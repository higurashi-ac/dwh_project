CREATE OR REPLACE VIEW dwh.vw_dim_payment_justify AS
SELECT
    payment_justify_id
,   date_paiement
,   client
,   montant
,   total
,   source
,   etat
,   moyen_paiement
,   attachment
,   user_id
,   planning
,   type_paiement
--,date::date as date_justify
--,name as payment_justify_name
--,mode_paiement
--,create_uid
--,create_date
--,write_uid
--,write_date
--,memo
--,etl_loaded_at
--,etl_batch_id
FROM dwh.dim_payment_justify;