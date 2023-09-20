CREATE OR REPLACE FORCE EDITIONABLE VIEW "APEX_F1"."V_F1_CUR_SEASON_RACES" 
 ( "SEASON", "ROUND", "CIRCUITID", "INFO", "CIRCUITNAME", "LAT", "LONGITUD", "LOCALITY", "COUNTRY"
  )  AS 
  select vr.season
       ,vr.round
       ,vt.circuitid
       ,vt.info
       ,vt.circuitname
       ,vt.lat
       ,vt.longitud
       ,vt.locality
       ,vt.country
from v_f1_tracks vt
inner join v_f1_races vr
on vt.circuitid = vr.circuitid
where vr.season = f1_logik.get_cur_f1_season  
order by vr.season desc, to_number(vr.round) asc