# Month 2 Assessment Rubric
**Programming Fundamentals + Data Analysis Skills**

## Overview
This assessment evaluates both programming fundamentals and practical data analysis skills using the Olist dataset. Students are assessed on their ability to connect Excel knowledge to programming concepts while solving real business problems.

---

## Assessment Components

### 1. Weekly Skill Checks (40% of Month 2 Grade)
**Format**: Short practical exercises completed during class
**Duration**: 15-20 minutes per week
**Purpose**: Immediate feedback on concept mastery

#### Week 0: Programming Mindset
- [ ] **Confidence Check**: Can explain what programming is in simple terms
- [ ] **Error Comfort**: Can read basic error messages without panic
- [ ] **Excel Connection**: Can relate programming concepts to Excel operations

#### Week 1: Fundamentals + Data Exploration
**Programming Skills**:
- [ ] Create variables of different data types (string, integer, float, boolean)
- [ ] Work with lists (create, access, modify)
- [ ] Use dictionaries for key-value pairs
- [ ] Write basic SELECT statements in SQL
- [ ] Understand database terminology

**Data Analysis Skills**:
- [ ] Load data in Python using pandas
- [ ] Query database tables using SQL
- [ ] Filter data using both tools
- [ ] Calculate basic business metrics

#### Week 2: Data Structures + Sorting
**Programming Skills**:
- [ ] Choose appropriate data structure for different scenarios
- [ ] Implement sorting in both Python and SQL
- [ ] Create calculated fields/columns

**Data Analysis Skills**:
- [ ] Sort data by multiple criteria
- [ ] Create business calculations
- [ ] Compare results between tools

#### Week 3: Functions + Aggregations
**Programming Skills**:
- [ ] Define custom functions with parameters
- [ ] Use built-in SQL functions
- [ ] Implement GROUP BY operations

**Data Analysis Skills**:
- [ ] Create reusable business logic
- [ ] Perform aggregations (count, sum, average)
- [ ] Generate summary reports

#### Week 4: Control Flow + Advanced Operations
**Programming Skills**:
- [ ] Implement if/else logic in both languages
- [ ] Use loops for data processing
- [ ] Write CASE statements in SQL

**Data Analysis Skills**:
- [ ] Create conditional business rules
- [ ] Process data iteratively
- [ ] Handle complex business logic

### 2. Programming Concepts Quiz (20% of Month 2 Grade)
**Format**: Multiple choice + short answer
**Duration**: 30 minutes
**Content**: Theory and application of programming fundamentals

#### Sample Questions:

**Multiple Choice**:
```
1. Which Python data structure is most similar to Excel's VLOOKUP table?
   a) List
   b) Dictionary  ✓
   c) Tuple
   d) Set

2. In SQL, what is equivalent to Excel's filter dropdown?
   a) SELECT clause
   b) FROM clause  
   c) WHERE clause  ✓
   d) ORDER BY clause
```

**Short Answer**:
```
3. Explain the difference between a Python list and a dictionary, using an Excel analogy.

Expected Answer: A list is like a single Excel column containing multiple values in order (e.g., A1:A10). A dictionary is like a lookup table with two columns - one for keys (like product names) and one for values (like prices), similar to what you'd use with VLOOKUP.

4. When would you use SQL vs Python for data analysis? Give a specific business scenario for each.

Expected Answer: Use SQL when data is stored in a database and you need to filter/aggregate large datasets efficiently (e.g., "find all orders from last quarter with value > $100"). Use Python when you need to combine multiple data sources, create visualizations, or perform complex calculations not easily done in SQL (e.g., "merge customer data from 3 different files and create predictive models").
```

### 3. Integrated Project (40% of Month 2 Grade)
**Format**: Take-home project using Olist dataset
**Duration**: 1 week (assigned Week 3, due Week 4)
**Purpose**: Demonstrate integrated Python + SQL skills on realistic business problem

#### Project Scenario:
> **You are a junior data analyst at Olist.** The Head of Operations has asked you to prepare a comprehensive analysis of order delivery performance for the monthly executive meeting. You need to use both SQL (for database queries) and Python (for calculations and summary) to answer key business questions.

#### Required Deliverables:

**Part A: SQL Analysis (Database Queries)**
Create SQL queries to answer:
1. **Order Volume**: How many orders were placed each month in 2017?
2. **Delivery Performance**: What percentage of orders are delivered on time vs late?
3. **Geographic Analysis**: Which states have the highest order volumes?
4. **Status Breakdown**: How many orders are in each status category?

**Part B: Python Analysis (Data Processing)**
Using Python, create:
1. **Business Metrics Calculator**: Function to calculate key performance indicators
2. **State Performance Summary**: Dictionary containing metrics for each state
3. **Trend Analysis**: List of monthly performance over time
4. **Executive Summary**: Formatted report with key findings

**Part C: Integration (Connecting Results)**
1. **Comparison**: Verify that SQL and Python give the same basic counts
2. **Business Insights**: Write 3-4 bullet points explaining what the data tells us
3. **Recommendations**: Suggest 2 actionable improvements based on the analysis

#### Grading Rubric for Integrated Project:

| Criteria | Excellent (4) | Proficient (3) | Developing (2) | Beginning (1) |
|----------|---------------|----------------|----------------|---------------|
| **SQL Queries** | All queries correct, efficient, well-commented | Most queries correct, some comments | Basic queries work, minimal comments | Queries incomplete or incorrect |
| **Python Code** | Clean, efficient, good variable names | Functional code, decent structure | Code works but needs improvement | Code errors or poor structure |
| **Programming Concepts** | Proper use of variables, lists, dicts, functions | Good use of most concepts | Basic use of concepts with errors | Limited understanding of concepts |
| **Data Analysis** | Insightful analysis, accurate calculations | Good analysis, mostly accurate | Basic analysis, some errors | Poor analysis, significant errors |
| **Excel Connections** | Clear connections to Excel concepts throughout | Some good Excel analogies | Few Excel connections | No Excel connections shown |
| **Business Context** | Professional insights, actionable recommendations | Good business understanding | Basic business awareness | Limited business context |

---

## Programming Fundamentals Competency Checklist

### Python Skills Assessment:
Students demonstrate competency by:
- [ ] **Variables**: Create and use different data types appropriately
- [ ] **Lists**: Build, access, and modify lists for business data
- [ ] **Dictionaries**: Use key-value pairs for lookups and data organization
- [ ] **Functions**: Write reusable business logic with clear parameters
- [ ] **Control Flow**: Implement conditional logic for business rules
- [ ] **Loops**: Process collections of data efficiently
- [ ] **pandas Basics**: Load CSV data and perform basic operations
- [ ] **Error Handling**: Read error messages and debug simple problems

### SQL Skills Assessment:
Students demonstrate competency by:
- [ ] **Database Concepts**: Understand tables, rows, columns, relationships
- [ ] **SELECT Statements**: Query specific columns and rows
- [ ] **WHERE Clauses**: Filter data based on conditions
- [ ] **Data Types**: Understand and work with different SQL data types
- [ ] **Aggregations**: Use COUNT, SUM, AVG for business metrics
- [ ] **GROUP BY**: Summarize data by categories
- [ ] **CASE Statements**: Implement conditional logic
- [ ] **Basic JOINs**: Connect related tables (introduced in Week 4)

### Integration Skills Assessment:
Students demonstrate competency by:
- [ ] **Tool Selection**: Choose appropriate tool for different tasks
- [ ] **Result Verification**: Cross-check results between Python and SQL
- [ ] **Excel Translation**: Explain programming concepts using Excel analogies
- [ ] **Business Application**: Apply programming skills to solve real problems
- [ ] **Documentation**: Write clear comments explaining their logic
- [ ] **Debugging**: Identify and fix common programming errors

---

## Remediation Guidelines

### Students Scoring Below 70%:
**Immediate Actions**:
1. **One-on-one session** with instructor to identify specific gaps
2. **Supplementary exercises** focusing on weak areas
3. **Peer mentoring** paired with stronger student
4. **Extended deadline** for integrated project (up to 3 additional days)

### Common Remediation Areas:

#### Programming Concepts Confusion:
- **Symptom**: Mixing up data types, incorrect syntax
- **Intervention**: Return to Programming Fundamentals Workbook, practice basic exercises
- **Resources**: Additional Excel-to-code comparison sheets

#### SQL vs Python Confusion:
- **Symptom**: Using Python syntax in SQL or vice versa
- **Intervention**: Side-by-side coding practice, explicit syntax comparison
- **Resources**: Enhanced cheat sheets with common mistakes

#### Business Context Disconnect:
- **Symptom**: Technically correct but no business insight
- **Intervention**: Focus on "why" questions, connect to real scenarios
- **Resources**: Business case studies, executive summary examples

---

## Success Indicators

### Individual Student Success:
- [ ] Can solve same business problem using both Python and SQL
- [ ] Explains code using Excel analogies naturally
- [ ] Writes readable, commented code
- [ ] Debugs simple errors independently
- [ ] Demonstrates confidence in trying new programming tasks

### Class Success Indicators:
- [ ] 80%+ of students score above 70% on integrated project
- [ ] Students help each other debug code during class
- [ ] Students ask "Can I do X with code?" questions
- [ ] Students connect programming to their work experience
- [ ] Students show excitement about automation possibilities

---

## Instructor Reflection Questions

After each assessment:
1. **Concept Clarity**: Which programming concepts need more explanation?
2. **Excel Bridge**: Are students making consistent Excel connections?
3. **Pace**: Is the progression from basic to complex appropriate?
4. **Practical Application**: Do students see the business value of programming?
5. **Confidence**: Are students comfortable making mistakes and learning from them?

---

*Assessment should feel like natural extension of learning, not separate evaluation. Every assessment task should reinforce the Excel-to-programming bridge and build student confidence in their analytical abilities.*