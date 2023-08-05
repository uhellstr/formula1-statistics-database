
  CREATE OR REPLACE EDITIONABLE FUNCTION "F1_LOGIK"."GET_CHECK_SEASON" 
(
  p_in_cur_year in varchar2 default to_char(current_date,'rrrr') 
) 
return varchar2 result_cache
as

 lv_retval varchar2(4);

begin

    select season into lv_retval -- Is current season finished yet?
    from
    (
     select to_date(r.race_date,'RRRR-MM-DD') as race_date
            ,case 
               when r.race_date < trunc(sysdate) then to_char(current_date,'RRRR')
               when r.race_date > trunc(sysdate) then to_char(to_number(to_char(current_date,'RRRR') - 1))
               else '1900'
             end as season
     from f1_data.v_f1_seasons_race_dates r
     where r.season = p_in_cur_year
       and to_number(r.round) in (select max(to_number(rd.round)) from f1_data.v_f1_seasons_race_dates rd
                                  where rd.season  = r.season)
    );
  return lv_retval;

end get_check_season;