# Dashboard Maintenance and Documentation

## Week 16 - Thursday Session - Part 4

### Duration: 20 minutes

---

## Why Documentation Is a Professional Responsibility

You have spent four weeks building visualization skills. You can create stunning dashboards with optimized data sources, calculated fields, interactive controls, and compelling data stories. But if the person maintaining your dashboard six months from now cannot understand what you built or why, the work has limited lasting value.

**Documentation is what transforms a personal project into a professional deliverable.**

In professional BI practice, undocumented dashboards are a liability. When the original analyst leaves or moves to another project:
- Who knows what the calculated fields actually compute?
- Who knows which revenue figure is authoritative ($payment_value, not $price+freight)?
- Who knows that August 2018 data is sparse and not representative?
- Who knows that marketing cost data is simulated?

These are time bombs waiting to surface as incorrect business decisions. Documentation defuses them.

### Connection to Prior Learning

In Week 15 (Data Storytelling), you learned to communicate insights clearly to business stakeholders. Today you apply that communication discipline to technical stakeholders — the next analyst who inherits your dashboard.

---

## The Four Components of Dashboard Documentation

Every production dashboard needs four categories of documentation:

1. **Overview** — what the dashboard does and who it serves
2. **Data Sources** — where data comes from, how it connects, and when it refreshes
3. **Calculated Fields** — what each custom formula computes and why
4. **Maintenance** — who owns it, how to update it, and known limitations

---

## The Dashboard Documentation Template

Use this template for your Final Project submission and for any professional dashboard you deliver.

---

### Section 1: Overview

```
DASHBOARD NAME:
[Your dashboard title — e.g., "Olist E-Commerce Executive Dashboard"]

PURPOSE:
[1-2 sentences describing what business question this dashboard answers]
Example: "This dashboard tracks monthly revenue, customer acquisition,
          delivery performance, and marketing funnel metrics for the
          Olist Brazilian marketplace. It supports weekly executive
          review and quarterly business planning."

TARGET AUDIENCE:
[ ] C-suite executives (strategic decisions)
[ ] Operations managers (day-to-day management)
[ ] Marketing team (campaign analysis)
[ ] Finance team (revenue reporting)
[ ] Technical analysts (ad-hoc exploration)

KEY METRICS DISPLAYED:
- [Metric 1]: [Brief description]
- [Metric 2]: [Brief description]
- [Continue for all metrics on Page 1]

DASHBOARD URL:
[Full Looker Studio URL]

PORTFOLIO EMBED URL (if applicable):
[Google Sites or personal website URL]

DATE CREATED:
[Date]

LAST UPDATED:
[Date]
```

---

### Section 2: Data Sources

```
DATA SOURCE NAME: Olist Monthly Executive KPIs
TYPE: Custom SQL (PostgreSQL/Supabase)
CONNECTION: Supabase — Project ID: pzykoxdiwsyclwfqfiii
SCHEMAS USED: olist_sales_data_set, olist_marketing_data_set
SQL QUERY: [Paste the full SQL query, or reference the file location]
REFRESH SCHEDULE: Weekly — Sunday 6:00 AM (WAT)
CONNECTION TYPE: Extract (cached)
CREDENTIAL TYPE: Owner's credentials
ACTIVE DATE RANGE: Sep 2016 – Aug 2018 (historical dataset — data does not change)

KNOWN LIMITATIONS:
- Marketing data ends May 2018; sales data ends Oct 2018 (5-month gap)
- Only 8 orders in final 30 days — effective end date is Aug 2018
- 2016 data sparse (startup period — exclude from trend analysis)
- All marketing cost figures are SIMULATED (real cost data unavailable)

REVENUE NOTE:
- Authoritative revenue source: SUM(payment_value) from olist_order_payments_dataset
- This exceeds price + freight_value by 22.73% (installment fees + vouchers — expected)
- Never use declared_monthly_revenue from closed_deals (all zeros)
```

Add a similar block for each data source in the report.

---

### Section 3: Calculated Fields

Document every custom formula you created. This is the most critical section — it is what allows someone else to audit or update your metrics.

```
FIELD NAME: CLV Tier
DATA SOURCE: [Name of data source]
FORMULA:
  CASE
    WHEN total_spend > 5000 THEN "Premium"
    WHEN total_spend > 2000 THEN "High"
    WHEN total_spend > 500  THEN "Medium"
    ELSE "Standard"
  END
PURPOSE: Segments customers by lifetime spend for retention prioritization
THRESHOLD RATIONALE: Validated against Olist data — max customer is $13,664
                     Original $500K threshold was unreachable (0 Premium customers)
DATA TYPE: Text (dimension)
USED IN CHARTS: [List chart names where this field appears]

---

FIELD NAME: Delivery Performance
DATA SOURCE: [Name of data source]
FORMULA:
  CASE
    WHEN delivery_category = "On Time" THEN "On Time (92%)"
    ELSE delivery_category
  END
  [OR: pre-calculated in SQL as delivery_category — use field directly]
PURPOSE: Categorizes orders by performance vs estimated delivery date
NOTE: Uses Olist's own estimated delivery date as benchmark
      Counterintuitive: 92% "On Time" because Olist set conservative estimates
      Average actual delivery is 12.7 days EARLIER than estimated
DATA TYPE: Text (dimension)

---

FIELD NAME: MoM Growth %
DATA SOURCE: Olist Monthly Executive KPIs (pre-calculated)
FORMULA: Use mom_growth_pct column directly — pre-calculated in SQL using LAG()
PURPOSE: Month-over-month revenue growth percentage
IMPORTANT: Do NOT recalculate in Looker Studio — LAG() is not supported
           in LS calculated fields; result comes from SQL pre-aggregation
DATA TYPE: Number (percentage)

---

FIELD NAME: Simulated CAC
DATA SOURCE: Olist Marketing Funnel (pre-calculated)
FORMULA: Use simulated_cac_usd column directly (SIMULATED — clearly labeled)
PURPOSE: Illustrative customer acquisition cost by channel
WARNING: Marketing cost data does not exist in the Olist database
         All cost figures are illustrative industry estimates only
         MUST be labeled as "SIMULATED" on every chart that displays this field
DATA TYPE: Number (currency)
```

Document all calculated fields following this pattern.

---

### Section 4: Filters and Controls

```
CONTROL: Date Range Selector (Page 1)
TYPE: Date range control
DEFAULT RANGE: Custom — Jan 1, 2017 to Aug 31, 2018
AFFECTS: All charts on Page 1
RATIONALE: Default range avoids the sparse 2016 startup period
           and the sparse Sep-Oct 2018 tail-off

CONTROL: State Filter (Geographic Page)
TYPE: Drop-down list
DATA SOURCE: Geographic Revenue (customer_state)
DEFAULT: All states
AFFECTS: All charts on the Geographic page only
NOTE: Two-letter state codes (SP, RJ, MG) — not full state names

CONTROL: Category Filter (Product Performance Page)
TYPE: Drop-down list (multi-select enabled)
DATA SOURCE: Product Category Performance (product_category)
DEFAULT: All categories
NOTE: Categories are in Portuguese — see translation table in resources
```

---

### Section 5: Maintenance

```
DASHBOARD OWNER: [Your full name]
EMAIL: [Your email address]
LAST UPDATED: [Date]

UPDATE SCHEDULE:
- Data refresh: Weekly automatic (Extract, Sunday 6 AM)
- Design updates: As needed when business requirements change
- Documentation updates: Whenever a calculated field or data source changes

HOW TO UPDATE THE DASHBOARD:
1. Open report → Click Edit (pencil icon)
2. Make changes to charts or calculated fields
3. If adding a new data source: Resource → Manage added data sources → Add
4. If modifying SQL: Edit data source → Edit (pencil) → Modify custom query
   → Click "Reconnect" to refresh schema
5. Test all affected charts after any change
6. Click "View" to exit edit mode before sharing with stakeholders

HOW TO REFRESH DATA MANUALLY:
1. Resource → Manage added data sources
2. Click Edit next to each data source
3. Click "Extract data" tab
4. Click "Refresh now"
5. Wait for confirmation

KNOWN LIMITATIONS:
1. Marketing data (MQL leads, closed deals) ends May 2018
   - Marketing page charts show ~12 months of data, not full dataset period
   - This is a dataset limitation, not a dashboard error

2. 2,965 orders (2.98%) excluded from delivery metrics
   - These are undelivered orders (cancelled, returned, in-transit)
   - Delivery performance charts do not include these orders
   - This is intentional — you cannot calculate delivery days for undelivered orders

3. Marketing cost data is simulated
   - All CAC and ROI figures use illustrative industry estimates
   - Real cost data does not exist in the Olist database
   - Any chart showing CAC or marketing ROI must display the "SIMULATED" disclaimer

4. Revenue cross-validation gap (22.73%)
   - payment_value exceeds price+freight by 22.73%
   - This is expected (installment fees, vouchers, multi-payment methods)
   - Always use payment_value as the authoritative revenue figure

SUPPORT CONTACT:
For questions about data or calculations, contact: [your name + email]
For technical Looker Studio issues: support.google.com/looker-studio
For database / Supabase access: [program instructor contact]
```

---

## Documenting for the Final Project

Your Final Project submission must include completed documentation. The documentation template above is the basis. For submission:

**Option 1: In-dashboard documentation**
Add a "Documentation" page as the last page of your report. Paste the documentation text boxes in Looker Studio. Viewers access the documentation without leaving the dashboard.

**Option 2: Separate document**
Create a Google Doc with the completed template. Share it alongside the dashboard URL. Include the doc link in your email to the instructor.

**Option 3: Both**
Best practice: brief summary in-dashboard (overview + known limitations), full technical documentation in a separate Google Doc.

---

## The Professional Handover Process

When you complete a dashboard project in a professional setting, the handover includes:

### Step 1: Technical Handover Meeting (30-45 minutes)

Walk the receiving analyst through:
- Where data comes from (data source SQL queries)
- What each calculated field does
- How to refresh data manually
- Known limitations and workarounds
- Where to find the documentation

### Step 2: Access Transfer

- Add the new owner as Editor or Owner in Looker Studio
- Share access to the Supabase database if they need to modify SQL
- Transfer scheduled email delivery to use their email as sender (if applicable)

### Step 3: Documentation Handoff

Email them:
- The complete documentation template (filled in)
- The SQL query files used as data sources
- Any reference materials (this performance optimization guide, data quality checklist)
- Contact information if questions arise

### Step 4: Verification Period (Optional but Professional)

Spend 1-2 weeks where both you and the new owner monitor the dashboard. If they encounter questions or issues, you are still available to help. After that period, full ownership transfers.

---

## Final Project Requirements Summary

This is the capstone of Month 5 (Visualization). Your dashboard will be evaluated on six criteria:

| Criterion | Weight | What to Include |
|-----------|--------|-----------------|
| Data Connection | 10% | Supabase PostgreSQL, 2+ tables, documented connection |
| Calculated Fields | 20% | Min 5 custom metrics: CLV Tier, Marketing CAC, Financial KPI with MoM, delivery category, at least one CASE field |
| Visualizations | 25% | Min 8 charts across 3+ pages: executive scorecards, time series, geographic, comparative, data table |
| Interactivity | 20% | Date range control, 2+ dimension filters, cross-chart filtering, drill-down |
| Design | 15% | Consistent branding, mobile-responsive, clear navigation, professional typography |
| Sharing & Documentation | 10% | Permissions configured, scheduled email, embed-ready, written documentation |

**Presentation Format (Thursday, Week 16):**
- 5-minute live demonstration
- Walk through dashboard features (not just scroll through pages)
- Highlight 2-3 key business insights
- Explain one technical decision (why you chose a specific chart type, or how you handled a data quality issue)
- Questions from instructor and classmates (2-3 minutes)

---

## Month 5 Completion: What You Have Built

Over the past four weeks, you have developed a complete set of production BI skills:

```
Week 13: Looker Studio Fundamentals
  → Data connections, chart types, basic formatting
  → Credential: First functional dashboard

Week 14: Interactive Dashboards
  → Controls, filters, cross-chart interaction, multi-page reports
  → Credential: Interactive stakeholder-ready dashboard

Week 15: Advanced Analytics & Data Storytelling
  → Calculated fields, period comparisons, narrative design, executive summaries
  → Credential: Insight-driven, presentation-ready dashboard

Week 16: Production Dashboards (Today)
  → Query optimization, data quality, sharing, scheduling, embedding, documentation
  → Credential: Production-grade, fully deployed, documented dashboard
```

This Looker Studio dashboard joins your SQL analysis (Weeks 1-6), Python analysis (Weeks 7-12), and specialized skills (Phase 3) as part of a growing professional portfolio.

---

## Key Takeaways

### What You Learned
1. ✅ Documentation protects your work from becoming unusable after you leave the project
2. ✅ Four components: Overview, Data Sources, Calculated Fields, Maintenance
3. ✅ Always document the "why" behind technical decisions (thresholds, filters, limitations)
4. ✅ Professional handover includes a meeting, access transfer, and documentation package
5. ✅ Final Project requires documentation as part of the Sharing & Documentation criterion (10%)
6. ✅ You have now completed Month 5 — Visualization — and hold a production-grade dashboard skill set

### Month 5 Complete

Congratulations on completing Weeks 13-16. You began with a blank Looker Studio canvas. You are finishing with:
- A production-optimized dashboard
- Validated data sources with proper quality controls
- Configured sharing, scheduling, and embedding
- Professional documentation

This is not a student exercise. This is what BI analysts produce for real organizations.

---

## Quick Reference Card

### Documentation Sections Checklist

```
SECTION 1: OVERVIEW
☐ Dashboard name and purpose
☐ Target audience
☐ Key metrics list
☐ Dashboard URL
☐ Creation and update dates

SECTION 2: DATA SOURCES
☐ Source name and connection details
☐ SQL query (or file reference)
☐ Refresh schedule
☐ Active date range
☐ Known limitations

SECTION 3: CALCULATED FIELDS
☐ Field name + formula
☐ Purpose (business meaning)
☐ Threshold rationale
☐ Data type
☐ Charts where used

SECTION 4: MAINTENANCE
☐ Owner contact
☐ Update procedure
☐ Manual refresh procedure
☐ Known limitations
☐ Support contacts
```

---

## Questions to Test Your Understanding

1. Why is documenting the threshold values in calculated fields (e.g., why $5,000 for Premium CLV, not $500,000) important?
2. Someone inherits your dashboard and notices revenue is $19.8M but the product category revenue totals only $16.1M. They assume there is a data error. How does your documentation prevent a panic?
3. In the Final Project criteria, Sharing & Documentation is 10% of the grade. A student focuses only on charts (25%) and ignores documentation entirely. What is the maximum grade they can achieve? What professional consequence does this simulate?
4. What is the difference between a dashboard owner transferring ownership and a dashboard owner sharing Editor access?
5. Why should you add a "Documentation" page as the last page of your Looker Studio report, rather than only keeping documentation in a separate Google Doc?

**Answers at the end of lecture notes**

---

## Additional Resources

- **Looker Studio Help:** [Sharing and collaboration best practices](https://support.google.com/looker-studio/answer/6313610)
- **Dashboard Documentation Template:** See resources/dashboard_documentation_template.md
- **Performance Optimization Guide:** See Wednesday resources/performance_optimization_guide.md
- **Data Quality Checklist:** See Wednesday resources/data_quality_checklist.md

---

## Answers to Questions

1. **Threshold documentation importance:** Without the rationale, a future analyst may "correct" the $5,000 threshold to $50,000 thinking it is more impressive. But the Olist dataset's maximum customer spend is $13,664 — at $50,000, zero customers would qualify as Premium and the metric becomes meaningless. Documenting "Validated against Olist data — max customer is $13,664; $500K threshold was unreachable" prevents well-intentioned but wrong changes.
2. **Revenue discrepancy prevention:** The data source documentation section explicitly states: "Revenue source: payment_value ($19.8M) — includes installment fees and vouchers. product category revenue uses price + freight ($16.1M) — this difference of 22.73% is expected and documented." Without this, an inherited dashboard triggers a data quality investigation. With it, the next analyst reads the note and immediately understands the situation.
3. **Missing documentation grade impact:** The student achieves at most 90% on each other criterion. Even with perfect scores on all five other criteria (Charts 25 + Calculated Fields 20 + Interactivity 20 + Design 15 + Data Connection 10 = 90 possible points out of 90 weighted), they score 0 on Documentation (10 points). Maximum grade = 90/100. The professional simulation: in a real organization, an undocumented dashboard is a liability. Future maintainers cannot support it, stakeholders cannot trust it without explanation, and the analyst's reputation suffers when issues arise.
4. **Ownership transfer vs Editor access:** Editor access allows another user to modify the dashboard but leaves the original owner in control of sharing, deletion, and credential management. Ownership transfer makes the new user the primary administrator — they can delete the report, revoke access from the former owner, and manage all settings. Transfer ownership when truly handing the project over. Give Editor access when collaborating but retaining control.
5. **In-dashboard documentation page:** A separate Google Doc can be lost, not found, or not shared with the right people. If the documentation is the last page of the report itself, anyone who accesses the dashboard automatically has access to the documentation. It is self-contained. The report and its documentation cannot be separated. This is especially valuable when someone finds your dashboard months later via a shared link and has no context about where to find the documentation.

---

**Thursday Session Complete.**
**Month 5 — Visualization — Complete.**
**Proceed to Final Project Submission.**
