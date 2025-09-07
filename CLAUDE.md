# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is the repository for **PORA ACADEMY COHORT 5 - Data Analytics & AI Bootcamp**, a comprehensive 9-month program that teaches data analytics and AI skills. The repository contains structured curriculum materials, project specifications, and learning resources organized by program phases.

## Repository Structure

The repository is organized into three main phases with supporting documentation:

```
/
├── docs/                         # Program documentation and guides
├── phase-1-foundations/          # Month 1-3: Excel mastery (COMPLETED)
├── phase-2-core-skills/          # Month 4-9: SQL, Python, visualization (6 months)
├── phase-3-specializations/      # Month 7-9: Career track specialization (3 months)
├── templates/                    # Project templates and frameworks
└── resources/                    # Setup guides, instructor info, schedules
```

## Program Timeline (9 Months Total)

### Phase 1: Foundations (3 months - COMPLETED)
**Location:** `phase-1-foundations/`
- Excel mastery and data analysis fundamentals
- Weekly progression through basic to advanced Excel skills
- Placement test requirement (≥80% to advance)
- **Key File:** `foundations.md` - Complete curriculum with exercises

### Phase 2: Core Skills (6 months)
**Location:** `phase-2-core-skills/`
**Schedule:** Wednesdays & Thursdays, 2 hours each, August 6, 2025 - March 6, 2026
**Holiday Considerations:** Nigerian holidays observed (October 1, December 25, January 1)

**Structure:**
- **Months 2-4:** `sql-python-synchronized/` - Learn SQL and Python simultaneously
  - Same concepts taught in both languages using same datasets
  - SQL environment: VS Code | Python environment: Google Colab
- **Month 5-6:** `visualization-tools/` - Google Looker Studio & Streamlit
- **Month 7:** `phase-2-projects/` - Major capstone project (extended to 2 months due to holiday breaks)

**Special Feature:** `getting-help-with-ai/` - AI troubleshooting curriculum
- Introduced after Month 4 when core skills are established
- Effective prompting techniques for SQL/Python debugging
- AI model selection and troubleshooting workflows

### Phase 3: Specializations (3 months, overlapping with Phase 2)
**Location:** `phase-3-specializations/`
**Timeline:** January 8 - May 1, 2026 (starts concurrent with Phase 2 project)

Four specialized career tracks:
1. **No-Code Automation** - Zapier, Make.com, Airtable, Power BI
2. **Data Engineering** - Airflow, AWS/GCP, dbt, Snowflake  
3. **Advanced Data Analytics** - Agentic AI tools, advanced Looker Studio
4. **ML Drug Discovery** - Machine learning for pharmaceutical applications

## Key Projects

### Phase 2 Projects (Month 7)
**Location:** `phase-2-core-skills/phase-2-projects/`
Choose from 5 industry-focused projects:
- `customer-satisfaction/` - Amazon review sentiment analysis
- `marketing-effectiveness/` - Digital marketing campaign optimization
- `product-performance/` - E-commerce category analysis  
- `seller-optimization/` - Marketplace seller performance
- `supply-chain-logistics/` - Delivery and logistics optimization

### Phase 3 Projects (Month 9)
**Location:** `phase-3-specializations/phase-3-projects/`
**Timeline:** April 8 - May 1, 2026
Specialization-specific capstone projects (placeholders for detailed development)

## Important Files by Location

### Documentation (`docs/`)
- `curriculum-overview.md` - Complete 9-month program overview
- `program-structure.md` - Visual Mermaid flowcharts of program flow
- `syllabus.md` - Detailed course requirements and structure

### Resources (`resources/`)
- `instructors.md` - Teaching staff and resource persons
- `schedule.md` - Class times and important dates
- `tools-setup.md` - Software installation and environment setup

### Templates (`templates/`)
- `project-template.md` - Standardized project structure and requirements

## Development Context

When working with this repository:

### Content Structure
- Focus on educational progression from Excel → SQL/Python → Specialization
- Understand synchronized SQL/Python approach (same concepts, different tools)
- Note emphasis on practical, industry-relevant projects
- Pay attention to AI-assisted learning integration

### Key Innovations
- **Synchronized Learning:** SQL and Python taught in parallel with same datasets
- **AI Troubleshooting:** Structured curriculum for AI-assisted problem solving
- **Two Project Phases:** Core skills project + specialization project
- **Industry Focus:** Real-world datasets and business scenarios

### Technical Environment
- **Phase 2 Tools:** VS Code (SQL), Google Colab (Python), Google Looker Studio, Streamlit
- **Dataset:** E-commerce data used consistently across SQL and Python lessons
- **Assessment:** Practical projects with interactive dashboards and business presentations

## Notes for Development

- This is an educational curriculum repository with structured learning materials
- Content emphasizes hands-on, practical skills development
- Strong focus on business applications and real-world problem solving
- AI integration is strategic (after foundational skills are solid)
- Repository structure supports both instructors and students navigation
- Project content is detailed and industry-relevant for portfolio development

## Schedule Considerations

- **Class Schedule:** Wednesdays & Thursdays only, 2 hours per session
- **Nigerian Holidays Observed:** October 1 (National Day), December 25 (Christmas), January 1 (New Year)
- **December Break:** Classes only December 3, 4, 10, 11 then extended break until January 8, 2026
- **Program Completion:** May 1, 2026 (extended from original March 27, 2026 due to holiday accommodations)
- **Total Instructional Impact:** 11 lost sessions accommodated through timeline extension

## MCP Server
Live data set: olist_marketing_data_set and olist_sales_data_set schema in the database. Use supabase MCP server. Always ensure SQL Data content aligns with Python. So always start with SQL content by fetching live data and then cascade to Python.

## Course content creation order. 
1. Access `/home/odunayo12/python-data-analysis-course-cohort-5/docs/syllabus.md` 
2. Access the `olist_marketing_data_set` and `olist_sales_data_set` schema for live data relevant to the topic to be developed. 
3. Create Lesson plan sql and python in the relevant folders based on the accessed data. 
4. Create Data  and excercises for python Class similar to sql data. 
5. Create SQL Content content for thursday sql classes,  excercise, and solutions in the relevant folders. 
6. Create Python Content,  excercise, and solutions in the relevant folders.
7. Include the solutions file in git ignore

## Phase 2 Weekly Folder Order
```
week-<number: 01|02|...>-<short-form-week-topic>/ #eg. week-01-programming-foundations/
├── wednesday-python/
│   ├── exercises/
│   ├── lecture-materials/
│   │   ├── datasets/
│   │   └── notebooks/
│   ├── resources/
│   └── solutions/
└── thursday-sql/
    ├── exercises/
    ├── lecture-materials/
    │   ├── notebooks/
    │   └── scripts/
    ├── resources/
    └── solutions/
```