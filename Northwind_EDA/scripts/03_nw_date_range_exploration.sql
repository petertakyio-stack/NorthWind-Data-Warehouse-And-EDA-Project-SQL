/*
===============================================================================
Date Range Exploration
===============================================================================
Purpose:
    - Determine the earliest and latest dates in the order data.
    - Measure the historical coverage of each date field.
    - Summarise date boundaries and historical coverage.
    - Display all results in a two-column report.

SQL Functions Used:
    - MIN()
    - MAX()
    - DATEDIFF()
===============================================================================
*/

-- Calculate all date measures once using CTEs
WITH date_measures AS (
    SELECT
        MIN(order_date) AS first_order_date,
        MAX(order_date) AS last_order_date,
        DATEDIFF(year, MIN(order_date), MAX(order_date)) AS order_year_range,
        DATEDIFF(month, MIN(order_date), MAX(order_date)) AS order_month_range,
        MIN(required_date) AS first_required_date,
        MAX(required_date) AS last_required_date,
        DATEDIFF(year, MIN(required_date), MAX(required_date)) AS required_year_range,
        DATEDIFF(month, MIN(required_date), MAX(required_date)) AS required_month_range,
        MIN(shipped_date) AS first_shipped_date,
        MAX(shipped_date) AS last_shipped_date,
        DATEDIFF(year, MIN(shipped_date), MAX(shipped_date)) AS shipped_year_range,
        DATEDIFF(month, MIN(shipped_date), MAX(shipped_date)) AS shipped_month_range
    FROM gold.fact_order_line
)

-- Convert date measures into a two-column report
SELECT 'First Order Date' AS date_measure_name,
       CONVERT(VARCHAR(10), first_order_date, 23) AS date_measure_value
FROM date_measures

UNION ALL
SELECT 'Last Order Date', CONVERT(VARCHAR(10), last_order_date, 23)
FROM date_measures

UNION ALL
SELECT 'Order Year Range', CAST(order_year_range AS VARCHAR(10))
FROM date_measures

UNION ALL
SELECT 'Order Month Range', CAST(order_month_range AS VARCHAR(10))
FROM date_measures

UNION ALL
SELECT 'First Required Date', CONVERT(VARCHAR(10), first_required_date, 23)
FROM date_measures

UNION ALL
SELECT 'Last Required Date', CONVERT(VARCHAR(10), last_required_date, 23)
FROM date_measures

UNION ALL
SELECT 'Required Year Range', CAST(required_year_range AS VARCHAR(10))
FROM date_measures

UNION ALL
SELECT 'Required Month Range', CAST(required_month_range AS VARCHAR(10))
FROM date_measures

UNION ALL
SELECT 'First Shipped Date', CONVERT(VARCHAR(10), first_shipped_date, 23)
FROM date_measures

UNION ALL
SELECT 'Last Shipped Date', CONVERT(VARCHAR(10), last_shipped_date, 23)
FROM date_measures

UNION ALL
SELECT 'Shipped Year Range', CAST(shipped_year_range AS VARCHAR(10))
FROM date_measures

UNION ALL
SELECT 'Shipped Month Range', CAST(shipped_month_range AS VARCHAR(10))
FROM date_measures;