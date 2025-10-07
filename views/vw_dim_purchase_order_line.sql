CREATE OR REPLACE VIEW dwh.vw_dim_purchase_order_line AS
SELECT
id as po_line_id
--,purchase_order_line_sk
,name as po_line_name
,order_id as po_id
,sequence
,state as po_line_state
,product_qty
,product_uom_qty
,date_planned
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
order by 3 desc, 1;