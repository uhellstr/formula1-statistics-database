CREATE OR REPLACE FORCE EDITIONABLE VIEW "V_F1_RESULTS" ("SEASON", "RACE", "INFO", "RACENAME", "CIRCUITID", "URL", "CIRCUITNAME", "LAT", "LON", "LOCALITY", "COUNTRY", "RACEDATE", "PILOTNR", "POSITION", "POSITIONTEXT", "POINTS", "DRIVERID", "DRIVURL", "GIVENNAME", "FAMILYNAME", "DATEOFBIRTH", "NATIONALITY", "CONSTRUCTORID", "CONSTRUCTORINFO", "CONSTRUCTORNAME", "CONSTRUCTORNATIONALITY", "GRID", "LAPS", "STATUS", "RANKING", "FASTESTLAP", "UNITS", "SPEED", "MILLIS", "RACETIME") AS 
  select to_number(f1.season) as season
       ,to_number(f1.race) as race
       ,f1.info
       ,f1.raceName
       ,f1.circuitId
       ,f1.url
       ,f1.circuitName
       ,f1.lat
       ,f1.lon
       ,f1.locality
       ,f1.country
       ,f1.racedate
       ,f1.pilotnr
       ,to_number(f1.position) as position
       ,f1.positionText
       ,to_number(f1.points,'999.99','nls_numeric_characters=''.,''') as points
       ,f1.driverId
       ,f1.drivurl
       ,f1.givenName
       ,f1.familyName
       ,to_date(f1.dateOfBirth,'RRRR-MM-DD') as dateofbirth
       ,f1.nationality
       ,f1.constructorId
       ,f1.constructorinfo
       ,f1.constructorname
       ,f1.constructornationality
       ,to_number(f1.grid) as grid
       ,to_number(f1.laps) as laps
       ,f1.status
       ,to_number(f1.ranking) as ranking
       ,to_number(fastestlap) as fastestlap
       ,units
       ,speed
       ,to_number(f1.millis) as millis
       ,f1.racetime
from f1_staging.v_f1_json_docs ftab,
     json_table(ftab.f1_document,'$.MRData.RaceTable.Races[*]'
                COLUMNS ( season PATH '$.season',
                          race PATH '$.round',
                          info PATH '$.url',
                          raceName PATH '$.raceName',
                          circuitId PATH '$.Circuit.circuitId',
                          url PATH '$.Circuit.url',
                          circuitName PATH '$.Circuit.circuitName',
                          lat PATH '$.Circuit.Location.lat',
                          lon PATH '$.Circuit.Location.long',
                          locality PATH '$.Circuit.Location.locality',
                          country PATH '$.Circuit.Location.country',
                          racedate PATH '$.date',
                          nested path '$.Results[*]'
                          COLUMNS
                           (
                             pilotnr PATH '$.number',
                             position PATH '$.position',
                             positionText PATH '$.positionText',
                             points PATH '$.points',
                             driverId PATH '$.Driver.driverId',
                             drivurl PATH '$.Driver.url',
                             givenName PATH '$.Driver.givenName',
                             familyName PATH '$.Driver.familyName',
                             dateOfBirth PATH '$.Driver.dateOfBirth',
                             nationality PATH '$.Driver.nationality',
                             constructorId PATH '$.Constructor.constructorId',
                             constructorinfo PATH '$.Constructor.url',
                             constructorname PATH '$.Constructor.name',
                             constructornationality PATH '$.Constructor.nationality',
                             grid PATH '$.grid',
                             laps PATH '$.laps',
                             status PATH '$.status',
                             ranking PATH '$.FastestLap.rank',
                             fastestlap PATH '$.FastestLap.lap',
                             units  PATH '$.FastestLap.units',
                             speed  PATH '$.FastestLap.speed',
                             millis PATH '$.Time.millis',
                             racetime PATH '$.Time.time'
                          )
                       )   
               ) f1
where ftab.doc_type = 'RACERESULTS'               
order by to_number(f1.season),to_number(f1.race);