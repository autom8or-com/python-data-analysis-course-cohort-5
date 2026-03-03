# Data Quality Checklist

## Week 16 - Wednesday Session Resource

**Last Updated:** March 2026 | Cohort 5

---

## Overview

This checklist documents all data quality findings from the validated Week 16 SQL audit of the Olist e-commerce dataset. Use it as a reference when implementing data quality indicators in your dashboard and when completing Exercise 2 (Data Quality Validation). All findings are confirmed against live Supabase data.

---

## Table of Contents

1. [Executive Data Quality Summary](#executive-data-quality-summary)
2. [NULL Audit Results](#null-audit-results)
3. [Temporal Boundary Audit](#temporal-boundary-audit)
4. [Outlier Detection Results](#outlier-detection-results)
5. [Revenue Cross-Validation](#revenue-cross-validation)
6. [In-Dashboard Quality Indicators](#in-dashboard-quality-indicators)
7. [Known Dataset Limitations](#known-dataset-limitations)
8. [Data Quality Status Panel Template](#data-quality-status-panel-template)
9. [Production Certification Checklist](#production-certification-checklist)

---

## Executive Data Quality Summary

| Metric | Status | Detail |
|--------|--------|--------|
| Revenue NULL rate | PASS | 0% NULL in payment_value |
| Order status NULL rate | PASS | 0% NULL in order_status |
| Delivery date NULL rate | WARN | 2.98% NULL (2,965 orders) — expected for undelivered |
| Temporal errors | PASS | 0 orders with purchase after delivery |
| Revenue outliers | INFO | 11 orders > $3,000 — legitimate, not removed |
| Revenue cross-validation | INFO | 22.73% gap between payment_value and price+freight — expected |
| Marketing cost data | MISSING | Does not exist — simulated for all CAC metrics |
| declared_monthly_revenue | INVALID | All zeros in closed_deals — do not use |

**Overall Data Quality Rating:** PRODUCTION-READY with documented limitations

---

## NULL Audit Results

### Query 3a Validated Results

Run the NULL audit to confirm these findings in your own environment:

```sql
SELECT
    COUNT(*) AS total_orders,
    COUNT(CASE WHEN o.order_status IS NULL THEN 1 END) AS null_order_status,
    COUNT(CASE WHEN o.order_delivered_customer_date IS NULL THEN 1 END) AS null_delivery_date,
    COUNT(CASE WHEN p.payment_value IS NULL THEN 1 END) AS null_payment_value,
    ROUND(
        COUNT(CASE WHEN o.order_delivered_customer_date IS NULL THEN 1 END)::numeric
        / COUNT(*) * 100, 2
    ) AS null_delivery_pct
FROM olist_sales_data_set.olist_orders_dataset o
LEFT JOIN olist_sales_data_set.olist_order_payments_dataset p
    ON o.order_id = p.order_id;
```

### Validated Results

| Field | NULL Count | NULL Rate | Status |
|-------|------------|-----------|--------|
| order_status | 0 | 0.00% | PASS — all orders have a status |
| payment_value | 0 | 0.00% | PASS — revenue field is complete |
| order_delivered_customer_date | 2,965 | 2.98% | WARN — see explanation below |

### Why 2,965 Delivery Dates Are NULL

These are not data errors. They are orders that were never delivered:
- `cancelled` status orders (no delivery date is expected)
- `returned` status orders
- Orders still `in_transit` at the end of the dataset period

**Dashboard rule:** Always filter delivery metric calculations to `WHERE order_delivered_customer_date IS NOT NULL` or equivalently `WHERE order_status = 'delivered'`. Do not attempt to calculate delivery days for undelivered orders.

### Impact on Dashboard

| Metric | Impact of NULL Delivery Dates |
|--------|-------------------------------|
| Revenue (SUM payment_value) | None — filter to delivered orders separately |
| Delivery performance chart | Exclude these 2,965 orders (2.98% exclusion — document this) |
| Days-to-deliver scorecard | Would error without NULL filter |
| Customer count | Minimal — these customers exist, just their delivery is absent |

---

## Temporal Boundary Audit

### Query 3b Validated Results

```sql
SELECT
    COUNT(*) AS orders_with_temporal_errors,
    MIN(o.order_purchase_timestamp) AS earliest_order,
    MAX(o.order_purchase_timestamp) AS latest_order,
    MIN(o.order_delivered_customer_date) AS earliest_delivery,
    MAX(o.order_delivered_customer_date) AS latest_delivery,
    COUNT(CASE WHEN o.order_delivered_customer_date < o.order_purchase_timestamp
               THEN 1 END) AS delivery_before_purchase
FROM olist_sales_data_set.olist_orders_dataset o
WHERE o.order_delivered_customer_date IS NOT NULL;
```

### Validated Results

| Check | Result | Status |
|-------|--------|--------|
| Temporal errors (delivery before purchase) | 0 | PASS |
| Earliest order | Sep 4, 2016 | INFO |
| Latest order | Oct 17, 2018 | INFO |
| Earliest delivery | Sep 19, 2016 | INFO |
| Latest delivery | Oct 17, 2018 | INFO |

### Date Range Implications for Dashboard

| Period | Recommendation |
|--------|---------------|
| Sep–Dec 2016 | Exclude from trend analysis — sparse startup period (few dozen orders) |
| Jan 2017 – Jul 2018 | Primary analysis window — reliable data |
| Aug 2018 | Usable but MoM growth -4.13% (declining, not representative) |
| Sep–Oct 2018 | Effectively empty — 8 orders only; exclude from charts |

**Dashboard default date range:** Set to Jan 1, 2017 – Aug 31, 2018 to show the most reliable 20 months of data.

---

## Outlier Detection Results

### Query 3c Validated Results

```sql
WITH revenue_stats AS (
    SELECT
        AVG(payment_value) AS mean_payment,
        STDDEV(payment_value) AS stddev_payment,
        PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY payment_value) AS p25,
        PERCENTILE_CONT(0.50) WITHIN GROUP (ORDER BY payment_value) AS p50,
        PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY payment_value) AS p75,
        PERCENTILE_CONT(0.95) WITHIN GROUP (ORDER BY payment_value) AS p95,
        PERCENTILE_CONT(0.99) WITHIN GROUP (ORDER BY payment_value) AS p99
    FROM olist_sales_data_set.olist_order_payments_dataset
    WHERE payment_value > 0
)
SELECT
    *,
    p75 - p25 AS iqr,
    (p75 - p25) * 1.5 AS whisker_length,
    p75 + (p75 - p25) * 1.5 AS upper_fence
FROM revenue_stats;
```

### Validated Statistical Profile

| Statistic | Value |
|-----------|-------|
| Mean payment | $166.79 |
| Median (P50) | $105.00 |
| P25 (lower quartile) | $44.00 |
| P75 (upper quartile) | $208.00 |
| P95 | $501.50 |
| P99 | $1,098.00 |
| IQR (P75 - P25) | $164.00 |
| Upper fence (P75 + 1.5 × IQR) | $454.00 |
| Orders above $3,000 | 11 |

### Outlier Assessment

**Are outliers problematic?** No — these are legitimate high-value transactions.

The Olist marketplace includes premium electronics, furniture, and appliances. An order of $3,000+ could be:
- A high-end laptop or TV
- A complete bedroom furniture set
- Industrial equipment sold through the marketplace

**Decision:** Retain all outliers. Do not remove. The 11 orders above $3,000 represent real customer behavior.

**Dashboard note:** The mean ($166.79) is significantly higher than the median ($105.00) because of these high-value orders. If your executive scorecard shows AOV, explain the median vs mean distinction in your documentation.

### Right-Skew Distribution

The dataset has a right-skewed payment distribution:
- Most orders are in the $44–$208 range (IQR)
- A small number of high-value orders pull the mean up
- This is normal for a general marketplace

---

## Revenue Cross-Validation

### Query 3d Validated Results

```sql
SELECT
    SUM(p.payment_value) AS total_payment_value,
    SUM(oi.price + oi.freight_value) AS total_price_freight,
    ROUND(
        (SUM(p.payment_value) - SUM(oi.price + oi.freight_value))
        / NULLIF(SUM(oi.price + oi.freight_value), 0) * 100,
        2
    ) AS pct_difference
FROM olist_sales_data_set.olist_orders_dataset o
JOIN olist_sales_data_set.olist_order_payments_dataset p
    ON o.order_id = p.order_id
JOIN olist_sales_data_set.olist_order_items_dataset oi
    ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered';
```

### Validated Results

| Revenue Source | Total Value | Notes |
|----------------|-------------|-------|
| SUM(payment_value) | $19,835,936 | Authoritative — actual money received |
| SUM(price + freight_value) | $16,162,447 | Listed price only — excludes adjustments |
| Difference | $3,673,489 | — |
| Gap percentage | 22.73% | Expected — not a data error |

### Why the 22.73% Gap Is Expected

The gap between what customers paid (`payment_value`) and what was listed (`price + freight_value`) comes from:

| Factor | Explanation |
|--------|-------------|
| Installment fees | Olist allows 1-24 installment payments; interest/fees increase total |
| Vouchers | Customers can pay part with a discount voucher (adds to payment_value) |
| Multiple payment methods | Split payments (card + voucher) can sum higher than base price |
| Rounding | Payment processor rounding across installments |

**Critical rule:** Always use `SUM(payment_value)` as the authoritative revenue figure. Never add `price + freight_value` for revenue metrics. The $19.8M figure is correct; the $16.2M figure represents catalog prices only.

---

## In-Dashboard Quality Indicators

### Method 1: Footer Text Box (Minimum Requirement)

Add to the bottom of each dashboard page:

```
Data Quality Notes:
- Revenue: SUM(payment_value) — authoritative figure (0% NULL)
- Delivery metrics exclude 2,965 undelivered orders (2.98% of orders)
- Marketing cost/CAC data is SIMULATED — not real Olist figures
- Active analysis period: Jan 2017 – Aug 2018
- Dataset: Olist Brazilian E-Commerce (historical — data does not update)
```

Style: 10px font, color #757575 (gray), positioned in bottom margin of canvas.

### Method 2: Data Quality Scorecard (Recommended for Final Project)

Create a dedicated scorecard row using scorecards with custom labels:

| Scorecard | Value | Format |
|-----------|-------|--------|
| Revenue NULL Rate | 0.00% | Green (#137333) |
| Orders in Analysis | 96,478 | Blue (#1a73e8) |
| Delivery Date Missing | 2.98% | Yellow (#f9ab00) |
| Temporal Errors | 0 | Green (#137333) |

Use a calculated field in Looker Studio:

```
-- Status label calculated field
CASE
  WHEN null_rate = 0 THEN "PASS"
  WHEN null_rate < 0.05 THEN "WARN"
  ELSE "FAIL"
END
```

### Method 3: Documentation Page

Add a final page to your dashboard titled "Documentation & Data Quality." Include:
- The data quality summary table (from Executive Data Quality Summary above)
- Revenue cross-validation note
- Known limitations (see section below)
- Your name and contact as dashboard owner

---

## Known Dataset Limitations

Document these in your dashboard's Documentation page and in your submission email.

### Limitation 1: Marketing Data Ends May 2018

The `olist_marketing_data_set` covers Jun 2017 – May 2018 only. Sales data runs through Oct 2018. This 5-month gap means:
- Marketing page shows only ~12 months of data
- You cannot calculate marketing ROI against Aug 2018 revenue
- Any combined marketing + sales analysis must acknowledge this boundary

### Limitation 2: Sparse 2016 Data

The dataset begins Sep 2016, but order volume was very low (Olist was a startup). Including 2016 in trend charts distorts growth rates. Set your default date range to Jan 2017 or later.

### Limitation 3: Oct 2018 Tail-Off

After August 2018, order volume drops to 8 total orders. This is likely because the dataset was extracted mid-cycle, not because Olist lost customers. Exclude Oct 2018 from trend analysis.

### Limitation 4: No Real Marketing Cost Data

The Olist dataset contains no advertising spend, campaign budget, or cost-per-lead data. Any CAC (Customer Acquisition Cost) or marketing ROI metric in your dashboard uses simulated industry estimates. Every chart displaying these must include "SIMULATED" in the title or as a visible disclaimer.

### Limitation 5: declared_monthly_revenue Is Empty

The `closed_deals` table has a `declared_monthly_revenue` column that is all zeros. This field was presumably intended for sellers to self-report revenue but was never populated. Do not use this column for any metric.

### Limitation 6: No Direct Marketing-to-Sales Link

There is no foreign key or join possible between `marketing_qualified_leads`/`closed_deals` and the orders/payments tables. The datasets come from different systems. You cannot determine which MQL lead became which paying customer.

---

## Data Quality Status Panel Template

Copy and paste this into a Looker Studio text box on your Documentation page:

```
=== DATA QUALITY STATUS — OLIST EXECUTIVE DASHBOARD ===

Last Validated: [Your date]
Validated By: [Your name]

FIELD-LEVEL STATUS
  payment_value          [PASS]  0.00% NULL — authoritative revenue source
  order_status           [PASS]  0.00% NULL — all orders categorized
  order_delivered_date   [WARN]  2.98% NULL — 2,965 undelivered orders excluded
  temporal consistency   [PASS]  0 records with delivery before purchase
  revenue outliers       [INFO]  11 orders > $3,000 — retained (legitimate)

REVENUE RECONCILIATION
  payment_value total:   $19,835,936
  price + freight total: $16,162,447
  Gap: 22.73% — EXPECTED (installment fees, vouchers, multi-payment methods)
  → Always use payment_value as the authoritative revenue figure

SIMULATION DISCLOSURES
  Marketing CAC (Customer Acquisition Cost): SIMULATED
  Marketing ROI: SIMULATED
  Campaign spend by channel: SIMULATED
  → Real cost data does not exist in the Olist database

EXCLUSIONS APPLIED
  - 2,965 orders excluded from delivery metrics (undelivered/cancelled/returned)
  - Pre-2017 data excluded from trend analysis (sparse startup period)
  - Post-Aug 2018 data excluded from trend analysis (8 orders only)

DATA SOURCE
  Olist Brazilian E-Commerce Public Dataset
  Period: Sep 2016 – Oct 2018 (historical — does not update)
  Connection: Supabase PostgreSQL (owner credentials)
  Refresh: Weekly (Sunday 6:00 AM WAT)
```

---

## Production Certification Checklist

Complete this checklist before declaring your dashboard production-ready. Check each item; do not skip.

```
REVENUE ACCURACY
☐ SUM(payment_value) used — NOT SUM(price + freight_value)
☐ WHERE order_status = 'delivered' filter applied to all revenue queries
☐ SP total revenue verified at approximately $5,770,360 (not $7,404,140)
☐ Revenue cross-validation discrepancy (22.73%) documented

NULL HANDLING
☐ Delivery date NULLs: 2,965 orders confirmed; delivery metrics exclude them
☐ Zero NULLs in payment_value confirmed (query 3a run and results recorded)
☐ Zero NULLs in order_status confirmed
☐ NULL handling noted in data quality footer on each page

TEMPORAL QUALITY
☐ Zero temporal errors confirmed (query 3b run)
☐ Default date range set to Jan 1, 2017 – Aug 31, 2018
☐ 2016 startup data excluded from trend analysis
☐ Oct 2018 tail-off addressed (excluded or annotated)

OUTLIER HANDLING
☐ 11 high-value orders (>$3,000) reviewed and retained
☐ Right-skewed distribution acknowledged (mean $167 vs median $105)
☐ No outliers removed without business justification

SIMULATION DISCLOSURES
☐ Marketing CAC labeled "SIMULATED" on every relevant chart
☐ Marketing ROI labeled "SIMULATED" on every relevant chart
☐ Simulation disclaimer present in documentation page
☐ declared_monthly_revenue NOT used anywhere in dashboard

DOCUMENTATION COMPLETENESS
☐ Data quality footer on every page (8 words minimum)
☐ Documentation page or separate Google Doc completed
☐ Known limitations documented (all 6 limitations above)
☐ Revenue note: payment_value is authoritative, gap of 22.73% expected
☐ Owner name and contact visible in documentation

PERFORMANCE
☐ Custom SQL data sources (not raw tables)
☐ Extract configured on all data sources
☐ Dashboard loads in under 5 seconds
☐ Owner's credentials set on all data sources

SHARING
☐ Instructor access configured (Viewer)
☐ Portfolio link sharing enabled ("Anyone with the link can view")
☐ Incognito test passed (dashboard loads without sign-in)
☐ Scheduled email delivery configured and test sent
```

---

**Checklist Version:** Week 16 Production Dashboards | March 2026
**Dataset:** Olist Brazilian E-Commerce (Sep 2016 – Oct 2018)
**Validation Queries:** From validation-report.md Sections 3a–3d
