# Excel to Python Translation Dictionary
**Your Complete Concept Bridge**

---

## Data Storage and Organization

| Excel Concept | Excel Example | Python Equivalent | Python Example |
|---------------|---------------|-------------------|----------------|
| **Named Cell** | `SalesTotal = 1500` | Variable | `sales_total = 1500` |
| **Cell Reference** | `=A1` | Variable access | `customer_name` |
| **Column Range** | `A1:A10` | List | `customers = ["John", "Mary", "Paul"]` |
| **Row of Data** | Row 2: `John, Lagos, 25, 50000` | Dictionary | `{"name": "John", "city": "Lagos", "age": 25}` |
| **Worksheet** | Sheet with rows/columns | DataFrame | `df = pd.DataFrame(data)` |
| **Workbook** | Multiple sheets | Multiple DataFrames | `orders_df, customers_df, products_df` |

---

## Data Types and Formats

| Excel Format | Excel Example | Python Type | Python Example |
|--------------|---------------|-------------|----------------|
| **Text** | `"John Doe"` | String (str) | `name = "John Doe"` |
| **Number** | `1500` | Integer (int) | `quantity = 1500` |
| **Currency** | `₦1,250.50` | Float | `price = 1250.50` |
| **Percentage** | `15%` | Float | `discount = 0.15` |
| **Date** | `15-Jan-2024` | String/DateTime | `date = "2024-01-15"` |
| **Yes/No** | `TRUE/FALSE` | Boolean | `is_vip = True` |

---

## Basic Operations and Calculations

| Excel Operation | Excel Formula | Python Operation | Python Code |
|----------------|---------------|------------------|-------------|
| **Addition** | `=A1+B1` | Addition | `total = price + tax` |
| **Subtraction** | `=A1-B1` | Subtraction | `profit = revenue - cost` |
| **Multiplication** | `=A1*B1` | Multiplication | `total = price * quantity` |
| **Division** | `=A1/B1` | Division | `average = total / count` |
| **Percentage** | `=A1*15%` | Percentage | `tax = amount * 0.15` |
| **Absolute Value** | `=ABS(A1)` | Absolute | `abs(difference)` |
| **Round** | `=ROUND(A1,2)` | Round | `round(value, 2)` |

---

## Text Operations

| Excel Function | Excel Example | Python Method | Python Example |
|----------------|---------------|---------------|----------------|
| **CONCATENATE** | `=A1&" "&B1` | String join | `full_name = first + " " + last` |
| **CONCATENATE** | `=A1&B1` | F-string | `f"{first_name} {last_name}"` |
| **UPPER** | `=UPPER(A1)` | .upper() | `name.upper()` |
| **LOWER** | `=LOWER(A1)` | .lower() | `name.lower()` |
| **LEN** | `=LEN(A1)` | len() | `len(text)` |
| **LEFT** | `=LEFT(A1,5)` | Slice | `text[:5]` |
| **RIGHT** | `=RIGHT(A1,3)` | Slice | `text[-3:]` |
| **MID** | `=MID(A1,2,5)` | Slice | `text[1:6]` |
| **FIND** | `=FIND("@",A1)` | .find() | `email.find("@")` |
| **SUBSTITUTE** | `=SUBSTITUTE(A1,"old","new")` | .replace() | `text.replace("old", "new")` |

---

## Logical Operations

| Excel Logic | Excel Example | Python Logic | Python Example |
|-------------|---------------|--------------|----------------|
| **IF** | `=IF(A1>100,"High","Low")` | if statement | `"High" if value > 100 else "Low"` |
| **IF-ELSEIF** | `=IF(A1>100,"High",IF(A1>50,"Med","Low"))` | if-elif-else | `if val > 100: "High" elif val > 50: "Med" else: "Low"` |
| **AND** | `=AND(A1>50, B1="Yes")` | and operator | `value > 50 and status == "Yes"` |
| **OR** | `=OR(A1>100, B1="VIP")` | or operator | `value > 100 or customer == "VIP"` |
| **NOT** | `=NOT(A1="")` | not operator | `not is_empty` |

---

## Mathematical Functions

| Excel Function | Excel Example | Python Function | Python Example |
|----------------|---------------|-----------------|----------------|
| **SUM** | `=SUM(A1:A10)` | sum() | `sum(sales_list)` |
| **AVERAGE** | `=AVERAGE(A1:A10)` | mean() | `statistics.mean(values)` or `sum()/len()` |
| **COUNT** | `=COUNT(A1:A10)` | len() | `len(numbers_list)` |
| **COUNTA** | `=COUNTA(A1:A10)` | len() | `len([x for x in list if x])` |
| **MAX** | `=MAX(A1:A10)` | max() | `max(values_list)` |
| **MIN** | `=MIN(A1:A10)` | min() | `min(values_list)` |
| **MEDIAN** | `=MEDIAN(A1:A10)` | median() | `statistics.median(values)` |
| **STDEV** | `=STDEV(A1:A10)` | stdev() | `statistics.stdev(values)` |

---

## Lookup and Reference Functions

| Excel Function | Excel Example | Python Equivalent | Python Example |
|----------------|---------------|-------------------|----------------|
| **VLOOKUP** | `=VLOOKUP("iPhone",A:B,2,0)` | Dictionary lookup | `prices["iPhone"]` |
| **HLOOKUP** | `=HLOOKUP("Q1",1:2,2,0)` | Dictionary lookup | `quarters["Q1"]` |
| **INDEX** | `=INDEX(A1:A10,5)` | List indexing | `customer_list[4]` (0-based) |
| **MATCH** | `=MATCH("John",A1:A10,0)` | .index() | `names.index("John")` |
| **LOOKUP** | `=LOOKUP(A1,B:C)` | Dictionary get | `lookup_dict.get(key, default)` |

---

## Data Analysis Functions

| Excel Feature | Excel Example | Pandas Equivalent | Python Example |
|---------------|---------------|-------------------|----------------|
| **AutoFilter** | Filter dropdown | Boolean indexing | `df[df['city'] == 'Lagos']` |
| **Sort** | Data > Sort | .sort_values() | `df.sort_values('sales', ascending=False)` |
| **Subtotal** | `=SUBTOTAL(9,A2:A10)` | .groupby() | `df.groupby('category')['sales'].sum()` |
| **Pivot Table** | Insert > PivotTable | .pivot_table() | `df.pivot_table(values='sales', index='city')` |
| **Conditional Format** | Format > Conditional | Boolean conditions | `df[df['sales'] > 1000000]` |

---

## File Operations

| Excel Action | Excel Method | Python Method | Python Example |
|--------------|--------------|---------------|----------------|
| **Open File** | File > Open | pd.read_csv() | `df = pd.read_csv('data.csv')` |
| **Save File** | File > Save As | .to_csv() | `df.to_csv('output.csv')` |
| **New Worksheet** | Right-click tab | New DataFrame | `new_df = pd.DataFrame()` |
| **Copy Sheet** | Right-click > Copy | .copy() | `df2 = df1.copy()` |

---

## Data Viewing and Navigation

| Excel Action | Excel Shortcut | Pandas Method | Python Example |
|--------------|----------------|---------------|----------------|
| **Go to top** | Ctrl+Home | .head() | `df.head()` |
| **Go to bottom** | Ctrl+End | .tail() | `df.tail()` |
| **View all data** | Scroll | Print DataFrame | `print(df)` |
| **Column headers** | Row 1 | .columns | `df.columns` |
| **Row count** | Status bar | len() or .shape | `len(df)` or `df.shape[0]` |
| **Column count** | Status bar | .shape | `df.shape[1]` |

---

## Error Handling

| Excel Error | Excel Meaning | Python Error | Python Solution |
|-------------|---------------|--------------|-----------------|
| **#NAME?** | Unknown function/name | NameError | Check variable spelling |
| **#VALUE!** | Wrong data type | TypeError | Convert data types |
| **#REF!** | Invalid reference | IndexError | Check list/dict indices |
| **#N/A** | Not available | KeyError | Use .get() for dictionaries |
| **#DIV/0!** | Division by zero | ZeroDivisionError | Check for zero before dividing |

---

## Common Excel Workflows → Python Equivalents

### 1. Data Entry and Validation
**Excel Workflow:**
1. Type data in cells
2. Use data validation
3. Format cells

**Python Equivalent:**
```python
# Create data
customer_data = {
    'name': 'John Doe',
    'age': 30,
    'city': 'Lagos'
}

# Validation
if customer_data['age'] > 0:
    print("Valid age")

# Display formatting
print(f"Customer: {customer_data['name']}")
```

### 2. Data Analysis Workflow
**Excel Workflow:**
1. Open file
2. Filter data
3. Create pivot table
4. Calculate summary statistics

**Python Equivalent:**
```python
# 1. Load data
df = pd.read_csv('customers.csv')

# 2. Filter data
lagos_customers = df[df['city'] == 'Lagos']

# 3. Group analysis (pivot table equivalent)
city_summary = df.groupby('city')['sales'].agg(['sum', 'mean', 'count'])

# 4. Summary statistics
print(df.describe())
```

### 3. Report Generation
**Excel Workflow:**
1. Create formulas
2. Format cells
3. Create charts
4. Print/save report

**Python Equivalent:**
```python
# 1. Calculations
total_sales = df['sales'].sum()
avg_sales = df['sales'].mean()

# 2. Format output
report = f"""
Sales Report
============
Total Sales: ₦{total_sales:,}
Average Sale: ₦{avg_sales:,.2f}
"""

# 3. Save report
with open('sales_report.txt', 'w') as f:
    f.write(report)
```

---

## Practice Translation Exercises

### Exercise 1: Convert This Excel Formula
**Excel:** `=IF(AND(B2>1000000, C2="VIP"), B2*0.1, B2*0.05)`

**Python Answer:**
```python
discount = order_value * 0.1 if order_value > 1000000 and status == "VIP" else order_value * 0.05
```

### Exercise 2: Convert This Excel Workflow
**Excel Steps:**
1. Open customer data
2. Filter for Lagos customers
3. Calculate average order value
4. Count number of customers

**Python Answer:**
```python
df = pd.read_csv('customers.csv')
lagos_df = df[df['city'] == 'Lagos']
avg_order = lagos_df['order_value'].mean()
customer_count = len(lagos_df)
print(f"Lagos: {customer_count} customers, avg ₦{avg_order:,.2f}")
```

---

## Memory Aids

### Remember These Key Translations:
- **Excel Cell** = Python Variable
- **Excel Column** = Python List
- **Excel Row** = Python Dictionary
- **Excel Sheet** = Python DataFrame
- **Excel Formula** = Python Expression
- **Excel Function** = Python Method
- **Excel Workflow** = Python Script

### When You Get Stuck:
1. **Ask yourself:** "What would I do in Excel?"
2. **Find the equivalent:** Use this dictionary
3. **Test it:** Try the Python version
4. **Iterate:** Adjust until it works

---

**Remember: You already know the logic! Python is just a different way to express the same data analysis concepts you use in Excel every day.**