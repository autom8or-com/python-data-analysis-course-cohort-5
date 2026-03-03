# Dashboard Documentation Template

## Week 16 - Thursday Session Resource

**Last Updated:** March 2026 | Cohort 5

---

## How to Use This Template

This is a fill-in template for documenting your Looker Studio dashboard. Complete all sections before your Final Project submission. Every field marked with `[brackets]` requires your input.

Two submission options:
- **Option A:** Create a "Documentation" page as the last page of your Looker Studio dashboard and paste the completed text
- **Option B:** Complete this template as a Google Doc and share the link alongside your dashboard URL in your submission email
- **Option C (Best Practice):** Brief summary in-dashboard (Section 1 + Known Limitations) + full technical documentation as a Google Doc

---

## SECTION 1: OVERVIEW

```
DASHBOARD NAME:
[Your dashboard title]
Example: "Olist E-Commerce Executive Dashboard — Cohort 5"

PURPOSE:
[1-2 sentences describing what business questions this dashboard answers]

Example:
"This dashboard tracks monthly revenue, customer lifetime value segmentation,
delivery performance, and marketing funnel metrics for the Olist Brazilian
marketplace. It supports weekly executive review, portfolio demonstration,
and business planning."

TARGET AUDIENCE:
Mark all that apply:
[ ] C-suite executives (strategic decisions)
[ ] Operations managers (day-to-day performance monitoring)
[ ] Marketing team (campaign and channel analysis)
[ ] Finance team (revenue reporting and trend analysis)
[ ] Technical analysts (ad-hoc data exploration)
[ ] Course instructor (academic evaluation)
[ ] Portfolio viewer / recruiter (professional demonstration)

KEY METRICS DISPLAYED:
(List every metric visible on Page 1 — your Executive Summary page)

Page 1 (Executive Summary):
- [Metric name]: [What it measures and how it is calculated]
- [Metric name]: [What it measures and how it is calculated]
- [Metric name]: [What it measures and how it is calculated]
(Add more rows as needed)

Example:
- Total Revenue (YTD 2018): Sum of payment_value for delivered orders,
  Jan–Aug 2018 ($8,452,980)
- Month-over-Month Growth: Pre-calculated in SQL using LAG() — Aug 2018: -4.13%
- Orders Count: COUNT(DISTINCT order_id) for delivered orders
- Average Order Value: Total revenue / order count (~$154 for analysis period)
- Delivery On Time Rate: % of orders delivered on or before estimated date

DASHBOARD URL (Shareable Link):
[Paste the shareable link from Share → Manage access → Copy link]

PORTFOLIO EMBED URL (if applicable):
[Paste the URL of your Google Site, personal website, or LinkedIn where embedded]

DATE CREATED:
[Date you built the first version of this dashboard]

LAST UPDATED:
[Date of your most recent significant change]

CREATED BY:
[Your full name]

CONTACT:
[Your email address]
```

---

## SECTION 2: DATA SOURCES

Complete one block per data source connected to your dashboard.

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
DATA SOURCE #1
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

DATA SOURCE NAME:
[Descriptive name, e.g., "Olist Monthly Executive KPIs"]
Tip: Use the name you gave it when creating the data source in Looker Studio

TYPE:
[ ] Custom SQL (PostgreSQL via Supabase)
[ ] Direct table connection
[ ] Google Sheets
[ ] Other: _______________

CONNECTION DETAILS:
  Database: Supabase PostgreSQL
  Project ID: pzykoxdiwsyclwfqfiii
  Host: aws-0-eu-central-1.pooler.supabase.com
  Schema(s) used: [List all schemas, e.g., olist_sales_data_set, olist_marketing_data_set]

SQL QUERY (if Custom SQL):
[Paste the full SQL query used for this data source — no semicolon at end]

Or if query is long, describe and reference:
"See validation-report.md Query [2a/2b/2c/2d/2e] — [description]"

REFRESH SCHEDULE:
  Type: [ ] Extract (cached) / [ ] Live connection
  Frequency: [ ] Weekly / [ ] Daily / [ ] Manual
  Day and Time (if Weekly): [e.g., Sunday 6:00 AM WAT]
  Last refreshed: [Date]

CREDENTIAL TYPE:
[ ] Owner's credentials (recommended for shared dashboards)
[ ] Viewer's credentials

ACTIVE DATE RANGE:
  Earliest data: [e.g., Sep 2016]
  Latest reliable data: [e.g., Aug 2018]
  Default date range in dashboard: [e.g., Jan 1, 2017 – Aug 31, 2018]

USED IN CHARTS:
(List which charts / pages use this data source)
- [Chart name on Page 1]
- [Chart name on Page 2]
(Continue as needed)

KNOWN LIMITATIONS:
[Any data quality issues, missing fields, or caveats specific to this source]

Example:
- Only delivered orders included (96,478 of 99,441 total)
- 2016 data sparse (Olist startup period) — excluded from default date range
- Marketing cost data does not exist — CAC figures are SIMULATED

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
DATA SOURCE #2 (if applicable — copy block above and repeat)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

[Repeat the block above for each additional data source]
```

### Standard Olist Data Source Reference

If you are using the validated pre-aggregated queries from the validation report, use these as your data source references:

| Data Source Name | Query Reference | Primary Use |
|-----------------|----------------|-------------|
| Olist Monthly Executive KPIs | validation-report.md Query 2a | Revenue trend, MoM, AOV, scorecards |
| Olist Product Category Performance | validation-report.md Query 2b | Category bar chart, product page |
| Olist Geographic Revenue | validation-report.md Query 2d | Map chart, state comparison |
| Olist Marketing Funnel | validation-report.md Query 2e | Channel analysis, marketing page |
| Olist Seller Performance | validation-report.md Query 2c | Seller table, ranking |
| Olist CLV Segmentation | validation-report.md Query 4a | Customer tier analysis |
| Olist Delivery Performance | validation-report.md Query 4e | On-time rate, delivery distribution |

---

## SECTION 3: CALCULATED FIELDS

Document every custom formula created in Looker Studio. This is the most important section — it allows someone else to audit or update your metrics without guessing.

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
CALCULATED FIELD #1
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

FIELD NAME:
[Exact name as it appears in Looker Studio]

DATA SOURCE:
[Which data source this field belongs to]

FORMULA:
[Paste exact Looker Studio formula — not SQL]

Example:
CASE
  WHEN total_spend > 5000 THEN "Premium"
  WHEN total_spend > 2000 THEN "High"
  WHEN total_spend > 500  THEN "Medium"
  ELSE "Standard"
END

PURPOSE:
[One sentence describing what this field computes and why]

THRESHOLD / LOGIC RATIONALE:
[Explain why you chose these values — especially important for CASE thresholds]

Example for CLV Tier:
"Thresholds validated against Olist data. Maximum customer spend is $13,664.
$500K original threshold was unreachable (0 customers qualified as Premium).
Current thresholds: Premium >$5K (7 customers), High >$2K (200 customers),
Medium >$500 (4,058 customers), Standard: remaining 89,092 customers."

DATA TYPE OUTPUT:
[ ] Text / Dimension
[ ] Number
[ ] Date

USED IN CHARTS:
[List all chart names where this field appears as a dimension or metric]

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
(Repeat the block above for each calculated field)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

### Pre-Filled Templates for Final Project Required Fields

The Final Project requires at least 5 custom calculated fields. Use these pre-filled templates:

**Required Field 1: CLV Tier**
```
FIELD NAME: CLV Tier

FORMULA:
CASE
  WHEN total_spend > 5000 THEN "Premium"
  WHEN total_spend > 2000 THEN "High"
  WHEN total_spend > 500  THEN "Medium"
  ELSE "Standard"
END

PURPOSE: Segments customers by lifetime spend for retention prioritization.

THRESHOLD RATIONALE:
Max customer spend in Olist dataset is $13,664. Thresholds set at $5K, $2K, $500
to distribute customers meaningfully across tiers:
  Premium: 7 customers (>$5K)
  High: 200 customers ($2K–$5K)
  Medium: 4,058 customers ($500–$2K)
  Standard: 89,092 customers (<$500)

DATA TYPE: Text (dimension)
```

**Required Field 2: MoM Growth % (from pre-calculated SQL column)**
```
FIELD NAME: MoM Growth % Display

FORMULA:
CONCAT(CAST(ROUND(mom_growth_pct, 1) AS STRING), "%")

PURPOSE: Formats the pre-calculated MoM growth percentage for scorecard display.

IMPORTANT NOTE:
mom_growth_pct is calculated in SQL using LAG() — NOT recalculated in Looker Studio.
Looker Studio does not support window functions in calculated fields.
The underlying column comes from the SQL data source (Query 2a).

DATA TYPE: Text (for display) — use raw mom_growth_pct column for numeric comparisons
```

**Required Field 3: Delivery Performance Category**
```
FIELD NAME: Delivery Category Display

FORMULA:
CASE
  WHEN days_vs_estimate <= 0 THEN "On Time"
  WHEN days_vs_estimate <= 7 THEN "Slightly Late"
  ELSE "Significantly Late"
END

OR (if using pre-calculated delivery_category column from SQL):
delivery_category [use field directly — no calculated field needed]

PURPOSE: Categorizes delivery performance relative to Olist's estimated delivery date.

NOTE:
"On Time" means delivered on or before the estimated date. Olist set conservative
estimates — average actual delivery is 12.7 days EARLIER than estimated.
This means approximately 92% of orders show as "On Time."
```

**Required Field 4: Financial KPI with MoM (from pre-calculated SQL)**
```
FIELD NAME: Revenue Trend Indicator

FORMULA:
CASE
  WHEN mom_growth_pct > 5   THEN "Strong Growth"
  WHEN mom_growth_pct > 0   THEN "Moderate Growth"
  WHEN mom_growth_pct = 0   THEN "Flat"
  WHEN mom_growth_pct > -5  THEN "Slight Decline"
  ELSE "Significant Decline"
END

PURPOSE: Translates numeric MoM growth into a business status label for executive scorecards.
```

**Required Field 5: Marketing Channel Label (SIMULATED)**
```
FIELD NAME: Channel Performance Label

FORMULA:
CASE
  WHEN conversion_rate > 0.05 THEN "High Performer"
  WHEN conversion_rate > 0.03 THEN "Average"
  ELSE "Underperforming"
END

PURPOSE: Classifies marketing channels by conversion rate for channel prioritization.

WARNING: Applies to conversion_rate which is real data. Any CAC or ROI
fields in the same chart are SIMULATED and must be clearly labeled.
```

---

## SECTION 4: FILTERS AND CONTROLS

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
CONTROL #1
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

CONTROL NAME/LABEL:
[The label visible on the dashboard, e.g., "Date Range"]

CONTROL TYPE:
[ ] Date range control
[ ] Drop-down list
[ ] Fixed-size list
[ ] Input box
[ ] Slider
[ ] Check box

DATA SOURCE:
[Which data source this control reads from]

FIELD USED:
[Which column the control filters on, e.g., order_month]

DEFAULT VALUE:
[What the control shows when the dashboard first loads]
Example: Jan 1, 2017 – Aug 31, 2018

AFFECTS CHARTS ON:
[ ] This page only
[ ] All pages
[ ] Pages: [list specific pages]

RATIONALE:
[Why you chose this control and its default value]

Example:
"Default date range set to Jan 2017 – Aug 2018 to exclude the sparse 2016
startup period and the effectively empty Sep–Oct 2018 tail-off. This gives
viewers the most representative 20 months of data on first load."

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
(Repeat the block above for each interactive control)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

---

## SECTION 5: MAINTENANCE

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
OWNERSHIP AND CONTACTS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

DASHBOARD OWNER:
[Your full name]

EMAIL:
[Your email address]

LAST UPDATED:
[Date]

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
UPDATE SCHEDULE
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

DATA REFRESH:
[e.g., Weekly automatic — Extract, Sunday 6:00 AM WAT]
Note: Since Olist is a historical dataset, data never changes.
The refresh schedule is configured but the data will be identical on every refresh.

DESIGN UPDATES:
[When you plan to update charts, calculated fields, or layout]
Example: As needed if business requirements change or errors are discovered.

DOCUMENTATION UPDATES:
After any change to a calculated field, data source, or significant chart modification,
update this document with the new formula and rationale.

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
HOW TO UPDATE THE DASHBOARD
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Standard Update Procedure:
1. Open the dashboard → click Edit (pencil icon, top right)
2. Make your changes to charts, calculated fields, or layout
3. Test all affected charts after any change

Modifying a data source SQL query:
1. Resource → Manage added data sources
2. Click Edit (pencil) next to the data source
3. Modify the custom SQL query in the query editor
4. Click "Reconnect" to refresh the schema after SQL changes
5. Return to the dashboard and verify affected charts still show data

Adding a new data source:
1. Resource → Manage added data sources → Add a data source
2. Select PostgreSQL → Connect to Supabase
3. Use Custom query → Paste SQL
4. Name descriptively → Add to report
5. Update calculated fields if the new source introduces new column names

After any update:
1. Click "View" (not Edit) to exit edit mode
2. Verify all charts load in View mode
3. If distributing to stakeholders, send a "Send now" test via scheduled delivery

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
HOW TO REFRESH DATA MANUALLY
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

When the scheduled Extract refresh has not run yet and you need current data:

1. Resource → Manage added data sources
2. Click Edit (pencil) next to each Extract data source
3. Click "Extract data" tab
4. Click "Refresh now"
5. Wait for "Extract refreshed successfully" confirmation
6. Close the data source editor → charts now reflect refreshed data

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
KNOWN LIMITATIONS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

The following are confirmed dataset limitations — these are not dashboard errors.
Anyone inheriting or reviewing this dashboard should be aware of these before
making changes or raising data quality concerns.

LIMITATION 1: Marketing data ends May 2018
  - The olist_marketing_data_set covers Jun 2017 – May 2018 only
  - Sales data extends through Oct 2018
  - Marketing page shows approximately 12 months of data — this is the full extent
    of what exists; it is not a filter error

LIMITATION 2: 2016 data is sparse
  - Olist was in startup/beta phase in 2016
  - Order volume in 2016 was <1% of the 2017-2018 volumes
  - 2016 is excluded from trend charts via the default date range filter
  - This is intentional — including 2016 makes growth rates misleading

LIMITATION 3: Sep–Oct 2018 tail-off
  - Only 8 total orders in Sep–Oct 2018 combined
  - This is an artifact of when the dataset was extracted, not an Olist business decline
  - These months are excluded from the default date range

LIMITATION 4: Marketing cost data is simulated
  - The Olist dataset contains no advertising spend, campaign budget, or cost-per-lead data
  - All Customer Acquisition Cost (CAC) and Return on Investment (ROI) metrics
    use illustrative industry estimate figures
  - Every chart showing CAC or ROI displays "SIMULATED" in the title or as a disclaimer
  - Do not present these figures as real Olist data in any professional context

LIMITATION 5: declared_monthly_revenue is empty
  - The closed_deals table has a declared_monthly_revenue column
  - All values are zero — this field was never populated by Olist sellers
  - This column is not used anywhere in this dashboard
  - Do not use it if extending the dashboard

LIMITATION 6: No join between marketing and sales data
  - There is no foreign key between olist_marketing_data_set and olist_sales_data_set
  - It is not possible to determine which MQL lead became which paying customer
  - Marketing and sales pages are analyzed separately, not jointly

LIMITATION 7: Revenue cross-validation gap (22.73%)
  - SUM(payment_value) = $19,835,936 (authoritative — actual money collected)
  - SUM(price + freight_value) = $16,162,447 (listed catalog prices only)
  - The 22.73% gap is EXPECTED — it comes from installment fees, vouchers, and
    multi-payment method adjustments
  - Always use payment_value for revenue metrics — never price + freight_value

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
SUPPORT CONTACTS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

For questions about dashboard data or calculations:
  Contact: [Your name] — [your email]

For technical Looker Studio issues:
  Google Looker Studio Help Center: support.google.com/looker-studio

For database access issues (Supabase connection):
  Contact: [Program instructor contact]

For access requests (non-editors who need view access):
  Use the dashboard's "Request access" button — owner will receive an email
```

---

## SECTION 6: SHARING AND ACCESS

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
CURRENT ACCESS CONFIGURATION
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

OWNER:
  [Your name / email] — Full control

EDITORS:
  [Name / email] — Can modify charts and data sources
  (If none: leave blank — single-owner dashboard)

VIEWERS (Direct Access):
  [Instructor name / email] — View-only for academic evaluation
  (Add others as applicable)

GENERAL ACCESS:
  [ ] Restricted — only explicitly listed users
  [x] Anyone with the link can view — portfolio ready (recommended)
  [ ] Published to web

SHAREABLE LINK:
  [Paste your shareable link here]

SCHEDULED DELIVERIES:
  Schedule 1:
    Recipients: [email]
    Format: PDF | Pages: Page 1 only | Frequency: Weekly Monday 7:00 AM
    Status: Active

  Schedule 2 (if configured):
    Recipients: [email]
    Format: Link | Pages: All | Frequency: Weekly Friday 4:00 PM
    Status: Active

EMBED CONFIGURATION:
  Embedding enabled: Yes / No
  Embedded at: [URL of embedding page, if applicable]

DATA SOURCE CREDENTIALS:
  All data sources: Owner's credentials
```

---

## Final Project Submission Checklist

Use this as your final review before submitting to the instructor.

```
DASHBOARD COMPLETENESS
☐ Dashboard has at least 3 pages
☐ Executive summary page (Page 1) — high-level KPIs
☐ At least 8 charts across all pages
☐ At least 5 custom calculated fields (including required types)
☐ At least 2 interactive filters/controls
☐ Date range control on at least one page

REQUIRED CALCULATED FIELDS
☐ CLV Tier (CASE-based customer segmentation)
☐ Marketing CAC or Channel Performance (labeled SIMULATED)
☐ Financial KPI with MoM comparison
☐ Delivery performance category
☐ At least one additional CASE-based field

REQUIRED CHARTS
☐ Scorecard(s) with key KPIs
☐ Time series / line chart (revenue trend)
☐ Geographic chart (map with state revenue)
☐ Comparative chart (bar chart for categories or channels)
☐ Data table (detailed drill-down)

DATA QUALITY
☐ Revenue uses SUM(payment_value) — validated
☐ WHERE order_status = 'delivered' applied
☐ CLV thresholds use $5K/$2K/$500 (not $500K)
☐ Marketing CAC labeled "SIMULATED" on every relevant chart
☐ Data quality footer on each page

SHARING
☐ Instructor granted Viewer access
☐ Portfolio link sharing enabled
☐ Incognito test passed
☐ Scheduled email delivery configured
☐ Test email received and verified

DOCUMENTATION
☐ Section 1 (Overview) complete
☐ Section 2 (Data Sources) — one block per data source
☐ Section 3 (Calculated Fields) — one block per custom field (min 5)
☐ Section 4 (Controls) — documented
☐ Section 5 (Maintenance + Known Limitations) — all 7 limitations acknowledged
☐ Section 6 (Sharing) — access configuration documented

SUBMISSION EMAIL
☐ Dashboard shareable link included
☐ Documentation link included (or documentation page in dashboard)
☐ Brief summary of what you built (2-3 sentences)
☐ One key insight from the data highlighted
```

---

**Template Version:** Week 16 Production Dashboards | March 2026
**For:** PORA Academy Cohort 5 Final Project Submission
