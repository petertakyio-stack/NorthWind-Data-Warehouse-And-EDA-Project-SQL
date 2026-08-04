/*
===============================================================================
Stored Procedure: silver.load_silver
===============================================================================

Purpose:
    Loads cleaned and standardized data from the bronze schema into the
    corresponding tables in the silver schema.

Process:
    For each silver table, the procedure:

    1. Records the start time of the table-loading operation.
    2. Truncates the existing silver table.
    3. Selects data from the corresponding bronze table.
    4. Applies the required cleansing and transformation rules.
    5. Inserts the transformed data into the silver table.
    6. Displays the loading duration for the table.

    After all tables have been processed, the procedure displays the total
    duration of the complete silver-layer load.

Parameters:
    None.

Usage:
    EXEC silver.load_silver;
===============================================================================
*/

CREATE OR ALTER PROCEDURE silver.load_silver
AS
BEGIN

    -- Variables used to measure individual table loads and the complete batch load.
    DECLARE
        @start_time DATETIME,
        @end_time DATETIME,
        @batch_start_time DATETIME,
        @batch_end_time DATETIME;

    BEGIN TRY
        -- Record the start time of the complete silver-layer loading process.
        SET @batch_start_time = GETDATE();

        PRINT '================================================';
        PRINT 'Loading Silver Layer';
        PRINT '================================================';


        -- =====================================================================
        -- 1. Load and clean the silver.categories table
        -- =====================================================================

        -- Record the start time for loading the categories table.
        SET @start_time = GETDATE();

        -- Remove all existing records before loading the refreshed dataset.
        PRINT '>> Truncating Table: silver.categories';
        TRUNCATE TABLE silver.categories;

        -- Load category data from the bronze layer.
        PRINT '>> Inserting Data Into: silver.categories';

        INSERT INTO silver.categories (category_id,category_name,cat_description)
        SELECT
            category_id,
            category_name,
            -- Clean the category description by removing carriage returns, line breaks, double quotation marks, and extra spaces.
            TRIM(REPLACE(REPLACE(REPLACE(description, CHAR(13), ''),CHAR(10), ''), '"', '')) AS cat_description
        FROM bronze.categories;

        -- Record the end time and display the categories loading duration.
        SET @end_time = GETDATE();

        PRINT '>> Load Duration: '
            + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR)
            + ' seconds';

        PRINT '>> --------------------------------------------------------------';


        -- =====================================================================
        -- 2. Load and standardize the silver.customers table
        -- =====================================================================

        -- Record the start time for loading the customers table.
        SET @start_time = GETDATE();

        -- Remove all existing customer records.
        PRINT '>> Truncating Table: silver.customers';
        TRUNCATE TABLE silver.customers;

        -- Load customer data from the bronze layer.
        PRINT '>> Inserting Data Into: silver.customers';

        INSERT INTO silver.customers (
            customer_id,
            company_name,
            contact_name,
            contact_title,
            city,
            country
        )
        SELECT
            customer_id,
            company_name,
            contact_name,
            -- The source value 'Owner/Marketing Assistant' appeared only once. Based on the agreed business rule, it is classified as 'Owner'.
            CASE
                WHEN TRIM(contact_title) = 'Owner/Marketing Assistant'
                    THEN 'Owner'
                ELSE contact_title
            END AS contact_title,
            city,
            country
        FROM bronze.customers;

        -- Record the end time and display the customers loading duration.
        SET @end_time = GETDATE();

        PRINT '>> Load Duration: '
            + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR)
            + ' seconds';

        PRINT '>> --------------------------------------------------------------';


        -- =====================================================================
        -- 3. Load and standardize the silver.employees table
        -- =====================================================================

        -- Record the start time for loading the employees table.
        SET @start_time = GETDATE();

        -- Remove all existing employee records.
        PRINT '>> Truncating Table: silver.employees';
        TRUNCATE TABLE silver.employees;

        -- Load employee data from the bronze layer.
        PRINT '>> Inserting Data Into: silver.employees';

        INSERT INTO silver.employees (
            employee_id,
            employee_name,
            title,
            city,
            country,
            reports_to
        )
        SELECT
            employee_id,
            employee_name,
            title,
            city,
            country,
            COALESCE(reports_to, 0) AS reports_to -- A value of 0 indicates that the employee does not report to another
        FROM bronze.employees;

        -- Record the end time and display the employees loading duration.
        SET @end_time = GETDATE();

        PRINT '>> Load Duration: '
            + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR)
            + ' seconds';

        PRINT '>> --------------------------------------------------------------';


        -- =====================================================================
        -- 4. Load the silver.order_details table
        -- =====================================================================

        -- Record the start time for loading the order-details table.
        SET @start_time = GETDATE();

        -- Remove all existing order-line records.
        PRINT '>> Truncating Table: silver.order_details';
        TRUNCATE TABLE silver.order_details;

        PRINT '>> Inserting Data Into: silver.order_details';

        INSERT INTO silver.order_details (
            order_id,
            product_id,
            unit_price,
            quantity,
            discount
        )
        SELECT
            order_id,
            product_id,
            unit_price,
            quantity,
            discount
        FROM bronze.order_details;

        -- Record the end time and display the order-details loading duration.
        SET @end_time = GETDATE();

        PRINT '>> Load Duration: '
            + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR)
            + ' seconds';

        PRINT '>> --------------------------------------------------------------';


        -- =====================================================================
        -- 5. Load the silver.orders table
        -- =====================================================================

        -- Record the start time for loading the orders table.
        SET @start_time = GETDATE();

        -- Remove all existing order records.
        PRINT '>> Truncating Table: silver.orders';
        TRUNCATE TABLE silver.orders;

        PRINT '>> Inserting Data Into: silver.orders';

        INSERT INTO silver.orders (
            order_id,
            customer_id,
            employee_id,
            order_date,
            required_date,
            shipped_date,
            shipper_id,
            freight
        )
        SELECT
            order_id,
            customer_id,
            employee_id,
            order_date,
            required_date,
            shipped_date,
            shipper_id,
            freight
        FROM bronze.orders;

        -- Record the end time and display the orders loading duration.
        SET @end_time = GETDATE();

        PRINT '>> Load Duration: '
            + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR)
            + ' seconds';

        PRINT '>> --------------------------------------------------------------';


        -- =====================================================================
        -- 6. Load and standardize the silver.products table
        -- =====================================================================

        -- Record the start time for loading the products table.
        SET @start_time = GETDATE();

        -- Remove all existing product records.
        PRINT '>> Truncating Table: silver.products';
        TRUNCATE TABLE silver.products;

        -- Load product data from the bronze layer.
        PRINT '>> Inserting Data Into: silver.products';

        INSERT INTO silver.products (
            product_id,
            product_name,
            quantity_per_unit,
            unit_price,
            discontinued,
            category_id
        )
        SELECT
            product_id,
            product_name,
            quantity_per_unit,
            CAST(unit_price AS DECIMAL(10, 2)) AS unit_price, --Convert the product price to DECIMAL(10,2) to retain a consistent financial format
            CASE
                WHEN discontinued = 0 THEN 'NO'
                ELSE 'YES'
            END AS discontinued,
            category_id
        FROM bronze.products;

        -- Record the end time and display the products loading duration.
        SET @end_time = GETDATE();

        PRINT '>> Load Duration: '
            + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR)
            + ' seconds';

        PRINT '>> --------------------------------------------------------------';


        -- =====================================================================
        -- 7. Load and clean the silver.shippers table
        -- =====================================================================

        -- Record the start time for loading the shippers table.
        SET @start_time = GETDATE();

        -- Remove all existing shipping-company records.
        PRINT '>> Truncating Table: silver.shippers';
        TRUNCATE TABLE silver.shippers;

        -- Load shipper data from the bronze layer.
        PRINT '>> Inserting Data Into: silver.shippers';

        INSERT INTO silver.shippers (
            shipper_id,
            company_name
        )
        SELECT
            shipper_id,
            TRIM(REPLACE(REPLACE(company_name, CHAR(13), ''),CHAR(10), '')) AS company_name -- Remove carriage-return and line-feed characters from the company name
        FROM bronze.shippers;

        -- Record the end time and display the shippers loading duration.
        SET @end_time = GETDATE();

        PRINT '>> Load Duration: '
            + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR)
            + ' seconds';

        PRINT '>> --------------------------------------------------------------';


        -- Record the completion time of the complete silver-layer load.
        SET @batch_end_time = GETDATE();

        -- Display the successful completion message and total load duration.
        PRINT '================================================';
        PRINT 'Silver Layer Loading Completed Successfully';

        PRINT '>> Total Load Duration: '
            + CAST(
                DATEDIFF(
                    SECOND,
                    @batch_start_time,
                    @batch_end_time
                ) AS NVARCHAR
            )
            + ' seconds';

        PRINT '================================================';

    END TRY

    BEGIN CATCH

        PRINT '================================================';
        PRINT 'ERROR OCCURRED DURING SILVER-LAYER LOADING';

        -- Display the SQL Server error description.
        PRINT 'Error Message: ' + ERROR_MESSAGE();

        -- Display the SQL Server error number.
        PRINT 'Error Number: '
            + CAST(ERROR_NUMBER() AS NVARCHAR);

        -- Display the SQL Server error state.
        PRINT 'Error State: '
            + CAST(ERROR_STATE() AS NVARCHAR);

        PRINT '================================================';

    END CATCH
END;
