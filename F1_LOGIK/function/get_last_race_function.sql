CREATE OR REPLACE EDITIONABLE FUNCTION "GET_LAST_RACE" 
(
  p_in_cur_year in varchar2 default to_char(current_date,'rrrr') 
) return number result_cache 
as 

  lv_retval number;

begin

    with last_race as -- we need to check if any upcoming races or if the last race for the season is done.
    (
    select /*+ MATERIALIZE */  nvl(min(to_number(x.round)-1),-1) as race -- check if any upcoming races this seaseon -1 and season is done
    from f1_data.v_f1_upcoming_races x
    where x.season = p_in_cur_year
    )
    select case when race = -1 then (select max(to_number(y.round))
                                   from  f1_data.v_f1_races y
                                   where y.season = to_char(to_number(p_in_cur_year)-1))
          else race
          end race
          into lv_retval
          from last_race;

   return lv_retval;

end get_last_race;
/