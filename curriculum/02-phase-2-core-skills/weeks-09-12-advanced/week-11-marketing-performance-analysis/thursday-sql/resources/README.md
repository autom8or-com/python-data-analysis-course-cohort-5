# SQL Marketing Analytics Resources

## Overview
This folder contains supplementary materials for the SQL marketing analytics session, including query patterns, optimization tips, and reference guides.

## Resource Files

### Reference Materials
- **marketing-sql-patterns.md** - Common SQL patterns for marketing analysis
- **attribution-modeling-sql.md** - SQL techniques for marketing attribution
- **window-functions-marketing.md** - Window functions for marketing metrics

### Query Templates
- **campaign-performance-template.sql** - Reusable campaign analysis queries
- **funnel-analysis-template.sql** - Standard funnel analysis patterns
- **roi-calculation-template.sql** - ROI calculation framework

### Optimization Guides
- **query-optimization-tips.md** - Performance tuning for marketing queries
- **indexing-strategies.md** - Database indexing for marketing analytics

## Key SQL Patterns for Marketing

### Campaign Performance Analysis
```sql
WITH campaign_metrics AS (
    SELECT
        campaign_id,
        COUNT(DISTINCT lead_id) as total_leads,
        COUNT(DISTINCT CASE WHEN converted = true THEN lead_id END) as conversions,
        SUM(spend) as total_spend
    FROM marketing_campaigns
    GROUP BY campaign_id
)
SELECT
    campaign_id,
    total_leads,
    conversions,
    ROUND(conversions::DECIMAL / total_leads * 100, 2) as conversion_rate,
    ROUND(total_spend::DECIMAL / conversions, 2) as cost_per_conversion
FROM campaign_metrics;
```

### Marketing Funnel Analysis
```sql
WITH funnel_stages AS (
    SELECT
        'Leads' as stage,
        COUNT(*) as count
    FROM marketing_qualified_leads

    UNION ALL

    SELECT
        'Opportunities' as stage,
        COUNT(*) as count
    FROM marketing_qualified_leads
    WHERE lead_score >= 50

    UNION ALL

    SELECT
        'Closed Deals' as stage,
        COUNT(*) as count
    FROM closed_deals
)
SELECT * FROM funnel_stages ORDER BY
    CASE stage
        WHEN 'Leads' THEN 1
        WHEN 'Opportunities' THEN 2
        WHEN 'Closed Deals' THEN 3
    END;
```

### Channel Attribution
```sql
WITH channel_performance AS (
    SELECT
        m.lead_origin,
        COUNT(DISTINCT m.mql_id) as leads,
        COUNT(DISTINCT c.deal_id) as deals,
        SUM(c.declared_value) as total_value,
        AVG(c.declared_value) as avg_deal_value
    FROM olist_marketing_qualified_leads m
    LEFT JOIN olist_closed_deals c ON m.mql_id = c.mql_id
    GROUP BY m.lead_origin
)
SELECT
    lead_origin as channel,
    leads,
    deals,
    ROUND(deals::DECIMAL / leads * 100, 2) as conversion_rate,
    total_value,
    avg_deal_value
FROM channel_performance
ORDER BY total_value DESC;
```

## Optimization Tips

### Indexing Strategy
- Index commonly filtered columns (lead_status, campaign_id, dates)
- Composite indexes for multi-column filters
- Consider partial indexes for frequently accessed subsets

### Query Performance
- Use CTEs for complex calculations
- Limit result sets with appropriate WHERE clauses
- Consider materialized views for recurring reports

---

**Purpose**: Reference materials and query templates
**Usage**: Quick lookup during development and review
**Updates**: Regularly updated with new patterns and optimizations