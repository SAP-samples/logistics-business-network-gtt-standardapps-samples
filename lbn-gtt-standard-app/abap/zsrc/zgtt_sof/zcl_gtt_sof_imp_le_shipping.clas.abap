class ZCL_GTT_SOF_IMP_LE_SHIPPING definition
  public
  final
  create public .

*"* public components of class CL_EXM_IM_LE_SHP_DELIVERY_PROC
*"* do not include other source files here!!!
public section.

  interfaces IF_BADI_INTERFACE .
  interfaces IF_EX_LE_SHP_DELIVERY_PROC .
protected section.
*"* protected components of class CL_EXM_IM_LE_SHP_DELIVERY_PROC
*"* do not include other source files here!!!
private section.
*"* private components of class CL_EXM_IM_LE_SHP_DELIVERY_PROC
*"* do not include other source files here!!!
ENDCLASS.



CLASS ZCL_GTT_SOF_IMP_LE_SHIPPING IMPLEMENTATION.


method IF_EX_LE_SHP_DELIVERY_PROC~CHANGE_DELIVERY_HEADER .


endmethod. "IF_EX_LE_SHP_DELIVERY_PROC~CHANGE_DELIVERY_HEADER


method IF_EX_LE_SHP_DELIVERY_PROC~CHANGE_DELIVERY_ITEM .


endmethod. "IF_EX_LE_SHP_DELIVERY_PROC~CHANGE_DELIVERY_ITEM


method IF_EX_LE_SHP_DELIVERY_PROC~CHANGE_FCODE_ATTRIBUTES .

endmethod. "IF_EX_LE_SHP_DELIVERY_PROC~CHANGE_FCODE_ATTRIBUTES


method IF_EX_LE_SHP_DELIVERY_PROC~CHANGE_FIELD_ATTRIBUTES .

endmethod. "IF_EX_LE_SHP_DELIVERY_PROC~CHANGE_FIELD_ATTRIBUTES


method IF_EX_LE_SHP_DELIVERY_PROC~CHECK_ITEM_DELETION .

endmethod. "IF_EX_LE_SHP_DELIVERY_PROC~CHECK_ITEM_DELETION


method IF_EX_LE_SHP_DELIVERY_PROC~DELIVERY_DELETION .


endmethod. "IF_EX_LE_SHP_DELIVERY_PROC~DELIVERY_DELETION


method IF_EX_LE_SHP_DELIVERY_PROC~DELIVERY_FINAL_CHECK .

endmethod. "IF_EX_LE_SHP_DELIVERY_PROC~DELIVERY_FINAL_CHECK


method IF_EX_LE_SHP_DELIVERY_PROC~DOCUMENT_NUMBER_PUBLISH .


endmethod. "IF_EX_LE_SHP_DELIVERY_PROC~DOCUMENT_NUMBER_PUBLISH


method IF_EX_LE_SHP_DELIVERY_PROC~FILL_DELIVERY_HEADER .


endmethod. "IF_EX_LE_SHP_DELIVERY_PROC~FILL_DELIVERY_HEADER


method IF_EX_LE_SHP_DELIVERY_PROC~FILL_DELIVERY_ITEM .


endmethod. "IF_EX_LE_SHP_DELIVERY_PROC~FILL_DELIVERY_ITEM


method IF_EX_LE_SHP_DELIVERY_PROC~INITIALIZE_DELIVERY .


endmethod. "IF_EX_LE_SHP_DELIVERY_PROC~INITIALIZE_DELIVERY


method IF_EX_LE_SHP_DELIVERY_PROC~ITEM_DELETION .


endmethod.                    "IF_EX_LE_SHP_DELIVERY_PROC~ITEM_DELETION


method IF_EX_LE_SHP_DELIVERY_PROC~PUBLISH_DELIVERY_ITEM .


endmethod. "IF_EX_LE_SHP_DELIVERY_PROC~PUBLISH_DELIVERY_ITEM


method IF_EX_LE_SHP_DELIVERY_PROC~READ_DELIVERY .

endmethod.                    "IF_EX_LE_SHP_DELIVERY_PROC~READ_DELIVERY


method IF_EX_LE_SHP_DELIVERY_PROC~SAVE_AND_PUBLISH_BEFORE_OUTPUT.
endmethod.


METHOD if_ex_le_shp_delivery_proc~save_and_publish_document .

  DATA:
    BEGIN OF ls_aotype,
      obj_type TYPE /saptrx/trk_obj_type,
      aot_type TYPE /saptrx/aotype,
    END OF ls_aotype.

  DATA:
    lv_structure_package TYPE devclass,
    lv_extflag           TYPE flag,
    lt_vbfa_delta        TYPE STANDARD TABLE OF vbfavb,
    lt_vbfas             TYPE STANDARD TABLE OF vbfas,
    lt_vbfa_new          TYPE STANDARD TABLE OF vbfavb,
    lt_vbap_delta        TYPE STANDARD TABLE OF vbapvb,
    lt_vbap              TYPE STANDARD TABLE OF vbap,
    lt_vbup              TYPE STANDARD TABLE OF vbup,
    lt_vbap_new          TYPE STANDARD TABLE OF vbapvb,
    ls_vbfa_delta        TYPE vbfavb,
    ls_vbfas             TYPE vbfas,
    ls_vbfa_new          TYPE vbfavb,
    ls_vbap_delta        TYPE vbapvb,
    ls_vbap              TYPE vbap,
    ls_vbap_new          TYPE vbapvb,
    ls_likp              TYPE likpvb,
    ls_likp_tmp          TYPE likp,
    ls_vbak              TYPE vbak,
    ls_comwa5            TYPE vbco5,
    ls_comwa6            TYPE vbco6,
    lt_control           TYPE /saptrx/bapi_trk_control_tab,
    lt_tracking_id       TYPE /saptrx/bapi_trk_trkid_tab,
    ls_trxserv           TYPE /saptrx/trxserv,
    lt_exp_events        TYPE /saptrx/bapi_trk_ee_tab,
    lv_appsys            TYPE logsys,
    lt_appobj_ctabs	     TYPE trxas_appobj_ctabs,
    lt_bapireturn	       TYPE bapiret2_t,
    lv_trxserver_id      TYPE /saptrx/trxservername,
    lv_tzone             TYPE timezone,
    ls_control           TYPE LINE OF /saptrx/bapi_trk_control_tab,
    ls_tracking_id       TYPE LINE OF /saptrx/bapi_trk_trkid_tab,
    ls_appobj_ctabs	     TYPE LINE OF trxas_appobj_ctabs,
    lt_aotype            LIKE STANDARD TABLE OF ls_aotype,
    ls_expeventdata      TYPE /saptrx/exp_events,
    lv_count             TYPE i,
    lrt_aotype_rst       TYPE RANGE OF /saptrx/aotype,
    lv_rst_id            TYPE zgtt_rst_id VALUE 'DL_TO_SOIT',
    lv_objtype           TYPE /saptrx/trk_obj_type VALUE 'ESC_SORDER',
    lt_dlv_type          TYPE rseloption,
    lt_so_type           TYPE rseloption.

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
    EXIT.
  ENDIF.
  IF lv_extflag <> 'X'.
    EXIT.
  ENDIF.

* Check if any tracking server defined
  CALL FUNCTION '/SAPTRX/EVENT_MGR_CHECK'
    EXCEPTIONS
      no_event_mgr_available = 1.
  IF sy-subrc <> 0.
    EXIT.
  ENDIF.

* Check if at least 1 active extractor exists
  SELECT COUNT(*) INTO lv_count   FROM /saptrx/aotypes
                                  WHERE trk_obj_type EQ 'ESC_DELIV'
                                  AND   torelevant  EQ 'X'.
  CHECK lv_count GE 1. CLEAR lv_count.

  SELECT COUNT(*) INTO lv_count   FROM /saptrx/aotypes
                                  WHERE trk_obj_type EQ 'ESC_SORDER'
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

  CLEAR lt_dlv_type.
  zcl_gtt_sof_toolkit=>get_delivery_type(
    RECEIVING
      rt_type = lt_dlv_type ).

  CLEAR lt_so_type.
  zcl_gtt_sof_toolkit=>get_so_type(
    RECEIVING
      rt_type = lt_so_type ).

  CHECK lt_dlv_type IS NOT INITIAL AND lt_so_type IS NOT INITIAL.

  LOOP AT it_xlikp INTO ls_likp WHERE lfart IN lt_dlv_type.

    CLEAR: lt_vbfa_delta, lt_vbap_delta.

    MOVE it_xvbfa TO lt_vbfa_delta.
    APPEND LINES OF it_yvbfa TO lt_vbfa_delta.
    DELETE lt_vbfa_delta WHERE ( updkz NE 'I' AND updkz NE 'D' ) OR ( vbtyp_n NE 'J' AND vbtyp_v NE 'C' ) OR vbeln NE ls_likp-vbeln.

    CHECK lt_vbfa_delta IS NOT INITIAL.

    LOOP AT lt_vbfa_delta INTO ls_vbfa_delta.
      MOVE ls_vbfa_delta-vbelv TO ls_vbap_delta-vbeln.
      MOVE ls_vbfa_delta-posnv TO ls_vbap_delta-posnr.
      COLLECT ls_vbap_delta INTO lt_vbap_delta.
    ENDLOOP.

    CLEAR: lt_vbfa_new, lt_vbap_new.
    LOOP AT lt_vbap_delta INTO ls_vbap_delta.
      CLEAR: ls_comwa6, lt_vbfas.
      MOVE-CORRESPONDING ls_vbap_delta TO ls_comwa6.
      CALL FUNCTION 'RV_ORDER_FLOW_INFORMATION'
        EXPORTING
          comwa    = ls_comwa6
        TABLES
          vbfa_tab = lt_vbfas.
      LOOP AT lt_vbfas INTO ls_vbfas WHERE vbtyp_n EQ 'J' AND vbtyp_v EQ 'C'.
        SELECT SINGLE * INTO ls_vbak FROM vbak WHERE vbeln = ls_vbfas-vbelv
                                                 AND auart IN lt_so_type.
        CHECK sy-subrc EQ 0.
        SELECT SINGLE * INTO ls_likp_tmp FROM likp WHERE vbeln = ls_vbfas-vbeln
                                                     AND lfart IN lt_dlv_type.
        CHECK sy-subrc EQ 0.
        MOVE-CORRESPONDING ls_vbfas TO ls_vbfa_new.
        APPEND ls_vbfa_new TO lt_vbfa_new.
      ENDLOOP.

      CLEAR: ls_comwa5, lt_vbap, ls_vbap, lt_vbup.
      MOVE-CORRESPONDING ls_vbap_delta TO ls_comwa5.
      CALL FUNCTION 'RV_ORDER_POSITION_AND_STATUS'
        EXPORTING
          comwa = ls_comwa5
        TABLES
          lvbap = lt_vbap
          tvbup = lt_vbup.
      IF lt_vbap IS NOT INITIAL.
        READ TABLE lt_vbap INTO ls_vbap WITH KEY vbeln = ls_vbap_delta-vbeln
                                                 posnr = ls_vbap_delta-posnr.
        SELECT SINGLE * INTO ls_vbak FROM vbak WHERE vbeln = ls_vbap-vbeln
                                                 AND auart IN lt_so_type.
        CHECK sy-subrc EQ 0.
        MOVE-CORRESPONDING ls_vbap TO ls_vbap_new.
        APPEND ls_vbap_new TO lt_vbap_new.
      ENDIF.
    ENDLOOP.

    LOOP AT lt_vbfa_delta INTO ls_vbfa_delta WHERE updkz = 'D'.
      DELETE lt_vbfa_new WHERE ruuid = ls_vbfa_delta-ruuid.
    ENDLOOP.

    LOOP AT lt_vbfa_delta INTO ls_vbfa_delta WHERE updkz = 'I'.
      READ TABLE lt_vbfa_new WITH KEY ruuid = ls_vbfa_delta-ruuid
                                      TRANSPORTING NO FIELDS.
      IF sy-subrc NE 0.
        SELECT SINGLE * INTO ls_vbak FROM vbak WHERE vbeln = ls_vbfa_delta-vbelv
                                                 AND auart IN lt_so_type.
        CHECK sy-subrc EQ 0.
        COLLECT ls_vbfa_delta INTO lt_vbfa_new.
      ENDIF.
    ENDLOOP.

*   COMPOSE and SEND IDOC->
    LOOP AT lt_aotype INTO ls_aotype.

      SELECT SINGLE trxservername INTO lv_trxserver_id  FROM /saptrx/aotypes
                                                        WHERE trk_obj_type EQ ls_aotype-obj_type
                                                        AND   aotype  EQ ls_aotype-aot_type.

      SELECT SINGLE trx_server_id trx_server em_version INTO ( ls_trxserv-trx_server_id, ls_trxserv-trx_server , ls_trxserv-em_version )
                                                        FROM /saptrx/trxserv
                                                       WHERE trx_server_id = lv_trxserver_id.

      CLEAR: lt_appobj_ctabs, lt_control, lt_tracking_id,lt_exp_events.

      LOOP AT lt_vbap_new INTO ls_vbap_new.
        CLEAR: ls_appobj_ctabs.
        ls_appobj_ctabs-trxservername = ls_trxserv-trx_server_id.
        ls_appobj_ctabs-appobjtype    = ls_aotype-aot_type.
        CONCATENATE ls_vbap_new-vbeln ls_vbap_new-posnr INTO ls_appobj_ctabs-appobjid.
        SHIFT ls_appobj_ctabs-appobjid LEFT DELETING LEADING '0'.
        APPEND ls_appobj_ctabs TO lt_appobj_ctabs.

        CLEAR: ls_control.
        ls_control-appsys  = lv_appsys.
        ls_control-appobjtype = ls_aotype-aot_type.
        CONCATENATE ls_vbap_new-vbeln ls_vbap_new-posnr INTO ls_control-appobjid.
        SHIFT ls_control-appobjid LEFT DELETING LEADING '0'.
        ls_control-paramname = 'YN_SO_NO'.
        ls_control-value     = | { ls_vbap_new-vbeln ALPHA = OUT } |.
        CONDENSE ls_control-value NO-GAPS.
        APPEND ls_control TO lt_control.
        ls_control-paramname = 'YN_SO_ITEM_NO'.
        ls_control-value     = ls_vbap_new-posnr.
        APPEND ls_control TO lt_control.
        ls_control-paramname = 'ACTUAL_BUSINESS_TIMEZONE'.
        ls_control-value     = lv_tzone.
        APPEND ls_control TO lt_control.
        ls_control-paramname = 'ACTUAL_BUSINESS_DATETIME'.
        CONCATENATE '0' sy-datum sy-uzeit INTO ls_control-value.
        APPEND ls_control TO lt_control.
        ls_control-paramname = 'REPORTED_BY'.
        ls_control-value = sy-uname.
        APPEND ls_control TO lt_control.

        CLEAR:ls_expeventdata.
        ls_expeventdata-appsys = lv_appsys.
        ls_expeventdata-appobjtype = ls_aotype-aot_type.
        ls_expeventdata-language = sy-langu.
        CONCATENATE ls_vbap_new-vbeln ls_vbap_new-posnr INTO ls_expeventdata-appobjid.
        SHIFT ls_expeventdata-appobjid LEFT DELETING LEADING '0'.
        LOOP AT lt_vbfa_new INTO ls_vbfa_new WHERE vbelv = ls_vbap_new-vbeln
                                               AND posnv = ls_vbap_new-posnr.
*         Add planned event ItemCompleteds
          ls_expeventdata-milestone    = zif_gtt_sof_constants=>cs_milestone-dlv_item_completed.
          ls_expeventdata-locid2       = |{ ls_vbfa_new-vbeln ALPHA = OUT }{ ls_vbfa_new-posnn ALPHA = IN }|.
          CONDENSE ls_expeventdata-locid2 NO-GAPS.
          APPEND ls_expeventdata TO lt_exp_events.
        ENDLOOP.

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

ENDMETHOD. "IF_EX_LE_SHP_DELIVERY_PROC~SAVE_AND_PUBLISH_DOCUMENT


method IF_EX_LE_SHP_DELIVERY_PROC~SAVE_DOCUMENT_PREPARE .

endmethod. "IF_EX_LE_SHP_DELIVERY_PROC~SAVE_DOCUMENT_PREPARE
ENDCLASS.
