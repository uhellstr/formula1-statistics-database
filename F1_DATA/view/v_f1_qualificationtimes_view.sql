CREATE OR REPLACE FORCE EDITIONABLE VIEW "V_F1_QUALIFICATIONTIMES" 
 ( "SEASON", "ROUND", "RACEINFO", "RACENAME", "CIRCUITID", "CIRCUITURL", "CIRCUITNAME", "RACEDATE", "RACETIME", "DRIVERNUMBER", "POSITION", "DRIVERID", "PERMANENTNUMBER", "CODE", "DRIVERINFO", "GIVENNAME", "FAMILYNAME", "DATEOFBIRTH", "NATIONALITY", "CONSTRUCTOR", "CONSTRUCTORINFO", "CONSTRUCTORNAME", "CONSTRUCTORNATIONALITY", "Q1", "Q2", "Q3"
  )  AS 
  select to_number(f1.season) as season,
       to_number(f1.round) as round,
        f1.raceinfo,
        f1.raceName,
        f1.circuitid,
        f1.circuiturl,
        f1.circuitName,
        f1.racedate,
        f1.racetime,
        to_number(f1.drivernumber) as drivernumber,
        to_number(f1.position) as position,
        f1.driverid,
        f1.permanentnumber,
        f1.code,
        f1.driverinfo,
        f1.givenName,
        f1.familyName,
        to_date(f1.dateOfBirth,'RRRR-MM-DD') as dateofbirth,
        f1.nationality,
        f1.Constructor,
        f1.Constructorinfo,
        f1.constructorname,
        f1.constructornationality,
        f1.q1,
        f1.q2,
        f1.q3        
from f1_staging.v_f1_json_docs ftab,
     json_table(ftab.f1_document,'$.MRData.RaceTable.Races[*]'
                COLUMNS ( season PATH '$.season',
                          round PATH '$.round',
                          raceinfo PATH '$.url',
                          raceName PATH '$.raceName',
                          nested path '$.Circuit[*]'
                          COLUMNS(
                             circuitid PATH '$.circuitId',
                             circuiturl PATH '$.url',
                             circuitName PATH '$.circuitName'),
                         racedate PATH '$.date',
                         racetime PATH '$.time',
                         nested path '$.QualifyingResults[*]'
                         COLUMNS(
                            drivernumber PATH '$.number',
                            position PATH '$.position',
                            driverId PATH '$.Driver.driverId',
                            permanentnumber PATH '$.Driver.permanentNumber',
                            code PATH '$.Driver.code',
                            driverinfo PATH '$.Driver.url',
                            givenName PATH '$.Driver.givenName',
                            familyName PATH '$.Driver.familyName',
                            dateOfBirth PATH '$.Driver.dateOfBirth',
                            nationality PATH '$.Driver.nationality',
                            Constructor PATH '$.Constructor.constructorId',
                            Constructorinfo PATH '$.Constructor.url',
                            constructorname PATH '$.Constructor.name',
                            constructornationality PATH '$.Constructor.nationality',
                            q1 PATH '$.Q1',
                            q2 PATH '$.Q2',
                            q3 PATH '$.Q3'))) f1
where ftab.doc_type = 'QUALIFICATIONS'                            
order by to_number(f1.season),to_number(f1.round)