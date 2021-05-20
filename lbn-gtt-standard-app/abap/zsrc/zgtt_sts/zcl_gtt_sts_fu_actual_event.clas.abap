CLASS zcl_gtt_sts_fu_actual_event DEFINITION
  PUBLIC
  INHERITING FROM zcl_gtt_sts_actual_event
  CREATE PUBLIC .

  PUBLIC SECTION.

    METHODS zif_gtt_sts_actual_event~extract_event
        REDEFINITION .
  PROTECTED SECTION.

    METHODS check_tor_sent_to_gtt
        REDEFINITION .
    METHODS check_tor_type_specific_events
        REDEFINITION .
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
      lv_stop_category  TYPE /scmtms/tor_category.

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
    DATA(lt_capa_stop) = get_capa_stop( it_all_appl_tables ).
    DATA(lt_capa_root) = get_capa_root( it_all_appl_tables ).

    ls_tracklocation-loccod = zif_gtt_sts_actual_event~cs_location_type-logistic.
    ls_tracklocation-locid1 = is_execinfo-ext_loc_id.

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


    IF iv_event_code = /scmtms/if_tor_const=>sc_tor_event-delay OR
       iv_event_code = /scmtms/if_tor_const=>sc_tor_event-delay_fu.
      DATA(lv_reference_event) = is_execinfo-ref_event_code.
    ENDIF.

    IF iv_event_code = /scmtms/if_tor_const=>sc_tor_event-pod OR
       lv_reference_event = /scmtms/if_tor_const=>sc_tor_event-pod.
      ls_tracklocation-locid2 = <ls_root>-tor_id.
    ELSE.
      IF <ls_stop> IS  ASSIGNED.
        ls_tracklocation-locid2 = zcl_gtt_sts_tools=>get_capa_match_key(
                                      iv_assgn_stop_key = <ls_stop>-assgn_stop_key
                                      it_capa_stop      = lt_capa_stop
                                      it_capa_root      = lt_capa_root ).
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
ENDCLASS.
