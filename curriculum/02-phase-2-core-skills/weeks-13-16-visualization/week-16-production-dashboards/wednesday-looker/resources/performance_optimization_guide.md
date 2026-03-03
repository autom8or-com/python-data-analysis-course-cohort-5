# Performance Optimization Guide

## Week 16 - Wednesday Session Resource

**Last Updated:** March 2026 | Cohort 5

---

## Overview

This guide provides a comprehensive reference for optimizing Looker Studio dashboards connected to PostgreSQL/Supabase. All patterns are validated against the Olist e-commerce dataset. Use this guide when diagnosing slow dashboards, correcting inflated metrics, and preparing dashboards for production deployment.

---

## Table of Contents

1. [The Row Multiplication Problem](#the-row-multiplication-problem)
2. [Query Optimization Patterns](#query-optimization-patterns)
3. [Pre-Aggregation Reference](#pre-aggregation-reference)
4. [Extract vs Live Connection](#extract-vs-live-connection)
5. [Looker Studio Data Source Configuration](#looker-studio-data-source-configuration)
6. [Performance Benchmarks](#performance-benchmarks)
7. [Optimization Decision Tree](#optimization-decision-tree)
8. [Common Anti-Patterns](#common-anti-patterns)
9. [EXPLAIN Output Guide](#explain-output-guide)
10. [Production Readiness Checklist](#production-readiness-checklist)

---

## The Row Multiplication Problem

### What It Is

When you join a table with a 1:many relationship without pre-aggregating the many side first, each row in the 1-side gets duplicated for every matching row in the many-side. Aggregate functions (SUM, AVG) then compute over these duplicated rows, inflating results.

### Olist Example

The Olist `olist_orders_dataset` has a 1:many relationship with `olist_order_items_dataset` (one order can contain multiple items). When you also join `olist_order_payments_dataset`:

```
Order #123:
  - 3 items in order_items
  - 1 payment of $150 in order_payments

After joining order_items:
  - Payment row ($150) is duplicated 3 times
  - SUM(payment_value) = $150 + $150 + $150 = $450 (WRONG — 3x inflated)
```

### Validation Results

| Query Version | SP Revenue | Error |
|---------------|------------|-------|
| Inflated (with order_items join) | $7,404,140 | +28.4% |
| Correct (pre-aggregated payments) | $5,770,360 | 0% |
| Discrepancy | $1,633,780 | — |

**Rule:** Always aggregate payments to order level BEFORE joining to other tables.

### The Fix Pattern

```sql
-- WRONG: Join order_items without pre-aggregating payments
SELECT
    c.customer_state,
    SUM(p.payment_value) AS total_revenue  -- INFLATED
FROM olist_orders_dataset o
JOIN olist_customers_dataset c ON o.customer_id = c.customer_id
JOIN olist_order_payments_dataset p ON o.order_id = p.order_id
JOIN olist_order_items_dataset oi ON o.order_id = oi.order_id  -- CAUSES DUPLICATION
WHERE o.order_status = 'delivered'
GROUP BY c.customer_state;

-- CORRECT: Pre-aggregate payments first, then join
WITH order_revenue AS (
    SELECT order_id, SUM(payment_value) AS order_revenue
    FROM olist_order_payments_dataset
    GROUP BY order_id  -- Collapse to 1 row per order BEFORE joining
)
SELECT
    c.customer_state,
    SUM(r.order_revenue) AS total_revenue  -- CORRECT
FROM olist_orders_dataset o
JOIN olist_customers_dataset c ON o.customer_id = c.customer_id
JOIN order_revenue r ON o.order_id = r.order_id
WHERE o.order_status = 'delivered'
GROUP BY c.customer_state;
```

---

## Query Optimization Patterns

### Pattern 1: Filter First

Apply filters as early as possible — ideally in a CTE before joining.

```sql
-- Less efficient: filter after joining all tables
SELECT ...
FROM olist_orders_dataset o
JOIN olist_customers_dataset c ON o.customer_id = c.customer_id
WHERE o.order_status = 'delivered';  -- Filter applied after full join

-- More efficient: filter in a CTE before joining
WITH delivered_orders AS (
    SELECT order_id, customer_id, order_purchase_timestamp
    FROM olist_sales_data_set.olist_orders_dataset
    WHERE order_status = 'delivered'  -- Filter applied to 96,478 rows, not 99,441
)
SELECT ...
FROM delivered_orders o
JOIN olist_sales_data_set.olist_customers_dataset c ON o.customer_id = c.customer_id;
```

**Rows filtered:** 99,441 total orders → 96,478 delivered (2,963 orders removed before any join)

### Pattern 2: Select Only Needed Columns

```sql
-- Inefficient: SELECT * brings all columns including unused ones
SELECT *
FROM olist_sales_data_set.olist_orders_dataset;

-- Efficient: Select only what the dashboard needs
SELECT
    order_id,
    customer_id,
    order_purchase_timestamp,
    order_status
FROM olist_sales_data_set.olist_orders_dataset
WHERE order_status = 'delivered';
```

### Pattern 3: COUNT DISTINCT Carefully

`COUNT(DISTINCT field)` is expensive in SQL. In Looker Studio custom SQL, pre-calculate it:

```sql
-- Expensive in Looker calculated fields (computed per row):
-- COUNT(DISTINCT customer_unique_id)

-- Better: Pre-calculate in SQL source
SELECT
    DATE_TRUNC('month', o.order_purchase_timestamp) AS order_month,
    COUNT(DISTINCT c.customer_unique_id) AS unique_customers
FROM olist_sales_data_set.olist_orders_dataset o
JOIN olist_sales_data_set.olist_customers_dataset c ON o.customer_id = c.customer_id
WHERE o.order_status = 'delivered'
GROUP BY 1;
```

### Pattern 4: Use CTEs for Readability and Performance

CTEs (Common Table Expressions) separate logic into named, reusable steps. PostgreSQL can optimize CTE execution plans effectively.

```sql
-- 5-CTE structure for the Executive Summary data source
WITH delivered_orders AS (
    SELECT order_id, customer_id, order_purchase_timestamp
    FROM olist_sales_data_set.olist_orders_dataset
    WHERE order_status = 'delivered'
),
order_revenue AS (
    SELECT order_id, SUM(payment_value) AS order_revenue
    FROM olist_sales_data_set.olist_order_payments_dataset
    GROUP BY order_id
),
customer_states AS (
    SELECT customer_id, customer_state, customer_unique_id
    FROM olist_sales_data_set.olist_customers_dataset
),
monthly_data AS (
    SELECT
        DATE_TRUNC('month', o.order_purchase_timestamp) AS order_month,
        cs.customer_state,
        SUM(r.order_revenue) AS monthly_revenue,
        COUNT(DISTINCT o.order_id) AS order_count,
        COUNT(DISTINCT cs.customer_unique_id) AS unique_customers
    FROM delivered_orders o
    JOIN order_revenue r ON o.order_id = r.order_id
    JOIN customer_states cs ON o.customer_id = cs.customer_id
    GROUP BY 1, 2
)
SELECT
    order_month,
    customer_state,
    monthly_revenue,
    order_count,
    unique_customers,
    ROUND(monthly_revenue / NULLIF(order_count, 0), 2) AS avg_order_value
FROM monthly_data
ORDER BY order_month, monthly_revenue DESC;
```

### Pattern 5: Window Functions Must Stay in SQL

Looker Studio calculated fields do not support `LAG()`, `LEAD()`, or `NTILE()`. Pre-calculate these in your SQL data source.

```sql
-- MoM Growth requires LAG() — must be in SQL, not Looker calculated field
WITH monthly_revenue AS (
    SELECT
        DATE_TRUNC('month', o.order_purchase_timestamp) AS order_month,
        SUM(p.order_revenue) AS monthly_revenue
    FROM delivered_orders o
    JOIN order_revenue p ON o.order_id = p.order_id
    GROUP BY 1
)
SELECT
    order_month,
    monthly_revenue,
    LAG(monthly_revenue) OVER (ORDER BY order_month) AS prev_month_revenue,
    ROUND(
        (monthly_revenue - LAG(monthly_revenue) OVER (ORDER BY order_month))
        / NULLIF(LAG(monthly_revenue) OVER (ORDER BY order_month), 0) * 100,
        2
    ) AS mom_growth_pct
FROM monthly_revenue
ORDER BY order_month;
```

---

## Pre-Aggregation Reference

These are the 5 validated pre-aggregated data sources for the Week 16 Final Project. Use them as Custom SQL data sources in Looker Studio.

### Data Source 2a: Monthly Executive KPIs

**Output rows:** ~27 months | **Use for:** Executive Summary page, revenue trend, MoM comparison

| Column | Type | Description |
|--------|------|-------------|
| order_month | Date | Truncated to month (first day) |
| monthly_revenue | Numeric | SUM(payment_value) for delivered orders |
| order_count | Integer | COUNT(DISTINCT order_id) |
| unique_customers | Integer | COUNT(DISTINCT customer_unique_id) |
| avg_order_value | Numeric | monthly_revenue / order_count |
| mom_growth_pct | Numeric | Month-over-month growth % (LAG-based) |

**Key validated result:** August 2018 MoM growth = -4.13% ($985,414 from $1,027,900)

### Data Source 2b: Product Category Performance

**Output rows:** ~73 categories | **Use for:** Category bar chart, product performance page

| Column | Type | Description |
|--------|------|-------------|
| product_category | Text | Category name (Portuguese) |
| category_revenue | Numeric | SUM(payment_value) |
| order_count | Integer | COUNT(DISTINCT order_id) |
| avg_order_value | Numeric | Revenue / orders |
| category_rank | Integer | RANK() by revenue |

**Key validated result:** Top category: `cama_mesa_banho` at $1,710,378

### Data Source 2c: Seller Performance

**Output rows:** ~3,095 sellers | **Use for:** Seller analysis, top-10 table

| Column | Type | Description |
|--------|------|-------------|
| seller_id | Text | Seller identifier |
| seller_state | Text | State code |
| seller_revenue | Numeric | SUM(payment_value) |
| order_count | Integer | Count of fulfilled orders |
| avg_review_score | Numeric | Average customer rating |

### Data Source 2d: Geographic Revenue

**Output rows:** 27 states | **Use for:** Map chart, state comparison bar chart

| Column | Type | Description |
|--------|------|-------------|
| customer_state | Text | Two-letter state code |
| state_revenue | Numeric | SUM(payment_value) |
| order_count | Integer | COUNT(DISTINCT order_id) |
| unique_customers | Integer | COUNT(DISTINCT customer_unique_id) |
| avg_order_value | Numeric | Revenue per order |

**Key validated result:** SP = $5,770,360 | RJ = $2,088,545

### Data Source 2e: Marketing Funnel

**Output rows:** ~8 channels | **Use for:** Marketing page, channel comparison

| Column | Type | Description |
|--------|------|-------------|
| origin | Text | Lead source (paid_search, organic, etc.) |
| total_leads | Integer | MQL count by channel |
| closed_deals | Integer | Count of closed deals |
| conversion_rate | Numeric | closed_deals / total_leads |
| simulated_cac_usd | Numeric | SIMULATED — not real cost data |

**Key validated result:** Best channel: Paid Search at 6.37% conversion | Overall: 4.75%

**WARNING:** `simulated_cac_usd` is illustrative only. Label ALL charts using this field as "SIMULATED."

---

## Extract vs Live Connection

### Comparison Table

| Factor | Live Connection | Extract |
|--------|-----------------|---------|
| Data freshness | Real-time | Delayed by refresh schedule |
| Load speed | Slow (queries Supabase on each load) | Fast (served from Google cache) |
| Cost to database | High (every page load hits Supabase) | Low (only on scheduled refresh) |
| Best for | Dashboards with intraday data needs | Historical/weekly reporting dashboards |
| Olist dataset | Not needed (historical data, no real-time) | Recommended |
| Setup complexity | None (default) | Simple (2-click in data source editor) |
| Max data size | No limit | 100MB compressed |

### When to Use Extract for Olist

The Olist dataset is historical (Sep 2016 – Oct 2018). Data does not change. Extract is always the better choice:
- Dashboard loads in under 2 seconds vs 8-18 seconds live
- No risk of query failures from Supabase connection timeouts
- Refresh weekly is more than sufficient (weekly, Sunday 6 AM recommended)

### Configuring Extract in Looker Studio

1. Resource → Manage added data sources → Edit (pencil icon on data source)
2. Click "Extract data" tab (top of the data source editor)
3. Set schedule: Weekly → Sunday → 6:00 AM
4. Click "Save"
5. Click "Refresh now" → wait for "Extract refreshed successfully" message
6. Return to dashboard → load time drops to under 2 seconds

---

## Looker Studio Data Source Configuration

### Custom SQL Data Source Setup

1. Resource → Manage added data sources → Add a data source
2. Select connector: PostgreSQL
3. Enter Supabase credentials:
   - Host: `aws-0-eu-central-1.pooler.supabase.com`
   - Port: `5432`
   - Database: `postgres`
   - Username: `postgres.pzykoxdiwsyclwfqfiii`
4. Click "Authenticate"
5. Select "Custom query" (not a specific table)
6. Paste your SQL query (no trailing semicolon)
7. Click "Connect"
8. Name the data source descriptively (e.g., "Olist Monthly Executive KPIs")
9. Click "Add to report"

### Important: No Semicolons

Looker Studio's SQL parser does not accept a semicolon at the end of custom queries. Always remove the final `;` before pasting.

### Naming Multiple Data Sources

When a dashboard uses multiple data sources, clear naming prevents confusion:

| Data Source Name | Used For |
|-----------------|----------|
| Olist Monthly Executive KPIs | Revenue trend, MoM, scorecards |
| Olist Product Category Performance | Category bar chart, product page |
| Olist Geographic Revenue | Map chart, state comparison |
| Olist Marketing Funnel | Marketing page, channel analysis |
| Olist Seller Performance | Seller table, top-10 ranking |

### Credentials Setting

Always set to "Owner's credentials" before sharing with non-technical stakeholders:
- Resource → Manage added data sources → click lock icon (credentials) → Owner's credentials → Save

Viewers do not have Supabase accounts. Owner's credentials allow the dashboard to query the database on their behalf.

---

## Performance Benchmarks

### Expected Load Times

| Configuration | Expected Load Time | Notes |
|---------------|-------------------|-------|
| Raw table, Live | 15-25 seconds | Worst case — avoid in production |
| Custom SQL, Live | 8-15 seconds | Better, but still slow for executives |
| Custom SQL, Extract | 1-3 seconds | Production standard |
| Pre-aggregated SQL, Extract | Under 2 seconds | Optimal configuration |

### Row Count Targets

| Data Source | Raw Row Count | Pre-Aggregated Rows | Reduction |
|-------------|---------------|----------------------|-----------|
| Orders | 99,441 | ~27 rows (monthly) | 99.97% |
| Products | ~33,000 unique items | ~73 rows (categories) | 99.78% |
| Customers | 99,441 | 27 rows (states) | 99.97% |
| Sellers | ~3,095 | ~3,095 rows | 0% (seller-level needed) |
| Marketing | 8,000 MQLs | ~8 rows (channels) | 99.9% |

---

## Optimization Decision Tree

```
START: Is your dashboard loading in under 5 seconds?
           |
    YES → Good. Proceed.
           |
    NO → Are you using raw table connections (not Custom SQL)?
              |
       YES → Replace with Custom SQL pre-aggregated queries (see Pattern 4)
       NO  → Is Extract configured?
                  |
           NO  → Configure Extract (see Looker Studio section above)
           YES → Does the dashboard have more than 8 charts on one page?
                      |
               YES → Move secondary charts to a new "Details" page
               NO  → Are charts using heavy calculated fields (CASE, RUNNING_TOTAL)?
                          |
                   YES → Pre-calculate in SQL instead
                   NO  → Contact instructor — may be a data source issue
```

---

## Common Anti-Patterns

| Anti-Pattern | Problem | Fix |
|-------------|---------|-----|
| `SELECT * FROM olist_orders_dataset` | Returns all 22 columns; most unused | Select only needed columns |
| Joining order_items without pre-aggregating payments | 28% revenue inflation | Pre-aggregate in CTE before joining |
| Using `customer_id` for unique customer count | Inflated unique count (one customer, multiple IDs) | Always use `customer_unique_id` |
| Using `declared_monthly_revenue` from closed_deals | All zeros — field is empty | Use SUM(payment_value) from order_payments |
| LAG() in Looker Studio calculated field | Not supported — will error | Pre-calculate in SQL data source |
| No `WHERE order_status = 'delivered'` | Includes cancelled/returned orders in revenue | Always filter to delivered orders |
| Live connection for historical dataset | Slow loads for data that never changes | Configure Extract |
| Date range default includes 2016 | Sparse startup period distorts trends | Set default date range to Jan 2017 onward |

---

## EXPLAIN Output Guide

Run `EXPLAIN <your query>` in VS Code (Supabase) to see the query execution plan. Key terms:

| Term | What It Means | Performance Indicator |
|------|--------------|----------------------|
| `Seq Scan` | Full table scan — reads every row | Slow on large tables |
| `Index Scan` | Uses an index to find rows quickly | Fast |
| `Hash Join` | Joins using a hash map of one table | Generally efficient |
| `Nested Loop` | Joins by looping through all combinations | Can be slow |
| `cost=X..Y` | X = startup cost, Y = total cost | Lower Y = faster query |
| `rows=N` | Estimated number of rows processed | Fewer = faster |
| `actual time=X..Y` | Real execution time in ms (with EXPLAIN ANALYZE) | Direct speed measurement |

### Reading Cost Numbers

```
EXPLAIN output example:
  Seq Scan on olist_orders_dataset (cost=0.00..3456.41 rows=99441 width=8)

The key number: cost=0.00..3456.41
  0.00 = startup cost (before first row returned)
  3456.41 = total estimated cost (all rows returned)

Compare two queries:
  Query A: cost=0.00..3456.41 (raw table scan)
  Query B: cost=0.00..12.50  (pre-aggregated, 27 rows)

Query B is ~276x cheaper by the planner's estimate.
```

---

## Production Readiness Checklist

Use this checklist before sharing any dashboard with stakeholders.

```
QUERY ACCURACY
☐ Revenue uses SUM(payment_value), not SUM(price + freight_value)
☐ Revenue filtered to WHERE order_status = 'delivered'
☐ Customer counts use customer_unique_id, not customer_id
☐ No joins to olist_order_items_dataset without pre-aggregating payments first
☐ MoM growth calculated via SQL LAG() (not Looker calculated field)
☐ Validated SP revenue is approximately $5,770,360 (not $7,404,140)

PERFORMANCE
☐ All data sources use Custom SQL (not raw table connections)
☐ Extract is configured on all data sources
☐ Extract has refreshed at least once ("Refresh now" clicked)
☐ Dashboard loads in under 5 seconds in View mode
☐ Main page has 8 or fewer charts

DATA SOURCE CONFIGURATION
☐ Credentials set to "Owner's credentials"
☐ Data source named descriptively (not "PostgreSQL data source 1")
☐ Custom SQL has no trailing semicolon
☐ Date range default excludes 2016 and post-Aug 2018

DATA QUALITY NOTES
☐ Data quality footer added to each page:
    "Revenue: SUM(payment_value) — authoritative"
    "Delivery metrics exclude 2,965 undelivered orders"
    "Marketing cost data is SIMULATED"
    "Active period: Jan 2017 – Aug 2018"
☐ Marketing CAC charts labeled as "SIMULATED"
```

---

## SQL Quick Reference for Olist Optimizations

### Schema Prefixes (Required in Supabase)

```sql
-- Always use full schema.table format
olist_sales_data_set.olist_orders_dataset
olist_sales_data_set.olist_order_items_dataset
olist_sales_data_set.olist_order_payments_dataset
olist_sales_data_set.olist_customers_dataset
olist_sales_data_set.olist_products_dataset
olist_sales_data_set.olist_sellers_dataset
olist_sales_data_set.olist_order_reviews_dataset
olist_sales_data_set.olist_geolocation_dataset
olist_marketing_data_set.marketing_qualified_leads
olist_marketing_data_set.closed_deals
```

### Revenue Filter Template

```sql
-- Standard filter for all revenue queries
WHERE order_status = 'delivered'
-- Removes: approved, invoiced, shipped, processing, unavailable, cancelled
-- Keeps: delivered (96,478 orders out of 99,441)
```

### Date Truncation Patterns

```sql
DATE_TRUNC('month', order_purchase_timestamp)  -- Group by month
DATE_TRUNC('quarter', order_purchase_timestamp) -- Group by quarter
EXTRACT(YEAR FROM order_purchase_timestamp)     -- Extract year as integer
```

### NULL-Safe Division

```sql
-- Prevent division by zero errors
ROUND(numerator / NULLIF(denominator, 0), 2)

-- Example: average order value
ROUND(monthly_revenue / NULLIF(order_count, 0), 2) AS avg_order_value
```

---

**Reference Version:** Week 16 Production Dashboards | March 2026
**Dataset:** Olist Brazilian E-Commerce (Sep 2016 – Oct 2018)
**Validated Against:** Supabase PostgreSQL (Project: pzykoxdiwsyclwfqfiii)
