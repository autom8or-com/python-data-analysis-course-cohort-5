-- ================================================================
-- WEEK 8 SQL EXERCISES: Advanced Filtering & Subqueries
-- Student Name: _________________________
-- Date: _________________________
-- ================================================================

/*
INSTRUCTIONS:
1. Read each question carefully
2. Write your SQL query below each question
3. Test your query to ensure it runs without errors
4. Compare your results with expected output where provided
5. Ask for help if stuck for more than 15 minutes!

DATABASE: olist_sales_data_set and olist_marketing_data_set schemas
ESTIMATED TIME: 90 minutes
*/

-- ================================================================
-- PART 1: ADVANCED WHERE CLAUSES (25 minutes)
-- ================================================================

-- EXERCISE 1.1: Payment Method Analysis
-- Find all orders paid with 'boleto' or 'voucher' where the payment
-- value is between R$ 50 and R$ 150 (inclusive).
-- Expected columns: order_id, payment_type, payment_value
-- Order by: payment_value DESC
-- Limit: 15 rows

-- YOUR QUERY HERE:



-- EXERCISE 1.2: Northeast Region Customers
-- Identify customers from Northeast states ('BA', 'PE', 'CE', 'RN', 'PB')
-- who have placed MORE than one delivered order.
-- Expected columns: customer_unique_id, customer_state, order_count
-- Order by: order_count DESC, customer_state
-- Limit: 20 rows

-- YOUR QUERY HERE:



-- EXERCISE 1.3: Negative Reviews with Comments
-- Find all reviews with scores of 1 or 2 WHERE the customer left a
-- written comment (review_comment_message IS NOT NULL).
-- Expected columns: review_id, order_id, review_score, review_comment_message
-- Order by: review_score ASC
-- Limit: 10 rows

-- YOUR QUERY HERE:



-- EXERCISE 1.4: Dormant High-Value Customers
-- Create a list of customers who:
-- - Have total lifetime spending over R$ 300
-- - Haven't ordered in 200+ days (use '2018-09-01' as reference date)
-- - Are from 'SP', 'RJ', or 'MG' states
-- Expected columns: customer_unique_id, customer_state, lifetime_value,
--                   last_order_date, days_since_last_order
-- Order by: lifetime_value DESC
-- Limit: 15 rows

-- YOUR QUERY HERE:



-- ================================================================
-- PART 2: SUBQUERIES IN WHERE CLAUSE (25 minutes)
-- ================================================================

-- EXERCISE 2.1: Above-Average Order Values
-- Find all order items where the total value (price + freight_value)
-- exceeds the AVERAGE total value by more than 50%.
-- Formula: (price + freight_value) > (AVG * 1.5)
-- Expected columns: order_id, product_id, price, freight_value, total_value
-- Order by: total_value DESC
-- Limit: 20 rows

-- YOUR QUERY HERE:



-- EXERCISE 2.2: Top Product Categories
-- Find all products that belong to the top 5 product categories by
-- total sales count. Use a subquery to identify the top 5 categories first.
-- Expected columns: product_id, product_category_name
-- Order by: product_category_name, product_id
-- Limit: 30 rows

-- YOUR QUERY HERE:



-- EXERCISE 2.3: Silent High-Value Customers
-- Identify customers who have:
-- - 3 or more delivered orders
-- - NEVER left a review (NOT EXISTS)
-- - Total spending > R$ 200
-- Expected columns: customer_unique_id, customer_state, total_orders,
--                   lifetime_value
-- Order by: lifetime_value DESC
-- Limit: 20 rows

-- YOUR QUERY HERE:



-- EXERCISE 2.4: Seasonal Shoppers
-- Find customers who made purchases in Q1 2018 (Jan-Mar) but NOT in
-- Q2 2018 (Apr-Jun). Use subqueries with IN and NOT IN.
-- Expected columns: customer_unique_id, customer_state, q1_orders
-- Order by: q1_orders DESC
-- Limit: 15 rows

-- YOUR QUERY HERE:



-- ================================================================
-- PART 3: COMMON TABLE EXPRESSIONS (CTEs) (40 minutes)
-- ================================================================

-- EXERCISE 3.1: Product Performance Dashboard
-- Create a 3-stage CTE query that:
-- Stage 1 (product_sales): Calculate total sales, revenue, and average price per product
-- Stage 2 (product_reviews): Calculate review metrics per product
-- Stage 3 (product_intelligence): Combine both and categorize products
--
-- Final output should show products with:
-- - "High Volume" (50+ sales) or "Medium Volume" (20-49 sales)
-- - "Low Satisfaction" (avg score < 3) or "Medium Satisfaction" (3-4)
-- - At least 5 reviews
--
-- Expected columns: product_id, product_category_name, times_sold,
--                   total_revenue, avg_review_score, total_reviews,
--                   volume_category, satisfaction_category
-- Order by: times_sold DESC
-- Limit: 15 rows

-- YOUR QUERY HERE:



-- EXERCISE 3.2: Customer Lifecycle Analysis
-- Build a CTE pipeline that identifies customer lifecycle stages:
--
-- CTE 1 (customer_orders): Get first and last order dates for each customer
-- CTE 2 (customer_segments): Categorize customers as:
--   - "New" (only 1 order)
--   - "Active Repeat" (2+ orders, last order within 90 days)
--   - "At Risk" (2+ orders, last order 91-180 days ago)
--   - "Dormant" (2+ orders, last order 181+ days ago)
--
-- Final output: Show count and average metrics per segment
-- Expected columns: segment, customer_count, avg_orders, avg_days_inactive
-- Order by: customer_count DESC

-- YOUR QUERY HERE:



-- EXERCISE 3.3: State Performance Comparison
-- Create a query that compares each state's performance to national averages:
--
-- CTE 1 (state_metrics): Calculate metrics per state (orders, revenue, customers)
-- CTE 2 (national_averages): Calculate overall national averages
-- CTE 3 (state_comparison): Show each state vs national average
--
-- Expected columns: customer_state, total_orders, total_revenue,
--                   national_avg_revenue, revenue_vs_national_pct
-- Order by: revenue_vs_national_pct DESC
-- Limit: 10 states

-- YOUR QUERY HERE:



-- EXERCISE 3.4: Retention Campaign Targets (CHALLENGE!)
-- Design a comprehensive CTE-based query that creates a prioritized
-- retention campaign target list:
--
-- CTE 1: Customer purchase behavior (orders, spend, dates)
-- CTE 2: Customer satisfaction metrics (reviews, scores)
-- CTE 3: Customer payment preferences (most used payment method)
-- CTE 4: Risk scoring and segmentation
-- CTE 5: Final prioritization with recommended actions
--
-- Target customers who are:
-- - High lifetime value (>R$ 400)
-- - Prefer credit card payments
-- - Either: At risk (90-180 days inactive) OR had a bad experience (review ≤ 2)
--
-- Expected columns: customer_unique_id, customer_state, lifetime_value,
--                   days_inactive, avg_review_score, preferred_payment,
--                   risk_category, priority_score, recommended_action
-- Order by: priority_score DESC
-- Limit: 25 rows

-- YOUR QUERY HERE:



-- ================================================================
-- BONUS CHALLENGES (Optional)
-- ================================================================

-- BONUS 1: Cross-Sell Opportunities
-- Find products frequently bought together. Use CTEs to:
-- 1. Identify orders with exactly 2 products
-- 2. Find the most common product pairs
-- 3. Show pairs where both products have good reviews (avg score ≥ 4)

-- YOUR QUERY HERE:



-- BONUS 2: Cohort Retention Analysis
-- Create a cohort analysis showing customer retention by their
-- first purchase month. Show what percentage of each monthly cohort
-- made repeat purchases in subsequent months.

-- YOUR QUERY HERE:



-- ================================================================
-- REFLECTION QUESTIONS (Write answers as SQL comments)
-- ================================================================

/*
Q1: When would you use EXISTS instead of IN? Give a real business example.
ANSWER:


Q2: What's the main advantage of CTEs over nested subqueries?
ANSWER:


Q3: How would you optimize a query with multiple correlated subqueries?
ANSWER:


Q4: Describe a business scenario from your own experience where advanced
    filtering and subqueries would be valuable.
ANSWER:


*/

-- ================================================================
-- END OF EXERCISES
-- Remember to save your work and test all queries before submission!
-- ================================================================
