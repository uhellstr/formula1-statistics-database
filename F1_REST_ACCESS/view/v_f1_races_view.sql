CREATE OR REPLACE FORCE EDITIONABLE VIEW "V_F1_RACES" 
 ( "SEASON", "ROUND", "INFO", "RACENAME", "CIRCUITID", "URL", "CIRCUITNAME", "LAT", "LONGITUDE", "LOCALITY", "COUNTRY"
  )  AS 
  select "SEASON","ROUND","INFO","RACENAME","CIRCUITID","URL","CIRCUITNAME","LAT","LONGITUDE","LOCALITY","COUNTRY" from F1_DATA.V_F1_RACES