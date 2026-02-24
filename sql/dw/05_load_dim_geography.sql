USE dw_amazon;

INSERT INTO dim_geography (region, state, city, zip, county, place_name)
SELECT DISTINCT
  a.region,
  a.state,
  a.city,
  a.zip,
  a.county,
  a.place_name
FROM oltp_amazon.oltp_addresses a
WHERE
  COALESCE(
    NULLIF(TRIM(a.region),''),
    NULLIF(TRIM(a.state),''),
    NULLIF(TRIM(a.city),''),
    NULLIF(TRIM(a.zip),'')
  ) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1
    FROM dw_amazon.dim_geography g
    WHERE g.region <=> a.region
      AND g.state <=> a.state
      AND g.city <=> a.city
      AND g.zip <=> a.zip
      AND g.county <=> a.county
      AND g.place_name <=> a.place_name
  );