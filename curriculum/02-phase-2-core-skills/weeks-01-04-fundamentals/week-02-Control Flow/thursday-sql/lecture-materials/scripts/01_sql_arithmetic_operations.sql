-- Week 02 - SQL Arithmetic Operations & Control Structures
-- Building on Wednesday's Python operators and control structures 
-- Using real Olist Brazilian e-commerce dataset for synchronized learning

-- =============================================================================
-- PART 1: ARITHMETIC OPERATIONS WITH REAL OLIST DATA
-- =============================================================================

-- Business scenario: Order calculations using same logic as Wednesday's Python session
-- Direct translation of Wednesday's arithmetic operators to SQL

-- Basic arithmetic with order items (matching Wednesday's Python examples)
SELECT 
    order_id,
    product_id,
    price,
    freight_value,
    
    -- Basic arithmetic operations (same as Wednesday's Python)
    -- total_cost = price + freight_value  
    price + freight_value AS total_cost,
    
    -- markup_price = price * 1.15 (15% markup)
    price * 1.15 AS markup_price,
    
    -- discount_price = price * 0.9 (10% discount)
    price * 0.9 AS discount_price,
    
    -- profit_margin = (price - estimated_cost) / price
    -- Assuming cost is 70% of price
    (price - (price * 0.7)) / NULLIF(price, 0) AS profit_margin_percent,
    
    -- shipping_ratio = freight_value / price  
    freight_value / NULLIF(price, 0) AS shipping_to_price_ratio

FROM olist_sales_data_set.olist_order_items_dataset 
WHERE price > 0 AND freight_value > 0
LIMIT 10;

-- =============================================================================
-- PART 2: CONDITIONAL LOGIC WITH CASE WHEN (SQL's if/elif/else)
-- =============================================================================

-- Product price categorization (matching Wednesday's Python control structures)
SELECT 
    product_id,
    price,
    freight_value,
    
    -- Python if/elif/else equivalent using CASE WHEN
    CASE 
        WHEN price >= 200 THEN 'Premium'
        WHEN price >= 100 THEN 'Standard' 
        WHEN price >= 50 THEN 'Budget'
        ELSE 'Economy'
    END AS price_tier,
    
    -- Shipping cost category
    CASE 
        WHEN freight_value >= 30 THEN 'Expensive Shipping'
        WHEN freight_value >= 15 THEN 'Standard Shipping'
        WHEN freight_value >= 5 THEN 'Cheap Shipping'
        ELSE 'Very Cheap Shipping'
    END AS shipping_category,
    
    -- Combined business logic (nested conditions)
    CASE 
        WHEN price >= 200 AND freight_value < 20 THEN 'Premium Deal'
        WHEN price >= 100 AND freight_value < 15 THEN 'Good Value'
        WHEN price < 50 AND freight_value < 10 THEN 'Budget Option'
        ELSE 'Standard Option'
    END AS deal_category

FROM olist_sales_data_set.olist_order_items_dataset 
WHERE price > 0 AND freight_value > 0
LIMIT 15;

-- =============================================================================
-- PART 3: COMPLEX ARITHMETIC WITH CONDITIONALS
-- =============================================================================

-- Dynamic pricing based on business rules (matching Wednesday's Python loops & conditions)
SELECT 
    order_id,
    price,
    freight_value,
    
    -- Calculate final price with conditional discounts
    CASE 
        WHEN price >= 500 THEN price * 0.85  -- 15% discount for high value
        WHEN price >= 200 THEN price * 0.92  -- 8% discount for medium value  
        WHEN price >= 100 THEN price * 0.95  -- 5% discount for standard value
        ELSE price                            -- No discount for low value
    END AS discounted_price,
    
    -- Calculate shipping fees with conditional logic
    CASE 
        WHEN price >= 200 THEN 0              -- Free shipping for premium items
        WHEN price >= 100 THEN freight_value * 0.5  -- 50% shipping discount
        ELSE freight_value                    -- Full shipping cost
    END AS final_shipping_cost,
    
    -- Total order value (price + shipping after all discounts)
    (CASE 
        WHEN price >= 500 THEN price * 0.85
        WHEN price >= 200 THEN price * 0.92
        WHEN price >= 100 THEN price * 0.95
        ELSE price
    END) + 
    (CASE 
        WHEN price >= 200 THEN 0
        WHEN price >= 100 THEN freight_value * 0.5
        ELSE freight_value
    END) AS final_total

FROM olist_sales_data_set.olist_order_items_dataset 
WHERE price > 0 AND freight_value > 0
ORDER BY price DESC
LIMIT 12;

-- =============================================================================
-- PART 4: BUSINESS INTELLIGENCE WITH AGGREGATIONS & CONDITIONS
-- =============================================================================

-- Order analysis by payment type (matching Wednesday's Python data processing)
SELECT 
    p.payment_type,
    COUNT(*) AS order_count,
    
    -- Average calculations with arithmetic
    AVG(oi.price) AS avg_item_price,
    AVG(oi.freight_value) AS avg_shipping,
    AVG(oi.price + oi.freight_value) AS avg_total_cost,
    
    -- Conditional aggregations (advanced control structures)
    COUNT(CASE WHEN oi.price >= 200 THEN 1 END) AS premium_items,
    COUNT(CASE WHEN oi.price BETWEEN 50 AND 199 THEN 1 END) AS standard_items,
    COUNT(CASE WHEN oi.price < 50 THEN 1 END) AS budget_items,
    
    -- Percentage calculations
    COUNT(CASE WHEN oi.price >= 200 THEN 1 END) * 100.0 / COUNT(*) AS premium_percentage

FROM olist_sales_data_set.olist_order_payments_dataset p
JOIN olist_sales_data_set.olist_order_items_dataset oi ON p.order_id = oi.order_id
WHERE p.payment_type IS NOT NULL
GROUP BY p.payment_type
ORDER BY order_count DESC
LIMIT 5;

-- =============================================================================
-- PART 5: CUSTOMER SEGMENTATION WITH COMPLEX LOGIC
-- =============================================================================

-- Multi-factor customer analysis (matching Wednesday's Python nested conditions)
WITH customer_orders AS (
    SELECT 
        c.customer_state,
        o.customer_id,
        COUNT(DISTINCT o.order_id) AS total_orders,
        SUM(oi.price) AS total_spent,
        AVG(oi.price) AS avg_order_value,
        MAX(oi.price) AS highest_purchase
    FROM olist_sales_data_set.olist_customers_dataset c
    JOIN olist_sales_data_set.olist_orders_dataset o ON c.customer_id = o.customer_id  
    JOIN olist_sales_data_set.olist_order_items_dataset oi ON o.order_id = oi.order_id
    GROUP BY c.customer_state, o.customer_id
)
SELECT 
    customer_state,
    customer_id,
    total_orders,
    total_spent,
    avg_order_value,
    
    -- Multi-condition customer tiering (like Wednesday's Python nested if statements)
    CASE 
        WHEN total_spent >= 1000 AND total_orders >= 5 THEN 'VIP Customer'
        WHEN total_spent >= 500 AND total_orders >= 3 THEN 'Premium Customer'  
        WHEN total_spent >= 200 OR total_orders >= 2 THEN 'Regular Customer'
        ELSE 'New Customer'
    END AS customer_tier,
    
    -- Loyalty score calculation (arithmetic + conditions)
    (total_orders * 10) + 
    (CASE 
        WHEN total_spent >= 1000 THEN 100
        WHEN total_spent >= 500 THEN 50
        WHEN total_spent >= 200 THEN 25
        ELSE 10
    END) AS loyalty_score,
    
    -- Personalized discount rate
    CASE 
        WHEN total_spent >= 1000 THEN 15  -- 15% discount for VIP
        WHEN total_spent >= 500 THEN 10   -- 10% discount for Premium
        WHEN total_orders >= 3 THEN 5     -- 5% discount for frequent buyers
        ELSE 0                             -- No discount for others
    END AS discount_rate_percent

FROM customer_orders
WHERE total_spent > 0
ORDER BY loyalty_score DESC
LIMIT 20;


/*
===============================================================================
KEY LEARNING POINTS - PYTHON TO SQL TRANSLATION:
===============================================================================

1. ARITHMETIC OPERATIONS:
   Python: total = price + shipping       →  SQL: price + freight_value AS total
   Python: discounted = price * 0.9      →  SQL: price * 0.9 AS discounted  
   Python: margin = (price - cost)/price  →  SQL: (price - cost)/price AS margin

2. CONDITIONAL LOGIC:
   Python: if price >= 200:              →  SQL: CASE WHEN price >= 200 THEN
           elif price >= 100:                     WHEN price >= 100 THEN  
           else:                                  ELSE ... END

3. BOOLEAN OPERATIONS:
   Python: if price > 100 and shipping < 20  →  SQL: WHEN price > 100 AND freight_value < 20

4. LOOPS & AGGREGATIONS:
   Python: for order in orders:          →  SQL: GROUP BY with aggregate functions
           total += order.price                  SUM(price), COUNT(*), AVG(price)

5. NESTED CONDITIONS:
   Python: nested if statements           →  SQL: nested CASE WHEN statements
   Python: multiple condition checks      →  SQL: AND, OR operators in WHEN clauses

BUSINESS APPLICATIONS DEMONSTRATED:
- Dynamic pricing with tiered discounts
- Customer segmentation with loyalty scoring  
- Shipping cost optimization
- Payment method analysis
- Multi-factor business intelligence
*/