# Week 13 Thursday - Exercise 2: Complete Sales Overview Dashboard

**Estimated Time:** 60 minutes
**Difficulty:** Intermediate
**Prerequisites:** Completed Exercise 1 (Basic Charts)

---

## Exercise Overview

Build a comprehensive sales overview dashboard for **NaijaCommerce** that the COO will use for daily performance monitoring. This dashboard combines multiple chart types, applies professional design principles, and creates an interactive, mobile-responsive analytics tool.

**Business Scenario:**
The COO needs a single dashboard to answer these questions every morning:
1. What's our current performance? (Revenue, Orders, AOV, Customers)
2. How are we trending? (Monthly revenue over time)
3. Where are sales coming from? (Geographic breakdown)
4. What's selling? (Top product categories)
5. How's delivery performance? (On-time percentage)

---

## Learning Objectives

- Apply F-pattern layout for optimal information flow
- Create cohesive multi-chart dashboards
- Implement mobile-responsive design
- Use consistent styling and color schemes
- Add interactive date filters
- Apply Nigerian business context throughout

---

## Dashboard Requirements

### Section 1: Executive KPIs (Top Row)

**4 Scorecards showing:**
1. **Total Revenue** - SUM(price), NGN format, vs Last Month
2. **Total Orders** - COUNT(order_id), compact format, vs Last Month
3. **Average Order Value** - Revenue / Orders, NGN format, vs Last Month
4. **Active Customers** - COUNT(DISTINCT customer_id), compact, vs Last Month

**Layout:** Horizontal row, equal widths, above the fold

---

### Section 2: Trend Analysis (Main Chart)

**Time Series Chart:**
- **Metric:** Monthly Revenue
- **Time Period:** Last 12 months
- **Include:** Order count as secondary metric (dual axis)
- **Features:** Grid lines, data point markers, reference line for target

---

### Section 3: Geographic Performance (Left)

**Filled Geo Map OR Bar Chart:**
- **Dimension:** customer_state
- **Metric:** SUM(price)
- **Top 10 states**
- **Color:** Nigeria green gradient

---

### Section 4: Category Performance (Right)

**Stacked Bar Chart:**
- **Dimension:** product_category (top 5)
- **Metric:** SUM(price)
- **Breakdown:** By order_status
- **Colors:** Distinct palette

---

### Section 5: Delivery Performance (Bottom Left)

**Gauge Chart:**
- **Metric:** On-time delivery percentage
- **Target:** 95%
- **Color Zones:**
  - 0-85%: Red (critical)
  - 85-95%: Yellow (warning)
  - 95-100%: Green (excellent)

---

### Section 6: Recent Activity (Bottom Right)

**Table:**
- Last 10 orders
- Columns: Order ID, Date, State, Status, Value
- Conditional formatting on status

---

## Step-by-Step Instructions

### Phase 1: Dashboard Setup (10 minutes)

1. **Create New Report**
   - Looker Studio → Create → Report
   - Title: "NaijaCommerce Sales Dashboard - Week 13"
   - Canvas: Standard (960px)

2. **Add Data Source**
   - Use existing connection from Wednesday/Exercise 1
   - Tables: orders, order_items, customers, products

3. **Set Up Color Scheme**
   - Primary: #008751 (Nigeria green)
   - Secondary: #FFD700 (Gold)
   - Accent: #1976D2 (Blue)
   - Text: #212121 (Dark gray)
   - Background: #FFFFFF (White)

---

### Phase 2: Build Executive KPIs (15 minutes)

**Create 4 Scorecards (Top Row)**

**Scorecard 1: Total Revenue**
```
Metric: SUM(price)
Filter: order_status = 'delivered'
Format: Currency NGN, Compact, 1 decimal
Comparison: Previous period (Last Month)
Conditional Color:
  >= 10%: Green
  0-10%: Yellow
  < 0%: Red
Size: 220px × 150px
Position: (20, 20)
```

**Scorecard 2: Total Orders**
```
Metric: COUNT(order_id)
Filter: order_status = 'delivered'
Format: Number, Compact
Comparison: Previous period
Size: 220px × 150px
Position: (260, 20)
```

**Scorecard 3: Average Order Value**
```
Metric: SUM(price) / COUNT(order_id)
Filter: order_status = 'delivered'
Format: Currency NGN, 2 decimals
Comparison: Previous period
Size: 220px × 150px
Position: (500, 20)
```

**Scorecard 4: Active Customers**
```
Metric: COUNT(DISTINCT customer_id)
Format: Number, Compact
Comparison: Previous period
Size: 220px × 150px
Position: (740, 20)
```

**Styling for All Scorecards:**
- Metric Value: 36px, Bold, #1976D2
- Label: 14px, #616161
- Background: White, 1px #E0E0E0 border, 8px radius
- Comparison: 14px, color-coded

---

### Phase 3: Monthly Revenue Trend (10 minutes)

**Time Series Chart (Full Width)**

```
Chart Type: Time Series (Line + Area)
Position: (20, 190)
Size: 920px × 300px

Data Configuration:
  Date Dimension: order_purchase_timestamp (Month)
  Metric 1 (Primary): SUM(price) as "Revenue"
  Metric 2 (Secondary): COUNT(order_id) as "Orders"
  Date Range: Last 12 months

Styling:
  Title: "Monthly Revenue & Order Trend - Last 12 Months"
  Line 1 (Revenue): Area chart, #008751, Left Y-axis
  Line 2 (Orders): Line chart, #1976D2, Right Y-axis
  Grid lines: Show, #E0E0E0
  Data markers: Show
  Reference line: NGN 5M (monthly target), dashed gray
```

**Axes:**
- Left: "Revenue (NGN Millions)"
- Right: "Order Count"
- Bottom: "Month"

---

### Phase 4: Geographic & Category Analysis (15 minutes)

**Left: Top States Bar Chart**

```
Chart Type: Bar Chart (Horizontal)
Position: (20, 510)
Size: 450px × 350px

Data:
  Dimension: customer_state
  Metric: SUM(price)
  Sort: Descending
  Limit: 10

Styling:
  Title: "Top 10 States by Revenue"
  Bar Color: #008751
  Show Labels: On bars
  Format: NGN Compact
```

**Right: Category Performance Stacked Bar**

```
Chart Type: Stacked Bar Chart (Horizontal)
Position: (490, 510)
Size: 450px × 350px

Data:
  Dimension: product_category_name (Top 5)
  Breakdown: order_status
  Metric: SUM(price)

Styling:
  Title: "Top 5 Categories by Status"
  Colors:
    delivered: #4CAF50 (green)
    shipped: #2196F3 (blue)
    processing: #FFC107 (yellow)
    canceled: #F44336 (red)
  Legend: Right side
```

---

### Phase 5: Operational Metrics (10 minutes)

**Left: Delivery Performance Gauge**

```
Chart Type: Gauge
Position: (20, 880)
Size: 300px × 200px

Metric Calculation:
  Name: On-Time Delivery Rate
  Formula:
    COUNT(CASE WHEN order_delivered_customer_date <= order_estimated_delivery_date THEN 1 END)
    / COUNT(order_id) * 100

Range: 0 to 100
Target: 95

Color Zones:
  0-85: #F44336 (red)
  85-95: #FFC107 (yellow)
  95-100: #4CAF50 (green)

Title: "On-Time Delivery Performance"
```

**Right: Recent Orders Table**

```
Chart Type: Table
Position: (340, 880)
Size: 600px × 250px

Columns:
  1. order_id (First 8 characters)
  2. order_purchase_timestamp (Date format: MMM DD)
  3. customer_state
  4. order_status (Conditional formatting)
  5. SUM(price) as "Value" (NGN, 2 decimals)

Sort: By date, Descending
Rows: 10

Styling:
  Title: "Recent Orders (Last 10)"
  Header: Bold, #E0E0E0 background
  Alternating rows: White / #F5F5F5
  Status colors:
    delivered: Green text
    shipped: Blue text
    processing: Yellow background
    canceled: Red text
```

---

### Phase 6: Add Interactivity (5 minutes)

**Date Range Filter Control**

```
Control Type: Date Range Slider
Position: (20, 1150)
Size: 920px × 50px

Configuration:
  Date Dimension: order_purchase_timestamp
  Default Range: Last 30 Days

Styling:
  Label: "Date Range:"
  Position: Top-left
  Slider color: #008751
```

**State Filter Control (Optional)**

```
Control Type: Drop-down list
Position: Above charts or sidebar
Dimension: customer_state
Default: All states
```

---

### Phase 7: Final Styling & Polish (5 minutes)

1. **Add Dashboard Title**
   - Text box at top: "NaijaCommerce - Sales Performance Dashboard"
   - Font: Roboto Bold, 28px, #212121
   - Position: Center or left-aligned above KPIs

2. **Add Section Headers**
   - "Key Metrics" above scorecards
   - "Trend Analysis" above time series
   - "Performance Breakdown" above bar charts
   - "Operations" above gauge and table

3. **Add Footer**
   - Text: "Last Updated: [Auto-update timestamp]"
   - Text: "Data Source: Olist E-Commerce Database"
   - Font: 10px, #757575

4. **Verify Mobile Responsiveness**
   - Click **View** → **Mobile Layout**
   - Ensure charts stack properly
   - Adjust if needed (scorecards 2×2 grid on mobile)

5. **Test Interactivity**
   - Change date range → All charts update
   - Verify calculations are correct
   - Check for data errors

---

## Dashboard Layout Diagram

```
┌──────────────────────────────────────────────────────────────┐
│  NAIJA COMMERCE - SALES PERFORMANCE DASHBOARD                │ ← Title
├───────────┬───────────┬───────────┬───────────┐              │
│  Revenue  │  Orders   │    AOV    │ Customers │              │ ← KPIs
│  45.3M    │  15.4K    │  2,932    │   8,765   │              │
│  ↑ 12%    │  ↑ 8%     │  ↑ 3%     │  ↑ 6%     │              │
├───────────┴───────────┴───────────┴───────────┘              │
│                                                               │
│  Monthly Revenue & Order Trend                                │ ← Trend
│  [Time Series Chart with dual axes]                          │
│                                                               │
├──────────────────────────┬────────────────────────────────────┤
│  Top 10 States           │  Top 5 Categories by Status       │ ← Analysis
│  [Horizontal Bar Chart]  │  [Stacked Horizontal Bars]        │
│                          │                                    │
├─────────────┬────────────┴────────────────────────────────────┤
│ Delivery    │  Recent Orders (Last 10)                       │ ← Operations
│ Performance │  [Table with order details]                    │
│ [Gauge]     │                                                │
│             │                                                │
├─────────────┴────────────────────────────────────────────────┤
│ Date Range: [Slider Control - Last 30 Days]                 │ ← Filter
├──────────────────────────────────────────────────────────────┤
│ Last Updated: Nov 13, 2025 10:30 AM WAT                      │ ← Footer
│ Data Source: Olist E-Commerce Database                       │
└──────────────────────────────────────────────────────────────┘
```

---

## Submission Checklist

**Section 1: Executive KPIs**
- [ ] 4 scorecards in horizontal row
- [ ] NGN currency format (compact for revenue)
- [ ] Comparison to previous period enabled
- [ ] Conditional formatting on revenue scorecard
- [ ] Professional styling (fonts, colors, borders)

**Section 2: Trend Chart**
- [ ] Monthly revenue trend (last 12 months)
- [ ] Dual axes (revenue + order count)
- [ ] Grid lines and data markers
- [ ] Reference line for target (optional but recommended)
- [ ] Clear axis labels

**Section 3: Geographic Analysis**
- [ ] Top 10 states by revenue
- [ ] Horizontal bars (not vertical)
- [ ] Nigeria green color
- [ ] Revenue labels on bars

**Section 4: Category Analysis**
- [ ] Top 5 categories
- [ ] Stacked by order status
- [ ] Distinct colors for each status
- [ ] Legend visible

**Section 5: Operational Metrics**
- [ ] Gauge shows on-time delivery %
- [ ] Color zones configured (red/yellow/green)
- [ ] Table shows last 10 orders
- [ ] Status column color-coded

**Section 6: Interactivity**
- [ ] Date range filter control added
- [ ] All charts respond to filter changes

**Design & Polish**
- [ ] F-pattern layout (KPIs → Trend → Breakdowns → Details)
- [ ] Consistent color scheme (Nigeria green, gold, blue)
- [ ] White space between sections
- [ ] Professional fonts (Roboto throughout)
- [ ] Mobile-responsive (test in mobile view)
- [ ] Dashboard title and section headers
- [ ] Footer with timestamp and data source

---

## Bonus Challenges (Optional)

1. **Add Customer Segment Pie Chart**
   - New vs Returning customers
   - Position: Between geo and category charts

2. **Add Average Delivery Time Scorecard**
   - Metric: AVG(delivery_date - purchase_date)
   - Format: Days
   - Position: 5th scorecard in top row

3. **Create Mobile Version**
   - Duplicate dashboard
   - Optimize layout for mobile (2-column max)
   - Reduce to 6 most important charts

4. **Add Email Delivery Schedule**
   - Schedule daily email to COO
   - Time: 6:00 AM WAT
   - Recipients: coo@naija commerce.com.ng

---

## Common Issues & Solutions

**Issue: Charts don't update when filter changes**
- **Solution:** Ensure all charts use same date dimension (`order_purchase_timestamp`)

**Issue: Gauge shows 0% or error**
- **Solution:** Check calculated field formula, ensure both numerator and denominator use same filters

**Issue: Mobile view looks broken**
- **Solution:** Reduce chart widths, allow auto-stacking, test on actual phone

**Issue: Performance is slow**
- **Solution:** Use data extract instead of live connection, reduce date range, limit rows

**Issue: Colors don't match Nigeria green**
- **Solution:** Use hex code #008751 exactly, not similar greens

---

## Evaluation Rubric

| Criterion | Points | Description |
|-----------|--------|-------------|
| **Data Accuracy** | 25 | Correct metrics, calculations, filters |
| **Layout & Design** | 25 | F-pattern, sections, white space, visual hierarchy |
| **Styling** | 20 | Colors, fonts, consistency, professionalism |
| **Interactivity** | 15 | Filters work, charts respond correctly |
| **Mobile Responsiveness** | 10 | Works on mobile devices |
| **Nigerian Context** | 5 | NGN currency, appropriate formatting |
| **Total** | 100 | |

**Grading:**
- 90-100: Production-ready dashboard
- 80-89: Minor refinements needed
- 70-79: Needs significant improvement
- Below 70: Revisit requirements

---

## Time Management Tips

- **Minutes 0-10:** Setup and KPIs (foundation)
- **Minutes 10-25:** Trend chart (main visual)
- **Minutes 25-40:** Geographic and category charts
- **Minutes 40-50:** Gauge and table
- **Minutes 50-55:** Filters and interactivity
- **Minutes 55-60:** Final polish and testing

**Don't:**
- Spend 30 minutes perfecting fonts (5 minutes is enough)
- Try to build everything perfectly first time (iterate!)
- Skip testing mobile view

---

## Next Steps After Completion

1. **Present to Classmates**
   - Practice explaining your dashboard
   - Walk through business insights it reveals
   - Receive peer feedback

2. **Iterate Based on Feedback**
   - Make 2-3 targeted improvements
   - Submit final version

3. **Add to Portfolio**
   - Take high-quality screenshot
   - Write brief description
   - Include in GitHub portfolio

4. **Prepare for Week 14**
   - Next week: Advanced calculated fields and data blending
   - Building on this foundation

---

## Resources

- **Lecture Materials:** Reference all 4 Thursday lecture files
- **Exercise 1:** Build on individual chart skills
- **Looker Studio Help:** support.google.com/datastudio
- **Design Inspiration:** Look at professional BI dashboards online

---

**Deadline:** Submit by end of week (Sunday, November 17, 2025)
**Submission:** Share dashboard link with instructor via email

**Questions?** Post in class Slack channel or ask during office hours.

Good luck building your first professional dashboard!
