# Performance Optimization - Fast-Loading Dashboards

**Week 14 - Thursday Session | Part 3 (15 minutes)**
**Business Context:** Creating dashboards that load quickly even on slow Nigerian internet connections

---

## Learning Objectives

By the end of this section, you will be able to:
- Identify dashboard performance bottlenecks
- Implement data caching strategies
- Optimize queries for faster loading
- Reduce dashboard complexity without losing insights
- Apply connection optimization techniques
- Monitor dashboard performance metrics
- Design for Nigerian internet conditions (inconsistent connectivity)

---

## Why Dashboard Performance Matters

### The 3-Second Rule

**Research Finding:** If a webpage takes more than 3 seconds to load, 40% of users abandon it

**Dashboard Reality:**
- **Under 2 seconds:** Excellent (users feel instant response)
- **2-5 seconds:** Acceptable (users notice slight delay)
- **5-10 seconds:** Poor (users get impatient)
- **Over 10 seconds:** Unacceptable (users close dashboard, don't return)

**Nigerian Internet Context:**
- Average mobile speed: 10-30 Mbps (varies by location and time)
- Inconsistent connectivity (drops, slowdowns)
- Data costs (users avoid heavy dashboards)
- Many users on 3G/4G (not broadband)

**Impact:**
```
Slow Dashboard → Users Don't Wait → Insights Not Seen → Bad Decisions
Fast Dashboard → Users Engage → Insights Discovered → Better Decisions
```

---

## Performance Bottlenecks in Dashboards

### Bottleneck 1: Too Many Charts (Query Overload)

**Problem:** Dashboard with 20 charts

**What Happens:**
- Each chart = separate database query
- 20 charts = 20 queries running when page loads
- Queries run in parallel, but limited by database connection pool
- Total load time = slowest query time

**Example Timing:**
```
Chart 1: Revenue scorecard         → 0.3 seconds
Chart 2: Orders scorecard          → 0.2 seconds
Chart 3: Monthly trend             → 1.5 seconds
Chart 4: Category breakdown        → 2.1 seconds
...
Chart 20: Detailed table           → 4.8 seconds (slowest)
                                     ▔▔▔▔▔▔▔▔▔▔
Total Load Time: 4.8 seconds (waiting for slowest chart)
```

**Solution:** Reduce to 6-8 charts per page, use multi-page dashboard

---

### Bottleneck 2: Complex Queries (Slow SQL)

**Problem:** Query does heavy computation

**Slow Query Examples:**
- Joining 5+ tables
- Calculating complex metrics (cohort analysis, retention rates)
- Aggregating millions of rows without indexes
- Using subqueries or window functions inefficiently

**Nigerian E-Commerce Example:**

**Slow Query (3.2 seconds):**
```sql
-- Calculate customer lifetime value on the fly
SELECT
    customer_id,
    customer_name,
    COUNT(DISTINCT order_id) as total_orders,
    SUM(order_value) as lifetime_value,
    AVG(order_value) as avg_order_value,
    MAX(order_date) as last_order_date,
    MIN(order_date) as first_order_date,
    DATEDIFF(MAX(order_date), MIN(order_date)) as customer_age_days
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
WHERE order_date >= '2024-01-01'
GROUP BY customer_id, customer_name
ORDER BY lifetime_value DESC
LIMIT 100;
```

**Why Slow:**
- 3 joins across large tables
- Multiple aggregations (COUNT, SUM, AVG, MAX, MIN)
- Calculated on every dashboard load

**Fast Query (0.4 seconds):**
```sql
-- Pre-calculated in customer_metrics materialized view
SELECT
    customer_id,
    customer_name,
    total_orders,
    lifetime_value,
    avg_order_value,
    last_order_date,
    first_order_date,
    customer_age_days
FROM customer_metrics_view
WHERE last_order_date >= '2024-01-01'
ORDER BY lifetime_value DESC
LIMIT 100;
```

**Why Fast:**
- Metrics pre-calculated and stored (no joins needed)
- Simple SELECT from single view
- Database can use indexes

**Reference Week 11 SQL Optimization:**
- Index usage and query planning
- Efficient JOIN strategies
- Query rewriting for performance
- Materialized views for complex aggregations

---

### Bottleneck 3: Large Datasets (Too Much Data)

**Problem:** Chart trying to display 100,000 data points

**What Happens:**
- Database sends 100,000 rows to Looker Studio
- Browser struggles to render 100,000 points
- Network transfer takes time (especially on mobile)
- Chart becomes unreadable anyway (too cluttered)

**Example:**
```
Time Series Chart: Daily Revenue for 10 Years
= 365 days × 10 years = 3,650 data points

Reality: Human eye can only distinguish ~50-100 points on a chart
Solution: Aggregate to monthly instead (120 points)
```

**Row Limits by Chart Type:**

| Chart Type | Recommended Max Rows | Reason |
|------------|---------------------|--------|
| Scorecard | 1 (single metric) | Simple aggregation |
| Time Series | 50-100 points | Visual clarity |
| Bar Chart | 10-15 bars | Readability |
| Pie Chart | 5-7 slices | Distinguishability |
| Table | 100-500 rows | Scrollability |
| Geo Map | 50-100 regions | Performance |

---

### Bottleneck 4: No Data Caching (Repeated Queries)

**Problem:** Dashboard re-queries database on every view

**Scenario:**
- CEO views dashboard at 9:00 AM → Query runs (takes 2 seconds)
- CEO refreshes at 9:05 AM → Same query runs again (another 2 seconds)
- Operations Manager views at 9:10 AM → Same query runs again (2 seconds)

**Result:** Database hit 3 times for same data in 10 minutes

**Solution:** Enable caching (next section)

---

## Performance Optimization Strategies

### Strategy 1: Data Source Caching

**How It Works:**
- Looker Studio stores query results temporarily
- Subsequent viewers get cached data (no database query)
- Cache expires after set duration
- Fresh queries only when cache expired

**Enable Data Caching:**
1. **Resource** → **Manage added data sources**
2. Select your data source
3. Click **Edit** (pencil icon)
4. **Data Freshness** section
5. Choose cache duration:
   - **Every 15 minutes** (near real-time, but more queries)
   - **Every hour** (good balance)
   - **Every 4 hours** (slow-changing data)
   - **Every 12 hours** (daily reports)

**Nigerian Business Recommendations:**

| Dashboard Type | Recommended Cache | Reasoning |
|----------------|------------------|-----------|
| Real-time monitoring (e.g., website traffic) | 15 minutes | Data changes rapidly |
| Daily sales dashboard | 1 hour | Hourly updates sufficient |
| Weekly performance report | 4 hours | Reviewed few times per day |
| Monthly financial report | 12 hours | Static after month-end |
| Annual strategy dashboard | 24 hours | Rarely changes |

**Example Impact:**
```
Without Caching:
- 100 users view dashboard daily
- Each view triggers query (2 seconds)
- Total: 100 queries × 2 sec = 200 seconds of database load

With 1-Hour Caching:
- 100 users view dashboard daily
- Only 24 fresh queries (once per hour)
- Total: 24 queries × 2 sec = 48 seconds of database load
- Savings: 76% reduction in database load
```

---

### Strategy 2: Query Optimization

**Technique 1: Use Database Views**

**Instead of:** Complex query in Looker Studio
**Do this:** Create database view with pre-calculated metrics

**Example:**

**Database View (Created Once):**
```sql
CREATE VIEW daily_sales_summary AS
SELECT
    DATE(order_date) as sale_date,
    COUNT(order_id) as total_orders,
    SUM(order_value) as total_revenue,
    AVG(order_value) as avg_order_value,
    COUNT(DISTINCT customer_id) as unique_customers
FROM orders
WHERE order_status = 'completed'
GROUP BY DATE(order_date);
```

**Looker Studio Query (Simple and Fast):**
```sql
SELECT * FROM daily_sales_summary
WHERE sale_date >= CURRENT_DATE - INTERVAL 30 DAY
ORDER BY sale_date;
```

**Performance Gain:** 5× faster (typical)

---

**Technique 2: Add Indexes to Database**

**Recall Week 11 SQL Optimization:**

**Problem:** Query scans entire table
```sql
SELECT * FROM orders
WHERE customer_id = 12345;

-- Without index: Scans all 1 million rows (slow)
```

**Solution:** Add index
```sql
CREATE INDEX idx_customer_id ON orders(customer_id);

-- With index: Direct lookup (fast)
```

**Common Indexes for Dashboards:**
```sql
-- Date filters (most common in dashboards)
CREATE INDEX idx_order_date ON orders(order_date);

-- Geographic filters
CREATE INDEX idx_customer_state ON customers(state);

-- Category filters
CREATE INDEX idx_product_category ON products(category);

-- Foreign keys (for joins)
CREATE INDEX idx_order_customer ON orders(customer_id);
CREATE INDEX idx_order_item_product ON order_items(product_id);
```

**Performance Gain:** 10-100× faster for filtered queries

---

**Technique 3: Limit Date Ranges**

**Problem:** Query retrieves 10 years of data

**Solution:** Default to recent data (last 30 days, 90 days)

**Implementation:**
1. Add date filter with smart default
2. Set default to "Last 30 days" (not "All time")
3. Users can expand if needed

**Example:**
```sql
-- Slow: All historical data
SELECT * FROM orders;

-- Fast: Recent data only
SELECT * FROM orders
WHERE order_date >= CURRENT_DATE - INTERVAL 30 DAY;
```

**Performance Gain:** Proportional to data reduction (30 days vs 10 years = 100× smaller dataset)

---

### Strategy 3: Reduce Dashboard Complexity

**Technique 1: Chart Reduction**

**Audit Your Dashboard:**
1. List all charts
2. For each chart ask: "Would anyone notice if this was gone?"
3. Remove charts that answer "no"

**Example Audit:**

| Chart | Essential? | Action |
|-------|-----------|--------|
| Revenue scorecard | YES (primary KPI) | Keep |
| Order count | YES (primary KPI) | Keep |
| Monthly revenue trend | YES (main analysis) | Keep |
| Revenue by category | YES (key insight) | Keep |
| Revenue by payment method | MAYBE (secondary) | Keep, move to Page 2 |
| Revenue by hour of day | NO (rarely used) | Remove or Page 3 |
| Revenue by day of week | NO (rarely used) | Remove or Page 3 |
| Revenue by customer age | NO (rarely used) | Remove or Page 3 |

**Result:** Reduce from 8 charts to 5 on main page

---

**Technique 2: Aggregate Before Visualizing**

**Problem:** Chart gets 10,000 rows, displays 10 bars

**What Happens:**
- Database sends 10,000 rows
- Looker Studio aggregates to 10 categories
- Wasted network transfer (9,990 extra rows)

**Solution:** Aggregate in database query

**Bad (Sends 10,000 Rows):**
```sql
SELECT product_name, order_value
FROM order_items
WHERE order_date >= '2025-01-01';
```
*Looker Studio aggregates: SUM(order_value) by product_name*

**Good (Sends 10 Rows):**
```sql
SELECT
    product_name,
    SUM(order_value) as total_revenue
FROM order_items
WHERE order_date >= '2025-01-01'
GROUP BY product_name
ORDER BY total_revenue DESC
LIMIT 10;
```
*Pre-aggregated and limited to top 10*

**Performance Gain:** 1000× less data transferred

---

**Technique 3: Lazy Loading (Multi-Page Strategy)**

**Concept:** Only load data when page is viewed

**Single Page Dashboard (All Load at Once):**
- Page 1 loads: Charts 1-20 all query database
- Load time: 5 seconds
- User only looks at Charts 1-5 (wasted 15 queries)

**Multi-Page Dashboard (Progressive Loading):**
- Page 1 loads: Charts 1-5 query database (2 seconds)
- User views, then navigates to Page 2
- Page 2 loads: Charts 6-10 query database (1 second)
- Page 3 never visited = Charts 11-15 never loaded

**Result:** 50% faster perceived performance

---

### Strategy 4: Optimize Data Source Connection

**Data Source Options by Speed:**

| Connection Type | Speed | Use Case | Cache? |
|----------------|-------|----------|--------|
| **Extracted Data** | Fastest | Static reports, snapshots | Built-in |
| **Google Sheets** | Fast | Small datasets (<10K rows) | Yes (15 min) |
| **BigQuery** | Fast-Medium | Large datasets (millions of rows) | Yes (configurable) |
| **Direct SQL** | Medium-Slow | Live database connections | Yes (configurable) |
| **API Connector** | Slow | External APIs (rate limits) | Yes (required) |

---

**Optimization: Use Data Extracts**

**What It Is:** Copy database data to Looker Studio storage

**How It Works:**
1. One-time query to database (extracts all data)
2. Data stored in Looker Studio
3. All charts query extract (not database)
4. Extract refreshes on schedule (daily, weekly)

**Enable Extract:**
1. **Resource** → **Manage added data sources**
2. Select data source → **Edit**
3. **Data Freshness** → **Enable data extract**
4. Set refresh schedule (e.g., daily at 6:00 AM)

**Performance Gain:** 5-10× faster (no database queries)

**Trade-off:** Data not real-time (acceptable for daily reports)

**Nigerian Business Example:**
- **Month-End Report:** Extract refreshes once after month closes
- **Daily Sales Dashboard:** Extract refreshes at 6 AM daily
- **Weekly Review:** Extract refreshes Monday mornings

---

## Performance Monitoring

### Measuring Dashboard Performance

**Looker Studio Performance Metrics:**
1. **Time to First Chart:** How long until first chart displays
2. **Total Load Time:** All charts loaded
3. **Chart Query Time:** Individual chart query duration
4. **Data Transfer Size:** KB/MB of data fetched

**Check Performance:**
1. Open dashboard in **View Mode** (not Edit)
2. Open browser DevTools (F12)
3. **Network** tab → Reload page
4. Look for:
   - Total requests
   - Total KB transferred
   - Load time

**Performance Targets:**

| Metric | Good | Acceptable | Poor |
|--------|------|------------|------|
| Time to First Chart | <1 second | 1-2 seconds | >2 seconds |
| Total Load Time | <3 seconds | 3-5 seconds | >5 seconds |
| Chart Query Time | <0.5 seconds | 0.5-1 second | >1 second |
| Data Transfer Size | <1 MB | 1-5 MB | >5 MB |

---

### Testing on Nigerian Internet Speeds

**Chrome DevTools Network Throttling:**
1. Open DevTools (F12)
2. **Network** tab
3. **Throttling** dropdown
4. Select **Fast 3G** or **Slow 3G**
5. Reload dashboard
6. Measure load time

**Typical Nigerian Speeds:**
- **Urban 4G:** 10-30 Mbps (use "Fast 3G" simulation)
- **Suburban 3G:** 1-5 Mbps (use "Slow 3G" simulation)
- **Rural 2G:** <1 Mbps (use "Slow 3G" or custom)

**Performance Target:** Dashboard must load in <10 seconds on "Slow 3G"

---

## Performance Optimization Checklist

### Before Publishing Dashboard

**1. Data Source Optimization:**
- [ ] Caching enabled (appropriate duration)
- [ ] Database indexes on filtered/joined columns
- [ ] Views created for complex calculations
- [ ] Date range defaults to recent data (not all-time)

**2. Query Optimization:**
- [ ] Aggregations done in database (not in Looker)
- [ ] Row limits applied (no 10,000+ row charts)
- [ ] Unnecessary columns removed from queries
- [ ] Efficient JOIN strategies (Week 11 concepts)

**3. Dashboard Design:**
- [ ] 6-8 charts maximum per page
- [ ] Multi-page for complex dashboards (not single 20-chart page)
- [ ] Unused charts removed
- [ ] Heavy charts moved to secondary pages

**4. Testing:**
- [ ] Load time tested on desktop (<5 seconds)
- [ ] Load time tested on mobile (<10 seconds)
- [ ] Load time tested on slow connection (Fast 3G)
- [ ] All charts display correctly
- [ ] No query errors in console

---

## Nigerian-Specific Optimizations

### Optimization 1: Minimize Image Use

**Problem:** Header images, logos, backgrounds increase load time

**Solution:**
- Use text + color instead of image headers
- If logo needed: Compress to <50KB, use PNG or SVG
- Avoid background images

**Example:**
```
❌ Heavy Header (500KB image): +2 seconds load time
✅ Text Header (5KB): +0.01 seconds load time
```

---

### Optimization 2: Design for Data Cost Awareness

**Nigerian Reality:** Users pay per MB of mobile data

**Dashboard Size Impact:**
- Heavy dashboard (5MB): Costs user ~10 naira per view
- Light dashboard (500KB): Costs user ~1 naira per view

**How to Reduce Size:**
- Enable caching (users don't re-download same data)
- Remove images
- Aggregate data (fewer rows = smaller transfer)
- Use data extracts

---

### Optimization 3: Offline-Friendly Design

**Problem:** User on bus, internet drops, dashboard unusable

**Solution:** PDF snapshot for offline viewing

**Implementation:**
1. **File** → **Download** → **PDF**
2. Schedule PDF email (daily/weekly)
3. Users can view PDF offline

**Use Case:** Field sales reps checking targets while traveling

---

## Real-World Nigerian Performance Improvements

### Case Study 1: Lagos Retailer Dashboard

**Before Optimization:**
- 15 charts on single page
- No caching
- Live database queries
- Complex JOINs in Looker
- Load time: 12 seconds (desktop), 25 seconds (mobile)

**After Optimization:**
- 6 charts on Page 1 (9 charts moved to Page 2)
- 1-hour caching enabled
- Database views for complex metrics
- Date filter defaulted to last 30 days
- Load time: 3 seconds (desktop), 6 seconds (mobile)

**Result:** 4× faster, users actually use dashboard daily

---

### Case Study 2: Abuja Logistics Company

**Before:**
- 200,000 row dataset loaded entirely
- No indexes on order_date
- All-time date range default
- Load time: 18 seconds

**After:**
- Added index on order_date
- Default to last 7 days (user can expand)
- Data extract (refreshes nightly)
- Load time: 2 seconds

**Result:** 9× faster, dashboard accessible on mobile in field

---

## Key Takeaways

1. **Performance = User Adoption** - Slow dashboards don't get used
2. **Enable caching** - Biggest quick win (set appropriate duration)
3. **Optimize queries** - Use Week 11 SQL optimization techniques
4. **Reduce complexity** - 6-8 charts per page maximum
5. **Test on slow connections** - Nigerian reality (3G/4G, not broadband)
6. **Database optimization matters** - Indexes, views, aggregations
7. **Multi-page > Single page** - Lazy loading improves perceived performance
8. **Monitor performance** - Use DevTools, test regularly

---

## Hands-On Preview

**In the exercise, you'll:**
1. Benchmark a slow dashboard (load time, data transfer)
2. Enable caching and measure improvement
3. Reduce charts from 12 to 6 (move others to Page 2)
4. Set default date filter to last 30 days
5. Test on simulated "Slow 3G" connection
6. Achieve target: <5 seconds on desktop, <10 seconds on mobile

**Expected Results:**
- Before: 14 seconds load time
- After: 4 seconds load time
- 3.5× performance improvement

---

## Additional Resources

- **Query Optimization:** Week 11 SQL Performance lecture notes
- **Chrome DevTools:** Network performance analysis guide
- **BigQuery Best Practices:** Google's optimization guide
- **Looker Studio Caching:** Official documentation on data freshness
- **Nigerian Internet Stats:** GSMA Mobile Connectivity Index (Nigeria data)

---

**Next Section:** Collaboration & Version Control (04_collaboration_version_control.md) - Sharing dashboards and managing changes

**Related Concepts:**
- Week 11 Thursday: SQL Query Optimization (database-level performance)
- Week 11 Wednesday: Python Performance (code-level optimization)
- Section 02: Multi-page navigation (strategy for lazy loading)
