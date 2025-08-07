# Supabase Database Setup for Olist Dataset

## Database Configuration

### Supabase MCP Server Integration
- **Database**: PostgreSQL via Supabase
- **Access Method**: MCP (Model Context Protocol) server
- **Schema Names**: 
  - `olist_sales_data_set`: Primary sales and transactional data
  - `olist_marketing_data_set`: Marketing funnel and customer acquisition data

## Table Structure for Beginners

### Schema: `olist_sales_data_set`

#### 1. `orders` (Main order information)
**Source**: `olist_orders_dataset.csv`
```sql
CREATE TABLE olist_sales_data_set.orders (
    order_id VARCHAR(255) PRIMARY KEY,
    customer_id VARCHAR(255) NOT NULL,
    order_status VARCHAR(100) NOT NULL,
    order_purchase_timestamp TIMESTAMP,
    order_approved_at TIMESTAMP,
    order_delivered_carrier_date TIMESTAMP,
    order_delivered_customer_date TIMESTAMP,
    order_estimated_delivery_date TIMESTAMP
);
```

#### 2. `customers` (Customer details and locations)
**Source**: `olist_customers_dataset.csv`
```sql
CREATE TABLE olist_sales_data_set.customers (
    customer_id VARCHAR(255) PRIMARY KEY,
    customer_unique_id VARCHAR(255),
    customer_zip_code_prefix INTEGER,
    customer_city VARCHAR(255),
    customer_state VARCHAR(10)
);
```

#### 3. `order_items` (What was bought in each order)
**Source**: `olist_order_items_dataset.csv`
```sql
CREATE TABLE olist_sales_data_set.order_items (
    order_id VARCHAR(255),
    order_item_id INTEGER,
    product_id VARCHAR(255),
    seller_id VARCHAR(255),
    shipping_limit_date TIMESTAMP,
    price DECIMAL(10,2),
    freight_value DECIMAL(10,2),
    PRIMARY KEY (order_id, order_item_id)
);
```

#### 4. `products` (Product catalog information)
**Source**: `olist_products_dataset.csv`
```sql
CREATE TABLE olist_sales_data_set.products (
    product_id VARCHAR(255) PRIMARY KEY,
    product_category_name VARCHAR(255),
    product_name_length INTEGER,
    product_description_length INTEGER,
    product_photos_qty INTEGER,
    product_weight_g INTEGER,
    product_length_cm INTEGER,
    product_height_cm INTEGER,
    product_width_cm INTEGER
);
```

#### 5. `payments` (Payment information)
**Source**: `olist_order_payments_dataset.csv`
```sql
CREATE TABLE olist_sales_data_set.payments (
    order_id VARCHAR(255),
    payment_sequential INTEGER,
    payment_type VARCHAR(100),
    payment_installments INTEGER,
    payment_value DECIMAL(10,2),
    PRIMARY KEY (order_id, payment_sequential)
);
```

#### 6. `reviews` (Customer feedback)
**Source**: `olist_order_reviews_dataset.csv`
```sql
CREATE TABLE olist_sales_data_set.reviews (
    review_id VARCHAR(255) PRIMARY KEY,
    order_id VARCHAR(255),
    review_score INTEGER,
    review_comment_title TEXT,
    review_comment_message TEXT,
    review_creation_date TIMESTAMP,
    review_answer_timestamp TIMESTAMP
);
```

#### 7. `sellers` (Seller information)
**Source**: `olist_sellers_dataset.csv`
```sql
CREATE TABLE olist_sales_data_set.sellers (
    seller_id VARCHAR(255) PRIMARY KEY,
    seller_zip_code_prefix INTEGER,
    seller_city VARCHAR(255),
    seller_state VARCHAR(10)
);
```

#### 8. `locations` (Geographic data)
**Source**: `olist_geolocation_dataset.csv`
```sql
CREATE TABLE olist_sales_data_set.locations (
    geolocation_zip_code_prefix INTEGER,
    geolocation_lat DECIMAL(10,8),
    geolocation_lng DECIMAL(11,8),
    geolocation_city VARCHAR(255),
    geolocation_state VARCHAR(10)
);
```

### Schema: `olist_marketing_data_set`

#### 1. `marketing_qualified_leads` (Marketing funnel data)
**Source**: `olist_marketing_qualified_leads_dataset.csv`
```sql
CREATE TABLE olist_marketing_data_set.marketing_qualified_leads (
    mql_id VARCHAR(255) PRIMARY KEY,
    first_contact_date TIMESTAMP,
    landing_page_id VARCHAR(255),
    origin VARCHAR(255)
);
```

#### 2. `closed_deals` (Successful conversions)
**Source**: `olist_closed_deals_dataset.csv`
```sql
CREATE TABLE olist_marketing_data_set.closed_deals (
    mql_id VARCHAR(255) PRIMARY KEY,
    seller_id VARCHAR(255),
    sdr_id VARCHAR(255),
    sr_id VARCHAR(255),
    won_date TIMESTAMP,
    business_segment VARCHAR(255),
    lead_type VARCHAR(255),
    lead_behaviour_profile VARCHAR(255),
    has_company BOOLEAN,
    has_gtin BOOLEAN,
    average_stock VARCHAR(100),
    business_type VARCHAR(255),
    declared_product_catalog_size INTEGER,
    declared_monthly_revenue DECIMAL(15,2)
);
```

## Beginner-Friendly Views

### Simplified Order Summary
```sql
CREATE VIEW olist_sales_data_set.simple_orders AS
SELECT 
    o.order_id,
    o.order_status,
    o.order_purchase_timestamp::date as order_date,
    c.customer_state,
    c.customer_city,
    COALESCE(p.payment_value, 0) as total_payment,
    CASE 
        WHEN o.order_delivered_customer_date > o.order_estimated_delivery_date 
        THEN 'Late' 
        ELSE 'On Time' 
    END as delivery_status
FROM olist_sales_data_set.orders o
LEFT JOIN olist_sales_data_set.customers c ON o.customer_id = c.customer_id
LEFT JOIN (
    SELECT order_id, SUM(payment_value) as payment_value 
    FROM olist_sales_data_set.payments 
    GROUP BY order_id
) p ON o.order_id = p.order_id;
```

### Sales by State
```sql
CREATE VIEW olist_sales_data_set.sales_by_state AS
SELECT 
    c.customer_state,
    COUNT(*) as total_orders,
    SUM(p.payment_value) as total_revenue,
    AVG(p.payment_value) as avg_order_value
FROM olist_sales_data_set.orders o
JOIN olist_sales_data_set.customers c ON o.customer_id = c.customer_id
JOIN (
    SELECT order_id, SUM(payment_value) as payment_value 
    FROM olist_sales_data_set.payments 
    GROUP BY order_id
) p ON o.order_id = p.order_id
WHERE o.order_status = 'delivered'
GROUP BY c.customer_state
ORDER BY total_revenue DESC;
```

## Data Loading Instructions

### Prerequisites
1. Supabase project created
2. MCP server configured for database access
3. SQL client (VS Code with PostgreSQL extension)

### Loading Process
1. **Create schemas**: Run schema creation scripts
2. **Import CSV data**: Use Supabase dashboard or command line tools
3. **Create views**: Run view creation scripts for beginner-friendly tables
4. **Test connection**: Verify MCP server can access tables
5. **Create sample queries**: Test basic SELECT statements

## Student Access Guidelines

### Recommended Query Patterns for Beginners
```sql
-- Always start with simple SELECT
SELECT * FROM olist_sales_data_set.orders LIMIT 5;

-- Use meaningful aliases
SELECT 
    order_id as "Order ID",
    order_status as "Status",
    order_purchase_timestamp as "Purchase Date"
FROM olist_sales_data_set.orders;

-- Build complexity gradually
SELECT 
    customer_state,
    COUNT(*) as "Number of Orders"
FROM olist_sales_data_set.simple_orders
GROUP BY customer_state
ORDER BY "Number of Orders" DESC;
```

### Common Beginner Errors to Avoid
- Missing quotes around column names with spaces
- Forgetting table prefixes in joins
- Using wrong data types in comparisons
- Not using LIMIT when exploring large tables

---

*This setup provides a beginner-friendly environment for learning SQL while working with real e-commerce data.*