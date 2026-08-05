/*
===============================================================================
Ranking Analysis Report
===============================================================================
Purpose:
    - Combine product, employee, customer and shipper rankings.
    - Present all results in one structured report.
===============================================================================
*/

WITH product_sales AS (
    SELECT
        p.product_name AS entity_name,
        CAST(SUM(o.sales_amount) AS DECIMAL(18,2)) AS metric_value,
        ROW_NUMBER() OVER (ORDER BY SUM(o.sales_amount) DESC) AS top_rank,
        ROW_NUMBER() OVER (ORDER BY SUM(o.sales_amount) ASC) AS bottom_rank
    FROM gold.fact_order_line o
    LEFT JOIN gold.dim_products p ON o.product_key = p.product_key
    GROUP BY p.product_name
),
category_sales AS (
    SELECT
        p.category_name AS entity_name,
        CAST(SUM(o.sales_amount) AS DECIMAL(18,2)) AS metric_value,
        ROW_NUMBER() OVER (ORDER BY SUM(o.sales_amount) DESC) AS top_rank,
        ROW_NUMBER() OVER (ORDER BY SUM(o.sales_amount) ASC) AS bottom_rank
    FROM gold.fact_order_line o
    LEFT JOIN gold.dim_products p ON o.product_key = p.product_key
    GROUP BY p.category_name
),
employee_sales AS (
    SELECT
        e.employee_name AS entity_name,
        CAST(SUM(o.sales_amount) AS DECIMAL(18,2)) AS metric_value,
        ROW_NUMBER() OVER (ORDER BY SUM(o.sales_amount) DESC) AS top_rank,
        ROW_NUMBER() OVER (ORDER BY SUM(o.sales_amount) ASC) AS bottom_rank
    FROM gold.fact_order_line o
    LEFT JOIN gold.dim_employees e ON o.employee_key = e.employee_key
    GROUP BY e.employee_name
),
employee_quantity AS (
    SELECT
        e.employee_name AS entity_name,
        CAST(SUM(o.quantity) AS DECIMAL(18,2)) AS metric_value,
        ROW_NUMBER() OVER (ORDER BY SUM(o.quantity) DESC) AS top_rank,
        ROW_NUMBER() OVER (ORDER BY SUM(o.quantity) ASC) AS bottom_rank
    FROM gold.fact_order_line o
    LEFT JOIN gold.dim_employees e ON o.employee_key = e.employee_key
    GROUP BY e.employee_name
),
employee_orders AS (
    SELECT
        e.employee_name AS entity_name,
        CAST(COUNT(DISTINCT o.order_id) AS DECIMAL(18,2)) AS metric_value,
        ROW_NUMBER() OVER (ORDER BY COUNT(DISTINCT o.order_id) DESC) AS top_rank,
        ROW_NUMBER() OVER (ORDER BY COUNT(DISTINCT o.order_id) ASC) AS bottom_rank
    FROM gold.fact_order_line o
    LEFT JOIN gold.dim_employees e ON o.employee_key = e.employee_key
    GROUP BY e.employee_name
),
customer_sales AS (
    SELECT
        c.company_name AS entity_name,
        CAST(SUM(o.sales_amount) AS DECIMAL(18,2)) AS metric_value,
        ROW_NUMBER() OVER (ORDER BY SUM(o.sales_amount) DESC) AS top_rank,
        ROW_NUMBER() OVER (ORDER BY SUM(o.sales_amount) ASC) AS bottom_rank
    FROM gold.fact_order_line o
    LEFT JOIN gold.dim_customers c ON o.customer_key = c.customer_key
    GROUP BY c.company_name
),
country_sales AS (
    SELECT
        c.country AS entity_name,
        CAST(SUM(o.sales_amount) AS DECIMAL(18,2)) AS metric_value,
        ROW_NUMBER() OVER (ORDER BY SUM(o.sales_amount) DESC) AS top_rank,
        ROW_NUMBER() OVER (ORDER BY SUM(o.sales_amount) ASC) AS bottom_rank
    FROM gold.fact_order_line o
    LEFT JOIN gold.dim_customers c ON o.customer_key = c.customer_key
    GROUP BY c.country
),
location_sales AS (
    SELECT
        CONCAT(c.country, ', ', c.city) AS entity_name,
        CAST(SUM(o.sales_amount) AS DECIMAL(18,2)) AS metric_value,
        ROW_NUMBER() OVER (ORDER BY SUM(o.sales_amount) DESC) AS top_rank,
        ROW_NUMBER() OVER (ORDER BY SUM(o.sales_amount) ASC) AS bottom_rank
    FROM gold.fact_order_line o
    LEFT JOIN gold.dim_customers c ON o.customer_key = c.customer_key
    GROUP BY c.country, c.city
),
shipper_sales AS (
    SELECT
        s.company_name AS entity_name,
        CAST(SUM(o.sales_amount) AS DECIMAL(18,2)) AS metric_value,
        ROW_NUMBER() OVER (ORDER BY SUM(o.sales_amount) DESC) AS top_rank,
        ROW_NUMBER() OVER (ORDER BY SUM(o.sales_amount) ASC) AS bottom_rank
    FROM gold.fact_order_line o
    LEFT JOIN gold.dim_shippers s ON o.shipper_key = s.shipper_key
    GROUP BY s.company_name
),
shipper_orders AS (
    SELECT
        s.company_name AS entity_name,
        CAST(COUNT(DISTINCT o.order_id) AS DECIMAL(18,2)) AS metric_value,
        ROW_NUMBER() OVER (ORDER BY COUNT(DISTINCT o.order_id) DESC) AS top_rank,
        ROW_NUMBER() OVER (ORDER BY COUNT(DISTINCT o.order_id) ASC) AS bottom_rank
    FROM gold.fact_order_line o
    LEFT JOIN gold.dim_shippers s ON o.shipper_key = s.shipper_key
    GROUP BY s.company_name
),
shipper_quantity AS (
    SELECT
        s.company_name AS entity_name,
        CAST(SUM(o.quantity) AS DECIMAL(18,2)) AS metric_value,
        ROW_NUMBER() OVER (ORDER BY SUM(o.quantity) DESC) AS rank_position
    FROM gold.fact_order_line o
    LEFT JOIN gold.dim_shippers s ON o.shipper_key = s.shipper_key
    GROUP BY s.company_name
)

-- Combine and arrange all ranking results
, ranking_report AS (
    SELECT 1 AS measure_order, 1 AS result_order,
        'Top 5 Products by Sales' AS ranking_category,
        entity_name, metric_value, top_rank AS rank_position
    FROM product_sales
    WHERE top_rank <= 5

    UNION ALL
    SELECT 1, 2, 'Bottom 5 Products by Sales',
        entity_name, metric_value, bottom_rank
    FROM product_sales
    WHERE bottom_rank <= 5

    UNION ALL
    SELECT 2, 1, 'Top 3 Categories by Sales',
        entity_name, metric_value, top_rank
    FROM category_sales
    WHERE top_rank <= 3

    UNION ALL
    SELECT 2, 2, 'Bottom 3 Categories by Sales',
        entity_name, metric_value, bottom_rank
    FROM category_sales
    WHERE bottom_rank <= 3

    UNION ALL
    SELECT 3, 1, 'Top 3 Employees by Sales',
        entity_name, metric_value, top_rank
    FROM employee_sales
    WHERE top_rank <= 3

    UNION ALL
    SELECT 3, 2, 'Bottom 3 Employees by Sales',
        entity_name, metric_value, bottom_rank
    FROM employee_sales
    WHERE bottom_rank <= 3

    UNION ALL
    SELECT 4, 1, 'Top 3 Employees by Quantity Sold',
        entity_name, metric_value, top_rank
    FROM employee_quantity
    WHERE top_rank <= 3

    UNION ALL
    SELECT 4, 2, 'Bottom 3 Employees by Quantity Sold',
        entity_name, metric_value, bottom_rank
    FROM employee_quantity
    WHERE bottom_rank <= 3

    UNION ALL
    SELECT 5, 1, 'Top 3 Employees by Orders Processed',
        entity_name, metric_value, top_rank
    FROM employee_orders
    WHERE top_rank <= 3

    UNION ALL
    SELECT 5, 2, 'Bottom 3 Employees by Orders Processed',
        entity_name, metric_value, bottom_rank
    FROM employee_orders
    WHERE bottom_rank <= 3

    UNION ALL
    SELECT 6, 1, 'Top 5 Customers by Sales',
        entity_name, metric_value, top_rank
    FROM customer_sales
    WHERE top_rank <= 5

    UNION ALL
    SELECT 6, 2, 'Bottom 5 Customers by Sales',
        entity_name, metric_value, bottom_rank
    FROM customer_sales
    WHERE bottom_rank <= 5

    UNION ALL
    SELECT 7, 1, 'Top 5 Countries by Sales',
        entity_name, metric_value, top_rank
    FROM country_sales
    WHERE top_rank <= 5

    UNION ALL
    SELECT 7, 2, 'Bottom 5 Countries by Sales',
        entity_name, metric_value, bottom_rank
    FROM country_sales
    WHERE bottom_rank <= 5

    UNION ALL
    SELECT 8, 1, 'Top 5 Locations by Sales',
        entity_name, metric_value, top_rank
    FROM location_sales
    WHERE top_rank <= 5

    UNION ALL
    SELECT 8, 2, 'Bottom 5 Locations by Sales',
        entity_name, metric_value, bottom_rank
    FROM location_sales
    WHERE bottom_rank <= 5

    UNION ALL
    SELECT 9, 1, 'Top Shipper by Sales',
        entity_name, metric_value, top_rank
    FROM shipper_sales
    WHERE top_rank = 1

    UNION ALL
    SELECT 9, 2, 'Bottom Shipper by Sales',
        entity_name, metric_value, bottom_rank
    FROM shipper_sales
    WHERE bottom_rank = 1

    UNION ALL
    SELECT 10, 1, 'Top Shipper by Orders Processed',
        entity_name, metric_value, top_rank
    FROM shipper_orders
    WHERE top_rank = 1

    UNION ALL
    SELECT 10, 2, 'Bottom Shipper by Orders Processed',
        entity_name, metric_value, bottom_rank
    FROM shipper_orders
    WHERE bottom_rank = 1

    UNION ALL
    SELECT 11, 1, 'Shipper Ranking by Quantity Shipped',
        entity_name, metric_value, rank_position
    FROM shipper_quantity
)

SELECT
    ranking_category,
    entity_name,
    metric_value,
    rank_position
FROM ranking_report
ORDER BY measure_order, result_order, rank_position;