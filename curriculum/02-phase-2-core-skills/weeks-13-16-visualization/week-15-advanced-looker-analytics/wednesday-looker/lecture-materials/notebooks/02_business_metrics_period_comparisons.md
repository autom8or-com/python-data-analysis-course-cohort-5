# Business Metrics: Period Comparisons and Growth Calculations

## Week 15 - Wednesday Session - Part 2

### Duration: 20 minutes

---

## What Are Period Comparison Metrics?

**Period Comparison Metrics** measure performance changes over time by comparing current results against previous periods. They answer critical business questions like "Are we growing?" and "Is this month better than last month?"

### Why Period Comparisons Matter

Think back to your SQL analytics work:

**Week 9 Window Functions - LAG for Month-over-Month:**
```sql
WITH monthly_revenue AS (
  SELECT
    DATE_TRUNC('month', order_purchase_timestamp) AS order_month,
    SUM(payment_value) AS total_revenue
  FROM olist_orders_dataset o
  JOIN olist_order_payments_dataset p ON o.order_id = p.order_id
  WHERE order_status = 'delivered'
  GROUP BY DATE_TRUNC('month', order_purchase_timestamp)
)
SELECT
  order_month,
  total_revenue,
  LAG(total_revenue) OVER (ORDER BY order_month) AS previous_month_revenue,
  ((total_revenue - LAG(total_revenue) OVER (ORDER BY order_month))
    / LAG(total_revenue) OVER (ORDER BY order_month)) * 100 AS mom_growth_pct
FROM monthly_revenue;
```

**Looker Studio Equivalent:**
- Built-in period comparison functionality
- Visual date range selectors
- Automatic calculation of growth percentages
- No complex SQL required

---

## Core Period Comparison Types

### 1. Month-over-Month (MoM) Growth
**Purpose:** Track short-term performance trends

**Business Context:** Month-over-month revenue growth is the most watched metric for e-commerce businesses. Positive MoM indicates momentum; negative indicates problems.

**Formula:**
```
((Current Month Revenue - Previous Month Revenue) / Previous Month Revenue) * 100
```

### 2. Year-over-Year (YoY) Growth
**Purpose:** Compare performance against the same period last year

**Use Cases:**
- Account for seasonality (December 2018 vs December 2017)
- Multi-year trend analysis
- Board reporting and investor updates

### 3. Quarter-over-Quarter (QoQ) Growth
**Purpose:** Medium-term performance tracking

**Business Context:** Smooths out monthly volatility while maintaining responsiveness to changes.

### 4. Week-over-Week (WoW) Growth
**Purpose:** Operational monitoring for fast-moving businesses

**Use Cases:**
- Marketing campaign impact assessment
- Flash sale performance
- Rapid response to issues

---

## Month-over-Month (MoM) Revenue Growth

### Business Requirement

**Executive Question:** "Is revenue growing or declining each month?"

**Data Source:** Olist sales dataset (September 2016 - October 2018)

**Expected Insights (from validation report):**
- August 2018: $985,414 revenue, -4.13% MoM (decline)
- July 2018: $1,027,900 revenue, +1.56% MoM (growth)
- June 2018: $1,012,090 revenue, -10.34% MoM (significant decline)

### Looker Studio Implementation

**Approach 1: Using Data Source Date Range Comparison**

This is the simplest method for basic comparisons.

**Step 1: Create Revenue Metric**

If not already created:

**Field Name:** Total Revenue

**Formula:**
```
SUM(payment_value)
```

**Type:** Currency (Number)

**Step 2: Add Comparison in Scorecard**

1. Add a **Scorecard** chart to your dashboard
2. Configure:
   - **Metric:** Total Revenue
   - **Data tab** → Scroll to **"Comparison Date Range"**
   - **Enable:** "Show comparison"
   - **Comparison type:** "Previous period"

3. The scorecard automatically shows:
   - Current period revenue
   - Previous period revenue
   - Change amount
   - Change percentage

**Screenshot Description:**
```
┌──────────────────────────┐
│  Total Revenue           │
│  $985,414                │
│  ↓ -$42,486 (-4.13%)    │
│  vs Previous Period      │
└──────────────────────────┘
```

---

### Approach 2: Calculated Field for MoM Growth Percentage

For more control and custom visualizations:

**Field Name:** MoM Revenue Growth %

**Formula:**
```
CASE
  WHEN LAG(SUM(payment_value)) OVER (ORDER BY DATE_TRUNC(order_purchase_timestamp, MONTH)) > 0
  THEN ((SUM(payment_value) - LAG(SUM(payment_value)) OVER (ORDER BY DATE_TRUNC(order_purchase_timestamp, MONTH)))
       / LAG(SUM(payment_value)) OVER (ORDER BY DATE_TRUNC(order_purchase_timestamp, MONTH))) * 100
  ELSE NULL
END
```

**Important Note:** Looker Studio has limited support for window functions like LAG in calculated fields. This formula may need to be **pre-calculated in your SQL data source** for optimal performance.

---

### Approach 3: Pre-Calculate in Data Source (Recommended)

**Create a SQL View or Query:**

```sql
CREATE OR REPLACE VIEW monthly_revenue_growth AS
WITH monthly_revenue AS (
  SELECT
    DATE_TRUNC('month', o.order_purchase_timestamp) AS order_month,
    SUM(p.payment_value) AS total_revenue,
    COUNT(DISTINCT o.order_id) AS order_count
  FROM olist_sales_data_set.olist_orders_dataset o
  JOIN olist_sales_data_set.olist_order_payments_dataset p
    ON o.order_id = p.order_id
  WHERE o.order_status = 'delivered'
    AND o.order_purchase_timestamp IS NOT NULL
  GROUP BY DATE_TRUNC('month', o.order_purchase_timestamp)
),
revenue_with_lag AS (
  SELECT
    order_month,
    total_revenue,
    order_count,
    LAG(total_revenue) OVER (ORDER BY order_month) AS previous_month_revenue
  FROM monthly_revenue
)
SELECT
  order_month,
  ROUND(total_revenue::numeric, 2) AS total_revenue,
  order_count,
  ROUND(previous_month_revenue::numeric, 2) AS previous_month_revenue,
  CASE
    WHEN previous_month_revenue > 0 THEN
      ROUND(((total_revenue - previous_month_revenue) / previous_month_revenue * 100)::numeric, 2)
    ELSE NULL
  END AS mom_growth_percentage
FROM revenue_with_lag
ORDER BY order_month DESC;
```

**Then in Looker Studio:**
1. Connect to this view as a data source
2. Use `mom_growth_percentage` field directly in charts
3. No complex calculated fields needed
4. Better performance

---

### Visualizing MoM Growth

**Chart 1: Combo Chart (Revenue + Growth %)**

1. Add a **Combo Chart**
2. Configure:
   - **Dimension:** order_month (or order_purchase_timestamp set to Month)
   - **Left Y-Axis Metric:** Total Revenue (bars)
   - **Right Y-Axis Metric:** MoM Growth % (line)
   - **Sort:** By date ascending

**Expected Visual:** Bars show revenue volume; line shows growth rate volatility.

**Chart 2: Bullet Chart for Current MoM**

1. Add a **Bullet Chart**
2. Configure:
   - **Metric:** Current Month MoM Growth %
   - **Target:** 0% (break-even line)
   - **Ranges:**
     - Red: -10% to 0% (decline)
     - Yellow: 0% to 5% (slow growth)
     - Green: 5%+ (strong growth)

---

## Year-to-Date (YTD) Cumulative Revenue

### Business Requirement

**Executive Question:** "Are we on track to meet our annual revenue target?"

**Use Case:** Track cumulative revenue from January 1st to current date, compared against annual goal.

### Looker Studio Implementation

**Approach 1: Use Date Filter + Running Total**

**Field Name:** YTD Revenue

**Formula:**
```
RUNNING_TOTAL(SUM(payment_value))
```

**Chart Setup:**
1. Add a **Time Series Chart**
2. Configure:
   - **Dimension:** order_purchase_timestamp (daily or weekly)
   - **Metric:** YTD Revenue (with RUNNING_TOTAL)
   - **Date filter:** This year (or custom range starting Jan 1)

**Expected Result (2018 YTD as of August 29):**
- Final YTD: $8,452,980

**Visualization Enhancement:**
Add a **reference line** at your annual target (e.g., $10,000,000) to show progress.

---

### Approach 2: Pre-Calculate YTD in SQL (More Reliable)

```sql
WITH daily_revenue AS (
  SELECT
    DATE(o.order_purchase_timestamp) AS order_date,
    SUM(p.payment_value) AS daily_revenue
  FROM olist_sales_data_set.olist_orders_dataset o
  JOIN olist_sales_data_set.olist_order_payments_dataset p
    ON o.order_id = p.order_id
  WHERE o.order_status = 'delivered'
    AND EXTRACT(YEAR FROM o.order_purchase_timestamp) = 2018
  GROUP BY DATE(o.order_purchase_timestamp)
)
SELECT
  order_date,
  ROUND(daily_revenue::numeric, 2) AS daily_revenue,
  ROUND(SUM(daily_revenue) OVER (ORDER BY order_date)::numeric, 2) AS ytd_cumulative_revenue
FROM daily_revenue
ORDER BY order_date;
```

**Then connect to this query in Looker Studio** and use `ytd_cumulative_revenue` directly.

---

### YTD Target Achievement Scorecard

**Field Name:** YTD vs Target %

**Formula:**
```
(YTD_Revenue / Annual_Target) * 100
```

**Example:**
- YTD Revenue: $8,452,980
- Annual Target: $10,000,000
- Achievement: 84.53%

**Scorecard Configuration:**
1. Add scorecard
2. Metric: YTD vs Target %
3. Conditional formatting:
   - Green: >90% (on track)
   - Yellow: 75-90% (at risk)
   - Red: <75% (critical)

---

## Average Order Value (AOV) Trends

### Business Requirement

**Question:** "Are customers spending more per order over time?"

**Why It Matters:** AOV indicates pricing power, upsell effectiveness, and customer value perception.

### Formula

```
Average Order Value = Total Revenue / Number of Orders
```

### Looker Studio Implementation

**Field Name:** Average Order Value

**Formula:**
```
SUM(payment_value) / COUNT(DISTINCT order_id)
```

**Type:** Currency

**Expected Results (from validation report):**
| Month | AOV |
|-------|-----|
| August 2018 | $155.16 |
| July 2018 | $166.89 |
| June 2018 | $165.94 |

**AOV Range Across Dataset:** $147 - $169

---

### AOV Trend Visualization

**Chart: Line Chart with Trend Line**

1. Add a **Line Chart**
2. Configure:
   - **Dimension:** order_purchase_timestamp (Month)
   - **Metric:** Average Order Value
   - **Style:**
     - Add trend line (shows if AOV is increasing/decreasing overall)
     - Data labels: On (show exact values)

**Business Insight:** If AOV is declining, consider:
- Bundle pricing strategies
- Free shipping thresholds (to encourage larger orders)
- Product mix changes (selling more low-value items)

---

### AOV by Customer Segment

**Enhanced Analysis:** Compare AOV across customer tiers.

**Chart: Table with Spark lines**

1. Add a **Table**
2. Configure:
   - **Dimension:** CLV Tier (created in Part 1)
   - **Metrics:**
     - Average Order Value
     - Number of Orders
     - Total Revenue
3. **Sort:** By AOV descending

**Expected Insight:** VIP Champions likely have much higher AOV than New Customers.

---

## Running Totals and Cumulative Metrics

### What Are Running Totals?

A **running total** (or cumulative sum) adds up values progressively over time, showing the accumulated amount at each point.

### Business Use Cases

1. **Cumulative Revenue:** Total revenue earned so far this year
2. **Cumulative Orders:** Total orders processed to date
3. **Cumulative Customer Acquisition:** Total customers acquired since launch

### Looker Studio Implementation

**Field Name:** Cumulative Revenue

**Formula:**
```
RUNNING_TOTAL(SUM(payment_value))
```

**Chart Setup:**
1. Add a **Time Series (Area Chart)**
2. Configure:
   - **Dimension:** order_purchase_timestamp (Daily or Weekly)
   - **Metric:** Cumulative Revenue
   - **Style:**
     - Fill: Blue gradient
     - Area opacity: 70%

**Visual Effect:** Shows revenue accumulating over time, always trending upward (unless refunds exceed new sales).

---

### Running Total vs Regular Total

**Regular Total (SUM):**
```
Jan: $100,000
Feb: $120,000
Mar: $110,000
```

**Running Total (RUNNING_TOTAL):**
```
Jan: $100,000
Feb: $220,000  (100k + 120k)
Mar: $330,000  (220k + 110k)
```

**When to Use Each:**
- **SUM:** Show performance per period (which month was best?)
- **RUNNING_TOTAL:** Show progress toward goal (are we reaching target?)

---

## Custom Aggregation Logic

### Weighted Averages

**Problem:** Simple average doesn't account for order size.

**Example:** Average delivery days

**Simple Average (MISLEADING):**
```
AVG(delivery_days)
```
Problem: A 1-item order and 50-item order count equally.

**Weighted Average (ACCURATE):**
```
SUM(delivery_days * order_item_count) / SUM(order_item_count)
```

Each order weighted by number of items.

---

### Conditional Aggregation

**Business Question:** "What's the average order value for premium customers only?"

**Field Name:** Premium Customer AOV

**Formula:**
```
SUM(CASE WHEN clv_tier = "VIP Champion" THEN payment_value ELSE 0 END)
/
COUNT(DISTINCT CASE WHEN clv_tier = "VIP Champion" THEN order_id END)
```

**Explanation:**
- Numerator: Sum revenue only for VIP Champions
- Denominator: Count orders only for VIP Champions
- Result: AOV specific to VIP segment

---

## Cohort-Based Metrics

### Connection to Week 9 (Cohort Analysis)

Remember analyzing customer behavior by acquisition month? Now visualize it in Looker Studio.

### Example: Revenue by Customer Cohort

**Pre-Calculate in SQL (Recommended):**

```sql
WITH customer_first_order AS (
  SELECT
    customer_unique_id,
    DATE_TRUNC('month', MIN(order_purchase_timestamp)) AS cohort_month
  FROM olist_sales_data_set.olist_customers_dataset c
  JOIN olist_sales_data_set.olist_orders_dataset o
    ON c.customer_id = o.customer_id
  WHERE o.order_status = 'delivered'
  GROUP BY customer_unique_id
),
cohort_revenue AS (
  SELECT
    cfo.cohort_month,
    DATE_TRUNC('month', o.order_purchase_timestamp) AS purchase_month,
    SUM(p.payment_value) AS revenue
  FROM customer_first_order cfo
  JOIN olist_sales_data_set.olist_customers_dataset c
    ON cfo.customer_unique_id = c.customer_unique_id
  JOIN olist_sales_data_set.olist_orders_dataset o
    ON c.customer_id = o.customer_id
  JOIN olist_sales_data_set.olist_order_payments_dataset p
    ON o.order_id = p.order_id
  WHERE o.order_status = 'delivered'
  GROUP BY cfo.cohort_month, DATE_TRUNC('month', o.order_purchase_timestamp)
)
SELECT * FROM cohort_revenue;
```

**Looker Studio Visualization:**
1. Connect to cohort_revenue view
2. Create a **Heatmap**:
   - **Rows:** cohort_month (customer acquisition month)
   - **Columns:** purchase_month (when revenue occurred)
   - **Metric:** revenue
   - **Color:** Green (high) to Red (low)

**Insight:** See which customer cohorts remain valuable over time vs which drop off.

---

## Percentage of Total Calculations

### Use Case: "What % of revenue comes from each state?"

**Field Name:** Revenue Share %

**Formula:**
```
SUM(payment_value) / SUM(SUM(payment_value)) * 100
```

**Explanation:**
- `SUM(payment_value)`: Revenue for this state
- `SUM(SUM(payment_value))`: Total revenue across all states (inner SUM aggregates, outer SUM totals)

**Expected Results (Top States):**
- SP (São Paulo): ~55% of revenue
- RJ (Rio de Janeiro): ~18% of revenue
- MG (Minas Gerais): ~11% of revenue

---

### Visualization: Pie Chart with Percentages

1. Add a **Pie Chart**
2. Configure:
   - **Dimension:** customer_state
   - **Metric:** Revenue Share %
   - **Style:**
     - Show data labels: Percentage
     - Sort: By metric descending
     - Limit: Top 10 states

---

## Practice Exercise: Build Business Metrics

### Task 1: Create MoM Growth Scorecard (10 minutes)

**Goal:** Display current month revenue with MoM growth percentage.

**Steps:**
1. Open your Customer Analytics dashboard
2. Add a **Scorecard**
3. Configure:
   - **Date Range:** This month
   - **Metric:** Total Revenue
   - **Comparison:** Enable, set to "Previous period"
4. Style:
   - Conditional formatting: Green if positive growth, Red if negative

**Expected Result:**
```
┌──────────────────────────┐
│  Current Month Revenue   │
│  $985,414                │
│  ↓ -4.13%               │
│  vs Previous Month       │
└──────────────────────────┘
```

---

### Task 2: Build YTD Revenue Progress Chart (10 minutes)

**Goal:** Show cumulative revenue with target line.

**Steps:**
1. Add a **Time Series (Area Chart)**
2. Configure:
   - **Date Range:** This year (or 2018 for Olist data)
   - **Dimension:** order_purchase_timestamp (Daily)
   - **Metric:** Create new field - YTD Revenue (formula: `RUNNING_TOTAL(SUM(payment_value))`)
3. Add **Reference Line**:
   - Value: $10,000,000 (annual target)
   - Label: "Annual Target"
   - Color: Red dashed line
4. Style:
   - Fill area below line
   - Blue gradient

**Expected Insight:** See if cumulative revenue is trending toward target.

---

### Task 3: AOV Trend with Conditional Formatting (5 minutes)

**Goal:** Highlight months with above-average AOV.

**Steps:**
1. Add a **Table**
2. Configure:
   - **Dimension:** order_purchase_timestamp (Month)
   - **Metrics:**
     - Total Revenue
     - Order Count
     - Average Order Value (formula: `SUM(payment_value) / COUNT(DISTINCT order_id)`)
3. **Conditional Formatting** on AOV:
   - Green: >$165
   - Yellow: $150-$165
   - Red: <$150

**Expected Result:** Easily spot high-AOV months for further analysis.

---

## Common Issues and Solutions

### Issue 1: "Comparison Period Shows No Data"

**Symptom:** Scorecard comparison is blank or shows "--"

**Causes & Solutions:**
- ❌ Previous period is outside dataset date range
  - ✅ Adjust date range to ensure prior period has data
- ❌ No data for that specific period (e.g., business didn't exist last year)
  - ✅ Use alternative comparison (MoM instead of YoY)

---

### Issue 2: "Running Total Restarts Each Year"

**Symptom:** Cumulative revenue drops back to zero in January

**Cause:** Running total is being reset by year boundary

**Solution:**
1. Check date filter: Should not have "This Year" if you want multi-year cumulative
2. Or explicitly filter to single year for YTD calculation

---

### Issue 3: "Percentage Calculations Are Incorrect"

**Symptom:** Percentages don't add up to 100% or show strange values

**Causes & Solutions:**
- ❌ Wrong aggregation level (dividing aggregated by non-aggregated)
  - ✅ Ensure both numerator and denominator use same aggregation
- ❌ Filtering affecting denominator
  - ✅ Use `SUM(SUM(field))` to total across filtered groups

---

### Issue 4: "LAG Function Not Supported Error"

**Symptom:** "Function LAG is not available in Looker Studio"

**Solution:** Looker Studio has limited window function support. **Pre-calculate LAG fields in your SQL data source** (create a view) then connect to that view.

---

## Connection to Prior Learning

### Week 9: Window Functions (LAG, LEAD)
```sql
LAG(revenue) OVER (ORDER BY month)
```
**Looker Approach:** Pre-calculate in SQL data source; use comparison date ranges in charts.

---

### Week 12: Financial Metrics and Ratios
```sql
-- Gross Margin %
(revenue - cost) / revenue * 100
```
**Looker Equivalent:** Same formula structure, visual implementation.

---

### Week 10: Data Quality and Aggregation
```sql
-- Handle NULLs in calculations
COALESCE(SUM(revenue), 0)
```
**Looker Equivalent:** Use CASE to handle NULLs before aggregation.

---

## Key Takeaways

### What You Learned
1. ✅ Period comparisons (MoM, YoY, YTD) track growth and trends
2. ✅ Running totals show cumulative progress toward goals
3. ✅ AOV and weighted averages reveal customer value trends
4. ✅ Conditional aggregation enables segment-specific metrics
5. ✅ Looker Studio's built-in comparison features simplify time-based analysis
6. ✅ Pre-calculating complex metrics in SQL improves performance

### What's Next
In **Thursday's session**, we'll apply these metrics to build a data storytelling dashboard that guides users through insights and recommendations.

### Skills Building Progression
```
Week 15 Part 1: Advanced Functions ✓
Week 15 Part 2: Business Metrics ✓
         ↓
Week 15 Part 3: Data Storytelling Principles (Thursday)
         ↓
Week 15 Part 4: Actionable Insights (Thursday)
```

---

## Quick Reference: Business Metrics Formulas

| Metric | Formula | Use Case |
|--------|---------|----------|
| **MoM Growth %** | `((Current - Previous) / Previous) * 100` | Track monthly momentum |
| **YTD Revenue** | `RUNNING_TOTAL(SUM(revenue))` | Progress vs annual target |
| **AOV** | `SUM(revenue) / COUNT(DISTINCT orders)` | Customer spending trends |
| **Revenue Share %** | `SUM(revenue) / SUM(SUM(revenue)) * 100` | Contribution by segment |
| **Weighted Average** | `SUM(value * weight) / SUM(weight)` | Account for size differences |

---

## Questions to Test Your Understanding

1. What's the difference between SUM and RUNNING_TOTAL?
2. Why might a simple average be misleading for delivery days?
3. When should you compare MoM vs YoY growth?
4. How do you prevent comparison metrics from showing errors when previous period has no data?
5. Why pre-calculate LAG functions in SQL instead of Looker Studio?

**Answers at the end of lecture notes**

---

## Additional Resources

- **Looker Studio Help:** [Date Range Comparisons](https://support.google.com/looker-studio/answer/7439729)
- **Video Tutorial:** Building Period Comparison Dashboards (Week 15 resources)
- **SQL Scripts:** Pre-calculated business metrics queries (lecture-materials/scripts/)
- **Validation Report:** See Section 3 for query examples (validation-report.md)

---

## Answers to Questions

1. **SUM** aggregates values for each period separately; **RUNNING_TOTAL** accumulates values cumulatively (always increasing)
2. **Simple average** treats all orders equally; a 1-item order and 50-item order count the same. **Weighted average** accounts for order size, giving more weight to larger orders
3. **MoM** for short-term trends and operational monitoring; **YoY** for seasonal comparison and long-term growth (avoids seasonality distortion)
4. Use **CASE WHEN Previous_Period_Revenue IS NULL OR Previous_Period_Revenue = 0 THEN NULL ELSE (growth calculation) END**
5. Looker Studio has **limited window function support** and may cause performance issues; pre-calculating in SQL is faster and more reliable

---

**Next Session:** Thursday - Data Storytelling Techniques
