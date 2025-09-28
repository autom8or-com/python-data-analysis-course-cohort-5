-- ================================================
-- Week 6: SQL Text Processing & Pattern Matching
-- Part 3: Regular Expressions for Advanced Patterns
-- Thursday, September 18, 2025
-- ================================================

-- Business Context: Advanced pattern extraction and text analysis
-- Excel Connection: Going beyond Excel capabilities with powerful pattern matching

-- ===================================
-- 1. INTRODUCTION TO REGULAR EXPRESSIONS
-- ===================================

-- 1.1 Basic Regex Operators in PostgreSQL
-- ~ = matches regex pattern (case-sensitive)
-- ~* = matches regex pattern (case-insensitive)
-- !~ = does not match regex pattern (case-sensitive)
-- !~* = does not match regex pattern (case-insensitive)

-- Find review comments containing exactly 4 digits (years, quantities, etc.)
SELECT
    review_comment_message,
    review_score
FROM olist_sales_data_set.olist_order_reviews_dataset
WHERE review_comment_message ~ '\d{4}'
LIMIT 10;

-- Find review comments with email patterns
SELECT
    review_comment_message,
    review_score
FROM olist_sales_data_set.olist_order_reviews_dataset
WHERE review_comment_message ~* '[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}'
LIMIT 5;

-- ===================================
-- 2. CHARACTER CLASSES AND QUANTIFIERS
-- ===================================

-- 2.1 Common Character Classes
-- \d = digits [0-9]
-- \w = word characters [a-zA-Z0-9_]
-- \s = whitespace characters
-- . = any character
-- [abc] = any of a, b, c
-- [a-z] = any lowercase letter

-- Find cities with numbers in the name
SELECT
    customer_city,
    COUNT(*) as frequency
FROM olist_sales_data_set.olist_customers_dataset
WHERE customer_city ~ '\d'
GROUP BY customer_city
ORDER BY frequency DESC
LIMIT 10;

-- Find product categories with specific letter patterns
SELECT
    product_category_name,
    product_category_name_english
FROM olist_sales_data_set.product_category_name_translation
WHERE product_category_name ~ '^[a-c]'  -- starts with a, b, or c
ORDER BY product_category_name;

-- 2.2 Quantifiers
-- + = one or more
-- * = zero or more
-- ? = zero or one
-- {n} = exactly n
-- {n,m} = between n and m

-- Find review comments with repeated letters (excitement, emphasis)
SELECT
    review_comment_message,
    review_score
FROM olist_sales_data_set.olist_order_reviews_dataset
WHERE review_comment_message ~* '[a-z]\1{2,}'  -- letter repeated 3+ times
LIMIT 10;

-- ===================================
-- 3. ANCHORS AND BOUNDARIES
-- ===================================

-- 3.1 Position Anchors
-- ^ = start of string
-- $ = end of string
-- \b = word boundary

-- Find cities that start with exactly 'sao' (not 'sao paulo', etc.)
SELECT
    customer_city,
    COUNT(*) as frequency
FROM olist_sales_data_set.olist_customers_dataset
WHERE customer_city ~* '^sao\s'  -- starts with 'sao' followed by space
GROUP BY customer_city
ORDER BY frequency DESC;

-- Find review comments that end with exclamation marks
SELECT
    review_comment_message,
    review_score,
    LENGTH(review_comment_message) as comment_length
FROM olist_sales_data_set.olist_order_reviews_dataset
WHERE review_comment_message ~ '!+$'  -- ends with one or more !
ORDER BY review_score DESC
LIMIT 10;

-- ===================================
-- 4. REGEX FUNCTIONS FOR EXTRACTION
-- ===================================

-- 4.1 REGEXP_MATCHES() - Extract matching patterns
-- Extract all numbers from review comments
SELECT
    review_comment_message,
    REGEXP_MATCHES(review_comment_message, '\d+', 'g') as extracted_numbers
FROM olist_sales_data_set.olist_order_reviews_dataset
WHERE review_comment_message ~ '\d+'
LIMIT 10;

-- Extract email domains from review comments
SELECT
    review_comment_message,
    REGEXP_MATCHES(review_comment_message, '@([a-zA-Z0-9.-]+\.[a-zA-Z]{2,})', 'gi') as email_domain
FROM olist_sales_data_set.olist_order_reviews_dataset
WHERE review_comment_message ~* '@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}'
LIMIT 5;

-- 4.2 REGEXP_REPLACE() - Pattern-based substitution
-- Standardize phone number patterns in review comments
SELECT
    review_comment_message as original,
    REGEXP_REPLACE(
        review_comment_message,
        '\(\d{2}\)\s*\d{4,5}-?\d{4}',
        '[PHONE NUMBER REMOVED]',
        'g'
    ) as sanitized
FROM olist_sales_data_set.olist_order_reviews_dataset
WHERE review_comment_message ~ '\(\d{2}\)\s*\d{4,5}-?\d{4}'
LIMIT 5;

-- Clean product category names using regex
SELECT
    product_category_name as original,
    REGEXP_REPLACE(
        REGEXP_REPLACE(product_category_name, '_', ' ', 'g'),
        '\s+', ' ', 'g'
    ) as cleaned_name
FROM olist_sales_data_set.product_category_name_translation
LIMIT 10;

-- ===================================
-- 5. BUSINESS INTELLIGENCE WITH REGEX
-- ===================================

-- 5.1 Review Sentiment Analysis with Patterns
-- Extract sentiment indicators using regex patterns
WITH sentiment_patterns AS (
    SELECT
        review_id,
        review_comment_message,
        review_score,
        CASE
            WHEN review_comment_message ~* '\b(excelente|ótimo|perfeito|maravilhoso)\b' THEN 'very_positive'
            WHEN review_comment_message ~* '\b(bom|boa|gostei|recomendo)\b' THEN 'positive'
            WHEN review_comment_message ~* '\b(ruim|péssimo|horrível|terrível)\b' THEN 'very_negative'
            WHEN review_comment_message ~* '\b(problema|defeito|demora|atraso)\b' THEN 'negative'
            ELSE 'neutral'
        END as text_sentiment
    FROM olist_sales_data_set.olist_order_reviews_dataset
    WHERE review_comment_message IS NOT NULL
)
SELECT
    review_score,
    text_sentiment,
    COUNT(*) as review_count,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (PARTITION BY review_score), 2) as percentage
FROM sentiment_patterns
GROUP BY review_score, text_sentiment
ORDER BY review_score, review_count DESC;

-- 5.2 Product Feature Extraction
-- Extract product features mentioned in categories
SELECT
    product_category_name_english,
    CASE
        WHEN product_category_name_english ~ '\b(mini|small|compact)\b' THEN 'Compact Size'
        WHEN product_category_name_english ~ '\b(large|big|giant)\b' THEN 'Large Size'
        WHEN product_category_name_english ~ '\b(portable|mobile)\b' THEN 'Portable'
        WHEN product_category_name_english ~ '\b(electric|electronic)\b' THEN 'Electronic'
        WHEN product_category_name_english ~ '\b(manual|hand)\b' THEN 'Manual'
        ELSE 'Standard'
    END as product_feature,
    COUNT(*) as category_count
FROM olist_sales_data_set.product_category_name_translation
GROUP BY product_category_name_english, product_feature
HAVING product_feature != 'Standard'
ORDER BY product_feature, category_count DESC;

-- ===================================
-- 6. DATA VALIDATION WITH REGEX
-- ===================================

-- 6.1 Validate Data Patterns
-- Check for valid Brazilian postal code patterns in city data
WITH postal_code_analysis AS (
    SELECT
        customer_zip_code_prefix,
        CASE
            WHEN customer_zip_code_prefix::text ~ '^\d{5}$' THEN 'Valid Format'
            WHEN customer_zip_code_prefix::text ~ '^\d{1,4}$' THEN 'Too Short'
            WHEN customer_zip_code_prefix::text ~ '^\d{6,}$' THEN 'Too Long'
            ELSE 'Invalid Format'
        END as zip_validation
    FROM olist_sales_data_set.olist_customers_dataset
    WHERE customer_zip_code_prefix IS NOT NULL
)
SELECT
    zip_validation,
    COUNT(*) as count,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2) as percentage
FROM postal_code_analysis
GROUP BY zip_validation
ORDER BY count DESC;

-- ===================================
-- 7. ADVANCED PATTERN COMBINATIONS
-- ===================================

-- 7.1 Complex Business Rules
-- Identify premium customers based on review patterns
WITH customer_review_analysis AS (
    SELECT
        c.customer_city,
        c.customer_state,
        COUNT(r.review_id) as review_count,
        AVG(r.review_score) as avg_score,
        COUNT(*) FILTER (
            WHERE r.review_comment_message ~* '\b(excelente|ótimo|perfeito|recomendo)\b'
        ) as positive_reviews,
        COUNT(*) FILTER (
            WHERE LENGTH(r.review_comment_message) > 100
        ) as detailed_reviews
    FROM olist_sales_data_set.olist_customers_dataset c
    JOIN olist_sales_data_set.olist_orders_dataset o ON c.customer_id = o.customer_id
    JOIN olist_sales_data_set.olist_order_reviews_dataset r ON o.order_id = r.order_id
    WHERE r.review_comment_message IS NOT NULL
    GROUP BY c.customer_city, c.customer_state
    HAVING COUNT(r.review_id) >= 5
)
SELECT
    customer_city,
    customer_state,
    review_count,
    ROUND(avg_score, 2) as avg_score,
    positive_reviews,
    detailed_reviews,
    CASE
        WHEN avg_score >= 4.5 AND positive_reviews >= 3 THEN 'Premium Engaged'
        WHEN avg_score >= 4.0 AND detailed_reviews >= 2 THEN 'Quality Focused'
        WHEN positive_reviews >= 2 THEN 'Positive Contributor'
        ELSE 'Standard Customer'
    END as customer_segment
FROM customer_review_analysis
ORDER BY avg_score DESC, positive_reviews DESC
LIMIT 20;

-- ===================================
-- 8. NIGERIAN BUSINESS APPLICATIONS
-- ===================================

-- 8.1 Nigerian Phone Number Validation
-- Simulate Nigerian phone number patterns
WITH nigerian_phone_examples AS (
    SELECT unnest(ARRAY[
        '+234 803 123 4567',
        '0803 123 4567',
        '08031234567',
        '234-803-123-4567',
        '803.123.4567'
    ]) as phone_number
)
SELECT
    phone_number,
    CASE
        WHEN phone_number ~ '^\+234\s?\d{3}\s?\d{3}\s?\d{4}$' THEN 'International Format'
        WHEN phone_number ~ '^0\d{3}\s?\d{3}\s?\d{4}$' THEN 'National Format'
        WHEN phone_number ~ '^\d{11}$' THEN 'Basic Format'
        ELSE 'Non-standard Format'
    END as format_type,
    REGEXP_REPLACE(phone_number, '[^\d]', '', 'g') as cleaned_number
FROM nigerian_phone_examples;

-- 8.2 Nigerian Business Name Patterns
-- Identify business entity types from names
WITH nigerian_business_names AS (
    SELECT unnest(ARRAY[
        'Dangote Group Limited',
        'First Bank of Nigeria Plc',
        'Shoprite Nigeria Ltd',
        'MTN Nigeria Communications Limited',
        'Guaranty Trust Bank plc',
        'Zenith Bank Plc'
    ]) as business_name
)
SELECT
    business_name,
    CASE
        WHEN business_name ~* '\b(limited|ltd)\b' THEN 'Private Limited Company'
        WHEN business_name ~* '\bplc\b' THEN 'Public Limited Company'
        WHEN business_name ~* '\b(group|holdings)\b' THEN 'Corporate Group'
        WHEN business_name ~* '\b(bank|financial)\b' THEN 'Financial Institution'
        ELSE 'Other Entity Type'
    END as entity_type
FROM nigerian_business_names;

-- ===================================
-- 9. PERFORMANCE CONSIDERATIONS
-- ===================================

-- 9.1 Regex Performance Tips
-- Use indexes for better performance with regex queries
EXPLAIN (ANALYZE, BUFFERS)
SELECT customer_city, COUNT(*)
FROM olist_sales_data_set.olist_customers_dataset
WHERE customer_city ~ '^sao'
GROUP BY customer_city;

-- 9.2 Alternative Approaches for Simple Patterns
-- Sometimes LIKE is faster than regex for simple patterns
-- Compare performance of LIKE vs regex
EXPLAIN (ANALYZE, BUFFERS)
SELECT COUNT(*)
FROM olist_sales_data_set.olist_customers_dataset
WHERE customer_city LIKE 'sao%';

EXPLAIN (ANALYZE, BUFFERS)
SELECT COUNT(*)
FROM olist_sales_data_set.olist_customers_dataset
WHERE customer_city ~ '^sao';

-- ===================================
-- FINAL BUSINESS APPLICATION
-- ===================================

-- Complete Product Categorization System
-- Combine all text processing techniques
CREATE OR REPLACE VIEW product_intelligence AS
WITH categorized_products AS (
    SELECT
        p.product_id,
        p.product_category_name,
        pt.product_category_name_english,
        -- Basic cleaning
        TRIM(LOWER(pt.product_category_name_english)) as clean_category,
        -- Pattern-based main category
        CASE
            WHEN pt.product_category_name_english ~* '\b(food|drink|beverage)\b' THEN 'Food & Beverages'
            WHEN pt.product_category_name_english ~* '\b(health|beauty|cosmetics)\b' THEN 'Health & Beauty'
            WHEN pt.product_category_name_english ~* '\b(home|house|furniture|garden)\b' THEN 'Home & Garden'
            WHEN pt.product_category_name_english ~* '\b(clothing|fashion|shoes)\b' THEN 'Fashion & Apparel'
            WHEN pt.product_category_name_english ~* '\b(sports|recreation|toys)\b' THEN 'Sports & Recreation'
            WHEN pt.product_category_name_english ~* '\b(electronic|computer|audio|video)\b' THEN 'Electronics'
            WHEN pt.product_category_name_english ~* '\b(auto|car|vehicle)\b' THEN 'Automotive'
            ELSE 'Other Categories'
        END as main_category,
        -- Size classification
        CASE
            WHEN pt.product_category_name_english ~* '\b(baby|mini|small)\b' THEN 'Small/Specialty'
            WHEN pt.product_category_name_english ~* '\b(large|big|giant)\b' THEN 'Large Items'
            ELSE 'Standard Size'
        END as size_category,
        -- Seasonal classification
        CASE
            WHEN pt.product_category_name_english ~* '\b(christmas|holiday|party)\b' THEN 'Seasonal'
            ELSE 'Year-round'
        END as seasonality
    FROM olist_sales_data_set.olist_products_dataset p
    LEFT JOIN olist_sales_data_set.product_category_name_translation pt
        ON p.product_category_name = pt.product_category_name
)
SELECT
    main_category,
    size_category,
    seasonality,
    COUNT(*) as product_count,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2) as percentage
FROM categorized_products
GROUP BY main_category, size_category, seasonality
ORDER BY product_count DESC;

-- Query the view to see the results
SELECT * FROM product_intelligence
WHERE product_count > 100
ORDER BY percentage DESC;

-- ===================================
-- HOMEWORK PREPARATION
-- ===================================

-- Students will practice:
-- 1. Cleaning messy text data using string functions
-- 2. Finding patterns in customer and product data
-- 3. Creating business intelligence with regex
-- 4. Validating data quality with pattern matching
-- 5. Building automated categorization rules

-- Next Class: Same concepts in Python with pandas and regex module