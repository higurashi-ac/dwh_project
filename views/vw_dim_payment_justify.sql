CREATE OR REPLACE VIEW dwh.vw_dim_payment_justify AS
SELECT
payment_justify_sk
--,payment_justify_id
--,name
--,mode_paiement
--,montant
--,date
--,client
--,source
--,total
--,create_uid
--,create_date
--,write_uid
--,write_date
--,etat
--,moyen_paiement
--,attachment
--,user_id
--,memo
--,date_paiement
--,planning
--,type_paiement
--,etl_loaded_at
--,etl_batch_id
FROM dwh.dim_payment_justify;