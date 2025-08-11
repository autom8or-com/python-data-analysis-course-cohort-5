# Common Python Errors and Solutions Guide
**Week 01 - Troubleshooting Reference**

---

## How to Read Error Messages

### Python Error Structure
```
Traceback (most recent call last):
  File "<ipython-input-1-abc123>", line 2, in <module>
    print(customer_name)
NameError: name 'customer_name' is not defined
```

**Parts of the error:**
- **File and line**: Where the error occurred
- **Error type**: `NameError` (the category)
- **Error message**: What went wrong
- **Your code**: The line that caused the problem

---

## Top 10 Most Common Errors for Beginners

### 1. NameError - "Variable Not Defined"

**What it looks like:**
```
NameError: name 'customer_name' is not defined
```

**Common causes:**
```python
# ❌ Trying to use a variable before creating it
print(customer_name)  # customer_name doesn't exist yet

# ❌ Typo in variable name
customer_name = "John"
print(costumer_name)  # Misspelled 'customer'

# ❌ Wrong capitalization
Customer_Name = "John"
print(customer_name)  # Python is case-sensitive
```

**How to fix:**
```python
# ✅ Create variable first
customer_name = "John"
print(customer_name)

# ✅ Check spelling carefully
customer_name = "John"
print(customer_name)  # Correct spelling

# ✅ Match exact capitalization
customer_name = "John"  # Use lowercase with underscores
print(customer_name)
```

**Business example:**
```python
# ❌ This will cause NameError
monthly_revenue = 500000
print(monthly_revenu)  # Typo!

# ✅ Fixed version
monthly_revenue = 500000
print(monthly_revenue)  # Correct spelling
```

---

### 2. SyntaxError - "Invalid Syntax"

**What it looks like:**
```
SyntaxError: invalid syntax
```

**Common causes:**
```python
# ❌ Missing quotes around text
company_name = NaijaCommerce  # Missing quotes

# ❌ Missing colons in if statements
if sales > 100000
    print("High sales")

# ❌ Wrong indentation
if sales > 100000:
print("High sales")  # Should be indented

# ❌ Mixing quotes
name = "John'  # Started with " but ended with '
```

**How to fix:**
```python
# ✅ Always quote text
company_name = "NaijaCommerce"

# ✅ Add colons after if statements
if sales > 100000:
    print("High sales")

# ✅ Proper indentation (4 spaces)
if sales > 100000:
    print("High sales")

# ✅ Match quote types
name = "John"  # Both quotes are "
# OR
name = 'John'  # Both quotes are '
```

---

### 3. TypeError - "Wrong Data Type"

**What it looks like:**
```
TypeError: can only concatenate str (not "int") to str
```

**Common causes:**
```python
# ❌ Mixing text and numbers
result = "Total: " + 1000  # Can't add text + number

# ❌ Wrong function usage
len(1000)  # len() works on text/lists, not numbers

# ❌ Calling non-function
price = 1000
result = price()  # price is a number, not a function
```

**How to fix:**
```python
# ✅ Convert number to text
result = "Total: " + str(1000)
# Or use f-strings (recommended)
result = f"Total: {1000}"

# ✅ Use appropriate functions
len("Hello")      # len() on text
len([1, 2, 3])   # len() on lists

# ✅ Don't add () to variables
price = 1000
result = price   # Just use the variable name
```

**Business example:**
```python
# ❌ This will cause TypeError
order_number = 1001
message = "Order " + order_number + " is ready"

# ✅ Fixed versions
order_number = 1001
message = "Order " + str(order_number) + " is ready"
# Or better:
message = f"Order {order_number} is ready"
```

---

### 4. IndentationError - "Incorrect Spacing"

**What it looks like:**
```
IndentationError: expected an indented block
```

**Common causes:**
```python
# ❌ Missing indentation after if/for
if customer_is_vip:
print("Apply discount")  # Should be indented

# ❌ Mixing tabs and spaces (invisible error!)
if sales > 100000:
    print("Line 1")  # 4 spaces
	print("Line 2")  # Tab character (different!)

# ❌ Wrong indentation level
if customer_is_vip:
  print("VIP customer")      # 2 spaces
    print("Apply discount")  # 4 spaces - inconsistent!
```

**How to fix:**
```python
# ✅ Always indent 4 spaces after colons
if customer_is_vip:
    print("Apply discount")  # 4 spaces

# ✅ Use spaces consistently (avoid tabs)
if sales > 100000:
    print("Line 1")    # 4 spaces
    print("Line 2")    # 4 spaces

# ✅ Consistent indentation
if customer_is_vip:
    print("VIP customer")    # 4 spaces
    print("Apply discount")  # 4 spaces
```

---

### 5. KeyError - "Dictionary Key Not Found"

**What it looks like:**
```
KeyError: 'phone'
```

**Common causes:**
```python
# ❌ Accessing non-existent dictionary key
customer = {"name": "John", "city": "Lagos"}
phone = customer["phone"]  # "phone" key doesn't exist

# ❌ Typo in key name
customer = {"customer_name": "John"}
name = customer["name"]  # Should be "customer_name"

# ❌ Case sensitivity
customer = {"Name": "John"}
name = customer["name"]  # "Name" vs "name"
```

**How to fix:**
```python
# ✅ Check if key exists first
customer = {"name": "John", "city": "Lagos"}
if "phone" in customer:
    phone = customer["phone"]
else:
    phone = "Not provided"

# ✅ Use .get() method with default
phone = customer.get("phone", "Not provided")

# ✅ Check exact key names
customer = {"customer_name": "John"}
name = customer["customer_name"]  # Correct key
```

**Business example:**
```python
# ❌ This will cause KeyError
product_prices = {"iPhone": 1250000, "Samsung": 980000}
ipad_price = product_prices["iPad"]  # iPad not in dictionary

# ✅ Fixed versions
# Option 1: Check first
if "iPad" in product_prices:
    ipad_price = product_prices["iPad"]
else:
    ipad_price = 0

# Option 2: Use .get() (recommended)
ipad_price = product_prices.get("iPad", 0)  # Returns 0 if not found
```

---

### 6. IndexError - "List Index Out of Range"

**What it looks like:**
```
IndexError: list index out of range
```

**Common causes:**
```python
# ❌ Trying to access item beyond list length
products = ["iPhone", "Samsung", "MacBook"]  # 3 items (indices 0, 1, 2)
fourth_product = products[3]  # Index 3 doesn't exist

# ❌ Using Excel thinking (starting from 1)
first_product = products[1]  # This gets the SECOND item!

# ❌ Empty list
empty_list = []
first_item = empty_list[0]  # No items to access
```

**How to fix:**
```python
# ✅ Remember Python starts counting at 0
products = ["iPhone", "Samsung", "MacBook"]
first_product = products[0]   # "iPhone"
second_product = products[1]  # "Samsung"
third_product = products[2]   # "MacBook"

# ✅ Check list length first
if len(products) > 3:
    fourth_product = products[3]
else:
    print("Not enough products")

# ✅ Use negative indexing for last items
last_product = products[-1]   # "MacBook" (last item)
```

---

### 7. AttributeError - "Object Has No Method"

**What it looks like:**
```
AttributeError: 'int' object has no attribute 'upper'
```

**Common causes:**
```python
# ❌ Using string methods on numbers
age = 25
age_upper = age.upper()  # Numbers don't have .upper()

# ❌ Typo in method name
name = "John"
name_caps = name.uppper()  # Should be .upper()

# ❌ Using list methods on strings
text = "Hello"
text.append("World")  # Strings don't have .append()
```

**How to fix:**
```python
# ✅ Use methods on correct data types
name = "John"
name_upper = name.upper()  # Strings have .upper()

# ✅ Check method spelling
name = "John"
name_upper = name.upper()  # Correct spelling

# ✅ Use appropriate methods for data type
text = "Hello"
new_text = text + " World"  # Use + for strings

my_list = ["Hello"]
my_list.append("World")     # Use .append() for lists
```

---

### 8. UnboundLocalError - "Variable Referenced Before Assignment"

**What it looks like:**
```
UnboundLocalError: local variable 'total' referenced before assignment
```

**Common causes:**
```python
# ❌ Using variable before defining it inside a function
def calculate_order():
    if condition:
        total = 1000
    print(total)  # total might not be defined

# ❌ Trying to modify global variable
total = 0
def add_sale(amount):
    total = total + amount  # Error: total referenced before assignment
```

**How to fix:**
```python
# ✅ Initialize variable before use
def calculate_order():
    total = 0  # Initialize first
    if condition:
        total = 1000
    print(total)

# ✅ Use different variable name or global keyword
total = 0
def add_sale(amount):
    new_total = total + amount  # Use different name
    return new_total
```

---

### 9. ValueError - "Inappropriate Value"

**What it looks like:**
```
ValueError: invalid literal for int() with base 10: 'abc'
```

**Common causes:**
```python
# ❌ Converting non-numeric text to number
price = int("abc")  # Can't convert "abc" to number

# ❌ Converting empty string
age = int("")  # Empty string can't be a number

# ❌ Converting text with spaces/symbols
amount = int("1,000")  # Comma makes it non-numeric
```

**How to fix:**
```python
# ✅ Convert valid numeric strings
price = int("1000")     # "1000" can become 1000
price = float("10.50")  # "10.50" can become 10.5

# ✅ Handle invalid conversions
user_input = "abc"
try:
    price = int(user_input)
except ValueError:
    print("Please enter a valid number")
    price = 0

# ✅ Clean data before converting
amount_text = "1,000"
amount_clean = amount_text.replace(",", "")  # Remove comma
amount = int(amount_clean)  # Now it works
```

**Business example:**
```python
# ❌ This will cause ValueError
user_input = "1,250,000"  # User typed with commas
revenue = int(user_input)  # Error!

# ✅ Fixed version
user_input = "1,250,000"
clean_input = user_input.replace(",", "")  # Remove commas
revenue = int(clean_input)  # Now it works: 1250000
```

---

### 10. ImportError/ModuleNotFoundError - "Library Not Found"

**What it looks like:**
```
ModuleNotFoundError: No module named 'pandas'
```

**Common causes:**
```python
# ❌ Trying to use library that's not installed
import pandas as pd  # If pandas isn't installed

# ❌ Typo in library name
import pandaas as pd  # Should be "pandas"

# ❌ Wrong import statement
from pandas import *
import pandas as pd  # Conflicting imports
```

**How to fix:**
```python
# ✅ Install library first (in terminal/command prompt)
# pip install pandas

# ✅ Correct spelling
import pandas as pd

# ✅ Standard import pattern
import pandas as pd
import numpy as np
```

---

## Debugging Strategies

### 1. Read the Error Message Carefully
- **Location**: Which line caused the error?
- **Type**: What kind of error is it?
- **Message**: What specifically went wrong?

### 2. Common Debugging Steps
```python
# Add print statements to check values
customer_name = "John"
print(f"Customer name is: {customer_name}")  # Check if variable exists
print(f"Type of customer_name: {type(customer_name)}")  # Check data type

# Check list/dictionary contents
products = ["iPhone", "Samsung"]
print(f"Products list: {products}")
print(f"Number of products: {len(products)}")
```

### 3. Use Python's Built-in Help
```python
# Check what methods are available
help(str)          # Help for strings
dir("hello")       # Methods available for strings
type(my_variable)  # Check data type
```

---

## Quick Error Fixes Checklist

When you get an error:

### ✅ Check These Common Issues:
1. **Spelling**: Variable names, function names, method names
2. **Capitalization**: Python is case-sensitive
3. **Quotes**: Text needs quotes, variables don't
4. **Colons**: Add `:` after if statements, for loops, function definitions
5. **Indentation**: 4 spaces after colons
6. **Parentheses**: Functions need `()`, variables don't
7. **Data Types**: Can't mix text and numbers without conversion
8. **List Length**: Check if list has enough items before accessing
9. **Dictionary Keys**: Check if key exists before accessing

### 🔧 Quick Fixes:
- **NameError** → Check variable spelling and creation
- **SyntaxError** → Check quotes, colons, indentation
- **TypeError** → Use `str()` to convert numbers to text
- **KeyError** → Use `.get()` method for dictionaries
- **IndexError** → Check list length with `len()`

---

## Practice: Fix These Errors

### Error 1
```python
# This code has errors - can you spot them?
customer name = "John Doe"
if customer_name == "John Doe"
    print("Welcome" + customer_name)
```

### Error 2
```python
# What's wrong here?
products = ["iPhone", "Samsung"]
print(products[2])
price = products.get("iPhone", 0)
```

### Answers
```python
# Fix 1:
customer_name = "John Doe"  # Use underscore, not space
if customer_name == "John Doe":  # Add colon
    print("Welcome " + customer_name)  # Add space, fix indentation

# Fix 2:
products = ["iPhone", "Samsung"]
print(products[1])  # Index 2 doesn't exist, use 1 for "Samsung"
# Can't use .get() on lists, only dictionaries
# If you want a price lookup, use a dictionary:
prices = {"iPhone": 1250000, "Samsung": 980000}
price = prices.get("iPhone", 0)
```

---

**Remember: Errors are learning opportunities! Every programmer gets errors - the key is learning to read and fix them systematically.**