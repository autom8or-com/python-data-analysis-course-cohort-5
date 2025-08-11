# Week 01 - Programming Foundations - Wednesday Python Session

## Session Overview
**Date**: August 13, 2025  
**Duration**: 2 hours  
**Platform**: Python/Google Colab  
**Business Scenario**: Olist e-commerce marketplace orientation - understanding how data flows from Excel to programming

## Learning Objectives
By the end of this session, students will be able to:
- [ ] Connect familiar Excel concepts to Python programming paradigms
- [ ] Successfully set up and navigate Google Colab environment
- [ ] Create and manipulate variables in Python with business context
- [ ] Load and explore CSV data using pandas (Excel → DataFrame transition)
- [ ] Understand fundamental Python data structures: lists, dictionaries, and DataFrames
- [ ] Perform basic data exploration using head(), info(), describe(), and shape
- [ ] Interpret error messages and apply basic troubleshooting techniques

## Session Structure

### Opening: Excel to Python Bridge (10 minutes)
**Welcome & Mindset Setting**
- Quick review: "You already think like a programmer!"
- Excel skills transfer: formulas = functions, ranges = lists, worksheets = DataFrames
- Overview of Olist business scenario (Brazilian e-commerce adapted for Nigerian context)
- Today's journey: From opening Excel files to loading DataFrames

**Resources:**
- `notebooks/01_welcome_excel_to_python.ipynb`

### Topic 1: Python Environment & Variables (35 minutes)

**Subtopics:**
- Google Colab setup and navigation (Excel Online equivalent)
- Variables as "named cells" with business context
- Data types: strings (text), integers (whole numbers), floats (decimals), booleans (yes/no)
- Print statements for checking values (like viewing cell contents)

**Activities:**
- Hands-on: Create variables for Nigerian e-commerce business
- Practice: Store customer information using different data types
- Mini-challenge: Calculate basic business metrics using variables

**Excel Connections:**
- Variables = Named cells in Excel
- Print() = Viewing cell values
- String concatenation = CONCATENATE function

**Resources:**
- `notebooks/02_variables_and_data_types.ipynb`
- `datasets/business_examples.csv`

### Topic 2: Data Structures - Lists and Dictionaries (35 minutes)

**Subtopics:**
- Lists as "column ranges" (A1:A10 concept)
- Accessing list items (index like row numbers, but starting from 0!)
- Dictionaries as "lookup tables" (VLOOKUP replacement)
- Real-world applications: customer lists, product catalogs, price lookups

**Activities:**
- Build customer list from scratch
- Create product dictionary with prices
- Practice accessing specific items
- Error handling: common indexing mistakes

**Excel Connections:**
- Lists = Column ranges (A1:A10)
- List indexing = Row numbers (but starts at 0)
- Dictionaries = Lookup tables with VLOOKUP functionality

**Resources:**
- `notebooks/03_lists_and_dictionaries.ipynb`

### Topic 3: Introduction to Pandas and DataFrames (35 minutes)

**Subtopics:**
- Installing and importing pandas (library = Excel add-in)
- Loading CSV files: pd.read_csv() vs Excel's "Open File"
- DataFrame structure: rows, columns, index (familiar Excel grid)
- Basic exploration: head(), tail(), info(), describe(), shape

**Activities:**
- Load the Olist sample dataset
- Explore data structure and column names
- Check data types and missing values
- Compare to Excel viewing methods

**Excel Connections:**
- DataFrame = Excel worksheet/spreadsheet
- pd.read_csv() = File > Open in Excel
- head() = Looking at first few rows
- info() = Checking column data types
- describe() = Summary statistics

**Resources:**
- `notebooks/04_pandas_dataframe_intro.ipynb`
- `datasets/orders_sample.csv`

### Wrap-up & Preview (5 minutes)
**Knowledge Check:**
- Quick quiz: Excel concept to Python equivalent
- Show code snippet, identify Excel parallel
- Error identification practice

**Next Session Preview:**
- Tomorrow: Same concepts in SQL (tables = DataFrames)
- Building on today's exploration with database queries
- Same business questions, different tool

**Assignment Instructions:**
- Complete practice exercises in `exercises/` folder
- Explore additional columns in the Olist dataset
- Personal reflection: document your "aha moments"

## Materials Needed
- [ ] `notebooks/01_welcome_excel_to_python.ipynb`
- [ ] `notebooks/02_variables_and_data_types.ipynb`  
- [ ] `notebooks/03_lists_and_dictionaries.ipynb`
- [ ] `notebooks/04_pandas_dataframe_intro.ipynb`
- [ ] `datasets/orders_sample.csv`
- [ ] `datasets/business_examples.csv`

## Assessment

**Formative Assessment:**
- Live coding participation during each segment
- Peer discussion: "Explain this concept to your neighbor using Excel terms"
- Quick error fixing challenges throughout session

**Summative Assessment:**
- End-of-session mini-project: "Explore Your First Dataset"
- Criteria: Successfully load data, explore structure, answer basic business questions
- Submit completed notebook with reflection comments

## Homework/Follow-up
**Assignment**: Complete `exercises/week_01_python_practice.ipynb`
- **Due**: Before Thursday's SQL session
- **Components**:
  1. Variable creation with business scenarios
  2. List and dictionary manipulation
  3. DataFrame loading and exploration
  4. Reflection essay: "How is Python like/unlike Excel?"

**Extension Activities for Early Finishers:**
- Explore additional columns in Olist dataset
- Try basic filtering operations using boolean indexing
- Research Python data types online and document findings
- Create a personal "Excel to Python" cheat sheet

## Instructor Notes

**Special Preparation Needed:**
- Test all Google Colab notebooks beforehand
- Prepare backup CSV files in case of loading issues
- Have Excel spreadsheet open for side-by-side comparisons
- Create troubleshooting slide for common errors

**Common Student Difficulties:**
1. **Indexing confusion** (Python starts at 0, Excel at 1)
   - *Solution*: Constant reinforcement, visual diagrams, practice exercises
2. **Syntax overwhelm** (brackets, quotes, parentheses)  
   - *Solution*: Provide syntax cheat sheet, emphasize patterns
3. **Error message fear** (red text = panic)
   - *Solution*: Frame errors as "feedback", practice interpreting messages
4. **"This is nothing like Excel!"** mindset
   - *Solution*: Constant Excel analogies, celebrate similarities

**Confidence Building Strategies:**
- Start each new concept with "You already know this from Excel..."
- Use Nigerian business examples they can relate to
- Celebrate small wins: "You just wrote your first Python program!"
- Emphasize that confusion is normal and temporary

**Time Management Tips:**
- Notebook 1: 10 minutes (keep moving, it's just orientation)
- Notebook 2: 35 minutes (most important for confidence building)
- Notebook 3: 35 minutes (fun part - they'll see the power)
- Notebook 4: 35 minutes (big payoff - real data!)
- Flexibility: Skip advanced examples if running behind

## Resources

**Lecture Materials:**
- `01_welcome_excel_to_python.ipynb` - Session introduction and mindset setting
- `02_variables_and_data_types.ipynb` - Core Python fundamentals with business examples  
- `03_lists_and_dictionaries.ipynb` - Data structures with e-commerce scenarios
- `04_pandas_dataframe_intro.ipynb` - Introduction to data analysis with real dataset

**Exercise Files:**
- `exercises/week_01_python_practice.ipynb` - Guided practice problems
- `exercises/dataset_exploration_challenge.ipynb` - Open-ended data exploration
- `exercises/reflection_template.md` - Structured thinking about Excel-Python connections

**Support Resources:**
- `resources/python_syntax_cheatsheet.md` - Quick reference for common operations
- `resources/excel_to_python_dictionary.md` - Direct concept translations
- `resources/common_errors_guide.md` - Error interpretation and solutions
- `resources/colab_setup_guide.md` - Step-by-step Google Colab navigation

**Additional Resources:**
- [Python.org Beginner's Guide](https://www.python.org/about/gettingstarted/)
- [Pandas Documentation](https://pandas.pydata.org/docs/getting_started/index.html)
- Nigerian business case studies for context adaptation

---

**Note for Instructors**: This lesson plan assumes students have successfully completed Phase 1 Excel training. Every concept introduction should start with an Excel parallel to build confidence and reduce cognitive load. The key to success is showing students they already possess the logical thinking skills needed for programming.