-- =====================================================
-- Dimension table for employee
-- =====================================================
CREATE SCHEMA IF NOT EXISTS dwh;

CREATE TABLE IF NOT EXISTS dwh.dim_employee (
    employee_sk SERIAL PRIMARY KEY,
    employee_id INT UNIQUE,   
    name TEXT,
    user_id TEXT,
    active BOOLEAN,
    job_title TEXT,
    company_id INT,
    work_phone TEXT,
    mobile_phone TEXT,
    work_email TEXT,
    work_location TEXT,
    resource_id INT,
    resource_calendar_id INT,
    create_date TIMESTAMP,
    write_date TIMESTAMP,
    
    stg_loaded_at TIMESTAMP,
    stg_batch_id VARCHAR
);

-- =====================================================
-- FULL LOAD (truncate + reload)
-- Use this for initial backfill
-- =====================================================
-- TRUNCATE dwh.dim_employee;

-- INSERT INTO dwh.dim_employee (
--     employee_id,
--     name,
--     user_id,
--     active,
--     job_title,
--     company_id,
--     work_phone,
--     mobile_phone,
--     work_email,
--     work_location,
--     resource_id,
--     resource_calendar_id,
--     create_date,
--     write_date,
--     stg_loaded_at,
--     stg_batch_id
-- )
-- SELECT
--     id AS employee_id,
--     name,
--     user_id,
--     active,
--     job_title,
--     company_id,
--     work_phone,
--     mobile_phone,
--     work_email,
--     work_location,
--     resource_id,
--     resource_calendar_id,
--     create_date,
--     write_date,
--     stg_loaded_at,
--     stg_batch_id
-- FROM stg.hr_employee s;

-- =====================================================
-- INCREMENTAL UPSERT
-- Use this for near real-time updates
-- =====================================================
INSERT INTO dwh.dim_employee (
    employee_id,
    name,
    user_id,
    active,
    job_title,
    company_id,
    work_phone,
    mobile_phone,
    work_email,
    work_location,
    resource_id,
    resource_calendar_id,
    create_date,
    write_date,
    stg_loaded_at,
    stg_batch_id
)
SELECT
    id::INT AS employee_id,
    name,
    user_id,
    active::BOOLEAN,
    job_title,
    company_id::INT,
    work_phone,
    mobile_phone,
    work_email,
    work_location,
    resource_id::INT,
    resource_calendar_id::INT,
    create_date::TIMESTAMP,
    write_date::TIMESTAMP,
    NOW() AS stg_loaded_at,           -- Génération automatique du timestamp
    'batch_001' AS stg_batch_id       -- Valeur statique ou dynamique pour batch
FROM stg.hr_employee s
ON CONFLICT (employee_id) DO UPDATE
SET
    name = EXCLUDED.name,
    user_id = EXCLUDED.user_id,
    active = EXCLUDED.active,
    job_title = EXCLUDED.job_title,
    company_id = EXCLUDED.company_id,
    work_phone = EXCLUDED.work_phone,
    mobile_phone = EXCLUDED.mobile_phone,
    work_email = EXCLUDED.work_email,
    work_location = EXCLUDED.work_location,
    resource_id = EXCLUDED.resource_id,
    resource_calendar_id = EXCLUDED.resource_calendar_id,
    create_date = EXCLUDED.create_date,
    write_date = EXCLUDED.write_date,
    stg_loaded_at = EXCLUDED.stg_loaded_at,
    stg_batch_id = EXCLUDED.stg_batch_id;
