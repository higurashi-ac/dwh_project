-- Table: public.payment_justify

-- DROP TABLE IF EXISTS public.payment_justify;

CREATE TABLE IF NOT EXISTS public.payment_justify
(
    id integer NOT NULL DEFAULT nextval('payment_justify_id_seq'::regclass),
    name character varying COLLATE pg_catalog."default",
    mode_paiement character varying COLLATE pg_catalog."default",
    montant double precision,
    date timestamp without time zone,
    client integer,
    source integer,
    total double precision,
    create_uid integer,
    create_date timestamp without time zone,
    write_uid integer,
    write_date timestamp without time zone,
    etat character varying COLLATE pg_catalog."default",
    moyen_paiement integer,
    attachment integer,
    user_id integer,
    memo character varying COLLATE pg_catalog."default",
    date_paiement date,
    planning integer,
    type_paiement character varying COLLATE pg_catalog."default",
    CONSTRAINT payment_justify_pkey PRIMARY KEY (id),
    CONSTRAINT payment_justify_attachment_fkey FOREIGN KEY (attachment)
        REFERENCES public.ir_attachment (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE SET NULL,
    CONSTRAINT payment_justify_client_fkey FOREIGN KEY (client)
        REFERENCES public.res_partner (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE SET NULL,
    CONSTRAINT payment_justify_create_uid_fkey FOREIGN KEY (create_uid)
        REFERENCES public.res_users (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE SET NULL,
    CONSTRAINT payment_justify_moyen_paiement_fkey FOREIGN KEY (moyen_paiement)
        REFERENCES public.account_journal (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE SET NULL,
    CONSTRAINT payment_justify_planning_fkey FOREIGN KEY (planning)
        REFERENCES public.planning_slot (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE SET NULL,
    CONSTRAINT payment_justify_source_fkey FOREIGN KEY (source)
        REFERENCES public.account_move (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE SET NULL,
    CONSTRAINT payment_justify_user_id_fkey FOREIGN KEY (user_id)
        REFERENCES public.res_users (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE SET NULL,
    CONSTRAINT payment_justify_write_uid_fkey FOREIGN KEY (write_uid)
        REFERENCES public.res_users (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE SET NULL
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.payment_justify
    OWNER to odoo;

COMMENT ON TABLE public.payment_justify
    IS 'Justification de paiement';

COMMENT ON COLUMN public.payment_justify.name
    IS 'Paiement';

COMMENT ON COLUMN public.payment_justify.mode_paiement
    IS 'Intermediaire';

COMMENT ON COLUMN public.payment_justify.montant
    IS 'Montant';

COMMENT ON COLUMN public.payment_justify.date
    IS 'Date paiement';

COMMENT ON COLUMN public.payment_justify.client
    IS 'client';

COMMENT ON COLUMN public.payment_justify.source
    IS 'Source';

COMMENT ON COLUMN public.payment_justify.total
    IS 'Total';

COMMENT ON COLUMN public.payment_justify.create_uid
    IS 'Created by';

COMMENT ON COLUMN public.payment_justify.create_date
    IS 'Created on';

COMMENT ON COLUMN public.payment_justify.write_uid
    IS 'Last Updated by';

COMMENT ON COLUMN public.payment_justify.write_date
    IS 'Last Updated on';

COMMENT ON COLUMN public.payment_justify.etat
    IS 'Etat paiement';

COMMENT ON COLUMN public.payment_justify.moyen_paiement
    IS 'Moyen Paiement';

COMMENT ON COLUMN public.payment_justify.attachment
    IS 'attachment';

COMMENT ON COLUMN public.payment_justify.user_id
    IS 'responsable';

COMMENT ON COLUMN public.payment_justify.memo
    IS 'memo';

COMMENT ON COLUMN public.payment_justify.date_paiement
    IS 'Date encaissement';

COMMENT ON COLUMN public.payment_justify.planning
    IS 'planning';

COMMENT ON COLUMN public.payment_justify.type_paiement
    IS 'Type de paiement';