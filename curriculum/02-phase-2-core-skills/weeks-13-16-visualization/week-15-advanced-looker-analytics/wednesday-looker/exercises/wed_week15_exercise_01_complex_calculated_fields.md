# Exercise 1: Complex Calculated Fields for Executive Reporting

## Week 15 - Wednesday - Exercise 1

### Estimated Time: 30 minutes

---

## Objective

Create advanced calculated fields that transform raw Olist e-commerce data into executive-ready business metrics. You'll build CLV tiers, delivery performance categories, RFM scores, and period comparison metrics for a comprehensive analytics dashboard.

---

## Prerequisites

Before starting, ensure you have:
- ✅ Completed Week 13-14 exercises (Data Connections & Interactive Controls)
- ✅ Active data source connected to Olist sales and marketing datasets
- ✅ Familiarity with CASE statements, date functions, and aggregations
- ✅ Completed Week 15 Lectures Part 1 & 2 (Advanced Functions & Business Metrics)

---

## Business Context

You're building an **Executive KPI Dashboard** for Olist's leadership team. They need to:
1. Identify high-value customers for VIP treatment
2. Monitor delivery performance (critical issue: 75% delayed)
3. Track month-over-month revenue growth
4. Understand customer segmentation via RFM analysis
5. Calculate customer acquisition cost by marketing channel

All metrics must be **calculated fields** in Looker Studio for real-time updates.

---

## Instructions

### Part 1: Customer Lifetime Value (CLV) Tier Classification

#### Task 1.1: Create CLV Tier Calculated Field

**Business Requirement:** Segment customers into 4 tiers based on total revenue for targeted retention strategies.

**Data Reality Check (from Validation Report):**
- Top customer: $13,664 lifetime value
- VIP threshold: $5,000+ (realistic for this dataset)
- NOT $500,000 (would result in zero VIP customers)

**Steps:**

1. Open your data source in Edit mode:
   - Dashboard → **"Resource" menu → "Manage added data sources"**
   - Click **"Edit"** next to your Olist data source

2. Click **"Add a field"** button (top-right)

3. Configure the field:

**Field Name:** `CLV_Tier`

**Formula:**
```
CASE
  WHEN SUM(payment_value) >= 5000 THEN "VIP Champion"
  WHEN SUM(payment_value) >= 2000 THEN "Loyal Customer"
  WHEN SUM(payment_value) >= 500 THEN "Growing Customer"
  ELSE "New Customer"
END
```

**Field ID:** `clv_tier` (auto-generated, leave as is)

**Type:** Text (should auto-detect)

4. Click **"Save"** → **"Done"**

**Verification:**
- Field appears in your dimensions list
- No error messages

---

#### Task 1.2: Visualize CLV Distribution

**Create Pie Chart:**

1. Add a **Pie Chart** to your dashboard
2. Configure:
   - **Dimension:** CLV_Tier
   - **Metric:** `Record Count` or `COUNT(DISTINCT customer_unique_id)`
   - **Sort:** By dimension (will order: Growing → Loyal → New → VIP alphabetically)
3. Style:
   - **Title:** "Customer Distribution by Lifetime Value"
   - **Colors:**
     - VIP Champion: Gold (#FFD700)
     - Loyal Customer: Blue (#4285F4)
     - Growing Customer: Green (#34A853)
     - New Customer: Gray (#9E9E9E)
   - **Data labels:** Show percentage

**Expected Results:**
- VIP Champion: <0.01% (tiny sliver)
- Loyal Customer: ~0.02%
- Growing Customer: ~0.5%
- New Customer: >99% (dominant)

**Business Insight:** Despite being <0.01%, VIP Champions should be prioritized for retention programs.

---

#### Task 1.3: Create CLV Revenue Table

**Create Table Chart:**

1. Add a **Table** chart
2. Configure:
   - **Dimension:** CLV_Tier
   - **Metrics:**
     - `COUNT(DISTINCT customer_unique_id)` → Rename to "Customer Count"
     - `SUM(payment_value)` → Rename to "Total Revenue"
     - `AVG(payment_value)` → Rename to "Avg Order Value"
   - **Sort:** By Total Revenue (descending)
3. **Conditional Formatting** on Total Revenue:
   - Green: >$1,000,000
   - Yellow: $100,000 - $1,000,000
   - Red: <$100,000

**Expected Insight:** VIP Champions have small customer count but disproportionate revenue contribution.

---

### Part 2: Delivery Performance Category

#### Task 2.1: Create Delivery Days Calculated Field

**First, calculate days between order and delivery:**

**Field Name:** `Delivery_Days`

**Formula:**
```
CASE
  WHEN order_delivered_customer_date IS NULL THEN NULL
  ELSE DATE_DIFF(order_delivered_customer_date, order_purchase_timestamp, DAY)
END
```

**Type:** Number

**Why Handle NULLs?** 2,965 orders (2.98%) have no delivery date—these are pending, canceled, or in-transit orders.

Click **"Save"**.

---

#### Task 2.2: Create Delivery Performance Category

**Field Name:** `Delivery_Performance`

**Formula:**
```
CASE
  WHEN DATE_DIFF(order_delivered_customer_date, order_purchase_timestamp, DAY) <= 3 THEN "Express"
  WHEN DATE_DIFF(order_delivered_customer_date, order_purchase_timestamp, DAY) <= 7 THEN "Standard"
  WHEN DATE_DIFF(order_delivered_customer_date, order_purchase_timestamp, DAY) <= 14 THEN "Delayed"
  WHEN DATE_DIFF(order_delivered_customer_date, order_purchase_timestamp, DAY) > 14 THEN "Critical Delay"
  ELSE "Unknown"
END
```

**Type:** Text

Click **"Save"** → **"Done"**.

---

#### Task 2.3: Visualize Delivery Performance

**Create Donut Chart:**

1. Add a **Donut Chart**
2. Configure:
   - **Dimension:** Delivery_Performance
   - **Metric:** `Record Count`
   - **Sort:** Custom order (Express → Standard → Delayed → Critical)
3. Style:
   - **Title:** "Delivery Speed Distribution"
   - **Colors:**
     - Express: Green (#34A853)
     - Standard: Light Green (#93C47D)
     - Delayed: Orange (#F9AB00)
     - Critical Delay: Red (#EA4335)
     - Unknown: Gray (#9E9E9E)
   - **Donut hole:** 50%

**Expected Results:**
- Express: ~5%
- Standard: ~20%
- Delayed: ~50% (⚠️ Major issue!)
- Critical Delay: ~25% (⚠️ Crisis-level!)

**Business Action Required:** This visualization should trigger immediate operations review. 75% of orders are late.

---

#### Task 2.4: Add Average Delivery Days Scorecard

1. Add a **Scorecard**
2. Configure:
   - **Metric:** `AVG(Delivery_Days)`
   - **Title:** "Average Delivery Time"
   - **Suffix:** "days"
3. **Conditional Formatting:**
   - Green: <7 days
   - Yellow: 7-14 days
   - Red: >14 days

**Expected Result:** ~15-18 days average (should show RED, indicating problem).

---

### Part 3: RFM Score Concatenation

#### Background

In Week 9 (RFM Analysis), you learned to score customers on:
- **R**ecency: How recently they purchased (1-5, 5 = most recent)
- **F**requency: How often they purchase (1-5, 5 = most frequent)
- **M**onetary: How much they spend (1-5, 5 = highest spend)

Combined score example: "555" = Champion customer

---

#### Task 3.1: Verify RFM Score Fields Exist

**Check your data source for these fields:**
- `Recency_Score` (1-5)
- `Frequency_Score` (1-5)
- `Monetary_Score` (1-5)

**If they DON'T exist:** You'll need to either:
1. Pre-calculate them in SQL (see validation report query 3.5)
2. Or create simplified versions using NTILE (advanced, optional)

**For this exercise, assume they exist.** In production, pre-calculate in SQL for performance.

---

#### Task 3.2: Create RFM Score Label

**Field Name:** `RFM_Score`

**Formula:**
```
CONCAT(
  CAST(Recency_Score AS STRING),
  CAST(Frequency_Score AS STRING),
  CAST(Monetary_Score AS STRING)
)
```

**Type:** Text

**Result Examples:**
- "555" (Champion: recent, frequent, high-value)
- "145" (Hibernating: old customer, infrequent, but high-value)
- "111" (Lost: old, infrequent, low-value)

Click **"Save"**.

---

#### Task 3.3: Create RFM Segment Name (Enhanced)

**Field Name:** `RFM_Segment_Name`

**Formula:**
```
CASE
  WHEN CONCAT(CAST(Recency_Score AS STRING), CAST(Frequency_Score AS STRING), CAST(Monetary_Score AS STRING)) = "555" THEN "Champions"
  WHEN CONCAT(CAST(Recency_Score AS STRING), CAST(Frequency_Score AS STRING), CAST(Monetary_Score AS STRING)) IN ("554", "544", "545", "454", "455", "445") THEN "Loyal Customers"
  WHEN CONCAT(CAST(Recency_Score AS STRING), CAST(Frequency_Score AS STRING), CAST(Monetary_Score AS STRING)) IN ("543", "444", "435", "355", "354", "345") THEN "Potential Loyalists"
  WHEN CONCAT(CAST(Recency_Score AS STRING), CAST(Frequency_Score AS STRING), CAST(Monetary_Score AS STRING)) IN ("512", "511", "422", "421", "412", "411", "311") THEN "New Customers"
  WHEN CONCAT(CAST(Recency_Score AS STRING), CAST(Frequency_Score AS STRING), CAST(Monetary_Score AS STRING)) IN ("525", "524", "523", "522", "521", "515", "514", "513", "425", "424", "413", "414", "415", "315", "314", "313") THEN "Promising"
  WHEN CONCAT(CAST(Recency_Score AS STRING), CAST(Frequency_Score AS STRING), CAST(Monetary_Score AS STRING)) IN ("535", "534", "443", "434", "343", "334", "325", "324") THEN "Need Attention"
  WHEN CONCAT(CAST(Recency_Score AS STRING), CAST(Frequency_Score AS STRING), CAST(Monetary_Score AS STRING)) IN ("331", "321", "312", "221", "213", "231", "241", "251") THEN "About To Sleep"
  WHEN CONCAT(CAST(Recency_Score AS STRING), CAST(Frequency_Score AS STRING), CAST(Monetary_Score AS STRING)) IN ("255", "254", "245", "244", "253", "252", "243", "242", "235", "234", "225", "224", "153", "152", "145", "143", "142", "135", "134", "133", "125", "124") THEN "At Risk"
  WHEN CONCAT(CAST(Recency_Score AS STRING), CAST(Frequency_Score AS STRING), CAST(Monetary_Score AS STRING)) IN ("155", "154", "144", "214", "215", "115", "114", "113") THEN "Cannot Lose Them"
  WHEN CONCAT(CAST(Recency_Score AS STRING), CAST(Frequency_Score AS STRING), CAST(Monetary_Score AS STRING)) IN ("332", "322", "233", "232", "223", "222", "132", "123", "122", "212", "211") THEN "Hibernating"
  WHEN CONCAT(CAST(Recency_Score AS STRING), CAST(Frequency_Score AS STRING), CAST(Monetary_Score AS STRING)) IN ("111", "112", "121", "131", "141", "151") THEN "Lost"
  ELSE "Other"
END
```

**Type:** Text

**This is a comprehensive RFM segmentation model** used in e-commerce marketing.

Click **"Save"**.

---

#### Task 3.4: Visualize RFM Segments

**Create Bar Chart:**

1. Add a **Bar Chart**
2. Configure:
   - **Dimension:** RFM_Segment_Name
   - **Metric:** `COUNT(DISTINCT customer_unique_id)`
   - **Sort:** By metric (descending)
   - **Limit:** Top 10 segments
3. Style:
   - **Title:** "Customer Segments by RFM Analysis"
   - **Orientation:** Horizontal bars
   - **Data labels:** Show count

**Expected Top Segments:**
- New Customers (largest group)
- At Risk (needs win-back campaigns)
- Champions (VIPs, retain at all costs)

**Business Application:** Each segment has specific marketing actions (e.g., win-back campaigns for "At Risk", exclusive offers for "Champions").

---

### Part 4: Month-over-Month (MoM) Revenue Growth

#### Task 4.1: Add MoM Comparison to Revenue Scorecard

**Using Built-in Comparison Feature:**

1. Add a **Scorecard** (or edit existing revenue scorecard)
2. Configure:
   - **Metric:** `SUM(payment_value)` (Total Revenue)
   - **Date Range:** Auto (or This Month)
3. **Data tab** → Scroll to **"Comparison Date Range"**:
   - **Enable:** "Show comparison"
   - **Comparison Type:** "Previous period"
   - **Calculate:** "Change" and "Percent change"

4. Style:
   - **Comparison Label:** "vs Last Month"
   - **Show compact numbers:** Yes (e.g., "$985K" instead of "$985,414")

**Expected Result (August 2018):**
```
┌──────────────────────────┐
│  Monthly Revenue         │
│  $985,414                │
│  ↓ -$42,486 (-4.13%)    │
│  vs Last Month           │
└──────────────────────────┘
```

**Business Insight:** Red downward arrow should trigger investigation—Why did revenue decline?

---

#### Task 4.2: Create MoM Growth Trend Chart

**Pre-Calculation Required:** For this chart, you need a SQL view with month-over-month data.

**If you have access to create SQL views:**

Use the query from validation report (Section 3.1) to create `monthly_revenue_growth` view.

**If not, use Looker Studio workaround:**

1. Add a **Combo Chart**
2. Configure:
   - **Dimension:** `order_purchase_timestamp` (set to Month granularity)
   - **Date Range:** Last 12 months
   - **Left Y-Axis (Bars):** `SUM(payment_value)` → "Monthly Revenue"
   - **Right Y-Axis (Line):** Create calculated field (see below)

**Calculated Field for Growth %:**

**Field Name:** `MoM_Growth_Indicator`

**Formula (Simplified - Comparison to Overall Average):**
```
((SUM(payment_value) - AVG(SUM(payment_value))) / AVG(SUM(payment_value))) * 100
```

**Note:** True MoM requires LAG function, which needs SQL pre-calculation. This simplified version shows performance vs average.

3. Style:
   - **Title:** "Monthly Revenue Trend"
   - **Bars:** Blue (revenue)
   - **Line:** Green/Red conditional (positive/negative growth)

---

### Part 5: Average Order Value (AOV) Trends

#### Task 5.1: Create AOV Calculated Field

**Field Name:** `Average_Order_Value`

**Formula:**
```
SUM(payment_value) / COUNT(DISTINCT order_id)
```

**Type:** Number (Currency)

**Format:** Currency (R$ or $)

Click **"Save"**.

---

#### Task 5.2: Create AOV Trend Line Chart

1. Add a **Line Chart**
2. Configure:
   - **Dimension:** `order_purchase_timestamp` (Month granularity)
   - **Date Range:** Last 12 months
   - **Metric:** Average_Order_Value
3. Style:
   - **Title:** "Average Order Value by Month"
   - **Line thickness:** 3px
   - **Point size:** Medium
   - **Add trend line:** Yes (shows overall AOV direction)

**Expected Results:**
- AOV Range: $147 - $169
- Trend: Relatively stable with minor fluctuations

**Business Question to Answer:** Is AOV increasing (customers buying more per order) or decreasing (shift to lower-value products)?

---

#### Task 5.3: Add AOV Comparison by CLV Tier

1. Add a **Table**
2. Configure:
   - **Dimension:** CLV_Tier
   - **Metrics:**
     - Average_Order_Value
     - `COUNT(DISTINCT order_id)` → "Total Orders"
     - `SUM(payment_value)` → "Total Revenue"
   - **Sort:** By Average_Order_Value (descending)

**Expected Insight:** VIP Champions likely have 2-3x higher AOV than New Customers.

**Business Application:** Focus upsell strategies on Growing Customers to move them to Loyal tier.

---

### Part 6: Year-to-Date (YTD) Revenue

#### Task 6.1: Create YTD Cumulative Revenue Chart

1. Add a **Time Series Chart**
2. Configure:
   - **Dimension:** `order_purchase_timestamp` (Day or Week granularity)
   - **Date Range:** This year (or 2018 for Olist historical data)
   - **Metric:** Create new calculated field

**Field Name:** `YTD_Revenue`

**Formula:**
```
RUNNING_TOTAL(SUM(payment_value))
```

**Type:** Number (Currency)

3. Style:
   - **Title:** "Year-to-Date Revenue Progress"
   - **Chart type:** Area chart
   - **Fill:** Blue gradient
   - **Opacity:** 70%

**Add Reference Line:**
- Click **"Style" tab** → **"Reference lines"** → **"Add"**
- Value: $10,000,000 (example annual target)
- Label: "Annual Target ($10M)"
- Color: Red dashed line

**Expected Result:** Rising area chart showing cumulative revenue. If line crosses reference line, target is achieved.

---

#### Task 6.2: Create YTD Achievement Scorecard

**Calculated Field:**

**Field Name:** `YTD_vs_Target_Percent`

**Formula:**
```
(RUNNING_TOTAL(SUM(payment_value)) / 10000000) * 100
```

**Note:** Replace 10,000,000 with your actual annual target.

**Type:** Number

**Format:** Percentage

1. Add a **Scorecard**
2. Configure:
   - **Metric:** YTD_vs_Target_Percent
   - **Title:** "YTD Target Achievement"
   - **Suffix:** "% of annual goal"
3. **Conditional Formatting:**
   - Green: >90% (on track)
   - Yellow: 75-90% (at risk)
   - Red: <75% (critical)

**Expected Result (2018 as of Aug 29):** ~84.53% (Yellow - at risk of missing target)

---

## Submission Checklist

Before marking this exercise complete, verify:

```
☐ CLV_Tier calculated field created with correct thresholds ($5K, $2K, $500)
☐ CLV distribution pie chart shows 4 tiers with appropriate colors
☐ CLV revenue table shows revenue concentration in VIP tier
☐ Delivery_Days calculated field handles NULL dates properly
☐ Delivery_Performance category created (Express/Standard/Delayed/Critical)
☐ Delivery performance donut chart shows ~75% delayed (highlighting issue)
☐ Average delivery days scorecard displays in RED (>14 days)
☐ RFM_Score concatenation field created (e.g., "555")
☐ RFM_Segment_Name field classifies customers into 11 segments
☐ RFM bar chart shows top customer segments
☐ MoM revenue comparison scorecard shows growth % vs previous month
☐ Average_Order_Value field calculates correctly ($147-$169 range)
☐ AOV trend line chart displays monthly fluctuations
☐ YTD_Revenue running total chart shows cumulative growth
☐ YTD achievement scorecard shows % toward target
☐ All charts have clear titles and appropriate conditional formatting
```

---

## Troubleshooting

### Issue 1: "Aggregation Error in CLV_Tier Formula"

**Error Message:** "Cannot mix aggregated and non-aggregated"

**Cause:** Using SUM inside CASE at wrong aggregation level

**Solution:**
- Ensure formula is: `CASE WHEN SUM(field) >= value`
- NOT: `SUM(CASE WHEN field >= value)`

---

### Issue 2: "Delivery_Days Shows Negative Numbers"

**Symptom:** Chart shows -5, -10 days

**Cause:** Date order reversed in DATE_DIFF

**Solution:** Use `DATE_DIFF(later_date, earlier_date, DAY)`
- Correct: `DATE_DIFF(order_delivered_customer_date, order_purchase_timestamp, DAY)`
- Wrong: `DATE_DIFF(order_purchase_timestamp, order_delivered_customer_date, DAY)`

---

### Issue 3: "RFM Score Shows 'null' Instead of Numbers"

**Cause:** RFM score fields don't exist in data source yet

**Solutions:**
1. **Best:** Pre-calculate RFM scores in SQL (see validation report query 3.5)
2. **Workaround:** Skip RFM section for now, complete other exercises

---

### Issue 4: "Running Total Resets Each Month"

**Symptom:** YTD chart drops back to zero at month boundaries

**Cause:** Date dimension has month granularity instead of day/week

**Solution:**
- Change dimension to Day or Week granularity
- Ensure date range filter is set to continuous period (e.g., "This Year")

---

### Issue 5: "MoM Comparison Shows '--' (No Data)"

**Cause:** Previous period is outside dataset date range

**Solution:**
- Olist data: Sep 2016 - Oct 2018
- If viewing Sep 2016, there's no Aug 2016 for comparison
- Adjust date range to period with prior data available

---

## Expected Outcomes

### Dashboard Layout

Your executive dashboard should now have:

```
┌────────────────────────────────────────────────────────────┐
│ Executive KPI Dashboard                                    │
├────────────────────────────────────────────────────────────┤
│                                                            │
│  ┌────────────┐ ┌────────────┐ ┌────────────┐            │
│  │ Monthly Rev│ │  AOV       │ │ YTD Target │            │
│  │ $985K      │ │  $155.16   │ │ 84.53%     │            │
│  │ ↓ -4.13%   │ │ ↓ -$11.73  │ │ ⚠️ At Risk  │            │
│  └────────────┘ └────────────┘ └────────────┘            │
│                                                            │
│  ┌──────────────────────┐  ┌────────────────────────────┐ │
│  │ CLV Distribution     │  │ Delivery Performance       │ │
│  │ (Pie Chart)          │  │ (Donut Chart)              │ │
│  │ • VIP: 0.007%        │  │ • Express: 5%              │ │
│  │ • Loyal: 0.02%       │  │ • Standard: 20%            │ │
│  │ • Growing: 0.5%      │  │ • Delayed: 50% ⚠️          │ │
│  │ • New: 99.47%        │  │ • Critical: 25% ⚠️         │ │
│  └──────────────────────┘  └────────────────────────────┘ │
│                                                            │
│  ┌──────────────────────────────────────────────────────┐ │
│  │ YTD Revenue Progress (Area Chart)                    │ │
│  │ [Cumulative revenue trending toward $10M target]     │ │
│  └──────────────────────────────────────────────────────┘ │
│                                                            │
│  ┌──────────────────────┐  ┌────────────────────────────┐ │
│  │ RFM Customer Segments│  │ AOV Trend (Line Chart)     │ │
│  │ (Bar Chart)          │  │ $147 - $169 range          │ │
│  └──────────────────────┘  └────────────────────────────┘ │
│                                                            │
└────────────────────────────────────────────────────────────┘
```

---

## How to Know You Succeeded

✅ **Calculated Fields Test:**
- All 6+ calculated fields exist in data source without errors
- Fields display correct data types (Text, Number, Date)
- No aggregation errors or NULL handling issues

✅ **Visualization Test:**
- CLV pie chart shows realistic distribution (<1% in VIP/Loyal tiers)
- Delivery donut chart highlights major delay problem (75% red/orange)
- YTD area chart shows steady upward trend
- AOV line chart shows minor fluctuations around $160

✅ **Business Insights Test:**
- Dashboard immediately reveals key issues (delivery delays)
- Executives can identify VIP customers for retention
- Month-over-month trends are clear (August decline visible)
- YTD progress toward target is obvious at a glance

---

## Reflection Questions

Answer these to test your understanding:

1. **Why use $5,000 threshold for VIP Champions instead of $500,000?**

2. **What business action should Olist take given 75% of orders are delayed?**

3. **How does RFM segmentation help marketing teams?**

4. **If MoM revenue growth is -4.13%, what questions should you ask next?**

5. **Why pre-calculate complex fields (like LAG) in SQL instead of Looker Studio?**

---

## Next Steps

Once completed:
1. **Save your dashboard** as "Week 15 - Executive KPI Dashboard - [Your Name]"
2. **Take screenshots** of your key visualizations
3. **Document insights** you discovered (especially delivery performance issue)
4. **Proceed to Exercise 2** - Marketing Performance Data Story Dashboard (Thursday)

**Excellent work!** You've created production-ready calculated fields that transform raw data into executive insights. These are the exact metrics used in real-world BI dashboards.

---

## Additional Challenge (Optional)

If you finish early, try these advanced tasks:

### Challenge 1: Create Customer Acquisition Cost (CAC) Field

**Business Context:** From Week 11 (Marketing Analytics)

**Note:** Campaign cost data doesn't exist in Olist dataset. Use simulated values for learning.

**Field Name:** `CAC_by_Channel`

**Formula:**
```
CASE origin
  WHEN "paid_search" THEN (COUNT(DISTINCT mql_id) * 50) / COUNT(DISTINCT customer_unique_id)
  WHEN "social" THEN (COUNT(DISTINCT mql_id) * 30) / COUNT(DISTINCT customer_unique_id)
  WHEN "email" THEN (COUNT(DISTINCT mql_id) * 10) / COUNT(DISTINCT customer_unique_id)
  WHEN "organic_search" THEN (COUNT(DISTINCT mql_id) * 5) / COUNT(DISTINCT customer_unique_id)
  ELSE (COUNT(DISTINCT mql_id) * 20) / COUNT(DISTINCT customer_unique_id)
END
```

**Visualization:** Bar chart showing CAC by marketing channel.

---

### Challenge 2: Create Delivery Delay Impact on Reviews

**Research Question:** Do delayed deliveries correlate with lower review scores?

**Create Scatter Plot:**
- X-axis: Delivery_Days
- Y-axis: review_score
- Color: Delivery_Performance category

**Expected Insight:** Longer delays likely correlate with lower review scores.

---

### Challenge 3: Build Cohort Retention Metric

**Advanced:** Calculate how many customers from each cohort make repeat purchases.

**Requires:** SQL pre-calculation for cohort analysis (see Week 9 materials).

---

**Instructor Note:** This exercise is data-intensive. Ensure students save their work frequently. Common issues include data source connection timeouts (refresh data source) and formula syntax errors (provide syntax reference sheet). Emphasize that these calculated fields are reusable across multiple dashboards—they're building a metric library.
