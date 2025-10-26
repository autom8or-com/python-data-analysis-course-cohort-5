# Week 10 Wednesday - Python Lecture Notebooks
## Inventory Management & Supply Chain Analysis

**Session Date:** October 15, 2025
**Duration:** 2 hours (120 minutes)
**Topics:** Data Merging, Reshaping, and Concatenation with Pandas

---

## 📚 Learning Path

This folder contains three sequential lecture notebooks that teach you how to combine and reshape data for comprehensive inventory analysis:

### Part 1: Data Merging (45 minutes)
**File:** `wed_inventory_merging_part1.ipynb`

**What You'll Learn:**
- How pandas `merge()` relates to SQL JOINs
- Four types of joins: inner, left, right, outer
- Combining product, inventory, and warehouse data
- Handling column name conflicts with suffixes
- Merging on different column names
- Multi-step merge operations

**Business Use Cases:**
- "Show me products with active inventory"
- "Which warehouse has the most inventory?"
- "Identify products without inventory records"

**Key Functions:**
```python
pd.merge(df1, df2, on='column', how='inner/left/right/outer')
pd.merge(df1, df2, left_on='col1', right_on='col2')
```

---

### Part 2: Data Reshaping (45 minutes)
**File:** `wed_inventory_reshaping_part2.ipynb`

**What You'll Learn:**
- Long format vs wide format data
- Creating pivot tables for reporting
- Converting wide data to long format with `melt()`
- Stack and unstack operations
- Multi-dimensional pivot tables

**Business Use Cases:**
- "Create a warehouse × category inventory matrix"
- "Show monthly sales with categories as rows and months as columns"
- "Convert Excel report to analyzable format"

**Key Functions:**
```python
pd.pivot_table(df, values='val', index='row', columns='col', aggfunc='sum')
pd.melt(df, id_vars=['id'], value_vars=['col1', 'col2'])
df.stack() / df.unstack()
```

---

### Part 3: Data Concatenation (30 minutes)
**File:** `wed_inventory_concatenation_part3.ipynb`

**What You'll Learn:**
- Combining DataFrames vertically (stacking rows)
- Combining DataFrames horizontally (adding columns)
- When to use `concat()` vs `merge()`
- Handling mismatched columns
- Tracking data sources with keys

**Business Use Cases:**
- "Combine January, February, March inventory snapshots"
- "Stack regional inventory files"
- "Append today's orders to the master dataset"

**Key Functions:**
```python
pd.concat([df1, df2, df3], axis=0, ignore_index=True)  # Vertical
pd.concat([df1, df2], axis=1)  # Horizontal
pd.concat([df1, df2], keys=['Source1', 'Source2'])  # With tracking
```

---

## 📊 Datasets Used

All notebooks use these CSV files (located in `../datasets/`):

| Dataset | Rows | Description |
|---------|------|-------------|
| `products.csv` | 20 | Product details (category, weight, dimensions) |
| `inventory.csv` | 20 | Current stock levels and warehouse assignments |
| `orders.csv` | 20 | Customer orders and delivery dates |
| `order_items.csv` | 20 | Individual items in each order |
| `suppliers.csv` | 20 | Supplier information and product counts |
| `warehouses.csv` | 5 | Nigerian warehouse locations and capacity |

**Business Context:** Lagos-based e-commerce company managing inventory across 5 warehouses (Lagos, Abuja, Port Harcourt, Kano, Ibadan).

---

## 🎯 Learning Objectives

By the end of these three sessions, you will be able to:

1. **Combine Related Data:**
   - Merge datasets based on common keys
   - Choose appropriate join types for different scenarios
   - Handle missing values after merges

2. **Reshape for Analysis:**
   - Transform data between long and wide formats
   - Create pivot tables for management reports
   - Restructure data for visualization

3. **Stack Multiple Files:**
   - Combine time-series data (monthly snapshots)
   - Merge regional datasets
   - Track data sources in combined datasets

4. **Apply to Real Business Problems:**
   - Inventory optimization
   - Supply chain analysis
   - Multi-period trend analysis
   - Data quality assessment

---

## 📝 Class Schedule

### Hour 1: Merging Operations (60 minutes)
- **0-15 min:** Merge concepts and SQL JOIN mapping
- **15-35 min:** Live coding demonstrations (all 4 join types)
- **35-50 min:** Guided practice with inventory data
- **50-60 min:** Start Exercise 1

### Hour 2: Reshaping and Combining (60 minutes)
- **0-20 min:** Pivot tables and melt demonstrations
- **20-40 min:** Concatenation operations
- **40-50 min:** Work on Exercises 2 and 3
- **50-60 min:** Q&A and project preview

---

## 💻 How to Use These Notebooks

### Prerequisites:
- Python 3.8+
- pandas library installed
- Basic understanding of DataFrames (Week 1-9 content)

### Running the Notebooks:

**Option 1: Google Colab (Recommended for Class)**
1. Upload notebook to Google Colab
2. Upload datasets folder to Colab session
3. Adjust file paths: `pd.read_csv('../datasets/file.csv')` → `pd.read_csv('/content/datasets/file.csv')`

**Option 2: Local Jupyter**
1. Navigate to this folder in terminal
2. Run: `jupyter notebook`
3. Open the notebook in your browser
4. Datasets will load automatically with relative paths

**Option 3: VS Code**
1. Install Jupyter extension
2. Open notebook file
3. Select Python kernel
4. Run cells interactively

### Best Practices:
- ✅ Run cells in order from top to bottom
- ✅ Read markdown explanations before running code
- ✅ Try modifying examples with different parameters
- ✅ Complete practice exercises at the end of each notebook
- ✅ Take notes on business insights discovered

---

## 🔗 Relationship to SQL Content

These pandas operations directly correspond to Thursday's SQL topics:

| Wednesday (Python) | Thursday (SQL) | Concept |
|--------------------|----------------|---------|
| `pd.merge()` | `JOIN` | Combining tables based on keys |
| Pivot table (wide format) | Denormalization | Reporting structure |
| Melt (long format) | Normalization (1NF) | Tidy data principle |
| Multi-step merge | View creation | Reusable data transformations |

**Integration Strategy:**
- Wednesday: Learn **how** to combine and reshape data (practical)
- Thursday: Learn **why** data is structured this way (conceptual)

---

## 📖 Additional Resources

### In This Repository:
- `../../exercises/week10_inventory_exercises.ipynb` - Comprehensive practice problems
- `../../solutions/` - Solution notebooks (instructor access only)
- `../../resources/` - Cheat sheets and quick reference guides

### External Documentation:
- [Pandas merge documentation](https://pandas.pydata.org/docs/reference/api/pandas.merge.html)
- [Pandas pivot_table documentation](https://pandas.pydata.org/docs/reference/api/pandas.pivot_table.html)
- [Pandas concat documentation](https://pandas.pydata.org/docs/reference/api/pandas.concat.html)
- [SQL to pandas comparison](https://pandas.pydata.org/docs/getting_started/comparison/comparison_with_sql.html)
- [Reshaping guide](https://pandas.pydata.org/docs/user_guide/reshaping.html)

### Video Tutorials:
- Pandas Merge Operations (Recommended: Data School series)
- Pivot Tables Explained (Corey Schafer)
- Real-world data cleaning examples

---

## ⚠️ Common Issues and Solutions

### Issue 1: File Not Found Error
```python
FileNotFoundError: [Errno 2] No such file or directory: '../datasets/products.csv'
```
**Solution:** Check your current working directory and adjust the relative path.
```python
import os
print(os.getcwd())  # Shows current directory
```

### Issue 2: Merge Produces Too Many Rows
```python
# Expected 100 rows, got 500 rows!
```
**Cause:** Many-to-many join (duplicate keys in both DataFrames)
**Solution:** Investigate duplicate keys before merging
```python
df1[df1.duplicated(subset=['key_column'], keep=False)]
```

### Issue 3: NaN Values After Merge
```python
# Many NaN values in result
```
**Cause:** Using inner join when you needed left/outer join
**Solution:** Choose appropriate join type
```python
# Keep all records from left table
pd.merge(df1, df2, on='key', how='left')
```

### Issue 4: Column Name Conflicts
```python
# Unwanted _x and _y suffixes
```
**Solution:** Use custom suffixes or rename columns beforehand
```python
pd.merge(df1, df2, on='key', suffixes=('_inventory', '_warehouse'))
```

---

## 🎓 Assessment

After completing these notebooks, you should be able to:

- [ ] Explain the difference between merge types (inner, left, right, outer)
- [ ] Transform a long-format dataset to wide format using pivot_table
- [ ] Convert a wide Excel report to long format for analysis
- [ ] Combine multiple monthly data files into one dataset
- [ ] Handle missing values appropriately after merge operations
- [ ] Choose the right tool (merge vs concat) for different scenarios
- [ ] Apply these techniques to real inventory management problems

**Next Step:** Complete the exercises in `../../exercises/week10_inventory_exercises.ipynb`

---

## 📧 Getting Help

- **During Class:** Raise your hand or use class chat
- **After Class:** Post in the course forum with:
  - Specific error message
  - Code you tried
  - What you expected vs what happened
- **Office Hours:** Wednesdays 6-7 PM, Thursdays 6-7 PM

---

## 🚀 What's Next?

**This Week:**
- Thursday: SQL Database Modeling (normalization, views, data integrity)
- Project: Apply these skills to real-world inventory optimization

**Next Week:**
- Advanced DataFrame operations
- Time series analysis
- Performance optimization

**Phase 2 Project (Month 7):**
- Choose from 5 industry projects
- Apply merging, reshaping, and visualization
- Build interactive Streamlit dashboard

---

**Last Updated:** October 20, 2025
**Instructor:** PORA Academy Teaching Team
**Course:** Data Analytics & AI Bootcamp - Cohort 5
**Phase:** 2 (Core Skills - Python & SQL)

---

*Need to update these materials? See the instructor guide in the resources folder.*
