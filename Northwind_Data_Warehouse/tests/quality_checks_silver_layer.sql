/*
===============================================================================
Data Quality Checks: Silver Layer
===============================================================================
Purpose:
    This script validates the quality of data loaded into the silver schema.

Checks Performed:
    - Duplicate records
    - NULL values
    - Leading and trailing spaces
    - Data standardisation
    - Invalid date relationships
    - Invalid categorical values

Expected Results:
    Queries marked as checks should return an empty result set unless otherwise
    stated. Any returned records should be reviewed and corrected.
===============================================================================
*/



-- =====================================================================
-- 1. categories table
-- =====================================================================

-- Check for duplicate category IDs; expected: no rows
SELECT 
    category_id,
    COUNT(*) AS duplicate_count
FROM silver.categories
GROUP BY category_id
HAVING COUNT(*) > 1;

-- Check for NULL values; expected: no rows
SELECT 
    category_id,
    category_name,
    cat_description
FROM silver.categories
WHERE category_id IS NULL
    OR category_name IS NULL
    OR cat_description IS NULL;

-- Check for leading or trailing spaces; expected: no rows
SELECT 
    category_id,
    category_name,
    cat_description
FROM silver.categories
WHERE category_name != TRIM(category_name)
    OR cat_description != TRIM(cat_description);


-- =====================================================================
-- 2. customers table
-- =====================================================================

-- Check for duplicate customer IDs; expected: no rows
SELECT 
    customer_id,
    COUNT(*) AS duplicate_count
FROM silver.customers
GROUP BY customer_id
HAVING COUNT(*) > 1;

-- Check for leading or trailing spaces; expected: no rows
SELECT 
    customer_id,
    company_name,
    contact_name,
    contact_title,
    city,
    country
FROM silver.customers
WHERE customer_id != TRIM(customer_id)
    OR company_name != TRIM(company_name)
    OR contact_name != TRIM(contact_name)
    OR contact_title != TRIM(contact_title)
    OR city != TRIM(city)
    OR country != TRIM(country);

-- Check for NULL values; expected: no rows
SELECT 
    customer_id,
    company_name,
    contact_name,
    contact_title,
    city,
    country
FROM silver.customers
WHERE customer_id IS NULL
    OR company_name IS NULL
    OR contact_name IS NULL
    OR contact_title IS NULL
    OR city IS NULL
    OR country IS NULL;

-- Review standardized contact-title values
SELECT DISTINCT
    contact_title
FROM silver.customers;

-- Confirm that the old contact-title value was removed; expected: no rows
SELECT
    customer_id,
    company_name,
    contact_name,
    contact_title,
    city,
    country
FROM silver.customers
WHERE contact_title = 'Owner/Marketing Assistant';

-- Review standardized city values
SELECT DISTINCT
    city
FROM silver.customers;

-- Review standardized country values
SELECT DISTINCT
    country
FROM silver.customers;


-- =====================================================================
-- 3. employees table
-- =====================================================================

-- Check for duplicate employee IDs; expected: no rows
SELECT 
    employee_id,
    COUNT(*) AS duplicate_count
FROM silver.employees
GROUP BY employee_id
HAVING COUNT(*) > 1;

-- Confirm that NULL reporting values were replaced with 0; expected: no rows
SELECT 
    employee_id,
    reports_to
FROM silver.employees
WHERE reports_to IS NULL;

-- Check for leading or trailing spaces; expected: no rows
SELECT 
    employee_id,
    employee_name,
    title,
    city,
    country,
    reports_to
FROM silver.employees
WHERE employee_name != TRIM(employee_name)
    OR title != TRIM(title)
    OR city != TRIM(city)
    OR country != TRIM(country);

-- Review standardized employee titles
SELECT DISTINCT
    title
FROM silver.employees;

-- Review standardized city values
SELECT DISTINCT
    city
FROM silver.employees;

-- Review standardized country values
SELECT DISTINCT
    country
FROM silver.employees;


-- =====================================================================
-- 4. order_details table
-- =====================================================================

-- Check for duplicate order-product combinations; expected: no rows
SELECT
    order_id,
    product_id,
    COUNT(*) AS duplicate_count
FROM silver.order_details
GROUP BY order_id, product_id
HAVING COUNT(*) > 1;


-- =====================================================================
-- 5. orders table
-- =====================================================================

-- Check for duplicate order IDs; expected: no rows
SELECT
    order_id,
    COUNT(*) AS duplicate_count
FROM silver.orders
GROUP BY order_id
HAVING COUNT(*) > 1;

-- Check required identifier columns for NULL values; expected: no rows
SELECT
    order_id,
    customer_id,
    employee_id
FROM silver.orders
WHERE order_id IS NULL
    OR customer_id IS NULL
    OR employee_id IS NULL;

-- Check for required or shipped dates earlier than the order date; expected: no rows
SELECT
    order_id,
    order_date,
    required_date,
    shipped_date
FROM silver.orders
WHERE required_date < order_date
    OR shipped_date < order_date;

-- Check required date columns for NULL values; expected: no rows
SELECT
    order_id,
    order_date,
    required_date,
    shipped_date
FROM silver.orders
WHERE order_date IS NULL
    OR required_date IS NULL;

-- Review orders that have not yet been shipped
SELECT
    order_id,
    order_date,
    shipped_date
FROM silver.orders
WHERE shipped_date IS NULL;

-- Check for missing shipper IDs; expected: no rows
SELECT
    order_id,
    shipper_id
FROM silver.orders
WHERE shipper_id IS NULL;


-- =====================================================================
-- 6. products table
-- =====================================================================

-- Check for duplicate product IDs; expected: no rows
SELECT
    product_id,
    COUNT(*) AS duplicate_count
FROM silver.products
GROUP BY product_id
HAVING COUNT(*) > 1;

-- Check for missing product IDs; expected: no rows
SELECT
    product_id
FROM silver.products
WHERE product_id IS NULL;

-- Check for leading or trailing spaces; expected: no rows
SELECT 
    product_id,
    product_name,
    quantity_per_unit
FROM silver.products
WHERE product_name != TRIM(product_name)
    OR quantity_per_unit != TRIM(quantity_per_unit);

-- Review values in the discontinued column
SELECT DISTINCT
    discontinued
FROM silver.products;


-- =====================================================================
-- 7. shippers table
-- =====================================================================

-- Check for leading or trailing spaces; expected: no rows
SELECT
    shipper_id,
    company_name
FROM silver.shippers
WHERE company_name != TRIM(company_name);