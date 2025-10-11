-- ================================================================
-- WEEK 8: ADVANCED FILTERING & SUBQUERIES - PART 3
-- Topic: Common Table Expressions (CTEs) - Clean, Readable Queries
-- Business Case: Multi-Stage Customer Analytics Pipeline
-- ================================================================

/*
LEARNING OBJECTIVES:
1. Understand what CTEs are and their benefits
2. Convert complex subqueries to readable CTEs
3. Chain multiple CTEs for step-by-step analysis
4. Apply CTEs to business intelligence workflows
5. Compare CTEs vs subqueries vs views

BUSINESS CONTEXT:
Remember that massive subquery nightmare from Part 2? CTEs make
complex multi-step analyses readable, maintainable, and debuggable.
Perfect for building business intelligence dashboards and reports!

FROM EXCEL TO SQL:
- Excel Named Ranges = SQL CTEs
- Excel "Helper Columns" = SQL CTE intermediate steps
- Excel Multiple Sheets = SQL Multiple CTEs
*/

-- ================================================================
-- SECTION 1: What are CTEs?
-- ================================================================

/*
COMMON TABLE EXPRESSION (CTE):
A temporary named result set that exists only during query execution.
Think of it as a "temporary view" or "query variable".

SYNTAX:
WITH cte_name AS (
    SELECT ...
)
SELECT * FROM cte_name;

BENEFITS:
✓ More readable than nested subqueries
✓ Reusable within same query
✓ Easier to debug (can test each CTE separately)
✓ Self-documenting code with meaningful names
✓ Can be chained for step-by-step analysis
*/

-- WITHOUT CTE: Hard to read nested subquery
SELECT
    customer_state,
    avg_ltv
FROM (
    SELECT
        customer_state,
        AVG(total_spent) as avg_ltv
    FROM (
        SELECT
            c.customer_state,
            c.customer_unique_id,
            SUM(oi.price + oi.freight_value) as total_spent
        FROM olist_sales_data_set.olist_customers_dataset c
        JOIN olist_sales_data_set.olist_orders_dataset o ON c.customer_id = o.customer_id
        JOIN olist_sales_data_set.olist_order_items_dataset oi ON o.order_id = oi.order_id
        WHERE o.order_status = 'delivered'
        GROUP BY c.customer_state, c.customer_unique_id
    ) customer_spending
    GROUP BY customer_state
) state_averages
WHERE avg_ltv > 200
ORDER BY avg_ltv DESC;

-- WITH CTE: Clear, step-by-step logic
WITH customer_spending AS (
    -- Step 1: Calculate each customer's total spending
    SELECT
        c.customer_state,
        c.customer_unique_id,
        SUM(oi.price + oi.freight_value) as total_spent
    FROM olist_sales_data_set.olist_customers_dataset c
    JOIN olist_sales_data_set.olist_orders_dataset o
        ON c.customer_id = o.customer_id
    JOIN olist_sales_data_set.olist_order_items_dataset oi
        ON o.order_id = oi.order_id
    WHERE o.order_status = 'delivered'
    GROUP BY c.customer_state, c.customer_unique_id
),
state_averages AS (
    -- Step 2: Calculate average spending per state
    SELECT
        customer_state,
        ROUND(AVG(total_spent)::numeric, 2) as avg_ltv,
        COUNT(DISTINCT customer_unique_id) as customer_count
    FROM customer_spending
    GROUP BY customer_state
)
-- Step 3: Filter to high-value states
SELECT
    customer_state,
    avg_ltv,
    customer_count
FROM state_averages
WHERE avg_ltv > 200
ORDER BY avg_ltv DESC;

-- ================================================================
-- SECTION 2: Single CTE - Simplifying Basic Queries
-- ================================================================

-- BUSINESS EXAMPLE: High-value orders analysis
WITH high_value_orders AS (
    SELECT
        o.order_id,
        o.customer_id,
        o.order_purchase_timestamp,
        SUM(oi.price + oi.freight_value) as order_total
    FROM olist_sales_data_set.olist_orders_dataset o
    JOIN olist_sales_data_set.olist_order_items_dataset oi
        ON o.order_id = oi.order_id
    WHERE o.order_status = 'delivered'
    GROUP BY o.order_id, o.customer_id, o.order_purchase_timestamp
    HAVING SUM(oi.price + oi.freight_value) > 500
)
SELECT
    hvo.order_id,
    hvo.customer_id,
    c.customer_state,
    c.customer_city,
    ROUND(hvo.order_total::numeric, 2) as order_total,
    hvo.order_purchase_timestamp,
    r.review_score
FROM high_value_orders hvo
JOIN olist_sales_data_set.olist_customers_dataset c
    ON hvo.customer_id = c.customer_id
LEFT JOIN olist_sales_data_set.olist_order_reviews_dataset r
    ON hvo.order_id = r.order_id
ORDER BY hvo.order_total DESC
LIMIT 20;

-- ================================================================
-- SECTION 3: Multiple CTEs - Building Analysis Pipelines
-- ================================================================

/*
CHAINING CTEs:
WITH
    cte1 AS (...),
    cte2 AS (...),  -- Can reference cte1
    cte3 AS (...)   -- Can reference cte1 and cte2
SELECT * FROM cte3;

Each CTE can use results from previous CTEs!
*/

-- BUSINESS EXAMPLE: Customer Segmentation Pipeline
-- Step-by-step: Raw data → Aggregations → Scoring → Segmentation

WITH
-- CTE 1: Calculate basic customer metrics
customer_metrics AS (
    SELECT
        c.customer_unique_id,
        c.customer_state,
        COUNT(DISTINCT o.order_id) as total_orders,
        SUM(oi.price + oi.freight_value) as lifetime_value,
        AVG(r.review_score) as avg_review_score,
        MIN(o.order_purchase_timestamp) as first_order_date,
        MAX(o.order_purchase_timestamp) as last_order_date
    FROM olist_sales_data_set.olist_customers_dataset c
    JOIN olist_sales_data_set.olist_orders_dataset o
        ON c.customer_id = o.customer_id
    JOIN olist_sales_data_set.olist_order_items_dataset oi
        ON o.order_id = oi.order_id
    LEFT JOIN olist_sales_data_set.olist_order_reviews_dataset r
        ON o.order_id = r.order_id
    WHERE o.order_status = 'delivered'
    GROUP BY c.customer_unique_id, c.customer_state
),

-- CTE 2: Add derived metrics and scoring
customer_scores AS (
    SELECT
        customer_unique_id,
        customer_state,
        total_orders,
        ROUND(lifetime_value::numeric, 2) as lifetime_value,
        ROUND(avg_review_score::numeric, 2) as avg_review_score,
        EXTRACT(DAY FROM '2018-09-01'::date - last_order_date::date) as days_since_last_order,
        EXTRACT(DAY FROM last_order_date::date - first_order_date::date) as customer_lifespan_days,

        -- Scoring components
        CASE
            WHEN lifetime_value > 1000 THEN 5
            WHEN lifetime_value > 500 THEN 4
            WHEN lifetime_value > 200 THEN 3
            WHEN lifetime_value > 100 THEN 2
            ELSE 1
        END as value_score,

        CASE
            WHEN total_orders >= 5 THEN 5
            WHEN total_orders >= 3 THEN 4
            WHEN total_orders >= 2 THEN 3
            ELSE 2
        END as frequency_score,

        CASE
            WHEN EXTRACT(DAY FROM '2018-09-01'::date - last_order_date::date) <= 30 THEN 5
            WHEN EXTRACT(DAY FROM '2018-09-01'::date - last_order_date::date) <= 90 THEN 4
            WHEN EXTRACT(DAY FROM '2018-09-01'::date - last_order_date::date) <= 180 THEN 3
            WHEN EXTRACT(DAY FROM '2018-09-01'::date - last_order_date::date) <= 365 THEN 2
            ELSE 1
        END as recency_score,

        CASE
            WHEN avg_review_score >= 4.5 THEN 5
            WHEN avg_review_score >= 4.0 THEN 4
            WHEN avg_review_score >= 3.0 THEN 3
            WHEN avg_review_score IS NOT NULL THEN 2
            ELSE 1
        END as satisfaction_score

    FROM customer_metrics
),

-- CTE 3: Calculate composite RFM score and segment
customer_segments AS (
    SELECT
        customer_unique_id,
        customer_state,
        total_orders,
        lifetime_value,
        avg_review_score,
        days_since_last_order,
        customer_lifespan_days,

        -- Individual scores
        recency_score,
        frequency_score,
        value_score,
        satisfaction_score,

        -- Composite RFM score
        (recency_score + frequency_score + value_score) as rfm_score,

        -- Segmentation
        CASE
            WHEN (recency_score + frequency_score + value_score) >= 13 THEN 'Champions'
            WHEN (recency_score + frequency_score + value_score) >= 10 THEN 'Loyal Customers'
            WHEN recency_score >= 4 AND frequency_score <= 2 THEN 'New Customers'
            WHEN recency_score <= 2 AND frequency_score >= 3 THEN 'At Risk'
            WHEN recency_score <= 2 AND value_score >= 4 THEN 'Cant Lose Them'
            WHEN frequency_score <= 2 AND value_score <= 2 THEN 'Lost'
            ELSE 'Potential'
        END as segment

    FROM customer_scores
)

-- Final output: Segmented customer analysis
SELECT
    segment,
    COUNT(*) as customers_in_segment,
    ROUND(AVG(lifetime_value)::numeric, 2) as avg_ltv,
    ROUND(AVG(total_orders)::numeric, 2) as avg_orders,
    ROUND(AVG(avg_review_score)::numeric, 2) as avg_satisfaction,
    ROUND(AVG(days_since_last_order)::numeric, 0) as avg_days_inactive,
    ROUND(AVG(rfm_score)::numeric, 2) as avg_rfm_score
FROM customer_segments
GROUP BY segment
ORDER BY avg_rfm_score DESC;

-- ================================================================
-- SECTION 4: CTEs for Filtering with IN/EXISTS
-- ================================================================

-- Replace subqueries with CTEs for cleaner code

-- BUSINESS EXAMPLE: Find orders from repeat customers
WITH repeat_customers AS (
    SELECT
        c.customer_unique_id,
        COUNT(DISTINCT o.order_id) as order_count
    FROM olist_sales_data_set.olist_customers_dataset c
    JOIN olist_sales_data_set.olist_orders_dataset o
        ON c.customer_id = o.customer_id
    WHERE o.order_status = 'delivered'
    GROUP BY c.customer_unique_id
    HAVING COUNT(DISTINCT o.order_id) >= 3
)
SELECT
    o.order_id,
    c.customer_unique_id,
    c.customer_state,
    o.order_purchase_timestamp,
    rc.order_count as customer_total_orders
FROM olist_sales_data_set.olist_orders_dataset o
JOIN olist_sales_data_set.olist_customers_dataset c
    ON o.customer_id = c.customer_id
JOIN repeat_customers rc
    ON c.customer_unique_id = rc.customer_unique_id
WHERE o.order_status = 'delivered'
ORDER BY rc.order_count DESC, o.order_purchase_timestamp DESC
LIMIT 25;

-- ================================================================
-- SECTION 5: CTEs for Complex Business Analytics
-- ================================================================

-- BUSINESS CASE: Product Performance Dashboard
-- Question: "Which products have high sales volume but low satisfaction?"

WITH
-- Step 1: Product sales metrics
product_sales AS (
    SELECT
        oi.product_id,
        p.product_category_name,
        COUNT(DISTINCT oi.order_id) as times_sold,
        SUM(oi.price) as total_revenue,
        AVG(oi.price) as avg_price
    FROM olist_sales_data_set.olist_order_items_dataset oi
    JOIN olist_sales_data_set.olist_products_dataset p
        ON oi.product_id = p.product_id
    GROUP BY oi.product_id, p.product_category_name
),

-- Step 2: Product review metrics
product_reviews AS (
    SELECT
        oi.product_id,
        COUNT(DISTINCT r.review_id) as total_reviews,
        AVG(r.review_score) as avg_review_score,
        COUNT(CASE WHEN r.review_score <= 2 THEN 1 END) as negative_reviews
    FROM olist_sales_data_set.olist_order_items_dataset oi
    JOIN olist_sales_data_set.olist_order_reviews_dataset r
        ON oi.order_id = r.order_id
    WHERE r.review_score IS NOT NULL
    GROUP BY oi.product_id
),

-- Step 3: Combined product intelligence
product_intelligence AS (
    SELECT
        ps.product_id,
        ps.product_category_name,
        ps.times_sold,
        ROUND(ps.total_revenue::numeric, 2) as total_revenue,
        ROUND(ps.avg_price::numeric, 2) as avg_price,
        COALESCE(pr.total_reviews, 0) as total_reviews,
        ROUND(pr.avg_review_score::numeric, 2) as avg_review_score,
        COALESCE(pr.negative_reviews, 0) as negative_reviews,

        -- Performance flags
        CASE
            WHEN ps.times_sold >= 50 THEN 'High Volume'
            WHEN ps.times_sold >= 20 THEN 'Medium Volume'
            ELSE 'Low Volume'
        END as sales_volume_category,

        CASE
            WHEN pr.avg_review_score >= 4.0 THEN 'High Satisfaction'
            WHEN pr.avg_review_score >= 3.0 THEN 'Medium Satisfaction'
            WHEN pr.avg_review_score IS NOT NULL THEN 'Low Satisfaction'
            ELSE 'No Reviews'
        END as satisfaction_category

    FROM product_sales ps
    LEFT JOIN product_reviews pr
        ON ps.product_id = pr.product_id
)

-- Final analysis: Problem products (high volume, low satisfaction)
SELECT
    product_id,
    product_category_name,
    times_sold,
    total_revenue,
    avg_price,
    total_reviews,
    avg_review_score,
    negative_reviews,
    sales_volume_category,
    satisfaction_category
FROM product_intelligence
WHERE sales_volume_category IN ('High Volume', 'Medium Volume')
    AND satisfaction_category IN ('Low Satisfaction', 'Medium Satisfaction')
    AND total_reviews >= 5  -- Statistically meaningful sample
ORDER BY times_sold DESC, avg_review_score ASC
LIMIT 20;

-- ================================================================
-- SECTION 6: CTEs vs Subqueries vs Views
-- ================================================================

/*
WHEN TO USE WHAT?

CTEs (WITH clause):
✓ Complex queries with multiple steps
✓ Need to reference same result set multiple times
✓ Want readable, maintainable code
✓ Temporary - exists only for one query
✗ Can't be reused across different queries

SUBQUERIES (nested SELECT):
✓ Simple, one-off calculations
✓ Scalar values in WHERE/SELECT clauses
✗ Hard to read when nested deeply
✗ Can't be referenced multiple times

VIEWS (CREATE VIEW):
✓ Need to reuse query across many queries
✓ Want to abstract complexity from end users
✓ Permanent - stored in database
✗ Requires CREATE permission
✗ Maintenance overhead

BEST PRACTICE: Start with CTEs, create Views if you find yourself
copying the same CTE across many queries.
*/

-- ================================================================
-- SECTION 7: Comprehensive Business Case - Customer Retention Dashboard
-- ================================================================

/*
SCENARIO:
CMO needs a dashboard answering:
1. Who are our most valuable customers?
2. Which valuable customers are at risk of churning?
3. What's causing dissatisfaction among high-value customers?
4. Which customer segments should we prioritize for retention campaigns?

We'll build this step-by-step with CTEs.
*/

WITH
-- Stage 1: Customer purchase behavior
customer_behavior AS (
    SELECT
        c.customer_unique_id,
        c.customer_state,
        COUNT(DISTINCT o.order_id) as total_orders,
        MIN(o.order_purchase_timestamp) as first_purchase,
        MAX(o.order_purchase_timestamp) as last_purchase,
        SUM(oi.price + oi.freight_value) as lifetime_value
    FROM olist_sales_data_set.olist_customers_dataset c
    JOIN olist_sales_data_set.olist_orders_dataset o
        ON c.customer_id = o.customer_id
    JOIN olist_sales_data_set.olist_order_items_dataset oi
        ON o.order_id = oi.order_id
    WHERE o.order_status = 'delivered'
    GROUP BY c.customer_unique_id, c.customer_state
),

-- Stage 2: Customer satisfaction metrics
customer_satisfaction AS (
    SELECT
        c.customer_unique_id,
        AVG(r.review_score) as avg_review_score,
        MIN(r.review_score) as worst_review,
        MAX(r.review_score) as best_review,
        COUNT(DISTINCT r.review_id) as total_reviews,
        COUNT(CASE WHEN r.review_score <= 2 THEN 1 END) as negative_reviews
    FROM olist_sales_data_set.olist_customers_dataset c
    JOIN olist_sales_data_set.olist_orders_dataset o
        ON c.customer_id = o.customer_id
    LEFT JOIN olist_sales_data_set.olist_order_reviews_dataset r
        ON o.order_id = r.order_id
    WHERE o.order_status = 'delivered'
    GROUP BY c.customer_unique_id
),

-- Stage 3: Combine and enrich with derived metrics
customer_profile AS (
    SELECT
        cb.customer_unique_id,
        cb.customer_state,
        cb.total_orders,
        ROUND(cb.lifetime_value::numeric, 2) as lifetime_value,
        ROUND(cs.avg_review_score::numeric, 2) as avg_review_score,
        cs.worst_review,
        cs.total_reviews,
        cs.negative_reviews,

        -- Time-based metrics
        cb.first_purchase,
        cb.last_purchase,
        EXTRACT(DAY FROM '2018-09-01'::date - cb.last_purchase::date) as days_inactive,
        EXTRACT(DAY FROM cb.last_purchase::date - cb.first_purchase::date) as customer_age_days,

        -- Customer tier
        CASE
            WHEN cb.lifetime_value > 1000 THEN 'Platinum'
            WHEN cb.lifetime_value > 500 THEN 'Gold'
            WHEN cb.lifetime_value > 200 THEN 'Silver'
            ELSE 'Bronze'
        END as value_tier,

        -- Activity status
        CASE
            WHEN EXTRACT(DAY FROM '2018-09-01'::date - cb.last_purchase::date) <= 60 THEN 'Active'
            WHEN EXTRACT(DAY FROM '2018-09-01'::date - cb.last_purchase::date) <= 180 THEN 'At Risk'
            ELSE 'Dormant'
        END as activity_status,

        -- Satisfaction status
        CASE
            WHEN cs.worst_review <= 2 THEN 'Had Bad Experience'
            WHEN cs.avg_review_score < 3.5 THEN 'Generally Unhappy'
            WHEN cs.avg_review_score IS NULL THEN 'Never Reviews'
            WHEN cs.avg_review_score >= 4.5 THEN 'Very Satisfied'
            ELSE 'Satisfied'
        END as satisfaction_status

    FROM customer_behavior cb
    LEFT JOIN customer_satisfaction cs
        ON cb.customer_unique_id = cs.customer_unique_id
),

-- Stage 4: Priority scoring for retention campaigns
retention_priorities AS (
    SELECT
        customer_unique_id,
        customer_state,
        total_orders,
        lifetime_value,
        avg_review_score,
        days_inactive,
        value_tier,
        activity_status,
        satisfaction_status,

        -- Priority score (higher = more urgent)
        CASE
            WHEN value_tier IN ('Platinum', 'Gold') AND activity_status = 'At Risk' THEN 100
            WHEN value_tier IN ('Platinum', 'Gold') AND satisfaction_status = 'Had Bad Experience' THEN 95
            WHEN value_tier = 'Gold' AND activity_status = 'Dormant' THEN 90
            WHEN value_tier IN ('Silver', 'Gold') AND satisfaction_status = 'Generally Unhappy' THEN 85
            WHEN value_tier = 'Platinum' AND activity_status = 'Active' THEN 80
            WHEN value_tier = 'Silver' AND activity_status = 'At Risk' THEN 70
            ELSE 50
        END as retention_priority_score,

        -- Recommended action
        CASE
            WHEN value_tier IN ('Platinum', 'Gold') AND activity_status = 'At Risk' AND satisfaction_status != 'Very Satisfied'
                THEN 'URGENT: Personal Outreach + Special Offer'
            WHEN value_tier IN ('Platinum', 'Gold') AND activity_status = 'Dormant'
                THEN 'Win-back Campaign with Deep Discount'
            WHEN satisfaction_status = 'Had Bad Experience' AND lifetime_value > 300
                THEN 'Service Recovery + Apology Discount'
            WHEN value_tier = 'Silver' AND activity_status = 'At Risk'
                THEN 'Re-engagement Email Series'
            WHEN activity_status = 'Active' AND value_tier IN ('Gold', 'Platinum')
                THEN 'VIP Program Invitation'
            ELSE 'Standard Newsletter'
        END as recommended_action

    FROM customer_profile
    WHERE lifetime_value > 100  -- Focus on customers worth retaining
)

-- Final Dashboard Output
SELECT
    retention_priority_score,
    recommended_action,
    value_tier,
    activity_status,
    satisfaction_status,
    COUNT(*) as customers_in_category,
    ROUND(AVG(lifetime_value)::numeric, 2) as avg_ltv,
    ROUND(AVG(days_inactive)::numeric, 0) as avg_days_inactive,
    ROUND(AVG(total_orders)::numeric, 1) as avg_orders,
    SUM(lifetime_value) as total_revenue_at_risk
FROM retention_priorities
GROUP BY
    retention_priority_score,
    recommended_action,
    value_tier,
    activity_status,
    satisfaction_status
ORDER BY retention_priority_score DESC, total_revenue_at_risk DESC;

-- ================================================================
-- KEY TAKEAWAYS
-- ================================================================

/*
1. CTEs: Named temporary result sets using WITH clause
2. READABILITY: Break complex queries into logical steps
3. REUSABILITY: Reference CTE multiple times in same query
4. DEBUGGING: Test each CTE independently
5. CHAINING: Each CTE can reference previous CTEs
6. BUSINESS VALUE: Perfect for analytics pipelines and dashboards

BEST PRACTICES:
✓ Give CTEs descriptive, business-meaningful names
✓ Add comments explaining each CTE's purpose
✓ Keep each CTE focused on one logical step
✓ Order CTEs from raw data → aggregations → business logic
✓ Consider moving frequently-used CTEs to VIEWs

PERFORMANCE NOTES:
- CTEs are "query-scoped views" (temporary)
- Not materialized (re-computed each reference)
- For better performance with reuse, consider temp tables
- Modern databases optimize CTE execution intelligently
*/

-- ================================================================
-- PRACTICE QUESTIONS
-- ================================================================

/*
Q1: Create a CTE-based query that identifies "product champions" -
    products with >20 sales, >4.0 avg review score, and >50% repeat
    customer rate.

Q2: Build a 3-stage CTE pipeline that:
    Stage 1: Calculates monthly order counts per customer
    Stage 2: Identifies growth/decline trends
    Stage 3: Segments customers by trend (Growing/Stable/Declining)

Q3: Use CTEs to create a "customer journey funnel":
    Stage 1: All customers who placed first order
    Stage 2: Those who placed second order
    Stage 3: Those who became repeat customers (3+)
    Show conversion rates between stages.

Q4: Design a CTE-based retention campaign target list that combines:
    - High lifetime value customers
    - Recent decline in purchase frequency
    - At least one low review score in history
    - Payment preference (credit card users only)

Answers in the solutions file!
*/
