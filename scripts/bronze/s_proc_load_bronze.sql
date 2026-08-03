/*
===============================================================================
Stored Procedure: bronze.load_bronze
===============================================================================

Purpose:
    Loads source data from CSV files into tables in the bronze schema.

Process:
    1. Records the start time of the complete loading process.
    2. Truncates each bronze table to remove previously loaded data.
    3. Loads the latest data from the corresponding CSV file using BULK INSERT.
    4. Records and displays the loading duration for each table.
    5. Displays the total duration of the complete bronze-layer load.
    6. Captures and displays error details if the loading process fails.

Important Notes:
    - The customers and products tables are not loaded through BULK INSERT.
    - These two tables were loaded using a Visual Studio Code extension because
      their CSV files contain commas, special characters, or formatting that
      cannot be handled correctly by the current BULK INSERT configuration.
    - The CSV files used by BULK INSERT must be accessible from inside the
      SQL Server container.

Parameters:
    None.

Return Value:
    None.

Usage:
    EXEC bronze.load_bronze;
===============================================================================
*/

CREATE OR ALTER PROCEDURE bronze.load_bronze
AS
BEGIN
    -- Variables used to measure individual table loads and the complete batch load.
    DECLARE 
        @start_time DATETIME,
        @end_time DATETIME,
        @batch_start_time DATETIME,
        @batch_end_time DATETIME;

    BEGIN TRY

        -- Record the start time of the complete bronze-layer loading process.
        SET @batch_start_time = GETDATE();

        PRINT '================================================';
        PRINT 'Loading Bronze Layer';
        PRINT '================================================';

        -- Customers and products were loaded separately using a VS Code extension.
        PRINT 'NOTE: The products and customers tables were loaded using extensions';


        -- =====================================================================
        -- 1. Load the categories table
        -- =====================================================================

        -- Record the start time for loading the categories table.
        SET @start_time = GETDATE();

        -- Remove all existing records before loading the latest source data.
        PRINT '>> Truncating Table: bronze.categories';
        TRUNCATE TABLE bronze.categories;

        -- Load category records from the CSV file into the bronze table.
        PRINT '>> Inserting Data Into: bronze.categories';
        BULK INSERT bronze.categories
        FROM '/var/opt/mssql/data/categories.csv'
        WITH (
            FIELDTERMINATOR = ',',       -- Columns in the file are separated by commas.
            ROWTERMINATOR = '0x0a',      -- Each row ends with a line-feed character.
            FIRSTROW = 2,                -- Skip the header row in the CSV file.
            TABLOCK                      -- Lock the table during the load for better performance.
        );

        -- Calculate and display the time taken to load the table.
        SET @end_time = GETDATE();

        PRINT '>> Load Duration: '
            + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR)
            + ' seconds';

        PRINT '>> --------------------------------------------------------------';


        -- =====================================================================
        -- 2. Customers table
        -- =====================================================================

        /*
        The customers table was not loaded using BULK INSERT because some customer
        records contain commas within the actual field values.

        With FIELDTERMINATOR set to a comma, SQL Server may incorrectly interpret
        these embedded commas as column separators. This can shift values into the
        wrong columns or cause the BULK INSERT operation to fail.

        In addition, files stored on the local computer are not automatically
        accessible to SQL Server when it is running inside a container. Files used
        by BULK INSERT must first be copied into a directory that the SQL Server
        container can access.

        To avoid these issues, the customers data was loaded directly from the local
        file system using a Visual Studio Code extension.

        The BULK INSERT version originally considered is retained below for reference.

        -------------------------------------------------------------------------

        SET @start_time = GETDATE();

        PRINT '>> Truncating Table: bronze.customers';
        TRUNCATE TABLE bronze.customers;

        PRINT '>> Inserting Data Into: bronze.customers';
        BULK INSERT bronze.customers
        FROM '/var/opt/mssql/data/customers.csv'
        WITH (
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = '0x0a',
            FIRSTROW = 2,
            TABLOCK
        );

        SET @end_time = GETDATE();

        PRINT '>> Load Duration: '
            + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR)
            + ' seconds';

        PRINT '>> --------------------------------------------------------------';
        */


        -- =====================================================================
        -- 3. Load the employees table
        -- =====================================================================

        -- Record the start time for loading the employees table.
        SET @start_time = GETDATE();

        -- Remove all existing employee records.
        PRINT '>> Truncating Table: bronze.employees';
        TRUNCATE TABLE bronze.employees;

        -- Load employee records from the CSV file.
        PRINT '>> Inserting Data Into: bronze.employees';
        BULK INSERT bronze.employees
        FROM '/var/opt/mssql/data/employees.csv'
        WITH (
            FIELDTERMINATOR = ',',       
            ROWTERMINATOR = '0x0a',      
            FIRSTROW = 2,                
            TABLOCK                      
        );

        -- Calculate and display the table-loading duration.
        SET @end_time = GETDATE();

        PRINT '>> Load Duration: '
            + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR)
            + ' seconds';

            PRINT '>> ----------------------------------------------------------';


        -- =====================================================================
        -- 4. Load the order_details table
        -- =====================================================================

        -- Record the start time for loading the order details.
        SET @start_time = GETDATE();

        -- Remove all existing order-detail records.
        PRINT '>> Truncating Table: bronze.order_details';
        TRUNCATE TABLE bronze.order_details;

        -- Load order-detail records from the CSV file.
        PRINT '>> Inserting Data Into: bronze.order_details';
        BULK INSERT bronze.order_details
        FROM '/var/opt/mssql/data/order_details.csv'
        WITH (
            FIELDTERMINATOR = ',',       -- Separate columns using commas.
            ROWTERMINATOR = '0x0a',      -- Separate records using line-feed characters.
            FIRSTROW = 2,                -- Skip the CSV header row.
            TABLOCK                      -- Apply a table-level lock during the load.
        );

        -- Calculate and display the table-loading duration.
        SET @end_time = GETDATE();

        PRINT '>> Load Duration: '
            + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR)
            + ' seconds';

        PRINT '>> --------------------------------------------------------------';


        -- =====================================================================
        -- 5. Load the orders table
        -- =====================================================================

        -- Record the start time for loading the orders table.
        SET @start_time = GETDATE();

        -- Remove all existing order records.
        PRINT '>> Truncating Table: bronze.orders';
        TRUNCATE TABLE bronze.orders;

        -- Load order records from the CSV file.
        PRINT '>> Inserting Data Into: bronze.orders';
        BULK INSERT bronze.orders
        FROM '/var/opt/mssql/data/orders.csv'
        WITH (
            FIELDTERMINATOR = ',',       -- Separate columns using commas.
            ROWTERMINATOR = '0x0a',      -- Separate records using line-feed characters.
            FIRSTROW = 2,                -- Skip the CSV header row.
            TABLOCK                      -- Apply a table-level lock during the load.
        );

        -- Calculate and display the table-loading duration.
        SET @end_time = GETDATE();

        PRINT '>> Load Duration: '
            + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR)
            + ' seconds';

        PRINT '>> --------------------------------------------------------------';


        -- =====================================================================
        -- 6. Products table
        -- =====================================================================

        /*
        The products table was not loaded using BULK INSERT because the source file
        contains special characters and formatting that caused the operation to fail.

        To preserve the original product values and avoid character-encoding or parsing
        problems, the products data was loaded using a Visual Studio Code extension.

        The BULK INSERT version originally considered is retained below for reference.

        -------------------------------------------------------------------------

        SET @start_time = GETDATE();

        PRINT '>> Truncating Table: bronze.products';
        TRUNCATE TABLE bronze.products;

        PRINT '>> Inserting Data Into: bronze.products';
        BULK INSERT bronze.products
        FROM '/var/opt/mssql/data/products.csv'
        WITH (
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = '0x0a',
            FIRSTROW = 2,
            TABLOCK
        );

        SET @end_time = GETDATE();

        PRINT '>> Load Duration: '
            + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR)
            + ' seconds';

        PRINT '>> --------------------------------------------------------------';
        */


        -- =====================================================================
        -- 7. Load the shippers table
        -- =====================================================================

        -- Record the start time for loading the shippers table.
        SET @start_time = GETDATE();

        -- Remove all existing shipper records.
        PRINT '>> Truncating Table: bronze.shippers';
        TRUNCATE TABLE bronze.shippers;

        -- Load shipper records from the CSV file.
        PRINT '>> Inserting Data Into: bronze.shippers';
        BULK INSERT bronze.shippers
        FROM '/var/opt/mssql/data/shippers.csv'
        WITH (
            FIELDTERMINATOR = ',',       -- Separate columns using commas.
            ROWTERMINATOR = '0x0a',      -- Separate records using line-feed characters.
            FIRSTROW = 2,                -- Skip the CSV header row.
            TABLOCK                      -- Apply a table-level lock during the load.
        );

        -- Calculate and display the table-loading duration.
        SET @end_time = GETDATE();

        PRINT '>> Load Duration: '
            + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR)
            + ' seconds';

        PRINT '>> --------------------------------------------------------------';


        -- Record the completion time of the complete bronze-layer load.
        SET @batch_end_time = GETDATE();

        -- Display the successful completion message and total loading duration.
        PRINT '==========================================';
        PRINT 'Loading Bronze Layer is Completed';

        PRINT '   - Total Load Duration: '
            + CAST(
                DATEDIFF(SECOND, @batch_start_time, @batch_end_time)
                AS NVARCHAR
              )
            + ' seconds';

        PRINT '==========================================';

    END TRY

    BEGIN CATCH

        -- Display information about any error encountered during the loading process.
        PRINT '==========================================';
        PRINT 'ERROR OCCURRED DURING BRONZE-LAYER LOADING';

        -- Display the SQL Server error description.
        PRINT 'Error Message: ' + ERROR_MESSAGE();

        -- Display the SQL Server error number.
        PRINT 'Error Number: ' + CAST(ERROR_NUMBER() AS NVARCHAR);

        -- Display the SQL Server error state.
        PRINT 'Error State: ' + CAST(ERROR_STATE() AS NVARCHAR);

        PRINT '==========================================';

    END CATCH
END;


EXEC bronze.load_bronze;






