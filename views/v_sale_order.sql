CREATE OR REPLACE VIEW dwh.v_sale_order AS
SELECT
id                          as so_id
,"name"                     as so_name
,project_title              as so_project_title
,"state"                    as so_state
,date_order::date           as so_date
,partner_id                 as so_customer_id
,note                       as so_note
,planning_id                as so_planning_id
,discount_type              as so_discount_type
,discount_rate              as so_discount_rate
,amount_discount            as so_amount_discount
,amount_untaxed             as so_amount_untaxed
,amount_tax                 as so_amount_tax
,amount_total               as so_amount_total
,state_devis                as so_state_devis
,zip_client                 as so_zip_client
,region                     as so_region
,ville_client               as so_ville_client
,region_client              as so_region_client
,ref_intervention           as so_ref_intervention
,source                     as so_source
,relance                    as so_relance
,note_relance               as so_note_relance
,date_relance               as so_date_relance
,responsable_intervention   as so_responsable_intervention
,remarque                   as so_remarque
,status_pose                as so_status_pose

--,campaign_id
--,source_id
--,medium_id
--,access_token
--,message_main_attachment_id
--,origin
--,client_order_ref
--,reference
--,validity_date
--,require_signature
--,require_payment
--,create_date
--,user_id
--,partner_invoice_id
--,partner_shipping_id
--,pricelist_id
--,analytic_account_id
--,invoice_status
--,currency_rate
--,payment_term_id
--,fiscal_position_id
--,company_id
--,team_id
--,signed_by
--,signed_on
--,commitment_date
--,create_uid
--,write_uid
--,write_date
--,sale_order_template_id
--,incoterm
--,picking_policy
--,warehouse_id
--,procurement_group_id
--,effective_date
--,style
--,opportunity_id
--,carrier_id
--,delivery_message
--,delivery_rating_success
--,recompute_delivery_price
--,type_devis
--,code_promo_program_id
--,force_invoiced
--,amount_words
--,dispatch_type
--,hide_net_price
--,old_state
--,information
--,atelier_id
--,decharge
--,invoice_id
--,etl_loaded_at
--,etl_batch_id
FROM dwh.dim_sale_order
order by so_id desc;