# Connecting Looker Studio to PostgreSQL (Supabase)

## Week 13 - Wednesday Session - Part 2

### Duration: 30 minutes

---

## Overview

In this lesson, you'll learn how to connect Google Looker Studio to your Supabase PostgreSQL database—the same database you've been querying with SQL for the past 8 weeks. This connection allows you to visualize your SQL query results without exporting data manually.

### What You'll Learn
- PostgreSQL connector configuration
- Supabase connection credentials
- Testing and troubleshooting connections
- Using custom SQL queries as data sources
- Data refresh settings

---

## Prerequisites

Before starting, ensure you have:

1. ✅ **Google Account** (Gmail or Google Workspace)
2. ✅ **Supabase Access** (database credentials provided by instructor)
3. ✅ **Looker Studio Access** (lookerstudio.google.com)
4. ✅ **Week 1-8 SQL Knowledge** (you'll write queries to define data sources)

---

## Part 1: Understanding Database Connections

### From SQL to Looker Studio

**What you've been doing (Weeks 1-8):**
```sql
-- In VS Code or SQL client
SELECT
    customer_state,
    COUNT(*) as order_count,
    SUM(price) as total_revenue
FROM olist_sales_data_set.olist_order_items_dataset oi
JOIN olist_sales_data_set.olist_orders_dataset o
    ON oi.order_id = o.order_id
GROUP BY customer_state
ORDER BY total_revenue DESC;
```

**What Looker Studio does:**
- Runs this query automatically
- Refreshes data periodically
- Lets you visualize results as charts
- Allows viewers to filter without writing SQL

### Connection Types

Looker Studio offers two connection modes:

#### 1. **Direct Connection (Recommended for Course)**
```
Your Dashboard → PostgreSQL Connector → Supabase Database
                                              ↓
                                    Real-time data queries
```

**Characteristics:**
- ✅ Always shows current data
- ✅ No data storage in Looker
- ⚠️ Slower for large datasets
- ⚠️ Requires active internet

#### 2. **Extract Connection (Not used in course)**
```
Your Dashboard → Cached Data → (Refreshed every 12 hours)
```

**Use when:**
- Database is very slow
- Data changes infrequently
- Need faster dashboard load times

---

## Part 2: Gathering Supabase Credentials

### What You Need

To connect to any PostgreSQL database, you need 5 pieces of information:

```
┌─────────────────────────────────┐
│  PostgreSQL Connection Details  │
├─────────────────────────────────┤
│ 1. Host/Server    : [Address]   │
│ 2. Port           : [Number]    │
│ 3. Database Name  : [Name]      │
│ 4. Username       : [User]      │
│ 5. Password       : [Pass]      │
└─────────────────────────────────┘
```

### Locating Supabase Credentials

#### Method 1: From Instructor-Provided Document
Your instructor has shared a document with these details. They look like:

```
Host: db.xxxxxxxxxxxxx.supabase.co
Port: 5432
Database: postgres
Username: postgres
Password: [provided separately for security]
```

#### Method 2: From Supabase Dashboard (if you have access)
1. Log into your Supabase project
2. Click **"Settings"** (gear icon, bottom-left)
3. Click **"Database"**
4. Scroll to **"Connection Info"**
5. Find **"Connection String"** section

**Security Note:** Never share your database password publicly or commit it to GitHub.

---

## Part 3: Step-by-Step Connection Process

### Step 1: Access Looker Studio
1. Open browser: `https://lookerstudio.google.com`
2. Click **"Create"** → **"Data Source"**

### Step 2: Select PostgreSQL Connector

You'll see the connector gallery:

```
Select a Connector
─────────────────────────────────────
Google Connectors
  ├── Google Sheets
  ├── Google Analytics
  └── BigQuery

Partner Connectors
  ├── 🐘 PostgreSQL ← SELECT THIS
  ├── MySQL
  └── Microsoft SQL Server

File Upload
  └── CSV Upload
```

**Click on: 🐘 PostgreSQL**

### Step 3: Authorize the Connector

First-time users will see:

```
┌──────────────────────────────────────────┐
│ PostgreSQL connector needs permission    │
│ to connect to databases                  │
│                                          │
│ This connector is provided by Google     │
│                                          │
│        [AUTHORIZE]    [Cancel]           │
└──────────────────────────────────────────┘
```

**Click "AUTHORIZE"** and follow prompts.

### Step 4: Enter Connection Details

You'll see a form with fields:

```
┌─────────────────────────────────────────────────────┐
│  PostgreSQL Connection                              │
├─────────────────────────────────────────────────────┤
│                                                     │
│  Host Path *                                        │
│  ┌──────────────────────────────────────────────┐  │
│  │ db.xxxxxxxxxxxxx.supabase.co                  │  │
│  └──────────────────────────────────────────────┘  │
│                                                     │
│  Port *                                            │
│  ┌──────────────────────────────────────────────┐  │
│  │ 5432                                          │  │
│  └──────────────────────────────────────────────┘  │
│                                                     │
│  Database *                                        │
│  ┌──────────────────────────────────────────────┐  │
│  │ postgres                                      │  │
│  └──────────────────────────────────────────────┘  │
│                                                     │
│  Username *                                        │
│  ┌──────────────────────────────────────────────┐  │
│  │ postgres                                      │  │
│  └──────────────────────────────────────────────┘  │
│                                                     │
│  Password *                                        │
│  ┌──────────────────────────────────────────────┐  │
│  │ ••••••••••••••••••                            │  │
│  └──────────────────────────────────────────────┘  │
│                                                     │
│  ☐ Enable SSL (leave unchecked for Supabase)      │
│                                                     │
│          [AUTHENTICATE]    [Cancel]                │
│                                                     │
└─────────────────────────────────────────────────────┘
```

**Fill in the fields:**
- **Host Path:** Copy from instructor document (e.g., `db.abcdefghij.supabase.co`)
- **Port:** Always `5432` for PostgreSQL
- **Database:** Usually `postgres` for Supabase
- **Username:** Usually `postgres` for Supabase
- **Password:** Copy from secure source (don't type manually—less error-prone)
- **Enable SSL:** Leave **UNCHECKED** (Supabase handles SSL automatically)

**Click "AUTHENTICATE"**

### Step 5: Connection Success

If successful, you'll see:

```
✅ Connection successful!

Now select a table or use custom query.
```

If failed, see **Troubleshooting** section below.

---

## Part 4: Choosing Your Data Source Method

After authentication, you have two options:

### Option A: Select a Table (Simple)

```
Select a table
──────────────────────────────────────
Schema: olist_sales_data_set
──────────────────────────────────────
  ☐ olist_customers_dataset
  ☐ olist_geolocation_dataset
  ☐ olist_order_items_dataset
  ☐ olist_order_payments_dataset
  ☐ olist_order_reviews_dataset
  ☐ olist_orders_dataset ← Select this for practice
  ☐ olist_products_dataset
  ☐ olist_sellers_dataset

Schema: olist_marketing_data_set
──────────────────────────────────────
  ☐ olist_closed_deals_dataset
  ☐ olist_marketing_qualified_leads_dataset
```

**When to use:**
- Simple, single-table data needs
- No joins or complex logic required
- Good for quick exploration

**Click on:** `olist_orders_dataset` (for practice)

### Option B: Custom Query (Recommended - Uses SQL Skills!)

```
☑ Enable data connector billing
☐ Use a custom query

[Enter Custom Query]
┌────────────────────────────────────────────────┐
│ SELECT                                          │
│   o.order_id,                                  │
│   o.customer_id,                               │
│   o.order_purchase_timestamp,                  │
│   c.customer_state,                            │
│   oi.price,                                    │
│   oi.freight_value                             │
│ FROM olist_sales_data_set.olist_orders_dataset o│
│ JOIN olist_sales_data_set.olist_customers_dataset c│
│   ON o.customer_id = c.customer_id            │
│ JOIN olist_sales_data_set.olist_order_items_dataset oi│
│   ON o.order_id = oi.order_id                 │
│ WHERE o.order_status = 'delivered'             │
└────────────────────────────────────────────────┘

                [Connect]
```

**When to use:**
- Need to join multiple tables (most common!)
- Apply WHERE filters
- Use calculated columns (like `price + freight_value`)
- Replicate complex SQL queries from Weeks 1-8

**Advantages:**
- ✅ Full SQL power
- ✅ Pre-filtered data (faster dashboards)
- ✅ Reuse queries you've already written

**Click checkbox:** ☑ Use a custom query

---

## Part 5: Creating Your First Data Source with Custom Query

### Example: Orders with Customer and Item Details

**Business Question:** We need to analyze order revenue by customer state.

**SQL Query (from Week 6):**
```sql
SELECT
    o.order_id,
    o.customer_id,
    o.order_purchase_timestamp::date as order_date,
    c.customer_state,
    c.customer_city,
    oi.product_id,
    oi.price,
    oi.freight_value,
    (oi.price + oi.freight_value) as total_order_value
FROM olist_sales_data_set.olist_orders_dataset o
JOIN olist_sales_data_set.olist_customers_dataset c
    ON o.customer_id = c.customer_id
JOIN olist_sales_data_set.olist_order_items_dataset oi
    ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered'
    AND o.order_purchase_timestamp >= '2017-01-01';
```

### Step-by-Step Setup

1. **Check "Use a custom query"**
2. **Paste your SQL query** in the text box
3. **Click "CONNECT"**

Looker Studio will:
- Validate your SQL syntax
- Run the query
- Detect field types (date, number, text)
- Create the data source

### Step 6: Name Your Data Source

After connecting, you'll see:

```
Untitled Data Source
──────────────────────────────────────
Connected to: PostgreSQL

[Rename to: "Olist Orders - Sales Analysis"]

Fields (9):
  📅 order_date          (Date)
  🏷️ customer_state     (Text)
  🏷️ customer_city      (Text)
  🔢 price               (Number)
  🔢 freight_value       (Number)
  🔢 total_order_value   (Number)
  ...
```

**Click on "Untitled Data Source"** and rename to something descriptive:
- Good: "Olist Orders - Sales Analysis"
- Good: "E-commerce Revenue Data"
- Bad: "Data Source 1"

**Click "CREATE REPORT"** (top-right blue button)

---

## Part 6: Verifying Your Connection

### Data Preview

After creating data source, look at the right panel:

```
Available Fields
──────────────────────────────────────
DIMENSIONS (6)
├── 📅 order_date
├── 🆔 order_id
├── 🆔 customer_id
├── 🏷️ customer_state
├── 🏷️ customer_city
└── 🆔 product_id

METRICS (3)
├── 🔢 price (Sum)
├── 🔢 freight_value (Sum)
└── 🔢 total_order_value (Sum)
```

**Verify:**
- ✅ Expected number of fields
- ✅ Correct data types (dates are dates, numbers are numbers)
- ✅ Dimensions vs. Metrics properly categorized

### Quick Test: Create a Table Chart

1. Looker auto-creates a table when you click "CREATE REPORT"
2. You should see rows of data
3. Try changing chart to a **Scorecard** (right panel)
   - Remove dimensions
   - Keep one metric (e.g., `total_order_value`)
   - You should see a total revenue number

**If you see data:** ✅ Connection successful!

---

## Part 7: Data Refresh Settings

### Understanding Data Freshness

Your Looker Studio report shows data from your database:

```
Database Changes → Report Updates?
─────────────────────────────────────
New orders added   → Need to refresh
Prices updated     → Need to refresh
Records deleted    → Need to refresh
```

### Refresh Options

#### Auto-Refresh (Default)
- Looker Studio caches data for 12 hours
- After 12 hours, next viewer triggers refresh
- Good for: Daily updated databases

#### Manual Refresh
- Click **"Refresh Data"** button
- Forces immediate update
- Good for: Testing after database changes

#### How to Refresh

**Option 1: In Data Source Settings**
1. Click **"Resource"** menu → **"Manage added data sources"**
2. Click **"EDIT"** next to your data source
3. Click **"REFRESH FIELDS"** button (top-right)

**Option 2: In View Mode**
1. Open report in View mode
2. Click **three dots** (⋮) top-right
3. Select **"Refresh data"**

### Cache Settings (Advanced)

For custom query data sources, you can control caching:

1. Edit data source
2. Look for **"Data Freshness"** section
3. Options:
   - Every 12 hours (default)
   - Every 4 hours
   - Every 1 hour
   - Every 15 minutes (rarely needed)

**Recommendation:** Keep default (12 hours) unless you need real-time dashboards.

---

## Part 8: Troubleshooting Common Connection Issues

### Error 1: "Connection failed"

**Possible causes:**
- ❌ Wrong host, port, or database name
- ❌ Incorrect username or password
- ❌ Firewall blocking connection
- ❌ SSL setting mismatch

**Solutions:**
1. **Double-check credentials** (copy-paste, don't type)
2. **Verify SSL is unchecked** for Supabase
3. **Contact instructor** if credentials are outdated
4. **Check Supabase status**: status.supabase.com

### Error 2: "Permission denied for schema"

**Possible causes:**
- ❌ Username lacks read permissions

**Solution:**
```sql
-- Instructor needs to run:
GRANT USAGE ON SCHEMA olist_sales_data_set TO postgres;
GRANT SELECT ON ALL TABLES IN SCHEMA olist_sales_data_set TO postgres;
```

### Error 3: "Invalid query syntax"

**Possible causes:**
- ❌ SQL syntax error in custom query
- ❌ Referencing non-existent table/column

**Solutions:**
1. **Test query in VS Code first** before pasting into Looker
2. **Check table names** (case-sensitive!)
3. **Avoid semicolons** at end of query (Looker doesn't need them)

### Error 4: "Data source cannot be created"

**Possible causes:**
- ❌ Query returns no data
- ❌ Query timeout (too slow)

**Solutions:**
1. **Add LIMIT 1000** to test if query works
2. **Simplify joins** if query is too complex
3. **Check date filters** (e.g., WHERE year = 2017 might return no rows)

---

## Part 9: Best Practices for Data Source Creation

### 1. Naming Conventions

**Good Names:**
- `Olist Sales - Delivered Orders Only`
- `Customer Analysis - 2017-2018`
- `Product Performance - Top Categories`

**Bad Names:**
- `Data Source 1`
- `New query`
- `Untitled`

**Why it matters:** You'll create multiple data sources—clear names help you find the right one.

### 2. Query Optimization

**Do:**
- ✅ Filter data with WHERE clauses
- ✅ Only SELECT columns you need
- ✅ Use date ranges (e.g., `>= '2017-01-01'`)
- ✅ Test query in VS Code first

**Don't:**
- ❌ SELECT * (grab everything)
- ❌ Pull entire dataset without filters
- ❌ Use overly complex subqueries (break into multiple data sources if needed)

**Example - Optimized Query:**
```sql
-- Good: Filtered and specific
SELECT
    o.order_purchase_timestamp::date as order_date,
    c.customer_state,
    SUM(oi.price) as revenue
FROM olist_sales_data_set.olist_orders_dataset o
JOIN olist_sales_data_set.olist_customers_dataset c ON o.customer_id = c.customer_id
JOIN olist_sales_data_set.olist_order_items_dataset oi ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered'
    AND o.order_purchase_timestamp >= '2017-01-01'
    AND o.order_purchase_timestamp < '2018-01-01'
GROUP BY o.order_purchase_timestamp::date, c.customer_state;
```

### 3. Reusability

Create **general-purpose data sources** that can power multiple reports:

**Example:**
- Instead of: "Sales Dashboard Data Source"
- Create: "Olist Orders - Complete" (can be used for sales, customer, product reports)

### 4. Documentation

Add descriptions to data sources:
1. Edit data source
2. Click **"⋮"** (three dots) next to data source name
3. Select **"Edit connection"**
4. Add **"Description"** field:

```
Description:
──────────────────────────────────────
Contains delivered orders from 2017-2018
with customer location and item pricing.
Used for: Sales analysis, customer segmentation.
Last updated: November 12, 2025
Contact: [Your Name]
```

---

## Part 10: Practice Activity (10 minutes)

### Task: Create a Supabase Data Source

**Objective:** Connect to Supabase and create a data source for order analysis.

#### Requirements:
1. Use PostgreSQL connector
2. Enter Supabase credentials (from instructor)
3. Use this custom query:

```sql
SELECT
    o.order_id,
    o.customer_id,
    o.order_purchase_timestamp::date as order_date,
    c.customer_state,
    oi.price,
    oi.freight_value,
    (oi.price + oi.freight_value) as total_value
FROM olist_sales_data_set.olist_orders_dataset o
JOIN olist_sales_data_set.olist_customers_dataset c
    ON o.customer_id = c.customer_id
JOIN olist_sales_data_set.olist_order_items_dataset oi
    ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered';
```

4. Name data source: `Olist Orders - Practice Connection`
5. Create report and verify data appears in a table

#### Success Criteria:
- ✅ Connection succeeds
- ✅ Data source shows 7 fields
- ✅ Table chart displays order data
- ✅ Can see customer states (SP, RJ, MG, etc.)

---

## Key Takeaways

### What You Learned
1. ✅ How to connect Looker Studio to PostgreSQL (Supabase)
2. ✅ Where to find and enter database credentials
3. ✅ Difference between table selection and custom queries
4. ✅ How to use SQL queries as data sources
5. ✅ Data refresh settings and cache management
6. ✅ Troubleshooting connection issues

### SQL Skills Applied
- Week 1: SELECT statements
- Week 2: JOINs (multiple tables)
- Week 3: WHERE filtering
- Week 5: Date casting and formatting

### Next Steps
In the next lesson (Part 3), you'll learn to create **calculated fields** in Looker Studio—the equivalent of SQL's calculated columns, but visual and reusable!

---

## Quick Reference: Connection Checklist

```
☐ Google account logged in
☐ Supabase credentials available
☐ PostgreSQL connector authorized
☐ Host path entered correctly
☐ Port set to 5432
☐ Database name correct
☐ Username and password entered
☐ SSL checkbox unchecked
☐ Custom query tested in VS Code
☐ Data source named descriptively
☐ Fields verify correctly (dimensions vs metrics)
☐ Test chart displays data
```

---

## Additional Resources

- **Looker Studio PostgreSQL Connector Docs:** [support.google.com/looker-studio/answer/7288010](https://support.google.com/looker-studio/answer/7288010)
- **Supabase Connection String Guide:** [supabase.com/docs/guides/database/connecting-to-postgres](https://supabase.com/docs/guides/database/connecting-to-postgres)
- **SQL to Looker Translation:** See `resources/sql_to_looker_translation.md`

---

**Next Lecture:** 03_calculated_fields_fundamentals.md
