-- =====================================================
-- Dimension table for purchase_order
-- =====================================================
CREATE SCHEMA IF NOT EXISTS dwh;

CREATE TABLE IF NOT EXISTS dwh.dim_purchase_order (
    purchase_order_sk SERIAL PRIMARY KEY,
    purchase_order_id INT UNIQUE,  -- BK from Odoo
    name TEXT,
    partner_ref TEXT,
    date_order TIMESTAMP,
    date_approve TIMESTAMP,
    partner_id INT,
    state TEXT,
    notes TEXT,
    invoice_count INT,
    invoice_status TEXT,
    date_planned TIMESTAMP,
    amount_untaxed NUMERIC,
    amount_tax NUMERIC,
    amount_total NUMERIC,
    user_id INT,
    create_date TIMESTAMP,
    write_date TIMESTAMP,
    note TEXT,
    adresse TEXT,
    stg_loaded_at TIMESTAMP,
    stg_batch_id VARCHAR
);

-- =====================================================
-- FULL LOAD (truncate + reload)
-- Use this for initial backfill
-- =====================================================
-- TRUNCATE dwh.dim_purchase_order;

-- INSERT INTO dwh.dim_purchase_order (
--     purchase_order_id,
--     name,
--     partner_ref,
--     date_order,
--     date_approve,
--     partner_id,
--     state,
--     notes,
--     invoice_count,
--     invoice_status,
--     date_planned,
--     amount_untaxed,
--     amount_tax,
--     amount_total,
--     user_id,
--     create_date,
--     write_date,
--     note,
--     adresse,
--     stg_loaded_at,
--     stg_batch_id
-- )
-- SELECT
--     id AS purchase_order_id,
--     name,
--     partner_ref,
--     date_order,
--     date_approve,
--     partner_id,
--     state,
--     notes,
--     invoice_count,
--     invoice_status,
--     date_planned,
--     amount_untaxed,
--     amount_tax,
--     amount_total,
--     user_id,
--     create_date,
--     write_date,
--     note,
--     adresse,
--     stg_loaded_at,
--     stg_batch_id
-- FROM stg.purchase_order s;

-- =====================================================
-- INCREMENTAL UPSERT
-- Use this for near real-time updates
-- =====================================================
INSERT INTO dwh.dim_purchase_order (
    purchase_order_id,
    name,
    partner_ref,
    date_order,
    date_approve,
    partner_id,
    state,
    notes,
    invoice_count,
    invoice_status,
    date_planned,
    amount_untaxed,
    amount_tax,
    amount_total,
    user_id,
    create_date,
    write_date,
    note,
    adresse,
    stg_loaded_at,
    stg_batch_id
)
SELECT
    id AS purchase_order_id,
    name,
    partner_ref,
    date_order,
    date_approve,
    partner_id,
    state,
    notes,
    invoice_count,
    invoice_status,
    date_planned,
    amount_untaxed,
    amount_tax,
    amount_total,
    user_id,
    create_date,
    write_date,
    note,
    adresse,
    stg_loaded_at,
    stg_batch_id
FROM stg.purchase_order s
ON CONFLICT (purchase_order_id) DO UPDATE
SET
    name = EXCLUDED.name,
    partner_ref = EXCLUDED.partner_ref,
    date_order = EXCLUDED.date_order,
    date_approve = EXCLUDED.date_approve,
    partner_id = EXCLUDED.partner_id,
    state = EXCLUDED.state,
    notes = EXCLUDED.notes,
    invoice_count = EXCLUDED.invoice_count,
    invoice_status = EXCLUDED.invoice_status,
    date_planned = EXCLUDED.date_planned,
    amount_untaxed = EXCLUDED.amount_untaxed,
    amount_tax = EXCLUDED.amount_tax,
    amount_total = EXCLUDED.amount_total,
    user_id = EXCLUDED.user_id,
    create_date = EXCLUDED.create_date,
    write_date = EXCLUDED.write_date,
    note = EXCLUDED.note,
    adresse = EXCLUDED.adresse,
    stg_loaded_at = EXCLUDED.stg_loaded_at,
    stg_batch_id = EXCLUDED.stg_batch_id;
