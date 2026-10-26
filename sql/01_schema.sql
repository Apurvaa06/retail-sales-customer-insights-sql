-- Retail Sales & Customer Insights | MySQL 8.0
CREATE DATABASE IF NOT EXISTS retail_sales;
USE retail_sales;

CREATE TABLE IF NOT EXISTS customers (
  customer_id VARCHAR(10) PRIMARY KEY, full_name VARCHAR(100) NOT NULL,
  email VARCHAR(150) NOT NULL UNIQUE, city VARCHAR(80) NOT NULL,
  state VARCHAR(80) NOT NULL, signup_date DATE NOT NULL,
  INDEX idx_customers_city (city)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS products (
  product_id VARCHAR(10) PRIMARY KEY, product_name VARCHAR(120) NOT NULL,
  category VARCHAR(80) NOT NULL, unit_price DECIMAL(10,2) NOT NULL CHECK (unit_price >= 0),
  stock_quantity INT NOT NULL CHECK (stock_quantity >= 0),
  INDEX idx_products_category (category)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS orders (
  order_id VARCHAR(10) PRIMARY KEY, customer_id VARCHAR(10) NOT NULL,
  order_date DATE NOT NULL, status ENUM('processing','shipped','delivered','cancelled','returned') NOT NULL,
  CONSTRAINT fk_orders_customer FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
  INDEX idx_orders_customer_date (customer_id, order_date),
  INDEX idx_orders_date_status (order_date, status)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS order_items (
  order_item_id INT AUTO_INCREMENT PRIMARY KEY, order_id VARCHAR(10) NOT NULL,
  product_id VARCHAR(10) NOT NULL, quantity INT NOT NULL CHECK (quantity > 0),
  CONSTRAINT fk_items_order FOREIGN KEY (order_id) REFERENCES orders(order_id),
  CONSTRAINT fk_items_product FOREIGN KEY (product_id) REFERENCES products(product_id),
  UNIQUE KEY uq_order_product (order_id, product_id), INDEX idx_items_product (product_id)
) ENGINE=InnoDB;
