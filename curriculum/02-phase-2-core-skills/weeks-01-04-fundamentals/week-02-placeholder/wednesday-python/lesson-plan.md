# Week 02 - Python Operators & Control Structures - Wednesday Python Session

## Session Overview
**Date**: August 20, 2025  
**Duration**: 2 hours  
**Platform**: Python/Google Colab  
**Business Scenario**: NaijaCommerce pricing calculations and automated decision-making using operators and control structures
**Building On**: Week 1 foundations (variables, DataFrames, basic data exploration) and boolean logic from existing content

## Learning Objectives
By the end of this session, students will be able to:
- [ ] Apply arithmetic operators (+, -, *, /, **, %, //) for business calculations
- [ ] Use comparison and logical operators to create business conditions
- [ ] Implement if/elif/else statements for automated decision-making
- [ ] Create for loops and while loops for repetitive business tasks
- [ ] Use break and continue statements for loop control
- [ ] Apply membership operators (in, not in) for category checking
- [ ] Build nested control structures for complex business logic
- [ ] Connect Python operators to Excel's formula and conditional formatting

## Session Structure

### Opening: From Excel Formulas to Python Operators (10 minutes)
**"Remember Excel's formulas and IF statements? Let's automate that in Python!"**
- Quick review: Week 1 success with DataFrames and boolean foundations
- Excel connection: Excel formulas = Python arithmetic operators
- Preview: By end of class, you'll automate pricing and decision-making
- Today's journey: From manual Excel calculations to programmatic control

**Excel Connections:**
- Excel arithmetic (=A1+B1) = Python operators (+, -, *, /)
- Excel IF statements = Python if/elif/else structures
- Excel nested IFs = Python nested conditionals and loops

### Topic 1: Arithmetic Operators & Business Calculations (35 minutes)

**Subtopics:**
- Basic arithmetic operators: +, -, *, / for financial calculations
- Advanced operators: ** (power), % (modulo), // (floor division)
- Order of operations (PEMDAS) in business formulas
- Working with numeric data types and precision

**Activities:**
- Calculate total order values with tax and shipping
- Compute commission percentages for sales staff
- Apply bulk discounts using percentage calculations
- Calculate compound interest for investment products

**Excel Connections:**
- Python +, -, *, / = Excel's =A1+B1, =A1*B1 formulas
- Python ** = Excel's POWER() function
- Python % = Excel's MOD() function

**Business Context:**
```python
# Business calculation: "Calculate total with 7.5% VAT"
total_with_tax = base_price * 1.075

# Business calculation: "Calculate bulk discount pricing"
discounted_price = original_price * (1 - discount_percentage / 100)

# Business calculation: "Calculate sales commission"
commission = sales_amount * commission_rate
```

**Resources:**
- `notebooks/01_arithmetic_operators_business.ipynb`
- `datasets/naijacommerce_pricing.csv` (product pricing and costs)

### Topic 2: Conditional Statements (if/elif/else) (35 minutes)

**Subtopics:**
- if statements for single condition decision-making
- elif for multiple condition chains
- else for default/catch-all scenarios
- Nested conditionals for complex business rules

**Activities:**
- Create customer tier assignment based on purchase history
- Implement dynamic pricing based on order volume
- Build order approval workflow with multiple criteria
- Design shipping cost calculator with location-based rules

**Excel Connections:**
- Python if/elif/else = Excel's nested IF statements
- Multiple conditions = Excel's AND(), OR() functions within IF
- Complex business rules = Excel's complex nested formula structures

**Business Context:**
```python
# Business rule: "Assign customer tier based on total spent"
if total_spent > 500000:
    customer_tier = 'VIP'
elif total_spent > 100000:
    customer_tier = 'Premium'
elif total_spent > 25000:
    customer_tier = 'Standard'
else:
    customer_tier = 'Basic'

# Business rule: "Calculate shipping cost"
if order_value > 50000:
    shipping_cost = 0  # Free shipping
elif customer_state == 'Lagos':
    shipping_cost = 1500
else:
    shipping_cost = 2500
```

**Common Errors to Address:**
- Missing colons after if/elif/else statements
- Incorrect indentation in code blocks
- Using = instead of == in conditions
- Unreachable elif/else conditions due to logic errors

**Resources:**
- `notebooks/02_conditional_statements_business.ipynb`
- `exercises/debugging_conditionals.ipynb`

### Topic 3: Loops & Repetitive Business Tasks (35 minutes)

**Subtopics:**
- for loops for iterating through lists and ranges
- while loops for condition-based repetition
- Loop control with break and continue statements
- Nested loops for complex data processing

**Activities:**
- Process monthly sales reports for each quarter
- Calculate compound interest for multiple investment scenarios
- Generate price lists for different customer tiers
- Process inventory updates across multiple product categories

**Excel Connections:**
- for loops = Excel's fill-down formulas across rows
- while loops = Excel's iterative calculations
- Nested loops = Excel's array formulas and complex lookups

**Business Context:**
```python
# Business task: "Calculate quarterly bonuses for all sales staff"
for quarter in ['Q1', 'Q2', 'Q3', 'Q4']:
    for salesperson in sales_team:
        if sales_data[quarter][salesperson] > target:
            bonus = sales_data[quarter][salesperson] * 0.1
            print(f'{salesperson} Q{quarter} bonus: ₦{bonus:,.2f}')

# Business task: "Process inventory until stock is adequate"
while current_stock < minimum_stock:
    order_quantity = calculate_reorder_amount()
    current_stock += order_quantity
    print(f'Reordered {order_quantity} units. New stock: {current_stock}')
```

**Resources:**
- `notebooks/03_loops_business_tasks.ipynb`
- `datasets/quarterly_sales_data.csv`

### Topic 4: Advanced Control Flow & Business Automation (30 minutes)

**Subtopics:**
- Membership operators (in, not in) for category checking
- Combining operators in complex business logic
- Creating reusable business rule functions
- Error handling in business calculations

**Activities:**
- Build automated product categorization system
- Create dynamic pricing engine with multiple factors
- Implement customer credit approval workflow
- Design inventory alert system with multiple thresholds

**Excel Connections:**
- Membership operators = Excel's MATCH() and INDEX() functions
- Complex business logic = Excel's advanced formula combinations
- Automation patterns = Excel's macro and VBA equivalent logic

**Business Context:**
```python
# Business automation: "Product category validation"
valid_categories = ['Electronics', 'Fashion', 'Home', 'Sports']
for product in product_list:
    if product['category'] in valid_categories:
        process_product(product)
    else:
        flag_for_review(product)

# Business automation: "Multi-factor pricing engine"
for order in order_queue:
    if order['customer_tier'] in ['VIP', 'Premium']:
        discount = 0.15
    elif order['order_value'] > 100000:
        discount = 0.1
    elif 'bulk_order' in order['tags']:
        discount = 0.05
    else:
        discount = 0.0
    
    final_price = order['base_price'] * (1 - discount)
```

**Resources:**
- `notebooks/04_advanced_control_flow.ipynb`
- `exercises/business_automation_challenges.ipynb`

### Wrap-up & Preview (5 minutes)
**Knowledge Check:**
- Demonstrate arithmetic calculation with operators
- Debug an if/elif/else logic error
- Explain when to use for vs while loops in business context

**Next Session Preview (Thursday SQL):**
- Same conditional concepts using CASE WHEN statements
- Arithmetic operations in SQL SELECT statements  
- Same business rules, SQL syntax

**Assignment Instructions:**
- Complete operator and control structure exercises with business scenarios
- Practice building automated business logic
- Prepare for Thursday's SQL conditional statements

## Materials Needed
- [ ] `notebooks/01_arithmetic_operators_business.ipynb` - Mathematical operations for pricing
- [ ] `notebooks/02_conditional_statements_business.ipynb` - Business decision automation
- [ ] `notebooks/03_loops_business_tasks.ipynb` - Repetitive task automation
- [ ] `notebooks/04_advanced_control_flow.ipynb` - Complex business logic patterns
- [ ] `datasets/naijacommerce_pricing.csv` - Product costs, prices, and margins
- [ ] `datasets/quarterly_sales_data.csv` - Sales performance for calculations

## Assessment

**Formative Assessment:**
- Live calculation and control structure challenges during each segment
- Peer explanation: "Describe this business logic using plain language"
- Error fixing exercises with common operator and control structure mistakes
- Quick translation: "What's the Excel equivalent of this Python operation?"

**Summative Assessment:**
- End-of-session project: "Automated Pricing & Customer Tier System"
- Criteria: Build pricing calculator with customer tier automation, explain business logic
- Submit notebook with calculations, control structures, and business automation

## Homework/Follow-up
**Assignment**: Complete `exercises/week_02_python_operators_control.ipynb`
- **Due**: Before Thursday's SQL session
- **Components**:
  1. Arithmetic operator calculations for business scenarios
  2. Conditional statements for automated decision-making
  3. Loop structures for repetitive business tasks
  4. Advanced control flow for complex business rules
  5. Reflection: "How do Python operators and control structures compare to Excel formulas?"

**Extension Activities for Early Finishers:**
- Create additional business calculation functions using operators
- Explore nested loop structures for complex data processing
- Practice list comprehensions as alternative to traditional loops
- Research Python operator precedence and performance optimization

## Instructor Notes

**Special Preparation Needed:**
- Prepare datasets with realistic Nigerian pricing and calculation scenarios
- Create side-by-side Excel comparisons for each operator and control concept
- Set up error examples for debugging operator precedence and control flow issues
- Prepare business scenarios that require mathematical calculations and automated logic

**Common Student Difficulties:**
1. **Operator precedence confusion** (order of operations)
   - *Solution*: Provide PEMDAS examples, emphasize parentheses usage
2. **Missing colons and indentation** in control structures
   - *Solution*: Create syntax templates, practice with clear examples
3. **Infinite loops** in while statements
   - *Solution*: Emphasize loop exit conditions, practice with counters
4. **Complex nested logic** overwhelming students
   - *Solution*: Build complexity gradually, break down step-by-step

**Confidence Building Strategies:**
- Start each concept with Excel parallel: "You already know this from formulas!"
- Use Nigerian business examples students can relate to
- Celebrate automation successes: "You just automated a business calculation!"
- Show how control structures eliminate repetitive manual work

**Time Management Tips:**
- Arithmetic operators: 35 minutes (foundation calculations critical)
- Conditional statements: 35 minutes (spend time on syntax and logic)
- Loops: 35 minutes (fun business automation applications)
- Advanced control flow: 30 minutes (complex business logic patterns)
- Keep business context relevant and engaging

**Synchronization with Thursday SQL:**
- Use identical business calculations that will be implemented with SQL arithmetic
- Reference same conditional logic that will be created with CASE WHEN statements
- Prepare transition language: "Tomorrow we'll do this same logic in SQL"
- Maintain consistent dataset structure for SQL compatibility

## Resources

**Lecture Materials:**
- `01_arithmetic_operators_business.ipynb` - Foundation calculations with Excel comparisons
- `02_conditional_statements_business.ipynb` - Decision automation with business applications
- `03_loops_business_tasks.ipynb` - Real-world business automation scenarios  
- `04_advanced_control_flow.ipynb` - Complex business logic for automation

**Exercise Files:**
- `exercises/week_02_python_operators_control.ipynb` - Guided practice problems
- `exercises/business_automation_challenge.ipynb` - Open-ended automation project
- `exercises/debugging_conditionals.ipynb` - Common error fixing practice
- `exercises/business_automation_challenges.ipynb` - Advanced control structure applications

**Support Resources:**
- `resources/python_operators_cheatsheet.md` - Quick reference for all operator types
- `resources/excel_to_python_operations.md` - Direct formula translations
- `resources/control_structure_error_guide.md` - Common errors and solutions
- `resources/business_automation_patterns.md` - Templates for common business logic

**Datasets:**
- `naijacommerce_pricing.csv` - Product costs, margins, and pricing data
- `quarterly_sales_data.csv` - Sales performance for commission calculations
- `customer_tiers.csv` - Customer classification data for automation
- Nigerian business context data with realistic financial values and calculations

---

**Note for Instructors**: This lesson builds directly on Week 1's DataFrame foundations and integrates boolean logic concepts. Every operator and control structure should connect to Excel's formula and conditional functionality to build confidence. The key to success is showing students that they already understand business calculations and decision-making - we're just learning Python's syntax for automating that logic. Emphasize business automation and efficiency throughout to maintain relevance and engagement.