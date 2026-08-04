/*
===============================================================================
Date Range Exploration
===============================================================================
Purpose:
    - Determine the earliest and latest dates in the order data.
    - Measure the historical coverage of each date field.

SQL Functions Used:
    - MIN()
    - MAX()
    - DATEDIFF()
===============================================================================
*/

-- Explore order date boundaries and coverage
SELECT
    MIN(order_date) AS first_order_date,
    MAX(order_date) AS last_order_date,
    DATEDIFF(year, MIN(order_date), MAX(order_date)) AS order_year_range,
    DATEDIFF(month, MIN(order_date), MAX(order_date)) AS order_month_range,

    -- Explore required delivery date boundaries and coverage
    MIN(required_date) AS first_required_date,
    MAX(required_date) AS last_required_date,
    DATEDIFF(year, MIN(required_date), MAX(required_date)) AS required_year_range,
    DATEDIFF(month, MIN(required_date), MAX(required_date)) AS required_month_range,

    -- Explore actual shipping date boundaries and coverage
    MIN(shipped_date) AS first_shipped_date,
    MAX(shipped_date) AS last_shipped_date,
    DATEDIFF(year, MIN(shipped_date), MAX(shipped_date)) AS shipping_year_range,
    DATEDIFF(month, MIN(shipped_date), MAX(shipped_date)) AS shipping_month_range
FROM gold.fact_order_line;