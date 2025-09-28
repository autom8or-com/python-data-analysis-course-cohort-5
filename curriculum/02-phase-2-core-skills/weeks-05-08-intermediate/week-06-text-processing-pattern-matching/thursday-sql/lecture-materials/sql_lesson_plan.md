# Week 6 SQL Lesson Plan: Text Processing & Pattern Matching
## Thursday, September 18, 2025

### Overview
**Duration**: 2 hours
**Business Context**: Product categorization and data standardization for Nigerian e-commerce platform
**Excel Bridge**: TEXT functions, FIND, SUBSTITUTE, CONCATENATE

### Learning Objectives
By the end of this lesson, students will be able to:
1. Clean and standardize text data using SQL string functions
2. Extract patterns from unstructured text using LIKE and regular expressions
3. Standardize product categories and customer location data
4. Handle data quality issues common in e-commerce datasets
5. Create standardized categorization systems for business analysis

### Lesson Structure

#### Part 1: SQL String Functions Fundamentals (45 minutes)
**Excel Connection**: Moving from TEXT, UPPER, LOWER, TRIM functions

**Topics Covered:**
- **Basic String Functions**
  - `UPPER()`, `LOWER()`, `INITCAP()` for case standardization
  - `TRIM()`, `LTRIM()`, `RTRIM()` for whitespace cleaning
  - `LENGTH()` for text measurement

- **String Modification Functions**
  - `REPLACE()` for text substitution (Excel SUBSTITUTE equivalent)
  - `SUBSTRING()` for text extraction (Excel MID equivalent)
  - `CONCAT()` and `||` for text joining (Excel CONCATENATE equivalent)

**Business Scenario 1**: Standardizing Brazilian city names for shipping analysis
- Clean inconsistent city name formatting
- Handle case variations and extra spaces
- Create standardized location categories

#### Part 2: Pattern Matching with LIKE and ILIKE (30 minutes)
**Excel Connection**: Moving from FIND and search functions

**Topics Covered:**
- **LIKE Pattern Matching**
  - Wildcard operators: `%` (multiple characters), `_` (single character)
  - Case-sensitive vs case-insensitive matching
  - `ILIKE` for case-insensitive patterns

- **Complex Pattern Examples**
  - Finding product categories with specific patterns
  - Identifying review comments with certain characteristics
  - Categorizing marketing lead sources

**Business Scenario 2**: Product categorization pattern identification
- Extract product family patterns from Portuguese names
- Identify seasonal product categories
- Create automated classification rules

#### Part 3: Introduction to Regular Expressions (25 minutes)
**Excel Connection**: Advanced pattern matching beyond Excel capabilities

**Topics Covered:**
- **Basic Regex Patterns**
  - Character classes: `[a-z]`, `[0-9]`, `\w`, `\d`
  - Quantifiers: `+`, `*`, `?`, `{n}`
  - Anchors: `^` (start), `$` (end)

- **SQL Regex Functions**
  - `REGEXP_MATCHES()` for pattern extraction
  - `REGEXP_REPLACE()` for pattern-based substitution
  - `REGEXP_SPLIT_TO_ARRAY()` for text splitting

**Business Scenario 3**: Review sentiment pattern extraction
- Extract key phrases from customer reviews
- Identify product quality indicators
- Standardize review categorization

### Real Data Examples

#### Dataset Usage
- **Primary**: `olist_order_reviews_dataset` for text cleaning
- **Secondary**: `product_category_name_translation` for standardization
- **Tertiary**: `olist_customers_dataset` for location normalization

#### Nigerian Business Context
- Adapt Brazilian e-commerce patterns to Nigerian market
- Focus on Lagos, Abuja, Port Harcourt as major business centers
- Consider multilingual text processing (English, Yoruba, Hausa, Igbo)

### Assessment Integration
- **Formative**: Live coding exercises during each section
- **Summative**: Product categorization project using real Olist data
- **Business Application**: Create text processing rules for Nigerian product catalog

### Tools and Environment
- **Database**: Supabase with Olist datasets
- **SQL Editor**: VS Code with SQL extensions
- **Testing**: Live queries against production-like data

### Preparation Requirements
**For Students:**
- Review Excel TEXT functions worksheet from Phase 1
- Understand basic SQL SELECT and WHERE statements
- Familiarize with business product categorization concepts

**For Instructor:**
- Prepare live database connection
- Set up example queries with expected outputs
- Create debugging scenarios for common text processing errors

### Extension Activities
**Advanced Students:**
- Explore PostgreSQL-specific text functions
- Practice with larger text datasets
- Research multilingual text processing challenges

**Struggling Students:**
- Additional Excel-to-SQL comparison exercises
- Simplified pattern matching examples
- One-on-one debugging support

### Homework Preview
Students will apply text processing techniques to:
1. Clean a messy product catalog dataset
2. Standardize customer location data
3. Extract key insights from review text
4. Create business rules for automated categorization

### Connection to Wednesday Python Class
- Same business scenarios and datasets
- SQL string functions → Python string methods
- SQL LIKE patterns → Python regex
- Database-centric → pandas DataFrame-centric approach