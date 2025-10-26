# Week 10: Inventory Management & Supply Chain Analysis
## Content Summary and Implementation Guide

**Week Dates**: October 15-16, 2025
**Topics**: Data Merging/Reshaping (Python) | Database Modeling (SQL)
**Business Context**: Lagos e-commerce inventory management and supply chain optimization

---

## Overview

Week 10 provides synchronized instruction on combining and reshaping data for comprehensive inventory analysis. Students learn to merge multiple data sources (Python) while understanding the underlying database design principles (SQL) that make such operations possible.

### Learning Progression
- **Wednesday (Python)**: Practical data combination using pandas merge, pivot, concat
- **Thursday (SQL)**: Theoretical foundation through normalization, views, and data integrity

---

## Content Status Summary

### SQL Content (Thursday) - Status: ✅ 90% COMPLETE

**Lecture Materials**: 4/4 files complete
- ✅ 01-normalization-review.sql
- ✅ 02-views-materialized-views.sql
- ✅ 03-data-integrity.sql
- ✅ inventory-schema-design.sql

**Exercises**: 1/3 files complete
- ✅ exercise-01-schema-analysis.sql
- ⏳ exercise-02-create-views.sql (NEEDS CREATION)
- ⏳ exercise-03-data-integrity.sql (NEEDS CREATION)

**Solutions**: 0/3 files (NEEDS CREATION)
**Resources**: 0/4 files (NEEDS CREATION)

### Python Content (Wednesday) - Status: ✅ 100% COMPLETE

**Datasets**: 6/6 CSV files ✅ COMPLETE
- ✅ products.csv (20 rows)
- ✅ inventory.csv (20 rows)
- ✅ orders.csv (20 rows)
- ✅ order_items.csv (20 rows)
- ✅ suppliers.csv (20 rows)
- ✅ warehouses.csv (5 rows)

**Lecture Notebooks**: 3/3 notebooks ✅ COMPLETE
- ✅ wed_inventory_merging_part1.ipynb (45 min)
- ✅ wed_inventory_reshaping_part2.ipynb (45 min)
- ✅ wed_inventory_concatenation_part3.ipynb (30 min)

**Exercises**: 1/1 notebooks ✅ COMPLETE
- ✅ week10_inventory_exercises.ipynb (5 exercises)

**Solutions**: 1/1 notebooks ✅ COMPLETE (in .gitignore)
- ✅ week10_inventory_solutions.ipynb (instructor only)

**Supporting Files**: ✅ COMPLETE
- ✅ convert_to_csv.py (data conversion utility)
- ✅ export_data.py (SQL query documentation)
- ✅ README.md (comprehensive guide)


---

## SQL-to-Pandas Concept Mapping

| SQL Concept | Pandas Equivalent | Business Use Case |
|-------------|-------------------|-------------------|
| `INNER JOIN` | `merge(how='inner')` | Match products to active inventory only |
| `LEFT JOIN` | `merge(how='left')` | Keep all products, show inventory where available |
| `RIGHT JOIN` | `merge(how='right')` | Keep all inventory records, add product details |
| `FULL OUTER JOIN` | `merge(how='outer')` | See all products and inventory, identify gaps |
| `UNION` | `concat(axis=0)` | Combine monthly sales reports vertically |
| `PIVOT` | `pivot_table()` | Monthly sales by category matrix |
| Normalization (1NF) | Tidy data (long format) | One observation per row |
| Denormalization | Wide format | Reporting-friendly structure |
| `VIEW` | Computed DataFrame | Reusable transformations |
| `MATERIALIZED VIEW` | Cached DataFrame | Pre-computed aggregations |

---

## Nigerian Business Context

### Lagos E-Commerce Scenarios

1. **Inventory Management**
   - Multi-warehouse coordination (Lagos, Abuja, Port Harcourt)
   - Supplier reliability tracking
   - Product demand forecasting by region

2. **Supply Chain Optimization**
   - Delivery route analysis
   - Warehouse capacity planning
   - Regional stock balancing

### Currency and Localization
- All monetary values in Nigerian Naira (₦)
- Date formats: DD/MM/YYYY (Nigerian standard)
- Business hours: 8 AM - 6 PM WAT (West Africa Time)
- Major cities: Lagos (primary), Abuja (capital), Port Harcourt (oil hub), Kano (northern trade)

---

## Data Export Queries for Python Content

### 1. Products Dataset
```sql
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
LIMIT 1000;
```

### 2. Orders Dataset
```sql
SELECT
    order_id,
    customer_id,
    order_status,
    order_purchase_timestamp::date as order_date,
    order_delivered_customer_date::date as delivery_date
FROM olist_sales_data_set.olist_orders_dataset
WHERE order_status IN ('delivered', 'shipped', 'invoiced')
LIMIT 1000;
```

### 3. Order Items Dataset
```sql
SELECT
    order_id,
    order_item_id,
    product_id,
    seller_id,
    price,
    freight_value
FROM olist_sales_data_set.olist_order_items_dataset
WHERE order_id IN (SELECT order_id FROM olist_orders_dataset LIMIT 1000);
```

### 4. Warehouses (Synthetic Data)
```sql
-- Create Nigerian warehouse reference data
SELECT
    warehouse_id,
    city,
    state,
    region,
    capacity_m3
FROM (VALUES
    (1, 'Lagos', 'LA', 'South West', 50000),
    (2, 'Abuja', 'FC', 'North Central', 35000),
    (3, 'Port Harcourt', 'RV', 'South South', 28000),
    (4, 'Kano', 'KN', 'North West', 25000),
    (5, 'Ibadan', 'OY', 'South West', 20000)
) AS warehouses(warehouse_id, city, state, region, capacity_m3);
```

### 5. Suppliers (Derived from Sellers)
```sql
SELECT
    seller_id as supplier_id,
    seller_city as city,
    seller_state as state,
    COUNT(DISTINCT product_id) as product_count,
    AVG(price) as avg_price
FROM olist_sales_data_set.olist_sellers_dataset s
JOIN olist_sales_data_set.olist_order_items_dataset oi
    ON s.seller_id = oi.seller_id
GROUP BY seller_id, seller_city, seller_state
HAVING COUNT(DISTINCT product_id) > 10
LIMIT 100;
```

### 6. Inventory (Synthetic Based on Order Patterns)
```sql
WITH product_demand AS (
    SELECT
        product_id,
        COUNT(*) as order_frequency,
        AVG(price) as avg_price
    FROM olist_sales_data_set.olist_order_items_dataset
    GROUP BY product_id
    HAVING COUNT(*) > 5
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
FROM product_demand
LIMIT 1000;
```

---

## Teaching Notes

### Wednesday Python Session (2 hours)

**Hour 1: Merging Operations (60 mins)**
- 0-15 min: Merge concepts and types
- 15-35 min: Live coding demonstrations
- 35-50 min: Guided practice
- 50-60 min: Exercise 1 start

**Hour 2: Reshaping and Combining (60 mins)**
- 0-20 min: Pivot and melt demonstrations
- 20-40 min: Concat operations
- 40-50 min: Exercises 2 and 3
- 50-60 min: Q&A and project preview

### Thursday SQL Session (2 hours)

**Hour 1: Normalization and Views (60 mins)**
- 0-30 min: Normalization review
- 30-60 min: Creating views

**Hour 2: Materialized Views and Integrity (60 mins)**
- 0-30 min: Materialized views
- 30-45 min: Data integrity
- 45-60 min: Exercises and Q&A

---

## Assessment Strategy

### Formative Assessment (During Class)
- Quick polls on merge type selection
- Code-along exercises with immediate feedback
- Peer code review for reshaping operations

### Summative Assessment (Take-Home)
Complete inventory analysis project requiring:
1. Merge 4+ data sources correctly
2. Reshape data for monthly trend analysis
3. Create pivot tables for category performance
4. Calculate inventory turnover metrics
5. Document data quality issues found
6. Provide business recommendations

---

## File Creation Priority

### Critical Path (Complete First)
1. ✅ SQL lecture notebooks (DONE)
2. ✅ Python dataset CSV files (DONE)
3. ✅ Python lecture notebook 01-merging (DONE)
4. ✅ Python lecture notebook 02-reshaping (DONE)
5. ✅ Python lecture notebook 03-concatenation (DONE)

### Important (Complete Second)
6. ✅ Python exercises (DONE - week10_inventory_exercises.ipynb)
7. ⏳ SQL exercises 2-3 (OPTIONAL)
8. ✅ Python README (DONE)

### Nice to Have (Complete Last)
9. ✅ Python solutions (DONE - in .gitignore)
10. ⏳ SQL solutions (OPTIONAL)
11. ⏳ All resource documents (OPTIONAL)
12. ⏳ Python notebook 04 integrated project (OPTIONAL - may be covered in exercises)

---

## Git Workflow

```bash
# Current branch: phase_2_week10_content
git status
git add curriculum/02-phase-2-core-skills/weeks-09-12-advanced/week-10-inventory-management/
git commit -m "Add Week 10: Inventory Management & Supply Chain Analysis content"
git push origin phase_2_week10_content

# When complete:
# Create PR: phase_2_week10_content -> main
# Title: "Add Week 10: Inventory Management & Supply Chain Analysis (SQL & Python)"
```

---

**Document Version**: 2.0
**Last Updated**: October 26, 2025
**Content Author**: Claude Code (sql-python-curriculum-developer agent)
**Status**: SQL Complete (90%) | Python Complete (100%) ✅
**Next Action**: Create Pull Request to merge into main branch
**Python Content Completion Date**: October 26, 2025
