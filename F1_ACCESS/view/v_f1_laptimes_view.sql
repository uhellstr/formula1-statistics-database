CREATE OR REPLACE FORCE EDITIONABLE VIEW "F1_ACCESS"."V_F1_LAPTIMES" 
 ( "SEASON", "ROUND", "RACE_DATE", "RACE_TIME", "LAP_NUMBER", "DRIVERID", "POSITION", "LAPTIME", "LAPTIME_IN_MILLIS"
  )  AS 
  SELECT
        "SEASON",
        "ROUND",
        "RACE_DATE",
        "RACE_TIME",
        "LAP_NUMBER",
        "DRIVERID",
        "POSITION",
        "LAPTIME",
        F1_LOGIK.TO_MILLIS(LAPTIME) LAPTIME_IN_MILLIS
    FROM
        f1_data.f1_laptimes