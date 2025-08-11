-- Week 01 Thursday SQL: Business Questions and Practical Applications
-- Direct Translation of Wednesday's Python Business Analysis
-- NaijaCommerce E-commerce Insights Using SQL

-- =============================================================================
-- SECTION 1: Same Business Questions from Yesterday
-- =============================================================================

-- Yesterday's Success: You analyzed NaijaCommerce data using Python
-- Today's Goal: Answer the same business questions using SQL

-- 💼 Business Context: You're the data analyst for NaijaCommerce
-- Your manager wants insights about orders, customers, and sales performance

-- =============================================================================
-- SECTION 2: Order Analysis (Python DataFrame → SQL Table)
-- =============================================================================

-- Yesterday in Python: You explored order data using df.head(), len(df), etc.
-- Today in SQL: Same insights, database queries

-- Business Question 1: How many orders do we have in total?
SELECT COUNT(*) AS "Total Orders"
FROM olist_sales_data_set.olist_orders_dataset;

-- Business Question 2: What's our order status breakdown?
SELECT 
    order_status AS "Order Status",
    COUNT(*) AS "Number of Orders",
    ROUND(COUNT(*) * 100.0 / (
        SELECT COUNT(*) FROM olist_sales_data_set.olist_orders_dataset
    ), 2) AS "Percentage of Total"
FROM olist_sales_data_set.olist_orders_dataset
GROUP BY order_status
ORDER BY COUNT(*) DESC;

-- 💡 Python Parallel from Yesterday:
-- total_orders = len(orders_df)
-- status_breakdown = orders_df['order_status'].value_counts()

-- Business Question 3: When was our first and most recent order?
SELECT 
    MIN(order_purchase_timestamp) AS "First Order",
    MAX(order_purchase_timestamp) AS "Most Recent Order",
    MAX(order_purchase_timestamp) - MIN(order_purchase_timestamp) AS "Business Operating Period"
FROM olist_sales_data_set.olist_orders_dataset;

-- 🎯 Business Insight: Shows how long the business has been running

-- =============================================================================
-- SECTION 3: Customer Geography Analysis
-- =============================================================================

-- Yesterday in Python: You explored customer locations
-- Today in SQL: Same geographic insights

-- Business Question 4: Which states have the most customers?
SELECT 
    customer_state AS "State",
    COUNT(*) AS "Number of Customers",
    ROUND(COUNT(*) * 100.0 / (
        SELECT COUNT(*) FROM olist_sales_data_set.olist_customers_dataset
    ), 2) AS "Percentage of Customer Base"
FROM olist_sales_data_set.olist_customers_dataset
GROUP BY customer_state
ORDER BY COUNT(*) DESC
LIMIT 10;

-- Business Question 5: Which cities in São Paulo (SP) state have most customers?
SELECT 
    customer_city AS "City",
    COUNT(*) AS "Number of Customers"
FROM olist_sales_data_set.olist_customers_dataset
WHERE customer_state = 'SP'  -- Focus on São Paulo state
GROUP BY customer_city
ORDER BY COUNT(*) DESC
LIMIT 15;

-- 💡 Business Value: Helps with logistics planning and marketing focus
-- 💡 Python Parallel: df[df['customer_state'] == 'SP']['customer_city'].value_counts()

-- =============================================================================
-- SECTION 4: Payment Analysis (Real Money Insights)
-- =============================================================================

-- Yesterday in Python: You looked at numeric data and calculations
-- Today in SQL: Financial analysis using aggregation functions

-- Business Question 6: What payment methods do customers prefer?
SELECT 
    payment_type AS "Payment Method",
    COUNT(*) AS "Number of Transactions",
    ROUND(AVG(payment_value), 2) AS "Average Transaction Value",
    ROUND(SUM(payment_value), 2) AS "Total Revenue"
FROM olist_sales_data_set.olist_order_payments_dataset
GROUP BY payment_type
ORDER BY COUNT(*) DESC;

-- Business Question 7: What's our payment value distribution?
SELECT 
    MIN(payment_value) AS "Minimum Payment",
    MAX(payment_value) AS "Maximum Payment", 
    ROUND(AVG(payment_value), 2) AS "Average Payment",
    ROUND(PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY payment_value), 2) AS "Median Payment",
    COUNT(*) AS "Total Payments"
FROM olist_sales_data_set.olist_order_payments_dataset;

-- 💡 Business Insight: Understanding customer spending patterns
-- 💡 Python Parallel: df['payment_value'].describe()

-- =============================================================================
-- SECTION 5: Product Category Analysis
-- =============================================================================

-- Yesterday in Python: You explored categorical data
-- Today in SQL: Product portfolio insights

-- Business Question 8: What are our top-selling product categories?
SELECT 
    p.product_category_name AS "Product Category",
    COUNT(oi.product_id) AS "Items Sold",
    ROUND(AVG(oi.price), 2) AS "Average Item Price"
FROM olist_sales_data_set.olist_order_items_dataset oi
JOIN olist_sales_data_set.olist_products_dataset p ON oi.product_id = p.product_id
WHERE p.product_category_name IS NOT NULL
GROUP BY p.product_category_name
ORDER BY COUNT(oi.product_id) DESC
LIMIT 20;

-- Business Question 9: Which categories generate the most revenue?
SELECT 
    p.product_category_name AS "Product Category",
    COUNT(oi.product_id) AS "Items Sold",
    ROUND(SUM(oi.price), 2) AS "Total Revenue",
    ROUND(AVG(oi.price), 2) AS "Average Price"
FROM olist_sales_data_set.olist_order_items_dataset oi
JOIN olist_sales_data_set.olist_products_dataset p ON oi.product_id = p.product_id
WHERE p.product_category_name IS NOT NULL
GROUP BY p.product_category_name
ORDER BY SUM(oi.price) DESC
LIMIT 15;

-- 🎯 Business Decision Support: Which categories to focus marketing on?

-- =============================================================================
-- SECTION 6: Time-Based Analysis (Seasonal Patterns)
-- =============================================================================

-- Yesterday in Python: You worked with dates and timestamps
-- Today in SQL: Temporal business insights

-- Business Question 10: Which months have the most orders?
SELECT 
    EXTRACT(YEAR FROM order_purchase_timestamp) AS "Year",
    EXTRACT(MONTH FROM order_purchase_timestamp) AS "Month",
    COUNT(*) AS "Number of Orders"
FROM olist_sales_data_set.olist_orders_dataset
GROUP BY EXTRACT(YEAR FROM order_purchase_timestamp), 
         EXTRACT(MONTH FROM order_purchase_timestamp)
ORDER BY "Year" DESC, "Month" DESC
LIMIT 12;

-- Business Question 11: Which days of the week are busiest?
SELECT 
    EXTRACT(DOW FROM order_purchase_timestamp) AS "Day of Week Number",
    CASE EXTRACT(DOW FROM order_purchase_timestamp)
        WHEN 0 THEN 'Sunday'
        WHEN 1 THEN 'Monday' 
        WHEN 2 THEN 'Tuesday'
        WHEN 3 THEN 'Wednesday'
        WHEN 4 THEN 'Thursday'
        WHEN 5 THEN 'Friday'
        WHEN 6 THEN 'Saturday'
    END AS "Day of Week",
    COUNT(*) AS "Number of Orders"
FROM olist_sales_data_set.olist_orders_dataset
GROUP BY EXTRACT(DOW FROM order_purchase_timestamp)
ORDER BY COUNT(*) DESC;

-- 💡 Business Application: Staff scheduling, inventory planning

-- =============================================================================
-- SECTION 7: Customer Satisfaction Analysis
-- =============================================================================

-- Business Question 12: What's our customer satisfaction score distribution?
SELECT 
    review_score AS "Star Rating",
    COUNT(*) AS "Number of Reviews",
    ROUND(COUNT(*) * 100.0 / (
        SELECT COUNT(*) FROM olist_sales_data_set.olist_order_reviews_dataset 
        WHERE review_score IS NOT NULL
    ), 2) AS "Percentage of Reviews"
FROM olist_sales_data_set.olist_order_reviews_dataset
WHERE review_score IS NOT NULL
GROUP BY review_score
ORDER BY review_score DESC;

-- Business Question 13: Average satisfaction by order status
SELECT 
    o.order_status AS "Order Status",
    COUNT(r.review_score) AS "Number of Reviews",
    ROUND(AVG(r.review_score), 2) AS "Average Rating"
FROM olist_sales_data_set.olist_orders_dataset o
LEFT JOIN olist_sales_data_set.olist_order_reviews_dataset r ON o.order_id = r.order_id
WHERE r.review_score IS NOT NULL
GROUP BY o.order_status
ORDER BY AVG(r.review_score) DESC;

-- 🎯 Business Insight: How delivery performance affects customer satisfaction

-- =============================================================================
-- SECTION 8: Advanced Business Intelligence Queries
-- =============================================================================

-- Business Question 14: Top 10 customers by total spending
SELECT 
    o.customer_id AS "Customer ID",
    c.customer_state AS "State",
    c.customer_city AS "City",
    COUNT(o.order_id) AS "Total Orders",
    ROUND(SUM(p.payment_value), 2) AS "Total Spent"
FROM olist_sales_data_set.olist_orders_dataset o
JOIN olist_sales_data_set.olist_customers_dataset c ON o.customer_id = c.customer_id
LEFT JOIN olist_sales_data_set.olist_order_payments_dataset p ON o.order_id = p.order_id
GROUP BY o.customer_id, c.customer_state, c.customer_city
ORDER BY SUM(p.payment_value) DESC
LIMIT 10;

-- Business Question 15: Monthly revenue trend
SELECT 
    EXTRACT(YEAR FROM o.order_purchase_timestamp) AS "Year",
    EXTRACT(MONTH FROM o.order_purchase_timestamp) AS "Month",
    COUNT(DISTINCT o.order_id) AS "Orders",
    ROUND(SUM(p.payment_value), 2) AS "Revenue"
FROM olist_sales_data_set.olist_orders_dataset o
LEFT JOIN olist_sales_data_set.olist_order_payments_dataset p ON o.order_id = p.order_id
WHERE o.order_status = 'delivered'
GROUP BY EXTRACT(YEAR FROM o.order_purchase_timestamp),
         EXTRACT(MONTH FROM o.order_purchase_timestamp)
ORDER BY "Year" DESC, "Month" DESC
LIMIT 12;

-- 💡 Executive Dashboard Material: Key performance indicators

-- =============================================================================
-- SECTION 9: Practical Business Reports
-- =============================================================================

-- Business Report 1: Daily Operations Summary
SELECT 
    CURRENT_DATE AS "Report Date",
    (SELECT COUNT(*) FROM olist_sales_data_set.olist_orders_dataset) AS "Total Orders Ever",
    (SELECT COUNT(*) FROM olist_sales_data_set.olist_customers_dataset) AS "Total Customers",
    (SELECT COUNT(DISTINCT product_category_name) 
     FROM olist_sales_data_set.olist_products_dataset 
     WHERE product_category_name IS NOT NULL) AS "Product Categories",
    (SELECT ROUND(AVG(payment_value), 2) 
     FROM olist_sales_data_set.olist_order_payments_dataset) AS "Average Order Value";

-- Business Report 2: Geographic Performance Summary
SELECT 
    'Geographic Performance' AS "Report Type",
    COUNT(DISTINCT c.customer_state) AS "States Served",
    COUNT(DISTINCT c.customer_city) AS "Cities Served",
    (SELECT c2.customer_state 
     FROM olist_sales_data_set.olist_customers_dataset c2 
     GROUP BY c2.customer_state 
     ORDER BY COUNT(*) DESC 
     LIMIT 1) AS "Top State by Customers"
FROM olist_sales_data_set.olist_customers_dataset c;

-- =============================================================================
-- SUCCESS CHALLENGES: Apply Your SQL Skills
-- =============================================================================

-- 🏆 Challenge 1: Find the most expensive single order
-- (Hint: Use MAX with payment_value)

-- 🏆 Challenge 2: Count how many orders were placed in 2018
-- (Hint: Use WHERE with EXTRACT(YEAR FROM ...))

-- 🏆 Challenge 3: Find the top 5 cities with highest average order values
-- (Hint: JOIN orders, customers, and payments tables)

-- 🏆 Challenge 4: Calculate what percentage of orders get 5-star reviews
-- (Hint: Use subqueries and conditional counting)

-- Solutions in the solutions folder!

-- =============================================================================
-- BUSINESS VALUE SUMMARY
-- =============================================================================

/*
What You've Accomplished Today:

✅ Translated Python data analysis to SQL database queries
✅ Answered real business questions using structured data
✅ Learned to aggregate, sort, and filter data for insights
✅ Connected multiple tables to get comprehensive views
✅ Generated actionable business intelligence reports

Real-World Applications:
- Customer segmentation for marketing campaigns
- Inventory planning based on category performance  
- Geographic expansion planning using location data
- Financial forecasting using payment trends
- Operations optimization using time-based patterns

Key Insight: Same analytical mindset as yesterday's Python work,
just using SQL as the tool. The business questions and logical
thinking remain consistent across tools!
*/

-- =============================================================================
-- REFLECTION: From Python DataFrames to SQL Tables
-- =============================================================================

/*
Direct Parallels from Yesterday's Python Success:

Python df.head()           → SQL SELECT * LIMIT 5
Python len(df)             → SQL SELECT COUNT(*)
Python df.sort_values()    → SQL ORDER BY  
Python df.groupby()        → SQL GROUP BY
Python df.value_counts()   → SQL GROUP BY + COUNT
Python df.describe()       → SQL aggregation functions
Python df.merge()          → SQL JOIN

Same Business Logic:
✓ Understanding your data structure first
✓ Asking specific business questions
✓ Using appropriate functions for the analysis needed
✓ Interpreting results in business context
✓ Building complex insights from simple operations

You haven't learned a completely new skill - you've learned
a new syntax for the same analytical thinking you already have!
*/