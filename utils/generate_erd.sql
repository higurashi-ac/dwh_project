-- ==========================================================
-- AUTO-GENERATED ERD SCHEMA CREATION SCRIPT
-- ==========================================================

DROP SCHEMA IF EXISTS erd CASCADE;
CREATE SCHEMA IF NOT EXISTS erd;

-- ==========================================================
-- STEP 1: CREATE TABLES FROM NON-FACT VIEWS
-- ==========================================================
CREATE TABLE erd.v_account_journal AS SELECT * FROM dwh.v_account_journal LIMIT 0;
CREATE TABLE erd.v_account_move AS SELECT * FROM dwh.v_account_move LIMIT 0;
CREATE TABLE erd.v_date AS SELECT * FROM dwh.v_date LIMIT 0;
CREATE TABLE erd.v_employee AS SELECT * FROM dwh.v_employee LIMIT 0;
CREATE TABLE erd.v_partner AS SELECT * FROM dwh.v_partner LIMIT 0;
CREATE TABLE erd.v_payment_justify AS SELECT * FROM dwh.v_payment_justify LIMIT 0;
CREATE TABLE erd.v_planning_slot AS SELECT * FROM dwh.v_planning_slot LIMIT 0;
CREATE TABLE erd.v_purchase_order AS SELECT * FROM dwh.v_purchase_order LIMIT 0;
CREATE TABLE erd.v_purchase_order_line AS SELECT * FROM dwh.v_purchase_order_line LIMIT 0;
CREATE TABLE erd.v_sale_order AS SELECT * FROM dwh.v_sale_order LIMIT 0;
CREATE TABLE erd.v_sale_order_line AS SELECT * FROM dwh.v_sale_order_line LIMIT 0;
CREATE TABLE erd.v_supplier AS SELECT * FROM dwh.v_supplier LIMIT 0;
CREATE TABLE erd.v_customer AS SELECT * FROM dwh.v_customer LIMIT 0;

-- ==========================================================
-- STEP 2: ADD PRIMARY KEYS (FIRST COLUMN OF EACH NON-FACT VIEW)
-- ==========================================================
ALTER TABLE erd.v_account_journal ADD PRIMARY KEY (account_journal_id);
ALTER TABLE erd.v_account_move ADD PRIMARY KEY (account_move_id);
ALTER TABLE erd.v_date ADD PRIMARY KEY (date_id);
ALTER TABLE erd.v_employee ADD PRIMARY KEY (employee_id);
ALTER TABLE erd.v_partner ADD PRIMARY KEY (partner_id);
ALTER TABLE erd.v_payment_justify ADD PRIMARY KEY (payment_justify_id);
ALTER TABLE erd.v_planning_slot ADD PRIMARY KEY (planning_id);
ALTER TABLE erd.v_purchase_order ADD PRIMARY KEY (po_id);
ALTER TABLE erd.v_purchase_order_line ADD PRIMARY KEY (po_line_id);
ALTER TABLE erd.v_supplier ADD PRIMARY KEY (supplier_id);
ALTER TABLE erd.v_customer ADD PRIMARY KEY (customer_id);

ALTER TABLE erd.v_sale_order ADD PRIMARY KEY (so_id);
ALTER TABLE erd.v_sale_order_line ADD PRIMARY KEY (so_line_id);
ALTER TABLE erd.v_sale_order_line ADD CONSTRAINT fk_v_so_so_line FOREIGN KEY (so_id) REFERENCES erd.v_sale_order(so_id);



-- ==========================================================
-- STEP 3: CREATE FACT TABLES
-- ==========================================================
CREATE TABLE erd.v_fact_sales AS SELECT * FROM dwh.v_fact_sales LIMIT 0;

-- ==========================================================
-- STEP 4: DEFINE FOREIGN KEYS FOR FACT TABLES
-- Each fact table references all previously defined non-fact tables.
-- You can refine these later if needed.
-- ==========================================================
ALTER TABLE erd.v_fact_sales ADD CONSTRAINT fk_v_fact_sales_v_customer         FOREIGN KEY (customer_id)    REFERENCES erd.v_customer(customer_id);
ALTER TABLE erd.v_fact_sales ADD CONSTRAINT fk_v_fact_sales_v_date             FOREIGN KEY (date_id)        REFERENCES erd.v_date(date_id);
ALTER TABLE erd.v_fact_sales ADD CONSTRAINT fk_v_fact_sales_v_sale_order       FOREIGN KEY (so_id)          REFERENCES erd.v_sale_order(so_id);
ALTER TABLE erd.v_fact_sales ADD CONSTRAINT fk_v_fact_sales_v_sale_order_line  FOREIGN KEY (so_line_id)     REFERENCES erd.v_sale_order_line(so_line_id);

