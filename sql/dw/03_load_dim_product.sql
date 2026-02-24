USE dw_amazon;


INSERT IGNORE INTO dim_product (sku, item_id, category)
SELECT
  p.sku,
  p.item_id,
  c.category_name AS category
FROM oltp_amazon.oltp_products p
JOIN oltp_amazon.oltp_categories c
  ON c.category_id = p.category_id
WHERE p.sku IS NOT NULL AND TRIM(p.sku) <> '';