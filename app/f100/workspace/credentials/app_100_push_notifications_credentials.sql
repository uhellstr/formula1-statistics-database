prompt --workspace/credentials/app_100_push_notifications_credentials
begin
--   Manifest
--     CREDENTIAL: App 100 Push Notifications Credentials
--   Manifest End
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2023.04.28'
,p_release=>'23.1.4'
,p_default_workspace_id=>3200475603065552
,p_default_application_id=>100
,p_default_id_offset=>0
,p_default_owner=>'APEX_F1'
);
wwv_imp_workspace.create_credential(
 p_id=>wwv_flow_imp.id(3709393718634415)
,p_name=>'App 100 Push Notifications Credentials'
,p_static_id=>'App_100_Push_Notifications_Credentials'
,p_authentication_type=>'KEY_PAIR'
,p_prompt_on_install=>false
);
wwv_flow_imp.component_end;
end;
/
