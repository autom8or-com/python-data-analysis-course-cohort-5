# Filter Relationships and Scope Configuration

## Week 14 - Wednesday Session - Part 2

### Duration: 15-20 minutes

---

## What Are Filter Relationships?

**Filter relationships** in Looker Studio control how filters and controls interact with charts on your dashboard. They determine the **scope** of filtering—which charts are affected when a user changes a control.

### Why This Matters

Imagine a sales dashboard with three sections:
1. **Overall Performance** (all products, all states)
2. **Regional Deep Dive** (specific state selected)
3. **Product Analysis** (specific category selected)

**Business Question:** When a user selects "São Paulo" from the state filter, what should happen?

**Option A:** All charts filter to São Paulo (including overall performance)
**Option B:** Only regional charts filter; overall performance stays national

**Filter relationships** let you control this behavior.

---

## The Problem: Default Filtering Behavior

### By Default: Everything Filters

When you add a control in Looker Studio, it filters **ALL** charts using that data source:

```
Dashboard with State Filter: [SP selected]
├── Chart 1: Total National Revenue → Now shows SP only ❌
├── Chart 2: Revenue by State → Shows SP only ✅
└── Chart 3: Top Products Nationally → Now shows SP only ❌
```

**Issue:** You lost your national context! Chart 1 and 3 should show all states for comparison.

### The Solution: Configure Filter Scope

```
Dashboard with State Filter: [SP selected]
├── Chart 1: Total National Revenue → NOT filtered (shows all) ✅
├── Chart 2: Revenue by State → Filtered to SP ✅
└── Chart 3: Top Products Nationally → NOT filtered (shows all) ✅
```

---

## Understanding Filter Scope

### Three Scope Levels

#### 1. **Report-Level Filters**
**Affect:** All charts across all pages
**Use for:** Global conditions (e.g., "only show delivered orders")

**SQL Equivalent:**
```sql
-- Every query in your analysis includes this
WHERE order_status = 'delivered'
```

#### 2. **Page-Level Filters**
**Affect:** All charts on a specific page
**Use for:** Page-specific focus (e.g., Page 1: 2017 data, Page 2: 2018 data)

**SQL Equivalent:**
```sql
-- Queries on this page include:
WHERE YEAR(order_date) = 2017
```

#### 3. **Chart-Level Filters**
**Affect:** Single chart only
**Use for:** Specific chart requirements (e.g., "Top 10 products only")

**SQL Equivalent:**
```sql
-- One specific query has:
LIMIT 10
```

---

## Part 1: Configuring Control Scope

### Scenario: E-commerce Executive Dashboard

**Dashboard Layout:**
```
┌─────────────────────────────────────────────────────┐
│  Controls: [📅 Date Range] [🗺️ State Filter]        │
├─────────────────────────────────────────────────────┤
│  COMPANY-WIDE KPIs (Should NOT filter by state)     │
│  [Total Revenue] [Total Orders] [Active Customers]  │
├─────────────────────────────────────────────────────┤
│  STATE-SPECIFIC ANALYSIS (Should filter by state)   │
│  [State Revenue Trend] [Top Cities in State]        │
└─────────────────────────────────────────────────────┘
```

**Requirement:**
- Date Range → Filters everything
- State Filter → Filters ONLY state-specific charts, NOT company KPIs

### Step 1: Identify Charts to Exclude

Create a list:
- **Filter applies to:** State Revenue Trend, Top Cities in State
- **Exclude from filter:** Total Revenue, Total Orders, Active Customers

### Step 2: Configure Chart Filter Scope

**Method 1: Disable Filter on Specific Charts**

1. Select a chart that should NOT be filtered (e.g., "Total Revenue" scorecard)
2. Right panel → **Setup** tab
3. Scroll to **"Chart filters"** section
4. Find the state control filter
5. Click the **"X"** to remove it from this chart

**Visual Guide:**
```
Chart: Total Revenue Scorecard
─────────────────────────────────────
Setup | Style

Data
  Metric: SUM(price)

Filters applied to chart
  ├── 📅 Date Range ✓ (keep this)
  └── 🗺️ State Filter [X] ← Click X to remove
```

**Method 2: Create Filter Scope Groups (Advanced)**

1. Click on the state filter control
2. Right panel → **Setup** tab → **"Filter scope"**
3. Options:
   - ⚪ **All widgets** (default—filters everything)
   - ⚪ **Selected widgets only** ← Choose this
4. Click **"Select charts..."**
5. Check only the charts that should be filtered

```
Select charts to filter
─────────────────────────────────────
☐ Total Revenue (company-wide)
☐ Total Orders (company-wide)
☐ Active Customers (company-wide)
☑ State Revenue Trend ✓
☑ Top Cities in State ✓
☑ State Performance Map ✓
```

**Click "APPLY"**

---

## Part 2: Cross-Filtering Between Charts

### What Is Cross-Filtering?

**Cross-filtering** allows users to click on chart elements to filter other charts—turning charts into interactive filters themselves.

### Example: Click-to-Filter Workflow

**Scenario:** Product category analysis

```
User Action: Clicks "Electronics" bar in Category Revenue chart
    ↓
Result: All other charts filter to show Electronics data only
    ├── Revenue Trend → Now shows Electronics trend
    ├── Top Products → Now shows top Electronics products
    └── State Map → Now shows Electronics sales by state
```

**Business Value:**
- No need to add separate category filter
- Intuitive point-and-click exploration
- Faster insights ("What drives Electronics sales in Q4?")

### Enabling Cross-Filtering

#### Step 1: Enable on Source Chart

1. Select the chart you want to be clickable (e.g., "Revenue by Category" bar chart)
2. Right panel → **Setup** tab
3. Scroll to **"Interactions"** section
4. Check ☑ **"Apply filter"**

```
Interactions
─────────────────────────────────────
☑ Apply filter
  When viewers click a bar/segment, filter other charts

☐ Cross-filtering (advanced)
  Two-way filtering between charts
```

#### Step 2: Test in View Mode

1. Click **"View"** (top-right)
2. Click on a category bar
3. Observe other charts filtering
4. Click again to deselect (or click different bar)

**Visual Feedback:**
- Selected bar: Highlighted (darker color)
- Other bars: Dimmed (lower opacity)
- Filtered charts: Show filtered icon 🔍

---

## Part 3: Filter Inclusion vs Exclusion

### Understanding Include/Exclude Logic

When configuring filters, you can choose how they apply:

#### Include Mode (Default)
**Behavior:** Show ONLY selected values

**SQL Equivalent:**
```sql
WHERE customer_state IN ('SP', 'RJ', 'MG')  -- Include these
```

**Example:**
Filter: "Show SP, RJ, MG"
Result: Charts display only these three states

#### Exclude Mode
**Behavior:** Show everything EXCEPT selected values

**SQL Equivalent:**
```sql
WHERE customer_state NOT IN ('AC', 'RR', 'AP')  -- Exclude these
```

**Example:**
Filter: "Exclude AC, RR, AP" (low-volume states)
Result: Charts show all states except these three

### When to Use Exclude Filters

**Use Case 1: Removing Outliers**
```
Exclude mode: product_category = "test_category"
Reason: Internal test data, not real sales
```

**Use Case 2: Regulatory Compliance**
```
Exclude mode: customer_state = "International"
Reason: Dashboard for domestic operations only
```

**Use Case 3: Data Quality**
```
Exclude mode: order_status IN ("canceled", "refunded")
Reason: Focus on successful transactions only
```

### Configuring Exclude Filters

1. Select chart
2. Right panel → **Setup** → **"Filters"**
3. Click **"+ Add a filter"**
4. Click **"CREATE A FILTER"**
5. Configure filter:

```
Create Filter
─────────────────────────────────────
Filter Name: Exclude Test Orders

Include/Exclude
  ⚪ Include
  ⚪ Exclude ← Select this

Conditions
  Field: product_category
  Condition: Equals (=)
  Value: "test_category"

[SAVE]
```

---

## Part 4: Advanced Filtering Scenarios

### Scenario 1: Comparison Dashboards

**Business Need:** Compare 2017 vs 2018 performance side-by-side

**Dashboard Layout:**
```
┌──────────────────┬──────────────────┐
│   2017 Analysis  │   2018 Analysis  │
├──────────────────┼──────────────────┤
│ Revenue: ₦500M   │ Revenue: ₦650M   │
│ Orders: 10,000   │ Orders: 12,500   │
│ [Trend Chart]    │ [Trend Chart]    │
└──────────────────┴──────────────────┘
```

**Implementation:**
1. Create page with two sections
2. Left section: Add chart filter `YEAR(order_date) = 2017`
3. Right section: Add chart filter `YEAR(order_date) = 2018`
4. Date range control: Exclude from both sections (they have fixed years)

### Scenario 2: Drill-Down Hierarchy

**Business Need:** National → Regional → State → City analysis

**Control Setup:**
```
Level 1: Region Filter [Northeast/Southeast/South/etc.]
  ↓ (filters Level 2)
Level 2: State Filter [SP/RJ/MG/etc.]
  ↓ (filters Level 3)
Level 3: City Filter [São Paulo/Rio/Belo Horizonte/etc.]
```

**Filter Relationship:**
- Region filter → Applies to State and City filters (cascading)
- State filter → Applies to City filter only
- City filter → Applies to charts only

**Implementation:**
1. Create calculated field `region` (from Week 13):
```
region = CASE
  WHEN customer_state IN ("SP","RJ","MG","ES") THEN "Southeast"
  WHEN customer_state IN ("RS","SC","PR") THEN "South"
  ...
END
```

2. Add three drop-down controls:
   - Control 1: Region (top-level)
   - Control 2: State (filtered by Region)
   - Control 3: City (filtered by State)

3. Configure scope:
   - Region control → Scope includes State control, City control, all charts
   - State control → Scope includes City control, all charts
   - City control → Scope includes charts only

### Scenario 3: Conditional Dashboard Sections

**Business Need:** Show different charts based on user selection

**Example:** Product Type Selector
- If "Physical Products" selected → Show shipping charts
- If "Digital Products" selected → Show download charts

**Implementation:**
1. Add product type filter (Physical/Digital)
2. Create two sets of charts:
   - Set A (Shipping): Filter to `product_type = "Physical"`
   - Set B (Downloads): Filter to `product_type = "Digital"`
3. User selects type → Relevant section appears with data

**Limitation:** Looker Studio doesn't hide/show sections dynamically. Alternative:
- Use **blended data** to show metrics conditionally
- Create separate pages for each product type

---

## Part 5: Filter Performance Optimization

### Why Filter Performance Matters

**Slow Dashboard Scenario:**
```
User changes date range → 10-second wait → Charts finally update
```

**Causes:**
- Large datasets being re-queried
- Complex calculated fields
- Too many charts filtering simultaneously
- Unoptimized database queries

### Optimization Technique 1: Backend Filtering

**Apply permanent filters at data source level:**

1. Edit data source
2. Add backend filter:
```sql
-- In custom SQL query
WHERE order_date >= '2017-01-01'  -- Don't query ancient data
  AND order_status = 'delivered'  -- Only completed orders
```

**Result:** Looker only queries relevant subset of data

### Optimization Technique 2: Pre-Aggregated Data

**Instead of:**
```sql
-- Looker queries raw data every time
SELECT order_date, SUM(price)
FROM olist_order_items_dataset
GROUP BY order_date
-- (millions of rows processed)
```

**Do:**
```sql
-- Create aggregated view in database
CREATE VIEW daily_revenue AS
SELECT order_date, SUM(price) as revenue
FROM olist_order_items_dataset
GROUP BY order_date;

-- Looker queries the view (365 rows for 1 year)
SELECT * FROM daily_revenue
```

**Benefit:** 1000x faster queries

### Optimization Technique 3: Limit Filter Options

**For high-cardinality dimensions:**

1. Edit filter control
2. Set **"Max items"** to reasonable number (e.g., 100)
3. Add **search box** for finding specific values
4. Sort by relevance (e.g., revenue DESC)

**Example: Product Category Filter**
```
Instead of: 73 categories (overwhelming)
Show: Top 20 categories by revenue + search box
```

---

## Part 6: Common Filter Relationship Patterns

### Pattern 1: Global Date, Selective Dimensions

**Use Case:** Most dashboards

```
Filters:
├── 📅 Date Range → Applies to ALL charts ✓
├── 🗺️ State Filter → Applies to regional charts only
├── 🛍️ Category Filter → Applies to product charts only
└── 💳 Payment Filter → Applies to payment charts only
```

### Pattern 2: Layered Filtering

**Use Case:** Drill-down analysis

```
Filters (cumulative):
├── Level 1: Date Range → Everything
├── Level 2: Region → Charts + lower controls
├── Level 3: State → Charts + lower controls
└── Level 4: City → Charts only
```

### Pattern 3: Independent Sections

**Use Case:** Multi-audience dashboard

```
Page Layout:
├── Section A: Executive Summary (no filters except date)
├── Section B: Sales Analysis (state + category filters)
└── Section C: Operations (warehouse + shipping filters)
```

**Each section has independent filter scope**

### Pattern 4: Comparison Mode

**Use Case:** A/B testing, period comparison

```
Page Layout:
├── Shared Controls: Date range, category
├── Section A: Variant A (filter: experiment_group = "A")
├── Section B: Variant B (filter: experiment_group = "B")
└── Section C: Comparison (no experiment filter—shows both)
```

---

## Part 7: Troubleshooting Filter Issues

### Issue 1: Filter Not Working

**Symptoms:**
- Control exists but charts don't filter
- Changing control values has no effect

**Diagnostic Steps:**
1. Check data source consistency
```
Control data source: olist_orders_dataset
Chart data source: olist_orders_dataset ✓ (must match!)
```

2. Verify dimension names match
```
Control field: customer_state
Chart dimension: customer_state ✓ (exact match required)
```

3. Check filter scope
```
Chart → Setup → Is this chart in filter scope? ✓
```

4. Look for conflicting filters
```
Chart has filter: customer_state = "SP" (fixed)
Control tries to change to "RJ" ❌ (conflict!)
```

### Issue 2: Unexpected Filtering Behavior

**Symptom:** Some charts filter when they shouldn't (or vice versa)

**Solution:**
1. Review filter scope for each control
2. Document which charts should be affected
3. Use **"Selected widgets only"** scope for precision
4. Test each filter independently in View mode

### Issue 3: Slow Filter Response

**Symptom:** Long delay when changing filters

**Solutions:**
1. Check data source query performance
   - Edit data source → Look at query time
   - Optimize SQL if using custom query

2. Reduce number of charts
   - Each chart re-queries when filter changes
   - Consider paginating (move some charts to page 2)

3. Add backend filters
   - Limit date range to last 2 years
   - Exclude low-volume categories

4. Use data extracts (advanced)
   - Cache data in Looker Studio
   - Refresh every 12 hours
   - Much faster filtering

---

## Part 8: Practical Exercise (10 minutes)

### Task: Configure a Two-Section Dashboard

**Scenario:** Executive + Analyst Dashboard

#### Requirements:

**Section 1: Executive Summary (Top)**
- Total Revenue scorecard
- Total Orders scorecard
- Revenue Trend line chart
- **Filtering:** Date range ONLY (no state/category filters)

**Section 2: Detailed Analysis (Bottom)**
- Revenue by State bar chart
- Top Products table
- Category Performance pie chart
- **Filtering:** Date range + State + Category filters

#### Implementation Steps:

1. **Add Controls**
   - Date Range control (top-left)
   - State Filter drop-down (below date)
   - Category Filter drop-down (below state)

2. **Configure Date Range Scope**
   - Scope: All widgets ✓ (default is fine)

3. **Configure State Filter Scope**
   - Click state filter control
   - Setup → Filter scope → **"Selected widgets only"**
   - Select: Revenue by State, Top Products, Category Performance
   - Exclude: Total Revenue, Total Orders, Revenue Trend

4. **Configure Category Filter Scope**
   - Click category filter control
   - Setup → Filter scope → **"Selected widgets only"**
   - Select: Top Products, Category Performance
   - Exclude: All scorecards, Revenue by State

5. **Test in View Mode**
   - Change date → All charts update
   - Change state → Only Section 2 charts update
   - Change category → Only product-related charts update

#### Success Criteria:
- ✅ Section 1 shows company-wide totals regardless of state/category selection
- ✅ Section 2 filters by state when selected
- ✅ Product charts filter by both state AND category
- ✅ Date range affects everything

---

## Connection to Prior Learning

### Week 2: SQL WHERE Clauses with Multiple Conditions

```sql
-- What filter relationships control in SQL terms:
SELECT
  SUM(price) as revenue
FROM olist_order_items_dataset oi
JOIN olist_orders_dataset o ON oi.order_id = o.order_id
WHERE 1=1
  AND o.order_date >= '2017-10-01'  -- Date filter (applies to all)
  AND o.customer_state = 'SP'       -- State filter (selective scope)
  AND oi.product_category = 'electronics'  -- Category filter (selective scope)
```

**Looker Filter Scope:** Controls which charts include each WHERE condition

### Week 6: Subqueries and Filtering Context

```sql
-- Chart with independent filter (chart-level)
SELECT state, SUM(price)
FROM orders
WHERE status = 'delivered'  -- Chart-level filter (not from control)
GROUP BY state;

-- Nested in larger dashboard context
```

**Looker Equivalent:** Chart filter + control filters combine

### Week 8: Complex Filtering Logic

```sql
-- Include/Exclude patterns
WHERE customer_state NOT IN ('test', 'invalid')  -- Exclude filter
  AND product_category IN ('electronics', 'fashion')  -- Include filter
```

**Looker Exclude Filters:** Same concept, visual interface

---

## Key Takeaways

### What You Learned
1. ✅ Filter scope controls which charts are affected by controls
2. ✅ Three scope levels: Report, Page, Chart
3. ✅ Cross-filtering enables click-to-explore interactions
4. ✅ Include/Exclude modes for different filtering logic
5. ✅ Filter relationships optimize dashboard performance
6. ✅ Hierarchical filters enable drill-down analysis

### What's Next
In the next lesson, we'll explore **conditional formatting** to highlight important data patterns and exceptions automatically.

### Skills Building Progression
```
Week 14 Part 1: Interactive Controls ✓
Week 14 Part 2: Filter Relationships ✓
         ↓
Week 14 Part 3: Conditional Formatting (Next)
         ↓
Week 14 Part 4: Time Series Best Practices
```

---

## Quick Reference Card

### Filter Scope Decision Matrix

| Chart Purpose | Date Filter | State Filter | Category Filter |
|--------------|-------------|--------------|-----------------|
| Company KPIs | ✓ Apply | ✗ Exclude | ✗ Exclude |
| Regional Analysis | ✓ Apply | ✓ Apply | ✗ Exclude |
| Product Analysis | ✓ Apply | ✗ Exclude | ✓ Apply |
| Drill-Down Details | ✓ Apply | ✓ Apply | ✓ Apply |

### Common Scope Patterns

```
Pattern: Global + Selective
─────────────────────────────────────
📅 Date Range → [All charts]
🗺️ State Filter → [Regional charts only]
🛍️ Category Filter → [Product charts only]

Pattern: Hierarchical
─────────────────────────────────────
📅 Date → [All]
  └→ 🌍 Region → [All + State control]
      └→ 🗺️ State → [All + City control]
          └→ 🏙️ City → [Charts only]

Pattern: Comparison Sections
─────────────────────────────────────
📅 Date → [Shared by both sections]
Section A: filter = "2017" (fixed)
Section B: filter = "2018" (fixed)
```

---

## Questions to Test Your Understanding

1. Why would you exclude a "Total Company Revenue" chart from a state filter?
2. What is the difference between chart-level and control-level filtering?
3. When would you use "Exclude" mode instead of "Include" mode for a filter?
4. How does cross-filtering enhance dashboard interactivity?
5. What causes slow filter performance and how can you fix it?

**Answers at the end of lecture notes**

---

## Additional Resources

- **Looker Studio Help:** [Filter Controls](https://support.google.com/looker-studio/answer/6291066)
- **Video Tutorial:** Advanced Filter Relationships (Week 14 resources)
- **Case Study:** Dashboard Filter Architecture (resources/filter_patterns.md)

---

## Answers to Questions

1. To maintain **company-wide context** while allowing regional drill-down—executives need both total and filtered views
2. **Chart-level filters** are hidden settings that always apply; **control-level filters** are visible and interactive for users
3. Use **Exclude mode** when it's easier to specify what to remove (e.g., "all states except test regions") rather than list everything to keep
4. **Cross-filtering** lets users click chart elements to drill down, making exploration intuitive without needing separate filter controls
5. Slow performance caused by large datasets or complex queries; fix with **backend filters**, **data extracts**, or **pre-aggregated views**

---

**Next Lecture:** 03_conditional_formatting_rules.md
