# Retail Sales & Customer Insights

A beginner/intermediate portfolio project using MySQL 8.0 and fictional retail data. It demonstrates relational table design, joins, aggregations, CTEs, window functions, and a reusable view.

## Dataset

- 25 synthetic customers
- 15 products
- 55 orders and 110 order items
- CSV files are in `data/`. The SQL load script inserts the same sample data.
- All sample data is fictional.

## Requirements

MySQL 8.0 or newer and a MySQL client, such as MySQL Command Line Client or MySQL Workbench.

## Run the project

Connect to your MySQL server. For a local Windows server using port 3307, run this in Command Prompt:

```text
mysql -u root -p -P 3307 -h 127.0.0.1
```

At the `mysql>` prompt, run the three scripts in order. Replace `C:/path/to` with the location where you saved the project folder:

```sql
SOURCE C:/path/to/Retail-Sales-Customer-Insights-SQL/sql/01_schema.sql
SOURCE C:/path/to/Retail-Sales-Customer-Insights-SQL/sql/02_load_sample_data.sql
SOURCE C:/path/to/Retail-Sales-Customer-Insights-SQL/sql/03_analysis_queries.sql
```

The load script resets and reloads the project’s sample data. To check the row counts, run:

```sql
USE retail_sales;
SELECT COUNT(*) FROM customers;
SELECT COUNT(*) FROM products;
SELECT COUNT(*) FROM orders;
SELECT COUNT(*) FROM order_items;
```

Expected counts: 25 customers, 15 products, 55 orders, and 110 order items.

## Analysis included

Delivered revenue and average order value; monthly revenue with `LAG`; category and product performance; `DENSE_RANK` within each category; customer lifetime value; repeat-customer percentage; revenue by city; order status; low stock; above-average order totals; cumulative revenue; and the `v_order_summary` view.

## Project files

- `sql/01_schema.sql` — creates the database and tables, including keys, constraints, and indexes.
- `sql/02_load_sample_data.sql` — inserts the synthetic sample data.
- `sql/03_analysis_queries.sql` — runs the analysis queries and creates the view.
- `data/` — CSV files for customers, products, orders, and order items.
- `CV_BULLET.md` — an editable résumé bullet.

Revenue is calculated as quantity multiplied by the current product price. This small dataset is for SQL practice and portfolio demonstration.
