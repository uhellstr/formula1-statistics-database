CREATE OR REPLACE FORCE EDITIONABLE VIEW "V_F1_DRIVERSTANDINGS" 
 ( "SEASON", "RACE", "POSITION", "POSITIONTEXT", "POINTS", "WINS", "DRIVERID", "CONSTRUCTORID"
  )  AS 
  select fds.season,
       fds.race,
       fds.position,
       fds.positiontext,
       fds.points,
       fds.wins,
       fds.driverid,
       (case 
           when fds.constructorid is null then 
               (select vfr.constructorid 
                from v_f1_results vfr
                where vfr.season = fds.season
                  and vfr.driverid = fds.driverid
                  and vfr.race = fds.race)
           else fds.constructorid
        end) as constructorid
from f1_data.f1_driverstandings fds