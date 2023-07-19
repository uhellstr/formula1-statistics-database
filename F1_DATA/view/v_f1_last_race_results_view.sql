CREATE OR REPLACE FORCE EDITIONABLE VIEW "F1_DATA"."V_F1_LAST_RACE_RESULTS" 
 ( "SEASON", "RACE", "RACENAME", "POSITION", "POINTS", "GIVENNAME", "FAMILYNAME"
  )  AS 
  select r.season,
       r.race,
       r.racename,
       r.position,
       r.points,
       r.givenname,
       r.familyname
from f1_data.v_f1_results r
where r.season = to_char(trunc(sysdate),'RRRR')
  and r.race = (select max(to_number(race))
                from v_f1_results
                where season = to_char(trunc(sysdate),'RRRR'))
  and r.position < 11
order by to_number(r.position) asc