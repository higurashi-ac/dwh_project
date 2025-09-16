-- =====================================================
-- Dimension table for Partner
-- =====================================================
CREATE SCHEMA IF NOT EXISTS dwh;

CREATE TABLE IF NOT EXISTS dwh.dim_partner (
    partner_sk SERIAL PRIMARY KEY,
    partner_id INT UNIQUE, -- business key from Odoo
    partner_name TEXT,
    partner_type TEXT, -- 'customer', 'supplier', 'both', or 'unknown'
    street TEXT,
    street2 TEXT,
    street_name TEXT,
    street_number TEXT,
    street_number2 TEXT,
    zip TEXT,
    city TEXT,
    email TEXT,
    email_normalized TEXT,
    phone TEXT,
    mobile TEXT,
    is_company BOOLEAN,
    commercial_company_name TEXT,
    create_date TIMESTAMP,
    write_date TIMESTAMP,
    stg_loaded_at TIMESTAMP,
    stg_batch_id VARCHAR
);

-- =====================================================
-- FULL LOAD (truncate + reload)
-- Use this for initial backfill
-- =====================================================
-- TRUNCATE dwh.dim_partner;

-- INSERT INTO dwh.dim_partner (
--     partner_id,
--     partner_name,
--     partner_type,
--     street,
--     street2,
--     street_name,
--     street_number,
--     street_number2,
--     zip,
--     city,
--     email,
--     email_normalized,
--     phone,
--     mobile,
--     is_company,
--     commercial_company_name,
--     create_date,
--     write_date,
--     stg_loaded_at,
--     stg_batch_id
-- )
-- WITH customer_ids AS (
--     SELECT DISTINCT partner_id
--     FROM stg.sale_order
-- ),
-- supplier_ids AS (
--     SELECT DISTINCT partner_id
--     FROM stg.purchase_order
-- )
-- SELECT 
--     rp.id AS partner_id,
--     rp.name AS partner_name,
--     CASE 
--         WHEN c.partner_id IS NOT NULL AND s.partner_id IS NOT NULL THEN 'both'
--         WHEN c.partner_id IS NOT NULL THEN 'customer'
--         WHEN s.partner_id IS NOT NULL THEN 'supplier'
--         ELSE 'unknown'
--     END AS partner_type,
--     rp.street,
--     rp.street2,
--     rp.street_name,
--     rp.street_number,
--     rp.street_number2,
--     rp.zip,
--     rp.city,
--     rp.email,
--     rp.email_normalized,
--     rp.phone,
--     rp.mobile,
--     rp.is_company,
--     rp.commercial_company_name,
--     rp.create_date,
--     rp.write_date,
--     rp.stg_loaded_at,
--     rp.stg_batch_id
-- FROM stg.res_partner rp
-- LEFT JOIN customer_ids c ON rp.id = c.partner_id
-- LEFT JOIN supplier_ids s ON rp.id = s.partner_id;

-- =====================================================
-- INCREMENTAL UPSERT
-- Use this for near real-time updates
-- =====================================================
WITH customer_ids AS (
    SELECT DISTINCT partner_id
    FROM stg.sale_order
),
supplier_ids AS (
    SELECT DISTINCT partner_id
    FROM stg.purchase_order
)
INSERT INTO dwh.dim_partner (
    partner_id,
    partner_name,
    partner_type,
    street,
    street2,
    street_name,
    street_number,
    street_number2,
    zip,
    city,
    email,
    email_normalized,
    phone,
    mobile,
    is_company,
    commercial_company_name,
    create_date,
    write_date,
    stg_loaded_at,
    stg_batch_id
)
SELECT 
    rp.id AS partner_id,
    rp.name AS partner_name,
    CASE 
        WHEN c.partner_id IS NOT NULL AND s.partner_id IS NOT NULL THEN 'both'
        WHEN c.partner_id IS NOT NULL THEN 'customer'
        WHEN s.partner_id IS NOT NULL THEN 'supplier'
        ELSE 'unknown'
    END AS partner_type,
    rp.street,
    rp.street2,
    rp.street_name,
    rp.street_number,
    rp.street_number2,
    rp.zip,
    rp.city,
    rp.email,
    rp.email_normalized,
    rp.phone,
    rp.mobile,
    rp.is_company,
    rp.commercial_company_name,
    rp.create_date,
    rp.write_date,
    rp.stg_loaded_at,
    rp.stg_batch_id
FROM stg.res_partner rp
LEFT JOIN customer_ids c ON rp.id = c.partner_id
LEFT JOIN supplier_ids s ON rp.id = s.partner_id
ON CONFLICT (partner_id) DO UPDATE
SET
    partner_name = EXCLUDED.partner_name,
    partner_type = EXCLUDED.partner_type,
    street = EXCLUDED.street,
    street2 = EXCLUDED.street2,
    street_name = EXCLUDED.street_name,
    street_number = EXCLUDED.street_number,
    street_number2 = EXCLUDED.street_number2,
    zip = EXCLUDED.zip,
    city = EXCLUDED.city,
    email = EXCLUDED.email,
    email_normalized = EXCLUDED.email_normalized,
    phone = EXCLUDED.phone,
    mobile = EXCLUDED.mobile,
    is_company = EXCLUDED.is_company,
    commercial_company_name = EXCLUDED.commercial_company_name,
    create_date = EXCLUDED.create_date,
    write_date = EXCLUDED.write_date,
    stg_loaded_at = EXCLUDED.stg_loaded_at,
    stg_batch_id = EXCLUDED.stg_batch_id;
