-- Week 5: Date & Time Operations - Part 1: SQL Date Function Fundamentals
-- Business Scenario: NaijaCommerce Seasonal Analysis
-- Data Source: Brazilian Olist E-commerce Dataset

-- =============================================================================
-- PART 1: UNDERSTANDING DATE/TIME DATA TYPES
-- =============================================================================

-- Let's start by exploring the temporal structure of our dataset
-- First, let's understand what date/time fields we have in the orders table

SELECT
    order_id,
    order_purchase_timestamp,
    order_approved_at,
    order_delivered_carrier_date,
    order_delivered_customer_date,
    order_estimated_delivery_date,
    order_status
FROM olist_sales_data_set.olist_orders_dataset
ORDER BY order_purchase_timestamp
LIMIT 5;

-- Check the data types of our temporal fields
SELECT
    column_name,
    data_type,
    is_nullable
FROM information_schema.columns
WHERE table_name = 'olist_orders_dataset'
    AND table_schema = 'olist_sales_data_set'
    AND data_type LIKE '%time%'
ORDER BY ordinal_position;

-- Business Insight: Understanding the customer journey timeline
-- From purchase → approval → carrier pickup → customer delivery

-- =============================================================================
-- PART 2: ESSENTIAL DATE EXTRACTION FUNCTIONS
-- =============================================================================

-- 2.1 EXTRACT() Function - The Foundation of Temporal Analysis
-- Let's analyze seasonal patterns in our e-commerce data

-- Extract year, month, quarter from purchase timestamps
SELECT
    order_id,
    order_purchase_timestamp,
    EXTRACT(YEAR FROM order_purchase_timestamp) AS purchase_year,
    EXTRACT(MONTH FROM order_purchase_timestamp) AS purchase_month,
    EXTRACT(QUARTER FROM order_purchase_timestamp) AS purchase_quarter,
    EXTRACT(DAY FROM order_purchase_timestamp) AS purchase_day,
    EXTRACT(DOW FROM order_purchase_timestamp) AS day_of_week  -- 0=Sunday, 6=Saturday
FROM olist_sales_data_set.olist_orders_dataset
WHERE order_purchase_timestamp IS NOT NULL
ORDER BY order_purchase_timestamp
LIMIT 10;

-- 2.2 Business Application: Monthly Sales Summary
-- This is exactly what our Nigerian e-commerce platform needs!

SELECT
    EXTRACT(YEAR FROM order_purchase_timestamp) AS year,
    EXTRACT(MONTH FROM order_purchase_timestamp) AS month,
    COUNT(*) AS total_orders,
    COUNT(DISTINCT customer_id) AS unique_customers
FROM olist_sales_data_set.olist_orders_dataset
WHERE order_purchase_timestamp IS NOT NULL
    AND order_status NOT IN ('cancelled', 'unavailable')
GROUP BY
    EXTRACT(YEAR FROM order_purchase_timestamp),
    EXTRACT(MONTH FROM order_purchase_timestamp)
ORDER BY year, month;

-- 2.3 DATE_TRUNC() Function - Grouping by Time Periods
-- Perfect for creating time-based reports

-- Weekly order trends
SELECT
    DATE_TRUNC('week', order_purchase_timestamp) AS week_start,
    COUNT(*) AS orders_per_week,
    COUNT(DISTINCT customer_id) AS customers_per_week
FROM olist_sales_data_set.olist_orders_dataset
WHERE order_purchase_timestamp IS NOT NULL
    AND order_purchase_timestamp >= '2018-01-01'
GROUP BY DATE_TRUNC('week', order_purchase_timestamp)
ORDER BY week_start
LIMIT 10;

-- Monthly revenue analysis with order items
SELECT
    DATE_TRUNC('month', o.order_purchase_timestamp) AS month,
    COUNT(DISTINCT o.order_id) AS total_orders,
    SUM(oi.price) AS total_revenue,
    AVG(oi.price) AS avg_order_value,
    COUNT(DISTINCT o.customer_id) AS unique_customers
FROM olist_sales_data_set.olist_orders_dataset o
JOIN olist_sales_data_set.olist_order_items_dataset oi ON o.order_id = oi.order_id
WHERE o.order_purchase_timestamp IS NOT NULL
    AND o.order_status NOT IN ('cancelled', 'unavailable')
    AND o.order_purchase_timestamp >= '2017-01-01'
GROUP BY DATE_TRUNC('month', o.order_purchase_timestamp)
ORDER BY month;

-- =============================================================================
-- PART 3: DATE FORMATTING AND CONVERSION
-- =============================================================================

-- 3.1 TO_CHAR() Function - Creating Business-Friendly Date Formats
-- Essential for reports and dashboards

SELECT
    order_id,
    order_purchase_timestamp,
    -- Different date format options
    TO_CHAR(order_purchase_timestamp, 'YYYY-MM-DD') AS date_iso,
    TO_CHAR(order_purchase_timestamp, 'Month DD, YYYY') AS date_readable,
    TO_CHAR(order_purchase_timestamp, 'Day') AS weekday_name,
    TO_CHAR(order_purchase_timestamp, 'Mon YYYY') AS month_year,
    TO_CHAR(order_purchase_timestamp, 'Q') AS quarter_num,
    TO_CHAR(order_purchase_timestamp, 'HH24:MI') AS time_24hr
FROM olist_sales_data_set.olist_orders_dataset
WHERE order_purchase_timestamp IS NOT NULL
ORDER BY order_purchase_timestamp
LIMIT 10;

-- 3.2 Business Report: Sales by Weekday
-- Understanding customer shopping behavior patterns

SELECT
    TO_CHAR(order_purchase_timestamp, 'Day') AS weekday,
    EXTRACT(DOW FROM order_purchase_timestamp) AS day_number,
    COUNT(*) AS total_orders,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2) AS percentage_of_orders
FROM olist_sales_data_set.olist_orders_dataset
WHERE order_purchase_timestamp IS NOT NULL
    AND order_status NOT IN ('cancelled', 'unavailable')
GROUP BY
    TO_CHAR(order_purchase_timestamp, 'Day'),
    EXTRACT(DOW FROM order_purchase_timestamp)
ORDER BY day_number;

-- 3.3 Handling Date Conversion and Parsing
-- Important for data quality and integration

-- Example: Working with different date string formats
-- (This would be used when importing data from various sources)

SELECT
    '2024-12-25' AS date_string,
    TO_DATE('2024-12-25', 'YYYY-MM-DD') AS parsed_date,
    TO_DATE('25/12/2024', 'DD/MM/YYYY') AS parsed_date_european,
    TO_DATE('Dec 25, 2024', 'Mon DD, YYYY') AS parsed_date_readable;

-- Checking for data quality issues with dates
SELECT
    COUNT(*) AS total_orders,
    COUNT(order_purchase_timestamp) AS orders_with_purchase_date,
    COUNT(order_approved_at) AS orders_with_approval_date,
    COUNT(order_delivered_customer_date) AS orders_with_delivery_date,
    -- Calculate completion rates
    ROUND(COUNT(order_approved_at) * 100.0 / COUNT(*), 2) AS approval_rate_percent,
    ROUND(COUNT(order_delivered_customer_date) * 100.0 / COUNT(*), 2) AS delivery_rate_percent
FROM olist_sales_data_set.olist_orders_dataset;

-- =============================================================================
-- PRACTICAL BUSINESS INSIGHTS
-- =============================================================================

-- Insight 1: Peak Shopping Hours
-- When are customers most active?

SELECT
    EXTRACT(HOUR FROM order_purchase_timestamp) AS hour_of_day,
    COUNT(*) AS orders_count,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2) AS percentage
FROM olist_sales_data_set.olist_orders_dataset
WHERE order_purchase_timestamp IS NOT NULL
GROUP BY EXTRACT(HOUR FROM order_purchase_timestamp)
ORDER BY hour_of_day;

-- Insight 2: Seasonal Revenue Patterns
-- Which quarters are strongest for business?

SELECT
    EXTRACT(YEAR FROM o.order_purchase_timestamp) AS year,
    EXTRACT(QUARTER FROM o.order_purchase_timestamp) AS quarter,
    COUNT(DISTINCT o.order_id) AS total_orders,
    SUM(oi.price) AS total_revenue,
    AVG(oi.price) AS avg_order_value
FROM olist_sales_data_set.olist_orders_dataset o
JOIN olist_sales_data_set.olist_order_items_dataset oi ON o.order_id = oi.order_id
WHERE o.order_purchase_timestamp IS NOT NULL
    AND o.order_status NOT IN ('cancelled', 'unavailable')
GROUP BY
    EXTRACT(YEAR FROM o.order_purchase_timestamp),
    EXTRACT(QUARTER FROM o.order_purchase_timestamp)
ORDER BY year, quarter;

-- Nigerian Business Context Notes:
-- 1. In Nigeria, peak shopping seasons include:
--    - December (Christmas season)
--    - April/May (Easter and salary payments)
--    - September (back-to-school season)
-- 2. Consider Ramadan periods for Muslim customers
-- 3. Account for rainy season (May-October) vs dry season logistics

-- =============================================================================
-- NEXT: Part 2 will cover advanced date arithmetic and business metrics
-- =============================================================================