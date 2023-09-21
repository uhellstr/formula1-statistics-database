
  CREATE OR REPLACE EDITIONABLE FUNCTION "F1_LOGIK"."MILLIS_TO_LAPTIME" 
(
    p_in_milliseconds in number
) return varchar2 is

    lv_hours number;
    lv_minutes number;
    lv_seconds number;
    lv_milliseconds number;
    lv_retval varchar2(15);
    lv_fmt_millis varchar2(6);

begin
  if p_in_milliseconds is not null then

    -- calculate laptime components
    lv_hours := floor(p_in_milliseconds / 3600000);      -- divide by 3600000 to get hours
    lv_minutes := floor((p_in_milliseconds - (lv_hours * 3600000)) / 60000);   -- subtract hours and divide by 60000 to get minutes
    lv_seconds := floor((p_in_milliseconds - (lv_hours * 3600000) - (lv_minutes * 60000)) / 1000);   -- subtract hours and minutes and divide by 1000 to get seconds
    lv_milliseconds := p_in_milliseconds - (lv_hours * 3600000) - (lv_minutes * 60000) - (lv_seconds * 1000);   -- subtract hours, minutes, and seconds to get remaining milliseconds

    lv_fmt_millis := case 
                     when lv_milliseconds between 0 and 99 then
                        rpad(lpad(to_char(lv_milliseconds),3,'0'),6,0)
                     else
                        rpad(to_char(lv_milliseconds), 6, '0')
                     end;

    -- format laptime into hh:mi:ss.ff
    lv_retval := lpad(to_char(lv_hours), 2, '0') || ':' ||
                 lpad(to_char(lv_minutes), 2, '0') || ':' ||
                 lpad(to_char(lv_seconds), 2, '0') || '.' ||
                 lv_fmt_millis;
  else
    lv_retval := null;
  end if;

  return lv_retval;

end;