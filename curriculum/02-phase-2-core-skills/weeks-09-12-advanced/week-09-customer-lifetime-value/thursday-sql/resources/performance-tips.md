# SQL Performance Tips: Subqueries, CTEs & Joins

## Overview
This guide provides practical performance optimization strategies for Customer Lifetime Value analysis queries, focusing on subqueries, CTEs, and joins. Learn when to use each technique and how to write efficient analytical queries.

---

## Part 1: Subquery Performance

### The Performance Hierarchy

**From Fastest to Slowest (Generally):**
1. JOINs with proper indexes
2. CTEs (Common Table Expressions)
3. WHERE clause subqueries (scalar or IN)
4. FROM clause subqueries (derived tables)
5. SELECT clause subqueries (correlated)
6. EXISTS / NOT EXISTS (context-dependent)

---

### Rule 1: Avoid SELECT Clause Subqueries

#### Problem
```sql
-- SLOW: Subquery executes once PER ROW
SELECT
    customer_id,
    order_total,
    (
        SELECT AVG(order_total)
        FROM orders o2
        WHERE o2.customer_id = o1.customer_id
    ) as customer_avg  -- Executes for EVERY row!
FROM orders o1;
```

#### Solution: Use Window Functions
```sql
-- FAST: Single pass through the data
SELECT
    customer_id,
    order_total,
    AVG(order_total) OVER (PARTITION BY customer_id) as customer_avg
FROM orders;
```

#### Performance Impact
- Subquery version: O(n * m) where n = rows, m = avg rows per customer
- Window function: O(n) single scan
- **Speedup: 10-100x for large datasets**

---

### Rule 2: Use EXISTS Instead of IN for Large Datasets

#### Problem with IN
```sql
-- SLOWER: Builds entire subquery result set
SELECT *
FROM customers c
WHERE c.customer_id IN (
    SELECT customer_id
    FROM orders
    WHERE order_total > 1000
);
```

#### Solution: Use EXISTS
```sql
-- FASTER: Short-circuits on first match
SELECT *
FROM customers c
WHERE EXISTS (
    SELECT 1
    FROM orders o
    WHERE o.customer_id = c.customer_id
      AND o.order_total > 1000
);
```

#### When to Use Each

| Scenario | Use | Reason |
|----------|-----|--------|
| Large subquery result | EXISTS | Stops at first match |
| Small fixed list | IN | Simple and clear: `IN (1, 2, 3)` |
| Need NOT condition | NOT EXISTS | Better performance than NOT IN |
| NULL handling critical | EXISTS | NOT IN fails with NULLs |

#### Example: NULL Handling Gotcha
```sql
-- BROKEN: Returns nothing if ANY order_id is NULL
SELECT * FROM customers
WHERE customer_id NOT IN (
    SELECT customer_id FROM orders  -- If any NULL exists, result is empty!
);

-- CORRECT: Handles NULLs properly
SELECT * FROM customers c
WHERE NOT EXISTS (
    SELECT 1 FROM orders o
    WHERE o.customer_id = c.customer_id
);
```

---

### Rule 3: Materialize Subqueries for Reuse

#### Problem: Repeated Subquery Calculation
```sql
-- INEFFICIENT: Same subquery computed twice
SELECT *
FROM orders
WHERE order_total > (SELECT AVG(order_total) FROM orders)  -- Computed here
   OR order_total < (SELECT AVG(order_total) FROM orders) * 0.5;  -- And here again!
```

#### Solution: CTE
```sql
-- EFFICIENT: Computed once
WITH avg_order AS (
    SELECT AVG(order_total) as avg_total
    FROM orders
)
SELECT *
FROM orders, avg_order
WHERE order_total > avg_order.avg_total
   OR order_total < avg_order.avg_total * 0.5;
```

---

## Part 2: CTE Performance

### CTE vs Subquery vs Temp Table

#### When to Use CTEs
- **Readability** is priority (almost always)
- Query executed **once**
- Result set is **small to medium** (< 100k rows typically)
- Need to **reference multiple times** in same query

#### When to Use Temp Tables
- Very **large intermediate results** (> 1M rows)
- Need to create **indexes** on intermediate results
- Will **reuse across multiple queries**
- Need to **gather statistics** for query optimization

#### Performance Comparison

```sql
-- CTE: Good for single query, moderate data
WITH high_value_customers AS (
    SELECT customer_id, SUM(order_total) as ltv
    FROM orders
    WHERE order_status = 'delivered'
    GROUP BY customer_id
    HAVING SUM(order_total) > 1000
)
SELECT * FROM high_value_customers;

-- Temp Table: Good for multi-query workflows, large data
CREATE TEMP TABLE high_value_customers AS
SELECT customer_id, SUM(order_total) as ltv
FROM orders
WHERE order_status = 'delivered'
GROUP BY customer_id
HAVING SUM(order_total) > 1000;

-- Now can create index
CREATE INDEX idx_hvc_ltv ON high_value_customers(ltv);

-- And reuse efficiently
SELECT * FROM high_value_customers WHERE ltv > 5000;
SELECT AVG(ltv) FROM high_value_customers;
```

---

### CTE Optimization Techniques

#### Technique 1: Push Filters Down
```sql
-- SLOW: Filter after aggregation
WITH all_customer_metrics AS (
    SELECT
        customer_id,
        COUNT(*) as order_count,
        SUM(order_total) as ltv
    FROM orders  -- Processes ALL orders
    GROUP BY customer_id
)
SELECT * FROM all_customer_metrics
WHERE order_count > 5;

-- FAST: Filter before aggregation
WITH recent_orders AS (
    SELECT customer_id, order_total
    FROM orders
    WHERE order_date >= '2023-01-01'  -- Reduces data early
      AND order_status = 'delivered'
),
customer_metrics AS (
    SELECT
        customer_id,
        COUNT(*) as order_count,
        SUM(order_total) as ltv
    FROM recent_orders
    GROUP BY customer_id
)
SELECT * FROM customer_metrics
WHERE order_count > 5;
```

#### Technique 2: Use MATERIALIZED CTEs (PostgreSQL 12+)
```sql
-- Tell database to materialize (compute once, store temporarily)
WITH MATERIALIZED expensive_calc AS (
    SELECT
        customer_id,
        complex_calculation(data) as result
    FROM large_table
)
SELECT * FROM expensive_calc e1
JOIN expensive_calc e2 ON e1.result = e2.result + 1;

-- Without MATERIALIZED, expensive_calc might run twice
```

---

## Part 3: JOIN vs Subquery Performance

### When JOINs are Faster

#### Scenario 1: One-to-Many Relationships
```sql
-- SUBQUERY: Slower
SELECT
    c.customer_id,
    c.customer_name,
    (SELECT COUNT(*) FROM orders o WHERE o.customer_id = c.customer_id) as order_count,
    (SELECT SUM(total) FROM orders o WHERE o.customer_id = c.customer_id) as total_spent
FROM customers c;

-- JOIN: Faster
SELECT
    c.customer_id,
    c.customer_name,
    COUNT(o.order_id) as order_count,
    SUM(o.total) as total_spent
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name;
```

### When Subqueries are Faster

#### Scenario 1: Filtering Before Join (Semi-Join)
```sql
-- JOIN: Slower if many non-matching rows
SELECT DISTINCT c.*
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
WHERE o.order_total > 1000;

-- SUBQUERY: Faster - avoids large join
SELECT c.*
FROM customers c
WHERE EXISTS (
    SELECT 1
    FROM orders o
    WHERE o.customer_id = c.customer_id
      AND o.order_total > 1000
);
```

#### Scenario 2: Anti-Join (Find What Doesn't Match)
```sql
-- LEFT JOIN with NULL check: Works but verbose
SELECT c.*
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;

-- NOT EXISTS: Clearer intent, often faster
SELECT c.*
FROM customers c
WHERE NOT EXISTS (
    SELECT 1
    FROM orders o
    WHERE o.customer_id = c.customer_id
);
```

---

## Part 4: Indexing Strategies for Analytics

### Essential Indexes for CLV Analysis

```sql
-- Customer table
CREATE INDEX idx_customers_state ON customers(customer_state);
CREATE INDEX idx_customers_city ON customers(customer_state, customer_city);

-- Orders table
CREATE INDEX idx_orders_customer ON orders(customer_id);
CREATE INDEX idx_orders_status ON orders(order_status);
CREATE INDEX idx_orders_date ON orders(order_date);
CREATE INDEX idx_orders_customer_status ON orders(customer_id, order_status);  -- Composite

-- Order items
CREATE INDEX idx_order_items_order ON order_items(order_id);
CREATE INDEX idx_order_items_product ON order_items(product_id);

-- Products
CREATE INDEX idx_products_category ON products(product_category_name);
```

### Index Usage Verification
```sql
-- Check if your query uses indexes
EXPLAIN ANALYZE
SELECT customer_id, SUM(order_total) as ltv
FROM orders
WHERE order_status = 'delivered'
  AND order_date >= '2023-01-01'
GROUP BY customer_id;

-- Look for:
-- ✓ "Index Scan" or "Index Only Scan" (good)
-- ✗ "Seq Scan" on large tables (bad)
```

---

## Part 5: Real-World Optimization Examples

### Example 1: Top Customers by State

#### Initial Query (Slow)
```sql
-- Problem: Correlated subquery executes per row
SELECT
    customer_id,
    customer_state,
    (
        SELECT SUM(order_total)
        FROM orders o
        WHERE o.customer_id = c.customer_id
          AND o.order_status = 'delivered'
    ) as ltv
FROM customers c
ORDER BY ltv DESC
LIMIT 100;
```

#### Optimized Version
```sql
-- Solution: Single JOIN with proper indexes
WITH customer_ltv AS (
    SELECT
        customer_id,
        SUM(order_total) as ltv
    FROM orders
    WHERE order_status = 'delivered'
    GROUP BY customer_id
)
SELECT
    c.customer_id,
    c.customer_state,
    cl.ltv
FROM customers c
JOIN customer_ltv cl ON c.customer_id = cl.customer_id
ORDER BY cl.ltv DESC
LIMIT 100;

-- Speedup: 50-100x with proper indexes
```

---

### Example 2: RFM Segmentation

#### Initial Approach (Multiple Passes)
```sql
-- SLOW: Three separate scans
SELECT
    customer_id,
    (SELECT MAX(order_date) FROM orders o WHERE o.customer_id = c.customer_id) as last_order,
    (SELECT COUNT(*) FROM orders o WHERE o.customer_id = c.customer_id) as frequency,
    (SELECT SUM(total) FROM orders o WHERE o.customer_id = c.customer_id) as monetary
FROM customers c;
```

#### Optimized Approach (Single Scan)
```sql
-- FAST: One aggregation query
WITH customer_rfm AS (
    SELECT
        customer_id,
        MAX(order_date) as last_order,
        COUNT(*) as frequency,
        SUM(total) as monetary
    FROM orders
    WHERE order_status = 'delivered'
    GROUP BY customer_id
)
SELECT
    c.customer_id,
    c.customer_name,
    EXTRACT(DAY FROM CURRENT_DATE - cfm.last_order) as recency_days,
    cfm.frequency,
    cfm.monetary
FROM customers c
JOIN customer_rfm cfm ON c.customer_id = cfm.customer_id;
```

---

## Part 6: Performance Monitoring & Troubleshooting

### Using EXPLAIN ANALYZE

```sql
-- Basic usage
EXPLAIN ANALYZE
SELECT ...;

-- Key metrics to watch:
-- 1. Execution Time: Total time taken
-- 2. Planning Time: Time to create query plan
-- 3. Rows: Estimated vs actual (large difference = bad statistics)
-- 4. Buffers: Shared hit (cache) vs read (disk)
```

### Common Performance Issues

#### Issue 1: Seq Scan on Large Table
```sql
-- EXPLAIN shows: Seq Scan on orders (cost=0.00..10000.00)

-- Solution: Add index
CREATE INDEX idx_orders_status_date ON orders(order_status, order_date);

-- Or filter more selectively
WHERE order_date >= CURRENT_DATE - INTERVAL '90 days'  -- Reduces scan
```

#### Issue 2: Nested Loop with Many Rows
```sql
-- EXPLAIN shows: Nested Loop (cost=...)
--   -> Seq Scan on customers (rows=100000)
--   -> Index Scan on orders (rows=10)

-- Problem: Inner query runs 100,000 times

-- Solution: Switch join order or use hash join
SET enable_hashjoin = ON;  -- Force hash join if beneficial
```

#### Issue 3: Sort Operation on Large Dataset
```sql
-- EXPLAIN shows: Sort (cost=10000.00..15000.00)
-- Memory: 250MB  Disk: 500MB  -- Spilling to disk!

-- Solution 1: Increase work_mem temporarily
SET work_mem = '500MB';

-- Solution 2: Add index on sort column
CREATE INDEX idx_orders_total ON orders(order_total DESC);

-- Solution 3: Limit earlier in query
WITH top_orders AS (
    SELECT *
    FROM orders
    WHERE order_total > 100  -- Pre-filter
)
SELECT * FROM top_orders
ORDER BY order_total DESC
LIMIT 100;
```

---

## Part 7: Nigerian E-Commerce Specific Optimizations

### Scenario: Lagos State Analysis
```sql
-- SLOW: Filter after expensive joins
SELECT
    c.customer_id,
    c.customer_city,
    COUNT(o.order_id) as orders,
    SUM(oi.price) as total_spent
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
WHERE c.customer_state = 'LA'  -- Filter at the end
GROUP BY c.customer_id, c.customer_city;

-- FAST: Filter early, reduce join size
WITH lagos_customers AS (
    SELECT customer_id, customer_city
    FROM customers
    WHERE customer_state = 'LA'  -- Only Lagos customers
),
lagos_orders AS (
    SELECT o.customer_id, o.order_id
    FROM orders o
    WHERE EXISTS (
        SELECT 1 FROM lagos_customers lc
        WHERE lc.customer_id = o.customer_id
    )
)
SELECT
    lc.customer_id,
    lc.customer_city,
    COUNT(lo.order_id) as orders,
    SUM(oi.price) as total_spent
FROM lagos_customers lc
JOIN lagos_orders lo ON lc.customer_id = lo.customer_id
JOIN order_items oi ON lo.order_id = oi.order_id
GROUP BY lc.customer_id, lc.customer_city;
```

---

## Quick Decision Guide

### Choose Your Technique

```
Need to filter based on aggregated data?
├─ Small dataset (< 1000 rows)
│  └─ Use: WHERE IN (subquery)
└─ Large dataset (> 1000 rows)
   └─ Use: WHERE EXISTS

Need to calculate multiple metrics?
├─ One metric
│  └─ Use: Simple JOIN
└─ Multiple metrics from same table
   ├─ Different aggregation levels
   │  └─ Use: Multiple CTEs then JOIN
   └─ Same aggregation level
      └─ Use: Single CTE with multiple aggregations

Need to reuse calculation?
├─ Within same query
│  └─ Use: CTE
└─ Across multiple queries
   └─ Use: Temp Table

Building complex pipeline?
├─ Prioritize readability
│  └─ Use: Multi-stage CTE
└─ Prioritize performance (very large data)
   └─ Use: Temp tables with indexes
```

---

## Performance Checklist

Before deploying a CLV query to production:

- [ ] Verified indexes exist on all JOIN columns
- [ ] Added WHERE clauses to filter early in query pipeline
- [ ] Replaced SELECT subqueries with JOINs or window functions
- [ ] Used CTEs for clarity and to avoid repeated calculations
- [ ] Ran EXPLAIN ANALYZE to check execution plan
- [ ] Tested with production-size data (not just samples)
- [ ] Confirmed no sequential scans on large tables
- [ ] Checked that statistics are up to date (ANALYZE command)
- [ ] Limited result sets where possible (LIMIT, date ranges)
- [ ] Considered partitioning for very large historical tables

---

## Additional Resources

- PostgreSQL Performance Tips: https://wiki.postgresql.org/wiki/Performance_Optimization
- Query Optimization Guide: Week 10 Advanced Window Functions
- Index Strategy Deep Dive: Week 11 Materials

---

Last Updated: October 2025
Course: PORA Academy Cohort 5 - Week 9
