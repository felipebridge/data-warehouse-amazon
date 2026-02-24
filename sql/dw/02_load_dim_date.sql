USE dw_amazon;

INSERT IGNORE INTO dim_date (
  date_key,
  full_date,
  day,
  month,
  month_name,
  quarter,
  year
)
SELECT DISTINCT
  DATE_FORMAT(o.order_date, '%Y%m%d') + 0 AS date_key,
  o.order_date AS full_date,
  DAY(o.order_date) AS day,
  MONTH(o.order_date) AS month,
  MONTHNAME(o.order_date) AS month_name,
  QUARTER(o.order_date) AS quarter,
  YEAR(o.order_date) AS year
FROM oltp_amazon.oltp_orders o
WHERE o.order_date IS NOT NULL;