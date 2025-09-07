# Week 3: Sorting & Calculated Fields - Thursday SQL Lesson Plan

## **Course Information**
- **Week**: 3 of 24
- **Date**: August 28, 2025
- **Duration**: 2 hours (120 minutes)
- **Mode**: In-person instruction with live coding

## **Business Context: Nigerian E-commerce Analytics**
**Scenario**: You are a data analyst for "Olist Nigeria," a major e-commerce marketplace. The management team needs insights into order pricing patterns, product performance metrics, and competitive positioning strategies to optimize their marketplace operations.

**Real-world Application**: Students will learn to create the calculated fields and sorting strategies commonly used by Nigerian e-commerce platforms like Jumia, Konga, and emerging local marketplaces.

## **Learning Objectives**
By the end of this lesson, students will be able to:

1. **Mathematical Operations**: Perform arithmetic calculations in SQL SELECT statements for business metrics
2. **Data Sorting**: Use ORDER BY with single and multiple columns to discover business insights  
3. **Conditional Logic**: Implement CASE statements for business categorization and segmentation
4. **Data Type Management**: Handle type casting and conversions for accurate calculations
5. **Business KPIs**: Calculate meaningful e-commerce metrics like profit margins, shipping ratios, and product rankings

## **Prerequisites Review (10 minutes)**
- Basic SELECT statements and table relationships
- WHERE clause filtering from Week 2
- Understanding of Olist database schema

---

## **LESSON STRUCTURE**

### **Opening & Context Setting (15 minutes)**

#### **Business Problem Introduction (8 minutes)**
"Today we're diving into one of the most critical skills for any data analyst in Nigeria's growing e-commerce sector - creating calculated fields and sorting data for business insights. 

Imagine you're working for Olist Nigeria, and the CEO walks in asking:
- 'Which product categories have the highest profit margins?'
- 'How should we rank our sellers by performance?'
- 'What's our shipping cost as a percentage of product value?'

These questions require calculated fields - new metrics derived from existing data."

#### **Excel to SQL Bridge (7 minutes)**
**Excel Connection**: "Remember in Excel when you created a formula in column D like `=B2+C2` or used functions like `=IF(A2>100,"High","Low")`? Today we're doing the exact same logic in SQL, but with the power to process millions of records instantly."

**Live Demo**: Show side-by-side comparison of Excel formula vs SQL calculation

---

### **Module 1: Mathematical Operations & Basic Calculations (30 minutes)**

#### **Core Concept: Arithmetic in SELECT Statements (15 minutes)**

**Business Example**: Calculate total order value (price + freight)
```sql
-- Basic arithmetic operations
SELECT 
    order_id,
    price,
    freight_value,
    price + freight_value AS total_order_value,
    price * 0.1 AS platform_commission,
    (price + freight_value) * 0.05 AS processing_fee
FROM olist_sales_data_set.olist_order_items_dataset
LIMIT 10;
```

**Key Teaching Points:**
- Column aliasing with AS keyword
- Order of operations (PEMDAS applies in SQL)
- Handling NULL values in calculations

#### **Advanced Business Calculations (15 minutes)**

**Practical Example**: E-commerce KPIs
```sql
-- Advanced business metrics
SELECT 
    oi.order_id,
    oi.price,
    oi.freight_value,
    -- Total order value
    oi.price + oi.freight_value AS total_order_value,
    -- Freight as percentage of price
    ROUND((oi.freight_value / oi.price * 100), 2) AS freight_percentage,
    -- Price per gram for efficiency analysis
    CASE 
        WHEN p.product_weight_g > 0 THEN ROUND(oi.price / p.product_weight_g, 4)
        ELSE NULL 
    END AS price_per_gram,
    -- Product volume calculation
    (p.product_length_cm * p.product_height_cm * p.product_width_cm) AS volume_cm3
FROM olist_sales_data_set.olist_order_items_dataset oi
JOIN olist_sales_data_set.olist_products_dataset p ON oi.product_id = p.product_id
LIMIT 15;
```

---

### **Module 2: Data Sorting with ORDER BY (25 minutes)**

#### **Single Column Sorting (10 minutes)**

**Business Context**: "Every e-commerce manager needs to quickly identify top performers and problem areas."

```sql
-- Find highest value orders
SELECT 
    order_id,
    price,
    freight_value,
    price + freight_value AS total_order_value
FROM olist_sales_data_set.olist_order_items_dataset
ORDER BY total_order_value DESC
LIMIT 20;
```

**Teaching Emphasis**: ASC vs DESC, NULL handling in sorting

#### **Multiple Column Sorting (15 minutes)**

**Complex Business Scenario**: "Rank products by category performance, then by price within each category"

```sql
-- Multi-level sorting for category analysis
SELECT 
    pct.product_category_name_english AS category,
    oi.price,
    oi.freight_value,
    oi.price + oi.freight_value AS total_value,
    p.product_weight_g
FROM olist_sales_data_set.olist_order_items_dataset oi
JOIN olist_sales_data_set.olist_products_dataset p ON oi.product_id = p.product_id
JOIN olist_sales_data_set.product_category_name_translation pct 
    ON p.product_category_name = pct.product_category_name
WHERE pct.product_category_name_english IN ('health_beauty', 'computers_accessories', 'watches_gifts')
ORDER BY 
    category ASC,
    total_value DESC,
    product_weight_g ASC
LIMIT 30;
```

---

### **Module 3: Conditional Logic with CASE Statements (35 minutes)**

#### **Basic CASE Statement Structure (15 minutes)**

**Business Application**: Product pricing categories for marketing segmentation
```sql
-- Product price categorization
SELECT 
    oi.product_id,
    oi.price,
    CASE 
        WHEN oi.price < 50 THEN 'Budget'
        WHEN oi.price BETWEEN 50 AND 200 THEN 'Mid-Range'
        WHEN oi.price BETWEEN 200 AND 500 THEN 'Premium'
        ELSE 'Luxury'
    END AS price_category,
    pct.product_category_name_english
FROM olist_sales_data_set.olist_order_items_dataset oi
JOIN olist_sales_data_set.olist_products_dataset p ON oi.product_id = p.product_id
JOIN olist_sales_data_set.product_category_name_translation pct 
    ON p.product_category_name = pct.product_category_name
ORDER BY oi.price DESC
LIMIT 25;
```

#### **Complex Business Logic Implementation (20 minutes)**

**Advanced Scenario**: Shipping efficiency analysis with multiple conditions
```sql
-- Advanced business categorization
SELECT 
    oi.order_id,
    oi.price,
    oi.freight_value,
    p.product_weight_g,
    pct.product_category_name_english,
    
    -- Shipping efficiency score
    CASE 
        WHEN oi.freight_value = 0 THEN 'Free Shipping'
        WHEN (oi.freight_value / oi.price) < 0.1 THEN 'Excellent'
        WHEN (oi.freight_value / oi.price) < 0.2 THEN 'Good'
        WHEN (oi.freight_value / oi.price) < 0.3 THEN 'Average'
        ELSE 'High Cost'
    END AS shipping_efficiency,
    
    -- Product size classification
    CASE 
        WHEN p.product_weight_g IS NULL THEN 'Unknown'
        WHEN p.product_weight_g < 500 THEN 'Light'
        WHEN p.product_weight_g < 2000 THEN 'Medium'
        WHEN p.product_weight_g < 5000 THEN 'Heavy'
        ELSE 'Bulk'
    END AS weight_category,
    
    -- Business priority scoring
    CASE 
        WHEN oi.price > 500 AND (oi.freight_value / oi.price) < 0.15 THEN 'High Priority'
        WHEN oi.price > 200 AND (oi.freight_value / oi.price) < 0.25 THEN 'Medium Priority'
        ELSE 'Standard Priority'
    END AS fulfillment_priority

FROM olist_sales_data_set.olist_order_items_dataset oi
JOIN olist_sales_data_set.olist_products_dataset p ON oi.product_id = p.product_id
JOIN olist_sales_data_set.product_category_name_translation pct 
    ON p.product_category_name = pct.product_category_name
ORDER BY oi.price DESC, shipping_efficiency
LIMIT 30;
```

---

### **Module 4: Data Type Conversions & Casting (15 minutes)**

#### **Practical Type Casting (15 minutes)**

**Business Context**: Ensuring accurate calculations across different data types
```sql
-- Type casting for accurate business calculations
SELECT 
    oi.order_id,
    oi.price,
    oi.freight_value,
    
    -- Explicit casting for precision
    CAST(oi.price AS DECIMAL(10,2)) AS price_decimal,
    CAST(oi.freight_value AS DECIMAL(10,2)) AS freight_decimal,
    
    -- String operations for business codes
    UPPER(SUBSTRING(oi.order_id, 1, 8)) AS order_code_prefix,
    
    -- Date formatting (if timestamps available)
    -- DATE(order_timestamp) AS order_date,
    
    -- Conditional casting
    CASE 
        WHEN p.product_weight_g IS NOT NULL 
        THEN CAST(p.product_weight_g AS VARCHAR) || ' grams'
        ELSE 'Weight not specified'
    END AS weight_display

FROM olist_sales_data_set.olist_order_items_dataset oi
JOIN olist_sales_data_set.olist_products_dataset p ON oi.product_id = p.product_id
LIMIT 20;
```

---

### **Hands-On Practice Session (15 minutes)**

#### **Guided Exercise**: Nigerian E-commerce Pricing Analysis
Students work on a realistic business problem:

**Challenge**: "Olist Nigeria wants to analyze their product portfolio. Create a query that categorizes products by pricing strategy and ranks them by profitability potential."

**Requirements**:
1. Calculate total value (price + freight) for each item
2. Create price categories: Budget (<₦20,000), Premium (₦20,000-₦100,000), Luxury (>₦100,000) 
3. Calculate freight as percentage of price
4. Rank by total value within each category
5. Include only categories with more than 1000 orders

**Solution Framework**:
```sql
-- Student guided exercise solution
SELECT 
    pct.product_category_name_english,
    oi.price * 500 AS price_naira, -- Converting to Naira approximation
    oi.freight_value * 500 AS freight_naira,
    (oi.price + oi.freight_value) * 500 AS total_value_naira,
    
    CASE 
        WHEN oi.price * 500 < 20000 THEN 'Budget'
        WHEN oi.price * 500 < 100000 THEN 'Premium' 
        ELSE 'Luxury'
    END AS pricing_strategy,
    
    ROUND((oi.freight_value / oi.price * 100), 1) AS freight_percentage,
    
    ROW_NUMBER() OVER (
        PARTITION BY 
            CASE 
                WHEN oi.price * 500 < 20000 THEN 'Budget'
                WHEN oi.price * 500 < 100000 THEN 'Premium' 
                ELSE 'Luxury'
            END 
        ORDER BY (oi.price + oi.freight_value) DESC
    ) AS rank_in_category

FROM olist_sales_data_set.olist_order_items_dataset oi
JOIN olist_sales_data_set.olist_products_dataset p ON oi.product_id = p.product_id
JOIN olist_sales_data_set.product_category_name_translation pct 
    ON p.product_category_name = pct.product_category_name
WHERE pct.product_category_name_english IN (
    'bed_bath_table', 'health_beauty', 'sports_leisure', 
    'computers_accessories', 'watches_gifts'
)
ORDER BY pricing_strategy, rank_in_category
LIMIT 50;
```

---

### **Wrap-up & Next Steps (10 minutes)**

#### **Key Takeaways Summary (5 minutes)**
1. **Calculated Fields**: Essential for creating business metrics from raw data
2. **ORDER BY**: Critical for identifying patterns and top/bottom performers
3. **CASE Statements**: Powerful tool for business logic and categorization
4. **Type Casting**: Ensures data accuracy in calculations

#### **Business Application Preview (3 minutes)**
"Next week we'll learn aggregations - combining these calculated fields with GROUP BY to answer questions like 'What's the average profit margin by category?' and 'Which region has the best shipping efficiency?'"

#### **Practice Assignment Brief (2 minutes)**
**Assignment**: Students will analyze product performance metrics, creating calculated fields for profitability analysis and ranking products by business importance.

---

## **Assessment Criteria**
Students will be evaluated on:
1. **Technical Accuracy** (40%): Correct SQL syntax and logic
2. **Business Application** (35%): Meaningful calculated fields for e-commerce analysis  
3. **Problem Solving** (15%): Approach to complex multi-step calculations
4. **Code Quality** (10%): Clean, readable SQL with proper aliasing

## **Resources & References**
- Olist dataset documentation
- SQL mathematical functions reference
- Nigerian e-commerce industry benchmarks
- CASE statement best practices guide

## **Common Errors & Debugging Tips**
1. **Division by Zero**: Always check denominators in business ratios
2. **NULL Handling**: Use COALESCE or CASE for missing values
3. **Data Type Mismatches**: Cast appropriately for accurate calculations
4. **ORDER BY Position**: Remember calculated fields can be referenced by alias

---

**Instructor Notes**: 
- Emphasize real-world business applications throughout
- Use live coding with students following along
- Encourage questions about Nigerian e-commerce context
- Prepare extra examples for advanced students
- Keep energy high with practical, immediately applicable examples