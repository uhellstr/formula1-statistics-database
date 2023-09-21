prompt --application/pages/page_00003
begin
--   Manifest
--     PAGE: 00003
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
 p_id=>3
,p_name=>'Race Statistics'
,p_alias=>'RACE-STATISTICS'
,p_step_title=>'Race Statistics'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_protection_level=>'C'
,p_page_component_map=>'04'
,p_last_updated_by=>'UHELLSTR'
,p_last_upd_yyyymmddhh24miss=>'20230921153050'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(3128846295151103)
,p_plug_name=>'Race Results'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_imp.id(3295809033634117)
,p_plug_display_sequence=>20
,p_plug_source_type=>'NATIVE_JET_CHART'
);
wwv_flow_imp_page.create_jet_chart(
 p_id=>wwv_flow_imp.id(3128963968151104)
,p_region_id=>wwv_flow_imp.id(3128846295151103)
,p_chart_type=>'bar'
,p_title=>'Race Results'
,p_height=>'400'
,p_animation_on_display=>'auto'
,p_animation_on_data_change=>'auto'
,p_orientation=>'horizontal'
,p_data_cursor=>'auto'
,p_data_cursor_behavior=>'auto'
,p_hover_behavior=>'dim'
,p_stack=>'off'
,p_connect_nulls=>'Y'
,p_sorting=>'label-asc'
,p_fill_multi_series_gaps=>true
,p_zoom_and_scroll=>'off'
,p_tooltip_rendered=>'Y'
,p_show_series_name=>true
,p_show_group_name=>true
,p_show_value=>true
,p_legend_rendered=>'off'
);
wwv_flow_imp_page.create_jet_chart_series(
 p_id=>wwv_flow_imp.id(3129007952151105)
,p_chart_id=>wwv_flow_imp.id(3128963968151104)
,p_seq=>10
,p_name=>'Points'
,p_data_source_type=>'SQL'
,p_data_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select  racename,',
'  circuitid,',
'  pilotnr,',
'  position,  positiontext,',
'  points,',
'  driverid,',
'  constructorid,',
'  grid,',
'  laps,',
'  status,',
'  racetime',
'from',
'  v_f1_results',
'where season = 2023',
'  and race = 1',
'  and position < 11',
'order by position asc'))
,p_max_row_count=>20
,p_items_value_column_name=>'POSITION'
,p_items_label_column_name=>'DRIVERID'
,p_assigned_to_y2=>'off'
,p_items_label_rendered=>false
);
wwv_flow_imp_page.create_jet_chart_axis(
 p_id=>wwv_flow_imp.id(3129152860151106)
,p_chart_id=>wwv_flow_imp.id(3128963968151104)
,p_axis=>'x'
,p_is_rendered=>'on'
,p_format_scaling=>'none'
,p_scaling=>'linear'
,p_baseline_scaling=>'zero'
,p_major_tick_rendered=>'auto'
,p_minor_tick_rendered=>'auto'
,p_tick_label_rendered=>'on'
,p_tick_label_rotation=>'auto'
,p_tick_label_position=>'outside'
);
wwv_flow_imp_page.create_jet_chart_axis(
 p_id=>wwv_flow_imp.id(3129220509151107)
,p_chart_id=>wwv_flow_imp.id(3128963968151104)
,p_axis=>'y'
,p_is_rendered=>'on'
,p_format_scaling=>'none'
,p_scaling=>'linear'
,p_baseline_scaling=>'zero'
,p_position=>'auto'
,p_major_tick_rendered=>'auto'
,p_minor_tick_rendered=>'auto'
,p_tick_label_rendered=>'on'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(3134329279160900)
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
 p_id=>wwv_flow_imp.id(3134929778160903)
,p_plug_name=>'FP2  Race Predictions'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_plug_template=>wwv_flow_imp.id(3295809033634117)
,p_plug_display_sequence=>10
,p_plug_source_type=>'NATIVE_JET_CHART'
);
wwv_flow_imp_page.create_jet_chart(
 p_id=>wwv_flow_imp.id(3135375463160903)
,p_region_id=>wwv_flow_imp.id(3134929778160903)
,p_chart_type=>'bar'
,p_title=>'FP2 Race Predictions'
,p_height=>'400'
,p_animation_on_display=>'auto'
,p_animation_on_data_change=>'auto'
,p_orientation=>'vertical'
,p_data_cursor=>'auto'
,p_data_cursor_behavior=>'auto'
,p_hide_and_show_behavior=>'withRescale'
,p_hover_behavior=>'dim'
,p_stack=>'on'
,p_stack_label=>'off'
,p_connect_nulls=>'Y'
,p_sorting=>'label-asc'
,p_fill_multi_series_gaps=>true
,p_zoom_and_scroll=>'off'
,p_tooltip_rendered=>'Y'
,p_show_series_name=>true
,p_show_group_name=>true
,p_show_value=>true
,p_legend_rendered=>'on'
,p_legend_title=>'Compound'
,p_legend_position=>'bottom'
);
wwv_flow_imp_page.create_jet_chart_series(
 p_id=>wwv_flow_imp.id(3137039921160907)
,p_chart_id=>wwv_flow_imp.id(3135375463160903)
,p_seq=>10
,p_name=>'FP2 long run '
,p_data_source_type=>'SQL'
,p_data_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select driver',
'       ,stint',
'       ,number_of_laps_in_stint',
'       ,median_laptime',
'       ,median_laptime_numeric',
'       ,compound',
'       ,chartcolor',
'       ,race',
'       ,racetype',
'from v_f1_fp2_predictions;'))
,p_max_row_count=>20
,p_items_value_column_name=>'MEDIAN_LAPTIME_NUMERIC'
,p_group_name_column_name=>'COMPOUND'
,p_items_label_column_name=>'DRIVER'
,p_color=>'&CHARTCOLOR!ATTR.'
,p_assigned_to_y2=>'off'
,p_items_label_rendered=>false
);
wwv_flow_imp_page.create_jet_chart_axis(
 p_id=>wwv_flow_imp.id(3135832283160904)
,p_chart_id=>wwv_flow_imp.id(3135375463160903)
,p_axis=>'x'
,p_is_rendered=>'on'
,p_format_scaling=>'million'
,p_scaling=>'linear'
,p_baseline_scaling=>'zero'
,p_major_tick_rendered=>'auto'
,p_minor_tick_rendered=>'auto'
,p_tick_label_rendered=>'on'
,p_tick_label_rotation=>'auto'
,p_tick_label_position=>'outside'
);
wwv_flow_imp_page.create_jet_chart_axis(
 p_id=>wwv_flow_imp.id(3136469398160906)
,p_chart_id=>wwv_flow_imp.id(3135375463160903)
,p_axis=>'y'
,p_is_rendered=>'on'
,p_format_type=>'decimal'
,p_numeric_pattern=>'#,##.###'
,p_format_scaling=>'million'
,p_scaling=>'linear'
,p_baseline_scaling=>'min'
,p_step=>1000000
,p_position=>'auto'
,p_major_tick_rendered=>'auto'
,p_minor_tick_rendered=>'auto'
,p_tick_label_rendered=>'on'
);
wwv_flow_imp.component_end;
end;
/
