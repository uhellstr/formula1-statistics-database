CREATE OR REPLACE FORCE EDITIONABLE VIEW "F1_REST_ACCESS"."V_F1_SEASON" 
 ( "SEASON", "INFO"
  )  AS 
  select "SEASON","INFO" from F1_DATA.V_F1_SEASON