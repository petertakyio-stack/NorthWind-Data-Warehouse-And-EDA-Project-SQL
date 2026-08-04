/*
===============================================================================
Data Quality Checks: Gold Layer
===============================================================================
Purpose:
    Validates dimension uniqueness, fact-table grain, dimension relationships,
    measures, freight allocation, and record-count consistency.

Expected Results:
    Checks should return no rows unless otherwise stated.
===============================================================================
*/

-- ===================================================================
-- 1. Check dimension business keys for duplicates
-- Expected: No rows
-- ===================================================================
SELECT 'dim_customers' AS view_name, CAST(customer_id AS VARCHAR(255)) AS business_key, COUNT(*) AS duplicate_count
FROM gold.dim_customers GROUP BY customer_id HAVING COUNT(*) > 1
UNION ALL
SELECT 'dim_employees', CAST(employee_id AS VARCHAR(255)), COUNT(*)
FROM gold.dim_employees GROUP BY employee_id HAVING COUNT(*) > 1
UNION ALL
SELECT 'dim_shippers', CAST(shipper_id AS VARCHAR(255)), COUNT(*)
FROM gold.dim_shippers GROUP BY shipper_id HAVING COUNT(*) > 1
UNION ALL
SELECT 'dim_products', CAST(product_id AS VARCHAR(255)), COUNT(*)
FROM gold.dim_products GROUP BY product_id HAVING COUNT(*) > 1;

-- ===================================================================
-- 2. Check the fact-table grain
-- Expected: No rows
-- ===================================================================
SELECT order_id, product_key, COUNT(*) AS duplicate_count
FROM gold.fact_order_line
GROUP BY order_id, product_key
HAVING COUNT(*) > 1;

-- ===================================================================
-- 3. Check for missing dimension keys
-- Expected: No rows
-- ===================================================================
SELECT order_key, order_id, product_key, customer_key, employee_key, shipper_key
FROM gold.fact_order_line
WHERE product_key IS NULL OR customer_key IS NULL
   OR employee_key IS NULL OR shipper_key IS NULL;

-- ===================================================================
-- 4. Check for invalid fact values
-- Expected: No rows
-- ===================================================================
SELECT order_key, order_id, unit_price, quantity, discount, sales_amount, allocated_freight
FROM gold.fact_order_line
WHERE unit_price < 0 OR quantity <= 0 OR discount < 0 OR discount > 1
   OR sales_amount < 0 OR allocated_freight < 0;

-- ===================================================================
-- 5. Confirm the sales calculation
-- Expected: No rows
-- ===================================================================
SELECT order_key, order_id, sales_amount,
       CAST(unit_price * quantity * (1 - discount) AS DECIMAL(18, 2)) AS expected_sales_amount
FROM gold.fact_order_line
WHERE ABS(sales_amount - CAST(unit_price * quantity * (1 - discount) AS DECIMAL(18, 2))) > 0.01;

-- ===================================================================
-- 6. Confirm allocated freight equals the total freight per order
-- Expected: No rows; small differences may occur from rounding
-- ===================================================================
SELECT order_id, MAX(total_order_freight) AS total_order_freight,
       SUM(allocated_freight) AS total_allocated_freight,
       ABS(MAX(total_order_freight) - SUM(allocated_freight)) AS difference
FROM gold.fact_order_line
GROUP BY order_id
HAVING ABS(MAX(total_order_freight) - SUM(allocated_freight)) > 0.05;

-- ===================================================================
-- 7. Reconcile Silver and Gold record counts
-- Expected: Both counts should be equal
-- ===================================================================
SELECT
    (SELECT COUNT(*) FROM silver.order_details) AS silver_order_detail_count,
    (SELECT COUNT(*) FROM gold.fact_order_line) AS gold_fact_count;