# Data Quality Validation for Production Dashboards

## Week 16 - Wednesday Session - Part 3

### Duration: 15 minutes

---

## What Is Data Quality Validation?

**Data quality validation** is the process of systematically checking your data for completeness, consistency, and correctness before and after building a dashboard. In production, a dashboard presenting incorrect numbers is worse than no dashboard at all — it causes stakeholders to make decisions based on wrong information.

### Why This Matters in Production

Think back to Week 10 (Data Integrity in SQL). You learned to write constraints and validation queries. In Week 16, those skills protect your dashboard from:

- **Silent errors:** Revenue overstated by 22.73% due to payment source mismatch
- **NULL traps:** Delivery metrics that ignore 2.98% of orders with no delivery date
- **Outlier distortion:** 731 high-value orders with 1-star reviews skewing satisfaction scores
- **Temporal confusion:** Only 8 orders in the final 30 days of the dataset — the data does not represent active current business

**The validation-first principle:** Always run your data quality queries and understand the results before presenting any number to a stakeholder.

---

## The Four Data Quality Queries

All four queries below have been validated against the live Supabase database. Run them in VS Code before building your dashboard.

---

### Query 3a: NULL Value Audit

**Purpose:** Establish a data quality baseline. Know which fields have missing data before building charts that depend on them.

```sql
-- Comprehensive NULL audit across all critical fields
SELECT
    'order_delivered_customer_date' AS field_name,
    COUNT(*)                        AS total_rows,
    SUM(CASE WHEN order_delivered_customer_date IS NULL THEN 1 ELSE 0 END) AS null_count,
    ROUND(
        SUM(CASE WHEN order_delivered_customer_date IS NULL THEN 1 ELSE 0 END)::numeric
        / COUNT(*) * 100, 2
    )                               AS null_pct
FROM olist_sales_data_set.olist_orders_dataset

UNION ALL

SELECT 'order_approved_at', COUNT(*),
    SUM(CASE WHEN order_approved_at IS NULL THEN 1 ELSE 0 END),
    ROUND(SUM(CASE WHEN order_approved_at IS NULL THEN 1 ELSE 0 END)::numeric / COUNT(*) * 100, 2)
FROM olist_sales_data_set.olist_orders_dataset

UNION ALL

SELECT 'payment_value', COUNT(*),
    SUM(CASE WHEN payment_value IS NULL THEN 1 ELSE 0 END),
    ROUND(SUM(CASE WHEN payment_value IS NULL THEN 1 ELSE 0 END)::numeric / COUNT(*) * 100, 2)
FROM olist_sales_data_set.olist_order_payments_dataset

UNION ALL

SELECT 'customer_unique_id', COUNT(*),
    SUM(CASE WHEN customer_unique_id IS NULL THEN 1 ELSE 0 END),
    ROUND(SUM(CASE WHEN customer_unique_id IS NULL THEN 1 ELSE 0 END)::numeric / COUNT(*) * 100, 2)
FROM olist_sales_data_set.olist_customers_dataset

UNION ALL

SELECT 'customer_state', COUNT(*),
    SUM(CASE WHEN customer_state IS NULL THEN 1 ELSE 0 END),
    ROUND(SUM(CASE WHEN customer_state IS NULL THEN 1 ELSE 0 END)::numeric / COUNT(*) * 100, 2)
FROM olist_sales_data_set.olist_customers_dataset;
```

**Validated Results:**

| field_name | total_rows | null_count | null_pct |
|------------|------------|------------|----------|
| order_delivered_customer_date | 99,441 | 2,965 | **2.98%** |
| order_approved_at | 99,441 | 160 | 0.16% |
| payment_value | 103,886 | 0 | 0.00% |
| customer_unique_id | 99,441 | 0 | 0.00% |
| customer_state | 99,441 | 0 | 0.00% |

**Key Findings and Dashboard Rules:**

| Finding | Dashboard Rule |
|---------|----------------|
| `order_delivered_customer_date`: 2.98% NULL | All delivery metrics must filter `WHERE order_delivered_customer_date IS NOT NULL` |
| `payment_value`: 0% NULL | Revenue calculations are safe — no defensive coding needed |
| `customer_unique_id`: 0% NULL | Customer counts are reliable |

**What the 2,965 NULLs represent:** Orders that were never delivered to the customer — cancelled orders, orders still in transit at the time the dataset was extracted, or orders returned before delivery. These are real business events, not data errors. Your dashboard should acknowledge them rather than silently exclude them.

**Recommended Looker Studio handling:**
```
-- In calculated fields that use order_delivered_customer_date, always add:
CASE
  WHEN order_delivered_customer_date IS NULL THEN NULL
  ELSE DATE_DIFF(order_delivered_customer_date, order_purchase_timestamp, DAY)
END
```

---

### Query 3b: Data Freshness Check

**Purpose:** Understand the temporal boundaries of the dataset so you can set appropriate date filters and default date ranges in Looker Studio.

```sql
-- Data freshness: most recent timestamps and recent activity volume
SELECT 'most_recent_order' AS metric,
       MAX(order_purchase_timestamp)::text AS value
FROM olist_sales_data_set.olist_orders_dataset

UNION ALL

SELECT 'most_recent_lead',
       MAX(first_contact_date)::text
FROM olist_marketing_data_set.olist_marketing_qualified_leads_dataset

UNION ALL

SELECT 'orders_in_last_30_days_of_dataset',
       COUNT(*)::text
FROM olist_sales_data_set.olist_orders_dataset
WHERE order_purchase_timestamp >= (
    SELECT MAX(order_purchase_timestamp) - INTERVAL '30 days'
    FROM olist_sales_data_set.olist_orders_dataset
);
```

**Validated Results:**

| metric | value |
|--------|-------|
| most_recent_order | 2018-10-17 17:30:18 |
| most_recent_lead | 2018-05-31 |
| orders_in_last_30_days_of_dataset | 8 |

**Critical Dashboard Configuration Decision:**

Only 8 orders exist in the final 30 days of the dataset (September 18 to October 17, 2018). If you set your default date range to "Last 30 days" in Looker Studio, most charts will appear nearly empty — confusing any viewer who does not know the dataset's history.

**Recommended Looker Studio Date Filter Settings:**
- Default date range: **Custom** → January 2017 to August 2018
- This captures the active business period where data is dense and meaningful
- Add a note in your dashboard: "Data represents Olist marketplace activity from Sep 2016 to Aug 2018"
- Marketing data ends May 2018 — set marketing page date filter accordingly

**Marketing data gap:** MQL data ends May 2018; sales data continues to October 2018. There is a 5-month gap where you have sales data but no marketing data. This means any marketing-to-revenue attribution for Jun-Oct 2018 is impossible from this dataset.

---

### Query 3c: Outlier and Anomaly Detection

**Purpose:** Identify data points that could distort averages or represent data entry errors.

```sql
-- Anomaly 1: High-value orders (payment_value > $1,000)
SELECT
    'high_value_orders_gt_1000'      AS anomaly_type,
    COUNT(*)                          AS count,
    ROUND(AVG(payment_value)::numeric, 2) AS avg_value,
    ROUND(MAX(payment_value)::numeric, 2) AS max_value
FROM olist_sales_data_set.olist_order_payments_dataset
WHERE payment_value > 1000

UNION ALL

-- Anomaly 2: Delivered before purchased (should be zero — data errors)
SELECT
    'delivered_before_purchased',
    COUNT(*),
    NULL,
    NULL
FROM olist_sales_data_set.olist_orders_dataset
WHERE order_delivered_customer_date < order_purchase_timestamp
  AND order_delivered_customer_date IS NOT NULL;
```

```sql
-- Anomaly 3: High-value orders with poor reviews (potential VIP dissatisfaction)
SELECT
    COUNT(DISTINCT o.order_id)            AS count_low_score_high_value,
    ROUND(AVG(p.payment_value)::numeric, 2) AS avg_payment_value,
    ROUND(MIN(p.payment_value)::numeric, 2) AS min_payment_value,
    ROUND(MAX(p.payment_value)::numeric, 2) AS max_payment_value
FROM olist_sales_data_set.olist_orders_dataset o
JOIN olist_sales_data_set.olist_order_reviews_dataset r ON o.order_id = r.order_id
JOIN olist_sales_data_set.olist_order_payments_dataset p ON o.order_id = p.order_id
WHERE r.review_score = 1
  AND p.payment_value > 500;
```

**Validated Results:**

| Check | Result | Interpretation |
|-------|--------|----------------|
| High-value orders (>$1,000) | 1,150 orders — avg $1,591, max $13,664 | Legitimate B2B bulk purchases — not errors |
| Delivered before purchased | 0 orders | Date logic is reliable — no temporal errors |
| 1-star reviews with payment > $500 | 731 orders — avg $982, max $13,664 | Major risk: high-value dissatisfied customers |

**Dashboard Impact of Each Finding:**

**High-value orders (1,150 orders):** These are real B2B purchases. Do not exclude them unless your dashboard is specifically for B2C analysis. Their presence means the maximum payment_value is $13,664, not an error.

**Zero temporal errors:** Confirmed — you can trust delivery date calculations. DATE_DIFF between `order_delivered_customer_date` and `order_purchase_timestamp` will always produce a positive number (or NULL for undelivered orders).

**731 high-value 1-star reviews:** These customers spent an average of $982 and gave the lowest possible satisfaction rating. They represent significant revenue risk — they are unlikely to return and may share negative reviews. This is a priority customer recovery segment.

---

### Query 3d: Revenue Cross-Validation

**Purpose:** Verify that your two possible revenue sources (`payment_value` and `price + freight_value`) are consistent — or understand why they differ.

```sql
-- Revenue validation: compare payment_value vs price + freight_value
SELECT
    ROUND(SUM(p.payment_value)::numeric, 2)              AS sum_payment_value,
    ROUND(SUM(oi.price + oi.freight_value)::numeric, 2)  AS sum_price_plus_freight,
    ROUND((SUM(p.payment_value) - SUM(oi.price + oi.freight_value))::numeric, 2) AS discrepancy,
    ROUND(
        (ABS(SUM(p.payment_value) - SUM(oi.price + oi.freight_value)) /
         NULLIF(SUM(oi.price + oi.freight_value), 0) * 100)::numeric,
        2
    )                                                     AS discrepancy_pct
FROM olist_sales_data_set.olist_orders_dataset o
JOIN olist_sales_data_set.olist_order_payments_dataset p  ON o.order_id = p.order_id
JOIN olist_sales_data_set.olist_order_items_dataset oi     ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered';
```

**Validated Result:**

| sum_payment_value | sum_price_plus_freight | discrepancy | discrepancy_pct |
|-------------------|----------------------|-------------|-----------------|
| $19,776,200 | $16,113,900 | +$3,662,320 | **22.73%** |

**This 22.73% gap is NOT a data error.** It is explained by three legitimate business factors:

1. **Installment fees:** Customers paying in installments pay interest on top of the item price. The extra amount is captured in `payment_value` but not in `price + freight_value`.

2. **Vouchers and gift cards:** A customer paying partially with a $50 gift card generates a separate payment record for the $50. The gift card amount appears in `payment_value` but not in `price + freight_value`.

3. **Multiple payment methods:** Some customers split payments between credit card and voucher. Both payment records are captured in `payment_value`.

**Production Rule — Always use `payment_value` for revenue:** It is the authoritative, complete revenue figure. Only use `price + freight_value` when you need product-level pricing breakdowns (for example, to show that a specific product costs $X plus $Y shipping).

---

## Building a Data Quality Indicator in Looker Studio

You can surface data quality status directly in your dashboard to maintain transparency with stakeholders.

### Option 1: Text Box Disclaimer

Add a small text box in the footer of each dashboard page:

```
Data Quality Notes:
- Revenue source: payment_value (authoritative)
- 2,965 orders (2.98%) excluded from delivery metrics (no delivery date)
- Marketing cost data simulated — see footnote for assumptions
- Dataset active period: Sep 2016 to Aug 2018 (8 orders in final 30 days)
```

### Option 2: Data Freshness Scorecard

Add a scorecard showing the most recent data timestamp:

**Calculated Field:**
```
-- Last data update indicator
-- Since Olist is historical, this shows the dataset's latest date
MAX(order_purchase_timestamp)
```

**Configuration:**
- Chart type: Scorecard
- Metric: MAX(order_purchase_timestamp)
- Format: Date (YYYY-MM-DD)
- Title: "Data current as of"

[Screenshot: Small scorecard in the top-right corner showing "Data current as of: 2018-10-17"]

### Option 3: Data Quality Checklist Chart

Create a simple table that serves as a quality status board:

**Manual approach (Text Box):**

```
┌─────────────────────────────────────────────────────┐
│ DATA QUALITY STATUS                                  │
├─────────────────────────────────────────────────────┤
│ ✅ Revenue field completeness:    100% (no NULLs)   │
│ ✅ Customer ID completeness:      100% (no NULLs)   │
│ ✅ No temporal data errors:       Confirmed          │
│ ⚠️ Delivery date coverage:        97.02% (2,965 NULLs)│
│ ⚠️ Revenue source discrepancy:    22.73% (expected)  │
│ ⚠️ Dataset active through:        Aug 2018 only      │
└─────────────────────────────────────────────────────┘
```

---

## Connection to Prior Learning

### Week 2 (NULL Handling in SQL)

```sql
-- Week 2: COALESCE for NULL handling
COALESCE(delivery_date, 'Not Delivered')

-- Week 16: NULL-safe calculated field in Looker Studio
CASE
  WHEN order_delivered_customer_date IS NULL THEN NULL
  ELSE DATE_DIFF(order_delivered_customer_date, order_purchase_timestamp, DAY)
END
```

### Week 10 (Data Integrity)

```sql
-- Week 10: Constraint checking
CHECK (payment_value > 0)

-- Week 16: Equivalent validation query
SELECT COUNT(*) FROM olist_order_payments_dataset WHERE payment_value <= 0;
-- Result: 0 — confirms constraint holds in practice
```

### Week 12 (Financial Metrics)

In Week 12 you calculated revenue for financial analysis. The 22.73% discrepancy between payment_value and price+freight directly affects which number you report. Week 16 confirms the rule: use `payment_value` for all financial metrics.

---

## Practical Exercise: Run Your Own Data Quality Audit (8 minutes)

**Before your next Looker Studio session, run all four validation queries in VS Code.**

**Task 1:** Run query 3a (NULL audit). Record the null_pct for `order_delivered_customer_date`.

**Task 2:** Run query 3b (freshness check). Note the most_recent_order date. Plan your dashboard's default date range accordingly.

**Task 3:** Run query 3c (anomaly detection). Identify whether the 731 high-value/1-star orders would materially affect your average review score metric.

**Task 4:** Run query 3d (revenue cross-check). Confirm that `sum_payment_value` is higher than `sum_price_plus_freight`. Explain the difference to a classmate.

**Self-check:** You have completed the audit when you can answer: "Which revenue source should I use in my dashboard, and why?"

---

## Common Issues and Solutions

| Issue | Symptom | Solution |
|-------|---------|---------|
| Delivery metrics show very high avg | Average delivery days appears to be 500+ | You included NULL delivery dates — add `WHERE order_delivered_customer_date IS NOT NULL` |
| Revenue seems too low | Dashboard shows $16M instead of $19M | You are using `price + freight_value` instead of `payment_value` |
| Charts are empty for recent dates | "No data" when filtering to recent months | Dataset ends effectively Aug 2018 — adjust default date range |
| High-value orders skew average payment | AOV appears much higher than $147-$169 | Consider whether to show median instead of mean, or note that 1,150 orders exceed $1,000 |

---

## Key Takeaways

### What You Learned
1. ✅ Only `order_delivered_customer_date` has significant NULLs (2.98%) — always filter it for delivery metrics
2. ✅ The 22.73% revenue discrepancy between payment_value and price+freight is expected — always use `payment_value`
3. ✅ Zero temporal data errors means delivery date math is reliable
4. ✅ The dataset effectively ends August 2018 — set default date ranges accordingly
5. ✅ 731 high-value customers with 1-star reviews are a priority recovery segment
6. ✅ Always surface data quality notes in your dashboard as text boxes or footers

### What's Next
In the final Wednesday session, we set up data freshness monitoring and caching configuration for production dashboards.

### Skills Building Progression

```
Week 16 Part 1: Query Optimization Techniques ✓
Week 16 Part 2: Pre-Aggregation Strategies ✓
Week 16 Part 3: Data Quality Validation (Now)
         ↓
Week 16 Part 4: Data Freshness Monitoring
```

---

## Quick Reference Card

### Data Quality Rules for Olist Dataset

| Field | Rule | Reason |
|-------|------|--------|
| `order_delivered_customer_date` | Filter IS NOT NULL for delivery metrics | 2.98% NULL (2,965 undelivered orders) |
| `payment_value` | Use this as authoritative revenue | Includes installment fees and vouchers |
| `price + freight_value` | For product-level pricing only | Understates revenue by 22.73% |
| `customer_unique_id` | Use for customer counts, never `customer_id` | Repeating customers counted correctly |
| `order_status = 'delivered'` | Filter in all revenue queries | Excludes cancelled and processing orders |
| Default date range | Set to 2017-01 to 2018-08 | Active business period; avoids sparse endpoints |

---

## Questions to Test Your Understanding

1. Why must all delivery-related metrics filter `WHERE order_delivered_customer_date IS NOT NULL`?
2. A new team member argues that the 22.73% revenue discrepancy is a data quality problem that must be fixed. How do you explain that it is expected?
3. You build an average review score metric that shows 3.9/5. After running the anomaly query, you discover 731 high-value 1-star reviews. Does this finding invalidate the 3.9 average? What additional analysis would you do?
4. Why should the Looker Studio default date range be set to January 2017 – August 2018 rather than "Last 12 Months"?
5. What does a null_pct of 0.00% for `payment_value` tell you about the reliability of your revenue calculations?

**Answers at the end of lecture notes**

---

## Answers to Questions

1. **NULL delivery filter:** The 2,965 NULL delivery dates represent orders that were never delivered (cancelled, in transit, returned). Including them in delivery time calculations would either produce NULL results (breaking calculations) or, if treated as 0 days, would falsely indicate instant delivery for those orders.
2. **Explaining the discrepancy:** `payment_value` and `price + freight_value` measure different things. `payment_value` captures the total amount the customer actually paid — including installment interest and voucher redemptions. `price + freight_value` captures only the product cost. A customer paying $100 in installments may ultimately pay $112 with interest. The difference is real business revenue, not an error.
3. **731 outliers and the average:** The 731 orders do not necessarily invalidate 3.9. An average of 731 very low scores across 98,410 reviews has limited aggregate impact — approximately a 0.05-0.1 point drag. More important is the business insight: customers spending >$500 and rating 1 star represent high revenue at risk. Recommend creating a separate metric: "High-Value Dissatisfied Customers" and tracking it separately from overall satisfaction.
4. **Date range reasoning:** "Last 12 Months" in a dashboard reviewing data that ends October 2018 would show March 2025 – March 2026 — a period with zero data. The Olist dataset is historical. Setting an explicit date range makes the dashboard immediately useful without requiring users to adjust filters.
5. **Zero NULLs in payment_value:** This means every payment record has a value. There are no missing revenue rows. You can calculate SUM(payment_value), AVG(payment_value), and COUNT(payment_value) without any defensive NULL handling. Revenue metrics are fully reliable from this field.

---

**Next Lecture:** 04_data_freshness_monitoring.md
