# Exercise 2: Year-to-Date Revenue Tracking & Target Achievement

## Week 15 - Wednesday - Exercise 2

### Estimated Time: 20 minutes

---

## Objective

Build a comprehensive Year-to-Date (YTD) revenue tracking dashboard that shows cumulative revenue progress, target achievement percentages, and month-over-month growth trends. This exercise focuses on running totals, period comparisons, and executive KPI scorecards.

---

## Prerequisites

Before starting, ensure you have:
- ✅ Completed Exercise 1 (Complex Calculated Fields)
- ✅ CLV_Tier, Delivery_Performance, and Average_Order_Value fields created
- ✅ Understanding of RUNNING_TOTAL function
- ✅ Familiarity with date range controls and scorecards

---

## Business Context

You're creating a **CFO Dashboard** for Olist's finance team. The leadership team needs to:
1. Track YTD revenue against annual target ($10M for 2018)
2. Monitor month-over-month growth rates
3. Identify revenue trends and seasonality
4. Compare current performance to prior year
5. Forecast year-end revenue based on trends

**Critical Success Metrics:**
- YTD Achievement: >85% by August means on track for annual target
- MoM Growth: Should average +5% for healthy business
- AOV Stability: Should remain within $150-$170 range

---

## Instructions

### Part 1: Create Year-to-Date (YTD) Cumulative Revenue Chart

#### Task 1.1: Create YTD Revenue Calculated Field

1. Open your data source in Edit mode
2. Click **"Add a field"**

**Field Name:** `YTD_Revenue`

**Formula:**
```
RUNNING_TOTAL(SUM(payment_value))
```

**Type:** Number (Currency)

**Explanation:**
- `SUM(payment_value)`: Aggregates revenue for each time period
- `RUNNING_TOTAL()`: Accumulates values cumulatively over time
- Result: Each point shows total revenue from start of year to that date

3. Click **"Save"** → **"Done"**

---

#### Task 1.2: Build YTD Revenue Area Chart

1. Create a new dashboard page or section titled: **"YTD Revenue Tracker"**

2. Add a **Time Series Chart**

3. Configure:
   - **Chart Type:** Area chart (filled)
   - **Dimension:** `order_purchase_timestamp`
   - **Date Granularity:** Week (smoother than daily, more detail than monthly)
   - **Metric:** YTD_Revenue
   - **Date Range Filter:** This year (or 2018 for Olist historical data)

4. Style:
   - **Title:** "Year-to-Date Revenue Progress"
   - **Subtitle:** "Cumulative revenue from January 1 to current date"
   - **Fill color:** Blue gradient (#4285F4)
   - **Opacity:** 70%
   - **Line thickness:** 2px

---

#### Task 1.3: Add Annual Target Reference Line

**Goal:** Show $10M target as red dashed line for visual comparison

1. In the same chart, click **"Style" tab**
2. Scroll to **"Reference lines"**
3. Click **"Add reference line"**
4. Configure:
   - **Axis:** Y-axis (left)
   - **Value:** 10000000 (or use metric: custom constant)
   - **Label:** "Annual Target: $10M"
   - **Position:** Value
   - **Line style:** Dashed
   - **Color:** Red (#EA4335)
   - **Line weight:** 2px

**Expected Result:** Blue area chart rising over time with horizontal red dashed line at $10M.

**Visual Indicator:**
- If blue line crosses red line = Target achieved!
- If blue line below red = Behind target
- Slope of blue line = Revenue acceleration/deceleration

---

### Part 2: YTD Target Achievement Scorecards

#### Task 2.1: Create YTD Achievement Percentage Field

**Field Name:** `YTD_Target_Achievement_Percent`

**Formula:**
```
(RUNNING_TOTAL(SUM(payment_value)) / 10000000) * 100
```

**Type:** Number

**Format:** Percentage (0 decimal places)

**Explanation:**
- Numerator: Current YTD revenue
- Denominator: $10M annual target
- Multiply by 100 for percentage
- Result: 85.3% means you're 85.3% toward annual goal

**Save the field.**

---

#### Task 2.2: Create YTD Achievement Scorecard

1. Add a **Scorecard** chart
2. Configure:
   - **Metric:** YTD_Target_Achievement_Percent
   - **Date Range:** This year
   - **Aggregation:** Use last value (most recent date)

3. Style:
   - **Title:** "Annual Target Achievement"
   - **Metric Label:** Remove (show just the percentage)
   - **Suffix:** "% of $10M target"
   - **Font size:** 48px (large, prominent)
   - **Number format:** 0 decimals

4. **Conditional Formatting:**
   - **Rule 1:** If >= 90%, Green background (#34A853)
   - **Rule 2:** If >= 75% AND < 90%, Yellow background (#FBBC04)
   - **Rule 3:** If < 75%, Red background (#EA4335)

**Expected Result (Aug 29, 2018):**
```
┌─────────────────────────┐
│ Annual Target Achievement│
│                         │
│        84.5%            │
│  of $10M target         │
│                         │
│  ⚠️ YELLOW (At Risk)     │
└─────────────────────────┘
```

**Business Insight:** 84.5% by late August means Olist is slightly behind pace. Need ~$1.55M in remaining 4 months (avg $387K/month).

---

#### Task 2.3: Create Actual YTD Revenue Scorecard

**For Context:** Show dollar amount alongside percentage

1. Add another **Scorecard**
2. Configure:
   - **Metric:** Create new field

**Field Name:** `Current_YTD_Revenue`

**Formula:**
```
RUNNING_TOTAL(SUM(payment_value))
```

**Type:** Currency

3. Style:
   - **Title:** "YTD Revenue (2018)"
   - **Format:** Currency, 0 decimals
   - **Prefix:** "$"
   - **Compact numbers:** Yes (shows $8.45M instead of $8,452,980)

**Expected Result:** $8.45M (as of August 29, 2018)

---

### Part 3: Month-over-Month Growth Analysis

#### Task 3.1: Create Monthly Revenue Table with MoM Growth

**Pre-Calculation Note:** True MoM growth requires LAG function. Since Looker Studio has limited support, we'll use the built-in comparison feature.

**Approach: Use Scorecard Comparison Feature**

1. Add a **Scorecard**
2. Configure:
   - **Metric:** `SUM(payment_value)` (Total Revenue)
   - **Date Range:** This month (or August 2018 for historical data)

3. **Data tab** → **"Comparison Date Range"**:
   - **Enable:** "Show comparison"
   - **Comparison Type:** "Previous period"
   - **Show:** "Change" and "Percent change"

4. Style:
   - **Title:** "Monthly Revenue with MoM Growth"
   - **Comparison Label:** "vs Last Month"
   - **Color:** Green for positive growth, Red for negative

**Expected Result (August 2018):**
```
┌─────────────────────────┐
│  Monthly Revenue        │
│  $985,414               │
│  ↓ -$42,486 (-4.13%)   │
│  vs Last Month          │
└─────────────────────────┘
```

**Business Alert:** Negative MoM growth should trigger investigation.

---

#### Task 3.2: Create MoM Trend Combo Chart

**Goal:** Visualize monthly revenue bars with growth % line overlay

1. Add a **Combo Chart**
2. Configure:
   - **Dimension:** `order_purchase_timestamp` (set to Month granularity)
   - **Date Range:** Last 12 months (or all 2018)

3. **Metrics:**
   - **Left Y-Axis (Bars):** `SUM(payment_value)` → Rename "Monthly Revenue"
   - **Right Y-Axis (Line):** Create simplified growth indicator

**Simplified Growth Indicator Field:**

**Field Name:** `Revenue_vs_Average_Percent`

**Formula:**
```
((SUM(payment_value) - AVG(SUM(payment_value))) / AVG(SUM(payment_value))) * 100
```

**Explanation:** Shows each month's performance vs overall monthly average (not true MoM, but useful for spotting trends)

4. Style:
   - **Title:** "Monthly Revenue Trend with Performance Indicator"
   - **Bars:** Blue (#4285F4)
   - **Line:** Orange (#FF9800)
   - **Line thickness:** 3px
   - **Show data labels:** On bars only

**Expected Visual:**
- Bars: Revenue volume per month
- Line: Fluctuates above/below zero (above = better than average month)

---

### Part 4: Average Order Value (AOV) Stability Tracking

#### Task 4.1: Create AOV Trend Line Chart

**Goal:** Monitor if AOV is stable or declining (critical metric)

1. Add a **Line Chart**
2. Configure:
   - **Dimension:** `order_purchase_timestamp` (Month)
   - **Date Range:** This year (or 2018)
   - **Metric:** `Average_Order_Value` (created in Exercise 1)

3. Style:
   - **Title:** "Average Order Value by Month"
   - **Subtitle:** "Target Range: $150-$170"
   - **Line color:** Green (#34A853)
   - **Line thickness:** 3px
   - **Show data points:** Yes (dots on line)
   - **Show trend line:** Yes (dotted line showing overall direction)

4. **Add Reference Lines:**
   - **Upper Bound:** $170 (green dashed)
   - **Lower Bound:** $150 (red dashed)
   - **Labels:** "Target Max", "Target Min"

**Expected Result:** Line fluctuating between $147-$169, mostly within target range.

**Business Insight:** If AOV drops below $150, investigate:
- Product mix shift (more low-value items)
- Discount campaigns eroding margins
- Decreased bundle purchases

---

#### Task 4.2: Create AOV Scorecard with Conditional Alert

1. Add a **Scorecard**
2. Configure:
   - **Metric:** `Average_Order_Value`
   - **Date Range:** This month

3. **Conditional Formatting:**
   - **Green:** AOV >= $160 (healthy)
   - **Yellow:** AOV $150-$160 (acceptable)
   - **Red:** AOV < $150 (⚠️ problem)

4. Style:
   - **Title:** "Current Month AOV"
   - **Font size:** 42px

**Expected Result (August 2018):** $155.16 (Yellow - acceptable but below ideal)

---

### Part 5: Revenue Forecast Projection

#### Task 5.1: Calculate Required Monthly Revenue to Hit Target

**Business Question:** "How much revenue per month do we need in remaining months to hit $10M?"

**Manual Calculation for Learning:**
- Annual Target: $10,000,000
- YTD Revenue (as of Aug 29): $8,452,980
- Remaining: $1,547,020
- Months Left: 4 (Sept, Oct, Nov, Dec)
- Required Avg per Month: $1,547,020 / 4 = $386,755

**Create Text Box with Insight:**

1. Add a **Text Box** to your dashboard
2. Content:
```
📊 Forecast Analysis

YTD Performance: $8.45M (84.5% of target)
Remaining Target: $1.55M
Months Remaining: 4
Required Avg/Month: $387K

Recent 3-Month Avg: $1.02M
Status: ✅ ON TRACK (if trend continues)

⚠️ Action Required: Maintain current sales velocity
```

3. Style:
   - Background: Light blue (#E8F5FD)
   - Border: Blue solid 2px
   - Font: 14px, left-aligned
   - Position: Top-right of dashboard

---

#### Task 5.2: Create Simple Linear Forecast (Optional Advanced)

**Note:** Looker Studio doesn't have native forecasting. This is a simplified projection.

**Approach: Add Trend Line to YTD Chart**

1. Return to your YTD Revenue Area Chart (Part 1)
2. **Style tab** → **"Trend line"**
3. Enable trend line:
   - **Type:** Linear
   - **Line style:** Dotted
   - **Color:** Gray (#9E9E9E)
   - **Extend:** Project to December 31

**Visual Result:** Dotted line extends beyond current date, showing projected revenue if trend continues.

**Business Use:** Quick visual forecast (not statistically rigorous, but useful for executives)

---

### Part 6: Dashboard Layout and Organization

#### Task 6.1: Organize YTD Dashboard Layout

Arrange your charts in this priority order:

```
┌─────────────────────────────────────────────────────────────┐
│ YTD REVENUE TRACKER - 2018                                  │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  ┌──────────────┐ ┌──────────────┐ ┌──────────────┐        │
│  │ YTD Revenue  │ │ Target %     │ │ Current AOV  │        │
│  │ $8.45M       │ │ 84.5%        │ │ $155.16      │        │
│  │              │ │ ⚠️ At Risk    │ │ ⚠️ Below Ideal│        │
│  └──────────────┘ └──────────────┘ └──────────────┘        │
│                                                             │
│  ┌──────────────────────────────────────────────────────┐  │
│  │ YTD Revenue Progress (Area Chart with Target Line)   │  │
│  │ [Blue area rising toward red $10M line]              │  │
│  └──────────────────────────────────────────────────────┘  │
│                                                             │
│  ┌────────────────────────────┐  ┌──────────────────────┐  │
│  │ Monthly Revenue Trend      │  │ AOV Stability        │  │
│  │ (Combo Chart)              │  │ (Line Chart)         │  │
│  │ Bars + Growth % Line       │  │ With target bands    │  │
│  └────────────────────────────┘  └──────────────────────┘  │
│                                                             │
│  ┌────────────────────────────┐  ┌──────────────────────┐  │
│  │ Forecast Analysis (Text)   │  │ Monthly Revenue      │  │
│  │ Required: $387K/month      │  │ (Scorecard w/ MoM)   │  │
│  │ Status: ✅ On track         │  │ $985K (-4.13%)       │  │
│  └────────────────────────────┘  └──────────────────────┘  │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

#### Task 6.2: Add Date Range Control

1. Add a **Date Range Control** at the top
2. Configure:
   - **Dimension:** order_purchase_timestamp
   - **Default:** This year
   - **Position:** Top-center, full width

**Allow users to:**
- View full 2018
- Focus on specific quarters
- Compare year-over-year (if multi-year data available)

---

### Part 7: Testing and Validation

#### Task 7.1: Verify YTD Calculations

**Test 1: Manual Calculation Check**

1. Filter to: January 1 - August 29, 2018
2. Check YTD Revenue scorecard shows: ~$8.45M
3. Manually verify in SQL (if possible):

```sql
SELECT SUM(payment_value) AS ytd_revenue
FROM olist_sales_data_set.olist_orders_dataset o
JOIN olist_sales_data_set.olist_order_payments_dataset p
  ON o.order_id = p.order_id
WHERE order_status = 'delivered'
  AND order_purchase_timestamp >= '2018-01-01'
  AND order_purchase_timestamp <= '2018-08-29';
```

**Expected:** $8,452,980

---

**Test 2: Running Total Validation**

1. Click on any point in YTD area chart (e.g., June 30)
2. Verify value matches cumulative sum from Jan 1 to that date
3. Should always be increasing (never decrease)

**If running total resets or decreases:**
- Check date dimension granularity (should be Day or Week, not Month)
- Verify date filter is continuous (not broken into separate periods)

---

**Test 3: Target Achievement Calculation**

Manual formula check:
- YTD Revenue: $8,452,980
- Target: $10,000,000
- Calculation: (8452980 / 10000000) * 100 = 84.53%

**Scorecard should show:** 84% or 85% (rounded)

---

## Submission Checklist

Before marking this exercise complete, verify:

```
☐ YTD_Revenue calculated field created with RUNNING_TOTAL function
☐ YTD area chart displays cumulative revenue trend
☐ $10M target reference line added to YTD chart (red dashed)
☐ YTD_Target_Achievement_Percent field calculates correctly
☐ Target achievement scorecard shows ~84.5% for Aug 2018
☐ Conditional formatting applied (Green/Yellow/Red based on achievement)
☐ Actual YTD revenue scorecard displays $8.45M
☐ Monthly revenue scorecard with MoM comparison shows -4.13% for Aug
☐ MoM trend combo chart displays bars (revenue) + line (growth indicator)
☐ AOV trend line chart shows monthly fluctuation with target range bands
☐ AOV scorecard with conditional formatting shows current month value
☐ Forecast analysis text box displays required monthly revenue
☐ Dashboard layout organized with scorecards at top, charts below
☐ Date range control added for user exploration
☐ All calculations verified against validation report values
```

---

## Troubleshooting

### Issue 1: "YTD Running Total Resets Each Month"

**Symptom:** Area chart drops back to zero at month boundaries

**Causes & Solutions:**
- ❌ Date dimension set to "Month" granularity
  - ✅ Change to "Day" or "Week" for continuous running total
- ❌ Date filter has gaps (e.g., filtering specific months non-consecutively)
  - ✅ Use continuous date range (Jan 1 - Current Date)

---

### Issue 2: "Target Achievement Shows >100% in January"

**Symptom:** Scorecard shows 150% achievement early in year

**Cause:** Using total revenue instead of YTD

**Solution:** Ensure using `RUNNING_TOTAL()` formula, not just `SUM()`

---

### Issue 3: "Reference Line Not Visible on Chart"

**Symptom:** Added $10M reference line but can't see it

**Causes & Solutions:**
- ❌ Line value outside Y-axis range
  - ✅ Adjust Y-axis max to at least $10.5M
- ❌ Line color same as background
  - ✅ Change to contrasting color (red/orange)
- ❌ Reference line on wrong axis
  - ✅ Verify set to "Left Y-axis" (revenue axis)

---

### Issue 4: "MoM Comparison Shows '--' (No Data)"

**Symptom:** Previous period comparison blank

**Cause:** Previous period outside dataset date range

**Solution:**
- Olist data: Sep 2016 - Oct 2018
- September 2016 has no prior month for comparison
- Adjust date range or note limitation

---

### Issue 5: "AOV Seems Too High or Too Low"

**Symptom:** AOV shows $500+ or $5

**Causes & Solutions:**
- ❌ Using wrong revenue field (price vs payment_value)
  - ✅ Use `SUM(payment_value)` for total revenue
- ❌ Counting order items instead of orders
  - ✅ Use `COUNT(DISTINCT order_id)` not `COUNT(order_item_id)`
- ❌ Including canceled/refunded orders
  - ✅ Filter to `order_status = 'delivered'`

---

## Expected Outcomes

### Final Dashboard Should Show:

**Executive Summary View:**
1. **Three Key Scorecards:** YTD Revenue ($8.45M), Target Achievement (84.5%), Current AOV ($155)
2. **Main Visual:** YTD area chart clearly showing progress toward $10M target line
3. **Trend Analysis:** Monthly revenue bars with growth indicator overlay
4. **Stability Check:** AOV line chart with target range bands
5. **Actionable Forecast:** Text insight showing required monthly revenue

**Business Insights Revealed:**
- Olist is 84.5% toward annual target (slightly behind pace)
- August saw -4.13% MoM decline (concerning trend)
- AOV stable around $155 (within acceptable range)
- Need $387K/month average in remaining 4 months (achievable based on trends)

---

## How to Know You Succeeded

✅ **Visual Test:**
- YTD area chart shows smooth upward trend (no drops)
- Target reference line clearly visible and provides context
- Scorecards use appropriate colors (Yellow for 84.5% achievement)
- All charts update when date range filter changes

✅ **Calculation Test:**
- YTD revenue matches validation report: $8,452,980
- Target achievement calculates to 84.5%
- MoM growth for August shows -4.13%
- AOV for August shows $155.16

✅ **Business Value Test:**
- CFO can immediately see YTD performance at a glance
- Dashboard clearly shows whether on track for annual target
- Forecast insight provides actionable guidance
- Trends reveal potential issues (August decline) for investigation

---

## Reflection Questions

Answer these to test your understanding:

1. **Why use RUNNING_TOTAL instead of regular SUM for YTD metrics?**

2. **What does 84.5% target achievement in late August indicate about year-end forecast?**

3. **Why is the -4.13% MoM decline in August concerning?**

4. **How would you explain the difference between YTD revenue and monthly revenue to a non-technical executive?**

5. **If AOV drops from $160 to $145 next month, what business factors might explain this?**

---

## Next Steps

Once completed:
1. **Save dashboard** as "Week 15 - YTD Revenue Tracker - [Your Name]"
2. **Take screenshots** of your KPI scorecards and YTD chart
3. **Document insights** discovered (especially August decline and forecast)
4. **Prepare for Thursday** - Data Storytelling session (presenting these insights narratively)

**Excellent work!** You've built a production-ready CFO dashboard with YTD tracking, target monitoring, and trend analysis. These are core BI skills for financial reporting roles.

---

## Additional Challenge (Optional)

If you finish early, try these advanced tasks:

### Challenge 1: Add Quarterly Performance Breakdown

**Create Table:**
- Dimension: `EXTRACT(QUARTER FROM order_purchase_timestamp)`
- Metrics: Revenue, Order Count, AOV, Growth vs Previous Quarter

**Shows:** Q1 vs Q2 vs Q3 performance comparison

---

### Challenge 2: Build "Days to Target" Countdown

**Calculated Field:**
```
CASE
  WHEN RUNNING_TOTAL(SUM(payment_value)) >= 10000000 THEN "TARGET ACHIEVED! ✅"
  ELSE CONCAT(
    "Need $",
    CAST(ROUND((10000000 - RUNNING_TOTAL(SUM(payment_value))) / 1000, 0) AS STRING),
    "K more"
  )
END
```

**Visualization:** Scorecard showing remaining amount to target

---

### Challenge 3: Create Revenue Run Rate Metric

**Business Concept:** Annualize current monthly revenue to project year-end

**Formula:**
```
SUM(payment_value) * (12 / [months_elapsed_in_year])
```

**Interpretation:** "If we maintain current pace, we'll finish with $X"

---

**Instructor Note:** This exercise reinforces cumulative calculations (RUNNING_TOTAL) and period comparisons. Common student confusion: mixing running totals with regular aggregations. Emphasize that running totals only make sense on time series charts with date dimensions. The YTD metrics created here will be used in Thursday's data storytelling exercise.
