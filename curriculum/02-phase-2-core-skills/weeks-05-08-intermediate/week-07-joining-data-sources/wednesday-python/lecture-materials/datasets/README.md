# Week 7 Python Datasets - Data Export Instructions

## Dataset Overview
This folder contains CSV exports from the Olist e-commerce database for use in Python pandas merge/join exercises. These datasets mirror the SQL tables used in Thursday's SQL class.

## Dataset Files

### Core Tables
1. **customers.csv** - Customer information
2. **orders.csv** - Order details and status
3. **order_items.csv** - Individual items in each order
4. **products.csv** - Product catalog with categories
5. **sellers.csv** - Seller location information
6. **order_reviews.csv** - Customer reviews and ratings
7. **order_payments.csv** - Payment information

## How to Export Data from Supabase

Use the following SQL queries to export data from Supabase to CSV files. Execute these in your SQL editor and save the results as CSV:

### 1. Export Customers (customers.csv)
```sql
COPY (
    SELECT
        customer_id,
        customer_unique_id,
        customer_zip_code_prefix,
        customer_city,
        customer_state
    FROM olist_sales_data_set.olist_customers_dataset
    ORDER BY customer_id
    LIMIT 5000
) TO STDOUT WITH CSV HEADER;
```

### 2. Export Orders (orders.csv)
```sql
COPY (
    SELECT
        order_id,
        customer_id,
        order_status,
        order_purchase_timestamp,
        order_approved_at,
        order_delivered_customer_date
    FROM olist_sales_data_set.olist_orders_dataset
    WHERE order_status IN ('delivered', 'shipped')
    ORDER BY order_purchase_timestamp DESC
    LIMIT 5000
) TO STDOUT WITH CSV HEADER;
```

### 3. Export Order Items (order_items.csv)
```sql
COPY (
    SELECT
        oi.order_id,
        oi.order_item_id,
        oi.product_id,
        oi.seller_id,
        oi.price,
        oi.freight_value
    FROM olist_sales_data_set.olist_order_items_dataset oi
    INNER JOIN olist_sales_data_set.olist_orders_dataset o
        ON oi.order_id = o.order_id
    WHERE o.order_status IN ('delivered', 'shipped')
    ORDER BY oi.order_id
    LIMIT 10000
) TO STDOUT WITH CSV HEADER;
```

### 4. Export Products (products.csv)
```sql
COPY (
    SELECT
        product_id,
        product_category_name,
        product_weight_g,
        product_length_cm,
        product_height_cm,
        product_width_cm
    FROM olist_sales_data_set.olist_products_dataset
    WHERE product_category_name IS NOT NULL
    ORDER BY product_id
    LIMIT 3000
) TO STDOUT WITH CSV HEADER;
```

### 5. Export Sellers (sellers.csv)
```sql
COPY (
    SELECT
        seller_id,
        seller_zip_code_prefix,
        seller_city,
        seller_state
    FROM olist_sales_data_set.olist_sellers_dataset
    ORDER BY seller_id
    LIMIT 2000
) TO STDOUT WITH CSV HEADER;
```

### 6. Export Reviews (order_reviews.csv)
```sql
COPY (
    SELECT
        r.review_id,
        r.order_id,
        r.review_score,
        r.review_creation_date
    FROM olist_sales_data_set.olist_order_reviews_dataset r
    INNER JOIN olist_sales_data_set.olist_orders_dataset o
        ON r.order_id = o.order_id
    WHERE o.order_status = 'delivered'
    ORDER BY r.review_creation_date DESC
    LIMIT 5000
) TO STDOUT WITH CSV HEADER;
```

### 7. Export Payments (order_payments.csv)
```sql
COPY (
    SELECT
        pay.order_id,
        pay.payment_sequential,
        pay.payment_type,
        pay.payment_installments,
        pay.payment_value
    FROM olist_sales_data_set.olist_order_payments_dataset pay
    INNER JOIN olist_sales_data_set.olist_orders_dataset o
        ON pay.order_id = o.order_id
    WHERE o.order_status IN ('delivered', 'shipped')
    ORDER BY pay.order_id
    LIMIT 5000
) TO STDOUT WITH CSV HEADER;
```

## Alternative: Python Export Script

If you have database access from Python, use this script:

```python
import pandas as pd
from sqlalchemy import create_engine

# Database connection (replace with your credentials)
connection_string = "postgresql://user:password@host:port/database"
engine = create_engine(connection_string)

# Export each table
tables = {
    'customers': 'SELECT * FROM olist_sales_data_set.olist_customers_dataset LIMIT 5000',
    'orders': 'SELECT * FROM olist_sales_data_set.olist_orders_dataset WHERE order_status IN (\'delivered\', \'shipped\') LIMIT 5000',
    'order_items': 'SELECT * FROM olist_sales_data_set.olist_order_items_dataset LIMIT 10000',
    'products': 'SELECT * FROM olist_sales_data_set.olist_products_dataset WHERE product_category_name IS NOT NULL LIMIT 3000',
    'sellers': 'SELECT * FROM olist_sales_data_set.olist_sellers_dataset LIMIT 2000',
    'order_reviews': 'SELECT * FROM olist_sales_data_set.olist_order_reviews_dataset LIMIT 5000',
    'order_payments': 'SELECT * FROM olist_sales_data_set.olist_order_payments_dataset LIMIT 5000'
}

for table_name, query in tables.items():
    df = pd.read_sql(query, engine)
    df.to_csv(f'{table_name}.csv', index=False)
    print(f'Exported {table_name}.csv - {len(df)} rows')
```

## Data Relationships

The CSV files maintain the same relationships as the SQL database:

```
customers.csv
    ↓ (customer_id)
orders.csv
    ↓ (order_id)
order_items.csv
    ↓ (product_id)      ↓ (seller_id)      ↓ (order_id)
products.csv      sellers.csv      order_reviews.csv
                                   order_payments.csv
```

## Usage in Python

Load the datasets in your Jupyter notebook:

```python
import pandas as pd

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
```

## Data Quality Notes

- All datasets are filtered for delivered/shipped orders to ensure data completeness
- NULL categories in products are excluded
- Customer and order data are synchronized (customers exist for all orders)
- Reviews and payments may be missing for some orders (use LEFT joins)

## File Size Estimates

- customers.csv: ~500 KB
- orders.csv: ~600 KB
- order_items.csv: ~1.2 MB
- products.csv: ~300 KB
- sellers.csv: ~150 KB
- order_reviews.csv: ~500 KB
- order_payments.csv: ~400 KB

**Total: ~3.7 MB** (manageable for Google Colab and local Jupyter)
