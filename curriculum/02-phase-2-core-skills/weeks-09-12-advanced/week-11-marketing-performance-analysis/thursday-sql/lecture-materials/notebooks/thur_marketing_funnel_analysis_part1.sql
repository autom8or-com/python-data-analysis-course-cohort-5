-- Week 11: Marketing Performance Analysis & Optimization
-- Thursday SQL - Query Performance and Optimization
-- Part 1: Marketing Funnel Analysis

-- Business Context: Nigerian E-commerce Marketing Performance Analysis
-- Scenario: You're a data analyst for Jumia Nigeria analyzing marketing campaign effectiveness

============================================================================
MARKETING FUNNEL ANALYSIS - MQL to Closed Deals Conversion
============================================================================

-- 1. Basic Marketing Funnel Analysis
-- Understanding the conversion from Marketing Qualified Leads (MQLs) to Closed Deals

-- First, let's examine our marketing data structure
SELECT
    table_name,
    column_name,
    data_type,
    is_nullable
FROM information_schema.columns
WHERE table_schema = 'olist_marketing_data_set'
ORDER BY table_name, ordinal_position;

-- 2. Marketing Qualified Leads Overview
-- Analyzing the source and timing of our MQLs

SELECT
    origin,
    COUNT(*) as total_mqls,
    COUNT(DISTINCT landing_page_id) as unique_landing_pages,
    MIN(first_contact_date) as earliest_contact,
    MAX(first_contact_date) as latest_contact
FROM olist_marketing_data_set.olist_marketing_qualified_leads_dataset
GROUP BY origin
ORDER BY total_mqls DESC;

-- 3. Monthly MQL Trends
-- Understanding when leads are generated throughout the year

SELECT
    DATE_TRUNC('month', first_contact_date) as contact_month,
    origin,
    COUNT(*) as mql_count,
    COUNT(DISTINCT landing_page_id) as unique_pages
FROM olist_marketing_data_set.olist_marketing_qualified_leads_dataset
GROUP BY DATE_TRUNC('month', first_contact_date), origin
ORDER BY contact_month, mql_count DESC;

-- 4. Conversion Analysis - MQL to Closed Deals
-- Calculating conversion rates by marketing channel

WITH mql_by_origin AS (
    SELECT
        origin,
        COUNT(*) as total_mqls
    FROM olist_marketing_data_set.olist_marketing_qualified_leads_dataset
    GROUP BY origin
),
closed_deals_by_origin AS (
    SELECT
        mqls.origin,
        COUNT(*) as closed_deals
    FROM olist_marketing_data_set.olist_marketing_qualified_leads_dataset mqls
    INNER JOIN olist_marketing_data_set.olist_closed_deals_dataset deals
        ON mqls.mql_id = deals.mql_id
    GROUP BY mqls.origin
)
SELECT
    m.origin,
    m.total_mqls,
    COALESCE(d.closed_deals, 0) as closed_deals,
    ROUND(COALESCE(d.closed_deals, 0.0) / m.total_mqls * 100, 2) as conversion_rate_pct
FROM mql_by_origin m
LEFT JOIN closed_deals_by_origin d ON m.origin = d.origin
ORDER BY m.total_mqls DESC;

-- 5. Time to Close Analysis
-- Understanding how long it takes to convert leads

SELECT
    mqls.origin,
    AVG(deals.won_date - mqls.first_contact_date) as avg_days_to_close,
    MIN(deals.won_date - mqls.first_contact_date) as min_days_to_close,
    MAX(deals.won_date - mqls.first_contact_date) as max_days_to_close,
    COUNT(*) as total_converted
FROM olist_marketing_data_set.olist_marketing_qualified_leads_dataset mqls
INNER JOIN olist_marketing_data_set.olist_closed_deals_dataset deals
    ON mqls.mql_id = deals.mql_id
GROUP BY mqls.origin
ORDER BY avg_days_to_close;

-- 6. Business Segment Performance
-- Which business segments convert best from each channel?

SELECT
    mqls.origin,
    deals.business_segment,
    COUNT(*) as deals_count,
    AVG(deals.declared_monthly_revenue) as avg_monthly_revenue,
    COUNT(DISTINCT deals.seller_id) as unique_sellers
FROM olist_marketing_data_set.olist_marketing_qualified_leads_dataset mqls
INNER JOIN olist_marketing_data_set.olist_closed_deals_dataset deals
    ON mqls.mql_id = deals.mql_id
GROUP BY mqls.origin, deals.business_segment
ORDER BY mqls.origin, deals_count DESC;

-- 7. Lead Behavior Analysis
-- Understanding lead characteristics and their conversion patterns

SELECT
    deals.lead_behaviour_profile,
    deals.lead_type,
    COUNT(*) as count,
    AVG(deals.declared_monthly_revenue) as avg_revenue
FROM olist_marketing_data_set.olist_closed_deals_dataset deals
WHERE deals.lead_behaviour_profile IS NOT NULL
GROUP BY deals.lead_behaviour_profile, deals.lead_type
ORDER BY count DESC;

-- Performance Analysis Query - Before Optimization
-- This query shows complex joins and aggregations that we'll optimize later

SELECT
    mqls.origin,
    mqls.landing_page_id,
    COUNT(*) as total_mqls,
    COUNT(DISTINCT deals.mql_id) as converted_mqls,
    COUNT(DISTINCT deals.seller_id) as unique_sellers,
    AVG(deals.declared_monthly_revenue) as avg_revenue,
    SUM(deals.declared_monthly_revenue) as total_revenue,
    ROUND(COUNT(DISTINCT deals.mql_id)::DECIMAL / COUNT(*) * 100, 2) as conversion_rate
FROM olist_marketing_data_set.olist_marketing_qualified_leads_dataset mqls
LEFT JOIN olist_marketing_data_set.olist_closed_deals_dataset deals
    ON mqls.mql_id = deals.mql_id
GROUP BY mqls.origin, mqls.landing_page_id
HAVING COUNT(*) >= 5
ORDER BY conversion_rate DESC, total_revenue DESC;