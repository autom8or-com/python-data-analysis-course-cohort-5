/*
=============================================================================
WEEK 10: INVENTORY MANAGEMENT & SUPPLY CHAIN ANALYSIS
Thursday SQL Session - Database Normalization Review
=============================================================================

LEARNING OBJECTIVES:
By the end of this lesson, you will be able to:
1. Understand the purpose and benefits of database normalization
2. Apply the first three normal forms (1NF, 2NF, 3NF)
3. Identify normalization issues in real-world schemas
4. Make informed decisions about denormalization for analytics

BUSINESS CONTEXT:
You're working with LagosMart, a Nigerian e-commerce marketplace similar to Olist.
Management wants to understand why their database is structured the way it is,
and whether the design supports efficient inventory management and supply chain operations.

DURATION: 30 minutes
=============================================================================
*/

-- =============================================================================
-- SECTION 1: UNDERSTANDING DATABASE NORMALIZATION
-- =============================================================================

/*
WHAT IS NORMALIZATION?
----------------------
Normalization is the process of organizing database tables to:
- Reduce data redundancy (duplicate information)
- Ensure data integrity (consistency and accuracy)
- Make the database easier to maintain
- Optimize storage space

EXCEL ANALOGY:
Think of normalization like organizing multiple Excel sheets instead of
cramming everything into one massive spreadsheet with repeated information.

BAD PRACTICE (Denormalized):
Order_ID | Customer_Name | Customer_City | Product_Name | Product_Category | Price
1001     | Adewale Lagos | Lagos        | Samsung TV   | Electronics      | ₦450,000
1002     | Adewale Lagos | Lagos        | HP Laptop    | Electronics      | ₦320,000

PROBLEM: Customer information repeats for every order!

GOOD PRACTICE (Normalized):
Customers Table: Customer_ID | Name | City
Orders Table: Order_ID | Customer_ID | Order_Date
Order_Items Table: Order_Item_ID | Order_ID | Product_ID | Price
Products Table: Product_ID | Name | Category
*/

-- Let's examine the Olist database structure
SELECT
    table_schema,
    table_name,
    column_name,
    data_type,
    is_nullable
FROM information_schema.columns
WHERE table_schema = 'olist_sales_data_set'
ORDER BY table_name, ordinal_position;

-- NIGERIAN BUSINESS APPLICATION:
-- Proper normalization helps Lagos warehouse managers avoid data inconsistencies
-- when product information changes or customer details are updated

/*
=============================================================================
KEY TAKEAWAYS
=============================================================================

1. NORMALIZATION BENEFITS:
   ✅ Reduces data redundancy
   ✅ Ensures data integrity
   ✅ Makes updates easier
   ✅ Saves storage space

2. NORMALIZATION LEVELS:
   - 1NF: Atomic values, unique rows
   - 2NF: No partial dependencies
   - 3NF: No transitive dependencies

3. WHEN TO DENORMALIZE:
   - Analytics and reporting systems
   - Frequently accessed combinations
   - Performance-critical queries

NIGERIAN BUSINESS APPLICATION:
- Design schemas that support fast queries for Lagos inventory
- Balance normalization with performance for retail dashboards
=============================================================================
*/
