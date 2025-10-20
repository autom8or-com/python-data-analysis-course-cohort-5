# Multi-Index (Hierarchical Index) Guide

## Overview
Multi-index allows you to have multiple levels of row or column labels, enabling efficient storage and manipulation of high-dimensional data.

## Creating Multi-Index DataFrames

### From GroupBy

```python
# Automatic multi-index creation
sales = df.groupby(['state', 'city', 'category'])['revenue'].sum()
# Returns Series with 3-level multi-index

# DataFrame with multi-index
sales_df = df.groupby(['state', 'city']).agg({
    'revenue': 'sum',
    'orders': 'count'
})
```

### Manual Creation

```python
# Using set_index
df_multi = df.set_index(['state', 'city'])

# Using MultiIndex.from_tuples
index = pd.MultiIndex.from_tuples([
    ('Lagos', 'Ikeja'),
    ('Lagos', 'Victoria Island'),
    ('Abuja', 'Wuse')
], names=['state', 'city'])

df_multi = pd.DataFrame({'revenue': [100, 200, 150]}, index=index)

# Using MultiIndex.from_arrays
states = ['LA', 'LA', 'AB', 'AB']
cities = ['Ikeja', 'VI', 'Wuse', 'Garki']
index = pd.MultiIndex.from_arrays([states, cities], names=['state', 'city'])
```

### From Product (Cartesian Product)

```python
# All combinations
states = ['LA', 'AB', 'PH']
months = ['Jan', 'Feb', 'Mar']
index = pd.MultiIndex.from_product([states, months], names=['state', 'month'])
```

## Accessing Data

### Selecting Rows

```python
# Single level selection
df.loc['Lagos']  # All rows where first level is 'Lagos'

# Multiple level selection with tuple
df.loc[('Lagos', 'Ikeja')]  # Specific combination

# Slicing with slice()
df.loc[(slice(None), 'Ikeja'), :]  # All states, city = Ikeja

# Using IndexSlice for complex selection
idx = pd.IndexSlice
df.loc[idx['Lagos':'Abuja', 'Ikeja'], :]
```

### Selecting Columns

```python
# For multi-index columns
df.loc[:, ('revenue', 'sum')]  # Column tuple

# Multiple columns
df.loc[:, [('revenue', 'sum'), ('revenue', 'mean')]]
```

### Cross-section (.xs)

```python
# Select specific level value
df.xs('Lagos', level='state')

# Select from specific level
df.xs('Ikeja', level='city')

# Multiple levels
df.xs(('Lagos', 2024), level=['state', 'year'])
```

## Manipulating Multi-Index

### Swapping Levels

```python
# Swap two levels
df.swaplevel('state', 'city')

# Swap by position
df.swaplevel(0, 1)

# After swapping, usually want to sort
df.swaplevel().sort_index()
```

### Reordering Levels

```python
# Reorder levels
df.reorder_levels(['city', 'state', 'month'])

# Sort by index
df.sort_index(level='city')
df.sort_index(level=['state', 'city'])
```

### Dropping Levels

```python
# Remove one level
df.droplevel('city')

# Remove multiple levels
df.droplevel(['city', 'month'])
```

### Resetting Index

```python
# Convert index to columns
df_flat = df.reset_index()

# Reset specific level
df.reset_index(level='city')

# Keep multi-index, just create new integer index
df.reset_index(drop=True)
```

## Stacking and Unstacking

### Unstack (Pivot)

```python
# Move innermost index level to columns
df.unstack()

# Unstack specific level
df.unstack(level='city')
df.unstack(level=0)

# Multiple levels
df.unstack(level=['city', 'month'])

# Handle missing values
df.unstack(fill_value=0)
```

### Stack (Unpivot)

```python
# Move columns to index
df.stack()

# Stack specific column level
df.stack(level=0)

# Drop missing values
df.stack(dropna=True)
```

### Example: Reshaping Sales Data

```python
# Start with multi-index
sales = df.groupby(['state', 'city', 'month'])['revenue'].sum()

# Unstack month to columns (one row per state-city)
sales_wide = sales.unstack(level='month')

# Fill missing months with 0
sales_wide = sales_wide.fillna(0)

# Stack back to long format
sales_long = sales_wide.stack()
```

## Pivot Tables and Multi-Index

### Creating Pivot Tables

```python
# Simple pivot
pivot = df.pivot_table(
    values='revenue',
    index='state',
    columns='month',
    aggfunc='sum'
)

# Multi-level index
pivot = df.pivot_table(
    values='revenue',
    index=['state', 'city'],
    columns='month',
    aggfunc='sum'
)

# Multi-level columns
pivot = df.pivot_table(
    values='revenue',
    index='state',
    columns=['month', 'category'],
    aggfunc='sum'
)

# Multiple aggregations (creates multi-level columns)
pivot = df.pivot_table(
    values='revenue',
    index='state',
    columns='month',
    aggfunc=['sum', 'mean', 'count']
)
```

### Working with Pivot Results

```python
# Flatten multi-level columns
pivot.columns = ['_'.join(col).strip() for col in pivot.columns.values]

# Or use reset_index
pivot_flat = pivot.reset_index()

# Select specific aggregate
pivot['sum']  # If aggfunc created multiple columns
```

## Aggregating Multi-Index DataFrames

### Grouping by Level

```python
# Group by specific index level
df.groupby(level='state').sum()

# Multiple levels
df.groupby(level=['state', 'city']).mean()

# By level number
df.groupby(level=0).sum()
```

### Aggregating Across Levels

```python
# Sum across all levels
df.sum(level='state')

# Mean for specific level
df.mean(level=['state', 'city'])

# Multiple operations
df.agg(['sum', 'mean'], level='state')
```

## Slicing Multi-Index

### Boolean Indexing

```python
# Filter by index level
df[df.index.get_level_values('state') == 'Lagos']

# Multiple conditions
df[(df.index.get_level_values('state') == 'Lagos') &
   (df.index.get_level_values('city') == 'Ikeja')]
```

### Query with Multi-Index

```python
# Reset index temporarily for query
df.reset_index().query("state == 'Lagos' and revenue > 1000").set_index(['state', 'city'])
```

### IndexSlice for Advanced Selection

```python
idx = pd.IndexSlice

# Select range of first level, specific second level
df.loc[idx['Lagos':'Abuja', 'Ikeja'], :]

# Select specific values across levels
df.loc[idx[['Lagos', 'Abuja'], ['Ikeja', 'Wuse']], :]

# Partial selection
df.loc[idx[:, 'Ikeja'], :]  # All states, Ikeja city
```

## Common Patterns

### State-City-Month Analysis

```python
# Create multi-index analysis
analysis = df.groupby(['state', 'city', 'month']).agg({
    'revenue': 'sum',
    'orders': 'count',
    'customers': 'nunique'
})

# Unstack month for time series view
time_series = analysis['revenue'].unstack(level='month')

# Calculate monthly growth
time_series.pct_change(axis=1)

# Total by state (summing across cities and months)
state_total = analysis.sum(level='state')
```

### Category-Subcategory Hierarchy

```python
# Product hierarchy
product_sales = df.groupby(['category', 'subcategory', 'product'])['revenue'].sum()

# Category totals
category_total = product_sales.sum(level='category')

# Percentage of category
pct_of_category = product_sales / product_sales.sum(level='category') * 100
```

### Customer Cohort Analysis

```python
# Create cohort multi-index
df['cohort_month'] = df.groupby('customer_id')['date'].transform('min').dt.to_period('M')
df['order_month'] = df['date'].dt.to_period('M')

cohort_data = df.groupby(['cohort_month', 'order_month'])['customer_id'].nunique()

# Unstack for retention matrix
cohort_matrix = cohort_data.unstack()

# Calculate retention rates
cohort_size = cohort_matrix.iloc[:, 0]
retention = cohort_matrix.div(cohort_size, axis=0) * 100
```

## Combining and Merging Multi-Index

### Concatenating

```python
# Concatenate along multi-index
pd.concat([df1, df2], axis=0)

# Add level during concatenation
pd.concat({'2023': df1, '2024': df2}, names=['year'])
```

### Merging

```python
# Merge on multi-index
df1.merge(df2, left_index=True, right_index=True)

# Reset index before merge if needed
df1.reset_index().merge(df2.reset_index(), on=['state', 'city'])
```

## Sorting Multi-Index

```python
# Sort by all levels
df.sort_index()

# Sort by specific level
df.sort_index(level='city')

# Sort by multiple levels
df.sort_index(level=['state', 'city'])

# Sort in different directions
df.sort_index(level=['state', 'city'], ascending=[True, False])

# Sort by values
df.sort_values('revenue')
```

## Performance Tips

### Memory Efficiency

```python
# Use categorical for repeated values
df['state'] = df['state'].astype('category')
df['city'] = df['city'].astype('category')

# Then create multi-index
df.set_index(['state', 'city'])
```

### Fast Selection

```python
# Sorted index is faster
df = df.sort_index()

# Then selections are faster
df.loc[('Lagos', 'Ikeja')]
```

## Visualization

### Heatmap of Multi-Index

```python
import seaborn as sns

# Unstack to 2D
pivot = df.unstack(level='month')

# Heatmap
sns.heatmap(pivot, annot=True, fmt='.0f', cmap='YlOrRd')
plt.title('Revenue by State-City and Month')
plt.show()
```

### Multi-Index in Plots

```python
# Reset index for plotting
df.reset_index().pivot(index='month', columns='state', values='revenue').plot()

# Or plot directly with multi-index
df.unstack(level='state').plot()
```

## Troubleshooting

### KeyError with Multi-Index

```python
# Problem: KeyError when accessing
# Solution: Use tuple for all levels
df.loc[('Lagos', 'Ikeja')]  # Correct
# df.loc['Lagos', 'Ikeja']  # Wrong

# Or use .xs()
df.xs('Lagos', level='state')
```

### Sorting Issues

```python
# Problem: Unexpected results
# Solution: Sort index first
df = df.sort_index()
```

### Memory Errors

```python
# Problem: High memory usage
# Solution: Use categorical dtypes
df['state'] = df['state'].astype('category')
```

### Flattening Confusion

```python
# To completely flatten multi-index
df_flat = df.reset_index()

# To flatten only columns (keep row multi-index)
df.columns = ['_'.join(col).strip() for col in df.columns.values]
```

## Best Practices

1. **Sort after creating**: `df.sort_index()` improves performance
2. **Use categorical**: For repeated values in index levels
3. **Name your levels**: Makes code more readable
4. **Reset when needed**: Use `.reset_index()` for simpler operations
5. **Document hierarchies**: Clear comments about index structure

## Resources

- [Pandas Multi-Index Documentation](https://pandas.pydata.org/docs/user_guide/advanced.html)
- Week 9 Lecture 02: Multi-Index Operations

---
**PORA Academy Cohort 5 - Week 9 Resources**
