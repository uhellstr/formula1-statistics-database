CREATE OR REPLACE FORCE EDITIONABLE VIEW "APEX_F1"."V_F1_CUR_SEASON_DRIVER_STANDINGS" 
 ( "SEASON", "RACE", "POINTS", "WINS", "GIVENNAME", "FAMILYNAME", "CONSTRUCTORNAME"
  )  AS 
  select vfd.season
       ,vfd.race
       ,vfd.points
       ,vfd.wins
       ,vfd1.givenname
       ,vfd1.familyname
       ,vfc.name as constructorname
from v_f1_driverstandings vfd
inner join v_f1_drivers vfd1
on vfd1.driverid = vfd.driverid
inner join v_f1_constructors vfc
on vfd.constructorid = vfc.constructorid
where vfd.season = f1_logik.get_cur_f1_season 
order by vfd.points desc