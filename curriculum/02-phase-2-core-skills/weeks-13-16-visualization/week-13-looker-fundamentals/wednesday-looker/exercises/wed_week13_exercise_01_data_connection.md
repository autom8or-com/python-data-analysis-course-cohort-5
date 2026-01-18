# Exercise 1: Data Connection Setup

## Week 13 - Wednesday - Exercise 1

### Estimated Time: 20 minutes

---

## Objective

Connect Google Looker Studio to your Supabase PostgreSQL database and create your first data source using the Olist e-commerce dataset.

---

## Prerequisites

Before starting, ensure you have:
- ✅ Google account (Gmail)
- ✅ Access to Looker Studio (lookerstudio.google.com)
- ✅ Supabase database credentials (provided by instructor)
- ✅ Completed Week 13 Lecture Part 1 & 2

---

## Instructions

### Part 1: Connect to Supabase Database

#### Task 1.1: Access PostgreSQL Connector

1. Navigate to: `https://lookerstudio.google.com`
2. Click **"Create"** → **"Data Source"**
3. Find and click **"PostgreSQL"** connector
4. If prompted, click **"AUTHORIZE"** to grant permissions

#### Task 1.2: Enter Connection Details

Enter the following information (get from instructor):

```
┌─────────────────────────────────────────────────┐
│ PostgreSQL Connection Settings                  │
├─────────────────────────────────────────────────┤
│                                                 │
│ Host Path: [Instructor will provide]            │
│ Example: db.xxxxxxxxxxxxx.supabase.co           │
│                                                 │
│ Port: 5432                                      │
│                                                 │
│ Database: postgres                              │
│                                                 │
│ Username: [Instructor will provide]             │
│                                                 │
│ Password: [Instructor will provide]             │
│                                                 │
│ ☐ Enable SSL (leave UNCHECKED)                 │
│                                                 │
└─────────────────────────────────────────────────┘
```

5. Click **"AUTHENTICATE"**

**Expected Result:** You should see "✅ Connection successful!"

---

### Part 2: Create Data Source from Orders Dataset

#### Task 2.1: Use Custom Query

After successful authentication:

1. Check the box: ☑ **"Use a custom query"**
2. Paste the following SQL query:

```sql
SELECT
    o.order_id,
    o.customer_id,
    o.order_status,
    o.order_purchase_timestamp,
    o.order_delivered_customer_date,
    o.order_estimated_delivery_date,
    c.customer_unique_id,
    c.customer_zip_code_prefix,
    c.customer_city,
    c.customer_state,
    oi.order_item_id,
    oi.product_id,
    oi.seller_id,
    oi.price,
    oi.freight_value
FROM olist_sales_data_set.olist_orders_dataset o
JOIN olist_sales_data_set.olist_customers_dataset c
    ON o.customer_id = c.customer_id
JOIN olist_sales_data_set.olist_order_items_dataset oi
    ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered'
    AND o.order_purchase_timestamp >= '2017-01-01'
    AND o.order_purchase_timestamp < '2018-01-01';
```

3. Click **"CONNECT"**

**Expected Result:** Data source creation begins, showing field list.

---

### Part 3: Configure Data Source

#### Task 3.1: Name Your Data Source

1. Click on "Untitled Data Source" (top-left)
2. Rename to: **"Olist Orders 2017 - Student [Your Name]"**
   - Example: "Olist Orders 2017 - Student John Doe"

#### Task 3.2: Verify Fields

Check that the following fields appear in the field list:

**Dimensions (should show 📋 icon):**
- `order_id`
- `customer_id`
- `order_status`
- `order_purchase_timestamp` (should be recognized as Date type)
- `order_delivered_customer_date` (should be recognized as Date type)
- `order_estimated_delivery_date` (should be recognized as Date type)
- `customer_unique_id`
- `customer_zip_code_prefix`
- `customer_city`
- `customer_state`
- `order_item_id`
- `product_id`
- `seller_id`

**Metrics (should show 📊 icon):**
- `price` (should be recognized as Number with Sum aggregation)
- `freight_value` (should be recognized as Number with Sum aggregation)
- `Record Count` (auto-created by Looker)

**Total expected fields:** 15 dimensions + 3 metrics = **18 fields**

---

### Part 4: Test Your Connection

#### Task 4.1: Create a Test Report

1. Click **"CREATE REPORT"** button (top-right, blue)
2. If prompted, click **"ADD TO REPORT"** to confirm

**Expected Result:** Looker Studio creates a default table chart with your data.

#### Task 4.2: Verify Data Display

Look at the table that appears. You should see:
- Multiple rows of order data
- Customer states (SP, RJ, MG, PR, etc.)
- Order IDs (alphanumeric strings)
- Prices and freight values (decimal numbers)

**Data Quality Check:**
- ✅ Do you see at least 50 rows?
- ✅ Are there recognizable Brazilian state codes (SP, RJ, MG)?
- ✅ Are prices showing as numbers (not text)?
- ✅ Are dates formatted correctly?

---

### Part 5: Explore Your Data

#### Task 5.1: Change Chart Type to Scorecard

1. Select the table chart (click on it)
2. In the right panel, find **"Chart"** tab
3. Click the chart type dropdown (currently showing "Table")
4. Select **"Scorecard"**

#### Task 5.2: Configure Scorecard for Total Revenue

1. In the **"Data"** tab (right panel):
   - Remove all dimensions (click X on each)
   - Keep only ONE metric: `price`
   - Make sure it says `SUM(price)` (not AVG or COUNT)

2. Look at the scorecard on your canvas

**Question:** What is the total revenue for 2017 delivered orders?

**Expected Range:** Should be between $5 million - $15 million USD

#### Task 5.3: Add Second Scorecard for Order Count

1. From toolbar, click **"Add a chart"**
2. Select **"Scorecard"**
3. Place it next to your first scorecard
4. Configure data:
   - Remove dimensions
   - Metric: `Record Count`

**Question:** How many delivered orders were there in 2017?

**Expected Range:** Should be between 50,000 - 100,000 orders

---

## Submission Checklist

Before marking this exercise as complete, verify:

```
☐ Successfully connected to Supabase PostgreSQL
☐ Created data source named "Olist Orders 2017 - Student [Your Name]"
☐ Data source shows 18 fields (15 dimensions + 3 metrics)
☐ Created test report with data visible
☐ Created Revenue scorecard showing total price
☐ Created Order Count scorecard showing record count
☐ Both scorecards show reasonable numbers (not zero or errors)
☐ Renamed report to "Week 13 Exercise 1 - [Your Name]"
```

---

## Troubleshooting

### Issue 1: "Connection Failed"

**Solutions:**
1. Double-check host path (copy-paste from instructor document)
2. Verify port is exactly: `5432`
3. Ensure SSL checkbox is **UNCHECKED**
4. Try re-entering password (copy-paste to avoid typos)
5. Contact instructor if problem persists

### Issue 2: "Invalid Query" Error

**Solutions:**
1. Check for typos in table names (case-sensitive!)
2. Ensure you copied the entire query (scroll down in query box)
3. Remove any semicolons (`;`) at the end of the query
4. Verify schema names are correct: `olist_sales_data_set`

### Issue 3: "No Data Visible" in Report

**Solutions:**
1. Check date range filter (should be 2017)
2. Verify `order_status = 'delivered'` in WHERE clause
3. Check if fields are correctly recognized as dimensions/metrics
4. Try clicking **"Refresh Data"** button

### Issue 4: Fields Show Wrong Type (Date shows as Text)

**Solutions:**
1. Edit data source (Resource → Manage added data sources → EDIT)
2. Find the date field in field list
3. Click on the field
4. Change **Type** to "Date" (or "Date & Time")
5. Click **"SAVE"**

---

## Expected Outcomes

### Data Source Configuration

Your data source should look like this:

```
Data Source: Olist Orders 2017 - Student [Your Name]
Connected to: PostgreSQL (Supabase)

Fields:
──────────────────────────────────────
DIMENSIONS (15)
├── 📅 order_purchase_timestamp
├── 📅 order_delivered_customer_date
├── 📅 order_estimated_delivery_date
├── 🏷️ customer_state
├── 🏷️ customer_city
├── 🏷️ order_status
└── ... (9 more ID fields)

METRICS (3)
├── 🔢 price (Sum)
├── 🔢 freight_value (Sum)
└── 📊 Record Count
```

### Test Report

Your report should contain:
```
┌──────────────────────────────────────────────┐
│ Week 13 Exercise 1 - [Your Name]             │
├──────────────────────────────────────────────┤
│                                              │
│  ┌─────────────────┐  ┌──────────────────┐  │
│  │ Total Revenue   │  │ Order Count      │  │
│  │                 │  │                  │  │
│  │ $X,XXX,XXX      │  │ XX,XXX           │  │
│  └─────────────────┘  └──────────────────┘  │
│                                              │
└──────────────────────────────────────────────┘
```

---

## Reflection Questions

Answer these questions to test your understanding:

1. **What is the difference between a "dimension" and a "metric" in Looker Studio?**

2. **Why did we use a custom query instead of selecting a single table?**

3. **What does the WHERE clause in our query do?**
   ```sql
   WHERE o.order_status = 'delivered'
       AND o.order_purchase_timestamp >= '2017-01-01'
   ```

4. **If you wanted to see 2018 data instead, what would you change in the query?**

5. **What is the advantage of connecting directly to the database vs. uploading a CSV file?**

---

## Next Steps

Once you've completed this exercise:
1. Save your report (auto-saves to Google Drive)
2. Keep your data source—you'll use it in Exercise 2
3. Proceed to **Exercise 2: Calculated Fields**

**Well done!** You've successfully connected Looker Studio to a live PostgreSQL database. This is the foundation for all your future dashboards.

---

## Additional Challenge (Optional)

If you finish early, try these bonus tasks:

### Challenge 1: Create Additional Scorecards

Add scorecards for:
- **Average Order Value:** `AVG(price)`
- **Average Freight Cost:** `AVG(freight_value)`
- **Unique Customers:** `COUNT_DISTINCT(customer_unique_id)`

### Challenge 2: Create a Simple Bar Chart

1. Add a **Bar Chart** to your report
2. Configure:
   - Dimension: `customer_state`
   - Metric: `SUM(price)`
   - Sort: Descending by `SUM(price)`

**Question:** Which state has the highest revenue?

### Challenge 3: Experiment with Date Ranges

1. Edit your data source
2. Change the WHERE clause date range to:
   - Q1 2017 only: `>= '2017-01-01' AND < '2017-04-01'`
   - Q4 2017 only: `>= '2017-10-01' AND < '2018-01-01'`

3. Observe how the numbers change in your scorecards

---

**Instructor Note:** Students should complete this exercise before moving to Exercise 2. Verify that all students have successfully connected and see data in their reports before proceeding.
