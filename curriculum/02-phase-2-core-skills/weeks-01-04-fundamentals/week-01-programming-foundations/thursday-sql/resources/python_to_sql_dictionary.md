# Python to SQL Translation Dictionary
## Building on Your Wednesday Python Success

This guide helps you translate concepts from yesterday's successful Python session directly to today's SQL learning.

## Core Philosophy: Same Logic, Different Syntax

**Key Insight**: You already understand the analytical thinking. SQL is just another way to express the same ideas you learned yesterday in Python.

---

## Data Loading and Initial Exploration

### Loading Data
| Task | Python (Yesterday) | SQL (Today) |
|------|-------------------|-------------|
| **Load CSV file** | `df = pd.read_csv('orders.csv')` | `SELECT * FROM olist_sales_data_set.olist_orders_dataset` |
| **First few rows** | `df.head()` or `df.head(10)` | `SELECT * FROM table LIMIT 5` or `LIMIT 10` |
| **Last few rows** | `df.tail()` | `SELECT * FROM table ORDER BY column DESC LIMIT 5` |
| **Random sample** | `df.sample(10)` | `SELECT * FROM table ORDER BY RANDOM() LIMIT 10` |

### Basic Data Information
| Task | Python (Yesterday) | SQL (Today) |
|------|-------------------|-------------|
| **Row count** | `len(df)` | `SELECT COUNT(*) FROM table` |
| **Column names** | `df.columns` | `SELECT column_name FROM information_schema.columns WHERE table_name='table'` |
| **Data types** | `df.dtypes` or `df.info()` | `SELECT column_name, data_type FROM information_schema.columns` |
| **Shape (rows, cols)** | `df.shape` | `SELECT COUNT(*) as rows, COUNT(column_name) as cols FROM information_schema.columns` |

---

## Data Selection and Filtering

### Column Selection
| Task | Python (Yesterday) | SQL (Today) |
|------|-------------------|-------------|
| **Select one column** | `df['order_id']` | `SELECT order_id FROM table` |
| **Select multiple columns** | `df[['order_id', 'order_status']]` | `SELECT order_id, order_status FROM table` |
| **Select all columns** | `df` or `df.iloc[:]` | `SELECT * FROM table` |

### Row Filtering (WHERE clauses)
| Task | Python (Yesterday) | SQL (Today) |
|------|-------------------|-------------|
| **Equal to** | `df[df['status'] == 'delivered']` | `SELECT * FROM table WHERE status = 'delivered'` |
| **Not equal** | `df[df['status'] != 'canceled']` | `SELECT * FROM table WHERE status != 'canceled'` |
| **Greater than** | `df[df['price'] > 100]` | `SELECT * FROM table WHERE price > 100` |
| **Multiple conditions** | `df[(df['price'] > 50) & (df['status'] == 'delivered')]` | `SELECT * FROM table WHERE price > 50 AND status = 'delivered'` |
| **OR conditions** | `df[(df['state'] == 'SP') \| (df['state'] == 'RJ')]` | `SELECT * FROM table WHERE state = 'SP' OR state = 'RJ'` |
| **IN list** | `df[df['state'].isin(['SP', 'RJ', 'MG'])]` | `SELECT * FROM table WHERE state IN ('SP', 'RJ', 'MG')` |

---

## Sorting and Ordering

| Task | Python (Yesterday) | SQL (Today) |
|------|-------------------|-------------|
| **Sort ascending** | `df.sort_values('price')` | `SELECT * FROM table ORDER BY price ASC` |
| **Sort descending** | `df.sort_values('price', ascending=False)` | `SELECT * FROM table ORDER BY price DESC` |
| **Sort by multiple columns** | `df.sort_values(['state', 'price'], ascending=[True, False])` | `SELECT * FROM table ORDER BY state ASC, price DESC` |

---

## Counting and Aggregation

### Basic Counts
| Task | Python (Yesterday) | SQL (Today) |
|------|-------------------|-------------|
| **Count rows** | `len(df)` | `SELECT COUNT(*) FROM table` |
| **Count non-null** | `df['column'].count()` | `SELECT COUNT(column) FROM table` |
| **Count unique** | `df['column'].nunique()` | `SELECT COUNT(DISTINCT column) FROM table` |
| **Value counts** | `df['column'].value_counts()` | `SELECT column, COUNT(*) FROM table GROUP BY column ORDER BY COUNT(*) DESC` |

### Statistical Aggregations
| Task | Python (Yesterday) | SQL (Today) |
|------|-------------------|-------------|
| **Minimum** | `df['price'].min()` | `SELECT MIN(price) FROM table` |
| **Maximum** | `df['price'].max()` | `SELECT MAX(price) FROM table` |
| **Average** | `df['price'].mean()` | `SELECT AVG(price) FROM table` |
| **Sum** | `df['price'].sum()` | `SELECT SUM(price) FROM table` |
| **Multiple stats** | `df['price'].describe()` | `SELECT MIN(price), MAX(price), AVG(price), COUNT(price) FROM table` |

---

## Grouping and Aggregation

| Task | Python (Yesterday) | SQL (Today) |
|------|-------------------|-------------|
| **Group by one column** | `df.groupby('state').size()` | `SELECT state, COUNT(*) FROM table GROUP BY state` |
| **Group with aggregation** | `df.groupby('state')['price'].mean()` | `SELECT state, AVG(price) FROM table GROUP BY state` |
| **Multiple aggregations** | `df.groupby('state')['price'].agg(['count', 'mean', 'sum'])` | `SELECT state, COUNT(*), AVG(price), SUM(price) FROM table GROUP BY state` |
| **Sort grouped results** | `df.groupby('state').size().sort_values(ascending=False)` | `SELECT state, COUNT(*) FROM table GROUP BY state ORDER BY COUNT(*) DESC` |

---

## Missing Data Handling

| Task | Python (Yesterday) | SQL (Today) |
|------|-------------------|-------------|
| **Check for nulls** | `df['column'].isnull().sum()` | `SELECT COUNT(*) - COUNT(column) FROM table` |
| **Filter out nulls** | `df[df['column'].notnull()]` | `SELECT * FROM table WHERE column IS NOT NULL` |
| **Filter only nulls** | `df[df['column'].isnull()]` | `SELECT * FROM table WHERE column IS NULL` |
| **Null percentage** | `df['column'].isnull().mean() * 100` | `SELECT (COUNT(*) - COUNT(column)) * 100.0 / COUNT(*) FROM table` |

---

## Date and Time Operations

| Task | Python (Yesterday) | SQL (Today) |
|------|-------------------|-------------|
| **Extract year** | `df['date'].dt.year` | `EXTRACT(YEAR FROM date_column)` |
| **Extract month** | `df['date'].dt.month` | `EXTRACT(MONTH FROM date_column)` |
| **Extract day of week** | `df['date'].dt.dayofweek` | `EXTRACT(DOW FROM date_column)` |
| **Date range filter** | `df[df['date'] >= '2018-01-01']` | `SELECT * FROM table WHERE date_column >= '2018-01-01'` |

---

## Text Operations

| Task | Python (Yesterday) | SQL (Today) |
|------|-------------------|-------------|
| **Contains text** | `df[df['name'].str.contains('São')]` | `SELECT * FROM table WHERE name LIKE '%São%'` |
| **Starts with** | `df[df['name'].str.startswith('São')]` | `SELECT * FROM table WHERE name LIKE 'São%'` |
| **Ends with** | `df[df['name'].str.endswith('Paulo')]` | `SELECT * FROM table WHERE name LIKE '%Paulo'` |
| **Case insensitive** | `df[df['name'].str.lower().str.contains('são')]` | `SELECT * FROM table WHERE LOWER(name) LIKE '%são%'` |

---

## Combining DataFrames/Tables

| Task | Python (Yesterday) | SQL (Today) |
|------|-------------------|-------------|
| **Inner join** | `pd.merge(df1, df2, on='id')` | `SELECT * FROM table1 t1 JOIN table2 t2 ON t1.id = t2.id` |
| **Left join** | `pd.merge(df1, df2, on='id', how='left')` | `SELECT * FROM table1 t1 LEFT JOIN table2 t2 ON t1.id = t2.id` |

---

## Data Types Translation

| Python Type | SQL Type | Example Values |
|-------------|----------|----------------|
| `str` (string) | `VARCHAR`, `TEXT` | 'São Paulo', 'delivered' |
| `int` (integer) | `INTEGER`, `INT` | 42, 1000, -5 |
| `float` (decimal) | `DECIMAL`, `NUMERIC`, `REAL` | 99.99, 3.14159 |
| `bool` (boolean) | `BOOLEAN` | TRUE, FALSE |
| `datetime` | `TIMESTAMP`, `DATE` | '2025-08-14 10:30:00' |

---

## Business Question Patterns

### Pattern 1: "How many...?"
- **Python**: `len(df[condition])` or `df[condition].shape[0]`
- **SQL**: `SELECT COUNT(*) FROM table WHERE condition`

### Pattern 2: "What's the distribution of...?"
- **Python**: `df['column'].value_counts()`
- **SQL**: `SELECT column, COUNT(*) FROM table GROUP BY column ORDER BY COUNT(*) DESC`

### Pattern 3: "What's the average/total...?"
- **Python**: `df['column'].mean()` or `df['column'].sum()`
- **SQL**: `SELECT AVG(column)` or `SELECT SUM(column) FROM table`

### Pattern 4: "Show me the top 10..."
- **Python**: `df.nlargest(10, 'column')` or `df.sort_values('column', ascending=False).head(10)`
- **SQL**: `SELECT * FROM table ORDER BY column DESC LIMIT 10`

### Pattern 5: "Find records where..."
- **Python**: `df[df['column'] == value]`
- **SQL**: `SELECT * FROM table WHERE column = value`

---

## Common Syntax Reminders

### SQL Syntax Rules
1. **End statements with semicolons**: `SELECT * FROM table;`
2. **Use single quotes for text**: `WHERE name = 'São Paulo'`
3. **Use double quotes for column aliases**: `SELECT COUNT(*) AS "Total Orders"`
4. **Case doesn't matter for keywords**: `select`, `SELECT`, `Select` all work
5. **But case matters for data**: `'São Paulo' ≠ 'são paulo'`

### Python-to-SQL Mental Translation
- **Python**: `df.head()` → **SQL**: `SELECT * FROM table LIMIT 5`
- **Python**: `df['column']` → **SQL**: `SELECT column FROM table`
- **Python**: `len(df)` → **SQL**: `SELECT COUNT(*) FROM table`
- **Python**: `df.groupby().count()` → **SQL**: `GROUP BY ... COUNT(*)`

---

## Confidence Building Reminders

### You Already Know This!
- ✅ **Logical thinking**: Same as yesterday - break problems into steps
- ✅ **Data exploration**: Same curiosity about the business data
- ✅ **Pattern recognition**: Same ability to spot trends and outliers
- ✅ **Problem-solving**: Same debugging mindset when something doesn't work

### SQL is Just Different Syntax
- 🔄 **Same business questions**: "How many customers from Lagos?"
- 🔄 **Same analytical approach**: Explore → Filter → Aggregate → Interpret
- 🔄 **Same data insights**: Customer patterns, sales trends, geographic distribution
- 🔄 **Same end goal**: Make data-driven business recommendations

---

## Quick Reference Card

**Most Common Python → SQL Translations:**
```
df.head(5)           → SELECT * FROM table LIMIT 5
len(df)              → SELECT COUNT(*) FROM table
df['column']         → SELECT column FROM table
df.columns           → SELECT * FROM information_schema.columns WHERE table_name='table'
df.sort_values()     → ORDER BY
df.groupby()         → GROUP BY
df[condition]        → WHERE condition
df.describe()        → SELECT MIN(), MAX(), AVG(), COUNT()
```

---

**Remember**: You mastered the thinking yesterday. Today you're just learning new vocabulary for the same concepts! 🚀