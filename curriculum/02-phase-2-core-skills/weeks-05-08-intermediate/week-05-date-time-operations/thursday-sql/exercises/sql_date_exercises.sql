-- Week 5: Date & Time Operations - SQL Exercises
-- Business Scenario: NaijaCommerce Seasonal Analysis & Operations Optimization
-- Instructions: Complete each exercise to help NaijaCommerce understand their temporal business patterns

-- =============================================================================
-- EXERCISE SET 1: BASIC DATE EXTRACTION AND FORMATTING
-- =============================================================================

-- Exercise 1.1: Monthly Sales Overview
-- Business Context: The marketing team needs a monthly sales report for 2017-2018
-- Task: Create a summary showing month, year, total orders, and unique customers

-- YOUR CODE HERE:
-- Hint: Use EXTRACT() function and GROUP BY with month/year
-- Expected columns: year, month, month_name, total_orders, unique_customers


-- Exercise 1.2: Weekend vs Weekday Shopping Patterns
-- Business Context: Operations team wants to optimize staffing based on shopping patterns
-- Task: Compare shopping patterns between weekdays and weekends

-- YOUR CODE HERE:
-- Hint: Use EXTRACT(DOW FROM date) and CASE statement to classify days
-- Expected columns: day_type (Weekend/Weekday), total_orders, percentage_of_total


-- Exercise 1.3: Peak Shopping Hours Analysis
-- Business Context: Customer service team needs to know when customers are most active
-- Task: Find the top 5 shopping hours by order volume

-- YOUR CODE HERE:
-- Hint: Extract hour from timestamp and count orders
-- Expected columns: hour_of_day, order_count, rank_by_orders


-- =============================================================================
-- EXERCISE SET 2: SEASONAL REVENUE ANALYSIS
-- =============================================================================

-- Exercise 2.1: Quarterly Performance Comparison
-- Business Context: Executive team wants to see quarterly revenue trends
-- Task: Calculate revenue and orders by quarter, including growth rates

-- YOUR CODE HERE:
-- Hint: JOIN orders with order_items, use EXTRACT(QUARTER) and window functions
-- Expected columns: year, quarter, total_orders, total_revenue, quarter_over_quarter_growth


-- Exercise 2.2: Holiday Season Impact Analysis
-- Business Context: Identify which months are "holiday seasons" based on performance
-- Task: Find months with above-average sales and classify them as peak/regular periods

-- YOUR CODE HERE:
-- Hint: Use window functions to calculate overall average, then compare each month
-- Expected columns: month, month_name, total_revenue, avg_revenue_all_months, classification


-- Exercise 2.3: Year-over-Year Growth Analysis
-- Business Context: Track business growth by comparing same months across different years
-- Task: Calculate month-over-month growth for 2017 vs 2018

-- YOUR CODE HERE:
-- Hint: Use LAG() window function with proper partitioning
-- Expected columns: year, month, total_orders, prev_year_orders, yoy_growth_percent


-- =============================================================================
-- EXERCISE SET 3: DELIVERY PERFORMANCE METRICS
-- =============================================================================

-- Exercise 3.1: Average Delivery Time by Month
-- Business Context: Logistics team needs to understand seasonal delivery performance
-- Task: Calculate average delivery time and identify months with poor performance

-- YOUR CODE HERE:
-- Hint: Use date arithmetic between purchase and delivery dates
-- Expected columns: month_year, total_deliveries, avg_delivery_days, performance_rating


-- Exercise 3.2: Delivery Performance Benchmarking
-- Business Context: Set delivery time targets based on historical performance
-- Task: Calculate delivery time percentiles and identify performance targets

-- YOUR CODE HERE:
-- Hint: Use PERCENTILE_CONT() function for statistical analysis
-- Expected columns: year, p50_delivery_days, p75_delivery_days, p95_delivery_days


-- Exercise 3.3: Late Delivery Analysis
-- Business Context: Identify patterns in late deliveries to improve logistics
-- Task: Find orders delivered later than estimated and analyze the patterns

-- YOUR CODE HERE:
-- Hint: Compare delivery date with estimated delivery date
-- Expected columns: month, total_orders, late_deliveries, late_delivery_rate, avg_delay_days


-- =============================================================================
-- EXERCISE SET 4: CUSTOMER BEHAVIOR TEMPORAL ANALYSIS
-- =============================================================================

-- Exercise 4.1: Customer Purchase Frequency by Season
-- Business Context: Marketing wants to understand customer engagement patterns
-- Task: Analyze how often customers make repeat purchases by quarter

-- YOUR CODE HERE:
-- Hint: Use window functions to identify customer purchase sequences
-- Expected columns: quarter, total_customers, repeat_customers, repeat_purchase_rate


-- Exercise 4.2: New vs Returning Customer Trends
-- Business Context: Growth team needs to track customer acquisition vs retention
-- Task: Identify customer acquisition patterns by month

-- YOUR CODE HERE:
-- Hint: Find each customer's first order date, then categorize subsequent orders
-- Expected columns: month_year, new_customers, returning_customers, customer_mix_ratio


-- Exercise 4.3: Customer Lifetime Analysis
-- Business Context: Calculate customer lifetime value patterns
-- Task: Analyze customer purchase spans and frequency

-- YOUR CODE HERE:
-- Hint: Calculate time between first and last order for each customer
-- Expected columns: customer_lifetime_months, customer_count, avg_orders_per_customer


-- =============================================================================
-- EXERCISE SET 5: ADVANCED TEMPORAL BUSINESS INTELLIGENCE
-- =============================================================================

-- Exercise 5.1: Rolling Averages for Trend Analysis
-- Business Context: Smooth out daily fluctuations to identify true trends
-- Task: Calculate 7-day and 30-day moving averages for daily orders

-- YOUR CODE HERE:
-- Hint: Use window functions with ROWS BETWEEN for moving windows
-- Expected columns: date, daily_orders, rolling_7d_avg, rolling_30d_avg


-- Exercise 5.2: Cohort Analysis by Registration Month
-- Business Context: Understand customer retention patterns by signup period
-- Task: Create a cohort analysis showing customer retention rates

-- YOUR CODE HERE:
-- Hint: Group customers by first order month, track subsequent activity
-- Expected columns: cohort_month, months_since_first_order, active_customers, retention_rate


-- Exercise 5.3: Seasonal Inventory Planning Analysis
-- Business Context: Help inventory team plan stock levels based on seasonal patterns
-- Task: Calculate seasonal demand patterns with predictive insights

-- YOUR CODE HERE:
-- Hint: Calculate seasonal indices and compare across multiple years
-- Expected columns: month, avg_orders, seasonal_index, recommended_stock_level


-- =============================================================================
-- NIGERIAN BUSINESS CONTEXT EXERCISES
-- =============================================================================

-- Exercise 6.1: Rainy Season Impact Analysis
-- Business Context: Understand how Nigerian weather patterns affect e-commerce
-- Task: Compare delivery performance between rainy and dry seasons

-- YOUR CODE HERE:
-- Hint: Classify months into rainy (May-Oct) and dry (Nov-Apr) seasons
-- Expected columns: season_type, avg_delivery_days, order_volume, delivery_performance


-- Exercise 6.2: Nigerian Holiday Impact Analysis
-- Business Context: Plan for major Nigerian holidays and cultural events
-- Task: Identify sales spikes around major Nigerian holidays

-- YOUR CODE HERE:
-- Hint: Focus on December (Christmas), October (Independence), and month-end patterns
-- Expected columns: month, holiday_type, sales_spike_factor, recommended_preparation


-- Exercise 6.3: Business Day vs Holiday Analysis
-- Business Context: Optimize operations for Nigerian working calendar
-- Task: Compare business metrics between regular business days and holidays

-- YOUR CODE HERE:
-- Hint: Use date functions to identify weekends and known holiday periods
-- Expected columns: day_type, avg_daily_orders, customer_behavior_pattern


-- =============================================================================
-- SUBMISSION GUIDELINES
-- =============================================================================

/*
1. Write clean, well-commented SQL code
2. Include business insights as comments above each query
3. Test your queries with LIMIT clauses first
4. Ensure your results make business sense
5. Consider data quality issues (NULL values, outliers)
6. Format your dates appropriately for business reporting

EVALUATION CRITERIA:
- Correct use of date functions (40%)
- Business relevance of analysis (30%)
- Code quality and readability (20%)
- Data quality considerations (10%)

Submit your completed exercises as a single .sql file with clear section headers.
*/