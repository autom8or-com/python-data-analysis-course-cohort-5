# Data Freshness Monitoring and Caching Configuration

## Week 16 - Wednesday Session - Part 4

### Duration: 15 minutes

---

## What Is Data Freshness?

**Data freshness** describes how recently your dashboard data was last updated from the source database. A dashboard with stale data — showing last week's numbers when today's decisions depend on current figures — is not just unhelpful; it can cause real harm if stakeholders trust it.

**Two questions every production dashboard must answer:**
1. When was this data last updated?
2. Is that freshness level appropriate for my audience's decisions?

### The Freshness Spectrum

Different business decisions require different data freshness:

| Decision Type | Example | Required Freshness |
|---------------|---------|-------------------|
| Real-time operations | Live order processing, fraud detection | Minutes |
| Daily management | Yesterday's sales, same-day delivery tracking | Hours |
| Weekly reporting | Weekly KPI review, team performance | Daily |
| Strategic planning | Executive dashboard, QBR | Weekly |
| Historical analysis | Year-over-year trends, cohort analysis | Monthly |

**For the Olist dashboard (historical data):** Weekly or on-demand refresh is appropriate. The dataset does not change, so any refresh will produce identical results — but a scheduled refresh confirms the data source connection remains healthy.

---

## How Looker Studio Handles Data Freshness

### Caching Behavior

Looker Studio automatically caches (stores temporarily) the results of your data source queries. This means:

1. First user loads dashboard → Looker Studio queries Supabase → Results cached for 12 hours
2. Second user loads dashboard → Served from cache → Fast load, no database query
3. After 12 hours → Cache expires → Next load triggers a fresh query to Supabase

**Default cache duration:** 12 hours for most connectors

**You can control this by:**
- Setting a manual refresh (forces a new database query immediately)
- Configuring an Extract data source with a custom refresh schedule
- Embedding a data freshness indicator so viewers know when data was last updated

### When Caching Helps vs Hurts

**Caching helps when:**
- Multiple users view the same dashboard simultaneously
- Database queries take more than 3-5 seconds
- Data changes infrequently (daily or less often)
- Dashboard load time matters for user experience

**Caching hurts when:**
- Data changes every hour (live operations)
- A specific user needs to see changes made 30 minutes ago
- You need guaranteed real-time accuracy

**For your Final Project dashboard:** The Olist dataset is historical. Caching is your friend. Enable Extract and schedule a weekly refresh to ensure the connection stays active.

---

## Setting Up Data Freshness Indicators

### Method 1: Last Refresh Timestamp Scorecard

Show users exactly when the data was last updated using a calculated field.

**Step 1: Add a timestamp field to your custom SQL query**

Add this line to the SELECT clause of your pre-aggregated query:

```sql
-- Add to your SELECT clause:
CURRENT_TIMESTAMP AS data_extracted_at
```

**Example (add to Query 2a):**

```sql
SELECT
    mo.year_month,
    ROUND(SUM(mo.payment_value)::numeric, 2)  AS total_revenue,
    COUNT(DISTINCT mo.order_id)               AS order_count,
    ROUND(AVG(mo.payment_value)::numeric, 2)  AS avg_order_value,
    CURRENT_TIMESTAMP                         AS data_extracted_at   -- add this
FROM monthly_orders mo
...
GROUP BY mo.year_month
ORDER BY mo.year_month;
```

**Step 2: Add a Scorecard in Looker Studio**

1. Add Chart → Scorecard
2. Metric: `MAX(data_extracted_at)` (shows the most recent extraction timestamp)
3. Format: Date time → "MMM D, YYYY h:mm A" (e.g., "Mar 3, 2026 9:00 AM")
4. Title: "Data last updated"
5. Position: Top-right corner of each page

[Screenshot: Scorecard in top-right corner showing "Data last updated: Mar 3, 2026 9:00 AM"]

### Method 2: Text Box with Refresh Schedule

A simpler approach — manually document the refresh schedule as a static text box:

```
Data Source: Olist PostgreSQL (Supabase)
Refresh Schedule: Every Sunday 6:00 AM
Data Period: Sep 2016 – Aug 2018 (historical)
Next Refresh: Sunday, Mar 8, 2026

Note: This dashboard uses historical data. The figures
do not change between refreshes. Contact the dashboard
owner if you need data beyond August 2018.
```

### Method 3: Dataset Boundary Warning

For the Olist dataset specifically, add a prominent warning when users try to view data outside the active date range:

**Calculated Field:**
```
-- Boundary check: warn if viewing period has limited data
CASE
  WHEN EXTRACT(YEAR FROM order_purchase_timestamp) = 2018
   AND EXTRACT(MONTH FROM order_purchase_timestamp) >= 9 THEN "Low Data Volume - Dataset Ends Aug 2018"
  WHEN EXTRACT(YEAR FROM order_purchase_timestamp) = 2016 THEN "Startup Period - Low Volume"
  ELSE "Active Period"
END
```

Add this field to a scorecard or filter the dashboard to only show the active period by default.

---

## Configuring Extract Data Sources

### When to Use Extract

Extract is appropriate for the Olist project because:
- Historical data does not change (a weekly refresh confirms connectivity but produces identical results)
- Dashboard serves an audience expecting sub-3-second load times
- Multiple students/reviewers will access the dashboard simultaneously during presentations

### Step-by-Step Extract Configuration

1. From your report, click **Resource** → **Manage added data sources**
2. Find your Olist data source → Click **Edit** (pencil icon)
3. At the top of the edit panel, click **"Extract data"** tab
4. Click **"Scheduled refresh"**
5. Configure:
   - **Frequency:** Weekly
   - **Day:** Sunday
   - **Time:** 6:00 AM
   - **Time zone:** Africa/Lagos (or your local timezone)
6. Click **"Save"**
7. Click **"Run now"** to trigger the first extract immediately

[Screenshot: Looker Studio data source editor showing the "Extract data" tab with schedule settings]

**After setup:** All charts connected to this data source will load from the cached extract rather than querying Supabase directly.

### Forcing a Manual Refresh

If your data has been updated and you need the dashboard to reflect new data immediately:

1. **Resource** → **Manage added data sources**
2. Click **Edit** on your data source
3. Click **"Extract data"** tab
4. Click **"Refresh now"**
5. Wait for confirmation → Click **"Done"**

[Screenshot: "Refresh now" button in the Extract data tab]

---

## Caching Configuration Best Practices

### Do Not Cache During Development

While building your dashboard:
- Use Live connection to see changes immediately
- Switch to Extract only when ready to publish for stakeholders

### Cache Duration Recommendations

| Audience | Data Change Rate | Recommended Cache |
|----------|-----------------|-------------------|
| Executives (monthly QBR) | Monthly | Extract with monthly refresh |
| Operations team (daily standup) | Daily | Extract with daily refresh |
| Real-time operations | Every hour | Live connection |
| Historical analysis | Never changes | Extract with weekly refresh (confirmation only) |

### Limiting Refresh to Off-Hours

Schedule refreshes during low-traffic hours to avoid slow dashboard loads during business hours:

- **Best times:** 5:00 AM – 7:00 AM local time
- **Avoid:** Monday 9:00 AM (when everyone opens the dashboard for the weekly meeting)
- **For Olist project:** Sunday 6:00 AM is ideal

---

## Dashboard Caching Architecture

Understanding how Looker Studio caches helps you diagnose load time issues:

```
User Opens Dashboard
        ↓
Looker Studio checks: "Is this query cached?"
        ├─ YES (within 12 hours) → Serve from cache [fast: 0.5-2 seconds]
        └─ NO (expired or first load)
                ↓
        Query sent to Supabase PostgreSQL
                ↓
        Supabase executes query [1-30 seconds depending on complexity]
                ↓
        Results returned to Looker Studio
                ↓
        Results stored in cache [next user gets fast load]
                ↓
        Charts rendered for current user
```

**Implication:** The first person to open a dashboard after cache expiry gets a slow load. Everyone after gets fast loads. For presentations, always open your dashboard 5 minutes before the audience arrives to warm the cache.

---

## Setting Up the Refresh Notification

For production dashboards with real stakeholders, configure scheduled email delivery to notify the team when data refreshes:

**Step 1:** Complete your dashboard and publish it (Share → Make available to anyone with the link)

**Step 2:** Navigate to **Share** → **Schedule email delivery**

**Step 3:** Configure:
- **Recipients:** Your email + any team members
- **Frequency:** Same as your data refresh (Weekly on Sunday)
- **Time:** 8:00 AM Sunday (2 hours after refresh completes)
- **Subject:** "Weekly Olist Dashboard Refresh Complete"
- **Message:** "The executive dashboard has been refreshed with the latest data. View at: [link]"

This pattern is a professional practice — stakeholders receive a notification that data is fresh, rather than having to guess whether to trust the numbers they see.

---

## Connection to Prior Learning

### Week 13 (Looker Fundamentals — Data Connections)

In Week 13 you connected Looker Studio to Supabase for the first time. Today you configure that connection for production-grade reliability. The connection itself has not changed — but the settings around it (cache, refresh, extract) have.

### Week 14 (Interactive Dashboards — Data Sources)

In Week 14 you added multiple data sources to a single report. Today you optimize how each of those data sources is refreshed and cached independently.

### Week 15 (Advanced Analytics — Pre-Calculation in SQL)

The pre-aggregated queries from the previous lecture (Part 2) are the data sources that will be configured with Extract today. The pre-aggregation + Extract combination produces the fastest possible dashboard load times.

---

## Production Readiness Checklist

Before marking your dashboard as production-ready for your Final Project:

```
DATA FRESHNESS
☐ Data freshness indicator added (scorecard or text box)
☐ Default date range set to active period (Jan 2017 – Aug 2018)
☐ Extract configured with scheduled refresh (weekly for Olist)
☐ Scheduled email delivery configured (optional but professional)
☐ Data quality notes visible in footer of each page

PERFORMANCE
☐ Custom SQL queries tested in VS Code (all run under 10 seconds)
☐ Pre-aggregated queries used as data sources (not raw tables)
☐ Charts per page: 8 or fewer
☐ Extract refreshed at least once (cache is warm)
☐ Dashboard loads in under 5 seconds after cache is warm

RELIABILITY
☐ All calculated fields tested with NULL edge cases
☐ Date filters set to avoid empty periods
☐ Revenue source confirmed: payment_value (not price + freight)
☐ Delivery metrics filter: order_delivered_customer_date IS NOT NULL
☐ Customer counts use: customer_unique_id (not customer_id)
```

---

## Common Issues and Solutions

| Issue | Symptom | Solution |
|-------|---------|---------|
| Dashboard loads slowly even with Extract | 10+ second load time | Check whether Extract actually refreshed — click "Refresh now" |
| Charts show "no data" after refresh | Empty charts after Extract refresh | SQL query may have changed — test query directly in VS Code |
| Extract refresh fails silently | Data is stale, no error shown | Check Supabase connection credentials have not expired |
| All charts show same old date | Cache served to all users | Extract has not been configured — all users see live query results |
| Dashboard stale for some users but fresh for others | Inconsistent cache behavior | Each device/browser may have different cache states — force manual refresh |

---

## Key Takeaways

### What You Learned
1. ✅ Data freshness describes how recently dashboard data was updated from the source
2. ✅ Extract connections cache results on Google's servers — fastest load times for historical data
3. ✅ Configure Extract refresh to match your data change rate (weekly for Olist historical data)
4. ✅ Always display a freshness indicator so viewers know when data was last updated
5. ✅ Warm the cache before presentations — open the dashboard 5 minutes early
6. ✅ Scheduled email delivery is a professional practice for notifying stakeholders of refreshes

### What's Next
This completes the Wednesday optimization and data quality sessions. On Thursday, you will configure sharing, set up scheduled email delivery for stakeholders, learn dashboard embedding, and build the documentation that makes your dashboard maintainable long after you hand it over.

### Month 5 Completion Progress

```
Week 13: Looker Studio Fundamentals ✓
Week 14: Interactive Dashboards ✓
Week 15: Advanced Analytics & Data Storytelling ✓
Week 16 Wednesday: Optimization & Data Quality ✓
         ↓
Week 16 Thursday: Sharing, Deployment & Documentation
         ↓
FINAL PROJECT SUBMISSION
```

---

## Quick Reference Card

### Freshness Configuration Decision

```
Is data historical (does not change)?
└─ YES → Extract + Weekly refresh (Olist)

Does data change daily?
└─ YES → Extract + Daily refresh at 5 AM

Does data change every hour?
└─ YES → Live connection (no Extract)

Does data change every minute?
└─ YES → Live connection + reduce chart complexity
```

### Must-Have Freshness Indicators

```
1. Scorecard: MAX(data_extracted_at) in top-right corner
2. Footer text: "Data period: [start] to [end]"
3. Footer text: "Refresh schedule: [frequency]"
```

---

## Questions to Test Your Understanding

1. A stakeholder opens your dashboard at 10:00 PM, and the cache was last refreshed at 8:00 AM that morning. Is the data still fresh? By how many hours has it exceeded the default 12-hour cache window?
2. You schedule an Extract refresh for Sunday at 6:00 AM. You schedule the weekly email delivery for Sunday at 8:00 AM. Why is the 2-hour gap important?
3. Your Final Project presentation is at 2:00 PM. When should you open your dashboard to warm the cache?
4. A classmate's dashboard takes 20 seconds to load. What is the most likely cause, and what would you check first?
5. The default Looker Studio cache duration is 12 hours. If you need your dashboard data to be fresh as of 30 minutes ago (for a live operations use case), what should you configure?

**Answers at the end of lecture notes**

---

## Additional Resources

- **Looker Studio Help:** [Data freshness and caching](https://support.google.com/looker-studio/answer/7020039)
- **Looker Studio Help:** [Extract data sources](https://support.google.com/looker-studio/answer/9208547)
- **Week 16 Resources:** Data Quality Checklist (resources folder)
- **Validation Report:** Section 3b — Data Freshness Query and Results

---

## Answers to Questions

1. **Cache freshness:** 14 hours have passed (8:00 AM to 10:00 PM). The default 12-hour cache has expired by 2 hours. Looker Studio would trigger a fresh query to Supabase when the stakeholder opens the dashboard at 10:00 PM — which is correct behavior.
2. **2-hour buffer:** The refresh job needs time to run. A complex pre-aggregated query against 99,441 rows may take 1-5 minutes to execute and cache. Scheduling the email 2 hours after the refresh ensures the data is fully refreshed and available before stakeholders are notified to look at it.
3. **Pre-warming cache:** Open the dashboard at 1:50-1:55 PM (5-10 minutes before the presentation). This ensures the query runs, results are cached, and all charts render. When you share your screen at 2:00 PM, charts load instantly.
4. **20-second load diagnosis:** First check: is the data source using a Live connection to a large raw table (no Extract, no pre-aggregation)? A raw query against 99,441+ rows can take 10-20 seconds. Solution: configure pre-aggregated custom SQL + Extract. Second check: are there more than 8-10 charts on the page (too many simultaneous queries)?
5. **30-minute freshness for live ops:** Extract is not appropriate here — it refreshes on a schedule, not in real-time. Configure a Live connection instead. Optionally, reduce query complexity to keep live query time under 5 seconds. Advise stakeholders that live data has a natural delay of seconds to minutes depending on database load.

---

**Wednesday Session Complete. Next: Thursday - 01_sharing_permissions.md**
