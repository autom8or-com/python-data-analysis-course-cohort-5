# Highlighting Anomalies and Actionable Insights

## Week 15 - Thursday Session - Part 3

### Duration: 15 minutes

---

## What Are Actionable Insights?

**Actionable Insight** = Data Observation + Business Context + Specific Recommendation

It's not enough to say "revenue declined 4.13%." An actionable insight explains:
1. **What** happened (data observation)
2. **Why** it matters (business impact)
3. **Who** should act (owner)
4. **What** to do (specific action)
5. **When** to do it (timeline)
6. **Expected** outcome (projected impact)

---

## Anatomy of an Actionable Insight

### Example: Transforming Data into Action

**Data Observation (Not Actionable):**
"Southeast region delivery delays increased to 75% in August."

**Actionable Insight (Complete):**
```
┌──────────────────────────────────────────────────┐
│ ⚠️ CRITICAL: Southeast Delivery Crisis           │
├──────────────────────────────────────────────────┤
│ WHAT: 75% of Southeast orders delayed (up from   │
│       60% in July). Customer satisfaction        │
│       dropped 3 points to 3.8★                   │
│                                                  │
│ WHY IT MATTERS: Southeast = 55% of total revenue │
│ ($5.4M/month). Each 0.1★ drop in satisfaction =  │
│ 8% churn risk. Projected $450K Q4 revenue loss.  │
│                                                  │
│ ROOT CAUSE: Logistics partner "FastShip Brazil"  │
│ changed delivery routes Aug 1, adding 5-7 days.  │
│                                                  │
│ ACTION REQUIRED:                                 │
│ 1. Owner: VP Operations (Maria Silva)            │
│ 2. Action: Audit FastShip contract + SLAs        │
│ 3. Timeline: Complete audit by Oct 15            │
│ 4. Backup: Negotiate with alternative carrier    │
│                                                  │
│ EXPECTED OUTCOME: Reduce delays from 75% → 40%   │
│ by Dec 1. Recover satisfaction to 4.2★.          │
│ Protect $450K revenue.                           │
└──────────────────────────────────────────────────┘
```

---

## How to Identify Anomalies in Data

### Anomaly Type 1: Sudden Spikes or Drops

**Definition:** Metric changes significantly more than historical volatility

**Detection Methods:**

**Method 1: Visual Inspection (Simple)**
- Plot time series
- Look for points that "stand out" from trend

**Method 2: Standard Deviation Threshold**
- Calculate average and standard deviation of metric
- Flag values > 2 standard deviations from mean

**Method 3: Percent Change Threshold**
- Month-over-month change >±10% = notable
- Month-over-month change >±20% = critical anomaly

**Example from Olist:**
```
Monthly Revenue ($M):
Jul: $1.03  →  Aug: $0.99  = -4.13% change
                           ↑ Anomaly flag (>3% decline threshold)
```

---

### Anomaly Type 2: Trend Reversal

**Definition:** Direction of trend changes (growth → decline or decline → growth)

**Looker Studio Detection:**
- Add trend line to time series chart
- Watch for inflection points where trend line changes slope

**Example:**
```
Order Count (Trend):

20K ┤         ╱────────  ← Upward trend Jan-Jun
    │     ╱
15K ┤ ╱
    │                ╲  ← Trend reversal Jul-Aug (anomaly!)
10K ┤                  ╲────
    └───────────────────────
     Jan Feb Mar Apr May Jun Jul Aug
```

**Business Implication:** Something changed in July. Investigate external factors.

---

### Anomaly Type 3: Unexpected Patterns

**Definition:** Values that violate business rules or expectations

**Examples:**
- **Seasonality violation:** December revenue lower than November (retail usually opposite)
- **Logical impossibility:** More orders delivered than placed
- **Benchmark deviation:** Your delivery time 18 days, industry standard 5 days

**Olist Example:**
- Expected: Holiday shopping boost in November/December
- Actual (if hypothetical): Revenue flat or declining
- **Anomaly:** Missing expected seasonal spike

---

### Anomaly Type 4: Outliers in Distributions

**Definition:** Individual data points far from the group

**Example from Olist:**
```
Customer Lifetime Value Distribution:
- Median: $157
- 95th percentile: $1,200
- Maximum: $13,664  ← Outlier! (VIP Champion customer)
```

**Business Action:** Identify characteristics of this $13.6K customer. Can we find more like them?

---

## Conditional Formatting for Anomaly Highlighting

### Technique 1: Traffic Light Colors (Scorecard KPIs)

**Purpose:** Instantly show status with color

**Configuration:**
```
Scorecard: Monthly Revenue Growth %

Rules:
- Green:  ≥5%   (healthy growth)
- Yellow: 0-5%  (slow growth)
- Red:    <0%   (decline - ALERT!)
```

**Visual Result:**
```
┌─────────────────────┐
│ MoM Revenue Growth  │
│                     │
│      -4.13%         │
│  🔴 RED BACKGROUND  │
└─────────────────────┘
```

**Executive sees RED immediately** → knows there's a problem without reading details.

---

### Technique 2: Color Scales (Tables and Heatmaps)

**Purpose:** Identify best and worst performers visually

**Configuration:**
```
Table: Revenue by State

Color Scale:
- Dark Green: Top 10% (highest revenue)
- Light Green: Top 25%
- White: Middle 50%
- Light Red: Bottom 25%
- Dark Red: Bottom 10% (needs attention)
```

**Visual Result:**
```
State       Revenue      Color
─────────────────────────────────
SP          $5.4M        🟩 Dark Green
RJ          $1.8M        🟢 Light Green
MG          $1.4M        ⬜ White
BA          $0.45M       🟠 Light Red
AC          $0.02M       🔴 Dark Red ← Anomaly: Investigate
```

---

### Technique 3: Threshold Lines on Charts

**Purpose:** Show acceptable range; highlight when metric exceeds limits

**Example:**
```
Delivery Days (Time Series)

SLA Target: 14 days (red line)
Goal: 7 days (green line)

20 ┤              ╱────────────  ← Above SLA (bad)
   │          ╱
15 ┤─────────────────────────── ← SLA Threshold
   │      ╱
10 ┤  ╱───
   │
 5 ┤─────────────────────────── ← Goal Threshold
   └────────────────────────────
    Jan Feb Mar Apr May Jun Jul
```

**Insight:** Delivery days crossed SLA threshold in May (anomaly). Stayed above threshold Jun-Jul (persistent problem).

---

### Technique 4: Sparklines with Indicators

**Purpose:** Show trend within scorecard for quick pattern recognition

**Implementation:**
```
┌───────────────────────────┐
│ AOV: $155                 │
│ ↓ -7.1% vs last month     │
│ ╱\  ╱\  ╱\__  ← Sparkline │
│         ↓ Declining trend │
└───────────────────────────┘
```

**Looker Studio:** Add mini line chart next to scorecard showing last 12 months of AOV.

---

## Building a Recommendations Section

### Structure of a Recommendation

**Template:**
```
[Priority Level] [Action Title]
Owner: [Name/Role]
Timeline: [Deadline]
Expected Impact: [Metric change]
Dependencies: [Prerequisites]
Resources Required: [Budget/People/Tools]
```

**Example:**
```
🔴 HIGH PRIORITY: Audit Southeast Logistics Partner
Owner: VP Operations (Maria Silva)
Timeline: Complete by October 15, 2018
Expected Impact:
  - Reduce delivery delays from 75% → 40%
  - Improve customer satisfaction 3.8★ → 4.2★
  - Protect $450K Q4 revenue at risk
Dependencies: None - can start immediately
Resources: 2 analysts, $5K audit budget
Next Step: Schedule kickoff meeting with FastShip Brazil
```

---

### Priority Framework (Eisenhower Matrix)

**Categorize recommendations by urgency and impact:**

```
              HIGH IMPACT
                  │
        ┌─────────┼─────────┐
        │         │         │
        │  🔴     │   🟡    │
        │  DO     │  DECIDE │
HIGH    │  FIRST  │  & PLAN │
URGENCY ├─────────┼─────────┤
        │  🟢     │   ⬜    │
        │  DELE-  │  ELIMI- │
LOW     │  GATE   │  NATE   │
        │         │         │
        └─────────┴─────────┘
             LOW IMPACT
```

**Example Classification:**
- 🔴 **Do First:** Fix Southeast delivery crisis (high impact, urgent)
- 🟡 **Decide & Plan:** Expand to new markets (high impact, not urgent)
- 🟢 **Delegate:** Update dashboard color scheme (low impact, needs doing)
- ⬜ **Eliminate:** Create 10 more vanity metrics (low impact, low urgency)

---

### Dashboard Recommendations Section Layout

**Visual Design:**
```
┌─────────────────────────────────────────────────┐
│ 📋 RECOMMENDED ACTIONS                          │
├─────────────────────────────────────────────────┤
│                                                 │
│ 🔴 HIGH PRIORITY                                │
│ ┌─────────────────────────────────────────────┐ │
│ │ 1. Audit Southeast Logistics                │ │
│ │    Owner: Maria Silva (VP Ops)              │ │
│ │    Deadline: Oct 15 | Impact: $450K revenue │ │
│ │    [View Details] [Mark Complete]           │ │
│ └─────────────────────────────────────────────┘ │
│                                                 │
│ 🟡 MEDIUM PRIORITY                              │
│ ┌─────────────────────────────────────────────┐ │
│ │ 2. Implement Delivery Guarantee Program    │ │
│ │    Owner: Marketing Team                    │ │
│ │    Deadline: Nov 1 | Impact: +0.4★ NPS      │ │
│ │    [View Details]                           │ │
│ └─────────────────────────────────────────────┘ │
│                                                 │
│ 🟢 LOW PRIORITY                                 │
│ ┌─────────────────────────────────────────────┐ │
│ │ 3. Expand South Region Carrier to Other     │ │
│ │    Regions (South has best performance)     │ │
│ │    Owner: Logistics Manager                 │ │
│ │    Deadline: Q1 2019 | Impact: +10% on-time │ │
│ │    [View Details]                           │ │
│ └─────────────────────────────────────────────┘ │
│                                                 │
└─────────────────────────────────────────────────┘
```

---

## Writing Effective Recommendation Text

### Good Recommendation Characteristics

**1. Specific (Not Vague)**
- ❌ Bad: "Improve logistics"
- ✅ Good: "Renegotiate SLA with FastShip to guarantee 7-day delivery or switch to backup carrier BrazilExpress"

**2. Measurable (Quantified Outcome)**
- ❌ Bad: "Make customers happier"
- ✅ Good: "Increase NPS from 12 to 25 (industry benchmark)"

**3. Achievable (Realistic Given Resources)**
- ❌ Bad: "Achieve same-day delivery nationwide" (requires massive infrastructure investment)
- ✅ Good: "Pilot same-day delivery in São Paulo (largest market) with existing carrier"

**4. Relevant (Tied to Business Goals)**
- ❌ Bad: "Redesign logo" (doesn't address delivery crisis)
- ✅ Good: "Fix delivery issues to protect $5.4M/month Southeast revenue stream"

**5. Time-Bound (Clear Deadline)**
- ❌ Bad: "Eventually improve delivery times"
- ✅ Good: "Reduce delivery delays to <40% by December 1, 2018"

**SMART Goals Framework:**
- **S**pecific
- **M**easurable
- **A**chievable
- **R**elevant
- **T**ime-bound

---

## Connecting Insights to Business Impact

### The "So What?" Test

**For every insight, ask: "So what? Why does this matter to the business?"**

**Example 1:**
- **Data:** "Average order value declined from $167 to $155"
- **So What?** "Revenue dropped 4.13% despite order growth"
- **So What?** "We're $1.55M behind annual target"
- **So What?** "Miss target = miss bonuses + shareholder disappointment"
- **Action:** "Implement upsell strategies to recover AOV"

**Example 2:**
- **Data:** "South region has 85% on-time delivery"
- **So What?** "South has highest customer satisfaction (4.5★)"
- **So What?** "South has 30% repeat purchase rate (vs 18% national avg)"
- **So What?** "South delivery model is replicable to other regions"
- **Action:** "Expand South region carrier (BrazilExpress) to Southeast"

---

## Practical Exercise: Write Actionable Insights

### Task 1: Transform Data into Insight (5 minutes)

**Given Data:**
- CLV Tier "VIP Champion": 7 customers (0.007%)
- VIP Champions generated $95,488 revenue (1.1% of total)
- VIP average order frequency: 8 orders per year
- Non-VIP average order frequency: 1.2 orders per year

**Your Task:** Write an actionable insight following this template:

```
WHAT: [State the data observation]

WHY IT MATTERS: [Business impact]

ROOT CAUSE/PATTERN: [Why is this happening?]

ACTION REQUIRED:
- Owner: [Who should act]
- Action: [Specific steps]
- Timeline: [When]
- Expected Outcome: [Projected result]
```

**Sample Answer:**
```
WHAT: Only 7 customers (0.007%) are VIP Champions, but
they generate $95K revenue (1.1% of total). VIPs order
8x per year vs 1.2x for non-VIPs.

WHY IT MATTERS: VIPs are 600% more valuable than average
customers. Losing even 1 VIP = losing 70 average customers.
Currently no VIP retention program, putting $95K at risk.

ROOT CAUSE/PATTERN: High order frequency indicates VIPs
have found product-market fit. Likely B2B buyers or bulk
purchasers (needs validation).

ACTION REQUIRED:
- Owner: Customer Success Lead
- Action: (1) Interview all 7 VIPs to identify common
  traits; (2) Create VIP retention program (dedicated
  account manager, priority support, exclusive offers);
  (3) Build lookalike model to identify future VIPs early
- Timeline: Launch VIP program by Nov 1
- Expected Outcome: Retain 100% of current VIPs (protect
  $95K), identify 20 potential VIPs from current customer
  base ($200K incremental revenue opportunity)
```

---

## Connection to Prior Learning

### Week 9 (RFM Analysis - SQL)
**Then:** Calculated customer segments with SQL queries
**Now:** Present RFM insights with recommendations: "Champions = 5% of customers, 35% of revenue. Action: Launch loyalty program targeting Champions."

### Week 11 (Marketing Analytics)
**Then:** Calculated marketing ROI and conversion rates
**Now:** Highlight underperforming channels: "Email converts at 2% vs 8% for paid search. Action: Optimize email copy + subject lines or reallocate budget."

### Week 12 (Financial Metrics)
**Then:** Calculated gross margin and profitability
**Now:** Flag margin compression: "Gross margin declined from 32% to 28%. Action: Audit COGS + negotiate supplier contracts."

---

## Key Takeaways

### What You Learned
1. ✅ Actionable insight = Data + Context + Specific Recommendation
2. ✅ Anomalies: spikes/drops, trend reversals, unexpected patterns, outliers
3. ✅ Conditional formatting highlights problems visually (traffic lights, color scales)
4. ✅ Recommendations should be SMART (Specific, Measurable, Achievable, Relevant, Time-bound)
5. ✅ Always connect insights to business impact ("So What?" test)
6. ✅ Prioritize recommendations using urgency/impact matrix

### What's Next
In the final lesson, we'll integrate everything into a complete **Marketing Performance Data Story Dashboard** that guides executives from problem identification to action.

---

## Quick Reference Card

### Actionable Insight Template
```
┌──────────────────────────────────────┐
│ [Priority] [INSIGHT TITLE]          │
├──────────────────────────────────────┤
│ WHAT: [Data observation]            │
│ WHY IT MATTERS: [Business impact]   │
│ ROOT CAUSE: [Explanation]           │
│                                      │
│ ACTION:                              │
│ • Owner: [Name/Role]                 │
│ • Steps: [Specific actions]          │
│ • Timeline: [Deadline]               │
│ • Expected: [Outcome + metrics]      │
└──────────────────────────────────────┘
```

### Anomaly Detection Checklist
```
☐ Sudden spike or drop (>±20% change)
☐ Trend reversal (direction change)
☐ Seasonality violation (unexpected pattern)
☐ Benchmark deviation (far from industry standard)
☐ Outlier (far from distribution mean)
☐ Logical impossibility (violates business rules)
```

---

## Questions to Test Your Understanding

1. What are the five components of an actionable insight?
2. How do you detect anomalies in time series data?
3. What's the difference between conditional formatting and annotations?
4. What does SMART stand for in the context of recommendations?
5. How do you prioritize multiple recommendations?

**Answers at end of notes**

---

## Answers to Questions

1. **Five components:** (1) What happened (data), (2) Why it matters (impact), (3) Who should act (owner), (4) What to do (action), (5) Expected outcome (result)
2. **Anomaly detection:** Look for (a) sudden spikes/drops >±20% from trend, (b) trend reversals/inflection points, (c) values >2 standard deviations from mean, (d) seasonality violations, (e) outliers in distributions
3. **Conditional formatting:** Automatically colors cells/charts based on rules (e.g., red if <target); **Annotations:** Manual text/labels explaining context or insights
4. **SMART:** Specific, Measurable, Achievable, Relevant, Time-bound (framework for writing effective recommendations)
5. **Prioritize recommendations:** Use urgency/impact matrix—High impact + High urgency = Do First; High impact + Low urgency = Plan; Low impact = Delegate or Eliminate

---

**Next Lecture:** 04_executive_summary_design.md
