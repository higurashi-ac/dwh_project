CREATE OR REPLACE VIEW dwh.vw_fact_sales AS

select  order_date
,       order_id
,       order_line_id
--,       product_id
,       customer_id
,       price_unit
,       product_uom_qty
,       discount
,       price_subtotal
,       price_tax
,       price_total
,       price_reduce

,       sum(price_total)  over(partition by order_id)  as sumOverTotal -- experimental
,       sum(price_reduce) over(partition by order_id)  as sumOverReduce -- experimental

from    dwh.fact_sales fs
order by order_date desc, order_id, order_line_id;