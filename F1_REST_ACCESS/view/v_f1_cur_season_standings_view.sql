CREATE OR REPLACE FORCE EDITIONABLE VIEW "F1_REST_ACCESS"."V_F1_CUR_SEASON_STANDINGS" 
 ( "SEASON", "POSITION", "RACE", "POINTS", "GIVENNAME", "FAMILYNAME", "CONSTRUCTORID"
  )  AS 
  select vfd.season
       ,rownum as position
       ,vfd.race
       ,vfd.points
       ,vfd.givenname
       ,vfd.familyname
       ,vfd.constructorid
from f1_rest_access.v_f1_driverstandings vfd
where vfd.season = f1_logik.get_cur_f1_season 
order by to_number(points) desc