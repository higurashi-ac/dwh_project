-- =====================================================
-- Dimension table for purchase_order_line
-- =====================================================
CREATE SCHEMA IF NOT EXISTS dwh;

CREATE TABLE IF NOT EXISTS dwh.dim_purchase_order_line (
    purchase_order_line_sk SERIAL PRIMARY KEY,
    purchase_order_line_id INT UNIQUE,  -- BK Odoo
    purchase_order_id INT,              -- links to dim_purchase_order
    state TEXT,
    name TEXT,
    sequence INT,
    product_qty NUMERIC,
    date_planned TIMESTAMP,
    product_uom TEXT,
    product_id INT,
    price_unit NUMERIC,
    price_subtotal NUMERIC,
    price_total NUMERIC,
    price_tax NUMERIC,
    net_price_pur NUMERIC,
    create_date TIMESTAMP,
    write_date TIMESTAMP,
    stg_loaded_at TIMESTAMP,
    stg_batch_id VARCHAR
);

-- =====================================================
-- FULL LOAD (truncate + reload)
-- Use this for initial backfill
-- =====================================================
-- TRUNCATE dwh.dim_purchase_order_line;

-- INSERT INTO dwh.dim_purchase_order_line (
--     purchase_order_line_id,
--     purchase_order_id,
--     state,
--     name,
--     sequence,
--     product_qty,
--     date_planned,
--     product_uom,
--     product_id,
--     price_unit,
--     price_subtotal,
--     price_total,
--     price_tax,
--     net_price_pur,
--     create_date,
--     write_date,
--     stg_loaded_at,
--     stg_batch_id
-- )
-- SELECT
--     id AS purchase_order_line_id,
--     purchase_order_id,
--     state,
--     name,
--     sequence,
--     product_qty,
--     date_planned,
--     product_uom,
--     product_id,
--     price_unit,
--     price_subtotal,
--     price_total,
--     price_tax,
--     net_price_pur,
--     create_date,
--     write_date,
--     stg_loaded_at,
--     stg_batch_id
-- FROM stg.purchase_order_line s;

-- =====================================================
-- INCREMENTAL UPSERT
-- Use this for near real-time updates
-- =====================================================
INSERT INTO dwh.dim_purchase_order_line (
    purchase_order_line_id,
    purchase_order_id,
    state,
    name,
    sequence,
    product_qty,
    date_planned,
    product_uom,
    product_id,
    price_unit,
    price_subtotal,
    price_total,
    price_tax,
    net_price_pur,
    create_date,
    write_date,
    stg_loaded_at,
    stg_batch_id
)
SELECT
    id AS purchase_order_line_id,
    purchase_order_id,
    state,
    name,
    sequence,
    product_qty,
    date_planned,
    product_uom,
    product_id,
    price_unit,
    price_subtotal,
    price_total,
    price_tax,
    net_price_pur,
    create_date,
    write_date,
    stg_loaded_at,
    stg_batch_id
FROM stg.purchase_order_line s
ON CONFLICT (purchase_order_line_id) DO UPDATE
SET
    purchase_order_id = EXCLUDED.purchase_order_id,
    state = EXCLUDED.state,
    name = EXCLUDED.name,
    sequence = EXCLUDED.sequence,
    product_qty = EXCLUDED.product_qty,
    date_planned = EXCLUDED.date_planned,
    product_uom = EXCLUDED.product_uom,
    product_id = EXCLUDED.product_id,
    price_unit = EXCLUDED.price_unit,
    price_subtotal = EXCLUDED.price_subtotal,
    price_total = EXCLUDED.price_total,
    price_tax = EXCLUDED.price_tax,
    net_price_pur = EXCLUDED.net_price_pur,
    create_date = EXCLUDED.create_date,
    write_date = EXCLUDED.write_date,
    stg_loaded_at = EXCLUDED.stg_loaded_at,
    stg_batch_id = EXCLUDED.stg_batch_id;
