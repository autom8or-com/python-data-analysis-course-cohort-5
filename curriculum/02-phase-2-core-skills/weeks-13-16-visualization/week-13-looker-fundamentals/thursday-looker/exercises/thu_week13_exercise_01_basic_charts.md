# Week 13 Thursday - Exercise 1: Basic Chart Types

**Estimated Time:** 45 minutes
**Difficulty:** Beginner
**Prerequisites:** Completed Wednesday's data source connection exercise

---

## Exercise Overview

In this exercise, you'll create four different chart types using the Olist e-commerce dataset. You'll practice selecting appropriate visualizations for different business questions and apply proper formatting for Nigerian business context.

**Business Scenario:**
You're a data analyst at **NaijaCommerce**, a Lagos-based online marketplace. The COO has requested a quick analysis of current performance using four specific visualizations. This is a practice run before you build the complete dashboard in Exercise 2.

---

## Learning Objectives

By completing this exercise, you will:
- Create scorecards showing single KPIs
- Build a bar chart for category comparisons
- Design a pie chart for proportion analysis
- Construct a data table for detailed records
- Apply proper Nigerian formatting (NGN, date formats)
- Use conditional formatting for performance indicators

---

## Prerequisites Check

Before starting, ensure you have:
- [ ] Looker Studio account (free Google account)
- [ ] Access to Supabase Olist database
- [ ] Completed Wednesday's data source connection
- [ ] Data source named: `olist_sales_orders` (or similar)

**If you haven't completed Wednesday's connection:**
1. Open Looker Studio (datastudio.google.com)
2. Create new report
3. Add PostgreSQL connector
4. Connect to Supabase (credentials provided by instructor)
5. Select tables: `olist_orders_dataset` and `olist_order_items_dataset`

---

## Setup Instructions

### Step 1: Create New Report

1. Go to Looker Studio (datastudio.google.com)
2. Click **Create** → **Report**
3. Title your report: **"Week 13 Exercise 1 - Basic Charts"**
4. Canvas size: Standard (default 960px wide)

---

### Step 2: Connect Data Source

1. Click **Add Data**
2. Select your existing data source from Wednesday
3. If creating new:
   - Connector: PostgreSQL
   - Connect to `olist_sales_data_set` schema
   - Tables needed:
     - `olist_orders_dataset`
     - `olist_order_items_dataset`
     - `olist_customers_dataset`

---

## Exercise Tasks

## Task 1: Create Total Revenue Scorecard (10 minutes)

### Business Question
**"What is our total revenue from all completed orders?"**

### Requirements

**Chart Type:** Scorecard

**Data Configuration:**
- **Metric:** Sum of `price` field
- **Filter:** Only orders where `order_status = 'delivered'`
- **Comparison:** Show comparison to previous period (vs Last Month)

**Formatting:**
- **Number Format:** Currency (NGN)
- **Compact Numbers:** Enabled (show 45.3M not 45,250,000)
- **Decimals:** 1 (e.g., 45.3M)
- **Metric Label:** "Total Revenue (Delivered Orders)"

**Styling:**
- **Metric Value Font Size:** 42px
- **Metric Value Color:** #1976D2 (blue)
- **Metric Label Font Size:** 14px
- **Background:** White (#FFFFFF)
- **Border:** 1px solid #E0E0E0
- **Border Radius:** 8px (rounded corners)

**Conditional Formatting:**
- If comparison vs previous period >= 10%: Green (#4CAF50)
- If comparison 0% to 10%: Yellow (#FFC107)
- If comparison < 0%: Red (#F44336)

### Step-by-Step Instructions

1. **Add Scorecard to Canvas**
   - Click **Add a Chart** → **Scorecard**
   - Draw on canvas (approximately 300px × 200px)

2. **Configure Data**
   - **Data** panel → **Data Source:** Your connected source
   - **Metric:** Click dropdown → **Add Field**
   - Create calculated field:
     ```
     Field Name: Total Revenue
     Formula: SUM(price)
     ```
   - Save field

3. **Add Filter for Delivered Orders**
   - **Data** panel → **Add a Filter** → **Create Filter**
   - Filter Name: "Delivered Orders Only"
   - **Include:** `order_status` EQUALS `delivered`
   - Save and apply

4. **Enable Comparison**
   - **Data** panel → **Show Comparison:** ON
   - **Comparison Calculation:** Relative to previous period
   - **Comparison Type:** Percentage
   - **Comparison Label:** "vs Last Month"

5. **Format Number**
   - **Style** panel → **Metric**
   - **Type:** Currency
   - **Currency:** NGN (₦)
   - **Compact Numbers:** ON
   - **Decimals:** 1

6. **Style the Scorecard**
   - **Style** panel → **Metric Value**
     - Font: Roboto
     - Size: 42
     - Weight: Bold
     - Color: #1976D2
   - **Metric Label**
     - Size: 14
     - Color: #616161
   - **Background and Border**
     - Background color: #FFFFFF
     - Border color: #E0E0E0
     - Border weight: 1
     - Border radius: 8

7. **Add Conditional Formatting**
   - **Style** panel → **Metric Value**
   - **Color:** Select **Conditional Formatting**
   - Add rules:
     - Rule 1: >= 10 → #4CAF50 (green)
     - Rule 2: >= 0 AND < 10 → #FFC107 (yellow)
     - Rule 3: < 0 → #F44336 (red)

### Expected Result

```
┌────────────────────────────────┐
│  Total Revenue                 │
│  (Delivered Orders)            │
│                                │
│      NGN 45.3M                 │  ← Large, blue
│                                │
│    ↑ 12.5% vs Last Month       │  ← Green (>10%)
└────────────────────────────────┘
```

### Check Your Work
- [ ] Revenue displays in NGN format with compact numbers (M for millions)
- [ ] Comparison shows percentage and direction (↑ or ↓)
- [ ] Color changes based on performance (green if > 10% growth)
- [ ] Border and rounded corners visible
- [ ] Professional fonts and spacing

---

## Task 2: Create Top 10 States Bar Chart (15 minutes)

### Business Question
**"Which 10 Nigerian states generate the most revenue, and how do they compare?"**

### Requirements

**Chart Type:** Bar Chart (Horizontal)

**Data Configuration:**
- **Dimension:** `customer_state` (from customers table)
- **Metric:** SUM(price)
- **Sort:** Descending by revenue (highest first)
- **Limit:** Top 10 states
- **Filter:** Only delivered orders

**Formatting:**
- **Bar Color:** #008751 (Nigeria green)
- **Number Format:** NGN, Compact, 1 decimal
- **Show Data Labels:** On bars (show NGN amount)

**Styling:**
- **Chart Title:** "Top 10 States by Revenue"
- **X-Axis Label:** "Revenue (NGN Millions)"
- **Y-Axis Label:** "State"
- **Grid Lines:** Show for X-axis (values)

### Step-by-Step Instructions

1. **Add Bar Chart**
   - **Add a Chart** → **Bar Chart**
   - Draw on canvas (approximately 600px × 400px)

2. **Configure Dimension**
   - **Data** panel → **Dimension:** Select `customer_state`
   - If joining tables needed:
     - Join `olist_orders_dataset` with `olist_customers_dataset` ON `customer_id`
     - Join `olist_order_items_dataset` with `olist_orders_dataset` ON `order_id`

3. **Configure Metric**
   - **Metric:** SUM(price)
   - **Metric Label:** "Revenue"

4. **Apply Filter**
   - Use same "Delivered Orders Only" filter from Task 1

5. **Sort and Limit**
   - **Data** panel → **Sort:** Metric (Revenue), Descending
   - **Rows to Display:** 10

6. **Format Bars**
   - **Style** panel → **Series**
   - **Color:** #008751
   - **Bar Labels:** Show
   - **Number Format:** Currency (NGN), Compact, 1 decimal

7. **Configure Axes**
   - **Style** panel → **Chart Header**
     - **Title:** "Top 10 States by Revenue"
     - Font size: 18
   - **X-Axis (Values)**
     - **Label:** "Revenue (NGN Millions)"
     - Show grid lines
   - **Y-Axis (States)**
     - **Label:** "State"

8. **Add Grid Lines and Styling**
   - **Style** → **Grid**
   - Color: #E0E0E0
   - Grid line weight: 1

### Expected Result

```
┌──────────────────────────────────────────┐
│  Top 10 States by Revenue                │
├──────────────────────────────────────────┤
│ SP  ████████████████████ NGN 18.2M      │
│ RJ  ████████████████ NGN 12.5M          │
│ MG  ██████████████ NGN 10.8M            │
│ RS  ████████ NGN 6.2M                   │
│ PR  ██████ NGN 4.5M                     │
│ SC  █████ NGN 3.8M                      │
│ BA  ████ NGN 3.2M                       │
│ DF  ███ NGN 2.1M                        │
│ GO  ██ NGN 1.5M                         │
│ CE  █ NGN 0.9M                          │
└──────────────────────────────────────────┘
```

**Note:** Dataset uses Brazilian state codes (SP, RJ, MG). In a real Nigerian dashboard, you'd see:
- LA (Lagos)
- FC (Abuja/FCT)
- KN (Kano)
- etc.

### Check Your Work
- [ ] Exactly 10 states shown
- [ ] Sorted from highest to lowest revenue
- [ ] Bars are Nigeria green (#008751)
- [ ] Revenue amounts shown on bars in NGN format
- [ ] Clear chart title and axis labels
- [ ] Horizontal bars (not vertical) for state name readability

---

## Task 3: Create Payment Type Pie Chart (10 minutes)

### Business Question
**"What proportion of our revenue comes from each payment method?"**

### Requirements

**Chart Type:** Pie Chart

**Data Configuration:**
- **Dimension:** `payment_type` (from payments table)
- **Metric:** SUM(payment_value)
- **Filter:** Only successful payments
- **Slice Limit:** Show all payment types

**Formatting:**
- **Show Percentages:** On slices
- **Show Values:** In legend
- **Color Palette:** Distinct colors for each payment type

**Styling:**
- **Chart Title:** "Revenue by Payment Method"
- **Legend Position:** Right side
- **Donut Hole:** 40% (convert to donut chart)

### Step-by-Step Instructions

1. **Add Pie Chart**
   - **Add a Chart** → **Pie Chart**
   - Draw on canvas (approximately 400px × 300px)

2. **Configure Data**
   - **Dimension:** `payment_type`
   - **Metric:** SUM(payment_value)
   - You may need to join tables:
     - `olist_order_payments_dataset` with `olist_orders_dataset`

3. **Configure Slices**
   - **Data** panel → **Slice Count:** All
   - **Sort:** By metric, descending

4. **Style as Donut Chart**
   - **Style** panel → **Donut Chart:** ON
   - **Donut Hole:** 40%

5. **Configure Labels**
   - **Style** → **Pie Slice**
   - **Show Slice Label:** Percentage
   - **Position:** On slice

6. **Configure Legend**
   - **Style** → **Legend**
   - **Position:** Right
   - **Show Legend:** ON
   - **Show Values:** ON (shows NGN amounts)

7. **Add Title and Colors**
   - **Style** → **Chart Header**
   - **Title:** "Revenue by Payment Method"
   - **Color Scheme:** Let Looker auto-assign distinct colors
   - OR manually assign:
     - Credit Card: #2196F3 (blue)
     - Boleto: #4CAF50 (green)
     - Debit Card: #FF9800 (orange)
     - Voucher: #9C27B0 (purple)

### Expected Result

```
┌───────────────────────────────────────┐
│  Revenue by Payment Method            │
│                                       │
│         ╱────────╲                    │
│       ╱   48%     ╲    Credit Card   │
│      │             │   NGN 22.1M     │
│      │    O        │                 │
│      │             │   Boleto        │
│       ╲   32%     ╱    NGN 14.7M    │
│         ╲────────╱                   │
│           15%  5%      Debit Card    │
│                        NGN 6.9M      │
│                                      │
│                        Voucher       │
│                        NGN 2.3M      │
└───────────────────────────────────────┘
```

### Check Your Work
- [ ] Percentages shown on pie slices
- [ ] Legend on right shows payment types and NGN amounts
- [ ] Donut hole visible (40%)
- [ ] Slices use distinct, accessible colors
- [ ] All payment types represented
- [ ] Chart title clear and descriptive

---

## Task 4: Create Recent Orders Table (10 minutes)

### Business Question
**"What are the most recent 20 orders with key details?"**

### Requirements

**Chart Type:** Table

**Data Configuration:**
- **Dimensions:**
  1. `order_id`
  2. `order_purchase_timestamp` (formatted as date)
  3. `customer_state`
  4. `order_status`
- **Metrics:**
  1. SUM(price) as Order Value
  2. COUNT(items) as Item Count
- **Sort:** By timestamp, descending (newest first)
- **Limit:** 20 rows

**Formatting:**
- **Date Format:** MMM DD, YYYY (Nov 13, 2025)
- **Currency Format:** NGN with 2 decimals
- **Compact Numbers:** OFF (show full amounts for table)

**Styling:**
- **Table Title:** "Recent Orders (Last 20)"
- **Header Row:** Bold, gray background
- **Alternating Row Colors:** Light gray every other row
- **Conditional Formatting:** Color-code order_status

### Step-by-Step Instructions

1. **Add Table**
   - **Add a Chart** → **Table**
   - Draw on canvas (approximately 800px × 400px)

2. **Add Dimensions**
   - **Data** panel → **Dimension:** Add each:
     1. `order_id`
     2. `order_purchase_timestamp`
     3. `customer_state`
     4. `order_status`

3. **Add Metrics**
   - **Metric 1:** Create calculated field
     ```
     Name: Order Value
     Formula: SUM(price)
     ```
   - **Metric 2:** COUNT(order_item_id) as "Items"
   - (Note: Adjust based on your data source structure)

4. **Sort and Limit**
   - **Sort:** By `order_purchase_timestamp`, Descending
   - **Rows to Display:** 20

5. **Format Date Column**
   - **Style** → **Table Header**
   - Find `order_purchase_timestamp` column
   - **Type:** Date
   - **Format:** Medium (MMM DD, YYYY)

6. **Format Currency Column**
   - Find `Order Value` column
   - **Type:** Currency
   - **Currency:** NGN
   - **Decimals:** 2
   - **Compact:** OFF

7. **Style Table**
   - **Style** → **Table Header**
     - **Title:** "Recent Orders (Last 20)"
     - Font size: 16
   - **Style** → **Table Body**
     - **Alternating Rows:** ON
     - Row color 1: #FFFFFF (white)
     - Row color 2: #F5F5F5 (light gray)
   - **Header Row:**
     - Background: #E0E0E0
     - Font weight: Bold

8. **Add Conditional Formatting for Status**
   - **Style** → Find `order_status` column
   - **Color:** Conditional formatting
   - Rules:
     - "delivered" → #4CAF50 (green)
     - "shipped" → #2196F3 (blue)
     - "processing" → #FFC107 (yellow)
     - "canceled" → #F44336 (red)

### Expected Result

```
┌─────────────────────────────────────────────────────────────────────────┐
│  Recent Orders (Last 20)                                                │
├──────────────────┬─────────────┬───────┬───────────┬────────┬─────────┤
│ Order ID         │ Order Date  │ State │ Status    │ Value  │ Items   │
├──────────────────┼─────────────┼───────┼───────────┼────────┼─────────┤
│ a1b2c3d4e5f6...  │ Nov 13, 2025│  SP   │delivered  │ 245.50 │   3     │
│ b2c3d4e5f6g7...  │ Nov 13, 2025│  RJ   │shipped    │ 189.99 │   1     │
│ c3d4e5f6g7h8...  │ Nov 12, 2025│  MG   │delivered  │ 432.75 │   5     │
│ ...              │ ...         │  ...  │ ...       │ ...    │  ...    │
└──────────────────┴─────────────┴───────┴───────────┴────────┴─────────┘
```

### Check Your Work
- [ ] Exactly 20 rows displayed
- [ ] Sorted newest to oldest
- [ ] Date formatted as "Nov 13, 2025" (readable format)
- [ ] Order Value shows NGN with 2 decimals
- [ ] Order status color-coded (green = delivered, etc.)
- [ ] Alternating row colors for readability
- [ ] Header row bold with gray background

---

## Bonus Challenge (Optional, +10 minutes)

### Task 5: Add Interactive Date Filter

**Goal:** Add a date range control that filters all 4 charts

**Instructions:**
1. Click **Add a Control** → **Date Range Control**
2. Place at top of page
3. **Data** panel → **Date Range Dimension:** `order_purchase_timestamp`
4. **Default Date Range:** Last 30 Days
5. **Style:** Make it prominent (medium size, clear label)

**Expected Behavior:**
- When user changes date range, all 4 charts update
- Example: Select "Last 7 Days" → see only past week's data

---

## Submission Checklist

Before submitting, verify:

**Task 1: Scorecard**
- [ ] Shows total revenue in NGN millions
- [ ] Comparison to previous period enabled
- [ ] Conditional formatting works (color changes based on growth)
- [ ] Professional styling (proper fonts, border, spacing)

**Task 2: Bar Chart**
- [ ] Exactly 10 states shown
- [ ] Horizontal bars (not vertical)
- [ ] Nigeria green color (#008751)
- [ ] Revenue labeled on bars
- [ ] Clear title and axis labels

**Task 3: Pie Chart**
- [ ] All payment types represented
- [ ] Percentages on slices
- [ ] Donut chart style (40% hole)
- [ ] Legend shows NGN amounts
- [ ] Distinct colors for each type

**Task 4: Table**
- [ ] 20 most recent orders
- [ ] Date formatted as MMM DD, YYYY
- [ ] Order status color-coded
- [ ] Alternating row colors
- [ ] Currency shows NGN with 2 decimals

**Bonus:**
- [ ] Date filter control added
- [ ] All charts respond to filter changes

---

## Common Issues and Troubleshooting

### Issue 1: "No data available"
**Cause:** Data source not connected properly or filter too restrictive
**Solution:**
- Check data source connection (click data source, verify credentials)
- Remove filters temporarily to see if data appears
- Verify table joins are correct

---

### Issue 2: Currency shows as $ instead of NGN
**Cause:** Currency format not set correctly
**Solution:**
- **Style** → **Number Format** → **Currency**
- **Currency Code:** Type "NGN" manually
- If NGN not available, use custom format: **₦#,##0.00**

---

### Issue 3: Dates show as timestamps (2025-11-13 10:30:45)
**Cause:** Date formatting not applied
**Solution:**
- **Style** → Column settings → **Type:** Date
- **Format:** Select "Medium" or "MMM DD, YYYY"

---

### Issue 4: Pie chart too crowded (too many slices)
**Cause:** Too many payment types or categories
**Solution:**
- **Data** → **Slice Limit:** Set to 5-6
- Enable "Other" category for remaining slices

---

### Issue 5: Bar chart bars are vertical instead of horizontal
**Cause:** Wrong chart type selected
**Solution:**
- Delete chart
- Add new chart: Select **Bar Chart** (not Column Chart)
- Bar Chart = Horizontal | Column Chart = Vertical

---

## Evaluation Rubric

Your exercise will be assessed on:

| Criterion | Points | Description |
|-----------|--------|-------------|
| **Correctness** | 40 | Charts show accurate data, proper calculations |
| **Formatting** | 25 | NGN currency, proper dates, compact numbers |
| **Styling** | 20 | Professional appearance, color choices, fonts |
| **Functionality** | 10 | Charts interactive, filters work, responsive |
| **Nigerian Context** | 5 | NGN currency, appropriate formatting, context-aware |
| **Total** | 100 | |

**Grading Scale:**
- 90-100: Excellent - Ready for stakeholders
- 80-89: Good - Minor improvements needed
- 70-79: Satisfactory - Needs refinement
- Below 70: Needs significant revision

---

## Next Steps

After completing this exercise:
1. **Save your report:** Click **File** → **Save**
2. **Share link:** Click **Share** → Get shareable link
3. **Submit:** Provide link to instructor
4. **Move to Exercise 2:** Build complete sales dashboard

**Exercise 2 Preview:**
You'll combine all 4 chart types (and more) into a comprehensive, professional dashboard with:
- Multiple sections (KPIs, Trends, Breakdowns)
- F-pattern layout
- Mobile-responsive design
- Interactive filters
- Complete Nigerian business context

---

## Additional Resources

- **Looker Studio Help:** support.google.com/datastudio
- **Chart Type Guide:** Reference Lecture Material 01
- **Scorecard Tutorial:** Reference Lecture Material 02
- **Nigerian Business Context:** Instructor-provided examples

---

**Estimated Completion Time:** 45 minutes
**Difficulty:** Beginner
**Status:** Required Exercise

Good luck! Remember: Professional dashboards take practice. Don't be discouraged if your first attempt isn't perfect - iteration is part of the process.
