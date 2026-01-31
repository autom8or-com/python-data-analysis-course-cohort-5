# Exercise 2: Conditional Formatting and Time Series Enhancements

## Week 14 - Wednesday - Exercise 2

### Estimated Time: 30 minutes

---

## Objective

Apply conditional formatting rules to create visual indicators for business insights, and enhance time series visualizations with trend lines, reference lines, and comparison periods. Transform your dashboard from data display to actionable intelligence.

---

## Prerequisites

Before starting, ensure you have:
- ✅ Completed Exercise 1 (Interactive Controls)
- ✅ Dashboard: "Week 14 - Interactive Dashboard - [Your Name]"
- ✅ Completed Week 14 Lecture Part 3 (Conditional Formatting)
- ✅ Completed Week 14 Lecture Part 4 (Time Series Best Practices)

---

## Instructions

### Part 1: Apply Color-Based Conditional Formatting

#### Task 1.1: Create KPI Scorecards with Status Colors

**Scenario:** Create an average delivery time scorecard that turns red if delivery takes too long.

1. Add a new **Scorecard** to your dashboard
2. Configure:
   - Metric: `AVG(delivery_time_days)`
   - Label: "Avg Delivery Time (Days)"
3. Position: Below your existing scorecards

**Apply Conditional Formatting:**

4. With scorecard selected, go to **"Style"** tab → **"Conditional formatting"**
5. Click **"+ Add rule"**
6. Configure Rule 1 (Excellent Performance):
   ```
   If: AVG(delivery_time_days) <= 7
   Color Type: Single color
   Background color: Light green (#D4EDDA)
   Font color: Dark green (#155724)
   ```

7. Click **"+ Add rule"** for Rule 2 (Acceptable Performance):
   ```
   If: AVG(delivery_time_days) > 7 AND AVG(delivery_time_days) <= 14
   Color Type: Single color
   Background color: Light yellow (#FFF3CD)
   Font color: Dark orange (#856404)
   ```

8. Click **"+ Add rule"** for Rule 3 (Poor Performance):
   ```
   If: AVG(delivery_time_days) > 14
   Color Type: Single color
   Background color: Light red (#F8D7DA)
   Font color: Dark red (#721C24)
   ```

**Expected Result:** Scorecard background color changes based on delivery performance.

---

#### Task 1.2: Create On-Time Delivery Rate with Thresholds

1. Add another **Scorecard**
2. Create a calculated field at chart level:
   - Click **"ADD A FIELD"** in Data tab
   - Field Name: `on_time_rate`
   - Formula:
     ```
     COUNTD(CASE WHEN delivery_status = "On Time" THEN order_id END) /
     COUNTD(order_id)
     ```
3. Configure scorecard:
   - Metric: `on_time_rate`
   - Label: "On-Time Delivery Rate"
   - Format: Percentage (0 decimal places)

**Apply Conditional Formatting:**

4. Style tab → Conditional formatting → Add rules:

   **Rule 1 (Excellent):**
   ```
   If: on_time_rate >= 0.90
   Background: Dark green (#28A745)
   Font: White (#FFFFFF)
   ```

   **Rule 2 (Good):**
   ```
   If: on_time_rate >= 0.75 AND on_time_rate < 0.90
   Background: Light green (#D4EDDA)
   Font: Dark green (#155724)
   ```

   **Rule 3 (Needs Improvement):**
   ```
   If: on_time_rate < 0.75
   Background: Red (#DC3545)
   Font: White (#FFFFFF)
   ```

**Expected Result:** Scorecard visually indicates delivery performance at a glance.

---

### Part 2: Apply Table Conditional Formatting

#### Task 2.1: Create Regional Performance Table with Color Coding

1. Add a **Table** chart to your dashboard
2. Configure dimensions and metrics:
   - Dimension: `region`
   - Metrics (in order):
     - `Record Count` (rename to "Orders")
     - `SUM(total_order_value)` (rename to "Revenue")
     - `AVG(delivery_time_days)` (rename to "Avg Delivery")
     - `AVG(price)` (rename to "Avg Order Value")

**Apply Conditional Formatting to Revenue Column:**

3. With table selected, go to **Style** tab
4. Find **"Conditional formatting"** section
5. Click **"Add rule"**
6. Configure:
   ```
   Apply to: SUM(total_order_value)

   Color Type: Color scale
   Gradient:
   - Minimum: Light red (#FFEBEE)
   - Midpoint: Light yellow (#FFF9C4)
   - Maximum: Dark green (#1B5E20)

   Scale type: Gradient
   ```

**Apply Conditional Formatting to Delivery Time Column:**

7. Click **"+ Add rule"**
8. Configure:
   ```
   Apply to: AVG(delivery_time_days)

   If: AVG(delivery_time_days) > 15
   Color Type: Single color
   Background: Light red (#FFCDD2)
   Font: Dark red (#B71C1C)
   ```

**Expected Result:** Table cells are color-coded, making high/low performers immediately visible.

---

#### Task 2.2: Create Top Products Table with Performance Indicators

1. Edit your data source to add product information (if not already connected)
2. Create a new **Table** chart
3. Configure:
   - Dimension: `product_id` (or category if available)
   - Metrics:
     - `Record Count` (Orders)
     - `SUM(price)` (Revenue)
     - Chart-level calculated field:
       ```
       Name: revenue_per_order
       Formula: SUM(price) / COUNT(order_id)
       ```

4. Sort: Descending by Revenue
5. Row limit: Top 10

**Apply Data Bars:**

6. Style tab → Conditional formatting
7. Add rule for Revenue column:
   ```
   Apply to: SUM(price)
   Color Type: Data bars
   Bar color: Blue (#4285F4)
   Show values: ☑ Yes
   ```

8. Add rule for Revenue per Order:
   ```
   Apply to: revenue_per_order
   Color Type: Color scale
   Minimum: White (#FFFFFF)
   Maximum: Green (#34A853)
   ```

**Expected Result:** Table shows data bars for visual comparison and color intensity for value.

---

### Part 3: Enhance Time Series Visualizations

#### Task 3.1: Add Trend Line to Orders Over Time

1. Select your existing **Time Series Chart** (Orders Over Time)
2. Go to **Style** tab
3. Find **"Trend line"** section
4. Configure:
   ```
   ☑ Show trend line
   Type: Linear
   Line weight: 2
   Line color: Red (#EA4335)
   Opacity: 70%
   ☑ Show data labels: No
   ```

**Expected Result:** A trend line appears showing overall growth or decline pattern.

---

#### Task 3.2: Add Reference Line for Target Orders

**Scenario:** Your business target is 300 orders per day.

1. With time series selected, Style tab
2. Find **"Reference lines"** section
3. Click **"+ Add reference line"**
4. Configure:
   ```
   Value: 300 (or calculate average)
   Label: "Daily Target"
   Line style: Dashed
   Line color: Orange (#FF9800)
   Line weight: 2
   Opacity: 80%
   Label position: Right
   ```

**Expected Result:** Horizontal line shows when actual orders exceed or fall below target.

---

#### Task 3.3: Enable Date Comparison for Year-over-Year Analysis

**Note:** This requires data from multiple years. If using 2017-only data, adapt to month-over-month.

1. In your date range control, ensure **"Allow date comparisons"** is ☑ checked
2. Create a new **Time Series Chart**
3. Configure:
   - Dimension: `order_purchase_timestamp`
   - Metric: `SUM(total_order_value)`
   - Date range: Comparison enabled

4. In **Data** tab:
   - Comparison date range: **"Previous period"**
   - Show comparison: ☑ Yes

5. Style tab:
   - Current period color: Blue (#4285F4)
   - Comparison period color: Gray (#9E9E9E)
   - Line weight: 3

**Expected Result:** Two lines show current vs previous period for easy comparison.

---

### Part 4: Create Advanced Conditional Formatting with Multiple Conditions

#### Task 4.1: Create Order Value Category Table with Alert Symbols

1. Add a new **Table** chart
2. Configure:
   - Dimension: `order_value_category`
   - Metrics:
     - `Record Count`
     - `SUM(total_order_value)`
     - `AVG(delivery_time_days)`

**Add Symbol-Based Formatting:**

3. Style tab → Conditional formatting
4. Add rule for delivery performance:
   ```
   Apply to: AVG(delivery_time_days)

   Rule 1:
   If: AVG(delivery_time_days) <= 7
   Background: Green (#E8F5E9)
   Font: Dark green (#2E7D32)
   Prefix text: "✓ "  (checkmark)

   Rule 2:
   If: AVG(delivery_time_days) > 14
   Background: Red (#FFEBEE)
   Font: Dark red (#C62828)
   Prefix text: "⚠ "  (warning)
   ```

**Expected Result:** Quick visual indicators using symbols and colors.

---

### Part 5: Create a Comparison Scorecard with Period Change

#### Task 5.1: Build Revenue Change Indicator

1. Add a **Scorecard with Compact Numbers**
2. Configure:
   - Metric: `SUM(total_order_value)`
   - Label: "Total Revenue"
   - Comparison: **"Previous period"**

3. Style tab:
   ```
   Compact numbers: ☑ Yes
   Show comparison: ☑ Yes
   Comparison label: "vs Previous Period"

   Positive change color: Green (#34A853)
   Negative change color: Red (#EA4335)
   ```

**Apply Conditional Formatting to Change Value:**

4. Conditional formatting → Add rule:
   ```
   If: Percent change > 10
   Background: Light green
   Font: Dark green

   If: Percent change < -10
   Background: Light red
   Font: Dark red
   ```

**Expected Result:** Scorecard shows revenue with up/down arrow and percentage change.

---

### Part 6: Test Your Conditional Formatting

#### Task 6.1: Interactive Testing

1. Enter **View Mode**
2. Test these scenarios:

**Test Scenario 1: Filter to Poor Performing Region**
- Use region filter to select "North"
- Observe:
  - Do delivery time scorecards turn red?
  - Does the regional table highlight North in red?

**Test Scenario 2: Filter to High-Performance Period**
- Set date range to November-December 2017 (holiday season)
- Observe:
  - Does revenue change scorecard show positive growth?
  - Do scorecards turn green?

**Test Scenario 3: Product Performance**
- Filter by "Premium" price tier
- Observe:
  - How do conditional formatting rules adjust?
  - Which regions/products perform best visually?

---

## Submission Checklist

Before marking this exercise as complete, verify:

```
☐ Delivery time scorecard created with 3-tier color coding (green/yellow/red)
☐ On-time rate scorecard with percentage-based conditional rules
☐ Regional performance table with gradient color scale on revenue
☐ Table rows highlighted when delivery time exceeds threshold
☐ Product table with data bars showing revenue visually
☐ Time series chart with trend line added (linear regression)
☐ Reference line added to time series (target or average)
☐ Date comparison enabled on at least one chart
☐ Order category table with symbol-based alerts (✓ and ⚠)
☐ Comparison scorecard showing period-over-period change
☐ All conditional formatting rules tested and working
☐ Colors follow accessibility guidelines (sufficient contrast)
```

---

## Troubleshooting

### Issue 1: "Conditional Formatting Not Applying"

**Possible Causes:**

**Problem:** Rule condition never evaluates to true
- **Solution:** Check your thresholds—use View mode to see actual values first
- **Example:** If avg delivery is 12 days, rule for "> 15" won't trigger

**Problem:** Multiple conflicting rules
- **Solution:** Rules apply in order—first matching rule wins
- **Fix:** Reorder rules (most specific first, general last)

---

### Issue 2: "Colors Don't Show in Color Scale"

**Problem:** Data range is too narrow
- **Solution:**
  1. Check min/max values in your data
  2. Manually set scale range if needed
  3. Use percentiles instead of absolute values

**Problem:** All values are the same
- **Solution:** Color scale needs variation—check if filter is too restrictive

---

### Issue 3: "Trend Line Looks Wrong"

**Problem:** Not enough data points
- **Solution:** Trend lines need at least 3-5 data points
- **Fix:** Adjust date granularity (daily → weekly) or expand date range

**Problem:** Outliers skew the trend
- **Solution:**
  1. Add filters to remove anomalies
  2. Use "Polynomial" instead of "Linear" trend type

---

### Issue 4: "Reference Line Doesn't Appear"

**Problem:** Value is outside visible range
- **Solution:** Check if reference value (e.g., 300) is within your data's Y-axis range

**Problem:** Line hidden behind chart elements
- **Solution:** Style tab → Reference line → Increase opacity or change color

---

### Issue 5: "Comparison Period Shows 'No Data'"

**Problem:** Comparison period has no data
- **Solution:** Ensure your dataset covers the comparison period
- **Example:** Comparing 2017 vs 2016 requires 2016 data

**Problem:** Date field not properly configured
- **Solution:** Edit data source → Ensure date field is type "Date & Time"

---

## Expected Outcomes

### Visual Indicators Dashboard

Your enhanced dashboard should now have:

```
┌──────────────────────────────────────────────────────────────────┐
│ Week 14 - Interactive Dashboard - [Your Name]                   │
├──────────────────────────────────────────────────────────────────┤
│  [Date Range] [Region Filter] [Price Tier] [Delivery Status]    │
│                                                                  │
│  ┌────────────┐ ┌────────────┐ ┌──────────────┐ ┌────────────┐ │
│  │   Total    │ │   Avg      │ │  On-Time     │ │  Revenue   │ │
│  │  Revenue   │ │  Delivery  │ │  Rate        │ │  vs Prev   │ │
│  │            │ │            │ │              │ │            │ │
│  │ $9.7M      │ │ 🟡 12 days │ │ 🟢 87%       │ │ 🟢 +15%    │ │
│  └────────────┘ └────────────┘ └──────────────┘ └────────────┘ │
│                                                                  │
│  ┌──────────────────────────────────────────────────────────┐   │
│  │ Revenue by Region (Color-Coded Table)                    │   │
│  │ ─────────────────────────────────────────────────────────│   │
│  │ Region      │ Orders │ Revenue    │ Avg Delivery │ AOV   │   │
│  │─────────────│────────│────────────│──────────────│───────│   │
│  │ Southeast   │ 45,000 │ $5.2M 🟢🟢 │ 11 days      │ $142  │   │
│  │ South       │ 18,000 │ $2.1M 🟢   │ 13 days      │ $138  │   │
│  │ Northeast   │ 12,000 │ $1.4M 🟡   │ 14 days      │ $128  │   │
│  │ Central-West│  5,000 │ $600K 🟡   │ 🔴 16 days   │ $125  │   │
│  │ North       │  2,000 │ $200K 🔴   │ 🔴 18 days   │ $119  │   │
│  └──────────────────────────────────────────────────────────┘   │
│                                                                  │
│  ┌──────────────────────────────────────────────────────────┐   │
│  │ Orders Over Time with Trend Line                         │   │
│  │                                              ──── Target │   │
│  │  350 |                    ╱╲                ┄┄┄┄┄┄       │   │
│  │      |          ╱╲      ╱    ╲    ╱╲                    │   │
│  │  300 |────────────────────────────────────────────── ←  │   │
│  │      |      ╱╲╱  ╲  ╱╲╱      ╲╱╲╱  ╲                   │   │
│  │  250 |    ╱                        ╲        ╱ Trend    │   │
│  │      |  ╱                            ╲    ╱            │   │
│  │  200 |╱                                ╲╱               │   │
│  │      Jan  Feb  Mar  Apr  May  Jun  Jul  Aug  Sep  Oct  │   │
│  └──────────────────────────────────────────────────────────┘   │
│                                                                  │
│  ┌──────────────────────────────────────────────────────────┐   │
│  │ Top 10 Products by Revenue (with Data Bars)              │   │
│  │ ─────────────────────────────────────────────────────────│   │
│  │ Product ID  │ Orders │ Revenue                           │   │
│  │─────────────│────────│───────────────────────────────────│   │
│  │ PROD-001    │   450  │ $85,000 ████████████████████      │   │
│  │ PROD-002    │   380  │ $72,000 ████████████████          │   │
│  │ PROD-003    │   340  │ $65,000 ██████████████            │   │
│  │ PROD-004    │   310  │ $58,000 ████████████              │   │
│  └──────────────────────────────────────────────────────────┘   │
│                                                                  │
└──────────────────────────────────────────────────────────────────┘
```

**Color Legend:**
- 🟢 Green: Good performance / Above target
- 🟡 Yellow: Acceptable / Within range
- 🔴 Red: Needs attention / Below target

---

## How to Know You Succeeded

✅ **Visual Clarity Test:**
- Users can instantly identify high/low performers without reading numbers
- Color coding is consistent across dashboard (green = good, red = bad)
- Data bars make relative sizes immediately clear

✅ **Business Insight Test:**
- Scorecards change color based on KPI thresholds
- Regional table highlights underperforming areas in red
- Trend line shows growth trajectory at a glance

✅ **Interactivity Test:**
- Conditional formatting updates when filters change
- Colors recalculate based on filtered data set
- Comparison periods show accurate period-over-period change

✅ **Accessibility Test:**
- Color contrasts are readable (dark text on light background)
- Information not conveyed by color alone (use symbols + color)
- Font sizes are legible when colored backgrounds applied

---

## Reflection Questions

Answer these to test your understanding:

1. **What is the difference between "single color" and "color scale" conditional formatting? When would you use each?**

2. **Why is it important to order conditional formatting rules from specific to general?**

3. **How does a trend line help business users vs. just showing the raw data points?**

4. **What is the business value of adding reference lines to charts?**

5. **Why should you combine symbols (✓ ⚠) with colors in conditional formatting?**

6. **If you have data from January-December 2017 and enable "previous period" comparison in December, what period will be compared?**

---

## Next Steps

After completing this exercise:

1. **Review your dashboard critically:**
   - Is the color coding intuitive?
   - Can someone unfamiliar with the data understand the insights?
   - Are there too many colors (visual overload)?

2. **Document your formatting rules:**
   - Screenshot the conditional formatting settings
   - Note business justification for each threshold

3. **Prepare for Thursday:**
   - Similar concepts apply to Streamlit (color coding, comparisons)
   - Think about how SQL queries would create these categories

**Excellent work!** You've transformed a data dashboard into an insights dashboard. Conditional formatting is a powerful tool for directing attention to what matters most.

---

## Additional Challenge (Optional)

If you finish early, try these advanced formatting techniques:

### Challenge 1: Create a Stoplight Chart

Build a single visual that combines:
- Circle shapes (use scorecard + custom styling)
- Three KPIs arranged vertically
- Red/Yellow/Green color scheme (like a traffic light)

**Metrics:**
- 🔴 Late Delivery Rate (should be red if >15%)
- 🟡 On-Time Rate (yellow if 75-90%)
- 🟢 Early Delivery Rate (green if >10%)

---

### Challenge 2: Implement Heat Map Table

Create a table showing:
- Rows: Regions
- Columns: Months
- Values: Revenue
- Formatting: Color scale (white to dark green)

**Configuration:**
- Use pivot table structure
- Apply gradient across entire table
- Identify seasonal patterns visually

---

### Challenge 3: Create Sparklines for Trends

**Note:** Looker Studio doesn't have native sparklines, but you can simulate:

1. Create small time series charts (50px high, 150px wide)
2. Remove axes labels and gridlines
3. Embed next to table rows
4. Shows trend without taking much space

**Use case:** Regional performance table + mini trend chart per region

---

### Challenge 4: Build an Executive Summary Scorecard

Create a "dashboard on a single screen" with:
- 4 key KPI scorecards with conditional formatting
- Traffic light colors based on targets
- Period comparison enabled
- Reference lines for each metric
- No detailed charts (high-level view only)

**Target audience:** Executives who want 30-second insights

---

**Instructor Note:** Emphasize that conditional formatting should enhance understanding, not just add decoration. Each color rule should have a business justification. Common student mistakes include too many colors (visual noise) and thresholds that don't reflect actual business targets. Review color accessibility—avoid red/green only combinations for colorblind users.
