-- Week 7: SQL JOINs - INNER JOIN Basics
-- PORA Academy Cohort 5 - Phase 2
-- Topic: Understanding INNER JOIN with Olist E-commerce Data

/* ========================================
   PART 1: TABLE EXPLORATION
   Understanding the data before joining
   ======================================== */

-- 1.1: View customers table structure
SELECT *
FROM olist_sales_data_set.olist_customers_dataset
LIMIT 5;

-- 1.2: View orders table structure
SELECT *
FROM olist_sales_data_set.olist_orders_dataset
LIMIT 5;

-- 1.3: Count records in each table
SELECT
    'Customers' AS table_name,
    COUNT(*) AS record_count
FROM olist_sales_data_set.olist_customers_dataset
UNION ALL
SELECT
    'Orders' AS table_name,
    COUNT(*) AS record_count
FROM olist_sales_data_set.olist_orders_dataset;

/* ========================================
   PART 2: BASIC INNER JOIN
   Combining orders with customer info
   ======================================== */

-- 2.1: Simple INNER JOIN - Orders with customer city
SELECT
    o.order_id,
    o.order_purchase_timestamp::date AS purchase_date,
    o.order_status,
    c.customer_city,
    c.customer_state
FROM olist_sales_data_set.olist_orders_dataset o
INNER JOIN olist_sales_data_set.olist_customers_dataset c
    ON o.customer_id = c.customer_id
ORDER BY o.order_purchase_timestamp DESC
LIMIT 20;

-- 2.2: INNER JOIN with filtering - Delivered orders from São Paulo
SELECT
    o.order_id,
    o.order_purchase_timestamp::date AS purchase_date,
    c.customer_city,
    c.customer_state,
    o.order_status
FROM olist_sales_data_set.olist_orders_dataset o
INNER JOIN olist_sales_data_set.olist_customers_dataset c
    ON o.customer_id = c.customer_id
WHERE c.customer_state = 'SP'
    AND o.order_status = 'delivered'
ORDER BY o.order_purchase_timestamp DESC
LIMIT 20;

-- 2.3: INNER JOIN with calculations - Add delivery time
SELECT
    o.order_id,
    c.customer_city,
    c.customer_state,
    o.order_purchase_timestamp::date AS purchase_date,
    o.order_delivered_customer_date::date AS delivery_date,
    o.order_delivered_customer_date::date - o.order_purchase_timestamp::date AS delivery_days
FROM olist_sales_data_set.olist_orders_dataset o
INNER JOIN olist_sales_data_set.olist_customers_dataset c
    ON o.customer_id = c.customer_id
WHERE o.order_status = 'delivered'
    AND o.order_delivered_customer_date IS NOT NULL
ORDER BY delivery_days DESC
LIMIT 20;

/* ========================================
   PART 3: THREE-TABLE INNER JOIN
   Orders → Items → Products
   ======================================== */

-- 3.1: Basic three-table join - Orders with product categories
SELECT
    o.order_id,
    o.order_purchase_timestamp::date AS purchase_date,
    oi.order_item_id,
    p.product_category_name,
    oi.price,
    oi.freight_value
FROM olist_sales_data_set.olist_orders_dataset o
INNER JOIN olist_sales_data_set.olist_order_items_dataset oi
    ON o.order_id = oi.order_id
INNER JOIN olist_sales_data_set.olist_products_dataset p
    ON oi.product_id = p.product_id
WHERE o.order_status = 'delivered'
ORDER BY o.order_purchase_timestamp DESC
LIMIT 30;

-- 3.2: Multi-table join with aggregation - Total order value by category
SELECT
    p.product_category_name,
    COUNT(DISTINCT o.order_id) AS total_orders,
    COUNT(oi.order_item_id) AS total_items,
    ROUND(SUM(oi.price), 2) AS total_revenue,
    ROUND(AVG(oi.price), 2) AS avg_item_price
FROM olist_sales_data_set.olist_orders_dataset o
INNER JOIN olist_sales_data_set.olist_order_items_dataset oi
    ON o.order_id = oi.order_id
INNER JOIN olist_sales_data_set.olist_products_dataset p
    ON oi.product_id = p.product_id
WHERE o.order_status = 'delivered'
    AND p.product_category_name IS NOT NULL
GROUP BY p.product_category_name
ORDER BY total_revenue DESC
LIMIT 20;

/* ========================================
   PART 4: FOUR-TABLE INNER JOIN
   Complete customer journey analysis
   ======================================== */

-- 4.1: Orders with customers, items, and products
SELECT
    c.customer_city,
    c.customer_state,
    o.order_id,
    o.order_purchase_timestamp::date AS purchase_date,
    p.product_category_name,
    oi.price,
    oi.freight_value,
    (oi.price + oi.freight_value) AS total_item_cost
FROM olist_sales_data_set.olist_customers_dataset c
INNER JOIN olist_sales_data_set.olist_orders_dataset o
    ON c.customer_id = o.customer_id
INNER JOIN olist_sales_data_set.olist_order_items_dataset oi
    ON o.order_id = oi.order_id
INNER JOIN olist_sales_data_set.olist_products_dataset p
    ON oi.product_id = p.product_id
WHERE o.order_status = 'delivered'
    AND c.customer_state = 'RJ'  -- Rio de Janeiro
ORDER BY o.order_purchase_timestamp DESC
LIMIT 30;

-- 4.2: Revenue analysis by customer state and product category
SELECT
    c.customer_state,
    p.product_category_name,
    COUNT(DISTINCT o.order_id) AS order_count,
    ROUND(SUM(oi.price), 2) AS total_revenue
FROM olist_sales_data_set.olist_customers_dataset c
INNER JOIN olist_sales_data_set.olist_orders_dataset o
    ON c.customer_id = o.customer_id
INNER JOIN olist_sales_data_set.olist_order_items_dataset oi
    ON o.order_id = oi.order_id
INNER JOIN olist_sales_data_set.olist_products_dataset p
    ON oi.product_id = p.product_id
WHERE o.order_status = 'delivered'
    AND p.product_category_name IS NOT NULL
GROUP BY c.customer_state, p.product_category_name
HAVING SUM(oi.price) > 1000
ORDER BY c.customer_state, total_revenue DESC
LIMIT 50;

/* ========================================
   PART 5: INNER JOIN WITH SELLERS
   Analyzing seller performance
   ======================================== */

-- 5.1: Orders with seller location information
SELECT
    o.order_id,
    o.order_purchase_timestamp::date AS purchase_date,
    s.seller_city,
    s.seller_state,
    oi.price,
    p.product_category_name
FROM olist_sales_data_set.olist_orders_dataset o
INNER JOIN olist_sales_data_set.olist_order_items_dataset oi
    ON o.order_id = oi.order_id
INNER JOIN olist_sales_data_set.olist_sellers_dataset s
    ON oi.seller_id = s.seller_id
INNER JOIN olist_sales_data_set.olist_products_dataset p
    ON oi.product_id = p.product_id
WHERE o.order_status = 'delivered'
ORDER BY o.order_purchase_timestamp DESC
LIMIT 25;

-- 5.2: Top performing sellers by state
SELECT
    s.seller_state,
    s.seller_city,
    COUNT(DISTINCT oi.order_id) AS total_orders,
    COUNT(oi.order_item_id) AS total_items_sold,
    ROUND(SUM(oi.price), 2) AS total_revenue,
    ROUND(AVG(oi.price), 2) AS avg_item_price
FROM olist_sales_data_set.olist_sellers_dataset s
INNER JOIN olist_sales_data_set.olist_order_items_dataset oi
    ON s.seller_id = oi.seller_id
INNER JOIN olist_sales_data_set.olist_orders_dataset o
    ON oi.order_id = o.order_id
WHERE o.order_status = 'delivered'
GROUP BY s.seller_state, s.seller_city
HAVING COUNT(DISTINCT oi.order_id) >= 10
ORDER BY total_revenue DESC
LIMIT 25;

/* ========================================
   PRACTICE EXERCISES
   Try these on your own!
   ======================================== */

-- EXERCISE 1: Customer and Seller Location Analysis
-- Write a query to show orders where customer and seller are in the SAME state
-- Include: order_id, customer_state, seller_state, customer_city, seller_city, and product price
-- Hint: Join customers → orders → order_items → sellers

-- EXERCISE 2: High-Value Orders Analysis
-- Find orders with total value > 500 (sum of all items in the order)
-- Include: order_id, customer_state, total_order_value, number_of_items
-- Hint: Use SUM and COUNT with GROUP BY

-- EXERCISE 3: Product Category Performance by State
-- Calculate total revenue and average order value for each product category in each state
-- Only include categories with at least 20 orders
-- Hint: Multi-table join with GROUP BY and HAVING

/* ========================================
   KEY LEARNINGS - INNER JOIN
   ======================================== */

/*
1. INNER JOIN returns only matching records from both tables
2. Always specify the join condition with ON clause
3. Use table aliases (o, c, oi, p, s) for readability
4. You can chain multiple INNER JOINs together
5. WHERE filters AFTER the join is performed
6. GROUP BY and aggregate functions work with joined data
7. Use DISTINCT COUNT to avoid counting duplicates from one-to-many relationships
8. Join order affects readability but not results (optimizer handles it)
*/
