# Pandas Aggregations & Summary Statistics - Reference Guide

## Week 4 Python Reference Materials
**Wednesday Python Class - September 3, 2025**

---

## Quick Reference: Excel to Pandas Translation

| Excel Function | Purpose | Pandas Equivalent | Example |
|----------------|---------|-------------------|---------|
| `SUM()` | Sum values | `df['column'].sum()` | `df['price'].sum()` |
| `COUNT()` | Count non-empty | `df['column'].count()` | `df['order_id'].count()` |
| `AVERAGE()` | Mean value | `df['column'].mean()` | `df['price'].mean()` |
| `MIN()` | Minimum value | `df['column'].min()` | `df['price'].min()` |
| `MAX()` | Maximum value | `df['column'].max()` | `df['price'].max()` |
| `MEDIAN()` | Middle value | `df['column'].median()` | `df['price'].median()` |
| `STDEV()` | Standard deviation | `df['column'].std()` | `df['price'].std()` |
| `SUMIF()` | Conditional sum | `df[condition]['col'].sum()` | `df[df['state']=='SP']['price'].sum()` |
| `COUNTIF()` | Conditional count | `df[condition].shape[0]` | `df[df['rating']>=4].shape[0]` |
| `AVERAGEIF()` | Conditional average | `df[condition]['col'].mean()` | `df[df['category']=='electronics']['price'].mean()` |
| Pivot Table | Cross-tabulation | `pd.pivot_table()` | `pd.pivot_table(df, values='price', index='state', columns='category')` |

---

## Core Aggregation Functions

### Basic Statistical Functions
```python
# Single column aggregations
df['price'].sum()          # Total sum
df['price'].mean()         # Average
df['price'].median()       # Middle value
df['price'].mode()         # Most frequent value(s)
df['price'].std()          # Standard deviation
df['price'].var()          # Variance
df['price'].min()          # Minimum value
df['price'].max()          # Maximum value
df['price'].count()        # Count of non-null values
df['price'].nunique()      # Count of unique values

# Quantiles and percentiles
df['price'].quantile(0.25)    # 25th percentile (Q1)
df['price'].quantile(0.50)    # 50th percentile (median)
df['price'].quantile(0.75)    # 75th percentile (Q3)
df['price'].quantile([0.25, 0.5, 0.75])  # Multiple quantiles
```

### The describe() Method
```python
# Comprehensive statistical summary
df['price'].describe()

# Custom percentiles
df['price'].describe(percentiles=[0.1, 0.25, 0.5, 0.75, 0.9, 0.95])

# Describe multiple columns
df[['price', 'freight_value', 'review_score']].describe()

# Describe by groups
df.groupby('customer_state')['price'].describe()
```

### Value Counts - Frequency Analysis
```python
# Basic frequency count
df['customer_state'].value_counts()

# Percentage distribution
df['customer_state'].value_counts(normalize=True) * 100

# Include missing values
df['customer_state'].value_counts(dropna=False)

# Sort by index instead of count
df['customer_state'].value_counts().sort_index()

# Top N values
df['customer_state'].value_counts().head(5)
```

---

## GroupBy Operations

### Basic GroupBy
```python
# Single column grouping
df.groupby('customer_state')['price'].sum()
df.groupby('customer_state')['price'].mean()
df.groupby('customer_state').size()  # Count of rows per group

# Multiple aggregations
df.groupby('customer_state')['price'].agg(['count', 'sum', 'mean', 'std'])
```

### Advanced GroupBy with agg()
```python
# Different aggregations for different columns
df.groupby('customer_state').agg({
    'price': ['count', 'sum', 'mean'],
    'freight_value': ['mean', 'sum'],
    'review_score': 'mean'
})

# Custom aggregation functions
df.groupby('customer_state')['price'].agg(['sum', 'mean', lambda x: x.max() - x.min()])

# Named aggregations (pandas 0.25+)
df.groupby('customer_state').agg(
    order_count=('price', 'count'),
    total_revenue=('price', 'sum'),
    avg_order_value=('price', 'mean'),
    avg_rating=('review_score', 'mean')
)
```

### Multi-Level GroupBy
```python
# Multiple grouping columns
df.groupby(['customer_state', 'category'])['price'].sum()

# With multiple aggregations
df.groupby(['customer_state', 'category']).agg({
    'price': ['count', 'sum', 'mean'],
    'review_score': 'mean'
})

# Reset index to flatten
result = df.groupby(['customer_state', 'category'])['price'].sum()
result.reset_index()
```

---

## Pivot Tables

### Basic Pivot Table
```python
# Simple pivot
pd.pivot_table(df, 
               values='price', 
               index='customer_state', 
               columns='category', 
               aggfunc='sum')

# With fill_value for missing combinations
pd.pivot_table(df, 
               values='price', 
               index='customer_state', 
               columns='category', 
               aggfunc='sum', 
               fill_value=0)

# With margins (totals)
pd.pivot_table(df, 
               values='price', 
               index='customer_state', 
               columns='category', 
               aggfunc='sum', 
               fill_value=0, 
               margins=True)
```

### Advanced Pivot Tables
```python
# Multiple values
pd.pivot_table(df, 
               values=['price', 'freight_value'], 
               index='customer_state', 
               columns='category', 
               aggfunc='mean')

# Multiple aggregation functions
pd.pivot_table(df, 
               values='price', 
               index='customer_state', 
               columns='category', 
               aggfunc=['sum', 'mean', 'count'])

# Multiple index/column levels
pd.pivot_table(df, 
               values='price', 
               index=['customer_state', 'price_segment'], 
               columns='category', 
               aggfunc='sum')
```

---

## Conditional Aggregations

### Boolean Indexing
```python
# Single condition
high_value_orders = df[df['price'] >= 200]
high_value_orders['price'].sum()

# Multiple conditions (AND)
premium_satisfied = df[(df['price'] >= 200) & (df['review_score'] >= 4)]

# Multiple conditions (OR)
sp_or_rj = df[(df['customer_state'] == 'SP') | (df['customer_state'] == 'RJ')]

# Using isin() for multiple values
top_states = df[df['customer_state'].isin(['SP', 'RJ', 'MG'])]
```

### Query Method (Alternative)
```python
# Using query for complex conditions
df.query('price >= 200 and review_score >= 4')
df.query('customer_state in ["SP", "RJ", "MG"]')
df.query('price >= 200 or category == "electronics"')
```

### Conditional Aggregations with GroupBy
```python
# Count of high-value orders by state
df[df['price'] >= 200].groupby('customer_state').size()

# Revenue from satisfied customers by category
df[df['review_score'] >= 4].groupby('category')['price'].sum()

# Complex conditional analysis
premium_customers = df[(df['price'] >= 200) & (df['review_score'] >= 4)]
premium_customers.groupby('customer_state').agg({
    'price': ['count', 'sum', 'mean'],
    'review_score': 'mean'
})
```

---

## Custom Aggregation Functions

### Creating Custom Functions
```python
def business_metrics(series):
    """Custom function for business KPIs"""
    return pd.Series({
        'count': len(series),
        'total': series.sum(),
        'average': series.mean(),
        'concentration': series.std() / series.mean() if series.mean() > 0 else 0,
        'top_10_pct': series.nlargest(int(len(series) * 0.1)).sum() if len(series) >= 10 else series.sum(),
        'range': series.max() - series.min()
    })

# Apply custom function
df.groupby('category')['price'].apply(business_metrics)

# Using lambda functions
df.groupby('customer_state')['price'].agg(
    total='sum',
    average='mean',
    coefficient_of_variation=lambda x: x.std() / x.mean(),
    percentile_95=lambda x: x.quantile(0.95)
)
```

---

## Performance Tips

### Efficient Aggregation
```python
# Use vectorized operations when possible
df['price'].sum()  # Faster than df['price'].apply(sum)

# Chain operations efficiently
result = (df.groupby('customer_state')
          .agg({'price': ['count', 'sum', 'mean']})
          .round(2)
          .sort_values(('price', 'sum'), ascending=False))

# Use query for complex filtering (can be faster)
df.query('price >= 200 and customer_state in ["SP", "RJ"]')
```

### Memory Considerations
```python
# For large datasets, consider:
# 1. Processing in chunks
for chunk in pd.read_csv('large_file.csv', chunksize=10000):
    result = chunk.groupby('category')['price'].sum()

# 2. Using categorical data types for repeated strings
df['customer_state'] = df['customer_state'].astype('category')
df['category'] = df['category'].astype('category')
```

---

## Common Patterns and Use Cases

### Business Analysis Patterns
```python
# Customer segmentation
def categorize_customer_value(total_spent):
    if total_spent >= 1000:
        return 'Premium'
    elif total_spent >= 500:
        return 'Standard'
    else:
        return 'Budget'

customer_segments = (df.groupby('customer_id')['price'].sum()
                     .apply(categorize_customer_value))

# Market share analysis
category_revenue = df.groupby('category')['price'].sum()
category_share = category_revenue / category_revenue.sum() * 100

# Performance benchmarking
state_avg = df.groupby('customer_state')['price'].mean()
overall_avg = df['price'].mean()
performance_vs_avg = (state_avg / overall_avg - 1) * 100

# Time series analysis
monthly_trends = df.groupby(df['order_date'].dt.to_period('M'))['price'].sum()
```

---

## Troubleshooting Common Issues

### Missing Values
```python
# Check for missing values
df.isnull().sum()

# Handle missing values in aggregations
df['review_score'].mean()  # Automatically excludes NaN
df.groupby('customer_state')['review_score'].mean()  # Also excludes NaN

# Count including missing values
df.groupby('customer_state').size()  # Includes all rows
df.groupby('customer_state')['review_score'].count()  # Excludes NaN
```

### Data Type Issues
```python
# Convert to numeric if needed
df['price'] = pd.to_numeric(df['price'], errors='coerce')

# Check data types
df.dtypes

# Convert dates
df['order_date'] = pd.to_datetime(df['order_date'])
```

### Column Name Issues
```python
# Flatten multi-level column names
df.columns = ['_'.join(col).strip() for col in df.columns.values]

# Or manually rename
df.columns = ['order_count', 'total_revenue', 'avg_price', 'avg_rating']
```

---

## Business Applications Checklist

When performing business analysis with aggregations, consider:

- **Relevance**: Are you answering the right business question?
- **Accuracy**: Are you handling missing values and data quality issues?
- **Context**: Are you comparing to appropriate benchmarks?
- **Actionability**: Can stakeholders act on your insights?
- **Visualization**: Would charts help communicate your findings?
- **Documentation**: Are your assumptions and methods clear?

---

*This reference guide covers the essential pandas aggregation techniques for business analysis. Bookmark it for quick lookup during your data analysis projects!*