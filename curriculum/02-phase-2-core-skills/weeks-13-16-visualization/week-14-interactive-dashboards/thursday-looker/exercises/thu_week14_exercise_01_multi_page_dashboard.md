# Week 14 Thursday - Exercise 1: Multi-Page Customer Analytics Dashboard

**Estimated Time:** 45 minutes
**Difficulty:** Intermediate
**Prerequisites:** Week 13 chart creation skills, Week 14 Wednesday interactive components

---

## Exercise Overview

Build a professional 3-page Customer Analytics dashboard using RFM (Recency, Frequency, Monetary) concepts from Week 9. You'll practice page layout, navigation, and creating a cohesive dashboard experience.

**Business Scenario:**
You're the lead analyst at **NaijaRetail**, a Lagos-based e-commerce platform. The Head of Customer Success needs a comprehensive Customer Analytics dashboard to:
- Understand overall customer behavior (Overview Page)
- Segment customers by value (Segmentation Page)
- Analyze geographic distribution (Geographic Page)

This dashboard will be used in monthly business reviews with C-level executives.

---

## Learning Objectives

By completing this exercise, you will:
- Design and implement multi-page dashboard navigation
- Apply F-pattern layout principles for visual hierarchy
- Create cohesive page themes with consistent styling
- Build RFM analysis visualizations
- Implement cross-page filtering
- Optimize dashboard for performance and UX

---

## Prerequisites Check

Before starting, ensure you have:
- [ ] Looker Studio account
- [ ] Access to Supabase Olist database
- [ ] Completed Week 13 basic chart exercises
- [ ] Completed Week 14 Wednesday interactive components
- [ ] Understanding of RFM concepts (Week 9 SQL/Python)

---

## Setup Instructions

### Step 1: Create New Multi-Page Report

1. Go to Looker Studio (datastudio.google.com)
2. Click **Create** → **Report**
3. Title: **"NaijaRetail Customer Analytics Dashboard"**
4. Canvas size: **Fixed size - 1600px wide × 900px high**
   - This ensures consistent viewing across devices

### Step 2: Connect Data Source

1. Add PostgreSQL connector
2. Connect to Supabase `olist_sales_data_set` schema
3. Required tables:
   - `olist_customers_dataset`
   - `olist_orders_dataset`
   - `olist_order_items_dataset`
   - `olist_order_payments_dataset`

### Step 3: Create Calculated Fields for RFM

You'll need these calculated fields for RFM analysis:

**1. Recency (Days Since Last Order)**
```
Field Name: Days Since Last Order
Formula: DATE_DIFF(CURRENT_DATE(), MAX(order_purchase_timestamp))
Description: Number of days since customer's most recent order
```

**2. Frequency (Total Orders)**
```
Field Name: Total Orders
Formula: COUNT_DISTINCT(order_id)
Description: Total number of orders per customer
```

**3. Monetary (Total Spend)**
```
Field Name: Total Spend
Formula: SUM(payment_value)
Description: Lifetime customer spend
```

**4. RFM Score (Simplified)**
```
Field Name: Customer Segment
Formula:
CASE
  WHEN Days Since Last Order <= 90 AND Total Orders >= 3 AND Total Spend >= 500 THEN "Champions"
  WHEN Days Since Last Order <= 90 AND Total Orders >= 2 THEN "Loyal"
  WHEN Days Since Last Order <= 180 AND Total Orders >= 1 THEN "Active"
  WHEN Days Since Last Order > 180 AND Total Orders >= 3 THEN "At Risk"
  WHEN Days Since Last Order > 365 THEN "Dormant"
  ELSE "New"
END
Description: Customer segmentation based on RFM
```

---

## Exercise Tasks

## Task 1: Create Page 1 - Customer Overview (15 minutes)

### Page Setup

1. **Rename Page:**
   - Click page tab → Rename to "Customer Overview"

2. **Add Navigation Header (Top Section - 1600px × 100px)**
   - Position: Top of page (0, 0)
   - Background: #008751 (Nigeria green)

   **Components:**
   - **Dashboard Title:** "NaijaRetail Customer Analytics" (left side)
     - Font: Roboto Bold, 28px, White (#FFFFFF)
   - **Navigation Tabs:** (right side)
     - Text: "Overview | Segmentation | Geographic"
     - Make clickable using page navigation (link "Overview" to Page 1, etc.)
     - Current page: Bold & Underlined
   - **Date Range Filter:** Top right corner
     - Control: Date Range Selector
     - Dimension: order_purchase_timestamp
     - Default: Last 12 Months
     - Style: Compact, white background

### F-Pattern Layout Design

Following the F-pattern eye-tracking principle:

**Row 1: Key Metrics (KPI Bar - Below Header)**
- Position: Y=120px, spans full width
- Height: 200px

Create 4 Scorecards in a row (400px × 200px each):

1. **Total Customers**
   - Metric: COUNT_DISTINCT(customer_id)
   - Filter: Only delivered orders
   - Format: Compact number (45.3K)
   - Comparison: vs Previous Period
   - Icon: 👥 (optional)

2. **Active Customers (Last 90 Days)**
   - Metric: COUNT_DISTINCT(customer_id) WHERE Days Since Last Order <= 90
   - Format: Compact number
   - Comparison: vs Previous 90 Days
   - Color: Green if increasing

3. **Average Order Value**
   - Metric: AVG(payment_value)
   - Format: NGN with 2 decimals
   - Comparison: vs Previous Period
   - Color: Conditional (>10% = green)

4. **Customer Lifetime Value**
   - Metric: AVG(Total Spend) per customer
   - Format: NGN, compact
   - Comparison: vs Previous Period

**Row 2: Primary Insight (Main Visual)**
- Position: Y=340px
- Left section: 1000px × 400px

5. **Customer Acquisition Trend (Time Series)**
   - Chart: Line Chart
   - Dimension: Month of first order (create calculated field)
   - Metric: COUNT_DISTINCT(customer_id)
   - Date Range: Last 12 months
   - Style:
     - Line color: #008751
     - Fill: Light green gradient
     - Grid lines: Horizontal only
     - Data labels: On points
   - Title: "New Customers per Month"

**Row 2: Supporting Metric**
- Position: Right of time series (X=1020px, Y=340px)
- Size: 560px × 400px

6. **Customer Status Breakdown (Donut Chart)**
   - Dimension: Customer Segment (from RFM calculated field)
   - Metric: COUNT_DISTINCT(customer_id)
   - Style:
     - Donut hole: 50%
     - Show percentages on slices
     - Legend: Bottom
     - Colors:
       - Champions: #4CAF50 (green)
       - Loyal: #2196F3 (blue)
       - Active: #FFC107 (yellow)
       - At Risk: #FF9800 (orange)
       - Dormant: #F44336 (red)
       - New: #9E9E9E (gray)
   - Title: "Customer Segmentation (RFM)"
   - Center text: Total customer count

**Row 3: Detailed Data**
- Position: Y=760px
- Size: Full width (1600px × 120px)

7. **Top 10 Customers by Spend (Table)**
   - Columns:
     1. Customer ID (first 8 characters)
     2. Customer State
     3. Total Orders
     4. Total Spend (NGN)
     5. Days Since Last Order
     6. Customer Segment
   - Sort: By Total Spend, descending
   - Limit: 10 rows
   - Style:
     - Alternating rows: ON
     - Header: Bold, gray background
     - Conditional formatting on Customer Segment (color-coded)
   - Title: "Top 10 Customers by Lifetime Value"

### Acceptance Criteria for Page 1
- [ ] Navigation header with working links
- [ ] 4 KPI scorecards with comparisons
- [ ] Time series showing new customers trend
- [ ] Donut chart with RFM segmentation
- [ ] Top customers table with 10 rows
- [ ] All charts use consistent Nigeria green theme
- [ ] Date filter affects all charts on page

---

## Task 2: Create Page 2 - Customer Segmentation (15 minutes)

### Page Setup

1. **Add New Page:**
   - Click **Add Page** at bottom
   - Rename to "Customer Segmentation"

2. **Copy Navigation Header from Page 1:**
   - Select header section on Page 1 → Copy → Paste on Page 2
   - Update navigation highlighting: Bold & underline "Segmentation"

### Page Layout

**Focus: Deep Dive into RFM Segments**

**Section 1: Segment Overview (Top)**
- Position: Y=120px

1. **Segment Distribution (Treemap)**
   - Size: 1000px × 350px
   - Dimension: Customer Segment
   - Metric: COUNT(customer_id)
   - Sub-metric: SUM(Total Spend) - shows size by revenue
   - Style:
     - Same colors as Page 1 donut chart
     - Show labels: Segment name + customer count
   - Title: "Customer Segments by Size & Revenue"

2. **Segment Performance Scorecard**
   - Position: Right of treemap (X=1020px)
   - Size: 560px × 350px
   - Create 3 mini scorecards stacked vertically:
     - **Champions Revenue:** SUM(Total Spend) WHERE Segment = "Champions"
     - **At Risk Count:** COUNT(customer_id) WHERE Segment = "At Risk"
     - **Dormant Count:** COUNT(customer_id) WHERE Segment = "Dormant"
   - Format: NGN for revenue, compact numbers for counts

**Section 2: RFM Matrix Analysis**
- Position: Y=490px

3. **Recency vs Frequency Scatter Plot**
   - Size: 780px × 380px
   - X-Axis: Days Since Last Order (Recency)
   - Y-Axis: Total Orders (Frequency)
   - Bubble Size: Total Spend (Monetary)
   - Bubble Color: Customer Segment (same color scheme)
   - Style:
     - Grid: Both axes
     - Show trend line: OFF
     - Labels: Show segment on hover
   - Title: "RFM Analysis: Recency vs Frequency"
   - Insight box below: "Ideal customers: Bottom-left (recent + frequent)"

4. **Segment Value Comparison (Bar Chart)**
   - Position: Right of scatter (X=800px)
   - Size: 780px × 380px
   - Dimension: Customer Segment
   - Metrics (Grouped):
     - AVG(Total Spend) per customer
     - AVG(Total Orders) per customer
   - Orientation: Horizontal bars
   - Sort: By AVG spend, descending
   - Style:
     - Bars grouped (not stacked)
     - Color 1: #008751 (spend)
     - Color 2: #FFC107 (orders)
     - Data labels: ON
   - Title: "Average Spend & Orders by Segment"

### Acceptance Criteria for Page 2
- [ ] Navigation header matches Page 1 (with "Segmentation" highlighted)
- [ ] Treemap showing segment distribution
- [ ] 3 segment performance scorecards
- [ ] Scatter plot analyzing RFM dimensions
- [ ] Bar chart comparing segment metrics
- [ ] All segment colors consistent with Page 1
- [ ] Date filter from Page 1 carries over (cross-page filtering)

---

## Task 3: Create Page 3 - Geographic Analysis (15 minutes)

### Page Setup

1. **Add New Page:**
   - Click **Add Page**
   - Rename to "Geographic Analysis"

2. **Copy Navigation Header:**
   - Copy from Page 1 → Paste on Page 3
   - Update highlighting: Bold "Geographic"

### Page Layout

**Focus: Location-Based Customer Insights**

**Section 1: Geographic Overview**
- Position: Y=120px

1. **Customers by State (Geo Map - Filled)**
   - Size: 1000px × 500px
   - Map Type: Filled (Choropleth)
   - Dimension: customer_state
   - Metric: COUNT_DISTINCT(customer_id)
   - Style:
     - Color scale: White → Nigeria Green (#008751)
     - Show labels: State abbreviation
     - Tooltip: State name + customer count + total spend
   - Title: "Customer Distribution by State"
   - Note: Brazilian data shows SP, RJ, MG; Nigerian would show LA, KN, etc.

2. **Top States Metrics (Scorecards)**
   - Position: Right of map (X=1020px)
   - Size: 560px × 500px
   - Create 5 mini scorecards (stacked):
     - **Top State by Customers:** MAX(customer_state) ranked by COUNT
     - **Top State by Revenue:** MAX(customer_state) ranked by SUM(Total Spend)
     - **Total States Served:** COUNT_DISTINCT(customer_state)
     - **Avg Customers per State:** AVG(COUNT customer_id per state)
     - **Geographic Concentration:** % of customers in top 3 states
   - Each scorecard: 560px × 90px
   - Style: Compact, green accent color

**Section 2: State-Level Analysis**
- Position: Y=640px

3. **State Performance Ranking (Bar Chart)**
   - Size: 780px × 240px
   - Dimension: customer_state
   - Metrics:
     - COUNT_DISTINCT(customer_id) as Customers
     - SUM(Total Spend) as Revenue
   - Orientation: Horizontal
   - Sort: By Revenue, descending
   - Limit: Top 15 states
   - Style:
     - Color: Nigeria green
     - Data labels: ON (show both metrics)
     - Grid: Vertical
   - Title: "Top 15 States by Customer Count & Revenue"

4. **State-Level Detail Table**
   - Position: Right of bar chart (X=800px)
   - Size: 780px × 240px
   - Columns:
     1. State
     2. Total Customers
     3. Champions (count in Champions segment)
     4. Active (count in Active segment)
     5. Dormant (count in Dormant segment)
     6. Total Revenue (NGN)
   - Sort: By Total Revenue, descending
   - Limit: 15 rows
   - Style:
     - Alternating rows
     - Conditional formatting: Highlight top 3 states (light green background)
   - Title: "State Performance Details"

### Final Navigation Setup

On **all 3 pages**, ensure navigation works:
1. Click "Overview" → Goes to Page 1
2. Click "Segmentation" → Goes to Page 2
3. Click "Geographic" → Goes to Page 3

**Implementation:**
- Select navigation text on each page
- Right-click → Add link → Select page from dropdown
- Style: Current page = Bold + Underlined, other pages = Regular

### Acceptance Criteria for Page 3
- [ ] Navigation header with working links
- [ ] Geo map showing customer distribution
- [ ] 5 geographic metric scorecards
- [ ] Top 15 states bar chart
- [ ] State detail table with segment breakdown
- [ ] Consistent green theme
- [ ] All page navigation functional (can click between all 3 pages)

---

## Bonus Challenges (Optional, +15 minutes)

### Challenge 1: Add Logo and Branding
- Add "NaijaRetail" logo image to header (use text or image placeholder)
- Add tagline: "Customer Intelligence Dashboard"
- Footer with update timestamp and data source info

### Challenge 2: Mobile-Responsive Version
- View → Mobile Layout
- Adjust page layout for mobile:
  - Stack scorecards vertically
  - Reduce chart heights
  - Simplify table columns
- Test on mobile simulator

### Challenge 3: Advanced Cross-Page Filtering
- Add "Customer Segment" filter control on Page 1
- Configure to affect all 3 pages:
  - When "Champions" selected → all pages show only Champions data
- Place filter in header (right of date range)

---

## Submission Checklist

Before submitting, verify:

**Page 1: Customer Overview**
- [ ] 4 KPI scorecards with comparisons
- [ ] New customers trend line chart
- [ ] RFM segmentation donut chart
- [ ] Top 10 customers table
- [ ] Navigation header functional

**Page 2: Customer Segmentation**
- [ ] Segment distribution treemap
- [ ] 3 segment performance scorecards
- [ ] RFM scatter plot (Recency vs Frequency)
- [ ] Segment comparison bar chart
- [ ] Navigation works

**Page 3: Geographic Analysis**
- [ ] Customer distribution geo map
- [ ] 5 geographic scorecards
- [ ] Top 15 states bar chart
- [ ] State detail table
- [ ] Navigation works

**Overall Dashboard**
- [ ] Consistent Nigeria green theme (#008751)
- [ ] All pages use same header design
- [ ] Date range filter affects all pages
- [ ] Can navigate between all 3 pages
- [ ] All charts show NGN currency format
- [ ] All numbers use compact format where appropriate
- [ ] RFM segmentation colors consistent across pages
- [ ] Professional, clean layout (proper spacing)

**User Experience**
- [ ] Dashboard loads in under 5 seconds
- [ ] Charts don't overlap
- [ ] Text is readable (minimum 12px font)
- [ ] Color contrast accessible (WCAG AA standard)
- [ ] Mobile layout configured (bonus)

---

## Common Issues and Troubleshooting

### Issue 1: Navigation links don't work
**Cause:** Links not configured properly
**Solution:**
- Select navigation text
- Right-click → Link → Select target page from "Pages in this report"
- Ensure "Open in same tab" is selected

---

### Issue 2: Date filter only affects one page
**Cause:** Filter not set to cross-page filtering
**Solution:**
- Click date filter control → Setup → Advanced
- Enable "Apply to all pages"
- Verify dimension is same across all data sources

---

### Issue 3: RFM calculated field returns errors
**Cause:** Nested aggregations or incorrect CASE syntax
**Solution:**
- Break down into 3 separate fields first (Recency, Frequency, Monetary)
- Then create Customer Segment field referencing those fields
- Use IF statements instead of CASE if CASE not supported

---

### Issue 4: Geo map shows wrong location
**Cause:** State codes don't match Looker's geo database
**Solution:**
- Brazilian dataset uses BR state codes (SP, RJ, MG)
- For Nigerian data, ensure state names are full ("Lagos" not "LA")
- Or use lat/long coordinates for precise mapping

---

### Issue 5: Pages look inconsistent
**Cause:** Copy-paste didn't preserve exact styling
**Solution:**
- Create header on Page 1 first
- Group all header elements (Ctrl+Click → Right-click → Group)
- Copy grouped header → Paste on other pages
- This ensures pixel-perfect consistency

---

### Issue 6: Dashboard loads slowly (>10 seconds)
**Cause:** Too many charts, live connections, or unoptimized queries
**Solution:**
- Limit charts to 6-8 per page
- Use data extracts instead of live connection (Data → Extract Data)
- Apply filters at data source level, not chart level
- See Performance Optimization Checklist resource

---

## Evaluation Rubric

Your exercise will be assessed on:

| Criterion | Points | Description |
|-----------|--------|-------------|
| **Layout & Navigation** | 25 | Clean F-pattern layout, functional page navigation, consistent headers |
| **RFM Implementation** | 25 | Correct calculated fields, accurate segmentation, insightful analysis |
| **Visual Design** | 20 | Consistent color scheme, proper spacing, professional appearance |
| **Functionality** | 15 | All charts work, filters apply correctly, cross-page filtering |
| **Nigerian Context** | 10 | NGN currency, compact numbers, appropriate formatting |
| **User Experience** | 5 | Fast loading, readable, accessible, mobile-friendly (bonus) |
| **Total** | 100 | |

**Grading Scale:**
- 90-100: Excellent - Production-ready dashboard
- 80-89: Good - Minor refinements needed
- 70-79: Satisfactory - Functional but needs polish
- Below 70: Needs significant revision

---

## Next Steps

After completing this exercise:

1. **Save your dashboard:**
   - File → Save → Name: "Week14_Ex1_YourName"

2. **Share for review:**
   - Share → Get shareable link
   - Permission: "Can view" for classmates, "Can edit" for instructor

3. **Self-review:**
   - Use Dashboard Design Checklist (resource file)
   - Test all navigation links
   - Verify mobile view

4. **Move to Exercise 2:**
   - Performance optimization
   - Collaboration features
   - Version control best practices

---

## Additional Resources

- **Dashboard Layout Patterns:** See resource file for templates
- **F-Pattern Design:** Reference Week 14 Wednesday lecture notes
- **RFM Analysis:** Review Week 9 SQL/Python materials
- **Looker Navigation:** support.google.com/datastudio → "Page navigation"
- **Color Accessibility:** Use WebAIM Contrast Checker

---

**Estimated Completion Time:** 45 minutes (15 min per page)
**Difficulty:** Intermediate
**Status:** Required Exercise

Good luck! Remember: Great dashboards tell a story. Your 3 pages should flow logically from overview → detailed segmentation → geographic insights. Think like a business user navigating through the data.
