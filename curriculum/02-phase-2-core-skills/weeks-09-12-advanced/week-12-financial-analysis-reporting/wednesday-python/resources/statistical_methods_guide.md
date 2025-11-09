# Statistical Methods Guide for Financial Analysis

## Overview
This guide provides a comprehensive reference for statistical methods used in financial analysis of e-commerce data.

## Key Statistical Concepts

### 1. Descriptive Statistics

#### Central Tendency Measures
- **Mean**: Average value, sensitive to outliers
- **Median**: Middle value, resistant to outliers
- **Mode**: Most frequent value, useful for categorical data

#### Spread Measures
- **Standard Deviation**: Measure of data variability
- **Variance**: Square of standard deviation
- **Range**: Difference between max and min values
- **Interquartile Range (IQR)**: Q3 - Q1, robust measure of spread

#### Percentiles
- **Quartiles**: 25th, 50th, 75th percentiles
- **Deciles**: 10th, 20th, ..., 90th percentiles
- **Application**: Understanding data distribution and outliers

### 2. Correlation Analysis

#### Pearson Correlation
- Measures linear relationship between continuous variables
- Range: -1 to +1
- Interpretation:
  - 0.7 to 1.0: Strong positive correlation
  - 0.3 to 0.7: Moderate positive correlation
  - -0.3 to 0.3: Weak or no correlation
  - -0.7 to -0.3: Moderate negative correlation
  - -1.0 to -0.7: Strong negative correlation

#### Spearman Correlation
- Measures monotonic relationship (rank-based)
- Useful for non-linear relationships
- More robust to outliers than Pearson

### 3. Statistical Testing

#### Hypothesis Testing
- **Null Hypothesis (H₀)**: No effect or difference
- **Alternative Hypothesis (H₁)**: Effect or difference exists
- **Significance Level (α)**: Typically 0.05
- **p-value**: Probability of observing results if H₀ is true

#### Common Tests
- **t-test**: Compare means between two groups
- **ANOVA**: Compare means across multiple groups
- **Chi-square**: Test independence in categorical data

### 4. Business Applications

#### Customer Segmentation
- RFM Analysis (Recency, Frequency, Monetary)
- Behavioral clustering
- Value-based segmentation

#### Performance Analysis
- Regional performance comparison
- Payment method effectiveness
- Time series trend analysis

## Python Implementation Tips

### Essential Libraries
```python
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns
from scipy import stats
from scipy.stats import pearsonr, spearmanr
```

### Common Patterns
```python
# Descriptive statistics
df.describe()
df['column'].mean()
df['column'].std()
df['column'].quantile([0.25, 0.5, 0.75])

# Correlation analysis
correlation_matrix = df.corr()
pearson_corr, p_value = pearsonr(x, y)

# Statistical testing
t_stat, p_value = stats.ttest_ind(group1, group2)

# Visualization
sns.heatmap(correlation_matrix, annot=True)
sns.boxplot(data=df, x='category', y='value')
```

## SQL Implementation Tips

### Statistical Functions
```sql
-- Basic statistics
AVG(column)
STDDEV(column)
VARIANCE(column)
MIN(column), MAX(column)

-- Percentiles
PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY column)
PERCENTILE_DISC(0.5) WITHIN GROUP (ORDER BY column)

-- Window functions for ranking
RANK() OVER (PARTITION BY group ORDER BY value DESC)
PERCENTILE_RANK() OVER (ORDER BY value)
```

### Common Patterns
```sql
-- Regional comparison
SELECT region, AVG(value) as avg_value, STDDEV(value) as std_dev
FROM table
GROUP BY region;

-- Correlation-like analysis (using COVAR_POP)
SELECT COVAR_POP(x, y) / (STDDEV_POP(x) * STDDEV_POP(y)) as correlation
FROM table;
```

## Nigerian E-commerce Context

### Regional Considerations
- **SP (São Paulo)**: Largest market, highest revenue
- **RJ (Rio de Janeiro)**: High tourism influence
- **MG (Minas Gerais)**: Growing digital adoption
- **BA (Bahia)**: Regional economic hub
- **RS (Rio Grande do Sul)**: Southern market characteristics

### Payment Method Patterns
- **Credit Card**: Preferred for high-value transactions
- **Boleto**: Popular for installment payments
- **Debit Card**: Direct bank account payments
- **Voucher**: Promotional and discount usage

### Business Metrics
- **Average Order Value**: Typically ₦100-₦200
- **Payment Variability**: Monitor CV% for market stability
- **Customer Lifetime Value**: Key for retention strategies
- **Regional Performance**: Benchmark against national averages

## Common Pitfalls and Solutions

### Data Quality Issues
- **Missing Values**: Handle appropriately (mean/median imputation)
- **Outliers**: Investigate vs. remove based on business context
- **Inconsistent Data**: Standardize formats and categories

### Statistical Mistakes
- **Confusing Correlation with Causation**: Correlation ≠ Causation
- **Small Sample Sizes**: Ensure statistical power
- **Multiple Testing**: Adjust significance levels
- **Ignoring Assumptions**: Check normality, independence

### Business Interpretation Errors
- **Statistical Significance vs. Practical Significance**: Large samples can show statistical significance for trivial effects
- **Overfitting**: Don't create overly complex models
- **Confirmation Bias**: Consider alternative explanations

## Best Practices

### Analysis Workflow
1. **Data Exploration**: Understand structure and quality
2. **Descriptive Statistics**: Basic summary and patterns
3. **Visualization**: Graphical analysis and insights
4. **Statistical Testing**: Validate hypotheses
5. **Business Interpretation**: Translate to actionable insights
6. **Documentation**: Record assumptions and limitations

### Presentation Tips
- Use clear, non-technical language for business audiences
- Include visualizations with proper labels and legends
- Provide context for statistical findings
- Make specific, actionable recommendations
- Acknowledge limitations and assumptions

## Resources

### Documentation
- [Pandas Documentation](https://pandas.pydata.org/docs/)
- [SciPy Statistics](https://docs.scipy.org/doc/scipy/reference/stats.html)
- [PostgreSQL Statistical Functions](https://www.postgresql.org/docs/current/functions-aggregate.html)

### Further Reading
- "Practical Statistics for Data Scientists" by Peter Bruce
- "Think Stats" by Allen B. Downey
- "Naked Statistics" by Charles Wheelan

---
*This guide is designed to complement the Week 12 curriculum on Financial Analysis and Reporting.*