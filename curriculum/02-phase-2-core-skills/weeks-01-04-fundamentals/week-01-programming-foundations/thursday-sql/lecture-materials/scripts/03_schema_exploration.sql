-- Week 01 Thursday SQL: Schema Exploration and Data Types
-- Building on Wednesday's Python df.info() and df.dtypes concepts
-- Business Context: Understanding our NaijaCommerce database structure

-- =============================================================================
-- SECTION 1: Database Schema Overview (Python: understanding your datasets)
-- =============================================================================

-- Yesterday in Python: You knew which CSV files you had
-- Today in SQL: Let's see what schemas and tables we have

-- What schemas (folders) are available in our database?
SELECT schema_name
FROM information_schema.schemata
WHERE schema_name LIKE '%olist%'
ORDER BY schema_name;

-- 🎯 Expected Result: olist_sales_data_set, olist_marketing_data_set
-- 💡 Think of schemas as folders organizing related tables

-- =============================================================================
-- SECTION 2: Table Discovery (Python: list of DataFrames you created)
-- =============================================================================

-- Yesterday in Python: You loaded multiple CSV files into DataFrames
-- Today in SQL: Let's see what tables are in our sales schema

-- What tables are in our sales data schema?
SELECT table_name, table_type
FROM information_schema.tables
WHERE table_schema = 'olist_sales_data_set'
ORDER BY table_name;

-- What about marketing data?
SELECT table_name, table_type
FROM information_schema.tables
WHERE table_schema = 'olist_marketing_data_set'
ORDER BY table_name;

-- 💡 Business Context: Each table represents a different aspect of e-commerce:
-- orders = transaction records
-- customers = buyer information
-- products = catalog items
-- payments = financial transactions
-- reviews = customer feedback

-- =============================================================================
-- SECTION 3: Column Structure Exploration (Python df.info() equivalent)
-- =============================================================================

-- Yesterday in Python: df.info() showed columns, data types, memory usage
-- Today in SQL: Schema queries show table structure

-- Explore orders table structure (like df.info())
SELECT 
    column_name AS "Column Name",
    data_type AS "Data Type",
    is_nullable AS "Can Be Empty?",
    character_maximum_length AS "Max Length",
    column_default AS "Default Value"
FROM information_schema.columns
WHERE table_name = 'orders' 
  AND table_schema = 'olist_sales_data_set'
ORDER BY ordinal_position;

-- Explore customers table structure
SELECT 
    column_name AS "Column Name",
    data_type AS "Data Type",
    is_nullable AS "Can Be Empty?"
FROM information_schema.columns
WHERE table_name = 'customers'
  AND table_schema = 'olist_sales_data_set'
ORDER BY ordinal_position;

-- 🎯 Expected Results: Column names, types (varchar, integer, timestamp, etc.)
-- 💡 Python Parallel: orders_df.info() and customers_df.info()

-- =============================================================================
-- SECTION 4: Data Type Understanding (Python dtypes translation)
-- =============================================================================

-- Yesterday in Python: You learned string, int, float, datetime, boolean
-- Today in SQL: Similar concepts, different names

-- Let's see all data types used in our sales schema
SELECT 
    table_name AS "Table",
    column_name AS "Column",
    data_type AS "SQL Data Type",
    CASE 
        WHEN data_type IN ('character varying', 'text') THEN 'Text/String'
        WHEN data_type = 'integer' THEN 'Whole Number'
        WHEN data_type = 'numeric' THEN 'Decimal Number'
        WHEN data_type IN ('timestamp without time zone', 'date') THEN 'Date/Time'
        WHEN data_type = 'boolean' THEN 'True/False'
        ELSE data_type
    END AS "Python Equivalent"
FROM information_schema.columns
WHERE table_schema = 'olist_sales_data_set'
ORDER BY table_name, ordinal_position;

-- 💡 Data Type Translation Guide:
-- VARCHAR/TEXT = Python str (string)
-- INTEGER = Python int (integer)  
-- NUMERIC/DECIMAL = Python float (decimal numbers)
-- TIMESTAMP/DATE = Python datetime
-- BOOLEAN = Python bool (True/False)

-- =============================================================================
-- SECTION 5: Sample Data with Data Types (Python df.head() with dtypes)
-- =============================================================================

-- Yesterday in Python: df.head() showed data, df.dtypes showed types
-- Today in SQL: Let's see data and understand the types

-- Orders table: View data and understand what each column contains
SELECT 
    order_id,           -- VARCHAR: Unique identifier (like product codes)
    customer_id,        -- VARCHAR: Links to customers table
    order_status,       -- VARCHAR: Text status ("delivered", "shipped", etc.)
    order_purchase_timestamp  -- TIMESTAMP: Date and time of purchase
FROM olist_sales_data_set.olist_orders_dataset
LIMIT 5;

-- Payments table: See numeric data types in action
SELECT 
    order_id,          -- VARCHAR: Links to orders table
    payment_type,      -- VARCHAR: Text ("credit_card", "boleto", etc.)
    payment_installments,  -- INTEGER: Whole number (1, 2, 3, etc.)
    payment_value      -- NUMERIC: Decimal money amounts
FROM olist_sales_data_set.olist_order_payments_dataset
LIMIT 5;

-- 💡 Notice how data types match the kind of information:
-- Text for names and categories → VARCHAR/TEXT
-- Numbers for counting → INTEGER
-- Money amounts → NUMERIC/DECIMAL
-- Dates and times → TIMESTAMP

-- =============================================================================
-- SECTION 6: Data Quality Checks (Python df.isnull() equivalent)
-- =============================================================================

-- Yesterday in Python: df.isnull().sum() to find missing data
-- Today in SQL: Check for NULL values (missing data)

-- Which columns in orders table have missing values?
SELECT 
    COUNT(*) AS "Total Rows",
    COUNT(order_id) AS "Non-null Order IDs",
    COUNT(order_status) AS "Non-null Status", 
    COUNT(order_purchase_timestamp) AS "Non-null Purchase Dates",
    COUNT(order_delivered_customer_date) AS "Non-null Delivery Dates"
FROM olist_sales_data_set.olist_orders_dataset;

-- Calculate missing data percentages
SELECT 
    'order_delivered_customer_date' AS "Column",
    COUNT(*) AS "Total Rows",
    COUNT(order_delivered_customer_date) AS "Non-null Values",
    COUNT(*) - COUNT(order_delivered_customer_date) AS "Missing Values",
    ROUND(
        (COUNT(*) - COUNT(order_delivered_customer_date)) * 100.0 / COUNT(*), 2
    ) AS "Missing Percentage"
FROM olist_sales_data_set.olist_orders_dataset;

-- 💡 Python Parallel:
-- df.isnull().sum()
-- df.isnull().mean() * 100  # for percentages

-- =============================================================================
-- SECTION 7: Table Relationships (Python: connecting DataFrames)
-- =============================================================================

-- Yesterday in Python: You might have merged DataFrames using common columns
-- Today in SQL: Tables are connected through primary keys and foreign keys

-- Understanding how tables connect (like VLOOKUP in Excel)
-- orders.customer_id connects to customers.customer_id

-- Let's see the connection in action:
SELECT 
    o.order_id AS "Order ID",
    o.order_status AS "Order Status", 
    c.customer_state AS "Customer State",
    c.customer_city AS "Customer City"
FROM olist_sales_data_set.olist_orders_dataset o
JOIN olist_sales_data_set.olist_customers_dataset c ON o.customer_id = c.customer_id
LIMIT 5;

-- 💡 Business Value: This connection lets us answer questions like:
-- "How many orders came from Lagos?"
-- "Which states have the most customers?"
-- "What's the order pattern by region?"

-- =============================================================================
-- SECTION 8: Table Size and Statistics (Python df.shape and df.describe())
-- =============================================================================

-- Yesterday in Python: df.shape gave you (rows, columns)
-- Today in SQL: Let's get comprehensive table statistics

-- Get row counts for all tables (like checking df.shape[0] for each DataFrame)
SELECT 
    'orders' AS "Table Name",
    COUNT(*) AS "Number of Rows"
FROM olist_sales_data_set.olist_orders_dataset

UNION ALL

SELECT 
    'customers' AS "Table Name", 
    COUNT(*) AS "Number of Rows"
FROM olist_sales_data_set.olist_customers_dataset

UNION ALL

SELECT 
    'products' AS "Table Name",
    COUNT(*) AS "Number of Rows"
FROM olist_sales_data_set.olist_products_dataset

UNION ALL

SELECT 
    'payments' AS "Table Name",
    COUNT(*) AS "Number of Rows"
FROM olist_sales_data_set.olist_order_payments_dataset

ORDER BY "Number of Rows" DESC;

-- Get column counts for each table
SELECT 
    table_name AS "Table Name",
    COUNT(*) AS "Number of Columns"
FROM information_schema.columns
WHERE table_schema = 'olist_sales_data_set'
GROUP BY table_name
ORDER BY "Number of Columns" DESC;

-- 🎯 Expected Results: You'll see which tables are biggest
-- 💡 Python Parallel: 
-- print(f"Orders: {orders_df.shape}")
-- print(f"Customers: {customers_df.shape}")

-- =============================================================================
-- SECTION 9: Business Data Exploration (Python df.value_counts() equivalent)
-- =============================================================================

-- Yesterday in Python: df['column'].value_counts()
-- Today in SQL: GROUP BY and COUNT()

-- What are the most common order statuses?
SELECT 
    order_status AS "Order Status",
    COUNT(*) AS "Number of Orders",
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM olist_sales_data_set.olist_orders_dataset), 2) AS "Percentage"
FROM olist_sales_data_set.olist_orders_dataset
GROUP BY order_status
ORDER BY COUNT(*) DESC;

-- What are the most common payment types?
SELECT 
    payment_type AS "Payment Method",
    COUNT(*) AS "Number of Payments"
FROM olist_sales_data_set.olist_order_payments_dataset
GROUP BY payment_type
ORDER BY COUNT(*) DESC;

-- Which states have the most customers?
SELECT 
    customer_state AS "State",
    COUNT(*) AS "Number of Customers"
FROM olist_sales_data_set.olist_customers_dataset
GROUP BY customer_state
ORDER BY COUNT(*) DESC
LIMIT 10;

-- 💡 Python Parallel:
-- df['order_status'].value_counts()
-- df['payment_type'].value_counts()
-- df['customer_state'].value_counts()

-- =============================================================================
-- PRACTICE EXERCISE: Schema Detective Challenge
-- =============================================================================

-- 🕵️ Your turn! Use what you've learned to explore the products table:

-- 1. How many columns does the products table have?
-- (Write a query to find out)

-- 2. What data types are used in the products table?
-- (Explore the column information)

-- 3. How many products are there total?
-- (Count the rows)

-- 4. Are there any missing values in product_category_name?
-- (Compare COUNT(*) with COUNT(product_category_name))

-- 5. What are the top 10 product categories by count?
-- (Use GROUP BY and COUNT)

-- Solutions provided in the solutions folder!

-- =============================================================================
-- REFLECTION: Schema Understanding = Data Foundation
-- =============================================================================

/*
Key Takeaways:

1. Schema exploration in SQL = df.info() in Python
2. Understanding data types helps you write better queries
3. Checking for missing data (NULL) is crucial for analysis
4. Table relationships connect data (like VLOOKUP in Excel)
5. Same analytical mindset, different tools

Business Value:
- Know your data before you analyze it
- Understanding structure prevents errors
- Data types guide what operations you can perform
- Table relationships unlock powerful insights

Remember: You already have the analytical thinking skills.
SQL schema exploration is just a systematic way to understand your data!
*/