/*
===============================================================================
DDL Script: Create Bronze-Layer Tables
===============================================================================

Purpose:
    Creates the required tables in the bronze schema.

Process:
    1. Checks whether each bronze table already exists.
    2. Drops the existing table where applicable.
    3. Recreates the table using the defined column names and data types.

Important Notes:
    - Running this script will permanently delete existing data in the tables
      that are dropped.
    - The customers and products tables are not created by this script.
    - These two tables were created automatically when their CSV files were
      imported using a Visual Studio Code extension.
    - The commented table definitions are retained for documentation and
      future reference.

Usage:
    Run this script whenever the bronze-layer table structures need to be
    recreated or redefined.
===============================================================================
*/


-- =============================================================================
-- 1. Create the categories table
-- =============================================================================

-- Drop the categories table if it already exists.
IF OBJECT_ID('bronze.categories', 'U') IS NOT NULL
    DROP TABLE bronze.categories;
GO

-- Create the categories table to store product-category information.
CREATE TABLE bronze.categories (
    category_id INT,
    category_name VARCHAR(MAX),
    description VARCHAR(MAX)
);
GO


-- =============================================================================
-- 2. Customers table
-- =============================================================================

/*
The customers table is not created by this script because it was created
automatically when the customers CSV file was imported using a Visual Studio
Code extension.

The table definition below is retained for reference. It can be uncommented
and executed if the customers table needs to be created manually.

-------------------------------------------------------------------------------

IF OBJECT_ID('bronze.customers', 'U') IS NOT NULL
    DROP TABLE bronze.customers;
GO

CREATE TABLE bronze.customers (
    customer_id NVARCHAR(255),
    company_name NVARCHAR(255),
    contact_name NVARCHAR(255),
    contact_title NVARCHAR(255),
    city NVARCHAR(255),
    country NVARCHAR(255)
);
GO
*/


-- =============================================================================
-- 3. Create the employees table
-- =============================================================================

-- Drop the employees table if it already exists.
IF OBJECT_ID('bronze.employees', 'U') IS NOT NULL
    DROP TABLE bronze.employees;
GO

-- Create the employees table to store employee and reporting information.
CREATE TABLE bronze.employees (
    employee_id INT,
    employee_name VARCHAR(255),
    title VARCHAR(255),
    city VARCHAR(255),
    country VARCHAR(255),
    reports_to INT
);
GO


-- =============================================================================
-- 4. Create the order_details table
-- =============================================================================

-- Drop the order_details table if it already exists.
IF OBJECT_ID('bronze.order_details', 'U') IS NOT NULL
    DROP TABLE bronze.order_details;
GO

-- Create the order_details table to store product-level information for orders.
CREATE TABLE bronze.order_details (
    order_id INT,
    product_id INT,
    unit_price DECIMAL(10, 2),
    quantity INT,
    discount DECIMAL(3, 2)
);
GO


-- =============================================================================
-- 5. Create the orders table
-- =============================================================================

-- Drop the orders table if it already exists.
IF OBJECT_ID('bronze.orders', 'U') IS NOT NULL
    DROP TABLE bronze.orders;
GO

-- Create the orders table to store order, shipping, and freight information.
CREATE TABLE bronze.orders (
    order_id INT,
    customer_id VARCHAR(50),
    employee_id INT,
    order_date DATE,
    required_date DATE,
    shipped_date DATE,
    shipper_id INT,
    freight DECIMAL(10, 2)
);
GO


-- =============================================================================
-- 6. Products table
-- =============================================================================

/*
The products table is not created by this script because it was created
automatically when the products CSV file was imported using a Visual Studio
Code extension.

The table definition below is retained for reference. It can be uncommented
and executed if the products table needs to be created manually.

-------------------------------------------------------------------------------

IF OBJECT_ID('bronze.products', 'U') IS NOT NULL
    DROP TABLE bronze.products;
GO

CREATE TABLE bronze.products (
    product_id INT,
    product_name NVARCHAR(50),
    quantity_per_unit NVARCHAR(50),
    unit_price FLOAT,
    discontinued BIT,
    category_id INT
);
GO
*/


-- =============================================================================
-- 7. Create the shippers table
-- =============================================================================

-- Drop the shippers table if it already exists.
IF OBJECT_ID('bronze.shippers', 'U') IS NOT NULL
    DROP TABLE bronze.shippers;
GO

-- Create the shippers table to store shipping-company information.
CREATE TABLE bronze.shippers (
    shipper_id INT,
    company_name VARCHAR(255)
);
GO