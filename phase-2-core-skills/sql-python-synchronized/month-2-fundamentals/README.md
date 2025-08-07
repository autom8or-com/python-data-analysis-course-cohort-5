# Month 2: Fundamentals - From Excel to SQL & Python

## Month Overview
**Goal**: Bridge the gap between Excel skills and programming fundamentals using familiar data operations.

**Mindset Shift**: 
- Excel: "Click and drag to get results"  
- Programming: "Write instructions to get results"

## Weekly Breakdown

### Week 1: Data Exploration & Basic Filtering
**Excel Concept**: Opening files, viewing data, using filters
**Business Question**: "Which orders were delivered late?"

#### SQL Focus: SELECT and WHERE
```sql
-- Like opening an Excel file and looking at the data
SELECT * FROM olist_orders_dataset LIMIT 10;

-- Like using Excel's filter dropdown
SELECT order_id, order_delivered_customer_date, order_estimated_delivery_date
FROM olist_orders_dataset 
WHERE order_delivered_customer_date > order_estimated_delivery_date;
```

#### Python Focus: Loading data and boolean indexing
```python
# Like opening an Excel file
import pandas as pd
orders = pd.read_csv('https://..../olist_orders_dataset.csv')

# Like looking at first few rows (Excel: Ctrl+Home)
orders.head(10)

# Like using Excel filters
late_orders = orders[orders['order_delivered_customer_date'] > orders['order_estimated_delivery_date']]
```

**Key Learning**: Both SQL and Python can "ask questions" of data, just like Excel filters.

### Week 2: Sorting and Basic Calculations  
**Excel Concept**: Sort A-Z, creating calculated columns
**Business Question**: "What are the most expensive orders?"

#### SQL Focus: ORDER BY and calculated fields
```sql
-- Like sorting in Excel (Data → Sort)
SELECT order_id, price, freight_value,
       price + freight_value as total_cost
FROM olist_order_items_dataset
ORDER BY total_cost DESC;
```

#### Python Focus: sort_values() and new columns
```python
# Like adding a new column in Excel
order_items['total_cost'] = order_items['price'] + order_items['freight_value']

# Like sorting in Excel
expensive_orders = order_items.sort_values('total_cost', ascending=False)
```

### Week 3: Counting and Basic Aggregations
**Excel Concept**: COUNTIF, SUMIF, pivot table basics
**Business Question**: "How many orders do we have per state?"

#### SQL Focus: COUNT and GROUP BY
```sql
-- Like creating a pivot table in Excel
SELECT customer_state, COUNT(*) as order_count
FROM olist_customers_dataset c
JOIN olist_orders_dataset o ON c.customer_id = o.customer_id
GROUP BY customer_state
ORDER BY order_count DESC;
```

#### Python Focus: value_counts() and groupby()
```python
# Like COUNTIF in Excel
state_counts = customers['customer_state'].value_counts()

# Like pivot table with count
orders_by_state = orders.merge(customers, on='customer_id')\
                       .groupby('customer_state')\
                       .size()\
                       .reset_index(name='order_count')
```

### Week 4: Date Operations and Text Functions
**Excel Concept**: DATE functions, TEXT functions, conditional formatting
**Business Question**: "Which months have the highest sales?"

#### SQL Focus: Date functions and CASE statements
```sql
-- Like using MONTH() function in Excel
SELECT 
    EXTRACT(MONTH FROM order_purchase_timestamp) as month,
    EXTRACT(YEAR FROM order_purchase_timestamp) as year,
    COUNT(*) as orders,
    CASE 
        WHEN EXTRACT(MONTH FROM order_purchase_timestamp) IN (11,12) THEN 'Holiday Season'
        ELSE 'Regular Season'
    END as season
FROM olist_orders_dataset
GROUP BY year, month
ORDER BY year, month;
```

#### Python Focus: datetime operations and conditions
```python
# Like adding month column in Excel
orders['month'] = orders['order_purchase_timestamp'].dt.month
orders['year'] = orders['order_purchase_timestamp'].dt.year

# Like IF statements in Excel
orders['season'] = orders['month'].apply(
    lambda x: 'Holiday Season' if x in [11,12] else 'Regular Season'
)

# Like pivot table with dates
monthly_sales = orders.groupby(['year', 'month']).size()
```

## Learning Resources per Week

### Student Materials
- **Concept Bridge Document**: Excel → SQL → Python comparison charts
- **Cheat Sheet**: Common operations in all three tools
- **Error Guide**: "I got this error, now what?" troubleshooting
- **Practice Dataset**: Subset of Olist data for exercises

### Exercises Structure
Each week includes:
1. **Warm-up**: Simple Excel-style question
2. **SQL Challenge**: Same question in SQL
3. **Python Challenge**: Same question in Python  
4. **Integration**: Compare results between tools
5. **Business Application**: Real scenario using the concept

## Assessment
- **Weekly Quiz**: "Translate this Excel operation to SQL/Python"
- **Mini-Project**: Week 4 culminating project analyzing seasonal trends
- **Peer Review**: Students explain their code to classmates

## Success Indicators
Students successfully completing Month 2 should:
- [ ] Write basic SELECT statements in SQL
- [ ] Load and filter data in Python pandas
- [ ] Understand how WHERE clauses relate to Excel filters
- [ ] Create simple calculated fields in both languages
- [ ] Perform basic counting and grouping operations
- [ ] Debug simple syntax errors
- [ ] Explain their code in plain English

---

*Remember: Every concept is first connected to Excel before introducing the programming equivalent.*