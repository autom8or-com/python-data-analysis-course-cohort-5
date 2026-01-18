# Dashboard Layout and Design Principles

**Week 13 - Thursday Session | Hour 2 (Full 60 minutes)**
**Business Context:** Creating professional, accessible, and effective dashboards for Nigerian stakeholders

---

## Learning Objectives

By the end of this section, you will be able to:
- Apply F-pattern and Z-pattern layouts for optimal information flow
- Use color theory principles for professional and accessible designs
- Create mobile-responsive dashboards that work on all devices
- Implement visual hierarchy to guide viewer attention
- Apply Nigerian business context to design decisions
- Follow accessibility standards (WCAG) for inclusive dashboards
- Balance aesthetics with functionality

---

## Why Dashboard Design Matters

### The 3-Second Rule
**Stakeholders decide in 3 seconds if your dashboard is:**
- Professional and trustworthy
- Clear and easy to understand
- Worth their time to explore

**Bad design = Good data ignored**
**Good design = Data-driven decisions**

### Dashboard vs Report vs Presentation

**Dashboard:**
- At-a-glance monitoring
- Interactive and dynamic
- Updates automatically
- Designed for repeated viewing

**Report:**
- Detailed analysis
- Static document
- One-time or scheduled delivery
- Narrative-driven

**Presentation:**
- Story-telling format
- Sequential slides
- Guided explanation
- Designed for presentation mode

**This week:** Focus on dashboards for ongoing monitoring

---

## Core Design Principles

### Principle 1: Visual Hierarchy

**Definition:** Arrange elements so the most important information gets seen first

#### Hierarchy Levels:

**Level 1: Primary (Most Important)**
- **What:** KPI scorecards, headline metrics
- **Size:** Largest fonts (36-48px)
- **Location:** Top of dashboard, "above the fold"
- **Color:** Brand primary color or bold accent

**Example:**
```
┌─────────────────────────────────────┐
│  ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓  │ ← Level 1
│  ┃   TOTAL REVENUE: NGN 45.3M  ┃  │   (Biggest, boldest)
│  ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛  │
└─────────────────────────────────────┘
```

**Level 2: Secondary (Supporting Information)**
- **What:** Time series trends, category breakdowns
- **Size:** Medium (charts 300-400px wide)
- **Location:** Middle section of dashboard
- **Color:** Supporting colors, less bold

**Example:**
```
┌─────────────┬─────────────┬─────────────┐
│  Monthly    │  Orders by  │  Delivery   │ ← Level 2
│  Revenue    │  State      │  Performance│   (Medium size)
│  [Chart]    │  [Chart]    │  [Chart]    │
└─────────────┴─────────────┴─────────────┘
```

**Level 3: Tertiary (Details)**
- **What:** Data tables, filters, footnotes
- **Size:** Smaller fonts (10-12px)
- **Location:** Bottom or right sidebar
- **Color:** Neutral grays

---

### Principle 2: Information Flow Patterns

#### F-Pattern Layout (Most Common)

**How People Read Digital Content:**
1. Horizontal scan across top (first F stroke)
2. Vertical scan down left side (F stem)
3. Horizontal scan in middle (second F stroke)
4. Continue scanning down left

**Dashboard Application:**
```
┌─────────────────────────────────────┐
│ ████████████████████ [Scan 1]       │ ← Top KPIs
│ ████                                 │
│ ████ Chart 1    Chart 2    Chart 3  │ ← Mid-level
│ ████                                 │
│ ████ Chart 4    Chart 5             │ ← Details
│ ████                                 │
│ ████ Table                          │ ← Supporting
└─────────────────────────────────────┘
   ↑
  Scan down left
```

**Best For:**
- Dashboards with lots of information
- Reports with narrative flow
- Text-heavy pages

**Nigerian Business Example: Sales Executive Dashboard**
```
┌──────────────────────────────────────────┐
│ Revenue | Orders | AOV | Customers       │ ← Top metrics
├──────────────────────────────────────────┤
│ Monthly Revenue Trend                     │ ← Main chart
│ [Time Series Chart]                       │
├──────────────────────────────────────────┤
│ Top States  │ Top Categories              │ ← Breakdowns
│ [Bar Chart] │ [Bar Chart]                 │
├──────────────────────────────────────────┤
│ Recent Orders Table                       │ ← Details
└──────────────────────────────────────────┘
```

---

#### Z-Pattern Layout (Simple Dashboards)

**How It Works:**
1. Top-left to top-right (first diagonal)
2. Top-right down to bottom-left (second diagonal)
3. Bottom-left to bottom-right (third diagonal)

**Visual:**
```
┌─────────────────────────────────────┐
│ ①────────────────────→②             │
│  \                     │             │
│   \                    │             │
│    \                   ↓             │
│     \              [Chart]           │
│      \                │              │
│       \               │              │
│        ↘              ↓              │
│         ③──────────→④               │
└─────────────────────────────────────┘
```

**Best For:**
- Simple dashboards (4-6 elements)
- Executive summaries
- Single-page overviews

**Nigerian Business Example: CEO Daily Dashboard**
```
┌──────────────────────────────────────────┐
│ Revenue: 45.3M ────────→ Orders: 1,543   │ ① → ②
│         ↓                        ↓        │
│    [Revenue Trend Chart]                 │
│         ↓                                 │
│ Top State: Lagos ─────→ Alert: Low Stock │ ③ → ④
└──────────────────────────────────────────┘
```

---

#### Grid Layout (Modern Dashboards)

**Structure:** Organized in rows and columns

**Looker Studio Grid:**
- 12-column system (like Bootstrap CSS)
- Snap-to-grid alignment
- Consistent spacing

**Example:**
```
┌───────┬───────┬───────┬───────┐
│  KPI  │  KPI  │  KPI  │  KPI  │ ← Row 1: 4 columns
├───────┴───────┴───────┴───────┤
│       Main Chart (12 cols)    │ ← Row 2: Full width
├───────────────┬───────────────┤
│  Chart (6)    │  Chart (6)    │ ← Row 3: 2 equal
├───────────────┴───────────────┤
│        Table (12 cols)        │ ← Row 4: Full width
└───────────────────────────────┘
```

**Best For:**
- Multi-section dashboards
- Responsive design (mobile-friendly)
- Clean, modern aesthetic

---

### Principle 3: White Space (Breathing Room)

**Definition:** Empty space around and between elements

**Why It Matters:**
- Reduces cognitive load
- Increases readability
- Makes dashboards feel less cluttered
- Guides attention to what matters

#### White Space Rules:

**Minimum Spacing:**
- Between charts: 16-24px
- Around dashboard edges: 24-32px
- Between sections: 32-48px

**Example of Cramped vs Spacious:**

**Bad (No White Space):**
```
┌KPI┬KPI┬KPI┬KPI┐
├───┴───┴───┴───┤
│Chart│Chart│Cht│
├───┬───┬───┬───┤
│Tbl│Tbl│Tbl│Tbl│
└───┴───┴───┴───┘
```
**Feels:** Overwhelming, hard to focus

**Good (Proper White Space):**
```
┌─────────────────────────┐
│                         │
│   KPI    KPI    KPI     │
│                         │
│   Chart      Chart      │
│                         │
│   Table                 │
│                         │
└─────────────────────────┘
```
**Feels:** Professional, easy to read

---

## Color Theory for Dashboards

### Purpose of Color in Dashboards

1. **Differentiation:** Separate data series
2. **Association:** Group related items
3. **Emphasis:** Highlight important metrics
4. **Meaning:** Good (green) vs Bad (red) performance

---

### Color Palette Selection

#### Option 1: Brand Colors (Recommended)

**Nigerian Business Example:**
- **Jumia:** Orange (#F68B24) as primary
- **Konga:** Red (#E2001A) as primary
- **Flutterwave:** Orange-Yellow (#FDB813)

**Application:**
- Primary KPI: Brand color
- Supporting charts: Brand color variations (lighter/darker)
- Neutral elements: Grays

---

#### Option 2: Data Visualization Palettes

**Categorical Data (5-7 categories):**
- Use distinct, equally vibrant colors
- Example: Google Material Design palette
  - #2196F3 (Blue)
  - #4CAF50 (Green)
  - #FF9800 (Orange)
  - #9C27B0 (Purple)
  - #F44336 (Red)

**Sequential Data (Low to High):**
- Single hue, varying intensity
- Example: Light Blue → Dark Blue
  - #E3F2FD → #2196F3 → #0D47A1

**Diverging Data (Negative to Positive):**
- Two hues meeting at neutral middle
- Example: Red (bad) ← Gray (neutral) → Green (good)
  - #F44336 → #9E9E9E → #4CAF50

---

### Nigerian Flag Color Palette (Patriotic Option)

**Colors:**
- Green: #008751
- White: #FFFFFF

**Application:**
- Success metrics: Green
- Background: White
- Text: Dark gray (#212121)
- Accents: Gold/Yellow for highlights

**Example Dashboard:**
```
┌─────────────────────────────────────┐
│ [Green Header]  NIGERIA E-COMMERCE  │
│                                     │
│ Revenue      Orders      AOV        │
│ [Green]      [Green]     [Green]    │
│                                     │
│ [Chart with green lines/bars]       │
└─────────────────────────────────────┘
```

---

### Color Accessibility (WCAG Standards)

**Purpose:** Ensure dashboards are usable by people with color vision deficiency

**Statistics:**
- 8% of men have some form of color blindness
- 0.5% of women affected
- Most common: Red-green color blindness

#### Accessibility Rules:

**Rule 1: Don't rely on color alone**
- **Bad:** Red bar = poor, Green bar = good (no labels)
- **Good:** Red bar + "Below Target" label, Green bar + "Exceeds Target" label

**Rule 2: Use patterns + color**
- Solid vs striped bars
- Different shapes (circle, square, triangle)
- Line styles (solid, dashed, dotted)

**Rule 3: Sufficient contrast**
- **Text on background:** Minimum 4.5:1 contrast ratio
- **Large text (18px+):** Minimum 3:1 contrast ratio

**Example:**
- ✗ Light gray text (#BDBDBD) on white background
- ✓ Dark gray text (#424242) on white background

**Rule 4: Test with simulators**
- Use online color blindness simulators
- Preview dashboard in grayscale mode
- Ask colleagues to review

**[SCREENSHOT 1: Dashboard in normal view vs color-blind simulation]**
*Caption: Ensuring dashboard is readable for all users*

---

## Typography in Dashboards

### Font Selection

**Recommendations:**
1. **Roboto** (Google's Material Design) - Clean, professional
2. **Open Sans** - Highly readable, neutral
3. **Lato** - Modern, friendly
4. **Montserrat** - Bold headers

**Avoid:**
- Comic Sans (unprofessional)
- Decorative fonts (hard to read)
- Too many fonts (max 2 font families)

---

### Font Sizes

**Hierarchy by Size:**
```
Dashboard Title:   24-28px (Bold)
Section Headers:   18-20px (Semi-Bold)
Chart Titles:      16-18px (Medium)
Metric Values:     36-48px (Bold) ← Scorecards
Metric Labels:     12-14px (Regular)
Axis Labels:       10-12px (Regular)
Footnotes:         9-10px (Regular)
```

**Nigerian Context Example:**
```
┌─────────────────────────────────────┐
│  SALES DASHBOARD - LAGOS REGION     │ ← 28px Bold
│                                     │
│  Revenue Metrics                    │ ← 18px Semi-Bold
│  ┌──────────┐                       │
│  │  NGN 45M │                       │ ← 42px Bold
│  │  Revenue │                       │ ← 14px Regular
│  └──────────┘                       │
└─────────────────────────────────────┘
```

---

### Text Alignment

**Left-Aligned (Default):**
- Dashboard titles
- Chart titles
- Labels
- Most text content

**Center-Aligned:**
- Scorecards (metric values)
- Dashboard headers (optional)
- Symmetrical layouts

**Right-Aligned:**
- Numbers in tables (especially currency)
- Dates in tables

**Example Table:**
```
┌──────────────────┬────────────┬────────────┐
│ Customer Name    │ Order Date │    Revenue │ ← Headers
├──────────────────┼────────────┼────────────┤
│ Adebayo Stores   │ 2025-11-01 │ NGN 15,400 │ ← Left | Center | Right
│ Chinwe Ventures  │ 2025-11-02 │ NGN 23,750 │
│ Lagos Mega Mall  │ 2025-11-03 │  NGN 8,250 │
└──────────────────┴────────────┴────────────┘
```

---

## Mobile-Responsive Design

### Why Mobile Matters

**Usage Statistics:**
- 60%+ of Nigerian internet users access via mobile
- Executives check dashboards on phones while traveling
- Field staff monitor dashboards on tablets

**Mobile-First Mindset:**
Design for mobile, enhance for desktop (not the other way around)

---

### Responsive Design Techniques

#### Technique 1: Stacking on Mobile

**Desktop (4 columns):**
```
┌─────┬─────┬─────┬─────┐
│ KPI │ KPI │ KPI │ KPI │
└─────┴─────┴─────┴─────┘
```

**Mobile (2 columns, stacked):**
```
┌─────┬─────┐
│ KPI │ KPI │
├─────┼─────┤
│ KPI │ KPI │
└─────┴─────┘
```

**Looker Studio:** Automatically reflows in "Mobile View" mode

---

#### Technique 2: Simplify for Mobile

**Desktop Dashboard:** 8 charts
**Mobile Dashboard:** 4 most important charts

**How:** Create mobile-specific dashboard variant OR use visibility rules

---

#### Technique 3: Touch-Friendly Targets

**Minimum Touch Target:** 44x44 pixels

**Application:**
- Filter buttons: Large enough to tap easily
- Dropdown selects: Adequate spacing
- Interactive chart elements: Visible hover states

---

#### Technique 4: Optimize Chart Types

**Desktop-Friendly:**
- Tables with many columns
- Complex multi-line charts
- Detailed legends

**Mobile-Friendly:**
- Scorecards (perfect for mobile)
- Simple bar charts (3-5 bars)
- Single-line time series
- Gauge charts

**Mobile Avoid:**
- Pivot tables (too wide)
- Charts with 10+ categories
- Tiny text labels

---

### Testing Mobile View

**In Looker Studio:**
1. Click **View** → **Mobile Layout**
2. Preview how dashboard reflows
3. Adjust chart sizes and positions
4. Test on actual mobile device

**[SCREENSHOT 2: Desktop view vs mobile view comparison]**
*Caption: Same dashboard automatically adapted for mobile screen size*

---

## Dashboard Structure Best Practices

### The "Above the Fold" Concept

**Definition:** Content visible without scrolling

**Importance:** 80% of users never scroll down

**What Belongs Above Fold:**
- Primary KPIs (3-4 scorecards)
- Main trend chart (revenue over time)
- Critical alerts or status indicators

**What Can Go Below Fold:**
- Detailed tables
- Secondary breakdowns
- Less-frequently-viewed metrics
- Data source notes and disclaimers

---

### Section Organization

#### 3-Section Dashboard (Recommended)

**Section 1: Executive Summary (Top)**
- KPI scorecards
- High-level trends
- Color-coded: Brand primary color background

**Section 2: Analysis (Middle)**
- Detailed charts (category breakdowns, geographic analysis)
- Interactive filters
- Color-coded: White/light gray background

**Section 3: Details (Bottom)**
- Data tables
- Footnotes and disclaimers
- Last updated timestamp
- Color-coded: Light gray background

**Visual:**
```
┌─────────────────────────────────────┐
│ [Blue Background]                   │ ← Section 1
│ KPI | KPI | KPI | KPI               │
├─────────────────────────────────────┤
│ [White Background]                  │ ← Section 2
│ Chart 1    Chart 2    Chart 3       │
│ Chart 4    Chart 5                  │
├─────────────────────────────────────┤
│ [Light Gray Background]             │ ← Section 3
│ Detailed Data Table                 │
│ Last Updated: Nov 13, 2025 10:30 AM │
└─────────────────────────────────────┘
```

---

### Filter Placement

**Options:**

**Top of Dashboard (Recommended):**
- Highly visible
- Controls affect entire dashboard
- Example: Date range, Product category, Customer state

**Sidebar (Alternative):**
- Saves vertical space
- Good for many filters (5+)
- Can be collapsible

**Per-Chart Filters:**
- Specific to one visualization
- Less cluttered global controls

**Nigerian Example:**
```
┌─────────────────────────────────────────────────────┐
│ Date Range: [Last 30 Days ▼]  State: [All ▼]      │ ← Top filters
├─────────────────────────────────────────────────────┤
│ Dashboard content...                                │
└─────────────────────────────────────────────────────┘
```

---

## Nigerian Business Design Considerations

### Language and Localization

**Currency:**
- Always show "NGN" or "₦" symbol
- Use NGN (not Naira) for international audiences
- Example: NGN 45.3M (not ₦45.3M)

**Date Format:**
- Nigerian standard: DD/MM/YYYY (13/11/2025)
- International: YYYY-MM-DD (2025-11-13)
- Recommendation: Use clear month names (Nov 13, 2025)

**Number Format:**
- Thousands separator: Comma (15,432 not 15.432)
- Decimal separator: Period (2.5 not 2,5)
- Compact: 45.3M (not 45,300,000)

---

### Cultural Considerations

**Colors:**
- **Green:** Success, growth (Nigeria's national color)
- **Red:** Alert, danger (use sparingly)
- **Gold/Yellow:** Premium, quality

**Imagery:**
- Use locally relevant icons (naira symbol, local landmarks)
- Avoid imagery that may be culturally insensitive

**Names and Labels:**
- Use local business terminology
- Example: "Payday Period" (last week of month = high sales)

---

### Connectivity Considerations

**Nigerian Internet Reality:**
- Inconsistent connectivity
- Mobile data costs
- Slower speeds in some areas

**Dashboard Optimization:**
- Minimize heavy images
- Use data extracts (snapshot) vs live queries where possible
- Optimize number of charts (each = database query)
- Enable caching

---

## Common Design Mistakes to Avoid

### Mistake 1: Too Much Information

**Problem:** 15 charts crammed on one page

**Result:** Analysis paralysis, nothing stands out

**Solution:**
- Max 6-8 charts per dashboard
- Create separate dashboards for different audiences
- Use drill-down instead of showing all details upfront

---

### Mistake 2: Inconsistent Styling

**Problem:**
- Chart 1: Blue bars
- Chart 2: Green bars (same data type)
- Chart 3: Red bars (different font)

**Result:** Looks unprofessional, confusing

**Solution:**
- Define color scheme, stick to it
- Use same fonts throughout
- Consistent chart sizes and spacing

---

### Mistake 3: Chartjunk (Unnecessary Decoration)

**Examples:**
- 3D effects on charts
- Drop shadows everywhere
- Excessive gradients
- Animated elements (distracting)

**Principle:** Every element should serve a purpose

**Solution:** Minimize decoration, maximize data-ink ratio

---

### Mistake 4: Poor Label Hierarchy

**Problem:**
- Chart title same size as metric value
- Axis labels larger than chart title
- No clear visual priority

**Solution:** Use font size hierarchy (see Typography section)

---

### Mistake 5: Ignoring Mobile

**Problem:** Perfect on desktop, unusable on mobile

**Result:** 60% of users can't access dashboard

**Solution:** Always test mobile view, simplify if needed

---

## Looker Studio Design Tools

### Canvas Grid and Alignment

**Enable Grid:**
1. **View** → **Show Grid**
2. Snap to 8px grid
3. Perfectly aligned elements

**Alignment Tools:**
- **Arrange** → **Align Left/Center/Right**
- **Arrange** → **Distribute Horizontally/Vertically**
- **Arrange** → **Same Width/Height**

**[SCREENSHOT 3: Grid alignment tools in action]**
*Caption: Using alignment tools for pixel-perfect layout*

---

### Themes (Pre-built Styles)

**Using Themes:**
1. **Theme** → **Theme and Layout**
2. Select pre-built theme OR create custom
3. Apply globally (all charts adopt theme)

**Custom Theme Elements:**
- Brand colors
- Font family and sizes
- Border styles
- Background colors

**Nigerian Business Theme Example:**
```yaml
Primary Color: #008751 (Nigeria Green)
Secondary Color: #FFD700 (Gold)
Text Color: #212121 (Dark Gray)
Background: #FFFFFF (White)
Accent: #1976D2 (Blue)

Font Family: Roboto
Title Font: 24px Bold
Body Font: 14px Regular
```

---

### Templates (Starting Points)

**Looker Studio Template Gallery:**
- E-commerce dashboard templates
- Sales performance templates
- Marketing analytics templates

**How to Use:**
1. **File** → **Make a Copy**
2. Connect to your data source
3. Customize colors, labels, filters
4. Publish

**Advantage:** Professional design in minutes

---

## Dashboard Design Workflow

### Step 1: Define Purpose and Audience

**Questions to Ask:**
- **Who** will use this dashboard? (CEO, Marketing Manager, Operations)
- **What** decisions will they make with it?
- **When** will they view it? (Daily check, weekly review, monthly report)
- **Where** will they view it? (Desktop, mobile, tablet)

**Example:**
- **Who:** Lagos Store Managers
- **What:** Monitor daily sales and inventory
- **When:** Every morning before opening
- **Where:** Mobile phone

**Design Implications:**
- Mobile-first design
- Focus on daily/yesterday metrics
- Large, clear scorecards
- Minimal scrolling

---

### Step 2: Sketch Layout (Wireframe)

**Low-Fidelity Mockup:**
- Draw boxes on paper
- Place KPIs, charts, filters
- Test flow with stakeholders

**Example Sketch:**
```
┌─────────────────────────────┐
│  SALES DASHBOARD            │
├────────┬────────┬───────────┤
│ Rev.   │ Orders │ AOV       │
├────────┴────────┴───────────┤
│ [Revenue Trend Chart]       │
├───────────────┬─────────────┤
│ Top Products  │ Top States  │
└───────────────┴─────────────┘
```

---

### Step 3: Build in Looker Studio

**Incremental Development:**
1. Add data source
2. Create KPI scorecards (top priority)
3. Add main trend chart
4. Add supporting charts
5. Style and polish
6. Test mobile view

**Don't:** Try to build everything perfectly in one go

---

### Step 4: Review and Iterate

**Feedback Loop:**
1. Share draft with 2-3 stakeholders
2. Collect specific feedback
3. Make targeted improvements
4. Re-share and confirm

**Questions for Reviewers:**
- What's the first thing you noticed?
- What questions can you answer with this dashboard?
- What's missing or confusing?
- Would you use this regularly?

---

### Step 5: Document and Deploy

**Dashboard Documentation:**
- **Title:** Clear, descriptive name
- **Purpose:** One-sentence summary
- **Audience:** Who should use this
- **Refresh Schedule:** How often data updates
- **Last Updated:** Timestamp (auto-generated)
- **Data Source:** Where data comes from
- **Contact:** Who to ask for help

**Example:**
```
┌─────────────────────────────────────────┐
│ Lagos E-Commerce Daily Sales Dashboard │
│ Purpose: Monitor daily sales performance│
│ Audience: Store managers and ops team   │
│ Updates: Every morning at 6:00 AM WAT   │
│ Contact: analytics@company.com.ng       │
│ Last Updated: Nov 13, 2025 06:05 AM     │
└─────────────────────────────────────────┘
```

---

## Key Takeaways

1. **Design serves the data** - Pretty but confusing = failure
2. **F-pattern and Z-pattern** - Work with natural reading flow
3. **White space is not wasted space** - It improves comprehension
4. **Color with purpose** - Differentiate, associate, emphasize, encode meaning
5. **Mobile-responsive is mandatory** - 60%+ of users are on mobile
6. **Accessibility matters** - Don't exclude users with color vision deficiency
7. **Nigerian context** - Use NGN, local business calendar, appropriate imagery
8. **Iterate based on feedback** - First version is never perfect

---

## Hands-On Exercise Preview

**You'll Design:**
A complete sales dashboard applying all principles learned:

**Layout:** F-pattern with 3 sections
**Colors:** Nigerian flag palette (green, white, gold)
**Typography:** Roboto font family with proper hierarchy
**Charts:**
- 4 KPI scorecards (top row)
- 1 monthly revenue time series (main chart)
- 2 category breakdown bar charts (supporting)
- 1 data table (bottom, detailed records)

**Accessibility:** Tested with color-blind simulator
**Mobile:** Responsive 2-column layout on mobile devices

---

**[SCREENSHOT 4: Complete dashboard showcasing all design principles]**
*Caption: Professional Nigerian e-commerce dashboard with F-pattern layout, accessible colors, and mobile-responsive design*

---

## Additional Resources

- **Color Palette Generator:** Coolors.co for harmonious color schemes
- **Contrast Checker:** WebAIM for WCAG compliance
- **Wireframe Tools:** Figma, Balsamiq for mockups
- **Design Inspiration:** Looker Studio Gallery, Dribbble dashboards
- **Nigerian Design Guide:** Local best practices and cultural considerations

---

**Next:** Hands-on exercises to apply everything learned!
