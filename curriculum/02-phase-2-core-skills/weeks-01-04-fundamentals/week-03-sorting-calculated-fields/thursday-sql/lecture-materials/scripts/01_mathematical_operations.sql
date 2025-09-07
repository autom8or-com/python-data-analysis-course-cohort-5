-- Week 3: SQL Mathematical Operations & Calculated Fields
-- Part 1: Basic Arithmetic and Business Calculations

-- =====================================================
-- BUSINESS CONTEXT: Olist E-commerce Pricing Analysis
-- =====================================================

-- As a data analyst for Olist Nigeria, you need to create calculated fields
-- to analyze order values, shipping costs, and product efficiency metrics.

-- =====================================================
-- 1. BASIC MATHEMATICAL OPERATIONS
-- =====================================================

-- Basic arithmetic in SELECT statements
SELECT 
    order_id,
    price,
    freight_value,
    -- Addition: Total order value
    price + freight_value AS total_order_value,
    
    -- Multiplication: Platform commission (10%)
    price * 0.1 AS platform_commission,
    
    -- Complex calculation: Processing fee (5% of total)
    (price + freight_value) * 0.05 AS processing_fee,
    
    -- Division: Price per freight unit (price efficiency)
    CASE 
        WHEN freight_value > 0 THEN ROUND(price / freight_value, 2)
        ELSE NULL 
    END AS price_freight_ratio

FROM olist_sales_data_set.olist_order_items_dataset
WHERE price > 0 AND freight_value >= 0
ORDER BY total_order_value DESC
LIMIT 20;

-- =====================================================
-- 2. ADVANCED BUSINESS CALCULATIONS  
-- =====================================================

-- Comprehensive e-commerce KPIs with product data
SELECT 
    oi.order_id,
    oi.product_id,
    oi.price,
    oi.freight_value,
    p.product_weight_g,
    pct.product_category_name_english,
    
    -- Total order value
    oi.price + oi.freight_value AS total_order_value,
    
    -- Freight as percentage of price (key logistics KPI)
    ROUND((oi.freight_value / oi.price * 100), 2) AS freight_percentage,
    
    -- Price per gram (efficiency for weight-based products)
    CASE 
        WHEN p.product_weight_g > 0 THEN ROUND(oi.price / p.product_weight_g, 4)
        ELSE NULL 
    END AS price_per_gram,
    
    -- Product volume calculation (for packaging optimization)
    (p.product_length_cm * p.product_height_cm * p.product_width_cm) AS volume_cm3,
    
    -- Value density (price per cubic cm)
    CASE 
        WHEN (p.product_length_cm * p.product_height_cm * p.product_width_cm) > 0
        THEN ROUND(oi.price / (p.product_length_cm * p.product_height_cm * p.product_width_cm), 6)
        ELSE NULL
    END AS value_density,
    
    -- Shipping efficiency score (lower is better)
    CASE 
        WHEN p.product_weight_g > 0 THEN ROUND(oi.freight_value / p.product_weight_g, 4)
        ELSE NULL
    END AS shipping_cost_per_gram

FROM olist_sales_data_set.olist_order_items_dataset oi
JOIN olist_sales_data_set.olist_products_dataset p ON oi.product_id = p.product_id
JOIN olist_sales_data_set.product_category_name_translation pct 
    ON p.product_category_name = pct.product_category_name
WHERE oi.price > 0 
    AND p.product_weight_g > 0
    AND p.product_length_cm > 0
    AND p.product_height_cm > 0
    AND p.product_width_cm > 0
ORDER BY value_density DESC
LIMIT 30;

-- =====================================================
-- 3. FINANCIAL CALCULATIONS FOR E-COMMERCE
-- =====================================================

-- Revenue and margin calculations
SELECT 
    oi.order_id,
    oi.price AS product_price,
    oi.freight_value,
    
    -- Gross revenue
    oi.price + oi.freight_value AS gross_revenue,
    
    -- Estimated costs (assuming 60% product cost, 15% operational cost)
    oi.price * 0.60 AS estimated_product_cost,
    oi.price * 0.15 AS estimated_operational_cost,
    
    -- Gross profit calculation
    oi.price - (oi.price * 0.60) - (oi.price * 0.15) AS estimated_gross_profit,
    
    -- Gross profit margin percentage
    ROUND(((oi.price - (oi.price * 0.75)) / oi.price * 100), 2) AS gross_profit_margin_pct,
    
    -- Revenue per order item
    (oi.price + oi.freight_value) / oi.order_item_id AS revenue_per_item,
    
    -- Break-even analysis: minimum orders needed for profitability
    CASE 
        WHEN (oi.price - (oi.price * 0.75)) > 0 
        THEN CEILING(100 / (oi.price - (oi.price * 0.75)))
        ELSE NULL
    END AS breakeven_order_count

FROM olist_sales_data_set.olist_order_items_dataset oi
WHERE oi.price > 0
ORDER BY estimated_gross_profit DESC
LIMIT 25;

-- =====================================================
-- 4. COMPARATIVE CALCULATIONS
-- =====================================================

-- Price comparison within product categories
SELECT 
    pct.product_category_name_english,
    oi.product_id,
    oi.price,
    
    -- Calculate category averages for comparison
    AVG(oi.price) OVER (PARTITION BY pct.product_category_name_english) AS category_avg_price,
    
    -- Price difference from category average
    oi.price - AVG(oi.price) OVER (PARTITION BY pct.product_category_name_english) AS price_diff_from_avg,
    
    -- Price as percentage of category average
    ROUND((oi.price / AVG(oi.price) OVER (PARTITION BY pct.product_category_name_english) * 100), 1) AS price_vs_category_avg_pct,
    
    -- Price ranking within category
    RANK() OVER (PARTITION BY pct.product_category_name_english ORDER BY oi.price DESC) AS price_rank_in_category

FROM olist_sales_data_set.olist_order_items_dataset oi
JOIN olist_sales_data_set.olist_products_dataset p ON oi.product_id = p.product_id
JOIN olist_sales_data_set.product_category_name_translation pct 
    ON p.product_category_name = pct.product_category_name
WHERE pct.product_category_name_english IN ('health_beauty', 'computers_accessories', 'watches_gifts', 'toys')
ORDER BY pct.product_category_name_english, price_rank_in_category
LIMIT 50;

-- =====================================================
-- 5. PRACTICAL BUSINESS SCENARIOS
-- =====================================================

-- Scenario: Identify products with unusual pricing or shipping patterns
SELECT 
    oi.order_id,
    oi.product_id,
    pct.product_category_name_english,
    oi.price,
    oi.freight_value,
    p.product_weight_g,
    
    -- Flag expensive items with low shipping costs (potential premium products)
    CASE 
        WHEN oi.price > 200 AND oi.freight_value < 10 THEN 'High Value, Low Shipping'
        WHEN oi.price < 50 AND oi.freight_value > 20 THEN 'Low Value, High Shipping'  
        WHEN oi.freight_value > oi.price THEN 'Shipping Exceeds Product Price'
        ELSE 'Normal'
    END AS pricing_pattern,
    
    -- Efficiency ratios for business analysis
    ROUND(oi.freight_value / oi.price, 3) AS freight_to_price_ratio,
    
    -- Weight-based shipping efficiency
    CASE 
        WHEN p.product_weight_g > 0 
        THEN ROUND(oi.freight_value / (p.product_weight_g / 1000.0), 2) -- Cost per kg
        ELSE NULL
    END AS shipping_cost_per_kg,
    
    -- Value proposition score (higher is better)
    CASE 
        WHEN oi.freight_value > 0 AND p.product_weight_g > 0
        THEN ROUND((oi.price * 1000) / (oi.freight_value * p.product_weight_g), 2)
        ELSE NULL
    END AS value_proposition_score

FROM olist_sales_data_set.olist_order_items_dataset oi
JOIN olist_sales_data_set.olist_products_dataset p ON oi.product_id = p.product_id
JOIN olist_sales_data_set.product_category_name_translation pct 
    ON p.product_category_name = pct.product_category_name
WHERE oi.price > 0 AND oi.freight_value >= 0
ORDER BY 
    CASE 
        WHEN oi.price > 200 AND oi.freight_value < 10 THEN 1
        WHEN oi.price < 50 AND oi.freight_value > 20 THEN 2  
        WHEN oi.freight_value > oi.price THEN 3
        ELSE 4
    END,
    value_proposition_score DESC NULLS LAST
LIMIT 40;

-- =====================================================
-- BUSINESS INSIGHTS QUESTIONS TO EXPLORE:
-- =====================================================

/*
1. Which product categories offer the best profit margins?
2. Are heavy products being charged appropriately for shipping?
3. Which products have the best value density (high price, small size)?
4. Are there products where shipping costs exceed reasonable thresholds?
5. How do our pricing strategies compare within product categories?

Use these queries as starting points to answer these business questions!
*/