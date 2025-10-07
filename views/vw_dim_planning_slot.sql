CREATE OR REPLACE VIEW dwh.vw_dim_planning_slot AS
SELECT
id as planning_id
--,planning_sk
,name_seq
,type_int
,"Rapport" as planning_rapport
,"Remarque" as planning_remarque
,state as planning_state
,rapport_supp
,motif
,employee_id
,user_id
,partner_id
,company_id
--,role_id
--,note_desc
--,name as planning_name
--,my_image
--,status
--,was_copied
--,start_datetime
--,end_datetime
,allocated_hours
,allocated_percentage
,working_days_count
--,is_published
--,publication_warning
--,recurrency_id
--,message_main_attachment_id
--,create_uid
--,create_date
--,write_uid
--,write_date
--,login_user
--,employees_ids
,voiture
--,devis
,suivi
--,parent_id
--,amount_residual
,ville_client
,region_client
--,etl_loaded_at
--,etl_batch_id
FROM dwh.dim_planning_slot;