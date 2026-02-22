# Progressive Disclosure and Annotations in Looker Studio

## Week 15 - Thursday Session - Part 2

### Duration: 20 minutes

---

## What Is Progressive Disclosure?

**Progressive Disclosure** is a design principle where information is revealed gradually, layer by layer, from general to specific. It prevents cognitive overload by showing users only what they need at each stage of analysis.

### The Problem It Solves

**Information Overload:** Showing all data at once overwhelms users and hides insights in noise.

**Example - Bad Design (Everything at Once):**
```
Dashboard with 25 charts, 50+ metrics, 200 data points visible
→ User reaction: "Where do I even start?"
```

**Example - Good Design (Progressive Disclosure):**
```
Level 1: 4 KPI scorecards (What's the overall health?)
   ↓ User clicks "Revenue" scorecard
Level 2: Revenue trend chart (How has it changed?)
   ↓ User notices August decline
Level 3: August breakdown by region (Where's the problem?)
   ↓ User identifies Southeast as issue
Level 4: Southeast city-level detail (Specifically which cities?)
```

---

## The Four Levels of Progressive Disclosure

### Level 1: Executive Summary (Always Visible)

**Purpose:** Answer "How are we doing?" in 5 seconds

**What to Include:**
- 3-5 KPI scorecards (most critical metrics)
- Current value, trend indicator (↑↓), and comparison (vs target, vs prior period)
- High-level status indicator (Green/Yellow/Red)

**Example Layout:**
```
┌──────────────────────────────────────────────────────┐
│  Q3 2018 Olist Performance Dashboard                 │
├──────────────────────────────────────────────────────┤
│ ┌──────────┐ ┌──────────┐ ┌──────────┐ ┌──────────┐ │
│ │Revenue   │ │Orders    │ │AOV       │ │NPS Proxy │ │
│ │$3.05M    │ │19,630    │ │$155.16   │ │+12       │ │
│ │↓ -2.3%   │ │↑ +5.1%   │ │↓ -7.1%   │ │↓ -8 pts  │ │
│ │⚠️ Yellow  │ │✅ Green   │ │⚠️ Yellow  │ │❌ Red     │ │
│ └──────────┘ └──────────┘ └──────────┘ └──────────┘ │
└──────────────────────────────────────────────────────┘
```

**Key Principle:** No drill-down needed. Executive sees health at a glance.

---

### Level 2: Key Trends (Primary View)

**Purpose:** Answer "What changed and when?"

**What to Include:**
- Time series charts showing trends over time
- Highlighted anomalies or inflection points
- Comparative charts (vs benchmark, vs prior year)
- 1-2 sentences of narrative context

**Example Implementation:**

**Chart Title:** "Revenue Trend: Q3 Decline Driven by AOV Drop"

**Visual:** Line chart with annotations
```
Revenue ($M)
 1.2 ┤                  ╱╲
 1.1 ┤              ╱       ╲
 1.0 ┤          ╱               ╲ ← Annotation: "Aug decline
 0.9 ┤      ╱                     \  -4.13% MoM"
 0.8 ┤  ╱                           \
     └──────────────────────────────
      Jul      Aug      Sep      Oct
```

**Narrative Box (below chart):**
"August revenue declined 4.13% month-over-month despite order volume growth. Root cause: Average Order Value dropped from $167 to $155 (-7.1%), indicating customers purchasing lower-value items or fewer items per order."

---

### Level 3: Segment Breakdown (Drill-Down Analysis)

**Purpose:** Answer "Where specifically is the issue?"

**What to Include:**
- Breakdowns by dimension (region, product, customer segment)
- Comparison of best vs worst performers
- Correlation analysis
- Tables with detailed metrics

**Example Implementation:**

**Triggered by:** User clicks on "August" data point in trend chart OR clicks "Analyze by Region" button

**New View Appears:**

```
┌──────────────────────────────────────────────────────┐
│  August 2018 Revenue Breakdown by Region             │
├──────────────────────────────────────────────────────┤
│ Southeast:  $540K  (55%)  ↓ -5.2%  ⚠️ Main problem   │
│ South:      $180K  (18%)  ↑ +2.1%  ✅ Growing        │
│ Northeast:  $140K  (14%)  ↓ -3.1%  ⚠️ Declining      │
│ Central:    $ 80K   (8%)  ↑ +1.5%  ✅ Stable         │
│ North:      $ 45K   (5%)  ↓ -8.3%  ❌ Critical       │
└──────────────────────────────────────────────────────┘
```

**Insight Callout:**
"Southeast region (55% of revenue) declined 5.2% in August. Investigation shows delivery delays increased from 60% to 75% this month, correlating with satisfaction drop."

---

### Level 4: Raw Data & Details (On-Demand)

**Purpose:** Answer "Show me the exact numbers"

**What to Include:**
- Detailed data tables with all dimensions and metrics
- Export to CSV functionality
- Filters for custom slicing
- Footnotes and methodology notes

**Implementation:**
- Link: "View Detailed Data Table" at bottom of each chart
- Or: Separate "Data Explorer" page accessible from navigation
- Or: Hover tooltips showing exact values

**Example:**

**User Action:** Clicks "Export Southeast Data" button

**Result:** CSV download with all Southeast orders, including:
- Order ID, Date, Customer, Product, Price, Freight, Review Score, Delivery Days
- 5,430 rows (all August Southeast orders)

**Use Case:** Power users can perform custom analysis in Excel/Python; analysts can validate dashboard calculations.

---

## Implementing Progressive Disclosure in Looker Studio

### Technique 1: Multi-Page Navigation

**Structure:**
```
Page 1: Executive Summary (Level 1 + Level 2)
Page 2: Regional Deep Dive (Level 3 for Geography)
Page 3: Product Performance (Level 3 for Products)
Page 4: Customer Segmentation (Level 3 for Customer RFM)
Page 5: Data Explorer (Level 4 - Raw Tables)
```

**How to Implement:**
1. Create multiple pages in your Looker Studio report
2. Add navigation menu at top or left sidebar
3. Use descriptive page names ("Regional Performance" not "Page 2")
4. Add breadcrumb trail: Home > Regional > Southeast

**Navigation Menu Design:**
```
┌─────────────────────────────────────────────┐
│ [📊 Summary] [🗺️ Regional] [📦 Products]    │
│ [👥 Customers] [📁 Data Explorer]            │
└─────────────────────────────────────────────┘
```

---

### Technique 2: Drill-Down with Filters

**Implementation:**
1. Start with high-level chart (e.g., Revenue by Region)
2. Enable "Apply filter on click" in chart settings
3. When user clicks a bar/slice, entire dashboard filters to that dimension value
4. Add "Clear Filters" button to return to summary view

**User Journey:**
```
1. View National Map (all regions colored)
2. Click "Southeast" region on map
3. All charts filter to Southeast only
4. See Southeast-specific trends, top cities, customer segments
5. Click "Clear Filters" to return to national view
```

**Looker Studio Configuration:**
- Chart → Style → Interactions → "Apply filter"
- Add Control → "Clear all filters" button

---

### Technique 3: Show/Hide Sections with Filters

**Use Case:** Advanced users want more detail; executives want simplicity

**Implementation:**
1. Create detailed analysis section (e.g., statistical deep dive)
2. Add a Checkbox Control with two options: "Basic View" / "Advanced View"
3. Use filter to hide/show advanced section based on checkbox selection

**Example:**
```
[☑] Show Advanced Metrics

If checked, displays:
- Standard deviation calculations
- Confidence intervals
- Statistical significance tests
- Correlation matrices
```

**Benefit:** Keeps dashboard clean for most users while supporting power users.

---

### Technique 4: Embedded Data Studio Charts (Nested Disclosure)

**Use Case:** Provide context without leaving current view

**Implementation:**
1. Main chart shows trend
2. Smaller "context charts" embedded nearby
3. Conditional visibility: Context charts only appear when main chart filtered

**Example:**
```
┌──────────────────────────────────────────────────┐
│ Main: Revenue Trend (Line Chart)                │
│ [User clicks "August" point]                    │
│                                                  │
│ → Context 1: August Revenue by Category (Pie)   │
│ → Context 2: August Top Products (Bar)          │
│ → Context 3: August Customer Segments (Donut)   │
└──────────────────────────────────────────────────┘
```

---

## Annotations: Adding Narrative to Charts

### What Are Annotations?

**Annotations** are contextual notes, labels, and explanations added directly to charts to guide interpretation and highlight insights.

### Types of Annotations in Looker Studio

#### 1. **Text Boxes** (Static Explanations)

**Use Case:** Provide context that doesn't change

**Example:**
```
┌──────────────────────────────────────────┐
│ Revenue Trend Chart                      │
│ [Line chart visualization]               │
│                                          │
│ 📌 Context: August typically shows       │
│ seasonal dip due to Brazilian winter     │
│ holidays. 2018 decline exceeds seasonal  │
│ expectation by 2.5%.                     │
└──────────────────────────────────────────┘
```

**How to Add:**
1. Insert → Text
2. Position near relevant chart
3. Style with subtle background color to distinguish from charts

---

#### 2. **Reference Lines** (Target Values and Thresholds)

**Use Case:** Show targets, benchmarks, or acceptable ranges

**Example:**
```
Delivery Days (Time Series)

20 ┤                              ╱────────
   │                          ╱            ← Target: 14 days (red line)
15 ┤─────────────────────────
   │                    ╱                  ← Actual delivery trend
10 ┤            ╱──────
   │    ╱──────                            ← Goal: 7 days (green line)
 5 ┤────
   └──────────────────────────────
     Jan  Feb  Mar  Apr  May  Jun
```

**How to Add:**
1. Edit chart → Style tab → Reference lines
2. Add line at value (e.g., 14 for target delivery days)
3. Label: "SLA Target: 14 Days"
4. Color: Red (warning) or Green (goal)

**Business Value:** Instantly see if metrics are within acceptable range.

---

#### 3. **Data Labels** (Show Exact Values)

**Use Case:** Eliminate guesswork—show precise numbers

**Example:**
```
Revenue by Region (Bar Chart)

Southeast  ██████████████████████ $5.4M
South      ████████ $1.8M
Northeast  ██████ $1.4M
Central    ███ $0.8M
North      ██ $0.4M
```

**How to Add:**
1. Edit chart → Style tab → Data labels
2. Enable "Show data labels"
3. Choose position: Outside end of bar, Inside bar, Above/below
4. Optional: Show percentage AND value

**Tip:** Use data labels sparingly. Too many numbers = cluttered chart.

---

#### 4. **Tooltips** (Contextual Hover Information)

**Use Case:** Provide details without cluttering chart

**Looker Studio Default:** Tooltips show dimension and metric values on hover

**Customization:**
1. Edit chart → Setup tab → Tooltip
2. Add additional metrics to tooltip (e.g., hover on revenue bar, see Order Count + AOV)
3. Add calculated fields for context (e.g., "% of Total Revenue")

**Example:**
```
[User hovers over "Southeast" bar]

Tooltip appears:
─────────────────
Region: Southeast
Revenue: $5,376,342
Orders: 34,650
AOV: $155.16
% of Total: 55.3%
─────────────────
```

---

#### 5. **Callout Boxes** (Highlight Key Insights)

**Use Case:** Draw attention to most important finding

**Implementation:**
1. Insert → Rectangle shape
2. Fill with attention-grabbing color (yellow for caution, red for alert, blue for info)
3. Add text with key insight
4. Position prominently (top of dashboard or next to relevant chart)

**Example:**
```
┌────────────────────────────────────────┐
│ ⚠️ ALERT: Southeast Delivery Crisis    │
│                                        │
│ 75% of orders delayed (up from 60%)   │
│ Customer satisfaction dropped to 3.8★  │
│ $450K revenue at risk this quarter     │
│                                        │
│ [View Southeast Details Button]       │
└────────────────────────────────────────┘
```

**Visual Hierarchy:** Callout box is first thing user sees → guides them to main story.

---

#### 6. **Event Markers** (Annotate Time Series)

**Use Case:** Explain spikes, drops, or anomalies in time series data

**Manual Implementation (Looker Studio doesn't have native event markers):**

**Workaround 1: Text Boxes with Arrows**
```
Revenue Chart

$1.2M ┤                    ↓ "New logistics
      │                  /   partner launched"
$1.0M ┤              ╱
      │          ╱
$0.8M ┤      ╱
      └─────────────────────
       Jul   Aug   Sep   Oct
```

1. Add Text Box above chart
2. Position at X-axis location of event
3. Add arrow character (↓) or emoji (📍) pointing to event date
4. Describe event: "Holiday promotion started"

**Workaround 2: Reference Line with Label**
- Add vertical reference line at event date
- Label: "Campaign Launch: Aug 15"

---

### Annotation Best Practices

#### When to Annotate

✅ **Do Annotate:**
- Anomalies or unexpected changes
- Business events (campaigns, product launches, holidays)
- Context that's not obvious from data alone
- Comparisons to targets or benchmarks
- Actionable insights

❌ **Don't Annotate:**
- Obvious patterns (don't state "revenue increased" when chart clearly shows increase)
- Redundant information already in chart title
- Every single data point (clutters chart)
- Technical jargon (use business language)

---

#### Annotation Style Guide

**Tone:**
- Direct and action-oriented
- Business-focused (impact on revenue, customers, operations)
- Avoid hedging language ("might", "possibly", "could")

**Wrong:**
"There seems to be a possible correlation between delivery delays and review scores that might warrant further investigation."

**Right:**
"Late deliveries directly cause low reviews. Each week of delay = -0.3 stars. Action: Audit Southeast logistics by Oct 15."

---

**Length:**
- Callout boxes: 1-2 sentences (max 20 words)
- Text annotations: 1 short paragraph (max 50 words)
- Detailed context: Link to separate documentation page

---

**Visual Hierarchy:**
- Most important insight = Largest text, boldest color
- Supporting details = Smaller text, neutral color
- Footnotes = Smallest text, gray

---

## Connection to Prior Learning

### Week 13 (Chart Types)
**Then:** "Bar charts compare categories"
**Now:** "Use bar chart with annotations to show which category is problem vs benchmark"

### Week 14 (Interactive Controls)
**Then:** "Add filters for user exploration"
**Now:** "Use filters to create progressive disclosure—Level 1 (no filters) → Level 3 (filtered to segment)"

### Week 9 (RFM Analysis - SQL)
**Then:** Calculated customer segments in SQL queries
**Now:** Present RFM segments in dashboard with annotations: "Champions generate 45% of revenue—prioritize retention"

---

## Practical Exercise: Add Annotations to Your Dashboard

### Task (10 minutes)

1. Open your Week 15 YTD Revenue dashboard (from Exercise 2)

2. Add **Reference Line** to YTD chart:
   - Target: $10M
   - Label: "Annual Target"
   - Color: Red dashed

3. Add **Callout Box** at top:
   ```
   ⚠️ Q3 Status: Behind pace by 15.5%
   Need $387K/month avg in Q4 to hit target
   ```

4. Add **Annotation** to August data point:
   - Text box: "August MoM decline (-4.13%): AOV pressure + delivery issues"
   - Position: Next to August point on trend chart

5. Add **Data Labels** to top 3 states in regional breakdown chart

6. Test **5-Second Rule**: Show dashboard to someone. Can they identify the problem in 5 seconds?

---

## Common Annotation Mistakes

### Mistake 1: Over-Annotation
**Problem:** Every chart has 5+ text boxes

**Fix:** Annotate only the most important insights (1-2 per dashboard page)

---

### Mistake 2: Stating the Obvious
**Problem:** Annotation says "Revenue increased in Q2" when chart clearly shows upward trend

**Fix:** Explain WHY or WHAT TO DO, not WHAT (chart already shows what)

---

### Mistake 3: Orphaned Context
**Problem:** Annotation far from relevant chart

**Fix:** Place annotations next to or overlapping the chart element they explain

---

### Mistake 4: Analysis Paralysis
**Problem:** Annotation says "Further analysis needed"

**Fix:** Provide actionable insight or next step

---

## Key Takeaways

### What You Learned
1. ✅ Progressive disclosure = 4 levels (Summary → Trends → Segments → Details)
2. ✅ Multi-page navigation guides users through story
3. ✅ Drill-down with filters enables self-service exploration
4. ✅ Annotations add context and narrative to charts
5. ✅ 6 types of annotations: Text boxes, reference lines, data labels, tooltips, callouts, event markers
6. ✅ Annotate insights, not obvious facts
7. ✅ Keep annotations concise and action-oriented

### What's Next
In the next lesson, we'll focus on **Actionable Insights**—transforming data observations into specific business recommendations.

---

## Quick Reference Card

### Progressive Disclosure Levels
| Level | Content | User Question Answered |
|-------|---------|------------------------|
| **1** | KPI Scorecards | "How are we doing overall?" |
| **2** | Trend Charts | "What changed and when?" |
| **3** | Segment Breakdowns | "Where specifically is the issue?" |
| **4** | Detailed Tables | "Show me exact numbers" |

### Annotation Checklist
```
☐ Added reference lines for targets/benchmarks
☐ Callout box highlights main insight
☐ Event markers explain anomalies in time series
☐ Data labels on key data points only (not all)
☐ Tooltips include additional context metrics
☐ Annotations are concise (1-2 sentences max)
☐ Annotations guide to action, not just observation
```

---

## Questions to Test Your Understanding

1. What is progressive disclosure and why does it matter for dashboard design?
2. What should be included in Level 1 (Executive Summary) of a dashboard?
3. How do you implement drill-down navigation in Looker Studio?
4. When should you use a reference line vs a text annotation?
5. What makes a good annotation vs a bad annotation?

**Answers at end of notes**

---

## Answers to Questions

1. **Progressive disclosure:** Revealing information layer by layer from general to specific. Prevents cognitive overload and guides users through analysis naturally.
2. **Level 1 should include:** 3-5 KPI scorecards with current value, trend indicator, and comparison; high-level status; no drill-down required.
3. **Implement drill-down:** Multi-page navigation, "Apply filter on click" chart interactions, or Show/Hide sections with checkbox controls.
4. **Reference line:** Use for fixed targets, thresholds, or benchmarks that don't change (e.g., "$10M annual target"). **Text annotation:** Use for contextual explanations of events, anomalies, or insights that require narrative (e.g., "Holiday campaign launched Aug 15").
5. **Good annotation:** Concise, action-oriented, explains WHY or WHAT TO DO. **Bad annotation:** States obvious facts, long-winded, uses jargon, doesn't lead to action.

---

**Next Lecture:** 03_highlighting_anomalies_recommendations.md
