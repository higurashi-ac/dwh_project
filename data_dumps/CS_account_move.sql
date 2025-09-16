
CREATE TABLE IF NOT EXISTS public.account_move
(
    id integer NOT NULL DEFAULT nextval('account_move_id_seq'::regclass),
    access_token character varying COLLATE pg_catalog."default",
    message_main_attachment_id integer,
    name character varying COLLATE pg_catalog."default" NOT NULL,
    date date NOT NULL,
    ref character varying COLLATE pg_catalog."default",
    narration text COLLATE pg_catalog."default",
    state character varying COLLATE pg_catalog."default" NOT NULL,
    type character varying COLLATE pg_catalog."default" NOT NULL,
    to_check boolean,
    journal_id integer NOT NULL,
    company_id integer,
    currency_id integer NOT NULL,
    partner_id integer,
    commercial_partner_id integer,
    amount_untaxed numeric,
    amount_tax numeric,
    amount_total numeric,
    amount_residual numeric,
    amount_untaxed_signed numeric,
    amount_tax_signed numeric,
    amount_total_signed numeric,
    amount_residual_signed numeric,
    tax_cash_basis_rec_id integer,
    auto_post boolean,
    reversed_entry_id integer,
    fiscal_position_id integer,
    invoice_user_id integer,
    invoice_payment_state character varying COLLATE pg_catalog."default",
    invoice_date date,
    invoice_date_due date,
    invoice_payment_ref character varying COLLATE pg_catalog."default",
    invoice_sent boolean,
    invoice_origin character varying COLLATE pg_catalog."default",
    invoice_payment_term_id integer,
    invoice_partner_bank_id integer,
    invoice_incoterm_id integer,
    invoice_source_email character varying COLLATE pg_catalog."default",
    invoice_partner_display_name character varying COLLATE pg_catalog."default",
    invoice_cash_rounding_id integer,
    secure_sequence_number integer,
    inalterable_hash character varying COLLATE pg_catalog."default",
    create_uid integer,
    create_date timestamp without time zone,
    write_uid integer,
    write_date timestamp without time zone,
    campaign_id integer,
    source_id integer,
    medium_id integer,
    team_id integer,
    partner_shipping_id integer,
    stock_move_id integer,
    style integer,
    project_title character varying COLLATE pg_catalog."default",
    x_date_intervention date,
    x_reference text COLLATE pg_catalog."default",
    x_interlocultaire character varying COLLATE pg_catalog."default",
    move_name character varying COLLATE pg_catalog."default",
    hide_net_price boolean,
    dispatch_type character varying COLLATE pg_catalog."default",
    test character varying COLLATE pg_catalog."default",
    ville_client character varying COLLATE pg_catalog."default",
    region_client character varying COLLATE pg_catalog."default",
    invoice_origin_id integer,
    x_serialnumber text COLLATE pg_catalog."default",
    relance_mail integer,
    relance_tel character varying COLLATE pg_catalog."default",
    date_relance_tel timestamp without time zone,
    date_relance_mail timestamp without time zone,
    note_relance character varying COLLATE pg_catalog."default",
    pose_fini boolean,
    accompte double precision,
    discount_type character varying COLLATE pg_catalog."default",
    discount_rate numeric,
    amount_discount numeric
)
    CONSTRAINT account_move_pkey PRIMARY KEY (id),
    CONSTRAINT account_move_campaign_id_fkey FOREIGN KEY (campaign_id)
        REFERENCES public.utm_campaign (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE SET NULL,
    CONSTRAINT account_move_commercial_partner_id_fkey FOREIGN KEY (commercial_partner_id)
        REFERENCES public.res_partner (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE RESTRICT,
    CONSTRAINT account_move_company_id_fkey FOREIGN KEY (company_id)
        REFERENCES public.res_company (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE SET NULL,
    CONSTRAINT account_move_create_uid_fkey FOREIGN KEY (create_uid)
        REFERENCES public.res_users (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE SET NULL,
    CONSTRAINT account_move_currency_id_fkey FOREIGN KEY (currency_id)
        REFERENCES public.res_currency (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE RESTRICT,
    CONSTRAINT account_move_fiscal_position_id_fkey FOREIGN KEY (fiscal_position_id)
        REFERENCES public.account_fiscal_position (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE RESTRICT,
    CONSTRAINT account_move_invoice_cash_rounding_id_fkey FOREIGN KEY (invoice_cash_rounding_id)
        REFERENCES public.account_cash_rounding (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE SET NULL,
    CONSTRAINT account_move_invoice_incoterm_id_fkey FOREIGN KEY (invoice_incoterm_id)
        REFERENCES public.account_incoterms (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE SET NULL,
    CONSTRAINT account_move_invoice_partner_bank_id_fkey FOREIGN KEY (invoice_partner_bank_id)
        REFERENCES public.res_partner_bank (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE SET NULL,
    CONSTRAINT account_move_invoice_payment_term_id_fkey FOREIGN KEY (invoice_payment_term_id)
        REFERENCES public.account_payment_term (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE SET NULL,
    CONSTRAINT account_move_invoice_user_id_fkey FOREIGN KEY (invoice_user_id)
        REFERENCES public.res_users (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE SET NULL,
    CONSTRAINT account_move_journal_id_fkey FOREIGN KEY (journal_id)
        REFERENCES public.account_journal (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE RESTRICT,
    CONSTRAINT account_move_medium_id_fkey FOREIGN KEY (medium_id)
        REFERENCES public.utm_medium (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE SET NULL,
    CONSTRAINT account_move_message_main_attachment_id_fkey FOREIGN KEY (message_main_attachment_id)
        REFERENCES public.ir_attachment (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE SET NULL,
    CONSTRAINT account_move_partner_id_fkey FOREIGN KEY (partner_id)
        REFERENCES public.res_partner (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE RESTRICT,
    CONSTRAINT account_move_partner_shipping_id_fkey FOREIGN KEY (partner_shipping_id)
        REFERENCES public.res_partner (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE SET NULL,
    CONSTRAINT account_move_reversed_entry_id_fkey FOREIGN KEY (reversed_entry_id)
        REFERENCES public.account_move (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE SET NULL,
    CONSTRAINT account_move_source_id_fkey FOREIGN KEY (source_id)
        REFERENCES public.utm_source (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE SET NULL,
    CONSTRAINT account_move_stock_move_id_fkey FOREIGN KEY (stock_move_id)
        REFERENCES public.stock_move (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE SET NULL,
    CONSTRAINT account_move_style_fkey FOREIGN KEY (style)
        REFERENCES public.report_template_settings (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE SET NULL,
    CONSTRAINT account_move_tax_cash_basis_rec_id_fkey FOREIGN KEY (tax_cash_basis_rec_id)
        REFERENCES public.account_partial_reconcile (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE SET NULL,
    CONSTRAINT account_move_team_id_fkey FOREIGN KEY (team_id)
        REFERENCES public.crm_team (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE SET NULL,
    CONSTRAINT account_move_write_uid_fkey FOREIGN KEY (write_uid)
        REFERENCES public.res_users (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE SET NULL
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.account_move
    OWNER to odoo;

COMMENT ON TABLE public.account_move
    IS 'Journal Entries';

COMMENT ON COLUMN public.account_move.access_token
    IS 'Security Token';

COMMENT ON COLUMN public.account_move.message_main_attachment_id
    IS 'Main Attachment';

COMMENT ON COLUMN public.account_move.name
    IS 'Number';

COMMENT ON COLUMN public.account_move.date
    IS 'Date';

COMMENT ON COLUMN public.account_move.ref
    IS 'Reference';

COMMENT ON COLUMN public.account_move.narration
    IS 'Terms and Conditions';

COMMENT ON COLUMN public.account_move.state
    IS 'Status';

COMMENT ON COLUMN public.account_move.type
    IS 'Type';

COMMENT ON COLUMN public.account_move.to_check
    IS 'To Check';

COMMENT ON COLUMN public.account_move.journal_id
    IS 'Journal';

COMMENT ON COLUMN public.account_move.company_id
    IS 'Company';

COMMENT ON COLUMN public.account_move.currency_id
    IS 'Currency';

COMMENT ON COLUMN public.account_move.partner_id
    IS 'Partner';

COMMENT ON COLUMN public.account_move.commercial_partner_id
    IS 'Commercial Entity';

COMMENT ON COLUMN public.account_move.amount_untaxed
    IS 'Untaxed Amount';

COMMENT ON COLUMN public.account_move.amount_tax
    IS 'Tax';

COMMENT ON COLUMN public.account_move.amount_total
    IS 'Total';

COMMENT ON COLUMN public.account_move.amount_residual
    IS 'Amount Due';

COMMENT ON COLUMN public.account_move.amount_untaxed_signed
    IS 'Untaxed Amount Signed';

COMMENT ON COLUMN public.account_move.amount_tax_signed
    IS 'Tax Signed';

COMMENT ON COLUMN public.account_move.amount_total_signed
    IS 'Total Signed';

COMMENT ON COLUMN public.account_move.amount_residual_signed
    IS 'Amount Due Signed';

COMMENT ON COLUMN public.account_move.tax_cash_basis_rec_id
    IS 'Tax Cash Basis Entry of';

COMMENT ON COLUMN public.account_move.auto_post
    IS 'Post Automatically';

COMMENT ON COLUMN public.account_move.reversed_entry_id
    IS 'Reversal of';

COMMENT ON COLUMN public.account_move.fiscal_position_id
    IS 'Fiscal Position';

COMMENT ON COLUMN public.account_move.invoice_user_id
    IS 'Salesperson';

COMMENT ON COLUMN public.account_move.invoice_payment_state
    IS 'Payment';

COMMENT ON COLUMN public.account_move.invoice_date
    IS 'Invoice/Bill Date';

COMMENT ON COLUMN public.account_move.invoice_date_due
    IS 'Due Date';

COMMENT ON COLUMN public.account_move.invoice_payment_ref
    IS 'Payment Reference';

COMMENT ON COLUMN public.account_move.invoice_sent
    IS 'Invoice Sent';

COMMENT ON COLUMN public.account_move.invoice_origin
    IS 'Origin';

COMMENT ON COLUMN public.account_move.invoice_payment_term_id
    IS 'Payment Terms';

COMMENT ON COLUMN public.account_move.invoice_partner_bank_id
    IS 'Bank Account';

COMMENT ON COLUMN public.account_move.invoice_incoterm_id
    IS 'Incoterm';

COMMENT ON COLUMN public.account_move.invoice_source_email
    IS 'Source Email';

COMMENT ON COLUMN public.account_move.invoice_partner_display_name
    IS 'Invoice Partner Display Name';

COMMENT ON COLUMN public.account_move.invoice_cash_rounding_id
    IS 'Cash Rounding Method';

COMMENT ON COLUMN public.account_move.secure_sequence_number
    IS 'Inalteralbility No Gap Sequence #';

COMMENT ON COLUMN public.account_move.inalterable_hash
    IS 'Inalterability Hash';

COMMENT ON COLUMN public.account_move.create_uid
    IS 'Created by';

COMMENT ON COLUMN public.account_move.create_date
    IS 'Created on';

COMMENT ON COLUMN public.account_move.write_uid
    IS 'Last Updated by';

COMMENT ON COLUMN public.account_move.write_date
    IS 'Last Updated on';

COMMENT ON COLUMN public.account_move.campaign_id
    IS 'Campaign';

COMMENT ON COLUMN public.account_move.source_id
    IS 'Source';

COMMENT ON COLUMN public.account_move.medium_id
    IS 'Medium';

COMMENT ON COLUMN public.account_move.team_id
    IS 'Sales Team';

COMMENT ON COLUMN public.account_move.partner_shipping_id
    IS 'Delivery Address';

COMMENT ON COLUMN public.account_move.stock_move_id
    IS 'Stock Move';

COMMENT ON COLUMN public.account_move.style
    IS 'Invoice Style';

COMMENT ON COLUMN public.account_move.project_title
    IS 'Title';

COMMENT ON COLUMN public.account_move.x_date_intervention
    IS 'Date d''intervention';

COMMENT ON COLUMN public.account_move.x_reference
    IS 'Référence';

COMMENT ON COLUMN public.account_move.x_interlocultaire
    IS 'Interlocutaire';

COMMENT ON COLUMN public.account_move.move_name
    IS 'Force Number';

COMMENT ON COLUMN public.account_move.hide_net_price
    IS 'Hide net price';

COMMENT ON COLUMN public.account_move.dispatch_type
    IS 'Dispatch Type';

COMMENT ON COLUMN public.account_move.test
    IS 'test';

COMMENT ON COLUMN public.account_move.ville_client
    IS 'Ville';

COMMENT ON COLUMN public.account_move.region_client
    IS 'Region';

COMMENT ON COLUMN public.account_move.invoice_origin_id
    IS 'Invoice Origin Id';

COMMENT ON COLUMN public.account_move.x_serialnumber
    IS 'Serial Number';

COMMENT ON COLUMN public.account_move.relance_mail
    IS 'Relance par mail';

COMMENT ON COLUMN public.account_move.relance_tel
    IS 'Relance par tel';

COMMENT ON COLUMN public.account_move.date_relance_tel
    IS 'Date relance par tel';

COMMENT ON COLUMN public.account_move.date_relance_mail
    IS 'Date relance par mail';

COMMENT ON COLUMN public.account_move.note_relance
    IS 'Note de la relance';

COMMENT ON COLUMN public.account_move.pose_fini
    IS 'pose fini';

COMMENT ON COLUMN public.account_move.accompte
    IS 'accompte';

COMMENT ON COLUMN public.account_move.discount_type
    IS 'Remise';

COMMENT ON COLUMN public.account_move.discount_rate
    IS 'valeur';

COMMENT ON COLUMN public.account_move.amount_discount
    IS 'Remise';
-- Index: account_move_date_index

-- DROP INDEX IF EXISTS public.account_move_date_index;

CREATE INDEX IF NOT EXISTS account_move_date_index
    ON public.account_move USING btree
    (date ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: account_move_invoice_date_due_index

-- DROP INDEX IF EXISTS public.account_move_invoice_date_due_index;

CREATE INDEX IF NOT EXISTS account_move_invoice_date_due_index
    ON public.account_move USING btree
    (invoice_date_due ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: account_move_invoice_date_index

-- DROP INDEX IF EXISTS public.account_move_invoice_date_index;

CREATE INDEX IF NOT EXISTS account_move_invoice_date_index
    ON public.account_move USING btree
    (invoice_date ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: account_move_invoice_payment_ref_index

-- DROP INDEX IF EXISTS public.account_move_invoice_payment_ref_index;

CREATE INDEX IF NOT EXISTS account_move_invoice_payment_ref_index
    ON public.account_move USING btree
    (invoice_payment_ref COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: account_move_message_main_attachment_id_index

-- DROP INDEX IF EXISTS public.account_move_message_main_attachment_id_index;

CREATE INDEX IF NOT EXISTS account_move_message_main_attachment_id_index
    ON public.account_move USING btree
    (message_main_attachment_id ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: account_move_stock_move_id_index

-- DROP INDEX IF EXISTS public.account_move_stock_move_id_index;

CREATE INDEX IF NOT EXISTS account_move_stock_move_id_index
    ON public.account_move USING btree
    (stock_move_id ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: account_move_type_index

-- DROP INDEX IF EXISTS public.account_move_type_index;

CREATE INDEX IF NOT EXISTS account_move_type_index
    ON public.account_move USING btree
    (type COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;