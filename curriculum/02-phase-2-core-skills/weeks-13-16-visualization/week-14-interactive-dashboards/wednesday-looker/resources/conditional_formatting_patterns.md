# Conditional Formatting Patterns

## Common Formatting Patterns with Examples for Looker Studio

**Last Updated:** Week 14, January 2026

---

## What is Conditional Formatting?

**Definition:** Conditional formatting applies visual styles (colors, fonts, backgrounds) to data based on values or rules, making patterns and outliers immediately visible.

**Business Value:**
- **Speed:** Identify issues in seconds (not minutes)
- **Focus:** Directs attention to what matters
- **Understanding:** Non-technical users grasp insights faster
- **Action:** Clear visual triggers for decisions

---

## Formatting Type Reference

### 1. Single Color

**What:** Apply one color when condition is met

**Use Cases:**
- Alert conditions (delivery >15 days = red)
- Target achievement (revenue >$1M = green)
- Status indicators (order status = "Late" = red)

**Configuration:**
```
If: [Condition]
Color Type: Single color
├── Background color: [Hex code]
├── Font color: [Hex code]
└── Font style: Normal/Bold/Italic
```

---

### 2. Color Scale (Gradient)

**What:** Apply gradient across value range (low to high)

**Use Cases:**
- Performance metrics (low revenue = red, high = green)
- Heat maps (identify hot spots)
- Comparative analysis (regional performance)

**Configuration:**
```
Color Type: Color scale
├── Scale Type: Gradient
├── Minimum value color: [Hex]
├── Midpoint value color: [Hex] (optional)
└── Maximum value color: [Hex]
```

**Common Color Schemes:**

| Scheme Name | Min → Mid → Max | Best For |
|-------------|-----------------|----------|
| **Red-Yellow-Green** | #F8D7DA → #FFF3CD → #D4EDDA | KPIs, performance metrics |
| **White-Blue** | #FFFFFF → #E3F2FD → #1565C0 | Heat maps, density |
| **White-Green** | #FFFFFF → #E8F5E9 → #1B5E20 | Revenue, growth metrics |
| **Red-White-Green** | #C62828 → #FFFFFF → #2E7D32 | Profit/loss, variance |
| **Purple Gradient** | #F3E5F5 → #9C27B0 → #4A148C | Single-direction intensity |

---

### 3. Data Bars

**What:** Horizontal bars proportional to values (like Excel data bars)

**Use Cases:**
- Table columns showing relative sizes
- Revenue comparison across products
- Order volume by state

**Configuration:**
```
Color Type: Data bars
├── Bar color: [Hex]
├── Show values: ☑ Yes (shows number + bar)
├── Bar direction: Left to right
└── Max bar width: 100% of cell
```

**Example:**
```
Product Revenue Table:
Product A: $50,000  ████████████████████
Product B: $35,000  ██████████████
Product C: $20,000  ████████
Product D: $10,000  ████
```

---

## Pattern Library

### Pattern 1: Traffic Light (KPI Scorecards)

**Use Case:** Performance scorecards (on-time delivery, customer satisfaction)

**Visual:**
```
🟢 Green: Excellent (>90%)
🟡 Yellow: Acceptable (75-90%)
🔴 Red: Needs Attention (<75%)
```

**Configuration:**
```
Rule 1:
If: on_time_rate >= 0.90
Background: #28A745 (green)
Font: #FFFFFF (white)

Rule 2:
If: on_time_rate >= 0.75 AND on_time_rate < 0.90
Background: #FFC107 (yellow)
Font: #333333 (dark gray)

Rule 3:
If: on_time_rate < 0.75
Background: #DC3545 (red)
Font: #FFFFFF (white)
```

**Example Metrics:**
- On-time delivery rate
- Customer satisfaction score
- Quality control pass rate
- Sales target achievement

---

### Pattern 2: Threshold Alert (Single Boundary)

**Use Case:** Highlight values exceeding a critical threshold

**Visual:**
- Normal values: Default styling
- Alert values: Red background

**Configuration:**
```
Rule 1:
If: delivery_time_days > 15
Background: #FFCDD2 (light red)
Font: #B71C1C (dark red)
Font style: Bold
```

**Example Metrics:**
- Delivery time exceeding SLA
- Inventory below reorder point
- Customer complaints above limit
- Response time over target

**Pro Tip:** Use light background + dark text for better readability than bright red.

---

### Pattern 3: Top/Bottom N Highlighting

**Use Case:** Emphasize top performers or bottom performers

**Visual:**
```
Top 3: Green background
Middle: Default
Bottom 3: Red background
```

**Configuration (Requires Calculated Field):**

Step 1: Create rank field
```
rank_by_revenue = RANK(SUM(revenue), "desc")
```

Step 2: Apply formatting
```
Rule 1 (Top Performers):
If: rank_by_revenue <= 3
Background: #E8F5E9 (light green)
Font: #2E7D32 (dark green)
Font style: Bold

Rule 2 (Bottom Performers):
If: rank_by_revenue >= COUNT_DISTINCT(region) - 2
Background: #FFEBEE (light red)
Font: #C62828 (dark red)
```

**Example Use Cases:**
- Top 5 sales regions
- Bottom 10 performing products
- Highest/lowest customer satisfaction states

---

### Pattern 4: Variance Analysis (Positive/Negative)

**Use Case:** Period-over-period comparisons, budget variance

**Visual:**
```
Positive change (+10%): Green
Negative change (-5%): Red
No change (0-2%): Gray
```

**Configuration:**
```
Rule 1 (Growth):
If: percent_change > 0.05
Background: #E8F5E9
Font: #2E7D32
Prefix: "↑ " (up arrow)

Rule 2 (Decline):
If: percent_change < -0.05
Background: #FFEBEE
Font: #C62828
Prefix: "↓ " (down arrow)

Rule 3 (Neutral):
If: percent_change >= -0.05 AND percent_change <= 0.05
Background: #F5F5F5
Font: #757575
Prefix: "→ " (right arrow)
```

**Calculated Field:**
```
percent_change = (current_period - previous_period) / previous_period
```

**Example Metrics:**
- Revenue vs. budget
- This month vs. last month sales
- Actual vs. forecast variance

---

### Pattern 5: Heat Map Table

**Use Case:** Multi-dimensional comparison (regions × months)

**Visual:** Gradient coloring across entire table

**Configuration:**
```
Apply to: [Metric column, e.g., SUM(revenue)]
Color Type: Color scale
Scale Type: Gradient
├── Minimum: #FFFFFF (white)
├── Midpoint: #FFF9C4 (light yellow)
└── Maximum: #1B5E20 (dark green)

Calculation: Percentile-based
└── Min = 10th percentile
    Mid = 50th percentile
    Max = 90th percentile
```

**Why Percentile-Based?** Avoids extreme outliers skewing the scale.

**Example:**
```
Revenue by Region × Month:

Region    | Jan     | Feb     | Mar     | Apr     |
─────────────────────────────────────────────────────
Southeast | $500K ██| $550K ██| $600K ███| $580K ██|
South     | $200K ░ | $220K ░ | $210K ░ | $230K ░ |
Northeast | $150K   | $160K   | $155K   | $165K   |
(Darker = Higher Revenue)
```

---

### Pattern 6: Symbol-Based Indicators

**Use Case:** Add visual symbols for quick scanning

**Visual:**
```
✓ Checkmark: Achieved target
⚠ Warning: Approaching threshold
✗ X-mark: Failed target
● Dot: In progress
```

**Configuration:**
```
Rule 1:
If: delivery_status = "On Time"
Background: #E8F5E9
Font: #2E7D32
Prefix text: "✓ "

Rule 2:
If: delivery_status = "Late"
Background: #FFEBEE
Font: #C62828
Prefix text: "⚠ "

Rule 3:
If: delivery_status = "Pending"
Background: #E3F2FD
Font: #1565C0
Prefix text: "● "
```

**Accessibility Note:** Always combine symbols with color (for colorblind users).

---

### Pattern 7: Percentile Banding

**Use Case:** Categorize into performance bands

**Visual:**
```
Top 25%: Dark green
25-50%: Light green
50-75%: Light yellow
Bottom 25%: Light red
```

**Configuration (Requires Calculated Field):**

Step 1: Create percentile field
```
revenue_percentile = PERCENTILE(SUM(revenue))
```

Step 2: Apply banding
```
Rule 1:
If: revenue_percentile >= 0.75
Background: #1B5E20
Font: #FFFFFF

Rule 2:
If: revenue_percentile >= 0.50 AND revenue_percentile < 0.75
Background: #A5D6A7
Font: #1B5E20

Rule 3:
If: revenue_percentile >= 0.25 AND revenue_percentile < 0.50
Background: #FFF9C4
Font: #F57F17

Rule 4:
If: revenue_percentile < 0.25
Background: #FFCDD2
Font: #B71C1C
```

---

### Pattern 8: Comparison Scorecard

**Use Case:** Show current vs. previous period with visual indicator

**Visual:**
```
┌────────────────────┐
│ Total Revenue      │
│                    │
│   $950,000         │
│   ↑ +15.2%         │
│   vs Previous      │
└────────────────────┘
(Green if positive, red if negative)
```

**Configuration:**

Enable comparison in scorecard:
```
Data Tab:
☑ Comparison date range
└── Type: Previous period

Style Tab:
Positive change color: #34A853 (green)
Negative change color: #EA4335 (red)
Show comparison: ☑ Yes
Comparison label: "vs Previous Period"
```

Add conditional formatting:
```
Rule 1:
If: Percent change > 0.10
Background: #E8F5E9
Font: #2E7D32

Rule 2:
If: Percent change < -0.10
Background: #FFEBEE
Font: #C62828
```

---

## E-commerce Specific Patterns

### Pattern 9: Order Value Tier Coloring

**Use Case:** Categorize orders by value tier

**Configuration:**
```
Rule 1 (Premium Orders):
If: total_order_value >= 500
Background: #FFF8E1 (gold tint)
Font: #F57F17 (dark gold)
Prefix: "💎 "

Rule 2 (Large Orders):
If: total_order_value >= 200 AND total_order_value < 500
Background: #E3F2FD
Font: #1565C0

Rule 3 (Medium Orders):
If: total_order_value >= 50 AND total_order_value < 200
Background: #F5F5F5
Font: #333333

Rule 4 (Small Orders):
If: total_order_value < 50
Background: #FFFFFF
Font: #757575
```

---

### Pattern 10: Delivery Performance Matrix

**Use Case:** Delivery time vs. delivery status combined

**Configuration:**
```
Rule 1 (Excellent - Early):
If: delivery_time_days < estimated_days AND delivery_status = "On Time"
Background: #C8E6C9
Font: #1B5E20
Prefix: "⚡ Fast: "

Rule 2 (Good - On Time):
If: delivery_time_days <= estimated_days AND delivery_status = "On Time"
Background: #E8F5E9
Font: #2E7D32
Prefix: "✓ "

Rule 3 (Warning - Close Call):
If: delivery_time_days <= estimated_days + 2 AND delivery_status = "Late"
Background: #FFF3CD
Font: #856404
Prefix: "⚠ "

Rule 4 (Critical - Very Late):
If: delivery_time_days > estimated_days + 5
Background: #F8D7DA
Font: #721C24
Prefix: "🔴 "
```

---

## Color Palette Reference

### Recommended Color Schemes

**Google Material Design (Accessible):**
```
Green (Success):
├── Light: #E8F5E9
├── Medium: #81C784
└── Dark: #2E7D32

Yellow (Warning):
├── Light: #FFF3CD
├── Medium: #FFD54F
└── Dark: #F57F17

Red (Alert):
├── Light: #FFEBEE
├── Medium: #E57373
└── Dark: #C62828

Blue (Info):
├── Light: #E3F2FD
├── Medium: #64B5F6
└── Dark: #1565C0

Gray (Neutral):
├── Light: #F5F5F5
├── Medium: #9E9E9E
└── Dark: #424242
```

### Business Context Colors

| Metric Type | Positive (Good) | Neutral | Negative (Bad) |
|-------------|-----------------|---------|----------------|
| **Revenue** | Green | Yellow | Red |
| **Costs** | Red (low cost) | Yellow | Green (high cost) |
| **Time (Delivery)** | Green (fast) | Yellow | Red (slow) |
| **Quality** | Green (high) | Yellow | Red (low) |
| **Customer Sat** | Green | Yellow | Red |

**Note:** For costs, reverse the scale (low = good = green).

---

## Accessibility Guidelines

### Color Contrast Requirements

**WCAG 2.1 Standards:**
- **Normal text:** Minimum 4.5:1 contrast ratio
- **Large text (18pt+):** Minimum 3:1 contrast ratio
- **Bold text (14pt+):** Minimum 3:1 contrast ratio

**Accessible Combinations:**

✅ **Good Contrast:**
- Dark green (#2E7D32) on light green (#E8F5E9) = 5.2:1
- White (#FFFFFF) on blue (#1565C0) = 7.8:1
- Dark red (#C62828) on light red (#FFEBEE) = 6.1:1

❌ **Poor Contrast:**
- Yellow (#FFEB3B) on white (#FFFFFF) = 1.4:1 ❌
- Light gray (#E0E0E0) on white (#FFFFFF) = 1.2:1 ❌

### Colorblind-Friendly Design

**Issue:** 8% of males have red-green colorblindness.

**Solutions:**
1. **Use symbols + color:** ✓ ⚠ ● (not just color)
2. **Use patterns:** Stripes, dots, textures (in addition to color)
3. **Use blue-orange palette:** Alternative to red-green
   - Good: Blue (#1565C0)
   - Warning: Orange (#FB8C00)
   - Bad: Dark gray (#424242)

**Colorblind-Safe Palette:**
```
Positive: Blue (#2196F3)
Neutral: Gray (#9E9E9E)
Negative: Orange (#FF9800)
```

---

## Performance Optimization

### Rule Ordering

**IMPORTANT:** Rules evaluate in order. First match wins.

✅ **Correct Order (Specific to General):**
```
1. If value > 1000: Dark green
2. If value > 500: Medium green
3. If value > 100: Light green
4. Else: Default
```

❌ **Wrong Order (General First):**
```
1. If value > 100: Light green  ← This catches everything >100!
2. If value > 500: Medium green ← Never evaluated
3. If value > 1000: Dark green  ← Never evaluated
```

### Minimize Rules

**Problem:** 20+ rules slow down dashboard.

**Solution:** Consolidate using calculated fields.

**Before (4 rules):**
```
If price < 50: "Budget"
If price 50-150: "Mid-Range"
If price 150-500: "Premium"
If price > 500: "Luxury"
```

**After (1 rule + 1 calculated field):**
```
Calculated field: price_tier (creates categories)
Rule: Color by category (4 values, 1 rule)
```

---

## Testing Checklist

Before publishing conditional formatting:

```
☐ Colors have sufficient contrast (4.5:1 minimum)
☐ Information not conveyed by color alone (use symbols/text)
☐ Rules are ordered correctly (specific to general)
☐ Tested with actual data range (not just sample)
☐ Thresholds match business targets (not arbitrary)
☐ Formatting updates when filters change
☐ Mobile view: Colors visible on small screens
☐ Print view: Colors print correctly (or use patterns)
☐ Colorblind simulation: Still understandable
☐ Performance: Dashboard loads in <3 seconds
```

**Tool:** Use Chrome DevTools → Rendering → Emulate vision deficiencies to test colorblind view.

---

## Common Mistakes and Fixes

| Mistake | Problem | Solution |
|---------|---------|----------|
| **Too many colors** | Visual noise | Limit to 3-4 colors per chart |
| **Poor contrast** | Unreadable text | Use dark text on light background |
| **Red-green only** | Colorblind issues | Add symbols or use blue-orange |
| **No legend** | Users don't know meaning | Add text explaining color codes |
| **Arbitrary thresholds** | No business justification | Base on targets, SLAs, benchmarks |
| **Wrong rule order** | Rules don't trigger | Put most specific rules first |
| **Static thresholds** | Don't work year-round | Use percentiles or dynamic calculations |
| **Formatting on dimensions** | Can't format text categories | Format metrics, not dimensions |

---

## Advanced Techniques

### Technique 1: Dynamic Thresholds

**Use percentiles instead of fixed values:**

```
Instead of:
If: revenue > 1000000  (fixed threshold)

Use:
If: revenue > PERCENTILE(revenue, 0.75)  (top 25%)
```

**Benefit:** Automatically adjusts as data grows.

---

### Technique 2: Combined Conditions

**Format based on multiple fields:**

```
If: delivery_status = "Late" AND customer_state IN ("SP", "RJ")
Background: Red
(Highlights late deliveries in high-priority states)
```

---

### Technique 3: Conditional Text Formatting

**Change text, not just colors:**

```
If: on_time_rate >= 0.90
Prefix: "✓ Excellent - "
Font: Bold, Green

If: on_time_rate < 0.75
Prefix: "⚠ URGENT - "
Font: Bold, Red, Italic
```

---

## Quick Decision Guide

**"What formatting pattern should I use?"**

```
What are you showing?

┌─ Single KPI (scorecard)
│  └─ Use: Traffic Light (3-tier)
│
┌─ Table with one metric column
│  └─ Use: Data Bars or Color Scale
│
┌─ Table with multiple metrics
│  └─ Use: Single Color rules per column
│
┌─ Time series comparison
│  └─ Use: Comparison Scorecard
│
┌─ Geographic heat map
│  └─ Use: Color Scale (white to dark)
│
┌─ Alert/warning system
│  └─ Use: Threshold Alert (red when bad)
│
└─ Performance ranking
   └─ Use: Top/Bottom N highlighting
```

---

## Industry Benchmarks

### E-commerce Standards (Olist Dataset Context)

| Metric | Excellent | Good | Needs Work |
|--------|-----------|------|------------|
| **On-Time Delivery** | >90% | 75-90% | <75% |
| **Avg Delivery Time** | <7 days | 7-14 days | >14 days |
| **Order Value** | >R$200 | R$50-200 | <R$50 |
| **Return Rate** | <5% | 5-10% | >10% |
| **Customer Rating** | >4.5/5 | 4.0-4.5 | <4.0 |

Use these for threshold-based conditional formatting.

---

## Resources

**Color Tools:**
- Coolors.co - Color scheme generator
- Contrast Checker (webaim.org) - WCAG compliance
- Adobe Color - Accessible palette builder

**Looker Studio References:**
- Official docs: Conditional Formatting Guide
- Material Design color system
- WCAG 2.1 Guidelines

---

## Version History

- **Week 14 (Jan 2026):** Initial guide for Cohort 5
- **Dataset:** Olist Brazilian E-commerce (2016-2018)

---

## See Also

- Controls Configuration Guide
- Week 13: Calculated Fields Reference
- Week 15: Dashboard Design Best Practices
