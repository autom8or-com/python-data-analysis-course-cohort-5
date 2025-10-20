# SQL Subqueries Quick Reference Guide
## Week 9: Customer Lifetime Value Analysis

---

## Table of Contents
1. [Subquery Types Overview](#subquery-types-overview)
2. [WHERE Clause Subqueries](#where-clause-subqueries)
3. [FROM Clause Subqueries (Derived Tables)](#from-clause-subqueries)
4. [SELECT Clause Subqueries](#select-clause-subqueries)
5. [Performance Tips](#performance-tips)
6. [Common Patterns for CLV](#common-patterns-for-clv)

---

## Subquery Types Overview

| Type | Location | Returns | Use Case | Example |
|------|----------|---------|----------|---------|
| **Scalar** | WHERE, SELECT, HAVING | Single value | Comparisons | `WHERE value > (SELECT AVG(value) FROM table)` |
| **Row** | WHERE | Single row, multiple columns | Multi-column comparison | `WHERE (col1, col2) = (SELECT col1, col2 FROM...)` |
| **Column** | WHERE | Single column, multiple rows | IN, ANY, ALL operators | `WHERE id IN (SELECT id FROM...)` |
| **Table** | FROM | Multiple rows & columns | Derived tables | `FROM (SELECT ... ) AS alias` |
| **Correlated** | Any | Depends on outer query | Row-by-row logic | `WHERE col = (SELECT ... WHERE outer.id = inner.id)` |

---

## WHERE Clause Subqueries

### Scalar Subquery (Single Value)

```sql
-- Find customers above average LTV
SELECT customer_id, lifetime_value
FROM customer_metrics
WHERE lifetime_value > (
    SELECT AVG(lifetime_value)
    FROM customer_metrics
);
```

**Key Points:**
- Must return exactly ONE value
- Runs once for entire query
- Fast for single comparisons

### Column Subquery (List of Values)

```sql
-- Find orders from high-value customers
SELECT order_id, customer_id, order_date
FROM orders
WHERE customer_id IN (
    SELECT customer_id
    FROM customer_metrics
    WHERE lifetime_value > 500
);
```

**Key Points:**
- Returns multiple values in single column
- Use with IN, ANY, ALL, NOT IN
- Alternative to JOIN in some cases

### Comparison Operators

| Operator | Description | Example |
|----------|-------------|---------|
| `=` | Equals (scalar only) | `WHERE value = (SELECT MAX(value)...)` |
| `>`, `<`, `>=`, `<=` | Comparison | `WHERE value > (SELECT AVG(value)...)` |
| `IN` | In list | `WHERE id IN (SELECT id...)` |
| `NOT IN` | Not in list | `WHERE id NOT IN (SELECT id...)` |
| `ANY` | Matches any value | `WHERE value > ANY (SELECT value...)` |
| `ALL` | Matches all values | `WHERE value > ALL (SELECT value...)` |
| `EXISTS` | Checks existence | `WHERE EXISTS (SELECT 1...)` |
| `NOT EXISTS` | Checks non-existence | `WHERE NOT EXISTS (SELECT 1...)` |

---

## FROM Clause Subqueries (Derived Tables)

### Basic Syntax

```sql
SELECT column1, column2
FROM (
    -- Subquery becomes a "virtual table"
    SELECT ...
    FROM ...
    WHERE ...
) AS alias_name  -- Alias is REQUIRED!
WHERE ...
ORDER BY ...
```

### Common Pattern: Pre-Aggregation

```sql
-- Customer segmentation
SELECT
    segment,
    COUNT(*) as customers,
    AVG(ltv) as avg_ltv
FROM (
    -- First, calculate individual customer metrics
    SELECT
        customer_id,
        SUM(order_value) as ltv,
        CASE
            WHEN SUM(order_value) > 1000 THEN 'VIP'
            WHEN SUM(order_value) > 500 THEN 'Gold'
            ELSE 'Standard'
        END as segment
    FROM orders
    GROUP BY customer_id
) AS customer_summary
GROUP BY segment;
```

### Nested Derived Tables

```sql
-- Multiple levels of aggregation
SELECT tier, AVG(state_avg) as national_avg
FROM (
    -- State averages
    SELECT state, AVG(customer_ltv) as state_avg
    FROM (
        -- Customer LTVs
        SELECT customer_id, state, SUM(value) as customer_ltv
        FROM orders
        GROUP BY customer_id, state
    ) AS customers
    GROUP BY state
) AS states
GROUP BY tier;
```

---

## SELECT Clause Subqueries

### Scalar Subquery in SELECT

```sql
SELECT
    customer_id,
    total_spent,

    -- Subquery must return single value per row
    (SELECT AVG(total_spent) FROM customers) as overall_avg,

    -- Can be correlated (references outer query)
    (SELECT COUNT(*)
     FROM orders o
     WHERE o.customer_id = c.customer_id) as order_count

FROM customers c;
```

**Warning:** SELECT subqueries run for EVERY row - can be slow!

### Use Cases

| Use Case | Example |
|----------|---------|
| **Comparison value** | `(SELECT AVG(price) FROM products) as avg_price` |
| **Row-specific calculation** | `(SELECT COUNT(*) FROM orders WHERE customer_id = c.id)` |
| **Conditional value** | `(SELECT status FROM latest_order WHERE...)` |

---

## Correlated Subqueries

### What Makes It Correlated?

```sql
-- NOT correlated (runs once)
SELECT customer_id
FROM customers
WHERE state = (SELECT MAX(state) FROM states);

-- CORRELATED (runs once per row)
SELECT customer_id
FROM customers c
WHERE total_spent > (
    SELECT AVG(total_spent)
    FROM customers c2
    WHERE c2.state = c.state  -- References outer query!
);
```

### EXISTS Pattern

```sql
-- Find customers who purchased category X
SELECT customer_id, customer_name
FROM customers c
WHERE EXISTS (
    SELECT 1  -- Value doesn't matter
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    WHERE o.customer_id = c.customer_id
      AND oi.category = 'Electronics'
);
```

**Why EXISTS is Better Than IN:**
- Short-circuits on first match (faster)
- Handles NULL values correctly
- More efficient for large datasets

### NOT EXISTS Pattern

```sql
-- Find customers who NEVER left bad reviews
SELECT customer_id
FROM customers c
WHERE NOT EXISTS (
    SELECT 1
    FROM reviews r
    WHERE r.customer_id = c.customer_id
      AND r.rating <= 2
);
```

---

## Performance Tips

### 1. Index Correlation Points

```sql
-- Slow without index on customer_id
SELECT *
FROM orders o
WHERE total > (
    SELECT AVG(total)
    FROM orders o2
    WHERE o2.customer_id = o.customer_id  -- Index this!
);
```

**Action:** `CREATE INDEX idx_orders_customer ON orders(customer_id);`

### 2. Use EXISTS Instead of IN

```sql
-- Slower
WHERE customer_id IN (
    SELECT customer_id FROM high_value_customers
);

-- Faster
WHERE EXISTS (
    SELECT 1 FROM high_value_customers hvc
    WHERE hvc.customer_id = customers.customer_id
);
```

### 3. Avoid SELECT Clause Subqueries When Possible

```sql
-- Slow (runs subquery for every row)
SELECT
    customer_id,
    (SELECT COUNT(*) FROM orders WHERE customer_id = c.id) as order_count
FROM customers c;

-- Fast (single GROUP BY)
SELECT
    c.customer_id,
    COUNT(o.order_id) as order_count
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id;
```

### 4. Limit Outer Query Rows

```sql
-- Better performance
SELECT *
FROM customers c
WHERE total_spent > 500  -- Reduce rows BEFORE subquery
  AND EXISTS (
      SELECT 1 FROM premium_products...
  );
```

---

## Common Patterns for CLV Analysis

### Pattern 1: Above Average Customers

```sql
SELECT customer_id, ltv
FROM customer_metrics
WHERE ltv > (SELECT AVG(ltv) FROM customer_metrics);
```

### Pattern 2: Top N Per Category

```sql
SELECT *
FROM (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY category ORDER BY revenue DESC) as rank
    FROM products
) ranked
WHERE rank <= 10;
```

### Pattern 3: Customer vs State Average

```sql
SELECT
    customer_id,
    state,
    ltv,
    (SELECT AVG(ltv) FROM customers c2 WHERE c2.state = c.state) as state_avg
FROM customers c;
```

### Pattern 4: Customers Missing a Trait

```sql
-- Customers who never bought from premium categories
SELECT customer_id
FROM customers c
WHERE NOT EXISTS (
    SELECT 1
    FROM orders o
    JOIN products p ON o.product_id = p.product_id
    WHERE o.customer_id = c.customer_id
      AND p.category IN ('Premium', 'Luxury')
);
```

### Pattern 5: Multi-Condition Filtering

```sql
SELECT customer_id
FROM customers c
WHERE
    -- Above average spend
    total_spent > (SELECT AVG(total_spent) FROM customers)
    -- AND purchased from multiple categories
    AND (
        SELECT COUNT(DISTINCT category)
        FROM orders o
        WHERE o.customer_id = c.customer_id
    ) >= 3
    -- AND recent activity
    AND last_order_date >= CURRENT_DATE - INTERVAL '90 days';
```

---

## When to Use Each Type

| Scenario | Best Choice | Why |
|----------|-------------|-----|
| Filter by single aggregate | WHERE scalar subquery | Simple, fast |
| Filter by list of IDs | EXISTS (not IN) | Performance |
| Pre-aggregate before JOIN | FROM subquery | Clarity, performance |
| Calculate per-row metrics | Join or CTE | Better than SELECT subquery |
| Multi-step logic | CTE (not subquery) | Readability |
| Check existence | EXISTS/NOT EXISTS | Performance, NULL handling |
| Ranking within groups | Window functions | More efficient than correlated |

---

## Common Mistakes to Avoid

### Mistake 1: Subquery Returns Multiple Rows

```sql
-- ERROR: Subquery returns more than one row
SELECT *
FROM products
WHERE price = (SELECT price FROM products WHERE category = 'Electronics');

-- FIX: Use IN or add LIMIT
WHERE price IN (SELECT price FROM products WHERE category = 'Electronics');
-- OR
WHERE price = (SELECT MAX(price) FROM products WHERE category = 'Electronics');
```

### Mistake 2: Forgetting Alias for Derived Table

```sql
-- ERROR: Missing alias
SELECT * FROM (SELECT * FROM customers);

-- FIX: Add AS alias
SELECT * FROM (SELECT * FROM customers) AS c;
```

### Mistake 3: Using IN with NULL Values

```sql
-- Unexpected behavior with NULLs
WHERE customer_id IN (SELECT customer_id FROM inactive_customers);
-- If inactive_customers has NULL, all rows excluded!

-- FIX: Use EXISTS
WHERE EXISTS (
    SELECT 1 FROM inactive_customers ic
    WHERE ic.customer_id = customers.customer_id
);
```

### Mistake 4: Unnecessary Correlation

```sql
-- Slow (correlated)
SELECT c.customer_id,
       (SELECT COUNT(*) FROM orders o WHERE o.customer_id = c.customer_id)
FROM customers c;

-- Fast (JOIN + GROUP BY)
SELECT c.customer_id, COUNT(o.order_id)
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id;
```

---

## Quick Decision Tree

```
Need to filter rows?
├─ By single value? → WHERE scalar subquery
├─ By list of values? → WHERE EXISTS (not IN)
└─ By complex condition? → WHERE subquery or CTE

Need calculated column?
├─ Same for all rows? → Scalar subquery (once)
├─ Different per row? → Use JOIN, not SELECT subquery
└─ Complex logic? → Use CTE, then JOIN

Need to aggregate aggregates?
└─ Use FROM subquery (derived table)

Query getting complex?
└─ Switch to CTEs for readability!
```

---

## Practice Template

```sql
-- Template for CLV analysis with subqueries

-- Step 1: WHERE subquery - Filter to relevant customers
SELECT customer_id, lifetime_value
FROM customers
WHERE lifetime_value > (
    SELECT PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY lifetime_value)
    FROM customers
)

-- Step 2: FROM subquery - Pre-aggregate complex metrics
AND customer_id IN (
    SELECT customer_id
    FROM (
        SELECT
            customer_id,
            COUNT(DISTINCT category) as categories
        FROM order_items
        GROUP BY customer_id
    ) diverse_buyers
    WHERE categories >= 3
)

-- Step 3: EXISTS - Check behavioral conditions
AND EXISTS (
    SELECT 1
    FROM orders o
    WHERE o.customer_id = customers.customer_id
      AND o.order_date >= CURRENT_DATE - INTERVAL '60 days'
);
```

---

## Additional Resources

- **PostgreSQL Documentation:** https://www.postgresql.org/docs/current/queries-table-expressions.html
- **SQL Performance Explained:** Use EXPLAIN ANALYZE before subqueries
- **Alternative:** Consider CTEs (Week 8) for complex multi-step logic

---

**Remember:** Subqueries are powerful but can be slow. Always:
1. Test with EXPLAIN ANALYZE
2. Consider alternatives (JOINs, CTEs, window functions)
3. Index correlation points
4. Use EXISTS instead of IN for better performance
