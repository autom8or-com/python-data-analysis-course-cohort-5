# Week 02 - SQL Arithmetic Operations & Conditional Logic - Thursday SQL Session

## Session Overview
**Date**: August 21, 2025  
**Duration**: 2 hours  
**Platform**: SQL/VS Code with PostgreSQL  
**Business Scenario**: Same NaijaCommerce pricing calculations and automated business logic from Wednesday - now using SQL arithmetic operations and CASE WHEN statements
**Building On**: Week 1 SQL foundations (basic SELECT, table exploration) + Wednesday's Python operators and control structures

## Learning Objectives
By the end of this session, students will be able to:
- [ ] Apply arithmetic operators (+, -, *, /, %) in SQL SELECT statements for business calculations
- [ ] Use CASE WHEN statements to implement conditional logic (SQL equivalent of if/elif/else)
- [ ] Combine arithmetic operations with business rules using CASE statements
- [ ] Create the same automated pricing and tier systems as Wednesday's Python session
- [ ] Use aggregate functions with conditional logic for business reporting
- [ ] Apply WHERE clauses in combination with arithmetic operations
- [ ] Connect SQL conditional operations to Wednesday's Python control structures

## Session Structure

### Opening: From Python Operators to SQL Calculations (10 minutes)
**"Remember yesterday's arithmetic and if/elif/else? Let's do that in SQL!"**
- Quick review: Wednesday's success with Python operators and control structures
- Direct translation: Python calculations → SQL arithmetic in SELECT statements
- Preview: By end of class, you'll create the same automated business logic using SQL
- Today's journey: Same business calculations and decisions, SQL syntax

**Python-SQL Connections:**
- Python arithmetic (+, -, *, /) = SQL arithmetic operators in SELECT
- Python if/elif/else = SQL CASE WHEN statements
- Python boolean conditions = SQL WHERE clause conditions
- Python nested conditionals = SQL nested CASE statements

### Topic 1: SQL Arithmetic Operations for Business (35 minutes)

**Subtopics:**
- Arithmetic operators in SELECT statements: +, -, *, /, % for calculations
- Order of operations (PEMDAS) in SQL expressions
- Creating calculated columns for business metrics
- Working with numeric data types and precision in SQL

**Activities:**
- Calculate order totals with tax: SELECT order_value * 1.075 AS total_with_tax
- Compute sales commissions: SELECT sales_amount * commission_rate AS commission
- Apply bulk discounts: SELECT price * (1 - discount_percentage/100) AS discounted_price
- Calculate profit margins: SELECT (selling_price - cost_price) / cost_price AS margin

**Python-SQL Direct Translations:**
```python
# Wednesday Python:
total_with_tax = base_price * 1.075
commission = sales_amount * commission_rate
```
```sql
-- Thursday SQL:
SELECT base_price * 1.075 AS total_with_tax FROM orders;
SELECT sales_amount * commission_rate AS commission FROM sales;
```

**Excel Connections:**
- SQL arithmetic = Excel formula calculations (=A1*B1)
- SELECT calculations = Excel calculated columns
- SQL expressions = Excel's complex formula structures

**Resources:**
- `scripts/01_sql_arithmetic_operations.sql`
- `datasets/naijacommerce_pricing_sql.csv` (same data as Wednesday's Python session)

### Topic 2: CASE WHEN Conditional Logic (35 minutes)

**Subtopics:**
- CASE WHEN syntax for conditional logic (SQL's if/elif/else)
- Simple CASE for direct value matching
- Searched CASE for complex conditional expressions
- Nested CASE statements for multi-level business rules

**Activities:**
- Create customer tier assignments: CASE WHEN total_spent > 500000 THEN 'VIP'
- Implement dynamic pricing: CASE WHEN order_volume > 100 THEN base_price * 0.9
- Build shipping cost calculator: CASE WHEN customer_state = 'Lagos' THEN 1500
- Design approval workflows: CASE WHEN order_value > 100000 THEN 'Requires Approval'

**Python-SQL Direct Translations:**
```python
# Wednesday Python:
if total_spent > 500000:
    customer_tier = 'VIP'
elif total_spent > 100000:
    customer_tier = 'Premium'
else:
    customer_tier = 'Standard'
```
```sql
-- Thursday SQL:
SELECT customer_id,
  CASE 
    WHEN total_spent > 500000 THEN 'VIP'
    WHEN total_spent > 100000 THEN 'Premium'
    ELSE 'Standard'
  END AS customer_tier
FROM customers;
```

**Excel Connections:**
- CASE WHEN = Excel's nested IF statements
- Multiple WHEN conditions = Excel's IF(AND()) and IF(OR()) combinations
- CASE with calculations = Excel's complex formula logic

**Common SQL Syntax Points:**
- CASE must end with END keyword
- WHEN conditions evaluated in order (first match wins)
- ELSE clause provides default value for unmatched cases

**Resources:**
- `scripts/02_case_when_statements.sql`
- `exercises/debugging_case_statements.sql`

### Topic 3: Combining Arithmetic with Conditional Logic (35 minutes)

**Subtopics:**
- Using arithmetic operations within CASE WHEN statements
- Calculating business metrics with conditional logic
- Creating complex pricing engines with multiple factors
- Combining WHERE clauses with calculated fields

**Activities:**
- Build tiered pricing system: CASE with arithmetic for volume discounts
- Calculate dynamic shipping: CASE statements with distance-based calculations
- Create performance bonuses: Arithmetic operations with conditional thresholds
- Generate automated alerts: CASE statements with calculated inventory levels

**Python-SQL Direct Translations:**
```python
# Wednesday Python:
for order in orders:
    if order['volume'] > 100:
        discount = 0.15
    elif order['customer_tier'] == 'VIP':
        discount = 0.10
    else:
        discount = 0.05
    final_price = order['price'] * (1 - discount)
```
```sql
-- Thursday SQL:
SELECT order_id, price,
  CASE 
    WHEN volume > 100 THEN price * 0.85
    WHEN customer_tier = 'VIP' THEN price * 0.90
    ELSE price * 0.95
  END AS final_price
FROM orders;
```

**Excel Connections:**
- Complex CASE calculations = Excel's nested formula combinations
- Conditional arithmetic = Excel's IF with mathematical operations
- Business rule automation = Excel's advanced formula logic

**Business Context:**
```sql
-- Business automation: "Dynamic pricing with multiple factors" (same as Wednesday Python)
SELECT product_id, base_price,
  CASE 
    WHEN customer_tier = 'VIP' THEN base_price * 0.85
    WHEN order_quantity > 50 THEN base_price * 0.90
    WHEN season = 'Holiday' THEN base_price * 1.10
    ELSE base_price
  END AS final_price,
  (final_price - cost_price) AS profit_margin
FROM orders;

-- Business calculation: "Sales commission with tier bonuses"
SELECT salesperson_id, sales_amount,
  CASE 
    WHEN sales_amount > 500000 THEN sales_amount * 0.12
    WHEN sales_amount > 250000 THEN sales_amount * 0.10
    ELSE sales_amount * 0.08
  END AS commission
FROM sales_data;
```

**Resources:**
- `scripts/03_arithmetic_conditional_combinations.sql`
- `exercises/business_calculations_sql.sql`

### Topic 4: Advanced Business Automation with SQL (30 minutes)

**Subtopics:**
- Subqueries with conditional logic for complex business rules
- Using aggregate functions with CASE statements
- Creating reusable views for common business calculations
- Performance considerations for complex conditional queries

**Activities:**
- Build comprehensive customer scoring system with multiple factors
- Create automated inventory reorder calculations
- Design performance dashboard with conditional formatting equivalents
- Implement business KPI calculations with thresholds and alerts

**Python-SQL Direct Translations:**
```python
# Wednesday Python:
for customer in customer_list:
    score = 0
    if customer['total_spent'] > 500000:
        score += 100
    if customer['orders_count'] > 10:
        score += 50
    if customer['referrals'] > 5:
        score += 25
    
    if score >= 150:
        tier = 'Platinum'
    elif score >= 100:
        tier = 'Gold'
    elif score >= 50:
        tier = 'Silver'
    else:
        tier = 'Bronze'
```
```sql
-- Thursday SQL:
SELECT customer_id,
  (CASE WHEN total_spent > 500000 THEN 100 ELSE 0 END +
   CASE WHEN orders_count > 10 THEN 50 ELSE 0 END +
   CASE WHEN referrals > 5 THEN 25 ELSE 0 END) AS customer_score,
  CASE 
    WHEN (customer_score) >= 150 THEN 'Platinum'
    WHEN (customer_score) >= 100 THEN 'Gold'
    WHEN (customer_score) >= 50 THEN 'Silver'
    ELSE 'Bronze'
  END AS customer_tier
FROM customers;
```

**Excel Connections:**
- CASE WHEN = Excel's nested IF statements with calculations
- SQL arithmetic in CASE = Excel's mathematical operations within IF
- Complex scoring = Excel's weighted scoring formulas

**Business Context:**
```sql
-- Business automation: "Multi-factor customer scoring" (matching Wednesday Python)
SELECT customer_id, 
  total_spent,
  orders_count,
  (total_spent * 0.6 + orders_count * 1000 * 0.4) AS weighted_score,
  CASE 
    WHEN weighted_score > 500000 THEN 'Platinum'
    WHEN weighted_score > 250000 THEN 'Gold'
    WHEN weighted_score > 100000 THEN 'Silver'
    ELSE 'Bronze'
  END AS customer_tier,
  CASE 
    WHEN customer_tier IN ('Platinum', 'Gold') THEN weighted_score * 0.15
    WHEN customer_tier = 'Silver' THEN weighted_score * 0.10
    ELSE weighted_score * 0.05
  END AS annual_discount_value
FROM customers;
```

**Resources:**
- `scripts/04_advanced_sql_automation.sql`
- `exercises/complex_business_logic_sql.sql`

### Wrap-up & Preview (5 minutes)
**Knowledge Check:**
- Show SQL CASE WHEN statement, identify Python equivalent from Wednesday
- Debug a CASE statement syntax error
- Explain when to use nested CASE vs simple arithmetic in business context

**Next Session Preview (Week 3):**
- Wednesday Python: Data aggregation and grouping with loops and functions
- Thursday SQL: GROUP BY clauses and aggregate functions
- Same business analysis, both tools

**Assignment Instructions:**
- Complete SQL arithmetic and CASE WHEN exercises with same business scenarios as Wednesday
- Practice automated business logic using SQL conditional statements
- Compare SQL and Python approaches for calculations and control flow in reflection assignment

## Materials Needed
- [ ] `scripts/01_sql_arithmetic_operations.sql` - Foundation arithmetic in SQL
- [ ] `scripts/02_case_when_statements.sql` - Conditional logic with CASE WHEN
- [ ] `scripts/03_arithmetic_conditional_combinations.sql` - Complex business calculations
- [ ] `scripts/04_advanced_sql_automation.sql` - Multi-factor business logic
- [ ] `datasets/naijacommerce_pricing_sql.csv` - Same pricing data as Wednesday Python session
- [ ] `datasets/business_rules_sql.csv` - Business logic data matching Python format

## Assessment

**Formative Assessment:**
- Live SQL calculation and CASE statement writing during each segment
- Peer explanation: "Describe this business logic using plain language"
- Error fixing exercises with common CASE WHEN and arithmetic syntax mistakes
- Quick translation: "What's the Python equivalent of this SQL calculation?"

**Summative Assessment:**
- End-of-session project: "Automated Pricing & Customer Tier System in SQL"
- Criteria: Write queries to create same pricing calculator and tier system as Wednesday's Python session
- Submit SQL script with calculations, CASE statements, and business automation
- Bonus: Compare SQL vs Python approaches for calculations and explain trade-offs

## Homework/Follow-up
**Assignment**: Complete `exercises/week_02_sql_calculations_conditional.sql`
- **Due**: Before Week 3 Wednesday's Python session
- **Components**:
  1. Arithmetic operations in business contexts
  2. Complex CASE WHEN statements for business automation
  3. Combined calculations and conditional logic
  4. Advanced business rule implementation using SQL
  5. Reflection: "How do SQL calculations and CASE statements compare to Python operators and control structures?"

**Extension Activities for Early Finishers:**
- Create additional business calculations using creative SQL expressions
- Explore NULL handling in CASE WHEN statements
- Practice subqueries with conditional logic for advanced scenarios
- Research SQL performance best practices for complex CASE statements

## Instructor Notes

**Special Preparation Needed:**
- Ensure database contains identical pricing and calculation data to Wednesday's Python CSV files
- Prepare side-by-side Python-SQL comparisons for each arithmetic and conditional concept
- Set up error examples for CASE WHEN syntax debugging practice
- Prepare same business calculation scenarios used in Wednesday's Python session

**Common Student Difficulties:**
1. **CASE WHEN syntax** (missing END keyword, incorrect WHEN placement)
   - *Solution*: Provide clear templates, emphasize required components
2. **Arithmetic operator precedence** in complex expressions
   - *Solution*: Show execution order, encourage parentheses usage for clarity
3. **Nested CASE statements** (complex logic overwhelming students)
   - *Solution*: Build complexity gradually, break down step-by-step
4. **Comparing to Python control structures** (wanting to use if/elif/else syntax)
   - *Solution*: Side-by-side comparison charts, practice translation exercises

**Confidence Building Strategies:**
- Start each concept with Wednesday's Python parallel: "Remember calculating this yesterday?"
- Use identical business examples and expected calculation results
- Celebrate automation victories: "You just recreated yesterday's business logic in SQL!"
- Show how SQL calculations produce same business automation as Python control structures

**Time Management Tips:**
- SQL arithmetic: 35 minutes (foundation calculations critical)
- CASE WHEN logic: 35 minutes (most time for syntax mastery)
- Combined calculations: 35 minutes (practical business applications)
- Advanced automation: 30 minutes (complex business logic patterns)
- Keep examples identical to Wednesday's Python session

**Synchronization with Wednesday Python:**
- Use identical datasets with same column names and numerical values
- Reference specific Python operator and control structure examples from Wednesday
- Show same business calculations and automation using different tools
- Maintain consistent NaijaCommerce business narrative
- Prepare transition language: "Next week we'll aggregate this calculated data"

## Resources

**Lecture Materials:**
- `01_sql_arithmetic_operations.sql` - Foundation calculations with Python comparisons
- `02_case_when_statements.sql` - Conditional logic with business applications
- `03_arithmetic_conditional_combinations.sql` - Complex business calculations
- `04_advanced_sql_automation.sql` - Multi-factor business logic matching Python control structures

**Exercise Files:**
- `exercises/week_02_sql_calculations_conditional.sql` - Guided practice problems
- `exercises/business_calculations_sql.sql` - Business calculations matching Python session
- `exercises/debugging_case_statements.sql` - Common error fixing practice
- `exercises/complex_business_logic_sql.sql` - Advanced CASE statement applications

**Support Resources:**
- `resources/sql_arithmetic_case_cheatsheet.md` - Quick reference for calculations and CASE WHEN
- `resources/python_to_sql_operations.md` - Direct operator and control structure translations
- `resources/sql_case_error_guide.md` - Common CASE WHEN errors and solutions
- `resources/business_sql_automation_patterns.md` - Templates for common business logic

**Database Schema:**
- pricing table with same columns as Wednesday's naijacommerce_pricing.csv
- customers table with tier and calculation data matching Wednesday's format
- sales_data table with commission and performance metrics
- Ensure numeric data types support arithmetic operations

---

**Note for Instructors**: This lesson directly parallels Wednesday's Python operators and control structures using SQL syntax. Every arithmetic operation and CASE WHEN statement should reference the equivalent Python calculation or if/elif/else structure students learned yesterday. The key to success is showing students that the same business logic applies to both tools - we're just changing the syntax, not the calculations or decision-making process. Use identical business scenarios and expected results to reinforce the concept that both Python and SQL are tools for implementing the same business automation and calculations.