# Exercise 2: Production Deployment — Complete Deployment Checklist

## Week 16 - Thursday - Exercise 2

### Estimated Time: 45 minutes

---

## Objective

Complete the full production deployment of your Olist executive dashboard by configuring embedding for your portfolio, writing comprehensive documentation, and preparing a 5-minute presentation for class. This exercise integrates all skills from Weeks 13-16 into a professional, submission-ready deliverable.

---

## Prerequisites

Before starting, ensure you have:
- ✅ Completed Thursday Exercise 1 (Sharing and Permissions)
- ✅ Shareable link saved from Exercise 1
- ✅ Completed Thursday Lectures 3 and 4 (Embedding + Documentation)
- ✅ All Wednesday optimizations implemented (pre-aggregated data source, data quality panel)

---

## Business Context

**Your Role:** BI Analyst completing the final handover package for the Olist executive dashboard.

**Deliverables for this exercise:**
1. Portfolio-ready embedded dashboard (public, interactive, shareable)
2. Complete dashboard documentation
3. 5-minute presentation outline
4. Final submission package

This exercise represents the complete lifecycle of a professional dashboard project: build → test → optimize → document → deploy → present → hand over.

---

## Instructions

### Part 1: Configure Dashboard for Portfolio Embedding

#### Task 1.1: Enable Embedding

1. Open your dashboard in View mode
2. Click **File** → **Embed report**
3. Toggle **"Enable embedding"** to **ON**
4. Copy the generated embed code

**Record:**
```
Embedding enabled: Yes / No
Embed code copied: Yes / No
```

The embed code should look like:
```html
<iframe
  width="600"
  height="450"
  src="https://lookerstudio.google.com/embed/reporting/YOUR-REPORT-ID/page/YOUR-PAGE-ID"
  frameborder="0"
  style="border:0"
  allowfullscreen
  sandbox="allow-storage-access-by-user-activation allow-scripts allow-same-origin allow-popups allow-popups-to-escape-sandbox">
</iframe>
```

#### Task 1.2: Configure the Embed Code for Your Portfolio

Customize the embed code following the guidelines from Lecture 3:

**Your customized embed code:**

```html
<!-- Copy and paste this into your portfolio website -->
<div style="max-width: 960px; margin: 0 auto;">

  <!-- Responsive embed wrapper -->
  <div style="position: relative; width: 100%; height: 0; padding-bottom: 62.5%;">
    <iframe
      style="position: absolute; top: 0; left: 0; width: 100%; height: 100%;"
      src="https://lookerstudio.google.com/embed/reporting/[YOUR-REPORT-ID]/page/[YOUR-PAGE-ID]"
      frameborder="0"
      allowfullscreen
      sandbox="allow-storage-access-by-user-activation allow-scripts allow-same-origin allow-popups allow-popups-to-escape-sandbox">
    </iframe>
  </div>

  <!-- Caption below the embed -->
  <p style="font-size: 14px; color: #555; margin-top: 12px; line-height: 1.5;">
    <strong>Olist E-Commerce Executive Dashboard</strong>
    — Google Looker Studio | PostgreSQL (Supabase) | Olist Brazilian Marketplace Dataset
    <br>
    99,441 orders | Sep 2016 – Aug 2018 | Key metrics: CLV segmentation,
    delivery performance, MoM revenue trends, marketing funnel analysis.
    <br>
    <a href="https://lookerstudio.google.com/reporting/[YOUR-REPORT-ID]"
       target="_blank" rel="noopener">
      View full interactive dashboard →
    </a>
  </p>

</div>
```

**Replace `[YOUR-REPORT-ID]` and `[YOUR-PAGE-ID]`** with the actual IDs from your Looker Studio embed code.

**Record:**
```
Report ID: _____________________________________________
Executive Summary page ID: _____________________________
Customized embed code: saved to notes / Google Doc / text file (circle one)
```

#### Task 1.3: Test the Embed in Google Sites

If you have not already created a Google Sites portfolio page, do so now. If you have an existing portfolio website, embed using the HTML above.

**Option A: Google Sites (recommended — no coding required)**

1. Open **sites.google.com** → New site (or open your existing site)
2. Navigate to the page where you want to embed the dashboard
3. Click **Insert** → **Embed**
4. Paste your Looker Studio report URL (not the embed code):
   ```
   https://lookerstudio.google.com/reporting/YOUR-REPORT-ID
   ```
5. Click **Insert**
6. Resize and position the embedded block
7. Add a text block below with your caption
8. Click **Publish**

[Screenshot: Google Sites editor showing the embedded Looker Studio dashboard]

**Record:**
```
Google Sites page created/updated: Yes / No
Dashboard embedded in Google Sites: Yes / No
Published Google Sites URL: ___________________________________
Dashboard visible on Google Sites: Yes / No
Tested in incognito (no Google sign-in): Yes / No
```

**Option B: Existing Portfolio Website (HTML)**

If you have a GitHub Pages or other personal website:
1. Add the customized embed code from Task 1.2 to your HTML file
2. Commit and push the changes
3. Verify the dashboard appears on your live portfolio page
4. Test in incognito mode

---

### Part 2: Complete the Dashboard Documentation

Use the template from Lecture 4. Fill in all sections for your specific dashboard.

#### Task 2.1: Write the Overview Section

In a Google Doc (or the last page of your Looker Studio report), write:

```
DASHBOARD NAME: Olist E-Commerce Executive Dashboard

PURPOSE:
[Write 2 sentences about what business questions this dashboard answers
and who uses it to make decisions.]
Example: "This dashboard tracks monthly revenue performance, customer
lifetime value distribution, delivery efficiency, and marketing funnel
conversion for the Brazilian Olist marketplace. It supports weekly
executive review and identifies operational priorities requiring action."

TARGET AUDIENCE:
[x] C-suite executives (strategic decisions)
[ ] Operations managers
[x] Data analytics team (technical review)
[ ] Marketing team
[ ] Other: _________________

KEY METRICS DISPLAYED:
Page 1 (Executive Summary):
- Total Revenue (MoM comparison)
- Order Count
- Average Order Value
- CLV Tier Distribution
- [Add your other metrics]

Page 2 ([Your page name]):
- [List metrics]

PAGE [N]: [Your page name]:
- [List metrics]

DASHBOARD URL: [Paste your Looker Studio report URL]
PORTFOLIO URL: [Paste your Google Sites or portfolio embed URL]
DATE CREATED: [Date]
LAST UPDATED: [Today's date]
```

#### Task 2.2: Write the Data Sources Section

Document each data source:

```
DATA SOURCE 1: Olist Monthly Executive KPIs
TYPE: Custom SQL — Pre-aggregated
CONNECTION: Supabase PostgreSQL
PROJECT ID: pzykoxdiwsyclwfqfiii
SCHEMAS: olist_sales_data_set, olist_marketing_data_set
REFRESH: Extract — Weekly Sunday 6:00 AM
CREDENTIALS: Owner's credentials
DATA RANGE: Sep 2016 – Aug 2018 (historical — does not change)
SQL QUERY: [paste the Query 2a SQL or reference validation-report.md Section 2a]

KNOWN LIMITATIONS:
- Marketing data ends May 2018 (5-month gap before sales data ends)
- Only 8 orders exist in final 30 days — effective end date is Aug 2018
- 2016 data sparse (startup period)
- All marketing cost figures are SIMULATED

REVENUE NOTE:
- Authoritative source: SUM(payment_value)
- Exceeds price + freight_value by 22.73% (expected: installments + vouchers)
- Never use declared_monthly_revenue from closed_deals (all zeros)

[Add additional data sources if you have more than one]
```

#### Task 2.3: Document Your Calculated Fields

List every calculated field you created. Use the format from Lecture 4.

Minimum required (Final Project requirement):

```
CALCULATED FIELD 1:
  Name: CLV Tier
  Formula:
    CASE
      WHEN total_spend > 5000 THEN "Premium"
      WHEN total_spend > 2000 THEN "High"
      WHEN total_spend > 500  THEN "Medium"
      ELSE "Standard"
    END
  Purpose: Customer lifetime value segmentation for retention prioritization
  Thresholds: Validated against Olist data (max customer = $13,664)
  Type: Text (dimension)
  Used in: [Chart names]

CALCULATED FIELD 2:
  Name: MoM Growth %
  Formula: Use mom_growth_pct column directly (pre-calculated in SQL using LAG)
  Purpose: Month-over-month revenue growth comparison
  Note: LAG() not supported in Looker Studio; pre-calculated in SQL source
  Type: Number (percentage)
  Used in: [Chart names]

CALCULATED FIELD 3:
  Name: [Your field name]
  Formula: [Your formula]
  Purpose: [Business description]
  Type: [Data type]
  Used in: [Chart names]

[Continue for all calculated fields — minimum 5 for Final Project]
```

#### Task 2.4: Write the Maintenance Section

```
DASHBOARD OWNER: [Your full name]
EMAIL: [Your email]
LAST UPDATED: [Today's date]

HOW TO REFRESH DATA:
1. Resource → Manage added data sources
2. Edit data source
3. Extract tab → Refresh now
4. Wait for confirmation

HOW TO ADD A NEW CHART:
1. Enter Edit mode (pencil icon)
2. Insert → Chart → Select chart type
3. Configure dimension, metric, and date range
4. Exit Edit mode

HOW TO MODIFY SQL DATA SOURCE:
1. Resource → Manage added data sources → Edit
2. Modify the custom query
3. Click "Reconnect" to refresh available fields
4. Update any charts that use renamed or removed fields

KNOWN LIMITATIONS:
1. Delivery performance shows 92% "On Time" vs Olist's estimated date
   — Olist set very conservative estimates (avg 12.7 days early)
   — This is correct behavior, not a data error

2. Marketing cost data is SIMULATED throughout
   — All CAC and ROI figures use illustrative estimates
   — Label as "SIMULATED" on any chart displaying these fields

3. 2,965 orders (2.98%) excluded from delivery metrics
   — These are cancelled or undelivered orders
   — Intentional — cannot calculate delivery time for undelivered orders

4. Revenue = SUM(payment_value) from payments table
   — 22.73% higher than price + freight — this is expected and documented

5. Dataset effectively ends August 2018
   — Set default date filters to Jan 2017 – Aug 2018

SUPPORT: [Your name] | [Your email]
         Looker Studio help: support.google.com/looker-studio
```

**Record:**
```
Documentation complete: Yes / No
All 4 sections written: Yes / No
Documentation location: Last dashboard page / Google Doc / Both (circle one)
```

---

### Part 3: Prepare Your 5-Minute Presentation

You will present your dashboard to the class. Prepare your talking points using this outline.

#### Task 3.1: Presentation Outline

Fill in the blanks:

```
PRESENTATION OUTLINE: Olist E-Commerce Executive Dashboard

MINUTE 1: Dashboard Introduction (Context)
"I built this dashboard to [state the business purpose].
It answers three key questions:
  1. [Question 1]
  2. [Question 2]
  3. [Question 3]
My audience is [audience type]."

[Navigate to your executive summary page]

MINUTE 2: Executive Summary Walk-Through
"This is the executive summary. I'll highlight three things:
  First: [KPI 1 — what it shows and why it matters]
  Second: [KPI 2 — what it shows and why it matters]
  Third: [Key insight — the main finding a stakeholder should act on]"

[Navigate to a second page / apply a filter]

MINUTE 3: Technical Feature Demonstration
"I want to show you one technical feature I'm proud of:
[Choose one of the following and explain it:]
  a) How I used pre-aggregated SQL to fix a 28% revenue inflation
  b) How the CLV segmentation was validated against actual data thresholds
  c) How I handled the 2.98% NULL rate in delivery dates
  d) How the MoM growth is pre-calculated in SQL because Looker Studio
     does not support window functions"

MINUTE 4: Data Quality Transparency
"Every production dashboard should document its limitations.
Mine has three notable ones:
  1. [Limitation 1 — e.g., marketing costs are simulated]
  2. [Limitation 2 — e.g., dataset ends effectively Aug 2018]
  3. [Limitation 3 — e.g., 2.98% of orders excluded from delivery metrics]
I documented these in [location of documentation]."

MINUTE 5: Sharing and Portfolio
"The dashboard is production-ready:
  - Configured with [describe your sharing settings]
  - Scheduled email delivery: [describe schedule]
  - Embedded in my portfolio: [show Google Sites page if possible]
  - Full documentation: [reference]
Thank you. Questions?"
```

#### Task 3.2: Rehearse Your Presentation

Time yourself with the outline above. Target: exactly 5 minutes.

**Tips:**
- Practice clicking between pages during your narration
- Know which filter you will apply (and what insight it reveals)
- Have your portfolio embed URL ready to open if asked
- Prepare for the most likely question: "What was the hardest technical challenge?"

**Record:**
```
Timed rehearsal: _____ minutes (target: 5 minutes)
Rehearsed once: Yes / No
Adjusted timing: Yes / No
```

---

### Part 4: Final Submission Package

Compile everything you need to submit for the Final Project.

#### Task 4.1: Submission Checklist

Verify every required element is complete:

```
DATA CONNECTION (10%)
☐ Supabase PostgreSQL connection to olist_sales_data_set
☐ At least 2 Olist tables used (orders + payments minimum)
☐ Data source documented (connection details, refresh schedule)

CALCULATED FIELDS (20%)
☐ CLV Tier: CASE WHEN total_spend > 5000 / 2000 / 500
☐ Marketing CAC: simulated_cac_usd (pre-calculated) — labeled SIMULATED
☐ Financial KPI with MoM: mom_growth_pct (pre-calculated via LAG in SQL)
☐ Period comparison: MoM or YoY using built-in comparison OR SQL pre-calc
☐ Custom categorization: delivery_category or other CASE field
☐ [Additional fields to total minimum 5]

VISUALIZATIONS (25%)
☐ Executive scorecards (min 3: Revenue, Orders, AOV)
☐ Time series trend (Revenue over time)
☐ Geographic analysis (Brazil state revenue map)
☐ Comparative analysis (bar chart: categories or channels)
☐ Detailed table (top customers, states, or sellers)
☐ [Additional charts to total minimum 8 across minimum 3 pages]

INTERACTIVITY (20%)
☐ Date range control configured with appropriate default
☐ At least 2 dimension filters (state filter, category filter, or similar)
☐ Cross-chart filtering (filters on one chart affect others)
☐ Drill-down: navigation to a detail page from summary page

DESIGN (15%)
☐ Consistent color scheme (same palette across all pages)
☐ Dashboard title and page titles descriptive and professional
☐ Charts have titles (not generic "Scorecard", "Chart 1")
☐ Mobile preview checked (View → Mobile preview)
☐ No overlapping or cramped charts
☐ Data quality notes visible (footer text boxes)

SHARING AND DOCUMENTATION (10%)
☐ Instructor access: Viewer (email sent with message)
☐ Link sharing: "Anyone with link can view"
☐ Scheduled email: Weekly Monday PDF, Page 1 only, sent to own email
☐ Embed configured and tested in Google Sites or portfolio website
☐ Documentation complete: all 4 sections written
☐ PDF export downloaded (all pages, high resolution)
```

#### Task 4.2: Compile Your Submission

Prepare the following for submission to your instructor:

**Email subject:** "Week 16 Final Project — Olist Dashboard — [Your Name]"

**Email body:**

```
Hi [Instructor name],

Please find my Week 16 Final Project submission:

DASHBOARD LINK:
[Looker Studio shareable link]

PORTFOLIO EMBED:
[Google Sites URL or portfolio website URL]

DOCUMENTATION:
[Google Doc link OR note that documentation is the last page of the dashboard]

KEY METRICS INCLUDED:
- CLV Tier segmentation (Premium/High/Medium/Standard)
- MoM Revenue Growth (pre-calculated via SQL LAG)
- Delivery Performance vs Estimated Date
- Marketing CAC by channel (SIMULATED — clearly labeled)
- Geographic Revenue by Brazilian state

DATA QUALITY NOTES:
- Revenue source: payment_value (authoritative, 22.73% above price+freight)
- Delivery metrics exclude 2,965 undelivered orders (2.98%)
- Dataset active period: Jan 2017 – Aug 2018
- Marketing cost data is SIMULATED throughout

I will present this dashboard on [presentation date].

Best regards,
[Your name]
```

**Record:**
```
Submission email drafted: Yes / No
All links included and tested: Yes / No
All checklist items ☑: Yes / No
Items still pending: ___________________________________
```

---

## Submission Checklist

```
PART 1: EMBEDDING
☐ Embedding enabled: File → Embed report → Enable embedding
☐ Embed code customized (responsive wrapper, caption, link)
☐ Dashboard embedded in Google Sites or portfolio website
☐ Portfolio embed URL saved and working
☐ Incognito test passed (loads without Google sign-in)

PART 2: DOCUMENTATION
☐ Section 1: Overview — purpose, audience, key metrics, URLs
☐ Section 2: Data Sources — SQL query, refresh, limitations
☐ Section 3: Calculated Fields — all fields documented with formulas
☐ Section 4: Maintenance — owner, procedures, known limitations
☐ Documentation location: [last dashboard page / Google Doc]

PART 3: PRESENTATION
☐ 5-minute outline written (all 5 minutes planned)
☐ Timed rehearsal completed
☐ Technical challenge prepared (which one you will explain)
☐ Known limitations prepared (which 3 you will mention)

PART 4: SUBMISSION
☐ All Final Project checklist items verified
☐ Submission email drafted
☐ All links tested and working
☐ PDF export ready (all pages, high resolution)
```

---

## Troubleshooting

### Issue 1: Google Sites embed shows "Preview unavailable"

**Solution:**
- Use the regular report URL (not the iframe embed code) in Google Sites
- Confirm the report sharing is set to "Anyone with the link can view"
- If it still fails, try: in the Looker Studio report, File → Embed report → copy the URL from the src attribute of the iframe, then paste just that URL into Google Sites → Embed

### Issue 2: Portfolio website embed shows blank iframe

**Solution:**
1. Verify the report sharing is "Public on the web" (not just "Anyone with link" — some embedding requires truly public access)
2. Test the embedded URL by pasting it directly in a browser — if it loads there, the iframe should work
3. Ensure you are using the `/embed/` version of the URL (the iframe src URL, not the regular report URL)
4. Check that the sandbox attributes are all present on the iframe element

### Issue 3: Presentation runs over 5 minutes in rehearsal

**Solution:** Identify which sections are overrunning:
- Minute 1 (Introduction): Trim to 2-3 sentences maximum
- Minute 2 (Walk-through): Show 3 things, not 5 — quality over quantity
- Minute 3 (Technical): Pick your ONE best technical achievement
- Minute 4 (Data quality): State 3 limitations in one sentence each
- Minute 5 (Sharing): Show the embed, share the link, done

### Issue 4: Documentation is very long — where does it go?

**Best approach:** Split it:
- **In-dashboard (last page):** Overview + Known Limitations (1 page, text boxes)
- **External Google Doc:** Full technical documentation (all 4 sections)
- **Submission email:** Link to both

This keeps the dashboard self-contained for casual viewers while providing full documentation for technical reviewers.

---

## Expected Outcomes

At the end of this exercise, you have:

```
PRODUCTION DEPLOYMENT PACKAGE
┌──────────────────────────────────────────────────────────┐
│ Dashboard (Looker Studio)                                │
│   URL: [your shareable link]                            │
│   Access: Anyone with link → Viewer                     │
│   Instructor: Direct Viewer access                      │
│   Schedule: Weekly Monday 7AM PDF to self               │
│   Embed: Enabled                                        │
├──────────────────────────────────────────────────────────┤
│ Portfolio (Google Sites / Personal website)             │
│   URL: [your portfolio URL]                             │
│   Dashboard: Embedded and responsive                    │
│   Caption: Project description with tech stack          │
│   Link: Full dashboard link below embed                 │
├──────────────────────────────────────────────────────────┤
│ Documentation (Google Doc or last dashboard page)       │
│   Section 1: Overview ✓                                 │
│   Section 2: Data Sources ✓                             │
│   Section 3: Calculated Fields ✓                        │
│   Section 4: Maintenance ✓                              │
├──────────────────────────────────────────────────────────┤
│ Presentation (5 minutes)                                │
│   Outline written ✓                                     │
│   Rehearsed ✓                                           │
│   Ready for class ✓                                     │
└──────────────────────────────────────────────────────────┘
```

---

## How to Know You Succeeded

✅ **Embed test:** A classmate or family member can open your portfolio URL and see the interactive dashboard without having a Google account or clicking any login button

✅ **Documentation test:** You can hand your documentation to a classmate who was not in this class, and they can understand what the dashboard shows, where the data comes from, and what limitations it has

✅ **Presentation test:** Your 5-minute rehearsal stayed within 5:30 minutes and covered all five sections

✅ **Submission test:** Your submission email contains all required links and they all work when you click them

---

## Reflection Questions

1. **You spent four weeks building this dashboard. What is the single most important thing you learned that you could not have learned from a textbook?**

2. **A recruiter opens your portfolio website and sees your embedded dashboard. What three things do you want them to notice first? Have you designed your dashboard and caption to emphasize those three things?**

3. **If you were to rebuild this dashboard from scratch, what would you do differently? Consider data sources, calculated fields, chart choices, and documentation.**

4. **The documentation template has four sections. Which section do you think is most important for long-term dashboard sustainability? Why?**

5. **You found a 28% revenue inflation error during the performance audit. Looking back on Weeks 13-15, is it possible that any of your earlier dashboards showed inflated revenue? What does this imply about the importance of the validation step?**

---

## Month 5 Completion

Upon submitting this exercise, you have completed:

```
✅ Week 13: Looker Studio Fundamentals
   → Data connections, chart types, basic dashboards

✅ Week 14: Interactive Dashboards
   → Controls, filters, cross-chart interaction, multi-page reports

✅ Week 15: Advanced Analytics & Data Storytelling
   → Calculated fields, period comparisons, narrative design

✅ Week 16: Production Dashboards
   → Optimization, data quality, sharing, embedding, documentation

DELIVERABLE: A production-grade, fully deployed, documented,
             embedded, portfolio-ready BI dashboard.

This joins your SQL and Python projects in your professional portfolio.
```

**Congratulations on completing Month 5 — Visualization.**

---

**Instructor Note:** This exercise is the culmination of the entire visualization module. Students who have been gradually building their dashboard across Weeks 13-15 may feel this exercise is more straightforward than earlier exercises — that feeling is the point. Production deployment should be a systematic process, not a creative one. The creativity happened during building. Deployment is about rigor, consistency, and completeness. Grade harshly on documentation completeness — a well-built dashboard with no documentation is a professional half-measure.
