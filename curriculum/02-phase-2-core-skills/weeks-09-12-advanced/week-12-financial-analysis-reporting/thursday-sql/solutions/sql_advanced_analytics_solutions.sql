-- Week 12: SQL Advanced Analytics - Complete Solutions
-- Advanced Statistical Functions for Business Intelligence
-- Nigerian E-commerce Financial Analysis
--
-- This file contains comprehensive solutions to all exercises with detailed explanations
-- and alternative approaches for real-world business applications.

-- ================================================================================
-- SOLUTION 1: BASIC STATISTICAL FUNCTIONS
-- ================================================================================

-- Solution 1.1: Comprehensive payment statistics by Nigerian state
-- Calculate total revenue, average order value, standard deviation, and coefficient of variation
WITH state_payment_stats AS (
    SELECT
        c.customer_state,
        COUNT(o.order_id) as total_orders,
        SUM(p.payment_value) as total_revenue,
        AVG(p.payment_value) as avg_order_value,
        STDDEV(p.payment_value) as revenue_stddev,
        VARIANCE(p.payment_value) as revenue_variance,
        MIN(p.payment_value) as min_order_value,
        MAX(p.payment_value) as max_order_value,
        PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY p.payment_value) as q1,
        PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY p.payment_value) as median_order_value,
        PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY p.payment_value) as q3,
        PERCENTILE_CONT(0.9) WITHIN GROUP (ORDER BY p.payment_value) as p90,
        PERCENTILE_CONT(0.95) WITHIN GROUP (ORDER BY p.payment_value) as p95,
        PERCENTILE_CONT(0.99) WITHIN GROUP (ORDER BY p.payment_value) as p99
    FROM olist_sales_data_set.olist_orders_dataset o
    JOIN olist_sales_data_set.olist_order_payments_dataset p ON o.order_id = p.order_id
    JOIN olist_sales_data_set.olist_customers_dataset c ON o.customer_id = c.customer_id
    WHERE o.order_status = 'delivered'
    GROUP BY c.customer_state
)
SELECT
    customer_state,
    total_orders,
    total_revenue,
    avg_order_value,
    revenue_stddev,
    revenue_variance,
    min_order_value,
    max_order_value,
    median_order_value,
    q1,
    q3,
    (q3 - q1) as iqr,
    p90,
    p95,
    p99,
    -- Coefficient of variation (relative risk)
    ROUND((revenue_stddev / NULLIF(avg_order_value, 0)) * 100, 2) as cv_percentage,
    -- Revenue concentration (Gini coefficient approximation)
    ROUND(
        (SUM(ABS(avg_order_value - LAG(avg_order_value) OVER (ORDER BY avg_order_value))) OVER ()) /
        (2 * COUNT(*) * avg_order_value), 4
    ) as revenue_concentration_index
FROM state_payment_stats
WHERE total_orders >= 10  -- Filter states with sufficient data
ORDER BY total_revenue DESC;

-- Alternative approach for coefficient of variation using window functions
SELECT
    customer_state,
    total_revenue,
    avg_order_value,
    revenue_stddev,
    revenue_stddev / avg_order_value as coefficient_of_variation,
    -- National comparison
    avg_order_value / AVG(avg_order_value) OVER () as performance_vs_national_avg,
    revenue_stddev / AVG(revenue_stddev) OVER () as volatility_vs_national_avg
FROM (
    SELECT
        c.customer_state,
        SUM(p.payment_value) as total_revenue,
        AVG(p.payment_value) as avg_order_value,
        STDDEV(p.payment_value) as revenue_stddev
    FROM olist_sales_data_set.olist_orders_dataset o
    JOIN olist_sales_data_set.olist_order_payments_dataset p ON o.order_id = p.order_id
    JOIN olist_sales_data_set.olist_customers_dataset c ON o.customer_id = c.customer_id
    WHERE o.order_status = 'delivered'
    GROUP BY c.customer_state
) state_stats
WHERE total_revenue > 0
ORDER BY total_revenue DESC;

-- Solution 1.2: Payment method performance analysis with statistical measures
WITH payment_method_analysis AS (
    SELECT
        p.payment_type,
        COUNT(DISTINCT o.order_id) as transaction_count,
        SUM(p.payment_value) as total_revenue,
        AVG(p.payment_value) as avg_transaction_value,
        STDDEV(p.payment_value) as revenue_stddev,
        VARIANCE(p.payment_value) as revenue_variance,
        -- Percentile analysis
        PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY p.payment_value) as q1,
        PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY p.payment_value) as median_value,
        PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY p.payment_value) as q3,
        PERCENTILE_CONT(0.90) WITHIN GROUP (ORDER BY p.payment_value) as p90,
        PERCENTILE_CONT(0.95) WITHIN GROUP (ORDER BY p.payment_value) as p95,
        -- Advanced metrics
        MIN(p.payment_value) as min_transaction,
        MAX(p.payment_value) as max_transaction,
        -- Statistical confidence intervals (95% CI)
        AVG(p.payment_value) - 1.96 * (STDDEV(p.payment_value) / SQRT(COUNT(o.order_id))) as lower_95_ci,
        AVG(p.payment_value) + 1.96 * (STDDEV(p.payment_value) / SQRT(COUNT(o.order_id))) as upper_95_ci,
        -- Outlier boundaries
        Q1 - 1.5 * (Q3 - Q1) as lower_outlier_bound,
        Q3 + 1.5 * (Q3 - Q1) as upper_outlier_bound
    FROM olist_sales_data_set.olist_orders_dataset o
    JOIN olist_sales_data_set.olist_order_payments_dataset p ON o.order_id = p.order_id
    WHERE o.order_status = 'delivered'
    GROUP BY p.payment_type
),
outlier_counts AS (
    SELECT
        p.payment_type,
        COUNT(*) as outlier_count
    FROM olist_sales_data_set.olist_orders_dataset o
    JOIN olist_sales_data_set.olist_order_payments_dataset p ON o.order_id = p.order_id
    JOIN payment_method_analysis pm ON p.payment_type = pm.payment_type
    WHERE o.order_status = 'delivered'
    AND (p.payment_value < pm.lower_outlier_bound OR p.payment_value > pm.upper_outlier_bound)
    GROUP BY p.payment_type
)
SELECT
    pma.payment_type,
    pma.transaction_count,
    pma.total_revenue,
    ROUND(pma.avg_transaction_value, 2) as avg_transaction_value,
    ROUND(pma.revenue_stddev, 2) as revenue_stddev,
    ROUND(pma.revenue_variance, 2) as revenue_variance,
    ROUND(pma.median_value, 2) as median_value,
    ROUND(pma.q1, 2) as q1,
    ROUND(pma.q3, 2) as q3,
    ROUND(pma.p90, 2) as p90,
    ROUND(pma.p95, 2) as p95,
    ROUND(pma.min_transaction, 2) as min_transaction,
    ROUND(pma.max_transaction, 2) as max_transaction,
    ROUND(pma.lower_95_ci, 2) as lower_95_ci,
    ROUND(pma.upper_95_ci, 2) as upper_95_ci,
    COALESCE(oc.outlier_count, 0) as outlier_count,
    ROUND((COALESCE(oc.outlier_count, 0)::DECIMAL / pma.transaction_count) * 100, 2) as outlier_percentage,
    -- Business insights
    ROUND(pma.total_revenue / NULLIF(pma.transaction_count, 0), 2) as revenue_per_transaction,
    ROUND((pma.revenue_stddev / NULLIF(pma.avg_transaction_value, 0)) * 100, 2) as cv_percentage,
    -- Market share
    ROUND(pma.total_revenue * 100.0 / SUM(pma.total_revenue) OVER (), 2) as market_share_percentage
FROM payment_method_analysis pma
LEFT JOIN outlier_counts oc ON pma.payment_type = oc.payment_type
ORDER BY pma.total_revenue DESC;

-- ================================================================================
-- SOLUTION 2: ADVANCED WINDOW FUNCTIONS
-- ================================================================================

-- Solution 2.1: Regional performance rankings with statistical measures
WITH regional_metrics AS (
    SELECT
        c.customer_state,
        c.customer_city,
        -- Base metrics
        COUNT(DISTINCT o.order_id) as total_orders,
        SUM(p.payment_value) as total_revenue,
        AVG(p.payment_value) as avg_order_value,
        STDDEV(p.payment_value) as revenue_stddev,
        -- Ranking functions
        RANK() OVER (ORDER BY SUM(p.payment_value) DESC) as revenue_rank,
        RANK() OVER (ORDER BY AVG(p.payment_value) DESC) as avg_value_rank,
        RANK() OVER (ORDER BY COUNT(DISTINCT o.order_id) DESC) as volume_rank,
        DENSE_RANK() OVER (ORDER BY SUM(p.payment_value) DESC) as dense_revenue_rank,
        NTILE(4) OVER (ORDER BY SUM(p.payment_value) DESC) as revenue_quartile,
        NTILE(5) OVER (ORDER BY AVG(p.payment_value) DESC) as avg_value_quintile,
        -- Percentile rankings
        PERCENT_RANK() OVER (ORDER BY SUM(p.payment_value)) as revenue_percent_rank,
        PERCENT_RANK() OVER (ORDER BY AVG(p.payment_value)) as avg_value_percent_rank,
        CUME_DIST() OVER (ORDER BY SUM(p.payment_value)) as revenue_cumulative_dist,
        -- Lead/Lag for trend analysis
        LAG(SUM(p.payment_value), 1) OVER (ORDER BY SUM(p.payment_value) DESC) as prev_state_revenue,
        LEAD(SUM(p.payment_value), 1) OVER (ORDER BY SUM(p.payment_value) DESC) as next_state_revenue,
        LAG(AVG(p.payment_value), 1) OVER (ORDER BY AVG(p.payment_value) DESC) as prev_state_avg_value,
        LEAD(AVG(p.payment_value), 1) OVER (ORDER BY AVG(p.payment_value) DESC) as next_state_avg_value,
        -- Distribution analysis
        ROW_NUMBER() OVER (ORDER BY SUM(p.payment_value) DESC) as revenue_row_num,
        FIRST_VALUE(SUM(p.payment_value)) OVER (ORDER BY SUM(p.payment_value) DESC) as max_state_revenue,
        LAST_VALUE(SUM(p.payment_value)) OVER (ORDER BY SUM(p.payment_value) DESC
            RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) as min_state_revenue
    FROM olist_sales_data_set.olist_orders_dataset o
    JOIN olist_sales_data_set.olist_order_payments_dataset p ON o.order_id = p.order_id
    JOIN olist_sales_data_set.olist_customers_dataset c ON o.customer_id = c.customer_id
    WHERE o.order_status = 'delivered'
    GROUP BY c.customer_state, c.customer_city
),
state_aggregates AS (
    SELECT
        customer_state,
        -- Aggregated city-level metrics
        SUM(total_orders) as state_total_orders,
        SUM(total_revenue) as state_total_revenue,
        AVG(avg_order_value) as state_avg_order_value,
        AVG(revenue_stddev) as state_avg_stddev,
        -- Top performing city
        MAX(CASE WHEN revenue_rank = 1 THEN customer_city END) as top_city,
        MAX(CASE WHEN avg_value_rank = 1 THEN customer_city END) as highest_avg_city,
        -- Number of cities analyzed
        COUNT(DISTINCT customer_city) as cities_analyzed
    FROM regional_metrics
    GROUP BY customer_state
)
SELECT
    rm.customer_state,
    rm.customer_city,
    rm.total_orders,
    rm.state_total_orders,
    rm.total_revenue,
    rm.state_total_revenue,
    rm.avg_order_value,
    rm.state_avg_order_value,
    rm.revenue_stddev,
    rm.state_avg_stddev,
    rm.revenue_rank,
    rm.avg_value_rank,
    rm.volume_rank,
    rm.revenue_quartile,
    rm.avg_value_quintile,
    ROUND(rm.revenue_percent_rank * 100, 1) as revenue_percentile,
    ROUND(rm.avg_value_percent_rank * 100, 1) as avg_value_percentile,
    ROUND(rm.revenue_cumulative_dist * 100, 1) as revenue_cumulative_percentile,
    -- Performance vs top performer
    ROUND(rm.total_revenue * 100.0 / NULLIF(rm.max_state_revenue, 0), 2) as performance_vs_top_pct,
    -- Gap analysis
    ROUND(rm.total_revenue - NULLIF(rm.prev_state_revenue, 0), 2) as revenue_gap_above_previous,
    ROUND(NULLIF(rm.next_state_revenue, 0) - rm.total_revenue, 2) as revenue_gap_to_next,
    -- Coefficient of variation at state level
    ROUND((rm.revenue_stddev / NULLIF(rm.avg_order_value, 0)) * 100, 2) as city_cv_percentage,
    -- Market concentration
    ROUND(rm.total_revenue * 100.0 / NULLIF(rm.state_total_revenue, 0), 2) as city_state_contribution_pct
FROM regional_metrics rm
JOIN state_aggregates sa ON rm.customer_state = sa.customer_state
WHERE rm.total_orders >= 5  -- Filter cities with sufficient data
ORDER BY rm.total_revenue DESC;

-- Solution 2.2: Time-based performance analysis with moving averages
WITH time_series_data AS (
    SELECT
        DATE_TRUNC('month', o.order_purchase_timestamp) as month_period,
        EXTRACT(YEAR FROM o.order_purchase_timestamp) as year_num,
        EXTRACT(MONTH FROM o.order_purchase_timestamp) as month_num,
        -- Monthly metrics
        COUNT(DISTINCT o.order_id) as monthly_orders,
        SUM(p.payment_value) as monthly_revenue,
        AVG(p.payment_value) as avg_monthly_order_value,
        STDDEV(p.payment_value) as monthly_revenue_stddev,
        -- Moving averages (3-month and 6-month)
        AVG(SUM(p.payment_value)) OVER (
            ORDER BY DATE_TRUNC('month', o.order_purchase_timestamp)
            ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
        ) as revenue_3month_moving_avg,
        AVG(SUM(p.payment_value)) OVER (
            ORDER BY DATE_TRUNC('month', o.order_purchase_timestamp)
            ROWS BETWEEN 5 PRECEDING AND CURRENT ROW
        ) as revenue_6month_moving_avg,
        AVG(COUNT(DISTINCT o.order_id)) OVER (
            ORDER BY DATE_TRUNC('month', o.order_purchase_timestamp)
            ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
        ) as orders_3month_moving_avg,
        -- Year-over-year comparisons
        LAG(SUM(p.payment_value), 12) OVER (
            ORDER BY DATE_TRUNC('month', o.order_purchase_timestamp)
        ) as same_month_last_year_revenue,
        LAG(COUNT(DISTINCT o.order_id), 12) OVER (
            ORDER BY DATE_TRUNC('month', o.order_purchase_timestamp)
        ) as same_month_last_year_orders,
        -- Growth rates
        (SUM(p.payment_value) - LAG(SUM(p.payment_value), 1) OVER (
            ORDER BY DATE_TRUNC('month', o.order_purchase_timestamp)
        )) / NULLIF(LAG(SUM(p.payment_value), 1) OVER (
            ORDER BY DATE_TRUNC('month', o.order_purchase_timestamp)
        ), 0) * 100 as month_over_month_growth_pct,
        -- Cumulative totals
        SUM(SUM(p.payment_value)) OVER (
            ORDER BY DATE_TRUNC('month', o.order_purchase_timestamp)
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ) as cumulative_revenue,
        SUM(COUNT(DISTINCT o.order_id)) OVER (
            ORDER BY DATE_TRUNC('month', o.order_purchase_timestamp)
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ) as cumulative_orders
    FROM olist_sales_data_set.olist_orders_dataset o
    JOIN olist_sales_data_set.olist_order_payments_dataset p ON o.order_id = p.order_id
    WHERE o.order_status = 'delivered'
    AND o.order_purchase_timestamp >= '2017-01-01'
    GROUP BY DATE_TRUNC('month', o.order_purchase_timestamp),
             EXTRACT(YEAR FROM o.order_purchase_timestamp),
             EXTRACT(MONTH FROM o.order_purchase_timestamp)
)
SELECT
    TO_CHAR(month_period, 'YYYY-MM') as period,
    monthly_orders,
    monthly_revenue,
    ROUND(avg_monthly_order_value, 2) as avg_monthly_order_value,
    ROUND(monthly_revenue_stddev, 2) as monthly_revenue_stddev,
    ROUND(revenue_3month_moving_avg, 2) as revenue_3month_moving_avg,
    ROUND(revenue_6month_moving_avg, 2) as revenue_6month_moving_avg,
    ROUND(orders_3month_moving_avg, 1) as orders_3month_moving_avg,
    ROUND(same_month_last_year_revenue, 2) as same_month_last_year_revenue,
    same_month_last_year_orders,
    ROUND(month_over_month_growth_pct, 2) as month_over_month_growth_pct,
    ROUND(cumulative_revenue, 2) as cumulative_revenue,
    cumulative_orders,
    -- Performance indicators
    CASE
        WHEN month_over_month_growth_pct > 10 THEN 'Strong Growth'
        WHEN month_over_month_growth_pct > 5 THEN 'Moderate Growth'
        WHEN month_over_month_growth_pct > 0 THEN 'Slow Growth'
        WHEN month_over_month_growth_pct > -5 THEN 'Slight Decline'
        ELSE 'Significant Decline'
    END as growth_category,
    -- Seasonal analysis
    ROUND(monthly_revenue / revenue_3month_moving_avg, 3) as seasonality_index_3m,
    ROUND(monthly_revenue / revenue_6month_moving_avg, 3) as seasonality_index_6m,
    -- Volatility measure
    ROUND(monthly_revenue_stddev / NULLIF(avg_monthly_order_value, 0) * 100, 2) as monthly_volatility_pct
FROM time_series_data
WHERE monthly_orders >= 10  -- Ensure statistical significance
ORDER BY month_period;

-- ================================================================================
-- SOLUTION 3: CUSTOMER SEGMENTATION ANALYSIS
-- ================================================================================

-- Solution 3.1: RFM (Recency, Frequency, Monetary) analysis with statistical segmentation
WITH customer_rfm AS (
    SELECT
        c.customer_unique_id,
        -- Recency: Days since last purchase
        EXTRACT(DAYS FROM CURRENT_DATE - MAX(o.order_purchase_timestamp)) as recency_days,
        -- Frequency: Number of orders
        COUNT(DISTINCT o.order_id) as frequency_count,
        -- Monetary: Total spent
        SUM(p.payment_value) as monetary_value,
        -- Additional metrics
        AVG(p.payment_value) as avg_order_value,
        MIN(o.order_purchase_timestamp) as first_purchase_date,
        MAX(o.order_purchase_timestamp) as last_purchase_date,
        -- Customer tenure in days
        EXTRACT(DAYS FROM MAX(o.order_purchase_timestamp) - MIN(o.order_purchase_timestamp)) as tenure_days,
        -- Average days between orders
        CASE
            WHEN COUNT(DISTINCT o.order_id) > 1 THEN
                EXTRACT(DAYS FROM MAX(o.order_purchase_timestamp) - MIN(o.order_purchase_timestamp)) /
                NULLIF(COUNT(DISTINCT o.order_id) - 1, 0)
            ELSE NULL
        END as avg_days_between_orders,
        -- Payment preferences
        MODE() WITHIN GROUP (ORDER BY p.payment_type) as preferred_payment_type,
        -- Geographic information
        c.customer_state,
        c.customer_city
    FROM olist_sales_data_set.olist_customers_dataset c
    JOIN olist_sales_data_set.olist_orders_dataset o ON c.customer_id = o.customer_id
    JOIN olist_sales_data_set.olist_order_payments_dataset p ON o.order_id = p.order_id
    WHERE o.order_status = 'delivered'
    GROUP BY c.customer_unique_id, c.customer_state, c.customer_city
),
rfm_scores AS (
    SELECT
        *,
        -- RFM Scoring (1-5 scale, 5 being best)
        NTILE(5) OVER (ORDER BY recency_days DESC) as recency_score,  -- Lower recency = higher score
        NTILE(5) OVER (ORDER BY frequency_count ASC) as frequency_score,  -- Higher frequency = higher score
        NTILE(5) OVER (ORDER BY monetary_value DESC) as monetary_score,  -- Higher monetary = higher score
        -- Percentile rankings for more granular analysis
        PERCENT_RANK() OVER (ORDER BY recency_days) as recency_percentile,
        PERCENT_RANK() OVER (ORDER BY frequency_count) as frequency_percentile,
        PERCENT_RANK() OVER (ORDER BY monetary_value) as monetary_percentile
    FROM customer_rfm
),
rfm_segments AS (
    SELECT
        *,
        -- Combined RFM score and segment
        recency_score + frequency_score + monetary_score as rfm_total_score,
        CASE
            WHEN recency_score >= 4 AND frequency_score >= 4 AND monetary_score >= 4 THEN 'Champions'
            WHEN recency_score >= 3 AND frequency_score >= 3 AND monetary_score >= 3 THEN 'Loyal Customers'
            WHEN recency_score >= 4 AND frequency_score <= 2 AND monetary_score >= 3 THEN 'New Customers'
            WHEN recency_score <= 2 AND frequency_score >= 3 AND monetary_score >= 3 THEN 'At-Risk Customers'
            WHEN recency_score <= 2 AND frequency_score <= 2 AND monetary_score <= 2 THEN 'Lost Customers'
            WHEN recency_score >= 3 AND monetary_score >= 4 THEN 'High-Value New'
            WHEN frequency_score >= 4 AND recency_score <= 3 THEN 'Frequent Buyers'
            ELSE 'Others'
        END as customer_segment,
        -- Value-based tiering
        CASE
            WHEN monetary_value >= (PERCENTILE_CONT(0.90) WITHIN GROUP (ORDER BY monetary_value)) THEN 'Platinum'
            WHEN monetary_value >= (PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY monetary_value)) THEN 'Gold'
            WHEN monetary_value >= (PERCENTILE_CONT(0.50) WITHIN GROUP (ORDER BY monetary_value)) THEN 'Silver'
            ELSE 'Bronze'
        END as value_tier
    FROM rfm_scores
)
SELECT
    customer_segment,
    value_tier,
    COUNT(*) as customer_count,
    COUNT(*) * 100.0 / SUM(COUNT(*)) OVER () as percentage_of_customers,
    ROUND(AVG(recency_days), 1) as avg_recency_days,
    ROUND(AVG(frequency_count), 1) as avg_frequency,
    ROUND(AVG(monetary_value), 2) as avg_monetary_value,
    ROUND(AVG(avg_order_value), 2) as avg_order_value,
    ROUND(AVG(tenure_days), 1) as avg_tenure_days,
    ROUND(AVG(avg_days_between_orders), 1) as avg_days_between_orders,
    -- Segment contribution to business
    ROUND(SUM(monetary_value) * 100.0 / SUM(SUM(monetary_value)) OVER (), 2) as revenue_contribution_pct,
    -- Geographic distribution
    COUNT(DISTINCT customer_state) as states_covered,
    COUNT(DISTINCT customer_city) as cities_covered,
    -- Payment preferences
    MODE() WITHIN GROUP (ORDER BY preferred_payment_type) as common_payment_type
FROM rfm_segments
GROUP BY customer_segment, value_tier
ORDER BY revenue_contribution_pct DESC;

-- Solution 3.2: Customer Lifetime Value (CLV) prediction with confidence intervals
WITH customer_behavior AS (
    SELECT
        c.customer_unique_id,
        -- Historical behavior
        COUNT(DISTINCT o.order_id) as total_orders,
        SUM(p.payment_value) as total_revenue,
        AVG(p.payment_value) as avg_order_value,
        STDDEV(p.payment_value) as order_value_stddev,
        MIN(o.order_purchase_timestamp) as first_order_date,
        MAX(o.order_purchase_timestamp) as last_order_date,
        EXTRACT(DAYS FROM MAX(o.order_purchase_timestamp) - MIN(o.order_purchase_timestamp)) as customer_lifetime_days,
        -- Purchase frequency
        CASE
            WHEN COUNT(DISTINCT o.order_id) > 1 THEN
                EXTRACT(DAYS FROM MAX(o.order_purchase_timestamp) - MIN(o.order_purchase_timestamp)) /
                NULLIF(COUNT(DISTINCT o.order_id) - 1, 0)
            ELSE 0
        END as avg_days_between_orders,
        -- Geographic factors
        c.customer_state,
        -- Payment type diversity
        COUNT(DISTINCT p.payment_type) as payment_type_diversity
    FROM olist_sales_data_set.olist_customers_dataset c
    JOIN olist_sales_data_set.olist_orders_dataset o ON c.customer_id = o.customer_id
    JOIN olist_sales_data_set.olist_order_payments_dataset p ON o.order_id = p.order_id
    WHERE o.order_status = 'delivered'
    GROUP BY c.customer_unique_id, c.customer_state
),
state_benchmarks AS (
    SELECT
        customer_state,
        AVG(total_orders) as state_avg_orders,
        AVG(total_revenue) as state_avg_revenue,
        AVG(avg_order_value) as state_avg_order_value,
        STDDEV(total_revenue) as state_revenue_stddev
    FROM customer_behavior
    WHERE total_orders > 0
    GROUP BY customer_state
),
clv_predictions AS (
    SELECT
        cb.customer_unique_id,
        cb.customer_state,
        cb.total_orders,
        cb.total_revenue,
        cb.avg_order_value,
        cb.avg_days_between_orders,
        -- Historical CLV (what they've already spent)
        cb.total_revenue as historical_clv,
        -- Predictive components
        -- Average order value with state adjustment
        CASE
            WHEN cb.avg_order_value > 0 THEN cb.avg_order_value
            ELSE sb.state_avg_order_value
        END as predicted_avg_order_value,
        -- Predicted remaining orders (next 365 days)
        CASE
            WHEN cb.avg_days_between_orders > 0 THEN
                GREATEST(1, 365.0 / cb.avg_days_between_orders)
            ELSE 1
        END as predicted_orders_next_year,
        -- State-based adjustment factor
        CASE
            WHEN sb.state_avg_revenue > 0 THEN
                cb.avg_order_value / NULLIF(sb.state_avg_order_value, 1)
            ELSE 1
        END as state_performance_factor,
        -- Risk adjustment based on order consistency
        CASE
            WHEN cb.order_value_stddev IS NOT NULL AND cb.avg_order_value > 0 THEN
                GREATEST(0.5, 1 - (cb.order_value_stddev / cb.avg_order_value))
            ELSE 1
        END as consistency_factor
    FROM customer_behavior cb
    LEFT JOIN state_benchmarks sb ON cb.customer_state = sb.customer_state
),
final_clv AS (
    SELECT
        *,
        -- Predicted CLV for next 12 months
        predicted_avg_order_value * predicted_orders_next_year *
        state_performance_factor * consistency_factor as predicted_clv_12m,
        -- Total predicted CLV (historical + future)
        historical_clv + (predicted_avg_order_value * predicted_orders_next_year *
        state_performance_factor * consistency_factor) as total_predicted_clv,
        -- Confidence intervals (simplified Monte Carlo approach)
        historical_clv + (predicted_avg_order_value * predicted_orders_next_year *
        state_performance_factor * consistency_factor * 0.8) as clv_lower_bound,
        historical_clv + (predicted_avg_order_value * predicted_orders_next_year *
        state_performance_factor * consistency_factor * 1.2) as clv_upper_bound
    FROM clv_predictions
)
SELECT
    customer_state,
    COUNT(*) as customer_count,
    ROUND(AVG(historical_clv), 2) as avg_historical_clv,
    ROUND(AVG(predicted_clv_12m), 2) as avg_predicted_12m_clv,
    ROUND(AVG(total_predicted_clv), 2) as avg_total_predicted_clv,
    ROUND(AVG(clv_lower_bound), 2) as avg_clv_lower_bound,
    ROUND(AVG(clv_upper_bound), 2) as avg_clv_upper_bound,
    ROUND(AVG(total_orders), 1) as avg_historical_orders,
    ROUND(AVG(predicted_orders_next_year), 1) as avg_predicted_orders,
    -- CLV tiers
    COUNT(CASE WHEN total_predicted_clv >= 1000 THEN 1 END) as high_value_customers,
    COUNT(CASE WHEN total_predicted_clv BETWEEN 500 AND 999 THEN 1 END) as medium_value_customers,
    COUNT(CASE WHEN total_predicted_clv < 500 THEN 1 END) as low_value_customers,
    -- Business metrics
    ROUND(SUM(total_revenue), 2) as total_historical_revenue,
    ROUND(SUM(predicted_clv_12m), 2) as total_predicted_revenue_12m,
    ROUND(AVG(state_performance_factor), 3) as avg_state_performance_factor,
    ROUND(AVG(consistency_factor), 3) as avg_consistency_factor
FROM final_clv
WHERE total_orders > 0  -- Active customers only
GROUP BY customer_state
ORDER BY total_predicted_revenue_12m DESC;

-- ================================================================================
-- SOLUTION 4: PRODUCT AND CATEGORY ANALYSIS
-- ================================================================================

-- Solution 4.1: Product category performance with statistical analysis
WITH category_performance AS (
    SELECT
        COALESCE(p.product_category_name, 'Unknown') as product_category,
        -- Sales metrics
        COUNT(DISTINCT oi.order_id) as total_orders,
        COUNT(DISTINCT oi.product_id) as unique_products,
        SUM(oi.price) as total_revenue,
        AVG(oi.price) as avg_product_price,
        STDDEV(oi.price) as price_stddev,
        SUM(oi.freight_value) as total_freight_cost,
        AVG(oi.freight_value) as avg_freight_cost,
        -- Profitability metrics (simplified)
        SUM(oi.price) * 0.7 as estimated_cost,  -- Assuming 30% gross margin
        SUM(oi.price) * 0.3 as estimated_profit,
        -- Statistical measures
        MIN(oi.price) as min_price,
        MAX(oi.price) as max_price,
        PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY oi.price) as price_q1,
        PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY oi.price) as price_median,
        PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY oi.price) as price_q3,
        PERCENTILE_CONT(0.90) WITHIN GROUP (ORDER BY oi.price) as price_p90,
        PERCENTILE_CONT(0.95) WITHIN GROUP (ORDER BY oi.price) as price_p95,
        -- Order size metrics
        AVG(oi.order_item_id) as avg_items_per_order,
        SUM(oi.order_item_id) as total_items_sold
    FROM olist_sales_data_set.olist_order_items_dataset oi
    LEFT JOIN olist_sales_data_set.olist_products_dataset p ON oi.product_id = p.product_id
    GROUP BY COALESCE(p.product_category_name, 'Unknown')
),
category_rankings AS (
    SELECT
        cp.*,
        -- Performance rankings
        RANK() OVER (ORDER BY cp.total_revenue DESC) as revenue_rank,
        RANK() OVER (ORDER BY cp.total_orders DESC) as volume_rank,
        RANK() OVER (ORDER BY cp.avg_product_price DESC) as price_rank,
        RANK() OVER (ORDER BY cp.estimated_profit DESC) as profit_rank,
        -- Market share
        cp.total_revenue * 100.0 / SUM(cp.total_revenue) OVER () as revenue_market_share,
        cp.total_orders * 100.0 / SUM(cp.total_orders) OVER () as volume_market_share,
        -- Percentile positions
        PERCENT_RANK() OVER (ORDER BY cp.total_revenue) as revenue_percentile,
        PERCENT_RANK() OVER (ORDER BY cp.total_orders) as volume_percentile,
        -- Performance indicators
        CASE
            WHEN cp.total_orders >= 100 AND cp.total_revenue >= 10000 THEN 'High Volume High Value'
            WHEN cp.total_orders >= 100 AND cp.total_revenue < 10000 THEN 'High Volume Low Value'
            WHEN cp.total_orders < 100 AND cp.total_revenue >= 10000 THEN 'Low Volume High Value'
            ELSE 'Low Volume Low Value'
        END as performance_category,
        -- Price positioning
        CASE
            WHEN cp.avg_product_price >= (PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY avg_product_value)) THEN 'Premium'
            WHEN cp.avg_product_price >= (PERCENTILE_CONT(0.50) WITHIN GROUP (ORDER BY avg_product_value)) THEN 'Mid-Range'
            ELSE 'Budget'
        END as price_positioning,
        -- Growth potential (based on unique products)
        CASE
            WHEN cp.unique_products >= 50 THEN 'High Variety'
            WHEN cp.unique_products >= 20 THEN 'Medium Variety'
            ELSE 'Low Variety'
        END as variety_level
    FROM category_performance cp
)
SELECT
    product_category,
    total_orders,
    unique_products,
    ROUND(total_revenue, 2) as total_revenue,
    ROUND(avg_product_price, 2) as avg_product_price,
    ROUND(price_stddev, 2) as price_stddev,
    ROUND(estimated_profit, 2) as estimated_profit,
    ROUND(price_median, 2) as price_median,
    ROUND(price_q1, 2) as price_q1,
    ROUND(price_q3, 2) as price_q3,
    revenue_rank,
    volume_rank,
    profit_rank,
    ROUND(revenue_market_share, 2) as revenue_market_share,
    ROUND(volume_market_share, 2) as volume_market_share,
    ROUND(revenue_percentile * 100, 1) as revenue_percentile,
    ROUND(volume_percentile * 100, 1) as volume_percentile,
    performance_category,
    price_positioning,
    variety_level,
    -- Profitability metrics
    ROUND(estimated_profit / NULLIF(total_revenue, 0) * 100, 2) as profit_margin_pct,
    ROUND(avg_freight_cost / NULLIF(avg_product_price, 0) * 100, 2) as freight_cost_ratio_pct
FROM category_rankings
WHERE total_orders >= 10  -- Filter categories with sufficient data
ORDER BY total_revenue DESC;

-- ================================================================================
-- SOLUTION 5: EXECUTIVE REPORTING QUERIES
-- ================================================================================

-- Solution 5.1: Comprehensive executive dashboard query
WITH executive_metrics AS (
    SELECT
        -- Overall Business Metrics
        COUNT(DISTINCT o.order_id) as total_orders,
        COUNT(DISTINCT c.customer_unique_id) as unique_customers,
        SUM(p.payment_value) as total_revenue,
        AVG(p.payment_value) as avg_order_value,
        -- Time Period Analysis
        MIN(o.order_purchase_timestamp) as first_order_date,
        MAX(o.order_purchase_timestamp) as last_order_date,
        EXTRACT(DAYS FROM MAX(o.order_purchase_timestamp) - MIN(o.order_purchase_timestamp)) as business_days,
        -- Geographic Coverage
        COUNT(DISTINCT c.customer_state) as states_covered,
        COUNT(DISTINCT c.customer_city) as cities_covered,
        -- Payment Method Distribution
        COUNT(DISTINCT p.payment_type) as payment_methods_used,
        -- Product Categories
        COUNT(DISTINCT COALESCE(pr.product_category_name, 'Unknown')) as product_categories
    FROM olist_sales_data_set.olist_orders_dataset o
    JOIN olist_sales_data_set.olist_order_payments_dataset p ON o.order_id = p.order_id
    JOIN olist_sales_data_set.olist_customers_dataset c ON o.customer_id = c.customer_id
    LEFT JOIN olist_sales_data_set.olist_order_items_dataset oi ON o.order_id = oi.order_id
    LEFT JOIN olist_sales_data_set.olist_products_dataset pr ON oi.product_id = pr.product_id
    WHERE o.order_status = 'delivered'
),
regional_leaders AS (
    SELECT
        'Top State by Revenue' as metric_type,
        c.customer_state as entity_name,
        SUM(p.payment_value) as metric_value
    FROM olist_sales_data_set.olist_orders_dataset o
    JOIN olist_sales_data_set.olist_order_payments_dataset p ON o.order_id = p.order_id
    JOIN olist_sales_data_set.olist_customers_dataset c ON o.customer_id = c.customer_id
    WHERE o.order_status = 'delivered'
    GROUP BY c.customer_state
    ORDER BY SUM(p.payment_value) DESC
    LIMIT 1

    UNION ALL

    SELECT
        'Top State by Order Volume' as metric_type,
        c.customer_state as entity_name,
        COUNT(DISTINCT o.order_id)::DECIMAL as metric_value
    FROM olist_sales_data_set.olist_orders_dataset o
    JOIN olist_sales_data_set.olist_order_payments_dataset p ON o.order_id = p.order_id
    JOIN olist_sales_data_set.olist_customers_dataset c ON o.customer_id = c.customer_id
    WHERE o.order_status = 'delivered'
    GROUP BY c.customer_state
    ORDER BY COUNT(DISTINCT o.order_id) DESC
    LIMIT 1
),
product_leaders AS (
    SELECT
        'Top Category by Revenue' as metric_type,
        COALESCE(pr.product_category_name, 'Unknown') as entity_name,
        SUM(oi.price) as metric_value
    FROM olist_sales_data_set.olist_order_items_dataset oi
    LEFT JOIN olist_sales_data_set.olist_products_dataset pr ON oi.product_id = pr.product_id
    GROUP BY COALESCE(pr.product_category_name, 'Unknown')
    ORDER BY SUM(oi.price) DESC
    LIMIT 1

    UNION ALL

    SELECT
        'Top Category by Volume' as metric_type,
        COALESCE(pr.product_category_name, 'Unknown') as entity_name,
        COUNT(DISTINCT oi.order_id)::DECIMAL as metric_value
    FROM olist_sales_data_set.olist_order_items_dataset oi
    LEFT JOIN olist_sales_data_set.olist_products_dataset pr ON oi.product_id = pr.product_id
    GROUP BY COALESCE(pr.product_category_name, 'Unknown')
    ORDER BY COUNT(DISTINCT oi.order_id) DESC
    LIMIT 1
),
monthly_trends AS (
    SELECT
        DATE_TRUNC('month', o.order_purchase_timestamp) as month_period,
        SUM(p.payment_value) as monthly_revenue,
        COUNT(DISTINCT o.order_id) as monthly_orders,
        AVG(p.payment_value) as avg_monthly_order_value
    FROM olist_sales_data_set.olist_orders_dataset o
    JOIN olist_sales_data_set.olist_order_payments_dataset p ON o.order_id = p.order_id
    WHERE o.order_status = 'delivered'
    GROUP BY DATE_TRUNC('month', o.order_purchase_timestamp)
    ORDER BY month_period DESC
    LIMIT 3
),
performance_indicators AS (
    SELECT
        -- Revenue per customer
        em.total_revenue / NULLIF(em.unique_customers, 0) as revenue_per_customer,
        -- Orders per customer
        em.total_orders / NULLIF(em.unique_customers, 0) as orders_per_customer,
        -- Revenue per order
        em.avg_order_value,
        -- Daily average revenue
        em.total_revenue / NULLIF(em.business_days, 0) as daily_avg_revenue,
        -- Geographic penetration
        em.unique_customers / NULLIF(em.states_covered, 0) as customers_per_state,
        -- Category diversity
        em.product_categories::DECIMAL / NULLIF(em.unique_customers, 0) as categories_per_customer
    FROM executive_metrics em
)
-- Final Executive Summary
SELECT
    '=== EXECUTIVE DASHBOARD SUMMARY ===' as report_section,
    NULL as metric_name,
    NULL as metric_value,
    NULL as unit

UNION ALL

SELECT
    'BUSINESS OVERVIEW',
    'Total Orders',
    total_orders::TEXT,
    'Count'
FROM executive_metrics

UNION ALL

SELECT
    'BUSINESS OVERVIEW',
    'Unique Customers',
    unique_customers::TEXT,
    'Count'
FROM executive_metrics

UNION ALL

SELECT
    'BUSINESS OVERVIEW',
    'Total Revenue',
    '₦' || ROUND(total_revenue, 2)::TEXT,
    'Currency'
FROM executive_metrics

UNION ALL

SELECT
    'BUSINESS OVERVIEW',
    'Average Order Value',
    '₦' || ROUND(avg_order_value, 2)::TEXT,
    'Currency'
FROM executive_metrics

UNION ALL

SELECT
    'BUSINESS OVERVIEW',
    'Business Duration',
    business_days::TEXT,
    'Days'
FROM executive_metrics

UNION ALL

SELECT
    'GEOGRAPHIC REACH',
    'States Covered',
    states_covered::TEXT,
    'Count'
FROM executive_metrics

UNION ALL

SELECT
    'GEOGRAPHIC REACH',
    'Cities Covered',
    cities_covered::TEXT,
    'Count'
FROM executive_metrics

UNION ALL

SELECT
    'GEOGRAPHIC REACH',
    'Customers per State',
    ROUND(customers_per_state, 1)::TEXT,
    'Ratio'
FROM performance_indicators

UNION ALL

SELECT
    'PRODUCT ASSORTMENT',
    'Product Categories',
    product_categories::TEXT,
    'Count'
FROM executive_metrics

UNION ALL

SELECT
    'PRODUCT ASSORTMENT',
    'Payment Methods',
    payment_methods_used::TEXT,
    'Count'
FROM executive_metrics

UNION ALL

SELECT
    'PERFORMANCE METRICS',
    'Revenue per Customer',
    '₦' || ROUND(revenue_per_customer, 2)::TEXT,
    'Currency'
FROM performance_indicators

UNION ALL

SELECT
    'PERFORMANCE METRICS',
    'Orders per Customer',
    ROUND(orders_per_customer, 2)::TEXT,
    'Ratio'
FROM performance_indicators

UNION ALL

SELECT
    'PERFORMANCE METRICS',
    'Daily Average Revenue',
    '₦' || ROUND(daily_avg_revenue, 2)::TEXT,
    'Currency'
FROM performance_indicators

UNION ALL

SELECT
    'TOP PERFORMERS',
    metric_type,
    entity_name,
    metric_value::TEXT
FROM regional_leaders

UNION ALL

SELECT
    'TOP PERFORMERS',
    metric_type,
    entity_name,
    '₦' || ROUND(metric_value, 2)::TEXT
FROM product_leaders

UNION ALL

SELECT
    'RECENT TRENDS',
    'Month: ' || TO_CHAR(month_period, 'YYYY-MM'),
    'Revenue: ₦' || ROUND(monthly_revenue, 2) || ', Orders: ' || monthly_orders,
    'Combined'
FROM monthly_trends

ORDER BY report_section, metric_name;