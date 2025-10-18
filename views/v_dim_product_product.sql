CREATE OR REPLACE VIEW dwh.v_product_product AS
SELECT product_product_sk
, id as product_id
--, product_tmpl_id
, barcode
, fix_price
--, prix_vente
--, message_main_attachment_id
--, default_code
--, active
--, combination_indices
--, volume, weight
--, can_image_variant_1024_be_zoomed
--, create_uid, create_date
--, write_uid
--, write_date
--, reference_interne
--, prix_achat
--, Taille
--, etl_loaded_at
--, etl_batch_id
FROM dwh.dim_product_product;