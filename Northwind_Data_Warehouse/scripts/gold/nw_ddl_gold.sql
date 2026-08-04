-- ===============================================================================
-- Gold Layer
-- ===============================================================================

/*
==================================================================================
DDL Script: Create Gold Views
==================================================================================
Purpose:
    Creates dimension and fact views for the Gold layer using cleaned data from
    the Silver layer. The views form a star schema for reporting and analytics.

Important Notes:
    - Keys generated with ROW_NUMBER() are recalculated when the views are queried.
    - The fact view contains one row per order and product combination.
    - total_order_freight repeats across the product lines of an order; use
      allocated_freight when calculating total freight from the fact view.

Usage:
    Query these views directly for analysis and reporting.
==================================================================================
*/

-- -------------------------------------------------------------------------------
-- Dimension View: gold.dim_customers
-- Grain: One row per customer
-- -------------------------------------------------------------------------------
IF OBJECT_ID('gold.dim_customers', 'V') IS NOT NULL
    DROP VIEW gold.dim_customers;
GO

CREATE VIEW gold.dim_customers AS
SELECT
    ROW_NUMBER() OVER (ORDER BY customer_id) AS customer_key, -- Dynamically generated customer key.
    customer_id,
    company_name,
    contact_name,
    contact_title,
    city,
    country
FROM silver.customers;
GO

-- -------------------------------------------------------------------------------
-- Dimension View: gold.dim_employees
-- Grain: One row per employee
-- -------------------------------------------------------------------------------
IF OBJECT_ID('gold.dim_employees', 'V') IS NOT NULL
    DROP VIEW gold.dim_employees;
GO

CREATE VIEW gold.dim_employees AS
SELECT
    ROW_NUMBER() OVER (ORDER BY e.employee_id) AS employee_key, -- Dynamically generated employee key.
    e.employee_id,
    e.employee_name,
    e.title AS employee_title,
    e.city AS employee_city,
    e.country AS employee_country,
    e.reports_to AS manager_id,
    COALESCE(m.employee_name, 'None') AS manager_name,
    COALESCE(m.title, 'None') AS manager_title
FROM silver.employees AS e
LEFT JOIN silver.employees AS m
    ON e.reports_to = m.employee_id; -- Self-join used to retrieve each employee's manager details.
GO

-- -------------------------------------------------------------------------------
-- Dimension View: gold.dim_shippers
-- Grain: One row per shipper
-- -------------------------------------------------------------------------------
IF OBJECT_ID('gold.dim_shippers', 'V') IS NOT NULL
    DROP VIEW gold.dim_shippers;
GO

CREATE VIEW gold.dim_shippers AS
SELECT
    ROW_NUMBER() OVER (ORDER BY shipper_id) AS shipper_key, -- Dynamically generated shipper key.
    shipper_id,
    company_name
FROM silver.shippers;
GO

-- -------------------------------------------------------------------------------
-- Dimension View: gold.dim_products
-- Grain: One row per product
-- -------------------------------------------------------------------------------
IF OBJECT_ID('gold.dim_products', 'V') IS NOT NULL
    DROP VIEW gold.dim_products;
GO

CREATE VIEW gold.dim_products AS
SELECT
    ROW_NUMBER() OVER (ORDER BY p.product_id) AS product_key, -- Dynamically generated product key.
    p.product_id,
    p.product_name,
    p.quantity_per_unit,
    p.unit_price,
    p.discontinued,
    p.category_id,
    c.category_name,
    c.cat_description AS category_description
FROM silver.products AS p
LEFT JOIN silver.categories AS c
    ON p.category_id = c.category_id; -- Adds category details to each product.
GO

-- -------------------------------------------------------------------
-- Creating Fact View: gold.fact_order_line
-- Grain: One row per order and product combination
-- -------------------------------------------------------------------
IF OBJECT_ID('gold.fact_order_line', 'V') IS NOT NULL
    DROP VIEW gold.fact_order_line;
GO

CREATE VIEW gold.fact_order_line AS
-- Calculate line-level sales before allocating freight and linking dimensions.
WITH order_lines AS (
    SELECT
        ROW_NUMBER() OVER (ORDER BY o.order_id, od.product_id) AS order_key,
        o.order_id,
        od.product_id,
        o.customer_id,
        o.employee_id,
        o.shipper_id,
        o.order_date,
        o.required_date,
        o.shipped_date,
        CASE
            WHEN o.shipped_date < o.required_date THEN 'Shipped Early'
            WHEN o.shipped_date > o.required_date THEN 'Shipping Delayed'
            WHEN o.shipped_date = o.required_date THEN 'Shipped on Time'
            ELSE 'N/A'
        END AS shipping_timeline,
        od.unit_price,
        od.quantity,
        od.discount,
        CAST(od.unit_price * od.quantity * (1 - od.discount) AS DECIMAL(18, 2)) AS sales_amount,
        o.freight AS total_order_freight
    FROM silver.orders AS o
    INNER JOIN silver.order_details AS od
        ON o.order_id = od.order_id
)
SELECT
    ol.order_key,
    ol.order_id,
    p.product_key,
    c.customer_key,
    e.employee_key,
    s.shipper_key,
    ol.order_date,
    ol.required_date,
    ol.shipped_date,
    ol.shipping_timeline,
    ol.unit_price,
    ol.quantity,
    ol.discount,
    ol.sales_amount,
    ol.total_order_freight,
    -- Allocate freight based on each product line's share of total order sales.
    CAST(
    CASE
        WHEN SUM(ol.sales_amount) OVER (PARTITION BY ol.order_id) > 0
            THEN ol.total_order_freight * ol.sales_amount / SUM(ol.sales_amount) OVER (PARTITION BY ol.order_id)
        ELSE ol.total_order_freight / COUNT(*) OVER (PARTITION BY ol.order_id)
    END AS DECIMAL(12, 2)
    ) AS allocated_freight
FROM order_lines AS ol
LEFT JOIN gold.dim_products AS p
    ON ol.product_id = p.product_id
LEFT JOIN gold.dim_customers AS c
    ON ol.customer_id = c.customer_id
LEFT JOIN gold.dim_employees AS e
    ON ol.employee_id = e.employee_id
LEFT JOIN gold.dim_shippers AS s
    ON ol.shipper_id = s.shipper_id;
GO