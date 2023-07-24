-- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
-- This is a testsuite of different queries against the F1 database
--                   Run these queries as F1_ACCESS
-- Author: Ulf Hellstrom Epico Tech 2020 -2023
-- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

-- If you need more data for dbms_xplan

--alter session set statistics_level=ALL;

-- Tracks and races in order by season and race

select vr.season
       ,vr.round
       ,vt.circuitid
       ,vt.info
       ,vt.circuitname
       ,vt.lat
       ,vt.longitud
       ,vt.locality
       ,vt.country
from f1_access.v_f1_tracks vt
inner join f1_access.v_f1_races vr
on vt.circuitid = vr.circuitid
order by to_number(vr.season) desc, to_number(vr.round) asc;

-- Give us the current driver standings in the current season or if between seasons the last season

select vfd.season
       ,vfd.race
       ,vfd.points
       ,vfd.wins
       ,vfd1.givenname
       ,vfd1.familyname
       ,vfd.constructorid
from f1_access.v_f1_driverstandings vfd
inner join f1_access.v_f1_drivers vfd1
on vfd1.driverid = vfd.driverid
where vfd.season = f1_logik.get_cur_f1_season  -- result cache function used here to calculate current season to speed up things.
order by to_number(points) desc;

-- Give us the current constructor standings in the current season or if between seasons the last season

select
    vfc.season
    ,vfc.race
    ,vfc.position
    ,vfc.positiontext
    ,vfc.points
    ,vfc.wins
    ,vfc1.name as constructorname
    ,vfc1.nationality
from f1_access.v_f1_constructorstandings vfc
inner join f1_access.v_f1_constructors vfc1
on vfc.constructorid = vfc1.constructorid
where vfc.season = f1_logik.get_cur_f1_season  -- result cache function used here to calculate current season to speed up things.
order by vfc.points desc;

-- Get the starting grid for the latest race in current season or
-- if between seasons the last race of the last season.

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
  f1_access.v_f1_qualificationtimes vfq
inner join f1_access.v_f1_drivers vfd
on vfq.driverid = vfd.driverid
inner join f1_access.v_f1_constructors vfc
on vfq.constructorid = vfc.constructorid
inner join f1_access.v_f1_races vfr
on vfq.round = vfr.round and vfq.season = vfr.season
where vfq.season = f1_logik.get_cur_f1_season
  and vfq.position is not null
  and vfq.round = f1_logik.get_last_race(f1_logik.get_cur_f1_season)
order by vfq.position asc;
    
-- Give us the race winner and drivers with score for the last race in 
-- current season or last season if between seasons.

select
  vfr.season
  ,vfr.race
  ,vfr.racename
  ,vft.circuitname
  ,vfr.racedate
  ,vfr.pilotnr
  ,vfr.position
  ,vfr.points
  ,vfd.givenname
  ,vfd.familyname
  ,vfd.nationality
  ,vfc.name as constructor
  ,vfr.grid
  ,vfr.laps
  ,vfr.status
  ,vfr.ranking
  ,vfr.fastestlap
  ,vfr.millis
  ,vfr.racetime
from
  f1_access.v_f1_results vfr
inner join f1_access.v_f1_drivers vfd
on vfr.driverid = vfd.driverid
inner join f1_access.v_f1_constructors vfc
on vfr.constructorid = vfc.constructorid
inner join f1_access.v_f1_tracks vft
on vfr.circuitid = vft.circuitid
where vfr.season = f1_logik.get_cur_f1_season
  and position is not null
  and vfr.race = f1_logik.get_last_race(f1_logik.get_cur_f1_season)
order by to_number(vfr.position) asc
fetch first 10 rows only;

-- Check number of laps a driver hold a certain position on track in the current season or last season if in between seasons.
select season
       ,givenname
       ,familyname
       ,nationality
       ,position 
       ,laps_hold_position
from
(
select f1l.season
       ,vfd.givenname
       ,vfd.familyname
       ,vfd.nationality
       ,f1l.position 
       ,count(f1l.position) as laps_hold_position
from f1_access.v_f1_laptimes f1l
inner join f1_access.v_f1_drivers f1d
on  f1l.driverid = f1d.driverid
inner join f1_access.v_f1_drivers vfd
on f1d.driverid = vfd.driverid
where f1l.season = f1_logik.get_cur_f1_season
group by f1l.season,vfd.givenname,vfd.familyname,vfd.nationality,f1l.position
) order by  position asc,laps_hold_position desc;
