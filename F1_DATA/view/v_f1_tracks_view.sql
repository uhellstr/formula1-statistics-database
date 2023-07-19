CREATE OR REPLACE FORCE EDITIONABLE VIEW "F1_DATA"."V_F1_TRACKS" 
 ( "CIRCUITID", "INFO", "CIRCUITNAME", "LAT", "LONGITUD", "LOCALITY", "COUNTRY"
  )  AS 
  select f1.circuitid
       ,f1.info
       ,f1.circuitname
       ,f1.lat
       ,f1.lon as longitud
       ,f1.locality
       ,f1.country
from f1_staging.v_f1_json_docs ftab,
     json_table(ftab.f1_document,'$.MRData.CircuitTable.Circuits[*]'
                COLUMNS ( circuitId PATH '$.circuitId',
                          info PATH '$.url',
                          circuitName PATH '$.circuitName',
                          lat PATH '$.Location.lat',
                          lon PATH '$.Location.long',
                          locality PATH '$.Location.locality',
                          country PATH '$.Location.country'
                          )
               ) f1
where ftab.doc_type = 'TRACKS'
order by circuitid