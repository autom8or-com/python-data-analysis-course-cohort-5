# Week 9 Python Lecture Notebooks

## Customer Lifetime Value Analysis with Pandas

This folder contains Jupyter notebooks for Week 9 Wednesday Python class covering advanced pandas operations for customer lifetime value analysis.

### Notebooks Overview

1. **01-groupby-mastery.ipynb** (30 mins)
   - Single and multiple column grouping
   - Built-in and custom aggregation functions
   - Transform operations within groups
   - Exercise: Customer purchase behavior analysis

2. **02-multi-index-operations.ipynb** (45 mins)
   - Creating hierarchical indexes
   - Unstacking and pivoting data
   - Cross-tabulation with pd.crosstab()
   - Exercise: Product-customer purchase matrix

3. **03-advanced-aggregations.ipynb** (45 mins)
   - Custom aggregation functions
   - Named aggregations with agg()
   - Combining multiple operations
   - Exercise: Customer lifetime value calculations

4. **04-customer-clv-analysis.ipynb** (Complete Analysis)
   - Comprehensive CLV calculation pipeline
   - RFM segmentation implementation
   - Customer cohort analysis
   - Business insights and recommendations

### Getting Started

1. **Upload to Google Colab:**
   - Go to [colab.research.google.com](https://colab.research.google.com)
   - File → Upload notebook
   - Select notebook from this folder

2. **Upload Datasets:**
   - In Colab, click folder icon on left sidebar
   - Upload all CSV files from `../datasets/` folder
   - Adjust file paths in notebooks if needed

3. **Run Cells:**
   - Click "Run" button or press Shift+Enter
   - Run cells in order from top to bottom

### Prerequisites

- Completion of Weeks 1-8 (pandas basics, filtering, joins)
- Understanding of SQL GROUP BY concepts
- Familiarity with Python functions

### Learning Path

**Recommended Order:**
1. Review SQL content from Thursday class first
2. Work through notebooks 01-03 sequentially
3. Complete exercises after each notebook
4. Finish with comprehensive analysis (notebook 04)
5. Compare pandas approach with SQL queries

### Key Concepts Covered

**GroupBy Operations:**
- Single column: `df.groupby('col')`
- Multiple columns: `df.groupby(['col1', 'col2'])`
- Aggregations: `sum()`, `mean()`, `count()`, `nunique()`
- Custom functions with `.agg()`
- Transform: `.transform()` for broadcasting

**Multi-Index:**
- Creating: `df.set_index(['col1', 'col2'])`
- Slicing: `.loc[(level1, level2), :]`
- Unstacking: `.unstack()`
- Cross-tabulation: `pd.crosstab()`

**Advanced Aggregations:**
- Named aggregations (pandas 0.25+)
- Multiple aggregations per column
- Conditional aggregations with `filter()`
- Window operations

### SQL to Pandas Translation

| SQL | Pandas |
|-----|--------|
| `GROUP BY col` | `.groupby('col')` |
| `COUNT(*)` | `.size()` or `.count()` |
| `SUM(col)` | `.sum()` |
| `AVG(col)` | `.mean()` |
| `HAVING condition` | Filter after groupby |
| `OVER (PARTITION BY)` | `.transform()` |
| `PIVOT` | `.pivot()` or `.pivot_table()` |
| `WITH cte AS (...)` | Intermediate DataFrames |

### Business Context

All examples use e-commerce customer data to calculate:
- **Customer Lifetime Value (CLV):** Total revenue per customer
- **RFM Segmentation:** Recency, Frequency, Monetary analysis
- **Cohort Analysis:** Customer retention over time
- **Product Affinity:** Cross-category purchase patterns
- **Churn Prediction:** Identifying at-risk customers

### Nigerian Business Adaptation

Examples include:
- Lagos, Abuja, Port Harcourt locations
- Nigerian Naira (₦) currency formatting
- Local business scenarios and challenges
- E-commerce growth patterns in Nigeria

### Common Issues & Solutions

**Issue:** File not found error
**Solution:** Ensure datasets are uploaded to Colab and path is correct

**Issue:** Memory error with large datasets
**Solution:** Use `.head()` for testing, or sample data with `.sample()`

**Issue:** Groupby returns unexpected results
**Solution:** Check for NaN values, filter before grouping

**Issue:** Multi-index confusing
**Solution:** Use `.reset_index()` to flatten when needed

### Additional Resources

- **Resources Folder:** Reference guides for groupby, aggregations, multi-index
- **Exercises Folder:** Practice problems with increasing difficulty
- **Solutions Folder:** Complete solutions with explanations
- **Thursday SQL Content:** Compare equivalent SQL approaches

### Support

If you encounter issues:
1. Check the resources folder for quick references
2. Compare with SQL solutions from Thursday
3. Review error messages carefully
4. Ask questions in class or office hours

### Next Week Preview

Week 10 will cover:
- Window functions in pandas (rolling, expanding, ewm)
- Time series analysis for CLV prediction
- Advanced merging and concatenation
- Performance optimization for large datasets

---

**Created:** October 2025
**Course:** PORA Academy Cohort 5 - Phase 2 Week 9
**Instructor:** [Your Name]
