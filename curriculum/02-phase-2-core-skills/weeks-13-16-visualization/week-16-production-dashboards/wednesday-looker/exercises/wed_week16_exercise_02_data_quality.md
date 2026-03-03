# Exercise 2: Data Quality Validation and Monitoring

## Week 16 - Wednesday - Exercise 2

### Estimated Time: 30 minutes

---

## Objective

Run all four data quality validation queries against the live Supabase database, document your findings, and add data quality indicators to your Looker Studio dashboard. You will also use the findings to set correct default date ranges and handle the dataset's known limitations professionally.

---

## Prerequisites

Before starting, ensure you have:
- ✅ Completed Wednesday Exercise 1 (Performance Audit)
- ✅ VS Code connected to Supabase (SQL queries ready to run)
- ✅ Completed Wednesday Lectures 3 and 4 (Data Quality + Data Freshness)
- ✅ Your optimized dashboard from Exercise 1 is open in Looker Studio

---

## Business Context

**Your Role:** BI Analyst preparing the Olist dashboard for hand-off to the executive team.

**The Situation:** Before presenting to executives on Friday, you need to certify that the dashboard is production-ready. That certification requires a documented data quality audit — evidence that you have checked for NULLs, temporal errors, outliers, and revenue consistency.

**Deliverable:** A completed data quality report that becomes part of your dashboard documentation.

---

## Instructions

### Part 1: Run All Four Validation Queries

#### Task 1.1: NULL Value Audit

Run the following query in VS Code against Supabase:

```sql
-- NULL audit: establish data quality baseline
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

**Record your results:**

| field_name | total_rows | null_count | null_pct | Dashboard Rule |
|------------|------------|------------|----------|----------------|
| order_delivered_customer_date | | | | |
| order_approved_at | | | | |
| payment_value | | | | |
| customer_unique_id | | | | |
| customer_state | | | | |

**Expected results:**
- `order_delivered_customer_date`: 2,965 NULLs (2.98%) — significant
- All other fields: 0 NULLs — fully populated

**For each field with NULLs, write the rule you will apply in your dashboard:**
```
Field: order_delivered_customer_date
Dashboard rule: ___________________________________
```

---

#### Task 1.2: Data Freshness Check

```sql
-- Data freshness: temporal boundaries and recent activity
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

**Record your results:**

| metric | value |
|--------|-------|
| most_recent_order | |
| most_recent_lead | |
| orders_in_last_30_days_of_dataset | |

**Based on these results, decide your default date range for each dashboard page:**

```
Executive Summary page default date range: _____ to _____
Marketing page default date range: _____ to _____
Reason: ________________________________________________
```

---

#### Task 1.3: Outlier and Anomaly Detection

**Run Query A (high-value orders and temporal errors):**

```sql
-- Anomaly checks
SELECT
    'high_value_orders_gt_1000'      AS anomaly_type,
    COUNT(*)                          AS count,
    ROUND(AVG(payment_value)::numeric, 2) AS avg_value,
    ROUND(MAX(payment_value)::numeric, 2) AS max_value
FROM olist_sales_data_set.olist_order_payments_dataset
WHERE payment_value > 1000

UNION ALL

SELECT
    'delivered_before_purchased',
    COUNT(*),
    NULL,
    NULL
FROM olist_sales_data_set.olist_orders_dataset
WHERE order_delivered_customer_date < order_purchase_timestamp
  AND order_delivered_customer_date IS NOT NULL;
```

**Run Query B (high-value dissatisfied customers):**

```sql
-- High-value orders with 1-star reviews
SELECT
    COUNT(DISTINCT o.order_id)            AS count_low_score_high_value,
    ROUND(AVG(p.payment_value)::numeric, 2) AS avg_payment_value,
    ROUND(MAX(p.payment_value)::numeric, 2) AS max_payment_value
FROM olist_sales_data_set.olist_orders_dataset o
JOIN olist_sales_data_set.olist_order_reviews_dataset r ON o.order_id = r.order_id
JOIN olist_sales_data_set.olist_order_payments_dataset p ON o.order_id = p.order_id
WHERE r.review_score = 1
  AND p.payment_value > 500;
```

**Record your results:**

| Anomaly Check | Count | Avg Value | Max Value | Interpretation |
|---------------|-------|-----------|-----------|----------------|
| High-value orders (>$1,000) | | | | |
| Delivered before purchased | | | | |
| 1-star reviews with payment > $500 | | | | |

**Dashboard impact of each finding:**
```
High-value orders: Include / Exclude / Flag? Why?
_______________________________________________________

Temporal errors: Does this affect date calculations? Why?
_______________________________________________________

High-value 1-star reviews: What action should Olist take?
_______________________________________________________
```

---

#### Task 1.4: Revenue Cross-Validation

```sql
-- Revenue cross-validation: payment_value vs price + freight_value
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

**Record your results:**

| sum_payment_value | sum_price_plus_freight | discrepancy | discrepancy_pct |
|-------------------|----------------------|-------------|-----------------|
| | | | |

**Explain the discrepancy in plain language (write your explanation here — do not copy from the lecture):**
```
The discrepancy of _____% exists because:
1. _______________________________________________
2. _______________________________________________
3. _______________________________________________

Which figure should the dashboard use for revenue, and why?
_______________________________________________
```

---

### Part 2: Apply Findings to Your Dashboard

#### Task 2.1: Fix Default Date Range

Based on your freshness check findings:

1. Open your dashboard in **Edit mode**
2. Click on your Date Range control (if you have one)
3. In the Data tab, find **"Default date range"**
4. Set to **"Custom"**:
   - Start date: **2017-01-01**
   - End date: **2018-08-31**
5. For your marketing page (if separate): set to **2017-06-01** to **2018-05-31**
6. Click **"Apply"**
7. Verify that charts are now populated and not empty

**Record:**
```
Date range updated: Yes / No
Charts now show data: Yes / No
Any pages still empty after adjustment: ____________________________
```

#### Task 2.2: Add NULL Handling to Delivery Calculated Fields

If your dashboard has a calculated field for delivery days, verify it handles NULLs correctly:

**Find your delivery days field:**
1. Resource → Manage added data sources → Edit → Find "Delivery_Days" or similar field

**If the formula is this (missing NULL handling):**
```
DATE_DIFF(order_delivered_customer_date, order_purchase_timestamp, DAY)
```

**Update it to this (NULL-safe):**
```
CASE
  WHEN order_delivered_customer_date IS NULL THEN NULL
  ELSE DATE_DIFF(order_delivered_customer_date, order_purchase_timestamp, DAY)
END
```

**Verify the fix:**
- Average delivery days should be approximately 12-15 days (not a huge unrealistic number)
- If it was showing 500+ days before the fix, that confirmed NULLs were being treated as zero dates

**Record:**
```
NULL handling added to delivery calculation: Yes / No / Was already correct
Average delivery days after fix: _______ days
```

#### Task 2.3: Add Data Quality Status Panel

Create a visible data quality status panel on your main dashboard page:

1. In Looker Studio, add a **Rectangle** shape (Insert → Shape → Rectangle)
2. Size: approximately 280px wide × 200px tall
3. Style: Light gray background (#F5F5F5), 1px solid border (#CCCCCC)
4. Position: Bottom right of the main page (so it does not obstruct key charts)

5. Inside the rectangle, add a **Text Box** with:

```
DATA QUALITY STATUS
As of: [Today's date]

✅ Revenue completeness: 100%
✅ Customer ID completeness: 100%
✅ No temporal data errors

⚠️ Delivery date coverage: 97.02%
   (2,965 orders excluded)

⚠️ Revenue note: payment_value
   used (22.73% above price+freight —
   expected, see documentation)

⚠️ Marketing costs: SIMULATED
   (real data unavailable)
```

6. Style: 10-11px font, dark gray (#333333) text

[Screenshot: Small data quality status panel in the bottom right corner of the dashboard]

**Record:**
```
Data quality panel added: Yes / No
Panel positioned on page: ___________________________
```

---

### Part 3: Validate Final Metric Queries

Run three of the five final project metric queries to confirm the key numbers in your dashboard match the database.

#### Task 3.1: CLV Tier Distribution (Final Project Metric 4a)

```sql
-- CLV Tier distribution for validation
WITH customer_revenue AS (
    SELECT
        c.customer_unique_id,
        ROUND(SUM(p.payment_value)::numeric, 2)  AS total_spend
    FROM olist_sales_data_set.olist_customers_dataset c
    JOIN olist_sales_data_set.olist_orders_dataset o
        ON c.customer_id = o.customer_id
    JOIN olist_sales_data_set.olist_order_payments_dataset p
        ON o.order_id = p.order_id
    WHERE o.order_status = 'delivered'
    GROUP BY c.customer_unique_id
)
SELECT
    CASE
        WHEN total_spend > 5000 THEN 'Premium'
        WHEN total_spend > 2000 THEN 'High'
        WHEN total_spend > 500  THEN 'Medium'
        ELSE 'Standard'
    END AS clv_tier,
    COUNT(*)                                AS customer_count,
    ROUND(AVG(total_spend)::numeric, 2)     AS avg_spend
FROM customer_revenue
GROUP BY clv_tier
ORDER BY avg_spend DESC;
```

**Expected results to verify:**
- Premium (>$5K): 7 customers
- High ($2K-$5K): approximately 200 customers
- Medium ($500-$2K): approximately 4,058 customers
- Standard (≤$500): approximately 89,092 customers

**Record your results:**

| clv_tier | customer_count | avg_spend | Matches Expected? |
|----------|---------------|-----------|-------------------|
| Premium | | | |
| High | | | |
| Medium | | | |
| Standard | | | |

#### Task 3.2: MoM Financial KPI (Final Project Metric 4c — selected months)

```sql
-- Financial KPI: Aug 2018 MoM growth check
WITH monthly_revenue AS (
    SELECT
        TO_CHAR(o.order_purchase_timestamp, 'YYYY-MM') AS year_month,
        ROUND(SUM(p.payment_value)::numeric, 2)        AS revenue
    FROM olist_sales_data_set.olist_orders_dataset o
    JOIN olist_sales_data_set.olist_order_payments_dataset p
        ON o.order_id = p.order_id
    WHERE o.order_status = 'delivered'
    GROUP BY TO_CHAR(o.order_purchase_timestamp, 'YYYY-MM')
)
SELECT
    year_month,
    revenue,
    LAG(revenue) OVER (ORDER BY year_month) AS prev_month_revenue,
    CASE
        WHEN LAG(revenue) OVER (ORDER BY year_month) > 0 THEN
            ROUND(
                (revenue - LAG(revenue) OVER (ORDER BY year_month)) /
                LAG(revenue) OVER (ORDER BY year_month) * 100,
                2
            )
        ELSE NULL
    END AS mom_growth_pct
FROM monthly_revenue
WHERE year_month IN ('2018-06', '2018-07', '2018-08')
ORDER BY year_month;
```

**Expected results:**
- 2018-07: approximately $1,027,900 → 2018-08: approximately $985,414 → MoM growth: -4.13%

**Record your results:**

| year_month | revenue | mom_growth_pct | Matches Expected? |
|------------|---------|----------------|-------------------|
| 2018-06 | | | |
| 2018-07 | | | |
| 2018-08 | | | |

#### Task 3.3: Delivery Performance Distribution (Final Project Metric 4e)

```sql
-- Delivery performance vs estimated date
WITH delivery_perf AS (
    SELECT
        o.order_id,
        DATE_PART('day',
            o.order_delivered_customer_date - o.order_estimated_delivery_date
        ) AS days_late,
        CASE
            WHEN o.order_delivered_customer_date <= o.order_estimated_delivery_date THEN 'On Time'
            WHEN DATE_PART('day',
                     o.order_delivered_customer_date - o.order_estimated_delivery_date
                 ) BETWEEN 1 AND 7 THEN 'Slightly Late'
            WHEN DATE_PART('day',
                     o.order_delivered_customer_date - o.order_estimated_delivery_date
                 ) BETWEEN 8 AND 30 THEN 'Very Late'
            WHEN DATE_PART('day',
                     o.order_delivered_customer_date - o.order_estimated_delivery_date
                 ) > 30 THEN 'Extremely Late'
            ELSE 'Unknown'
        END AS delivery_category
    FROM olist_sales_data_set.olist_orders_dataset o
    WHERE o.order_delivered_customer_date IS NOT NULL
      AND o.order_estimated_delivery_date IS NOT NULL
      AND o.order_status = 'delivered'
)
SELECT
    delivery_category,
    COUNT(*)                               AS order_count,
    ROUND(AVG(days_late)::numeric, 1)      AS avg_days_late
FROM delivery_perf
GROUP BY delivery_category
ORDER BY
    CASE delivery_category
        WHEN 'On Time'        THEN 1
        WHEN 'Slightly Late'  THEN 2
        WHEN 'Very Late'      THEN 3
        WHEN 'Extremely Late' THEN 4
        ELSE 5
    END;
```

**Expected results:**
- On Time: approximately 92,623 orders (92%)
- Slightly Late: approximately 3,805 orders
- Very Late: approximately 2,621 orders
- Extremely Late: approximately 360 orders

**Record your results:**

| delivery_category | order_count | avg_days_late | Matches Expected? |
|-----------------|-------------|---------------|-------------------|
| On Time | | | |
| Slightly Late | | | |
| Very Late | | | |
| Extremely Late | | | |

**Important insight to note:**
```
The "On Time" category average_days_late is: _____ days

This is a negative number because: ____________________________________
___________________________________________________________________

Business implication: _______________________________________________
```

---

### Part 4: Document Your Findings

#### Task 4.1: Complete Your Data Quality Report

Using the results from all tasks above, complete the data quality section of your dashboard documentation:

```
DATA QUALITY AUDIT REPORT
Dashboard: [Your dashboard name]
Audit Date: [Today's date]
Analyst: [Your name]

NULL ANALYSIS:
- Critical fields all fully populated (payment_value, customer_unique_id, customer_state)
- order_delivered_customer_date: [your null_count] NULLs ([your null_pct]%)
- Mitigation: Delivery metrics filter WHERE order_delivered_customer_date IS NOT NULL

TEMPORAL VALIDITY:
- Zero orders delivered before purchased (confirmed: no data errors)
- Active data period: [your most_recent_order result]
  Effectively ends: August 2018 (only 8 orders in final 30 days)

REVENUE ACCURACY:
- Authoritative source: SUM(payment_value) = $[your sum_payment_value]
- Alternative source: SUM(price + freight) = $[your sum_price_plus_freight]
- Discrepancy: [your discrepancy_pct]% (expected — installments, vouchers)
- Dashboard uses: payment_value (authoritative)

OUTLIER NOTES:
- 1,150 high-value orders (>$1,000) — legitimate B2B purchases, included
- 731 orders: high-value + 1-star review — priority recovery segment
- Max single order: $13,664 — real B2B transaction, not an error

KEY METRIC VALIDATION:
- CLV Tier distribution: matches expected
- MoM Aug 2018: -4.13% (revenue $985,414 from $1,027,900 in July)
- Delivery: 92% On Time vs estimated (Olist uses conservative estimates)

DASHBOARD CONFIGURATION CHANGES MADE:
- Default date range set to Jan 2017 – Aug 2018
- NULL handling added to delivery calculations
- Data quality status panel added to main page
```

---

## Submission Checklist

```
☐ NULL audit query run — results recorded with all 5 fields
☐ Freshness check query run — date boundaries documented
☐ Outlier detection queries run — all 3 checks completed
☐ Revenue cross-validation run — discrepancy calculated and explained
☐ Default date range updated in dashboard
☐ NULL handling verified in delivery calculated fields
☐ Data quality status panel added to dashboard
☐ CLV tier validation query run — results match expected
☐ MoM financial KPI query run — August -4.13% confirmed
☐ Delivery performance query run — 92% On Time confirmed
☐ Data quality audit report completed (Task 4.1)
```

---

## Troubleshooting

### Issue 1: "UNION ALL" query shows different total_rows for each field

**Explanation:** This is expected. Each UNION ALL section queries a different table — orders, payments, customers — which have different record counts (99,441; 103,886; 99,441 respectively).

### Issue 2: Delivery performance shows 100% "On Time"

**Symptom:** All orders categorized as On Time

**Cause:** Likely missing the NULL filters. The CASE statement needs `order_delivered_customer_date IS NOT NULL` to exclude undelivered orders.

**Solution:** Confirm the WHERE clause in your delivery query includes both:
```sql
WHERE o.order_delivered_customer_date IS NOT NULL
  AND o.order_estimated_delivery_date IS NOT NULL
```

### Issue 3: CLV tier query returns more customers than expected

**Cause:** Using `customer_id` instead of `customer_unique_id` for grouping. A returning customer gets a new `customer_id` for each order but has the same `customer_unique_id`.

**Solution:** Verify the GROUP BY and JOIN use `customer_unique_id` in the CTE.

### Issue 4: Revenue cross-validation total does not match expected

**Symptom:** Your `sum_payment_value` is different from the expected ~$19.8M

**Cause:** Query may not be filtering correctly. Verify:
1. `WHERE o.order_status = 'delivered'` is in the query
2. No additional filters are applied
3. All three tables are correctly joined

---

## Expected Outcomes

After completing this exercise, your dashboard should:
- Show realistic delivery performance (92% On Time vs estimated)
- Display correct revenue figures (matching validated SQL results)
- Have a visible data quality status panel
- Default to the active data period (Jan 2017 – Aug 2018)
- Handle NULL delivery dates correctly in all calculations

Your data quality audit report should be complete enough to include as Section 3 of your final project documentation.

---

## How to Know You Succeeded

✅ **NULL test:** You can explain which fields have NULLs and why, from memory

✅ **Freshness test:** Your dashboard default date range excludes the sparse startup period and the tail-off period

✅ **Revenue test:** You can state confidently: "This dashboard uses payment_value, which is 22.73% higher than price+freight — this is expected because of installments and vouchers"

✅ **Outlier test:** You know that the top seller (highest revenue) has the lowest review score — and can explain the business implication

✅ **Delivery insight:** You can explain why 92% "On Time" vs estimated date actually means Olist set very conservative estimates (average 12.7 days early)

---

## Reflection Questions

1. **The delivery performance result (92% On Time) seems much better than what you learned in Week 15 (75% delayed). These are not contradictory. Can you explain how both can be correct simultaneously?**

2. **A financial controller asks: "Why does your dashboard show $19.8M in revenue but the accounting system shows $16.1M?" How would you respond?**

3. **You found 731 high-value orders (>$500) that received 1-star reviews. What specific Looker Studio visualization would you build to monitor and action this customer segment?**

4. **If you were building this dashboard for a real company (not the Olist historical dataset), how would you automate the data quality audit so it runs automatically each time the data refreshes?**

5. **Looking at the delivery performance categories: "On Time" orders arrive on average 12.7 days before the estimated date. Should Olist change their delivery estimates to be more accurate? What would be the business benefit and risk of doing so?**

---

## Next Steps

Once completed:
1. **Save the completed audit report** to your notes — it becomes your documentation
2. **Share your dashboard** with a classmate and ask them to verify one metric against SQL
3. **Proceed to Thursday's session** — Sharing, Deployment, and Documentation

---

## Additional Challenge (Optional)

### Challenge: Build a Live Data Quality Dashboard Page

Add a dedicated "Data Quality" page to your report that displays:

1. **NULL Rate Scorecard** — Shows 2.98% with red conditional formatting (any NULL rate > 0 for critical fields)
2. **Revenue Source Comparison Table** — Two rows: `payment_value` and `price+freight`, showing the 22.73% difference
3. **Dataset Date Range Indicator** — Scorecard showing "Data: Sep 2016 – Oct 2018 (Active: Jan 2017 – Aug 2018)"
4. **High-Value Dissatisfied Customers Metric** — Scorecard: "731 customers: spent >$500, rated 1 star — priority recovery"

This "data quality audit dashboard" within your dashboard is a mark of professional-grade work. It demonstrates that you understand and communicate data limitations — not just data insights.

---

**Instructor Note:** The key insight in this exercise is the delivery performance finding. Students who learned in Week 15 that "75% of orders are delayed" may be confused to see "92% On Time" here. These use different benchmarks: Week 15's metric was "delivered in over 7 days from order date" (many categories of delay), while this query measures "delivered before Olist's estimated date" (which Olist set conservatively). Both numbers are correct. Help students understand that a metric is only meaningful when you understand exactly what it is measuring — and that two metrics about the same thing can tell very different stories depending on the benchmark used.
