CREATE OR REPLACE FORCE EDITIONABLE VIEW "V_F1_LAST_RACE_WINNERS" 
 ( "SEASON", "RACE", "RACENAME", "CIRCUITNAME", "RACEDATE", "PILOTNR", "POSITION", "POINTS", "GIVENNAME", "FAMILYNAME", "NATIONALITY", "CONSTRUCTOR", "GRID", "LAPS", "STATUS", "RANKING", "FASTESTLAP", "MILLIS", "RACETIME"
  )  AS 
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
  v_f1_results vfr
inner join v_f1_drivers vfd
on vfr.driverid = vfd.driverid
inner join v_f1_constructors vfc
on vfr.constructorid = vfc.constructorid
inner join v_f1_tracks vft
on vfr.circuitid = vft.circuitid
where vfr.season = f1_logik.get_cur_f1_season
  and position is not null
  and vfr.race = f1_logik.get_last_race(f1_logik.get_cur_f1_season)
order by to_number(vfr.position) asc
fetch first 10 rows only