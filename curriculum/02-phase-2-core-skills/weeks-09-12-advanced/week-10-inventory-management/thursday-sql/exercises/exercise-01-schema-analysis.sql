/*
================================================================================
WEEK 10 - THURSDAY SQL EXERCISE 1
Schema Analysis and Normalization
================================================================================

EXERCISE DURATION: 30 minutes
DIFFICULTY: Intermediate

LEARNING OBJECTIVES:
- Analyze the Olist database schema design
- Identify normalization levels and patterns
- Recognize design decisions and trade-offs
- Propose improvements for specific use cases

INSTRUCTIONS:
Complete all questions below. Write SQL queries where requested and provide
written analysis where indicated. Some questions require critical thinking
about database design principles.

================================================================================
*/

-- ============================================================================
-- PART 1: SCHEMA EXPLORATION (10 minutes)
-- ============================================================================

/*
QUESTION 1.1: Primary Keys Analysis
List all tables in the olist_sales_data_set schema and identify their primary keys.

TASK:
Write a query that shows:
- Table name
- Primary key column(s)
- Data type of the primary key

HINT: Use the information_schema.table_constraints and key_column_usage views
*/

-- YOUR QUERY HERE:




/*
QUESTION 1.2: Foreign Key Relationships
Identify all foreign key relationships in the Olist schema.

TASK:
Write a query that shows:
- Table with the foreign key
- Foreign key column name
- Referenced table
- Referenced column
- Delete rule (CASCADE, RESTRICT, etc.)

This reveals the database's referential integrity design.
*/

-- YOUR QUERY HERE:




/*
QUESTION 1.3: Data Type Analysis
Examine the data types used in the products table.

TASK:
Write a query to show all columns in olist_products_dataset with their:
- Column name
- Data type
- Whether it allows NULL values

ANALYSIS: Are the data types appropriate for the business domain?
Are there any columns that should/shouldn't allow NULL?
*/

-- YOUR QUERY HERE:




-- ============================================================================
-- PART 2: NORMALIZATION ANALYSIS (15 minutes)
-- ============================================================================

/*
QUESTION 2.1: First Normal Form (1NF) Compliance
Analyze whether the Olist schema follows 1NF rules.

1NF Requirements:
- Each column contains atomic (indivisible) values
- Each column contains values of a single type
- Each row is unique (has a primary key)
- Order of rows doesn't matter

TASK:
a) Check if there are any columns that violate 1NF (contain comma-separated values, arrays, etc.)
b) Write a query to identify products where product_category_name might contain multiple values
c) Check if any text columns contain structured data that should be in separate tables
*/

-- YOUR QUERY HERE:




/*
WRITTEN ANALYSIS:
Does the Olist schema comply with 1NF? Explain your findings:

YOUR ANSWER:



*/


/*
QUESTION 2.2: Second Normal Form (2NF) Analysis
Analyze the order_items table for 2NF compliance.

2NF Requirements:
- Must be in 1NF
- All non-key attributes must depend on the ENTIRE primary key (relevant for composite keys)

TASK:
a) Examine the order_items table structure
b) Identify what the primary key should be (or is)
c) Determine if there are any partial dependencies

Write a query to show the structure of order_items:
*/

-- YOUR QUERY HERE:




/*
WRITTEN ANALYSIS:
Is the order_items table in 2NF? Are there any partial dependencies?
If you had to create a composite primary key, what would it be and why?

YOUR ANSWER:



*/


/*
QUESTION 2.3: Third Normal Form (3NF) Analysis
Analyze the Olist schema for transitive dependencies.

3NF Requirements:
- Must be in 2NF
- No transitive dependencies (non-key attributes depending on other non-key attributes)

SCENARIO:
Imagine if the sellers table included these columns:
- seller_id (PK)
- seller_city
- seller_state
- state_region (derived from state: 'North', 'South', 'East', 'West')

TASK:
a) Explain why including 'state_region' violates 3NF
b) Design a normalized solution
c) Write queries to demonstrate your solution
*/

-- YOUR QUERY HERE:




/*
WRITTEN ANALYSIS:
Explain the 3NF violation and your normalized solution:

YOUR ANSWER:



*/


/*
QUESTION 2.4: Real-world 3NF Check
Examine whether customer address information in the Olist schema is properly normalized.

TASK:
a) Query the customers table to see how location data is stored
b) Check if zip code could be used to derive city and state (transitive dependency)
c) Analyze if the current design is optimal for this use case
*/

-- YOUR QUERY HERE:




/*
WRITTEN ANALYSIS:
Is the customer location data fully normalized? Should it be?
Consider trade-offs between normalization and query performance.

YOUR ANSWER:



*/


-- ============================================================================
-- PART 3: DENORMALIZATION OPPORTUNITIES (15 minutes)
-- ============================================================================

/*
QUESTION 3.1: Identify Expensive Joins
Find queries that require many joins and would benefit from denormalization.

SCENARIO:
You need to create a daily sales report that shows:
- Order date
- Customer city and state
- Product category
- Seller city and state
- Order value
- Freight cost

TASK:
a) Write the fully normalized query (with all necessary joins)
b) Use EXPLAIN ANALYZE to check the query cost
c) Count how many tables are joined
*/

-- YOUR QUERY HERE:




/*
QUESTION 3.2: Design a Denormalized Reporting Table
Based on the expensive query above, design a denormalized table for reporting.

TASK:
a) Create a denormalized table schema that pre-joins the data
b) List which columns you would include
c) Identify what data would be duplicated
d) Estimate storage vs. performance trade-off
*/

-- YOUR QUERY HERE (CREATE TABLE statement):




/*
WRITTEN ANALYSIS:
Justify your denormalization decisions:

YOUR ANSWER:
What data is duplicated:


Storage impact:


Performance benefit:


Update complexity:



*/


/*
QUESTION 3.3: Materialized View for Product Performance
Create a denormalized view for product analytics.

BUSINESS REQUIREMENT:
The marketing team frequently needs product performance metrics:
- Total orders per product
- Total revenue per product
- Average rating per product
- Number of sellers offering the product
- Geographic reach (states sold in)

TASK:
a) Design a materialized view with these metrics
b) Write the CREATE MATERIALIZED VIEW statement
c) Add appropriate indexes
d) Explain refresh strategy
*/

-- YOUR QUERY HERE:




/*
WRITTEN ANALYSIS:
Refresh strategy for your materialized view:

YOUR ANSWER:
How often should it be refreshed:


What triggers a refresh:


Impact on query performance:



*/


-- ============================================================================
-- PART 4: DESIGN IMPROVEMENTS (20 minutes)
-- ============================================================================

/*
QUESTION 4.1: Missing Constraints
Identify potential data integrity issues in the Olist schema.

TASK:
a) Check for potential negative prices in order_items
b) Check for orders with impossible dates (delivered before purchased)
c) Check for products without categories
d) List any other data quality issues you find
*/

-- YOUR QUERY HERE:




/*
WRITTEN ANALYSIS:
What constraints would you add to prevent these issues?

YOUR ANSWER:



*/


/*
QUESTION 4.2: Index Strategy
Design an indexing strategy for common query patterns.

COMMON QUERIES IN E-COMMERCE:
1. Find all orders for a customer
2. Find all products in a category
3. Find all orders in a date range
4. Find sellers in a specific state
5. Search products by name

TASK:
Write CREATE INDEX statements for these query patterns:
*/

-- YOUR INDEXES HERE:




/*
QUESTION 4.3: Scalability Concerns
Analyze potential scalability issues as the business grows.

SCENARIO:
Current: 100K orders, 30K products, 3K sellers
Future: 10M orders, 500K products, 50K sellers

TASK:
a) Identify which tables will grow most
b) Identify which queries will slow down most
c) Propose partitioning strategies
d) Suggest archival strategies
*/

-- YOUR QUERIES HERE:




/*
WRITTEN ANALYSIS:
Your scalability recommendations:

YOUR ANSWER:
Tables needing partitioning:


Archival strategy:


Query optimization needed:


Infrastructure considerations:



*/


-- ============================================================================
-- PART 5: NIGERIAN E-COMMERCE CONTEXT (10 minutes)
-- ============================================================================

/*
QUESTION 5.1: Adapt Schema for Nigerian Market
The Olist schema is designed for Brazil. What changes would you make for Nigeria?

CONSIDERATIONS:
- Multiple currencies (NGN, USD)
- Mobile money payment methods
- State-specific delivery zones
- Product import/export tracking
- Multi-language support (English, Yoruba, Igbo, Hausa)

TASK:
Design schema modifications or new tables to support these requirements.
*/

-- YOUR SCHEMA CHANGES HERE:




/*
WRITTEN ANALYSIS:
Explain your design decisions for the Nigerian market:

YOUR ANSWER:



*/


/*
QUESTION 5.2: Lagos Warehouse Optimization
Design a schema addition for warehouse zone management in Lagos.

REQUIREMENTS:
- Lagos warehouse serves multiple zones (Island, Mainland, Lekki, etc.)
- Different delivery costs per zone
- Different delivery times per zone
- Zone-based inventory allocation

TASK:
Create the necessary tables and relationships.
*/

-- YOUR SCHEMA HERE:




-- ============================================================================
-- BONUS CHALLENGE
-- ============================================================================

/*
BONUS: Design a Complete Inventory Management Schema
Based on everything you've learned, design a normalized inventory management
schema for a Nigerian e-commerce marketplace.

REQUIREMENTS:
- Multiple warehouses
- Stock tracking (on-hand, reserved, available)
- Reorder points and automatic PO generation
- Product suppliers with lead times
- Batch/lot tracking for expirable products
- Warehouse locations (aisle, shelf, bin)
- Inventory valuation (FIFO, LIFO, Average)

DELIVERABLES:
1. Entity-Relationship diagram (describe in comments)
2. CREATE TABLE statements with all constraints
3. Sample queries for common operations
4. Explanation of normalization decisions
*/

-- YOUR SCHEMA HERE:




/*
================================================================================
SUBMISSION CHECKLIST
================================================================================

Before submitting, ensure you have:
□ Answered all questions in Parts 1-5
□ Provided both SQL queries and written analysis where requested
□ Tested all queries for syntax errors
□ Explained your reasoning for design decisions
□ Considered Nigerian e-commerce context
□ (Optional) Completed the bonus challenge

GRADING CRITERIA:
- SQL Query Accuracy: 40%
- Normalization Understanding: 25%
- Design Justifications: 20%
- Nigerian Market Adaptations: 10%
- Bonus Challenge: 5%

================================================================================
*/
