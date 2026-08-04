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

<p align="center">
  <img width="1073" height="571" alt="image" src="https://github.com/user-attachments/assets/0ab3f84b-1f39-4002-9774-09026899373d" />
  <em>Figure 1: End-to-end data flow from CSV source files through the Bronze, Silver, and Gold layers to BI and reporting tools.</em>
</p>

<p align="center">
 <img width="1206" height="684" alt="image" src="https://github.com/user-attachments/assets/f80a476f-54e8-4974-bec5-dcdd2be1ee9f" />
  <em>Figure 2: End-to-end data lineage from CSV source files through the Bronze, Silver, and Gold layers to BI and reporting tools.</em>
</p>

### Bronze Layer
Stores raw or near-raw source data. It creates source-aligned tables, reloads CSV files, preserves original values, tracks load duration, and captures errors.
### Silver Layer
Cleans and standardises Bronze data by removing unwanted characters and spaces, correcting inconsistent values, handling selected missing data, converting data types, and validating data quality.
### Gold Layer
Presents business-ready dimension and fact views in a star schema for customer, product, employee, shipping, sales, and freight analysis.

---

## Gold-Layer - Source Data Model
<img width="988" height="728" alt="image" src="https://github.com/user-attachments/assets/46f8c701-4dc1-4d07-90c6-ae2170020d09" />
<em>Figure 2: Gold-layer star schema connecting the order-line fact view to the customer, product, employee, and shipper dimensions.</em>
</p>

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

---

## BI: Analytics & Reporting

The Gold layer provides an analytics-ready star schema that can be connected to tools such as **Power BI, Tableau, or Excel** to build interactive reports and dashboards.

### Key Performance Indicators

| KPI | Description |
|---|---|
| **Total Sales** | Total revenue generated after discounts |
| **Total Orders** | Number of unique customer orders |
| **Average Order Value** | Average sales value per order |
| **Units Sold** | Total quantity of products ordered |
| **Average Discount** | Average discount applied across order lines |
| **Allocated Freight Cost** | Freight assigned to each product line |
| **On-Time Shipping Rate** | Percentage of orders shipped on or before the required date |
| **Delayed Orders** | Number of orders shipped after the required date |
| **Sales After Freight** | Sales amount remaining after allocated freight costs |

### Critical Business Questions

  - Which customers generate the highest sales?
  - Which products and categories perform best?
  - Which employees manage the highest-value orders?
  - Which countries and cities contribute the most revenue?
  - How do discounts affect sales performance?
  - Which shipping companies handle the most orders?
  - What percentage of orders are shipped early, on time, or late?
  - Which products attract the highest freight costs?
  - How do sales and order volumes change over time?
  - Which customers, products, or markets show opportunities for growth?

---

### 👨🏽‍💻 About Me

Hi, I’m **Peter Takyi Ohemeng** — a **petroleum engineer and environmental management professional** building strong expertise in **data analytics, business intelligence, and data engineering**.

🌍 I aspire to become an **environmental data analyst**, using data to identify environmental risks, improve operational performance, and support smarter decision-making across the energy and extractive industries.

⚙️ I am particularly interested in finding the right balance between resource development and environmental responsibility. My long-term goal is to help organisations derive the safest and fullest possible benefits from extractive activities while protecting the environment and the communities that depend on it.

📊 Through projects like this, I am developing practical skills in **SQL, data warehousing, dimensional modelling, ETL development, and analytics reporting** — transforming raw data into reliable insights that support better business and environmental decisions.

> 🌱 **My mission:** To combine engineering knowledge, environmental awareness, and data-driven insights to contribute to a safer, smarter, and more sustainable future.

---

## License

This project is licensed under the [MIT License](LICENSE).
You are free to use, modify, and share this project with proper attribution.

---
