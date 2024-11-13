CREATE OR REPLACE FORCE EDITIONABLE VIEW "V_F1_RACES" 
 ( "SEASON", "ROUND", "INFO", "RACENAME", "CIRCUITID", "URL", "CIRCUITNAME", "LAT", "LONGITUDE", "LOCALITY", "COUNTRY"
  )  AS 
  select to_number(f1.season) as season
       ,to_number(f1.round) as round
       ,f1.info
       ,f1.racename
       ,f1.circuitid
       ,f1.url
       ,f1.circuitname
       ,f1.lat
       ,f1.lon as longitude
       ,f1.locality
       ,f1.country
from f1_staging.v_f1_json_docs ftab,
     json_table(ftab.f1_document,'$.MRData.RaceTable.Races[*]'
                COLUMNS ( season PATH '$.season',
                          round PATH '$.round',
                          info PATH '$.url',
                          raceName PATH '$.raceName',
                          circuitId PATH '$.Circuit.circuitId',
                          url PATH '$.Circuit.url',
                          circuitName PATH '$.Circuit.circuitName',
                          lat PATH '$.Circuit.Location.lat',
                          lon PATH '$.Circuit.Location.long',
                          locality PATH '$.Circuit.Location.locality',
                          country PATH '$.Circuit.Location.country'
                        )
               ) f1
where ftab.doc_type = 'RACES'
order by to_number(f1.season),to_number(f1.round)