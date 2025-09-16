-- =====================================================
-- Dimension table for planning_slot
-- =====================================================
CREATE SCHEMA IF NOT EXISTS dwh;

CREATE TABLE IF NOT EXISTS dwh.dim_planning_slot (
    planning_slot_sk SERIAL PRIMARY KEY,
    planning_slot_id INT UNIQUE,   -- Odoo ID
    name_seq TEXT,
    type_intervention TEXT,
    my_image TEXT,                 -- to think about this later
    rapport TEXT,
    remarque TEXT,
    employee_id INT,               -- link to dim_employee
    user_id INT,                   -- link to user dimension (am still thinking about whether integrate this or not)
    partner_id INT,                -- link to dim_partner
    company_id INT,
    start_datetime TIMESTAMP,
    end_datetime TIMESTAMP,
    allocated_hours NUMERIC,
    create_date TIMESTAMP,
    write_date TIMESTAMP,
    state TEXT,
    motif TEXT,
    parent_id INT,                 -- potential self-reference
    ville_client TEXT,
    region_client TEXT,
    stg_loaded_at TIMESTAMP,
    stg_batch_id VARCHAR
);

-- =====================================================
-- FULL LOAD (truncate + reload)
-- Use this for initial backfill
-- =====================================================
-- TRUNCATE dwh.dim_planning_slot;

-- INSERT INTO dwh.dim_planning_slot (
--     planning_slot_id,
--     name_seq,
--     type_intervention,
--     my_image,
--     rapport,
--     remarque,
--     employee_id,
--     user_id,
--     partner_id,
--     company_id,
--     start_datetime,
--     end_datetime,
--     allocated_hours,
--     create_date,
--     write_date,
--     state,
--     motif,
--     parent_id,
--     ville_client,
--     region_client,
--     stg_loaded_at,
--     stg_batch_id
-- )
-- SELECT
--     id AS planning_slot_id,
--     name_seq,
--     type_intervention,
--     my_image,
--     rapport,
--     remarque,
--     employee_id,
--     user_id,
--     partner_id,
--     company_id,
--     start_datetime,
--     end_datetime,
--     allocated_hours,
--     create_date,
--     write_date,
--     state,
--     motif,
--     parent_id,
--     ville_client,
--     region_client,
--     stg_loaded_at,
--     stg_batch_id
-- FROM stg.planning_slot s;

-- =====================================================
-- INCREMENTAL UPSERT
-- Use this for near real-time updates
-- =====================================================
INSERT INTO dwh.dim_planning_slot (
    planning_slot_id,
    name_seq,
    type_intervention,
    my_image,
    rapport,
    remarque,
    employee_id,
    user_id,
    partner_id,
    company_id,
    start_datetime,
    end_datetime,
    allocated_hours,
    create_date,
    write_date,
    state,
    motif,
    parent_id,
    ville_client,
    region_client,
    stg_loaded_at,
    stg_batch_id
)
SELECT
    id AS planning_slot_id,
    name_seq,
    type_intervention,
    my_image,
    rapport,
    remarque,
    employee_id,
    user_id,
    partner_id,
    company_id,
    start_datetime,
    end_datetime,
    allocated_hours,
    create_date,
    write_date,
    state,
    motif,
    parent_id,
    ville_client,
    region_client,
    stg_loaded_at,
    stg_batch_id
FROM stg.planning_slot s
ON CONFLICT (planning_slot_id) DO UPDATE
SET
    name_seq = EXCLUDED.name_seq,
    type_intervention = EXCLUDED.type_intervention,
    my_image = EXCLUDED.my_image,
    rapport = EXCLUDED.rapport,
    remarque = EXCLUDED.remarque,
    employee_id = EXCLUDED.employee_id,
    user_id = EXCLUDED.user_id,
    partner_id = EXCLUDED.partner_id,
    company_id = EXCLUDED.company_id,
    start_datetime = EXCLUDED.start_datetime,
    end_datetime = EXCLUDED.end_datetime,
    allocated_hours = EXCLUDED.allocated_hours,
    create_date = EXCLUDED.create_date,
    write_date = EXCLUDED.write_date,
    state = EXCLUDED.state,
    motif = EXCLUDED.motif,
    parent_id = EXCLUDED.parent_id,
    ville_client = EXCLUDED.ville_client,
    region_client = EXCLUDED.region_client,
    stg_loaded_at = EXCLUDED.stg_loaded_at,
    stg_batch_id = EXCLUDED.stg_batch_id;
