-- ================================================
-- Week 6: SQL Text Processing & Pattern Matching
-- Part 2: Pattern Matching with LIKE and ILIKE
-- Thursday, September 18, 2025
-- ================================================

-- Business Context: Finding patterns in product categories and customer data
-- Excel Connection: Moving from FIND, SEARCH functions to advanced pattern matching

-- ===================================
-- 1. LIKE OPERATOR FUNDAMENTALS
-- ===================================

-- 1.1 Basic Wildcard Patterns
-- % = zero or more characters (Excel * equivalent)
-- _ = exactly one character (Excel ? equivalent)

-- Find all product categories containing 'casa' (house/home)
SELECT
    product_category_name,
    product_category_name_english
FROM olist_sales_data_set.product_category_name_translation
WHERE product_category_name LIKE '%casa%'
ORDER BY product_category_name;

-- Find cities starting with 'sao'
SELECT
    customer_city,
    COUNT(*) as customer_count
FROM olist_sales_data_set.olist_customers_dataset
WHERE customer_city LIKE 'sao%'
GROUP BY customer_city
ORDER BY customer_count DESC;

-- Find cities ending with 'nopolis' (city suffix)
SELECT
    customer_city,
    COUNT(*) as customer_count
FROM olist_sales_data_set.olist_customers_dataset
WHERE customer_city LIKE '%nopolis'
GROUP BY customer_city
ORDER BY customer_count DESC;

-- 1.2 Single Character Wildcard (_)
-- Find short city names (exactly 5 characters)
SELECT
    customer_city,
    LENGTH(customer_city) as city_length,
    COUNT(*) as frequency
FROM olist_sales_data_set.olist_customers_dataset
WHERE customer_city LIKE '_____'  -- exactly 5 characters
GROUP BY customer_city, LENGTH(customer_city)
ORDER BY frequency DESC
LIMIT 10;

-- ===================================
-- 2. CASE-SENSITIVE VS CASE-INSENSITIVE MATCHING
-- ===================================

-- 2.1 LIKE (case-sensitive) vs ILIKE (case-insensitive)

-- Case-sensitive search for 'Rio'
SELECT
    customer_city,
    COUNT(*) as count_case_sensitive
FROM olist_sales_data_set.olist_customers_dataset
WHERE customer_city LIKE '%Rio%'
GROUP BY customer_city;

-- Case-insensitive search for 'rio'
SELECT
    customer_city,
    COUNT(*) as count_case_insensitive
FROM olist_sales_data_set.olist_customers_dataset
WHERE customer_city ILIKE '%rio%'
GROUP BY customer_city
ORDER BY count_case_insensitive DESC;

-- Compare the results side by side
SELECT
    'Case Sensitive (Rio)' as search_type,
    COUNT(*) as matches
FROM olist_sales_data_set.olist_customers_dataset
WHERE customer_city LIKE '%Rio%'

UNION ALL

SELECT
    'Case Insensitive (rio)' as search_type,
    COUNT(*) as matches
FROM olist_sales_data_set.olist_customers_dataset
WHERE customer_city ILIKE '%rio%';

-- ===================================
-- 3. COMPLEX PATTERN COMBINATIONS
-- ===================================

-- 3.1 Multiple Pattern Conditions
-- Find product categories that are food-related
SELECT
    product_category_name,
    product_category_name_english,
    CASE
        WHEN product_category_name ILIKE '%alimento%' THEN 'Food (Portuguese)'
        WHEN product_category_name ILIKE '%bebida%' THEN 'Beverage (Portuguese)'
        WHEN product_category_name_english ILIKE '%food%' THEN 'Food (English)'
        WHEN product_category_name_english ILIKE '%drink%' THEN 'Beverage (English)'
        ELSE 'Other Food Category'
    END as food_category_type
FROM olist_sales_data_set.product_category_name_translation
WHERE product_category_name ILIKE '%alimento%'
   OR product_category_name ILIKE '%bebida%'
   OR product_category_name_english ILIKE '%food%'
   OR product_category_name_english ILIKE '%drink%'
ORDER BY food_category_type, product_category_name_english;

-- 3.2 NOT LIKE for Exclusion Patterns
-- Find all categories that are NOT home/house related
SELECT
    product_category_name_english,
    COUNT(*) as non_home_categories
FROM olist_sales_data_set.product_category_name_translation
WHERE product_category_name_english NOT ILIKE '%home%'
  AND product_category_name_english NOT ILIKE '%house%'
  AND product_category_name_english NOT ILIKE '%furniture%'
  AND product_category_name NOT ILIKE '%casa%'
GROUP BY product_category_name_english
ORDER BY product_category_name_english;

-- ===================================
-- 4. BUSINESS PATTERN IDENTIFICATION
-- ===================================

-- 4.1 Marketing Lead Source Analysis
-- Categorize marketing origins by pattern
SELECT
    origin,
    CASE
        WHEN origin ILIKE '%search%' THEN 'Search Marketing'
        WHEN origin ILIKE '%social%' THEN 'Social Media'
        WHEN origin ILIKE '%email%' THEN 'Email Marketing'
        WHEN origin ILIKE '%direct%' THEN 'Direct Traffic'
        WHEN origin ILIKE '%referral%' THEN 'Referral Traffic'
        WHEN origin ILIKE '%display%' THEN 'Display Advertising'
        ELSE 'Other Sources'
    END as marketing_channel_category,
    COUNT(*) as lead_count
FROM olist_marketing_data_set.olist_marketing_qualified_leads_dataset
WHERE origin IS NOT NULL
GROUP BY origin, marketing_channel_category
ORDER BY lead_count DESC;

-- 4.2 Review Sentiment Pattern Detection
-- Identify positive and negative sentiment patterns in reviews
SELECT
    review_score,
    COUNT(*) as total_reviews,
    COUNT(*) FILTER (WHERE review_comment_message ILIKE '%excelente%'
                     OR review_comment_message ILIKE '%ótimo%'
                     OR review_comment_message ILIKE '%perfeito%'
                     OR review_comment_message ILIKE '%recomendo%') as positive_keywords,
    COUNT(*) FILTER (WHERE review_comment_message ILIKE '%ruim%'
                     OR review_comment_message ILIKE '%problema%'
                     OR review_comment_message ILIKE '%defeito%'
                     OR review_comment_message ILIKE '%demora%') as negative_keywords
FROM olist_sales_data_set.olist_order_reviews_dataset
WHERE review_comment_message IS NOT NULL
GROUP BY review_score
ORDER BY review_score;

-- ===================================
-- 5. GEOGRAPHIC PATTERN ANALYSIS
-- ===================================

-- 5.1 Identify City Name Patterns
-- Find cities that follow common Brazilian naming patterns
SELECT
    'Santo/Santa prefix' as pattern_type,
    COUNT(*) as city_count,
    STRING_AGG(DISTINCT customer_city, ', ') as examples
FROM olist_sales_data_set.olist_customers_dataset
WHERE customer_city ILIKE 'santo %' OR customer_city ILIKE 'santa %'

UNION ALL

SELECT
    'Sao prefix' as pattern_type,
    COUNT(*) as city_count,
    STRING_AGG(DISTINCT customer_city, ', ') as examples
FROM olist_sales_data_set.olist_customers_dataset
WHERE customer_city ILIKE 'sao %'

UNION ALL

SELECT
    'Campo/Campos suffix' as pattern_type,
    COUNT(*) as city_count,
    STRING_AGG(DISTINCT customer_city, ', ') as examples
FROM olist_sales_data_set.olist_customers_dataset
WHERE customer_city ILIKE '% campo' OR customer_city ILIKE '% campos'

ORDER BY city_count DESC;

-- 5.2 State Code Standardization
-- Identify and standardize state patterns
SELECT
    customer_state,
    COUNT(*) as frequency,
    CASE
        WHEN customer_state ILIKE 'SP' THEN 'São Paulo'
        WHEN customer_state ILIKE 'RJ' THEN 'Rio de Janeiro'
        WHEN customer_state ILIKE 'MG' THEN 'Minas Gerais'
        WHEN customer_state ILIKE 'PR' THEN 'Paraná'
        WHEN customer_state ILIKE 'RS' THEN 'Rio Grande do Sul'
        WHEN customer_state ILIKE 'SC' THEN 'Santa Catarina'
        ELSE 'Other State'
    END as full_state_name
FROM olist_sales_data_set.olist_customers_dataset
WHERE customer_state IS NOT NULL
GROUP BY customer_state
ORDER BY frequency DESC;

-- ===================================
-- 6. PRODUCT CATEGORIZATION PATTERNS
-- ===================================

-- 6.1 Seasonal Product Identification
-- Find products that might be seasonal based on category names
SELECT
    product_category_name_english,
    CASE
        WHEN product_category_name_english ILIKE '%christmas%'
             OR product_category_name ILIKE '%natal%' THEN 'Christmas/Holiday'
        WHEN product_category_name_english ILIKE '%party%'
             OR product_category_name ILIKE '%festa%' THEN 'Party/Celebration'
        WHEN product_category_name_english ILIKE '%garden%'
             OR product_category_name ILIKE '%jardim%' THEN 'Garden/Outdoor'
        WHEN product_category_name_english ILIKE '%sports%'
             OR product_category_name ILIKE '%esporte%' THEN 'Sports/Recreation'
        ELSE 'Year-round'
    END as seasonality_category
FROM olist_sales_data_set.product_category_name_translation
WHERE product_category_name_english IS NOT NULL
ORDER BY seasonality_category, product_category_name_english;

-- 6.2 Product Size/Type Pattern Analysis
-- Identify product characteristics from category names
SELECT
    product_category_name_english,
    CASE
        WHEN product_category_name_english ILIKE '%baby%'
             OR product_category_name ILIKE '%bebe%' THEN 'Baby/Children'
        WHEN product_category_name_english ILIKE '%small%'
             OR product_category_name_english ILIKE '%mini%' THEN 'Small Items'
        WHEN product_category_name_english ILIKE '%large%'
             OR product_category_name_english ILIKE '%big%' THEN 'Large Items'
        WHEN product_category_name_english ILIKE '%portable%'
             OR product_category_name_english ILIKE '%mobile%' THEN 'Portable Items'
        ELSE 'Standard Size'
    END as size_category,
    COUNT(*) as category_count
FROM olist_sales_data_set.product_category_name_translation
GROUP BY product_category_name_english, size_category
HAVING size_category != 'Standard Size'
ORDER BY size_category, product_category_name_english;

-- ===================================
-- 7. NIGERIAN BUSINESS ADAPTATION
-- ===================================

-- 7.1 Nigerian City Pattern Examples
-- Apply LIKE patterns to Nigerian city names
WITH nigerian_cities AS (
    SELECT unnest(ARRAY[
        'Lagos', 'Abuja', 'Kano', 'Ibadan', 'Port Harcourt',
        'Benin City', 'Kaduna', 'Jos', 'Ilorin', 'Owerri',
        'Enugu', 'Abeokuta', 'Akure', 'Bauchi', 'Sokoto'
    ]) as city_name
)
SELECT
    city_name,
    CASE
        WHEN city_name ILIKE '%abuja%' THEN 'Federal Capital Territory'
        WHEN city_name ILIKE '%lagos%' THEN 'Lagos State'
        WHEN city_name ILIKE '%port%' THEN 'Rivers State'
        WHEN city_name ILIKE '%kano%' THEN 'Kano State'
        ELSE 'Other State'
    END as likely_state,
    LENGTH(city_name) as name_length
FROM nigerian_cities
ORDER BY name_length DESC;

-- ===================================
-- 8. ADVANCED PATTERN COMBINATIONS
-- ===================================

-- 8.1 Multiple Wildcard Patterns
-- Find complex product category patterns
SELECT
    product_category_name,
    product_category_name_english,
    'Health & Beauty' as category_group
FROM olist_sales_data_set.product_category_name_translation
WHERE (product_category_name ILIKE '%saude%' OR product_category_name_english ILIKE '%health%')
   OR (product_category_name ILIKE '%beleza%' OR product_category_name_english ILIKE '%beauty%')
   OR (product_category_name ILIKE '%perfume%' OR product_category_name_english ILIKE '%perfume%')

UNION ALL

SELECT
    product_category_name,
    product_category_name_english,
    'Electronics & Technology' as category_group
FROM olist_sales_data_set.product_category_name_translation
WHERE product_category_name_english ILIKE '%computer%'
   OR product_category_name_english ILIKE '%electronic%'
   OR product_category_name_english ILIKE '%audio%'
   OR product_category_name_english ILIKE '%video%'

ORDER BY category_group, product_category_name_english;

-- ===================================
-- EXERCISES PREVIEW
-- ===================================

-- Exercise 1: Marketing Channel Analysis
-- Use LIKE patterns to categorize all marketing lead origins
-- Create business-friendly channel names

-- Exercise 2: Review Quality Assessment
-- Find reviews with specific quality indicators using patterns
-- Identify reviews that mention delivery, quality, price

-- Exercise 3: Geographic Business Intelligence
-- Create regional groupings of Brazilian cities using patterns
-- Identify business opportunities by region

-- Next Part Preview: Regular Expressions for Advanced Pattern Matching