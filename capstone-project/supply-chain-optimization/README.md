# Supply Chain & Logistics Optimization — Phase 2 Capstone Project

## Google Looker Studio Dashboard Project Using the Olist E-Commerce Dataset

---

## A. Project Title & Overview

**Title:** Olist Supply Chain Performance Intelligence Dashboard

**Overview:** Students will build a comprehensive Google Looker Studio dashboard that analyzes the end-to-end delivery pipeline of Olist, a Brazilian e-commerce marketplace. Using real transactional data covering 96,478 delivered orders from September 2016 to October 2018, students will measure delivery speed, on-time performance, freight cost efficiency, seller shipping compliance, and geographic logistics patterns. The final deliverable is a multi-page interactive dashboard accompanied by a written business report and a stakeholder presentation with actionable recommendations for reducing late deliveries and optimizing freight costs.

**Primary Deliverables:**
1. Google Looker Studio dashboard (3-5 pages, interactive filters)
2. Written business report (8-12 pages)
3. Stakeholder presentation (10-15 slides, 10-minute delivery)

---

## B. Business Questions

The dashboard should answer the following core business questions:

1. **How fast are we delivering?** What is the average order-to-delivery time, and how does it break down across processing, carrier handoff, and transit stages?

2. **Are we meeting delivery promises?** What percentage of orders arrive on or before the estimated delivery date, and is that rate improving or declining over time?

3. **Where are deliveries slowest and most unreliable?** Which customer states or seller-to-customer routes have the highest late delivery rates and longest transit times?

4. **How much are we spending on freight, and is it justified?** What is the average freight cost as a percentage of order value, and how does freight vary by product category, weight, and shipping distance (seller state vs customer state)?

5. **Are sellers shipping on time?** What percentage of items are handed to carriers before the shipping limit deadline, and which sellers consistently miss their handoff windows?

6. **What product characteristics drive logistics costs?** How do product weight, dimensions, and category correlate with freight costs and delivery times?

7. **Are there seasonal or trend-based patterns in delivery performance?** Do late delivery rates spike during certain months (e.g., Black Friday in November, holiday season), and is overall logistics performance improving year-over-year?

---

## C. KPI Catalog

### KPI 1: Average Delivery Time (Days)

**Business Meaning:** The average number of calendar days from when a customer places an order to when it arrives. This is the single most important customer experience metric for logistics.

**Validated SQL Query:**
```sql
SELECT
  ROUND(AVG(
    EXTRACT(EPOCH FROM (order_delivered_customer_date - order_purchase_timestamp)) / 86400
  )::numeric, 1) AS avg_delivery_days,
  ROUND((PERCENTILE_CONT(0.5) WITHIN GROUP (
    ORDER BY EXTRACT(EPOCH FROM (order_delivered_customer_date - order_purchase_timestamp)) / 86400
  ))::numeric, 1) AS median_delivery_days
FROM olist_sales_data_set.olist_orders_dataset
WHERE order_status = 'delivered'
  AND order_delivered_customer_date IS NOT NULL;
```

**Verified Result:** Average = 12.6 days, Median = 10.2 days. Range: 0.5 to 209.6 days.

**Looker Studio Implementation:** Create as a SQL data source calculated column (`DATE_DIFF(order_delivered_customer_date, order_purchase_timestamp)`) or pre-compute in a custom SQL query. Display as a scorecard with sparkline trend.

---

### KPI 2: On-Time Delivery Rate (%)

**Business Meaning:** The percentage of delivered orders that arrived on or before the estimated delivery date shown to the customer. This measures whether Olist keeps its delivery promises.

**Validated SQL Query:**
```sql
SELECT
  COUNT(*) AS total_delivered,
  COUNT(*) FILTER (
    WHERE order_delivered_customer_date <= order_estimated_delivery_date
  ) AS on_time,
  ROUND(100.0 * COUNT(*) FILTER (
    WHERE order_delivered_customer_date <= order_estimated_delivery_date
  ) / COUNT(*), 2) AS on_time_pct
FROM olist_sales_data_set.olist_orders_dataset
WHERE order_status = 'delivered'
  AND order_delivered_customer_date IS NOT NULL
  AND order_estimated_delivery_date IS NOT NULL;
```

**Verified Result:** 91.89% on-time (88,644 of 96,470). 8.11% late (7,826 orders).

**Looker Studio Implementation:** Calculated field using `CASE WHEN order_delivered_customer_date <= order_estimated_delivery_date THEN 1 ELSE 0 END`, then use `AVG()` formatted as percentage. Display as a gauge or scorecard.

---

### KPI 3: Average Delivery Delay (Late Orders Only)

**Business Meaning:** For orders that missed the estimated delivery date, how many days late were they on average? This quantifies the severity of delivery failures, not just their frequency.

**Validated SQL Query:**
```sql
SELECT
  COUNT(*) AS late_orders,
  ROUND(AVG(
    EXTRACT(EPOCH FROM (order_delivered_customer_date - order_estimated_delivery_date)) / 86400
  )::numeric, 1) AS avg_delay_days,
  ROUND(MAX(
    EXTRACT(EPOCH FROM (order_delivered_customer_date - order_estimated_delivery_date)) / 86400
  )::numeric, 1) AS max_delay_days
FROM olist_sales_data_set.olist_orders_dataset
WHERE order_status = 'delivered'
  AND order_delivered_customer_date IS NOT NULL
  AND order_estimated_delivery_date IS NOT NULL
  AND order_delivered_customer_date > order_estimated_delivery_date;
```

**Verified Result:** 7,826 late orders, average delay = 9.6 days, worst case = 189 days late.

**Looker Studio Implementation:** Pre-compute in SQL source. Filter to late orders only. Display as scorecard + histogram of delay distribution.

---

### KPI 4: Order Processing Pipeline Breakdown

**Business Meaning:** Decomposes the total delivery time into three stages: (1) approval time (purchase to approval), (2) seller handoff time (approval to carrier pickup), and (3) transit time (carrier to customer doorstep). Identifies which stage is the bottleneck.

**Validated SQL Query:**
```sql
SELECT
  ROUND(AVG(
    EXTRACT(EPOCH FROM (order_approved_at - order_purchase_timestamp)) / 3600
  )::numeric, 1) AS avg_approval_hours,
  ROUND(AVG(
    EXTRACT(EPOCH FROM (order_delivered_carrier_date - order_approved_at)) / 86400
  )::numeric, 1) AS avg_seller_handoff_days,
  ROUND(AVG(
    EXTRACT(EPOCH FROM (order_delivered_customer_date - order_delivered_carrier_date)) / 86400
  )::numeric, 1) AS avg_transit_days
FROM olist_sales_data_set.olist_orders_dataset
WHERE order_status = 'delivered'
  AND order_delivered_customer_date IS NOT NULL
  AND order_delivered_carrier_date IS NOT NULL
  AND order_approved_at IS NOT NULL;
```

**Verified Result:** Approval = 10.3 hours, Seller handoff = 2.8 days, Transit = 9.3 days. Transit is the dominant bottleneck (73% of total delivery time).

**Looker Studio Implementation:** Three separate calculated fields for each stage. Display as a stacked bar chart or waterfall chart showing the pipeline breakdown.

---

### KPI 5: Freight Cost Metrics

**Business Meaning:** Average shipping cost per item and freight as a percentage of total order value. High freight ratios indicate inefficient logistics pricing or long-distance shipping.

**Validated SQL Query:**
```sql
SELECT
  ROUND(AVG(freight_value)::numeric, 2) AS avg_freight,
  ROUND(PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY freight_value)::numeric, 2) AS median_freight,
  ROUND(SUM(freight_value)::numeric, 2) AS total_freight_revenue,
  ROUND(AVG(freight_value / NULLIF(price + freight_value, 0) * 100)::numeric, 1) AS avg_freight_pct
FROM olist_sales_data_set.olist_order_items_dataset;
```

**Verified Result:** Average freight = R$19.99, Median = R$16.26, Total freight collected = R$2,251,970. Freight represents 21.3% of total order value on average.

**Looker Studio Implementation:** Calculated field `freight_value / (price + freight_value)` for percentage. Display as scorecard + bar chart by product category.

---

### KPI 6: Late Delivery Rate by Customer State

**Business Meaning:** Geographic breakdown of delivery reliability. Identifies which Brazilian states experience the worst delivery performance, enabling targeted logistics improvements.

**Validated SQL Query:**
```sql
SELECT
  c.customer_state,
  COUNT(*) AS total_delivered,
  ROUND(100.0 * COUNT(*) FILTER (
    WHERE o.order_delivered_customer_date > o.order_estimated_delivery_date
  ) / COUNT(*), 2) AS late_pct,
  ROUND(AVG(
    EXTRACT(EPOCH FROM (o.order_delivered_customer_date - o.order_purchase_timestamp)) / 86400
  )::numeric, 1) AS avg_delivery_days
FROM olist_sales_data_set.olist_orders_dataset o
JOIN olist_sales_data_set.olist_customers_dataset c
  ON o.customer_id = c.customer_id
WHERE o.order_status = 'delivered'
  AND o.order_delivered_customer_date IS NOT NULL
  AND o.order_estimated_delivery_date IS NOT NULL
GROUP BY c.customer_state
ORDER BY total_delivered DESC;
```

**Verified Result (Top States):**
| State | Orders | Late % | Avg Days |
|-------|--------|--------|----------|
| SP    | 40,494 | 5.89%  | 8.8      |
| RJ    | 12,350 | 13.47% | 15.3     |
| MG    | 11,354 | 5.61%  | 12.0     |
| BA    | 3,256  | 14.04% | 19.3     |
| ES    | 1,995  | 12.23% | 15.8     |

**Key Insight:** Rio de Janeiro (RJ) and Bahia (BA) have late rates 2-3x the national average despite high order volumes. Sao Paulo (SP) is best-served at 5.89% late.

**Looker Studio Implementation:** Use as SQL data source grouped by state. Display as a geo map (Brazil state boundaries) colored by late %, with a sortable table alongside.

---

### KPI 7: Freight Cost by Seller Origin State

**Business Meaning:** Shows which seller locations have the highest average shipping costs. Combined with delivery time data, reveals the cost-efficiency tradeoff of seller geographic concentration.

**Validated SQL Query:**
```sql
SELECT
  s.seller_state,
  COUNT(DISTINCT s.seller_id) AS num_sellers,
  COUNT(*) AS total_items,
  ROUND(AVG(oi.freight_value)::numeric, 2) AS avg_freight,
  ROUND(SUM(oi.freight_value)::numeric, 2) AS total_freight
FROM olist_sales_data_set.olist_order_items_dataset oi
JOIN olist_sales_data_set.olist_sellers_dataset s
  ON oi.seller_id = s.seller_id
GROUP BY s.seller_state
ORDER BY total_items DESC;
```

**Verified Result:** SP sellers (1,849 sellers, 80K items) average R$18.45 freight. BA sellers average R$30.64, SC sellers R$26.15. SP dominance (71% of items) keeps overall freight low.

**Looker Studio Implementation:** SQL source grouped by seller state. Bar chart with avg freight + bubble chart (size = volume, color = avg freight).

---

### KPI 8: Delivery Estimate Accuracy (Buffer Analysis)

**Business Meaning:** How much padding does Olist add to delivery estimates? A large buffer means customers see inflated estimates but receive orders "early." Measures whether the estimate algorithm is well-calibrated or overly conservative.

**Validated SQL Query:**
```sql
SELECT
  ROUND(AVG(
    EXTRACT(EPOCH FROM (order_estimated_delivery_date - order_delivered_customer_date)) / 86400
  )::numeric, 1) AS avg_buffer_days,
  ROUND((PERCENTILE_CONT(0.5) WITHIN GROUP (
    ORDER BY EXTRACT(EPOCH FROM (order_estimated_delivery_date - order_delivered_customer_date)) / 86400
  ))::numeric, 1) AS median_buffer_days
FROM olist_sales_data_set.olist_orders_dataset
WHERE order_status = 'delivered'
  AND order_delivered_customer_date IS NOT NULL
  AND order_estimated_delivery_date IS NOT NULL;
```

**Verified Result:** Average buffer = 11.2 days early, Median = 11.9 days early. P25 = 6.4 days, P75 = 16.2 days. Estimates are very conservative -- most orders arrive nearly 2 weeks ahead of the promised date.

**Looker Studio Implementation:** Calculated field `DATE_DIFF(order_estimated_delivery_date, order_delivered_customer_date)`. Display as histogram + scorecard.

---

### KPI 9: Seller Shipping Limit Compliance Rate

**Business Meaning:** Percentage of items where the seller handed the package to the carrier before the contractual shipping limit deadline. Low compliance means sellers are a bottleneck in the supply chain.

**Validated SQL Query:**
```sql
SELECT
  COUNT(*) AS total_items,
  COUNT(*) FILTER (
    WHERE o.order_delivered_carrier_date <= oi.shipping_limit_date
  ) AS on_time_handoff,
  ROUND(100.0 * COUNT(*) FILTER (
    WHERE o.order_delivered_carrier_date <= oi.shipping_limit_date
  ) / NULLIF(COUNT(*) FILTER (WHERE o.order_delivered_carrier_date IS NOT NULL), 0), 2) AS compliance_pct
FROM olist_sales_data_set.olist_order_items_dataset oi
JOIN olist_sales_data_set.olist_orders_dataset o
  ON oi.order_id = o.order_id
WHERE o.order_status = 'delivered'
  AND o.order_delivered_carrier_date IS NOT NULL;
```

**Verified Result:** 90.68% compliance (99,925 of 110,195 items on time). 10,270 items (9.32%) had late seller handoff.

**Looker Studio Implementation:** Calculated field comparing carrier date to shipping limit. Scorecard + trend line over time.

---

### KPI 10: Shipping Route Performance (Seller State to Customer State)

**Business Meaning:** Identifies the busiest and most problematic shipping corridors. Enables route-level optimization decisions (e.g., adding warehouses, changing carriers for specific routes).

**Validated SQL Query:**
```sql
SELECT
  s.seller_state || ' → ' || c.customer_state AS route,
  COUNT(*) AS orders,
  ROUND(AVG(
    EXTRACT(EPOCH FROM (o.order_delivered_customer_date - o.order_purchase_timestamp)) / 86400
  )::numeric, 1) AS avg_delivery_days,
  ROUND(AVG(oi.freight_value)::numeric, 2) AS avg_freight,
  ROUND(100.0 * COUNT(*) FILTER (
    WHERE o.order_delivered_customer_date > o.order_estimated_delivery_date
  ) / COUNT(*), 2) AS late_pct
FROM olist_sales_data_set.olist_order_items_dataset oi
JOIN olist_sales_data_set.olist_orders_dataset o ON oi.order_id = o.order_id
JOIN olist_sales_data_set.olist_sellers_dataset s ON oi.seller_id = s.seller_id
JOIN olist_sales_data_set.olist_customers_dataset c ON o.customer_id = c.customer_id
WHERE o.order_status = 'delivered'
  AND o.order_delivered_customer_date IS NOT NULL
  AND o.order_estimated_delivery_date IS NOT NULL
GROUP BY s.seller_state, c.customer_state
HAVING COUNT(*) >= 100
ORDER BY orders DESC;
```

**Verified Result (Top 5 Routes):**
| Route    | Orders | Avg Days | Avg Freight | Late % |
|----------|--------|----------|-------------|--------|
| SP → SP  | 35,420 | 7.9      | R$13.20     | 6.10%  |
| SP → RJ  | 9,403  | 16.1     | R$20.39     | 14.85% |
| SP → MG  | 8,567  | 12.3     | R$20.25     | 6.09%  |
| SP → RS  | 4,133  | 16.0     | R$20.61     | 7.23%  |
| SP → BA  | 2,626  | 19.7     | R$24.32     | 14.78% |

**Key Insight:** SP → RJ is the second-busiest route but has a 14.85% late rate, nearly 3x the intrastate SP → SP rate. SP → BA averages almost 20 days delivery time.

**Looker Studio Implementation:** Cross-join table in SQL source. Display as a heatmap matrix (seller state rows, customer state columns, colored by late %).

---

### KPI 11: Product Category Logistics Profile

**Business Meaning:** Links product characteristics (weight, category) to freight cost and delivery time. Helps identify which product categories are most expensive or difficult to ship.

**Validated SQL Query:**
```sql
SELECT
  t.product_category_name_english AS category,
  COUNT(*) AS items,
  ROUND(AVG(p.product_weight_g)::numeric, 0) AS avg_weight_g,
  ROUND(AVG(oi.freight_value)::numeric, 2) AS avg_freight,
  ROUND(AVG(
    EXTRACT(EPOCH FROM (o.order_delivered_customer_date - o.order_purchase_timestamp)) / 86400
  )::numeric, 1) AS avg_delivery_days
FROM olist_sales_data_set.olist_order_items_dataset oi
JOIN olist_sales_data_set.olist_orders_dataset o ON oi.order_id = o.order_id
JOIN olist_sales_data_set.olist_products_dataset p ON oi.product_id = p.product_id
LEFT JOIN olist_sales_data_set.product_category_name_translation t
  ON p.product_category_name = t.product_category_name
WHERE o.order_status = 'delivered'
  AND o.order_delivered_customer_date IS NOT NULL
  AND p.product_weight_g IS NOT NULL
GROUP BY t.product_category_name_english
ORDER BY items DESC
LIMIT 15;
```

**Verified Result:** Heaviest categories (housewares at 3,217g, garden tools at 2,809g) have highest freight (R$21-23). Lightest (telephony at 261g) has lowest freight (R$15.65). Delivery times surprisingly uniform (10.9-13.7 days) regardless of weight.

**Looker Studio Implementation:** SQL source with product join. Scatter plot (x = avg weight, y = avg freight, size = volume). Bar chart by category.

---

### KPI 12: Monthly Delivery Performance Trend

**Business Meaning:** Tracks whether logistics performance is improving or degrading over the 2-year data window. Identifies seasonal spikes (Black Friday, holidays) and structural improvements.

**Validated SQL Query:**
```sql
SELECT
  TO_CHAR(order_purchase_timestamp, 'YYYY-MM') AS month,
  COUNT(*) AS delivered_orders,
  ROUND(AVG(
    EXTRACT(EPOCH FROM (order_delivered_customer_date - order_purchase_timestamp)) / 86400
  )::numeric, 1) AS avg_delivery_days,
  ROUND(100.0 * COUNT(*) FILTER (
    WHERE o.order_delivered_customer_date > o.order_estimated_delivery_date
  ) / COUNT(*), 2) AS late_pct
FROM olist_sales_data_set.olist_orders_dataset o
WHERE order_status = 'delivered'
  AND order_delivered_customer_date IS NOT NULL
  AND order_estimated_delivery_date IS NOT NULL
GROUP BY TO_CHAR(order_purchase_timestamp, 'YYYY-MM')
ORDER BY month;
```

**Verified Result Highlights:**
- **Nov 2017 (Black Friday):** Late rate spikes to 14.31%, avg 15.2 days
- **Feb-Mar 2018:** Worst period -- late rates hit 16-21%, avg delivery 16-17 days
- **Jun-Aug 2018:** Strong recovery -- delivery times drop to 7.7-9.2 days, late rates normalize
- **Overall trend:** Delivery times improved from ~13 days in 2017 to ~8-9 days by mid-2018

**Looker Studio Implementation:** Time series line chart with dual axis (avg delivery days + late %). Add date range filter. This is best as a SQL source with monthly pre-aggregation.

---

## D. Suggested Dashboard Pages

### Page 1: Executive Summary

**Purpose:** High-level KPI overview for senior management. At-a-glance health of the supply chain.

**Components:**
- Scorecard row: Total Delivered Orders (96,478), Avg Delivery Time (12.6 days), On-Time Rate (91.89%), Avg Freight (R$19.99)
- Trend line: Monthly delivery volume + on-time rate over time
- Gauge chart: Current quarter on-time rate vs target (e.g., 95%)
- Comparison table: Current period vs previous period key metrics
- Date range filter and order status filter (global controls)

---

### Page 2: Delivery Pipeline Analysis

**Purpose:** Deep dive into where time is spent in the order-to-delivery pipeline. Identifies bottlenecks.

**Components:**
- Stacked bar/waterfall chart: Avg approval time (10.3 hrs) + seller handoff (2.8 days) + transit (9.3 days)
- Time series: Monthly trend of each pipeline stage
- Histogram: Distribution of total delivery times (how many orders in 0-5 days, 5-10, 10-15, etc.)
- Delivery estimate buffer analysis: Scatter plot of estimated vs actual delivery dates
- Seller compliance scorecard: 90.68% on-time handoff rate
- Filter: By customer state, by seller state

---

### Page 3: Geographic Performance

**Purpose:** Map-based analysis of delivery performance across Brazilian states and shipping corridors.

**Components:**
- Geo map (Brazil): Customer states colored by late delivery rate (red = high, green = low)
- Route performance table: Top 15 seller→customer state corridors with delivery time, freight, and late %
- Comparison bar chart: Avg delivery days by customer state
- Intra-state vs inter-state comparison: SP→SP (7.9 days) vs SP→BA (19.7 days)
- Filter: By seller state, by customer state, by date range

---

### Page 4: Freight & Cost Analysis

**Purpose:** Understand shipping cost drivers and identify cost optimization opportunities.

**Components:**
- Scorecard: Total freight revenue (R$2.25M), Avg freight per item (R$19.99), Freight as % of order value (21.3%)
- Bar chart: Avg freight by product category (top 15)
- Scatter plot: Product weight (x) vs freight cost (y), sized by volume
- Bar chart: Avg freight by seller state
- Table: Freight cost by shipping route (seller state → customer state)
- Filter: By product category, by weight range, by seller state

---

### Page 5: Seller Performance & Trends

**Purpose:** Evaluate individual seller logistics performance and identify improvement trends.

**Components:**
- Table: Top 20 sellers by volume with avg delivery time, late %, avg freight, compliance rate
- Time series: Monthly on-time rate trend with volume overlay
- Seasonal analysis: Late rate by month-of-year (to identify recurring seasonal patterns)
- Seller compliance trend: % of items handed off before shipping limit, monthly
- Highlight: Nov 2017 Black Friday spike, Feb-Mar 2018 crisis, mid-2018 recovery
- Filter: By seller state, by date range, by minimum order threshold

---

## E. Weekly Milestones

### Week 1: Data Exploration & SQL Query Development

**Objectives:** Understand the data, write and validate all SQL queries, identify data quality issues.

**Tasks:**
- [ ] Explore all 5 logistics tables (orders, order_items, sellers, customers, products) in Supabase
- [ ] Write and validate SQL queries for all 12 KPIs listed above
- [ ] Document column definitions, data types, and NULL patterns
- [ ] Identify and document data limitations (see Section F)
- [ ] Create a data dictionary specific to supply chain columns
- [ ] Design the SQL views or custom queries that will feed each dashboard page
- [ ] Set up Google Looker Studio and connect to the Supabase data source

**Deliverable:** SQL query workbook (all 12 KPIs validated with results) + data exploration report

---

### Week 2: Dashboard Build (Core Pages)

**Objectives:** Build Pages 1-3 of the dashboard with basic interactivity.

**Tasks:**
- [ ] Create the data source connection in Looker Studio (custom SQL query or blended sources)
- [ ] Build Page 1 (Executive Summary): scorecards, trend line, gauge
- [ ] Build Page 2 (Delivery Pipeline): waterfall chart, histograms, pipeline breakdown
- [ ] Build Page 3 (Geographic Performance): geo map, route table, state comparisons
- [ ] Add date range filter as a global control
- [ ] Ensure consistent color scheme and formatting across all pages
- [ ] Test all calculated fields against validated SQL results

**Deliverable:** Working 3-page Looker Studio dashboard with basic filters

---

### Week 3: Advanced Features, Interactivity, Polish

**Objectives:** Complete remaining pages, add cross-filtering, polish design.

**Tasks:**
- [ ] Build Page 4 (Freight & Cost Analysis): scatter plots, category breakdowns
- [ ] Build Page 5 (Seller Performance & Trends): seller table, trend analysis
- [ ] Add cross-page navigation and consistent filter controls
- [ ] Implement interactive cross-filtering (click a state on the map to filter the whole page)
- [ ] Add conditional formatting to highlight problem areas (e.g., red for late rate > 10%)
- [ ] Create calculated fields for Looker Studio (on-time flag, delivery stage durations, freight %)
- [ ] Design polish: headers, legends, tooltips, consistent color palette
- [ ] Peer review: exchange dashboards with another student for feedback

**Deliverable:** Complete 5-page interactive dashboard, peer review feedback incorporated

---

### Week 4: Report Writing, Presentation Prep, Final Review

**Objectives:** Write the business report, prepare the presentation, finalize everything.

**Tasks:**
- [ ] Write executive summary (1 page): key findings and recommendations
- [ ] Write methodology section: data sources, KPI definitions, tools used
- [ ] Write findings section (4-6 pages): one subsection per dashboard page with key insights
- [ ] Write recommendations section (1-2 pages): actionable supply chain improvements
- [ ] Create 10-15 slide presentation with dashboard screenshots and key talking points
- [ ] Practice presentation delivery (10 minutes)
- [ ] Final dashboard quality check: verify all numbers, fix any formatting issues
- [ ] Submit complete project package

**Deliverable:** Final report + presentation slides + polished dashboard link

---

## F. Data Limitations & Gotchas

### Critical Rules Students Must Follow

| # | Issue | Rule | Impact if Ignored |
|---|-------|------|-------------------|
| 1 | **Order status filter** | ALWAYS filter `WHERE order_status = 'delivered'` for delivery metrics | Including shipped/canceled orders will produce meaningless delivery time averages |
| 2 | **NULL delivery dates** | Exclude rows where `order_delivered_customer_date IS NULL` (only 8 rows in delivered orders) | Minor impact but shows good practice |
| 3 | **NULL carrier dates** | Only 2 delivered orders have NULL `order_delivered_carrier_date` | Negligible but exclude for pipeline analysis |
| 4 | **Geolocation duplicates** | The `olist_geolocation_dataset` has ~52.6 rows per zip code (1M rows for 19K zips) | MUST deduplicate (use `DISTINCT ON` or subquery with `AVG(lat), AVG(lng)`) before joining, or skip geolocation entirely and use state-level analysis |
| 5 | **Date range** | Data spans Sep 2016 to Oct 2018, but Sep-Dec 2016 has very few orders (<300) | Consider filtering to Jan 2017+ for trend analysis to avoid distorted early data |
| 6 | **No carrier identity** | There is no carrier/shipping company name in the data | Cannot compare carrier performance -- all transit analysis is route-based, not carrier-based |
| 7 | **No real shipping cost to Olist** | `freight_value` is what the CUSTOMER paid for shipping, not what the carrier charges Olist | Cannot calculate true shipping margin or logistics P&L |
| 8 | **Single delivery per order** | Delivery timestamps are at the ORDER level, not the item level | Multi-item orders from different sellers show one delivery date; the "last item delivered" sets the timestamp |
| 9 | **Product weight NULLs** | Some products have NULL `product_weight_g` | Exclude from weight-based analysis; document the exclusion count |
| 10 | **Extreme outliers** | Max delivery time = 209.6 days; max delay = 189 days | Consider capping at a reasonable threshold (e.g., 60 days) or noting outliers separately |
| 11 | **Category translation** | Product categories are in Portuguese; use `product_category_name_translation` table for English names | Some categories may not have translations (LEFT JOIN, handle NULLs) |
| 12 | **Estimated delivery date** | This is the date SHOWN TO THE CUSTOMER, not an internal operational target | The ~11-day average buffer suggests Olist deliberately over-estimates; "on-time" is partly an artifact of conservative estimates |

### Data Strengths for This Project

- Large sample size: 96,478 delivered orders with complete timestamps
- Full pipeline visibility: purchase → approval → carrier → customer → estimated dates all available
- Rich geographic dimension: seller state + customer state enables route analysis
- Product dimension: weight, dimensions, and category available for freight analysis
- Two full years of data for meaningful trend analysis

---

## G. Grading Rubric

### Total: 100 Points

---

### 1. SQL Query Development & Data Understanding (20 points)

| Grade | Points | Criteria |
|-------|--------|----------|
| A (18-20) | Queries for all 12 KPIs validated and documented. Demonstrates awareness of all data gotchas. Custom queries go beyond the provided list (e.g., percentile analysis, cohort comparisons). |
| B (14-17) | Queries for 8-10 KPIs working correctly. Most data rules followed. Minor issues with edge cases or NULL handling. |
| C (10-13) | Queries for 6-8 KPIs working. Some data rules missed (e.g., forgot to filter delivered orders). Basic SQL only, no advanced functions. |
| D/F (<10) | Fewer than 6 KPIs computed. Major data errors (e.g., including non-delivered orders in delivery time). Queries not validated against database. |

---

### 2. Dashboard Design & Visual Communication (30 points)

| Grade | Points | Criteria |
|-------|--------|----------|
| A (27-30) | 4-5 well-designed pages. Consistent color scheme and typography. Effective use of chart types (geo maps, scatter plots, time series). Clear titles, labels, and legends. Visual hierarchy guides the viewer's eye. |
| B (22-26) | 3-4 pages with good design. Most charts are appropriate. Minor inconsistencies in formatting. Some labels or legends missing. |
| C (16-21) | 2-3 pages. Basic chart types only (bar charts, tables). Inconsistent formatting. Missing legends or unclear labels. Dashboard feels like disconnected charts rather than a story. |
| D/F (<16) | 1-2 pages. Poor chart selection. No consistent design. Missing basic labels. Charts are misleading or incorrectly configured. |

---

### 3. Interactivity & Technical Execution (20 points)

| Grade | Points | Criteria |
|-------|--------|----------|
| A (18-20) | Global date range filter + state/category filters. Cross-filtering works across charts. Drill-down capability (e.g., click state to see city-level). Calculated fields in Looker Studio are correct. Navigation between pages is intuitive. |
| B (14-17) | Date filter + 1-2 other filters working. Some cross-filtering. Calculated fields mostly correct. Basic navigation. |
| C (10-13) | Only 1 filter (date range). No cross-filtering. Calculated fields have errors or are missing. |
| D/F (<10) | No interactivity. Static charts only. No filters or calculated fields. |

---

### 4. Business Report (15 points)

| Grade | Points | Criteria |
|-------|--------|----------|
| A (13-15) | Clear executive summary. Well-structured methodology section. Each finding is supported by specific numbers from the dashboard. Recommendations are actionable and tied to data (e.g., "Prioritize SP→RJ route optimization -- 14.85% late rate on 9,403 orders"). |
| B (10-12) | Good structure. Most findings supported by data. Recommendations present but somewhat generic. |
| C (7-9) | Basic report structure. Findings descriptive rather than analytical. Recommendations vague. |
| D/F (<7) | Poorly organized. Findings not supported by data. No meaningful recommendations. |

---

### 5. Presentation & Communication (15 points)

| Grade | Points | Criteria |
|-------|--------|----------|
| A (13-15) | Clear 10-minute delivery. Slides tell a story (problem → analysis → findings → recommendations). Live dashboard demo included. Confident handling of Q&A. Professional slide design. |
| B (10-12) | Good delivery. Mostly follows narrative structure. Dashboard shown but not demoed interactively. Minor timing issues. |
| C (7-9) | Reads from slides. No clear narrative. Dashboard screenshots only (no live demo). Significantly over/under time. |
| D/F (<7) | Unprepared. No clear structure. Cannot explain methodology or findings when questioned. |

---

### Bonus Opportunities (up to 5 extra points)

- **+2:** Incorporate review scores (from `olist_order_reviews_dataset`) to correlate delivery delays with customer satisfaction ratings
- **+2:** Build a "What-If" simulation (e.g., "If we reduced SP→RJ transit time by 3 days, how would overall on-time rate change?")
- **+1:** Add a comparison dashboard page showing 2017 vs 2018 side-by-side performance

---

## Appendix: Table Schema Reference

### olist_orders_dataset (99,441 rows)
| Column | Type | Notes |
|--------|------|-------|
| order_id | text | Primary key |
| customer_id | text | FK to customers |
| order_status | text | delivered (96,478), shipped (1,107), canceled (625), etc. |
| order_purchase_timestamp | timestamp | Customer placed order |
| order_approved_at | timestamp | Payment approved |
| order_delivered_carrier_date | timestamp | Handed to carrier |
| order_delivered_customer_date | timestamp | Arrived at customer |
| order_estimated_delivery_date | timestamp | Promised date shown to customer |

### olist_order_items_dataset (112,650 rows)
| Column | Type | Notes |
|--------|------|-------|
| order_id | text | FK to orders |
| order_item_id | integer | Item sequence within order |
| product_id | text | FK to products |
| seller_id | text | FK to sellers |
| shipping_limit_date | timestamp | Deadline for seller to hand off |
| price | real | Item price in BRL |
| freight_value | real | Shipping cost charged to customer in BRL |

### olist_sellers_dataset (3,095 rows)
| Column | Type | Notes |
|--------|------|-------|
| seller_id | text | Primary key |
| seller_zip_code_prefix | integer | 5-digit zip prefix |
| seller_city | text | Seller city |
| seller_state | text | 2-letter state code (SP, MG, PR, etc.) |

### olist_customers_dataset (99,441 rows)
| Column | Type | Notes |
|--------|------|-------|
| customer_id | text | PK, one per order |
| customer_unique_id | text | True unique customer (for repeat analysis) |
| customer_zip_code_prefix | integer | 5-digit zip prefix |
| customer_city | text | Customer city |
| customer_state | text | 2-letter state code |

### olist_products_dataset (32,951 rows)
| Column | Type | Notes |
|--------|------|-------|
| product_id | text | Primary key |
| product_category_name | text | Portuguese category name |
| product_weight_g | integer | Weight in grams (some NULLs) |
| product_length_cm | integer | Package length |
| product_height_cm | integer | Package height |
| product_width_cm | integer | Package width |

### olist_geolocation_dataset (1,000,163 rows)
| Column | Type | Notes |
|--------|------|-------|
| geolocation_zip_code_prefix | integer | 5-digit zip prefix |
| geolocation_lat | real | Latitude |
| geolocation_lng | real | Longitude |
| geolocation_city | text | City name |
| geolocation_state | text | State code |

**WARNING:** ~52.6 rows per zip code. MUST deduplicate before use.

### product_category_name_translation
| Column | Type | Notes |
|--------|------|-------|
| product_category_name | text | Portuguese original |
| product_category_name_english | text | English translation |
