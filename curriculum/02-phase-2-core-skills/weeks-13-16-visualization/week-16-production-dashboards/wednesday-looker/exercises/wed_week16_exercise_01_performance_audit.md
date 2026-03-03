# Exercise 1: Dashboard Performance Audit

## Week 16 - Wednesday - Exercise 1

### Estimated Time: 30 minutes

---

## Objective

Evaluate the performance of your existing dashboard from Weeks 13-15, identify optimization opportunities, implement at least two performance improvements, and document before/after performance metrics. You will also run the validated optimization queries to confirm revenue accuracy.

---

## Prerequisites

Before starting, ensure you have:
- ✅ Completed Weeks 13-15 exercises — you have an existing Looker Studio dashboard to audit
- ✅ VS Code connected to Supabase (postgresql connection active)
- ✅ Completed Wednesday Lectures 1 and 2 (Query Optimization + Pre-Aggregation)
- ✅ Access to the Week 16 validation report (validation-report.md)

---

## Business Context

**Your Role:** Senior BI Analyst at a consultancy that has been handed an Olist dashboard built by a junior analyst who is on leave.

**Your Task:** The dashboard has been reported as "slow and possibly showing wrong revenue numbers." You need to:
1. Measure the current load time
2. Identify the root cause of any revenue discrepancy
3. Implement optimizations
4. Document the improvements for the client

This is a real-world audit scenario — the same process you would follow when inheriting any production dashboard.

---

## Instructions

### Part 1: Baseline Performance Measurement

#### Task 1.1: Measure Current Dashboard Load Time

1. Open your existing Olist dashboard from Week 14 or 15 in Looker Studio
2. Navigate to a page with 6+ charts
3. Use browser developer tools to measure load time:
   - Press F12 (or Cmd+Option+I on Mac) to open developer tools
   - Click the **Network** tab
   - Hard refresh the page: **Ctrl+Shift+R** (or Cmd+Shift+R on Mac)
   - Look for the total load time in the bottom status bar
   - Record the time

4. Alternatively, use a simple stopwatch:
   - Close all tabs and clear cache: Settings → Privacy → Clear browsing data → Cached images and files
   - Reopen the dashboard and start your stopwatch
   - Stop when all charts finish loading
   - Record the time

**Record in your audit log:**
```
Current load time: _____ seconds
Number of charts on page: _____
Data source type: Live / Extract (circle one)
Using raw tables: Yes / No (circle one)
```

#### Task 1.2: Check Current Data Source Configuration

1. In Looker Studio: **Resource** → **Manage added data sources**
2. For each data source, record:

```
Data Source 1:
  Name: _______________________________________________
  Type: Direct table / Custom SQL (circle one)
  Extract configured: Yes / No
  Refresh schedule: ___________________________________

Data Source 2 (if applicable):
  Name: _______________________________________________
  Type: Direct table / Custom SQL (circle one)
  Extract configured: Yes / No
```

**Flag any data source connected directly to a raw table** (not a custom SQL query). These are the primary performance targets.

---

### Part 2: Revenue Accuracy Audit

This is the most critical part of the audit — confirming that the revenue figures in your dashboard are correct.

#### Task 2.1: Run the "Before" Query (The Inflated Version)

Open VS Code (connected to Supabase) and run:

```sql
-- BEFORE: Potentially inflated revenue (joins order_items without pre-aggregation)
SELECT
    c.customer_state,
    COUNT(DISTINCT o.order_id)  AS order_count,
    SUM(p.payment_value)        AS total_revenue_before,
    AVG(p.payment_value)        AS avg_order_value_before
FROM olist_sales_data_set.olist_orders_dataset o
JOIN olist_sales_data_set.olist_customers_dataset c
    ON o.customer_id = c.customer_id
JOIN olist_sales_data_set.olist_order_payments_dataset p
    ON o.order_id = p.order_id
JOIN olist_sales_data_set.olist_order_items_dataset oi
    ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered'
GROUP BY c.customer_state
ORDER BY total_revenue_before DESC;
```

**Record the São Paulo revenue from this query:**
```
BEFORE query — SP total_revenue: $_______________
```

#### Task 2.2: Run the "After" Query (The Correct Version)

```sql
-- AFTER: Correct revenue using CTE pre-aggregation
WITH delivered_orders AS (
    SELECT order_id, customer_id
    FROM olist_sales_data_set.olist_orders_dataset
    WHERE order_status = 'delivered'
),
order_revenue AS (
    SELECT order_id, SUM(payment_value) AS order_revenue
    FROM olist_sales_data_set.olist_order_payments_dataset
    GROUP BY order_id
),
customer_states AS (
    SELECT customer_id, customer_state
    FROM olist_sales_data_set.olist_customers_dataset
)
SELECT
    cs.customer_state,
    COUNT(DISTINCT d.order_id)               AS order_count,
    ROUND(SUM(r.order_revenue)::numeric, 2)  AS total_revenue_after,
    ROUND(AVG(r.order_revenue)::numeric, 2)  AS avg_order_value_after
FROM delivered_orders d
JOIN order_revenue r    ON d.order_id = r.order_id
JOIN customer_states cs ON d.customer_id = cs.customer_id
GROUP BY cs.customer_state
ORDER BY total_revenue_after DESC;
```

**Record the São Paulo revenue from this query:**
```
AFTER query — SP total_revenue: $_______________
```

#### Task 2.3: Calculate the Inflation

```
Revenue difference: BEFORE ($________) - AFTER ($________) = $________
Inflation percentage: difference / AFTER × 100 = _______%
```

**Expected finding:** Your BEFORE figure should be approximately 28% higher than AFTER (approximately $7.4M vs $5.77M for SP).

**Record your finding:**
```
My dashboard is currently showing: ☐ Correct revenue  ☐ Inflated revenue
Evidence: _______________________________________________
```

---

### Part 3: Implement Two Optimizations

Choose at least 2 of the following optimizations and implement them in your dashboard.

#### Optimization A: Replace Raw Table with Custom SQL Data Source

**Before:** Dashboard connected to `olist_orders_dataset` (raw table, 99,441 rows)

**After:** Dashboard connected to the pre-aggregated Executive Summary query (26 rows)

**Steps:**
1. In Looker Studio: **Resource** → **Manage added data sources**
2. Click **Add a data source**
3. Select **PostgreSQL** → connect to Supabase
4. Click **Custom query**
5. Paste the Executive Summary pre-aggregated query (Query 2a from the lecture)
6. Click **Connect**
7. Name it: "Olist Monthly Executive KPIs"
8. Update your revenue and order count charts to use this new data source
9. Verify the SP total_revenue shown in charts matches the AFTER query result

**Record:**
```
Optimization A implemented: Yes / No
Data source replaced: _________________________________
Charts updated to use new source: ___________________
```

#### Optimization B: Configure Extract Data Source

**Before:** Live connection (queries Supabase on every dashboard load)

**After:** Extract connection (cached results, sub-2-second loads)

**Steps:**
1. Edit your primary data source (Resource → Manage added data sources → Edit)
2. Click **"Extract data"** tab
3. Click **"Scheduled refresh"** → Weekly → Sunday → 6:00 AM
4. Click **"Save"**
5. Click **"Refresh now"** to run the first extract
6. Wait for "Extract refreshed successfully" confirmation
7. Reload your dashboard and measure load time again

**Record:**
```
Optimization B implemented: Yes / No
Extract configured for: ______________________________
New load time after Extract: _____ seconds
Improvement: _____ seconds faster
```

#### Optimization C: Reduce Charts Per Page

**Before:** More than 8 charts on a single page

**After:** 6-8 charts on the main page, others moved to a dedicated deep-dive page

**Steps:**
1. Identify which charts on your main page are "secondary" (supporting details rather than headline metrics)
2. Add a new page: "Details"
3. Move secondary charts to the Details page
4. Verify the main page has 6-8 charts maximum
5. Add navigation text or buttons to link between pages

**Record:**
```
Optimization C implemented: Yes / No
Charts moved to secondary page: _____________________
Main page chart count before: _____  After: _____
```

#### Optimization D: Add Data Quality Indicators

**Before:** No indication of NULL handling or data quality status

**After:** Visible data quality note visible to all viewers

**Steps:**
1. Add a text box at the bottom of each page
2. Enter the following text (update with your actual findings from Task 1):
```
Data Quality Notes:
- Revenue: SUM(payment_value) — authoritative (0% NULL)
- Delivery metrics exclude 2,965 undelivered orders (2.98%)
- Marketing cost data is SIMULATED — not real figures
- Active data period: Jan 2017 – Aug 2018
```
3. Style: 10px font, gray (#757575), positioned in the bottom margin

**Record:**
```
Optimization D implemented: Yes / No
Notes added to pages: ___________________________
```

---

### Part 4: Re-Measure Performance

After implementing your chosen optimizations:

#### Task 4.1: Measure New Load Time

Repeat the measurement from Task 1.1 using the same method.

```
After optimization:
Load time: _____ seconds
Number of charts on page: _____
Improvement vs baseline: _____ seconds faster
```

#### Task 4.2: Compare Revenue Accuracy

Confirm that your dashboard now shows the correct SP revenue:

```
Dashboard now shows SP revenue: $________________
Matches AFTER query ($5,770,360): Yes / No
```

---

### Part 5: Write a Brief Audit Report (5 minutes)

In a text document or the class chat, write a 3-5 sentence audit summary for the "client":

**Template:**
```
DASHBOARD PERFORMANCE AUDIT REPORT
Date: [Today's date]
Analyst: [Your name]

FINDINGS:
The dashboard loaded in [X] seconds initially.
[Describe the revenue issue found — was revenue inflated? By how much?]
[Describe the root cause — e.g., "unoptimized join inflated revenue by 28%"]

ACTIONS TAKEN:
[List the 2+ optimizations implemented]

RESULTS:
After optimization, dashboard loads in [X] seconds ([Y]% improvement).
Revenue now correctly shows $5,770,360 for São Paulo (previously $7,404,140 — 28% inflated).
Data quality notes added to all pages.
```

---

## Submission Checklist

Before marking complete:

```
☐ Baseline load time recorded
☐ Data source configuration documented
☐ BEFORE query run — São Paulo inflated revenue recorded
☐ AFTER query run — São Paulo correct revenue recorded
☐ Revenue inflation percentage calculated
☐ At least 2 optimizations implemented
☐ Post-optimization load time recorded
☐ Revenue verified as correct in dashboard
☐ Audit report written (3-5 sentences)
```

---

## Troubleshooting

### Issue 1: "Cannot connect custom SQL" in Looker Studio

**Symptom:** Error when pasting the pre-aggregated SQL query

**Solution:**
1. First verify the query runs in VS Code against Supabase
2. Check that schema prefixes are included: `olist_sales_data_set.olist_orders_dataset`
3. Remove any semicolons from the end of the query (Looker Studio's parser does not accept them)
4. Ensure all CTEs are complete (every WITH clause has a closing parenthesis)

### Issue 2: Extract refresh fails

**Symptom:** "Extract refresh failed" error message

**Solution:**
1. Verify Supabase connection is active (open VS Code and confirm query runs)
2. Check that the data source credentials have not expired
3. Try editing the data source → reconnect → test the connection
4. If all else fails, delete and re-add the data source with Extract enabled from the start

### Issue 3: Revenue in dashboard does not match AFTER query

**Symptom:** Dashboard shows revenue that does not match $5,770,360 for SP

**Possible causes:**
- Dashboard is still using the old data source (check which source each chart uses)
- Date filter is restricting to a partial period (check default date range)
- State filter is applied (ensure no filter is hiding SP data)
- Extract has not refreshed (click "Refresh now")

### Issue 4: BEFORE query shows same result as AFTER query

**Symptom:** Both queries show the same SP revenue

**Explanation:** This can happen if your existing queries did not join `olist_order_items_dataset`. The inflation only occurs when that table is joined. If your queries avoided order_items, they may already be correct — this is a good outcome.

---

## Expected Outcomes

### Dashboard Layout After Optimization

```
┌────────────────────────────────────────────────────────┐
│ MAIN PAGE (Executive Summary)                          │
├────────────────────────────────────────────────────────┤
│                                                        │
│ [Revenue Scorecard]  [Orders Scorecard]  [AOV Score]  │
│                                                        │
│ ┌────────────────────┐  ┌───────────────────────────┐  │
│ │ Monthly Revenue    │  │ Delivery Performance      │  │
│ │ Trend (Line Chart) │  │ (Donut Chart)             │  │
│ └────────────────────┘  └───────────────────────────┘  │
│                                                        │
│ ┌────────────────────┐  ┌───────────────────────────┐  │
│ │ Top Categories     │  │ Geographic Revenue (Map)  │  │
│ │ (Bar Chart)        │  │                           │  │
│ └────────────────────┘  └───────────────────────────┘  │
│                                                        │
│ Data Quality Notes [small text, footer]               │
└────────────────────────────────────────────────────────┘
```

**Performance target:** Under 5 seconds after Extract is configured.

---

## How to Know You Succeeded

✅ **Revenue test:** Your dashboard shows SP total revenue close to $5,770,360 (not $7,404,140)

✅ **Performance test:** Dashboard loads in under 5 seconds (ideally under 3 seconds with Extract)

✅ **Data quality test:** At least one page shows data quality notes in the footer

✅ **Optimization test:** At least 2 of the 4 optimizations are implemented and documented

✅ **Documentation test:** Your audit report clearly explains what was wrong and what you fixed

---

## Reflection Questions

Answer these to confirm your understanding:

1. **Why does joining `olist_order_items_dataset` without pre-aggregating payments inflate revenue?**

2. **Your dashboard load time went from 18 seconds to 2 seconds after configuring Extract. Where is the data being served from in the Extract scenario?**

3. **A stakeholder says "I prefer the dashboard to show real-time data — please remove the Extract." What would you tell them about the trade-offs?**

4. **You discover your dashboard was showing $7.4M for SP instead of $5.77M. How would you explain this to a non-technical business user?**

5. **After the audit, what is the single most important data quality rule you have confirmed for every Olist revenue calculation?**

---

## Next Steps

Once completed:
1. **Save your optimized dashboard** as "Week 16 - Optimized Executive Dashboard - [Your Name]"
2. **Note your load time improvement** — you will reference this in your final project documentation
3. **Keep your audit report** — it becomes part of your documentation section
4. **Proceed to Exercise 2** — Data Quality Validation

---

## Additional Challenge (Optional)

If you finish early:

### Challenge 1: Run EXPLAIN on Both Queries

```sql
EXPLAIN
-- Paste your BEFORE query here
```

```sql
EXPLAIN
-- Paste your AFTER query here
```

Compare the estimated total costs (the last number in `cost=X..Y`). Which query has the higher total cost? Capture the output and identify the key difference in the execution plan.

### Challenge 2: Add a Revenue Discrepancy Note

The 22.73% discrepancy between payment_value and price+freight is a real finding that could confuse stakeholders. Add an annotated text box to your dashboard explaining:
- What the two revenue figures are
- Why they differ (installments, vouchers, multi-payment methods)
- Which one your dashboard uses and why

This is the kind of transparency that builds stakeholder trust.

---

**Instructor Note:** The revenue inflation finding (28%) is the key "aha moment" of this exercise. Students often expect data in a reputable dataset to be clean. Finding that an innocent-looking join query overstates revenue by $1.6M for a single state is genuinely surprising — and memorable. Encourage students to sit with that finding: "What business decisions would have been made on that $7.4M figure? Would they have been correct?" This connects data engineering discipline directly to business consequences.
