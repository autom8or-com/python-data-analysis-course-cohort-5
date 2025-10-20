-- ================================================================
-- WEEK 9: COMPREHENSIVE CUSTOMER LIFETIME VALUE ANALYSIS
-- Complete CLV Segmentation & Business Intelligence Script
-- Business Case: Executive CLV Dashboard for NaijaCommerce
-- ================================================================

/*
PURPOSE:
This script provides a complete end-to-end CLV analysis framework
combining all techniques learned this week: subqueries, CTEs, and
correlated patterns. Use this as a template for production CLV dashboards.

BUSINESS OUTPUTS:
1. RFM-based customer segmentation
2. Cohort retention analysis
3. State-level performance benchmarks
4. Predictive CLV calculations
5. Marketing campaign recommendations
6. Executive summary metrics

SECTIONS:
I.   Customer RFM Segmentation
II.  Cohort Analysis & Retention
III. Geographic Performance Analysis
IV.  Predictive Lifetime Value
V.   Product Affinity Analysis
VI.  Marketing Campaign Prioritization
VII. Executive Summary Dashboard

RUN TIME: ~30-60 seconds depending on database size
*/

-- ================================================================
-- SECTION I: CUSTOMER RFM SEGMENTATION
-- ================================================================

-- Complete RFM analysis with business-ready segments
WITH
customer_rfm_base AS (
    -- Calculate raw RFM metrics
    SELECT
        c.customer_unique_id,
        c.customer_state,
        c.customer_city,
        c.customer_id,

        -- Recency: Days since last purchase (as of Sept 1, 2018)
        EXTRACT(DAY FROM '2018-09-01'::date - MAX(o.order_purchase_timestamp)::date) as recency_days,

        -- Frequency: Total number of orders
        COUNT(DISTINCT o.order_id) as frequency_orders,

        -- Monetary: Total lifetime value
        SUM(oi.price + oi.freight_value) as monetary_value,

        -- Derived metrics
        MIN(o.order_purchase_timestamp)::date as first_purchase_date,
        MAX(o.order_purchase_timestamp)::date as last_purchase_date,
        EXTRACT(DAY FROM MAX(o.order_purchase_timestamp) - MIN(o.order_purchase_timestamp)) as customer_tenure_days,
        AVG(oi.price + oi.freight_value) as avg_order_value

    FROM olist_sales_data_set.olist_customers_dataset c
    JOIN olist_sales_data_set.olist_orders_dataset o ON c.customer_id = o.customer_id
    JOIN olist_sales_data_set.olist_order_items_dataset oi ON o.order_id = oi.order_id
    WHERE o.order_status = 'delivered'
    GROUP BY c.customer_unique_id, c.customer_state, c.customer_city, c.customer_id
),

customer_rfm_scored AS (
    -- Assign RFM scores (1-5 scale, 5 = best)
    SELECT
        *,
        -- R Score: Recent = Higher Score
        CASE
            WHEN recency_days <= 30 THEN 5
            WHEN recency_days <= 60 THEN 4
            WHEN recency_days <= 90 THEN 3
            WHEN recency_days <= 180 THEN 2
            ELSE 1
        END as r_score,

        -- F Score: More Orders = Higher Score
        CASE
            WHEN frequency_orders >= 5 THEN 5
            WHEN frequency_orders >= 4 THEN 4
            WHEN frequency_orders >= 3 THEN 3
            WHEN frequency_orders >= 2 THEN 2
            ELSE 1
        END as f_score,

        -- M Score: Higher Value = Higher Score
        CASE
            WHEN monetary_value >= 1000 THEN 5
            WHEN monetary_value >= 500 THEN 4
            WHEN monetary_value >= 250 THEN 3
            WHEN monetary_value >= 100 THEN 2
            ELSE 1
        END as m_score

    FROM customer_rfm_base
),

customer_segments AS (
    -- Create actionable business segments
    SELECT
        customer_unique_id,
        customer_state,
        customer_city,
        recency_days,
        frequency_orders,
        ROUND(monetary_value::numeric, 2) as monetary_value,
        ROUND(avg_order_value::numeric, 2) as avg_order_value,
        first_purchase_date,
        last_purchase_date,
        customer_tenure_days,
        r_score,
        f_score,
        m_score,
        (r_score + f_score + m_score) as rfm_score,

        -- Business segment classification
        CASE
            WHEN r_score >= 4 AND f_score >= 4 AND m_score >= 4 THEN 'Champions'
            WHEN r_score >= 4 AND f_score >= 3 THEN 'Loyal Customers'
            WHEN r_score >= 4 AND f_score <= 2 AND m_score >= 3 THEN 'Promising'
            WHEN r_score >= 3 AND f_score >= 3 AND m_score >= 3 THEN 'Potential Loyalists'
            WHEN r_score >= 3 AND m_score >= 4 THEN 'Big Spenders'
            WHEN r_score <= 2 AND f_score >= 4 AND m_score >= 4 THEN 'Cant Lose Them'
            WHEN r_score <= 2 AND f_score >= 3 THEN 'At Risk'
            WHEN r_score <= 2 AND f_score <= 2 AND m_score >= 3 THEN 'Hibernating High Value'
            WHEN r_score <= 2 THEN 'Lost'
            WHEN f_score = 1 THEN 'New Customers'
            ELSE 'Need Attention'
        END as segment,

        -- Customer value tier
        CASE
            WHEN monetary_value >= 1000 THEN 'Platinum'
            WHEN monetary_value >= 500 THEN 'Gold'
            WHEN monetary_value >= 250 THEN 'Silver'
            WHEN monetary_value >= 100 THEN 'Bronze'
            ELSE 'Basic'
        END as value_tier,

        -- Engagement status
        CASE
            WHEN recency_days <= 60 THEN 'Active'
            WHEN recency_days <= 180 THEN 'At Risk'
            ELSE 'Inactive'
        END as engagement_status

    FROM customer_rfm_scored
)

-- OUTPUT 1: Segment Performance Summary
SELECT
    segment,
    COUNT(*) as customer_count,
    ROUND(AVG(monetary_value)::numeric, 2) as avg_lifetime_value,
    ROUND(SUM(monetary_value)::numeric, 2) as total_segment_value,
    ROUND((SUM(monetary_value) / SUM(SUM(monetary_value)) OVER ()) * 100, 2) as pct_of_total_revenue,
    ROUND(AVG(frequency_orders)::numeric, 1) as avg_orders,
    ROUND(AVG(recency_days)::numeric, 0) as avg_days_inactive,
    ROUND(AVG(rfm_score)::numeric, 1) as avg_rfm_score,

    -- Marketing recommendation
    CASE segment
        WHEN 'Champions' THEN 'Reward & Retain: VIP program, exclusive access'
        WHEN 'Loyal Customers' THEN 'Upsell: Premium products, loyalty perks'
        WHEN 'Big Spenders' THEN 'Increase Frequency: Retention campaigns'
        WHEN 'Promising' THEN 'Convert: Second purchase incentives'
        WHEN 'Potential Loyalists' THEN 'Nurture: Engagement programs'
        WHEN 'Cant Lose Them' THEN 'URGENT: Executive intervention, save relationship'
        WHEN 'At Risk' THEN 'Win-Back: Special offers, re-engagement'
        WHEN 'Hibernating High Value' THEN 'Reactivation: Deep discounts'
        WHEN 'New Customers' THEN 'Onboard: Welcome series, education'
        WHEN 'Lost' THEN 'Low Priority: Minimal investment'
        ELSE 'Standard: Regular communications'
    END as recommended_action,

    -- Budget allocation (as % of marketing budget)
    CASE segment
        WHEN 'Champions' THEN '20%'
        WHEN 'Cant Lose Them' THEN '20%'
        WHEN 'Loyal Customers' THEN '15%'
        WHEN 'Big Spenders' THEN '15%'
        WHEN 'At Risk' THEN '10%'
        WHEN 'Promising' THEN '10%'
        WHEN 'Potential Loyalists' THEN '5%'
        ELSE '5%'
    END as suggested_budget_allocation

FROM customer_segments
GROUP BY segment
ORDER BY total_segment_value DESC;


-- ================================================================
-- SECTION II: COHORT ANALYSIS & RETENTION
-- ================================================================

WITH
customer_cohorts AS (
    -- Assign customers to monthly cohorts
    SELECT
        c.customer_unique_id,
        c.customer_state,
        TO_CHAR(MIN(o.order_purchase_timestamp), 'YYYY-MM') as cohort_month,
        COUNT(DISTINCT o.order_id) as total_orders,
        SUM(oi.price + oi.freight_value) as lifetime_value,
        MIN(o.order_purchase_timestamp)::date as cohort_date,
        MAX(o.order_purchase_timestamp)::date as last_purchase_date
    FROM olist_sales_data_set.olist_customers_dataset c
    JOIN olist_sales_data_set.olist_orders_dataset o ON c.customer_id = o.customer_id
    JOIN olist_sales_data_set.olist_order_items_dataset oi ON o.order_id = oi.order_id
    WHERE o.order_status = 'delivered'
    GROUP BY c.customer_unique_id, c.customer_state
),

cohort_metrics AS (
    -- Calculate cohort-level performance
    SELECT
        cohort_month,
        COUNT(DISTINCT customer_unique_id) as cohort_size,
        ROUND(AVG(lifetime_value)::numeric, 2) as avg_ltv,
        ROUND(SUM(lifetime_value)::numeric, 2) as total_revenue,
        ROUND(AVG(total_orders)::numeric, 2) as avg_orders_per_customer,

        -- Retention metrics
        COUNT(DISTINCT CASE WHEN total_orders >= 2 THEN customer_unique_id END) as repeat_customers,
        ROUND((COUNT(DISTINCT CASE WHEN total_orders >= 2 THEN customer_unique_id END) * 100.0 /
               COUNT(DISTINCT customer_unique_id)), 2) as repeat_purchase_rate,

        -- Engagement
        ROUND(AVG(EXTRACT(DAY FROM last_purchase_date - cohort_date))::numeric, 0) as avg_lifespan_days,
        COUNT(DISTINCT CASE WHEN total_orders >= 3 THEN customer_unique_id END) as loyal_customers,
        ROUND((COUNT(DISTINCT CASE WHEN total_orders >= 3 THEN customer_unique_id END) * 100.0 /
               COUNT(DISTINCT customer_unique_id)), 2) as loyalty_rate

    FROM customer_cohorts
    GROUP BY cohort_month
)

-- OUTPUT 2: Cohort Performance Dashboard
SELECT
    cohort_month,
    cohort_size,
    avg_ltv,
    total_revenue,
    repeat_purchase_rate,
    loyalty_rate,
    avg_lifespan_days,

    -- Month-over-month growth
    LAG(avg_ltv) OVER (ORDER BY cohort_month) as prev_month_ltv,
    ROUND(((avg_ltv - LAG(avg_ltv) OVER (ORDER BY cohort_month)) /
            NULLIF(LAG(avg_ltv) OVER (ORDER BY cohort_month), 0) * 100)::numeric, 2) as ltv_growth_pct,

    -- Cohort quality assessment
    CASE
        WHEN avg_ltv > 200 AND repeat_purchase_rate > 30 THEN 'Excellent Cohort'
        WHEN avg_ltv > 150 OR repeat_purchase_rate > 25 THEN 'Good Cohort'
        WHEN avg_ltv > 100 OR repeat_purchase_rate > 15 THEN 'Average Cohort'
        ELSE 'Weak Cohort'
    END as cohort_quality

FROM cohort_metrics
WHERE cohort_size >= 10  -- Filter noise
ORDER BY cohort_month;


-- ================================================================
-- SECTION III: GEOGRAPHIC PERFORMANCE ANALYSIS
-- ================================================================

WITH
state_customer_metrics AS (
    SELECT
        c.customer_state,
        c.customer_unique_id,
        SUM(oi.price + oi.freight_value) as customer_ltv,
        COUNT(DISTINCT o.order_id) as customer_orders
    FROM olist_sales_data_set.olist_customers_dataset c
    JOIN olist_sales_data_set.olist_orders_dataset o ON c.customer_id = o.customer_id
    JOIN olist_sales_data_set.olist_order_items_dataset oi ON o.order_id = oi.order_id
    WHERE o.order_status = 'delivered'
    GROUP BY c.customer_state, c.customer_unique_id
),

state_performance AS (
    SELECT
        customer_state,
        COUNT(DISTINCT customer_unique_id) as total_customers,
        ROUND(SUM(customer_ltv)::numeric, 2) as total_revenue,
        ROUND(AVG(customer_ltv)::numeric, 2) as avg_customer_ltv,
        ROUND(AVG(customer_orders)::numeric, 1) as avg_orders_per_customer,
        PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY customer_ltv) as median_ltv,
        PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY customer_ltv) as p75_ltv,
        PERCENTILE_CONT(0.90) WITHIN GROUP (ORDER BY customer_ltv) as p90_ltv,

        -- Top customer concentration
        (SELECT SUM(customer_ltv)
         FROM (SELECT customer_ltv FROM state_customer_metrics scm2
               WHERE scm2.customer_state = scm.customer_state
               ORDER BY customer_ltv DESC LIMIT 10) top10
        ) as top10_customer_revenue

    FROM state_customer_metrics scm
    GROUP BY customer_state
)

-- OUTPUT 3: State-Level Performance
SELECT
    customer_state,
    total_customers,
    total_revenue,
    avg_customer_ltv,
    avg_orders_per_customer,
    ROUND(median_ltv::numeric, 2) as median_ltv,

    -- Revenue contribution
    ROUND((total_revenue / SUM(total_revenue) OVER ()) * 100, 2) as pct_of_national_revenue,

    -- Ranking
    RANK() OVER (ORDER BY total_revenue DESC) as revenue_rank,
    RANK() OVER (ORDER BY avg_customer_ltv DESC) as ltv_rank,

    -- Market maturity indicator
    CASE
        WHEN avg_customer_ltv > p75_ltv THEN 'Mature High-Value Market'
        WHEN avg_orders_per_customer >= 2 THEN 'Growing Market'
        WHEN total_customers >= 1000 THEN 'Large Emerging Market'
        ELSE 'Early Stage Market'
    END as market_classification,

    -- Top customer concentration
    ROUND((top10_customer_revenue / total_revenue * 100)::numeric, 2) as top10_revenue_concentration_pct

FROM state_performance
WHERE total_customers >= 50  -- Focus on significant markets
ORDER BY total_revenue DESC
LIMIT 20;


-- ================================================================
-- SECTION IV: PREDICTIVE LIFETIME VALUE
-- ================================================================

WITH
customer_purchase_velocity AS (
    SELECT
        c.customer_unique_id,
        c.customer_state,
        c.customer_id,
        COUNT(DISTINCT o.order_id) as historical_orders,
        SUM(oi.price + oi.freight_value) as historical_value,
        MIN(o.order_purchase_timestamp)::date as first_purchase,
        MAX(o.order_purchase_timestamp)::date as last_purchase,
        EXTRACT(DAY FROM MAX(o.order_purchase_timestamp) - MIN(o.order_purchase_timestamp)) as days_active,
        AVG(oi.price + oi.freight_value) as avg_order_value,

        -- Purchase frequency (orders per 30 days)
        CASE
            WHEN EXTRACT(DAY FROM MAX(o.order_purchase_timestamp) - MIN(o.order_purchase_timestamp)) = 0
                THEN COUNT(DISTINCT o.order_id)
            ELSE
                COUNT(DISTINCT o.order_id) * 30.0 /
                EXTRACT(DAY FROM MAX(o.order_purchase_timestamp) - MIN(o.order_purchase_timestamp))
        END as orders_per_month,

        -- Current engagement
        EXTRACT(DAY FROM '2018-09-01'::date - MAX(o.order_purchase_timestamp)::date) as days_since_last_order

    FROM olist_sales_data_set.olist_customers_dataset c
    JOIN olist_sales_data_set.olist_orders_dataset o ON c.customer_id = o.customer_id
    JOIN olist_sales_data_set.olist_order_items_dataset oi ON o.order_id = oi.order_id
    WHERE o.order_status = 'delivered'
    GROUP BY c.customer_unique_id, c.customer_state, c.customer_id
),

predictive_ltv AS (
    SELECT
        customer_unique_id,
        customer_state,
        historical_orders,
        ROUND(historical_value::numeric, 2) as historical_value,
        ROUND(avg_order_value::numeric, 2) as avg_order_value,
        ROUND(orders_per_month::numeric, 2) as monthly_order_frequency,
        days_since_last_order,

        -- Engagement classification
        CASE
            WHEN days_since_last_order <= 60 THEN 'Active'
            WHEN days_since_last_order <= 180 THEN 'At Risk'
            ELSE 'Inactive'
        END as engagement_status,

        -- 12-month projected orders (adjusted for engagement)
        ROUND(
            orders_per_month * 12 *
            CASE
                WHEN days_since_last_order <= 60 THEN 0.8   -- Active: 80% retention
                WHEN days_since_last_order <= 180 THEN 0.4  -- At Risk: 40% retention
                ELSE 0.1                                     -- Inactive: 10% retention
            END
        ::numeric, 1) as projected_orders_12m,

        -- 12-month projected revenue
        ROUND(
            orders_per_month * 12 * avg_order_value *
            CASE
                WHEN days_since_last_order <= 60 THEN 0.8
                WHEN days_since_last_order <= 180 THEN 0.4
                ELSE 0.1
            END
        ::numeric, 2) as projected_revenue_12m,

        -- Total predicted lifetime value
        ROUND(
            (historical_value +
             orders_per_month * 12 * avg_order_value *
             CASE
                 WHEN days_since_last_order <= 60 THEN 0.8
                 WHEN days_since_last_order <= 180 THEN 0.4
                 ELSE 0.1
             END)
        ::numeric, 2) as total_predicted_ltv

    FROM customer_purchase_velocity
)

-- OUTPUT 4: Predictive LTV Segments
SELECT
    CASE
        WHEN total_predicted_ltv >= 1000 THEN 'Platinum Future (>1000)'
        WHEN total_predicted_ltv >= 500 THEN 'Gold Future (500-1000)'
        WHEN total_predicted_ltv >= 250 THEN 'Silver Future (250-500)'
        WHEN total_predicted_ltv >= 100 THEN 'Bronze Future (100-250)'
        ELSE 'Basic Future (<100)'
    END as predicted_value_tier,

    engagement_status,
    COUNT(*) as customer_count,
    ROUND(AVG(historical_value)::numeric, 2) as avg_historical_value,
    ROUND(AVG(projected_revenue_12m)::numeric, 2) as avg_projected_12m_revenue,
    ROUND(SUM(total_predicted_ltv)::numeric, 2) as total_predicted_segment_value,

    -- Investment recommendation
    CASE
        WHEN total_predicted_ltv >= 500 AND engagement_status = 'At Risk'
            THEN 'HIGH PRIORITY: Retention investment'
        WHEN total_predicted_ltv >= 1000 AND engagement_status = 'Active'
            THEN 'HIGH PRIORITY: Expansion investment'
        WHEN total_predicted_ltv < 100 AND engagement_status = 'Inactive'
            THEN 'LOW PRIORITY: Minimal spend'
        ELSE 'MEDIUM PRIORITY: Standard engagement'
    END as investment_priority

FROM predictive_ltv
GROUP BY predicted_value_tier, engagement_status
ORDER BY total_predicted_segment_value DESC;


-- ================================================================
-- SECTION V: PRODUCT AFFINITY ANALYSIS
-- ================================================================

WITH
customer_category_behavior AS (
    SELECT
        c.customer_unique_id,
        c.customer_state,
        COUNT(DISTINCT p.product_category_name) as unique_categories,
        COUNT(DISTINCT o.order_id) as total_orders,
        SUM(oi.price) as total_spent,
        STRING_AGG(DISTINCT p.product_category_name, ', ' ORDER BY p.product_category_name) as categories_list
    FROM olist_sales_data_set.olist_customers_dataset c
    JOIN olist_sales_data_set.olist_orders_dataset o ON c.customer_id = o.customer_id
    JOIN olist_sales_data_set.olist_order_items_dataset oi ON o.order_id = oi.order_id
    JOIN olist_sales_data_set.olist_products_dataset p ON oi.product_id = p.product_id
    WHERE o.order_status = 'delivered'
      AND p.product_category_name IS NOT NULL
    GROUP BY c.customer_unique_id, c.customer_state
)

-- OUTPUT 5: Category Breadth Analysis
SELECT
    CASE
        WHEN unique_categories >= 5 THEN 'Cross-Category Explorer (5+)'
        WHEN unique_categories >= 3 THEN 'Multi-Category Buyer (3-4)'
        WHEN unique_categories = 2 THEN 'Dual-Category Buyer'
        ELSE 'Single-Category Focused'
    END as category_breadth_segment,

    COUNT(*) as customer_count,
    ROUND(AVG(total_spent)::numeric, 2) as avg_customer_value,
    ROUND(AVG(total_orders)::numeric, 1) as avg_orders,
    ROUND(AVG(unique_categories)::numeric, 1) as avg_categories,

    -- Cross-sell opportunity
    CASE
        WHEN unique_categories >= 5 THEN 'Low: Already diversified'
        WHEN unique_categories >= 3 THEN 'Medium: 1-2 more categories'
        ELSE 'High: Major expansion opportunity'
    END as cross_sell_opportunity

FROM customer_category_behavior
GROUP BY category_breadth_segment
ORDER BY avg_customer_value DESC;


-- ================================================================
-- SECTION VI: EXECUTIVE SUMMARY DASHBOARD
-- ================================================================

-- Key Performance Indicators
WITH
overall_metrics AS (
    SELECT
        COUNT(DISTINCT c.customer_unique_id) as total_customers,
        COUNT(DISTINCT o.order_id) as total_orders,
        ROUND(SUM(oi.price + oi.freight_value)::numeric, 2) as total_revenue,
        ROUND(AVG(customer_ltv)::numeric, 2) as avg_customer_ltv,
        ROUND(SUM(CASE WHEN order_count >= 2 THEN customer_ltv ELSE 0 END)::numeric, 2) as revenue_from_repeat_customers,
        COUNT(DISTINCT CASE WHEN order_count >= 2 THEN customer_id END) as repeat_customers
    FROM (
        SELECT
            c.customer_id,
            c.customer_unique_id,
            COUNT(DISTINCT o.order_id) as order_count,
            SUM(oi.price + oi.freight_value) as customer_ltv
        FROM olist_sales_data_set.olist_customers_dataset c
        JOIN olist_sales_data_set.olist_orders_dataset o ON c.customer_id = o.customer_id
        JOIN olist_sales_data_set.olist_order_items_dataset oi ON o.order_id = oi.order_id
        WHERE o.order_status = 'delivered'
        GROUP BY c.customer_id, c.customer_unique_id
    ) customer_base
    CROSS JOIN olist_sales_data_set.olist_customers_dataset c
    CROSS JOIN olist_sales_data_set.olist_orders_dataset o
    CROSS JOIN olist_sales_data_set.olist_order_items_dataset oi
    WHERE o.customer_id = c.customer_id
      AND oi.order_id = o.order_id
      AND o.order_status = 'delivered'
)

-- OUTPUT 6: Executive Summary
SELECT
    'CUSTOMER LIFETIME VALUE SUMMARY' as metric_category,
    total_customers as total_unique_customers,
    total_orders,
    total_revenue,
    avg_customer_ltv,
    ROUND((total_revenue / total_customers)::numeric, 2) as revenue_per_customer,
    ROUND((total_orders * 1.0 / total_customers)::numeric, 2) as orders_per_customer,
    repeat_customers,
    ROUND((repeat_customers * 100.0 / total_customers)::numeric, 2) as repeat_customer_rate_pct,
    revenue_from_repeat_customers,
    ROUND((revenue_from_repeat_customers / total_revenue * 100)::numeric, 2) as pct_revenue_from_repeats
FROM overall_metrics;

-- ================================================================
-- END OF COMPREHENSIVE CLV ANALYSIS
-- ================================================================

/*
IMPLEMENTATION NOTES:

1. SCHEDULING:
   - Run this analysis weekly/monthly
   - Compare period-over-period trends
   - Track segment migration

2. ACTIONABLE OUTPUTS:
   - Export segment lists to CRM
   - Feed recommendations to marketing automation
   - Track campaign ROI by segment

3. OPTIMIZATION:
   - Consider materialized views for base metrics
   - Index customer_id, order_id, order_status
   - Archive historical snapshots for trend analysis

4. EXTENSIONS:
   - Add product-level affinity matrices
   - Incorporate review sentiment
   - Build churn prediction models
   - Calculate customer acquisition cost by cohort

5. BUSINESS IMPACT:
   - Prioritize retention budget allocation
   - Identify at-risk high-value customers
   - Guide product bundling strategies
   - Optimize state-level marketing spend
   - Measure cohort quality over time

This framework provides a foundation for data-driven customer
relationship management and strategic marketing decision-making.
*/
