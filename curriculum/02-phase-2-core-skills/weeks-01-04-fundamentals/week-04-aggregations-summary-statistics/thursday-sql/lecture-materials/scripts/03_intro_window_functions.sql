-- ====================================================================
-- WEEK 4: AGGREGATIONS & SUMMARY STATISTICS - PART 3: INTRO TO WINDOW FUNCTIONS
-- Thursday SQL Class - September 4, 2025
-- Business Context: Running Totals, Rankings, and Comparative Analysis
-- ====================================================================

-- LEARNING OBJECTIVES:
-- 1. Understand window functions vs aggregate functions
-- 2. Create business rankings and percentiles
-- 3. Calculate running totals and moving averages
-- 4. Implement comparative analysis (vs previous period, vs average)

-- ====================================================================
-- SECTION 1: WINDOW FUNCTIONS FUNDAMENTALS
-- ====================================================================

-- Window functions vs Aggregate functions:
-- Aggregate: GROUP BY collapses rows into groups
-- Window: OVER() keeps all rows while adding calculated values

-- Basic syntax: function() OVER (PARTITION BY column ORDER BY column)

-- ====================================================================
-- SECTION 2: RANKING FUNCTIONS - BUSINESS PERFORMANCE RANKINGS
-- ====================================================================

-- 2.1 ROW_NUMBER() - Unique ranking
-- Business Question: Rank our top-performing states by revenue
SELECT 
    c.customer_state,
    SUM(oi.price) as total_revenue,
    COUNT(DISTINCT o.order_id) as total_orders,
    ROW_NUMBER() OVER (ORDER BY SUM(oi.price) DESC) as revenue_rank
FROM olist_sales_data_set.olist_customers_dataset c
JOIN olist_sales_data_set.olist_orders_dataset o ON c.customer_id = o.customer_id
JOIN olist_sales_data_set.olist_order_items_dataset oi ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered'
GROUP BY c.customer_state
ORDER BY revenue_rank;

-- 2.2 RANK() and DENSE_RANK() - Handling ties
-- Business Question: Rank product categories by average customer satisfaction
-- (RANK skips numbers after ties, DENSE_RANK doesn't)
SELECT 
    t.product_category_name_english as category,
    COUNT(r.review_id) as review_count,
    ROUND(AVG(r.review_score), 2) as avg_rating,
    RANK() OVER (ORDER BY AVG(r.review_score) DESC) as satisfaction_rank,
    DENSE_RANK() OVER (ORDER BY AVG(r.review_score) DESC) as satisfaction_dense_rank
FROM olist_sales_data_set.olist_order_reviews_dataset r
JOIN olist_sales_data_set.olist_orders_dataset o ON r.order_id = o.order_id
JOIN olist_sales_data_set.olist_order_items_dataset oi ON o.order_id = oi.order_id
JOIN olist_sales_data_set.olist_products_dataset p ON oi.product_id = p.product_id
JOIN olist_sales_data_set.product_category_name_translation t ON p.product_category_name = t.product_category_name
WHERE r.review_score IS NOT NULL
GROUP BY t.product_category_name_english
HAVING COUNT(r.review_id) >= 100  -- Statistically significant
ORDER BY avg_rating DESC;

-- 2.3 NTILE() - Creating business segments
-- Business Question: Segment our customers into quartiles by order value
-- (Nigerian context: Premium, Standard, Budget customer segments)
SELECT 
    c.customer_id,
    c.customer_state,
    SUM(oi.price) as total_spent,
    COUNT(o.order_id) as total_orders,
    NTILE(4) OVER (ORDER BY SUM(oi.price) DESC) as customer_quartile,
    CASE 
        WHEN NTILE(4) OVER (ORDER BY SUM(oi.price) DESC) = 1 THEN 'Premium (Top 25%)'
        WHEN NTILE(4) OVER (ORDER BY SUM(oi.price) DESC) = 2 THEN 'High Value (25-50%)'
        WHEN NTILE(4) OVER (ORDER BY SUM(oi.price) DESC) = 3 THEN 'Standard (50-75%)'
        ELSE 'Budget (Bottom 25%)'
    END as customer_segment
FROM olist_sales_data_set.olist_customers_dataset c
JOIN olist_sales_data_set.olist_orders_dataset o ON c.customer_id = o.customer_id
JOIN olist_sales_data_set.olist_order_items_dataset oi ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered'
GROUP BY c.customer_id, c.customer_state
HAVING COUNT(o.order_id) >= 2  -- Repeat customers only
ORDER BY total_spent DESC
LIMIT 20;

-- ====================================================================
-- SECTION 3: AGGREGATE WINDOW FUNCTIONS - RUNNING CALCULATIONS
-- ====================================================================

-- 3.1 SUM() OVER() - Running totals
-- Business Question: Show cumulative revenue by month
-- (Critical for cash flow and growth analysis)
WITH monthly_revenue AS (
    SELECT 
        EXTRACT(YEAR FROM o.order_purchase_timestamp) as year,
        EXTRACT(MONTH FROM o.order_purchase_timestamp) as month,
        SUM(oi.price) as monthly_revenue
    FROM olist_sales_data_set.olist_orders_dataset o
    JOIN olist_sales_data_set.olist_order_items_dataset oi ON o.order_id = oi.order_id
    WHERE o.order_status = 'delivered'
      AND o.order_purchase_timestamp IS NOT NULL
    GROUP BY 
        EXTRACT(YEAR FROM o.order_purchase_timestamp),
        EXTRACT(MONTH FROM o.order_purchase_timestamp)
)
SELECT 
    year,
    month,
    monthly_revenue,
    SUM(monthly_revenue) OVER (
        ORDER BY year, month 
        ROWS UNBOUNDED PRECEDING
    ) as cumulative_revenue,
    ROUND(
        (monthly_revenue / SUM(monthly_revenue) OVER (
            ORDER BY year, month 
            ROWS UNBOUNDED PRECEDING
        )) * 100, 2
    ) as percent_of_cumulative
FROM monthly_revenue
ORDER BY year, month;

-- 3.2 AVG() OVER() with moving window - Trend analysis
-- Business Question: Calculate 3-month moving average of orders
WITH monthly_orders AS (
    SELECT 
        EXTRACT(YEAR FROM o.order_purchase_timestamp) as year,
        EXTRACT(MONTH FROM o.order_purchase_timestamp) as month,
        COUNT(DISTINCT o.order_id) as monthly_orders
    FROM olist_sales_data_set.olist_orders_dataset o
    WHERE o.order_status = 'delivered'
      AND o.order_purchase_timestamp IS NOT NULL
    GROUP BY 
        EXTRACT(YEAR FROM o.order_purchase_timestamp),
        EXTRACT(MONTH FROM o.order_purchase_timestamp)
)
SELECT 
    year,
    month,
    monthly_orders,
    ROUND(
        AVG(monthly_orders) OVER (
            ORDER BY year, month 
            ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
        ), 1
    ) as three_month_avg,
    ROUND(
        AVG(monthly_orders) OVER (
            ORDER BY year, month 
            ROWS BETWEEN 5 PRECEDING AND CURRENT ROW
        ), 1
    ) as six_month_avg
FROM monthly_orders
ORDER BY year, month;

-- ====================================================================
-- SECTION 4: PARTITIONED WINDOW FUNCTIONS - COMPARATIVE ANALYSIS
-- ====================================================================

-- 4.1 Compare each state's performance to overall average
-- Business Question: How does each state perform vs national average?
SELECT 
    c.customer_state,
    COUNT(DISTINCT o.order_id) as state_orders,
    SUM(oi.price) as state_revenue,
    ROUND(AVG(oi.price), 2) as state_avg_order_value,
    ROUND(AVG(AVG(oi.price)) OVER (), 2) as national_avg_order_value,
    ROUND(
        (AVG(oi.price) - AVG(AVG(oi.price)) OVER ()) / AVG(AVG(oi.price)) OVER () * 100, 
        2
    ) as variance_from_national_avg_percent,
    CASE 
        WHEN AVG(oi.price) > AVG(AVG(oi.price)) OVER () THEN 'Above Average'
        ELSE 'Below Average'
    END as performance_vs_national
FROM olist_sales_data_set.olist_customers_dataset c
JOIN olist_sales_data_set.olist_orders_dataset o ON c.customer_id = o.customer_id
JOIN olist_sales_data_set.olist_order_items_dataset oi ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered'
GROUP BY c.customer_state
HAVING COUNT(DISTINCT o.order_id) >= 100  -- States with sufficient data
ORDER BY state_avg_order_value DESC;

-- 4.2 Category performance within each state
-- Business Question: What's the top category in each state?
WITH state_category_performance AS (
    SELECT 
        c.customer_state,
        t.product_category_name_english as category,
        SUM(oi.price) as category_revenue,
        COUNT(oi.order_id) as category_orders,
        ROW_NUMBER() OVER (
            PARTITION BY c.customer_state 
            ORDER BY SUM(oi.price) DESC
        ) as category_rank_in_state
    FROM olist_sales_data_set.olist_customers_dataset c
    JOIN olist_sales_data_set.olist_orders_dataset o ON c.customer_id = o.customer_id
    JOIN olist_sales_data_set.olist_order_items_dataset oi ON o.order_id = oi.order_id
    JOIN olist_sales_data_set.olist_products_dataset p ON oi.product_id = p.product_id
    JOIN olist_sales_data_set.product_category_name_translation t ON p.product_category_name = t.product_category_name
    WHERE o.order_status = 'delivered'
      AND c.customer_state IN ('SP', 'RJ', 'MG', 'RS', 'PR')  -- Top 5 states
    GROUP BY c.customer_state, t.product_category_name_english
)
SELECT 
    customer_state,
    category as top_category,
    category_revenue,
    category_orders,
    ROUND(category_revenue / SUM(category_revenue) OVER (PARTITION BY customer_state) * 100, 2) as percent_of_state_revenue
FROM state_category_performance
WHERE category_rank_in_state <= 3  -- Top 3 categories per state
ORDER BY customer_state, category_rank_in_state;

-- ====================================================================
-- SECTION 5: ADVANCED WINDOW FUNCTIONS - LAG/LEAD FOR TREND ANALYSIS
-- ====================================================================

-- 5.1 Month-over-month growth analysis
-- Business Question: Calculate monthly growth rates
WITH monthly_metrics AS (
    SELECT 
        EXTRACT(YEAR FROM o.order_purchase_timestamp) as year,
        EXTRACT(MONTH FROM o.order_purchase_timestamp) as month,
        COUNT(DISTINCT o.order_id) as orders,
        SUM(oi.price) as revenue,
        COUNT(DISTINCT c.customer_id) as customers
    FROM olist_sales_data_set.olist_orders_dataset o
    JOIN olist_sales_data_set.olist_customers_dataset c ON o.customer_id = c.customer_id
    JOIN olist_sales_data_set.olist_order_items_dataset oi ON o.order_id = oi.order_id
    WHERE o.order_status = 'delivered'
      AND o.order_purchase_timestamp IS NOT NULL
    GROUP BY 
        EXTRACT(YEAR FROM o.order_purchase_timestamp),
        EXTRACT(MONTH FROM o.order_purchase_timestamp)
)
SELECT 
    year,
    month,
    orders,
    revenue,
    customers,
    LAG(revenue) OVER (ORDER BY year, month) as prev_month_revenue,
    ROUND(
        (revenue - LAG(revenue) OVER (ORDER BY year, month)) / 
        LAG(revenue) OVER (ORDER BY year, month) * 100, 2
    ) as revenue_growth_percent,
    LAG(orders) OVER (ORDER BY year, month) as prev_month_orders,
    ROUND(
        (orders - LAG(orders) OVER (ORDER BY year, month))::decimal / 
        LAG(orders) OVER (ORDER BY year, month) * 100, 2
    ) as orders_growth_percent
FROM monthly_metrics
ORDER BY year, month;

-- ====================================================================
-- SECTION 6: PRACTICAL BUSINESS DASHBOARDS WITH WINDOW FUNCTIONS
-- ====================================================================

-- 6.1 Top performers dashboard
-- Business Question: Executive summary of top performers with rankings
SELECT 
    'State Performance' as metric_type,
    c.customer_state as entity,
    SUM(oi.price) as total_revenue,
    COUNT(DISTINCT o.order_id) as total_orders,
    ROUND(AVG(oi.price), 2) as avg_order_value,
    ROW_NUMBER() OVER (ORDER BY SUM(oi.price) DESC) as overall_rank,
    ROUND(
        SUM(oi.price) / SUM(SUM(oi.price)) OVER () * 100, 2
    ) as percent_of_total_revenue
FROM olist_sales_data_set.olist_customers_dataset c
JOIN olist_sales_data_set.olist_orders_dataset o ON c.customer_id = o.customer_id
JOIN olist_sales_data_set.olist_order_items_dataset oi ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered'
GROUP BY c.customer_state

UNION ALL

SELECT 
    'Category Performance' as metric_type,
    t.product_category_name_english as entity,
    SUM(oi.price) as total_revenue,
    COUNT(oi.order_id) as total_orders,
    ROUND(AVG(oi.price), 2) as avg_order_value,
    ROW_NUMBER() OVER (ORDER BY SUM(oi.price) DESC) as overall_rank,
    ROUND(
        SUM(oi.price) / SUM(SUM(oi.price)) OVER () * 100, 2
    ) as percent_of_total_revenue
FROM olist_sales_data_set.olist_order_items_dataset oi
JOIN olist_sales_data_set.olist_products_dataset p ON oi.product_id = p.product_id
JOIN olist_sales_data_set.product_category_name_translation t ON p.product_category_name = t.product_category_name
JOIN olist_sales_data_set.olist_orders_dataset o ON oi.order_id = o.order_id
WHERE o.order_status = 'delivered'
GROUP BY t.product_category_name_english

ORDER BY metric_type, overall_rank
LIMIT 20;

-- ====================================================================
-- KEY TAKEAWAYS FOR WINDOW FUNCTIONS:
-- ====================================================================

/*
1. Window functions preserve all rows while adding calculated columns
2. RANK/ROW_NUMBER create business performance rankings
3. Running totals show cumulative business performance
4. PARTITION BY enables group-wise comparisons
5. LAG/LEAD functions enable period-over-period analysis
6. Combine with CTEs for complex business intelligence reports

BUSINESS APPLICATIONS:
- Customer segmentation (NTILE)
- Sales trend analysis (moving averages)
- Performance rankings (RANK, ROW_NUMBER)
- Growth rate calculations (LAG/LEAD)
- Market share analysis (percentage of total)

NEXT WEEK: We'll build complete business intelligence reports combining all these techniques!
*/