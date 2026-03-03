# Looker Studio Content Developer - Agent Memory

## Content Structure Patterns

### Week Folder Structure (Established from Week 14)
```
week-##-topic-name/
├── README.md (overview with learning objectives, schedule, exercises)
├── validation-report.md (SQL validation from validator agent)
├── wednesday-looker/
│   ├── exercises/ (2 files: wed_week##_exercise_01/02_*.md)
│   ├── lecture-materials/
│   │   └── notebooks/ (4 files: 01-04_*.md, ~15-20 min each)
│   └── resources/ (2 files: reference guides, patterns)
└── thursday-looker/
    ├── exercises/ (2 files: thu_week##_exercise_01/02_*.md)
    ├── lecture-materials/ (4 files: 01-04_*.md)
    └── resources/ (2 files: reference guides, checklists)
```

**Note:** Solutions folder exists but is git-ignored (not created in repo).

### File Naming Conventions
- Lectures: `##_descriptive_topic_name.md` (numbered sequentially)
- Exercises: `{day}_week##_exercise_##_topic.md`
- Resources: `descriptive_name_{type}.md` (e.g., `controls_configuration_guide.md`)

## Content Development Workflow (MANDATORY ORDER)

1. **Inspect Previous Week** - Extract structural template, section patterns, transition language
2. **Fetch Looker Studio Documentation** - Use Context7 for current UI references
3. **Review Supplied Materials** - Validate schema, queries, metrics from validation report
4. **Develop Content** - Follow extracted structure exactly

## Educational Patterns from Week 14

### Lecture Material Structure
Each lecture file (~15-20 min) includes:
1. **Title + Duration** - Clear time expectation
2. **What Is [Concept]?** - Conceptual foundation with business context
3. **Why [Concept] Matters** - Connection to prior SQL/Python work with code comparisons
4. **Core Types/Categories** - Organized breakdown with business use cases
5. **Step-by-Step Implementation** - Numbered instructions with exact UI paths
6. **Screenshot Placeholders** - `[Screenshot: description]` format
7. **Connection to Prior Learning** - Explicit references to specific weeks (e.g., "Week 3: SQL CASE", "Week 9: RFM")
8. **Practical Exercise** - Embedded 5-10 min hands-on task
9. **Common Issues and Solutions** - Troubleshooting table format
10. **Key Takeaways** - Bulleted summary with ✅ checkmarks
11. **What's Next** - Transition to next lecture
12. **Quick Reference Card** - Table summarizing key concepts
13. **Questions to Test Understanding** - 5 questions with answers at end
14. **Additional Resources** - Links to Looker docs, videos, cheat sheets

### Exercise Structure
Exercises (~25-30 min) include:
- **Objective** - Clear learning goal
- **Prerequisites** - Checklist of prior completed work
- **Business Context** - Real-world scenario (Olist e-commerce)
- **Instructions** - Multi-part tasks with subtasks
- **Submission Checklist** - Verification items with ☐ checkboxes
- **Troubleshooting** - Common issues with solutions
- **Expected Outcomes** - Visual mockup of final result
- **How to Know You Succeeded** - Success criteria tests
- **Reflection Questions** - Critical thinking prompts
- **Next Steps** - Clear guidance on what's next
- **Additional Challenge** - Optional advanced tasks

### Resource Documents
- Configuration guides (comprehensive reference tables)
- Pattern libraries (reusable design templates)
- Checklists (optimization, performance, accessibility)
- Quick decision trees ("Which control to use?")

## Olist Dataset Specifics (Weeks 15-16 Validation)

### Critical Data Corrections
1. **CLV Tiers:** Use $5K/$2K/$500 thresholds (NOT $500K - top customer is $13.6K)
2. **Customer ID:** Always use `customer_unique_id` for aggregation (NOT `customer_id`)
3. **Marketing ROI:** Campaign cost data missing - use simulated values with disclaimers
4. **Delivery Stats (vs 7-day threshold):** 75% delayed/critical (Week 15 framing)
5. **Delivery Stats (vs Olist estimate):** 92% On Time — Olist sets conservative estimates, avg delivery 12.7 days EARLY (Week 16 framing — different metric, not a contradiction)
6. **Declared Revenue:** All zeros in closed_deals - avoid using this field
7. **Date Ranges:** Sales (Sep 2016-Oct 2018), Marketing (Jun 2017-May 2018)
8. **Revenue Inflation Risk:** Joining order_items without pre-aggregating payments inflates SP revenue 28% ($7.4M vs $5.77M correct)

### Schema Tables
- **olist_sales_data_set:** orders, order_items, customers, products, sellers, payments, reviews, geolocation
- **olist_marketing_data_set:** marketing_qualified_leads, closed_deals

### Key Metrics (Validated)
- MoM Growth: Aug 2018 = -4.13%
- YTD Revenue (2018): $8,452,980
- AOV Range: $147-$169
- Delivery distribution: Express 5%, Standard 20%, Delayed 50%, Critical 25%

## Looker Studio Function Syntax Notes

### Functions That Work
- CASE WHEN ... THEN ... ELSE ... END
- CONCAT(field1, field2, ...)
- CAST(field AS STRING/NUMBER/DATE)
- DATE_DIFF(end_date, start_date, DAY)
- ROUND(number, decimals)
- SUM, AVG, COUNT, COUNT(DISTINCT field)
- RUNNING_TOTAL(metric)
- UPPER, LOWER (text standardization)
- EXTRACT(MONTH FROM date)

### Functions with Limitations
- **LAG/LEAD:** Limited support - pre-calculate in SQL for window functions
- **NTILE:** Not supported in calculated fields - pre-calculate for RFM scores
- **STRING functions:** Limited compared to SQL - use CONCAT + CAST workarounds

### Data Type Conversions
- Use `STRING` not `TEXT` (Looker syntax)
- Date fields must be timestamp or date type (not string)
- Currency should be Number type with currency format applied

## Content Tone and Style

### Instructor Voice
- Professional but approachable (instructor-to-student)
- Explicit connections to prior weeks (builds on existing knowledge)
- Business context before technical steps (WHY before HOW)
- Real-world applications (Olist e-commerce scenarios)

### Format Conventions
- Use ✅ ❌ for Do's/Don'ts
- Use ☐ for checklists
- Use ⚠️ for critical warnings
- Use 📊 📅 🎚️ sparingly for visual markers
- Code blocks with language tags (sql, python, no tag for Looker formulas)
- Tables for comparisons and reference material
- Visual mockups in ASCII art for expected layouts

## Common Student Pain Points

### Week 14 Patterns
1. **Control-chart data source mismatch** - Most common issue, emphasize checking data sources
2. **Multi-select confusion** - Need Ctrl/Cmd+click, not intuitive to students
3. **NULL handling** - 2,965 orders with NULL delivery dates cause calc errors
4. **Aggregation level confusion** - Mixing SUM(field) with field in same formula
5. **Date comparison outside range** - Previous period has no data (dataset boundaries)

### Solutions Emphasized
- Always filter `WHERE order_status = 'delivered'` for revenue metrics
- Handle NULLs explicitly: `CASE WHEN field IS NULL THEN NULL ELSE calc END`
- Pre-calculate complex metrics (LAG, NTILE) in SQL data source
- Use validation report queries as SQL templates

## Week 15 Specific Learnings

### Advanced Functions Focus
- Nested CASE statements for business logic (CLV tiers, delivery performance)
- String functions for data cleaning (CONCAT, CAST, UPPER)
- Date functions for time-based analysis (DATE_DIFF, EXTRACT)
- Mathematical functions for KPIs (ROUND, ABS, conditional aggregation)

### Business Metrics Focus
- Period comparisons (MoM, YoY) using Looker built-in comparison features
- Running totals (YTD revenue) using RUNNING_TOTAL function
- AOV trends and weighted averages
- Percentage of total calculations

### Data Storytelling Focus (Thursday)
- Narrative dashboard design (progressive disclosure, annotations)
- Actionable insights (highlighting anomalies, recommendations)
- Executive summary patterns

## Week 16 Specific Learnings

### Production Dashboard Focus
- Row multiplication problem: joining order_items without pre-aggregating payments inflates revenue 28%
- Pre-aggregated queries (5 data sources: 2a-2e from validation report) reduce rows from 99K to 27
- Extract vs Live: Always use Extract for Olist (historical data, no real-time needed)
- Custom SQL in Looker: No trailing semicolons, schema.table prefix required

### Sharing and Permissions Focus
- Owner's credentials is mandatory when sharing with non-Supabase users (all external stakeholders)
- Shareable link URL (from "Manage access" dialog) != Edit URL from browser address bar
- Scheduled email delivery: PDF for executives (Page 1 only, Monday 7AM); Link for analysts (all pages, Friday 4PM)
- Embed: Must enable File > Embed report first; responsive wrapper uses padding-bottom CSS trick

### Documentation Requirements (Week 16 Final Project)
- 6 criteria: Data Connection 10%, Calculated Fields 20%, Visualizations 25%, Interactivity 20%, Design 15%, Sharing+Docs 10%
- Documentation has 5 sections: Overview, Data Sources, Calculated Fields, Filters/Controls, Maintenance
- Known limitations (7 total) must all be acknowledged in student documentation
- 5-minute live presentation: features demo + 2-3 business insights + 1 technical decision + Q&A

### Resource File Patterns (Week 16)
- Wednesday resources: `performance_optimization_guide.md` (SQL anti-patterns, benchmarks, decision tree) + `data_quality_checklist.md` (field-level audit results, production certification checklist)
- Thursday resources: `sharing_permissions_reference.md` (all sharing methods, permission levels, troubleshooting) + `dashboard_documentation_template.md` (fill-in template with pre-filled Olist examples)

### Context7 Reliability
- Context7 API sometimes fails with "TypeError: fetch failed" network error
- Fallback: Rely on training knowledge + thorough validation report reading + Week 15 structural reference
- Always verify feature behavior (e.g., scheduled delivery, embed) in the validation report or README rather than assuming

## Completed Weeks Summary
- Week 13: Fundamentals (Wed: 3 notebooks, Thu: 4 lectures) - COMPLETE
- Week 14: Interactive Dashboards (Wed: 4 notebooks, Thu: 4 lectures + solutions) - COMPLETE
- Week 15: Advanced Analytics + Storytelling (Wed: 4 notebooks, Thu: 4 lectures) - COMPLETE
- Week 16: Production Dashboards (Wed: 4 notebooks + 2 exercises + 2 resources; Thu: 4 lectures + 2 exercises + 2 resources) - COMPLETE

## Links to Related Memory Files
- (Future) `debugging.md` - Common Looker Studio errors and fixes
- (Future) `patterns.md` - Reusable dashboard layout templates

---
**Last Updated:** 2026-03-03 | Week 16 Development Session
