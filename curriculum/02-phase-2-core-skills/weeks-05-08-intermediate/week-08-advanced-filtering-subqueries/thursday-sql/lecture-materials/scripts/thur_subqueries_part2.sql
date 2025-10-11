-- ================================================================
-- WEEK 8: ADVANCED FILTERING & SUBQUERIES - PART 2
-- Topic: Subqueries for Advanced Customer Analysis
-- Business Case: Multi-Level Customer Segmentation
-- ================================================================

/*
LEARNING OBJECTIVES:
1. Understand what subqueries are and when to use them
2. Master subqueries in WHERE clauses
3. Use subqueries in SELECT clauses (scalar subqueries)
4. Apply subqueries with IN, NOT IN, EXISTS
5. Differentiate correlated vs non-correlated subqueries

BUSINESS CONTEXT:
You need to answer complex questions like:
- "Which customers spent more than the average order value?"
- "Find orders that include our top 5 best-selling products"
- "Identify customers who bought in Q1 but not in Q2"

These require comparing data against aggregated or filtered results -
perfect use cases for subqueries!

FROM EXCEL TO SQL:
- Excel AVERAGEIF with comparison = SQL subquery with AVG()
- Excel "Filter by another sheet's values" = SQL IN (subquery)
- Excel Array Formulas = SQL correlated subqueries
*/

-- ================================================================
-- SECTION 1: What is a Subquery?
-- ================================================================

/*
SUBQUERY DEFINITION:
A query nested inside another query. The inner query (subquery) runs
first, and its results are used by the outer query.

TYPES OF SUBQUERIES:
1. Scalar Subquery: Returns single value (one row, one column)
2. Column Subquery: Returns single column (multiple rows)
3. Row Subquery: Returns single row (multiple columns)
4. Table Subquery: Returns multiple rows and columns

PLACEMENT:
- WHERE clause: For filtering
- SELECT clause: For calculated columns
- FROM clause: As a virtual table (covered next week in CTEs)
- HAVING clause: For grouped filtering
*/

-- Simple example: Find all orders above average order value
-- Step 1: Calculate average (this becomes our subquery)
SELECT AVG(price + freight_value) as avg_order_value
FROM olist_sales_data_set.olist_order_items_dataset;

-- Step 2: Use that average in our WHERE clause (complete query with subquery)
SELECT
    order_id,
    product_id,
    price,
    freight_value,
    (price + freight_value) as total_value
FROM olist_sales_data_set.olist_order_items_dataset
WHERE (price + freight_value) > (
    SELECT AVG(price + freight_value)
    FROM olist_sales_data_set.olist_order_items_dataset
)
ORDER BY total_value DESC
LIMIT 20;

-- ================================================================
-- SECTION 2: Subqueries in WHERE Clause with Comparison Operators
-- ================================================================

/*
COMMON PATTERN:
WHERE column operator (SELECT ...)

Operators: =, >, <, >=, <=, !=
The subquery MUST return a single value (scalar subquery)
*/

-- BUSINESS EXAMPLE: High-value customers
-- Find customers whose lifetime value exceeds average
SELECT
    c.customer_unique_id,
    c.customer_state,
    SUM(oi.price + oi.freight_value) as lifetime_value
FROM olist_sales_data_set.olist_customers_dataset c
JOIN olist_sales_data_set.olist_orders_dataset o
    ON c.customer_id = o.customer_id
JOIN olist_sales_data_set.olist_order_items_dataset oi
    ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered'
GROUP BY c.customer_unique_id, c.customer_state
HAVING SUM(oi.price + oi.freight_value) > (
    -- Subquery: Calculate average customer lifetime value
    SELECT AVG(customer_total)
    FROM (
        SELECT SUM(oi2.price + oi2.freight_value) as customer_total
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
LIMIT 20;

-- BUSINESS EXAMPLE: Products with above-average ratings
-- Find products that perform better than average review score
SELECT
    p.product_id,
    p.product_category_name,
    COUNT(DISTINCT r.review_id) as total_reviews,
    ROUND(AVG(r.review_score)::numeric, 2) as avg_score
FROM olist_sales_data_set.olist_products_dataset p
JOIN olist_sales_data_set.olist_order_items_dataset oi
    ON p.product_id = oi.product_id
JOIN olist_sales_data_set.olist_order_reviews_dataset r
    ON oi.order_id = r.order_id
GROUP BY p.product_id, p.product_category_name
HAVING AVG(r.review_score) > (
    SELECT AVG(review_score)
    FROM olist_sales_data_set.olist_order_reviews_dataset
    WHERE review_score IS NOT NULL
)
    AND COUNT(DISTINCT r.review_id) >= 5  -- At least 5 reviews for reliability
ORDER BY avg_score DESC, total_reviews DESC
LIMIT 15;

-- ================================================================
-- SECTION 3: Subqueries with IN Operator
-- ================================================================

/*
IN WITH SUBQUERY:
WHERE column IN (SELECT column FROM ...)

The subquery returns a list of values (column subquery)
Useful for "find records that match this filtered list"
*/

-- Find top 3 states by customer count
SELECT customer_state, COUNT(*) as customer_count
FROM olist_sales_data_set.olist_customers_dataset
GROUP BY customer_state
ORDER BY customer_count DESC
LIMIT 3;

-- Now find all customers from those top 3 states
SELECT
    customer_id,
    customer_unique_id,
    customer_state,
    customer_city
FROM olist_sales_data_set.olist_customers_dataset
WHERE customer_state IN (
    -- Subquery: Get top 3 states
    SELECT customer_state
    FROM olist_sales_data_set.olist_customers_dataset
    GROUP BY customer_state
    ORDER BY COUNT(*) DESC
    LIMIT 3
)
LIMIT 20;

-- BUSINESS EXAMPLE: Orders containing bestselling products
-- Step 1: Identify top 10 products by sales volume
SELECT
    product_id,
    COUNT(*) as times_sold
FROM olist_sales_data_set.olist_order_items_dataset
GROUP BY product_id
ORDER BY times_sold DESC
LIMIT 10;

-- Step 2: Find all orders containing these bestsellers
SELECT DISTINCT
    o.order_id,
    o.customer_id,
    o.order_purchase_timestamp,
    o.order_status
FROM olist_sales_data_set.olist_orders_dataset o
JOIN olist_sales_data_set.olist_order_items_dataset oi
    ON o.order_id = oi.order_id
WHERE oi.product_id IN (
    -- Subquery: Top 10 bestselling products
    SELECT product_id
    FROM olist_sales_data_set.olist_order_items_dataset
    GROUP BY product_id
    ORDER BY COUNT(*) DESC
    LIMIT 10
)
    AND o.order_status = 'delivered'
ORDER BY o.order_purchase_timestamp DESC
LIMIT 25;

-- ================================================================
-- SECTION 4: Subqueries with NOT IN - Finding Exclusions
-- ================================================================

/*
NOT IN WITH SUBQUERY:
WHERE column NOT IN (SELECT column FROM ...)

Useful for "find records that DON'T match this list"
CAUTION: NULL values in subquery can cause problems!
*/

-- BUSINESS EXAMPLE: One-time customers (never returned)
-- Find customers who placed exactly one order
SELECT
    c.customer_unique_id,
    c.customer_state,
    c.customer_city,
    COUNT(o.order_id) as order_count
FROM olist_sales_data_set.olist_customers_dataset c
JOIN olist_sales_data_set.olist_orders_dataset o
    ON c.customer_id = o.customer_id
WHERE o.order_status = 'delivered'
GROUP BY c.customer_unique_id, c.customer_state, c.customer_city
HAVING COUNT(o.order_id) = 1
LIMIT 20;

-- Alternative: Using NOT IN to find non-repeat customers
-- First get all customers who made repeat purchases
SELECT DISTINCT customer_unique_id
FROM (
    SELECT
        c.customer_unique_id,
        COUNT(DISTINCT o.order_id) as order_count
    FROM olist_sales_data_set.olist_customers_dataset c
    JOIN olist_sales_data_set.olist_orders_dataset o
        ON c.customer_id = o.customer_id
    WHERE o.order_status = 'delivered'
    GROUP BY c.customer_unique_id
    HAVING COUNT(DISTINCT o.order_id) > 1
) repeat_customers;

-- Then find customers NOT in that repeat list
SELECT DISTINCT
    c.customer_unique_id,
    c.customer_state
FROM olist_sales_data_set.olist_customers_dataset c
JOIN olist_sales_data_set.olist_orders_dataset o
    ON c.customer_id = o.customer_id
WHERE c.customer_unique_id NOT IN (
    -- Subquery: Customers with multiple orders
    SELECT customer_unique_id
    FROM (
        SELECT
            c2.customer_unique_id,
            COUNT(DISTINCT o2.order_id) as order_count
        FROM olist_sales_data_set.olist_customers_dataset c2
        JOIN olist_sales_data_set.olist_orders_dataset o2
            ON c2.customer_id = o2.customer_id
        WHERE o2.order_status = 'delivered'
        GROUP BY c2.customer_unique_id
        HAVING COUNT(DISTINCT o2.order_id) > 1
    ) repeat_customers
)
    AND o.order_status = 'delivered'
LIMIT 20;

-- ================================================================
-- SECTION 5: EXISTS and NOT EXISTS
-- ================================================================

/*
EXISTS OPERATOR:
- Returns TRUE if subquery returns any rows
- More efficient than IN for large datasets
- Tests for existence, not specific values
- Syntax: WHERE EXISTS (SELECT 1 FROM ... WHERE condition)

BEST PRACTICE: Use EXISTS instead of IN when checking for presence
*/

-- Find customers who have left at least one review
-- Using IN (less efficient)
SELECT DISTINCT
    c.customer_unique_id,
    c.customer_state
FROM olist_sales_data_set.olist_customers_dataset c
WHERE c.customer_id IN (
    SELECT DISTINCT o.customer_id
    FROM olist_sales_data_set.olist_orders_dataset o
    JOIN olist_sales_data_set.olist_order_reviews_dataset r
        ON o.order_id = r.order_id
)
LIMIT 20;

-- Using EXISTS (more efficient!)
SELECT DISTINCT
    c.customer_unique_id,
    c.customer_state
FROM olist_sales_data_set.olist_customers_dataset c
WHERE EXISTS (
    SELECT 1
    FROM olist_sales_data_set.olist_orders_dataset o
    JOIN olist_sales_data_set.olist_order_reviews_dataset r
        ON o.order_id = r.order_id
    WHERE o.customer_id = c.customer_id
)
LIMIT 20;

-- NOT EXISTS: Find silent customers (no reviews ever)
SELECT DISTINCT
    c.customer_unique_id,
    c.customer_state,
    c.customer_city
FROM olist_sales_data_set.olist_customers_dataset c
JOIN olist_sales_data_set.olist_orders_dataset o
    ON c.customer_id = o.customer_id
WHERE o.order_status = 'delivered'
    AND NOT EXISTS (
        SELECT 1
        FROM olist_sales_data_set.olist_order_reviews_dataset r
        JOIN olist_sales_data_set.olist_orders_dataset o2
            ON r.order_id = o2.order_id
        WHERE o2.customer_id = c.customer_id
    )
LIMIT 25;

-- ================================================================
-- SECTION 6: Scalar Subqueries in SELECT Clause
-- ================================================================

/*
SCALAR SUBQUERY IN SELECT:
- Adds calculated columns based on other queries
- Must return exactly ONE value per row
- Can reference outer query columns (correlated subquery)
*/

-- Add column showing how each customer compares to average
SELECT
    c.customer_unique_id,
    c.customer_state,
    COUNT(DISTINCT o.order_id) as customer_orders,
    (SELECT AVG(order_count)
     FROM (
         SELECT COUNT(DISTINCT o2.order_id) as order_count
         FROM olist_sales_data_set.olist_orders_dataset o2
         WHERE o2.order_status = 'delivered'
         GROUP BY o2.customer_id
     ) avg_calc
    ) as avg_orders_per_customer,
    ROUND(
        COUNT(DISTINCT o.order_id)::numeric -
        (SELECT AVG(order_count)
         FROM (
             SELECT COUNT(DISTINCT o2.order_id) as order_count
             FROM olist_sales_data_set.olist_orders_dataset o2
             WHERE o2.order_status = 'delivered'
             GROUP BY o2.customer_id
         ) avg_calc
        ), 2
    ) as orders_above_average
FROM olist_sales_data_set.olist_customers_dataset c
JOIN olist_sales_data_set.olist_orders_dataset o
    ON c.customer_id = o.customer_id
WHERE o.order_status = 'delivered'
GROUP BY c.customer_unique_id, c.customer_state
HAVING COUNT(DISTINCT o.order_id) > 1
ORDER BY customer_orders DESC
LIMIT 20;

-- ================================================================
-- SECTION 7: Correlated Subqueries
-- ================================================================

/*
CORRELATED SUBQUERY:
- References columns from the outer query
- Executed once for EACH row of outer query (slower!)
- Useful when inner query depends on outer query values

NON-CORRELATED SUBQUERY:
- Independent of outer query
- Executed ONCE and result reused (faster!)
*/

-- NON-CORRELATED: Get average review score (runs once)
SELECT
    order_id,
    review_score,
    (SELECT AVG(review_score)
     FROM olist_sales_data_set.olist_order_reviews_dataset
     WHERE review_score IS NOT NULL
    ) as overall_avg_score
FROM olist_sales_data_set.olist_order_reviews_dataset
WHERE review_score IS NOT NULL
LIMIT 10;

-- CORRELATED: Get customer's average review score for each order
SELECT
    o.order_id,
    o.customer_id,
    r.review_score as this_order_score,
    (
        SELECT ROUND(AVG(r2.review_score)::numeric, 2)
        FROM olist_sales_data_set.olist_orders_dataset o2
        JOIN olist_sales_data_set.olist_order_reviews_dataset r2
            ON o2.order_id = r2.order_id
        WHERE o2.customer_id = o.customer_id  -- Links to outer query!
            AND r2.review_score IS NOT NULL
    ) as customer_avg_score
FROM olist_sales_data_set.olist_orders_dataset o
JOIN olist_sales_data_set.olist_order_reviews_dataset r
    ON o.order_id = r.order_id
WHERE r.review_score IS NOT NULL
    AND o.order_status = 'delivered'
ORDER BY o.customer_id
LIMIT 25;

-- ================================================================
-- SECTION 8: Comprehensive Business Case - At-Risk Customer Dashboard
-- ================================================================

/*
RETENTION ANALYSIS REQUIREMENTS:
1. Identify VIP customers (high lifetime value)
2. Check if they've had any negative experiences (review score <= 3)
3. See if they're currently active or dormant
4. Compare their behavior to average customer patterns

This requires multiple subqueries working together!
*/

SELECT
    c.customer_unique_id,
    c.customer_state,
    c.customer_city,

    -- Customer metrics
    COUNT(DISTINCT o.order_id) as total_orders,
    ROUND(SUM(oi.price + oi.freight_value)::numeric, 2) as lifetime_value,
    ROUND(AVG(r.review_score)::numeric, 2) as avg_review_score,
    MIN(r.review_score) as worst_review,
    MAX(o.order_purchase_timestamp) as last_purchase,

    -- Days since last order
    EXTRACT(DAY FROM '2018-09-01'::date - MAX(o.order_purchase_timestamp)::date) as days_inactive,

    -- Comparison to averages (scalar subqueries)
    (
        SELECT ROUND(AVG(customer_ltv)::numeric, 2)
        FROM (
            SELECT SUM(oi2.price + oi2.freight_value) as customer_ltv
            FROM olist_sales_data_set.olist_customers_dataset c2
            JOIN olist_sales_data_set.olist_orders_dataset o2 ON c2.customer_id = o2.customer_id
            JOIN olist_sales_data_set.olist_order_items_dataset oi2 ON o2.order_id = oi2.order_id
            WHERE o2.order_status = 'delivered'
            GROUP BY c2.customer_unique_id
        ) ltv_calc
    ) as avg_customer_ltv,

    -- VIP status
    CASE
        WHEN SUM(oi.price + oi.freight_value) > (
            SELECT AVG(customer_ltv) * 2
            FROM (
                SELECT SUM(oi3.price + oi3.freight_value) as customer_ltv
                FROM olist_sales_data_set.olist_customers_dataset c3
                JOIN olist_sales_data_set.olist_orders_dataset o3 ON c3.customer_id = o3.customer_id
                JOIN olist_sales_data_set.olist_order_items_dataset oi3 ON o3.order_id = oi3.order_id
                WHERE o3.order_status = 'delivered'
                GROUP BY c3.customer_unique_id
            ) ltv_calc2
        ) THEN 'VIP'
        ELSE 'Standard'
    END as customer_tier,

    -- Risk factors
    CASE
        WHEN MIN(r.review_score) <= 2 THEN 'Had Very Bad Experience'
        WHEN AVG(r.review_score) < 3.5 THEN 'Generally Dissatisfied'
        WHEN AVG(r.review_score) IS NULL THEN 'Never Reviews (Disengaged?)'
        ELSE 'Satisfied'
    END as satisfaction_status,

    CASE
        WHEN EXTRACT(DAY FROM '2018-09-01'::date - MAX(o.order_purchase_timestamp)::date) > 180 THEN 'Dormant'
        WHEN EXTRACT(DAY FROM '2018-09-01'::date - MAX(o.order_purchase_timestamp)::date) > 90 THEN 'At Risk'
        ELSE 'Active'
    END as activity_status

FROM olist_sales_data_set.olist_customers_dataset c
JOIN olist_sales_data_set.olist_orders_dataset o
    ON c.customer_id = o.customer_id
JOIN olist_sales_data_set.olist_order_items_dataset oi
    ON o.order_id = oi.order_id
LEFT JOIN olist_sales_data_set.olist_order_reviews_dataset r
    ON o.order_id = r.order_id

WHERE o.order_status = 'delivered'
    -- Filter to VIP customers using subquery
    AND c.customer_unique_id IN (
        SELECT customer_unique_id
        FROM (
            SELECT
                c4.customer_unique_id,
                SUM(oi4.price + oi4.freight_value) as ltv
            FROM olist_sales_data_set.olist_customers_dataset c4
            JOIN olist_sales_data_set.olist_orders_dataset o4 ON c4.customer_id = o4.customer_id
            JOIN olist_sales_data_set.olist_order_items_dataset oi4 ON o4.order_id = oi4.order_id
            WHERE o4.order_status = 'delivered'
            GROUP BY c4.customer_unique_id
            HAVING SUM(oi4.price + oi4.freight_value) > 500
        ) vip_customers
    )

GROUP BY c.customer_unique_id, c.customer_state, c.customer_city

ORDER BY
    CASE
        WHEN MIN(r.review_score) <= 2 THEN 1
        WHEN AVG(r.review_score) < 3.5 THEN 2
        ELSE 3
    END,
    lifetime_value DESC
LIMIT 30;

-- ================================================================
-- KEY TAKEAWAYS
-- ================================================================

/*
1. SUBQUERIES: Query within a query - inner runs first
2. WHERE clause: Use for filtering against aggregated values
3. SELECT clause: Add calculated columns comparing to averages/totals
4. IN/NOT IN: Filter based on lists from subqueries
5. EXISTS: More efficient than IN for checking presence
6. CORRELATED: Inner query references outer query (slower but powerful)

PERFORMANCE TIPS:
- Use EXISTS instead of IN when possible
- Avoid correlated subqueries when non-correlated works
- Consider CTEs (next lecture) for complex multi-level queries
- Index columns used in subquery joins/filters

NEXT STEPS:
Part 3 introduces Common Table Expressions (CTEs) - a cleaner,
more readable way to write complex queries with multiple subqueries!
*/

-- ================================================================
-- PRACTICE QUESTIONS
-- ================================================================

/*
Q1: Find all orders where the total order value exceeds the average
    order value by more than 50%.

Q2: Identify customers who have NEVER left a review despite having
    3 or more delivered orders.

Q3: Find products that appear in orders with review scores of 5,
    but never appear in orders with review scores of 1 or 2.

Q4: Create a query showing each customer's total orders, lifetime value,
    and how they compare to the state average for their state.

Answers in the solutions file!
*/
