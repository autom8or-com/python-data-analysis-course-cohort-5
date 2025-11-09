-- Week 12: Financial Analysis and Reporting
-- SQL Session 1: Statistical Functions in SQL
--
-- Learning Objectives:
-- - Master statistical functions in SQL (STDDEV, VARIANCE, percentiles)
-- - Perform advanced analytical calculations
-- - Create sophisticated business metrics and KPIs
-- - Apply statistical analysis to Nigerian e-commerce data

-- ================================================================================
-- 1. BASIC STATISTICAL FUNCTIONS
-- ================================================================================

-- Overview of Payment Value Statistics
-- Calculate comprehensive statistical measures for financial analysis

SELECT
    COUNT(*) as total_transactions,
    SUM(payment_value) as total_revenue,
    AVG(payment_value) as avg_order_value,
    MIN(payment_value) as min_order_value,
    MAX(payment_value) as max_order_value,
    STDDEV(payment_value) as revenue_stddev,
    VARIANCE(payment_value) as revenue_variance,
    -- Calculate coefficient of variation for risk assessment
    (STDDEV(payment_value) / AVG(payment_value)) * 100 as coefficient_of_variation_pct
FROM olist_sales_data_set.olist_order_payments_dataset;

-- Regional Statistical Analysis
-- Analyze payment patterns across different Nigerian states

SELECT
    c.customer_state,
    COUNT(*) as total_transactions,
    SUM(p.payment_value) as total_revenue,
    AVG(p.payment_value) as avg_order_value,
    STDDEV(p.payment_value) as revenue_stddev,
    VARIANCE(p.payment_value) as revenue_variance,
    -- Business risk assessment
    (STDDEV(p.payment_value) / AVG(p.payment_value)) * 100 as cv_pct,
    -- Calculate number of unique customers
    COUNT(DISTINCT c.customer_id) as unique_customers,
    -- Calculate revenue per customer
    SUM(p.payment_value) / COUNT(DISTINCT c.customer_id) as revenue_per_customer
FROM olist_sales_data_set.olist_customers_dataset c
JOIN olist_sales_data_set.olist_orders_dataset o ON c.customer_id = o.customer_id
JOIN olist_sales_data_set.olist_order_payments_dataset p ON o.order_id = p.order_id
WHERE o.order_status = 'delivered'
    AND c.customer_state IN ('SP', 'RJ', 'MG', 'BA', 'RS', 'PR', 'SC', 'GO', 'DF', 'PE')
GROUP BY c.customer_state
ORDER BY total_revenue DESC;

-- ================================================================================
-- 2. PERCENTILE ANALYSIS
-- ================================================================================

-- Payment Value Percentiles by State
-- Understand the distribution of order values in each region

SELECT
    c.customer_state,
    COUNT(*) as transaction_count,
    -- Basic statistics
    AVG(p.payment_value) as avg_order_value,
    MIN(p.payment_value) as min_order_value,
    MAX(p.payment_value) as max_order_value,
    -- Percentiles for distribution analysis
    PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY p.payment_value) as p25_order_value,
    PERCENTILE_CONT(0.50) WITHIN GROUP (ORDER BY p.payment_value) as median_order_value,
    PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY p.payment_value) as p75_order_value,
    PERCENTILE_CONT(0.90) WITHIN GROUP (ORDER BY p.payment_value) as p90_order_value,
    PERCENTILE_CONT(0.95) WITHIN GROUP (ORDER BY p.payment_value) as p95_order_value,
    -- Interquartile range for outlier detection
    PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY p.payment_value) -
    PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY p.payment_value) as iqr
FROM olist_sales_data_set.olist_customers_dataset c
JOIN olist_sales_data_set.olist_orders_dataset o ON c.customer_id = o.customer_id
JOIN olist_sales_data_set.olist_order_payments_dataset p ON o.order_id = p.order_id
WHERE o.order_status = 'delivered'
    AND c.customer_state IN ('SP', 'RJ', 'MG', 'BA', 'RS')
GROUP BY c.customer_state
ORDER BY avg_order_value DESC;

-- Payment Type Performance with Percentiles
-- Analyze different payment methods and their performance patterns

SELECT
    p.payment_type,
    COUNT(*) as transaction_count,
    SUM(p.payment_value) as total_revenue,
    AVG(p.payment_value) as avg_order_value,
    STDDEV(p.payment_value) as revenue_stddev,
    -- Percentile analysis for each payment type
    PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY p.payment_value) as p25_value,
    PERCENTILE_CONT(0.50) WITHIN GROUP (ORDER BY p.payment_value) as median_value,
    PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY p.payment_value) as p75_value,
    -- Market penetration analysis
    COUNT(DISTINCT c.customer_id) as unique_customers,
    -- Average number of installments (for payment types that support it)
    AVG(p.payment_installments) as avg_installments
FROM olist_sales_data_set.olist_customers_dataset c
JOIN olist_sales_data_set.olist_orders_dataset o ON c.customer_id = o.customer_id
JOIN olist_sales_data_set.olist_order_payments_dataset p ON o.order_id = p.order_id
WHERE o.order_status = 'delivered'
GROUP BY p.payment_type
ORDER BY total_revenue DESC;

-- ================================================================================
-- 3. ADVANCED WINDOW FUNCTIONS FOR STATISTICAL ANALYSIS
-- ================================================================================

-- Customer Purchase Behavior Analysis with Window Functions
-- Analyze individual customer spending patterns relative to population

WITH customer_stats AS (
    SELECT
        c.customer_id,
        c.customer_state,
        c.customer_city,
        COUNT(o.order_id) as total_orders,
        SUM(p.payment_value) as total_spent,
        AVG(p.payment_value) as avg_order_value,
        -- Calculate customer statistics relative to all customers
        PERCENTILE_RANK() OVER (ORDER BY SUM(p.payment_value)) as revenue_percentile,
        PERCENTILE_RANK() OVER (ORDER BY AVG(p.payment_value)) as avg_order_percentile,
        -- Customer ranking within their state
        RANK() OVER (PARTITION BY c.customer_state ORDER BY SUM(p.payment_value) DESC) as state_revenue_rank,
        -- First and last order analysis
        MIN(o.order_purchase_timestamp) as first_order_date,
        MAX(o.order_purchase_timestamp) as last_order_date,
        -- Customer lifetime analysis
        MAX(o.order_purchase_timestamp) - MIN(o.order_purchase_timestamp) as customer_lifetime_days
    FROM olist_sales_data_set.olist_customers_dataset c
    JOIN olist_sales_data_set.olist_orders_dataset o ON c.customer_id = o.customer_id
    JOIN olist_sales_data_set.olist_order_payments_dataset p ON o.order_id = p.order_id
    WHERE o.order_status = 'delivered'
    GROUP BY c.customer_id, c.customer_state, c.customer_city
    HAVING COUNT(o.order_id) >= 2  -- Only customers with 2+ orders
)
SELECT
    customer_id,
    customer_state,
    customer_city,
    total_orders,
    total_spent,
    avg_order_value,
    revenue_percentile,
    avg_order_percentile,
    state_revenue_rank,
    customer_lifetime_days,
    -- Customer segmentation based on behavior
    CASE
        WHEN revenue_percentile >= 0.90 THEN 'Platinum'
        WHEN revenue_percentile >= 0.75 THEN 'Gold'
        WHEN revenue_percentile >= 0.50 THEN 'Silver'
        WHEN revenue_percentile >= 0.25 THEN 'Bronze'
        ELSE 'Standard'
    END as customer_segment
FROM customer_stats
ORDER BY total_spent DESC
LIMIT 50;

-- Monthly Revenue Trends with Statistical Analysis
-- Analyze revenue patterns over time with statistical indicators

WITH monthly_stats AS (
    SELECT
        DATE_TRUNC('month', o.order_purchase_timestamp) as month,
        COUNT(o.order_id) as total_orders,
        SUM(p.payment_value) as total_revenue,
        AVG(p.payment_value) as avg_order_value,
        STDDEV(p.payment_value) as revenue_stddev,
        COUNT(DISTINCT c.customer_id) as unique_customers,
        -- Calculate month-over-month growth
        LAG(SUM(p.payment_value)) OVER (ORDER BY DATE_TRUNC('month', o.order_purchase_timestamp)) as prev_month_revenue
    FROM olist_sales_data_set.olist_orders_dataset o
    JOIN olist_sales_data_set.olist_order_payments_dataset p ON o.order_id = p.order_id
    JOIN olist_sales_data_set.olist_customers_dataset c ON o.customer_id = c.customer_id
    WHERE o.order_status = 'delivered'
        AND o.order_purchase_timestamp >= '2017-01-01'
    GROUP BY DATE_TRUNC('month', o.order_purchase_timestamp)
)
SELECT
    TO_CHAR(month, 'YYYY-MM') as month_year,
    total_orders,
    total_revenue,
    avg_order_value,
    revenue_stddev,
    unique_customers,
    prev_month_revenue,
    -- Calculate growth metrics
    CASE
        WHEN prev_month_revenue > 0
        THEN ((total_revenue - prev_month_revenue) / prev_month_revenue) * 100
        ELSE NULL
    END as revenue_growth_pct,
    -- Revenue volatility assessment
    (revenue_stddev / avg_order_value) * 100 as volatility_index,
    -- Performance classification
    CASE
        WHEN total_revenue > 500000 THEN 'High Performance'
        WHEN total_revenue > 300000 THEN 'Medium Performance'
        ELSE 'Low Performance'
    END as performance_tier
FROM monthly_stats
ORDER BY month;

-- ================================================================================
-- 4. COHORT ANALYSIS WITH STATISTICAL METRICS
-- ================================================================================

-- Customer Cohort Retention Analysis with Statistical Measures
-- Track customer behavior over time with statistical validation

WITH customer_cohorts AS (
    -- Define customer cohorts based on first purchase month
    SELECT
        c.customer_id,
        DATE_TRUNC('month', o.order_purchase_timestamp) as order_month,
        DATE_TRUNC('month', MIN(o.order_purchase_timestamp) OVER (PARTITION BY c.customer_id)) as cohort_month,
        -- Calculate cohort age in months
        EXTRACT(YEAR FROM AGE(DATE_TRUNC('month', o.order_purchase_timestamp),
                              DATE_TRUNC('month', MIN(o.order_purchase_timestamp) OVER (PARTITION BY c.customer_id)))) * 12 +
        EXTRACT(MONTH FROM AGE(DATE_TRUNC('month', o.order_purchase_timestamp),
                               DATE_TRUNC('month', MIN(o.order_purchase_timestamp) OVER (PARTITION BY c.customer_id)))) as cohort_age_months,
        p.payment_value
    FROM olist_sales_data_set.olist_customers_dataset c
    JOIN olist_sales_data_set.olist_orders_dataset o ON c.customer_id = o.customer_id
    JOIN olist_sales_data_set.olist_order_payments_dataset p ON o.order_id = p.order_id
    WHERE o.order_status = 'delivered'
),
cohort_metrics AS (
    -- Calculate cohort metrics with statistical measures
    SELECT
        TO_CHAR(cohort_month, 'YYYY-MM') as cohort,
        cohort_age_months,
        COUNT(DISTINCT customer_id) as active_customers,
        SUM(payment_value) as cohort_revenue,
        AVG(payment_value) as avg_order_value,
        STDDEV(payment_value) as revenue_stddev,
        -- Calculate retention rate
        FIRST_VALUE(COUNT(DISTINCT customer_id)) OVER (PARTITION BY cohort_month ORDER BY cohort_age_months) as cohort_size,
        -- Calculate cumulative revenue
        SUM(payment_value) OVER (PARTITION BY cohort_month ORDER BY cohort_age_months) as cumulative_revenue
    FROM customer_cohorts
    GROUP BY cohort_month, cohort_age_months
)
SELECT
    cohort,
    cohort_age_months,
    active_customers,
    cohort_size,
    -- Retention rate calculation
    ROUND((active_customers::DECIMAL / cohort_size) * 100, 2) as retention_rate_pct,
    cohort_revenue,
    avg_order_value,
    revenue_stddev,
    cumulative_revenue,
    -- Customer lifetime value metrics
    ROUND(cumulative_revenue / cohort_size, 2) as clv_per_customer,
    -- Volatility assessment
    CASE
        WHEN revenue_stddev > avg_order_value THEN 'High Volatility'
        WHEN revenue_stddev > avg_order_value * 0.5 THEN 'Medium Volatility'
        ELSE 'Low Volatility'
    END as spending_volatility
FROM cohort_metrics
ORDER BY cohort, cohort_age_months;

-- ================================================================================
-- 5. ADVANCED BUSINESS INTELLIGENCE QUERIES
-- ================================================================================

-- Regional Performance Dashboard with Statistical Benchmarks
-- Comprehensive regional analysis with statistical validation

WITH regional_benchmarks AS (
    -- Calculate national benchmarks for comparison
    SELECT
        AVG(p.payment_value) as national_avg_order,
        STDDEV(p.payment_value) as national_stddev,
        PERCENTILE_CONT(0.50) WITHIN GROUP (ORDER BY p.payment_value) as national_median,
        PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY p.payment_value) as national_p75,
        COUNT(*) as total_transactions,
        SUM(p.payment_value) as total_revenue
    FROM olist_sales_data_set.olist_orders_dataset o
    JOIN olist_sales_data_set.olist_order_payments_dataset p ON o.order_id = p.order_id
    WHERE o.order_status = 'delivered'
)
SELECT
    c.customer_state,
    COUNT(*) as state_transactions,
    SUM(p.payment_value) as state_revenue,
    AVG(p.payment_value) as state_avg_order,
    STDDEV(p.payment_value) as state_stddev,
    -- National comparison metrics
    rb.national_avg_order,
    (AVG(p.payment_value) - rb.national_avg_order) / rb.national_avg_order * 100 as performance_vs_national_pct,
    -- Market share analysis
    (SUM(p.payment_value) / rb.total_revenue) * 100 as revenue_market_share_pct,
    (COUNT(*) / rb.total_transactions) * 100 as volume_market_share_pct,
    -- Statistical significance indicators
    ABS(AVG(p.payment_value) - rb.national_avg_order) / (STDDEV(p.payment_value) / SQRT(COUNT(*))) as z_score,
    -- Performance classification
    CASE
        WHEN (AVG(p.payment_value) - rb.national_avg_order) / rb.national_avg_order > 0.1 THEN 'Outperforming'
        WHEN (AVG(p.payment_value) - rb.national_avg_order) / rb.national_avg_order < -0.1 THEN 'Underperforming'
        ELSE 'Performing as Expected'
    END as performance_status,
    -- Risk assessment based on volatility
    CASE
        WHEN STDDEV(p.payment_value) / AVG(p.payment_value) > 0.8 THEN 'High Risk'
        WHEN STDDEV(p.payment_value) / AVG(p.payment_value) > 0.5 THEN 'Medium Risk'
        ELSE 'Low Risk'
    END as risk_level
FROM olist_sales_data_set.olist_customers_dataset c
JOIN olist_sales_data_set.olist_orders_dataset o ON c.customer_id = o.customer_id
JOIN olist_sales_data_set.olist_order_payments_dataset p ON o.order_id = p.order_id
CROSS JOIN regional_benchmarks rb
WHERE o.order_status = 'delivered'
    AND c.customer_state IN ('SP', 'RJ', 'MG', 'BA', 'RS', 'PR', 'SC', 'GO', 'DF', 'PE')
GROUP BY c.customer_state, rb.national_avg_order, rb.national_stddev, rb.national_median,
         rb.national_p75, rb.total_transactions, rb.total_revenue
ORDER BY state_revenue DESC;

-- Payment Method Performance Scorecard
-- Comprehensive analysis of payment methods with statistical validation

WITH payment_method_stats AS (
    SELECT
        p.payment_type,
        COUNT(*) as transaction_count,
        SUM(p.payment_value) as total_revenue,
        AVG(p.payment_value) as avg_order_value,
        STDDEV(p.payment_value) as revenue_stddev,
        AVG(p.payment_installments) as avg_installments,
        -- Calculate percentiles for distribution analysis
        PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY p.payment_value) as p25_value,
        PERCENTILE_CONT(0.50) WITHIN GROUP (ORDER BY p.payment_value) as median_value,
        PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY p.payment_value) as p75_value,
        -- Time-based analysis
        AVG(EXTRACT(EPOCH FROM (o.order_delivered_customer_date - o.order_purchase_timestamp)) / 86400) as avg_delivery_days
    FROM olist_sales_data_set.olist_orders_dataset o
    JOIN olist_sales_data_set.olist_order_payments_dataset p ON o.order_id = p.order_id
    WHERE o.order_status = 'delivered'
    GROUP BY p.payment_type
)
SELECT
    payment_type,
    transaction_count,
    total_revenue,
    avg_order_value,
    revenue_stddev,
    (revenue_stddev / avg_order_value) * 100 as cv_pct,
    avg_installments,
    p25_value,
    median_value,
    p75_value,
    (p75_value - p25_value) as iqr,
    avg_delivery_days,
    -- Payment method scorecard (0-100 scale)
    -- Revenue component (40% weight)
    CASE
        WHEN total_revenue > 1000000 THEN 40
        WHEN total_revenue > 500000 THEN 30
        WHEN total_revenue > 250000 THEN 20
        ELSE 10
    END as revenue_score,
    -- Stability component (30% weight) - lower CV is better
    CASE
        WHEN (revenue_stddev / avg_order_value) < 0.3 THEN 30
        WHEN (revenue_stddev / avg_order_value) < 0.5 THEN 20
        WHEN (revenue_stddev / avg_order_value) < 0.8 THEN 10
        ELSE 5
    END as stability_score,
    -- Usage component (30% weight)
    CASE
        WHEN transaction_count > 50000 THEN 30
        WHEN transaction_count > 25000 THEN 20
        WHEN transaction_count > 10000 THEN 10
        ELSE 5
    END as usage_score
FROM payment_method_stats
ORDER BY total_revenue DESC;

-- ================================================================================
-- 6. OUTLIER DETECTION WITH STATISTICAL METHODS
-- ================================================================================

-- Transaction Outlier Analysis using Statistical Methods
-- Identify unusual transactions that may require investigation

WITH order_statistics AS (
    -- Calculate baseline statistics for outlier detection
    SELECT
        AVG(p.payment_value) as baseline_avg,
        STDDEV(p.payment_value) as baseline_stddev,
        PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY p.payment_value) as q1,
        PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY p.payment_value) as q3
    FROM olist_sales_data_set.olist_orders_dataset o
    JOIN olist_sales_data_set.olist_order_payments_dataset p ON o.order_id = p.order_id
    WHERE o.order_status = 'delivered'
),
outlier_analysis AS (
    SELECT
        o.order_id,
        c.customer_id,
        c.customer_state,
        c.customer_city,
        p.payment_value,
        p.payment_type,
        o.order_purchase_timestamp,
        -- Z-score calculation
        (p.payment_value - os.baseline_avg) / os.baseline_stddev as z_score,
        -- IQR method calculation
        CASE
            WHEN p.payment_value < (os.q1 - 1.5 * (os.q3 - os.q1)) THEN 'Low Outlier'
            WHEN p.payment_value > (os.q3 + 1.5 * (os.q3 - os.q1)) THEN 'High Outlier'
            ELSE 'Normal'
        END as iqr_outlier_status,
        -- Multiple of baseline average
        p.payment_value / os.baseline_avg as avg_multiple
    FROM olist_sales_data_set.olist_orders_dataset o
    JOIN olist_sales_data_set.olist_order_payments_dataset p ON o.order_id = p.order_id
    JOIN olist_sales_data_set.olist_customers_dataset c ON o.customer_id = c.customer_id
    CROSS JOIN order_statistics os
    WHERE o.order_status = 'delivered'
)
-- Identify significant outliers (|z-score| > 3 or IQR outliers)
SELECT
    order_id,
    customer_id,
    customer_state,
    customer_city,
    payment_value,
    payment_type,
    order_purchase_timestamp,
    ROUND(z_score, 2) as z_score,
    iqr_outlier_status,
    ROUND(avg_multiple, 2) as avg_multiple,
    -- Risk classification
    CASE
        WHEN ABS(z_score) > 4 THEN 'Critical - Investigation Required'
        WHEN ABS(z_score) > 3 THEN 'High Priority - Review Recommended'
        WHEN iqr_outlier_status != 'Normal' THEN 'Medium Priority - Monitor'
        ELSE 'Normal Transaction'
    END as risk_level,
    -- Recommended action
    CASE
        WHEN ABS(z_score) > 4 THEN 'Immediate fraud investigation'
        WHEN ABS(z_score) > 3 AND payment_value > 1000 THEN 'Verify customer identity'
        WHEN iqr_outlier_status = 'High Outlier' THEN 'Review for pricing errors'
        WHEN iqr_outlier_status = 'Low Outlier' THEN 'Check for system errors'
        ELSE 'No action needed'
    END as recommended_action
FROM outlier_analysis
WHERE ABS(z_score) > 3 OR iqr_outlier_status != 'Normal'
ORDER BY ABS(z_score) DESC, payment_value DESC
LIMIT 50;

-- ================================================================================
-- SUMMARY STATISTICS FOR EXECUTIVE REPORTING
-- ================================================================================

-- Executive Financial Performance Summary
-- High-level KPI dashboard with statistical validation

SELECT
    -- Revenue Metrics
    'Total Revenue' as metric,
    SUM(p.payment_value) as value,
    '₦' || ROUND(SUM(p.payment_value)::NUMERIC, 0) as formatted_value,
    NULL as benchmark,
    NULL as performance
FROM olist_sales_data_set.olist_orders_dataset o
JOIN olist_sales_data_set.olist_order_payments_dataset p ON o.order_id = p.order_id
WHERE o.order_status = 'delivered'

UNION ALL

SELECT
    'Average Order Value' as metric,
    AVG(p.payment_value) as value,
    '₦' || ROUND(AVG(p.payment_value)::NUMERIC, 2) as formatted_value,
    NULL as benchmark,
    NULL as performance
FROM olist_sales_data_set.olist_orders_dataset o
JOIN olist_sales_data_set.olist_order_payments_dataset p ON o.order_id = p.order_id
WHERE o.order_status = 'delivered'

UNION ALL

SELECT
    'Total Customers' as metric,
    COUNT(DISTINCT c.customer_id)::NUMERIC as value,
    COUNT(DISTINCT c.customer_id)::TEXT as formatted_value,
    NULL as benchmark,
    NULL as performance
FROM olist_sales_data_set.olist_orders_dataset o
JOIN olist_sales_data_set.olist_customers_dataset c ON o.customer_id = c.customer_id
WHERE o.order_status = 'delivered'

UNION ALL

SELECT
    'Revenue Volatility (CV %)' as metric,
    (STDDEV(p.payment_value) / AVG(p.payment_value) * 100) as value,
    ROUND((STDDEV(p.payment_value) / AVG(p.payment_value) * 100)::NUMERIC, 1) || '%' as formatted_value,
    50 as benchmark,
    CASE
        WHEN (STDDEV(p.payment_value) / AVG(p.payment_value) * 100) <= 50 THEN 'Low Risk'
        WHEN (STDDEV(p.payment_value) / AVG(p.payment_value) * 100) <= 75 THEN 'Medium Risk'
        ELSE 'High Risk'
    END as performance
FROM olist_sales_data_set.olist_orders_dataset o
JOIN olist_sales_data_set.olist_order_payments_dataset p ON o.order_id = p.order_id
WHERE o.order_status = 'delivered'

ORDER BY metric;