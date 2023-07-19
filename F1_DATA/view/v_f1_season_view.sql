CREATE OR REPLACE FORCE EDITIONABLE VIEW "F1_DATA"."V_F1_SEASON" 
 ( "SEASON", "INFO"
  )  AS 
  select to_number(f1.season) as season
       ,f1.info
from f1_staging.v_f1_json_docs ftab,
     json_table(ftab.f1_document,'$.MRData.SeasonTable.Seasons[*]'
                COLUMNS ( season PATH '$.season',
                          info PATH '$.url')
               ) f1
where ftab.doc_type = 'SEASONS'
order by to_number(f1.season)