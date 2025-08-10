# Supply-Chain and Logistics Analysis Project

# Phase 1 Capstone: Logistics & Customer Service Business Intelligence System

---

### 📋 **Project Overview**

**Duration:** 6 Days

**Dataset:** E-Commerce Shipping Data (10,999 records)

**Data Source:** https://www.kaggle.com/datasets/prachi13/customer-analytics

**Tools:** Microsoft Excel (Advanced Functions, Pivot Tables, Charts)

**Objective:** Build a comprehensive e-commerce shipping performance analysis system using advanced Excel techniques to optimise delivery operations and customer satisfaction

---

### 🎯 **Learning Objectives**

By completing this project, students will:

- Master advanced data cleaning techniques in Excel for logistics and shipping data
- Apply complex formulas and functions (SUM, AVERAGE, COUNTIF, VLOOKUP, SUMIFS) to shipping performance analytics
- Create interactive dashboards using pivot tables and charts for delivery operations tracking
- Develop skills in customer service optimisation and logistics business intelligence
- Build presentation-ready visualisations for supply chain and operations management stakeholders

---

### 📊 **Dataset Information**

**E-Commerce Shipping Data:**

- **Records:** 10,999 customer shipping transactions
- **Business Context:** E-commerce platform focused on shipping performance and delivery optimization
- **Objective:** Predict whether products will be delivered on time and analyze factors affecting delivery performance
- **Industry Focus:** Logistics, supply chain management, and customer service operations

**Key Columns:**

- `ID` - Unique transaction identifier
- `Warehouse_block` - Warehouse section (A, B, C, D, F)
- `Mode_of_Shipment` - Shipping method (Ship, Flight, Road)
- `Customer_care_calls` - Number of customer service calls made
- `Customer_rating` - Customer satisfaction rating (1-5 scale)
- `Cost_of_the_Product` - Product cost in USD
- `Prior_purchases` - Number of previous purchases by customer
- `Product_importance` - Product priority level (low, medium, high)
- `Gender` - Customer gender (M/F)
- `Discount_offered` - Discount percentage applied
- `Weight_in_gms` - Product weight in grams
- `Reached.on.Time_Y.N` - On-time delivery status (0=No, 1=Yes)

---

## 📅 **Daily Schedule & Tasks**

### **Day 1: Data Import & Shipping Data Exploration**

**Focus: Logistics Data Familiarisation & Setup**

### 1. **Data Import & Setup**

- Download the e-commerce shipping dataset from Kaggle
- Import CSV into Excel using Data → Get Data
- Set up proper data types (Cost as Currency, Weight as Number, Rating as Number)
- Create a backup copy on a separate worksheet

### 2. **Initial Shipping Data Exploration**

- Use `=ROWS()` to count total shipments
- Use `=COLUMNS()` to verify column count
- Create shipping summary statistics table:
    - Total shipments: `=COUNT(A:A)`
    - On-time delivery rate: `=AVERAGE(Reached_on_Time_Column)*100`
    - Average customer rating: `=AVERAGE(Customer_rating_Column)`
    - Average product cost: `=AVERAGE(Cost_of_the_Product_Column)`

### 3. **Logistics Data Quality Assessment**

- Check for missing values in critical columns using `=COUNTBLANK()`
- Identify incomplete shipping records using conditional formatting
- Create a data quality report with:
    - Missing value count per logistics metric
    - Shipment completeness summary
    - Basic delivery performance statistics

**Deliverable:** Shipping data import verification report + logistics data quality assessment

---

### **Day 2: Shipping Data Cleaning & Operations Standardisation**

**Focus: Advanced Logistics Data Cleaning Techniques**

### 1. **Shipping and Customer Data Cleaning**

- Clean warehouse identifiers:
    - Remove extra spaces: `=TRIM()`
    - Standardise warehouse block formats
- Clean shipping information:
    - Standardise the mode of shipment: `=PROPER()`
    - Handle inconsistent shipping method naming
    - Normalise product importance classifications

### 2. **Delivery Data Validation & Duplicates**

- Identify duplicate shipments (same ID or customer with identical orders)
- Create a duplicate detection formula: `=COUNTIFS($ID:$ID,ID)>1`
- Remove duplicate shipment records using Data → Remove Duplicates
- Validate delivery performance data integrity post-cleaning

### 3. **Performance Data Standardization**

- Validate customer rating ranges (1-5)
- Handle discount percentage inconsistencies
- Create customer service call categories (No Calls, Low 1-2, Medium 3-4, High 5+)
- Create weight categories (Light <500g, Medium 500-2000g, Heavy >2000g)

### 4. **Shipping Performance Calculations**

- Create Delivery Success Rate: `=IF(Reached_on_Time=1,"On Time","Delayed")`
- Create Customer Experience Score: `=(Customer_rating*2)-(Customer_care_calls*0.5)`
- Create Product Value Tier: `=IF(Cost_of_the_Product>=200,"High Value",IF(Cost_of_the_Product>=100,"Medium Value","Low Value"))`
- Handle calculation errors with proper error handling

**Deliverable:** Cleaned shipping dataset with logistics metrics validation report

---

### **Day 3: Advanced Shipping Formulas & Performance Analysis**

**Focus: Complex Logistics Calculations & Service Segmentation**

### 1. **Delivery Performance Classification**

- Create shipping efficiency categories:
    
    ```python
    =IF(AND(Reached_on_Time=1,Customer_care_calls<=1),"Excellent Delivery",IF(AND(Reached_on_Time=1,Customer_care_calls<=3),"Good Delivery",IF(Reached_on_Time=1,"Average Delivery","Poor Delivery")))
    
    ```
    
- Calculate warehouse performance indicators using multiple metrics
- Create customer satisfaction effectiveness scores

### 2. **Customer Service Segmentation**

- Count shipments per customer: `=COUNTIF($ID:$ID,ID)` (If customer ID is available)
- Categorise customers by service interaction:
    
    ```r
    =IF(Customer_care_calls=0,"Self-Service Customer",IF(Customer_care_calls<=2,"Low-Touch Customer",IF(Customer_care_calls<=4,"Medium-Touch Customer","High-Touch Customer")))
    
    ```
    

### 3. **Warehouse Performance Metrics**

- Average delivery rate per warehouse: `=AVERAGEIF($Warehouse_block:$Warehouse_block,Warehouse_block,Reached_on_Time)`
- Cost efficiency by warehouse: `=AVERAGEIF($Warehouse_block:$Warehouse_block,Warehouse_block,Cost_of_the_Product)`
- Service call analysis by the warehouse using `=SUMIF()` and `=AVERAGEIF()`

### 4. **Shipping Method Analytics**

- Calculate mode performance: `=AVERAGEIF($Mode_of_Shipment:$Mode_of_Shipment,Mode_of_Shipment,Reached_on_Time)`
- Gender-based shipping preferences: `=COUNTIFS($Gender:$Gender,"M",$Mode_of_Shipment:$Mode_of_Shipment,Mode_of_Shipment)`
- Use `=VLOOKUP()` for shipping method cost mapping

**Deliverable:** E-commerce shipping performance analysis with customer service segmentation

---

### **Day 4: Shipping Pivot Tables & Dynamic Logistics Analysis**

**Focus: Interactive Logistics Intelligence Analysis**

### 1. **Delivery Performance Pivot Tables**

- On-time delivery rates by warehouse and shipping method
- Customer satisfaction ratings by delivery performance
- Service call frequency patterns by shipping mode
- Add slicers for interactive warehouse and method filtering

### 2. **Customer Service Pivot Tables**

- Customer care call analysis by product importance and delivery status
- Rating distribution by shipping method and warehouse
- Gender-based shipping preferences and satisfaction levels
- Prior purchase impact on delivery expectations

### 3. **Warehouse Operations Analysis**

- Warehouse efficiency comparison using pivot tables
- Product weight vs delivery performance correlation
- Discount impact on customer service interactions
- Product importance vs delivery success rates

### 4. **Cost and Efficiency Analysis**

- Shipping cost vs delivery performance by method
- Weight optimization opportunities by warehouse
- Customer service cost analysis (calls vs satisfaction)
- Product value vs shipping method selection

**Deliverable:** Interactive shipping operations business intelligence pivot table system

---

### **Day 5: Logistics Dashboards & Shipping Performance Visualization**

**Focus: Supply Chain Data Visualization & Operations Storytelling**

### 1. **Executive Logistics Dashboard Creation**

- Key shipping performance indicators (KPIs):
    - On-time delivery rate, average customer rating, service call volume, and cost efficiency
- Delivery performance trend charts by warehouse and method
- Top performing warehouses and shipping methods leaderboards
- Dynamic filtering by product importance, weight, and time period

### 2. **Customer Service Insights Visualizations**

- Customer satisfaction distribution pie charts
- Service calls vs delivery performance scatter plots
- Warehouse performance heatmap
- Shipping method effectiveness comparison charts

### 3. **Operations Performance Dashboard**

- Warehouse efficiency comparison (using conditional formatting)
- Shipping method cost-benefit analysis
- Product weight vs delivery success correlation
- Customer service optimization recommendations

### 4. **Interactive Logistics Elements**

- Add form controls for dynamic filtering by warehouse and shipping method
- Create dependent dropdown lists for product importance analysis
- Implement conditional formatting for performance indicators
- Add data validation for operational metric inputs

**Deliverable:** Comprehensive logistics and shipping business intelligence dashboard

---

### **Day 6: Operations Insights & Logistics Presentation**

**Focus: Professional Supply Chain Reporting & Stakeholder Communication**

### 1. **Logistics Executive Summary Creation**

- Key shipping performance findings and warehouse efficiency insights
- Customer service optimization recommendations
- Delivery method effectiveness analysis
- Cost reduction and service improvement strategies

### 2. **Supply Chain Presentation Materials**

- Create PowerPoint presentation with key logistics insights
- Include screenshots of interactive Excel shipping dashboard
- Prepare speaker notes for supply chain stakeholder presentation
- Design professional operations performance visualizations

### 3. **Logistics Documentation & Validation**

- Complete shipping formula documentation
- Create user guide for logistics dashboard
- Validate all operational calculations using Excel's audit tools
- Final logistics intelligence quality assurance

### 4. **Final Operations Review & Optimization**

- Performance optimization of shipping workbook
- Error checking and correction
- Create final logistics analytics backup
- Prepare executive submission package

**Deliverable:** Complete logistics and shipping intelligence project package with presentation

---

## 🔧 **Technical Requirements**

### **Essential Excel Skills Applied:**

- Core functions: `SUM`, `AVERAGE`, `COUNTIF`, `COUNTIFS`, `SUMIFS`, `AVERAGEIF`
- Text functions: `TRIM`, `PROPER`, `LEN`, `SUBSTITUTE`
- Lookup functions: `VLOOKUP`, `INDEX-MATCH`
- Logical functions: `IF`, `AND`, `OR` for delivery status analysis
- Mathematical functions: Percentage calculations, efficiency ratios
- Conditional formatting and data validation
- Pivot tables with slicers and calculated fields
- Interactive charts and dynamic logistics dashboards

### **Shipping Data Cleaning Techniques:**

- Warehouse data standardization using built-in Excel tools
- Missing delivery metric handling with conditional logic
- Shipping method standardization using TEXT-TO-COLUMNS
- Performance data validation and error handling
- Customer service data normalization

---

## 📈 **Key Performance Indicators (KPIs)**

### **Primary Logistics Metrics:**

1. **On-Time Delivery Rate:** Percentage of shipments delivered on schedule
2. **Customer Satisfaction Score:** Average customer rating across all shipments
3. **Service Call Rate:** Average customer care calls per shipment
4. **Warehouse Efficiency:** Delivery success rate by warehouse location
5. **Shipping Method Effectiveness:** Performance comparison across delivery modes

### **Secondary Logistics Metrics:**

- Cost per delivery by shipping method
- Weight optimization efficiency
- Customer service resolution rate
- Product importance vs delivery prioritization
- Gender-based shipping preferences

---

## 🎯 **Assessment Criteria**

### **Excel Workbook Output (60%)**

- **Data Cleaning Completeness (20%):** Proper use of TRIM, duplicate removal, shipping data validation
- **Formula Accuracy (20%):** Correct implementation of VLOOKUP, SUMIFS, COUNTIFS, logistics calculations
- **Pivot Table Sophistication (10%):** Advanced pivot tables with slicers and shipping calculated fields
- **Dashboard Functionality (10%):** Interactive elements, charts, and professional logistics formatting

### **Presentation Quality (40%)**

- **Business Insight (15%):** Quality of analysis and findings relevant to shipping and logistics performance
- **Visual Communication (15%):** Clarity of logistics charts, professional design, effective supply chain storytelling
- **Technical Understanding (10%):** Demonstration of Excel skills and logistics methodology explanation

---

## 🚚 **Expected Business Insights**

### **Delivery Optimization:**

- Most efficient warehouse locations and shipping methods
- Factors affecting on-time delivery performance
- Weight and product type impact on delivery success

### **Customer Service Enhancement:**

- Correlation between delivery issues and service calls
- Customer satisfaction drivers in shipping operations
- Service call reduction strategies

### **Cost Efficiency:**

- Shipping method cost-benefit analysis
- Warehouse operational efficiency comparison
- Product importance vs shipping investment optimization

### **Strategic Recommendations:**

- Warehouse capacity and location optimization
- Shipping method selection criteria
- Customer service resource allocation
- Delivery performance improvement initiatives

---

*This project represents the culmination of Phase 1 PORA Academy training, demonstrating mastery of Excel-based data analysis for logistics and shipping operations. Students who successfully complete this project will understand delivery performance optimization, customer service analytics, and supply chain efficiency metrics, preparing them for Phase 2 (SQL/Python) training with strong foundations in operations analytics.*