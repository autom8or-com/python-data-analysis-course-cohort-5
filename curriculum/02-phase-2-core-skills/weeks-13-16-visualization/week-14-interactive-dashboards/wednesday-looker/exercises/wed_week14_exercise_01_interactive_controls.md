# Exercise 1: Interactive Controls

## Week 14 - Wednesday - Exercise 1

### Estimated Time: 25 minutes

---

## Objective

Add interactive controls to your Looker Studio dashboard to enable users to filter and explore data dynamically. You'll implement date range controls, dropdown filters, and parameters to create a user-driven analytics experience.

---

## Prerequisites

Before starting, ensure you have:
- ✅ Completed Week 13 exercises (Data Connection & Calculated Fields)
- ✅ Active data source: "Olist Orders 2017 - Student [Your Name]"
- ✅ Familiarity with your calculated fields (region, price_tier, delivery_status)
- ✅ Completed Week 14 Lecture Part 1 & 2 (Parameters and Controls)

---

## Instructions

### Part 1: Create a New Dashboard for Interactive Controls

#### Task 1.1: Set Up Your Dashboard

1. Go to Looker Studio home: `https://lookerstudio.google.com`
2. Click **"Create"** → **"Report"**
3. Select your data source: **"Olist Orders 2017 - Student [Your Name]"**
4. Click **"ADD TO REPORT"**
5. Rename the report to: **"Week 14 - Interactive Dashboard - [Your Name]"**

#### Task 1.2: Create Foundation Charts

Before adding controls, create these baseline charts:

**Chart 1: Revenue Scorecard**
1. Add a **Scorecard** (top-left of canvas)
2. Configure:
   - Metric: `SUM(total_order_value)`
   - Label: "Total Revenue"
3. Position: Top-left area

**Chart 2: Order Count Scorecard**
1. Add another **Scorecard**
2. Configure:
   - Metric: `Record Count`
   - Label: "Total Orders"
3. Position: Next to Revenue scorecard

**Chart 3: Revenue by Region (Bar Chart)**
1. Add a **Bar Chart**
2. Configure:
   - Dimension: `region`
   - Metric: `SUM(total_order_value)`
   - Sort: Descending by metric
3. Position: Below scorecards (left side)

**Chart 4: Orders by Month (Time Series)**
1. Add a **Time Series Chart**
2. Configure:
   - Dimension: `order_purchase_timestamp` (automatic date breakdown)
   - Metric: `Record Count`
3. Position: Below scorecards (right side)

---

### Part 2: Add Date Range Control

#### Task 2.1: Create Date Range Selector

1. From toolbar, click **"Add a control"** → **"Date range control"**
2. Place it at the **top of your dashboard** (above all charts)
3. Configure the control (right panel):
   - **Data tab:**
     - Date Dimension: `order_purchase_timestamp`
   - **Style tab:**
     - Control Type: **"Slider"** (default)
     - Auto Date Range: **"Auto"** (leave checked)

4. Resize the date range control to span most of the width at the top

#### Task 2.2: Test Date Range Functionality

1. Click **"View"** button (top-right) to enter view mode
2. Interact with the date range slider:
   - Drag the left handle to start from March 2017
   - Drag the right handle to end at September 2017
3. **Observe:** All charts update automatically

**Verification Questions:**
- Did the Total Revenue scorecard value change?
- Did the bar chart show different region values?
- Did the time series chart show only March-September data?

4. Click **"Edit"** to return to edit mode

---

### Part 3: Add Dropdown Filter Controls

#### Task 3.1: Create Region Filter

1. Click **"Add a control"** → **"Drop-down list"**
2. Place it below the date range control (top-left area)
3. Configure:
   - **Data tab:**
     - Control field: `region`
     - Metric: `Record Count` (to show count per region)
   - **Style tab:**
     - Label: "Select Region"
     - Allow multiple selections: ☑ **Checked**
     - Include "All" option: ☑ **Checked**

#### Task 3.2: Create Price Tier Filter

1. Add another **"Drop-down list"** control
2. Place it next to the Region filter
3. Configure:
   - **Data tab:**
     - Control field: `price_tier`
     - Metric: `Record Count`
   - **Style tab:**
     - Label: "Price Tier"
     - Allow multiple selections: ☑ **Checked**
     - Include "All" option: ☑ **Checked**

#### Task 3.3: Create Delivery Status Filter

1. Add a third **"Drop-down list"** control
2. Place it next to the Price Tier filter
3. Configure:
   - **Data tab:**
     - Control field: `delivery_status`
     - Metric: `Record Count`
   - **Style tab:**
     - Label: "Delivery Status"
     - Allow multiple selections: ☑ **Checked**
     - Include "All" option: ☑ **Checked**

---

### Part 4: Add Fixed-Size List Control

#### Task 4.1: Create State Selector (Fixed List)

For more detailed geographic filtering, add a visible list control:

1. Click **"Add a control"** → **"Fixed-size list"**
2. Place it on the right side of the dashboard (vertical orientation)
3. Configure:
   - **Data tab:**
     - Control field: `customer_state`
     - Metric: `SUM(total_order_value)` (shows revenue per state)
     - Sort: Descending by metric
     - Max items: **10** (top 10 states)
   - **Style tab:**
     - Label: "Top States by Revenue"
     - Allow multiple selections: ☑ **Checked**
     - Display metric: ☑ **Checked**

**Expected Result:** A vertical list showing top 10 states (SP, RJ, MG, etc.) with revenue values.

---

### Part 5: Test Interactive Filtering

#### Task 5.1: Enter View Mode and Test Combinations

1. Click **"View"** button to enter view mode
2. Run these test scenarios:

**Test Scenario 1: Filter by Single Region**
- Date Range: Leave as default (all 2017)
- Region: Select **"Southeast"** only
- Price Tier: All
- Delivery Status: All
- State: All

**Observe:**
- Does the Revenue scorecard decrease?
- Does the bar chart show only Southeast?
- Do you see only Southeast states in the state list?

**Test Scenario 2: Combine Multiple Filters**
- Date Range: **January - March 2017**
- Region: **"Southeast"** and **"South"**
- Price Tier: **"Premium"** only
- Delivery Status: **"On Time"**
- State: All

**Record the results:**
- Total Revenue: __________
- Total Orders: __________
- Which region has more premium orders in Q1?

**Test Scenario 3: State-Level Drill Down**
- Reset all filters (select "All")
- From the State list, select only **"SP"** (São Paulo)
- Date Range: Entire 2017

**Questions:**
- What percentage of total revenue comes from SP?
- How many orders came from SP?

3. Click **"Edit"** to return to edit mode

---

### Part 6: Add Search Box Control (Optional Enhancement)

#### Task 6.1: Create Customer City Search

1. Click **"Add a control"** → **"Input box"**
2. Place it near your state selector
3. Configure:
   - **Data tab:**
     - Control field: `customer_city`
   - **Style tab:**
     - Label: "Search City"
     - Placeholder text: "Type city name..."
     - Match type: **"Contains"** (partial matching)

**Use Case:** Users can type "rio" to see all cities containing "rio" (Rio de Janeiro, etc.)

---

### Part 7: Organize and Style Your Controls

#### Task 7.1: Align and Group Controls

1. Select all filter controls (hold Shift and click each)
2. Right-click → **"Align"** → **"Align top"** (ensure they're on same horizontal line)
3. Right-click → **"Distribute"** → **"Distribute horizontally"** (equal spacing)

#### Task 7.2: Add Background to Controls Section

1. From toolbar, click **"Insert"** → **"Rectangle"**
2. Draw a rectangle behind all your controls
3. Configure rectangle:
   - **Style tab:**
     - Background color: Light gray (#F5F5F5)
     - Border: None or subtle gray
4. Right-click rectangle → **"Order"** → **"Send to back"**

**Expected Result:** Controls appear on a subtle background, visually grouped as a "control panel."

---

## Submission Checklist

Before marking this exercise as complete, verify:

```
☐ Dashboard created with name "Week 14 - Interactive Dashboard - [Your Name]"
☐ Date range control added and functional (slider type)
☐ Three dropdown filters created (Region, Price Tier, Delivery Status)
☐ Fixed-size list control for states created (shows top 10)
☐ Optional: Search box for cities added
☐ All charts respond to filter changes
☐ Controls are visually aligned and organized
☐ Background styling applied to controls section
☐ Tested multiple filter combinations successfully
☐ All filters show "All" option for reset capability
```

---

## Troubleshooting

### Issue 1: "Control Doesn't Filter Charts"

**Possible Causes:**

**Problem:** Chart uses different data source than control
- **Solution:** Ensure all charts and controls use the same data source

**Problem:** Chart has a manual filter overriding control
- **Solution:**
  1. Select the chart
  2. Data tab → **"Filter"** section
  3. Remove any manual filters that conflict with controls

---

### Issue 2: "Date Range Control Shows No Data"

**Solutions:**
1. Check that `order_purchase_timestamp` is recognized as **Date** type
2. Edit data source → Find field → Change type to "Date & Time"
3. Verify your date range includes dates in your dataset (2017)

---

### Issue 3: "Dropdown Shows Too Many Items"

**Problem:** State dropdown shows all 27 Brazilian states, hard to navigate

**Solutions:**
1. Use **Fixed-size list** instead for better UX
2. Or limit dropdown to top N items:
   - Control configuration → Data tab
   - Sort: By your metric (descending)
   - Max items: 15

---

### Issue 4: "Multiple Selections Not Working"

**Solution:**
1. Edit the control
2. Style tab → Ensure **"Allow multiple selections"** is ☑ Checked
3. In view mode, use Ctrl (Windows) or Cmd (Mac) to select multiple items

---

### Issue 5: "Controls Overlap Charts"

**Solution:**
1. Resize your charts to make room for controls
2. Move controls to dedicated area (top or left sidebar)
3. Use **Grid Layout** (View → Grid settings → Show grid)
4. Align everything to grid for clean layout

---

## Expected Outcomes

### Your Dashboard Layout

Your interactive dashboard should look similar to this:

```
┌────────────────────────────────────────────────────────────────────────┐
│ Week 14 - Interactive Dashboard - [Your Name]                         │
├────────────────────────────────────────────────────────────────────────┤
│                                                                        │
│  ┌──────────────────────────────────────────────────────────────────┐ │
│  │ ◄─────────── Date Range: Jan 2017 ─────────── Dec 2017 ─────────►│ │
│  └──────────────────────────────────────────────────────────────────┘ │
│                                                                        │
│  ┌────────────────┐ ┌──────────────┐ ┌────────────────┐              │
│  │ Select Region▼ │ │ Price Tier ▼ │ │ Delivery Status▼│             │
│  │ All           │ │ All         │ │ All            │              │
│  └────────────────┘ └──────────────┘ └────────────────┘              │
│                                                                        │
│  ┌──────────────┐ ┌──────────────┐         ┌──────────────────────┐  │
│  │Total Revenue │ │ Total Orders │         │ Top States          │  │
│  │              │ │              │         │ ─────────────────── │  │
│  │ $9,700,000   │ │   96,478     │         │ ☐ SP    $5.2M       │  │
│  └──────────────┘ └──────────────┘         │ ☐ RJ    $1.8M       │  │
│                                             │ ☐ MG    $1.1M       │  │
│  ┌────────────────────────────────┐         │ ☐ RS      $900K     │  │
│  │ Revenue by Region              │         │ ☐ PR      $850K     │  │
│  │ ─────────────────────────────  │         │ ☐ SC      $600K     │  │
│  │ Southeast  ███████████  $5.2M  │         │ ☐ BA      $450K     │  │
│  │ South      ████  $2.3M          │         │ ☐ DF      $380K     │  │
│  │ Northeast  ██  $1.4M            │         │ ☐ GO      $320K     │  │
│  │ Central    █  $600K             │         │ ☐ ES      $250K     │  │
│  │ North      ▌  $200K             │         └──────────────────────┘  │
│  └────────────────────────────────┘                                   │
│                                                                        │
│  ┌──────────────────────────────────────────────────────────────────┐ │
│  │ Orders Over Time (2017)                                          │ │
│  │ ────────────────────────────────────────────────────────────────  │ │
│  │      ╱\        ╱\                                                 │ │
│  │    ╱    \    ╱    \      ╱\                                       │ │
│  │  ╱        \╱        \  ╱    \                                     │ │
│  │╱                      ╱        \                                  │ │
│  │ Jan  Feb  Mar  Apr  May  Jun  Jul  Aug  Sep  Oct  Nov  Dec       │ │
│  └──────────────────────────────────────────────────────────────────┘ │
│                                                                        │
└────────────────────────────────────────────────────────────────────────┘
```

---

## How to Know You Succeeded

✅ **Control Responsiveness Test:**
- When you change date range → all charts update immediately
- When you select a region → charts show only that region's data
- When you select multiple price tiers → charts combine those tiers
- When you select a state → charts filter to that state only

✅ **User Experience Test:**
- Controls are clearly labeled and intuitive
- "All" option appears for easy reset
- Multiple selections work with Ctrl/Cmd + click
- Control panel looks organized and professional

✅ **Data Consistency Test:**
- Scorecard totals match the filtered data in charts
- Time series shows correct date range
- Bar chart regions match selected filters
- State list updates based on other filters

---

## Reflection Questions

Answer these to test your understanding:

1. **What is the difference between a "Date range control" and a "Fixed-size list" for dates?**

2. **Why do we enable "Allow multiple selections" on dropdown filters?**

3. **How do controls interact with charts that use the same data source?**

4. **When would you use a "Fixed-size list" instead of a "Drop-down list"?**

5. **If a user selects "Southeast" in Region filter and "SP" in State filter, what data appears? Is this redundant or useful?**

---

## Next Steps

Once you've completed this exercise:
1. **Keep this dashboard** – You'll enhance it in Exercise 2 with conditional formatting
2. **Experiment** – Try different control types (checkbox, slider) on your own
3. **Document** – Take screenshots of your filter combinations for reference

**Great work!** You've built an interactive dashboard that gives users control over their data exploration. This is a key skill for creating self-service analytics.

---

## Additional Challenge (Optional)

If you finish early, try these advanced tasks:

### Challenge 1: Add Checkbox Controls

Replace one dropdown with checkboxes for easier multi-select:

1. Add control → **"Checkbox list"**
2. Configure for `delivery_status`
3. Compare UX: Checkboxes vs. Dropdown for multiple selections

**Question:** Which is more user-friendly for 3-5 options?

---

### Challenge 2: Create Filter Dependency

Make state filter depend on region selection:

**Note:** Looker Studio automatically does this—if you select "Southeast" region, the state list automatically shows only Southeast states. Test this behavior!

---

### Challenge 3: Add Slider for Numeric Filtering

Create a price range slider:

1. Add control → **"Slider"**
2. Configure:
   - Control field: `price`
   - Min: 0
   - Max: 1000
3. Observe how users can select price range visually

---

### Challenge 4: Create "Reset All Filters" Functionality

**Workaround (Looker doesn't have built-in reset button):**

1. Add a **Text** element with instructions:
   ```
   "To reset all filters: Select 'All' in each dropdown"
   ```
2. Style it prominently near controls

**Better approach:** Use parameter defaults (covered in advanced lectures)

---

**Instructor Note:** Ensure students test filter interactions thoroughly. Common issues include control/chart data source mismatches and confusion about multi-select keyboard shortcuts (Ctrl/Cmd + click). Demonstrate these in class before exercise time.
