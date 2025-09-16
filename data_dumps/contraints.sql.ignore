-- ======================
-- File 2: Constraints and Indexes
-- ======================

-- ======================
-- res_partner Constraints
-- ======================
ALTER TABLE public.res_partner
    ADD CONSTRAINT res_partner_pkey PRIMARY KEY (id);

ALTER TABLE public.res_partner
    ADD CONSTRAINT res_partner_unique_barcode UNIQUE (barcode, company_id);

ALTER TABLE public.res_partner
    ADD CONSTRAINT res_partner_commercial_partner_id_fkey FOREIGN KEY (commercial_partner_id)
        REFERENCES public.res_partner (id) ON UPDATE NO ACTION ON DELETE SET NULL;

-- ALTER TABLE public.res_partner
--     ADD CONSTRAINT res_partner_company_id_fkey FOREIGN KEY (company_id)
--         REFERENCES public.res_company (id) ON UPDATE NO ACTION ON DELETE SET NULL;

ALTER TABLE public.res_partner
    ADD CONSTRAINT res_partner_country_id_fkey FOREIGN KEY (country_id)
        REFERENCES public.res_country (id) ON UPDATE NO ACTION ON DELETE RESTRICT;

--ALTER TABLE public.res_partner
--    ADD CONSTRAINT res_partner_create_uid_fkey FOREIGN KEY (create_uid)
--        REFERENCES public.res_users (id) ON UPDATE NO ACTION ON DELETE SET NULL;

ALTER TABLE public.res_partner
    ADD CONSTRAINT res_partner_industry_id_fkey FOREIGN KEY (industry_id)
        REFERENCES public.res_partner_industry (id) ON UPDATE NO ACTION ON DELETE SET NULL;

ALTER TABLE public.res_partner
    ADD CONSTRAINT res_partner_message_main_attachment_id_fkey FOREIGN KEY (message_main_attachment_id)
        REFERENCES public.ir_attachment (id) ON UPDATE NO ACTION ON DELETE SET NULL;

ALTER TABLE public.res_partner
    ADD CONSTRAINT res_partner_parent_id_fkey FOREIGN KEY (parent_id)
        REFERENCES public.res_partner (id) ON UPDATE NO ACTION ON DELETE SET NULL;

ALTER TABLE public.res_partner
    ADD CONSTRAINT res_partner_state_id_fkey FOREIGN KEY (state_id)
        REFERENCES public.res_country_state (id) ON UPDATE NO ACTION ON DELETE RESTRICT;

ALTER TABLE public.res_partner
    ADD CONSTRAINT res_partner_style_fkey FOREIGN KEY (style)
        REFERENCES public.report_template_settings (id) ON UPDATE NO ACTION ON DELETE SET NULL;

ALTER TABLE public.res_partner
    ADD CONSTRAINT res_partner_team_id_fkey FOREIGN KEY (team_id)
        REFERENCES public.crm_team (id) ON UPDATE NO ACTION ON DELETE SET NULL;

ALTER TABLE public.res_partner
    ADD CONSTRAINT res_partner_title_fkey FOREIGN KEY (title)
        REFERENCES public.res_partner_title (id) ON UPDATE NO ACTION ON DELETE SET NULL;

--ALTER TABLE public.res_partner
--    ADD CONSTRAINT res_partner_user_id_fkey FOREIGN KEY (user_id)
--        REFERENCES public.res_users (id) ON UPDATE NO ACTION ON DELETE SET NULL;

--ALTER TABLE public.res_partner
--    ADD CONSTRAINT res_partner_write_uid_fkey FOREIGN KEY (write_uid)
--        REFERENCES public.res_users (id) ON UPDATE NO ACTION ON DELETE SET NULL;

ALTER TABLE public.res_partner
    ADD CONSTRAINT res_partner_check_name CHECK ((type='contact' AND name IS NOT NULL) OR type<>'contact');

-- Indexes for res_partner
CREATE INDEX IF NOT EXISTS res_partner_commercial_partner_id_index
    ON public.res_partner (commercial_partner_id);

CREATE INDEX IF NOT EXISTS res_partner_company_id_index
    ON public.res_partner (company_id);

CREATE INDEX IF NOT EXISTS res_partner_date_index
    ON public.res_partner (date);

CREATE INDEX IF NOT EXISTS res_partner_display_name_index
    ON public.res_partner (display_name);

CREATE INDEX IF NOT EXISTS res_partner_message_main_attachment_id_index
    ON public.res_partner (message_main_attachment_id);

CREATE INDEX IF NOT EXISTS res_partner_name_index
    ON public.res_partner (name);

CREATE INDEX IF NOT EXISTS res_partner_parent_id_index
    ON public.res_partner (parent_id);

CREATE INDEX IF NOT EXISTS res_partner_ref_index
    ON public.res_partner (ref);

CREATE INDEX IF NOT EXISTS res_partner_vat_index
    ON public.res_partner (vat);


-- ======================
-- sale_order Constraints
-- ======================
ALTER TABLE public.sale_order
    ADD CONSTRAINT sale_order_pkey PRIMARY KEY (id);

--ALTER TABLE public.sale_order
--    ADD CONSTRAINT sale_order_analytic_account_id_fkey FOREIGN KEY (analytic_account_id)
--        REFERENCES public.account_analytic_account (id) ON UPDATE NO ACTION ON DELETE SET NULL;

ALTER TABLE public.sale_order
    ADD CONSTRAINT sale_order_atelier_id_fkey FOREIGN KEY (atelier_id)
        REFERENCES public.hr_atelier (id) ON UPDATE NO ACTION ON DELETE SET NULL;

ALTER TABLE public.sale_order
    ADD CONSTRAINT sale_order_campaign_id_fkey FOREIGN KEY (campaign_id)
        REFERENCES public.utm_campaign (id) ON UPDATE NO ACTION ON DELETE SET NULL;

ALTER TABLE public.sale_order
    ADD CONSTRAINT sale_order_carrier_id_fkey FOREIGN KEY (carrier_id)
        REFERENCES public.delivery_carrier (id) ON UPDATE NO ACTION ON DELETE SET NULL;

ALTER TABLE public.sale_order
    ADD CONSTRAINT sale_order_code_promo_program_id_fkey FOREIGN KEY (code_promo_program_id)
        REFERENCES public.sale_coupon_program (id) ON UPDATE NO ACTION ON DELETE SET NULL;

--ALTER TABLE public.sale_order
--    ADD CONSTRAINT sale_order_company_id_fkey FOREIGN KEY (company_id)
--        REFERENCES public.res_company (id) ON UPDATE NO ACTION ON DELETE RESTRICT;

--ALTER TABLE public.sale_order
--    ADD CONSTRAINT sale_order_create_uid_fkey FOREIGN KEY (create_uid)
--        REFERENCES public.res_users (id) ON UPDATE NO ACTION ON DELETE SET NULL;

ALTER TABLE public.sale_order
    ADD CONSTRAINT sale_order_fiscal_position_id_fkey FOREIGN KEY (fiscal_position_id)
        REFERENCES public.account_fiscal_position (id) ON UPDATE NO ACTION ON DELETE SET NULL;

ALTER TABLE public.sale_order
    ADD CONSTRAINT sale_order_incoterm_fkey FOREIGN KEY (incoterm)
        REFERENCES public.account_incoterms (id) ON UPDATE NO ACTION ON DELETE SET NULL;

ALTER TABLE public.sale_order
    ADD CONSTRAINT sale_order_information_fkey FOREIGN KEY (information)
        REFERENCES public.kit_line_info (id) ON UPDATE NO ACTION ON DELETE SET NULL;

ALTER TABLE public.sale_order
    ADD CONSTRAINT sale_order_invoice_id_fkey FOREIGN KEY (invoice_id)
        REFERENCES public.account_move (id) ON UPDATE NO ACTION ON DELETE SET NULL;

ALTER TABLE public.sale_order
    ADD CONSTRAINT sale_order_medium_id_fkey FOREIGN KEY (medium_id)
        REFERENCES public.utm_medium (id) ON UPDATE NO ACTION ON DELETE SET NULL;

ALTER TABLE public.sale_order
    ADD CONSTRAINT sale_order_message_main_attachment_id_fkey FOREIGN KEY (message_main_attachment_id)
        REFERENCES public.ir_attachment (id) ON UPDATE NO ACTION ON DELETE SET NULL;

ALTER TABLE public.sale_order
    ADD CONSTRAINT sale_order_opportunity_id_fkey FOREIGN KEY (opportunity_id)
        REFERENCES public.crm_lead (id) ON UPDATE NO ACTION ON DELETE SET NULL;

ALTER TABLE public.sale_order
    ADD CONSTRAINT sale_order_partner_id_fkey FOREIGN KEY (partner_id)
        REFERENCES public.res_partner (id) ON UPDATE NO ACTION ON DELETE RESTRICT;

ALTER TABLE public.sale_order
    ADD CONSTRAINT sale_order_partner_invoice_id_fkey FOREIGN KEY (partner_invoice_id)
        REFERENCES public.res_partner (id) ON UPDATE NO ACTION ON DELETE RESTRICT;

ALTER TABLE public.sale_order
    ADD CONSTRAINT sale_order_partner_shipping_id_fkey FOREIGN KEY (partner_shipping_id)
        REFERENCES public.res_partner (id) ON UPDATE NO ACTION ON DELETE RESTRICT;

ALTER TABLE public.sale_order
    ADD CONSTRAINT sale_order_payment_term_id_fkey FOREIGN KEY (payment_term_id)
        REFERENCES public.account_payment_term (id) ON UPDATE NO ACTION ON DELETE SET NULL;

ALTER TABLE public.sale_order
    ADD CONSTRAINT sale_order_planning_id_fkey FOREIGN KEY (planning_id)
        REFERENCES public.planning_slot (id) ON UPDATE NO ACTION ON DELETE SET NULL;

--ALTER TABLE public.sale_order
--    ADD CONSTRAINT sale_order_pricelist_id_fkey FOREIGN KEY (pricelist_id)
--        REFERENCES public.product_pricelist (id) ON UPDATE NO ACTION ON DELETE RESTRICT;

ALTER TABLE public.sale_order
    ADD CONSTRAINT sale_order_procurement_group_id_fkey FOREIGN KEY (procurement_group_id)
        REFERENCES public.procurement_group (id) ON UPDATE NO ACTION ON DELETE SET NULL;

--ALTER TABLE public.sale_order
--    ADD CONSTRAINT sale_order_responsable_intervention_fkey FOREIGN KEY (responsable_intervention)
--        REFERENCES public.res_users (id) ON UPDATE NO ACTION ON DELETE SET NULL;

ALTER TABLE public.sale_order
    ADD CONSTRAINT sale_order_sale_order_template_id_fkey FOREIGN KEY (sale_order_template_id)
        REFERENCES public.sale_order_template (id) ON UPDATE NO ACTION ON DELETE SET NULL;

ALTER TABLE public.sale_order
    ADD CONSTRAINT sale_order_source_id_fkey FOREIGN KEY (source_id)
        REFERENCES public.utm_source (id) ON UPDATE NO ACTION ON DELETE SET NULL;

ALTER TABLE public.sale_order
    ADD CONSTRAINT sale_order_style_fkey FOREIGN KEY (style)
        REFERENCES public.report_template_settings (id) ON UPDATE NO ACTION ON DELETE SET NULL;

ALTER TABLE public.sale_order
    ADD CONSTRAINT sale_order_team_id_fkey FOREIGN KEY (team_id)
        REFERENCES public.crm_team (id) ON UPDATE NO ACTION ON DELETE SET NULL;

--ALTER TABLE public.sale_order
--    ADD CONSTRAINT sale_order_user_id_fkey FOREIGN KEY (user_id)
--        REFERENCES public.res_users (id) ON UPDATE NO ACTION ON DELETE SET NULL;

--ALTER TABLE public.sale_order
--    ADD CONSTRAINT sale_order_warehouse_id_fkey FOREIGN KEY (warehouse_id)
--        REFERENCES public.stock_warehouse (id) ON UPDATE NO ACTION ON DELETE RESTRICT;

--ALTER TABLE public.sale_order
--    ADD CONSTRAINT sale_order_write_uid_fkey FOREIGN KEY (write_uid)
--        REFERENCES public.res_users (id) ON UPDATE NO ACTION ON DELETE SET NULL;

ALTER TABLE public.sale_order
    ADD CONSTRAINT sale_order_date_order_conditional_required CHECK ((state IN ('sale', 'done') AND date_order IS NOT NULL) OR state NOT IN ('sale', 'done'));

-- Indexes for sale_order
CREATE INDEX IF NOT EXISTS sale_order_company_id_index
    ON public.sale_order (company_id);

CREATE INDEX IF NOT EXISTS sale_order_create_date_index
    ON public.sale_order (create_date);

CREATE INDEX IF NOT EXISTS sale_order_date_order_index
    ON public.sale_order (date_order);

CREATE INDEX IF NOT EXISTS sale_order_message_main_attachment_id_index
    ON public.sale_order (message_main_attachment_id);

CREATE INDEX IF NOT EXISTS sale_order_name_index
    ON public.sale_order (name);

CREATE INDEX IF NOT EXISTS sale_order_partner_id_index
    ON public.sale_order (partner_id);

CREATE INDEX IF NOT EXISTS sale_order_state_devis_index
    ON public.sale_order (state_devis);

CREATE INDEX IF NOT EXISTS sale_order_state_index
    ON public.sale_order (state);

CREATE INDEX IF NOT EXISTS sale_order_user_id_index
    ON public.sale_order (user_id);

-- ======================
-- hr_employee Constraints
-- ======================
ALTER TABLE public.hr_employee
    ADD CONSTRAINT hr_employee_pkey PRIMARY KEY (id);

ALTER TABLE public.hr_employee
    ADD CONSTRAINT hr_employee_address_home_id_fkey FOREIGN KEY (address_home_id)
        REFERENCES public.res_partner (id) ON UPDATE NO ACTION ON DELETE SET NULL;

--ALTER TABLE public.hr_employee
--    ADD CONSTRAINT hr_employee_create_uid_fkey FOREIGN KEY (create_uid)
--        REFERENCES public.res_users (id) ON UPDATE NO ACTION ON DELETE SET NULL;

--ALTER TABLE public.hr_employee
--    ADD CONSTRAINT hr_employee_department_id_fkey FOREIGN KEY (department_id)
--        REFERENCES public.hr_department (id) ON UPDATE NO ACTION ON DELETE SET NULL;

--ALTER TABLE public.hr_employee
--    ADD CONSTRAINT hr_employee_job_id_fkey FOREIGN KEY (job_id)
--        REFERENCES public.hr_job (id) ON UPDATE NO ACTION ON DELETE SET NULL;

--ALTER TABLE public.hr_employee
--    ADD CONSTRAINT hr_employee_write_uid_fkey FOREIGN KEY (write_uid)
--        REFERENCES public.res_users (id) ON UPDATE NO ACTION ON DELETE SET NULL;

-- Indexes for hr_employee
CREATE INDEX IF NOT EXISTS hr_employee_address_home_id_index
    ON public.hr_employee (address_home_id);

CREATE INDEX IF NOT EXISTS hr_employee_department_id_index
    ON public.hr_employee (department_id);

CREATE INDEX IF NOT EXISTS hr_employee_job_id_index
    ON public.hr_employee (job_id);

CREATE INDEX IF NOT EXISTS hr_employee_user_id_index
    ON public.hr_employee (user_id);

-- ======================
-- planning_slot Constraints
-- ======================
ALTER TABLE public.planning_slot
    ADD CONSTRAINT planning_slot_pkey PRIMARY KEY (id);

--ALTER TABLE public.planning_slot
--    ADD CONSTRAINT planning_slot_create_uid_fkey FOREIGN KEY (create_uid)
--        REFERENCES public.res_users (id) ON UPDATE NO ACTION ON DELETE SET NULL;

ALTER TABLE public.planning_slot
    ADD CONSTRAINT planning_slot_employee_id_fkey FOREIGN KEY (employee_id)
        REFERENCES public.hr_employee (id) ON UPDATE NO ACTION ON DELETE SET NULL;

--ALTER TABLE public.planning_slot
--    ADD CONSTRAINT planning_slot_write_uid_fkey FOREIGN KEY (write_uid)
--        REFERENCES public.res_users (id) ON UPDATE NO ACTION ON DELETE SET NULL;

-- Indexes for planning_slot
CREATE INDEX IF NOT EXISTS planning_slot_employee_id_index
    ON public.planning_slot (employee_id);

-- ======================
-- product_product and product_template Constraints
-- ======================
--ALTER TABLE public.product_template
--    ADD CONSTRAINT product_template_pkey PRIMARY KEY (id);

ALTER TABLE public.product_product
    ADD CONSTRAINT product_product_pkey PRIMARY KEY (id);

--ALTER TABLE public.product_product
--    ADD CONSTRAINT product_product_template_id_fkey FOREIGN KEY (product_tmpl_id)
--        REFERENCES public.product_template (id) ON UPDATE NO ACTION ON DELETE CASCADE;

-- ======================
-- purchase_order Constraints
-- ======================
ALTER TABLE public.purchase_order
    ADD CONSTRAINT purchase_order_pkey PRIMARY KEY (id);

--ALTER TABLE public.purchase_order
--    ADD CONSTRAINT purchase_order_create_uid_fkey FOREIGN KEY (create_uid)
--        REFERENCES public.res_users (id) ON UPDATE NO ACTION ON DELETE SET NULL;

ALTER TABLE public.purchase_order
    ADD CONSTRAINT purchase_order_partner_id_fkey FOREIGN KEY (partner_id)
        REFERENCES public.res_partner (id) ON UPDATE NO ACTION ON DELETE RESTRICT;

--ALTER TABLE public.purchase_order
--    ADD CONSTRAINT purchase_order_pricelist_id_fkey FOREIGN KEY (pricelist_id)
--        REFERENCES public.product_pricelist (id) ON UPDATE NO ACTION ON DELETE RESTRICT;

--ALTER TABLE public.purchase_order
--    ADD CONSTRAINT purchase_order_write_uid_fkey FOREIGN KEY (write_uid)
--        REFERENCES public.res_users (id) ON UPDATE NO ACTION ON DELETE SET NULL;
