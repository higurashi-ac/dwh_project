-- Table: public.product_product

-- DROP TABLE IF EXISTS public.product_product;

CREATE TABLE IF NOT EXISTS public.product_product
(
    id integer NOT NULL DEFAULT nextval('product_product_id_seq'::regclass),
    message_main_attachment_id integer,
    default_code character varying COLLATE pg_catalog."default",
    active boolean,
    product_tmpl_id integer NOT NULL,
    barcode character varying COLLATE pg_catalog."default",
    combination_indices character varying COLLATE pg_catalog."default",
    volume numeric,
    weight numeric,
    can_image_variant_1024_be_zoomed boolean,
    create_uid integer,
    create_date timestamp without time zone,
    write_uid integer,
    write_date timestamp without time zone,
    fix_price numeric,
    prix_vente double precision,
    reference_interne character varying COLLATE pg_catalog."default",
    prix_achat double precision,
    "Taille" integer,
    CONSTRAINT product_product_pkey PRIMARY KEY (id),
    CONSTRAINT product_product_barcode_uniq UNIQUE (barcode),
    CONSTRAINT product_product_create_uid_fkey FOREIGN KEY (create_uid)
        REFERENCES public.res_users (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE SET NULL,
    CONSTRAINT product_product_message_main_attachment_id_fkey FOREIGN KEY (message_main_attachment_id)
        REFERENCES public.ir_attachment (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE SET NULL,
    CONSTRAINT product_product_product_tmpl_id_fkey FOREIGN KEY (product_tmpl_id)
        REFERENCES public.product_template (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE CASCADE,
    CONSTRAINT product_product_write_uid_fkey FOREIGN KEY (write_uid)
        REFERENCES public.res_users (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE SET NULL
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.product_product
    OWNER to odoo;

COMMENT ON TABLE public.product_product
    IS 'Product';

COMMENT ON COLUMN public.product_product.message_main_attachment_id
    IS 'Main Attachment';

COMMENT ON COLUMN public.product_product.default_code
    IS 'Internal Reference';

COMMENT ON COLUMN public.product_product.active
    IS 'Active';

COMMENT ON COLUMN public.product_product.product_tmpl_id
    IS 'Product Template';

COMMENT ON COLUMN public.product_product.barcode
    IS 'Barcode';

COMMENT ON COLUMN public.product_product.combination_indices
    IS 'Combination Indices';

COMMENT ON COLUMN public.product_product.volume
    IS 'Volume';

COMMENT ON COLUMN public.product_product.weight
    IS 'Weight';

COMMENT ON COLUMN public.product_product.can_image_variant_1024_be_zoomed
    IS 'Can Variant Image 1024 be zoomed';

COMMENT ON COLUMN public.product_product.create_uid
    IS 'Created by';

COMMENT ON COLUMN public.product_product.create_date
    IS 'Created on';

COMMENT ON COLUMN public.product_product.write_uid
    IS 'Last Updated by';

COMMENT ON COLUMN public.product_product.write_date
    IS 'Last Updated on';

COMMENT ON COLUMN public.product_product.fix_price
    IS 'Fix Price';

COMMENT ON COLUMN public.product_product.prix_vente
    IS 'Prix Vente';

COMMENT ON COLUMN public.product_product.reference_interne
    IS 'Référence Interne';

COMMENT ON COLUMN public.product_product.prix_achat
    IS 'Prix Achat';

COMMENT ON COLUMN public.product_product."Taille"
    IS 'Taille';

COMMENT ON CONSTRAINT product_product_barcode_uniq ON public.product_product
    IS 'unique(barcode)';
-- Index: product_product_combination_indices_index

-- DROP INDEX IF EXISTS public.product_product_combination_indices_index;

CREATE INDEX IF NOT EXISTS product_product_combination_indices_index
    ON public.product_product USING btree
    (combination_indices COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: product_product_combination_unique

-- DROP INDEX IF EXISTS public.product_product_combination_unique;

CREATE UNIQUE INDEX IF NOT EXISTS product_product_combination_unique
    ON public.product_product USING btree
    (product_tmpl_id ASC NULLS LAST, combination_indices COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default
    WHERE active IS TRUE;
-- Index: product_product_default_code_index

-- DROP INDEX IF EXISTS public.product_product_default_code_index;

CREATE INDEX IF NOT EXISTS product_product_default_code_index
    ON public.product_product USING btree
    (default_code COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: product_product_message_main_attachment_id_index

-- DROP INDEX IF EXISTS public.product_product_message_main_attachment_id_index;

CREATE INDEX IF NOT EXISTS product_product_message_main_attachment_id_index
    ON public.product_product USING btree
    (message_main_attachment_id ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: product_product_product_tmpl_id_index

-- DROP INDEX IF EXISTS public.product_product_product_tmpl_id_index;

CREATE INDEX IF NOT EXISTS product_product_product_tmpl_id_index
    ON public.product_product USING btree
    (product_tmpl_id ASC NULLS LAST)
    TABLESPACE pg_default;