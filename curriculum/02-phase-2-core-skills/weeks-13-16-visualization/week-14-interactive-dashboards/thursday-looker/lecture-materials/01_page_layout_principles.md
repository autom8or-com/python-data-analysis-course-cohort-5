# Page Layout Principles - Professional Dashboard Design

**Week 14 - Thursday Session | Part 1 (20 minutes)**
**Business Context:** Designing client-ready dashboards with professional layouts that guide viewer attention and maximize comprehension

---

## Learning Objectives

By the end of this section, you will be able to:
- Apply F-pattern and Z-pattern reading flows to dashboard layouts
- Create effective visual hierarchy for business dashboards
- Use the grid system for pixel-perfect alignment
- Implement white space strategically for clarity
- Choose appropriate page dimensions for different use cases
- Recognize and avoid common layout mistakes
- Design multi-section dashboards with clear information flow

---

## Why Dashboard Layout Matters

### The 5-Second Test

**Reality Check:** Stakeholders will judge your dashboard in 5 seconds or less:
- **3 seconds:** Initial impression (professional or amateur?)
- **2 seconds:** Identify what the dashboard is about
- **Decision:** Explore further OR close and ignore

**Bad layout = Your insights ignored**
**Good layout = Data-driven decisions**

### Layout vs Content

**Common Mistake:** "I have great data, layout doesn't matter"

**Truth:**
- **Content** = What you say (your data insights)
- **Layout** = How you say it (visual organization)
- **Both** are equally important for impact

**Nigerian Business Example:**
Two dashboards with identical data:
- **Dashboard A:** Random chart placement, no hierarchy = CEO confused, ignores it
- **Dashboard B:** Clear layout, KPIs at top = CEO sees revenue drop immediately, takes action

---

## Core Layout Principles

### Principle 1: Visual Hierarchy

**Definition:** Organizing elements so viewers see the most important information first

#### The Three-Level Hierarchy

**Level 1: Primary Information (What matters most?)**
- **Content:** Critical KPIs, headline metrics, urgent alerts
- **Size:** Largest elements (300-400px wide scorecards)
- **Position:** Top of dashboard, "above the fold"
- **Weight:** Bold, high contrast
- **Purpose:** Answer "How are we doing?" instantly

**Example:**
```
┌─────────────────────────────────────────────────┐
│  ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓     │
│  ┃  NGN 45.3M Revenue | 1,543 Orders      ┃     │ ← Level 1
│  ┃  ↑ 23% vs last month                   ┃     │   (Biggest, boldest)
│  ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛     │
└─────────────────────────────────────────────────┘
```

**Level 2: Secondary Information (Supporting details)**
- **Content:** Trend analysis, category breakdowns, comparisons
- **Size:** Medium elements (250-300px charts)
- **Position:** Middle section of dashboard
- **Weight:** Regular, readable
- **Purpose:** Explain "Why are we performing this way?"

**Example:**
```
┌──────────────┬──────────────┬──────────────┐
│  Monthly     │  Top 5       │  Payment     │ ← Level 2
│  Revenue     │  States      │  Methods     │   (Medium size)
│  Trend       │  by Revenue  │  Mix         │
│  [Chart]     │  [Chart]     │  [Chart]     │
└──────────────┴──────────────┴──────────────┘
```

**Level 3: Tertiary Information (Detailed exploration)**
- **Content:** Data tables, footnotes, data sources, filters
- **Size:** Smaller elements (tables, 10-12px text)
- **Position:** Bottom or right sidebar
- **Weight:** Light, neutral colors
- **Purpose:** "Show me the details" for analysts

**Example:**
```
┌───────────────────────────────────────────────┐
│  Detailed Order Transactions                  │ ← Level 3
│  ┌─────────┬──────────┬──────────┬─────────┐  │   (Smaller, detailed)
│  │Order ID │ Customer │ Amount   │ Status  │  │
│  ├─────────┼──────────┼──────────┼─────────┤  │
│  │ 10423   │ Lagos    │ NGN 2.3K │ Shipped │  │
│  │ 10424   │ Abuja    │ NGN 5.1K │ Pending │  │
│  └─────────┴──────────┴──────────┴─────────┘  │
│                                               │
│  Last Updated: Jan 31, 2026 10:30 AM          │
└───────────────────────────────────────────────┘
```

---

### Principle 2: Reading Patterns

#### F-Pattern Layout (Most Common for Dashboards)

**How People Read Digital Content:**

**Research Findings (Nielsen Norman Group):**
- Users read in an F-shaped pattern on web pages
- First: Horizontal scan across top
- Second: Vertical scan down left side
- Third: Horizontal scan in middle area
- Fourth: Quick vertical scan to bottom

**Dashboard Application:**
```
┌─────────────────────────────────────────┐
│ ████████████████████████ [Scan 1]       │ ← Top KPIs (horizontal scan)
│ ████                                    │ ← Left margin (vertical scan)
│ ████  Chart 1    Chart 2    Chart 3     │ ← Mid-level charts (horizontal)
│ ████                                    │ ← Continue left scan
│ ████  Chart 4    Chart 5                │ ← More analysis
│ ████                                    │
│ ████  Detailed Table                    │ ← Supporting details
└─────────────────────────────────────────┘
     ↑
  Vertical scan down left side
```

**Best For:**
- Information-dense dashboards
- Multiple sections with clear hierarchy
- Long-form dashboards with scrolling
- Detailed analytical dashboards

**Nigerian Business Example: Operations Dashboard**
```
┌────────────────────────────────────────────────┐
│ Revenue: 45M | Orders: 1.5K | AOV: 2.9K | ...  │ ← Scan 1: Top metrics
├────────────────────────────────────────────────┤
│ TRENDS                                         │ ← Scan 2: Left labels
│ [Monthly Revenue Time Series Chart]            │
├────────────────────────────────────────────────┤
│ PERFORMANCE BY CATEGORY                        │
│ [Electronics] ███████████ NGN 12.3M            │ ← Scan 3: Mid content
│ [Fashion]     ████████ NGN 8.7M                │
│ [Home]        ████ NGN 4.2M                    │
├────────────────────────────────────────────────┤
│ GEOGRAPHIC BREAKDOWN                           │
│ [Lagos]       ████████████████ 45%             │
│ [Abuja]       ███████ 23%                      │
│ [Rivers]      ████ 12%                         │
├────────────────────────────────────────────────┤
│ Recent Orders Table                            │ ← Scan 4: Details
│ [Detailed transaction log...]                  │
└────────────────────────────────────────────────┘
```

---

#### Z-Pattern Layout (Executive Dashboards)

**How It Works:**
1. **First diagonal:** Top-left → Top-right (scan header/title)
2. **Second diagonal:** Top-right → Middle-left (main chart)
3. **Third diagonal:** Middle-left → Bottom-right (supporting info)

**Visual:**
```
┌───────────────────────────────────────────┐
│ ①───────────────────────→②               │
│  \                        │               │
│   \                       ↓               │
│    \                  [Main Chart]        │
│     \                     │               │
│      \                    │               │
│       ↘                   ↓               │
│        ③──────────────→④                 │
└───────────────────────────────────────────┘
```

**Best For:**
- Simple, focused dashboards (4-6 elements max)
- Executive summaries (no scrolling)
- Landing pages or overview screens
- Single-page dashboards for presentations

**Nigerian Business Example: CEO Daily Snapshot**
```
┌─────────────────────────────────────────────────┐
│ Daily Sales Dashboard - Lagos Region      [Logo]│ ① → ②
│         ↓                                    ↓  │
│  NGN 2.3M Revenue                     432 Orders│
│  ↑ 15% vs yesterday                  ↑ 8% growth│
│         ↓                                       │
│    [Today's Revenue by Hour - Line Chart]       │ Main focus
│         ↓                                       │
│ Top Product: Electronics ───→ Alert: Low Stock! │ ③ → ④
│ [Bar chart mini view]           [⚠ Warning icon]│
└─────────────────────────────────────────────────┘
```

---

#### Grid Layout (Modern, Responsive Dashboards)

**Structure:** Organized in rows and columns like a spreadsheet

**Looker Studio Grid System:**
- **12 columns** (similar to Bootstrap CSS framework)
- **Snap-to-grid alignment** (8px or 16px increments)
- **Responsive reflow** for mobile devices
- **Consistent spacing** between elements

**Example Grid Configurations:**

**Full Width (12 columns):**
```
┌────────────────────────────────────────┐
│                                        │
│        Single Large Chart (12 cols)    │
│                                        │
└────────────────────────────────────────┘
```

**Half-Half (6 + 6 columns):**
```
┌────────────────────┬───────────────────┐
│                    │                   │
│   Chart A (6)      │   Chart B (6)     │
│                    │                   │
└────────────────────┴───────────────────┘
```

**Thirds (4 + 4 + 4 columns):**
```
┌─────────┬─────────┬─────────┐
│         │         │         │
│  KPI 1  │  KPI 2  │  KPI 3  │
│  (4)    │  (4)    │  (4)    │
└─────────┴─────────┴─────────┘
```

**Asymmetric (8 + 4 columns):**
```
┌─────────────────────────┬──────────┐
│                         │          │
│   Main Chart (8)        │ Sidebar  │
│                         │  (4)     │
└─────────────────────────┴──────────┘
```

**Complete Dashboard Grid Example:**
```
┌───────┬───────┬───────┬───────┐
│  KPI  │  KPI  │  KPI  │  KPI  │ ← Row 1: 4 equal columns (3 each)
│  (3)  │  (3)  │  (3)  │  (3)  │
├───────┴───────┴───────┴───────┤
│                               │ ← Row 2: Full width (12)
│     Main Trend Chart (12)     │
│                               │
├───────────────┬───────────────┤
│               │               │ ← Row 3: Two equal (6 + 6)
│  Category (6) │  Geography(6) │
│               │               │
├───────┬───────┴───────┬───────┤
│  Sub  │               │  Sub  │ ← Row 4: Asymmetric (3 + 6 + 3)
│  (3)  │  Detail (6)   │  (3)  │
└───────┴───────────────┴───────┘
```

**Best For:**
- Multi-section dashboards with varied content
- Responsive design (automatically adapts to mobile)
- Clean, modern aesthetic
- Flexibility for different chart sizes

---

### Principle 3: White Space (Negative Space)

**Definition:** Empty space around and between elements

**Common Misconception:** "White space is wasted space - fill it with more charts!"

**Reality:** White space is a critical design tool

#### Why White Space Matters

**1. Reduces Cognitive Load**
- Brain needs "breathing room" to process information
- Too many elements = overwhelming = nothing gets absorbed

**2. Improves Readability**
- Separates distinct sections
- Makes text easier to scan
- Reduces eye strain

**3. Creates Visual Hierarchy**
- More space around important elements = they stand out
- Grouped items with less space = perceived as related

**4. Adds Professionalism**
- Cramped layouts look amateur
- Generous spacing looks intentional and polished

---

#### White Space Rules for Dashboards

**Minimum Spacing Guidelines:**

| Element Pair | Minimum Space | Recommended Space |
|--------------|---------------|-------------------|
| Between charts (same section) | 12px | 16-24px |
| Between sections | 24px | 32-48px |
| Dashboard edges (margin) | 16px | 24-32px |
| Around scorecard text | 8px | 12-16px |
| Table row height | 32px | 36-40px |

---

#### White Space: Before vs After

**Bad (Cramped Layout):**
```
┌KPI┬KPI┬KPI┬KPI┐ ← No spacing
├───┼───┼───┼───┤
│Ch1│Ch2│Ch3│Ch4│ ← Overwhelming
├───┼───┼───┼───┤
│Tb1│Tb2│Tb3│Tb4│ ← Hard to focus
└───┴───┴───┴───┘
```
**Feels:** Cluttered, stressful, unprofessional
**User Reaction:** "Too much to look at, I'll check later" (never does)

---

**Good (Strategic White Space):**
```
┌─────────────────────────────────────┐
│                                     │
│   KPI      KPI      KPI      KPI    │ ← Space around KPIs
│                                     │
│                                     │ ← Section separator
│   Chart 1            Chart 2        │ ← Space between charts
│                                     │
│                                     │ ← Section separator
│   Detailed Table                    │
│                                     │
│                                     │ ← Bottom margin
└─────────────────────────────────────┘
```
**Feels:** Clear, professional, inviting
**User Reaction:** "This is easy to understand - let me explore"

---

#### Micro vs Macro White Space

**Micro White Space (Within Elements):**
- Padding inside scorecard boxes
- Space between label and value
- Letter spacing (tracking)
- Line height in text blocks

**Example Scorecard:**
```
┌──────────────┐
│              │ ← Top padding (12px)
│  NGN 45.3M   │ ← Value
│  Revenue     │ ← Label (8px below value)
│              │ ← Bottom padding (12px)
└──────────────┘
```

**Macro White Space (Between Elements):**
- Gutters between charts
- Margins around dashboard canvas
- Section dividers
- Header/footer spacing

---

### Principle 4: Page Dimensions and Canvas Size

#### Choosing Dashboard Dimensions

**Desktop Dashboards:**
- **Width:** 1920px (Full HD standard)
- **Height:** Variable (scrollable) OR 1080px (single page)
- **Aspect Ratio:** 16:9 for presentation mode

**Mobile-Optimized Dashboards:**
- **Width:** 375px (iPhone standard)
- **Height:** Variable (vertical scroll expected)
- **Orientation:** Portrait (vertical)

**Tablet Dashboards:**
- **Width:** 1024px (iPad standard)
- **Height:** 768px (landscape) OR variable
- **Orientation:** Both landscape and portrait

**Looker Studio Default:**
- **Canvas:** Infinite scroll (no fixed height)
- **Width:** Auto-adjusts to viewer's screen
- **Best Practice:** Design for 1920px width, test at 1366px and 1024px

---

#### Single-Page vs Scrollable Dashboards

**Single-Page Dashboard (No Scrolling):**

**Advantages:**
- All information visible at once
- Better for presentations (projected on screen)
- Faster to grasp overall picture
- Forces prioritization (can't fit everything)

**Disadvantages:**
- Limited content (max 6-8 charts)
- May feel cramped on smaller screens
- Less detail available

**Best For:**
- Executive summaries
- Real-time monitoring (NOC dashboards)
- Presentation mode
- TV/monitor displays in office

**Nigerian Example:** Store manager dashboard on TV screen showing today's sales, updated every 5 minutes

---

**Scrollable Dashboard (Vertical Scroll):**

**Advantages:**
- Unlimited content (can include many sections)
- Natural web behavior (users expect scrolling)
- More detail and analysis possible
- Better storytelling (top-to-bottom flow)

**Disadvantages:**
- Users may not scroll to see everything
- Need strong "above the fold" content
- Harder to print or present

**Best For:**
- Analytical deep-dives
- Multi-section dashboards
- Self-service exploration
- Weekly/monthly reports

**Nigerian Example:** End-of-month performance review dashboard with 15+ charts covering sales, inventory, customer satisfaction, logistics

---

## Practical Layout Techniques in Looker Studio

### Technique 1: Grid Alignment

**Enable Grid View:**
1. **View** → **Show Grid**
2. Elements snap to 8px or 16px grid
3. Creates pixel-perfect alignment

**Alignment Tools:**
- **Arrange** → **Align Left/Center/Right**
- **Arrange** → **Align Top/Middle/Bottom**
- **Arrange** → **Distribute Horizontally** (equal spacing)
- **Arrange** → **Distribute Vertically** (equal spacing)

**Pro Tip:** Select multiple charts → Right-click → **Distribute Horizontally** = perfectly spaced charts automatically

---

### Technique 2: Same Size Elements

**Problem:** 4 KPI scorecards with slightly different sizes (looks sloppy)

**Solution:**
1. Select all 4 scorecards (Shift + Click)
2. **Arrange** → **Make Same Width**
3. **Arrange** → **Make Same Height**
4. **Arrange** → **Distribute Horizontally**

**Result:** Perfectly aligned, equally-sized scorecards

---

### Technique 3: Background Containers

**Purpose:** Group related charts visually

**How to Create:**
1. **Insert** → **Rectangle** (shape)
2. Size to encompass multiple charts
3. Set background color (light gray: #F5F5F5)
4. **Arrange** → **Send to Back**
5. Add text label for section name

**Example:**
```
┌───────────────────────────────────┐
│ Performance Metrics               │ ← Section label
│ ┌──────────────────────────────┐  │
│ │                              │  │ ← Light gray container
│ │  [Chart 1]    [Chart 2]      │  │
│ │  [Chart 3]    [Chart 4]      │  │
│ │                              │  │
│ └──────────────────────────────┘  │
└───────────────────────────────────┘
```

---

### Technique 4: Visual Dividers

**Options:**
1. **Horizontal lines** between sections
2. **Different background colors** per section
3. **Whitespace alone** (24-48px gap)

**Best Practice:** Choose one method and use consistently

**Example with Lines:**
```
┌─────────────────────────────────┐
│  KPIs                           │
├─────────────────────────────────┤ ← Divider line
│  Trend Analysis                 │
├─────────────────────────────────┤ ← Divider line
│  Category Breakdown             │
└─────────────────────────────────┘
```

**Example with Background Colors:**
```
┌─────────────────────────────────┐
│  KPIs [Blue Background]         │
├─────────────────────────────────┤
│  Trend Analysis [White]         │
├─────────────────────────────────┤
│  Details [Light Gray]           │
└─────────────────────────────────┘
```

---

## Common Layout Mistakes to Avoid

### Mistake 1: Chart Tetris (Random Placement)

**Problem:** Charts placed wherever they fit, no alignment
```
┌────────────────────────┐
│  ┌───┐     ┌──────┐    │ ← Different sizes
│  │KPI│   ┌─┤Chart │    │ ← Overlapping
│  └───┘   │ └──────┘    │ ← No alignment
│      ┌───┴──┐          │
│      │Table │    ┌──┐  │ ← Random gaps
│      └──────┘    └──┘  │
└────────────────────────┘
```

**Result:** Looks unprofessional, hard to scan

**Solution:** Use grid alignment, consistent chart sizes, clear sections

---

### Mistake 2: Ignoring Visual Hierarchy

**Problem:** All charts the same size, no clear entry point
```
┌─────┬─────┬─────┬─────┐
│Chart│Chart│Chart│Chart│ ← All equal importance?
├─────┼─────┼─────┼─────┤
│Chart│Chart│Chart│Chart│ ← Where to look first?
└─────┴─────┴─────┴─────┘
```

**Result:** Overwhelming, no clear story

**Solution:** Make most important elements largest (KPIs at top, bigger size)

---

### Mistake 3: No White Space

**Problem:** Every pixel filled with content
```
┌KPI┬KPI┬KPI┬KPI┬KPI┬KPI┐ ← 6 KPIs crammed
├──┼──┼──┼──┼──┼──┼──┼──┤
│Ch│Ch│Ch│Ch│Ch│Ch│Ch│Ch│ ← 8 charts
├──┼──┼──┼──┼──┼──┼──┼──┤
│Tb│Tb│Tb│Tb│Tb│Tb│Tb│Tb│ ← 8 tables
```

**Result:** Cognitive overload, nothing stands out

**Solution:** Max 6-8 major elements, generous spacing (16-24px minimum)

---

### Mistake 4: Inconsistent Spacing

**Problem:** Random gaps between elements
```
┌─────┬─────┐
│ KPI │ KPI │ ← 10px gap
└─────┴─────┘

┌────────┐
│ Chart  │ ← 30px gap
└────────┘

┌─────────────┐
│ Table       │ ← 5px gap
└─────────────┘
```

**Result:** Feels unfinished, amateurish

**Solution:** Define spacing standards (e.g., always 16px between charts, always 32px between sections) and apply consistently

---

### Mistake 5: Mobile Ignored

**Problem:** Perfect on desktop, unusable on phone
- 4-column layout becomes unreadable on 375px screen
- Text too small to tap
- Charts overlap

**Result:** 60% of Nigerian users can't use your dashboard

**Solution:** Test mobile view, simplify for small screens (covered in section 02_multi_page_navigation.md)

---

## Real-World Nigerian Dashboard Layouts

### Layout 1: E-Commerce Executive Dashboard (Z-Pattern)

**Use Case:** Daily snapshot for CEO on mobile

**Layout:**
```
┌─────────────────────────────────────────┐
│ Daily Sales - January 31, 2026    [Menu]│ ① Top bar
│         ↓                               │
│  NGN 2.3M Revenue      ↑ 432 Orders     │ ② Key metrics
│  ↑ 15% vs yesterday    ↑ 8% growth      │
│         ↓                               │
│  [Today's Hourly Revenue Trend Chart]   │ Main visual
│         ↓                               │
│  Top: Electronics      ⚠ Stock Alert    │ ③ Action items
│  [Mini bar chart]      Low: Laptops     │
└─────────────────────────────────────────┘
```

**Why It Works:**
- Single page (no scrolling needed)
- Z-pattern guides eye naturally
- Mobile-optimized (readable on phone)
- Action items highlighted (stock alert)

---

### Layout 2: Weekly Performance Review (F-Pattern)

**Use Case:** Operations manager analyzing weekly trends

**Layout:**
```
┌──────────────────────────────────────────┐
│ Weekly Performance - Week 4, Jan 2026    │ Header
├──────────────────────────────────────────┤
│ Rev: 12.3M │ Orders: 4.5K │ AOV: 2.7K    │ ← KPI row
├──────────────────────────────────────────┤
│ TRENDS                                   │ ← Section 1
│ [Daily Revenue Bar Chart]                │
│ [Daily Order Volume Line Chart]          │
├──────────────────────────────────────────┤
│ CATEGORY PERFORMANCE                     │ ← Section 2
│ Electronics  ████████████ NGN 5.2M       │
│ Fashion      ████████ NGN 3.1M           │
│ Home         ████ NGN 2.0M               │
├──────────────────────────────────────────┤
│ GEOGRAPHIC BREAKDOWN                     │ ← Section 3
│ [Map of Nigeria with color intensity]    │
│ Top: Lagos (45%) | Abuja (23%)           │
├──────────────────────────────────────────┤
│ TOP PRODUCTS TABLE                       │ ← Section 4 (details)
│ [Sortable table with 20 products]        │
└──────────────────────────────────────────┘
```

**Why It Works:**
- F-pattern with clear left-side section labels
- Multiple sections organized logically
- Scrollable for depth, but KPIs above fold
- Clear visual hierarchy (KPIs → Trends → Breakdowns → Details)

---

### Layout 3: Customer Analytics Dashboard (Grid)

**Use Case:** Marketing team analyzing customer behavior

**Layout:**
```
┌────────────┬────────────┬────────────┐
│ Total      │ New        │ Returning  │ ← Row 1: 3 KPIs
│ Customers  │ Customers  │ Customers  │   (4 cols each)
│ 8,765      │ 1,234      │ 7,531      │
├────────────┴────────────┴────────────┤
│                                      │ ← Row 2: Full width
│  Customer Acquisition Trend (12)     │   (12 cols)
│  [Time series chart]                 │
├──────────────────┬───────────────────┤
│ Customers by     │ Customers by      │ ← Row 3: Two halves
│ State (6)        │ Age Group (6)     │   (6 cols each)
│ [Geo map]        │ [Pie chart]       │
├──────────────────┴───────────────────┤
│ Customer Segmentation Table (12)     │ ← Row 4: Full width
│ [Detailed table with RFM scores]     │
└──────────────────────────────────────┘
```

**Why It Works:**
- Clean grid structure (easy to scan)
- Responsive (automatically adjusts to tablet/mobile)
- Balanced layout (no element overpowers others)
- Logical flow (overview → trends → segments → details)

---

## Key Takeaways

1. **Visual hierarchy is non-negotiable** - Guide viewers to most important info first
2. **Match layout pattern to use case:**
   - F-pattern for detailed, multi-section dashboards
   - Z-pattern for simple executive summaries
   - Grid for flexible, responsive designs
3. **White space improves comprehension** - It's not wasted, it's intentional
4. **Alignment matters** - Use grid and alignment tools religiously
5. **Test on target devices** - If users view on mobile, design for mobile
6. **Consistency beats creativity** - Predictable layouts are easier to use
7. **Less is more** - 5 well-designed charts > 15 cluttered charts

---

## Hands-On Preview

**In the exercise, you'll:**
1. Analyze a poorly designed dashboard and identify layout problems
2. Redesign it using F-pattern layout with proper hierarchy
3. Apply white space principles for clarity
4. Use alignment tools for pixel-perfect positioning
5. Create a mobile-responsive version

**Example Improvement:**
- **Before:** 12 charts randomly placed, no spacing, unclear focus
- **After:** 6 prioritized charts, F-pattern flow, clear sections, 24px spacing

---

## Additional Resources

- **Layout Inspiration:** Looker Studio Template Gallery (best-in-class examples)
- **Grid Calculator:** 12-column grid overlay tool for planning
- **White Space Analysis:** Heat map tool showing density distribution
- **Reading Pattern Research:** Nielsen Norman Group eye-tracking studies
- **Nigerian Dashboard Examples:** Local business case studies with cultural context

---

**Next Section:** Multi-Page Navigation (02_multi_page_navigation.md) - Creating multi-page dashboards with intuitive navigation

**Related Concepts:**
- Week 13: Basic chart creation (you're now organizing those charts effectively)
- Week 14 Wednesday: Interactivity concepts (navigation builds on this)
- UX Design Principles: User-centered dashboard design
