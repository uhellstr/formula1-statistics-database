CREATE OR REPLACE EDITIONABLE PACKAGE BODY "F1_INIT_PKG" 
as

  --%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
  function return_race_date
             (
               p_in_season in varchar2
               ,p_in_round in number
             ) return date
  --%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  -- Function: return_race_date
  -- API: Private not published outside body
  -- Purpose: Return the race date for a specific race in a season in date format.
  -- Author: Ulf Hellstrom, oraminute@gmail.com
  --%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%             
  is 
   lv_retval date;
  begin

    select race_date into lv_retval
    from f1_data.v_f1_seasons_race_dates
    where season = p_in_season
     and round = p_in_round;

    return lv_retval;

  end return_race_date;

  --%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  function ret_next_race_in_cur_season
  return number result_cache
  --%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  -- Function: ret_next_race_in_cur_season
  -- API: Private not published outside body
  -- Purpose: Return the next upcoming race in current season. If no races are left then return 0
  -- Author: Ulf Hellstrom, oraminute@gmail.com
  --%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  as
    lv_retval number;
    lv_last_race number;

  begin

    select round into lv_retval
    from
    (
      select to_number(round) as round
      from f1_data.v_f1_upcoming_races
      --where to_date(race_date,'YYYY-MM-DD') > trunc(sysdate)
      order by to_number(round)
    ) where rownum < 2;


    return lv_retval;

  -- Season my have ended
  exception
    when no_data_found then
       return 0;

  end ret_next_race_in_cur_season;

  --%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  procedure fetch_json_in_chunks
              (
                p_i_url in varchar2
                ,p_i_doc_type in number
                ,p_i_season in number default null
                ,p_i_race in number default null
                ,p_i_lapnumber in number default null
                ,p_i_racetype in number default null
              )
  --%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  -- Procedure: fetch_json_in_chunks
  -- API: Private not published outside body
  -- Purpose: Helper function fetching json docs in chunckks of max 100 rows
  -- Author: Ulf Hellstrom, oraminute@gmail.com
  --%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%               
  is

    l_json_doc        clob;
    l_limit           pls_integer := 100;
    l_offset          pls_integer := 0;
    l_total           pls_integer;
    b_fetch_more      boolean := true;
    l_base_url        varchar2(500) := p_i_url||'?limit=';
    l_url             clob;

  begin

    --dbms_output.put_line('first fetch url: '||l_url);

    --
    -- First pass we need to get tags for total number of
    -- rows to fetch. Converting to relation unsing json_table()
    --
    l_json_doc := apex_web_service.make_rest_request
        (
          p_url => l_base_url||to_char(l_limit),
          p_http_method => 'GET'
        );

    select jt.limit
          , jt.offset
          , jt.total
    into l_limit
          , l_offset
          , l_total    
    from 
    json_table(
        l_json_doc, 
        '$.MRData' 
        columns (
            limit  VARCHAR2(10) PATH '$.limit',
            offset VARCHAR2(10) PATH '$.offset',
            total  VARCHAR2(10) PATH '$.total'
        )
    ) jt;

    insert into f1_staging.f1_json_docs(
        doc_id
        ,doc_type
        ,date_loaded
        ,season
        ,race
        ,lapnumber
        ,racetype
        ,f1_document
      ) values
      (  
       f1_staging.f1_staging_seq.nextval
       ,p_i_doc_type
       ,systimestamp
       ,p_i_season
       ,p_i_race
       ,p_i_lapnumber
       ,p_i_racetype
       ,l_json_doc
    );
    commit;

    -- calculating the offset for fetcthing more rows.
    l_offset := (l_offset + l_limit);
    --dbms_output.put_line(to_char(l_offset)||' after first fetch!');

    -- If less or equal to 100 rows to fetch then we are finished.
    if l_total <= 100 then
      b_fetch_more := false;
    end if;

    -- loop and fetch chunks of document until finished.
    while (b_fetch_more = true) loop  -- Bug here!

      if ((l_offset < l_total) and ((l_total - l_offset) >= 100)) then
        l_url := l_base_url||to_char(l_limit)||'&offset='||to_char(l_offset);
      else
        l_limit := (l_total - l_offset);
        l_url := l_base_url||to_char(l_limit)||'&offset='||to_char(l_offset);
        b_fetch_more := false;
      end if;

      --dbms_output.put_line(l_url);
      --dbms_output.put_line(l_limit||','||l_offset||','||l_total);

      l_json_doc := apex_web_service.make_rest_request
        (
          p_url => l_url,
          p_http_method => 'GET'
        );

      insert into f1_staging.f1_json_docs(
        doc_id
        ,doc_type
        ,date_loaded
        ,season
        ,race
        ,lapnumber
        ,racetype
        ,f1_document
      ) values
      (  
       f1_staging.f1_staging_seq.nextval
       ,p_i_doc_type
       ,systimestamp
       ,p_i_season
       ,p_i_race
       ,p_i_lapnumber
       ,p_i_racetype
       ,l_json_doc
      );
      commit;

      if l_total - l_offset < 100 then
        l_limit := l_total - l_offset;
      end if;

      l_offset := (l_offset + l_limit);
      
      -- need to handling throttle - max 4 requests per second.
      dbms_session.sleep(0.5);
      --dbms_output.put_line('offset,limit and total in loop '||to_char(l_offset)||','||l_limit||','||l_total);

    end loop; -- while true

  end fetch_json_in_chunks;

  --%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  procedure load_f1_seasons
  is
  --%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  -- Procedure: Load all years that F1 has done races
  -- API: Private not published outside body
  -- Purpose: Fetch data about all seasons that F1 has done races.
  -- Author: Ulf Hellstrom, oraminute@gmail.com
  --%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  begin
    -- To try it out, simply replace ergast.com/api/f1/ with api.jolpi.ca/ergast/f1/
    -- Only one JSON document fetched so we reload it every time.
    delete from f1_staging.f1_json_docs where doc_type = 9;

    fetch_json_in_chunks
              (
                p_i_url => 'http://api.jolpi.ca/ergast/f1/seasons.json'
                ,p_i_doc_type => 9
                ,p_i_season => null
                ,p_i_race => null
                ,p_i_lapnumber => null
                ,p_i_racetype => null
              );

  end load_f1_seasons;

  --%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  procedure load_f1_drivers
  is
  --%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  -- Procedure: load_f1_drivers
  -- API: Private not published outside body
  -- Purpose: Fetch all F1 drivers thru the history from ergast.com and save it in JSON format.
  -- Author: Ulf Hellstrom, oraminute@gmail.com
  --%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  begin

    delete from f1_staging.f1_json_docs where doc_type = 3;

    fetch_json_in_chunks
              (
                p_i_url => 'http://api.jolpi.ca/ergast/f1/drivers.json'
                ,p_i_doc_type => 3
                ,p_i_season => null
                ,p_i_race => null
                ,p_i_lapnumber => null
                ,p_i_racetype => null
              );    
 
  end load_f1_drivers;

  --%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  procedure load_f1_tracks
  is
  --%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  -- Procedure: load_f1_tracks
  -- API: Private not published outside body
  -- Purpose: Fetch all F1 tracks ever raced on from ergast.com and save in JSON format.
  -- Author: Ulf Hellstrom, oraminute@gmail.com
  --%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  begin

    delete from f1_staging.f1_json_docs where doc_type = 11;

    fetch_json_in_chunks
              (
                p_i_url => 'http://api.jolpi.ca/ergast/f1/circuits.json'
                ,p_i_doc_type => 11
                ,p_i_season => null
                ,p_i_race => null
                ,p_i_lapnumber => null
                ,p_i_racetype => null
              );    

  end load_f1_tracks;

  --%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  procedure load_f1_races
  --%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  -- Procedure: load_f1_races
  -- API: Private not published outside body
  -- Purpose: Fetch all historic and for current season planned F1 races from ergast.com and save in JSON format.
  -- Author: Ulf Hellstrom, oraminute@gmail.com
  --%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  is

    url clob := 'http://api.jolpi.ca/ergast/f1/{YEAR}.json';
    calling_url clob;

    cursor cur_get_season_year is
    select f1.season
    from f1_data.v_f1_season f1;

    --inline
    procedure get_races(
      p_in_year in number,
      p_in_url in clob
    )
    is

      lv_count number;

    begin

      -- check if year is already loaded, if then skip
      select count(season) into lv_count
      from f1_staging.f1_json_docs
      where season = p_in_year 
        and doc_type = 7;

      if lv_count = 0 then

        fetch_json_in_chunks
            (
              p_i_url => p_in_url
              ,p_i_doc_type => 7
              ,p_i_season => p_in_year
              ,p_i_race => null
              ,p_i_lapnumber => null
              ,p_i_racetype => null
            );
        
      end if;

    end get_races;

  begin

    for rec in cur_get_season_year loop
      calling_url := replace(url,'{YEAR}',rec.season);
      get_races(rec.season,calling_url);
    end loop;

  end load_f1_races;

  --%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  procedure load_f1_raceresults
  --%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  -- Procedure: load_f1_raceresults
  -- API: Private not published outside body
  -- Purpose: Fetch all the results of all historic F1 races and save it in JSON format.
  -- Author: Ulf Hellstrom, oraminute@gmail.com
  --%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  is

    url clob := 'http://api.jolpi.ca/ergast/f1/{YEAR}/{ROUND}/results.json';
    tmp clob;
    calling_url clob;
    lv_next_round_nr number;
    lv_max_round number;
    last_season_race_date date;

    cursor cur_get_f1_races is
    select season as season
           ,round as race
    from f1_data.v_f1_seasons_race_dates;

    -- inline
    procedure insert_results
       (
         p_in_year in number
         ,p_in_round in number
         ,p_in_url in clob
        )
    is

      lv_count number;

    begin

      select count(season) into lv_count
      from f1_staging.f1_json_docs
      where season = p_in_year
        and race = p_in_round
        and doc_type = 8;

      if lv_count = 0 then

        fetch_json_in_chunks
            (
              p_i_url => p_in_url
              ,p_i_doc_type => 8
              ,p_i_season => p_in_year
              ,p_i_race => p_in_round
              ,p_i_lapnumber => null
              ,p_i_racetype => null
            );

      end if;

  end insert_results;

  begin

      for rec in cur_get_f1_races loop

        -- check that we have a race that has finished before trying to load results
        if  return_race_date(
               p_in_season => rec.season
               ,p_in_round => rec.race) <= trunc(sysdate-2) 
        then
          tmp := replace(url,'{YEAR}',rec.season);
          calling_url := replace(tmp,'{ROUND}',rec.race);
          insert_results(rec.season,rec.race,calling_url);
        end if;
      end loop;

  end load_f1_raceresults;

  --%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  procedure load_f1_constructors
  is
  --%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  -- Procedure: load_f1_constructors
  -- API: Private not published outside body
  -- Purpose: Fetch all F1 constructors ever raced on from ergast.com and save in JSON format.
  -- Author: Ulf Hellstrom, oraminute@gmail.com
  --%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  begin

    delete from f1_staging.f1_json_docs where doc_type = 1;

    fetch_json_in_chunks
              (
                p_i_url => 'http://api.jolpi.ca/ergast/f1/constructors.json'
                ,p_i_doc_type => 1
                ,p_i_season => null
                ,p_i_race => null
                ,p_i_lapnumber => null
                ,p_i_racetype => null
              );      

  end load_f1_constructors;

  --%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  procedure load_f1_driverstandings
  --%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  -- Procedure: load_f1_driverstandings
  -- API: Private not published outside body
  -- Purpose: Fetch the last restults in points for all drivers for historic and current season and save in JSON format
  -- Author: Ulf Hellstrom, oraminute@gmail.com
  --%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  is
    url clob := 'http://api.jolpi.ca/ergast/f1/{YEAR}/driverStandings.json';
    calling_url clob;

    cursor cur_get_f1_seasons is
    select season
    from f1_data.v_f1_season;

    -- inline
    procedure insert_results
       (
         p_in_year in number
         ,p_in_url in clob
        )
    is
     lv_count number;
    begin

     -- Reload current years driverstandings since it will be updated until end of season.
     if p_in_year = to_number(to_char(trunc(sysdate),'RRRR')) then
       lv_count := 0;
       delete from f1_staging.f1_json_docs 
       where doc_type = 4 
         and season = to_number(to_char(trunc(sysdate),'RRRR'));
     else
       -- check if results for year already loaded. if then skip to load it.
       select count(season) into lv_count
       from f1_staging.f1_json_docs
       where doc_type = 4
         and season = p_in_year;
     end if;

     if lv_count = 0 then

        fetch_json_in_chunks
            (
              p_i_url => p_in_url
              ,p_i_doc_type => 4
              ,p_i_season => p_in_year
              ,p_i_race => null
              ,p_i_lapnumber => null
              ,p_i_racetype => null
            );
       
     end if;
    end insert_results;

  begin
    for rec in cur_get_f1_seasons loop
      calling_url := replace(url,'{YEAR}',rec.season);
      --dbms_output.put_line(calling_url);
      insert_results(rec.season,calling_url);
    end loop;
  end load_f1_driverstandings;

  --%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  procedure load_f1_constructorstandings
  --%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  -- Procedure: load_f1_constructorstandings
  -- API: Private not published outside body
  -- Purpose: Fetch all F1 historic and current seasons last or final result from ergast.com and save in JSON format.
  -- Author: Ulf Hellstrom, oraminute@gmail.com
  --%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  is
    url clob := 'http://api.jolpi.ca/ergast/f1/{YEAR}/constructorStandings.json';
    calling_url clob;

    cursor cur_get_f1_seasons is
    select to_number(season) as season
    from f1_data.v_f1_season;

    -- inline
    procedure insert_results
       (
         p_in_year in number
         ,p_in_url in clob
        )
    is
      lv_count number;
    begin

     -- Reload current years constructortandings since the update until end of season.
     if p_in_year = to_number(to_char(trunc(sysdate),'RRRR')) then
       lv_count := 0;
       delete from f1_staging.f1_json_docs 
       where doc_type = 2
         and season = to_number(to_char(trunc(sysdate),'RRRR'));
     else
       -- check if results for year already loaded. if then skip to load it.
       select count(season) into lv_count
       from f1_staging.f1_json_docs
       where doc_type = 2
         and season = p_in_year;
     end if;

     if lv_count = 0 then

        fetch_json_in_chunks
            (
              p_i_url => p_in_url
              ,p_i_doc_type => 2
              ,p_i_season => p_in_year
              ,p_i_race => null
              ,p_i_lapnumber => null
              ,p_i_racetype => null
            );

     end if;
    end insert_results;

  begin
    for rec in cur_get_f1_seasons loop
      calling_url := replace(url,'{YEAR}',rec.season);
      insert_results(rec.season,calling_url);
    end loop;
  end load_f1_constructorstandings;

  --%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  procedure load_f1_seasons_racedates
  --%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  -- Procedure: load_f1_tracks
  -- API: Private not published outside body
  -- Purpose: Fetch all racedats for historic and current season ever raced from ergast.com and save in JSON format.
  -- Author: Ulf Hellstrom, oraminute@gmail.com
  --%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  is

    url clob := 'http://api.jolpi.ca/ergast/f1/{YEAR}.json';
    calling_url clob;

    cursor cur_get_f1_seasons is
    select season 
    from f1_data.v_f1_season;

    -- inline
    procedure insert_results
       (
         p_in_year in number
         ,p_in_url in clob
        )
    is
      lv_count number;
    begin

    -- check if racedates already loaded , if then skip
     select count(season) into lv_count
     from f1_staging.f1_json_docs
     where doc_type = 10
       and season = p_in_year;

     if lv_count = 0 then

        fetch_json_in_chunks
            (
              p_i_url => p_in_url
              ,p_i_doc_type => 10
              ,p_i_season => p_in_year
              ,p_i_race => null
              ,p_i_lapnumber => null
              ,p_i_racetype => null
            );

     end if;
    end insert_results;

  begin

    for rec in cur_get_f1_seasons loop
      calling_url := replace(url,'{YEAR}',rec.season);
      insert_results(rec.season,calling_url);
    end loop;

  end load_f1_seasons_racedates;

  --%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  procedure load_f1_qualitimes
  --%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  -- Procedure: load_f1_qualitimes (Heavylifter)
  -- API: Private not published outside body
  -- Purpose: Fetch all F1 qualitimes historicly from 1994 and forward and store in JSON format
  -- Author: Ulf Hellstrom, oraminute@gmail.com
  --%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  is

    url clob := 'http://api.jolpi.ca/ergast/f1/{YEAR}/{ROUND}/qualifying.json';
    calling_url clob;
    tmp_url clob;
    lv_number_of_races number;
    lv_next_round_nr number;

    cursor cur_get_season_year is
    select season 
    from f1_data.v_f1_season
    where season > 1993;

    -- inline
    procedure get_qualitimes
    (
        p_in_year in number
        ,p_in_round in number
        ,p_in_url clob
    )
    is

      lv_count number;

    begin

      -- check if racedates already loaded , if then skip
      select count(season) into lv_count
      from f1_staging.f1_json_docs
      where doc_type = 6
        and season = p_in_year
        and race = p_in_round;

     if lv_count = 0 then

        fetch_json_in_chunks
            (
              p_i_url => p_in_url
              ,p_i_doc_type => 6
              ,p_i_season => p_in_year
              ,p_i_race => p_in_round
              ,p_i_lapnumber => null
              ,p_i_racetype => null
            );

     end if;

    end get_qualitimes;

  begin


   for rec in cur_get_season_year loop

      -- Special handling for current season since not all races are done yeat

     select max(round) into lv_number_of_races
     from f1_data.v_f1_races
     where season = rec.season;

     if lv_number_of_races > 0 then

        for i in 1..lv_number_of_races loop

          -- Is the race finished ?
          if return_race_date(
               p_in_season => rec.season
               ,p_in_round => i) <= trunc(sysdate-2) -- Let there be some time for ergast to update 
          then
            tmp_url := replace(url,'{YEAR}',rec.season);
            calling_url := replace(tmp_url,'{ROUND}',i);
            get_qualitimes(rec.season,i,calling_url);
          end if;

        end loop; -- round in season

     end if; -- Has the season started yeat?

   end loop;

  end load_f1_qualitimes;

  --%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  procedure load_f1_laptimes
  --%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  -- Procedure: load_f1_laptimes (Heavylifter)
  -- API: Private not published outside body
  -- Purpose: Fetch all F1 laptimes historicly from 1996 and forward and store in JSON format
  -- Author: Ulf Hellstrom, oraminute@gmail.com
  --%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  is
  
  /*
    Are you making calls similar to these?
        /ergast/f1/2024/17/laps/35.json?offset=0&limit=100
        /ergast/f1/2024/17/laps/36.json?offset=0&limit=100

        If so I'd recommend removing the filter at the end and use paging instead.
        e.g. instead of api.jolpi.ca/ergast/f1/2024/17/laps/9.json from 1-70 (or however many laps).
        Do api.jolpi.ca/ergast/f1/2024/17/laps.json?limit=100?offset=0 for offset of 0,100,etc
  */
    url clob := 'http://api.jolpi.ca/ergast/f1/{YEAR}/{ROUND}/laps/{LAP}.json';
    --url clob := 'http://api.jolpi.ca/ergast/f1/{YEAR}/{ROUND}/laps.json';
    calling_url clob;
    tmp_url clob;
    tmp1_url clob;
    lv_number_of_races number;
    lv_number_of_laps number;
    lv_next_round_nr number;

    cursor cur_get_season_year is
    select to_number(season) as season
    from f1_data.v_f1_season
    where to_number(season) > 1995
      and to_number(season) <= to_number(trunc(to_char(sysdate,'RRRR')));

    --inline
    procedure get_laps(
        p_in_year in number,
        p_in_round in number,
        p_in_lap in number,
        p_in_url clob
    )
    is

      lv_count number;

    begin

      select count(lapnumber) into lv_count
      from f1_staging.f1_json_docs
      where doc_type = 5
        and season  = p_in_year
        and race = p_in_round
        and lapnumber = p_in_lap;

      if lv_count = 0 then

        fetch_json_in_chunks
            (
              p_i_url => p_in_url
              ,p_i_doc_type => 5
              ,p_i_season => p_in_year
              ,p_i_race => p_in_round
              ,p_i_lapnumber => p_in_lap
              ,p_i_racetype => 3
            );

      end if;
     end get_laps;

  begin

    for rec in cur_get_season_year loop

      -- Special handling for current season since not all races are done yeat

      select max(to_number(round)) into lv_number_of_races
      from f1_data.v_f1_races
      where season = rec.season;

      if lv_number_of_races > 0 then

        for i in 1..lv_number_of_races loop

          begin

            select to_number(laps)
            into lv_number_of_laps
            from f1_data.v_f1_results
            where to_number(position) = 1
              and to_number(season) = rec.season
              and to_number(race) = i;

               -- In current season do not try to load races not yet raced!
            if return_race_date
                   (
                     p_in_season => rec.season
                    ,p_in_round => i) <= trunc(sysdate-2) -- Let there be some time for Ergast to update
            then 
              for j in 1..lv_number_of_laps loop
                  tmp_url := replace(url,'{YEAR}',rec.season);
                  tmp1_url := replace(tmp_url,'{ROUND}',i);
                  calling_url := replace(tmp1_url,'{LAP}',j);
                  get_laps(rec.season,i,j,calling_url);
              end loop;
            end if;  
          exception -- special handling if runned same date as race is and no data loaded on ergast.com yet!
             when no_data_found then
                delete from f1_staging.f1_json_docs
                where season = rec.season
                  and race = i
                  and doc_type = 5;
                  commit;
          end;  

        end loop;
      end if; -- lv_number_of_races 
    end loop; -- cursor

  end load_f1_laptimes;

  --%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  procedure reset_all_data 
  is
  begin
    delete from f1_staging.f1_json_docs;
    commit;
  end reset_all_data;

  --%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  procedure reset_race
             (
               p_in_season in number
               ,p_in_race in number
             )
  is
  begin
   -- TODO
   null;
  end reset_race;

  --%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  procedure load_f1_data
  is
  begin

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
           to_number(lat,'9999.9999999999999999','nls_numeric_characters=''.,''') as lat,
           to_number(longitud,'9999.9999999999999999','nls_numeric_characters=''.,''') as longitud,
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

  end load_f1_data;

  --%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  -- main published API starts here.
  --%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  procedure load_json as
  begin
    load_f1_seasons;
    load_f1_seasons_racedates;
    load_f1_drivers;
    load_f1_tracks;
    load_f1_races;  
    load_f1_raceresults;
    load_f1_constructors;
    load_f1_driverstandings;
    load_f1_constructorstandings;
    load_f1_qualitimes;
    load_f1_laptimes;
    load_f1_data;
  end load_json;

  procedure load_race
             (
               p_in_season in number
               ,p_in_race in number
             )
 is
 begin

   reset_race
             (
               p_in_season => p_in_season
               ,p_in_race => p_in_race
             );

 end load_race;

end f1_init_pkg;
/