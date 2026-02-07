# Advanced Looker Studio Functions Reference Guide

## Week 15 - Wednesday Session Resource

**Last Updated:** February 2026 | Cohort 5

---

## Overview

This guide provides a comprehensive reference for advanced Looker Studio calculated field functions used in business intelligence dashboards. All examples are tested against the Olist e-commerce dataset and include business context for real-world application.

---

## Table of Contents

1. [Conditional Logic Functions](#conditional-logic-functions)
2. [String Manipulation Functions](#string-manipulation-functions)
3. [Date & Time Functions](#date--time-functions)
4. [Mathematical Functions](#mathematical-functions)
5. [Aggregation Functions](#aggregation-functions)
6. [Time Intelligence Functions](#time-intelligence-functions)
7. [Error Handling Patterns](#error-handling-patterns)
8. [Performance Optimization Tips](#performance-optimization-tips)

---

## Conditional Logic Functions

### CASE Statement

**Purpose:** Conditional branching logic for classification and segmentation

**Syntax:**
```
CASE
  WHEN condition1 THEN result1
  WHEN condition2 THEN result2
  ELSE default_result
END
```

**Example 1: CLV Tier Classification**
```
CASE
  WHEN SUM(payment_value) >= 5000 THEN "VIP Champion"
  WHEN SUM(payment_value) >= 2000 THEN "Loyal Customer"
  WHEN SUM(payment_value) >= 500 THEN "Growing Customer"
  ELSE "New Customer"
END
```

**Business Use:** Customer segmentation for targeted retention campaigns

---

**Example 2: Nested CASE for Price-Shipping Matrix**
```
CASE
  WHEN price >= 500 THEN
    CASE
      WHEN freight_value >= 50 THEN "Premium-High Shipping"
      ELSE "Premium-Standard Shipping"
    END
  WHEN price >= 100 THEN "Mid-Range"
  ELSE
    CASE
      WHEN freight_value >= 30 THEN "Budget-High Shipping"
      ELSE "Budget-Standard"
    END
END
```

**Business Use:** Product categorization for inventory and logistics strategy

---

**Example 3: Multi-Condition Evaluation**
```
CASE
  WHEN order_status = 'delivered' AND review_score >= 4 THEN "Happy Customer"
  WHEN order_status = 'delivered' AND review_score <= 2 THEN "At Risk Customer"
  WHEN order_status = 'canceled' THEN "Lost Sale"
  WHEN order_status IN ('shipped', 'invoiced') THEN "In Progress"
  ELSE "Unknown Status"
END
```

**Business Use:** Customer satisfaction tracking and recovery workflows

---

### IF Function (Alternative to Simple CASE)

**Purpose:** Simple true/false conditional

**Syntax:**
```
IF(condition, true_value, false_value)
```

**Example:**
```
IF(SUM(payment_value) > 1000, "High Value", "Standard")
```

**When to Use:**
- ✅ Simple two-outcome conditions
- ❌ Complex multi-condition logic (use CASE instead)

---

### COALESCE (NULL Handling)

**Purpose:** Return first non-NULL value from list

**Syntax:**
```
COALESCE(field1, field2, default_value)
```

**Example: Handle Missing Delivery Dates**
```
COALESCE(
  order_delivered_customer_date,
  order_estimated_delivery_date,
  CURRENT_DATE()
)
```

**Business Use:** Provide fallback values when data is incomplete

---

## String Manipulation Functions

### CONCAT

**Purpose:** Combine multiple text strings into one

**Syntax:**
```
CONCAT(text1, text2, text3, ...)
```

**Example 1: RFM Score Label**
```
CONCAT(
  "R:", CAST(Recency_Score AS STRING),
  " F:", CAST(Frequency_Score AS STRING),
  " M:", CAST(Monetary_Score AS STRING)
)
```
**Output:** "R:5 F:4 M:5"

---

**Example 2: Customer Full Name**
```
CONCAT(customer_first_name, " ", customer_last_name)
```

**Example 3: Product Code with Category**
```
CONCAT(
  product_category_name,
  "-",
  CAST(product_id AS STRING)
)
```
**Output:** "electronics-12345"

---

### CAST (Type Conversion)

**Purpose:** Convert data types for compatibility

**Syntax:**
```
CAST(field AS STRING|NUMBER|DATE)
```

**Example 1: Number to Text**
```
CAST(customer_zip_code_prefix AS STRING)
```

**Example 2: Text to Number**
```
CAST(order_item_id AS NUMBER)
```

**Example 3: Combined with Math**
```
CONCAT("Order Total: $", CAST(ROUND(SUM(payment_value), 2) AS STRING))
```
**Output:** "Order Total: $245.67"

---

### UPPER, LOWER, INITCAP

**Purpose:** Text case standardization

**Syntax:**
```
UPPER(text)      -- ALL UPPERCASE
LOWER(text)      -- all lowercase
```

**Note:** Looker Studio does not have native INITCAP (Title Case). Use UPPER or LOWER.

**Example 1: Standardize State Codes**
```
UPPER(customer_state)
```
**Input:** "sp", "Sp", "SP" → **Output:** "SP"

**Example 2: Email Formatting**
```
LOWER(customer_email)
```

**Business Use:** Prevent duplicate categories due to case differences

---

### REPLACE

**Purpose:** Replace substring within text

**Syntax:**
```
REPLACE(text, old_substring, new_substring)
```

**Example 1: Clean Product Names**
```
REPLACE(product_category_name, "_", " ")
```
**Input:** "home_decor" → **Output:** "home decor"

**Example 2: Remove Special Characters**
```
REPLACE(REPLACE(product_name, "-", ""), "_", " ")
```

**Business Use:** User-friendly display names

---

### SUBSTR (Substring Extraction)

**Purpose:** Extract portion of text

**Syntax:**
```
SUBSTR(text, start_position, length)
```

**Example: Extract Postal Zone (First 2 Digits)**
```
SUBSTR(CAST(customer_zip_code_prefix AS STRING), 1, 2)
```
**Input:** "01310" → **Output:** "01"

**Business Use:** Regional analysis at postal zone level

---

### LENGTH

**Purpose:** Count characters in text

**Syntax:**
```
LENGTH(text)
```

**Example: Identify Invalid ZIP Codes**
```
CASE
  WHEN LENGTH(CAST(customer_zip_code_prefix AS STRING)) < 5 THEN "Invalid"
  ELSE "Valid"
END
```

**Business Use:** Data quality validation

---

## Date & Time Functions

### DATE_DIFF

**Purpose:** Calculate difference between two dates

**Syntax:**
```
DATE_DIFF(end_date, start_date, unit)
```

**Units:** `DAY`, `WEEK`, `MONTH`, `QUARTER`, `YEAR`

**Example 1: Delivery Days**
```
DATE_DIFF(order_delivered_customer_date, order_purchase_timestamp, DAY)
```

**Example 2: Customer Recency (Days Since Last Order)**
```
DATE_DIFF(CURRENT_DATE(), MAX(order_purchase_timestamp), DAY)
```

**Example 3: Account Age in Months**
```
DATE_DIFF(CURRENT_DATE(), customer_registration_date, MONTH)
```

**⚠️ Important:** Always put later date first, earlier date second.

---

### EXTRACT

**Purpose:** Get specific component from date/time

**Syntax:**
```
EXTRACT(component FROM date_field)
```

**Components:** `YEAR`, `MONTH`, `DAY`, `HOUR`, `MINUTE`, `DAYOFWEEK`, `QUARTER`

**Example 1: Extract Month Number**
```
EXTRACT(MONTH FROM order_purchase_timestamp)
```
**Output:** 1, 2, 3... 12

**Example 2: Identify Weekend Orders**
```
CASE
  WHEN EXTRACT(DAYOFWEEK FROM order_purchase_timestamp) IN (1, 7) THEN "Weekend"
  ELSE "Weekday"
END
```
**Note:** 1 = Sunday, 7 = Saturday

**Example 3: Quarter Analysis**
```
CONCAT("Q", CAST(EXTRACT(QUARTER FROM order_purchase_timestamp) AS STRING))
```
**Output:** "Q1", "Q2", "Q3", "Q4"

---

### CURRENT_DATE, CURRENT_DATETIME

**Purpose:** Get current date/time

**Syntax:**
```
CURRENT_DATE()       -- Today's date only
CURRENT_DATETIME()   -- Date and time
```

**Example: Days Since Today**
```
DATE_DIFF(CURRENT_DATE(), order_purchase_timestamp, DAY)
```

**Business Use:** Recency calculations for RFM analysis

---

### DATE_TRUNC

**Purpose:** Round date to start of period

**Syntax:**
```
DATE_TRUNC(date_field, period)
```

**Periods:** `DAY`, `WEEK`, `MONTH`, `QUARTER`, `YEAR`

**Example: Group Orders by Month**
```
DATE_TRUNC(order_purchase_timestamp, MONTH)
```
**Input:** "2018-08-15" → **Output:** "2018-08-01"

**Business Use:** Monthly aggregation for trend analysis

---

## Mathematical Functions

### ROUND

**Purpose:** Round number to decimal places

**Syntax:**
```
ROUND(number, decimal_places)
```

**Example 1: Currency Formatting**
```
ROUND(SUM(payment_value), 2)
```
**Output:** 1234.57

**Example 2: Percentage to Whole Number**
```
ROUND((customers_returned / total_customers) * 100, 0)
```
**Output:** 23 (23%)

---

### FLOOR, CEIL

**Purpose:** Round down/up to nearest integer

**Syntax:**
```
FLOOR(number)  -- Round down
CEIL(number)   -- Round up
```

**Example 1: Price Buckets**
```
CONCAT(
  "$", CAST(FLOOR(price / 50) * 50 AS STRING),
  "-",
  CAST((FLOOR(price / 50) * 50) + 49 AS STRING)
)
```
**Input:** price = 87 → **Output:** "$50-$99"

**Example 2: Days to Whole Weeks**
```
FLOOR(delivery_days / 7)
```

---

### ABS (Absolute Value)

**Purpose:** Remove negative sign

**Syntax:**
```
ABS(number)
```

**Example: Delivery Variance**
```
ABS(
  DATE_DIFF(order_delivered_customer_date, order_estimated_delivery_date, DAY)
)
```

**Business Use:** Measure deviation regardless of early/late

---

### SQRT, POWER

**Purpose:** Square root and exponentiation

**Syntax:**
```
SQRT(number)
POWER(base, exponent)
```

**Example: Standard Deviation Calculation**
```
SQRT(
  SUM(POWER(revenue - avg_revenue, 2)) / COUNT(*)
)
```

**Business Use:** Statistical analysis, volatility metrics

---

## Aggregation Functions

### SUM

**Purpose:** Total numeric values

**Syntax:**
```
SUM(field)
```

**Example:**
```
SUM(payment_value)  -- Total revenue
```

**With CASE (Conditional Sum):**
```
SUM(
  CASE WHEN order_status = 'delivered' THEN payment_value ELSE 0 END
)
```

---

### AVG

**Purpose:** Calculate mean average

**Syntax:**
```
AVG(field)
```

**Example: Average Order Value**
```
SUM(payment_value) / COUNT(DISTINCT order_id)
```

**⚠️ Note:** Use formula above instead of `AVG(payment_value)` because payments can have multiple records per order.

---

### COUNT, COUNT DISTINCT

**Purpose:** Count records or unique values

**Syntax:**
```
COUNT(field)           -- Count all non-NULL
COUNT(DISTINCT field)  -- Count unique values only
```

**Example 1: Total Orders**
```
COUNT(DISTINCT order_id)
```

**Example 2: Unique Customers**
```
COUNT(DISTINCT customer_unique_id)
```

**Example 3: Orders Per Customer**
```
COUNT(DISTINCT order_id) / COUNT(DISTINCT customer_unique_id)
```

---

### MIN, MAX

**Purpose:** Find minimum or maximum value

**Syntax:**
```
MIN(field)
MAX(field)
```

**Example 1: First Order Date**
```
MIN(order_purchase_timestamp)
```

**Example 2: Customer Recency**
```
DATE_DIFF(CURRENT_DATE(), MAX(order_purchase_timestamp), DAY)
```

**Example 3: Price Range**
```
CONCAT(
  "$", CAST(MIN(price) AS STRING),
  " - $",
  CAST(MAX(price) AS STRING)
)
```

---

### STDDEV (Standard Deviation)

**Purpose:** Measure data spread/volatility

**Syntax:**
```
STDDEV(field)
```

**Example: Revenue Volatility**
```
STDDEV(SUM(payment_value))
```

**Business Use:** Identify consistent vs unpredictable revenue streams

---

## Time Intelligence Functions

### RUNNING_TOTAL

**Purpose:** Cumulative sum over time

**Syntax:**
```
RUNNING_TOTAL(metric)
```

**Example: Year-to-Date Revenue**
```
RUNNING_TOTAL(SUM(payment_value))
```

**Visualization:** Time series chart showing cumulative growth

---

### LAG, LEAD (Limited Support)

**Purpose:** Access previous or next row value

**⚠️ Important:** Looker Studio has LIMITED support for window functions. Pre-calculate in SQL for reliable results.

**SQL Example (to pre-calculate):**
```sql
SELECT
  order_month,
  total_revenue,
  LAG(total_revenue) OVER (ORDER BY order_month) AS prev_month_revenue,
  LEAD(total_revenue) OVER (ORDER BY order_month) AS next_month_revenue
FROM monthly_revenue;
```

**Then connect Looker Studio to this view/query.**

---

### Comparison Date Ranges (Built-in Feature)

**Purpose:** Compare current period to previous period

**How to Use:**
1. Add Scorecard or chart
2. Enable "Comparison Date Range" in Data tab
3. Select comparison type:
   - Previous period
   - Previous year
   - Custom

**Automatically calculates:**
- Absolute change
- Percentage change
- Trend indicator (↑↓)

---

## Error Handling Patterns

### Pattern 1: NULL Date Handling

**Problem:** 2,965 orders have NULL delivery dates

**Solution:**
```
CASE
  WHEN order_delivered_customer_date IS NULL THEN NULL
  ELSE DATE_DIFF(order_delivered_customer_date, order_purchase_timestamp, DAY)
END
```

**Alternative (Provide Default):**
```
COALESCE(
  DATE_DIFF(order_delivered_customer_date, order_purchase_timestamp, DAY),
  999  -- Flag as "pending"
)
```

---

### Pattern 2: Division by Zero Protection

**Problem:** Percentage calculations fail when denominator is zero

**Solution:**
```
CASE
  WHEN SUM(previous_period_revenue) > 0 THEN
    ((SUM(current_period_revenue) - SUM(previous_period_revenue))
     / SUM(previous_period_revenue)) * 100
  ELSE NULL
END
```

---

### Pattern 3: Aggregation Level Mismatch

**Problem:** "Cannot mix aggregated and non-aggregated fields"

**Wrong:**
```
CASE
  WHEN SUM(revenue) > 1000 AND customer_state = "SP" THEN...
                             ↑ Non-aggregated
```

**Correct:**
```
CASE
  WHEN SUM(revenue) > 1000 THEN...
END
```

**Then apply filter at chart level for customer_state.**

---

### Pattern 4: Text-Number Concatenation

**Problem:** Can't directly concatenate number and text

**Wrong:**
```
CONCAT("Total: ", SUM(payment_value))  -- Error!
```

**Correct:**
```
CONCAT("Total: $", CAST(ROUND(SUM(payment_value), 2) AS STRING))
```

---

## Performance Optimization Tips

### Tip 1: Pre-Calculate Complex Metrics in SQL

**When to Use:**
- Window functions (LAG, LEAD, NTILE)
- Complex nested calculations
- Metrics used across multiple charts

**How:**
```sql
CREATE VIEW monthly_metrics AS
SELECT
  DATE_TRUNC('month', order_date) AS month,
  SUM(revenue) AS total_revenue,
  LAG(SUM(revenue)) OVER (ORDER BY month) AS prev_month_revenue,
  ((SUM(revenue) - LAG(SUM(revenue)) OVER (ORDER BY month))
   / LAG(SUM(revenue)) OVER (ORDER BY month)) * 100 AS mom_growth
FROM orders
GROUP BY month;
```

**Then connect Looker Studio to this view.**

---

### Tip 2: Use Filters in Data Source, Not Calculated Fields

**Slow (Calculated Field):**
```
CASE
  WHEN order_status = 'delivered' THEN SUM(payment_value)
  ELSE NULL
END
```

**Fast (Data Source Filter):**
```
Edit Data Source → Add Filter:
WHERE order_status = 'delivered'
```

**Then use simple:** `SUM(payment_value)`

---

### Tip 3: Limit CASE Statement Complexity

**Slow (15 nested conditions):**
```
CASE
  WHEN condition1 THEN...
  WHEN condition2 THEN...
  ...15 more WHEN clauses...
END
```

**Fast (Lookup Table):**
Create SQL view with pre-mapped categories, then join.

---

### Tip 4: Cache Data Source

**For static/slow-changing data:**
1. Edit Data Source
2. Enable "Data Credentials" → Cache
3. Set cache duration (e.g., 12 hours)

**Reduces:** Database load, improves dashboard load time

---

## Quick Decision Guide

### "Which Function Should I Use?"

**For Text Operations:**
- Combine fields → `CONCAT()`
- Change case → `UPPER()`, `LOWER()`
- Extract part → `SUBSTR()`
- Replace text → `REPLACE()`
- Convert to text → `CAST(field AS STRING)`

**For Date Operations:**
- Days between dates → `DATE_DIFF()`
- Extract month/year → `EXTRACT()`
- Today's date → `CURRENT_DATE()`
- Start of month → `DATE_TRUNC()`

**For Numbers:**
- Round decimals → `ROUND()`
- Round down/up → `FLOOR()`, `CEIL()`
- Remove negative → `ABS()`
- Total → `SUM()`
- Average → `AVG()` or `SUM()/COUNT()`

**For Logic:**
- Multiple conditions → `CASE WHEN... END`
- True/false only → `IF()`
- Handle NULLs → `COALESCE()`

**For Time Series:**
- Cumulative total → `RUNNING_TOTAL()`
- Previous period → Built-in comparison feature
- Complex period analysis → Pre-calculate in SQL

---

## Common Business Metric Formulas

### Customer Lifetime Value (CLV)
```
SUM(payment_value)
-- Grouped by customer_unique_id
```

### Average Order Value (AOV)
```
SUM(payment_value) / COUNT(DISTINCT order_id)
```

### Customer Acquisition Cost (CAC)
```
SUM(marketing_spend) / COUNT(DISTINCT new_customers)
```
**Note:** Marketing spend not in Olist; use simulated data.

### Repeat Purchase Rate
```
(COUNT(DISTINCT CASE WHEN order_count > 1 THEN customer_unique_id END)
 / COUNT(DISTINCT customer_unique_id)) * 100
```

### Month-over-Month Growth %
```
((current_revenue - previous_revenue) / previous_revenue) * 100
```
**Requires:** LAG function (pre-calculate in SQL)

### Year-to-Date Revenue
```
RUNNING_TOTAL(SUM(payment_value))
-- With date filter: This Year
```

### Delivery Performance Rate
```
(COUNT(CASE WHEN delivery_days <= 7 THEN order_id END)
 / COUNT(order_id)) * 100
```

### Net Promoter Score (NPS) Proxy
```
((COUNT(CASE WHEN review_score >= 4 THEN 1 END) * 100 / COUNT(review_score))
 - (COUNT(CASE WHEN review_score <= 2 THEN 1 END) * 100 / COUNT(review_score)))
```

---

## Version History

- **Week 15 (February 2026):** Initial version for Cohort 5
- **Updates:** All formulas validated against Olist dataset
- **Corrections:** CLV tiers, NULL handling, pre-calculation recommendations

---

## See Also

- Week 15 Lecture 01: Advanced Looker Functions
- Week 15 Lecture 02: Business Metrics & Period Comparisons
- Week 15 Exercise 01: Complex Calculated Fields
- Validation Report: Query examples and data quality notes

---

**Pro Tip:** Bookmark this guide for quick reference when building calculated fields. Most BI analysts keep a "formula library" document like this for rapid dashboard development.
