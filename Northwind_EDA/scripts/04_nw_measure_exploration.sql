/*
===============================================================================
Measures Exploration (Key Metrics)
===============================================================================
Purpose:
    - To calculate aggregated metrics (e.g., totals, averages) for quick insights.
    - To identify overall trends or spot anomalies.

SQL Functions Used:
    - COUNT(), SUM(), AVG()
===============================================================================
*/

-- total order lines
SELECT
    COUNT(*) AS total_order_lines
FROM gold.fact_order_line;

-- total order
SELECT
    COUNT(DISTINCT order_id) AS total_orders
FROM gold.fact_order_line;

-- total sales_amount
SELECT
    CAST(SUM(sales_amount) AS DECIMAL(18,2)) AS total_sales
FROM gold.fact_order_line;

-- total product categories
SELECT
    COUNT(DISTINCT category_name) AS total_product_categories
FROM gold.dim_products;

-- total employees
SELECT
    COUNT(DISTINCT employee_key) AS total_employees
FROM gold.dim_employees;

-- total shipping companies
SELECT
    COUNT(DISTINCT shipper_key) AS total_shippers
FROM gold.dim_shippers;

-- average order value (average sales per order)
SELECT
    CAST(AVG(sales_amount) AS DECIMAL(18,2)) AS average_order_value
FROM gold.fact_order_line;

-- units sold (total quantity of products sold)
SELECT
    SUM(quantity) AS units_sold
FROM gold.fact_order_line;

-- average discount
SELECT
    CONCAT(CAST(AVG(discount) AS DECIMAL (3,2)) * 100, '%') AS overall_average_discount
FROM gold.fact_order_line;

-- total freight cost
SELECT
    SUM (allocated_freight) AS total_freight
FROM gold.fact_order_line;

-- average allocated freight cost
SELECT
    CAST(AVG (allocated_freight) AS DECIMAL (18,2)) AS average_product_freight
FROM gold.fact_order_line;

-- on time shipping rate (% of orders shipped on or before the required date). Note: N/As were not included in denominator
SELECT
    CAST(100.00 * 
        (COUNT
            (DISTINCT CASE 
                WHEN shipping_timeline IN ('Shipped on Time', 'Shipped Early') THEN order_id 
            END)) 
        / NULLIF(COUNT
            (DISTINCT CASE 
                WHEN shipping_timeline <> 'N/A' THEN order_id 
            END), 0) 
    AS DECIMAL(5,2)) AS on_time_shipping_rate
FROM gold.fact_order_line;

-- delayed orders (number of orders shipped after the required date)
SELECT
    CAST(100.00 * 
        (COUNT
            (DISTINCT CASE 
                WHEN shipping_timeline = 'Shipping Delayed' THEN order_id 
            END)) 
        / NULLIF(COUNT
            (DISTINCT CASE 
                WHEN shipping_timeline <> 'N/A' THEN order_id 
            END), 0) 
    AS DECIMAL(5,2)) AS delayed_shipping_rate
FROM gold.fact_order_line;


-- --------------------------------------------------------------
-- Generate a Report that showls all key measures of business
-- --------------------------------------------------------------

SELECT 'Total Order Lines' AS measure_name, COUNT(*) AS measure_value FROM gold.fact_order_line
UNION ALL
SELECT 'Total Unique Orders', COUNT(DISTINCT order_id) FROM gold.fact_order_line
UNION ALL
SELECT 'Total Sales Amount (USD)', CAST(SUM(sales_amount) AS DECIMAL(18,2)) FROM gold.fact_order_line
UNION ALL
SELECT 'Total Product Categories', COUNT(DISTINCT category_name) FROM gold.dim_products
UNION ALL
SELECT 'Total Number of Employees', COUNT(DISTINCT employee_key) FROM gold.dim_employees
UNION ALL
SELECT 'Total Number of Shippers', COUNT(DISTINCT shipper_key) FROM gold.dim_shippers
UNION ALL
SELECT 'Average Ordre Value (USD)', CAST(AVG(sales_amount) AS DECIMAL(18,2)) FROM gold.fact_order_line
UNION ALL
SELECT 'Units Sold', SUM(quantity) FROM gold.fact_order_line
UNION ALL
SELECT 'Overall Average Discount (%)', CAST(AVG(discount) AS DECIMAL (3,2)) * 100 FROM gold.fact_order_line
UNION ALL
SELECT 'Total Freight Cost (USD)', SUM (allocated_freight) FROM gold.fact_order_line
UNION ALL
SELECT 'Average Product Freight Cost (USD)', CAST(AVG (allocated_freight) AS DECIMAL (18,2)) FROM gold.fact_order_line
UNION ALL
SELECT 'Total Unique Order Shipped',
    COUNT
        (DISTINCT CASE 
            WHEN shipping_timeline <> 'N/A' THEN order_id 
        END)
FROM gold.fact_order_line
UNION ALL
SELECT 'Total On-Time Shipping',
        (COUNT
            (DISTINCT CASE 
                WHEN shipping_timeline IN ('Shipped on Time', 'Shipped Early') THEN order_id 
            END))
FROM gold.fact_order_line
UNION ALL
SELECT 'On-Time Shipping Rate (%)',
    CAST(100.00 * 
        (COUNT
            (DISTINCT CASE 
                WHEN shipping_timeline IN ('Shipped on Time', 'Shipped Early') THEN order_id 
            END)) 
        / NULLIF(COUNT
            (DISTINCT CASE 
                WHEN shipping_timeline <> 'N/A' THEN order_id 
            END), 0) 
    AS DECIMAL(5,2)) 
FROM gold.fact_order_line
UNION ALL
SELECT 'Total Delayed Shipping',
    (COUNT
        (DISTINCT CASE 
            WHEN shipping_timeline = 'Shipping Delayed' THEN order_id 
        END))
FROM gold.fact_order_line 
UNION ALL
SELECT 'Delayed Shipping Rate (%)',
    CAST(100.00 * 
        (COUNT
            (DISTINCT CASE 
                WHEN shipping_timeline = 'Shipping Delayed' THEN order_id 
            END)) 
        / NULLIF(COUNT
            (DISTINCT CASE 
                WHEN shipping_timeline <> 'N/A' THEN order_id 
            END), 0) 
    AS DECIMAL(5,2)) 
FROM gold.fact_order_line;


