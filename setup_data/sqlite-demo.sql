-- Tracks and races for current season

select vr.season
      ,vr.round
      ,vt.circuitid
      ,vt.circuitname
      ,vt.locality
      ,vt.country
  from f1_tracks vt
 inner join f1_races vr
on vt.circuitid = vr.circuitid
 where vr.season = (select CURRENT_YEAR from V_CURRENT_YEAR)
 order by vr.season desc
                ,vr.round asc;

-- get current standings 	in current season			
select vfd.season
      ,vfd.round
      ,vfr.racename
      ,vfr.circuitid
      ,vfd.points
      ,vfd.wins
      ,vfd1.givenname
      ,vfd1.familyname
      ,vfc.name as constructorname
 from f1_driverstandings vfd
 inner join f1_drivers vfd1
on vfd1.driverid = vfd.driverid
 inner join f1_constructors vfc
on vfd.constructorid = vfc.constructorid
  inner join f1_races vfr
on vfr.round = vfd.round and vfr.season = vfd.season
 where vfd.season = (select CURRENT_YEAR from V_CURRENT_YEAR)
 order by vfd.points desc;
 
 -- get constructor standings in current season.
 select vfc.season
      ,vfc.round
      ,vfc.position
      ,vfc.points
      ,vfc.wins
      ,vfc1.name as constructorname
      ,vfc1.nationality
from f1_constructorstandings vfc
inner join f1_constructors vfc1
on vfc.constructorid = vfc1.constructorid
where vfc.season = (select CURRENT_YEAR from V_CURRENT_YEAR)
order by vfc.points desc;

-- Get the result from the latest race
select frs.season
			,frs.round as race
			,frs.race_name as name
			,frs.circuit_name
			,frs.position
			,frs.points
			,frs.grid as result
			,frs.laps
			,frs.status
			,frs.driver_id as driver
			,frs.constructor_name
			,frs.race_time
from F1_RACERESULTS frs
where frs.season = (select CURRENT_YEAR from V_CURRENT_YEAR)
    and frs.round = (select LAST_RACE from V_LAST_RACE)
order by frs.position asc;
