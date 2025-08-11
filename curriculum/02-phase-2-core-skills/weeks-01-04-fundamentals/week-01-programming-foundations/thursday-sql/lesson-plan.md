# Week 01 - Programming Foundations - Thursday SQL Session

## Session Overview
**Date**: August 14, 2025  
**Duration**: 2 hours  
**Platform**: SQL/VS Code with PostgreSQL  
**Business Scenario**: Same NaijaCommerce/Olist e-commerce analysis from Wednesday - now using databases  
**Building On**: Wednesday's Python DataFrame concepts translated to SQL tables

## Learning Objectives
By the end of this session, students will be able to:
- [ ] Connect Wednesday's Python DataFrame concepts to SQL table operations
- [ ] Successfully connect to Supabase database using VS Code
- [ ] Write basic SELECT statements to explore table structure (SQL equivalent of df.head())
- [ ] Understand database schemas and table relationships (databases = Excel workbooks, tables = worksheets)
- [ ] Use LIMIT, ORDER BY, and basic WHERE clauses (SQL equivalents of Python indexing)
- [ ] Explore data types and table schemas (SQL equivalent of df.info())
- [ ] Recognize direct parallels between Python operations and SQL queries

## Session Structure

### Opening: Python to SQL Bridge (10 minutes)
**"Yesterday in Python, Today in SQL"**
- Quick review: "Remember your DataFrame success from yesterday?"
- Direct translations: `df.head()` → `SELECT * LIMIT 5`
- Same business questions, different tool
- Preview: By end of class, you'll query the same Olist data from Wednesday

**Excel → Python → SQL Connections:**
- Excel Worksheet = Python DataFrame = SQL Table
- Excel Workbook = Python multiple DataFrames = SQL Database Schema
- Excel filters = Python boolean indexing = SQL WHERE clauses

### Topic 1: Database Concepts & Connection Setup (35 minutes)

**Subtopics:**
- Database vs. Excel: Workbooks with multiple interconnected worksheets
- Tables = DataFrames = Excel worksheets (same concept, different tool)
- Schemas as organized folders of related tables
- VS Code setup and Supabase connection (like opening an Excel workbook)

**Activities:**
- Connect to Supabase NaijaCommerce database
- Explore available schemas and tables (like browsing worksheet tabs)
- Compare database structure to Wednesday's Python file structure
- Success metric: Successfully view table list in VS Code

**Python-SQL Parallels:**
```python
# Yesterday in Python:
import pandas as pd
df = pd.read_csv('orders.csv')
```
```sql
-- Today in SQL:
SELECT * FROM olist_sales_data_set.olist_orders_dataset;
```

**Resources:**
- `notebooks/01_database_concepts.ipynb` - Side-by-side Python-SQL comparison
- `scripts/01_connection_setup.sql` - Database connection verification

### Topic 2: Basic SELECT Statements & Data Exploration (35 minutes)

**Subtopics:**
- SELECT = "show me columns" (like selecting columns in Excel)
- FROM = "from this table" (like specifying worksheet)
- LIMIT = df.head() equivalent
- Column selection vs. SELECT * (specific columns vs. all columns)

**Activities:**
- Write first SELECT statements using orders table
- Practice column selection (SELECT specific columns)
- Use LIMIT to view manageable data chunks
- Compare results to Wednesday's Python df.head() outputs

**Direct Python-SQL Translation:**
```python
# Wednesday Python:
print(df.head())
print(df.columns)
print(df.shape)
```
```sql
-- Thursday SQL:
SELECT * FROM olist_sales_data_set.olist_orders_dataset LIMIT 5;
SELECT column_name FROM information_schema.columns WHERE table_name = 'olist_orders_dataset';
SELECT COUNT(*) FROM olist_sales_data_set.olist_orders_dataset;
```

**Resources:**
- `scripts/02_basic_select.sql` - Progressive SELECT examples
- `exercises/sql_vs_python_comparison.md` - Side-by-side syntax guide

### Topic 3: Data Types and Schema Exploration (35 minutes)

**Subtopics:**
- SQL data types: VARCHAR (text), INTEGER (whole numbers), DECIMAL (floats), DATE/TIMESTAMP
- Schema exploration: understanding table structure without opening the data
- DESCRIBE equivalent queries for PostgreSQL
- Column aliases for readable output (like renaming DataFrame columns)

**Activities:**
- Explore orders table schema (column names, data types, constraints)
- Compare to Wednesday's df.info() and df.dtypes outputs
- Practice using column aliases for business-friendly names
- Identify primary keys and foreign keys (unique identifiers)

**Python-SQL Schema Comparison:**
```python
# Wednesday Python:
print(df.info())
print(df.dtypes)
print(df.describe())
```
```sql
-- Thursday SQL:
SELECT column_name, data_type, is_nullable 
FROM information_schema.columns 
WHERE table_name = 'olist_orders_dataset';

SELECT 
  COUNT(*) as total_rows,
  COUNT(DISTINCT order_id) as unique_orders,
  MIN(order_purchase_timestamp) as earliest_order,
  MAX(order_purchase_timestamp) as latest_order
FROM olist_sales_data_set.olist_orders_dataset;
```

**Resources:**
- `scripts/03_schema_exploration.sql` - Schema discovery queries
- `exercises/data_types_practice.sql` - Hands-on data type identification

### Topic 4: Business Questions with Basic Queries (30 minutes)

**Subtopics:**
- Answering the same business questions from Wednesday using SQL
- ORDER BY for sorting (like DataFrame.sort_values())
- COUNT() for counting records (like len(df))
- Basic aggregation functions: COUNT, MIN, MAX, AVG

**Activities:**
- Count total orders (same as Wednesday's len(df))
- Find oldest and newest orders (same as Wednesday's min/max operations)
- Sort orders by date (same as Wednesday's sort_values())
- Create readable column names using aliases

**Same Questions, Different Tools:**
```python
# Wednesday Python approach:
total_orders = len(df)
oldest_order = df['order_purchase_timestamp'].min()
sorted_orders = df.sort_values('order_purchase_timestamp')
```
```sql
-- Thursday SQL approach:
SELECT COUNT(*) as total_orders FROM olist_sales_data_set.olist_orders_dataset;
SELECT MIN(order_purchase_timestamp) as oldest_order FROM olist_sales_data_set.olist_orders_dataset;
SELECT * FROM olist_sales_data_set.olist_orders_dataset ORDER BY order_purchase_timestamp LIMIT 10;
```

**Resources:**
- `scripts/04_business_queries.sql` - Real business question examples
- `exercises/python_to_sql_translation.sql` - Convert Python code to SQL

### Wrap-up & Preview (5 minutes)
**Knowledge Check:**
- Quick comparison: Show Python code, write SQL equivalent
- Error identification: Spot the SQL syntax error
- Confidence builder: "You just queried a real database!"

**Next Session Preview (Week 02):**
- Monday Python: Filtering DataFrames with conditions (boolean indexing)
- Thursday SQL: WHERE clauses and complex conditions
- Same filtering concepts, both tools

**Assignment Instructions:**
- Complete practice exercises comparing Python and SQL approaches
- Explore additional tables in the Olist database
- Document your observations: "How is SQL similar to Python?"

## Materials Needed
- [ ] `notebooks/01_database_concepts.ipynb` - Visual comparison of concepts
- [ ] `scripts/01_connection_setup.sql` - Database setup verification
- [ ] `scripts/02_basic_select.sql` - Progressive SELECT examples  
- [ ] `scripts/03_schema_exploration.sql` - Table structure queries
- [ ] `scripts/04_business_queries.sql` - Real business applications
- [ ] `exercises/sql_vs_python_comparison.md` - Side-by-side syntax reference

## Assessment

**Formative Assessment:**
- Live query writing during each segment
- Peer discussion: "Explain this SQL concept using yesterday's Python knowledge"
- Quick syntax correction exercises throughout session
- Confidence check: "What's the Python equivalent of this SQL query?"

**Summative Assessment:**
- End-of-session challenge: "Query Your First Database"
- Criteria: Write queries to explore table structure, count records, sort results
- Submit completed SQL script with reflection comments comparing to Python

## Homework/Follow-up
**Assignment**: Complete `exercises/week_01_sql_practice.sql`
- **Due**: Before Week 2 Wednesday's Python session
- **Components**:
  1. Basic SELECT queries with business context
  2. Schema exploration of different tables
  3. Simple aggregation queries (COUNT, MIN, MAX)
  4. Reflection essay: "SQL vs. Python: Same Logic, Different Syntax"

**Extension Activities for Early Finishers:**
- Explore additional tables in olist_sales_data_set schema
- Try basic JOIN operations between orders and customers tables
- Research SQL best practices and document findings
- Create a personal "Python to SQL" translation cheat sheet

## Instructor Notes

**Special Preparation Needed:**
- Test Supabase database connection from VS Code beforehand
- Prepare backup queries in case of connection issues
- Have Wednesday's Python notebooks open for side-by-side comparisons
- Create troubleshooting guide for common SQL syntax errors

**Common Student Difficulties:**
1. **SQL syntax overwhelm** (quotes, semicolons, case sensitivity)
   - *Solution*: Start with simple queries, build complexity gradually
   - *Python parallel*: "Remember learning pandas syntax yesterday? Same process."
2. **Forgetting table names and schemas**
   - *Solution*: Keep schema reference visible, use tab completion in VS Code
3. **"This seems harder than Python!"** mindset
   - *Solution*: Show direct equivalents, emphasize same logical thinking
4. **Connection and setup issues**
   - *Solution*: Pair programming, pre-tested connection strings

**Confidence Building Strategies:**
- Start each concept with "Remember from yesterday in Python..."
- Use identical business questions from Wednesday's session
- Celebrate syntax victories: "You just wrote your first SQL query!"
- Show data results that match Wednesday's Python outputs

**Time Management Tips:**
- Database setup: 15 minutes (critical foundation time)
- Basic SELECT: 30 minutes (core skill building)
- Schema exploration: 25 minutes (understanding data structure)
- Business queries: 30 minutes (practical application)
- Keep examples simple; complexity comes later

**Synchronization with Wednesday:**
- Use identical Olist tables that correspond to Wednesday's CSV files
- Reference specific Python code examples from Wednesday
- Show same business insights using different tools
- Maintain same NaijaCommerce business narrative

## Resources

**Lecture Materials:**
- `01_database_concepts.ipynb` - Visual explanations with Python parallels
- `02_basic_select.sql` - Progressive query examples with explanations
- `03_schema_exploration.sql` - Table structure discovery techniques
- `04_business_queries.sql` - Real-world application examples

**Exercise Files:**
- `exercises/week_01_sql_practice.sql` - Guided practice problems
- `exercises/database_exploration_challenge.sql` - Open-ended exploration
- `exercises/python_sql_reflection.md` - Structured comparison thinking

**Support Resources:**
- `resources/sql_syntax_cheatsheet.md` - Quick reference for common operations
- `resources/python_to_sql_dictionary.md` - Direct operation translations
- `resources/sql_error_guide.md` - Common error interpretation and solutions
- `resources/vscode_sql_setup.md` - Step-by-step database connection guide

**Connection Information:**
- Supabase URL and connection details
- Schema access permissions for students
- Sample queries for connection testing
- Troubleshooting guide for connection issues

---

**Note for Instructors**: This lesson builds directly on Wednesday's Python success. Every SQL concept should reference the equivalent Python operation students learned yesterday. The goal is showing that the same logical thinking applies to both tools - we're just changing the syntax, not the approach.