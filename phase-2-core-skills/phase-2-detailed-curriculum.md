# Phase 2 Core Skills - Detailed Curriculum (24 Weeks)
**PORA Academy Cohort 5 - Data Analytics & AI Bootcamp**  
**Duration:** August 13, 2025 - March 6, 2026  
**Format:** Wednesdays (Python) & Thursdays (SQL) - 2 hours each session

---

## Program Overview

This Phase 2 curriculum provides synchronized learning of Python and SQL for data analytics, starting from absolute fundamentals and progressing to advanced visualization and project work. Each week addresses the same business concepts through both languages using consistent datasets and real-world Nigerian business scenarios.

**Key Principles:**
- Foundation-first approach starting with core syntax and concepts
- Synchronized Wednesday (Python) and Thursday (SQL) content
- Progressive skill building using Brazilian Olist e-commerce dataset
- Nigerian business context adaptation throughout
- Hands-on exercises with immediate practical application

---

## MONTH 2: FUNDAMENTALS (Weeks 1-4)
*Building Core Syntax and Database Foundations*

### WEEK 1 (Aug 13-14, 2025)
**Business Context:** Introduction to Lagos E-commerce Marketplace Data Analysis

#### Wednesday: Python Syntax & Data Structures Fundamentals
**Learning Objectives:**
- Understand Python syntax and execution environment
- Master basic data types and variable assignment
- Work with fundamental data structures (lists, dictionaries, tuples)

**Detailed Topics:**
1. **Python Environment Setup & Basics** (30 mins)
   - Google Colab interface navigation
   - Code cells vs text cells
   - Print statements and basic output
   - Comments and documentation practices

2. **Variables and Data Types** (45 mins)
   - Variable naming conventions (snake_case)
   - Integers, floats, strings, booleans
   - Type checking with `type()` function
   - String operations and formatting
   - **Exercise:** Create variables for Nigerian business metrics (revenue, customer_count, product_name)

3. **Lists: Foundation Collection Type** (45 mins)
   - List creation and indexing (0-based indexing concept)
   - List methods: append(), remove(), pop(), extend()
   - List slicing and negative indexing
   - Nested lists for tabular data representation
   - **Exercise:** Create lists of Nigerian cities, products, and sales figures

**Hands-on Exercise:**
Create a simple inventory system for a Lagos electronics store using lists and basic operations.

**Assessment:** Code completion exercise with variable creation and list manipulation.

#### Thursday: SQL & RDBMS Fundamentals
**Learning Objectives:**
- Understand database concepts and relational model
- Learn basic SQL syntax and query structure
- Connect to Supabase and explore table structures

**Detailed Topics:**
1. **Database Concepts Introduction** (30 mins)
   - What is a database vs spreadsheet
   - Relational Database Management Systems (RDBMS)
   - Tables, rows, columns, primary keys
   - Database vs Excel: when to use which

2. **SQL Basics and Environment** (45 mins)
   - SQL as a declarative language
   - VS Code SQL extension setup
   - Connecting to Supabase database
   - Understanding the Olist dataset structure
   - **Exercise:** Explore table schemas in olist_sales_data_set

3. **Basic SELECT Statements** (45 mins)
   - SELECT syntax: SELECT column FROM table
   - Selecting all columns with *
   - Basic WHERE clauses with simple conditions
   - Data types in SQL: INTEGER, VARCHAR, DATE, BOOLEAN
   - **Exercise:** Basic queries on customers and orders tables

**Hands-on Exercise:**
Write basic SELECT statements to explore customer data and order information from the Olist dataset.

**Assessment:** SQL query writing exercise with basic SELECT statements.

---

### WEEK 2 (Aug 20-21, 2025)
**Business Context:** Customer Data Analysis for Nigerian Online Retailer

#### Wednesday: Python Operators & Control Structures
**Learning Objectives:**
- Master Python operators for data manipulation
- Understand conditional logic and decision making
- Implement basic loops for data processing

**Detailed Topics:**
1. **Python Operators** (30 mins)
   - Arithmetic operators (+, -, *, /, //, %, **)
   - Comparison operators (==, !=, >, <, >=, <=)
   - Logical operators (and, or, not)
   - Membership operators (in, not in)
   - **Exercise:** Calculate profit margins and commission rates

2. **Conditional Statements** (45 mins)
   - if, elif, else structure
   - Nested conditionals
   - Ternary operators for simple conditions
   - Boolean logic in decision making
   - **Exercise:** Customer categorization based on purchase history

3. **Introduction to Loops** (45 mins)
   - for loops with lists and ranges
   - while loops for conditional iteration
   - break and continue statements
   - Loop control and best practices
   - **Exercise:** Process customer orders with loop-based calculations

**Hands-on Exercise:**
Build a customer classification system that categorizes customers as "Premium", "Regular", or "New" based on purchase criteria.

**Assessment:** Programming exercise requiring conditionals and loops.

#### Thursday: SQL Filtering & Conditional Logic
**Learning Objectives:**
- Master WHERE clause conditions and operators
- Use SQL logical operators for complex filtering
- Handle NULL values appropriately

**Detailed Topics:**
1. **WHERE Clause Deep Dive** (30 mins)
   - Comparison operators in SQL
   - String matching with LIKE and wildcards (%, _)
   - IN operator for multiple value matching
   - BETWEEN for range queries
   - **Exercise:** Filter customers by location and registration date

2. **Logical Operators in SQL** (45 mins)
   - AND, OR, NOT operators
   - Operator precedence and parentheses
   - Complex conditional logic
   - **Exercise:** Find customers meeting multiple criteria

3. **Handling NULL Values** (45 mins)
   - Understanding NULL in databases
   - IS NULL and IS NOT NULL
   - NULL behavior in comparisons
   - COALESCE for NULL handling
   - **Exercise:** Clean data queries handling missing information

**Hands-on Exercise:**
Create complex queries to segment customers based on geographic location, purchase behavior, and registration patterns.

**Assessment:** SQL filtering exercise with complex WHERE conditions.

---

### WEEK 3 (Aug 27-28, 2025)
**Business Context:** Product Performance Analysis for Multi-Category Retailer

#### Wednesday: Python Dictionaries & Data Organization
**Learning Objectives:**
- Master dictionary operations for key-value data storage
- Understand nested data structures
- Process structured data efficiently

**Detailed Topics:**
1. **Dictionary Fundamentals** (30 mins)
   - Dictionary creation and key-value concepts
   - Dictionary methods: keys(), values(), items()
   - Adding, updating, and removing dictionary elements
   - Dictionary comprehensions introduction
   - **Exercise:** Create product catalog with categories and prices

2. **Nested Data Structures** (45 mins)
   - Lists of dictionaries (records/rows concept)
   - Dictionaries containing lists (grouped data)
   - Accessing nested elements
   - Real-world data structure patterns
   - **Exercise:** Build customer order history structure

3. **Data Processing with Dictionaries** (45 mins)
   - Iterating through dictionaries
   - Counting and aggregation patterns
   - Grouping data by categories
   - Dictionary-based lookup operations
   - **Exercise:** Calculate product category sales summaries

**Hands-on Exercise:**
Analyze product performance data stored in nested dictionaries, calculating category-wise metrics and top-performing items.

**Assessment:** Data processing exercise using dictionaries and nested structures.

#### Thursday: SQL Sorting & Pattern Matching
**Learning Objectives:**
- Sort query results effectively
- Use pattern matching for text analysis
- Combine filtering with ordering

**Detailed Topics:**
1. **ORDER BY Fundamentals** (30 mins)
   - Single column sorting (ASC/DESC)
   - Multiple column sorting priorities
   - Sorting with expressions and functions
   - NULL values in sorting
   - **Exercise:** Sort products by price and popularity

2. **Advanced Pattern Matching** (45 mins)
   - LIKE with complex wildcard patterns
   - ILIKE for case-insensitive matching
   - Regular expressions (where supported)
   - String functions: UPPER(), LOWER(), LENGTH()
   - **Exercise:** Find products matching specific naming patterns

3. **Combining Filtering and Sorting** (45 mins)
   - Complex queries with WHERE and ORDER BY
   - Performance considerations
   - Query optimization basics
   - **Exercise:** Product catalog queries with filtering and sorting

**Hands-on Exercise:**
Create queries to analyze product catalogs, finding items matching specific criteria and presenting results in meaningful order.

**Assessment:** Complex SQL queries combining filtering, pattern matching, and sorting.

---

### WEEK 4 (Sep 3-4, 2025)
**Business Context:** Sales Performance Dashboard Data Preparation

#### Wednesday: Python Functions & Code Organization
**Learning Objectives:**
- Create reusable functions for data processing
- Understand function parameters and return values
- Organize code into logical, maintainable structures

**Detailed Topics:**
1. **Function Fundamentals** (30 mins)
   - Function definition with def keyword
   - Parameters and arguments (positional and keyword)
   - Return statements and return values
   - Function documentation with docstrings
   - **Exercise:** Create functions for common business calculations

2. **Function Parameters & Scope** (45 mins)
   - Default parameter values
   - Variable scope (local vs global)
   - Lambda functions for simple operations
   - Function as first-class objects
   - **Exercise:** Build modular sales calculation functions

3. **Code Organization Patterns** (45 mins)
   - Breaking complex problems into functions
   - Function composition and chaining
   - Error handling basics with try/except
   - **Exercise:** Create a complete data processing pipeline

**Hands-on Exercise:**
Build a sales analysis toolkit with functions for calculating metrics, formatting output, and processing customer data.

**Assessment:** Function creation exercise with real-world business logic.

#### Thursday: SQL Aggregate Functions & Grouping
**Learning Objectives:**
- Master SQL aggregate functions for data summarization
- Use GROUP BY for categorical analysis
- Apply HAVING for filtered aggregations

**Detailed Topics:**
1. **Aggregate Functions** (30 mins)
   - COUNT(), SUM(), AVG(), MIN(), MAX()
   - COUNT(*) vs COUNT(column)
   - Aggregate functions with NULL handling
   - **Exercise:** Calculate basic sales statistics

2. **GROUP BY Fundamentals** (45 mins)
   - Grouping concept and syntax
   - Single column grouping
   - Multiple column grouping
   - Aggregates with grouping
   - **Exercise:** Sales performance by category and region

3. **HAVING Clause** (45 mins)
   - HAVING vs WHERE differences
   - Filtering grouped results
   - Complex HAVING conditions
   - **Exercise:** Find high-performing product categories

**Hands-on Exercise:**
Create comprehensive sales reports using aggregation and grouping to analyze performance across different dimensions.

**Assessment:** SQL aggregation queries for business reporting.

---

## MONTH 3: INTERMEDIATE CONCEPTS (Weeks 5-8)
*Building Data Manipulation and Analysis Skills*

### WEEK 5 (Sep 10-11, 2025)
**Business Context:** Customer Segmentation and Behavior Analysis

#### Wednesday: Python Libraries Introduction (Pandas Basics)
**Learning Objectives:**
- Install and import essential data libraries
- Understand pandas DataFrame structure
- Perform basic data loading and exploration

**Detailed Topics:**
1. **Library Installation and Imports** (30 mins)
   - pip install in Colab environment
   - Importing pandas, numpy with aliases
   - Understanding library documentation
   - **Exercise:** Set up data analysis environment

2. **DataFrame Fundamentals** (45 mins)
   - Creating DataFrames from dictionaries and lists
   - DataFrame structure: index, columns, values
   - Basic DataFrame attributes and methods
   - Data type conversion and inspection
   - **Exercise:** Load customer data into DataFrame

3. **Data Exploration Basics** (45 mins)
   - head(), tail(), info(), describe() methods
   - Shape, columns, and index properties
   - Basic data selection and filtering
   - **Exercise:** Explore Olist customer dataset structure

**Hands-on Exercise:**
Load and explore the Olist customer dataset, performing initial data quality assessment and basic exploration.

**Assessment:** DataFrame creation and exploration exercise.

#### Thursday: SQL Joins Introduction
**Learning Objectives:**
- Understand relational database relationships
- Master INNER JOIN for combining tables
- Apply joins to real business scenarios

**Detailed Topics:**
1. **Relational Database Relationships** (30 mins)
   - Primary keys and foreign keys
   - One-to-many and many-to-many relationships
   - Entity relationship concepts
   - **Exercise:** Identify relationships in Olist schema

2. **INNER JOIN Fundamentals** (45 mins)
   - JOIN syntax and table aliases
   - Joining on single and multiple columns
   - Qualifying column names
   - **Exercise:** Join customers with orders

3. **Business Applications of Joins** (45 mins)
   - Customer order history queries
   - Product sales analysis across tables
   - Performance implications of joins
   - **Exercise:** Create comprehensive customer-order reports

**Hands-on Exercise:**
Build customer analysis queries by joining multiple tables to create comprehensive customer profiles with order history.

**Assessment:** Multi-table join queries for business analysis.

---

### WEEK 6 (Sep 17-18, 2025)
**Business Context:** Product Catalog Management and Pricing Analysis

#### Wednesday: Pandas Data Manipulation
**Learning Objectives:**
- Filter and subset DataFrame data
- Apply transformations and calculations
- Handle missing data appropriately

**Detailed Topics:**
1. **DataFrame Filtering** (30 mins)
   - Boolean indexing and conditions
   - Multiple condition filtering with & and |
   - isin() method for multiple value filtering
   - Query method for complex conditions
   - **Exercise:** Filter products by category and price range

2. **Data Transformations** (45 mins)
   - Creating new columns with calculations
   - apply() method for custom functions
   - String operations on text columns
   - **Exercise:** Calculate profit margins and price categories

3. **Missing Data Handling** (45 mins)
   - Identifying missing values with isna()
   - Strategies: dropna() vs fillna()
   - Forward fill, backward fill, and interpolation
   - **Exercise:** Clean product catalog data

**Hands-on Exercise:**
Process and clean the Olist products dataset, creating derived metrics and handling data quality issues.

**Assessment:** Data cleaning and transformation exercise.

#### Thursday: SQL Advanced Joins
**Learning Objectives:**
- Master LEFT, RIGHT, and FULL OUTER JOINs
- Handle NULL values in join results
- Optimize join performance

**Detailed Topics:**
1. **LEFT and RIGHT JOINs** (30 mins)
   - Understanding outer join concepts
   - LEFT JOIN for preserving left table data
   - RIGHT JOIN applications
   - **Exercise:** Find customers with and without orders

2. **FULL OUTER JOIN** (45 mins)
   - Complete data preservation scenarios
   - UNION operations as alternative
   - Handling NULL values in outer joins
   - **Exercise:** Complete customer-order relationship analysis

3. **Join Optimization** (45 mins)
   - Index usage in joins
   - Join order considerations
   - Query performance monitoring
   - **Exercise:** Optimize complex multi-table queries

**Hands-on Exercise:**
Create comprehensive reports using various join types to analyze customer behavior and product performance with complete data coverage.

**Assessment:** Complex join scenarios with business requirements.

---

### WEEK 7 (Sep 24-25, 2025)
**Business Context:** Time Series Analysis for Sales Trends

#### Wednesday: Pandas Time Series Basics
**Learning Objectives:**
- Work with datetime data in pandas
- Perform time-based filtering and grouping
- Calculate time-based business metrics

**Detailed Topics:**
1. **DateTime Handling** (30 mins)
   - Converting strings to datetime
   - datetime indexing and properties
   - Date arithmetic and time deltas
   - **Exercise:** Parse order dates and calculate delivery times

2. **Time-Based Filtering** (45 mins)
   - Date range filtering
   - Extracting date components (year, month, day)
   - Business calendar considerations
   - **Exercise:** Filter orders by Nigerian holiday periods

3. **Time Series Aggregation** (45 mins)
   - Grouping by time periods
   - Resampling data to different frequencies
   - Rolling window calculations
   - **Exercise:** Calculate monthly sales trends

**Hands-on Exercise:**
Analyze sales trends over time, identifying seasonal patterns and calculating key time-based metrics for business planning.

**Assessment:** Time series analysis exercise with business insights.

#### Thursday: SQL Date Functions & Window Functions
**Learning Objectives:**
- Master SQL date/time functions
- Understand window functions for advanced analytics
- Apply running calculations and rankings

**Detailed Topics:**
1. **Date Functions in SQL** (30 mins)
   - DATE_TRUNC for period grouping
   - EXTRACT for date component extraction
   - Date arithmetic and intervals
   - **Exercise:** Group sales by month and quarter

2. **Window Functions Introduction** (45 mins)
   - ROW_NUMBER(), RANK(), DENSE_RANK()
   - Window frame concepts (ROWS vs RANGE)
   - PARTITION BY for grouped calculations
   - **Exercise:** Rank customers by purchase frequency

3. **Running Calculations** (45 mins)
   - SUM() OVER for cumulative totals
   - Moving averages with window frames
   - LAG() and LEAD() for period comparisons
   - **Exercise:** Calculate running sales totals

**Hands-on Exercise:**
Create time-based analytics queries using window functions to identify trends, rankings, and running calculations.

**Assessment:** Advanced SQL with window functions and date analysis.

---

### WEEK 8 (Oct 1, 2025 - NIGERIAN INDEPENDENCE DAY HOLIDAY)
**Alternative Schedule: Single Session Focus**

### WEEK 8 (Oct 2, 2025 - Thursday Only)
**Business Context:** Advanced Data Aggregation Techniques

#### Thursday: SQL Advanced Analytics
**Learning Objectives:**
- Master complex aggregation scenarios
- Use CASE statements for conditional logic
- Create pivot-like reports in SQL

**Detailed Topics:**
1. **Conditional Aggregation** (40 mins)
   - CASE statements in aggregations
   - Conditional counting and summing
   - NULL handling in aggregates
   - **Exercise:** Create sales performance scorecard

2. **Pivot Operations in SQL** (40 mins)
   - Manual pivot with CASE and GROUP BY
   - Cross-tabulation techniques
   - Dynamic column creation
   - **Exercise:** Product category performance matrix

3. **Advanced GROUP BY Features** (40 mins)
   - GROUPING SETS for multiple groupings
   - ROLLUP and CUBE for subtotals
   - Complex analytical requirements
   - **Exercise:** Hierarchical sales reporting

**Hands-on Exercise:**
Build comprehensive analytical reports using advanced SQL techniques for multi-dimensional business analysis.

**Assessment:** Complex analytical SQL queries.

---

## MONTH 4: ADVANCED DATA OPERATIONS (Weeks 9-12)
*Mastering Complex Data Analysis and Manipulation*

### WEEK 9 (Oct 8-9, 2025)
**Business Context:** Customer Lifetime Value Analysis

#### Wednesday: Pandas Advanced Operations
**Learning Objectives:**
- Master pandas groupby operations
- Perform multi-index data manipulation
- Create complex aggregations and transformations

**Detailed Topics:**
1. **GroupBy Mastery** (30 mins)
   - Single and multiple column grouping
   - Aggregate functions and custom aggregations
   - Transform operations within groups
   - **Exercise:** Customer purchase behavior analysis

2. **Multi-Index Operations** (45 mins)
   - Creating hierarchical indexes
   - Unstacking and pivoting data
   - Cross-tabulation with pd.crosstab()
   - **Exercise:** Product-customer purchase matrix

3. **Advanced Aggregations** (45 mins)
   - Custom aggregation functions
   - Named aggregations with agg()
   - Combining multiple operations
   - **Exercise:** Customer lifetime value calculations

**Hands-on Exercise:**
Calculate comprehensive customer lifetime value metrics using advanced pandas operations and customer segmentation analysis.

**Assessment:** Complex customer analytics with pandas groupby operations.

#### Thursday: SQL Subqueries & CTEs
**Learning Objectives:**
- Write and optimize subqueries
- Use Common Table Expressions (CTEs)
- Implement correlated subqueries

**Detailed Topics:**
1. **Subquery Fundamentals** (30 mins)
   - WHERE clause subqueries
   - FROM clause subqueries (derived tables)
   - SELECT clause subqueries
   - **Exercise:** Find customers above average purchase amount

2. **Common Table Expressions (CTEs)** (45 mins)
   - WITH clause syntax
   - Multiple CTE definitions
   - Recursive CTEs introduction
   - **Exercise:** Customer ranking and segmentation

3. **Correlated Subqueries** (45 mins)
   - Understanding correlation concept
   - EXISTS and NOT EXISTS
   - Performance considerations
   - **Exercise:** Customer purchase pattern analysis

**Hands-on Exercise:**
Create complex analytical queries using CTEs and subqueries to perform customer segmentation and advanced business analysis.

**Assessment:** Advanced SQL with subqueries and CTEs.

---

### WEEK 10 (Oct 15-16, 2025)
**Business Context:** Inventory Management and Supply Chain Analysis

#### Wednesday: Pandas Data Merging & Reshaping
**Learning Objectives:**
- Master pandas merge operations
- Reshape data between wide and long formats
- Handle complex data combination scenarios

**Detailed Topics:**
1. **DataFrame Merging** (30 mins)
   - Inner, outer, left, right merges
   - Merge on index vs columns
   - Handling duplicate keys and conflicts
   - **Exercise:** Combine product and inventory data

2. **Data Reshaping** (45 mins)
   - melt() for wide-to-long transformation
   - pivot() and pivot_table() for aggregations
   - Stack and unstack operations
   - **Exercise:** Transform sales data for analysis

3. **Concatenation and Combining** (45 mins)
   - concat() for combining DataFrames
   - Handling different indexes and columns
   - Append operations and best practices
   - **Exercise:** Combine multiple data sources

**Hands-on Exercise:**
Build comprehensive inventory analysis by merging multiple data sources and reshaping data for optimal analysis structure.

**Assessment:** Data merging and reshaping exercise with business requirements.

#### Thursday: SQL Advanced Data Modeling
**Learning Objectives:**
- Design normalized database structures
- Implement data integrity constraints
- Create views for business logic

**Detailed Topics:**
1. **Database Normalization Review** (30 mins)
   - First, second, third normal forms
   - Denormalization for analytics
   - Trade-offs in design decisions
   - **Exercise:** Analyze Olist schema design

2. **Views and Materialized Views** (45 mins)
   - Creating views for complex business logic
   - View security and access control
   - Materialized view performance benefits
   - **Exercise:** Create customer summary views

3. **Data Integrity** (45 mins)
   - Constraints and referential integrity
   - Check constraints for business rules
   - Trigger concepts for data validation
   - **Exercise:** Design integrity rules for e-commerce data

**Hands-on Exercise:**
Design and implement views that encapsulate complex business logic for recurring analytical needs.

**Assessment:** Database design and view creation exercise.

---

### WEEK 11 (Oct 22-23, 2025)
**Business Context:** Marketing Campaign Performance Analysis

#### Wednesday: Data Visualization with Matplotlib
**Learning Objectives:**
- Create basic plots and charts
- Customize visualization aesthetics
- Tell stories with data visualizations

**Detailed Topics:**
1. **Matplotlib Fundamentals** (30 mins)
   - Figure and axes concepts
   - Basic plot types: line, bar, scatter
   - Plot customization basics
   - **Exercise:** Create sales trend visualizations

2. **Advanced Plot Customization** (45 mins)
   - Colors, markers, and line styles
   - Labels, titles, and legends
   - Subplots for multiple visualizations
   - **Exercise:** Marketing campaign performance dashboard

3. **Business Storytelling** (45 mins)
   - Choosing appropriate chart types
   - Highlighting key insights
   - Color psychology and accessibility
   - **Exercise:** Executive summary visualizations

**Hands-on Exercise:**
Create a comprehensive marketing campaign analysis with multiple visualizations that tell a clear business story.

**Assessment:** Data visualization exercise with business narrative.

#### Thursday: SQL Performance Optimization
**Learning Objectives:**
- Understand query execution plans
- Optimize query performance
- Use indexes effectively

**Detailed Topics:**
1. **Query Performance Analysis** (30 mins)
   - EXPLAIN and EXPLAIN ANALYZE
   - Reading execution plans
   - Identifying performance bottlenecks
   - **Exercise:** Analyze slow query performance

2. **Index Strategy** (45 mins)
   - B-tree indexes for common queries
   - Composite indexes for multiple columns
   - Index maintenance considerations
   - **Exercise:** Design optimal indexing strategy

3. **Query Optimization Techniques** (45 mins)
   - Rewriting queries for performance
   - Join optimization strategies
   - Avoiding common anti-patterns
   - **Exercise:** Optimize complex analytical queries

**Hands-on Exercise:**
Optimize a suite of business intelligence queries for improved performance and scalability.

**Assessment:** Query optimization and performance tuning exercise.

---

### WEEK 12 (Oct 29-30, 2025)
**Business Context:** Financial Analysis and Reporting

#### Wednesday: Statistical Analysis with Python
**Learning Objectives:**
- Perform descriptive statistical analysis
- Understand correlation and relationships
- Apply basic statistical tests

**Detailed Topics:**
1. **Descriptive Statistics** (30 mins)
   - Central tendency and spread measures
   - Distribution analysis and percentiles
   - Outlier detection methods
   - **Exercise:** Financial performance statistical summary

2. **Correlation Analysis** (45 mins)
   - Pearson and Spearman correlations
   - Correlation matrices and heatmaps
   - Understanding causation vs correlation
   - **Exercise:** Revenue driver correlation analysis

3. **Basic Statistical Testing** (45 mins)
   - Hypothesis testing concepts
   - t-tests for mean comparisons
   - Chi-square tests for categorical data
   - **Exercise:** A/B test analysis for marketing campaigns

**Hands-on Exercise:**
Perform comprehensive statistical analysis of financial performance data to identify key business drivers and relationships.

**Assessment:** Statistical analysis exercise with business interpretation.

#### Thursday: SQL Advanced Analytics Functions
**Learning Objectives:**
- Master statistical functions in SQL
- Perform advanced analytical calculations
- Create sophisticated business metrics

**Detailed Topics:**
1. **Statistical Functions in SQL** (30 mins)
   - STDDEV, VARIANCE for spread measures
   - PERCENTILE_CONT and PERCENTILE_DISC
   - Statistical aggregations
   - **Exercise:** Customer behavior statistical analysis

2. **Advanced Window Functions** (45 mins)
   - FIRST_VALUE and LAST_VALUE
   - Complex window frame definitions
   - Analytical functions for business metrics
   - **Exercise:** Customer journey analysis

3. **Business Intelligence Patterns** (45 mins)
   - Cohort analysis techniques
   - Retention rate calculations
   - Complex KPI definitions
   - **Exercise:** Customer retention metrics

**Hands-on Exercise:**
Build comprehensive business intelligence queries that calculate advanced metrics for executive reporting.

**Assessment:** Advanced analytical SQL with business intelligence applications.

---

## MONTH 5: GOOGLE LOOKER STUDIO (Weeks 13-16)
*Visual Analytics and Business Intelligence Dashboards*

### WEEK 13 (Nov 5-6, 2025)
**Business Context:** Executive Dashboard Development

#### Wednesday: Data Preparation for Visualization
**Learning Objectives:**
- Prepare clean datasets for dashboard consumption
- Export data in visualization-ready formats
- Understand data modeling for BI tools

**Detailed Topics:**
1. **Data Cleaning for Dashboards** (30 mins)
   - Data quality standards for visualization
   - Handling missing values and outliers
   - Standardizing formats and categories
   - **Exercise:** Clean Olist data for dashboard consumption

2. **Data Export and Formatting** (45 mins)
   - CSV export best practices
   - JSON format for complex structures
   - Database connection preparation
   - **Exercise:** Prepare multiple datasets for Looker Studio

3. **Data Modeling Concepts** (45 mins)
   - Star schema design principles
   - Fact and dimension table concepts
   - Aggregation strategies for performance
   - **Exercise:** Design dashboard data model

**Hands-on Exercise:**
Prepare comprehensive, clean datasets optimized for business dashboard creation with proper data modeling.

**Assessment:** Data preparation and modeling exercise.

#### Thursday: Looker Studio Fundamentals
**Learning Objectives:**
- Navigate Looker Studio interface
- Connect to data sources
- Create basic charts and visualizations

**Detailed Topics:**
1. **Looker Studio Interface** (30 mins)
   - Dashboard creation workflow
   - Data source connections
   - Report vs dashboard concepts
   - **Exercise:** Connect to prepared datasets

2. **Basic Visualizations** (45 mins)
   - Chart types: bar, line, pie, table
   - Chart configuration and customization
   - Filter and control components
   - **Exercise:** Create sales performance charts

3. **Data Source Management** (45 mins)
   - Multiple data source handling
   - Data blending basics
   - Calculated fields introduction
   - **Exercise:** Blend customer and order data

**Hands-on Exercise:**
Create a basic sales performance dashboard with multiple chart types and interactive filters.

**Assessment:** Basic Looker Studio dashboard creation.

---

### WEEK 14 (Nov 12-13, 2025)
**Business Context:** Marketing Performance Analytics Dashboard

#### Wednesday: Advanced Data Aggregation for BI
**Learning Objectives:**
- Create pre-aggregated datasets for dashboard performance
- Design calculated metrics and KPIs
- Implement data refresh strategies

**Detailed Topics:**
1. **Pre-Aggregation Strategies** (30 mins)
   - Summary table creation
   - Time-based aggregations
   - Multi-dimensional rollups
   - **Exercise:** Create marketing metrics summary tables

2. **KPI Calculation Logic** (45 mins)
   - Business metric definitions
   - Complex calculation implementations
   - Ratio and percentage calculations
   - **Exercise:** Implement marketing ROI calculations

3. **Data Pipeline Design** (45 mins)
   - Automated data refresh concepts
   - Error handling in data pipelines
   - Data validation and quality checks
   - **Exercise:** Design marketing dashboard data pipeline

**Hands-on Exercise:**
Build comprehensive marketing performance datasets with automated KPI calculations and validation logic.

**Assessment:** Advanced data pipeline and KPI implementation.

#### Thursday: Advanced Looker Studio Features
**Learning Objectives:**
- Master calculated fields and custom metrics
- Implement advanced chart customizations
- Create interactive dashboard experiences

**Detailed Topics:**
1. **Calculated Fields Mastery** (30 mins)
   - Mathematical operations and functions
   - Conditional logic with CASE statements
   - Date and string manipulation functions
   - **Exercise:** Create complex marketing metrics

2. **Advanced Chart Features** (45 mins)
   - Custom styling and branding
   - Drill-down capabilities
   - Chart interactions and linking
   - **Exercise:** Interactive marketing campaign analysis

3. **Dashboard Interactivity** (45 mins)
   - Parameter controls and filters
   - Cross-filtering between charts
   - User experience optimization
   - **Exercise:** Build interactive marketing dashboard

**Hands-on Exercise:**
Create an advanced marketing performance dashboard with complex calculated metrics and full interactivity.

**Assessment:** Advanced Looker Studio dashboard with complex features.

---

### WEEK 15 (Nov 19-20, 2025)
**Business Context:** Customer Analytics and Segmentation Dashboard

#### Wednesday: Customer Segmentation Analysis
**Learning Objectives:**
- Implement RFM analysis for customer segmentation
- Create customer lifecycle metrics
- Design predictive scoring models

**Detailed Topics:**
1. **RFM Analysis Implementation** (30 mins)
   - Recency, Frequency, Monetary calculations
   - Scoring and ranking methodologies
   - Customer segment definitions
   - **Exercise:** Calculate RFM scores for Olist customers

2. **Customer Lifecycle Metrics** (45 mins)
   - Customer acquisition cost (CAC)
   - Customer lifetime value (CLV)
   - Churn prediction indicators
   - **Exercise:** Build customer lifecycle dashboard data

3. **Predictive Scoring** (45 mins)
   - Simple scoring algorithms
   - Risk assessment calculations
   - Propensity modeling basics
   - **Exercise:** Create customer health scores

**Hands-on Exercise:**
Build comprehensive customer segmentation analysis with RFM methodology and lifecycle metrics for targeted marketing.

**Assessment:** Customer segmentation and scoring implementation.

#### Thursday: Looker Studio Advanced Analytics
**Learning Objectives:**
- Create cohort analysis visualizations
- Implement funnel and conversion tracking
- Build executive summary scorecards

**Detailed Topics:**
1. **Cohort Analysis Visualization** (30 mins)
   - Cohort table design principles
   - Retention rate visualizations
   - Time-based cohort analysis
   - **Exercise:** Customer retention cohort dashboard

2. **Conversion Funnel Analysis** (45 mins)
   - Funnel chart configurations
   - Step-by-step conversion tracking
   - Drop-off analysis visualization
   - **Exercise:** E-commerce conversion funnel

3. **Executive Scorecards** (45 mins)
   - KPI scorecard design principles
   - Traffic light and gauge charts
   - Summary metrics presentation
   - **Exercise:** Executive customer analytics scorecard

**Hands-on Exercise:**
Create comprehensive customer analytics dashboard with cohort analysis, funnels, and executive summary views.

**Assessment:** Advanced customer analytics dashboard with multiple visualization types.

---

### WEEK 16 (Nov 26-27, 2025)
**Business Context:** Financial Performance and Operations Dashboard

#### Wednesday: Financial Analysis Automation
**Learning Objectives:**
- Automate financial calculations and reports
- Create variance analysis systems
- Implement financial forecasting basics

**Detailed Topics:**
1. **Automated Financial Calculations** (30 mins)
   - Revenue recognition automation
   - Cost allocation algorithms
   - Margin analysis calculations
   - **Exercise:** Automate profit and loss calculations

2. **Variance Analysis Systems** (45 mins)
   - Budget vs actual comparisons
   - Variance calculation and classification
   - Trend analysis and alerts
   - **Exercise:** Build budget variance analysis

3. **Basic Financial Forecasting** (45 mins)
   - Time series forecasting concepts
   - Trend and seasonality analysis
   - Simple prediction algorithms
   - **Exercise:** Revenue forecasting model

**Hands-on Exercise:**
Build comprehensive financial analysis system with automated calculations, variance analysis, and basic forecasting capabilities.

**Assessment:** Financial automation and forecasting implementation.

#### Thursday: Looker Studio Integration and Sharing
**Learning Objectives:**
- Master data source integration techniques
- Implement dashboard sharing and security
- Create automated reporting workflows

**Detailed Topics:**
1. **Advanced Data Integration** (30 mins)
   - Multiple data source blending
   - Real-time data connections
   - API data source integration
   - **Exercise:** Integrate financial data from multiple sources

2. **Dashboard Security and Sharing** (45 mins)
   - Access control and permissions
   - Scheduled report delivery
   - Embedding dashboards in websites
   - **Exercise:** Set up executive dashboard sharing

3. **Automated Reporting Workflows** (45 mins)
   - Email automation and scheduling
   - Conditional alerts and notifications
   - Report versioning and archiving
   - **Exercise:** Automated financial reporting system

**Hands-on Exercise:**
Create fully integrated financial performance dashboard with automated sharing and security controls.

**Assessment:** Complete dashboard integration and automation project.

---

## MONTH 6: STREAMLIT APPLICATIONS (Weeks 17-20)
*Interactive Web Applications for Data Analytics*

### WEEK 17 (Dec 3-4, 2025)
**Business Context:** Interactive Sales Analytics Application

#### Wednesday: Streamlit Fundamentals
**Learning Objectives:**
- Set up Streamlit development environment
- Create basic interactive web applications
- Understand Streamlit's reactive programming model

**Detailed Topics:**
1. **Streamlit Environment Setup** (30 mins)
   - Installation and configuration
   - Running Streamlit applications locally
   - Understanding the development workflow
   - **Exercise:** Create first Streamlit "Hello World" app

2. **Basic Streamlit Components** (45 mins)
   - Text display: st.write(), st.markdown(), st.title()
   - Data display: st.dataframe(), st.table()
   - Input widgets: st.slider(), st.selectbox(), st.text_input()
   - **Exercise:** Build basic sales data explorer

3. **Streamlit Reactive Model** (45 mins)
   - Understanding app reruns and state
   - Widget callbacks and interactions
   - Session state basics
   - **Exercise:** Interactive sales filter application

**Hands-on Exercise:**
Create an interactive sales analytics application that allows users to filter and explore the Olist dataset.

**Assessment:** Basic Streamlit application development.

#### Thursday: SQL to Python Integration
**Learning Objectives:**
- Connect Python applications to SQL databases
- Execute dynamic SQL queries from Python
- Handle database connections and error management

**Detailed Topics:**
1. **Database Connectivity** (30 mins)
   - SQLAlchemy and database engines
   - Connection string configuration
   - Connection pooling concepts
   - **Exercise:** Connect Streamlit to Supabase database

2. **Dynamic SQL Query Execution** (45 mins)
   - Parameterized queries for security
   - Query result handling in pandas
   - Error handling and validation
   - **Exercise:** Build dynamic query interface

3. **Performance Optimization** (45 mins)
   - Query caching strategies
   - Connection management
   - Lazy loading techniques
   - **Exercise:** Optimize database queries for web app

**Hands-on Exercise:**
Build database-connected analytics application with dynamic querying capabilities and proper error handling.

**Assessment:** Database integration and dynamic query implementation.

---

### WEEK 18 (Dec 10-11, 2025)
**Business Context:** Customer Service Dashboard Application

*Note: Last regular classes before extended December break*

#### Wednesday: Advanced Streamlit Features
**Learning Objectives:**
- Implement advanced Streamlit layouts and styling
- Create complex interactive components
- Build professional-looking applications

**Detailed Topics:**
1. **Layout and Styling** (30 mins)
   - Columns and containers for layout
   - Sidebar and tabs organization
   - CSS styling and themes
   - **Exercise:** Professional dashboard layout

2. **Advanced Components** (45 mins)
   - Charts with st.plotly_chart() and st.altair_chart()
   - File upload and download functionality
   - Custom components and HTML integration
   - **Exercise:** Interactive customer service metrics

3. **State Management** (45 mins)
   - Session state for multi-page applications
   - Caching with @st.cache_data
   - Performance optimization techniques
   - **Exercise:** Multi-page customer analytics app

**Hands-on Exercise:**
Build comprehensive customer service dashboard with advanced layouts, interactive components, and efficient state management.

**Assessment:** Advanced Streamlit application with professional UI.

#### Thursday: Application Deployment Fundamentals
**Learning Objectives:**
- Prepare applications for production deployment
- Understand deployment options and requirements
- Implement basic security and configuration management

**Detailed Topics:**
1. **Deployment Preparation** (30 mins)
   - Requirements.txt creation
   - Environment configuration
   - Code organization for production
   - **Exercise:** Prepare customer service app for deployment

2. **Security Considerations** (45 mins)
   - Environment variable management
   - Database connection security
   - User authentication basics
   - **Exercise:** Implement secure configuration

3. **Deployment Options** (45 mins)
   - Streamlit Cloud deployment
   - Alternative hosting platforms
   - Domain and SSL configuration
   - **Exercise:** Deploy application to Streamlit Cloud

**Hands-on Exercise:**
Deploy customer service dashboard application with proper security configuration and production settings.

**Assessment:** Application deployment and security implementation.

---

**EXTENDED DECEMBER BREAK: December 12, 2025 - January 7, 2026**
*Students encouraged to practice skills and work on portfolio projects*

---

### WEEK 19 (Jan 8-9, 2026)
**Business Context:** Inventory Management Application

#### Wednesday: Multi-Page Streamlit Applications
**Learning Objectives:**
- Create complex multi-page applications
- Implement navigation and user flow
- Build modular, maintainable code structures

**Detailed Topics:**
1. **Multi-Page Architecture** (30 mins)
   - Page organization and navigation
   - Shared components and utilities
   - State management across pages
   - **Exercise:** Inventory management app structure

2. **Advanced Data Visualization** (45 mins)
   - Interactive Plotly charts
   - Custom visualization components
   - Real-time data updates
   - **Exercise:** Inventory trend visualizations

3. **User Experience Design** (45 mins)
   - Form handling and validation
   - Progress indicators and feedback
   - Error handling and user guidance
   - **Exercise:** Inventory management workflows

**Hands-on Exercise:**
Build comprehensive inventory management application with multiple pages, advanced visualizations, and excellent user experience.

**Assessment:** Multi-page application development with advanced features.

#### Thursday: Real-Time Data Integration
**Learning Objectives:**
- Implement real-time data updates
- Handle streaming data scenarios
- Create responsive applications

**Detailed Topics:**
1. **Real-Time Data Patterns** (30 mins)
   - Polling vs push-based updates
   - WebSocket integration concepts
   - Auto-refresh strategies
   - **Exercise:** Real-time inventory monitoring

2. **Data Refresh Strategies** (45 mins)
   - Scheduled updates and caching
   - Incremental data loading
   - Performance optimization
   - **Exercise:** Efficient inventory data updates

3. **Responsive Application Design** (45 mins)
   - Loading states and placeholders
   - Error recovery mechanisms
   - User notification systems
   - **Exercise:** Robust inventory tracking system

**Hands-on Exercise:**
Implement real-time inventory tracking application with automatic updates and responsive user interface.

**Assessment:** Real-time application development with data integration.

---

### WEEK 20 (Jan 15-16, 2026)
**Business Context:** Executive Decision Support System

#### Wednesday: Advanced Analytics in Streamlit
**Learning Objectives:**
- Implement machine learning models in web applications
- Create predictive analytics interfaces
- Build decision support tools

**Detailed Topics:**
1. **ML Model Integration** (30 mins)
   - Scikit-learn model deployment
   - Model prediction interfaces
   - Model performance monitoring
   - **Exercise:** Customer churn prediction app

2. **Predictive Analytics Dashboard** (45 mins)
   - Forecasting model implementation
   - Interactive parameter tuning
   - Scenario analysis tools
   - **Exercise:** Sales forecasting interface

3. **Decision Support Features** (45 mins)
   - What-if analysis capabilities
   - Optimization recommendations
   - Risk assessment tools
   - **Exercise:** Executive decision dashboard

**Hands-on Exercise:**
Build executive decision support system with predictive analytics, scenario modeling, and recommendation engines.

**Assessment:** Advanced analytics application with ML integration.

#### Thursday: Application Testing and Quality Assurance
**Learning Objectives:**
- Implement application testing strategies
- Ensure code quality and reliability
- Create maintenance and monitoring systems

**Detailed Topics:**
1. **Application Testing** (30 mins)
   - Unit testing for Streamlit applications
   - Integration testing with databases
   - User acceptance testing strategies
   - **Exercise:** Test executive dashboard functionality

2. **Code Quality and Documentation** (45 mins)
   - Code organization and best practices
   - Documentation generation
   - Version control for applications
   - **Exercise:** Document and organize decision support system

3. **Monitoring and Maintenance** (45 mins)
   - Application performance monitoring
   - Error logging and debugging
   - Update and maintenance workflows
   - **Exercise:** Implement monitoring for production app

**Hands-on Exercise:**
Implement comprehensive testing and quality assurance for executive decision support system.

**Assessment:** Application testing and quality assurance implementation.

---

## MONTH 7: CAPSTONE PROJECTS (Weeks 21-24)
*Comprehensive Data Analytics Projects*

### WEEK 21 (Jan 22-23, 2026)
**Business Context:** Project Planning and Design Phase

#### Wednesday: Project Scope and Requirements
**Learning Objectives:**
- Define comprehensive project requirements
- Design project architecture and data flow
- Create project timeline and deliverables

**Detailed Topics:**
1. **Project Selection and Scoping** (30 mins)
   - Available project options analysis
   - Stakeholder requirement gathering
   - Success criteria definition
   - **Exercise:** Choose and scope capstone project

2. **Technical Architecture Design** (45 mins)
   - Data pipeline architecture
   - Technology stack selection
   - Integration points identification
   - **Exercise:** Design project technical architecture

3. **Project Planning** (45 mins)
   - Work breakdown structure
   - Timeline and milestone definition
   - Risk assessment and mitigation
   - **Exercise:** Create detailed project plan

**Hands-on Exercise:**
Complete comprehensive project planning documentation including requirements, architecture, and detailed timeline.

**Assessment:** Project planning and design documentation.

#### Thursday: Data Architecture and Pipeline Design
**Learning Objectives:**
- Design robust data architectures
- Plan efficient data pipelines
- Implement data quality frameworks

**Detailed Topics:**
1. **Data Architecture Design** (30 mins)
   - Source system analysis
   - Data modeling for analytics
   - Storage and processing requirements
   - **Exercise:** Design project data architecture

2. **ETL Pipeline Planning** (45 mins)
   - Extract, transform, load process design
   - Data validation and quality checks
   - Error handling and recovery
   - **Exercise:** Plan project data pipeline

3. **Performance and Scalability** (45 mins)
   - Query optimization strategies
   - Indexing and partitioning plans
   - Monitoring and alerting design
   - **Exercise:** Design performance optimization strategy

**Hands-on Exercise:**
Create comprehensive data architecture and pipeline design for capstone project implementation.

**Assessment:** Data architecture and pipeline design documentation.

---

### WEEK 22 (Jan 29-30, 2026)
**Business Context:** Implementation Phase - Data Processing

#### Wednesday: Data Collection and Preprocessing
**Learning Objectives:**
- Implement data collection systems
- Build robust data cleaning pipelines
- Create data validation frameworks

**Detailed Topics:**
1. **Data Collection Implementation** (30 mins)
   - API integration and data extraction
   - File processing automation
   - Database connectivity setup
   - **Exercise:** Implement project data collection

2. **Data Cleaning and Validation** (45 mins)
   - Automated data quality checks
   - Missing value handling strategies
   - Outlier detection and treatment
   - **Exercise:** Build data validation pipeline

3. **Data Transformation Pipeline** (45 mins)
   - Business logic implementation
   - Calculated field creation
   - Data aggregation strategies
   - **Exercise:** Implement transformation logic

**Hands-on Exercise:**
Build complete data processing pipeline from collection through transformation with comprehensive quality controls.

**Assessment:** Data processing pipeline implementation and testing.

#### Thursday: Advanced SQL for Project Analytics
**Learning Objectives:**
- Implement complex analytical queries
- Create project-specific database objects
- Optimize queries for project requirements

**Detailed Topics:**
1. **Project-Specific Analytics** (30 mins)
   - Complex business logic in SQL
   - Multi-table analytical queries
   - Performance-optimized implementations
   - **Exercise:** Implement key project analytics

2. **Database Objects Creation** (45 mins)
   - Views for business logic encapsulation
   - Stored procedures for complex operations
   - Indexes for query optimization
   - **Exercise:** Create project database objects

3. **Query Performance Optimization** (45 mins)
   - Execution plan analysis
   - Index strategy implementation
   - Query rewriting for efficiency
   - **Exercise:** Optimize project queries

**Hands-on Exercise:**
Create comprehensive SQL analytics framework optimized for project-specific requirements and performance goals.

**Assessment:** Advanced SQL implementation with performance optimization.

---

### WEEK 23 (Feb 5-6, 2026)
**Business Context:** Implementation Phase - Application Development

#### Wednesday: Dashboard and Application Development
**Learning Objectives:**
- Build comprehensive analytics dashboards
- Implement interactive features
- Create user-friendly interfaces

**Detailed Topics:**
1. **Dashboard Implementation** (30 mins)
   - Multi-page dashboard architecture
   - Advanced visualization creation
   - Interactive component development
   - **Exercise:** Build project main dashboard

2. **Advanced Features Implementation** (45 mins)
   - Predictive analytics integration
   - Real-time data updates
   - Export and sharing capabilities
   - **Exercise:** Implement advanced dashboard features

3. **User Experience Optimization** (45 mins)
   - Performance optimization
   - Error handling and validation
   - Accessibility considerations
   - **Exercise:** Optimize dashboard user experience

**Hands-on Exercise:**
Complete comprehensive dashboard application with advanced features and optimized user experience.

**Assessment:** Complete dashboard application with advanced functionality.

#### Thursday: Integration Testing and Quality Assurance
**Learning Objectives:**
- Implement comprehensive testing strategies
- Ensure system reliability and performance
- Create documentation and maintenance procedures

**Detailed Topics:**
1. **System Integration Testing** (30 mins)
   - End-to-end workflow testing
   - Data pipeline validation
   - User acceptance testing
   - **Exercise:** Complete system integration testing

2. **Performance Testing and Optimization** (45 mins)
   - Load testing strategies
   - Performance bottleneck identification
   - Optimization implementation
   - **Exercise:** Performance test and optimize system

3. **Documentation and Maintenance** (45 mins)
   - User documentation creation
   - Technical documentation
   - Maintenance procedures
   - **Exercise:** Create comprehensive project documentation

**Hands-on Exercise:**
Complete system testing, optimization, and documentation for production-ready deployment.

**Assessment:** System testing, performance optimization, and documentation.

---

### WEEK 24 (Feb 12-13, 2026)
**Business Context:** Project Finalization and Presentation

#### Wednesday: Final Implementation and Deployment
**Learning Objectives:**
- Complete project implementation
- Deploy to production environment
- Implement monitoring and maintenance systems

**Detailed Topics:**
1. **Final Implementation** (30 mins)
   - Remaining feature completion
   - Bug fixes and final testing
   - Production configuration
   - **Exercise:** Complete project implementation

2. **Production Deployment** (45 mins)
   - Deployment to cloud platform
   - Security configuration
   - Performance monitoring setup
   - **Exercise:** Deploy project to production

3. **Monitoring and Maintenance Setup** (45 mins)
   - Application monitoring implementation
   - Automated alerting configuration
   - Backup and recovery procedures
   - **Exercise:** Implement production monitoring

**Hands-on Exercise:**
Complete project deployment with full production configuration, monitoring, and maintenance procedures.

**Assessment:** Production deployment and monitoring implementation.

#### Thursday: Project Presentation and Portfolio Development
**Learning Objectives:**
- Create compelling project presentations
- Develop professional portfolios
- Demonstrate technical and business value

**Detailed Topics:**
1. **Project Presentation Development** (30 mins)
   - Business value demonstration
   - Technical implementation showcase
   - Results and impact presentation
   - **Exercise:** Create project presentation materials

2. **Portfolio Development** (45 mins)
   - GitHub portfolio organization
   - Project documentation for portfolio
   - Professional presentation preparation
   - **Exercise:** Organize portfolio materials

3. **Final Presentations** (45 mins)
   - Individual project presentations
   - Peer feedback and evaluation
   - Portfolio review and discussion
   - **Exercise:** Present final projects

**Hands-on Exercise:**
Complete project presentations and finalize professional portfolios showcasing Phase 2 achievements.

**Assessment:** Final project presentation and portfolio evaluation.

---

## Assessment Framework

### Weekly Assessment Structure
- **Formative Assessment:** Hands-on exercises each session (40% of grade)
- **Practical Application:** Weekly mini-projects (30% of grade)
- **Technical Implementation:** Code quality and documentation (20% of grade)
- **Business Application:** Real-world problem solving (10% of grade)

### Month-End Evaluations
1. **Month 2:** Fundamentals mastery test
2. **Month 3:** Intermediate concepts project
3. **Month 4:** Advanced operations portfolio
4. **Month 5:** Looker Studio dashboard portfolio
5. **Month 6:** Streamlit application portfolio
6. **Month 7:** Capstone project presentation and defense

### Professional Development Components
- **GitHub Portfolio:** Maintained throughout Phase 2
- **Technical Documentation:** Best practices for code documentation
- **Business Communication:** Presenting technical results to non-technical stakeholders
- **Peer Collaboration:** Group exercises and peer review sessions

---

## Resources and Support Materials

### Required Tools and Software
- **Python Environment:** Google Colab (primary), local Jupyter setup (optional)
- **SQL Environment:** VS Code with SQL extensions
- **Database:** Supabase (provided access)
- **Visualization:** Google Looker Studio, Matplotlib, Plotly
- **Development:** Streamlit, Git/GitHub

### Dataset Resources
- **Primary Dataset:** Brazilian Olist E-commerce Dataset
- **Supplementary Data:** Nigerian business context adaptations
- **Practice Datasets:** Additional e-commerce and business datasets

### Learning Support
- **Office Hours:** Weekly instructor availability
- **Peer Learning:** Study groups and collaboration sessions
- **AI Assistance:** Structured AI troubleshooting curriculum (introduced after Month 4)
- **Industry Mentorship:** Access to data analytics professionals

### Success Metrics
- **Technical Proficiency:** 80% minimum on practical assessments
- **Project Quality:** Professional-grade deliverables suitable for portfolio
- **Business Application:** Demonstrated ability to solve real-world problems
- **Career Readiness:** Complete portfolio and presentation skills

---

*This curriculum is designed to transform Excel users into confident Python and SQL practitioners capable of building complete data analytics solutions. The synchronized approach ensures students see both languages as complementary tools for solving the same business challenges, building a strong foundation for data analytics careers.*

---

**Program Timeline Summary:**
- **Start Date:** August 13, 2025
- **End Date:** March 6, 2026 (extended from February 27 due to holiday accommodations)
- **Total Sessions:** 46 sessions (2 per week × 23 weeks, accounting for holiday breaks)
- **Holiday Accommodations:** Nigerian national holidays observed with schedule adjustments
- **Capstone Projects:** 4 weeks of intensive project work leading to portfolio-ready deliverables