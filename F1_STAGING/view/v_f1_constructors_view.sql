CREATE OR REPLACE FORCE EDITIONABLE VIEW "V_F1_CONSTRUCTORS" 
 ( "CONSTRUCTORID", "INFO", "NAME", "NATIONALITY"
  )  AS 
  select "CONSTRUCTORID","INFO","NAME","NATIONALITY" from F1_DATA.V_F1_CONSTRUCTORS