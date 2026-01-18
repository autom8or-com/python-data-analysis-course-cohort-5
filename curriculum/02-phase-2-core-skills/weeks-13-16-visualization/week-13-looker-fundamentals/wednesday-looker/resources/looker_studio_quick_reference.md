# Looker Studio Quick Reference Guide

## Week 13 - Wednesday Resources

**PORA Academy - Data Analytics Bootcamp**

---

## Table of Contents

1. [Interface Navigation](#interface-navigation)
2. [Common Functions](#common-functions)
3. [Data Types](#data-types)
4. [Formula Syntax](#formula-syntax)
5. [Keyboard Shortcuts](#keyboard-shortcuts)
6. [Troubleshooting](#troubleshooting)

---

## Interface Navigation

### Main Components

```
┌─────────────────────────────────────────────────────────┐
│  Looker Studio Report Editor                            │
├─────────────────────────────────────────────────────────┤
│                                                         │
│  TOP TOOLBAR                                            │
│  ┌─────────────────────────────────────────────────┐   │
│  │ File | Edit | View | Insert | Page | Arrange   │   │
│  └─────────────────────────────────────────────────┘   │
│                                                         │
│  LEFT SIDEBAR        CANVAS            RIGHT PANEL      │
│  ┌──────────┐       ┌─────────────┐   ┌───────────┐   │
│  │          │       │             │   │ Data      │   │
│  │ Add      │       │  Your       │   │ ────────  │   │
│  │ Chart    │       │  Dashboard  │   │ Settings  │   │
│  │          │       │  Design     │   │           │   │
│  │ Add      │       │  Area       │   │ Style     │   │
│  │ Control  │       │             │   │ ────────  │   │
│  │          │       │             │   │ Format    │   │
│  │ Add Text │       │             │   │           │   │
│  └──────────┘       └─────────────┘   └───────────┘   │
│                                                         │
└─────────────────────────────────────────────────────────┘
```

### Key Menu Locations

| Task | Menu Path |
|------|-----------|
| **Add Chart** | Insert → Chart OR Click chart icon in toolbar |
| **Add Filter** | Insert → Control → Drop-down list |
| **Share Report** | Share button (top-right) |
| **Edit Data Source** | Resource → Manage added data sources |
| **Preview Report** | View button (top-right) |
| **Refresh Data** | Resource → Refresh data |
| **Add Page** | Page → New page |

---

## Common Functions

### Arithmetic Functions

| Function | Description | Example | Result |
|----------|-------------|---------|--------|
| `+` | Addition | `price + freight` | Sum of two fields |
| `-` | Subtraction | `delivered_date - purchase_date` | Date difference |
| `*` | Multiplication | `price * 1.5` | Price × 1.5 |
| `/` | Division | `revenue / orders` | Average |
| `%` | Modulo | `order_num % 2` | Remainder |

### Aggregation Functions

| Function | Description | Example | Use Case |
|----------|-------------|---------|----------|
| `SUM(field)` | Total sum | `SUM(price)` | Total revenue |
| `AVG(field)` | Average | `AVG(delivery_days)` | Avg delivery time |
| `COUNT(field)` | Count values | `COUNT(order_id)` | Number of orders |
| `COUNT_DISTINCT(field)` | Unique count | `COUNT_DISTINCT(customer_id)` | Unique customers |
| `MIN(field)` | Minimum value | `MIN(price)` | Cheapest product |
| `MAX(field)` | Maximum value | `MAX(price)` | Most expensive product |

### Date Functions

| Function | Description | Example | Result |
|----------|-------------|---------|--------|
| `YEAR(date)` | Extract year | `YEAR(order_date)` | 2017 |
| `MONTH(date)` | Extract month (1-12) | `MONTH(order_date)` | 3 |
| `MONTH_NAME(date)` | Month name | `MONTH_NAME(order_date)` | "March" |
| `QUARTER(date)` | Quarter (1-4) | `QUARTER(order_date)` | 1 |
| `WEEKDAY(date)` | Day of week (1-7) | `WEEKDAY(order_date)` | 4 |
| `DAY(date)` | Day of month (1-31) | `DAY(order_date)` | 15 |
| `DATE_DIFF(date1, date2)` | Days between | `DATE_DIFF(delivered, purchased)` | 7 |
| `HOUR(datetime)` | Extract hour (0-23) | `HOUR(timestamp)` | 14 |

### Text Functions

| Function | Description | Example | Result |
|----------|-------------|---------|--------|
| `CONCAT(text1, text2, ...)` | Join text | `CONCAT(city, ", ", state)` | "São Paulo, SP" |
| `UPPER(text)` | Uppercase | `UPPER(state)` | "SP" |
| `LOWER(text)` | Lowercase | `LOWER(NAME)` | "product" |
| `SUBSTR(text, start, length)` | Extract substring | `SUBSTR(zip, 1, 2)` | "01" |
| `REPLACE(text, old, new)` | Replace text | `REPLACE(name, "_", " ")` | "home appliances" |
| `LENGTH(text)` | Text length | `LENGTH(customer_id)` | 32 |
| `TRIM(text)` | Remove whitespace | `TRIM( " text " )` | "text" |

### Logical Functions

| Function | Description | Example |
|----------|-------------|---------|
| `IF(condition, true_value, false_value)` | Simple if | `IF(price > 100, "High", "Low")` |
| `IFNULL(field, default)` | Replace NULL | `IFNULL(phone, "No Phone")` |
| `CASE WHEN ... END` | Multi-condition | See CASE statement section |
| `AND` | Logical AND | `price > 100 AND state = "SP"` |
| `OR` | Logical OR | `state = "SP" OR state = "RJ"` |
| `NOT` | Logical NOT | `NOT (price > 100)` |
| `IN (value1, value2, ...)` | Value in list | `state IN ("SP", "RJ", "MG")` |
| `IS NULL` | Check for NULL | `delivery_date IS NULL` |
| `IS NOT NULL` | Check not NULL | `phone IS NOT NULL` |

### Comparison Operators

| Operator | Description | Example |
|----------|-------------|---------|
| `=` | Equal to | `state = "SP"` |
| `!=` or `<>` | Not equal to | `status != "cancelled"` |
| `>` | Greater than | `price > 100` |
| `<` | Less than | `delivery_days < 7` |
| `>=` | Greater or equal | `price >= 50` |
| `<=` | Less or equal | `delivery_days <= 10` |

---

## Data Types

### Field Types in Looker Studio

| Type | Description | Icon | Example Values | Use As |
|------|-------------|------|----------------|--------|
| **Text** | String values | 🏷️ | "São Paulo", "SP" | Dimension |
| **Number** | Numeric values | 🔢 | 125.50, 42 | Metric |
| **Date** | Date only | 📅 | 2017-03-15 | Dimension |
| **Date & Time** | Date with time | 🕐 | 2017-03-15 14:30:00 | Dimension |
| **Boolean** | True/False | ☑️ | true, false | Dimension |
| **URL** | Web address | 🔗 | https://... | Dimension |
| **Geo** | Geographic | 🌍 | Country, City | Dimension |

### Dimension vs. Metric

| Aspect | Dimension | Metric |
|--------|-----------|--------|
| **Type** | Categorical (text, date) | Numeric |
| **Role** | What to group by | What to measure |
| **SQL Equivalent** | GROUP BY column | SELECT SUM()/AVG()/COUNT() |
| **Icon** | 🏷️ 📅 | 🔢 📊 |
| **Examples** | customer_state, order_date, product_name | price, quantity, revenue |
| **Aggregation** | Not aggregated | Usually aggregated (SUM, AVG) |

### Converting Between Types

```
# Text to Number
CAST(text_field AS NUMBER)

# Number to Text
CAST(number_field AS TEXT)

# Text to Date
PARSE_DATE("%Y-%m-%d", date_string)

# Date to Text
FORMAT_DATE("%Y-%m-%d", date_field)
```

---

## Formula Syntax

### CASE Statement Structure

```
CASE
    WHEN condition1 THEN "result1"
    WHEN condition2 THEN "result2"
    WHEN condition3 THEN "result3"
    ELSE "default_result"
END
```

**Example: Price Categorization**
```
CASE
    WHEN price < 50 THEN "Budget"
    WHEN price >= 50 AND price < 150 THEN "Mid-Range"
    WHEN price >= 150 THEN "Premium"
    ELSE "Unknown"
END
```

**Important Rules:**
- Use **double quotes** `"text"` (not single quotes)
- First matching condition wins (order matters!)
- Always include `ELSE` clause
- Always end with `END`

### Nested CASE Statements

```
CASE
    WHEN region = "Southeast" THEN
        CASE
            WHEN state = "SP" THEN "São Paulo State"
            WHEN state = "RJ" THEN "Rio State"
            ELSE "Other Southeast"
        END
    WHEN region = "South" THEN "Southern Region"
    ELSE "Other Region"
END
```

### IF Function (Simple Conditionals)

```
# Syntax
IF(condition, value_if_true, value_if_false)

# Example
IF(price > 100, "Expensive", "Affordable")

# Nested IF (not recommended - use CASE instead)
IF(price > 150, "Premium",
    IF(price > 50, "Mid-Range", "Budget"))
```

---

## Keyboard Shortcuts

### General

| Action | Windows/Linux | Mac |
|--------|---------------|-----|
| **Save** | Ctrl + S | Cmd + S |
| **Undo** | Ctrl + Z | Cmd + Z |
| **Redo** | Ctrl + Y | Cmd + Y |
| **Copy** | Ctrl + C | Cmd + C |
| **Paste** | Ctrl + V | Cmd + V |
| **Duplicate** | Ctrl + D | Cmd + D |
| **Delete** | Delete | Delete |

### Report Editing

| Action | Windows/Linux | Mac |
|--------|---------------|-----|
| **Edit Mode** | Ctrl + Alt + E | Cmd + Option + E |
| **View Mode** | Ctrl + Alt + V | Cmd + Option + V |
| **Add Chart** | Ctrl + K | Cmd + K |
| **Find/Replace** | Ctrl + F | Cmd + F |
| **Zoom In** | Ctrl + + | Cmd + + |
| **Zoom Out** | Ctrl + - | Cmd + - |
| **Fit to Width** | Ctrl + 0 | Cmd + 0 |

### Chart Selection

| Action | Shortcut |
|--------|----------|
| **Select All** | Ctrl/Cmd + A |
| **Deselect** | Esc |
| **Select Multiple** | Shift + Click |
| **Group Elements** | Ctrl/Cmd + G |
| **Ungroup** | Ctrl/Cmd + Shift + G |

---

## Troubleshooting

### Common Error Messages

#### "Invalid Formula"

**Cause:** Syntax error in calculated field

**Solutions:**
```
❌ Wrong: CASE WHEN price > 100 THEN 'High' END
✅ Right: CASE WHEN price > 100 THEN "High" END
          (double quotes, not single)

❌ Wrong: SUM(price) + freight_value
✅ Right: SUM(price + freight_value)
          OR SUM(price) + SUM(freight_value)
```

---

#### "Configuration Incomplete"

**Cause:** Chart missing required dimension or metric

**Solution:**
- Check Data tab in right panel
- Ensure dimension or metric is added
- Verify data source is connected

---

#### "No data to display"

**Possible Causes:**
1. Date range filter excludes all data
2. Data source has no matching records
3. Field filter too restrictive

**Solutions:**
- Check date range (expand to "All Time")
- Verify data source has data (edit data source → preview)
- Remove or relax filters

---

#### "Permission Denied"

**Cause:** Can't access data source or database

**Solutions:**
- Verify database credentials
- Check if data source owner has revoked access
- Re-authenticate PostgreSQL connector

---

#### "Cannot mix aggregated and non-aggregated fields"

**Cause:** Using SUM/AVG/COUNT with non-aggregated fields

**Example:**
```
❌ Wrong: SUM(price) / quantity
✅ Right: SUM(price) / SUM(quantity)
          OR SUM(price / quantity)
```

---

### Performance Issues

#### Dashboard Loads Slowly

**Solutions:**
1. **Limit date range** in data source query
   ```sql
   WHERE order_date >= '2017-01-01'
   AND order_date < '2018-01-01'
   ```

2. **Use data source filters** instead of chart filters

3. **Reduce number of charts** on single page (split into multiple pages)

4. **Pre-aggregate data** in SQL query:
   ```sql
   SELECT
       customer_state,
       DATE_TRUNC('month', order_date) as month,
       SUM(price) as revenue
   FROM orders
   GROUP BY customer_state, month
   ```

5. **Enable data caching** (Resource → Data Source → Enable caching)

---

#### Charts Not Refreshing

**Solutions:**
1. Click **Resource → Refresh Data**
2. Edit data source → Click **"Refresh Fields"**
3. Check cache settings (may need to wait for cache expiry)
4. Force refresh: Add `?nocache=true` to report URL

---

### Data Type Issues

#### Dates Showing as Text

**Solution:**
1. Edit data source
2. Find date field in field list
3. Click field → Change **Type** to "Date" or "Date & Time"
4. Click **"Done"**

---

#### Numbers Showing as Text

**Solution:**
```
# In calculated field, cast to number:
CAST(text_field AS NUMBER)

# Or in data source:
1. Edit data source
2. Click field
3. Change Type to "Number"
```

---

## Quick Wins - Copy-Paste Ready Formulas

### Total Order Value
```
price + freight_value
```

### Month-Year Label
```
CONCAT(MONTH_NAME(order_date), " ", CAST(YEAR(order_date) AS TEXT))
```

### Days Between Dates
```
DATE_DIFF(end_date, start_date)
```

### Percentage Calculation
```
(value / total_value) * 100
```

### Conditional Formatting Label
```
CASE
    WHEN value >= target THEN "✅ Met Target"
    WHEN value >= target * 0.9 THEN "⚠️ Close"
    ELSE "❌ Below Target"
END
```

### Weekend Indicator
```
CASE
    WHEN WEEKDAY(order_date) IN (1, 7) THEN "Weekend"
    ELSE "Weekday"
END
```

### Handle Division by Zero
```
CASE
    WHEN denominator = 0 OR denominator IS NULL THEN 0
    ELSE numerator / denominator
END
```

### Regional Classification (Brazilian States)
```
CASE
    WHEN state IN ("SP", "RJ", "MG", "ES") THEN "Southeast"
    WHEN state IN ("RS", "SC", "PR") THEN "South"
    WHEN state IN ("GO", "MT", "MS", "DF") THEN "Central-West"
    WHEN state IN ("BA", "SE", "AL", "PE", "PB", "RN", "CE", "PI", "MA") THEN "Northeast"
    WHEN state IN ("AM", "RR", "AP", "PA", "TO", "RO", "AC") THEN "North"
    ELSE "Unknown"
END
```

---

## Best Practices Checklist

### Data Source Management
- ☐ Use descriptive names ("Olist Sales 2017" not "Data Source 1")
- ☐ Document data sources with descriptions
- ☐ Create calculated fields at data source level (not chart level)
- ☐ Test formulas before saving
- ☐ Filter data in SQL query when possible

### Formula Writing
- ☐ Use double quotes `"text"` for strings
- ☐ Handle NULL values explicitly (IFNULL, CASE)
- ☐ Add ELSE clause to all CASE statements
- ☐ Use meaningful field names (`total_revenue` not `tot_rev`)
- ☐ Test with sample data before using in production

### Dashboard Design
- ☐ Limit to 5-7 charts per page
- ☐ Use consistent colors and fonts
- ☐ Add titles and context to all charts
- ☐ Test on mobile before sharing
- ☐ Add date range control for user flexibility

---

## Additional Resources

- **Official Docs:** [support.google.com/looker-studio](https://support.google.com/looker-studio)
- **Function Reference:** [support.google.com/looker-studio/table/6379764](https://support.google.com/looker-studio/table/6379764)
- **Community Forum:** [Looker Studio Help Community](https://support.google.com/looker-studio/community)
- **YouTube Channel:** [Google Looker Studio](https://www.youtube.com/@LookerStudio)

---

**Last Updated:** Week 13, November 2025
**PORA Academy - Data Analytics & AI Bootcamp Cohort 5**
