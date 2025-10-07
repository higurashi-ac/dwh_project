CREATE OR REPLACE VIEW dwh.vw_dim_date AS
SELECT
full_date
,year
,month
,day
,weekday_name
,weekday_iso
,is_weekend
,week_of_year
,is_holiday_fr
,is_holiday_tn
,holiday_name
,country
FROM dwh.dim_date;