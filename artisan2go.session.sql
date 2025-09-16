-- Trying to link po->planing->so
select po.create_date::date
,po.name         as "PO Number"
,rp.id           as "PO-> supplier id"
,rp.name         as "PO-> Supplier name (RES)"
,ps.partner_id   as "planning-> partner_id"
,rp2.name        as "planning-> Customer name"
,po.partner_ref  as "PO partner_ref->name_seq in planning_slot)"
,po.amount_total as "PO amount_total"
,po.state        as "PO state"
,po.invoice_status as "PO invoice_status"
,so.amount_total as "SO amount_total"
,ps.id           as "planning_slot id"
,ps.employee_id  as "planner_id"
,hr.name         as "planner_name"
,so.planning_id  as "SO planning_id (planning_slot.id)"
,so.partner_id   as "SO -> Customer name"

,'Joins keys===>' as all_Join_keys
,po.partner_id   as "po.partner_id"
,rp.id           as "rp.id"
,po.partner_ref  as "po.partner_ref"
,ps.name_seq     as "ps.name_seq"
,ps.partner_id   as "ps.partner_id"
,rp2.id          as "rp2.id"
,ps.id           as "ps.id"
,so.planning_id  as "so.planning_id"
--,'PO DATA===>'       as PO_data       ,po.*
--,'RES.P DATA===>'    as RES_data      ,rp.*
--,'Planning DATA===>' as Planning_data ,ps.*
--,'Sales DATA===>'    as Sales_data    ,so.*
from purchase_order po
left join res_partner rp    on po.partner_id = rp.id
left join planning_slot ps  on po.partner_ref = ps.name_seq
left join res_partner rp2   on ps.partner_id = rp2.id
left join sale_order so     on ps.id = so.planning_id
left join hr_employee hr    on ps.employee_id = hr.id
where 1=1
--and po.create_date::date between '2024-08-01' and '2025-08-31'
--and po.name in ('P03254','P03255','P03242','P03118')
and po.name = 'P03238'
order by 1 DESC


select so.*
--'Planning DATA===>' as Planning_data ,ps.*
--,'Sales DATA===>'    as Sales_data    ,so.*
--,'RES.P DATA===>'    as RES_data      ,rp2.*
 from planning_slot ps
 left join sale_order so on ps.id=so.planning_id
 where ps.name_seq in ('#11054')

select * from planning_slot ps where ps.name_seq = '#11054'
select planning_id,* from sale_order so  where so.planning_id = '11032'

select planning_id,* from sale_order so where so.name = 'D2516167'

select po.*
from purchase_order po
where 1=1
--and po.create_date::date between '2025-08-06' and '2025-08-31'
and po.name in ('P03238')
order by po.create_date desc



select
    rp.id                  as "Client ID",
    rp.name                as "Client name",
    so.planning_id         as "Planning ID in SO",
    ps.partner_id         as "Client ID in Planning",

    so.id                  as "SO ID",
    so.name                as "SO number",
    so.amount_total        as "SO amount",
    so.state               as "SO state",
    so.create_date::date   as "SO date",
	so.state_devis         as "state sale order",
    ps.id                  as "Planning ID",
    ps.name_seq            as "Ref intervention",
    ps.state               as "Planning state",
	ps.type_int            as "type intervention" ,
	ps.motif               as "motif intervention",
	ps.name_seq            as "name_seq" ,
	ps.start_datetime      as "startdatetime",
  
    po.id                  as "PO ID",
    po.name                as "PO number",
    po.amount_total        as "PO amount",
    po.state               as "PO state",
    po.create_date::date   as "PO date",

    hr.name                as "Planner name"

from res_partner rp
-- devis (SO)
left join sale_order so 
    on so.partner_id = rp.id
-- planning
left join planning_slot ps 
    on ps.partner_id = rp.id
    --on ps.id = so.planning_id

left join hr_employee hr 
    on ps.employee_id = hr.id

-- achats liés à l’intervention
left join purchase_order po 
    on po.partner_ref = ps.name_seq
   --and po.state = 'purchase'     
where 1=1
and rp.id = 54250
and so.create_date::date = '2025-08-13'
order by so.create_date, po.create_date;







with base as (
select --so.*
so.date_order              as "date_order"
,row_number() over (partition by so.date_order::date,rp.id order by so.date_order::date desc) as rn
,rp.id                     --as "Customer_id"
,so.name                   as "number"
,so.state                  as "state"
,so.state_devis            as "state sale order"
,so.invoice_status         as "invoice_status"
,so.status_pose            as "status pose"
,so.project_title          as "project_title"
,so.planning_id            as "planning_id"
,rp.name                   as "Customer name"
,so.date_order::date       as "date"
,so.amount_untaxed         as "amount_untaxed"
,so.amount_tax             as "amount_tax"
,so.amount_total           as "amount total"
,so.discount_rate          as "discount rate"
,so.amount_discount        as "amount_discount"
from sale_order so 
left join res_partner rp
on rp.id = so.partner_id
where 1=1
and rp.id = 54250
--and so.name = 'D2516683'
--and so.create_date::date between '2024-08-01' and '2025-08-31'
and so.create_date::date = '2025-08-13'
--order by 1 desc
)

select base.*
,'===> PS' as "PS"
, ps.*
from base
 left join planning_slot ps
on base.id = ps.partner_id
 order by 1 desc ,3

with base as (select 
ps.create_date
,ps.partner_id as "Customer_id"
,ps."Remarque"
,ps.id as "planning_id"
,ps.parent_id
,COALESCE(ps.parent_id, ps.id) AS family_id -- coalesce ki tal9a null temchi lel valeur li ba3dha
,ps.type_int
,ps.state
,ps."Rapport"
,ps.name_seq
,so.name
,so.signed_by
,so.signed_on
,so.state_devis            as "state sale order"
,so.project_title          as "project_title"
,so.amount_untaxed         as "amount_untaxed"
,so.amount_tax             as "amount_tax"
,so.amount_total           as "amount total"
,so.discount_rate          as "discount rate"
,so.amount_discount        as "amount_discount"
,ps.motif
,ps.suivi
--,so.*
from planning_slot ps
left join sale_order so on ps.id=so.planning_id
where 1=1
--and ps.partner_id in ('54250','56018','54949')
and so.create_date::date between '2024-01-01' and '2025-01-01'
order by 1
)
select
row_number() over (partition by family_id order by create_date) as rn
,*
from base
--where x in(name_seq)
order by family_id
         ,case when parent_id is null then 0 else 1 end -- bch e child yji 9bal el parent
         ,create_date;