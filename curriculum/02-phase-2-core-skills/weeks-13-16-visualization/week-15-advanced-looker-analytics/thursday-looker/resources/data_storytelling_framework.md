# Data Storytelling Framework & Templates

## Week 15 - Thursday Session Resource

**Last Updated:** February 2026 | Cohort 5

---

## Overview

This framework provides structured templates and decision-making tools for building narrative-driven dashboards. Use these templates to transform raw data into compelling business stories that drive action.

---

## Table of Contents

1. [Story Arc Template](#story-arc-template)
2. [Dashboard Layout Patterns](#dashboard-layout-patterns)
3. [Annotation Style Guide](#annotation-style-guide)
4. [Recommendation Writing Framework](#recommendation-writing-framework)
5. [Color Palette Guidelines](#color-palette-guidelines)
6. [Checklist Library](#checklist-library)

---

## Story Arc Template

### The Classic 4-Act Structure

Use this template for every business dashboard:

```
ACT 1: SETUP (Executive Summary)
├─ Current State: Where are we now?
├─ Key Metrics: 4-6 KPI scorecards
└─ Context: vs Target, vs Prior Period

ACT 2: CONFLICT (Problem Identification)
├─ What's Wrong: Declining trends, missed targets
├─ Visual Evidence: Charts showing the problem
└─ Magnitude: How big is the issue?

ACT 3: CLIMAX (Root Cause Analysis)
├─ Why It Happened: Drill-down analysis
├─ Contributing Factors: Segmentation breakdown
└─ Correlation: What drives the problem?

ACT 4: RESOLUTION (Recommendations)
├─ What To Do: Prioritized actions (2-4 items)
├─ Who Owns It: Clear ownership
├─ Expected Outcome: Quantified impact
└─ Timeline: Specific deadlines
```

---

### Example: E-commerce Revenue Decline Story

```
ACT 1: SETUP
"Q3 revenue: $3.05M (↓2.3% vs Q2)"

ACT 2: CONFLICT
"Revenue declined despite order growth (+5.1%)
→ Root cause: AOV decreased from $167 to $155"

ACT 3: CLIMAX
"AOV decline driven by:
- 75% delivery delays in Southeast (largest market)
- Customer dissatisfaction (3.8★ vs 4.2★ target)
- Lower repeat purchase rate (18% vs 25% benchmark)"

ACT 4: RESOLUTION
"Action 1: Audit Southeast logistics by Oct 15
Expected: Reduce delays 75%→40%, recover $450K revenue"
```

---

## Dashboard Layout Patterns

### Pattern 1: Executive Summary Dashboard

**Use Case:** C-suite monthly business review

**Layout:**
```
┌─────────────────────────────────────────────────┐
│ TITLE + DATE RANGE              [Refresh] [Help]│
├─────────────────────────────────────────────────┤
│                                                 │
│ [KPI1] [KPI2] [KPI3] [KPI4] [KPI5]  ← Row 1   │
│                                                 │
│ ┌─────────────────────────────────────────────┐ │
│ │ EXECUTIVE SUMMARY TEXT (3 sentences)        │ │
│ │ Main problem + Root cause + Action required │ │
│ └─────────────────────────────────────────────┘ │
│                                                 │
│ ┌────────────────────────┐ ┌─────────────────┐ │
│ │ MAIN TREND CHART       │ │ TOP 3 ACTIONS   │ │
│ │ (Annotated, large)     │ │ 1. Urgent       │ │
│ │                        │ │ 2. Important    │ │
│ │                        │ │ 3. Strategic    │ │
│ └────────────────────────┘ └─────────────────┘ │
│                                                 │
│ [Supporting] [Supporting] [Supporting]          │
│                                                 │
└─────────────────────────────────────────────────┘
```

**When to Use:**
- Audience: Senior leadership
- Frequency: Monthly/quarterly
- Goal: Strategic decision-making

---

### Pattern 2: Operational Performance Dashboard

**Use Case:** Weekly team performance tracking

**Layout:**
```
┌─────────────────────────────────────────────────┐
│ TITLE: Weekly Performance      Week of Oct 1-7  │
├─────────────────────────────────────────────────┤
│                                                 │
│ [This Week] [Last Week] [% Change] [vs Target]  │
│                                                 │
│ ┌─────────────────────────────────────────────┐ │
│ │ DAILY TREND (This Week)                     │ │
│ │ Line chart: Mon-Sun performance             │ │
│ └─────────────────────────────────────────────┘ │
│                                                 │
│ ┌──────────────┐ ┌──────────────┐              │
│ │ Top          │ │ Bottom       │              │
│ │ Performers   │ │ Performers   │              │
│ │ (Green list) │ │ (Red list)   │              │
│ └──────────────┘ └──────────────┘              │
│                                                 │
│ ACTION ITEMS FOR THIS WEEK:                     │
│ ☐ Follow up with underperforming team          │
│ ☐ Celebrate top performers                     │
│ ☐ Address blockers                             │
│                                                 │
└─────────────────────────────────────────────────┘
```

**When to Use:**
- Audience: Team managers
- Frequency: Daily/weekly
- Goal: Operational execution

---

### Pattern 3: Exploratory Analysis Dashboard

**Use Case:** Analyst self-service data investigation

**Layout:**
```
┌─────────────────────────────────────────────────┐
│ DATA EXPLORER                          [Export] │
├─────────────────────────────────────────────────┤
│ FILTERS:                                        │
│ [Date: ___] [Region: ___] [Category: ___]      │
│                                                 │
│ ┌─────────────────────────────────────────────┐ │
│ │ PRIMARY METRIC TREND                        │ │
│ │ (User-selected metric)                      │ │
│ └─────────────────────────────────────────────┘ │
│                                                 │
│ ┌────────────────┐ ┌────────────────┐          │
│ │ Breakdown 1    │ │ Breakdown 2    │          │
│ │ (Dimension A)  │ │ (Dimension B)  │          │
│ └────────────────┘ └────────────────┘          │
│                                                 │
│ DETAILED DATA TABLE:                            │
│ ┌─────────────────────────────────────────────┐ │
│ │ [All fields with sorting/filtering]         │ │
│ │ [Pagination] [Download CSV]                 │ │
│ └─────────────────────────────────────────────┘ │
│                                                 │
└─────────────────────────────────────────────────┘
```

**When to Use:**
- Audience: Analysts, data scientists
- Frequency: Ad-hoc
- Goal: Deep-dive investigation

---

## Annotation Style Guide

### Annotation Types & When to Use

| Type | Purpose | Example | When to Use |
|------|---------|---------|-------------|
| **Text Box** | Explain context | "Holiday campaign started Aug 15" | Events, background info |
| **Reference Line** | Show target/benchmark | $10M annual goal (red dashed) | Targets, thresholds, SLAs |
| **Data Label** | Display exact value | "SP: $5.4M" on bar | Key numbers, comparisons |
| **Tooltip** | On-hover details | Hover shows breakdown | Supplementary info |
| **Callout Box** | Highlight key insight | "⚠️ 75% delayed orders" | Most important finding |
| **Arrow/Emoji** | Direct attention | ↓ pointing to anomaly | Anomalies, peaks/dips |

---

### Annotation Writing Rules

**Rule 1: Be Concise**
- ❌ "There appears to be an interesting pattern in the data suggesting that revenue may have declined during this time period"
- ✅ "Revenue declined 4.13% in August"

**Rule 2: Explain WHY, Not WHAT**
- ❌ "Revenue decreased" (chart already shows this)
- ✅ "Revenue decreased due to delivery delays causing customer churn"

**Rule 3: Use Active Voice**
- ❌ "It was observed that performance was impacted"
- ✅ "Delivery delays impacted performance"

**Rule 4: Include Business Impact**
- ❌ "Conversion rate dropped from 5% to 4%"
- ✅ "Conversion rate dropped from 5% to 4% = 200 fewer customers/month = $60K revenue loss"

**Rule 5: Be Specific, Not Vague**
- ❌ "Soon we should look into improving this"
- ✅ "Audit logistics partner by Oct 15 (Owner: Maria Silva, VP Ops)"

---

### Annotation Template Library

**Template 1: Anomaly Explanation**
```
[Event/Change]: [What happened]
Impact: [Quantified effect]
Cause: [Why it happened]
```

Example:
```
August Revenue Drop: -4.13% MoM
Impact: $42K below target
Cause: AOV declined due to delivery delays (75% late orders)
```

---

**Template 2: Benchmark Comparison**
```
Actual: [Current value]
Benchmark: [Industry/target value]
Gap: [Difference and %]
Action: [What to do]
```

Example:
```
Actual: 4.8% conversion rate
Benchmark: 6.0% (industry standard)
Gap: -1.2 percentage points (-20%)
Action: Optimize email nurture sequence by Nov 1
```

---

**Template 3: Trend Observation**
```
Pattern: [Trend description]
Duration: [Time period]
Magnitude: [Size of change]
Implication: [Business meaning]
```

Example:
```
Pattern: Steady upward revenue growth
Duration: Jan-Jul 2018 (+3-5% MoM)
Magnitude: Trend reversed in Aug (-4.13%)
Implication: Investigate what changed in August (logistics partner switch identified)
```

---

## Recommendation Writing Framework

### SMART Recommendation Template

```
[PRIORITY LEVEL] [ACTION TITLE]
├─ SPECIFIC: [Exact action to take]
├─ MEASURABLE: [How to track success]
├─ ACHIEVABLE: [Resources required]
├─ RELEVANT: [Business impact/why it matters]
└─ TIME-BOUND: [Deadline and milestones]

Owner: [Name/Role]
Expected Outcome: [Quantified result]
Success Metrics: [KPIs to monitor]
Dependencies: [Prerequisites]
Status: [Not Started / In Progress / Complete]
```

---

### Example: Complete Recommendation

```
🔴 HIGH PRIORITY: Audit Southeast Logistics Partner

SPECIFIC:
1. Review FastShip Brazil contract and SLA terms
2. Analyze delivery performance data (Aug-Sep 2018)
3. Conduct on-site audit of 3 largest fulfillment centers
4. Benchmark against alternative carriers (BrazilExpress, LogiPro)
5. Negotiate improved SLA or prepare switch to backup carrier

MEASURABLE:
- Success = On-time delivery improves from 25% → 60% by Dec 1
- Track weekly: % orders delivered within 7 days
- Track monthly: Customer satisfaction score (target: 4.2★)

ACHIEVABLE:
- Resources: 2 analysts (40 hours each), $5K audit budget
- Timeline: 6 weeks (Oct 1 - Nov 15)
- Tools: Existing Looker dashboard for tracking

RELEVANT:
- Southeast = 55% of total revenue ($5.4M/month)
- Current delays put $450K Q4 revenue at risk
- Customer satisfaction dropped from 4.2★ → 3.8★
- Competitors gaining market share with faster delivery

TIME-BOUND:
- Oct 1: Kick-off meeting with FastShip
- Oct 15: Complete performance data analysis
- Oct 30: On-site audits finished
- Nov 10: Benchmark alternatives completed
- Nov 15: Final recommendation to executive team
- Dec 1: Implementation complete (if switching carrier)

Owner: Maria Silva (VP Operations)
Expected Outcome:
- Reduce delayed orders from 75% → 40%
- Recover customer satisfaction 3.8★ → 4.2★
- Protect $450K Q4 revenue
- Prevent further market share loss

Success Metrics:
- % on-time delivery (weekly)
- Customer satisfaction NPS (monthly)
- Revenue retention in Southeast (monthly)
- Repeat purchase rate (monthly)

Dependencies: None (can start immediately)
Status: Not Started → Target: In Progress by Oct 1
```

---

## Color Palette Guidelines

### Semantic Color Coding (Consistent Meaning)

**Status Colors:**
```
🟢 Green (#34A853):   Success, on-target, positive trend
🟡 Yellow (#FBBC04):  Warning, at-risk, needs attention
🔴 Red (#EA4335):     Problem, critical, below target
⚪ Gray (#9E9E9E):    Neutral, not applicable, disabled
🔵 Blue (#4285F4):    Information, standard, clickable
```

**Do's:**
- ✅ Use consistently: Green always = good, Red always = bad
- ✅ Combine with icons/text (colorblind accessibility)
- ✅ Apply to backgrounds (scorecards) and text (annotations)

**Don'ts:**
- ❌ Use red for anything positive
- ❌ Mix metaphors (red for revenue, green for costs)
- ❌ Rely solely on color without text/icons

---

### Chart Color Schemes

**Single Series (One Metric Over Time):**
- Use single color (brand color or blue)
- Add fill under line (30-50% opacity)
- Example: Revenue trend → Solid blue line with light blue fill

**Categorical Comparison (Multiple Categories):**
- Use sequential or diverging palette
- Maintain visual hierarchy (darkest = most important)
- Limit to 5-7 colors maximum

**Example: Revenue by State**
```
Top Performer (SP):     Dark Green #1E8E3E
Good Performers:        Medium Green #34A853
Average Performers:     Light Green #93C47D
Low Performers:         Light Orange #F9AB00
Problem Areas:          Dark Red #EA4335
```

**Heatmap (Gradient for Intensity):**
- Low values: Light color (white or pale blue)
- High values: Dark color (dark blue or dark green)
- Diverging: Red ← White → Blue (for +/- values)

---

## Checklist Library

### Pre-Publication Dashboard Review

```
STORY & NARRATIVE
☐ Clear title describing main insight (not generic)
☐ Executive summary text present (2-3 sentences)
☐ Story arc flows: Problem → Evidence → Solution
☐ Main insight obvious in 5 seconds
☐ Recommendations section included with owners/deadlines

DESIGN & LAYOUT
☐ F-pattern layout (KPIs top, key charts left)
☐ 4-6 KPIs maximum (not 20+)
☐ Conditional formatting applied (traffic lights)
☐ Annotations highlight key points
☐ Single screen (no scrolling for key info on Page 1)
☐ Passes squint test (hierarchy visible when blurred)

PROGRESSIVE DISCLOSURE
☐ Level 1: Executive summary (always visible)
☐ Level 2: Key trends (main page content)
☐ Level 3: Drill-down pages (accessible via navigation)
☐ Level 4: Data explorer (optional for power users)

DATA ACCURACY
☐ Metrics match validated SQL queries
☐ Date ranges clearly labeled
☐ Comparisons calculated correctly (MoM, YoY, vs Target)
☐ No "null", "error", or "#DIV/0!" visible
☐ Data source auto-refresh enabled

ACCESSIBILITY
☐ Color + icons (not color alone) for status indicators
☐ Font size ≥12px (14px for executive dashboards)
☐ High contrast text (dark on light or vice versa)
☐ Alt text added to images
☐ Mobile-friendly (tested in mobile preview)

USABILITY
☐ Interactive controls placed logically
☐ Navigation menu functional
☐ Export/download options provided
☐ Help documentation linked
☐ Contact info for questions (email/Slack)

BUSINESS VALUE
☐ Answers specific business question
☐ Enables concrete decision or action
☐ Quantifies impact ($, %, customer count)
☐ Assigns clear ownership
☐ Sets measurable success criteria
```

---

### Storytelling Quality Assessment

Rate your dashboard on each dimension (1=Poor, 5=Excellent):

```
CLARITY
[1][2][3][4][5] Main message is immediately obvious
[1][2][3][4][5] Charts are simple and easy to interpret
[1][2][3][4][5] Annotations explain key points clearly

ACTIONABILITY
[1][2][3][4][5] Recommendations are specific and measurable
[1][2][3][4][5] Owners and deadlines are assigned
[1][2][3][4][5] Expected outcomes are quantified

NARRATIVE FLOW
[1][2][3][4][5] Story arc is logical (Setup→Conflict→Resolution)
[1][2][3][4][5] Progressive disclosure works smoothly
[1][2][3][4][5] Transitions between sections make sense

VISUAL DESIGN
[1][2][3][4][5] Layout follows F-pattern or Z-pattern
[1][2][3][4][5] Color coding is consistent and meaningful
[1][2][3][4][5] Visual hierarchy guides attention effectively

BUSINESS IMPACT
[1][2][3][4][5] Clearly articulates business problem
[1][2][3][4][5] Connects data insights to revenue/customers/costs
[1][2][3][4][5] Enables strategic or operational decisions

TARGET SCORE: 20-25 points = Excellent storytelling dashboard
```

---

## Decision Trees

### "Which Layout Pattern Should I Use?"

```
Who is the primary audience?
├─ C-suite Executives
│  └─ Use: Executive Summary Pattern
│      - 5 KPIs, 1 main chart, 3 actions
│      - Single screen, no scrolling
│
├─ Operations Managers
│  └─ Use: Operational Performance Pattern
│      - Weekly trends, top/bottom performers
│      - Action checklists
│
├─ Analysts / Data Scientists
│  └─ Use: Exploratory Analysis Pattern
│      - Many filters, detailed tables
│      - Export functionality
│
└─ Mixed Audience
   └─ Use: Multi-Page Report
       - Page 1: Executive summary
       - Page 2-3: Operational details
       - Page 4: Data explorer
```

---

### "How Many Charts Should I Include?"

```
What's the purpose of this dashboard?
├─ Strategic Decision (Monthly/Quarterly Review)
│  └─ 5-7 charts maximum
│      - 4-6 KPI scorecards
│      - 1 main trend chart
│      - 2-3 supporting charts
│
├─ Operational Monitoring (Daily/Weekly Tracking)
│  └─ 8-12 charts
│      - More granular breakdowns
│      - Team/individual performance
│
├─ Comprehensive Analysis (Quarterly Business Review)
│  └─ 15-20 charts across multiple pages
│      - Page 1: Summary (5 charts)
│      - Page 2-3: Deep dives (5 charts each)
│      - Page 4: Details (5 charts)
│
└─ Exploratory (Ad-Hoc Investigation)
   └─ Flexible, user-driven
       - Start with 3-5 core charts
       - Users customize as needed
```

---

## Version History

- **Week 15 (February 2026):** Initial version for Cohort 5
- **Validated:** All templates tested against Olist dataset
- **Examples:** Real business scenarios from e-commerce domain

---

## See Also

- Week 15 Lecture 01: Data Storytelling Principles
- Week 15 Lecture 02: Progressive Disclosure & Annotations
- Week 15 Lecture 03: Highlighting Anomalies & Insights
- Week 15 Lecture 04: Executive Summary Dashboard Design
- Thursday Exercise 01: Marketing Data Story Dashboard

---

**Pro Tip:** Print this framework and keep it next to your computer. Before publishing any dashboard, run through the checklists to ensure you're telling a compelling story, not just displaying data.
