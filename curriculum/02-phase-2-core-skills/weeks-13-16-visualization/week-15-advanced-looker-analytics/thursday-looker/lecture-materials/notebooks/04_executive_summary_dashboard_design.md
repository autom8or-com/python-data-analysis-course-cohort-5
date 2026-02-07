# Executive Summary Dashboard Design

## Week 15 - Thursday Session - Part 4

### Duration: 10 minutes

---

## What Is an Executive Summary Dashboard?

An **Executive Summary Dashboard** is a single-page view that provides C-suite leaders with critical business health indicators and key insights in 30 seconds or less. It prioritizes clarity, actionability, and business impact over comprehensive detail.

**Purpose:** Enable senior leaders to make strategic decisions without analyzing raw data.

---

## The Executive Dashboard Formula

### The 5-3-1 Rule

**5 Seconds:** Understand overall business health (Green/Yellow/Red)
**3 Minutes:** Grasp key insights and trends
**1 Action:** Know exactly what to do next

**Design Implication:**
- First 5 seconds: Large KPI scorecards with color coding
- Next 3 minutes: 2-3 trend charts with annotations
- Always visible: Prioritized recommendations section

---

## Essential Elements of Executive Dashboards

### Element 1: Headline KPI Scorecards (Top Priority)

**Placement:** Top row, full width

**Number of KPIs:** 4-6 maximum (more = cognitive overload)

**What to Include:**
- Current value (large, bold)
- Trend indicator (↑↓ arrow)
- Comparison (vs target, vs prior period)
- Conditional formatting (traffic light colors)

**Example:**
```
┌──────────────────────────────────────────────────────────────┐
│  OLIST Q3 2018 EXECUTIVE SUMMARY                             │
├──────────────────────────────────────────────────────────────┤
│ ┌─────────┐ ┌─────────┐ ┌─────────┐ ┌─────────┐ ┌─────────┐ │
│ │Revenue  │ │Orders   │ │AOV      │ │NPS      │ │On-Time% │ │
│ │$3.05M   │ │19,630   │ │$155     │ │+12      │ │25%      │ │
│ │↓ -2.3%  │ │↑ +5.1%  │ │↓ -7.1%  │ │↓ -8 pts │ │↓ -15pts │ │
│ │🟡 Yellow │ │🟢 Green  │ │🟡 Yellow │ │🔴 Red    │ │🔴 Red    │ │
│ └─────────┘ └─────────┘ └─────────┘ └─────────┘ └─────────┘ │
└──────────────────────────────────────────────────────────────┘
```

**Insight (5-second scan):** 3 of 5 metrics yellow/red → Business has problems

---

### Element 2: Executive Summary Text Box

**Placement:** Immediately below KPI scorecards

**Content:** 2-3 sentence narrative summarizing situation

**Template:**
```
[Business health statement]. [Main problem/opportunity].
[Immediate action required].
```

**Example:**
```
┌──────────────────────────────────────────────────────────┐
│ 📊 EXECUTIVE SUMMARY                                     │
├──────────────────────────────────────────────────────────┤
│ Q3 revenue declined 2.3% despite 5.1% order growth,     │
│ driven by Average Order Value compression (-7.1%).       │
│ Root cause: Delivery delays (75% in Southeast) causing  │
│ customer dissatisfaction and lower repeat purchase       │
│ rates. Immediate action: Audit logistics partner SLA    │
│ by Oct 15 to protect $450K Q4 revenue.                  │
└──────────────────────────────────────────────────────────┘
```

**Why This Works:** Tells complete story without requiring chart interpretation.

---

### Element 3: Single Most Important Chart

**Placement:** Center of dashboard, largest visual element

**Chart Type:** Typically time series showing main KPI trend

**Requirements:**
- Clear title stating the insight (not just "Revenue Chart")
- Annotations highlighting key events/anomalies
- Reference lines showing targets or benchmarks
- Trend line showing overall direction

**Example:**
```
┌──────────────────────────────────────────────────────────┐
│ Revenue Trend: Q3 Decline Driven by AOV Pressure        │
├──────────────────────────────────────────────────────────┤
│                                                          │
│ $1.2M ┤                  ╱╲                              │
│       │              ╱      ╲                            │
│ $1.0M ┤          ╱            ╲ ← Aug: -4.13% MoM       │
│       │      ╱                  ╲                        │
│ $0.8M ┤  ╱                        ╲                      │
│       └──────────────────────────────                    │
│        Jul    Aug    Sep    Oct                          │
│                                                          │
│ 🎯 Target: $1.1M/month (dashed red line)                │
│ ⚠️ Aug-Sep below target → Q4 recovery plan needed        │
└──────────────────────────────────────────────────────────┘
```

---

### Element 4: Recommended Actions Panel

**Placement:** Right sidebar or bottom section, prominently visible

**Content:**
- 2-3 prioritized actions (not 10+)
- Each action has: Owner, Deadline, Expected Impact
- Visual hierarchy (highest priority = largest/boldest)

**Example:**
```
┌──────────────────────────────────────────────────────┐
│ 🚀 TOP 3 ACTIONS                                     │
├──────────────────────────────────────────────────────┤
│                                                      │
│ 1. 🔴 Audit Southeast Logistics (URGENT)            │
│    Owner: Maria Silva (VP Operations)               │
│    Due: Oct 15 | Impact: Protect $450K              │
│    [View Full Plan →]                               │
│                                                      │
│ 2. 🟡 Launch AOV Recovery Campaign                  │
│    Owner: Marketing Team                            │
│    Due: Oct 30 | Impact: +$10/order = +$200K/mo    │
│    [View Campaign Details →]                        │
│                                                      │
│ 3. 🟢 Expand South Model to Other Regions           │
│    Owner: Logistics Manager                         │
│    Due: Q1 2019 | Impact: +15% on-time delivery    │
│    [View Regional Analysis →]                       │
│                                                      │
└──────────────────────────────────────────────────────┘
```

---

### Element 5: Drill-Down Navigation

**Placement:** Top navigation bar or clickable KPI cards

**Purpose:** Let executives explore details if needed, but don't force them

**Implementation:**
```
┌──────────────────────────────────────────────────────┐
│ [📊 Summary] [📈 Revenue Deep Dive] [🚚 Operations]  │
│ [👥 Customers] [📍 Regional] [📁 Data Explorer]       │
└──────────────────────────────────────────────────────┘
      ↑ You are here
```

**Best Practice:** Summary page should be self-contained. Drill-down is optional, not required.

---

## Executive Dashboard Layout Template

### Layout Pattern: F-Pattern with Highlight Box

```
┌──────────────────────────────────────────────────────────────┐
│ EXECUTIVE SUMMARY - Q3 2018                          [Filters]│
├──────────────────────────────────────────────────────────────┤
│                                                              │
│ ┌─────┐ ┌─────┐ ┌─────┐ ┌─────┐ ┌─────┐  ← KPI Row        │
│ │Rev  │ │Orders│ │AOV  │ │NPS  │ │Deliv│                   │
│ └─────┘ └─────┘ └─────┘ └─────┘ └─────┘                   │
│                                                              │
│ ┌───────────────────────────────────────────────────────┐   │
│ │ 📊 EXECUTIVE SUMMARY (2-3 sentence narrative)         │   │
│ │ Revenue declined 2.3% due to delivery issues...       │   │
│ └───────────────────────────────────────────────────────┘   │
│                                                              │
│ ┌──────────────────────────┐  ┌──────────────────────────┐  │
│ │ MAIN TREND CHART         │  │ 🚀 TOP 3 ACTIONS         │  │
│ │ (Large, annotated)       │  │ 1. Fix Southeast         │  │
│ │                          │  │ 2. AOV recovery          │  │
│ │                          │  │ 3. Expand South model    │  │
│ │                          │  │                          │  │
│ └──────────────────────────┘  └──────────────────────────┘  │
│                                                              │
│ ┌────────────┐ ┌────────────┐ ┌────────────┐               │
│ │Supporting  │ │Supporting  │ │Supporting  │               │
│ │Chart 1     │ │Chart 2     │ │Chart 3     │               │
│ └────────────┘ └────────────┘ └────────────┘               │
│                                                              │
│ [View Detailed Analysis →] [Export Report →] [Schedule ↻]  │
└──────────────────────────────────────────────────────────────┘
```

---

## Common Executive Dashboard Mistakes

### Mistake 1: Too Many Metrics (Dashboard Vomit)

**Bad:** 20 KPI cards, 15 charts, endless scrolling

**Good:** 5 KPIs, 1 main chart, 3 supporting charts, single screen

**Why:** Executives have 30 seconds, not 30 minutes.

---

### Mistake 2: No Clear Narrative

**Bad:** Random collection of charts with no connection

**Good:** Story arc—Problem → Evidence → Solution

**Why:** Data without context is noise.

---

### Mistake 3: Missing Recommendations

**Bad:** Shows problems but leaves "what to do?" unanswered

**Good:** Every problem flagged has a corresponding action

**Why:** Executives need to know what to do, not just what's wrong.

---

### Mistake 4: No Conditional Formatting

**Bad:** All numbers in black text, no visual indicators

**Good:** Red/Yellow/Green color coding for instant status

**Why:** Color is processed faster than text.

---

### Mistake 5: Buried Insights

**Bad:** Most important insight at bottom of page 3

**Good:** Lead with conclusion (inverted pyramid)

**Why:** Executives may only see page 1.

---

## Mobile-First Design Considerations

**Reality:** 40% of dashboard views happen on tablets/phones (executives on the go)

### Mobile Optimization Checklist

```
☐ Scorecards stack vertically (not horizontal row)
☐ Font size ≥14px (readable on small screens)
☐ Charts simplified (fewer data series, larger elements)
☐ Touch-friendly controls (large buttons, no tiny dropdowns)
☐ Single column layout (no side-by-side comparisons)
☐ Hide non-essential elements on mobile view
☐ Test on actual iPhone/iPad before publishing
```

**Looker Studio Mobile Preview:** View → Preview → Mobile

---

## Integration with Email and Alerts

### Scheduled Email Reports

**Use Case:** Daily/weekly executive briefing sent automatically

**Setup:**
1. Dashboard → Share → Schedule email delivery
2. Recipients: CEO, CFO, VP Ops
3. Frequency: Monday 8am (weekly summary)
4. Format: PDF attachment + link to live dashboard

**Best Practice:** Email includes 1-paragraph summary in body, full dashboard as attachment.

---

### Threshold Alerts

**Use Case:** Notify executives immediately when KPI crosses threshold

**Example:**
- Trigger: Revenue declines >5% week-over-week
- Action: Send Slack notification to #executive-alerts
- Include: Current value, % change, link to dashboard

**Looker Studio Limitation:** No native alerting. Workaround:
1. Connect Looker to Google Sheets (live data connection)
2. Use Apps Script to check thresholds daily
3. Send email/Slack alert if triggered

---

## Accessibility and Inclusivity

### Color Blindness Considerations

**Problem:** Red-green color blindness affects 8% of men, 0.5% of women

**Solution:**
- Don't rely solely on red/green distinction
- Add icons: ✅❌⚠️ alongside colors
- Use patterns: Solid, Striped, Dotted (in addition to colors)
- Test with colorblind simulator tool

**Example:**
```
Good Performance:  🟢✅ Green + Checkmark
Warning:           🟡⚠️ Yellow + Warning Triangle
Problem:           🔴❌ Red + X Mark
```

---

### Screen Reader Compatibility

**Looker Studio Accessibility Features:**
- Alt text for images (Add via Edit → Alt text)
- Descriptive chart titles (not "Chart 1")
- Keyboard navigation support

**Best Practices:**
- Chart title describes insight, not just data ("Revenue declined 2.3%" vs "Revenue Chart")
- Use text annotations to supplement visual-only information

---

## Executive Dashboard Approval Checklist

Before presenting to executives, verify:

```
CONTENT CHECKS
☐ 4-6 KPIs maximum (not 20+)
☐ Each KPI has comparison (vs target or prior period)
☐ Clear 2-3 sentence executive summary
☐ Main chart has annotations explaining key points
☐ 2-3 actionable recommendations with owners/deadlines
☐ No jargon or technical terms (business language only)

DESIGN CHECKS
☐ Passes 5-second test (health obvious immediately)
☐ F-pattern layout (top + left = most important)
☐ Conditional formatting applied (traffic light colors)
☐ Single screen (no scrolling required for key info)
☐ Mobile-friendly (tested on tablet/phone)
☐ Colorblind accessible (icons + colors, not just colors)

ACCURACY CHECKS
☐ Metrics match validated SQL queries
☐ Comparisons calculated correctly
☐ Date ranges clearly labeled
☐ Data source fresh (auto-refresh enabled)
☐ No "null" or "error" values visible
```

---

## Real-World Example: Olist Q3 Executive Dashboard

### Complete Layout

```
┌──────────────────────────────────────────────────────────────┐
│ OLIST Q3 2018 EXECUTIVE DASHBOARD                  [Refresh] │
├──────────────────────────────────────────────────────────────┤
│                                                              │
│ ┌─────────┐ ┌─────────┐ ┌─────────┐ ┌─────────┐ ┌────────┐ │
│ │ Revenue │ │ Orders  │ │   AOV   │ │   NPS   │ │On-Time │ │
│ │ $3.05M  │ │ 19,630  │ │  $155   │ │   +12   │ │  25%   │ │
│ │ ↓ -2.3% │ │ ↑ +5.1% │ │ ↓ -7.1% │ │ ↓ -8pts │ │↓ -15pts│ │
│ │ 🟡      │ │ 🟢      │ │ 🟡      │ │ 🔴      │ │ 🔴     │ │
│ └─────────┘ └─────────┘ └─────────┘ └─────────┘ └────────┘ │
│                                                              │
│ ┌────────────────────────────────────────────────────────┐  │
│ │ 📊 Q3 revenue declined 2.3% despite order growth due   │  │
│ │ to AOV pressure (-7.1%) and delivery issues (75%       │  │
│ │ delayed in Southeast). NPS dropped 8 points.           │  │
│ │ Action: Audit logistics partner by Oct 15.            │  │
│ └────────────────────────────────────────────────────────┘  │
│                                                              │
│ ┌──────────────────────────┐ ┌──────────────────────────┐   │
│ │ Revenue Trend: Q3 Dip    │ │ 🚀 ACTIONS REQUIRED      │   │
│ │                          │ │                          │   │
│ │ $1.2M ┤      ╱╲          │ │ 1.🔴 Audit Southeast     │   │
│ │       │  ╱      ╲        │ │    Owner: Maria Silva    │   │
│ │ $1.0M ┤╱          ╲      │ │    Due: Oct 15           │   │
│ │       │            ╲     │ │    Impact: $450K saved   │   │
│ │       │  Aug: -4.13% ↓   │ │                          │   │
│ │       └─────────────────  │ │ 2.🟡 AOV Recovery        │   │
│ │  Jul  Aug  Sep  Oct      │ │    Owner: Marketing      │   │
│ │                          │ │    Due: Oct 30           │   │
│ │ 🎯 Target: $1.1M/month   │ │    Impact: +$200K/mo     │   │
│ └──────────────────────────┘ └──────────────────────────┘   │
│                                                              │
│ ┌───────────────┐ ┌───────────────┐ ┌───────────────┐      │
│ │ Regional      │ │ Top Products  │ │ Customer      │      │
│ │ Performance   │ │ (by Revenue)  │ │ Satisfaction  │      │
│ │ Southeast: ⚠️  │ │ Electronics:  │ │ Overall: 3.8★ │      │
│ │ South: ✅      │ │ $1.2M         │ │ SE Region:3.6★│      │
│ │ North: ⚠️      │ │ Home: $0.9M   │ │ South: 4.5★   │      │
│ └───────────────┘ └───────────────┘ └───────────────┘      │
│                                                              │
│ [View Full Report] [Export PDF] [Schedule Email] [Help]    │
└──────────────────────────────────────────────────────────────┘
```

**This dashboard passes all criteria:**
- ✅ 5-second scan: 3 red/yellow KPIs = problems
- ✅ 3-minute read: Understands delivery crisis in Southeast
- ✅ 1 action: Audit logistics partner by Oct 15
- ✅ Single screen, no scrolling
- ✅ Clear narrative and recommendations

---

## Key Takeaways

### What You Learned
1. ✅ Executive dashboards follow 5-3-1 rule (5 sec, 3 min, 1 action)
2. ✅ Essential elements: KPIs, summary text, main chart, recommendations, navigation
3. ✅ F-pattern layout with top-row KPIs and left-side highlights
4. ✅ 4-6 KPIs maximum (avoid dashboard vomit)
5. ✅ Mobile-first design for executives on the go
6. ✅ Accessibility matters (colorblind users, screen readers)
7. ✅ Integration with email alerts for proactive monitoring

### What's Next
**Apply everything:** In the exercises, you'll build a complete Marketing Performance Data Story Dashboard using all techniques from this week.

---

## Questions to Test Your Understanding

1. What is the 5-3-1 rule for executive dashboards?
2. What are the five essential elements every executive dashboard must have?
3. Why should you limit KPI cards to 4-6 maximum?
4. How do you make dashboards accessible to colorblind users?
5. What's the difference between an executive summary dashboard and a detailed analytics dashboard?

**Answers at end of notes**

---

## Answers to Questions

1. **5-3-1 rule:** User understands business health in 5 seconds, grasps key insights in 3 minutes, knows 1 specific action to take
2. **Five essential elements:** (1) Headline KPI scorecards, (2) Executive summary text, (3) Main trend chart (annotated), (4) Recommended actions panel, (5) Drill-down navigation
3. **Limit to 4-6 KPIs:** More metrics = cognitive overload. Executives can't process 20 metrics in 30 seconds. Focus on most critical indicators only.
4. **Colorblind accessibility:** Don't rely solely on red/green colors. Add icons (✅❌⚠️), use patterns (solid/striped/dotted), test with colorblind simulator
5. **Difference:** Executive dashboard = high-level, actionable, single-screen, business impact. Detailed dashboard = comprehensive, exploratory, multi-page, for analysts. Different audiences, different needs.

---

**Congratulations!** You've completed all Week 15 lectures. You now have the complete toolkit for building advanced analytics dashboards that tell compelling stories and drive business decisions.

**Next:** Complete the exercises to apply everything you've learned!
