# Python Syntax Cheat Sheet
**Week 01 - Quick Reference Guide**

## Variables and Data Types

### Creating Variables
```python
# Text (strings) - always use quotes
company_name = "NaijaCommerce"
customer_email = "user@email.com"

# Numbers
age = 25                    # Integer (whole numbers)
price = 1250.50            # Float (decimal numbers)

# True/False values
is_vip = True              # Boolean (True or False)
has_discount = False
```

### Variable Naming Rules
```python
# ✅ Good variable names
customer_name = "John"      # Use underscores for spaces
sales_2024 = 50000         # Numbers at end are OK
total_revenue = 1000000    # Descriptive names

# ❌ Bad variable names (will cause errors)
# customer name = "John"   # No spaces allowed
# 2024_sales = 50000       # Can't start with numbers
# class = "Premium"        # 'class' is reserved word
```

## Working with Numbers

### Basic Math Operations
```python
# Basic calculations
total = 1000 + 500         # Addition
difference = 1000 - 200    # Subtraction
product = 100 * 15         # Multiplication
division = 1000 / 4        # Division (gives decimal)
whole_division = 1000 // 3 # Division (whole numbers only)
remainder = 1000 % 3       # Remainder after division

# Business example
price = 50000
tax_rate = 0.075           # 7.5%
tax_amount = price * tax_rate
final_price = price + tax_amount
```

### Formatting Numbers
```python
price = 1250000.50
print(f"Price: ₦{price:,}")           # ₦1,250,000.5
print(f"Price: ₦{price:,.2f}")        # ₦1,250,000.50
print(f"Tax Rate: {tax_rate:.1%}")    # Tax Rate: 7.5%
```

## Working with Text (Strings)

### String Operations
```python
first_name = "Adebayo"
last_name = "Okonkwo"

# Combine strings
full_name = first_name + " " + last_name
# Or use f-strings (recommended)
full_name = f"{first_name} {last_name}"

# String methods
print(first_name.upper())    # ADEBAYO
print(first_name.lower())    # adebayo
print(len(full_name))        # 15 (number of characters)
```

### Common String Patterns
```python
# Email generation
email = f"{first_name.lower()}@company.com"

# Display formatting
greeting = f"Hello {first_name}, welcome to our store!"
```

## Lists (Collections of Items)

### Creating and Using Lists
```python
# Create lists
cities = ["Lagos", "Abuja", "Port Harcourt"]
prices = [100, 250, 75, 400]
mixed_list = ["Product", 500, True, 25.50]

# Access items (starts counting from 0!)
first_city = cities[0]        # "Lagos"
second_city = cities[1]       # "Abuja" 
last_city = cities[-1]        # "Port Harcourt"

# List properties
num_cities = len(cities)      # 3
```

### List Operations
```python
sales = [1000, 1500, 1200, 1800, 900]

# Math with lists
total_sales = sum(sales)      # 6400
average_sales = sum(sales) / len(sales)  # 1280.0
max_sales = max(sales)        # 1800
min_sales = min(sales)        # 900

# Add items to list
sales.append(2000)           # Add to end
```

## Dictionaries (Key-Value Pairs)

### Creating Dictionaries
```python
# Customer information
customer = {
    "name": "Fatima Abdullahi",
    "city": "Abuja",
    "age": 28,
    "is_vip": True,
    "total_orders": 12
}

# Product prices (like lookup table)
prices = {
    "iPhone": 1250000,
    "Samsung": 980000,
    "MacBook": 2500000
}
```

### Using Dictionaries
```python
# Get values
customer_name = customer["name"]
iphone_price = prices["iPhone"]

# Check if key exists
if "iPad" in prices:
    ipad_price = prices["iPad"]
else:
    print("iPad not found")

# Safe way to get values
ipad_price = prices.get("iPad", 0)  # Returns 0 if not found
```

## Basic Programming Logic

### If Statements (Conditions)
```python
order_total = 125000

if order_total > 100000:
    customer_type = "VIP"
    discount = 0.10
elif order_total > 50000:
    customer_type = "Premium"
    discount = 0.05
else:
    customer_type = "Regular"
    discount = 0.0

print(f"Customer: {customer_type}, Discount: {discount:.1%}")
```

### Loops (Repeating Operations)
```python
# Loop through list
products = ["iPhone", "Samsung", "MacBook"]
prices = [1250000, 980000, 2500000]

# Method 1: Simple loop
for product in products:
    print(f"Product: {product}")

# Method 2: Loop with index
for i in range(len(products)):
    print(f"{products[i]}: ₦{prices[i]:,}")

# Method 3: Loop through dictionary
customer_info = {"name": "John", "city": "Lagos", "age": 30}
for key, value in customer_info.items():
    print(f"{key}: {value}")
```

## Working with Pandas (DataFrames)

### Import and Basic Setup
```python
import pandas as pd

# Create DataFrame from dictionary
data = {
    'customer': ['John', 'Mary', 'Paul'],
    'city': ['Lagos', 'Abuja', 'Kano'],
    'order_value': [50000, 75000, 120000]
}
df = pd.DataFrame(data)
```

### Essential DataFrame Operations
```python
# View data
df.head()                    # First 5 rows
df.tail()                    # Last 5 rows
df.info()                    # Dataset information
df.describe()                # Summary statistics

# Select columns
names = df['customer']       # Single column
subset = df[['customer', 'order_value']]  # Multiple columns

# Filter data
high_value = df[df['order_value'] > 60000]  # Orders over ₦60,000
lagos_customers = df[df['city'] == 'Lagos'] # Lagos customers only

# Sort data
sorted_df = df.sort_values('order_value', ascending=False)  # High to low

# Group and analyze
city_stats = df.groupby('city')['order_value'].sum()  # Total by city
```

## Common Functions

### Math Functions
```python
import math

# Basic functions
abs(-10)                     # 10 (absolute value)
round(3.14159, 2)           # 3.14 (round to 2 decimals)
math.sqrt(16)               # 4.0 (square root)
```

### String Functions
```python
text = "  Hello World  "
text.strip()                # "Hello World" (remove spaces)
text.replace("World", "Nigeria")  # "Hello Nigeria"
text.split()                # ["Hello", "World"]
```

## Print and Display

### Basic Printing
```python
print("Hello World")
print(f"Customer: {name}, Order: ₦{amount:,}")

# Multiple items
name = "John"
age = 25
print("Name:", name, "Age:", age)
```

### Formatted Printing
```python
# F-strings (recommended)
print(f"Revenue: ₦{revenue:,}")           # Comma formatting
print(f"Growth: {growth:.1%}")            # Percentage
print(f"Price: ₦{price:.2f}")             # 2 decimal places

# Multiple lines
print(f"""
Customer: {name}
City: {city}
Total: ₦{total:,}
""")
```

## Common Error Messages and Fixes

### NameError
```python
# ❌ Error: name 'customer_name' is not defined
print(customer_name)  # Variable not created yet

# ✅ Fix: Create variable first
customer_name = "John"
print(customer_name)
```

### TypeError
```python
# ❌ Error: can only concatenate str (not "int") to str
result = "Total: " + 1000

# ✅ Fix: Convert number to string
result = "Total: " + str(1000)
# Or use f-string
result = f"Total: {1000}"
```

### KeyError
```python
prices = {"iPhone": 1250000, "Samsung": 980000}

# ❌ Error: KeyError: 'iPad'
ipad_price = prices["iPad"]  # iPad doesn't exist

# ✅ Fix: Check if key exists
if "iPad" in prices:
    ipad_price = prices["iPad"]
else:
    print("iPad not found")

# Or use .get()
ipad_price = prices.get("iPad", 0)  # Returns 0 if not found
```

### IndexError
```python
products = ["iPhone", "Samsung", "MacBook"]

# ❌ Error: list index out of range
fourth_product = products[3]  # Only indices 0, 1, 2 exist

# ✅ Fix: Check list length
if len(products) > 3:
    fourth_product = products[3]
else:
    print("Not enough products")
```

## Quick Reference Summary

| Task | Excel | Python |
|------|-------|---------|
| Store value | Named cell | `variable = value` |
| Add numbers | `=A1+B1` | `total = a + b` |
| Text combination | `=A1&B1` | `f"{a}{b}"` |
| Conditional | `=IF(A1>100,"High","Low")` | `if a > 100: result = "High"` |
| List of values | Column range | `list = [1, 2, 3]` |
| Lookup table | VLOOKUP | `dict = {"key": "value"}` |
| Count items | COUNT | `len(list)` |
| Sum values | SUM | `sum(list)` |
| Average | AVERAGE | `sum(list)/len(list)` |

---

**Remember**: Python is just another way to express the same logic you already use in Excel. Focus on the concepts, not memorizing syntax!