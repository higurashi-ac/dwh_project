CREATE OR REPLACE VIEW dwh.vw_fact_sales AS
SELECT
order_id
,order_line_id
,order_name
,order_date
,customer_id
,price_unit
,product_uom_qty
,discount
,price_subtotal
,price_tax
,price_total
,price_reduce

,sum(price_total)  over(partition by order_id)  as sumOverTotal -- experimental
,sum(price_reduce) over(partition by order_id)  as sumOverReduce -- experimental
FROM dwh.fact_sales;