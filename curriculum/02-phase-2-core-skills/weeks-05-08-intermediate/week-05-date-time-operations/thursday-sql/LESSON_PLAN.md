# Week 5: Date & Time Operations - SQL Lesson Plan
**Date**: September 11, 2025
**Duration**: 2 hours
**Business Scenario**: Seasonal Analysis - Understanding Purchase Patterns by Time Periods

## Learning Objectives
By the end of this lesson, students will be able to:
- Extract meaningful date components for temporal analysis
- Perform date arithmetic for business calculations
- Format dates and timestamps for reporting
- Analyze seasonal patterns and trends using SQL date functions
- Calculate time-based business metrics (delivery times, seasonal performance)

## Business Context: Brazilian E-commerce Seasonal Analysis
**Setting**: You are a data analyst at "NaijaCommerce," a Nigerian e-commerce platform inspired by the Brazilian Olist marketplace. The executive team wants to understand seasonal buying patterns to optimize inventory, marketing campaigns, and logistics.

**Key Business Questions**:
1. Which months show the highest sales volume and revenue?
2. How do delivery times vary across different seasons?
3. What are the peak shopping periods during the year?
4. How can we identify seasonal trends for better business planning?

## Lesson Structure (120 minutes)

### Part 1: SQL Date Function Fundamentals (40 minutes)

#### 1.1 Understanding Date/Time Data Types (10 minutes)
- `DATE` vs `TIMESTAMP` vs `TIMESTAMP WITH TIME ZONE`
- Working with the Olist dataset's temporal fields
- Data quality considerations with date fields

#### 1.2 Essential Date Extraction Functions (15 minutes)
- `EXTRACT()` function for components (year, month, day, quarter)
- `DATE_TRUNC()` for grouping by time periods
- `DATE_PART()` alternative syntax
- Brazilian vs Nigerian timezone considerations

#### 1.3 Date Formatting and Conversion (15 minutes)
- `TO_CHAR()` for custom date formatting
- Converting strings to dates with `TO_DATE()`
- Handling date parsing errors and NULL values

### Part 2: Temporal Business Analysis (40 minutes)

#### 2.1 Seasonal Sales Pattern Analysis (20 minutes)
- Monthly revenue trends using `EXTRACT(MONTH FROM date)`
- Quarterly performance comparisons
- Year-over-year growth calculations
- Identifying peak shopping seasons

#### 2.2 Day-of-Week and Time-of-Day Analysis (20 minutes)
- Extracting weekday patterns for marketing timing
- Hour-based analysis for customer behavior
- Weekend vs weekday shopping patterns
- Creating business-friendly day names

### Part 3: Advanced Date Arithmetic & Business Metrics (40 minutes)

#### 3.1 Date Arithmetic for Delivery Analysis (20 minutes)
- Calculating delivery times using date subtraction
- Age calculations and interval operations
- Working with `INTERVAL` data type
- Performance metrics across time periods

#### 3.2 Time-Based Business Intelligence (20 minutes)
- Rolling averages and moving windows
- Period-over-period comparisons
- Lead and lag calculations for trend analysis
- Creating time-based cohorts

## Practical Exercises Focus Areas

### Exercise 1: Basic Date Extraction
- Extract month, quarter, and year from order dates
- Create readable date formats for business reports
- Handle missing date values appropriately

### Exercise 2: Seasonal Revenue Analysis
- Calculate monthly and quarterly revenue totals
- Identify peak sales months and seasons
- Compare year-over-year performance

### Exercise 3: Delivery Performance Metrics
- Calculate average delivery times by month
- Analyze delivery performance trends
- Identify seasonal logistics challenges

### Exercise 4: Customer Behavior Patterns
- Analyze shopping patterns by day of week
- Calculate peak shopping hours
- Understand seasonal customer preferences

## Key SQL Functions Covered

### Date Extraction Functions
```sql
EXTRACT(YEAR FROM date_column)
EXTRACT(MONTH FROM date_column)
EXTRACT(DAY FROM date_column)
EXTRACT(QUARTER FROM date_column)
EXTRACT(DOW FROM date_column)  -- Day of week
EXTRACT(HOUR FROM timestamp_column)
```

### Date Truncation Functions
```sql
DATE_TRUNC('month', date_column)
DATE_TRUNC('quarter', date_column)
DATE_TRUNC('week', date_column)
```

### Date Formatting Functions
```sql
TO_CHAR(date_column, 'YYYY-MM-DD')
TO_CHAR(date_column, 'Month YYYY')
TO_CHAR(date_column, 'Day')
```

### Date Arithmetic
```sql
date_column1 - date_column2  -- Difference in days
date_column + INTERVAL '30 days'
AGE(end_date, start_date)
```

## Expected Outcomes
Students will gain confidence in:
- Extracting meaningful business insights from temporal data
- Creating time-based business reports and dashboards
- Understanding seasonal business patterns
- Preparing data for time series analysis and forecasting

## Assessment Criteria
- Accuracy in date function usage
- Business relevance of temporal analysis
- Code readability and documentation
- Insight quality from seasonal pattern identification

## Preparation for Wednesday Python Class
This SQL foundation will directly support Wednesday's Python datetime lesson, where students will:
- Use pandas for equivalent temporal analysis
- Work with Python datetime objects
- Create time series visualizations
- Perform similar seasonal analysis using Python tools

## Nigerian Business Context Integration
- Adapt seasonal patterns to Nigerian calendar (rainy/dry seasons)
- Consider local holidays and festivals (Christmas, Eid, Independence Day)
- Discuss timezone considerations for West Africa Time (WAT)
- Reference Nigerian e-commerce platforms like Jumia, Konga for context