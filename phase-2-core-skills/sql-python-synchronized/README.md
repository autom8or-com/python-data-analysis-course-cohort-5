# Phase 2: Synchronized SQL & Python Learning

## Overview
This phase teaches SQL and Python simultaneously using the **Olist Brazilian E-commerce Dataset**. The curriculum is designed for absolute beginners who have completed Excel training and are ready to learn programming concepts.

## Learning Philosophy: From Excel to Code
- **Excel mindset → Programming mindset**: Connect familiar Excel concepts to SQL/Python
- **Same data, two tools**: Learn identical concepts in both SQL and Python
- **Progressive complexity**: Start simple, build complexity gradually
- **Real business context**: Use actual e-commerce data for practical learning

## Dataset: Olist Brazilian E-commerce
**What is Olist?** A Brazilian e-commerce platform connecting small businesses to major marketplaces.
- **Time period**: 2016-2018
- **Scale**: 100,000+ orders
- **Scope**: Complete sales and marketing funnel data

### Key Tables (Beginner-Friendly Names):
1. **Orders** (`olist_orders_dataset`) - The main order information
2. **Customers** (`olist_customers_dataset`) - Customer details and locations  
3. **Products** (`olist_products_dataset`) - Product catalog information
4. **Order_Items** (`olist_order_items_dataset`) - What was bought in each order
5. **Payments** (`olist_order_payments_dataset`) - How customers paid
6. **Reviews** (`olist_order_reviews_dataset`) - Customer feedback
7. **Sellers** (`olist_sellers_dataset`) - Seller information
8. **Locations** (`olist_geolocation_dataset`) - Geographic data

## Technical Setup

### SQL Environment: Supabase
- **Tool**: VS Code with SQL extensions
- **Database**: Supabase (PostgreSQL)
- **Schema**: `olist_sales_data_set` (main tables)
- **Access**: MCP server integration

### Python Environment: Google Colab
- **Tool**: Google Colab (browser-based, no installation needed)
- **Data Source**: Online CSV files from Kaggle
- **Libraries**: pandas, numpy, matplotlib, seaborn

## Month-by-Month Structure

### Month 2: Fundamentals (August 2025)
**Excel Concept → SQL & Python**
- Filtering data → WHERE clauses & boolean indexing
- Sorting data → ORDER BY & sort_values()
- Basic calculations → SELECT expressions & pandas operations
- Counting records → COUNT() & len()/value_counts()

### Month 3: Intermediate (September 2025)  
**Excel Concept → SQL & Python**
- VLOOKUP → JOINs & merge()
- Pivot Tables → GROUP BY & pivot_table()
- Conditional logic → CASE WHEN & np.where()
- Date functions → Date/time operations

### Month 4: Advanced (October 2025)
**Excel Concept → SQL & Python**
- Complex formulas → Subqueries & lambda functions
- Data validation → Window functions & rolling operations
- Advanced charts → Aggregations & visualization libraries

## Weekly Session Structure (2 hours)

### Hour 1: Concept Introduction (1 hour)
1. **Excel Connection** (10 min): "You already know this in Excel..."
2. **SQL Demonstration** (20 min): Live coding with explanation
3. **Python Demonstration** (20 min): Same concept in Python
4. **Side-by-Side Comparison** (10 min): Highlight similarities/differences

### Hour 2: Hands-On Practice (1 hour)
1. **Guided Practice** (30 min): Students code along
2. **Independent Exercise** (20 min): Complete small task
3. **Q&A and Troubleshooting** (10 min): Address issues

## Assessment Approach
- **Weekly mini-projects**: Same business question solved in both SQL and Python
- **Gradual complexity**: Start with single-table queries, progress to multi-table analysis
- **Real-world context**: Every exercise relates to actual business decisions

## Success Metrics
By end of Phase 2, students should:
1. **Translate Excel thinking** to programming logic
2. **Write equivalent queries** in SQL and Python for same business question
3. **Understand data flow** from raw tables to business insights
4. **Debug basic errors** in both languages
5. **Choose appropriate tool** for different types of analysis

---

*This curriculum bridges the gap between Excel proficiency and programming skills, using real e-commerce data to teach practical data analysis techniques.*