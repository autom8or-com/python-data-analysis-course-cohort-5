# Customer Satisfaction Intelligence

# PORA Academy Cohort 5- Customer Performance Optimization Project

## Phase 1 Capstone: Customer Satisfaction Intelligence System

---

### 📋 **Project Overview**

**Duration:** 6 Days

**Dataset:** Amazon Fine Food Reviews (568,454 reviews, Oct 1999 - Oct 2012)

**Data Source:** https://www.kaggle.com/datasets/snap/amazon-fine-food-reviews

**Tools:** Microsoft Excel (Advanced Functions, Pivot Tables, Charts)

**Objective:** Build a comprehensive customer satisfaction analysis system using advanced Excel techniques

---

### 🎯 **Learning Objectives**

By completing this project, students will:

- Master advanced data cleaning techniques in Excel
- Apply complex formulas and functions (SUM, AVERAGE, COUNTIF, VLOOKUP, SUMIFS) to real-world business problems
- Create interactive dashboards using pivot tables and charts
- Develop skills in customer sentiment analysis
- Build presentation-ready visualizations for stakeholders

---

### 📊 **Dataset Information**

**Amazon Fine Food Reviews Dataset:**

- **Records:** 568,454 reviews
- **Users:** 256,059 unique customers
- **Products:** 74,258 food items
- **Time Period:** October 1999 - October 2012

**Key Columns:**

- `Id` - Unique review identifier
- `ProductId` - Unique product identifier
- `UserId` - Unique customer identifier
- `ProfileName` - Customer display name
- `HelpfulnessNumerator` - Users who found review helpful
- `HelpfulnessDenominator` - Total users who rated helpfulness
- `Score` - Rating (1-5 stars)
- `Time` - Review timestamp
- `Summary` - Brief review summary
- `Text` - Full review text

---

## 📅 **Daily Schedule & Tasks**

### **Day 1: Data Import & Initial Exploration**

**Focus: Data Familiarization & Setup**

1. **Data Import & Setup**
    - Download Amazon Fine Food Reviews dataset from Kaggle
    - Import CSV into Excel using Data → Get Data
    - Set up proper data types for each column
    - Create backup copy on separate worksheet
2. **Initial Data Exploration**
    - Use `=ROWS()` to count total records
    - Use `=COLUMNS()` to verify column count
    - Create summary statistics table:
        - Total reviews: `=COUNT(A:A)`
        - Date range: `=MIN(H:H)` and `=MAX(H:H)`
        - Average score: `=AVERAGE(G:G)`
3. **Basic Data Quality Assessment**
    - Check for missing values using `=COUNTBLANK()`
    - Identify duplicate reviews using conditional formatting
    - Create data quality report with:
        - Missing value count per column
        - Duplicate detection summary
        - Basic descriptive statistics

**Deliverable:** Data import verification report + quality assessment summary

---

### **Day 2: Data Cleaning & Standardization**

**Focus: Advanced Data Cleaning Techniques**

1. **Text Data Cleaning**
    - Clean Profile Name column:
        - Remove extra spaces: `=TRIM()`
        - Standardize case: `=PROPER()`
    - Clean Summary and Text columns:
        - Remove HTML tags using find/replace
        - Handle special characters
        - Standardize punctuation
2. **Duplicate Removal & Data Validation**
    - Identify true duplicates (same user, product, timestamp)
    - Create duplicate detection formula:
        
        ```
        =COUNTIFS($B:$B,B2,$C:$C,C2,$H:$H,H2)>1
        
        ```
        
    - Remove duplicates using Data → Remove Duplicates
    - Validate data integrity post-cleaning
3. **Date & Time Standardization**
    - Convert Unix timestamp to readable date
    - Extract year, month, day using:
        - `=YEAR(H2)`, `=MONTH(H2)`, `=DAY(H2)`
    - Create time-based categories (quarters, seasons)
4. **Helpfulness Ratio Calculation**
    - Create helpfulness score: `=IF(F2=0,0,E2/F2)`
    - Handle division by zero errors
    - Categorize helpfulness levels

**Deliverable:** Cleaned dataset with validation report

---

### **Day 3: Advanced Formulas & Business Logic**

**Focus: Complex Calculations & Customer Segmentation**

1. **Sentiment Classification**
    - Create sentiment categories:
        
        ```
        =IF(G2>=4,"Positive",IF(G2<=2,"Negative","Neutral"))
        
        ```
        
    - Calculate sentiment distribution using `=COUNTIF()`
    - Create sentiment strength indicator
2. **Customer Segmentation**
    - Count reviews per customer: `=COUNTIF($C:$C,C2)`
    - Categorize customers:
        
        ```
        =IF(ReviewCount>=50,"Power User",   IF(ReviewCount>=10,"Regular User",      IF(ReviewCount>=5,"Occasional User","New User")))
        
        ```
        
3. **Product Performance Metrics**
    - Average rating per product: `=AVERAGEIF($B:$B,B2,$G:$G)`
    - Review volume per product: `=COUNTIF($B:$B,B2)`
    - Product popularity score calculation using `=SUMIF()`
4. **Advanced Text Analytics**
    - Calculate review length: `=LEN(J2)-LEN(SUBSTITUTE(J2," ",""))+1`
    - Create length categories (Short, Medium, Long)
    - Use `=VLOOKUP()` for category mapping

**Deliverable:** Customer and product segmentation analysis

---

### **Day 4: Pivot Tables & Dynamic Analysis**

**Focus: Interactive Data Analysis**

1. **Customer Behavior Pivot Tables**
    - Reviews by customer segment over time
    - Average rating by customer type using pivot table calculations
    - Helpfulness patterns by user category
    - Add slicers for interactive filtering
2. **Product Performance Pivot Tables**
    - Top products by review volume
    - Average ratings by product
    - Sentiment distribution by product
    - Time-based product trends
3. **Time Series Analysis**
    - Monthly review volume trends using pivot tables
    - Seasonal sentiment patterns
    - Year-over-year growth analysis
    - Peak activity periods identification
4. **Helpfulness Analysis**
    - Correlation between review length and helpfulness
    - Sentiment vs. helpfulness patterns
    - Customer segment helpfulness comparison

**Deliverable:** Interactive pivot table analysis system

---

### **Day 5: Advanced Visualizations & Dashboard Creation**

**Focus: Data Visualization & Storytelling**

1. **Executive Dashboard Creation**
    - Key performance indicators (KPIs):
        - Total reviews, average rating, sentiment distribution
    - Trend charts for review volume and sentiment
    - Top products and customers leaderboards
    - Dynamic date filtering
2. **Customer Insights Visualizations**
    - Customer segment distribution pie chart
    - Review frequency by customer type
    - Customer lifecycle analysis
    - Helpfulness patterns by segment
3. **Product Performance Dashboard**
    - Product rating distribution histogram
    - Top-rated vs. most-reviewed products scatter plot
    - Product sentiment analysis charts
    - Review volume trends by product category
4. **Interactive Elements**
    - Add form controls for dynamic filtering
    - Create dependent dropdown lists
    - Implement conditional formatting
    - Add data validation for user inputs

**Deliverable:** Comprehensive business dashboard

---

### **Day 6: Final Analysis & Presentation**

**Focus: Professional Reporting & Communication**

1. **Executive Summary Creation**
    - Key findings and insights from the analysis
    - Business recommendations based on data
    - Data quality assessment summary
    - Methodology documentation
2. **Presentation Materials**
    - Create PowerPoint presentation with key insights
    - Include screenshots of interactive Excel dashboard
    - Prepare speaker notes for presentation
    - Design professional visualizations
3. **Documentation & Validation**
    - Complete formula documentation
    - Create user guide for dashboard
    - Validate all calculations using Excel's audit tools
    - Final quality assurance check
4. **Final Review & Optimization**
    - Performance optimization of Excel workbook
    - Error checking and correction
    - Create final backup
    - Prepare submission package

**Deliverable:** Complete project package with presentation

---

## 🔧 **Technical Requirements**

### **Essential Excel Skills Applied:**

- Core functions: `SUM`, `AVERAGE`, `COUNTIF`, `COUNTIFS`, `SUMIFS`, `AVERAGEIF`
- Text functions: `TRIM`, `PROPER`, `LEN`, `SUBSTITUTE`
- Lookup functions: `VLOOKUP`, `INDEX-MATCH`
- Date functions: `YEAR`, `MONTH`, `DAY`
- Conditional formatting and data validation
- Pivot tables with slicers and calculated fields
- Interactive charts and dynamic dashboards

### **Data Cleaning Techniques:**

- Duplicate identification and removal using built-in Excel tools
- Missing value handling with conditional logic
- Text standardization using TEXT-TO-COLUMNS
- Date format conversion
- Data type validation

---

## 📈 **Key Performance Indicators (KPIs)**

### **Primary Metrics:**

1. **Customer Satisfaction Score:** Average rating across all reviews
2. **Review Engagement Rate:** Percentage of reviews marked as helpful
3. **Customer Retention Proxy:** Repeat reviewer percentage
4. **Product Performance Index:** Combined rating and volume score
5. **Sentiment Trend:** Monthly positive sentiment percentage

### **Secondary Metrics:**

- Review velocity (reviews per day/month)
- Customer segment distribution
- Product category performance
- Seasonal satisfaction patterns
- Review quality indicators

---

## 🎯 **Assessment Criteria**

### **Excel Workbook Output (60%)**

- **Data Cleaning Completeness (20%):** Proper use of TRIM, duplicate removal, data validation
- **Formula Accuracy (20%):** Correct implementation of VLOOKUP, SUMIFS, COUNTIFS, conditional logic
- **Pivot Table Sophistication (10%):** Advanced pivot tables with slicers and calculated fields
- **Dashboard Functionality (10%):** Interactive elements, charts, and professional formatting

### **Presentation Quality (40%)**

- **Business Insight (15%):** Quality of analysis and findings relevant to customer satisfaction
- **Visual Communication (15%):** Clarity of charts, professional design, effective storytelling
- **Technical Understanding (10%):** Demonstration of Excel skills and methodology explanation

---

*This project represents the culmination of Phase 1 PORA Academy training, demonstrating mastery of Excel-based data analysis for business intelligence applications. Students who successfully complete this project will be ready to advance to Phase 2 (SQL/Python) training.*