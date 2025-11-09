-- Week 11: Marketing Performance Analysis & Optimization
-- Thursday SQL - Marketing Performance Exercises
-- Nigerian E-commerce Marketing Analytics

============================================================================
EXERCISE 1: Marketing Channel Performance Analysis (25 minutes)
============================================================================

Scenario: You are analyzing marketing performance for Konga Nigeria's Q1 2018 campaign.
Your manager wants to understand which marketing channels are performing best.

Tasks:
1. Calculate the total number of MQLs by origin channel
2. Calculate the conversion rate (MQL → Closed Deal) by channel
3. Calculate the average revenue per closed deal by channel
4. Rank channels by overall performance (considering both volume and revenue)

Requirements:
- Use appropriate joins
- Handle cases where channels have MQLs but no closed deals
- Format percentages to 2 decimal places
- Include channels with at least 50 MQLs for statistical significance

-- Write your query below:


============================================================================
EXERCISE 2: Marketing Funnel Time Analysis (20 minutes)
============================================================================

Scenario: The marketing team wants to understand the time it takes for leads to convert
through the funnel to optimize follow-up strategies.

Tasks:
1. Calculate average time from first contact to closed deal by origin channel
2. Identify the top 3 fastest-converting business segments
3. Calculate conversion velocity by month (how quickly leads in each month convert)
4. Find any seasonal patterns in conversion times

Requirements:
- Use date functions appropriately
- Handle cases where leads haven't converted yet
- Present results in days (not timestamps)
- Consider only leads that have actually converted

-- Write your query below:


============================================================================
EXERCISE 3: Landing Page Performance Optimization (25 minutes)
============================================================================

Scenario: You need to analyze landing page performance to recommend which pages should
be optimized or discontinued.

Tasks:
1. Calculate conversion rate by landing page (minimum 20 MQLs)
2. Identify top and bottom performing landing pages
3. Analyze landing page performance by traffic source
4. Recommend 3 landing pages for optimization based on potential impact

Requirements:
- Use window functions for ranking
- Calculate potential revenue impact of optimization
- Consider both conversion rate and volume
- Exclude landing pages with very low traffic

-- Write your query below:


============================================================================
EXERCISE 4: Query Performance Optimization (30 minutes)
============================================================================

Scenario: Your team is experiencing slow query performance on marketing reports.
You need to optimize the following complex query:

-- SLOW QUERY TO OPTIMIZE:
SELECT
    m.origin,
    DATE_TRUNC('month', m.first_contact_date) as month,
    COUNT(DISTINCT m.mql_id) as total_mqls,
    COUNT(DISTINCT d.mql_id) as converted_mqls,
    (SELECT AVG(declared_monthly_revenue)
     FROM olist_marketing_data_set.olist_closed_deals_dataset d2
     WHERE d2.mql_id IN (SELECT mql_id FROM olist_marketing_data_set.olist_marketing_qualified_leads_dataset WHERE origin = m.origin)) as avg_revenue,
    ROUND(COUNT(DISTINCT d.mql_id)::DECIMAL / COUNT(DISTINCT m.mql_id) * 100, 2) as conversion_rate
FROM olist_marketing_data_set.olist_marketing_qualified_leads_dataset m
LEFT JOIN olist_marketing_data_set.olist_closed_deals_dataset d ON m.mql_id = d.mql_id
WHERE m.first_contact_date >= '2018-01-01'
GROUP BY m.origin, DATE_TRUNC('month', m.first_contact_date)
ORDER BY month DESC, total_mqls DESC;

Tasks:
1. Identify performance bottlenecks in the query
2. Rewrite the query using better SQL patterns
3. Create appropriate indexes to support this query
4. Explain why your optimized version will perform better

Requirements:
- Eliminate subqueries where possible
- Use CTEs for better readability and potential performance
- Create specific indexes that would help this query
- Explain your optimization strategy

-- Write your optimized query below:


-- Write your index creation statements below:


============================================================================
EXERCISE 5: Advanced Marketing Analytics (20 minutes)
============================================================================

Scenario: The CMO wants a comprehensive view of marketing ROI including lead quality
and business segment performance.

Tasks:
1. Create a comprehensive marketing performance dashboard showing:
   - Channel performance by business segment
   - Lead quality scores based on conversion and revenue
   - Month-over-month growth trends
   - Top performing combinations of channel and segment

Requirements:
- Use multiple CTEs to build the analysis step by step
- Create a scoring system for lead quality (0-100)
- Show month-over-month percentage changes
- Rank channel-segment combinations by overall performance score

-- Write your query below:


============================================================================
BONUS CHALLENGE: Real-time Marketing Alert System (15 minutes)
============================================================================

Scenario: Create a query that identifies marketing performance issues that need
immediate attention from the marketing team.

Tasks:
1. Identify channels with conversion rates below 5%
2. Find landing pages with declining performance (consecutive months)
3. Detect unusual drops in MQL volume (more than 30% drop month-over-month)
4. Flag business segments with unusually low revenue per deal

Requirements:
- Use window functions for trend analysis
- Create alerts with specific thresholds
- Provide actionable recommendations for each alert
- Format results for easy consumption by marketing team

-- Write your alert query below:


============================================================================
SUBMISSION INSTRUCTIONS
============================================================================

1. Save your completed exercises as: `thur_marketing_performance_solution_[your_name].sql`
2. Include comments explaining your approach for each exercise
3. Test each query for correctness and performance
4. Be prepared to explain your optimization strategies
5. Focus on both correctness and query efficiency

Good luck! Remember to think about the Nigerian e-commerce context and
provide actionable business insights from your analysis.