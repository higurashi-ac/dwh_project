CREATE OR REPLACE VIEW dwh.vw_dim_planning_slot AS
SELECT
--,planning_sk
id as pl_id
,coalesce(parent_id, id) as parent_id
,row_number() over (partition by coalesce(parent_id, id) order by create_date) as pl_seq
,create_date::date as pl_date
,date_trunc('second', create_date::timestamp) as create_date_ts
,name_seq as pl_ref_intervention
,type_int as type_intervention
,motif
,"Rapport" as pl_rapport
,"Remarque" as pl_remarque
,state as pl_state
,employee_id
,partner_id as customer_id
,ville_client
,region_client
--,employees_ids
,suivi
,allocated_hours
,allocated_percentage
,working_days_count
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
FROM dwh.dim_planning_slot
order by parent_id desc, create_date_ts;