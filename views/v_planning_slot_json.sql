CREATE OR REPLACE VIEW dwh.v_intervention AS
with planning as ( --planning : cte  table temporaire
  select
    customer_id
    ,row_number() over (partition by ps.customer_id order by create_date_ts) as cust_seq
    ,create_date_ts
    ,planning_date
    ,planning_ref_intervention
    ,type_intervention
    ,planning_motif
    ,regexp_replace(planning_remarque, '<\/?p>', '', 'gi') as planning_remarque 
    ,regexp_replace(planning_rapport, '<\/?p>', '', 'gi') as planning_rapport
    ,e.employee_name
  from dwh.v_planning_slot ps
  left join dwh.v_employee e on ps.employee_id = e.employee_id

)
select
  customer_id,
  max(cust_seq) as "# interv",
  min(create_date_ts) as "first_intervention",
  json_agg(
    json_build_object(
      'N°intervention  ' , cust_seq
      ,'date_ts         ' , to_char(create_date_ts, 'YYYY-MM-DD HH24:MI:SS')
      ,'date            ' , planning_date
      ,'ref             ' , planning_ref_intervention
      ,'motif           ' , planning_motif
      ,'type            ' , type_intervention
      ,'emp_name        ' , employee_name
      ,'remarque        ' , planning_remarque
      ,'rapport         ' , planning_rapport
      
    ) order by create_date_ts
  ) as planning_history
from planning
group by 1