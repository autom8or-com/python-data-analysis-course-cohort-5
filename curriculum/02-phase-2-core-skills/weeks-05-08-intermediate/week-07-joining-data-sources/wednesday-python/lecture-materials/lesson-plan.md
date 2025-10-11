# Week 7: Joining Data Sources - Python Lesson Plan

## Course Information
- **Program**: PORA Academy Cohort 5 - Data Analytics & AI Bootcamp
- **Phase**: 2 - Core Skills Development
- **Week**: 7 (September 24-25, 2025)
- **Day**: Wednesday - Python Session
- **Duration**: 2 hours
- **Topic**: Pandas Merging & Joining

## Excel Bridge Concept
**Excel Equivalent**: VLOOKUP, INDEX-MATCH, and Power Query merge operations

In Excel, you use VLOOKUP to bring data from one table into another. In pandas, we use `merge()` and `join()` functions to combine DataFrames. The concepts are identical to SQL JOINs you'll learn tomorrow - same business logic, different syntax!

## Business Scenario
**Customer Journey Analysis**: Connecting orders, products, customers, and reviews to understand the complete e-commerce experience in the Olist marketplace.

Just like in SQL, you need to combine multiple DataFrames to answer complex business questions:
- Which products do customers from São Paulo prefer?
- What's the average review score by product category?
- How do seller locations affect customer satisfaction?

## Learning Objectives
By the end of this session, students will be able to:
1. Understand why data is split across multiple files (normalization concept)
2. Use `pd.merge()` to combine DataFrames with different join types
3. Apply inner, left, right, and outer merges appropriately
4. Handle duplicate keys and missing matches in merged data
5. Chain multiple merge operations for complex analysis
6. Understand the relationship between pandas merge and SQL JOINs
7. Validate merge results and diagnose common merge issues

## Dataset Overview

### Olist E-commerce Data Files

```
customers.csv
├── customer_id (primary key)
├── customer_unique_id
├── customer_city
└── customer_state

orders.csv
├── order_id (primary key)
├── customer_id (foreign key → customers)
├── order_status
└── order_purchase_timestamp

order_items.csv
├── order_id (foreign key → orders)
├── order_item_id
├── product_id (foreign key → products)
├── seller_id (foreign key → sellers)
├── price
└── freight_value

products.csv
├── product_id (primary key)
├── product_category_name
└── product_weight_g

sellers.csv
├── seller_id (primary key)
├── seller_city
└── seller_state

order_reviews.csv
├── review_id (primary key)
├── order_id (foreign key → orders)
├── review_score
└── review_creation_date

order_payments.csv
├── order_id (foreign key → orders)
├── payment_type
├── payment_installments
└── payment_value
```

## Lesson Structure (120 minutes)

### Part 1: Understanding Relational Data (15 minutes)

#### Why Data is Split Across Files
**Concept**: Instead of one massive Excel file with duplicate information, we split related data into multiple files.

**Benefits**:
- **No Redundancy**: Customer address appears once, not in every order row
- **Easy Updates**: Change customer info in one place
- **Better Performance**: Smaller files load faster

**Real-World Analogy**: Your phone contacts app doesn't save complete contact info in every message. Messages reference contacts by ID, keeping data separate but connected.

#### Loading the Datasets

```python
import pandas as pd
import numpy as np

# Load all datasets
customers = pd.read_csv('datasets/customers.csv')
orders = pd.read_csv('datasets/orders.csv')
order_items = pd.read_csv('datasets/order_items.csv')
products = pd.read_csv('datasets/products.csv')
sellers = pd.read_csv('datasets/sellers.csv')
reviews = pd.read_csv('datasets/order_reviews.csv')
payments = pd.read_csv('datasets/order_payments.csv')

# Convert date columns
orders['order_purchase_timestamp'] = pd.to_datetime(orders['order_purchase_timestamp'])
orders['order_delivered_customer_date'] = pd.to_datetime(orders['order_delivered_customer_date'])
reviews['review_creation_date'] = pd.to_datetime(reviews['review_creation_date'])

# Explore structure
print("Customers shape:", customers.shape)
print("Orders shape:", orders.shape)
print("\nCustomers columns:", customers.columns.tolist())
print("Orders columns:", orders.columns.tolist())
```

#### Understanding Keys
- **Primary Key**: Unique identifier for each row (like `customer_id`)
- **Foreign Key**: Column that references a primary key in another DataFrame
- **Join Column**: The column used to connect DataFrames

### Part 2: Inner Merge - The Foundation (25 minutes)

#### Concept Explanation
**Inner Merge**: Returns only rows where keys exist in BOTH DataFrames.

**Excel Analogy**: Like VLOOKUP, but only keeps rows where a match is found. No match? Row is excluded.

**Visual Representation**:
```
DataFrame A    DataFrame B     Inner Merge
-----------    -----------     -----------
  ┌─────┐        ┌─────┐         ┌─────┐
  │ A   │   +    │ B   │    =    │ A∩B │  (overlap only)
  └─────┘        └─────┘         └─────┘
```

#### Basic Syntax

```python
# Basic merge syntax
merged_df = pd.merge(
    left_df,
    right_df,
    on='key_column',      # Column to join on
    how='inner'           # Join type
)
```

#### Practical Example 1: Orders with Customer Information

**Business Question**: "Show me orders with customer city and state information"

```python
# Inner merge: Orders with customer details
orders_customers = pd.merge(
    orders,
    customers,
    on='customer_id',
    how='inner'
)

# Select relevant columns
result = orders_customers[[
    'order_id',
    'order_purchase_timestamp',
    'order_status',
    'customer_city',
    'customer_state'
]].head(20)

print(result)
```

**Key Teaching Points**:
- `on='customer_id'` specifies the join column
- Only orders with matching customers appear (inner merge behavior)
- Columns from both DataFrames are available

#### Practical Example 2: Three-DataFrame Merge

**Business Question**: "What products were purchased in each order?"

```python
# Step 1: Merge orders with order_items
orders_items = pd.merge(
    orders,
    order_items,
    on='order_id',
    how='inner'
)

# Step 2: Merge result with products
orders_items_products = pd.merge(
    orders_items,
    products,
    on='product_id',
    how='inner'
)

# Filter and display
delivered_orders = orders_items_products[
    orders_items_products['order_status'] == 'delivered'
]

result = delivered_orders[[
    'order_id',
    'order_purchase_timestamp',
    'product_category_name',
    'price',
    'freight_value'
]].head(20)

print(result)
```

**Key Teaching Points**:
- Merges can be chained together
- Each merge uses the result of the previous merge
- Filter after merging, not before (usually)

#### Method Chaining Approach

```python
# Same result using method chaining
result = (orders
    .merge(order_items, on='order_id', how='inner')
    .merge(products, on='product_id', how='inner')
    .query('order_status == "delivered"')
    [['order_id', 'order_purchase_timestamp', 'product_category_name', 'price', 'freight_value']]
    .head(20)
)

print(result)
```

### Part 3: Left Merge - Keeping All Records (25 minutes)

#### Concept Explanation
**Left Merge**: Returns ALL rows from the left DataFrame and matching rows from the right. If no match, right columns are NaN.

**Excel Analogy**: Like VLOOKUP with IFERROR - you keep all original rows, showing blanks (NaN) when no match found.

**Visual Representation**:
```
DataFrame A    DataFrame B     Left Merge
-----------    -----------     ----------
  ┌─────┐        ┌─────┐       ┌─────┐
  │  A  │   +    │ B   │   =   │ All │  (all of A)
  └─────┘        └─────┘       │  A  │
                               └─────┘
```

#### When to Use Left Merge
Use left merge when you want:
- All records from the main DataFrame regardless of matches
- To identify records WITHOUT matches (using `.isna()`)
- To preserve your primary dataset while adding supplementary info

#### Practical Example 1: All Orders with Optional Reviews

**Business Question**: "Show all orders, including those without reviews"

```python
# Left merge: All orders with review data (if available)
orders_reviews = pd.merge(
    orders,
    reviews,
    on='order_id',
    how='left'
)

# Filter for delivered orders
delivered = orders_reviews[orders_reviews['order_status'] == 'delivered']

# Add review status column
delivered['review_status'] = delivered['review_id'].apply(
    lambda x: 'Has Review' if pd.notna(x) else 'No Review'
)

result = delivered[[
    'order_id',
    'order_status',
    'order_purchase_timestamp',
    'review_score',
    'review_creation_date',
    'review_status'
]].head(20)

print(result)
print("\nReview completion rate:")
print(delivered['review_status'].value_counts())
```

**Key Teaching Points**:
- All orders appear (left DataFrame preserved)
- `review_score` is NaN for orders without reviews
- `.isna()` or `.notna()` detect missing values

#### Practical Example 2: Finding Missing Data

**Business Question**: "Which delivered orders have no customer reviews?"

```python
# Left merge to find missing reviews
orders_reviews = pd.merge(
    orders,
    reviews,
    on='order_id',
    how='left'
)

# Filter for delivered orders without reviews
missing_reviews = orders_reviews[
    (orders_reviews['order_status'] == 'delivered') &
    (orders_reviews['review_id'].isna())
]

result = missing_reviews[[
    'order_id',
    'customer_id',
    'order_purchase_timestamp',
    'order_delivered_customer_date'
]].head(20)

print(f"Orders without reviews: {len(missing_reviews)}")
print(result)
```

**Key Teaching Points**:
- Left merge + `.isna()` pattern identifies missing relationships
- Critical for data quality analysis
- Helps identify gaps in business processes

#### Practical Example 3: Data Completeness Analysis

**Business Question**: "What percentage of delivered orders have reviews?"

```python
# Calculate review completion rate
orders_reviews = pd.merge(
    orders.query('order_status == "delivered"'),
    reviews,
    on='order_id',
    how='left'
)

total_orders = len(orders_reviews)
reviewed_orders = orders_reviews['review_id'].notna().sum()
completion_rate = (reviewed_orders / total_orders) * 100

print(f"Total delivered orders: {total_orders}")
print(f"Orders with reviews: {reviewed_orders}")
print(f"Review completion rate: {completion_rate:.2f}%")
```

### Part 4: Right Merge and Outer Merge (15 minutes)

#### Right Merge
**Right Merge**: Opposite of left merge - keeps all rows from RIGHT DataFrame.

**Note**: Less common in practice. You can reverse DataFrames and use left merge instead.

```python
# Right merge example
reviews_orders = pd.merge(
    orders,
    reviews,
    on='order_id',
    how='right'
)

# Same result as:
reviews_orders = pd.merge(
    reviews,
    orders,
    on='order_id',
    how='left'
)
```

#### Outer Merge (Full Outer Join)
**Outer Merge**: Returns ALL rows from BOTH DataFrames, with NaN where no match exists.

**Use Cases**: Data reconciliation, finding all mismatches

```python
# Full outer merge: Find all order/review mismatches
all_data = pd.merge(
    orders,
    reviews,
    on='order_id',
    how='outer',
    indicator=True  # Shows merge source
)

# Find mismatches
mismatches = all_data[all_data['_merge'] != 'both']

print("Merge status breakdown:")
print(all_data['_merge'].value_counts())
print("\nMismatches:")
print(mismatches[['order_id', 'order_status', 'review_id', '_merge']].head())
```

**Key Teaching Points**:
- `indicator=True` adds `_merge` column showing merge source
- Values: 'left_only', 'right_only', 'both'
- Useful for data quality checks

### Part 5: Advanced Merge Scenarios (25 minutes)

#### Scenario 1: Multi-DataFrame Analysis

**Business Question**: "Analyze São Paulo orders: products, payments, and reviews"

```python
# Complex multi-DataFrame merge
sp_analysis = (orders
    .merge(customers, on='customer_id', how='inner')
    .merge(order_items, on='order_id', how='inner')
    .merge(products, on='product_id', how='inner')
    .merge(payments, on='order_id', how='left')
    .merge(reviews, on='order_id', how='left')
    .query('customer_state == "SP" and order_status == "delivered"')
)

result = sp_analysis[[
    'customer_city',
    'order_id',
    'product_category_name',
    'price',
    'payment_type',
    'review_score'
]].head(20)

print(result)
```

#### Scenario 2: Aggregations with Merged Data

**Business Question**: "Average review score by product category"

```python
# Merge and aggregate
category_reviews = (products
    .merge(order_items, on='product_id', how='inner')
    .merge(orders, on='order_id', how='inner')
    .merge(reviews, on='order_id', how='left')
    .query('order_status == "delivered" and product_category_name.notna()')
)

# Group and calculate
summary = category_reviews.groupby('product_category_name').agg({
    'order_id': 'nunique',
    'order_item_id': 'count',
    'review_score': 'mean',
    'price': 'mean'
}).rename(columns={
    'order_id': 'total_orders',
    'order_item_id': 'total_items',
    'review_score': 'avg_review_score',
    'price': 'avg_price'
}).round(2)

# Filter and sort
top_categories = summary[summary['total_orders'] >= 10].sort_values('avg_review_score', ascending=False)

print(top_categories.head(15))
```

#### Scenario 3: Handling Duplicate Keys

**Business Question**: "Orders with multiple items - understanding one-to-many relationships"

```python
# One-to-many merge (one order, many items)
orders_with_items = pd.merge(
    orders,
    order_items,
    on='order_id',
    how='inner'
)

print(f"Original orders: {len(orders)}")
print(f"After merge: {len(orders_with_items)}")
print(f"Duplicates created by one-to-many relationship")

# Count items per order
items_per_order = orders_with_items.groupby('order_id').size().reset_index(name='item_count')
print("\nOrders with multiple items:")
print(items_per_order[items_per_order['item_count'] > 1].head())
```

**Key Teaching Points**:
- One-to-many relationships create duplicate rows
- Be careful with aggregations after merging
- Use `.nunique()` for distinct counts

### Part 6: Merge vs Join Methods (15 minutes)

#### Different Ways to Merge

```python
# Method 1: pd.merge() function (most common)
result1 = pd.merge(orders, customers, on='customer_id', how='inner')

# Method 2: .merge() method
result2 = orders.merge(customers, on='customer_id', how='inner')

# Method 3: .join() method (index-based)
orders_indexed = orders.set_index('customer_id')
customers_indexed = customers.set_index('customer_id')
result3 = orders_indexed.join(customers_indexed, how='inner')

# All produce same result
print("All methods equal:", result1.equals(result2.reset_index(drop=True)))
```

#### When to Use Each Method

| Method | Best For | Notes |
|--------|----------|-------|
| `pd.merge()` | Column-based joins | Most flexible, clearest |
| `.merge()` | Method chaining | Good for pipelines |
| `.join()` | Index-based joins | Faster but requires index setup |

### Part 7: Common Merge Issues and Solutions (10 minutes)

#### Issue 1: Key Column Name Mismatch

```python
# Problem: Different column names for same key
# orders has 'customer_id', but another df has 'cust_id'

# Solution: Use left_on and right_on
result = pd.merge(
    orders,
    other_df,
    left_on='customer_id',
    right_on='cust_id',
    how='inner'
)

# This creates both columns - drop one
result = result.drop('cust_id', axis=1)
```

#### Issue 2: Unexpected Number of Rows

```python
# Before merge: Check for duplicates in key columns
print("Duplicate order_ids in orders:", orders['order_id'].duplicated().sum())
print("Duplicate order_ids in reviews:", reviews['order_id'].duplicated().sum())

# After merge: Validate
merged = pd.merge(orders, order_items, on='order_id', how='inner')
print(f"Orders before merge: {len(orders)}")
print(f"Rows after merge: {len(merged)}")
print(f"Ratio: {len(merged) / len(orders):.2f}x")
```

#### Issue 3: NaN Values After Merge

```python
# Check for NaN values
merged = pd.merge(orders, reviews, on='order_id', how='left')

print("Missing review scores:")
print(merged['review_score'].isna().sum())

# Fill NaN with appropriate values
merged['review_score_filled'] = merged['review_score'].fillna(0)
merged['review_status'] = merged['review_score'].apply(
    lambda x: 'Reviewed' if pd.notna(x) else 'Not Reviewed'
)
```

## Hands-On Practice During Class (15 minutes)

### Exercise 1: Basic Inner Merge
"Merge orders with customers and show orders from 'RJ' state with customer city information."

### Exercise 2: Left Merge for Data Quality
"Find all products that have never been ordered. Use left merge and check for NaN."

### Exercise 3: Multi-DataFrame Analysis
"Calculate total revenue by seller state. Merge orders → order_items → sellers, then group by seller_state."

## Comparison: Pandas Merge vs SQL JOIN

| pandas | SQL | Purpose |
|--------|-----|---------|
| `how='inner'` | INNER JOIN | Only matches |
| `how='left'` | LEFT JOIN | All from left |
| `how='right'` | RIGHT JOIN | All from right |
| `how='outer'` | FULL OUTER JOIN | All from both |
| `on='column'` | ON table1.column = table2.column | Join condition |
| `indicator=True` | (manual check) | Track merge source |

**Tomorrow's SQL class will teach the same concepts with SQL syntax!**

## Recap and Key Takeaways (10 minutes)

### Merge Types Quick Reference
- **Inner**: Only matching rows from both DataFrames
- **Left**: All from left + matching from right (NaN for no match)
- **Right**: All from right + matching from left
- **Outer**: All rows from both DataFrames

### Best Practices
1. **Check key columns before merging** (duplicates, NaN values)
2. **Validate merge results** (row counts, NaN patterns)
3. **Use left merge** when you need to preserve all primary records
4. **Chain merges logically** (start with main DataFrame)
5. **Use `indicator=True`** for debugging merge issues
6. **Handle NaN values appropriately** after merging

### Real-World Applications
- **E-commerce**: Combining orders, products, and customers
- **Marketing**: Joining campaign data with customer behavior
- **Finance**: Merging transactions with account information
- **Healthcare**: Connecting patient records across systems

## Homework Assignment Preview
Students will receive exercises requiring:
1. Multi-DataFrame merges with business logic
2. Finding missing data using left merge + `.isna()`
3. Aggregating across merged DataFrames
4. Data quality analysis with merge validation

## Additional Resources
- Pandas merge documentation
- Visual merge diagrams
- Merge patterns cheat sheet
- Common merge pitfalls guide

---

**Next Session**: Thursday SQL class will cover JOINs - the same concepts you learned today but with SQL syntax and the same Olist database!
