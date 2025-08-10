# Programming Fundamentals Workbook
**Your Excel-to-Code Translation Guide**

## How to Use This Workbook

**Purpose**: This workbook connects every programming concept to something you already know from Excel.

**Structure**: Each concept has:
- 🔗 **Excel Connection**: What you already know
- 💡 **Programming Concept**: The new idea
- 📝 **Practice**: Try it yourself
- 🚫 **Common Mistakes**: What to avoid

---

## Chapter 1: Variables and Data Types

### 🔗 Excel Connection: Named Cells and Data Types

**In Excel**, you might have:
- A cell named "SalesTotal" that contains 1500
- Another cell with "CompanyName" that contains "ABC Corp"
- Excel automatically knows 1500 is a number and "ABC Corp" is text

### 💡 Programming Concept: Variables

**In Python**, you create the same thing with variables:
```python
# Variable name = value
sales_total = 1500          # Number (integer)
company_name = "ABC Corp"   # Text (string)
tax_rate = 0.08            # Decimal (float)
is_profitable = True       # Yes/No (boolean)
```

**In SQL**, you can also create temporary values:
```sql
-- Using variables in queries
SELECT 
    order_total,
    order_total * 0.08 as tax_amount,
    'Profitable' as status
FROM orders;
```

### 📝 Practice: Create Your Own Variables

Fill in the blanks to create variables about your business:
```python
# Your turn - fill in realistic values
monthly_revenue = ____
company_city = "____"
number_of_employees = ____
has_online_store = ____  # True or False
```

### 🚫 Common Mistakes
❌ `sales total = 1500` (spaces in variable names)  
✅ `sales_total = 1500` (use underscores)

❌ `company_name = ABC Corp` (missing quotes for text)  
✅ `company_name = "ABC Corp"` (text needs quotes)

---

## Chapter 2: Lists (Arrays)

### 🔗 Excel Connection: Column Ranges

**In Excel**, you work with ranges like A1:A10:
```
A1: Apple
A2: Banana  
A3: Orange
A4: Grape
```

### 💡 Programming Concept: Lists

**In Python**, you create lists:
```python
# A list is like a column in Excel
fruits = ["Apple", "Banana", "Orange", "Grape"]
prices = [1.50, 0.75, 2.00, 3.25]
months = ["Jan", "Feb", "Mar", "Apr", "May"]

# Access items like Excel cell references
first_fruit = fruits[0]    # Like A1 (but starts at 0!)
second_price = prices[1]   # Like B2
```

**In SQL**, you work with lists using IN:
```sql
-- Like filtering multiple values in Excel
SELECT * FROM products 
WHERE category IN ('Electronics', 'Clothing', 'Books');
```

### 📝 Practice: Create Business Lists

```python
# Create lists for your business scenario
customer_states = ["____", "____", "____"]
quarterly_sales = [____, ____, ____, ____]
product_categories = ["____", "____", "____"]

# Access the first item in each list
print("First state:", customer_states[0])
print("Q1 sales:", quarterly_sales[0])
```

### 🚫 Common Mistakes
❌ `fruits = Apple, Banana` (missing brackets and quotes)  
✅ `fruits = ["Apple", "Banana"]` (lists need brackets)

❌ `first_item = fruits[1]` (thinking it starts at 1)  
✅ `first_item = fruits[0]` (programming starts counting at 0)

---

## Chapter 3: Dictionaries (Key-Value Pairs)

### 🔗 Excel Connection: Lookup Tables

**In Excel**, you might have a lookup table:
```
A1: Product    B1: Price
A2: Laptop     B2: 999
A3: Mouse      B3: 25
A4: Keyboard   B4: 75
```
Then use VLOOKUP to find prices by product name.

### 💡 Programming Concept: Dictionaries

**In Python**, dictionaries work like lookup tables:
```python
# Dictionary = {key: value}
product_prices = {
    "Laptop": 999,
    "Mouse": 25,
    "Keyboard": 75
}

# Look up values (like VLOOKUP)
laptop_price = product_prices["Laptop"]  # Returns 999
```

**In SQL**, you JOIN tables (like advanced VLOOKUP):
```sql
-- Join product table with price table
SELECT p.product_name, pr.price
FROM products p
JOIN prices pr ON p.product_id = pr.product_id;
```

### 📝 Practice: Create Business Lookups

```python
# Create a dictionary for customer information
customer_info = {
    "name": "____",
    "city": "____", 
    "total_orders": ____,
    "vip_status": ____  # True or False
}

# Look up information
print("Customer name:", customer_info["name"])
print("Is VIP:", customer_info["vip_status"])
```

### 🚫 Common Mistakes
❌ `prices = {"Laptop" 999}` (missing colon)  
✅ `prices = {"Laptop": 999}` (need colon between key and value)

❌ `price = prices[Laptop]` (missing quotes)  
✅ `price = prices["Laptop"]` (keys need quotes if they're text)

---

## Chapter 4: Functions

### 🔗 Excel Connection: Excel Functions and Formulas

**In Excel**, you use functions like:
- `=SUM(A1:A10)` - adds up a range
- `=AVERAGE(B1:B10)` - calculates average
- `=IF(C1>100, "High", "Low")` - conditional logic

### 💡 Programming Concept: Creating Your Own Functions

**In Python**, you can create custom functions:
```python
# Define a function (like creating a custom Excel formula)
def calculate_tax(price, tax_rate):
    tax_amount = price * tax_rate
    return tax_amount

# Use the function (like using =SUM() in Excel)
item_price = 100
tax_owed = calculate_tax(item_price, 0.08)  # Returns 8.0
```

**In SQL**, you use built-in functions:
```sql
-- SQL has many built-in functions like Excel
SELECT 
    SUM(order_total) as total_sales,
    AVG(order_total) as average_order,
    COUNT(*) as number_of_orders
FROM orders;
```

### 📝 Practice: Create Business Functions

```python
def calculate_discount(original_price, discount_percent):
    """
    Calculate discount amount (like creating a custom Excel formula)
    """
    discount_amount = original_price * (discount_percent / 100)
    return discount_amount

# Test your function
original = 200
discount = 15  # 15% discount
savings = calculate_discount(original, discount)
print(f"You save ${savings} on a ${original} item")
```

### 🚫 Common Mistakes
❌ `def calculatetax(price):` (missing underscore in function name)  
✅ `def calculate_tax(price):` (use underscores for readability)

❌ `return price * tax_rate` (forgetting to define tax_rate parameter)  
✅ `def calculate_tax(price, tax_rate): return price * tax_rate`

---

## Chapter 5: Control Flow (If/Else, Loops)

### 🔗 Excel Connection: IF Statements and Applying Formulas to Ranges

**In Excel**:
- `=IF(A1>100, "VIP", "Regular")` - conditional logic
- Copying formulas down a column - repeating operations

### 💡 Programming Concept: If/Else and Loops

**Python If/Else** (like Excel IF):
```python
order_total = 150

if order_total > 100:
    customer_type = "VIP"
    discount = 0.10
else:
    customer_type = "Regular" 
    discount = 0.05

print(f"Customer is {customer_type}, discount: {discount*100}%")
```

**Python Loops** (like copying formulas down):
```python
order_totals = [50, 150, 75, 200, 120]

# This is like applying a formula to each row
for total in order_totals:
    if total > 100:
        status = "VIP"
    else:
        status = "Regular"
    print(f"Order ${total}: {status}")
```

**SQL Conditional Logic**:
```sql
-- Like Excel IF statements
SELECT 
    order_id,
    order_total,
    CASE 
        WHEN order_total > 100 THEN 'VIP'
        ELSE 'Regular'
    END as customer_type
FROM orders;
```

### 📝 Practice: Business Logic

```python
# Customer categorization logic
customer_orders = [25, 75, 150, 300, 45]

for order_amount in customer_orders:
    if order_amount >= 200:
        category = "Premium"
        shipping = "Free"
    elif order_amount >= 100:
        category = "VIP"  
        shipping = "Discounted"
    else:
        category = "Standard"
        shipping = "Regular"
    
    print(f"${order_amount} order: {category} customer, {shipping} shipping")
```

### 🚫 Common Mistakes
❌ `if order_total > 100` (missing colon)  
✅ `if order_total > 100:` (if statements need colons)

❌ ```
if order_total > 100:
customer_type = "VIP"
```
(wrong indentation)

✅ ```
if order_total > 100:
    customer_type = "VIP"
```
(Python uses indentation to show what's inside the if)

---

## Chapter 6: SQL Database Fundamentals

### 🔗 Excel Connection: Multiple Related Worksheets

**In Excel**, you might have:
- Sheet1: Customer information
- Sheet2: Order information  
- Sheet3: Product information
- Use VLOOKUP to connect information between sheets

### 💡 Programming Concept: Database Tables and Relationships

**SQL Database Structure**:
```sql
-- Tables are like Excel worksheets, but with relationships

-- Customers table (like Customer worksheet)
CREATE TABLE customers (
    customer_id PRIMARY KEY,  -- Like a unique ID column
    customer_name TEXT,
    customer_city TEXT
);

-- Orders table (like Orders worksheet)  
CREATE TABLE orders (
    order_id PRIMARY KEY,
    customer_id REFERENCES customers,  -- Links to customers table
    order_date DATE,
    order_total DECIMAL
);
```

**Key Database Terms**:
- **Table** = Excel worksheet
- **Row** = Excel row
- **Column** = Excel column  
- **Primary Key** = Unique identifier (like customer ID)
- **Foreign Key** = Reference to another table (like customer ID in orders)

### 📝 Practice: Understanding Relationships

```sql
-- This is like using VLOOKUP across multiple Excel sheets
SELECT 
    c.customer_name,
    c.customer_city,
    o.order_date,
    o.order_total
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
WHERE c.customer_city = 'New York';
```

### 🚫 Common Mistakes
❌ Thinking databases are just big Excel files (they have relationships and rules)  
✅ Understanding that tables are connected and have data integrity rules

❌ `SELECT * FROM customers, orders` (old way of joining)  
✅ `SELECT * FROM customers JOIN orders ON customers.id = orders.customer_id`

---

## Quick Reference: Excel to Code Cheat Sheet

| What You Want | Excel | SQL | Python |
|---------------|-------|-----|--------|
| **Store a value** | Named cell | Variable in query | `variable = value` |
| **List of values** | Column range | Column or IN list | `list = [1, 2, 3]` |
| **Lookup table** | VLOOKUP | JOIN tables | `dict = {"key": "value"}` |
| **Conditional logic** | IF function | CASE WHEN | `if condition:` |
| **Repeat operation** | Copy formula down | Apply to all rows | `for item in list:` |
| **Calculate sum** | SUM function | SUM() | `sum(list)` |
| **Count items** | COUNT function | COUNT() | `len(list)` |
| **Filter data** | Filter dropdown | WHERE clause | `df[condition]` |

---

## Confidence Building Reminders

### You Already Think Like a Programmer! 

When you created Excel formulas, you were already:
- ✅ **Using variables** (cell references like A1, B2)
- ✅ **Writing functions** (=SUM, =AVERAGE, =IF)
- ✅ **Using conditional logic** (IF statements)
- ✅ **Working with data types** (numbers, text, dates)
- ✅ **Debugging errors** (fixing #VALUE! and #REF! errors)

### Programming is Just Excel Logic in Text Form

- Same logical thinking
- Same problem-solving approach  
- Same goal: get insights from data
- Different syntax, same concepts

---

*Keep this workbook handy as you learn. Every time you encounter a new programming concept, try to connect it to something you already know from Excel.*