CREATE OR REPLACE FORCE EDITIONABLE VIEW "APEX_F1"."V_F1_CONSTRUCTORS" 
 ( "CONSTRUCTORID", "INFO", "NAME", "NATIONALITY"
  )  AS 
  select "CONSTRUCTORID","INFO","NAME","NATIONALITY" from f1_data.F1_CONSTRUCTORS