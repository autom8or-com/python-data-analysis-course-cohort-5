# Enhanced Week 1 Practice Exercises
**Programming Fundamentals + Data Exploration with Olist Dataset**

## Overview
These exercises combine programming fundamentals (variables, lists, data types) with practical data analysis using the Olist Brazilian e-commerce dataset.

## Prerequisites
- [ ] Completed Week 0: Programming Foundations
- [ ] Read Programming Fundamentals Workbook
- [ ] Access to Google Colab (Python) and Supabase (SQL)

---

## Part A: Programming Fundamentals Review (Warm-Up)

### Exercise A1: Variables and Data Types
**Excel Connection**: Named cells and different data formats

```python
# Create variables for Olist business metrics
# Fill in realistic values based on what you learned about Olist

company_name = "____"           # String (text)
founding_year = ____            # Integer (whole number)
commission_rate = ____          # Float (decimal)
is_marketplace = ____           # Boolean (True/False)
top_states = ["____", "____", "____"]  # List of strings

# Print a business summary
print(f"Company: {company_name}")
print(f"Founded: {founding_year}")
print(f"Commission Rate: {commission_rate*100}%")
print(f"Is Marketplace: {is_marketplace}")
print(f"Top States: {', '.join(top_states)}")
```

**Your Tasks**:
1. Fill in the blanks with appropriate values
2. Add a variable for `current_year` and calculate company age
3. Create a list called `order_statuses` with possible order states

### Exercise A2: Lists and Basic Operations
**Excel Connection**: Working with column ranges

```python
# Sample order data (like Excel columns)
order_ids = ["001", "002", "003", "004", "005"]
order_values = [150.50, 89.90, 234.75, 67.25, 445.00]
customer_states = ["SP", "RJ", "MG", "SP", "RS"]

# Your tasks:
# 1. Print the first order ID and its value
first_order = ____
first_value = ____
print(f"First order: {first_order} = ${first_value}")

# 2. Count how many orders we have
total_orders = ____
print(f"Total orders: {total_orders}")

# 3. Find the highest order value (hint: use max() function)
highest_value = ____
print(f"Highest order: ${highest_value}")

# 4. Create a new list with order IDs from SP state only
sp_orders = []  # We'll fill this in together
```

### Exercise A3: Dictionaries (Key-Value Pairs)
**Excel Connection**: Lookup tables and VLOOKUP

```python
# Create a customer profile (like a mini-database record)
customer_profile = {
    "customer_id": "cust_001",
    "name": "Maria Silva", 
    "state": "SP",
    "city": "São Paulo",
    "total_orders": 5,
    "is_vip": True,
    "avg_order_value": 187.50
}

# Your tasks:
# 1. Print the customer's name and state
print(f"Customer: ____ from ____")

# 2. Check if the customer is VIP
if customer_profile["____"]:
    print("This is a VIP customer!")
else:
    print("Regular customer")

# 3. Calculate total spent (total_orders × avg_order_value)
total_spent = ____
print(f"Total spent: ${total_spent}")

# 4. Create another customer profile with different values
customer_2 = {
    # Fill this in with your own values
}
```

---

## Part B: SQL Database Fundamentals

### Exercise B1: Understanding Database Structure
**Excel Connection**: Multiple related worksheets

```sql
-- Task 1: Explore the database structure
-- This is like looking at all worksheets in an Excel workbook
SELECT table_name, table_schema 
FROM information_schema.tables 
WHERE table_schema = 'olist_sales_data_set'
ORDER BY table_name;
```

```sql
-- Task 2: Understand the orders table structure
-- This is like looking at column headers in Excel
SELECT 
    column_name as "Column Name",
    data_type as "Data Type",
    is_nullable as "Can be Empty"
FROM information_schema.columns 
WHERE table_name = 'orders' 
AND table_schema = 'olist_sales_data_set'
ORDER BY ordinal_position;
```

**Your Tasks**:
1. Run both queries and write down the table names you see
2. Identify which columns in the orders table are similar to what you'd track in Excel
3. Which column do you think is the "primary key" (unique identifier)?

### Exercise B2: Basic SQL Data Types and Variables
**Excel Connection**: Named cells and data validation

```sql
-- Task 1: Create temporary variables (like Excel named cells)
WITH business_constants AS (
    SELECT 
        'Olist' as company_name,
        2015 as founding_year,
        0.05 as commission_rate,
        EXTRACT(YEAR FROM CURRENT_DATE) as current_year
)
SELECT 
    company_name,
    founding_year,
    current_year - founding_year as company_age,
    commission_rate * 100 as commission_percent
FROM business_constants;
```

```sql
-- Task 2: Data type exploration
-- See what kinds of data are in each column
SELECT 
    order_id,                    -- VARCHAR (text)
    order_status,                -- VARCHAR (text) 
    order_purchase_timestamp,    -- TIMESTAMP (date and time)
    EXTRACT(YEAR FROM order_purchase_timestamp) as order_year  -- INTEGER (number)
FROM olist_sales_data_set.olist_orders_dataset
LIMIT 10;
```

**Your Tasks**:
1. Modify the first query to calculate how many years Olist has been operating
2. In the second query, add a column that shows the month of each order
3. Can you identify different data types in the results?

---

## Part C: Integrated Python + SQL Practice

### Exercise C1: Same Business Question, Two Tools
**Business Scenario**: The CEO wants to know basic order statistics for a board meeting.

#### Python Approach:
```python
import pandas as pd

# Load the data
orders_url = "https://raw.githubusercontent.com/olist/work-at-olist-data/master/datasets/olist_orders_dataset.csv"
orders = pd.read_csv(orders_url)

# Create variables for key metrics
total_orders = len(orders)
unique_customers = orders['customer_id'].nunique()
date_range_start = orders['order_purchase_timestamp'].min()
date_range_end = orders['order_purchase_timestamp'].max()

# Create a summary dictionary
ceo_summary = {
    "total_orders": total_orders,
    "unique_customers": unique_customers,
    "date_range": f"{date_range_start} to {date_range_end}",
    "avg_orders_per_customer": round(total_orders / unique_customers, 2)
}

# Your task: Print a formatted report for the CEO
print("=== CEO BOARD REPORT ===")
for metric, value in ceo_summary.items():
    print(f"{metric.replace('_', ' ').title()}: {value}")
```

#### SQL Approach:
```sql
-- Create the same CEO report using SQL
WITH ceo_metrics AS (
    SELECT 
        COUNT(*) as total_orders,
        COUNT(DISTINCT customer_id) as unique_customers,
        MIN(order_purchase_timestamp) as date_range_start,
        MAX(order_purchase_timestamp) as date_range_end
    FROM olist_sales_data_set.olist_orders_dataset
)
SELECT 
    total_orders,
    unique_customers,
    CONCAT(date_range_start, ' to ', date_range_end) as date_range,
    ROUND(total_orders::DECIMAL / unique_customers, 2) as avg_orders_per_customer
FROM ceo_metrics;
```

**Your Tasks**:
1. Run both versions and compare the results
2. Which approach felt more familiar? Why?
3. Add one more metric to both versions: count of delivered orders

### Exercise C2: Data Type Challenges
**Real Business Problem**: The operations team needs to categorize orders by value ranges.

#### Python Version:
```python
# Load order items data (contains price information)
items_url = "https://raw.githubusercontent.com/olist/work-at-olist-data/master/datasets/olist_order_items_dataset.csv"
order_items = pd.read_csv(items_url)

# Create price categories using conditions (like Excel IF statements)
def categorize_order(price):
    if price >= 200:
        return "High Value"
    elif price >= 50:
        return "Medium Value"
    else:
        return "Low Value"

# Apply the function to create categories
order_items['price_category'] = order_items['price'].apply(categorize_order)

# Count orders in each category
category_counts = order_items['price_category'].value_counts()
print("Order Categories:")
print(category_counts)

# Your task: Calculate the percentage of each category
total_items = len(order_items)
for category, count in category_counts.items():
    percentage = (count / total_items) * 100
    print(f"{category}: {count:,} orders ({percentage:.1f}%)")
```

#### SQL Version:
```sql
-- Same categorization using SQL CASE statements
WITH categorized_orders AS (
    SELECT 
        order_id,
        price,
        CASE 
            WHEN price >= 200 THEN 'High Value'
            WHEN price >= 50 THEN 'Medium Value'
            ELSE 'Low Value'
        END as price_category
    FROM olist_sales_data_set.olist_order_items_dataset
)
SELECT 
    price_category,
    COUNT(*) as order_count,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 1) as percentage
FROM categorized_orders
GROUP BY price_category
ORDER BY order_count DESC;
```

**Your Tasks**:
1. Run both versions and verify they give the same results
2. Modify the price thresholds: High Value = $100+, Medium = $25+, Low = under $25
3. Which syntax felt more natural for conditional logic?

---

## Part D: Programming Concepts Application

### Exercise D1: Functions (Custom Business Logic)
**Excel Connection**: Creating custom formulas

```python
def calculate_shipping_cost(price, customer_state):
    """
    Calculate shipping cost based on order value and location
    Like creating a custom Excel formula
    """
    # Base shipping rates by region
    shipping_rates = {
        "SP": 10.00,    # São Paulo - cheapest (company location)
        "RJ": 15.00,    # Rio de Janeiro  
        "MG": 12.00,    # Minas Gerais
        "RS": 20.00,    # Rio Grande do Sul - most expensive
        "Other": 18.00  # Default for other states
    }
    
    # Get base rate (with default for unknown states)
    base_rate = shipping_rates.get(customer_state, shipping_rates["Other"])
    
    # Free shipping over $100 (like Excel IF statement)
    if price >= 100:
        return 0.00
    else:
        return base_rate

# Test the function with sample data
test_orders = [
    {"price": 150, "state": "SP"},
    {"price": 75, "state": "RJ"}, 
    {"price": 45, "state": "RS"},
    {"price": 120, "state": "MG"}
]

# Your task: Calculate shipping for each test order
print("Shipping Cost Calculator:")
for order in test_orders:
    shipping = calculate_shipping_cost(order["price"], order["state"])
    print(f"${order['price']} order to {order['state']}: ${shipping} shipping")

# Bonus: Calculate total cost (price + shipping) for each order
```

### Exercise D2: Loops and Data Processing
**Excel Connection**: Applying formulas to entire columns

```python
# Sample customer data
customers = [
    {"name": "Ana Santos", "state": "SP", "orders": 3, "total_spent": 450},
    {"name": "Carlos Silva", "state": "RJ", "orders": 1, "total_spent": 89},
    {"name": "Maria Costa", "state": "MG", "orders": 7, "total_spent": 1250},
    {"name": "João Ferreira", "state": "RS", "orders": 2, "total_spent": 234}
]

# Your task: Process each customer to determine VIP status
print("Customer VIP Status Report:")
print("-" * 50)

for customer in customers:
    # Calculate average order value
    avg_order = customer["total_spent"] / customer["orders"]
    
    # Determine VIP status (like Excel nested IF)
    if customer["total_spent"] >= 1000:
        vip_status = "Platinum VIP"
        discount = 0.15
    elif customer["total_spent"] >= 500 or customer["orders"] >= 5:
        vip_status = "Gold VIP"  
        discount = 0.10
    elif avg_order >= 100:
        vip_status = "Silver VIP"
        discount = 0.05
    else:
        vip_status = "Regular"
        discount = 0.00
    
    # Print formatted report
    print(f"Name: {customer['name']}")
    print(f"Location: {customer['state']}")
    print(f"Orders: {customer['orders']}, Total: ${customer['total_spent']}")
    print(f"Avg Order: ${avg_order:.2f}")
    print(f"Status: {vip_status} ({discount*100}% discount)")
    print("-" * 30)

# Bonus: Count how many customers are in each VIP tier
```

---

## Self-Assessment Checklist

After completing all exercises, you should be able to:

### Python Fundamentals:
- [ ] Create and use variables of different data types
- [ ] Work with lists (create, access, modify)
- [ ] Use dictionaries for key-value data storage
- [ ] Write simple functions with parameters and return values
- [ ] Use if/else statements for conditional logic
- [ ] Write for loops to process multiple items
- [ ] Load data using pandas and perform basic operations

### SQL Fundamentals:
- [ ] Understand database terminology (table, row, column, schema)
- [ ] Write basic SELECT statements with specific columns
- [ ] Use WHERE clauses to filter data
- [ ] Understand different SQL data types
- [ ] Use CASE statements for conditional logic
- [ ] Create temporary variables using WITH clauses
- [ ] Perform basic aggregations (COUNT, SUM, AVG)

### Integration Skills:
- [ ] Solve the same business problem using both Python and SQL
- [ ] Connect programming concepts to Excel equivalents
- [ ] Explain when to use Python vs SQL for different tasks
- [ ] Read and debug simple error messages in both languages

---

## Reflection Questions

1. **Programming Foundations**: Which Python data structure (variables, lists, dictionaries) felt most similar to Excel? Why?

2. **SQL vs Excel**: How did writing SQL queries compare to creating Excel formulas? What felt familiar or different?

3. **Tool Choice**: For the business scenarios in these exercises, when would you prefer Python vs SQL vs Excel? 

4. **Confidence Level**: On a scale of 1-10, how confident do you feel about:
   - Writing basic Python variables and lists?
   - Writing basic SQL SELECT statements?
   - Connecting programming concepts to business problems?

5. **Next Steps**: What programming concept from this week would you like to practice more?

---

## Answer Key & Solutions
*Available separately for instructors - includes detailed solutions and common error explanations*

---

*Remember: The goal is understanding concepts, not memorizing syntax. Focus on the logic and connections to Excel - the syntax will come with practice!*