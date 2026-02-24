CREATE DATABASE IF NOT EXISTS dw_amazon;
USE dw_amazon;


-- DIMENSIONES

CREATE TABLE IF NOT EXISTS dim_date (
  date_key INT PRIMARY KEY,            
  full_date DATE NOT NULL,
  day TINYINT NOT NULL,
  month TINYINT NOT NULL,
  month_name VARCHAR(15) NOT NULL,
  quarter TINYINT NOT NULL,
  year SMALLINT NOT NULL,
  UNIQUE KEY uq_full_date (full_date),
  KEY idx_year_month (year, month)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS dim_product (
  product_key INT AUTO_INCREMENT PRIMARY KEY,
  sku VARCHAR(100) NOT NULL,
  item_id INT,
  category VARCHAR(100),
  UNIQUE KEY uq_sku (sku),
  KEY idx_category (category)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS dim_customer (
  customer_key INT AUTO_INCREMENT PRIMARY KEY,
  cust_id INT NOT NULL,
  full_name VARCHAR(200),
  gender VARCHAR(20),
  age INT,
  age_group VARCHAR(20),
  sign_in_date DATE,
  UNIQUE KEY uq_cust_id (cust_id),
  KEY idx_gender_agegroup (gender, age_group)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS dim_geography (
  geography_key INT AUTO_INCREMENT PRIMARY KEY,
  region VARCHAR(100),
  state VARCHAR(100),
  city VARCHAR(100),
  zip VARCHAR(30),
  county VARCHAR(120),
  place_name VARCHAR(120),
  KEY idx_geo_hierarchy (region, state, city)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS dim_payment_method (
  payment_method_key INT AUTO_INCREMENT PRIMARY KEY,
  payment_method VARCHAR(50) NOT NULL,
  UNIQUE KEY uq_payment_method (payment_method)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS dim_order_status (
  status_key INT AUTO_INCREMENT PRIMARY KEY,
  status VARCHAR(50) NOT NULL,
  UNIQUE KEY uq_status (status)
) ENGINE=InnoDB;


-- FACT

CREATE TABLE IF NOT EXISTS fact_order_line (
  fact_id BIGINT AUTO_INCREMENT PRIMARY KEY,

  order_id VARCHAR(30) NOT NULL,

  date_key INT NOT NULL,
  product_key INT NOT NULL,
  customer_key INT NOT NULL,
  geography_key INT,
  payment_method_key INT NOT NULL,
  status_key INT NOT NULL,

  qty_ordered INT NOT NULL,
  gross_value DECIMAL(12,2) NOT NULL,
  discount_amount DECIMAL(12,2) NOT NULL,
  net_total DECIMAL(12,2) NOT NULL,

  KEY idx_date_key (date_key),
  KEY idx_product_key (product_key),
  KEY idx_customer_key (customer_key),
  KEY idx_geo_key (geography_key),
  KEY idx_payment_key (payment_method_key),
  KEY idx_status_key (status_key),

  CONSTRAINT fk_fact_date FOREIGN KEY (date_key) REFERENCES dim_date(date_key),
  CONSTRAINT fk_fact_product FOREIGN KEY (product_key) REFERENCES dim_product(product_key),
  CONSTRAINT fk_fact_customer FOREIGN KEY (customer_key) REFERENCES dim_customer(customer_key),
  CONSTRAINT fk_fact_geo FOREIGN KEY (geography_key) REFERENCES dim_geography(geography_key),
  CONSTRAINT fk_fact_payment FOREIGN KEY (payment_method_key) REFERENCES dim_payment_method(payment_method_key),
  CONSTRAINT fk_fact_status FOREIGN KEY (status_key) REFERENCES dim_order_status(status_key)
) ENGINE=InnoDB;