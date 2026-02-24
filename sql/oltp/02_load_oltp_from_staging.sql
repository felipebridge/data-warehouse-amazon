INSERT IGNORE INTO oltp_amazon.oltp_categories (category_name)
SELECT DISTINCT TRIM(category)
FROM staging_amazon.stg_orders_raw
WHERE category IS NOT NULL AND TRIM(category) <> '';

INSERT IGNORE INTO oltp_amazon.oltp_payment_methods (payment_method)
SELECT DISTINCT TRIM(payment_method)
FROM staging_amazon.stg_orders_raw
WHERE payment_method IS NOT NULL AND TRIM(payment_method) <> '';

INSERT IGNORE INTO oltp_amazon.oltp_order_status (status)
SELECT DISTINCT TRIM(status)
FROM staging_amazon.stg_orders_raw
WHERE status IS NOT NULL AND TRIM(status) <> '';


INSERT IGNORE INTO oltp_amazon.oltp_products (item_id, sku, category_id)
SELECT DISTINCT
  CAST(NULLIF(TRIM(s.item_id), '') AS UNSIGNED) AS item_id_num,
  TRIM(s.sku) AS sku,
  c.category_id
FROM staging_amazon.stg_orders_raw s
JOIN oltp_amazon.oltp_categories c
  ON c.category_name = TRIM(s.category)
WHERE s.sku IS NOT NULL AND TRIM(s.sku) <> '';

INSERT IGNORE INTO oltp_amazon.oltp_addresses (place_name, county, city, state, zip, region)
SELECT DISTINCT
  NULLIF(TRIM(place_name), ''),
  NULLIF(TRIM(county), ''),
  NULLIF(TRIM(city), ''),
  NULLIF(TRIM(state), ''),
  NULLIF(TRIM(zip), ''),
  NULLIF(TRIM(region), '')
FROM staging_amazon.stg_orders_raw;

INSERT IGNORE INTO oltp_amazon.oltp_customers (
  cust_id, name_prefix, first_name, middle_initial, last_name, full_name,
  gender, age, email, username, sign_in_date, phone
)
SELECT DISTINCT
  CAST(NULLIF(TRIM(cust_id), '') AS UNSIGNED) AS cust_id_num,
  NULLIF(TRIM(name_prefix), ''),
  NULLIF(TRIM(first_name), ''),
  NULLIF(TRIM(middle_initial), ''),
  NULLIF(TRIM(last_name), ''),
  NULLIF(TRIM(full_name), ''),
  NULLIF(TRIM(gender), ''),
  CAST(NULLIF(TRIM(age), '') AS UNSIGNED) AS age_num,
  NULLIF(TRIM(email), ''),
  NULLIF(TRIM(user_name), ''),
  STR_TO_DATE(NULLIF(TRIM(sign_in_date), ''), '%d/%m/%Y') AS sign_in_dt,
  NULLIF(TRIM(phone_no), '')
FROM staging_amazon.stg_orders_raw
WHERE cust_id IS NOT NULL AND TRIM(cust_id) <> '';


INSERT IGNORE INTO oltp_amazon.oltp_orders (
  order_id, order_date, customer_id, status_id, payment_method_id,
  shipping_address_id, ref_num, year, month
)
SELECT
  TRIM(s.order_id) AS order_id,
  STR_TO_DATE(NULLIF(TRIM(s.order_date), ''), '%d/%m/%Y') AS order_dt,
  cu.customer_id,
  st.status_id,
  pm.payment_method_id,
  a.address_id,
  NULLIF(TRIM(s.ref_num), ''),
  CAST(NULLIF(TRIM(s.year), '') AS UNSIGNED),
  CAST(NULLIF(TRIM(s.month), '') AS UNSIGNED)
FROM (
  SELECT DISTINCT
    order_id, order_date, cust_id, status, payment_method, ref_num, year, month,
    place_name, county, city, state, zip, region
  FROM staging_amazon.stg_orders_raw
  WHERE order_id IS NOT NULL AND TRIM(order_id) <> ''
) s
JOIN oltp_amazon.oltp_customers cu
  ON cu.cust_id = CAST(NULLIF(TRIM(s.cust_id), '') AS UNSIGNED)
JOIN oltp_amazon.oltp_order_status st
  ON st.status = TRIM(s.status)
JOIN oltp_amazon.oltp_payment_methods pm
  ON pm.payment_method = TRIM(s.payment_method)
LEFT JOIN oltp_amazon.oltp_addresses a
  ON a.place_name <=> NULLIF(TRIM(s.place_name), '')
 AND a.county     <=> NULLIF(TRIM(s.county), '')
 AND a.city       <=> NULLIF(TRIM(s.city), '')
 AND a.state      <=> NULLIF(TRIM(s.state), '')
 AND a.zip        <=> NULLIF(TRIM(s.zip), '')
 AND a.region     <=> NULLIF(TRIM(s.region), '');


INSERT IGNORE INTO oltp_amazon.oltp_order_items (
  order_pk, product_id, qty_ordered, price, value, discount_amount, total, discount_percent
)
SELECT
  o.order_pk,
  p.product_id,
  CAST(NULLIF(TRIM(s.qty_ordered), '') AS UNSIGNED),
  CAST(NULLIF(TRIM(s.price), '') AS DECIMAL(12,2)),
  CAST(NULLIF(TRIM(s.value), '') AS DECIMAL(12,2)),
  CAST(NULLIF(TRIM(s.discount_amount), '') AS DECIMAL(12,2)),
  CAST(NULLIF(TRIM(s.total), '') AS DECIMAL(12,2)),
  CAST(NULLIF(TRIM(s.discount_percent), '') AS DECIMAL(6,2))
FROM staging_amazon.stg_orders_raw s
JOIN oltp_amazon.oltp_orders o
  ON o.order_id = TRIM(s.order_id)
JOIN oltp_amazon.oltp_products p
  ON p.sku = TRIM(s.sku)
WHERE s.order_id IS NOT NULL AND TRIM(s.order_id) <> ''
  AND s.sku IS NOT NULL AND TRIM(s.sku) <> '';