# Week 6 Python Lesson Plan: Text Processing & Pattern Matching
## Wednesday, September 17, 2025

### Overview
**Duration**: 2 hours
**Business Context**: Product categorization and data standardization for Nigerian e-commerce platform
**Excel Bridge**: TEXT functions, FIND, SUBSTITUTE, CONCATENATE

### Learning Objectives
By the end of this lesson, students will be able to:
1. Clean and standardize text data using Python string methods
2. Extract patterns from unstructured text using regular expressions
3. Standardize product categories and customer location data
4. Handle data quality issues common in e-commerce datasets
5. Create standardized categorization systems for business analysis

### Lesson Structure

#### Part 1: Python String Methods Fundamentals (45 minutes)
**Excel Connection**: Moving from TEXT, UPPER, LOWER, TRIM functions

**Topics Covered:**
- **Basic String Methods**
  - `.upper()`, `.lower()`, `.title()` for case standardization
  - `.strip()`, `.lstrip()`, `.rstrip()` for whitespace cleaning
  - `len()` for text measurement

- **String Modification Methods**
  - `.replace()` for text substitution (Excel SUBSTITUTE equivalent)
  - Slicing `[start:end]` for text extraction (Excel MID equivalent)
  - `.join()` and f-strings for text joining (Excel CONCATENATE equivalent)

- **Pandas String Operations**
  - `.str` accessor for vectorized string operations
  - Applying string methods to entire DataFrame columns
  - Handling missing values with string operations

**Business Scenario 1**: Standardizing Brazilian city names for shipping analysis
- Clean inconsistent city name formatting using pandas `.str` methods
- Handle case variations and extra spaces in customer data
- Create standardized location categories for Nigerian market adaptation

#### Part 2: Pattern Matching with String Methods (30 minutes)
**Excel Connection**: Moving from FIND and search functions

**Topics Covered:**
- **Basic Pattern Matching**
  - `.startswith()` and `.endswith()` for prefix/suffix matching
  - `.contains()` for substring detection
  - `.find()` and `.index()` for position finding

- **Complex Pattern Examples**
  - Finding product categories with specific patterns
  - Identifying review comments with certain characteristics
  - Categorizing marketing lead sources using pattern detection

**Business Scenario 2**: Product categorization pattern identification
- Extract product family patterns from Portuguese names
- Identify seasonal product categories using string pattern matching
- Create automated classification rules for Nigerian products

#### Part 3: Regular Expressions in Python (25 minutes)
**Excel Connection**: Advanced pattern matching beyond Excel capabilities

**Topics Covered:**
- **Basic Regex Patterns with `re` module**
  - Character classes: `[a-z]`, `[0-9]`, `\w`, `\d`
  - Quantifiers: `+`, `*`, `?`, `{n}`
  - Anchors: `^` (start), `$` (end)

- **Pandas Regex Integration**
  - `.str.contains()` with regex patterns
  - `.str.extract()` for pattern extraction
  - `.str.replace()` with regex for pattern-based substitution
  - `.str.findall()` for finding all matches

**Business Scenario 3**: Review sentiment pattern extraction
- Extract key phrases from customer reviews using regex
- Identify product quality indicators in Portuguese text
- Standardize review categorization for business intelligence

### Real Data Examples

#### Dataset Usage
- **Primary**: Olist customer reviews data (similar structure to SQL)
- **Secondary**: Product category translations for standardization
- **Tertiary**: Customer location data for cleaning exercises

#### Nigerian Business Context
- Adapt Brazilian e-commerce patterns to Nigerian market
- Focus on Lagos, Abuja, Port Harcourt as major business centers
- Consider multilingual text processing (English, Yoruba, Hausa, Igbo)

### Code Structure and Best Practices

#### Jupyter Notebook Organization
- **Part 1**: `wed_string_methods_fundamentals_part1.ipynb`
- **Part 2**: `wed_pattern_matching_basics_part2.ipynb`
- **Part 3**: `wed_regex_advanced_patterns_part3.ipynb`

#### Key Libraries
```python
import pandas as pd
import numpy as np
import re
import matplotlib.pyplot as plt
import seaborn as sns
```

### Assessment Integration
- **Formative**: Interactive coding exercises in each notebook section
- **Summative**: Product categorization project using simulated Olist data
- **Business Application**: Create text processing pipeline for Nigerian product catalog

### Tools and Environment
- **Development**: Google Colab for accessibility and collaboration
- **Data Source**: CSV datasets mirroring live SQL data structure
- **Visualization**: Matplotlib/Seaborn for text analysis insights

### Preparation Requirements
**For Students:**
- Review Excel TEXT functions worksheet from Phase 1
- Understand basic pandas DataFrame operations
- Familiarize with business product categorization concepts

**For Instructor:**
- Prepare sample datasets matching SQL lesson data
- Set up Colab notebooks with pre-loaded sample data
- Create debugging scenarios for common string processing errors

### Extension Activities
**Advanced Students:**
- Explore advanced regex patterns and named groups
- Practice with multilingual text processing
- Research Natural Language Processing basics

**Struggling Students:**
- Additional Excel-to-Python comparison exercises
- Simplified string method examples with step-by-step explanations
- Visual guides for regex pattern understanding

### Homework Preview
Students will apply text processing techniques to:
1. Clean a messy product catalog dataset (CSV format)
2. Standardize customer location data for Nigerian cities
3. Extract key insights from review text using pandas string methods
4. Create business rules for automated categorization pipeline

### Connection to Thursday SQL Class
- **Perfect Alignment**: Same business scenarios and data structure
- **Tool Translation**: Python string methods ↔ SQL string functions
- **Pattern Matching**: Python regex ↔ SQL LIKE and regex
- **Approach Difference**: DataFrame-centric vs database-centric operations

### Learning Progression
- **From Excel**: Leveraging familiar TEXT function concepts
- **Python Fundamentals**: Building on pandas DataFrame manipulation
- **Next Week**: Advanced data manipulation and merging techniques
- **Future Application**: Preparing data for visualization in Looker Studio

### Success Metrics
Students successfully complete the lesson when they can:
- Clean and standardize text data using appropriate Python methods
- Write regex patterns for common business text processing needs
- Apply string operations efficiently to pandas DataFrames
- Create reusable text processing functions for business workflows