# Conditional Formatting and Dynamic Styling

## Week 14 - Wednesday Session - Part 3

### Duration: 20 minutes

---

## What Is Conditional Formatting?

**Conditional formatting** automatically changes the visual appearance of data based on its values. It highlights patterns, exceptions, and important insights without manual intervention.

### Why Conditional Formatting Matters

**Without Conditional Formatting:**
```
Revenue by State (Plain Table)
─────────────────────────────────
State    |  Revenue
─────────────────────────────────
SP       |  ₦45,200,000
RJ       |  ₦38,500,000
MG       |  ₦22,100,000
BA       |  ₦15,300,000
PR       |  ₦12,800,000
```

**With Conditional Formatting:**
```
Revenue by State (Highlighted)
─────────────────────────────────
State    |  Revenue
─────────────────────────────────
SP       |  ₦45,200,000  🟢 (top performer—green)
RJ       |  ₦38,500,000  🟢 (strong—green)
MG       |  ₦22,100,000  🟡 (average—yellow)
BA       |  ₦15,300,000  🟠 (below average—orange)
PR       |  ₦12,800,000  🔴 (attention needed—red)
```

**Insight at a glance:** SP and RJ are your top markets; PR needs attention.

---

## Connection to Prior Learning

### Week 3: SQL CASE Statements for Categorization

Remember creating categories in SQL?

```sql
-- SQL conditional logic
SELECT
  product_category,
  revenue,
  CASE
    WHEN revenue > 100000 THEN 'High Performer'
    WHEN revenue > 50000 THEN 'Average'
    ELSE 'Needs Attention'
  END as performance_tier
FROM products;
```

**Conditional formatting** applies this same logic to **visual styling** instead of creating new columns.

### Python: Color Coding in DataFrames

```python
# Python equivalent (pandas styling)
def color_revenue(val):
    if val > 100000:
        return 'background-color: green'
    elif val > 50000:
        return 'background-color: yellow'
    else:
        return 'background-color: red'

df.style.applymap(color_revenue)
```

**Looker Studio:** Same concept, point-and-click interface.

---

## Part 1: Types of Conditional Formatting

### 1. Color Scales (Heat Maps)

**Purpose:** Show value ranges with color gradients

**Best for:**
- Revenue by state (high to low)
- Sales performance metrics
- Inventory levels
- Customer engagement scores

**Example:**
```
Low Revenue ◀────────▶ High Revenue
  🔴 Red  →  🟡 Yellow  →  🟢 Green
```

### 2. Thresholds (Rules-Based)

**Purpose:** Highlight values meeting specific conditions

**Best for:**
- Flag low-stock items (< 50 units)
- Highlight late deliveries (> 5 days)
- Mark high-value orders (> ₦100,000)
- Identify underperforming regions (< target)

**Example:**
```
If delivery_days > 7: Red background
If delivery_days 4-7: Yellow background
If delivery_days < 4: Green background
```

### 3. Progress Bars

**Purpose:** Visualize metric completion against goal

**Best for:**
- Sales vs target
- Order fulfillment rate
- Campaign progress
- KPI achievement

**Example:**
```
Target: ₦100M | Actual: ₦75M
[████████████████░░░░] 75%
```

### 4. Data Bars (In-Cell Bars)

**Purpose:** Mini bar charts within table cells

**Best for:**
- Comparing values in tables
- Quick visual ranking
- Space-efficient visualization

**Example:**
```
State    | Revenue              | Visual Bar
─────────────────────────────────────────────
SP       | ₦45M  [████████████] ▓▓▓▓▓▓▓▓▓▓
RJ       | ₦38M  [██████████  ] ▓▓▓▓▓▓▓▓
MG       | ₦22M  [██████      ] ▓▓▓▓▓
```

---

## Part 2: Setting Up Color Scales

### Scenario: Revenue by State Heat Map

**Business Goal:** Quickly identify high-revenue and low-revenue states in a table.

### Step 1: Create a Table Chart

1. Insert → Table
2. Add dimensions: `customer_state`
3. Add metric: `SUM(price)` as "Revenue"
4. Sort by Revenue (descending)

### Step 2: Access Conditional Formatting

1. Select the table chart
2. Right panel → **Style** tab
3. Scroll to **"Color by value"** or **"Conditional formatting"** section
4. Click **"+ Add"** or toggle **ON**

### Step 3: Configure Color Scale

```
Conditional Formatting
─────────────────────────────────────
Apply to: Revenue (metric)

Color Type
⚪ Single color threshold
⚪ Color scale ← Select this

Color Scale Settings
─────────────────────────────────────
Scale Type:
  ⚪ 2-color gradient
  ⚪ 3-color gradient ← Recommended
  ⚪ 5-color gradient

Gradient Direction:
  ⚪ Low to High
  ⚪ High to Low ← Select (red=low, green=high)

Colors:
  Low (Min): #D32F2F (Red)
  Mid (50%): #FDD835 (Yellow)
  High (Max): #388E3C (Green)

Apply to:
  ⚪ Cell background ← More visible
  ⚪ Text color
```

**Click "APPLY"**

### Step 4: Customize Thresholds (Optional)

Instead of automatic min/max, set business thresholds:

```
Manual Scale
─────────────────────────────────────
Min Value: 0
Midpoint: ₦25,000,000 (target)
Max Value: ₦50,000,000 (stretch goal)
```

**Why:** Aligns colors with business targets, not just data range.

---

## Part 3: Threshold-Based Rules

### Scenario: Delivery Performance Dashboard

**Business Rule:**
- **On-time delivery:** ≤ 3 days = Green
- **Acceptable:** 4-7 days = Yellow
- **Late:** > 7 days = Red

### Step 1: Create Calculated Field

First, calculate delivery time (from Week 13):
```
Field Name: delivery_days
Formula: DATE_DIFF(order_delivered_customer_date,
                   order_purchase_timestamp)
```

### Step 2: Add to Table

1. Create table with: `order_id`, `customer_state`, `delivery_days`
2. Select chart → Style tab

### Step 3: Add Threshold Rules

```
Conditional Formatting
─────────────────────────────────────
Apply to: delivery_days

Color Type
⚪ Color scale
⚪ Single color threshold ← Select

Rule 1: Late Deliveries
─────────────────────────────────────
Condition: Greater than
Value: 7
Background: #D32F2F (Red)
Text: #FFFFFF (White)

[+ Add another rule]

Rule 2: Acceptable Deliveries
─────────────────────────────────────
Condition: Between
Value 1: 4
Value 2: 7
Background: #FDD835 (Yellow)
Text: #000000 (Black)

[+ Add another rule]

Rule 3: On-Time Deliveries
─────────────────────────────────────
Condition: Less than or equal to
Value: 3
Background: #388E3C (Green)
Text: #FFFFFF (White)
```

**Order matters:** Looker applies rules top-to-bottom. Most specific rules should come first.

### Available Conditions

| Condition | SQL Equivalent | Use Case |
|-----------|----------------|----------|
| **Equal to** | `=` | Specific status flags |
| **Not equal to** | `!=` | Exclude certain values |
| **Greater than** | `>` | Above threshold alerts |
| **Less than** | `<` | Below minimum warnings |
| **Between** | `BETWEEN x AND y` | Range-based rules |
| **Contains** | `LIKE '%text%'` | Text matching |
| **Is null** | `IS NULL` | Missing data flags |

---

## Part 4: Nigerian Business Context Examples

### Example 1: VAT-Inclusive Pricing Alert

**Rule:** Highlight orders missing VAT calculation

```
Calculated Field: has_vat
Formula: IF(vat_amount IS NULL OR vat_amount = 0, "Missing", "Included")

Conditional Formatting:
─────────────────────────────────────
Apply to: has_vat
Condition: Equal to
Value: "Missing"
Background: #FF5722 (Orange)
Text: #FFFFFF
Icon: ⚠️ (if available)
```

### Example 2: Lagos Premium Shipping

**Rule:** Flag Lagos orders for expedited shipping

```
Calculated Field: is_lagos
Formula: IF(customer_state = "SP", "Lagos", "Other")
-- Note: Using Brazilian SP as analogy for Lagos market

Conditional Formatting:
─────────────────────────────────────
Apply to: is_lagos
Condition: Equal to
Value: "Lagos"
Background: #1976D2 (Blue)
Icon: ⚡ (priority indicator)
```

### Example 3: Currency Threshold (Naira)

**Rule:** Flag high-value orders requiring approval

```
Calculated Field: price_ngn
Formula: price * 1500  -- Convert USD to NGN

Conditional Formatting:
─────────────────────────────────────
Apply to: price_ngn
Condition: Greater than
Value: 150000  -- ₦150,000 threshold
Background: #9C27B0 (Purple - VIP)
Text: #FFFFFF
Bold: ☑
```

### Example 4: Regional Performance vs Target

**Rule:** Compare actual vs regional targets

```
Regional Targets (Nigerian Context):
Lagos: ₦50M
Abuja: ₦30M
Port Harcourt: ₦20M
Others: ₦10M each

Conditional Formatting:
─────────────────────────────────────
Apply to: revenue
Condition: Greater than or equal to (target from parameter)
Background: #4CAF50 (Green - target met)

Else:
Background: #F44336 (Red - below target)
```

---

## Part 5: Scorecard Conditional Formatting

### Scenario: KPI Monitoring Dashboard

**Business Metrics:**
- **Total Revenue:** Target = ₦100M
- **Order Count:** Target = 5,000
- **Average Order Value:** Target = ₦20,000

### Step 1: Create Scorecards

1. Insert → Scorecard
2. Metric: `SUM(price)` as "Total Revenue"
3. Repeat for other KPIs

### Step 2: Add Target Comparison

```
Data
─────────────────────────────────────
Metric: SUM(price)

Comparison
☑ Show comparison
  Comparison type: Target
  Target value: 100000000  -- ₦100M
  Comparison label: "vs Target"
```

### Step 3: Conditional Format Based on Performance

```
Style → Conditional Formatting
─────────────────────────────────────
Apply to: Metric

Rule 1: Exceeds Target (110%+)
Condition: Greater than
Value: 110000000
Background: #1B5E20 (Dark Green)
Text: #FFFFFF
Font size: 48px

Rule 2: Meets Target (90-110%)
Condition: Between
Value 1: 90000000
Value 2: 110000000
Background: #4CAF50 (Green)
Text: #FFFFFF
Font size: 48px

Rule 3: Below Target (<90%)
Condition: Less than
Value: 90000000
Background: #D32F2F (Red)
Text: #FFFFFF
Font size: 48px
```

**Result:** Scorecard background color signals performance at a glance.

---

## Part 6: Advanced Techniques

### Technique 1: Dynamic Thresholds with Parameters

**Problem:** Targets change monthly; hard-coded values get outdated

**Solution:** Use parameters for dynamic thresholds

#### Step 1: Create Parameter (Looker Studio Pro feature)

```
Parameter Name: revenue_target
Type: Number
Default Value: 100000000
```

#### Step 2: Reference in Conditional Formatting

```
Conditional Formatting
─────────────────────────────────────
Condition: Greater than
Value: revenue_target  -- References parameter
```

**Benefit:** Update target once; all formatting updates automatically.

### Technique 2: Nested Conditions (Multiple Metrics)

**Use Case:** Flag orders that are BOTH late AND high-value

```
Calculated Field: requires_attention
Formula:
CASE
  WHEN delivery_days > 7 AND price > 500 THEN "Urgent"
  WHEN delivery_days > 7 THEN "Late"
  WHEN price > 500 THEN "High Value"
  ELSE "Normal"
END

Conditional Formatting:
─────────────────────────────────────
Apply to: requires_attention

Rule 1:
Condition: Equal to "Urgent"
Background: #B71C1C (Dark Red)
Icon: 🚨

Rule 2:
Condition: Equal to "Late"
Background: #FF9800 (Orange)

Rule 3:
Condition: Equal to "High Value"
Background: #2196F3 (Blue)
```

### Technique 3: Percentile-Based Formatting

**Use Case:** Highlight top 10% and bottom 10% performers

**Looker Studio Limitation:** No built-in percentile functions

**Workaround:** Pre-calculate in SQL custom query

```sql
-- In data source custom query
WITH ranked AS (
  SELECT
    customer_state,
    SUM(price) as revenue,
    PERCENT_RANK() OVER (ORDER BY SUM(price)) as percentile
  FROM olist_order_items_dataset oi
  JOIN olist_orders_dataset o ON oi.order_id = o.order_id
  GROUP BY customer_state
)
SELECT
  customer_state,
  revenue,
  CASE
    WHEN percentile >= 0.9 THEN 'Top 10%'
    WHEN percentile <= 0.1 THEN 'Bottom 10%'
    ELSE 'Middle 80%'
  END as performance_tier
FROM ranked;
```

Then apply conditional formatting to `performance_tier` field.

---

## Part 7: Best Practices for Conditional Formatting

### Do's ✅

**1. Use Color Purposefully**
```
Standard Conventions:
🟢 Green = Good, Success, On-track
🔴 Red = Bad, Error, Alert
🟡 Yellow = Warning, Caution
🔵 Blue = Information, Neutral
🟣 Purple = Premium, VIP
```

**2. Limit Colors to 3-5**
- Too many colors = confusing
- Stick to traffic light system (red/yellow/green)

**3. Consider Color Blindness**
- Use patterns or icons in addition to colors
- Avoid red/green-only distinctions
- Add text labels for accessibility

**4. Align with Business Logic**
```
✅ Good: Revenue > Target = Green
❌ Bad: Revenue > Target = Red (confusing!)
```

**5. Test Readability**
```
✅ Good: Dark text on light background
❌ Bad: Light text on light background
```

### Don'ts ❌

**1. Over-Format**
```
❌ Bad: Every cell in rainbow colors
✅ Good: Highlight exceptions only
```

**2. Ignore Context**
```
❌ Bad: All negative numbers = red
Context: Negative could mean "cost savings" (good!) or "loss" (bad)
✅ Good: Context-aware formatting
```

**3. Format Without Purpose**
```
❌ Bad: "It looks pretty"
✅ Good: "Red highlights items needing immediate action"
```

**4. Use Conflicting Colors**
```
❌ Bad: Green for both "high sales" AND "low costs"
✅ Good: Separate color schemes for different contexts
```

---

## Part 8: Practical Exercise (10 minutes)

### Task: Build a Conditional Formatting Dashboard

Using your Olist dataset, create:

#### Chart 1: Revenue by State (Heat Map)
1. Create table: `customer_state` | `SUM(price)`
2. Add color scale:
   - Low = Red
   - Mid = Yellow
   - High = Green
3. Apply to cell background

**Verification:**
- States with high revenue show green
- Low-revenue states show red

#### Chart 2: Delivery Performance Table
1. Create calculated field:
```
delivery_status =
CASE
  WHEN delivery_days <= 3 THEN "On Time"
  WHEN delivery_days BETWEEN 4 AND 7 THEN "Acceptable"
  WHEN delivery_days > 7 THEN "Late"
  ELSE "Unknown"
END
```

2. Create table: `order_id` | `delivery_days` | `delivery_status`
3. Add threshold formatting:
   - "On Time" = Green background
   - "Acceptable" = Yellow background
   - "Late" = Red background

**Verification:**
- Late orders clearly visible in red
- Color coding matches delivery times

#### Chart 3: KPI Scorecard with Target
1. Create scorecard: `SUM(price)` as "Total Revenue"
2. Set comparison target: 50,000,000 (₦50M or R$50M)
3. Add conditional formatting:
   - Above target = Green
   - Below target = Red

**Verification:**
- Scorecard background changes based on performance
- Comparison percentage shows

---

## Part 9: Common Formatting Issues and Solutions

### Issue 1: Colors Don't Show

**Symptoms:** Formatting configured but cells remain white

**Causes & Solutions:**
- ❌ Applied to wrong column
  - ✅ Check "Apply to" field matches metric/dimension
- ❌ Condition never true
  - ✅ Verify threshold values are realistic
- ❌ Style theme overriding
  - ✅ Check chart theme settings

### Issue 2: All Cells Same Color

**Symptoms:** Every cell shows same formatting

**Causes & Solutions:**
- ❌ Threshold too low/high (all values meet condition)
  - ✅ Adjust threshold to match data range
- ❌ Using dimension instead of metric
  - ✅ Ensure numeric field is being evaluated

### Issue 3: Text Unreadable

**Symptoms:** Can't read text due to color contrast

**Causes & Solutions:**
- ❌ Light text on light background
  - ✅ Set text color to white when background is dark
  - ✅ Set text color to black when background is light

**Rule of Thumb:**
```
Dark backgrounds (#D32F2F, #388E3C) → White text (#FFFFFF)
Light backgrounds (#FDD835, #FFEB3B) → Black text (#000000)
```

### Issue 4: Formatting Changes Unexpectedly

**Symptoms:** Colors shift when filter applied

**Causes & Solutions:**
- ❌ Using auto-scale (min/max change with filter)
  - ✅ Set manual thresholds based on business rules
  - ✅ Use absolute values, not relative scales

---

## Connection to SQL Logic

### SQL CASE for Status + Looker Formatting

**SQL Approach (Week 3):**
```sql
SELECT
  order_id,
  delivery_days,
  CASE
    WHEN delivery_days > 7 THEN 'LATE'
    WHEN delivery_days > 3 THEN 'OK'
    ELSE 'ON TIME'
  END as status,
  -- Manual color column (awkward!)
  CASE
    WHEN delivery_days > 7 THEN 'red'
    WHEN delivery_days > 3 THEN 'yellow'
    ELSE 'green'
  END as color_code
FROM orders;
```

**Looker Approach:**
```
1. Create status field (CASE statement)
2. Apply conditional formatting (automatic colors)
3. No separate color column needed!
```

**Advantage:** Separation of logic and presentation.

---

## Key Takeaways

### What You Learned
1. ✅ Conditional formatting highlights patterns automatically
2. ✅ Color scales show gradients (heat maps)
3. ✅ Threshold rules flag specific conditions
4. ✅ Business-aligned colors improve decision-making
5. ✅ Scorecard formatting signals KPI performance
6. ✅ Accessibility matters (color blindness, contrast)

### What's Next
In the final lesson (Part 4), we'll cover **time series best practices** including trend analysis, seasonality, and comparison techniques.

### Skills Building Progression
```
Week 14 Part 1: Interactive Controls ✓
Week 14 Part 2: Filter Relationships ✓
Week 14 Part 3: Conditional Formatting ✓
         ↓
Week 14 Part 4: Time Series Best Practices (Next)
```

---

## Quick Reference Card

### Common Formatting Rules

| Business Scenario | Condition | Color |
|------------------|-----------|-------|
| **Revenue above target** | `> target` | 🟢 Green |
| **Revenue below target** | `< target * 0.9` | 🔴 Red |
| **Near target (±10%)** | `BETWEEN target*0.9 AND target*1.1` | 🟡 Yellow |
| **Late delivery** | `delivery_days > 7` | 🔴 Red |
| **High-value order** | `price > 100000` | 🟣 Purple |
| **Missing data** | `IS NULL` | 🟠 Orange |
| **Top performer** | `rank <= 3` | 🟢 Green |
| **Bottom performer** | `rank > 20` | 🔴 Red |

### Color Palette Recommendations

**Traffic Light System:**
```
🟢 Success: #4CAF50 (Green)
🟡 Warning: #FDD835 (Yellow)
🔴 Alert:   #F44336 (Red)
```

**Business Tiers:**
```
🟣 Premium:  #9C27B0 (Purple)
🔵 Standard: #2196F3 (Blue)
🟢 Economy:  #4CAF50 (Green)
```

**Performance:**
```
🟢 High:    #1B5E20 (Dark Green)
🟡 Medium:  #FBC02D (Amber)
🔴 Low:     #B71C1C (Dark Red)
```

---

## Questions to Test Your Understanding

1. What is the difference between color scales and threshold rules?
2. Why should you avoid using too many colors in conditional formatting?
3. How does conditional formatting relate to SQL CASE statements?
4. What accessibility considerations matter for color choices?
5. When would you use manual thresholds instead of auto-scaling?

**Answers at the end of lecture notes**

---

## Additional Resources

- **Looker Studio Help:** [Conditional Formatting](https://support.google.com/looker-studio/answer/7571884)
- **Color Accessibility Checker:** [WebAIM Contrast Checker](https://webaim.org/resources/contrastchecker/)
- **Design Guide:** Data Visualization Color Best Practices (resources/)

---

## Answers to Questions

1. **Color scales** apply gradients across a range (min to max); **threshold rules** apply specific colors when conditions are met (if-then logic)
2. Too many colors create visual clutter and confusion; 3-5 colors aligned with business meaning (traffic lights) are most effective
3. Both use **conditional logic** to categorize data; CASE creates text categories, formatting creates visual categories through color
4. **Color blindness** (avoid red/green only), **contrast ratio** (readable text), **patterns/icons** as color alternatives
5. Use **manual thresholds** when business targets are fixed (e.g., ₦100M goal) rather than data-dependent (prevents thresholds shifting when data changes)

---

**Next Lecture:** 04_time_series_best_practices.md
