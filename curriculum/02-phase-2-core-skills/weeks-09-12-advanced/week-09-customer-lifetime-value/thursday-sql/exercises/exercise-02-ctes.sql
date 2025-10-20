-- ================================================================
-- WEEK 9: CUSTOMER LIFETIME VALUE - EXERCISE 2
-- Topic: Common Table Expressions (CTEs) Practice
-- ================================================================

/*
INSTRUCTIONS:
Complete each exercise using CTEs (WITH clauses) to build multi-stage
analytical pipelines for Customer Lifetime Value analysis.

Focus on creating readable, maintainable queries with clear business logic.

BEST PRACTICES:
- Name CTEs with clear, business-meaningful names
- Comment each CTE's purpose
- Build complexity gradually (simple → complex CTEs)
- Test each CTE independently before chaining
*/

-- ================================================================
-- EXERCISE 2.1: Basic RFM Segmentation
-- ================================================================

/*
TASK:
Create a 3-stage CTE pipeline that implements RFM segmentation.

STAGE 1: Calculate raw RFM metrics for each customer
STAGE 2: Assign scores (1-5) for each dimension
STAGE 3: Create segments and analyze performance

REQUIREMENTS:
Final output should show:
- Segment name (Champions, Loyal, At Risk, etc.)
- Customer count per segment
- Average LTV per segment
- Average RFM score per segment
- Recommended marketing action

HINT: Refer to lecture materials for RFM scoring thresholds.
*/

-- YOUR SOLUTION HERE:




-- ================================================================
-- EXERCISE 2.2: Cohort Retention Analysis
-- ================================================================

/*
TASK:
Build a cohort analysis showing month-over-month retention rates.

CTE PIPELINE:
1. customer_cohorts: Assign each customer to their first purchase month
2. cohort_orders: Count orders by cohort and subsequent months
3. retention_rates: Calculate % of cohort still active each month

REQUIREMENTS:
Final output should show:
- Cohort month
- Initial cohort size
- Customers still active after 1 month
- Customers still active after 3 months
- Retention rate at 1 month (%)
- Retention rate at 3 months (%)

DEFINITION: "Active" = placed at least one order in that period

HINT: Use date arithmetic to calculate months since cohort start.
*/

-- YOUR SOLUTION HERE:




-- ================================================================
-- EXERCISE 2.3: Customer Journey Funnel
-- ================================================================

/*
TASK:
Create a customer journey funnel showing conversion at each stage.

FUNNEL STAGES:
1. All customers (placed first order)
2. Converted to second order
3. Became repeat customers (3+ orders)
4. Became loyal customers (5+ orders)
5. Became champions (10+ orders, LTV > 500)

REQUIREMENTS:
Use CTEs to calculate:
- Number of customers at each stage
- Conversion rate from previous stage
- Average LTV at each stage
- Average days to reach each stage (from first order)

OUTPUT:
- funnel_stage name
- customer_count
- conversion_rate_from_previous (%)
- avg_ltv
- avg_days_to_stage

HINT: Use window functions (LAG) to calculate conversion rates.
*/

-- YOUR SOLUTION HERE:




-- ================================================================
-- EXERCISE 2.4: Product Category Expansion Analysis
-- ================================================================

/*
TASK:
Analyze how customers expand across product categories over time.

CTE PIPELINE:
1. first_category: Each customer's first category purchased
2. category_expansion: Subsequent categories and timeline
3. expansion_patterns: Aggregate expansion behavior
4. segment_performance: Analyze by expansion pattern

REQUIREMENTS:
Final output should show:
- expansion_pattern (e.g., "Single Category", "Fast Expander", "Slow Expander")
- customer_count
- avg_lifetime_value
- avg_categories_purchased
- avg_days_to_second_category
- cross_sell_success_rate (%)

DEFINITIONS:
- Fast Expander: 2nd category within 30 days
- Slow Expander: 2nd category after 30 days
- Single Category: Never expanded

HINT: Use CASE statements to classify expansion patterns.
*/

-- YOUR SOLUTION HERE:




-- ================================================================
-- EXERCISE 2.5: Churn Risk Prediction
-- ================================================================

/*
TASK:
Build a churn risk assessment using customer behavior patterns.

CTE PIPELINE:
1. customer_metrics: Calculate key behavioral metrics
2. purchase_velocity: Calculate frequency trends
3. engagement_signals: Identify warning signs
4. churn_risk_scores: Combine signals into risk score
5. risk_segments: Group by risk level and recommend actions

METRICS TO CALCULATE:
- Days since last order
- Average days between orders
- Order frequency trend (increasing/stable/declining)
- LTV tier
- Review sentiment (if negative reviews exist)

RISK FACTORS:
- Days since last order > 2x average purchase interval
- Decreasing order frequency
- Recent negative review
- High historical value (more to lose)

REQUIREMENTS:
Final output should show:
- risk_level (Critical, High, Medium, Low)
- customer_count
- total_revenue_at_risk
- avg_days_inactive
- recommended_intervention

SORT: By total revenue at risk descending

HINT: Weight risk factors differently - recent behavior matters more!
*/

-- YOUR SOLUTION HERE:




-- ================================================================
-- EXERCISE 2.6: State Market Penetration Analysis
-- ================================================================

/*
TASK:
Analyze market penetration and growth potential by state.

CTE PIPELINE:
1. state_metrics: Calculate current performance
2. state_benchmarks: Identify top performers
3. growth_potential: Compare each state to benchmarks
4. market_classification: Categorize markets
5. investment_recommendations: Prioritize opportunities

REQUIREMENTS:
Final output should show:
- customer_state
- current_customers
- current_revenue
- avg_customer_ltv
- market_maturity (Mature/Growing/Emerging)
- growth_potential_score (1-10)
- investment_priority (High/Medium/Low)
- recommended_strategy

GROWTH SIGNALS:
- LTV below benchmark but growing
- Low repeat rate with high initial orders
- High customer count with low LTV (upsell opportunity)

HINT: Compare each state to top 25th percentile benchmarks.
*/

-- YOUR SOLUTION HERE:




-- ================================================================
-- BONUS CHALLENGE: Predictive Next Best Action
-- ================================================================

/*
TASK:
Create a "Next Best Action" recommendation engine.

CTE PIPELINE:
1. customer_profile: Comprehensive customer metrics
2. behavior_gaps: Identify what customer hasn't done yet
3. opportunity_scoring: Score each potential action
4. action_recommendations: Prioritize top 3 actions per customer

POTENTIAL ACTIONS:
- "Category Cross-Sell: [category name]"
- "Frequency Boost: Incentivize repeat purchase"
- "AOV Increase: Upsell to premium products"
- "Reactivation: Win-back campaign"
- "Loyalty Upgrade: VIP program invitation"
- "Payment Flexibility: Offer installments"

SCORING CRITERIA:
- Expected revenue impact
- Likelihood of success (based on similar customers)
- Time sensitivity (churn risk)
- Implementation cost (High/Medium/Low)

REQUIREMENTS:
For each customer with LTV > 200, show:
- customer_unique_id
- current_ltv
- primary_recommended_action
- expected_revenue_impact
- action_priority_score
- implementation_timeline (Immediate/This Month/This Quarter)

LIMIT: Top 100 customers by priority score

HINT: This is complex! Break it into many small CTEs, test each one.
*/

-- YOUR SOLUTION HERE:




-- ================================================================
-- REFLECTION QUESTIONS
-- ================================================================

/*
After completing these exercises, reflect on:

1. How did CTEs improve readability compared to nested subqueries?


2. Which CTE pipeline was most complex? How did you manage the complexity?


3. When would you convert a CTE to a permanent VIEW instead?


4. How could you make these CTEs more performant for production use?


5. What business insights surprised you from these analyses?

*/

-- ================================================================
-- END OF EXERCISE 2
-- ================================================================

-- Check solutions folder for complete answers with detailed explanations!
