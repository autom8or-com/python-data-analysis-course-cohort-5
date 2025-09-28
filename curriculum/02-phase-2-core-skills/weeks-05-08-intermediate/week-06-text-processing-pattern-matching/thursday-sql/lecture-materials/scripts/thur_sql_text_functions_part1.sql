-- ================================================
-- Week 6: SQL Text Processing & Pattern Matching
-- Part 1: Basic String Functions & Data Cleaning
-- Thursday, September 18, 2025
-- ================================================

-- Business Context: Cleaning and standardizing e-commerce data
-- Excel Connection: Moving from TEXT, UPPER, LOWER, TRIM functions

-- ===================================
-- 1. BASIC STRING FUNCTIONS
-- ===================================

-- 1.1 Case Standardization Functions
-- Excel equivalent: UPPER(), LOWER(), PROPER()

-- View city names with inconsistent casing
SELECT
    customer_city,
    COUNT(*) as frequency
FROM olist_sales_data_set.olist_customers_dataset
WHERE customer_city IN ('sao paulo', 'SAO PAULO', 'Sao Paulo', 'rio de janeiro', 'RIO DE JANEIRO')
GROUP BY customer_city
ORDER BY customer_city;

-- Standardize city names to proper case
SELECT
    customer_city as original_name,
    UPPER(customer_city) as uppercase_name,
    LOWER(customer_city) as lowercase_name,
    INITCAP(customer_city) as proper_case_name
FROM olist_sales_data_set.olist_customers_dataset
WHERE customer_city = 'sao paulo'
LIMIT 5;

-- 1.2 Text Length Functions
-- Excel equivalent: LEN()

-- Analyze review comment lengths for quality assessment
SELECT
    review_score,
    AVG(LENGTH(review_comment_message)) as avg_comment_length,
    MIN(LENGTH(review_comment_message)) as min_length,
    MAX(LENGTH(review_comment_message)) as max_length,
    COUNT(*) as review_count
FROM olist_sales_data_set.olist_order_reviews_dataset
WHERE review_comment_message IS NOT NULL
GROUP BY review_score
ORDER BY review_score;

-- ===================================
-- 2. WHITESPACE CLEANING FUNCTIONS
-- ===================================

-- 2.1 TRIM Functions
-- Excel equivalent: TRIM()

-- Identify and clean data with extra whitespace
SELECT
    '|' || customer_city || '|' as original_with_markers,
    '|' || TRIM(customer_city) || '|' as trimmed_with_markers,
    LENGTH(customer_city) as original_length,
    LENGTH(TRIM(customer_city)) as trimmed_length
FROM olist_sales_data_set.olist_customers_dataset
WHERE customer_city LIKE ' %' OR customer_city LIKE '% '
LIMIT 10;

-- Left and right trim examples
SELECT
    LTRIM('   left spaces removed') as left_trimmed,
    RTRIM('right spaces removed   ') as right_trimmed,
    TRIM('  both sides cleaned  ') as both_trimmed;

-- ===================================
-- 3. TEXT MODIFICATION FUNCTIONS
-- ===================================

-- 3.1 REPLACE Function
-- Excel equivalent: SUBSTITUTE()

-- Standardize product category names
SELECT
    product_category_name as original_category,
    REPLACE(product_category_name, '_', ' ') as readable_category,
    REPLACE(REPLACE(product_category_name, '_', ' '), 'e', '&') as business_friendly
FROM olist_sales_data_set.product_category_name_translation
WHERE product_category_name LIKE '%_e_%'
LIMIT 10;

-- Clean and standardize review text
SELECT
    review_comment_message as original_comment,
    REPLACE(
        REPLACE(
            REPLACE(review_comment_message, '\r\n', ' '),
            '  ', ' '
        ),
        '.', ''
    ) as cleaned_comment
FROM olist_sales_data_set.olist_order_reviews_dataset
WHERE review_comment_message LIKE '%\r\n%'
LIMIT 5;

-- 3.2 SUBSTRING Function
-- Excel equivalent: MID(), LEFT(), RIGHT()

-- Extract first word from city names for regional analysis
SELECT
    customer_city as full_city_name,
    SUBSTRING(customer_city FROM 1 FOR POSITION(' ' IN customer_city || ' ') - 1) as first_word,
    SUBSTRING(customer_city FROM POSITION(' ' IN customer_city) + 1) as remaining_words
FROM olist_sales_data_set.olist_customers_dataset
WHERE customer_city LIKE '% %'
LIMIT 10;

-- Extract year from review text mentioning years
SELECT
    review_comment_message,
    SUBSTRING(review_comment_message FROM '\d{4}') as extracted_year
FROM olist_sales_data_set.olist_order_reviews_dataset
WHERE review_comment_message ~ '\d{4}'
LIMIT 5;

-- ===================================
-- 4. TEXT CONCATENATION
-- ===================================

-- 4.1 CONCAT Function and || Operator
-- Excel equivalent: CONCATENATE(), &

-- Create standardized customer location format
SELECT
    customer_id,
    CONCAT(INITCAP(customer_city), ', ', UPPER(customer_state)) as formatted_location,
    customer_city || ', ' || customer_state as pipe_concatenation,
    UPPER(customer_city) || ' - ' || customer_zip_code_prefix as shipping_label
FROM olist_sales_data_set.olist_customers_dataset
WHERE customer_city IS NOT NULL AND customer_state IS NOT NULL
LIMIT 10;

-- Create product category hierarchy
SELECT
    product_category_name,
    product_category_name_english,
    CONCAT('Category: ', INITCAP(REPLACE(product_category_name_english, '_', ' '))) as display_name,
    'BR: ' || product_category_name || ' | EN: ' || product_category_name_english as bilingual_label
FROM olist_sales_data_set.product_category_name_translation
ORDER BY product_category_name_english
LIMIT 15;

-- ===================================
-- 5. BUSINESS APPLICATION EXAMPLES
-- ===================================

-- 5.1 Nigerian E-commerce Adaptation
-- Standardize city names for major Nigerian cities
SELECT
    'lagos' as original_input,
    INITCAP('lagos') as standardized_name,
    CONCAT(INITCAP('lagos'), ', Lagos State') as full_location;

SELECT
    'ABUJA' as original_input,
    INITCAP(LOWER('ABUJA')) as standardized_name,
    CONCAT(INITCAP(LOWER('ABUJA')), ', FCT') as full_location;

-- 5.2 Product Category Standardization
-- Create Nigerian-relevant product categories
WITH nigerian_categories AS (
    SELECT
        CASE
            WHEN product_category_name_english LIKE '%food%' THEN 'Food & Beverages'
            WHEN product_category_name_english LIKE '%health%' OR product_category_name_english LIKE '%beauty%' THEN 'Health & Beauty'
            WHEN product_category_name_english LIKE '%home%' OR product_category_name_english LIKE '%furniture%' THEN 'Home & Garden'
            WHEN product_category_name_english LIKE '%fashion%' OR product_category_name_english LIKE '%clothing%' THEN 'Fashion & Apparel'
            WHEN product_category_name_english LIKE '%electronics%' OR product_category_name_english LIKE '%computer%' THEN 'Electronics & Technology'
            ELSE 'Other Categories'
        END as nigerian_category,
        product_category_name_english as original_category,
        COUNT(*) as category_count
    FROM olist_sales_data_set.product_category_name_translation
    GROUP BY nigerian_category, product_category_name_english
)
SELECT
    nigerian_category,
    COUNT(*) as total_subcategories,
    STRING_AGG(original_category, ', ') as subcategories
FROM nigerian_categories
GROUP BY nigerian_category
ORDER BY total_subcategories DESC;

-- ===================================
-- 6. DATA QUALITY ASSESSMENT
-- ===================================

-- Check for common text data quality issues
SELECT
    'Empty strings' as issue_type,
    COUNT(*) as count
FROM olist_sales_data_set.olist_customers_dataset
WHERE customer_city = ''

UNION ALL

SELECT
    'Only whitespace' as issue_type,
    COUNT(*) as count
FROM olist_sales_data_set.olist_customers_dataset
WHERE TRIM(customer_city) = '' AND customer_city IS NOT NULL

UNION ALL

SELECT
    'Leading/trailing spaces' as issue_type,
    COUNT(*) as count
FROM olist_sales_data_set.olist_customers_dataset
WHERE customer_city != TRIM(customer_city)

UNION ALL

SELECT
    'Mixed case inconsistency' as issue_type,
    COUNT(DISTINCT customer_city) - COUNT(DISTINCT LOWER(customer_city)) as count
FROM olist_sales_data_set.olist_customers_dataset
WHERE customer_city IS NOT NULL;

-- ===================================
-- PRACTICE EXERCISES PREVIEW
-- ===================================

-- Exercise 1: Create a standardized customer address format
-- Combine city, state, and zip code into a Nigerian postal format

-- Exercise 2: Clean product category names
-- Remove underscores, standardize casing, create display-friendly names

-- Exercise 3: Review text quality analysis
-- Identify reviews with potential quality issues (too short, excessive caps, etc.)

-- Next Part Preview: Pattern Matching with LIKE and ILIKE