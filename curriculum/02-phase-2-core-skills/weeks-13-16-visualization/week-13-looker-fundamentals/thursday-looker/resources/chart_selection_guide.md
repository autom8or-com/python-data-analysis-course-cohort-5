# Chart Selection Quick Reference Guide

**Week 13 - Looker Studio Fundamentals**
**Purpose:** Quick decision tree for choosing the right visualization

---

## The 30-Second Chart Selection Process

### Step 1: Identify Your Data Story Type

Ask yourself: **"What am I trying to show?"**

```
┌─────────────────────────────────────┐
│  What's the SINGLE MOST             │
│  IMPORTANT message?                 │
└─────────────────────────────────────┘
           │
           ├─→ A single number? ────────→ SCORECARD/GAUGE
           │
           ├─→ Change over time? ───────→ TIME SERIES
           │
           ├─→ Comparison of items? ────→ BAR/COLUMN CHART
           │
           ├─→ Part of a whole? ────────→ PIE/DONUT/TREEMAP
           │
           ├─→ Location-based? ─────────→ GEO MAP
           │
           ├─→ Detailed records? ───────→ TABLE
           │
           ├─→ Correlation? ────────────→ SCATTER PLOT
           │
           └─→ Flow/process? ───────────→ SANKEY DIAGRAM
```

---

## Chart Type Decision Matrix

| Business Question | Best Chart | Second Choice | Avoid |
|-------------------|------------|---------------|--------|
| "What is the total?" | Scorecard | Gauge | Pie Chart |
| "What's the trend?" | Time Series (Line) | Area Chart | Pie Chart |
| "Which is highest?" | Bar Chart | Table | Line Chart |
| "What's the breakdown?" | Pie (3-6 items) | Bar Chart | Line Chart |
| "What's the breakdown?" (7+ items) | Treemap | Bar Chart | Pie Chart |
| "Where is it happening?" | Geo Map (Filled) | Geo Map (Bubble) | Table |
| "How do 2 variables relate?" | Scatter Plot | Dual-Axis Line | Two separate charts |
| "What's the journey?" | Sankey | Stacked Bar | Pie Chart |
| "What are the details?" | Table | Pivot Table | Many scorecards |

---

## Quick Decision Flowchart

```
START: I have data to visualize
│
├─→ Is it just ONE number?
│   │
│   YES → Use SCORECARD
│   │      └─→ Show progress to goal? → Use GAUGE instead
│   │
│   NO (continue)
│
├─→ Does it have a TIME dimension?
│   │
│   YES → Use TIME SERIES (Line Chart)
│   │      └─→ Multiple categories over time? → Use Stacked Area
│   │
│   NO (continue)
│
├─→ Am I COMPARING categories?
│   │
│   YES → How many categories?
│   │      ├─→ 3-20 categories → BAR CHART
│   │      └─→ 20+ categories → TABLE with sorting
│   │
│   NO (continue)
│
├─→ Am I showing PROPORTIONS?
│   │
│   YES → How many parts?
│   │      ├─→ 3-6 parts → PIE CHART
│   │      ├─→ 7-15 parts → DONUT CHART
│   │      └─→ 15+ parts → TREEMAP
│   │
│   NO (continue)
│
├─→ Is there a GEOGRAPHIC component?
│   │
│   YES → Use GEO MAP
│   │      ├─→ Compare regions → Filled (Choropleth)
│   │      └─→ Show specific locations → Bubble Map
│   │
│   NO (continue)
│
├─→ Am I looking for RELATIONSHIPS?
│   │
│   YES → Use SCATTER PLOT
│   │
│   NO (continue)
│
└─→ Default: Use TABLE (detailed data view)
```

---

## Chart Type Cheat Sheet

### 1. SCORECARD
**When:** Single, important metric
**Example:** Total Revenue = NGN 45.3M
**Good For:** KPIs, headline numbers, dashboard summaries
**Limit:** One metric per scorecard
**Nigerian Use:** Monthly sales, customer count, average delivery time

---

### 2. GAUGE
**When:** Single metric with target/goal
**Example:** Delivery on-time rate (92% of 95% target)
**Good For:** Performance against goals
**Limit:** Works best with 0-100% ranges
**Nigerian Use:** Service level agreements, quota achievement

---

### 3. TIME SERIES (Line Chart)
**When:** Showing trends over time periods
**Example:** Monthly revenue trend (Jan-Dec)
**Good For:** Identifying patterns, seasonality, growth
**Limit:** Max 5-7 lines (avoid spaghetti chart)
**Nigerian Use:** Holiday sales patterns, weekly order volume

---

### 4. BAR CHART (Horizontal)
**When:** Comparing categories with long names
**Example:** Revenue by Nigerian state (Lagos, Kano, Rivers...)
**Good For:** Rankings, top N lists
**Limit:** 3-20 bars (more = use table)
**Nigerian Use:** Top states, top products, top customers

---

### 5. COLUMN CHART (Vertical)
**When:** Comparing categories with short names OR time periods
**Example:** Monthly sales (Jan, Feb, Mar, Apr, May...)
**Good For:** Short time periods, short category names
**Limit:** 3-12 columns
**Nigerian Use:** Quarterly comparisons, day-of-week patterns

---

### 6. PIE CHART
**When:** Showing simple proportions (part of whole)
**Example:** Payment method distribution
**Good For:** 3-6 categories max
**Limit:** Never use with >6 slices
**Nigerian Use:** Market share, customer segments

---

### 7. DONUT CHART
**When:** Like pie chart, with center space for total
**Example:** Revenue by category with total in center
**Good For:** 4-7 categories
**Limit:** Same as pie chart
**Nigerian Use:** Product mix, order status breakdown

---

### 8. TREEMAP
**When:** Hierarchical proportions with many categories
**Example:** Revenue by category → subcategory
**Good For:** 10-50 categories, nested structures
**Limit:** Requires hierarchical data
**Nigerian Use:** Product catalog, organizational structure

---

### 9. GEO MAP - Filled (Choropleth)
**When:** Regional comparisons (states, countries)
**Example:** Sales by Nigerian state (color intensity)
**Good For:** Geographic patterns, heat mapping
**Limit:** Needs location dimension
**Nigerian Use:** State-by-state performance, delivery coverage

---

### 10. GEO MAP - Bubble
**When:** Specific locations with metric magnitude
**Example:** Order volume by city (bubble size)
**Good For:** Precise locations, magnitude comparison
**Limit:** Can get crowded with many locations
**Nigerian Use:** Store locations with sales volume

---

### 11. TABLE
**When:** Need to show detailed, granular data
**Example:** Recent 50 orders with all details
**Good For:** Lookup, detail views, many columns
**Limit:** Limited to ~100 rows on screen
**Nigerian Use:** Order history, customer directory

---

### 12. PIVOT TABLE
**When:** Cross-tabulation (rows AND columns grouping)
**Example:** Revenue by State (rows) × Month (columns)
**Good For:** Multi-dimensional analysis
**Limit:** Can become complex quickly
**Nigerian Use:** Sales by region and time period

---

### 13. SCATTER PLOT
**When:** Exploring relationship between two numeric variables
**Example:** Product price vs sales volume
**Good For:** Correlation analysis, outlier detection
**Limit:** Needs two numeric metrics
**Nigerian Use:** Price elasticity, customer value analysis

---

### 14. COMBO CHART (Line + Bar)
**When:** Two metrics with different scales
**Example:** Revenue (bars) and Order Count (line)
**Good For:** Comparing related but different metrics
**Limit:** Max 2 metrics with different Y-axes
**Nigerian Use:** Sales volume vs average order value

---

### 15. STACKED BAR/COLUMN
**When:** Showing composition AND comparison
**Example:** Revenue by state, broken down by payment type
**Good For:** Part-to-whole across categories
**Limit:** Max 5-7 stack segments
**Nigerian Use:** Category sales by order status

---

### 16. AREA CHART
**When:** Time series emphasizing magnitude/volume
**Example:** Cumulative revenue over time
**Good For:** Stacked categories over time
**Limit:** Like time series, max 5-7 series
**Nigerian Use:** Revenue composition over time

---

### 17. SANKEY DIAGRAM
**When:** Showing flow between stages or categories
**Example:** Customer journey (Visit → Cart → Purchase)
**Good For:** Process flows, conversion funnels
**Limit:** Works best with 3-10 stages
**Nigerian Use:** Order status flow, referral sources

---

## Context-Based Selection Guide

### Executive Dashboard (For CEO/COO)
**Use:**
- 4-6 **Scorecards** for KPIs
- 1 **Time Series** for main trend
- 2-3 **Bar Charts** for key breakdowns
- 1 **Geo Map** if geography matters

**Avoid:**
- Tables (too detailed)
- Scatter plots (too analytical)
- More than 8 total charts

---

### Operational Dashboard (For Managers)
**Use:**
- 3-4 **Scorecards** for key metrics
- 1-2 **Time Series** for trends
- 2-3 **Bar/Column Charts** for comparisons
- 1 **Table** for recent activity
- **Gauge** for performance vs target

**Avoid:**
- Pie charts (use bars instead)
- Too many colors

---

### Analytical Dashboard (For Analysts)
**Use:**
- 1-2 **Scorecards** for context
- 2-3 **Time Series** with drill-down
- **Scatter Plots** for correlations
- **Tables** and **Pivot Tables** for details
- **Filters** for exploration

**Avoid:**
- Limiting to simple charts (analysts want depth)

---

## Common Mistakes and Fixes

| Mistake | Why It's Wrong | Fix |
|---------|----------------|-----|
| Pie chart with 12 slices | Unreadable | Use bar chart or treemap |
| Line chart for categories | Categories aren't sequential | Use bar chart |
| Scorecard for trend | Can't see change over time | Use time series |
| Table for summary | Too much detail | Use scorecards or bar chart |
| Bar chart starting at 50 | Distorts perception | Always start at 0 for volume/revenue |
| 3D chart | Distorts values | Use 2D version |

---

## Nigerian E-Commerce Specific Recommendations

### Revenue Analysis
- **Primary:** Scorecard (total revenue)
- **Trend:** Time Series (monthly revenue)
- **Breakdown:** Bar Chart (revenue by state)

### Customer Analysis
- **Primary:** Scorecard (total customers)
- **Segmentation:** Pie Chart (new vs returning, max 5 segments)
- **Geographic:** Geo Map (customers by state)

### Product Performance
- **Top Products:** Bar Chart (horizontal, top 10)
- **Category Mix:** Treemap (all categories and subcategories)
- **Trend:** Time Series (category sales over time)

### Logistics & Delivery
- **On-Time %:** Gauge (vs 95% target)
- **Delivery Time:** Scorecard (average days)
- **By State:** Geo Map (average delivery time by region)

### Order Processing
- **Status Flow:** Sankey (Pending → Processing → Shipped → Delivered)
- **Recent Orders:** Table (last 20 orders with details)
- **Daily Volume:** Time Series (orders per day, last 30 days)

---

## Mobile-Friendly Chart Ranking

**Best for Mobile (Small Screens):**
1. Scorecard (perfect - large number)
2. Gauge (simple, visual)
3. Simple Bar Chart (3-5 bars)
4. Single-Line Time Series
5. Table (limit to 3-4 columns)

**Okay for Mobile:**
6. Pie/Donut Chart
7. Multi-Line Time Series (max 3 lines)
8. Geo Map (interactive)

**Avoid on Mobile:**
9. Pivot Tables (too wide)
10. Scatter Plots (too detailed)
11. Complex Stacked Charts
12. Tables with 8+ columns

---

## Quick Nigerian Context Checklist

When creating any chart for Nigerian business:

- [ ] Currency shows NGN (not $, not ₦ alone)
- [ ] Dates use clear format (Nov 13, 2025 not 13/11/25)
- [ ] Numbers use compact format (45.3M not 45,300,000)
- [ ] Geographic data uses Nigerian states/cities
- [ ] Colors accessible (not relying on red-green for color blind users)
- [ ] Mobile-responsive (60% of Nigerian users on mobile)
- [ ] Consider data costs (optimize images, extracts vs live)

---

## Emergency Chart Selector

**"I have 5 minutes to create a chart - what do I use?"**

| Your Data | Use This Chart | 5-Minute Priority |
|-----------|----------------|-------------------|
| 1 number | Scorecard | Just show the number, large font |
| Trend over time | Time Series | Monthly data, last 12 months |
| Top 10 list | Bar Chart | Horizontal, sorted descending |
| Breakdown (3-5 parts) | Pie Chart | Show percentages |
| Breakdown (6+ parts) | Bar Chart | Not pie - too crowded |
| Lots of details | Table | Sort by most important column |

**Styling Priority (5 minutes):**
1. Clear title (3 seconds)
2. Proper number format - NGN, dates (10 seconds)
3. Color that matches brand (5 seconds)
4. Remove chartjunk - 3D, shadows, extra lines (2 seconds)
5. Done!

---

## Print-Friendly Summary Card

```
┌─────────────────────────────────────────────────────┐
│  LOOKER STUDIO CHART SELECTOR - QUICK REFERENCE     │
├─────────────────────────────────────────────────────┤
│                                                     │
│  Single Number → SCORECARD                          │
│  Trend Over Time → TIME SERIES (Line)               │
│  Compare Categories → BAR CHART (horizontal)        │
│  Proportions (3-6) → PIE CHART                      │
│  Proportions (7+) → TREEMAP or BAR CHART            │
│  Geographic → GEO MAP (Filled or Bubble)            │
│  Detailed Data → TABLE                              │
│  Correlation → SCATTER PLOT                         │
│  Flow/Journey → SANKEY DIAGRAM                      │
│                                                     │
│  DEFAULT: When in doubt, use BAR CHART              │
│                                                     │
│  Nigerian Context: Always NGN, Compact Numbers,     │
│  Mobile-Responsive, Accessible Colors               │
└─────────────────────────────────────────────────────┘
```

---

**Bookmark this guide! Reference it every time you create a new visualization.**

**Pro Tip:** The best chart is the simplest one that clearly answers the business question. When in doubt, go simpler.

---

## Additional Resources

- Full Chart Type Overview: Lecture Material 01
- Scorecard Guide: Lecture Material 02
- Time Series Guide: Lecture Material 03
- Dashboard Design: Lecture Material 04
