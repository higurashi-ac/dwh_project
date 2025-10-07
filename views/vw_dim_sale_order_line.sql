CREATE OR REPLACE VIEW dwh.vw_dim_sale_order_line AS
SELECT
--,sale_order_line_sk
order_id as so_id
,sl.id as so_line_id
,concat(so.name,'-',row_number() over(partition by sl.order_id order by sl.id) ) as so_line_key
,sl.name as so_line_name
,sl.order_partner_id as customer_id
,sl.sequence
,sl.invoice_status
,sl.price_unit
,sl.price_subtotal
,sl.price_tax
,sl.discount
,sl.price_total
,sl.price_reduce
,sl.price_reduce_taxinc
,sl.price_reduce_taxexcl
,sl.product_id
,sl.product_uom_qty
,sl.product_uom
,sl.qty_delivered_method
,sl.qty_delivered
,sl.qty_delivered_manual
,sl.qty_to_invoice
,sl.qty_invoiced
,sl.untaxed_amount_invoiced
,sl.untaxed_amount_to_invoice
,sl.salesman_id
,sl.company_id

--,currency_id
--,is_expense
--,is_downpayment
--,customer_lead
--,display_type
--,create_uid
--,create_date
--,write_uid
--,write_date
--,product_packaging
--,route_id
--,width_moved0
--,height_moved0
--,is_delivery
--,is_reward_line
--,unite_mesure
--,width
--,height
--,puissance
--,m2
--,net_price
--,hide_net_price
--,etl_loaded_at
--,etl_batch_id
from dwh.dim_sale_order_line sl
inner join dwh.dim_sale_order so on so.id=order_id
order by so_id desc, so_line_id;