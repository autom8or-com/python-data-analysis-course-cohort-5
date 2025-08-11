-- Week 01 Thursday SQL: Basic SELECT Statements
-- Building on Wednesday's Python DataFrame concepts
-- Business Context: NaijaCommerce e-commerce data analysis

-- =============================================================================
-- SECTION 1: Your First SQL Query (Python df.head() equivalent)
-- =============================================================================

-- Yesterday in Python: df.head()
-- Today in SQL: SELECT with LIMIT

-- View first 5 orders (same as df.head())
SELECT * 
FROM olist_sales_data_set.olist_orders_dataset 
LIMIT 5;

-- 🎯 Expected Result: First 5 rows with all columns
-- 💡 Python Parallel: orders_df.head()

-- =============================================================================
-- SECTION 2: Selecting Specific Columns (Python df[['col1', 'col2']])
-- =============================================================================

-- Yesterday in Python: df[['order_id', 'order_status']]
-- Today in SQL: SELECT specific columns

-- Business Question: What are the order IDs and their current status?
SELECT 
    order_id,
    order_status
FROM olist_sales_data_set.olist_orders_dataset
LIMIT 10;

-- Adding meaningful column names (like Excel column headers)
SELECT 
    order_id AS "Order ID",
    order_status AS "Current Status",
    order_purchase_timestamp AS "Purchase Date"
FROM olist_sales_data_set.olist_orders_dataset
LIMIT 10;

-- 🎯 Expected Result: 10 rows with only selected columns
-- 💡 Python Parallel: df[['order_id', 'order_status', 'order_purchase_timestamp']].head(10)

-- =============================================================================
-- SECTION 3: Exploring Different Tables (Multiple DataFrames)
-- =============================================================================

-- Yesterday in Python: You loaded different CSV files
-- Today in SQL: Query different tables

-- View customers data
SELECT *
FROM olist_sales_data_set.olist_customers_dataset
LIMIT 5;

-- View products data
SELECT *
FROM olist_sales_data_set.olist_products_dataset
LIMIT 5;

-- View payments data
SELECT *
FROM olist_sales_data_set.olist_order_payments_dataset
LIMIT 5;

-- 💡 Business Insight: Each table contains different business information
-- orders = transaction records
-- customers = who bought
-- products = what was sold
-- payments = how they paid

-- =============================================================================
-- SECTION 4: Counting Records (Python len(df))
-- =============================================================================

-- Yesterday in Python: len(df)
-- Today in SQL: SELECT COUNT(*)

-- How many total orders do we have?
SELECT COUNT(*) AS "Total Orders"
FROM olist_sales_data_set.olist_orders_dataset;

-- How many customers?
SELECT COUNT(*) AS "Total Customers"
FROM olist_sales_data_set.olist_customers_dataset;

-- How many products?
SELECT COUNT(*) AS "Total Products"
FROM olist_sales_data_set.olist_products_dataset;

-- 🎯 Expected Results: 
-- Total Orders: ~99,441
-- Total Customers: ~99,441
-- Total Products: ~32,951

-- 💡 Python Parallel: 
-- len(orders_df)
-- len(customers_df)
-- len(products_df)

-- =============================================================================
-- SECTION 5: Basic Sorting (Python df.sort_values())
-- =============================================================================

-- Yesterday in Python: df.sort_values('column_name')
-- Today in SQL: ORDER BY

-- Show newest orders first
SELECT 
    order_id AS "Order ID",
    order_status AS "Status",
    order_purchase_timestamp AS "Purchase Date"
FROM olist_sales_data_set.olist_orders_dataset
ORDER BY order_purchase_timestamp DESC
LIMIT 10;

-- Show oldest orders first
SELECT 
    order_id AS "Order ID",
    order_status AS "Status", 
    order_purchase_timestamp AS "Purchase Date"
FROM olist_sales_data_set.olist_orders_dataset
ORDER BY order_purchase_timestamp ASC
LIMIT 10;

-- 💡 Python Parallel:
-- df.sort_values('order_purchase_timestamp', ascending=False).head(10)
-- df.sort_values('order_purchase_timestamp', ascending=True).head(10)

-- =============================================================================
-- SECTION 6: Exploring Column Names and Structure
-- =============================================================================

-- Yesterday in Python: df.columns and df.info()
-- Today in SQL: Schema exploration queries

-- What columns does the orders table have?
SELECT column_name, data_type, is_nullable
FROM information_schema.columns
WHERE table_name = 'olist_orders_dataset' 
  AND table_schema = 'olist_sales_data_set'
ORDER BY ordinal_position;

-- What columns does the customers table have?
SELECT column_name, data_type, is_nullable
FROM information_schema.columns
WHERE table_name = 'olist_customers_dataset'
  AND table_schema = 'olist_sales_data_set'
ORDER BY ordinal_position;

-- 💡 Python Parallel: df.info() and df.dtypes

-- =============================================================================
-- SECTION 7: Basic Aggregations (Python df.describe())
-- =============================================================================

-- Yesterday in Python: df['column'].min(), df['column'].max()
-- Today in SQL: MIN(), MAX(), AVG()

-- What's the date range of our orders?
SELECT 
    MIN(order_purchase_timestamp) AS "First Order Date",
    MAX(order_purchase_timestamp) AS "Last Order Date",
    COUNT(*) AS "Total Orders"
FROM olist_sales_data_set.olist_orders_dataset;

-- What's the range of payment values?
SELECT 
    MIN(payment_value) AS "Minimum Payment",
    MAX(payment_value) AS "Maximum Payment",
    AVG(payment_value) AS "Average Payment",
    COUNT(*) AS "Total Payments"
FROM olist_sales_data_set.olist_order_payments_dataset;

-- 💡 Python Parallel: 
-- df['order_purchase_timestamp'].min()
-- df['payment_value'].describe()

-- =============================================================================
-- SECTION 8: Business Questions Using Basic SQL
-- =============================================================================

-- Let's answer the same business questions from yesterday!

-- Question 1: How many unique order statuses do we have?
SELECT DISTINCT order_status AS "Order Status"
FROM olist_sales_data_set.olist_orders_dataset
ORDER BY order_status;

-- Question 2: What states do our customers come from?
SELECT DISTINCT customer_state AS "Customer State"
FROM olist_sales_data_set.olist_customers_dataset
ORDER BY customer_state;

-- Question 3: What product categories do we sell?
SELECT DISTINCT product_category_name AS "Product Category"
FROM olist_sales_data_set.olist_products_dataset
WHERE product_category_name IS NOT NULL
ORDER BY product_category_name
LIMIT 20;

-- 💡 Python Parallel:
-- df['order_status'].unique()
-- df['customer_state'].unique() 
-- df['product_category_name'].unique()

-- =============================================================================
-- SECTION 9: Putting It All Together - Real Business Analysis
-- =============================================================================

-- Business Scenario: NaijaCommerce Management Dashboard
-- Question: "Show me our top 10 most recent completed orders with customer location"

-- This query combines multiple concepts we learned:
SELECT 
    o.order_id AS "Order ID",
    o.order_status AS "Status",
    o.order_purchase_timestamp AS "Purchase Date",
    c.customer_city AS "Customer City",
    c.customer_state AS "Customer State"
FROM olist_sales_data_set.olist_orders_dataset o
JOIN olist_sales_data_set.customers c ON o.customer_id = c.customer_id
WHERE o.order_status = 'delivered'
ORDER BY o.order_purchase_timestamp DESC
LIMIT 10;

-- 🎯 This is advanced but shows the power of SQL!
-- 💡 Notice how we're answering the same type of business questions
--     you tackled yesterday in Python, just with different syntax

-- =============================================================================
-- SUCCESS CHECK: Can You Write These Queries?
-- =============================================================================

-- 1. Show me the first 3 rows from the products table

-- 2. Count how many payment records we have

-- 3. Show me the 5 most recent orders (newest first)

-- 4. List all unique payment types

-- (Solutions in the solutions folder!)

-- =============================================================================
-- REFLECTION: SQL vs Python - Same Logic, Different Syntax
-- =============================================================================

/*
Key Takeaways:
1. SQL SELECT = Python df operations
2. LIMIT = df.head()
3. COUNT(*) = len(df)
4. ORDER BY = df.sort_values()
5. DISTINCT = df.unique()
6. Same business questions, different tools!

Remember: You already know the logical thinking.
SQL is just another way to express the same ideas.
*/