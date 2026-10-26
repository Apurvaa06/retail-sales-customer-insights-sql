-- Retail Sales & Customer Insights | MySQL 8.0 analysis
USE retail_sales;

-- 1. Row counts
SELECT 'customers' AS table_name, COUNT(*) AS row_count FROM customers
UNION ALL SELECT 'products', COUNT(*) FROM products
UNION ALL SELECT 'orders', COUNT(*) FROM orders
UNION ALL SELECT 'order_items', COUNT(*) FROM order_items;

-- Shared order value calculation: line quantity multiplied by current product price.
-- 2. Delivered revenue and average order value (AOV)
WITH order_totals AS (SELECT o.order_id, SUM(oi.quantity*p.unit_price) AS order_value FROM orders o JOIN order_items oi USING(order_id) JOIN products p USING(product_id) WHERE o.status='delivered' GROUP BY o.order_id)
SELECT ROUND(SUM(order_value),2) AS delivered_revenue, ROUND(AVG(order_value),2) AS delivered_aov FROM order_totals;

-- 3. Monthly delivered revenue and change from prior month
WITH monthly AS (SELECT DATE_FORMAT(o.order_date,'%Y-%m') AS sales_month, SUM(oi.quantity*p.unit_price) AS revenue FROM orders o JOIN order_items oi USING(order_id) JOIN products p USING(product_id) WHERE o.status='delivered' GROUP BY DATE_FORMAT(o.order_date,'%Y-%m'))
SELECT sales_month, ROUND(revenue,2) AS revenue, ROUND(LAG(revenue) OVER(ORDER BY sales_month),2) AS previous_month_revenue FROM monthly ORDER BY sales_month;

-- 4. Revenue by category (delivered orders)
SELECT p.category, ROUND(SUM(oi.quantity*p.unit_price),2) AS revenue FROM orders o JOIN order_items oi USING(order_id) JOIN products p USING(product_id) WHERE o.status='delivered' GROUP BY p.category ORDER BY revenue DESC;

-- 5. Top 10 products by delivered revenue
SELECT p.product_id,p.product_name,ROUND(SUM(oi.quantity*p.unit_price),2) AS revenue FROM orders o JOIN order_items oi USING(order_id) JOIN products p USING(product_id) WHERE o.status='delivered' GROUP BY p.product_id,p.product_name ORDER BY revenue DESC LIMIT 10;

-- 6. Rank products within each category by delivered revenue
WITH product_sales AS (SELECT p.product_id,p.product_name,p.category,SUM(oi.quantity*p.unit_price) AS revenue FROM orders o JOIN order_items oi USING(order_id) JOIN products p USING(product_id) WHERE o.status='delivered' GROUP BY p.product_id,p.product_name,p.category)
SELECT category,product_name,ROUND(revenue,2) AS revenue,DENSE_RANK() OVER(PARTITION BY category ORDER BY revenue DESC) AS category_rank FROM product_sales ORDER BY category,category_rank;

-- 7. Customer lifetime value: total delivered revenue per customer
SELECT c.customer_id,c.full_name,ROUND(COALESCE(SUM(oi.quantity*p.unit_price),0),2) AS lifetime_value FROM customers c LEFT JOIN orders o ON o.customer_id=c.customer_id AND o.status='delivered' LEFT JOIN order_items oi USING(order_id) LEFT JOIN products p USING(product_id) GROUP BY c.customer_id,c.full_name ORDER BY lifetime_value DESC;

-- 8. Repeat-customer percentage, based on customers with 2+ delivered orders
WITH per_customer AS (SELECT c.customer_id,COUNT(o.order_id) AS delivered_orders FROM customers c LEFT JOIN orders o ON o.customer_id=c.customer_id AND o.status='delivered' GROUP BY c.customer_id)
SELECT ROUND(100.0*SUM(delivered_orders>=2)/NULLIF(COUNT(*),0),2) AS repeat_customer_percentage FROM per_customer;

-- 9. Delivered revenue by customer city
SELECT c.city,ROUND(SUM(oi.quantity*p.unit_price),2) AS revenue FROM customers c JOIN orders o USING(customer_id) JOIN order_items oi USING(order_id) JOIN products p USING(product_id) WHERE o.status='delivered' GROUP BY c.city ORDER BY revenue DESC;

-- 10. Order status distribution
SELECT status,COUNT(*) AS order_count,ROUND(100.0*COUNT(*)/(SELECT COUNT(*) FROM orders),2) AS percentage FROM orders GROUP BY status ORDER BY order_count DESC;

-- 11. Low stock products (fewer than 10 units)
SELECT product_id,product_name,stock_quantity FROM products WHERE stock_quantity<10 ORDER BY stock_quantity;

-- 12. Orders whose value is above the average order value (all statuses)
WITH order_totals AS (SELECT o.order_id,o.status,SUM(oi.quantity*p.unit_price) AS order_value FROM orders o JOIN order_items oi USING(order_id) JOIN products p USING(product_id) GROUP BY o.order_id,o.status)
SELECT order_id,status,ROUND(order_value,2) AS order_value FROM order_totals WHERE order_value>(SELECT AVG(order_value) FROM order_totals) ORDER BY order_value DESC;

-- 13. Cumulative delivered revenue by date
WITH daily AS (SELECT o.order_date,SUM(oi.quantity*p.unit_price) AS revenue FROM orders o JOIN order_items oi USING(order_id) JOIN products p USING(product_id) WHERE o.status='delivered' GROUP BY o.order_date)
SELECT order_date,ROUND(revenue,2) AS daily_revenue,ROUND(SUM(revenue) OVER(ORDER BY order_date ROWS UNBOUNDED PRECEDING),2) AS cumulative_revenue FROM daily ORDER BY order_date;

-- 14. Reusable view: one row per order with its calculated total
CREATE OR REPLACE VIEW v_order_summary AS SELECT o.order_id,o.customer_id,c.full_name,o.order_date,o.status,ROUND(SUM(oi.quantity*p.unit_price),2) AS order_total FROM orders o JOIN customers c USING(customer_id) JOIN order_items oi USING(order_id) JOIN products p USING(product_id) GROUP BY o.order_id,o.customer_id,c.full_name,o.order_date,o.status;
SELECT * FROM v_order_summary ORDER BY order_date,order_id;
