# Google Colab Setup Guide
**Getting Started with Python in the Cloud**

---

## What is Google Colab?

Google Colab (Colaboratory) is a free, cloud-based Jupyter notebook environment that lets you write and run Python code in your web browser. Think of it as **"Excel Online for Python"** - no installation required!

### Why Use Colab for Learning Python?
✅ **No installation** - Works in any web browser  
✅ **Free to use** - Google provides the computing power  
✅ **Pre-installed libraries** - pandas, numpy, matplotlib already available  
✅ **Easy sharing** - Share notebooks like Google Docs  
✅ **Persistent storage** - Saves to your Google Drive  
✅ **GPU access** - For advanced projects later  

---

## Getting Started

### Step 1: Access Google Colab
1. Go to **https://colab.research.google.com**
2. Sign in with your Google account (same as Gmail/Drive)
3. You'll see the Colab welcome screen

### Step 2: Create Your First Notebook
1. Click **"New notebook"** or **File > New notebook**
2. Rename your notebook:
   - Click on "Untitled0.ipynb" at the top
   - Change to "Week_01_Python_Practice" or similar
   - It automatically saves to your Google Drive

### Step 3: Understanding the Interface

**Colab looks like this:**
```
┌─────────────────────────────────────────────────────────┐
│ Week_01_Python_Practice.ipynb                          │ ← Notebook name
├─────────────────────────────────────────────────────────┤
│ + Code    + Text                                        │ ← Add cell buttons
├─────────────────────────────────────────────────────────┤
│ [ ]: # This is a code cell                             │
│      print("Hello World")                              │
│      ▶ Run button                                      │
├─────────────────────────────────────────────────────────┤
│ Output: Hello World                                     │
├─────────────────────────────────────────────────────────┤
│ This is a text cell (Markdown)                         │
│ Use this for notes and explanations                    │
└─────────────────────────────────────────────────────────┘
```

---

## Basic Operations

### Cell Types
**Code Cells** (for Python code):
- Gray background with `[ ]:` on the left
- Type Python code here
- Press **Shift+Enter** to run

**Text Cells** (for notes and explanations):
- White background
- Use for headings, explanations, business context
- Supports Markdown formatting

### Running Code
```python
# Type this in a code cell and press Shift+Enter
print("Welcome to Python!")
company = "NaijaCommerce"
print(f"Learning Python for {company}")
```

### Keyboard Shortcuts
- **Shift+Enter**: Run current cell and move to next
- **Ctrl+Enter**: Run current cell and stay
- **Alt+Enter**: Run current cell and insert new cell below
- **A**: Insert cell above (when not editing)
- **B**: Insert cell below (when not editing)
- **DD**: Delete current cell (when not editing)

---

## Setting Up for Week 01

### Step 1: Create Your Weekly Notebook Structure
Create a new notebook and add these sections:

```python
# Cell 1: Import necessary libraries
import pandas as pd
import numpy as np
from datetime import datetime

print("✅ Libraries imported successfully!")
print("Ready for Week 01 Python learning!")
```

```python
# Cell 2: Test basic operations
# Variables and data types practice
company_name = "NaijaCommerce"
monthly_revenue = 2500000
is_profitable = True

print("=== Business Profile ===")
print(f"Company: {company_name}")
print(f"Revenue: ₦{monthly_revenue:,}")
print(f"Profitable: {is_profitable}")
```

### Step 2: Create Text Cells for Organization
Add text cells with headings:

```markdown
# Week 01: Python Fundamentals
**Learning Objectives**: Master variables, lists, dictionaries, and DataFrames

## Exercise 1: Variables and Data Types
*Complete the customer profile creation exercise*

## Exercise 2: Lists and Collections
*Practice with product catalogs and sales data*

## Exercise 3: Dictionaries and Lookups
*Build customer database and analysis*

## Exercise 4: DataFrames and Analysis
*Work with pandas for business insights*
```

---

## Working with Data Files

### Method 1: Upload Files from Computer
```python
# Upload a CSV file
from google.colab import files
uploaded = files.upload()

# Then read with pandas
import pandas as pd
df = pd.read_csv('your_file.csv')
print(df.head())
```

### Method 2: Create Sample Data (Recommended for Week 01)
```python
# Create sample business data directly in Colab
import pandas as pd

# Customer data
customers = {
    'name': ['Adebayo Okonkwo', 'Fatima Abdullahi', 'Chinedu Okoro'],
    'city': ['Lagos', 'Abuja', 'Port Harcourt'],
    'order_value': [125000, 87500, 200000],
    'is_vip': [True, False, True]
}

df = pd.DataFrame(customers)
print("Sample data created:")
print(df)
```

### Method 3: Load from Google Drive
```python
# Mount Google Drive (one-time setup per session)
from google.colab import drive
drive.mount('/content/drive')

# Access files in your Drive
df = pd.read_csv('/content/drive/MyDrive/data/customers.csv')
```

---

## Best Practices for Learning

### 1. Notebook Organization
```markdown
# Use clear headings
## Exercise 1: Variables
### Task 1.1: Customer Profile

**Instructions**: Create variables for a Nigerian customer

**Business Context**: You're setting up profiles for an e-commerce platform
```

### 2. Code Documentation
```python
# Always add comments to explain your business logic
customer_age = 32                    # Age in years
monthly_income = 350000             # Income in Nigerian Naira
customer_tier = "Gold"              # Based on income level

# Calculate spending potential
estimated_budget = monthly_income * 0.05  # 5% of income for online shopping
print(f"Estimated monthly budget: ₦{estimated_budget:,}")
```

### 3. Error Handling Practice
```python
# Test your understanding with intentional errors
try:
    # This will work
    price = 1000
    print(f"Price: ₦{price}")
    
    # This will cause an error - practice fixing it!
    # print(f"Price: ₦{pric}")  # Uncomment to see error
except NameError as e:
    print(f"Error found: {e}")
    print("Check variable spelling!")
```

---

## Saving and Sharing Your Work

### Auto-Save
- Colab automatically saves to Google Drive every few minutes
- Look for "All changes saved" message at the top

### Manual Save
- **Ctrl+S** or **File > Save**
- Creates checkpoint you can revert to

### Downloading Your Work
- **File > Download > Download .ipynb** (Python notebook format)
- **File > Download > Download .py** (Pure Python script)

### Sharing Your Notebook
1. Click **"Share"** button (top right)
2. Change permissions to "Anyone with the link"
3. Copy link to share with instructors or classmates

---

## Troubleshooting Common Issues

### Problem: Libraries Not Found
```python
# If you get "ModuleNotFoundError"
!pip install pandas  # The ! runs command in the system
import pandas as pd
```

### Problem: Notebook Runs Slowly
- **Runtime > Restart and run all** - Clears memory and reruns
- **Runtime > Factory reset runtime** - Complete fresh start

### Problem: Code Cell Won't Run
- Check for syntax errors (red underlines)
- Make sure previous cells ran successfully
- Try **Runtime > Restart and run all**

### Problem: Lost Connection
- Colab disconnects after ~90 minutes of inactivity
- Just click **"Reconnect"** when prompted
- Your code and data are saved, but variables are cleared

---

## Week 01 Practice Workflow

### Daily Routine:
1. **Open Colab** (colab.research.google.com)
2. **Create/open** your Week 01 notebook
3. **Follow along** with lecture notebooks
4. **Practice** with exercises immediately
5. **Save and organize** your work
6. **Add notes** about what you learned

### Exercise Submission:
1. **Complete** all exercises in your notebook
2. **Add reflection** text cells with your insights
3. **Run all cells** to ensure no errors
4. **Share link** with instructor (if required)

---

## Advanced Tips for Later

### Useful Colab Features You'll Learn:
- **Forms** - Create input widgets for data entry
- **Markdown** - Rich text formatting for reports
- **Plotting** - Create charts with matplotlib/seaborn
- **GitHub integration** - Save notebooks to GitHub

### Productivity Shortcuts:
```python
# Quick data preview
df.head()    # First 5 rows
df.info()    # Column information
df.describe()  # Summary statistics

# Quick calculations
df['sales'].sum()     # Total sales
df['city'].value_counts()  # Count by city
```

---

## Getting Help

### Built-in Help:
```python
# Get help on any function
help(print)
help(pd.DataFrame)

# See available methods
dir(df)  # All methods available for DataFrame df
```

### When You're Stuck:
1. **Read the error message** carefully
2. **Check spelling** of variable names
3. **Try the error** in a simple example
4. **Ask for help** in class or discussion forums
5. **Use Google** - search "python [your error message]"

---

## Quick Start Checklist

For Week 01, make sure you can:
- [ ] ✅ Access Google Colab and create a notebook
- [ ] ✅ Run basic Python code in cells
- [ ] ✅ Create variables with different data types
- [ ] ✅ Import pandas and create DataFrames
- [ ] ✅ Add text cells with notes and explanations
- [ ] ✅ Save and share your notebook
- [ ] ✅ Handle basic errors and troubleshoot

---

**You're ready to start learning Python! Remember: Colab is just the tool - the real learning happens when you practice the concepts with real business data.**