-- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
-- This is a testsuite of different queries against the F1 database
--                   Run these queries as F1_ACCESS
-- Author: Ulf Hellstrom Epico Tech 2020-2025
-- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

-- If you need more data for dbms_xplan

--alter session set statistics_level=ALL;

REM
REM Info on current season or last season if we are between seasons
REM

-- VSCodium need this else you get american date format
alter session set nls_date_format = 'RRRR-MM-DD HH24:MI:SS';

select sysdate
  from dual;

-- Tracks and races for current season
-- result cache function used here to calculate current season to speed up things.
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
 where vr.season = f1_logik.get_cur_f1_season
 order by vr.season desc
         ,to_number(vr.round) asc;


-- Give us the current driver standings in the current season or if between seasons the last season

select vfd.season
      ,vfd.race
      ,vfr.racename
      ,vfr.circuitid
      ,vfd.points
      ,vfd.wins
      ,vfd1.givenname
      ,vfd1.familyname
      ,vfc.name as constructorname
  from f1_access.v_f1_driverstandings vfd
 inner join f1_access.v_f1_drivers vfd1
on vfd1.driverid = vfd.driverid
 inner join f1_access.v_f1_constructors vfc
on vfd.constructorid = vfc.constructorid
  inner join f1_access.v_f1_races vfr
on vfr.round = vfd.race and vfr.season = vfd.season
 where vfd.season = f1_logik.get_cur_f1_season
      -- result cache function used here to calculate current season to speed up things.
 order by vfd.points desc;


-- Give us the current constructor standings in the current season or if between seasons the last season

select vfc.season
      ,vfc.race
      ,vfc.position
      ,vfc.points
      ,vfc.wins
      ,vfc1.name as constructorname
      ,vfc1.nationality
  from f1_access.v_f1_constructorstandings vfc
 inner join f1_access.v_f1_constructors vfc1
on vfc.constructorid = vfc1.constructorid
 where vfc.season = f1_logik.get_cur_f1_season
-- result cache function used here to calculate current season to speed up things.
 order by vfc.points desc;

-- Get the starting grid for the latest race in current season or
-- if between seasons the last race of the last season.

select vfq.season
      ,vfq.round as race
      ,vfr.racename
      ,vfq.racedate
      ,vfd.givenname
      ,vfd.familyname
      ,vfd.nationality
      ,vfc.name as contsructor
      ,vfc.nationality as constructornationality
      ,case
   when vfq.q3 is not null
      and vfq.q2 is not null
      and vfq.q1 is not null then
      'Q3'
   when vfq.q3 is null
      and vfq.q2 is not null
      and vfq.q1 is not null then
      'Q2'
   when vfq.q3 is null
      and vfq.q2 is null
      and vfq.q1 is not null then
      'Q1'
   else
      null
        end as qualification
      ,case
   when vfq.q3 is not null
      and vfq.q2 is not null
      and vfq.q1 is not null then
      vfq.q3
   when vfq.q3 is null
      and vfq.q2 is not null
      and vfq.q1 is not null then
      vfq.q2
   when vfq.q3 is null
      and vfq.q2 is null
      and vfq.q1 is not null then
      vfq.q1
   else
      null
        end as qualification_time
      ,vfq.position as starting_grid
  from f1_access.v_f1_qualificationtimes vfq
 inner join f1_access.v_f1_drivers vfd
on vfq.driverid = vfd.driverid
 inner join f1_access.v_f1_constructors vfc
on vfq.constructorid = vfc.constructorid
 inner join f1_access.v_f1_races vfr
on vfq.round = vfr.round
   and vfq.season = vfr.season
 where vfq.season = f1_logik.get_cur_f1_season
   and vfq.position is not null
   and vfq.round = f1_logik.get_last_race(f1_logik.get_cur_f1_season)
 order by vfq.position asc;
    
-- Give us the race winner and drivers with score for the last race in 
-- current season or last season if between seasons.

select vfr.season
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
  from f1_access.v_f1_results vfr
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
  from (
   select f1l.season
         ,vfd.givenname
         ,vfd.familyname
         ,vfd.nationality
         ,f1l.position
         ,count(f1l.position) as laps_hold_position
     from f1_access.v_f1_laptimes f1l
    inner join f1_access.v_f1_drivers f1d
   on f1l.driverid = f1d.driverid
    inner join f1_access.v_f1_drivers vfd
   on f1d.driverid = vfd.driverid
    where f1l.season = f1_logik.get_cur_f1_season
    group by f1l.season
            ,vfd.givenname
            ,vfd.familyname
            ,vfd.nationality
            ,f1l.position
)
 order by position asc
         ,laps_hold_position desc;

-- Shw me the tracks where Verstappen never has won

SELECT DISTINCT RACENAME, RACEDATE, POSITION,  STATUS, POINTS
FROM V_F1_RESULTS
WHERE (DRIVERID = 'max_verstappen' OR DRIVERID = 'verstappen')
  AND (POSITION <> 1 OR UPPER(POSITIONTEXT) = 'DNF' OR UPPER(STATUS) = 'DNF')
  AND RACENAME NOT IN (
    'Spanish Grand Prix','Italian Grand Prix','Azerbaijan Grand Prix','São Paulo Grand Prix',
    'Qatar Grand Prix','Japanese Grand Prix','Emilia Romagna Grand Prix','French Grand Prix',
    'Saudi Arabian Grand Prix','Hungarian Grand Prix','Belgian Grand Prix','Chinese Grand Prix',
    'Abu Dhabi Grand Prix','Dutch Grand Prix','Canadian Grand Prix','Monaco Grand Prix',
    'United States Grand Prix','Mexico City Grand Prix','Austrian Grand Prix','Bahrain Grand Prix',
    'Malaysian Grand Prix','German Grand Prix','Styrian Grand Prix','Australian Grand Prix',
    'Mexican Grand Prix','Miami Grand Prix','British Grand Prix','Brazilian Grand Prix',
    '70th Anniversary Grand Prix','Las Vegas Grand Prix'
  )
  AND SEASON >= 2015
ORDER BY  RACEDATE DESC;



--
-- Number of times drivers been on podium and there current points in the current or last season.
--

select season
      ,givenname
      ,familyname
      ,number_of_podiums
      ,points
  from (
   select vfs.season
         ,vfd.givenname
         ,vfd.familyname
         ,vfs.points
         ,count(vfr.position) as number_of_podiums
     from f1_access.v_f1_results vfr
    inner join f1_access.v_f1_drivers vfd
   on vfr.driverid = vfd.driverid
    inner join f1_access.v_f1_driverstandings vfs
   on vfr.driverid = vfs.driverid
    where vfr.season = f1_logik.get_cur_f1_season
      and vfr.position < 4
      and vfs.race = (
      select max(vds.race)
        from f1_access.v_f1_driverstandings vds
       where vds.season = f1_logik.get_cur_f1_season
   )
    group by vfs.season
            ,vfd.givenname
            ,vfd.familyname
            ,vfs.points
)
 where season = f1_logik.get_cur_f1_season
 order by number_of_podiums desc
         ,points desc;

--
-- World champions thru history
--

--
-- Constructor championships thru history.
--

--
-- Percent of points the drivers within a team contributed to constructors title in current season
--
with constructor_points as (
   select vfc.season
         ,vfc.race
         ,vfc.position
         ,vfc.points
         ,vfc.wins
         ,vfc1.name as constructorname
         ,vfc1.nationality
     from f1_access.v_f1_constructorstandings vfc
    inner join f1_access.v_f1_constructors vfc1
   on vfc.constructorid = vfc1.constructorid
    where vfc.season = f1_logik.get_cur_f1_season
    order by vfc.points desc
),driver_points as (
   select vfd.season
         ,vfd.race
         ,vfd.points
         ,vfd.wins
         ,vfd1.givenname
         ,vfd1.familyname
         ,vfc.name as constructorname
     from f1_access.v_f1_driverstandings vfd
    inner join f1_access.v_f1_drivers vfd1
   on vfd1.driverid = vfd.driverid
    inner join f1_access.v_f1_constructors vfc
   on vfd.constructorid = vfc.constructorid
    where vfd.season = f1_logik.get_cur_f1_season
    order by vfd.points desc
)
select a.season
      ,a.constructorname
      ,a.points as constructor_points
      ,b.familyname
      ,b.points as driver_points
      ,round((b.points / NULLIF(a.points,0) * 100)) as percent
  from constructor_points a
 inner join driver_points b
on a.season = b.season
   and a.constructorname = b.constructorname
 order by a.constructorname
         ,b.familyname;

--
-- Get number of times a driver scored points and current points in the current or last season.
--
select season
      ,givenname
      ,familyname
      ,number_of_getting_in_points
      ,points
  from (
   select vfs.season
         ,vfd.givenname
         ,vfd.familyname
         ,vfs.points
         ,count(vfr.position) as number_of_getting_in_points
     from f1_access.v_f1_results vfr
    inner join f1_access.v_f1_drivers vfd
   on vfr.driverid = vfd.driverid
    inner join f1_access.v_f1_driverstandings vfs
   on vfr.driverid = vfs.driverid
    where vfr.season = f1_logik.get_cur_f1_season
      and vfr.position < 11
      and vfs.race = (
      select max(vf1dr.race)
        from f1_access.v_f1_driverstandings vf1dr
       where vf1dr.season = f1_logik.get_cur_f1_season
   )
    group by vfs.season
            ,vfd.givenname
            ,vfd.familyname
            ,vfs.points
)
 where season = f1_logik.get_cur_f1_season
 order by number_of_getting_in_points desc
         ,points desc;

--
-- Find all swedish formula 1 drivers and the years they where active
-- 

select d.driverid,
       d.permanentnumber,
       d.code,
       d.givenname,
       d.familyname,
       count(r.racedate) as number_of_starts,
       min(r.racedate) as starting_race,
       max(r.racedate) as end_race,
       listagg(distinct(extract(YEAR FROM r.racedate)),',') within group(order by extract(YEAR FROM r.racedate)) as years_active
from v_f1_drivers d
inner join v_f1_results r on d.driverid = r.driverid
where d.nationality = 'Swedish'
group by d.driverid,
         d.permanentnumber,
         d.code,
         d.givenname,
         d.familyname
order by number_of_starts desc;

REM
REM Other interesting queries
REM

--
-- Get the dominating driver for each season (e.g driver with most wins.)
--

select season
      ,wins
      ,givenname
      ,familyname
      ,nationality
      ,constructorname
  from (
   select vfr.season
         ,count(vfr.position) as wins
         ,vfd.givenname
         ,vfd.familyname
         ,vfd.nationality
         ,vfc.name as constructorname
     from f1_access.v_f1_results vfr
    inner join f1_access.v_f1_constructors vfc
   on vfr.constructorid = vfc.constructorid
    inner join f1_access.v_f1_drivers vfd
   on vfr.driverid = vfd.driverid
    where vfr.position = 1
    group by vfr.season
            ,vfd.givenname
            ,vfd.familyname
            ,vfd.nationality
            ,vfc.name
)
 order by season desc
         ,wins desc;

REM
REM With data in f1_data.f1_official_timedata we can do some additional analysis
REM
REM This requires that you load data using provided f1_timingdata python program
REM           
-- Try to calculate possible race speed using FP2 and stint 4 for Hamilton
-- for race 11 in season 2023
-- We use function for converting a laptime string hh:mm:ss:ms to numeric millisends
-- and find the median value and then we convert the millisecond value back to
-- a laptime value of hh:mm:ss:ms

select count(*) as number_of_laps_in_stint_4
      ,f1_logik.millis_to_laptime(round(median(f1_logik.to_millis(laptime)))) as median_laptime
  from v_f1_official_timedata
 where season = 2023
   and racetype = 'FP2'
   and driver = 'HAM'
   and race = 11
   and stint = 4
   and laptime is not null
   and median_laptime is not null
 order by lapnumber;
     --> 00:01:24.232

-- 
-- Get the race simulations median laptimes for *ALL* drivers 
-- race x and FP2 for the latest (requires data in f1_data.f1_official_timedata)
-- That is loaded thru python (f1_timingdata)
--
select driver
      ,stint
      ,number_of_laps_in_stint
      ,median_laptime
      ,compound
  from (
   with stints as (
      select count(lapnumber) as laps
            ,driver
            ,stint
        from v_f1_official_timedata
       where season = f1_logik.get_cur_f1_season
         and racetype = 'FP2'
         and race = &race
         and laptime is not null
       group by driver
               ,stint
   ),race_simulation as (
      select a.stint
            ,a.driver
            ,a.laps
        from stints a
       where a.laps = (
         select max(b.laps)
           from stints b
          where a.driver = b.driver
      )
   )
   select count(vfo.laptime) as number_of_laps_in_stint
         ,f1_logik.millis_to_laptime(round(median(f1_logik.to_millis(vfo.laptime)))) as median_laptime
         ,vfo.driver
         ,vfo.stint
         ,vfo.compound
     from v_f1_official_timedata vfo
    inner join race_simulation rs
   on vfo.driver = rs.driver
    where vfo.stint = rs.stint
      and vfo.season = f1_logik.get_cur_f1_season
      and vfo.racetype = 'FP2'
      and vfo.race = &race
      and laptime is not null
    group by vfo.driver
            ,vfo.stint
            ,vfo.compound
)
 order by f1_logik.to_millis(median_laptime) asc;