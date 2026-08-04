# Northwind Exploratory Data Analysis (EDA) Using SQL

![SQL](https://img.shields.io/badge/SQL-Server-informational)
![Project](https://img.shields.io/badge/Project-Exploratory_Data_Analysis-informational)
![Data Model](https://img.shields.io/badge/Data_Model-Star_Schema-informational)

## Project Overview

This project performs exploratory data analysis on the **Gold layer of a Northwind data warehouse** using Microsoft SQL Server. The analysis converts order-line data into business insights about sales, products, customers, employees, shipping companies and delivery performance.

The SQL scripts follow a structured EDA process: database inspection, dimension exploration, date-range analysis, key-measure calculation, magnitude analysis and performance ranking.

![Northwind EDA Workflow](docs/EDA.png)

## Project Objectives

- Understand the structure and coverage of the analytical dataset.
- Calculate core business measures such as sales, orders, units sold, freight and discounts.
- Examine how performance is distributed across products, customers, employees, locations and shippers.
- Measure shipping outcomes, including on-time and delayed shipping rates.
- Identify leading and lowest-performing business segments through ranking analysis.
- Produce reusable SQL scripts that can support reporting and dashboard development.

## Data Model

The analysis uses one order-line fact table connected to four dimensions. Because the fact table is stored at **order-line grain**, one order may appear on several rows. Order-level measures therefore use `COUNT(DISTINCT order_id)`.

![Northwind Star Schema](docs/northwind_star_schema.png)

| Table | Purpose | Records |
|---|---|---:|
| `gold.fact_order_line` | Order-line transactions, dates, shipping status, quantity, sales and freight | 2,155 |
| `gold.dim_customers` | Customer, company and geographic attributes | 91 |
| `gold.dim_products` | Product, category, price and discontinued status | 77 |
| `gold.dim_employees` | Employee, role, location and manager information | 9 |
| `gold.dim_shippers` | Shipping-company information | 3 |

The order data covers **04 July 2013 to 06 May 2015**.

## Repository Structure

```text
Northwind_EDA/
├── datasets/
│   ├── dim_customers.csv
│   ├── dim_employees.csv
│   ├── dim_products.csv
│   ├── dim_shippers.csv
│   └── fact_order_line.csv
├── docs/
│   ├── EDA.png
│   ├── northwind_kpi_summary.png
│   ├── northwind_star_schema.png
│   └── summary_EDA_measure_analysis.pdf
├── scripts/
│   ├── 01_nw_database_exploration.sql
│   ├── 02_nw_dimension_exploration.sql
│   ├── 03_nw_date_range_exploration.sql
│   ├── 04_nw_measure_exploration.sql
│   ├── 05_nw_magnitude_analysis.sql
│   └── 06_nw_ranking_analysis.sql
└── README.md
```

## Analysis Workflow

| Stage | Script | Main Purpose |
|---:|---|---|
| 1 | [`01_nw_database_exploration.sql`](scripts/01_nw_database_exploration.sql) | Inspect tables, schemas, columns and metadata. |
| 2 | [`02_nw_dimension_exploration.sql`](scripts/02_nw_dimension_exploration.sql) | Review unique countries, categories, products and shipping classifications. |
| 3 | [`03_nw_date_range_exploration.sql`](scripts/03_nw_date_range_exploration.sql) | Determine the earliest and latest order, required and shipped dates. |
| 4 | [`04_nw_measure_exploration.sql`](scripts/04_nw_measure_exploration.sql) | Calculate totals, averages, shipping rates and a consolidated measures report. |
| 5 | [`05_nw_magnitude_analysis.sql`](scripts/05_nw_magnitude_analysis.sql) | Compare business measures across customers, products, employees and shippers. |
| 6 | [`06_nw_ranking_analysis.sql`](scripts/06_nw_ranking_analysis.sql) | Rank top and bottom products, categories, employees, customers, locations and shippers. |

## Key Performance Snapshot

![Northwind KPI Summary](docs/northwind_kpi_summary.png)

| Measure | Result |
|---|---:|
| Total sales | **$1,265,793.29** |
| Unique orders | **830** |
| Order lines | **2,155** |
| Units sold | **51,317** |
| Product categories | **8** |
| Customers | **91** |
| On-time or early orders | **772** |
| On-time shipping rate | **95.43%** |
| Delayed orders | **37** |
| Delayed shipping rate | **4.57%** |

> Shipping rates are calculated from unique shipped orders. Orders classified as `N/A` are excluded because they do not have a completed shipping outcome.

## Selected Findings

- **Côte de Blaye** generated the highest product sales at **$141,396.74**.
- **Beverages** was the leading category with **$267,868.20** in sales.
- **Margaret Peacock** generated the highest employee-attributed sales at **$232,890.89**.
- **QUICK-Stop** was the highest-value customer, contributing **$110,277.32**.
- The **USA** was the leading customer market with **$245,584.65** in sales.
- **United Package** handled the highest sales value at **$533,547.74**.
- Of the **809** orders with a completed shipping outcome, **772** were shipped early or on time.

## SQL Techniques Demonstrated

- Aggregate functions: `COUNT()`, `SUM()` and `AVG()`
- Unique order counting with `COUNT(DISTINCT)`
- Conditional aggregation using `CASE`
- Date analysis with `MIN()`, `MAX()` and `DATEDIFF()`
- Multi-table analysis using `LEFT JOIN`
- Segmentation with `GROUP BY`
- Sorting and top/bottom analysis with `ORDER BY` and `TOP`
- Ranking with `ROW_NUMBER()`
- Consolidated reporting with `UNION ALL`
- Safe division using `NULLIF()`
- Numeric formatting with `CAST()` and `DECIMAL`

## How to Run the Analysis

1. Ensure the Northwind data warehouse has been created and the Gold-layer tables are available.
2. Open the project in SQL Server Management Studio or another SQL Server client.
3. Run the scripts in numerical order, beginning with database exploration.
4. Review each result set and compare the detailed findings with the consolidated measure report.
5. Open [`summary_EDA_measure_analysis.pdf`](docs/summary_EDA_measure_analysis.pdf) for the saved measure-analysis summary.

## Important Analytical Note

`gold.fact_order_line` contains one row per product line rather than one row per order. For this reason:

```sql
COUNT(*)                       -- counts order lines
COUNT(DISTINCT order_id)       -- counts actual orders
SUM(quantity)                  -- counts the number of units sold
```

Using the correct grain prevents orders containing several products from being counted multiple times.

## Potential Extensions

- Monthly and yearly sales trend analysis
- Customer segmentation and repeat-purchase analysis
- Product profitability after freight and discount allocation
- Employee performance comparison across time periods
- Shipping-company service-level analysis
- Interactive Power BI or Tableau dashboard development

## Author

Developed by [petertakyio-stack](https://github.com/petertakyio-stack).
