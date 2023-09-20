prompt --application/pages/page_00004
begin
--   Manifest
--     PAGE: 00004
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
 p_id=>4
,p_name=>'Season statistics 2023'
,p_alias=>'SEASON-STATISTICS'
,p_step_title=>'Season statistics 2023'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_protection_level=>'C'
,p_page_component_map=>'04'
,p_last_updated_by=>'UHELLSTR'
,p_last_upd_yyyymmddhh24miss=>'20230913170115'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(3711478774783974)
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
 p_id=>wwv_flow_imp.id(3712040436783974)
,p_plug_name=>'Constructor Standing'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_plug_template=>wwv_flow_imp.id(3295809033634117)
,p_plug_display_sequence=>10
,p_plug_source_type=>'NATIVE_JET_CHART'
,p_plug_customized=>'1'
);
wwv_flow_imp_page.create_jet_chart(
 p_id=>wwv_flow_imp.id(3712447847783974)
,p_region_id=>wwv_flow_imp.id(3712040436783974)
,p_chart_type=>'bar'
,p_title=>'Constructor Standings'
,p_height=>'400'
,p_animation_on_display=>'auto'
,p_animation_on_data_change=>'auto'
,p_orientation=>'horizontal'
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
,p_legend_title=>'Contructor Points/Wins'
,p_legend_position=>'top'
);
wwv_flow_imp_page.create_jet_chart_series(
 p_id=>wwv_flow_imp.id(3720460573840201)
,p_chart_id=>wwv_flow_imp.id(3712447847783974)
,p_seq=>10
,p_name=>'Wins'
,p_data_source_type=>'SQL'
,p_data_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select position',
'       , points',
'       , wins',
'       , constructorname, nationality',
'from v_f1_cur_season_constructor_standings',
'order by points desc',
''))
,p_items_value_column_name=>'WINS'
,p_items_label_column_name=>'CONSTRUCTORNAME'
,p_color=>'#0004ff'
,p_assigned_to_y2=>'off'
,p_items_label_rendered=>false
,p_link_target=>'f?p=&APP_ID.:5:&SESSION.::&DEBUG.:::'
,p_link_target_type=>'REDIRECT_PAGE'
);
wwv_flow_imp_page.create_jet_chart_series(
 p_id=>wwv_flow_imp.id(3714152924783975)
,p_chart_id=>wwv_flow_imp.id(3712447847783974)
,p_seq=>20
,p_name=>'Points'
,p_data_source_type=>'SQL'
,p_data_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select position',
'       , points',
'       , wins',
'       , constructorname, nationality',
'from v_f1_cur_season_constructor_standings',
'order by points desc'))
,p_max_row_count=>20
,p_items_value_column_name=>'POINTS'
,p_items_label_column_name=>'CONSTRUCTORNAME'
,p_color=>'#a3013c'
,p_assigned_to_y2=>'off'
,p_items_label_rendered=>false
,p_link_target=>'f?p=&APP_ID.:5:&SESSION.::&DEBUG.:::'
,p_link_target_type=>'REDIRECT_PAGE'
);
wwv_flow_imp_page.create_jet_chart_axis(
 p_id=>wwv_flow_imp.id(3712994045783975)
,p_chart_id=>wwv_flow_imp.id(3712447847783974)
,p_axis=>'x'
,p_is_rendered=>'on'
,p_title=>'Constructor Name'
,p_format_scaling=>'auto'
,p_scaling=>'linear'
,p_baseline_scaling=>'zero'
,p_major_tick_rendered=>'auto'
,p_minor_tick_rendered=>'auto'
,p_tick_label_rendered=>'on'
,p_tick_label_rotation=>'auto'
,p_tick_label_position=>'outside'
);
wwv_flow_imp_page.create_jet_chart_axis(
 p_id=>wwv_flow_imp.id(3713506146783975)
,p_chart_id=>wwv_flow_imp.id(3712447847783974)
,p_axis=>'y'
,p_is_rendered=>'on'
,p_title=>'Points and Wins'
,p_format_scaling=>'auto'
,p_scaling=>'linear'
,p_baseline_scaling=>'zero'
,p_position=>'auto'
,p_major_tick_rendered=>'auto'
,p_minor_tick_rendered=>'on'
,p_tick_label_rendered=>'on'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(3714787590783976)
,p_plug_name=>'Driver Standings'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_plug_template=>wwv_flow_imp.id(3295809033634117)
,p_plug_display_sequence=>20
,p_plug_source_type=>'NATIVE_JET_CHART'
);
wwv_flow_imp_page.create_jet_chart(
 p_id=>wwv_flow_imp.id(3715147095783976)
,p_region_id=>wwv_flow_imp.id(3714787590783976)
,p_chart_type=>'pie'
,p_animation_on_display=>'auto'
,p_animation_on_data_change=>'auto'
,p_hide_and_show_behavior=>'withRescale'
,p_hover_behavior=>'dim'
,p_stack=>'off'
,p_stack_label=>'off'
,p_connect_nulls=>'Y'
,p_value_position=>'auto'
,p_sorting=>'label-asc'
,p_fill_multi_series_gaps=>true
,p_tooltip_rendered=>'Y'
,p_show_series_name=>true
,p_show_group_name=>true
,p_show_value=>true
,p_show_label=>true
,p_show_row=>true
,p_show_start=>true
,p_show_end=>true
,p_show_progress=>true
,p_show_baseline=>true
,p_legend_rendered=>'off'
,p_legend_position=>'auto'
,p_overview_rendered=>'off'
,p_horizontal_grid=>'auto'
,p_vertical_grid=>'auto'
,p_gauge_orientation=>'circular'
,p_gauge_plot_area=>'on'
,p_show_gauge_value=>true
);
wwv_flow_imp_page.create_jet_chart_series(
 p_id=>wwv_flow_imp.id(3715610698783976)
,p_chart_id=>wwv_flow_imp.id(3715147095783976)
,p_seq=>10
,p_name=>'Driver Standing'
,p_data_source_type=>'SQL'
,p_data_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select points',
'       ,wins',
'       ,familyname',
'       ,constructorname',
'from v_f1_cur_season_driver_standings;'))
,p_max_row_count=>20
,p_items_value_column_name=>'POINTS'
,p_items_label_column_name=>'FAMILYNAME'
,p_items_label_rendered=>true
,p_items_label_position=>'auto'
,p_items_label_display_as=>'LABEL'
,p_link_target=>'f?p=&APP_ID.:7:&SESSION.::&DEBUG.:::'
,p_link_target_type=>'REDIRECT_PAGE'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(3716268326783976)
,p_plug_name=>'Podiums'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_plug_template=>wwv_flow_imp.id(3295809033634117)
,p_plug_display_sequence=>30
,p_plug_new_grid_row=>false
,p_plug_source_type=>'NATIVE_JET_CHART'
);
wwv_flow_imp_page.create_jet_chart(
 p_id=>wwv_flow_imp.id(3716686662783976)
,p_region_id=>wwv_flow_imp.id(3716268326783976)
,p_chart_type=>'bar'
,p_animation_on_display=>'auto'
,p_animation_on_data_change=>'auto'
,p_orientation=>'vertical'
,p_hide_and_show_behavior=>'withRescale'
,p_hover_behavior=>'dim'
,p_stack=>'off'
,p_stack_label=>'off'
,p_connect_nulls=>'Y'
,p_value_position=>'auto'
,p_sorting=>'label-asc'
,p_fill_multi_series_gaps=>true
,p_tooltip_rendered=>'Y'
,p_show_series_name=>true
,p_show_group_name=>true
,p_show_value=>true
,p_show_label=>true
,p_show_row=>true
,p_show_start=>true
,p_show_end=>true
,p_show_progress=>true
,p_show_baseline=>true
,p_legend_rendered=>'off'
,p_legend_position=>'auto'
,p_overview_rendered=>'off'
,p_horizontal_grid=>'auto'
,p_vertical_grid=>'auto'
,p_gauge_orientation=>'circular'
,p_gauge_plot_area=>'on'
,p_show_gauge_value=>true
);
wwv_flow_imp_page.create_jet_chart_series(
 p_id=>wwv_flow_imp.id(3718391473783976)
,p_chart_id=>wwv_flow_imp.id(3716686662783976)
,p_seq=>10
,p_name=>'Podium'
,p_data_source_type=>'SQL'
,p_data_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select familyname',
'       ,number_of_podiums',
'from v_f1_cur_season_driver_podium'))
,p_max_row_count=>20
,p_items_value_column_name=>'NUMBER_OF_PODIUMS'
,p_items_label_column_name=>'FAMILYNAME'
,p_assigned_to_y2=>'off'
,p_items_label_rendered=>false
,p_link_target=>'f?p=&APP_ID.:10:&SESSION.::&DEBUG.:::'
,p_link_target_type=>'REDIRECT_PAGE'
);
wwv_flow_imp_page.create_jet_chart_axis(
 p_id=>wwv_flow_imp.id(3717131760783976)
,p_chart_id=>wwv_flow_imp.id(3716686662783976)
,p_axis=>'x'
,p_is_rendered=>'on'
,p_baseline_scaling=>'zero'
,p_major_tick_rendered=>'auto'
,p_minor_tick_rendered=>'auto'
,p_tick_label_rendered=>'on'
,p_zoom_order_seconds=>false
,p_zoom_order_minutes=>false
,p_zoom_order_hours=>false
,p_zoom_order_days=>false
,p_zoom_order_weeks=>false
,p_zoom_order_months=>false
,p_zoom_order_quarters=>false
,p_zoom_order_years=>false
);
wwv_flow_imp_page.create_jet_chart_axis(
 p_id=>wwv_flow_imp.id(3717755371783976)
,p_chart_id=>wwv_flow_imp.id(3716686662783976)
,p_axis=>'y'
,p_is_rendered=>'on'
,p_format_scaling=>'auto'
,p_scaling=>'linear'
,p_baseline_scaling=>'zero'
,p_position=>'auto'
,p_major_tick_rendered=>'auto'
,p_minor_tick_rendered=>'on'
,p_tick_label_rendered=>'on'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(3722269357840219)
,p_plug_name=>'Pole Position'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_imp.id(3295809033634117)
,p_plug_display_sequence=>40
,p_plug_new_grid_row=>false
,p_plug_source_type=>'NATIVE_JET_CHART'
);
wwv_flow_imp_page.create_jet_chart(
 p_id=>wwv_flow_imp.id(3722376543840220)
,p_region_id=>wwv_flow_imp.id(3722269357840219)
,p_chart_type=>'bar'
,p_animation_on_display=>'auto'
,p_animation_on_data_change=>'auto'
,p_orientation=>'vertical'
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
 p_id=>wwv_flow_imp.id(3722442408840221)
,p_chart_id=>wwv_flow_imp.id(3722376543840220)
,p_seq=>10
,p_name=>'Pole Position'
,p_data_source_type=>'SQL'
,p_data_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select givenname',
'       ,familyname',
'       ,constructor',
'       ,count(position) as poleposition',
'from v_f1_cur_season_qualifications',
'where position = 1',
'group by givenname,familyname,constructor'))
,p_max_row_count=>20
,p_items_value_column_name=>'POLEPOSITION'
,p_items_label_column_name=>'FAMILYNAME'
,p_assigned_to_y2=>'off'
,p_items_label_rendered=>false
,p_link_target=>'f?p=&APP_ID.:2:&SESSION.::&DEBUG.:::'
,p_link_target_type=>'REDIRECT_PAGE'
);
wwv_flow_imp_page.create_jet_chart_axis(
 p_id=>wwv_flow_imp.id(3722588486840222)
,p_chart_id=>wwv_flow_imp.id(3722376543840220)
,p_axis=>'x'
,p_is_rendered=>'on'
,p_format_scaling=>'auto'
,p_scaling=>'linear'
,p_baseline_scaling=>'zero'
,p_major_tick_rendered=>'auto'
,p_minor_tick_rendered=>'auto'
,p_tick_label_rendered=>'on'
,p_tick_label_rotation=>'auto'
,p_tick_label_position=>'outside'
);
wwv_flow_imp_page.create_jet_chart_axis(
 p_id=>wwv_flow_imp.id(3722612918840223)
,p_chart_id=>wwv_flow_imp.id(3722376543840220)
,p_axis=>'y'
,p_is_rendered=>'on'
,p_format_scaling=>'auto'
,p_scaling=>'linear'
,p_baseline_scaling=>'zero'
,p_position=>'auto'
,p_major_tick_rendered=>'auto'
,p_minor_tick_rendered=>'on'
,p_tick_label_rendered=>'on'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(3722710270840224)
,p_plug_name=>'Race Winners'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_imp.id(3295809033634117)
,p_plug_display_sequence=>50
,p_plug_new_grid_row=>false
,p_plug_source_type=>'NATIVE_JET_CHART'
);
wwv_flow_imp_page.create_jet_chart(
 p_id=>wwv_flow_imp.id(3722852163840225)
,p_region_id=>wwv_flow_imp.id(3722710270840224)
,p_chart_type=>'bar'
,p_animation_on_display=>'auto'
,p_animation_on_data_change=>'auto'
,p_orientation=>'vertical'
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
 p_id=>wwv_flow_imp.id(3722943508840226)
,p_chart_id=>wwv_flow_imp.id(3722852163840225)
,p_seq=>10
,p_name=>'Race Winners'
,p_data_source_type=>'SQL'
,p_data_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select givenname',
'       ,familyname',
'       ,win',
'from',
'(',
'select vfd.givenname',
'       ,vfd.familyname',
'       ,count(vfr.position) as win',
'from v_f1_results vfr',
'inner join v_f1_drivers vfd',
'on vfr.driverid = vfd.driverid',
'where vfr.season = f1_logik.get_cur_f1_season',
' and vfr.position = 1',
'group by vfd.givenname,vfd.familyname',
') order by win desc'))
,p_max_row_count=>20
,p_items_value_column_name=>'WIN'
,p_items_label_column_name=>'FAMILYNAME'
,p_assigned_to_y2=>'off'
,p_items_label_rendered=>false
,p_link_target=>'f?p=&APP_ID.:2:&SESSION.::&DEBUG.:::'
,p_link_target_type=>'REDIRECT_PAGE'
);
wwv_flow_imp_page.create_jet_chart_axis(
 p_id=>wwv_flow_imp.id(3723061654840227)
,p_chart_id=>wwv_flow_imp.id(3722852163840225)
,p_axis=>'x'
,p_is_rendered=>'on'
,p_format_scaling=>'auto'
,p_scaling=>'linear'
,p_baseline_scaling=>'zero'
,p_major_tick_rendered=>'auto'
,p_minor_tick_rendered=>'auto'
,p_tick_label_rendered=>'on'
,p_tick_label_rotation=>'auto'
,p_tick_label_position=>'outside'
);
wwv_flow_imp_page.create_jet_chart_axis(
 p_id=>wwv_flow_imp.id(3723197326840228)
,p_chart_id=>wwv_flow_imp.id(3722852163840225)
,p_axis=>'y'
,p_is_rendered=>'on'
,p_format_scaling=>'auto'
,p_scaling=>'linear'
,p_baseline_scaling=>'zero'
,p_position=>'auto'
,p_major_tick_rendered=>'auto'
,p_minor_tick_rendered=>'on'
,p_tick_label_rendered=>'on'
);
wwv_flow_imp.component_end;
end;
/
