USE master;
GO

-- Drop and recreate the 'NorthWindDataWarehouse' database

IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'NorthWindDataWarehouse')
BEGIN
    ALTER DATABASE NorthWindDataWarehouse SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE NorthWindDataWarehouse;
END;
GO

-- Create NorthWindDataWarehouse Database
CREATE DATABASE NorthWindDataWarehouse;
GO

USE NorthWindDataWarehouse;
GO


-- Create Schemas
CREATE SCHEMA bronze;
GO

CREATE SCHEMA silver;
GO

CREATE SCHEMA gold;
GO