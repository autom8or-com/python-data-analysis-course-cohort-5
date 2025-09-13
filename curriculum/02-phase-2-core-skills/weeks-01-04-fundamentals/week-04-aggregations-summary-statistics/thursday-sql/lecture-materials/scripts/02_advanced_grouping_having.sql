-- ====================================================================
-- WEEK 4: AGGREGATIONS & SUMMARY STATISTICS - PART 2: ADVANCED GROUPING
-- Thursday SQL Class - September 4, 2025
-- Business Context: Advanced Sales Analysis with HAVING and Multi-level Grouping
-- ====================================================================

-- LEARNING OBJECTIVES:
-- 1. Master HAVING clause for filtering aggregated results
-- 2. Implement multi-column GROUP BY for detailed analysis
-- 3. Create business KPIs and performance metrics
-- 4. Apply conditional aggregations for complex business logic

-- ====================================================================
-- SECTION 1: HAVING CLAUSE - FILTERING AGGREGATED RESULTS
-- ====================================================================

-- The WHERE vs HAVING difference:
-- WHERE filters individual rows BEFORE grouping
-- HAVING filters groups AFTER aggregation

-- 1.1 Basic HAVING usage
-- Business Question: Which states have generated more than 100,000 in revenue?
SELECT 
    c.customer_state as state,
    COUNT(DISTINCT o.order_id) as total_orders,
    SUM(oi.price) as total_revenue,
    AVG(oi.price) as avg_order_value
FROM olist_sales_data_set.olist_customers_dataset c
JOIN olist_sales_data_set.olist_orders_dataset o ON c.customer_id = o.customer_id
JOIN olist_sales_data_set.olist_order_items_dataset oi ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered'
GROUP BY c.customer_state
HAVING SUM(oi.price) > 100000  -- Filter groups with revenue > 100,000
ORDER BY total_revenue DESC;

-- 1.2 Multiple HAVING conditions
-- Business Question: Which product categories have both high volume AND high value?
-- (Nigerian context: Categories suitable for focus - high volume + high margin)
SELECT 
    t.product_category_name_english as category,
    COUNT(oi.order_id) as total_orders,
    SUM(oi.price) as total_revenue,
    AVG(oi.price) as avg_price
FROM olist_sales_data_set.olist_order_items_dataset oi
JOIN olist_sales_data_set.olist_products_dataset p ON oi.product_id = p.product_id
JOIN olist_sales_data_set.product_category_name_translation t ON p.product_category_name = t.product_category_name
GROUP BY t.product_category_name_english
HAVING COUNT(oi.order_id) >= 1000  -- High volume (at least 1000 orders)
   AND AVG(oi.price) >= 100        -- High value (average price >= 100)
ORDER BY total_revenue DESC;

-- 1.3 Complex HAVING with calculated metrics
-- Business Question: Which sellers have consistent high-value performance?
-- (Above average order value and significant volume)
SELECT 
    s.seller_state,
    s.seller_city,
    COUNT(oi.order_id) as total_orders,
    SUM(oi.price) as total_revenue,
    AVG(oi.price) as avg_order_value,
    COUNT(DISTINCT oi.seller_id) as number_of_sellers
FROM olist_sales_data_set.olist_order_items_dataset oi
JOIN olist_sales_data_set.olist_sellers_dataset s ON oi.seller_id = s.seller_id
JOIN olist_sales_data_set.olist_orders_dataset o ON oi.order_id = o.order_id
WHERE o.order_status = 'delivered'
GROUP BY s.seller_state, s.seller_city
HAVING COUNT(oi.order_id) >= 100        -- Minimum volume threshold
   AND AVG(oi.price) > (                -- Above overall average
       SELECT AVG(price) 
       FROM olist_sales_data_set.olist_order_items_dataset
   )
ORDER BY avg_order_value DESC;

-- ====================================================================
-- SECTION 2: MULTI-COLUMN GROUP BY - DETAILED BUSINESS ANALYSIS
-- ====================================================================

-- 2.1 Time-based analysis with multiple dimensions
-- Business Question: How do sales vary by state and month?
-- (Nigerian context: Seasonal patterns by different regions)
SELECT 
    c.customer_state,
    EXTRACT(YEAR FROM o.order_purchase_timestamp) as year,
    EXTRACT(MONTH FROM o.order_purchase_timestamp) as month,
    COUNT(DISTINCT o.order_id) as orders,
    SUM(oi.price) as revenue,
    AVG(oi.price) as avg_order_value,
    COUNT(DISTINCT c.customer_id) as unique_customers
FROM olist_sales_data_set.olist_customers_dataset c
JOIN olist_sales_data_set.olist_orders_dataset o ON c.customer_id = o.customer_id
JOIN olist_sales_data_set.olist_order_items_dataset oi ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered'
  AND o.order_purchase_timestamp IS NOT NULL
  AND c.customer_state IN ('SP', 'RJ', 'MG', 'RS', 'PR')  -- Top 5 states
GROUP BY 
    c.customer_state,
    EXTRACT(YEAR FROM o.order_purchase_timestamp),
    EXTRACT(MONTH FROM o.order_purchase_timestamp)
HAVING COUNT(DISTINCT o.order_id) >= 10  -- Only months with sufficient data
ORDER BY customer_state, year, month;

-- 2.2 Product category performance by region
-- Business Question: Which categories perform best in each major state?
SELECT 
    c.customer_state,
    t.product_category_name_english as category,
    COUNT(oi.order_id) as total_orders,
    SUM(oi.price) as total_revenue,
    AVG(oi.price) as avg_price,
    AVG(r.review_score) as avg_rating
FROM olist_sales_data_set.olist_customers_dataset c
JOIN olist_sales_data_set.olist_orders_dataset o ON c.customer_id = o.customer_id
JOIN olist_sales_data_set.olist_order_items_dataset oi ON o.order_id = oi.order_id
JOIN olist_sales_data_set.olist_products_dataset p ON oi.product_id = p.product_id
JOIN olist_sales_data_set.product_category_name_translation t ON p.product_category_name = t.product_category_name
LEFT JOIN olist_sales_data_set.olist_order_reviews_dataset r ON o.order_id = r.order_id
WHERE o.order_status = 'delivered'
  AND c.customer_state IN ('SP', 'RJ', 'MG')  -- Top 3 states for focus
GROUP BY c.customer_state, t.product_category_name_english
HAVING COUNT(oi.order_id) >= 50  -- Categories with sufficient volume per state
ORDER BY customer_state, total_revenue DESC;

-- ====================================================================
-- SECTION 3: CONDITIONAL AGGREGATIONS - ADVANCED BUSINESS LOGIC
-- ====================================================================

-- 3.1 CASE statements within aggregations
-- Business Question: How many high-value vs low-value orders do we have by state?
SELECT 
    c.customer_state,
    COUNT(*) as total_orders,
    SUM(CASE WHEN oi.price >= 100 THEN 1 ELSE 0 END) as high_value_orders,
    SUM(CASE WHEN oi.price < 100 THEN 1 ELSE 0 END) as low_value_orders,
    AVG(CASE WHEN oi.price >= 100 THEN oi.price END) as avg_high_value_price,
    AVG(CASE WHEN oi.price < 100 THEN oi.price END) as avg_low_value_price,
    ROUND(
        SUM(CASE WHEN oi.price >= 100 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 
        2
    ) as high_value_percentage
FROM olist_sales_data_set.olist_customers_dataset c
JOIN olist_sales_data_set.olist_orders_dataset o ON c.customer_id = o.customer_id
JOIN olist_sales_data_set.olist_order_items_dataset oi ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered'
GROUP BY c.customer_state
HAVING COUNT(*) >= 500  -- States with sufficient order volume
ORDER BY high_value_percentage DESC;

-- 3.2 Payment behavior analysis with conditional aggregations
-- Business Question: How do payment preferences vary by order value ranges?
SELECT 
    CASE 
        WHEN oi.price < 50 THEN 'Low Value (< R$50)'
        WHEN oi.price >= 50 AND oi.price < 150 THEN 'Medium Value (R$50-150)'
        WHEN oi.price >= 150 AND oi.price < 300 THEN 'High Value (R$150-300)'
        ELSE 'Premium (R$300+)'
    END as price_category,
    COUNT(*) as total_transactions,
    SUM(CASE WHEN p.payment_type = 'credit_card' THEN 1 ELSE 0 END) as credit_card_count,
    SUM(CASE WHEN p.payment_type = 'boleto' THEN 1 ELSE 0 END) as boleto_count,
    SUM(CASE WHEN p.payment_type = 'debit_card' THEN 1 ELSE 0 END) as debit_card_count,
    SUM(CASE WHEN p.payment_type = 'voucher' THEN 1 ELSE 0 END) as voucher_count,
    AVG(p.payment_installments) as avg_installments,
    ROUND(
        SUM(CASE WHEN p.payment_type = 'credit_card' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 
        2
    ) as credit_card_percentage
FROM olist_sales_data_set.olist_order_items_dataset oi
JOIN olist_sales_data_set.olist_orders_dataset o ON oi.order_id = o.order_id
JOIN olist_sales_data_set.olist_order_payments_dataset p ON o.order_id = p.order_id
WHERE o.order_status = 'delivered'
GROUP BY 
    CASE 
        WHEN oi.price < 50 THEN 'Low Value (< R$50)'
        WHEN oi.price >= 50 AND oi.price < 150 THEN 'Medium Value (R$50-150)'
        WHEN oi.price >= 150 AND oi.price < 300 THEN 'High Value (R$150-300)'
        ELSE 'Premium (R$300+)'
    END
ORDER BY 
    MIN(oi.price);  -- Order by the minimum price in each category

-- ====================================================================
-- SECTION 4: BUSINESS KPI CALCULATIONS
-- ====================================================================

-- 4.1 Customer satisfaction metrics by category
-- Business Question: Calculate comprehensive satisfaction KPIs
SELECT 
    t.product_category_name_english as category,
    COUNT(r.review_id) as total_reviews,
    ROUND(AVG(r.review_score), 2) as avg_rating,
    SUM(CASE WHEN r.review_score = 5 THEN 1 ELSE 0 END) as five_star_reviews,
    SUM(CASE WHEN r.review_score >= 4 THEN 1 ELSE 0 END) as positive_reviews,
    SUM(CASE WHEN r.review_score <= 2 THEN 1 ELSE 0 END) as negative_reviews,
    ROUND(
        SUM(CASE WHEN r.review_score >= 4 THEN 1 ELSE 0 END) * 100.0 / COUNT(r.review_id), 
        2
    ) as satisfaction_rate,
    ROUND(
        SUM(CASE WHEN r.review_score = 5 THEN 1 ELSE 0 END) * 100.0 / COUNT(r.review_id), 
        2
    ) as excellence_rate
FROM olist_sales_data_set.olist_order_reviews_dataset r
JOIN olist_sales_data_set.olist_orders_dataset o ON r.order_id = o.order_id
JOIN olist_sales_data_set.olist_order_items_dataset oi ON o.order_id = oi.order_id
JOIN olist_sales_data_set.olist_products_dataset p ON oi.product_id = p.product_id
JOIN olist_sales_data_set.product_category_name_translation t ON p.product_category_name = t.product_category_name
WHERE r.review_score IS NOT NULL
GROUP BY t.product_category_name_english
HAVING COUNT(r.review_id) >= 100  -- Statistically significant sample
ORDER BY satisfaction_rate DESC, avg_rating DESC;

-- 4.2 Seller performance scorecard
-- Business Question: Create a comprehensive seller evaluation
SELECT 
    s.seller_state,
    s.seller_city,
    COUNT(DISTINCT oi.seller_id) as active_sellers,
    COUNT(oi.order_id) as total_orders,
    SUM(oi.price) as total_revenue,
    AVG(oi.price) as avg_order_value,
    AVG(oi.freight_value) as avg_shipping_cost,
    ROUND(AVG(oi.freight_value) / AVG(oi.price) * 100, 2) as shipping_cost_percentage,
    COUNT(DISTINCT EXTRACT(MONTH FROM o.order_purchase_timestamp)) as active_months,
    ROUND(COUNT(oi.order_id)::decimal / COUNT(DISTINCT oi.seller_id), 1) as orders_per_seller
FROM olist_sales_data_set.olist_order_items_dataset oi
JOIN olist_sales_data_set.olist_sellers_dataset s ON oi.seller_id = s.seller_id
JOIN olist_sales_data_set.olist_orders_dataset o ON oi.order_id = o.order_id
WHERE o.order_status = 'delivered'
  AND o.order_purchase_timestamp IS NOT NULL
GROUP BY s.seller_state, s.seller_city
HAVING COUNT(oi.order_id) >= 50  -- Cities with significant seller activity
ORDER BY total_revenue DESC;

-- ====================================================================
-- BUSINESS INSIGHTS SUMMARY QUERY
-- ====================================================================

-- Master summary: Overall business health metrics
SELECT 
    'Overall Business Performance' as metric_category,
    COUNT(DISTINCT o.order_id) as total_orders,
    COUNT(DISTINCT c.customer_id) as unique_customers,
    COUNT(DISTINCT oi.seller_id) as active_sellers,
    SUM(oi.price) as total_revenue,
    AVG(oi.price) as avg_order_value,
    ROUND(AVG(r.review_score), 2) as avg_customer_satisfaction,
    COUNT(DISTINCT t.product_category_name_english) as active_categories,
    ROUND(
        SUM(CASE WHEN r.review_score >= 4 THEN 1 ELSE 0 END) * 100.0 / COUNT(r.review_id), 
        2
    ) as overall_satisfaction_rate
FROM olist_sales_data_set.olist_orders_dataset o
JOIN olist_sales_data_set.olist_customers_dataset c ON o.customer_id = c.customer_id
JOIN olist_sales_data_set.olist_order_items_dataset oi ON o.order_id = oi.order_id
JOIN olist_sales_data_set.olist_products_dataset p ON oi.product_id = p.product_id
JOIN olist_sales_data_set.product_category_name_translation t ON p.product_category_name = t.product_category_name
LEFT JOIN olist_sales_data_set.olist_order_reviews_dataset r ON o.order_id = r.order_id
WHERE o.order_status = 'delivered';

-- ====================================================================
-- KEY TAKEAWAYS FOR ADVANCED AGGREGATIONS:
-- ====================================================================

/*
1. HAVING filters aggregated results - use after GROUP BY
2. Multi-column GROUP BY enables detailed dimensional analysis
3. CASE statements in aggregations create conditional metrics
4. Combine multiple aggregation techniques for comprehensive KPIs
5. Always consider statistical significance (HAVING COUNT >= threshold)
6. Business context drives which metrics matter most

NEXT WEEK: We'll explore window functions for running totals and rankings!
*/