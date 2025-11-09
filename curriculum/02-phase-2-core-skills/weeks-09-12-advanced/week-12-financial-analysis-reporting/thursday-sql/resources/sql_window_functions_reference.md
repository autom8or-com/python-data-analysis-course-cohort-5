# SQL Window Functions Reference for Advanced Analytics

## Overview
Window functions perform calculations across a set of table rows that are somehow related to the current row. They are essential for advanced analytics and business intelligence.

## Window Function Syntax
```sql
window_function(expression) OVER (
    [PARTITION BY partition_expression]
    [ORDER BY sort_expression]
    [frame_clause]
)
```

## Categories of Window Functions

### 1. Aggregate Window Functions
Perform calculations like aggregate functions but don't collapse rows.

```sql
-- Running total
SUM(payment_value) OVER (ORDER BY order_date) as running_total

-- Moving average
AVG(payment_value) OVER (
    ORDER BY order_date
    ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
) as moving_avg

-- Count within partition
COUNT(*) OVER (PARTITION BY customer_state) as state_count
```

### 2. Ranking Functions
Return a ranking value for each row within a partition.

```sql
-- ROW_NUMBER: Unique sequential numbers
ROW_NUMBER() OVER (ORDER BY revenue DESC) as rank_num

-- RANK: Same rank for ties, gaps in numbering
RANK() OVER (PARTITION BY category ORDER BY sales DESC) as sales_rank

-- DENSE_RANK: Same rank for ties, no gaps
DENSE_RANK() OVER (PARTITION BY region ORDER BY profit DESC) as profit_rank

-- NTILE: Divide rows into n groups
NTILE(4) OVER (ORDER BY customer_value DESC) as value_quartile
```

### 3. Value Functions
Return a value from another row in the window frame.

```sql
-- LAG: Value from previous row
LAG(payment_value, 1) OVER (ORDER BY order_date) as prev_payment

-- LEAD: Value from next row
LEAD(payment_value, 1) OVER (ORDER BY order_date) as next_payment

-- FIRST_VALUE: First value in window frame
FIRST_VALUE(payment_value) OVER (
    PARTITION BY customer_id
    ORDER BY order_date
    ROWS UNBOUNDED PRECEDING
) as first_payment

-- LAST_VALUE: Last value in window frame
LAST_VALUE(payment_value) OVER (
    PARTITION BY customer_id
    ORDER BY order_date
    ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
) as last_payment
```

### 4. Statistical Functions
Calculate statistical measures across windows.

```sql
-- Percentile rank
PERCENTILE_RANK() OVER (ORDER BY revenue) as percentile_rank

-- CUME_DIST: Cumulative distribution
CUME_DIST() OVER (ORDER BY order_value) as cumulative_dist

-- NTH_VALUE: Nth value from window
NTH_VALUE(payment_value, 3) OVER (
    ORDER BY order_date
    ROWS UNBOUNDED PRECEDING
) as third_payment
```

## Frame Clauses
Define the window frame for calculation.

### Frame Types
```sql
-- ROWS: Physical rows
ROWS BETWEEN 3 PRECEDING AND CURRENT ROW
ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
ROWS CURRENT ROW

-- RANGE: Logical range based on values
RANGE BETWEEN INTERVAL '30' DAY PRECEDING AND CURRENT ROW
RANGE UNBOUNDED PRECEDING
```

### Frame Boundaries
- `UNBOUNDED PRECEDING`: First row of partition
- `n PRECEDING`: n rows before current row
- `CURRENT ROW`: Current row
- `n FOLLOWING`: n rows after current row
- `UNBOUNDED FOLLOWING`: Last row of partition

## Practical Examples

### Customer Analysis
```sql
-- Customer lifetime value with ranking
SELECT
    customer_id,
    order_date,
    payment_value,
    SUM(payment_value) OVER (PARTITION BY customer_id) as customer_lifetime_value,
    ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY order_date) as order_number,
    AVG(payment_value) OVER (PARTITION BY customer_id) as avg_order_value,
    FIRST_VALUE(payment_value) OVER (PARTITION BY customer_id ORDER BY order_date) as first_order_value
FROM orders o
JOIN payments p ON o.order_id = p.order_id;
```

### Time Series Analysis
```sql
-- Monthly revenue trends with growth rates
SELECT
    DATE_TRUNC('month', order_date) as month,
    SUM(payment_value) as monthly_revenue,
    LAG(SUM(payment_value), 1) OVER (ORDER BY DATE_TRUNC('month', order_date)) as prev_month_revenue,
    SUM(payment_value) / LAG(SUM(payment_value), 1) OVER (ORDER BY DATE_TRUNC('month', order_date)) - 1 as growth_rate,
    AVG(SUM(payment_value)) OVER (
        ORDER BY DATE_TRUNC('month', order_date)
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ) as three_month_avg
FROM orders o
JOIN payments p ON o.order_id = p.order_id
GROUP BY DATE_TRUNC('month', order_date)
ORDER BY month;
```

### Performance Analysis
```sql
-- Product performance with percentiles
SELECT
    product_id,
    category,
    total_revenue,
    RANK() OVER (PARTITION BY category ORDER BY total_revenue DESC) as category_rank,
    PERCENTILE_RANK() OVER (ORDER BY total_revenue) as overall_percentile,
    NTILE(10) OVER (ORDER BY total_revenue) as revenue_decile,
    CASE
        WHEN PERCENTILE_RANK() OVER (ORDER BY total_revenue) >= 0.9 THEN 'Top 10%'
        WHEN PERCENTILE_RANK() OVER (ORDER BY total_revenue) >= 0.75 THEN 'Top 25%'
        ELSE 'Bottom 75%'
    END as performance_tier
FROM (
    SELECT
        p.product_id,
        pc.product_category_name as category,
        SUM(oi.price * oi.quantity) as total_revenue
    FROM order_items oi
    JOIN products p ON oi.product_id = p.product_id
    GROUP BY p.product_id, pc.product_category_name
) product_stats;
```

### Cohort Analysis
```sql
-- Customer cohort retention
WITH customer_cohorts AS (
    SELECT
        c.customer_id,
        DATE_TRUNC('month', MIN(o.order_date)) as cohort_month,
        DATE_TRUNC('month', o.order_date) as order_month,
        EXTRACT(YEAR FROM AGE(DATE_TRUNC('month', o.order_date), DATE_TRUNC('month', MIN(o.order_date)))) * 12 +
        EXTRACT(MONTH FROM AGE(DATE_TRUNC('month', o.order_date), DATE_TRUNC('month', MIN(o.order_date)))) as months_since_first
    FROM customers c
    JOIN orders o ON c.customer_id = o.customer_id
    GROUP BY c.customer_id, DATE_TRUNC('month', o.order_date)
),
cohort_metrics AS (
    SELECT
        cohort_month,
        months_since_first,
        COUNT(DISTINCT customer_id) as active_customers,
        FIRST_VALUE(COUNT(DISTINCT customer_id)) OVER (PARTITION BY cohort_month ORDER BY months_since_first) as cohort_size
    FROM customer_cohorts
    GROUP BY cohort_month, months_since_first
)
SELECT
    TO_CHAR(cohort_month, 'YYYY-MM') as cohort,
    months_since_first,
    cohort_size,
    active_customers,
    ROUND((active_customers::DECIMAL / cohort_size) * 100, 2) as retention_rate
FROM cohort_metrics
ORDER BY cohort, months_since_first;
```

## Performance Optimization

### Indexing Strategies
```sql
-- Create indexes for window function performance
CREATE INDEX idx_orders_customer_date ON orders(customer_id, order_date);
CREATE INDEX idx_payments_order_value ON order_payments(order_id, payment_value);
CREATE INDEX idx_customers_state ON customers(customer_state);
```

### Query Optimization Tips
1. **Filter Early**: Apply WHERE clauses before window functions
2. **Partition Effectively**: Choose meaningful partition keys
3. **Frame Efficiency**: Use appropriate frame clauses
4. **Avoid Over-partitioning**: Too many small partitions are inefficient

```sql
-- Less efficient - applies window function to all rows then filters
SELECT * FROM (
    SELECT
        *, ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY order_date) as rn
    FROM orders
) ranked_orders
WHERE rn <= 5;

-- More efficient - filters before window function
SELECT
    customer_id,
    order_date,
    ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY order_date) as rn
FROM orders
WHERE customer_id IN (SELECT customer_id FROM orders GROUP BY customer_id HAVING COUNT(*) > 10);
```

## Advanced Patterns

### Gap Analysis
```sql
-- Detect gaps in customer purchase patterns
WITH customer_orders AS (
    SELECT
        customer_id,
        order_date,
        ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY order_date) as rn,
        order_date - ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY order_date) * INTERVAL '1 day' as grp
    FROM orders
)
SELECT
    customer_id,
    MIN(order_date) as gap_start,
    MAX(order_date) as gap_end,
    COUNT(*) as orders_in_gap
FROM customer_orders
GROUP BY customer_id, grp
ORDER BY customer_id, gap_start;
```

### Session Analysis
```sql
-- Customer session analysis with time windows
SELECT
    customer_id,
    order_date,
    CASE
        WHEN order_date <= LAG(order_date, 1) OVER (PARTITION BY customer_id ORDER BY order_date) + INTERVAL '24 hour'
        THEN 'Same Session'
        ELSE 'New Session'
    END as session_type,
    SUM(CASE WHEN session_type = 'New Session' THEN 1 ELSE 0 END) OVER (
        PARTITION BY customer_id ORDER BY order_date
    ) as session_number
FROM (
    SELECT
        customer_id,
        order_date,
        LAG(order_date, 1) OVER (PARTITION BY customer_id ORDER BY order_date) as prev_order_date
    FROM orders
) order_analysis;
```

## PostgreSQL Specific Features

### Statistical Aggregate Functions
```sql
-- Correlation
SELECT
    CORR(payment_value, freight_value) as correlation_coefficient
FROM order_items;

-- Regression functions
SELECT
    REGR_SLOPE(payment_value, product_weight_g) as slope,
    REGR_INTERCEPT(payment_value, product_weight_g) as intercept,
    REGR_R2(payment_value, product_weight_g) as r_squared
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id;
```

### FILTER Clause with Aggregates
```sql
-- Conditional aggregation with FILTER
SELECT
    customer_state,
    COUNT(*) as total_orders,
    COUNT(*) FILTER (WHERE payment_type = 'credit_card') as credit_card_orders,
    AVG(payment_value) as avg_order_value,
    AVG(payment_value) FILTER (WHERE payment_type = 'credit_card') as avg_credit_card_value
FROM orders o
JOIN payments p ON o.order_id = p.order_id
JOIN customers c ON o.customer_id = c.customer_id
GROUP BY customer_state;
```

## Common Use Cases in Financial Analysis

### Year-over-Year Comparison
```sql
SELECT
    DATE_TRUNC('month', order_date) as month,
    SUM(payment_value) as revenue,
    LAG(SUM(payment_value), 12) OVER (ORDER BY DATE_TRUNC('month', order_date)) as same_month_last_year,
    SUM(payment_value) - LAG(SUM(payment_value), 12) OVER (ORDER BY DATE_TRUNC('month', order_date)) as yoy_change
FROM orders o
JOIN payments p ON o.order_id = p.order_id
GROUP BY DATE_TRUNC('month', order_date)
ORDER BY month;
```

### Moving Averages and Trends
```sql
SELECT
    DATE_TRUNC('week', order_date) as week,
    SUM(payment_value) as weekly_revenue,
    AVG(SUM(payment_value)) OVER (
        ORDER BY DATE_TRUNC('week', order_date)
        ROWS BETWEEN 3 PRECEDING AND CURRENT ROW
    ) as four_week_avg,
    SUM(payment_value) - AVG(SUM(payment_value)) OVER (
        ORDER BY DATE_TRUNC('week', order_date)
        ROWS BETWEEN 3 PRECEDING AND CURRENT ROW
    ) as deviation_from_avg
FROM orders o
JOIN payments p ON o.order_id = p.order_id
GROUP BY DATE_TRUNC('week', order_date)
ORDER BY week;
```

## Best Practices

1. **Use Appropriate Partitioning**: Choose partition keys that make business sense
2. **Consider Performance**: Window functions can be resource-intensive
3. **Test with Subsets**: Validate logic with small datasets first
4. **Document Complex Logic**: Add comments explaining the purpose
5. **Handle NULL Values**: Consider NULL handling in your calculations
6. **Frame Awareness**: Understand how window frames affect results

---
*This reference supports the Week 12 curriculum on SQL Advanced Analytics Functions.*