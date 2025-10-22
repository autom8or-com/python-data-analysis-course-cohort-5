/*
================================================================================
WEEK 10 - THURSDAY SQL LECTURE
Views and Materialized Views for Business Logic
================================================================================

LEARNING OBJECTIVES:
- Create and manage SQL views for complex business logic
- Understand view security and access control
- Implement materialized views for performance optimization
- Design reusable view patterns for inventory management

BUSINESS CONTEXT:
As Lagos-based e-commerce platforms like Jumia scale operations, repeatedly
writing complex queries for common business questions becomes inefficient and
error-prone. Views encapsulate business logic into reusable database objects,
ensuring consistent calculations and simplifying reporting for stakeholders.

DURATION: 45 minutes
================================================================================
*/

-- ============================================================================
-- PART 1: UNDERSTANDING VIEWS (15 minutes)
-- ============================================================================

/*
WHAT IS A VIEW?
A view is a virtual table based on the result of a SELECT query.
It doesn't store data itself - it's a saved query that runs each time you access it.

BENEFITS:
✓ Simplify complex queries
✓ Encapsulate business logic
✓ Provide security/access control
✓ Present data in different formats
✓ Maintain consistency across reports
*/

-- EXAMPLE 1: Simple View - Product Catalog with English Names
-- Business need: Marketing team needs product catalog with translated categories

CREATE OR REPLACE VIEW vw_product_catalog AS
SELECT
    p.product_id,
    p.product_category_name as category_code,
    COALESCE(pct.product_category_name_english, 'uncategorized') as category_name,
    p.product_weight_g,
    p.product_length_cm,
    p.product_height_cm,
    p.product_width_cm,
    -- Calculated field: Product volume
    (p.product_length_cm * p.product_height_cm * p.product_width_cm) as volume_cm3,
    -- Calculated field: Weight category
    CASE
        WHEN p.product_weight_g < 500 THEN 'Light'
        WHEN p.product_weight_g < 2000 THEN 'Medium'
        WHEN p.product_weight_g < 10000 THEN 'Heavy'
        ELSE 'Very Heavy'
    END as weight_category
FROM olist_sales_data_set.olist_products_dataset p
LEFT JOIN olist_sales_data_set.product_category_name_translation pct
    ON p.product_category_name = pct.product_category_name;

-- Using the view is simple - just like querying a table!
SELECT
    category_name,
    weight_category,
    COUNT(*) as product_count,
    AVG(volume_cm3) as avg_volume,
    AVG(product_weight_g) as avg_weight
FROM vw_product_catalog
GROUP BY category_name, weight_category
ORDER BY category_name, weight_category;

-- The view hides complexity - no joins needed in queries!


-- EXAMPLE 2: Complex View - Customer Purchase History
-- Business need: Customer service needs quick access to customer history

CREATE OR REPLACE VIEW vw_customer_purchase_history AS
SELECT
    c.customer_id,
    c.customer_city,
    c.customer_state,
    c.customer_zip_code_prefix,
    -- Order metrics
    COUNT(DISTINCT o.order_id) as total_orders,
    COUNT(DISTINCT CASE WHEN o.order_status = 'delivered' THEN o.order_id END) as delivered_orders,
    COUNT(DISTINCT CASE WHEN o.order_status = 'canceled' THEN o.order_id END) as canceled_orders,
    -- Date metrics
    MIN(o.order_purchase_timestamp) as first_order_date,
    MAX(o.order_purchase_timestamp) as last_order_date,
    -- Financial metrics
    COALESCE(SUM(oi.price), 0) as lifetime_value,
    COALESCE(AVG(oi.price), 0) as avg_item_value,
    -- Product diversity
    COUNT(DISTINCT oi.product_id) as unique_products_bought,
    COUNT(DISTINCT p.product_category_name) as unique_categories,
    -- Seller diversity
    COUNT(DISTINCT oi.seller_id) as unique_sellers,
    -- Review behavior
    COUNT(DISTINCT r.review_id) as total_reviews,
    AVG(r.review_score) as avg_review_score
FROM olist_sales_data_set.olist_customers_dataset c
LEFT JOIN olist_sales_data_set.olist_orders_dataset o
    ON c.customer_id = o.customer_id
LEFT JOIN olist_sales_data_set.olist_order_items_dataset oi
    ON o.order_id = oi.order_id
LEFT JOIN olist_sales_data_set.olist_products_dataset p
    ON oi.product_id = p.product_id
LEFT JOIN olist_sales_data_set.olist_order_reviews_dataset r
    ON o.order_id = r.order_id
GROUP BY c.customer_id, c.customer_city, c.customer_state, c.customer_zip_code_prefix;

-- Now customer analysis is one simple query!
SELECT
    customer_state,
    COUNT(*) as customer_count,
    AVG(lifetime_value) as avg_ltv,
    AVG(total_orders) as avg_orders,
    AVG(avg_review_score) as avg_satisfaction
FROM vw_customer_purchase_history
WHERE total_orders > 0
GROUP BY customer_state
ORDER BY avg_ltv DESC
LIMIT 10;

-- Find high-value customers for loyalty program
SELECT
    customer_id,
    customer_city,
    customer_state,
    total_orders,
    lifetime_value,
    avg_review_score,
    unique_categories
FROM vw_customer_purchase_history
WHERE lifetime_value > 1000
    AND total_orders >= 5
    AND avg_review_score >= 4
ORDER BY lifetime_value DESC
LIMIT 20;


-- EXAMPLE 3: Seller Performance Dashboard View
-- Business need: Marketplace management needs seller metrics

CREATE OR REPLACE VIEW vw_seller_performance AS
SELECT
    s.seller_id,
    s.seller_city,
    s.seller_state,
    -- Sales metrics
    COUNT(DISTINCT oi.order_id) as total_orders,
    COUNT(DISTINCT oi.product_id) as unique_products,
    SUM(oi.price) as total_revenue,
    AVG(oi.price) as avg_item_price,
    -- Shipping metrics
    SUM(oi.freight_value) as total_freight_charged,
    AVG(oi.freight_value) as avg_freight_per_item,
    -- Performance metrics
    COUNT(DISTINCT o.customer_id) as unique_customers,
    COUNT(DISTINCT CASE WHEN o.order_status = 'delivered' THEN o.order_id END) as delivered_orders,
    COUNT(DISTINCT CASE WHEN o.order_status = 'canceled' THEN o.order_id END) as canceled_orders,
    -- Calculate delivery performance
    AVG(EXTRACT(EPOCH FROM (o.order_delivered_customer_date - o.order_purchase_timestamp))/86400) as avg_delivery_days,
    -- Geographic reach
    COUNT(DISTINCT c.customer_state) as states_served,
    COUNT(DISTINCT c.customer_city) as cities_served,
    -- Customer satisfaction
    AVG(r.review_score) as avg_customer_rating,
    COUNT(DISTINCT r.review_id) as total_reviews
FROM olist_sales_data_set.olist_sellers_dataset s
LEFT JOIN olist_sales_data_set.olist_order_items_dataset oi
    ON s.seller_id = oi.seller_id
LEFT JOIN olist_sales_data_set.olist_orders_dataset o
    ON oi.order_id = o.order_id
LEFT JOIN olist_sales_data_set.olist_customers_dataset c
    ON o.customer_id = c.customer_id
LEFT JOIN olist_sales_data_set.olist_order_reviews_dataset r
    ON o.order_id = r.order_id
WHERE o.order_status IS NOT NULL
GROUP BY s.seller_id, s.seller_city, s.seller_state;

-- Top performing sellers
SELECT
    seller_id,
    seller_city,
    seller_state,
    total_orders,
    total_revenue,
    avg_customer_rating,
    avg_delivery_days,
    states_served
FROM vw_seller_performance
WHERE total_orders >= 10
ORDER BY total_revenue DESC
LIMIT 20;

-- Sellers needing improvement
SELECT
    seller_id,
    seller_city,
    total_orders,
    avg_customer_rating,
    avg_delivery_days,
    canceled_orders,
    ROUND(100.0 * canceled_orders / NULLIF(total_orders, 0), 2) as cancellation_rate
FROM vw_seller_performance
WHERE total_orders >= 10
    AND (avg_customer_rating < 3.5 OR avg_delivery_days > 30)
ORDER BY avg_customer_rating ASC;


-- ============================================================================
-- PART 2: VIEW SECURITY AND ACCESS CONTROL (10 minutes)
-- ============================================================================

/*
VIEWS FOR SECURITY:
Views can hide sensitive columns and restrict row access, providing different
levels of data visibility to different user groups.
*/

-- EXAMPLE 1: Customer Data - Public vs Private Views

-- Public view: Safe for customer service representatives
CREATE OR REPLACE VIEW vw_customer_service_info AS
SELECT
    c.customer_id,
    c.customer_city,
    c.customer_state,
    -- NO zip code (could be PII)
    o.order_id,
    o.order_status,
    o.order_purchase_timestamp,
    -- Order value without detailed pricing
    SUM(oi.price) as order_total
FROM olist_sales_data_set.olist_customers_dataset c
JOIN olist_sales_data_set.olist_orders_dataset o
    ON c.customer_id = o.customer_id
JOIN olist_sales_data_set.olist_order_items_dataset oi
    ON o.order_id = oi.order_id
GROUP BY c.customer_id, c.customer_city, c.customer_state,
         o.order_id, o.order_status, o.order_purchase_timestamp;

-- Private view: Full details for analytics team
CREATE OR REPLACE VIEW vw_customer_full_profile AS
SELECT
    c.customer_id,
    c.customer_unique_id,
    c.customer_city,
    c.customer_state,
    c.customer_zip_code_prefix,  -- Full details for analytics
    cph.total_orders,
    cph.lifetime_value,
    cph.avg_review_score
FROM olist_sales_data_set.olist_customers_dataset c
LEFT JOIN vw_customer_purchase_history cph
    ON c.customer_id = cph.customer_id;


-- EXAMPLE 2: Financial Data - Filtered by Region

-- Regional manager view: Only see their region's data
CREATE OR REPLACE VIEW vw_sp_region_sales AS
SELECT
    s.seller_id,
    s.seller_city,
    oi.order_id,
    oi.product_id,
    oi.price,
    oi.freight_value,
    o.order_purchase_timestamp
FROM olist_sales_data_set.olist_sellers_dataset s
JOIN olist_sales_data_set.olist_order_items_dataset oi
    ON s.seller_id = oi.seller_id
JOIN olist_sales_data_set.olist_orders_dataset o
    ON oi.order_id = o.order_id
WHERE s.seller_state = 'SP';  -- São Paulo region only

-- Warehouse view: Only inventory-relevant data
CREATE OR REPLACE VIEW vw_inventory_operations AS
SELECT
    p.product_id,
    pct.product_category_name_english as category,
    p.product_weight_g,
    p.product_length_cm,
    p.product_height_cm,
    p.product_width_cm,
    COUNT(DISTINCT oi.order_id) as order_count,
    SUM(oi.price) as total_value,
    MAX(o.order_purchase_timestamp) as last_order_date
FROM olist_sales_data_set.olist_products_dataset p
LEFT JOIN olist_sales_data_set.product_category_name_translation pct
    ON p.product_category_name = pct.product_category_name
LEFT JOIN olist_sales_data_set.olist_order_items_dataset oi
    ON p.product_id = oi.product_id
LEFT JOIN olist_sales_data_set.olist_orders_dataset o
    ON oi.order_id = o.order_id
GROUP BY p.product_id, pct.product_category_name_english,
         p.product_weight_g, p.product_length_cm, p.product_height_cm, p.product_width_cm;
-- Note: NO pricing details, NO customer information, NO seller information


-- ============================================================================
-- PART 3: MATERIALIZED VIEWS FOR PERFORMANCE (10 minutes)
-- ============================================================================

/*
MATERIALIZED VIEWS:
Unlike regular views (which run the query every time), materialized views
STORE the query results physically. This dramatically improves performance
for complex aggregations, but requires periodic refreshing.

PostgreSQL Syntax:
CREATE MATERIALIZED VIEW view_name AS query;
REFRESH MATERIALIZED VIEW view_name;

Note: PostgreSQL supports materialized views. Other databases may use
different approaches (SQL Server: Indexed Views, Oracle: Materialized Views)
*/

-- EXAMPLE 1: Daily Sales Summary (Expensive to calculate repeatedly)

CREATE MATERIALIZED VIEW mv_daily_sales_summary AS
SELECT
    DATE(o.order_purchase_timestamp) as sales_date,
    COUNT(DISTINCT o.order_id) as total_orders,
    COUNT(DISTINCT o.customer_id) as unique_customers,
    COUNT(DISTINCT oi.product_id) as unique_products_sold,
    COUNT(DISTINCT oi.seller_id) as active_sellers,
    SUM(oi.price) as daily_revenue,
    AVG(oi.price) as avg_item_price,
    SUM(oi.freight_value) as total_freight_revenue
FROM olist_sales_data_set.olist_orders_dataset o
JOIN olist_sales_data_set.olist_order_items_dataset oi
    ON o.order_id = oi.order_id
WHERE o.order_purchase_timestamp IS NOT NULL
GROUP BY DATE(o.order_purchase_timestamp);

-- Query the materialized view (VERY fast - no joins needed!)
SELECT
    sales_date,
    total_orders,
    daily_revenue,
    ROUND(daily_revenue::numeric / total_orders, 2) as avg_order_value
FROM mv_daily_sales_summary
ORDER BY sales_date DESC
LIMIT 30;

-- Calculate month-over-month growth
SELECT
    TO_CHAR(sales_date, 'YYYY-MM') as month,
    SUM(total_orders) as monthly_orders,
    SUM(daily_revenue) as monthly_revenue,
    AVG(unique_customers) as avg_daily_customers
FROM mv_daily_sales_summary
GROUP BY TO_CHAR(sales_date, 'YYYY-MM')
ORDER BY month DESC;

-- Refresh the materialized view (run nightly via scheduled job)
-- REFRESH MATERIALIZED VIEW mv_daily_sales_summary;


-- EXAMPLE 2: Product Category Performance (Complex calculations)

CREATE MATERIALIZED VIEW mv_category_performance AS
SELECT
    COALESCE(pct.product_category_name_english, 'uncategorized') as category,
    COUNT(DISTINCT p.product_id) as total_products,
    COUNT(DISTINCT oi.order_id) as total_orders,
    COUNT(DISTINCT oi.seller_id) as seller_count,
    SUM(oi.price) as total_revenue,
    AVG(oi.price) as avg_price,
    SUM(oi.freight_value) as total_freight,
    -- Customer metrics
    COUNT(DISTINCT o.customer_id) as unique_customers,
    COUNT(DISTINCT o.customer_id)::float / NULLIF(COUNT(DISTINCT oi.order_id), 0) as customers_per_order,
    -- Review metrics
    COUNT(DISTINCT r.review_id) as total_reviews,
    AVG(r.review_score) as avg_rating,
    -- Product physical characteristics
    AVG(p.product_weight_g) as avg_weight_g,
    AVG(p.product_length_cm * p.product_height_cm * p.product_width_cm) as avg_volume_cm3
FROM olist_sales_data_set.olist_products_dataset p
LEFT JOIN olist_sales_data_set.product_category_name_translation pct
    ON p.product_category_name = pct.product_category_name
LEFT JOIN olist_sales_data_set.olist_order_items_dataset oi
    ON p.product_id = oi.product_id
LEFT JOIN olist_sales_data_set.olist_orders_dataset o
    ON oi.order_id = o.order_id
LEFT JOIN olist_sales_data_set.olist_order_reviews_dataset r
    ON o.order_id = r.order_id
GROUP BY COALESCE(pct.product_category_name_english, 'uncategorized');

-- Fast queries against materialized view
SELECT
    category,
    total_revenue,
    total_orders,
    avg_rating,
    seller_count
FROM mv_category_performance
ORDER BY total_revenue DESC
LIMIT 15;

-- Category comparison
SELECT
    category,
    ROUND(avg_price::numeric, 2) as avg_price,
    ROUND(avg_weight_g::numeric, 0) as avg_weight_g,
    total_products,
    seller_count,
    ROUND(avg_rating::numeric, 2) as avg_rating
FROM mv_category_performance
WHERE total_orders > 100
ORDER BY avg_rating DESC;


-- EXAMPLE 3: Seller Inventory Snapshot

CREATE MATERIALIZED VIEW mv_seller_inventory_snapshot AS
SELECT
    s.seller_id,
    s.seller_city,
    s.seller_state,
    COALESCE(pct.product_category_name_english, 'uncategorized') as category,
    COUNT(DISTINCT p.product_id) as product_count,
    COUNT(DISTINCT oi.order_id) as order_count,
    SUM(oi.price) as category_revenue,
    AVG(oi.price) as avg_item_price,
    AVG(p.product_weight_g) as avg_product_weight,
    MAX(o.order_purchase_timestamp) as last_sale_date
FROM olist_sales_data_set.olist_sellers_dataset s
JOIN olist_sales_data_set.olist_order_items_dataset oi
    ON s.seller_id = oi.seller_id
JOIN olist_sales_data_set.olist_products_dataset p
    ON oi.product_id = p.product_id
LEFT JOIN olist_sales_data_set.product_category_name_translation pct
    ON p.product_category_name = pct.product_category_name
JOIN olist_sales_data_set.olist_orders_dataset o
    ON oi.order_id = o.order_id
GROUP BY s.seller_id, s.seller_city, s.seller_state,
         COALESCE(pct.product_category_name_english, 'uncategorized');

-- Analyze seller category diversification
SELECT
    seller_id,
    seller_city,
    seller_state,
    COUNT(DISTINCT category) as category_count,
    SUM(category_revenue) as total_revenue,
    STRING_AGG(category, ', ' ORDER BY category_revenue DESC) as top_categories
FROM mv_seller_inventory_snapshot
GROUP BY seller_id, seller_city, seller_state
HAVING COUNT(DISTINCT category) >= 3
ORDER BY total_revenue DESC
LIMIT 20;


-- ============================================================================
-- PART 4: VIEW BEST PRACTICES AND PATTERNS (10 minutes)
-- ============================================================================

/*
WHEN TO USE VIEWS vs MATERIALIZED VIEWS

USE REGULAR VIEWS WHEN:
✓ Data changes frequently
✓ Query is relatively simple/fast
✓ Need real-time data
✓ Storage space is limited
✓ Encapsulating security logic

USE MATERIALIZED VIEWS WHEN:
✓ Complex aggregations (many joins, GROUP BY)
✓ Data doesn't change often
✓ Query performance is critical
✓ Acceptable to have slightly stale data
✓ Can schedule periodic refreshes
*/

-- BEST PRACTICE 1: Naming Conventions
-- Regular views: vw_*
-- Materialized views: mv_*
-- Temporary views: temp_vw_*

-- BEST PRACTICE 2: Documentation in Views
CREATE OR REPLACE VIEW vw_high_value_customers AS
-- Purpose: Identify customers with lifetime value > 500 for marketing campaigns
-- Owner: Marketing Analytics Team
-- Refresh: Real-time (regular view)
-- Dependencies: vw_customer_purchase_history
SELECT
    customer_id,
    customer_city,
    customer_state,
    lifetime_value,
    total_orders,
    avg_review_score,
    first_order_date,
    last_order_date,
    -- Calculate days since last order
    EXTRACT(DAYS FROM (CURRENT_TIMESTAMP - last_order_date)) as days_since_last_order,
    -- Customer segment
    CASE
        WHEN lifetime_value > 2000 THEN 'VIP'
        WHEN lifetime_value > 1000 THEN 'Gold'
        WHEN lifetime_value > 500 THEN 'Silver'
    END as customer_segment
FROM vw_customer_purchase_history
WHERE lifetime_value > 500;


-- BEST PRACTICE 3: Layered Views (Building on simpler views)

-- Base layer: Clean data
CREATE OR REPLACE VIEW vw_clean_orders AS
SELECT
    order_id,
    customer_id,
    order_status,
    order_purchase_timestamp,
    order_delivered_customer_date
FROM olist_sales_data_set.olist_orders_dataset
WHERE order_status IN ('delivered', 'shipped', 'invoiced', 'processing');

-- Middle layer: Add calculations
CREATE OR REPLACE VIEW vw_order_metrics AS
SELECT
    co.*,
    SUM(oi.price) as order_value,
    COUNT(oi.order_item_id) as item_count,
    EXTRACT(DAYS FROM (co.order_delivered_customer_date - co.order_purchase_timestamp)) as delivery_days
FROM vw_clean_orders co
JOIN olist_sales_data_set.olist_order_items_dataset oi
    ON co.order_id = oi.order_id
GROUP BY co.order_id, co.customer_id, co.order_status,
         co.order_purchase_timestamp, co.order_delivered_customer_date;

-- Top layer: Business insights
CREATE OR REPLACE VIEW vw_order_insights AS
SELECT
    *,
    CASE
        WHEN delivery_days <= 7 THEN 'Fast'
        WHEN delivery_days <= 14 THEN 'Normal'
        WHEN delivery_days <= 30 THEN 'Slow'
        ELSE 'Very Slow'
    END as delivery_speed,
    CASE
        WHEN order_value < 50 THEN 'Small'
        WHEN order_value < 200 THEN 'Medium'
        WHEN order_value < 500 THEN 'Large'
        ELSE 'Very Large'
    END as order_size_category
FROM vw_order_metrics;


-- BEST PRACTICE 4: Performance Hints in View Queries

-- Index the base tables appropriately
-- CREATE INDEX idx_orders_customer ON olist_orders_dataset(customer_id);
-- CREATE INDEX idx_order_items_order ON olist_order_items_dataset(order_id);

-- Use EXPLAIN to analyze view performance
EXPLAIN ANALYZE
SELECT * FROM vw_seller_performance
WHERE total_orders > 100;


-- ============================================================================
-- REAL-WORLD NIGERIAN E-COMMERCE SCENARIO
-- ============================================================================

/*
CASE STUDY: Building Views for Jumia-like Marketplace

Required Views for Different Stakeholders:

1. EXECUTIVE DASHBOARD:
   - Daily/Monthly GMV (Gross Merchandise Value)
   - Active sellers and products
   - Customer acquisition and retention

2. WAREHOUSE OPERATIONS:
   - Inventory levels by product/category
   - Fast-moving vs slow-moving items
   - Warehouse capacity utilization

3. SELLER PORTAL:
   - Individual seller performance
   - Payment summaries
   - Product listing performance

4. CUSTOMER SERVICE:
   - Order status and history
   - Return and refund tracking
   - Customer complaint patterns

5. MARKETING TEAM:
   - Customer segments
   - Campaign performance
   - Product recommendations
*/


-- ============================================================================
-- KEY TAKEAWAYS
-- ============================================================================

/*
1. VIEWS SIMPLIFY COMPLEXITY:
   - Encapsulate complex queries into simple interfaces
   - Ensure consistent business logic across applications
   - Reduce development time and errors

2. SECURITY THROUGH VIEWS:
   - Hide sensitive columns
   - Filter rows based on access levels
   - Provide role-based data access

3. MATERIALIZED VIEWS FOR PERFORMANCE:
   - Store query results for complex aggregations
   - Trade freshness for speed
   - Require refresh strategy (nightly, hourly, etc.)

4. VIEW DESIGN PATTERNS:
   - Use clear naming conventions (vw_*, mv_*)
   - Layer views (base → calculated → insights)
   - Document purpose, owner, and dependencies
   - Monitor and optimize view performance

5. NIGERIAN E-COMMERCE CONTEXT:
   - Views critical for scaling multi-vendor marketplaces
   - Support different stakeholder needs with targeted views
   - Balance real-time data needs with performance
   - Plan refresh schedules for materialized views during low-traffic hours
*/

-- ============================================================================
-- PRACTICE EXERCISE
-- ============================================================================

/*
CHALLENGE: Create a comprehensive seller management system with views

1. Create vw_seller_daily_sales:
   - Daily sales by seller
   - Order count, revenue, avg order value
   - Delivery performance

2. Create mv_seller_monthly_summary:
   - Month-end snapshot of seller performance
   - Categories sold, geographic reach
   - Customer satisfaction metrics

3. Create vw_underperforming_sellers:
   - Sellers with low ratings (<3.5)
   - High cancellation rates (>10%)
   - Slow delivery times (>30 days avg)

4. Create vw_seller_product_mix:
   - Product diversity by seller
   - Revenue contribution by category
   - Identify single-category vs diversified sellers

Test your views with realistic queries a marketplace manager would need!
*/
