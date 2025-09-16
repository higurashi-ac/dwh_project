-- Table: public.purchase_order_line

-- DROP TABLE IF EXISTS public.purchase_order_line;

CREATE TABLE IF NOT EXISTS public.purchase_order_line
(
    id integer NOT NULL DEFAULT nextval('purchase_order_line_id_seq'::regclass),
    name text COLLATE pg_catalog."default" NOT NULL,
    sequence integer,
    product_qty numeric NOT NULL,
    product_uom_qty double precision,
    date_planned timestamp without time zone,
    product_uom integer,
    product_id integer,
    price_unit numeric,
    price_subtotal numeric,
    price_total numeric,
    price_tax double precision,
    order_id integer NOT NULL,
    account_analytic_id integer,
    company_id integer,
    state character varying COLLATE pg_catalog."default",
    qty_invoiced numeric,
    qty_received_method character varying COLLATE pg_catalog."default",
    qty_received numeric,
    qty_received_manual numeric,
    partner_id integer,
    currency_id integer,
    display_type character varying COLLATE pg_catalog."default",
    create_uid integer,
    create_date timestamp without time zone,
    write_uid integer,
    write_date timestamp without time zone,
    sale_order_id integer,
    sale_line_id integer,
    prix_achat double precision,
    orderpoint_id integer,
    propagate_date boolean,
    propagate_date_minimum_delta integer,
    propagate_cancel boolean,
    discount numeric,
    unite_mesure character varying COLLATE pg_catalog."default",
    width double precision NOT NULL,
    height double precision NOT NULL,
    square_meter double precision,
    net_price_pur double precision,
    hide_net_price boolean,
    CONSTRAINT purchase_order_line_pkey PRIMARY KEY (id),
    CONSTRAINT purchase_order_line_account_analytic_id_fkey FOREIGN KEY (account_analytic_id)
        REFERENCES public.account_analytic_account (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE SET NULL,
    CONSTRAINT purchase_order_line_company_id_fkey FOREIGN KEY (company_id)
        REFERENCES public.res_company (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE SET NULL,
    CONSTRAINT purchase_order_line_create_uid_fkey FOREIGN KEY (create_uid)
        REFERENCES public.res_users (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE SET NULL,
    CONSTRAINT purchase_order_line_currency_id_fkey FOREIGN KEY (currency_id)
        REFERENCES public.res_currency (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE SET NULL,
    CONSTRAINT purchase_order_line_order_id_fkey FOREIGN KEY (order_id)
        REFERENCES public.purchase_order (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE CASCADE,
    CONSTRAINT purchase_order_line_orderpoint_id_fkey FOREIGN KEY (orderpoint_id)
        REFERENCES public.stock_warehouse_orderpoint (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE SET NULL,
    CONSTRAINT purchase_order_line_partner_id_fkey FOREIGN KEY (partner_id)
        REFERENCES public.res_partner (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE SET NULL,
    CONSTRAINT purchase_order_line_product_id_fkey FOREIGN KEY (product_id)
        REFERENCES public.product_product (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE SET NULL,
    CONSTRAINT purchase_order_line_product_uom_fkey FOREIGN KEY (product_uom)
        REFERENCES public.uom_uom (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE SET NULL,
    CONSTRAINT purchase_order_line_sale_line_id_fkey FOREIGN KEY (sale_line_id)
        REFERENCES public.sale_order_line (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE SET NULL,
    CONSTRAINT purchase_order_line_sale_order_id_fkey FOREIGN KEY (sale_order_id)
        REFERENCES public.sale_order (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE SET NULL,
    CONSTRAINT purchase_order_line_write_uid_fkey FOREIGN KEY (write_uid)
        REFERENCES public.res_users (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE SET NULL,
    CONSTRAINT purchase_order_line_accountable_required_fields CHECK (display_type IS NOT NULL OR product_id IS NOT NULL AND product_uom IS NOT NULL AND date_planned IS NOT NULL),
    CONSTRAINT purchase_order_line_discount_limit CHECK (discount <= 100.0),
    CONSTRAINT purchase_order_line_non_accountable_null_fields CHECK (display_type IS NULL OR product_id IS NULL AND price_unit = 0::numeric AND product_uom_qty = 0::double precision AND product_uom IS NULL AND date_planned IS NULL)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.purchase_order_line
    OWNER to odoo;

COMMENT ON TABLE public.purchase_order_line
    IS 'Purchase Order Line';

COMMENT ON COLUMN public.purchase_order_line.name
    IS 'Description';

COMMENT ON COLUMN public.purchase_order_line.sequence
    IS 'Sequence';

COMMENT ON COLUMN public.purchase_order_line.product_qty
    IS 'Quantity';

COMMENT ON COLUMN public.purchase_order_line.product_uom_qty
    IS 'Total Quantity';

COMMENT ON COLUMN public.purchase_order_line.date_planned
    IS 'Scheduled Date';

COMMENT ON COLUMN public.purchase_order_line.product_uom
    IS 'Unit of Measure';

COMMENT ON COLUMN public.purchase_order_line.product_id
    IS 'Product';

COMMENT ON COLUMN public.purchase_order_line.price_unit
    IS 'Unit Price';

COMMENT ON COLUMN public.purchase_order_line.price_subtotal
    IS 'Subtotal';

COMMENT ON COLUMN public.purchase_order_line.price_total
    IS 'Total';

COMMENT ON COLUMN public.purchase_order_line.price_tax
    IS 'Tax';

COMMENT ON COLUMN public.purchase_order_line.order_id
    IS 'Order Reference';

COMMENT ON COLUMN public.purchase_order_line.account_analytic_id
    IS 'Analytic Account';

COMMENT ON COLUMN public.purchase_order_line.company_id
    IS 'Company';

COMMENT ON COLUMN public.purchase_order_line.state
    IS 'Status';

COMMENT ON COLUMN public.purchase_order_line.qty_invoiced
    IS 'Billed Qty';

COMMENT ON COLUMN public.purchase_order_line.qty_received_method
    IS 'Received Qty Method';

COMMENT ON COLUMN public.purchase_order_line.qty_received
    IS 'Received Qty';

COMMENT ON COLUMN public.purchase_order_line.qty_received_manual
    IS 'Manual Received Qty';

COMMENT ON COLUMN public.purchase_order_line.partner_id
    IS 'Partner';

COMMENT ON COLUMN public.purchase_order_line.currency_id
    IS 'Currency';

COMMENT ON COLUMN public.purchase_order_line.display_type
    IS 'Display Type';

COMMENT ON COLUMN public.purchase_order_line.create_uid
    IS 'Created by';

COMMENT ON COLUMN public.purchase_order_line.create_date
    IS 'Created on';

COMMENT ON COLUMN public.purchase_order_line.write_uid
    IS 'Last Updated by';

COMMENT ON COLUMN public.purchase_order_line.write_date
    IS 'Last Updated on';

COMMENT ON COLUMN public.purchase_order_line.sale_order_id
    IS 'Sale Order';

COMMENT ON COLUMN public.purchase_order_line.sale_line_id
    IS 'Origin Sale Item';

COMMENT ON COLUMN public.purchase_order_line.prix_achat
    IS 'Prix achat';

COMMENT ON COLUMN public.purchase_order_line.orderpoint_id
    IS 'Orderpoint';

COMMENT ON COLUMN public.purchase_order_line.propagate_date
    IS 'Propagate Rescheduling';

COMMENT ON COLUMN public.purchase_order_line.propagate_date_minimum_delta
    IS 'Reschedule if Higher Than';

COMMENT ON COLUMN public.purchase_order_line.propagate_cancel
    IS 'Propagate cancellation';

COMMENT ON COLUMN public.purchase_order_line.discount
    IS 'Discount (%)';

COMMENT ON COLUMN public.purchase_order_line.unite_mesure
    IS 'Unité';

COMMENT ON COLUMN public.purchase_order_line.width
    IS 'Width (Mt.)';

COMMENT ON COLUMN public.purchase_order_line.height
    IS 'Height (Mt.)';

COMMENT ON COLUMN public.purchase_order_line.square_meter
    IS '(Mt.)2';

COMMENT ON COLUMN public.purchase_order_line.net_price_pur
    IS 'Net Price';

COMMENT ON COLUMN public.purchase_order_line.hide_net_price
    IS 'Hide net price';

COMMENT ON CONSTRAINT purchase_order_line_accountable_required_fields ON public.purchase_order_line
    IS 'CHECK(display_type IS NOT NULL OR (product_id IS NOT NULL AND product_uom IS NOT NULL AND date_planned IS NOT NULL))';
COMMENT ON CONSTRAINT purchase_order_line_discount_limit ON public.purchase_order_line
    IS 'CHECK (discount <= 100.0)';
COMMENT ON CONSTRAINT purchase_order_line_non_accountable_null_fields ON public.purchase_order_line
    IS 'CHECK(display_type IS NULL OR (product_id IS NULL AND price_unit = 0 AND product_uom_qty = 0 AND product_uom IS NULL AND date_planned is NULL))';
-- Index: purchase_order_line_date_planned_index

-- DROP INDEX IF EXISTS public.purchase_order_line_date_planned_index;

CREATE INDEX IF NOT EXISTS purchase_order_line_date_planned_index
    ON public.purchase_order_line USING btree
    (date_planned ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: purchase_order_line_order_id_index

-- DROP INDEX IF EXISTS public.purchase_order_line_order_id_index;

CREATE INDEX IF NOT EXISTS purchase_order_line_order_id_index
    ON public.purchase_order_line USING btree
    (order_id ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: purchase_order_line_sale_line_id_index

-- DROP INDEX IF EXISTS public.purchase_order_line_sale_line_id_index;

CREATE INDEX IF NOT EXISTS purchase_order_line_sale_line_id_index
    ON public.purchase_order_line USING btree
    (sale_line_id ASC NULLS LAST)
    TABLESPACE pg_default;