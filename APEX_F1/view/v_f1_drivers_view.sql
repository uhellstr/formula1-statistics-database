CREATE OR REPLACE FORCE EDITIONABLE VIEW "APEX_F1"."V_F1_DRIVERS" 
 ( "DRIVERID", "PERMANENTNUMBER", "CODE", "INFO", "GIVENNAME", "FAMILYNAME", "DATEOFBIRTH", "NATIONALITY"
  )  AS 
  select "DRIVERID","PERMANENTNUMBER","CODE","INFO","GIVENNAME","FAMILYNAME","DATEOFBIRTH","NATIONALITY" from f1_data.F1_DRIVERS