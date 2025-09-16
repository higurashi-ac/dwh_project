-- Table: public.planning_slot

-- DROP TABLE IF EXISTS public.planning_slot;

CREATE TABLE IF NOT EXISTS public.planning_slot
(
    id integer NOT NULL DEFAULT nextval('planning_slot_id_seq'::regclass),
    name_seq character varying COLLATE pg_catalog."default" NOT NULL,
    type_int character varying COLLATE pg_catalog."default",
    my_image character varying COLLATE pg_catalog."default",
    name text COLLATE pg_catalog."default",
    "Rapport" text COLLATE pg_catalog."default",
    employee_id integer,
    user_id integer,
    partner_id integer,
    company_id integer NOT NULL,
    role_id integer,
    note_desc integer,
    status integer,
    was_copied boolean,
    start_datetime timestamp without time zone NOT NULL,
    end_datetime timestamp without time zone NOT NULL,
    allocated_hours double precision,
    allocated_percentage double precision,
    working_days_count integer,
    is_published boolean,
    publication_warning boolean,
    recurrency_id integer,
    message_main_attachment_id integer,
    create_uid integer,
    create_date timestamp without time zone,
    write_uid integer,
    write_date timestamp without time zone,
    login_user integer,
    employees_ids integer,
    state character varying COLLATE pg_catalog."default",
    "Remarque" text COLLATE pg_catalog."default",
    voiture integer,
    devis integer,
    motif character varying COLLATE pg_catalog."default",
    rapport_supp text COLLATE pg_catalog."default",
    suivi character varying COLLATE pg_catalog."default",
    parent_id integer,
    amount_residual double precision,
    ville_client character varying COLLATE pg_catalog."default",
    region_client character varying COLLATE pg_catalog."default",
    CONSTRAINT planning_slot_pkey PRIMARY KEY (id),
    CONSTRAINT planning_slot_company_id_fkey FOREIGN KEY (company_id)
        REFERENCES public.res_company (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE RESTRICT,
    CONSTRAINT planning_slot_create_uid_fkey FOREIGN KEY (create_uid)
        REFERENCES public.res_users (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE SET NULL,
    CONSTRAINT planning_slot_devis_fkey FOREIGN KEY (devis)
        REFERENCES public.sale_order (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE SET NULL,
    CONSTRAINT planning_slot_employee_id_fkey FOREIGN KEY (employee_id)
        REFERENCES public.hr_employee (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE SET NULL,
    CONSTRAINT planning_slot_employees_ids_fkey FOREIGN KEY (employees_ids)
        REFERENCES public.hr_employee (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE SET NULL,
    CONSTRAINT planning_slot_login_user_fkey FOREIGN KEY (login_user)
        REFERENCES public.res_users (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE SET NULL,
    CONSTRAINT planning_slot_message_main_attachment_id_fkey FOREIGN KEY (message_main_attachment_id)
        REFERENCES public.ir_attachment (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE SET NULL,
    CONSTRAINT planning_slot_note_desc_fkey FOREIGN KEY (note_desc)
        REFERENCES public.planning_note (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE SET NULL,
    CONSTRAINT planning_slot_parent_id_fkey FOREIGN KEY (parent_id)
        REFERENCES public.planning_slot (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE SET NULL,
    CONSTRAINT planning_slot_partner_id_fkey FOREIGN KEY (partner_id)
        REFERENCES public.res_partner (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE SET NULL,
    CONSTRAINT planning_slot_recurrency_id_fkey FOREIGN KEY (recurrency_id)
        REFERENCES public.planning_recurrency (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE SET NULL,
    CONSTRAINT planning_slot_role_id_fkey FOREIGN KEY (role_id)
        REFERENCES public.planning_role (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE SET NULL,
    CONSTRAINT planning_slot_status_fkey FOREIGN KEY (status)
        REFERENCES public.planning_state (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE SET NULL,
    CONSTRAINT planning_slot_user_id_fkey FOREIGN KEY (user_id)
        REFERENCES public.res_users (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE SET NULL,
    CONSTRAINT planning_slot_voiture_fkey FOREIGN KEY (voiture)
        REFERENCES public.fleet_vehicle (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE SET NULL,
    CONSTRAINT planning_slot_write_uid_fkey FOREIGN KEY (write_uid)
        REFERENCES public.res_users (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE SET NULL,
    CONSTRAINT planning_slot_check_allocated_hours_positive CHECK (allocated_hours >= 0::double precision),
    CONSTRAINT planning_slot_check_start_date_lower_end_date CHECK (end_datetime > start_datetime)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.planning_slot
    OWNER to odoo;

COMMENT ON TABLE public.planning_slot
    IS 'Planning Shift';

COMMENT ON COLUMN public.planning_slot.name_seq
    IS 'Planning Numero';

COMMENT ON COLUMN public.planning_slot.type_int
    IS 'Type intervention';

COMMENT ON COLUMN public.planning_slot.my_image
    IS 'File Name';

COMMENT ON COLUMN public.planning_slot.name
    IS 'Note';

COMMENT ON COLUMN public.planning_slot."Rapport"
    IS 'Rapport';

COMMENT ON COLUMN public.planning_slot.employee_id
    IS 'Employee';

COMMENT ON COLUMN public.planning_slot.user_id
    IS 'User';

COMMENT ON COLUMN public.planning_slot.partner_id
    IS 'Client';

COMMENT ON COLUMN public.planning_slot.company_id
    IS 'Company';

COMMENT ON COLUMN public.planning_slot.role_id
    IS 'Role';

COMMENT ON COLUMN public.planning_slot.note_desc
    IS 'Message';

COMMENT ON COLUMN public.planning_slot.status
    IS 'Status';

COMMENT ON COLUMN public.planning_slot.was_copied
    IS 'This shift was copied from previous week';

COMMENT ON COLUMN public.planning_slot.start_datetime
    IS 'Start Date';

COMMENT ON COLUMN public.planning_slot.end_datetime
    IS 'End Date';

COMMENT ON COLUMN public.planning_slot.allocated_hours
    IS 'Allocated hours';

COMMENT ON COLUMN public.planning_slot.allocated_percentage
    IS 'Allocated Time (%)';

COMMENT ON COLUMN public.planning_slot.working_days_count
    IS 'Number of working days';

COMMENT ON COLUMN public.planning_slot.is_published
    IS 'Is the shift sent';

COMMENT ON COLUMN public.planning_slot.publication_warning
    IS 'Modified since last publication';

COMMENT ON COLUMN public.planning_slot.recurrency_id
    IS 'Recurrency';

COMMENT ON COLUMN public.planning_slot.message_main_attachment_id
    IS 'Main Attachment';

COMMENT ON COLUMN public.planning_slot.create_uid
    IS 'Created by';

COMMENT ON COLUMN public.planning_slot.create_date
    IS 'Created on';

COMMENT ON COLUMN public.planning_slot.write_uid
    IS 'Last Updated by';

COMMENT ON COLUMN public.planning_slot.write_date
    IS 'Last Updated on';

COMMENT ON COLUMN public.planning_slot.login_user
    IS 'Responsable';

COMMENT ON COLUMN public.planning_slot.employees_ids
    IS 'Employees';

COMMENT ON COLUMN public.planning_slot.state
    IS 'Status';

COMMENT ON COLUMN public.planning_slot."Remarque"
    IS 'Remarque';

COMMENT ON COLUMN public.planning_slot.voiture
    IS 'voiture';

COMMENT ON COLUMN public.planning_slot.devis
    IS 'devis';

COMMENT ON COLUMN public.planning_slot.motif
    IS 'Motif intervention';

COMMENT ON COLUMN public.planning_slot.rapport_supp
    IS 'Rapport supplementaire';

COMMENT ON COLUMN public.planning_slot.suivi
    IS 'Suivi d''intervention';

COMMENT ON COLUMN public.planning_slot.parent_id
    IS 'Parent';

COMMENT ON COLUMN public.planning_slot.amount_residual
    IS 'Montant restant';

COMMENT ON COLUMN public.planning_slot.ville_client
    IS 'Ville';

COMMENT ON COLUMN public.planning_slot.region_client
    IS 'Region';

COMMENT ON CONSTRAINT planning_slot_check_allocated_hours_positive ON public.planning_slot
    IS 'CHECK(allocated_hours >= 0)';
COMMENT ON CONSTRAINT planning_slot_check_start_date_lower_end_date ON public.planning_slot
    IS 'CHECK(end_datetime > start_datetime)';
-- Index: planning_slot_message_main_attachment_id_index

-- DROP INDEX IF EXISTS public.planning_slot_message_main_attachment_id_index;

CREATE INDEX IF NOT EXISTS planning_slot_message_main_attachment_id_index
    ON public.planning_slot USING btree
    (message_main_attachment_id ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: planning_slot_recurrency_id_index

-- DROP INDEX IF EXISTS public.planning_slot_recurrency_id_index;

CREATE INDEX IF NOT EXISTS planning_slot_recurrency_id_index
    ON public.planning_slot USING btree
    (recurrency_id ASC NULLS LAST)
    TABLESPACE pg_default;