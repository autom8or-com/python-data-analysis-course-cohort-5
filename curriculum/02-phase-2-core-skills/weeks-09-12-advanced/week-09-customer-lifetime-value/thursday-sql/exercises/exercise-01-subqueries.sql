-- ================================================================
-- WEEK 9: CUSTOMER LIFETIME VALUE - EXERCISE 1
-- Topic: Subquery Fundamentals Practice
-- ================================================================

/*
INSTRUCTIONS:
Complete each exercise below using the appropriate subquery type
(WHERE clause, FROM clause, or SELECT clause subqueries).

Focus on Customer Lifetime Value analysis scenarios.

DATASETS: Use olist_sales_data_set schema tables:
- olist_customers_dataset
- olist_orders_dataset
- olist_order_items_dataset
- olist_products_dataset
- olist_order_reviews_dataset
- olist_order_payments_dataset

SUBMISSION:
- Write your queries below each exercise
- Test each query to ensure it runs
- Comment your approach
*/

-- ================================================================
-- EXERCISE 1.1: WHERE Clause Subquery
-- ================================================================

/*
TASK:
Find all customers whose lifetime value is greater than the average
lifetime value across ALL customers.

REQUIREMENTS:
- Show: customer_unique_id, customer_state, lifetime_value
- Include: total number of orders for each customer
- Filter: Only customers above average LTV
- Sort: By lifetime value descending
- Limit: Top 50

HINT: You'll need a subquery in the HAVING clause to compare against
the average customer LTV.
*/

-- YOUR SOLUTION HERE:




-- ================================================================
-- EXERCISE 1.2: FROM Clause Subquery (Derived Table)
-- ================================================================

/*
TASK:
Create a customer segmentation report showing how many customers fall
into different value tiers (Platinum, Gold, Silver, Bronze, Basic).

REQUIREMENTS:
- Value Tiers:
  * Platinum: LTV >= 1000
  * Gold: LTV >= 500
  * Silver: LTV >= 250
  * Bronze: LTV >= 100
  * Basic: LTV < 100
- Show: tier name, customer count, average LTV, total tier revenue
- Sort: By total tier revenue descending

HINT: First create a derived table that calculates customer LTV and
assigns tiers, then aggregate by tier in the outer query.
*/

-- YOUR SOLUTION HERE:




-- ================================================================
-- EXERCISE 1.3: SELECT Clause Subquery
-- ================================================================

/*
TASK:
Show each customer's information along with how they compare to the
average customer in their state.

REQUIREMENTS:
- Show: customer_unique_id, customer_state, customer_ltv
- Include: state average LTV (using SELECT subquery)
- Include: difference between customer LTV and state average
- Include: label ('Above Average' or 'Below Average')
- Filter: Only customers with LTV > 100
- Limit: 30 rows

HINT: Use a correlated subquery in the SELECT clause to calculate the
state average for each row.
*/

-- YOUR SOLUTION HERE:




-- ================================================================
-- EXERCISE 1.4: Combined Subquery Challenge
-- ================================================================

/*
TASK:
Find customers who:
1. Have spent more than the average customer in their state
2. Have purchased products from at least 3 different categories
3. Have placed more orders than the overall median number of orders

REQUIREMENTS:
- Show: customer_unique_id, customer_state, lifetime_value
- Include: number of unique categories purchased
- Include: total number of orders
- Sort: By lifetime value descending
- Limit: 25

HINT: You'll need multiple subqueries - some in WHERE, some in HAVING.
Consider using a derived table to first calculate customer metrics.
*/

-- YOUR SOLUTION HERE:




-- ================================================================
-- EXERCISE 1.5: Business Insight Challenge
-- ================================================================

/*
TASK:
Identify "one-hit wonders" - customers who made a single large purchase
but never returned.

REQUIREMENTS:
- Find customers with exactly 1 order
- Their single order value must be > average order value across ALL orders
- Show: customer_unique_id, customer_state, order_value, order_date
- Include: days since that order (as of 2018-09-01)
- Include: percentage above average order value
- Sort: By order value descending
- Limit: 20

BUSINESS QUESTION:
What might we learn from these customers to improve retention?

HINT: Use subqueries to find the average order value and filter to
single-order customers.
*/

-- YOUR SOLUTION HERE:




-- ================================================================
-- BONUS CHALLENGE: Advanced Subquery
-- ================================================================

/*
TASK:
Create a "State Performance Leaderboard" showing each state's:
- Total customers
- Total revenue
- Average customer LTV
- State's rank by revenue (nationwide)
- % of customers above national average LTV
- Top 10 customers' revenue contribution (%)

REQUIREMENTS:
- Only include states with at least 100 customers
- Sort by total revenue descending
- Show top 15 states

HINT: This will require multiple levels of subqueries and possibly
derived tables within derived tables.
*/

-- YOUR SOLUTION HERE:




-- ================================================================
-- REFLECTION QUESTIONS
-- ================================================================

/*
After completing these exercises, answer these questions in comments:

1. Which type of subquery (WHERE, FROM, SELECT) did you find most useful
   for CLV analysis? Why?


2. When did you find derived tables (FROM subqueries) more readable than
   nested WHERE subqueries?


3. What performance considerations should you keep in mind when using
   SELECT clause subqueries?


4. How would you decide between using a subquery vs a CTE for a complex
   analysis?

*/

-- ================================================================
-- END OF EXERCISE 1
-- ================================================================

-- Check solutions folder for complete answers and explanations!
