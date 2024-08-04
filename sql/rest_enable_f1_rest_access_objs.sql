DECLARE
  PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN

    ORDS.ENABLE_OBJECT(p_enabled => TRUE,
                       p_schema => 'F1_REST_ACCESS',
                       p_object => 'V_F1_CONSTRUCTORS',
                       p_object_type => 'VIEW',
                       p_object_alias => 'f1_constructors',
                       p_auto_rest_auth => FALSE);

    commit;
    
    ORDS.ENABLE_OBJECT(p_enabled => TRUE,
                       p_schema => 'F1_REST_ACCESS',
                       p_object => 'V_F1_CONSTRUCTORSTANDINGS',
                       p_object_type => 'VIEW',
                       p_object_alias => 'f1_constructorstandings',
                       p_auto_rest_auth => FALSE);

    commit;    
    
    ORDS.ENABLE_OBJECT(p_enabled => TRUE,
                       p_schema => 'F1_REST_ACCESS',
                       p_object => 'V_F1_CUR_SEASON_STANDINGS',
                       p_object_type => 'VIEW',
                       p_object_alias => 'f1_season_standings',
                       p_auto_rest_auth => FALSE);

    commit;    

    ORDS.ENABLE_OBJECT(p_enabled => TRUE,
                       p_schema => 'F1_REST_ACCESS',
                       p_object => 'V_F1_DRIVERS',
                       p_object_type => 'VIEW',
                       p_object_alias => 'f1_drivers',
                       p_auto_rest_auth => FALSE);

    commit;
    
    ORDS.ENABLE_OBJECT(p_enabled => TRUE,
                       p_schema => 'F1_REST_ACCESS',
                       p_object => 'V_F1_DRIVERSTANDINGS',
                       p_object_type => 'VIEW',
                       p_object_alias => 'f1_driverstandings',
                       p_auto_rest_auth => FALSE);

    commit;
    
    ORDS.ENABLE_OBJECT(p_enabled => TRUE,
                       p_schema => 'F1_REST_ACCESS',
                       p_object => 'V_F1_LAPTIMES',
                       p_object_type => 'VIEW',
                       p_object_alias => 'f1_laptimes',
                       p_auto_rest_auth => FALSE);

    commit;    
    
     ORDS.ENABLE_OBJECT(p_enabled => TRUE,
                       p_schema => 'F1_REST_ACCESS',
                       p_object => 'V_F1_LAST_RACE_QUALIFIERS',
                       p_object_type => 'VIEW',
                       p_object_alias => 'f1_last_race_qualifiers',
                       p_auto_rest_auth => FALSE);

    commit;
    
    ORDS.ENABLE_OBJECT(p_enabled => TRUE,
                       p_schema => 'F1_REST_ACCESS',
                       p_object => 'V_F1_LAST_RACE_RESULTS',
                       p_object_type => 'VIEW',
                       p_object_alias => 'f1_last_race_result',
                       p_auto_rest_auth => FALSE);

    commit;

    ORDS.ENABLE_OBJECT(p_enabled => TRUE,
                       p_schema => 'F1_REST_ACCESS',
                       p_object => 'V_F1_LAST_RACE_WINNERS',
                       p_object_type => 'VIEW',
                       p_object_alias => 'f1_last_race_winner',
                       p_auto_rest_auth => FALSE);

    commit;
    
    ORDS.ENABLE_OBJECT(p_enabled => TRUE,
                       p_schema => 'F1_REST_ACCESS',
                       p_object => 'V_F1_OFFICIAL_TIMEDATA',
                       p_object_type => 'VIEW',
                       p_object_alias => 'f1_laptime_data',
                       p_auto_rest_auth => FALSE);

    commit;
    
    ORDS.ENABLE_OBJECT(p_enabled => TRUE,
                       p_schema => 'F1_REST_ACCESS',
                       p_object => 'V_F1_OFFICIAL_WEATHER',
                       p_object_type => 'VIEW',
                       p_object_alias => 'f1_weather_data',
                       p_auto_rest_auth => FALSE);

    commit;
    
    ORDS.ENABLE_OBJECT(p_enabled => TRUE,
                       p_schema => 'F1_REST_ACCESS',
                       p_object => 'V_F1_QUALIFICATIONTIMES',
                       p_object_type => 'VIEW',
                       p_object_alias => 'f1_qualification',
                       p_auto_rest_auth => FALSE);

    commit;
    
    ORDS.ENABLE_OBJECT(p_enabled => TRUE,
                       p_schema => 'F1_REST_ACCESS',
                       p_object => 'V_F1_RACES',
                       p_object_type => 'VIEW',
                       p_object_alias => 'f1_races',
                       p_auto_rest_auth => FALSE);

    commit;    

    ORDS.ENABLE_OBJECT(p_enabled => TRUE,
                       p_schema => 'F1_REST_ACCESS',
                       p_object => 'V_F1_RESULTS',
                       p_object_type => 'VIEW',
                       p_object_alias => 'f1_results',
                       p_auto_rest_auth => FALSE);

    commit;
    
    ORDS.ENABLE_OBJECT(p_enabled => TRUE,
                       p_schema => 'F1_REST_ACCESS',
                       p_object => 'V_F1_SEASON',
                       p_object_type => 'VIEW',
                       p_object_alias => 'f1_seasons',
                       p_auto_rest_auth => FALSE);

    commit;
    
    ORDS.ENABLE_OBJECT(p_enabled => TRUE,
                       p_schema => 'F1_REST_ACCESS',
                       p_object => 'V_F1_SEASONS_RACE_DATES',
                       p_object_type => 'VIEW',
                       p_object_alias => 'f1_race_dates',
                       p_auto_rest_auth => FALSE);

    commit;
    
    ORDS.ENABLE_OBJECT(p_enabled => TRUE,
                       p_schema => 'F1_REST_ACCESS',
                       p_object => 'V_F1_TRACKS',
                       p_object_type => 'VIEW',
                       p_object_alias => 'f1_tracks',
                       p_auto_rest_auth => FALSE);

    commit;

    ORDS.ENABLE_OBJECT(p_enabled => TRUE,
                       p_schema => 'F1_REST_ACCESS',
                       p_object => 'V_F1_UPCOMING_RACES',
                       p_object_type => 'VIEW',
                       p_object_alias => 'f1_future_season_races',
                       p_auto_rest_auth => FALSE);

    commit;
    
END;