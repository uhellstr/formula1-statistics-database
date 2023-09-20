prompt --application/pages/page_00002
begin
--   Manifest
--     PAGE: 00002
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
 p_id=>2
,p_name=>'Pole Position'
,p_alias=>'POLE-POSITION'
,p_page_mode=>'MODAL'
,p_step_title=>'Pole Position'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_protection_level=>'C'
,p_page_component_map=>'03'
,p_last_updated_by=>'UHELLSTR'
,p_last_upd_yyyymmddhh24miss=>'20230913163553'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(4369126452196060)
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
wwv_flow_imp_page.create_report_region(
 p_id=>wwv_flow_imp.id(4369786007196061)
,p_name=>'Pole Position'
,p_template=>wwv_flow_imp.id(3295809033634117)
,p_display_sequence=>10
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--hideHeader:t-Region--scrollBody'
,p_component_template_options=>'#DEFAULT#:t-Report--stretch:t-Report--staticRowColors:t-Report--rowHighlight:t-Report--inline:t-Report--hideNoPagination'
,p_source_type=>'NATIVE_SQL_REPORT'
,p_query_type=>'SQL'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select *',
'from',
'(',
'select givenname',
'       ,familyname',
'       ,constructor',
'       ,count(position) as poleposition',
'from v_f1_cur_season_qualifications',
'where position = 1',
'group by givenname,familyname,constructor',
') order by poleposition desc'))
,p_ajax_enabled=>'Y'
,p_lazy_loading=>false
,p_query_row_template=>wwv_flow_imp.id(3349329571634129)
,p_query_num_rows=>50
,p_query_options=>'DERIVED_REPORT_COLUMNS'
,p_query_no_data_found=>'no data found'
,p_query_num_rows_type=>'NEXT_PREVIOUS_LINKS'
,p_query_row_count_max=>500
,p_pagination_display_position=>'BOTTOM_RIGHT'
,p_prn_output=>'N'
,p_prn_format=>'PDF'
,p_sort_null=>'L'
,p_plug_query_strip_html=>'N'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(4370168507196063)
,p_query_column_id=>1
,p_column_alias=>'GIVENNAME'
,p_column_display_sequence=>1
,p_column_heading=>'Givenname'
,p_use_as_row_header=>'N'
,p_heading_alignment=>'LEFT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(4370567250196063)
,p_query_column_id=>2
,p_column_alias=>'FAMILYNAME'
,p_column_display_sequence=>2
,p_column_heading=>'Familyname'
,p_use_as_row_header=>'N'
,p_heading_alignment=>'LEFT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(4370911099196063)
,p_query_column_id=>3
,p_column_alias=>'CONSTRUCTOR'
,p_column_display_sequence=>3
,p_column_heading=>'Constructor'
,p_use_as_row_header=>'N'
,p_heading_alignment=>'LEFT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(4371354696196063)
,p_query_column_id=>4
,p_column_alias=>'POLEPOSITION'
,p_column_display_sequence=>4
,p_column_heading=>'Poleposition'
,p_use_as_row_header=>'N'
,p_column_alignment=>'RIGHT'
,p_heading_alignment=>'RIGHT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp.component_end;
end;
/
