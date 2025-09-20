# Week 5: Date & Time Operations - Datasets Overview

This folder contains the CSV datasets used in Week 5 Python classes for learning DateTime operations and temporal analysis.

## Dataset Files

### 1. olist_orders_dataset.csv
**Source**: Based on Brazilian Olist E-commerce data (simplified for learning)
**Records**: 50 orders
**Columns**:
- `order_id`: Unique order identifier
- `customer_id`: Customer identifier
- `order_status`: Order status (delivered, shipped, cancelled)
- `order_purchase_timestamp`: When the order was placed
- `order_approved_at`: When the order was approved
- `order_delivered_carrier_date`: When carrier picked up the order
- `order_delivered_customer_date`: When customer received the order
- `order_estimated_delivery_date`: Initially estimated delivery date

**Use Cases**: Basic datetime operations, date extraction, temporal grouping

### 2. olist_order_items_dataset.csv
**Source**: Based on Brazilian Olist E-commerce order items data
**Records**: 50 order items
**Columns**:
- `order_id`: Links to orders dataset
- `order_item_id`: Item number within order
- `product_id`: Product identifier
- `seller_id`: Seller identifier
- `shipping_limit_date`: Latest shipping date
- `price`: Item price
- `freight_value`: Shipping cost

**Use Cases**: Date arithmetic, calculating shipping deadlines, pricing analysis over time

### 3. customer_purchase_patterns.csv
**Source**: Synthesized from Brazilian e-commerce patterns
**Records**: 50 customers
**Columns**:
- `customer_id`: Customer identifier
- `customer_city`: Customer city
- `customer_state`: Brazilian state (SP, RJ, MG, etc.)
- `first_purchase_date`: Customer's first order date
- `last_purchase_date`: Customer's most recent order date
- `total_orders`: Number of orders placed
- `total_spent`: Total amount spent
- `avg_days_between_orders`: Average time between orders
- `preferred_month`: Month with most orders
- `seasonal_pattern`: Customer behavior type

**Use Cases**: Customer lifecycle analysis, seasonal pattern detection, time-based customer segmentation

### 4. naija_commerce_orders.csv
**Source**: Synthesized Nigerian e-commerce data
**Records**: 50 orders across Nigerian cities
**Columns**:
- `order_id`: Order identifier (NC format)
- `customer_id`: Customer identifier
- `customer_city`: Nigerian city
- `customer_state`: Nigerian state
- `order_date`: When order was placed
- `delivery_date`: When order was delivered
- `order_status`: Order status
- `total_amount`: Order value in Naira
- `payment_method`: Payment type (bank_transfer, card, ussd)
- `product_category`: Product type
- `seasonal_event`: Nigerian seasonal context

**Use Cases**: Nigerian business context analysis, local seasonal patterns, payment method trends

### 5. delivery_performance.csv
**Source**: Synthesized delivery performance data
**Records**: 50 delivery records
**Columns**:
- `order_id`: Order identifier
- `order_date`: Order placement date
- `promised_delivery_date`: Initially promised delivery
- `actual_delivery_date`: Actual delivery date
- `delivery_city`: Nigerian delivery city
- `delivery_state`: Nigerian state
- `delivery_status`: Performance vs promise (early, on_time, late)
- `delivery_days`: Actual days to deliver
- `promised_days`: Originally promised days
- `performance_rating`: Delivery performance rating

**Use Cases**: Time difference calculations, performance analysis, SLA tracking

## Learning Objectives Supported

### Part 1: DateTime Fundamentals
- Loading CSV data with datetime columns
- Converting string dates to datetime objects
- Extracting date components (year, month, day, hour)
- Basic temporal filtering and grouping

### Part 2: Advanced Temporal Analysis
- Date arithmetic and timedelta calculations
- Seasonal pattern analysis
- Customer behavior over time
- Business performance metrics

## Business Context

These datasets help students understand:
1. **E-commerce Operations**: Order lifecycle, delivery logistics
2. **Customer Analytics**: Purchase patterns, seasonal behavior
3. **Nigerian Market**: Local payment methods, seasonal events, geographic spread
4. **Performance Metrics**: Delivery performance, customer satisfaction

## Data Quality Notes

- All dates are properly formatted for pandas datetime parsing
- Missing values (NaT) are included for realistic data handling practice
- Nigerian cities and states are authentic for cultural relevance
- Seasonal events reflect actual Nigerian business calendar
- Price ranges and patterns reflect realistic e-commerce data

## Usage in Lessons

Students will progressively work through:
1. **Basic loading and exploration** (olist_orders_dataset.csv)
2. **Date component extraction** (all datasets)
3. **Time-based aggregations** (customer_purchase_patterns.csv)
4. **Local business context** (naija_commerce_orders.csv)
5. **Performance calculations** (delivery_performance.csv)

This progression mirrors the SQL content taught on Thursdays while providing hands-on Python practice with realistic business scenarios.