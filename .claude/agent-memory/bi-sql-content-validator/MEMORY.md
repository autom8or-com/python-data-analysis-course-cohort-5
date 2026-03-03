# BI SQL Content Validator - Agent Memory

## Database Schema Overview

### Olist Sales Data Set (`olist_sales_data_set`)
- **olist_orders_dataset**: Core orders table with timestamps, status, delivery dates
  - Key columns: `order_id`, `customer_id`, `order_status`, `order_purchase_timestamp`, `order_delivered_customer_date`
  - Date range: 2016-09-04 to 2018-10-17 (99,441 records)
  - NULL issues: 2,965 records have null delivery dates (orders not yet delivered)

- **olist_order_items_dataset**: Line items with pricing
  - Key columns: `order_id`, `product_id`, `seller_id`, `price`, `freight_value`
  - No NULL issues in critical fields (112,650 records)

- **olist_order_payments_dataset**: Payment transactions
  - Key columns: `order_id`, `payment_value`, `payment_type`, `payment_installments`
  - Clean data (103,886 records)

- **olist_customers_dataset**: Customer information
  - Key columns: `customer_id`, `customer_unique_id`, `customer_city`, `customer_state`

### Olist Marketing Data Set (`olist_marketing_data_set`)
- **olist_marketing_qualified_leads_dataset**: Marketing leads
  - Key columns: `mql_id`, `first_contact_date`, `origin` (channel), `landing_page_id`
  - Date range: 2017-06-14 to 2018-05-31 (8,000 records)

- **olist_closed_deals_dataset**: Converted leads
  - Key columns: `mql_id`, `seller_id`, `won_date`, `business_segment`, `lead_type`, `business_type`
  - Date range: 2017-12-11 to 2018-08-07 (380 records)
  - Conversion rate: 4.75% (380/8000)
  - NOTE: `declared_monthly_revenue` field is mostly 0 - not reliable for revenue calculations

## Common Join Patterns

### Revenue Calculations
```sql
-- Always join orders → payments for revenue
FROM olist_orders_dataset o
JOIN olist_order_payments_dataset p ON o.order_id = p.order_id
WHERE o.order_status = 'delivered'  -- Critical filter!
```

### Customer Metrics (CLV, RFM)
```sql
-- Use customer_unique_id for true customer aggregation
FROM olist_customers_dataset c
JOIN olist_orders_dataset o ON c.customer_id = o.customer_id
JOIN olist_order_payments_dataset p ON o.order_id = p.order_id
GROUP BY c.customer_unique_id  -- Not customer_id!
```

### Marketing Funnel
```sql
-- Left join to preserve all leads
FROM olist_marketing_qualified_leads_dataset mql
LEFT JOIN olist_closed_deals_dataset cd ON mql.mql_id = cd.mql_id
```

## Validated Metrics & Results

### Revenue Metrics
- **Monthly Revenue Range**: ~$645K - $1.15M (2017-2018)
- **MoM Growth**: Ranges from -26.9% to +53.57%
- **Average Order Value**: ~$147-$169 per order
- **YTD Cumulative Revenue (2018)**: ~$8.45M by August 29

### Delivery Performance
- Delivery days calculated as: `EXTRACT(DAY FROM (order_delivered_customer_date - order_purchase_timestamp))`
- Categories: Express (≤3 days), Standard (≤7), Delayed (≤14), Critical Delay (>14)
- Most orders fall into "Delayed" category

### Customer Metrics
- **CLV Tiers**: VIP Champion (≥$5K), Loyal (≥$2K), Growing (≥$500), New (<$500)
- Top customers: Single orders of $13K+ (likely B2B bulk purchases)
- **RFM Scores**: Calculated using NTILE(5) for each dimension
- Reference date for recency: Use latest date in dataset (2018-09-01)

### Marketing Metrics
- **Overall Conversion**: 4.75% (380 closed deals from 8,000 MQLs)
- **Best Channels**: Unknown (7.37%), Paid Search (6.37%), Direct Traffic (6.21%)
- **Worst Channels**: Email (1.22%), Display (1.69%), Other Publicities (0%)
- **Top Business Segments**: Health & Beauty (45 deals), Household Utilities (44), Home Decor (44)

## Data Quality Notes

1. **Missing Delivery Dates**: 2,965 orders (~3%) have NULL `order_delivered_customer_date` - exclude these for delivery metrics
2. **Campaign Cost Data**: NOT available in database - must simulate for CAC calculations
3. **Declared Monthly Revenue**: Field exists in closed_deals but all values are 0 - cannot be used
4. **Marketing-Sales Link**: No direct link between marketing leads and actual orders - separate datasets
5. **Date Alignment**: Marketing data (2017-06 to 2018-05) doesn't fully overlap with sales data (2016-09 to 2018-10)

## Calculated Field Patterns for Looker Studio

### Period-over-Period Growth
```sql
CASE
  WHEN previous_period_value > 0 THEN
    (current_period_value - previous_period_value) / previous_period_value * 100
  ELSE NULL
END
```

### CLV Tier Classification
Use actual thresholds: $5000, $2000, $500 (not $500K as in README example)

### RFM Score Concatenation
```sql
CONCAT(recency_score::text, frequency_score::text, monetary_score::text)
```

### Delivery Category
Based on `EXTRACT(DAY FROM (order_delivered_customer_date - order_purchase_timestamp))`

## Key Teaching Points

1. **Always filter by order_status = 'delivered'** for revenue calculations
2. **Use customer_unique_id** not customer_id for true customer-level aggregations
3. **Handle NULLs** in delivery dates when calculating delivery performance
4. **Marketing data limitations**: Cannot directly link MQLs to actual order revenue
5. **Realistic thresholds**: Adjust CLV tiers based on actual data distribution ($5K not $500K)

## SQL Syntax Gotchas (PostgreSQL / Supabase)

- `ROUND()` on a `double precision` (real) value will error. Always cast first: `ROUND(value::numeric, 2)`
- Division of two `double precision` values produces `double precision` — cast the whole expression: `(a / b)::numeric`
- `DATE_PART('day', timestamp - timestamp)` returns double precision — cast when passing to ROUND
- `EXTRACT(...)` returns double precision — cast to int if using as integer: `::int`
- LAG/LEAD/NTILE are not supported in Looker Studio calculated fields — pre-calculate in SQL

## Row Multiplication Warning (Critical)

Joining `olist_order_items_dataset` (many rows per order) to `olist_order_payments_dataset` and then doing SUM(payment_value) inflates revenue. Validated impact: SP state revenue shows $7.4M (wrong) vs $5.77M (correct) — a 28% inflation.

**Fix**: Always pre-aggregate payments per order in a CTE before joining with order items:
```sql
WITH order_revenue AS (
    SELECT order_id, SUM(payment_value) AS order_revenue
    FROM olist_order_payments_dataset GROUP BY order_id
)
-- Then join order_revenue to your other tables
```

## Delivery Performance: Estimated vs Actual

Two distinct delivery metrics exist:
1. **Actual delivery time** = `DATE_PART('day', order_delivered_customer_date - order_purchase_timestamp)` — avg ~12-22 days per seller
2. **Lateness vs estimate** = `DATE_PART('day', order_delivered_customer_date - order_estimated_delivery_date)` — 92% are "On Time" because Olist sets conservative estimates (avg 12.7 days early)

The "On Time vs Estimated" metric tells a very different story from "days from purchase to delivery". Both are valid but measure different things.

## Revenue Cross-Check Finding

`SUM(payment_value)` is ~22.73% higher than `SUM(price + freight_value)` for delivered orders. This is expected:
- payment_value includes gift cards, vouchers, and installment fees
- Always use payment_value as the authoritative revenue source

## Dataset Temporal Boundaries

- Sales: Only 8 orders in final 30 days (Sep–Oct 2018) — effective active range Sep 2016–Aug 2018
- Marketing: Ends May 2018, 5-month gap before sales data ends
- 2016 is startup period (266 orders total) — exclude from trend analysis
- Dec 2016: Only 1 order ($19.62) — causes extreme MoM artifacts in any time series
