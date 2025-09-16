-- Table: public.sale_order_line

-- DROP TABLE IF EXISTS public.sale_order_line;

CREATE TABLE IF NOT EXISTS public.sale_order_line
(
    id integer NOT NULL DEFAULT nextval('sale_order_line_id_seq'::regclass),
    order_id integer NOT NULL,
    name text COLLATE pg_catalog."default" NOT NULL,
    sequence integer,
    invoice_status character varying COLLATE pg_catalog."default",
    price_unit numeric NOT NULL,
    price_subtotal numeric,
    price_tax double precision,
    price_total numeric,
    price_reduce numeric,
    price_reduce_taxinc numeric,
    price_reduce_taxexcl numeric,
    discount numeric,
    product_id integer,
    product_uom_qty numeric NOT NULL,
    product_uom integer,
    qty_delivered_method character varying COLLATE pg_catalog."default",
    qty_delivered numeric,
    qty_delivered_manual numeric,
    qty_to_invoice numeric,
    qty_invoiced numeric,
    untaxed_amount_invoiced numeric,
    untaxed_amount_to_invoice numeric,
    salesman_id integer,
    currency_id integer,
    company_id integer,
    order_partner_id integer,
    is_expense boolean,
    is_downpayment boolean,
    state character varying COLLATE pg_catalog."default",
    customer_lead double precision NOT NULL,
    display_type character varying COLLATE pg_catalog."default",
    create_uid integer,
    create_date timestamp without time zone,
    write_uid integer,
    write_date timestamp without time zone,
    product_packaging integer,
    route_id integer,
    width_moved0 numeric,
    height_moved0 numeric,
    is_delivery boolean,
    is_reward_line boolean,
    unite_mesure character varying COLLATE pg_catalog."default",
    width integer NOT NULL,
    height integer NOT NULL,
    puissance character varying COLLATE pg_catalog."default",
    m2 double precision,
    net_price double precision,
    hide_net_price boolean,
    CONSTRAINT sale_order_line_pkey PRIMARY KEY (id),
    CONSTRAINT sale_order_line_company_id_fkey FOREIGN KEY (company_id)
        REFERENCES public.res_company (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE SET NULL,
    CONSTRAINT sale_order_line_create_uid_fkey FOREIGN KEY (create_uid)
        REFERENCES public.res_users (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE SET NULL,
    CONSTRAINT sale_order_line_currency_id_fkey FOREIGN KEY (currency_id)
        REFERENCES public.res_currency (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE SET NULL,
    CONSTRAINT sale_order_line_order_id_fkey FOREIGN KEY (order_id)
        REFERENCES public.sale_order (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE CASCADE,
    CONSTRAINT sale_order_line_order_partner_id_fkey FOREIGN KEY (order_partner_id)
        REFERENCES public.res_partner (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE SET NULL,
    CONSTRAINT sale_order_line_product_id_fkey FOREIGN KEY (product_id)
        REFERENCES public.product_product (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE RESTRICT,
    CONSTRAINT sale_order_line_product_packaging_fkey FOREIGN KEY (product_packaging)
        REFERENCES public.product_packaging (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE SET NULL,
    CONSTRAINT sale_order_line_product_uom_fkey FOREIGN KEY (product_uom)
        REFERENCES public.uom_uom (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE SET NULL,
    CONSTRAINT sale_order_line_route_id_fkey FOREIGN KEY (route_id)
        REFERENCES public.stock_location_route (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE RESTRICT,
    CONSTRAINT sale_order_line_salesman_id_fkey FOREIGN KEY (salesman_id)
        REFERENCES public.res_users (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE SET NULL,
    CONSTRAINT sale_order_line_write_uid_fkey FOREIGN KEY (write_uid)
        REFERENCES public.res_users (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE SET NULL,
    CONSTRAINT sale_order_line_accountable_required_fields CHECK (display_type IS NOT NULL OR product_id IS NOT NULL AND product_uom IS NOT NULL),
    CONSTRAINT sale_order_line_non_accountable_null_fields CHECK (display_type IS NULL OR product_id IS NULL AND price_unit = 0::numeric AND product_uom_qty = 0::numeric AND product_uom IS NULL AND customer_lead = 0::double precision)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.sale_order_line
    OWNER to odoo;

COMMENT ON TABLE public.sale_order_line
    IS 'Sales Order Line';

COMMENT ON COLUMN public.sale_order_line.order_id
    IS 'Order Reference';

COMMENT ON COLUMN public.sale_order_line.name
    IS 'Description';

COMMENT ON COLUMN public.sale_order_line.sequence
    IS 'Sequence';

COMMENT ON COLUMN public.sale_order_line.invoice_status
    IS 'Invoice Status';

COMMENT ON COLUMN public.sale_order_line.price_unit
    IS 'Unit Price';

COMMENT ON COLUMN public.sale_order_line.price_subtotal
    IS 'Subtotal';

COMMENT ON COLUMN public.sale_order_line.price_tax
    IS 'Total Tax';

COMMENT ON COLUMN public.sale_order_line.price_total
    IS 'Total';

COMMENT ON COLUMN public.sale_order_line.price_reduce
    IS 'Price Reduce';

COMMENT ON COLUMN public.sale_order_line.price_reduce_taxinc
    IS 'Price Reduce Tax inc';

COMMENT ON COLUMN public.sale_order_line.price_reduce_taxexcl
    IS 'Price Reduce Tax excl';

COMMENT ON COLUMN public.sale_order_line.discount
    IS 'Discount (%)';

COMMENT ON COLUMN public.sale_order_line.product_id
    IS 'Product';

COMMENT ON COLUMN public.sale_order_line.product_uom_qty
    IS 'Quantity';

COMMENT ON COLUMN public.sale_order_line.product_uom
    IS 'Unit of Measure';

COMMENT ON COLUMN public.sale_order_line.qty_delivered_method
    IS 'Method to update delivered qty';

COMMENT ON COLUMN public.sale_order_line.qty_delivered
    IS 'Delivered Quantity';

COMMENT ON COLUMN public.sale_order_line.qty_delivered_manual
    IS 'Delivered Manually';

COMMENT ON COLUMN public.sale_order_line.qty_to_invoice
    IS 'To Invoice Quantity';

COMMENT ON COLUMN public.sale_order_line.qty_invoiced
    IS 'Invoiced Quantity';

COMMENT ON COLUMN public.sale_order_line.untaxed_amount_invoiced
    IS 'Untaxed Invoiced Amount';

COMMENT ON COLUMN public.sale_order_line.untaxed_amount_to_invoice
    IS 'Untaxed Amount To Invoice';

COMMENT ON COLUMN public.sale_order_line.salesman_id
    IS 'Salesperson';

COMMENT ON COLUMN public.sale_order_line.currency_id
    IS 'Currency';

COMMENT ON COLUMN public.sale_order_line.company_id
    IS 'Company';

COMMENT ON COLUMN public.sale_order_line.order_partner_id
    IS 'Customer';

COMMENT ON COLUMN public.sale_order_line.is_expense
    IS 'Is expense';

COMMENT ON COLUMN public.sale_order_line.is_downpayment
    IS 'Is a down payment';

COMMENT ON COLUMN public.sale_order_line.state
    IS 'Order Status';

COMMENT ON COLUMN public.sale_order_line.customer_lead
    IS 'Lead Time';

COMMENT ON COLUMN public.sale_order_line.display_type
    IS 'Display Type';

COMMENT ON COLUMN public.sale_order_line.create_uid
    IS 'Created by';

COMMENT ON COLUMN public.sale_order_line.create_date
    IS 'Created on';

COMMENT ON COLUMN public.sale_order_line.write_uid
    IS 'Last Updated by';

COMMENT ON COLUMN public.sale_order_line.write_date
    IS 'Last Updated on';

COMMENT ON COLUMN public.sale_order_line.product_packaging
    IS 'Package';

COMMENT ON COLUMN public.sale_order_line.route_id
    IS 'Route';

COMMENT ON COLUMN public.sale_order_line.width_moved0
    IS 'Width (Mm.)';

COMMENT ON COLUMN public.sale_order_line.height_moved0
    IS 'Height (Mm.)';

COMMENT ON COLUMN public.sale_order_line.is_delivery
    IS 'Is a Delivery';

COMMENT ON COLUMN public.sale_order_line.is_reward_line
    IS 'Is a program reward line';

COMMENT ON COLUMN public.sale_order_line.unite_mesure
    IS 'Unité';

COMMENT ON COLUMN public.sale_order_line.width
    IS 'Width (Mm.)';

COMMENT ON COLUMN public.sale_order_line.height
    IS 'Height (Mm.)';

COMMENT ON COLUMN public.sale_order_line.puissance
    IS 'Puissance M';

COMMENT ON COLUMN public.sale_order_line.m2
    IS '(MM.)2';

COMMENT ON COLUMN public.sale_order_line.net_price
    IS 'Net Price';

COMMENT ON COLUMN public.sale_order_line.hide_net_price
    IS 'Hide net price';

COMMENT ON CONSTRAINT sale_order_line_accountable_required_fields ON public.sale_order_line
    IS 'CHECK(display_type IS NOT NULL OR (product_id IS NOT NULL AND product_uom IS NOT NULL))';
COMMENT ON CONSTRAINT sale_order_line_non_accountable_null_fields ON public.sale_order_line
    IS 'CHECK(display_type IS NULL OR (product_id IS NULL AND price_unit = 0 AND product_uom_qty = 0 AND product_uom IS NULL AND customer_lead = 0))';
-- Index: sale_order_line_company_id_index

-- DROP INDEX IF EXISTS public.sale_order_line_company_id_index;

CREATE INDEX IF NOT EXISTS sale_order_line_company_id_index
    ON public.sale_order_line USING btree
    (company_id ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: sale_order_line_order_id_index

-- DROP INDEX IF EXISTS public.sale_order_line_order_id_index;

CREATE INDEX IF NOT EXISTS sale_order_line_order_id_index
    ON public.sale_order_line USING btree
    (order_id ASC NULLS LAST)
    TABLESPACE pg_default;