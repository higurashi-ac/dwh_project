CREATE OR REPLACE VIEW dwh.v_fact_purchases AS

select  order_date      as date_id
,       order_id        as po_id
,       order_line_id   as po_line_id
,       supplier_id     as supplier_id
,       product_id      as sales_product_id
,       product_name    as product_name 
,       product_price   as product_price
,       product_barcode as product_barcode


-------- derived measures: sale_order_line --------
-------- see fact_sales.py dag for more --------
,       price_unit          as fs_price_unit
,       product_uom_qty     as fs_product_uom_qty
,       discount            as fs_discount
,       price_subtotal      as fs_price_subtotal
,       price_tax           as fs_price_tax
,       price_total         as fs_price_total

,       sum(price_total)  over(partition by order_id)  as sumOverTotal -- experimental


from    dwh.fact_purchases fs
order by order_date desc, order_id, order_line_id;