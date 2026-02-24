CREATE DATABASE IF NOT EXISTS oltp_amazon;
USE oltp_amazon;

CREATE TABLE IF NOT EXISTS oltp_categories (
  category_id INT AUTO_INCREMENT PRIMARY KEY,
  category_name VARCHAR(100) NOT NULL,
  UNIQUE KEY uq_category_name (category_name)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS oltp_payment_methods (
  payment_method_id INT AUTO_INCREMENT PRIMARY KEY,
  payment_method VARCHAR(50) NOT NULL,
  UNIQUE KEY uq_payment_method (payment_method)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS oltp_order_status (
  status_id INT AUTO_INCREMENT PRIMARY KEY,
  status VARCHAR(50) NOT NULL,
  UNIQUE KEY uq_status (status)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS oltp_products (
  product_id INT AUTO_INCREMENT PRIMARY KEY,
  item_id INT NOT NULL,
  sku VARCHAR(100) NOT NULL,
  category_id INT NOT NULL,
  UNIQUE KEY uq_sku (sku),
  KEY idx_category_id (category_id),
  CONSTRAINT fk_products_category
    FOREIGN KEY (category_id) REFERENCES oltp_categories(category_id)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS oltp_addresses (
  address_id INT AUTO_INCREMENT PRIMARY KEY,
  place_name VARCHAR(100),
  county VARCHAR(100),
  city VARCHAR(100),
  state VARCHAR(50),
  zip VARCHAR(20),
  region VARCHAR(50),
  UNIQUE KEY uq_address (place_name, county, city, state, zip, region)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS oltp_customers (
  customer_id INT AUTO_INCREMENT PRIMARY KEY,
  cust_id INT NOT NULL,
  name_prefix VARCHAR(20),
  first_name VARCHAR(50),
  middle_initial VARCHAR(10),
  last_name VARCHAR(50),
  full_name VARCHAR(150),
  gender VARCHAR(20),
  age INT,
  email VARCHAR(120),
  username VARCHAR(80),
  sign_in_date DATE,
  phone VARCHAR(30),
  UNIQUE KEY uq_cust_id (cust_id)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS oltp_orders (
  order_pk INT AUTO_INCREMENT PRIMARY KEY,
  order_id VARCHAR(30) NOT NULL,
  order_date DATE NOT NULL,
  customer_id INT NOT NULL,
  status_id INT NOT NULL,
  payment_method_id INT NOT NULL,
  shipping_address_id INT,
  ref_num VARCHAR(50),
  year SMALLINT,
  month TINYINT,
  UNIQUE KEY uq_order_id (order_id),
  KEY idx_order_date (order_date),
  CONSTRAINT fk_orders_customer
    FOREIGN KEY (customer_id) REFERENCES oltp_customers(customer_id),
  CONSTRAINT fk_orders_status
    FOREIGN KEY (status_id) REFERENCES oltp_order_status(status_id),
  CONSTRAINT fk_orders_payment
    FOREIGN KEY (payment_method_id) REFERENCES oltp_payment_methods(payment_method_id),
  CONSTRAINT fk_orders_address
    FOREIGN KEY (shipping_address_id) REFERENCES oltp_addresses(address_id)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS oltp_order_items (
  order_item_id INT AUTO_INCREMENT PRIMARY KEY,
  order_pk INT NOT NULL,
  product_id INT NOT NULL,
  qty_ordered INT NOT NULL,
  price DECIMAL(12,2) NOT NULL,
  value DECIMAL(12,2) NOT NULL,
  discount_amount DECIMAL(12,2) NOT NULL,
  total DECIMAL(12,2) NOT NULL,
  discount_percent DECIMAL(6,2),
  KEY idx_order_pk (order_pk),
  KEY idx_product_id (product_id),
  CONSTRAINT fk_items_order
    FOREIGN KEY (order_pk) REFERENCES oltp_orders(order_pk),
  CONSTRAINT fk_items_product
    FOREIGN KEY (product_id) REFERENCES oltp_products(product_id)
) ENGINE=InnoDB;