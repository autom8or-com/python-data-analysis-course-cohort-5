# Dashboard Layout Patterns - Templates and Best Practices

**Week 14 Thursday - Resource Guide**
**Purpose:** Ready-to-use layout templates for professional dashboard design

---

## Table of Contents

1. [Layout Pattern Library](#layout-pattern-library)
2. [Page Templates by Use Case](#page-templates-by-use-case)
3. [Grid System Reference](#grid-system-reference)
4. [Spacing Standards](#spacing-standards)
5. [Common Layout Mistakes](#common-layout-mistakes)
6. [Layout Checklist](#layout-checklist)

---

## Layout Pattern Library

### Pattern 1: F-Pattern (Information-Dense Dashboards)

**Best For:** Operational dashboards, analytical reports, multi-section views

**Reading Flow:**
1. Horizontal scan across top (KPIs)
2. Vertical scan down left side (section labels)
3. Horizontal scan in middle (main charts)
4. Quick scan to bottom (details)

**Template:**
```
┌────────────────────────────────────────────────┐
│ DASHBOARD TITLE                    [Filters]   │ ← Top bar
├────────────────────────────────────────────────┤
│ ████████ KPI ROW ████████████████████████      │ ← Horizontal scan 1
│ KPI1    KPI2    KPI3    KPI4    KPI5           │
├────────────────────────────────────────────────┤
│ SECTION 1: OVERVIEW            █               │ ← Vertical scan (left)
│ [Main Trend Chart - Full Width]                │ ← Horizontal scan 2
├────────────────────────────────────────────────┤
│ SECTION 2: BREAKDOWNS          █               │ ← Continue vertical
│ [Chart A]       [Chart B]       [Chart C]      │ ← Horizontal scan 3
├────────────────────────────────────────────────┤
│ SECTION 3: GEOGRAPHIC          █               │
│ [Geo Map]                [Regional Stats]      │
├────────────────────────────────────────────────┤
│ SECTION 4: DETAILS             █               │
│ [Detailed Table with many rows]                │
└────────────────────────────────────────────────┘
  ↑ Section labels create strong left anchor
```

**Pixel-Perfect Dimensions (1600px Dashboard):**
```
Top Bar: 1600 × 80px
KPI Row: 1600 × 150px (5 KPIs @ 300×150 each, 20px spacing)
Section Labels: 200 × 40px (text boxes, left-aligned)
Main Chart: 1560 × 350px (full width minus margins)
Sub-Charts: 500 × 300px each (3 across = 1560px with spacing)
Table: 1560 × 400px
Margins: 20px left/right
```

**When to Use:**
- ✓ Multi-section dashboards (4+ sections)
- ✓ Long-form reports (scrollable)
- ✓ Analyst/manager audiences (need details)
- ✗ Executive summaries (too much info)
- ✗ Mobile devices (doesn't adapt well)

---

### Pattern 2: Z-Pattern (Executive Dashboards)

**Best For:** Executive summaries, single-page views, presentation mode

**Reading Flow:**
1. Top-left → Top-right (header scan)
2. Diagonal: Top-right → Center-left (main focus)
3. Bottom-left → Bottom-right (supporting info)

**Template:**
```
┌────────────────────────────────────────────────┐
│ ①─────────────────────────→②                   │
│  Dashboard Title            Last Updated       │
│   \                               ↓            │
│    \                      [KPI Scorecard]      │
│     \                             ↓            │
│      \                                         │
│       \           [MAIN CHART]                 │
│        \          (Primary Visual)             │
│         \                 ↓                    │
│          \                ↓                    │
│           ↘               ↓                    │
│            ③──────────────→④                   │
│            [Insight Box]  [Action Items]       │
└────────────────────────────────────────────────┘
```

**Pixel-Perfect Dimensions (1600×900 Single Page):**
```
Header Bar: 1600 × 100px
  - Title (left): 800 × 100px
  - Last Updated (right): 800 × 100px

KPI Scorecard (top-right): 600 × 200px
Main Chart (center): 1200 × 450px
Insight Box (bottom-left): 700 × 150px
Action Items (bottom-right): 860 × 150px
```

**When to Use:**
- ✓ CEO/executive dashboards
- ✓ Single-page, no-scroll designs
- ✓ Presentation mode (projected on screen)
- ✓ Focus on one key metric/chart
- ✗ Detailed analysis (not enough space)
- ✗ Multiple related metrics (use F-pattern)

---

### Pattern 3: Grid Layout (Flexible/Responsive)

**Best For:** Modern dashboards, mobile-responsive, balanced content

**12-Column Grid System:**
```
┌─┬─┬─┬─┬─┬─┬─┬─┬─┬─┬─┬─┐
│1│2│3│4│5│6│7│8│9│0│1│2│ ← 12 columns
└─┴─┴─┴─┴─┴─┴─┴─┴─┴─┴─┴─┘

Each column = 1600px / 12 = ~133px
```

**Common Grid Configurations:**

**Full Width (12 columns):**
```
┌─────────────────────────────────────┐
│                                     │
│     Single Chart (12 cols)          │
│                                     │
└─────────────────────────────────────┘
```

**Half-Half (6 + 6):**
```
┌─────────────────┬──────────────────┐
│                 │                  │
│  Chart A (6)    │   Chart B (6)    │
│                 │                  │
└─────────────────┴──────────────────┘
```

**Thirds (4 + 4 + 4):**
```
┌──────────┬──────────┬──────────┐
│          │          │          │
│  KPI (4) │ KPI (4)  │ KPI (4)  │
│          │          │          │
└──────────┴──────────┴──────────┘
```

**Asymmetric (8 + 4):**
```
┌────────────────────────┬─────────┐
│                        │         │
│   Main Chart (8)       │ Side(4) │
│                        │         │
└────────────────────────┴─────────┘
```

**Complex Multi-Row:**
```
┌──────┬──────┬──────┬──────┐
│ KPI  │ KPI  │ KPI  │ KPI  │ ← Row 1: 4×3 cols
│ (3)  │ (3)  │ (3)  │ (3)  │
├──────┴──────┴──────┴──────┤
│                           │ ← Row 2: 1×12 cols
│   Main Trend (12)         │
│                           │
├────────────┬──────────────┤
│            │              │ ← Row 3: 2×6 cols
│  Chart (6) │  Chart (6)   │
│            │              │
├────┬───────┴──────┬───────┤
│ S  │              │   S   │ ← Row 4: 3+6+3
│(3) │  Detail (6)  │  (3)  │
└────┴──────────────┴───────┘
```

**When to Use:**
- ✓ Modern, clean designs
- ✓ Responsive layouts (desktop → tablet → mobile)
- ✓ Balanced information presentation
- ✓ When charts are equally important
- ✗ When strong hierarchy needed (use F-pattern)

---

### Pattern 4: Dashboard-First (Mobile-Primary)

**Best For:** Field teams, sales reps, mobile-first users

**Mobile Layout (375px Width):**
```
┌─────────────────┐
│ 📱 HEADER       │ ← 375 × 60px
├────────┬────────┤
│  KPI1  │  KPI2  │ ← 2×2 grid
│        │        │   175×120 each
├────────┼────────┤
│  KPI3  │  KPI4  │
│        │        │
├────────┴────────┤
│                 │
│  [Chart 1]      │ ← Full width
│  Stacked        │   375 × 200px
│                 │
├─────────────────┤
│                 │
│  [Chart 2]      │
│  Vertical       │
│                 │
├─────────────────┤
│  [Simplified    │
│   Table]        │
│  3 cols max     │
└─────────────────┘
```

**Key Mobile Principles:**
- Max width: 375px (iPhone standard)
- Vertical stacking only (no side-by-side)
- Large tap targets (44×44px minimum)
- Simplified charts (fewer data points)
- Minimal text (icons preferred)
- 3-4 columns max in tables
- Font size: 14px minimum

**When to Use:**
- ✓ Sales teams in the field
- ✓ Executives on-the-go
- ✓ Mobile-first audiences
- ✗ Detailed analysis (too limited screen space)

---

## Page Templates by Use Case

### Template 1: Executive Summary Dashboard

**Audience:** CEO, C-suite executives
**Purpose:** Quick daily snapshot
**View Time:** <2 minutes

**Layout:**
```
┌────────────────────────────────────────────────┐
│ EXECUTIVE SUMMARY - [Date]        [Logo]      │ ← Header
├───────┬───────┬───────┬───────┬───────┬───────┤
│  Rev  │Orders │  AOV  │Margin │Growth │NPS    │ ← 6 KPIs
│ 45.3M │ 15.2K │ 2.9K  │ 32%   │ ↑12%  │  73   │
├───────┴───────┴───────┴───────┴───────┴───────┤
│                                               │
│  REVENUE TREND (Last 30 Days)                 │ ← Main chart
│  [Line chart with target line]               │
│                                               │
├───────────────────────┬───────────────────────┤
│  TOP 3 CATEGORIES     │  GEOGRAPHIC MIX       │ ← Supporting
│  [Simple bar chart]   │  [Pie chart]          │
├───────────────────────┴───────────────────────┤
│ 🔴 Alerts: Inventory low on Product X         │ ← Actions
│ 🟢 On Track: Q1 revenue goal (87% complete)   │
└────────────────────────────────────────────────┘

Size: 1600 × 900px (single page, no scroll)
Charts: 6 max (not overwhelming)
Colors: Minimal (green/red for up/down)
```

---

### Template 2: Operational Dashboard

**Audience:** Managers, operations teams
**Purpose:** Daily monitoring and quick action
**View Time:** 5-10 minutes

**Layout:**
```
┌────────────────────────────────────────────────┐
│ OPERATIONS DASHBOARD          [Date Filter]   │
├────────────────────────────────────────────────┤
│ PERFORMANCE INDICATORS                         │
│ ┌─────┬─────┬─────┬─────┬─────┐               │ ← 5 KPIs
│ │ KPI1│ KPI2│ KPI3│ KPI4│ KPI5│               │   with gauges
│ │[Gge]│[Gge]│[Gge]│[Gge]│[Gge]│               │
│ └─────┴─────┴─────┴─────┴─────┘               │
├────────────────────────────────────────────────┤
│ TRENDS & PATTERNS                              │
│ [Daily Volume Bar Chart - Last 30 Days]       │
├───────────────────────┬────────────────────────┤
│ BY CATEGORY           │ BY REGION              │
│ [Stacked bar chart]   │ [Geo map]              │
├───────────────────────┴────────────────────────┤
│ RECENT ACTIVITY                                │
│ [Live table: Last 20 transactions]            │
├────────────────────────────────────────────────┤
│ ALERTS & ACTIONS                               │
│ • High priority: 3 items    [View All →]      │
│ • Medium priority: 7 items                     │
└────────────────────────────────────────────────┘

Size: 1600 × 1200px (scrollable)
Update Frequency: Every 5 minutes (near real-time)
Alerts: Prominent (top or bottom)
```

---

### Template 3: Analytical Deep-Dive

**Audience:** Data analysts, researchers
**Purpose:** In-depth exploration and investigation
**View Time:** 20+ minutes

**Layout:**
```
┌────────────────────────────────────────────────┐
│ CUSTOMER BEHAVIOR ANALYSIS    [Filters ▼▼▼]   │ ← Many filters
├────────────────────────────────────────────────┤
│ OVERVIEW METRICS                               │
│ [3 KPIs]                                       │
├────────────────────────────────────────────────┤
│ COHORT ANALYSIS                                │
│ [Cohort retention heatmap - Large]            │
├────────────────────────────────────────────────┤
│ SEGMENT COMPARISON                             │
│ [Scatter plot: RFM analysis with drill-down]  │
├────────────────────┬──────────────────────────┤
│ DISTRIBUTION       │ CORRELATION              │
│ [Histogram]        │ [Correlation matrix]     │
├────────────────────┴──────────────────────────┤
│ DETAILED DATA EXPLORATION                      │
│ [Pivot table with 10+ dimensions]             │
├────────────────────────────────────────────────┤
│ STATISTICAL SUMMARY                            │
│ [Box plots, percentiles, outliers]            │
└────────────────────────────────────────────────┘

Size: 1600 × 2000px (long scroll)
Charts: 10-15 (comprehensive)
Interactivity: High (filters, drill-downs)
```

---

### Template 4: Marketing Dashboard

**Audience:** Marketing team
**Purpose:** Campaign performance and customer acquisition
**View Time:** 5-10 minutes

**Layout:**
```
┌────────────────────────────────────────────────┐
│ MARKETING PERFORMANCE - [Campaign Name]       │
├────────┬────────┬────────┬────────┬───────────┤
│ Reach  │ Clicks │  CTR   │ Conv.  │   ROI     │ ← Campaign KPIs
│ 125K   │ 8.4K   │  6.7%  │  3.2%  │   450%    │
├────────┴────────┴────────┴────────┴───────────┤
│ FUNNEL PERFORMANCE                             │
│ [Funnel chart: Impressions → Clicks → Conv.]  │
├───────────────────────┬────────────────────────┤
│ CHANNEL BREAKDOWN     │ GEOGRAPHIC REACH       │
│ [Pie: Email, Social,  │ [Geo map: By state]    │
│  Search, Display]     │                        │
├───────────────────────┴────────────────────────┤
│ DAILY PERFORMANCE TREND                        │
│ [Line chart: Spend vs Revenue over time]      │
├────────────────────────────────────────────────┤
│ TOP PERFORMING ADS                             │
│ [Table: Ad creative, CTR, conversions, cost]  │
└────────────────────────────────────────────────┘

Size: 1600 × 1000px
Colors: Brand colors (company palette)
Focus: Conversion and ROI metrics
```

---

## Grid System Reference

### 12-Column Grid Breakdown

**Column Widths (1600px Dashboard with 20px Gutters):**

```
Total Width: 1600px
Margins: 20px left + 20px right = 40px
Usable Width: 1560px
Gutters: 11 × 20px = 220px
Column Width: (1560 - 220) / 12 = 111.67px ≈ 112px

Column Configurations:
1 col  = 112px
2 cols = 244px (112 + 20 + 112)
3 cols = 376px
4 cols = 508px
5 cols = 640px
6 cols = 772px (half width)
7 cols = 904px
8 cols = 1036px
9 cols = 1168px
10 cols = 1300px
11 cols = 1432px
12 cols = 1560px (full width)
```

### Common Grid Patterns

**KPI Row (4 Equal KPIs):**
```
Each KPI: 3 columns = 376px wide
Spacing: 20px gutter
Total: (376 × 4) + (20 × 3) = 1564px ≈ Full width
```

**Main Chart + Sidebar:**
```
Main: 8 columns = 1036px
Sidebar: 4 columns = 508px
Gutter: 20px
Total: 1036 + 20 + 508 = 1564px
```

**Three Equal Charts:**
```
Each: 4 columns = 508px
Gutters: 2 × 20px = 40px
Total: (508 × 3) + 40 = 1564px
```

---

## Spacing Standards

### Standard Spacing Values

**Use these consistent spacing values:**

```
Micro Spacing (Inside Elements):
  4px - Very tight (between icon and text)
  8px - Tight (padding inside buttons)
  12px - Standard (padding inside cards)
  16px - Comfortable (padding inside large containers)

Macro Spacing (Between Elements):
  16px - Minimum between charts (same section)
  24px - Standard between charts (same section)
  32px - Between sections (visual break)
  48px - Major section dividers
  64px - Page-level spacing (top/bottom margins)

Margins (Dashboard Edges):
  20px - Left/Right margins (standard)
  24px - Top/Bottom margins (standard)
  32px - Large screen margins (>1920px)
```

---

### Spacing in Practice

**Example: KPI Scorecard Row**
```
┌──────────────────────────────────────────────┐
│ 20px margin                                  │
├──┬──────────┬──┬──────────┬──┬──────────┬───┤
│20│   KPI1   │24│   KPI2   │24│   KPI3   │20 │
│  │  376×150 │  │  376×150 │  │  376×150 │   │
└──┴──────────┴──┴──────────┴──┴──────────┴───┘
   ↑           ↑
   Margin      Gutter (between charts)
```

**Example: Section Spacing**
```
┌────────────────────────────────────────┐
│ SECTION 1: OVERVIEW                    │
│ [Chart content]                        │
│                                        │
│ ←────── 48px gap ──────→               │ ← Major section break
│                                        │
│ SECTION 2: DETAILS                     │
│ [Chart content]                        │
└────────────────────────────────────────┘
```

---

### White Space Best Practices

**Good White Space:**
```
┌─────────────────────────────────┐
│                                 │ ← 24px top margin
│   [Chart Title]                 │
│                                 │ ← 16px below title
│   [Chart Content]               │
│                                 │
│                                 │ ← 24px bottom margin
└─────────────────────────────────┘

Benefits:
  ✓ Easy to scan
  ✓ Clear visual separation
  ✓ Professional appearance
```

**Bad White Space (Cramped):**
```
┌─────────────────────────┐
│[Chart Title]            │ ← No spacing
│[Chart Content]          │
└─────────────────────────┘

Problems:
  ✗ Hard to read
  ✗ Elements blend together
  ✗ Looks amateur
```

---

## Common Layout Mistakes

### Mistake 1: Chart Tetris

**Problem:** Random placement, no alignment

**Bad:**
```
┌────────────────────────┐
│  ┌───┐     ┌──────┐   │ ← Misaligned
│  │ A │   ┌─┤  B   │   │ ← Overlapping
│  └───┘   │ └──────┘   │
│      ┌───┴──┐         │ ← Different sizes
│      │  C   │    ┌──┐ │ ← Random gaps
│      └──────┘    │D │ │
└────────────────────────┘
```

**Good:**
```
┌────────────────────────┐
│  ┌─────┐  ┌─────┐     │ ← Aligned
│  │  A  │  │  B  │     │ ← Same size
│  └─────┘  └─────┘     │ ← Equal spacing
│  ┌─────┐  ┌─────┐     │
│  │  C  │  │  D  │     │
│  └─────┘  └─────┘     │
└────────────────────────┘
```

---

### Mistake 2: No Visual Hierarchy

**Problem:** All elements same size/importance

**Bad:**
```
┌──────┬──────┬──────┬──────┐
│Chart │Chart │Chart │Chart │ ← All equal
├──────┼──────┼──────┼──────┤   Where to look?
│Chart │Chart │Chart │Chart │
└──────┴──────┴──────┴──────┘
```

**Good:**
```
┌────────────────────────────┐
│  ████ PRIMARY METRIC ████  │ ← Largest (most important)
├─────────┬──────────────────┤
│  Chart  │   Chart   │Chart │ ← Medium
├─────────┴──────────────────┤
│  Details table (smallest)  │ ← Smallest (supporting)
└────────────────────────────┘
```

---

### Mistake 3: Inconsistent Spacing

**Problem:** Random gaps

**Bad:**
```
┌──────┐           ← 10px gap
│ KPI1 │
└──────┘
           ← 40px gap
┌──────┐
│Chart │
└──────┘
    ← 5px gap
┌──────┐
│Table │
└──────┘
```

**Good:**
```
┌──────┐
│ KPI1 │           ← Consistent
└──────┘           ← 24px gaps
           ← 24px
┌──────┐
│Chart │
└──────┘
           ← 24px
┌──────┐
│Table │
└──────┘
```

---

### Mistake 4: Ignoring Mobile

**Problem:** Desktop-only design breaks on mobile

**Desktop (1600px):**
```
┌───────┬───────┬───────┬───────┐
│  KPI1 │  KPI2 │  KPI3 │  KPI4 │ ✓ Looks good
└───────┴───────┴───────┴───────┘
```

**Same Layout on Mobile (375px):**
```
┌──┬──┬──┬──┐
│K1│K2│K3│K4│ ✗ Unreadable (each KPI only 90px wide)
└──┴──┴──┴──┘
```

**Solution (Mobile-Responsive):**
```
Mobile:
┌─────┬─────┐
│ KPI1│ KPI2│ ✓ Readable (175px each)
├─────┼─────┤
│ KPI3│ KPI4│
└─────┴─────┘
```

---

## Layout Checklist

### Before Publishing Dashboard

**Visual Hierarchy:**
- [ ] Most important metric is largest and top-left
- [ ] Clear progression from primary → secondary → tertiary info
- [ ] KPIs/scorecards prominently placed (above the fold)
- [ ] Details (tables) at bottom, not top

**Alignment:**
- [ ] All charts aligned to grid (no random placement)
- [ ] Charts in same row have same top edge
- [ ] Charts in same column have same left edge
- [ ] Used Looker's "Align" tools (not manual positioning)

**Spacing:**
- [ ] Consistent spacing between charts (16-24px)
- [ ] Larger spacing between sections (32-48px)
- [ ] Margins around dashboard edges (20-24px)
- [ ] White space around text (not cramped)
- [ ] No charts touching each other

**Sizing:**
- [ ] Related charts are same size (e.g., all KPIs same size)
- [ ] Chart sizes proportional to importance
- [ ] Charts not too small (<200px) or too large (>1000px)
- [ ] Fixed canvas size for consistency (1600×900 or similar)

**Responsiveness:**
- [ ] Mobile layout configured
- [ ] Tested on phone simulator (375px width)
- [ ] Charts stack vertically on mobile
- [ ] No horizontal scrolling on mobile
- [ ] Font sizes readable on small screens (14px minimum)

**Navigation:**
- [ ] Page navigation clear and functional
- [ ] Current page highlighted in nav menu
- [ ] Breadcrumbs if multi-level navigation
- [ ] Back to top button on long pages (optional)

**Branding:**
- [ ] Logo placed in header (consistent location)
- [ ] Brand colors used appropriately
- [ ] Consistent fonts throughout
- [ ] Professional color scheme (not rainbow)

**Accessibility:**
- [ ] Color contrast meets WCAG AA standard (4.5:1 ratio)
- [ ] Charts don't rely on color alone (use patterns/labels too)
- [ ] Text readable without zooming
- [ ] Interactive elements large enough to tap (44×44px)

---

## Quick Reference: Layout Decision Tree

**Choose Layout Based on Audience:**

```
                  ┌─ Executives?
                  │    └─→ Use Z-Pattern
                  │        (Simple, focused)
                  │
 What type  ──────┼─ Managers/Ops?
 of user?         │    └─→ Use F-Pattern
                  │        (Detailed sections)
                  │
                  └─ Analysts?
                       └─→ Use Grid Layout
                           (Flexible, complex)

                  ┌─ Desktop only?
                  │    └─→ 1600×900px
                  │        Fixed layout
                  │
 What      ───────┼─ Responsive?
 device?          │    └─→ Grid System
                  │        (12-column)
                  │
                  └─ Mobile-first?
                       └─→ 375px width
                           Vertical stacking

                  ┌─ One key metric?
                  │    └─→ Z-Pattern
                  │
 How many ────────┼─ 5-10 metrics?
 charts?          │    └─→ F-Pattern or Grid
                  │
                  └─ 10+ metrics?
                       └─→ Multi-page
                           (split into 2-3 pages)
```

---

## Templates Download

**To use these templates:**

1. **In Looker Studio:**
   - Create new report
   - Set canvas size to template dimensions
   - Use "View → Show Grid" for alignment
   - Follow pixel dimensions exactly

2. **Starter Template (Blank Grid):**
```
Dashboard Name: "Blank Template - F-Pattern"
Canvas: 1600 × 900px (fixed)
Pages: 1
Grid: 16px
Margins: 20px

Sections to add:
  - Header: 1600 × 80px (position: 0, 0)
  - KPI Row: 1560 × 150px (position: 20, 100)
  - Section 1: 1560 × 350px (position: 20, 270)
  - Section 2: 1560 × 300px (position: 20, 640)
```

3. **Copy from Gallery:**
   - Looker Studio Template Gallery
   - Search: "Executive Dashboard", "Operations Dashboard"
   - Make a copy → Customize with your data

---

## Additional Resources

- **Looker Studio Design Gallery:** datastudio.google.com/gallery
- **Material Design Guidelines:** material.io/design
- **Dashboard Design Book:** "Information Dashboard Design" by Stephen Few
- **Eye-Tracking Research:** Nielsen Norman Group studies
- **Grid Calculator:** 1200px.com (12-column grid calculator)

---

**Remember:** Good layout is invisible. Users shouldn't notice the design—they should just find information effortlessly. If your layout draws attention to itself, it's too complex. Simplify.

**Pro Tip:** Start with too much white space, then gradually add content until it feels "just right." It's easier to fill space than to remove clutter later.

---

**Last Updated:** January 31, 2026
**Version:** 1.0
