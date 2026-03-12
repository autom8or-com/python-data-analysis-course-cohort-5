# Phase 2 Capstone Project — Team Dashboard Challenge

## PORA Academy Cohort 5 | Data Analytics & AI Bootcamp

---

## Overview

**Duration:** 4 weeks (Month 7)
**Format:** Team-based group project
**Tool:** Google Looker Studio
**Dataset:** Olist Brazilian E-Commerce (Supabase — `olist_sales_data_set` schema)

Students are divided into **3 teams** (varied sizes), each tackling a distinct business analytics focus area using the same Olist marketplace dataset. Each team will produce an interactive Looker Studio dashboard, a written business report, and a stakeholder presentation.

---

## Team Assignments

| Team | Focus Area | Project Directory |
|------|-----------|-------------------|
| Team 1 | **Seller Performance Optimization** | [`seller-performance/`](seller-performance/) |
| Team 2 | **Supply Chain & Logistics Optimization** | [`supply-chain-optimization/`](supply-chain-optimization/) |
| Team 3 | **Customer Satisfaction Analytics** | [`customer-satisfaction/`](customer-satisfaction/) |

---

## Deliverables (All Teams)

Each team must produce:

1. **Google Looker Studio Dashboard** (3-5 interactive pages)
   - Connected to Supabase/SQL data sources
   - Interactive filters and cross-filtering
   - Professional design with consistent color scheme
   - Clear titles, labels, legends, and insight annotations

2. **Written Business Report** (8-12 pages, PDF)
   - Executive summary
   - Methodology (data sources, KPI definitions, tools)
   - Key findings (5-7 insights supported by data)
   - Recommendations (actionable, tied to specific metrics)
   - Data limitations and caveats

3. **Stakeholder Presentation** (10-15 slides, 10-minute delivery)
   - Problem statement → Analysis approach → Key findings → Recommendations
   - Live dashboard demo during presentation
   - Q&A readiness

---

## Weekly Milestones

| Week | Focus | Deliverable |
|------|-------|-------------|
| **Week 1** | Data Exploration & SQL Development | Validated SQL queries + data dictionary |
| **Week 2** | Core Dashboard Build (Pages 1-3) | Working 3-page dashboard |
| **Week 3** | Advanced Features & Polish (Pages 4-5) | Complete 5-page dashboard with cross-filtering |
| **Week 4** | Report, Presentation & Final Review | Report (PDF) + Slides + Final dashboard |

---

## Shared Dataset: Olist E-Commerce

All teams use the same database but focus on different analytical angles:

### Schema: `olist_sales_data_set`
| Table | Rows | Key For |
|-------|------|---------|
| `olist_orders_dataset` | 99,441 | All teams — order status, timestamps |
| `olist_order_items_dataset` | 112,650 | Seller + Supply Chain — prices, freight, sellers |
| `olist_order_reviews_dataset` | 98,410 | Customer Satisfaction — review scores, comments |
| `olist_customers_dataset` | 99,441 | Customer Satisfaction + Supply Chain — geography |
| `olist_sellers_dataset` | 3,095 | Seller Performance — seller locations |
| `olist_products_dataset` | 32,951 | All teams — categories, weight, dimensions |
| `olist_order_payments_dataset` | 103,886 | All teams — payment methods |
| `product_category_name_translation` | 71 | All teams — Portuguese→English category names |

### Critical Data Rules (ALL TEAMS MUST FOLLOW)
- Filter `WHERE order_status = 'delivered'` for revenue and delivery metrics
- Use `customer_unique_id` (NOT `customer_id`) for customer aggregation
- Exclude NULL delivery dates (~3% of orders) from delivery calculations
- Date range: Sep 2016 – Oct 2018 (use Jan 2017+ for trends)
- Join `product_category_name_translation` for English category names
- `declared_monthly_revenue` in marketing tables is ALL ZEROS — never use

---

## Grading Structure (100 points + 5 bonus)

| Component | Weight | Description |
|-----------|--------|-------------|
| SQL Development | 20% | Query correctness, NULL handling, complexity |
| Dashboard Design | 30% | Visual communication, chart selection, layout |
| Interactivity | 20% | Filters, cross-filtering, calculated fields |
| Business Report | 15% | Analysis depth, actionable recommendations |
| Presentation | 15% | Delivery, narrative, live demo, Q&A |
| **Bonus** | +5 | Advanced features, original insights |

---

## Project Subdirectory Structure

Each team's folder contains:
```
{team-project}/
├── README.md           # Full project outline with validated SQL & KPIs
├── sql-queries/        # Team's validated SQL query files
├── dashboard-specs/    # Dashboard page layouts and design specs
├── report/             # Written business report drafts and final
├── presentation/       # Slide deck files
└── resources/          # Reference materials, data dictionary
```

---

## Support & Resources

- **Weekly check-ins** with instructors during class sessions
- **Peer collaboration** encouraged across teams (different focus areas = no competition)
- **AI troubleshooting** guidance available (reference Getting Help with AI curriculum)
- **Supabase access** for live SQL query validation
- Each project README contains **12 pre-validated SQL queries** with sample results as starting points
