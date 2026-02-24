USE dw_amazon;

INSERT IGNORE INTO dim_order_status (status)
SELECT os.status
FROM oltp_amazon.oltp_order_status os
WHERE os.status IS NOT NULL AND TRIM(os.status) <> '';