-- Week 3: SQL CASE Statements & Conditional Logic
-- Part 3: Advanced Business Categorization and Decision Logic

-- =====================================================
-- BUSINESS CONTEXT: Product Categorization & Segmentation
-- =====================================================

-- Nigerian e-commerce platforms need sophisticated categorization systems
-- for pricing strategies, inventory management, and customer targeting.
-- CASE statements provide the conditional logic needed for business rules.

-- =====================================================
-- 1. BASIC CASE STATEMENT - PRICE CATEGORIZATION
-- =====================================================

-- Categorize products by price tiers for marketing campaigns
SELECT 
    oi.product_id,
    oi.price,
    pct.product_category_name_english,
    
    -- Basic price categorization (in Brazilian Real, approximate Nigerian Naira conversion)
    CASE 
        WHEN oi.price < 25 THEN 'Budget (₦0-12,500)'
        WHEN oi.price BETWEEN 25 AND 100 THEN 'Economy (₦12,500-50,000)'
        WHEN oi.price BETWEEN 100 AND 300 THEN 'Mid-Range (₦50,000-150,000)'
        WHEN oi.price BETWEEN 300 AND 800 THEN 'Premium (₦150,000-400,000)'
        ELSE 'Luxury (₦400,000+)'
    END AS price_category,
    
    -- Simple binary categorization
    CASE 
        WHEN oi.price > 200 THEN 'High Value'
        ELSE 'Standard Value'
    END AS value_tier,
    
    -- Freight evaluation
    CASE 
        WHEN oi.freight_value = 0 THEN 'Free Shipping'
        WHEN oi.freight_value < 10 THEN 'Low Shipping'
        WHEN oi.freight_value < 25 THEN 'Standard Shipping'
        ELSE 'High Shipping'
    END AS shipping_cost_tier

FROM olist_sales_data_set.olist_order_items_dataset oi
JOIN olist_sales_data_set.olist_products_dataset p ON oi.product_id = p.product_id
JOIN olist_sales_data_set.product_category_name_translation pct 
    ON p.product_category_name = pct.product_category_name
WHERE oi.price > 0
ORDER BY oi.price DESC
LIMIT 30;

-- =====================================================
-- 2. COMPLEX BUSINESS LOGIC - MULTIPLE CONDITIONS
-- =====================================================

-- Advanced shipping efficiency analysis with multiple business rules
SELECT 
    oi.order_id,
    oi.price,
    oi.freight_value,
    p.product_weight_g,
    pct.product_category_name_english,
    
    -- Multi-condition shipping efficiency scoring
    CASE 
        WHEN oi.freight_value = 0 THEN 'Free Shipping ⭐⭐⭐⭐⭐'
        WHEN (oi.freight_value / oi.price) < 0.05 THEN 'Excellent Efficiency ⭐⭐⭐⭐'
        WHEN (oi.freight_value / oi.price) < 0.10 THEN 'Very Good ⭐⭐⭐'
        WHEN (oi.freight_value / oi.price) < 0.20 THEN 'Good ⭐⭐'
        WHEN (oi.freight_value / oi.price) < 0.30 THEN 'Average ⭐'
        ELSE 'Poor Efficiency ❌'
    END AS shipping_efficiency_score,
    
    -- Weight-based product classification
    CASE 
        WHEN p.product_weight_g IS NULL THEN 'Weight Unknown'
        WHEN p.product_weight_g < 200 THEN 'Ultra Light'
        WHEN p.product_weight_g < 500 THEN 'Light'
        WHEN p.product_weight_g < 1000 THEN 'Medium'
        WHEN p.product_weight_g < 3000 THEN 'Heavy'
        WHEN p.product_weight_g < 5000 THEN 'Very Heavy'
        ELSE 'Bulk Item'
    END AS weight_category,
    
    -- Business priority assignment (complex multi-factor analysis)
    CASE 
        WHEN oi.price > 500 AND (oi.freight_value / oi.price) < 0.15 AND p.product_weight_g < 2000 
        THEN 'VIP Priority 🏆'
        
        WHEN oi.price > 300 AND (oi.freight_value / oi.price) < 0.20 
        THEN 'High Priority 🚀'
        
        WHEN oi.price > 100 AND (oi.freight_value / oi.price) < 0.25 
        THEN 'Standard Priority ✅'
        
        WHEN (oi.freight_value / oi.price) > 0.40 
        THEN 'Review Required ⚠️'
        
        ELSE 'Low Priority 📦'
    END AS fulfillment_priority,
    
    -- Profitability assessment
    CASE 
        WHEN oi.price > 200 AND (oi.freight_value / oi.price) < 0.15 THEN 'High Profit Potential'
        WHEN oi.price > 100 AND (oi.freight_value / oi.price) < 0.25 THEN 'Good Profit Potential' 
        WHEN oi.price > 50 AND (oi.freight_value / oi.price) < 0.35 THEN 'Moderate Profit'
        ELSE 'Low Profit Margin'
    END AS profit_category

FROM olist_sales_data_set.olist_order_items_dataset oi
JOIN olist_sales_data_set.olist_products_dataset p ON oi.product_id = p.product_id
JOIN olist_sales_data_set.product_category_name_translation pct 
    ON p.product_category_name = pct.product_category_name
WHERE oi.price > 0
ORDER BY 
    CASE 
        WHEN oi.price > 500 AND (oi.freight_value / oi.price) < 0.15 AND p.product_weight_g < 2000 THEN 1
        WHEN oi.price > 300 AND (oi.freight_value / oi.price) < 0.20 THEN 2
        WHEN oi.price > 100 AND (oi.freight_value / oi.price) < 0.25 THEN 3
        WHEN (oi.freight_value / oi.price) > 0.40 THEN 4
        ELSE 5
    END,
    oi.price DESC
LIMIT 40;

-- =====================================================
-- 3. NESTED CASE STATEMENTS - ADVANCED CATEGORIZATION
-- =====================================================

-- Product recommendation engine logic with nested conditions
SELECT 
    oi.product_id,
    pct.product_category_name_english,
    oi.price,
    oi.freight_value,
    p.product_weight_g,
    
    -- Nested CASE for sophisticated product recommendation
    CASE pct.product_category_name_english
        WHEN 'health_beauty' THEN 
            CASE 
                WHEN oi.price < 50 THEN 'Essential Beauty - Budget Friendly'
                WHEN oi.price < 150 THEN 'Premium Beauty - Good Value'
                ELSE 'Luxury Beauty - High End'
            END
            
        WHEN 'computers_accessories' THEN
            CASE 
                WHEN oi.price < 100 THEN 'Tech Accessories - Basic'
                WHEN oi.price < 400 THEN 'Tech Accessories - Professional'
                ELSE 'Tech Accessories - Premium'
            END
            
        WHEN 'watches_gifts' THEN
            CASE 
                WHEN oi.price < 100 THEN 'Everyday Accessories'
                WHEN oi.price < 500 THEN 'Special Occasion Gifts'
                ELSE 'Luxury Timepieces & Gifts'
            END
            
        WHEN 'toys' THEN
            CASE 
                WHEN oi.price < 30 THEN 'Pocket Money Toys'
                WHEN oi.price < 100 THEN 'Birthday Gift Range'
                ELSE 'Premium Educational Toys'
            END
            
        ELSE 
            CASE 
                WHEN oi.price < 50 THEN 'Budget Category'
                WHEN oi.price < 200 THEN 'Mid-Range Category'
                ELSE 'Premium Category'
            END
    END AS product_positioning,
    
    -- Inventory management recommendations
    CASE 
        WHEN pct.product_category_name_english IN ('health_beauty', 'computers_accessories') 
             AND oi.price > 100 
        THEN 'Fast Moving - Restock Weekly'
        
        WHEN pct.product_category_name_english IN ('toys', 'watches_gifts') 
             AND oi.price BETWEEN 50 AND 300
        THEN 'Seasonal Demand - Monitor Trends'
        
        WHEN p.product_weight_g > 5000 
        THEN 'Bulk Item - Special Handling'
        
        ELSE 'Standard Inventory'
    END AS inventory_strategy,
    
    -- Customer targeting recommendations  
    CASE 
        WHEN oi.price < 25 AND (oi.freight_value / oi.price) < 0.20 
        THEN 'Mass Market - Price Sensitive'
        
        WHEN oi.price BETWEEN 100 AND 500 AND (oi.freight_value / oi.price) < 0.15
        THEN 'Middle Class - Value Conscious'
        
        WHEN oi.price > 500 
        THEN 'Premium Segment - Quality Focused'
        
        WHEN (oi.freight_value / oi.price) > 0.30
        THEN 'Local Market - Shipping Sensitive'
        
        ELSE 'General Market'
    END AS target_customer_segment

FROM olist_sales_data_set.olist_order_items_dataset oi
JOIN olist_sales_data_set.olist_products_dataset p ON oi.product_id = p.product_id
JOIN olist_sales_data_set.product_category_name_translation pct 
    ON p.product_category_name = pct.product_category_name
WHERE oi.price > 0 
    AND pct.product_category_name_english IN (
        'health_beauty', 'computers_accessories', 'watches_gifts', 'toys', 'electronics'
    )
ORDER BY pct.product_category_name_english, oi.price DESC
LIMIT 50;

-- =====================================================
-- 4. BUSINESS RULES ENGINE - OPERATIONAL DECISIONS
-- =====================================================

-- Automated business decision system using CASE statements
SELECT 
    oi.order_id,
    oi.product_id,
    pct.product_category_name_english,
    oi.price,
    oi.freight_value,
    p.product_weight_g,
    
    -- Shipping method recommendation
    CASE 
        WHEN p.product_weight_g > 10000 OR (p.product_length_cm * p.product_height_cm * p.product_width_cm) > 50000 
        THEN 'Freight Shipping Required'
        
        WHEN oi.price > 1000 
        THEN 'Express Shipping Recommended'
        
        WHEN p.product_weight_g < 500 AND oi.price > 200
        THEN 'Premium Packaging + Fast Delivery'
        
        WHEN (oi.freight_value / oi.price) < 0.10
        THEN 'Standard Shipping Optimized'
        
        ELSE 'Economy Shipping Suitable'
    END AS shipping_recommendation,
    
    -- Warehouse location assignment
    CASE 
        WHEN pct.product_category_name_english IN ('electronics', 'computers_accessories') 
        THEN 'Electronics Warehouse - Security Required'
        
        WHEN pct.product_category_name_english IN ('health_beauty', 'perfumery')
        THEN 'Climate Controlled Warehouse'
        
        WHEN p.product_weight_g > 5000
        THEN 'Heavy Goods Warehouse'
        
        WHEN oi.price > 500
        THEN 'Premium Storage Facility'
        
        ELSE 'General Warehouse'
    END AS warehouse_assignment,
    
    -- Quality control requirements
    CASE 
        WHEN oi.price > 1000 THEN 'Full Inspection Required'
        WHEN oi.price > 300 THEN 'Standard Quality Check'
        WHEN pct.product_category_name_english IN ('health_beauty', 'baby') THEN 'Safety Inspection Required'
        WHEN p.product_weight_g > 3000 THEN 'Structural Integrity Check'
        ELSE 'Visual Inspection Only'
    END AS quality_control_level,
    
    -- Insurance requirement
    CASE 
        WHEN oi.price > 2000 THEN 'Full Insurance Coverage'
        WHEN oi.price > 500 THEN 'Standard Insurance'  
        WHEN oi.price > 100 THEN 'Basic Coverage'
        ELSE 'No Insurance Required'
    END AS insurance_requirement,
    
    -- Customer communication priority
    CASE 
        WHEN oi.price > 1000 THEN 'VIP Communication - Manager Follow-up'
        WHEN oi.price > 300 THEN 'Priority Communication - Same Day Response'
        WHEN (oi.freight_value / oi.price) > 0.30 THEN 'Proactive Communication - Shipping Explanation'
        ELSE 'Standard Communication'
    END AS communication_priority

FROM olist_sales_data_set.olist_order_items_dataset oi
JOIN olist_sales_data_set.olist_products_dataset p ON oi.product_id = p.product_id
JOIN olist_sales_data_set.product_category_name_translation pct 
    ON p.product_category_name = pct.product_category_name
WHERE oi.price > 0
ORDER BY oi.price DESC, communication_priority
LIMIT 30;

-- =====================================================
-- 5. CASE WITH AGGREGATION - CATEGORY ANALYSIS
-- =====================================================

-- Category performance analysis using CASE in aggregations
SELECT 
    pct.product_category_name_english,
    COUNT(*) as total_orders,
    
    -- Count by price categories
    SUM(CASE WHEN oi.price < 50 THEN 1 ELSE 0 END) as budget_orders,
    SUM(CASE WHEN oi.price BETWEEN 50 AND 200 THEN 1 ELSE 0 END) as mid_range_orders,
    SUM(CASE WHEN oi.price > 200 THEN 1 ELSE 0 END) as premium_orders,
    
    -- Revenue by price categories  
    SUM(CASE WHEN oi.price < 50 THEN oi.price ELSE 0 END) as budget_revenue,
    SUM(CASE WHEN oi.price BETWEEN 50 AND 200 THEN oi.price ELSE 0 END) as mid_range_revenue,
    SUM(CASE WHEN oi.price > 200 THEN oi.price ELSE 0 END) as premium_revenue,
    
    -- Shipping efficiency analysis
    AVG(CASE WHEN (oi.freight_value / oi.price) < 0.20 THEN oi.price ELSE NULL END) as avg_efficient_shipping_price,
    COUNT(CASE WHEN (oi.freight_value / oi.price) > 0.30 THEN 1 END) as high_shipping_cost_orders,
    
    -- Performance scoring
    CASE 
        WHEN AVG(oi.price) > 200 AND COUNT(*) > 1000 THEN 'Star Category ⭐'
        WHEN AVG(oi.price) > 100 AND COUNT(*) > 500 THEN 'Strong Performer 🚀'
        WHEN COUNT(*) > 2000 THEN 'High Volume Category 📈'
        ELSE 'Standard Category'
    END as category_performance_rating

FROM olist_sales_data_set.olist_order_items_dataset oi
JOIN olist_sales_data_set.olist_products_dataset p ON oi.product_id = p.product_id
JOIN olist_sales_data_set.product_category_name_translation pct 
    ON p.product_category_name = pct.product_category_name
WHERE oi.price > 0
GROUP BY pct.product_category_name_english
HAVING COUNT(*) >= 100  -- Focus on categories with substantial data
ORDER BY 
    CASE 
        WHEN AVG(oi.price) > 200 AND COUNT(*) > 1000 THEN 1
        WHEN AVG(oi.price) > 100 AND COUNT(*) > 500 THEN 2
        WHEN COUNT(*) > 2000 THEN 3
        ELSE 4
    END,
    total_orders DESC
LIMIT 25;

-- =====================================================
-- PRACTICAL BUSINESS APPLICATIONS
-- =====================================================

/*
CASE statements enable sophisticated business logic:

1. **Dynamic Pricing**: Adjust strategies based on competition and costs
2. **Inventory Management**: Categorize products for different storage needs  
3. **Customer Segmentation**: Target different groups with appropriate messaging
4. **Operational Efficiency**: Automate decisions for shipping, quality control
5. **Performance Analysis**: Create meaningful business categories for reporting

Practice these patterns to build robust business intelligence systems!
*/

-- Advanced Challenge Query: Complete Business Intelligence Dashboard Logic
SELECT 
    pct.product_category_name_english,
    oi.product_id,
    oi.price,
    
    -- Multi-dimensional classification system
    CASE 
        WHEN oi.price > 500 AND (oi.freight_value / oi.price) < 0.10 THEN 'Premium Efficient'
        WHEN oi.price > 200 AND (oi.freight_value / oi.price) < 0.20 THEN 'High Value Good'  
        WHEN oi.price < 50 AND (oi.freight_value / oi.price) < 0.25 THEN 'Budget Optimized'
        WHEN (oi.freight_value / oi.price) > 0.35 THEN 'Shipping Challenge'
        ELSE 'Standard Product'
    END as business_classification,
    
    -- Action recommendations
    CASE 
        WHEN oi.price > 500 AND (oi.freight_value / oi.price) < 0.10 THEN 'Promote Heavily'
        WHEN (oi.freight_value / oi.price) > 0.35 THEN 'Review Logistics'
        WHEN oi.price < 25 THEN 'Bundle Opportunity'
        ELSE 'Monitor Performance'
    END as recommended_action
    
FROM olist_sales_data_set.olist_order_items_dataset oi
JOIN olist_sales_data_set.olist_products_dataset p ON oi.product_id = p.product_id
JOIN olist_sales_data_set.product_category_name_translation pct 
    ON p.product_category_name = pct.product_category_name
WHERE oi.price > 0
ORDER BY 
    CASE 
        WHEN oi.price > 500 AND (oi.freight_value / oi.price) < 0.10 THEN 1
        WHEN oi.price > 200 AND (oi.freight_value / oi.price) < 0.20 THEN 2
        WHEN oi.price < 50 AND (oi.freight_value / oi.price) < 0.25 THEN 3
        WHEN (oi.freight_value / oi.price) > 0.35 THEN 4
        ELSE 5
    END
LIMIT 50;