# Interactive Controls Configuration Guide

## Quick Reference for Looker Studio Controls

**Last Updated:** Week 14, January 2026

---

## Control Types Overview

| Control Type | Icon | Best Use Case | Max Recommended Items | Multi-Select Support |
|--------------|------|---------------|----------------------|---------------------|
| **Date Range** | 📅 | Time-based filtering | N/A | N/A |
| **Drop-down List** | 🔽 | Categories, states, products | 50 items | ✅ Yes |
| **Fixed-Size List** | ☑️ | 2-10 visible options | 10 items | ✅ Yes |
| **Slider** | 🎚️ | Numeric ranges (price, quantity) | N/A | N/A |
| **Input Box** | 🔤 | Exact search (IDs, names) | Unlimited | ❌ No |
| **Checkbox** | ☑️ | Boolean filters (yes/no, active) | 5 items | ✅ Yes |
| **Advanced Filter** | ⚙️ | Power users, complex conditions | N/A | ✅ Yes |

---

## Date Range Control

### Configuration Settings

```
DATA TAB
├── Date Dimension: [Select date field]
│   Example: order_purchase_timestamp
│
├── Auto Date Range
│   ⚪ Auto (based on data)
│   ⚪ Custom (set default)
│   └── Options:
│       • Today
│       • Yesterday
│       • Last 7 days
│       • Last 28 days
│       • Last 30 days
│       • Last 90 days
│       • Last 12 months
│       • This week
│       • This month
│       • This quarter
│       • This year
│       • Previous week
│       • Previous month
│       • Previous quarter
│       • Previous year
│       • Custom dates
│
└── Comparison Date Range
    ☐ Allow date comparisons
    └── If enabled, adds second range picker
```

### Common Configurations

| Use Case | Setting | Justification |
|----------|---------|---------------|
| **Daily Operations Dashboard** | Last 7 days | Recent trends, daily monitoring |
| **Monthly Business Review** | This month | Current period performance |
| **Executive Summary** | Last 90 days | Quarterly overview |
| **Year-End Reports** | This year | Annual performance |
| **Campaign Analysis** | Custom dates | Specific campaign period |
| **Trend Analysis** | Last 12 months | Long-term patterns |

### Style Options

```
STYLE TAB
├── Control Display Type
│   ⚪ Slider (default, compact)
│   ⚪ Simple (text boxes)
│   ⚪ Advanced (full calendar)
│
├── Comparison Settings (if enabled)
│   ☐ Show comparison metrics in charts
│   ☐ Show comparison date range selector
│
└── Appearance
    ├── Background color: #FFFFFF
    ├── Border color: #E0E0E0
    ├── Border radius: 4px
    └── Font: Google Sans, 12px
```

**Recommendation:** Use **Slider** for most dashboards (space-efficient, intuitive).

---

## Drop-down List Control

### Configuration Settings

```
DATA TAB
├── Control Field: [Select dimension]
│   Examples: customer_state, product_category, region
│
├── Metric (for sorting/filtering)
│   • Record Count (default)
│   • SUM(revenue)
│   • Custom metric
│
├── Sort
│   ⚪ Ascending (A-Z, 1-9)
│   ⚪ Descending (Z-A, 9-1)
│   └── By: Dimension name OR Metric value
│
├── Limit Items
│   • Show top: [Number] items
│   • Example: Top 10 states by revenue
│
└── Default Selection
    ⚪ All
    ⚪ First value
    ⚪ Custom: [Select specific value]
```

### Multi-Selection Settings

```
STYLE TAB
├── Selection Options
│   ☐ Allow multiple selections
│   ☐ Include "All" option (recommended)
│   ☐ Require a selection (forces choice)
│
└── Display Options
    ☐ Show metric values (e.g., "São Paulo (15,342)")
    ☐ Enable search box (for >10 items)
    ├── Placeholder text: "Search..."
    └── Max visible items: 10
```

### Common Configurations

| Dimension Type | Configuration | Example |
|----------------|---------------|---------|
| **Geographic** (States) | Multi-select enabled, Sort by revenue DESC | "SP, RJ, MG" |
| **Product Category** | Multi-select enabled, Include "All", Search box | "Electronics, Fashion" |
| **Delivery Status** | Multi-select enabled (3-4 options) | "On Time, Late" |
| **Payment Type** | Single select, Show metric values | "Credit Card (45%)" |
| **Order Size** | Single select, Categories | "Small, Medium, Large" |

### UX Best Practices

✅ **Do:**
- Enable "Include All" option for easy reset
- Sort by business importance (revenue, count)
- Use search box when >10 options
- Show metric values for context

❌ **Don't:**
- Use dropdown for >50 items (consider filter or search instead)
- Use for high-cardinality fields (like order_id)
- Disable "All" option without good reason
- Use multi-select for mutually exclusive options

---

## Fixed-Size List Control

### Configuration Settings

```
DATA TAB
├── Control Field: [Select dimension]
│   Best for: 2-10 items
│
├── Metric: [For sorting]
│   Display next to each item
│
├── Max Items: [Number to show]
│   Recommended: 5-10
│
└── Sort: Descending by metric (typical)
```

```
STYLE TAB
├── Selection
│   ☐ Allow multiple selections
│   ☐ Show metric values
│
├── Layout
│   ⚪ Vertical (stacked)
│   ⚪ Horizontal (side-by-side)
│   └── Height/Width: Auto or Custom
│
└── Appearance
    ├── Font size: 12-14px
    ├── Item padding: 8px
    └── Checkbox style: Default or Custom
```

### When to Use Fixed-Size vs. Dropdown

| Scenario | Use Fixed-Size List | Use Dropdown |
|----------|---------------------|--------------|
| 2-8 options | ✅ Yes | Either works |
| 10-50 options | ❌ No | ✅ Yes |
| Need to see all options at once | ✅ Yes | ❌ No |
| Limited dashboard space | ❌ No | ✅ Yes |
| Top N performers (sorted) | ✅ Yes | Either works |
| Alphabetical categories | Either works | ✅ Yes |

**Example Use Case:** Top 5 states by revenue (visible, ranked, metrics shown)

---

## Slider Control

### Configuration Settings

```
DATA TAB
├── Control Field: [Select numeric field]
│   Examples: price, freight_value, order_quantity
│
├── Range Settings
│   ├── Minimum Value
│   │   ⚪ Auto-detect from data
│   │   ⚪ Custom: [Value]
│   │
│   ├── Maximum Value
│   │   ⚪ Auto-detect from data
│   │   ⚪ Custom: [Value]
│   │
│   ├── Step Size: [Increment]
│   │   Example: 10 (for prices: 0, 10, 20, 30...)
│   │
│   └── Default Range
│       ⚪ Full range (min to max)
│       ⚪ Custom: [Start] to [End]
```

```
STYLE TAB
├── Slider Appearance
│   ├── Track color: #CCCCCC
│   ├── Fill color: #4285F4
│   ├── Handle color: #FFFFFF
│   └── Handle border: #4285F4
│
├── Value Display
│   ☐ Show current values
│   ├── Prefix: $ or ₦ or R$
│   ├── Suffix: units, kg, etc.
│   └── Decimal places: 0, 1, 2
│
└── Layout
    ├── Width: 200-400px (recommended)
    └── Orientation: Horizontal (default)
```

### Common Slider Configurations

| Use Case | Range | Step | Prefix/Suffix |
|----------|-------|------|---------------|
| **Product Price Filter** | 0 - 1000 | 10 | R$ or $ |
| **Order Quantity** | 1 - 100 | 1 | units |
| **Weight Filter** | 0 - 50 | 0.5 | kg |
| **Delivery Days** | 0 - 30 | 1 | days |
| **Discount Percentage** | 0 - 100 | 5 | % |

**Pro Tip:** Set max value to 95th percentile, not absolute max, to avoid extreme outliers.

---

## Input Box Control

### Configuration Settings

```
DATA TAB
├── Control Field: [Select dimension]
│   Best for: customer_id, order_id, product_name
│
└── Match Type
    ⚪ Exact match (case-sensitive)
    ⚪ Contains (partial match)
    ⚪ Starts with
    ⚪ Ends with
    ⚪ Regular expression (advanced)
```

```
STYLE TAB
├── Input Box
│   ├── Placeholder text: "Enter customer ID..."
│   ├── Width: 200-300px
│   └── Case sensitive: ☐ (usually unchecked)
│
└── Label
    ├── Text: "Search by Customer"
    ├── Position: Above or Left
    └── Font: 12-14px
```

### Best Practices

✅ **Use for:**
- Customer support dashboards (search by ID)
- Power users who know exact values
- Exploratory analysis (search product names)

❌ **Don't use for:**
- General filtering (use dropdown instead)
- Executive dashboards (too technical)
- Fields with inconsistent formatting

**Example:** Support team searching `customer_id: "8abc-12345"` to view customer history.

---

## Advanced Filter Control

### When to Use

The **Advanced Filter** control allows users to create complex filter expressions:

```
Examples:
• customer_state = "SP" AND order_value > 100
• product_category IN ("electronics", "furniture") OR delivery_status = "Late"
• order_date >= TODAY() - 30
```

**Target Users:** Data analysts, power users comfortable with filter syntax.

**For General Users:** Use individual dropdown/slider controls instead.

---

## Control Interaction and Scope

### Data Source Matching

**Critical Rule:** Controls only affect charts using the **same data source**.

```
✅ Correct Setup:
Control Data Source: olist_orders_dataset
Chart 1 Data Source: olist_orders_dataset  ← Filtered
Chart 2 Data Source: olist_orders_dataset  ← Filtered
Chart 3 Data Source: olist_products_dataset ← NOT filtered

❌ Common Mistake:
Using blended data sources with controls (limited functionality)
```

### Filter Scope Options

Some controls allow setting scope:

```
Apply filter to:
☑ All charts (default)
☐ Selected charts only
   └── Choose: Chart 1, Chart 2, Chart 4
```

**Use Case:** Date range should filter all charts, but state filter only affects geographic charts.

---

## Layout and Positioning Best Practices

### Standard Dashboard Layout

```
┌─────────────────────────────────────────────────────┐
│ DASHBOARD TITLE                                     │
├─────────────────────────────────────────────────────┤
│ ┌─────────────────────────────────────────────────┐ │
│ │ 📅 Date Range: [Last 90 Days ─────────────]     │ │
│ └─────────────────────────────────────────────────┘ │
│                                                     │
│ ┌─────────┐ ┌─────────┐ ┌─────────┐ ┌─────────┐   │
│ │Region ▼ │ │Category▼│ │Status ▼ │ │Price 🎚 │   │
│ └─────────┘ └─────────┘ └─────────┘ └─────────┘   │
│                                                     │
│ ┌───────────────────────────────────────────────┐   │
│ │ CHARTS AND VISUALIZATIONS                     │   │
│ │                                               │   │
│ └───────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────┘
```

### Priority Order (Left to Right)

1. **Date/Time** (most universal filter)
2. **Geography** (state, region, country)
3. **Category** (product, customer segment)
4. **Status** (order status, delivery status)
5. **Numeric** (price range, quantity)
6. **Search** (optional, for power users)

### Grouping Strategy

**Option 1: Horizontal Bar (Top)**
- Best for: 3-6 controls
- Space efficient
- Standard pattern users expect

**Option 2: Left Sidebar**
- Best for: 6+ controls
- Vertical stacking
- More room for labels

**Option 3: Dedicated Control Panel**
- Best for: Interactive dashboards with many filters
- Grouped in colored background box
- Clear visual separation

---

## Accessibility and UX Guidelines

### Color Coding

```
Control Panel Background: Light neutral (#F5F5F5 to #FAFAFA)
Active Selection: Brand blue (#4285F4)
Disabled State: Light gray (#E0E0E0)
Labels: Dark gray (#333333)
```

### Label Best Practices

✅ **Clear Labels:**
- "Select State" (not just "State")
- "Date Range" (not "Dates")
- "Price Range (R$)" (include currency)

❌ **Unclear Labels:**
- "Filter" (filter what?)
- "Options" (too generic)
- Abbreviations users won't understand

### Multi-Select Instructions

Add a text element near controls:
```
"Tip: Hold Ctrl (Windows) or Cmd (Mac) to select multiple options"
```

Or use Fixed-Size List (checkboxes) for clearer multi-select UX.

---

## Testing Checklist

Before publishing your dashboard, test:

```
☐ All controls affect correct charts (same data source)
☐ "All" option is available for easy reset
☐ Default values make sense (not overly filtered)
☐ Multi-select works as expected (Ctrl/Cmd + click)
☐ Date range covers all data in dataset
☐ Slider min/max values are appropriate (not extreme outliers)
☐ Search box uses "Contains" for partial matches
☐ Controls are visually aligned and organized
☐ Labels are clear and descriptive
☐ Mobile view: Controls are usable on small screens
☐ Performance: Filters apply quickly (<2 seconds)
```

---

## Common Mistakes and Solutions

| Mistake | Problem | Solution |
|---------|---------|----------|
| Too many controls | Decision fatigue | Limit to 5-7 key filters |
| No "All" option | Users can't reset | Always include "All" |
| Wrong data source | Filters don't work | Match control to chart data source |
| High-cardinality dropdown | 500+ items in dropdown | Use search box or filter data |
| No default selected | Dashboard loads blank | Set sensible defaults |
| Controls at bottom | Users don't see them | Place at top or left |
| Tiny slider on mobile | Unusable on phone | Test mobile view, increase size |
| Confusing labels | Users don't understand | User-test with actual stakeholders |

---

## Keyboard Shortcuts (View Mode)

| Action | Windows | Mac |
|--------|---------|-----|
| Multi-select in dropdown | Ctrl + Click | Cmd + Click |
| Select range in list | Shift + Click | Shift + Click |
| Clear selection | Click "All" | Click "All" |
| Tab through controls | Tab | Tab |

---

## Performance Optimization

### For Large Datasets

1. **Limit dropdown items:**
   - Show top 20 by default
   - Add "Show more" option

2. **Use server-side filtering:**
   - Add WHERE clause in data source query
   - Pre-filter to last 2 years of data

3. **Avoid real-time updates:**
   - Use cached data sources
   - Schedule daily refreshes

4. **Optimize control placement:**
   - Load essential controls first
   - Lazy-load advanced filters

---

## Quick Decision Tree

**"What control should I use?"**

```
Is it a date/time field?
├─ Yes → DATE RANGE CONTROL
└─ No
   │
   Is it numeric (price, quantity)?
   ├─ Yes → SLIDER
   └─ No
      │
      Is it a known list of categories?
      ├─ Yes
      │  └─ How many options?
      │     ├─ 2-8 options → FIXED-SIZE LIST
      │     └─ 9+ options → DROP-DOWN LIST
      └─ No (free-form text search)
         └─ INPUT BOX
```

---

## Version History

- **Week 14 (Jan 2026):** Initial version for Cohort 5
- **Updates:** Control configurations for Olist e-commerce dataset

---

## See Also

- Conditional Formatting Patterns Guide
- Week 13: Calculated Fields Reference
- Week 15: Advanced Dashboard Design Patterns
