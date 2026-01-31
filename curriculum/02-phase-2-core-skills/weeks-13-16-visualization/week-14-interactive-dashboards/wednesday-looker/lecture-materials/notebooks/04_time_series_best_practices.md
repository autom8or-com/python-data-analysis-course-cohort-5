# Time Series Analysis and Visualization Best Practices

## Week 14 - Wednesday Session - Part 4

### Duration: 20 minutes

---

## What Is Time Series Analysis?

**Time series analysis** examines data points ordered chronologically to identify trends, patterns, seasonality, and anomalies over time. It's one of the most powerful tools for business decision-making.

### Why Time Matters in Business

**Business Questions Time Series Answers:**
- "Are sales growing or declining?"
- "Which months have highest revenue?"
- "How does this quarter compare to last year?"
- "Did our marketing campaign boost orders?"
- "What's the delivery time trend?"

**Without time context:** "We made ₦50M in sales" (so what?)
**With time context:** "We made ₦50M this month, up 20% from last month" (actionable!)

---

## Connection to Prior Learning

### Week 5: SQL Date Functions and Time-Based Analysis

```sql
-- Extract time components (from Week 5)
SELECT
  DATE_TRUNC('month', order_purchase_timestamp) as month,
  COUNT(*) as order_count,
  SUM(price) as revenue
FROM olist_orders_dataset
GROUP BY DATE_TRUNC('month', order_purchase_timestamp)
ORDER BY month;
```

**Looker Studio:** Visualizes this query as an interactive line chart.

### Week 8: Window Functions for Period Comparison

```sql
-- Compare to previous period (from Week 8)
SELECT
  month,
  revenue,
  LAG(revenue, 1) OVER (ORDER BY month) as prev_month_revenue,
  revenue - LAG(revenue, 1) OVER (ORDER BY month) as revenue_change
FROM monthly_revenue;
```

**Looker Studio:** Built-in comparison features eliminate need for complex SQL.

### Python: Time Series with Pandas

```python
# Python date manipulation (from Week 10)
df['order_date'] = pd.to_datetime(df['order_purchase_timestamp'])
df.set_index('order_date').resample('M')['price'].sum()
```

**Looker Studio:** Automatic date grouping—no coding required.

---

## Part 1: Essential Time Series Chart Types

### 1. Line Chart (Trend Over Time)

**Best for:**
- Revenue trends
- Order volume over time
- Customer acquisition growth
- KPI tracking

**When to use:**
- Continuous time periods (daily, weekly, monthly)
- Showing trends and patterns
- Comparing multiple metrics over time

**Nigerian E-commerce Example:**
```
Monthly Revenue Trend (Jan-Dec 2017)
₦60M │                           ╱╲
     │                          ╱  ╲
₦40M │                    ╱────╱    ╲
     │               ╱───╱           ╲
₦20M │          ╱───╱                 ╲
     │     ╱───╱                       ╲───
₦0M  └────────────────────────────────────→
     Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec
```

**Insight:** Peak in November (Black Friday), dip in January (post-holiday).

### 2. Area Chart (Volume + Trend)

**Best for:**
- Total accumulated values
- Part-to-whole over time (stacked areas)
- Showing magnitude of change

**When to use:**
- Emphasizing total volume
- Comparing proportions over time (stacked)
- Showing cumulative growth

**Example: Payment Method Trends**
```
Stacked Area: Revenue by Payment Type
₦60M │████████████████████████ Credit Card
₦50M │██████████████████░░░░░░ Boleto
₦40M │████████████░░░░░░░░░░░░ Debit Card
₦30M │██████░░░░░░░░░░░░░░░░░░ Voucher
     └────────────────────────→
     Q1        Q2        Q3        Q4
```

**Insight:** Credit card usage growing; voucher declining.

### 3. Column Chart (Period Comparison)

**Best for:**
- Discrete time periods (quarters, years)
- Easy visual comparison
- Categorical time breakdowns

**When to use:**
- Comparing performance across distinct periods
- Highlighting specific period performance
- Monthly/quarterly summaries

**Example: Quarterly Revenue**
```
Revenue by Quarter 2017
₦60M ┤     ▓▓
     │     ▓▓
₦40M ┤ ▓▓  ▓▓  ▓▓
     │ ▓▓  ▓▓  ▓▓  ▓▓
₦20M ┤ ▓▓  ▓▓  ▓▓  ▓▓
     │ ▓▓  ▓▓  ▓▓  ▓▓
     └─────────────────
      Q1  Q2  Q3  Q4
```

### 4. Combo Chart (Multiple Metrics)

**Best for:**
- Revenue vs Order Count
- Sales vs Profit Margin
- Volume vs Average Order Value

**When to use:**
- Different scales (e.g., millions vs percentages)
- Showing correlation between metrics
- Dual-axis analysis

**Example: Sales Volume vs AOV**
```
Monthly Sales Analysis
Orders │                        │ AOV
10K    ┤ ╱╲    ╱╲              ┤ ₦800
       │╱  ╲  ╱  ╲         •   │
8K     ┤    ╲╱    ╲     •      ┤ ₦600
       │          •╲  •        │
6K     ┤        •    •         ┤ ₦400
       └───────────────────────┘
       Jan Feb Mar Apr May Jun
       ─── Order Count
       ••• Avg Order Value
```

**Insight:** More orders but lower AOV—focus on upselling.

---

## Part 2: Date Granularity Selection

### Understanding Granularity

**Granularity** = level of time detail (hour, day, week, month, year)

### Choosing the Right Granularity

| Timeframe | Best Granularity | Example Use Case |
|-----------|------------------|------------------|
| **Last 7 days** | Daily or hourly | Real-time monitoring |
| **Last 30 days** | Daily | Weekly pattern analysis |
| **Last 90 days** | Daily or weekly | Trend identification |
| **Last 12 months** | Weekly or monthly | Seasonal patterns |
| **Last 2+ years** | Monthly or quarterly | Long-term growth |
| **Multi-year** | Quarterly or yearly | Strategic planning |

### Too Granular = Noise

```
❌ Bad: Hourly data over 2 years (17,520 data points—chart is cluttered)

✅ Good: Monthly data over 2 years (24 data points—clear trend)
```

### Too Aggregated = Lost Insights

```
❌ Bad: Annual data for last 3 months (only 1 data point!)

✅ Good: Daily or weekly data for last 3 months
```

### Configuring Granularity in Looker Studio

#### Step 1: Select Chart with Date Dimension

1. Click your time series chart (line or area)
2. Right panel → **Data** tab
3. Find **Dimension** section

#### Step 2: Choose Date Type

```
Dimension
─────────────────────────────────────
order_purchase_timestamp

Click dropdown →
├── Date (YYYYMMDD) - Daily
├── Year Week (YYYYWW) - Weekly
├── Year Month (YYYYMM) - Monthly ← Select
├── Year Quarter (YYYYQ) - Quarterly
├── Year (YYYY) - Yearly
├── Month (1-12)
├── Week (1-52)
└── Hour (0-23)
```

**Pro Tip:** For trend analysis, start monthly, then drill to weekly/daily if needed.

---

## Part 3: Time-Based Comparisons

### Comparison Types

#### 1. Period-over-Period (Sequential)

**Compares:** This period vs immediately previous period

**Examples:**
- This month vs last month
- This week vs last week
- This quarter vs last quarter

**Business Value:** Detect immediate changes (growth or decline).

#### 2. Year-over-Year (Seasonal)

**Compares:** This period vs same period last year

**Examples:**
- December 2017 vs December 2016
- Q4 2017 vs Q4 2016

**Business Value:** Account for seasonality (holiday shopping, harvest seasons).

#### 3. Custom Period Comparison

**Compares:** Any two specific periods

**Examples:**
- Campaign period vs pre-campaign baseline
- Holiday season vs regular months
- Before/after product launch

### Setting Up Comparisons in Looker Studio

#### Method 1: Date Range Control Comparison (Easiest)

**Step 1: Configure Date Range Control**

1. Select date range control
2. Right panel → **Setup** tab
3. Enable comparison:

```
Comparison Date Range
─────────────────────────────────────
☑ Enable comparison

Comparison Type
⚪ Previous period (e.g., last month vs month before)
⚪ Previous year (e.g., this month vs same month last year) ← Select
⚪ Custom

Comparison Label: "vs Last Year"
```

**Step 2: Charts Auto-Update**

All time series charts connected to this control now show:
- Primary metric (current period)
- Comparison metric (previous year)
- Percentage change

**Example:**
```
Revenue Trend: This Year vs Last Year
₦60M │
     │     /\      Current Year (solid line)
₦40M │    /  \
     │   /    \    Last Year (dashed line)
₦20M │  /.....\.
     │ /       .\
     └────────────→
     Jan Feb Mar Apr
```

#### Method 2: Calculated Field Comparison (Advanced)

**Use Case:** Custom comparison not available in date control

**Step 1: Create Comparison Fields**

```sql
-- Add to data source custom query
WITH comparison AS (
  SELECT
    order_purchase_timestamp::date as date,
    SUM(price) as revenue,
    -- Same day last year
    SUM(price) FILTER (
      WHERE order_purchase_timestamp::date =
        CURRENT_DATE - INTERVAL '1 year'
    ) as revenue_last_year
  FROM olist_order_items_dataset
  GROUP BY date
)
SELECT
  date,
  revenue,
  revenue_last_year,
  ((revenue - revenue_last_year) / revenue_last_year * 100) as yoy_growth_pct
FROM comparison;
```

**Step 2: Visualize in Looker**

Add both metrics to chart:
- `revenue` (primary line)
- `revenue_last_year` (comparison line)
- `yoy_growth_pct` (secondary axis or tooltip)

---

## Part 4: Trend Analysis Techniques

### 1. Moving Averages (Smoothing)

**Purpose:** Remove daily noise to see underlying trend

**Business Case:** Daily revenue jumps around; 7-day average shows true direction.

**Looker Studio Implementation:**

Create calculated field:
```
Field Name: revenue_7day_avg
Formula: AVG(revenue) -- with date range set to 7 days

Note: Looker has limited window functions.
Better approach: Calculate in SQL custom query
```

**SQL Custom Query (Recommended):**
```sql
SELECT
  order_purchase_timestamp::date as date,
  SUM(price) as revenue,
  AVG(SUM(price)) OVER (
    ORDER BY order_purchase_timestamp::date
    ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
  ) as revenue_7day_avg
FROM olist_order_items_dataset
GROUP BY order_purchase_timestamp::date
ORDER BY date;
```

**Chart Setup:**
- Line 1: `revenue` (actual—lighter color, thin line)
- Line 2: `revenue_7day_avg` (trend—darker color, thick line)

**Visual Example:**
```
Revenue with 7-Day Moving Average
₦5M │  •  •              Actual (noisy)
    │   \/  •  •
₦4M │   /\  \/  •
    │  /  \/  \/         ─── 7-Day Avg (smooth trend)
₦3M │─/────\────\───
    └─────────────────→
```

### 2. Cumulative Metrics (Running Totals)

**Purpose:** Show accumulated value over time

**Business Case:** "We've made ₦450M so far this year"

**SQL Implementation:**
```sql
SELECT
  order_purchase_timestamp::date as date,
  SUM(price) as daily_revenue,
  SUM(SUM(price)) OVER (
    ORDER BY order_purchase_timestamp::date
    ROWS UNBOUNDED PRECEDING
  ) as cumulative_revenue
FROM olist_order_items_dataset
WHERE EXTRACT(YEAR FROM order_purchase_timestamp) = 2017
GROUP BY order_purchase_timestamp::date
ORDER BY date;
```

**Looker Chart:**
```
Cumulative Revenue 2017
₦600M │                      ╱───── Year-end total
      │                   ╱──
₦400M │                ╱──
      │             ╱──
₦200M │         ╱───
      │    ╱────
₦0M   └──────────────────────→
      Jan  Mar  May  Jul  Sep  Nov
```

**Insight:** Slope indicates growth rate (steeper = faster growth).

### 3. Growth Rate Calculation

**Purpose:** Measure percentage change over time

**Calculation Types:**

**Period-over-Period Growth:**
```
Growth Rate = ((Current - Previous) / Previous) * 100
```

**SQL:**
```sql
SELECT
  month,
  revenue,
  LAG(revenue) OVER (ORDER BY month) as prev_month,
  ROUND(
    ((revenue - LAG(revenue) OVER (ORDER BY month)) /
     LAG(revenue) OVER (ORDER BY month) * 100),
    2
  ) as growth_rate_pct
FROM monthly_revenue
ORDER BY month;
```

**Looker Calculated Field:**
```
Field Name: mom_growth
Formula:
(revenue - revenue_previous_period) / revenue_previous_period * 100

Note: Requires comparison date range enabled
```

**Visualization:**
```
Month-over-Month Growth Rate
+30% ┤     •
     │    /
+15% ┤   •    •
     │  /      \
  0% ┼─•────────•───
     │           \
-15% ┤            •
     └──────────────→
     Jan Feb Mar Apr May
```

**Insight:** Identify acceleration or deceleration of growth.

---

## Part 5: Seasonality and Pattern Detection

### Understanding Seasonality

**Seasonality** = predictable patterns that repeat over time

**Nigerian E-commerce Seasonality:**
- **January:** Low (post-holiday slump)
- **March-April:** Moderate (Easter shopping)
- **September:** High (back-to-school)
- **November-December:** Peak (Black Friday, Christmas)

**Brazilian Olist Data Seasonality:**
- **Q4:** Peak (Black Friday, holiday season)
- **January:** Recovery period
- **Mid-year:** Steady demand

### Visualizing Seasonality

#### Method 1: Year-over-Year Overlay

**Chart Setup:**
1. Line chart with monthly data
2. Color/breakdown by year
3. X-axis: Month (1-12)

```
Monthly Revenue Pattern (2017 vs 2018)
₦50M │
     │         ╱╲         2017 (solid)
₦30M │        ╱  ╲        2018 (dashed)
     │   •   /    \   •
₦10M │  / \./      \./ \
     └──────────────────→
     Jan Mar May Jul Sep Nov
```

**Insight:** Both years peak in Nov (Black Friday consistent pattern).

#### Method 2: Heatmap Calendar

**Visual:**
```
Daily Revenue Heatmap 2017
     Jan  Feb  Mar  Apr  May  Jun  Jul  Aug  Sep  Oct  Nov  Dec
W1   🟢   🟡   🟡   🟢   🟡   🟢   🟡   🟢   🟢   🟡   🟢   🔴
W2   🟡   🟡   🟢   🟡   🟡   🟡   🟢   🟡   🟡   🟢   🔴   🔴
W3   🟡   🟡   🟡   🟡   🟢   🟡   🟡   🟡   🟢   🟡   🔴   🔴
W4   🟡   🟡   🟡   🟡   🟡   🟡   🟡   🟢   🟡   🟢   🔴   🔴

🔴 High Revenue  🟢 Medium  🟡 Low
```

**Insight:** November-December hot streak (plan inventory accordingly).

#### Method 3: Day-of-Week Analysis

**Business Question:** "Which days have highest order volume?"

**SQL:**
```sql
SELECT
  TO_CHAR(order_purchase_timestamp, 'Day') as day_name,
  EXTRACT(DOW FROM order_purchase_timestamp) as day_num,
  COUNT(*) as order_count,
  SUM(price) as revenue
FROM olist_orders_dataset
GROUP BY day_name, day_num
ORDER BY day_num;
```

**Looker Chart:**
```
Average Daily Revenue by Day of Week
₦5M ┤           ▓▓  ▓▓
    │       ▓▓  ▓▓  ▓▓  ▓▓
₦3M ┤   ▓▓  ▓▓  ▓▓  ▓▓  ▓▓
    │   ▓▓  ▓▓  ▓▓  ▓▓  ▓▓  ▓▓
₦1M ┤   ▓▓  ▓▓  ▓▓  ▓▓  ▓▓  ▓▓
    └────────────────────────────
    Sun Mon Tue Wed Thu Fri Sat
```

**Insight:** Mid-week peak (Tue-Thu), weekend slower.

---

## Part 6: Annotations and Context

### Why Annotations Matter

**Chart without context:**
```
Revenue spike in November ← Why?
```

**Chart with annotation:**
```
Revenue spike in November ← "Black Friday campaign launched"
```

**Annotations provide:**
- Event explanations (campaigns, holidays)
- Anomaly clarifications (data issues, one-time events)
- Goal markers (targets, milestones)
- Business context for stakeholders

### Adding Annotations in Looker Studio

**Limitation:** Looker Studio doesn't have built-in annotation features (unlike Tableau).

**Workarounds:**

#### Method 1: Text Overlay

1. Insert → Text box
2. Position over relevant chart area
3. Add arrow shape pointing to data point
4. Text: "Black Friday: +150% sales"

**Pros:** Visual and clear
**Cons:** Static (doesn't move with date filters)

#### Method 2: Reference Line

1. Select chart
2. Right panel → **Style** tab
3. Add reference line:

```
Reference Line
─────────────────────────────────────
Type: Metric value
Value: 50000000 (target)
Label: "Monthly Target: ₦50M"
Color: Red dashed line
```

**Pros:** Dynamic (adapts to filters)
**Cons:** Only shows thresholds, not events

#### Method 3: Annotation Table (Creative)

Create a separate table:
```
Event Timeline
─────────────────────────────────────
Date       | Event
─────────────────────────────────────
2017-11-24 | Black Friday Sale
2017-12-15 | Holiday Campaign
2018-01-01 | New Year Promo
```

Place below chart for reference.

#### Method 4: Data Source Annotations (Best)

Add annotations directly in SQL:
```sql
SELECT
  date,
  revenue,
  CASE
    WHEN date = '2017-11-24' THEN 'Black Friday'
    WHEN date = '2017-12-25' THEN 'Christmas'
    ELSE NULL
  END as event_label
FROM daily_revenue;
```

Use `event_label` as tooltip or dimension in chart.

---

## Part 7: Nigerian Business Context Time Series

### Example 1: Holiday Season Analysis

**Nigerian Holidays:**
- January 1: New Year
- March-April: Easter (varies)
- May 1: Workers' Day
- June 12: Democracy Day
- October 1: Independence Day
- December 25-26: Christmas

**Analysis:**
```
Create calculated field: is_holiday
Formula:
CASE
  WHEN MONTH(order_date) = 12 AND DAY(order_date) BETWEEN 20 AND 26 THEN "Christmas Week"
  WHEN MONTH(order_date) = 10 AND DAY(order_date) = 1 THEN "Independence Day"
  WHEN MONTH(order_date) = 1 AND DAY(order_date) = 1 THEN "New Year"
  ELSE "Regular Day"
END
```

**Chart:** Revenue by holiday vs regular days

### Example 2: School Calendar Impact

**Nigerian School Breaks:**
- July-September: Long vacation
- December: Short break

**Expected Patterns:**
- **July-Aug:** Lower office supplies, higher travel/leisure
- **September:** Back-to-school spike (books, uniforms, electronics)
- **December:** Holiday shopping peak

**SQL Analysis:**
```sql
SELECT
  TO_CHAR(order_date, 'Month') as month,
  product_category,
  SUM(price) as revenue
FROM orders
WHERE product_category IN ('books', 'office_supplies', 'electronics')
GROUP BY month, product_category
ORDER BY month;
```

**Looker Chart:** Stacked area showing category mix changes by month.

### Example 3: Currency Fluctuation Context

**Nigerian Context:** Naira exchange rate volatility

**Enhanced Time Series:**
```sql
-- Combine revenue with exchange rate context
SELECT
  order_date,
  SUM(price) as revenue_usd,
  SUM(price) * 1500 as revenue_ngn,  -- Use actual rate table
  avg_exchange_rate  -- From separate rate table
FROM orders
LEFT JOIN exchange_rates ON orders.order_date = exchange_rates.date
GROUP BY order_date, avg_exchange_rate;
```

**Dual-Axis Chart:**
- Left axis: Revenue
- Right axis: Exchange rate
- **Insight:** Revenue dips correlate with Naira weakness

---

## Part 8: Performance Optimization for Time Series

### Challenge: Large Time Series Datasets

**Problem:**
- 2 years of daily data = 730 rows (manageable)
- 2 years of hourly data = 17,520 rows (slow)
- Multiple metrics × multiple dimensions = millions of data points

### Solution 1: Pre-Aggregate in SQL

**Instead of:**
```sql
-- Querying raw data (slow)
SELECT order_purchase_timestamp, price
FROM olist_order_items_dataset
-- Millions of rows
```

**Do:**
```sql
-- Pre-aggregated view (fast)
CREATE VIEW daily_revenue AS
SELECT
  order_purchase_timestamp::date as date,
  SUM(price) as revenue,
  COUNT(*) as order_count
FROM olist_order_items_dataset
GROUP BY order_purchase_timestamp::date;
-- Only 365-730 rows
```

Connect Looker to the view instead of raw table.

### Solution 2: Use Appropriate Granularity

**Dashboard Load Time by Granularity:**
- Hourly (17K points): 8 seconds ❌
- Daily (730 points): 2 seconds ✅
- Weekly (104 points): 0.5 seconds ✅✅
- Monthly (24 points): 0.3 seconds ✅✅✅

**Rule:** Use coarsest granularity that still shows pattern.

### Solution 3: Limit Date Range

Add backend filter in data source:
```sql
WHERE order_purchase_timestamp >= CURRENT_DATE - INTERVAL '2 years'
-- Don't query ancient data
```

### Solution 4: Data Extracts (Looker Studio Pro)

1. Create data extract (cached snapshot)
2. Refresh every 12/24 hours
3. Charts query cache (instant), not database

**Trade-off:** Not real-time, but much faster.

---

## Part 9: Practical Exercise (10 minutes)

### Task: Build a Comprehensive Time Series Dashboard

**Objective:** Analyze Olist revenue trends with comparisons and patterns.

#### Chart 1: Monthly Revenue Trend Line
1. Create line chart
2. Dimension: `YEAR MONTH(order_purchase_timestamp)`
3. Metric: `SUM(price)`
4. Date range: All available data
5. Enable year-over-year comparison

**Success Check:**
- ✅ Clear trend visible
- ✅ Comparison line shows previous year
- ✅ Percentage change displayed

#### Chart 2: Revenue by Day of Week
1. Create bar chart
2. Dimension: `WEEKDAY(order_purchase_timestamp)`
3. Metric: `AVG(price)` (average daily revenue)
4. Sort by day order (Sun-Sat)

**Success Check:**
- ✅ Shows which days are strongest
- ✅ Clear pattern emerges

#### Chart 3: Cumulative Revenue YTD
1. Use pre-calculated cumulative field (from SQL)
2. Area chart
3. Dimension: Date
4. Metric: `cumulative_revenue`
5. Filter: Current year only

**Success Check:**
- ✅ Ascending curve
- ✅ Shows total accumulated value

#### Chart 4: Seasonal Pattern Analysis
1. Line chart
2. Dimension: `MONTH(order_purchase_timestamp)`
3. Breakdown: `YEAR(order_purchase_timestamp)`
4. Metric: `SUM(price)`

**Success Check:**
- ✅ Multiple year lines overlay
- ✅ Seasonal peaks/troughs visible
- ✅ Pattern consistency across years

---

## Key Takeaways

### What You Learned
1. ✅ Time series reveals trends, seasonality, and anomalies
2. ✅ Choose chart types based on analysis goals (line, area, column)
3. ✅ Granularity selection balances detail and clarity
4. ✅ Comparisons (YoY, MoM) provide essential context
5. ✅ Moving averages smooth noise to show true trends
6. ✅ Seasonality patterns inform inventory and marketing planning
7. ✅ Annotations add business context to data
8. ✅ Pre-aggregation optimizes dashboard performance

### Week 14 Complete!

You've now mastered:
- **Part 1:** Interactive controls (date ranges, filters, sliders)
- **Part 2:** Filter relationships and scope configuration
- **Part 3:** Conditional formatting for visual insights
- **Part 4:** Time series analysis and best practices ✓

### What's Next

**Week 15:** Advanced Looker Studio features (blended data, custom themes, embedding)
**Week 16:** Streamlit interactive dashboards (Python-based)
**Phase 2 Project:** Apply all visualization skills to capstone project

---

## Quick Reference Card

### Time Series Chart Selection

| Analysis Goal | Best Chart | Granularity |
|--------------|------------|-------------|
| **Identify trend** | Line chart | Monthly or weekly |
| **Compare periods** | Line with comparison | Match business cycle |
| **Show volume** | Area chart | Daily or weekly |
| **Highlight seasonality** | Multi-year line (by month) | Monthly |
| **Spot anomalies** | Line + moving average | Daily with 7-day MA |
| **Track cumulative** | Area chart (running total) | Daily or weekly |
| **Compare discrete periods** | Column chart | Quarterly or yearly |

### Common Time Calculations (SQL)

```sql
-- Month-over-month growth
LAG(revenue) OVER (ORDER BY month) as prev_month,
(revenue - LAG(revenue) OVER (...)) / LAG(revenue) OVER (...) * 100 as growth_pct

-- Year-over-year comparison
LAG(revenue, 12) OVER (ORDER BY month) as same_month_last_year

-- Moving average (7-day)
AVG(revenue) OVER (ORDER BY date ROWS BETWEEN 6 PRECEDING AND CURRENT ROW)

-- Cumulative sum
SUM(revenue) OVER (ORDER BY date ROWS UNBOUNDED PRECEDING)

-- Extract time components
EXTRACT(YEAR FROM order_date),
EXTRACT(MONTH FROM order_date),
EXTRACT(DOW FROM order_date)  -- Day of week (0=Sunday)
```

---

## Questions to Test Your Understanding

1. When would you use monthly granularity instead of daily for a time series?
2. What's the difference between period-over-period and year-over-year comparison?
3. Why are moving averages useful for trend analysis?
4. How does seasonality affect inventory planning?
5. What causes slow time series chart performance and how can you fix it?

**Answers at the end of lecture notes**

---

## Additional Resources

- **Looker Studio Help:** [Date and Time Functions](https://support.google.com/looker-studio/table/6379764)
- **SQL Date Functions:** PostgreSQL Date/Time Documentation
- **Case Study:** Seasonal Analysis in E-commerce (resources/)
- **Template:** Time Series Dashboard Best Practices (templates/)

---

## Answers to Questions

1. Use **monthly granularity** when viewing long periods (1+ years) to reduce noise and show clear trends; daily is better for short-term (1-3 months) monitoring
2. **Period-over-period** compares sequential periods (this month vs last month) to detect immediate changes; **year-over-year** compares same period across years to account for seasonality
3. **Moving averages** smooth out daily volatility (noise) to reveal underlying trends, making it easier to see if metrics are truly rising or falling
4. **Seasonality** shows when demand peaks (e.g., December holidays, back-to-school), allowing businesses to stock up in advance and avoid stockouts during high-demand periods
5. **Slow performance** caused by high granularity (hourly) and large datasets; fix by using pre-aggregated views, appropriate granularity (monthly/weekly), and backend date filters (last 2 years only)

---

## Congratulations!

You've completed **Week 14: Interactive Dashboards** and are now equipped to build professional, data-driven dashboards that stakeholders can explore independently. These skills directly prepare you for the **Phase 2 Capstone Project** where you'll build a complete analytics solution.

**Next Session:** Thursday - Advanced dashboard design and SQL integration strategies

---

**End of Week 14 Wednesday Lecture Series**
