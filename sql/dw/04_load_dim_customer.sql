USE dw_amazon;

INSERT IGNORE INTO dim_customer (cust_id, full_name, gender, age, age_group, sign_in_date)
SELECT
  cu.cust_id,
  cu.full_name,
  cu.gender,
  cu.age,
  CASE
    WHEN cu.age IS NULL THEN 'Unknown'
    WHEN cu.age < 18 THEN '<18'
    WHEN cu.age BETWEEN 18 AND 24 THEN '18-24'
    WHEN cu.age BETWEEN 25 AND 34 THEN '25-34'
    WHEN cu.age BETWEEN 35 AND 44 THEN '35-44'
    WHEN cu.age BETWEEN 45 AND 54 THEN '45-54'
    WHEN cu.age BETWEEN 55 AND 64 THEN '55-64'
    ELSE '65+'
  END AS age_group,
  cu.sign_in_date
FROM oltp_amazon.oltp_customers cu
WHERE cu.cust_id IS NOT NULL;