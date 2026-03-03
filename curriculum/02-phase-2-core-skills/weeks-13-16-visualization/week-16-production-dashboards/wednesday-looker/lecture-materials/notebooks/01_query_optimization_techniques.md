# Query Optimization Techniques for Production Dashboards

## Week 16 - Wednesday Session - Part 1

### Duration: 20 minutes

---

## What Is Query Optimization?

**Query optimization** is the practice of rewriting SQL to retrieve the same results in less time, using fewer database resources. In a production dashboard context, an unoptimized query can make an executive wait 30 seconds for a chart to load — or worse, return wrong numbers entirely.

### Why Optimization Matters for Looker Studio Dashboards

Think about the journey your data takes every time a user opens your dashboard:

```
User opens dashboard
        ↓
Looker Studio sends query to Supabase (PostgreSQL)
        ↓
PostgreSQL executes query across 99,441+ rows
        ↓
Results travel back to Looker Studio
        ↓
Looker Studio renders charts
        ↓
User sees results
```

Every step takes time. Your SQL query controls the slowest step — the database execution. A poorly written query on the Olist dataset can take 15-30 seconds. A well-written one takes under 2 seconds.

**Connection to Prior Learning:**

In Weeks 4-8 (SQL optimization), you learned:
```sql
-- Week 4: Filter early
WHERE order_status = 'delivered'

-- Week 8: Use CTEs for readability
WITH delivered AS (SELECT ... WHERE ...)

-- Week 11: Aggregation efficiency
GROUP BY before JOIN
```

Today you apply all of those lessons specifically to Looker Studio data sources.

---

## The Production Dashboard Problem: Row Multiplication

Before learning how to optimize, you need to understand the most common production error — one that silently corrupts your revenue figures.

### The Dangerous Join Pattern

**The Olist Schema Relationship:**

```
olist_orders_dataset:         99,441 rows  (1 per order)
olist_order_payments_dataset: 103,886 rows (multiple per order — installments)
olist_order_items_dataset:    112,650 rows (multiple per order — multi-item)
```

When you join all three tables simultaneously, each payment row multiplies against each item row for the same order. An order with 3 items and 2 payment installments produces 6 rows instead of 1.

### Live Demonstration: Before vs After

Run both queries below in your SQL client (VS Code connected to Supabase). Compare the São Paulo revenue figures.

**BEFORE — The Dangerous Query (do not use in production):**

```sql
-- BEFORE: Joining order_items without pre-aggregation inflates revenue
-- This query overstates SP revenue by 28%
SELECT
    c.customer_state,
    COUNT(DISTINCT o.order_id)  AS order_count,
    SUM(p.payment_value)        AS total_revenue,
    AVG(p.payment_value)        AS avg_order_value
FROM olist_sales_data_set.olist_orders_dataset o
JOIN olist_sales_data_set.olist_customers_dataset c
    ON o.customer_id = c.customer_id
JOIN olist_sales_data_set.olist_order_payments_dataset p
    ON o.order_id = p.order_id
JOIN olist_sales_data_set.olist_order_items_dataset oi  -- causes row multiplication
    ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered'
GROUP BY c.customer_state
ORDER BY total_revenue DESC;
```

**BEFORE result for São Paulo:** `total_revenue = $7,404,140` — this number is WRONG.

---

**AFTER — The Optimized Query:**

```sql
-- AFTER: CTEs pre-aggregate before joining — correct revenue figures
WITH delivered_orders AS (
    -- Step 1: Filter early, work with a smaller dataset from the start
    SELECT order_id, customer_id
    FROM olist_sales_data_set.olist_orders_dataset
    WHERE order_status = 'delivered'
),
order_revenue AS (
    -- Step 2: Pre-aggregate payments PER ORDER before joining anything else
    -- This collapses installment rows into one revenue figure per order
    SELECT order_id, SUM(payment_value) AS order_revenue
    FROM olist_sales_data_set.olist_order_payments_dataset
    GROUP BY order_id
),
customer_states AS (
    -- Step 3: Pull only the columns we need from customers
    SELECT customer_id, customer_state
    FROM olist_sales_data_set.olist_customers_dataset
)
SELECT
    cs.customer_state,
    COUNT(DISTINCT d.order_id)               AS order_count,
    ROUND(SUM(r.order_revenue)::numeric, 2)  AS total_revenue,
    ROUND(AVG(r.order_revenue)::numeric, 2)  AS avg_order_value
FROM delivered_orders d
JOIN order_revenue r    ON d.order_id = r.order_id
JOIN customer_states cs ON d.customer_id = cs.customer_id
GROUP BY cs.customer_state
ORDER BY total_revenue DESC;
```

**AFTER result for São Paulo:** `total_revenue = $5,770,360` — this number is CORRECT.

**The difference:** $7,404,140 vs $5,770,360 = **28% inflation** from the unoptimized query.

---

## Reading EXPLAIN Output

PostgreSQL's `EXPLAIN` command shows you the execution plan — exactly what the database will do to answer your query. You do not need to memorize every term, but understanding the key signals helps you diagnose slow dashboards.

### Running EXPLAIN in Supabase

Prefix your query with `EXPLAIN`:

```sql
EXPLAIN
WITH delivered_orders AS (
    SELECT order_id, customer_id
    FROM olist_sales_data_set.olist_orders_dataset
    WHERE order_status = 'delivered'
),
order_revenue AS (
    SELECT order_id, SUM(payment_value) AS order_revenue
    FROM olist_sales_data_set.olist_order_payments_dataset
    GROUP BY order_id
),
customer_states AS (
    SELECT customer_id, customer_state
    FROM olist_sales_data_set.olist_customers_dataset
)
SELECT
    cs.customer_state,
    COUNT(DISTINCT d.order_id)               AS order_count,
    ROUND(SUM(r.order_revenue)::numeric, 2)  AS total_revenue,
    ROUND(AVG(r.order_revenue)::numeric, 2)  AS avg_order_value
FROM delivered_orders d
JOIN order_revenue r    ON d.order_id = r.order_id
JOIN customer_states cs ON d.customer_id = cs.customer_id
GROUP BY cs.customer_state
ORDER BY total_revenue DESC;
```

### Validated EXPLAIN Output

```
Sort  (cost=35629.16..35629.23 rows=27 width=75)
  Sort Key: (round((sum(r.order_revenue))::numeric, 2)) DESC
  ->  GroupAggregate  (cost=34480.27..35628.52 rows=27 width=75)
        Group Key: olist_customers_dataset.customer_state
        ->  Sort  (cost=34480.27..34709.80 rows=91811 width=40)
              ->  Hash Join  (cost=16563.87..25440.22 rows=91811 width=40)
                    Hash Cond: (olist_orders_dataset.order_id = r.order_id)
                    ->  Hash Join  (cost=4518.42..10893.60 rows=96441 width=36)
                          Hash Cond: (olist_orders_dataset.customer_id = olist_customers_dataset.customer_id)
                          ->  Seq Scan on olist_orders_dataset  (cost=0.00..3083.01 rows=96441 width=66)
                                Filter: (order_status = 'delivered'::text)
                          ->  Hash  (cost=2498.41..2498.41 rows=99441 width=36)
                    ->  Hash  (cost=10122.11..10122.11 rows=94667 width=37)
                          ->  Subquery Scan on r
                                ->  HashAggregate  (cost=6605.55..9175.44 rows=94667 width=37)
                                      Group Key: olist_order_payments_dataset.order_id
                                      ->  Seq Scan on olist_order_payments_dataset
```

### How to Read the Plan

| Term | What It Means | Good or Concerning? |
|------|--------------|---------------------|
| `Seq Scan` | Reads every row in the table | Fine for tables <200K rows; concerning for millions |
| `Hash Join` | Builds a hash table from the smaller side, scans larger | Efficient join method — good sign |
| `HashAggregate` | Groups rows (the CTE pre-aggregation happening here) | Expected and efficient |
| `cost=X..Y` | Startup cost .. total cost in planner units | Lower total cost = faster query |
| `rows=N` | Estimated rows at this step | Verify against actual table sizes |
| `Filter: (order_status = 'delivered')` | WHERE clause applied during table scan | Early filtering — good sign |

**Positive signals in our optimized plan:**
- Filter applied inside the Seq Scan (early elimination — fewer rows travel through the join)
- HashAggregate on payments pre-aggregates before the join (correct approach)
- Hash Join is used throughout (efficient for these table sizes)

---

## The Five Optimization Rules for Looker Studio Data Sources

### Rule 1: Filter First, Join Later

**Bad pattern:** Join all tables, then filter.
**Good pattern:** Filter inside a CTE before joining.

```sql
-- Bad: filter happens after all joins complete (processes all 99,441 orders)
SELECT ... FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN payments p ON o.order_id = p.order_id
WHERE o.order_status = 'delivered';  -- too late, all rows already joined

-- Good: filter first in CTE (database processes only 96,478 delivered orders)
WITH delivered AS (
    SELECT order_id, customer_id
    FROM olist_sales_data_set.olist_orders_dataset
    WHERE order_status = 'delivered'           -- filter here, early
)
SELECT ... FROM delivered d
JOIN payments p ON d.order_id = p.order_id;
```

### Rule 2: Pre-Aggregate on the Many Side Before Joining

This is the most important rule for Olist data. Any 1:many relationship (one order, many payments; one order, many items) must be aggregated on the "many" side before the join.

```sql
-- Wrong: join payments directly, SUM after (inflates via row multiplication)
SELECT o.order_id, SUM(p.payment_value)
FROM orders o
JOIN payments p ON o.order_id = p.order_id
JOIN order_items oi ON o.order_id = oi.order_id  -- this causes the problem
GROUP BY o.order_id;

-- Correct: collapse payments first, then join
WITH payments_per_order AS (
    SELECT order_id, SUM(payment_value) AS order_revenue
    FROM olist_sales_data_set.olist_order_payments_dataset
    GROUP BY order_id
)
SELECT o.order_id, p.order_revenue
FROM orders o
JOIN payments_per_order p ON o.order_id = p.order_id;
```

### Rule 3: Select Only the Columns You Need

Looker Studio transfers all columns from your data source. Unnecessary columns waste network bandwidth and slow the connection.

```sql
-- Bad: SELECT * transfers everything (including 30+ columns you won't use)
SELECT * FROM olist_sales_data_set.olist_orders_dataset;

-- Good: select only the columns your dashboard needs
SELECT
    order_id,
    customer_id,
    order_status,
    order_purchase_timestamp,
    order_delivered_customer_date
FROM olist_sales_data_set.olist_orders_dataset
WHERE order_status = 'delivered';
```

### Rule 4: Use COUNT(DISTINCT) Carefully

`COUNT(DISTINCT)` is expensive — it has to track every unique value. Use it only where deduplication is genuinely needed.

```sql
-- Use DISTINCT when counting customers (to avoid counting same customer twice)
COUNT(DISTINCT customer_unique_id)  -- correct: deduplicated customer count

-- Do NOT use DISTINCT when counting orders (each order_id is already unique)
COUNT(order_id)                     -- correct: no DISTINCT needed here
COUNT(DISTINCT order_id)            -- wasteful: same result, slower
```

### Rule 5: Use LIMIT During Development, Remove for Production

When building and testing queries in VS Code, add `LIMIT 1000` to get fast feedback. Remove it before connecting to Looker Studio.

```sql
-- Development mode (fast, for testing query structure)
SELECT customer_state, SUM(payment_value)
FROM ...
GROUP BY customer_state
LIMIT 100;

-- Production mode (full dataset for Looker Studio)
SELECT customer_state, SUM(payment_value)
FROM ...
GROUP BY customer_state;
```

---

## Connection to Prior Learning

### Week 4 (SQL Aggregations) — GROUP BY Efficiency

```sql
-- Week 4 lesson: GROUP BY reduces rows before returning results
-- Week 16 application: always GROUP BY inside CTEs before joining
WITH monthly_sales AS (
    SELECT
        TO_CHAR(order_purchase_timestamp, 'YYYY-MM') AS year_month,
        SUM(payment_value) AS monthly_revenue
    FROM olist_sales_data_set.olist_order_payments_dataset
    GROUP BY year_month                              -- aggregate here, inside CTE
)
SELECT year_month, monthly_revenue FROM monthly_sales;
```

### Week 8 (CTEs) — Readable Optimization

```sql
-- Week 8: CTEs for readable queries
-- Week 16: CTEs as an optimization tool — filter and aggregate in each CTE step
-- The two goals align: readable code is often also well-optimized code
```

### Week 11 (SQL Window Functions) — Pre-Calculate for Looker Studio

You learned LAG() in Week 11 for month-over-month calculations:

```sql
-- Week 11 SQL:
LAG(revenue) OVER (ORDER BY year_month) AS prev_month_revenue
```

Looker Studio does not support LAG/LEAD in calculated fields. You must pre-calculate in SQL and expose the column to Looker Studio — exactly the technique you learned in Week 11.

---

## Practical Exercise: Diagnose an Inflated Revenue Report (10 minutes)

**Scenario:** A colleague built a dashboard showing total revenue of $25.4M for the Olist dataset. You know from the validation report that delivered order revenue is approximately $16-19M. Something is wrong.

**Task:**

1. Run the "BEFORE" query above (the one that joins order_items without pre-aggregation).
2. Run the "AFTER" query (the optimized CTE version).
3. Record the total revenue difference.
4. Identify which table join caused the inflation.
5. Confirm the correct revenue figure for São Paulo state.

**Expected Findings:**
- BEFORE total (all states summed): inflated by approximately 28%
- AFTER total: matches the validated figure from the validation report
- Root cause: joining `olist_order_items_dataset` without pre-aggregating payments first
- SP correct revenue: $5,770,360

**Self-check:** If your AFTER query for SP shows approximately $5.77M, you have correctly applied the optimization.

---

## Common Issues and Solutions

| Issue | Symptom | Solution |
|-------|---------|---------|
| Revenue inflated by ~28% | SP shows $7.4M instead of $5.77M | Pre-aggregate payments in CTE before joining order_items |
| Query times out in Looker Studio | Dashboard shows "Data Loading" indefinitely | Add WHERE filter inside CTE, remove LIMIT 0 in production |
| Duplicate customer rows | Customer count higher than expected | Switch from `customer_id` to `customer_unique_id` |
| NULL delivery dates in metrics | AVG delivery days is NULL or very high | Add `WHERE order_delivered_customer_date IS NOT NULL` |
| ROUND() error on PostgreSQL | "function round(double precision, integer) does not exist" | Cast to numeric first: `ROUND(value::numeric, 2)` |

---

## Key Takeaways

### What You Learned
1. ✅ Row multiplication is the most dangerous silent error in Olist queries — a 28% revenue inflation
2. ✅ Pre-aggregate on the "many" side of any 1:many join before joining other tables
3. ✅ Filter inside CTEs (early) rather than after all joins complete
4. ✅ EXPLAIN output reveals what PostgreSQL is doing and where inefficiencies exist
5. ✅ SELECT only the columns your dashboard actually uses
6. ✅ LAG/LEAD must be pre-calculated in SQL because Looker Studio does not support them

### What's Next
In the next session, we apply these optimization techniques to build the five pre-aggregated data source queries that will power the production executive dashboard.

### Skills Building Progression

```
Week 16 Part 1: Query Optimization Techniques (Now)
         ↓
Week 16 Part 2: Pre-Aggregation Strategies for Looker Studio
         ↓
Week 16 Part 3: Data Quality Validation
         ↓
Week 16 Part 4: Data Freshness Monitoring
```

---

## Quick Reference Card

### The Pre-Aggregation Pattern

```sql
WITH payment_totals AS (
    SELECT order_id, SUM(payment_value) AS order_revenue
    FROM olist_sales_data_set.olist_order_payments_dataset
    GROUP BY order_id                          -- aggregate BEFORE joining
),
filtered_orders AS (
    SELECT order_id, customer_id
    FROM olist_sales_data_set.olist_orders_dataset
    WHERE order_status = 'delivered'           -- filter EARLY
)
SELECT
    o.order_id,
    p.order_revenue
FROM filtered_orders o
JOIN payment_totals p ON o.order_id = p.order_id;
-- Join AFTER both CTEs have done their work
```

### EXPLAIN Signals Cheat Sheet

| Signal | Meaning |
|--------|---------|
| `Seq Scan + Filter` | Early filtering — good |
| `Hash Join` | Efficient join — good |
| `HashAggregate` | Grouping — expected |
| High `cost=X..Y` on a scan | Potentially slow table scan |
| `rows=N` much higher than expected | May indicate missing filter |

---

## Questions to Test Your Understanding

1. Why does joining `olist_order_items_dataset` before aggregating payments inflate revenue?
2. What SQL keyword lets you see the execution plan PostgreSQL will use for your query?
3. What is the correct Supabase syntax for rounding a double precision value to 2 decimal places?
4. Why must LAG() and NTILE() be pre-calculated in SQL rather than as Looker Studio calculated fields?
5. An executive reports that monthly revenue for August 2018 looks too high in the dashboard. What is your first debugging step?

**Answers at the end of lecture notes**

---

## Additional Resources

- **Looker Studio Help:** [Using custom SQL queries](https://support.google.com/looker-studio/answer/9263475)
- **PostgreSQL Docs:** [EXPLAIN command reference](https://www.postgresql.org/docs/current/sql-explain.html)
- **Week 16 Validation Report:** Full query results and optimization examples
- **Performance Optimization Guide:** See resources/ folder

---

## Answers to Questions

1. **Row multiplication:** An order with 3 items produces 3 rows in `order_items`. When you join this to payments and then SUM payment_value, the payment is counted once per item row — inflating revenue by the number of items per order.
2. **EXPLAIN keyword:** Prefix your SELECT with `EXPLAIN` to see the execution plan. Add `EXPLAIN ANALYZE` to run it and see actual timings.
3. **ROUND() syntax:** `ROUND(value::numeric, 2)` — the `::numeric` cast is required in PostgreSQL because ROUND only accepts numeric (not double precision) as the second argument.
4. **LAG/LEAD limitation:** Looker Studio calculated fields only support single-row expressions, not window functions that look across rows. Pre-calculate in SQL and expose the result column to Looker Studio.
5. **Debugging step:** First, run the underlying SQL query directly in VS Code against Supabase and compare the figure. If the SQL result is also high, the issue is in the query (likely row multiplication). If the SQL result is correct but Looker shows wrong, the data source may be cached with stale data.

---

**Next Lecture:** 02_pre_aggregation_strategies.md
