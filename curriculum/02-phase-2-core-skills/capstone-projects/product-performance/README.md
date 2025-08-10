# Product Category Performance Analysis Project

# PORA Academy Cohort 5 - Product Category Performance Analysis Project

## Phase 1 Capstone: Retail Business Intelligence System

---

### 📋 **Project Overview**

**Duration:** 6 Days

**Dataset:** Superstore Sales Dataset (9,994 transactions, 2014-2017)

**Data Source:** https://www.kaggle.com/datasets/vivek468/superstore-dataset-final?select=Sample+-+Superstore.csv

**Tools:** Microsoft Excel (Advanced Functions, Pivot Tables, Charts)

**Objective:** Build a comprehensive product category performance analysis system using advanced Excel techniques

---

### 🎯 **Learning Objectives**

By completing this project, students will:

- Master advanced data cleaning techniques in Excel for retail data
- Apply complex formulas and functions (SUM, AVERAGE, COUNTIF, VLOOKUP, SUMIFS) to business analytics
- Create interactive dashboards using pivot tables and charts for product performance
- Develop skills in profitability analysis and business intelligence
- Build presentation-ready visualizations for retail management stakeholders

---

### 📊 **Dataset Information**

**Superstore Sales Dataset:**

- **Records:** 9,994 sales transactions
- **Time Period:** January 2014 - January 2018
- **Customers:** 793 unique customers
- **Business Context:** Fictional US retail company specializing in Furniture, Office Supplies, and Technology

**Key Columns:**

- `Row ID` - Unique transaction identifier
- `Order ID` - Order reference number
- `Order Date` - Date when order was placed
- `Ship Date` - Date when order was shipped
- `Ship Mode` - Shipping method used
- `Customer ID` - Unique customer identifier
- `Customer Name` - Customer full name
- `Segment` - Customer segment (Consumer, Corporate, Home Office)
- `Country/Region/State/City` - Geographic information
- `Product ID` - Unique product identifier
- `Category` - Product category (Furniture, Office Supplies, Technology)
- `Sub-Category` - Product subcategory
- `Product Name` - Specific product name
- `Sales` - Revenue generated from sale
- `Quantity` - Number of units sold
- `Discount` - Discount percentage applied
- `Profit` - Profit generated from sale

---

## 📅 **Daily Schedule & Tasks**

### **Day 1: Data Import & Retail Data Exploration**

**Focus: Business Data Familiarization & Setup**

1. **Data Import & Setup**
    - Download Superstore dataset from Kaggle
    - Import CSV into Excel using Data → Get Data
    - Set up proper data types for retail metrics (Sales as Currency, Dates as Date format)
    - Create backup copy on separate worksheet
2. **Initial Business Data Exploration**
    - Use `=ROWS()` to count total transactions
    - Use `=COLUMNS()` to verify column count
    - Create business summary statistics table:
        - Total transactions: `=COUNT(A:A)`
        - Date range: `=MIN(Order_Date)` and `=MAX(Order_Date)`
        - Total sales: `=SUM(Sales_Column)`
        - Total profit: `=SUM(Profit_Column)`
3. **Business Data Quality Assessment**
    - Check for missing values in critical columns using `=COUNTBLANK()`
    - Identify incomplete transaction records using conditional formatting
    - Create data quality report with:
        - Missing value count per business metric
        - Transaction completeness summary
        - Basic financial performance statistics

**Deliverable:** Business data import verification report + retail data quality assessment

---

### **Day 2: Retail Data Cleaning & Business Standardization**

**Focus: Advanced Retail Data Cleaning Techniques**

1. **Product and Customer Data Cleaning**
    - Clean product names:
        - Remove extra spaces: `=TRIM()`
        - Standardize product naming: `=PROPER()`
    - Clean customer information:
        - Standardize customer names
        - Handle inconsistent segment values
        - Normalize geographic data
2. **Transaction Data Validation & Duplicates**
    - Identify duplicate transactions (same Order ID, Product ID combination)
    - Create duplicate detection formula: `=COUNTIFS($Order_ID:$Order_ID,Order_ID,$Product_ID:$Product_ID,Product_ID)>1`
    - Remove duplicate transactions using Data → Remove Duplicates
    - Validate financial data integrity post-cleaning
3. **Financial Data Standardization**
    - Validate sales and profit consistency
    - Handle negative profit margins
    - Create discount categories (No Discount, Low, Medium, High)
    - Convert discount decimal to percentage format
4. **Business Performance Calculations**
    - Create Profit Margin: `=IF(Sales=0,0,Profit/Sales)`
    - Create Days to Ship: `=Ship_Date-Order_Date`
    - Create Order Value Categories: `=IF(Sales>=1000,"High Value",IF(Sales>=500,"Medium Value","Low Value"))`
    - Handle calculation errors with proper error handling

**Deliverable:** Cleaned retail dataset with business metrics validation report

---

### **Day 3: Advanced Business Formulas & Product Analysis**

**Focus: Complex Retail Calculations & Category Segmentation**

1. **Product Performance Classification**
    - Create product performance categories:
        
        ```
        =IF(Profit_Margin>=0.2,"High Profit",IF(Profit_Margin>=0.1,"Medium Profit",IF(Profit_Margin>=0,"Low Profit","Loss Making")))
        
        ```
        
    - Calculate product success indicators using multiple metrics
    - Create category effectiveness scores
2. **Customer Segmentation Analysis**
    - Count orders per customer: `=COUNTIF($Customer_ID:$Customer_ID,Customer_ID)`
    - Categorize customers by purchase behavior:
        
        ```
        =IF(Order_Count>=10,"VIP Customer",IF(Order_Count>=5,"Regular Customer",IF(Order_Count>=2,"Occasional Customer","New Customer")))
        
        ```
        
3. **Category Performance Metrics**
    - Average sales per category: `=AVERAGEIF($Category:$Category,Category,Sales)`
    - Total profit per category: `=SUMIF($Category:$Category,Category,Profit)`
    - Category market share calculations using `=SUMIF()` and relative percentages
4. **Geographic Performance Analytics**
    - Calculate regional performance: `=AVERAGEIF($Region:$Region,Region,Profit_Margin)`
    - State-wise sales analysis: `=SUMIF($State:$State,State,Sales)`
    - Use `=VLOOKUP()` for geographic category mapping

**Deliverable:** Product category performance analysis with customer segmentation

---

### **Day 4: Business Pivot Tables & Dynamic Retail Analysis**

**Focus: Interactive Business Intelligence Analysis**

1. **Product Category Performance Pivot Tables**
    - Sales and profit performance by category and subcategory over time
    - Average profit margins by product category
    - Quantity sold patterns by category
    - Add slicers for interactive category filtering
2. **Customer Behavior Pivot Tables**
    - Top customers by sales value and frequency
    - Customer segment performance analysis
    - Purchase patterns by customer segment
    - Regional customer distribution and performance
3. **Time Series Business Analysis**
    - Monthly and yearly sales trends using pivot tables
    - Seasonal sales patterns by category
    - Year-over-year growth analysis
    - Peak sales periods identification
4. **Profitability Analysis**
    - Profit margin analysis by category and region
    - High vs. low performing products
    - Discount impact on profitability
    - Shipping efficiency analysis

**Deliverable:** Interactive business intelligence pivot table system

---

### **Day 5: Business Dashboards & Retail Performance Visualisation**

**Focus: Retail Data Visualisation & Business Storytelling**

1. **Executive Business Dashboard Creation**
    - Key business performance indicators (KPIs):
        - Total sales, profit, transactions, and profit margin
    - Sales and profit trend charts over time
    - Top performing categories and products leaderboards
    - Dynamic filtering by region and period
2. **Product Category Insights Visualisations**
    - Category sales distribution pie charts
    - Profit margin vs. sales volume scatter plots
    - Subcategory performance heatmap
    - Category growth trends over time
3. **Geographic Performance Dashboard**
    - Regional sales performance maps (using conditional formatting)
    - State-wise profit margin comparison
    - City performance rankings
    - Shipping efficiency by region
4. **Interactive Business Elements**
    - Add form controls for dynamic filtering by category
    - Create dependent dropdown lists for product analysis
    - Implement conditional formatting for performance indicators
    - Add data validation for business metric inputs

**Deliverable:** Comprehensive retail business intelligence dashboard

---

### **Day 6: Business Insights & Executive Presentation**

**Focus: Professional Business Reporting & Stakeholder Communication**

1. **Business Executive Summary Creation**
    - Key retail findings and category performance insights
    - Product portfolio recommendations
    - Geographic expansion opportunities
    - Profitability optimization strategies
2. **Business Presentation Materials**
    - Create PowerPoint presentation with key business insights
    - Include screenshots of interactive Excel business dashboard
    - Prepare speaker notes for executive stakeholder presentation
    - Design professional retail performance visualizations
3. **Business Documentation & Validation**
    - Complete business formula documentation
    - Create user guide for retail dashboard
    - Validate all business calculations using Excel's audit tools
    - Final business intelligence quality assurance
4. **Final Business Review & Optimization**
    - Performance optimization of retail workbook
    - Error checking and correction
    - Create final business analytics backup
    - Prepare executive submission package

**Deliverable:** Complete retail business intelligence project package with presentation

---

## 🔧 **Technical Requirements**

### **Essential Excel Skills Applied:**

- Core functions: `SUM`, `AVERAGE`, `COUNTIF`, `COUNTIFS`, `SUMIFS`, `AVERAGEIF`
- Text functions: `TRIM`, `PROPER`, `LEN`, `SUBSTITUTE`
- Lookup functions: `VLOOKUP`, `INDEX-MATCH`
- Date functions: `YEAR`, `MONTH`, `DAY`, date arithmetic
- Mathematical functions: Percentage calculations, margin analysis
- Conditional formatting and data validation
- Pivot tables with slicers and calculated fields
- Interactive charts and dynamic business dashboards

### **Retail Data Cleaning Techniques:**

- Product data standardization using built-in Excel tools
- Missing business metric handling with conditional logic
- Customer data standardization using TEXT-TO-COLUMNS
- Financial data validation and error handling
- Geographic data normalization

---

## 📈 **Key Performance Indicators (KPIs)**

### **Primary Business Metrics:**

1. **Total Sales Revenue:** Sum of all sales transactions
2. **Overall Profit Margin:** Total profit divided by total sales
3. **Average Order Value:** Total sales divided by number of orders
4. **Category Performance Index:** Composite score of sales and profit by category
5. **Customer Retention Rate:** Repeat customer percentage

### **Secondary Business Metrics:**

- Sales growth rate (monthly/yearly)
- Product category market share
- Regional performance comparison
- Shipping efficiency metrics
- Discount impact on profitability

---

## 🎯 **Assessment Criteria**

### **Excel Workbook Output (60%)**

- **Data Cleaning Completeness (20%):** Proper use of TRIM, duplicate removal, business data validation
- **Formula Accuracy (20%):** Correct implementation of VLOOKUP, SUMIFS, COUNTIFS, business calculations
- **Pivot Table Sophistication (10%):** Advanced pivot tables with slicers and business calculated fields
- **Dashboard Functionality (10%):** Interactive elements, charts, and professional business formatting

### **Presentation Quality (40%)**

- **Business Insight (15%):** Quality of analysis and findings relevant to retail category performance
- **Visual Communication (15%):** Clarity of business charts, professional design, effective retail storytelling
- **Technical Understanding (10%):** Demonstration of Excel skills and business methodology explanation

---

*This project represents the culmination of Phase 1 PORA Academy training, demonstrating mastery of Excel-based data analysis for retail business intelligence applications. Students who successfully complete this project will be ready to advance to Phase 2 (SQL/Python) training with strong foundations in business analytics.*