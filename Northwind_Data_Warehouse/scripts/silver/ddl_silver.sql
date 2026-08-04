IF OBJECT_ID('silver.categories', 'U') IS NOT NULL
    DROP TABLE silver.categories;
GO

CREATE TABLE silver.categories (
    category_id INT,
    category_name VARCHAR(MAX),
    cat_description VARCHAR(MAX), -- since description is reserved word, we use cat_description instead.
    dwh_create_date    DATETIME2 DEFAULT GETDATE() 
);
GO


IF OBJECT_ID('silver.customers', 'U') IS NOT NULL
    DROP TABLE silver.customers;
GO

CREATE TABLE silver.customers (
    customer_id NVARCHAR(50),
    company_name NVARCHAR(50),
    contact_name NVARCHAR(50),
    contact_title NVARCHAR(50),
    city NVARCHAR(50),
    country NVARCHAR(50),
    dwh_create_date    DATETIME2 DEFAULT GETDATE()
);
GO


IF OBJECT_ID('silver.employees', 'U') IS NOT NULL
    DROP TABLE silver.employees;
GO

CREATE TABLE silver.employees (
    employee_id INT,
    employee_name VARCHAR(255),
    title VARCHAR(255),
    city VARCHAR(255),
    country VARCHAR(255),
    reports_to INT,
    dwh_create_date    DATETIME2 DEFAULT GETDATE()
);
GO


IF OBJECT_ID('silver.order_details', 'U') IS NOT NULL
    DROP TABLE silver.order_details;
GO

CREATE TABLE silver.order_details (
    order_id INT,
    product_id INT,
    unit_price DECIMAL(10, 2),
    quantity INT,
    discount DECIMAL(3, 2),
    dwh_create_date    DATETIME2 DEFAULT GETDATE()
);
GO


IF OBJECT_ID('silver.orders', 'U') IS NOT NULL
    DROP TABLE silver.orders;
GO

CREATE TABLE silver.orders (
    order_id INT,
    customer_id VARCHAR(50),
    employee_id INT,
    order_date DATE,
    required_date DATE,
    shipped_date DATE,
    shipper_id INT,
    freight DECIMAL(10, 2),
    dwh_create_date    DATETIME2 DEFAULT GETDATE()
);
GO


IF OBJECT_ID('silver.products', 'U') IS NOT NULL
    DROP TABLE silver.products;
GO

CREATE TABLE silver.products (
    product_id INT,
    product_name NVARCHAR(50),
    quantity_per_unit NVARCHAR(50),
    unit_price FLOAT,
    discontinued NVARCHAR(50),
    category_id INT,
    dwh_create_date    DATETIME2 DEFAULT GETDATE()
);
GO


IF OBJECT_ID('silver.shippers', 'U') IS NOT NULL
    DROP TABLE silver.shippers ;
GO

CREATE TABLE silver.shippers (
    shipper_id INT,
    company_name VARCHAR(255),
    dwh_create_date    DATETIME2 DEFAULT GETDATE()
);
GO
