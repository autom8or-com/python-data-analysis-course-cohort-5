-- Week 5: Date & Time Operations - Part 2: Date Arithmetic & Business Metrics
-- Business Scenario: NaijaCommerce Delivery Performance & Customer Analysis
-- Focus: Advanced date calculations for operational excellence

-- =============================================================================
-- PART 1: DATE ARITHMETIC FOR DELIVERY ANALYSIS
-- =============================================================================

-- 1.1 Basic Date Arithmetic - Understanding Delivery Times
-- Critical for logistics optimization in Nigerian e-commerce

-- Calculate delivery time metrics
SELECT
    order_id,
    order_purchase_timestamp,
    order_approved_at,
    order_delivered_customer_date,
    -- Date arithmetic: subtraction gives us interval/days
    order_delivered_customer_date - order_purchase_timestamp AS total_delivery_time,
    order_approved_at - order_purchase_timestamp AS approval_time,
    order_delivered_customer_date - order_approved_at AS fulfillment_time,
    -- Extract days from the interval
    EXTRACT(DAY FROM (order_delivered_customer_date - order_purchase_timestamp)) AS delivery_days,
    EXTRACT(DAY FROM (order_approved_at - order_purchase_timestamp)) AS approval_days
FROM olist_sales_data_set.olist_orders_dataset
WHERE order_delivered_customer_date IS NOT NULL
    AND order_approved_at IS NOT NULL
    AND order_purchase_timestamp IS NOT NULL
    AND order_status = 'delivered'
ORDER BY order_purchase_timestamp
LIMIT 10;

-- 1.2 Business KPI: Average Delivery Performance by Month
-- Understanding seasonal impact on logistics

SELECT
    DATE_TRUNC('month', order_purchase_timestamp) AS month,
    COUNT(*) AS delivered_orders,
    -- Average delivery time calculations
    ROUND(AVG(EXTRACT(DAY FROM (order_delivered_customer_date - order_purchase_timestamp))), 2) AS avg_delivery_days,
    ROUND(AVG(EXTRACT(DAY FROM (order_approved_at - order_purchase_timestamp))), 2) AS avg_approval_days,
    -- Performance targets (example: target 7 days total delivery)
    COUNT(CASE WHEN EXTRACT(DAY FROM (order_delivered_customer_date - order_purchase_timestamp)) <= 7 THEN 1 END) AS orders_within_target,
    ROUND(
        COUNT(CASE WHEN EXTRACT(DAY FROM (order_delivered_customer_date - order_purchase_timestamp)) <= 7 THEN 1 END) * 100.0 / COUNT(*),
        2
    ) AS target_achievement_rate
FROM olist_sales_data_set.olist_orders_dataset
WHERE order_delivered_customer_date IS NOT NULL
    AND order_approved_at IS NOT NULL
    AND order_purchase_timestamp IS NOT NULL
    AND order_status = 'delivered'
    AND order_purchase_timestamp >= '2017-01-01'
GROUP BY DATE_TRUNC('month', order_purchase_timestamp)
ORDER BY month;

-- 1.3 Working with INTERVAL Data Type
-- Useful for date calculations and business rules

SELECT
    order_id,
    order_purchase_timestamp,
    -- Adding intervals to dates
    order_purchase_timestamp + INTERVAL '7 days' AS expected_delivery,
    order_purchase_timestamp + INTERVAL '3 months' AS warranty_expiry,
    -- Current timestamp comparisons
    CURRENT_TIMESTAMP - order_purchase_timestamp AS order_age,
    -- Business logic with intervals
    CASE
        WHEN order_delivered_customer_date <= order_purchase_timestamp + INTERVAL '7 days' THEN 'Fast Delivery'
        WHEN order_delivered_customer_date <= order_purchase_timestamp + INTERVAL '14 days' THEN 'Standard Delivery'
        ELSE 'Slow Delivery'
    END AS delivery_classification
FROM olist_sales_data_set.olist_orders_dataset
WHERE order_delivered_customer_date IS NOT NULL
    AND order_purchase_timestamp IS NOT NULL
    AND order_status = 'delivered'
ORDER BY order_purchase_timestamp DESC
LIMIT 10;

-- =============================================================================
-- PART 2: TIME-BASED BUSINESS INTELLIGENCE
-- =============================================================================

-- 2.1 Period-over-Period Comparisons
-- Essential for understanding business growth trends

-- Year-over-Year comparison of monthly sales
WITH monthly_sales AS (
    SELECT
        EXTRACT(YEAR FROM o.order_purchase_timestamp) AS year,
        EXTRACT(MONTH FROM o.order_purchase_timestamp) AS month,
        COUNT(DISTINCT o.order_id) AS total_orders,
        SUM(oi.price) AS total_revenue,
        COUNT(DISTINCT o.customer_id) AS unique_customers
    FROM olist_sales_data_set.olist_orders_dataset o
    JOIN olist_sales_data_set.olist_order_items_dataset oi ON o.order_id = oi.order_id
    WHERE o.order_purchase_timestamp IS NOT NULL
        AND o.order_status NOT IN ('cancelled', 'unavailable')
    GROUP BY EXTRACT(YEAR FROM o.order_purchase_timestamp), EXTRACT(MONTH FROM o.order_purchase_timestamp)
)
SELECT
    year,
    month,
    total_orders,
    total_revenue,
    unique_customers,
    -- Compare with same month previous year using LAG window function
    LAG(total_orders, 12) OVER (ORDER BY year, month) AS prev_year_orders,
    LAG(total_revenue, 12) OVER (ORDER BY year, month) AS prev_year_revenue,
    -- Calculate year-over-year growth
    CASE
        WHEN LAG(total_orders, 12) OVER (ORDER BY year, month) IS NOT NULL THEN
            ROUND((total_orders - LAG(total_orders, 12) OVER (ORDER BY year, month)) * 100.0 /
                  LAG(total_orders, 12) OVER (ORDER BY year, month), 2)
    END AS orders_yoy_growth_percent,
    CASE
        WHEN LAG(total_revenue, 12) OVER (ORDER BY year, month) IS NOT NULL THEN
            ROUND((total_revenue - LAG(total_revenue, 12) OVER (ORDER BY year, month)) * 100.0 /
                  LAG(total_revenue, 12) OVER (ORDER BY year, month), 2)
    END AS revenue_yoy_growth_percent
FROM monthly_sales
ORDER BY year, month;

-- 2.2 Rolling Averages and Moving Windows
-- Smoothing out fluctuations to identify trends

WITH daily_orders AS (
    SELECT
        DATE(order_purchase_timestamp) AS order_date,
        COUNT(*) AS daily_order_count,
        COUNT(DISTINCT customer_id) AS daily_unique_customers
    FROM olist_sales_data_set.olist_orders_dataset
    WHERE order_purchase_timestamp IS NOT NULL
        AND order_purchase_timestamp >= '2018-01-01'
        AND order_status NOT IN ('cancelled', 'unavailable')
    GROUP BY DATE(order_purchase_timestamp)
)
SELECT
    order_date,
    daily_order_count,
    daily_unique_customers,
    -- 7-day moving average
    ROUND(AVG(daily_order_count) OVER (ORDER BY order_date ROWS BETWEEN 6 PRECEDING AND CURRENT ROW), 2) AS moving_avg_7d_orders,
    -- 30-day moving average
    ROUND(AVG(daily_order_count) OVER (ORDER BY order_date ROWS BETWEEN 29 PRECEDING AND CURRENT ROW), 2) AS moving_avg_30d_orders,
    -- Comparison with previous day
    LAG(daily_order_count, 1) OVER (ORDER BY order_date) AS prev_day_orders,
    daily_order_count - LAG(daily_order_count, 1) OVER (ORDER BY order_date) AS daily_change
FROM daily_orders
ORDER BY order_date
LIMIT 30;

-- 2.3 Customer Cohort Analysis Based on Registration Time
-- Understanding customer lifetime value by signup period

WITH customer_first_order AS (
    SELECT
        customer_id,
        MIN(order_purchase_timestamp) AS first_order_date,
        DATE_TRUNC('month', MIN(order_purchase_timestamp)) AS cohort_month
    FROM olist_sales_data_set.olist_orders_dataset
    WHERE order_purchase_timestamp IS NOT NULL
    GROUP BY customer_id
),
customer_orders AS (
    SELECT
        o.customer_id,
        o.order_purchase_timestamp,
        cfo.cohort_month,
        -- Calculate months since first order
        EXTRACT(YEAR FROM AGE(o.order_purchase_timestamp, cfo.first_order_date)) * 12 +
        EXTRACT(MONTH FROM AGE(o.order_purchase_timestamp, cfo.first_order_date)) AS months_since_first_order
    FROM olist_sales_data_set.olist_orders_dataset o
    JOIN customer_first_order cfo ON o.customer_id = cfo.customer_id
    WHERE o.order_purchase_timestamp IS NOT NULL
        AND o.order_status NOT IN ('cancelled', 'unavailable')
)
SELECT
    cohort_month,
    months_since_first_order,
    COUNT(DISTINCT customer_id) AS active_customers,
    COUNT(*) AS total_orders
FROM customer_orders
WHERE cohort_month >= '2017-01-01'
    AND months_since_first_order <= 12  -- Focus on first year
GROUP BY cohort_month, months_since_first_order
ORDER BY cohort_month, months_since_first_order
LIMIT 20;

-- =============================================================================
-- PART 3: ADVANCED TEMPORAL BUSINESS ANALYSIS
-- =============================================================================

-- 3.1 Seasonal Pattern Detection
-- Identifying recurring patterns for inventory and marketing planning

SELECT
    EXTRACT(MONTH FROM o.order_purchase_timestamp) AS month,
    TO_CHAR(o.order_purchase_timestamp, 'Month') AS month_name,
    COUNT(DISTINCT o.order_id) AS total_orders,
    SUM(oi.price) AS total_revenue,
    AVG(oi.price) AS avg_order_value,
    -- Calculate seasonal index (comparing each month to yearly average)
    ROUND(
        COUNT(DISTINCT o.order_id) * 100.0 /
        (SUM(COUNT(DISTINCT o.order_id)) OVER () / 12), 2
    ) AS seasonal_index_orders,
    ROUND(
        SUM(oi.price) * 100.0 /
        (SUM(SUM(oi.price)) OVER () / 12), 2
    ) AS seasonal_index_revenue
FROM olist_sales_data_set.olist_orders_dataset o
JOIN olist_sales_data_set.olist_order_items_dataset oi ON o.order_id = oi.order_id
WHERE o.order_purchase_timestamp IS NOT NULL
    AND o.order_status NOT IN ('cancelled', 'unavailable')
    AND o.order_purchase_timestamp >= '2017-01-01'
    AND o.order_purchase_timestamp < '2019-01-01'
GROUP BY EXTRACT(MONTH FROM o.order_purchase_timestamp), TO_CHAR(o.order_purchase_timestamp, 'Month')
ORDER BY month;

-- 3.2 Time-Based Performance Benchmarking
-- Creating delivery performance benchmarks by time period

WITH delivery_metrics AS (
    SELECT
        DATE_TRUNC('quarter', order_purchase_timestamp) AS quarter,
        EXTRACT(DAY FROM (order_delivered_customer_date - order_purchase_timestamp)) AS delivery_days,
        order_id
    FROM olist_sales_data_set.olist_orders_dataset
    WHERE order_delivered_customer_date IS NOT NULL
        AND order_purchase_timestamp IS NOT NULL
        AND order_status = 'delivered'
        AND order_purchase_timestamp >= '2017-01-01'
)
SELECT
    quarter,
    COUNT(*) AS total_deliveries,
    ROUND(AVG(delivery_days), 2) AS avg_delivery_days,
    ROUND(PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY delivery_days), 2) AS median_delivery_days,
    ROUND(PERCENTILE_CONT(0.95) WITHIN GROUP (ORDER BY delivery_days), 2) AS p95_delivery_days,
    -- Performance classification
    COUNT(CASE WHEN delivery_days <= 7 THEN 1 END) AS fast_deliveries,
    COUNT(CASE WHEN delivery_days BETWEEN 8 AND 14 THEN 1 END) AS standard_deliveries,
    COUNT(CASE WHEN delivery_days > 14 THEN 1 END) AS slow_deliveries,
    -- Performance rates
    ROUND(COUNT(CASE WHEN delivery_days <= 7 THEN 1 END) * 100.0 / COUNT(*), 2) AS fast_delivery_rate
FROM delivery_metrics
GROUP BY quarter
ORDER BY quarter;

-- =============================================================================
-- NIGERIAN BUSINESS CONTEXT CONSIDERATIONS
-- =============================================================================

-- Nigerian-specific temporal analysis considerations:
-- 1. Rainy Season Impact (May-October): Longer delivery times expected
-- 2. Festive Seasons: Christmas (Dec), Eid (varies), Independence Day (Oct 1)
-- 3. Salary Payment Cycles: End of month peaks in government sectors
-- 4. Academic Calendar: September (resumption), December (holidays) impact

-- Example: Nigerian Seasonal Adjustment Analysis
SELECT
    EXTRACT(MONTH FROM o.order_purchase_timestamp) AS month,
    TO_CHAR(o.order_purchase_timestamp, 'Month') AS month_name,
    COUNT(*) AS orders,
    AVG(EXTRACT(DAY FROM (order_delivered_customer_date - order_purchase_timestamp))) AS avg_delivery_days,
    CASE
        WHEN EXTRACT(MONTH FROM o.order_purchase_timestamp) IN (5,6,7,8,9,10) THEN 'Rainy Season'
        ELSE 'Dry Season'
    END AS nigerian_season,
    CASE
        WHEN EXTRACT(MONTH FROM o.order_purchase_timestamp) = 12 THEN 'Christmas Peak'
        WHEN EXTRACT(MONTH FROM o.order_purchase_timestamp) = 10 THEN 'Independence Month'
        WHEN EXTRACT(MONTH FROM o.order_purchase_timestamp) = 9 THEN 'Back-to-School'
        ELSE 'Regular Period'
    END AS business_period
FROM olist_sales_data_set.olist_orders_dataset o
WHERE order_delivered_customer_date IS NOT NULL
    AND order_purchase_timestamp IS NOT NULL
    AND order_status = 'delivered'
GROUP BY EXTRACT(MONTH FROM o.order_purchase_timestamp), TO_CHAR(o.order_purchase_timestamp, 'Month')
ORDER BY month;

-- =============================================================================
-- PREPARATION FOR WEDNESDAY PYTHON CLASS
-- =============================================================================

-- Key concepts students will translate to Python:
-- 1. Date component extraction → pandas .dt accessor
-- 2. Date arithmetic → timedelta operations
-- 3. Grouping by time periods → pandas resample()
-- 4. Window functions → pandas rolling()
-- 5. Period comparisons → pandas shift() and pct_change()

-- The business insights remain the same; only the tools change!