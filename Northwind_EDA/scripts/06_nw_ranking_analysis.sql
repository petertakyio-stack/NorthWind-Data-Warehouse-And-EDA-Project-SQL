/*
===============================================================================
Ranking Analysis
===============================================================================
Purpose:
    - Rank products, employees, customers and shippers by key performance metrics.
    - Identify top performers and lowest performers.

SQL Functions Used:
    - ROW_NUMBER()
    - TOP
    - SUM()
    - COUNT(DISTINCT)
    - GROUP BY
    - ORDER BY
===============================================================================
*/

-- Top 5 products by sales
SELECT TOP 5
    product_name,
    total_sales,
    ROW_NUMBER() OVER (ORDER BY total_sales DESC) AS rank
FROM (
    SELECT
        p.product_name,
        CAST(SUM(o.sales_amount) AS DECIMAL(18,2)) AS total_sales
    FROM gold.fact_order_line o
    LEFT JOIN gold.dim_products p
        ON o.product_key = p.product_key
    GROUP BY p.product_name
) t
ORDER BY total_sales DESC;

-- Bottom 5 products by sales
SELECT TOP 5
    product_name,
    total_sales,
    ROW_NUMBER() OVER (ORDER BY total_sales ASC) AS rank
FROM (
    SELECT
        p.product_name,
        CAST(SUM(o.sales_amount) AS DECIMAL(18,2)) AS total_sales
    FROM gold.fact_order_line o
    LEFT JOIN gold.dim_products p
        ON o.product_key = p.product_key
    GROUP BY p.product_name
) t
ORDER BY total_sales ASC;

-- Top 3 product categories by sales
SELECT TOP 3
    category_name,
    total_sales,
    ROW_NUMBER() OVER (ORDER BY total_sales DESC) AS rank
FROM (
    SELECT
        p.category_name,
        CAST(SUM(o.sales_amount) AS DECIMAL(18,2)) AS total_sales
    FROM gold.fact_order_line o
    LEFT JOIN gold.dim_products p
        ON o.product_key = p.product_key
    GROUP BY p.category_name
) t
ORDER BY total_sales DESC;

-- Bottom 3 product categories by sales
SELECT TOP 3
    category_name,
    total_sales,
    ROW_NUMBER() OVER (ORDER BY total_sales ASC) AS rank
FROM (
    SELECT
        p.category_name,
        CAST(SUM(o.sales_amount) AS DECIMAL(18,2)) AS total_sales
    FROM gold.fact_order_line o
    LEFT JOIN gold.dim_products p
        ON o.product_key = p.product_key
    GROUP BY p.category_name
) t
ORDER BY total_sales ASC;

-- Top 3 employees by sales
SELECT TOP 3
    employee_name,
    total_sales,
    ROW_NUMBER() OVER (ORDER BY total_sales DESC) AS rank
FROM (
    SELECT
        e.employee_name,
        CAST(SUM(o.sales_amount) AS DECIMAL(18,2)) AS total_sales
    FROM gold.fact_order_line o
    LEFT JOIN gold.dim_employees e
        ON o.employee_key = e.employee_key
    GROUP BY e.employee_name
) t
ORDER BY total_sales DESC;

-- Bottom 3 employees by sales
SELECT TOP 3
    employee_name,
    total_sales,
    ROW_NUMBER() OVER (ORDER BY total_sales ASC) AS rank
FROM (
    SELECT
        e.employee_name,
        CAST(SUM(o.sales_amount) AS DECIMAL(18,2)) AS total_sales
    FROM gold.fact_order_line o
    LEFT JOIN gold.dim_employees e
        ON o.employee_key = e.employee_key
    GROUP BY e.employee_name
) t
ORDER BY total_sales ASC;

-- Top 3 employees by quantity sold
SELECT TOP 3
    employee_name,
    total_items_sold,
    ROW_NUMBER() OVER (ORDER BY total_items_sold DESC) AS rank
FROM (
    SELECT
        e.employee_name,
        SUM(o.quantity) AS total_items_sold
    FROM gold.fact_order_line o
    LEFT JOIN gold.dim_employees e
        ON o.employee_key = e.employee_key
    GROUP BY e.employee_name
) t
ORDER BY total_items_sold DESC;

-- Bottom 3 employees by quantity sold
SELECT TOP 3
    employee_name,
    total_items_sold,
    ROW_NUMBER() OVER (ORDER BY total_items_sold ASC) AS rank
FROM (
    SELECT
        e.employee_name,
        SUM(o.quantity) AS total_items_sold
    FROM gold.fact_order_line o
    LEFT JOIN gold.dim_employees e
        ON o.employee_key = e.employee_key
    GROUP BY e.employee_name
) t
ORDER BY total_items_sold ASC;

-- Top 3 employees by unique orders processed
SELECT TOP 3
    employee_name,
    total_orders_processed,
    ROW_NUMBER() OVER (ORDER BY total_orders_processed DESC) AS rank
FROM (
    SELECT
        e.employee_name,
        COUNT(DISTINCT o.order_id) AS total_orders_processed
    FROM gold.fact_order_line o
    LEFT JOIN gold.dim_employees e
        ON o.employee_key = e.employee_key
    GROUP BY e.employee_name
) t
ORDER BY total_orders_processed DESC;

-- Bottom 3 employees by unique orders processed
SELECT TOP 3
    employee_name,
    total_orders_processed,
    ROW_NUMBER() OVER (ORDER BY total_orders_processed ASC) AS rank
FROM (
    SELECT
        e.employee_name,
        COUNT(DISTINCT o.order_id) AS total_orders_processed
    FROM gold.fact_order_line o
    LEFT JOIN gold.dim_employees e
        ON o.employee_key = e.employee_key
    GROUP BY e.employee_name
) t
ORDER BY total_orders_processed ASC;

-- Top 5 customers by sales
SELECT TOP 5
    company_name,
    total_sales,
    ROW_NUMBER() OVER (ORDER BY total_sales DESC) AS rank
FROM (
    SELECT
        c.company_name,
        CAST(SUM(o.sales_amount) AS DECIMAL(18,2)) AS total_sales
    FROM gold.fact_order_line o
    LEFT JOIN gold.dim_customers c
        ON o.customer_key = c.customer_key
    GROUP BY c.company_name
) t
ORDER BY total_sales DESC;

-- Bottom 5 customers by sales
SELECT TOP 5
    company_name,
    total_sales,
    ROW_NUMBER() OVER (ORDER BY total_sales ASC) AS rank
FROM (
    SELECT
        c.company_name,
        CAST(SUM(o.sales_amount) AS DECIMAL(18,2)) AS total_sales
    FROM gold.fact_order_line o
    LEFT JOIN gold.dim_customers c
        ON o.customer_key = c.customer_key
    GROUP BY c.company_name
) t
ORDER BY total_sales ASC;

-- Top 5 customer countries by sales
SELECT TOP 5
    country,
    total_sales,
    ROW_NUMBER() OVER (ORDER BY total_sales DESC) AS rank
FROM (
    SELECT
        c.country,
        CAST(SUM(o.sales_amount) AS DECIMAL(18,2)) AS total_sales
    FROM gold.fact_order_line o
    LEFT JOIN gold.dim_customers c
        ON o.customer_key = c.customer_key
    GROUP BY c.country
) t
ORDER BY total_sales DESC;

-- Bottom 5 customer countries by sales
SELECT TOP 5
    country,
    total_sales,
    ROW_NUMBER() OVER (ORDER BY total_sales ASC) AS rank
FROM (
    SELECT
        c.country,
        CAST(SUM(o.sales_amount) AS DECIMAL(18,2)) AS total_sales
    FROM gold.fact_order_line o
    LEFT JOIN gold.dim_customers c
        ON o.customer_key = c.customer_key
    GROUP BY c.country
) t
ORDER BY total_sales ASC;

-- Top 5 customer locations by sales
SELECT TOP 5
    country,
    city,
    total_sales,
    ROW_NUMBER() OVER (ORDER BY total_sales DESC) AS rank
FROM (
    SELECT
        c.country,
        c.city,
        CAST(SUM(o.sales_amount) AS DECIMAL(18,2)) AS total_sales
    FROM gold.fact_order_line o
    LEFT JOIN gold.dim_customers c
        ON o.customer_key = c.customer_key
    GROUP BY c.country, c.city
) t
ORDER BY total_sales DESC;

-- Bottom 5 customer locations by sales
SELECT TOP 5
    country,
    city,
    total_sales,
    ROW_NUMBER() OVER (ORDER BY total_sales ASC) AS rank
FROM (
    SELECT
        c.country,
        c.city,
        CAST(SUM(o.sales_amount) AS DECIMAL(18,2)) AS total_sales
    FROM gold.fact_order_line o
    LEFT JOIN gold.dim_customers c
        ON o.customer_key = c.customer_key
    GROUP BY c.country, c.city
) t
ORDER BY total_sales ASC;

-- Top shipping company by sales
SELECT TOP 1
    company_name,
    total_sales,
    ROW_NUMBER() OVER (ORDER BY total_sales DESC) AS rank
FROM (
    SELECT
        s.company_name,
        CAST(SUM(o.sales_amount) AS DECIMAL(18,2)) AS total_sales
    FROM gold.fact_order_line o
    LEFT JOIN gold.dim_shippers s
        ON o.shipper_key = s.shipper_key
    GROUP BY s.company_name
) t
ORDER BY total_sales DESC;

-- Bottom shipping company by sales
SELECT TOP 1
    company_name,
    total_sales,
    ROW_NUMBER() OVER (ORDER BY total_sales ASC) AS rank
FROM (
    SELECT
        s.company_name,
        CAST(SUM(o.sales_amount) AS DECIMAL(18,2)) AS total_sales
    FROM gold.fact_order_line o
    LEFT JOIN gold.dim_shippers s
        ON o.shipper_key = s.shipper_key
    GROUP BY s.company_name
) t
ORDER BY total_sales ASC;

-- Top shipping company by unique orders processed
SELECT TOP 1
    company_name,
    total_unique_orders_processed,
    ROW_NUMBER() OVER (ORDER BY total_unique_orders_processed DESC) AS rank
FROM (
    SELECT
        s.company_name,
        COUNT(DISTINCT o.order_id) AS total_unique_orders_processed
    FROM gold.fact_order_line o
    LEFT JOIN gold.dim_shippers s
        ON o.shipper_key = s.shipper_key
    GROUP BY s.company_name
) t
ORDER BY total_unique_orders_processed DESC;

-- Bottom shipping company by unique orders processed
SELECT TOP 1
    company_name,
    total_unique_orders_processed,
    ROW_NUMBER() OVER (ORDER BY total_unique_orders_processed ASC) AS rank
FROM (
    SELECT
        s.company_name,
        COUNT(DISTINCT o.order_id) AS total_unique_orders_processed
    FROM gold.fact_order_line o
    LEFT JOIN gold.dim_shippers s
        ON o.shipper_key = s.shipper_key
    GROUP BY s.company_name
) t
ORDER BY total_unique_orders_processed ASC;

-- Rank shipping companies by total quantity shipped
SELECT
    company_name,
    total_quantity_shipped,
    ROW_NUMBER() OVER (ORDER BY total_quantity_shipped DESC) AS rank
FROM (
    SELECT
        s.company_name,
        SUM(o.quantity) AS total_quantity_shipped
    FROM gold.fact_order_line o
    LEFT JOIN gold.dim_shippers s
        ON o.shipper_key = s.shipper_key
    GROUP BY s.company_name
) t
ORDER BY total_quantity_shipped DESC;