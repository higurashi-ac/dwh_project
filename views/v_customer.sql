CREATE OR REPLACE VIEW dwh.v_customer AS
SELECT
id                  as customer_id
,"name"             as customer_name
,phone              as customer_phone
,mobile             as customer_mobile
,email              as customer_email
,email_normalized   as customer_email_normalized
,comment            as customer_comment
,street             as customer_street
,street_name        as customer_street_name
,street_number      as customer_street_number
,zip                as customer_zip
,city               as customer_city
,places             as customer_places
,create_date::date  as customer_create_date
FROM dwh.dim_customer;

--,active
--,function
--,type
--,street2
--,state_id
--,vat
--,website
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