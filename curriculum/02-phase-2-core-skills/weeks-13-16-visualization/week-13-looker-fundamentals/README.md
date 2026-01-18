# Week 13: Looker Studio Fundamentals

## November 12-13, 2025

**Business Scenario:** Sales Performance Dashboard - Translating SQL aggregation insights to visual format

---

## Learning Objectives

By the end of this week, students will be able to:

- Connect Looker Studio to Supabase PostgreSQL database
- Understand data source configuration and refresh settings
- Create calculated fields using familiar SQL-like syntax
- Select appropriate chart types for different data stories
- Apply design principles for effective data communication
- Create mobile-responsive dashboard layouts

---

## Wednesday Session: Data Connection & Preparation (2 hours)

### Hour 1: Data Connections (60 min)

| Time | Topic | Prior Knowledge Connection |
|------|-------|---------------------------|
| 0-15 | Platform introduction and navigation | New tool orientation |
| 15-30 | PostgreSQL connector setup for Supabase | Week 1: Database concepts |
| 30-45 | Custom SQL queries as data source | Weeks 1-8: SQL query writing |
| 45-60 | Data source configuration (refresh, caching) | Week 11: Performance concepts |

### Hour 2: Calculated Fields (60 min)

| Time | Topic | Prior Knowledge Connection |
|------|-------|---------------------------|
| 0-20 | Creating calculated fields (metrics) | Week 3: Calculated columns |
| 20-40 | CASE statements for categorization | Week 3: CASE statements in SQL |
| 40-55 | Date functions and formatting | Week 5: DateTime operations |
| 55-60 | Practice: Create revenue calculations | Week 4: Aggregations |

### Wednesday Practical Exercise

Create a data source from the Olist orders dataset with calculated fields for:
- **Total order value:** `price + freight_value`
- **Order year/month:** Extract using date functions
- **Delivery time:** `delivery_date - purchase_date` in days
- **Customer tier:** Classification using CASE statements

---

## Thursday Session: Basic Visualization Design (2 hours)

### Hour 1: Chart Types and Selection (60 min)

| Time | Topic | Prior Knowledge Connection |
|------|-------|---------------------------|
| 0-15 | Overview of 17+ chart types | Python matplotlib concepts |
| 15-30 | Scorecards for KPIs | Week 4: Aggregation metrics |
| 30-45 | Time series charts | Week 5: Time-based analysis |
| 45-60 | Tables and pivot tables | Week 9: Pivot tables in Python |

### Hour 2: Design Principles (60 min)

| Time | Topic | Prior Knowledge Connection |
|------|-------|---------------------------|
| 0-20 | Dashboard layout organization | New visualization skill |
| 20-35 | Color theory and branding | New visualization skill |
| 35-50 | Accessibility considerations | New visualization skill |
| 50-60 | Mobile-responsive design | New visualization skill |

### Thursday Practical Exercise

Build a basic sales overview dashboard including:
- **Scorecard:** Total Revenue (from Week 4 aggregations)
- **Time series:** Monthly sales trend (from Week 5 date analysis)
- **Bar chart:** Sales by product category (from Week 4 GROUP BY)
- **Table:** Top 10 products by revenue (from Week 3 ORDER BY)

---

## SQL-to-Looker-Studio Mapping

| SQL Concept (Weeks 1-8) | Looker Studio Equivalent |
|-------------------------|--------------------------|
| `SELECT col1, col2` | Add dimensions to chart |
| `SUM(price)` | Create metric with SUM aggregation |
| `CASE WHEN...THEN...END` | Calculated field with CASE |
| `EXTRACT(MONTH FROM date)` | Date functions in calculated fields |
| `WHERE condition` | Filters on data source or chart |
| `GROUP BY category` | Dimension grouping in charts |

---

## Chart Selection Guide

| Business Question | Recommended Chart | SQL Query Pattern |
|-------------------|-------------------|-------------------|
| "What is total revenue?" | Scorecard | `SUM(price)` |
| "How are sales trending?" | Time Series | `GROUP BY month` |
| "Which category sells most?" | Bar Chart | `GROUP BY category` |
| "What are top products?" | Table with sorting | `ORDER BY revenue DESC` |
| "What's the geographic distribution?" | Geo Map | `GROUP BY state` |
| "What's the proportion by segment?" | Pie Chart | `GROUP BY segment` |

---

## Datasets Used

```sql
-- Primary data source
olist_sales_data_set.olist_orders_dataset
olist_sales_data_set.olist_order_items_dataset
olist_sales_data_set.olist_customers_dataset
```

---

## Exercises

### Exercise 1: Data Source Setup (Take-home)
Connect to Supabase and create calculated fields:
1. Total order value (price + freight)
2. Delivery time in days
3. Order status category (on-time, late, pending)

### Exercise 2: Basic Dashboard (In-class)
Recreate Week 4 SQL aggregation results as Looker Studio charts:
- Scorecards: Total Revenue, Order Count, Average Order Value
- Bar chart: Sales by customer state

---

## Resources

- `lecture-materials/`: Connection guides and chart type reference
- `resources/`: Looker Studio Quick Reference Guide
- `resources/`: SQL-to-Looker-Studio Translation Cheatsheet

---

## Key Concepts

### Data Source Types
1. **Direct Connection:** Real-time data from PostgreSQL
2. **Extract:** Snapshot of data (faster performance)
3. **Blended Source:** Combined multiple data sources (Week 14)

### Calculated Field Types
1. **Data Source Level:** Reusable across all charts
2. **Chart Level:** Specific to individual charts

### Chart Categories
- **Tabular:** Tables, Pivot Tables
- **Metric:** Scorecards, Gauges, Bullets
- **Time-Based:** Time Series, Area Charts
- **Comparison:** Bar, Column, Waterfall
- **Proportion:** Pie, Treemap, Sankey
- **Geographic:** Geo Maps (Bubble, Filled, Heat)

---

## Success Criteria

By end of Week 13, students should be able to:
- [ ] Successfully connect to Supabase PostgreSQL from Looker Studio
- [ ] Create at least 3 calculated fields using SQL-like syntax
- [ ] Build a dashboard with 4+ charts of different types
- [ ] Apply basic design principles (layout, colors, fonts)
- [ ] Explain why specific chart types were chosen

---

*Week 13 establishes the foundation for all subsequent visualization work. Focus on understanding data connections and basic chart creation before moving to advanced features.*
