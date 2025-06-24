CREATE OR REPLACE FORCE EDITIONABLE VIEW "V_F1_DRIVERSTANDINGS" ("SEASON", "RACE", "POSITION", "POSITIONTEXT", "POINTS", "WINS", "DRIVERID", "PERMANENTNUMBER", "CODE", "INFO", "GIVENNAME", "FAMILYNAME", "DATEOFBIRTH", "NATIONALITY", "CONSTRUCTORID", "CONSTRUCTORINFO", "CONSTRUCTORNAME", "CONSTRUCTORNATIONALITY") AS 
  select to_number(f1.season) as season,
       to_number(f1.race) as race,
       to_number(f1.position) as position,
       f1.positionText,
       to_number(f1.points,'999.99','nls_numeric_characters=''.,''') as points,
       to_number(f1.wins) as wins,
       f1.driverId,
       f1.permanentNumber,
       f1.code,
       f1.info,
       f1.givenname,
       f1.familyName,
       f1.dateOfBirth,
       f1.nationality,
       f1.constructorId,
       f1.constructorinfo,
       f1.constructorname,
       f1.constructornationality
from f1_staging.v_f1_json_docs ftab,
     json_table(ftab.f1_document,'$.MRData.StandingsTable.StandingsLists[*]'
                COLUMNS ( season PATH '$.season',
                          race PATH '$.round',
                          nested path '$.DriverStandings[*]'
                          COLUMNS
                           (
                             position PATH '$.position',
                             positionText PATH '$.positionText',
                             points PATH '$.points',
                             wins PATH '$.wins',
                             driverId PATH '$.Driver.driverId',
                             permanentNumber PATH '$.Driver.permanentNumber',
                             code PATH '$.Driver.code',
                             info PATH '$.Driver.url',
                             givenname PATH '$.Driver.givenName',
                             familyName PATH '$.Driver.familyName',
                             dateOfBirth PATH '$.Driver.dateOfBirth',
                             nationality PATH '$.Driver.nationality',
                             constructorId PATH '$.Constructors.constructorId',
                             constructorinfo PATH '$.Constructors.url',
                             constructorname PATH '$.Constructors.name',
                             constructornationality PATH '$.Constructors.nationality'
                           )
                       )   
               ) f1 
where ftab.doc_type = 'DRIVERSSTANDINGS'               
order by to_number(f1.season),to_number(f1.race),to_number(f1.position);