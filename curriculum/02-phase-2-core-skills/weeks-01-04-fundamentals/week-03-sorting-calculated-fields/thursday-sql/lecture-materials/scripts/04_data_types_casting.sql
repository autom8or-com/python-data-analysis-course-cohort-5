-- Week 3: SQL Data Types & Type Casting
-- Part 4: Ensuring Data Accuracy Through Proper Type Management

-- =====================================================
-- BUSINESS CONTEXT: Data Quality & Precision
-- =====================================================

-- In Nigerian e-commerce, accurate financial calculations are critical.
-- Different data types affect precision, performance, and business logic.
-- Understanding type casting prevents calculation errors that could cost money.

-- =====================================================
-- 1. UNDERSTANDING DATA TYPES IN PRACTICE
-- =====================================================

-- Examine current data types in our dataset
SELECT 
    oi.order_id,
    oi.price,                    -- REAL (floating point)
    oi.freight_value,           -- REAL (floating point)  
    oi.order_item_id,           -- INTEGER
    p.product_weight_g,         -- INTEGER
    p.product_length_cm,        -- INTEGER
    pct.product_category_name_english,  -- TEXT
    
    -- Display data types information
    pg_typeof(oi.price) as price_type,
    pg_typeof(oi.order_item_id) as item_id_type,
    pg_typeof(p.product_weight_g) as weight_type,
    pg_typeof(pct.product_category_name_english) as category_type

FROM olist_sales_data_set.olist_order_items_dataset oi
JOIN olist_sales_data_set.olist_products_dataset p ON oi.product_id = p.product_id
JOIN olist_sales_data_set.product_category_name_translation pct 
    ON p.product_category_name = pct.product_category_name
LIMIT 10;

-- =====================================================
-- 2. EXPLICIT TYPE CASTING FOR PRECISION
-- =====================================================

-- Financial calculations require precision - cast to DECIMAL for accuracy
SELECT 
    oi.order_id,
    oi.price,
    oi.freight_value,
    
    -- Cast to DECIMAL for precise financial calculations
    CAST(oi.price AS DECIMAL(10,2)) AS price_precise,
    CAST(oi.freight_value AS DECIMAL(10,2)) AS freight_precise,
    
    -- Precise calculation using DECIMAL
    CAST(oi.price AS DECIMAL(10,2)) + CAST(oi.freight_value AS DECIMAL(10,2)) AS total_value_precise,
    
    -- Convert to Nigerian Naira (approximate exchange rate)
    CAST(oi.price AS DECIMAL(10,2)) * CAST(500 AS DECIMAL(10,2)) AS price_naira,
    CAST(oi.freight_value AS DECIMAL(10,2)) * CAST(500 AS DECIMAL(10,2)) AS freight_naira,
    
    -- Percentage calculation with proper precision
    ROUND(
        (CAST(oi.freight_value AS DECIMAL(10,4)) / CAST(oi.price AS DECIMAL(10,4)) * 100), 
        2
    ) AS freight_percentage_precise,
    
    -- Show the difference between REAL and DECIMAL calculations
    oi.price + oi.freight_value AS total_real,
    CAST(oi.price AS DECIMAL(10,2)) + CAST(oi.freight_value AS DECIMAL(10,2)) AS total_decimal

FROM olist_sales_data_set.olist_order_items_dataset oi
WHERE oi.price > 0 AND oi.freight_value > 0
ORDER BY oi.price DESC
LIMIT 20;

-- =====================================================
-- 3. STRING OPERATIONS AND CONVERSIONS
-- =====================================================

-- Working with text data and conversions for business applications
SELECT 
    oi.order_id,
    oi.product_id,
    pct.product_category_name_english,
    oi.price,
    p.product_weight_g,
    
    -- String manipulation for business codes
    UPPER(SUBSTRING(oi.order_id, 1, 8)) AS order_code_prefix,
    LOWER(pct.product_category_name_english) AS category_lowercase,
    INITCAP(pct.product_category_name_english) AS category_title_case,
    
    -- Convert numbers to formatted strings
    CAST(oi.price AS VARCHAR) || ' BRL' AS price_display,
    CAST(ROUND(oi.price * 500, 0) AS VARCHAR) || ' NGN' AS price_naira_display,
    
    -- Conditional string formatting
    CASE 
        WHEN p.product_weight_g IS NOT NULL 
        THEN CAST(p.product_weight_g AS VARCHAR) || ' grams'
        ELSE 'Weight not specified'
    END AS weight_display,
    
    -- Create SKU-like codes
    UPPER(SUBSTRING(pct.product_category_name_english, 1, 3)) || '-' || 
    CAST(oi.order_item_id AS VARCHAR) || '-' || 
    SUBSTRING(oi.product_id, 1, 6) AS generated_sku,
    
    -- Format price ranges for display
    CASE 
        WHEN oi.price < 50 THEN 'NGN 0 - 25,000'
        WHEN oi.price < 200 THEN 'NGN 25,000 - 100,000'
        WHEN oi.price < 500 THEN 'NGN 100,000 - 250,000'
        ELSE 'NGN 250,000+'
    END AS price_range_display,
    
    -- Length of text fields (useful for data quality)
    LENGTH(oi.order_id) AS order_id_length,
    LENGTH(pct.product_category_name_english) AS category_name_length

FROM olist_sales_data_set.olist_order_items_dataset oi
JOIN olist_sales_data_set.olist_products_dataset p ON oi.product_id = p.product_id
JOIN olist_sales_data_set.product_category_name_translation pct 
    ON p.product_category_name = pct.product_category_name
ORDER BY oi.price DESC
LIMIT 25;

-- =====================================================
-- 4. HANDLING NULL VALUES AND DATA QUALITY
-- =====================================================

-- Proper handling of missing data with type-safe operations
SELECT 
    oi.product_id,
    oi.price,
    p.product_weight_g,
    p.product_length_cm,
    p.product_height_cm,
    p.product_width_cm,
    pct.product_category_name_english,
    
    -- Safe NULL handling with COALESCE
    COALESCE(p.product_weight_g, 0) AS weight_safe,
    COALESCE(CAST(p.product_weight_g AS VARCHAR), 'Unknown') AS weight_display_safe,
    
    -- Calculate volume with NULL safety
    CASE 
        WHEN p.product_length_cm IS NOT NULL 
             AND p.product_height_cm IS NOT NULL 
             AND p.product_width_cm IS NOT NULL
             AND p.product_length_cm > 0
             AND p.product_height_cm > 0
             AND p.product_width_cm > 0
        THEN CAST(p.product_length_cm AS DECIMAL) * 
             CAST(p.product_height_cm AS DECIMAL) * 
             CAST(p.product_width_cm AS DECIMAL)
        ELSE NULL
    END AS volume_cm3_safe,
    
    -- Data quality flags
    CASE 
        WHEN p.product_weight_g IS NULL THEN 'Missing Weight'
        WHEN p.product_weight_g <= 0 THEN 'Invalid Weight'
        ELSE 'Weight OK'
    END AS weight_quality_flag,
    
    CASE 
        WHEN p.product_length_cm IS NULL OR p.product_height_cm IS NULL OR p.product_width_cm IS NULL
        THEN 'Missing Dimensions'
        WHEN p.product_length_cm <= 0 OR p.product_height_cm <= 0 OR p.product_width_cm <= 0
        THEN 'Invalid Dimensions'
        ELSE 'Dimensions OK'
    END AS dimensions_quality_flag,
    
    -- Safe division with NULL checking
    CASE 
        WHEN p.product_weight_g IS NOT NULL AND p.product_weight_g > 0 
        THEN ROUND(CAST(oi.price AS DECIMAL(10,2)) / CAST(p.product_weight_g AS DECIMAL(10,2)), 4)
        ELSE NULL
    END AS price_per_gram_safe,
    
    -- Count of missing fields
    (CASE WHEN p.product_weight_g IS NULL THEN 1 ELSE 0 END +
     CASE WHEN p.product_length_cm IS NULL THEN 1 ELSE 0 END +
     CASE WHEN p.product_height_cm IS NULL THEN 1 ELSE 0 END +
     CASE WHEN p.product_width_cm IS NULL THEN 1 ELSE 0 END) AS missing_field_count

FROM olist_sales_data_set.olist_order_items_dataset oi
JOIN olist_sales_data_set.olist_products_dataset p ON oi.product_id = p.product_id
JOIN olist_sales_data_set.product_category_name_translation pct 
    ON p.product_category_name = pct.product_category_name
WHERE oi.price > 0
ORDER BY missing_field_count DESC, oi.price DESC
LIMIT 30;

-- =====================================================
-- 5. ADVANCED TYPE CONVERSIONS FOR BUSINESS LOGIC
-- =====================================================

-- Complex business scenarios requiring careful type management
SELECT 
    oi.order_id,
    oi.price,
    oi.freight_value,
    p.product_weight_g,
    pct.product_category_name_english,
    
    -- Financial calculations with proper decimal precision
    ROUND(CAST(oi.price * 500 AS DECIMAL(12,2)), 2) AS price_naira_precise,
    ROUND(CAST(oi.freight_value * 500 AS DECIMAL(12,2)), 2) AS freight_naira_precise,
    
    -- Business ratios with controlled precision
    CASE 
        WHEN oi.price > 0 
        THEN ROUND(CAST(oi.freight_value AS DECIMAL(10,4)) / CAST(oi.price AS DECIMAL(10,4)), 4)
        ELSE NULL
    END AS freight_ratio_precise,
    
    -- Convert categorical data to numeric scores for analysis
    CASE pct.product_category_name_english
        WHEN 'computers_accessories' THEN 5
        WHEN 'health_beauty' THEN 4  
        WHEN 'watches_gifts' THEN 4
        WHEN 'toys' THEN 3
        WHEN 'electronics' THEN 5
        ELSE 2
    END AS category_priority_score,
    
    -- Weight-based shipping zones (convert to business categories)
    CASE 
        WHEN p.product_weight_g IS NULL THEN 0
        WHEN CAST(p.product_weight_g AS DECIMAL) <= 500 THEN 1
        WHEN CAST(p.product_weight_g AS DECIMAL) <= 2000 THEN 2
        WHEN CAST(p.product_weight_g AS DECIMAL) <= 5000 THEN 3
        ELSE 4
    END AS shipping_zone_code,
    
    -- Create standardized product codes
    LPAD(CAST(ROW_NUMBER() OVER (ORDER BY oi.price DESC) AS VARCHAR), 6, '0') AS product_rank_code,
    
    -- Boolean flags converted to text for reporting
    CASE WHEN oi.price > 100 THEN 'Yes' ELSE 'No' END AS high_value_flag,
    CASE WHEN COALESCE(p.product_weight_g, 0) > 1000 THEN 'Heavy' ELSE 'Light' END AS weight_flag,
    
    -- JSON-like string for API responses (advanced string building)
    '{' ||
    '"order_id":"' || oi.order_id || '",' ||
    '"price":' || CAST(oi.price AS VARCHAR) || ',' ||
    '"category":"' || pct.product_category_name_english || '",' ||
    '"weight_g":' || COALESCE(CAST(p.product_weight_g AS VARCHAR), 'null') ||
    '}' AS order_json

FROM olist_sales_data_set.olist_order_items_dataset oi
JOIN olist_sales_data_set.olist_products_dataset p ON oi.product_id = p.product_id
JOIN olist_sales_data_set.product_category_name_translation pct 
    ON p.product_category_name = pct.product_category_name
WHERE oi.price > 0
ORDER BY oi.price DESC
LIMIT 20;

-- =====================================================
-- 6. DATA VALIDATION AND QUALITY CONTROL
-- =====================================================

-- Comprehensive data validation using type casting and checks
SELECT 
    'Data Quality Report' AS report_type,
    COUNT(*) AS total_records,
    
    -- Type validation counts
    SUM(CASE WHEN oi.price IS NULL OR oi.price <= 0 THEN 1 ELSE 0 END) AS invalid_prices,
    SUM(CASE WHEN oi.freight_value IS NULL OR oi.freight_value < 0 THEN 1 ELSE 0 END) AS invalid_freight,
    SUM(CASE WHEN p.product_weight_g IS NULL THEN 1 ELSE 0 END) AS missing_weights,
    SUM(CASE WHEN p.product_weight_g <= 0 AND p.product_weight_g IS NOT NULL THEN 1 ELSE 0 END) AS invalid_weights,
    
    -- String validation
    SUM(CASE WHEN LENGTH(TRIM(pct.product_category_name_english)) = 0 THEN 1 ELSE 0 END) AS empty_categories,
    SUM(CASE WHEN LENGTH(oi.order_id) != 32 THEN 1 ELSE 0 END) AS invalid_order_id_format,
    
    -- Business logic validation
    SUM(CASE WHEN CAST(oi.freight_value AS DECIMAL) / CAST(oi.price AS DECIMAL) > 1 THEN 1 ELSE 0 END) AS freight_exceeds_price,
    SUM(CASE WHEN oi.price > 5000 THEN 1 ELSE 0 END) AS extremely_high_prices,
    
    -- Calculate data quality score (percentage of clean records)
    ROUND(
        (COUNT(*) - 
         SUM(CASE WHEN oi.price IS NULL OR oi.price <= 0 THEN 1 ELSE 0 END) -
         SUM(CASE WHEN oi.freight_value IS NULL OR oi.freight_value < 0 THEN 1 ELSE 0 END) -
         SUM(CASE WHEN p.product_weight_g IS NULL THEN 1 ELSE 0 END)
        ) * 100.0 / COUNT(*), 2
    ) AS data_quality_score_percent

FROM olist_sales_data_set.olist_order_items_dataset oi
JOIN olist_sales_data_set.olist_products_dataset p ON oi.product_id = p.product_id
JOIN olist_sales_data_set.product_category_name_translation pct 
    ON p.product_category_name = pct.product_category_name;

-- =====================================================
-- 7. BEST PRACTICES FOR TYPE CASTING
-- =====================================================

-- Demonstration of proper casting techniques
SELECT 
    oi.order_id,
    oi.price,
    p.product_weight_g,
    
    -- ❌ WRONG: Direct division can lose precision
    oi.price / p.product_weight_g AS price_per_gram_imprecise,
    
    -- ✅ CORRECT: Cast to appropriate precision first
    CASE 
        WHEN p.product_weight_g > 0 
        THEN ROUND(CAST(oi.price AS DECIMAL(12,4)) / CAST(p.product_weight_g AS DECIMAL(12,4)), 6)
        ELSE NULL
    END AS price_per_gram_precise,
    
    -- ❌ WRONG: Concatenation without proper casting
    -- oi.price || ' BRL'  -- This would cause an error
    
    -- ✅ CORRECT: Explicit string conversion
    CAST(ROUND(oi.price, 2) AS VARCHAR) || ' BRL' AS price_formatted,
    
    -- ❌ WRONG: Assuming values are never NULL
    -- ROUND(oi.price / p.product_weight_g, 2)  -- Fails if weight is NULL
    
    -- ✅ CORRECT: NULL-safe operations
    COALESCE(
        CASE 
            WHEN p.product_weight_g > 0 
            THEN ROUND(CAST(oi.price AS DECIMAL(10,2)) / CAST(p.product_weight_g AS DECIMAL(10,2)), 4)
            ELSE NULL
        END, 
        0
    ) AS price_per_gram_safe,
    
    -- Performance tip: Cast once, use multiple times
    CAST(oi.price AS DECIMAL(10,2)) AS price_decimal,
    CAST(oi.price AS DECIMAL(10,2)) * 500 AS price_naira,
    CAST(oi.price AS DECIMAL(10,2)) * 0.1 AS commission

FROM olist_sales_data_set.olist_order_items_dataset oi
JOIN olist_sales_data_set.olist_products_dataset p ON oi.product_id = p.product_id
WHERE oi.price > 0
LIMIT 15;

-- =====================================================
-- BUSINESS IMPACT OF PROPER TYPE CASTING
-- =====================================================

/*
Why Type Casting Matters in Nigerian E-commerce:

1. **Financial Accuracy**: Prevents rounding errors in revenue calculations
2. **Currency Conversion**: Ensures precise BRL to NGN conversions
3. **Inventory Management**: Accurate weight and dimension calculations
4. **Reporting**: Consistent data types for dashboard integration
5. **API Integration**: Proper JSON formatting for external systems

Common Pitfalls to Avoid:
- Never assume data is never NULL
- Always cast to appropriate precision for financial calculations  
- Validate data types before complex operations
- Use DECIMAL for money, not FLOAT/REAL
- Handle division by zero explicitly

Practice these patterns to build robust, accurate business systems!
*/

-- Final Challenge: Complete order analysis with proper type management
SELECT 
    oi.order_id,
    UPPER(SUBSTRING(oi.order_id, 1, 8)) AS order_prefix,
    pct.product_category_name_english,
    
    -- Financial calculations with proper precision
    CAST(oi.price AS DECIMAL(10,2)) AS price_brl,
    ROUND(CAST(oi.price AS DECIMAL(10,2)) * 500, 0) AS price_ngn,
    CAST(oi.freight_value AS DECIMAL(10,2)) AS freight_brl,
    
    -- Business metrics with NULL safety
    CASE 
        WHEN p.product_weight_g > 0 
        THEN CAST(ROUND(CAST(oi.price AS DECIMAL(12,4)) / p.product_weight_g, 4) AS VARCHAR) || ' BRL/g'
        ELSE 'Weight unavailable'
    END AS efficiency_display,
    
    -- Data quality indicators
    (CASE WHEN oi.price > 0 THEN 1 ELSE 0 END +
     CASE WHEN oi.freight_value >= 0 THEN 1 ELSE 0 END +
     CASE WHEN p.product_weight_g > 0 THEN 1 ELSE 0 END) AS quality_score

FROM olist_sales_data_set.olist_order_items_dataset oi
JOIN olist_sales_data_set.olist_products_dataset p ON oi.product_id = p.product_id
JOIN olist_sales_data_set.product_category_name_translation pct 
    ON p.product_category_name = pct.product_category_name
WHERE oi.price > 0
ORDER BY quality_score DESC, price_ngn DESC
LIMIT 25;