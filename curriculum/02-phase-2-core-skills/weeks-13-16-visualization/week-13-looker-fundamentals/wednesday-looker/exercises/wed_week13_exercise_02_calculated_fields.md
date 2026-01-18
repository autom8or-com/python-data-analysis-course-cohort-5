# Exercise 2: Calculated Fields Practice

## Week 13 - Wednesday - Exercise 2

### Estimated Time: 25 minutes

---

## Objective

Master creating calculated fields in Looker Studio by building business metrics from the Olist e-commerce dataset using SQL-like formulas.

---

## Prerequisites

Before starting, ensure you have:
- ✅ Completed Exercise 1 (Data Connection Setup)
- ✅ Active data source: "Olist Orders 2017 - Student [Your Name]"
- ✅ Completed Week 13 Lecture Part 3 (Calculated Fields Fundamentals)

---

## Instructions

### Part 1: Create Arithmetic Calculated Fields

#### Task 1.1: Total Order Value

Create a field that calculates the complete cost per order item (product price + shipping).

**Step-by-Step:**

1. Access your data source:
   - Method A: From your report → **Resource** → **Manage added data sources** → **EDIT**
   - Method B: From Looker home → **Data Sources** → Click your data source

2. Click **"+ ADD A FIELD"** (top-right of field list)

3. Enter the following:

```
Field Name: total_order_value
Formula:    price + freight_value
```

4. Verify you see: ✅ **"Formula is valid"**
5. Click **"SAVE"**

**Expected Result:** New metric field `total_order_value` appears in METRICS section with blue icon (🔢).

---

#### Task 1.2: VAT Amount (7.5%)

Calculate Nigerian VAT on product price.

**Create field:**
```
Field Name: vat_amount
Formula:    price * 0.075
```

**Click SAVE**

---

#### Task 1.3: Total with VAT

Calculate total cost including VAT.

**Create field:**
```
Field Name: total_with_vat
Formula:    price + (price * 0.075) + freight_value
```

**Alternative formula (using your previous calculated field):**
```
Formula: total_order_value + vat_amount
```

**Click SAVE**

---

### Part 2: Create Date Extraction Fields

#### Task 2.1: Order Year

Extract year from purchase timestamp for grouping sales by year.

**Create field:**
```
Field Name: order_year
Formula:    YEAR(order_purchase_timestamp)
```

**Field Type:** This becomes a **dimension** (category for grouping)

**Click SAVE**

---

#### Task 2.2: Order Month (Number)

Extract month number (1-12) for seasonal analysis.

**Create field:**
```
Field Name: order_month
Formula:    MONTH(order_purchase_timestamp)
```

**Click SAVE**

---

#### Task 2.3: Order Month Name

Extract month name (January, February, etc.) for readable reports.

**Create field:**
```
Field Name: order_month_name
Formula:    MONTH_NAME(order_purchase_timestamp)
```

**Click SAVE**

---

#### Task 2.4: Day of Week

Identify which day customers place orders most frequently.

**Create field:**
```
Field Name: order_day_of_week
Formula:    WEEKDAY(order_purchase_timestamp)
```

**Note:** Returns values 1-7 (Sunday=1, Monday=2, etc.)

**Click SAVE**

---

### Part 3: Create Date Calculation Fields

#### Task 3.1: Delivery Time (Days)

Calculate how many days it took to deliver each order.

**Create field:**
```
Field Name: delivery_time_days
Formula:    DATE_DIFF(order_delivered_customer_date,
                      order_purchase_timestamp)
```

**Important:** This calculates difference in days between delivery and purchase.

**Click SAVE**

---

#### Task 3.2: Estimated Delivery Time

Calculate the promised delivery timeframe.

**Create field:**
```
Field Name: estimated_delivery_days
Formula:    DATE_DIFF(order_estimated_delivery_date,
                      order_purchase_timestamp)
```

**Click SAVE**

---

### Part 4: Create CASE Statement Fields (Categorization)

#### Task 4.1: Price Tier Classification

Categorize products by price range.

**Create field:**
```
Field Name: price_tier
Formula:
CASE
    WHEN price <= 50 THEN "Budget"
    WHEN price > 50 AND price <= 150 THEN "Mid-Range"
    WHEN price > 150 THEN "Premium"
    ELSE "Unknown"
END
```

**Field Type:** This is a **dimension** (text category)

**Click SAVE**

---

#### Task 4.2: Delivery Status

Categorize delivery performance (on-time, late, or pending).

**Create field:**
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

**Click SAVE**

---

#### Task 4.3: Order Value Category

Classify orders by total value for customer segmentation.

**Create field:**
```
Field Name: order_value_category
Formula:
CASE
    WHEN total_order_value < 50 THEN "Small Order"
    WHEN total_order_value >= 50 AND total_order_value < 200
        THEN "Medium Order"
    WHEN total_order_value >= 200 AND total_order_value < 500
        THEN "Large Order"
    WHEN total_order_value >= 500 THEN "Premium Order"
    ELSE "Unknown"
END
```

**Click SAVE**

---

#### Task 4.4: Regional Grouping

Group Brazilian states into regions for geographic analysis.

**Create field:**
```
Field Name: region
Formula:
CASE
    WHEN customer_state IN ("SP", "RJ", "MG", "ES") THEN "Southeast"
    WHEN customer_state IN ("RS", "SC", "PR") THEN "South"
    WHEN customer_state IN ("GO", "MT", "MS", "DF") THEN "Central-West"
    WHEN customer_state IN ("BA", "SE", "AL", "PE", "PB", "RN", "CE", "PI", "MA")
        THEN "Northeast"
    WHEN customer_state IN ("AM", "RR", "AP", "PA", "TO", "RO", "AC") THEN "North"
    ELSE "Unknown"
END
```

**Click SAVE**

---

### Part 5: Verify Your Calculated Fields

#### Task 5.1: Count Your Fields

In your data source, verify you now have these NEW calculated fields (14 total):

**Metrics (6):**
- ✅ `total_order_value`
- ✅ `vat_amount`
- ✅ `total_with_vat`
- ✅ `delivery_time_days`
- ✅ `estimated_delivery_days`

**Dimensions (8):**
- ✅ `order_year`
- ✅ `order_month`
- ✅ `order_month_name`
- ✅ `order_day_of_week`
- ✅ `price_tier`
- ✅ `delivery_status`
- ✅ `order_value_category`
- ✅ `region`

**Note:** Calculated fields show a **blue icon** in the field list.

---

### Part 6: Test Your Calculated Fields

#### Task 6.1: Create Test Report

1. Click **"CREATE REPORT"** from your data source
2. Rename report to: **"Week 13 Exercise 2 - Calculated Fields Test - [Your Name]"**

#### Task 6.2: Create Table to Verify Arithmetic Fields

1. Add a **Table** chart
2. Configure Data tab:
   - **Dimensions:** (none)
   - **Metrics:** Add these in order:
     - `SUM(price)`
     - `SUM(freight_value)`
     - `SUM(total_order_value)`
     - `SUM(vat_amount)`
     - `SUM(total_with_vat)`

3. **Verify Logic:**
   - Does `total_order_value` = `price` + `freight_value`?
   - Does `vat_amount` ≈ `price` × 0.075?
   - Does `total_with_vat` = `price` + `vat_amount` + `freight_value`?

**Example expected output:**
```
| SUM(price) | SUM(freight_value) | SUM(total_order_value) | SUM(vat_amount) | SUM(total_with_vat) |
|------------|--------------------|-----------------------|-----------------|---------------------|
| 8,500,000  | 1,200,000          | 9,700,000             | 637,500         | 10,337,500          |
```

---

#### Task 6.3: Create Bar Chart by Price Tier

1. Add a **Bar Chart**
2. Configure:
   - **Dimension:** `price_tier`
   - **Metric:** `Record Count`
   - **Sort:** Descending by `Record Count`

**Questions to Answer:**
- Which price tier has the most orders?
- What percentage of orders are "Budget" tier?

---

#### Task 6.4: Create Table by Region

1. Add a **Table** chart
2. Configure:
   - **Dimension:** `region`
   - **Metrics:**
     - `Record Count`
     - `SUM(total_order_value)`
     - `AVG(delivery_time_days)`
   - **Sort:** Descending by `SUM(total_order_value)`

**Questions to Answer:**
- Which region generates the most revenue?
- Which region has the fastest average delivery time?

---

#### Task 6.5: Create Pie Chart for Delivery Status

1. Add a **Pie Chart**
2. Configure:
   - **Dimension:** `delivery_status`
   - **Metric:** `Record Count`

**Questions to Answer:**
- What percentage of orders were delivered on time?
- What percentage were late?

---

#### Task 6.6: Create Scorecards for Summary Metrics

Create **4 scorecards** showing:

1. **Total Revenue (with VAT)**
   - Metric: `SUM(total_with_vat)`
   - Format as currency

2. **Average Order Value**
   - Metric: `AVG(total_order_value)`
   - Format as currency

3. **Average Delivery Time**
   - Metric: `AVG(delivery_time_days)`
   - Add label: "days"

4. **On-Time Delivery Rate**
   - Metric: Create chart-level calculated field:
   ```
   Formula: COUNT(CASE WHEN delivery_status = "On Time" THEN 1 END) / COUNT(delivery_status)
   ```
   - Format as percentage

---

## Submission Checklist

Before marking this exercise as complete, verify:

```
☐ Created all 14 calculated fields (6 metrics + 8 dimensions)
☐ All fields show "Formula is valid" (no errors)
☐ Test report created with verification charts
☐ Arithmetic calculations verified (totals add up correctly)
☐ Date fields extract correctly (years 2017, months 1-12)
☐ CASE statements categorize data properly
☐ Regional grouping shows 5 regions + Unknown
☐ Price tiers show Budget, Mid-Range, Premium
☐ Delivery status shows On Time, Late, Pending
☐ All charts display data (no errors or empty charts)
```

---

## Troubleshooting

### Issue 1: "Invalid Formula" Error

**Common Causes & Solutions:**

**Problem:** Using single quotes instead of double quotes
```
❌ Wrong: CASE WHEN price > 100 THEN 'High' END
✅ Right: CASE WHEN price > 100 THEN "High" END
```

**Problem:** Field name typo
```
❌ Wrong: price + freight    (field doesn't exist)
✅ Right: price + freight_value
```

**Problem:** Missing END in CASE statement
```
❌ Wrong: CASE WHEN price > 100 THEN "High"
✅ Right: CASE WHEN price > 100 THEN "High" END
```

---

### Issue 2: "Cannot Mix Aggregated and Non-Aggregated Fields"

**Problem:** Using SUM with non-aggregated field
```
❌ Wrong: SUM(price) + freight_value
✅ Right: SUM(price + freight_value)
or
✅ Right: SUM(price) + SUM(freight_value)
```

---

### Issue 3: Date Field Shows as Text

**Solution:**
1. Edit data source
2. Find the calculated date field
3. Click on field → Change **Type** to "Date" or "Number" (for year/month)
4. Save

---

### Issue 4: CASE Statement Returns Unexpected Results

**Check:**
- Order of conditions (first match wins!)
- Correct logical operators (AND, OR, NOT)
- Inclusive/exclusive boundaries

**Example of order mattering:**
```
❌ Wrong order:
CASE
    WHEN price > 0 THEN "Has Price"        ← This catches everything!
    WHEN price > 100 THEN "Expensive"      ← Never reached
END

✅ Right order:
CASE
    WHEN price > 100 THEN "Expensive"      ← Check specific first
    WHEN price > 0 THEN "Has Price"        ← Then general
END
```

---

## Expected Outcomes

### Your Data Source Field List

After completing all tasks, your data source should show:

```
Data Source: Olist Orders 2017 - Student [Your Name]
Connected to: PostgreSQL

Fields:
──────────────────────────────────────
DIMENSIONS (23 total)
├── Original Fields (15)
│   ├── 📅 order_purchase_timestamp
│   ├── 📅 order_delivered_customer_date
│   ├── 📅 order_estimated_delivery_date
│   ├── 🏷️ customer_state
│   ├── 🏷️ customer_city
│   └── ... (10 more)
│
└── Calculated Fields (8) - Blue icon
    ├── 🔢 order_year
    ├── 🔢 order_month
    ├── 🏷️ order_month_name
    ├── 🔢 order_day_of_week
    ├── 🏷️ price_tier
    ├── 🏷️ delivery_status
    ├── 🏷️ order_value_category
    └── 🏷️ region

METRICS (9 total)
├── Original Fields (3)
│   ├── 🔢 price
│   ├── 🔢 freight_value
│   └── 📊 Record Count
│
└── Calculated Fields (6) - Blue icon
    ├── 🔢 total_order_value
    ├── 🔢 vat_amount
    ├── 🔢 total_with_vat
    ├── 🔢 delivery_time_days
    └── 🔢 estimated_delivery_days
```

---

### Sample Dashboard Layout

Your test report should look similar to this:

```
┌────────────────────────────────────────────────────────────────┐
│ Week 13 Exercise 2 - Calculated Fields Test - [Your Name]     │
├────────────────────────────────────────────────────────────────┤
│                                                                │
│  Scorecard Row:                                                │
│  ┌──────────┐ ┌──────────┐ ┌──────────┐ ┌──────────────┐     │
│  │ Total    │ │ Avg Order│ │ Avg      │ │ On-Time      │     │
│  │ Revenue  │ │ Value    │ │ Delivery │ │ Delivery %   │     │
│  │ (w/ VAT) │ │          │ │ Time     │ │              │     │
│  │          │ │          │ │          │ │              │     │
│  │$10.3M    │ │ $142.50  │ │ 12 days  │ │    78%       │     │
│  └──────────┘ └──────────┘ └──────────┘ └──────────────┘     │
│                                                                │
│  ┌────────────────────┐  ┌──────────────────────────────────┐ │
│  │ Orders by Price    │  │ Revenue by Region                │ │
│  │ Tier (Bar Chart)   │  │ (Table)                          │ │
│  │                    │  │                                  │ │
│  │ Budget:    ████▌   │  │ Southeast  | 45,000 | $5.2M    │ │
│  │ Mid-Range: ███     │  │ South      | 18,000 | $2.1M    │ │
│  │ Premium:   █       │  │ Northeast  | 12,000 | $1.4M    │ │
│  └────────────────────┘  └──────────────────────────────────┘ │
│                                                                │
│  ┌────────────────────────────────────────────────────────────┤
│  │ Delivery Status Distribution (Pie Chart)                  │ │
│  │                                                            │ │
│  │        On Time: 78%                                        │ │
│  │        Late: 18%                                           │ │
│  │        Pending: 4%                                         │ │
│  └────────────────────────────────────────────────────────────┘
│                                                                │
└────────────────────────────────────────────────────────────────┘
```

---

## Reflection Questions

Answer these to test your understanding:

1. **What is the difference between a data source-level calculated field and a chart-level calculated field?**

2. **Why do we use CASE statements instead of multiple IF statements?**

3. **In the formula `total_order_value + vat_amount`, both are calculated fields. Why does this work?**

4. **What happens if you try to use `SUM(price)` inside a CASE statement at the data source level?**

5. **How would you modify the `price_tier` CASE statement to use Nigerian Naira thresholds instead of USD?**

---

## Next Steps

After completing this exercise:

1. **Keep your data source** – You'll use these calculated fields in Thursday's visualization exercises
2. **Experiment** – Try creating your own custom calculated fields
3. **Review** – Make sure you understand each formula before Thursday's class

**Excellent work!** You now have a robust data source with business-ready calculated fields. These will power all your future Looker Studio dashboards.

---

## Additional Challenge (Optional)

If you finish early, try these advanced calculated fields:

### Challenge 1: Month-Year Combined Dimension

Create a field showing "Jan 2017", "Feb 2017", etc.

```
Field Name: month_year
Formula:    CONCAT(order_month_name, " ", CAST(order_year AS TEXT))
```

### Challenge 2: Delivery Delay (Days)

Calculate how many days late (or early) delivery was.

```
Field Name: delivery_delay_days
Formula:    DATE_DIFF(order_delivered_customer_date,
                      order_estimated_delivery_date)
```

**Note:** Negative = early, Positive = late

### Challenge 3: Weekend Order Flag

Identify if order was placed on weekend.

```
Field Name: is_weekend_order
Formula:
CASE
    WHEN WEEKDAY(order_purchase_timestamp) IN (1, 7) THEN "Weekend"
    ELSE "Weekday"
END
```

### Challenge 4: Revenue Per Delivery Day

Calculate efficiency metric.

```
Field Name: revenue_per_day
Formula:    total_order_value / delivery_time_days
```

**Handle division by zero:**
```
Formula:
CASE
    WHEN delivery_time_days = 0 OR delivery_time_days IS NULL THEN 0
    ELSE total_order_value / delivery_time_days
END
```

---

**Instructor Note:** Students should test all calculated fields thoroughly before proceeding to Thursday's visualization session. Ensure fields are correctly categorized as dimensions vs. metrics.
