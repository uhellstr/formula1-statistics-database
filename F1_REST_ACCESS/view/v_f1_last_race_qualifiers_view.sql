CREATE OR REPLACE FORCE EDITIONABLE VIEW "F1_REST_ACCESS"."V_F1_LAST_RACE_QUALIFIERS" 
 ( "SEASON", "RACE", "RACENAME", "RACEDATE", "GIVENNAME", "FAMILYNAME", "NATIONALITY", "CONTSRUCTOR", "CONSTRUCTORNATIONALITY", "QUALIFICATION", "QUALIFICATION_TIME", "STARTING_GRID"
  )  AS 
  select
  vfq.season
  ,vfq.round as race
  ,vfr.racename
  ,vfq.racedate
  ,vfd.givenname
  ,vfd.familyname 
  ,vfd.nationality
  ,vfc.name as contsructor
  ,vfc.nationality as constructornationality
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
  f1_rest_access.v_f1_qualificationtimes vfq
inner join f1_rest_access.v_f1_drivers vfd
on vfq.driverid = vfd.driverid
inner join f1_rest_access.v_f1_constructors vfc
on vfq.constructor = vfc.constructorid
inner join f1_rest_access.v_f1_races vfr
on vfq.round = vfr.round and vfq.season = vfr.season
where vfq.season = f1_logik.get_cur_f1_season
  and vfq.position is not null
  and vfq.round = f1_logik.get_last_race(f1_logik.get_cur_f1_season)
order by vfq.position asc