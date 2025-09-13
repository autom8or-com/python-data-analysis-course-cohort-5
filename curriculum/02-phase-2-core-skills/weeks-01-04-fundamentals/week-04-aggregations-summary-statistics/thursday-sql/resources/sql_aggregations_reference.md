# SQL Aggregations & Summary Statistics - Reference Guide

## Week 4 SQL Reference Materials
**Thursday SQL Class - September 4, 2025**

---

## Quick Reference: Excel to SQL Translation

| Excel Function | Purpose | SQL Equivalent | Example |
|----------------|---------|----------------|---------|
| `SUM()` | Sum values | `SUM(column)` | `SELECT SUM(price) FROM orders` |
| `COUNT()` | Count rows | `COUNT(*)` or `COUNT(column)` | `SELECT COUNT(*) FROM orders` |
| `AVERAGE()` | Mean value | `AVG(column)` | `SELECT AVG(price) FROM orders` |
| `MIN()` | Minimum value | `MIN(column)` | `SELECT MIN(price) FROM orders` |
| `MAX()` | Maximum value | `MAX(column)` | `SELECT MAX(price) FROM orders` |
| `SUMIF()` | Conditional sum | `SUM() with WHERE` | `SELECT SUM(price) WHERE state = 'SP'` |
| `COUNTIF()` | Conditional count | `COUNT() with WHERE` | `SELECT COUNT(*) WHERE rating >= 4` |
| `AVERAGEIF()` | Conditional average | `AVG() with WHERE` | `SELECT AVG(price) WHERE category = 'electronics'` |
| Pivot Table | Cross-tabulation | `GROUP BY with CASE` | `SELECT state, SUM(CASE WHEN category = 'electronics' THEN price END)` |

---

## Core Aggregate Functions

### Basic Aggregate Functions
```sql
-- COUNT: Number of rows or non-null values
SELECT COUNT(*) FROM orders;                    -- All rows
SELECT COUNT(review_score) FROM orders;        -- Non-null reviews only
SELECT COUNT(DISTINCT customer_id) FROM orders; -- Unique customers

-- SUM: Total of numeric values
SELECT SUM(price) FROM orders;
SELECT SUM(price + freight_value) FROM orders; -- Calculated totals

-- AVG: Average of numeric values
SELECT AVG(price) FROM orders;
SELECT AVG(price) FROM orders WHERE price IS NOT NULL; -- Explicit null handling

-- MIN and MAX: Minimum and maximum values
SELECT MIN(price), MAX(price) FROM orders;
SELECT MIN(order_date), MAX(order_date) FROM orders; -- Works with dates too

-- Multiple aggregates in one query
SELECT 
    COUNT(*) as total_orders,
    SUM(price) as total_revenue,
    AVG(price) as avg_order_value,
    MIN(price) as min_price,
    MAX(price) as max_price,
    AVG(review_score) as avg_rating
FROM orders;
```

### Aggregate Functions with Conditions
```sql
-- Using WHERE for filtering before aggregation
SELECT COUNT(*) FROM orders WHERE price >= 200;
SELECT SUM(price) FROM orders WHERE customer_state = 'SP';
SELECT AVG(review_score) FROM orders WHERE price BETWEEN 100 AND 300;

-- Conditional aggregation with CASE
SELECT 
    SUM(CASE WHEN price >= 200 THEN price ELSE 0 END) as high_value_revenue,
    SUM(CASE WHEN price < 200 THEN price ELSE 0 END) as regular_revenue,
    COUNT(CASE WHEN review_score >= 4 THEN 1 END) as satisfied_customers
FROM orders;

-- Boolean aggregation (PostgreSQL)
SELECT 
    COUNT(*) as total_orders,
    SUM(CASE WHEN price >= 200 THEN 1 ELSE 0 END) as premium_orders,
    ROUND(SUM(CASE WHEN price >= 200 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) as premium_percentage
FROM orders;
```

---

## GROUP BY Operations

### Single Column Grouping
```sql
-- Basic grouping
SELECT customer_state, COUNT(*) as order_count
FROM orders
GROUP BY customer_state;

-- Multiple aggregates per group
SELECT 
    customer_state,
    COUNT(*) as order_count,
    SUM(price) as total_revenue,
    AVG(price) as avg_order_value,
    MIN(price) as min_price,
    MAX(price) as max_price
FROM orders
GROUP BY customer_state
ORDER BY total_revenue DESC;

-- Grouping with calculations
SELECT 
    customer_state,
    COUNT(DISTINCT customer_id) as unique_customers,
    COUNT(*) as total_orders,
    ROUND(COUNT(*)::decimal / COUNT(DISTINCT customer_id), 2) as orders_per_customer
FROM orders
GROUP BY customer_state;
```

### Multiple Column Grouping
```sql
-- Two-level grouping
SELECT 
    customer_state,
    category,
    COUNT(*) as order_count,
    SUM(price) as revenue,
    AVG(price) as avg_price
FROM orders
GROUP BY customer_state, category
ORDER BY customer_state, revenue DESC;

-- Time-based grouping
SELECT 
    EXTRACT(YEAR FROM order_date) as year,
    EXTRACT(MONTH FROM order_date) as month,
    COUNT(*) as monthly_orders,
    SUM(price) as monthly_revenue
FROM orders
GROUP BY 
    EXTRACT(YEAR FROM order_date),
    EXTRACT(MONTH FROM order_date)
ORDER BY year, month;

-- Price segment grouping with CASE
SELECT 
    CASE 
        WHEN price < 100 THEN 'Budget'
        WHEN price >= 100 AND price < 200 THEN 'Standard'
        WHEN price >= 200 AND price < 300 THEN 'Premium'
        ELSE 'Luxury'
    END as price_segment,
    COUNT(*) as order_count,
    SUM(price) as segment_revenue,
    AVG(price) as avg_price
FROM orders
GROUP BY 
    CASE 
        WHEN price < 100 THEN 'Budget'
        WHEN price >= 100 AND price < 200 THEN 'Standard'
        WHEN price >= 200 AND price < 300 THEN 'Premium'
        ELSE 'Luxury'
    END
ORDER BY segment_revenue DESC;
```

---

## HAVING Clause - Filtering Groups

### Basic HAVING Usage
```sql
-- Filter groups after aggregation
SELECT 
    customer_state,
    COUNT(*) as order_count,
    SUM(price) as total_revenue
FROM orders
GROUP BY customer_state
HAVING COUNT(*) >= 100  -- Only states with at least 100 orders
ORDER BY total_revenue DESC;

-- Multiple HAVING conditions
SELECT 
    category,
    COUNT(*) as order_count,
    AVG(price) as avg_price,
    AVG(review_score) as avg_rating
FROM orders
GROUP BY category
HAVING COUNT(*) >= 50        -- Sufficient volume
   AND AVG(price) >= 100     -- High value
   AND AVG(review_score) >= 4.0  -- Good satisfaction
ORDER BY avg_price DESC;
```

### Complex HAVING with Subqueries
```sql
-- Compare to overall averages
SELECT 
    customer_state,
    COUNT(*) as orders,
    AVG(price) as avg_order_value,
    ROUND((AVG(price) / (SELECT AVG(price) FROM orders) - 1) * 100, 2) as vs_overall_avg_pct
FROM orders
GROUP BY customer_state
HAVING AVG(price) > (SELECT AVG(price) FROM orders)  -- Above average performance only
ORDER BY avg_order_value DESC;

-- Statistical significance filter
SELECT 
    category,
    COUNT(*) as sample_size,
    AVG(review_score) as avg_rating,
    STDDEV(review_score) as rating_std_dev
FROM orders
WHERE review_score IS NOT NULL
GROUP BY category
HAVING COUNT(*) >= 30  -- Minimum sample size for statistical significance
ORDER BY avg_rating DESC;
```

---

## Window Functions Introduction

### Basic Window Functions
```sql
-- Running totals
SELECT 
    order_date,
    price,
    SUM(price) OVER (ORDER BY order_date) as running_total
FROM orders
ORDER BY order_date;

-- Rankings
SELECT 
    customer_state,
    SUM(price) as total_revenue,
    ROW_NUMBER() OVER (ORDER BY SUM(price) DESC) as revenue_rank,
    RANK() OVER (ORDER BY SUM(price) DESC) as revenue_rank_with_ties
FROM orders
GROUP BY customer_state
ORDER BY revenue_rank;

-- Percentiles with NTILE
SELECT 
    customer_id,
    SUM(price) as total_spent,
    NTILE(4) OVER (ORDER BY SUM(price)) as customer_quartile
FROM orders
GROUP BY customer_id
ORDER BY total_spent DESC;
```

### Window Functions with Partitions
```sql
-- Compare each state to overall average
SELECT 
    customer_state,
    category,
    AVG(price) as category_avg_by_state,
    AVG(AVG(price)) OVER () as overall_avg,
    ROUND((AVG(price) - AVG(AVG(price)) OVER ()) / AVG(AVG(price)) OVER () * 100, 2) as variance_pct
FROM orders
GROUP BY customer_state, category
ORDER BY customer_state, variance_pct DESC;

-- Rank categories within each state
SELECT 
    customer_state,
    category,
    SUM(price) as category_revenue,
    ROW_NUMBER() OVER (PARTITION BY customer_state ORDER BY SUM(price) DESC) as rank_in_state
FROM orders
GROUP BY customer_state, category
ORDER BY customer_state, rank_in_state;
```

### Moving Averages and Lag Functions
```sql
-- Monthly trends with moving averages (using CTE)
WITH monthly_data AS (
    SELECT 
        EXTRACT(YEAR FROM order_date) as year,
        EXTRACT(MONTH FROM order_date) as month,
        COUNT(*) as monthly_orders,
        SUM(price) as monthly_revenue
    FROM orders
    GROUP BY 
        EXTRACT(YEAR FROM order_date),
        EXTRACT(MONTH FROM order_date)
)
SELECT 
    year,
    month,
    monthly_revenue,
    AVG(monthly_revenue) OVER (
        ORDER BY year, month 
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ) as three_month_avg,
    LAG(monthly_revenue) OVER (ORDER BY year, month) as prev_month_revenue,
    ROUND(
        (monthly_revenue - LAG(monthly_revenue) OVER (ORDER BY year, month)) / 
        LAG(monthly_revenue) OVER (ORDER BY year, month) * 100, 2
    ) as month_over_month_growth_pct
FROM monthly_data
ORDER BY year, month;
```

---

## Advanced Aggregation Patterns

### Conditional Aggregation with CASE
```sql
-- Cross-tabulation (pivot-like) using CASE
SELECT 
    customer_state,
    SUM(CASE WHEN category = 'electronics' THEN price ELSE 0 END) as electronics_revenue,
    SUM(CASE WHEN category = 'clothing' THEN price ELSE 0 END) as clothing_revenue,
    SUM(CASE WHEN category = 'books' THEN price ELSE 0 END) as books_revenue,
    SUM(price) as total_revenue
FROM orders
GROUP BY customer_state
ORDER BY total_revenue DESC;

-- Customer satisfaction analysis by price ranges
SELECT 
    CASE 
        WHEN price < 50 THEN 'Budget'
        WHEN price >= 50 AND price < 150 THEN 'Standard'
        WHEN price >= 150 AND price < 300 THEN 'Premium'
        ELSE 'Luxury'
    END as price_category,
    COUNT(*) as total_orders,
    SUM(CASE WHEN review_score >= 4 THEN 1 ELSE 0 END) as satisfied_customers,
    ROUND(SUM(CASE WHEN review_score >= 4 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) as satisfaction_rate
FROM orders
WHERE review_score IS NOT NULL
GROUP BY 
    CASE 
        WHEN price < 50 THEN 'Budget'
        WHEN price >= 50 AND price < 150 THEN 'Standard'
        WHEN price >= 150 AND price < 300 THEN 'Premium'
        ELSE 'Luxury'
    END
ORDER BY satisfaction_rate DESC;
```

### Using CTEs for Complex Analysis
```sql
-- Multi-step analysis using Common Table Expressions
WITH customer_metrics AS (
    SELECT 
        customer_id,
        customer_state,
        COUNT(*) as order_count,
        SUM(price) as total_spent,
        AVG(price) as avg_order_value,
        MAX(order_date) as last_order_date
    FROM orders
    GROUP BY customer_id, customer_state
),
customer_segments AS (
    SELECT 
        customer_id,
        customer_state,
        order_count,
        total_spent,
        avg_order_value,
        CASE 
            WHEN total_spent >= 1000 THEN 'VIP'
            WHEN total_spent >= 500 THEN 'Premium'
            WHEN total_spent >= 200 THEN 'Standard'
            ELSE 'Basic'
        END as customer_segment
    FROM customer_metrics
)
SELECT 
    customer_state,
    customer_segment,
    COUNT(*) as customers_in_segment,
    AVG(total_spent) as avg_lifetime_value,
    AVG(order_count) as avg_orders_per_customer
FROM customer_segments
GROUP BY customer_state, customer_segment
ORDER BY customer_state, avg_lifetime_value DESC;
```

---

## Performance Optimization

### Indexing for Aggregations
```sql
-- Indexes that help aggregation queries
-- CREATE INDEX idx_orders_state ON orders(customer_state);
-- CREATE INDEX idx_orders_category ON orders(category);
-- CREATE INDEX idx_orders_date ON orders(order_date);
-- CREATE INDEX idx_orders_state_category ON orders(customer_state, category);

-- Use covering indexes when possible
-- CREATE INDEX idx_orders_analysis ON orders(customer_state, category) INCLUDE (price, review_score);
```

### Efficient Aggregation Queries
```sql
-- Use EXISTS instead of IN for large subqueries
SELECT customer_state, COUNT(*)
FROM orders o1
WHERE EXISTS (
    SELECT 1 FROM orders o2 
    WHERE o2.customer_state = o1.customer_state 
    AND o2.price >= 200
)
GROUP BY customer_state;

-- Limit data early with WHERE
SELECT 
    category,
    COUNT(*) as orders,
    AVG(price) as avg_price
FROM orders
WHERE order_date >= '2023-01-01'  -- Filter before aggregation
  AND price IS NOT NULL
GROUP BY category
HAVING COUNT(*) >= 100;
```

---

## Common Aggregation Patterns

### Business KPI Calculations
```sql
-- Customer acquisition and retention metrics
SELECT 
    EXTRACT(YEAR FROM order_date) as year,
    EXTRACT(MONTH FROM order_date) as month,
    COUNT(DISTINCT customer_id) as active_customers,
    COUNT(*) as total_orders,
    SUM(price) as total_revenue,
    ROUND(SUM(price) / COUNT(DISTINCT customer_id), 2) as revenue_per_customer,
    ROUND(COUNT(*)::decimal / COUNT(DISTINCT customer_id), 2) as orders_per_customer
FROM orders
GROUP BY 
    EXTRACT(YEAR FROM order_date),
    EXTRACT(MONTH FROM order_date)
ORDER BY year, month;

-- Market concentration analysis
SELECT 
    customer_state,
    SUM(price) as revenue,
    ROUND(SUM(price) / SUM(SUM(price)) OVER () * 100, 2) as market_share_pct,
    SUM(ROUND(SUM(price) / SUM(SUM(price)) OVER () * 100, 2)) OVER (ORDER BY SUM(price) DESC) as cumulative_share
FROM orders
GROUP BY customer_state
ORDER BY revenue DESC;
```

---

## Data Quality Considerations

### Handling NULL Values
```sql
-- COUNT with NULL handling
SELECT 
    customer_state,
    COUNT(*) as total_orders,
    COUNT(review_score) as orders_with_reviews,
    COUNT(*) - COUNT(review_score) as orders_without_reviews,
    ROUND(COUNT(review_score) * 100.0 / COUNT(*), 2) as review_completion_rate
FROM orders
GROUP BY customer_state;

-- AVG with NULL handling (automatic)
SELECT 
    category,
    AVG(review_score) as avg_rating,  -- Automatically excludes NULLs
    COUNT(review_score) as rated_orders,
    COUNT(*) as total_orders
FROM orders
GROUP BY category;

-- Explicit NULL handling with COALESCE
SELECT 
    customer_state,
    AVG(COALESCE(review_score, 3.0)) as avg_rating_with_default,
    AVG(review_score) as avg_rating_excluding_nulls
FROM orders
GROUP BY customer_state;
```

### Data Validation in Aggregations
```sql
-- Identify data quality issues
SELECT 
    'Price Issues' as issue_type,
    COUNT(*) as problem_count
FROM orders
WHERE price <= 0 OR price IS NULL

UNION ALL

SELECT 
    'Date Issues' as issue_type,
    COUNT(*) as problem_count
FROM orders
WHERE order_date IS NULL OR order_date > CURRENT_DATE

UNION ALL

SELECT 
    'Review Score Issues' as issue_type,
    COUNT(*) as problem_count
FROM orders
WHERE review_score < 1 OR review_score > 5;
```

---

## Business Analysis Templates

### Executive Dashboard Query
```sql
-- Comprehensive business metrics
SELECT 
    'Overall Performance' as metric_category,
    COUNT(*) as total_orders,
    COUNT(DISTINCT customer_id) as unique_customers,
    SUM(price) as total_revenue,
    AVG(price) as avg_order_value,
    ROUND(AVG(review_score), 2) as avg_customer_satisfaction,
    COUNT(DISTINCT category) as active_categories,
    MIN(order_date) as first_order,
    MAX(order_date) as last_order
FROM orders;
```

### Market Performance Analysis
```sql
-- State-by-state performance comparison
WITH state_metrics AS (
    SELECT 
        customer_state,
        COUNT(*) as orders,
        SUM(price) as revenue,
        AVG(price) as aov,
        AVG(review_score) as avg_rating,
        COUNT(DISTINCT category) as categories_sold
    FROM orders
    GROUP BY customer_state
),
overall_metrics AS (
    SELECT 
        AVG(aov) as overall_aov,
        AVG(avg_rating) as overall_rating
    FROM state_metrics
)
SELECT 
    s.customer_state,
    s.orders,
    s.revenue,
    s.aov,
    ROUND((s.aov / o.overall_aov - 1) * 100, 2) as aov_vs_avg_pct,
    s.avg_rating,
    ROUND((s.avg_rating / o.overall_rating - 1) * 100, 2) as rating_vs_avg_pct,
    s.categories_sold,
    ROW_NUMBER() OVER (ORDER BY s.revenue DESC) as revenue_rank
FROM state_metrics s
CROSS JOIN overall_metrics o
ORDER BY s.revenue DESC;
```

---

## Troubleshooting Common Issues

### GROUP BY Errors
```sql
-- WRONG: Column not in GROUP BY
-- SELECT customer_state, category, COUNT(*) FROM orders GROUP BY customer_state;

-- CORRECT: All non-aggregate columns must be in GROUP BY
SELECT customer_state, category, COUNT(*) 
FROM orders 
GROUP BY customer_state, category;

-- CORRECT: Or use aggregation for all columns
SELECT customer_state, COUNT(DISTINCT category) as categories, COUNT(*) 
FROM orders 
GROUP BY customer_state;
```

### Division by Zero Prevention
```sql
-- Safe division with NULLIF or CASE
SELECT 
    customer_state,
    COUNT(*) as orders,
    SUM(price) as revenue,
    ROUND(SUM(price) / NULLIF(COUNT(*), 0), 2) as avg_order_value,  -- NULLIF prevents divide by zero
    CASE 
        WHEN COUNT(*) > 0 THEN SUM(price) / COUNT(*)
        ELSE 0
    END as safe_avg_order_value
FROM orders
GROUP BY customer_state;
```

---

## Best Practices Checklist

When writing aggregation queries:

- ✅ **Use appropriate indexes** on GROUP BY and WHERE columns
- ✅ **Filter early** with WHERE before GROUP BY when possible
- ✅ **Handle NULL values** explicitly when they affect business logic
- ✅ **Use meaningful aliases** for aggregated columns
- ✅ **Order results** logically for business users
- ✅ **Validate results** by cross-checking totals
- ✅ **Comment complex logic** especially CASE statements
- ✅ **Test with edge cases** like empty groups or NULL values
- ✅ **Consider performance** for large datasets
- ✅ **Use CTEs** for complex multi-step analysis

---

*This comprehensive reference covers SQL aggregation techniques for business analysis. Keep it handy for your data analysis projects!*