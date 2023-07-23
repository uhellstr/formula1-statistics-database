CREATE OR REPLACE FORCE EDITIONABLE VIEW "F1_ACCESS"."V_F1_QUALIFICATIONTIMES" 
 ( "SEASON", "ROUND", "RACEDATE", "RACETIME", "POSITION", "DRIVERID", "CONSTRUCTORID", "Q1", "Q1_IN_MILLIS", "Q2", "Q2_IN_MILLIS", "Q3", "Q3_IN_MILLIS"
  )  AS 
  SELECT
        "SEASON",
        "ROUND",
        "RACEDATE",
        "RACETIME",
        "POSITION",
        "DRIVERID",
        "CONSTRUCTORID",
        "Q1",
        F1_LOGIK.TO_MILLIS(Q1) as Q1_IN_MILLIS,
        "Q2",
        F1_LOGIK.TO_MILLIS(Q2) as Q2_IN_MILLIS,        
        "Q3",
        F1_LOGIK.TO_MILLIS(Q3) as Q3_IN_MILLIS        
    FROM
        f1_data.f1_qualificationtimes