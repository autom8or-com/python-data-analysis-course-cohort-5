-- ================================================================
-- WEEK 9: CUSTOMER LIFETIME VALUE ANALYSIS - PART 2
-- Topic: CTE Mastery for CLV Calculations
-- Business Case: Multi-Stage CLV Analysis Pipeline
-- ================================================================

/*
LEARNING OBJECTIVES:
1. Design multi-stage CTE pipelines for CLV analysis
2. Build RFM (Recency, Frequency, Monetary) segmentation with CTEs
3. Create predictive CLV models using historical data
4. Implement customer cohort analysis frameworks
5. Optimize CTE performance for production queries

BUSINESS CONTEXT:
Last week you learned basic CTEs. This week, we master advanced CTE
patterns specifically for Customer Lifetime Value analysis - the most
important metric for subscription businesses and e-commerce.

CLV COMPONENTS:
- Recency: How recently did the customer purchase?
- Frequency: How often do they purchase?
- Monetary: How much do they spend?
- Tenure: How long have they been a customer?
- Engagement: Are they active or churning?

FROM EXCEL TO SQL:
- Excel Multi-Sheet Workbook = SQL Multi-CTE Pipeline
- Excel Data Model = SQL CTE Chain
- Excel Power Query Steps = SQL CTE Stages
*/

-- ================================================================
-- SECTION 1: RFM Analysis with CTEs
-- ================================================================

/*
RFM SEGMENTATION:
The gold standard for customer value analysis.
We'll build this step-by-step using CTEs.

PIPELINE:
1. Calculate raw metrics (R, F, M)
2. Score each dimension (1-5 scale)
3. Combine scores into segments
4. Analyze segment performance
*/

WITH
-- Stage 1: Calculate raw RFM metrics for each customer
customer_rfm_raw AS (
    SELECT
        c.customer_unique_id,
        c.customer_state,
        c.customer_city,

        -- Recency: Days since last purchase
        EXTRACT(DAY FROM '2018-09-01'::date - MAX(o.order_purchase_timestamp)::date) as days_since_last_purchase,

        -- Frequency: Number of orders
        COUNT(DISTINCT o.order_id) as total_orders,

        -- Monetary: Total lifetime value
        SUM(oi.price + oi.freight_value) as lifetime_value,

        -- Additional metrics
        MIN(o.order_purchase_timestamp)::date as first_purchase_date,
        MAX(o.order_purchase_timestamp)::date as last_purchase_date,
        AVG(oi.price + oi.freight_value) as avg_order_value

    FROM olist_sales_data_set.olist_customers_dataset c
    JOIN olist_sales_data_set.olist_orders_dataset o
        ON c.customer_id = o.customer_id
    JOIN olist_sales_data_set.olist_order_items_dataset oi
        ON o.order_id = oi.order_id
    WHERE o.order_status = 'delivered'
    GROUP BY c.customer_unique_id, c.customer_state, c.customer_city
),

-- Stage 2: Calculate RFM scores (1-5 scale, 5 = best)
customer_rfm_scores AS (
    SELECT
        customer_unique_id,
        customer_state,
        customer_city,
        days_since_last_purchase,
        total_orders,
        ROUND(lifetime_value::numeric, 2) as lifetime_value,
        ROUND(avg_order_value::numeric, 2) as avg_order_value,
        first_purchase_date,
        last_purchase_date,

        -- Recency Score (lower days = better score)
        CASE
            WHEN days_since_last_purchase <= 30 THEN 5
            WHEN days_since_last_purchase <= 60 THEN 4
            WHEN days_since_last_purchase <= 90 THEN 3
            WHEN days_since_last_purchase <= 180 THEN 2
            ELSE 1
        END as recency_score,

        -- Frequency Score
        CASE
            WHEN total_orders >= 5 THEN 5
            WHEN total_orders >= 4 THEN 4
            WHEN total_orders >= 3 THEN 3
            WHEN total_orders >= 2 THEN 2
            ELSE 1
        END as frequency_score,

        -- Monetary Score
        CASE
            WHEN lifetime_value >= 1000 THEN 5
            WHEN lifetime_value >= 500 THEN 4
            WHEN lifetime_value >= 250 THEN 3
            WHEN lifetime_value >= 100 THEN 2
            ELSE 1
        END as monetary_score

    FROM customer_rfm_raw
),

-- Stage 3: Create RFM segments
customer_segments AS (
    SELECT
        *,
        -- Composite RFM score
        (recency_score + frequency_score + monetary_score) as rfm_total_score,

        -- Segment classification based on RFM combination
        CASE
            -- Champions: Recent, frequent, high-value customers
            WHEN recency_score >= 4 AND frequency_score >= 4 AND monetary_score >= 4
                THEN 'Champions'

            -- Loyal Customers: Frequent buyers regardless of recency
            WHEN frequency_score >= 4 AND monetary_score >= 3
                THEN 'Loyal Customers'

            -- Big Spenders: High monetary value
            WHEN monetary_score >= 4
                THEN 'Big Spenders'

            -- Promising: Recent customers with potential
            WHEN recency_score >= 4 AND frequency_score <= 2
                THEN 'Promising'

            -- Need Attention: Good customers becoming inactive
            WHEN recency_score <= 2 AND frequency_score >= 3
                THEN 'Need Attention'

            -- About to Sleep: Declining engagement
            WHEN recency_score <= 2 AND frequency_score >= 2
                THEN 'About to Sleep'

            -- At Risk: High value but inactive
            WHEN recency_score <= 2 AND monetary_score >= 3
                THEN 'At Risk'

            -- Cant Lose: Best customers going dormant
            WHEN recency_score <= 1 AND frequency_score >= 4 AND monetary_score >= 4
                THEN 'Cant Lose Them'

            -- Hibernating: Previously good customers now inactive
            WHEN recency_score <= 1 AND frequency_score <= 2 AND monetary_score >= 3
                THEN 'Hibernating'

            -- Lost: Inactive low-value customers
            WHEN recency_score <= 2 AND frequency_score <= 2 AND monetary_score <= 2
                THEN 'Lost'

            -- New Customers: Recent first-time buyers
            WHEN frequency_score = 1 AND recency_score >= 3
                THEN 'New Customers'

            ELSE 'Others'
        END as customer_segment

    FROM customer_rfm_scores
)

-- Stage 4: Analyze segment performance
SELECT
    customer_segment,
    COUNT(*) as customer_count,
    ROUND(AVG(lifetime_value)::numeric, 2) as avg_lifetime_value,
    ROUND(SUM(lifetime_value)::numeric, 2) as total_segment_value,
    ROUND(AVG(total_orders)::numeric, 1) as avg_orders,
    ROUND(AVG(days_since_last_purchase)::numeric, 0) as avg_days_inactive,
    ROUND(AVG(rfm_total_score)::numeric, 1) as avg_rfm_score,

    -- Segment value as percentage of total
    ROUND((SUM(lifetime_value) / SUM(SUM(lifetime_value)) OVER () * 100)::numeric, 2) as pct_of_total_value,

    -- Recommended action
    CASE
        WHEN customer_segment = 'Champions' THEN 'Reward & Retain: VIP program, early access'
        WHEN customer_segment = 'Loyal Customers' THEN 'Upsell & Cross-sell: Premium products'
        WHEN customer_segment = 'Big Spenders' THEN 'Increase Frequency: Loyalty rewards'
        WHEN customer_segment = 'Promising' THEN 'Convert: Second purchase incentives'
        WHEN customer_segment = 'Need Attention' THEN 'Re-engage: Personalized offers'
        WHEN customer_segment = 'About to Sleep' THEN 'Reactivation: Win-back campaign'
        WHEN customer_segment = 'At Risk' THEN 'Urgent: Save high-value relationships'
        WHEN customer_segment = 'Cant Lose Them' THEN 'Critical: Executive intervention'
        WHEN customer_segment = 'New Customers' THEN 'Onboard: Welcome series'
        WHEN customer_segment = 'Hibernating' THEN 'Revive: Deep discount offers'
        ELSE 'Monitor'
    END as recommended_action

FROM customer_segments
GROUP BY customer_segment
ORDER BY total_segment_value DESC;

-- 💡 Business Insight: Focus on 'Cant Lose Them' and 'At Risk' segments first - highest ROI

-- ================================================================
-- SECTION 2: Cohort Analysis with CTEs
-- ================================================================

/*
COHORT ANALYSIS:
Group customers by their first purchase month and track behavior over time.
Critical for understanding customer lifetime value by acquisition period.
*/

WITH
-- Stage 1: Identify customer cohorts
customer_cohorts AS (
    SELECT
        c.customer_unique_id,
        c.customer_state,
        TO_CHAR(MIN(o.order_purchase_timestamp), 'YYYY-MM') as cohort_month,
        MIN(o.order_purchase_timestamp)::date as cohort_date,
        COUNT(DISTINCT o.order_id) as total_orders,
        SUM(oi.price + oi.freight_value) as lifetime_value,
        MAX(o.order_purchase_timestamp)::date as last_purchase_date
    FROM olist_sales_data_set.olist_customers_dataset c
    JOIN olist_sales_data_set.olist_orders_dataset o
        ON c.customer_id = o.customer_id
    JOIN olist_sales_data_set.olist_order_items_dataset oi
        ON o.order_id = oi.order_id
    WHERE o.order_status = 'delivered'
    GROUP BY c.customer_unique_id, c.customer_state
),

-- Stage 2: Calculate cohort metrics
cohort_metrics AS (
    SELECT
        cohort_month,
        COUNT(DISTINCT customer_unique_id) as cohort_size,
        ROUND(AVG(lifetime_value)::numeric, 2) as avg_cohort_ltv,
        ROUND(SUM(lifetime_value)::numeric, 2) as total_cohort_revenue,
        ROUND(AVG(total_orders)::numeric, 2) as avg_orders_per_customer,

        -- Retention metrics
        COUNT(DISTINCT CASE WHEN total_orders >= 2 THEN customer_unique_id END) as repeat_customers,
        ROUND(
            COUNT(DISTINCT CASE WHEN total_orders >= 2 THEN customer_unique_id END) * 100.0 /
            COUNT(DISTINCT customer_unique_id)
        , 2) as repeat_purchase_rate,

        -- Customer lifespan
        ROUND(AVG(EXTRACT(DAY FROM last_purchase_date - cohort_date))::numeric, 0) as avg_customer_lifespan_days,

        -- Revenue per day
        ROUND(
            (SUM(lifetime_value) / COUNT(DISTINCT customer_unique_id)) /
            NULLIF(AVG(EXTRACT(DAY FROM last_purchase_date - cohort_date)), 0)
        ::numeric, 2) as revenue_per_customer_per_day

    FROM customer_cohorts
    GROUP BY cohort_month
),

-- Stage 3: Add period-over-period comparisons
cohort_comparison AS (
    SELECT
        cohort_month,
        cohort_size,
        avg_cohort_ltv,
        total_cohort_revenue,
        avg_orders_per_customer,
        repeat_customers,
        repeat_purchase_rate,
        avg_customer_lifespan_days,
        revenue_per_customer_per_day,

        -- Compare to previous cohort
        LAG(avg_cohort_ltv) OVER (ORDER BY cohort_month) as prev_cohort_ltv,
        ROUND(
            (avg_cohort_ltv - LAG(avg_cohort_ltv) OVER (ORDER BY cohort_month)) /
            NULLIF(LAG(avg_cohort_ltv) OVER (ORDER BY cohort_month), 0) * 100
        ::numeric, 2) as ltv_change_pct,

        LAG(repeat_purchase_rate) OVER (ORDER BY cohort_month) as prev_repeat_rate,
        ROUND(
            repeat_purchase_rate - LAG(repeat_purchase_rate) OVER (ORDER BY cohort_month)
        ::numeric, 2) as repeat_rate_change_pp

    FROM cohort_metrics
)

-- Final output: Cohort performance dashboard
SELECT
    cohort_month,
    cohort_size,
    avg_cohort_ltv,
    total_cohort_revenue,
    avg_orders_per_customer,
    repeat_purchase_rate,
    avg_customer_lifespan_days,
    revenue_per_customer_per_day,

    -- Performance indicators
    CASE
        WHEN ltv_change_pct > 10 THEN 'Improving ↑'
        WHEN ltv_change_pct < -10 THEN 'Declining ↓'
        ELSE 'Stable →'
    END as ltv_trend,

    CASE
        WHEN avg_cohort_ltv > 200 AND repeat_purchase_rate > 30 THEN 'Excellent'
        WHEN avg_cohort_ltv > 150 OR repeat_purchase_rate > 25 THEN 'Good'
        WHEN avg_cohort_ltv > 100 OR repeat_purchase_rate > 15 THEN 'Average'
        ELSE 'Needs Improvement'
    END as cohort_quality

FROM cohort_comparison
WHERE cohort_size >= 10  -- Filter out small cohorts
ORDER BY cohort_month;

-- 💡 Business Insight: Identify best-performing acquisition months to replicate marketing strategies

-- ================================================================
-- SECTION 3: Predictive CLV with Historical Patterns
-- ================================================================

/*
PREDICTIVE CLV:
Estimate future customer value based on historical behavior patterns.
Uses customer purchase velocity and average order trends.
*/

WITH
-- Stage 1: Calculate customer purchase patterns
customer_history AS (
    SELECT
        c.customer_unique_id,
        c.customer_state,
        COUNT(DISTINCT o.order_id) as historical_orders,
        SUM(oi.price + oi.freight_value) as historical_value,
        MIN(o.order_purchase_timestamp)::date as first_purchase,
        MAX(o.order_purchase_timestamp)::date as last_purchase,
        EXTRACT(DAY FROM MAX(o.order_purchase_timestamp) - MIN(o.order_purchase_timestamp)) as days_active,

        -- Calculate purchase velocity (orders per month)
        CASE
            WHEN EXTRACT(DAY FROM MAX(o.order_purchase_timestamp) - MIN(o.order_purchase_timestamp)) = 0
                THEN COUNT(DISTINCT o.order_id)
            ELSE
                COUNT(DISTINCT o.order_id) * 30.0 /
                EXTRACT(DAY FROM MAX(o.order_purchase_timestamp) - MIN(o.order_purchase_timestamp))
        END as orders_per_month

    FROM olist_sales_data_set.olist_customers_dataset c
    JOIN olist_sales_data_set.olist_orders_dataset o
        ON c.customer_id = o.customer_id
    JOIN olist_sales_data_set.olist_order_items_dataset oi
        ON o.order_id = oi.order_id
    WHERE o.order_status = 'delivered'
    GROUP BY c.customer_unique_id, c.customer_state
),

-- Stage 2: Calculate average order value trends
customer_trends AS (
    SELECT
        customer_unique_id,
        customer_state,
        historical_orders,
        ROUND(historical_value::numeric, 2) as historical_value,
        ROUND((historical_value / historical_orders)::numeric, 2) as avg_order_value,
        first_purchase,
        last_purchase,
        days_active,
        ROUND(orders_per_month::numeric, 2) as orders_per_month,

        -- Days since last purchase
        EXTRACT(DAY FROM '2018-09-01'::date - last_purchase) as days_since_last_purchase,

        -- Engagement status
        CASE
            WHEN EXTRACT(DAY FROM '2018-09-01'::date - last_purchase) <= 60 THEN 'Active'
            WHEN EXTRACT(DAY FROM '2018-09-01'::date - last_purchase) <= 180 THEN 'At Risk'
            ELSE 'Inactive'
        END as engagement_status

    FROM customer_history
),

-- Stage 3: Calculate predictive CLV (12-month projection)
predictive_clv AS (
    SELECT
        customer_unique_id,
        customer_state,
        historical_orders,
        historical_value,
        avg_order_value,
        orders_per_month,
        days_since_last_purchase,
        engagement_status,

        -- 12-month projected orders (adjusted for engagement)
        ROUND(
            CASE
                WHEN engagement_status = 'Active' THEN orders_per_month * 12 * 0.8
                WHEN engagement_status = 'At Risk' THEN orders_per_month * 12 * 0.4
                ELSE orders_per_month * 12 * 0.1
            END
        ::numeric, 1) as projected_orders_12m,

        -- 12-month projected revenue
        ROUND(
            CASE
                WHEN engagement_status = 'Active' THEN orders_per_month * 12 * 0.8 * avg_order_value
                WHEN engagement_status = 'At Risk' THEN orders_per_month * 12 * 0.4 * avg_order_value
                ELSE orders_per_month * 12 * 0.1 * avg_order_value
            END
        ::numeric, 2) as projected_revenue_12m,

        -- Total predicted lifetime value
        ROUND(
            (historical_value +
            CASE
                WHEN engagement_status = 'Active' THEN orders_per_month * 12 * 0.8 * avg_order_value
                WHEN engagement_status = 'At Risk' THEN orders_per_month * 12 * 0.4 * avg_order_value
                ELSE orders_per_month * 12 * 0.1 * avg_order_value
            END)
        ::numeric, 2) as total_predicted_ltv

    FROM customer_trends
),

-- Stage 4: Segment by predicted value
value_segments AS (
    SELECT
        *,
        CASE
            WHEN total_predicted_ltv >= 1000 THEN 'Platinum (>1000)'
            WHEN total_predicted_ltv >= 500 THEN 'Gold (500-1000)'
            WHEN total_predicted_ltv >= 250 THEN 'Silver (250-500)'
            WHEN total_predicted_ltv >= 100 THEN 'Bronze (100-250)'
            ELSE 'Basic (<100)'
        END as predicted_value_tier,

        -- ROI of retention investment
        CASE
            WHEN engagement_status = 'At Risk' AND total_predicted_ltv >= 500
                THEN 'High ROI: Invest in retention'
            WHEN engagement_status = 'Active' AND total_predicted_ltv >= 1000
                THEN 'High ROI: Invest in expansion'
            WHEN engagement_status = 'Inactive' AND total_predicted_ltv < 200
                THEN 'Low ROI: Minimal investment'
            ELSE 'Medium ROI: Standard engagement'
        END as investment_recommendation

    FROM predictive_clv
)

-- Final output: Predictive CLV analysis
SELECT
    predicted_value_tier,
    engagement_status,
    COUNT(*) as customer_count,
    ROUND(AVG(historical_value)::numeric, 2) as avg_historical_value,
    ROUND(AVG(projected_revenue_12m)::numeric, 2) as avg_projected_12m_revenue,
    ROUND(AVG(total_predicted_ltv)::numeric, 2) as avg_total_predicted_ltv,
    ROUND(SUM(total_predicted_ltv)::numeric, 2) as total_predicted_segment_value,
    ROUND(AVG(orders_per_month)::numeric, 2) as avg_monthly_order_frequency,

    -- Strategic insights
    CASE
        WHEN predicted_value_tier = 'Platinum (>1000)' AND engagement_status = 'At Risk'
            THEN 'CRITICAL: Save high-value at-risk customers'
        WHEN predicted_value_tier IN ('Gold (500-1000)', 'Platinum (>1000)') AND engagement_status = 'Active'
            THEN 'PRIORITY: Deepen relationships with best customers'
        WHEN predicted_value_tier = 'Bronze (100-250)' AND engagement_status = 'Inactive'
            THEN 'LOW PRIORITY: Minimal reactivation effort'
        ELSE 'STANDARD: Regular engagement programs'
    END as strategic_priority

FROM value_segments
GROUP BY predicted_value_tier, engagement_status
ORDER BY total_predicted_segment_value DESC;

-- 💡 Business Insight: Allocate retention budget based on predicted future value, not just historical spending

-- ================================================================
-- SECTION 4: Multi-Dimensional CLV Segmentation
-- ================================================================

/*
ADVANCED SEGMENTATION:
Combine RFM with product affinity, satisfaction, and payment behavior
for ultra-targeted marketing.
*/

WITH
-- Stage 1: Base RFM metrics
base_rfm AS (
    SELECT
        c.customer_unique_id,
        c.customer_state,
        EXTRACT(DAY FROM '2018-09-01'::date - MAX(o.order_purchase_timestamp)::date) as recency_days,
        COUNT(DISTINCT o.order_id) as frequency,
        SUM(oi.price + oi.freight_value) as monetary_value
    FROM olist_sales_data_set.olist_customers_dataset c
    JOIN olist_sales_data_set.olist_orders_dataset o ON c.customer_id = o.customer_id
    JOIN olist_sales_data_set.olist_order_items_dataset oi ON o.order_id = oi.order_id
    WHERE o.order_status = 'delivered'
    GROUP BY c.customer_unique_id, c.customer_state
),

-- Stage 2: Customer satisfaction metrics
satisfaction_metrics AS (
    SELECT
        c.customer_unique_id,
        ROUND(AVG(r.review_score)::numeric, 2) as avg_review_score,
        COUNT(CASE WHEN r.review_score >= 4 THEN 1 END) as positive_reviews,
        COUNT(CASE WHEN r.review_score <= 2 THEN 1 END) as negative_reviews,
        COUNT(DISTINCT r.review_id) as total_reviews
    FROM olist_sales_data_set.olist_customers_dataset c
    JOIN olist_sales_data_set.olist_orders_dataset o ON c.customer_id = o.customer_id
    LEFT JOIN olist_sales_data_set.olist_order_reviews_dataset r ON o.order_id = r.order_id
    WHERE o.order_status = 'delivered'
    GROUP BY c.customer_unique_id
),

-- Stage 3: Product category affinity
category_affinity AS (
    SELECT
        c.customer_unique_id,
        COUNT(DISTINCT p.product_category_name) as unique_categories_purchased,
        STRING_AGG(DISTINCT p.product_category_name, ', ' ORDER BY p.product_category_name) as categories,
        CASE
            WHEN COUNT(DISTINCT p.product_category_name) >= 5 THEN 'Cross-Category Buyer'
            WHEN COUNT(DISTINCT p.product_category_name) >= 3 THEN 'Multi-Category Buyer'
            WHEN COUNT(DISTINCT p.product_category_name) >= 2 THEN 'Dual-Category Buyer'
            ELSE 'Single-Category Buyer'
        END as category_breadth
    FROM olist_sales_data_set.olist_customers_dataset c
    JOIN olist_sales_data_set.olist_orders_dataset o ON c.customer_id = o.customer_id
    JOIN olist_sales_data_set.olist_order_items_dataset oi ON o.order_id = oi.order_id
    JOIN olist_sales_data_set.olist_products_dataset p ON oi.product_id = p.product_id
    WHERE o.order_status = 'delivered' AND p.product_category_name IS NOT NULL
    GROUP BY c.customer_unique_id
),

-- Stage 4: Payment behavior
payment_behavior AS (
    SELECT
        c.customer_unique_id,
        MODE() WITHIN GROUP (ORDER BY pay.payment_type) as preferred_payment_method,
        ROUND(AVG(pay.payment_installments)::numeric, 1) as avg_installments,
        CASE
            WHEN AVG(pay.payment_installments) > 3 THEN 'Prefers Installments'
            ELSE 'Prefers Full Payment'
        END as payment_preference
    FROM olist_sales_data_set.olist_customers_dataset c
    JOIN olist_sales_data_set.olist_orders_dataset o ON c.customer_id = o.customer_id
    JOIN olist_sales_data_set.olist_order_payments_dataset pay ON o.order_id = pay.order_id
    WHERE o.order_status = 'delivered'
    GROUP BY c.customer_unique_id
),

-- Stage 5: Combine all dimensions
comprehensive_profile AS (
    SELECT
        b.customer_unique_id,
        b.customer_state,
        b.recency_days,
        b.frequency,
        ROUND(b.monetary_value::numeric, 2) as monetary_value,

        -- Satisfaction
        COALESCE(s.avg_review_score, 3.0) as avg_review_score,
        COALESCE(s.total_reviews, 0) as total_reviews,

        -- Product affinity
        COALESCE(ca.unique_categories_purchased, 1) as unique_categories,
        COALESCE(ca.category_breadth, 'Single-Category Buyer') as category_breadth,

        -- Payment
        COALESCE(pb.preferred_payment_method, 'credit_card') as payment_method,
        COALESCE(pb.payment_preference, 'Unknown') as payment_preference,

        -- Composite scores
        CASE WHEN b.recency_days <= 60 THEN 5 WHEN b.recency_days <= 120 THEN 4
             WHEN b.recency_days <= 180 THEN 3 WHEN b.recency_days <= 365 THEN 2 ELSE 1 END as r_score,
        CASE WHEN b.frequency >= 5 THEN 5 WHEN b.frequency >= 4 THEN 4
             WHEN b.frequency >= 3 THEN 3 WHEN b.frequency >= 2 THEN 2 ELSE 1 END as f_score,
        CASE WHEN b.monetary_value >= 1000 THEN 5 WHEN b.monetary_value >= 500 THEN 4
             WHEN b.monetary_value >= 250 THEN 3 WHEN b.monetary_value >= 100 THEN 2 ELSE 1 END as m_score,
        CASE WHEN COALESCE(s.avg_review_score, 3.0) >= 4.5 THEN 5
             WHEN COALESCE(s.avg_review_score, 3.0) >= 4.0 THEN 4
             WHEN COALESCE(s.avg_review_score, 3.0) >= 3.5 THEN 3
             WHEN COALESCE(s.avg_review_score, 3.0) >= 3.0 THEN 2 ELSE 1 END as satisfaction_score

    FROM base_rfm b
    LEFT JOIN satisfaction_metrics s ON b.customer_unique_id = s.customer_unique_id
    LEFT JOIN category_affinity ca ON b.customer_unique_id = ca.customer_unique_id
    LEFT JOIN payment_behavior pb ON b.customer_unique_id = pb.customer_unique_id
),

-- Stage 6: Create micro-segments
micro_segments AS (
    SELECT
        *,
        (r_score + f_score + m_score + satisfaction_score) as composite_score,

        -- Ultra-targeted segment
        CASE
            WHEN r_score >= 4 AND f_score >= 4 AND m_score >= 4 AND satisfaction_score >= 4
                THEN 'Diamond: Best customers, perfect experience'
            WHEN r_score >= 4 AND f_score >= 3 AND satisfaction_score <= 2
                THEN 'Rescue: Active but unhappy - urgent intervention'
            WHEN m_score >= 4 AND r_score <= 2
                THEN 'Win-Back VIP: High-value dormant customers'
            WHEN f_score >= 4 AND m_score <= 2
                THEN 'Optimize: Frequent low-value - increase AOV'
            WHEN r_score >= 4 AND f_score = 1
                THEN 'New: Recent first-time buyers - convert to repeat'
            WHEN unique_categories >= 4 AND monetary_value >= 300
                THEN 'Explorer: Cross-category high-value'
            ELSE 'Standard: Regular engagement'
        END as micro_segment

    FROM comprehensive_profile
)

-- Final output: Micro-segment analysis with marketing recommendations
SELECT
    micro_segment,
    COUNT(*) as customers,
    ROUND(AVG(monetary_value)::numeric, 2) as avg_ltv,
    ROUND(SUM(monetary_value)::numeric, 2) as total_segment_value,
    ROUND(AVG(frequency)::numeric, 1) as avg_orders,
    ROUND(AVG(avg_review_score)::numeric, 2) as avg_satisfaction,
    ROUND(AVG(unique_categories)::numeric, 1) as avg_category_breadth,
    ROUND(AVG(composite_score)::numeric, 1) as avg_composite_score,

    -- Marketing strategy
    CASE
        WHEN micro_segment = 'Diamond: Best customers, perfect experience'
            THEN 'VIP Treatment: Exclusive benefits, early access, personal service'
        WHEN micro_segment = 'Rescue: Active but unhappy - urgent intervention'
            THEN 'Service Recovery: Personal outreach, address issues, compensation'
        WHEN micro_segment = 'Win-Back VIP: High-value dormant customers'
            THEN 'Win-Back Campaign: Exclusive offers, "We miss you" messaging'
        WHEN micro_segment = 'Optimize: Frequent low-value - increase AOV'
            THEN 'Basket Builder: Bundle offers, volume discounts, upsells'
        WHEN micro_segment = 'New: Recent first-time buyers - convert to repeat'
            THEN 'Onboarding: Welcome series, second-purchase discount'
        WHEN micro_segment = 'Explorer: Cross-category high-value'
            THEN 'Curation: Personalized recommendations, new category intros'
        ELSE 'Standard: Newsletter, seasonal promotions'
    END as marketing_strategy,

    -- Budget allocation recommendation (% of total marketing budget)
    CASE
        WHEN micro_segment LIKE '%Diamond%' OR micro_segment LIKE '%Win-Back VIP%' THEN '25%'
        WHEN micro_segment LIKE '%Rescue%' THEN '20%'
        WHEN micro_segment LIKE '%Explorer%' THEN '15%'
        WHEN micro_segment LIKE '%New%' OR micro_segment LIKE '%Optimize%' THEN '10%'
        ELSE '5%'
    END as budget_allocation

FROM micro_segments
GROUP BY micro_segment
ORDER BY total_segment_value DESC;

-- 💡 Business Insight: Precision targeting beats one-size-fits-all marketing

-- ================================================================
-- KEY TAKEAWAYS
-- ================================================================

/*
CTE PATTERNS FOR CLV ANALYSIS:

1. RFM SEGMENTATION:
   - Stage 1: Calculate raw metrics
   - Stage 2: Score each dimension
   - Stage 3: Combine into segments
   - Stage 4: Analyze performance

2. COHORT ANALYSIS:
   - Track customer groups over time
   - Measure retention and LTV by cohort
   - Identify best acquisition periods

3. PREDICTIVE CLV:
   - Historical patterns → Future projections
   - Adjust for engagement status
   - Guide investment decisions

4. MULTI-DIMENSIONAL SEGMENTATION:
   - Combine RFM + satisfaction + behavior
   - Create precision micro-segments
   - Enable targeted marketing

BEST PRACTICES:
✓ Give each CTE a clear, descriptive name
✓ Build complexity gradually (simple → complex)
✓ Comment each stage's business purpose
✓ Test each CTE independently before chaining
✓ Use CTEs for readability, temp tables for performance

BUSINESS VALUE:
- Identify highest-value customer segments
- Predict future revenue and churn risk
- Optimize marketing budget allocation
- Personalize customer experiences
- Track cohort performance over time
*/

-- ================================================================
-- PRACTICE EXERCISES
-- ================================================================

/*
EXERCISE 1: Create a 4-stage CTE pipeline that:
           1. Calculates customer purchase frequency by quarter
           2. Identifies trend (increasing/stable/declining)
           3. Segments by trend + current value
           4. Recommends retention vs growth strategies

EXERCISE 2: Build a cohort retention analysis showing:
           - Month 0: Initial cohort size
           - Month 1: % who purchased again
           - Month 3: % still active
           - Month 6: % still active
           Use CTEs for each time period

EXERCISE 3: Design a "Next Best Action" recommendation system using CTEs:
           - Stage 1: Calculate customer metrics
           - Stage 2: Identify gaps (low frequency, single category, etc.)
           - Stage 3: Match gaps to actions
           - Stage 4: Prioritize by predicted revenue impact

Solutions in the solutions folder!
*/
