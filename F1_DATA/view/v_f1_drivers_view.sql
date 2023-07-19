CREATE OR REPLACE FORCE EDITIONABLE VIEW "F1_DATA"."V_F1_DRIVERS" 
 ( "DRIVERID", "PERMANENTNUMBER", "CODE", "INFO", "GIVENNAME", "FAMILYNAME", "DATEOFBIRTH", "NATIONALITY"
  )  AS 
  select f1.driverid
       ,f1.permanentNumber
       ,f1.code
       ,f1.info
       ,f1.givenname
       ,f1.familyname
       ,f1.dateofbirth
       ,f1.nationality
from f1_staging.v_f1_json_docs ftab,
     json_table(ftab.f1_document,'$.MRData.DriverTable.Drivers[*]'
                COLUMNS ( driverid PATH '$.driverId',
                          permanentNumber PATH '$.permanentNumber',
                          code PATH '$.code',
                          info PATH '$.url',
                          givenName PATH '$.givenName',
                          familyName PATH '$.familyName',
                          dateOfBirth PATH '$.dateOfBirth',
                          nationality PATH '$.nationality')
               ) f1
where ftab.doc_type = 'DRIVERS'