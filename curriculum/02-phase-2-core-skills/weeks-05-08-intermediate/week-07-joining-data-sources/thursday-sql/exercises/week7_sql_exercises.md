## Week 7: SQL JOINs - Practice Exercises
**PORA Academy Cohort 5 - Phase 2**
**Topic**: Joining Data Sources with SQL
**Duration**: Complete all exercises for homework

---

### Instructions
- Complete all exercises using the Olist e-commerce database
- Write your SQL queries in a `.sql` file
- Test each query to ensure it returns meaningful results
- Pay attention to join types (INNER vs LEFT) based on requirements
- Add comments explaining your logic

---

## Section 1: Basic INNER JOIN Exercises

### Exercise 1.1: Orders with Customer Information
**Business Question**: "Show me the first 20 orders from 2017 with customer city and state information."

**Requirements**:
- Use INNER JOIN to combine orders and customers
- Filter for orders from 2017
- Include: order_id, order_purchase_timestamp, customer_city, customer_state
- Order by purchase timestamp (newest first)
- Limit to 20 results

**Expected columns**: order_id, order_purchase_timestamp, customer_city, customer_state

---

### Exercise 1.2: Product Orders Analysis
**Business Question**: "What products were ordered in delivered orders? Show product categories and prices."

**Requirements**:
- Join orders, order_items, and products tables
- Filter for delivered orders only
- Include: order_id, product_category_name, price, freight_value
- Calculate total_cost (price + freight_value)
- Show first 30 results

**Expected columns**: order_id, product_category_name, price, freight_value, total_cost

---

### Exercise 1.3: Seller Location Analysis
**Business Question**: "Which sellers from São Paulo state have made sales?"

**Requirements**:
- Join sellers with order_items
- Filter for sellers from 'SP' state
- Show: seller_id, seller_city, seller_state, number of items sold, total revenue
- Group by seller information
- Order by total revenue descending

**Expected columns**: seller_id, seller_city, seller_state, items_sold, total_revenue

---

## Section 2: LEFT JOIN Exercises

### Exercise 2.1: Orders Without Reviews
**Business Question**: "Find all delivered orders that don't have customer reviews."

**Requirements**:
- Use LEFT JOIN between orders and reviews
- Filter for delivered orders
- Find orders where review_id IS NULL
- Include: order_id, customer_id, order_purchase_timestamp, order_delivered_customer_date
- Show first 25 results

**Expected columns**: order_id, customer_id, order_purchase_timestamp, order_delivered_customer_date

---

### Exercise 2.2: Product Inventory Check
**Business Question**: "Which products have never been ordered?"

**Requirements**:
- Use LEFT JOIN from products to order_items
- Find products where order_id IS NULL
- Include: product_id, product_category_name, product_weight_g
- Filter out products with NULL category names
- Show first 30 results

**Expected columns**: product_id, product_category_name, product_weight_g

---

### Exercise 2.3: Review Completion Rate by State
**Business Question**: "Calculate the review completion rate for each customer state."

**Requirements**:
- Join customers, orders, and reviews (use LEFT JOIN for reviews)
- Filter for delivered orders only
- Group by customer_state
- Calculate: total orders, orders with reviews, orders without reviews, review_rate (percentage)
- Show states with at least 50 delivered orders
- Order by review_rate descending

**Expected columns**: customer_state, total_orders, orders_with_reviews, orders_without_reviews, review_rate_percentage

---

## Section 3: Multi-Table JOIN Exercises

### Exercise 3.1: Complete Order Analysis
**Business Question**: "Analyze orders from Rio de Janeiro (RJ) with full details: customer, product, and seller information."

**Requirements**:
- Join customers, orders, order_items, products, and sellers
- Filter for customer_state = 'RJ' and order_status = 'delivered'
- Include: customer_city, order_id, product_category_name, price, seller_state
- Calculate: is_local_seller (TRUE if seller_state = customer_state, FALSE otherwise)
- Show first 40 results

**Expected columns**: customer_city, order_id, product_category_name, price, seller_state, is_local_seller

---

### Exercise 3.2: Payment Analysis by Product Category
**Business Question**: "What are the preferred payment methods for different product categories?"

**Requirements**:
- Join products, order_items, orders, and payments
- Filter for delivered orders
- Group by product_category_name and payment_type
- Calculate: total orders, total revenue, average payment installments
- Show categories with at least 100 orders
- Order by total revenue descending

**Expected columns**: product_category_name, payment_type, total_orders, total_revenue, avg_installments

---

### Exercise 3.3: Seller Performance with Reviews
**Business Question**: "Rank sellers by performance, including revenue and customer satisfaction."

**Requirements**:
- Join sellers, order_items, orders, and reviews (LEFT JOIN for reviews)
- Filter for delivered orders
- Group by seller_id, seller_city, seller_state
- Calculate: total_orders, total_revenue, average_review_score
- Include sellers with at least 20 orders
- Order by total_revenue descending

**Expected columns**: seller_id, seller_city, seller_state, total_orders, total_revenue, avg_review_score

---

## Section 4: Advanced JOIN Exercises

### Exercise 4.1: Cross-State Shipping Analysis
**Business Question**: "Compare local shipping (same state) vs interstate shipping in terms of revenue and customer satisfaction."

**Requirements**:
- Join customers, orders, order_items, sellers, and reviews
- Create shipping_type: 'Local' if customer_state = seller_state, else 'Interstate'
- Filter for delivered orders
- Group by shipping_type
- Calculate: total_orders, total_revenue, avg_freight_cost, avg_review_score
- Round numerical values to 2 decimal places

**Expected columns**: shipping_type, total_orders, total_revenue, avg_freight_cost, avg_review_score

---

### Exercise 4.2: Product Category Deep Dive
**Business Question**: "Create a comprehensive report for each product category showing orders, revenue, payments, and reviews."

**Requirements**:
- Join products, order_items, orders, payments (INNER), and reviews (LEFT)
- Filter for delivered orders and non-NULL categories
- Group by product_category_name
- Calculate:
  * total_orders (distinct count)
  * total_items_sold
  * total_revenue
  * avg_order_value
  * credit_card_orders (count where payment_type = 'credit_card')
  * avg_review_score (handle NULLs appropriately)
- Show top 15 categories by revenue

**Expected columns**: product_category_name, total_orders, total_items_sold, total_revenue, avg_order_value, credit_card_orders, avg_review_score

---

### Exercise 4.3: Customer Segmentation
**Business Question**: "Segment customers based on their purchase behavior and satisfaction."

**Requirements**:
- Join customers, orders, order_items, and reviews
- Filter for delivered orders
- Group by customer_unique_id and customer_state
- Calculate for each customer:
  * total_orders
  * total_spent (sum of all item prices)
  * avg_review_score
  * customer_segment: 'Loyal' (3+ orders), 'Repeat' (2 orders), 'One-Time' (1 order)
- Show first 50 customers ordered by total_spent descending

**Expected columns**: customer_unique_id, customer_state, total_orders, total_spent, avg_review_score, customer_segment

---

## Section 5: Challenge Exercises

### Challenge 5.1: Self-Join - Same-Day Orders
**Business Question**: "Find cases where the same customer placed multiple orders on the same day."

**Requirements**:
- Use self-join on orders table
- Match on customer_id and purchase date (not time)
- Ensure order_id_1 < order_id_2 to avoid duplicates
- Include: customer_id, purchase_date, order_id_1, order_id_2, order_status_1, order_status_2
- Show first 20 results

**Expected columns**: customer_id, purchase_date, order_id_1, order_id_2, order_status_1, order_status_2

---

### Challenge 5.2: Data Quality Report
**Business Question**: "Create a data quality report showing orders with missing information."

**Requirements**:
- Use FULL OUTER JOIN or multiple LEFT JOINs
- Find and categorize orders:
  * Orders without payment information
  * Orders without items
  * Orders without reviews (delivered only)
- Create issue_type column to categorize each problem
- Count each issue type

**Expected columns**: issue_type, order_count

---

### Challenge 5.3: Top Customer-Seller Pairs
**Business Question**: "Identify the most valuable customer-seller relationships (customers who buy most from specific sellers)."

**Requirements**:
- Join customers, orders, order_items, sellers
- Filter for delivered orders
- Group by customer_unique_id, customer_state, seller_id, seller_state
- Calculate: total_orders_together, total_revenue
- Show customer-seller pairs with at least 3 orders together
- Order by total_revenue descending
- Limit to top 25 pairs

**Expected columns**: customer_unique_id, customer_state, seller_id, seller_state, total_orders_together, total_revenue

---

## Bonus Section: Business Intelligence Queries

### Bonus 1: Monthly Revenue Trend by Category
**Business Question**: "Show monthly revenue trends for top 5 product categories."

**Requirements**:
- Extract year and month from order_purchase_timestamp
- Join orders, order_items, products
- Filter for delivered orders in 2017
- Group by month and product_category_name
- Calculate monthly revenue per category
- Find top 5 categories by total revenue

**Hint**: Use DATE_TRUNC or EXTRACT functions for date manipulation

---

### Bonus 2: Seller Efficiency Score
**Business Question**: "Calculate a seller efficiency score based on order volume, revenue, and customer satisfaction."

**Requirements**:
- Join sellers, order_items, orders, reviews
- Calculate for each seller:
  * order_volume_score: orders/10 (normalized)
  * revenue_score: total_revenue/1000 (normalized)
  * satisfaction_score: avg_review_score (already 0-5 scale)
  * efficiency_score: average of the three scores above
- Filter sellers with at least 30 orders
- Show top 20 sellers by efficiency_score

---

## Submission Guidelines

1. **File Format**: Submit as `week7_sql_solutions.sql`
2. **Documentation**: Add comments explaining your approach
3. **Testing**: Verify each query returns expected results
4. **Formatting**: Use proper indentation and readable SQL formatting
5. **Bonus**: Attempt bonus questions for extra credit

---

## Evaluation Criteria

- **Correctness**: Queries return accurate results (40%)
- **Join Type Selection**: Appropriate use of INNER/LEFT/OUTER joins (25%)
- **Performance**: Efficient queries (filtering, grouping) (15%)
- **Code Quality**: Readable, well-commented SQL (10%)
- **Completeness**: All required columns and calculations (10%)

---

## Resources

- Lecture notes on JOIN types and syntax
- SQL script examples from class
- PostgreSQL documentation on JOINs
- Office hours: Tuesday 6-7 PM, Friday 3-4 PM

**Good luck! Remember: The key to mastering JOINs is understanding the relationships between tables and choosing the right join type for your business question.**
