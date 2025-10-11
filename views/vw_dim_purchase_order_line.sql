CREATE OR REPLACE VIEW dwh.vw_dim_purchase_order_line AS
SELECT
order_id                as po_id
,id                     as po_line_id
,concat('PO-', order_id,'-',row_number() over(partition by order_id order by id) ) as po_line_key
,"name"                 as po_line_desc
,"sequence"
,"state"                as po_line_state
,product_qty
,product_uom_qty
,date_planned::date     as po_line_date_planned
,product_uom
,product_id
,price_unit
,price_subtotal
,price_total
,price_tax
--,account_analytic_id
--,company_id

,qty_invoiced
,qty_received_method
,qty_received
,qty_received_manual
,partner_id
--,currency_id
--,display_type
--,create_uid
--,create_date
--,write_uid
--,write_date
--,sale_order_id
--,sale_line_id
,prix_achat
--,orderpoint_id
--,propagate_date
--,propagate_date_minimum_delta
--,propagate_cancel
,discount
--,unite_mesure
--,width
--,height
--,square_meter
,net_price_pur
--,hide_net_price
--,etl_loaded_at
--,etl_batch_id
FROM dwh.dim_purchase_order_line
order by po_id desc, po_line_id;