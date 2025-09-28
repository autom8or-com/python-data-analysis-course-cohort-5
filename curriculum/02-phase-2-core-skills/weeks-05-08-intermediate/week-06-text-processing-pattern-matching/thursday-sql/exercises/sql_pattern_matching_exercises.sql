-- =====================================================
-- Week 6 SQL Exercises: Advanced Pattern Matching & Regular Expressions
-- Thursday SQL Class - Pattern Matching
-- Business Context: Customer Data Analysis & Validation
-- =====================================================

/*
BUSINESS SCENARIO:
As a Senior Data Analyst at NaijaMart, you've been tasked with implementing
data validation rules and customer segmentation based on text patterns.
Your analysis will help improve data quality and identify customer behavior
patterns for targeted marketing campaigns.

ADVANCED CONCEPTS COVERED:
✓ Complex LIKE and ILIKE patterns
✓ Regular expressions in PostgreSQL
✓ Text pattern validation
✓ Customer segmentation based on text patterns
✓ Data quality assessment using pattern matching

DATASETS USED:
- olist_sales_data_set.olist_order_reviews_dataset
- olist_sales_data_set.olist_customers_dataset
- olist_marketing_data_set.olist_closed_deals_dataset
- olist_sales_data_set.product_category_name_translation
*/

-- =====================================================
-- SECTION 1: ADVANCED LIKE PATTERNS
-- Master complex pattern matching with wildcards
-- =====================================================

-- Exercise 1.1: Customer ID Pattern Analysis
-- Task: Analyze customer ID formats and identify patterns

/*
INSTRUCTIONS:
Customer IDs might follow different patterns. Analyze and categorize them:

1. IDs starting with numbers (likely auto-generated)
2. IDs with exactly 32 characters (UUID format)
3. IDs containing only lowercase letters and numbers
4. IDs with mixed case (containing both upper and lower case)
5. IDs with special patterns (containing dashes, underscores)

For each pattern type:
- Count the occurrences
- Show 3 sample IDs
- Calculate average length

HINT: Use various LIKE patterns: '[0-9]%', '%[A-Z]%', etc.
Note: PostgreSQL LIKE is case-sensitive, ILIKE is case-insensitive
*/

-- YOUR SQL QUERY HERE:




-- Exercise 1.2: City Name Validation
-- Task: Validate Brazilian city names for data quality

/*
INSTRUCTIONS:
Create validation rules for Brazilian city names:

1. Cities with valid characters only (letters, spaces, hyphens, apostrophes)
2. Cities with numbers (likely data entry errors)
3. Cities with too many consecutive spaces
4. Cities starting or ending with spaces
5. Cities with special characters that shouldn't be there

Create a data quality report showing:
- Total cities analyzed
- Number of clean cities
- Number of cities with each type of issue
- Sample problematic city names

HINT: Use LIKE patterns with character classes where supported,
or use LENGTH comparisons with TRIM results
*/

-- YOUR SQL QUERY HERE:




-- Exercise 1.3: Business Segment Pattern Classification
-- Task: Classify business segments by naming patterns

/*
INSTRUCTIONS:
Classify business segments from the marketing dataset:

1. Single-word segments (no underscores)
2. Two-word segments (one underscore)
3. Multi-word segments (multiple underscores)
4. Segments with numbers
5. Segments following "adjective_noun" pattern vs "noun_adjective"

For each category:
- Count segments
- Show examples
- Identify the most common pattern
- Suggest standardization opportunities

HINT: Count underscores using LENGTH(segment) - LENGTH(REPLACE(segment, '_', ''))
*/

-- YOUR SQL QUERY HERE:




-- =====================================================
-- SECTION 2: REGULAR EXPRESSIONS FUNDAMENTALS
-- Learn PostgreSQL regex patterns
-- =====================================================

-- Exercise 2.1: Email Pattern Validation (Simulated)
-- Task: Validate email patterns from customer IDs

/*
INSTRUCTIONS:
Create simulated email addresses using customer_id + domain patterns.
Then validate them using regex:

1. Basic email format: characters@domain.extension
2. Valid domains: gmail.com, yahoo.com, hotmail.com, company.com.br
3. Valid username patterns:
   - Only letters, numbers, dots, underscores
   - Cannot start or end with dots
   - No consecutive dots

Use PostgreSQL regex operators:
- ~ for case-sensitive matching
- ~* for case-insensitive matching
- !~ and !~* for negation

Show counts of valid vs invalid emails by domain.

HINT: Use patterns like '^[a-zA-Z0-9._]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$'
*/

-- YOUR SQL QUERY HERE:




-- Exercise 2.2: Review Message Content Analysis
-- Task: Extract structured information from review messages

/*
INSTRUCTIONS:
Analyze customer review messages using regex to find:

1. Messages containing phone numbers (Brazilian format: +55 11 9999-9999)
2. Messages with dates mentioned (dd/mm/yyyy or dd-mm-yyyy)
3. Messages with price mentions (R$ 99,99 or $ 99.99)
4. Messages with product codes (pattern: ABC123 or ABC-123)
5. Messages with email addresses

For each pattern:
- Count occurrences
- Extract the matched patterns
- Show sample reviews
- Analyze correlation with review scores

HINT: Use SUBSTRING with regex: SUBSTRING(text FROM pattern)
*/

-- YOUR SQL QUERY HERE:




-- Exercise 2.3: Product Category Code Generation
-- Task: Generate standardized product codes using patterns

/*
INSTRUCTIONS:
Create standardized product category codes based on English names:

1. Extract first 3 letters of each major word
2. Convert to uppercase
3. Handle special cases:
   - "health_beauty" → "HLT_BTY"
   - "computers_accessories" → "CMP_ACC"
   - "sports_leisure" → "SPT_LSR"

Rules:
- Skip common words: "and", "or", "of", "the"
- If word is 2 letters, use full word
- If word is 3+ letters, use first 3
- Separate major categories with underscore

Use regex to identify word boundaries and patterns.

HINT: Use regexp_split_to_table() to split words, then aggregate
*/

-- YOUR SQL QUERY HERE:




-- =====================================================
-- SECTION 3: ADVANCED PATTERN MATCHING SCENARIOS
-- Complex business logic using text patterns
-- =====================================================

-- Exercise 3.1: Customer Sentiment Analysis
-- Task: Classify review sentiment using keyword patterns

/*
INSTRUCTIONS:
Create a sentiment analysis system using pattern matching:

POSITIVE indicators (regex patterns):
- "recommend" variations: (recomend|recommend).*
- Excellent: (excelent|ótimo|perfeito).*
- Quality: (qualidade|quality).*
- Fast: (rápid|fast|quick).*

NEGATIVE indicators:
- Problems: (problem|defeito|ruim).*
- Slow: (lent|demor|atras).*
- Bad: (ruim|péssimo|terrível).*

NEUTRAL indicators:
- "ok", "normal", "regular"

Classification logic:
- 2+ positive patterns = "Very Positive"
- 1 positive pattern = "Positive"
- 1+ negative patterns = "Negative"
- Only neutral = "Neutral"
- No patterns = "Unclassified"

Show sentiment distribution and correlation with numeric scores.

HINT: Use multiple CASE WHEN with regex matches, count pattern occurrences
*/

-- YOUR SQL QUERY HERE:




-- Exercise 3.2: Geographic Pattern Analysis
-- Task: Analyze regional patterns in customer data

/*
INSTRUCTIONS:
Identify geographic patterns and anomalies:

1. State code validation (should be 2 uppercase letters)
2. ZIP code patterns by region:
   - São Paulo: 01000-05999, 08000-19999
   - Rio de Janeiro: 20000-28999
   - Other patterns that might indicate data entry errors

3. City name patterns:
   - Cities ending in common suffixes: -ópolis, -ândia, -inha
   - Cities with "São", "Santa", "Santo" prefixes
   - Indigenous vs Portuguese names (pattern analysis)

4. Anomaly detection:
   - ZIP codes that don't match expected state patterns
   - Cities that might be misspelled (similar to known cities)

Create a geographic data quality report.

HINT: Use regex ranges [0-9]{5} for ZIP patterns, word boundary \b
*/

-- YOUR SQL QUERY HERE:




-- Exercise 3.3: Business Intelligence Pattern Mining
-- Task: Discover hidden patterns in business segment data

/*
INSTRUCTIONS:
Mine patterns from business segments to discover insights:

1. Seasonal business indicators:
   - Keywords suggesting seasonal businesses: "christmas", "beach", "winter"
   - Year-round vs seasonal pattern classification

2. B2B vs B2C indicators:
   - B2B keywords: "industrial", "wholesale", "manufacturing"
   - B2C keywords: "retail", "consumer", "personal"

3. Market maturity indicators:
   - Emerging markets: "new", "startup", "innovation"
   - Established markets: "traditional", "established", "classic"

4. Technology adoption patterns:
   - Digital-native: "online", "digital", "tech", "mobile"
   - Traditional: no tech keywords, traditional segments

Cross-analyze with:
- Declared monthly revenue
- Lead behavior profile
- Business type

Generate strategic insights for business development.

HINT: Create indicator scores using regex matches, use CTEs for complex logic
*/

-- YOUR SQL QUERY HERE:




-- =====================================================
-- SECTION 4: DATA VALIDATION AND CLEANSING
-- Implement production-ready validation rules
-- =====================================================

-- Exercise 4.1: Comprehensive Data Validation Framework
-- Task: Create a complete validation system

/*
INSTRUCTIONS:
Build a validation framework that scores data quality:

CUSTOMER DATA VALIDATION:
1. Customer ID format consistency (score 0-25 points)
2. City name validity (score 0-25 points)
3. State code validity (score 0-25 points)
4. ZIP code format validity (score 0-25 points)

VALIDATION RULES:
- Customer ID: 32 characters, alphanumeric only
- City: Only letters, spaces, hyphens, apostrophes
- State: Exactly 2 uppercase letters
- ZIP: 5 digits, valid ranges for Brazilian states

OUTPUT:
- Customer ID
- Individual scores for each field
- Total quality score (0-100)
- Quality grade (A: 90-100, B: 80-89, C: 70-79, D: 60-69, F: <60)
- Specific issues found

Show distribution of quality grades and most common issues.

HINT: Use CASE WHEN for scoring, string functions for validation
*/

-- YOUR SQL QUERY HERE:




-- Exercise 4.2: Automated Data Cleansing Suggestions
-- Task: Generate automated cleaning recommendations

/*
INSTRUCTIONS:
Create a system that suggests data corrections:

1. CITY NAME CORRECTIONS:
   - Remove extra spaces: "  São Paulo  " → "São Paulo"
   - Fix common typos: "Sao Paulo" → "São Paulo"
   - Standardize case: "SAO PAULO" → "São Paulo"

2. BUSINESS SEGMENT STANDARDIZATION:
   - Suggest merging similar segments
   - Fix underscore inconsistencies
   - Propose category hierarchies

3. REVIEW MESSAGE CLEANING:
   - Remove excessive punctuation
   - Fix encoding issues (if any)
   - Standardize common abbreviations

For each suggestion:
- Show original value
- Suggest corrected value
- Provide confidence score
- Count affected records
- Estimate impact on data quality

HINT: Use string manipulation functions, pattern matching for suggestions
*/

-- YOUR SQL QUERY HERE:




-- Exercise 4.3: Real-time Validation Rules
-- Task: Create validation rules for new data entry

/*
INSTRUCTIONS:
Design validation rules for real-time data entry:

1. CREATE VALIDATION FUNCTIONS (conceptual):
   Write queries that could be used as validation functions for:
   - New customer registration
   - Product category assignment
   - Business segment classification
   - Review submission

2. PERFORMANCE OPTIMIZATION:
   - Design validation rules that are fast enough for real-time use
   - Consider indexing implications
   - Balance thoroughness vs performance

3. USER-FRIENDLY ERROR MESSAGES:
   Generate specific, actionable error messages:
   - "City name contains invalid characters. Only letters, spaces, and hyphens allowed."
   - "Business segment must use underscores to separate words, not spaces."
   - "Review message appears to contain personal information. Please remove phone numbers."

Show examples of validation in action with sample data.

HINT: Use functions like regexp_matches(), validate step by step
*/

-- YOUR SQL QUERY HERE:




-- =====================================================
-- SECTION 5: BUSINESS INTELLIGENCE APPLICATIONS
-- Apply pattern matching to solve business problems
-- =====================================================

-- Exercise 5.1: Customer Segmentation Using Text Patterns
-- Task: Create customer segments based on behavioral text patterns

/*
BUSINESS CONTEXT:
Marketing wants to segment customers based on their review patterns and preferences.

INSTRUCTIONS:
Create customer segments based on text analysis:

1. PREMIUM CUSTOMERS:
   - Reviews mention "quality", "excellent", "recommend"
   - Higher average review scores
   - Longer, detailed review messages

2. PRICE-SENSITIVE CUSTOMERS:
   - Reviews mention "price", "cheap", "expensive", "value"
   - Focus on delivery cost and speed
   - Shorter review messages

3. TECH-SAVVY CUSTOMERS:
   - Reviews of tech products
   - Mention specifications, features, technical terms
   - Early adopters (first to review new products)

4. LOYAL CUSTOMERS:
   - Multiple reviews over time
   - Consistent positive sentiment
   - Mention brand loyalty, repeat purchases

For each segment:
- Count customers
- Average review score
- Most common product categories
- Geographic distribution
- Revenue potential indicators

HINT: Join multiple tables, use text analysis for classification
*/

-- YOUR SQL QUERY HERE:




-- Exercise 5.2: Product Recommendation Engine Data
-- Task: Extract features for recommendation algorithms

/*
BUSINESS CONTEXT:
Data Science team needs structured features from text data for ML models.

INSTRUCTIONS:
Extract recommendation features from text patterns:

1. PRODUCT SIMILARITY FEATURES:
   - Extract adjectives from product categories
   - Identify product attribute mentions in reviews
   - Create product feature vectors from text

2. CUSTOMER PREFERENCE FEATURES:
   - Extract preference signals from review text
   - Identify mention of use cases and contexts
   - Map customer language to product attributes

3. SEASONAL PATTERNS:
   - Detect seasonal language in reviews
   - Identify gift-giving contexts
   - Extract time-sensitive preferences

4. CROSS-CATEGORY FEATURES:
   - Find customers mentioning multiple categories
   - Extract bundle preferences from text
   - Identify complementary product signals

Output structured data suitable for ML feature engineering.

HINT: Use text analysis to create numerical features, consider co-occurrence patterns
*/

-- YOUR SQL QUERY HERE:




-- Exercise 5.3: Competitive Intelligence Text Mining
-- Task: Extract market intelligence from text data

/*
BUSINESS CONTEXT:
Strategy team needs competitive insights from customer feedback patterns.

INSTRUCTIONS:
Mine competitive intelligence from review patterns:

1. BRAND MENTIONS:
   - Identify competitor brands mentioned in reviews
   - Sentiment around competitor comparisons
   - Feature comparisons (better/worse than...)

2. MARKET GAPS:
   - Customer complaints about missing features
   - Requests for products not available
   - Unmet needs expressed in reviews

3. PRICING INSIGHTS:
   - Price sensitivity patterns by category
   - Value perception indicators
   - Price comparison mentions

4. MARKET TRENDS:
   - Emerging product preferences
   - Declining interest patterns
   - New use case discoveries

Generate strategic insights report with:
- Key findings
- Opportunity areas
- Threat assessments
- Market positioning recommendations

HINT: Use advanced pattern matching, sentiment analysis, trend detection
*/

-- YOUR SQL QUERY HERE:




-- =====================================================
-- ADVANCED BONUS CHALLENGES
-- =====================================================

-- Bonus 1: Multi-language Pattern Detection
-- Detect patterns across Portuguese and English text in the same analysis

-- YOUR SQL QUERY HERE:




-- Bonus 2: Fuzzy Matching Implementation
-- Create a similarity score between text strings using SQL (Levenshtein-like logic)

-- YOUR SQL QUERY HERE:




-- Bonus 3: Text-based Anomaly Detection
-- Identify unusual patterns that might indicate data quality issues or fraud

-- YOUR SQL QUERY HERE:




-- =====================================================
-- SUBMISSION CHECKLIST
-- =====================================================
/*
ADVANCED CRITERIA FOR PATTERN MATCHING:
✓ Proper use of regex patterns and syntax
✓ Efficient pattern matching (avoid performance issues)
✓ Business logic correctly implemented
✓ Edge cases handled appropriately
✓ Complex joins and aggregations work correctly
✓ Results provide actionable business insights

GRADING RUBRIC:
- Technical correctness (35%)
- Pattern matching proficiency (25%)
- Business problem solving (25%)
- Code optimization and best practices (15%)

SUBMISSION REQUIREMENTS:
- All queries must execute without errors
- Include sample outputs as comments
- Explain complex regex patterns used
- Document business assumptions made
- Provide performance considerations for production use

Save as: your_name_sql_pattern_matching_exercises.sql
*/