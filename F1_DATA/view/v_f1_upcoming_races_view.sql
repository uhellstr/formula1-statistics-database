CREATE OR REPLACE FORCE EDITIONABLE VIEW "F1_DATA"."V_F1_UPCOMING_RACES" 
 ( "SEASON", "ROUND", "RACE_DATE"
  )  AS 
  select a.season,
       a.round,
       a.race_date
from v_f1_seasons_race_dates a
where a.round not in ( select b.race
                     from v_f1_results b
                     where a.season = b.season
                       and a.round = b.race)
  and a.season = to_char(trunc(sysdate),'RRRR')