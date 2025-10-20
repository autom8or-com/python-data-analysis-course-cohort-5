-- ================================================================
-- WEEK 9: CUSTOMER LIFETIME VALUE ANALYSIS - PART 1
-- Topic: Subquery Fundamentals - Deep Dive
-- Business Case: Building CLV Metrics with Subqueries
-- ================================================================

/*
LEARNING OBJECTIVES:
1. Master WHERE clause subqueries for dynamic filtering
2. Use FROM clause subqueries (derived tables) for complex aggregations
3. Implement SELECT clause subqueries for correlated calculations
4. Understand when to use each subquery type
5. Optimize subquery performance for business analytics

BUSINESS CONTEXT:
Customer Lifetime Value (CLV) is the total revenue a business expects
from a customer over their entire relationship. This week, we'll build
comprehensive CLV metrics using advanced SQL techniques.

Last week you learned CTEs - this week we go deeper into subqueries
and when to use each technique for maximum efficiency.

FROM EXCEL TO SQL:
- Excel "Helper Columns" = SQL Subqueries in SELECT clause
- Excel Filter by Calculated Value = SQL WHERE clause subqueries
- Excel PivotTable on PivotTable = SQL FROM clause subqueries
*/

-- ================================================================
-- SECTION 1: WHERE Clause Subqueries - Dynamic Filtering
-- ================================================================

/*
WHERE CLAUSE SUBQUERY:
Returns values used to filter the main query.
Must return: Single value (scalar) OR List of values

SYNTAX:
SELECT columns
FROM table
WHERE column [operator] (SELECT ...)

OPERATORS: =, >, <, >=, <=, <>, IN, NOT IN, EXISTS, NOT EXISTS
*/

-- BUSINESS EXAMPLE 1: Find customers who spent more than average

-- First, let's see the average customer lifetime value
SELECT
    ROUND(AVG(total_spent)::numeric, 2) as avg_customer_ltv
FROM (
    SELECT
        c.customer_unique_id,
        SUM(oi.price + oi.freight_value) as total_spent
    FROM olist_sales_data_set.olist_customers_dataset c
    JOIN olist_sales_data_set.olist_orders_dataset o
        ON c.customer_id = o.customer_id
    JOIN olist_sales_data_set.olist_order_items_dataset oi
        ON o.order_id = oi.order_id
    WHERE o.order_status = 'delivered'
    GROUP BY c.customer_unique_id
) customer_spending;

-- Now use that average as a filter with a subquery
SELECT
    c.customer_unique_id,
    c.customer_state,
    c.customer_city,
    SUM(oi.price + oi.freight_value) as lifetime_value,
    COUNT(DISTINCT o.order_id) as total_orders,
    ROUND((SUM(oi.price + oi.freight_value) / COUNT(DISTINCT o.order_id))::numeric, 2) as avg_order_value
FROM olist_sales_data_set.olist_customers_dataset c
JOIN olist_sales_data_set.olist_orders_dataset o
    ON c.customer_id = o.customer_id
JOIN olist_sales_data_set.olist_order_items_dataset oi
    ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered'
GROUP BY c.customer_unique_id, c.customer_state, c.customer_city
HAVING SUM(oi.price + oi.freight_value) > (
    -- Subquery: Calculate average CLV across all customers
    SELECT AVG(total_spent)
    FROM (
        SELECT
            c2.customer_unique_id,
            SUM(oi2.price + oi2.freight_value) as total_spent
        FROM olist_sales_data_set.olist_customers_dataset c2
        JOIN olist_sales_data_set.olist_orders_dataset o2
            ON c2.customer_id = o2.customer_id
        JOIN olist_sales_data_set.olist_order_items_dataset oi2
            ON o2.order_id = oi2.order_id
        WHERE o2.order_status = 'delivered'
        GROUP BY c2.customer_unique_id
    ) customer_totals
)
ORDER BY lifetime_value DESC
LIMIT 50;

-- 💡 Business Insight: Above-average spenders are prime targets for VIP programs

-- BUSINESS EXAMPLE 2: Find customers who bought products from specific high-value categories

-- Using IN with subquery
SELECT
    c.customer_unique_id,
    c.customer_state,
    COUNT(DISTINCT o.order_id) as orders_count,
    SUM(oi.price) as total_spent,
    STRING_AGG(DISTINCT p.product_category_name, ', ') as categories_purchased
FROM olist_sales_data_set.olist_customers_dataset c
JOIN olist_sales_data_set.olist_orders_dataset o
    ON c.customer_id = o.customer_id
JOIN olist_sales_data_set.olist_order_items_dataset oi
    ON o.order_id = oi.order_id
JOIN olist_sales_data_set.olist_products_dataset p
    ON oi.product_id = p.product_id
WHERE o.order_status = 'delivered'
  AND p.product_category_name IN (
      -- Subquery: Find top 10 revenue-generating categories
      SELECT product_category_name
      FROM (
          SELECT
              p2.product_category_name,
              SUM(oi2.price) as category_revenue
          FROM olist_sales_data_set.olist_products_dataset p2
          JOIN olist_sales_data_set.olist_order_items_dataset oi2
              ON p2.product_id = oi2.product_id
          WHERE p2.product_category_name IS NOT NULL
          GROUP BY p2.product_category_name
          ORDER BY category_revenue DESC
          LIMIT 10
      ) top_categories
  )
GROUP BY c.customer_unique_id, c.customer_state
HAVING COUNT(DISTINCT o.order_id) >= 2
ORDER BY total_spent DESC
LIMIT 30;

-- 💡 Business Insight: Customers buying from premium categories are high-value targets

-- BUSINESS EXAMPLE 3: Find orders larger than the customer's average order

SELECT
    o.order_id,
    c.customer_unique_id,
    c.customer_state,
    o.order_purchase_timestamp,
    SUM(oi.price + oi.freight_value) as order_total,
    (
        -- Subquery: This customer's average order value
        SELECT ROUND(AVG(order_sum)::numeric, 2)
        FROM (
            SELECT SUM(oi2.price + oi2.freight_value) as order_sum
            FROM olist_sales_data_set.olist_orders_dataset o2
            JOIN olist_sales_data_set.olist_order_items_dataset oi2
                ON o2.order_id = oi2.order_id
            WHERE o2.customer_id = o.customer_id
              AND o2.order_status = 'delivered'
            GROUP BY o2.order_id
        ) customer_orders
    ) as customer_avg_order
FROM olist_sales_data_set.olist_orders_dataset o
JOIN olist_sales_data_set.olist_customers_dataset c
    ON o.customer_id = c.customer_id
JOIN olist_sales_data_set.olist_order_items_dataset oi
    ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered'
GROUP BY o.order_id, c.customer_unique_id, c.customer_state, o.order_purchase_timestamp, o.customer_id
HAVING SUM(oi.price + oi.freight_value) > (
    SELECT AVG(order_sum)
    FROM (
        SELECT SUM(oi2.price + oi2.freight_value) as order_sum
        FROM olist_sales_data_set.olist_orders_dataset o2
        JOIN olist_sales_data_set.olist_order_items_dataset oi2
            ON o2.order_id = oi2.order_id
        WHERE o2.customer_id = o.customer_id
          AND o2.order_status = 'delivered'
        GROUP BY o2.order_id
    ) customer_orders
)
ORDER BY customer_unique_id, order_total DESC
LIMIT 40;

-- 💡 Business Insight: Unusually large orders might indicate upsell opportunities

-- ================================================================
-- SECTION 2: FROM Clause Subqueries (Derived Tables)
-- ================================================================

/*
FROM CLAUSE SUBQUERY (Derived Table):
Creates a temporary result set treated as a table.
Must be given an alias.

SYNTAX:
SELECT columns
FROM (
    SELECT ...
    FROM ...
) AS alias_name
WHERE ...

USE CASES:
- Pre-aggregating data before joining
- Creating intermediate calculations
- Breaking complex queries into steps
*/

-- BUSINESS EXAMPLE 1: Customer segmentation based on purchase patterns

SELECT
    customer_segment,
    COUNT(*) as customers_in_segment,
    ROUND(AVG(lifetime_value)::numeric, 2) as avg_ltv,
    ROUND(AVG(total_orders)::numeric, 1) as avg_orders,
    ROUND(AVG(avg_order_value)::numeric, 2) as avg_order_value,
    ROUND(SUM(lifetime_value)::numeric, 2) as total_segment_value
FROM (
    -- Derived table: Calculate metrics for each customer
    SELECT
        c.customer_unique_id,
        c.customer_state,
        COUNT(DISTINCT o.order_id) as total_orders,
        SUM(oi.price + oi.freight_value) as lifetime_value,
        AVG(oi.price + oi.freight_value) as avg_order_value,

        -- Segment customers based on behavior
        CASE
            WHEN COUNT(DISTINCT o.order_id) >= 3
                 AND SUM(oi.price + oi.freight_value) > 500
                THEN 'VIP Champions'
            WHEN COUNT(DISTINCT o.order_id) >= 3
                THEN 'Loyal Regulars'
            WHEN SUM(oi.price + oi.freight_value) > 500
                THEN 'High Spenders'
            WHEN COUNT(DISTINCT o.order_id) = 2
                THEN 'Promising Repeaters'
            ELSE 'One-Time Buyers'
        END as customer_segment

    FROM olist_sales_data_set.olist_customers_dataset c
    JOIN olist_sales_data_set.olist_orders_dataset o
        ON c.customer_id = o.customer_id
    JOIN olist_sales_data_set.olist_order_items_dataset oi
        ON o.order_id = oi.order_id
    WHERE o.order_status = 'delivered'
    GROUP BY c.customer_unique_id, c.customer_state
) customer_metrics
GROUP BY customer_segment
ORDER BY total_segment_value DESC;

-- 💡 Business Insight: Focus marketing spend on VIP Champions and converting High Spenders to repeat customers

-- BUSINESS EXAMPLE 2: Monthly cohort analysis for CLV tracking

SELECT
    first_purchase_month,
    COUNT(DISTINCT customer_unique_id) as cohort_size,
    ROUND(AVG(lifetime_value)::numeric, 2) as avg_cohort_ltv,
    ROUND(AVG(total_orders)::numeric, 1) as avg_orders_per_customer,
    ROUND(AVG(days_as_customer)::numeric, 0) as avg_customer_lifespan_days,
    ROUND((AVG(lifetime_value) / NULLIF(AVG(days_as_customer), 0))::numeric, 2) as avg_daily_revenue_per_customer
FROM (
    -- Derived table: Calculate cohort metrics
    SELECT
        c.customer_unique_id,
        TO_CHAR(MIN(o.order_purchase_timestamp), 'YYYY-MM') as first_purchase_month,
        COUNT(DISTINCT o.order_id) as total_orders,
        SUM(oi.price + oi.freight_value) as lifetime_value,
        EXTRACT(DAY FROM MAX(o.order_purchase_timestamp) - MIN(o.order_purchase_timestamp)) as days_as_customer
    FROM olist_sales_data_set.olist_customers_dataset c
    JOIN olist_sales_data_set.olist_orders_dataset o
        ON c.customer_id = o.customer_id
    JOIN olist_sales_data_set.olist_order_items_dataset oi
        ON o.order_id = oi.order_id
    WHERE o.order_status = 'delivered'
    GROUP BY c.customer_unique_id
) cohort_data
GROUP BY first_purchase_month
HAVING COUNT(DISTINCT customer_unique_id) >= 10
ORDER BY first_purchase_month;

-- 💡 Business Insight: Compare cohort performance to identify best acquisition periods

-- BUSINESS EXAMPLE 3: State-level CLV analysis with ranking

SELECT
    customer_state,
    total_customers,
    total_revenue,
    avg_ltv_per_customer,
    avg_orders_per_customer,
    state_rank,

    -- Calculate percentage of total revenue
    ROUND((total_revenue / SUM(total_revenue) OVER () * 100)::numeric, 2) as pct_of_total_revenue
FROM (
    -- Derived table: Aggregate by state
    SELECT
        customer_state,
        COUNT(DISTINCT customer_unique_id) as total_customers,
        ROUND(SUM(lifetime_value)::numeric, 2) as total_revenue,
        ROUND(AVG(lifetime_value)::numeric, 2) as avg_ltv_per_customer,
        ROUND(AVG(total_orders)::numeric, 1) as avg_orders_per_customer,
        RANK() OVER (ORDER BY SUM(lifetime_value) DESC) as state_rank
    FROM (
        -- Inner derived table: Customer-level metrics
        SELECT
            c.customer_unique_id,
            c.customer_state,
            COUNT(DISTINCT o.order_id) as total_orders,
            SUM(oi.price + oi.freight_value) as lifetime_value
        FROM olist_sales_data_set.olist_customers_dataset c
        JOIN olist_sales_data_set.olist_orders_dataset o
            ON c.customer_id = o.customer_id
        JOIN olist_sales_data_set.olist_order_items_dataset oi
            ON o.order_id = oi.order_id
        WHERE o.order_status = 'delivered'
        GROUP BY c.customer_unique_id, c.customer_state
    ) customer_level
    GROUP BY customer_state
) state_level
ORDER BY state_rank
LIMIT 20;

-- 💡 Business Insight: Top states by revenue deserve regional marketing investment

-- ================================================================
-- SECTION 3: SELECT Clause Subqueries - Correlated Calculations
-- ================================================================

/*
SELECT CLAUSE SUBQUERY:
Returns a single value for each row in the main query.
Often correlated (references outer query columns).

SYNTAX:
SELECT
    column1,
    (SELECT ... WHERE outer.col = inner.col) AS calculated_value
FROM table outer

IMPORTANT: Must return exactly ONE value per row
*/

-- BUSINESS EXAMPLE 1: Customer performance vs category average

SELECT
    c.customer_unique_id,
    c.customer_state,
    p.product_category_name,
    COUNT(DISTINCT o.order_id) as orders_in_category,
    ROUND(SUM(oi.price)::numeric, 2) as customer_category_spend,

    -- Subquery: Average spending in this category across all customers
    (
        SELECT ROUND(AVG(category_spend)::numeric, 2)
        FROM (
            SELECT
                c2.customer_unique_id,
                SUM(oi2.price) as category_spend
            FROM olist_sales_data_set.olist_customers_dataset c2
            JOIN olist_sales_data_set.olist_orders_dataset o2
                ON c2.customer_id = o2.customer_id
            JOIN olist_sales_data_set.olist_order_items_dataset oi2
                ON o2.order_id = oi2.order_id
            JOIN olist_sales_data_set.olist_products_dataset p2
                ON oi2.product_id = p2.product_id
            WHERE o2.order_status = 'delivered'
              AND p2.product_category_name = p.product_category_name
            GROUP BY c2.customer_unique_id
        ) category_customers
    ) as category_avg_spend,

    -- Performance indicator
    CASE
        WHEN SUM(oi.price) > (
            SELECT AVG(category_spend)
            FROM (
                SELECT
                    c2.customer_unique_id,
                    SUM(oi2.price) as category_spend
                FROM olist_sales_data_set.olist_customers_dataset c2
                JOIN olist_sales_data_set.olist_orders_dataset o2
                    ON c2.customer_id = o2.customer_id
                JOIN olist_sales_data_set.olist_order_items_dataset oi2
                    ON o2.order_id = oi2.order_id
                JOIN olist_sales_data_set.olist_products_dataset p2
                    ON oi2.product_id = p2.product_id
                WHERE o2.order_status = 'delivered'
                  AND p2.product_category_name = p.product_category_name
                GROUP BY c2.customer_unique_id
            ) category_customers
        ) THEN 'Above Average'
        ELSE 'Below Average'
    END as performance

FROM olist_sales_data_set.olist_customers_dataset c
JOIN olist_sales_data_set.olist_orders_dataset o
    ON c.customer_id = o.customer_id
JOIN olist_sales_data_set.olist_order_items_dataset oi
    ON o.order_id = oi.order_id
JOIN olist_sales_data_set.olist_products_dataset p
    ON oi.product_id = p.product_id
WHERE o.order_status = 'delivered'
  AND p.product_category_name IS NOT NULL
GROUP BY c.customer_unique_id, c.customer_state, p.product_category_name
HAVING COUNT(DISTINCT o.order_id) >= 2
ORDER BY customer_category_spend DESC
LIMIT 30;

-- 💡 Business Insight: Identify category enthusiasts for targeted promotions

-- BUSINESS EXAMPLE 2: Customer ranking within their state

SELECT
    customer_unique_id,
    customer_state,
    lifetime_value,
    total_orders,

    -- Subquery: Customer's rank within their state
    (
        SELECT COUNT(*) + 1
        FROM (
            SELECT
                c2.customer_unique_id,
                SUM(oi2.price + oi2.freight_value) as other_customer_ltv
            FROM olist_sales_data_set.olist_customers_dataset c2
            JOIN olist_sales_data_set.olist_orders_dataset o2
                ON c2.customer_id = o2.customer_id
            JOIN olist_sales_data_set.olist_order_items_dataset oi2
                ON o2.order_id = oi2.order_id
            WHERE o2.order_status = 'delivered'
              AND c2.customer_state = main.customer_state
            GROUP BY c2.customer_unique_id
            HAVING SUM(oi2.price + oi2.freight_value) > main.lifetime_value
        ) higher_spenders
    ) as rank_in_state,

    -- Subquery: Total customers in this state
    (
        SELECT COUNT(DISTINCT c3.customer_unique_id)
        FROM olist_sales_data_set.olist_customers_dataset c3
        JOIN olist_sales_data_set.olist_orders_dataset o3
            ON c3.customer_id = o3.customer_id
        WHERE o3.order_status = 'delivered'
          AND c3.customer_state = main.customer_state
    ) as total_customers_in_state

FROM (
    SELECT
        c.customer_unique_id,
        c.customer_state,
        ROUND(SUM(oi.price + oi.freight_value)::numeric, 2) as lifetime_value,
        COUNT(DISTINCT o.order_id) as total_orders
    FROM olist_sales_data_set.olist_customers_dataset c
    JOIN olist_sales_data_set.olist_orders_dataset o
        ON c.customer_id = o.customer_id
    JOIN olist_sales_data_set.olist_order_items_dataset oi
        ON o.order_id = oi.order_id
    WHERE o.order_status = 'delivered'
    GROUP BY c.customer_unique_id, c.customer_state
) main
WHERE lifetime_value > 200
ORDER BY customer_state, lifetime_value DESC
LIMIT 50;

-- 💡 Business Insight: Top customers per state are regional VIP candidates

-- ================================================================
-- SECTION 4: Combining Subquery Types for CLV Analysis
-- ================================================================

-- COMPREHENSIVE BUSINESS CASE: Full CLV Dashboard

SELECT
    customer_unique_id,
    customer_state,
    total_orders,
    ROUND(lifetime_value::numeric, 2) as lifetime_value,
    ROUND(avg_order_value::numeric, 2) as avg_order_value,
    first_purchase_date,
    last_purchase_date,
    days_as_customer,

    -- SELECT subquery: Customer's percentile ranking
    (
        SELECT ROUND((COUNT(*) * 100.0 / total_count)::numeric, 1)
        FROM (
            SELECT c2.customer_unique_id
            FROM olist_sales_data_set.olist_customers_dataset c2
            JOIN olist_sales_data_set.olist_orders_dataset o2
                ON c2.customer_id = o2.customer_id
            JOIN olist_sales_data_set.olist_order_items_dataset oi2
                ON o2.order_id = oi2.order_id
            WHERE o2.order_status = 'delivered'
            GROUP BY c2.customer_unique_id
            HAVING SUM(oi2.price + oi2.freight_value) <= main.lifetime_value
        ) lower_or_equal,
        (SELECT COUNT(DISTINCT customer_unique_id) FROM (
            SELECT c3.customer_unique_id
            FROM olist_sales_data_set.olist_customers_dataset c3
            JOIN olist_sales_data_set.olist_orders_dataset o3 ON c3.customer_id = o3.customer_id
            WHERE o3.order_status = 'delivered'
        ) all_customers) as total_count
    ) as percentile_rank,

    -- Predictive: Days since last order
    EXTRACT(DAY FROM CURRENT_DATE - last_purchase_date) as days_since_last_order,

    -- Segment classification
    CASE
        WHEN total_orders >= 3 AND lifetime_value > 500 THEN 'VIP'
        WHEN total_orders >= 3 THEN 'Loyal'
        WHEN lifetime_value > 500 THEN 'High Value'
        WHEN total_orders = 2 THEN 'Promising'
        ELSE 'One-Time'
    END as customer_segment

FROM (
    -- FROM subquery: Base customer metrics
    SELECT
        c.customer_unique_id,
        c.customer_state,
        COUNT(DISTINCT o.order_id) as total_orders,
        SUM(oi.price + oi.freight_value) as lifetime_value,
        SUM(oi.price + oi.freight_value) / COUNT(DISTINCT o.order_id) as avg_order_value,
        MIN(o.order_purchase_timestamp)::date as first_purchase_date,
        MAX(o.order_purchase_timestamp)::date as last_purchase_date,
        EXTRACT(DAY FROM MAX(o.order_purchase_timestamp) - MIN(o.order_purchase_timestamp)) as days_as_customer
    FROM olist_sales_data_set.olist_customers_dataset c
    JOIN olist_sales_data_set.olist_orders_dataset o
        ON c.customer_id = o.customer_id
    JOIN olist_sales_data_set.olist_order_items_dataset oi
        ON o.order_id = oi.order_id
    WHERE o.order_status = 'delivered'
    GROUP BY c.customer_unique_id, c.customer_state
) main

-- WHERE subquery: Only high-value customers
WHERE lifetime_value > (
    SELECT AVG(customer_ltv)
    FROM (
        SELECT SUM(oi.price + oi.freight_value) as customer_ltv
        FROM olist_sales_data_set.olist_customers_dataset c
        JOIN olist_sales_data_set.olist_orders_dataset o ON c.customer_id = o.customer_id
        JOIN olist_sales_data_set.olist_order_items_dataset oi ON o.order_id = oi.order_id
        WHERE o.order_status = 'delivered'
        GROUP BY c.customer_unique_id
    ) all_ltv
)

ORDER BY lifetime_value DESC
LIMIT 100;

-- ================================================================
-- KEY TAKEAWAYS
-- ================================================================

/*
SUBQUERY TYPES:

1. WHERE CLAUSE SUBQUERIES:
   - Filter based on dynamic calculations
   - Use =, IN, EXISTS for comparisons
   - Must return scalar or list of values

2. FROM CLAUSE SUBQUERIES (Derived Tables):
   - Pre-aggregate before further analysis
   - Break complex logic into steps
   - Must have alias

3. SELECT CLAUSE SUBQUERIES:
   - Calculate correlated values per row
   - Must return exactly ONE value
   - Often slower - use sparingly

PERFORMANCE TIPS:
✓ Use WHERE subqueries for filtering (fastest)
✓ Use FROM subqueries for pre-aggregation
✓ Avoid SELECT subqueries if JOINs work
✓ Index columns used in subquery joins
✓ Consider CTEs for readability (covered in Week 8)

BUSINESS VALUE:
- Dynamic comparisons (above average, top percentile)
- Customer segmentation based on complex logic
- Cohort analysis and ranking
- Personalized metrics (customer vs peers)
*/

-- ================================================================
-- PRACTICE EXERCISES
-- ================================================================

/*
EXERCISE 1: Find all customers whose most recent order was larger
           than their average order value. Show customer ID, state,
           most recent order value, and their average order value.

EXERCISE 2: Create a customer segmentation that compares each customer's
           lifetime value to the average LTV in their state. Classify
           as 'State Leader', 'Above State Avg', or 'Below State Avg'.

EXERCISE 3: Build a derived table showing monthly customer acquisition,
           then calculate cumulative customer count and month-over-month
           growth rate.

EXERCISE 4: Use SELECT subqueries to show each order with:
           - Order total
           - Customer's average order value
           - Difference from customer average
           - Percentage difference

Solutions in the solutions folder!
*/
