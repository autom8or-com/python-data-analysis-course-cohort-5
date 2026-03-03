# Pre-Aggregation Strategies for Production Data Sources

## Week 16 - Wednesday Session - Part 2

### Duration: 20 minutes

---

## What Is Pre-Aggregation?

**Pre-aggregation** means computing summarized results in SQL before Looker Studio receives the data, rather than letting Looker Studio aggregate raw rows on the fly.

Instead of connecting Looker Studio to 99,441 raw order rows and having every chart compute its own aggregation, you write a SQL query that returns 26 monthly summary rows — one per month — and Looker Studio works with that compact result set.

### The Core Trade-Off

| Approach | Data Size Sent to Looker | Chart Speed | Data Freshness |
|----------|--------------------------|-------------|----------------|
| Live connection to raw tables | Full table (99,441+ rows) | Slow (aggregates at query time) | Real-time |
| Custom SQL (pre-aggregated) | Summary rows only (26-500 rows) | Fast | Reflects last query execution |
| Extract (cached snapshot) | Cached in Looker's servers | Fastest | Updated on schedule |

**Rule of thumb:** For dashboards with an audience larger than 2-3 people, or data that refreshes daily rather than every minute, pre-aggregated custom SQL is almost always the right choice.

### Connection to Prior Learning

In Week 4 you wrote aggregation queries for analysis. In Week 14 you connected Looker Studio to live tables. This lesson combines both: you write the aggregation query, then connect Looker Studio to that query as a custom SQL data source — not the raw table.

```sql
-- Week 4 (analysis): aggregate for insight
SELECT customer_state, SUM(payment_value)
FROM olist_sales_data_set.olist_order_payments_dataset p
JOIN olist_sales_data_set.olist_orders_dataset o ON p.order_id = o.order_id
GROUP BY customer_state;

-- Week 16 (production): that exact same query becomes your Looker Studio data source
-- Looker Studio receives 27 rows (one per state) instead of 103,886 raw payment rows
```

---

## Extract vs Live Connection in Looker Studio

Before connecting your pre-aggregated queries, understand the two connection modes.

### Live Connection

- Every chart interaction (filter change, date range update) sends a new query to Supabase
- Data is always current as of the moment the user views the dashboard
- Can be slow for large datasets or complex queries
- Appropriate for: operational dashboards needing real-time data, datasets under 50K rows

**How to set:** When adding a data source, connect with default settings (no extract).

### Extract Connection

- Looker Studio runs your query once and caches the results on Google's servers
- Subsequent chart loads read from the cache — very fast
- Data is stale until the next scheduled refresh
- Appropriate for: executive dashboards reviewed weekly/monthly, historical datasets that do not change

**How to set:** Edit data source → "Extract data" tab → Configure refresh schedule.

**For the Olist dataset:** Since the data is historical (2016-2018) and does not change, an Extract connection is ideal. Configure a weekly refresh to keep things tidy, but the data will be identical each time.

---

## The Five Production Pre-Aggregated Data Sources

These five queries are validated against the live Supabase database. Each one becomes a separate Custom SQL data source in Looker Studio.

---

### Query 2a: Executive Summary Monthly KPIs

**Purpose:** Powers your executive summary dashboard page. Returns 26 monthly rows covering the full Olist period.

**Returns:** `year_month`, `total_revenue`, `order_count`, `avg_order_value`, `new_customers`, `returning_customers`

```sql
-- Pre-aggregated executive summary: monthly KPIs with customer acquisition breakdown
WITH monthly_orders AS (
    SELECT
        TO_CHAR(o.order_purchase_timestamp, 'YYYY-MM') AS year_month,
        o.order_id,
        o.customer_id,
        p.payment_value
    FROM olist_sales_data_set.olist_orders_dataset o
    JOIN olist_sales_data_set.olist_order_payments_dataset p ON o.order_id = p.order_id
    WHERE o.order_status = 'delivered'
),
customer_first_order AS (
    SELECT
        c.customer_unique_id,
        MIN(TO_CHAR(o.order_purchase_timestamp, 'YYYY-MM')) AS first_order_month
    FROM olist_sales_data_set.olist_customers_dataset c
    JOIN olist_sales_data_set.olist_orders_dataset o ON c.customer_id = o.customer_id
    WHERE o.order_status = 'delivered'
    GROUP BY c.customer_unique_id
),
monthly_customer_type AS (
    SELECT
        TO_CHAR(o.order_purchase_timestamp, 'YYYY-MM') AS year_month,
        c.customer_unique_id,
        CASE
            WHEN TO_CHAR(o.order_purchase_timestamp, 'YYYY-MM') = cfo.first_order_month THEN 'new'
            ELSE 'returning'
        END AS customer_type
    FROM olist_sales_data_set.olist_orders_dataset o
    JOIN olist_sales_data_set.olist_customers_dataset c ON o.customer_id = c.customer_id
    JOIN customer_first_order cfo ON c.customer_unique_id = cfo.customer_unique_id
    WHERE o.order_status = 'delivered'
)
SELECT
    mo.year_month,
    ROUND(SUM(mo.payment_value)::numeric, 2)          AS total_revenue,
    COUNT(DISTINCT mo.order_id)                        AS order_count,
    ROUND(AVG(mo.payment_value)::numeric, 2)           AS avg_order_value,
    COUNT(DISTINCT CASE WHEN mct.customer_type = 'new'
                        THEN mct.customer_unique_id END) AS new_customers,
    COUNT(DISTINCT CASE WHEN mct.customer_type = 'returning'
                        THEN mct.customer_unique_id END) AS returning_customers
FROM monthly_orders mo
JOIN olist_sales_data_set.olist_customers_dataset c ON mo.customer_id = c.customer_id
JOIN monthly_customer_type mct
    ON c.customer_unique_id = mct.customer_unique_id
    AND mo.year_month = mct.year_month
GROUP BY mo.year_month
ORDER BY mo.year_month;
```

**Validated Sample Output:**

| year_month | total_revenue | order_count | avg_order_value | new_customers | returning_customers |
|------------|--------------|-------------|-----------------|---------------|---------------------|
| 2016-10 | $47,542.90 | 265 | $165.08 | 262 | 0 |
| 2017-08 | $668,716.00 | 4,193 | $146.42 | 4,057 | 57 |
| 2017-11 | $1,153,520.00 | 7,289 | $151.92 | ~7,230 | ~59 |
| 2018-08 | $985,414.00 | 6,351 | $150.79 | ~6,290 | ~61 |

**Business Insight:** New customers dominate every month (returning customers are under 2%). This is a critical finding — Olist has a customer retention problem that no amount of acquisition can fix long-term.

**Looker Studio Usage:**
- `year_month` → Date dimension (set format to Year-Month)
- `total_revenue` → Line chart for revenue trend
- `new_customers` + `returning_customers` → Stacked bar chart showing acquisition mix

---

### Query 2b: Product Category Performance

**Purpose:** Powers the product performance page. Returns one row per category.

**Returns:** `product_category`, `total_revenue`, `order_count`, `avg_price`, `avg_review_score`

```sql
-- Product category performance: revenue, volume, pricing, and satisfaction
SELECT
    COALESCE(pr.product_category_name, 'Unknown') AS product_category,
    ROUND(SUM(p.payment_value)::numeric, 2)        AS total_revenue,
    COUNT(DISTINCT o.order_id)                      AS order_count,
    ROUND(AVG(oi.price)::numeric, 2)               AS avg_price,
    ROUND(AVG(r.review_score)::numeric, 2)         AS avg_review_score
FROM olist_sales_data_set.olist_orders_dataset o
JOIN olist_sales_data_set.olist_order_items_dataset oi
    ON o.order_id = oi.order_id
JOIN olist_sales_data_set.olist_products_dataset pr
    ON oi.product_id = pr.product_id
JOIN olist_sales_data_set.olist_order_payments_dataset p
    ON o.order_id = p.order_id
LEFT JOIN olist_sales_data_set.olist_order_reviews_dataset r
    ON o.order_id = r.order_id
WHERE o.order_status = 'delivered'
GROUP BY pr.product_category_name
ORDER BY total_revenue DESC;
```

**Validated Top 5 Categories:**

| product_category | total_revenue | order_count | avg_price | avg_review_score |
|-----------------|--------------|-------------|-----------|-----------------|
| cama_mesa_banho | $1,715,220 | 9,272 | $92.56 | 3.92 |
| beleza_saude | $1,622,030 | 8,646 | $130.17 | 4.19 |
| informatica_acessorios | $1,554,560 | 6,530 | $116.34 | 4.00 |
| moveis_decoracao | $1,398,320 | 6,307 | $87.11 | 3.97 |
| relogios_presentes | $1,387,830 | 5,495 | $199.87 | 4.07 |

**Note on Portuguese category names:** For a production dashboard, add a CASE statement or a lookup table to translate to English. `cama_mesa_banho` = Bed/Bath/Table; `beleza_saude` = Health & Beauty; `informatica_acessorios` = IT Accessories.

**Looker Studio Usage:**
- Treemap by `total_revenue` to show category size at a glance
- Scatter plot of `avg_price` vs `avg_review_score` (sized by `order_count`) to find price-quality sweet spots

---

### Query 2c: Seller Performance

**Purpose:** Enables seller benchmarking. Returns one row per seller.

**Returns:** `seller_id`, `seller_state`, `total_revenue`, `order_count`, `avg_delivery_days`, `avg_review_score`

```sql
-- Seller performance: revenue, volume, delivery speed, satisfaction
SELECT
    oi.seller_id,
    s.seller_state,
    ROUND(SUM(p.payment_value)::numeric, 2)                                         AS total_revenue,
    COUNT(DISTINCT o.order_id)                                                       AS order_count,
    ROUND(AVG(DATE_PART('day',
        o.order_delivered_customer_date - o.order_purchase_timestamp))::numeric, 1) AS avg_delivery_days,
    ROUND(AVG(r.review_score)::numeric, 2)                                          AS avg_review_score
FROM olist_sales_data_set.olist_orders_dataset o
JOIN olist_sales_data_set.olist_order_items_dataset oi
    ON o.order_id = oi.order_id
JOIN olist_sales_data_set.olist_sellers_dataset s
    ON oi.seller_id = s.seller_id
JOIN olist_sales_data_set.olist_order_payments_dataset p
    ON o.order_id = p.order_id
LEFT JOIN olist_sales_data_set.olist_order_reviews_dataset r
    ON o.order_id = r.order_id
WHERE o.order_status = 'delivered'
  AND o.order_delivered_customer_date IS NOT NULL
GROUP BY oi.seller_id, s.seller_state
ORDER BY total_revenue DESC;
```

**Top 5 Sellers (Validated):**

| seller_id (truncated) | seller_state | total_revenue | avg_delivery_days | avg_review_score |
|----------------------|--------------|---------------|-------------------|-----------------|
| 7c67e144... | SP | $510,059 | 22.0 | 3.40 |
| 1025f0e2... | SP | $306,416 | 11.5 | 3.89 |
| 4a3ca931... | SP | $299,515 | 13.8 | 3.83 |
| 1f50f920... | SP | $291,526 | 15.2 | 3.99 |
| 53243585... | BA | $279,843 | 12.9 | 4.12 |

**Business Insight:** The top seller (highest revenue) has the worst review score (3.40) and slowest delivery (22.0 days). The Bahia seller has better delivery and reviews despite lower volume. Use this to teach that revenue alone is not a complete performance picture.

**Looker Studio Usage:**
- Scatter plot: `avg_delivery_days` (x-axis) vs `avg_review_score` (y-axis), sized by `total_revenue`
- This creates a seller quadrant analysis: Fast+High Satisfaction vs Slow+Low Satisfaction

---

### Query 2d: Geographic Revenue

**Purpose:** Powers the map visualization showing revenue by Brazilian state.

**Returns:** `customer_state`, `total_revenue`, `order_count`, `avg_order_value`, `customer_count`

```sql
-- Geographic revenue breakdown by customer state
SELECT
    c.customer_state,
    ROUND(SUM(p.payment_value)::numeric, 2)  AS total_revenue,
    COUNT(DISTINCT o.order_id)               AS order_count,
    ROUND(AVG(p.payment_value)::numeric, 2)  AS avg_order_value,
    COUNT(DISTINCT c.customer_unique_id)     AS customer_count
FROM olist_sales_data_set.olist_orders_dataset o
JOIN olist_sales_data_set.olist_order_payments_dataset p
    ON o.order_id = p.order_id
JOIN olist_sales_data_set.olist_customers_dataset c
    ON o.customer_id = c.customer_id
WHERE o.order_status = 'delivered'
GROUP BY c.customer_state
ORDER BY total_revenue DESC;
```

**Validated Top 5 States:**

| customer_state | total_revenue | order_count | avg_order_value | customer_count |
|---------------|--------------|-------------|-----------------|----------------|
| SP | $5,770,370 | 40,500 | $136.39 | 39,155 |
| RJ | $2,055,700 | 12,350 | $158.08 | 11,917 |
| MG | $1,819,290 | 11,354 | $154.12 | 11,001 |
| RS | $861,801 | 5,345 | $155.45 | 5,168 |
| PR | $781,918 | 4,923 | $152.45 | 4,769 |

**Looker Studio Geo-Chart Setup:**
1. Add Chart → Geo Chart
2. Dimension: `customer_state`
3. Metric: `total_revenue`
4. In Chart Properties → Geo → Region: Select "Brazil" → "State"
5. Looker Studio maps two-letter state codes (SP, RJ, MG) automatically to Brazilian states

---

### Query 2e: Marketing Funnel

**Purpose:** Shows lead source conversion funnel for the marketing page.

**Returns:** `lead_source`, `lead_count`, `closed_deal_count`, `conversion_rate_pct`

```sql
-- Marketing funnel: lead volume and conversion rate by source channel
SELECT
    mql.origin                                       AS lead_source,
    COUNT(DISTINCT mql.mql_id)                      AS lead_count,
    COUNT(DISTINCT cd.mql_id)                       AS closed_deal_count,
    ROUND(
        (COUNT(DISTINCT cd.mql_id)::numeric /
         NULLIF(COUNT(DISTINCT mql.mql_id), 0)) * 100,
        2
    )                                                AS conversion_rate_pct
FROM olist_marketing_data_set.olist_marketing_qualified_leads_dataset mql
LEFT JOIN olist_marketing_data_set.olist_closed_deals_dataset cd
    ON mql.mql_id = cd.mql_id
GROUP BY mql.origin
ORDER BY lead_count DESC;
```

**Validated Full Output:**

| lead_source | lead_count | closed_deal_count | conversion_rate_pct |
|-------------|------------|-------------------|---------------------|
| organic_search | 2,296 | 113 | 4.92% |
| paid_search | 1,586 | 101 | 6.37% |
| social | 1,350 | 31 | 2.30% |
| unknown | 1,099 | 81 | 7.37% |
| direct_traffic | 499 | 31 | 6.21% |
| email | 493 | 6 | 1.22% |
| referral | 284 | 9 | 3.17% |
| display | 118 | 2 | 1.69% |

**Critical Note on LEFT JOIN:** The LEFT JOIN preserves all 8,000 MQLs regardless of whether they converted. Without it, you would only see the 380 closed deals and miss the 7,620 that did not convert — making every channel look like it has a 100% conversion rate.

---

## How to Connect a Custom SQL Query in Looker Studio

### Step-by-Step

1. Open Looker Studio → **Create** → **Report**
2. In the data source panel, click **Add data**
3. Select **PostgreSQL** (your Supabase connector)
4. Enter your Supabase connection details (host, database, credentials)
5. Instead of selecting a table, click **Custom query**
6. Paste one of the pre-aggregated queries from above
7. Click **Connect** → **Add to report**

[Screenshot: Looker Studio "Custom query" input box with a CTE query pasted in]

### Naming Your Data Sources

When you have multiple custom SQL data sources, naming them clearly prevents confusion:

| Query | Suggested Data Source Name |
|-------|---------------------------|
| Query 2a | Olist Monthly Executive KPIs |
| Query 2b | Olist Product Category Performance |
| Query 2c | Olist Seller Benchmarks |
| Query 2d | Olist Geographic Revenue |
| Query 2e | Olist Marketing Funnel |

### Setting Up an Extract (for Historical Data)

Since Olist data is historical and does not change:

1. Edit your data source (pencil icon next to data source name)
2. Click **"Extract data"** tab
3. Click **"Schedule"** to set refresh frequency
4. For Olist: weekly refresh is fine (data never changes, but weekly confirms integrity)
5. Click **"Save"**

[Screenshot: Looker Studio data source editor showing "Extract data" tab and refresh schedule settings]

---

## Connection to Final Project Requirements

Each pre-aggregated query maps directly to a Final Project evaluation criterion:

| Query | Final Project Element |
|-------|----------------------|
| 2a Executive Monthly KPIs | Calculated Fields: Period comparison (MoM) |
| 2b Product Category | Visualizations: Comparative analysis |
| 2c Seller Performance | Visualizations: Scatter/quadrant analysis |
| 2d Geographic Revenue | Visualizations: Geographic analysis |
| 2e Marketing Funnel | Calculated Fields: Marketing ROI metric |

The Financial KPI with MoM growth (query 4c from the validation report) is also a required Final Project element — it pre-calculates LAG() in SQL for the MoM growth column.

---

## Common Issues and Solutions

| Issue | Symptom | Solution |
|-------|---------|---------|
| Custom query rejected | "Syntax error" in Looker Studio | Paste query in VS Code first, verify it runs without errors |
| Data source shows zero rows | Charts all show "No Data" | Check that Supabase credentials are correct and connection is live |
| Extract not refreshing | Dashboard shows data from weeks ago | Edit data source → Extract tab → "Refresh now" |
| Column names change after refresh | Chart breaks after data source update | Avoid renaming columns in SQL after initial connection |
| Geo chart shows no map | States appear as text, not map | Change chart type to Geo Chart and set region to "Brazil > State" |

---

## Key Takeaways

### What You Learned
1. ✅ Pre-aggregated custom SQL reduces data sent to Looker Studio from thousands to hundreds of rows
2. ✅ Live connection is best for real-time operational data; Extract is best for historical or scheduled reports
3. ✅ Five validated queries cover all dashboard pages: Executive KPIs, Products, Sellers, Geography, Marketing
4. ✅ LEFT JOIN in the marketing funnel query is critical — it preserves leads that never converted
5. ✅ Custom SQL data sources are connected via the PostgreSQL connector in Looker Studio
6. ✅ Each query maps to a specific Final Project evaluation criterion

### What's Next
In the next session, we use the validated data quality queries to build a data quality monitoring system into your dashboard.

### Skills Building Progression

```
Week 16 Part 1: Query Optimization Techniques ✓
Week 16 Part 2: Pre-Aggregation Strategies (Now)
         ↓
Week 16 Part 3: Data Quality Validation
         ↓
Week 16 Part 4: Data Freshness Monitoring
```

---

## Quick Reference Card

### Extract vs Live Decision Tree

```
Is data real-time critical (changes every hour)?
├─ YES → Use Live connection
└─ NO → Does data refresh daily or weekly?
         ├─ DAILY → Live connection or Extract with daily refresh
         └─ WEEKLY/MONTHLY → Extract (fastest dashboard load)

Is data historical (does not change)?
└─ YES → Extract with infrequent refresh (Olist = weekly is fine)
```

### Custom SQL Connection Steps

```
Create Report → Add Data → PostgreSQL
→ Enter Supabase credentials
→ Select "Custom query"
→ Paste pre-aggregated SQL
→ Click Connect
→ Name data source clearly
```

---

## Questions to Test Your Understanding

1. What is the main advantage of connecting Looker Studio to a pre-aggregated SQL query rather than a raw table?
2. The marketing funnel query uses a LEFT JOIN instead of an INNER JOIN. What data would be lost if you switched to an INNER JOIN?
3. Looking at the seller performance data: seller 7c67e144 has the highest revenue but the lowest review score. What business decision does this suggest?
4. Why does the geographic query use `customer_unique_id` for `customer_count` but `order_id` for `order_count`?
5. You connect your executive KPI query to Looker Studio and the total_revenue for November 2017 shows $1,153,520. Is this correct? How would you verify?

**Answers at the end of lecture notes**

---

## Answers to Questions

1. **Pre-aggregation advantage:** Looker Studio receives a compact summary (26 monthly rows) instead of 99,441+ raw rows. Charts load faster because no aggregation is needed at render time. The database does the heavy lifting once, not on every user interaction.
2. **LEFT vs INNER JOIN impact:** An INNER JOIN would only return the 380 MQLs that became closed deals, discarding the 7,620 that did not convert. Conversion rate would show 100% for every channel, which is meaningless. The LEFT JOIN correctly preserves all 8,000 MQLs.
3. **Business decision:** Review seller 7c67e144's practices. High revenue with poor satisfaction (3.40 stars) suggests they sell a lot but deliver poor experiences. Options: (a) impose a performance improvement plan with SLA penalties, (b) investigate root cause (slow delivery at 22 days), (c) consider de-listing if no improvement.
4. **COUNT DISTINCT logic:** `customer_unique_id` deduplicates returning customers (a customer who ordered 3 times should count as 1 customer, not 3). `order_id` is already unique per order — no deduplication needed, though `COUNT(DISTINCT order_id)` and `COUNT(order_id)` produce the same result for this reason.
5. **Verification:** Yes, $1,153,520 for November 2017 is the validated correct figure from the validation report. To verify: run the executive summary query directly in VS Code, filter to year_month = '2017-11', and confirm the total_revenue column matches.

---

**Next Lecture:** 03_data_quality_validation.md
