CREATE OR REPLACE FORCE EDITIONABLE VIEW "APEX_F1"."V_F1_CUR_SEASON_QUALIFICATIONS" 
 ( "RACE", "GIVENNAME", "FAMILYNAME", "CONSTRUCTOR", "QUALIFICATION", "QUALIFICATION_TIME", "MILLIS", "POSITION"
  )  AS 
  select
  race
  , givenname
  ,familyname
  ,constructor
  ,qualification
  ,qualification_time
  ,millis
  ,position  
from
(
select
  race
  ,givenname
  ,familyname
  ,constructor
  ,qualification
  ,qualification_time
  ,f1_logik.to_millis(qualification_time) as millis
  ,starting_grid as position
from
(
select
  vfq.round as race
  ,vfd.givenname
  ,vfd.familyname 
  ,vfc.name as constructor
  ,case 
  when vfq.q3 is not null and vfq.q2 is not null and vfq.q1 is not null then
    'Q3'
  when vfq.q3 is null and vfq.q2 is not null and vfq.q1 is not null then 
    'Q2'
  when vfq.q3 is null and vfq.q2 is null and vfq.q1 is not null then
    'Q1'
  else
    null
  end as qualification
  ,case 
  when vfq.q3 is not null and vfq.q2 is not null and vfq.q1 is not null then
    q3
  when vfq.q3 is null and vfq.q2 is not null and vfq.q1 is not null then 
    q2
  when vfq.q3 is null and vfq.q2 is null and vfq.q1 is not null then
    q1
  else
    null
  end as qualification_time
  ,vfq.position as starting_grid
from
  v_f1_qualifications vfq
inner join v_f1_drivers vfd
on vfq.driverid = vfd.driverid
inner join v_f1_constructors vfc
on vfq.constructorid = vfc.constructorid
inner join v_f1_races vfr
on vfq.round = vfr.round and vfq.season = vfr.season
where vfq.season = f1_logik.get_cur_f1_season
  and vfq.position is not null
)) order by race,position