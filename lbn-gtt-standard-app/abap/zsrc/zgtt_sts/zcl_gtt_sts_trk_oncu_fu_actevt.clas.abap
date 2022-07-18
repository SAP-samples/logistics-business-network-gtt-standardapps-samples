class ZCL_GTT_STS_TRK_ONCU_FU_ACTEVT definition
  public
  inheriting from ZCL_GTT_STS_ACTUAL_EVENT
  create public .

public section.

  methods ZIF_GTT_STS_ACTUAL_EVENT~EXTRACT_EVENT
    redefinition .
protected section.

  methods CHECK_TOR_SENT_TO_GTT
    redefinition .
  methods CHECK_TOR_TYPE_SPECIFIC_EVENTS
    redefinition .
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_GTT_STS_TRK_ONCU_FU_ACTEVT IMPLEMENTATION.


  METHOD CHECK_TOR_SENT_TO_GTT.

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


  METHOD CHECK_TOR_TYPE_SPECIFIC_EVENTS.

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


  METHOD ZIF_GTT_STS_ACTUAL_EVENT~EXTRACT_EVENT.

    FIELD-SYMBOLS <ls_root> TYPE /scmtms/s_em_bo_tor_root.

    DATA:
      ls_trackingheader TYPE /saptrx/bapi_evm_header,
      ls_tracklocation  TYPE /saptrx/bapi_evm_locationid,
      lv_stop_category  TYPE /scmtms/tor_category,
      lv_loctype        TYPE /saptrx/loc_id_type,
      lv_locno          TYPE /sapapo/locno.

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

    DATA(lv_reference_event) = is_execinfo-ref_event_code.

    IF iv_event_code = /scmtms/if_tor_const=>sc_tor_event-pod OR
       lv_reference_event = /scmtms/if_tor_const=>sc_tor_event-pod.
      ls_tracklocation-locid2 = <ls_root>-tor_id.
    ELSE.

      zcl_gtt_sts_tools=>get_stop_points(
        EXPORTING
          iv_root_id     = <ls_root>-tor_id
          it_stop        = VALUE #( FOR <ls_stop> IN lt_stop USING KEY parent_seqnum
                                    WHERE ( parent_node_id = <ls_root>-node_id ) ( <ls_stop> ) )
        IMPORTING
          et_stop_points = DATA(lt_stop_points) ).

      ASSIGN lt_stop_points[ log_locid = is_execinfo-ext_loc_id ]-stop_id TO FIELD-SYMBOL(<lv_stop_id>) ##WARN_OK.
      IF sy-subrc = 0.
        SHIFT <lv_stop_id> LEFT DELETING LEADING '0'.
        ls_tracklocation-locid2 = <lv_stop_id>.
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
