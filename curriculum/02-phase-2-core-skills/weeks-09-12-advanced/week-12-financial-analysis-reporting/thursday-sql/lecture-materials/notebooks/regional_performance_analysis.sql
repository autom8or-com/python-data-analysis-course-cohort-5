-- Week 12: Financial Analysis and Reporting
-- SQL Exercise Notebook: Regional Performance Analysis
--
-- This file contains structured queries for analyzing regional performance
-- with statistical validation and business intelligence insights

-- ================================================================================
-- EXERCISE 1: BASIC REGIONAL STATISTICS
-- ================================================================================

-- Question 1: Calculate basic payment statistics for the top 5 Nigerian states
-- Include: total transactions, total revenue, average order value, standard deviation

SELECT
    c.customer_state,
    COUNT(*) as total_transactions,
    SUM(p.payment_value) as total_revenue,
    AVG(p.payment_value) as avg_order_value,
    STDDEV(p.payment_value) as revenue_stddev,
    -- Calculate coefficient of variation
    ROUND((STDDEV(p.payment_value) / AVG(p.payment_value)) * 100, 2) as cv_percentage,
    COUNT(DISTINCT c.customer_id) as unique_customers
FROM olist_sales_data_set.olist_customers_dataset c
JOIN olist_sales_data_set.olist_orders_dataset o ON c.customer_id = o.customer_id
JOIN olist_sales_data_set.olist_order_payments_dataset p ON o.order_id = p.order_id
WHERE o.order_status = 'delivered'
    AND c.customer_state IN ('SP', 'RJ', 'MG', 'BA', 'RS')
GROUP BY c.customer_state
ORDER BY total_revenue DESC;

-- ================================================================================
-- EXERCISE 2: PERCENTILE ANALYSIS
-- ================================================================================

-- Question 2: Analyze payment distribution by payment type using percentiles
-- Include 25th, 50th (median), 75th, and 95th percentiles

SELECT
    p.payment_type,
    COUNT(*) as transaction_count,
    SUM(p.payment_value) as total_revenue,
    AVG(p.payment_value) as avg_order_value,
    -- Percentile analysis
    ROUND(PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY p.payment_value), 2) as p25_order_value,
    ROUND(PERCENTILE_CONT(0.50) WITHIN GROUP (ORDER BY p.payment_value), 2) as median_order_value,
    ROUND(PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY p.payment_value), 2) as p75_order_value,
    ROUND(PERCENTILE_CONT(0.95) WITHIN GROUP (ORDER BY p.payment_value), 2) as p95_order_value,
    -- Interquartile range
    ROUND(PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY p.payment_value) -
          PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY p.payment_value), 2) as iqr,
    -- Payment characteristics
    AVG(p.payment_installments) as avg_installments
FROM olist_sales_data_set.olist_orders_dataset o
JOIN olist_sales_data_set.olist_order_payments_dataset p ON o.order_id = p.order_id
WHERE o.order_status = 'delivered'
GROUP BY p.payment_type
ORDER BY total_revenue DESC;

-- ================================================================================
-- EXERCISE 3: ADVANCED WINDOW FUNCTIONS
-- ================================================================================

-- Question 3: Create a customer performance ranking within each state
-- Show top 10 customers by total spending in each state

WITH customer_performance AS (
    SELECT
        c.customer_id,
        c.customer_state,
        c.customer_city,
        COUNT(o.order_id) as total_orders,
        SUM(p.payment_value) as total_spent,
        AVG(p.payment_value) as avg_order_value,
        -- Rank customers within their state
        RANK() OVER (PARTITION BY c.customer_state ORDER BY SUM(p.payment_value) DESC) as state_rank,
        -- Calculate percentile within state
        PERCENTILE_RANK() OVER (PARTITION BY c.customer_state ORDER BY SUM(p.payment_value)) as state_percentile,
        -- Overall customer percentile
        PERCENTILE_RANK() OVER (ORDER BY SUM(p.payment_value)) as overall_percentile
    FROM olist_sales_data_set.olist_customers_dataset c
    JOIN olist_sales_data_set.olist_orders_dataset o ON c.customer_id = o.customer_id
    JOIN olist_sales_data_set.olist_order_payments_dataset p ON o.order_id = p.order_id
    WHERE o.order_status = 'delivered'
        AND c.customer_state IN ('SP', 'RJ', 'MG', 'BA', 'RS')
    GROUP BY c.customer_id, c.customer_state, c.customer_city
)
SELECT
    customer_id,
    customer_state,
    customer_city,
    total_orders,
    total_spent,
    avg_order_value,
    state_rank,
    ROUND(state_percentile * 100, 2) as state_percentile_pct,
    ROUND(overall_percentile * 100, 2) as overall_percentile_pct,
    -- Customer segment based on performance
    CASE
        WHEN state_percentile >= 0.90 THEN 'Elite Customer'
        WHEN state_percentile >= 0.75 THEN 'Premium Customer'
        WHEN state_percentile >= 0.50 THEN 'Standard Customer'
        ELSE 'Developing Customer'
    END as customer_segment
FROM customer_performance
WHERE state_rank <= 10  -- Top 10 customers per state
ORDER BY customer_state, state_rank;

-- ================================================================================
-- EXERCISE 4: COHORT RETENTION ANALYSIS
-- ================================================================================

-- Question 4: Calculate customer cohort retention rates by state
-- Group customers by their first purchase month and track retention over time

WITH customer_cohorts AS (
    -- Identify customer cohorts and their activity over time
    SELECT
        c.customer_id,
        c.customer_state,
        DATE_TRUNC('month', o.order_purchase_timestamp) as order_month,
        DATE_TRUNC('month', MIN(o.order_purchase_timestamp) OVER (PARTITION BY c.customer_id)) as cohort_month,
        -- Calculate cohort age in months
        EXTRACT(YEAR FROM AGE(DATE_TRUNC('month', o.order_purchase_timestamp),
                              DATE_TRUNC('month', MIN(o.order_purchase_timestamp) OVER (PARTITION BY c.customer_id)))) * 12 +
        EXTRACT(MONTH FROM AGE(DATE_TRUNC('month', o.order_purchase_timestamp),
                               DATE_TRUNC('month', MIN(o.order_purchase_timestamp) OVER (PARTITION BY c.customer_id)))) as cohort_age_months
    FROM olist_sales_data_set.olist_customers_dataset c
    JOIN olist_sales_data_set.olist_orders_dataset o ON c.customer_id = o.customer_id
    WHERE o.order_status = 'delivered'
        AND c.customer_state IN ('SP', 'RJ', 'MG')
),
cohort_analysis AS (
    -- Calculate cohort metrics
    SELECT
        TO_CHAR(cohort_month, 'YYYY-MM') as cohort_period,
        customer_state,
        cohort_age_months,
        COUNT(DISTINCT customer_id) as active_customers,
        -- Calculate cohort size
        FIRST_VALUE(COUNT(DISTINCT customer_id)) OVER (PARTITION BY customer_state, cohort_month ORDER BY cohort_age_months) as cohort_size
    FROM customer_cohorts
    GROUP BY cohort_month, customer_state, cohort_age_months
)
-- Final retention calculation
SELECT
    cohort_period,
    customer_state,
    cohort_age_months,
    cohort_size,
    active_customers,
    -- Retention rate calculation
    ROUND((active_customers::DECIMAL / cohort_size) * 100, 2) as retention_rate_pct,
    -- Performance classification
    CASE
        WHEN (active_customers::DECIMAL / cohort_size) >= 0.5 THEN 'Excellent Retention'
        WHEN (active_customers::DECIMAL / cohort_size) >= 0.3 THEN 'Good Retention'
        WHEN (active_customers::DECIMAL / cohort_size) >= 0.1 THEN 'Average Retention'
        ELSE 'Poor Retention'
    END as retention_performance
FROM cohort_analysis
WHERE cohort_age_months <= 12  -- First 12 months
ORDER BY customer_state, cohort_period, cohort_age_months;

-- ================================================================================
-- EXERCISE 5: STATISTICAL OUTLIER DETECTION
-- ================================================================================

-- Question 5: Identify statistical outliers in payment data using multiple methods
-- Use both Z-score and IQR methods for comprehensive analysis

WITH payment_statistics AS (
    -- Calculate baseline statistics
    SELECT
        AVG(p.payment_value) as baseline_avg,
        STDDEV(p.payment_value) as baseline_stddev,
        PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY p.payment_value) as q1,
        PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY p.payment_value) as q3
    FROM olist_sales_data_set.olist_orders_dataset o
    JOIN olist_sales_data_set.olist_order_payments_dataset p ON o.order_id = p.order_id
    WHERE o.order_status = 'delivered'
),
outlier_detection AS (
    -- Detect outliers using multiple methods
    SELECT
        o.order_id,
        c.customer_id,
        c.customer_state,
        c.customer_city,
        p.payment_value,
        p.payment_type,
        o.order_purchase_timestamp,
        -- Z-score calculation
        ROUND((p.payment_value - ps.baseline_avg) / ps.baseline_stddev, 2) as z_score,
        -- IQR outlier detection
        CASE
            WHEN p.payment_value < (ps.q1 - 1.5 * (ps.q3 - ps.q1)) THEN 'Low Outlier'
            WHEN p.payment_value > (ps.q3 + 1.5 * (ps.q3 - ps.q1)) THEN 'High Outlier'
            ELSE 'Normal'
        END as iqr_outlier_status,
        -- Deviation from mean
        ROUND(p.payment_value / ps.baseline_avg, 2) as avg_multiple
    FROM olist_sales_data_set.olist_orders_dataset o
    JOIN olist_sales_data_set.olist_order_payments_dataset p ON o.order_id = p.order_id
    JOIN olist_sales_data_set.olist_customers_dataset c ON o.customer_id = c.customer_id
    CROSS JOIN payment_statistics ps
    WHERE o.order_status = 'delivered'
        AND c.customer_state IN ('SP', 'RJ', 'MG')
)
-- Identify significant outliers
SELECT
    order_id,
    customer_id,
    customer_state,
    customer_city,
    payment_value,
    payment_type,
    TO_CHAR(order_purchase_timestamp, 'YYYY-MM-DD') as order_date,
    z_score,
    iqr_outlier_status,
    avg_multiple,
    -- Risk assessment
    CASE
        WHEN ABS(z_score) > 4 THEN 'Critical Risk'
        WHEN ABS(z_score) > 3 THEN 'High Risk'
        WHEN iqr_outlier_status != 'Normal' THEN 'Medium Risk'
        ELSE 'Low Risk'
    END as risk_level,
    -- Recommended action
    CASE
        WHEN ABS(z_score) > 4 THEN 'Immediate investigation required'
        WHEN ABS(z_score) > 3 AND avg_multiple > 5 THEN 'Verify transaction legitimacy'
        WHEN iqr_outlier_status = 'High Outlier' THEN 'Review for potential fraud'
        WHEN iqr_outlier_status = 'Low Outlier' THEN 'Check for data entry errors'
        ELSE 'No action needed'
    END as recommended_action
FROM outlier_detection
WHERE ABS(z_score) > 3 OR iqr_outlier_status != 'Normal'
ORDER BY ABS(z_score) DESC, payment_value DESC
LIMIT 20;

-- ================================================================================
-- EXERCISE 6: BUSINESS INTELLIGENCE DASHBOARD
-- ================================================================================

-- Question 6: Create a comprehensive regional performance dashboard
-- Include performance metrics, benchmarks, and recommendations

WITH regional_benchmarks AS (
    -- Calculate national benchmarks
    SELECT
        AVG(p.payment_value) as national_avg_order,
        STDDEV(p.payment_value) as national_stddev,
        PERCENTILE_CONT(0.50) WITHIN GROUP (ORDER BY p.payment_value) as national_median,
        COUNT(*) as total_transactions,
        SUM(p.payment_value) as total_national_revenue
    FROM olist_sales_data_set.olist_orders_dataset o
    JOIN olist_sales_data_set.olist_order_payments_dataset p ON o.order_id = p.order_id
    WHERE o.order_status = 'delivered'
),
regional_metrics AS (
    -- Calculate regional metrics
    SELECT
        c.customer_state,
        COUNT(*) as state_transactions,
        SUM(p.payment_value) as state_revenue,
        AVG(p.payment_value) as state_avg_order,
        STDDEV(p.payment_value) as state_stddev,
        COUNT(DISTINCT c.customer_id) as unique_customers,
        -- Average order value by payment type
        AVG(CASE WHEN p.payment_type = 'credit_card' THEN p.payment_value END) as avg_credit_card,
        AVG(CASE WHEN p.payment_type = 'boleto' THEN p.payment_value END) as avg_boleto,
        AVG(CASE WHEN p.payment_type = 'debit_card' THEN p.payment_value END) as avg_debit_card
    FROM olist_sales_data_set.olist_customers_dataset c
    JOIN olist_sales_data_set.olist_orders_dataset o ON c.customer_id = o.customer_id
    JOIN olist_sales_data_set.olist_order_payments_dataset p ON o.order_id = p.order_id
    WHERE o.order_status = 'delivered'
        AND c.customer_state IN ('SP', 'RJ', 'MG', 'BA', 'RS')
    GROUP BY c.customer_state
)
-- Final dashboard query
SELECT
    rm.customer_state,
    rm.state_transactions,
    rm.state_revenue,
    rm.state_avg_order,
    rm.state_stddev,
    rm.unique_customers,
    -- National comparison
    rb.national_avg_order,
    ROUND((rm.state_avg_order - rb.national_avg_order) / rb.national_avg_order * 100, 2) as performance_vs_national_pct,
    -- Market share
    ROUND((rm.state_revenue / rb.total_national_revenue) * 100, 2) as revenue_market_share_pct,
    ROUND((rm.state_transactions / rb.total_transactions) * 100, 2) as transaction_market_share_pct,
    -- Statistical significance
    ROUND(ABS(rm.state_avg_order - rb.national_avg_order) / (rm.state_stddev / SQRT(rm.state_transactions)), 2) as z_statistic,
    -- Payment method preferences
    ROUND(rm.avg_credit_card, 2) as credit_card_avg,
    ROUND(rm.avg_boleto, 2) as boleto_avg,
    ROUND(rm.avg_debit_card, 2) as debit_card_avg,
    -- Performance classification
    CASE
        WHEN (rm.state_avg_order - rb.national_avg_order) / rb.national_avg_order > 0.1 THEN 'Outperforming'
        WHEN (rm.state_avg_order - rb.national_avg_order) / rb.national_avg_order < -0.1 THEN 'Underperforming'
        ELSE 'Performing as Expected'
    END as performance_status,
    -- Risk assessment
    CASE
        WHEN rm.state_stddev / rm.state_avg_order > 0.8 THEN 'High Variability'
        WHEN rm.state_stddev / rm.state_avg_order > 0.5 THEN 'Medium Variability'
        ELSE 'Low Variability'
    END as variability_level,
    -- Strategic recommendations
    CASE
        WHEN (rm.state_avg_order - rb.national_avg_order) / rb.national_avg_order > 0.1
             AND rm.state_stddev / rm.state_avg_order < 0.5
        THEN 'Maintain current strategy, focus on volume growth'
        WHEN (rm.state_avg_order - rb.national_avg_order) / rb.national_avg_order < -0.1
             AND rm.state_stddev / rm.state_avg_order > 0.5
        THEN 'Review pricing strategy, improve customer segmentation'
        WHEN rm.state_revenue / rb.total_national_revenue > 0.2
        THEN 'Focus on customer retention and upselling'
        ELSE 'Develop market-specific growth strategies'
    END as strategic_recommendation
FROM regional_metrics rm
CROSS JOIN regional_benchmarks rb
ORDER BY rm.state_revenue DESC;