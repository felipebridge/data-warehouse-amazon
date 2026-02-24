
CREATE DATABASE IF NOT EXISTS staging_amazon;
USE staging_amazon;

CREATE TABLE IF NOT EXISTS stg_orders_raw (
  row_id BIGINT AUTO_INCREMENT PRIMARY KEY,

  order_id            VARCHAR(50),
  order_date          VARCHAR(50),
  status              VARCHAR(50),
  item_id             VARCHAR(50),
  sku                 VARCHAR(100),
  qty_ordered         VARCHAR(50),
  price               VARCHAR(50),
  value               VARCHAR(50),
  discount_amount     VARCHAR(50),
  total               VARCHAR(50),
  category            VARCHAR(100),
  payment_method      VARCHAR(50),
  bi_st               VARCHAR(50),
  cust_id             VARCHAR(50),
  year                VARCHAR(10),
  month               VARCHAR(10),
  ref_num             VARCHAR(100),

  name_prefix         VARCHAR(50),
  first_name          VARCHAR(80),
  middle_initial      VARCHAR(50),
  last_name           VARCHAR(80),

  gender              VARCHAR(20),
  age                 VARCHAR(20),
  full_name           VARCHAR(200),

  email               VARCHAR(150),
  sign_in_date        VARCHAR(50),
  phone_no            VARCHAR(50),
  user_name           VARCHAR(100),

  zip                 VARCHAR(30),
  city                VARCHAR(100),
  state               VARCHAR(100),
  region              VARCHAR(100),
  county              VARCHAR(120),
  place_name          VARCHAR(120)
);