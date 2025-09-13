-- ====================================================================
-- WEEK 4: SQL AGGREGATIONS & SUMMARY STATISTICS - EXERCISES
-- Thursday SQL Class - September 4, 2025
-- Student Name: _________________ Date: _________________
-- ====================================================================

-- INSTRUCTIONS:
-- Complete each exercise below using the Olist e-commerce dataset
-- Focus on applying aggregation functions, GROUP BY, HAVING, and basic window functions
-- Write clean, well-commented SQL queries
-- Test your results to ensure they make business sense

-- ====================================================================
-- PART A: BASIC AGGREGATIONS (20 points)
-- ====================================================================

-- Exercise A1 (5 points)
-- Business Question: What's the total number of delivered orders and their total revenue?
-- Write a query to show: total_orders, total_revenue, average_order_value
-- YOUR CODE HERE:


-- Exercise A2 (5 points)
-- Business Question: What are the minimum, maximum, and average freight costs?
-- Include only delivered orders in your analysis
-- YOUR CODE HERE:


-- Exercise A3 (5 points)
-- Business Question: How many unique customers, sellers, and products are in our delivered orders?
-- Show all three counts in a single query
-- YOUR CODE HERE:


-- Exercise A4 (5 points)
-- Business Question: What's the total payment value by payment type?
-- Order results from highest to lowest total value
-- YOUR CODE HERE:


-- ====================================================================
-- PART B: GROUP BY ANALYSIS (30 points)
-- ====================================================================

-- Exercise B1 (10 points)
-- Business Question: Analyze sales performance by customer state
-- Show: state, total_orders, total_revenue, average_order_value, unique_customers
-- Include only states with at least 50 orders
-- Order by total revenue (highest first)
-- YOUR CODE HERE:


-- Exercise B2 (10 points) 
-- Business Question: Which product categories generate the most revenue?
-- Show: category (English name), total_orders, total_revenue, average_price
-- Include only categories with at least 100 orders
-- Order by total revenue descending
-- YOUR CODE HERE:


-- Exercise B3 (10 points)
-- Business Question: Analyze monthly sales trends
-- Show: year, month, total_orders, total_revenue, unique_customers
-- Include only delivered orders from 2017-2018
-- Order chronologically (year, then month)
-- YOUR CODE HERE:


-- ====================================================================
-- PART C: HAVING CLAUSE & CONDITIONAL AGGREGATIONS (25 points)
-- ====================================================================

-- Exercise C1 (10 points)
-- Business Question: Which seller cities have high-performing sellers?
-- Show cities where:
-- - Average order value is above 120
-- - Total orders >= 100
-- - At least 5 different sellers
-- Display: seller_state, seller_city, total_orders, avg_order_value, seller_count
-- YOUR CODE HERE:


-- Exercise C2 (15 points)
-- Business Question: Customer satisfaction analysis by price range
-- Create price categories: 
-- - 'Budget' (< 50), 'Standard' (50-150), 'Premium' (150-300), 'Luxury' (300+)
-- For each category show:
-- - Total orders, average rating, percentage of 5-star reviews
-- - Only include categories with at least 500 orders
-- YOUR CODE HERE:


-- ====================================================================
-- PART D: WINDOW FUNCTIONS (25 points)
-- ====================================================================

-- Exercise D1 (10 points)
-- Business Question: Rank the top 10 states by total revenue
-- Show: state, total_revenue, revenue_rank, percent_of_total_revenue
-- Use ROW_NUMBER() for ranking
-- YOUR CODE HERE:


-- Exercise D2 (15 points)
-- Business Question: Monthly revenue growth analysis
-- Show each month's revenue compared to the previous month
-- Display: year, month, monthly_revenue, previous_month_revenue, growth_percentage
-- Include only months with complete data (orders from both current and previous month)
-- Order chronologically
-- YOUR CODE HERE:


-- ====================================================================
-- PART E: COMPREHENSIVE BUSINESS ANALYSIS (BONUS - 10 points)
-- ====================================================================

-- Exercise E1 (10 points)
-- Business Challenge: Create an executive dashboard query
-- 
-- Requirements:
-- 1. Combine multiple aggregation techniques
-- 2. Include at least one window function
-- 3. Use conditional aggregations (CASE statements)
-- 4. Filter for business relevance (HAVING clauses)
-- 5. Present actionable business insights
-- 
-- Suggested focus: Regional performance analysis with growth trends
-- or Category performance with customer satisfaction metrics
-- 
-- YOUR CODE HERE:


-- ====================================================================
-- SUBMISSION CHECKLIST:
-- ====================================================================

-- Before submitting, verify:
-- [ ] All queries execute without errors
-- [ ] Results make business sense
-- [ ] Queries are properly commented
-- [ ] Correct aggregate functions used
-- [ ] GROUP BY used appropriately
-- [ ] HAVING clauses filter aggregated data correctly
-- [ ] Window functions preserve row count where appropriate
-- [ ] Business questions are fully answered

-- ====================================================================
-- SELF-ASSESSMENT QUESTIONS:
-- ====================================================================

-- 1. How do SQL aggregations compare to Excel SUMIF/COUNTIF functions?

-- 2. When should you use HAVING vs WHERE in aggregation queries?

-- 3. What's the key difference between aggregate functions and window functions?

-- 4. How can these SQL techniques help analyze business performance?