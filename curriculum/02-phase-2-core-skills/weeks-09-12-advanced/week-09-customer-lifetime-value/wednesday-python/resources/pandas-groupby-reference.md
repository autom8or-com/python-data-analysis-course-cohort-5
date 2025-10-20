# Pandas GroupBy Quick Reference

## Overview
GroupBy operations split data into groups, apply functions, and combine results. Essential for aggregating and analyzing data by categories.

## Basic Syntax

```python
# Single column grouping
df.groupby('column_name')

# Multiple column grouping
df.groupby(['col1', 'col2'])

# With aggregation
df.groupby('column').aggregation_function()
```

## Common Aggregation Functions

### Built-in Aggregations

| Function | Description | Example |
|----------|-------------|---------|
| `.count()` | Count non-null values | `df.groupby('state').count()` |
| `.size()` | Count all rows (includes NaN) | `df.groupby('state').size()` |
| `.sum()` | Sum of values | `df.groupby('category')['revenue'].sum()` |
| `.mean()` | Average value | `df.groupby('customer')['price'].mean()` |
| `.median()` | Median value | `df.groupby('product')['sales'].median()` |
| `.min()` | Minimum value | `df.groupby('state')['price'].min()` |
| `.max()` | Maximum value | `df.groupby('state')['price'].max()` |
| `.std()` | Standard deviation | `df.groupby('category')['price'].std()` |
| `.var()` | Variance | `df.groupby('product')['sales'].var()` |
| `.nunique()` | Count unique values | `df.groupby('customer')['product'].nunique()` |
| `.first()` | First value in group | `df.groupby('customer').first()` |
| `.last()` | Last value in group | `df.groupby('customer').last()` |

## Advanced Aggregations

### Using .agg() with Dictionary

```python
# Different aggregations for different columns
df.groupby('customer').agg({
    'order_id': 'count',
    'revenue': 'sum',
    'price': ['mean', 'min', 'max']
})
```

### Named Aggregations (pandas 0.25+)

```python
# Cleaner syntax with custom column names
df.groupby('customer').agg(
    total_orders=('order_id', 'count'),
    total_revenue=('revenue', 'sum'),
    avg_price=('price', 'mean'),
    max_price=('price', 'max')
)
```

### Custom Aggregation Functions

```python
# Define custom function
def price_range(x):
    return x.max() - x.min()

# Apply custom function
df.groupby('category').agg(
    avg_price=('price', 'mean'),
    price_range=('price', price_range)
)
```

### Lambda Functions

```python
# Percentiles
df.groupby('category').agg(
    p25=('price', lambda x: x.quantile(0.25)),
    p75=('price', lambda x: x.quantile(0.75))
)

# Coefficient of variation
df.groupby('product').agg(
    cv=('price', lambda x: (x.std() / x.mean()) * 100 if x.mean() != 0 else 0)
)
```

## Transform vs Apply vs Agg

### Transform
Returns a Series with same shape as original DataFrame.

```python
# Add group mean to each row
df['category_avg'] = df.groupby('category')['price'].transform('mean')

# Calculate percentage of group total
df['pct_of_category'] = df['revenue'] / df.groupby('category')['revenue'].transform('sum') * 100
```

### Apply
Most flexible - can return scalar, Series, or DataFrame.

```python
# Custom function returning multiple values
def group_stats(x):
    return pd.Series({
        'count': len(x),
        'mean': x.mean(),
        'std': x.std()
    })

df.groupby('category')['price'].apply(group_stats)
```

### Agg
Returns aggregated result (usually scalar per group).

```python
# Single aggregation
df.groupby('customer')['revenue'].agg('sum')

# Multiple aggregations
df.groupby('customer').agg(['sum', 'mean', 'count'])
```

## Filtering Groups

```python
# Keep only groups that meet condition
df.groupby('customer').filter(lambda x: x['revenue'].sum() > 1000)

# Keep groups with more than 5 orders
df.groupby('customer').filter(lambda x: len(x) > 5)
```

## Iterating Through Groups

```python
# Loop through groups
for name, group in df.groupby('category'):
    print(f"Category: {name}")
    print(f"Size: {len(group)}")
    print(group.head())
```

## Multiple Grouping Levels

```python
# Create multi-index
grouped = df.groupby(['state', 'city', 'category'])['revenue'].sum()

# Access specific group
grouped.loc[('Lagos', 'Ikeja', 'Electronics')]

# Access all cities in Lagos
grouped.loc['Lagos']
```

## Common Patterns

### Customer Analysis
```python
customer_metrics = df.groupby('customer_id').agg(
    total_spent=('amount', 'sum'),
    num_orders=('order_id', 'nunique'),
    avg_order_value=('amount', 'mean'),
    first_purchase=('date', 'min'),
    last_purchase=('date', 'max')
)
```

### Product Performance
```python
product_performance = df.groupby('product_category').agg(
    total_revenue=('revenue', 'sum'),
    units_sold=('quantity', 'sum'),
    avg_price=('price', 'mean'),
    unique_customers=('customer_id', 'nunique')
)
```

### Time-based Analysis
```python
# Monthly aggregation
df['month'] = df['date'].dt.to_period('M')
monthly_sales = df.groupby('month')['revenue'].sum()
```

## Troubleshooting Tips

### Issue: KeyError when accessing column
**Solution:** Check column name spelling, use `df.columns` to see available columns

### Issue: Aggregation returns NaN
**Solution:** Check for null values, use `fillna()` before grouping

### Issue: SettingWithCopyWarning
**Solution:** Use `.copy()` when creating subset or use `.loc[]` properly

### Issue: Multi-index confusing
**Solution:** Use `.reset_index()` to flatten multi-index

```python
# Flatten multi-index
result = df.groupby(['state', 'city']).sum().reset_index()
```

### Issue: Memory error with large datasets
**Solution:**
- Use categorical data types for grouping columns
- Sample data for testing
- Process in chunks

```python
# Convert to categorical
df['category'] = df['category'].astype('category')
```

## Performance Tips

1. **Use built-in functions**: Faster than custom functions
2. **Avoid apply when possible**: Use vectorized operations
3. **Sort before grouping**: Can improve performance for large datasets
4. **Use categorical dtypes**: Reduces memory for repeated values

```python
# Sort before grouping (can be faster)
df = df.sort_values('customer_id')
result = df.groupby('customer_id', sort=False)['revenue'].sum()
```

## SQL to Pandas Translation

| SQL | Pandas |
|-----|--------|
| `SELECT state, COUNT(*) FROM df GROUP BY state` | `df.groupby('state').size()` |
| `SELECT state, SUM(revenue) FROM df GROUP BY state` | `df.groupby('state')['revenue'].sum()` |
| `SELECT state, AVG(price) FROM df GROUP BY state HAVING AVG(price) > 100` | `df.groupby('state')['price'].mean()[lambda x: x > 100]` |
| `SELECT state, city, SUM(revenue) FROM df GROUP BY state, city` | `df.groupby(['state', 'city'])['revenue'].sum()` |

## Additional Resources

- [Pandas GroupBy Documentation](https://pandas.pydata.org/docs/user_guide/groupby.html)
- [10 Minutes to Pandas](https://pandas.pydata.org/docs/user_guide/10min.html)
- Practice with Week 9 lecture notebooks

---
**PORA Academy Cohort 5 - Week 9 Resources**
