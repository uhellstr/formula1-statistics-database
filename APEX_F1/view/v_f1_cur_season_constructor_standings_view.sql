CREATE OR REPLACE FORCE EDITIONABLE VIEW "APEX_F1"."V_F1_CUR_SEASON_CONSTRUCTOR_STANDINGS" 
 ( "SEASON", "RACE", "POSITION", "POINTS", "WINS", "CONSTRUCTORNAME", "NATIONALITY"
  )  AS 
  select
    vfc.season
    ,vfc.race
    ,vfc.position
    ,vfc.points
    ,vfc.wins
    ,vfc1.name as constructorname
    ,vfc1.nationality
from v_f1_constructorstandings vfc
inner join v_f1_constructors vfc1
on vfc.constructorid = vfc1.constructorid
where vfc.season = f1_logik.get_cur_f1_season
order by vfc.points desc