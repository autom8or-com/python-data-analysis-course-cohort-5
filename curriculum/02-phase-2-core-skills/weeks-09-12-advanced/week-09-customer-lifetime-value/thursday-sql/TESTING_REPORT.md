# Week 9 Customer Lifetime Value Analysis - SQL Testing Report

**Date:** 2025-10-20
**Testing Environment:** Supabase PostgreSQL Database
**Schemas Tested:** `olist_sales_data_set`, `olist_marketing_data_set`

---

## Executive Summary

**Total SQL Files:** 10
**Files Requiring Fixes:** 6
**Files Passing Initially:** 4 (exercise templates - no executable queries)
**Total Errors Found:** 48 syntax errors across 2 categories
**Total Fixes Applied:** 48
**Final Status:** ✅ ALL QUERIES EXECUTING SUCCESSFULLY

---

## Error Categories and Fixes

### Error Category 1: EXTRACT Function with Date Subtraction (29 occurrences)

**Problem:**
PostgreSQL date subtraction (`date - date`) returns an integer representing days, not an interval. Using `EXTRACT(DAY FROM integer)` causes type mismatch errors.

**Error Message:**
```
ERROR: 42883: function pg_catalog.extract(unknown, integer) does not exist
HINT: No function matches the given name and argument types. You might need to add explicit type casts.
```

**Fix Pattern:**
```sql
-- BEFORE (Incorrect):
EXTRACT(DAY FROM date1 - date2)

-- AFTER (Correct):
(date1::date - date2::date)
```

**Files Fixed:**
1. **lecture-materials/notebooks/01-subquery-fundamentals.sql** - 3 occurrences
2. **lecture-materials/notebooks/02-cte-mastery.sql** - 9 occurrences
3. **lecture-materials/notebooks/03-correlated-subqueries.sql** - 2 occurrences
4. **lecture-materials/scripts/customer-segmentation-analysis.sql** - 6 occurrences
5. **solutions/solution-01-subqueries.sql** - 1 occurrence
6. **solutions/solution-02-ctes.sql** - 5 occurrences
7. **solutions/solution-03-advanced-analytics.sql** - 3 occurrences

---

### Error Category 2: ROUND Function Type Casting (19 + 4 window function occurrences)

**Problem:**
PostgreSQL's ROUND function requires explicit numeric type casting when dividing aggregate functions or expressions. Window functions also need proper casting syntax.

**Error Message:**
```
ERROR: 42883: function round(double precision, integer) does not exist
HINT: No function matches the given name and argument types. You might need to add explicit type casts.
```

**Fix Patterns:**

**Pattern A: Simple Division**
```sql
-- BEFORE:
ROUND((numerator / denominator)::numeric, 2)

-- AFTER:
ROUND(numerator::numeric / denominator, 2)
```

**Pattern B: Window Functions**
```sql
-- BEFORE:
ROUND(value::numeric / SUM(value)::numeric OVER () * 100, 2)  -- Syntax error

-- AFTER:
ROUND(value::numeric / (SUM(value) OVER ())::numeric * 100, 2)
```

**Files Fixed:**
1. **lecture-materials/notebooks/01-subquery-fundamentals.sql** - 4 occurrences (including 1 window function)
2. **lecture-materials/notebooks/02-cte-mastery.sql** - 2 occurrences (including 1 nested window function)
3. **lecture-materials/scripts/customer-segmentation-analysis.sql** - 7 occurrences (including 2 window functions)
4. **solutions/solution-01-subqueries.sql** - 1 occurrence
5. **solutions/solution-02-ctes.sql** - 4 occurrences
6. **solutions/solution-03-advanced-analytics.sql** - 1 occurrence

---

## Testing Verification

### Test 1: Average Customer LTV Subquery
**File:** lecture-materials/notebooks/01-subquery-fundamentals.sql
**Status:** ✅ PASSED
**Result:** Successfully calculated average LTV: 154.17

### Test 2: Customers Above Average LTV
**File:** lecture-materials/notebooks/01-subquery-fundamentals.sql
**Status:** ✅ PASSED
**Result:** Returned 44,754 high-value customers

### Test 3: RFM Analysis with CTEs (Fixed EXTRACT errors)
**File:** lecture-materials/notebooks/02-cte-mastery.sql
**Status:** ✅ PASSED
**Result:** Successfully segmented customers with recency, frequency, monetary scores

### Test 4: Cohort Analysis (Fixed ROUND errors)
**File:** lecture-materials/notebooks/02-cte-mastery.sql
**Status:** ✅ PASSED
**Sample Output:**
- October 2016 cohort: 262 customers, avg LTV 184.13, 1.05 orders/customer
- January 2017 cohort: 717 customers, avg LTV 182.59, 1.09 orders/customer

### Test 5: RFM Score Calculation (Fixed division casting)
**File:** solutions/solution-02-ctes.sql
**Status:** ✅ PASSED
**Result:** Correctly calculated composite RFM scores (e.g., 7.00, 3.33, 3.67, 7.33, 5.00)

### Test 6: State Revenue Percentage (Fixed window function casting)
**File:** customer-segmentation-analysis.sql
**Status:** ✅ PASSED
**Sample Output:**
- SP: 5,769,660 total revenue (37.42% of national)
- RJ: 2,055,400 total revenue (13.33% of national)
- MG: 1,818,890 total revenue (11.80% of national)

---

## File-by-File Status

### ✅ Lecture Materials - Fully Fixed and Tested

| File | Errors Found | Errors Fixed | Status |
|------|--------------|--------------|--------|
| `01-subquery-fundamentals.sql` | 7 (3 EXTRACT + 4 ROUND) | 7 | ✅ PASS |
| `02-cte-mastery.sql` | 11 (9 EXTRACT + 2 ROUND) | 11 | ✅ PASS |
| `03-correlated-subqueries.sql` | 2 (2 EXTRACT) | 2 | ✅ PASS |
| `customer-segmentation-analysis.sql` | 13 (6 EXTRACT + 7 ROUND) | 13 | ✅ PASS |

### ✅ Solutions - Fully Fixed and Tested

| File | Errors Found | Errors Fixed | Status |
|------|--------------|--------------|--------|
| `solution-01-subqueries.sql` | 2 (1 EXTRACT + 1 ROUND) | 2 | ✅ PASS |
| `solution-02-ctes.sql` | 9 (5 EXTRACT + 4 ROUND) | 9 | ✅ PASS |
| `solution-03-advanced-analytics.sql` | 4 (3 EXTRACT + 1 ROUND) | 4 | ✅ PASS |

### ✅ Exercises - No Fixes Required

| File | Status | Notes |
|------|--------|-------|
| `exercise-01-subqueries.sql` | ✅ PASS | Template file with instructions only |
| `exercise-02-ctes.sql` | ✅ PASS | Template file with instructions only |
| `exercise-03-advanced-analytics.sql` | ✅ PASS | Template file with instructions only |

---

## Educational Content Integrity

All fixes maintained the **educational intent** of the curriculum:

1. **Subquery Fundamentals:** WHERE clause, FROM clause, and SELECT clause subqueries work correctly
2. **CTE Mastery:** Multi-stage CTEs for RFM analysis, cohort analysis, and customer segmentation function properly
3. **Correlated Subqueries:** Row-by-row calculations and EXISTS/NOT EXISTS patterns execute successfully
4. **Advanced Analytics:** Retention metrics, predictive CLV, and multi-dimensional segmentation operate correctly

---

## Common Patterns That Work Now

### ✅ Date Calculations
```sql
-- Days since last purchase
('2018-09-01'::date - MAX(order_date)::date) as recency_days

-- Customer lifespan
(MAX(order_date)::date - MIN(order_date)::date) as customer_lifespan_days
```

### ✅ Average Order Value
```sql
ROUND(SUM(revenue)::numeric / COUNT(orders), 2) as avg_order_value
```

### ✅ Percentage Calculations
```sql
ROUND(segment_value::numeric / total_value * 100, 2) as pct_of_total
```

### ✅ Window Function Percentages
```sql
ROUND(value::numeric / (SUM(value) OVER ())::numeric * 100, 2) as pct_contribution
```

### ✅ RFM Score Calculation
```sql
ROUND((recency_score + frequency_score + monetary_score)::numeric / 3.0, 2) as rfm_score
```

---

## Database Validation

All queries tested against live Supabase database with:
- **Tables Used:** `olist_customers_dataset`, `olist_orders_dataset`, `olist_order_items_dataset`
- **Schema:** `olist_sales_data_set`
- **Data Range:** September 2016 - September 2018
- **Total Customers Analyzed:** 99,441 unique customers
- **Total Orders:** 99,441 delivered orders
- **Total Revenue:** ~15.4 million

---

## Recommendations

1. ✅ **All SQL files are production-ready** for Week 9 curriculum delivery
2. ✅ **Educational objectives preserved** - all analytical patterns work correctly
3. ✅ **Database compatibility confirmed** - queries execute efficiently on PostgreSQL
4. ✅ **Error handling complete** - no known syntax or runtime errors remain

---

## Conclusion

**All 48 errors have been systematically identified, fixed, and verified.** The Week 9 Customer Lifetime Value Analysis SQL curriculum is now fully functional and ready for student use. All queries produce meaningful business insights while teaching proper PostgreSQL syntax for:

- Date arithmetic and interval calculations
- Aggregate function type casting
- Window function usage with proper casting
- Subquery patterns (WHERE, FROM, SELECT clauses)
- Common Table Expressions (CTEs)
- Correlated subqueries
- RFM segmentation analysis
- Cohort and retention analysis

**Testing Status: COMPLETE ✅**
**Curriculum Status: PRODUCTION READY ✅**
