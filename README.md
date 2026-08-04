# Northwind Data Warehouse Project
## Project Overview

This project transforms the Northwind operational dataset into a structured, analytics-ready data warehouse using SQL Server and a layered data architecture.

The project demonstrates an end-to-end data engineering workflow, including:
  - Extracting data from CSV source files
  - Loading raw data into a Bronze layer
  - Cleaning and standardising data in a Silver layer
  - Building dimension and fact views in a Gold layer
  - Designing a star schema for reporting and analytics
  - Implementing stored procedures and data-quality checks
  - Creating calculated business measures such as sales amount and allocated freight

The project was developed as part of my data engineering portfolio to demonstrate practical skills in SQL, ETL development, dimensional modelling, data transformation, data validation, and technical documentation.

---

## High Level Architecture
The warehouse follows a three-layer Medallion Architecture:
<img width="1073" height="571" alt="image" src="https://github.com/user-attachments/assets/0ab3f84b-1f39-4002-9774-09026899373d" />

### Bronze Layer
Stores raw or near-raw source data. It creates source-aligned tables, reloads CSV files, preserves original values, tracks load duration, and captures errors.
### Silver Layer
Cleans and standardises Bronze data by removing unwanted characters and spaces, correcting inconsistent values, handling selected missing data, converting data types, and validating data quality.
### Gold Layer
Presents business-ready dimension and fact views in a star schema for customer, product, employee, shipping, sales, and freight analysis.

---

## Gold-Layer Model
<img width="988" height="728" alt="image" src="https://github.com/user-attachments/assets/46f8c701-4dc1-4d07-90c6-ae2170020d09" />

Fact-table grain: One row per order and product combination.

### Dimension Views

  - gold.dim_customers
  - gold.dim_employees
  - gold.dim_products
  - gold.dim_shippers

### Fact View

  - gold.fact_order_line

### Key Features

  - CSV loading with BULK INSERT
  - Bronze and Silver ETL stored procedures
  - Data cleansing and standardisation
  - Star-schema modelling
  - Dynamically generated dimension keys
  - Employee-manager self-join
  - Shipping timeline classification
  - Sales and freight calculations
  - Silver and Gold data-quality checks
  - Error handling with TRY...CATCH

---

## Data Quality Checks

The project checks for:

  - Duplicate business keys
  - Duplicate order-product combinations
  - Missing dimension relationships
  - Invalid prices, quantities, or discounts
  - Incorrect sales calculations
  - Freight-allocation differences
  - Silver-to-Gold record-count mismatches

---

## Run Order

1. Database and schema setup
2. Bronze table creation
3. Bronze data load
4. Silver table creation
5. Silver data load
6. Silver quality checks
7. Gold view creation
8. Gold quality checks

---

## Skills Demonstrated
## Skills & Technologies

<p align="left">
  <img src="https://img.shields.io/badge/SQL%20Server-Database%20Development-CC2927?logo=microsoftsqlserver&logoColor=white" />
  <img src="https://img.shields.io/badge/ETL-Data%20Pipelines-0A66C2" />
  <img src="https://img.shields.io/badge/Data%20Warehousing-Analytics%20Ready-6F42C1" />
  <img src="https://img.shields.io/badge/Medallion%20Architecture-Bronze%20%7C%20Silver%20%7C%20Gold-D4A017" />
  <img src="https://img.shields.io/badge/Star%20Schema-Dimensional%20Modelling-2E8B57" />
  <img src="https://img.shields.io/badge/Window%20Functions-Advanced%20SQL-00758F" />
  <img src="https://img.shields.io/badge/CTEs-Readable%20Transformations-4B8BBE" />
  <img src="https://img.shields.io/badge/Data%20Quality-Validation%20%26%20Testing-28A745" />
</p>
