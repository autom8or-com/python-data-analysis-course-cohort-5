# Common CTE Patterns for Customer Analytics

## Overview
Common Table Expressions (CTEs) are powerful tools for building readable, modular SQL queries. This guide covers essential CTE patterns specifically for customer lifetime value analysis and business analytics.

---

## Pattern 1: Sequential Pipeline (Multi-Stage Processing)

### Use Case
Breaking down complex calculations into logical steps - ideal for CLV calculations that require multiple transformations.

### Template
```sql
WITH
-- Stage 1: Raw data extraction
raw_data AS (
    SELECT column1, column2, aggregate_function()
    FROM table1
    JOIN table2 ON...
    GROUP BY column1, column2
),

-- Stage 2: Calculations on raw data
calculated_metrics AS (
    SELECT
        *,
        column1 / column2 AS derived_metric
    FROM raw_data
),

-- Stage 3: Final classification
final_results AS (
    SELECT
        *,
        CASE
            WHEN derived_metric > threshold THEN 'Category A'
            ELSE 'Category B'
        END AS classification
    FROM calculated_metrics
)

-- Final query
SELECT * FROM final_results
WHERE classification = 'Category A';
```

### Business Example
```sql
WITH
customer_orders AS (
    SELECT customer_id, COUNT(*) as order_count, SUM(total) as total_spent
    FROM orders
    GROUP BY customer_id
),
customer_scores AS (
    SELECT *,
        total_spent / order_count AS avg_order_value
    FROM customer_orders
),
customer_segments AS (
    SELECT *,
        CASE
            WHEN avg_order_value > 100 THEN 'Premium'
            WHEN avg_order_value > 50 THEN 'Standard'
            ELSE 'Budget'
        END AS segment
    FROM customer_scores
)
SELECT * FROM customer_segments;
```

---

## Pattern 2: Recursive CTE (Hierarchical Data)

### Use Case
Processing hierarchical relationships like referral chains, organizational structures, or customer network effects.

### Template
```sql
WITH RECURSIVE hierarchy AS (
    -- Base case: Starting point
    SELECT id, parent_id, name, 1 AS level
    FROM table
    WHERE parent_id IS NULL

    UNION ALL

    -- Recursive case: Build upon previous results
    SELECT t.id, t.parent_id, t.name, h.level + 1
    FROM table t
    INNER JOIN hierarchy h ON t.parent_id = h.id
)
SELECT * FROM hierarchy;
```

### Business Example: Referral Chain Analysis
```sql
WITH RECURSIVE referral_chain AS (
    -- Base: Customers who joined without referral
    SELECT
        customer_id,
        referrer_id,
        customer_name,
        1 AS generation,
        customer_id::TEXT AS referral_path
    FROM customers
    WHERE referrer_id IS NULL

    UNION ALL

    -- Recursive: Customers referred by previous generation
    SELECT
        c.customer_id,
        c.referrer_id,
        c.customer_name,
        rc.generation + 1,
        rc.referral_path || ' -> ' || c.customer_id::TEXT
    FROM customers c
    INNER JOIN referral_chain rc ON c.referrer_id = rc.customer_id
    WHERE rc.generation < 5  -- Limit recursion depth
)
SELECT * FROM referral_chain
ORDER BY generation, customer_id;
```

---

## Pattern 3: Parallel CTEs (Independent Calculations)

### Use Case
Computing multiple independent metrics that will be combined later - perfect for dashboard queries.

### Template
```sql
WITH
metric_a AS (
    SELECT key, SUM(value_a) as total_a
    FROM table1
    GROUP BY key
),
metric_b AS (
    SELECT key, AVG(value_b) as avg_b
    FROM table2
    GROUP BY key
),
metric_c AS (
    SELECT key, COUNT(*) as count_c
    FROM table3
    GROUP BY key
)

-- Combine all metrics
SELECT
    COALESCE(a.key, b.key, c.key) as key,
    a.total_a,
    b.avg_b,
    c.count_c
FROM metric_a a
FULL OUTER JOIN metric_b b ON a.key = b.key
FULL OUTER JOIN metric_c c ON a.key = c.key;
```

### Business Example: Customer 360 View
```sql
WITH
purchase_metrics AS (
    SELECT customer_id,
        COUNT(*) as total_orders,
        SUM(order_total) as lifetime_value
    FROM orders
    WHERE status = 'completed'
    GROUP BY customer_id
),
engagement_metrics AS (
    SELECT customer_id,
        COUNT(*) as email_opens,
        MAX(event_date) as last_engagement
    FROM email_events
    GROUP BY customer_id
),
support_metrics AS (
    SELECT customer_id,
        COUNT(*) as support_tickets,
        AVG(satisfaction_score) as avg_satisfaction
    FROM support_tickets
    GROUP BY customer_id
)

SELECT
    c.customer_id,
    c.customer_name,
    p.total_orders,
    p.lifetime_value,
    e.email_opens,
    e.last_engagement,
    s.support_tickets,
    s.avg_satisfaction
FROM customers c
LEFT JOIN purchase_metrics p ON c.customer_id = p.customer_id
LEFT JOIN engagement_metrics e ON c.customer_id = e.customer_id
LEFT JOIN support_metrics s ON c.customer_id = s.customer_id;
```

---

## Pattern 4: Data Quality CTE (Filtering & Cleaning)

### Use Case
Establishing clean baseline data before complex analysis - essential for accurate CLV calculations.

### Template
```sql
WITH
clean_data AS (
    SELECT *
    FROM source_table
    WHERE
        -- Remove invalid records
        critical_field IS NOT NULL
        AND numeric_field > 0
        AND date_field BETWEEN start_date AND end_date
        -- Remove duplicates
        AND id IN (
            SELECT MIN(id)
            FROM source_table
            GROUP BY unique_key
        )
),
validated_data AS (
    SELECT *,
        -- Add validation flags
        CASE WHEN condition THEN 'VALID' ELSE 'INVALID' END as validation_status
    FROM clean_data
)

SELECT * FROM validated_data
WHERE validation_status = 'VALID';
```

### Business Example
```sql
WITH
clean_orders AS (
    SELECT *
    FROM orders
    WHERE
        order_status IN ('delivered', 'completed')
        AND order_total > 0
        AND order_date >= '2020-01-01'
        -- Remove test orders
        AND customer_email NOT LIKE '%@test.com'
),
deduplicated_orders AS (
    SELECT
        order_id,
        customer_id,
        order_date,
        order_total,
        ROW_NUMBER() OVER (PARTITION BY order_id ORDER BY updated_at DESC) as rn
    FROM clean_orders
)

SELECT
    order_id,
    customer_id,
    order_date,
    order_total
FROM deduplicated_orders
WHERE rn = 1;  -- Keep only the latest version of each order
```

---

## Pattern 5: Cohort Analysis CTE

### Use Case
Tracking customer behavior over time by acquisition cohort - critical for CLV prediction.

### Template
```sql
WITH
customer_cohorts AS (
    SELECT
        customer_id,
        DATE_TRUNC('month', first_purchase_date) as cohort_month
    FROM (
        SELECT
            customer_id,
            MIN(order_date) as first_purchase_date
        FROM orders
        GROUP BY customer_id
    ) first_orders
),
monthly_activity AS (
    SELECT
        c.cohort_month,
        DATE_TRUNC('month', o.order_date) as activity_month,
        COUNT(DISTINCT o.customer_id) as active_customers,
        SUM(o.order_total) as cohort_revenue
    FROM customer_cohorts c
    JOIN orders o ON c.customer_id = o.customer_id
    GROUP BY c.cohort_month, DATE_TRUNC('month', o.order_date)
)

SELECT
    cohort_month,
    activity_month,
    EXTRACT(MONTH FROM AGE(activity_month, cohort_month)) as months_since_acquisition,
    active_customers,
    cohort_revenue,
    cohort_revenue / active_customers as revenue_per_customer
FROM monthly_activity
ORDER BY cohort_month, activity_month;
```

---

## Pattern 6: Window Function CTE (Ranking & Running Totals)

### Use Case
Adding analytical calculations like running totals, percentile ranks, and moving averages to CLV analysis.

### Template
```sql
WITH
base_metrics AS (
    SELECT
        customer_id,
        metric_value,
        metric_date
    FROM metrics_table
),
ranked_metrics AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY metric_date DESC) as recency_rank,
        RANK() OVER (ORDER BY metric_value DESC) as value_rank,
        PERCENT_RANK() OVER (ORDER BY metric_value) as percentile_rank,
        SUM(metric_value) OVER (PARTITION BY customer_id ORDER BY metric_date) as running_total,
        AVG(metric_value) OVER (PARTITION BY customer_id ORDER BY metric_date ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) as moving_avg_3mo
    FROM base_metrics
)

SELECT * FROM ranked_metrics;
```

### Business Example: Customer Spending Trends
```sql
WITH
monthly_spending AS (
    SELECT
        customer_id,
        DATE_TRUNC('month', order_date) as month,
        SUM(order_total) as monthly_total
    FROM orders
    WHERE order_status = 'delivered'
    GROUP BY customer_id, DATE_TRUNC('month', order_date)
),
spending_analysis AS (
    SELECT
        customer_id,
        month,
        monthly_total,

        -- Rank this month within customer's history
        DENSE_RANK() OVER (PARTITION BY customer_id ORDER BY monthly_total DESC) as spend_rank,

        -- Running total of customer spend
        SUM(monthly_total) OVER (PARTITION BY customer_id ORDER BY month) as cumulative_spend,

        -- 3-month moving average
        AVG(monthly_total) OVER (PARTITION BY customer_id ORDER BY month ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) as avg_3mo,

        -- Compare to previous month
        LAG(monthly_total) OVER (PARTITION BY customer_id ORDER BY month) as prev_month_total,

        -- Month-over-month growth
        ((monthly_total - LAG(monthly_total) OVER (PARTITION BY customer_id ORDER BY month))
         / NULLIF(LAG(monthly_total) OVER (PARTITION BY customer_id ORDER BY month), 0) * 100) as mom_growth_pct

    FROM monthly_spending
)

SELECT * FROM spending_analysis
ORDER BY customer_id, month DESC;
```

---

## Pattern 7: Self-Join CTE (Comparing Records)

### Use Case
Comparing customer behavior across time periods or finding patterns in repeat purchases.

### Template
```sql
WITH
customer_purchases AS (
    SELECT
        customer_id,
        order_id,
        order_date,
        product_category
    FROM orders
)

SELECT
    cp1.customer_id,
    cp1.order_id as first_order,
    cp2.order_id as second_order,
    cp1.product_category as first_category,
    cp2.product_category as second_category,
    cp2.order_date - cp1.order_date as days_between_orders
FROM customer_purchases cp1
JOIN customer_purchases cp2
    ON cp1.customer_id = cp2.customer_id
    AND cp1.order_date < cp2.order_date
WHERE cp2.order_date - cp1.order_date <= 90;  -- Orders within 90 days
```

---

## Best Practices

### 1. Naming Conventions
- Use descriptive CTE names that indicate purpose: `customer_rfm_raw`, `monthly_cohorts`, `clean_orders`
- Use consistent naming patterns across your organization
- Avoid generic names like `cte1`, `temp`, `data`

### 2. CTE Organization
- Order CTEs logically (data cleaning → calculations → aggregations → final formatting)
- Add comments explaining each CTE's purpose
- Keep each CTE focused on a single responsibility

### 3. Performance Considerations
- CTEs are evaluated once per query (in most databases)
- For very large datasets, consider materialized CTEs or temp tables
- Use EXPLAIN ANALYZE to check execution plans
- Index columns used in CTE joins and WHERE clauses

### 4. Readability
```sql
-- Good: Clear pipeline with documented stages
WITH
-- Stage 1: Extract base customer data
customer_base AS (...),

-- Stage 2: Calculate RFM scores
customer_scores AS (...),

-- Stage 3: Assign segments
customer_segments AS (...)

SELECT * FROM customer_segments;

-- Bad: Cryptic names and no documentation
WITH a AS (...), b AS (...), c AS (...)
SELECT * FROM c;
```

### 5. Error Handling
- Validate data quality in early CTEs
- Use COALESCE() to handle NULLs
- Add data validation flags when needed
- Document assumptions in comments

---

## Nigerian Business Context Examples

### Example: Lagos Market Analysis
```sql
WITH
lagos_customers AS (
    SELECT customer_id, customer_state
    FROM customers
    WHERE customer_state = 'LA'  -- Lagos State
),
customer_spending AS (
    SELECT
        lc.customer_id,
        COUNT(DISTINCT o.order_id) as total_orders,
        SUM(o.order_total) as lifetime_value
    FROM lagos_customers lc
    JOIN orders o ON lc.customer_id = o.customer_id
    WHERE o.order_status = 'delivered'
    GROUP BY lc.customer_id
),
spending_segments AS (
    SELECT
        *,
        CASE
            WHEN lifetime_value >= 100000 THEN 'Premium (₦100k+)'  -- Nigerian Naira
            WHEN lifetime_value >= 50000 THEN 'Standard (₦50k-100k)'
            ELSE 'Basic (<₦50k)'
        END AS customer_segment
    FROM customer_spending
)

SELECT
    customer_segment,
    COUNT(*) as customers,
    ROUND(AVG(lifetime_value), 2) as avg_ltv,
    ROUND(SUM(lifetime_value), 2) as total_revenue
FROM spending_segments
GROUP BY customer_segment
ORDER BY total_revenue DESC;
```

---

## Quick Reference Table

| Pattern | Use Case | Complexity | Performance Impact |
|---------|----------|------------|-------------------|
| Sequential Pipeline | Multi-step CLV calculations | Medium | Low |
| Recursive CTE | Referral chains, hierarchies | High | Medium-High |
| Parallel CTEs | Dashboard metrics | Medium | Low |
| Data Quality CTE | Data cleaning baseline | Low | Low |
| Cohort Analysis | Customer lifecycle tracking | Medium | Medium |
| Window Function CTE | Rankings, running totals | Medium | Medium |
| Self-Join CTE | Pattern matching | Medium | Medium-High |

---

## Practice Exercise

Try converting this nested subquery into a readable CTE pipeline:

```sql
-- Complex nested query
SELECT *
FROM (
    SELECT customer_id,
        SUM(total) as ltv,
        RANK() OVER (ORDER BY SUM(total) DESC) as rank
    FROM (
        SELECT o.customer_id, o.order_total as total
        FROM orders o
        WHERE o.order_status = 'delivered'
          AND o.order_date >= '2023-01-01'
    ) clean_orders
    GROUP BY customer_id
) ranked_customers
WHERE rank <= 100;
```

Solution in the exercises folder!

---

## Additional Resources

- PostgreSQL CTE Documentation: https://www.postgresql.org/docs/current/queries-with.html
- SQL CTE Performance Guide: Week 9 `performance-tips.md`
- Advanced Window Functions: Week 10 materials

---

Last Updated: October 2025
Course: PORA Academy Cohort 5 - Week 9
