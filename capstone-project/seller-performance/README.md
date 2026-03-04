# Seller Performance Optimization — Capstone Project

## A. Project Title & Overview

**Title:** Olist Marketplace Seller Performance Analytics Dashboard

**Overview:** Build a comprehensive Google Looker Studio dashboard that analyzes the performance of 3,095 sellers on the Olist e-commerce marketplace in Brazil. Using SQL to extract and transform data from the `olist_sales_data_set` schema (112,650 order items, 99,441 orders, 98,410 reviews across Sep 2016 – Oct 2018), compute seller-level KPIs spanning revenue, delivery speed, customer satisfaction, and product mix, then visualize these metrics in an interactive multi-page dashboard designed for a marketplace operations team.

**Duration:** 4 weeks
**Tool:** Google Looker Studio
**Deliverables:** Interactive Dashboard + Written Report (PDF) + Presentation Deck

---

## B. Business Questions

The dashboard should answer these seven questions:

1. **Who are the top-performing sellers by revenue, and how concentrated is marketplace revenue?** (Pareto analysis: top 10% of sellers generate ~67% of revenue)
2. **Which sellers consistently deliver on time, and which are chronic late-shippers?** (On-time delivery rate averages 92% but ranges from 33% to 100%)
3. **How does seller processing speed (order approval to carrier handoff) vary, and what is its impact on customer satisfaction?** (Median 52 hours, P90 at 150 hours)
4. **What is the relationship between a seller's average review score and their revenue volume?** (Average review 4.13/5.0 across 1,337 sellers with 10+ reviews)
5. **Which product categories have the most competitive seller landscapes, and where are opportunities?** (Health & Beauty has 479 sellers, while high-revenue Bed/Bath/Table has only 189)
6. **How has the seller ecosystem grown over time, and is revenue per seller increasing or declining?** (Active sellers grew from 219 to 1,261 monthly, but rev/seller dropped from $1,054 peak to $665)
7. **What distinguishes a "five-star" seller from an underperformer, and can we build a composite seller scorecard?**

---

## C. KPI Catalog

### KPI 1: Total Seller Revenue (GMV)

**Business meaning:** Total product price billed through each seller's orders (excluding freight). Primary measure of marketplace contribution.

**Validated SQL:**
```sql
SELECT
  oi.seller_id,
  COUNT(DISTINCT oi.order_id) AS total_orders,
  ROUND(SUM(oi.price)::numeric, 2) AS total_revenue,
  ROUND(SUM(oi.freight_value)::numeric, 2) AS total_freight,
  ROUND((SUM(oi.price) + SUM(oi.freight_value))::numeric, 2) AS total_gmv
FROM olist_sales_data_set.olist_order_items_dataset oi
JOIN olist_sales_data_set.olist_orders_dataset o ON oi.order_id = o.order_id
WHERE o.order_status = 'delivered'
GROUP BY oi.seller_id
ORDER BY total_revenue DESC;
```

**Sample result:** Top seller: $226,989 revenue across 1,124 orders. Top 10 sellers range $131K–$227K.

**Looker Studio notes:** Pre-compute in SQL data source. Use scoreboard for total, bar chart for top-N sellers.

---

### KPI 2: Average Order Value (AOV) per Seller

**Business meaning:** Average price per item a seller transacts. Indicates premium vs budget product segments.

**Validated SQL:**
```sql
SELECT
  oi.seller_id,
  ROUND(AVG(oi.price)::numeric, 2) AS avg_order_value,
  COUNT(DISTINCT oi.order_id) AS order_count
FROM olist_sales_data_set.olist_order_items_dataset oi
JOIN olist_sales_data_set.olist_orders_dataset o ON oi.order_id = o.order_id
WHERE o.order_status = 'delivered'
GROUP BY oi.seller_id;
```

**Sample result:** P25=$52.31, Median=$95.57, P75=$171.73, Max=$6,735. Overall avg AOV=$177.65.

**Looker Studio notes:** Display as histogram. Can also use calculated field: `SUM(price) / COUNT_DISTINCT(order_id)`.

---

### KPI 3: Average Customer Review Score

**Business meaning:** Mean review rating (1-5 stars) received by a seller. Core quality signal.

**Validated SQL:**
```sql
SELECT
  oi.seller_id,
  ROUND(AVG(r.review_score)::numeric, 2) AS avg_review_score,
  COUNT(r.review_id) AS review_count
FROM olist_sales_data_set.olist_order_items_dataset oi
JOIN olist_sales_data_set.olist_orders_dataset o ON oi.order_id = o.order_id
JOIN olist_sales_data_set.olist_order_reviews_dataset r ON o.order_id = r.order_id
WHERE o.order_status = 'delivered'
GROUP BY oi.seller_id
HAVING COUNT(r.review_id) >= 10;
```

**Sample result:** 1,337 sellers with 10+ reviews. Average=4.13, worst=1.40, best=5.00. Distribution: 59.3% are 5-star, 9.7% are 1-star.

**Looker Studio notes:** Gauge chart for marketplace average, scatter plot (score vs revenue) for individual sellers.

---

### KPI 4: On-Time Delivery Rate

**Business meaning:** Percentage of orders where `delivered_date <= estimated_date`. Measures logistics reliability.

**Validated SQL:**
```sql
SELECT
  oi.seller_id,
  COUNT(DISTINCT o.order_id) AS total_delivered,
  COUNT(DISTINCT CASE
    WHEN o.order_delivered_customer_date <= o.order_estimated_delivery_date
    THEN o.order_id END) AS on_time_count,
  ROUND(
    COUNT(DISTINCT CASE
      WHEN o.order_delivered_customer_date <= o.order_estimated_delivery_date
      THEN o.order_id END)::numeric
    / COUNT(DISTINCT o.order_id) * 100, 1
  ) AS on_time_pct
FROM olist_sales_data_set.olist_order_items_dataset oi
JOIN olist_sales_data_set.olist_orders_dataset o ON oi.order_id = o.order_id
WHERE o.order_status = 'delivered'
  AND o.order_delivered_customer_date IS NOT NULL
  AND o.order_estimated_delivery_date IS NOT NULL
GROUP BY oi.seller_id
HAVING COUNT(DISTINCT o.order_id) >= 5;
```

**Sample result:** 1,766 sellers with 5+ orders. Average on-time rate=92.0%, min=33.3%, max=100.0%.

**Looker Studio notes:** Scoreboard (marketplace avg), histogram (distribution), conditional-color table (green/yellow/red at 95%/85%/below).

---

### KPI 5: Seller Processing Speed (Hours)

**Business meaning:** Average hours between order approval and carrier handoff. The only delivery stage sellers directly control.

**Validated SQL:**
```sql
SELECT
  oi.seller_id,
  ROUND(AVG(EXTRACT(EPOCH FROM (o.order_delivered_carrier_date - o.order_approved_at)) / 3600)::numeric, 1) AS avg_processing_hrs,
  COUNT(DISTINCT o.order_id) AS order_count
FROM olist_sales_data_set.olist_order_items_dataset oi
JOIN olist_sales_data_set.olist_orders_dataset o ON oi.order_id = o.order_id
WHERE o.order_status = 'delivered'
  AND o.order_delivered_carrier_date IS NOT NULL
  AND o.order_approved_at IS NOT NULL
GROUP BY oi.seller_id;
```

**Sample result:** Average=77.8 hrs (~3.2 days), Median=52.1 hrs (~2.2 days), P90=149.9 hrs (~6.2 days).

**Looker Studio notes:** Must pre-compute in SQL (Looker can't do EXTRACT/EPOCH). Display as histogram + seller scorecard column.

---

### KPI 6: Freight-to-Price Ratio

**Business meaning:** Proportion of freight cost relative to product price. High ratios indicate margin risk.

**Validated SQL:**
```sql
SELECT
  oi.seller_id,
  ROUND((SUM(oi.freight_value) / NULLIF(SUM(oi.price), 0))::numeric, 3) AS freight_ratio
FROM olist_sales_data_set.olist_order_items_dataset oi
JOIN olist_sales_data_set.olist_orders_dataset o ON oi.order_id = o.order_id
WHERE o.order_status = 'delivered'
GROUP BY oi.seller_id
HAVING SUM(oi.price) > 0;
```

**Sample result:** Average=0.264 (26.4%), Median=0.205, Max=3.535.

**Looker Studio notes:** Can compute as calculated field: `SUM(freight_value) / SUM(price)`. Histogram + flag outliers >0.50.

---

### KPI 7: Product Category Diversification

**Business meaning:** Number of distinct categories per seller. Specialists (1 category) vs diversified sellers.

**Validated SQL:**
```sql
SELECT
  oi.seller_id,
  COUNT(DISTINCT p.product_category_name) AS category_count
FROM olist_sales_data_set.olist_order_items_dataset oi
JOIN olist_sales_data_set.olist_products_dataset p ON oi.product_id = p.product_id
JOIN olist_sales_data_set.olist_orders_dataset o ON oi.order_id = o.order_id
WHERE o.order_status = 'delivered'
GROUP BY oi.seller_id;
```

**Sample result:** Average=2.1, Median=1 (most are specialists), Max=27. Top revenue seller operates in 10 categories.

**Looker Studio notes:** Bar chart (distribution) + detail table column. Join `product_category_name_translation` for English names.

---

### KPI 8: Monthly Active Sellers & Revenue per Seller Trend

**Business meaning:** Tracks marketplace growth and health. Declining rev/seller signals saturation.

**Validated SQL:**
```sql
SELECT
  TO_CHAR(o.order_purchase_timestamp, 'YYYY-MM') AS month,
  COUNT(DISTINCT oi.seller_id) AS active_sellers,
  ROUND(SUM(oi.price)::numeric, 0) AS monthly_revenue,
  ROUND((SUM(oi.price) / COUNT(DISTINCT oi.seller_id))::numeric, 0) AS rev_per_seller
FROM olist_sales_data_set.olist_order_items_dataset oi
JOIN olist_sales_data_set.olist_orders_dataset o ON oi.order_id = o.order_id
WHERE o.order_status = 'delivered'
  AND o.order_purchase_timestamp >= '2017-01-01'
GROUP BY TO_CHAR(o.order_purchase_timestamp, 'YYYY-MM')
ORDER BY month;
```

**Sample result:** Jan 2017: 219 sellers, $510/seller. Peak Nov 2017: 937 sellers, $1,054/seller. Aug 2018: 1,261 sellers, $665/seller. Revenue per seller declined 37% from peak.

**Looker Studio notes:** Dual-axis time series (bar=seller count, line=rev/seller).

---

### KPI 9: Revenue Concentration (Pareto Distribution)

**Business meaning:** How unevenly revenue is distributed. Critical for marketplace risk assessment.

**Validated SQL:**
```sql
WITH seller_rev AS (
  SELECT oi.seller_id, SUM(oi.price) AS revenue
  FROM olist_sales_data_set.olist_order_items_dataset oi
  JOIN olist_sales_data_set.olist_orders_dataset o ON oi.order_id = o.order_id
  WHERE o.order_status = 'delivered'
  GROUP BY oi.seller_id
),
ranked AS (
  SELECT seller_id, revenue,
    SUM(revenue) OVER (ORDER BY revenue DESC) AS cumulative_rev,
    SUM(revenue) OVER () AS total_rev,
    ROW_NUMBER() OVER (ORDER BY revenue DESC) AS rn,
    COUNT(*) OVER () AS total_sellers
  FROM seller_rev
)
SELECT
  rn AS seller_rank,
  ROUND((rn::numeric / total_sellers * 100), 1) AS pct_of_sellers,
  ROUND((cumulative_rev / total_rev * 100)::numeric, 1) AS cumulative_rev_pct
FROM ranked
WHERE rn IN (1, 10, 50, 100, 297, 594, 1485)
ORDER BY rn;
```

**Sample result:**

| % of Sellers | Cumulative Revenue % |
|---|---|
| Top 10 (0.3%) | 13.3% |
| Top 100 (3.4%) | 45.5% |
| Top 10% (297) | 67.1% |
| Top 20% (594) | 82.3% |
| Top 50% (1,485) | 96.7% |

**Looker Studio notes:** Pre-compute cumulative %. Display as Pareto curve (line chart).

---

### KPI 10: Delivery Time Breakdown (Processing vs Transit)

**Business meaning:** Decomposes delivery into seller-controlled processing time vs carrier transit time.

**Validated SQL:**
```sql
SELECT
  oi.seller_id,
  ROUND(AVG(EXTRACT(EPOCH FROM (o.order_delivered_carrier_date - o.order_approved_at)) / 86400)::numeric, 1) AS avg_processing_days,
  ROUND(AVG(EXTRACT(EPOCH FROM (o.order_delivered_customer_date - o.order_delivered_carrier_date)) / 86400)::numeric, 1) AS avg_transit_days,
  ROUND(AVG(EXTRACT(EPOCH FROM (o.order_delivered_customer_date - o.order_purchase_timestamp)) / 86400)::numeric, 1) AS avg_total_days
FROM olist_sales_data_set.olist_order_items_dataset oi
JOIN olist_sales_data_set.olist_orders_dataset o ON oi.order_id = o.order_id
WHERE o.order_status = 'delivered'
  AND o.order_delivered_carrier_date IS NOT NULL
  AND o.order_delivered_customer_date IS NOT NULL
  AND o.order_approved_at IS NOT NULL
GROUP BY oi.seller_id;
```

**Sample result:** Processing=2.8 days, Transit=9.2 days, Total=12.5 days. Sellers control ~22% of total delivery time.

**Looker Studio notes:** Stacked bar chart (processing vs transit per seller tier).

---

### KPI 11: Repeat Customer Rate per Seller

**Business meaning:** Percentage of customers who purchased more than once on the platform (uses `customer_unique_id`).

**Validated SQL:**
```sql
SELECT
  oi.seller_id,
  COUNT(DISTINCT c.customer_unique_id) AS unique_customers,
  COUNT(DISTINCT CASE WHEN cust_orders.order_count > 1 THEN c.customer_unique_id END) AS repeat_customers,
  ROUND(
    COUNT(DISTINCT CASE WHEN cust_orders.order_count > 1 THEN c.customer_unique_id END)::numeric
    / NULLIF(COUNT(DISTINCT c.customer_unique_id), 0) * 100, 1
  ) AS repeat_pct
FROM olist_sales_data_set.olist_order_items_dataset oi
JOIN olist_sales_data_set.olist_orders_dataset o ON oi.order_id = o.order_id
JOIN olist_sales_data_set.olist_customers_dataset c ON o.customer_id = c.customer_id
JOIN (
  SELECT c2.customer_unique_id, COUNT(DISTINCT o2.order_id) AS order_count
  FROM olist_sales_data_set.olist_customers_dataset c2
  JOIN olist_sales_data_set.olist_orders_dataset o2 ON c2.customer_id = o2.customer_id
  WHERE o2.order_status = 'delivered'
  GROUP BY c2.customer_unique_id
) cust_orders ON c.customer_unique_id = cust_orders.customer_unique_id
WHERE o.order_status = 'delivered'
GROUP BY oi.seller_id
HAVING COUNT(DISTINCT c.customer_unique_id) >= 10;
```

**Sample result:** 918 sellers have repeat customers. Average repeat rate=7.2%. Note: this is platform-level repeat, not seller-specific.

**Looker Studio notes:** Detail table column. Document the limitation clearly.

---

### KPI 12: Seller Geographic Performance (Revenue by State)

**Business meaning:** Revenue by seller location. Identifies geographic clusters and underserved regions.

**Validated SQL:**
```sql
SELECT
  s.seller_state,
  COUNT(DISTINCT s.seller_id) AS seller_count,
  ROUND(SUM(oi.price)::numeric, 0) AS total_revenue,
  ROUND((SUM(oi.price) / COUNT(DISTINCT s.seller_id))::numeric, 0) AS rev_per_seller,
  ROUND(AVG(r.review_score)::numeric, 2) AS avg_review
FROM olist_sales_data_set.olist_sellers_dataset s
JOIN olist_sales_data_set.olist_order_items_dataset oi ON s.seller_id = oi.seller_id
JOIN olist_sales_data_set.olist_orders_dataset o ON oi.order_id = o.order_id
LEFT JOIN olist_sales_data_set.olist_order_reviews_dataset r ON o.order_id = r.order_id
WHERE o.order_status = 'delivered'
GROUP BY s.seller_state
ORDER BY total_revenue DESC;
```

**Sample result:** SP (Sao Paulo) dominates with 1,849 sellers. Top: SP, PR (349), MG (244), SC (190), RJ (171). 23 states total.

**Looker Studio notes:** Geo chart (map) with `seller_state` dimension. Brazilian 2-letter state codes.

---

## D. Suggested Dashboard Pages

### Page 1: Marketplace Overview (Executive Summary)
- Scorecards: Total sellers (3,095), Delivered revenue (~$13.5M), Avg review (4.13), On-time rate (92%)
- Time series: Monthly revenue + active seller count (dual-axis)
- Revenue per seller trend line (saturation signal)
- Pareto chart: Revenue concentration curve
- Date range filter control

### Page 2: Individual Seller Scorecard
- Interactive data table: Seller ID, State, Orders, Revenue, AOV, Review Score, On-Time %, Processing Hours, Freight Ratio, Category Count
- Sortable, filterable by state, min orders, review score range
- Conditional formatting (color-coded cells)
- Search bar for seller ID lookup

### Page 3: Delivery & Quality Analysis
- Stacked bar: Processing days vs transit days by seller tier
- Scatter plot: Processing speed (x) vs review score (y), sized by volume
- Histogram: On-time delivery rate distribution
- Review score distribution (1-5 stars) as stacked bar
- Filters: State, category

### Page 4: Product & Category Intelligence
- Horizontal bar: Top 15 categories by seller count and revenue
- Bubble chart: Category revenue (x) vs seller count (y), sized by avg review
- Pie/donut: Single-category vs multi-category seller distribution
- Table: Top categories with revenue, seller count, avg price, avg review

### Page 5: Geographic Analysis
- Brazil state-level choropleth map (revenue or seller count)
- Bar chart: Top 10 states by revenue per seller
- Comparison table: State-level KPIs
- Insight callout: SP concentration risk (60% of sellers in Sao Paulo)

---

## E. Weekly Milestones

### Week 1: Data Exploration & SQL Query Development
- Explore all relevant tables (sellers, order_items, orders, reviews, products, translations)
- Understand join relationships
- Write and test all 12 KPI queries against Supabase
- Create master SQL view/query for flat seller-level dataset
- Document data limitations and decisions
- **Deliverable:** SQL query document with validated queries + data dictionary

### Week 2: Dashboard Build (Core Pages)
- Connect Looker Studio to data source
- Build Page 1 (Executive Overview): scorecards, time series, Pareto chart
- Build Page 2 (Seller Scorecard): interactive table with conditional formatting
- Build Page 3 (Delivery & Quality): scatter plots, histograms, stacked bars
- Apply consistent color theme and typography
- **Deliverable:** Working 3-page dashboard with functional interactivity

### Week 3: Advanced Features, Interactivity & Polish
- Build Page 4 (Product Categories)
- Build Page 5 (Geographic)
- Implement cross-page filter controls
- Add calculated fields in Looker Studio
- Design polish: headers, legends, tooltips, annotations
- Peer review and iterate
- **Deliverable:** Complete 5-page dashboard with cross-filtering and polish

### Week 4: Report Writing, Presentation & Final Review
- Write 3-5 page executive report (methodology, findings, recommendations, limitations)
- Create 10-slide presentation deck
- Final dashboard QA: all filters, numbers, charts verified
- Practice presentation (5-minute limit)
- **Deliverable:** Final dashboard link, report (PDF), presentation deck, SQL query file

---

## F. Data Limitations & Gotchas

1. **NULL delivery dates:** ~2,965 orders (~3%) have NULL delivery dates. MUST exclude from delivery calculations.
2. **Delivered-only filter:** Always use `WHERE order_status = 'delivered'` for revenue and delivery metrics.
3. **One order, multiple sellers:** An order can have items from multiple sellers. Use `order_items` as grain, not `orders`.
4. **Review attribution:** Reviews are per ORDER, not per seller. If an order spans two sellers, both get the same score.
5. **Seller IDs are hashed:** Anonymized hashes — use seller_city + truncated ID for display labels.
6. **Repeat customer metric is platform-level:** `customer_unique_id` tracks platform repeat, not seller-specific repeat.
7. **No cost/margin data:** No seller costs, commissions, or profit margins. Revenue is gross only.
8. **Geographic limitation:** State-level analysis only. Geolocation table has duplicate zip codes.
9. **Category translation:** Categories are in Portuguese by default. Join with `product_category_name_translation`. ~247 sellers have NULL categories.
10. **Time period bias:** Early sellers (2016-17) have higher cumulative revenue than late joiners. Normalize by active months when comparing.
11. **Revenue per seller decline:** Rev/seller dropped 37% from Nov 2017 peak — this is a real marketplace saturation signal, not a data error.

---

## G. Grading Rubric

### A-Level (90-100%): Exceptional
- **SQL (25%):** All 12 KPIs correct, clean CTEs/window functions, handles NULLs/edge cases
- **Dashboard (30%):** All 5 pages, professional design, consistent theme, cross-filtering flawless
- **Analysis (25%):** Identifies Pareto concentration, rev/seller decline, processing-speed/review relationship, plus 2+ original insights
- **Report & Presentation (20%):** Structured report with actionable recommendations, confident 5-min presentation

### B-Level (75-89%): Proficient
- **SQL:** 8-10 KPIs correct, minor NULL/filter issues
- **Dashboard:** 4-5 pages, mostly clean, filters mostly work
- **Analysis:** Identifies main patterns but may miss saturation signal
- **Report:** Adequate, clear but lacks polish

### C-Level (60-74%): Developing
- **SQL:** 5-7 KPIs, some errors (missing delivered filter, NULLs)
- **Dashboard:** 3-4 pages, basic charts, inconsistent formatting
- **Analysis:** Describes data without interpreting WHY
- **Report:** Brief, summarizes charts without deeper analysis

### Below C (Below 60%): Incomplete
- Fewer than 5 KPIs, significant SQL errors, 2 or fewer pages, no report

### Bonus Points (up to 5%)
- Seller tier classification (Gold/Silver/Bronze composite score)
- Time-series cohort analysis (by seller join month)
- Seller comparison feature (select 2-3 sellers side-by-side)
- Advanced Looker calculated fields (PERCENTILE, CASE WHEN)
- Data quality appendix documenting NULL counts and exclusions
