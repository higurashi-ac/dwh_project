-- =====================================================
-- Dimension table for account_journal
-- =====================================================
CREATE SCHEMA IF NOT EXISTS dwh;

CREATE TABLE IF NOT EXISTS dwh.dim_account_journal (
    account_journal_sk SERIAL PRIMARY KEY,
    account_journal_id INT UNIQUE,
    name TEXT,
    code TEXT,
    active BOOLEAN,
    type TEXT,
    default_credit_account_id INT,
    default_debit_account_id INT,
    restrict_mode_hash_table BOOLEAN,
    sequence_id INT,
    refund_sequence_id INT,
    sequence INT,
    company_id INT,
    refund_sequence BOOLEAN,
    create_date TIMESTAMP,
    write_date TIMESTAMP,
    check_sequence_id INT,
    stg_loaded_at TIMESTAMP,
    stg_batch_id VARCHAR
);

-- =====================================================
-- FULL LOAD (truncate + reload)
-- Use this for initial backfill
-- =====================================================
-- TRUNCATE dwh.dim_account_journal;

-- INSERT INTO dwh.dim_account_journal (
--     account_journal_id,
--     name,
--     code,
--     active,
--     type,
--     default_credit_account_id,
--     default_debit_account_id,
--     restrict_mode_hash_table,
--     sequence_id,
--     refund_sequence_id,
--     sequence,
--     company_id,
--     refund_sequence,
--     create_date,
--     write_date,
--     check_sequence_id,
--     stg_loaded_at,
--     stg_batch_id
-- )
-- SELECT
--     id AS account_journal_id,
--     name,
--     code,
--     active,
--     type,
--     default_credit_account_id,
--     default_debit_account_id,
--     restrict_mode_hash_table,
--     sequence_id,
--     refund_sequence_id,
--     sequence,
--     company_id,
--     refund_sequence,
--     create_date,
--     write_date,
--     check_sequence_id,
--     stg_loaded_at,
--     stg_batch_id
-- FROM stg.account_journal s;

-- =====================================================
-- INCREMENTAL UPSERT
-- Use this for near real-time updates
-- =====================================================
INSERT INTO dwh.dim_account_journal (
    account_journal_id,
    name,
    code,
    active,
    type,
    default_credit_account_id,
    default_debit_account_id,
    restrict_mode_hash_table,
    sequence_id,
    refund_sequence_id,
    sequence,
    company_id,
    refund_sequence,
    create_date,
    write_date,
    check_sequence_id,
    stg_loaded_at,
    stg_batch_id
)
SELECT
    id AS account_journal_id,
    name,
    code,
    active,
    type,
    default_credit_account_id,
    default_debit_account_id,
    restrict_mode_hash_table,
    sequence_id,
    refund_sequence_id,
    sequence,
    company_id,
    refund_sequence,
    create_date,
    write_date,
    check_sequence_id,
    stg_loaded_at,
    stg_batch_id
FROM stg.account_journal s
ON CONFLICT (account_journal_id) DO UPDATE
SET
    name = EXCLUDED.name,
    code = EXCLUDED.code,
    active = EXCLUDED.active,
    type = EXCLUDED.type,
    default_credit_account_id = EXCLUDED.default_credit_account_id,
    default_debit_account_id = EXCLUDED.default_debit_account_id,
    restrict_mode_hash_table = EXCLUDED.restrict_mode_hash_table,
    sequence_id = EXCLUDED.sequence_id,
    refund_sequence_id = EXCLUDED.refund_sequence_id,
    sequence = EXCLUDED.sequence,
    company_id = EXCLUDED.company_id,
    refund_sequence = EXCLUDED.refund_sequence,
    create_date = EXCLUDED.create_date,
    write_date = EXCLUDED.write_date,
    check_sequence_id = EXCLUDED.check_sequence_id,
    stg_loaded_at = EXCLUDED.stg_loaded_at,
    stg_batch_id = EXCLUDED.stg_batch_id;
