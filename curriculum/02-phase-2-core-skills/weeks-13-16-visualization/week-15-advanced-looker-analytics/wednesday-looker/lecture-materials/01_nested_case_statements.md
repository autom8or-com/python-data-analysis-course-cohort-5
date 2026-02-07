# Nested CASE Statements in Google Looker Studio

## Week 15 - Wednesday Session - Part 1

### Duration: 15 minutes

---

## What Are Nested CASE Statements?

**Nested CASE statements** allow you to build complex conditional logic by placing one CASE statement inside another. They enable multi-level categorization and sophisticated business rules that go beyond simple if-then logic.

### Connection to Prior Learning

**Week 3: SQL Complex CASE Logic**
```sql
-- SQL nested CASE for customer segmentation
CASE
  WHEN total_orders >= 5 THEN
    CASE
      WHEN total_revenue >= 5000 THEN 'VIP Champion'
      WHEN total_revenue >= 2000 THEN 'Loyal Customer'
      ELSE 'Frequent Buyer'
    END
  WHEN total_orders >= 2 THEN 'Repeat Customer'
  ELSE 'New Customer'
END
```

**Looker Studio Equivalent:** Same logic, visual interface for building and testing.

---

## Why Nested CASE Statements Matter

### Business Scenarios Requiring Complex Logic

**Scenario 1: Customer Lifetime Value Tiering**

Your marketing team needs to segment customers not just by total spending, but by combining purchase frequency AND monetary value:

- **VIP Champions**: High frequency (4+ orders) AND high value ($5K+)
- **Loyal Customers**: Moderate frequency (2-3 orders) AND high value ($2K+)
- **Growing Customers**: Any frequency with moderate value ($500-$2K)
- **At-Risk**: Low frequency (<2 orders) but previously high value
- **New Customers**: Everything else

**Simple CASE Won't Work:** You need multiple conditions evaluated hierarchically.

**Scenario 2: Delivery Performance Classification**

Logistics team wants granular delivery categories based on actual vs. promised delivery:

- **Express**: Delivered 3+ days early
- **On Time**: Within promised window
- **Minor Delay**: 1-3 days late
- **Major Delay**: 4-7 days late
- **Critical Delay**: 8+ days late AND high-value order

This requires comparing dates AND checking order values conditionally.

---

## Understanding Looker Studio CASE Syntax

### Basic CASE Review

```
CASE
  WHEN condition THEN result
  WHEN condition THEN result
  ELSE default_result
END
```

**Key Points:**
- Evaluates conditions top-to-bottom
- Returns result for first TRUE condition
- ELSE catches everything that doesn't match
- Must end with END keyword

### Nested CASE Structure

```
CASE
  WHEN outer_condition THEN
    CASE
      WHEN inner_condition THEN inner_result_1
      WHEN inner_condition THEN inner_result_2
      ELSE inner_default
    END
  WHEN outer_condition THEN outer_result_2
  ELSE outer_default
END
```

**Execution Flow:**
1. Evaluate outer WHEN condition
2. If TRUE, enter inner CASE
3. Evaluate inner conditions
4. Return appropriate result
5. If outer FALSE, move to next outer WHEN

---

## Example 1: CLV Tier Classification (Corrected from Validation)

### Business Context

The validation report revealed that the README's original CLV thresholds ($500K+) were unrealistic for the Olist dataset. Top customers spend ~$13K-14K, not $500K. We need corrected, data-appropriate tiers.

### Corrected CLV Tiers (from validation report)

- **VIP Champion**: ≥ $5,000 (top 0.01% of customers)
- **Loyal Customer**: ≥ $2,000 (high-value repeat buyers)
- **Growing Customer**: ≥ $500 (engaged with potential)
- **New Customer**: < $500 (majority of customer base)

### Simple CASE Implementation

First, let's see the straightforward approach:

```
CASE
  WHEN Total_Revenue >= 5000 THEN "VIP Champion"
  WHEN Total_Revenue >= 2000 THEN "Loyal Customer"
  WHEN Total_Revenue >= 500 THEN "Growing Customer"
  ELSE "New Customer"
END
```

**This works!** But what if we want to add frequency requirements?

### Enhanced: Nested CASE with Frequency

**Business Requirement:** VIP Champions must have BOTH high revenue ($5K+) AND multiple orders (3+). Otherwise, they might be one-time bulk buyers, not true VIPs.

```
CASE
  WHEN Total_Revenue >= 5000 THEN
    CASE
      WHEN Order_Count >= 3 THEN "VIP Champion - Engaged"
      ELSE "VIP Champion - One-Time"
    END
  WHEN Total_Revenue >= 2000 THEN
    CASE
      WHEN Order_Count >= 2 THEN "Loyal Customer"
      ELSE "High-Value Prospect"
    END
  WHEN Total_Revenue >= 500 THEN "Growing Customer"
  ELSE
    CASE
      WHEN Order_Count >= 2 THEN "Frequent Low-Spender"
      ELSE "New Customer"
    END
END
```

**Result:** 6 distinct customer segments instead of 4, with nuanced business logic.

### Creating This in Looker Studio

**Step 1: Add Calculated Field**

1. Click on your data source in Looker Studio
2. Click "ADD A FIELD" button (top-right)
3. Name: `Customer_Segment_Advanced`
4. Formula: [Paste nested CASE above]
5. Click "SAVE"

**Step 2: Test the Field**

1. Create a **Table** chart
2. Dimensions: `customer_unique_id`, `Customer_Segment_Advanced`
3. Metrics: `SUM(payment_value)` as Total_Revenue, `COUNT(order_id)` as Order_Count
4. Sort by Total_Revenue descending
5. Filter: Show top 20 customers

**Expected Results:**
| customer_unique_id | Customer_Segment_Advanced | Total_Revenue | Order_Count |
|--------------------|---------------------------|---------------|-------------|
| 0a0a92112bd4c708... | VIP Champion - One-Time | $13,664.10 | 1 |
| c8460e4251689ba2... | VIP Champion - Engaged | $4,655.91 | 4 |
| da122df9eeddfedc... | Loyal Customer | $7,571.63 | 2 |

**Insight:** Top revenue customer is one-time buyer, while engaged VIPs have multiple orders.

---

## Example 2: Delivery Performance with Value Consideration

### Business Context

From the validation report, we know 75% of orders are delayed. But not all delays are equal:
- A $500 order delayed by 2 days: Annoying
- A $50 order delayed by 2 days: Acceptable
- A $500 order delayed by 10 days: Critical

We need nested logic to flag high-priority delivery issues.

### Delivery Days Calculation (Prerequisite)

First, create a calculated field for delivery days:

**Field Name:** `Delivery_Days`

**Formula:**
```
DATE_DIFF(order_delivered_customer_date, order_purchase_timestamp, DAY)
```

**Looker Studio Function:** `DATE_DIFF(date1, date2, unit)`
- Returns numeric difference between two dates
- Unit can be: DAY, WEEK, MONTH, YEAR

### Simple Delivery Category

```
CASE
  WHEN Delivery_Days <= 3 THEN "Express"
  WHEN Delivery_Days <= 7 THEN "Standard"
  WHEN Delivery_Days <= 14 THEN "Delayed"
  ELSE "Critical Delay"
END
```

### Enhanced: Nested with Order Value Priority

**Field Name:** `Delivery_Performance_Priority`

**Formula:**
```
CASE
  WHEN Delivery_Days <= 7 THEN
    CASE
      WHEN payment_value >= 500 THEN "On-Time Premium"
      ELSE "On-Time Standard"
    END
  WHEN Delivery_Days <= 14 THEN
    CASE
      WHEN payment_value >= 500 THEN "⚠️ Delayed Premium (Priority Fix)"
      WHEN payment_value >= 200 THEN "⚠️ Delayed Mid-Value"
      ELSE "Delayed Standard"
    END
  ELSE
    CASE
      WHEN payment_value >= 500 THEN "🚨 CRITICAL - High Value Late"
      WHEN payment_value >= 200 THEN "🚨 CRITICAL - Mid Value Late"
      ELSE "Critical Delay - Standard"
    END
END
```

**Business Value:**
- Operations team can filter for "🚨 CRITICAL - High Value Late" to prioritize customer service outreach
- Identifies where delays hurt most (premium orders)
- Separate tracking for standard delays vs. critical issues

### Creating in Looker Studio

**Step 1: Create Delivery_Days Field (if not exists)**

1. Data source → Add Field
2. Name: `Delivery_Days`
3. Formula: `DATE_DIFF(order_delivered_customer_date, order_purchase_timestamp, DAY)`
4. Save

**Step 2: Create Nested Performance Field**

1. Data source → Add Field
2. Name: `Delivery_Performance_Priority`
3. Formula: [Paste nested CASE above]
4. Save

**Step 3: Build Priority Dashboard**

Create a **Table** with:
- Dimension: `Delivery_Performance_Priority`
- Metrics: `COUNT(order_id)` as Order_Count, `AVG(Delivery_Days)`, `SUM(payment_value)` as Revenue_at_Risk
- Sort: By Revenue_at_Risk descending

**Expected Insight:** Critical high-value delays represent small order count but significant revenue risk.

---

## Example 3: Marketing Channel Quality Score

### Business Context

Not all marketing channels are equal. The validation report shows:
- **Best performers**: Unknown (7.37%), Paid Search (6.37%), Direct Traffic (6.21%)
- **Worst performers**: Email (1.22%), Display (1.69%), Other Publicities (0%)

Create a nested quality score combining conversion rate AND lead volume.

### Prerequisites

You need these fields (from marketing data):
- `origin` (marketing channel)
- `Conversion_Rate` (calculated: converted_leads / total_leads)
- `Lead_Volume` (COUNT of mql_id)

### Nested Channel Quality Score

**Field Name:** `Channel_Quality_Score`

**Formula:**
```
CASE
  WHEN Conversion_Rate >= 0.06 THEN
    CASE
      WHEN Lead_Volume >= 1000 THEN "A+ Tier - Scale Up"
      WHEN Lead_Volume >= 500 THEN "A Tier - Invest More"
      ELSE "A Tier - Test Scaling"
    END
  WHEN Conversion_Rate >= 0.04 THEN
    CASE
      WHEN Lead_Volume >= 1000 THEN "B+ Tier - Optimize & Scale"
      ELSE "B Tier - Optimize First"
    END
  WHEN Conversion_Rate >= 0.02 THEN
    CASE
      WHEN Lead_Volume >= 1000 THEN "C Tier - High Volume, Low Quality"
      ELSE "C Tier - Improve or Reduce"
    END
  ELSE "D Tier - Cut or Redesign"
END
```

**Strategic Decisions Enabled:**
- **A+ Tier (Paid Search: 6.37%, 1,586 leads)**: Increase budget immediately
- **D Tier (Email: 1.22%)**: Pause campaigns, redesign strategy
- **C Tier (Social: 2.30%, 1,350 leads)**: High volume but poor quality—optimize targeting

### Building the Dashboard

Create a **Scorecard Grid**:

**Layout:**
```
┌─────────────────────────────────────────────────┐
│  Marketing Channel Performance Matrix           │
├─────────────────────────────────────────────────┤
│                                                 │
│  A+ Tier - Scale Up                             │
│  [Paid Search]  1,586 leads | 6.37% conv       │
│  💰 Action: +50% budget                         │
│                                                 │
│  B+ Tier - Optimize & Scale                     │
│  [Organic Search]  2,296 leads | 4.92% conv    │
│  📊 Action: Improve SEO, then scale             │
│                                                 │
│  C Tier - High Volume, Low Quality              │
│  [Social]  1,350 leads | 2.30% conv            │
│  ⚠️ Action: Retarget or reduce spend            │
│                                                 │
│  D Tier - Cut or Redesign                       │
│  [Email]  493 leads | 1.22% conv               │
│  🛑 Action: Pause and redesign                  │
│                                                 │
└─────────────────────────────────────────────────┘
```

---

## Common Nested CASE Patterns

### Pattern 1: Tiered Hierarchy

```
CASE
  WHEN top_tier_condition THEN "Tier 1"
  WHEN mid_tier_condition THEN
    CASE
      WHEN sub_condition THEN "Tier 2A"
      ELSE "Tier 2B"
    END
  ELSE "Tier 3"
END
```

**Use Cases:** Customer segments, product categories, risk levels

### Pattern 2: Multi-Criteria Decision Tree

```
CASE
  WHEN primary_metric >= threshold THEN
    CASE
      WHEN secondary_metric >= threshold THEN "Best"
      WHEN secondary_metric >= lower_threshold THEN "Good"
      ELSE "Caution"
    END
  WHEN primary_metric >= lower_threshold THEN
    CASE
      WHEN secondary_metric >= threshold THEN "Potential"
      ELSE "Standard"
    END
  ELSE "Below Target"
END
```

**Use Cases:** Performance ratings, quality scores, prioritization

### Pattern 3: Conditional Formatting Logic

```
CASE
  WHEN metric_value > target THEN
    CASE
      WHEN metric_value > target * 1.2 THEN "🟢 Exceptional"
      ELSE "🟢 On Target"
    END
  WHEN metric_value > target * 0.9 THEN "🟡 Nearly There"
  WHEN metric_value > target * 0.7 THEN "🟠 Below Target"
  ELSE "🔴 Critical"
END
```

**Use Cases:** KPI dashboards, alerts, performance tracking

---

## Building Your First Nested CASE: Step-by-Step

### Exercise: Create RFM Segment Names

**Context:** Week 9 taught you RFM scoring (Recency, Frequency, Monetary). Now create human-readable segment names from RFM scores using nested CASE.

**RFM Score:** Three-digit string like "555" (best) or "111" (worst)

**Step 1: Understand RFM Concatenation (from README)**

You should already have this field:

```
RFM_Score = CONCAT(
  CAST(Recency_Score AS STRING),
  CAST(Frequency_Score AS STRING),
  CAST(Monetary_Score AS STRING)
)
```

**Step 2: Create Nested Segment Names**

**Field Name:** `RFM_Segment_Name`

**Formula:**
```
CASE
  -- Champions: High across all dimensions
  WHEN RFM_Score IN ("555", "554", "544", "545") THEN "🏆 Champions"

  -- Loyal Customers: High F and M, any R
  WHEN Frequency_Score >= 4 AND Monetary_Score >= 4 THEN
    CASE
      WHEN Recency_Score >= 4 THEN "💎 Loyal - Active"
      ELSE "💎 Loyal - Needs Reactivation"
    END

  -- Promising: High M or F, but not both
  WHEN Monetary_Score >= 4 OR Frequency_Score >= 4 THEN
    CASE
      WHEN Recency_Score >= 3 THEN "⭐ Promising - Recent"
      ELSE "⭐ Promising - Dormant"
    END

  -- At Risk: Previously valuable, now inactive
  WHEN (Frequency_Score >= 3 OR Monetary_Score >= 3) AND Recency_Score <= 2 THEN "⚠️ At Risk - Win Back"

  -- New Customers: High R, low F
  WHEN Recency_Score >= 4 AND Frequency_Score <= 2 THEN "🌱 New Customers"

  -- Lost: Low across all
  WHEN Recency_Score <= 2 AND Frequency_Score <= 2 AND Monetary_Score <= 2 THEN "❌ Lost"

  ELSE "📊 Other"
END
```

**Step 3: Test Your Formula**

1. Create a **Table** chart
2. Dimensions: `RFM_Score`, `RFM_Segment_Name`
3. Metrics: `COUNT(customer_unique_id)` as Customer_Count, `SUM(payment_value)` as Total_Revenue
4. Sort by Total_Revenue descending

**Step 4: Validate Against Business Logic**

- **Champions (555-545)**: Should have highest revenue per customer
- **At Risk**: Should show recent drop in activity (low R, previously high F/M)
- **New Customers**: High R, low F (only 1-2 orders)

---

## Common Errors and Debugging

### Error 1: "Syntax error near CASE"

**Cause:** Missing END keyword

**Bad:**
```
CASE
  WHEN condition THEN
    CASE
      WHEN inner THEN "result"
    -- Missing END here!
  ELSE "default"
END
```

**Fixed:**
```
CASE
  WHEN condition THEN
    CASE
      WHEN inner THEN "result"
    END  -- Added!
  ELSE "default"
END
```

### Error 2: "All WHEN branches return different data types"

**Cause:** Mixing text and numbers in results

**Bad:**
```
CASE
  WHEN revenue > 5000 THEN "VIP"
  WHEN revenue > 2000 THEN 2  -- Number instead of text!
  ELSE "Standard"
END
```

**Fixed:**
```
CASE
  WHEN revenue > 5000 THEN "VIP"
  WHEN revenue > 2000 THEN "Loyal"  -- Now consistent text
  ELSE "Standard"
END
```

### Error 3: "Field not found: inner_field"

**Cause:** Referencing field that doesn't exist at outer CASE level

**Problem:** You're trying to use a calculated field inside another calculated field before it's defined.

**Solution:** Create fields in order:
1. First: `Delivery_Days` (basic calculation)
2. Then: `Delivery_Performance` (uses Delivery_Days)
3. Finally: `Delivery_Priority` (uses Delivery_Performance)

### Error 4: Nested CASE Returns NULL Unexpectedly

**Cause:** Missing ELSE in inner CASE

**Bad:**
```
CASE
  WHEN revenue >= 5000 THEN
    CASE
      WHEN orders >= 3 THEN "VIP Champion"
      -- What if orders < 3? Returns NULL!
    END
  ELSE "Standard"
END
```

**Fixed:**
```
CASE
  WHEN revenue >= 5000 THEN
    CASE
      WHEN orders >= 3 THEN "VIP Champion"
      ELSE "VIP One-Time"  -- Added ELSE!
    END
  ELSE "Standard"
END
```

---

## Performance Considerations

### Nested CASE Can Be Slow on Large Datasets

**Why:** Each condition is evaluated sequentially for every row.

**Best Practices:**

1. **Order Conditions by Likelihood**
   - Put most common cases first
   - Reduces average evaluation time

2. **Limit Nesting Depth**
   - Max 2-3 levels of nesting
   - Deeper nesting = harder to maintain and slower

3. **Pre-Calculate When Possible**
   - If using same logic multiple times, create intermediate calculated fields
   - Example: Calculate `Is_Premium_Order` once, reuse in multiple nested CASEs

4. **Use Backend Filtering**
   - Apply data source filters before complex CASE evaluation
   - Example: Filter to `order_status = 'delivered'` at data source level

### When to Pre-Aggregate vs. Calculate in Looker

**Pre-Aggregate in SQL (Data Source) When:**
- Logic is reused across multiple dashboards
- Calculation involves complex joins or window functions
- Performance is critical (millions of rows)

**Calculate in Looker When:**
- Logic changes frequently (business rules evolve)
- Different stakeholders need different categorizations
- You want flexibility without modifying data source

---

## Key Takeaways

### What You Learned

1. ✅ Nested CASE statements enable multi-level conditional logic
2. ✅ Looker Studio syntax mirrors SQL CASE but with visual interface
3. ✅ Always include ELSE in inner CASE to avoid unexpected NULLs
4. ✅ Order conditions from most to least likely for performance
5. ✅ Nested logic is powerful for customer segmentation, prioritization, and scoring
6. ✅ Corrected CLV tiers: $5K (VIP), $2K (Loyal), $500 (Growing), <$500 (New)

### Connection to SQL Learning

**Week 3 SQL:**
```sql
CASE
  WHEN condition THEN
    CASE WHEN inner THEN result END
END
```

**Looker Studio:** Same logic, same syntax, different interface.

**Advantage:** Looker allows business users to modify logic without SQL access.

### What's Next

In the next lesson, we'll explore **string functions** for advanced categorization and text manipulation in Looker Studio.

---

## Quick Reference Card

### Nested CASE Template

```
CASE
  WHEN outer_condition_1 THEN
    CASE
      WHEN inner_condition_1 THEN "Result A1"
      WHEN inner_condition_2 THEN "Result A2"
      ELSE "Result A Default"
    END
  WHEN outer_condition_2 THEN "Result B"
  ELSE "Default Result"
END
```

### Common Business Applications

| Use Case | Outer CASE | Inner CASE |
|----------|-----------|------------|
| Customer Segments | Revenue tiers | Frequency within tier |
| Delivery Priority | Delay severity | Order value |
| Marketing ROI | Conversion rate | Lead volume |
| Product Categories | Price range | Stock level |

---

## Practice Exercise (5 minutes)

**Task:** Create a nested CASE for order size classification

**Business Rules:**
- **Large Orders** (payment_value ≥ $500):
  - If ≥3 items: "Large - Multiple Items"
  - If <3 items: "Large - Bulk Single Item"
- **Medium Orders** ($100-$499):
  - If ≥2 items: "Medium - Multi-Item"
  - If 1 item: "Medium - Single Item"
- **Small Orders** (<$100): "Small Order"

**Formula:** [Try writing it yourself before looking at solution below]

<details>
<summary>Click to reveal solution</summary>

```
CASE
  WHEN payment_value >= 500 THEN
    CASE
      WHEN item_count >= 3 THEN "Large - Multiple Items"
      ELSE "Large - Bulk Single Item"
    END
  WHEN payment_value >= 100 THEN
    CASE
      WHEN item_count >= 2 THEN "Medium - Multi-Item"
      ELSE "Medium - Single Item"
    END
  ELSE "Small Order"
END
```
</details>

---

**Next Lecture:** 02_string_functions_categorization.md
