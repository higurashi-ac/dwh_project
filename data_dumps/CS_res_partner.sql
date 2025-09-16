-- Table: public.res_partner

-- DROP TABLE IF EXISTS public.res_partner;

CREATE TABLE IF NOT EXISTS public.res_partner
(
    id integer NOT NULL DEFAULT nextval('res_partner_id_seq'::regclass),
    name character varying COLLATE pg_catalog."default",
    company_id integer,
    create_date timestamp without time zone,
    display_name character varying COLLATE pg_catalog."default",
    date date,
    title integer,
    parent_id integer,
    ref character varying COLLATE pg_catalog."default",
    lang character varying COLLATE pg_catalog."default",
    tz character varying COLLATE pg_catalog."default",
    user_id integer,
    vat character varying COLLATE pg_catalog."default",
    website character varying COLLATE pg_catalog."default",
    comment text COLLATE pg_catalog."default",
    credit_limit double precision,
    active boolean,
    employee boolean,
    function character varying COLLATE pg_catalog."default",
    type character varying COLLATE pg_catalog."default",
    street character varying COLLATE pg_catalog."default",
    street2 character varying COLLATE pg_catalog."default",
    zip character varying COLLATE pg_catalog."default",
    city character varying COLLATE pg_catalog."default",
    state_id integer,
    country_id integer,
    partner_latitude numeric,
    partner_longitude numeric,
    email character varying COLLATE pg_catalog."default",
    phone character varying COLLATE pg_catalog."default",
    mobile character varying COLLATE pg_catalog."default",
    is_company boolean,
    industry_id integer,
    color integer,
    partner_share boolean,
    commercial_partner_id integer,
    commercial_company_name character varying COLLATE pg_catalog."default",
    company_name character varying COLLATE pg_catalog."default",
    create_uid integer,
    write_uid integer,
    write_date timestamp without time zone,
    message_main_attachment_id integer,
    email_normalized character varying COLLATE pg_catalog."default",
    message_bounce integer,
    signup_token character varying COLLATE pg_catalog."default",
    signup_type character varying COLLATE pg_catalog."default",
    signup_expiration timestamp without time zone,
    team_id integer,
    debit_limit numeric,
    last_time_entries_checked timestamp without time zone,
    invoice_warn character varying COLLATE pg_catalog."default",
    invoice_warn_msg text COLLATE pg_catalog."default",
    supplier_rank integer,
    customer_rank integer,
    sale_warn character varying COLLATE pg_catalog."default",
    sale_warn_msg text COLLATE pg_catalog."default",
    siret character varying(14) COLLATE pg_catalog."default",
    picking_warn character varying COLLATE pg_catalog."default",
    picking_warn_msg text COLLATE pg_catalog."default",
    delivery_instructions text COLLATE pg_catalog."default",
    style integer,
    street_name character varying COLLATE pg_catalog."default",
    street_number character varying COLLATE pg_catalog."default",
    street_number2 character varying COLLATE pg_catalog."default",
    date_localization date,
    calendar_last_notif_ack timestamp without time zone,
    purchase_warn character varying COLLATE pg_catalog."default",
    purchase_warn_msg text COLLATE pg_catalog."default",
    plan_to_change_car boolean,
    default_supplierinfo_discount numeric,
    barcode character varying COLLATE pg_catalog."default",
    places character varying COLLATE pg_catalog."default",
    x_message text COLLATE pg_catalog."default",
    x_note text COLLATE pg_catalog."default",
    x_interphone text COLLATE pg_catalog."default",
    x_code text COLLATE pg_catalog."default",
    x_origin text COLLATE pg_catalog."default",
    x_state character varying COLLATE pg_catalog."default",
    x_date date,
    x_date_reponse date,
    x_operation character varying COLLATE pg_catalog."default",
    x_objet text COLLATE pg_catalog."default",
    partner_invoice character varying COLLATE pg_catalog."default",
    partner_delivery character varying COLLATE pg_catalog."default",
    CONSTRAINT res_partner_pkey PRIMARY KEY (id),
    CONSTRAINT res_partner_unique_barcode UNIQUE (barcode, company_id),
    CONSTRAINT res_partner_commercial_partner_id_fkey FOREIGN KEY (commercial_partner_id)
        REFERENCES public.res_partner (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE SET NULL,
    CONSTRAINT res_partner_company_id_fkey FOREIGN KEY (company_id)
        REFERENCES public.res_company (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE SET NULL,
    CONSTRAINT res_partner_country_id_fkey FOREIGN KEY (country_id)
        REFERENCES public.res_country (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE RESTRICT,
    CONSTRAINT res_partner_create_uid_fkey FOREIGN KEY (create_uid)
        REFERENCES public.res_users (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE SET NULL,
    CONSTRAINT res_partner_industry_id_fkey FOREIGN KEY (industry_id)
        REFERENCES public.res_partner_industry (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE SET NULL,
    CONSTRAINT res_partner_message_main_attachment_id_fkey FOREIGN KEY (message_main_attachment_id)
        REFERENCES public.ir_attachment (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE SET NULL,
    CONSTRAINT res_partner_parent_id_fkey FOREIGN KEY (parent_id)
        REFERENCES public.res_partner (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE SET NULL,
    CONSTRAINT res_partner_state_id_fkey FOREIGN KEY (state_id)
        REFERENCES public.res_country_state (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE RESTRICT,
    CONSTRAINT res_partner_style_fkey FOREIGN KEY (style)
        REFERENCES public.report_template_settings (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE SET NULL,
    CONSTRAINT res_partner_team_id_fkey FOREIGN KEY (team_id)
        REFERENCES public.crm_team (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE SET NULL,
    CONSTRAINT res_partner_title_fkey FOREIGN KEY (title)
        REFERENCES public.res_partner_title (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE SET NULL,
    CONSTRAINT res_partner_user_id_fkey FOREIGN KEY (user_id)
        REFERENCES public.res_users (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE SET NULL,
    CONSTRAINT res_partner_write_uid_fkey FOREIGN KEY (write_uid)
        REFERENCES public.res_users (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE SET NULL,
    CONSTRAINT res_partner_check_name CHECK (type::text = 'contact'::text AND name IS NOT NULL OR type::text <> 'contact'::text)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.res_partner
    OWNER to odoo;

COMMENT ON COLUMN public.res_partner.display_name
    IS 'Display Name';

COMMENT ON COLUMN public.res_partner.date
    IS 'Date';

COMMENT ON COLUMN public.res_partner.title
    IS 'Title';

COMMENT ON COLUMN public.res_partner.parent_id
    IS 'Related Company';

COMMENT ON COLUMN public.res_partner.ref
    IS 'Reference';

COMMENT ON COLUMN public.res_partner.lang
    IS 'Language';

COMMENT ON COLUMN public.res_partner.tz
    IS 'Timezone';

COMMENT ON COLUMN public.res_partner.user_id
    IS 'Salesperson';

COMMENT ON COLUMN public.res_partner.vat
    IS 'Tax ID';

COMMENT ON COLUMN public.res_partner.website
    IS 'Website Link';

COMMENT ON COLUMN public.res_partner.comment
    IS 'Notes';

COMMENT ON COLUMN public.res_partner.credit_limit
    IS 'Credit Limit';

COMMENT ON COLUMN public.res_partner.active
    IS 'Active';

COMMENT ON COLUMN public.res_partner.employee
    IS 'Employee';

COMMENT ON COLUMN public.res_partner.function
    IS 'Job Position';

COMMENT ON COLUMN public.res_partner.type
    IS 'Address Type';

COMMENT ON COLUMN public.res_partner.street
    IS 'Street';

COMMENT ON COLUMN public.res_partner.street2
    IS 'Street2';

COMMENT ON COLUMN public.res_partner.zip
    IS 'Zip';

COMMENT ON COLUMN public.res_partner.city
    IS 'City';

COMMENT ON COLUMN public.res_partner.state_id
    IS 'State';

COMMENT ON COLUMN public.res_partner.country_id
    IS 'Country';

COMMENT ON COLUMN public.res_partner.partner_latitude
    IS 'Geo Latitude';

COMMENT ON COLUMN public.res_partner.partner_longitude
    IS 'Geo Longitude';

COMMENT ON COLUMN public.res_partner.email
    IS 'Email';

COMMENT ON COLUMN public.res_partner.phone
    IS 'Phone';

COMMENT ON COLUMN public.res_partner.mobile
    IS 'Mobile';

COMMENT ON COLUMN public.res_partner.is_company
    IS 'Is a Company';

COMMENT ON COLUMN public.res_partner.industry_id
    IS 'Industry';

COMMENT ON COLUMN public.res_partner.color
    IS 'Color Index';

COMMENT ON COLUMN public.res_partner.partner_share
    IS 'Share Partner';

COMMENT ON COLUMN public.res_partner.commercial_partner_id
    IS 'Commercial Entity';

COMMENT ON COLUMN public.res_partner.commercial_company_name
    IS 'Company Name Entity';

COMMENT ON COLUMN public.res_partner.company_name
    IS 'Company Name';

COMMENT ON COLUMN public.res_partner.create_uid
    IS 'Created by';

COMMENT ON COLUMN public.res_partner.write_uid
    IS 'Last Updated by';

COMMENT ON COLUMN public.res_partner.write_date
    IS 'Last Updated on';

COMMENT ON COLUMN public.res_partner.message_main_attachment_id
    IS 'Main Attachment';

COMMENT ON COLUMN public.res_partner.email_normalized
    IS 'Normalized Email';

COMMENT ON COLUMN public.res_partner.message_bounce
    IS 'Bounce';

COMMENT ON COLUMN public.res_partner.signup_token
    IS 'Signup Token';

COMMENT ON COLUMN public.res_partner.signup_type
    IS 'Signup Token Type';

COMMENT ON COLUMN public.res_partner.signup_expiration
    IS 'Signup Expiration';

COMMENT ON COLUMN public.res_partner.team_id
    IS 'Sales Team';

COMMENT ON COLUMN public.res_partner.debit_limit
    IS 'Payable Limit';

COMMENT ON COLUMN public.res_partner.last_time_entries_checked
    IS 'Latest Invoices & Payments Matching Date';

COMMENT ON COLUMN public.res_partner.invoice_warn
    IS 'Invoice';

COMMENT ON COLUMN public.res_partner.invoice_warn_msg
    IS 'Message for Invoice';

COMMENT ON COLUMN public.res_partner.supplier_rank
    IS 'Supplier Rank';

COMMENT ON COLUMN public.res_partner.customer_rank
    IS 'Customer Rank';

COMMENT ON COLUMN public.res_partner.sale_warn
    IS 'Sales Warnings';

COMMENT ON COLUMN public.res_partner.sale_warn_msg
    IS 'Message for Sales Order';

COMMENT ON COLUMN public.res_partner.siret
    IS 'SIRET';

COMMENT ON COLUMN public.res_partner.picking_warn
    IS 'Stock Picking';

COMMENT ON COLUMN public.res_partner.picking_warn_msg
    IS 'Message for Stock Picking';

COMMENT ON COLUMN public.res_partner.delivery_instructions
    IS 'Delivery Instructions';

COMMENT ON COLUMN public.res_partner.style
    IS 'Reports Style';

COMMENT ON COLUMN public.res_partner.street_name
    IS 'Street Name';

COMMENT ON COLUMN public.res_partner.street_number
    IS 'House';

COMMENT ON COLUMN public.res_partner.street_number2
    IS 'Door';

COMMENT ON COLUMN public.res_partner.date_localization
    IS 'Geolocation Date';

COMMENT ON COLUMN public.res_partner.calendar_last_notif_ack
    IS 'Last notification marked as read from base Calendar';

COMMENT ON COLUMN public.res_partner.purchase_warn
    IS 'Purchase Order';

COMMENT ON COLUMN public.res_partner.purchase_warn_msg
    IS 'Message for Purchase Order';

COMMENT ON COLUMN public.res_partner.plan_to_change_car
    IS 'Plan To Change Car';

COMMENT ON COLUMN public.res_partner.default_supplierinfo_discount
    IS 'Default Supplier Discount (%)';

COMMENT ON COLUMN public.res_partner.barcode
    IS 'Barcode';

COMMENT ON COLUMN public.res_partner.places
    IS 'place';

COMMENT ON COLUMN public.res_partner.x_message
    IS 'Message';

COMMENT ON COLUMN public.res_partner.x_note
    IS 'Note';

COMMENT ON COLUMN public.res_partner.x_interphone
    IS 'Interphone';

COMMENT ON COLUMN public.res_partner.x_code
    IS 'Code d''acces';

COMMENT ON COLUMN public.res_partner.x_origin
    IS 'Source';

COMMENT ON COLUMN public.res_partner.x_state
    IS 'Etat de demande par mail';

COMMENT ON COLUMN public.res_partner.x_date
    IS 'Date de l''email';

COMMENT ON COLUMN public.res_partner.x_date_reponse
    IS 'Date de la reponse';

COMMENT ON COLUMN public.res_partner.x_operation
    IS 'Operation';

COMMENT ON COLUMN public.res_partner.x_objet
    IS 'email object';

COMMENT ON COLUMN public.res_partner.partner_invoice
    IS 'Invoice address';

COMMENT ON COLUMN public.res_partner.partner_delivery
    IS 'Delivery address';

COMMENT ON CONSTRAINT res_partner_unique_barcode ON public.res_partner
    IS 'unique(barcode, company_id)';

COMMENT ON CONSTRAINT res_partner_check_name ON public.res_partner
    IS 'CHECK( (type=''contact'' AND name IS NOT NULL) or (type!=''contact'') )';
-- Index: res_partner_commercial_partner_id_index

-- DROP INDEX IF EXISTS public.res_partner_commercial_partner_id_index;

CREATE INDEX IF NOT EXISTS res_partner_commercial_partner_id_index
    ON public.res_partner USING btree
    (commercial_partner_id ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: res_partner_company_id_index

-- DROP INDEX IF EXISTS public.res_partner_company_id_index;

CREATE INDEX IF NOT EXISTS res_partner_company_id_index
    ON public.res_partner USING btree
    (company_id ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: res_partner_date_index

-- DROP INDEX IF EXISTS public.res_partner_date_index;

CREATE INDEX IF NOT EXISTS res_partner_date_index
    ON public.res_partner USING btree
    (date ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: res_partner_display_name_index

-- DROP INDEX IF EXISTS public.res_partner_display_name_index;

CREATE INDEX IF NOT EXISTS res_partner_display_name_index
    ON public.res_partner USING btree
    (display_name COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: res_partner_message_main_attachment_id_index

-- DROP INDEX IF EXISTS public.res_partner_message_main_attachment_id_index;

CREATE INDEX IF NOT EXISTS res_partner_message_main_attachment_id_index
    ON public.res_partner USING btree
    (message_main_attachment_id ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: res_partner_name_index

-- DROP INDEX IF EXISTS public.res_partner_name_index;

CREATE INDEX IF NOT EXISTS res_partner_name_index
    ON public.res_partner USING btree
    (name COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: res_partner_parent_id_index

-- DROP INDEX IF EXISTS public.res_partner_parent_id_index;

CREATE INDEX IF NOT EXISTS res_partner_parent_id_index
    ON public.res_partner USING btree
    (parent_id ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: res_partner_ref_index

-- DROP INDEX IF EXISTS public.res_partner_ref_index;

CREATE INDEX IF NOT EXISTS res_partner_ref_index
    ON public.res_partner USING btree
    (ref COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: res_partner_vat_index

-- DROP INDEX IF EXISTS public.res_partner_vat_index;

CREATE INDEX IF NOT EXISTS res_partner_vat_index
    ON public.res_partner USING btree
    (vat COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;