/*
Run this script as F1_LOGIK after inserting data into the oracle database from the f1.sqlite datbase
using the provided python script f1_json_oracle.py
*/

    delete from f1_data.f1_laptimes;
    delete from f1_data.f1_qualificationtimes;
    delete from f1_data.f1_results;
    delete from f1_data.f1_season;
    delete from f1_data.f1_constructorstandings;
    delete from f1_data.f1_constructors;
    delete from f1_data.f1_driverstandings;
    delete from f1_data.f1_drivers;
    delete from f1_data.f1_races;
    delete from f1_data.f1_tracks;

    insert into f1_data.f1_season
    select *
    from f1_data.v_f1_season;
    commit;

    insert into f1_data.f1_constructors select * from f1_data.V_F1_CONSTRUCTORS;
    commit;

    insert into f1_data.f1_constructorstandings
    select season,
           race,
           position,
           positiontext,
           points,
           wins,
           constructorid
    from f1_data.v_f1_constructorstandings;
    commit;

    insert into f1_data.f1_drivers
    select  trim(driverid) driverid
            ,permanentNumber
            ,code
            ,info
            ,givenname
            ,familyname
            ,dateofbirth
            ,nationality
    from f1_data.v_f1_drivers;
    commit;

    insert into f1_data.f1_driverstandings
    select season,
           race,
           position,
           positiontext,
           points,
           wins,
           trim(driverid) driverid,
           constructorid
    from f1_data.v_f1_driverstandings;
    commit;

    insert into f1_data.f1_tracks 
    select circuitid,
           info,
           circuitname,
           to_number(lat,'9999.999999','nls_numeric_characters=''.,''') as lat,
           to_number(longitud,'9999.999999','nls_numeric_characters=''.,''') as longitud,
           locality,
           country
    from f1_data.v_f1_tracks;
    commit;

    insert into f1_data.f1_races
    select season,
           round,
           info,
           racename,
           circuitid
    from f1_data.v_f1_races;
    commit;

    insert into f1_data.f1_results
    select season,
           race,
           info,
           racename,
           circuitid,
           racedate,
           pilotnr,
           position,
           positiontext,
           points,
           trim(driverid) driverid,
           constructorid,
           grid,
           laps,
           status,
           ranking,
           fastestlap,
           units,
           speed,
           millis,
           racetime
    from f1_data.v_f1_results;
    commit;

    insert into f1_data.f1_qualificationtimes
    select season,
           round,
           racedate,
           racetime,
           position,
           trim(driverid) driverid,
           constructor as constructorid,
           q1,
           q2,
           q3
    from f1_data.v_f1_qualificationtimes
    where position is not null;
    commit;

    insert into f1_data.f1_laptimes
    select season,
           round,
           race_date,
           race_time,
           lap_number,
           trim(driverid) driverid,
           position,
           laptime
    from f1_data.v_f1_laptimes;
    commit;

-- Count up the sequence counter in Oracle so that we end up in trouble later
DECLARE
  l_seq_currval number;
  l_seq_updateval number;
  l_temp number;

BEGIN

   select f1_staging.f1_staging_seq.nextval into l_seq_currval;
   dbms_output.put_line(to_char(l_seq_currval));

   select max(doc_id) into l_seq_updateval from f1_staging.F1_JSON_DOCS; 
   dbms_output.put_line(to_char(l_seq_updateval));
   
   for x in l_seq_currval..l_seq_updateval loop
     select f1_staging.f1_staging_seq.nextval into l_temp from dual; 
   end loop;
   
   dbms_output.put_line('Updated sequence to correct value: '||to_char(l_temp));
END;
/

    