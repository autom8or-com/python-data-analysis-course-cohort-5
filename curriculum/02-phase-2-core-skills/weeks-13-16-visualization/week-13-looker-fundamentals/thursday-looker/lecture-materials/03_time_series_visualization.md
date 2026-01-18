# Time Series Visualization in Looker Studio

**Week 13 - Thursday Session | Hour 1 (30-45 minutes)**
**Business Context:** Visualizing sales trends, seasonal patterns, and growth trajectories for Nigerian e-commerce

---

## Learning Objectives

By the end of this section, you will be able to:
- Create time series (line) charts showing trends over time
- Configure date dimensions with proper granularity (daily, weekly, monthly)
- Apply date range filters for flexible time period analysis
- Identify seasonal patterns in Nigerian business cycles
- Combine multiple metrics in time series comparisons
- Use area charts for cumulative and stacked visualizations

---

## What is Time Series Visualization?

A **time series chart** displays how one or more metrics change over sequential time periods. It's the most fundamental tool for understanding business trends.

### Excel to Looker Studio Evolution

**Excel Line Chart:**
- Manually select date range
- Static data that doesn't update
- Limited to single worksheet data
- Manual formatting for each element

**Looker Studio Time Series:**
- Automatically updates with new data
- Interactive date range controls
- Connect to live database
- Professional styling with one click
- Multiple metrics with dual axes
- Drill-down from year → quarter → month → week → day

---

## Why Time Series Matters for Nigerian E-Commerce

### Business Questions Time Series Answers:

1. **Growth Tracking:** Is revenue growing month-over-month?
2. **Seasonal Patterns:** When do we see holiday shopping spikes?
3. **Trend Identification:** Are customers shifting to mobile ordering?
4. **Performance Cycles:** Which days of week have highest sales?
5. **Impact Analysis:** How did our marketing campaign affect orders?

### Nigerian Business Calendar Context

**Key Periods to Track:**
- **January-February:** Post-holiday slowdown, New Year sales
- **March-April:** End of Q1, Easter shopping
- **May-June:** Mid-year promotions, Eid al-Fitr
- **July-August:** Eid al-Adha, back-to-school shopping
- **September:** Independence Day promotions (October 1)
- **October-November:** Ramp-up to holiday season
- **December:** Peak season - Christmas, year-end sales

---

## Step-by-Step: Creating Your First Time Series Chart

### Example: Monthly Revenue Trend (2025)

**Business Question:** How is our monthly revenue trending this year?

**SQL Equivalent (Week 5: Date Functions):**
```sql
SELECT
    DATE_TRUNC('month', order_purchase_timestamp) as order_month,
    SUM(price) as monthly_revenue
FROM olist_sales_data_set.olist_order_items_dataset oi
JOIN olist_sales_data_set.olist_orders_dataset o ON oi.order_id = o.order_id
WHERE EXTRACT(YEAR FROM order_purchase_timestamp) = 2025
GROUP BY DATE_TRUNC('month', order_purchase_timestamp)
ORDER BY order_month;
```

---

### Step 1: Add Time Series Chart

1. Click **Add a Chart** in toolbar
2. Select **Time Series Chart** (line chart icon)
3. Click and drag on canvas to size your chart

**[SCREENSHOT 1: Selecting time series chart from chart picker]**
*Caption: Time series chart is in the "Time-based" category of chart types*

---

### Step 2: Configure Date Dimension

In **Data** panel (right side):

**Data Source:**
- Select: `olist_orders_with_items` (created Wednesday)

**Date Range Dimension:** (Critical for time series)
- Field: `order_purchase_timestamp`
- This tells Looker what field contains your dates

**Dimension:** (X-axis - time periods)
- Field: `order_purchase_timestamp`
- Granularity: **Month** (YYYYMM format)

**Granularity Options:**
- **Year:** Annual comparison (YYYY)
- **Quarter:** Quarterly trends (YYYY-Q1, YYYY-Q2...)
- **Month:** Monthly trends (2025-01, 2025-02...)
- **Week:** Weekly patterns (Week 1, Week 2...)
- **Day:** Daily tracking (2025-01-15, 2025-01-16...)
- **Hour:** Intraday patterns (for large-scale operations)

**Nigerian E-Commerce Recommendation:**
- **Monthly:** For executive reporting and trend analysis
- **Weekly:** For operational monitoring
- **Daily:** For marketing campaign impact tracking

**[SCREENSHOT 2: Configuring date dimension with monthly granularity]**
*Caption: Setting order_purchase_timestamp as dimension with Month granularity*

---

### Step 3: Add Metrics (Y-axis)

**Metric:** The value you're tracking over time

**Add Primary Metric:**
1. Click **Add Metric**
2. Select existing field OR create calculated field
3. Example: `SUM(price)` for total revenue

**Metric Configuration:**
- **Name:** "Monthly Revenue"
- **Field:** `price`
- **Aggregation:** SUM
- **Format:** Currency (NGN), Compact

**SQL Concept Connection:**
- Metric = SELECT clause aggregate function
- SUM(price), COUNT(order_id), AVG(review_score)

---

### Step 4: Set Date Range Filter

**Purpose:** Control which time period is displayed

**Options:**

**A. Fixed Date Range:**
- Start: January 1, 2025
- End: December 31, 2025
- Use: Annual reporting

**B. Relative Date Range (Recommended):**
- **Last 12 months:** Rolling 12-month view (always current)
- **Year to date:** January 1 to today
- **Last 90 days:** Recent trend focus
- **Last week:** Operational monitoring

**Nigerian Business Example:**
```
Date Range: Last 12 months
Result: Always shows trailing 12 months
Benefit: Dashboard stays current without manual updates
```

**How to Set:**
1. **Data** panel → **Default Date Range**
2. Select: **Last 12 months**
3. OR: Add date range control to dashboard (user-adjustable)

**[SCREENSHOT 3: Date range configuration options]**
*Caption: Setting "Last 12 months" as default date range for rolling trends*

---

### Step 5: Style the Time Series Chart

In **Style** panel:

#### Chart Appearance
**Line Style:**
- Line thickness: 3px (visible but not overwhelming)
- Line smoothing: Medium (smooth curves vs sharp angles)
- Show data points: Yes (circles at each month)

**Colors:**
- Primary metric: #1976D2 (professional blue)
- Use brand colors if available

**Grid Lines:**
- Show X-axis labels: Yes (month names)
- Show Y-axis labels: Yes (revenue amounts)
- Gridline color: #E0E0E0 (subtle gray)

#### Axes Configuration
**X-Axis (Time):**
- Label: "Month"
- Slant labels: Auto (prevents overlap)
- Show all months: Yes

**Y-Axis (Metric):**
- Label: "Revenue (NGN)"
- Min value: 0 (always start at zero for revenue)
- Max value: Auto (or set if you want consistent scale)
- Format: NGN, Compact (shows 5M instead of 5,000,000)

**Chart Title:**
- Text: "Monthly Revenue Trend - 2025"
- Font: Roboto Medium
- Size: 18px
- Color: #212121 (dark gray)

**[SCREENSHOT 4: Styled time series chart with professional formatting]**
*Caption: Completed monthly revenue trend with proper styling and labels*

---

## Time Series Chart Variations

### Variation 1: Multiple Metrics Comparison

**Use Case:** Compare revenue and order count over time

**Configuration:**
- **Metric 1:** SUM(price) - Revenue (Left Y-axis)
- **Metric 2:** COUNT(order_id) - Order Count (Right Y-axis)

**Why Two Axes?**
- Revenue: NGN 5,000,000
- Order Count: 1,500
- Different scales require different axes

**Setup in Looker:**
1. Add first metric (revenue)
2. Add second metric (order count)
3. **Style** → **Series** → Set metric 2 to **Right Axis**

**Business Insight:**
- If revenue up but orders flat → Higher average order value
- If orders up but revenue flat → Lower average order value
- Both up → Healthy growth

**SQL Equivalent:**
```sql
SELECT
    DATE_TRUNC('month', order_purchase_timestamp) as order_month,
    SUM(price) as revenue,
    COUNT(DISTINCT o.order_id) as order_count
FROM olist_sales_data_set.olist_order_items_dataset oi
JOIN olist_sales_data_set.olist_orders_dataset o ON oi.order_id = o.order_id
GROUP BY order_month
ORDER BY order_month;
```

**[SCREENSHOT 5: Dual-axis time series comparing revenue and order count]**
*Caption: Left axis shows revenue (bars), right axis shows order count (line)*

---

### Variation 2: Multi-Line Comparison (Category Breakdown)

**Use Case:** Compare sales across product categories over time

**Configuration:**
- **Date Dimension:** order_purchase_timestamp (Month)
- **Breakdown Dimension:** product_category_name
- **Metric:** SUM(price)

**Result:** Multiple colored lines, one per category

**Best Practices:**
- Limit to 5-7 categories (too many lines = spaghetti chart)
- Use distinct colors
- Add legend clearly labeled

**SQL Equivalent:**
```sql
SELECT
    DATE_TRUNC('month', order_purchase_timestamp) as order_month,
    pct.product_category_name_english,
    SUM(price) as category_revenue
FROM olist_sales_data_set.olist_order_items_dataset oi
JOIN olist_sales_data_set.olist_orders_dataset o ON oi.order_id = o.order_id
JOIN olist_sales_data_set.olist_products_dataset p ON oi.product_id = p.product_id
JOIN olist_sales_data_set.product_category_name_translation pct
    ON p.product_category_name = pct.product_category_name
WHERE pct.product_category_name_english IN
    ('Electronics', 'Fashion', 'Home & Garden', 'Beauty', 'Sports')
GROUP BY order_month, pct.product_category_name_english
ORDER BY order_month;
```

**Nigerian Product Categories Example:**
- Electronics (phones, laptops, accessories)
- Fashion & Apparel
- Home & Living
- Beauty & Personal Care
- Sports & Fitness

**[SCREENSHOT 6: Multi-line time series showing category trends]**
*Caption: Five product categories tracked over 12 months with color-coded lines*

---

### Variation 3: Area Chart (Stacked)

**Use Case:** Show composition of total over time (100% stacked or value stacked)

**When to Use:**
- Visualizing parts of a whole over time
- Showing cumulative impact
- Emphasizing volume/magnitude

**100% Stacked Area Chart Example:**
- Shows proportion of each category in total revenue
- Each time period adds to 100%

**Value Stacked Area Chart Example:**
- Shows actual values stacking on top of each other
- Top line represents total revenue

**Configuration:**
1. Add chart → **Area Chart**
2. **Date Dimension:** order_purchase_timestamp (Month)
3. **Breakdown:** product_category_name
4. **Metric:** SUM(price)
5. **Style** → **Stacked:** Yes (or 100% stacked)

**SQL Concept (Week 8: Aggregation patterns):**
```sql
SELECT
    DATE_TRUNC('month', order_purchase_timestamp) as order_month,
    product_category_name,
    SUM(price) as category_revenue,
    SUM(SUM(price)) OVER (PARTITION BY DATE_TRUNC('month', order_purchase_timestamp))
        as total_monthly_revenue
FROM olist_sales_data_set.olist_order_items_dataset oi
JOIN olist_sales_data_set.olist_products_dataset p ON oi.product_id = p.product_id
GROUP BY order_month, product_category_name;
```

**[SCREENSHOT 7: Stacked area chart showing category composition over time]**
*Caption: Stacked area chart reveals how product mix changes month-to-month*

---

## Nigerian Business Time Series Examples

### Example 1: Festive Season Analysis

**Chart:** Daily order volume (December 1-31, 2025)

**Purpose:** Identify peak shopping days

**Expected Patterns:**
- Spike on December 1 (Christmas shopping begins)
- Peak around December 20-22 (last-minute shopping)
- Drop on December 25 (Christmas Day)
- Final spike December 26-27 (Boxing Day sales)

**Configuration:**
- **Dimension:** order_purchase_timestamp (Day)
- **Date Range:** December 1-31, 2025
- **Metric:** COUNT(order_id)

**Business Action:**
- Schedule extra customer service for peak days
- Increase inventory before spikes
- Plan delivery logistics for high-volume periods

---

### Example 2: Weekly Pattern Analysis

**Chart:** Average daily orders by day of week (Last 90 days)

**Purpose:** Understand weekly shopping patterns

**SQL Equivalent:**
```sql
SELECT
    EXTRACT(DOW FROM order_purchase_timestamp) as day_of_week,
    TO_CHAR(order_purchase_timestamp, 'Day') as day_name,
    AVG(daily_orders) as avg_orders
FROM (
    SELECT
        DATE(order_purchase_timestamp) as order_date,
        EXTRACT(DOW FROM order_purchase_timestamp) as day_of_week,
        COUNT(*) as daily_orders
    FROM olist_sales_data_set.olist_orders_dataset
    WHERE order_purchase_timestamp >= CURRENT_DATE - INTERVAL '90 days'
    GROUP BY DATE(order_purchase_timestamp)
) daily_summary
GROUP BY day_of_week, day_name
ORDER BY day_of_week;
```

**Expected Pattern (Nigerian Context):**
- **Monday-Wednesday:** Moderate activity
- **Thursday-Friday:** Peak (payday for many workers)
- **Saturday:** High (weekend shopping)
- **Sunday:** Moderate to low (family/religious activities)

**Business Action:**
- Schedule promotions for Thursday-Friday
- Optimize delivery for Saturday orders
- Reduce customer service staffing on Sundays

---

### Example 3: Month-over-Month Growth Rate

**Chart:** Revenue with growth percentage overlay

**Calculated Field Required:**
```
Growth Rate = (Current Month - Previous Month) / Previous Month * 100
```

**Looker Calculation:**
```
(SUM(price) - LAG(SUM(price))) / LAG(SUM(price)) * 100
```

**Visual:**
- Bar chart: Monthly revenue
- Line overlay: Growth percentage

**Target:** 10% month-over-month growth

**[SCREENSHOT 8: Combo chart showing revenue bars with growth rate line]**
*Caption: Bars show absolute revenue, line shows percentage growth rate*

---

## Common Time Series Patterns to Recognize

### Pattern 1: Seasonal Trend
**Looks Like:** Regular peaks and valleys at consistent intervals

**Example:** Higher sales in December (Christmas), dips in January

**Business Response:** Stock up before known peak seasons

---

### Pattern 2: Growth Trend
**Looks Like:** Consistent upward slope over time

**Example:** Steady 15% month-over-month revenue increase

**Business Response:** Scale operations, hire staff, expand inventory

---

### Pattern 3: Decline Trend
**Looks Like:** Consistent downward slope

**Example:** Decreasing order volume for 3 consecutive months

**Business Response:** Investigate causes (competition, quality issues, marketing gaps)

---

### Pattern 4: Cyclical Pattern
**Looks Like:** Repeating wave pattern (not strictly seasonal)

**Example:** Sales spike every 3 months (quarterly bonuses)

**Business Response:** Time promotions to match cycles

---

### Pattern 5: Step Change
**Looks Like:** Sudden jump or drop, then new plateau

**Example:** Revenue doubles after launching new product category

**Business Response:** Sustain gains, replicate success factors

---

## Advanced Time Series Techniques

### Technique 1: Reference Lines (Targets)

**Purpose:** Show performance vs goal

**Configuration:**
1. **Style** → **Reference Lines**
2. Add line: "Monthly Target - NGN 5M"
3. Line style: Dashed, color: Gray
4. Label: "Target: NGN 5M"

**Result:** Easy visual of above/below target performance

---

### Technique 2: Annotations

**Purpose:** Mark significant events on timeline

**Examples:**
- "Marketing Campaign Launched"
- "New Product Category Added"
- "Website Redesign"
- "COVID-19 Lockdown"

**Setup:**
1. **Style** → **Annotations**
2. Add annotation: Select date, add label
3. Show as vertical line or marker

**Business Value:** Connect data changes to real-world events

---

### Technique 3: Trend Lines

**Purpose:** Show overall direction despite noise

**Configuration:**
1. **Style** → **Trend Line**
2. Type: Linear (straight line best fit)
3. Color: Subtle gray
4. Show R-squared (correlation strength)

**Interpretation:**
- Upward trend line = overall growth
- Downward = overall decline
- Flat = no clear trend

---

### Technique 4: Period Comparison

**Purpose:** Compare current period to previous period side-by-side

**Example:** This December vs Last December

**Configuration:**
1. Add **Date Range Control** to dashboard
2. Set primary range: Dec 1-31, 2025
3. Enable **Comparison Range**: Dec 1-31, 2024
4. Chart shows both lines: Current (solid), Previous (dashed)

**Nigerian Context:**
Compare Eid 2025 to Eid 2024, Black Friday 2025 to 2024, etc.

---

## Time Series Best Practices

### Rule 1: Always Start Y-Axis at Zero (for Volume/Revenue)
**Why:** Starting at arbitrary number distorts perception of change

**Exception:** Percentage changes can start at non-zero

---

### Rule 2: Use Appropriate Granularity
**Short Term (1-3 months):** Daily or Weekly
**Medium Term (3-12 months):** Weekly or Monthly
**Long Term (1+ years):** Monthly or Quarterly

**Too Granular:** Daily chart of 5 years = unreadable
**Too Coarse:** Annual chart of 3 months = no insight

---

### Rule 3: Limit Number of Lines
**Maximum:** 5-7 lines per chart
**Reason:** More = spaghetti chart (confusing)

**Solution for Many Categories:**
- Create separate chart for each category
- Use small multiples (4 mini charts)
- Use filter control to select category

---

### Rule 4: Label Clearly
**Always Include:**
- Chart title: "Monthly Revenue Trend - Last 12 Months"
- Y-axis label: "Revenue (NGN Millions)"
- X-axis label: "Month"
- Legend: If multiple lines/series

---

### Rule 5: Consider Time Zone
**Nigerian Time (WAT):** UTC+1
**Ensure:** Database timestamps and Looker timezone match
**Issue:** Mismatched timezones = orders appear on wrong dates

**Set in Looker:**
- **Data Source** → **Timezone:** Africa/Lagos

---

## Hands-On Exercise Preview

**You'll Create:**
1. **Monthly Revenue Time Series** (Last 12 months)
2. **Daily Order Volume** (Last 30 days)
3. **Category Comparison** (Top 5 categories, monthly trends)
4. **Stacked Area Chart** (Revenue composition by payment type)

**Using Skills:**
- Date dimension configuration
- Multiple metrics
- Breakdown dimensions
- Professional styling
- Reference lines for targets

---

## Key Takeaways

1. **Time series shows CHANGE** - Always about trends, not static values
2. **Date dimension is critical** - Must configure properly with right granularity
3. **Context matters** - Nigerian business cycles affect interpretation
4. **Comparison adds insight** - Current vs previous period reveals growth
5. **Visual clarity wins** - Clean, simple charts tell better stories

---

## Connection to SQL Skills

| SQL Skill (Week 5) | Looker Time Series Application |
|--------------------|-------------------------------|
| **DATE_TRUNC('month', date)** | Month granularity in dimension |
| **EXTRACT(YEAR FROM date)** | Year filtering in date range |
| **GROUP BY date** | Automatic grouping by time dimension |
| **ORDER BY date** | Automatic chronological ordering |
| **LAG() window function** | Period-over-period comparison |

---

**Next Section:** Dashboard Layout and Design Principles (04_dashboard_layout_design.md)

**[SCREENSHOT 9: Complete time series dashboard example]**
*Caption: Professional dashboard showing multiple time series visualizations for Nigerian e-commerce*

---

## Additional Resources

- **Date Function Reference:** Complete guide to Looker date calculations
- **Seasonal Pattern Guide:** Nigerian business calendar with key shopping periods
- **Time Series Troubleshooting:** Common issues and solutions
- **Advanced Forecasting:** Using trend lines for prediction (Week 15 preview)
