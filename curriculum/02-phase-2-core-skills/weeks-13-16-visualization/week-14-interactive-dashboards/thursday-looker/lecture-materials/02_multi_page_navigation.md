# Multi-Page Navigation - Creating Dashboard Systems

**Week 14 - Thursday Session | Part 2 (20 minutes)**
**Business Context:** Building comprehensive dashboard systems with intuitive navigation for different audiences and use cases

---

## Learning Objectives

By the end of this section, you will be able to:
- Design effective multi-page dashboard structures
- Create intuitive navigation systems (tabs, menus, buttons)
- Implement cross-page filters for consistent user experience
- Organize dashboards by audience and purpose
- Apply information architecture principles
- Design mobile-friendly navigation patterns
- Use page templates for consistent branding

---

## Why Multi-Page Dashboards?

### The Single-Page Problem

**Scenario:** You try to fit everything on one dashboard:
- 20 KPIs
- 15 charts
- 5 data tables
- 10 filters

**Result:**
- Overwhelming scroll depth (3-4 screens long)
- Slow loading (too many queries)
- Unclear focus (what's important?)
- Poor mobile experience

**Nigerian Business Example:**
- CEO needs high-level overview
- Operations manager needs detailed logistics
- Marketing team needs customer analytics
- Finance needs revenue breakdowns

**Solution:** Multi-page dashboard with navigation

---

### Single Page vs Multi-Page Decision Matrix

| Use Single Page When... | Use Multi-Page When... |
|-------------------------|------------------------|
| 6-8 charts maximum | 10+ charts needed |
| Single audience (e.g., only executives) | Multiple audiences (executives + analysts) |
| Single topic (e.g., only revenue) | Multiple topics (sales + inventory + customers) |
| Real-time monitoring (dashboard on TV) | Exploratory analysis (self-service) |
| No scrolling needed | Deep-dive analysis required |
| Presentation mode | Web/mobile browsing |

---

## Multi-Page Dashboard Architecture

### Structure 1: Overview + Details (2-3 Pages)

**Most Common Pattern for Business Dashboards**

**Page 1: Executive Overview**
- Purpose: High-level snapshot for leadership
- Content: 4-6 KPIs, main trend chart, top insights
- Audience: CEO, directors, senior management
- Update Frequency: Daily or real-time

**Page 2: Detailed Analysis**
- Purpose: Deep-dive for analysts and managers
- Content: Category breakdowns, geographic analysis, trend details
- Audience: Operations managers, marketing team
- Update Frequency: Daily

**Page 3: Data Explorer (Optional)**
- Purpose: Raw data access for analysts
- Content: Detailed tables, custom filters, drill-downs
- Audience: Data analysts, BI team
- Update Frequency: Real-time or hourly

**Nigerian E-Commerce Example:**

```
┌─────────────────────────────────────────────┐
│ [Overview] [Sales Details] [Customer Insights]│ ← Navigation tabs
├─────────────────────────────────────────────┤
│                                             │
│ Page 1: Overview                            │
│ • NGN 45.3M Revenue (monthly KPI)          │
│ • 1,543 Orders                              │
│ • Top state: Lagos (45%)                    │
│ • Trend: ↑ 12% vs last month                │
│                                             │
└─────────────────────────────────────────────┘

┌─────────────────────────────────────────────┐
│ [Overview] [Sales Details] [Customer Insights]│
├─────────────────────────────────────────────┤
│                                             │
│ Page 2: Sales Details                       │
│ • Daily revenue breakdown (30 days)         │
│ • Product category performance              │
│ • Payment method analysis                   │
│ • Delivery performance by courier           │
│                                             │
└─────────────────────────────────────────────┘

┌─────────────────────────────────────────────┐
│ [Overview] [Sales Details] [Customer Insights]│
├─────────────────────────────────────────────┤
│                                             │
│ Page 3: Customer Insights                   │
│ • Customer acquisition trends               │
│ • Top customers by revenue                  │
│ • Customer retention metrics                │
│ • Geographic distribution map               │
│                                             │
└─────────────────────────────────────────────┘
```

---

### Structure 2: Topic-Based Pages (4-6 Pages)

**Use When:** Multiple business functions need separate views

**Nigerian Logistics Company Example:**

**Page 1: Delivery Performance**
- On-time delivery rate
- Average delivery time by state
- Courier performance comparison
- Delay reasons breakdown

**Page 2: Revenue Analytics**
- Total shipping revenue
- Revenue by service type (express, standard)
- Revenue by state
- Monthly trends

**Page 3: Customer Analytics**
- Active customers
- New vs returning customers
- Customer satisfaction scores
- Top customers by volume

**Page 4: Operational Efficiency**
- Packages processed per day
- Warehouse utilization
- Staff productivity metrics
- Vehicle fleet utilization

**Page 5: Financial Overview**
- P&L summary
- Cost breakdown
- Margin analysis
- Budget vs actual

---

### Structure 3: Audience-Based Pages (3-4 Pages)

**Use When:** Different roles need different information

**Nigerian Bank Branch Example:**

**Page 1: Branch Manager View**
- Daily deposits and withdrawals
- Customer service metrics
- Queue time analysis
- Staff performance

**Page 2: Regional Director View**
- Branch comparison across region
- Regional targets vs actuals
- Top performing branches
- Risk indicators

**Page 3: Operations View**
- Transaction volumes
- System uptime
- Processing times
- Error rates

**Page 4: Compliance View**
- Regulatory report status
- Policy violations
- Audit readiness
- Risk flags

---

## Navigation Methods in Looker Studio

### Method 1: Tab Navigation (Recommended)

**Best For:** 2-6 pages, frequent switching between pages

**How It Works:**
- Tabs appear at top of dashboard
- One-click access to any page
- Current page highlighted
- Always visible

**Creating Tabs:**
1. Create multiple pages in same report
2. **View** → **Page Navigation** → **Show Tabs**
3. Customize tab names (short, descriptive)
4. Reorder tabs by dragging

**Visual Example:**
```
┌─────────────────────────────────────────────┐
│ [Overview] [Sales] [Customers] [Inventory]  │ ← Tab bar
│            ▔▔▔▔▔▔                            │ ← Active indicator
├─────────────────────────────────────────────┤
│                                             │
│ Sales page content...                       │
│                                             │
└─────────────────────────────────────────────┘
```

**Tab Naming Best Practices:**
- ✓ Short: "Sales" not "Sales Performance Analysis"
- ✓ Clear: "Customers" not "CRM"
- ✓ Consistent: All nouns OR all verbs
- ✗ Avoid: "Page 1", "Dashboard 2" (meaningless)

**Nigerian Context Example:**
```
[Overview] [Lagos] [Abuja] [Port Harcourt] [Kano]
   ↑         ↑       ↑           ↑            ↑
   All    State   State       State       State
  Nigeria  views  views       views       views
```

---

### Method 2: Button Navigation (Custom Design)

**Best For:** Branded experience, landing page with multiple destinations

**How It Works:**
- Custom buttons designed to match brand
- Can include icons and descriptions
- More flexible positioning
- Requires more setup

**Creating Navigation Buttons:**
1. **Insert** → **Rectangle** (create button shape)
2. Style rectangle (brand color, rounded corners)
3. Add text label on top of rectangle
4. Select rectangle → **Link** icon → **Page Navigation**
5. Choose destination page
6. Group text and rectangle together

**Example Landing Page:**
```
┌─────────────────────────────────────────────┐
│         LAGOS E-COMMERCE DASHBOARD          │
│                                             │
│  Select a view:                             │
│                                             │
│  ┌─────────────┐    ┌─────────────┐       │
│  │  Executive  │    │    Sales    │       │
│  │   Summary   │    │   Analysis  │       │
│  └─────────────┘    └─────────────┘       │
│                                             │
│  ┌─────────────┐    ┌─────────────┐       │
│  │  Customer   │    │  Inventory  │       │
│  │  Insights   │    │   Status    │       │
│  └─────────────┘    └─────────────┘       │
│                                             │
└─────────────────────────────────────────────┘
```

**Button Design Tips:**
- Use brand colors consistently
- Make buttons large (touch-friendly): Minimum 120px × 60px
- Include hover effects (change color on mouse-over)
- Add icons for visual recognition (📊 Sales, 👥 Customers)
- Maintain spacing (16-24px between buttons)

---

### Method 3: Dropdown Menu Navigation

**Best For:** 6+ pages, saving vertical space, secondary navigation

**How It Works:**
- Compact dropdown selector
- Users select page from list
- Good for many pages
- Less discoverable than tabs

**Creating Dropdown Navigation:**
1. Use a **Filter Control** set to "Page Name" (custom setup)
2. Configure control to change page on selection
3. Style as dropdown menu
4. Place at top of dashboard

**Visual Example:**
```
┌─────────────────────────────────────────────┐
│ Select View: [Overview ▼]                   │ ← Dropdown
│              [Sales Analysis    ]           │
│              [Customer Metrics  ]           │
│              [Inventory Status  ]           │
├─────────────────────────────────────────────┤
│                                             │
│ Dashboard content...                        │
│                                             │
└─────────────────────────────────────────────┘
```

**When to Use:**
- More than 6 pages (tabs get cramped)
- Mobile-first design (saves screen space)
- Hierarchical navigation (categories with sub-pages)

---

### Method 4: Breadcrumb Navigation

**Best For:** Deep hierarchy, showing current location

**How It Works:**
- Shows navigation path
- Users can click to go back
- Example: Home > Sales > Lagos > Electronics

**Visual Example:**
```
┌─────────────────────────────────────────────┐
│ Home > Sales Dashboard > Lagos Region       │ ← Breadcrumb
├─────────────────────────────────────────────┤
│                                             │
│ Lagos Region Sales Details...               │
│                                             │
└─────────────────────────────────────────────┘
```

**Implementation in Looker Studio:**
- Create text with hyperlinks to previous pages
- Style to look like breadcrumb trail
- Update on each page to reflect location

---

## Cross-Page Filters (Global Controls)

### The Problem: Filter Fatigue

**Scenario:** User wants to view sales for "November 2025" across all pages

**Without Cross-Page Filters:**
1. Page 1: Set date filter to November
2. Navigate to Page 2: Date reset to default, set filter again
3. Navigate to Page 3: Date reset again, set filter AGAIN
4. User frustrated, closes dashboard

**With Cross-Page Filters:**
1. Page 1: Set date filter to November ONCE
2. Navigate to Page 2: Still showing November (filter persists)
3. Navigate to Page 3: Still November (consistent experience)
4. User happy, continues exploring

---

### Setting Up Cross-Page Filters

**Step-by-Step:**

1. **Create Filter on First Page:**
   - Add filter control (e.g., Date Range)
   - Configure as usual

2. **Enable Cross-Page Filtering:**
   - Select filter control
   - Properties panel → **Apply to:**
   - Choose **All pages** (not just "This page")

3. **Verify on Other Pages:**
   - Navigate to Page 2
   - Check that filter selection carries over
   - Test filtering to confirm it works

**Common Cross-Page Filters:**
- **Date Range:** Most common (all pages need consistent time period)
- **State/Region:** Geographic analysis across multiple topics
- **Product Category:** Filter all pages by product type
- **Customer Segment:** B2B vs B2C, new vs returning
- **Currency:** USD vs NGN for international businesses

---

### Filter Placement for Multi-Page Dashboards

**Option 1: Top Navigation Bar (Recommended)**
```
┌─────────────────────────────────────────────┐
│ [Overview] [Sales] [Customers]              │ ← Tabs
├─────────────────────────────────────────────┤
│ Date: [Nov 2025 ▼]  State: [All ▼]         │ ← Global filters
├─────────────────────────────────────────────┤
│                                             │
│ Page content...                             │
│                                             │
└─────────────────────────────────────────────┘
```

**Advantages:**
- Always visible
- Consistent location across pages
- Clear visual separation from content

**Option 2: Sidebar (Alternative)**
```
┌─────────┬───────────────────────────────────┐
│ FILTERS │ [Overview] [Sales] [Customers]    │
├─────────┤                                   │
│ Date    │ Page content...                   │
│ [Nov ▼] │                                   │
│         │                                   │
│ State   │                                   │
│ [All ▼] │                                   │
│         │                                   │
│ Product │                                   │
│ [All ▼] │                                   │
└─────────┴───────────────────────────────────┘
```

**Advantages:**
- More space for multiple filters
- Doesn't use vertical space
- Can be collapsible

---

## Page Templates and Consistency

### Why Templates Matter

**Problem:** Each page looks different
- Different header styles
- Inconsistent font sizes
- Different color schemes
- Random filter placement

**Result:** Feels like separate dashboards, not one system

**Solution:** Create a page template

---

### Creating a Master Template

**Step 1: Design First Page with All Standard Elements**

**Template Elements:**
```
┌─────────────────────────────────────────────┐
│ [Company Logo]  DASHBOARD TITLE   [Date]   │ ← Header (consistent)
├─────────────────────────────────────────────┤
│ [Nav: Overview] [Sales] [Customers]         │ ← Navigation
├─────────────────────────────────────────────┤
│ Date: [Filter] State: [Filter]              │ ← Global filters
├─────────────────────────────────────────────┤
│                                             │
│ [Page-specific content goes here]          │ ← Flexible area
│                                             │
│                                             │
├─────────────────────────────────────────────┤
│ Last Updated: [Timestamp] | Contact: ...   │ ← Footer (consistent)
└─────────────────────────────────────────────┘
```

**Step 2: Duplicate Template for New Pages**
1. Right-click page tab → **Duplicate Page**
2. Rename page
3. Delete old content (keep header/nav/footer)
4. Add page-specific charts

**Step 3: Lock Template Elements**
- Select header, navigation, filters, footer
- Right-click → **Lock** (prevents accidental editing)

---

### Nigerian Business Template Example

**Company:** Lagos Fashion Retailer
**Brand Colors:** Purple (#9C27B0), Gold (#FFD700)

**Template Applied to All Pages:**
```
┌─────────────────────────────────────────────┐
│ [Logo] LAGOS FASHION ANALYTICS     Jan 2026 │ ← Purple header
├─────────────────────────────────────────────┤
│ [Overview] [Sales] [Inventory] [Customers]  │ ← Gold tabs
├─────────────────────────────────────────────┤
│ Date Range: [Filter]  Store: [Filter]       │ ← Cross-page filters
├─────────────────────────────────────────────┤
│                                             │
│ [Each page has different content here]     │
│                                             │
├─────────────────────────────────────────────┤
│ Updated: 31 Jan 2026 10:30 AM               │ ← Gray footer
│ Questions? analytics@lagosfashion.com.ng    │
└─────────────────────────────────────────────┘
```

**Consistency Benefits:**
- Users know where to find filters (always in same spot)
- Brand recognition (logo and colors on every page)
- Professional appearance
- Faster navigation (predictable layout)

---

## Mobile Navigation Design

### Mobile Challenges

**Problem:** Desktop navigation doesn't work on mobile
- Tabs too small to tap accurately (need 44px minimum)
- Horizontal scrolling to see all tabs (poor UX)
- Dropdown menus hard to use on small screens
- Filters overlap with content

**Nigerian Context:**
- 60%+ users on mobile
- Many using smaller screens (iPhone SE, budget Android)
- Touch-based interaction (no mouse hover)

---

### Mobile Navigation Solutions

#### Solution 1: Hamburger Menu

**How It Works:**
- Three-line icon (☰) in top corner
- Tap to open navigation menu
- Menu overlays or slides in from side
- Takes up full screen on mobile

**Implementation:**
1. Create button with hamburger icon (☰)
2. Add navigation links to overlay page
3. Show overlay on button click
4. Hide on page selection

**Visual:**
```
Mobile View:

┌─────────────────────┐
│ ☰  Dashboard  [🔍]  │ ← Hamburger menu icon
├─────────────────────┤
│                     │
│ Content visible...  │
│                     │
└─────────────────────┘

Tap ☰ →

┌─────────────────────┐
│ MENU            [×] │ ← Close button
├─────────────────────┤
│ Overview            │
│ Sales Analysis      │
│ Customer Insights   │
│ Inventory Status    │
│ Settings            │
└─────────────────────┘
```

---

#### Solution 2: Bottom Tab Bar

**How It Works:**
- Navigation tabs at bottom of screen (like mobile apps)
- Always visible while scrolling
- Large touch targets (48px+ height)
- Icons + text labels

**Implementation:**
1. Create fixed bar at bottom of each page
2. Add navigation buttons with icons
3. Highlight current page
4. Make sure buttons are large (easy to tap)

**Visual:**
```
┌─────────────────────┐
│                     │
│ Dashboard content   │
│ (scrollable)        │
│                     │
│                     │
├─────────────────────┤
│ 📊     💰    👥    │ ← Bottom tabs
│ Over-  Sales Custom │
│ view          ers   │
└─────────────────────┘
```

---

#### Solution 3: Vertical Navigation (Scrollable Tabs)

**How It Works:**
- Tabs stack vertically on mobile
- Scroll up/down to see all pages
- Each tab full width (easy to tap)
- Current page highlighted

**Looker Studio Auto-Behavior:**
- Tabs automatically stack on narrow screens
- Test with **View** → **Mobile Layout**

**Visual:**
```
Desktop:
[Overview][Sales][Customers][Inventory]

Mobile:
┌─────────────────────┐
│ ▶ Overview          │ ← Selected
├─────────────────────┤
│   Sales Analysis    │
├─────────────────────┤
│   Customer Insights │
├─────────────────────┤
│   Inventory Status  │
└─────────────────────┘
```

---

## Information Architecture Best Practices

### Principle 1: Logical Grouping

**Group Related Pages Together**

**Bad:**
```
[Sales] [Customers] [Inventory] [Revenue] [Products] [Orders]
  ↑        ↑           ↑           ↑          ↑         ↑
Random order - hard to predict what's where
```

**Good:**
```
[Overview] | [Sales][Revenue][Orders] | [Customers][Products] | [Inventory]
    ↑              ↑ Revenue Group         ↑ Customer Group      ↑ Operations
  Summary          (all related)           (all related)
```

---

### Principle 2: Progressive Disclosure

**Start Broad, Then Allow Deep-Dives**

**Page Flow:**
1. **Overview** (high-level, all topics)
   - Link to: Sales, Customers, Inventory
2. **Sales** (all sales metrics)
   - Link to: Sales by Category, Sales by State
3. **Sales by Category** (specific deep-dive)
   - Link back to: Sales, Overview

**Navigation Path Example:**
```
Overview → Sales → Electronics Category → Product Details
  ↓
[Back to Overview] [Back to Sales] [Back to Categories]
```

---

### Principle 3: Maximum 7±2 Items

**Cognitive Psychology:** Humans can hold 5-9 items in short-term memory

**Application to Navigation:**
- **Ideal:** 5 main pages (Overview + 4 topics)
- **Maximum:** 7 main pages before users get lost
- **Too Many?** Create sub-navigation or categories

**Example Hierarchy:**
```
Main Navigation (5 items):
[Overview] [Sales] [Operations] [Finance] [People]

Sales Sub-Pages (not in main nav):
- Sales by Region
- Sales by Product
- Sales Trends

Operations Sub-Pages:
- Inventory
- Logistics
- Quality Control
```

---

### Principle 4: Orientation Cues

**Users Should Always Know:**
1. Where am I? (current page highlighted)
2. Where can I go? (visible navigation options)
3. How do I get back? (breadcrumbs or back button)

**Example:**
```
┌─────────────────────────────────────────────┐
│ [Overview] [Sales] [Customers]              │
│            ▔▔▔▔▔▔                            │ ← You are here
│ Home > Sales Dashboard                      │ ← Breadcrumb
├─────────────────────────────────────────────┤
│ Sales Performance                           │ ← Page title
│                                             │
└─────────────────────────────────────────────┘
```

---

## Common Navigation Mistakes to Avoid

### Mistake 1: Too Many Pages

**Problem:** 15 pages in navigation bar

**Result:**
- Overwhelming choice (analysis paralysis)
- Tiny tabs on mobile (impossible to tap)
- Users don't explore beyond page 1

**Solution:**
- Consolidate to 5-7 main pages
- Use drill-down navigation for details
- Create separate reports for different audiences

---

### Mistake 2: Unclear Page Names

**Problem:**
```
[Dashboard 1] [Dashboard 2] [Report A] [Report B]
```

**Result:** Users have no idea what each page contains

**Solution:** Descriptive, role-based names
```
[Executive Summary] [Sales Team] [Operations] [Finance]
```

---

### Mistake 3: No Visual Feedback

**Problem:**
- Click navigation button, no indication it worked
- Current page not highlighted
- User confused: "Did my click work?"

**Solution:**
- Highlight active page (different color, underline)
- Show loading indicator for page transitions
- Use consistent styling for selected state

---

### Mistake 4: Filters Don't Carry Over

**Problem:** User sets date filter on Page 1, navigates to Page 2, filter resets

**Result:** Frustration, abandonment

**Solution:** Use cross-page filters (covered earlier)

---

### Mistake 5: Mobile Navigation Ignored

**Problem:** Perfect desktop navigation, unusable on mobile

**Result:** 60% of Nigerian users can't navigate your dashboard

**Solution:**
- Test mobile view for every page
- Use mobile-friendly navigation (hamburger menu or bottom tabs)
- Ensure tap targets are 44px+ minimum

---

## Real-World Nigerian Multi-Page Dashboard Examples

### Example 1: Lagos E-Commerce Platform

**Pages:**
1. **Executive Dashboard** (CEO daily view)
   - NGN revenue today/week/month
   - Order volume
   - Top 3 alerts

2. **Sales Performance** (Sales team)
   - Revenue by category
   - Revenue by state
   - Sales rep leaderboard

3. **Customer Analytics** (Marketing team)
   - New vs returning customers
   - Customer lifetime value
   - Acquisition sources

4. **Inventory Management** (Operations)
   - Stock levels by product
   - Low stock alerts
   - Supplier performance

5. **Delivery Performance** (Logistics)
   - On-time delivery rate
   - Average delivery time
   - Courier comparison

**Navigation:** Tab-based (5 clear tabs)
**Cross-Page Filters:** Date range, State
**Mobile:** Vertical stacked tabs

---

### Example 2: Nigerian Bank Branch Network

**Pages:**
1. **National Overview** (Head office)
   - All branches performance
   - Regional comparison
   - National KPIs

2. **Lagos Region** (Regional view)
   - Branch comparison within Lagos
   - Regional trends
   - Top performers

3. **Branch Details** (Branch manager)
   - Individual branch deep-dive
   - Customer satisfaction
   - Staff metrics

4. **Compliance & Risk** (Risk team)
   - Policy violations
   - Audit status
   - Risk indicators

**Navigation:** Dropdown menu (hierarchical: National → Region → Branch)
**Cross-Page Filters:** Date range, Branch selector
**Mobile:** Hamburger menu with sub-categories

---

## Key Takeaways

1. **Multi-page when content exceeds 8 charts** - Don't cram everything on one page
2. **Organize by audience or topic** - Sales team page, Operations page, etc.
3. **Use tabs for 2-6 pages** - Most intuitive navigation method
4. **Cross-page filters are essential** - Users shouldn't reset filters on every page
5. **Create templates for consistency** - Header, navigation, footer same on all pages
6. **Test mobile navigation** - 60% of Nigerian users are on mobile
7. **7±2 rule** - Maximum 7 main pages before users get lost
8. **Show where users are** - Highlight current page, use breadcrumbs

---

## Hands-On Preview

**In the exercise, you'll:**
1. Convert a single cramped dashboard into a 3-page system
2. Create tab navigation with proper page names
3. Set up cross-page filters for date and state
4. Design a consistent header/footer template
5. Test mobile navigation on small screen

**Pages You'll Create:**
- Page 1: Executive Overview (KPIs + main trend)
- Page 2: Sales Analysis (category and geographic breakdowns)
- Page 3: Customer Insights (customer metrics and segmentation)

---

## Additional Resources

- **Navigation Patterns:** Google Material Design navigation guidelines
- **Mobile Navigation:** iOS and Android app navigation best practices
- **IA Tools:** Card sorting for user-driven information architecture
- **Examples:** Looker Studio community gallery for multi-page inspiration
- **Nigerian Case Studies:** Local dashboard examples with cultural context

---

**Next Section:** Performance Optimization (03_performance_optimization.md) - Making dashboards load faster for Nigerian internet conditions

**Related Concepts:**
- Section 01: Page layout principles (now organizing across multiple pages)
- Week 14 Wednesday: Cross-chart filtering (extending to cross-page filtering)
- Week 11 SQL: Query optimization (dashboard-level performance)
