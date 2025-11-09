-- Week 12: Financial Analysis - SQL Exercise
-- Advanced Analytics Functions for Business Intelligence
--
-- Exercise Overview:
-- This exercise will test your ability to use advanced SQL functions for
-- statistical analysis, business intelligence, and financial reporting.
--
-- Learning Objectives:
-- 1. Master statistical functions (STDDEV, VARIANCE, percentiles)
-- 2. Apply window functions for advanced analytics
-- 3. Create business intelligence queries
-- 4. Perform cohort analysis and retention calculations
-- 5. Generate executive-level reporting queries

-- ================================================================================
-- SETUP: Understanding the Database Schema
-- ================================================================================

/*
Database Schema Overview:

Key Tables:
- olist_customers_dataset: Customer information (customer_id, customer_state, customer_city)
- olist_orders_dataset: Order information (order_id, customer_id, timestamps, order_status)
- olist_order_payments_dataset: Payment details (order_id, payment_value, payment_type, installments)
- olist_order_items_dataset: Order line items (order_id, product_id, price, freight_value)
- olist_products_dataset: Product information (product_id, category, dimensions)
- olist_sellers_dataset: Seller information (seller_id, seller_state, seller_city)

Business Context:
- Nigerian e-commerce marketplace data
- Multiple payment methods: credit_card, boleto, debit_card, voucher
- Regional analysis across different states
- Time-based analysis for trend identification
*/

-- ================================================================================
-- EXERCISE 1: BASIC STATISTICAL FUNCTIONS
-- ================================================================================

-- Question 1.1: Calculate comprehensive payment statistics
-- Calculate total revenue, average order value, standard deviation, and coefficient of variation
-- for each Nigerian state. Include only delivered orders.

-- YOUR QUERY HERE:

-- Question 1.2: Payment method performance analysis
-- For each payment type, calculate:
-- - Total revenue and transaction count
-- - Average order value with standard deviation
-- - 25th, 50th (median), and 75th percentiles
-- - Average number of installments

-- YOUR QUERY HERE:

-- Question 1.3: Regional vs National comparison
-- Create a query that compares each state's performance against national benchmarks.
-- Include z-scores to determine statistical significance.

-- YOUR QUERY HERE:

-- ================================================================================
-- EXERCISE 2: ADVANCED WINDOW FUNCTIONS
-- ================================================================================

-- Question 2.1: Customer performance ranking
-- Create a customer performance analysis that shows:
-- - Total spent and average order value per customer
-- - Customer rank within their state
-- - Customer percentile rank nationally
-- - Customer segment based on spending patterns

-- YOUR QUERY HERE:

-- Question 2.2: Time-based trend analysis with window functions
-- Analyze monthly revenue trends with:
-- - Month-over-month growth rates
-- - 3-month moving averages
-- - Year-over-year comparisons
-- - Trend direction indicators

-- YOUR QUERY HERE:

-- Question 2.3: Product performance with window functions
-- Calculate product performance metrics:
-- - Total revenue and quantity sold per product
-- - Product rank within category
-- - Running total of revenue (cumulative)
-- - Top-performing products by revenue percentile

-- YOUR QUERY HERE:

-- ================================================================================
-- EXERCISE 3: COHORT ANALYSIS AND RETENTION
-- ================================================================================

-- Question 3.1: Customer cohort retention analysis
-- Create a cohort analysis that shows:
-- - Customer cohorts by first purchase month
-- - Retention rates for each month after first purchase
-- - Revenue retention over time
-- - Cohort size comparison

-- YOUR QUERY HERE:

-- Question 3.2: Payment method adoption by cohort
-- Analyze how different customer cohorts adopt payment methods:
-- - Payment method preference by cohort
-- - Payment method evolution over time
-- - Average order value changes by cohort and payment method

-- YOUR QUERY HERE:

-- Question 3.3: Customer lifetime value by cohort
-- Calculate customer lifetime value metrics:
-- - CLV per cohort
-- - Time to break-even per cohort
-- - Repeat purchase rates by cohort
-- - Average order frequency by cohort

-- YOUR QUERY HERE:

-- ================================================================================
-- EXERCISE 4: BUSINESS INTELLIGENCE DASHBOARD
-- ================================================================================

-- Question 4.1: Executive KPI dashboard
-- Create a comprehensive executive dashboard with:
-- - Key performance indicators (KPIs)
-- - Performance vs. targets/benchmarks
-- - Trend indicators (up/down/flat)
-- - Risk assessment metrics

-- YOUR QUERY HERE:

-- Question 4.2: Regional performance scorecard
-- Develop a regional scorecard that includes:
-- - Revenue performance ranking
-- - Growth rate assessment
-- - Market penetration metrics
-- - Competitive position analysis

-- YOUR QUERY HERE:

-- Question 4.3: Payment optimization analysis
-- Create payment method optimization insights:
-- - Payment method profitability analysis
-- - Processing cost considerations (assume 2% for credit cards, 1% for others)
-- - Customer preference vs. business profitability
-- - Optimization recommendations

-- YOUR QUERY HERE:

-- ================================================================================
-- EXERCISE 5: ADVANCED STATISTICAL ANALYSIS
-- ================================================================================

-- Question 5.1: Correlation analysis using SQL
-- Identify correlations between:
-- - Order value and payment installments
-- - Regional location and payment preferences
-- - Product categories and order values
-- - Seasonal patterns and purchase behavior

-- YOUR QUERY HERE:

-- Question 5.2: Outlier detection and analysis
-- Implement outlier detection using:
-- - Z-score method (threshold = 3)
-- - IQR method (1.5 * IQR)
-- - Multiple outlier detection criteria
-- - Risk classification for outliers

-- YOUR QUERY HERE:

-- Question 5.3: Statistical significance testing
-- Perform statistical tests to validate:
-- - Regional performance differences (ANOVA-like analysis)
-- - Payment method effectiveness differences
-- - Seasonal trend significance
-- - A/B test scenario analysis

-- YOUR QUERY HERE:

-- ================================================================================
-- EXERCISE 6: PREDICTIVE ANALYTICS FOUNDATIONS
-- ================================================================================

-- Question 6.1: Customer segmentation using statistical patterns
-- Create customer segments based on:
-- - RFM (Recency, Frequency, Monetary) analysis
-- - Statistical clustering using SQL
-- - Behavioral pattern identification
-- - Segment profitability analysis

-- YOUR QUERY HERE:

-- Question 6.2: Churn prediction indicators
-- Identify early warning signs of customer churn:
-- - Decreasing order frequency patterns
-- - Changes in payment method preferences
-- - Time since last purchase analysis
-- - Risk scoring for each customer

-- YOUR QUERY HERE:

-- Question 6.3: Market basket analysis preparation
-- Prepare data for market basket analysis:
-- - Product co-occurrence patterns
-- - Category association analysis
-- - Regional preference patterns
-- - Seasonal product affinities

-- YOUR QUERY HERE:

-- ================================================================================
-- BONUS CHALLENGES
-- ================================================================================

-- Bonus Challenge 1: Advanced Time Series Analysis
-- Create sophisticated time series queries including:
-- - Seasonal decomposition
-- - Trend analysis with statistical significance
-- - Forecasting foundation using moving averages
-- - Anomaly detection in time series data

-- Bonus Challenge 2: Multi-dimensional Analysis
-- Implement cross-dimensional analysis:
-- - Regional x Payment Method x Product Category
-- - Time x Region x Customer Segment
-- - Price x Quality x Satisfaction (proxy analysis)
-- - Complex pivot table operations

-- Bonus Challenge 3: Performance Optimization
-- Optimize your queries for performance:
-- - Index usage recommendations
-- - Query execution plan analysis
-- - Caching strategies for repeated calculations
-- - Materialized view recommendations

-- ================================================================================
-- SOLUTION GUIDELINES
-- ================================================================================

/*
Testing Your Solutions:

1. Verify query accuracy by:
   - Checking row counts against expectations
   - Validating calculations with manual samples
   - Ensuring proper handling of NULL values
   - Testing edge cases and boundary conditions

2. Performance considerations:
   - Use appropriate indexing in WHERE clauses
   - Limit result sets for testing
   - Consider CTEs for complex calculations
   - Optimize JOIN operations

3. Business validation:
   - Results should make logical business sense
   - Check for negative values where inappropriate
   - Validate percentage calculations (0-100% range)
   - Ensure date arithmetic is correct

4. Documentation:
   - Add comments explaining complex logic
   - Document business rules implemented
   - Note any assumptions made
   - Explain any data quality considerations
*/

-- ================================================================================
-- SUBMISSION REQUIREMENTS
-- ================================================================================

/*
Submission Checklist:

1. Completed solutions for all exercises
2. Query results with sample outputs
3. Business interpretation of results
4. Performance optimization notes
5. Any assumptions or limitations noted

Evaluation Criteria:
- Query Accuracy (40%): Correct implementation of statistical functions
- Business Logic (30%): Appropriate business rules and validations
- Performance (20%): Efficient query design and optimization
- Documentation (10%): Clear comments and explanations

Due Date: End of class session
Good luck! 📊🚀
*/