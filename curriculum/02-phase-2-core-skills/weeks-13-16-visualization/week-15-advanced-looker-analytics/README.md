# Week 15: Advanced Analytics in Looker Studio

## November 26-27, 2025

**Business Scenario:** Executive KPI Dashboard - Applying Week 11-12 marketing and financial metrics

---

## Learning Objectives

By the end of this week, students will be able to:

- Build advanced formulas using nested functions
- Create period-over-period comparisons
- Implement statistical calculations in Looker Studio
- Design custom business metrics from multiple fields
- Create narrative-driven dashboards
- Implement progressive disclosure of information
- Add annotations and context for business users

---

## Wednesday Session: Complex Calculated Fields (2 hours)

### Hour 1: Advanced Functions (60 min)

| Time | Topic | Prior Knowledge Connection |
|------|-------|---------------------------|
| 0-15 | Nested CASE statements | Week 3: Complex CASE logic |
| 15-30 | String functions for categorization | Week 6: Text processing |
| 30-45 | Date-based calculated fields | Week 5: Date calculations |
| 45-60 | Mathematical functions for KPIs | Week 12: Statistical analysis |

### Hour 2: Business Metrics (60 min)

| Time | Topic | Prior Knowledge Connection |
|------|-------|---------------------------|
| 0-20 | Period comparison calculations | Week 12: Cohort analysis |
| 20-40 | Running totals and cumulative metrics | Week 9: Window functions |
| 40-55 | Custom aggregation logic | Week 4: Advanced aggregations |
| 55-60 | Practice: Build marketing metrics | Week 11: Marketing KPIs |

### Wednesday Practical Exercise

Create calculated fields for executive reporting:
- Month-over-month revenue growth percentage
- Year-to-date cumulative revenue
- Average order value trends
- Customer acquisition cost (CAC)
- Customer lifetime value (from Week 9 CLV calculations)

---

## Thursday Session: Data Storytelling Techniques (2 hours)

### Hour 1: Narrative Dashboard Design (60 min)

| Time | Topic | Prior Knowledge Connection |
|------|-------|---------------------------|
| 0-15 | Storytelling principles for data | New visualization skill |
| 15-30 | Progressive disclosure techniques | New visualization skill |
| 30-45 | Annotation and commentary features | New visualization skill |
| 45-60 | Building executive summaries | Week 12: Executive reporting |

### Hour 2: Actionable Insights (60 min)

| Time | Topic | Prior Knowledge Connection |
|------|-------|---------------------------|
| 0-20 | Highlighting insights and anomalies | Week 10: Data quality checks |
| 20-35 | Recommendation integration | Week 11: Marketing optimization |
| 35-50 | Call-to-action design | New visualization skill |
| 50-60 | Practice: Create executive summary page | Integration practice |

### Thursday Practical Exercise

Build a data story dashboard for marketing performance:
- Executive summary with key insights at top
- Trend analysis with annotated events
- Anomaly highlighting (unusually high/low performance)
- Recommendations section with action items

---

## Advanced Calculated Field Examples

### Revenue Growth (Period over Period)
```
CASE
  WHEN Revenue_Previous_Period > 0
  THEN (Revenue_Current_Period - Revenue_Previous_Period) / Revenue_Previous_Period * 100
  ELSE NULL
END
```

### CLV Tier Classification (from Week 9)
```
CASE
  WHEN Total_Revenue >= 500000 THEN "VIP Champion"
  WHEN Total_Revenue >= 200000 THEN "Loyal Customer"
  WHEN Total_Revenue >= 50000 THEN "Growing Customer"
  ELSE "New Customer"
END
```

### RFM Score Concatenation (from Week 9)
```
CONCAT(
  CAST(Recency_Score AS TEXT),
  CAST(Frequency_Score AS TEXT),
  CAST(Monetary_Score AS TEXT)
)
```

### Delivery Performance Category
```
CASE
  WHEN Delivery_Days <= 3 THEN "Express"
  WHEN Delivery_Days <= 7 THEN "Standard"
  WHEN Delivery_Days <= 14 THEN "Delayed"
  ELSE "Critical Delay"
END
```

### Marketing ROI Calculation
```
(Revenue_From_Campaign - Campaign_Cost) / Campaign_Cost * 100
```

---

## Data Storytelling Framework

| Dashboard Section | Purpose | Design Element |
|-------------------|---------|----------------|
| Executive Summary | Quick overview | Scorecards + key insight text |
| What Happened | Facts and trends | Time series with annotations |
| Why It Matters | Context and impact | Comparison charts |
| What To Do | Recommendations | Action items list |

---

## Progressive Disclosure Pattern

```
Dashboard Layout:
├── Level 1: Executive Summary (Always Visible)
│   └── 3-4 KPI scorecards with trend indicators
│
├── Level 2: Key Trends (Scrollable)
│   └── Time series showing performance over time
│
├── Level 3: Detailed Analysis (On Demand)
│   └── Tables and breakdowns by segment
│
└── Level 4: Raw Data (Link to Explore)
    └── Option to export or drill into details
```

---

## Annotation Best Practices

### When to Annotate
- Major events (campaigns, holidays, product launches)
- Anomalies (unexpected spikes or drops)
- Targets and goals
- Period comparisons

### Annotation Types
- **Text boxes:** Static explanations
- **Reference lines:** Target values
- **Highlighted regions:** Date ranges of interest
- **Tooltips:** Contextual information on hover

---

## Datasets Used

All Olist tables plus marketing dataset:
```sql
-- Sales data
olist_sales_data_set.olist_orders_dataset
olist_sales_data_set.olist_order_items_dataset
olist_sales_data_set.olist_customers_dataset

-- Marketing data (from Week 11)
olist_marketing_data_set.olist_marketing_qualified_leads_dataset
olist_marketing_data_set.olist_closed_deals_dataset
```

---

## Exercises

### Exercise 1: Advanced Calculated Fields (In-class)
Create the following calculated fields:
1. CLV tier classification (from Week 9 definitions)
2. Month-over-month growth percentage
3. RFM score concatenation
4. Delivery performance category
5. Marketing ROI calculation

### Exercise 2: Marketing Performance Dashboard (Take-home)
Apply Week 11 marketing metrics to Looker Studio:
1. Marketing funnel visualization
2. Conversion rate by channel
3. Campaign performance comparison
4. Add annotations for campaign launch dates
5. Include recommendations section

---

## Key Metrics from Prior Weeks

### From Week 9 (CLV/RFM):
- Customer Lifetime Value
- Recency Score
- Frequency Score
- Monetary Score
- Customer Segment

### From Week 11 (Marketing):
- Lead Conversion Rate
- Customer Acquisition Cost (CAC)
- Marketing Qualified Leads (MQL)
- Sales Qualified Leads (SQL)
- Campaign ROI

### From Week 12 (Financial):
- Gross Revenue
- Net Revenue
- Average Order Value
- Revenue Growth Rate
- Profit Margin

---

## Resources

- `lecture-materials/`: Advanced function reference
- `resources/`: Data Storytelling Template
- `resources/`: Marketing Metrics Calculation Guide
- `resources/`: Advanced Functions Reference Guide

---

## Key Concepts

### Nested Functions
Combining multiple functions within a single calculated field for complex logic.

### Period Comparison
Calculating change between time periods (MoM, YoY, WoW).

### Data Storytelling
Designing dashboards that guide users through insights in a logical narrative flow.

### Actionable Insights
Presenting data in a way that suggests clear next steps for the viewer.

---

## Success Criteria

By end of Week 15, students should be able to:
- [ ] Create at least 3 complex calculated fields with nested logic
- [ ] Build period-over-period comparison metrics
- [ ] Design a dashboard with clear narrative flow
- [ ] Add annotations to highlight key events and anomalies
- [ ] Include an actionable recommendations section

---

*Week 15 elevates dashboards from data display to strategic communication tools. Focus on telling compelling stories with data that drive business decisions.*
