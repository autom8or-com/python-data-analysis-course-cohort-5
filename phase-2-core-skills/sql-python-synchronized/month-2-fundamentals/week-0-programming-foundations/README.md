# Week 0: Programming Foundations & Mindset
**From Excel User to Programmer**

## Overview
**Duration**: 2 sessions (Wednesday & Thursday)  
**Goal**: Help students understand what programming actually is and build confidence before diving into code.

## The Big Picture: What is Programming?

### Programming vs Excel: Same Brain, Different Tools

**Excel User Mindset**:
- "I want to calculate the total sales" → Click SUM button
- "I want to filter data" → Click filter dropdown  
- "I want to create a chart" → Insert chart wizard

**Programmer Mindset**:
- "I want to calculate the total sales" → Write instruction: `SUM(sales_column)`
- "I want to filter data" → Write instruction: `WHERE condition`
- "I want to create a chart" → Write instruction: `plot(data)`

**Key Insight**: Programming is just **writing down the steps** instead of **clicking through the steps**.

---

## Session 1: Programming Demystified

### What We'll Cover (1 hour)

#### Part 1: Breaking Down the Fear (20 minutes)

**Common Myths vs Reality**:

| Myth | Reality |
|------|---------|
| "Programming is only for math geniuses" | "It's like writing recipes - step by step instructions" |
| "You need to memorize everything" | "Programmers Google syntax all the time" |
| "One mistake breaks everything" | "Mistakes are normal and easily fixable" |
| "It's completely different from Excel" | "It's the same logic, different syntax" |

#### Part 2: Programming Languages Explained (20 minutes)

**Think of Languages Like Different Calculators**:

- **SQL**: Like a specialized calculator for asking questions about data stored in tables
- **Python**: Like a Swiss Army knife - can do calculations, data analysis, websites, automation
- **Excel**: Like a visual calculator with point-and-click interface

**Why Learn Both SQL and Python?**:
- **SQL**: For data stored in databases (most business data)
- **Python**: For analysis, automation, and combining multiple data sources
- **Together**: Complete toolkit for any data challenge

#### Part 3: Understanding Syntax and Errors (20 minutes)

**Syntax = Grammar Rules**

**English Grammar**:
- "The cat sat on the mat" ✓
- "Cat the mat on sat the" ✗

**Programming Grammar**:
- `SELECT name FROM customers` ✓
- `FROM customers SELECT name` ✗

**Error Messages Are Your Friends**:
- They tell you exactly what's wrong
- They're not personal attacks on your intelligence
- Every programmer sees hundreds of error messages daily

---

## Session 2: Getting Your Hands Dirty

### What We'll Cover (1 hour)

#### Part 1: Your First Lines of Code (30 minutes)

**Python "Hello World"**:
```python
# This is a comment - it explains what the code does
print("Hello, Data Analyst!")

# Variables are like named cells in Excel
my_name = "Your Name Here"
print("Hello,", my_name)

# Numbers work like Excel calculations
sales_total = 1000 + 500 + 750
print("Total sales:", sales_total)
```

**SQL "Hello World"**:
```sql
-- This is a comment in SQL
SELECT 'Hello, Data Analyst!' as greeting;

-- This is like asking "what's in this spreadsheet?"
SELECT * FROM olist_sales_data_set.orders LIMIT 5;

-- This is like counting rows in Excel
SELECT COUNT(*) as total_orders FROM olist_sales_data_set.orders;
```

#### Part 2: Understanding the Development Environment (30 minutes)

**Google Colab (Python)**:
- Like Excel, but for code
- Each "cell" contains code instead of formulas
- Press Shift+Enter to "calculate" the cell
- Results appear below, just like Excel shows results

**VS Code + Supabase (SQL)**:
- Like a specialized Excel for database queries
- Write query, run query, see results
- Results show in table format, just like Excel

---

## Key Concepts to Master This Week

### 1. Variables (Python) = Named Cells (Excel)

**Excel**:
```
A1: 100
A2: 200  
A3: =A1+A2    (shows 300)
```

**Python**:
```python
price = 100
tax = 200
total = price + tax    # equals 300
```

### 2. Comments = Documentation

**Excel**: You might write notes in nearby cells
**Programming**: You write comments in the code

```python
# This calculates the total with tax
total = price + tax
```

```sql
-- This finds all delivered orders
SELECT * FROM orders WHERE status = 'delivered';
```

### 3. Data Types = Different Kinds of Information

**Excel automatically guesses**:
- Numbers look like numbers
- Text looks like text  
- Dates look like dates

**Programming requires clarity**:
- `"Hello"` = text (string)
- `123` = number (integer)
- `123.45` = decimal number (float)
- `True/False` = yes/no (boolean)

---

## Confidence Building Exercises

### Exercise 1: Variables and Basic Operations
```python
# Fill in your information
student_name = "Your Name"
favorite_number = 42
years_using_excel = 5

# Let the computer do the math
print("Hello", student_name)
print("In 10 years, you'll have", years_using_excel + 10, "years of Excel experience")
print("Your favorite number times 2 is", favorite_number * 2)
```

### Exercise 2: Your First SQL Query
```sql
-- Look at the data structure (like opening a new Excel file)
SELECT * FROM olist_sales_data_set.orders LIMIT 3;

-- Count something (like using COUNTA in Excel)
SELECT COUNT(*) as "Total Orders" FROM olist_sales_data_set.orders;
```

### Exercise 3: Error Recovery Practice
**Intentionally make mistakes and fix them**:

```python
# This has an error - can you spot it?
print("Hello World"    # Missing closing parenthesis

# This has an error too
my_age = "25"
next_year = my_age + 1  # Can't add number to text
```

---

## Homework: Programming Mindset Journal

### Day 1 Reflection (after Python session):
1. **What felt familiar?** What connections did you make to Excel?
2. **What felt strange?** What was different from what you expected?
3. **Error Practice**: Make an intentional mistake in Python, read the error message, and fix it. What did you learn?

### Day 2 Reflection (after SQL session):
1. **SQL vs Excel**: How did writing SQL queries feel compared to using Excel formulas?
2. **Database vs Spreadsheet**: What differences did you notice between tables in a database vs worksheets in Excel?
3. **Confidence Check**: On a scale of 1-10, how ready do you feel to learn more programming? What would boost your confidence?

---

## Success Checklist

By the end of Week 0, you should be able to:

- [ ] **Explain** what programming is in simple terms
- [ ] **Write** a basic Python print statement
- [ ] **Write** a basic SQL SELECT statement  
- [ ] **Create** and use variables in Python
- [ ] **Read** simple error messages without panic
- [ ] **Connect** programming concepts to Excel equivalents
- [ ] **Feel confident** that you can learn this!

---

## Instructor Notes

### Red Flags to Watch For:
- Students saying "I'm not a programmer" (remind them they already are!)
- Perfectionism (emphasize that errors are normal)
- Overwhelm (slow down, return to Excel analogies)
- Comparing to others (everyone learns at their own pace)

### Success Indicators:
- Students asking "Can I do X with code?"
- Students experimenting with variations
- Students helping each other debug errors
- Students connecting concepts to their work experience

### Common Questions & Answers:
**Q**: "Do I need to memorize all this syntax?"  
**A**: "No more than you memorized every Excel function. You learn the patterns."

**Q**: "What if I break something?"  
**A**: "You can't break anything that can't be easily fixed. That's why we practice!"

**Q**: "Is this going to be too hard for me?"  
**A**: "You already think logically about data. We're just learning a new language to express what you already know."

---

*Remember: The goal this week is confidence and understanding, not mastery of syntax.*