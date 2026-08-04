/*
===============================================================================
Dimensions Exploration
===============================================================================
Purpose:
    - Explore key attributes in dimension and fact tables.
    - Identify unique values and category combinations.

SQL Functions Used:
    - DISTINCT
    - ORDER BY
===============================================================================
*/

-- Explore customer countries
SELECT DISTINCT country
FROM gold.dim_customers;
GO

-- Explore product status
SELECT DISTINCT discontinued
FROM gold.dim_products;

-- Explore product categories
SELECT DISTINCT category_name
FROM gold.dim_products;

-- Explore products within each category
SELECT DISTINCT
    category_name,
    product_name
FROM gold.dim_products
ORDER BY category_name, product_name;

-- Explore employee countries
SELECT DISTINCT employee_country
FROM gold.dim_employees;

-- Explore shipping timeline categories
SELECT DISTINCT shipping_timeline
FROM gold.fact_order_line;