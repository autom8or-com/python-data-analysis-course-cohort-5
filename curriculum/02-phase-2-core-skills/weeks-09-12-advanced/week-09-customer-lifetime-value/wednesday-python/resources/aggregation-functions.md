# Aggregation Functions Reference

## Overview
Aggregation functions reduce multiple values to a single summary statistic. Essential for data analysis and reporting.

## Built-in Aggregation Functions

### Counting Functions

| Function | Description | Handles NaN | Example |
|----------|-------------|-------------|---------|
| `count()` | Count non-null values | No (excludes) | `df['price'].count()` |
| `size()` | Count all values | Yes (includes) | `df.groupby('state').size()` |
| `nunique()` | Count unique values | No (excludes) | `df['customer_id'].nunique()` |

```python
# Examples
print(f"Total orders: {df['order_id'].count()}")
print(f"Unique customers: {df['customer_id'].nunique()}")
print(f"Rows per category: {df.groupby('category').size()}")
```

### Central Tendency

| Function | Description | Use Case |
|----------|-------------|----------|
| `mean()` | Average value | General central tendency |
| `median()` | Middle value | Robust to outliers |
| `mode()` | Most frequent value | Categorical data |

```python
# Average order value
avg_order = df['amount'].mean()

# Median price (not affected by extreme values)
median_price = df['price'].median()

# Most common category
popular_category = df['category'].mode()[0]
```

### Spread/Variability

| Function | Description | Formula |
|----------|-------------|---------|
| `std()` | Standard deviation | √(Σ(x - μ)² / N) |
| `var()` | Variance | Σ(x - μ)² / N |
| `sem()` | Standard error of mean | std / √N |
| `mad()` | Mean absolute deviation | Σ\|x - μ\| / N |

```python
# Price variability
price_std = df['price'].std()
price_var = df['price'].var()

# Coefficient of variation (relative variability)
cv = (df['price'].std() / df['price'].mean()) * 100
```

### Range Functions

| Function | Description | Example |
|----------|-------------|---------|
| `min()` | Minimum value | `df['price'].min()` |
| `max()` | Maximum value | `df['price'].max()` |
| `quantile(q)` | Value at quantile q | `df['price'].quantile(0.75)` |

```python
# Price range
min_price = df['price'].min()
max_price = df['price'].max()
price_range = max_price - min_price

# Percentiles
p25 = df['revenue'].quantile(0.25)
p50 = df['revenue'].quantile(0.50)  # Same as median
p75 = df['revenue'].quantile(0.75)
p90 = df['revenue'].quantile(0.90)
```

### Sum Functions

| Function | Description | Example |
|----------|-------------|---------|
| `sum()` | Total of all values | `df['revenue'].sum()` |
| `cumsum()` | Cumulative sum | `df['revenue'].cumsum()` |
| `prod()` | Product of all values | `df['multiplier'].prod()` |

```python
# Total revenue
total_revenue = df['revenue'].sum()

# Running total
df['running_total'] = df['revenue'].cumsum()

# Compound growth
total_growth = df['growth_rate'].prod()
```

## Custom Aggregation Functions

### Simple Custom Functions

```python
# Range
def value_range(x):
    return x.max() - x.min()

# Coefficient of variation
def coeff_var(x):
    if x.mean() == 0:
        return 0
    return (x.std() / x.mean()) * 100

# Interquartile range
def iqr(x):
    return x.quantile(0.75) - x.quantile(0.25)

# Apply custom functions
df.groupby('category').agg(
    price_range=('price', value_range),
    price_cv=('price', coeff_var),
    price_iqr=('price', iqr)
)
```

### Advanced Custom Functions

```python
# Multiple return values
def detailed_stats(x):
    return pd.Series({
        'mean': x.mean(),
        'std': x.std(),
        'cv': (x.std() / x.mean() * 100) if x.mean() != 0 else 0,
        'skew': x.skew(),
        'kurtosis': x.kurtosis()
    })

# Weighted average
def weighted_avg(values, weights):
    return (values * weights).sum() / weights.sum()

# Apply
result = df.groupby('category')['price'].apply(detailed_stats)
```

### Lambda Functions

```python
# Percentiles
df.groupby('state').agg(
    p10=('price', lambda x: x.quantile(0.10)),
    p90=('price', lambda x: x.quantile(0.90))
)

# Custom calculation
df.groupby('customer').agg(
    total_with_tax=('amount', lambda x: x.sum() * 1.075),
    avg_discount=('discount', lambda x: x.mean() * 100)
)

# Conditional aggregation
df.groupby('category').agg(
    high_value_count=('price', lambda x: (x > 100).sum()),
    premium_pct=('price', lambda x: (x > 100).mean() * 100)
)
```

## Multiple Aggregations

### Same Function, Multiple Columns

```python
# Sum multiple columns
df.groupby('category')[['revenue', 'profit', 'quantity']].sum()

# Multiple stats on multiple columns
df.groupby('state').agg(['mean', 'median', 'std'])
```

### Different Functions, Different Columns

```python
df.groupby('customer').agg({
    'order_id': 'count',
    'revenue': ['sum', 'mean'],
    'product': 'nunique',
    'date': ['min', 'max']
})
```

### Named Aggregations

```python
customer_summary = df.groupby('customer_id').agg(
    # Revenue metrics
    total_revenue=('amount', 'sum'),
    avg_order_value=('amount', 'mean'),

    # Order metrics
    num_orders=('order_id', 'nunique'),
    total_items=('quantity', 'sum'),

    # Product diversity
    unique_products=('product_id', 'nunique'),

    # Time metrics
    first_order=('date', 'min'),
    last_order=('date', 'max'),

    # Custom metrics
    price_variability=('amount', lambda x: x.std())
)
```

## Conditional Aggregations

### Using Boolean Masks

```python
# Count high-value orders
df.groupby('customer').apply(lambda x: (x['amount'] > 500).sum())

# Percentage of premium purchases
df.groupby('customer').apply(lambda x: (x['price'] > 100).mean() * 100)
```

### Multiple Conditions

```python
def high_value_repeat_customers(group):
    return {
        'total_spent': group['amount'].sum(),
        'is_high_value': group['amount'].sum() > 1000,
        'is_repeat': len(group) > 1,
        'is_vip': (group['amount'].sum() > 1000) & (len(group) > 1)
    }

vip_analysis = df.groupby('customer_id').apply(high_value_repeat_customers)
```

## Statistical Aggregations

### Distribution Measures

```python
# Skewness (asymmetry)
df.groupby('category')['price'].skew()

# Kurtosis (tailedness)
df.groupby('category')['price'].apply(pd.Series.kurtosis)

# Percentile-based stats
df.groupby('category')['price'].agg([
    ('p10', lambda x: x.quantile(0.10)),
    ('p25', lambda x: x.quantile(0.25)),
    ('median', 'median'),
    ('p75', lambda x: x.quantile(0.75)),
    ('p90', lambda x: x.quantile(0.90))
])
```

### Robust Statistics

```python
# Median absolute deviation (robust to outliers)
def mad(x):
    return (x - x.median()).abs().median()

# Trimmed mean (exclude top/bottom 10%)
def trimmed_mean(x, percent=0.1):
    return x.clip(lower=x.quantile(percent),
                  upper=x.quantile(1-percent)).mean()

df.groupby('product').agg(
    mean=('price', 'mean'),
    median=('price', 'median'),
    mad=('price', mad),
    trimmed_mean=('price', trimmed_mean)
)
```

## Business Metrics

### Customer Lifetime Value

```python
clv_metrics = df.groupby('customer_id').agg(
    # Revenue
    lifetime_value=('amount', 'sum'),
    avg_order_value=('amount', 'mean'),

    # Frequency
    total_orders=('order_id', 'nunique'),
    avg_days_between_orders=('date', lambda x: (x.max() - x.min()).days / (len(x) - 1) if len(x) > 1 else 0),

    # Recency
    days_since_last_order=('date', lambda x: (pd.Timestamp.now() - x.max()).days),

    # Engagement
    product_diversity=('product_id', 'nunique'),
    category_diversity=('category', 'nunique')
)
```

### RFM Metrics

```python
analysis_date = pd.Timestamp('2024-01-01')

rfm = df.groupby('customer_id').agg(
    recency=('date', lambda x: (analysis_date - x.max()).days),
    frequency=('order_id', 'nunique'),
    monetary=('amount', 'sum')
)
```

### Product Performance

```python
product_metrics = df.groupby('product_id').agg(
    # Sales
    total_revenue=('amount', 'sum'),
    units_sold=('quantity', 'sum'),
    avg_price=('price', 'mean'),

    # Customers
    unique_customers=('customer_id', 'nunique'),
    repeat_purchase_rate=('customer_id', lambda x: (x.value_counts() > 1).sum() / x.nunique() * 100),

    # Performance
    revenue_per_customer=('amount', lambda x: x.sum() / x.count())
)
```

## Performance Considerations

### Efficient Aggregations

```python
# Fast: Use built-in functions
df.groupby('category')['price'].mean()  # Fast

# Slower: Using apply with lambda
df.groupby('category')['price'].apply(lambda x: x.mean())  # Slower

# Fastest: Vectorized operations before grouping
df['revenue_with_tax'] = df['revenue'] * 1.075
df.groupby('category')['revenue_with_tax'].sum()
```

### Memory-Efficient Patterns

```python
# Instead of loading all groups at once
for name, group in df.groupby('category'):
    result = process_large_group(group)
    save_result(name, result)

# Use categorical dtypes for grouping columns
df['category'] = df['category'].astype('category')
```

## Common Patterns

### Top N per Group

```python
# Top 3 customers per state by revenue
df.groupby('state').apply(lambda x: x.nlargest(3, 'revenue'))

# Simpler with sort_values
df.sort_values('revenue', ascending=False).groupby('state').head(3)
```

### Cumulative within Groups

```python
# Running total within each category
df['running_total'] = df.groupby('category')['revenue'].cumsum()

# Rank within group
df['rank_in_category'] = df.groupby('category')['price'].rank(ascending=False)
```

### Percentage of Group Total

```python
# Each row's percentage of its category total
df['pct_of_category'] = df['revenue'] / df.groupby('category')['revenue'].transform('sum') * 100
```

## Troubleshooting

### Division by Zero

```python
# Safe coefficient of variation
def safe_cv(x):
    mean = x.mean()
    return (x.std() / mean * 100) if mean != 0 else 0
```

### Handling NaN Values

```python
# Exclude NaN before aggregating
df.groupby('category')['price'].apply(lambda x: x.dropna().mean())

# Or fill NaN values
df['price'].fillna(0).groupby(df['category']).sum()
```

## Resources

- [Pandas Aggregation Documentation](https://pandas.pydata.org/docs/reference/groupby.html)
- [NumPy Statistical Functions](https://numpy.org/doc/stable/reference/routines.statistics.html)

---
**PORA Academy Cohort 5 - Week 9 Resources**
