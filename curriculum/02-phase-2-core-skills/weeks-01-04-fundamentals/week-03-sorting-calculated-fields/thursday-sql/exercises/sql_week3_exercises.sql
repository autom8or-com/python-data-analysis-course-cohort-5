-- Week 3: SQL Sorting & Calculated Fields - Practice Exercises
-- Nigerian E-commerce Business Scenarios

-- =====================================================
-- INSTRUCTIONS FOR STUDENTS
-- =====================================================

/*
You are working as a data analyst for "Olist Nigeria," a major e-commerce marketplace.
Complete the following exercises to help the business make data-driven decisions.

SUBMISSION REQUIREMENTS:
1. Write SQL queries to answer each business question
2. Include comments explaining your business logic
3. Use proper formatting and aliasing
4. Handle NULL values appropriately
5. Test your queries and verify results make business sense

DATABASE SCHEMA REMINDER:
- olist_sales_data_set.olist_order_items_dataset (order_id, product_id, seller_id, price, freight_value)
- olist_sales_data_set.olist_products_dataset (product_id, product_category_name, product_weight_g, dimensions)
- olist_sales_data_set.product_category_name_translation (product_category_name, product_category_name_english)
*/

-- =====================================================
-- EXERCISE 1: BASIC CALCULATED FIELDS (15 points)
-- =====================================================

/*
BUSINESS SCENARIO: The marketing team needs to understand total order values and shipping costs.

TASK: Create a query that shows:
- Order ID
- Product price in Brazilian Real (BRL)  
- Freight cost in BRL
- Total order value (price + freight)
- Estimated price in Nigerian Naira (use 1 BRL = 500 NGN)
- Freight as percentage of product price
- A business category: "High Value" if total > 200 BRL, "Standard" otherwise

REQUIREMENTS:
- Include only orders with positive prices
- Round percentages to 2 decimal places  
- Sort by total order value (highest first)
- Limit to 25 results

Write your query below:
*/

-- YOUR QUERY HERE:




-- =====================================================
-- EXERCISE 2: MULTI-COLUMN SORTING (15 points) 
-- =====================================================

/*
BUSINESS SCENARIO: The operations team needs to prioritize order fulfillment.

TASK: Create a query that ranks orders for processing priority:
- Show order_id, product_category (English), price, freight_value, total_value
- Create a priority system:
  * Priority 1: Electronics/Computers over 300 BRL
  * Priority 2: Health/Beauty over 150 BRL  
  * Priority 3: All other orders over 100 BRL
  * Priority 4: Everything else
- Sort by priority level, then by total value (highest first), then by freight efficiency (lowest freight % first)

REQUIREMENTS:
- Only include delivered orders (join with orders table if needed)
- Show top 40 results
- Include freight percentage calculation

Write your query below:
*/

-- YOUR QUERY HERE:




-- =====================================================
-- EXERCISE 3: COMPLEX CASE STATEMENTS (20 points)
-- =====================================================

/*
BUSINESS SCENARIO: Management wants a comprehensive product categorization system.

TASK: Create a sophisticated product analysis with multiple CASE statements:

1. **Price Tier Classification:**
   - Budget: < 50 BRL  
   - Economy: 50-150 BRL
   - Premium: 150-500 BRL
   - Luxury: > 500 BRL

2. **Shipping Efficiency Score:**
   - Excellent: Freight < 10% of price
   - Good: Freight 10-20% of price  
   - Average: Freight 20-30% of price
   - Poor: Freight > 30% of price

3. **Weight Category:**
   - Light: < 500g
   - Medium: 500-2000g  
   - Heavy: 2000-5000g
   - Bulk: > 5000g
   - Unknown: NULL weight

4. **Business Recommendation:**
   - "Promote Heavily": Premium/Luxury with Excellent/Good shipping
   - "Standard Marketing": Economy with Good shipping
   - "Review Logistics": Any product with Poor shipping
   - "Bundle Opportunity": Budget items with Average/Good shipping
   - "Standard Treatment": All others

REQUIREMENTS:
- Include product category, price, weight, freight details
- Sort by Business Recommendation, then Price Tier, then Shipping Efficiency
- Limit to 50 results

Write your query below:
*/

-- YOUR QUERY HERE:




-- =====================================================
-- EXERCISE 4: DATA TYPE CONVERSIONS & NULL HANDLING (20 points)
-- =====================================================

/*
BUSINESS SCENARIO: The finance team needs accurate calculations for investor reports.

TASK: Create a financial analysis query with proper type casting and NULL handling:

1. Convert all prices to DECIMAL(10,2) for precision
2. Handle NULL weights gracefully using COALESCE
3. Calculate price per gram (handle division by zero)
4. Create formatted display strings for reporting
5. Generate data quality flags

REQUIRED FIELDS:
- Order ID (formatted as uppercase first 8 characters + "...")
- Product category  
- Price in BRL (precise decimal)
- Price in NGN (formatted as "₦X,XXX.XX")
- Weight in grams (show "Not specified" if NULL)
- Price per gram (show "N/A" if can't calculate)
- Volume in cubic cm (product of dimensions)
- Data completeness score (0-4 based on available fields)
- Quality flag: "Complete", "Missing Weight", "Missing Dimensions", "Incomplete Data"

REQUIREMENTS:
- Use proper type casting for all calculations
- Format currency displays appropriately  
- Handle all NULL scenarios
- Sort by data completeness (complete records first), then by price
- Limit to 30 results

Write your query below:
*/

-- YOUR QUERY HERE:




-- =====================================================
-- EXERCISE 5: ADVANCED BUSINESS ANALYSIS (30 points)
-- =====================================================

/*
BUSINESS SCENARIO: The CEO wants a comprehensive product performance dashboard.

TASK: Create an executive summary query that combines all Week 3 concepts:

REQUIREMENTS:
1. **Product Performance Metrics:**
   - Total order value (price + freight)
   - Revenue in NGN (500:1 exchange rate)  
   - Profit estimate (assume 25% gross margin on price)
   - Efficiency score (price/weight if available)

2. **Business Classifications:**
   - Market segment (Mass/Premium/Luxury based on price)
   - Logistics category (based on weight and dimensions)
   - Competitive position (High/Medium/Low based on price vs category average)
   - Growth potential (based on multiple factors)

3. **Operational Insights:**
   - Shipping efficiency rating (5-star system)
   - Inventory priority (High/Medium/Low)
   - Quality control requirement level
   - Customer communication priority

4. **Advanced Calculations:**
   - Category rank by price (use window functions if you know them, otherwise describe logic)
   - Value density (price per cubic cm)
   - Profitability index (custom formula combining multiple factors)

5. **Data Quality & Formatting:**
   - Proper decimal precision for financial data
   - Formatted strings for executive presentation
   - NULL handling throughout
   - Data completeness indicators

FINAL REQUIREMENTS:
- Include detailed comments explaining business logic
- Sort by profitability index (highest first)
- Group similar business classifications together
- Limit to 35 most important products
- Make the output executive-ready (clean formatting)

Write your comprehensive query below:
*/

-- YOUR QUERY HERE:




-- =====================================================
-- BONUS CHALLENGE (Extra Credit - 10 points)
-- =====================================================

/*
BUSINESS SCENARIO: International expansion planning

TASK: Create a query that identifies products suitable for international shipping:

CRITERIA:
- High value-to-weight ratio (valuable but light)
- Reasonable shipping costs (< 25% of product price)  
- Popular categories (computers, health_beauty, watches_gifts)
- Price range suitable for international market (100-800 BRL)

DELIVERABLES:
- Product ranking for international suitability
- Estimated international shipping feasibility
- Currency conversions for target markets (NGN, USD at 1BRL=0.20USD)
- Risk assessment based on product characteristics

Write your bonus query below:
*/

-- YOUR BONUS QUERY HERE:




-- =====================================================
-- REFLECTION QUESTIONS
-- =====================================================

/*
Answer these questions in comments:

1. What business insights did you discover while working with this data?

2. Which calculated fields would be most valuable for daily business operations?

3. How do proper data types and NULL handling impact business decision-making?

4. What additional data would help improve these analyses?

5. How could these queries be optimized for better performance?

YOUR ANSWERS:
1. 

2. 

3. 

4. 

5. 

*/

-- =====================================================
-- SUBMISSION CHECKLIST
-- =====================================================

/*
Before submitting, verify:
□ All queries run without errors
□ Results make business sense
□ Proper aliases and formatting used
□ NULL values handled appropriately  
□ Comments explain business logic
□ Sorting follows requirements
□ Calculations use proper data types
□ Output is clean and professional

Good luck! Remember: Think like a business analyst, not just a programmer.
*/