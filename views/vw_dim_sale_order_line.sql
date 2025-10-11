CREATE OR REPLACE VIEW dwh.vw_dim_sale_order_line AS
SELECT
--,sale_order_line_sk
order_id                        as so_id
,concat(so.name,'-',row_number() over(partition by sl.order_id order by sl.id) )
                                as so_line_key
,sl.id                          as so_line_id                                

,sl.name                        as so_line_name                                
,sl.order_partner_id            as customer_id                                 
,sl.sequence                    as so_line_sequence                                
,sl.invoice_status              as so_line_invoice_status                                  
,sl.price_unit                  as so_line_price_unit                              
,sl.price_subtotal              as so_line_price_subtotal                                  
,sl.price_tax                   as so_line_price_tax                               
,sl.discount                    as so_line_discount                                
,sl.price_total                 as so_line_price_total                                 
,sl.price_reduce                as so_line_price_reduce                                    
,sl.price_reduce_taxinc         as so_line_price_reduce_taxinc                                         
,sl.price_reduce_taxexcl        as so_line_price_reduce_taxexcl                                            
,sl.product_id                  as so_line_product_id                              
,sl.product_uom_qty             as so_line_product_uom_qty                                     
,sl.product_uom                 as so_line_product_uom                                 
,sl.qty_delivered_method        as so_line_qty_delivered_method                                            
,sl.qty_delivered               as so_line_qty_delivered                                   
,sl.qty_delivered_manual        as so_line_qty_delivered_manual                                            
,sl.qty_to_invoice              as so_line_qty_to_invoice                                  
,sl.qty_invoiced                as so_line_qty_invoiced                                    
,sl.untaxed_amount_invoiced     as so_line_untaxed_amount_invoiced                                             
,sl.untaxed_amount_to_invoice   as so_line_untaxed_amount_to_invoice                                               
,sl.salesman_id                 as so_line_salesman_id                                 
,sl.company_id                  as so_line_company_id                              

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