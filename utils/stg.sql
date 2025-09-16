-- Create schema if it does not exist
CREATE SCHEMA IF NOT EXISTS stg;

-- ============================
-- res_partner
-- ============================
CREATE TABLE IF NOT EXISTS stg.res_partner
(LIKE public.res_partner INCLUDING DEFAULTS INCLUDING GENERATED);

ALTER TABLE stg.res_partner
    ADD COLUMN IF NOT EXISTS stg_loaded_at TIMESTAMP NOT NULL DEFAULT now(),
    ADD COLUMN IF NOT EXISTS stg_batch_id VARCHAR;

-- ============================
-- sale_order_line
-- ============================
CREATE TABLE IF NOT EXISTS stg.sale_order_line
(LIKE public.sale_order_line INCLUDING DEFAULTS INCLUDING GENERATED);

ALTER TABLE stg.sale_order_line
    ADD COLUMN IF NOT EXISTS stg_loaded_at TIMESTAMP NOT NULL DEFAULT now(),
    ADD COLUMN IF NOT EXISTS stg_batch_id VARCHAR;

-- ============================
-- sale_order
-- ============================
CREATE TABLE IF NOT EXISTS stg.sale_order
(LIKE public.sale_order INCLUDING DEFAULTS INCLUDING GENERATED);

ALTER TABLE stg.sale_order
    ADD COLUMN IF NOT EXISTS stg_loaded_at TIMESTAMP NOT NULL DEFAULT now(),
    ADD COLUMN IF NOT EXISTS stg_batch_id VARCHAR;

-- ============================
-- planning_slot
-- ============================
CREATE TABLE IF NOT EXISTS stg.planning_slot
(LIKE public.planning_slot INCLUDING DEFAULTS INCLUDING GENERATED);

ALTER TABLE stg.planning_slot
    ADD COLUMN IF NOT EXISTS stg_loaded_at TIMESTAMP NOT NULL DEFAULT now(),
    ADD COLUMN IF NOT EXISTS stg_batch_id VARCHAR;


-- ============================
-- purchase_order_line
-- ============================
CREATE TABLE IF NOT EXISTS stg.purchase_order_line
(LIKE public.purchase_order_line INCLUDING DEFAULTS INCLUDING GENERATED);

ALTER TABLE stg.purchase_order_line
    ADD COLUMN IF NOT EXISTS stg_loaded_at TIMESTAMP NOT NULL DEFAULT now(),
    ADD COLUMN IF NOT EXISTS stg_batch_id VARCHAR;


-- ============================
-- purchase_order
-- ============================
CREATE TABLE IF NOT EXISTS stg.purchase_order
(LIKE public.purchase_order INCLUDING DEFAULTS INCLUDING GENERATED);

ALTER TABLE stg.purchase_order
    ADD COLUMN IF NOT EXISTS stg_loaded_at TIMESTAMP NOT NULL DEFAULT now(),
    ADD COLUMN IF NOT EXISTS stg_batch_id VARCHAR;


-- ============================
-- hr_employee
-- ============================
CREATE TABLE IF NOT EXISTS stg.hr_employee
(LIKE public.hr_employee INCLUDING DEFAULTS INCLUDING GENERATED);

ALTER TABLE stg.hr_employee
    ADD COLUMN IF NOT EXISTS stg_loaded_at TIMESTAMP NOT NULL DEFAULT now(),
    ADD COLUMN IF NOT EXISTS stg_batch_id VARCHAR;


-- ============================
-- payment_justify
-- ============================
CREATE TABLE IF NOT EXISTS stg.payment_justify
(LIKE public.payment_justify INCLUDING DEFAULTS INCLUDING GENERATED);

ALTER TABLE stg.payment_justify
    ADD COLUMN IF NOT EXISTS stg_loaded_at TIMESTAMP NOT NULL DEFAULT now(),
    ADD COLUMN IF NOT EXISTS stg_batch_id VARCHAR;


-- ============================
-- account_journal
-- ============================
CREATE TABLE IF NOT EXISTS stg.account_journal
(LIKE public.account_journal INCLUDING DEFAULTS INCLUDING GENERATED);

ALTER TABLE stg.account_journal
    ADD COLUMN IF NOT EXISTS stg_loaded_at TIMESTAMP NOT NULL DEFAULT now(),
    ADD COLUMN IF NOT EXISTS stg_batch_id VARCHAR;


-- ============================
-- account_move
-- ============================
CREATE TABLE IF NOT EXISTS stg.account_move
(LIKE public.account_move INCLUDING DEFAULTS INCLUDING GENERATED);

ALTER TABLE stg.account_move
    ADD COLUMN IF NOT EXISTS stg_loaded_at TIMESTAMP NOT NULL DEFAULT now(),
    ADD COLUMN IF NOT EXISTS stg_batch_id VARCHAR;
