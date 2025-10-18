CREATE OR REPLACE VIEW dwh.v_product_template AS
SELECT product_template_sk
, id as product_tmpl_id
, name
, type
, categ_id
, list_price
-- , sequence
-- , message_main_attachment_id
-- , description
-- , description_purchase
-- , description_sale
-- , rental
-- , volume
-- , weight
-- , sale_ok
-- , purchase_ok
-- , uom_id
-- , uom_po_id
-- , company_id
-- , active
-- , color
-- , default_code
-- , can_image_1024_be_zoomed
-- , has_configurable_attributes
-- , create_uid
-- , create_date
-- , write_uid
-- , write_date
-- , service_type
-- , sale_line_warn
-- , sale_line_warn_msg
-- , expense_policy
-- , invoice_policy
-- , sale_delay
-- , tracking
-- , description_picking
-- , description_pickingout
-- , description_pickingin
-- , produce_delay
-- , can_be_expensed
-- , width_moved0
-- , height_moved0
-- , purchase_method
-- , purchase_line_warn
-- , purchase_line_warn_msg
-- , service_to_purchase
-- , hs_code
-- , width
-- , height
-- , reference_fab
-- , reference_interne
-- , prix_achat
-- , couple
-- , diametre
-- , options_ok
-- , puissance
-- , brand_id
-- , is_pack
-- , pack_price
-- , pack_quantity
-- , pack_location_id
-- , available_in_pos
-- , to_weight
-- , pos_categ_id
-- , version
-- , etl_loaded_at
-- , etl_batch_id
FROM dwh.dim_product_template;