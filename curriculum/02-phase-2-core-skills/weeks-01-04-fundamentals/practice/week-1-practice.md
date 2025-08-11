# Week 1 Practice Exercises
**Data Exploration & Basic Filtering with Olist Dataset**

## Before You Start
**Mindset**: You're doing the same things you do in Excel, just writing instructions instead of clicking buttons.

**Setup Checklist**:
- [ ] Access to Supabase database (SQL)
- [ ] Google Colab notebook open (Python)
- [ ] Excel file with Olist sample data (for comparison)

---

## Exercise Set 1: Getting Familiar with Data (Beginner)

### Business Context
You've just started working at Olist as a data analyst. Your manager wants you to get familiar with the orders database.

### Task 1A: First Look at the Data
**Excel Equivalent**: Opening a file and scrolling through the first page

**SQL Challenge**:
```sql
-- Write a query to see the first 10 orders in the database
-- Include: order_id, order_status, and order_purchase_timestamp
```

**Python Challenge**:
```python
# Load the orders data and display the first 10 rows
# Show only: order_id, order_status, and order_purchase_timestamp
```

**Expected Output**: 10 rows showing basic order information

### Task 1B: Data Size Check
**Excel Equivalent**: Looking at the row counter at the bottom

**SQL Challenge**:
```sql
-- How many total orders are in our database?
```

**Python Challenge**:
```python
# Count the number of orders in the dataset
```

**Expected Output**: A single number (around 99,441 orders)

---

## Exercise Set 2: Basic Filtering (Intermediate)

### Business Context  
Your manager asks: "How are we doing with order deliveries? I want to see only completed orders."

### Task 2A: Filter by Order Status
**Excel Equivalent**: Using the filter dropdown to show only "delivered" orders

**SQL Challenge**:
```sql
-- Show all orders with status = 'delivered'
-- Display: order_id, order_status, order_purchase_timestamp
-- Limit to first 20 results
```

**Python Challenge**:
```python
# Filter to show only delivered orders
# Display the same columns and first 20 results
```

**Expected Output**: 20 rows of delivered orders

### Task 2B: Count Filtered Results
**Excel Equivalent**: Seeing "X of Y records found" after filtering

**SQL Challenge**:
```sql
-- How many orders have been delivered?
```

**Python Challenge**:
```python
# Count how many orders have 'delivered' status
```

**Expected Output**: A count of delivered orders

---

## Exercise Set 3: Multiple Conditions (Advanced)

### Business Context
The logistics team wants to analyze recent performance: "Show me orders from 2018 that were delivered."

### Task 3A: Date + Status Filter
**Excel Equivalent**: Using multiple filter dropdowns simultaneously

**SQL Challenge**:
```sql
-- Find orders from 2018 that have been delivered
-- Hint: Use EXTRACT(YEAR FROM order_purchase_timestamp) = 2018
-- Show: order_id, order_status, order_purchase_timestamp
```

**Python Challenge**:
```python
# Filter for delivered orders from 2018
# Hint: Use orders['order_purchase_timestamp'].dt.year == 2018
# Show the same columns
```

**Expected Output**: Delivered orders from 2018 only

### Task 3B: Performance Summary
**SQL Challenge**:
```sql
-- Count delivered orders by year (2016, 2017, 2018)
-- Show: year and count of delivered orders
```

**Python Challenge**:
```python
# Create a summary showing delivered orders by year
```

**Expected Output**: A summary table showing year and count

---

## Exercise Set 4: Real Business Scenario

### Business Context
**Email from Manager**: 
"Hi! I need to prepare for Monday's meeting. Can you help me understand our order cancellations? Specifically:
1. How many orders were cancelled in total?  
2. How does this compare to delivered orders?
3. What percentage of orders were cancelled?"

### Your Mission
Answer all three questions using both SQL and Python.

**Guidelines**:
- Write clear, commented code
- Show your results clearly
- Calculate the percentage (cancelled ÷ total orders × 100)

**SQL Starter Code**:
```sql
-- Question 1: Count cancelled orders
SELECT COUNT(*) as cancelled_orders
FROM olist_sales_data_set.olist_orders_dataset
WHERE order_status = 'canceled';

-- Add your code for questions 2 and 3 here
```

**Python Starter Code**:
```python
# Question 1: Count cancelled orders
cancelled_count = len(orders[orders['order_status'] == 'canceled'])
print(f"Cancelled orders: {cancelled_count}")

# Add your code for questions 2 and 3 here
```

---

## Self-Check Questions

After completing the exercises, ask yourself:

1. **Understanding**: Can I explain what `WHERE` does in SQL and `df[condition]` does in Python?
2. **Excel Connection**: How is SQL's `WHERE` similar to Excel's filter dropdowns?
3. **Syntax**: Do I understand why we use single quotes around text values?
4. **Problem Solving**: If I got an error, could I identify what went wrong?
5. **Business Context**: Can I explain what these numbers mean for the business?

---

## Troubleshooting Guide

### Common Errors and Solutions

#### SQL Errors
```
Error: column "order_Status" does not exist
```
**Fix**: Check spelling and capitalization → `order_status`

```
Error: syntax error at or near "FROM"
```
**Fix**: Missing comma in SELECT list

#### Python Errors
```
KeyError: 'order_Status'
```
**Fix**: Check column name spelling → `'order_status'`

```
TypeError: cannot compare to string
```
**Fix**: Make sure you're comparing the right data types

### Getting Help
1. **Read the error message** - it usually tells you what's wrong
2. **Check your spelling** - column names must match exactly
3. **Compare with examples** - look at working code for patterns
4. **Ask for help** - instructors are here to support you!

---

## Homework Reflection

After completing the exercises, write a short reflection (3-4 sentences) answering:

1. **What felt familiar?** How did these programming concepts connect to your Excel experience?
2. **What felt challenging?** What was harder than expected?
3. **Aha moments**: Did anything "click" during the exercises?
4. **Next steps**: What do you want to learn more about?

**Submit**: Screenshots of your working code + the reflection paragraph

---

## Answer Key Available
*Instructors: Detailed solutions with explanations available in separate answer key document*

---

*Remember: You're not expected to memorize syntax. Focus on understanding the logic - the syntax will come with practice!*