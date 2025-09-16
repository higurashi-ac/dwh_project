-- Table: public.purchase_order

-- DROP TABLE IF EXISTS public.purchase_order;

CREATE TABLE IF NOT EXISTS public.purchase_order
(
    id integer NOT NULL DEFAULT nextval('purchase_order_id_seq'::regclass),
    name character varying COLLATE pg_catalog."default" NOT NULL,
    origin character varying COLLATE pg_catalog."default",
    partner_ref character varying COLLATE pg_catalog."default",
    date_order timestamp without time zone NOT NULL,
    date_approve timestamp without time zone,
    partner_id integer NOT NULL,
    dest_address_id integer,
    currency_id integer NOT NULL,
    state character varying COLLATE pg_catalog."default",
    notes text COLLATE pg_catalog."default",
    invoice_count integer,
    invoice_status character varying COLLATE pg_catalog."default",
    date_planned timestamp without time zone,
    amount_untaxed numeric,
    amount_tax numeric,
    amount_total numeric,
    fiscal_position_id integer,
    payment_term_id integer,
    incoterm_id integer,
    user_id integer,
    company_id integer NOT NULL,
    currency_rate double precision,
    message_main_attachment_id integer,
    access_token character varying COLLATE pg_catalog."default",
    create_uid integer,
    create_date timestamp without time zone,
    write_uid integer,
    write_date timestamp without time zone,
    picking_count integer,
    picking_type_id integer NOT NULL,
    group_id integer,
    hide_net_price boolean,
    dispatch_type character varying COLLATE pg_catalog."default",
    "Note" text COLLATE pg_catalog."default",
    "Adresse" text COLLATE pg_catalog."default",
    report_grids boolean,
    CONSTRAINT purchase_order_pkey PRIMARY KEY (id),
    CONSTRAINT purchase_order_company_id_fkey FOREIGN KEY (company_id)
        REFERENCES public.res_company (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE RESTRICT,
    CONSTRAINT purchase_order_create_uid_fkey FOREIGN KEY (create_uid)
        REFERENCES public.res_users (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE SET NULL,
    CONSTRAINT purchase_order_currency_id_fkey FOREIGN KEY (currency_id)
        REFERENCES public.res_currency (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE RESTRICT,
    CONSTRAINT purchase_order_dest_address_id_fkey FOREIGN KEY (dest_address_id)
        REFERENCES public.res_partner (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE SET NULL,
    CONSTRAINT purchase_order_fiscal_position_id_fkey FOREIGN KEY (fiscal_position_id)
        REFERENCES public.account_fiscal_position (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE SET NULL,
    CONSTRAINT purchase_order_group_id_fkey FOREIGN KEY (group_id)
        REFERENCES public.procurement_group (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE SET NULL,
    CONSTRAINT purchase_order_incoterm_id_fkey FOREIGN KEY (incoterm_id)
        REFERENCES public.account_incoterms (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE SET NULL,
    CONSTRAINT purchase_order_message_main_attachment_id_fkey FOREIGN KEY (message_main_attachment_id)
        REFERENCES public.ir_attachment (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE SET NULL,
    CONSTRAINT purchase_order_partner_id_fkey FOREIGN KEY (partner_id)
        REFERENCES public.res_partner (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE RESTRICT,
    CONSTRAINT purchase_order_payment_term_id_fkey FOREIGN KEY (payment_term_id)
        REFERENCES public.account_payment_term (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE SET NULL,
    CONSTRAINT purchase_order_picking_type_id_fkey FOREIGN KEY (picking_type_id)
        REFERENCES public.stock_picking_type (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE RESTRICT,
    CONSTRAINT purchase_order_user_id_fkey FOREIGN KEY (user_id)
        REFERENCES public.res_users (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE SET NULL,
    CONSTRAINT purchase_order_write_uid_fkey FOREIGN KEY (write_uid)
        REFERENCES public.res_users (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE SET NULL
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.purchase_order
    OWNER to odoo;

COMMENT ON TABLE public.purchase_order
    IS 'Purchase Order';

COMMENT ON COLUMN public.purchase_order.name
    IS 'Order Reference';

COMMENT ON COLUMN public.purchase_order.origin
    IS 'Source Document';

COMMENT ON COLUMN public.purchase_order.partner_ref
    IS 'Vendor Reference';

COMMENT ON COLUMN public.purchase_order.date_order
    IS 'Order Date';

COMMENT ON COLUMN public.purchase_order.date_approve
    IS 'Confirmation Date';

COMMENT ON COLUMN public.purchase_order.partner_id
    IS 'Vendor';

COMMENT ON COLUMN public.purchase_order.dest_address_id
    IS 'Drop Ship Address';

COMMENT ON COLUMN public.purchase_order.currency_id
    IS 'Currency';

COMMENT ON COLUMN public.purchase_order.state
    IS 'Status';

COMMENT ON COLUMN public.purchase_order.notes
    IS 'Terms and Conditions';

COMMENT ON COLUMN public.purchase_order.invoice_count
    IS 'Bill Count';

COMMENT ON COLUMN public.purchase_order.invoice_status
    IS 'Billing Status';

COMMENT ON COLUMN public.purchase_order.date_planned
    IS 'Receipt Date';

COMMENT ON COLUMN public.purchase_order.amount_untaxed
    IS 'Untaxed Amount';

COMMENT ON COLUMN public.purchase_order.amount_tax
    IS 'Taxes';

COMMENT ON COLUMN public.purchase_order.amount_total
    IS 'Total';

COMMENT ON COLUMN public.purchase_order.fiscal_position_id
    IS 'Fiscal Position';

COMMENT ON COLUMN public.purchase_order.payment_term_id
    IS 'Payment Terms';

COMMENT ON COLUMN public.purchase_order.incoterm_id
    IS 'Incoterm';

COMMENT ON COLUMN public.purchase_order.user_id
    IS 'Purchase Representative';

COMMENT ON COLUMN public.purchase_order.company_id
    IS 'Company';

COMMENT ON COLUMN public.purchase_order.currency_rate
    IS 'Currency Rate';

COMMENT ON COLUMN public.purchase_order.message_main_attachment_id
    IS 'Main Attachment';

COMMENT ON COLUMN public.purchase_order.access_token
    IS 'Security Token';

COMMENT ON COLUMN public.purchase_order.create_uid
    IS 'Created by';

COMMENT ON COLUMN public.purchase_order.create_date
    IS 'Created on';

COMMENT ON COLUMN public.purchase_order.write_uid
    IS 'Last Updated by';

COMMENT ON COLUMN public.purchase_order.write_date
    IS 'Last Updated on';

COMMENT ON COLUMN public.purchase_order.picking_count
    IS 'Picking count';

COMMENT ON COLUMN public.purchase_order.picking_type_id
    IS 'Deliver To';

COMMENT ON COLUMN public.purchase_order.group_id
    IS 'Procurement Group';

COMMENT ON COLUMN public.purchase_order.hide_net_price
    IS 'Hide net price';

COMMENT ON COLUMN public.purchase_order.dispatch_type
    IS 'Dispatch Type';

COMMENT ON COLUMN public.purchase_order."Note"
    IS 'Note';

COMMENT ON COLUMN public.purchase_order."Adresse"
    IS 'Adresse';

COMMENT ON COLUMN public.purchase_order.report_grids
    IS 'Print Variant Grids';
-- Index: purchase_order_company_id_index

-- DROP INDEX IF EXISTS public.purchase_order_company_id_index;

CREATE INDEX IF NOT EXISTS purchase_order_company_id_index
    ON public.purchase_order USING btree
    (company_id ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: purchase_order_date_approve_index

-- DROP INDEX IF EXISTS public.purchase_order_date_approve_index;

CREATE INDEX IF NOT EXISTS purchase_order_date_approve_index
    ON public.purchase_order USING btree
    (date_approve ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: purchase_order_date_order_index

-- DROP INDEX IF EXISTS public.purchase_order_date_order_index;

CREATE INDEX IF NOT EXISTS purchase_order_date_order_index
    ON public.purchase_order USING btree
    (date_order ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: purchase_order_date_planned_index

-- DROP INDEX IF EXISTS public.purchase_order_date_planned_index;

CREATE INDEX IF NOT EXISTS purchase_order_date_planned_index
    ON public.purchase_order USING btree
    (date_planned ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: purchase_order_message_main_attachment_id_index

-- DROP INDEX IF EXISTS public.purchase_order_message_main_attachment_id_index;

CREATE INDEX IF NOT EXISTS purchase_order_message_main_attachment_id_index
    ON public.purchase_order USING btree
    (message_main_attachment_id ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: purchase_order_name_index

-- DROP INDEX IF EXISTS public.purchase_order_name_index;

CREATE INDEX IF NOT EXISTS purchase_order_name_index
    ON public.purchase_order USING btree
    (name COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: purchase_order_state_index

-- DROP INDEX IF EXISTS public.purchase_order_state_index;

CREATE INDEX IF NOT EXISTS purchase_order_state_index
    ON public.purchase_order USING btree
    (state COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: purchase_order_user_id_index

-- DROP INDEX IF EXISTS public.purchase_order_user_id_index;

CREATE INDEX IF NOT EXISTS purchase_order_user_id_index
    ON public.purchase_order USING btree
    (user_id ASC NULLS LAST)
    TABLESPACE pg_default;