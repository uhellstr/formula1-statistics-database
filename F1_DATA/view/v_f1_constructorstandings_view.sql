CREATE OR REPLACE FORCE EDITIONABLE VIEW "V_F1_CONSTRUCTORSTANDINGS" 
 ( "SEASON", "RACE", "POSITION", "POSITIONTEXT", "POINTS", "WINS", "CONSTRUCTORID", "CONSTRUCTORINFO", "CONSTRUCTORNAME", "CONSTRUCTORNATIONALITY"
  )  AS 
  select  to_number(f1.season) as season,
        to_number(f1.race) as race,
        to_number(f1.position) as position,
        f1.positionText,
        --f1.points as points_text,
        to_number(f1.points,'999.99') as points,
        to_number(f1.wins) as wins,                             
        f1.constructorId,
        f1.constructorinfo,
        f1.constructorname,
        f1.constructornationality
from f1_staging.v_f1_json_docs ftab,
     json_table(ftab.f1_document,'$.MRData.StandingsTable.StandingsLists[*]'
                COLUMNS ( season PATH '$.season',
                          race PATH '$.round',
                          nested path '$.ConstructorStandings[*]'
                          COLUMNS
                           (
                             position PATH '$.position',
                             positionText PATH '$.positionText',
                             points PATH '$.points',
                             wins PATH '$.wins',                             
                             constructorId PATH '$.Constructor.constructorId',
                             constructorinfo PATH '$.Constructor.url',
                             constructorname PATH '$.Constructor.name',
                             constructornationality PATH '$.Constructor.nationality'
                           )
                       )   
               ) f1 
where ftab.doc_type = 'CONSTRUCTORSTANDINGS'               
order by to_number(f1.season),to_number(f1.race)