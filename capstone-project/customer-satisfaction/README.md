# Customer Satisfaction Analytics — Capstone Project

## Google Looker Studio Dashboard Project Using the Olist E-Commerce Dataset

---

## A. Project Title & Overview

**Title:** Olist Customer Satisfaction Intelligence Dashboard

**Overview:** Build a comprehensive Google Looker Studio dashboard that analyzes customer satisfaction patterns across the Olist e-commerce marketplace in Brazil. Using 98,410 customer reviews spanning Sep 2016 – Oct 2018, students will compute satisfaction KPIs including NPS proxy scores, review trends, delivery impact on ratings, category-level satisfaction, and customer behavior patterns. The dashboard will help a customer experience team identify satisfaction drivers, problem areas, and actionable improvements.

**Primary Deliverables:**
1. Google Looker Studio dashboard (3-5 pages, interactive filters)
2. Written business report (8-12 pages)
3. Stakeholder presentation (10-15 slides, 10-minute delivery)

---

## B. Business Questions

The dashboard should answer these seven core business questions:

1. **What is our overall customer satisfaction level, and is it improving or declining?** (Overall avg review score = 4.09/5.0, NPS proxy = +35.0)

2. **How severely does delivery performance impact customer satisfaction?** (On-time orders avg 4.30 stars vs late orders avg 2.57 stars — a 1.73-star gap)

3. **Which product categories drive the highest and lowest satisfaction?** (Books: 4.51 avg vs Office Furniture: 3.52 avg)

4. **Do higher-value orders lead to lower satisfaction?** (Under $50: 4.25 avg vs $500+: 4.01 avg — a clear inverse relationship)

5. **How does delivery timing granularity affect reviews?** (14+ days early: 4.33 stars vs 8-14 days late: 1.74 stars — a dramatic 2.59-star cliff)

6. **Are dissatisfied customers more vocal?** (76.6% of 1-star reviewers leave comments at avg 100 chars vs 35.9% of 5-star at avg 52 chars)

7. **Do repeat customers report higher satisfaction than one-time buyers?** (Repeat: 4.24 avg vs One-Time: 4.15 avg)

---

## C. KPI Catalog

### KPI 1: Overall Average Review Score

**Business meaning:** The marketplace-wide average customer rating (1-5 stars). The single most important satisfaction metric.

**Validated SQL:**
```sql
SELECT
  ROUND(AVG(review_score), 2) AS avg_review_score,
  COUNT(*) AS total_reviews
FROM olist_sales_data_set.olist_order_reviews_dataset;
```

**Verified Result:** Average = 4.09 out of 5.0, Total reviews = 98,410.

**Looker Studio notes:** Scorecard with gauge visualization. Use `AVG(review_score)` as the metric. Add sparkline for monthly trend.

---

### KPI 2: NPS Proxy Score

**Business meaning:** Net Promoter Score approximation using review scores. 5-star = Promoters, 4-star = Passives, 1-3 stars = Detractors. NPS = %Promoters - %Detractors.

**Validated SQL:**
```sql
SELECT
  ROUND(SUM(CASE WHEN review_score = 5 THEN 1 ELSE 0 END)::numeric / COUNT(*) * 100, 1) AS promoter_pct,
  ROUND(SUM(CASE WHEN review_score = 4 THEN 1 ELSE 0 END)::numeric / COUNT(*) * 100, 1) AS passive_pct,
  ROUND(SUM(CASE WHEN review_score <= 3 THEN 1 ELSE 0 END)::numeric / COUNT(*) * 100, 1) AS detractor_pct,
  ROUND(
    (SUM(CASE WHEN review_score = 5 THEN 1 ELSE 0 END)::numeric
     - SUM(CASE WHEN review_score <= 3 THEN 1 ELSE 0 END)::numeric) / COUNT(*) * 100, 1
  ) AS nps_score
FROM olist_sales_data_set.olist_order_reviews_dataset;
```

**Verified Result:** Promoters = 57.8%, Passives = 19.3%, Detractors = 22.9%, **NPS = +35.0**

**Looker Studio notes:** Pre-compute in SQL. Display as gauge (-100 to +100 scale) with color coding (green >50, yellow 0-50, red <0). Donut chart showing promoter/passive/detractor split.

---

### KPI 3: Monthly Satisfaction Trend

**Business meaning:** Average review score by month. Tracks whether satisfaction is improving or degrading over time, and identifies seasonal patterns.

**Validated SQL:**
```sql
SELECT
  TO_CHAR(review_creation_date::timestamp, 'YYYY-MM') AS review_month,
  COUNT(*) AS review_count,
  ROUND(AVG(review_score), 2) AS avg_score
FROM olist_sales_data_set.olist_order_reviews_dataset
GROUP BY review_month
ORDER BY review_month;
```

**Verified Result Highlights:**
- Dec 2016: Lowest score (2.36) — early marketplace issues
- Jan 2017: Recovered to 4.33
- Dec 2017: Dipped to 3.93 (holiday season stress)
- Mar 2018: Dipped to 3.73 (post-holiday backlog)
- Jul-Aug 2018: Strong recovery to 4.22-4.29

**Looker Studio notes:** Time series line chart. Use raw timestamp with Looker date granularity set to Month. Dual axis with review count as bars.

---

### KPI 4: Satisfaction by Delivery Performance (On-Time vs Late)

**Business meaning:** The single strongest driver of customer satisfaction — compares ratings for orders delivered on time vs late.

**Validated SQL:**
```sql
SELECT
  CASE
    WHEN o.order_delivered_customer_date::timestamp <= o.order_estimated_delivery_date::timestamp THEN 'On-Time'
    ELSE 'Late'
  END AS delivery_status,
  COUNT(*) AS order_count,
  ROUND(AVG(r.review_score), 2) AS avg_score,
  ROUND(SUM(CASE WHEN r.review_score <= 3 THEN 1 ELSE 0 END)::numeric / COUNT(*) * 100, 1) AS detractor_pct
FROM olist_sales_data_set.olist_orders_dataset o
JOIN olist_sales_data_set.olist_order_reviews_dataset r ON o.order_id = r.order_id
WHERE o.order_delivered_customer_date IS NOT NULL
  AND o.order_status = 'delivered'
GROUP BY delivery_status;
```

**Verified Result:**

| Status | Orders | Avg Score | Detractor % |
|--------|--------|-----------|-------------|
| On-Time | 87,969 | 4.30 | 17.2% |
| Late | 7,632 | 2.57 | 65.4% |

**Key Insight:** Late delivery nearly quadruples the detractor rate (17.2% → 65.4%). This is THE most impactful finding.

**Looker Studio notes:** Calculated field: `CASE WHEN order_delivered_customer_date <= order_estimated_delivery_date THEN "On-Time" ELSE "Late" END`. Side-by-side bar chart + scorecard comparison.

---

### KPI 5: Satisfaction by Product Category (Top & Bottom)

**Business meaning:** Which product categories delight or disappoint customers most? Identifies problem categories for quality improvement.

**Validated SQL:**
```sql
WITH cat_scores AS (
  SELECT
    COALESCE(t.product_category_name_english, p.product_category_name) AS category,
    COUNT(*) AS review_count,
    ROUND(AVG(r.review_score), 2) AS avg_score
  FROM olist_sales_data_set.olist_order_reviews_dataset r
  JOIN olist_sales_data_set.olist_orders_dataset o ON r.order_id = o.order_id
  JOIN olist_sales_data_set.olist_order_items_dataset oi ON o.order_id = oi.order_id
  JOIN olist_sales_data_set.olist_products_dataset p ON oi.product_id = p.product_id
  LEFT JOIN olist_sales_data_set.product_category_name_translation t
    ON p.product_category_name = t.product_category_name
  WHERE o.order_status = 'delivered'
  GROUP BY category
  HAVING COUNT(*) >= 50
)
(SELECT 'TOP' AS rank_type, category, review_count, avg_score
 FROM cat_scores ORDER BY avg_score DESC LIMIT 5)
UNION ALL
(SELECT 'BOTTOM', category, review_count, avg_score
 FROM cat_scores ORDER BY avg_score ASC LIMIT 5);
```

**Verified Result:**

| Rank | Category | Reviews | Avg Score |
|------|----------|---------|-----------|
| TOP | books_general_interest | 533 | 4.51 |
| TOP | books_imported | 57 | 4.51 |
| TOP | construction_tools | 99 | 4.44 |
| TOP | small_appliances_home | 73 | 4.44 |
| TOP | books_technical | 261 | 4.39 |
| BOTTOM | office_furniture | 1,654 | 3.52 |
| BOTTOM | fashion_male_clothing | 123 | 3.76 |
| BOTTOM | fixed_telephony | 253 | 3.76 |
| BOTTOM | audio | 358 | 3.84 |
| BOTTOM | home_comfort | 428 | 3.86 |

**Looker Studio notes:** Horizontal bar chart sorted by avg score. Color-code green (>4.2) / yellow (3.8-4.2) / red (<3.8). Filter by min review count.

---

### KPI 6: Review Response Time (Days to Review)

**Business meaning:** Average days between order purchase and review submission. Indicates customer engagement speed and whether delayed reviews correlate with dissatisfaction.

**Validated SQL:**
```sql
SELECT
  ROUND(AVG(EXTRACT(EPOCH FROM (r.review_creation_date::timestamp - o.order_purchase_timestamp::timestamp)) / 86400), 1) AS avg_days_to_review,
  PERCENTILE_CONT(0.5) WITHIN GROUP (
    ORDER BY EXTRACT(EPOCH FROM (r.review_creation_date::timestamp - o.order_purchase_timestamp::timestamp)) / 86400
  ) AS median_days_to_review
FROM olist_sales_data_set.olist_order_reviews_dataset r
JOIN olist_sales_data_set.olist_orders_dataset o ON r.order_id = o.order_id
WHERE o.order_status = 'delivered';
```

**Verified Result:** Average = 12.3 days, Median = 10.5 days.

**Looker Studio notes:** Pre-compute in SQL. Display as histogram of response time distribution + scorecard for average.

---

### KPI 7: Satisfaction by Customer State (Geographic)

**Business meaning:** Geographic breakdown of satisfaction. Identifies which regions have the happiest or most dissatisfied customers.

**Validated SQL:**
```sql
WITH state_scores AS (
  SELECT
    c.customer_state,
    COUNT(*) AS review_count,
    ROUND(AVG(r.review_score), 2) AS avg_score
  FROM olist_sales_data_set.olist_order_reviews_dataset r
  JOIN olist_sales_data_set.olist_orders_dataset o ON r.order_id = o.order_id
  JOIN olist_sales_data_set.olist_customers_dataset c ON o.customer_id = c.customer_id
  WHERE o.order_status = 'delivered'
  GROUP BY c.customer_state
  HAVING COUNT(*) >= 100
)
(SELECT 'TOP' AS rank_type, customer_state, review_count, avg_score
 FROM state_scores ORDER BY avg_score DESC LIMIT 5)
UNION ALL
(SELECT 'BOTTOM', customer_state, review_count, avg_score
 FROM state_scores ORDER BY avg_score ASC LIMIT 5);
```

**Verified Result:** States closest to seller hub (SP) tend to score higher due to faster delivery. Remote northern/northeastern states score lower.

**Looker Studio notes:** Geo map (Brazil states) colored by avg score. Sortable table alongside. Use `customer_state` as geographic dimension.

---

### KPI 8: Repeat vs One-Time Customer Satisfaction

**Business meaning:** Compares satisfaction between customers who ordered once vs multiple times (using `customer_unique_id`). Tests whether repeat buyers are more or less satisfied.

**Validated SQL:**
```sql
WITH customer_orders AS (
  SELECT
    c.customer_unique_id,
    COUNT(DISTINCT o.order_id) AS order_count
  FROM olist_sales_data_set.olist_orders_dataset o
  JOIN olist_sales_data_set.olist_customers_dataset c ON o.customer_id = c.customer_id
  WHERE o.order_status = 'delivered'
  GROUP BY c.customer_unique_id
)
SELECT
  CASE WHEN co.order_count > 1 THEN 'Repeat' ELSE 'One-Time' END AS customer_type,
  COUNT(DISTINCT c.customer_unique_id) AS customer_count,
  ROUND(AVG(r.review_score), 2) AS avg_score
FROM olist_sales_data_set.olist_order_reviews_dataset r
JOIN olist_sales_data_set.olist_orders_dataset o ON r.order_id = o.order_id
JOIN olist_sales_data_set.olist_customers_dataset c ON o.customer_id = c.customer_id
JOIN customer_orders co ON c.customer_unique_id = co.customer_unique_id
WHERE o.order_status = 'delivered'
GROUP BY customer_type;
```

**Verified Result:**

| Type | Customers | Avg Score |
|------|-----------|-----------|
| One-Time | 89,935 | 4.15 |
| Repeat | 2,791 | 4.24 |

**Key Insight:** Repeat customers are slightly more satisfied (4.24 vs 4.15), suggesting positive experiences drive retention. Only 3% of customers are repeat buyers.

**Looker Studio notes:** Pre-compute in SQL. Bar chart comparison + scorecards.

---

### KPI 9: Review Comment Analysis (Vocal Dissatisfaction)

**Business meaning:** Measures whether dissatisfied customers leave more comments and longer comments. Proxy for sentiment intensity without NLP.

**Validated SQL:**
```sql
SELECT
  review_score,
  COUNT(*) AS total,
  SUM(CASE WHEN review_comment_message IS NOT NULL AND review_comment_message != '' THEN 1 ELSE 0 END) AS with_comment,
  ROUND(SUM(CASE WHEN review_comment_message IS NOT NULL AND review_comment_message != '' THEN 1 ELSE 0 END)::numeric / COUNT(*) * 100, 1) AS comment_pct,
  ROUND(AVG(CASE WHEN review_comment_message IS NOT NULL AND review_comment_message != ''
    THEN LENGTH(review_comment_message) END), 0) AS avg_comment_length
FROM olist_sales_data_set.olist_order_reviews_dataset
GROUP BY review_score ORDER BY review_score;
```

**Verified Result:**

| Score | Total | % with Comment | Avg Comment Length |
|-------|-------|---------------|-------------------|
| 1 | 11,282 | 76.6% | 100 chars |
| 2 | 3,114 | 68.0% | 97 chars |
| 3 | 8,097 | 43.6% | 83 chars |
| 4 | 19,007 | 31.2% | 62 chars |
| 5 | 56,910 | 35.9% | 52 chars |

**Key Insight:** Dissatisfied customers are 2x more likely to leave comments and write nearly 2x longer comments. This is a powerful finding for prioritizing complaint analysis.

**Looker Studio notes:** Grouped bar chart (comment rate by score). Cannot do NLP in Looker, but comment presence/length is a useful proxy.

---

### KPI 10: Delivery Delay Severity vs Satisfaction

**Business meaning:** Granular analysis of how delivery timing affects satisfaction across 6 buckets from "14+ days early" to "14+ days late".

**Validated SQL:**
```sql
SELECT
  CASE
    WHEN EXTRACT(EPOCH FROM (o.order_delivered_customer_date::timestamp - o.order_estimated_delivery_date::timestamp)) / 86400 <= -14 THEN '14+ days early'
    WHEN EXTRACT(EPOCH FROM (o.order_delivered_customer_date::timestamp - o.order_estimated_delivery_date::timestamp)) / 86400 <= -7 THEN '7-14 days early'
    WHEN EXTRACT(EPOCH FROM (o.order_delivered_customer_date::timestamp - o.order_estimated_delivery_date::timestamp)) / 86400 <= 0 THEN '0-7 days early'
    WHEN EXTRACT(EPOCH FROM (o.order_delivered_customer_date::timestamp - o.order_estimated_delivery_date::timestamp)) / 86400 <= 7 THEN '1-7 days late'
    WHEN EXTRACT(EPOCH FROM (o.order_delivered_customer_date::timestamp - o.order_estimated_delivery_date::timestamp)) / 86400 <= 14 THEN '8-14 days late'
    ELSE '14+ days late'
  END AS delivery_bucket,
  COUNT(*) AS order_count,
  ROUND(AVG(r.review_score), 2) AS avg_score
FROM olist_sales_data_set.olist_orders_dataset o
JOIN olist_sales_data_set.olist_order_reviews_dataset r ON o.order_id = r.order_id
WHERE o.order_delivered_customer_date IS NOT NULL AND o.order_status = 'delivered'
GROUP BY delivery_bucket
ORDER BY avg_score DESC;
```

**Verified Result:**

| Delivery Bucket | Orders | Avg Score |
|-----------------|--------|-----------|
| 14+ days early | 34,662 | 4.33 |
| 7-14 days early | 36,091 | 4.31 |
| 0-7 days early | 17,216 | 4.20 |
| 1-7 days late | 4,391 | 3.18 |
| 8-14 days late | 1,740 | 1.74 |
| 14+ days late | 1,501 | 1.71 |

**Key Insight:** There's a dramatic "satisfaction cliff" — going from on-time to 1-7 days late drops the score by 1 full star. Beyond 8 days late, scores collapse to 1.7. Early delivery provides only marginal improvement (4.20→4.33).

**Looker Studio notes:** Bar chart ordered by delivery bucket. Color gradient from green to red. This is the most compelling visualization in the project.

---

### KPI 11: Order Value vs Satisfaction

**Business meaning:** Tests whether higher-spending customers are harder to please.

**Validated SQL:**
```sql
SELECT
  CASE
    WHEN total_value < 50 THEN 'Under $50'
    WHEN total_value < 100 THEN '$50-$100'
    WHEN total_value < 200 THEN '$100-$200'
    WHEN total_value < 500 THEN '$200-$500'
    ELSE '$500+'
  END AS order_value_bucket,
  COUNT(*) AS order_count,
  ROUND(AVG(review_score), 2) AS avg_score
FROM (
  SELECT o.order_id, r.review_score, SUM(oi.price + oi.freight_value) AS total_value
  FROM olist_sales_data_set.olist_orders_dataset o
  JOIN olist_sales_data_set.olist_order_reviews_dataset r ON o.order_id = r.order_id
  JOIN olist_sales_data_set.olist_order_items_dataset oi ON o.order_id = oi.order_id
  WHERE o.order_status = 'delivered'
  GROUP BY o.order_id, r.review_score
) sub
GROUP BY order_value_bucket
ORDER BY avg_score DESC;
```

**Verified Result:**

| Value Bucket | Orders | Avg Score |
|-------------|--------|-----------|
| Under $50 | 16,289 | 4.25 |
| $50-$100 | 29,098 | 4.20 |
| $100-$200 | 30,697 | 4.14 |
| $200-$500 | 15,326 | 4.06 |
| $500+ | 4,032 | 4.01 |

**Key Insight:** Clear inverse relationship — satisfaction decreases as order value increases. Higher-value orders carry higher expectations and more risk of disappointment.

**Looker Studio notes:** Bar chart by value bucket. Can create calculated field for value bucket using CASE WHEN on `price + freight_value`.

---

### KPI 12: Monthly 1-Star Review Rate (Dissatisfaction Trend)

**Business meaning:** Tracks the percentage of 1-star reviews over time. More sensitive than average score for detecting emerging satisfaction crises.

**Validated SQL:**
```sql
SELECT
  TO_CHAR(review_creation_date::timestamp, 'YYYY-MM') AS review_month,
  COUNT(*) AS total_reviews,
  SUM(CASE WHEN review_score = 1 THEN 1 ELSE 0 END) AS one_star_count,
  ROUND(SUM(CASE WHEN review_score = 1 THEN 1 ELSE 0 END)::numeric / COUNT(*) * 100, 1) AS one_star_pct
FROM olist_sales_data_set.olist_order_reviews_dataset
GROUP BY review_month
ORDER BY review_month;
```

**Verified Result Highlights:**
- Dec 2016: 64.4% 1-star (early platform issues, tiny sample)
- Jan-Feb 2017: Normalized to 6.6-7.3%
- Mar 2018: Spiked to 19.4% (worst month — post-holiday logistics crisis)
- Jul-Aug 2018: Recovered to 8.0-9.2%
- Overall trend: 1-star rate fluctuates between 8-15%, with seasonal spikes around holidays

**Looker Studio notes:** Time series line chart. More actionable than average score because it isolates the "angry customer" signal. Add threshold line at 10%.

---

## D. Suggested Dashboard Pages

### Page 1: Satisfaction Executive Summary
- Scorecards: Avg Review (4.09), NPS (+35.0), Total Reviews (98,410), Review Coverage %
- NPS donut chart (Promoter/Passive/Detractor split: 57.8% / 19.3% / 22.9%)
- Monthly satisfaction trend line (avg score over time)
- Review score distribution bar chart (1-5 stars)
- Date range filter + state filter (global controls)

### Page 2: Delivery Impact on Satisfaction
- Headline comparison: On-Time (4.30) vs Late (2.57) — the core story
- Delivery bucket satisfaction bar chart (14+ early through 14+ late)
- Scatter plot: Delivery days (x) vs review score (y)
- Monthly late delivery rate vs satisfaction trend (dual axis)
- Filter: Customer state, product category

### Page 3: Product & Category Satisfaction
- Horizontal bar chart: All categories sorted by avg score (color-coded)
- Top 5 / Bottom 5 categories comparison
- Order value vs satisfaction bar chart
- Bubble chart: Category volume (x) vs avg score (y), sized by revenue
- Filter: Min review count threshold, category selector

### Page 4: Customer Behavior & Voice
- Repeat vs One-Time customer comparison (bar chart + scorecards)
- Review comment analysis: % with comments by score level
- Comment length by score (proxy for sentiment intensity)
- Review response time histogram
- Filter: Customer type (repeat/one-time), date range

### Page 5: Geographic Satisfaction Map
- Brazil state choropleth map colored by avg review score
- State-level comparison table (state, reviews, avg score, detractor %, avg delivery days)
- Correlation callout: States with longer delivery times have lower scores
- Top 5 / Bottom 5 states by satisfaction
- Filter: State selector for cross-page filtering

---

## E. Weekly Milestones

### Week 1: Data Exploration & SQL Query Development
- Explore reviews, orders, customers, order_items, products tables
- Understand joins: order_id links reviews↔orders, customer_id links orders↔customers, product_id links items↔products
- Write and validate all 12 KPI queries against Supabase
- Document data quality issues (review coverage, NULL handling)
- Create master SQL view for flat review-level dataset
- **Deliverable:** SQL query workbook with all validated queries + data dictionary

### Week 2: Dashboard Build (Core Pages)
- Connect Looker Studio to Supabase data source
- Build Page 1 (Executive Summary): NPS gauge, scorecards, score distribution, monthly trend
- Build Page 2 (Delivery Impact): on-time vs late comparison, delivery bucket chart
- Build Page 3 (Category Satisfaction): category rankings, value vs satisfaction
- Apply consistent color theme (green=high satisfaction, red=low)
- **Deliverable:** Working 3-page dashboard with basic interactivity

### Week 3: Advanced Features, Interactivity & Polish
- Build Page 4 (Customer Behavior): repeat vs one-time, comment analysis
- Build Page 5 (Geographic Map): state satisfaction map, regional comparison
- Add cross-page filters (date range, state, category)
- Create Looker calculated fields (NPS categories, delivery status, value buckets)
- Design polish: annotations with key insights on each page, consistent headers
- Peer review and iterate
- **Deliverable:** Complete 5-page dashboard with cross-filtering and polish

### Week 4: Report Writing, Presentation & Final Review
- Write executive report:
  - Methodology (data sources, KPI definitions, limitations)
  - Key findings (5-7 insights with supporting data)
  - Recommendations (actionable improvements for CX team)
- Create 10-15 slide presentation with dashboard screenshots
- Final dashboard QA: verify all numbers match SQL results
- Practice 10-minute presentation
- **Deliverable:** Report (PDF), presentation deck, final dashboard link, SQL query file

---

## F. Data Limitations & Gotchas

| # | Issue | Rule | Impact if Ignored |
|---|-------|------|-------------------|
| 1 | **Customer ID confusion** | Use `customer_unique_id` NOT `customer_id` for customer-level analysis | `customer_id` is per-order, not per-person. Using it inflates unique customer counts |
| 2 | **Order status filter** | Always use `WHERE order_status = 'delivered'` for satisfaction analysis | Including canceled/shipped orders creates mismatched review-to-delivery comparisons |
| 3 | **Not all orders have reviews** | ~98% of delivered orders have reviews, but check coverage | Missing reviews are NOT random — they may skew results |
| 4 | **NULL delivery dates** | Exclude ~2,965 orders with NULL `order_delivered_customer_date` from delivery analysis | Will cause errors in delivery timing calculations |
| 5 | **Review is per ORDER, not per item** | If an order has 3 items from 2 sellers, there's ONE review for the whole order | Cannot attribute satisfaction to individual products or sellers precisely |
| 6 | **Comments are in Portuguese** | Review comment text is in Portuguese — cannot do English NLP | Use comment presence and length as proxies instead of actual sentiment analysis |
| 7 | **No customer demographics** | Only geographic data (state/city) available. No age, income, or profile data | Cannot segment by customer demographics |
| 8 | **Review score is ordinal, not interval** | The "distance" between 1→2 stars may differ from 4→5 stars psychologically | Be cautious interpreting averages — NPS-style bucketing is more robust |
| 9 | **Category translation needed** | Product categories are in Portuguese by default | Join with `product_category_name_translation` for English names |
| 10 | **Date range considerations** | Sep-Dec 2016 has very few reviews (<322 total) | Consider starting trend analysis from Jan 2017 to avoid small-sample distortion |
| 11 | **Delivery estimates are conservative** | Olist pads estimated delivery dates by ~11 days on average | "On-time" rate (92%) is partly an artifact of over-estimation, not operational excellence |
| 12 | **No return/refund data** | Dataset has no returns, refunds, or post-review resolution data | Cannot measure whether complaints were resolved or led to returns |

---

## G. Grading Rubric

### Total: 100 Points

### 1. SQL Query Development & Data Understanding (20 points)

| Grade | Points | Criteria |
|-------|--------|----------|
| A (18-20) | All 12 KPIs computed correctly, clean SQL with CTEs, handles NULLs, uses `customer_unique_id` correctly, documents all limitations |
| B (14-17) | 8-10 KPIs working, most data rules followed, minor edge case issues |
| C (10-13) | 6-8 KPIs, some rules missed (e.g., using `customer_id` instead of `customer_unique_id`) |
| D/F (<10) | Fewer than 6 KPIs, major data errors, queries not validated |

### 2. Dashboard Design & Visual Communication (30 points)

| Grade | Points | Criteria |
|-------|--------|----------|
| A (27-30) | 4-5 pages, professional design, appropriate chart types, clear visual hierarchy, insights annotated on each page |
| B (22-26) | 3-4 pages, good design, mostly appropriate charts, minor labeling gaps |
| C (16-21) | 2-3 pages, basic charts only, inconsistent formatting |
| D/F (<16) | 1-2 pages, poor chart selection, misleading visualizations |

### 3. Interactivity & Technical Execution (20 points)

| Grade | Points | Criteria |
|-------|--------|----------|
| A (18-20) | Global filters (date, state, category), cross-filtering between charts, calculated fields correct, intuitive navigation |
| B (14-17) | Date filter + 1-2 others, some cross-filtering, mostly correct calculated fields |
| C (10-13) | Only date filter, no cross-filtering, calculation errors |
| D/F (<10) | No interactivity, static charts only |

### 4. Business Report (15 points)

| Grade | Points | Criteria |
|-------|--------|----------|
| A (13-15) | Identifies the delivery-satisfaction relationship as the key insight, provides specific actionable recommendations with data backing, addresses limitations honestly |
| B (10-12) | Good findings with data support, recommendations present but somewhat generic |
| C (7-9) | Descriptive rather than analytical, vague recommendations |
| D/F (<7) | Poorly organized, findings not data-supported |

### 5. Presentation & Communication (15 points)

| Grade | Points | Criteria |
|-------|--------|----------|
| A (13-15) | Clear 10-min delivery, narrative structure (problem → analysis → findings → actions), live dashboard demo, confident Q&A |
| B (10-12) | Good delivery, mostly follows narrative, dashboard shown but not demoed live |
| C (7-9) | Reads from slides, no clear story, screenshots only |
| D/F (<7) | Unprepared, cannot explain methodology |

### Bonus Opportunities (up to 5 extra points)
- **+2:** Correlate satisfaction with seller processing speed (cross-reference with seller data)
- **+2:** Build a "Customer Satisfaction Predictor" — identify which order characteristics predict 1-star reviews
- **+1:** Create a month-over-month comparison view showing improvement/decline trends
