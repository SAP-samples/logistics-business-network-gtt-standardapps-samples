class ZCL_GTT_STS_FU_ACTUAL_EVENT definition
  public
  inheriting from ZCL_GTT_STS_ACTUAL_EVENT
  create public .

public section.

  methods ZIF_GTT_STS_ACTUAL_EVENT~CHECK_EVENT_RELEVANCE
    redefinition .
  methods ZIF_GTT_STS_ACTUAL_EVENT~EXTRACT_EVENT
    redefinition .
protected section.

  methods CHECK_TOR_SENT_TO_GTT
    redefinition .
  methods CHECK_TOR_TYPE_SPECIFIC_EVENTS
    redefinition .
  methods CHECK_APPLICATION_EVENT_SOURCE
    redefinition .
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_GTT_STS_FU_ACTUAL_EVENT IMPLEMENTATION.


  METHOD check_tor_sent_to_gtt.

    FIELD-SYMBOLS: <ls_tor_root> TYPE /scmtms/s_em_bo_tor_root.

    CLEAR ev_is_sent.

    ASSIGN is_event-maintabref->* TO <ls_tor_root>.
    IF sy-subrc <> 0.
      RETURN.
    ENDIF.

    IF <ls_tor_root>-lifecycle = zif_gtt_sts_constants=>cs_lifecycle_status-in_process OR
       <ls_tor_root>-lifecycle = zif_gtt_sts_constants=>cs_lifecycle_status-completed.
      ev_is_sent = abap_true.
    ELSE.
      ev_is_sent = abap_false.
    ENDIF.

    zcl_gtt_sts_tools=>get_gtt_relev_flag_by_aot_type(
      EXPORTING
        iv_aotype     = <ls_tor_root>-aotype
      RECEIVING
        rv_torelevant = DATA(lv_torelevant) ).
    IF lv_torelevant = abap_false.
      ev_is_sent = abap_false.
    ENDIF.

  ENDMETHOD.


  METHOD check_tor_type_specific_events.

    IF iv_event_code <> /scmtms/if_tor_const=>sc_tor_event-departure    AND
       iv_event_code <> /scmtms/if_tor_const=>sc_tor_event-arriv_dest   AND
       iv_event_code <> /scmtms/if_tor_const=>sc_tor_event-popu         AND
       iv_event_code <> /scmtms/if_tor_const=>sc_tor_event-pod          AND
       iv_event_code <> /scmtms/if_tor_const=>sc_tor_event-load_begin   AND
       iv_event_code <> /scmtms/if_tor_const=>sc_tor_event-load_end     AND
       iv_event_code <> /scmtms/if_tor_const=>sc_tor_event-unload_begin AND
       iv_event_code <> /scmtms/if_tor_const=>sc_tor_event-unload_end   AND
       iv_event_code <> /scmtms/if_tor_const=>sc_tor_event-coupling     AND
       iv_event_code <> /scmtms/if_tor_const=>sc_tor_event-decoupling   AND
       iv_event_code <> /scmtms/if_tor_const=>sc_tor_event-delay        AND
       iv_event_code <> /scmtms/if_tor_const=>sc_tor_event-delay_fu.
      ev_result = zif_gtt_sts_ef_constants=>cs_condition-false.
    ENDIF.

  ENDMETHOD.


  METHOD zif_gtt_sts_actual_event~extract_event.

    DATA:
      ls_trackingheader TYPE /saptrx/bapi_evm_header,
      ls_tracklocation  TYPE /saptrx/bapi_evm_locationid,
      lv_stop_category  TYPE /scmtms/tor_category,
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

    ASSIGN is_event-maintabref->* TO <ls_root>.
    IF sy-subrc <> 0.
      RETURN.
    ENDIF.

    DATA(lt_stop) = get_stop( it_all_appl_tables ).
    lv_locno = is_execinfo-ext_loc_id.
    ls_tracklocation-loccod = zcl_gtt_sts_tools=>get_location_type( iv_locno = lv_locno ).
    ls_tracklocation-locid1 = is_execinfo-ext_loc_id.

    zcl_gtt_sts_tools=>get_reqcapa_info_mul(
      EXPORTING
        ir_root          = REF #( <ls_root> )
        iv_old_data      = abap_false
      IMPORTING
        et_req2capa_info = DATA(lt_req2capa_info) ).

    LOOP AT lt_stop ASSIGNING FIELD-SYMBOL(<ls_stop>) USING KEY parent_seqnum WHERE parent_node_id = <ls_root>-node_id.
      IF <ls_stop>-seq_num = 1.
        DATA(lv_first_location) = <ls_stop>-log_locid.
      ENDIF.
      DATA(lv_last_location) = <ls_stop>-log_locid.
    ENDLOOP.

    IF ls_tracklocation-locid1 = lv_first_location OR ls_tracklocation-locid1 = lv_last_location.
      ASSIGN lt_stop[ parent_node_id = <ls_root>-node_id
                      log_locid      = ls_tracklocation-locid1 ] TO <ls_stop> ##WARN_OK.
    ELSE.
      IF iv_event_code = /scmtms/if_tor_const=>sc_tor_event-departure  OR
         iv_event_code = /scmtms/if_tor_const=>sc_tor_event-popu       OR
         iv_event_code = /scmtms/if_tor_const=>sc_tor_event-load_begin OR
         iv_event_code = /scmtms/if_tor_const=>sc_tor_event-load_end   OR
         iv_event_code = /scmtms/if_tor_const=>sc_tor_event-coupling.
        lv_stop_category = /scmtms/if_tor_const=>sc_tor_stop_cat-outbound.
      ELSEIF iv_event_code = /scmtms/if_tor_const=>sc_tor_event-arriv_dest   OR
             iv_event_code = /scmtms/if_tor_const=>sc_tor_event-pod          OR
             iv_event_code = /scmtms/if_tor_const=>sc_tor_event-unload_begin OR
             iv_event_code = /scmtms/if_tor_const=>sc_tor_event-unload_end   OR
             iv_event_code = /scmtms/if_tor_const=>sc_tor_event-decoupling   OR
             iv_event_code = /scmtms/if_tor_const=>sc_tor_event-delay.
        lv_stop_category = /scmtms/if_tor_const=>sc_tor_stop_cat-inbound.
      ENDIF.
      ASSIGN lt_stop[ parent_node_id = <ls_root>-node_id
                      log_locid      = ls_tracklocation-locid1
                      stop_cat       = lv_stop_category ] TO <ls_stop> ##WARN_OK.
    ENDIF.

    DATA(lv_reference_event) = is_execinfo-ref_event_code.

    IF <ls_stop> IS ASSIGNED.
      READ TABLE lt_req2capa_info INTO DATA(ls_req2capa_info)
        WITH KEY req_assgn_stop_key = <ls_stop>-assgn_stop_key.
      IF sy-subrc = 0.
        ls_tracklocation-locid2 = |{ ls_req2capa_info-cap_no }{ ls_req2capa_info-cap_seq }|.
        SHIFT ls_tracklocation-locid2 LEFT DELETING LEADING '0'.
      ENDIF.
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


  METHOD zif_gtt_sts_actual_event~check_event_relevance.

    super->zif_gtt_sts_actual_event~check_event_relevance(
      EXPORTING
        it_all_appl_tables = it_all_appl_tables
        iv_event_code      = iv_event_code
        is_event           = is_event
      IMPORTING
        ev_result          = ev_result ).

*   Disable sending FU’s actual events to GTT
*    ev_result = zif_gtt_sts_ef_constants=>cs_condition-false.

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
        CHECK NOT ( <ls_tor_execinfo>-execinfo_source = /scmtms/if_tor_const=>sc_tor_event_source-application ).
        ev_result = zif_gtt_sts_ef_constants=>cs_condition-false.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.
ENDCLASS.
