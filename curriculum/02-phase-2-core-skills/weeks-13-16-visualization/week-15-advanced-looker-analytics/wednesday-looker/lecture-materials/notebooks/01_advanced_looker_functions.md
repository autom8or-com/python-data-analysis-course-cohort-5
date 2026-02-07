# Advanced Looker Studio Functions for Business Intelligence

## Week 15 - Wednesday Session - Part 1

### Duration: 15-20 minutes

---

## What Are Advanced Calculated Fields?

**Advanced Calculated Fields** in Looker Studio combine multiple functions, conditions, and business logic into single, reusable metrics. They transform raw data into actionable business insights without writing SQL queries.

### Why Advanced Functions Matter

Think back to your SQL and Python work from Weeks 3-12:

**SQL Approach (Week 3 - Complex CASE Logic):**
```sql
-- Nested CASE for customer lifetime value tiers
SELECT
  customer_unique_id,
  SUM(payment_value) as total_revenue,
  CASE
    WHEN SUM(payment_value) >= 5000 THEN 'VIP Champion'
    WHEN SUM(payment_value) >= 2000 THEN 'Loyal Customer'
    WHEN SUM(payment_value) >= 500 THEN 'Growing Customer'
    ELSE 'New Customer'
  END as clv_tier
FROM olist_customers_dataset c
JOIN olist_orders_dataset o ON c.customer_id = o.customer_id
JOIN olist_order_payments_dataset p ON o.order_id = p.order_id
WHERE o.order_status = 'delivered'
GROUP BY customer_unique_id;
```

**Python Approach (Week 6 - Complex Categorization):**
```python
def categorize_clv(revenue):
    if revenue >= 5000:
        return 'VIP Champion'
    elif revenue >= 2000:
        return 'Loyal Customer'
    elif revenue >= 500:
        return 'Growing Customer'
    else:
        return 'New Customer'

df['clv_tier'] = df['total_revenue'].apply(categorize_clv)
```

**Looker Studio Advanced Calculated Field:**
- No SQL queries needed
- No Python code required
- Business users can understand the logic
- Instant updates across all visualizations
- Reusable across multiple charts

---

## Core Advanced Function Types

### 1. Nested CASE Statements
**Purpose:** Complex multi-condition logic for business categorization

**Use Cases:**
- Customer lifetime value tiers
- Product performance classification
- Risk scoring and segmentation
- Regional performance categories

**Business Context (Olist E-commerce):**
Remember from Week 9 (CLV Analysis) when you calculated customer segments using SQL window functions and NTILE? In Looker Studio, you create the same segmentation visually.

### 2. String Functions for Data Cleaning
**Purpose:** Transform and standardize text data for consistent reporting

**Use Cases:**
- Concatenating customer IDs with names for labels
- Extracting product categories from long descriptions
- Formatting phone numbers or postal codes
- Creating readable segment names

**SQL Equivalent (Week 6 - Text Processing):**
```sql
-- Creating readable RFM segment labels
SELECT
  CONCAT(recency_score::text, frequency_score::text, monetary_score::text) as rfm_score
FROM customer_rfm;
```

### 3. Date-Based Calculated Fields
**Purpose:** Time-based analysis and period comparisons

**Use Cases:**
- Calculate days since last order (recency)
- Determine order age
- Identify weekend vs weekday orders
- Calculate delivery delays

**Connection to Week 5 (Date Calculations):**
```sql
-- SQL version of delivery days calculation
SELECT
  EXTRACT(DAY FROM (order_delivered_customer_date - order_purchase_timestamp)) as delivery_days
FROM olist_orders_dataset;
```

### 4. Mathematical Functions for KPIs
**Purpose:** Complex business metric calculations

**Use Cases:**
- Month-over-month growth percentages
- Customer acquisition cost (CAC)
- Average order value trends
- Profit margins and ratios

**Connection to Week 12 (Financial Metrics):**
Remember calculating revenue metrics, gross/net revenue, and profitability? Now you'll create those same calculations in Looker Studio for real-time dashboards.

---

## Advanced Function Category 1: Nested CASE Statements

### Basic Syntax

```
CASE
  WHEN condition1 THEN result1
  WHEN condition2 THEN result2
  WHEN condition3 THEN result3
  ELSE default_result
END
```

### Example 1: Customer Lifetime Value (CLV) Tier Classification

**Business Requirement:** Segment customers based on total revenue to prioritize retention efforts.

**Data Source:** Based on validation report, top customers max out at $13,664. Use realistic thresholds.

**Looker Studio Calculated Field:**
```
CASE
  WHEN SUM(payment_value) >= 5000 THEN "VIP Champion"
  WHEN SUM(payment_value) >= 2000 THEN "Loyal Customer"
  WHEN SUM(payment_value) >= 500 THEN "Growing Customer"
  ELSE "New Customer"
END
```

**Field Configuration:**
- **Name:** CLV Tier
- **Formula:** (as above)
- **Type:** Text
- **Aggregation:** None (already aggregated with SUM)

**How It Works:**
1. `SUM(payment_value)` calculates total customer revenue
2. CASE evaluates from top to bottom
3. First matching condition returns the tier
4. Customers with <$500 revenue default to "New Customer"

**Expected Distribution (from validation report):**
- VIP Champions: ~7 customers (~0.007%)
- Loyal Customers: ~20 customers
- Growing Customers: ~500 customers
- New Customers: ~95,000+ customers

**Business Insight:** VIP Champions represent only 0.007% of customers but should receive white-glove service, dedicated account managers, and exclusive offers.

---

### Example 2: Delivery Performance Category

**Business Requirement:** Monitor logistics performance and identify delivery speed issues.

**Data Reality (from validation report):** 75% of orders are delayed or critically late. This is a major operational issue.

**Looker Studio Calculated Field:**
```
CASE
  WHEN Delivery_Days <= 3 THEN "Express"
  WHEN Delivery_Days <= 7 THEN "Standard"
  WHEN Delivery_Days <= 14 THEN "Delayed"
  ELSE "Critical Delay"
END
```

**Prerequisites:** First create the `Delivery_Days` calculated field:
```
DATE_DIFF(order_delivered_customer_date, order_purchase_timestamp, DAY)
```

**Expected Distribution:**
- Express (≤3 days): ~5%
- Standard (4-7 days): ~20%
- Delayed (8-14 days): ~50%
- Critical Delay (>14 days): ~25%

**Visualization Recommendations:**
- Pie chart showing delivery performance distribution
- Time series showing % on-time deliveries by month
- Conditional formatting: Green (Express), Yellow (Standard), Red (Delayed/Critical)

---

### Example 3: Nested CASE for Price Tier with Multiple Conditions

**Business Requirement:** Categorize products by price and shipping cost together for inventory strategy.

**Looker Studio Calculated Field:**
```
CASE
  WHEN price >= 500 AND freight_value >= 50 THEN "Premium-High Shipping"
  WHEN price >= 500 AND freight_value < 50 THEN "Premium-Standard Shipping"
  WHEN price >= 100 AND price < 500 THEN "Mid-Range"
  WHEN price < 100 AND freight_value >= 30 THEN "Budget-High Shipping"
  ELSE "Budget-Standard"
END
```

**Field Configuration:**
- **Name:** Product Price Category
- **Type:** Text
- **Data Source:** olist_order_items_dataset

**Business Application:**
- **Premium-High Shipping:** Review shipping partners (high cost items need reliable carriers)
- **Budget-High Shipping:** Investigate why cheap items have expensive shipping
- **Mid-Range:** Core product line, optimize for volume
- **Budget-Standard:** Focus on conversion rate (low margin)

---

## Advanced Function Category 2: String Functions

### CONCAT - Combining Text Fields

**Purpose:** Create readable labels by combining multiple data points.

**Example 1: RFM Score Display**

Remember Week 9 (RFM Analysis)? You calculated Recency, Frequency, and Monetary scores (1-5). Now create a readable label.

**Looker Studio Calculated Field:**
```
CONCAT(
  CAST(Recency_Score AS STRING),
  CAST(Frequency_Score AS STRING),
  CAST(Monetary_Score AS STRING)
)
```

**Result Examples:**
- "555" = Champions (recent, frequent, high-value)
- "155" = Hibernating (old, frequent, high-value)
- "111" = Lost (old, infrequent, low-value)

**Enhanced Version with Labels:**
```
CONCAT(
  "R:", CAST(Recency_Score AS STRING),
  " F:", CAST(Frequency_Score AS STRING),
  " M:", CAST(Monetary_Score AS STRING)
)
```

**Result:** "R:5 F:5 M:5" (more readable for business users)

---

### UPPER, LOWER, INITCAP - Text Standardization

**Problem:** Customer state data may have inconsistent capitalization (sp, SP, Sp, São Paulo).

**Solution - Standardize to Uppercase:**
```
UPPER(customer_state)
```

**Result:** All states display as "SP", "RJ", "MG" consistently.

**Use in Filters:** Prevents "SP" and "sp" from appearing as separate categories.

---

### SUBSTR and LENGTH - Text Extraction

**Example: Extract Postal Code Prefix**

Brazilian postal codes in Olist are stored as integers (e.g., 01000, 05000). Extract the region code (first 2 digits).

**Looker Studio Calculated Field:**
```
CAST(FLOOR(customer_zip_code_prefix / 1000) AS STRING)
```

**Explanation:**
- 01310 / 1000 = 1.31 → FLOOR = 1 → "01" region
- 05422 / 1000 = 5.422 → FLOOR = 5 → "05" region

**Business Use:** Regional analysis at zone level (more granular than state).

---

### REPLACE - Data Cleaning

**Problem:** Product category names have underscores: "home_decor", "health_beauty"

**Solution - Make User-Friendly:**
```
REPLACE(
  REPLACE(product_category_name, "_", " "),
  INITCAP
)
```

**Result:** "home_decor" → "Home Decor"

**Note:** Looker Studio doesn't have INITCAP; use nested UPPER/LOWER if needed, or clean in data source.

---

## Advanced Function Category 3: Date Functions

### DATE_DIFF - Calculate Days Between Dates

**Example 1: Days Since Last Order (Recency)**

**Business Context:** From Week 9 RFM analysis, recency is critical for customer segmentation.

**Looker Studio Calculated Field:**
```
DATE_DIFF(CURRENT_DATE(), MAX(order_purchase_timestamp), DAY)
```

**Explanation:**
- `CURRENT_DATE()`: Today's date
- `MAX(order_purchase_timestamp)`: Customer's most recent order
- `DAY`: Unit of measurement

**Expected Results:**
- Recent customers: 0-30 days
- Active customers: 31-90 days
- At-risk customers: 91-180 days
- Lost customers: >180 days

---

### Example 2: Delivery Days Calculation

**Critical for Logistics KPIs:**

```
DATE_DIFF(order_delivered_customer_date, order_purchase_timestamp, DAY)
```

**Handles NULL Dates:** Add error handling:
```
CASE
  WHEN order_delivered_customer_date IS NULL THEN NULL
  ELSE DATE_DIFF(order_delivered_customer_date, order_purchase_timestamp, DAY)
END
```

**Why This Matters:** Validation report shows 2,965 orders (2.98%) have NULL delivery dates. Always handle NULLs to prevent calculation errors.

---

### EXTRACT - Get Date Components

**Example: Extract Month Name for Seasonality Analysis**

```
CASE EXTRACT(MONTH FROM order_purchase_timestamp)
  WHEN 1 THEN "January"
  WHEN 2 THEN "February"
  WHEN 3 THEN "March"
  WHEN 4 THEN "April"
  WHEN 5 THEN "May"
  WHEN 6 THEN "June"
  WHEN 7 THEN "July"
  WHEN 8 THEN "August"
  WHEN 9 THEN "September"
  WHEN 10 THEN "October"
  WHEN 11 THEN "November"
  WHEN 12 THEN "December"
END
```

**Simpler Alternative (Looker Studio Native):**
Just use `order_purchase_timestamp` dimension and set date granularity to "Month" in chart settings.

---

### Example: Identify Weekend Orders

**Business Question:** Do we get more orders on weekends or weekdays?

**Looker Studio Calculated Field:**
```
CASE
  WHEN EXTRACT(DAYOFWEEK FROM order_purchase_timestamp) IN (1, 7) THEN "Weekend"
  ELSE "Weekday"
END
```

**Note:** In Looker Studio:
- 1 = Sunday
- 7 = Saturday
- 2-6 = Monday-Friday

**Use Case:** Analyze if weekend orders have different AOV, delivery expectations, or product mix.

---

## Advanced Function Category 4: Mathematical Functions

### ROUND - Clean Numeric Display

**Problem:** Revenue shows as $1,234.5678901

**Solution:**
```
ROUND(SUM(payment_value), 2)
```

**Result:** $1,234.57 (exactly 2 decimal places)

**Pro Tip:** Always round currency to 2 decimals for professional presentation.

---

### ABS - Absolute Values for Comparisons

**Use Case:** Calculate delivery variance (actual vs estimated)

```
ABS(
  DATE_DIFF(order_delivered_customer_date, order_estimated_delivery_date, DAY)
)
```

**Why ABS?** Captures both early and late deliveries as positive numbers for "days off estimate."

---

### FLOOR and CEIL - Rounding Logic

**Example: Group Prices into Buckets**

**Business Requirement:** Group products into $50 price buckets ($0-49, $50-99, $100-149, etc.)

```
CONCAT(
  "$", CAST(FLOOR(price / 50) * 50 AS STRING),
  "-",
  CAST((FLOOR(price / 50) * 50) + 49 AS STRING)
)
```

**Explanation:**
- price = $87
- FLOOR(87 / 50) = 1
- 1 * 50 = $50 (start of bucket)
- 50 + 49 = $99 (end of bucket)
- Result: "$50-$99"

---

## Combining Multiple Functions: Real-World Example

### Complex Field: Marketing ROI with Error Handling

**Business Context:** From Week 11 (Marketing Analytics), calculate ROI but handle missing data.

**Validation Report Note:** Campaign cost data doesn't exist in Olist dataset. This example shows the logic for when you have complete data.

**Looker Studio Calculated Field:**
```
CASE
  WHEN Campaign_Cost > 0 THEN
    ROUND(
      ((Revenue_From_Campaign - Campaign_Cost) / Campaign_Cost) * 100,
      2
    )
  WHEN Campaign_Cost = 0 THEN NULL  -- Avoid division by zero
  ELSE NULL  -- Handle missing data
END
```

**Explanation:**
1. Check if Campaign_Cost exists and is positive
2. Calculate ROI formula: (Revenue - Cost) / Cost * 100
3. Round to 2 decimals for readability
4. Handle edge cases (zero cost, missing data)

**Expected Results:**
- Positive ROI: Profitable campaigns
- Negative ROI: Campaigns losing money
- NULL: Incomplete data (exclude from averages)

---

## Connection to Prior Learning

### Week 3: Complex SQL CASE Logic
```sql
-- SQL version
CASE
  WHEN total_revenue >= 5000 THEN 'VIP Champion'
  WHEN total_revenue >= 2000 THEN 'Loyal Customer'
  ...
END
```

**Looker Equivalent:** Same logic, visual interface, no SQL needed.

---

### Week 6: Python String Manipulation
```python
# Python version
df['rfm_score'] = df['R'].astype(str) + df['F'].astype(str) + df['M'].astype(str)
```

**Looker Equivalent:** `CONCAT(CAST(R AS STRING), CAST(F AS STRING), CAST(M AS STRING))`

---

### Week 9: Window Functions and RFM Analysis
```sql
-- SQL window function for recency score
NTILE(5) OVER (ORDER BY days_since_last_order DESC) as recency_score
```

**Looker Approach:** Pre-calculate RFM scores in SQL data source, then use CONCAT to create labels in Looker Studio.

---

### Week 12: Statistical Calculations
```sql
-- SQL aggregation
SELECT
  AVG(payment_value) as avg_order_value,
  STDDEV(payment_value) as std_dev
FROM orders;
```

**Looker Equivalent:** Use built-in AVG() and STDDEV() functions in calculated fields.

---

## Practical Exercise: Build Your First Complex Field

### Task: Create CLV Tier Field (10 minutes)

1. Open your Week 14 Customer Analytics dashboard in **Edit Mode**
2. Click data source name → **"Manage added data sources"**
3. Click **"Edit"** next to your Olist data source
4. Click **"Add a field"** button (top-right)
5. Configure the field:

**Field Name:** CLV Tier

**Formula:**
```
CASE
  WHEN SUM(payment_value) >= 5000 THEN "VIP Champion"
  WHEN SUM(payment_value) >= 2000 THEN "Loyal Customer"
  WHEN SUM(payment_value) >= 500 THEN "Growing Customer"
  ELSE "New Customer"
END
```

**Type:** Text (auto-detected)

6. Click **"Save"** → **"Done"**
7. Return to your dashboard
8. Add a **Pie Chart**:
   - Dimension: CLV Tier
   - Metric: Record Count
   - Title: "Customer Distribution by Lifetime Value"

**Success Check:**
- See 4 slices: VIP Champion, Loyal, Growing, New
- VIP Champion is the smallest slice (<0.01%)
- New Customer is the largest slice (>90%)

---

### Task 2: Create Delivery Performance Field (5 minutes)

**Step 1: Create Delivery Days Field**

**Field Name:** Delivery Days

**Formula:**
```
DATE_DIFF(order_delivered_customer_date, order_purchase_timestamp, DAY)
```

**Step 2: Create Delivery Performance Category Field**

**Field Name:** Delivery Performance

**Formula:**
```
CASE
  WHEN DATE_DIFF(order_delivered_customer_date, order_purchase_timestamp, DAY) <= 3 THEN "Express"
  WHEN DATE_DIFF(order_delivered_customer_date, order_purchase_timestamp, DAY) <= 7 THEN "Standard"
  WHEN DATE_DIFF(order_delivered_customer_date, order_purchase_timestamp, DAY) <= 14 THEN "Delayed"
  ELSE "Critical Delay"
END
```

**Step 3: Add to Dashboard**

Add a **Donut Chart**:
- Dimension: Delivery Performance
- Metric: Record Count
- Title: "Delivery Speed Distribution"

**Expected Result:** You should see ~75% of orders in "Delayed" or "Critical Delay" categories, highlighting a major logistics issue.

---

## Common Issues and Solutions

### Issue 1: "Invalid Formula" Error

**Symptom:** Red error message when saving calculated field

**Causes & Solutions:**
- ❌ Syntax error (missing END statement)
  - ✅ Every CASE must close with END
- ❌ Wrong field names (case-sensitive)
  - ✅ Copy field names exactly from data source
- ❌ Mismatched data types
  - ✅ Use CAST() to convert types

---

### Issue 2: "Aggregation Error"

**Symptom:** "Cannot mix aggregated and non-aggregated fields"

**Cause:** Mixing SUM(field) with regular field in same formula

**Solution:**
```
❌ Wrong:
CASE
  WHEN SUM(revenue) > 1000 AND customer_state = "SP" THEN...
                             ↑ Non-aggregated field

✅ Correct:
-- Option 1: Aggregate everything
CASE
  WHEN SUM(revenue) > 1000 AND COUNT(DISTINCT customer_state) = 1 THEN...

-- Option 2: Don't aggregate
CASE
  WHEN revenue > 1000 AND customer_state = "SP" THEN...
```

---

### Issue 3: NULL Values Breaking Calculations

**Symptom:** Charts show blank or zero when they should show data

**Solution:** Always handle NULLs explicitly:
```
CASE
  WHEN field IS NULL THEN NULL  -- or 0, or "Unknown"
  WHEN field > 100 THEN "High"
  ELSE "Low"
END
```

---

### Issue 4: Performance Lag with Complex Fields

**Symptom:** Dashboard loads slowly or times out

**Causes & Solutions:**
- ❌ Too many nested CASE statements
  - ✅ Pre-calculate in SQL data source
- ❌ Complex calculations on large datasets
  - ✅ Add filters to reduce data volume
- ❌ String functions on millions of rows
  - ✅ Create lookup table in data source

---

## Key Takeaways

### What You Learned
1. ✅ Nested CASE statements replicate SQL logic visually
2. ✅ String functions (CONCAT, UPPER, CAST) clean and format data
3. ✅ Date functions (DATE_DIFF, EXTRACT) enable time-based analysis
4. ✅ Mathematical functions (ROUND, ABS) create professional metrics
5. ✅ Complex fields combine multiple function types
6. ✅ Always handle NULL values and edge cases

### What's Next
In the next lesson, we'll explore **Business Metrics** - building period comparisons, running totals, and advanced KPIs like month-over-month growth.

### Skills Building Progression
```
Week 15 Part 1: Advanced Functions ✓
         ↓
Week 15 Part 2: Business Metrics (Next)
         ↓
Week 15 Part 3: Data Storytelling Principles
         ↓
Week 15 Part 4: Actionable Insights
```

---

## Quick Reference Card

### Function Syntax Cheat Sheet

| Function | Syntax | Example |
|----------|--------|---------|
| **CASE** | `CASE WHEN condition THEN result ELSE default END` | Customer segmentation |
| **CONCAT** | `CONCAT(text1, text2, ...)` | Combine first and last name |
| **CAST** | `CAST(field AS STRING/NUMBER/DATE)` | Convert number to text |
| **DATE_DIFF** | `DATE_DIFF(end_date, start_date, DAY)` | Days between dates |
| **ROUND** | `ROUND(number, decimals)` | Round to 2 decimal places |
| **SUM** | `SUM(field)` | Total revenue |
| **AVG** | `AVG(field)` | Average order value |
| **COUNT** | `COUNT(field)` or `COUNT(DISTINCT field)` | Number of orders |

---

## Questions to Test Your Understanding

1. What is the difference between `SUM(payment_value)` and `payment_value` in a CASE statement?
2. Why do we use `CAST()` when concatenating numbers and text?
3. How do you prevent "division by zero" errors in ROI calculations?
4. What happens if you don't handle NULL values in DATE_DIFF calculations?
5. When should you pre-calculate fields in SQL vs. creating them in Looker Studio?

**Answers at the end of lecture notes**

---

## Additional Resources

- **Looker Studio Help:** [Calculated Fields Reference](https://support.google.com/looker-studio/answer/6299685)
- **Video Tutorial:** Advanced Functions Walkthrough (Week 15 resources folder)
- **Cheat Sheet:** Looker Studio Function Reference (resources/)
- **Validation Report:** Week 15 Data Validation (see validation-report.md)

---

## Answers to Questions

1. **SUM(payment_value)** aggregates across multiple rows (total); **payment_value** is the individual row value (no aggregation)
2. **CAST()** converts data types so they're compatible for concatenation (can't directly concat number + text)
3. Add **CASE WHEN Campaign_Cost > 0 THEN (calculation) ELSE NULL END** to check for zero before dividing
4. DATE_DIFF with NULL dates returns **NULL**, which breaks charts; use **CASE WHEN field IS NULL** to handle
5. Pre-calculate in SQL for **complex calculations** (performance) or **window functions** (not supported in Looker Studio); use Looker for **simple logic** and **business user accessibility**

---

**Next Lecture:** 02_business_metrics_period_comparisons.md
