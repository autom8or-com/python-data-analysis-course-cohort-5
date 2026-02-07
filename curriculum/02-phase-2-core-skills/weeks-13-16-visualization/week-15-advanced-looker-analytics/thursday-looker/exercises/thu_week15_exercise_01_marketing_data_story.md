# Exercise 1: Marketing Performance Data Story Dashboard

## Week 15 - Thursday - Exercise 1

### Estimated Time: 45 minutes

---

## Objective

Build a complete data storytelling dashboard that guides stakeholders through Olist's marketing performance, highlighting key insights and providing actionable recommendations. Apply all techniques learned this week: progressive disclosure, annotations, anomaly highlighting, and executive summary design.

---

## Prerequisites

Before starting, ensure you have:
- ✅ Completed Week 15 Wednesday exercises (Complex Calculated Fields, YTD Tracking)
- ✅ Active data source with olist_marketing_data_set and olist_sales_data_set
- ✅ Understanding of data storytelling principles and progressive disclosure
- ✅ Completed Thursday Lectures 1-4 (Story Principles, Annotations, Insights, Executive Design)

---

## Business Context

**Your Role:** Senior BI Analyst presenting to Olist's CMO (Chief Marketing Officer)

**Scenario:** The CMO needs to understand:
1. **What happened:** Marketing performance Q3 2018
2. **Why it matters:** Impact on revenue and customer acquisition
3. **What to do:** Specific actions to improve marketing ROI

**Critical Business Questions:**
- Which marketing channels drive the most revenue?
- Is our lead-to-customer conversion rate improving?
- What's our customer acquisition cost (CAC) by channel?
- Should we reallocate marketing budget based on performance?

**Validation Report Note:** Marketing cost data doesn't exist in Olist dataset. We'll use simulated values for learning purposes.

---

## Instructions

### Part 1: Create Executive Summary Page

#### Task 1.1: Set Up New Dashboard

1. Create new Looker Studio report
2. Title: **"Olist Marketing Performance - Q3 2018 Executive Summary"**
3. Rename Page 1 to: **"Executive Summary"**

---

#### Task 1.2: Build Top-Row KPI Scorecards

Create **5 KPI scorecards** across the top in this order:

**Scorecard 1: Total Leads Generated**

**Metric:** `COUNT(DISTINCT mql_id)` from marketing_qualified_leads

**Calculation:**
```
COUNT(DISTINCT mql_id)
```

**Configuration:**
- Title: "Marketing Qualified Leads"
- Date Range: Q3 2018 (Jul 1 - Sep 30)
- Comparison: Enable "Previous period" (Q2 2018)
- Format: Whole number with thousands separator (8,000)

**Expected Result:** ~2,600 leads in Q3

**Conditional Formatting:**
- Green: Growth ≥10%
- Yellow: Growth 0-10%
- Red: Decline <0%

---

**Scorecard 2: Lead-to-Customer Conversion Rate**

**Business Definition:** % of marketing leads that became paying customers

**Note:** Olist dataset doesn't link MQLs to customers directly. Use closed_deals as proxy.

**Metric:** `(COUNT(DISTINCT closed_deals) / COUNT(DISTINCT mql_id)) * 100`

**Calculated Field Name:** `Lead_Conversion_Rate`

**Formula:**
```
(COUNT(DISTINCT business_segment) / COUNT(DISTINCT mql_id)) * 100
```
**Note:** Use `business_segment` from closed_deals as proxy for converted customers (real implementation would join MQL to actual customer orders)

**Configuration:**
- Title: "Conversion Rate"
- Format: Percentage, 1 decimal (e.g., 4.8%)
- Comparison: vs Q2 2018

**Expected Result:** ~4-5% (from validation report: 4.75% overall)

**Conditional Formatting:**
- Green: ≥6% (industry benchmark)
- Yellow: 4-6%
- Red: <4%

---

**Scorecard 3: Customer Acquisition Cost (CAC)**

**Business Definition:** Marketing spend per acquired customer

**Simulated Calculation (since cost data unavailable):**

**Field Name:** `Simulated_CAC`

**Formula:**
```
CASE origin
  WHEN "paid_search" THEN 75
  WHEN "social" THEN 45
  WHEN "email" THEN 15
  WHEN "organic_search" THEN 5
  WHEN "referral" THEN 10
  WHEN "direct_traffic" THEN 8
  ELSE 25
END
```

**Configuration:**
- Title: "Avg Customer Acquisition Cost"
- Format: Currency ($75)
- Suffix: "per customer"
- Comparison: vs Q2

**Add Disclaimer Text Box:**
"⚠️ Note: CAC values are simulated for educational purposes (actual campaign cost data not available in dataset)"

---

**Scorecard 4: Top Performing Channel**

**Metric:** Channel with most leads

**Implementation:**

Create **Text Box** (not scorecard) that displays:

**Content:**
```
Top Channel: Paid Search
2,156 leads (42% of total)
```

**How to Determine:**
1. Create separate bar chart filtered to Q3
2. Dimension: `origin`
3. Metric: `COUNT(DISTINCT mql_id)`
4. Identify top channel
5. Manually enter into text box

**Alternative (Dynamic):** Use scorecard with `origin` dimension, sorted by lead count descending, limit 1.

---

**Scorecard 5: Marketing ROI**

**Business Definition:** Revenue generated per dollar spent on marketing

**Simulated Calculation:**

**Field Name:** `Simulated_Marketing_ROI`

**Formula:**
```
CASE
  WHEN Simulated_CAC > 0 THEN
    (AVG(SUM(payment_value)) / Simulated_CAC) * 100
  ELSE NULL
END
```

**Note:** This assumes average customer value = payment_value from first order. Real ROI would use CLV.

**Configuration:**
- Title: "Marketing ROI"
- Format: Percentage (250% = $2.50 returned per $1 spent)
- Conditional Formatting:
  - Green: >200%
  - Yellow: 100-200%
  - Red: <100% (losing money)

---

#### Task 1.3: Add Executive Summary Text Box

Below the KPIs, add a **Text Box** with 2-3 sentence narrative:

**Template:**
```
┌──────────────────────────────────────────────────────────┐
│ 📊 EXECUTIVE SUMMARY                                     │
├──────────────────────────────────────────────────────────┤
│ Q3 generated 2,600 marketing qualified leads (+8% vs Q2)│
│ but conversion rate remains flat at 4.8% (below 6%       │
│ industry benchmark). Paid search drives 42% of leads but │
│ has highest CAC ($75/customer). Recommendation:          │
│ Optimize paid search campaigns and scale organic search  │
│ (lowest CAC at $5).                                      │
└──────────────────────────────────────────────────────────┘
```

**Styling:**
- Background: Light blue (#E8F5FD)
- Border: 2px solid blue (#4285F4)
- Font: 14px, left-aligned
- Position: Full width below KPIs

---

### Part 2: Create Main Trend Visualization

#### Task 2.1: Build Leads Over Time Chart

**Goal:** Show lead generation trend with annotations

1. Add **Time Series Chart** (large, center of page)

2. Configure:
   - **Dimension:** `first_contact_date` (from marketing_qualified_leads)
   - **Date Granularity:** Week
   - **Metric:** `COUNT(DISTINCT mql_id)` → "Leads Generated"
   - **Date Range:** Q3 2018 (Jul 1 - Sep 30, 2018)

3. Style:
   - **Title:** "Marketing Lead Generation: Q3 Shows Steady Growth"
   - **Line color:** Green (#34A853)
   - **Line thickness:** 3px
   - **Fill:** Enable area under line, 60% opacity

4. **Add Trend Line:**
   - Style tab → Trend line → Enable
   - Type: Linear
   - Color: Gray dotted line

**Expected Visual:** Upward trending line showing lead growth over Q3.

---

#### Task 2.2: Add Annotations to Trend Chart

**Annotation 1: Peak Week**

Identify the week with most leads (likely late August or early September).

1. Add **Text Box** positioned above that peak point
2. Content: "Peak Week: 380 leads (Campaign launch)"
3. Add arrow emoji pointing down: ↓
4. Position directly above peak

**Annotation 2: Reference Line**

Add reference line showing Q2 average for comparison:

1. Chart → Style → Reference lines → Add
2. Value: Calculate Q2 avg (if ~600 leads / 13 weeks = ~46/week)
3. Label: "Q2 Avg: 46 leads/week"
4. Color: Orange dashed line

**Insight:** Q3 consistently above Q2 average = positive growth.

---

### Part 3: Build Channel Performance Breakdown (Progressive Disclosure Level 2)

#### Task 3.1: Create Channel Performance Bar Chart

1. Add **Bar Chart** (horizontal)

2. Configure:
   - **Dimension:** `origin` (marketing channel)
   - **Metrics:**
     - `COUNT(DISTINCT mql_id)` → "Leads"
     - **Add 2nd metric:** Create `Leads_Percentage`

**Calculated Field:** `Leads_Percentage`

**Formula:**
```
(COUNT(DISTINCT mql_id) / SUM(COUNT(DISTINCT mql_id))) * 100
```

   - **Sort:** By Leads (descending)

3. Style:
   - **Title:** "Lead Generation by Channel: Paid Search Dominates"
   - **Bar colors:** Gradient from dark blue (top) to light blue (bottom)
   - **Data labels:** Show both count and percentage
   - **Bar width:** Medium thickness

**Expected Result:**
```
paid_search       ████████████████████ 2,156 (42%)
organic_search    ████████ 856 (17%)
social            ██████ 624 (12%)
email             █████ 520 (10%)
...
```

---

#### Task 3.2: Add Channel Efficiency Table

Below the bar chart, add a **Table** showing CAC and conversion metrics:

**Configuration:**
- **Dimension:** `origin`
- **Metrics:**
  - `COUNT(DISTINCT mql_id)` → "Leads"
  - `Lead_Conversion_Rate` → "Conv Rate %"
  - `Simulated_CAC` → "CAC ($)"
  - Create: `Cost_Per_Lead` = `Simulated_CAC * COUNT(DISTINCT mql_id)`
- **Sort:** By CAC (ascending) to show most efficient channels first

**Conditional Formatting:**
- **Conv Rate:** Green if >6%, Yellow 4-6%, Red <4%
- **CAC:** Green if <$25, Yellow $25-50, Red >$50

**Add Table Title:**
"Channel Efficiency Analysis: Organic Search Most Cost-Effective"

---

### Part 4: Build Recommendations Section

#### Task 4.1: Create Recommendations Panel

Add a **Rectangle Shape** (right sidebar or bottom section):

**Dimensions:** ~300px wide × 400px tall

**Styling:**
- Background: Light yellow (#FFF9C4) for attention
- Border: 3px solid orange (#FF9800)

Inside the rectangle, add **Text Boxes** for each recommendation:

```
┌─────────────────────────────────────────────┐
│ 🚀 TOP 3 MARKETING ACTIONS                  │
├─────────────────────────────────────────────┤
│                                             │
│ 1. 🔴 Optimize Paid Search Campaigns        │
│    Problem: Highest CAC ($75) but largest   │
│    volume (42% of leads)                    │
│    Owner: Paid Media Manager                │
│    Action: A/B test ad copy + keywords      │
│    Timeline: Oct 15 | Target: Reduce CAC to │
│    $60 (-20%) while maintaining volume      │
│                                             │
│ 2. 🟡 Scale Organic Search (SEO)            │
│    Opportunity: Lowest CAC ($5) with strong │
│    conversion (5.2%)                        │
│    Owner: Content Marketing Lead            │
│    Action: Publish 20 SEO-optimized blogs   │
│    Timeline: Nov 30 | Target: +30% organic  │
│    traffic = +250 leads/month               │
│                                             │
│ 3. 🟢 Launch Referral Program               │
│    Data: Referral has 2nd lowest CAC ($10)  │
│    but only 8% of leads                     │
│    Owner: Growth Marketing                  │
│    Action: Implement refer-a-friend rewards │
│    Timeline: Dec 1 | Target: Double referral│
│    leads from 200 → 400/month               │
│                                             │
└─────────────────────────────────────────────┘
```

---

### Part 5: Add Progressive Disclosure Navigation

#### Task 5.1: Create Multi-Page Report

1. Add 3 new pages to your report:
   - Page 2: "Channel Deep Dive"
   - Page 3: "Conversion Funnel Analysis"
   - Page 4: "Data Explorer"

2. **Page 1 (Executive Summary):** Already built above

3. **Page 2 (Channel Deep Dive):**

Content:
- **Title:** "Marketing Channel Performance - Detailed Analysis"
- **Dropdown Filter:** Allow users to select specific channel
- **Charts when filtered to channel:**
  - Lead generation trend for that channel only
  - Geographic distribution (which states generate most leads)
  - Lead type breakdown (online_medium, online_big, etc.)
  - Conversion rate by lead type

4. **Page 3 (Conversion Funnel):**

Content:
- **Title:** "Lead-to-Customer Conversion Funnel"
- **Funnel visualization:**
  ```
  MQLs Generated:     8,000  ████████████████████
                             ↓ 15% qualify
  SQL (Sales Qualified): 1,200  ███████████
                             ↓ 32% close
  Closed Deals:         380  ████
  ```
- **Conversion rate by business segment**
- **Average days from MQL to close**

5. **Page 4 (Data Explorer):**

Content:
- **Title:** "Marketing Data Explorer - Custom Analysis"
- **Interactive controls:**
  - Date range selector
  - Channel multi-select
  - Lead type filter
- **Detailed table:** All marketing metrics with export capability

---

#### Task 5.2: Add Navigation Menu

At top of Page 1, add navigation buttons:

1. Insert **Text Box** with hyperlinks:

```
[📊 Executive Summary] [📈 Channel Deep Dive] [🔄 Conversion Funnel] [📁 Data Explorer]
        ↑ You are here
```

2. Make each label a hyperlink:
   - Select text → Insert link → Select page

**Or use Looker Studio built-in navigation:**
- View → Navigation → Show page navigation

---

### Part 6: Final Touches - Annotations and Insights

#### Task 6.1: Add Callout Box for Main Insight

At top of dashboard (below summary text), add **prominent callout:**

```
┌──────────────────────────────────────────────────────┐
│ ⚠️ KEY INSIGHT: Channel Imbalance                    │
├──────────────────────────────────────────────────────┤
│ Paid search drives 42% of leads but has 15x higher  │
│ CAC than organic search ($75 vs $5). Rebalancing    │
│ strategy could reduce acquisition cost by $120K/year│
│ while maintaining lead volume.                       │
│                                                      │
│ Calculation: 1,000 leads shifted from paid → organic│
│ = $70 saved per lead × 1,000 = $70K/quarter         │
└──────────────────────────────────────────────────────┘
```

**Styling:**
- Background: Light orange (#FFE0B2) for visibility
- Border: 4px solid orange
- Font: 16px bold title, 14px body
- Position: Center, prominent

---

#### Task 6.2: Add Data Quality Disclaimer

At bottom of dashboard, add small footnote:

```
📝 Data Notes:
- Lead data: Jun 2017 - May 2018 (olist_marketing_qualified_leads)
- Q3 2018 data extrapolated for exercise purposes
- CAC values are simulated (actual campaign cost data not available)
- Conversion rate uses closed_deals as proxy (actual order linkage unavailable)
```

**Font:** 10px, gray (#757575)

---

### Part 7: Test and Validate

#### Task 7.1: Run Through User Journey

**Executive Persona Test:**

1. Load Page 1 (Executive Summary)
2. Time yourself: Can you understand main message in 5 seconds?
   - Expected: "Paid search has high CAC, organic search is efficient"
3. Read full page: Can you identify top 3 actions in 3 minutes?
   - Expected: Yes—clearly listed in recommendations panel
4. Click drill-down: Does navigation work?
   - Expected: Smooth transition to Channel Deep Dive page

---

#### Task 7.2: 5-Second Test with Peer

1. Show dashboard to a classmate for 5 seconds
2. Hide it
3. Ask them: "What was the main problem or insight?"
4. **Success criteria:** They can articulate "Paid search is expensive, organic search is cheap"

If they can't, **redesign** to make insight more obvious.

---

#### Task 7.3: Mobile View Test

1. Looker Studio → View → Mobile preview
2. Verify:
   - ☐ KPI scorecards stack vertically (readable)
   - ☐ Charts don't overflow horizontally
   - ☐ Text size ≥14px (legible on phone)
   - ☐ Navigation buttons are touch-friendly (not tiny)

If issues, adjust layout for mobile responsiveness.

---

## Submission Checklist

Before marking complete, verify:

```
EXECUTIVE SUMMARY PAGE
☐ 5 KPI scorecards with conditional formatting (traffic lights)
☐ Executive summary text box (2-3 sentences)
☐ Main trend chart with annotations (peak week, reference line)
☐ Channel performance bar chart with data labels
☐ Channel efficiency table with conditional formatting
☐ Recommendations panel (3 prioritized actions)
☐ Key insight callout box prominently displayed

PROGRESSIVE DISCLOSURE
☐ Page 2: Channel Deep Dive created with filtered views
☐ Page 3: Conversion Funnel visualization
☐ Page 4: Data Explorer with interactive controls
☐ Navigation menu functional (can click between pages)

DATA STORYTELLING ELEMENTS
☐ Clear narrative flow (Problem → Evidence → Solution)
☐ Annotations explain anomalies and trends
☐ Color coding consistent (red=problem, green=good)
☐ Passes 5-second test (main message obvious)
☐ Recommendations are SMART (Specific, Measurable, Achievable, Relevant, Time-bound)

QUALITY CHECKS
☐ All metrics calculate correctly
☐ No "null" or "error" values visible
☐ Data source refreshed (showing latest data)
☐ Mobile-friendly (tested in mobile preview)
☐ Disclaimer added for simulated CAC values
```

---

## Troubleshooting

### Issue 1: "Lead Conversion Rate Shows 0% or NULL"

**Cause:** No link between marketing_qualified_leads and actual customer orders in Olist dataset

**Solution:** Use closed_deals as proxy:
```
(COUNT(DISTINCT business_segment from closed_deals) / COUNT(DISTINCT mql_id)) * 100
```

This is an approximation for educational purposes.

---

### Issue 2: "Q3 2018 Marketing Data Doesn't Exist"

**Symptom:** Charts show no data for Q3 2018

**Reality Check:** Olist marketing data range is Jun 2017 - May 2018 (from validation report)

**Solution:**
- **Option 1:** Change exercise to use Q2 2018 (Apr-Jun 2018) where data exists
- **Option 2:** Use all available data and adjust narrative to match actual date range
- **Option 3:** Note limitation and use Q4 2017 (Oct-Dec 2017) as proxy for Q3

**For learning purposes, use actual data range and adjust narrative accordingly.**

---

### Issue 3: "CAC Calculated Field Shows Same Value for All Channels"

**Cause:** Formula using CASE on origin but aggregation not grouping by origin

**Solution:** Ensure calculated field is dimension-level (no aggregation functions) or create separate field per channel.

---

### Issue 4: "Recommendations Panel Text Overflows Rectangle"

**Symptom:** Text doesn't fit inside background rectangle

**Solution:**
- Enlarge rectangle height
- Reduce font size (12px instead of 14px)
- Abbreviate text (use bullets, not paragraphs)
- Or remove rectangle, use text boxes only

---

## Expected Outcomes

### Final Dashboard Should Show:

**Page 1 (Executive Summary):**
```
┌──────────────────────────────────────────────────────────────┐
│ OLIST MARKETING PERFORMANCE - Q3 2018 EXECUTIVE SUMMARY      │
├──────────────────────────────────────────────────────────────┤
│ [MQLs: 2.6K] [Conv: 4.8%] [CAC: $75] [Top: Paid] [ROI: 250%]│
│   🟢 +8%      🟡 Flat      🔴 High     Search       🟢 Good  │
│                                                              │
│ 📊 Summary: 2,600 leads generated (+8% vs Q2) but conversion│
│ flat at 4.8% (below 6% benchmark). Paid search dominates    │
│ (42%) but has high CAC. Opportunity: Scale organic search.  │
│                                                              │
│ ⚠️ KEY INSIGHT: Channel imbalance - shifting 1K leads from   │
│ paid → organic could save $70K/quarter while maintaining vol│
│                                                              │
│ [Lead Generation Trend Chart - Annotated]                   │
│ [Channel Performance Bar Chart]                             │
│ [Channel Efficiency Table with Conditional Formatting]      │
│                                                              │
│ 🚀 ACTIONS: (1) Optimize paid search, (2) Scale organic SEO,│
│ (3) Launch referral program                                 │
└──────────────────────────────────────────────────────────────┘
```

**Business Value Delivered:**
- CMO sees health at glance (5-second scan: paid search expensive)
- Understands impact ($70K/quarter savings opportunity)
- Knows exactly what to do (3 prioritized actions with owners)
- Can drill down for details if needed (multi-page navigation)

---

## How to Know You Succeeded

✅ **Story Test:**
- Dashboard tells complete story: Paid search volume high but expensive → Organic search efficient → Shift budget to optimize
- Narrative flows logically from problem → evidence → solution

✅ **Executive Test:**
- CMO can make decision based on Page 1 alone (doesn't need to dig through data)
- Recommendations are specific enough to assign and execute
- Expected outcomes are quantified ($70K savings, +250 leads/month)

✅ **Design Test:**
- Passes 5-second test (peer can identify main insight)
- Passes squint test (key elements visible when blurred)
- Mobile-friendly (tested on tablet/phone)

✅ **Technical Test:**
- All metrics accurate (verified against validation report)
- Conditional formatting highlights problems (red/yellow/green)
- Navigation works smoothly between pages

---

## Reflection Questions

Answer these to test your understanding:

1. **Why did we use simulated CAC values instead of real data, and what would you do in a real-world scenario?**

2. **What's the difference between showing "paid search has 2,156 leads" vs "paid search has high CAC, shift to organic for efficiency"? Which is data storytelling?**

3. **How does progressive disclosure improve the executive experience in this dashboard?**

4. **If the CMO says "I don't have time to click through pages," what would you adjust?**

5. **Why include a recommendations panel instead of just showing charts and letting executives draw their own conclusions?**

---

## Next Steps

Once completed:
1. **Save dashboard** as "Week 15 - Marketing Data Story - [Your Name]"
2. **Present to instructor** (2-minute walkthrough as if presenting to CMO)
3. **Export to PDF** (File → Download → PDF) for portfolio
4. **Document learnings** - What worked? What would you change?

**Outstanding work!** You've built a complete data storytelling dashboard that transforms raw marketing data into strategic insights and actionable recommendations—a core skill for BI analysts and data storytellers.

---

## Additional Challenge (Optional)

If you finish early, enhance your dashboard:

### Challenge 1: Add Projected Impact Calculator

**Interactive Element:**
- Slider control: "Shift X leads from paid to organic"
- Real-time calculation: "Projected savings: $Y/quarter"
- Dynamic chart showing budget reallocation impact

### Challenge 2: Build A/B Test Visualization

**Scenario:** Marketing tested two ad variations

**Create:**
- Comparison table: Variation A vs B (conversion rate, CAC, ROI)
- Winner highlight: Which variation should they scale?

### Challenge 3: Add Competitive Benchmarking

**Research industry benchmarks:**
- E-commerce average conversion rate: 2-3%
- Average CAC: $50-$100
- Compare Olist performance to industry standards
- Highlight: "We're 60% above industry conversion rate (4.8% vs 3%) ✅"

---

**Instructor Note:** This capstone exercise integrates all Week 15 skills. Students should spend time on narrative and recommendations, not just building charts. The goal is storytelling, not chart mastery. Encourage peer review—students should present their dashboard to each other and get feedback on clarity and actionability. Common struggle: students focus on technical accuracy over business communication. Remind them: "Would a non-technical CMO understand your message?"
