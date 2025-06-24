CREATE OR REPLACE FORCE EDITIONABLE VIEW "V_F1_LAPTIMES" ("SEASON", "ROUND", "INFO", "RACENAME", "CIRCUITID", "URL", "CIRCUITNAME", "RACE_DATE", "RACE_TIME", "LAP_NUMBER", "DRIVERID", "POSITION", "LAPTIME") AS 
  select to_number(f1.season) as season,
       to_number(f1.round) as round,
       f1.info,
       f1.racename,
       f1.circuitid,
       f1.url,
       f1.circuitname,
       to_date(f1.race_date,'RRRR-MM-DD') as race_date,
       f1.race_time,
       to_number(f1.lap_number) as lap_number,
       f1.driverid,
       to_number(f1.position) as position,
       f1.laptime
from f1_staging.v_f1_json_docs ftab,
     json_table(ftab.f1_document,'$.MRData.RaceTable.Races[*]'
                COLUMNS ( season PATH '$.season',
                          round PATH '$.round',
                          info PATH '$.url',
                          raceName PATH '$.raceName',
                          nested path '$.Circuit[*]'
                          COLUMNS(
                             circuitid PATH '$.circuitId',
                             url PATH '$.url',
                             circuitName PATH '$.circuitName'),
                         race_date PATH '$.date',
                         race_time PATH '$.time',
                         nested path '$.Laps[*]'
                         COLUMNS(
                            lap_number PATH '$.number',
                            nested PATH '$.Timings[*]'
                            COLUMNS(
                               driverId PATH '$.driverId',
                               position PATH '$.position',
                               laptime PATH '$.time')))   
               ) f1
where ftab.doc_type = 'LAPTIMES'                
order by to_number(f1.season),to_number(f1.round),to_number(f1.lap_number),to_number(f1.position);