-- Table: public.hr_employee

-- DROP TABLE IF EXISTS public.hr_employee;
CREATE SEQUENCE hr_employee_id_seq;

CREATE TABLE IF NOT EXISTS public.hr_employee
(
    id integer NOT NULL DEFAULT nextval('hr_employee_id_seq'::regclass),
    name character varying COLLATE pg_catalog."default",
    user_id integer,
    active boolean,
    address_home_id integer,
    country_id integer,
    gender character varying COLLATE pg_catalog."default",
    marital character varying COLLATE pg_catalog."default",
    spouse_complete_name character varying COLLATE pg_catalog."default",
    spouse_birthdate date,
    children integer,
    place_of_birth character varying COLLATE pg_catalog."default",
    country_of_birth integer,
    birthday date,
    ssnid character varying COLLATE pg_catalog."default",
    sinid character varying COLLATE pg_catalog."default",
    identification_id character varying COLLATE pg_catalog."default",
    passport_id character varying COLLATE pg_catalog."default",
    bank_account_id integer,
    permit_no character varying COLLATE pg_catalog."default",
    visa_no character varying COLLATE pg_catalog."default",
    visa_expire date,
    additional_note text COLLATE pg_catalog."default",
    certificate character varying COLLATE pg_catalog."default",
    study_field character varying COLLATE pg_catalog."default",
    study_school character varying COLLATE pg_catalog."default",
    emergency_contact character varying COLLATE pg_catalog."default",
    emergency_phone character varying COLLATE pg_catalog."default",
    km_home_work integer,
    notes text COLLATE pg_catalog."default",
    color integer,
    barcode character varying COLLATE pg_catalog."default",
    pin character varying COLLATE pg_catalog."default",
    departure_reason character varying COLLATE pg_catalog."default",
    departure_description text COLLATE pg_catalog."default",
    message_main_attachment_id integer,
    department_id integer,
    job_id integer,
    job_title character varying COLLATE pg_catalog."default",
    company_id integer,
    address_id integer,
    work_phone character varying COLLATE pg_catalog."default",
    mobile_phone character varying COLLATE pg_catalog."default",
    work_email character varying COLLATE pg_catalog."default",
    work_location character varying COLLATE pg_catalog."default",
    resource_id integer NOT NULL,
    resource_calendar_id integer,
    parent_id integer,
    coach_id integer,
    create_uid integer,
    create_date timestamp without time zone,
    write_uid integer,
    write_date timestamp without time zone,
    medic_exam date,
    vehicle character varying COLLATE pg_catalog."default",
    contract_id integer,
    contract_warning boolean,
    expense_manager_id integer,
    leave_manager_id integer,
    last_attendance_id integer,
    last_check_in timestamp without time zone,
    last_check_out timestamp without time zone,
    planning_role_id integer,
    employee_token character varying COLLATE pg_catalog."default",
    voiture integer,
    order_display integer,
    CONSTRAINT hr_employee_pkey PRIMARY KEY (id),
    CONSTRAINT hr_employee_barcode_uniq UNIQUE (barcode),
    CONSTRAINT hr_employee_employee_token_unique UNIQUE (employee_token),
    CONSTRAINT hr_employee_user_uniq UNIQUE (user_id, company_id),
    CONSTRAINT hr_employee_address_home_id_fkey FOREIGN KEY (address_home_id)
        REFERENCES public.res_partner (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE SET NULL,
    CONSTRAINT hr_employee_address_id_fkey FOREIGN KEY (address_id)
        REFERENCES public.res_partner (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE SET NULL,
    CONSTRAINT hr_employee_bank_account_id_fkey FOREIGN KEY (bank_account_id)
        REFERENCES public.res_partner_bank (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE SET NULL,
    CONSTRAINT hr_employee_coach_id_fkey FOREIGN KEY (coach_id)
        REFERENCES public.hr_employee (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE SET NULL,
    CONSTRAINT hr_employee_company_id_fkey FOREIGN KEY (company_id)
        REFERENCES public.res_company (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE SET NULL,
    CONSTRAINT hr_employee_contract_id_fkey FOREIGN KEY (contract_id)
        REFERENCES public.hr_contract (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE SET NULL,
    CONSTRAINT hr_employee_country_id_fkey FOREIGN KEY (country_id)
        REFERENCES public.res_country (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE SET NULL,
    CONSTRAINT hr_employee_country_of_birth_fkey FOREIGN KEY (country_of_birth)
        REFERENCES public.res_country (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE SET NULL,
    CONSTRAINT hr_employee_create_uid_fkey FOREIGN KEY (create_uid)
        REFERENCES public.res_users (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE SET NULL,
    CONSTRAINT hr_employee_department_id_fkey FOREIGN KEY (department_id)
        REFERENCES public.hr_department (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE SET NULL,
    CONSTRAINT hr_employee_expense_manager_id_fkey FOREIGN KEY (expense_manager_id)
        REFERENCES public.res_users (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE SET NULL,
    CONSTRAINT hr_employee_job_id_fkey FOREIGN KEY (job_id)
        REFERENCES public.hr_job (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE SET NULL,
    CONSTRAINT hr_employee_last_attendance_id_fkey FOREIGN KEY (last_attendance_id)
        REFERENCES public.hr_attendance (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE SET NULL,
    CONSTRAINT hr_employee_leave_manager_id_fkey FOREIGN KEY (leave_manager_id)
        REFERENCES public.res_users (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE SET NULL,
    CONSTRAINT hr_employee_message_main_attachment_id_fkey FOREIGN KEY (message_main_attachment_id)
        REFERENCES public.ir_attachment (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE SET NULL,
    CONSTRAINT hr_employee_parent_id_fkey FOREIGN KEY (parent_id)
        REFERENCES public.hr_employee (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE SET NULL,
    CONSTRAINT hr_employee_planning_role_id_fkey FOREIGN KEY (planning_role_id)
        REFERENCES public.planning_role (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE SET NULL,
    CONSTRAINT hr_employee_resource_calendar_id_fkey FOREIGN KEY (resource_calendar_id)
        REFERENCES public.resource_calendar (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE SET NULL,
    CONSTRAINT hr_employee_resource_id_fkey FOREIGN KEY (resource_id)
        REFERENCES public.resource_resource (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE RESTRICT,
    CONSTRAINT hr_employee_user_id_fkey FOREIGN KEY (user_id)
        REFERENCES public.res_users (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE SET NULL,
    CONSTRAINT hr_employee_voiture_fkey FOREIGN KEY (voiture)
        REFERENCES public.fleet_vehicle (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE SET NULL,
    CONSTRAINT hr_employee_write_uid_fkey FOREIGN KEY (write_uid)
        REFERENCES public.res_users (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE SET NULL
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.hr_employee
    OWNER to odoo;

COMMENT ON TABLE public.hr_employee
    IS 'Employee';

COMMENT ON COLUMN public.hr_employee.name
    IS 'Employee Name';

COMMENT ON COLUMN public.hr_employee.user_id
    IS 'User';

COMMENT ON COLUMN public.hr_employee.active
    IS 'Active';

COMMENT ON COLUMN public.hr_employee.address_home_id
    IS 'Address';

COMMENT ON COLUMN public.hr_employee.country_id
    IS 'Nationality (Country)';

COMMENT ON COLUMN public.hr_employee.gender
    IS 'Gender';

COMMENT ON COLUMN public.hr_employee.marital
    IS 'Marital Status';

COMMENT ON COLUMN public.hr_employee.spouse_complete_name
    IS 'Spouse Complete Name';

COMMENT ON COLUMN public.hr_employee.spouse_birthdate
    IS 'Spouse Birthdate';

COMMENT ON COLUMN public.hr_employee.children
    IS 'Number of Children';

COMMENT ON COLUMN public.hr_employee.place_of_birth
    IS 'Place of Birth';

COMMENT ON COLUMN public.hr_employee.country_of_birth
    IS 'Country of Birth';

COMMENT ON COLUMN public.hr_employee.birthday
    IS 'Date of Birth';

COMMENT ON COLUMN public.hr_employee.ssnid
    IS 'SSN No';

COMMENT ON COLUMN public.hr_employee.sinid
    IS 'SIN No';

COMMENT ON COLUMN public.hr_employee.identification_id
    IS 'Identification No';

COMMENT ON COLUMN public.hr_employee.passport_id
    IS 'Passport No';

COMMENT ON COLUMN public.hr_employee.bank_account_id
    IS 'Bank Account Number';

COMMENT ON COLUMN public.hr_employee.permit_no
    IS 'Work Permit No';

COMMENT ON COLUMN public.hr_employee.visa_no
    IS 'Visa No';

COMMENT ON COLUMN public.hr_employee.visa_expire
    IS 'Visa Expire Date';

COMMENT ON COLUMN public.hr_employee.additional_note
    IS 'Additional Note';

COMMENT ON COLUMN public.hr_employee.certificate
    IS 'Certificate Level';

COMMENT ON COLUMN public.hr_employee.study_field
    IS 'Field of Study';

COMMENT ON COLUMN public.hr_employee.study_school
    IS 'School';

COMMENT ON COLUMN public.hr_employee.emergency_contact
    IS 'Emergency Contact';

COMMENT ON COLUMN public.hr_employee.emergency_phone
    IS 'Emergency Phone';

COMMENT ON COLUMN public.hr_employee.km_home_work
    IS 'Km Home-Work';

COMMENT ON COLUMN public.hr_employee.notes
    IS 'Notes';

COMMENT ON COLUMN public.hr_employee.color
    IS 'Color Index';

COMMENT ON COLUMN public.hr_employee.barcode
    IS 'Badge ID';

COMMENT ON COLUMN public.hr_employee.pin
    IS 'PIN';

COMMENT ON COLUMN public.hr_employee.departure_reason
    IS 'Departure Reason';

COMMENT ON COLUMN public.hr_employee.departure_description
    IS 'Additional Information';

COMMENT ON COLUMN public.hr_employee.message_main_attachment_id
    IS 'Main Attachment';

COMMENT ON COLUMN public.hr_employee.department_id
    IS 'Department';

COMMENT ON COLUMN public.hr_employee.job_id
    IS 'Job Position';

COMMENT ON COLUMN public.hr_employee.job_title
    IS 'Job Title';

COMMENT ON COLUMN public.hr_employee.company_id
    IS 'Company';

COMMENT ON COLUMN public.hr_employee.address_id
    IS 'Work Address';

COMMENT ON COLUMN public.hr_employee.work_phone
    IS 'Work Phone';

COMMENT ON COLUMN public.hr_employee.mobile_phone
    IS 'Work Mobile';

COMMENT ON COLUMN public.hr_employee.work_email
    IS 'Work Email';

COMMENT ON COLUMN public.hr_employee.work_location
    IS 'Work Location';

COMMENT ON COLUMN public.hr_employee.resource_id
    IS 'Resource';

COMMENT ON COLUMN public.hr_employee.resource_calendar_id
    IS 'Working Hours';

COMMENT ON COLUMN public.hr_employee.parent_id
    IS 'Manager';

COMMENT ON COLUMN public.hr_employee.coach_id
    IS 'Coach';

COMMENT ON COLUMN public.hr_employee.create_uid
    IS 'Created by';

COMMENT ON COLUMN public.hr_employee.create_date
    IS 'Created on';

COMMENT ON COLUMN public.hr_employee.write_uid
    IS 'Last Updated by';

COMMENT ON COLUMN public.hr_employee.write_date
    IS 'Last Updated on';

COMMENT ON COLUMN public.hr_employee.medic_exam
    IS 'Medical Examination Date';

COMMENT ON COLUMN public.hr_employee.vehicle
    IS 'Company Vehicle';

COMMENT ON COLUMN public.hr_employee.contract_id
    IS 'Current Contract';

COMMENT ON COLUMN public.hr_employee.contract_warning
    IS 'Contract Warning';

COMMENT ON COLUMN public.hr_employee.expense_manager_id
    IS 'Expense';

COMMENT ON COLUMN public.hr_employee.leave_manager_id
    IS 'Time Off';

COMMENT ON COLUMN public.hr_employee.last_attendance_id
    IS 'Last Attendance';

COMMENT ON COLUMN public.hr_employee.last_check_in
    IS 'Check In';

COMMENT ON COLUMN public.hr_employee.last_check_out
    IS 'Check Out';

COMMENT ON COLUMN public.hr_employee.planning_role_id
    IS 'Default Planning Role';

COMMENT ON COLUMN public.hr_employee.employee_token
    IS 'Security Token';

COMMENT ON COLUMN public.hr_employee.voiture
    IS 'Voiture';

COMMENT ON COLUMN public.hr_employee.order_display
    IS 'Ordre affichage';

COMMENT ON CONSTRAINT hr_employee_barcode_uniq ON public.hr_employee
    IS 'unique (barcode)';
COMMENT ON CONSTRAINT hr_employee_employee_token_unique ON public.hr_employee
    IS 'unique(employee_token)';
COMMENT ON CONSTRAINT hr_employee_user_uniq ON public.hr_employee
    IS 'unique (user_id, company_id)';
-- Index: hr_employee_company_id_index

-- DROP INDEX IF EXISTS public.hr_employee_company_id_index;

CREATE INDEX IF NOT EXISTS hr_employee_company_id_index
    ON public.hr_employee USING btree
    (company_id ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: hr_employee_message_main_attachment_id_index

-- DROP INDEX IF EXISTS public.hr_employee_message_main_attachment_id_index;

CREATE INDEX IF NOT EXISTS hr_employee_message_main_attachment_id_index
    ON public.hr_employee USING btree
    (message_main_attachment_id ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: hr_employee_resource_calendar_id_index

-- DROP INDEX IF EXISTS public.hr_employee_resource_calendar_id_index;

CREATE INDEX IF NOT EXISTS hr_employee_resource_calendar_id_index
    ON public.hr_employee USING btree
    (resource_calendar_id ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: hr_employee_resource_id_index

-- DROP INDEX IF EXISTS public.hr_employee_resource_id_index;

CREATE INDEX IF NOT EXISTS hr_employee_resource_id_index
    ON public.hr_employee USING btree
    (resource_id ASC NULLS LAST)
    TABLESPACE pg_default;