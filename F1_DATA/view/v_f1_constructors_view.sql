CREATE OR REPLACE FORCE EDITIONABLE VIEW "F1_DATA"."V_F1_CONSTRUCTORS" 
 ( "CONSTRUCTORID", "INFO", "NAME", "NATIONALITY"
  )  AS 
  select f1.constructorid
       ,f1.info
       ,f1.name
       ,f1.nationality
from f1_staging.v_f1_json_docs ftab,
     json_table(ftab.f1_document,'$.MRData.ConstructorTable.Constructors[*]'
                COLUMNS( constructorId PATH '$.constructorId',
                          info PATH '$.url',
                          name PATH '$.name',
                          nationality PATH '$.nationality')
               ) f1
where ftab.doc_type = 'CONSTRUCTORS'