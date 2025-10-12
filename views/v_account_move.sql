CREATE OR REPLACE VIEW dwh.v_account_move AS
SELECT
am.id as "account_move_id"
,am."date"
,am.invoice_date
,am.invoice_date_due
,am.create_date::date as sys_create_date
,am.partner_id
,case when c.id is not null then 'customer'
      when s.id is not null then 'supplier'
      else 'not defined'
      end as partner_type
,am.invoice_partner_display_name
,am.partner_shipping_id
,am.invoice_payment_state
,am.invoice_payment_ref
,am.ref
,am."name"
,am.invoice_origin -- to check against sale_order.name and to do some regex on it
,am.invoice_sent
,am.project_title
,am.ville_client
,am.region_client
,am.amount_untaxed
,am.amount_tax
,am.amount_total
,am.amount_residual
,am.amount_untaxed_signed
,am.amount_tax_signed
,am.amount_total_signed
,am.amount_residual_signed
,am.narration
,am."state"
,am."type"
,am.invoice_payment_term_id
,am.invoice_partner_bank_id
,am.to_check
,am.journal_id
,am.company_id
,am.currency_id
,am.tax_cash_basis_rec_id
,am.auto_post
,am.reversed_entry_id
,am.fiscal_position_id
,am.invoice_user_id
,am.team_id
,am.invoice_origin_id
,am.relance_mail
,am.relance_tel
,am.date_relance_tel
,am.date_relance_mail
,am.note_relance
,am.pose_fini
,am.accompte
,am.discount_type
,am.discount_rate
,am.amount_discount
--,access_token
--,message_main_attachment_id
--,commercial_partner_id
--,invoice_incoterm_id
--,invoice_source_email
--,invoice_cash_rounding_id
--,secure_sequence_number
--,inalterable_hash
--,create_uid
--,write_uid
--,write_date
--,campaign_id
--,source_id
--,medium_id
--,stock_move_id
--,style
--,x_date_intervention
--,x_reference
--,x_interlocultaire
--,move_name
--,hide_net_price
--,dispatch_type
--,test
--,x_serialnumber
--,etl_loaded_at
--,etl_batch_id

FROM dwh.dim_account_move am
left join dwh.dim_customer c
    on am.partner_id = c.id
left join dwh.dim_supplier s
    on am.partner_id = s.id
