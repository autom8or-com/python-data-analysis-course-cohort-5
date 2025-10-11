-- Week 7: SQL JOINs - LEFT JOIN Patterns
-- PORA Academy Cohort 5 - Phase 2
-- Topic: Using LEFT JOIN for complete data retention and data quality analysis

/* ========================================
   UNDERSTANDING LEFT JOIN
   ======================================== */

/*
LEFT JOIN (or LEFT OUTER JOIN):
- Returns ALL records from the LEFT table
- Returns matching records from the RIGHT table
- Returns NULL for right table columns when no match exists

Think of it like VLOOKUP with IFERROR in Excel:
- You keep all your original rows
- You add data from the lookup table where available
- Blank cells (NULL) appear when no match is found
*/

/* ========================================
   PART 1: BASIC LEFT JOIN
   All orders with optional review data
   ======================================== */

-- 1.1: All delivered orders with review data (if available)
SELECT
    o.order_id,
    o.order_status,
    o.order_purchase_timestamp::date AS purchase_date,
    o.order_delivered_customer_date::date AS delivery_date,
    r.review_score,
    r.review_creation_date::date AS review_date,
    CASE
        WHEN r.review_id IS NULL THEN 'No Review'
        ELSE 'Has Review'
    END AS review_status
FROM olist_sales_data_set.olist_orders_dataset o
LEFT JOIN olist_sales_data_set.olist_order_reviews_dataset r
    ON o.order_id = r.order_id
WHERE o.order_status = 'delivered'
ORDER BY o.order_purchase_timestamp DESC
LIMIT 30;

-- 1.2: Count orders WITH and WITHOUT reviews
SELECT
    CASE
        WHEN r.review_id IS NULL THEN 'No Review'
        ELSE 'Has Review'
    END AS review_status,
    COUNT(*) AS order_count,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2) AS percentage
FROM olist_sales_data_set.olist_orders_dataset o
LEFT JOIN olist_sales_data_set.olist_order_reviews_dataset r
    ON o.order_id = r.order_id
WHERE o.order_status = 'delivered'
GROUP BY review_status
ORDER BY order_count DESC;

/* ========================================
   PART 2: FINDING MISSING DATA
   Using LEFT JOIN + IS NULL pattern
   ======================================== */

-- 2.1: Find delivered orders WITHOUT reviews (data quality check)
SELECT
    o.order_id,
    o.customer_id,
    o.order_purchase_timestamp::date AS purchase_date,
    o.order_delivered_customer_date::date AS delivery_date,
    o.order_delivered_customer_date::date - o.order_purchase_timestamp::date AS days_since_purchase
FROM olist_sales_data_set.olist_orders_dataset o
LEFT JOIN olist_sales_data_set.olist_order_reviews_dataset r
    ON o.order_id = r.order_id
WHERE o.order_status = 'delivered'
    AND r.review_id IS NULL
ORDER BY o.order_delivered_customer_date DESC
LIMIT 30;

-- 2.2: Products that have NEVER been ordered
SELECT
    p.product_id,
    p.product_category_name,
    p.product_weight_g,
    p.product_length_cm,
    p.product_height_cm,
    p.product_width_cm
FROM olist_sales_data_set.olist_products_dataset p
LEFT JOIN olist_sales_data_set.olist_order_items_dataset oi
    ON p.product_id = oi.product_id
WHERE oi.order_id IS NULL
    AND p.product_category_name IS NOT NULL
ORDER BY p.product_category_name
LIMIT 30;

-- 2.3: Count products by order status (ordered vs never ordered)
SELECT
    CASE
        WHEN oi.order_id IS NULL THEN 'Never Ordered'
        ELSE 'Has Orders'
    END AS order_status,
    COUNT(DISTINCT p.product_id) AS product_count
FROM olist_sales_data_set.olist_products_dataset p
LEFT JOIN olist_sales_data_set.olist_order_items_dataset oi
    ON p.product_id = oi.product_id
GROUP BY order_status;

/* ========================================
   PART 3: MULTI-TABLE LEFT JOINS
   Preserving the main dataset while adding info
   ======================================== */

-- 3.1: All orders with optional payments and reviews
SELECT
    o.order_id,
    o.order_status,
    o.order_purchase_timestamp::date AS purchase_date,
    c.customer_state,
    pay.payment_type,
    pay.payment_value,
    r.review_score,
    CASE
        WHEN pay.payment_type IS NULL THEN 'No Payment Info'
        ELSE pay.payment_type
    END AS payment_status,
    CASE
        WHEN r.review_id IS NULL THEN 'No Review'
        ELSE 'Reviewed'
    END AS review_status
FROM olist_sales_data_set.olist_orders_dataset o
INNER JOIN olist_sales_data_set.olist_customers_dataset c
    ON o.customer_id = c.customer_id
LEFT JOIN olist_sales_data_set.olist_order_payments_dataset pay
    ON o.order_id = pay.order_id
LEFT JOIN olist_sales_data_set.olist_order_reviews_dataset r
    ON o.order_id = r.order_id
WHERE o.order_status IN ('delivered', 'shipped')
ORDER BY o.order_purchase_timestamp DESC
LIMIT 40;

-- 3.2: Customer order history with optional reviews - Customer 360 view
SELECT
    c.customer_id,
    c.customer_city,
    c.customer_state,
    o.order_id,
    o.order_purchase_timestamp::date AS purchase_date,
    o.order_status,
    r.review_score,
    COALESCE(r.review_score, 0) AS review_score_filled,  -- Replace NULL with 0
    CASE
        WHEN r.review_score >= 4 THEN 'Positive'
        WHEN r.review_score >= 3 THEN 'Neutral'
        WHEN r.review_score IS NOT NULL THEN 'Negative'
        ELSE 'Not Reviewed'
    END AS review_sentiment
FROM olist_sales_data_set.olist_customers_dataset c
INNER JOIN olist_sales_data_set.olist_orders_dataset o
    ON c.customer_id = o.customer_id
LEFT JOIN olist_sales_data_set.olist_order_reviews_dataset r
    ON o.order_id = r.order_id
WHERE c.customer_state = 'SP'
ORDER BY c.customer_id, o.order_purchase_timestamp DESC
LIMIT 50;

/* ========================================
   PART 4: DATA QUALITY ANALYSIS
   Using LEFT JOIN for completeness checks
   ======================================== */

-- 4.1: Payment completeness by order status
SELECT
    o.order_status,
    COUNT(o.order_id) AS total_orders,
    COUNT(pay.payment_type) AS orders_with_payment,
    COUNT(o.order_id) - COUNT(pay.payment_type) AS orders_without_payment,
    ROUND(COUNT(pay.payment_type) * 100.0 / COUNT(o.order_id), 2) AS payment_completion_rate
FROM olist_sales_data_set.olist_orders_dataset o
LEFT JOIN olist_sales_data_set.olist_order_payments_dataset pay
    ON o.order_id = pay.order_id
GROUP BY o.order_status
ORDER BY total_orders DESC;

-- 4.2: Review completeness by customer state
SELECT
    c.customer_state,
    COUNT(DISTINCT o.order_id) AS total_delivered_orders,
    COUNT(DISTINCT r.review_id) AS orders_with_reviews,
    COUNT(DISTINCT o.order_id) - COUNT(DISTINCT r.review_id) AS orders_without_reviews,
    ROUND(COUNT(DISTINCT r.review_id) * 100.0 / COUNT(DISTINCT o.order_id), 2) AS review_rate
FROM olist_sales_data_set.olist_customers_dataset c
INNER JOIN olist_sales_data_set.olist_orders_dataset o
    ON c.customer_id = o.customer_id
LEFT JOIN olist_sales_data_set.olist_order_reviews_dataset r
    ON o.order_id = r.order_id
WHERE o.order_status = 'delivered'
GROUP BY c.customer_state
HAVING COUNT(DISTINCT o.order_id) >= 100
ORDER BY review_rate DESC
LIMIT 27;  -- All Brazilian states

/* ========================================
   PART 5: BUSINESS ANALYSIS WITH LEFT JOIN
   Combining insights while preserving data
   ======================================== */

-- 5.1: Product performance with review analysis
SELECT
    p.product_category_name,
    COUNT(DISTINCT oi.order_id) AS total_orders,
    COUNT(DISTINCT r.review_id) AS reviewed_orders,
    ROUND(AVG(CASE WHEN r.review_score IS NOT NULL THEN r.review_score END), 2) AS avg_review_score,
    ROUND(SUM(oi.price), 2) AS total_revenue,
    ROUND(AVG(oi.price), 2) AS avg_price
FROM olist_sales_data_set.olist_products_dataset p
INNER JOIN olist_sales_data_set.olist_order_items_dataset oi
    ON p.product_id = oi.product_id
INNER JOIN olist_sales_data_set.olist_orders_dataset o
    ON oi.order_id = o.order_id
LEFT JOIN olist_sales_data_set.olist_order_reviews_dataset r
    ON o.order_id = r.order_id
WHERE o.order_status = 'delivered'
    AND p.product_category_name IS NOT NULL
GROUP BY p.product_category_name
HAVING COUNT(DISTINCT oi.order_id) >= 50
ORDER BY total_revenue DESC
LIMIT 20;

-- 5.2: Seller performance with optional review feedback
SELECT
    s.seller_state,
    s.seller_city,
    COUNT(DISTINCT oi.order_id) AS total_orders,
    COUNT(DISTINCT r.review_id) AS reviewed_orders,
    ROUND(AVG(CASE WHEN r.review_score IS NOT NULL THEN r.review_score END), 2) AS avg_review_score,
    ROUND(SUM(oi.price), 2) AS total_revenue,
    CASE
        WHEN AVG(CASE WHEN r.review_score IS NOT NULL THEN r.review_score END) >= 4 THEN 'High Rated'
        WHEN AVG(CASE WHEN r.review_score IS NOT NULL THEN r.review_score END) >= 3 THEN 'Medium Rated'
        WHEN AVG(CASE WHEN r.review_score IS NOT NULL THEN r.review_score END) IS NOT NULL THEN 'Low Rated'
        ELSE 'Not Rated'
    END AS seller_rating
FROM olist_sales_data_set.olist_sellers_dataset s
INNER JOIN olist_sales_data_set.olist_order_items_dataset oi
    ON s.seller_id = oi.seller_id
INNER JOIN olist_sales_data_set.olist_orders_dataset o
    ON oi.order_id = o.order_id
LEFT JOIN olist_sales_data_set.olist_order_reviews_dataset r
    ON o.order_id = r.order_id
WHERE o.order_status = 'delivered'
GROUP BY s.seller_state, s.seller_city
HAVING COUNT(DISTINCT oi.order_id) >= 20
ORDER BY total_revenue DESC
LIMIT 30;

/* ========================================
   PART 6: ADVANCED LEFT JOIN PATTERNS
   Complex business scenarios
   ======================================== */

-- 6.1: Complete order analysis - All data points (LEFT JOIN chain)
SELECT
    o.order_id,
    c.customer_state,
    c.customer_city,
    o.order_purchase_timestamp::date AS purchase_date,
    o.order_status,
    COALESCE(pay.payment_type, 'Unknown') AS payment_type,
    COALESCE(pay.payment_value, 0) AS payment_value,
    COALESCE(r.review_score, 0) AS review_score,
    p.product_category_name,
    oi.price AS item_price,
    s.seller_state,
    s.seller_city AS seller_city
FROM olist_sales_data_set.olist_orders_dataset o
INNER JOIN olist_sales_data_set.olist_customers_dataset c
    ON o.customer_id = c.customer_id
LEFT JOIN olist_sales_data_set.olist_order_payments_dataset pay
    ON o.order_id = pay.order_id
LEFT JOIN olist_sales_data_set.olist_order_reviews_dataset r
    ON o.order_id = r.order_id
LEFT JOIN olist_sales_data_set.olist_order_items_dataset oi
    ON o.order_id = oi.order_id
LEFT JOIN olist_sales_data_set.olist_products_dataset p
    ON oi.product_id = p.product_id
LEFT JOIN olist_sales_data_set.olist_sellers_dataset s
    ON oi.seller_id = s.seller_id
WHERE o.order_status = 'delivered'
ORDER BY o.order_purchase_timestamp DESC
LIMIT 50;

-- 6.2: Customer retention analysis - Repeat vs one-time customers
SELECT
    c.customer_unique_id,
    c.customer_state,
    COUNT(DISTINCT o.order_id) AS total_orders,
    MIN(o.order_purchase_timestamp::date) AS first_order_date,
    MAX(o.order_purchase_timestamp::date) AS last_order_date,
    ROUND(AVG(COALESCE(r.review_score, 0)), 2) AS avg_review_score,
    CASE
        WHEN COUNT(DISTINCT o.order_id) = 1 THEN 'One-Time Customer'
        WHEN COUNT(DISTINCT o.order_id) BETWEEN 2 AND 3 THEN 'Repeat Customer'
        ELSE 'Loyal Customer'
    END AS customer_segment
FROM olist_sales_data_set.olist_customers_dataset c
LEFT JOIN olist_sales_data_set.olist_orders_dataset o
    ON c.customer_id = o.customer_id
LEFT JOIN olist_sales_data_set.olist_order_reviews_dataset r
    ON o.order_id = r.order_id
WHERE o.order_status = 'delivered'
GROUP BY c.customer_unique_id, c.customer_state
HAVING COUNT(DISTINCT o.order_id) >= 1
ORDER BY total_orders DESC, c.customer_unique_id
LIMIT 40;

/* ========================================
   PRACTICE EXERCISES
   ======================================== */

-- EXERCISE 1: Missing Payment Analysis
-- Find all delivered orders WITHOUT payment information
-- Include: order_id, customer_state, purchase_date, order_status
-- Hint: LEFT JOIN orders to payments, filter WHERE payment_type IS NULL

-- EXERCISE 2: Low-Rated Products Investigation
-- Find products with average review score below 3.0
-- Include products even if they have no reviews (show NULL avg)
-- Include: product_category_name, total_orders, avg_review_score
-- Hint: Use LEFT JOIN for reviews and CASE for handling NULL scores

-- EXERCISE 3: Seller Coverage Analysis
-- Identify sellers who have products but have never made a sale
-- Include: seller_id, seller_state, seller_city
-- Hint: This requires understanding your data relationships - think carefully!

/* ========================================
   KEY LEARNINGS - LEFT JOIN
   ======================================== */

/*
1. LEFT JOIN preserves ALL records from the left table
2. Use LEFT JOIN when you want to keep your main dataset intact
3. NULL values in right table columns indicate no match was found
4. LEFT JOIN + IS NULL pattern finds missing relationships
5. Use COALESCE() to replace NULL values with defaults
6. CASE statements can categorize based on NULL presence
7. Be careful with WHERE clauses - they can turn LEFT JOIN into INNER JOIN!
   - WHERE right_table.column = value  → Excludes NULLs (acts like INNER JOIN)
   - WHERE right_table.column IS NULL  → Finds non-matches (correct for LEFT JOIN)
8. LEFT JOIN is essential for data quality and completeness analysis
*/
