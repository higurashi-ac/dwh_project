-- Table: public.account_journal

-- DROP TABLE IF EXISTS public.account_journal;

CREATE TABLE IF NOT EXISTS public.account_journal
(
    id integer NOT NULL DEFAULT nextval('account_journal_id_seq'::regclass),
    message_main_attachment_id integer,
    name character varying COLLATE pg_catalog."default" NOT NULL,
    code character varying(5) COLLATE pg_catalog."default" NOT NULL,
    active boolean,
    type character varying COLLATE pg_catalog."default" NOT NULL,
    default_credit_account_id integer,
    default_debit_account_id integer,
    restrict_mode_hash_table boolean,
    sequence_id integer NOT NULL,
    refund_sequence_id integer,
    sequence integer,
    invoice_reference_type character varying COLLATE pg_catalog."default" NOT NULL,
    invoice_reference_model character varying COLLATE pg_catalog."default" NOT NULL,
    currency_id integer,
    company_id integer NOT NULL,
    refund_sequence boolean,
    at_least_one_inbound boolean,
    at_least_one_outbound boolean,
    profit_account_id integer,
    loss_account_id integer,
    bank_account_id integer,
    bank_statements_source character varying COLLATE pg_catalog."default",
    post_at character varying COLLATE pg_catalog."default",
    alias_id integer,
    secure_sequence_id integer,
    show_on_dashboard boolean,
    color integer,
    create_uid integer,
    create_date timestamp without time zone,
    write_uid integer,
    write_date timestamp without time zone,
    check_manual_sequencing boolean,
    check_sequence_id integer,
    check_print_auto boolean,
    check_layout_id integer,
    x_bnpp_cert_file integer,
    CONSTRAINT account_journal_pkey PRIMARY KEY (id),
    CONSTRAINT account_journal_code_company_uniq UNIQUE (code, name, company_id),
    CONSTRAINT account_journal_alias_id_fkey FOREIGN KEY (alias_id)
        REFERENCES public.mail_alias (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE SET NULL,
    CONSTRAINT account_journal_bank_account_id_fkey FOREIGN KEY (bank_account_id)
        REFERENCES public.res_partner_bank (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE RESTRICT,
    CONSTRAINT account_journal_check_layout_id_fkey FOREIGN KEY (check_layout_id)
        REFERENCES public.account_payment_check_report (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE SET NULL,
    CONSTRAINT account_journal_check_sequence_id_fkey FOREIGN KEY (check_sequence_id)
        REFERENCES public.ir_sequence (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE SET NULL,
    CONSTRAINT account_journal_company_id_fkey FOREIGN KEY (company_id)
        REFERENCES public.res_company (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE RESTRICT,
    CONSTRAINT account_journal_create_uid_fkey FOREIGN KEY (create_uid)
        REFERENCES public.res_users (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE SET NULL,
    CONSTRAINT account_journal_currency_id_fkey FOREIGN KEY (currency_id)
        REFERENCES public.res_currency (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE SET NULL,
    CONSTRAINT account_journal_default_credit_account_id_fkey FOREIGN KEY (default_credit_account_id)
        REFERENCES public.account_account (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE RESTRICT,
    CONSTRAINT account_journal_default_debit_account_id_fkey FOREIGN KEY (default_debit_account_id)
        REFERENCES public.account_account (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE RESTRICT,
    CONSTRAINT account_journal_loss_account_id_fkey FOREIGN KEY (loss_account_id)
        REFERENCES public.account_account (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE SET NULL,
    CONSTRAINT account_journal_message_main_attachment_id_fkey FOREIGN KEY (message_main_attachment_id)
        REFERENCES public.ir_attachment (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE SET NULL,
    CONSTRAINT account_journal_profit_account_id_fkey FOREIGN KEY (profit_account_id)
        REFERENCES public.account_account (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE SET NULL,
    CONSTRAINT account_journal_refund_sequence_id_fkey FOREIGN KEY (refund_sequence_id)
        REFERENCES public.ir_sequence (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE SET NULL,
    CONSTRAINT account_journal_secure_sequence_id_fkey FOREIGN KEY (secure_sequence_id)
        REFERENCES public.ir_sequence (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE SET NULL,
    CONSTRAINT account_journal_sequence_id_fkey FOREIGN KEY (sequence_id)
        REFERENCES public.ir_sequence (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE RESTRICT,
    CONSTRAINT account_journal_write_uid_fkey FOREIGN KEY (write_uid)
        REFERENCES public.res_users (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE SET NULL,
    CONSTRAINT account_journal_x_bnpp_cert_file_fkey FOREIGN KEY (x_bnpp_cert_file)
        REFERENCES public.ir_attachment (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE SET NULL
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.account_journal
    OWNER to odoo;

COMMENT ON TABLE public.account_journal
    IS 'Journal';

COMMENT ON COLUMN public.account_journal.message_main_attachment_id
    IS 'Main Attachment';

COMMENT ON COLUMN public.account_journal.name
    IS 'Journal Name';

COMMENT ON COLUMN public.account_journal.code
    IS 'Short Code';

COMMENT ON COLUMN public.account_journal.active
    IS 'Active';

COMMENT ON COLUMN public.account_journal.type
    IS 'Type';

COMMENT ON COLUMN public.account_journal.default_credit_account_id
    IS 'Default Credit Account';

COMMENT ON COLUMN public.account_journal.default_debit_account_id
    IS 'Default Debit Account';

COMMENT ON COLUMN public.account_journal.restrict_mode_hash_table
    IS 'Lock Posted Entries with Hash';

COMMENT ON COLUMN public.account_journal.sequence_id
    IS 'Entry Sequence';

COMMENT ON COLUMN public.account_journal.refund_sequence_id
    IS 'Credit Note Entry Sequence';

COMMENT ON COLUMN public.account_journal.sequence
    IS 'Sequence';

COMMENT ON COLUMN public.account_journal.invoice_reference_type
    IS 'Communication Type';

COMMENT ON COLUMN public.account_journal.invoice_reference_model
    IS 'Communication Standard';

COMMENT ON COLUMN public.account_journal.currency_id
    IS 'Currency';

COMMENT ON COLUMN public.account_journal.company_id
    IS 'Company';

COMMENT ON COLUMN public.account_journal.refund_sequence
    IS 'Dedicated Credit Note Sequence';

COMMENT ON COLUMN public.account_journal.at_least_one_inbound
    IS 'At Least One Inbound';

COMMENT ON COLUMN public.account_journal.at_least_one_outbound
    IS 'At Least One Outbound';

COMMENT ON COLUMN public.account_journal.profit_account_id
    IS 'Profit Account';

COMMENT ON COLUMN public.account_journal.loss_account_id
    IS 'Loss Account';

COMMENT ON COLUMN public.account_journal.bank_account_id
    IS 'Bank Account';

COMMENT ON COLUMN public.account_journal.bank_statements_source
    IS 'Bank Feeds';

COMMENT ON COLUMN public.account_journal.post_at
    IS 'Post At';

COMMENT ON COLUMN public.account_journal.alias_id
    IS 'Alias';

COMMENT ON COLUMN public.account_journal.secure_sequence_id
    IS 'Secure Sequence';

COMMENT ON COLUMN public.account_journal.show_on_dashboard
    IS 'Show journal on dashboard';

COMMENT ON COLUMN public.account_journal.color
    IS 'Color Index';

COMMENT ON COLUMN public.account_journal.create_uid
    IS 'Created by';

COMMENT ON COLUMN public.account_journal.create_date
    IS 'Created on';

COMMENT ON COLUMN public.account_journal.write_uid
    IS 'Last Updated by';

COMMENT ON COLUMN public.account_journal.write_date
    IS 'Last Updated on';

COMMENT ON COLUMN public.account_journal.check_manual_sequencing
    IS 'Manual Numbering';

COMMENT ON COLUMN public.account_journal.check_sequence_id
    IS 'Check Sequence';

COMMENT ON COLUMN public.account_journal.check_print_auto
    IS 'Automatic check printing';

COMMENT ON COLUMN public.account_journal.check_layout_id
    IS 'Check format';

COMMENT ON COLUMN public.account_journal.x_bnpp_cert_file
    IS 'X Bnpp Cert File';

COMMENT ON CONSTRAINT account_journal_code_company_uniq ON public.account_journal
    IS 'unique (code, name, company_id)';
-- Index: account_journal_company_id_index

-- DROP INDEX IF EXISTS public.account_journal_company_id_index;

CREATE INDEX IF NOT EXISTS account_journal_company_id_index
    ON public.account_journal USING btree
    (company_id ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: account_journal_message_main_attachment_id_index

-- DROP INDEX IF EXISTS public.account_journal_message_main_attachment_id_index;

CREATE INDEX IF NOT EXISTS account_journal_message_main_attachment_id_index
    ON public.account_journal USING btree
    (message_main_attachment_id ASC NULLS LAST)
    TABLESPACE pg_default;