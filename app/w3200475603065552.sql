prompt --application/set_environment
set define off verify off feedback off
whenever sqlerror exit sql.sqlcode rollback
--------------------------------------------------------------------------------
--
-- Oracle APEX export file
--
-- You should run this script using a SQL client connected to the database as
-- the owner (parsing schema) of the application or as a database user with the
-- APEX_ADMINISTRATOR_ROLE role.
--
-- This export file has been automatically generated. Modifying this file is not
-- supported by Oracle and can lead to unexpected application and/or instance
-- behavior now or in the future.
--
-- NOTE: Calls to apex_application_install override the defaults below.
--
--------------------------------------------------------------------------------
begin
wwv_flow_imp.import_begin (
 p_version_yyyy_mm_dd=>'2023.04.28'
,p_default_workspace_id=>3200475603065552
);
end;
/
prompt  WORKSPACE 3200475603065552
--
-- Workspace, User Group, User, and Team Development Export:
--   Exported By:     ULFDBA
--   Export Type:     Workspace Export
--   Version:         23.1.4
--   Instance ID:     706438958328128
--
-- Import:
--   Using Instance Administration / Manage Workspaces
--   or
--   Using SQL*Plus as the Oracle user APEX_230100
 
begin
    wwv_flow_imp.set_security_group_id(p_security_group_id=>3200475603065552);
end;
/
----------------
-- W O R K S P A C E
-- Creating a workspace will not create database schemas or objects.
-- This API creates only the meta data for this APEX workspace
prompt  Creating workspace APEX_F1_WS...
begin
wwv_flow_fnd_user_api.create_company (
  p_id => 3200536411065560
 ,p_provisioning_company_id => 3200475603065552
 ,p_short_name => 'APEX_F1_WS'
 ,p_display_name => 'APEX_F1_WS'
 ,p_first_schema_provisioned => 'APEX_F1'
 ,p_company_schemas => 'APEX_F1'
 ,p_account_status => 'ASSIGNED'
 ,p_allow_plsql_editing => 'Y'
 ,p_allow_app_building_yn => 'Y'
 ,p_allow_packaged_app_ins_yn => 'Y'
 ,p_allow_sql_workshop_yn => 'Y'
 ,p_allow_team_development_yn => 'Y'
 ,p_allow_to_be_purged_yn => 'Y'
 ,p_allow_restful_services_yn => 'Y'
 ,p_source_identifier => 'APEX_F1_'
 ,p_webservice_logging_yn => 'Y'
 ,p_path_prefix => 'APEX_F1_WS'
 ,p_files_version => 1
 ,p_env_banner_yn => 'N'
 ,p_env_banner_pos => 'LEFT'
);
end;
/
----------------
-- G R O U P S
--
prompt  Creating Groups...
begin
wwv_flow_fnd_user_api.create_user_group (
  p_id => 3091722199351925,
  p_GROUP_NAME => 'OAuth2 Client Developer',
  p_SECURITY_GROUP_ID => 10,
  p_GROUP_DESC => 'Users authorized to register OAuth2 Client Applications');
end;
/
begin
wwv_flow_fnd_user_api.create_user_group (
  p_id => 3091672351351925,
  p_GROUP_NAME => 'RESTful Services',
  p_SECURITY_GROUP_ID => 10,
  p_GROUP_DESC => 'Users authorized to use RESTful Services with this workspace');
end;
/
begin
wwv_flow_fnd_user_api.create_user_group (
  p_id => 3091571658351925,
  p_GROUP_NAME => 'SQL Developer',
  p_SECURITY_GROUP_ID => 10,
  p_GROUP_DESC => 'Users authorized to use SQL Developer with this workspace');
end;
/
prompt  Creating group grants...
----------------
-- U S E R S
-- User repository for use with APEX cookie-based authentication.
--
prompt  Creating Users...
begin
wwv_flow_fnd_user_api.create_fnd_user (
  p_user_id                      => '3200393423065552',
  p_user_name                    => 'F1-ADMIN',
  p_first_name                   => 'Ulf',
  p_last_name                    => 'Hellström',
  p_description                  => '',
  p_email_address                => 'oraminute@gmail.com',
  p_web_password                 => 'CB1EB9080D04D9BB440AE0E0609356510463F43615AAF6D27C07D79F02137FA04BC35DD37FE34337900478A5253E9F747635143715D1FB3655B27D9AE0607979',
  p_web_password_format          => '5;5;10000',
  p_group_ids                    => '',
  p_developer_privs              => 'ADMIN:CREATE:DATA_LOADER:EDIT:HELP:MONITOR:SQL',
  p_default_schema               => 'APEX_F1',
  p_account_locked               => 'N',
  p_account_expiry               => to_date('202309121324','YYYYMMDDHH24MI'),
  p_failed_access_attempts       => 0,
  p_change_password_on_first_use => 'Y',
  p_first_password_use_occurred  => 'N',
  p_allow_app_building_yn        => 'Y',
  p_allow_sql_workshop_yn        => 'Y',
  p_allow_team_development_yn    => 'Y',
  p_allow_access_to_schemas      => '');
end;
/
begin
wwv_flow_fnd_user_api.create_fnd_user (
  p_user_id                      => '3201405679073766',
  p_user_name                    => 'UHELLSTR',
  p_first_name                   => 'Ulf',
  p_last_name                    => 'Hellström',
  p_description                  => 'Developer',
  p_email_address                => 'oraminute@gmail.com',
  p_web_password                 => 'E1F403123CFFABE94889144495DBFE83717A079CEF68C6A8D81DD93DE5B69AA6650F676D9AA61C00BBE0796F12922DB9AF3F6F1472DD01D0F20BA6521EA850B5',
  p_web_password_format          => '5;5;10000',
  p_group_ids                    => '',
  p_developer_privs              => 'ADMIN:CREATE:DATA_LOADER:EDIT:HELP:MONITOR:SQL',
  p_default_schema               => '',
  p_account_locked               => 'N',
  p_account_expiry               => to_date('202309121326','YYYYMMDDHH24MI'),
  p_failed_access_attempts       => 0,
  p_change_password_on_first_use => 'N',
  p_first_password_use_occurred  => 'N',
  p_allow_app_building_yn        => 'Y',
  p_allow_sql_workshop_yn        => 'Y',
  p_allow_team_development_yn    => 'Y',
  p_default_date_format          => 'RRRR-MM-DD HH24:MI:SS',
  p_allow_access_to_schemas      => '');
end;
/
---------------------------
-- D G  B L U E P R I N T S
-- Creating Data Generator Blueprints...
----------------
--Click Count Logs
--
----------------
--mail
--
----------------
--mail log
--
----------------
--app models
--
----------------
--password history
--
begin
  wwv_imp_workspace.create_password_history (
    p_id => 3200722250065582,
    p_user_id => 3200393423065552,
    p_password => 'CB1EB9080D04D9BB440AE0E0609356510463F43615AAF6D27C07D79F02137FA04BC35DD37FE34337900478A5253E9F747635143715D1FB3655B27D9AE0607979');
end;
/
begin
  wwv_imp_workspace.create_password_history (
    p_id => 3201571107073772,
    p_user_id => 3201405679073766,
    p_password => 'E1F403123CFFABE94889144495DBFE83717A079CEF68C6A8D81DD93DE5B69AA6650F676D9AA61C00BBE0796F12922DB9AF3F6F1472DD01D0F20BA6521EA850B5');
end;
/
----------------
--preferences
--
begin
  wwv_imp_workspace.create_preferences$ (
    p_id => 3710580920678686,
    p_user_id => 'UHELLSTR',
    p_preference_name => 'FSP_IR_4000_P1500_W3519715528105919',
    p_attribute_value => '3521529006112497____',
    p_tenant_id => '');
end;
/
begin
  wwv_imp_workspace.create_preferences$ (
    p_id => 3733225518929748,
    p_user_id => 'UHELLSTR',
    p_preference_name => 'FSP100_P5_R3730835545929264_SORT',
    p_attribute_value => 'sort_1_asc',
    p_tenant_id => '');
end;
/
begin
  wwv_imp_workspace.create_preferences$ (
    p_id => 3737382400029080,
    p_user_id => 'UHELLSTR',
    p_preference_name => 'FSP_IR_100_P10010_W3510647342634235',
    p_attribute_value => '3516297637634245____',
    p_tenant_id => '');
end;
/
begin
  wwv_imp_workspace.create_preferences$ (
    p_id => 4371733763196380,
    p_user_id => 'UHELLSTR',
    p_preference_name => 'FSP100_P2_R4369786007196061_SORT',
    p_attribute_value => 'sort_1_asc',
    p_tenant_id => '');
end;
/
begin
  wwv_imp_workspace.create_preferences$ (
    p_id => 3709823942634509,
    p_user_id => 'UHELLSTR',
    p_preference_name => 'PERSISTENT_ITEM_P1_DISPLAY_MODE',
    p_attribute_value => 'ICONS',
    p_tenant_id => '');
end;
/
begin
  wwv_imp_workspace.create_preferences$ (
    p_id => 3710046886634527,
    p_user_id => 'UHELLSTR',
    p_preference_name => 'FSP_IR_4000_P1_W3326806401130228',
    p_attribute_value => '3328003692130542____ICON',
    p_tenant_id => '');
end;
/
begin
  wwv_imp_workspace.create_preferences$ (
    p_id => 3710167564634538,
    p_user_id => 'UHELLSTR',
    p_preference_name => 'FB_FLOW_ID',
    p_attribute_value => '101',
    p_tenant_id => '');
end;
/
begin
  wwv_imp_workspace.create_preferences$ (
    p_id => 3743551036087770,
    p_user_id => 'UHELLSTR',
    p_preference_name => 'FSP100_P7_R3741195426086251_SORT',
    p_attribute_value => 'sort_1_asc',
    p_tenant_id => '');
end;
/
begin
  wwv_imp_workspace.create_preferences$ (
    p_id => 3748122168318434,
    p_user_id => 'UHELLSTR',
    p_preference_name => 'F4000_203906404237009921_SPLITTER_STATE',
    p_attribute_value => '455:false',
    p_tenant_id => '');
end;
/
begin
  wwv_imp_workspace.create_preferences$ (
    p_id => 3755165495566193,
    p_user_id => 'UHELLSTR',
    p_preference_name => 'FSP100_P1_R3721694982840213_SORT',
    p_attribute_value => 'sort_1_asc',
    p_tenant_id => '');
end;
/
begin
  wwv_imp_workspace.create_preferences$ (
    p_id => 4158715137107905,
    p_user_id => 'UHELLSTR',
    p_preference_name => 'FSP_IR_4000_P4850_W663191354226602129',
    p_attribute_value => '663193778295677089____',
    p_tenant_id => '');
end;
/
begin
  wwv_imp_workspace.create_preferences$ (
    p_id => 4362587298488447,
    p_user_id => 'UHELLSTR',
    p_preference_name => 'CODE_LANGUAGE',
    p_attribute_value => 'PLSQL',
    p_tenant_id => '');
end;
/
begin
  wwv_imp_workspace.create_preferences$ (
    p_id => 4362013042482116,
    p_user_id => 'UHELLSTR',
    p_preference_name => 'FSP_IR_4000_P405_W3852329031687921',
    p_attribute_value => '3853503855690337____',
    p_tenant_id => '');
end;
/
begin
  wwv_imp_workspace.create_preferences$ (
    p_id => 4362497984482429,
    p_user_id => 'UHELLSTR',
    p_preference_name => 'APEX_IG_665073618803777080_CURRENT_REPORT',
    p_attribute_value => '665079563548779201:GRID',
    p_tenant_id => '');
end;
/
----------------
--query builder
--
----------------
--sql scripts
--
----------------
--sql commands
--
----------------
--Quick SQL saved models
--
----------------
--user access log
--
begin
  wwv_imp_workspace.create_user_access_log2$ (
    p_login_name => 'UHELLSTR',
    p_auth_method => 'Internal Authentication',
    p_app => 4500,
    p_owner => 'APEX_230100',
    p_access_date => to_date('202309121338','YYYYMMDDHH24MI'),
    p_ip_address => '127.0.0.1',
    p_remote_user => 'APEX_PUBLIC_USER',
    p_auth_result => 0,
    p_custom_status_text => '');
end;
/
begin
  wwv_imp_workspace.create_user_access_log2$ (
    p_login_name => 'UHELLSTR',
    p_auth_method => 'Internal Authentication',
    p_app => 4500,
    p_owner => 'APEX_230100',
    p_access_date => to_date('202309121458','YYYYMMDDHH24MI'),
    p_ip_address => '127.0.0.1',
    p_remote_user => 'APEX_PUBLIC_USER',
    p_auth_result => 4,
    p_custom_status_text => 'Invalid Login Credentials');
end;
/
begin
  wwv_imp_workspace.create_user_access_log2$ (
    p_login_name => 'UHELLSTR',
    p_auth_method => 'Internal Authentication',
    p_app => 4500,
    p_owner => 'APEX_230100',
    p_access_date => to_date('202309121458','YYYYMMDDHH24MI'),
    p_ip_address => '127.0.0.1',
    p_remote_user => 'APEX_PUBLIC_USER',
    p_auth_result => 0,
    p_custom_status_text => '');
end;
/
begin
  wwv_imp_workspace.create_user_access_log2$ (
    p_login_name => 'UHELLSTR',
    p_auth_method => 'Oracle APEX Accounts',
    p_app => 100,
    p_owner => 'APEX_F1',
    p_access_date => to_date('202309121623','YYYYMMDDHH24MI'),
    p_ip_address => '127.0.0.1',
    p_remote_user => 'APEX_PUBLIC_USER',
    p_auth_result => 0,
    p_custom_status_text => '');
end;
/
begin
  wwv_imp_workspace.create_user_access_log2$ (
    p_login_name => 'UHELLSTR',
    p_auth_method => 'Application Express Accounts',
    p_app => 101,
    p_owner => 'APEX_F1',
    p_access_date => to_date('202309131604','YYYYMMDDHH24MI'),
    p_ip_address => '127.0.0.1',
    p_remote_user => 'APEX_PUBLIC_USER',
    p_auth_result => 0,
    p_custom_status_text => '');
end;
/
begin
  wwv_imp_workspace.create_user_access_log2$ (
    p_login_name => 'UHELLSTR',
    p_auth_method => 'Oracle APEX Accounts',
    p_app => 100,
    p_owner => 'APEX_F1',
    p_access_date => to_date('202309121459','YYYYMMDDHH24MI'),
    p_ip_address => '127.0.0.1',
    p_remote_user => 'APEX_PUBLIC_USER',
    p_auth_result => 0,
    p_custom_status_text => '');
end;
/
begin
  wwv_imp_workspace.create_user_access_log2$ (
    p_login_name => 'UHELLSTR',
    p_auth_method => 'Oracle APEX Accounts',
    p_app => 100,
    p_owner => 'APEX_F1',
    p_access_date => to_date('202309131322','YYYYMMDDHH24MI'),
    p_ip_address => '127.0.0.1',
    p_remote_user => 'APEX_PUBLIC_USER',
    p_auth_result => 0,
    p_custom_status_text => '');
end;
/
begin
  wwv_imp_workspace.create_user_access_log2$ (
    p_login_name => 'UHELLSTR',
    p_auth_method => 'Internal Authentication',
    p_app => 4500,
    p_owner => 'APEX_230100',
    p_access_date => to_date('202309131552','YYYYMMDDHH24MI'),
    p_ip_address => '127.0.0.1',
    p_remote_user => 'APEX_PUBLIC_USER',
    p_auth_result => 0,
    p_custom_status_text => '');
end;
/
begin
  wwv_imp_workspace.create_user_access_log2$ (
    p_login_name => 'UHELLSTR',
    p_auth_method => 'Internal Authentication',
    p_app => 4500,
    p_owner => 'APEX_230100',
    p_access_date => to_date('202309121327','YYYYMMDDHH24MI'),
    p_ip_address => '127.0.0.1',
    p_remote_user => 'APEX_PUBLIC_USER',
    p_auth_result => 0,
    p_custom_status_text => '');
end;
/
begin
  wwv_imp_workspace.create_user_access_log2$ (
    p_login_name => 'UHELLSTR',
    p_auth_method => 'Internal Authentication',
    p_app => 4500,
    p_owner => 'APEX_230100',
    p_access_date => to_date('202309201516','YYYYMMDDHH24MI'),
    p_ip_address => '127.0.0.1',
    p_remote_user => 'APEX_PUBLIC_USER',
    p_auth_result => 0,
    p_custom_status_text => '');
end;
/
begin
  wwv_imp_workspace.create_user_access_log2$ (
    p_login_name => 'UHELLSTR',
    p_auth_method => 'Internal Authentication',
    p_app => 4500,
    p_owner => 'APEX_230100',
    p_access_date => to_date('202309121738','YYYYMMDDHH24MI'),
    p_ip_address => '127.0.0.1',
    p_remote_user => 'APEX_PUBLIC_USER',
    p_auth_result => 0,
    p_custom_status_text => '');
end;
/
begin
  wwv_imp_workspace.create_user_access_log2$ (
    p_login_name => 'UHELLSTR',
    p_auth_method => 'Internal Authentication',
    p_app => 4500,
    p_owner => 'APEX_230100',
    p_access_date => to_date('202309131320','YYYYMMDDHH24MI'),
    p_ip_address => '127.0.0.1',
    p_remote_user => 'APEX_PUBLIC_USER',
    p_auth_result => 0,
    p_custom_status_text => '');
end;
/
begin
  wwv_imp_workspace.create_user_access_log2$ (
    p_login_name => 'UHELLSTR',
    p_auth_method => 'Oracle APEX Accounts',
    p_app => 100,
    p_owner => 'APEX_F1',
    p_access_date => to_date('202309131552','YYYYMMDDHH24MI'),
    p_ip_address => '127.0.0.1',
    p_remote_user => 'APEX_PUBLIC_USER',
    p_auth_result => 0,
    p_custom_status_text => '');
end;
/
begin
  wwv_imp_workspace.create_user_access_log2$ (
    p_login_name => 'UHELLSTR',
    p_auth_method => 'Internal Authentication',
    p_app => 4500,
    p_owner => 'APEX_230100',
    p_access_date => to_date('202309121745','YYYYMMDDHH24MI'),
    p_ip_address => '127.0.0.1',
    p_remote_user => 'APEX_PUBLIC_USER',
    p_auth_result => 0,
    p_custom_status_text => '');
end;
/
begin
  wwv_imp_workspace.create_user_access_log2$ (
    p_login_name => 'UHELLSTR',
    p_auth_method => 'Internal Authentication',
    p_app => 4500,
    p_owner => 'APEX_230100',
    p_access_date => to_date('202309131020','YYYYMMDDHH24MI'),
    p_ip_address => '127.0.0.1',
    p_remote_user => 'APEX_PUBLIC_USER',
    p_auth_result => 0,
    p_custom_status_text => '');
end;
/
begin
  wwv_imp_workspace.create_user_access_log2$ (
    p_login_name => 'UHELLSTR',
    p_auth_method => 'Oracle APEX Accounts',
    p_app => 100,
    p_owner => 'APEX_F1',
    p_access_date => to_date('202309131020','YYYYMMDDHH24MI'),
    p_ip_address => '127.0.0.1',
    p_remote_user => 'APEX_PUBLIC_USER',
    p_auth_result => 0,
    p_custom_status_text => '');
end;
/
begin
  wwv_imp_workspace.create_user_access_log2$ (
    p_login_name => 'UHELLSTR',
    p_auth_method => 'Application Express Accounts',
    p_app => 101,
    p_owner => 'APEX_F1',
    p_access_date => to_date('202309131115','YYYYMMDDHH24MI'),
    p_ip_address => '127.0.0.1',
    p_remote_user => 'APEX_PUBLIC_USER',
    p_auth_result => 0,
    p_custom_status_text => '');
end;
/
 
prompt ...RESTful Services
 
-- SET SCHEMA
 
begin
 
   wwv_flow_imp.g_id_offset := 0;
   wwv_flow_hint.g_schema   := 'APEX_F1';
   wwv_flow_hint.check_schema_privs;
 
end;
/

 
--------------------------------------------------------------------
prompt  SCHEMA APEX_F1 - User Interface Defaults, Table Defaults
--
-- Import using sqlplus as the Oracle user: APEX_230100
-- Exported 15:29 Wednesday September 20, 2023 by: 
--
 
--------------------------------------------------------------------
prompt User Interface Defaults, Attribute Dictionary
--
-- Exported 15:29 Wednesday September 20, 2023 by: 
--
-- SHOW EXPORTING WORKSPACE
 
begin
 
   wwv_flow_imp.g_id_offset := 0;
   wwv_flow_hint.g_exp_workspace := 'APEX_F1_WS';
 
end;
/

begin
wwv_flow_imp.import_end(p_auto_install_sup_obj => nvl(wwv_flow_application_install.get_auto_install_sup_obj, false));
commit;
end;
/
set verify on feedback on define on
prompt  ...done
