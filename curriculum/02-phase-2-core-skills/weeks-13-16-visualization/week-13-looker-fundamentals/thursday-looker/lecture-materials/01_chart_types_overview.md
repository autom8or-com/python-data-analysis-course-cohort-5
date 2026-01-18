# Chart Types Overview - Looker Studio Fundamentals

**Week 13 - Thursday Session | Hour 1 (0-15 minutes)**
**Business Context:** Understanding when and how to use different visualization types for Nigerian e-commerce analysis

---

## Learning Objectives

By the end of this section, you will be able to:
- Identify all 17+ chart types available in Looker Studio
- Understand the purpose and use case for each chart type
- Map SQL aggregation patterns to appropriate visualizations
- Select the right chart type based on your data story

---

## Overview: The Visualization Toolkit

Looker Studio provides a comprehensive set of visualization options. Choosing the right chart is like choosing the right tool - you wouldn't use a hammer to tighten a screw. Each chart type tells a specific kind of story with your data.

### Excel to Looker Studio Mindset Shift

**Excel Approach:**
- Limited chart types (Bar, Line, Pie, Scatter)
- Manual data selection and range specification
- Static charts that don't update automatically

**Looker Studio Approach:**
- 17+ specialized chart types for different scenarios
- Dynamic charts that update with data changes
- Interactive filters and drill-down capabilities
- Mobile-responsive and shareable dashboards

---

## Chart Type Categories

### 1. METRIC DISPLAYS (Single Number Focus)

#### 1.1 Scorecard
**Purpose:** Display a single key metric prominently
**When to Use:** KPIs, headline numbers, summary statistics

**SQL Pattern:**
```sql
SELECT SUM(price) as total_revenue
FROM olist_sales_data_set.olist_order_items_dataset;
```

**Business Examples:**
- Total Revenue: NGN 45,250,000
- Total Orders: 15,432
- Average Order Value: NGN 2,932
- Customer Count: 8,765

**Nigerian Context:** Perfect for displaying monthly sales targets, VAT collected (7.5%), or total customers acquired.

---

#### 1.2 Gauge Chart
**Purpose:** Show progress toward a goal or range
**When to Use:** Performance against targets, capacity utilization

**SQL Pattern:**
```sql
SELECT
    SUM(price) as current_revenue,
    500000 as revenue_target
FROM olist_sales_data_set.olist_order_items_dataset
WHERE EXTRACT(MONTH FROM order_purchase_timestamp) = EXTRACT(MONTH FROM CURRENT_DATE);
```

**Business Examples:**
- Monthly revenue vs target (NGN 3.2M / NGN 5M)
- Fulfillment rate (85% of target)
- Customer satisfaction score (4.2 / 5.0)

---

#### 1.3 Bullet Chart
**Purpose:** Compare actual vs target with context ranges
**When to Use:** Performance tracking with good/warning/critical zones

**Business Examples:**
- Sales performance with below-target, on-target, above-target ranges
- Delivery time performance (excellent < 3 days, good 3-5 days, poor > 5 days)

---

### 2. TIME-BASED VISUALIZATIONS (Trend Analysis)

#### 2.1 Time Series (Line Chart)
**Purpose:** Show trends and patterns over time
**When to Use:** Daily/weekly/monthly trends, seasonality analysis

**SQL Pattern:**
```sql
SELECT
    DATE_TRUNC('month', order_purchase_timestamp) as order_month,
    SUM(price) as monthly_revenue
FROM olist_sales_data_set.olist_order_items_dataset
GROUP BY DATE_TRUNC('month', order_purchase_timestamp)
ORDER BY order_month;
```

**Business Examples:**
- Monthly revenue trends for 2025
- Daily order volume during December shopping season
- Weekly customer acquisition trends

**Nigerian Context:** Track sales during key periods (Eid, Christmas, Black Friday, Jumia Anniversary sales)

---

#### 2.2 Area Chart
**Purpose:** Time series with emphasis on volume/magnitude
**When to Use:** Cumulative values, stacked categories over time

**SQL Pattern:**
```sql
SELECT
    DATE_TRUNC('month', order_purchase_timestamp) as order_month,
    product_category_name,
    SUM(price) as category_revenue
FROM olist_sales_data_set.olist_order_items_dataset oi
JOIN olist_sales_data_set.olist_products_dataset p ON oi.product_id = p.product_id
GROUP BY order_month, product_category_name
ORDER BY order_month;
```

**Business Examples:**
- Stacked revenue by product category over time
- Cumulative order count year-to-date

---

#### 2.3 Combo Chart
**Purpose:** Combine line and bar charts for dual metrics
**When to Use:** Comparing metrics with different scales (revenue vs order count)

**Business Example:**
- Bars: Monthly revenue (NGN millions)
- Line: Average order value (NGN thousands)

---

### 3. COMPARISON VISUALIZATIONS (Category Analysis)

#### 3.1 Bar Chart (Horizontal)
**Purpose:** Compare values across categories
**When to Use:** Category comparisons, rankings with long labels

**SQL Pattern:**
```sql
SELECT
    customer_state,
    COUNT(DISTINCT customer_id) as customer_count
FROM olist_sales_data_set.olist_customers_dataset
GROUP BY customer_state
ORDER BY customer_count DESC
LIMIT 10;
```

**Business Examples:**
- Revenue by Nigerian state (Lagos, Abuja, Kano, Rivers...)
- Orders by product category
- Top 10 cities by customer count

**Why Horizontal?** Better for long category names like "Computer Accessories" or Nigerian city names.

---

#### 3.2 Column Chart (Vertical)
**Purpose:** Compare values across categories (short labels)
**When to Use:** Time periods (months, quarters), short category names

**SQL Pattern:**
```sql
SELECT
    EXTRACT(MONTH FROM order_purchase_timestamp) as month_number,
    COUNT(*) as order_count
FROM olist_sales_data_set.olist_orders_dataset
WHERE EXTRACT(YEAR FROM order_purchase_timestamp) = 2025
GROUP BY month_number
ORDER BY month_number;
```

**Business Examples:**
- Monthly sales comparison (Jan, Feb, Mar...)
- Quarterly revenue (Q1, Q2, Q3, Q4)
- Daily order volume for last 7 days

---

#### 3.3 Stacked Bar/Column Chart
**Purpose:** Show composition AND comparison
**When to Use:** Part-to-whole relationships across categories

**SQL Pattern:**
```sql
SELECT
    customer_state,
    payment_type,
    SUM(payment_value) as total_payment
FROM olist_sales_data_set.olist_customers_dataset c
JOIN olist_sales_data_set.olist_orders_dataset o ON c.customer_id = o.customer_id
JOIN olist_sales_data_set.olist_order_payments_dataset p ON o.order_id = p.order_id
GROUP BY customer_state, payment_type;
```

**Business Examples:**
- Revenue by state, broken down by payment method (card, transfer, cash)
- Orders by category, split by delivery status

---

### 4. PROPORTION VISUALIZATIONS (Part-to-Whole)

#### 4.1 Pie Chart
**Purpose:** Show percentage distribution of a whole
**When to Use:** 3-6 categories maximum, simple proportion stories

**SQL Pattern:**
```sql
SELECT
    payment_type,
    SUM(payment_value) as total_value
FROM olist_sales_data_set.olist_order_payments_dataset
GROUP BY payment_type;
```

**Business Examples:**
- Payment method distribution (50% Card, 30% Transfer, 20% Cash)
- Order status breakdown
- Revenue by top 5 product categories

**Important:** Avoid pie charts with > 6 slices - use bar chart instead.

---

#### 4.2 Donut Chart
**Purpose:** Pie chart with center space for total or metric
**When to Use:** Same as pie chart, with additional context in center

**Business Example:**
- Payment distribution with total revenue in center: NGN 125M

---

#### 4.3 Treemap
**Purpose:** Hierarchical proportions with nested rectangles
**When to Use:** Product categories, geographic drill-down, > 6 categories

**SQL Pattern:**
```sql
SELECT
    product_category_name,
    COUNT(*) as product_count,
    SUM(price) as category_revenue
FROM olist_sales_data_set.olist_products_dataset p
JOIN olist_sales_data_set.olist_order_items_dataset oi ON p.product_id = oi.product_id
GROUP BY product_category_name;
```

**Business Examples:**
- Revenue by category and subcategory
- Customer distribution by state and city
- Inventory by warehouse and product type

**Nigerian Context:** Show market share across Lagos LGAs or sales across states with nested city breakdown.

---

### 5. TABULAR DISPLAYS (Detailed Data)

#### 5.1 Table
**Purpose:** Display detailed data with multiple columns
**When to Use:** Detailed reports, lookup references, data exploration

**SQL Pattern:**
```sql
SELECT
    o.order_id,
    c.customer_city,
    o.order_purchase_timestamp,
    oi.price,
    o.order_status
FROM olist_sales_data_set.olist_orders_dataset o
JOIN olist_sales_data_set.olist_customers_dataset c ON o.customer_id = c.customer_id
JOIN olist_sales_data_set.olist_order_items_dataset oi ON o.order_id = oi.order_id
ORDER BY o.order_purchase_timestamp DESC
LIMIT 100;
```

**Business Examples:**
- Order transaction log
- Customer contact directory
- Product catalog with prices and stock

**Table Features in Looker Studio:**
- Sortable columns
- Conditional formatting (highlight high values)
- Heatmaps on numeric columns
- Row-level drill-down

---

#### 5.2 Pivot Table
**Purpose:** Cross-tabulation with row and column groupings
**When to Use:** Multi-dimensional analysis, Excel pivot table equivalents

**SQL Pattern (conceptual):**
```sql
-- Week 8 PIVOT concepts
SELECT
    customer_state,
    SUM(CASE WHEN payment_type = 'credit_card' THEN payment_value ELSE 0 END) as credit_card,
    SUM(CASE WHEN payment_type = 'boleto' THEN payment_value ELSE 0 END) as boleto,
    SUM(CASE WHEN payment_type = 'debit_card' THEN payment_value ELSE 0 END) as debit_card
FROM olist_sales_data_set.olist_order_payments_dataset p
JOIN olist_sales_data_set.olist_orders_dataset o ON p.order_id = o.order_id
JOIN olist_sales_data_set.olist_customers_dataset c ON o.customer_id = c.customer_id
GROUP BY customer_state;
```

**Business Examples:**
- Sales by state (rows) and product category (columns)
- Revenue by month (rows) and payment type (columns)

---

### 6. GEOGRAPHIC VISUALIZATIONS (Location-Based)

#### 6.1 Geo Map - Bubble Map
**Purpose:** Show metric intensity by location with sized markers
**When to Use:** Comparing values across locations

**SQL Pattern:**
```sql
SELECT
    customer_state,
    customer_city,
    geolocation_lat,
    geolocation_lng,
    COUNT(*) as order_count
FROM olist_sales_data_set.olist_customers_dataset c
JOIN olist_sales_data_set.olist_geolocation_dataset g
    ON c.customer_zip_code_prefix = g.geolocation_zip_code_prefix
GROUP BY customer_state, customer_city, geolocation_lat, geolocation_lng;
```

**Business Examples:**
- Order volume by city (larger bubbles = more orders)
- Revenue concentration across Nigerian states

---

#### 6.2 Geo Map - Filled (Choropleth)
**Purpose:** Color-coded regions showing metric intensity
**When to Use:** State/country-level comparisons, heat mapping

**Business Examples:**
- Revenue by state (darker = higher revenue)
- Customer density map of Nigeria

**Nigerian Context:** Map showing sales performance across all 36 states + FCT.

---

### 7. RELATIONSHIP VISUALIZATIONS (Connections)

#### 7.1 Scatter Plot
**Purpose:** Show relationship between two numeric variables
**When to Use:** Correlation analysis, outlier detection

**SQL Pattern:**
```sql
SELECT
    product_id,
    AVG(price) as avg_price,
    COUNT(*) as sales_volume
FROM olist_sales_data_set.olist_order_items_dataset
GROUP BY product_id;
```

**Business Examples:**
- Product price vs sales volume (does higher price mean lower sales?)
- Delivery time vs review score correlation
- Order value vs freight cost relationship

---

#### 7.2 Sankey Diagram
**Purpose:** Show flow between stages or categories
**When to Use:** Customer journey, funnel analysis, flow tracking

**Business Examples:**
- Order flow: Pending → Processing → Shipped → Delivered
- Customer journey: Visit → Add to Cart → Checkout → Purchase
- Payment method to order status flow

---

### 8. SPECIALIZED VISUALIZATIONS

#### 8.1 Waterfall Chart
**Purpose:** Show cumulative effect of sequential values
**When to Use:** P&L statements, variance analysis

**Business Example:**
- Revenue breakdown: Starting Revenue + New Orders - Refunds - Discounts = Net Revenue

---

#### 8.2 Candlestick Chart
**Purpose:** Financial data with open/close/high/low values
**When to Use:** Rarely in e-commerce, useful for price tracking over time

---

## Chart Selection Decision Tree

### Start Here: What story are you telling?

**1. "What is the current value?"**
→ Use: Scorecard, Gauge, or Bullet Chart

**2. "How is it changing over time?"**
→ Use: Time Series (Line), Area Chart, or Combo Chart

**3. "How do categories compare?"**
→ Use: Bar Chart (long labels) or Column Chart (short labels)

**4. "What's the composition?"**
→ Use: Pie Chart (3-6 items), Donut Chart, or Treemap (7+ items)

**5. "What are the details?"**
→ Use: Table or Pivot Table

**6. "Where is it happening?"**
→ Use: Geo Map (Bubble or Filled)

**7. "Are two variables related?"**
→ Use: Scatter Plot

**8. "What's the flow or journey?"**
→ Use: Sankey Diagram

---

## Looker Studio Chart Library Quick Reference

| Chart Type | Best For | Max Categories | SQL Skill Link |
|------------|----------|----------------|----------------|
| **Scorecard** | Single KPI | 1 metric | Week 4: Aggregations |
| **Gauge** | Progress to goal | 1 metric + target | Week 4: Aggregations |
| **Time Series** | Trends over time | Unlimited dates | Week 5: Date analysis |
| **Bar Chart** | Category comparison | < 20 categories | Week 4: GROUP BY |
| **Column Chart** | Time periods | < 12 periods | Week 4: GROUP BY |
| **Pie Chart** | Simple proportions | 3-6 slices | Week 4: Aggregations |
| **Treemap** | Complex hierarchies | 10-50 categories | Week 9: Hierarchies |
| **Table** | Detailed records | Unlimited rows | Week 1-3: SELECT |
| **Pivot Table** | Cross-tabulation | Varies | Week 8: Pivot concepts |
| **Geo Map** | Location analysis | 50-100 locations | Week 4: GROUP BY |
| **Scatter** | Correlations | 100-1000 points | Week 12: Statistics |
| **Sankey** | Process flow | 5-20 stages | Advanced queries |

---

## Common Chart Selection Mistakes

### Mistake 1: Using Pie Charts for Too Many Categories
**Problem:** 12-slice pie chart is unreadable
**Solution:** Use bar chart or treemap instead

### Mistake 2: Line Charts for Non-Sequential Data
**Problem:** Line chart for product categories (not a sequence)
**Solution:** Use bar chart for categorical comparisons

### Mistake 3: 3D Charts (Don't Use These!)
**Problem:** Distort perception, harder to read
**Solution:** Use 2D versions with good color choices

### Mistake 4: Wrong Comparison Direction
**Problem:** Vertical bar chart with long state names (text overlaps)
**Solution:** Use horizontal bar chart for better label readability

### Mistake 5: Geographic Data Without Maps
**Problem:** Table of states with revenue numbers
**Solution:** Use filled geo map for immediate pattern recognition

---

## Nigerian Business Context Examples

### E-Commerce Dashboard for Lagos-Based Retailer

**Scorecard Section:**
- Total Revenue (NGN)
- Order Count
- Average Order Value (AOV)
- Customer Lifetime Value (CLV)

**Trend Analysis:**
- Monthly revenue time series
- Daily order volume during festive periods

**Category Performance:**
- Bar chart: Revenue by product category
- Treemap: Product subcategory breakdown

**Geographic Analysis:**
- Filled map: Orders by Nigerian state
- Bubble map: Customer concentration in Lagos LGAs

**Operational Metrics:**
- Gauge: Delivery on-time percentage
- Table: Recent orders with status

---

## Hands-On Practice Scenarios

### Scenario 1: Executive Summary
**Need:** Quick overview for CEO
**Charts to Use:**
1. Scorecard: Total Monthly Revenue
2. Scorecard: Total Orders
3. Time Series: Revenue trend (last 6 months)
4. Bar Chart: Top 5 states by revenue

### Scenario 2: Product Manager Dashboard
**Need:** Category performance analysis
**Charts to Use:**
1. Treemap: Revenue by category and subcategory
2. Scatter: Price vs Sales Volume
3. Table: Top 20 products with metrics
4. Combo: Category revenue (bars) + order count (line)

### Scenario 3: Logistics Dashboard
**Need:** Delivery performance monitoring
**Charts to Use:**
1. Gauge: On-time delivery rate
2. Geo Map: Average delivery time by state
3. Time Series: Daily shipment volume
4. Sankey: Order status flow

---

## Connection to Wednesday's Session

**Wednesday:** You learned to create calculated fields and prepare data sources
**Today:** You're learning which visualization to apply to that prepared data

**Next Steps:**
- Hour 2: We'll create actual scorecards and time series charts
- Exercise: Build a complete dashboard using 4+ chart types

---

## Key Takeaways

1. **Match Chart to Data Story:** Every chart type serves a specific purpose
2. **Simplicity Wins:** Fewer chart types, clearer message
3. **SQL Skills Transfer:** Your aggregation and grouping knowledge directly applies
4. **Context Matters:** Nigerian business examples make data relatable
5. **Less is More:** 4 well-designed charts > 10 cluttered charts

---

## Screenshot Placeholders

**[SCREENSHOT 1: Looker Studio Chart Picker Menu]**
*Caption: Access all chart types from the toolbar - scorecard, time series, bar, pie, table, geo map*

**[SCREENSHOT 2: Chart Type Gallery]**
*Caption: Visual reference showing all 17+ chart types with example data*

**[SCREENSHOT 3: Before/After Comparison]**
*Caption: Wrong chart type (pie with 15 slices) vs Right chart type (bar chart)*

**[SCREENSHOT 4: Nigerian Dashboard Example]**
*Caption: Complete e-commerce dashboard using multiple chart types effectively*

---

## Additional Resources

- **Looker Studio Chart Documentation:** See official Google docs for detailed chart configurations
- **Data Visualization Best Practices:** Edward Tufte principles applied to dashboards
- **Color Theory Guide:** Accessible color palettes for Nigerian audiences
- **Chart Selection Flowchart:** Download printable reference guide

---

**Next Section:** Creating Scorecards and KPIs (02_creating_scorecards_kpis.md)

**Related SQL Concepts:**
- Week 4: Aggregate Functions (SUM, COUNT, AVG)
- Week 5: Date Functions (DATE_TRUNC, EXTRACT)
- Week 8: Advanced Aggregations (CASE, Pivot)
