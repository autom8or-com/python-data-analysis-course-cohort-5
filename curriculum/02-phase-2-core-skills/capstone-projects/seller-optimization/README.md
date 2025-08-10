# Seller Performance Optimization Project

## Phase 1 Capstone: Publishing Industry Business Intelligence System

---

### 📋 **Project Overview**

**Duration:** 6 Days

**Dataset:** Amazon Top 50 Bestselling Books 2009-2019 (550+ book records)

**Data Source:** https://www.kaggle.com/datasets/sootersaalu/amazon-top-50-bestselling-books-2009-2019

**Tools:** Microsoft Excel (Advanced Functions, Pivot Tables, Charts)

**Objective:** Build a comprehensive publishing industry performance analysis system using advanced Excel techniques to analyze bestselling book trends

---

### 🎯 **Learning Objectives**

By completing this project, students will:

- Master advanced data cleaning techniques in Excel for publishing industry data
- Apply complex formulas and functions (SUM, AVERAGE, COUNTIF, VLOOKUP, SUMIFS) to book market analytics
- Create interactive dashboards using pivot tables and charts for publishing performance
- Develop skills in market trend analysis and publishing business intelligence
- Build presentation-ready visualizations for publishing industry stakeholders

---

### 📊 **Dataset Information**

**Amazon Top 50 Bestselling Books Dataset:**

- **Records:** 550+ bestselling book entries
- **Time Period:** 2009-2019 (11 years)
- **Business Context:** Amazon's annual top 50 bestselling books across Fiction and Non-Fiction categories
- **Market Coverage:** US market bestseller data with pricing, ratings, and review metrics

**Key Columns:**

- `Name` - Book title
- `Author` - Author name
- `User Rating` - Average user rating (1.0-5.0 scale)
- `Reviews` - Number of user reviews
- `Price` - Book price in USD
- `Year` - Publication/bestseller year (2009-2019)
- `Genre` - Category (Fiction or Non Fiction)

---

## 📅 **Daily Schedule & Tasks**

### **Day 1: Data Import & Publishing Data Exploration**

**Focus: Publishing Industry Data Familiarization & Setup**

### 1. **Data Import & Setup**

- Download Amazon bestselling books dataset from Kaggle
- Import CSV into Excel using Data → Get Data
- Set up proper data types (Price as Currency, User Rating as Number, Year as Date)
- Create backup copy on separate worksheet

### 2. **Initial Publishing Data Exploration**

- Use `=ROWS()` to count total book records
- Use `=COLUMNS()` to verify column count
- Create publishing summary statistics table:
    - Total books analyzed: `=COUNT(A:A)`
    - Year range: `=MIN(Year)` and `=MAX(Year)`
    - Average book price: `=AVERAGE(Price_Column)`
    - Average user rating: `=AVERAGE(User_Rating_Column)`

### 3. **Publishing Data Quality Assessment**

- Check for missing values in critical columns using `=COUNTBLANK()`
- Identify incomplete book records using conditional formatting
- Create data quality report with:
    - Missing value count per publishing metric
    - Book record completeness summary
    - Basic market performance statistics

**Deliverable:** Publishing data import verification report + book market data quality assessment

---

### **Day 2: Publishing Data Cleaning & Market Standardization**

**Focus: Advanced Publishing Data Cleaning Techniques**

### 1. **Book and Author Data Cleaning**

- Clean book titles:
    - Remove extra spaces: `=TRIM()`
    - Standardize book naming: `=PROPER()`
- Clean author information:
    - Standardize author names
    - Handle inconsistent author formats
    - Normalize author naming conventions

### 2. **Publishing Data Validation & Duplicates**

- Identify duplicate book entries (same Name, Author combination across years)
- Create duplicate detection formula: `=COUNTIFS($Name:$Name,Name,$Author:$Author,Author)>1`
- Handle multi-year bestsellers appropriately
- Validate rating and price data integrity post-cleaning

### 3. **Market Data Standardization**

- Validate rating ranges (1.0-5.0)
- Handle price inconsistencies and outliers
- Create rating categories (Excellent 4.5+, Good 4.0-4.4, Average 3.5-3.9, Below Average <3.5)
- Create price categories (Budget <$10, Mid-range $10-20, Premium >$20)

### 4. **Publishing Performance Calculations**

- Create Review Engagement Score: `=Reviews/1000` (thousands of reviews)
- Create Price-Rating Ratio: `=Price/User_Rating`
- Create Popular Book Categories: `=IF(Reviews>=10000,"Highly Popular",IF(Reviews>=1000,"Popular","Moderate"))`
- Handle calculation errors with proper error handling

**Deliverable:** Cleaned publishing dataset with market metrics validation report

---

### **Day 3: Advanced Publishing Formulas & Market Analysis**

**Focus: Complex Publishing Calculations & Genre Segmentation**

### 1. **Book Performance Classification**

- Create book success categories:
    
    ```
    =IF(AND(User_Rating>=4.5,Reviews>=5000),"Blockbuster",IF(AND(User_Rating>=4.0,Reviews>=1000),"Hit",IF(User_Rating>=3.5,"Moderate Success","Underperformer")))
    
    ```
    
- Calculate genre dominance indicators using multiple metrics
- Create market effectiveness scores by year

### 2. **Author Performance Analysis**

- Count books per author: `=COUNTIF($Author:$Author,Author)`
- Categorize authors by market presence:
    
    ```
    =IF(Book_Count>=5,"Bestselling Author",IF(Book_Count>=3,"Established Author",IF(Book_Count>=2,"Recurring Author","New Author")))
    
    ```
    

### 3. **Genre Performance Metrics**

- Average rating per genre: `=AVERAGEIF($Genre:$Genre,Genre,User_Rating)`
- Total reviews per genre: `=SUMIF($Genre:$Genre,Genre,Reviews)`
- Genre market share calculations using `=COUNTIF()` and relative percentages

### 4. **Temporal Performance Analytics**

- Calculate yearly trends: `=AVERAGEIF($Year:$Year,Year,User_Rating)`
- Year-wise price analysis: `=AVERAGEIF($Year:$Year,Year,Price)`
- Use `=VLOOKUP()` for year-over-year comparison mapping

**Deliverable:** Publishing genre performance analysis with author segmentation

---

### **Day 4: Publishing Pivot Tables & Dynamic Market Analysis**

**Focus: Interactive Publishing Intelligence Analysis**

### 1. **Genre Performance Pivot Tables**

- Rating and review performance by genre over time
- Average prices by genre and year
- Book volume patterns by genre
- Add slicers for interactive genre and year filtering

### 2. **Author Success Pivot Tables**

- Top authors by total reviews and average ratings
- Author performance across different years
- Multi-genre author analysis
- Author market longevity assessment

### 3. **Time Series Publishing Analysis**

- Yearly bestseller trends using pivot tables
- Genre popularity shifts over the decade
- Year-over-year market growth analysis
- Peak publishing periods identification

### 4. **Market Performance Analysis**

- Price vs rating correlation by genre and year
- High vs low performing books comparison
- Review volume impact on bestseller status
- Market saturation analysis by genre

**Deliverable:** Interactive publishing intelligence pivot table system

---

### **Day 5: Publishing Dashboards & Market Visualization**

**Focus: Publishing Data Visualization & Industry Storytelling**

### 1. **Executive Publishing Dashboard Creation**

- Key publishing performance indicators (KPIs):
    - Total books, average rating, total reviews, and market trends
- Rating and price trend charts over time
- Top performing genres and authors leaderboards
- Dynamic filtering by genre and time period

### 2. **Genre Market Insights Visualizations**

- Genre distribution pie charts across years
- Rating vs review volume scatter plots
- Price comparison by genre heatmap
- Genre market evolution trends over time

### 3. **Author Performance Dashboard**

- Author success rankings (using conditional formatting)
- Multi-year author performance comparison
- New vs established author analysis
- Author genre specialization patterns

### 4. **Interactive Publishing Elements**

- Add form controls for dynamic filtering by genre and year
- Create dependent dropdown lists for author analysis
- Implement conditional formatting for performance indicators
- Add data validation for market metric inputs

**Deliverable:** Comprehensive publishing industry business intelligence dashboard

---

### **Day 6: Market Insights & Publishing Presentation**

**Focus: Professional Publishing Reporting & Industry Communication**

### 1. **Publishing Executive Summary Creation**

- Key market findings and genre performance insights
- Author portfolio recommendations
- Market trend opportunities
- Publishing strategy optimization recommendations

### 2. **Industry Presentation Materials**

- Create PowerPoint presentation with key publishing insights
- Include screenshots of interactive Excel publishing dashboard
- Prepare speaker notes for publishing industry stakeholder presentation
- Design professional market performance visualizations

### 3. **Publishing Documentation & Validation**

- Complete publishing formula documentation
- Create user guide for publishing dashboard
- Validate all market calculations using Excel's audit tools
- Final publishing intelligence quality assurance

### 4. **Final Market Review & Optimization**

- Performance optimization of publishing workbook
- Error checking and correction
- Create final publishing analytics backup
- Prepare executive submission package

**Deliverable:** Complete publishing industry intelligence project package with presentation

---

## 🔧 **Technical Requirements**

### **Essential Excel Skills Applied:**

- Core functions: `SUM`, `AVERAGE`, `COUNTIF`, `COUNTIFS`, `SUMIFS`, `AVERAGEIF`
- Text functions: `TRIM`, `PROPER`, `LEN`, `SUBSTITUTE`
- Lookup functions: `VLOOKUP`, `INDEX-MATCH`
- Date functions: `YEAR`, date arithmetic for time series analysis
- Mathematical functions: Percentage calculations, ratio analysis
- Conditional formatting and data validation
- Pivot tables with slicers and calculated fields
- Interactive charts and dynamic publishing dashboards

### **Publishing Data Cleaning Techniques:**

- Book title standardization using built-in Excel tools
- Missing market metric handling with conditional logic
- Author name standardization using TEXT-TO-COLUMNS
- Rating and price data validation and error handling
- Genre data normalization

---

## 📈 **Key Performance Indicators (KPIs)**

### **Primary Publishing Metrics:**

1. **Average Market Rating:** Overall rating across all bestselling books
2. **Genre Market Share:** Percentage distribution of Fiction vs Non-Fiction
3. **Review Engagement Rate:** Average reviews per bestselling book
4. **Price Point Analysis:** Average price trends across genres and years
5. **Author Repeat Rate:** Percentage of authors with multiple bestsellers

### **Secondary Publishing Metrics:**

- Year-over-year rating trends
- Genre-specific price optimization
- Author longevity in bestseller lists
- Market saturation indicators by genre
- Seasonal publishing patterns

---

## 🎯 **Assessment Criteria**

### **Excel Workbook Output (60%)**

- **Data Cleaning Completeness (20%):** Proper use of TRIM, duplicate handling, publishing data validation
- **Formula Accuracy (20%):** Correct implementation of VLOOKUP, SUMIFS, COUNTIFS, market calculations
- **Pivot Table Sophistication (10%):** Advanced pivot tables with slicers and publishing calculated fields
- **Dashboard Functionality (10%):** Interactive elements, charts, and professional publishing formatting

### **Presentation Quality (40%)**

- **Market Insight (15%):** Quality of analysis and findings relevant to publishing industry performance
- **Visual Communication (15%):** Clarity of publishing charts, professional design, effective industry storytelling
- **Technical Understanding (10%):** Demonstration of Excel skills and publishing methodology explanation

---

## 📚 **Expected Business Insights**

### **Genre Analysis:**

- Fiction vs Non-Fiction market dominance trends
- Genre-specific pricing strategies effectiveness
- Reader preference evolution over the decade

### **Author Success Patterns:**

- Characteristics of multi-year bestselling authors
- New author breakthrough patterns
- Genre specialization vs diversification success

### **Market Evolution:**

- Digital transformation impact on pricing (2009-2019)
- Review culture growth and its market influence
- Quality vs popularity correlation analysis

### **Strategic Recommendations:**

- Optimal pricing strategies by genre
- Author development investment priorities
- Market timing for different book categories

---

*This project represents the culmination of Phase 1 PORA Academy training, demonstrating mastery of Excel-based data analysis for publishing industry applications. Students who successfully complete this project will understand market trends, author performance patterns, and genre dynamics in the digital publishing landscape, preparing them for Phase 2 (SQL/Python) training with strong foundations in business analytics.*