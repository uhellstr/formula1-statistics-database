CREATE OR REPLACE FORCE EDITIONABLE VIEW "APEX_F1"."V_F1_RESULTS" 
 ( "SEASON", "RACE", "INFO", "RACENAME", "CIRCUITID", "RACEDATE", "PILOTNR", "POSITION", "POSITIONTEXT", "POINTS", "DRIVERID", "CONSTRUCTORID", "GRID", "LAPS", "STATUS", "RANKING", "FASTESTLAP", "UNITS", "SPEED", "MILLIS", "RACETIME"
  )  AS 
  select "SEASON","RACE","INFO","RACENAME","CIRCUITID","RACEDATE","PILOTNR","POSITION","POSITIONTEXT","POINTS","DRIVERID","CONSTRUCTORID","GRID","LAPS","STATUS","RANKING","FASTESTLAP","UNITS","SPEED","MILLIS","RACETIME" from f1_data.F1_RESULTS