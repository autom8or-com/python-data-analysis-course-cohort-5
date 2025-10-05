-- Week 7: SQL JOINs - Advanced JOIN Patterns
-- PORA Academy Cohort 5 - Phase 2
-- Topic: RIGHT JOIN, FULL OUTER JOIN, Self-Joins, and Complex Business Logic

/* ========================================
   PART 1: RIGHT JOIN
   (Less common, but important to understand)
   ======================================== */

/*
RIGHT JOIN:
- Returns ALL records from the RIGHT table
- Returns matching records from the LEFT table
- Returns NULL for left table columns when no match exists

Note: RIGHT JOIN is less commonly used because you can achieve
the same result by reversing tables and using LEFT JOIN.
*/

-- 1.1: RIGHT JOIN example - All reviews with optional order info
SELECT
    r.review_id,
    r.review_score,
    r.review_creation_date::date AS review_date,
    o.order_id,
    o.order_status,
    o.order_purchase_timestamp::date AS purchase_date
FROM olist_sales_data_set.olist_orders_dataset o
RIGHT JOIN olist_sales_data_set.olist_order_reviews_dataset r
    ON o.order_id = r.order_id
ORDER BY r.review_creation_date DESC
LIMIT 30;

-- 1.2: Same query rewritten as LEFT JOIN (preferred approach)
SELECT
    r.review_id,
    r.review_score,
    r.review_creation_date::date AS review_date,
    o.order_id,
    o.order_status,
    o.order_purchase_timestamp::date AS purchase_date
FROM olist_sales_data_set.olist_order_reviews_dataset r
LEFT JOIN olist_sales_data_set.olist_orders_dataset o
    ON r.order_id = o.order_id
ORDER BY r.review_creation_date DESC
LIMIT 30;

/* ========================================
   PART 2: FULL OUTER JOIN
   Finding all mismatches and orphans
   ======================================== */

/*
FULL OUTER JOIN (or FULL JOIN):
- Returns ALL records from BOTH tables
- Matches where possible
- NULL values where no match exists

Use cases:
- Data reconciliation between systems
- Finding orphaned records
- Quality assurance and data validation
*/

-- 2.1: Full outer join - Find all order/review mismatches
SELECT
    o.order_id AS order_id_from_orders,
    r.order_id AS order_id_from_reviews,
    o.order_status,
    r.review_score,
    CASE
        WHEN o.order_id IS NULL THEN 'Review without order (orphan)'
        WHEN r.review_id IS NULL THEN 'Order without review'
        ELSE 'Matched'
    END AS match_status
FROM olist_sales_data_set.olist_orders_dataset o
FULL OUTER JOIN olist_sales_data_set.olist_order_reviews_dataset r
    ON o.order_id = r.order_id
WHERE o.order_id IS NULL OR r.review_id IS NULL
ORDER BY match_status
LIMIT 30;

-- 2.2: Data quality check - Orders vs Payments reconciliation
SELECT
    o.order_id AS order_id_from_orders,
    pay.order_id AS order_id_from_payments,
    o.order_status,
    pay.payment_value,
    pay.payment_type,
    CASE
        WHEN o.order_id IS NULL THEN 'Payment without order'
        WHEN pay.order_id IS NULL THEN 'Order without payment'
        ELSE 'Matched'
    END AS reconciliation_status
FROM olist_sales_data_set.olist_orders_dataset o
FULL OUTER JOIN olist_sales_data_set.olist_order_payments_dataset pay
    ON o.order_id = pay.order_id
WHERE o.order_id IS NULL OR pay.order_id IS NULL
ORDER BY reconciliation_status
LIMIT 30;

/* ========================================
   PART 3: SELF-JOINS
   Comparing records within the same table
   ======================================== */

/*
Self-Join: Joining a table to itself
- Uses different aliases to treat one table as two separate tables
- Common use cases:
  * Finding relationships within hierarchical data
  * Comparing records to find patterns
  * Detecting duplicates or related items
*/

-- 3.1: Find customers from the same city (network analysis)
SELECT DISTINCT
    c1.customer_id AS customer_1,
    c2.customer_id AS customer_2,
    c1.customer_city,
    c1.customer_state
FROM olist_sales_data_set.olist_customers_dataset c1
INNER JOIN olist_sales_data_set.olist_customers_dataset c2
    ON c1.customer_city = c2.customer_city
    AND c1.customer_state = c2.customer_state
    AND c1.customer_id < c2.customer_id  -- Avoid duplicates and self-matches
WHERE c1.customer_city = 'sao paulo'
LIMIT 30;

-- 3.2: Find orders from same customer on the same day (bulk purchases)
SELECT
    o1.customer_id,
    o1.order_id AS order_1,
    o2.order_id AS order_2,
    o1.order_purchase_timestamp::date AS purchase_date,
    o1.order_status AS status_1,
    o2.order_status AS status_2
FROM olist_sales_data_set.olist_orders_dataset o1
INNER JOIN olist_sales_data_set.olist_orders_dataset o2
    ON o1.customer_id = o2.customer_id
    AND o1.order_purchase_timestamp::date = o2.order_purchase_timestamp::date
    AND o1.order_id < o2.order_id  -- Avoid duplicates
ORDER BY o1.order_purchase_timestamp DESC
LIMIT 30;

-- 3.3: Compare sellers from the same city (competitive analysis)
SELECT
    s1.seller_id AS seller_1,
    s2.seller_id AS seller_2,
    s1.seller_city,
    s1.seller_state,
    COUNT(DISTINCT oi1.order_id) AS seller_1_orders,
    COUNT(DISTINCT oi2.order_id) AS seller_2_orders
FROM olist_sales_data_set.olist_sellers_dataset s1
INNER JOIN olist_sales_data_set.olist_sellers_dataset s2
    ON s1.seller_city = s2.seller_city
    AND s1.seller_state = s2.seller_state
    AND s1.seller_id < s2.seller_id
LEFT JOIN olist_sales_data_set.olist_order_items_dataset oi1
    ON s1.seller_id = oi1.seller_id
LEFT JOIN olist_sales_data_set.olist_order_items_dataset oi2
    ON s2.seller_id = oi2.seller_id
WHERE s1.seller_city = 'sao paulo'
GROUP BY s1.seller_id, s2.seller_id, s1.seller_city, s1.seller_state
HAVING COUNT(DISTINCT oi1.order_id) > 0 AND COUNT(DISTINCT oi2.order_id) > 0
ORDER BY seller_1_orders DESC, seller_2_orders DESC
LIMIT 20;

/* ========================================
   PART 4: COMPLEX MULTI-TABLE BUSINESS ANALYSIS
   Real-world scenarios combining multiple join types
   ======================================== */

-- 4.1: Complete customer journey with all touchpoints
SELECT
    c.customer_unique_id,
    c.customer_state,
    c.customer_city,
    o.order_id,
    o.order_purchase_timestamp::date AS purchase_date,
    o.order_status,
    p.product_category_name,
    oi.price AS item_price,
    pay.payment_type,
    pay.payment_value,
    r.review_score,
    s.seller_state AS seller_state,
    CASE
        WHEN c.customer_state = s.seller_state THEN 'Same State'
        ELSE 'Different State'
    END AS shipping_distance
FROM olist_sales_data_set.olist_customers_dataset c
INNER JOIN olist_sales_data_set.olist_orders_dataset o
    ON c.customer_id = o.customer_id
LEFT JOIN olist_sales_data_set.olist_order_items_dataset oi
    ON o.order_id = oi.order_id
LEFT JOIN olist_sales_data_set.olist_products_dataset p
    ON oi.product_id = p.product_id
LEFT JOIN olist_sales_data_set.olist_sellers_dataset s
    ON oi.seller_id = s.seller_id
LEFT JOIN olist_sales_data_set.olist_order_payments_dataset pay
    ON o.order_id = pay.order_id
LEFT JOIN olist_sales_data_set.olist_order_reviews_dataset r
    ON o.order_id = r.order_id
WHERE o.order_status = 'delivered'
    AND c.customer_state = 'RJ'
ORDER BY o.order_purchase_timestamp DESC
LIMIT 50;

-- 4.2: Revenue analysis by shipping distance (customer state vs seller state)
SELECT
    CASE
        WHEN c.customer_state = s.seller_state THEN 'Local (Same State)'
        ELSE 'Interstate'
    END AS shipping_type,
    COUNT(DISTINCT o.order_id) AS total_orders,
    COUNT(DISTINCT oi.order_item_id) AS total_items,
    ROUND(SUM(oi.price), 2) AS total_revenue,
    ROUND(AVG(oi.price), 2) AS avg_item_price,
    ROUND(AVG(oi.freight_value), 2) AS avg_freight_cost,
    ROUND(AVG(COALESCE(r.review_score, 0)), 2) AS avg_review_score
FROM olist_sales_data_set.olist_customers_dataset c
INNER JOIN olist_sales_data_set.olist_orders_dataset o
    ON c.customer_id = o.customer_id
INNER JOIN olist_sales_data_set.olist_order_items_dataset oi
    ON o.order_id = oi.order_id
INNER JOIN olist_sales_data_set.olist_sellers_dataset s
    ON oi.seller_id = s.seller_id
LEFT JOIN olist_sales_data_set.olist_order_reviews_dataset r
    ON o.order_id = r.order_id
WHERE o.order_status = 'delivered'
GROUP BY shipping_type
ORDER BY total_revenue DESC;

-- 4.3: Product category performance by payment method
SELECT
    p.product_category_name,
    pay.payment_type,
    COUNT(DISTINCT o.order_id) AS order_count,
    COUNT(DISTINCT oi.order_item_id) AS item_count,
    ROUND(SUM(oi.price), 2) AS total_revenue,
    ROUND(AVG(pay.payment_installments), 1) AS avg_installments,
    ROUND(AVG(COALESCE(r.review_score, 0)), 2) AS avg_review_score
FROM olist_sales_data_set.olist_products_dataset p
INNER JOIN olist_sales_data_set.olist_order_items_dataset oi
    ON p.product_id = oi.product_id
INNER JOIN olist_sales_data_set.olist_orders_dataset o
    ON oi.order_id = o.order_id
INNER JOIN olist_sales_data_set.olist_order_payments_dataset pay
    ON o.order_id = pay.order_id
LEFT JOIN olist_sales_data_set.olist_order_reviews_dataset r
    ON o.order_id = r.order_id
WHERE o.order_status = 'delivered'
    AND p.product_category_name IS NOT NULL
GROUP BY p.product_category_name, pay.payment_type
HAVING COUNT(DISTINCT o.order_id) >= 20
ORDER BY total_revenue DESC
LIMIT 30;

/* ========================================
   PART 5: ADVANCED PATTERNS - CTEs with JOINs
   Using Common Table Expressions for readability
   ======================================== */

-- 5.1: Step-by-step analysis using CTEs
WITH customer_orders AS (
    -- Step 1: Get order basics
    SELECT
        c.customer_unique_id,
        c.customer_state,
        o.order_id,
        o.order_purchase_timestamp,
        o.order_status
    FROM olist_sales_data_set.olist_customers_dataset c
    INNER JOIN olist_sales_data_set.olist_orders_dataset o
        ON c.customer_id = o.customer_id
    WHERE o.order_status = 'delivered'
),
order_revenue AS (
    -- Step 2: Calculate order revenue
    SELECT
        oi.order_id,
        SUM(oi.price) AS order_revenue,
        COUNT(oi.order_item_id) AS item_count
    FROM olist_sales_data_set.olist_order_items_dataset oi
    GROUP BY oi.order_id
),
order_reviews AS (
    -- Step 3: Get review scores
    SELECT
        order_id,
        AVG(review_score) AS avg_review_score
    FROM olist_sales_data_set.olist_order_reviews_dataset
    GROUP BY order_id
)
-- Final: Combine all CTEs
SELECT
    co.customer_state,
    COUNT(DISTINCT co.order_id) AS total_orders,
    ROUND(AVG(rev.order_revenue), 2) AS avg_order_revenue,
    ROUND(AVG(rev.item_count), 1) AS avg_items_per_order,
    ROUND(AVG(COALESCE(orw.avg_review_score, 0)), 2) AS avg_review_score
FROM customer_orders co
LEFT JOIN order_revenue rev
    ON co.order_id = rev.order_id
LEFT JOIN order_reviews orw
    ON co.order_id = orw.order_id
GROUP BY co.customer_state
ORDER BY total_orders DESC
LIMIT 27;

-- 5.2: Customer segmentation using CTEs and multiple joins
WITH customer_metrics AS (
    SELECT
        c.customer_unique_id,
        c.customer_state,
        COUNT(DISTINCT o.order_id) AS total_orders,
        SUM(oi.price) AS total_spent,
        AVG(r.review_score) AS avg_review_score,
        MAX(o.order_purchase_timestamp) AS last_order_date
    FROM olist_sales_data_set.olist_customers_dataset c
    INNER JOIN olist_sales_data_set.olist_orders_dataset o
        ON c.customer_id = o.customer_id
    LEFT JOIN olist_sales_data_set.olist_order_items_dataset oi
        ON o.order_id = oi.order_id
    LEFT JOIN olist_sales_data_set.olist_order_reviews_dataset r
        ON o.order_id = r.order_id
    WHERE o.order_status = 'delivered'
    GROUP BY c.customer_unique_id, c.customer_state
)
SELECT
    customer_state,
    CASE
        WHEN total_orders >= 3 THEN 'Loyal'
        WHEN total_orders = 2 THEN 'Repeat'
        ELSE 'One-Time'
    END AS customer_segment,
    COUNT(*) AS customer_count,
    ROUND(AVG(total_spent), 2) AS avg_lifetime_value,
    ROUND(AVG(avg_review_score), 2) AS avg_satisfaction
FROM customer_metrics
GROUP BY customer_state, customer_segment
ORDER BY customer_state, customer_count DESC;

/* ========================================
   PART 6: PERFORMANCE OPTIMIZATION TIPS
   ======================================== */

-- 6.1: Using EXPLAIN ANALYZE to understand query performance
EXPLAIN ANALYZE
SELECT
    c.customer_state,
    COUNT(DISTINCT o.order_id) AS order_count
FROM olist_sales_data_set.olist_customers_dataset c
INNER JOIN olist_sales_data_set.olist_orders_dataset o
    ON c.customer_id = o.customer_id
WHERE o.order_status = 'delivered'
GROUP BY c.customer_state;

-- 6.2: Filtering before joining (subquery approach)
SELECT
    c.customer_state,
    COUNT(delivered_orders.order_id) AS order_count
FROM olist_sales_data_set.olist_customers_dataset c
INNER JOIN (
    SELECT customer_id, order_id
    FROM olist_sales_data_set.olist_orders_dataset
    WHERE order_status = 'delivered'
) AS delivered_orders
    ON c.customer_id = delivered_orders.customer_id
GROUP BY c.customer_state;

/* ========================================
   PRACTICE EXERCISES - ADVANCED
   ======================================== */

-- EXERCISE 1: Self-Join Analysis
-- Find pairs of products from the same category that were ordered together
-- (i.e., both products in the same order)
-- Include: product_category_name, product_1_id, product_2_id, times_ordered_together
-- Hint: Self-join on olist_order_items_dataset with same order_id but different product_id

-- EXERCISE 2: Full Customer Journey with FULL OUTER JOIN
-- Create a data quality report showing:
-- - Orders that have payments but no items
-- - Orders that have items but no payments
-- Include: order_id, has_payment (yes/no), has_items (yes/no), issue_description

-- EXERCISE 3: Complex Business Analysis
-- Calculate the "cross-state premium" - do customers pay more when buying from
-- sellers in different states vs same state?
-- Include: shipping_type (local/interstate), avg_price, avg_freight, total_orders
-- Hint: Join customers, orders, order_items, sellers and use CASE for shipping type

/* ========================================
   KEY LEARNINGS - ADVANCED JOINS
   ======================================== */

/*
1. RIGHT JOIN is just LEFT JOIN with tables reversed (use LEFT JOIN for consistency)
2. FULL OUTER JOIN is powerful for data reconciliation and finding orphans
3. Self-joins compare records within the same table (use different aliases)
4. Self-join inequality conditions prevent matching records to themselves
5. CTEs make complex multi-step queries readable and maintainable
6. EXPLAIN ANALYZE helps you understand query performance
7. Filter early in subqueries or CTEs to reduce data before joining
8. Strategic use of INNER vs LEFT JOIN affects both results and performance
9. Always qualify column names in multi-table queries to avoid ambiguity
10. Complex business logic often requires combining multiple join types
*/
