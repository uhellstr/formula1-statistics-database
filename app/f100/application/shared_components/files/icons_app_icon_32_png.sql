prompt --application/shared_components/files/icons_app_icon_32_png
begin
--   Manifest
--     APP STATIC FILES: 100
--   Manifest End
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2023.04.28'
,p_release=>'23.1.4'
,p_default_workspace_id=>3200475603065552
,p_default_application_id=>100
,p_default_id_offset=>0
,p_default_owner=>'APEX_F1'
);
wwv_flow_imp.g_varchar2_table := wwv_flow_imp.empty_varchar2_table;
wwv_flow_imp.g_varchar2_table(1) := '89504E470D0A1A0A0000000D4948445200000020000000200806000000737A7AF4000000B4494441545847ED54410E80200C2BF107FECFD7F93FFD808942748690C12641F1306EC6AEEDBA8143E7E33AEBC30C5802968025F028811D185660D33E5E23E0';
wwv_flow_imp.g_varchar2_table(2) := '16C0979D277CA7B52A0331494BF1C0251AE0C4B94E526352E7842F1A78B373D1C017E2D911C4E23EA2D96FD1545A24FAA78D3D1E97B803DAA5ABC5FDD600DDDD1606035796472B1070648A088BC4175EE41701CC6C3F37908E8333C061E896DD4F31378A';
wwv_flow_imp.g_varchar2_table(3) := '9A046A179EAD33039680256009744FE000CD022A211C80108D0000000049454E44AE426082';
wwv_flow_imp_shared.create_app_static_file(
 p_id=>wwv_flow_imp.id(3495610577634200)
,p_file_name=>'icons/app-icon-32.png'
,p_mime_type=>'image/png'
,p_file_charset=>'utf-8'
,p_file_content => wwv_flow_imp.varchar2_to_blob(wwv_flow_imp.g_varchar2_table)
);
wwv_flow_imp.component_end;
end;
/
