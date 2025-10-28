CREATE OR REPLACE VIEW dwh.v_planning_slot AS
SELECT
id                       as planning_id
,coalesce(parent_id, id) as parent_id
,row_number()            over (partition by coalesce(parent_id, id) order by create_date) as planning_seq
,create_date::date       as planning_date
,date_trunc('second', create_date::timestamp) as create_date_ts
,name_seq                as planning_ref_intervention
,type_int                as type_intervention
,motif                   as planning_motif 
,"Remarque"              as planning_remarque
,"Rapport"               as planning_rapport
,"state"                 as planning_state
,employee_id
,partner_id              as customer_id
,ville_client
,region_client
--,employees_ids
--,suivi
--,allocated_hours
--,allocated_percentage
--,working_days_count
--,user_id
--,company_id
--,rapport_supp
--,role_id
--,note_desc
--,name as planning_name
--,my_image
--,status
--,was_copied
--,start_datetime
--,end_datetime
--,is_published
--,publication_warning
--,recurrency_id
--,message_main_attachment_id
--,create_uid
--,write_uid
--,write_date
--,login_user
--,voiture
--,devis
--,amount_residual
--,etl_loaded_at
--,etl_batch_id
FROM dwh.dim_planning_slot;