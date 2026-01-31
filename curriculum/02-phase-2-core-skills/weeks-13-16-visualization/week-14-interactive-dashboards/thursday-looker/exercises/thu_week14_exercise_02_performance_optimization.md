# Week 14 Thursday - Exercise 2: Dashboard Performance Optimization

**Estimated Time:** 30 minutes
**Difficulty:** Intermediate-Advanced
**Prerequisites:** Completed Exercise 1 (Multi-Page Customer Analytics Dashboard)

---

## Exercise Overview

Optimize your 3-page Customer Analytics dashboard from Exercise 1 for production use. You'll improve loading speed, implement caching strategies, configure data refresh schedules, and set up collaboration features for team use.

**Business Scenario:**
Your Customer Analytics dashboard from Exercise 1 is now ready for production. However, the Head of Customer Success reports:
- Dashboard loads slowly (>10 seconds)
- Real-time data not needed (daily updates sufficient)
- Need to share with 5 team members
- Want scheduled email delivery every Monday morning
- Mobile version needed for field sales team

Your task: Optimize for performance, collaboration, and accessibility.

---

## Learning Objectives

By completing this exercise, you will:
- Diagnose and fix dashboard performance issues
- Implement data caching and extract optimization
- Configure scheduled data refreshes
- Set up email delivery schedules
- Create and manage dashboard versions
- Implement mobile-optimized layouts
- Configure sharing and collaboration settings

---

## Prerequisites Check

Before starting, ensure you have:
- [ ] Completed Exercise 1 (3-page Customer Analytics Dashboard)
- [ ] Dashboard link from Exercise 1
- [ ] Access to same Supabase data source
- [ ] Looker Studio account with sharing permissions

---

## Exercise Tasks

## Task 1: Performance Audit & Diagnosis (5 minutes)

### Step 1: Measure Current Performance

1. **Open your Exercise 1 dashboard**

2. **Test loading time:**
   - Clear browser cache (Ctrl+Shift+Delete)
   - Open dashboard link in incognito/private window
   - Use browser DevTools (F12) → Network tab
   - Record: Time to first chart display _______ seconds
   - Record: Time to full dashboard load _______ seconds

3. **Identify bottlenecks:**
   - Check which charts load slowest
   - Note any error messages in console
   - Count total charts across all 3 pages: _______

### Step 2: Performance Checklist

Complete this diagnostic checklist:

**Data Connection:**
- [ ] Using live connection (slower) OR data extract (faster)?
- [ ] How many tables joined? _______
- [ ] Any complex calculated fields? (List: _____________)

**Chart Count:**
- [ ] Page 1: _______ charts
- [ ] Page 2: _______ charts
- [ ] Page 3: _______ charts
- [ ] **Total:** _______ charts
- [ ] Recommended: Max 8 charts per page

**Filter Configuration:**
- [ ] Filters applied at data source level OR chart level?
- [ ] Cross-page filters configured correctly?

**Data Volume:**
- [ ] Date range selected: _______
- [ ] Approximate rows returned per chart: _______
- [ ] Any charts pulling >10,000 rows?

### Expected Findings

**Baseline Benchmarks:**
- **Excellent:** <3 seconds full load
- **Good:** 3-5 seconds
- **Acceptable:** 5-8 seconds
- **Needs Optimization:** >8 seconds

---

## Task 2: Implement Data Optimization (10 minutes)

### Step 2.1: Convert to Data Extract

**Why:** Data extracts cache results, reducing database queries

**How to implement:**

1. **Navigate to Data Source:**
   - Click any chart → **Data** panel → Data source name → **Edit connection**

2. **Enable Data Freshness (Extract):**
   - Look for **Data Freshness** section
   - Select: **Data is refreshed** → **Every 12 hours**
   - OR select: **Data is refreshed** → **Daily at 6:00 AM** (choose your timezone: WAT - West Africa Time)
   - Save

3. **Create Data Extract:**
   - Click **Extract Data** button
   - Configuration:
     - **Date range:** Last 12 months (or your standard reporting period)
     - **Row limit:** 100,000 (adjust based on data size)
     - **Enable:** Automatic refresh
   - Click **Save**

4. **Replace data source in dashboard:**
   - **Resource** → **Manage added data sources**
   - Replace live connection with extract
   - Apply to all pages

**Expected Result:**
- Dashboard now uses cached data
- Load time reduced by 40-60%
- Data updates automatically at scheduled time

---

### Step 2.2: Optimize Calculated Fields

**Problem:** Complex calculated fields recalculate on every page load

**Solution:** Pre-aggregate at data source level

**Fields to optimize:**

**1. RFM Scores - Move to Data Source Level**

Instead of calculating in Looker, create in database:

```sql
-- Option A: If you have database access, create view
CREATE VIEW customer_rfm_scores AS
SELECT
  customer_id,
  DATEDIFF(CURRENT_DATE, MAX(order_purchase_timestamp)) AS recency_days,
  COUNT(DISTINCT order_id) AS frequency,
  SUM(payment_value) AS monetary,
  CASE
    WHEN DATEDIFF(CURRENT_DATE, MAX(order_purchase_timestamp)) <= 90
         AND COUNT(DISTINCT order_id) >= 3
         AND SUM(payment_value) >= 500 THEN 'Champions'
    WHEN DATEDIFF(CURRENT_DATE, MAX(order_purchase_timestamp)) <= 90
         AND COUNT(DISTINCT order_id) >= 2 THEN 'Loyal'
    WHEN DATEDIFF(CURRENT_DATE, MAX(order_purchase_timestamp)) <= 180 THEN 'Active'
    WHEN DATEDIFF(CURRENT_DATE, MAX(order_purchase_timestamp)) > 180
         AND COUNT(DISTINCT order_id) >= 3 THEN 'At Risk'
    WHEN DATEDIFF(CURRENT_DATE, MAX(order_purchase_timestamp)) > 365 THEN 'Dormant'
    ELSE 'New'
  END AS customer_segment
FROM olist_orders_dataset o
JOIN olist_order_payments_dataset p ON o.order_id = p.order_id
GROUP BY customer_id;
```

**Option B: If no database access, optimize in Looker:**

- Simplify CASE statements (fewer conditions)
- Use IF instead of nested CASE when possible
- Pre-filter data before calculations

**2. Reduce Aggregation Complexity**

**Before (Slow):**
```
AVG(SUM(payment_value) / COUNT(order_id))
```

**After (Fast):**
```
SUM(payment_value) / COUNT(order_id)
```

Remove nested aggregations where possible.

---

### Step 2.3: Optimize Filters

**Move filters from chart level to data source level:**

1. **Identify common filters:**
   - "Delivered orders only" (used on all pages)
   - Date range filter
   - Customer segment filter

2. **Apply at data source level:**
   - Edit data source → **Filter** tab
   - Add filter: `order_status = 'delivered'`
   - This filter now applies globally, charts don't need to reapply

3. **Remove redundant chart-level filters:**
   - Go through each chart
   - Remove filters already applied at data source level
   - Keep only chart-specific filters

**Expected Result:**
- Faster query execution
- Reduced data transfer
- Simpler chart configurations

---

## Task 3: Implement Caching Strategy (5 minutes)

### Step 3.1: Enable Query Caching

**What it does:** Stores recent query results, serves cached data to subsequent viewers

**How to enable:**

1. **Data Source Settings:**
   - Edit data source → **Advanced** tab
   - Enable: **Query caching**
   - Cache duration: **12 hours** (balance freshness vs performance)
   - Save

2. **Test caching:**
   - Load dashboard (first load = fresh query)
   - Reload page (second load = cached, faster)
   - Verify time difference

---

### Step 3.2: Configure Data Freshness Indicator

**Add transparency for users:**

1. **Add "Last Updated" text box:**
   - On each page, bottom-right corner
   - Text: "Data Last Updated: [Auto-Insert Date]"
   - Use formula: `CURRENT_DATETIME()` (shows cache refresh time)
   - Style: Small (10px), gray color, italic

2. **Add data source indicator:**
   - Text: "Source: Olist E-Commerce Database"
   - Position: Footer area
   - Links to data source documentation (optional)

**Example Footer:**
```
┌────────────────────────────────────────────┐
│                                            │
│ [Charts and content above]                 │
│                                            │
├────────────────────────────────────────────┤
│ Data Last Updated: Jan 31, 2026 6:00 AM   │
│ Source: Olist Database | Refresh: Daily   │
└────────────────────────────────────────────┘
```

---

## Task 4: Configure Scheduled Email Delivery (5 minutes)

### Step 4.1: Set Up Email Schedule

**Requirement:** Head of Customer Success wants dashboard emailed every Monday at 6 AM

**How to configure:**

1. **Open dashboard in view mode** (not edit mode)

2. **Click Share button → Schedule email delivery**

3. **Email schedule configuration:**
   - **Recipients:**
     - Add email: customerSuccess@najaretail.com.ng
     - Add team members (5 people from scenario)
   - **Frequency:** Weekly
   - **Day:** Monday
   - **Time:** 6:00 AM
   - **Timezone:** WAT (GMT+1) - West Africa Time
   - **Email subject:** "Weekly Customer Analytics Dashboard - [Date]"
   - **Message:**
     ```
     Good morning team,

     Your weekly Customer Analytics Dashboard is ready for review.

     Key highlights:
     - New customer acquisition trends (Page 1)
     - RFM segmentation analysis (Page 2)
     - Geographic distribution insights (Page 3)

     Click the link below to view the interactive dashboard.

     Best regards,
     NaijaRetail Analytics Team
     ```

4. **Attachment options:**
   - **Attach PDF:** YES (for offline viewing)
   - **Include link:** YES (for interactive exploration)
   - **Pages to include:** All pages (1, 2, 3)

5. **Save schedule**

---

### Step 4.2: Test Email Delivery

1. **Send test email:**
   - Click **Send test email** button
   - Enter your own email
   - Verify:
     - [ ] Email received within 2 minutes
     - [ ] PDF attachment opens correctly
     - [ ] Dashboard link works
     - [ ] All 3 pages included in PDF
     - [ ] Charts render correctly in email

2. **Troubleshooting:**
   - If charts don't show: Enable "Embed images" in settings
   - If PDF cut off: Adjust page dimensions to standard size (1600×900)
   - If link broken: Check sharing permissions (Anyone with link → Can view)

---

## Task 5: Create Mobile-Optimized Version (10 minutes)

### Step 5.1: Duplicate Dashboard for Mobile

**Why:** Separate mobile version allows specific optimizations without affecting desktop

**How to create:**

1. **Duplicate dashboard:**
   - File → Make a copy
   - Name: "NaijaRetail Customer Analytics - Mobile"
   - Save

2. **Switch to mobile layout:**
   - View → Mobile layout
   - Canvas width: 375px (iPhone standard)
   - Height: Variable (scrollable)

---

### Step 5.2: Optimize for Mobile Screens

**Page 1: Customer Overview - Mobile Version**

**Changes to make:**

1. **KPI Scorecards:**
   - **Before:** 4 scorecards in horizontal row (400px each)
   - **After:** 2×2 grid (175px each)
   ```
   ┌────────┬────────┐
   │  KPI1  │  KPI2  │
   ├────────┼────────┤
   │  KPI3  │  KPI4  │
   └────────┴────────┘
   ```

2. **Customer Acquisition Trend:**
   - **Before:** 1000px wide
   - **After:** Full width (375px)
   - **Height:** Reduce from 400px to 250px
   - Simplify: Remove grid lines, keep only essential elements

3. **RFM Donut Chart:**
   - **Before:** Side-by-side with time series
   - **After:** Stack below time series
   - **Width:** Full (375px)
   - **Height:** 200px (smaller)
   - Legend position: Bottom (not right - saves width)

4. **Top Customers Table:**
   - **Before:** 7 columns
   - **After:** 3 columns only
     - Customer ID
     - Total Spend
     - Segment
   - Hide other columns (too narrow on mobile)
   - Font size: Minimum 14px (tappable)

**Repeat similar optimizations for Pages 2 and 3:**
- Stack elements vertically (no side-by-side layouts)
- Reduce chart heights
- Simplify tables (fewer columns)
- Larger tap targets (minimum 44×44px buttons)
- Increase font sizes (minimum 14px body, 18px titles)

---

### Step 5.3: Test Mobile Experience

1. **Mobile simulator test:**
   - Chrome DevTools → Toggle device toolbar (Ctrl+Shift+M)
   - Test devices:
     - iPhone 12 Pro (390×844)
     - Samsung Galaxy S21 (360×800)
     - iPad (768×1024)

2. **Interaction test:**
   - [ ] All charts visible without horizontal scroll
   - [ ] Navigation tabs tappable (not too small)
   - [ ] Date filter works on touch screen
   - [ ] Tables scrollable if needed
   - [ ] Page transitions smooth

3. **Share mobile version:**
   - Get shareable link
   - Add to description: "Optimized for mobile devices"
   - Share with field sales team

---

## Task 6: Set Up Collaboration Features (5 minutes)

### Step 6.1: Configure Sharing Permissions

**Requirement:** 5 team members need editing access, stakeholders need view-only

**How to configure:**

1. **Share desktop version:**
   - Click **Share** button
   - Add people:
     - **Can edit:** Team members (5 people)
       - analyst1@najaretail.com.ng
       - analyst2@najaretail.com.ng
       - manager@najaretail.com.ng
       - (add 2 more)
     - **Can view:** Stakeholders
       - ceo@najaretail.com.ng
       - head_cs@najaretail.com.ng
   - Link sharing: **Anyone at NaijaRetail with link can view**
   - Disable: **Anyone on the internet** (security)

2. **Add access expiration (Optional):**
   - For external stakeholders: Set expiration date
   - Example: Grant 30-day view access for consultants

---

### Step 6.2: Version Control Setup

**Create version history for tracking changes:**

1. **Enable version history:**
   - File → Version history → Name current version
   - Name: "v1.0 - Production Release - Jan 31, 2026"
   - Description: "Initial production version with RFM analysis"

2. **Create change log:**
   - Add text box on Page 1 (bottom)
   - Title: "Change Log"
   - Content:
     ```
     v1.0 - Jan 31, 2026: Initial production release
     - 3-page dashboard (Overview, Segmentation, Geographic)
     - RFM customer segmentation
     - Data refresh: Daily at 6 AM WAT
     ```

3. **Version management protocol:**
   - Before major changes: Save new version
   - Naming convention: v[Major].[Minor] - [Description] - [Date]
   - Example: v1.1 - Added Product Analysis Page - Feb 15, 2026

---

### Step 6.3: Add Collaboration Comments

**Enable team feedback:**

1. **Turn on commenting:**
   - View mode → Click speech bubble icon (top right)
   - Enable: **Anyone with access can comment**

2. **Add sample comments for team:**
   - Select a chart → Click comment icon
   - Add note: "Question: Should we segment Champions further into High/Medium/Low value?"
   - Assign to team member for follow-up

3. **Create feedback guidelines:**
   - Add text box on Page 1: "Feedback Welcome"
   - Instructions:
     ```
     Have suggestions? Click the comment icon (💬) on any chart.

     Questions? Tag @analyst-team
     Issues? Tag @data-ops

     We review comments weekly and update the dashboard monthly.
     ```

---

## Bonus Challenges (Optional, +10 minutes)

### Challenge 1: Add Performance Monitoring

**Set up dashboard usage analytics:**

1. Go to dashboard settings
2. Enable Google Analytics integration
3. Track:
   - Page views per dashboard page
   - Average time on dashboard
   - Most common filter selections
   - Peak usage times

---

### Challenge 2: Create Dashboard Documentation

**Build a user guide:**

1. Create new page: "How to Use This Dashboard"
2. Add:
   - Navigation instructions
   - Filter explanations
   - RFM segment definitions
   - FAQ section
   - Contact info for support

---

### Challenge 3: Implement Data Quality Alerts

**Monitor data freshness:**

1. Add scorecard showing data staleness
2. Formula: `DATEDIFF(CURRENT_DATE(), MAX(order_date))`
3. Conditional formatting:
   - Green: <1 day old (fresh)
   - Yellow: 1-2 days old (acceptable)
   - Red: >2 days old (stale - investigate)

---

## Submission Checklist

Before submitting, verify all optimizations:

**Performance:**
- [ ] Data extract enabled (not live connection)
- [ ] Cache configured (12-hour duration)
- [ ] Query time reduced (measure before/after)
- [ ] Dashboard loads in <5 seconds
- [ ] Calculated fields optimized (no nested aggregations)
- [ ] Filters applied at data source level

**Scheduled Delivery:**
- [ ] Email schedule configured (Mondays, 6 AM WAT)
- [ ] Recipients added (5 team members + stakeholders)
- [ ] Test email sent and received successfully
- [ ] PDF attachment renders correctly

**Mobile Optimization:**
- [ ] Mobile version created (separate dashboard)
- [ ] Layouts optimized for 375px width
- [ ] Charts stack vertically (no horizontal scroll)
- [ ] Fonts readable (minimum 14px)
- [ ] Navigation works on touch devices
- [ ] Tested on mobile simulator

**Collaboration:**
- [ ] Sharing permissions configured (edit vs view)
- [ ] Version history enabled
- [ ] v1.0 named and saved
- [ ] Change log added
- [ ] Commenting enabled
- [ ] Feedback guidelines provided

**Documentation:**
- [ ] "Last Updated" timestamp on all pages
- [ ] Data source attribution
- [ ] Version number visible
- [ ] Contact info for support (optional)

---

## Performance Comparison Table

Document your improvements:

| Metric | Before Optimization | After Optimization | Improvement |
|--------|--------------------|--------------------|-------------|
| Initial load time | ________ sec | ________ sec | ________ % |
| Page 1 load | ________ sec | ________ sec | ________ % |
| Page 2 load | ________ sec | ________ sec | ________ % |
| Page 3 load | ________ sec | ________ sec | ________ % |
| Data source type | Live connection | Data extract | N/A |
| Cache enabled | No | Yes (12 hrs) | N/A |
| Total charts | ________ | ________ | ________ fewer |

**Target:** At least 40% improvement in load time

---

## Common Issues and Troubleshooting

### Issue 1: Data extract fails to create
**Cause:** Dataset too large or query timeout
**Solution:**
- Reduce date range (last 6 months instead of 12)
- Remove unused fields from data source
- Split into multiple smaller extracts
- Contact Looker support if >500K rows

---

### Issue 2: Email delivery not working
**Cause:** Sharing permissions or authentication issue
**Solution:**
- Verify dashboard is shared with "Anyone with link can view"
- Check recipient email addresses (no typos)
- Ensure you have email delivery quota (Looker limits)
- Confirm timezone is correct (WAT = GMT+1)

---

### Issue 3: Mobile version looks broken
**Cause:** Fixed-width elements don't scale
**Solution:**
- Use percentage widths instead of pixels
- Enable "Auto-fit to mobile" in layout settings
- Test on actual mobile device (not just simulator)
- Simplify: Remove complex charts on mobile

---

### Issue 4: Cache not updating
**Cause:** Refresh schedule not triggered
**Solution:**
- Manual refresh: Data source → Refresh data
- Check schedule timezone matches server timezone
- Verify automatic refresh is enabled
- Look for error messages in data source logs

---

### Issue 5: Version history shows too many versions
**Cause:** Auto-save creates versions frequently
**Solution:**
- Manually name important versions only
- Delete unnecessary auto-saved versions
- Use naming convention to distinguish major/minor changes
- Export version before major redesign (backup)

---

## Evaluation Rubric

Your exercise will be assessed on:

| Criterion | Points | Description |
|-----------|--------|-------------|
| **Performance Optimization** | 30 | Data extract, caching, query optimization, load time <5 sec |
| **Scheduled Delivery** | 20 | Email configured, tested, PDF renders correctly |
| **Mobile Optimization** | 20 | Separate mobile version, layouts optimized, tested |
| **Collaboration Setup** | 15 | Sharing, versioning, commenting configured |
| **Documentation** | 10 | Change log, timestamps, clear instructions |
| **Measurable Improvement** | 5 | Before/after metrics documented, >40% improvement |
| **Total** | 100 | |

**Grading Scale:**
- 90-100: Production-ready, enterprise-grade dashboard
- 80-89: Good optimization, minor improvements needed
- 70-79: Functional, needs performance tuning
- Below 70: Significant optimization required

---

## Next Steps

After completing this exercise:

1. **Document optimizations:**
   - Create summary: What changed, why, impact
   - Share learnings with team

2. **Monitor performance:**
   - Week 1: Check load times daily
   - Week 2-4: Weekly monitoring
   - Set alerts for performance degradation

3. **Gather user feedback:**
   - Email team after first scheduled delivery
   - Ask: Is mobile version usable?
   - Iterate based on feedback

4. **Plan next optimizations:**
   - Quarterly review of dashboard performance
   - Archive old data to maintain speed
   - Upgrade to premium connectors if needed (BigQuery, etc.)

---

## Additional Resources

- **Performance Optimization Checklist:** See resource file for complete guide
- **Looker Studio Limits:** support.google.com/datastudio → "Quota limits"
- **Data Extract Best Practices:** Looker community forum
- **Mobile Design Guidelines:** Google Material Design for mobile dashboards
- **Email Delivery Troubleshooting:** Looker help center

---

**Estimated Completion Time:** 30 minutes (+ 10 minutes for bonuses)
**Difficulty:** Intermediate-Advanced
**Status:** Required Exercise

Remember: Performance optimization is not a one-time task. Monitor your dashboard regularly and optimize as data grows and usage patterns change. A fast, reliable dashboard gets used; a slow dashboard gets ignored.

Good luck optimizing! Your users will thank you for every second saved.
