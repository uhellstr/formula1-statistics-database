BEGIN TRANSACTION;

CREATE TABLE IF NOT EXISTS "F1_CONSTRUCTORSTANDINGS" (
	"season"	INT,
	"round"	INT,
	"position"	INT,
	"positiontext"	,
	"points"	REAL,
	"wins"	INT,
	"constructorid"	,
	"constructorurl"	,
	"constructorname"	,
	"constructornationality"	
);

CREATE TABLE IF NOT EXISTS "F1_DRIVERS" (
	"driverid"	,
	"url"	,
	"givenname"	,
	"familyname"	,
	"dateofbirth"	,
	"nationality"	,
	"code"	,
	"permanentnumber"	
);

CREATE TABLE IF NOT EXISTS "F1_DRIVERSTANDINGS" (
	"season"	INT,
	"round"	INT,
	"position"	INT,
	"positiontext"	,
	"points"	REAL,
	"wins"	INT,
	"driverid"	,
	"permanentnumber"	,
	"drivercode"	,
	"driverurl"	,
	"drivergivenname"	,
	"driverfamilyname"	,
	"driverdateofbirth"	,
	"drivernationality"	,
	"constructorid"	,
	"constructorurl"	,
	"constructorname"	,
	"constructornationality"	
);

CREATE TABLE IF NOT EXISTS "F1_JSON_DOCS" (
	"DOC_ID"	REAL,
	"DOC_TYPE"	REAL,
	"DATE_LOADED"	TEXT,
	"SEASON"	REAL,
	"RACE"	REAL,
	"LAPNUMBER"	REAL,
	"RACETYPE"	REAL,
	"F1_DOCUMENT"	TEXT
);

CREATE TABLE IF NOT EXISTS "F1_JSON_DOCTYPE" (
	"ID"	REAL,
	"DOC_TYPE"	TEXT
);

CREATE TABLE IF NOT EXISTS "F1_JSON_RACETYPE" (
	"ID"	REAL,
	"RACE_TYPE"	TEXT
);

CREATE TABLE IF NOT EXISTS "F1_LAPTIMES" (
	"season"	INT,
	"round"	INT,
	"raceurl"	,
	"racename"	,
	"racedate"	,
	"circuitid"	,
	"circuiturl"	,
	"circuitname"	,
	"circuitlatitude"	REAL,
	"circuitlongitude"	REAL,
	"circuitlocality"	,
	"circuitcountry"	,
	"lapnumber"	INT,
	"driverid"	,
	"driverposition"	INT,
	"laptime"	,
	"lap_time_ms"	
);

CREATE TABLE  IF NOT EXISTS F1_QUALIFICATION_LAPS(
  season,
  round,
  position,
  car_number,
  driver_id,
  given_name,
  family_name,
  driver_nationality,
  constructor_id,
  constructor_name,
  constructor_nationality,
  Q1,
  Q2,
  Q3
);

CREATE TABLE IF NOT EXISTS "F1_RACERESULTS" (
	"season"	INT,
	"round"	INT,
	"race_name"	,
	"race_date"	,
	"circuit_id"	,
	"circuit_name"	,
	"circuit_locality"	,
	"circuit_country"	,
	"position"	INT,
	"position_text"	,
	"points"	REAL,
	"grid"	INT,
	"laps"	INT,
	"status"	,
	"driver_id"	,
	"driver_first_name"	,
	"driver_last_name"	,
	"driver_nationality"	,
	"constructor_id"	,
	"constructor_name"	,
	"constructor_nationality"	,
	"race_time_millis"	,
	"race_time"	
);

CREATE TABLE IF NOT EXISTS "F1_RACES" (
	"season"	INT,
	"round"	INT,
	"raceurl"	,
	"racename"	,
	"racedate"	,
	"circuitid"	,
	"circuiturl"	,
	"circuitname"	,
	"latitude"	REAL,
	"longitude"	REAL,
	"locality"	,
	"country"	
);

CREATE TABLE IF NOT EXISTS "F1_SEASONS" (
	"season"	INT,
	"season_url"	
);

CREATE TABLE IF NOT EXISTS "F1_TRACKS" (
	"circuitid"	,
	"url"	,
	"circuitname"	,
	"latitude"	,
	"longitude"	,
	"locality"	,
	"country"	
);

CREATE TABLE IF NOT EXISTS "F1_CONSTRUCTORS" (
	"constructorId"	,
	"url"	,
	"name"	,
	"nationality"	
);

CREATE VIEW IF NOT EXISTS V_F1_CONSTRUCTORS AS
SELECT
    json_extract(value, '$.constructorId') AS constructorId,
    json_extract(value, '$.url') AS url,
    json_extract(value, '$.name') AS name,
    json_extract(value, '$.nationality') AS nationality
FROM
    F1_JSON_DOCS,
    json_each(json_extract(F1_DOCUMENT, '$.MRData.ConstructorTable.Constructors'))
WHERE DOC_TYPE = 1.0
ORDER BY CONSTRUCTORID ASC;

CREATE VIEW IF NOT EXISTS V_F1_CONSTRUCTORSTANDINGS AS
SELECT
    cast(json_extract(standings.value, '$.season') AS INT) AS season,
    cast(json_extract(standings.value, '$.round') AS INT) AS round,
    cast(json_extract(constructor.value, '$.position') AS INT) AS position,
    json_extract(constructor.value, '$.positionText') AS positiontext,
    cast(json_extract(constructor.value, '$.points') AS REAL) AS points,
    cast(json_extract(constructor.value, '$.wins') AS INT) AS wins,
    json_extract(constructor.value, '$.Constructor.constructorId') AS constructorid,
    json_extract(constructor.value, '$.Constructor.url') AS constructorurl,
    json_extract(constructor.value, '$.Constructor.name') AS constructorname,
    json_extract(constructor.value, '$.Constructor.nationality') AS constructornationality
FROM
    F1_JSON_DOCS,
    json_each(json_extract(F1_DOCUMENT, '$.MRData.StandingsTable.StandingsLists')) AS standings,
    json_each(json_extract(standings.value, '$.ConstructorStandings')) AS constructor
WHERE DOC_TYPE = 2.0;

CREATE VIEW IF NOT EXISTS V_F1_DRIVERS AS
SELECT
    json_extract(value, '$.driverId') AS driverid,
    json_extract(value, '$.url') AS url,
    json_extract(value, '$.givenName') AS givenname,
    json_extract(value, '$.familyName') AS familyname,
    json_extract(value, '$.dateOfBirth') AS dateofbirth,
    json_extract(value, '$.nationality') AS nationality,
    json_extract(value, '$.code') AS code,
    json_extract(value, '$.permanentNumber') AS permanentnumber
FROM
    F1_JSON_DOCS,
    json_each(json_extract(F1_DOCUMENT, '$.MRData.DriverTable.Drivers'))
WHERE DOC_TYPE = 3.0;

CREATE VIEW IF NOT EXISTS V_F1_DRIVERSTANDINGS AS
SELECT
    cast(json_extract(standings.value, '$.season') AS INT) AS season,
    cast(json_extract(standings.value, '$.round') AS INT) AS round,
    cast(json_extract(driver_standing.value, '$.position') AS INT) AS position,
    json_extract(driver_standing.value, '$.positionText') AS positiontext,
    cast(json_extract(driver_standing.value, '$.points') AS REAL) AS points,
    cast(json_extract(driver_standing.value, '$.wins') AS INT) AS wins,
    json_extract(driver_standing.value, '$.Driver.driverId') AS driverid,
    json_extract(driver_standing.value, '$.Driver.permanentNumber') AS permanentnumber,
    json_extract(driver_standing.value, '$.Driver.code') AS drivercode,
    json_extract(driver_standing.value, '$.Driver.url') AS driverurl,
    json_extract(driver_standing.value, '$.Driver.givenName') AS drivergivenname,
    json_extract(driver_standing.value, '$.Driver.familyName') AS driverfamilyname,
    json_extract(driver_standing.value, '$.Driver.dateOfBirth') AS driverdateofbirth,
    json_extract(driver_standing.value, '$.Driver.nationality') AS drivernationality,
    json_extract(constructor.value, '$.constructorId') AS constructorid,
    json_extract(constructor.value, '$.url') AS constructorurl,
    json_extract(constructor.value, '$.name') AS constructorname,
    json_extract(constructor.value, '$.nationality') AS constructornationality
FROM
    F1_JSON_DOCS,
    json_each(json_extract(F1_DOCUMENT, '$.MRData.StandingsTable.StandingsLists')) AS standings,
    json_each(json_extract(standings.value, '$.DriverStandings')) AS driver_standing,
    json_each(json_extract(driver_standing.value, '$.Constructors')) AS constructor
WHERE DOC_TYPE = 4.0;

CREATE VIEW IF NOT EXISTS V_F1_JSON_DOCS AS
SELECT cast(fd.DOC_ID AS INT) AS DOC_ID
       ,fj.DOC_TYPE
	   ,datetime(fd.DATE_LOADED) as DATE_LOADED
	   ,cast(fd.SEASON AS INT) AS SEASON
	   ,cast(fd.RACE AS INT) AS RACE
	   ,cast(fd.LAPNUMBER AS INT) AS LAPNUMBER
	   ,fd.RACETYPE
	   ,fd.F1_DOCUMENT
FROM F1_JSON_DOCS fd
INNER JOIN F1_JSON_DOCTYPE fj
ON fd.DOC_TYPE = fj.ID
ORDER BY datetime(fd.date_loaded) DESC;

CREATE VIEW IF NOT EXISTS V_F1_LAPTIMES AS
SELECT
    cast(json_extract(race.value, '$.season') AS INT) AS season,
    cast(json_extract(race.value, '$.round') AS INT) AS round,
    json_extract(race.value, '$.url') AS raceurl,
    json_extract(race.value, '$.raceName') AS racename,
    json_extract(race.value, '$.date') AS racedate,
    json_extract(race.value, '$.Circuit.circuitId') AS circuitid,
    json_extract(race.value, '$.Circuit.url') AS circuiturl,
    json_extract(race.value, '$.Circuit.circuitName') AS circuitname,
    cast(json_extract(race.value, '$.Circuit.Location.lat') AS REAL) AS circuitlatitude,
    cast(json_extract(race.value, '$.Circuit.Location.long') AS REAL) AS circuitlongitude,
    json_extract(race.value, '$.Circuit.Location.locality') AS circuitlocality,
    json_extract(race.value, '$.Circuit.Location.country') AS circuitcountry,
    cast(json_extract(lap.value, '$.number') AS INT) AS lapnumber,
    json_extract(timing.value, '$.driverId') AS driverid,
    cast(json_extract(timing.value, '$.position') AS INT) AS driverposition,
    json_extract(timing.value, '$.time') AS laptime,
	(CAST(substr(json_extract(timing.value, '$.time'), 1, instr(json_extract(timing.value, '$.time'), ':') - 1) AS INTEGER) * 60000) +
    (CAST(substr(json_extract(timing.value, '$.time'), instr(json_extract(timing.value, '$.time'), ':') + 1) AS FLOAT) * 1000) AS lap_time_ms
FROM
    F1_JSON_DOCS,
    json_each(json_extract(F1_DOCUMENT, '$.MRData.RaceTable.Races')) AS race
    LEFT JOIN json_each(json_extract(race.value, '$.Laps')) AS lap
    LEFT JOIN json_each(json_extract(lap.value, '$.Timings')) AS timing
WHERE DOC_TYPE = 5.0;

CREATE VIEW IF NOT EXISTS V_F1_QUALIFICATIONTIMES AS
SELECT
    json_extract(doc.F1_DOCUMENT, '$.MRData.RaceTable.season') AS season,
    json_extract(doc.F1_DOCUMENT, '$.MRData.RaceTable.round') AS round,
    json_extract(result.value, '$.position') AS position,
    json_extract(result.value, '$.number') AS car_number,
    json_extract(result.value, '$.Driver.driverId') AS driver_id,
    json_extract(result.value, '$.Driver.givenName') AS given_name,
    json_extract(result.value, '$.Driver.familyName') AS family_name,
    json_extract(result.value, '$.Driver.nationality') AS driver_nationality,
    json_extract(result.value, '$.Constructor.constructorId') AS constructor_id,
    json_extract(result.value, '$.Constructor.name') AS constructor_name,
    json_extract(result.value, '$.Constructor.nationality') AS constructor_nationality,
    json_extract(result.value, '$.Q1') AS Q1,
    json_extract(result.value, '$.Q2') AS Q2,
    json_extract(result.value, '$.Q3') AS Q3
FROM F1_JSON_DOCS AS doc,
     json_each(json_extract(doc.F1_DOCUMENT, '$.MRData.RaceTable.Races[0].QualifyingResults')) AS result
WHERE doc.DOC_TYPE = 6;

CREATE VIEW IF NOT EXISTS V_F1_RACERESULTS AS
SELECT
    cast(json_extract(race.value, '$.season') AS INT) AS season,
    cast(json_extract(race.value, '$.round') AS INT) AS round,
    json_extract(race.value, '$.raceName') AS race_name,
    json_extract(race.value, '$.date') AS race_date,
    json_extract(race.value, '$.Circuit.circuitId') AS circuit_id,
    json_extract(race.value, '$.Circuit.circuitName') AS circuit_name,
    json_extract(race.value, '$.Circuit.Location.locality') AS circuit_locality,
    json_extract(race.value, '$.Circuit.Location.country') AS circuit_country,
    cast(json_extract(result.value, '$.position') AS INT) AS position,
    json_extract(result.value, '$.positionText') AS position_text,
    cast(json_extract(result.value, '$.points') AS REAL) AS points,
    cast(json_extract(result.value, '$.grid') AS INT) AS grid,
    cast(json_extract(result.value, '$.laps') AS INT) AS laps,
    json_extract(result.value, '$.status') AS status,
    json_extract(result.value, '$.Driver.driverId') AS driver_id,
    json_extract(result.value, '$.Driver.givenName') AS driver_first_name,
    json_extract(result.value, '$.Driver.familyName') AS driver_last_name,
    json_extract(result.value, '$.Driver.nationality') AS driver_nationality,
    json_extract(result.value, '$.Constructor.constructorId') AS constructor_id,
    json_extract(result.value, '$.Constructor.name') AS constructor_name,
    json_extract(result.value, '$.Constructor.nationality') AS constructor_nationality,
    json_extract(result.value, '$.Time.millis') AS race_time_millis,
    json_extract(result.value, '$.Time.time') AS race_time
FROM F1_JSON_DOCS,
    json_each(F1_DOCUMENT, '$.MRData.RaceTable.Races') race
LEFT JOIN json_each(race.value, '$.Results') result
WHERE DOC_TYPE = 8.0;

CREATE VIEW IF NOT EXISTS V_F1_RACES AS
SELECT
    cast(json_extract(race.value, '$.season') AS INT) AS season,
    cast(json_extract(race.value, '$.round') AS INT) AS round,
    json_extract(race.value, '$.url') AS raceurl,
    json_extract(race.value, '$.raceName') AS racename,
    json_extract(race.value, '$.date')  AS racedate,
    json_extract(race.value, '$.Circuit.circuitId') AS circuitid,
    json_extract(race.value, '$.Circuit.url') AS circuiturl,
    json_extract(race.value, '$.Circuit.circuitName') AS circuitname,
    cast(json_extract(race.value, '$.Circuit.Location.lat') AS REAL) AS latitude,
    cast(json_extract(race.value, '$.Circuit.Location.long') AS REAL) AS longitude,
    json_extract(race.value, '$.Circuit.Location.locality') AS locality,
    json_extract(race.value, '$.Circuit.Location.country') AS country
FROM
    F1_JSON_DOCS,
    json_each(json_extract(F1_DOCUMENT, '$.MRData.RaceTable.Races')) AS race
WHERE DOC_TYPE = 7.0;

CREATE VIEW IF NOT EXISTS V_F1_SEASONS AS
SELECT
    cast(json_extract(season.value, '$.season') AS INT) AS season,
    json_extract(season.value, '$.url') AS season_url
FROM F1_JSON_DOCS,
    json_each(F1_DOCUMENT, '$.MRData.SeasonTable.Seasons') season
WHERE DOC_TYPE = 9.0;

CREATE VIEW IF NOT EXISTS V_F1_TRACKS AS
SELECT
    json_extract(value, '$.circuitId') AS circuitid,
    json_extract(value, '$.url') AS url,
    json_extract(value, '$.circuitName') AS circuitname,
    json_extract(value, '$.Location.lat') AS latitude,
    json_extract(value, '$.Location.long') AS longitude,
    json_extract(value, '$.Location.locality') AS locality,
    json_extract(value, '$.Location.country') AS country
FROM
    F1_JSON_DOCS,
    json_each(json_extract(F1_DOCUMENT, '$.MRData.CircuitTable.Circuits'))
WHERE DOC_TYPE = 11.0;

CREATE INDEX IF NOT EXISTS "F1_CONSTRUCTORSTANDINGS_IDX1" ON "F1_CONSTRUCTORSTANDINGS" (
	"SEASON",
	"ROUND"
);

CREATE INDEX IF NOT EXISTS "F1_DRIVERSTANDINGS_IDX1" ON "F1_DRIVERSTANDINGS" (
	"SEASON",
	"ROUND"
);

CREATE INDEX IF NOT EXISTS "F1_LAPTIMES_IDX1" ON "F1_LAPTIMES" (
	"SEASON",
	"ROUND"
);

CREATE INDEX IF NOT EXISTS "F1_QUALIFICATION_LAPS_IDX1" ON "F1_QUALIFICATION_LAPS" (
	"SEASON",
	"ROUND"
);

CREATE INDEX IF NOT EXISTS "F1_RACES_IDX1" ON "F1_RACES" (
	"SEASON",
	"ROUND"
);

CREATE INDEX IF NOT EXISTS "F1_RESULTS_IDX1" ON "F1_RACERESULTS" (
	"SEASON",
	"ROUND"
);

CREATE INDEX IF NOT EXISTS "IDX_F1_JSON_DOCS" ON "F1_JSON_DOCS" (
	"DOC_TYPE",
	"SEASON",
	"RACE",
	"LAPNUMBER"
);

DELETE FROM F1_CONSTRUCTORS;
INSERT INTO F1_CONSTRUCTORS SELECT * FROM V_F1_CONSTRUCTORS;

DELETE FROM F1_CONSTRUCTORSTANDINGS;
INSERT INTO F1_CONSTRUCTORSTANDINGS SELECT * FROM V_F1_CONSTRUCTORSTANDINGS;

DELETE FROM F1_DRIVERS;
INSERT INTO F1_DRIVERS SELECT * FROM V_F1_DRIVERS;

DELETE FROM F1_DRIVERSTANDINGS;
INSERT INTO F1_DRIVERSTANDINGS SELECT * FROM V_F1_DRIVERSTANDINGS;

DELETE FROM F1_LAPTIMES;
INSERT INTO F1_LAPTIMES SELECT * FROM V_F1_LAPTIMES;

DELETE FROM F1_QUALIFICATION_LAPS;
INSERT INTO F1_QUALIFICATION_LAPS SELECT * FROM V_F1_QUALIFICATIONTIMES;

DELETE FROM F1_RACERESULTS;
INSERT INTO F1_RACERESULTS SELECT * FROM V_F1_RACERESULTS;

DELETE FROM F1_RACES;
INSERT INTO F1_RACES SELECT * FROM V_F1_RACES;

DELETE FROM F1_SEASONS;
INSERT INTO F1_SEASONS SELECT * FROM V_F1_SEASONS;

DELETE FROM F1_TRACKS;
INSERT INTO F1_TRACKS SELECT * FROM V_F1_TRACKS;

COMMIT;
