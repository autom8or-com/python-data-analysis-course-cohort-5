# Creating Scorecards and KPIs in Looker Studio

**Week 13 - Thursday Session | Hour 1 (15-30 minutes)**
**Business Context:** Building executive-level KPI displays for Nigerian e-commerce performance

---

## Learning Objectives

By the end of this section, you will be able to:
- Create scorecards showing single metrics
- Configure comparison values (vs previous period, vs target)
- Apply conditional formatting for performance indicators
- Design visually appealing and informative KPI displays
- Use calculated fields from Wednesday's session

---

## What is a Scorecard?

A **scorecard** is the simplest but most powerful visualization in business intelligence. It displays a single number prominently - your most important metric.

### Excel Equivalent
In Excel, you might have a cell with a formula like `=SUM(B2:B100)` and make it large and bold. A Looker Studio scorecard is this concept evolved - automatic updates, comparisons, and professional design.

### When to Use Scorecards

**Perfect For:**
- Executive dashboards (what matters most in 3 seconds)
- KPI tracking (metrics you check daily)
- Summary metrics (total revenue, customer count, average values)
- Target monitoring (actual vs goal)

**Not Good For:**
- Detailed breakdowns (use tables instead)
- Trends over time (use time series instead)
- Comparisons across categories (use bar charts instead)

---

## Scorecard Anatomy: Components Explained

### Basic Scorecard Structure

```
┌─────────────────────────────┐
│      METRIC NAME            │  ← Descriptive label
│                             │
│      NGN 45,250,000         │  ← The main metric (large font)
│                             │
│      ↑ 15.3% vs Last Month  │  ← Comparison indicator
└─────────────────────────────┘
```

### Component Breakdown

1. **Metric Label:** Tells viewers what they're looking at
   - Keep it short: "Total Revenue" not "Sum of All Order Item Prices"
   - Use business language, not technical jargon

2. **Main Value:** The star of the show
   - Largest element in the scorecard
   - Properly formatted (currency, percentages, counts)

3. **Comparison Value:** Context for the metric
   - Absolute change: "+NGN 2.3M"
   - Percentage change: "↑ 15.3%"
   - Comparison label: "vs Last Month", "vs Target", "vs Last Year"

4. **Conditional Formatting:** Visual performance indicators
   - Green: Good performance (up arrow, positive color)
   - Red: Poor performance (down arrow, alert color)
   - Gray: Neutral or no change

---

## Step-by-Step: Creating Your First Scorecard

### Example: Total Revenue Scorecard

**Business Question:** What is our total revenue from all orders?

**SQL Equivalent (Week 4 Aggregations):**
```sql
SELECT SUM(price) as total_revenue
FROM olist_sales_data_set.olist_order_items_dataset;
```

### Looker Studio Implementation

#### Step 1: Add Scorecard to Canvas

1. Click **Add a Chart** button in toolbar
2. Select **Scorecard** from chart menu
3. Click and drag on canvas to create scorecard

**[SCREENSHOT 1: Adding scorecard from chart menu]**
*Caption: Scorecard is found in the chart picker under "Metric" category*

---

#### Step 2: Configure Data Source

In the **Data** panel (right side):

**Data Source:** Select your Wednesday-created data source
- Example: `olist_orders_with_calculations`

**Dimension:** (Leave empty for total aggregation)
- Scorecards typically don't need dimensions
- Exception: If filtering to specific category

**Metric:** Select or create your metric

**Option A: Use Existing Field**
- If you created `total_revenue` calculated field on Wednesday:
- Select it from dropdown

**Option B: Create Metric On-The-Fly**
1. Click **Add Metric** → **Create Field**
2. Field Name: `Total Revenue`
3. Formula:
   ```
   SUM(price)
   ```
4. Save

**[SCREENSHOT 2: Data panel configuration for scorecard]**
*Caption: Configuring the metric - use SUM aggregation on price field*

---

#### Step 3: Format the Number

In **Style** panel:

**Number Format:**
1. Type: **Currency**
2. Currency: **NGN** (Nigerian Naira)
3. Decimals: **0** (millions don't need decimals)
4. Compact Numbers: **ON** (shows 45.3M instead of 45,250,000)

**Example Formatting Results:**
- Raw: 45250000
- Currency, No Compact: NGN 45,250,000
- Currency, Compact: NGN 45.3M ✓ (Best for dashboards)

**[SCREENSHOT 3: Number formatting options]**
*Caption: Setting currency to NGN with compact number display*

---

#### Step 4: Add Comparison (Time Comparison)

**Business Value:** Is revenue growing or shrinking?

In **Data** panel:

**Comparison Calculation:**
1. Enable **Show Comparison**
2. **Comparison Type:** Select **Previous Period**
3. **Date Range Dimension:** `order_purchase_timestamp`
4. **Comparison Range:** Last Month / Last Quarter / Last Year

**SQL Equivalent Concept:**
```sql
-- Current period
SELECT SUM(price) as current_revenue
FROM olist_sales_data_set.olist_order_items_dataset
WHERE order_purchase_timestamp >= DATE_TRUNC('month', CURRENT_DATE)
  AND order_purchase_timestamp < DATE_TRUNC('month', CURRENT_DATE) + INTERVAL '1 month';

-- Previous period
SELECT SUM(price) as previous_revenue
FROM olist_sales_data_set.olist_order_items_dataset
WHERE order_purchase_timestamp >= DATE_TRUNC('month', CURRENT_DATE) - INTERVAL '1 month'
  AND order_purchase_timestamp < DATE_TRUNC('month', CURRENT_DATE);

-- Looker automatically calculates: (current - previous) / previous * 100
```

**Comparison Display Options:**
- **Percent Change:** ↑ 15.3%
- **Absolute Change:** ↑ NGN 5.8M
- **Both:** ↑ 15.3% (NGN 5.8M)

**[SCREENSHOT 4: Comparison configuration panel]**
*Caption: Enabling previous period comparison for month-over-month growth*

---

#### Step 5: Style the Scorecard

In **Style** panel:

**Metric Label:**
- Text: "Total Revenue"
- Font: Roboto (clean, professional)
- Size: 14px
- Color: #424242 (dark gray)

**Metric Value:**
- Font: Roboto Bold
- Size: 36px
- Color: #1976D2 (professional blue)

**Comparison Value:**
- Font: Roboto
- Size: 16px
- Show Direction Indicator: ✓ (up/down arrows)

**Background:**
- Background Color: #FFFFFF (white)
- Border: 1px solid #E0E0E0 (subtle border)
- Border Radius: 8px (rounded corners)

**[SCREENSHOT 5: Styled scorecard with formatting]**
*Caption: Professional scorecard with proper fonts, colors, and spacing*

---

## Essential KPIs for Nigerian E-Commerce

### 1. Revenue Metrics

#### Total Revenue (Overall Business Health)
```
Metric: SUM(price)
Format: NGN, Compact
Comparison: vs Last Month
Target: NGN 50M
```

**Why It Matters:** Primary indicator of business growth
**Nigerian Context:** Track against monthly rent, salaries, inventory costs

---

#### Average Order Value (AOV)
```
Metric: SUM(price) / COUNT(order_id)
Format: NGN, 2 decimals
Comparison: vs Last Quarter
Target: NGN 3,500
```

**SQL Equivalent:**
```sql
SELECT
    SUM(price) / COUNT(DISTINCT order_id) as avg_order_value
FROM olist_sales_data_set.olist_order_items_dataset;
```

**Why It Matters:** Shows if customers are buying more per transaction
**Business Action:** If decreasing, implement bundle discounts or "complete the look" suggestions

---

#### Revenue Per Customer
```
Metric: SUM(price) / COUNT(DISTINCT customer_id)
Format: NGN, 2 decimals
Comparison: vs Last Year
```

**Why It Matters:** Customer value indicator
**Goal:** Increase through repeat purchases and upselling

---

### 2. Volume Metrics

#### Total Orders
```
Metric: COUNT(order_id)
Format: Number, Compact
Comparison: vs Last Month
Target: 20,000 orders/month
```

**Why It Matters:** Volume drives revenue; early indicator of traffic issues

---

#### Total Customers
```
Metric: COUNT(DISTINCT customer_id)
Format: Number, Compact
Comparison: vs Last Month
```

**Why It Matters:** Growing customer base = sustainable business

---

#### New vs Returning Customers
```
Metric 1: COUNT(first_time_customers)
Metric 2: COUNT(returning_customers)
Format: Number with percentage
```

**Requires Calculated Field:**
```sql
-- Concept from Week 9: Customer segmentation
CASE
    WHEN customer_order_count = 1 THEN 'New'
    ELSE 'Returning'
END
```

---

### 3. Operational Metrics

#### On-Time Delivery Rate
```
Metric: COUNT(on_time_orders) / COUNT(total_orders) * 100
Format: Percentage, 1 decimal
Comparison: vs Target (95%)
```

**Calculated Field Required:**
```
CASE
    WHEN order_delivered_customer_date <= order_estimated_delivery_date THEN 1
    ELSE 0
END
```

**SQL Equivalent:**
```sql
SELECT
    SUM(CASE WHEN order_delivered_customer_date <= order_estimated_delivery_date THEN 1 ELSE 0 END)::FLOAT
    / COUNT(*)::FLOAT * 100 as on_time_percentage
FROM olist_sales_data_set.olist_orders_dataset
WHERE order_status = 'delivered';
```

**Why It Matters:** Customer satisfaction driver; logistics performance indicator

---

#### Average Delivery Time (Days)
```
Metric: AVG(delivery_days)
Format: Number, 1 decimal
Comparison: vs Last Quarter
Target: 5 days
```

**Calculated Field (from Wednesday):**
```
DATE_DIFF(order_delivered_customer_date, order_purchase_timestamp)
```

**Nigerian Context:** Account for Lagos traffic, intercity logistics challenges, festive period delays

---

### 4. Customer Satisfaction Metrics

#### Average Review Score
```
Metric: AVG(review_score)
Format: Number, 2 decimals
Comparison: vs Target (4.5)
Range: 1.0 - 5.0
```

**SQL Source:**
```sql
SELECT AVG(review_score) as avg_review_score
FROM olist_sales_data_set.olist_order_reviews_dataset;
```

**Why It Matters:** Direct customer satisfaction indicator
**Action Trigger:** If < 4.0, investigate top complaints

---

#### Review Response Rate
```
Metric: COUNT(orders_with_reviews) / COUNT(total_delivered_orders) * 100
Format: Percentage, 1 decimal
```

**Why It Matters:** Higher response = more customer engagement data

---

### 5. Financial Health Metrics

#### Gross Profit Margin (Requires Cost Data)
```
Metric: (SUM(revenue) - SUM(cost)) / SUM(revenue) * 100
Format: Percentage, 1 decimal
Target: 35%
```

**Nigerian Context:** Factor in 7.5% VAT, import duties, currency fluctuation costs

---

#### VAT Collected (7.5%)
```
Metric: SUM(price) * 0.075
Format: NGN, Compact
```

**Why It Matters:** Track tax liability for FIRS remittance

---

## Advanced Scorecard Techniques

### Technique 1: Conditional Formatting with Thresholds

**Use Case:** On-Time Delivery Rate scorecard

**Configuration:**
1. **Style** panel → **Metric Value Color**
2. Select **Conditional Formatting**
3. Set Rules:
   - If >= 95%: Green (#4CAF50) - Excellent
   - If >= 85% AND < 95%: Yellow (#FFC107) - Warning
   - If < 85%: Red (#F44336) - Critical

**[SCREENSHOT 6: Conditional formatting rules panel]**
*Caption: Setting color thresholds for performance indicators*

**Result:**
```
┌─────────────────────────┐
│  On-Time Delivery Rate  │
│                         │
│       97.3%             │  ← Green (excellent)
│    ↑ 2.1% vs Target     │
└─────────────────────────┘
```

---

### Technique 2: Compact Metric Layout

**Use Case:** Dashboard header with 4 key metrics

**Layout:** Horizontal row of 4 scorecards

```
┌──────────┬──────────┬──────────┬──────────┐
│ Revenue  │  Orders  │   AOV    │ Customers│
│ 45.3M    │  15.4K   │  2,932   │  8,765   │
│ ↑ 15.3%  │ ↑ 12.1%  │ ↑ 2.8%   │ ↑ 8.4%   │
└──────────┴──────────┴──────────┴──────────┘
```

**Design Tips:**
- Equal widths for visual balance
- Consistent font sizes across all four
- Same comparison period (all vs Last Month)
- Align comparison indicators

---

### Technique 3: Sparkline Scorecard

**Use Case:** Metric with mini trend visualization

**Configuration:**
1. Add scorecard as normal
2. **Style** → Enable **Compact Number with Sparkline**
3. Sparkline shows last 7 or 30 data points

**Result:**
```
┌─────────────────────────┐
│    Total Revenue        │
│                         │
│    NGN 45.3M      ╱╲╱   │  ← Mini trend line
│    ↑ 15.3%        ╲  ╲  │
└─────────────────────────┘
```

**Why It's Powerful:** Single metric + trend context in compact space

---

### Technique 4: Target vs Actual Gauge

**Use Case:** Goal-oriented metrics (sales targets, KPIs)

**Implementation:**
1. Create calculated field:
   ```
   Revenue Target Achievement = SUM(price) / 50000000 * 100
   ```
2. Use **Gauge Chart** instead of scorecard
3. Set range: 0% to 150%
4. Color zones:
   - 0-80%: Red (below target)
   - 80-100%: Yellow (approaching target)
   - 100-150%: Green (exceeding target)

**[SCREENSHOT 7: Gauge chart showing target achievement]**
*Caption: Revenue target achievement gauge with color-coded performance zones*

---

## Scorecard Layout Best Practices

### Rule 1: Hierarchy - Most Important First

**Top of Dashboard (above the fold):**
- Total Revenue
- Total Orders
- Average Order Value

**Secondary Level:**
- Customer metrics
- Operational metrics
- Satisfaction metrics

---

### Rule 2: Grouping by Category

**Revenue Group:**
```
┌─────────────────────────────────────────┐
│  REVENUE METRICS                        │
├──────────┬──────────┬──────────┐        │
│ Total    │   AOV    │  Per     │        │
│ Revenue  │          │ Customer │        │
└──────────┴──────────┴──────────┘        │
```

**Operations Group:**
```
┌─────────────────────────────────────────┐
│  OPERATIONS                             │
├──────────┬──────────┬──────────┐        │
│ Orders   │ Delivery │ Review   │        │
│          │ Rate     │ Score    │        │
└──────────┴──────────┴──────────┘        │
```

---

### Rule 3: Consistent Comparison Periods

**Don't Mix:**
- Total Revenue (vs Last Month)
- Total Orders (vs Last Week) ← Inconsistent!
- AOV (vs Last Year) ← Confusing!

**Do Use:**
- All metrics vs Last Month
- Clear section labels if mixing periods

---

### Rule 4: Mobile Responsiveness

**Desktop View (4 columns):**
```
│ Revenue │ Orders │ AOV │ Customers │
```

**Mobile View (2 columns, stacked):**
```
│ Revenue  │ Orders    │
│ AOV      │ Customers │
```

**Looker Studio Auto-Stacking:**
- Scorecards automatically reflow on mobile
- Test your dashboard on mobile devices
- Ensure font sizes are readable (min 24px for metric value)

---

## Nigerian Business Context: KPI Examples

### Example 1: Lagos Marketplace Dashboard

**Top KPIs (Scorecard Row):**

**Total GMV (Gross Merchandise Value)**
- Metric: SUM(price + freight_value)
- Comparison: vs Last Month
- Format: NGN Millions

**Active Vendors**
- Metric: COUNT(DISTINCT seller_id)
- Comparison: vs Last Quarter
- Format: Number

**Platform Commission**
- Metric: SUM(price) * 0.15 (15% commission)
- Comparison: vs Revenue Target
- Format: NGN Thousands

**Customer Retention Rate**
- Metric: Returning Customers / Total Customers * 100
- Comparison: vs Last Month
- Format: Percentage

---

### Example 2: Festive Season Performance (December)

**December Specific KPIs:**

**Holiday Sales Lift**
- Metric: December Revenue / Average Monthly Revenue
- Format: Multiplier (e.g., 2.3x normal)

**Peak Day Performance**
- Metric: MAX(daily_revenue)
- Date: Show date of peak
- Format: NGN + Date

**Stock Availability**
- Metric: Products In Stock / Total Products * 100
- Critical during high-demand periods
- Format: Percentage

---

## Common Scorecard Mistakes to Avoid

### Mistake 1: Too Many Decimals
**Wrong:** NGN 45,250,327.48
**Right:** NGN 45.3M

**Why:** Precision doesn't add value for executive metrics

---

### Mistake 2: Missing Context
**Wrong:** Just showing "5,432"
**Right:** "5,432 Orders (↑ 12.3% vs Last Month)"

**Why:** Numbers without context are meaningless

---

### Mistake 3: Inconsistent Formatting
**Wrong:**
- Total Revenue: 45,250,000
- Total Orders: 15.4K ← Compact
- AOV: ₦2,932 ← Different currency symbol

**Right:** All use same number format system

---

### Mistake 4: Misleading Comparisons
**Wrong:** Comparing December (high season) to January (low season)
**Right:** Comparing December 2025 to December 2024 (year-over-year)

---

## Hands-On Exercise Preview

**Task:** Create 4 scorecard KPIs for executive dashboard

You'll create:
1. **Total Revenue** - SUM(price), NGN format, vs Last Month
2. **Total Orders** - COUNT(order_id), compact format, vs Last Month
3. **Average Order Value** - Revenue / Orders, NGN format, vs Last Quarter
4. **Customer Count** - COUNT(DISTINCT customer_id), number format, vs Last Month

**All using:**
- Proper NGN currency formatting
- Compact number display where appropriate
- Consistent comparison periods
- Professional styling with conditional formatting

---

## Key Takeaways

1. **Scorecards are for single, important metrics** - Don't overcomplicate
2. **Context through comparison** - Always show vs something (period, target)
3. **Format for readability** - NGN, compact numbers, appropriate decimals
4. **Visual indicators matter** - Colors, arrows, clear labels
5. **Mobile-first thinking** - Ensure scorecards work on all devices

---

## Connection to SQL Skills

| SQL Concept | Looker Scorecard Application |
|-------------|------------------------------|
| **SUM(column)** | Total Revenue, Total Sales metrics |
| **COUNT(*)** | Order count, Customer count |
| **AVG(column)** | Average Order Value, Average Rating |
| **CASE WHEN** | Conditional metrics (on-time %, category flags) |
| **WHERE clauses** | Filters applied to scorecard data source |
| **Date functions** | Comparison period calculations |

---

**Next Section:** Time Series Visualization (03_time_series_visualization.md)
**Practice:** Create your first scorecards in the hands-on exercise

**[SCREENSHOT 8: Complete scorecard dashboard example]**
*Caption: Professional executive dashboard with 8 scorecards showing key Nigerian e-commerce metrics*

---

## Additional Resources

- **Number Formatting Guide:** Full list of Looker Studio number format codes
- **Color Psychology:** Choosing the right colors for your brand and audience
- **Comparison Calculation Reference:** All comparison types explained
- **Mobile Dashboard Checklist:** Ensure your scorecards work on all devices
