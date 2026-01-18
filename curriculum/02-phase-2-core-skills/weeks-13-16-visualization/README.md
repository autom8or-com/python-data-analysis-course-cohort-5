# Month 5: Data Visualization with Google Looker Studio

## Weeks 13-16 | November 12 - December 4, 2025

**Schedule:** Wednesdays & Thursdays, 2 hours each session
**Platform:** Google Looker Studio (free)
**Data Source:** Supabase PostgreSQL (Olist e-commerce dataset)

---

## Section Overview

Month 5 transforms the SQL and Python analysis skills developed in Weeks 1-12 into professional data visualizations and interactive dashboards. Students will learn to create business intelligence solutions that communicate insights effectively to stakeholders.

This section bridges the gap between data analysis and data communication—a critical skill for any data professional.

---

## Learning Objectives

By the end of Month 5, students will be able to:

- **Connect** Looker Studio to PostgreSQL databases (Supabase)
- **Create** calculated fields using SQL-like syntax they already know
- **Build** interactive dashboards with filters and date controls
- **Blend** multiple data sources for comprehensive reporting
- **Design** effective visualizations following best practices
- **Deploy** and share dashboards for business stakeholders

---

## Prior Knowledge Bridge

This section builds directly on SQL and Python skills from Weeks 1-12:

| Prior Week | Concept | Looker Studio Application |
|------------|---------|---------------------------|
| Week 1 | Database concepts | PostgreSQL connector setup |
| Week 2 | WHERE clauses | Dashboard filters |
| Week 3 | CASE statements, calculated columns | Calculated fields |
| Week 4 | Aggregations (SUM, COUNT, AVG) | Metrics and scorecards |
| Week 5 | DateTime operations | Time series charts, date filters |
| Week 6 | Text processing | String functions in calculated fields |
| Week 7 | JOINs | Data blending |
| Week 8 | Subqueries | Custom SQL data sources |
| Week 9 | CLV/RFM analysis | Customer segmentation dashboards |
| Week 10 | Data quality | Error handling, validation |
| Week 11 | Marketing analytics | Marketing KPI dashboards |
| Week 12 | Financial reporting | Executive KPI dashboards |

---

## Weekly Breakdown

### Week 13: Looker Studio Fundamentals
**November 12-13, 2025**
- Data connection to Supabase PostgreSQL
- Calculated fields using SQL-like syntax
- Basic chart types and when to use them
- Dashboard layout and design principles

### Week 14: Interactive Dashboards
**November 19-20, 2025**
- Interactive controls (filters, date ranges)
- Cross-filtering and chart interactions
- Multi-page report navigation
- Dashboard performance optimization

### Week 15: Advanced Analytics in Looker Studio
**November 26-27, 2025**
- Complex calculated fields (nested CASE, date calculations)
- Period-over-period comparisons
- Data storytelling techniques
- Executive summary design

### Week 16: Production Dashboards & Sharing
**December 3-4, 2025**
- Performance optimization
- Sharing and permissions
- Scheduled email delivery
- Final project presentation

---

## SQL-to-Looker-Studio Translation

Students will leverage their SQL knowledge directly:

| SQL Concept | Looker Studio Equivalent |
|-------------|--------------------------|
| `SELECT col1, col2` | Add dimensions to chart |
| `SUM(price)` | Create metric with SUM aggregation |
| `CASE WHEN...THEN...END` | Calculated field with CASE |
| `EXTRACT(MONTH FROM date)` | Date functions |
| `WHERE condition` | Filters on data source or chart |
| `GROUP BY category` | Dimension grouping in charts |
| `ORDER BY col DESC` | Sorting in tables |
| `JOIN table1 ON...` | Data blending |

---

## Tools & Resources

### Required Tools
- **Google Account** - For Looker Studio access
- **Google Looker Studio** - [lookerstudio.google.com](https://lookerstudio.google.com)
- **Supabase Credentials** - Same as Weeks 1-12 SQL exercises

### Datasets Used
All familiar Olist tables from previous weeks:
```sql
-- Sales data
olist_sales_data_set.olist_orders_dataset
olist_sales_data_set.olist_order_items_dataset
olist_sales_data_set.olist_customers_dataset
olist_sales_data_set.olist_products_dataset
olist_sales_data_set.olist_sellers_dataset
olist_sales_data_set.olist_order_payments_dataset
olist_sales_data_set.olist_order_reviews_dataset

-- Marketing data
olist_marketing_data_set.olist_marketing_qualified_leads_dataset
olist_marketing_data_set.olist_closed_deals_dataset
```

---

## Assessment

### Continuous Assessment (60%)
- Weekly in-class exercises
- Peer review of dashboard designs
- Chart type selection quizzes

### Final Project (40%)
**Comprehensive Business Intelligence Dashboard**

Students will create a production-ready dashboard including:
- Data connection to Supabase with 2+ Olist tables
- Minimum 5 calculated fields (CLV, marketing ROI, financial KPIs)
- Minimum 8 charts across 3+ pages
- Interactive controls (date range, 2+ dimension filters)
- Professional design with consistent branding
- Sharing configuration and scheduled email delivery

---

## Folder Structure

```
weeks-13-16-visualization/
├── README.md (this file)
├── week-13-looker-fundamentals/
│   ├── wednesday-looker/
│   │   ├── exercises/
│   │   ├── lecture-materials/
│   │   ├── resources/
│   │   └── solutions/
│   └── thursday-looker/
│       ├── exercises/
│       ├── lecture-materials/
│       ├── resources/
│       └── solutions/
├── week-14-interactive-dashboards/
│   └── [same structure]
├── week-15-advanced-looker-analytics/
│   └── [same structure]
└── week-16-production-dashboards/
    └── [same structure]
```

---

## Business Context

All examples and exercises maintain the Nigerian e-commerce context established in Weeks 9-12:
- Monetary values displayed in Nigerian Naira (NGN)
- Geographic analysis using Nigerian state equivalents
- Business scenarios reflecting Nigerian market conditions
- Seasonal analysis considering Nigerian holidays

---

## Support Resources

- **Office Hours:** Tuesdays 6-7 PM, Fridays 3-4 PM
- **Peer Study Groups:** Weekends (optional)
- **AI Troubleshooting:** Integrated curriculum for debugging

---

*This section represents the transition from data analysis to data communication—preparing students to deliver actionable insights to business stakeholders.*
