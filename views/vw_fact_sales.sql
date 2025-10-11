CREATE OR REPLACE VIEW dwh.vw_fact_sales AS

select  order_date
,       order_id
,       order_line_id
--,       product_id
,       pl.planning_id
,       customer_id


-------- derived measures: sale_order_line --------
-------- see fact_sales.py dag --------
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

join    dwh.dim_planning_slot pl
        on fs.planning_slot_id = pl.planning_slot_id

order by order_date desc, order_id, order_line_id;