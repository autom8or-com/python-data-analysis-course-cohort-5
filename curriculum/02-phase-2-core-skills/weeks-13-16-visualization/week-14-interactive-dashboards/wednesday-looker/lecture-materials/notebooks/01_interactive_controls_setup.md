# Interactive Controls Setup in Google Looker Studio

## Week 14 - Wednesday Session - Part 1

### Duration: 15-20 minutes

---

## What Are Interactive Controls?

**Interactive Controls** in Looker Studio are user interface elements that allow dashboard viewers to filter and manipulate data without editing the report. They transform static dashboards into dynamic, self-service analytics tools.

### Why Controls Matter

Think back to your SQL and Python work:

**SQL Approach:**
```sql
-- To view different time periods, you had to manually change dates
SELECT customer_state, SUM(price) as revenue
FROM olist_orders_dataset
WHERE order_date BETWEEN '2017-01-01' AND '2017-12-31';  -- Hard-coded dates
GROUP BY customer_state;
```

**Python Approach:**
```python
# Similar issue - filters hard-coded in code
filtered_df = df[df['order_date'] >= '2017-01-01']
filtered_df = filtered_df[filtered_df['order_date'] <= '2017-12-31']
```

**Looker Studio with Controls:**
- Business users select dates from a calendar picker
- No code changes needed
- Instant results
- Everyone can explore data independently

---

## Core Control Types

### 1. Date Range Control
**Purpose:** Filter data by time periods

**Use Cases:**
- "Show me sales for last quarter"
- "Compare this month vs last month"
- "View year-to-date performance"

**Business Context (Nigerian E-commerce):**
Imagine stakeholders asking: "How did we perform during the December holiday shopping season?" Instead of running a new SQL query, they simply select December dates.

### 2. Drop-down List
**Purpose:** Filter by categorical dimensions

**Use Cases:**
- Select product category
- Choose customer state
- Pick payment type

**SQL Equivalent:**
```sql
WHERE product_category IN ('electronics', 'fashion')  -- Hard-coded
```
**Looker Equivalent:** User selects from dropdown, filter applies automatically

### 3. Slider Control
**Purpose:** Filter by numeric ranges

**Use Cases:**
- Price range selection
- Order value thresholds
- Customer lifetime value bands

### 4. Input Box
**Purpose:** Text search filtering

**Use Cases:**
- Search for specific customer ID
- Filter by order number
- Find product name

### 5. Fixed-Size List
**Purpose:** Multiple visible selection options

**Use Cases:**
- Show all states with checkboxes
- Multi-select product categories
- Toggle multiple customer segments

### 6. Advanced Filter (Custom)
**Purpose:** Complex filtering with multiple conditions

**Use Cases:**
- Combine date + category + region
- Advanced business logic
- Power user requirements

---

## Control vs Filter: Key Distinction

| Feature | Control | Filter |
|---------|---------|---------|
| **Visibility** | Visible to viewers | Hidden in chart settings |
| **User Access** | Viewers can change | Only editors can modify |
| **Purpose** | Interactive exploration | Fixed data restrictions |
| **Example** | Date picker on dashboard | Backend filter: status = 'delivered' |

**Key Insight:** Controls empower users; filters enforce data boundaries.

---

## Setting Up Your First Date Range Control

### Step 1: Insert the Control

1. Open your Week 13 dashboard in **Edit Mode**
2. Click **"Add a control"** in the toolbar
   - Or: Menu → Insert → Date Range
3. Click anywhere on canvas to place it
4. Position it prominently (typically top-left of dashboard)

**Screenshot Description:**
```
[Toolbar showing: Add Chart | Add Control* | Add Text | Add Image]
                                  ↑
                            Click here
```

### Step 2: Configure Data Source

The right panel opens with control settings:

```
Data
─────────────────
📊 Data Source: [Select data source]
   → Choose: olist_orders_dataset

📅 Dimension: [Select date field]
   → Choose: order_purchase_timestamp
```

**Why This Matters:**
- **Data Source:** Which dataset to filter
- **Dimension:** Which date field controls the time range
- **Connection:** Links to charts using the same data source

### Step 3: Set Default Date Range

```
Default Date Range
─────────────────
⚪ Auto
⚪ Custom
⚪ Advanced

Select: Custom
├── Type: Last 90 days
├── Start: [Auto-calculated]
└── End: Today
```

**Business Justification:**
- **Last 90 days:** Most relevant recent performance
- **Rolling range:** Automatically updates daily
- **No manual updates:** Dashboard stays current

**Alternative Options:**
- **Last 7 days:** Weekly dashboards
- **Last 30 days:** Monthly reporting
- **This year:** Annual performance tracking
- **Custom dates:** Specific campaign periods

### Step 4: Enable Date Comparison (Optional)

```
☑ Allow date comparisons
```

This adds a second date range selector so users can compare:
- This month vs last month
- This quarter vs same quarter last year
- Current week vs previous week

**SQL Equivalent:**
```sql
-- Without comparison
SELECT DATE_TRUNC('month', order_date) as month,
       SUM(price) as revenue
FROM orders
WHERE order_date >= CURRENT_DATE - INTERVAL '90 days'
GROUP BY month;

-- With comparison (requires UNION or window functions)
-- Much more complex!
```

**Looker Benefit:** Built-in comparison capability with checkbox.

### Step 5: Style Your Control

Switch to **Style** tab in right panel:

```
Style
─────────────────
📅 Type
   ⚪ Compact (calendar icon, less space)
   ⚪ Simple (date text boxes)
   ⚪ Advanced (full calendar view)

🎨 Appearance
   ├── Font: Google Sans
   ├── Size: 12
   ├── Color: #333333
   └── Background: #FFFFFF

📐 Border
   ├── Color: #E0E0E0
   ├── Weight: 1px
   └── Radius: 4px (rounded corners)
```

**Best Practice:** Use "Compact" for space efficiency on busy dashboards.

---

## Creating a Drop-down Filter

### Step 1: Add Control

1. Click **"Add a control"** → **"Drop-down list"**
2. Place it below your date range control
3. Control properties panel opens

### Step 2: Configure the Filter

```
Data
─────────────────
📊 Data Source: olist_orders_dataset

📋 Control field: [Select dimension]
   → Choose: customer_state

🔽 Control Type: Drop-down list

⚙️ Options
   ☐ Allow multiple selections
   ☑ Include "All" option (shows unfiltered data)
   ☐ Require a selection
```

**Configuration Decisions:**

**Single vs Multiple Selection:**
- **Single:** "Show me only São Paulo"
- **Multiple:** "Show me São Paulo AND Rio de Janeiro"

**Include "All" Option:**
- ✅ Recommended for flexibility
- Lets users view all states or drill into specific ones

### Step 3: Set Default Selection

```
Default Selection
─────────────────
⚪ All
⚪ First value
⚪ Custom: [Select state]

Recommended: All
```

**Why "All" Default:**
- Dashboard loads with full data picture
- Users start broad, then drill down
- Prevents confusion about missing data

### Step 4: Sort and Limit Values

```
Metric for Sorting
─────────────────
📊 Metric: Record Count (descending)
   → Shows states with most orders first

Or:
📊 Metric: SUM(price) (descending)
   → Shows highest revenue states first
```

**Business Context:**
Sort by revenue to highlight top-performing states (Lagos, Abuja, etc. in Nigerian context; SP, RJ in Brazilian Olist data).

### Step 5: Style the Drop-down

```
Style
─────────────────
🎨 Control
   ├── Font: Google Sans
   ├── Size: 14
   ├── Text Color: #333333
   └── Background: #F9F9F9

📋 Label
   ☑ Show label
   ├── Text: "Select State"
   ├── Position: Top
   └── Font: Bold, 12px

🔽 Dropdown
   ├── Width: 200px
   ├── Max items shown: 10
   └── Search box: ☑ (for long lists)
```

**Pro Tip:** Enable search box when you have >10 options (like all Nigerian states or Brazilian states).

---

## Creating a Slider Control for Price Range

### Step 1: Insert Slider

1. **Add a control** → **"Slider"**
2. Position it in your controls section

### Step 2: Configure Range

```
Data
─────────────────
📊 Data Source: olist_order_items_dataset

📐 Control field: price

🎚️ Range Settings
   ├── Minimum: [Auto-detect or set: 0]
   ├── Maximum: [Auto-detect or set: 1000]
   ├── Step: 10 (increment size)
   └── Default: Full range
```

**Business Use Case:**
"Show me orders between ₦5,000 and ₦50,000" (or R$50-R$500 for Olist data)

### Step 3: Style the Slider

```
Style
─────────────────
📊 Slider
   ├── Track color: #CCCCCC
   ├── Fill color: #4285F4 (Google blue)
   ├── Handle color: #FFFFFF
   └── Handle border: #4285F4

🏷️ Value Display
   ☑ Show current values
   ├── Prefix: R$ (Brazilian Real)
   └── Decimal places: 2
```

---

## Connecting Controls to Your Data Story

### The Customer Analytics Dashboard Scenario

**Business Question:** "How did customer behavior in São Paulo change during Q4 2017?"

**Controls Needed:**
1. **Date Range:** October-December 2017
2. **State Filter:** São Paulo
3. **Category Filter:** All categories (or specific focus)

**Without Controls:** Analyst runs 10 different SQL queries
**With Controls:** Stakeholder selects filters in 30 seconds

### Control Placement Strategy

```
┌─────────────────────────────────────────────────┐
│  🎛️ CONTROLS SECTION (Top 10% of dashboard)     │
│  [📅 Last 90 Days ▼] [🗺️ All States ▼] [🛍️ All Categories ▼] │
├─────────────────────────────────────────────────┤
│  📊 KPI SCORECARDS                              │
│  [Total Revenue] [Orders] [AOV] [Customers]     │
├─────────────────────────────────────────────────┤
│  📈 MAIN VISUALIZATIONS                         │
│  Revenue Trend | Top Products | State Map       │
└─────────────────────────────────────────────────┘
```

**Layout Principles:**
- **Controls at top:** First thing users see
- **Left to right priority:** Date → Geography → Category
- **Consistent alignment:** Visual organization

---

## Advanced Control: Input Box for Customer Search

### Use Case
Power users need to analyze specific customers by ID or email.

### Setup

```
Data
─────────────────
📊 Data Source: olist_customers_dataset
📝 Control field: customer_unique_id
🔤 Control Type: Input box

⚙️ Settings
   ├── Placeholder text: "Enter customer ID..."
   ├── Match type: Contains (partial match)
   └── Case sensitive: ☐ No
```

**When to Use:**
- Support teams investigating specific orders
- Sales teams looking up customer history
- Account managers reviewing client data

**When NOT to Use:**
- General exploration (too specific)
- Executive dashboards (not user-friendly)

---

## Practical Exercise: Add Controls to Your Dashboard

### Task 1: Date Range Control (5 minutes)
1. Open your Week 13 sales dashboard
2. Add a date range control
3. Set default: Last 90 days
4. Position it top-left
5. Switch to View Mode and test

**Success Check:**
- Calendar appears when clicked
- Charts update when date changes
- Default shows last 90 days of data

### Task 2: State Filter (5 minutes)
1. Add drop-down list control
2. Configure for `customer_state` field
3. Enable "All" option
4. Sort by revenue (descending)
5. Test filtering

**Success Check:**
- See all Brazilian states listed
- Selecting one state filters all charts
- "All" option shows complete dataset

### Task 3: Category Filter (5 minutes)
1. Add another drop-down list
2. Configure for `product_category_name` field
3. Allow multiple selections
4. Add search box (many categories)
5. Test combinations

**Success Check:**
- Can select multiple categories
- Search box helps find specific categories
- Combining state + category filters both work

---

## Common Control Issues and Solutions

### Issue 1: Control Doesn't Filter Charts
**Symptom:** Changing control has no effect

**Causes & Solutions:**
- ❌ Different data sources
  - ✅ Ensure control and charts use same data source
- ❌ Wrong dimension selected
  - ✅ Verify dimension name matches across sources
- ❌ Chart has conflicting filter
  - ✅ Check chart-level filters don't override control

### Issue 2: Control Shows "No Data"
**Symptom:** Control is empty or shows error

**Causes & Solutions:**
- ❌ Connection to database failed
  - ✅ Check data source credentials
- ❌ Dimension has no values
  - ✅ Verify data exists in that field
- ❌ Pre-filter too restrictive
  - ✅ Remove chart filters temporarily

### Issue 3: Too Many Options in Drop-down
**Symptom:** Drop-down has hundreds of items

**Causes & Solutions:**
- ❌ Using high-cardinality field (like order_id)
  - ✅ Use aggregated dimensions instead
- ❌ Need search functionality
  - ✅ Enable search box in Style settings
- ❌ Consider different control type
  - ✅ Use input box for exact searches

### Issue 4: Date Range Slow to Load
**Symptom:** Dashboard lags when changing dates

**Causes & Solutions:**
- ❌ Large dataset being processed
  - ✅ Add backend filter for max date range (e.g., last 2 years only)
- ❌ Too many charts refreshing
  - ✅ Consider data source optimization
- ❌ Complex calculated fields
  - ✅ Pre-calculate in SQL view

---

## Connection to Prior Learning

### Week 2: SQL WHERE Clauses
```sql
-- SQL version of what controls do
WHERE order_date >= '2017-10-01'
  AND order_date <= '2017-12-31'
  AND customer_state IN ('SP', 'RJ')
  AND product_category = 'electronics';
```

**Looker Controls:** Visual interface for these exact filters.

### Week 5: Date Filtering and Aggregation
```sql
-- Remember date functions?
WHERE order_date >= CURRENT_DATE - INTERVAL '90 days'
```

**Looker "Last 90 Days" Control:** Implements this logic automatically.

### Week 8: Multiple Conditions
```sql
-- Complex AND/OR logic
WHERE (state = 'SP' OR state = 'RJ')
  AND price BETWEEN 50 AND 500
  AND category IN ('electronics', 'home')
```

**Multiple Controls:** Each adds an AND condition; multi-select adds OR within dimension.

---

## Key Takeaways

### What You Learned
1. ✅ Controls transform dashboards from static to interactive
2. ✅ Date range control is most essential for time-based analysis
3. ✅ Drop-down lists enable categorical filtering
4. ✅ Sliders work well for numeric ranges
5. ✅ Controls replace hard-coded SQL WHERE clauses
6. ✅ Proper placement and styling improve user experience

### What's Next
In the next lesson, we'll configure **filter relationships** to control how filters interact across charts and pages.

### Skills Building Progression
```
Week 14 Part 1: Interactive Controls ✓
         ↓
Week 14 Part 2: Filter Relationships (Next)
         ↓
Week 14 Part 3: Conditional Formatting
         ↓
Week 14 Part 4: Time Series Best Practices
```

---

## Quick Reference Card

### Essential Controls Checklist
| Control Type | Best For | Required Setting |
|-------------|----------|------------------|
| Date Range | Time filtering | Set default to rolling period |
| Drop-down | Categories (states, products) | Enable "All" option |
| Slider | Price, quantity ranges | Set sensible min/max |
| Input Box | Specific ID search | Use "Contains" match type |
| Fixed List | 2-8 visible options | Multi-select checkbox |

### Common Control Configurations
| Business Need | Control Setup |
|--------------|---------------|
| "Last quarter performance" | Date range: Last 90 days |
| "Top 3 states" | Drop-down: Sort by revenue DESC, Limit 3 |
| "Orders $100-$500" | Slider: price field, Range 100-500 |
| "Find customer X" | Input box: customer_id, Contains match |

---

## Questions to Test Your Understanding

1. What is the main difference between a control and a chart filter?
2. Why would you choose a drop-down over a slider control?
3. What does "rolling date range" mean and why is it useful?
4. If a control doesn't filter your charts, what should you check first?
5. When should you enable "Allow multiple selections" on a drop-down?

**Answers at the end of lecture notes**

---

## Additional Resources

- **Looker Studio Help:** [Controls Overview](https://support.google.com/looker-studio/answer/6291066)
- **Video Tutorial:** Adding Interactive Controls (Week 14 resources folder)
- **Cheat Sheet:** Control Types Quick Reference (resources/)

---

## Answers to Questions

1. **Controls** are visible to viewers and interactive; **chart filters** are hidden in settings and only editors can change them
2. **Drop-down** for categorical data (states, categories); **slider** for continuous numeric ranges (price, quantity)
3. **Rolling date range** calculates relative to today (e.g., "Last 30 days" always shows the most recent 30 days automatically)
4. Check if control and charts use the **same data source** and **same dimension names**
5. Enable multiple selections when users need to analyze several categories together (e.g., "Show me SP, RJ, and MG states combined")

---

**Next Lecture:** 02_filter_relationships_configuration.md
