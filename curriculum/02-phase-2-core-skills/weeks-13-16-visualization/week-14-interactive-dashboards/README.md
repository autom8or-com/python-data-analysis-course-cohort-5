# Week 14: Interactive Dashboards

## November 19-20, 2025

**Business Scenario:** Customer Analytics Dashboard - Building on Week 9's CLV analysis

---

## Learning Objectives

By the end of this week, students will be able to:

- Implement interactive controls (filters, date ranges, parameters)
- Configure filter relationships between charts
- Apply conditional formatting for data highlighting
- Master time series visualization best practices
- Design effective page layouts for business users
- Implement navigation for multi-page reports
- Optimize dashboard performance

---

## Wednesday Session: Advanced Chart Configuration (2 hours)

### Hour 1: Interactive Controls (60 min)

| Time | Topic | Prior Knowledge Connection |
|------|-------|---------------------------|
| 0-15 | Date range controls setup | Week 5: Date filtering |
| 15-30 | Drop-down filters for dimensions | Week 2: WHERE clauses |
| 30-45 | Filter relationships (cross-filtering) | Week 8: Multiple conditions |
| 45-60 | Parameters for dynamic calculations | Week 3: CASE statements |

### Hour 2: Advanced Formatting (60 min)

| Time | Topic | Prior Knowledge Connection |
|------|-------|---------------------------|
| 0-20 | Conditional formatting rules | Excel conditional formatting |
| 20-40 | Time series best practices | Week 5: Time analysis |
| 40-55 | Chart interactions and drill-down | New visualization skill |
| 55-60 | Practice: Add interactivity to Week 13 dashboard | Integration practice |

### Wednesday Practical Exercise

Enhance the sales dashboard with:
- Date range selector (default: last 90 days)
- Product category dropdown filter
- Customer state filter
- Conditional formatting on metrics (red/yellow/green thresholds)

---

## Thursday Session: Dashboard Layout & UX Design (2 hours)

### Hour 1: Layout and Navigation (60 min)

| Time | Topic | Prior Knowledge Connection |
|------|-------|---------------------------|
| 0-20 | Page layout principles (F-pattern, Z-pattern) | New visualization skill |
| 20-35 | Multi-page report navigation | New visualization skill |
| 35-50 | Header/footer design and branding | New visualization skill |
| 50-60 | Section organization with containers | New visualization skill |

### Hour 2: Performance and Collaboration (60 min)

| Time | Topic | Prior Knowledge Connection |
|------|-------|---------------------------|
| 0-15 | Performance optimization techniques | Week 11: Query optimization |
| 15-30 | Data caching strategies | New visualization skill |
| 30-45 | Sharing permissions and access control | New visualization skill |
| 45-60 | Version history and change management | Git concepts |

### Thursday Practical Exercise

Create a multi-page Customer Analytics dashboard:
- **Page 1: Overview** - KPI scorecards, trends
- **Page 2: Customer Segments** - RFM visualization (from Week 9)
- **Page 3: Geographic Analysis** - Regional performance maps
- Add navigation menu and consistent branding

---

## Control Types Reference

| User Need | Control Type | Implementation |
|-----------|--------------|----------------|
| Select time period | Date Range Control | Calendar with presets (Last 7 days, Last month, etc.) |
| Filter by category | Drop-down List | Dimension-based single/multi-select |
| Filter by region | Fixed-size List | Visible multi-select options |
| Search for customer | Input Box | Text search filter |
| Filter by price range | Slider | Numeric range selection |
| Toggle feature on/off | Checkbox | Boolean selection |

---

## Date Range Options

### Fixed Date Ranges
- Specific start and end dates
- Use for historical reports

### Rolling Date Ranges
- Relative to today (Last 7 days, Last 30 days, Last quarter)
- Updates automatically

### Advanced Date Ranges
- Custom formulas (Today minus X days)
- Comparison periods (This month vs last month)

---

## Multi-Page Dashboard Structure Template

```
Customer Analytics Dashboard
├── Page 1: Executive Summary
│   ├── KPI Row (4 scorecards)
│   │   ├── Total Revenue
│   │   ├── Total Customers
│   │   ├── Average Order Value
│   │   └── Customer Satisfaction
│   ├── Trend Chart (time series)
│   └── Category Breakdown (bar chart)
│
├── Page 2: Customer Segmentation
│   ├── RFM Distribution (treemap)
│   ├── Segment Details (table)
│   │   ├── Champions
│   │   ├── Loyal Customers
│   │   ├── At Risk
│   │   └── Lost Customers
│   └── CLV by Segment (bar chart)
│
└── Page 3: Regional Performance
    ├── State Map (geo chart)
    ├── Regional Metrics (pivot table)
    └── State Comparison (bar chart)
```

---

## Filter Scope Configuration

| Scope | Description | Use Case |
|-------|-------------|----------|
| Report Level | Applies to all pages and charts | Global date range |
| Page Level | Applies to current page only | Page-specific context |
| Chart Level | Applies to single chart | Specific comparison |

---

## Datasets Used

Same as Week 13, plus customer segmentation data from Week 9 analysis:
```sql
-- Primary sources
olist_sales_data_set.olist_orders_dataset
olist_sales_data_set.olist_customers_dataset

-- For segmentation (from Week 9 analysis)
-- CLV calculations
-- RFM scores
```

---

## Exercises

### Exercise 1: Interactive Controls (In-class)
Add interactivity to Week 13 dashboard:
1. Date range control with rolling 90-day default
2. Product category dropdown filter
3. Customer state multi-select filter
4. Configure cross-filtering between charts
5. Test filter combinations and verify data accuracy

### Exercise 2: Multi-Page Dashboard (Take-home)
Create a 3-page customer analytics dashboard:
1. Executive Summary page with KPIs
2. Customer Segmentation page (using Week 9 RFM concepts)
3. Geographic Analysis page with state map
4. Implement navigation menu
5. Apply consistent branding (colors, fonts, logo)

---

## Performance Best Practices

### Do's
- Limit filters to 3-5 per page
- Place controls logically near related charts
- Use date filters at data source level for efficiency
- Test with expected data volumes

### Don'ts
- Overload pages with too many charts
- Use complex calculated fields in every chart
- Ignore mobile responsiveness
- Skip filter scope configuration

---

## Resources

- `lecture-materials/`: Control configuration guides
- `resources/`: Dashboard Design Best Practices Guide
- `resources/`: Control Types Reference Sheet

---

## Key Concepts

### Cross-Filtering
When a user clicks on a chart element (bar, slice), other charts on the page automatically filter to show related data.

### Filter Groups
Controls that work together to provide coordinated filtering across multiple charts.

### Responsive Design
Dashboard layouts that automatically adjust for desktop, tablet, and mobile viewing.

---

## Success Criteria

By end of Week 14, students should be able to:
- [ ] Add at least 3 interactive controls to a dashboard
- [ ] Configure cross-filtering between charts
- [ ] Create a multi-page report with navigation
- [ ] Apply conditional formatting to highlight key metrics
- [ ] Optimize dashboard performance for user experience

---

*Week 14 transforms static dashboards into interactive analytics tools. Focus on user experience and making data exploration intuitive for business users.*
