# Week 7: Pandas Merging & Joining - Practice Exercises
**PORA Academy Cohort 5 - Phase 2**
**Topic**: Joining Data Sources with Pandas
**Duration**: Complete all exercises for homework

---

## Setup Instructions

```python
import pandas as pd
import numpy as np

# Load datasets
customers = pd.read_csv('datasets/customers.csv')
orders = pd.read_csv('datasets/orders.csv')
order_items = pd.read_csv('datasets/order_items.csv')
products = pd.read_csv('datasets/products.csv')
sellers = pd.read_csv('datasets/sellers.csv')
reviews = pd.read_csv('datasets/order_reviews.csv')
payments = pd.read_csv('datasets/payments.csv')

# Convert dates
orders['order_purchase_timestamp'] = pd.to_datetime(orders['order_purchase_timestamp'])
orders['order_delivered_customer_date'] = pd.to_datetime(orders['order_delivered_customer_date'])
reviews['review_creation_date'] = pd.to_datetime(reviews['review_creation_date'])
```

---

## Section 1: Basic Inner Merge Exercises

### Exercise 1.1: Orders with Customer Information
**Business Question**: "Show me orders from 2017 with customer city and state."

**Requirements**:
- Merge orders with customers using inner merge
- Filter for year 2017
- Include: order_id, order_purchase_timestamp, customer_city, customer_state
- Display first 20 results

**Expected output**: DataFrame with 4 columns, 20 rows

---

### Exercise 1.2: Product Orders Analysis
**Business Question**: "What products were ordered? Show categories and prices."

**Requirements**:
- Merge orders, order_items, and products (inner merge)
- Filter for delivered orders
- Calculate total_cost = price + freight_value
- Include: order_id, product_category_name, price, freight_value, total_cost
- Display first 30 results

**Expected output**: DataFrame with 5 columns

---

### Exercise 1.3: Seller Performance
**Business Question**: "Which sellers from São Paulo (SP) have made sales?"

**Requirements**:
- Merge sellers with order_items
- Filter for seller_state == 'SP'
- Group by seller_id, seller_city, seller_state
- Calculate: items_sold (count), total_revenue (sum of price)
- Sort by total_revenue descending

**Expected output**: DataFrame with seller metrics

---

## Section 2: Left Merge Exercises

### Exercise 2.1: Orders Without Reviews
**Business Question**: "Find delivered orders missing customer reviews."

**Requirements**:
- Use left merge: orders → reviews
- Filter for delivered orders
- Find where review_id is NaN
- Include: order_id, customer_id, order_purchase_timestamp, order_delivered_customer_date
- Display first 25 results

**Expected output**: DataFrame showing orders without reviews

---

### Exercise 2.2: Product Inventory Check
**Business Question**: "Which products have never been ordered?"

**Requirements**:
- Use left merge: products → order_items
- Find products where order_id is NaN
- Exclude products with NaN category
- Include: product_id, product_category_name, product_weight_g
- Display first 30 results

**Expected output**: DataFrame with never-ordered products

---

### Exercise 2.3: Review Completion Rate
**Business Question**: "Calculate review completion rate by customer state."

**Requirements**:
- Merge customers, orders (inner), reviews (left)
- Filter for delivered orders
- Group by customer_state
- Calculate: total_orders, orders_with_reviews, completion_rate_percentage
- Show states with >= 50 orders
- Sort by completion_rate descending

**Expected output**: DataFrame with completion metrics by state

---

## Section 3: Multi-DataFrame Merge Exercises

### Exercise 3.1: Complete Order Analysis
**Business Question**: "Analyze Rio de Janeiro (RJ) orders with full details."

**Requirements**:
- Merge: customers → orders → order_items → products → sellers
- Filter: customer_state == 'RJ' and order_status == 'delivered'
- Create column: is_local_seller (True if customer_state == seller_state)
- Include: customer_city, order_id, product_category_name, price, seller_state, is_local_seller
- Display first 40 results

**Expected output**: DataFrame with shipping analysis

---

### Exercise 3.2: Payment Analysis by Category
**Business Question**: "What payment methods are used for each product category?"

**Requirements**:
- Merge: products → order_items → orders → payments
- Filter for delivered orders
- Group by product_category_name and payment_type
- Calculate: total_orders (nunique), total_revenue (sum), avg_installments (mean)
- Show categories with >= 100 orders
- Sort by total_revenue descending

**Expected output**: DataFrame with payment preferences

---

### Exercise 3.3: Seller Performance with Reviews
**Business Question**: "Rank sellers by revenue and customer satisfaction."

**Requirements**:
- Merge: sellers → order_items → orders, then left merge reviews
- Filter for delivered orders
- Group by seller_id, seller_city, seller_state
- Calculate: total_orders, total_revenue, avg_review_score
- Include sellers with >= 20 orders
- Sort by total_revenue descending

**Expected output**: DataFrame with seller rankings

---

## Section 4: Advanced Exercises

### Exercise 4.1: Local vs Interstate Shipping
**Business Question**: "Compare local and interstate shipping performance."

**Requirements**:
- Merge: customers → orders → order_items → sellers, then left merge reviews
- Create shipping_type: 'Local' if states match, else 'Interstate'
- Filter for delivered orders
- Group by shipping_type
- Calculate: total_orders, total_revenue, avg_freight_cost, avg_review_score

**Expected output**: Comparison of shipping types

---

### Exercise 4.2: Product Category Deep Dive
**Business Question**: "Comprehensive report per product category."

**Requirements**:
- Merge: products → order_items → orders → payments (inner) → reviews (left)
- Filter: delivered orders, non-NaN categories
- Group by product_category_name
- Calculate:
  * total_orders (nunique on order_id)
  * total_items_sold (count)
  * total_revenue (sum of price)
  * avg_order_value (revenue / orders)
  * credit_card_orders (count where payment_type == 'credit_card')
  * avg_review_score (mean, handle NaN)
- Show top 15 by revenue

**Expected output**: Comprehensive category metrics

---

### Exercise 4.3: Customer Segmentation
**Business Question**: "Segment customers by purchase behavior."

**Requirements**:
- Merge: customers → orders → order_items, then left merge reviews
- Filter for delivered orders
- Group by customer_unique_id and customer_state
- Calculate:
  * total_orders (count unique)
  * total_spent (sum of price)
  * avg_review_score (mean)
  * customer_segment: 'Loyal' (3+ orders), 'Repeat' (2 orders), 'One-Time' (1 order)
- Display top 50 by total_spent

**Expected output**: Customer segmentation analysis

---

## Section 5: Challenge Exercises

### Challenge 5.1: Data Quality Report
**Business Question**: "Identify data quality issues across datasets."

**Requirements**:
- Find:
  * Orders without payment info (left merge, check NaN)
  * Orders without items (left merge, check NaN)
  * Delivered orders without reviews (left merge, check NaN)
- Create summary DataFrame with columns: issue_type, order_count
- Use pd.concat() or multiple analyses

**Expected output**: Data quality summary

---

### Challenge 5.2: Same-Day Multiple Orders
**Business Question**: "Find customers who placed multiple orders on the same day."

**Requirements**:
- Create purchase_date from order_purchase_timestamp (date only)
- Group by customer_id and purchase_date
- Filter groups with count > 1
- Show: customer_id, purchase_date, order_count, order_ids (as list)

**Hint**: Use `.agg()` with custom functions

**Expected output**: Same-day order patterns

---

### Challenge 5.3: Top Customer-Seller Pairs
**Business Question**: "Find most valuable customer-seller relationships."

**Requirements**:
- Merge: customers → orders → order_items → sellers
- Filter for delivered orders
- Group by customer_unique_id, customer_state, seller_id, seller_state
- Calculate: orders_together, total_revenue
- Filter pairs with >= 3 orders together
- Show top 25 by revenue

**Expected output**: Valuable relationship pairs

---

## Bonus Section

### Bonus 1: Monthly Revenue Trend
**Business Question**: "Monthly revenue trends for top 5 categories in 2017."

**Requirements**:
- Extract month from order_purchase_timestamp
- Merge: orders → order_items → products
- Filter: delivered orders, year 2017
- Find top 5 categories by total revenue
- Group by month and category
- Show monthly revenue for top categories

**Hint**: Use pd.to_datetime().dt.to_period('M')

---

### Bonus 2: Merge Indicator Analysis
**Business Question**: "Use merge indicator to find data mismatches."

**Requirements**:
- Outer merge orders and reviews with indicator=True
- Analyze _merge column values
- Show counts of: both, left_only, right_only
- Investigate records that are left_only or right_only

**Expected output**: Merge diagnostic report

---

## Submission Guidelines

1. **File Format**: Jupyter Notebook (.ipynb)
2. **Naming**: week7_python_solutions_yourname.ipynb
3. **Documentation**: Add markdown cells explaining approach
4. **Code Quality**: Clean, commented code
5. **Output**: Show results for each exercise

---

## Evaluation Criteria

- **Correctness**: Accurate merge operations (40%)
- **Merge Type Selection**: Appropriate inner/left/outer (25%)
- **Data Handling**: Proper NaN and duplicate management (15%)
- **Code Quality**: Readable, efficient pandas code (10%)
- **Completeness**: All required columns and calculations (10%)

---

## Resources

- Pandas merge documentation
- Lesson plan and notebook examples
- Office hours: Tuesday 6-7 PM, Friday 3-4 PM

**Good luck! Remember: The key to mastering merges is understanding the relationships between DataFrames and choosing the right merge type for your analysis.**
