-- ================================================================
-- WEEK 8: ADVANCED FILTERING & SUBQUERIES - PART 1
-- Topic: Advanced WHERE Clauses for Customer Retention Analysis
-- Business Case: Identifying At-Risk Customers in E-Commerce
-- ================================================================

/*
LEARNING OBJECTIVES:
1. Master complex WHERE conditions with multiple operators
2. Use IN and NOT IN for efficient list filtering
3. Apply BETWEEN for range queries
4. Combine AND/OR logic strategically
5. Handle NULL values in complex conditions

BUSINESS CONTEXT:
As a data analyst for Olist (Brazilian e-commerce marketplace), you've been
tasked with identifying at-risk customers who may churn. Your analysis will
help the marketing team design targeted retention campaigns.

FROM EXCEL TO SQL:
- Excel Multiple Filters = SQL WHERE with AND/OR
- Excel "Filter by List" = SQL IN clause
- Excel "Between" custom filter = SQL BETWEEN
- Excel "Blanks" filter = SQL IS NULL
*/

-- ================================================================
-- SECTION 1: REVIEW - Basic Filtering (Week 2 Concepts)
-- ================================================================

-- Simple condition: Find all orders delivered in São Paulo
SELECT
    o.order_id,
    o.customer_id,
    c.customer_state,
    o.order_purchase_timestamp,
    o.order_status
FROM olist_sales_data_set.olist_orders_dataset o
JOIN olist_sales_data_set.olist_customers_dataset c
    ON o.customer_id = c.customer_id
WHERE c.customer_state = 'SP'
    AND o.order_status = 'delivered'
LIMIT 10;

-- ================================================================
-- SECTION 2: IN Operator - Filtering Multiple Values
-- ================================================================

/*
IN OPERATOR:
- Replaces multiple OR conditions
- More readable and maintainable
- Can accept subqueries (we'll cover this in Part 3)
- Syntax: column IN (value1, value2, value3, ...)
*/

-- BAD PRACTICE: Multiple OR conditions
SELECT
    customer_id,
    customer_state,
    customer_city
FROM olist_sales_data_set.olist_customers_dataset
WHERE customer_state = 'SP'
    OR customer_state = 'RJ'
    OR customer_state = 'MG'
LIMIT 10;

-- BEST PRACTICE: Using IN operator
SELECT
    customer_id,
    customer_state,
    customer_city
FROM olist_sales_data_set.olist_customers_dataset
WHERE customer_state IN ('SP', 'RJ', 'MG')
LIMIT 10;

-- BUSINESS EXAMPLE: Focus on top revenue states
-- Find customers from high-value states for targeted campaigns
SELECT
    customer_state,
    COUNT(DISTINCT customer_unique_id) as unique_customers,
    COUNT(DISTINCT customer_id) as total_customer_records
FROM olist_sales_data_set.olist_customers_dataset
WHERE customer_state IN ('SP', 'RJ', 'MG', 'RS', 'PR')
GROUP BY customer_state
ORDER BY unique_customers DESC;

-- ================================================================
-- SECTION 3: NOT IN - Exclusion Filtering
-- ================================================================

/*
NOT IN OPERATOR:
- Excludes specific values from results
- Useful for removing test data, cancelled orders, etc.
- CAUTION: NULL values can cause unexpected behavior
*/

-- Find customers NOT from the Southeast region
SELECT
    customer_state,
    COUNT(*) as customer_count
FROM olist_sales_data_set.olist_customers_dataset
WHERE customer_state NOT IN ('SP', 'RJ', 'MG', 'ES')
GROUP BY customer_state
ORDER BY customer_count DESC
LIMIT 10;

-- BUSINESS EXAMPLE: Analyze non-delivered orders (potential issues)
SELECT
    order_status,
    COUNT(*) as order_count,
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 2) as percentage
FROM olist_sales_data_set.olist_orders_dataset
WHERE order_status NOT IN ('delivered', 'shipped')
GROUP BY order_status
ORDER BY order_count DESC;

-- ================================================================
-- SECTION 4: BETWEEN Operator - Range Filtering
-- ================================================================

/*
BETWEEN OPERATOR:
- Simplifies range queries
- INCLUSIVE on both ends
- Works with numbers, dates, and text
- Syntax: column BETWEEN low_value AND high_value
*/

-- Find orders with medium-value transactions (R$ 100 - R$ 300)
SELECT
    oi.order_id,
    oi.product_id,
    oi.price,
    oi.freight_value,
    (oi.price + oi.freight_value) as total_value
FROM olist_sales_data_set.olist_order_items_dataset oi
WHERE (oi.price + oi.freight_value) BETWEEN 100 AND 300
ORDER BY total_value DESC
LIMIT 20;

-- Date ranges: Recent orders (last quarter of 2017)
SELECT
    order_id,
    customer_id,
    order_purchase_timestamp,
    order_status
FROM olist_sales_data_set.olist_orders_dataset
WHERE order_purchase_timestamp BETWEEN '2017-10-01' AND '2017-12-31'
ORDER BY order_purchase_timestamp DESC
LIMIT 15;

-- BUSINESS EXAMPLE: Customer retention - Recent but not too recent
-- Find customers who made purchases 90-180 days ago (re-engagement window)
SELECT
    c.customer_unique_id,
    c.customer_state,
    MAX(o.order_purchase_timestamp) as last_purchase_date,
    EXTRACT(DAY FROM '2018-09-01'::date - MAX(o.order_purchase_timestamp)::date) as days_since_last_order
FROM olist_sales_data_set.olist_customers_dataset c
JOIN olist_sales_data_set.olist_orders_dataset o
    ON c.customer_id = o.customer_id
WHERE o.order_status = 'delivered'
GROUP BY c.customer_unique_id, c.customer_state
HAVING EXTRACT(DAY FROM '2018-09-01'::date - MAX(o.order_purchase_timestamp)::date) BETWEEN 90 AND 180
ORDER BY days_since_last_order
LIMIT 20;

-- ================================================================
-- SECTION 5: Complex AND/OR Logic
-- ================================================================

/*
COMBINING CONDITIONS:
- AND: ALL conditions must be true
- OR: AT LEAST ONE condition must be true
- Use parentheses () to control evaluation order
- AND takes precedence over OR (like * before + in math)
*/

-- WITHOUT PARENTHESES (confusing logic!)
SELECT
    order_id,
    payment_type,
    payment_installments,
    payment_value
FROM olist_sales_data_set.olist_order_payments_dataset
WHERE payment_type = 'credit_card'
    AND payment_value > 200
    OR payment_installments >= 10
LIMIT 10;
-- This returns: (credit_card AND value > 200) OR (installments >= 10)
-- Might include non-credit cards with 10+ installments!

-- WITH PARENTHESES (clear intent!)
SELECT
    order_id,
    payment_type,
    payment_installments,
    payment_value
FROM olist_sales_data_set.olist_order_payments_dataset
WHERE payment_type = 'credit_card'
    AND (payment_value > 200 OR payment_installments >= 10)
LIMIT 10;
-- This returns: credit cards with (high value OR many installments)

-- BUSINESS EXAMPLE: At-risk customer indicators
-- Customers with low review scores OR no reviews AND high order value
SELECT
    o.order_id,
    o.customer_id,
    r.review_score,
    COALESCE(SUM(oi.price + oi.freight_value), 0) as order_value,
    CASE
        WHEN r.review_score IS NULL THEN 'No Review'
        WHEN r.review_score <= 2 THEN 'Very Dissatisfied'
        WHEN r.review_score = 3 THEN 'Neutral'
        ELSE 'Satisfied'
    END as satisfaction_level
FROM olist_sales_data_set.olist_orders_dataset o
LEFT JOIN olist_sales_data_set.olist_order_reviews_dataset r
    ON o.order_id = r.order_id
JOIN olist_sales_data_set.olist_order_items_dataset oi
    ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered'
    AND (
        r.review_score <= 2  -- Low satisfaction
        OR r.review_score IS NULL  -- No feedback given (disengaged?)
    )
GROUP BY o.order_id, o.customer_id, r.review_score
HAVING SUM(oi.price + oi.freight_value) > 150  -- High-value orders only
ORDER BY order_value DESC
LIMIT 25;

-- ================================================================
-- SECTION 6: NULL Handling in Complex Conditions
-- ================================================================

/*
NULL COMPLICATIONS:
- NULL in comparisons returns UNKNOWN (not TRUE or FALSE)
- NULL in IN/NOT IN can cause issues
- Always use IS NULL / IS NOT NULL explicitly
- Use COALESCE to provide default values
*/

-- Reviews with and without comments
SELECT
    review_score,
    COUNT(*) as total_reviews,
    COUNT(review_comment_message) as reviews_with_comments,
    COUNT(*) - COUNT(review_comment_message) as reviews_without_comments
FROM olist_sales_data_set.olist_order_reviews_dataset
GROUP BY review_score
ORDER BY review_score;

-- BUSINESS EXAMPLE: Payment anomalies
-- Orders with undefined payment methods (data quality issue)
SELECT
    order_id,
    payment_type,
    payment_value,
    payment_installments
FROM olist_sales_data_set.olist_order_payments_dataset
WHERE payment_type IS NULL
    OR payment_type = 'not_defined'
    OR payment_value = 0
LIMIT 10;

-- ================================================================
-- SECTION 7: Practical Business Case - Customer Retention Scoring
-- ================================================================

/*
RETENTION RISK FACTORS:
1. Low review scores (1-2 stars) = Dissatisfied
2. High-value customers = Critical to retain
3. Recent purchases = Active but potentially volatile
4. Credit card users = Financially engaged

GOAL: Create a filtered list of at-risk VIP customers
*/

-- Comprehensive at-risk customer analysis
WITH customer_metrics AS (
    SELECT
        c.customer_unique_id,
        c.customer_state,
        c.customer_city,
        COUNT(DISTINCT o.order_id) as total_orders,
        SUM(oi.price + oi.freight_value) as lifetime_value,
        AVG(r.review_score) as avg_review_score,
        MAX(o.order_purchase_timestamp) as last_order_date,
        MIN(r.review_score) as lowest_review_score
    FROM olist_sales_data_set.olist_customers_dataset c
    JOIN olist_sales_data_set.olist_orders_dataset o
        ON c.customer_id = o.customer_id
    JOIN olist_sales_data_set.olist_order_items_dataset oi
        ON o.order_id = oi.order_id
    LEFT JOIN olist_sales_data_set.olist_order_reviews_dataset r
        ON o.order_id = r.order_id
    WHERE o.order_status = 'delivered'
    GROUP BY c.customer_unique_id, c.customer_state, c.customer_city
)
SELECT
    customer_unique_id,
    customer_state,
    customer_city,
    total_orders,
    ROUND(lifetime_value::numeric, 2) as lifetime_value,
    ROUND(avg_review_score::numeric, 2) as avg_review_score,
    lowest_review_score,
    last_order_date,
    EXTRACT(DAY FROM '2018-09-01'::date - last_order_date::date) as days_since_last_order,
    CASE
        WHEN avg_review_score < 3 THEN 'High Risk'
        WHEN avg_review_score < 4 THEN 'Medium Risk'
        ELSE 'Low Risk'
    END as risk_category
FROM customer_metrics
WHERE
    lifetime_value > 200  -- High-value customers
    AND total_orders >= 1
    AND (
        avg_review_score < 4  -- Not fully satisfied
        OR lowest_review_score <= 2  -- Had at least one bad experience
        OR EXTRACT(DAY FROM '2018-09-01'::date - last_order_date::date) BETWEEN 60 AND 180  -- Recent but not current
    )
ORDER BY
    CASE
        WHEN avg_review_score < 3 THEN 1
        WHEN avg_review_score < 4 THEN 2
        ELSE 3
    END,
    lifetime_value DESC
LIMIT 30;

-- ================================================================
-- KEY TAKEAWAYS
-- ================================================================

/*
1. IN/NOT IN: Clean way to filter multiple values
2. BETWEEN: Inclusive range queries for numbers, dates, text
3. Parentheses: Control AND/OR evaluation order
4. NULL handling: Always explicit with IS NULL/IS NOT NULL
5. Business logic: Layer multiple conditions to create meaningful segments

NEXT STEPS:
Part 2 will introduce subqueries, letting you use one query's results
to filter another query - essential for advanced customer analysis!
*/

-- ================================================================
-- PRACTICE QUESTIONS (Try these yourself!)
-- ================================================================

/*
Q1: Find all orders paid with boleto or voucher where the payment value
    is between R$ 50 and R$ 150.

Q2: Identify customers from states 'BA', 'PE', 'CE' (Northeast region) who
    have placed more than one order.

Q3: Find products with review scores of 1 or 2 AND where the customer
    left a comment (review_comment_message IS NOT NULL).

Q4: Create a list of "dormant high-value customers": those who spent over
    R$ 300 total but haven't ordered in 200+ days.

Answers in the solutions file!
*/
