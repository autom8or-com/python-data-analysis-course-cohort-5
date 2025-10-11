# Week 7: Joining Data Sources - SQL Lesson Plan

## Course Information
- **Program**: PORA Academy Cohort 5 - Data Analytics & AI Bootcamp
- **Phase**: 2 - Core Skills Development
- **Week**: 7 (September 24-25, 2025)
- **Day**: Thursday - SQL Session
- **Duration**: 2 hours
- **Topic**: SQL JOINs Mastery

## Excel Bridge Concept
**Excel Equivalent**: VLOOKUP, INDEX-MATCH, and Power Query merge operations

In Excel, you use VLOOKUP to bring data from one table into another based on a matching key. SQL JOINs accomplish the same goal but with more flexibility and power. Instead of looking up one value at a time, SQL JOINs combine entire tables based on related columns.

## Business Scenario
**Customer Journey Analysis**: Connecting orders, products, customers, and reviews to understand the complete e-commerce experience in the Olist marketplace.

You work as a data analyst for Olist, a Brazilian e-commerce platform. Your manager needs insights that require data from multiple tables:
- Which products do customers from São Paulo prefer?
- What's the average review score for orders containing electronics?
- How do seller locations affect delivery times?

These questions can't be answered with a single table - you need to JOIN data sources!

## Learning Objectives
By the end of this session, students will be able to:
1. Understand relational database concepts and why data is normalized across tables
2. Write INNER JOIN queries to combine data from multiple tables
3. Use LEFT JOIN to include all records from one table even without matches
4. Apply RIGHT JOIN and FULL OUTER JOIN for comprehensive data analysis
5. Handle duplicate keys and missing matches appropriately
6. Construct multi-table joins with proper syntax and logical ordering
7. Understand JOIN performance considerations for real-world applications

## Database Schema Overview

### Olist Sales Data Structure (Entity Relationship)

```
olist_customers_dataset
├── customer_id (PK)
├── customer_unique_id
├── customer_city
└── customer_state

olist_orders_dataset
├── order_id (PK)
├── customer_id (FK → customers)
├── order_status
├── order_purchase_timestamp
└── order_delivered_customer_date

olist_order_items_dataset
├── order_id (FK → orders)
├── order_item_id
├── product_id (FK → products)
├── seller_id (FK → sellers)
├── price
└── freight_value

olist_products_dataset
├── product_id (PK)
├── product_category_name
├── product_weight_g
└── product_dimensions

olist_sellers_dataset
├── seller_id (PK)
├── seller_city
└── seller_state

olist_order_reviews_dataset
├── review_id (PK)
├── order_id (FK → orders)
├── review_score
└── review_creation_date

olist_order_payments_dataset
├── order_id (FK → orders)
├── payment_type
├── payment_installments
└── payment_value
```

## Lesson Structure (120 minutes)

### Part 1: Understanding Relational Data (15 minutes)

#### Why Tables Are Separated (Normalization)
**Concept**: In Excel, you might have one massive spreadsheet with all data. Databases split data into related tables to:
- Reduce redundancy (don't repeat customer info for every order)
- Improve data integrity (update customer address in one place)
- Optimize storage and performance

**Real-World Analogy**:
Think of your phone contacts. You don't write your friend's full information every time you text them. Your messages reference the contact by ID, and the full details are stored separately. That's how database joins work!

#### Foreign Keys: The Connection Points
- **Primary Key (PK)**: Unique identifier for each record (like customer_id)
- **Foreign Key (FK)**: Column that references a primary key in another table

**Demo Query**: Show table relationships
```sql
-- View customers table structure
SELECT * FROM olist_sales_data_set.olist_customers_dataset LIMIT 5;

-- View orders table structure (note the customer_id foreign key)
SELECT * FROM olist_sales_data_set.olist_orders_dataset LIMIT 5;
```

### Part 2: INNER JOIN - The Foundation (25 minutes)

#### Concept Explanation
**INNER JOIN**: Returns only records that have matching values in BOTH tables.

**Excel Analogy**: Like VLOOKUP, but only shows rows where a match is found. No match? Row is excluded.

**Visual Representation**:
```
Table A        Table B         INNER JOIN Result
-------        -------         -----------------
   A              B            Only overlapping
  ┌─┐            ┌─┐           area (A ∩ B)
  │ │     +      │ │      =         ┌─┐
  └─┘            └─┘                │█│
                                    └─┘
```

#### Basic Syntax
```sql
SELECT
    table1.column1,
    table2.column2
FROM table1
INNER JOIN table2
    ON table1.key_column = table2.key_column;
```

#### Practical Example 1: Orders with Customer Information
**Business Question**: "Show me orders with customer city and state information"

```sql
-- INNER JOIN: Orders with customer details
SELECT
    o.order_id,
    o.order_purchase_timestamp::date AS purchase_date,
    o.order_status,
    c.customer_city,
    c.customer_state
FROM olist_sales_data_set.olist_orders_dataset o
INNER JOIN olist_sales_data_set.olist_customers_dataset c
    ON o.customer_id = c.customer_id
ORDER BY o.order_purchase_timestamp DESC
LIMIT 20;
```

**Key Teaching Points**:
- Table aliases (o, c) make queries readable
- ON clause specifies the join condition
- Only orders with matching customers appear (INNER JOIN behavior)

#### Practical Example 2: Orders with Items and Products
**Business Question**: "What products were purchased in each order?"

```sql
-- Three-table INNER JOIN: Orders → Items → Products
SELECT
    o.order_id,
    o.order_purchase_timestamp::date AS purchase_date,
    oi.product_id,
    p.product_category_name,
    oi.price,
    oi.freight_value
FROM olist_sales_data_set.olist_orders_dataset o
INNER JOIN olist_sales_data_set.olist_order_items_dataset oi
    ON o.order_id = oi.order_id
INNER JOIN olist_sales_data_set.olist_products_dataset p
    ON oi.product_id = p.product_id
WHERE o.order_status = 'delivered'
ORDER BY o.order_purchase_timestamp DESC
LIMIT 20;
```

**Key Teaching Points**:
- Multiple JOINs chain together logically
- Join order matters for readability (start with main table)
- WHERE clause filters AFTER joins are performed

### Part 3: LEFT JOIN - Keeping All Records from Left Table (25 minutes)

#### Concept Explanation
**LEFT JOIN** (or LEFT OUTER JOIN): Returns ALL records from the left table, and matching records from the right table. If no match exists, NULL values appear for right table columns.

**Excel Analogy**: Like VLOOKUP with IFERROR - you keep all original rows, showing blanks when no match is found.

**Visual Representation**:
```
Table A        Table B         LEFT JOIN Result
-------        -------         -----------------
   A              B            All of A + matching B
  ┌─┐            ┌─┐
  │█│     +      │ │      =    ┌─┐
  └─┘            └─┘            │█│
                                └─┘
```

#### When to Use LEFT JOIN
Use LEFT JOIN when you want:
- All records from the main table regardless of matches
- To identify records WITHOUT matches (using WHERE right_table.column IS NULL)
- To preserve your primary dataset while adding supplementary information

#### Practical Example 1: All Orders with Optional Review Data
**Business Question**: "Show all orders, including those without reviews"

```sql
-- LEFT JOIN: All orders with review data (if available)
SELECT
    o.order_id,
    o.order_status,
    o.order_purchase_timestamp::date AS purchase_date,
    r.review_score,
    r.review_creation_date::date AS review_date
FROM olist_sales_data_set.olist_orders_dataset o
LEFT JOIN olist_sales_data_set.olist_order_reviews_dataset r
    ON o.order_id = r.order_id
WHERE o.order_status = 'delivered'
ORDER BY o.order_purchase_timestamp DESC
LIMIT 20;
```

**Key Teaching Points**:
- All orders appear (left table preserved)
- review_score and review_date are NULL for orders without reviews
- This reveals data completeness issues

#### Practical Example 2: Finding Orders WITHOUT Reviews
**Business Question**: "Which delivered orders have no customer reviews?"

```sql
-- Using LEFT JOIN to find missing data
SELECT
    o.order_id,
    o.customer_id,
    o.order_purchase_timestamp::date AS purchase_date,
    o.order_delivered_customer_date::date AS delivery_date
FROM olist_sales_data_set.olist_orders_dataset o
LEFT JOIN olist_sales_data_set.olist_order_reviews_dataset r
    ON o.order_id = r.order_id
WHERE o.order_status = 'delivered'
    AND r.review_id IS NULL
ORDER BY o.order_purchase_timestamp DESC
LIMIT 20;
```

**Key Teaching Points**:
- LEFT JOIN + IS NULL pattern identifies missing relationships
- Critical for data quality analysis
- Helps identify gaps in business processes (customers not reviewing)

### Part 4: RIGHT JOIN and FULL OUTER JOIN (15 minutes)

#### RIGHT JOIN
**RIGHT JOIN**: Opposite of LEFT JOIN - keeps all records from RIGHT table, matching records from left.

**When to Use**: Less common in practice (you can reverse tables and use LEFT JOIN instead). Some developers prefer LEFT JOIN for consistency.

```sql
-- RIGHT JOIN example (could be rewritten as LEFT JOIN)
SELECT
    r.review_id,
    r.review_score,
    o.order_id,
    o.order_status
FROM olist_sales_data_set.olist_orders_dataset o
RIGHT JOIN olist_sales_data_set.olist_order_reviews_dataset r
    ON o.order_id = r.order_id
LIMIT 20;

-- Same result as:
-- SELECT ... FROM reviews r LEFT JOIN orders o ON ...
```

#### FULL OUTER JOIN
**FULL OUTER JOIN**: Returns ALL records from BOTH tables, with NULLs where no match exists.

**Visual Representation**:
```
Table A        Table B         FULL OUTER JOIN
-------        -------         ---------------
   A              B            Everything
  ┌─┐            ┌─┐
  │█│     +      │█│      =    ┌─┐
  └─┘            └─┘            │█│
                                └─┘
```

**When to Use**: Data reconciliation, finding all mismatches between systems.

```sql
-- FULL OUTER JOIN: Find all orders and reviews (including orphans)
SELECT
    o.order_id AS order_id_from_orders,
    r.order_id AS order_id_from_reviews,
    o.order_status,
    r.review_score,
    CASE
        WHEN o.order_id IS NULL THEN 'Review without order'
        WHEN r.review_id IS NULL THEN 'Order without review'
        ELSE 'Matched'
    END AS match_status
FROM olist_sales_data_set.olist_orders_dataset o
FULL OUTER JOIN olist_sales_data_set.olist_order_reviews_dataset r
    ON o.order_id = r.order_id
WHERE o.order_id IS NULL OR r.review_id IS NULL
LIMIT 20;
```

### Part 5: Advanced JOIN Scenarios (25 minutes)

#### Scenario 1: Multi-Table Analysis - Complete Customer Journey
**Business Question**: "Analyze customer orders from São Paulo: products purchased, payments, and reviews"

```sql
-- Complex multi-table join for business intelligence
SELECT
    c.customer_city,
    c.customer_state,
    o.order_id,
    o.order_purchase_timestamp::date AS purchase_date,
    p.product_category_name,
    oi.price,
    pay.payment_type,
    r.review_score
FROM olist_sales_data_set.olist_customers_dataset c
INNER JOIN olist_sales_data_set.olist_orders_dataset o
    ON c.customer_id = o.customer_id
INNER JOIN olist_sales_data_set.olist_order_items_dataset oi
    ON o.order_id = oi.order_id
INNER JOIN olist_sales_data_set.olist_products_dataset p
    ON oi.product_id = p.product_id
LEFT JOIN olist_sales_data_set.olist_order_payments_dataset pay
    ON o.order_id = pay.order_id
LEFT JOIN olist_sales_data_set.olist_order_reviews_dataset r
    ON o.order_id = r.order_id
WHERE c.customer_state = 'SP'
    AND o.order_status = 'delivered'
ORDER BY o.order_purchase_timestamp DESC
LIMIT 50;
```

**Key Teaching Points**:
- Strategic use of INNER and LEFT JOINs
- Start with main entity (customers/orders)
- Add supplementary data with LEFT JOINs (payments, reviews)
- WHERE clause applies to final joined result

#### Scenario 2: Aggregations with JOINs
**Business Question**: "What's the average review score by product category?"

```sql
-- Aggregating across joined tables
SELECT
    p.product_category_name,
    COUNT(DISTINCT o.order_id) AS total_orders,
    COUNT(r.review_id) AS total_reviews,
    ROUND(AVG(r.review_score), 2) AS avg_review_score,
    ROUND(AVG(oi.price), 2) AS avg_product_price
FROM olist_sales_data_set.olist_products_dataset p
INNER JOIN olist_sales_data_set.olist_order_items_dataset oi
    ON p.product_id = oi.product_id
INNER JOIN olist_sales_data_set.olist_orders_dataset o
    ON oi.order_id = o.order_id
LEFT JOIN olist_sales_data_set.olist_order_reviews_dataset r
    ON o.order_id = r.order_id
WHERE p.product_category_name IS NOT NULL
GROUP BY p.product_category_name
HAVING COUNT(r.review_id) >= 10
ORDER BY avg_review_score DESC, total_reviews DESC
LIMIT 20;
```

**Key Teaching Points**:
- GROUP BY works with joined data
- Use DISTINCT COUNT to avoid duplicate counting (one order, many items)
- HAVING filters after aggregation
- LEFT JOIN prevents losing products without reviews

#### Scenario 3: Self-Joins for Comparative Analysis
**Business Question**: "Find customers from the same city who made orders on the same day"

```sql
-- Self-join: Comparing records within the same table
SELECT DISTINCT
    c1.customer_id AS customer_1,
    c2.customer_id AS customer_2,
    c1.customer_city,
    o1.order_purchase_timestamp::date AS purchase_date
FROM olist_sales_data_set.olist_customers_dataset c1
INNER JOIN olist_sales_data_set.olist_orders_dataset o1
    ON c1.customer_id = o1.customer_id
INNER JOIN olist_sales_data_set.olist_customers_dataset c2
    ON c1.customer_city = c2.customer_city
    AND c1.customer_id < c2.customer_id  -- Avoid duplicates and self-matches
INNER JOIN olist_sales_data_set.olist_orders_dataset o2
    ON c2.customer_id = o2.customer_id
    AND o1.order_purchase_timestamp::date = o2.order_purchase_timestamp::date
WHERE c1.customer_city = 'sao paulo'
LIMIT 20;
```

**Key Teaching Points**:
- Self-joins compare a table to itself (use different aliases)
- Inequality conditions prevent matching a record to itself
- Useful for finding patterns, hierarchies, or comparisons

### Part 6: JOIN Performance and Best Practices (15 minutes)

#### Performance Considerations

**1. Join Order Matters (for readability, not always performance)**
```sql
-- Start with the table that will be filtered or is smallest
SELECT ...
FROM small_filtered_table
JOIN large_table ON ...
```

**2. Index Your Join Columns**
- Primary keys are automatically indexed
- Foreign keys should be indexed
- Check with: `EXPLAIN ANALYZE` to see query plan

**3. Filter Early, Join Later**
```sql
-- GOOD: Filter before joining (smaller dataset to join)
SELECT o.order_id, c.customer_city
FROM (
    SELECT * FROM olist_sales_data_set.olist_orders_dataset
    WHERE order_status = 'delivered'
) o
JOIN olist_sales_data_set.olist_customers_dataset c
    ON o.customer_id = c.customer_id;

-- BETTER: Use WHERE clause (optimizer handles it)
SELECT o.order_id, c.customer_city
FROM olist_sales_data_set.olist_orders_dataset o
JOIN olist_sales_data_set.olist_customers_dataset c
    ON o.customer_id = c.customer_id
WHERE o.order_status = 'delivered';
```

**4. Avoid Cartesian Joins (Missing ON Clause)**
```sql
-- DANGER: Cartesian product (every row matched to every row)
SELECT *
FROM table1, table2;  -- Missing join condition!

-- CORRECT: Always specify join condition
SELECT *
FROM table1
JOIN table2 ON table1.id = table2.id;
```

#### Common JOIN Pitfalls and How to Avoid Them

**1. Duplicate Records from One-to-Many Relationships**
```sql
-- Problem: One order can have multiple items (creates duplicates)
SELECT o.order_id, COUNT(*) as item_count
FROM olist_sales_data_set.olist_orders_dataset o
JOIN olist_sales_data_set.olist_order_items_dataset oi
    ON o.order_id = oi.order_id
GROUP BY o.order_id
HAVING COUNT(*) > 1;

-- Solution: Use DISTINCT or aggregate appropriately
SELECT DISTINCT o.order_id, o.order_status
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id;
```

**2. NULL Values in Join Conditions**
```sql
-- NULLs never match (NULL != NULL in SQL)
-- Use COALESCE or handle separately
SELECT ...
FROM table1 t1
LEFT JOIN table2 t2
    ON COALESCE(t1.column, 'UNKNOWN') = COALESCE(t2.column, 'UNKNOWN');
```

**3. Ambiguous Column Names**
```sql
-- ERROR: Which table's order_id?
SELECT order_id FROM orders JOIN order_items ON ...;

-- CORRECT: Always qualify columns
SELECT o.order_id FROM orders o JOIN order_items oi ON ...;
```

## Hands-On Practice During Class (15 minutes)

### Exercise 1: Basic INNER JOIN
"Write a query to show all delivered orders with customer state information. Include order_id, purchase date, and customer_state."

### Exercise 2: LEFT JOIN for Data Quality
"Find all products that have never been ordered. Hint: Use LEFT JOIN and check for NULL order_ids."

### Exercise 3: Multi-Table Analysis
"Calculate total revenue by seller state. Join orders → order_items → sellers, and sum the prices."

## Recap and Key Takeaways (10 minutes)

### Join Types Quick Reference
| Join Type | Returns | Use When |
|-----------|---------|----------|
| INNER JOIN | Only matching records from both tables | You need complete data from both sides |
| LEFT JOIN | All from left + matching from right | Keep all primary records, add optional info |
| RIGHT JOIN | All from right + matching from left | (Rare - use LEFT JOIN instead) |
| FULL OUTER JOIN | All records from both tables | Finding all mismatches/reconciliation |

### Mental Model for Choosing Join Types
1. **Start with your main table** (the one you must keep all records from)
2. **Use INNER JOIN** when related data MUST exist
3. **Use LEFT JOIN** when related data is OPTIONAL
4. **Always specify ON conditions** to avoid Cartesian products
5. **Test with LIMIT** first, then remove for full results

### Real-World Applications
- **E-commerce**: Combining orders, products, customers, and inventory
- **Marketing**: Joining campaign data with customer behavior
- **Finance**: Merging transaction data with account information
- **Healthcare**: Connecting patient records across systems

## Homework Assignment Preview
Students will receive exercises requiring:
1. Three-table joins with business logic
2. Finding missing data using LEFT JOIN + IS NULL
3. Aggregating across joined tables
4. Writing queries for real business questions

## Additional Resources
- PostgreSQL JOIN documentation
- Visual JOIN diagrams
- Common JOIN patterns cheat sheet
- SQL query optimization guide

---

**Next Session**: Wednesday Python class will cover the same joining concepts using pandas merge() and join() functions with the same Olist dataset exported to CSV files.
