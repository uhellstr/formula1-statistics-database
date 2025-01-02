DECLARE
  PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN

    ORDS.ENABLE_SCHEMA(p_enabled => TRUE,
                       p_schema => 'F1_REST_ACCESS',
                       p_url_mapping_type => 'BASE_PATH',
                       p_url_mapping_pattern => 'f1_rest_access',
                       p_auto_rest_auth => FALSE);

    commit;

END;
/