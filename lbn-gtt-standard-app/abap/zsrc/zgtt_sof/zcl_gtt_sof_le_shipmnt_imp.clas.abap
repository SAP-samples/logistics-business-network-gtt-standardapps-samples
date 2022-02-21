class ZCL_GTT_SOF_LE_SHIPMNT_IMP definition
  public
  final
  create public .

public section.

  interfaces IF_EX_BADI_LE_SHIPMENT .
protected section.
private section.
ENDCLASS.



CLASS ZCL_GTT_SOF_LE_SHIPMNT_IMP IMPLEMENTATION.


  method IF_EX_BADI_LE_SHIPMENT~AT_SAVE.
  endmethod.


METHOD IF_EX_BADI_LE_SHIPMENT~BEFORE_UPDATE.

  DATA:
    BEGIN OF ls_aotype,
      obj_type TYPE /saptrx/trk_obj_type,
      aot_type TYPE /saptrx/aotype,
    END OF ls_aotype.

  DATA:
    lv_structure_package      TYPE devclass,
    lv_extflag                TYPE flag,
    lv_count                  TYPE i,
    ls_comwa6                 TYPE vbco6,
    lv_fstop                  TYPE char255,
    lv_lstop                  TYPE char255,
    lv_locid                  TYPE zgtt_ssof_locid,
    ls_vttk_old               TYPE vttkvb,
    ls_vttk                   TYPE vttkvb,
    ls_vttk_tmp               TYPE vttk,
    ls_vtts_old               TYPE vttsvb,
    ls_vtts_delta             TYPE vttsvb,
    ls_vttp_delta             TYPE vttpvb,
    ls_vtsp_delta             TYPE vtspvb,
    ls_likp_delta             TYPE likpvb,
    ls_likp                   TYPE likp,
    ls_vbfas                  TYPE vbfas,
    ls_vbfa_new               TYPE vbfavb,
    ls_likp_new               TYPE likp,
    ls_stop                   TYPE zgtt_ssof_stop_info,
    ls_dlv_watching_stop      TYPE zgtt_ssof_dlv_watch_stop,
    ls_eerel                  TYPE zgtt_mia_ee_rel,
    lt_vbfas                  TYPE STANDARD TABLE OF vbfas,
    lt_vbfa_new               TYPE STANDARD TABLE OF vbfavb,
    lt_vttk                   TYPE STANDARD TABLE OF vttkvb,
    lt_vtts_delta             TYPE STANDARD TABLE OF vttsvb,
    lt_vttp_delta             TYPE STANDARD TABLE OF vttpvb,
    lt_vttp_delta_tmp         TYPE STANDARD TABLE OF vttpvb,
    lt_vtsp_delta             TYPE STANDARD TABLE OF vtspvb,
    lt_vtsp_delta_tmp         TYPE STANDARD TABLE OF vtspvb,
    lt_likp_delta             TYPE STANDARD TABLE OF likpvb,
    lt_likp_new               TYPE STANDARD TABLE OF likp,
    lt_stops_tmp              TYPE zgtt_ssof_stops,
    lt_dlv_watching_stops_tmp TYPE zgtt_ssof_dlv_watch_stops,
    lt_stops                  TYPE zgtt_ssof_stops,
    lt_dlv_watching_stops     TYPE zgtt_ssof_dlv_watch_stops,
    lt_control                TYPE /saptrx/bapi_trk_control_tab,
    lt_tracking_id            TYPE /saptrx/bapi_trk_trkid_tab,
    ls_trxserv                TYPE /saptrx/trxserv,
    lv_appsys                 TYPE logsys,
    lt_appobj_ctabs	          TYPE trxas_appobj_ctabs,
    lt_bapireturn	            TYPE bapiret2_t,
    lv_trxserver_id           TYPE /saptrx/trxservername,
    lv_tzone                  TYPE timezone,
    lt_exp_events             TYPE /saptrx/bapi_trk_ee_tab,
    ls_control                TYPE LINE OF /saptrx/bapi_trk_control_tab,
    ls_tracking_id            TYPE LINE OF /saptrx/bapi_trk_trkid_tab,
    ls_appobj_ctabs	          TYPE LINE OF trxas_appobj_ctabs,
    ls_expeventdata           TYPE LINE OF /saptrx/bapi_trk_ee_tab,
    lt_aotype                 LIKE STANDARD TABLE OF ls_aotype,
    lrt_aotype_rst            TYPE RANGE OF /saptrx/aotype,
    lv_rst_id                 TYPE zgtt_rst_id VALUE 'SH_TO_ODLH',
    lv_objtype                TYPE /saptrx/trk_obj_type VALUE 'ESC_DELIV',
    lt_lips                   TYPE STANDARD TABLE OF lips,
    lv_milestonenum           TYPE /saptrx/seq_num,
    lv_length                 TYPE i,
    lv_tmp_vbeln              TYPE vbeln_nach,
    lv_appobjid               TYPE /saptrx/aoid.

* Check package dependent BADI disabling
  lv_structure_package = '/SAPTRX/SCEM_AI_R3'.
  CALL FUNCTION 'GET_R3_EXTENSION_SWITCH'
    EXPORTING
      i_structure_package = lv_structure_package
    IMPORTING
      e_active            = lv_extflag
    EXCEPTIONS
      not_existing        = 1
      object_not_existing = 2
      no_extension_object = 3
      OTHERS              = 4.
  IF sy-subrc <> 0.
    RETURN.
  ENDIF.
  IF lv_extflag <> 'X'.
    RETURN.
  ENDIF.

* Check if any tracking server defined
  CHECK im_shipments_before_update-tra_save_caller <> 'TRX'.
  CALL FUNCTION '/SAPTRX/EVENT_MGR_CHECK'
    EXCEPTIONS
      no_event_mgr_available = 1.
  IF sy-subrc <> 0.
    RETURN.
  ENDIF.

* Check if at least 1 active extractor exists
  SELECT COUNT(*) INTO lv_count   FROM /saptrx/aotypes
                                  WHERE trk_obj_type EQ 'ESC_SHIPMT'
                                  AND   torelevant  EQ 'X'.
  CHECK lv_count GE 1. CLEAR lv_count.

  SELECT COUNT(*) INTO lv_count   FROM /saptrx/aotypes
                                  WHERE trk_obj_type EQ 'ESC_DELIV'
                                  AND   torelevant  EQ 'X'.
  CHECK lv_count GE 1.

* GET CURRENT LOGICAL SYSTEM
  CALL FUNCTION 'OWN_LOGICAL_SYSTEM_GET'
    IMPORTING
      own_logical_system = lv_appsys.

* Actual Business Time zone
  CALL FUNCTION 'GET_SYSTEM_TIMEZONE'
    IMPORTING
      timezone            = lv_tzone
    EXCEPTIONS
      customizing_missing = 1
      OTHERS              = 2.

  SELECT rst_option AS option,
         rst_sign   AS sign,
         rst_low    AS low,
         rst_high   AS high
    INTO CORRESPONDING FIELDS OF TABLE @lrt_aotype_rst
    FROM zgtt_aotype_rst
   WHERE rst_id = @lv_rst_id.

* Prepare AOT list
  SELECT trk_obj_type  AS obj_type
         aotype        AS aot_type
    INTO TABLE lt_aotype
    FROM /saptrx/aotypes
   WHERE trk_obj_type  = lv_objtype
     AND aotype       IN lrt_aotype_rst
     AND torelevant    = abap_true.

* Get the shipment header
  MOVE im_shipments_before_update-new_vttk TO lt_vttk.
  LOOP AT im_shipments_before_update-old_vttk INTO ls_vttk_old WHERE updkz = 'D'.
    APPEND ls_vttk_old TO lt_vttk.
  ENDLOOP.

  LOOP AT lt_vttk INTO ls_vttk WHERE ( abfer EQ '1' OR abfer EQ '3' )."outbound shipment

    CLEAR: lt_vttp_delta, lt_likp_delta, lt_vttp_delta_tmp, lt_vtsp_delta, lt_vtsp_delta_tmp, lt_vtts_delta.

    MOVE im_shipments_before_update-new_vttp TO lt_vttp_delta.
    APPEND LINES OF im_shipments_before_update-old_vttp TO lt_vttp_delta.
    MOVE lt_vttp_delta TO lt_vttp_delta_tmp.
    DELETE lt_vttp_delta WHERE ( updkz NE 'I' AND updkz NE 'D' ) OR tknum NE ls_vttk-tknum.

    IF lt_vttp_delta IS NOT INITIAL.
      LOOP AT lt_vttp_delta INTO ls_vttp_delta.
        MOVE ls_vttp_delta-vbeln TO ls_likp_delta-vbeln.
        COLLECT ls_likp_delta INTO lt_likp_delta.
      ENDLOOP.
    ENDIF.

    MOVE im_shipments_before_update-new_vtsp TO lt_vtsp_delta.
    APPEND LINES OF im_shipments_before_update-old_vtsp TO lt_vtsp_delta.
    MOVE lt_vtsp_delta TO lt_vtsp_delta_tmp.
    DELETE lt_vtsp_delta WHERE ( updkz NE 'I' AND updkz NE 'D' ) OR tknum NE ls_vttk-tknum.

    IF lt_vtsp_delta IS NOT INITIAL.
      LOOP AT lt_vtsp_delta INTO ls_vtsp_delta.
        READ TABLE lt_vttp_delta_tmp INTO ls_vttp_delta WITH KEY tknum = ls_vtsp_delta-tknum
                                                                 tpnum = ls_vtsp_delta-tpnum BINARY SEARCH.
        IF sy-subrc EQ 0.
          MOVE ls_vttp_delta-vbeln TO ls_likp_delta-vbeln.
          COLLECT ls_likp_delta INTO lt_likp_delta.
        ENDIF.
      ENDLOOP.
    ENDIF.

    MOVE im_shipments_before_update-new_vtts TO lt_vtts_delta.
    APPEND LINES OF im_shipments_before_update-old_vtts TO lt_vtts_delta.
    DELETE lt_vtts_delta WHERE tknum NE ls_vttk-tknum.

    IF lt_vtts_delta IS NOT INITIAL.
      LOOP AT lt_vtts_delta INTO ls_vtts_delta WHERE updkz = 'I' OR updkz = 'D'.
        CLEAR: ls_vtsp_delta,  ls_vttp_delta.
        LOOP AT lt_vtsp_delta_tmp INTO ls_vtsp_delta WHERE tknum = ls_vtts_delta-tknum
                                                       AND tsnum = ls_vtts_delta-tsnum.
          READ TABLE lt_vttp_delta_tmp INTO ls_vttp_delta WITH KEY tknum = ls_vtsp_delta-tknum
                                                                   tpnum = ls_vtsp_delta-tpnum BINARY SEARCH.
          IF sy-subrc EQ 0.
            MOVE ls_vttp_delta-vbeln TO ls_likp_delta-vbeln.
            COLLECT ls_likp_delta INTO lt_likp_delta.
          ENDIF.
        ENDLOOP.
      ENDLOOP.
      LOOP AT lt_vtts_delta INTO ls_vtts_delta WHERE updkz <> 'I' AND updkz <> 'D'.
        READ TABLE im_shipments_before_update-old_vtts INTO ls_vtts_old WITH KEY tknum = ls_vtts_delta-tknum
                                                                                 tsnum = ls_vtts_delta-tsnum BINARY SEARCH.
        CHECK sy-subrc IS INITIAL.
        IF  ls_vtts_delta-knota NE ls_vtts_old-knota OR
            ls_vtts_delta-vstel NE ls_vtts_old-vstel OR
            ls_vtts_delta-werka NE ls_vtts_old-werka OR
            ls_vtts_delta-kunna NE ls_vtts_old-kunna OR
            ls_vtts_delta-lifna NE ls_vtts_old-lifna OR
            ls_vtts_delta-kunnz NE ls_vtts_old-kunnz OR
            ls_vtts_delta-vstez NE ls_vtts_old-vstez OR
            ls_vtts_delta-lifnz NE ls_vtts_old-lifnz OR
            ls_vtts_delta-werkz NE ls_vtts_old-werkz OR
            ls_vtts_delta-knotz NE ls_vtts_old-knotz OR
            ls_vtts_delta-dptbg NE ls_vtts_old-dptbg OR
            ls_vtts_delta-uptbg NE ls_vtts_old-uptbg OR
            ls_vtts_delta-dpten NE ls_vtts_old-dpten OR
            ls_vtts_delta-upten NE ls_vtts_old-upten.
          CLEAR: ls_vtsp_delta,  ls_vttp_delta.
          LOOP AT lt_vtsp_delta_tmp INTO ls_vtsp_delta WHERE tknum = ls_vtts_delta-tknum
                                                         AND tsnum = ls_vtts_delta-tsnum.
            READ TABLE lt_vttp_delta_tmp INTO ls_vttp_delta WITH KEY tknum = ls_vtsp_delta-tknum
                                                                     tpnum = ls_vtsp_delta-tpnum BINARY SEARCH.
            IF sy-subrc EQ 0.
              MOVE ls_vttp_delta-vbeln TO ls_likp_delta-vbeln.
              COLLECT ls_likp_delta INTO lt_likp_delta.
            ENDIF.
          ENDLOOP.
        ENDIF.
      ENDLOOP.
    ENDIF.

    CLEAR: lt_vbfa_new, lt_likp_new.
    LOOP AT lt_likp_delta INTO ls_likp_delta.
      CLEAR: ls_comwa6, lt_vbfas.
      MOVE-CORRESPONDING ls_likp_delta TO ls_comwa6.
      CALL FUNCTION 'RV_ORDER_FLOW_INFORMATION'
        EXPORTING
          comwa    = ls_comwa6
        TABLES
          vbfa_tab = lt_vbfas.
      LOOP AT lt_vbfas INTO ls_vbfas WHERE vbtyp_n EQ '8' AND vbtyp_v EQ 'J'.
        SELECT SINGLE * INTO ls_likp FROM likp WHERE vbeln = ls_vbfas-vbelv
                                                 AND lfart = zif_gtt_sof_constants=>cs_relevance-lfart.
        CHECK sy-subrc EQ 0.
        SELECT SINGLE * INTO ls_vttk_tmp FROM vttk WHERE tknum = ls_vbfas-vbeln
                                                     AND ( abfer EQ '1' OR abfer EQ '3' ).
        CHECK sy-subrc EQ 0.
        MOVE-CORRESPONDING ls_vbfas TO ls_vbfa_new.
        APPEND ls_vbfa_new TO lt_vbfa_new.
      ENDLOOP.

      SELECT SINGLE * INTO ls_likp FROM likp WHERE vbeln = ls_likp_delta-vbeln
                                               AND lfart = zif_gtt_sof_constants=>cs_relevance-lfart.
      IF sy-subrc = 0.
        COLLECT ls_likp INTO lt_likp_new.
      ENDIF.
    ENDLOOP.

    LOOP AT lt_vttp_delta INTO ls_vttp_delta WHERE updkz = 'D'.
      DELETE lt_vbfa_new WHERE vbeln = ls_vttp_delta-tknum
                           AND vbelv = ls_vttp_delta-vbeln.
    ENDLOOP.

    LOOP AT lt_vttp_delta INTO ls_vttp_delta WHERE updkz = 'I'.
      READ TABLE lt_vbfa_new WITH KEY vbeln = ls_vttp_delta-tknum
                                      vbelv = ls_vttp_delta-vbeln
                                      TRANSPORTING NO FIELDS.
      IF sy-subrc NE 0.
        SELECT SINGLE * INTO ls_likp FROM likp WHERE vbeln = ls_vttp_delta-vbeln
                                                 AND lfart = zif_gtt_sof_constants=>cs_relevance-lfart.
        CHECK sy-subrc EQ 0.
        CLEAR ls_vbfa_new.
        ls_vbfa_new-vbelv = ls_vttp_delta-vbeln.
        ls_vbfa_new-vbeln = ls_vttp_delta-tknum.
        COLLECT ls_vbfa_new INTO lt_vbfa_new.
      ENDIF.
    ENDLOOP.

    CHECK lt_likp_new IS NOT INITIAL.

    CLEAR: lt_stops, lt_dlv_watching_stops.
    LOOP AT lt_vbfa_new INTO ls_vbfa_new.
      CLEAR: lt_stops_tmp, lt_dlv_watching_stops_tmp.
      IF ls_vbfa_new-vbeln = ls_vttk-tknum.
        CALL FUNCTION 'ZGTT_SSOF_GET_STOPS_FROM_SHP'
          EXPORTING
            iv_tknum              = ls_vttk-tknum
            it_vtts_new           = im_shipments_before_update-new_vtts
            it_vtsp_new           = im_shipments_before_update-new_vtsp
            it_vttp_new           = im_shipments_before_update-new_vttp
          IMPORTING
            et_stops              = lt_stops_tmp
            et_dlv_watching_stops = lt_dlv_watching_stops_tmp.
      ELSE.
        CALL FUNCTION 'ZGTT_SSOF_GET_STOPS_FROM_SHP'
          EXPORTING
            iv_tknum              = ls_vbfa_new-vbeln
          IMPORTING
            et_stops              = lt_stops_tmp
            et_dlv_watching_stops = lt_dlv_watching_stops_tmp.
      ENDIF.
      APPEND LINES OF lt_stops_tmp TO lt_stops.
      APPEND LINES OF lt_dlv_watching_stops_tmp TO lt_dlv_watching_stops.
    ENDLOOP.
    SORT lt_stops BY stopid loccat.
    SORT lt_dlv_watching_stops BY vbeln stopid loccat.
    DELETE ADJACENT DUPLICATES FROM lt_stops COMPARING stopid loccat.
    DELETE ADJACENT DUPLICATES FROM lt_dlv_watching_stops COMPARING vbeln stopid loccat.

    CLEAR lt_lips.
    IF lt_likp_new IS NOT INITIAL.
      SELECT * INTO TABLE lt_lips FROM lips FOR ALL ENTRIES IN lt_likp_new WHERE vbeln = lt_likp_new-vbeln.
    ENDIF.

*   COMPOSE IDOC->
    LOOP AT lt_aotype INTO ls_aotype.

      lv_milestonenum = 1.
      SELECT SINGLE trxservername INTO lv_trxserver_id  FROM /saptrx/aotypes
                                                        WHERE trk_obj_type EQ ls_aotype-obj_type
                                                        AND   aotype  EQ ls_aotype-aot_type.

      SELECT SINGLE trx_server_id trx_server em_version INTO ( ls_trxserv-trx_server_id, ls_trxserv-trx_server,ls_trxserv-em_version )
                                                        FROM /saptrx/trxserv
                                                       WHERE trx_server_id = lv_trxserver_id.

      CLEAR: lt_appobj_ctabs, lt_control, lt_tracking_id, lt_exp_events.

      LOOP AT lt_likp_new INTO ls_likp_new.
        lv_milestonenum = 1.
        CLEAR: ls_appobj_ctabs.
        ls_appobj_ctabs-trxservername = ls_trxserv-trx_server_id.
        ls_appobj_ctabs-appobjtype    = ls_aotype-aot_type.
        ls_appobj_ctabs-appobjid      = |{ ls_likp_new-vbeln ALPHA = OUT }|.
        CONDENSE ls_appobj_ctabs-appobjid NO-GAPS.
        APPEND ls_appobj_ctabs TO lt_appobj_ctabs.

*       update the impacted deliveries' shipment composition and tracking id table=>
        CLEAR: ls_control.
        ls_control-appsys  = lv_appsys.
        ls_control-appobjtype = ls_aotype-aot_type.
        ls_control-appobjid   = |{ ls_likp_new-vbeln ALPHA = OUT }|.
        ls_control-paramname = 'YN_DLV_NO'.
        ls_control-value     = |{ ls_likp_new-vbeln ALPHA = OUT }|.
        CONDENSE ls_control-appobjid NO-GAPS.
        CONDENSE ls_control-value NO-GAPS.
        APPEND ls_control TO lt_control.
        ls_control-paramname = 'ACTUAL_BUSINESS_TIMEZONE'.
        ls_control-value     = lv_tzone.
        APPEND ls_control TO lt_control.
        ls_control-paramname = 'ACTUAL_BUSINESS_DATETIME'.
        CONCATENATE '0' sy-datum sy-uzeit INTO ls_control-value.
        APPEND ls_control TO lt_control.

*       Actual Technical Datetime & Time zone
        ls_control-paramname = 'ACTUAL_TECHNICAL_TIMEZONE'.
        ls_control-value     = lv_tzone.
        APPEND ls_control TO lt_control.
        ls_control-paramname = 'ACTUAL_TECHNICAL_DATETIME'.
        CONCATENATE '0' sy-datum sy-uzeit INTO ls_control-value.
        APPEND ls_control TO lt_control.

        CLEAR: lv_count.
        LOOP AT lt_vbfa_new INTO ls_vbfa_new WHERE vbelv = ls_likp_new-vbeln.
          lv_count = lv_count + 1.
          ls_control-paramname = 'YN_SHP_LINE_COUNT'.
          ls_control-paramindex = lv_count.
          ls_control-value = lv_count.
          SHIFT ls_control-value LEFT  DELETING LEADING space.
          APPEND ls_control TO lt_control.

          ls_control-paramname = 'YN_SHP_NO'.
          ls_control-paramindex = lv_count.
          ls_control-value      = |{ ls_vbfa_new-vbeln ALPHA = OUT }|.
          CONDENSE ls_control-value NO-GAPS.
          APPEND ls_control TO lt_control.

          CLEAR: lv_fstop, lv_lstop,lv_length,lv_tmp_vbeln.
          lv_tmp_vbeln = ls_vbfa_new-vbeln.
          SHIFT lv_tmp_vbeln LEFT DELETING LEADING '0'.
          lv_length = strlen( lv_tmp_vbeln ).

          LOOP AT lt_dlv_watching_stops INTO ls_dlv_watching_stop WHERE vbeln = ls_vbfa_new-vbelv.
            IF ls_dlv_watching_stop-stopid(lv_length) = lv_tmp_vbeln.
              IF lv_fstop IS INITIAL.
                lv_fstop = ls_dlv_watching_stop-stopid.
              ENDIF.
              lv_lstop  = ls_dlv_watching_stop-stopid.
            ENDIF.
          ENDLOOP.
          ls_control-paramname = 'YN_SHP_FIRST_STOP'.
          ls_control-paramindex = lv_count.
          ls_control-value      = |{ lv_fstop ALPHA = OUT }|.
          CONDENSE ls_control-value NO-GAPS.
          APPEND ls_control TO lt_control.

          ls_control-paramname = 'YN_SHP_LAST_STOP'.
          ls_control-paramindex = lv_count.
          ls_control-value      = |{ lv_lstop ALPHA = OUT }|.
          CONDENSE ls_control-value NO-GAPS.
          APPEND ls_control TO lt_control.
        ENDLOOP.
        IF sy-subrc NE 0.
          ls_control-paramname = 'YN_SHP_LINE_COUNT'.
          ls_control-paramindex = '1'.
          ls_control-value = ''.
          APPEND ls_control TO lt_control.
        ENDIF.

        CLEAR: ls_tracking_id.
        ls_tracking_id-appsys = lv_appsys.
        ls_tracking_id-appobjtype = ls_aotype-aot_type.
        ls_tracking_id-appobjid   = |{ ls_likp_new-vbeln ALPHA = OUT }|.
        ls_tracking_id-trxcod     = zif_gtt_sof_constants=>cs_trxcod-out_delivery.
        ls_tracking_id-trxid      = |{ ls_likp_new-vbeln ALPHA = OUT }|.
        CONDENSE ls_tracking_id-appobjid NO-GAPS.
        CONDENSE ls_tracking_id-trxid NO-GAPS.
        APPEND ls_tracking_id TO lt_tracking_id.

        CLEAR ls_tracking_id-start_date.
        CLEAR ls_tracking_id-end_date.
        CLEAR ls_tracking_id-timzon.
        LOOP AT lt_vttp_delta INTO ls_vttp_delta WHERE vbeln = ls_likp_new-vbeln.
          CLEAR ls_tracking_id-action.
          ls_tracking_id-trxcod          = zif_gtt_sof_constants=>cs_trxcod-shipment.
          ls_tracking_id-trxid           = |{ ls_vttp_delta-tknum ALPHA = OUT }|.
          IF ls_vttp_delta-updkz = 'D'.
            ls_tracking_id-action = 'D'.
          ENDIF.
          CONDENSE ls_tracking_id-trxid NO-GAPS.
          APPEND ls_tracking_id TO lt_tracking_id.
        ENDLOOP.
*       update the impacted deliveries' shipment composition and tracking id table=<

*       update the impacted deliveries' planned event table=>
        CLEAR ls_expeventdata.
        ls_expeventdata-appsys        = lv_appsys.
        ls_expeventdata-appobjtype    = ls_aotype-aot_type.
        ls_expeventdata-language      = sy-langu.
        ls_expeventdata-appobjid      = |{ ls_likp_new-vbeln ALPHA = OUT }|.
        ls_expeventdata-evt_exp_tzone = lv_tzone.
        CONDENSE ls_expeventdata-appobjid NO-GAPS.
        CLEAR ls_eerel.
        SELECT SINGLE * INTO ls_eerel FROM zgtt_mia_ee_rel WHERE appobjid = ls_expeventdata-appobjid.
        IF ls_eerel-z_wbsta    = 'X'.
          ls_expeventdata-milestone     = zif_gtt_sof_constants=>cs_milestone-goods_issue.
          ls_expeventdata-milestonenum  = lv_milestonenum.
          IF ls_likp_new-wadat IS INITIAL.
            CLEAR ls_expeventdata-evt_exp_datetime.
          ELSE.
            CONCATENATE '0' ls_likp_new-wadat ls_likp_new-wauhr INTO ls_expeventdata-evt_exp_datetime.
          ENDIF.
          ls_expeventdata-loctype = zif_gtt_sof_constants=>cs_loctype-shippingpoint.
          ls_expeventdata-locid1 = ls_likp_new-vstel.
          ls_expeventdata-locid2 = ''.
          APPEND ls_expeventdata TO lt_exp_events.
          ADD 1 TO lv_milestonenum.
        ENDIF.

        LOOP AT lt_dlv_watching_stops INTO ls_dlv_watching_stop WHERE vbeln = ls_likp_new-vbeln.
          READ TABLE lt_stops INTO ls_stop WITH KEY stopid = ls_dlv_watching_stop-stopid
                                                    loccat = ls_dlv_watching_stop-loccat.

          IF ls_dlv_watching_stop-loccat = zif_gtt_sof_constants=>cs_loccat-departure.
*           DEPARTURE planned event
            ls_expeventdata-milestone    = zif_gtt_sof_constants=>cs_milestone-departure.
            ls_expeventdata-milestonenum = lv_milestonenum.
            ls_expeventdata-locid2       = ls_stop-stopid.
            ls_expeventdata-loctype      = ls_stop-loctype.
            ls_expeventdata-locid1       = ls_stop-locid.
            ls_expeventdata-evt_exp_datetime  = ls_stop-pln_evt_datetime.
            ls_expeventdata-evt_exp_tzone = ls_stop-pln_evt_timezone.
            APPEND ls_expeventdata TO lt_exp_events.
            ADD 1 TO lv_milestonenum.
          ELSEIF ls_dlv_watching_stop-loccat = zif_gtt_sof_constants=>cs_loccat-arrival.
*           ARRIVAL planned event
            ls_expeventdata-milestone    = zif_gtt_sof_constants=>cs_milestone-arriv_dest.
            ls_expeventdata-milestonenum = lv_milestonenum.
            ls_expeventdata-locid2       = ls_stop-stopid.
            ls_expeventdata-loctype      = ls_stop-loctype.
            ls_expeventdata-locid1       = ls_stop-locid.
            ls_expeventdata-evt_exp_datetime  = ls_stop-pln_evt_datetime.
            ls_expeventdata-evt_exp_tzone = ls_stop-pln_evt_timezone.
            APPEND ls_expeventdata TO lt_exp_events.
            ADD 1 TO lv_milestonenum.

*           POD planned event
            CLEAR: lv_locid.
            SELECT SINGLE kunnr INTO lv_locid FROM likp WHERE vbeln = ls_likp_new-vbeln.
            IF lv_locid EQ ls_stop-locid AND ls_eerel-z_pdstk = 'X'.
              ls_expeventdata-milestone    = zif_gtt_sof_constants=>cs_milestone-pod.
              ls_expeventdata-milestonenum = lv_milestonenum.
              ls_expeventdata-locid2       = ls_stop-stopid.
              ls_expeventdata-loctype      = ls_stop-loctype.
              ls_expeventdata-locid1       = ls_stop-locid.
              ls_expeventdata-evt_exp_datetime  = ls_stop-pln_evt_datetime.
              ls_expeventdata-evt_exp_tzone = ls_stop-pln_evt_timezone.
              APPEND ls_expeventdata TO lt_exp_events.
              ADD 1 TO lv_milestonenum.
            ENDIF.

          ENDIF.

        ENDLOOP.

*       Add planned event ItemPOD
        CLEAR:
          ls_expeventdata-milestonenum,
          ls_expeventdata-evt_exp_tzone,
          ls_expeventdata-evt_exp_datetime,
          ls_expeventdata-loctype,
          ls_expeventdata-locid1,
          ls_expeventdata-locid2,
          ls_eerel,
          lv_appobjid.
        LOOP AT lt_lips INTO DATA(ls_lips) WHERE vbeln = ls_likp_new-vbeln.
          CONCATENATE ls_lips-vbeln ls_lips-posnr INTO lv_appobjid.
          SHIFT lv_appobjid LEFT DELETING LEADING '0'.
          SELECT SINGLE * INTO ls_eerel FROM zgtt_mia_ee_rel WHERE appobjid = lv_appobjid.
          IF sy-subrc  = 0 AND ls_eerel-z_pdstk = abap_true.
            ls_expeventdata-milestone = zif_gtt_sof_constants=>cs_milestone-dlv_item_pod.
            ls_expeventdata-milestonenum  = lv_milestonenum.
            CONCATENATE ls_lips-vbeln ls_lips-posnr
                   INTO ls_expeventdata-locid2.
            SHIFT ls_expeventdata-locid2 LEFT DELETING LEADING '0'.
            APPEND ls_expeventdata TO lt_exp_events.
            ADD 1 TO lv_milestonenum.
          ENDIF.
          CLEAR:
            lv_appobjid,
            ls_eerel.
        ENDLOOP.

*       Add planned event HeaderCompleted
        CLEAR:
          ls_expeventdata-milestonenum,
          ls_expeventdata-evt_exp_tzone,
          ls_expeventdata-evt_exp_datetime,
          ls_expeventdata-loctype,
          ls_expeventdata-locid1,
          ls_expeventdata-locid2.
        ls_expeventdata-milestone = zif_gtt_sof_constants=>cs_milestone-dlv_hd_completed.
        APPEND ls_expeventdata TO lt_exp_events.

*       Add planned delivery event with planned timestamp
        CLEAR:
          ls_expeventdata-milestonenum,
          ls_expeventdata-evt_exp_datetime,
          ls_expeventdata-evt_exp_tzone,
          ls_expeventdata-loctype,
          ls_expeventdata-locid1,
          ls_expeventdata-locid2.

        ls_expeventdata-milestone        = zif_gtt_sof_constants=>cs_milestone-odlv_planned_dlv.
        ls_expeventdata-evt_exp_datetime = |{ ls_likp_new-lfdat }{ ls_likp_new-lfuhr }|.
        ls_expeventdata-evt_exp_tzone    = ls_likp_new-tzonrc.
        APPEND ls_expeventdata TO lt_exp_events.

        READ TABLE lt_exp_events WITH KEY appobjid = |{ ls_likp_new-vbeln ALPHA = OUT }| TRANSPORTING NO FIELDS.
        IF sy-subrc NE 0.
          ls_expeventdata-evt_exp_datetime = '000000000000000'.
          ls_expeventdata-milestone     = ''.
          ls_expeventdata-evt_exp_tzone = ''.
          ls_expeventdata-loctype = ''.
          ls_expeventdata-locid1 = ''.
          ls_expeventdata-locid2 = ''.
          APPEND ls_expeventdata TO lt_exp_events.
        ENDIF.
*       update the impacted deliveries' planned event table=<
      ENDLOOP.

      IF lt_control IS NOT INITIAL.
        CALL METHOD zcl_gtt_sof_helper=>send_idoc_ehpost01
          EXPORTING
            it_control      = lt_control
            it_tracking_id  = lt_tracking_id
            it_exp_event    = lt_exp_events
            is_trxserv      = ls_trxserv
            iv_appsys       = lv_appsys
            it_appobj_ctabs = lt_appobj_ctabs.

*       Send IDOC GTTMSG01 if ST_MASTER_IDOC_DATA was populated previously (relevant for GTTv2)
        IF zcl_gtt_sof_helper=>st_idoc_data IS NOT INITIAL.
          CALL METHOD zcl_gtt_sof_helper=>send_idoc_gttmsg01
            IMPORTING
              et_bapireturn = lt_bapireturn.
          CLEAR zcl_gtt_sof_helper=>st_idoc_data.
        ENDIF.
      ENDIF.
    ENDLOOP.

  ENDLOOP.

ENDMETHOD.


  method IF_EX_BADI_LE_SHIPMENT~IN_UPDATE.
  endmethod.
ENDCLASS.
