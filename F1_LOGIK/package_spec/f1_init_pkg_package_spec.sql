
  CREATE OR REPLACE EDITIONABLE PACKAGE "F1_LOGIK"."F1_INIT_PKG" as

  procedure load_json;
  procedure load_race
             (
               p_in_season in number
               ,p_in_race in number
             );
  procedure reset_all_data;
  function ret_next_race_in_cur_season return number result_cache;

end f1_init_pkg;