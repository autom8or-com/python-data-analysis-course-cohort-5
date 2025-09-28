-- =====================================================
-- Week 6 SQL Exercises: Text Processing & Pattern Matching
-- Thursday SQL Class - Text Functions
-- Business Context: Product Categorization & Data Cleaning
-- =====================================================

/*
BUSINESS SCENARIO:
You work as a Data Analyst for "NaijaMart", an emerging Nigerian e-commerce platform
inspired by successful models like Olist in Brazil. Your task is to clean and
standardize product data, customer information, and business segments to improve
data quality for analytics and reporting.

DATASETS USED:
- olist_sales_data_set.product_category_name_translation
- olist_sales_data_set.olist_order_reviews_dataset
- olist_marketing_data_set.olist_closed_deals_dataset
- olist_sales_data_set.olist_customers_dataset
- olist_sales_data_set.olist_sellers_dataset

LEARNING OBJECTIVES:
✓ Master SQL string manipulation functions (UPPER, LOWER, TRIM, LENGTH)
✓ Use LIKE and ILIKE for pattern matching
✓ Apply SUBSTRING and POSITION functions for text extraction
✓ Handle NULL values and empty strings in text data
✓ Concatenate strings for data standardization
*/

-- =====================================================
-- SECTION 1: BASIC STRING FUNCTIONS
-- Practice fundamental text manipulation functions
-- =====================================================

-- Exercise 1.1: City Name Standardization
-- Nigerian cities often have inconsistent capitalization in databases
-- Task: Standardize customer city names to proper case (title case)

/*
INSTRUCTIONS:
Write a query to display customer cities in the following formats:
- Original city name
- UPPERCASE version
- lowercase version
- Proper Case (First Letter Capitalized)
- Length of city name

Show results for the first 15 unique cities, ordered alphabetically.

HINT: Use UPPER(), LOWER(), INITCAP(), LENGTH() functions
Expected Nigerian cities might include: "sao paulo", "RIO DE JANEIRO", etc.
*/

-- YOUR SQL QUERY HERE:




-- Exercise 1.2: Product Category Cleanup
-- Task: Clean Portuguese product category names by removing extra spaces

/*
INSTRUCTIONS:
From the product_category_name_translation table:
1. Display original category names with any leading/trailing spaces
2. Show cleaned category names (trimmed)
3. Calculate the difference in length before and after trimming
4. Only show categories where trimming makes a difference

HINT: Use TRIM(), LENGTH() functions and compare lengths
*/

-- YOUR SQL QUERY HERE:




-- Exercise 1.3: Business Segment Analysis
-- Task: Analyze business segment naming patterns

/*
INSTRUCTIONS:
From the closed deals dataset:
1. Count how many unique business segments exist
2. Show each segment in UPPERCASE
3. Display the average length of segment names
4. Group results by the first character of the segment name

HINT: Use COUNT(DISTINCT), UPPER(), AVG(LENGTH()), LEFT() or SUBSTRING()
*/

-- YOUR SQL QUERY HERE:




-- =====================================================
-- SECTION 2: PATTERN MATCHING WITH LIKE/ILIKE
-- Learn to find patterns in text data
-- =====================================================

-- Exercise 2.1: Finding Health & Beauty Products
-- Task: Find all product categories related to health and beauty

/*
INSTRUCTIONS:
Find all product categories (both Portuguese and English) that contain:
- "beleza" (beauty in Portuguese)
- "saude" (health in Portuguese)
- "health" or "beauty" in English names

Use case-insensitive matching and show both original and English names.

HINT: Use ILIKE with % wildcards, combine conditions with OR
*/

-- YOUR SQL QUERY HERE:




-- Exercise 2.2: Email Domain Analysis (Simulated)
-- Task: Analyze customer email patterns (we'll simulate email domains from customer IDs)

/*
INSTRUCTIONS:
Create simulated email addresses using customer_id + '@domain.com'
Then find customers whose simulated emails:
1. End with 'gmail.com'
2. End with 'yahoo.com'
3. Contain numbers in the username part
4. Have usernames longer than 20 characters

Show customer_id, simulated email, city, and state.

HINT: Use CONCAT(), RIGHT(), LIKE patterns with %, numbers are 0-9
*/

-- YOUR SQL QUERY HERE:




-- Exercise 2.3: Review Content Filtering
-- Task: Find reviews containing specific keywords

/*
INSTRUCTIONS:
From customer reviews, find reviews that mention:
1. "recomendo" (recommend in Portuguese)
2. "produto" (product in Portuguese)
3. "entrega" (delivery in Portuguese)
4. Reviews that contain exclamation marks

For each category, show:
- Review score
- Review title (if available)
- First 50 characters of the message
- Review creation date

HINT: Use ILIKE for case-insensitive search, LEFT() for substring
*/

-- YOUR SQL QUERY HERE:




-- =====================================================
-- SECTION 3: SUBSTRING AND POSITION FUNCTIONS
-- Extract specific parts of text data
-- =====================================================

-- Exercise 3.1: State Code Extraction
-- Task: Extract state codes from address information

/*
INSTRUCTIONS:
From the customer dataset:
1. Extract the first 2 characters of customer_state (state codes)
2. Count customers by state code
3. Show the full state name and abbreviated code
4. Order by customer count (highest first)

Create a mapping for common Brazilian states:
SP = São Paulo, RJ = Rio de Janeiro, MG = Minas Gerais, etc.

HINT: Use LEFT() or SUBSTRING(), COUNT(), ORDER BY
*/

-- YOUR SQL QUERY HERE:




-- Exercise 3.2: Product Category Prefix Analysis
-- Task: Analyze product category naming patterns

/*
INSTRUCTIONS:
From product categories:
1. Extract the first word from each Portuguese category name (before underscore)
2. Extract the last word from each English category name (after last underscore)
3. Count how many categories start with each prefix
4. Show the most common prefixes

HINT: Use SUBSTRING(), POSITION(), SPLIT_PART() if available
*/

-- YOUR SQL QUERY HERE:




-- Exercise 3.3: Review Message Length Analysis
-- Task: Categorize reviews by message length

/*
INSTRUCTIONS:
Categorize customer reviews into:
- "Short" (1-50 characters)
- "Medium" (51-200 characters)
- "Long" (201+ characters)
- "Empty" (NULL or empty)

Show:
1. Category counts
2. Average review score for each category
3. Sample message (first 30 characters) for each category

HINT: Use CASE WHEN with LENGTH(), AVG(), LEFT()
*/

-- YOUR SQL QUERY HERE:




-- =====================================================
-- SECTION 4: STRING CONCATENATION AND FORMATTING
-- Combine text data for standardized output
-- =====================================================

-- Exercise 4.1: Full Address Formatting
-- Task: Create standardized address strings

/*
INSTRUCTIONS:
Create formatted address strings for customers:
Format: "City, State ZIP"
Example: "São Paulo, SP 01310"

Handle cases where:
- City names need proper capitalization
- State codes should be uppercase
- ZIP codes should be zero-padded to 5 digits

Show customer_id and formatted address for first 20 customers.

HINT: Use CONCAT(), INITCAP(), UPPER(), LPAD() for zero-padding
*/

-- YOUR SQL QUERY HERE:




-- Exercise 4.2: Business Profile Summary
-- Task: Create business profile descriptions

/*
INSTRUCTIONS:
From the closed deals dataset, create formatted business descriptions:
Format: "[SEGMENT] business operating as [TYPE] through [LEAD_TYPE] channels"
Example: "HEALTH_BEAUTY business operating as MANUFACTURER through ONLINE_MEDIUM channels"

Requirements:
- All text in uppercase
- Replace underscores with spaces
- Handle NULL values appropriately

HINT: Use CONCAT(), UPPER(), REPLACE(), COALESCE()
*/

-- YOUR SQL QUERY HERE:




-- Exercise 4.3: Review Summary Creation
-- Task: Create standardized review summaries

/*
INSTRUCTIONS:
Create review summaries in this format:
"[SCORE]/5 stars - [TITLE]: [FIRST_50_CHARS]..."

Handle cases where:
- Title is NULL (use "No Title")
- Message is NULL (use "No Comment")
- Ensure consistent formatting

Show for reviews with scores 4 and 5 only.

HINT: Use CONCAT(), COALESCE(), LEFT(), CASE WHEN
*/

-- YOUR SQL QUERY HERE:




-- =====================================================
-- SECTION 5: REAL-WORLD BUSINESS SCENARIOS
-- Apply text processing to solve business problems
-- =====================================================

-- Exercise 5.1: Product Category Standardization Project
-- Task: Create a mapping table for category standardization

/*
BUSINESS CONTEXT:
NaijaMart wants to standardize product categories for better analytics.
Some categories have inconsistent naming, spaces, and formatting.

INSTRUCTIONS:
1. Create a comprehensive list of all product categories
2. Identify categories that might be duplicates (similar names)
3. Suggest standardized names using these rules:
   - All lowercase
   - Replace spaces with underscores
   - Remove special characters
   - Combine similar categories

Show original name, standardized name, and frequency count.

HINT: Use string functions to clean data, LIKE for finding similar names
*/

-- YOUR SQL QUERY HERE:




-- Exercise 5.2: Customer Communication Personalization
-- Task: Generate personalized greeting messages

/*
BUSINESS CONTEXT:
Create personalized email greetings for customers based on their location.

INSTRUCTIONS:
Generate greetings in this format:
- For São Paulo customers: "Olá [Customer_ID], bem-vindo de São Paulo!"
- For Rio customers: "Oi [Customer_ID], saudações do Rio de Janeiro!"
- For other cities: "Olá [Customer_ID], obrigado por escolher NaijaMart!"

Include:
- Customer count by greeting type
- Total character count for each greeting template

HINT: Use CASE WHEN, CONCAT(), COUNT(), SUM(LENGTH())
*/

-- YOUR SQL QUERY HERE:




-- Exercise 5.3: Marketing Segment Analysis
-- Task: Analyze business segment patterns for marketing

/*
BUSINESS CONTEXT:
Marketing team needs insights about business segments to create targeted campaigns.

INSTRUCTIONS:
Create a report showing:
1. Business segments containing "home" or "house" keywords
2. Segments containing "beauty" or "health" keywords
3. Technology-related segments (containing "tech", "computer", "phone")
4. For each group, show:
   - Count of businesses
   - Most common business type
   - Most common lead type
   - Average declared monthly revenue

HINT: Use ILIKE with OR conditions, GROUP BY, MAX(), AVG()
*/

-- YOUR SQL QUERY HERE:




-- =====================================================
-- BONUS CHALLENGES
-- Advanced text processing scenarios
-- =====================================================

-- Bonus 1: Data Quality Score
-- Create a data quality score for each product category based on:
-- - Presence of both Portuguese and English names
-- - Length consistency between names
-- - Absence of special characters
-- Score from 1-10 where 10 is highest quality

-- YOUR SQL QUERY HERE:




-- Bonus 2: Multi-language Search Function
-- Create a query that can search product categories in both Portuguese and English
-- Allow partial matches and return relevance scores based on match quality

-- YOUR SQL QUERY HERE:




-- =====================================================
-- SUBMISSION CHECKLIST
-- =====================================================
/*
Before submitting, ensure your queries:
✓ Handle NULL values appropriately
✓ Use appropriate SQL functions for each task
✓ Include comments explaining complex logic
✓ Follow consistent formatting and indentation
✓ Produce realistic results for business scenarios
✓ Include proper error handling where needed

GRADING CRITERIA:
- Correctness of SQL syntax and logic (40%)
- Proper use of text functions (30%)
- Business context understanding (20%)
- Code quality and documentation (10%)

SUBMISSION FORMAT:
- Save as: your_name_sql_text_exercises.sql
- Include all queries with sample outputs as comments
- Add your name and date at the top of the file
*/