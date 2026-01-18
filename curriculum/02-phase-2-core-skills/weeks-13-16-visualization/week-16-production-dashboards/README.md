# Week 16: Production Dashboards & Sharing

## December 3-4, 2025

**Business Scenario:** Client-Ready Dashboard Deployment - Full integration of all prior learning

---

## Learning Objectives

By the end of this week, students will be able to:

- Optimize query performance for production dashboards
- Implement data sampling and aggregation strategies
- Configure caching for improved user experience
- Add error handling and data validation
- Configure sharing permissions and access control
- Embed dashboards in external websites
- Set up scheduled email delivery
- Plan dashboard maintenance and updates

---

## Wednesday Session: Dashboard Optimization & Performance (2 hours)

### Hour 1: Performance Optimization (60 min)

| Time | Topic | Prior Knowledge Connection |
|------|-------|---------------------------|
| 0-20 | Query optimization techniques | Week 11: SQL optimization |
| 20-35 | Data sampling for large datasets | Week 10: Large dataset handling |
| 35-50 | Pre-aggregation strategies | Week 4: Aggregation efficiency |
| 50-60 | Caching configuration | New production skill |

### Hour 2: Data Quality (60 min)

| Time | Topic | Prior Knowledge Connection |
|------|-------|---------------------------|
| 0-15 | Error handling in calculated fields | Week 10: Data integrity |
| 15-30 | Data validation rules | Week 10: Constraint checking |
| 30-45 | Handling null and missing values | Week 2: NULL handling |
| 45-60 | Data freshness monitoring | New production skill |

### Wednesday Practical Exercise

Optimize the executive dashboard for production:
- Implement extract data source (pre-aggregated)
- Configure appropriate refresh schedules
- Add data quality indicators
- Test with realistic data volumes
- Measure and document load times

---

## Thursday Session: Sharing & Collaboration (2 hours)

### Hour 1: Sharing and Permissions (60 min)

| Time | Topic | Prior Knowledge Connection |
|------|-------|---------------------------|
| 0-20 | Permission levels (view, edit, owner) | New production skill |
| 20-35 | Link sharing and access requests | New production skill |
| 35-50 | Scheduled email delivery setup | New production skill |
| 50-60 | PDF export and printing options | New production skill |

### Hour 2: Deployment and Maintenance (60 min)

| Time | Topic | Prior Knowledge Connection |
|------|-------|---------------------------|
| 0-15 | Embedding dashboards in websites | New production skill |
| 15-30 | Integration with Google Sites | New production skill |
| 30-45 | Dashboard maintenance planning | New production skill |
| 45-60 | Documentation and handover | Professional skill |

### Thursday Practical Exercise

Deploy and document the complete dashboard solution:
- Configure appropriate sharing permissions
- Create scheduled weekly email reports
- Generate embed code for portfolio website
- Write dashboard documentation for handover
- Present final dashboard to class

---

## Performance Optimization Checklist

### Data Source Optimization
- [ ] Use custom SQL for pre-aggregation where possible
- [ ] Limit rows in data source for initial development
- [ ] Consider extract vs. live connection trade-offs
- [ ] Remove unused fields from data source

### Dashboard Optimization
- [ ] Limit charts per page (8-10 maximum)
- [ ] Avoid excessive calculated fields per chart
- [ ] Use appropriate date granularity (don't over-detail)
- [ ] Enable data freshness indicators

### Testing
- [ ] Test with expected user concurrency
- [ ] Verify load times are acceptable (<5 seconds)
- [ ] Check mobile responsiveness
- [ ] Validate all calculations with SQL queries

---

## Sharing Configuration Options

| Sharing Method | Use Case | Access Level |
|----------------|----------|--------------|
| View link | External stakeholders | View only |
| Edit access | Team members | Can modify |
| Scheduled email | Executives | Automated delivery |
| Embedded | Website/intranet | Public or restricted |
| PDF download | Offline review | Static snapshot |

---

## Permission Levels

| Level | Capabilities |
|-------|-------------|
| **Viewer** | View dashboard, apply temporary filters |
| **Editor** | Modify charts, add pages, change styling |
| **Owner** | Full control, manage sharing, delete |

---

## Scheduled Email Delivery Setup

### Configuration Options
- **Frequency:** Daily, Weekly, Monthly
- **Time:** Select delivery time (timezone aware)
- **Recipients:** Email addresses or Google Groups
- **Format:** Link to dashboard or PDF attachment
- **Pages:** All pages or selected pages only

### Best Practices
- Schedule for early morning (before meetings)
- Use PDF for executives who prefer printable format
- Include link for interactive exploration
- Test delivery before going live

---

## Embedding Dashboards

### Embed Options
1. **Public Embed:** Anyone with the link can view
2. **Restricted Embed:** Requires Google sign-in
3. **Google Sites Integration:** Native embedding

### Embed Code Example
```html
<iframe
  width="100%"
  height="600"
  src="https://lookerstudio.google.com/embed/reporting/YOUR-REPORT-ID"
  frameborder="0"
  style="border:0"
  allowfullscreen>
</iframe>
```

---

## Dashboard Documentation Template

### 1. Overview
- Dashboard name and purpose
- Target audience
- Key metrics displayed

### 2. Data Sources
- Connection details
- Refresh schedule
- Data freshness expectations

### 3. Calculated Fields
- List of custom calculations
- Business logic explanations
- Formula documentation

### 4. Filters and Controls
- Available filters
- Default settings
- Filter relationships

### 5. Maintenance
- Owner contact information
- Update schedule
- Known limitations

### 6. Troubleshooting
- Common issues and solutions
- Support contact

---

## Final Project Requirements

Students will create a production-ready dashboard incorporating all Month 5 skills:

### Required Elements

#### 1. Data Connection (10%)
- Supabase PostgreSQL with at least 2 Olist tables
- Proper data source configuration
- Documented connection details

#### 2. Calculated Fields (20%)
Minimum 5 custom metrics including:
- CLV calculation (from Week 9)
- Marketing ROI metric (from Week 11)
- Financial KPI (from Week 12)
- Period comparison (MoM or YoY)
- Custom categorization using CASE

#### 3. Visualizations (25%)
Minimum 8 charts across 3+ pages:
- Executive summary scorecards
- Time series trends
- Geographic analysis
- Comparative analysis (bar/column)
- Detailed tables

#### 4. Interactivity (20%)
- Date range control
- At least 2 dimension filters
- Cross-chart filtering
- Drill-down capability

#### 5. Design (15%)
- Consistent branding and colors
- Mobile-responsive layout
- Clear navigation
- Professional typography

#### 6. Sharing & Documentation (10%)
- Configured permissions
- Scheduled email report
- Embed-ready configuration
- Written documentation

---

## Evaluation Criteria

| Criteria | Weight | Assessment Areas |
|----------|--------|------------------|
| Data Accuracy | 25% | Correct calculations, valid queries, data quality |
| Visualization Choice | 20% | Appropriate charts for data stories |
| Interactivity | 20% | User-friendly controls, cross-filtering |
| Design Quality | 15% | Layout, branding, accessibility |
| Performance | 10% | Load time, optimization |
| Documentation | 10% | Clear instructions, maintenance plan |

---

## Exercises

### Exercise 1: Performance Audit (In-class)
1. Evaluate current dashboard load times
2. Identify 3 optimization opportunities
3. Implement at least 2 performance improvements
4. Document before/after performance metrics

### Exercise 2: Production Deployment (Take-home)
1. Configure sharing for stakeholder review
2. Set up scheduled weekly email delivery
3. Generate embed code for portfolio website
4. Create comprehensive documentation
5. Prepare 5-minute presentation for class

---

## Presentation Guidelines

### Format
- 5-minute live demonstration
- Walk through dashboard features
- Highlight key insights
- Explain design decisions

### Evaluation
- Clarity of communication
- Technical accuracy
- Design professionalism
- Audience engagement

---

## Resources

- `lecture-materials/`: Optimization guides
- `resources/`: Performance Optimization Guide
- `resources/`: Sharing & Permissions Reference
- `resources/`: Dashboard Documentation Template
- `resources/`: Final Project Rubric

---

## Key Concepts

### Data Freshness
How recently the data was last updated. Critical for production dashboards.

### Extract vs. Live
- **Extract:** Faster performance, periodic refresh
- **Live:** Real-time data, potential performance impact

### Caching
Storing query results temporarily to improve load times.

### Permissions Inheritance
How access levels cascade from data source to dashboard.

---

## Success Criteria

By end of Week 16, students should be able to:
- [ ] Optimize dashboard performance to <5 second load time
- [ ] Configure sharing with appropriate permission levels
- [ ] Set up scheduled email delivery
- [ ] Create embed code for external websites
- [ ] Write comprehensive dashboard documentation
- [ ] Present dashboard professionally to stakeholders

---

## Month 5 Completion

Upon completing Week 16, students will have:
1. A production-ready business intelligence dashboard
2. Portfolio piece demonstrating visualization skills
3. Documentation suitable for professional handover
4. Presentation experience for stakeholder communication

This dashboard joins the Python and SQL projects from Weeks 1-12 as part of the growing professional portfolio.

---

*Week 16 brings together all visualization skills into a polished, production-ready deliverable. Focus on professional quality and stakeholder-ready presentation.*
