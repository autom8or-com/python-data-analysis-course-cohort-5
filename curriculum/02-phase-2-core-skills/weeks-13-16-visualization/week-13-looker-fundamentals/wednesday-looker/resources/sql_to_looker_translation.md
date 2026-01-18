# SQL to Looker Studio Translation Guide

## Week 13 - Wednesday Resources

**PORA Academy - Data Analytics Bootcamp**

---

## Overview

This guide helps you translate SQL concepts you learned in Weeks 1-12 into Looker Studio equivalents. Think of Looker Studio as a visual SQL query builder with dashboarding capabilities.

---

## Table of Contents

1. [Core SQL Concepts](#core-sql-concepts)
2. [Data Selection](#data-selection)
3. [Filtering Data](#filtering-data)
4. [Aggregations](#aggregations)
5. [Grouping](#grouping)
6. [Joins](#joins)
7. [Date Operations](#date-operations)
8. [String Operations](#string-operations)
9. [Conditional Logic](#conditional-logic)
10. [Common Queries Translated](#common-queries-translated)

---

## Core SQL Concepts

### SELECT Statement → Data Source + Chart Configuration

**SQL Approach:**
```sql
SELECT
    customer_state,          -- What data to show
    SUM(price) as revenue    -- What to calculate
FROM olist_orders            -- Where data comes from
WHERE order_status = 'delivered'  -- Conditions
GROUP BY customer_state      -- How to group
ORDER BY revenue DESC        -- How to sort
LIMIT 10;                    -- How many rows
```

**Looker Studio Approach:**
```
┌─────────────────────────────────────────┐
│ DATA SOURCE (Connection)                │
├─────────────────────────────────────────┤
│ FROM: PostgreSQL olist_orders           │
│ WHERE: (Set in SQL query or filters)    │
└─────────────────────────────────────────┘
           ↓
┌─────────────────────────────────────────┐
│ CHART CONFIGURATION                     │
├─────────────────────────────────────────┤
│ Dimension: customer_state (GROUP BY)    │
│ Metric: SUM(price) (SELECT SUM)         │
│ Sort By: Revenue DESC (ORDER BY)        │
│ Rows: 10 (LIMIT)                        │
└─────────────────────────────────────────┘
```

---

## Data Selection

### Selecting Columns

**SQL:**
```sql
SELECT
    order_id,
    customer_id,
    price
FROM orders;
```

**Looker Studio:**
1. Create data source with custom query (same SQL)
2. OR select individual fields in chart Data tab
3. Add as Dimensions (for IDs) or Metrics (for price)

### SELECT * (All Columns)

**SQL:**
```sql
SELECT * FROM orders;
```

**Looker Studio:**
- Data Source: Use table selection (not custom query)
- Chart: Add all fields from field list
- **Better:** Only select fields you need for performance

### Calculated Columns

**SQL:**
```sql
SELECT
    price,
    freight_value,
    price + freight_value AS total_value
FROM orders;
```

**Looker Studio:**
```
Create calculated field:
────────────────────────
Name: total_value
Formula: price + freight_value
```

---

## Filtering Data

### WHERE Clause → Filters

**SQL:**
```sql
SELECT *
FROM orders
WHERE customer_state = 'SP'
    AND price > 100;
```

**Looker Studio - Option 1: Data Source Level (Recommended)**
```sql
-- Include in custom query
SELECT *
FROM orders
WHERE customer_state = 'SP'
    AND price > 100;
```

**Looker Studio - Option 2: Chart Level Filter**
```
In Chart Data tab:
─────────────────────────
Add Filter:
  customer_state = SP

Add Filter:
  price > 100
```

**Looker Studio - Option 3: User-Controlled Filter**
```
Insert → Control → Drop-down list
Configure:
  Field: customer_state
  (User can select SP, RJ, MG, etc.)
```

### IN Operator

**SQL:**
```sql
WHERE customer_state IN ('SP', 'RJ', 'MG')
```

**Looker Studio Calculated Field:**
```
Formula:
customer_state IN ("SP", "RJ", "MG")
```

**Looker Studio Filter:**
```
Filter settings:
  Include: SP, RJ, MG
```

### BETWEEN

**SQL:**
```sql
WHERE price BETWEEN 50 AND 150
```

**Looker Studio Filter:**
```
Filter type: Range
  Minimum: 50
  Maximum: 150
```

**Looker Studio Formula:**
```
price >= 50 AND price <= 150
```

### LIKE (Pattern Matching)

**SQL:**
```sql
WHERE product_name LIKE '%phone%'
```

**Looker Studio:**
```
Filter:
  Field: product_name
  Condition: Contains
  Value: phone
```

**OR in calculated field:**
```
REGEXP_MATCH(product_name, ".*phone.*")
```

---

## Aggregations

### Aggregation Functions

| SQL | Looker Studio | Example |
|-----|---------------|---------|
| `COUNT(*)` | `Record Count` | Auto-created metric |
| `COUNT(order_id)` | `COUNT(order_id)` | Count specific field |
| `COUNT(DISTINCT customer_id)` | `COUNT_DISTINCT(customer_id)` | Unique customers |
| `SUM(price)` | `SUM(price)` | Total revenue |
| `AVG(price)` | `AVG(price)` | Average price |
| `MIN(price)` | `MIN(price)` | Minimum price |
| `MAX(price)` | `MAX(price)` | Maximum price |

### Example: Total Revenue

**SQL:**
```sql
SELECT SUM(price) as total_revenue
FROM orders;
```

**Looker Studio:**
```
Chart: Scorecard
─────────────────
Metric: SUM(price)
(Rename to "Total Revenue" in Style tab)
```

### Example: Average Order Value

**SQL:**
```sql
SELECT AVG(price) as avg_order_value
FROM orders;
```

**Looker Studio:**
```
Chart: Scorecard
─────────────────
Metric: AVG(price)
```

---

## Grouping

### GROUP BY → Dimensions

**SQL:**
```sql
SELECT
    customer_state,
    COUNT(*) as order_count
FROM orders
GROUP BY customer_state;
```

**Looker Studio:**
```
Chart: Table or Bar Chart
─────────────────────────
Dimension: customer_state  (this is GROUP BY!)
Metric: Record Count       (this is COUNT(*))
```

### Multiple GROUP BY

**SQL:**
```sql
SELECT
    customer_state,
    EXTRACT(YEAR FROM order_date) as year,
    SUM(price) as revenue
FROM orders
GROUP BY customer_state, year;
```

**Looker Studio:**
```
First, create calculated field:
────────────────────────────────
Name: order_year
Formula: YEAR(order_date)

Then configure chart:
────────────────────────────────
Dimensions:
  1. customer_state
  2. order_year
Metric: SUM(price)
```

---

## Joins

### INNER JOIN → Blended Data or Custom Query

**SQL:**
```sql
SELECT
    o.order_id,
    c.customer_state,
    SUM(oi.price) as revenue
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY o.order_id, c.customer_state;
```

**Looker Studio - Option 1: Custom Query (Recommended)**
```sql
-- Use same SQL in data source creation
-- "Use a custom query" checkbox
-- Paste entire JOIN query
```

**Looker Studio - Option 2: Data Blending**
```
1. Create two data sources:
   - Data Source 1: orders + customers
   - Data Source 2: order_items

2. In report, select chart
3. Click "Blend Data" button
4. Configure join:
   - Left Source: Data Source 1
   - Right Source: Data Source 2
   - Join key: order_id = order_id
   - Join type: Inner
```

**Recommendation:** Use custom query for better performance.

### LEFT JOIN

**SQL:**
```sql
SELECT
    c.customer_id,
    c.customer_state,
    COUNT(o.order_id) as order_count
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_state;
```

**Looker Studio:**
```
Data Blending:
────────────────
Join type: Left Outer
Left table: customers
Right table: orders
Join condition: customer_id = customer_id

Metrics will show:
- All customers (even with 0 orders)
- Order count (0 for customers with no orders)
```

---

## Date Operations

### Date Extraction

| SQL | Looker Studio |
|-----|---------------|
| `EXTRACT(YEAR FROM date)` | `YEAR(date)` |
| `EXTRACT(MONTH FROM date)` | `MONTH(date)` |
| `EXTRACT(DAY FROM date)` | `DAY(date)` |
| `EXTRACT(QUARTER FROM date)` | `QUARTER(date)` |
| `EXTRACT(DOW FROM date)` | `WEEKDAY(date)` |

### Example: Sales by Month

**SQL:**
```sql
SELECT
    EXTRACT(MONTH FROM order_date) as month,
    SUM(price) as revenue
FROM orders
WHERE EXTRACT(YEAR FROM order_date) = 2017
GROUP BY month
ORDER BY month;
```

**Looker Studio:**
```
Create calculated fields:
────────────────────────────────
1. Name: order_month
   Formula: MONTH(order_date)

2. Name: order_year
   Formula: YEAR(order_date)

Configure chart:
────────────────────────────────
Chart type: Time Series or Bar
Dimension: order_month
Metric: SUM(price)
Filter: order_year = 2017
Sort: order_month ascending
```

### Date Difference

**SQL:**
```sql
SELECT
    order_id,
    order_delivered_date - order_purchase_date as delivery_days
FROM orders;
```

**Looker Studio:**
```
Calculated field:
────────────────────────────────
Name: delivery_days
Formula: DATE_DIFF(order_delivered_date,
                   order_purchase_date)
```

### Date Truncation

**SQL:**
```sql
SELECT
    DATE_TRUNC('month', order_date) as month,
    SUM(price) as revenue
FROM orders
GROUP BY month;
```

**Looker Studio:**
```
Dimension configuration:
────────────────────────────────
Field: order_date
Type: Date
Default date range: Month
```

**OR use order_date directly and Looker auto-groups by month/week/day based on date range.**

---

## String Operations

### CONCAT

**SQL:**
```sql
SELECT
    first_name || ' ' || last_name as full_name
FROM customers;
```

**Looker Studio:**
```
Name: full_name
Formula: CONCAT(first_name, " ", last_name)
```

### UPPER / LOWER

**SQL:**
```sql
SELECT UPPER(customer_state) FROM customers;
```

**Looker Studio:**
```
Formula: UPPER(customer_state)
```

### SUBSTRING

**SQL:**
```sql
SELECT SUBSTR(zip_code, 1, 2) as zip_prefix
FROM customers;
```

**Looker Studio:**
```
Formula: SUBSTR(zip_code, 1, 2)
```

---

## Conditional Logic

### CASE WHEN → CASE Statement

**SQL:**
```sql
SELECT
    order_id,
    CASE
        WHEN price < 50 THEN 'Budget'
        WHEN price >= 50 AND price < 150 THEN 'Mid-Range'
        ELSE 'Premium'
    END as price_tier
FROM orders;
```

**Looker Studio:**
```
Name: price_tier
Formula:
CASE
    WHEN price < 50 THEN "Budget"
    WHEN price >= 50 AND price < 150 THEN "Mid-Range"
    ELSE "Premium"
END
```

**Key Differences:**
- SQL: Single quotes `'text'`
- Looker: Double quotes `"text"`

### Conditional Aggregation

**SQL:**
```sql
SELECT
    COUNT(CASE WHEN order_status = 'delivered' THEN 1 END) as delivered_orders,
    COUNT(CASE WHEN order_status = 'cancelled' THEN 1 END) as cancelled_orders
FROM orders;
```

**Looker Studio:**
```
Create calculated metrics:
────────────────────────────────
1. Name: delivered_orders
   Formula: COUNT(CASE WHEN order_status = "delivered" THEN 1 END)

2. Name: cancelled_orders
   Formula: COUNT(CASE WHEN order_status = "cancelled" THEN 1 END)
```

---

## Common Queries Translated

### Query 1: Top 10 States by Revenue

**SQL:**
```sql
SELECT
    customer_state,
    SUM(price) as revenue,
    COUNT(*) as order_count
FROM orders
GROUP BY customer_state
ORDER BY revenue DESC
LIMIT 10;
```

**Looker Studio:**
```
Chart: Table or Bar Chart
────────────────────────────────
Dimensions: customer_state
Metrics:
  - SUM(price)
  - Record Count
Sort: SUM(price) descending
Rows to display: 10
```

---

### Query 2: Monthly Sales Trend

**SQL:**
```sql
SELECT
    DATE_TRUNC('month', order_date) as month,
    SUM(price) as revenue
FROM orders
WHERE order_date >= '2017-01-01'
GROUP BY month
ORDER BY month;
```

**Looker Studio:**
```
Chart: Time Series
────────────────────────────────
Dimension: order_date (set to Month granularity)
Metric: SUM(price)
Date Range: Jan 1, 2017 - Dec 31, 2017
```

---

### Query 3: Customer Segmentation

**SQL:**
```sql
SELECT
    CASE
        WHEN total_spent > 500 THEN 'VIP'
        WHEN total_spent >= 100 THEN 'Regular'
        ELSE 'New'
    END as customer_tier,
    COUNT(*) as customer_count
FROM (
    SELECT
        customer_id,
        SUM(price) as total_spent
    FROM orders
    GROUP BY customer_id
) customer_totals
GROUP BY customer_tier;
```

**Looker Studio:**
```
Step 1: Create data source with aggregated query
────────────────────────────────
SELECT
    customer_id,
    SUM(price) as total_spent
FROM orders
GROUP BY customer_id

Step 2: Create calculated dimension
────────────────────────────────
Name: customer_tier
Formula:
CASE
    WHEN total_spent > 500 THEN "VIP"
    WHEN total_spent >= 100 THEN "Regular"
    ELSE "New"
END

Step 3: Create chart
────────────────────────────────
Chart: Pie Chart or Bar Chart
Dimension: customer_tier
Metric: Record Count
```

---

### Query 4: Year-over-Year Comparison

**SQL:**
```sql
SELECT
    customer_state,
    SUM(CASE WHEN EXTRACT(YEAR FROM order_date) = 2017 THEN price ELSE 0 END) as revenue_2017,
    SUM(CASE WHEN EXTRACT(YEAR FROM order_date) = 2018 THEN price ELSE 0 END) as revenue_2018
FROM orders
WHERE EXTRACT(YEAR FROM order_date) IN (2017, 2018)
GROUP BY customer_state;
```

**Looker Studio:**
```
Option 1: Use Time Series with comparison
────────────────────────────────
Chart: Time Series
Dimension: order_date
Metric: SUM(price)
Comparison: Previous year

Option 2: Create calculated metrics
────────────────────────────────
Name: revenue_2017
Formula:
CASE
    WHEN YEAR(order_date) = 2017 THEN price
    ELSE 0
END

Name: revenue_2018
Formula:
CASE
    WHEN YEAR(order_date) = 2018 THEN price
    ELSE 0
END

Chart: Table
Dimension: customer_state
Metrics: SUM(revenue_2017), SUM(revenue_2018)
```

---

### Query 5: Running Total (Cumulative Sum)

**SQL (Window Function):**
```sql
SELECT
    order_date,
    price,
    SUM(price) OVER (ORDER BY order_date) as running_total
FROM orders
ORDER BY order_date;
```

**Looker Studio:**
```
Chart: Time Series
────────────────────────────────
Dimension: order_date
Metric: SUM(price)

In Style tab:
  Enable "Running total" or "Cumulative"
```

**OR Create Calculated Metric:**
```
Name: running_total
Formula: RUNNING_SUM(price)
```

---

## Key Differences Summary

| Aspect | SQL | Looker Studio |
|--------|-----|---------------|
| **String literals** | Single quotes `'text'` | Double quotes `"text"` |
| **Concatenation** | `\|\|` or `CONCAT()` | `CONCAT()` only |
| **Date extraction** | `EXTRACT(YEAR FROM date)` | `YEAR(date)` |
| **Grouping** | `GROUP BY column` | Add field to Dimensions |
| **Aggregation** | `SELECT SUM(column)` | Add `SUM(column)` to Metrics |
| **Filtering** | `WHERE condition` | Chart filters or data source filters |
| **Sorting** | `ORDER BY column` | Sort settings in chart |
| **Limiting rows** | `LIMIT 10` | "Rows to display" setting |
| **Joins** | `JOIN tables ON condition` | Data blending or custom query |
| **Subqueries** | Nested `SELECT` | Not supported (use custom query) |
| **Window functions** | `OVER (PARTITION BY...)` | Limited (use running total features) |

---

## Best Practices

### When to Use SQL (Custom Query)

✅ Use custom query when you need:
- Complex joins (3+ tables)
- Pre-aggregated data for performance
- Subqueries or CTEs
- Specific WHERE clause filtering
- Data transformation before visualization

**Example:**
```sql
-- Pre-aggregate for performance
SELECT
    customer_state,
    DATE_TRUNC('month', order_date) as month,
    COUNT(DISTINCT customer_id) as customers,
    SUM(price) as revenue,
    AVG(price) as avg_order_value
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
WHERE order_status = 'delivered'
    AND order_date >= '2017-01-01'
GROUP BY customer_state, month;
```

### When to Use Looker Calculated Fields

✅ Use calculated fields when you need:
- Business logic reusable across charts
- Categorization (CASE statements)
- Simple arithmetic (price + freight)
- Date extractions (year, month, quarter)
- Formatting (concatenation, text manipulation)

---

## Migration Checklist

When converting SQL queries to Looker Studio:

```
☐ Identify FROM clause → Data source selection
☐ Identify SELECT columns → Chart dimensions and metrics
☐ Identify WHERE clause → Data source query or filters
☐ Identify GROUP BY → Chart dimensions
☐ Identify aggregations (SUM, AVG, COUNT) → Chart metrics
☐ Identify calculated columns → Calculated fields
☐ Identify CASE statements → Calculated fields with CASE
☐ Identify ORDER BY → Chart sort settings
☐ Identify LIMIT → Rows to display setting
☐ Identify JOINs → Custom query or data blending
☐ Test with sample data to verify accuracy
```

---

## Practice Exercise

**SQL Query:**
```sql
SELECT
    c.customer_state,
    EXTRACT(MONTH FROM o.order_date) as month,
    COUNT(DISTINCT o.order_id) as order_count,
    SUM(oi.price) as revenue,
    AVG(oi.price) as avg_order_value
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered'
    AND EXTRACT(YEAR FROM o.order_date) = 2017
GROUP BY c.customer_state, month
HAVING COUNT(*) > 100
ORDER BY revenue DESC
LIMIT 20;
```

**Your Task:** Translate to Looker Studio
1. What would you put in the custom query?
2. What calculated fields would you create?
3. What chart type would you use?
4. How would you configure dimensions and metrics?

**Answer in solutions file.**

---

**Remember:** Looker Studio is a visual layer on top of your SQL data. Understanding how SQL concepts map to Looker features helps you build dashboards faster and more effectively!

---

**Last Updated:** Week 13, November 2025
**PORA Academy - Data Analytics & AI Bootcamp Cohort 5**
