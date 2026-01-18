# Calculated Fields in Looker Studio

## Week 13 - Wednesday Session - Part 3

### Duration: 40 minutes

---

## Overview

Calculated fields in Looker Studio are like **derived columns** in SQL or **calculated columns** in Excel. They let you create new metrics and dimensions based on existing data without modifying your database.

### What You'll Learn
- Creating calculated fields at data source level
- Creating calculated fields at chart level
- SQL-like syntax in Looker Studio
- Common business calculations
- Date manipulation functions
- CASE statements for categorization

---

## Part 1: Understanding Calculated Fields

### What Are Calculated Fields?

**Definition:** New fields created by applying formulas to existing data.

**Analogy from SQL:**
```sql
-- This is a calculated field in SQL
SELECT
    price,
    freight_value,
    price + freight_value AS total_order_value  -- Calculated!
FROM orders;
```

**Analogy from Excel:**
```
| A: price | B: freight | C: total_order_value |
|----------|------------|----------------------|
| 100      | 15         | =A2+B2               | ← Calculated!
```

### Why Use Calculated Fields?

**Instead of:**
```sql
-- Modifying database query every time you need a new metric
SELECT
    price,
    freight_value,
    price + freight_value as total_value,
    price * 0.075 as tax_amount,
    (price + freight_value) * 1.075 as total_with_tax
FROM orders;
```

**You can:**
- Create fields once in Looker Studio
- Reuse across all charts
- Modify without touching database
- Share across multiple reports

---

## Part 2: Two Types of Calculated Fields

### Type 1: Data Source Level (Recommended)

**Created in:** Data Source editor
**Scope:** Available in ALL charts using that data source
**Best for:** Commonly used calculations

**Example:** `total_order_value` field used across multiple charts

```
Report: Sales Dashboard
├── Chart 1: Total Revenue (uses total_order_value)
├── Chart 2: Revenue by State (uses total_order_value)
└── Chart 3: Top Products by Revenue (uses total_order_value)
                              ↑
                  All use the same calculated field!
```

### Type 2: Chart Level

**Created in:** Individual chart editor
**Scope:** Only available in THAT specific chart
**Best for:** One-off calculations

**Example:** Custom metric for a single chart

```
Report: Sales Dashboard
├── Chart 1: Revenue Comparison
│   └── Custom field: revenue_vs_target (only here)
├── Chart 2: Order Count (no custom fields)
└── Chart 3: Product Mix (no custom fields)
```

---

## Part 3: Creating Data Source Level Calculated Fields

### Step-by-Step Process

#### Step 1: Access Data Source Editor

**Method A: From Report**
1. Open your report in Edit mode
2. Click **"Resource"** menu → **"Manage added data sources"**
3. Click **"EDIT"** next to your data source
4. You're now in the Data Source editor

**Method B: From Home**
1. Go to Looker Studio home
2. Click **"Data Sources"** tab
3. Find your data source
4. Click on it to edit

#### Step 2: Add Calculated Field

In the Data Source editor, you'll see the field list:

```
Fields
──────────────────────────────────────
DIMENSIONS
├── 📅 order_date
├── 🏷️ customer_state
└── 🆔 order_id

METRICS
├── 🔢 price
├── 🔢 freight_value
└── 📊 Record Count

[+ ADD A FIELD]  ← Click here
```

**Click: "+ ADD A FIELD"** (top-right of field list)

#### Step 3: Define Your Calculation

A dialog box opens:

```
┌─────────────────────────────────────────┐
│  Create Field                            │
├─────────────────────────────────────────┤
│  Field Name                             │
│  ┌───────────────────────────────────┐  │
│  │ total_order_value                  │  │
│  └───────────────────────────────────┘  │
│                                         │
│  Formula                                │
│  ┌───────────────────────────────────┐  │
│  │ price + freight_value              │  │
│  └───────────────────────────────────┘  │
│                                         │
│  ✅ Formula is valid                    │
│                                         │
│         [SAVE]      [Cancel]           │
└─────────────────────────────────────────┘
```

**Enter:**
- **Field Name:** Descriptive name (e.g., `total_order_value`)
- **Formula:** Calculation using existing fields

**Click: "SAVE"**

#### Step 4: Verify Field Creation

Your new field appears in the field list:

```
METRICS
├── 🔢 price
├── 🔢 freight_value
├── 🔢 total_order_value  ← Your new field! (blue icon = calculated)
└── 📊 Record Count
```

**Blue icon** = Calculated field

---

## Part 4: Looker Studio Formula Syntax

### Basic Syntax Rules

**1. Field References**
- Use field names directly (case-sensitive)
- Enclose in quotes if name has spaces: `"Order Date"`

**2. Operators**
```
Arithmetic:  +  -  *  /  %
Comparison:  =  !=  <  >  <=  >=
Logical:     AND  OR  NOT
```

**3. Functions**
- Always uppercase: `SUM()`, `AVG()`, `COUNT()`
- Case-sensitive

### Comparison: SQL vs. Looker Studio

| Operation | SQL | Looker Studio |
|-----------|-----|---------------|
| **Addition** | `price + freight` | `price + freight_value` |
| **Multiplication** | `price * quantity` | `price * quantity` |
| **Conditional** | `CASE WHEN price > 100 THEN 'High' ELSE 'Low' END` | `CASE WHEN price > 100 THEN "High" ELSE "Low" END` |
| **Text concat** | `first_name || ' ' || last_name` | `CONCAT(first_name, " ", last_name)` |
| **Date year** | `EXTRACT(YEAR FROM order_date)` | `YEAR(order_date)` |

**Key Differences:**
- SQL uses single quotes `'text'`
- Looker uses double quotes `"text"`
- Functions slightly different (but similar)

---

## Part 5: Common Business Calculations

### 1. Arithmetic Operations

#### Total Order Value
```
Field Name: total_order_value
Formula:    price + freight_value
```

#### Profit Margin (if you have cost data)
```
Field Name: profit_margin
Formula:    (price - cost) / price
```

#### Tax Amount (7.5%)
```
Field Name: tax_amount
Formula:    price * 0.075
```

#### Average Order Value (AOV)
```
Field Name: average_order_value
Formula:    SUM(price) / COUNT_DISTINCT(order_id)
```

### 2. Date Extractions

#### Order Year
```
Field Name: order_year
Formula:    YEAR(order_date)
```

#### Order Month (Number)
```
Field Name: order_month
Formula:    MONTH(order_date)
```

#### Order Month Name
```
Field Name: order_month_name
Formula:    MONTH_NAME(order_date)
```

#### Quarter
```
Field Name: order_quarter
Formula:    QUARTER(order_date)
```

#### Day of Week
```
Field Name: order_day_of_week
Formula:    WEEKDAY(order_date)
```

#### Year-Month (for time series grouping)
```
Field Name: year_month
Formula:    CONCAT(CAST(YEAR(order_date) AS TEXT), "-",
                   RIGHT(CONCAT("0", CAST(MONTH(order_date) AS TEXT)), 2))
```

### 3. Date Calculations

#### Delivery Time (Days)
```
Field Name: delivery_time_days
Formula:    DATE_DIFF(order_delivered_customer_date,
                      order_purchase_timestamp)
```

#### Is Delivered On Time (Boolean)
```
Field Name: is_on_time
Formula:    order_delivered_customer_date <= order_estimated_delivery_date
```

#### Days Until Delivery
```
Field Name: days_until_delivery
Formula:    DATE_DIFF(order_estimated_delivery_date,
                      order_purchase_timestamp)
```

---

## Part 6: CASE Statements for Categorization

### Basic Syntax

**SQL Version:**
```sql
CASE
    WHEN condition1 THEN result1
    WHEN condition2 THEN result2
    ELSE default_result
END
```

**Looker Studio Version:**
```
CASE
    WHEN condition1 THEN "result1"
    WHEN condition2 THEN "result2"
    ELSE "default_result"
END
```

### Example 1: Price Tier Classification

**Business Rule:**
- Budget: ≤ ₦10,000 (≤ $50)
- Mid-range: ₦10,001 - ₦30,000 ($50 - $150)
- Premium: > ₦30,000 (> $150)

```
Field Name: price_tier
Formula:
CASE
    WHEN price <= 50 THEN "Budget"
    WHEN price > 50 AND price <= 150 THEN "Mid-range"
    WHEN price > 150 THEN "Premium"
    ELSE "Unknown"
END
```

### Example 2: Delivery Status

**Business Rule:**
- On Time: delivered ≤ estimated
- Late: delivered > estimated
- Pending: not yet delivered

```
Field Name: delivery_status
Formula:
CASE
    WHEN order_delivered_customer_date IS NULL THEN "Pending"
    WHEN order_delivered_customer_date <= order_estimated_delivery_date
        THEN "On Time"
    WHEN order_delivered_customer_date > order_estimated_delivery_date
        THEN "Late"
    ELSE "Unknown"
END
```

### Example 3: Customer Tier by Total Spending

**Business Rule:**
- VIP: > ₦100,000 (> $500)
- Regular: ₦20,000 - ₦100,000 ($100 - $500)
- New: < ₦20,000 (< $100)

```
Field Name: customer_tier
Formula:
CASE
    WHEN total_order_value > 500 THEN "VIP"
    WHEN total_order_value >= 100 THEN "Regular"
    WHEN total_order_value < 100 THEN "New"
    ELSE "Unknown"
END
```

### Example 4: Regional Grouping (Brazilian States)

**Business Rule:** Group states by region

```
Field Name: region
Formula:
CASE
    WHEN customer_state IN ("SP", "RJ", "MG", "ES") THEN "Southeast"
    WHEN customer_state IN ("RS", "SC", "PR") THEN "South"
    WHEN customer_state IN ("GO", "MT", "MS", "DF") THEN "Central-West"
    WHEN customer_state IN ("BA", "SE", "AL", "PE", "PB", "RN", "CE", "PI", "MA") THEN "Northeast"
    WHEN customer_state IN ("AM", "RR", "AP", "PA", "TO", "RO", "AC") THEN "North"
    ELSE "Unknown"
END
```

---

## Part 7: Aggregation Functions

### Common Aggregate Functions

#### SUM - Total
```
Field Name: total_revenue
Formula:    SUM(price)
```

#### AVG - Average
```
Field Name: average_price
Formula:    AVG(price)
```

#### COUNT - Count of records
```
Field Name: order_count
Formula:    COUNT(order_id)
```

#### COUNT_DISTINCT - Unique count
```
Field Name: unique_customers
Formula:    COUNT_DISTINCT(customer_id)
```

#### MIN - Minimum
```
Field Name: min_price
Formula:    MIN(price)
```

#### MAX - Maximum
```
Field Name: max_price
Formula:    MAX(price)
```

### When to Use Aggregations

**Rule of Thumb:**
- Use aggregations when creating **metrics** (numbers to measure)
- Don't use for **dimensions** (categories to group by)

**Example:**
```
✅ Good: total_revenue = SUM(price)         [Metric]
✅ Good: order_year = YEAR(order_date)      [Dimension]
❌ Bad:  customer_state = SUM(customer_state)  [Makes no sense!]
```

---

## Part 8: Text Functions

### CONCAT - Combine Text

```
Field Name: full_location
Formula:    CONCAT(customer_city, ", ", customer_state)
Result:     "São Paulo, SP"
```

### UPPER / LOWER - Change Case

```
Field Name: state_upper
Formula:    UPPER(customer_state)
Result:     "SP" → "SP"
```

### SUBSTR - Extract Part of Text

```
Field Name: state_code
Formula:    SUBSTR(customer_zip_code_prefix, 1, 2)
Result:     "01310" → "01"
```

### REPLACE - Replace Text

```
Field Name: clean_product_name
Formula:    REPLACE(product_category_name, "_", " ")
Result:     "home_appliances" → "home appliances"
```

---

## Part 9: Null Handling

### Checking for Nulls

```
Field Name: has_delivery_date
Formula:    IF(order_delivered_customer_date IS NULL,
               "No",
               "Yes")
```

### Replacing Nulls with Defaults

```
Field Name: delivery_date_clean
Formula:    IFNULL(order_delivered_customer_date,
                   "Not Delivered")
```

### COALESCE - First Non-Null Value

```
Field Name: primary_contact
Formula:    COALESCE(mobile_phone, work_phone, home_phone, "No Phone")
```

---

## Part 10: Chart-Level Calculated Fields

### When to Use Chart-Level Fields

**Use when:**
- Calculation is specific to ONE chart
- You don't want to clutter data source with one-off metrics
- Testing a formula before making it data source-level

### Creating Chart-Level Fields

#### Step 1: Edit Chart
- Select chart on canvas
- Right panel opens

#### Step 2: Access Metrics Section

```
Data
──────────────────────────────────────
Metric
├── 🔢 SUM(price)
└── [+ Add metric]  ← Click here
```

#### Step 3: Create Formula

In the metric dropdown:
```
Add metric
──────────────────────────────────────
📈 price
📈 freight_value
📈 total_order_value
──────────────────────────────────────
🔧 Create calculated field  ← Click here
```

#### Step 4: Define Field (Same as Data Source Level)

```
Field Name: revenue_per_customer
Formula:    SUM(price) / COUNT_DISTINCT(customer_id)
```

**Important:** This field ONLY exists in this chart.

---

## Part 11: Nigerian Business Context Examples

### Example 1: Naira Conversion (USD to NGN)

**Scenario:** Your data is in USD, but you want to display in Naira.

```
Field Name: price_ngn
Formula:    price * 1500
Note:       Use current exchange rate
```

### Example 2: VAT Calculation (7.5%)

```
Field Name: vat_amount
Formula:    price * 0.075
```

```
Field Name: total_with_vat
Formula:    price + (price * 0.075)
```

### Example 3: Lagos vs. Non-Lagos Sales

```
Field Name: is_lagos
Formula:
CASE
    WHEN customer_state = "SP" THEN "Lagos"
    -- Note: Brazilian data, use SP as analogy for Lagos
    ELSE "Other States"
END
```

### Example 4: Working Days Delivery Time

**Exclude weekends from delivery time calculation:**

```
Field Name: working_days_delivery
Formula:    DATE_DIFF(order_delivered_customer_date,
                      order_purchase_timestamp,
                      WEEK)
```

---

## Part 12: Testing and Debugging Calculated Fields

### Common Errors

#### Error 1: "Invalid formula"

**Cause:** Syntax error

**Examples:**
```
❌ price + freight           // Field name doesn't exist
✅ price + freight_value     // Correct field name

❌ SUM(price) + freight_value  // Mixing aggregated and non-aggregated
✅ SUM(price + freight_value)  // Both inside aggregation

❌ CASE WHEN price > 100 THEN 'High' END  // Single quotes
✅ CASE WHEN price > 100 THEN "High" END  // Double quotes
```

#### Error 2: "Cannot mix aggregated and non-aggregated fields"

**Cause:** Using SUM/AVG/COUNT with regular fields incorrectly

```
❌ SUM(price) / freight_value    // SUM mixed with non-aggregated
✅ SUM(price) / SUM(freight_value)  // Both aggregated
✅ SUM(price / freight_value)    // Calculate ratio first, then aggregate
```

#### Error 3: "Field not found"

**Cause:** Typo in field name

**Solution:** Use field picker (click "fx" button) instead of typing

### Testing Your Calculations

**Method 1: Create a Table Chart**
1. Add your calculated field to a table
2. Add original fields it's based on
3. Verify results manually

**Example:**
```
| price | freight_value | total_order_value | ✓ Correct? |
|-------|---------------|-------------------|------------|
| 100   | 15            | 115               | ✓          |
| 200   | 20            | 220               | ✓          |
```

**Method 2: Use Scorecards**
1. Create scorecard with calculated field
2. Compare to expected total
3. Use SQL query in VS Code to verify

---

## Part 13: Practical Exercise (15 minutes)

### Task: Create 5 Calculated Fields

Using your "Olist Orders - Practice Connection" data source, create these calculated fields:

#### Field 1: Total Order Value
```
Name:    total_order_value
Formula: price + freight_value
Type:    Metric
```

#### Field 2: Order Year
```
Name:    order_year
Formula: YEAR(order_purchase_timestamp)
Type:    Dimension
```

#### Field 3: Order Month
```
Name:    order_month
Formula: MONTH(order_purchase_timestamp)
Type:    Dimension
```

#### Field 4: Price Tier
```
Name:    price_tier
Formula:
CASE
    WHEN price <= 50 THEN "Budget"
    WHEN price > 50 AND price <= 150 THEN "Mid-range"
    ELSE "Premium"
END
Type:    Dimension
```

#### Field 5: Delivery Time (Days)
```
Name:    delivery_time_days
Formula: DATE_DIFF(order_delivered_customer_date,
                   order_purchase_timestamp)
Type:    Metric
```

### Verification Steps

1. **Create a table** with all 5 fields
2. **Check for errors** (red exclamation marks)
3. **Verify data types:**
   - `total_order_value`: Number
   - `order_year`: Number (or Date)
   - `order_month`: Number (or Date)
   - `price_tier`: Text
   - `delivery_time_days`: Number

4. **Create scorecards:**
   - Total Revenue: `SUM(total_order_value)`
   - Average Delivery Time: `AVG(delivery_time_days)`

---

## Key Takeaways

### What You Learned
1. ✅ Two types of calculated fields: Data Source vs. Chart level
2. ✅ Looker Studio formula syntax (similar to SQL)
3. ✅ Common calculations: arithmetic, dates, text
4. ✅ CASE statements for categorization
5. ✅ Aggregation functions (SUM, AVG, COUNT)
6. ✅ Testing and debugging formulas

### SQL Skills Applied
- Week 3: Calculated columns and CASE statements
- Week 5: Date functions (EXTRACT, DATE_DIFF)
- Week 4: Aggregations (SUM, AVG, COUNT)

### Formula Reference Quick Guide

| Category | Function | Example |
|----------|----------|---------|
| **Math** | `+`, `-`, `*`, `/` | `price * 1.075` |
| **Aggregation** | `SUM()`, `AVG()`, `COUNT()` | `SUM(price)` |
| **Date** | `YEAR()`, `MONTH()`, `DATE_DIFF()` | `YEAR(order_date)` |
| **Text** | `CONCAT()`, `UPPER()`, `LOWER()` | `CONCAT(city, ", ", state)` |
| **Logic** | `CASE WHEN`, `IF()`, `IFNULL()` | `CASE WHEN price > 100...` |

---

## Best Practices Checklist

```
☐ Create commonly used fields at data source level
☐ Use descriptive field names (total_order_value, not tov)
☐ Test formulas before saving (check with table chart)
☐ Document complex formulas (add comments)
☐ Use CASE for categorization (not multiple IF statements)
☐ Always handle NULL values explicitly
☐ Prefer data source fields over chart-level fields
☐ Verify data types (metrics vs dimensions)
```

---

## Additional Resources

- **Looker Studio Formula Reference:** [support.google.com/looker-studio/table/6379764](https://support.google.com/looker-studio/table/6379764)
- **Complete Function List:** See `resources/looker_studio_quick_reference.md`
- **SQL to Looker Translation:** See `resources/sql_to_looker_translation.md`

---

**Next Session:** Thursday - Chart Types and Basic Visualization Design

Your calculated fields are now ready to be used in charts!
