-- ==========================================================
-- AUTO-GENERATED ERD SCHEMA CREATION SCRIPT
-- ==========================================================

DROP SCHEMA IF EXISTS erd CASCADE;
CREATE SCHEMA IF NOT EXISTS erd;

-- ==========================================================
-- STEP 1: CREATE TABLES FROM NON-FACT VIEWS
-- ==========================================================
CREATE TABLE erd.dim_account_journal AS SELECT * FROM dwh.v_account_journal LIMIT 0;
CREATE TABLE erd.dim_account_move AS SELECT * FROM dwh.v_account_move LIMIT 0;
CREATE TABLE erd.dim_date AS SELECT * FROM dwh.v_date LIMIT 0;
CREATE TABLE erd.dim_employee AS SELECT * FROM dwh.v_employee LIMIT 0;
CREATE TABLE erd.dim_partner AS SELECT * FROM dwh.v_partner LIMIT 0;
CREATE TABLE erd.dim_payment_justify AS SELECT * FROM dwh.v_payment_justify LIMIT 0;
CREATE TABLE erd.dim_planning_slot AS SELECT * FROM dwh.v_planning_slot LIMIT 0;
CREATE TABLE erd.dim_purchase_order AS SELECT * FROM dwh.v_purchase_order LIMIT 0;
CREATE TABLE erd.dim_purchase_order_line AS SELECT * FROM dwh.v_purchase_order_line LIMIT 0;
CREATE TABLE erd.dim_sale_order AS SELECT * FROM dwh.v_sale_order LIMIT 0;
CREATE TABLE erd.dim_sale_order_line AS SELECT * FROM dwh.v_sale_order_line LIMIT 0;
CREATE TABLE erd.dim_supplier AS SELECT * FROM dwh.v_supplier LIMIT 0;
CREATE TABLE erd.dim_customer AS SELECT * FROM dwh.v_customer LIMIT 0;
CREATE TABLE erd.dim_product_product AS SELECT * FROM dwh.v_product_product LIMIT 0;
CREATE TABLE erd.dim_product_template AS SELECT * FROM dwh.v_product_template LIMIT 0;

-- ==========================================================
-- STEP 2: ADD PRIMARY KEYS (FIRST COLUMN OF EACH NON-FACT VIEW)
-- ==========================================================
ALTER TABLE erd.dim_account_journal ADD PRIMARY KEY (account_journal_id);
ALTER TABLE erd.dim_account_move ADD PRIMARY KEY (account_move_id);
ALTER TABLE erd.dim_date ADD PRIMARY KEY (date_id);
ALTER TABLE erd.dim_employee ADD PRIMARY KEY (employee_id);
ALTER TABLE erd.dim_partner ADD PRIMARY KEY (partner_id);
ALTER TABLE erd.dim_payment_justify ADD PRIMARY KEY (payment_justify_id);
ALTER TABLE erd.dim_planning_slot ADD PRIMARY KEY (planning_id);

ALTER TABLE erd.dim_supplier ADD PRIMARY KEY (supplier_id);
ALTER TABLE erd.dim_customer ADD PRIMARY KEY (customer_id);
ALTER TABLE erd.dim_product_product ADD PRIMARY KEY (product_id);
ALTER TABLE erd.dim_product_template ADD PRIMARY KEY (product_tmpl_id);

ALTER TABLE erd.dim_sale_order ADD PRIMARY KEY (so_id);
ALTER TABLE erd.dim_sale_order_line ADD PRIMARY KEY (so_line_id);
ALTER TABLE erd.dim_sale_order_line ADD CONSTRAINT fk_v_so_so_line FOREIGN KEY (so_id) REFERENCES erd.dim_sale_order(so_id);

ALTER TABLE erd.dim_purchase_order ADD PRIMARY KEY (po_id);
ALTER TABLE erd.dim_purchase_order_line ADD PRIMARY KEY (po_line_id);
ALTER TABLE erd.dim_purchase_order_line ADD CONSTRAINT fk_v_po_po_line FOREIGN KEY (po_id) REFERENCES erd.dim_purchase_order(po_id);


-- ==========================================================
-- STEP 3: CREATE FACT TABLES
-- ==========================================================
CREATE TABLE erd.fact_sales AS SELECT * FROM dwh.v_fact_sales LIMIT 0;
CREATE TABLE erd.fact_purchases AS SELECT * FROM dwh.v_fact_purchases LIMIT 0;

-- ==========================================================
-- STEP 4: DEFINE FOREIGN KEYS FOR FACT TABLES
-- Each fact table references all previously defined non-fact tables.
-- You can refine these later if needed.
-- ==========================================================
ALTER TABLE erd.fact_sales ADD CONSTRAINT fk_fact_sales_v_customer         FOREIGN KEY (customer_id)    REFERENCES erd.dim_customer(customer_id);
ALTER TABLE erd.fact_sales ADD CONSTRAINT fk_fact_sales_v_date             FOREIGN KEY (date_id)        REFERENCES erd.dim_date(date_id);
ALTER TABLE erd.fact_sales ADD CONSTRAINT fk_fact_sales_v_sale_order       FOREIGN KEY (so_id)          REFERENCES erd.dim_sale_order(so_id);
ALTER TABLE erd.fact_sales ADD CONSTRAINT fk_fact_sales_v_sale_order_line  FOREIGN KEY (so_line_id)     REFERENCES erd.dim_sale_order_line(so_line_id);

ALTER TABLE erd.fact_purchases ADD CONSTRAINT fk_fact_purchases_v_supplier         FOREIGN KEY (supplier_id)    REFERENCES erd.dim_supplier(supplier_id);
ALTER TABLE erd.fact_purchases ADD CONSTRAINT fk_fact_purchases_v_date             FOREIGN KEY (date_id)        REFERENCES erd.dim_date(date_id);
ALTER TABLE erd.fact_purchases ADD CONSTRAINT fk_fact_purchases_v_purchase_order       FOREIGN KEY (po_id)          REFERENCES erd.dim_purchase_order (po_id);
ALTER TABLE erd.fact_purchases ADD CONSTRAINT fk_fact_purchases_v_purchase_order_line  FOREIGN KEY (po_line_id)     REFERENCES erd.dim_purchase_order_line(po_line_id);