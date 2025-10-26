"""
Data Export Script for Week 10 Python Content
Exports datasets from Supabase to CSV files for pandas exercises
"""

import os
import sys

# Queries for data export (reduced to 100 rows for initial testing)
QUERIES = {
    'products': """
SELECT
    p.product_id,
    p.product_category_name,
    pct.product_category_name_english as category,
    p.product_weight_g as weight_grams,
    p.product_length_cm as length_cm,
    p.product_height_cm as height_cm,
    p.product_width_cm as width_cm,
    (p.product_length_cm * p.product_height_cm * p.product_width_cm) as volume_cm3
FROM olist_sales_data_set.olist_products_dataset p
LEFT JOIN olist_sales_data_set.product_category_name_translation pct
    ON p.product_category_name = pct.product_category_name
LIMIT 100;
""",

    'orders': """
SELECT
    order_id,
    customer_id,
    order_status,
    order_purchase_timestamp::date as order_date,
    order_delivered_customer_date::date as delivery_date
FROM olist_sales_data_set.olist_orders_dataset
WHERE order_status IN ('delivered', 'shipped', 'invoiced')
ORDER BY order_purchase_timestamp DESC
LIMIT 100;
""",

    'order_items': """
SELECT
    oi.order_id,
    oi.order_item_id,
    oi.product_id,
    oi.seller_id,
    oi.price,
    oi.freight_value
FROM olist_sales_data_set.olist_order_items_dataset oi
WHERE oi.order_id IN (
    SELECT order_id
    FROM olist_sales_data_set.olist_orders_dataset
    WHERE order_status IN ('delivered', 'shipped', 'invoiced')
    ORDER BY order_purchase_timestamp DESC
    LIMIT 100
);
""",

    'suppliers': """
SELECT
    s.seller_id as supplier_id,
    s.seller_city as city,
    s.seller_state as state,
    COUNT(DISTINCT oi.product_id) as product_count,
    AVG(oi.price) as avg_price
FROM olist_sales_data_set.olist_sellers_dataset s
JOIN olist_sales_data_set.olist_order_items_dataset oi
    ON s.seller_id = oi.seller_id
GROUP BY s.seller_id, s.seller_city, s.seller_state
HAVING COUNT(DISTINCT oi.product_id) > 10
LIMIT 100;
""",

    'inventory': """
WITH product_demand AS (
    SELECT
        product_id,
        COUNT(*) as order_frequency,
        AVG(price) as avg_price
    FROM olist_sales_data_set.olist_order_items_dataset
    GROUP BY product_id
    HAVING COUNT(*) > 5
    LIMIT 100
)
SELECT
    product_id,
    (RANDOM() * 4 + 1)::INTEGER as warehouse_id,
    (order_frequency * (RANDOM() * 0.5 + 0.75))::INTEGER as stock_level,
    (order_frequency * 0.25)::INTEGER as reorder_point,
    (CURRENT_DATE - (RANDOM() * 60)::INTEGER) as last_restocked,
    CASE
        WHEN RANDOM() < 0.8 THEN 'In Stock'
        WHEN RANDOM() < 0.95 THEN 'Low Stock'
        ELSE 'Out of Stock'
    END as status
FROM product_demand;
"""
}

print("=" * 60)
print("Week 10 Dataset Export Script")
print("=" * 60)
print("\nThis script exports data from Supabase to CSV files.")
print("\nQueries ready for:")
for name in QUERIES.keys():
    print(f"  - {name}.csv")
print("\nNote: warehouses.csv is already created (synthetic data)")
print("\n" + "=" * 60)
print("\nTo execute these queries:")
print("1. Use Supabase web interface (SQL Editor)")
print("2. Run each query and export as CSV")
print("3. Save to this directory with corresponding filename")
print("\nOr use the Supabase MCP server with smaller batches.")
print("=" * 60)
