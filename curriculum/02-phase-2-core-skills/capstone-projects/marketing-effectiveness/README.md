# Marketing Channel Effectiveness

# PORA Academy Cohort 5 - Marketing Channel Effectiveness Analysis Project

## Phase 1 Capstone: Digital Marketing Performance Intelligence System

---

### 📋 **Project Overview**

**Duration:** 6 Days

**Dataset:** Clicks Conversion Tracking (Marketing Campaign Data)

**Data Source:** https://www.kaggle.com/datasets/loveall/clicks-conversion-tracking

**Tools:** Microsoft Excel (Advanced Functions, Pivot Tables, Charts)

**Objective:** Build a comprehensive marketing channel effectiveness analysis system using advanced Excel techniques

---

### 🎯 **Learning Objectives**

By completing this project, students will:

- Master advanced data cleaning techniques in Excel for marketing data
- Apply complex formulas and functions (SUM, AVERAGE, COUNTIF, VLOOKUP, SUMIFS) to digital marketing analytics
- Create interactive dashboards using pivot tables and charts for campaign performance
- Develop skills in marketing ROI and conversion analysis
- Build presentation-ready visualizations for marketing stakeholders

---

### 📊 **Dataset Information**

**Clicks Conversion Tracking Dataset:**

- **Focus:** Facebook/Meta advertising campaign performance
- **Metrics:** Click-through rates, conversion tracking, campaign effectiveness
- **Business Context:** Digital marketing optimization and ROI analysis

**Key Columns (Expected):**

- `ad_id` - Unique advertisement identifier
- `xyz_campaign_id` - Campaign identifier from XYZ platform
- `fb_campaign_id` - Facebook campaign identifier
- `age` - Target audience age group
- `gender` - Target audience gender
- `interest` - Target audience interest category
- `Impressions` - Number of times ad was shown
- `Clicks` - Number of clicks received
- `Spent` - Amount spent on advertising
- `Total_Conversion` - Number of conversions achieved
- `Approved_Conversion` - Number of approved/valid conversions

---

## 📅 **Daily Schedule & Tasks**

### **Day 1: Data Import & Marketing Data Exploration**

**Focus: Campaign Data Familiarization & Setup**

1. **Data Import & Setup**
    - Download Clicks Conversion Tracking dataset from Kaggle
    - Import CSV into Excel using Data → Get Data
    - Set up proper data types for marketing metrics
    - Create backup copy on separate worksheet
2. **Initial Marketing Data Exploration**
    - Use `=ROWS()` to count total campaign records
    - Use `=COLUMNS()` to verify column count
    - Create marketing summary statistics table:
        - Total campaigns: `=COUNT(A:A)`
        - Total impressions: `=SUM(Impressions_Column)`
        - Total clicks: `=SUM(Clicks_Column)`
        - Average spend per campaign: `=AVERAGE(Spent_Column)`
3. **Campaign Performance Assessment**
    - Check for missing values in critical columns using `=COUNTBLANK()`
    - Identify incomplete campaign data using conditional formatting
    - Create campaign quality report with:
        - Missing value count per marketing metric
        - Campaign completeness summary
        - Basic performance statistics

**Deliverable:** Marketing data import verification report + campaign quality assessment

---

### **Day 2: Marketing Data Cleaning & Standardization**

**Focus: Advanced Marketing Data Cleaning Techniques**

1. **Campaign Data Cleaning**
    - Clean campaign identifiers:
        - Remove extra spaces: `=TRIM()`
        - Standardize campaign naming: `=PROPER()`
    - Clean demographic data (age, gender, interest):
        - Standardize age group formats
        - Handle inconsistent gender values
        - Normalize interest categories
2. **Duplicate Campaign Detection & Removal**
    - Identify duplicate campaigns (same ad_id, campaign_id combination)
    - Create duplicate detection formula: `=COUNTIFS($A:$A,A2,$B:$B,B2)>1`
    - Remove duplicate campaign entries using Data → Remove Duplicates
    - Validate campaign data integrity post-cleaning
3. **Marketing Metrics Standardization**
    - Validate impression and click data consistency
    - Handle zero or negative spend values
    - Create spend categories (Low, Medium, High budget campaigns)
4. **Campaign Performance Calculations**
    - Create Click-Through Rate (CTR): `=IF(Impressions=0,0,Clicks/Impressions)`
    - Create Cost Per Click (CPC): `=IF(Clicks=0,0,Spent/Clicks)`
    - Create Conversion Rate: `=IF(Clicks=0,0,Total_Conversion/Clicks)`
    - Handle division by zero errors with proper error handling

**Deliverable:** Cleaned marketing dataset with performance metrics validation report

---

### **Day 3: Advanced Marketing Formulas & Campaign Analysis**

**Focus: Complex Marketing Calculations & Audience Segmentation**

1. **Campaign Performance Classification**
    - Create campaign performance categories:
        
        ```
        =IF(CTR>=0.02,"High Performance",IF(CTR>=0.01,"Medium Performance","Low Performance"))
        
        ```
        
    - Calculate campaign effectiveness scores using multiple metrics
    - Create campaign success indicators
2. **Audience Segmentation Analysis**
    - Count campaigns per demographic: `=COUNTIF($Age_Column:$Age_Column,Age_Value)`
    - Categorize audience segments:
        
        ```
        =IF(Age<=25,"Young Adults",IF(Age<=45,"Adults",IF(Age<=65,"Mature Adults","Seniors")))
        
        ```
        
3. **Marketing ROI Calculations**
    - Return on Ad Spend (ROAS): `=IF(Spent=0,0,Revenue/Spent)` (if revenue data available)
    - Cost per conversion: `=IF(Total_Conversion=0,0,Spent/Total_Conversion)`
    - Campaign efficiency metrics using `=SUMIF()` and `=AVERAGEIF()`
4. **Channel Performance Analytics**
    - Calculate platform performance: `=AVERAGEIF($Platform:$Platform,Platform,CTR_Column)`
    - Campaign duration analysis: `=LEN()` functions for campaign naming patterns
    - Use `=VLOOKUP()` for campaign category mapping

**Deliverable:** Campaign performance analysis with audience segmentation

---

### **Day 4: Marketing Pivot Tables & Dynamic Campaign Analysis**

**Focus: Interactive Marketing Data Analysis**

1. **Campaign Performance Pivot Tables**
    - Campaign performance by demographic segments over time
    - Average CTR and conversion rates by audience type
    - Spend efficiency patterns by campaign category
    - Add slicers for interactive campaign filtering
2. **Channel Effectiveness Pivot Tables**
    - Top performing campaigns by impressions and conversions
    - Platform comparison (Facebook vs other channels if applicable)
    - Demographic performance analysis
    - Budget allocation effectiveness trends
3. **Marketing Funnel Analysis**
    - Impression to click conversion analysis
    - Click to conversion funnel performance
    - Campaign lifecycle performance patterns
    - Audience engagement progression analysis
4. **Budget Optimization Analysis**
    - Spend vs. performance correlation analysis
    - Cost efficiency by campaign type
    - Budget allocation recommendations
    - Campaign scalability assessment

**Deliverable:** Interactive marketing analytics pivot table system

---

### **Day 5: Marketing Dashboards & Performance Visualization**

**Focus: Marketing Data Visualization & Campaign Storytelling**

1. **Marketing Executive Dashboard Creation**
    - Key marketing performance indicators (KPIs):
        - Total impressions, clicks, conversions, and spend
    - Campaign performance trend charts
    - Top performing campaigns and audience segments leaderboards
    - Dynamic campaign filtering by demographics
2. **Campaign Performance Visualizations**
    - Campaign ROI distribution charts
    - Audience segment performance comparison
    - Marketing funnel conversion rates
    - Budget efficiency analysis charts
3. **Audience Insights Dashboard**
    - Demographic segment distribution pie charts
    - Age group vs. conversion rate scatter plots
    - Interest category performance heatmap
    - Gender-based campaign effectiveness analysis
4. **Interactive Marketing Elements**
    - Add form controls for campaign filtering
    - Create dependent dropdown lists for demographic analysis
    - Implement conditional formatting for performance indicators
    - Add data validation for marketing metric inputs

**Deliverable:** Comprehensive marketing performance dashboard

---

### **Day 6: Marketing Insights & Presentation**

**Focus: Professional Marketing Reporting & Business Communication**

1. **Marketing Executive Summary Creation**
    - Key campaign findings and performance insights
    - Marketing recommendations for budget optimization
    - Audience targeting recommendations
    - Campaign performance assessment summary
2. **Marketing Presentation Materials**
    - Create PowerPoint presentation with key marketing insights
    - Include screenshots of interactive Excel marketing dashboard
    - Prepare speaker notes for marketing stakeholder presentation
    - Design professional marketing visualizations
3. **Marketing Documentation & Validation**
    - Complete marketing formula documentation
    - Create user guide for marketing dashboard
    - Validate all marketing calculations using Excel's audit tools
    - Final marketing analytics quality assurance
4. **Final Marketing Review & Optimization**
    - Performance optimization of marketing workbook
    - Error checking and correction
    - Create final marketing analytics backup
    - Prepare marketing submission package

**Deliverable:** Complete marketing analytics project package with presentation

---

## 🔧 **Technical Requirements**

### **Essential Excel Skills Applied:**

- Core functions: `SUM`, `AVERAGE`, `COUNTIF`, `COUNTIFS`, `SUMIFS`, `AVERAGEIF`
- Text functions: `TRIM`, `PROPER`, `LEN`, `SUBSTITUTE`
- Lookup functions: `VLOOKUP`, `INDEX-MATCH`
- Mathematical functions: Division, percentage calculations, ratio analysis
- Conditional formatting and data validation
- Pivot tables with slicers and calculated fields
- Interactive charts and dynamic marketing dashboards

### **Marketing Data Cleaning Techniques:**

- Campaign data standardization using built-in Excel tools
- Missing marketing metric handling with conditional logic
- Demographic data standardization using TEXT-TO-COLUMNS
- Marketing metric validation and error handling

---

## 📈 **Key Performance Indicators (KPIs)**

### **Primary Marketing Metrics:**

1. **Click-Through Rate (CTR):** Clicks divided by impressions
2. **Conversion Rate:** Conversions divided by clicks
3. **Cost Per Click (CPC):** Total spend divided by total clicks
4. **Cost Per Conversion:** Total spend divided by total conversions
5. **Campaign Efficiency Score:** Composite metric of performance indicators

### **Secondary Marketing Metrics:**

- Return on Ad Spend (ROAS) - if revenue data available
- Audience engagement rate by demographic
- Platform performance comparison
- Budget utilization efficiency
- Campaign scalability indicators

---

## 🎯 **Assessment Criteria**

### **Excel Workbook Output (60%)**

- **Data Cleaning Completeness (20%):** Proper use of TRIM, duplicate removal, marketing data validation
- **Formula Accuracy (20%):** Correct implementation of VLOOKUP, SUMIFS, COUNTIFS, marketing calculations
- **Pivot Table Sophistication (10%):** Advanced pivot tables with slicers and marketing calculated fields
- **Dashboard Functionality (10%):** Interactive elements, charts, and professional marketing formatting

### **Presentation Quality (40%)**

- **Marketing Insight (15%):** Quality of analysis and findings relevant to digital marketing effectiveness
- **Visual Communication (15%):** Clarity of marketing charts, professional design, effective campaign storytelling
- **Technical Understanding (10%):** Demonstration of Excel skills and marketing methodology explanation

---

*This project represents the culmination of Phase 1 PORA Academy training, demonstrating mastery of Excel-based data analysis for digital marketing intelligence applications. Students who successfully complete this project will be ready to advance to Phase 2 (SQL/Python) training with strong foundations in marketing analytics.*