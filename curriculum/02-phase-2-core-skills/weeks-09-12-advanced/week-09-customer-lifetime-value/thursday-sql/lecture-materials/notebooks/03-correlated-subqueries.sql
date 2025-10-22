-- ================================================================
-- WEEK 9: CUSTOMER LIFETIME VALUE ANALYSIS - PART 3
-- Topic: Correlated Subqueries & Advanced Patterns
-- Business Case: Row-Level CLV Intelligence
-- ================================================================

/*
LEARNING OBJECTIVES:
1. Master correlated subqueries for row-by-row calculations
2. Use EXISTS and NOT EXISTS for advanced filtering
3. Implement running totals and rankings with subqueries
4. Understand performance implications of correlation
5. Know when to use correlated vs non-correlated approaches

BUSINESS CONTEXT:
Correlated subqueries let you perform calculations that reference
the outer query row-by-row. Perfect for comparing each customer
to their peers, calculating percentile rankings, and identifying
specific behavior patterns.

CORRELATION EXPLAINED:
Normal Subquery: Runs once, returns result
Correlated Subquery: Runs ONCE PER ROW of outer query

Think of it like Excel's VLOOKUP for every row in a table!

FROM EXCEL TO SQL:
- Excel INDEX/MATCH for each row = SQL Correlated Subquery
- Excel "This row vs others" formulas = SQL Correlation
- Excel Conditional Formatting (vs others) = SQL EXISTS pattern
*/

-- ================================================================
-- SECTION 1: Correlated Subqueries Fundamentals
-- ================================================================

/*
CORRELATED SUBQUERY:
A subquery that references columns from the outer query.
Executes once for each row in the outer query.

SYNTAX:
SELECT
    outer.column,
    (SELECT ... FROM table WHERE table.col = outer.col)  -- Correlated!
FROM table outer
*/

-- BUSINESS EXAMPLE 1: Each customer's rank within their state

SELECT
    c.customer_unique_id,
    c.customer_state,
    c.customer_city,
    ROUND(SUM(oi.price + oi.freight_value)::numeric, 2) as lifetime_value,
    COUNT(DISTINCT o.order_id) as total_orders,

    -- Correlated subquery: How many customers in same state spent more?
    (
        SELECT COUNT(*) + 1
        FROM olist_sales_data_set.olist_customers_dataset c2
        JOIN olist_sales_data_set.olist_orders_dataset o2
            ON c2.customer_id = o2.customer_id
        JOIN olist_sales_data_set.olist_order_items_dataset oi2
            ON o2.order_id = oi2.order_id
        WHERE c2.customer_state = c.customer_state  -- CORRELATION POINT!
          AND o2.order_status = 'delivered'
        GROUP BY c2.customer_unique_id
        HAVING SUM(oi2.price + oi2.freight_value) > SUM(oi.price + oi.freight_value)
    ) as state_rank,

    -- Correlated subquery: Total customers in this state
    (
        SELECT COUNT(DISTINCT c3.customer_unique_id)
        FROM olist_sales_data_set.olist_customers_dataset c3
        JOIN olist_sales_data_set.olist_orders_dataset o3
            ON c3.customer_id = o3.customer_id
        WHERE c3.customer_state = c.customer_state  -- CORRELATION POINT!
          AND o3.order_status = 'delivered'
    ) as total_state_customers

FROM olist_sales_data_set.olist_customers_dataset c
JOIN olist_sales_data_set.olist_orders_dataset o
    ON c.customer_id = o.customer_id
JOIN olist_sales_data_set.olist_order_items_dataset oi
    ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered'
GROUP BY c.customer_unique_id, c.customer_state, c.customer_city
HAVING SUM(oi.price + oi.freight_value) > 200
ORDER BY c.customer_state, lifetime_value DESC
LIMIT 50;

-- 💡 Business Insight: State-level ranking identifies regional VIP candidates

-- BUSINESS EXAMPLE 2: Compare each order to customer's average

SELECT
    o.order_id,
    c.customer_unique_id,
    c.customer_state,
    o.order_purchase_timestamp,
    ROUND(SUM(oi.price + oi.freight_value)::numeric, 2) as order_total,

    -- Correlated: This customer's average order value
    (
        SELECT ROUND(AVG(order_value)::numeric, 2)
        FROM (
            SELECT o2.order_id, SUM(oi2.price + oi2.freight_value) as order_value
            FROM olist_sales_data_set.olist_orders_dataset o2
            JOIN olist_sales_data_set.olist_order_items_dataset oi2
                ON o2.order_id = oi2.order_id
            WHERE o2.customer_id = o.customer_id  -- CORRELATION!
              AND o2.order_status = 'delivered'
            GROUP BY o2.order_id
        ) customer_orders
    ) as customer_avg_order,

    -- Correlated: This customer's order count
    (
        SELECT COUNT(DISTINCT o2.order_id)
        FROM olist_sales_data_set.olist_orders_dataset o2
        WHERE o2.customer_id = o.customer_id  -- CORRELATION!
          AND o2.order_status = 'delivered'
    ) as customer_total_orders,

    -- Performance vs customer average
    CASE
        WHEN SUM(oi.price + oi.freight_value) > (
            SELECT AVG(order_value) * 1.5
            FROM (
                SELECT SUM(oi2.price + oi2.freight_value) as order_value
                FROM olist_sales_data_set.olist_orders_dataset o2
                JOIN olist_sales_data_set.olist_order_items_dataset oi2
                    ON o2.order_id = oi2.order_id
                WHERE o2.customer_id = o.customer_id
                  AND o2.order_status = 'delivered'
                GROUP BY o2.order_id
            ) customer_orders
        ) THEN 'Exceptional Order (>150% avg)'
        WHEN SUM(oi.price + oi.freight_value) > (
            SELECT AVG(order_value)
            FROM (
                SELECT SUM(oi2.price + oi2.freight_value) as order_value
                FROM olist_sales_data_set.olist_orders_dataset o2
                JOIN olist_sales_data_set.olist_order_items_dataset oi2
                    ON o2.order_id = oi2.order_id
                WHERE o2.customer_id = o.customer_id
                  AND o2.order_status = 'delivered'
                GROUP BY o2.order_id
            ) customer_orders
        ) THEN 'Above Average'
        ELSE 'Below Average'
    END as order_performance

FROM olist_sales_data_set.olist_orders_dataset o
JOIN olist_sales_data_set.olist_customers_dataset c
    ON o.customer_id = c.customer_id
JOIN olist_sales_data_set.olist_order_items_dataset oi
    ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered'
GROUP BY o.order_id, c.customer_unique_id, c.customer_state, o.order_purchase_timestamp, o.customer_id
ORDER BY order_total DESC
LIMIT 40;

-- 💡 Business Insight: Exceptional orders indicate upsell success or special occasions

-- ================================================================
-- SECTION 2: EXISTS and NOT EXISTS - Existence Checks
-- ================================================================

/*
EXISTS:
Returns TRUE if subquery returns any rows.
More efficient than IN for large datasets.

SYNTAX:
SELECT columns
FROM table t1
WHERE EXISTS (
    SELECT 1
    FROM table2 t2
    WHERE t2.col = t1.col  -- Correlation
)

NOT EXISTS: Returns TRUE if subquery returns NO rows
*/

-- BUSINESS EXAMPLE 1: Find customers who bought from ALL top categories

-- First, identify top 5 categories by revenue
WITH top_categories AS (
    SELECT p.product_category_name
    FROM olist_sales_data_set.olist_products_dataset p
    JOIN olist_sales_data_set.olist_order_items_dataset oi
        ON p.product_id = oi.product_id
    WHERE p.product_category_name IS NOT NULL
    GROUP BY p.product_category_name
    ORDER BY SUM(oi.price) DESC
    LIMIT 5
)

-- Find customers who purchased from all 5 categories
SELECT
    c.customer_unique_id,
    c.customer_state,
    COUNT(DISTINCT o.order_id) as total_orders,
    ROUND(SUM(oi.price + oi.freight_value)::numeric, 2) as lifetime_value,
    COUNT(DISTINCT p.product_category_name) as categories_purchased

FROM olist_sales_data_set.olist_customers_dataset c
JOIN olist_sales_data_set.olist_orders_dataset o
    ON c.customer_id = o.customer_id
JOIN olist_sales_data_set.olist_order_items_dataset oi
    ON o.order_id = oi.order_id
JOIN olist_sales_data_set.olist_products_dataset p
    ON oi.product_id = p.product_id
WHERE o.order_status = 'delivered'
  AND NOT EXISTS (
      -- Check if there's any top category this customer HASN'T bought from
      SELECT 1
      FROM top_categories tc
      WHERE NOT EXISTS (
          SELECT 1
          FROM olist_sales_data_set.olist_orders_dataset o2
          JOIN olist_sales_data_set.olist_order_items_dataset oi2
              ON o2.order_id = oi2.order_id
          JOIN olist_sales_data_set.olist_products_dataset p2
              ON oi2.product_id = p2.product_id
          WHERE o2.customer_id = c.customer_id  -- CORRELATION!
            AND o2.order_status = 'delivered'
            AND p2.product_category_name = tc.product_category_name
      )
  )
GROUP BY c.customer_unique_id, c.customer_state
ORDER BY lifetime_value DESC;

-- 💡 Business Insight: Cross-category buyers are most loyal and valuable

-- BUSINESS EXAMPLE 2: Find high-value customers who NEVER left negative reviews

SELECT
    c.customer_unique_id,
    c.customer_state,
    COUNT(DISTINCT o.order_id) as total_orders,
    ROUND(SUM(oi.price + oi.freight_value)::numeric, 2) as lifetime_value,
    ROUND(AVG(r.review_score)::numeric, 2) as avg_review_score,
    COUNT(DISTINCT r.review_id) as total_reviews

FROM olist_sales_data_set.olist_customers_dataset c
JOIN olist_sales_data_set.olist_orders_dataset o
    ON c.customer_id = o.customer_id
JOIN olist_sales_data_set.olist_order_items_dataset oi
    ON o.order_id = oi.order_id
LEFT JOIN olist_sales_data_set.olist_order_reviews_dataset r
    ON o.order_id = r.order_id

WHERE o.order_status = 'delivered'
  -- No negative reviews exist for this customer
  AND NOT EXISTS (
      SELECT 1
      FROM olist_sales_data_set.olist_orders_dataset o2
      JOIN olist_sales_data_set.olist_order_reviews_dataset r2
          ON o2.order_id = r2.order_id
      WHERE o2.customer_id = c.customer_id  -- CORRELATION!
        AND r2.review_score <= 2
  )
  -- Has at least some reviews
  AND EXISTS (
      SELECT 1
      FROM olist_sales_data_set.olist_orders_dataset o3
      JOIN olist_sales_data_set.olist_order_reviews_dataset r3
          ON o3.order_id = r3.order_id
      WHERE o3.customer_id = c.customer_id  -- CORRELATION!
  )

GROUP BY c.customer_unique_id, c.customer_state
HAVING SUM(oi.price + oi.freight_value) > 200
ORDER BY lifetime_value DESC
LIMIT 50;

-- 💡 Business Insight: Consistently satisfied high-value customers are brand advocates

-- BUSINESS EXAMPLE 3: Find customers with declining purchase frequency

SELECT
    c.customer_unique_id,
    c.customer_state,
    COUNT(DISTINCT o.order_id) as total_orders,
    ROUND(SUM(oi.price + oi.freight_value)::numeric, 2) as lifetime_value,
    MIN(o.order_purchase_timestamp)::date as first_purchase,
    MAX(o.order_purchase_timestamp)::date as last_purchase,

    -- Days between first two orders
    (
        SELECT (MIN(o2.order_purchase_timestamp)::date - (
            SELECT MIN(o3.order_purchase_timestamp)::date
            FROM olist_sales_data_set.olist_orders_dataset o3
            WHERE o3.customer_id = c.customer_id
              AND o3.order_status = 'delivered'
        ))
        FROM olist_sales_data_set.olist_orders_dataset o2
        WHERE o2.customer_id = c.customer_id
          AND o2.order_status = 'delivered'
          AND o2.order_purchase_timestamp > (
              SELECT MIN(o4.order_purchase_timestamp)
              FROM olist_sales_data_set.olist_orders_dataset o4
              WHERE o4.customer_id = c.customer_id
                AND o4.order_status = 'delivered'
          )
    ) as days_between_first_two_orders,

    -- Days between last two orders
    (
        SELECT (MAX(o2.order_purchase_timestamp)::date - (
            SELECT MAX(o3.order_purchase_timestamp)::date
            FROM olist_sales_data_set.olist_orders_dataset o3
            WHERE o3.customer_id = c.customer_id
              AND o3.order_status = 'delivered'
              AND o3.order_purchase_timestamp < (
                  SELECT MAX(o4.order_purchase_timestamp)
                  FROM olist_sales_data_set.olist_orders_dataset o4
                  WHERE o4.customer_id = c.customer_id
                    AND o4.order_status = 'delivered'
              )
        ))
        FROM olist_sales_data_set.olist_orders_dataset o2
        WHERE o2.customer_id = c.customer_id
          AND o2.order_status = 'delivered'
    ) as days_between_last_two_orders

FROM olist_sales_data_set.olist_customers_dataset c
JOIN olist_sales_data_set.olist_orders_dataset o
    ON c.customer_id = o.customer_id
JOIN olist_sales_data_set.olist_order_items_dataset oi
    ON o.order_id = oi.order_id

WHERE o.order_status = 'delivered'
  -- Has at least 3 orders (need trend data)
  AND EXISTS (
      SELECT 1
      FROM olist_sales_data_set.olist_orders_dataset o2
      WHERE o2.customer_id = c.customer_id
        AND o2.order_status = 'delivered'
      GROUP BY o2.customer_id
      HAVING COUNT(DISTINCT o2.order_id) >= 3
  )

GROUP BY c.customer_unique_id, c.customer_state, c.customer_id
HAVING COUNT(DISTINCT o.order_id) >= 3
ORDER BY lifetime_value DESC
LIMIT 30;

-- 💡 Business Insight: Slowing purchase velocity signals churn risk

-- ================================================================
-- SECTION 3: Correlated Subqueries for Running Calculations
-- ================================================================

/*
RUNNING TOTALS & CUMULATIVE METRICS:
Use correlated subqueries to calculate cumulative values.
(Window functions are more efficient, but this shows the logic)
*/

-- BUSINESS EXAMPLE 1: Customer purchase history with running total

SELECT
    o.order_id,
    c.customer_unique_id,
    c.customer_state,
    o.order_purchase_timestamp,
    ROUND(SUM(oi.price + oi.freight_value)::numeric, 2) as order_value,

    -- Correlated: Running total of customer's lifetime value up to this order
    (
        SELECT ROUND(SUM(oi2.price + oi2.freight_value)::numeric, 2)
        FROM olist_sales_data_set.olist_orders_dataset o2
        JOIN olist_sales_data_set.olist_order_items_dataset oi2
            ON o2.order_id = oi2.order_id
        WHERE o2.customer_id = o.customer_id  -- CORRELATION!
          AND o2.order_status = 'delivered'
          AND o2.order_purchase_timestamp <= o.order_purchase_timestamp
    ) as running_customer_ltv,

    -- Correlated: Order number for this customer
    (
        SELECT COUNT(DISTINCT o2.order_id)
        FROM olist_sales_data_set.olist_orders_dataset o2
        WHERE o2.customer_id = o.customer_id  -- CORRELATION!
          AND o2.order_status = 'delivered'
          AND o2.order_purchase_timestamp <= o.order_purchase_timestamp
    ) as order_sequence_number

FROM olist_sales_data_set.olist_orders_dataset o
JOIN olist_sales_data_set.olist_customers_dataset c
    ON o.customer_id = c.customer_id
JOIN olist_sales_data_set.olist_order_items_dataset oi
    ON o.order_id = oi.order_id

WHERE o.order_status = 'delivered'
  -- Focus on repeat customers
  AND EXISTS (
      SELECT 1
      FROM olist_sales_data_set.olist_orders_dataset o2
      WHERE o2.customer_id = o.customer_id
        AND o2.order_status = 'delivered'
      GROUP BY o2.customer_id
      HAVING COUNT(DISTINCT o2.order_id) >= 3
  )

GROUP BY o.order_id, c.customer_unique_id, c.customer_state, o.order_purchase_timestamp, o.customer_id
ORDER BY c.customer_unique_id, o.order_purchase_timestamp
LIMIT 100;

-- 💡 Business Insight: Track LTV growth trajectory per customer

-- BUSINESS EXAMPLE 2: Identify first-time category purchases per customer

SELECT
    c.customer_unique_id,
    c.customer_state,
    p.product_category_name,
    MIN(o.order_purchase_timestamp)::date as first_purchase_in_category,
    COUNT(DISTINCT o.order_id) as orders_in_category,
    ROUND(SUM(oi.price)::numeric, 2) as total_spent_in_category,

    -- Was this their first purchase overall?
    CASE
        WHEN MIN(o.order_purchase_timestamp) = (
            SELECT MIN(o2.order_purchase_timestamp)
            FROM olist_sales_data_set.olist_orders_dataset o2
            WHERE o2.customer_id = c.customer_id  -- CORRELATION!
              AND o2.order_status = 'delivered'
        ) THEN 'First Purchase Ever'
        ELSE 'Category Expansion'
    END as purchase_type,

    -- How many categories had they bought from before this one?
    (
        SELECT COUNT(DISTINCT p2.product_category_name)
        FROM olist_sales_data_set.olist_orders_dataset o2
        JOIN olist_sales_data_set.olist_order_items_dataset oi2
            ON o2.order_id = oi2.order_id
        JOIN olist_sales_data_set.olist_products_dataset p2
            ON oi2.product_id = p2.product_id
        WHERE o2.customer_id = c.customer_id  -- CORRELATION!
          AND o2.order_status = 'delivered'
          AND o2.order_purchase_timestamp < MIN(o.order_purchase_timestamp)
          AND p2.product_category_name IS NOT NULL
    ) as categories_purchased_before

FROM olist_sales_data_set.olist_customers_dataset c
JOIN olist_sales_data_set.olist_orders_dataset o
    ON c.customer_id = o.customer_id
JOIN olist_sales_data_set.olist_order_items_dataset oi
    ON o.order_id = oi.order_id
JOIN olist_sales_data_set.olist_products_dataset p
    ON oi.product_id = p.product_id

WHERE o.order_status = 'delivered'
  AND p.product_category_name IS NOT NULL

GROUP BY c.customer_unique_id, c.customer_state, p.product_category_name, c.customer_id
HAVING COUNT(DISTINCT o.order_id) >= 2
ORDER BY c.customer_unique_id, first_purchase_in_category
LIMIT 50;

-- 💡 Business Insight: Track category expansion journey to guide cross-sell strategies

-- ================================================================
-- SECTION 4: Performance Optimization for Correlated Subqueries
-- ================================================================

/*
PERFORMANCE CONSIDERATIONS:
Correlated subqueries can be slow because they run once per outer row.

OPTIMIZATION STRATEGIES:
1. Index columns used in WHERE correlation
2. Consider JOINs or window functions instead
3. Use EXISTS instead of IN when checking existence
4. Limit outer query rows when possible
5. Use CTEs to pre-filter data
*/

-- SLOW: Correlated subquery without optimization
-- (Don't run this on large datasets!)
/*
SELECT
    c.customer_unique_id,
    (SELECT COUNT(*) FROM orders WHERE customer_id = c.customer_id),
    (SELECT AVG(price) FROM order_items oi JOIN orders o ON oi.order_id = o.order_id WHERE o.customer_id = c.customer_id),
    (SELECT MAX(timestamp) FROM orders WHERE customer_id = c.customer_id)
FROM customers c;
*/

-- OPTIMIZED: Use CTE to pre-aggregate, then join
WITH customer_metrics AS (
    SELECT
        c.customer_id,
        c.customer_unique_id,
        COUNT(DISTINCT o.order_id) as order_count,
        AVG(oi.price) as avg_price,
        MAX(o.order_purchase_timestamp) as last_order
    FROM olist_sales_data_set.olist_customers_dataset c
    JOIN olist_sales_data_set.olist_orders_dataset o
        ON c.customer_id = o.customer_id
    JOIN olist_sales_data_set.olist_order_items_dataset oi
        ON o.order_id = oi.order_id
    WHERE o.order_status = 'delivered'
    GROUP BY c.customer_id, c.customer_unique_id
)
SELECT
    customer_unique_id,
    order_count,
    ROUND(avg_price::numeric, 2) as avg_price,
    last_order
FROM customer_metrics
ORDER BY order_count DESC
LIMIT 100;

-- COMPARISON: EXISTS vs IN for large datasets

-- SLOWER: Using IN (materializes full subquery)
SELECT
    c.customer_unique_id,
    c.customer_state,
    COUNT(DISTINCT o.order_id) as orders
FROM olist_sales_data_set.olist_customers_dataset c
JOIN olist_sales_data_set.olist_orders_dataset o
    ON c.customer_id = o.customer_id
WHERE c.customer_unique_id IN (
    SELECT c2.customer_unique_id
    FROM olist_sales_data_set.olist_customers_dataset c2
    JOIN olist_sales_data_set.olist_orders_dataset o2 ON c2.customer_id = o2.customer_id
    JOIN olist_sales_data_set.olist_order_items_dataset oi2 ON o2.order_id = oi2.order_id
    WHERE o2.order_status = 'delivered'
    GROUP BY c2.customer_unique_id
    HAVING SUM(oi2.price + oi2.freight_value) > 500
)
  AND o.order_status = 'delivered'
GROUP BY c.customer_unique_id, c.customer_state
ORDER BY orders DESC
LIMIT 20;

-- FASTER: Using EXISTS (short-circuits on first match)
SELECT
    c.customer_unique_id,
    c.customer_state,
    COUNT(DISTINCT o.order_id) as orders
FROM olist_sales_data_set.olist_customers_dataset c
JOIN olist_sales_data_set.olist_orders_dataset o
    ON c.customer_id = o.customer_id
WHERE EXISTS (
    SELECT 1
    FROM olist_sales_data_set.olist_orders_dataset o2
    JOIN olist_sales_data_set.olist_order_items_dataset oi2 ON o2.order_id = oi2.order_id
    WHERE o2.customer_id = c.customer_id  -- CORRELATION!
      AND o2.order_status = 'delivered'
    GROUP BY o2.customer_id
    HAVING SUM(oi2.price + oi2.freight_value) > 500
)
  AND o.order_status = 'delivered'
GROUP BY c.customer_unique_id, c.customer_state
ORDER BY orders DESC
LIMIT 20;

-- 💡 Performance Tip: EXISTS is typically 2-3x faster than IN for large datasets

-- ================================================================
-- SECTION 5: When to Use Correlated vs Other Approaches
-- ================================================================

/*
DECISION MATRIX:

USE CORRELATED SUBQUERIES WHEN:
✓ Need row-by-row comparisons (each customer vs their history)
✓ Calculating rankings or percentiles
✓ Checking existence conditions (EXISTS/NOT EXISTS)
✓ Working with smaller datasets (<100K rows in outer query)

USE CTEs WHEN:
✓ Need readable, maintainable code
✓ Same calculation referenced multiple times
✓ Building multi-stage analytics pipelines
✓ Query complexity is high

USE JOINs WHEN:
✓ Combining data from multiple tables
✓ Working with large datasets (performance critical)
✓ Need all columns from related tables

USE WINDOW FUNCTIONS WHEN:
✓ Calculating running totals or rankings
✓ Need row-level calculations with aggregates
✓ Performance is critical
✓ (Covered in advanced topics)

HYBRID APPROACH (Best for CLV):
Combine techniques for optimal balance of readability and performance.
*/

-- EXAMPLE: Hybrid approach for comprehensive CLV analysis

WITH
-- CTE: Pre-aggregate customer metrics (performance)
customer_base AS (
    SELECT
        c.customer_unique_id,
        c.customer_state,
        c.customer_id,
        COUNT(DISTINCT o.order_id) as total_orders,
        SUM(oi.price + oi.freight_value) as lifetime_value,
        MIN(o.order_purchase_timestamp)::date as first_purchase,
        MAX(o.order_purchase_timestamp)::date as last_purchase
    FROM olist_sales_data_set.olist_customers_dataset c
    JOIN olist_sales_data_set.olist_orders_dataset o ON c.customer_id = o.customer_id
    JOIN olist_sales_data_set.olist_order_items_dataset oi ON o.order_id = oi.order_id
    WHERE o.order_status = 'delivered'
    GROUP BY c.customer_unique_id, c.customer_state, c.customer_id
),

-- CTE: State-level benchmarks
state_benchmarks AS (
    SELECT
        customer_state,
        AVG(lifetime_value) as state_avg_ltv,
        PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY lifetime_value) as state_p75_ltv
    FROM customer_base
    GROUP BY customer_state
)

-- Main query: Use correlated subquery only where necessary
SELECT
    cb.customer_unique_id,
    cb.customer_state,
    cb.total_orders,
    ROUND(cb.lifetime_value::numeric, 2) as lifetime_value,
    ROUND(sb.state_avg_ltv::numeric, 2) as state_avg_ltv,

    -- Correlated: Precise rank (where window function not available)
    (
        SELECT COUNT(*) + 1
        FROM customer_base cb2
        WHERE cb2.customer_state = cb.customer_state
          AND cb2.lifetime_value > cb.lifetime_value
    ) as state_rank,

    -- Join-based: State benchmark (efficient)
    CASE
        WHEN cb.lifetime_value > sb.state_p75_ltv THEN 'Top 25% in State'
        WHEN cb.lifetime_value > sb.state_avg_ltv THEN 'Above State Average'
        ELSE 'Below State Average'
    END as state_performance,

    -- Correlated EXISTS: Satisfaction check
    CASE
        WHEN NOT EXISTS (
            SELECT 1
            FROM olist_sales_data_set.olist_orders_dataset o
            JOIN olist_sales_data_set.olist_order_reviews_dataset r ON o.order_id = r.order_id
            WHERE o.customer_id = cb.customer_id
              AND r.review_score <= 2
        ) THEN 'Always Satisfied'
        ELSE 'Has Complaints'
    END as satisfaction_status

FROM customer_base cb
JOIN state_benchmarks sb ON cb.customer_state = sb.customer_state
WHERE cb.lifetime_value > 200
ORDER BY cb.customer_state, cb.lifetime_value DESC
LIMIT 50;

-- 💡 Best Practice: Use each technique where it excels, combine for optimal results

-- ================================================================
-- KEY TAKEAWAYS
-- ================================================================

/*
CORRELATED SUBQUERIES:

FUNDAMENTALS:
- References outer query columns
- Executes once per outer row
- Perfect for row-by-row comparisons

EXISTS/NOT EXISTS:
✓ Faster than IN for large datasets
✓ Short-circuits on first match
✓ Ideal for existence checks

PERFORMANCE:
- Index correlation points
- Limit outer query rows
- Consider CTEs/JOINs for large data
- Use EXISTS over IN

WHEN TO USE:
✓ Ranking within groups
✓ Row vs aggregate comparisons
✓ Existence validation
✓ Running calculations

WHEN NOT TO USE:
✗ Large datasets (use window functions)
✗ Simple aggregations (use GROUP BY)
✗ Reusable logic (use CTEs)

BUSINESS VALUE:
- Personalized customer insights
- Peer comparisons and rankings
- Behavior pattern detection
- Churn prediction signals
- Targeted intervention triggers
*/

-- ================================================================
-- PRACTICE EXERCISES
-- ================================================================

/*
EXERCISE 1: Use correlated subquery to find customers whose most recent
           order value exceeds 150% of their historical average. Show
           customer ID, recent order value, historical average, and
           percentage difference.

EXERCISE 2: Use EXISTS to find customers who have purchased from at least
           3 different product categories AND have at least one review
           score of 5. Show their category breadth and satisfaction metrics.

EXERCISE 3: Create a query showing each customer's orders with:
           - Order value
           - Running total of their lifetime value
           - Percentage of total LTV this order represents
           - Order number in their purchase sequence
           Use correlated subqueries only (no window functions)

EXERCISE 4: Find customers who exist in the top 20% of spenders in their
           state BUT do not exist in the list of customers who left
           negative reviews. Use EXISTS/NOT EXISTS patterns.

EXERCISE 5: CHALLENGE - Compare correlated subquery vs CTE approach for
           calculating customer state rankings. Measure conceptual
           performance (complexity) of each approach.

Solutions in the solutions folder!
*/
