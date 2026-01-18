# Google Looker Studio Platform Introduction

## Week 13 - Wednesday Session - Part 1

### Duration: 15 minutes

---

## What is Google Looker Studio?

**Google Looker Studio** (formerly Google Data Studio) is a free, cloud-based business intelligence and data visualization platform that transforms your data into informative, easy-to-read, interactive dashboards and reports.

### Key Characteristics

- **Free to use** (with Google account)
- **Cloud-based** (no installation required)
- **Collaborative** (like Google Docs)
- **Interactive** (viewers can filter and explore)
- **Shareable** (multiple permission levels)

---

## Why Looker Studio for Data Analytics?

Coming from SQL and Python, you might wonder why we need another tool. Here's the value proposition:

### 1. **Business User Accessibility**
- SQL queries → Technical audiences only
- Python notebooks → Requires coding knowledge
- Looker Studio dashboards → Anyone can interact

### 2. **Real-Time Data**
- Direct database connections (no manual exports)
- Automatic refresh capabilities
- Always up-to-date insights

### 3. **Professional Presentation**
- Publication-ready dashboards
- Branding and customization
- Mobile-responsive design

### 4. **Self-Service Analytics**
- Stakeholders can filter without code
- Interactive exploration
- No developer intervention needed

---

## Looker Studio vs. Your Previous Tools

| Task | SQL/Python | Looker Studio |
|------|------------|---------------|
| **Data Analysis** | Write queries/code | Connect and visualize |
| **Sharing Results** | Screenshots, static PDFs | Interactive dashboards |
| **Updates** | Re-run code, re-share | Auto-refresh |
| **Audience** | Technical teams | Business stakeholders |
| **Skill Required** | Programming | Point-and-click design |

**Key Insight:** Looker Studio is the **last mile** of your data analytics workflow—it makes your SQL/Python insights accessible to everyone.

---

## Core Concepts: Report vs. Data Source

### Data Source
Think of this as your **SQL connection** or **Python DataFrame definition**.

- **Purpose:** Defines WHERE your data comes from
- **Contains:** Connection details, fields, calculated fields
- **Reusable:** One data source can power multiple reports
- **Example:** "Olist Orders Data Source" connected to Supabase PostgreSQL

**Analogy from SQL:**
```sql
-- This is like creating a VIEW in SQL
CREATE VIEW olist_orders_view AS
SELECT * FROM olist_sales_data_set.olist_orders_dataset;
```

### Report
Think of this as your **dashboard** or **presentation**.

- **Purpose:** Defines HOW your data is displayed
- **Contains:** Charts, tables, filters, layout
- **Visual:** Colors, fonts, branding
- **Example:** "Monthly Sales Performance Dashboard"

**Analogy from Python:**
```python
# This is like creating visualizations from your DataFrame
import matplotlib.pyplot as plt
df.plot(kind='bar')  # Creating a chart
```

---

## The Looker Studio Interface

When you first open Looker Studio (lookerstudio.google.com), you'll see:

### 1. **Home Screen**
- **Reports:** Your dashboards
- **Data Sources:** Your connections
- **Explorer:** Ad-hoc analysis tool (Week 14)
- **Templates:** Pre-built dashboard designs

### 2. **Report Editor (Where you'll spend most time)**

#### Top Toolbar
```
File | Edit | View | Insert | Page | Arrange | Format | Help
```

**Important Menus:**
- **File → Share:** Control who can view/edit
- **View → View Mode:** Preview as your audience sees it
- **Insert:** Add charts, text, images, filters
- **Page:** Manage multiple dashboard pages

#### Left Sidebar (Insert Panel)
```
📊 Add a Chart
📋 Add a Table
📈 Add a Scorecard
🔽 Add a Control (Filter)
📦 Add a Container
📝 Add Text/Image
```

#### Right Sidebar (Properties Panel)
Changes based on what you've selected:
- **Chart selected:** Chart type, data settings, style
- **Data source selected:** Fields, calculated fields
- **Nothing selected:** Page settings

#### Canvas (Center)
- Your dashboard layout area
- Drag-and-drop interface
- Resize and arrange elements

---

## Creating Your First Report

### Step 1: Access Looker Studio
1. Open your browser
2. Navigate to: `https://lookerstudio.google.com`
3. Sign in with your Google account
4. Click **"Create"** → **"Report"**

### Step 2: Choose Data Source
On first report creation, you'll be prompted to add a data source:

```
Connect to data
─────────────────────────────────
🔌 Google Connectors
   ├── Google Sheets
   ├── Google Analytics
   ├── Google Ads
   └── YouTube Analytics

🗄️ Database Connectors
   ├── PostgreSQL
   ├── MySQL
   ├── BigQuery
   └── More...

📂 File Uploads
   └── CSV Upload
```

**For this course:** We'll use the PostgreSQL connector to connect to Supabase.

### Step 3: First Chart
After connecting data, Looker automatically:
- Creates a default table chart
- Shows all available fields
- Places it on your canvas

**You can:**
- Change chart type (right panel)
- Add/remove fields
- Resize and position

### Step 4: Save Your Report
- Click **File → Rename** to name your report
- Reports auto-save to your Google Drive
- Organized in "My Reports" folder

---

## Navigation Best Practices

### View Modes

#### Edit Mode (Default)
- Full access to all tools
- Modify charts, data, layout
- See edit toolbar and panels

#### View Mode (Preview)
- See report as viewers will
- Test filters and interactivity
- No editing capabilities

**Keyboard Shortcut:**
- `Ctrl/Cmd + Alt + E` → Toggle Edit Mode
- `Ctrl/Cmd + Alt + V` → Toggle View Mode

### Sharing Your Report

Three permission levels:

1. **Viewer**
   - Can see and interact with dashboard
   - Cannot edit anything
   - Best for: Stakeholders, executives

2. **Editor**
   - Can modify charts and layout
   - Can add/remove data sources
   - Best for: Team members, collaborators

3. **Owner**
   - Full control including deletion
   - Can transfer ownership
   - Best for: You (creator)

**To Share:**
1. Click **"Share"** button (top-right)
2. Add email addresses
3. Choose permission level
4. Click **"Send"**

---

## Common Interface Elements

### The Data Panel (Right Sidebar when editing chart)

```
Data
─────────────────
📊 Data Source: [Dropdown]

Dimensions (What to group by)
├── 📅 order_date
├── 🏷️ customer_state
└── 🆔 order_id

Metrics (What to measure)
├── 📈 Record Count
├── 💰 price
└── 📦 freight_value

Filters
└── [Add a Filter]
```

**Key Terms:**
- **Dimensions:** Categories, dates, text (SQL: columns in GROUP BY)
- **Metrics:** Numbers to aggregate (SQL: columns in SELECT with SUM/AVG/COUNT)

### The Style Panel (Right Sidebar when editing chart)

Controls visual appearance:
```
Style
─────────────────
📊 Chart
├── Bar Color
├── Border
└── Background

🔤 Label
├── Font
├── Size
└── Color

📐 Axis
├── Show/Hide
└── Scale
```

---

## Your First 5 Minutes Exercise

Let's create a simple report to get familiar with the interface:

### Task: Create a Blank Report
1. Go to `lookerstudio.google.com`
2. Click **"Create"** → **"Report"**
3. **Skip data source selection** (click X or Cancel)
4. You now have a blank canvas

### Task: Explore the Interface
1. **Insert a Text Box:**
   - Click **"Add Text"** in toolbar
   - Type: "My First Looker Studio Report"
   - Change font size to 24
   - Change color to blue

2. **Insert a Shape:**
   - Click **"Add a Shape"** (bottom of Insert menu)
   - Draw a rectangle
   - Change fill color in Style panel

3. **Toggle View Mode:**
   - Click **"View"** button (top-right)
   - Observe: Editing tools disappear
   - Click **"Edit"** to return

4. **Rename Your Report:**
   - Click "Untitled Report" at top
   - Type: "Week 13 - Practice Report"
   - Reports auto-save

---

## Key Takeaways

### What You Learned
1. ✅ Looker Studio is a free, cloud-based visualization platform
2. ✅ **Data Sources** define WHERE data comes from
3. ✅ **Reports** define HOW data is displayed
4. ✅ Interface has three main areas: Toolbar, Canvas, Properties Panel
5. ✅ Two modes: Edit (build) and View (present)

### What's Next
In the next lesson, we'll connect Looker Studio to our Supabase PostgreSQL database containing the Olist e-commerce dataset.

### Skills Building Progression
```
Week 13 Part 1: Platform Navigation ✓
         ↓
Week 13 Part 2: Database Connection (Next)
         ↓
Week 13 Part 3: Calculated Fields
         ↓
Week 13 Part 4: Chart Creation
```

---

## Quick Reference Card

### Essential Shortcuts
| Action | Shortcut |
|--------|----------|
| Toggle Edit/View | `Ctrl/Cmd + Alt + E` |
| Add Chart | `Ctrl/Cmd + K` |
| Duplicate Element | `Ctrl/Cmd + D` |
| Undo | `Ctrl/Cmd + Z` |
| Redo | `Ctrl/Cmd + Y` |

### Common Tasks
| Task | Location |
|------|----------|
| Add chart | Insert menu → Chart |
| Change chart type | Select chart → Right panel → Chart tab |
| Add filter | Insert menu → Control → Filter |
| Share report | Top-right "Share" button |
| Preview | Top-right "View" button |

---

## Questions to Test Your Understanding

1. What is the difference between a Data Source and a Report?
2. Which permission level allows someone to modify your dashboard?
3. How do you switch between Edit Mode and View Mode?
4. Where do you find the chart type selector?
5. What are Dimensions and Metrics?

**Answers at the end of lecture notes**

---

## Additional Resources

- **Official Documentation:** [support.google.com/looker-studio](https://support.google.com/looker-studio)
- **Video Tutorials:** Looker Studio YouTube Channel
- **Community:** Looker Studio Help Community Forum

---

## Answers to Questions

1. **Data Source** = connection to data + field definitions; **Report** = dashboard with visualizations
2. **Editor** permission level
3. Click "View" button (top-right) or use `Ctrl/Cmd + Alt + E`
4. Right sidebar Properties Panel → Chart tab → Type dropdown
5. **Dimensions** = grouping fields (categories); **Metrics** = numeric measures (aggregations)

---

**Next Lecture:** 02_postgresql_connection_setup.md
