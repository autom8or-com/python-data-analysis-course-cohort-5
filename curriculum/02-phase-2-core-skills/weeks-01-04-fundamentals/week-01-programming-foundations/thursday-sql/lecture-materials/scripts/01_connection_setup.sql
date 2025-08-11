-- Week 01 Thursday SQL: Database Connection Setup and Verification
-- First Steps: Connecting to NaijaCommerce Database
-- Building Confidence: "You can do this!"

-- =============================================================================
-- SECTION 1: Connection Test - Are We Connected?
-- =============================================================================

-- Test 1: Basic connection (like opening Excel)
SELECT 'Hello SQL World!' AS welcome_message;

-- Expected Result: You should see "Hello SQL World!" 
-- ✅ Success means your VS Code → Supabase connection works!

-- Test 2: Check database version and time
SELECT 
    version() AS "Database Version",
    current_timestamp AS "Current Time",
    current_user AS "Connected User";

-- 💡 This is like checking "File → Properties" in Excel

-- =============================================================================
-- SECTION 2: Schema and Table Discovery
-- =============================================================================

-- Test 3: Can we see our NaijaCommerce schemas?
SELECT schema_name AS "Available Schemas"
FROM information_schema.schemata 
WHERE schema_name LIKE '%olist%'
ORDER BY schema_name;

-- Expected Result: Should show olist_sales_data_set and olist_marketing_data_set
-- ✅ Success means you can access the NaijaCommerce data!

-- Test 4: Can we see tables in our main sales schema?
SELECT 
    table_name AS "Table Name",
    table_type AS "Type"
FROM information_schema.tables 
WHERE table_schema = 'olist_sales_data_set'
ORDER BY table_name;

-- Expected Result: Should show orders, customers, products, payments, etc.
-- ✅ Success means all our business data tables are accessible!

-- =============================================================================
-- SECTION 3: Basic Data Access Test
-- =============================================================================

-- Test 5: Can we query the orders table? (Yesterday's Python equivalent: df.head())
SELECT 
    order_id,
    order_status, 
    order_purchase_timestamp
FROM olist_sales_data_set.olist_orders_dataset 
LIMIT 3;

-- Expected Result: Should show 3 rows of order data
-- ✅ Success means you can read the same data you analyzed yesterday in Python!

-- Test 6: Can we count records? (Yesterday's Python equivalent: len(df))
SELECT 
    'orders' AS table_name,
    COUNT(*) AS record_count
FROM olist_sales_data_set.olist_orders_dataset

UNION ALL

SELECT 
    'customers' AS table_name,
    COUNT(*) AS record_count  
FROM olist_sales_data_set.olist_customers_dataset

UNION ALL

SELECT 
    'products' AS table_name,
    COUNT(*) AS record_count
FROM olist_sales_data_set.olist_products_dataset;

-- Expected Results: 
-- orders: ~99,441 records
-- customers: ~99,441 records  
-- products: ~32,951 records
-- ✅ Success means you have access to the full dataset!

-- =============================================================================
-- SECTION 4: Permissions and Access Verification
-- =============================================================================

-- Test 7: Can we access both schemas?
SELECT 
    'sales_schema' AS schema_type,
    COUNT(*) AS table_count
FROM information_schema.tables 
WHERE table_schema = 'olist_sales_data_set'

UNION ALL

SELECT 
    'marketing_schema' AS schema_type,
    COUNT(*) AS table_count
FROM information_schema.tables 
WHERE table_schema = 'olist_marketing_data_set';

-- Expected Results: Should show table counts for both schemas
-- ✅ Success means you have full access to all NaijaCommerce data!

-- =============================================================================
-- SECTION 5: Data Types and Structure Verification
-- =============================================================================

-- Test 8: Can we see column information? (Yesterday's Python equivalent: df.info())
SELECT 
    column_name,
    data_type,
    is_nullable
FROM information_schema.columns 
WHERE table_name = 'olist_orders_dataset' 
  AND table_schema = 'olist_sales_data_set'
ORDER BY ordinal_position
LIMIT 5;

-- Expected Result: Column details for the orders table
-- ✅ Success means you can explore data structure like you did yesterday!

-- =============================================================================
-- SECTION 6: Business Context Verification
-- =============================================================================

-- Test 9: Can we answer a simple business question?
SELECT 
    COUNT(DISTINCT order_status) AS "Number of Order Statuses",
    MIN(order_purchase_timestamp) AS "First Order Date",
    MAX(order_purchase_timestamp) AS "Latest Order Date"
FROM olist_sales_data_set.olist_orders_dataset;

-- Expected Result: Statistics about our order data
-- ✅ Success means you can start analyzing the business immediately!

-- Test 10: Can we see our customer geographic spread?
SELECT 
    customer_state AS "State",
    COUNT(*) AS "Customer Count"
FROM olist_sales_data_set.olist_customers_dataset
GROUP BY customer_state
ORDER BY COUNT(*) DESC
LIMIT 5;

-- Expected Result: Top 5 states by customer count
-- ✅ Success means you can do the same geographic analysis as yesterday!

-- =============================================================================
-- SECTION 7: Connection Troubleshooting Guide
-- =============================================================================

/*
If any of the above tests fail, here's what to check:

❌ Test 1 fails: "Hello SQL World!" doesn't show
   → VS Code not connected to database
   → Check connection string in VS Code PostgreSQL extension

❌ Test 3 fails: No olist schemas shown  
   → Wrong database or permission issues
   → Verify Supabase project and credentials

❌ Test 5 fails: Can't select from orders table
   → Table access permissions
   → Schema name spelling (olist_sales_data_set)

❌ Test 6 fails: Count queries don't work
   → SQL syntax issues
   → Check for typos in table names

✅ All tests pass: You're ready to start learning SQL!
   → Move on to basic SELECT statements
   → You have the same data access as yesterday's Python work
*/

-- =============================================================================
-- SECTION 8: Success Confirmation Message
-- =============================================================================

-- Final Test: Generate a success report
SELECT 
    'CONNECTION SUCCESS!' AS status,
    current_timestamp AS connected_at,
    'You can access the same NaijaCommerce data from yesterday!' AS message,
    'Ready to learn SQL!' AS next_step;

-- =============================================================================
-- INSTRUCTOR NOTES: What Each Test Verifies
-- =============================================================================

/*
Test 1-2: Basic database connectivity and session info
Test 3-4: Schema and table visibility (data catalog access)
Test 5-6: Read permissions on core business tables
Test 7: Multi-schema access verification
Test 8: Metadata access (for exploring table structures)
Test 9-10: Business query functionality

Success Criteria:
✅ All 10 tests should run without errors
✅ Record counts should match expected values
✅ Student can see schemas, tables, and data
✅ Connection is stable for 2-hour session

Common Issues:
- Network connectivity problems
- Incorrect connection strings
- Case sensitivity in schema/table names
- Permission restrictions
- VS Code extension not properly configured

Resolution Path:
1. Basic connectivity (Tests 1-2)
2. Access verification (Tests 3-4) 
3. Data access (Tests 5-6)
4. Full functionality (Tests 7-10)
*/

-- =============================================================================
-- STUDENT SUCCESS MESSAGE
-- =============================================================================

/*
🎉 CONGRATULATIONS! 

If you can run all these queries successfully, you have:

✅ Connected to a professional database system
✅ Accessed the same NaijaCommerce data from yesterday
✅ Verified you can run business analysis queries
✅ Confirmed you're ready to learn SQL!

This is the SAME data you worked with yesterday in Python:
- Same orders, customers, products, payments
- Same business questions to answer
- Same insights to discover
- Just using a different tool (SQL instead of Python)

You already have the analytical mindset.
Now you're just learning a new syntax for the same logic!

Ready to write your first real SQL queries? Let's go! 🚀
*/