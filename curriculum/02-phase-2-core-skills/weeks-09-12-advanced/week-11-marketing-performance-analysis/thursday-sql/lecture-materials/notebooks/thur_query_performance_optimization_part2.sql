-- Week 11: Marketing Performance Analysis & Optimization
-- Thursday SQL - Query Performance and Optimization
-- Part 2: Query Performance Analysis and Optimization

============================================================================
QUERY PERFORMANCE ANALYSIS AND OPTIMIZATION
============================================================================

-- 1. Understanding Query Execution Plans
-- EXPLAIN shows how PostgreSQL will execute your query
-- EXPLAIN ANALYZE actually runs the query and shows timing information

-- Example: Analyze our marketing funnel query performance
EXPLAIN ANALYZE
SELECT
    mqls.origin,
    mqls.landing_page_id,
    COUNT(*) as total_mqls,
    COUNT(DISTINCT deals.mql_id) as converted_mqls
FROM olist_marketing_data_set.olist_marketing_qualified_leads_dataset mqls
LEFT JOIN olist_marketing_data_set.olist_closed_deals_dataset deals
    ON mqls.mql_id = deals.mql_id
GROUP BY mqls.origin, mqls.landing_page_id;

-- 2. Performance Bottleneck Identification
-- Common performance issues in marketing analytics queries:

-- a) Missing Indexes - Check current indexes
SELECT
    schemaname,
    tablename,
    indexname,
    indexdef
FROM pg_indexes
WHERE schemaname IN ('olist_marketing_data_set', 'olist_sales_data_set')
ORDER BY tablename, indexname;

-- b) Analyzing table sizes and row counts
SELECT
    schemaname,
    tablename,
    n_tup_ins as total_inserts,
    n_tup_upd as total_updates,
    n_tup_del as total_deletes,
    n_live_tup as live_rows,
    n_dead_tup as dead_rows
FROM pg_stat_user_tables
WHERE schemaname IN ('olist_marketing_data_set', 'olist_sales_data_set')
ORDER BY live_rows DESC;

-- 3. Index Strategy for Marketing Queries
-- Creating appropriate indexes to improve query performance

-- Recommended indexes for marketing performance analysis
CREATE INDEX CONCURRENTLY idx_mqls_origin_date
ON olist_marketing_data_set.olist_marketing_qualified_leads_dataset(origin, first_contact_date);

CREATE INDEX CONCURRENTLY idx_mqls_landing_page
ON olist_marketing_data_set.olist_marketing_qualified_leads_dataset(landing_page_id);

CREATE INDEX CONCURRENTLY idx_closed_deals_mql_id
ON olist_marketing_data_set.olist_closed_deals_dataset(mql_id);

CREATE INDEX CONCURRENTLY idx_closed_deals_won_date
ON olist_marketing_data_set.olist_closed_deals_dataset(won_date);

CREATE INDEX CONCURRENTLY idx_closed_deals_business_segment
ON olist_marketing_data_set.olist_closed_deals_dataset(business_segment);

-- 4. Query Optimization Techniques
-- Rewriting queries for better performance

-- Original: Inefficient query with multiple aggregations
SELECT
    m.origin,
    COUNT(*) as total_mqls,
    (SELECT COUNT(*) FROM olist_marketing_data_set.olist_closed_deals_dataset d
     WHERE d.mql_id IN (SELECT mql_id FROM olist_marketing_data_set.olist_marketing_qualified_leads_dataset WHERE origin = m.origin)) as closed_deals
FROM olist_marketing_data_set.olist_marketing_qualified_leads_dataset m
GROUP BY m.origin;

-- Optimized: Using LEFT JOIN instead of subquery
WITH mql_summary AS (
    SELECT
        origin,
        COUNT(*) as total_mqls
    FROM olist_marketing_data_set.olist_marketing_qualified_leads_dataset
    GROUP BY origin
),
deal_summary AS (
    SELECT
        m.origin,
        COUNT(DISTINCT d.mql_id) as closed_deals
    FROM olist_marketing_data_set.olist_marketing_qualified_leads_dataset m
    INNER JOIN olist_marketing_data_set.olist_closed_deals_dataset d ON m.mql_id = d.mql_id
    GROUP BY m.origin
)
SELECT
    m.origin,
    m.total_mqls,
    COALESCE(d.closed_deals, 0) as closed_deals,
    ROUND(COALESCE(d.closed_deals, 0.0) / m.total_mqls * 100, 2) as conversion_rate
FROM mql_summary m
LEFT JOIN deal_summary d ON m.origin = d.origin
ORDER BY m.total_mqls DESC;

-- 5. Window Functions for Performance
-- Using window functions can be more efficient than self-joins

-- Instead of self-joining to get rankings, use window functions
SELECT
    origin,
    business_segment,
    deals_count,
    avg_revenue,
    RANK() OVER (PARTITION BY origin ORDER BY deals_count DESC) as rank_in_origin,
    RANK() OVER (ORDER BY deals_count DESC) as overall_rank
FROM (
    SELECT
        mqls.origin,
        deals.business_segment,
        COUNT(*) as deals_count,
        AVG(deals.declared_monthly_revenue) as avg_revenue
    FROM olist_marketing_data_set.olist_marketing_qualified_leads_dataset mqls
    INNER JOIN olist_marketing_data_set.olist_closed_deals_dataset deals
        ON mqls.mql_id = deals.mql_id
    GROUP BY mqls.origin, deals.business_segment
) segment_performance
ORDER BY origin, rank_in_origin;

-- 6. Materialized Views for Complex Aggregations
-- Pre-calculate complex metrics for faster reporting

CREATE MATERIALIZED VIEW olist_marketing_data_set.monthly_performance_summary AS
SELECT
    DATE_TRUNC('month', mqls.first_contact_date) as month,
    mqls.origin,
    COUNT(DISTINCT mqls.mql_id) as total_mqls,
    COUNT(DISTINCT deals.mql_id) as converted_mqls,
    COUNT(DISTINCT deals.seller_id) as unique_sellers,
    SUM(deals.declared_monthly_revenue) as total_revenue,
    AVG(deals.declared_monthly_revenue) as avg_revenue_per_deal,
    ROUND(COUNT(DISTINCT deals.mql_id)::DECIMAL / COUNT(DISTINCT mqls.mql_id) * 100, 2) as conversion_rate
FROM olist_marketing_data_set.olist_marketing_qualified_leads_dataset mqls
LEFT JOIN olist_marketing_data_set.olist_closed_deals_dataset deals
    ON mqls.mql_id = deals.mql_id
GROUP BY DATE_TRUNC('month', mqls.first_contact_date), mqls.origin;

-- Create unique index for efficient refreshes
CREATE UNIQUE INDEX idx_monthly_performance_summary_unique
ON olist_marketing_data_set.monthly_performance_summary(month, origin);

-- Refresh materialized view (would be scheduled in production)
REFRESH MATERIALIZED VIEW CONCURRENTLY olist_marketing_data_set.monthly_performance_summary;

-- Query using materialized view (much faster)
SELECT * FROM olist_marketing_data_set.monthly_performance_summary
WHERE month >= '2018-01-01'::DATE
ORDER BY month, conversion_rate DESC;

-- 7. Performance Monitoring
-- Track slow queries and performance improvements

-- Enable pg_stat_statements if not already enabled
-- (This would typically be done by a database administrator)

-- View query performance statistics
SELECT
    query,
    calls,
    total_exec_time,
    mean_exec_time,
    rows
FROM pg_stat_statements
WHERE query LIKE '%marketing%' OR query LIKE '%olist%'
ORDER BY mean_exec_time DESC
LIMIT 10;

-- 8. Best Practices for Marketing Analytics Queries

-- a) Use appropriate data types
-- b) Create indexes on frequently filtered/joined columns
-- c) Avoid SELECT * in production queries
-- d) Use CTEs for readability and potential performance benefits
-- e) Consider materialized views for complex aggregations
-- f) Monitor query performance regularly

-- Example of well-optimized complex query
WITH monthly_mqls AS (
    SELECT
        DATE_TRUNC('month', first_contact_date) as month,
        origin,
        COUNT(DISTINCT mql_id) as mql_count
    FROM olist_marketing_data_set.olist_marketing_qualified_leads_dataset
    WHERE first_contact_date >= '2018-01-01'
    GROUP BY 1, 2
),
monthly_deals AS (
    SELECT
        DATE_TRUNC('month', first_contact_date) as month,
        mqls.origin,
        COUNT(DISTINCT deals.mql_id) as deal_count,
        SUM(deals.declared_monthly_revenue) as total_revenue
    FROM olist_marketing_data_set.olist_marketing_qualified_leads_dataset mqls
    INNER JOIN olist_marketing_data_set.olist_closed_deals_dataset deals
        ON mqls.mql_id = deals.mql_id
    WHERE mqls.first_contact_date >= '2018-01-01'
    GROUP BY 1, 2
)
SELECT
    m.month,
    m.origin,
    m.mql_count,
    COALESCE(d.deal_count, 0) as deal_count,
    COALESCE(d.total_revenue, 0) as total_revenue,
    ROUND(COALESCE(d.deal_count, 0.0) / m.mql_count * 100, 2) as conversion_rate,
    CASE
        WHEN COALESCE(d.total_revenue, 0) > 0 THEN COALESCE(d.total_revenue, 0.0) / m.mql_count
        ELSE 0
    END as revenue_per_mql
FROM monthly_mqls m
LEFT JOIN monthly_deals d ON m.month = d.month AND m.origin = d.origin
WHERE m.month >= '2018-01-01'::DATE
ORDER BY m.month DESC, m.mql_count DESC;