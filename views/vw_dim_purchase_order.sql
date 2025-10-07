CREATE OR REPLACE VIEW dwh.vw_dim_purchase_order AS
SELECT
id as po_id
,name as po_name
,partner_id as supplier_id
,partner_ref as "partner_ref (PL.name_seq)"
,COALESCE((REGEXP_MATCH(partner_ref, '#\d+'))[1],'#' || (REGEXP_MATCH(partner_ref, '(^|\s)(\d{4,5})($|\s)'))[2]) as name_seq_clean
,(REGEXP_MATCH(partner_ref, 'D\d+'))[1] as so_name
,case when LOWER(partner_ref) like '%stock%' then true else false end as in_stock
,date_order::date as order_date
,date_approve::date as approve_date
,state as po_state
,notes as po_notes
,invoice_count
,invoice_status
,amount_untaxed
,amount_tax
,amount_total
,fiscal_position_id
,payment_term_id
,user_id
,company_id
,currency_rate
,"Note" as po_note
,"Adresse"

--,date_planned
--,incoterm_id
--,message_main_attachment_id
--,access_token
--,origin
--,create_uid
--,create_date
--,write_uid
--,write_date
--,picking_count
--,picking_type_id
--,group_id
--,hide_net_price
--,dispatch_type
--,report_grids
--,etl_loaded_at
--,etl_batch_id
FROM dwh.dim_purchase_order;