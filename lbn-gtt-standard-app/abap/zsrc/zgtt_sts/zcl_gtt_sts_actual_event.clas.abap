class ZCL_GTT_STS_ACTUAL_EVENT definition
  public
  create public .

public section.

  interfaces ZIF_GTT_STS_ACTUAL_EVENT .

  types:
    TT_TRACK_CONF type TABLE of ZGTT_TRACK_CONF .

  class-methods GET_TOR_ACTUAL_EVENT_CLASS
    importing
      !IS_EVENT type TRXAS_EVT_CTAB_WA
    returning
      value(RO_ACTUAL_EVENT) type ref to ZIF_GTT_STS_ACTUAL_EVENT
    raising
      CX_UDM_MESSAGE .
  methods GET_STOP
    importing
      !IT_ALL_APPL_TABLES type TRXAS_TABCONTAINER
    returning
      value(RT_STOP) type /SCMTMS/T_EM_BO_TOR_STOP .
  methods GET_CAPA_STOP
    importing
      !IT_ALL_APPL_TABLES type TRXAS_TABCONTAINER
    returning
      value(RT_STOP) type /SCMTMS/T_EM_BO_TOR_STOP .
  methods GET_CAPA_ROOT
    importing
      !IT_ALL_APPL_TABLES type TRXAS_TABCONTAINER
    returning
      value(RT_ROOT) type /SCMTMS/T_EM_BO_TOR_ROOT .
  methods GET_EXECUTION
    importing
      !IT_ALL_APPL_TABLES type TRXAS_TABCONTAINER
      !IV_OLD type ABAP_BOOL default ABAP_FALSE
    exporting
      value(ET_EXECUTION) type /SCMTMS/T_EM_BO_TOR_EXECINFO .
  methods EXTRACT_GENERAL_EVENT_DATA
    importing
      !IS_EXECINFO type /SCMTMS/S_EM_BO_TOR_EXECINFO
      !IV_EVT_CNT type /SAPTRX/EVTCNT
      !IV_EVENTID type /SAPTRX/EVTCNT
      !IS_TRACKINGHEADER type /SAPTRX/BAPI_EVM_HEADER
    changing
      !CS_TRACKINGHEADER type /SAPTRX/BAPI_EVM_HEADER
      !CS_TRACKLOCATION type /SAPTRX/BAPI_EVM_LOCATIONID
      !CT_TRACKPARAMETERS type ZIF_GTT_STS_ACTUAL_EVENT~TT_TRACKPARAMETERS
      !CT_EVENTID_MAP type TRXAS_EVTID_EVTCNT_MAP
    raising
      CX_UDM_MESSAGE .
  methods HANDLE_DELAY_EVENT
    importing
      !IS_TOR_ROOT type /SCMTMS/S_EM_BO_TOR_ROOT
      !IS_EXECINFO type /SCMTMS/S_EM_BO_TOR_EXECINFO
      !IV_EVT_CNT type /SAPTRX/EVTCNT
    changing
      !CS_TRACKLOCATION type /SAPTRX/BAPI_EVM_LOCATIONID
      !CT_TRACKPARAMETERS type ZIF_GTT_STS_ACTUAL_EVENT~TT_TRACKPARAMETERS .
protected section.

  class-data GV_EVENT_COUNT type /SAPTRX/EVTCNT .
  class-data MT_TRACK_CONF type TT_TRACK_CONF .

  methods GET_MODEL_EVENT_ID
    importing
      !IV_STANDARD_EVENT_ID type /SAPTRX/EV_EVTID
    returning
      value(RV_MODEL_EVENT_ID) type /SAPTRX/EV_EVTID .
  methods CHECK_APPLICATION_EVENT_SOURCE
    importing
      !IT_ALL_APPL_TABLES type TRXAS_TABCONTAINER
      !IV_EVENT_CODE type /SCMTMS/TOR_EVENT
      !IS_EVENT type TRXAS_EVT_CTAB_WA
    exporting
      !EV_RESULT like SY-BINPT .
  methods CHECK_TOR_SENT_TO_GTT
    importing
      !IS_EVENT type TRXAS_EVT_CTAB_WA
    exporting
      !EV_IS_SENT type ABAP_BOOL .
  methods CHECK_TRXSERVERNAME
    importing
      !IS_EVENT type TRXAS_EVT_CTAB_WA
    exporting
      !EV_RESULT like SY-BINPT .
  methods CHECK_TOR_TYPE_SPECIFIC_EVENTS
    importing
      !IV_EVENT_CODE type /SCMTMS/TOR_EVENT
    returning
      value(EV_RESULT) like SY-BINPT .
private section.

  methods ADD_ADDITIONAL_MATCH_KEY
    importing
      !IV_EXECUTION_INFO_SOURCE type /SCMTMS/EXECINFO_SOURCE
      !IV_EVTCNT type /SAPTRX/EVTCNT
    changing
      !CT_TRACKPARAMETERS type ZIF_GTT_STS_ACTUAL_EVENT=>TT_TRACKPARAMETERS .
ENDCLASS.



CLASS ZCL_GTT_STS_ACTUAL_EVENT IMPLEMENTATION.


  METHOD add_additional_match_key.
    IF iv_execution_info_source = /scmtms/if_tor_const=>sc_tor_event_source-prop_predecessor.
      INSERT VALUE #( evtcnt      = iv_evtcnt
                      param_name  = zif_gtt_sts_ef_constants=>cs_parameter-additional_match_key
                      param_value = 'TMFU' ) INTO TABLE ct_trackparameters.
    ENDIF.
  ENDMETHOD.


  METHOD check_application_event_source.

    FIELD-SYMBOLS <ls_tor_root> TYPE /scmtms/s_em_bo_tor_root.

    CLEAR ev_result.

    get_execution(
      EXPORTING
        it_all_appl_tables = it_all_appl_tables
      IMPORTING
        et_execution      = DATA(lt_tor_execinfo) ).

    get_execution(
      EXPORTING
        it_all_appl_tables = it_all_appl_tables
        iv_old            = abap_true
      IMPORTING
        et_execution      = DATA(lt_tor_execinfo_old) ).

    ASSIGN is_event-maintabref->* TO <ls_tor_root>.

    LOOP AT lt_tor_execinfo ASSIGNING FIELD-SYMBOL(<ls_tor_execinfo>) WHERE parent_node_id = <ls_tor_root>-node_id.

      ASSIGN lt_tor_execinfo_old[ KEY node_id COMPONENTS node_id = <ls_tor_execinfo>-node_id ]
        TO FIELD-SYMBOL(<ls_tor_execinfo_old>).
      IF ( sy-subrc = 0 AND <ls_tor_execinfo_old> <> <ls_tor_execinfo> ) OR sy-subrc <> 0 ##BOOL_OK.

        CHECK <ls_tor_execinfo>-event_code = iv_event_code.
        CHECK NOT ( <ls_tor_execinfo>-execinfo_source = /scmtms/if_tor_const=>sc_tor_event_source-application OR
                    <ls_tor_execinfo>-execinfo_source = /scmtms/if_tor_const=>sc_tor_event_source-prop_predecessor OR
                    <ls_tor_execinfo>-execinfo_source = /scmtms/if_tor_const=>sc_tor_event_source-prop_successor ).
        ev_result = zif_gtt_sts_ef_constants=>cs_condition-false.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.


  METHOD check_tor_sent_to_gtt.

    FIELD-SYMBOLS: <ls_tor_root> TYPE /scmtms/s_em_bo_tor_root.

    CLEAR ev_is_sent.

    ASSIGN is_event-maintabref->* TO <ls_tor_root>.
    IF sy-subrc <> 0.
      RETURN.
    ENDIF.

    IF <ls_tor_root>-tspid IS NOT INITIAL AND
        <ls_tor_root>-lifecycle = zif_gtt_sts_constants=>cs_lifecycle_status-in_process OR
        <ls_tor_root>-lifecycle = zif_gtt_sts_constants=>cs_lifecycle_status-completed AND
      ( <ls_tor_root>-execution = zif_gtt_sts_constants=>cs_execution_status-in_execution OR
        <ls_tor_root>-execution = zif_gtt_sts_constants=>cs_execution_status-executed OR
        <ls_tor_root>-execution = zif_gtt_sts_constants=>cs_execution_status-ready_for_transp_exec ).
      ev_is_sent = abap_true.
    ELSE.
      ev_is_sent = abap_false.
    ENDIF.

  ENDMETHOD.


  METHOD check_tor_type_specific_events.
    RETURN.
  ENDMETHOD.


  METHOD check_trxservername.

    FIELD-SYMBOLS <ls_tor_root> TYPE /scmtms/s_em_bo_tor_root.

    CLEAR ev_result.

    ASSIGN is_event-maintabref->* TO <ls_tor_root>.

    TEST-SEAM lv_trxservername.
      SELECT SINGLE /saptrx/aotypes~trxservername
        FROM /scmtms/c_torty
        JOIN /saptrx/aotypes ON /scmtms/c_torty~aotype = /saptrx/aotypes~aotype
        INTO @DATA(lv_trxservername)
        WHERE /scmtms/c_torty~type         = @<ls_tor_root>-tor_type AND
              /saptrx/aotypes~trk_obj_type = @zif_gtt_sts_actual_event~cv_tor_trk_obj_typ ##WARN_OK. "#EC CI_BUFFJOIN
    END-TEST-SEAM.
    IF is_event-trxservername <> lv_trxservername.
      ev_result = zif_gtt_sts_ef_constants=>cs_condition-false.
    ENDIF.

  ENDMETHOD.


  METHOD extract_general_event_data.

    DATA:
      ls_eventid_map          TYPE trxas_evtid_evtcnt_map_wa,
      ls_trackparameters      TYPE /saptrx/bapi_evm_parameters,
      ls_loc_root             TYPE /scmtms/s_bo_loc_root_k,
      ls_loc_geo_addr_details TYPE /scmtms/s_bo_loc_addr_detailsk,
      ls_loc_descr            TYPE /scmtms/s_bo_loc_description_k.

    ls_eventid_map-eventid = iv_eventid.
    ls_eventid_map-evtcnt  = iv_evt_cnt.
    APPEND ls_eventid_map TO ct_eventid_map.

    cs_trackingheader        = is_trackingheader.
    cs_trackingheader-evtcnt = iv_evt_cnt.
    cs_tracklocation-evtcnt  = iv_evt_cnt.
    cs_tracklocation-addnum  = iv_evt_cnt.

    IF cs_trackingheader-datacs IS INITIAL AND cs_trackingheader-dataid IS INITIAL.
      cs_trackingheader-datacs  = is_execinfo-datacs.
      cs_trackingheader-dataid  = is_execinfo-dataid.
    ENDIF.

    IF is_execinfo-event_reason IS NOT INITIAL.
      cs_trackingheader-srctx = is_execinfo-event_reason.
    ENDIF.

    IF is_execinfo-actual_date IS NOT INITIAL.
      cs_trackingheader-evttst = is_execinfo-actual_date.
      IF is_execinfo-actual_tzone IS NOT INITIAL.
        CALL FUNCTION 'IB_CONVERT_FROM_TIMESTAMP'
          EXPORTING
            i_timestamp = is_execinfo-actual_date
            i_tzone     = is_execinfo-actual_tzone
          IMPORTING
            e_datlo     = cs_trackingheader-evtdat
            e_timlo     = cs_trackingheader-evttim.
      ENDIF.
    ENDIF.

    CLEAR ls_loc_root.
    CLEAR ls_loc_geo_addr_details.
    CLEAR ls_loc_descr.

    " Note: 2276001
    cs_trackingheader-srcid  = is_execinfo-event_reason_code.
    IF is_execinfo-sndid IS NOT INITIAL.                          " Note: 2280769
      cs_trackingheader-sndid = is_execinfo-sndid.
    ENDIF.                                                        " Note: 2280769
    IF is_execinfo-sndcod IS NOT INITIAL.                         " Note: 2280769
      cs_trackingheader-sndcod = is_execinfo-sndcod.
    ENDIF.                                                        " Note: 2280769

    cs_trackingheader-msgsrctyp = /scmtms/cl_scem_int_c=>sc_ev_srctyp-tm.

    IF is_execinfo-ext_loc_id IS NOT INITIAL.
      /scmtms/cl_em_tm_helper=>get_loc_descr(
        EXPORTING
          iv_loc_id               = is_execinfo-ext_loc_id
          iv_loc_uuid             = is_execinfo-ext_loc_uuid
        CHANGING
          cs_loc_geo_addr_details = ls_loc_geo_addr_details
          cs_loc_root             = ls_loc_root
          cs_loc_descr            = ls_loc_descr ).
    ENDIF.

    cs_trackingheader-evtzon  = ls_loc_root-time_zone_code.
    cs_tracklocation-locnam   = ls_loc_descr-loc_description.

    IF is_execinfo-actual_tzone IS NOT INITIAL.
      cs_trackingheader-evtzon = is_execinfo-actual_tzone.
    ENDIF.

    CLEAR ls_trackparameters.
    ls_trackparameters-evtcnt      = cs_trackingheader-evtcnt.
    ls_trackparameters-param_name  = zif_gtt_sts_ef_constants=>cs_system_fields-actual_technical_timezone.
    ls_trackparameters-param_value = zcl_gtt_sts_tools=>get_system_time_zone( ).
    APPEND ls_trackparameters TO ct_trackparameters.

    CLEAR ls_trackparameters.
    ls_trackparameters-evtcnt      = cs_trackingheader-evtcnt.
    ls_trackparameters-param_name  = zif_gtt_sts_ef_constants=>cs_system_fields-actual_technical_datetime.
    ls_trackparameters-param_value = zcl_gtt_sts_tools=>get_system_date_time( ).
    APPEND ls_trackparameters TO ct_trackparameters.

  ENDMETHOD.


  METHOD get_capa_root.

    FIELD-SYMBOLS <lt_capa_root> TYPE /scmtms/t_em_bo_tor_root.
    ASSIGN it_all_appl_tables[ tabledef = /scmtms/cl_scem_int_c=>sc_table_definition-bo_tor-capa_root ]-tableref
      TO FIELD-SYMBOL(<lr_tabref>).
    IF sy-subrc = 0.
      ASSIGN <lr_tabref>->* TO <lt_capa_root>.
      IF sy-subrc = 0.
        rt_root = <lt_capa_root>.
      ENDIF.
    ENDIF.

  ENDMETHOD.


  METHOD get_capa_stop.

    FIELD-SYMBOLS <lt_capa_stop> TYPE /scmtms/t_em_bo_tor_stop.
    ASSIGN it_all_appl_tables[ tabledef = /scmtms/cl_scem_int_c=>sc_table_definition-bo_tor-capa_stop ]-tableref
      TO FIELD-SYMBOL(<lr_tabref>).
    IF sy-subrc = 0.
      ASSIGN <lr_tabref>->* TO <lt_capa_stop>.
      IF sy-subrc = 0.
        rt_stop = <lt_capa_stop>.
      ENDIF.
    ENDIF.

  ENDMETHOD.


  METHOD get_execution.

    FIELD-SYMBOLS <lt_execution> TYPE /scmtms/t_em_bo_tor_execinfo.
    CLEAR et_execution.
    ASSIGN it_all_appl_tables[ tabledef = SWITCH #( iv_old WHEN abap_false
                                                             THEN zif_gtt_sts_actual_event~cs_tabledef-tor_execution_info
                                                          ELSE  zif_gtt_sts_actual_event~cs_tabledef-tor_execution_info_before )
                             ]-tableref TO FIELD-SYMBOL(<lr_tabref>).
    IF sy-subrc = 0.
      ASSIGN <lr_tabref>->* TO <lt_execution>.
      IF sy-subrc = 0.
        et_execution = <lt_execution>.
      ENDIF.
    ENDIF.

  ENDMETHOD.


  METHOD get_model_event_id.

    CASE iv_standard_event_id.
      WHEN zif_gtt_sts_actual_event~cs_event_id-standard-arrival.
        rv_model_event_id = zif_gtt_sts_actual_event~cs_event_id-model-shp_arrival.
      WHEN zif_gtt_sts_actual_event~cs_event_id-standard-departure.
        rv_model_event_id = zif_gtt_sts_actual_event~cs_event_id-model-shp_departure.
      WHEN zif_gtt_sts_actual_event~cs_event_id-standard-pod.
        rv_model_event_id = zif_gtt_sts_actual_event~cs_event_id-model-shp_pod.
      WHEN zif_gtt_sts_actual_event~cs_event_id-standard-popu.
        rv_model_event_id = zif_gtt_sts_actual_event~cs_event_id-model-popu.
      WHEN zif_gtt_sts_actual_event~cs_event_id-standard-load_begin.
        rv_model_event_id = zif_gtt_sts_actual_event~cs_event_id-model-load_start.
      WHEN zif_gtt_sts_actual_event~cs_event_id-standard-load_end.
        rv_model_event_id = zif_gtt_sts_actual_event~cs_event_id-model-load_end.
      WHEN zif_gtt_sts_actual_event~cs_event_id-standard-coupling.
        rv_model_event_id = zif_gtt_sts_actual_event~cs_event_id-model-coupling.
      WHEN zif_gtt_sts_actual_event~cs_event_id-standard-decoupling.
        rv_model_event_id = zif_gtt_sts_actual_event~cs_event_id-model-decoupling.
      WHEN zif_gtt_sts_actual_event~cs_event_id-standard-unload_begin.
        rv_model_event_id = zif_gtt_sts_actual_event~cs_event_id-model-unload_begin.
      WHEN zif_gtt_sts_actual_event~cs_event_id-standard-unload_end.
        rv_model_event_id = zif_gtt_sts_actual_event~cs_event_id-model-unload_end.
      WHEN zif_gtt_sts_actual_event~cs_event_id-standard-delay.
        rv_model_event_id = zif_gtt_sts_actual_event~cs_event_id-model-delay.
      WHEN zif_gtt_sts_actual_event~cs_event_id-standard-delay_fu.
        rv_model_event_id = zif_gtt_sts_actual_event~cs_event_id-model-delay.
      WHEN OTHERS.
        RETURN.
    ENDCASE.

  ENDMETHOD.


  METHOD get_stop.

    FIELD-SYMBOLS <lt_stop> TYPE /scmtms/t_em_bo_tor_stop.
    ASSIGN it_all_appl_tables[ tabledef = zif_gtt_sts_actual_event~cs_tabledef-tor_stop ]-tableref
      TO FIELD-SYMBOL(<lr_tabref>) ##WARN_OK.
    IF sy-subrc = 0.
      ASSIGN <lr_tabref>->* TO <lt_stop>.
      IF sy-subrc = 0.
        rt_stop = <lt_stop>.
      ENDIF.
    ENDIF.

  ENDMETHOD.


  METHOD get_tor_actual_event_class.

    FIELD-SYMBOLS <ls_tor_root> TYPE /scmtms/s_em_bo_tor_root.
    ASSIGN is_event-maintabref->* TO <ls_tor_root>.
    IF sy-subrc <> 0.
      MESSAGE e010(zgtt_sts) INTO DATA(lv_dummy) ##needed.
      zcl_gtt_sts_tools=>throw_exception( ).
    ENDIF.

*   Get configuration data
    IF mt_track_conf IS INITIAL.
      zcl_gtt_sts_tools=>get_track_conf(
        IMPORTING
          et_conf = mt_track_conf ).
    ENDIF.

    READ TABLE mt_track_conf INTO DATA(ls_track_conf)
      WITH KEY tor_type = <ls_tor_root>-tor_type.
    IF sy-subrc = 0.
      CASE <ls_tor_root>-tor_cat.
        WHEN /scmtms/if_tor_const=>sc_tor_category-active.
          CASE ls_track_conf-track_option.
            WHEN zif_gtt_sts_constants=>cs_tracking_scenario-fo_track.
              ro_actual_event = NEW zcl_gtt_sts_fo_actual_event( ).
            WHEN zif_gtt_sts_constants=>cs_tracking_scenario-tu_on_fo.
              ro_actual_event = NEW zcl_gtt_sts_trk_onfo_fo_actevt( ).
            WHEN zif_gtt_sts_constants=>cs_tracking_scenario-tu_on_fu.
              ro_actual_event = NEW zcl_gtt_sts_trk_onfu_fo_actevt( ).
            WHEN zif_gtt_sts_constants=>cs_tracking_scenario-tu_on_cu.
              ro_actual_event = NEW zcl_gtt_sts_trk_oncu_fo_actevt( ).
            WHEN OTHERS.
          ENDCASE.

        WHEN /scmtms/if_tor_const=>sc_tor_category-booking.
          CASE ls_track_conf-track_option.
            WHEN zif_gtt_sts_constants=>cs_tracking_scenario-fo_track.
              ro_actual_event = NEW zcl_gtt_sts_fb_actual_event( ).
            WHEN zif_gtt_sts_constants=>cs_tracking_scenario-tu_on_fo.
              ro_actual_event = NEW zcl_gtt_sts_trk_onfo_fb_actevt( ).
            WHEN zif_gtt_sts_constants=>cs_tracking_scenario-tu_on_fu.
              ro_actual_event = NEW zcl_gtt_sts_trk_onfu_fb_actevt( ).
            WHEN zif_gtt_sts_constants=>cs_tracking_scenario-tu_on_cu.
              ro_actual_event = NEW zcl_gtt_sts_trk_oncu_fb_actevt( ).
            WHEN OTHERS.
          ENDCASE.

        WHEN /scmtms/if_tor_const=>sc_tor_category-freight_unit.
          CASE ls_track_conf-track_option.
            WHEN zif_gtt_sts_constants=>cs_tracking_scenario-fo_track.
              ro_actual_event = NEW zcl_gtt_sts_fu_actual_event( ).
            WHEN zif_gtt_sts_constants=>cs_tracking_scenario-tu_on_fo.
              ro_actual_event = NEW zcl_gtt_sts_trk_onfo_fu_actevt( ).
            WHEN zif_gtt_sts_constants=>cs_tracking_scenario-tu_on_fu.
              ro_actual_event = NEW zcl_gtt_sts_trk_onfu_fu_actevt( ).
            WHEN zif_gtt_sts_constants=>cs_tracking_scenario-tu_on_cu.
              ro_actual_event = NEW zcl_gtt_sts_trk_oncu_fu_actevt( ).
            WHEN OTHERS.
          ENDCASE.
        WHEN OTHERS.
      ENDCASE.
    ELSE.
      CASE <ls_tor_root>-tor_cat.
        WHEN /scmtms/if_tor_const=>sc_tor_category-active.
          ro_actual_event = NEW zcl_gtt_sts_fo_actual_event( ).
        WHEN /scmtms/if_tor_const=>sc_tor_category-booking.
          ro_actual_event = NEW zcl_gtt_sts_fb_actual_event( ).
        WHEN /scmtms/if_tor_const=>sc_tor_category-freight_unit.
          ro_actual_event = NEW zcl_gtt_sts_fu_actual_event( ).
        WHEN OTHERS.
      ENDCASE.
    ENDIF.

  ENDMETHOD.


  METHOD handle_delay_event.

    DATA:
      lt_execinfo_tr TYPE /scmtms/t_tor_exec_tr_k,
      lv_timezone    TYPE /scmtms/tzone,
      lv_locno       TYPE /sapapo/locno,
      lv_loctype     TYPE /saptrx/loc_id_type,
      lv_ref_evt     TYPE /scmtms/tor_event,
      lv_estimated   TYPE string.

    DATA(lo_tor_srv_mgr) = /bobf/cl_tra_serv_mgr_factory=>get_service_manager( iv_bo_key = /scmtms/if_tor_c=>sc_bo_key ).
    TEST-SEAM lt_execinfo_tr.
      lo_tor_srv_mgr->retrieve_by_association(
        EXPORTING
          iv_node_key    = /scmtms/if_tor_c=>sc_node-root
          it_key         = VALUE #( ( key = is_tor_root-node_id ) )
          iv_association = /scmtms/if_tor_c=>sc_association-root-executioninformation_tr
          iv_fill_data   = abap_true
        IMPORTING
          et_data        = lt_execinfo_tr ).
    END-TEST-SEAM.

    ASSIGN lt_execinfo_tr[ parent_key   = is_execinfo-parent_node_id
                           execution_id = is_execinfo-execution_id ] TO FIELD-SYMBOL(<ls_execinfo_tr>) ##PRIMKEY
                                                                                                       ##WARN_OK.
    IF sy-subrc = 0.
      IF <ls_execinfo_tr>-estimated_date IS NOT INITIAL.
        lv_estimated = <ls_execinfo_tr>-estimated_date.
        CONDENSE lv_estimated NO-GAPS.
        INSERT VALUE #( evtcnt      = iv_evt_cnt
                        param_name  = zif_gtt_sts_ef_constants=>cs_parameter-estimated_datetime
                        param_index = 1
                        param_value = lv_estimated ) INTO TABLE ct_trackparameters.

        INSERT VALUE #( evtcnt      = iv_evt_cnt
                       param_name  = zif_gtt_sts_ef_constants=>cs_parameter-stop_id
                       param_index = 1
                       param_value = cs_tracklocation-locid2 ) INTO TABLE ct_trackparameters.

        IF <ls_execinfo_tr>-actual_date_tz_em IS NOT INITIAL.
          lv_timezone = <ls_execinfo_tr>-actual_date_tz_em.
        ELSE.
          lv_timezone = <ls_execinfo_tr>-actual_tzone.
        ENDIF.

        IF lv_timezone IS NOT INITIAL.
          INSERT VALUE #( evtcnt      = iv_evt_cnt
                          param_name  = zif_gtt_sts_ef_constants=>cs_parameter-estimated_timezone
                          param_index = 1
                          param_value = lv_timezone ) INTO TABLE ct_trackparameters.
        ENDIF.
      ENDIF.
    ENDIF.

    lv_ref_evt = is_execinfo-ref_event_code.

    IF lv_ref_evt IS NOT INITIAL.
      INSERT VALUE #( evtcnt      = iv_evt_cnt
                      param_name  = zif_gtt_sts_ef_constants=>cs_parameter-ref_planned_event_milestone
                      param_value = lv_ref_evt ) INTO TABLE ct_trackparameters.
    ENDIF.

    lv_locno = cs_tracklocation-locid1.
    lv_loctype = zcl_gtt_sts_tools=>get_location_type( iv_locno = lv_locno ).

    IF lv_locno IS NOT INITIAL.

      INSERT VALUE #( evtcnt      = iv_evt_cnt
                      param_name  = zif_gtt_sts_ef_constants=>cs_parameter-ref_planned_event_loctype
                      param_value = lv_loctype ) INTO TABLE ct_trackparameters.

      INSERT VALUE #( evtcnt      = iv_evt_cnt
                      param_name  = zif_gtt_sts_ef_constants=>cs_parameter-ref_planned_event_locid1
                      param_value = cs_tracklocation-locid1 ) INTO TABLE ct_trackparameters.

      INSERT VALUE #( evtcnt      = iv_evt_cnt
                      param_name  = zif_gtt_sts_ef_constants=>cs_parameter-ref_planned_event_locid2
                      param_value = cs_tracklocation-locid2 ) INTO TABLE ct_trackparameters.
    ENDIF.

    CLEAR: cs_tracklocation-loccod,
           cs_tracklocation-locid1,
           cs_tracklocation-locid2.

  ENDMETHOD.


  METHOD zif_gtt_sts_actual_event~check_event_relevance.

    CLEAR ev_result.

    IF check_tor_type_specific_events( iv_event_code ) = zif_gtt_sts_ef_constants=>cs_condition-false.
      RETURN.
    ENDIF.

    check_application_event_source(
      EXPORTING
        it_all_appl_tables = it_all_appl_tables
        iv_event_code     = iv_event_code
        is_event           = is_event
      IMPORTING
        ev_result          = ev_result ).
    IF ev_result = zif_gtt_sts_ef_constants=>cs_condition-false.
      RETURN.
    ENDIF.

    check_tor_sent_to_gtt(
      EXPORTING
        is_event    = is_event
      IMPORTING
        ev_is_sent = DATA(lv_is_sent) ).
    IF lv_is_sent = abap_false.
      ev_result = zif_gtt_sts_ef_constants=>cs_condition-false.
      RETURN.
    ENDIF.

    check_trxservername(
      EXPORTING
        is_event  = is_event
      IMPORTING
        ev_result = ev_result ).

  ENDMETHOD.


  METHOD zif_gtt_sts_actual_event~extract_event.

    DATA:
      ls_trackingheader TYPE /saptrx/bapi_evm_header,
      ls_tracklocation  TYPE /saptrx/bapi_evm_locationid,
      lv_loctype        TYPE /saptrx/loc_id_type,
      lv_locno          TYPE /sapapo/locno.

    FIELD-SYMBOLS <ls_root> TYPE /scmtms/s_em_bo_tor_root.

    extract_general_event_data(
      EXPORTING
        is_execinfo        = is_execinfo
        iv_evt_cnt         = iv_evt_cnt
        iv_eventid         = is_event-eventid
        is_trackingheader  = is_trackingheader
      CHANGING
        cs_trackingheader  = ls_trackingheader
        cs_tracklocation   = ls_tracklocation
        ct_trackparameters = ct_trackparameters
        ct_eventid_map     = ct_eventid_map ).

    add_additional_match_key(
      EXPORTING
        iv_evtcnt                = iv_evt_cnt
        iv_execution_info_source = is_execinfo-execinfo_source
      CHANGING
        ct_trackparameters       = ct_trackparameters ).

    ASSIGN is_event-maintabref->* TO <ls_root>.
    IF sy-subrc <> 0.
      RETURN.
    ENDIF.

    DATA(lt_stop) = get_stop( it_all_appl_tables ).
    zcl_gtt_sts_tools=>get_stop_points(
      EXPORTING
        iv_root_id     = <ls_root>-tor_id
        it_stop        = VALUE #( FOR <ls_stop> IN lt_stop USING KEY parent_seqnum
                                  WHERE ( parent_node_id = <ls_root>-node_id ) ( <ls_stop> ) )
      IMPORTING
        et_stop_points = DATA(lt_stop_points) ).

    lv_locno = is_execinfo-ext_loc_id.
    ls_tracklocation-loccod = zcl_gtt_sts_tools=>get_location_type( iv_locno = lv_locno ).
    ls_tracklocation-locid1 = is_execinfo-ext_loc_id.

    ASSIGN lt_stop_points[ log_locid = is_execinfo-ext_loc_id ]-stop_id TO FIELD-SYMBOL(<lv_stop_id>) ##WARN_OK.
    IF sy-subrc = 0.
      SHIFT <lv_stop_id> LEFT DELETING LEADING '0'.
      ls_tracklocation-locid2 = <lv_stop_id>.
    ENDIF.

    IF iv_event_code = /scmtms/if_tor_const=>sc_tor_event-delay OR
       iv_event_code = /scmtms/if_tor_const=>sc_tor_event-delay_fu.
      handle_delay_event(
        EXPORTING
          is_tor_root        = <ls_root>
          is_execinfo        = is_execinfo
          iv_evt_cnt         = ls_trackingheader-evtcnt
        CHANGING
          cs_tracklocation   = ls_tracklocation
          ct_trackparameters = ct_trackparameters ).
    ENDIF.

    APPEND ls_trackingheader TO ct_trackingheader.
    APPEND ls_tracklocation TO ct_tracklocation.

  ENDMETHOD.


  METHOD zif_gtt_sts_actual_event~process_actual_event.

    FIELD-SYMBOLS: <ls_tor_root> TYPE /scmtms/s_em_bo_tor_root.
    DATA:
      ls_trackingheader TYPE /saptrx/bapi_evm_header,
      lv_tmp_fotrxcod   TYPE /saptrx/trxcod,
      lv_tmp_futrxcod   TYPE /saptrx/trxcod,
      lv_fotrxcod       TYPE /saptrx/trxcod,
      lv_futrxcod       TYPE /saptrx/trxcod.

    get_execution(
      EXPORTING
        it_all_appl_tables = it_all_appl_tables
      IMPORTING
        et_execution      = DATA(lt_tor_execinfo) ).

    get_execution(
      EXPORTING
        it_all_appl_tables = it_all_appl_tables
        iv_old            = abap_true
      IMPORTING
        et_execution      = DATA(lt_tor_execinfo_before) ).

    LOOP AT it_events ASSIGNING FIELD-SYMBOL(<ls_event>).

      CLEAR ls_trackingheader.
      ls_trackingheader-language = sy-langu.
      ls_trackingheader-evtid    = get_model_event_id( CONV #( iv_event_code ) ).

      DATA(zcl_gtt_sts_tor_actual_event) = get_tor_actual_event_class( <ls_event> ).
      CHECK zcl_gtt_sts_tor_actual_event is BOUND.
      ASSIGN <ls_event>-maintabref->* TO <ls_tor_root>.
      CHECK sy-subrc = 0.

      ls_trackingheader-trxid = |{ <ls_tor_root>-tor_id ALPHA = OUT }|.

      CASE <ls_tor_root>-tor_cat.
        WHEN /scmtms/if_tor_const=>sc_tor_category-active.
          ls_trackingheader-trxcod = zif_gtt_sts_constants=>cs_trxcod-fo_number.
        WHEN /scmtms/if_tor_const=>sc_tor_category-booking.
          ls_trackingheader-trxcod = zif_gtt_sts_constants=>cs_trxcod-fo_number.
        WHEN /scmtms/if_tor_const=>sc_tor_category-freight_unit.
          ls_trackingheader-trxcod = zif_gtt_sts_constants=>cs_trxcod-fu_number.
      ENDCASE.

      GET TIME STAMP FIELD DATA(lv_timestamp).
      ls_trackingheader-evttst = lv_timestamp.
      ls_trackingheader-sndnam = /scmtms/cl_scem_int_c=>gc_sendername_tm.

      " lt_tor_execinfo is SORTED by parent_node_id event_code
      READ TABLE lt_tor_execinfo TRANSPORTING NO FIELDS
        WITH KEY parent_node_id = <ls_tor_root>-node_id
                 event_code     = iv_event_code.

      LOOP AT lt_tor_execinfo ASSIGNING FIELD-SYMBOL(<ls_tor_execinfo>) FROM sy-tabix.
        IF <ls_tor_execinfo>-parent_node_id <> <ls_tor_root>-node_id OR
           <ls_tor_execinfo>-event_code     <> iv_event_code.
          EXIT.
        ENDIF.

        READ TABLE lt_tor_execinfo_before WITH KEY node_id COMPONENTS node_id = <ls_tor_execinfo>-node_id
          ASSIGNING FIELD-SYMBOL(<ls_tor_execinfo_before>).
        IF ( sy-subrc = 0 AND <ls_tor_execinfo_before> <> <ls_tor_execinfo> ) OR  sy-subrc <> 0 ##BOOL_OK.

          zcl_gtt_sts_actual_event=>gv_event_count += 1.

          zcl_gtt_sts_tor_actual_event->extract_event(
            EXPORTING
              is_execinfo           = <ls_tor_execinfo>
              iv_evt_cnt            = zcl_gtt_sts_actual_event=>gv_event_count
              is_event              = <ls_event>
              is_trackingheader     = ls_trackingheader
              it_all_appl_tables    = it_all_appl_tables
              iv_event_code         = iv_event_code
            CHANGING
              ct_trackingheader     = ct_trackingheader
              ct_tracklocation      = ct_tracklocation
              ct_trackparameters    = ct_trackparameters
              ct_eventid_map        = ct_eventid_map ).

        ENDIF.
      ENDLOOP.
    ENDLOOP.

  ENDMETHOD.
ENDCLASS.
