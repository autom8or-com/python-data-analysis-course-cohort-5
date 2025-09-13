-- ====================================================================
-- WEEK 4: AGGREGATIONS & SUMMARY STATISTICS - PART 1: BASIC AGGREGATIONS
-- Thursday SQL Class - September 4, 2025
-- Business Context: Sales Performance Analysis (Excel SUMIF/COUNTIF concepts)
-- ====================================================================

-- LEARNING OBJECTIVES:
-- 1. Master basic aggregate functions (COUNT, SUM, AVG, MIN, MAX)
-- 2. Understand GROUP BY for business categorization
-- 3. Bridge from Excel SUMIF/COUNTIF to SQL aggregations
-- 4. Analyze real e-commerce data for business insights

-- ====================================================================
-- SECTION 1: FROM EXCEL TO SQL - CONCEPTUAL BRIDGE
-- ====================================================================

/* 
EXCEL vs SQL AGGREGATION COMPARISON:
Excel SUMIF(range, criteria, sum_range) → SQL SUM() with WHERE/GROUP BY
Excel COUNTIF(range, criteria) → SQL COUNT() with WHERE/GROUP BY  
Excel AVERAGEIF(range, criteria, avg_range) → SQL AVG() with WHERE/GROUP BY
*/

-- ====================================================================
-- SECTION 2: BASIC AGGREGATE FUNCTIONS
-- ====================================================================

-- 2.1 COUNT - How many records meet our criteria?
-- Business Question: How many orders do we have in total?
SELECT COUNT(*) as total_orders
FROM olist_sales_data_set.olist_orders_dataset;

-- Business Question: How many delivered orders do we have?
-- (Excel equivalent: COUNTIF(status_column, "delivered"))
SELECT COUNT(*) as delivered_orders
FROM olist_sales_data_set.olist_orders_dataset
WHERE order_status = 'delivered';

-- 2.2 SUM - What's the total value?
-- Business Question: What's our total revenue from delivered orders?
-- (Excel equivalent: SUMIF(status_column, "delivered", price_column))
SELECT SUM(oi.price) as total_revenue
FROM olist_sales_data_set.olist_order_items_dataset oi
JOIN olist_sales_data_set.olist_orders_dataset o ON oi.order_id = o.order_id
WHERE o.order_status = 'delivered';

-- 2.3 AVG - What's the typical value?
-- Business Question: What's our average order value for delivered orders?
-- (Excel equivalent: AVERAGEIF(status_column, "delivered", price_column))
SELECT AVG(oi.price) as avg_order_value
FROM olist_sales_data_set.olist_order_items_dataset oi
JOIN olist_sales_data_set.olist_orders_dataset o ON oi.order_id = o.order_id
WHERE o.order_status = 'delivered';

-- 2.4 MIN and MAX - What are the extremes?
-- Business Question: What are our lowest and highest order values?
SELECT 
    MIN(price) as lowest_order_value,
    MAX(price) as highest_order_value
FROM olist_sales_data_set.olist_order_items_dataset;

-- 2.5 Multiple aggregations in one query
-- Business Question: Give me a complete summary of our order values
SELECT 
    COUNT(*) as total_items,
    SUM(price) as total_revenue,
    AVG(price) as average_price,
    MIN(price) as minimum_price,
    MAX(price) as maximum_price,
    AVG(freight_value) as avg_shipping_cost
FROM olist_sales_data_set.olist_order_items_dataset oi
JOIN olist_sales_data_set.olist_orders_dataset o ON oi.order_id = o.order_id
WHERE o.order_status = 'delivered';

-- ====================================================================
-- SECTION 3: GROUP BY - CATEGORIZING YOUR BUSINESS DATA
-- ====================================================================

-- 3.1 Single column grouping - Excel SUMIF equivalent
-- Business Question: How much revenue does each order status generate?
-- (This is like having multiple SUMIF formulas, one for each status)
SELECT 
    order_status,
    COUNT(*) as order_count,
    SUM(oi.price) as total_revenue,
    AVG(oi.price) as avg_order_value
FROM olist_sales_data_set.olist_orders_dataset o
JOIN olist_sales_data_set.olist_order_items_dataset oi ON o.order_id = oi.order_id
GROUP BY order_status
ORDER BY total_revenue DESC;

-- 3.2 Regional analysis - Key business insight
-- Business Question: Which states generate the most revenue?
-- (Nigerian business context: Like analyzing sales by Lagos, Abuja, Kano, etc.)
SELECT 
    c.customer_state as state,
    COUNT(DISTINCT o.order_id) as total_orders,
    SUM(oi.price) as total_revenue,
    AVG(oi.price) as avg_order_value,
    COUNT(DISTINCT c.customer_id) as unique_customers
FROM olist_sales_data_set.olist_customers_dataset c
JOIN olist_sales_data_set.olist_orders_dataset o ON c.customer_id = o.customer_id
JOIN olist_sales_data_set.olist_order_items_dataset oi ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered'
GROUP BY c.customer_state
ORDER BY total_revenue DESC
LIMIT 10;

-- 3.3 Product performance analysis
-- Business Question: Which product categories perform best?
SELECT 
    t.product_category_name_english as category,
    COUNT(oi.order_id) as total_orders,
    SUM(oi.price) as total_revenue,
    AVG(oi.price) as avg_price,
    MIN(oi.price) as min_price,
    MAX(oi.price) as max_price
FROM olist_sales_data_set.olist_order_items_dataset oi
JOIN olist_sales_data_set.olist_products_dataset p ON oi.product_id = p.product_id
JOIN olist_sales_data_set.product_category_name_translation t ON p.product_category_name = t.product_category_name
GROUP BY t.product_category_name_english
ORDER BY total_revenue DESC
LIMIT 15;

-- ====================================================================
-- SECTION 4: PRACTICAL BUSINESS ANALYSIS EXERCISES
-- ====================================================================

-- 4.1 Monthly sales trend analysis
-- Business Question: How do our sales vary by month?
SELECT 
    EXTRACT(YEAR FROM o.order_purchase_timestamp) as year,
    EXTRACT(MONTH FROM o.order_purchase_timestamp) as month,
    COUNT(DISTINCT o.order_id) as orders,
    SUM(oi.price) as revenue,
    AVG(oi.price) as avg_order_value
FROM olist_sales_data_set.olist_orders_dataset o
JOIN olist_sales_data_set.olist_order_items_dataset oi ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered'
  AND o.order_purchase_timestamp IS NOT NULL
GROUP BY 
    EXTRACT(YEAR FROM o.order_purchase_timestamp),
    EXTRACT(MONTH FROM o.order_purchase_timestamp)
ORDER BY year, month;

-- 4.2 Payment method analysis
-- Business Question: How do different payment methods perform?
-- (Nigerian context: Cash, bank transfer, cards, mobile money)
SELECT 
    payment_type,
    COUNT(*) as transaction_count,
    SUM(payment_value) as total_value,
    AVG(payment_value) as avg_transaction_value,
    AVG(payment_installments) as avg_installments
FROM olist_sales_data_set.olist_order_payments_dataset
GROUP BY payment_type
ORDER BY total_value DESC;

-- 4.3 Customer satisfaction by category
-- Business Question: Which product categories have the highest customer satisfaction?
SELECT 
    t.product_category_name_english as category,
    COUNT(r.review_id) as total_reviews,
    AVG(r.review_score) as avg_rating,
    COUNT(CASE WHEN r.review_score >= 4 THEN 1 END) as positive_reviews,
    ROUND(
        COUNT(CASE WHEN r.review_score >= 4 THEN 1 END) * 100.0 / COUNT(r.review_id), 
        2
    ) as positive_review_percentage
FROM olist_sales_data_set.olist_order_reviews_dataset r
JOIN olist_sales_data_set.olist_orders_dataset o ON r.order_id = o.order_id
JOIN olist_sales_data_set.olist_order_items_dataset oi ON o.order_id = oi.order_id
JOIN olist_sales_data_set.olist_products_dataset p ON oi.product_id = p.product_id
JOIN olist_sales_data_set.product_category_name_translation t ON p.product_category_name = t.product_category_name
WHERE r.review_score IS NOT NULL
GROUP BY t.product_category_name_english
HAVING COUNT(r.review_id) >= 100  -- Only categories with sufficient reviews
ORDER BY avg_rating DESC;

-- ====================================================================
-- KEY TAKEAWAYS FOR BUSINESS ANALYSTS:
-- ====================================================================

/*
1. COUNT(*) tells us volume - how many customers, orders, products
2. SUM() gives us totals - revenue, costs, quantities
3. AVG() shows typical performance - average order value, ratings
4. MIN/MAX reveal outliers and ranges in your data
5. GROUP BY categorizes data like Excel pivot tables
6. These replace multiple Excel SUMIF/COUNTIF formulas with single queries

NEXT CLASS: We'll add HAVING clause, multiple grouping columns, and window functions!
*/