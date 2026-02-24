USE dw_amazon;

INSERT IGNORE INTO dim_payment_method (payment_method)
SELECT pm.payment_method
FROM oltp_amazon.oltp_payment_methods pm
WHERE pm.payment_method IS NOT NULL AND TRIM(pm.payment_method) <> '';