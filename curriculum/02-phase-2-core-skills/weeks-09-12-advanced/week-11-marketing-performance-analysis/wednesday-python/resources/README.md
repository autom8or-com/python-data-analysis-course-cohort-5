# Python Marketing Analytics Resources

## Overview
This folder contains supplementary materials for the Python marketing analytics session, including reference guides, cheat sheets, and additional learning resources.

## Resource Files

### Reference Materials
- **marketing-metrics-cheatsheet.md** - Common marketing KPIs and formulas
- **pandas-marketing-patterns.md** - Pandas patterns for marketing data
- **visualization-guide.md** - Best practices for marketing dashboards

### Data Templates
- **marketing-data-template.csv** - Sample marketing data structure
- **kpi-calculator-template.py** - Reusable KPI calculation functions

### Additional Examples
- **advanced-segmentation.py** - Complex customer segmentation techniques
- **attribution-modeling.py** - Marketing attribution examples
- **forecasting-examples.py** - Simple forecasting methods

## External Resources
- **Google Colab Setup Guide** - Link to notebook environment setup
- **Marketing Analytics Books** - Recommended reading list
- **Online Marketing Analytics Courses** - Supplementary learning materials

## Quick Reference

### Key Pandas Functions for Marketing
```python
# Calculate conversion rate
conversion_rate = df['converted'].sum() / len(df) * 100

# Customer RFM analysis
rfm = df.groupby('customer_id').agg({
    'order_date': 'max',  # Recency
    'order_id': 'count',  # Frequency
    'order_value': 'sum'  # Monetary
})
```

### Common Visualization Patterns
```python
# Funnel visualization
import plotly.express as px
fig = px.funnel(df, x='stage', y='count', title='Marketing Funnel')

# Time series of campaign performance
import matplotlib.pyplot as plt
df.groupby('date')['conversions'].sum().plot()
```

---

**Purpose**: Supplementary learning materials
**Usage**: Reference during and after class
**Updates**: Check for updated versions regularly