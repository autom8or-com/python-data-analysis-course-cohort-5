-- Week 01 Thursday SQL: Practice Exercises
-- Building on Your Wednesday Python Success
-- Same Business Logic, SQL Syntax Practice

-- =============================================================================
-- INSTRUCTIONS FOR STUDENTS
-- =============================================================================

/*
Welcome to your first SQL practice session! 

Today's Goal: Apply the same analytical thinking from yesterday's Python 
success to write SQL queries.

How to Use This File:
1. Read each business question carefully
2. Write your SQL query below the question  
3. Run the query and check the results
4. Compare your approach to yesterday's Python methods
5. Build confidence: "I can do this in both Python AND SQL!"

Remember: You already know HOW to think about these problems.
You're just learning new syntax to express the same ideas.
*/

-- =============================================================================
-- WARM-UP EXERCISES: Connection and Basic Queries
-- =============================================================================

-- Exercise 1: Connection Test
-- Task: Write a query that shows "I am connected to the database!"
-- Hint: Use SELECT with a text message

-- Your solution here:




-- Exercise 2: First Data View  
-- Task: View the first 5 rows from the orders table
-- Python Equivalent: orders_df.head()
-- Hint: SELECT * FROM olist_sales_data_set.olist_orders_dataset LIMIT 5;

-- Your solution here:




-- Exercise 3: Column Exploration
-- Task: Show only order_id and order_status from the first 10 orders
-- Python Equivalent: orders_df[['order_id', 'order_status']].head(10)
-- Hint: SELECT order_id, order_status FROM olist_sales_data_set.olist_orders_dataset LIMIT 10;

-- Your solution here:




-- =============================================================================
-- COUNTING AND BASIC STATISTICS
-- =============================================================================

-- Exercise 4: Total Record Count
-- Task: How many total orders are in our database?
-- Python Equivalent: len(orders_df)
-- Hint: SELECT COUNT(*) FROM olist_sales_data_set.olist_orders_dataset;

-- Your solution here:




-- Exercise 5: Customer Count
-- Task: How many customers are in our database?
-- Python Equivalent: len(customers_df)
-- Hint: SELECT COUNT(*) FROM olist_sales_data_set.olist_customers_dataset;

-- Your solution here:




-- Exercise 6: Product Catalog Size
-- Task: How many products are in our catalog?
-- Python Equivalent: len(products_df)
-- Hint: SELECT COUNT(*) FROM olist_sales_data_set.olist_products_dataset;

-- Your solution here:




-- =============================================================================
-- SORTING AND ORDERING
-- =============================================================================

-- Exercise 7: Newest Orders First
-- Task: Show the 10 most recent orders (order_id, status, purchase timestamp)
-- Python Equivalent: orders_df.sort_values('order_purchase_timestamp', ascending=False).head(10)
-- Hint: SELECT order_id, order_status, order_purchase_timestamp FROM olist_sales_data_set.olist_orders_dataset ORDER BY order_purchase_timestamp DESC LIMIT 10;

-- Your solution here:




-- Exercise 8: Oldest Orders  
-- Task: Show the 5 oldest orders in our database
-- Python Equivalent: orders_df.sort_values('order_purchase_timestamp', ascending=True).head(5)
-- Hint: SELECT * FROM olist_sales_data_set.olist_orders_dataset ORDER BY order_purchase_timestamp ASC LIMIT 5;

-- Your solution here:




-- =============================================================================
-- CATEGORICAL DATA ANALYSIS
-- =============================================================================

-- Exercise 9: Order Status Breakdown
-- Task: Count how many orders exist for each order status
-- Python Equivalent: orders_df['order_status'].value_counts()
-- Hint: SELECT order_status, COUNT(*) FROM olist_sales_data_set.olist_orders_dataset GROUP BY order_status;

-- Your solution here:




-- Exercise 10: Customer Geographic Distribution
-- Task: Count customers by state, show top 10 states
-- Python Equivalent: customers_df['customer_state'].value_counts().head(10)
-- Hint: SELECT customer_state, COUNT(*) FROM olist_sales_data_set.olist_customers_dataset GROUP BY customer_state ORDER BY COUNT(*) DESC LIMIT 10;

-- Your solution here:




-- Exercise 11: Payment Method Preferences  
-- Task: What payment methods do customers use most?
-- Python Equivalent: payments_df['payment_type'].value_counts()
-- Hint: SELECT payment_type, COUNT(*) FROM olist_sales_data_set.olist_order_payments_dataset GROUP BY payment_type ORDER BY COUNT(*) DESC;

-- Your solution here:




-- =============================================================================
-- DATA EXPLORATION AND QUALITY CHECKS
-- =============================================================================

-- Exercise 12: Date Range Analysis
-- Task: Find the earliest and latest order dates in our database
-- Python Equivalent: orders_df['order_purchase_timestamp'].min(), max()
-- Hint: SELECT MIN(order_purchase_timestamp), MAX(order_purchase_timestamp) FROM olist_sales_data_set.olist_orders_dataset;

-- Your solution here:




-- Exercise 13: Payment Value Statistics
-- Task: Find minimum, maximum, and average payment values
-- Python Equivalent: payments_df['payment_value'].describe()
-- Hint: SELECT MIN(payment_value), MAX(payment_value), AVG(payment_value) FROM olist_sales_data_set.olist_order_payments_dataset;

-- Your solution here:




-- Exercise 14: Missing Data Check
-- Task: Count how many orders have missing delivery dates
-- Python Equivalent: orders_df['order_delivered_customer_date'].isnull().sum()
-- Hint: SELECT COUNT(*) - COUNT(order_delivered_customer_date) FROM olist_sales_data_set.olist_orders_dataset;

-- Your solution here:




-- =============================================================================
-- BUSINESS QUESTIONS (Medium Difficulty)
-- =============================================================================

-- Exercise 15: Customer Concentration
-- Task: Which city in São Paulo (SP) state has the most customers?
-- Python Equivalent: customers_df[customers_df['customer_state'] == 'SP']['customer_city'].value_counts()
-- Hint: SELECT customer_city, COUNT(*) FROM olist_sales_data_set.olist_customers_dataset WHERE customer_state = 'SP' GROUP BY customer_city ORDER BY COUNT(*) DESC;

-- Your solution here:




-- Exercise 16: High-Value Payments
-- Task: Find all payments over R$ 1000, ordered by value (highest first)
-- Python Equivalent: payments_df[payments_df['payment_value'] > 1000].sort_values('payment_value', ascending=False)
-- Hint: SELECT * FROM olist_sales_data_set.olist_order_payments_dataset WHERE payment_value > 1000 ORDER BY payment_value DESC;

-- Your solution here:




-- Exercise 17: Product Category Exploration
-- Task: How many different product categories do we have? (exclude NULL values)
-- Python Equivalent: products_df['product_category_name'].nunique()
-- Hint: SELECT COUNT(DISTINCT product_category_name) FROM olist_sales_data_set.olist_products_dataset WHERE product_category_name IS NOT NULL;

-- Your solution here:




-- =============================================================================
-- TIME-BASED ANALYSIS
-- =============================================================================

-- Exercise 18: Monthly Order Pattern
-- Task: Count orders by month for the year 2018
-- Python Equivalent: orders_df[orders_df['order_purchase_timestamp'].dt.year == 2018].groupby(orders_df['order_purchase_timestamp'].dt.month).size()
-- Hint: SELECT EXTRACT(MONTH FROM order_purchase_timestamp) as month, COUNT(*) FROM olist_sales_data_set.olist_orders_dataset WHERE EXTRACT(YEAR FROM order_purchase_timestamp) = 2018 GROUP BY EXTRACT(MONTH FROM order_purchase_timestamp) ORDER BY month;

-- Your solution here:




-- Exercise 19: Day of Week Analysis  
-- Task: Which day of the week has the most orders?
-- Hint: SELECT EXTRACT(DOW FROM order_purchase_timestamp) as day_of_week, COUNT(*) FROM olist_sales_data_set.olist_orders_dataset GROUP BY EXTRACT(DOW FROM order_purchase_timestamp) ORDER BY COUNT(*) DESC;

-- Your solution here:




-- =============================================================================
-- ADVANCED CHALLENGES (For Early Finishers)
-- =============================================================================

-- Challenge 20: Customer Satisfaction Overview
-- Task: Show the distribution of review scores (1-5 stars)
-- Python Equivalent: reviews_df['review_score'].value_counts().sort_index()
-- Hint: SELECT review_score, COUNT(*) FROM olist_sales_data_set.olist_order_reviews_dataset GROUP BY review_score ORDER BY review_score;

-- Your solution here:




-- Challenge 21: Revenue by Payment Type
-- Task: Calculate total revenue for each payment method
-- Python Equivalent: payments_df.groupby('payment_type')['payment_value'].sum().sort_values(ascending=False)
-- Hint: SELECT payment_type, SUM(payment_value) FROM olist_sales_data_set.olist_order_payments_dataset GROUP BY payment_type ORDER BY SUM(payment_value) DESC;

-- Your solution here:




-- Challenge 22: Geographic Revenue Analysis
-- Task: Which state generates the most revenue? (Join orders, customers, payments)
-- This is advanced - combines multiple tables!
-- Hint: You'll need to JOIN olist_sales_data_set.olist_orders_dataset, olist_sales_data_set.olist_customers_dataset, and olist_sales_data_set.olist_order_payments_dataset

-- Your solution here:




-- =============================================================================
-- REFLECTION SECTION
-- =============================================================================

-- Exercise 23: Personal Reflection
-- Task: Write a comment comparing your experience today vs. yesterday

/*
Reflection Questions:
1. Which felt more natural - Python or SQL? Why?
2. What was similar between Python DataFrames and SQL tables?
3. What was different?
4. Which business questions were easier to answer in SQL vs Python?
5. What concepts from yesterday helped you today?

Write your thoughts here:




*/

-- =============================================================================
-- SUCCESS CHECK: Can You Do These Without Hints?
-- =============================================================================

-- Quick Check 1: Count total customers

-- Quick Check 2: Show 5 newest orders

-- Quick Check 3: List all unique order statuses

-- Quick Check 4: Find the most expensive single payment

-- =============================================================================
-- BONUS: Creative Analysis
-- =============================================================================

-- Bonus Exercise: Choose Your Own Adventure
-- Task: Write a query that answers a business question YOU find interesting
-- Examples: 
-- - Which product weighs the most?
-- - What's the longest product name?
-- - Which month had the lowest sales?
-- - How many customers are from your favorite Brazilian city?

-- Your creative query here:




/*
CONGRATULATIONS! 🎉

If you completed these exercises, you've successfully:

✅ Connected SQL concepts to yesterday's Python success
✅ Written basic SELECT queries with business context  
✅ Used COUNT, MIN, MAX, AVG for data analysis
✅ Applied sorting and filtering for insights
✅ Analyzed categorical data using GROUP BY
✅ Performed time-based analysis with date functions
✅ Gained confidence in database querying

Key Insight: You used the same analytical thinking as yesterday,
just with different syntax. The business questions and logical
approach remained consistent!

Next Steps: 
- Review solutions in the solutions folder
- Prepare for Week 2: Data Filtering (WHERE clauses)
- Feel proud - you can now work with both Python AND SQL! 💪
*/