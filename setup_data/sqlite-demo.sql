-- The last qualifying times for the 2025 season, round 4
SELECT   season
         , round as race
         , race_name
         , race_date
         , circuit_id
         , circuit_name
         , latitude
         , longitude
         , locality
         , country
         , driver_number
         , qualifying_position
         , qualifying_time
         , driver_id
         , driver_given_name
         , driver_family_name
         , driver_dob
         , driver_nationality
         , constructor_id
         , constructor_name
         , constructor_nationality
FROM F1_QUALIFICATIONTIMES
where season = 2025
  and round = 4
order by qualifying_position asc;

-- This SQL script calculates the fastest lap time for each driver in 2025 season, race 5, qualifying session.
-- It also formats the lap time and calculates the difference from the overall fastest lap time.
-- The script assumes the existence of a table named F1_OFFICIAL_TIMEDATA with relevant columns.

WITH laptime_ms_calculated AS (
    SELECT 
        SEASON,
        RACE,
        RACETYPE,
        DATAPOINT,
        TIME,
        DRIVER,
        DRIVERNUMBER,
        LAPTIME,
        (
            CAST(SUBSTR(LAPTIME, 1, 2) AS INTEGER) * 3600000 +   -- Hours to ms
            CAST(SUBSTR(LAPTIME, 4, 2) AS INTEGER) * 60000 +     -- Minutes to ms
            CAST(SUBSTR(LAPTIME, 7, 2) AS INTEGER) * 1000 +      -- Seconds to ms
            CAST(SUBSTR(LAPTIME, 10, 3) AS INTEGER)              -- Milliseconds
        ) AS LAPTIME_MS,
        LAPNUMBER
    FROM F1_OFFICIAL_TIMEDATA
    WHERE LAPTIME IS NOT NULL
),
fastest_lap_per_driver AS (
    SELECT 
        SEASON,
        RACE,
        RACETYPE,
        DRIVER,
        LAPTIME,
        LAPTIME_MS,
        LAPNUMBER
    FROM laptime_ms_calculated l1
    WHERE LAPTIME_MS = (
        SELECT MIN(LAPTIME_MS)
        FROM laptime_ms_calculated l2
        WHERE l1.DRIVER = l2.DRIVER
          AND l1.SEASON = l2.SEASON
          AND l1.RACE = l2.RACE
          AND l1.RACETYPE = l2.RACETYPE
    )
    AND SEASON = 2025
    AND RACE = 5
    AND RACETYPE = 'Q'
)
SELECT 
    f.SEASON,
    f.RACE,
    f.RACETYPE,
    f.DRIVER,
    --f.LAPTIME,
    --f.LAPTIME_MS,
    printf('%02d:%02d:%02d.%03d',
        f.LAPTIME_MS / 3600000,                                   -- Hours
        (f.LAPTIME_MS % 3600000) / 60000,                         -- Minutes
        (f.LAPTIME_MS % 60000) / 1000,                            -- Seconds
        f.LAPTIME_MS % 1000                                       -- Milliseconds
    ) AS FORMATTED_LAPTIME,
    printf('%02d:%02d:%02d.%03d',
        (f.LAPTIME_MS - overall_fastest.LAPTIME_MS) / 3600000,    -- Hours
        ((f.LAPTIME_MS - overall_fastest.LAPTIME_MS) % 3600000) / 60000, -- Minutes
        ((f.LAPTIME_MS - overall_fastest.LAPTIME_MS) % 60000) / 1000,    -- Seconds
        (f.LAPTIME_MS - overall_fastest.LAPTIME_MS) % 1000        -- Milliseconds
    ) AS TIME_DIFF
FROM fastest_lap_per_driver f
LEFT JOIN (
    SELECT MIN(LAPTIME_MS) AS LAPTIME_MS
    FROM fastest_lap_per_driver
) overall_fastest
ON 1 = 1 -- Join to calculate the difference with the fastest lap overall
ORDER BY f.LAPTIME_MS ASC;

