CREATE OR REPLACE FORCE EDITIONABLE VIEW "F1_ACCESS"."V_F1_CONSTRUCTORSTANDINGS" 
 ( "SEASON", "RACE", "POSITION", "POSITIONTEXT", "POINTS", "WINS", "CONSTRUCTORID"
  )  AS 
  select "SEASON","RACE","POSITION","POSITIONTEXT","POINTS","WINS","CONSTRUCTORID" from F1_DATA.F1_CONSTRUCTORSTANDINGS