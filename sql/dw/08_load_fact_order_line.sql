USE dw_amazon;

-- FACT ORDER LINE

INSERT INTO fact_order_line (
  order_id,
  date_key,
  product_key,
  customer_key,
  geography_key,
  payment_method_key,
  status_key,
  qty_ordered,
  gross_value,
  discount_amount,
  net_total
)
SELECT
  o.order_id,

  -- dim_date
  d.date_key,

  -- dim_product
  dp.product_key,

  -- dim_customer
  dc.customer_key,

  -- dim_geography 
  dg.geography_key,

  -- dim_payment_method
  dpm.payment_method_key,

  -- dim_order_status
  dos.status_key,

  -- measures
  oi.qty_ordered,
  oi.value        AS gross_value,
  oi.discount_amount,
  oi.total        AS net_total

FROM oltp_amazon.oltp_order_items oi
JOIN oltp_amazon.oltp_orders o
  ON o.order_pk = oi.order_pk

JOIN oltp_amazon.oltp_products p
  ON p.product_id = oi.product_id
JOIN oltp_amazon.oltp_categories c
  ON c.category_id = p.category_id

JOIN oltp_amazon.oltp_customers cu
  ON cu.customer_id = o.customer_id

JOIN oltp_amazon.oltp_payment_methods pm
  ON pm.payment_method_id = o.payment_method_id

JOIN oltp_amazon.oltp_order_status os
  ON os.status_id = o.status_id

LEFT JOIN oltp_amazon.oltp_addresses a
  ON a.address_id = o.shipping_address_id


-- Joins a DIMENSIONES


JOIN dw_amazon.dim_date d
  ON d.full_date = o.order_date

JOIN dw_amazon.dim_product dp
  ON dp.sku = p.sku

JOIN dw_amazon.dim_customer dc
  ON dc.cust_id = cu.cust_id

JOIN dw_amazon.dim_payment_method dpm
  ON dpm.payment_method = pm.payment_method

JOIN dw_amazon.dim_order_status dos
  ON dos.status = os.status

LEFT JOIN dw_amazon.dim_geography dg
  ON dg.region <=> a.region
 AND dg.state  <=> a.state
 AND dg.city   <=> a.city
 AND dg.zip    <=> a.zip
 AND dg.county <=> a.county
 AND dg.place_name <=> a.place_name
;