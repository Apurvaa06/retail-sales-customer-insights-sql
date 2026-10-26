# Retail Sales & Customer Insights (MySQL 8.0)

A beginner/intermediate portfolio project using a small synthetic retail dataset. It demonstrates relational table design, constraints, joins, aggregation, CTEs, window functions, and a reusable view.

## Dataset

- 25 synthetic customers
- 15 products across several categories
- 55 orders with two item rows each (110 order-item rows)
- CSV files are in `data/`; the SQL load script contains the same rows and does not require `LOAD DATA LOCAL INFILE`.
- All names, email addresses, and transactions are fictional.

## Requirements

MySQL 8.0 or newer, plus a MySQL client such as Command Prompt's `mysql` client or MySQL Workbench. The setup guide below uses Windows and port **3307**.

## Run from the MySQL prompt

If you already see `mysql>`, enter each line separately:

```sql
SOURCE C:/Users/your-Windows-name/Downloads/Retail-Sales-Customer-Insights-SQL/sql/01_schema.sql;
SOURCE C:/Users/your-Windows-name/Downloads/Retail-Sales-Customer-Insights-SQL/sql/02_load_sample_data.sql;
SOURCE C:/Users/your-Windows-name/Downloads/Retail-Sales-Customer-Insights-SQL/sql/03_analysis_queries.sql;
```

Replace the example path with the folder where you extracted the ZIP. In Windows paths, use forward slashes in `SOURCE`. If you opened MySQL Workbench instead, open each `.sql` file and click the lightning-bolt Execute button in this order.

## Windows setup from the beginning

1. Extract `Retail-Sales-Customer-Insights-SQL.zip` to a convenient folder, such as `Documents`.
2. Open **Command Prompt** (press Start, type `cmd`, press Enter).
3. Connect to the local MySQL server on port 3307:

   ```text
   mysql -u root -p -P 3307 -h 127.0.0.1
   ```

   Type your MySQL password when prompted. The password will not appear while you type. If Windows says `mysql` is not recognized, open MySQL Command Line Client from Start, or run the `mysql.exe` in your MySQL Server `bin` folder with the same options.
4. At the `mysql>` prompt, run the three `SOURCE` commands above, using your actual Windows folder path. Run them in order.
5. Check that data loaded:

   ```sql
   USE retail_sales;
   SELECT COUNT(*) FROM customers;
   SELECT COUNT(*) FROM products;
   SELECT COUNT(*) FROM orders;
   SELECT COUNT(*) FROM order_items;
   ```

   Expected counts: 25, 15, 55, and 110. The analysis script also prints results and creates `v_order_summary`.
6. Exit with `exit;`.

## Files

- `sql/01_schema.sql` creates database `retail_sales` and four related InnoDB tables with primary keys, foreign keys, checks, uniqueness, and indexes.
- `sql/02_load_sample_data.sql` resets and inserts the synthetic sample records. Re-running it replaces the sample rows.
- `sql/03_analysis_queries.sql` contains the requested analysis examples and creates the reusable view.
- `data/*.csv` provides spreadsheet-friendly copies of each table.
- `CV_BULLET.md` has an editable portfolio bullet.

## Analysis included

Row counts; delivered revenue and average order value; monthly revenue with `LAG`; category revenue; top products; `DENSE_RANK` within category; customer lifetime value; repeat-customer percentage; revenue by city; order status distribution; low-stock products; above-average order totals; cumulative revenue; and a reusable order summary view.

## Notes

Revenue is calculated as item quantity multiplied by the current product price, and revenue-focused examples generally include delivered orders. This compact portfolio dataset is for SQL practice, not business forecasting.

## Publish to GitHub later

1. Create a new **public** repository on GitHub named `retail-sales-customer-insights-sql`. Do not initialize it with a README (this folder already has one).
2. Install Git for Windows if needed, then open Command Prompt in the extracted project folder. In File Explorer, open the folder, click the address bar, type `cmd`, and press Enter.
3. Run these commands, replacing `YOUR-USERNAME` with your GitHub username:

   ```text
   git init
   git add .
   git commit -m "Add retail sales SQL portfolio project"
   git branch -M main
   git remote add origin https://github.com/YOUR-USERNAME/retail-sales-customer-insights-sql.git
   git push -u origin main
   ```

4. Sign in if Git asks, then refresh the repository page. The README will appear on the project home page.

Before publishing, review the files and make sure you have not added passwords, private data, or machine-specific files. This project contains only synthetic sample data.
