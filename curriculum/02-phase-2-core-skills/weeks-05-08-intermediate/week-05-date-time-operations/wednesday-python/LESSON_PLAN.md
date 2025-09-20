# Week 5: Date & Time Operations - Python Lesson Plan
**Date**: September 10, 2025
**Duration**: 2 hours
**Business Scenario**: Seasonal Analysis - Understanding Purchase Patterns by Time Periods

## Learning Objectives
By the end of this lesson, students will be able to:
- Convert strings to datetime objects using pandas and datetime libraries
- Extract meaningful date components for temporal analysis
- Perform date arithmetic for business calculations
- Analyze seasonal patterns and trends using Python datetime tools
- Calculate time-based business metrics with pandas time series functionality

## Business Context: NaijaCommerce Seasonal Analysis (Python Implementation)
**Setting**: Building on Thursday's SQL foundation, you'll now implement the same seasonal analysis using Python and pandas. This demonstrates how the same business insights can be achieved using different tools.

**Key Business Questions** (Same as SQL class):
1. Which months show the highest sales volume and revenue?
2. How do delivery times vary across different seasons?
3. What are the peak shopping periods during the year?
4. How can we identify seasonal trends for better business planning?

## Lesson Structure (120 minutes)

### Part 1: Python DateTime Fundamentals (40 minutes)

#### 1.1 Understanding Python Date/Time Objects (15 minutes)
- `datetime` module vs pandas `datetime64` types
- Converting strings to datetime objects with `pd.to_datetime()`
- Working with timestamps and time zones
- Handling missing and malformed date data

#### 1.2 Pandas DateTime Accessor (.dt) (15 minutes)
- Using `.dt` accessor for date component extraction
- Extracting year, month, quarter, day of week
- Creating business-friendly date formats
- Timezone conversions and localization

#### 1.3 Loading and Preparing Olist Data (10 minutes)
- Reading CSV files with datetime parsing
- Setting datetime index for time series analysis
- Data quality checks for temporal fields
- Handling Brazilian timezone considerations

### Part 2: Temporal Business Analysis with Pandas (40 minutes)

#### 2.1 Seasonal Sales Pattern Analysis (20 minutes)
- Monthly and quarterly revenue analysis using `groupby()`
- Time-based aggregations with `resample()`
- Creating seasonal visualizations
- Identifying peak shopping seasons

#### 2.2 Customer Behavior Temporal Patterns (20 minutes)
- Day-of-week and hour-of-day analysis
- Weekend vs weekday shopping patterns
- Time-based customer segmentation
- Purchase frequency analysis over time

### Part 3: Advanced Date Arithmetic & Time Series Analysis (40 minutes)

#### 3.1 Date Arithmetic with Timedelta (20 minutes)
- Calculating delivery times using date subtraction
- Working with `timedelta` objects for business metrics
- Age calculations and time interval operations
- Performance metrics across time periods

#### 3.2 Advanced Time Series Operations (20 minutes)
- Rolling windows and moving averages
- Period-over-period comparisons using `shift()`
- Lead and lag calculations for trend analysis
- Time-based cohort analysis

## Practical Exercises Focus Areas

### Exercise 1: Basic DateTime Operations
- Convert order timestamps to datetime objects
- Extract date components for business reporting
- Handle missing date values appropriately

### Exercise 2: Seasonal Revenue Analysis (Python equivalent of SQL)
- Calculate monthly and quarterly revenue totals
- Identify peak sales months and seasons
- Compare year-over-year performance

### Exercise 3: Delivery Performance Metrics (Python equivalent of SQL)
- Calculate average delivery times by month
- Analyze delivery performance trends
- Identify seasonal logistics challenges

### Exercise 4: Customer Behavior Patterns (Python equivalent of SQL)
- Analyze shopping patterns by day of week
- Calculate peak shopping hours
- Understand seasonal customer preferences

## Key Python Libraries and Methods Covered

### Core Libraries
```python
import pandas as pd
import datetime as dt
from datetime import datetime, timedelta
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns
```

### Essential DateTime Operations
```python
# Converting to datetime
pd.to_datetime(df['date_column'])
datetime.strptime(date_string, '%Y-%m-%d')

# Date component extraction
df['date_column'].dt.year
df['date_column'].dt.month
df['date_column'].dt.quarter
df['date_column'].dt.dayofweek
df['date_column'].dt.hour

# Date arithmetic
df['delivery_time'] = df['delivered_date'] - df['order_date']
df['future_date'] = df['date_column'] + pd.Timedelta(days=30)

# Time-based grouping
df.groupby(df['date_column'].dt.month).sum()
df.resample('M', on='date_column').sum()  # Monthly resampling
```

### Advanced Time Series Operations
```python
# Rolling calculations
df['rolling_avg'] = df['orders'].rolling(window=7).mean()

# Period comparisons
df['prev_month'] = df['revenue'].shift(1)
df['growth_rate'] = df['revenue'].pct_change()

# Time-based filtering
mask = (df['date'] >= '2017-01-01') & (df['date'] <= '2018-12-31')
filtered_df = df[mask]
```

## Integration with Thursday's SQL Lessons

### Synchronized Learning Approach
Students will see direct parallels between SQL and Python approaches:

| SQL Function | Python Pandas Equivalent | Business Use Case |
|-------------|--------------------------|-------------------|
| `EXTRACT(MONTH FROM date)` | `df['date'].dt.month` | Monthly sales analysis |
| `DATE_TRUNC('month', date)` | `df.resample('M')` | Time-based aggregation |
| `LAG(value) OVER (ORDER BY date)` | `df['value'].shift(1)` | Period-over-period comparison |
| `AVG(value) OVER (ROWS 6 PRECEDING)` | `df['value'].rolling(7).mean()` | Moving averages |
| `date1 - date2` | `df['date1'] - df['date2']` | Time difference calculations |

### Business Insights Consistency
Both SQL and Python lessons will produce identical business insights:
- Same seasonal patterns identified
- Equivalent delivery performance metrics
- Consistent customer behavior analysis
- Aligned recommendations for business optimization

## Expected Outcomes
Students will gain confidence in:
- Translating SQL date logic to Python pandas operations
- Using pandas for comprehensive temporal data analysis
- Creating time-based visualizations and dashboards
- Building time series analysis workflows
- Understanding when to use SQL vs Python for temporal analysis

## Assessment Criteria
- Correct implementation of datetime operations (40%)
- Business relevance of temporal analysis (30%)
- Code quality and pandas best practices (20%)
- Integration of insights with Thursday's SQL findings (10%)

## Preparation for Advanced Visualization
This Python datetime foundation will directly support upcoming lessons in:
- **Google Looker Studio**: Time-based dashboard creation
- **Streamlit**: Interactive temporal analytics applications
- **Advanced Analytics**: Time series forecasting and trend analysis

## Nigerian Business Context Integration
- Adapt seasonal patterns to Nigerian calendar (rainy/dry seasons)
- Consider local holidays and festivals in datetime analysis
- Discuss timezone handling for West Africa Time (WAT)
- Reference Nigerian e-commerce platforms for context

## Tools and Environment Setup
- **Google Colab**: Primary development environment
- **Required Libraries**: pandas, numpy, matplotlib, seaborn, datetime
- **Data Source**: Olist Brazilian E-commerce dataset (same as SQL)
- **Visualization**: Basic time series plots and seasonal charts

## Homework Assignment Bridge
Students will be asked to:
1. Compare results from Wednesday Python and Thursday SQL analysis
2. Identify advantages of each approach for different business scenarios
3. Create a unified report combining insights from both tools
4. Propose which tool they would recommend for different stakeholder needs