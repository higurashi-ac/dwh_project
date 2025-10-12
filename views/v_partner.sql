CREATE OR REPLACE VIEW dwh.v_partner AS
SELECT
 id                    as partner_id 
,name                  as partner_name     
,phone                 as partner_phone     
,mobile                as partner_mobile     
,email                 as partner_email     
,email_normalized      as partner_email_normalized                 
,street                as partner_street     
,street2               as partner_street2         
,street_number         as partner_street_number             
,zip                   as partner_zip     
,city                  as partner_city     
,state_id              as partner_state_id         
,street_name           as partner_street_name             
,vat                   as partner_vat     
,website               as partner_website         
,comment               as partner_comment         
,active                as partner_active     
,function              as partner_function         
,type                  as partner_type     
,create_date::date     as partner_create_date
--,street_number2
--,date_localization
--,company_id
--,display_name
--,date
--,title
--,parent_id
--,ref
--,lang
--,tz
--,user_id
--,credit_limit
--,employee
--,country_id
--,partner_latitude
--,partner_longitude
--,is_company
--,industry_id
--,color
--,partner_share
--,commercial_partner_id
--,commercial_company_name
--,company_name
--,create_uid
--,write_uid
--,write_date
--,message_main_attachment_id
--,message_bounce
--,signup_token
--,signup_type
--,signup_expiration
--,team_id
--,debit_limit
--,last_time_entries_checked
--,invoice_warn
--,invoice_warn_msg
--,supplier_rank
--,customer_rank
--,sale_warn
--,sale_warn_msg
--,siret
--,picking_warn
--,picking_warn_msg
--,delivery_instructions
--,style
--,calendar_last_notif_ack
--,purchase_warn
--,purchase_warn_msg
--,plan_to_change_car
--,default_supplierinfo_discount
--,barcode
--,places
--,x_message
--,x_note
--,x_interphone
--,x_code
--,x_origin
--,x_state
--,x_date
--,x_date_reponse
--,x_operation
--,x_objet
--,partner_invoice
--,partner_delivery
--,etl_loaded_at
--,etl_batch_id
FROM dwh.dim_res_partner;