
  CREATE OR REPLACE EDITIONABLE FUNCTION "F1_LOGIK"."GET_CUR_F1_SEASON" 
(
  p_in_cur_year in varchar2 default to_char(current_date,'RRRR') 
) 
return varchar2 result_cache
as 

 lv_season varchar2(4);
 lv_races  pls_integer;

begin

  with numb_races as -- check if between seasons where season is finished.
      (
        select /*+ MATERIALIZE */ count(vfr.round) as number_of_races
        from f1_data.v_f1_races vfr
        where vfr.season = p_in_cur_year
      )
  ,upc_races as
      (
        select /*+ MATERIALIZE */ count(vfu.round) as upcoming_races
        from f1_data.v_f1_upcoming_races vfu
        where vfu.season = p_in_cur_year
      ) 
  select case
             when x.number_of_races - y.upcoming_races = x.number_of_races then 0
             else 1
         end as races_done
  into lv_races
  from numb_races x
       ,upc_races y;

  with future_races as -- We need to handle between seasons where there are no races
    (
      select /*+ MATERIALIZE */ count(vfu.season) as any_races
      from f1_data.v_f1_upcoming_races vfu
      where vfu.season = substr(to_char(trunc(sysdate,'YEAR')),1,4)  --Fix to YEAR and substr(1,4) to garantee that we only get the YEAR part
    )
    select season into lv_season -- Is current season finished yet?
    from
    (
     select to_date(r.race_date,'RRRR-MM-DD') as race_date
            ,case
               when (r.race_date < trunc(sysdate) and x.any_races = 0 and lv_races = 0 and to_char(to_number(to_char(current_date,'RRRR'))) = p_in_cur_year) then to_char(to_number(to_char(current_date,'RRRR'))) -- season finished but same year 
               when (r.race_date < trunc(sysdate) and x.any_races < 1) then to_char(to_number(to_char(current_date,'RRRR') - 1)) -- season finished but next years season has not yet started
               when r.race_date < trunc(sysdate) then to_char(current_date,'RRRR')
               when (r.race_date > trunc(sysdate) and x.any_races > 0) then to_char(current_date,'RRRR')
               else '1900'
             end as season
     from f1_data.v_f1_seasons_race_dates r
          ,future_races x
     where r.season = p_in_cur_year
       and to_number(r.round) in (select max(to_number(rd.round)) from f1_data.v_f1_seasons_race_dates rd
                                  where rd.season  = r.season)
  );

  return lv_season;

end get_cur_f1_season;