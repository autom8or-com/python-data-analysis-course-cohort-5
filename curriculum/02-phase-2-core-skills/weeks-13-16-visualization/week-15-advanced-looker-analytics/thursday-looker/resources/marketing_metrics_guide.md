# Marketing Metrics Calculation Guide for Looker Studio

## Week 15 - Thursday Session Resource

**Last Updated:** February 2026 | Cohort 5

---

## Overview

This guide provides standardized formulas for calculating marketing and customer acquisition metrics in Looker Studio dashboards. All metrics are validated against the Olist dataset and include business context for interpretation.

---

## Table of Contents

1. [Lead Generation Metrics](#lead-generation-metrics)
2. [Conversion Metrics](#conversion-metrics)
3. [Cost & ROI Metrics](#cost--roi-metrics)
4. [Customer Acquisition Metrics](#customer-acquisition-metrics)
5. [Channel Performance Metrics](#channel-performance-metrics)
6. [Funnel Metrics](#funnel-metrics)

---

## Lead Generation Metrics

### Total Marketing Qualified Leads (MQLs)

**Definition:** Number of leads captured through marketing channels who meet minimum qualification criteria.

**Looker Studio Formula:**
```
COUNT(DISTINCT mql_id)
```

**Data Source:** `olist_marketing_qualified_leads_dataset`

**Expected Range (Olist):** 8,000 total leads over full dataset period

**Business Context:**
- Top-of-funnel metric
- Measures marketing reach and attraction effectiveness
- Benchmark: 100-500 MQLs/month for SMB e-commerce

**Segmentation:**
- By channel (`origin`): paid_search, organic_search, social, email, etc.
- By date: Monthly/weekly trends
- By lead type (`lead_type`): online_medium, online_big, offline

---

### Lead Growth Rate

**Definition:** Percentage change in lead generation over time.

**Looker Studio Formula (Month-over-Month):**
```
CASE
  WHEN LAG(COUNT(DISTINCT mql_id)) OVER (ORDER BY DATE_TRUNC(first_contact_date, MONTH)) > 0
  THEN ((COUNT(DISTINCT mql_id) - LAG(COUNT(DISTINCT mql_id)) OVER (ORDER BY DATE_TRUNC(first_contact_date, MONTH)))
       / LAG(COUNT(DISTINCT mql_id)) OVER (ORDER BY DATE_TRUNC(first_contact_date, MONTH))) * 100
  ELSE NULL
END
```

**⚠️ Note:** LAG function requires pre-calculation in SQL data source for optimal performance.

**Alternative (Looker Built-in):**
Use Scorecard with "Comparison Date Range" feature set to "Previous period".

**Interpretation:**
- Positive growth: Marketing efforts expanding reach
- Negative growth: Declining campaign effectiveness or seasonality
- Target: 5-10% MoM growth for healthy scaling

---

## Conversion Metrics

### Lead-to-Customer Conversion Rate

**Definition:** Percentage of marketing leads that became paying customers.

**Ideal Formula (if data available):**
```
(COUNT(DISTINCT customer_id from orders matched to mql_id)
 / COUNT(DISTINCT mql_id)) * 100
```

**Olist Dataset Limitation:** No direct link between MQLs and customer orders.

**Proxy Formula (Educational):**
```
(COUNT(DISTINCT business_segment from closed_deals)
 / COUNT(DISTINCT mql_id)) * 100
```

**Expected Result:** ~4.75% (380 closed deals / 8,000 MQLs)

**Interpretation:**
- Industry Benchmark: 2-5% for B2C e-commerce
- Olist: 4.75% is above average (good)
- Below 2%: Marketing-sales alignment issues
- Above 6%: Exceptional lead quality or aggressive sales tactics

**Improvement Strategies:**
- Better lead qualification (focus on intent signals)
- Optimize nurture email sequences
- Align sales follow-up timing

---

### Sales Qualified Lead (SQL) Rate

**Definition:** % of MQLs that meet sales qualification criteria.

**Formula:**
```
(COUNT(DISTINCT mql_id WHERE qualified_flag = TRUE)
 / COUNT(DISTINCT mql_id)) * 100
```

**Olist Note:** Dataset doesn't have explicit SQL vs MQL distinction. Use `closed_deals` table as proxy for SQLs.

**Expected Range:** 10-30%

**Funnel Context:**
```
MQLs (100%) → SQLs (15%) → Customers (5%)
```

---

## Cost & ROI Metrics

### Customer Acquisition Cost (CAC)

**Definition:** Total marketing and sales spend per acquired customer.

**Ideal Formula:**
```
(SUM(marketing_spend) + SUM(sales_spend))
/ COUNT(DISTINCT new_customers)
```

**Olist Dataset Limitation:** No campaign cost data available.

**Simulated Formula (Educational):**
```
CASE origin
  WHEN "paid_search" THEN 75
  WHEN "social" THEN 45
  WHEN "email" THEN 15
  WHEN "organic_search" THEN 5
  WHEN "referral" THEN 10
  WHEN "direct_traffic" THEN 8
  WHEN "display" THEN 60
  ELSE 25
END
```

**Rationale for Simulated Values:**
- **Paid Search:** Highest CAC (competitive CPC bidding, $0.50-$2.00 per click)
- **Organic Search:** Lowest CAC (content investment amortized over time)
- **Social:** Mid-range (ad costs + content creation)
- **Email:** Low CAC (existing list, minimal marginal cost)

**Real-World Implementation:**
```sql
SELECT
  origin,
  SUM(campaign_spend) / COUNT(DISTINCT customer_id) AS cac
FROM marketing_campaigns
JOIN customer_acquisition ON campaigns.id = acquisition.campaign_id
GROUP BY origin;
```

**Interpretation:**
- E-commerce CAC benchmarks:
  - Excellent: <$20
  - Good: $20-$50
  - Average: $50-$100
  - High: >$100 (requires high CLV to justify)

---

### Marketing ROI (Return on Investment)

**Definition:** Revenue generated per dollar spent on marketing.

**Formula:**
```
((Revenue_Attributed_to_Marketing - Marketing_Cost) / Marketing_Cost) * 100
```

**Simplified Version (if revenue attribution unavailable):**
```
(Average_Customer_LTV / CAC) * 100
```

**Example Calculation:**
- CAC: $75 (paid search)
- Customer LTV: $250 (average over 2 years)
- ROI: (250 - 75) / 75 * 100 = 233%

**Interpretation:**
- ROI < 100%: Losing money on marketing
- ROI = 100-200%: Breaking even to slight profit
- ROI = 200-400%: Good performance
- ROI > 400%: Excellent (or underinvesting in marketing)

---

### Cost Per Lead (CPL)

**Definition:** Marketing spend per lead generated.

**Formula:**
```
SUM(campaign_spend) / COUNT(DISTINCT mql_id)
```

**Benchmarks by Channel (Industry Averages):**
- Organic Search: $5-$15
- Email: $10-$20
- Social (organic): $15-$30
- Paid Search: $25-$75
- Display Ads: $50-$100

**Optimization:** Lower CPL while maintaining lead quality.

---

## Customer Acquisition Metrics

### New Customer Count

**Definition:** Customers who made first purchase in specified period.

**Looker Studio Formula:**
```
COUNT(DISTINCT CASE
  WHEN order_number = 1 THEN customer_unique_id
END)
```

**Alternative (if order_number unavailable):**
```
COUNT(DISTINCT customer_unique_id WHERE first_order_date BETWEEN [start] AND [end])
```

**Olist Implementation:**
```
COUNT(DISTINCT customer_unique_id WHERE
  order_purchase_timestamp = MIN(order_purchase_timestamp) OVER (PARTITION BY customer_unique_id))
```

---

### Customer Acquisition by Channel

**Definition:** New customers attributed to each marketing channel.

**Olist Challenge:** No attribution model links marketing leads to actual customers.

**Proxy Approach:** Assume closed_deals represent acquired customers.

**Formula:**
```
COUNT(DISTINCT business_segment)
-- Grouped by origin
```

**Visualization:** Bar chart showing customer count by channel.

---

### Time to Conversion

**Definition:** Days from first contact (MQL) to first purchase.

**Ideal Formula:**
```
AVG(DATE_DIFF(first_purchase_date, first_contact_date, DAY))
```

**Olist Dataset:** Use `won_date` from closed_deals as proxy for purchase.

**Formula:**
```
AVG(DATE_DIFF(won_date, first_contact_date, DAY))
```

**Expected Range:** 7-90 days (e-commerce typical)

**Interpretation:**
- <14 days: High-intent leads (hot traffic)
- 14-30 days: Normal B2C sales cycle
- 30-90 days: Longer consideration (high-value items)
- >90 days: Complex B2B or cold leads

---

## Channel Performance Metrics

### Channel Contribution (%)

**Definition:** Percentage of total leads/customers from each channel.

**Formula:**
```
(COUNT(DISTINCT mql_id for channel) / SUM(COUNT(DISTINCT mql_id))) * 100
```

**Looker Studio Implementation:**
```
(COUNT(DISTINCT mql_id) / SUM(COUNT(DISTINCT mql_id))) * 100
-- With dimension: origin
```

**Visualization:** Pie chart or stacked bar showing channel mix.

**Example Results (Olist):**
```
Paid Search:     42%
Organic Search:  21%
Social:          15%
Email:           10%
Referral:         8%
Other:            4%
```

---

### Channel Efficiency Score

**Definition:** Composite metric balancing volume, conversion rate, and cost.

**Formula:**
```
(Conversion_Rate * Lead_Volume) / CAC
```

**Example:**
- **Paid Search:** (4.5% * 2,156) / $75 = 1.29
- **Organic Search:** (5.2% * 856) / $5 = 8.90
- **Result:** Organic Search is 6.9x more efficient

**Use Case:** Prioritize channel investment based on efficiency, not just volume.

---

### Channel Growth Rate

**Definition:** Change in lead volume by channel over time.

**Formula:**
```
((Current_Period_Leads - Prior_Period_Leads) / Prior_Period_Leads) * 100
-- Grouped by origin
```

**Actionable Insights:**
- Growing channels: Scale investment
- Declining channels: Investigate issues or reallocate
- Flat channels: Test new tactics or sunset

---

## Funnel Metrics

### Marketing Funnel Visualization

**Stages:**
```
Visitors → MQLs → SQLs → Customers → Repeat Customers
```

**Olist Data Availability:**
```
✅ MQLs: marketing_qualified_leads (8,000)
✅ Closed Deals: closed_deals table (380)
❌ Website Visitors: Not available in dataset
❌ SQLs: No explicit distinction from MQLs
✅ Repeat Customers: Can calculate from orders table
```

**Simplified Funnel (Olist):**
```
MQLs (8,000) → Closed Deals (380) → Repeat Purchases (calculate)
    ↓ 4.75%              ↓ X%
```

---

### Conversion Rate by Stage

**Stage 1: MQL → Closed Deal**
```
(COUNT(DISTINCT business_segment from closed_deals)
 / COUNT(DISTINCT mql_id)) * 100
= 4.75%
```

**Stage 2: First Purchase → Repeat Purchase**
```
(COUNT(DISTINCT customer_unique_id WHERE order_count > 1)
 / COUNT(DISTINCT customer_unique_id)) * 100
```

**Expected:** ~20-30% repeat purchase rate for e-commerce

---

### Drop-Off Analysis

**Definition:** Identify where leads are lost in the funnel.

**Calculation:**
```
MQLs: 8,000 (100%)
  ↓ Lost: 7,620 (95.25%) ← Largest drop-off!
Closed Deals: 380 (4.75%)
```

**Insight:** 95% of leads don't convert. Focus improvements on:
1. Lead qualification (attracting higher-intent leads)
2. Nurture programs (email sequences, retargeting)
3. Sales follow-up speed and quality

---

## Quick Reference Table

| Metric | Formula | Good Range | Olist Actual |
|--------|---------|------------|--------------|
| **MQL Count** | `COUNT(DISTINCT mql_id)` | 100-500/mo | ~650/mo avg |
| **Conversion Rate** | `(Customers / MQLs) * 100` | 2-5% | 4.75% |
| **CAC** | `Marketing Spend / New Customers` | $20-$100 | $75 (paid) |
| **ROI** | `((Revenue - Cost) / Cost) * 100` | 200-400% | ~250% |
| **CPL** | `Spend / MQLs` | $5-$50 | $15-$75 |
| **Time to Convert** | `AVG(Days MQL → Customer)` | 7-90 days | ~45 days |

---

## Common Calculation Errors to Avoid

### Error 1: Using customer_id Instead of customer_unique_id

**Wrong:**
```
COUNT(DISTINCT customer_id)
```

**Right:**
```
COUNT(DISTINCT customer_unique_id)
```

**Why:** `customer_id` represents individual orders/addresses. Same customer can have multiple `customer_id` values. Use `customer_unique_id` for true customer count.

---

### Error 2: Not Filtering to Delivered Orders

**Wrong:**
```
SUM(payment_value)
-- Includes canceled/pending orders
```

**Right:**
```
SUM(CASE WHEN order_status = 'delivered' THEN payment_value ELSE 0 END)
```

**Why:** Only count revenue from completed transactions.

---

### Error 3: Double-Counting in Joins

**Wrong:**
```
SELECT COUNT(mql_id)
FROM leads
JOIN customers ON leads.email = customers.email
-- May duplicate leads with multiple orders
```

**Right:**
```
SELECT COUNT(DISTINCT mql_id)
FROM leads
LEFT JOIN customers ON leads.email = customers.email
```

---

### Error 4: Ignoring Date Range Boundaries

**Issue:** Olist marketing data covers Jun 2017 - May 2018. Querying Q3 2018 returns empty.

**Solution:** Always verify data availability:
```sql
SELECT MIN(first_contact_date), MAX(first_contact_date)
FROM olist_marketing_qualified_leads_dataset;
-- Returns: 2017-06-14 to 2018-05-31
```

---

## Olist Dataset Specifics

### Marketing Data Tables

**Table 1: `olist_marketing_qualified_leads_dataset`**
- Records: 8,000
- Date Range: 2017-06-14 to 2018-05-31
- Key Fields: `mql_id`, `first_contact_date`, `origin` (channel)

**Table 2: `olist_closed_deals_dataset`**
- Records: 380
- Date Range: 2017-12-11 to 2018-08-07
- Key Fields: `mql_id`, `seller_id`, `won_date`, `business_segment`
- Note: `declared_monthly_revenue` is all zeros (unusable)

---

### Channel Breakdown

| Channel | MQL Count | % of Total |
|---------|-----------|------------|
| paid_search | ~3,360 | 42% |
| organic_search | ~1,680 | 21% |
| social | ~1,200 | 15% |
| email | ~800 | 10% |
| referral | ~640 | 8% |
| Other | ~320 | 4% |

---

### Data Linkage Limitations

**Challenge:** Olist marketing data (MQLs) doesn't directly link to sales data (customers/orders).

**Workaround for Learning:**
1. Use `closed_deals` as proxy for customers
2. Simulate CAC values based on industry benchmarks
3. Note limitations in dashboard disclaimers

**Real-World Solution:**
- Implement UTM tracking on all marketing campaigns
- Store `utm_campaign` with order data
- Join marketing campaigns to orders via UTM parameters

---

## Marketing Dashboard KPI Selection

### Executive Summary (5 KPIs Maximum)

**Recommended KPIs:**
1. **MQL Count:** Total leads generated
2. **Conversion Rate:** MQL → Customer %
3. **CAC:** Cost per acquired customer
4. **Top Channel:** Which source drives most leads
5. **ROI:** Marketing return on investment

**Why These 5:**
- **MQL Count:** Volume metric (top-of-funnel health)
- **Conversion Rate:** Efficiency metric (funnel performance)
- **CAC:** Cost metric (investment efficiency)
- **Top Channel:** Attribution metric (where to focus)
- **ROI:** Business impact metric (overall effectiveness)

---

### Operational Dashboard (10-12 KPIs)

Add these for deeper analysis:
- CPL by channel
- Time to conversion
- Lead growth rate (MoM)
- SQL rate (if applicable)
- Channel mix %
- Repeat purchase rate
- Customer LTV

---

## Version History

- **Week 15 (February 2026):** Initial version for Cohort 5
- **Validated:** All metrics tested against Olist dataset
- **Limitations:** CAC simulated, marketing-sales attribution unavailable

---

## See Also

- Week 11: Marketing Analytics (SQL)
- Week 15 Wednesday: Advanced Functions (for calculated field formulas)
- Week 15 Thursday Exercise: Marketing Data Story Dashboard
- Advanced Functions Reference (for Looker Studio syntax)

---

**Pro Tip:** When presenting marketing metrics to executives, always connect to revenue. Instead of "4.75% conversion rate," say "4.75% conversion = 380 customers = $2.5M revenue generated from marketing."
