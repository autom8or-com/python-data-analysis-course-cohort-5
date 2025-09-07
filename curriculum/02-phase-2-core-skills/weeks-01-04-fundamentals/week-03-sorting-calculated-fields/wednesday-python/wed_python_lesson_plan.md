# Week 3: Sorting & Calculated Fields - Wednesday Python Lesson Plan

## **Course Information**
- **Week**: 3 of 24
- **Date**: August 27, 2025
- **Duration**: 2 hours (120 minutes)
- **Mode**: Google Colab with live coding and exercises

## **Business Context: Nigerian E-commerce Analytics**
**Scenario**: You are a data analyst for "Olist Nigeria," a major e-commerce marketplace. Using Python and pandas, you'll analyze order pricing patterns, create calculated fields for business metrics, and sort data to discover insights that drive strategic decisions.

**Real-world Application**: Students will learn the pandas operations that power Nigerian e-commerce platforms' analytics dashboards - the same techniques used by data teams at Jumia, Konga, and emerging local marketplaces.

## **Learning Objectives**
By the end of this lesson, students will be able to:

1. **Create Calculated Columns**: Add new columns to DataFrames using arithmetic operations and business logic
2. **Sort Data Effectively**: Use `sort_values()` with single and multiple criteria for business insights
3. **Apply String Manipulations**: Clean and standardize text data for business categorization
4. **Handle Data Type Conversions**: Ensure accurate calculations through proper data types
5. **Build Business Metrics**: Create KPIs and derived metrics for e-commerce analysis

## **Prerequisites Review (10 minutes)**
- Basic DataFrame operations from Weeks 1-2
- Data filtering with boolean indexing
- Understanding of Olist dataset structure

---

## **LESSON STRUCTURE**

### **Opening & Context Setting (15 minutes)**

#### **Business Problem Introduction (8 minutes)**
"Today we're mastering one of the most powerful aspects of pandas - creating new insights from existing data through calculated fields and strategic sorting.

In the e-commerce world, raw data tells only part of the story. The magic happens when we:
- Calculate profit margins from price and cost data
- Create efficiency metrics like price-per-gram
- Rank products by performance criteria  
- Categorize customers by spending patterns

These calculated fields become the foundation of every business dashboard and executive report."

#### **Excel to Python Bridge (7 minutes)**
**Excel Connection**: "Remember creating formulas in Excel like `=B2+C2` or using functions like `=IF(A2>100,"High","Low")`? Today we're doing the exact same logic in Python, but with the power to process millions of records and create reproducible analyses."

**Live Demo**: Show DataFrame operations alongside equivalent Excel formulas
```python
# Excel: =B2+C2
df['total'] = df['price'] + df['freight']

# Excel: =IF(A2>100,"High","Low")  
df['category'] = df['price'].apply(lambda x: 'High' if x > 100 else 'Low')
```

---

### **Module 1: Creating Calculated Columns (30 minutes)**

#### **Basic Arithmetic Operations (15 minutes)**

**Business Example**: Calculate total order value and commission
```python
import pandas as pd
import numpy as np

# Load sample e-commerce data
# (In Colab, students will load from provided CSV)
df = pd.read_csv('olist_order_items_sample.csv')

# Basic calculated columns
df['total_order_value'] = df['price'] + df['freight_value']
df['platform_commission'] = df['price'] * 0.1
df['processing_fee'] = df['total_order_value'] * 0.05

# Display results
print("Basic Calculated Fields:")
print(df[['order_id', 'price', 'freight_value', 'total_order_value', 'platform_commission']].head())
```

**Key Teaching Points:**
- Element-wise operations in pandas
- Broadcasting with scalar values
- Creating meaningful column names

#### **Advanced Business Calculations (15 minutes)**

**Practical Example**: E-commerce KPIs and efficiency metrics
```python
# Advanced business metrics
df['freight_percentage'] = (df['freight_value'] / df['price'] * 100).round(2)
df['price_per_gram'] = (df['price'] / df['product_weight_g']).round(4)
df['volume_cm3'] = df['product_length_cm'] * df['product_height_cm'] * df['product_width_cm']
df['value_density'] = (df['price'] / df['volume_cm3']).round(6)

# Handle division by zero and missing values
df['price_per_gram'] = df['price_per_gram'].replace([np.inf, -np.inf], np.nan)

# Nigerian Naira conversion (approximation: 1 BRL = 500 NGN)
df['price_ngn'] = (df['price'] * 500).round(0)
df['total_value_ngn'] = (df['total_order_value'] * 500).round(0)

print("Advanced E-commerce Metrics:")
print(df[['price', 'freight_percentage', 'price_per_gram', 'value_density', 'price_ngn']].head(10))
```

---

### **Module 2: Data Sorting with sort_values() (25 minutes)**

#### **Single Column Sorting (10 minutes)**

**Business Context**: "Every e-commerce manager needs to quickly identify top performers and problem areas."

```python
# Find highest value orders
high_value_orders = df.sort_values('total_order_value', ascending=False)
print("Top 10 Highest Value Orders:")
print(high_value_orders[['order_id', 'price', 'freight_value', 'total_order_value']].head(10))

# Find most efficient shipping (lowest freight percentage)
efficient_shipping = df.sort_values('freight_percentage', ascending=True)
print("\nMost Efficient Shipping:")
print(efficient_shipping[['order_id', 'price', 'freight_percentage']].head(10))

# Find products with best value density
best_value_density = df.sort_values('value_density', ascending=False, na_position='last')
print("\nBest Value Density Products:")
print(best_value_density[['product_id', 'price', 'volume_cm3', 'value_density']].head(10))
```

#### **Multiple Column Sorting (15 minutes)**

**Complex Business Scenario**: "Rank products by category performance, then by price within each category"

```python
# Multi-level sorting for comprehensive analysis
df_sorted = df.sort_values(
    ['product_category_name_english', 'total_order_value', 'freight_percentage'],
    ascending=[True, False, True]  # Category A-Z, highest value first, best shipping first
)

print("Multi-level Sorting: Category → Value → Shipping Efficiency")
selected_categories = ['health_beauty', 'computers_accessories', 'watches_gifts']
category_analysis = df_sorted[df_sorted['product_category_name_english'].isin(selected_categories)]

print(category_analysis[['product_category_name_english', 'price', 'total_order_value', 'freight_percentage']].head(15))

# Get top 3 products per category
top_per_category = df.groupby('product_category_name_english').apply(
    lambda x: x.nlargest(3, 'total_order_value')
).reset_index(drop=True)

print("\nTop 3 Products per Category:")
print(top_per_category[['product_category_name_english', 'price', 'total_order_value']].head(12))
```

---

### **Module 3: Conditional Logic and Categorization (35 minutes)**

#### **Using numpy.where for Simple Conditions (15 minutes)**

**Business Application**: Product pricing categories for marketing segmentation
```python
import numpy as np

# Simple binary categorization
df['value_tier'] = np.where(df['price'] > 200, 'High Value', 'Standard Value')

# Shipping evaluation
df['shipping_tier'] = np.where(
    df['freight_value'] == 0, 'Free Shipping',
    np.where(df['freight_value'] < 10, 'Low Shipping', 'Standard Shipping')
)

# Nigerian market pricing (converted to Naira)
df['naira_price_category'] = np.where(
    df['price_ngn'] < 25000, 'Budget (₦0-25K)',
    np.where(df['price_ngn'] < 100000, 'Economy (₦25K-100K)', 'Premium (₦100K+)')
)

print("Simple Categorization:")
print(df[['price', 'value_tier', 'freight_value', 'shipping_tier', 'naira_price_category']].head())
```

#### **Advanced Conditional Logic with Custom Functions (20 minutes)**

**Complex Business Scenario**: Multi-factor business categorization system
```python
def categorize_shipping_efficiency(row):
    """Categorize shipping efficiency based on multiple factors"""
    freight_pct = row['freight_percentage']
    if freight_pct < 5:
        return 'Excellent ⭐⭐⭐⭐⭐'
    elif freight_pct < 10:
        return 'Very Good ⭐⭐⭐⭐'
    elif freight_pct < 20:
        return 'Good ⭐⭐⭐'
    elif freight_pct < 30:
        return 'Average ⭐⭐'
    else:
        return 'Needs Improvement ⭐'

def categorize_business_priority(row):
    """Complex business priority based on multiple factors"""
    price = row['price']
    freight_pct = row['freight_percentage']
    weight = row['product_weight_g'] if pd.notna(row['product_weight_g']) else 0
    
    if price > 500 and freight_pct < 15 and weight < 2000:
        return 'VIP Priority 🏆'
    elif price > 300 and freight_pct < 20:
        return 'High Priority 🚀'  
    elif price > 100 and freight_pct < 25:
        return 'Standard Priority ✅'
    elif freight_pct > 40:
        return 'Review Required ⚠️'
    else:
        return 'Low Priority 📦'

def categorize_weight_class(weight):
    """Categorize products by weight for logistics planning"""
    if pd.isna(weight):
        return 'Unknown'
    elif weight < 500:
        return 'Light'
    elif weight < 2000:
        return 'Medium'  
    elif weight < 5000:
        return 'Heavy'
    else:
        return 'Bulk'

# Apply categorization functions
df['shipping_efficiency_score'] = df.apply(categorize_shipping_efficiency, axis=1)
df['business_priority'] = df.apply(categorize_business_priority, axis=1)
df['weight_category'] = df['product_weight_g'].apply(categorize_weight_class)

print("Advanced Business Categorization:")
print(df[['price', 'freight_percentage', 'shipping_efficiency_score', 'business_priority', 'weight_category']].head(10))

# Business priority distribution
priority_counts = df['business_priority'].value_counts()
print("\nBusiness Priority Distribution:")
print(priority_counts)
```

---

### **Module 4: String Manipulation for Business Data (15 minutes)**

#### **Text Processing for E-commerce Data (15 minutes)**

**Business Context**: Cleaning and standardizing product categories and codes
```python
# String operations for business applications
df['order_code_prefix'] = df['order_id'].str[:8].str.upper()
df['category_clean'] = df['product_category_name_english'].str.title().str.replace('_', ' ')

# Create standardized SKU codes
df['generated_sku'] = (
    df['product_category_name_english'].str[:3].str.upper() + '-' +
    df['order_item_id'].astype(str) + '-' +
    df['product_id'].str[:6].str.upper()
)

# Format currency displays
df['price_display'] = df['price'].apply(lambda x: f'R$ {x:.2f}')
df['naira_display'] = df['price_ngn'].apply(lambda x: f'₦ {x:,.0f}')

# Weight display with units
df['weight_display'] = df['product_weight_g'].apply(
    lambda x: f'{x:.0f}g' if pd.notna(x) else 'Weight not specified'
)

print("String Manipulation for Business:")
print(df[['order_code_prefix', 'category_clean', 'generated_sku', 'price_display', 'naira_display']].head())

# Text analysis - category name lengths (data quality check)
df['category_name_length'] = df['product_category_name_english'].str.len()
print(f"\nAverage category name length: {df['category_name_length'].mean():.1f} characters")
```

---

### **Hands-On Practice Session (15 minutes)**

#### **Guided Exercise**: Nigerian E-commerce Pricing Analysis
Students work on a realistic business problem:

**Challenge**: "Olist Nigeria wants to analyze their product portfolio. Create calculated fields for business insights and rank products by strategic importance."

**Requirements**:
1. Calculate total value including shipping for each order
2. Create price categories: Budget (<₦25,000), Premium (₦25,000-₦100,000), Luxury (>₦100,000)
3. Calculate shipping efficiency score (freight as % of price)
4. Create business recommendations based on multiple factors
5. Sort by business importance and display top 20

**Solution Framework**:
```python
# Student guided exercise
# 1. Calculate total values and conversions
df['total_with_shipping'] = df['price'] + df['freight_value']
df['total_ngn'] = df['total_with_shipping'] * 500

# 2. Price categorization
df['price_category_ngn'] = pd.cut(
    df['total_ngn'],
    bins=[0, 25000, 100000, float('inf')],
    labels=['Budget', 'Premium', 'Luxury']
)

# 3. Shipping efficiency
df['shipping_efficiency'] = (df['freight_value'] / df['price'] * 100).round(1)

# 4. Business recommendations
def get_business_recommendation(row):
    if row['total_ngn'] > 100000 and row['shipping_efficiency'] < 15:
        return 'Promote Heavily'
    elif row['total_ngn'] < 25000 and row['shipping_efficiency'] < 25:
        return 'Bundle Opportunity'
    elif row['shipping_efficiency'] > 35:
        return 'Review Logistics'
    else:
        return 'Standard Treatment'

df['business_recommendation'] = df.apply(get_business_recommendation, axis=1)

# 5. Strategic ranking
strategic_ranking = df.sort_values(
    ['business_recommendation', 'total_ngn', 'shipping_efficiency'],
    ascending=[True, False, True]
)

print("Strategic Product Ranking:")
print(strategic_ranking[['product_category_name_english', 'total_ngn', 'price_category_ngn', 'shipping_efficiency', 'business_recommendation']].head(20))
```

---

### **Wrap-up & Next Steps (10 minutes)**

#### **Key Takeaways Summary (5 minutes)**
1. **Calculated Columns**: Essential for deriving business insights from raw data
2. **Strategic Sorting**: Critical for identifying patterns and priorities  
3. **Conditional Logic**: Enables sophisticated business categorization
4. **String Operations**: Clean data for professional presentation

#### **Python vs SQL Bridge (3 minutes)**
"Tomorrow in SQL, we'll implement these same business calculations using different syntax:
- DataFrame columns become SELECT calculated fields
- `sort_values()` becomes ORDER BY
- Custom functions become CASE statements
- The business logic remains identical!"

#### **Practice Assignment Preview (2 minutes)**
**Assignment**: Students will analyze seller performance metrics, creating calculated fields for profitability analysis and ranking sellers by business importance.

---

## **Assessment Criteria**
Students will be evaluated on:
1. **Technical Accuracy** (40%): Correct pandas syntax and operations
2. **Business Application** (35%): Meaningful calculated fields and categorization logic
3. **Problem Solving** (15%): Approach to complex multi-step analyses
4. **Code Quality** (10%): Clean, readable code with appropriate comments

## **Resources & References**
- Pandas documentation for calculated columns
- NumPy documentation for conditional operations  
- Nigerian e-commerce market data for context
- Google Colab best practices guide

## **Common Errors & Debugging Tips**
1. **Division by Zero**: Use `replace()` to handle inf values
2. **Missing Data**: Check for NaN values before calculations
3. **Data Type Issues**: Use `astype()` for proper conversions  
4. **Sorting with NaN**: Use `na_position` parameter in `sort_values()`

---

**Instructor Notes**:
- Use live coding with students following along in Colab
- Provide sample data CSV for consistent results
- Emphasize business interpretation of results
- Connect every operation to real-world e-commerce scenarios
- Prepare debugging examples for common student errors