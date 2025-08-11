-- Week 01 Thursday SQL: Practice Exercise Solutions
-- Building on Wednesday's Python Success
-- Detailed Solutions with Python Comparisons

-- =============================================================================
-- WARM-UP EXERCISES: Connection and Basic Queries
-- =============================================================================

-- Exercise 1: Connection Test
SELECT 'I am connected to the database!' AS connection_message;

-- Exercise 2: First Data View  
SELECT * 
FROM olist_sales_data_set.orders 
LIMIT 5;

-- Exercise 3: Column Exploration
SELECT 
    order_id,
    order_status
FROM olist_sales_data_set.orders
LIMIT 10;

-- =============================================================================
-- COUNTING AND BASIC STATISTICS
-- =============================================================================

-- Exercise 4: Total Record Count
SELECT COUNT(*) AS "Total Orders"
FROM olist_sales_data_set.orders;
-- Expected Result: ~99,441 orders

-- Exercise 5: Customer Count
SELECT COUNT(*) AS "Total Customers"
FROM olist_sales_data_set.customers;
-- Expected Result: ~99,441 customers

-- Exercise 6: Product Catalog Size
SELECT COUNT(*) AS "Total Products"
FROM olist_sales_data_set.products;
-- Expected Result: ~32,951 products

-- =============================================================================
-- SORTING AND ORDERING
-- =============================================================================

-- Exercise 7: Newest Orders First
SELECT 
    order_id,
    order_status,
    order_purchase_timestamp
FROM olist_sales_data_set.orders
ORDER BY order_purchase_timestamp DESC
LIMIT 10;

-- Exercise 8: Oldest Orders  
SELECT 
    order_id,
    order_status,
    order_purchase_timestamp
FROM olist_sales_data_set.orders
ORDER BY order_purchase_timestamp ASC
LIMIT 5;

-- =============================================================================
-- CATEGORICAL DATA ANALYSIS
-- =============================================================================

-- Exercise 9: Order Status Breakdown
SELECT 
    order_status,
    COUNT(*) AS order_count,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM olist_sales_data_set.orders), 2) AS percentage
FROM olist_sales_data_set.orders
GROUP BY order_status
ORDER BY COUNT(*) DESC;

-- Exercise 10: Customer Geographic Distribution
SELECT 
    customer_state,
    COUNT(*) AS customer_count
FROM olist_sales_data_set.customers
GROUP BY customer_state
ORDER BY COUNT(*) DESC
LIMIT 10;

-- Exercise 11: Payment Method Preferences  
SELECT 
    payment_type,
    COUNT(*) AS payment_count,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM olist_sales_data_set.payments), 2) AS percentage
FROM olist_sales_data_set.payments
GROUP BY payment_type
ORDER BY COUNT(*) DESC;

-- =============================================================================
-- DATA EXPLORATION AND QUALITY CHECKS
-- =============================================================================

-- Exercise 12: Date Range Analysis
SELECT 
    MIN(order_purchase_timestamp) AS "Earliest Order",
    MAX(order_purchase_timestamp) AS "Latest Order",
    MAX(order_purchase_timestamp) - MIN(order_purchase_timestamp) AS "Business Period"
FROM olist_sales_data_set.orders;

-- Exercise 13: Payment Value Statistics
SELECT 
    COUNT(*) AS "Total Payments",
    MIN(payment_value) AS "Minimum Payment",
    MAX(payment_value) AS "Maximum Payment",
    ROUND(AVG(payment_value), 2) AS "Average Payment",
    ROUND(SUM(payment_value), 2) AS "Total Revenue"
FROM olist_sales_data_set.payments;

-- Exercise 14: Missing Data Check
SELECT 
    COUNT(*) AS "Total Orders",
    COUNT(order_delivered_customer_date) AS "Orders with Delivery Date",
    COUNT(*) - COUNT(order_delivered_customer_date) AS "Missing Delivery Dates",
    ROUND((COUNT(*) - COUNT(order_delivered_customer_date)) * 100.0 / COUNT(*), 2) AS "Missing Percentage"
FROM olist_sales_data_set.orders;

-- =============================================================================
-- BUSINESS QUESTIONS (Medium Difficulty)
-- =============================================================================

-- Exercise 15: Customer Concentration
SELECT 
    customer_city,
    COUNT(*) AS customer_count
FROM olist_sales_data_set.customers
WHERE customer_state = 'SP'
GROUP BY customer_city
ORDER BY COUNT(*) DESC
LIMIT 1;
-- Expected Result: São Paulo city should be #1

-- Exercise 16: High-Value Payments
SELECT 
    order_id,
    payment_type,
    payment_value
FROM olist_sales_data_set.payments
WHERE payment_value > 1000
ORDER BY payment_value DESC;

-- Exercise 17: Product Category Exploration
SELECT COUNT(DISTINCT product_category_name) AS "Unique Categories"
FROM olist_sales_data_set.products
WHERE product_category_name IS NOT NULL;
-- Expected Result: ~73 categories

-- =============================================================================
-- TIME-BASED ANALYSIS
-- =============================================================================

-- Exercise 18: Monthly Order Pattern
SELECT 
    EXTRACT(MONTH FROM order_purchase_timestamp) AS month_number,
    CASE EXTRACT(MONTH FROM order_purchase_timestamp)
        WHEN 1 THEN 'January'
        WHEN 2 THEN 'February'
        WHEN 3 THEN 'March'
        WHEN 4 THEN 'April'
        WHEN 5 THEN 'May'
        WHEN 6 THEN 'June'
        WHEN 7 THEN 'July'
        WHEN 8 THEN 'August'
        WHEN 9 THEN 'September'
        WHEN 10 THEN 'October'
        WHEN 11 THEN 'November'
        WHEN 12 THEN 'December'
    END AS month_name,
    COUNT(*) AS order_count
FROM olist_sales_data_set.orders
WHERE EXTRACT(YEAR FROM order_purchase_timestamp) = 2018
GROUP BY EXTRACT(MONTH FROM order_purchase_timestamp)
ORDER BY EXTRACT(MONTH FROM order_purchase_timestamp);

-- Exercise 19: Day of Week Analysis  
SELECT 
    EXTRACT(DOW FROM order_purchase_timestamp) AS day_number,
    CASE EXTRACT(DOW FROM order_purchase_timestamp)
        WHEN 0 THEN 'Sunday'
        WHEN 1 THEN 'Monday'
        WHEN 2 THEN 'Tuesday'
        WHEN 3 THEN 'Wednesday'
        WHEN 4 THEN 'Thursday'
        WHEN 5 THEN 'Friday'
        WHEN 6 THEN 'Saturday'
    END AS day_name,
    COUNT(*) AS order_count
FROM olist_sales_data_set.orders
GROUP BY EXTRACT(DOW FROM order_purchase_timestamp)
ORDER BY COUNT(*) DESC;

-- =============================================================================
-- ADVANCED CHALLENGES (For Early Finishers)
-- =============================================================================

-- Challenge 20: Customer Satisfaction Overview
SELECT 
    review_score AS "Star Rating",
    COUNT(*) AS "Number of Reviews",
    ROUND(COUNT(*) * 100.0 / (
        SELECT COUNT(*) 
        FROM olist_sales_data_set.reviews 
        WHERE review_score IS NOT NULL
    ), 2) AS "Percentage"
FROM olist_sales_data_set.reviews
WHERE review_score IS NOT NULL
GROUP BY review_score
ORDER BY review_score;

-- Challenge 21: Revenue by Payment Type
SELECT 
    payment_type,
    COUNT(*) AS transaction_count,
    ROUND(SUM(payment_value), 2) AS total_revenue,
    ROUND(AVG(payment_value), 2) AS avg_transaction_value
FROM olist_sales_data_set.payments
GROUP BY payment_type
ORDER BY SUM(payment_value) DESC;

-- Challenge 22: Geographic Revenue Analysis
SELECT 
    c.customer_state,
    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND(SUM(p.payment_value), 2) AS total_revenue,
    ROUND(AVG(p.payment_value), 2) AS avg_order_value
FROM olist_sales_data_set.orders o
JOIN olist_sales_data_set.customers c ON o.customer_id = c.customer_id
LEFT JOIN olist_sales_data_set.payments p ON o.order_id = p.order_id
WHERE o.order_status = 'delivered'
GROUP BY c.customer_state
ORDER BY SUM(p.payment_value) DESC
LIMIT 10;

-- =============================================================================
-- SUCCESS CHECK SOLUTIONS
-- =============================================================================

-- Quick Check 1: Count total customers
SELECT COUNT(*) AS total_customers FROM olist_sales_data_set.customers;

-- Quick Check 2: Show 5 newest orders
SELECT * FROM olist_sales_data_set.orders 
ORDER BY order_purchase_timestamp DESC LIMIT 5;

-- Quick Check 3: List all unique order statuses
SELECT DISTINCT order_status FROM olist_sales_data_set.orders ORDER BY order_status;

-- Quick Check 4: Find the most expensive single payment
SELECT * FROM olist_sales_data_set.payments 
ORDER BY payment_value DESC LIMIT 1;

-- =============================================================================
-- BONUS CREATIVE EXAMPLES
-- =============================================================================

-- Creative Example 1: Heaviest Product
SELECT 
    product_id,
    product_category_name,
    product_weight_g
FROM olist_sales_data_set.products
WHERE product_weight_g IS NOT NULL
ORDER BY product_weight_g DESC
LIMIT 5;

-- Creative Example 2: Longest Product Names
SELECT 
    product_id,
    product_category_name,
    product_name_length
FROM olist_sales_data_set.products
WHERE product_name_length IS NOT NULL
ORDER BY product_name_length DESC
LIMIT 10;

-- Creative Example 3: Most Productive Hour
SELECT 
    EXTRACT(HOUR FROM order_purchase_timestamp) AS hour_of_day,
    COUNT(*) AS orders_placed
FROM olist_sales_data_set.orders
GROUP BY EXTRACT(HOUR FROM order_purchase_timestamp)
ORDER BY COUNT(*) DESC;

-- Creative Example 4: Payment Installment Analysis
SELECT 
    payment_installments,
    COUNT(*) AS payment_count,
    ROUND(AVG(payment_value), 2) AS avg_payment_value
FROM olist_sales_data_set.payments
WHERE payment_installments <= 10  -- Focus on common installment counts
GROUP BY payment_installments
ORDER BY payment_installments;

-- =============================================================================
-- LEARNING ASSESSMENT: Python vs SQL Comparison
-- =============================================================================

/*
SOLUTION ANALYSIS: Python vs SQL Patterns

1. Data Loading and First Look:
   Python: df = pd.read_csv(); df.head()
   SQL:    SELECT * FROM table LIMIT 5;

2. Counting Records:
   Python: len(df)
   SQL:    SELECT COUNT(*) FROM table;

3. Unique Values:
   Python: df['column'].unique()
   SQL:    SELECT DISTINCT column FROM table;

4. Value Counts:
   Python: df['column'].value_counts()
   SQL:    SELECT column, COUNT(*) FROM table GROUP BY column ORDER BY COUNT(*) DESC;

5. Basic Statistics:
   Python: df['column'].describe()
   SQL:    SELECT MIN(column), MAX(column), AVG(column), COUNT(*) FROM table;

6. Filtering:
   Python: df[df['column'] > value]
   SQL:    SELECT * FROM table WHERE column > value;

7. Sorting:
   Python: df.sort_values('column', ascending=False)
   SQL:    SELECT * FROM table ORDER BY column DESC;

8. Group Analysis:
   Python: df.groupby('column')['other_column'].agg(['count', 'mean'])
   SQL:    SELECT column, COUNT(*), AVG(other_column) FROM table GROUP BY column;

KEY INSIGHT: Same logical patterns, different syntax!
The business thinking and analytical approach remain identical.
*/

-- =============================================================================
-- STUDENT SUCCESS METRICS
-- =============================================================================

/*
If you successfully completed these solutions, you have mastered:

✅ Basic SQL SELECT syntax and structure
✅ Data exploration using LIMIT, ORDER BY, COUNT
✅ Categorical analysis using GROUP BY and aggregations
✅ Data quality assessment with NULL checks
✅ Time-based analysis using date extraction functions
✅ Multi-table relationships using JOIN operations
✅ Business question translation from English to SQL

Confidence Builders:
✓ You wrote queries answering real business questions
✓ You used the same analytical thinking as Python
✓ You successfully explored a professional database
✓ You can now work with both Python DataFrames AND SQL tables

Next Week Preview:
- Data filtering with WHERE clauses (Python boolean indexing → SQL conditions)
- Complex conditions and multiple criteria
- Pattern matching and text searches
- Date range filtering and time-based conditions

You're building a powerful toolkit: Excel + Python + SQL!
The same business logic, multiple tools for maximum flexibility.

CONGRATULATIONS! You're officially a multi-tool data analyst! 🎉📊
*/