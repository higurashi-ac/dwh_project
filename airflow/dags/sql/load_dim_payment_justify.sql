-- =====================================================
-- Dimension table for payment_justify
-- =====================================================
CREATE SCHEMA IF NOT EXISTS dwh;

CREATE TABLE IF NOT EXISTS dwh.dim_payment_justify (
    payment_justify_sk SERIAL PRIMARY KEY,
    payment_justify_id INT UNIQUE,   -- BK
    name TEXT,
    mode_paiement TEXT,
    montant NUMERIC,
    date TIMESTAMP,
    client INT,                      -- link to dim_partner
    source TEXT,
    total NUMERIC,
    create_date TIMESTAMP,
    write_date TIMESTAMP,
    etat TEXT,
    moyen_paiement TEXT,
    attachment TEXT,
    user_id INT,                      -- link to dim_employee/user
    memo TEXT,
    date_paiement TIMESTAMP,
    planning INT,                     -- link to dim_planning_slot
    type_paiement TEXT,
    stg_loaded_at TIMESTAMP,
    stg_batch_id VARCHAR
);

-- =====================================================
-- FULL LOAD (truncate + reload)
-- Use this for initial backfill
-- =====================================================
-- TRUNCATE dwh.dim_payment_justify;

-- INSERT INTO dwh.dim_payment_justify (
--     payment_justify_id,
--     name,
--     mode_paiement,
--     montant,
--     date,
--     client,
--     source,
--     total,
--     create_date,
--     write_date,
--     etat,
--     moyen_paiement,
--     attachment,
--     user_id,
--     memo,
--     date_paiement,
--     planning,
--     type_paiement,
--     stg_loaded_at,
--     stg_batch_id
-- )
-- SELECT
--     id AS payment_justify_id,
--     name,
--     mode_paiement,
--     montant,
--     date,
--     client,
--     source,
--     total,
--     create_date,
--     write_date,
--     etat,
--     moyen_paiement,
--     attachment,
--     user_id,
--     memo,
--     date_paiement,
--     planning,
--     type_paiement,
--     stg_loaded_at,
--     stg_batch_id
-- FROM stg.payment_justify s;

-- =====================================================
-- INCREMENTAL UPSERT
-- Use this for near real-time updates
-- =====================================================
INSERT INTO dwh.dim_payment_justify (
    payment_justify_id,
    name,
    mode_paiement,
    montant,
    date,
    client,
    source,
    total,
    create_date,
    write_date,
    etat,
    moyen_paiement,
    attachment,
    user_id,
    memo,
    date_paiement,
    planning,
    type_paiement,
    stg_loaded_at,
    stg_batch_id
)
SELECT
    id AS payment_justify_id,
    name,
    mode_paiement,
    montant,
    date,
    client,
    source,
    total,
    create_date,
    write_date,
    etat,
    moyen_paiement,
    attachment,
    user_id,
    memo,
    date_paiement,
    planning,
    type_paiement,
    stg_loaded_at,
    stg_batch_id
FROM stg.payment_justify s
ON CONFLICT (payment_justify_id) DO UPDATE
SET
    name = EXCLUDED.name,
    mode_paiement = EXCLUDED.mode_paiement,
    montant = EXCLUDED.montant,
    date = EXCLUDED.date,
    client = EXCLUDED.client,
    source = EXCLUDED.source,
    total = EXCLUDED.total,
    create_date = EXCLUDED.create_date,
    write_date = EXCLUDED.write_date,
    etat = EXCLUDED.etat,
    moyen_paiement = EXCLUDED.moyen_paiement,
    attachment = EXCLUDED.attachment,
    user_id = EXCLUDED.user_id,
    memo = EXCLUDED.memo,
    date_paiement = EXCLUDED.date_paiement,
    planning = EXCLUDED.planning,
    type_paiement = EXCLUDED.type_paiement,
    stg_loaded_at = EXCLUDED.stg_loaded_at,
    stg_batch_id = EXCLUDED.stg_batch_id;
