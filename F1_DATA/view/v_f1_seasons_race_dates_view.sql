CREATE OR REPLACE FORCE EDITIONABLE VIEW "F1_DATA"."V_F1_SEASONS_RACE_DATES" 
 ( "SEASON", "ROUND", "INFO", "RACENAME", "CIRCUITID", "URL", "CIRCUITNAME", "RACE_DATE"
  )  AS 
  select to_number(f1.season) as season,
       to_number(f1.round) as round,
       f1.info,
       f1.racename,
       f1.circuitid,
       f1.url,
       f1.circuitname,
       to_date(f1.race_date,'RRRR-MM-DD') as race_date
from f1_staging.v_f1_json_docs ftab,
     json_table(ftab.f1_document,'$.MRData.RaceTable.Races[*]'
                COLUMNS ( season PATH '$.season',
                          round PATH '$.round',
                          info PATH '$.url',
                          raceName PATH '$.raceName',
                          nested path '$.Circuit[*]'
                          COLUMNS(circuitid PATH '$.circuitId',
                                  url PATH '$.url',
                                  circuitName PATH '$.circuitName'),
                         race_date PATH '$.date'  
                       )   
               ) f1 
where ftab.doc_type = 'RACEDATES'               
order by to_number(f1.season),to_number(f1.round)