prompt --application/pages/page_00009
begin
--   Manifest
--     PAGE: 00009
--   Manifest End
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2023.04.28'
,p_release=>'23.1.4'
,p_default_workspace_id=>3200475603065552
,p_default_application_id=>100
,p_default_id_offset=>0
,p_default_owner=>'APEX_F1'
);
wwv_flow_imp_page.create_page(
 p_id=>9
,p_name=>'Race Details 2023'
,p_alias=>'RACE-DETAILS-2023'
,p_step_title=>'Race Details 2023'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_protection_level=>'C'
,p_page_component_map=>'23'
,p_last_updated_by=>'UHELLSTR'
,p_last_upd_yyyymmddhh24miss=>'20230921145309'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(4159768203183722)
,p_plug_name=>'Breadcrumb'
,p_region_template_options=>'#DEFAULT#:t-BreadcrumbRegion--useBreadcrumbTitle'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_imp.id(3308246700634120)
,p_plug_display_sequence=>10
,p_plug_display_point=>'REGION_POSITION_01'
,p_menu_id=>wwv_flow_imp.id(3210254008634085)
,p_plug_source_type=>'NATIVE_BREADCRUMB'
,p_menu_template_id=>wwv_flow_imp.id(3388338487634141)
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(4160312085183724)
,p_plug_name=>'Race Details 2023'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_imp.id(3254080804634105)
,p_plug_display_sequence=>10
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select round as race',
'       ,racename',
'       ,circuitname',
'       ,race_date',
'       , case when trunc(race_date) <= trunc(sysdate) then',
'          ''u-color-1''',
'         else',
'          ''u-color-43''',
'        end card_color ',
'from v_f1_seasons_race_dates',
'where season = 2023'))
,p_query_order_by_type=>'ITEM'
,p_query_order_by=>'{"orderBys":[{"key":"RACE_DATE","expr":"\"RACE_DATE\" asc"},{"key":"RACENAME","expr":"\"RACENAME\" asc"},{"key":"CIRCUITNAME","expr":"\"CIRCUITNAME\" asc"}],"itemName":"P9_ORDER_BY"}'
,p_lazy_loading=>false
,p_plug_source_type=>'NATIVE_CARDS'
,p_plug_query_num_rows_type=>'SCROLL'
,p_show_total_row_count=>false
,p_pagination_display_position=>'BOTTOM_RIGHT'
);
wwv_flow_imp_page.create_card(
 p_id=>wwv_flow_imp.id(4160813325183725)
,p_region_id=>wwv_flow_imp.id(4160312085183724)
,p_layout_type=>'GRID'
,p_card_css_classes=>'&CARD_COLOR!ATTR.'
,p_title_adv_formatting=>false
,p_title_column_name=>'RACENAME'
,p_sub_title_adv_formatting=>false
,p_body_adv_formatting=>false
,p_body_column_name=>'CIRCUITNAME'
,p_second_body_adv_formatting=>false
,p_badge_column_name=>'RACE_DATE'
,p_media_adv_formatting=>false
);
wwv_flow_imp_page.create_card_action(
 p_id=>wwv_flow_imp.id(3128772256151102)
,p_card_id=>wwv_flow_imp.id(4160813325183725)
,p_action_type=>'BUTTON'
,p_position=>'PRIMARY'
,p_display_sequence=>10
,p_label=>'Race Details'
,p_link_target_type=>'REDIRECT_PAGE'
,p_link_target=>'f?p=&APP_ID.:3:&SESSION.::&DEBUG.:::'
,p_button_display_type=>'TEXT'
,p_is_hot=>false
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(4161379858183728)
,p_name=>'P9_ORDER_BY'
,p_is_required=>true
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(4160312085183724)
,p_item_display_point=>'ORDER_BY_ITEM'
,p_item_default=>'RACE_DATE'
,p_prompt=>'Order By'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>'STATIC2:Race Date;RACE_DATE,Racename;RACENAME,Circuitname;CIRCUITNAME'
,p_cHeight=>1
,p_field_template=>wwv_flow_imp.id(3384241421634139)
,p_item_template_options=>'#DEFAULT#'
,p_warn_on_unsaved_changes=>'I'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_imp.component_end;
end;
/
