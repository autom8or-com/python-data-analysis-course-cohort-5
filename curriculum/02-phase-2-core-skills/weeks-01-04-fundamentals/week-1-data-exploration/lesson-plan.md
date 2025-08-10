# Week 1: Programming Fundamentals & Data Exploration
**From Excel to SQL & Python with Solid Foundations**

## Session Overview
**Duration**: 2 hours (Wednesday & Thursday)  
**Goal**: Build Python/SQL fundamentals while learning data exploration, connecting every concept to Excel knowledge.

## Pre-Session Setup
- [ ] Students completed Week 0 programming foundations
- [ ] Supabase database with Olist data loaded
- [ ] Google Colab notebook template with Python basics
- [ ] Excel sample file for comparison
- [ ] Programming Fundamentals Workbook distributed

---

## Hour 1: Python Fundamentals + Data Exploration

### Opening: From Excel Cells to Python Variables (15 minutes)

**Start with what they mastered in Week 0:**
> "Last week you learned that programming is writing instructions instead of clicking. Today we'll use that knowledge to work with real business data."

**Excel to Python Connection** (10 minutes):
```python
# Excel: You put 1500 in cell A1 and name it "SalesTotal"
# Python: You create the same thing with variables
sales_total = 1500
company_name = "Olist"
current_year = 2018

print(f"Welcome to {company_name} data analysis!")
print(f"Total sales: ${sales_total}")
```

**Lists = Excel Columns** (5 minutes):
```python
# Excel: Column A contains customer states
# Python: List contains the same data
customer_states = ["SP", "RJ", "MG", "RS", "PR"]
order_amounts = [150.50, 89.90, 234.75, 67.25, 145.00]

# Access items like Excel cell references (but starting at 0!)
first_state = customer_states[0]  # Like A1
second_amount = order_amounts[1]  # Like B2
```

### Python Data Structures in Action (25 minutes)

#### Working with Olist Data Structure
```python
# Import the pandas library (like opening Excel)
import pandas as pd

# Load data (like File > Open in Excel)
orders_url = "https://raw.githubusercontent.com/olist/work-at-olist-data/master/datasets/olist_orders_dataset.csv"
orders = pd.read_csv(orders_url)

# Explore the data structure
print("Column names:", orders.columns.tolist())  # Like seeing Excel headers
print("Data types:", orders.dtypes)              # Like seeing if Excel shows numbers vs text
print("Shape:", orders.shape)                    # Like seeing row/column count
```

#### Understanding DataFrames vs Excel
```python
# DataFrames are like Excel worksheets, but more powerful
print("First 5 rows (like Ctrl+Home in Excel):")
print(orders.head())

print("\nColumn info (like right-clicking column header):")
print(orders.info())

# Working with specific columns (like selecting Excel columns)
order_ids = orders['order_id'].tolist()          # Convert column to Python list
print(f"First 3 order IDs: {order_ids[:3]}")    # List slicing
```

### Python Variables and Data Types with Real Data (20 minutes)

#### Extracting Business Information
```python
# Create variables from the data (like Excel calculated cells)
total_orders = len(orders)                                    # Like COUNT in Excel
unique_customers = orders['customer_id'].nunique()           # Like counting unique values
delivered_orders = len(orders[orders['order_status'] == 'delivered'])  # Like COUNTIF

# Create a summary dictionary (like Excel summary table)
business_summary = {
    "total_orders": total_orders,
    "unique_customers": unique_customers,
    "delivered_orders": delivered_orders,
    "delivery_rate": delivered_orders / total_orders * 100
}

# Display results
print("Business Summary:")
for key, value in business_summary.items():
    if key == "delivery_rate":
        print(f"{key}: {value:.1f}%")
    else:
        print(f"{key}: {value:,}")
```

---

## Hour 2: SQL Fundamentals + Data Querying

### Opening: Database Concepts for Excel Users (15 minutes)

**Database vs Excel Workbook**:
> "Think of a database like a super-organized Excel workbook with strict rules."

#### Key Database Terms (10 minutes):
```sql
-- DATABASE = Excel workbook (contains multiple tables)
-- TABLE = Excel worksheet 
-- ROW = Excel row
-- COLUMN = Excel column
-- PRIMARY KEY = Unique ID (like customer numbers in Excel)
-- FOREIGN KEY = Reference to another table (like customer ID in orders)
```

**Why Databases vs Excel** (5 minutes):
- **Size**: Databases handle millions of rows (Excel maxes at ~1 million)
- **Speed**: Databases are optimized for large data
- **Relationships**: Tables connect automatically (no manual VLOOKUP)
- **Integrity**: Databases prevent data errors

### SQL Fundamentals with Olist Data (25 minutes)

#### Part 1: Understanding Table Structure
```sql
-- Like looking at Excel column headers
SELECT column_name, data_type, is_nullable 
FROM information_schema.columns 
WHERE table_name = 'orders' 
AND table_schema = 'olist_sales_data_set';
```

#### Part 2: Basic SELECT (like Excel viewing)
```sql
-- This is like opening an Excel file and looking at the first page
SELECT * FROM olist_sales_data_set.orders LIMIT 10;

-- This is like selecting specific Excel columns
SELECT 
    order_id,
    order_status,
    order_purchase_timestamp
FROM olist_sales_data_set.orders
LIMIT 10;
```

#### Part 3: Data Types and Variables in SQL
```sql
-- SQL can create temporary variables (like Excel named cells)
WITH business_variables AS (
    SELECT 
        COUNT(*) as total_orders,
        COUNT(CASE WHEN order_status = 'delivered' THEN 1 END) as delivered_orders,
        EXTRACT(YEAR FROM CURRENT_DATE) as current_year
    FROM olist_sales_data_set.orders
)
SELECT 
    total_orders,
    delivered_orders,
    (delivered_orders * 100.0 / total_orders) as delivery_rate_percent
FROM business_variables;
```

#### Part 4: WHERE Clause (like Excel filters)
```sql
-- This is like using Excel's filter dropdown
SELECT 
    order_id,
    order_status,
    order_purchase_timestamp
FROM olist_sales_data_set.orders
WHERE order_status = 'delivered'
LIMIT 20;

-- Multiple conditions (like multiple Excel filters)
SELECT 
    order_id,
    order_status,
    order_purchase_timestamp
FROM olist_sales_data_set.orders
WHERE order_status = 'delivered' 
  AND EXTRACT(YEAR FROM order_purchase_timestamp) = 2018
LIMIT 20;
```

### Connecting Python and SQL Results (20 minutes)

#### Same Business Question, Two Tools
**Business Question**: "What's our delivery performance summary?"

**Python Approach**:
```python
# Calculate delivery metrics
total = len(orders)
delivered = len(orders[orders['order_status'] == 'delivered'])
rate = (delivered / total) * 100

print(f"Python Results:")
print(f"Total orders: {total:,}")
print(f"Delivered orders: {delivered:,}")
print(f"Delivery rate: {rate:.1f}%")
```

**SQL Approach**:
```sql
-- Same calculation in SQL
SELECT 
    COUNT(*) as total_orders,
    SUM(CASE WHEN order_status = 'delivered' THEN 1 ELSE 0 END) as delivered_orders,
    ROUND(
        SUM(CASE WHEN order_status = 'delivered' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 
        1
    ) as delivery_rate_percent
FROM olist_sales_data_set.orders;
```

**Key Learning**: Same logic, different syntax!

### Side-by-Side Comparison (10 minutes)
**Show on screen:**

| Task | Excel | SQL | Python |
|------|-------|-----|--------|
| Open data | File > Open | SELECT * FROM table | pd.read_csv() |
| Filter rows | Filter dropdown | WHERE condition | df[condition] |
| Select columns | Hide columns | SELECT specific columns | df[['col1', 'col2']] |
| Count results | Status bar | COUNT(*) | len(df) |

---

## Hour 2: Hands-On Practice

### Guided Practice (30 minutes)
**Students code along - start simple:**

#### Exercise 1: Basic Data Exploration (10 minutes)
**SQL Version:**
```sql
-- Look at the first 5 orders
SELECT * FROM olist_sales_data_set.orders LIMIT 5;

-- Count total orders
SELECT COUNT(*) as total_orders FROM olist_sales_data_set.orders;
```

**Python Version:**
```python
# Look at the first 5 orders
orders.head(5)

# Count total orders
total_orders = len(orders)
print(f"Total orders: {total_orders}")
```

#### Exercise 2: Simple Filtering (20 minutes)
**Business Question**: "How many orders were canceled?"

**SQL Version:**
```sql
SELECT COUNT(*) as canceled_orders
FROM olist_sales_data_set.orders
WHERE order_status = 'canceled';
```

**Python Version:**
```python
canceled_orders = orders[orders['order_status'] == 'canceled']
print(f"Canceled orders: {len(canceled_orders)}")
```

### Independent Exercise (20 minutes)
**Business Scenario**: "The manager wants to know about orders from 2017."

**Your tasks:**
1. **SQL**: Write a query to show all orders from 2017
2. **Python**: Filter the data to show only 2017 orders  
3. **Both**: Count how many orders were from 2017
4. **Bonus**: How many 2017 orders were delivered?

**Hints:**
- For dates, use `order_purchase_timestamp`
- SQL: Use `EXTRACT(YEAR FROM order_purchase_timestamp) = 2017`
- Python: Use `orders['order_purchase_timestamp'].dt.year == 2017`

### Q&A and Troubleshooting (10 minutes)
**Common Beginner Issues:**
- Forgetting quotes around text values
- Case sensitivity in column names  
- Understanding error messages
- SQL vs Python syntax differences

---

## Assessment & Homework

### Quick Check (5 minutes)
**Without looking at notes, can you:**
1. Write a SQL SELECT statement to show first 10 customers?
2. Write Python code to load the orders data?
3. Explain what `WHERE` does in SQL?
4. Explain what `df[condition]` does in Python?

### Homework Assignment
**Scenario**: You're helping analyze customer locations.

**Tasks:**
1. Load the customers dataset in Python
2. Write SQL to show customers from 'SP' state
3. Count customers by state in both SQL and Python
4. Reflection: Write 2-3 sentences comparing Excel filters to SQL WHERE clauses

**Deliverable**: Screenshots of working code + the reflection paragraph

---

## Instructor Notes

### Key Success Indicators
- [ ] Students can load data in both tools
- [ ] Students understand WHERE = Excel filter
- [ ] Students can count filtered results
- [ ] Students ask meaningful questions about syntax

### Common Struggles & Solutions
1. **"This is harder than Excel"** → Emphasize power/flexibility gains
2. **Syntax errors** → Show side-by-side comparison charts
3. **"Why learn both?"** → Explain different use cases (databases vs files)
4. **Overwhelm** → Slow down, return to Excel analogy

### Differentiation Strategies
- **Fast learners**: Challenge with multiple conditions, introduce OR logic
- **Struggling learners**: Pair programming, more Excel comparisons
- **Visual learners**: Use diagrams showing data flow

---

*Remember: Every new concept should be connected back to something they already know from Excel.*