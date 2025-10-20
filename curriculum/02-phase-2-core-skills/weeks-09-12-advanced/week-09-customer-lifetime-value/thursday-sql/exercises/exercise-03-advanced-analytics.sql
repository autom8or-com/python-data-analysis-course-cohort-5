-- ================================================================
-- WEEK 9: CUSTOMER LIFETIME VALUE - EXERCISE 3
-- Topic: Correlated Subqueries & Advanced Analytics
-- ================================================================

/*
INSTRUCTIONS:
Complete these advanced exercises focusing on correlated subqueries,
EXISTS/NOT EXISTS patterns, and complex CLV analytics.

These exercises combine all Week 9 concepts for comprehensive analysis.

PERFORMANCE TIP:
Correlated subqueries can be slow. Consider alternatives (CTEs, JOINs)
if performance becomes an issue.
*/

-- ================================================================
-- EXERCISE 3.1: Customer Percentile Ranking
-- ================================================================

/*
TASK:
Calculate each customer's percentile rank based on lifetime value.

REQUIREMENTS:
- Show: customer_unique_id, customer_state, lifetime_value
- Include: percentile_rank (0-100, where 100 = highest value)
- Include: rank_category (Top 10%, Top 25%, Top 50%, Bottom 50%)
- Filter: Only customers with LTV > 100
- Sort: By percentile rank descending
- Limit: 50

HINT: Use a correlated subquery to count how many customers have
lower LTV, then calculate percentile.
*/

-- YOUR SOLUTION HERE:




-- ================================================================
-- EXERCISE 3.2: EXISTS Pattern - Multi-Category Champions
-- ================================================================

/*
TASK:
Find customers who have purchased from ALL of the top 5 revenue-generating
product categories.

REQUIREMENTS:
Step 1: Identify top 5 categories by total revenue
Step 2: Find customers who bought from all 5
Final output should show:
- customer_unique_id
- customer_state
- total_lifetime_value
- total_orders
- List of all categories purchased from

HINT: Use NOT EXISTS to check if there's any top category the customer
hasn't purchased from.
*/

-- YOUR SOLUTION HERE:




-- ================================================================
-- EXERCISE 3.3: Correlated Running Total
-- ================================================================

/*
TASK:
Show each customer's order history with running totals.

REQUIREMENTS:
For customers with 3+ orders, show each order with:
- order_id
- customer_unique_id
- order_date
- order_value
- running_total_ltv (cumulative value up to this order)
- order_sequence_number (1st, 2nd, 3rd, etc.)
- cumulative_ltv_percentile (what % of final LTV reached?)

HINT: Use correlated subqueries with date comparison to calculate
running totals for each order.

BUSINESS INSIGHT: At what order do customers typically reach 80% of
their final LTV?
*/

-- YOUR SOLUTION HERE:




-- ================================================================
-- EXERCISE 3.4: NOT EXISTS Pattern - Perfect Customers
-- ================================================================

/*
TASK:
Identify "perfect customers" who meet ALL these criteria:
1. LTV > $300
2. At least 3 orders
3. Never left a review score below 4
4. Never used Boleto payment (only credit card)
5. Purchased from at least 2 categories

REQUIREMENTS:
- Show: customer_unique_id, customer_state, lifetime_value
- Include: total_orders, avg_review_score, categories_count
- Use NOT EXISTS to check for negative conditions
- Sort: By lifetime value descending
- Limit: 30

BUSINESS QUESTION: What characteristics do these perfect customers share?
*/

-- YOUR SOLUTION HERE:




-- ================================================================
-- EXERCISE 3.5: Peer Comparison Analysis
-- ================================================================

/*
TASK:
Compare each high-value customer to similar customers in their state.

REQUIREMENTS:
For customers with LTV > $500, show:
- customer_unique_id
- customer_state
- customer_ltv
- state_avg_ltv (correlated subquery)
- state_median_ltv (correlated subquery)
- customers_in_state (correlated subquery)
- rank_in_state (correlated subquery)
- performance_vs_peers (Much Above/Above/Average/Below)

DEFINITIONS:
- Much Above: > 150% of state median
- Above: > 100% of state median
- Average: 80-100% of state median
- Below: < 80% of state median

HINT: Each correlated subquery should reference the outer query's state.
*/

-- YOUR SOLUTION HERE:




-- ================================================================
-- EXERCISE 3.6: Purchase Velocity Trend Detection
-- ================================================================

/*
TASK:
Identify customers with declining purchase frequency (churn warning).

REQUIREMENTS:
For customers with 4+ orders:
- Calculate days between first two orders
- Calculate days between last two orders
- Compare to identify trend

Show:
- customer_unique_id
- customer_state
- lifetime_value
- total_orders
- avg_days_between_early_orders (first 3 orders)
- avg_days_between_recent_orders (last 3 orders)
- velocity_trend (Accelerating/Stable/Decelerating)
- churn_risk (High/Medium/Low)

CHURN RISK CRITERIA:
- High: Recent interval > 2x early interval AND LTV > $300
- Medium: Recent interval > 1.5x early interval
- Low: Stable or accelerating

HINT: Use correlated subqueries to calculate intervals between specific
order sequence numbers.
*/

-- YOUR SOLUTION HERE:




-- ================================================================
-- EXERCISE 3.7: Category Affinity Matrix
-- ================================================================

/*
TASK:
Build a customer-category purchase matrix showing which customers bought
from which top categories.

REQUIREMENTS:
Step 1: Identify top 10 categories by customer count
Step 2: For each customer with LTV > $200, create a row showing:
- customer_unique_id
- lifetime_value
- Boolean flags for each top category (1 if purchased, 0 if not)
- category_breadth_score (sum of flags)
- cross_sell_opportunity_score (10 - category_breadth_score)

Use EXISTS subqueries to check if customer purchased from each category.

OUTPUT: Top 50 customers by cross-sell opportunity score

BUSINESS USE: Targeted cross-sell campaigns for specific categories
*/

-- YOUR SOLUTION HERE:




-- ================================================================
-- EXERCISE 3.8: Customer Lifetime Stages
-- ================================================================

/*
TASK:
Classify each customer's current lifecycle stage based on behavior.

STAGES:
1. "New Prospect" - 1 order, recent (< 60 days)
2. "Growing Customer" - 2-3 orders, increasing frequency
3. "Loyal Customer" - 4+ orders, stable frequency
4. "VIP Champion" - 5+ orders, LTV > $500, recent activity
5. "At Risk" - Good history but inactive > 90 days
6. "Dormant High-Value" - LTV > $300 but inactive > 180 days
7. "Churned" - Inactive > 365 days

REQUIREMENTS:
For each customer, show:
- customer_unique_id
- customer_state
- lifetime_value
- total_orders
- days_since_last_order (correlated)
- purchase_frequency_trend (correlated)
- lifecycle_stage
- recommended_next_action

HINT: Use CASE statement with multiple correlated subquery conditions.
*/

-- YOUR SOLUTION HERE:




-- ================================================================
-- BONUS CHALLENGE: Comprehensive CLV Health Dashboard
-- ================================================================

/*
TASK:
Create an executive dashboard showing CLV health metrics by combining
all advanced techniques learned this week.

REQUIREMENTS:

SECTION 1: Overall Metrics
- Total customers
- Total revenue
- Avg LTV
- Median LTV
- % of revenue from top 20% customers
- % of revenue from repeat customers

SECTION 2: Risk Distribution
- Customers by risk level (Critical/High/Medium/Low)
- Revenue at risk by level
- Avg days inactive by level

SECTION 3: Opportunity Analysis
- Cross-sell opportunity (single-category customers)
- Upsell opportunity (low AOV but high frequency)
- Reactivation opportunity (high historical value, now dormant)

SECTION 4: Trend Indicators
- New customer acquisition (this month vs last month)
- Repeat purchase rate trend
- Average LTV trend by cohort

Use a combination of:
- CTEs for base metrics
- Correlated subqueries for comparisons
- EXISTS patterns for categorical checks
- Derived tables for complex aggregations

OUTPUT: Multiple result sets showing different dashboard sections

HINT: Break this into multiple queries, one per dashboard section.
*/

-- YOUR SOLUTION HERE:




-- ================================================================
-- REFLECTION QUESTIONS
-- ================================================================

/*
After completing these advanced exercises:

1. When did correlated subqueries provide insights that JOINs couldn't?


2. How did EXISTS/NOT EXISTS improve query readability and performance?


3. What was the most challenging aspect of row-by-row calculations?


4. How would you optimize the most complex query you wrote?


5. Which analytical pattern (subqueries/CTEs/correlation) would you
   use for each business scenario? Why?
   a) Monthly cohort analysis
   b) Customer percentile ranking
   c) Multi-step segmentation
   d) Peer comparisons


6. What CLV insights would you present to:
   a) Marketing team?
   b) Product team?
   c) Executive team?

*/

-- ================================================================
-- END OF EXERCISE 3
-- ================================================================

/*
CONGRATULATIONS!

You've completed Week 9 advanced SQL exercises focusing on Customer
Lifetime Value analysis using subqueries, CTEs, and correlated patterns.

These skills form the foundation of:
- Customer analytics
- Marketing optimization
- Churn prediction
- Revenue forecasting
- Strategic business intelligence

Next steps:
1. Review solutions for optimization techniques
2. Apply these patterns to your own datasets
3. Build production CLV dashboards
4. Combine with visualization tools (Looker Studio, Tableau)

Keep analyzing!
*/
