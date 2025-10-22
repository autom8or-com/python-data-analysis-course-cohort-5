/*
================================================================================
WEEK 10 - THURSDAY SQL LECTURE
Data Integrity: Constraints and Business Rules
================================================================================

LEARNING OBJECTIVES:
- Implement database constraints for data quality
- Design check constraints for business rules
- Understand referential integrity and foreign keys
- Apply trigger concepts for data validation

BUSINESS CONTEXT:
In Nigerian e-commerce operations, data integrity prevents costly errors:
- Invalid prices causing revenue loss
- Orphaned orders without customers
- Negative inventory quantities
- Duplicate customer records
Constraints enforce business rules at the database level, ensuring data quality
regardless of which application accesses the database.

DURATION: 45 minutes
================================================================================
*/

-- ============================================================================
-- PART 1: PRIMARY KEYS AND UNIQUE CONSTRAINTS (10 minutes)
-- ============================================================================

/*
PRIMARY KEY CONSTRAINT:
- Uniquely identifies each row
- Cannot be NULL
- Only one primary key per table
- Automatically creates an index

UNIQUE CONSTRAINT:
- Ensures column values are unique
- Can be NULL (unless combined with NOT NULL)
- Multiple unique constraints per table
*/

-- Let's examine Olist's primary key implementation
SELECT
    table_name,
    column_name,
    data_type
FROM information_schema.table_constraints tc
JOIN information_schema.key_column_usage kcu
    ON tc.constraint_name = kcu.constraint_name
    AND tc.table_schema = kcu.table_schema
WHERE tc.constraint_type = 'PRIMARY KEY'
    AND tc.table_schema = 'olist_sales_data_set'
ORDER BY table_name, kcu.ordinal_position;

-- EXAMPLE 1: Creating table with PRIMARY KEY

-- Nigerian e-commerce inventory system
CREATE TEMP TABLE inventory (
    inventory_id SERIAL PRIMARY KEY,  -- Auto-incrementing primary key
    product_id TEXT NOT NULL,
    warehouse_location VARCHAR(100) NOT NULL,
    quantity_on_hand INTEGER NOT NULL DEFAULT 0,
    reorder_level INTEGER NOT NULL DEFAULT 10,
    last_restock_date TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Attempt to insert duplicate primary key (will fail)
INSERT INTO inventory (inventory_id, product_id, warehouse_location, quantity_on_hand)
VALUES (1, 'PROD001', 'Lagos Warehouse', 100);

-- This will fail with primary key violation
-- INSERT INTO inventory (inventory_id, product_id, warehouse_location, quantity_on_hand)
-- VALUES (1, 'PROD002', 'Abuja Warehouse', 50);


-- EXAMPLE 2: UNIQUE Constraints for Business Rules

CREATE TEMP TABLE warehouses (
    warehouse_id SERIAL PRIMARY KEY,
    warehouse_code VARCHAR(20) UNIQUE NOT NULL,  -- No duplicate codes
    warehouse_name VARCHAR(100) NOT NULL,
    city VARCHAR(50) NOT NULL,
    state VARCHAR(50) NOT NULL,
    manager_email VARCHAR(100) UNIQUE,  -- One warehouse per manager
    capacity_cubic_meters INTEGER NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Insert valid data
INSERT INTO warehouses (warehouse_code, warehouse_name, city, state, manager_email, capacity_cubic_meters)
VALUES
    ('LG-001', 'Lagos Main Warehouse', 'Lagos', 'Lagos', 'manager.lagos@example.com', 10000),
    ('AB-001', 'Abuja Central Warehouse', 'Abuja', 'FCT', 'manager.abuja@example.com', 8000),
    ('PH-001', 'Port Harcourt Warehouse', 'Port Harcourt', 'Rivers', 'manager.ph@example.com', 7500);

-- This will fail due to duplicate warehouse_code
-- INSERT INTO warehouses (warehouse_code, warehouse_name, city, state, capacity_cubic_meters)
-- VALUES ('LG-001', 'Lagos Secondary Warehouse', 'Lagos', 'Lagos', 9000);

-- Composite UNIQUE constraint (combination must be unique)
CREATE TEMP TABLE product_warehouse (
    product_id TEXT NOT NULL,
    warehouse_id INTEGER NOT NULL,
    quantity INTEGER NOT NULL DEFAULT 0,
    aisle VARCHAR(10),
    shelf VARCHAR(10),
    PRIMARY KEY (product_id, warehouse_id),  -- Composite primary key
    UNIQUE (warehouse_id, aisle, shelf)       -- Same location can't store 2 products
);


-- ============================================================================
-- PART 2: FOREIGN KEY CONSTRAINTS (REFERENTIAL INTEGRITY) (10 minutes)
-- ============================================================================

/*
FOREIGN KEY CONSTRAINT:
- Ensures referential integrity between tables
- References primary key or unique key in another table
- Prevents orphaned records
- Can cascade updates/deletes

CASCADE OPTIONS:
- ON DELETE CASCADE: Delete child records when parent is deleted
- ON DELETE SET NULL: Set foreign key to NULL when parent is deleted
- ON DELETE RESTRICT: Prevent deletion of parent if children exist (default)
- ON UPDATE CASCADE: Update foreign key when parent key changes
*/

-- Examine Olist's foreign key relationships
SELECT
    tc.table_name,
    kcu.column_name,
    ccu.table_name AS foreign_table_name,
    ccu.column_name AS foreign_column_name,
    rc.delete_rule,
    rc.update_rule
FROM information_schema.table_constraints AS tc
JOIN information_schema.key_column_usage AS kcu
    ON tc.constraint_name = kcu.constraint_name
    AND tc.table_schema = kcu.table_schema
JOIN information_schema.constraint_column_usage AS ccu
    ON ccu.constraint_name = tc.constraint_name
    AND ccu.table_schema = tc.table_schema
JOIN information_schema.referential_constraints AS rc
    ON rc.constraint_name = tc.constraint_name
WHERE tc.constraint_type = 'FOREIGN KEY'
    AND tc.table_schema = 'olist_sales_data_set'
ORDER BY tc.table_name;


-- EXAMPLE 1: Basic Foreign Key

CREATE TEMP TABLE products (
    product_id SERIAL PRIMARY KEY,
    product_name VARCHAR(200) NOT NULL,
    category_id INTEGER NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    weight_kg DECIMAL(8,3) NOT NULL
);

CREATE TEMP TABLE categories (
    category_id SERIAL PRIMARY KEY,
    category_name VARCHAR(100) NOT NULL UNIQUE,
    parent_category_id INTEGER,
    FOREIGN KEY (parent_category_id) REFERENCES categories(category_id)
);

-- Insert categories first
INSERT INTO categories (category_name) VALUES
    ('Electronics'),
    ('Fashion'),
    ('Home & Kitchen');

-- Now insert products (must reference existing category_id)
ALTER TABLE products
ADD CONSTRAINT fk_products_category
FOREIGN KEY (category_id) REFERENCES categories(category_id)
ON DELETE RESTRICT;  -- Can't delete category if products exist

-- This works - category 1 exists
INSERT INTO products (product_name, category_id, price, weight_kg)
VALUES ('Samsung Galaxy S21', 1, 45000, 0.169);

-- This fails - category 99 doesn't exist
-- INSERT INTO products (product_name, category_id, price, weight_kg)
-- VALUES ('Unknown Product', 99, 1000, 0.5);


-- EXAMPLE 2: CASCADE Operations

CREATE TEMP TABLE customers_demo (
    customer_id SERIAL PRIMARY KEY,
    customer_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(20)
);

CREATE TEMP TABLE orders_demo (
    order_id SERIAL PRIMARY KEY,
    customer_id INTEGER NOT NULL,
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    total_amount DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES customers_demo(customer_id)
        ON DELETE CASCADE  -- Delete orders when customer is deleted
);

CREATE TEMP TABLE order_items_demo (
    order_item_id SERIAL PRIMARY KEY,
    order_id INTEGER NOT NULL,
    product_id INTEGER NOT NULL,
    quantity INTEGER NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders_demo(order_id)
        ON DELETE CASCADE  -- Delete items when order is deleted
);

-- Insert test data
INSERT INTO customers_demo (customer_name, email, phone)
VALUES ('Adewale Johnson', 'adewale@example.com', '08012345678');

INSERT INTO orders_demo (customer_id, order_date, total_amount)
VALUES (1, '2025-01-15', 15000);

INSERT INTO order_items_demo (order_id, product_id, quantity, price)
VALUES (1, 101, 2, 7500);

-- Deleting customer cascades to orders and order_items
-- DELETE FROM customers_demo WHERE customer_id = 1;
-- This would also delete the order and order_items!


-- EXAMPLE 3: Real-world Inventory System with Foreign Keys

CREATE TEMP TABLE suppliers (
    supplier_id SERIAL PRIMARY KEY,
    supplier_name VARCHAR(200) NOT NULL,
    contact_email VARCHAR(100) UNIQUE NOT NULL,
    city VARCHAR(50) NOT NULL,
    state VARCHAR(50) NOT NULL
);

CREATE TEMP TABLE product_suppliers (
    product_id TEXT NOT NULL,
    supplier_id INTEGER NOT NULL,
    cost_price DECIMAL(10,2) NOT NULL,
    lead_time_days INTEGER NOT NULL,
    minimum_order_quantity INTEGER NOT NULL,
    PRIMARY KEY (product_id, supplier_id),
    FOREIGN KEY (supplier_id) REFERENCES suppliers(supplier_id)
        ON DELETE RESTRICT  -- Can't delete supplier if products linked
);

CREATE TEMP TABLE purchase_orders (
    po_id SERIAL PRIMARY KEY,
    supplier_id INTEGER NOT NULL,
    order_date DATE NOT NULL,
    expected_delivery_date DATE NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'pending',
    total_amount DECIMAL(12,2) NOT NULL,
    FOREIGN KEY (supplier_id) REFERENCES suppliers(supplier_id)
        ON DELETE RESTRICT,
    CHECK (expected_delivery_date >= order_date),  -- Can't deliver before ordering!
    CHECK (status IN ('pending', 'approved', 'shipped', 'received', 'cancelled'))
);


-- ============================================================================
-- PART 3: CHECK CONSTRAINTS (BUSINESS RULES) (15 minutes)
-- ============================================================================

/*
CHECK CONSTRAINTS:
- Enforce business rules at database level
- Validate data before insert/update
- Prevent invalid data entry
- Can reference multiple columns
*/

-- EXAMPLE 1: Simple CHECK constraints

CREATE TEMP TABLE products_with_checks (
    product_id SERIAL PRIMARY KEY,
    product_name VARCHAR(200) NOT NULL,
    price DECIMAL(10,2) NOT NULL CHECK (price > 0),  -- Price must be positive
    discount_percent INTEGER CHECK (discount_percent BETWEEN 0 AND 100),
    weight_kg DECIMAL(8,3) CHECK (weight_kg > 0),
    stock_quantity INTEGER NOT NULL DEFAULT 0 CHECK (stock_quantity >= 0),
    status VARCHAR(20) DEFAULT 'active' CHECK (status IN ('active', 'discontinued', 'out_of_stock'))
);

-- Valid insert
INSERT INTO products_with_checks (product_name, price, discount_percent, weight_kg, stock_quantity)
VALUES ('Laptop Computer', 85000.00, 15, 2.5, 50);

-- These will fail:
-- Negative price
-- INSERT INTO products_with_checks (product_name, price, weight_kg)
-- VALUES ('Test Product', -100, 1.0);

-- Invalid discount (> 100%)
-- INSERT INTO products_with_checks (product_name, price, discount_percent, weight_kg)
-- VALUES ('Test Product', 1000, 150, 1.0);

-- Negative stock
-- INSERT INTO products_with_checks (product_name, price, weight_kg, stock_quantity)
-- VALUES ('Test Product', 1000, 1.0, -5);


-- EXAMPLE 2: Multi-column CHECK constraints

CREATE TEMP TABLE orders_with_checks (
    order_id SERIAL PRIMARY KEY,
    customer_id INTEGER NOT NULL,
    order_date DATE NOT NULL DEFAULT CURRENT_DATE,
    shipping_date DATE,
    delivery_date DATE,
    subtotal DECIMAL(12,2) NOT NULL CHECK (subtotal >= 0),
    shipping_cost DECIMAL(8,2) NOT NULL CHECK (shipping_cost >= 0),
    discount_amount DECIMAL(10,2) DEFAULT 0 CHECK (discount_amount >= 0),
    total_amount DECIMAL(12,2) NOT NULL,

    -- Multi-column checks
    CHECK (shipping_date IS NULL OR shipping_date >= order_date),
    CHECK (delivery_date IS NULL OR delivery_date >= shipping_date),
    CHECK (total_amount = subtotal + shipping_cost - discount_amount),
    CHECK (discount_amount <= subtotal)  -- Discount can't exceed subtotal
);

-- Valid order
INSERT INTO orders_with_checks (customer_id, order_date, subtotal, shipping_cost, discount_amount, total_amount)
VALUES (1, '2025-01-15', 10000, 500, 1000, 9500);

-- Invalid: delivery before shipping
-- INSERT INTO orders_with_checks (customer_id, order_date, shipping_date, delivery_date, subtotal, shipping_cost, total_amount)
-- VALUES (1, '2025-01-15', '2025-01-18', '2025-01-16', 10000, 500, 10500);

-- Invalid: total doesn't match calculation
-- INSERT INTO orders_with_checks (customer_id, subtotal, shipping_cost, discount_amount, total_amount)
-- VALUES (1, 10000, 500, 1000, 15000);  -- Should be 9500


-- EXAMPLE 3: Real-world Inventory Business Rules

CREATE TEMP TABLE inventory_with_rules (
    inventory_id SERIAL PRIMARY KEY,
    product_id TEXT NOT NULL,
    warehouse_id INTEGER NOT NULL,
    quantity_on_hand INTEGER NOT NULL DEFAULT 0,
    quantity_reserved INTEGER NOT NULL DEFAULT 0,
    quantity_available INTEGER GENERATED ALWAYS AS (quantity_on_hand - quantity_reserved) STORED,
    reorder_level INTEGER NOT NULL,
    reorder_quantity INTEGER NOT NULL,
    cost_per_unit DECIMAL(10,2) NOT NULL,
    last_restock_date DATE,
    last_stock_check_date DATE NOT NULL DEFAULT CURRENT_DATE,

    -- Business rule constraints
    CHECK (quantity_on_hand >= 0),
    CHECK (quantity_reserved >= 0),
    CHECK (quantity_reserved <= quantity_on_hand),  -- Can't reserve more than we have
    CHECK (reorder_level >= 0),
    CHECK (reorder_quantity > 0),
    CHECK (cost_per_unit > 0),
    CHECK (last_stock_check_date <= CURRENT_DATE),  -- Can't check stock in future
    CHECK (last_restock_date IS NULL OR last_restock_date <= CURRENT_DATE)
);

-- Valid inventory entry
INSERT INTO inventory_with_rules (product_id, warehouse_id, quantity_on_hand, quantity_reserved, reorder_level, reorder_quantity, cost_per_unit)
VALUES ('PROD-001', 1, 100, 25, 20, 50, 5000.00);

SELECT product_id, quantity_on_hand, quantity_reserved, quantity_available
FROM inventory_with_rules;


-- EXAMPLE 4: E-commerce Order Validation Rules

CREATE TEMP TABLE order_validation (
    order_id SERIAL PRIMARY KEY,
    customer_id INTEGER NOT NULL,
    order_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    payment_method VARCHAR(50) NOT NULL,
    payment_status VARCHAR(20) NOT NULL DEFAULT 'pending',
    subtotal DECIMAL(12,2) NOT NULL,
    tax_amount DECIMAL(10,2) NOT NULL DEFAULT 0,
    shipping_cost DECIMAL(8,2) NOT NULL,
    discount_code VARCHAR(50),
    discount_amount DECIMAL(10,2) DEFAULT 0,
    total_amount DECIMAL(12,2) NOT NULL,

    -- Business rules
    CHECK (payment_method IN ('credit_card', 'debit_card', 'bank_transfer', 'cash_on_delivery', 'mobile_money')),
    CHECK (payment_status IN ('pending', 'processing', 'completed', 'failed', 'refunded')),
    CHECK (subtotal > 0),
    CHECK (tax_amount >= 0),
    CHECK (tax_amount <= subtotal * 0.2),  -- Max 20% tax
    CHECK (shipping_cost >= 0),
    CHECK (discount_amount >= 0),
    CHECK (discount_amount <= subtotal * 0.5),  -- Max 50% discount
    CHECK (total_amount = subtotal + tax_amount + shipping_cost - discount_amount),
    CHECK (
        -- If COD, order must be under 200,000 Naira
        payment_method != 'cash_on_delivery' OR total_amount <= 200000
    )
);


-- ============================================================================
-- PART 4: NOT NULL CONSTRAINTS AND DEFAULTS (5 minutes)
-- ============================================================================

/*
NOT NULL CONSTRAINT:
- Column must have a value
- Prevents NULL entries
- Essential for required business data

DEFAULT VALUES:
- Automatic value if none provided
- Simplifies inserts
- Ensures consistent initial state
*/

CREATE TEMP TABLE customers_with_defaults (
    customer_id SERIAL PRIMARY KEY,
    customer_name VARCHAR(100) NOT NULL,  -- Required
    email VARCHAR(100) NOT NULL UNIQUE,    -- Required and unique
    phone VARCHAR(20),                     -- Optional
    registration_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    account_status VARCHAR(20) NOT NULL DEFAULT 'active',
    loyalty_points INTEGER NOT NULL DEFAULT 0,
    email_verified BOOLEAN NOT NULL DEFAULT FALSE,
    marketing_opt_in BOOLEAN NOT NULL DEFAULT FALSE,

    CHECK (account_status IN ('active', 'suspended', 'closed')),
    CHECK (loyalty_points >= 0)
);

-- Minimal insert (uses defaults)
INSERT INTO customers_with_defaults (customer_name, email)
VALUES ('Chiamaka Okafor', 'chiamaka@example.com');

-- Check the defaults
SELECT customer_name, registration_date, account_status, loyalty_points, email_verified
FROM customers_with_defaults;


-- ============================================================================
-- PART 5: TRIGGER CONCEPTS FOR DATA VALIDATION (5 minutes)
-- ============================================================================

/*
TRIGGERS:
- Automatic actions when specific events occur
- Before/After INSERT, UPDATE, DELETE
- Can validate data, audit changes, maintain derived values
- More flexible than CHECK constraints

Note: Full trigger implementation is beyond today's scope,
but understanding the concept is important for data integrity.
*/

-- EXAMPLE: Audit Trail Trigger (Concept)

CREATE TEMP TABLE products_audit (
    audit_id SERIAL PRIMARY KEY,
    product_id INTEGER NOT NULL,
    action VARCHAR(10) NOT NULL,
    old_price DECIMAL(10,2),
    new_price DECIMAL(10,2),
    changed_by VARCHAR(100),
    changed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Conceptual trigger (PostgreSQL syntax):
/*
CREATE OR REPLACE FUNCTION audit_product_price_change()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'UPDATE' AND OLD.price != NEW.price THEN
        INSERT INTO products_audit (product_id, action, old_price, new_price, changed_by)
        VALUES (NEW.product_id, 'UPDATE', OLD.price, NEW.price, current_user);
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_audit_price_change
AFTER UPDATE ON products
FOR EACH ROW
EXECUTE FUNCTION audit_product_price_change();
*/

-- EXAMPLE: Inventory Update Trigger (Concept)

-- Trigger to update inventory when order is placed
/*
CREATE OR REPLACE FUNCTION update_inventory_on_order()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE inventory
    SET quantity_reserved = quantity_reserved + NEW.quantity
    WHERE product_id = NEW.product_id;

    -- Check if inventory is sufficient
    IF (SELECT quantity_available FROM inventory WHERE product_id = NEW.product_id) < 0 THEN
        RAISE EXCEPTION 'Insufficient inventory for product %', NEW.product_id;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;
*/


-- ============================================================================
-- PART 6: ANALYZING OLIST DATA QUALITY WITH CONSTRAINTS (5 minutes)
-- ============================================================================

-- Check for data quality issues that constraints would prevent

-- 1. Check for NULL values in critical columns
SELECT
    COUNT(*) as total_products,
    COUNT(product_category_name) as products_with_category,
    COUNT(*) - COUNT(product_category_name) as products_without_category,
    COUNT(product_weight_g) as products_with_weight,
    COUNT(*) - COUNT(product_weight_g) as products_without_weight
FROM olist_sales_data_set.olist_products_dataset;

-- 2. Check for invalid prices (should be positive)
SELECT
    COUNT(*) as total_order_items,
    COUNT(CASE WHEN price <= 0 THEN 1 END) as invalid_prices,
    MIN(price) as min_price,
    MAX(price) as max_price
FROM olist_sales_data_set.olist_order_items_dataset;

-- 3. Check for referential integrity violations
SELECT
    COUNT(DISTINCT oi.order_id) as order_items_orders,
    COUNT(DISTINCT o.order_id) as actual_orders,
    COUNT(DISTINCT oi.order_id) - COUNT(DISTINCT o.order_id) as orphaned_order_items
FROM olist_sales_data_set.olist_order_items_dataset oi
LEFT JOIN olist_sales_data_set.olist_orders_dataset o
    ON oi.order_id = o.order_id;

-- 4. Check for date logic violations
SELECT
    COUNT(*) as total_orders,
    COUNT(CASE WHEN order_delivered_customer_date < order_purchase_timestamp THEN 1 END) as delivery_before_purchase,
    COUNT(CASE WHEN order_estimated_delivery_date < order_purchase_timestamp THEN 1 END) as estimate_before_purchase
FROM olist_sales_data_set.olist_orders_dataset
WHERE order_delivered_customer_date IS NOT NULL;


-- ============================================================================
-- KEY TAKEAWAYS
-- ============================================================================

/*
1. PRIMARY KEYS AND UNIQUE CONSTRAINTS:
   - Every table needs a primary key
   - Use UNIQUE for business-level uniqueness (email, product code)
   - Composite keys for many-to-many relationships

2. FOREIGN KEYS (REFERENTIAL INTEGRITY):
   - Prevent orphaned records
   - Choose appropriate CASCADE options
   - ON DELETE RESTRICT for important relationships
   - ON DELETE CASCADE for dependent data

3. CHECK CONSTRAINTS:
   - Enforce business rules at database level
   - Validate ranges, formats, relationships
   - Multi-column checks for complex logic
   - Better than application-level validation (can't be bypassed)

4. NOT NULL AND DEFAULTS:
   - Mark required fields as NOT NULL
   - Use meaningful defaults
   - Simplify data entry and ensure consistency

5. TRIGGERS FOR COMPLEX VALIDATION:
   - Audit trails and change tracking
   - Derived value maintenance
   - Complex business logic
   - Use sparingly (can impact performance)

6. DATA QUALITY IN OLIST:
   - Well-designed foreign keys maintain integrity
   - Some NULL values where constraints could help
   - Date logic generally valid
   - Good example of real-world database design

7. NIGERIAN E-COMMERCE CONTEXT:
   - Constraints prevent data entry errors
   - Critical for multi-vendor marketplaces
   - Reduce need for data cleaning
   - Enable reliable reporting and analytics
   - Support compliance requirements
*/

-- ============================================================================
-- PRACTICE EXERCISE
-- ============================================================================

/*
CHALLENGE: Design a complete inventory management schema with constraints

Create tables for:
1. products
   - product_id (PK)
   - product_name (NOT NULL, UNIQUE)
   - category_id (FK to categories)
   - price (CHECK > 0)
   - weight_kg (CHECK > 0)
   - status (CHECK IN ('active', 'discontinued'))

2. warehouses
   - warehouse_id (PK)
   - warehouse_code (UNIQUE, NOT NULL)
   - city, state (NOT NULL)
   - capacity_cubic_meters (CHECK > 0)

3. inventory
   - Composite PK (product_id, warehouse_id)
   - quantity_on_hand (CHECK >= 0)
   - quantity_reserved (CHECK >= 0, <= quantity_on_hand)
   - reorder_level (CHECK >= 0)
   - last_restock_date (CHECK <= CURRENT_DATE)

4. inventory_transactions
   - transaction_id (PK)
   - product_id, warehouse_id (FKs)
   - transaction_type (CHECK IN ('restock', 'sale', 'return', 'adjustment'))
   - quantity (CHECK != 0)
   - transaction_date (DEFAULT CURRENT_TIMESTAMP, CHECK <= CURRENT_DATE)

Add appropriate constraints to ensure:
- No negative inventory
- Products can't be in warehouses that don't exist
- Transaction dates are realistic
- All prices and quantities are valid

Test your constraints with valid and invalid data!
*/
