# Performance Optimization Checklist

**Week 14 Thursday - Resource Guide**
**Purpose:** Step-by-step checklist for optimizing Looker Studio dashboard performance

---

## Table of Contents

1. [Performance Benchmarks](#performance-benchmarks)
2. [Quick Wins (15 Minutes)](#quick-wins-15-minutes)
3. [Data Source Optimization](#data-source-optimization)
4. [Query Optimization](#query-optimization)
5. [Chart Optimization](#chart-optimization)
6. [Mobile Optimization](#mobile-optimization)
7. [Troubleshooting Slow Dashboards](#troubleshooting-slow-dashboards)

---

## Performance Benchmarks

### Target Load Times

**Desktop Performance:**
```
Excellent:  < 3 seconds total load time
Good:       3-5 seconds
Acceptable: 5-8 seconds
Needs Work: 8-12 seconds
Unacceptable: > 12 seconds
```

**Mobile Performance:**
```
Excellent:  < 4 seconds
Good:       4-6 seconds
Acceptable: 6-10 seconds
Needs Work: > 10 seconds
```

**Component-Level Benchmarks:**
```
Data Source Connection: < 1 second
Query Execution (per chart): < 500ms
Chart Rendering: < 200ms per chart
Page Navigation: < 1 second
Filter Application: < 2 seconds
```

---

### How to Measure Performance

**Method 1: Browser DevTools (Most Accurate)**

```
1. Open Chrome DevTools (F12)
2. Go to "Network" tab
3. Check "Disable cache"
4. Refresh dashboard
5. Look at bottom status bar:
   - "Load: X.XX s" ← This is your total load time
   - "DOMContentLoaded: X.XX s" ← Time to interactive
6. Filter by "XHR" to see data queries
   - Each row = one query
   - "Time" column = query duration
```

**Method 2: Looker Studio Performance Panel**

```
Edit mode → View → Show performance
  - See query times per chart
  - Identify slowest charts
  - Track before/after optimization
```

**Method 3: Perceived Load Time (User Experience)**

```
1. Clear cache
2. Open dashboard in incognito window
3. Start timer when clicking link
4. Stop when all charts fully loaded
5. This is real user experience time
```

---

## Quick Wins (15 Minutes)

These optimizations provide immediate performance improvements with minimal effort.

### Quick Win #1: Enable Data Extract (5 minutes)

**Impact:** 40-70% faster load times

**Steps:**
```
1. Data Source → Edit Connection
2. Find "Data Freshness" section
3. Select "Extract Data"
4. Configure:
   - Refresh: Daily (or appropriate frequency)
   - Time: Off-peak hours (e.g., 2 AM)
5. Click "Extract Data"
6. Wait 2-5 minutes for initial extract
7. Replace live connection with extract in dashboard
```

**Before:** Every dashboard view queries database
**After:** Dashboard reads cached data (only refreshes daily)

---

### Quick Win #2: Enable Query Caching (2 minutes)

**Impact:** 50-80% faster for repeat viewers

**Steps:**
```
1. Data Source → Advanced Settings
2. Query Caching: Enable
3. Cache Duration: 12 hours (adjust based on data freshness needs)
4. Save
```

**How It Works:**
- First viewer: Queries database, caches result
- Next viewers (within 12 hours): Read cache (instant)
- After 12 hours: Cache expires, next viewer triggers refresh

---

### Quick Win #3: Reduce Date Range Default (2 minutes)

**Impact:** 30-50% faster queries (especially on large datasets)

**Steps:**
```
1. Find date range filter control
2. Change default: "All time" → "Last 12 months" or "Last 90 days"
3. Apply to all pages
```

**Why:** Smaller date range = fewer rows scanned = faster queries

**Example:**
- All time (5 years): 500,000 rows → 8 seconds
- Last 12 months: 100,000 rows → 3 seconds
- Last 90 days: 25,000 rows → 1 second

---

### Quick Win #4: Remove Unused Charts (5 minutes)

**Impact:** 10-20% faster per chart removed

**Steps:**
```
1. Identify charts that:
   - Provide redundant information
   - Are rarely viewed
   - Have low stakeholder value
2. Delete or move to separate "Details" page
3. Target: Max 8 charts per page
```

**Before:** 15 charts on one page = 12 seconds load
**After:** 8 charts on one page = 6 seconds load

---

### Quick Win #5: Apply Filters at Data Source Level (1 minute)

**Impact:** 20-30% faster queries

**Steps:**
```
1. Data Source → Filter tab
2. Add common filters here (instead of on each chart):
   - order_status = 'delivered'
   - customer_state IS NOT NULL
   - order_date >= 2023-01-01
3. Remove these filters from individual charts
```

**Why:** Filter applied once at source vs. 15 times per chart

---

## Data Source Optimization

### Optimization #1: Use Extracts Over Live Connections

**When to Use Extract:**
- ✓ Data updates daily or less frequently
- ✓ Dataset < 500,000 rows
- ✓ Dashboard has many viewers (>10 people)
- ✓ Database is slow or far away

**When to Keep Live Connection:**
- ✓ Need real-time data (updates every few minutes)
- ✓ Dataset > 1 million rows (extract may fail)
- ✓ Data changes constantly
- ✓ Require up-to-the-second accuracy

**Extract Configuration Best Practices:**
```
Refresh Frequency:
  - Transactional data: Daily
  - Marketing data: Hourly
  - Static reference data: Weekly

Refresh Time:
  - Choose off-peak hours (2-4 AM)
  - Avoid business hours (9 AM - 5 PM)
  - Consider timezone (WAT for Nigerian users)

Row Limit:
  - Set reasonable limit (100,000 - 500,000)
  - Use date filters to limit scope
  - Archive old data if needed

Incremental Refresh:
  - Enable if dataset very large (>500K rows)
  - Use date field for incremental updates
  - Only refreshes new/changed rows (faster)
```

---

### Optimization #2: Pre-Aggregate Data in Database

**Problem:** Looker calculates aggregations on every query

**Solution:** Create database views with pre-calculated metrics

**Example: Customer RFM View**

```sql
-- Instead of calculating in Looker every time:
CREATE MATERIALIZED VIEW customer_rfm_summary AS
SELECT
  customer_id,
  customer_state,

  -- Pre-calculated RFM metrics
  DATE_PART('day', CURRENT_DATE - MAX(order_date)) AS recency_days,
  COUNT(DISTINCT order_id) AS frequency,
  SUM(order_value) AS monetary,

  -- Pre-calculated segment
  CASE
    WHEN DATE_PART('day', CURRENT_DATE - MAX(order_date)) <= 90
         AND COUNT(DISTINCT order_id) >= 3
         AND SUM(order_value) >= 500
    THEN 'Champions'
    WHEN DATE_PART('day', CURRENT_DATE - MAX(order_date)) <= 90
         AND COUNT(DISTINCT order_id) >= 2
    THEN 'Loyal'
    -- ... other segments
  END AS customer_segment,

  -- Pre-calculated flags
  MAX(order_date) AS last_order_date,
  MIN(order_date) AS first_order_date
FROM orders
WHERE order_status = 'delivered'
GROUP BY customer_id, customer_state;

-- Refresh daily
REFRESH MATERIALIZED VIEW customer_rfm_summary;
```

**In Looker:** Connect to `customer_rfm_summary` view, use pre-calculated fields directly

**Performance Impact:**
- Before (live calculation): 800ms per chart
- After (pre-aggregated): 50ms per chart (16× faster!)

---

### Optimization #3: Optimize Table Joins

**Problem:** Joining 4-5 tables on every query slows performance

**Solutions:**

**Option A: Create Denormalized View**
```sql
-- Combine common joins into single view
CREATE VIEW orders_denormalized AS
SELECT
  o.order_id,
  o.order_date,
  o.order_status,
  c.customer_id,
  c.customer_state,
  c.customer_city,
  p.payment_value,
  p.payment_type,
  i.product_id,
  i.price,
  i.freight_value
FROM orders o
LEFT JOIN customers c ON o.customer_id = c.customer_id
LEFT JOIN order_payments p ON o.order_id = p.order_id
LEFT JOIN order_items i ON o.order_id = i.order_id;
```

**In Looker:** Connect to single denormalized view (no joins needed)

**Option B: Limit Join Complexity**
- Only join tables actually needed for dashboard
- Remove unused columns from SELECT
- Use INNER JOIN instead of LEFT JOIN when possible (faster)

---

## Query Optimization

### Optimization #1: Simplify Calculated Fields

**Problem:** Complex calculated fields with nested aggregations

**Before (Slow):**
```
Field: High-Value Customer Flag
Formula:
  CASE
    WHEN SUM(payment_value) > AVG(SUM(payment_value))
    THEN "High Value"
    ELSE "Normal Value"
  END

Issue: Nested aggregation (SUM inside AVG) recalculates on every query
Time: 1,200ms per chart
```

**After (Fast) - Method 1: Separate Fields**
```
Field 1: Total Spend
Formula: SUM(payment_value)

Field 2: Average Customer Spend
Formula: AVG(Total_Spend)
  (Create as separate calculated field at data source level)

Field 3: High-Value Customer Flag
Formula:
  IF(Total_Spend > Average_Customer_Spend, "High Value", "Normal Value")

Time: 200ms per chart (6× faster)
```

**After (Fastest) - Method 2: Database Calculation**
```sql
-- Add to database view
CASE
  WHEN customer_total_spend > (
    SELECT AVG(customer_total_spend) FROM customer_summary
  )
  THEN 'High Value'
  ELSE 'Normal Value'
END AS customer_value_tier
```

---

### Optimization #2: Reduce Data Volume

**Strategy 1: Filter Early**
```
Bad: Pull all data → Filter in Looker
  - Queries 500,000 rows
  - Filters to 50,000 rows
  - Wastes 450,000 rows of transfer

Good: Filter at data source
  - Queries only needed 50,000 rows
  - 10× less data transfer
  - Faster query execution
```

**Strategy 2: Use Sampling for Exploratory Dashboards**
```sql
-- For very large datasets (>1M rows), sample data
SELECT *
FROM orders
WHERE order_status = 'delivered'
  AND order_date >= CURRENT_DATE - INTERVAL '12 months'
  AND MOD(ABS(HASH(order_id)), 100) < 10  -- 10% sample
```

**When to Sample:**
- ✓ Exploratory analysis (trends, patterns)
- ✓ Testing dashboard layout
- ✓ Dataset > 1 million rows
- ✗ Executive reports (need accuracy)
- ✗ Financial dashboards (need exactness)

**Strategy 3: Aggregate at Higher Granularity**
```
Daily data: 365 rows/year (detailed)
Weekly data: 52 rows/year (faster)
Monthly data: 12 rows/year (fastest)

For trend charts:
  - Use monthly aggregation (not daily)
  - Reduces data points by 30×
  - Chart still shows clear trends
```

---

### Optimization #3: Limit Row Returns

**Set row limits on all charts:**

```
Scorecards: 1 row (always)
Bar Charts: 10-20 rows (top N)
Tables: 50-100 rows max (paginate if needed)
Scatter Plots: 500-1,000 points (more = unreadable)
Line Charts: 12-24 data points (monthly for 1-2 years)
```

**Implementation:**
```
Each chart → Data panel → Rows to Display
  - Set appropriate limit
  - Default: 100 (often too high)
  - Recommended: Minimum needed for insight
```

**Example:**
- Before: Table shows all 10,000 customers (8 seconds load)
- After: Table shows top 50 customers (1 second load)
- User can still export full data if needed

---

## Chart Optimization

### Optimization #1: Choose Efficient Chart Types

**Chart Performance Ranking (Fastest to Slowest):**

```
1. Scorecard (single value)           → ~50ms
2. Bar Chart (simple)                  → ~100ms
3. Line Chart                          → ~150ms
4. Pie/Donut Chart                     → ~200ms
5. Table (< 100 rows)                  → ~300ms
6. Scatter Plot (< 500 points)         → ~500ms
7. Geo Map (state level)               → ~800ms
8. Pivot Table                         → ~1,000ms
9. Treemap                             → ~1,200ms
10. Geo Map (bubble, many points)      → ~2,000ms
11. Sankey Diagram                     → ~3,000ms
12. Table (> 1,000 rows)               → ~5,000ms
```

**Optimization Strategy:**
- Replace slow chart types with faster alternatives when possible
- Example: Bubble geo map (2s) → Filled geo map (800ms) → Bar chart (100ms)

---

### Optimization #2: Reduce Chart Complexity

**Simplification Strategies:**

**Time Series Charts:**
```
Before: Daily data for 2 years (730 points) → Slow, cluttered
After: Weekly data for 2 years (104 points) → Fast, clear

Before: 10 lines on one chart → Confusing, slow
After: 3 lines on chart, others on separate chart → Clear, fast
```

**Tables:**
```
Before: 15 columns, 500 rows → 7,500 cells to render
After: 5 columns, 50 rows → 250 cells to render (30× faster)
```

**Scatter Plots:**
```
Before: 10,000 data points → Unreadable, slow (3 seconds)
After: 500 data points (sample or filter) → Clear, fast (400ms)
```

---

### Optimization #3: Conditional Chart Loading

**Strategy:** Only load charts when visible

**Implementation:**
```
Use multi-page dashboards:
  - Page 1: Overview (6 charts)
  - Page 2: Details (6 charts)
  - Page 3: Deep-dive (6 charts)

Only loads current page (6 charts) instead of all 18 charts at once

Performance Impact:
  - Before (single page): 18 charts = 12 seconds
  - After (3 pages): 6 charts per page = 4 seconds per page
```

---

## Mobile Optimization

### Mobile-Specific Performance Checklist

**Network Considerations:**
```
Mobile networks slower than WiFi:
  - 4G: 5-12 Mbps download (vs 50+ Mbps WiFi)
  - 3G: 0.5-5 Mbps (common in rural Nigeria)
  - High latency: 50-200ms (vs 10-30ms WiFi)

Optimization: Reduce data transfer
  - Use extracts (cached data)
  - Compress images
  - Limit charts (max 5 per page on mobile)
  - Simplify visuals (remove gradients, shadows)
```

**Mobile-Specific Optimizations:**
```
1. Reduce Chart Count:
   Desktop: 8 charts → Mobile: 4 charts
   Show only essential metrics

2. Simplify Tables:
   Desktop: 7 columns → Mobile: 3 columns
   Hide non-critical columns

3. Lower Chart Resolution:
   Desktop: 1600px wide → Mobile: 375px wide
   Less pixels to render = faster

4. Remove Heavy Charts:
   Desktop: Geo map, scatter plot → Mobile: Simple bar charts
   Replace with lighter alternatives

5. Lazy Loading:
   Load charts as user scrolls (not all at once)
   Reduces initial load time
```

---

## Troubleshooting Slow Dashboards

### Diagnostic Process

**Step 1: Identify the Bottleneck**

Run this diagnostic:
```
1. Open DevTools → Network tab
2. Refresh dashboard
3. Look at timing:
   - If most time in "Waiting": Database query slow
   - If most time in "Content Download": Large data transfer
   - If most time in "Rendering": Too many charts/complexity

4. Identify slowest chart:
   - Looker Edit Mode → View → Show Performance
   - Sort by query time
   - Focus optimization on slowest chart first
```

---

### Common Slow Dashboard Causes & Fixes

**Problem 1: Live Connection to Slow Database**

**Symptoms:**
- "Waiting" time > 5 seconds per chart
- Slow even with few charts
- Faster on first load, then slower (no caching)

**Solution:**
```
✓ Switch to data extract
✓ Enable query caching
✓ Optimize database (add indexes on joined columns)
✓ Use database views (pre-aggregated data)
```

---

**Problem 2: Too Many Charts**

**Symptoms:**
- Many charts (12+) on single page
- Each chart fast individually, but combined slow
- Long "Rendering" time

**Solution:**
```
✓ Split into multiple pages (max 8 charts/page)
✓ Remove redundant charts
✓ Combine related charts (e.g., multiple scorecards into one)
✓ Use tabs/page navigation
```

---

**Problem 3: Complex Calculated Fields**

**Symptoms:**
- Specific charts very slow (>2 seconds)
- Charts with calculated fields slower than simple charts
- High CPU usage during load

**Solution:**
```
✓ Simplify formulas (remove nested aggregations)
✓ Move calculations to database (views)
✓ Break complex fields into multiple simple fields
✓ Pre-aggregate in data source
```

---

**Problem 4: Large Data Volume**

**Symptoms:**
- "Content Download" time > 3 seconds
- MB of data transferred (check Network tab size)
- Slow even with extracts

**Solution:**
```
✓ Filter data at source (reduce date range)
✓ Limit rows returned (top 10, not all)
✓ Aggregate at higher level (weekly vs daily)
✓ Sample data (10% sample for large datasets)
```

---

**Problem 5: Inefficient Chart Types**

**Symptoms:**
- Geo maps, Sankey diagrams taking 3+ seconds each
- Charts with 1,000+ data points

**Solution:**
```
✓ Replace with simpler chart types:
  - Bubble geo map → Filled geo map or Bar chart
  - Sankey → Stacked bar chart
  - Scatter (10K points) → Scatter (500 points)
✓ Reduce data granularity
```

---

**Problem 6: No Caching**

**Symptoms:**
- Same speed every time (not faster on reload)
- Many viewers but no performance improvement

**Solution:**
```
✓ Enable query caching (12-hour duration)
✓ Use data extracts (cached at source)
✓ Enable browser caching (check headers)
```

---

## Performance Optimization Workflow

### Step-by-Step Optimization Process

**Phase 1: Measure Baseline (5 minutes)**
```
1. Clear browser cache
2. Open dashboard in incognito window
3. Measure load time (DevTools)
4. Document:
   - Total load time: _____ seconds
   - Slowest chart: _____ (name)
   - Slowest chart time: _____ seconds
   - Data transfer size: _____ MB
```

**Phase 2: Quick Wins (15 minutes)**
```
1. Enable data extract (if not already)
2. Enable query caching
3. Apply filters at data source level
4. Remove unused charts
5. Reduce default date range
```

**Phase 3: Measure Improvement (5 minutes)**
```
Repeat Phase 1 measurement
Calculate improvement:
  - Before: _____ seconds
  - After: _____ seconds
  - Improvement: _____ % faster

Target: 40%+ improvement from quick wins
```

**Phase 4: Advanced Optimization (30 minutes)**
```
If still not meeting targets (<5 seconds):
1. Optimize calculated fields
2. Create database views
3. Simplify complex charts
4. Split into multiple pages
5. Implement mobile optimization
```

**Phase 5: Monitor Ongoing (Weekly)**
```
Set up monitoring:
  - Weekly check: Dashboard load time
  - Track: Number of viewers, usage patterns
  - Alert: If load time > 8 seconds
  - Review: Quarterly optimization review
```

---

## Performance Checklist (Copy This!)

### Pre-Launch Performance Checklist

**Data Source:**
- [ ] Data extract enabled (not live connection)
- [ ] Extract refresh schedule configured (daily/hourly)
- [ ] Query caching enabled (12-hour duration)
- [ ] Filters applied at data source level (not chart level)
- [ ] Unused tables removed from data source
- [ ] Row limits set on data source (if applicable)

**Calculated Fields:**
- [ ] No nested aggregations (SUM inside AVG)
- [ ] Complex calculations moved to database views
- [ ] Calculated fields optimized (simplified formulas)
- [ ] Unused calculated fields removed

**Charts:**
- [ ] Chart count: ≤ 8 per page
- [ ] Row limits set on all charts (scorecards: 1, tables: ≤100, etc.)
- [ ] Efficient chart types used (avoid Sankey, complex geo maps)
- [ ] No charts pulling >10,000 rows
- [ ] Slow charts replaced with faster alternatives

**Layout:**
- [ ] Multi-page dashboard (if >10 charts total)
- [ ] Page navigation functional
- [ ] Charts load only when page active (not all at once)

**Mobile:**
- [ ] Mobile layout configured
- [ ] Mobile chart count reduced (≤5 per page)
- [ ] Tables simplified for mobile (≤3 columns)
- [ ] Heavy charts removed on mobile version

**Performance:**
- [ ] Desktop load time: <5 seconds
- [ ] Mobile load time: <6 seconds
- [ ] Individual chart load: <500ms
- [ ] Filter application: <2 seconds
- [ ] Data transfer: <5 MB total

**Monitoring:**
- [ ] Performance baseline documented
- [ ] Weekly monitoring scheduled
- [ ] Alert threshold set (>8 seconds = investigate)
- [ ] Optimization review scheduled (quarterly)

---

## Performance Targets by Dashboard Type

**Executive Dashboard:**
```
Target: < 3 seconds
Charts: 4-6
Data: Highly aggregated (monthly summaries)
Refresh: Daily
Users: 5-10 executives
```

**Operational Dashboard:**
```
Target: < 5 seconds
Charts: 6-10
Data: Moderate aggregation (daily summaries)
Refresh: Hourly
Users: 20-50 managers
```

**Analytical Dashboard:**
```
Target: < 8 seconds (acceptable for complexity)
Charts: 10-15
Data: Detailed (row-level when needed)
Refresh: Daily or on-demand
Users: 5-10 analysts
```

**Public Dashboard:**
```
Target: < 4 seconds
Charts: 4-8
Data: Highly aggregated, cached
Refresh: Daily
Users: 100+ (unknown network conditions)
```

---

## Emergency Performance Fixes

**If dashboard is critically slow (>20 seconds) and needs immediate fix:**

**1-Minute Fix:**
```
Temporarily reduce date range filter to "Last 30 Days"
  → Usually 50-70% faster immediately
```

**5-Minute Fix:**
```
Delete half the charts
  → Move to separate "Details" page
  → Re-publish dashboard
```

**15-Minute Fix:**
```
Create data extract with aggressive filters:
  - Last 6 months only
  - Top 1,000 customers only
  - Delivered orders only
Replace live connection with this extract
```

**30-Minute Fix:**
```
Create simplified dashboard version:
  - Single page
  - 4 charts only (most critical metrics)
  - Highly aggregated data
  - Share this as "Quick View" dashboard
  - Keep original as "Detailed View"
```

---

## Additional Resources

**Looker Studio Performance Guides:**
- Official Docs: support.google.com/datastudio → "Performance best practices"
- Community Forum: Looker Studio Community (search "performance")

**Database Optimization:**
- PostgreSQL: EXPLAIN ANALYZE query plans
- BigQuery: Query execution details
- Index optimization guides

**Monitoring Tools:**
- Google PageSpeed Insights (for embedded dashboards)
- Browser DevTools (Network and Performance tabs)
- Looker Studio built-in performance panel

---

**Remember:** Performance optimization is iterative. Start with quick wins, measure improvement, then tackle advanced optimizations if needed. A 40% improvement is good; 70%+ is excellent.

**Pro Tip:** Optimize for your 90th percentile user (not the best case). If 90% of users load in <5 seconds, you're doing well. Don't over-optimize for the 1% with poor internet.

---

**Last Updated:** January 31, 2026
**Version:** 1.0
