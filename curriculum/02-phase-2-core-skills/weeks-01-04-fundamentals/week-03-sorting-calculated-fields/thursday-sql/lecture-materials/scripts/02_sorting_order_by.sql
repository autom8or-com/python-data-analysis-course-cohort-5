-- Week 3: SQL Sorting with ORDER BY
-- Part 2: Single and Multiple Column Sorting for Business Analysis

-- =====================================================
-- BUSINESS CONTEXT: Product Performance Ranking
-- =====================================================

-- As an e-commerce analyst, you need to rank products, orders, and categories
-- to identify top performers, problem areas, and optimization opportunities.

-- =====================================================
-- 1. SINGLE COLUMN SORTING - BASIC RANKINGS
-- =====================================================

-- Find highest value orders (critical for VIP customer identification)
SELECT 
    order_id,
    price,
    freight_value,
    price + freight_value AS total_order_value,
    ROUND((freight_value / price * 100), 2) AS freight_percentage
FROM olist_sales_data_set.olist_order_items_dataset
WHERE price > 0
ORDER BY total_order_value DESC  -- Highest value first
LIMIT 25;

-- Find lowest freight costs (efficient shipping identification)
SELECT 
    order_id,
    product_id,
    price,
    freight_value,
    ROUND((freight_value / price * 100), 2) AS freight_percentage
FROM olist_sales_data_set.olist_order_items_dataset
WHERE price > 50  -- Focus on meaningful transactions
ORDER BY freight_value ASC  -- Lowest freight first
LIMIT 20;

-- Products with highest price-to-weight ratio (premium products)
SELECT 
    oi.product_id,
    oi.price,
    p.product_weight_g,
    pct.product_category_name_english,
    CASE 
        WHEN p.product_weight_g > 0 THEN ROUND(oi.price / p.product_weight_g, 4)
        ELSE NULL 
    END AS price_per_gram
FROM olist_sales_data_set.olist_order_items_dataset oi
JOIN olist_sales_data_set.olist_products_dataset p ON oi.product_id = p.product_id
JOIN olist_sales_data_set.product_category_name_translation pct 
    ON p.product_category_name = pct.product_category_name
WHERE p.product_weight_g > 0 AND oi.price > 0
ORDER BY price_per_gram DESC  -- Most expensive per gram first
LIMIT 30;

-- =====================================================
-- 2. MULTIPLE COLUMN SORTING - COMPLEX BUSINESS LOGIC
-- =====================================================

-- Multi-level sorting: Category performance analysis
-- Sort by category, then by price within each category
SELECT 
    pct.product_category_name_english AS category,
    oi.price,
    oi.freight_value,
    oi.price + oi.freight_value AS total_value,
    p.product_weight_g,
    ROUND((oi.freight_value / oi.price * 100), 1) AS freight_pct
FROM olist_sales_data_set.olist_order_items_dataset oi
JOIN olist_sales_data_set.olist_products_dataset p ON oi.product_id = p.product_id
JOIN olist_sales_data_set.product_category_name_translation pct 
    ON p.product_category_name = pct.product_category_name
WHERE pct.product_category_name_english IN (
    'health_beauty', 'computers_accessories', 'watches_gifts', 'toys', 'electronics'
)
ORDER BY 
    category ASC,           -- Group by category
    total_value DESC,       -- Highest value first within category
    freight_pct ASC         -- Best shipping deals first
LIMIT 50;

-- =====================================================
-- 3. BUSINESS PRIORITY SORTING
-- =====================================================

-- Customer order prioritization for fulfillment
-- Priority: High value orders with efficient shipping first
SELECT 
    oi.order_id,
    oi.product_id,
    oi.price,
    oi.freight_value,
    pct.product_category_name_english,
    p.product_weight_g,
    
    -- Business metrics for prioritization
    oi.price + oi.freight_value AS total_value,
    ROUND((oi.freight_value / oi.price * 100), 1) AS freight_efficiency_pct,
    
    -- Priority categorization
    CASE 
        WHEN oi.price > 500 THEN 'High Value'
        WHEN oi.price > 200 THEN 'Medium Value'
        ELSE 'Standard'
    END AS value_tier,
    
    CASE 
        WHEN (oi.freight_value / oi.price) < 0.15 THEN 'Efficient Shipping'
        WHEN (oi.freight_value / oi.price) < 0.30 THEN 'Standard Shipping'
        ELSE 'High Shipping Cost'
    END AS shipping_tier

FROM olist_sales_data_set.olist_order_items_dataset oi
JOIN olist_sales_data_set.olist_products_dataset p ON oi.product_id = p.product_id
JOIN olist_sales_data_set.product_category_name_translation pct 
    ON p.product_category_name = pct.product_category_name
WHERE oi.price > 0
ORDER BY 
    -- Primary: Value tier (High Value first)
    CASE 
        WHEN oi.price > 500 THEN 1
        WHEN oi.price > 200 THEN 2
        ELSE 3
    END,
    -- Secondary: Shipping efficiency (better efficiency first)
    freight_efficiency_pct ASC,
    -- Tertiary: Total value (highest first)
    total_value DESC
LIMIT 40;

-- =====================================================
-- 4. CATEGORY PERFORMANCE RANKINGS
-- =====================================================

-- Category analysis: Best performing categories by various metrics
WITH category_metrics AS (
    SELECT 
        pct.product_category_name_english AS category,
        COUNT(*) as order_count,
        AVG(oi.price) as avg_price,
        AVG(oi.freight_value) as avg_freight,
        AVG(oi.price + oi.freight_value) as avg_total_value,
        AVG(oi.freight_value / oi.price * 100) as avg_freight_pct,
        MAX(oi.price) as max_price,
        MIN(oi.price) as min_price
    FROM olist_sales_data_set.olist_order_items_dataset oi
    JOIN olist_sales_data_set.olist_products_dataset p ON oi.product_id = p.product_id
    JOIN olist_sales_data_set.product_category_name_translation pct 
        ON p.product_category_name = pct.product_category_name
    WHERE oi.price > 0
    GROUP BY pct.product_category_name_english
    HAVING COUNT(*) >= 100  -- Focus on categories with substantial data
)
SELECT 
    category,
    order_count,
    ROUND(avg_price, 2) as avg_price,
    ROUND(avg_freight, 2) as avg_freight,
    ROUND(avg_total_value, 2) as avg_total_value,
    ROUND(avg_freight_pct, 1) as avg_freight_pct,
    ROUND(max_price, 2) as max_price,
    ROUND(min_price, 2) as min_price,
    
    -- Category performance score (higher is better)
    ROUND((avg_price * order_count / 1000), 2) as performance_score
FROM category_metrics
ORDER BY 
    performance_score DESC,  -- Best performing categories first
    avg_freight_pct ASC,     -- Most efficient shipping second
    order_count DESC         -- Highest volume third
LIMIT 20;

-- =====================================================
-- 5. PRODUCT EFFICIENCY RANKINGS
-- =====================================================

-- Find most efficient products by size, weight, and value
SELECT 
    oi.product_id,
    pct.product_category_name_english,
    oi.price,
    p.product_weight_g,
    p.product_length_cm * p.product_height_cm * p.product_width_cm AS volume_cm3,
    
    -- Efficiency metrics
    CASE 
        WHEN p.product_weight_g > 0 
        THEN ROUND(oi.price / p.product_weight_g, 4)
        ELSE NULL 
    END AS price_per_gram,
    
    CASE 
        WHEN (p.product_length_cm * p.product_height_cm * p.product_width_cm) > 0
        THEN ROUND(oi.price / (p.product_length_cm * p.product_height_cm * p.product_width_cm), 6)
        ELSE NULL
    END AS value_density,
    
    -- Combined efficiency score
    CASE 
        WHEN p.product_weight_g > 0 AND (p.product_length_cm * p.product_height_cm * p.product_width_cm) > 0
        THEN ROUND(oi.price / SQRT(p.product_weight_g * (p.product_length_cm * p.product_height_cm * p.product_width_cm)), 8)
        ELSE NULL
    END AS efficiency_score

FROM olist_sales_data_set.olist_order_items_dataset oi
JOIN olist_sales_data_set.olist_products_dataset p ON oi.product_id = p.product_id
JOIN olist_sales_data_set.product_category_name_translation pct 
    ON p.product_category_name = pct.product_category_name
WHERE oi.price > 0 
    AND p.product_weight_g > 0
    AND p.product_length_cm > 0 
    AND p.product_height_cm > 0 
    AND p.product_width_cm > 0
ORDER BY 
    efficiency_score DESC NULLS LAST,  -- Most efficient first
    value_density DESC,                -- Highest value density second
    price_per_gram DESC                -- Best price per gram third
LIMIT 35;

-- =====================================================
-- 6. FREIGHT COST ANALYSIS WITH SORTING
-- =====================================================

-- Identify products with unusual freight patterns
SELECT 
    oi.order_id,
    oi.product_id,
    pct.product_category_name_english,
    oi.price,
    oi.freight_value,
    p.product_weight_g,
    
    ROUND((oi.freight_value / oi.price * 100), 2) AS freight_percentage,
    
    -- Freight efficiency categories
    CASE 
        WHEN oi.freight_value = 0 THEN 'Free Shipping'
        WHEN (oi.freight_value / oi.price) < 0.10 THEN 'Excellent'
        WHEN (oi.freight_value / oi.price) < 0.20 THEN 'Good'
        WHEN (oi.freight_value / oi.price) < 0.30 THEN 'Average'
        ELSE 'High Cost'
    END AS freight_efficiency,
    
    -- Weight-based shipping cost
    CASE 
        WHEN p.product_weight_g > 0 
        THEN ROUND(oi.freight_value / (p.product_weight_g / 1000.0), 2)
        ELSE NULL
    END AS cost_per_kg

FROM olist_sales_data_set.olist_order_items_dataset oi
JOIN olist_sales_data_set.olist_products_dataset p ON oi.product_id = p.product_id
JOIN olist_sales_data_set.product_category_name_translation pct 
    ON p.product_category_name = pct.product_category_name
WHERE oi.price > 0 AND p.product_weight_g > 0
ORDER BY 
    -- Sort by freight efficiency category
    CASE 
        WHEN oi.freight_value = 0 THEN 1
        WHEN (oi.freight_value / oi.price) < 0.10 THEN 2
        WHEN (oi.freight_value / oi.price) < 0.20 THEN 3
        WHEN (oi.freight_value / oi.price) < 0.30 THEN 4
        ELSE 5
    END,
    -- Then by price (highest first within each efficiency category)
    oi.price DESC,
    -- Finally by cost per kg (lowest first)
    cost_per_kg ASC NULLS LAST
LIMIT 50;

-- =====================================================
-- BUSINESS QUESTIONS TO EXPLORE WITH SORTING:
-- =====================================================

/*
1. Which products offer the best value for money?
2. How do shipping costs vary by product category and weight?
3. Which categories have the most consistent pricing?
4. What products have unusual freight-to-price ratios?
5. How should we prioritize order fulfillment for maximum efficiency?

Practice these sorting patterns to become proficient at discovering
business insights through strategic data ordering!
*/