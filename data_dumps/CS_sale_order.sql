-- Table: public.sale_order

-- DROP TABLE IF EXISTS public.sale_order;

CREATE TABLE IF NOT EXISTS public.sale_order
(
    id integer NOT NULL DEFAULT nextval('sale_order_id_seq'::regclass),
    campaign_id integer,
    source_id integer,
    medium_id integer,
    access_token character varying COLLATE pg_catalog."default" NOT NULL,
    message_main_attachment_id integer,
    name character varying COLLATE pg_catalog."default" NOT NULL,
    origin character varying COLLATE pg_catalog."default",
    client_order_ref character varying COLLATE pg_catalog."default",
    reference character varying COLLATE pg_catalog."default",
    state character varying COLLATE pg_catalog."default",
    date_order timestamp without time zone NOT NULL,
    validity_date date,
    require_signature boolean,
    require_payment boolean,
    create_date timestamp without time zone,
    user_id integer,
    partner_id integer NOT NULL,
    partner_invoice_id integer NOT NULL,
    partner_shipping_id integer NOT NULL,
    pricelist_id integer NOT NULL,
    analytic_account_id integer,
    invoice_status character varying COLLATE pg_catalog."default",
    note text COLLATE pg_catalog."default",
    amount_untaxed numeric,
    amount_tax numeric,
    amount_total numeric,
    currency_rate numeric,
    payment_term_id integer,
    fiscal_position_id integer,
    company_id integer NOT NULL,
    team_id integer,
    signed_by character varying COLLATE pg_catalog."default",
    signed_on timestamp without time zone,
    commitment_date timestamp without time zone,
    create_uid integer,
    write_uid integer,
    write_date timestamp without time zone,
    sale_order_template_id integer,
    incoterm integer,
    picking_policy character varying COLLATE pg_catalog."default" NOT NULL,
    warehouse_id integer NOT NULL,
    procurement_group_id integer,
    effective_date date,
    style integer,
    project_title character varying COLLATE pg_catalog."default",
    opportunity_id integer,
    carrier_id integer,
    delivery_message character varying COLLATE pg_catalog."default",
    delivery_rating_success boolean,
    recompute_delivery_price boolean,
    planning_id integer,
    type_devis character varying COLLATE pg_catalog."default",
    code_promo_program_id integer,
    force_invoiced boolean,
    amount_words character varying COLLATE pg_catalog."default",
    state_devis character varying COLLATE pg_catalog."default",
    dispatch_type character varying COLLATE pg_catalog."default",
    hide_net_price boolean,
    old_state character varying(128) COLLATE pg_catalog."default",
    information integer,
    zip_client character varying COLLATE pg_catalog."default",
    region integer,
    ville_client character varying COLLATE pg_catalog."default",
    region_client character varying COLLATE pg_catalog."default",
    ref_intervention character varying COLLATE pg_catalog."default",
    source character varying COLLATE pg_catalog."default" NOT NULL,
    relance character varying COLLATE pg_catalog."default",
    note_relance text COLLATE pg_catalog."default",
    date_relance timestamp without time zone,
    atelier_id integer,
    responsable_intervention integer,
    remarque text COLLATE pg_catalog."default",
    status_pose character varying COLLATE pg_catalog."default",
    decharge boolean,
    invoice_id integer,
    discount_type character varying COLLATE pg_catalog."default",
    discount_rate numeric,
    amount_discount numeric,
    CONSTRAINT sale_order_pkey PRIMARY KEY (id),
    CONSTRAINT sale_order_analytic_account_id_fkey FOREIGN KEY (analytic_account_id)
        REFERENCES public.account_analytic_account (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE SET NULL,
    CONSTRAINT sale_order_atelier_id_fkey FOREIGN KEY (atelier_id)
        REFERENCES public.hr_atelier (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE SET NULL,
    CONSTRAINT sale_order_campaign_id_fkey FOREIGN KEY (campaign_id)
        REFERENCES public.utm_campaign (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE SET NULL,
    CONSTRAINT sale_order_carrier_id_fkey FOREIGN KEY (carrier_id)
        REFERENCES public.delivery_carrier (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE SET NULL,
    CONSTRAINT sale_order_code_promo_program_id_fkey FOREIGN KEY (code_promo_program_id)
        REFERENCES public.sale_coupon_program (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE SET NULL,
    CONSTRAINT sale_order_company_id_fkey FOREIGN KEY (company_id)
        REFERENCES public.res_company (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE RESTRICT,
    CONSTRAINT sale_order_create_uid_fkey FOREIGN KEY (create_uid)
        REFERENCES public.res_users (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE SET NULL,
    CONSTRAINT sale_order_fiscal_position_id_fkey FOREIGN KEY (fiscal_position_id)
        REFERENCES public.account_fiscal_position (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE SET NULL,
    CONSTRAINT sale_order_incoterm_fkey FOREIGN KEY (incoterm)
        REFERENCES public.account_incoterms (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE SET NULL,
    CONSTRAINT sale_order_information_fkey FOREIGN KEY (information)
        REFERENCES public.kit_line_info (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE SET NULL,
    CONSTRAINT sale_order_invoice_id_fkey FOREIGN KEY (invoice_id)
        REFERENCES public.account_move (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE SET NULL,
    CONSTRAINT sale_order_medium_id_fkey FOREIGN KEY (medium_id)
        REFERENCES public.utm_medium (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE SET NULL,
    CONSTRAINT sale_order_message_main_attachment_id_fkey FOREIGN KEY (message_main_attachment_id)
        REFERENCES public.ir_attachment (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE SET NULL,
    CONSTRAINT sale_order_opportunity_id_fkey FOREIGN KEY (opportunity_id)
        REFERENCES public.crm_lead (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE SET NULL,
    CONSTRAINT sale_order_partner_id_fkey FOREIGN KEY (partner_id)
        REFERENCES public.res_partner (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE RESTRICT,
    CONSTRAINT sale_order_partner_invoice_id_fkey FOREIGN KEY (partner_invoice_id)
        REFERENCES public.res_partner (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE RESTRICT,
    CONSTRAINT sale_order_partner_shipping_id_fkey FOREIGN KEY (partner_shipping_id)
        REFERENCES public.res_partner (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE RESTRICT,
    CONSTRAINT sale_order_payment_term_id_fkey FOREIGN KEY (payment_term_id)
        REFERENCES public.account_payment_term (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE SET NULL,
    CONSTRAINT sale_order_planning_id_fkey FOREIGN KEY (planning_id)
        REFERENCES public.planning_slot (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE SET NULL,
    CONSTRAINT sale_order_pricelist_id_fkey FOREIGN KEY (pricelist_id)
        REFERENCES public.product_pricelist (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE RESTRICT,
    CONSTRAINT sale_order_procurement_group_id_fkey FOREIGN KEY (procurement_group_id)
        REFERENCES public.procurement_group (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE SET NULL,
    CONSTRAINT sale_order_responsable_intervention_fkey FOREIGN KEY (responsable_intervention)
        REFERENCES public.res_users (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE SET NULL,
    CONSTRAINT sale_order_sale_order_template_id_fkey FOREIGN KEY (sale_order_template_id)
        REFERENCES public.sale_order_template (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE SET NULL,
    CONSTRAINT sale_order_source_id_fkey FOREIGN KEY (source_id)
        REFERENCES public.utm_source (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE SET NULL,
    CONSTRAINT sale_order_style_fkey FOREIGN KEY (style)
        REFERENCES public.report_template_settings (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE SET NULL,
    CONSTRAINT sale_order_team_id_fkey FOREIGN KEY (team_id)
        REFERENCES public.crm_team (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE SET NULL,
    CONSTRAINT sale_order_user_id_fkey FOREIGN KEY (user_id)
        REFERENCES public.res_users (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE SET NULL,
    CONSTRAINT sale_order_warehouse_id_fkey FOREIGN KEY (warehouse_id)
        REFERENCES public.stock_warehouse (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE RESTRICT,
    CONSTRAINT sale_order_write_uid_fkey FOREIGN KEY (write_uid)
        REFERENCES public.res_users (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE SET NULL,
    CONSTRAINT sale_order_date_order_conditional_required CHECK ((state::text = ANY (ARRAY['sale'::character varying, 'done'::character varying]::text[])) AND date_order IS NOT NULL OR (state::text <> ALL (ARRAY['sale'::character varying, 'done'::character varying]::text[])))
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.sale_order
    OWNER to odoo;

COMMENT ON TABLE public.sale_order
    IS 'Sales Order';

COMMENT ON COLUMN public.sale_order.campaign_id
    IS 'Campaign';

COMMENT ON COLUMN public.sale_order.source_id
    IS 'Source';

COMMENT ON COLUMN public.sale_order.medium_id
    IS 'Medium';

COMMENT ON COLUMN public.sale_order.access_token
    IS 'Security Token';

COMMENT ON COLUMN public.sale_order.message_main_attachment_id
    IS 'Main Attachment';

COMMENT ON COLUMN public.sale_order.name
    IS 'Order Reference';

COMMENT ON COLUMN public.sale_order.origin
    IS 'Source Document';

COMMENT ON COLUMN public.sale_order.client_order_ref
    IS 'Customer Reference';

COMMENT ON COLUMN public.sale_order.reference
    IS 'Payment Ref.';

COMMENT ON COLUMN public.sale_order.state
    IS 'Status';

COMMENT ON COLUMN public.sale_order.date_order
    IS 'Order Date';

COMMENT ON COLUMN public.sale_order.validity_date
    IS 'Expiration';

COMMENT ON COLUMN public.sale_order.require_signature
    IS 'Online Signature';

COMMENT ON COLUMN public.sale_order.require_payment
    IS 'Online Payment';

COMMENT ON COLUMN public.sale_order.create_date
    IS 'Creation Date';

COMMENT ON COLUMN public.sale_order.user_id
    IS 'Salesperson';

COMMENT ON COLUMN public.sale_order.partner_id
    IS 'Customer';

COMMENT ON COLUMN public.sale_order.partner_invoice_id
    IS 'Invoice Address';

COMMENT ON COLUMN public.sale_order.partner_shipping_id
    IS 'Delivery Address';

COMMENT ON COLUMN public.sale_order.pricelist_id
    IS 'Pricelist';

COMMENT ON COLUMN public.sale_order.analytic_account_id
    IS 'Analytic Account';

COMMENT ON COLUMN public.sale_order.invoice_status
    IS 'Invoice Status';

COMMENT ON COLUMN public.sale_order.note
    IS 'Terms and conditions';

COMMENT ON COLUMN public.sale_order.amount_untaxed
    IS 'Untaxed Amount';

COMMENT ON COLUMN public.sale_order.amount_tax
    IS 'Taxes';

COMMENT ON COLUMN public.sale_order.amount_total
    IS 'Total';

COMMENT ON COLUMN public.sale_order.currency_rate
    IS 'Currency Rate';

COMMENT ON COLUMN public.sale_order.payment_term_id
    IS 'Payment Terms';

COMMENT ON COLUMN public.sale_order.fiscal_position_id
    IS 'Fiscal Position';

COMMENT ON COLUMN public.sale_order.company_id
    IS 'Company';

COMMENT ON COLUMN public.sale_order.team_id
    IS 'Sales Team';

COMMENT ON COLUMN public.sale_order.signed_by
    IS 'Signed By';

COMMENT ON COLUMN public.sale_order.signed_on
    IS 'Signed On';

COMMENT ON COLUMN public.sale_order.commitment_date
    IS 'Delivery Date';

COMMENT ON COLUMN public.sale_order.create_uid
    IS 'Created by';

COMMENT ON COLUMN public.sale_order.write_uid
    IS 'Last Updated by';

COMMENT ON COLUMN public.sale_order.write_date
    IS 'Last Updated on';

COMMENT ON COLUMN public.sale_order.sale_order_template_id
    IS 'Quotation Template';

COMMENT ON COLUMN public.sale_order.incoterm
    IS 'Incoterm';

COMMENT ON COLUMN public.sale_order.picking_policy
    IS 'Shipping Policy';

COMMENT ON COLUMN public.sale_order.warehouse_id
    IS 'Warehouse';

COMMENT ON COLUMN public.sale_order.procurement_group_id
    IS 'Procurement Group';

COMMENT ON COLUMN public.sale_order.effective_date
    IS 'Effective Date';

COMMENT ON COLUMN public.sale_order.style
    IS 'Quote/Order Style';

COMMENT ON COLUMN public.sale_order.project_title
    IS 'Title';

COMMENT ON COLUMN public.sale_order.opportunity_id
    IS 'Opportunity';

COMMENT ON COLUMN public.sale_order.carrier_id
    IS 'Delivery Method';

COMMENT ON COLUMN public.sale_order.delivery_message
    IS 'Delivery Message';

COMMENT ON COLUMN public.sale_order.delivery_rating_success
    IS 'Delivery Rating Success';

COMMENT ON COLUMN public.sale_order.recompute_delivery_price
    IS 'Delivery cost should be recomputed';

COMMENT ON COLUMN public.sale_order.planning_id
    IS 'planning';

COMMENT ON COLUMN public.sale_order.type_devis
    IS 'Type Devis';

COMMENT ON COLUMN public.sale_order.code_promo_program_id
    IS 'Applied Promo Program';

COMMENT ON COLUMN public.sale_order.force_invoiced
    IS 'Force invoiced';

COMMENT ON COLUMN public.sale_order.amount_words
    IS 'Arrêté le présent devis à la somme de:';

COMMENT ON COLUMN public.sale_order.state_devis
    IS 'Etat';

COMMENT ON COLUMN public.sale_order.dispatch_type
    IS 'Dispatch Type';

COMMENT ON COLUMN public.sale_order.hide_net_price
    IS 'Hide net price';

COMMENT ON COLUMN public.sale_order.old_state
    IS 'Old State';

COMMENT ON COLUMN public.sale_order.information
    IS 'Informations';

COMMENT ON COLUMN public.sale_order.zip_client
    IS 'Code postale';

COMMENT ON COLUMN public.sale_order.region
    IS 'state';

COMMENT ON COLUMN public.sale_order.ville_client
    IS 'Ville';

COMMENT ON COLUMN public.sale_order.region_client
    IS 'Region';

COMMENT ON COLUMN public.sale_order.ref_intervention
    IS 'ref Intervention';

COMMENT ON COLUMN public.sale_order.source
    IS 'Source de Devis';

COMMENT ON COLUMN public.sale_order.relance
    IS 'Relance';

COMMENT ON COLUMN public.sale_order.note_relance
    IS 'Note relance';

COMMENT ON COLUMN public.sale_order.date_relance
    IS 'Date relance';

COMMENT ON COLUMN public.sale_order.atelier_id
    IS 'Atelier';

COMMENT ON COLUMN public.sale_order.responsable_intervention
    IS 'Responsable Intervention';

COMMENT ON COLUMN public.sale_order.remarque
    IS 'remarque';

COMMENT ON COLUMN public.sale_order.status_pose
    IS 'Status Pose';

COMMENT ON COLUMN public.sale_order.decharge
    IS 'decharge';

COMMENT ON COLUMN public.sale_order.invoice_id
    IS 'facture';

COMMENT ON COLUMN public.sale_order.discount_type
    IS 'Remise';

COMMENT ON COLUMN public.sale_order.discount_rate
    IS 'valeur';

COMMENT ON COLUMN public.sale_order.amount_discount
    IS 'Remise';

COMMENT ON CONSTRAINT sale_order_date_order_conditional_required ON public.sale_order
    IS 'CHECK( (state IN (''sale'', ''done'') AND date_order IS NOT NULL) OR state NOT IN (''sale'', ''done'') )';
-- Index: sale_order_company_id_index

-- DROP INDEX IF EXISTS public.sale_order_company_id_index;

CREATE INDEX IF NOT EXISTS sale_order_company_id_index
    ON public.sale_order USING btree
    (company_id ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: sale_order_create_date_index

-- DROP INDEX IF EXISTS public.sale_order_create_date_index;

CREATE INDEX IF NOT EXISTS sale_order_create_date_index
    ON public.sale_order USING btree
    (create_date ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: sale_order_date_order_index

-- DROP INDEX IF EXISTS public.sale_order_date_order_index;

CREATE INDEX IF NOT EXISTS sale_order_date_order_index
    ON public.sale_order USING btree
    (date_order ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: sale_order_message_main_attachment_id_index

-- DROP INDEX IF EXISTS public.sale_order_message_main_attachment_id_index;

CREATE INDEX IF NOT EXISTS sale_order_message_main_attachment_id_index
    ON public.sale_order USING btree
    (message_main_attachment_id ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: sale_order_name_index

-- DROP INDEX IF EXISTS public.sale_order_name_index;

CREATE INDEX IF NOT EXISTS sale_order_name_index
    ON public.sale_order USING btree
    (name COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: sale_order_partner_id_index

-- DROP INDEX IF EXISTS public.sale_order_partner_id_index;

CREATE INDEX IF NOT EXISTS sale_order_partner_id_index
    ON public.sale_order USING btree
    (partner_id ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: sale_order_state_devis_index

-- DROP INDEX IF EXISTS public.sale_order_state_devis_index;

CREATE INDEX IF NOT EXISTS sale_order_state_devis_index
    ON public.sale_order USING btree
    (state_devis COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: sale_order_state_index

-- DROP INDEX IF EXISTS public.sale_order_state_index;

CREATE INDEX IF NOT EXISTS sale_order_state_index
    ON public.sale_order USING btree
    (state COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: sale_order_user_id_index

-- DROP INDEX IF EXISTS public.sale_order_user_id_index;

CREATE INDEX IF NOT EXISTS sale_order_user_id_index
    ON public.sale_order USING btree
    (user_id ASC NULLS LAST)
    TABLESPACE pg_default;