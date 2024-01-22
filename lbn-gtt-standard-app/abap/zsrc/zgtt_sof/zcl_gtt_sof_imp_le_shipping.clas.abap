class ZCL_GTT_SOF_IMP_LE_SHIPPING definition
  public
  final
  create public .

*"* public components of class CL_EXM_IM_LE_SHP_DELIVERY_PROC
*"* do not include other source files here!!!
public section.

  interfaces IF_BADI_INTERFACE .
  interfaces IF_EX_LE_SHP_DELIVERY_PROC .

  methods SEND_SO_HD_IDOC
    importing
      !IV_APPSYS type LOGSYS
      !IV_TZONE type TIMEZONE
      !IT_SO_TYPE type RSELOPTION
      !IT_DLV_TYPE type RSELOPTION
      !IT_XLIKP type SHP_LIKP_T
      !IT_XLIPS type SHP_LIPS_T .
protected section.
*"* protected components of class CL_EXM_IM_LE_SHP_DELIVERY_PROC
*"* do not include other source files here!!!
private section.

  methods CHECK_DLV_ITEM
    importing
      !IV_PSTYV type PSTYV_VL
    returning
      value(RV_RESULT) type ABAP_BOOL .
  methods PREPARE_PLN_EVT
    importing
      !IV_APPSYS type LOGSYS
      !IV_OBJ_TYPE type /SAPTRX/TRK_OBJ_TYPE
      !IV_AOT_TYPE type /SAPTRX/AOTYPE
      !IV_SERVER_NAME type /SAPTRX/TRXSERVERNAME
      !IS_VBAK type /SAPTRX/SD_SDS_HDR
      !IT_VBAP type VA_VBAPVB_T
    exporting
      !ET_EXP_EVENT type /SAPTRX/BAPI_TRK_EE_TAB .
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
  IF lrt_aotype_rst IS NOT INITIAL.
    SELECT trk_obj_type  AS obj_type
           aotype        AS aot_type
      INTO TABLE lt_aotype
      FROM /saptrx/aotypes
     WHERE trk_obj_type  = lv_objtype
       AND aotype       IN lrt_aotype_rst
       AND torelevant    = abap_true.
  ENDIF.

  CLEAR lt_dlv_type.
  zcl_gtt_sof_toolkit=>get_delivery_type(
    RECEIVING
      rt_type = lt_dlv_type ).

  CLEAR lt_so_type.
  zcl_gtt_sof_toolkit=>get_so_type(
    RECEIVING
      rt_type = lt_so_type ).

  CHECK lt_dlv_type IS NOT INITIAL AND lt_so_type IS NOT INITIAL.

* Send SO header IDOC
  send_so_hd_idoc(
    iv_appsys   = lv_appsys
    iv_tzone    = lv_tzone
    it_so_type  = lt_so_type
    it_dlv_type = lt_dlv_type
    it_xlikp    = it_xlikp
    it_xlips    = it_xlips ).

* Send SO Item IDOC
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


  METHOD CHECK_DLV_ITEM.

    DATA:
      lt_tvlp  TYPE STANDARD TABLE OF tvlp.

    CLEAR: rv_result.

    CALL FUNCTION 'MCV_TVLP_READ'
      EXPORTING
        i_pstyv   = iv_pstyv
      TABLES
        t_tvlp    = lt_tvlp
      EXCEPTIONS
        not_found = 1
        OTHERS    = 2.

    IF sy-subrc = 0.
      READ TABLE lt_tvlp INTO DATA(ls_tvlp)
        WITH KEY vbtyp = if_sd_doc_category=>delivery.
      IF sy-subrc = 0.
        rv_result = abap_true.
      ENDIF.
    ENDIF.

  ENDMETHOD.


  METHOD prepare_pln_evt.

    DATA:
      ls_app_obj_types      TYPE /saptrx/aotypes,
      lt_all_appl_tables    TYPE trxas_tabcontainer,
      lt_app_type_cntl_tabs TYPE trxas_apptype_tabs,
      ls_app_objects        TYPE trxas_appobj_ctab_wa,
      lt_app_objects        TYPE trxas_appobj_ctabs,
      lv_appobjid           TYPE /saptrx/aoid.

    CLEAR: et_exp_event[].

    lv_appobjid = is_vbak-vbeln.
    CONDENSE lv_appobjid NO-GAPS.
    SHIFT lv_appobjid LEFT DELETING LEADING '0'.

    ls_app_obj_types-trk_obj_type  = iv_obj_type.
    ls_app_obj_types-aotype  = iv_aot_type.
    ls_app_obj_types-trxservername = iv_server_name.
    ls_app_objects = CORRESPONDING #( ls_app_obj_types ).

    ls_app_objects-appobjtype     = iv_aot_type.
    ls_app_objects-appobjid       = lv_appobjid.
    ls_app_objects-maintabref     = REF #( is_vbak ).
    ls_app_objects-maintabdef     = zif_gtt_sof_constants=>cs_tabledef-so_header_new.

    lt_app_objects                = VALUE #( ( ls_app_objects ) ).

    lt_all_appl_tables            = VALUE #(
    (
      tabledef    = zif_gtt_sof_constants=>cs_tabledef-so_item_new
      tableref    = REF #( it_vbap )
     ) ).

    CALL FUNCTION 'ZGTT_SSOF_EE_SO_HD'
      EXPORTING
        i_appsys                  = iv_appsys
        i_app_obj_types           = ls_app_obj_types
        i_all_appl_tables         = lt_all_appl_tables
        i_app_type_cntl_tabs      = lt_app_type_cntl_tabs
        i_app_objects             = lt_app_objects
      TABLES
        e_expeventdata            = et_exp_event
      EXCEPTIONS
        parameter_error           = 1
        exp_event_determ_error    = 2
        table_determination_error = 3
        stop_processing           = 4
        OTHERS                    = 5.

    IF sy-subrc <> 0.
      "zcl_gtt_tools=>throw_exception( ).
    ENDIF.

  ENDMETHOD.


  METHOD send_so_hd_idoc.

    DATA:
      BEGIN OF ts_aotype,
        obj_type TYPE /saptrx/trk_obj_type,
        aot_type TYPE /saptrx/aotype,
      END OF ts_aotype.

    DATA:
      lrt_aotype_rst  TYPE RANGE OF /saptrx/aotype,
      lv_rst_id       TYPE zgtt_rst_id VALUE 'DL_TO_SOHD',
      lt_aotype       LIKE STANDARD TABLE OF ts_aotype,
      lv_objtype      TYPE /saptrx/trk_obj_type VALUE 'ESC_SORDER',
      ls_aotype       LIKE ts_aotype,
      lv_trxserver_id TYPE /saptrx/trxservername,
      ls_trxserv      TYPE /saptrx/trxserv,
      ls_control      TYPE LINE OF /saptrx/bapi_trk_control_tab,
      ls_appobj_ctabs	TYPE LINE OF trxas_appobj_ctabs,
      lt_appobj_ctabs	TYPE trxas_appobj_ctabs,
      lt_control      TYPE /saptrx/bapi_trk_control_tab,
      lt_info         TYPE /saptrx/bapi_trk_info_tab,
      lt_tracking_id  TYPE /saptrx/bapi_trk_trkid_tab,
      lt_exp_events   TYPE /saptrx/bapi_trk_ee_tab,
      lv_appsys       TYPE logsys,
      lv_tzone        TYPE timezone,
      lv_count        TYPE i,
      lt_xlips        TYPE shp_lips_t,
      lt_tvlp         TYPE STANDARD TABLE OF tvlp,
      lt_vbak         TYPE TABLE OF vbak,
      lt_vbap         TYPE va_vbapvb_t,
      ls_vbak_hdr     TYPE /saptrx/sd_sds_hdr.

    lv_appsys = iv_appsys.
    lv_tzone = iv_tzone.

    SELECT rst_option AS option,
           rst_sign   AS sign,
           rst_low    AS low,
           rst_high   AS high
      INTO CORRESPONDING FIELDS OF TABLE @lrt_aotype_rst
      FROM zgtt_aotype_rst
     WHERE rst_id = @lv_rst_id.

*   Prepare AOT list
    IF lrt_aotype_rst IS NOT INITIAL.
      SELECT trk_obj_type  AS obj_type
             aotype        AS aot_type
        INTO TABLE lt_aotype
        FROM /saptrx/aotypes
       WHERE trk_obj_type  = lv_objtype
         AND aotype       IN lrt_aotype_rst
         AND torelevant    = abap_true.
    ENDIF.

    LOOP AT it_xlips INTO DATA(ls_xlips).
      READ TABLE it_xlikp INTO DATA(ls_xlikp)
        WITH KEY vbeln = ls_xlips-vbeln.
      IF sy-subrc = 0 AND ls_xlikp-lfart IN it_dlv_type AND check_dlv_item( ls_xlips-pstyv ) = abap_true.
        APPEND ls_xlips TO lt_xlips.
      ENDIF.
      CLEAR ls_xlips.
    ENDLOOP.

    IF lt_xlips IS INITIAL.
      RETURN.
    ENDIF.

    zcl_gtt_tools=>get_po_so_by_delivery(
      EXPORTING
        iv_vgtyp       = if_sd_doc_category=>order
        it_xlikp       = it_xlikp
        it_xlips       = lt_xlips
      IMPORTING
        et_ref_list    = DATA(lt_ref_list)
        ev_ref_chg_flg = DATA(lv_chg_flg) ).

*   The relationship between SO and ODLV is not changed,no need send out the Cross TP IDOC
    IF lv_chg_flg IS INITIAL.
      RETURN.
    ENDIF.

    IF lt_ref_list IS NOT INITIAL.
      SELECT *
        INTO TABLE lt_vbak
        FROM vbak
         FOR ALL ENTRIES IN lt_ref_list
       WHERE vbeln = lt_ref_list-vgbel.

      SELECT *
        INTO CORRESPONDING FIELDS OF TABLE lt_vbap
        FROM vbap
         FOR ALL ENTRIES IN lt_ref_list
       WHERE vbeln = lt_ref_list-vgbel.
    ENDIF.

    LOOP AT lt_aotype INTO ls_aotype.

      CLEAR:
        lv_trxserver_id,
        ls_trxserv,
        ls_appobj_ctabs,
        lt_appobj_ctabs,
        lt_control.

      SELECT SINGLE trxservername INTO lv_trxserver_id  FROM /saptrx/aotypes
                                                        WHERE trk_obj_type EQ ls_aotype-obj_type
                                                        AND   aotype  EQ ls_aotype-aot_type.

      SELECT SINGLE trx_server_id trx_server em_version INTO ( ls_trxserv-trx_server_id, ls_trxserv-trx_server , ls_trxserv-em_version )
                                                        FROM /saptrx/trxserv
                                                       WHERE trx_server_id = lv_trxserver_id.

      LOOP AT lt_ref_list INTO DATA(ls_ref_list).
        CLEAR:
         ls_vbak_hdr,
         ls_appobj_ctabs,
         lt_control,
         lt_info,
         lt_tracking_id,
         lt_exp_events,
         lt_appobj_ctabs.

        READ TABLE lt_vbak INTO DATA(ls_vbak)
          WITH KEY vbeln = ls_ref_list-vgbel.
        IF sy-subrc = 0 AND ls_vbak-auart NOT IN it_so_type.
          CONTINUE.
        ENDIF.

        MOVE-CORRESPONDING ls_vbak TO ls_vbak_hdr.

        ls_appobj_ctabs-trxservername = ls_trxserv-trx_server_id.
        ls_appobj_ctabs-appobjtype    = ls_aotype-aot_type.
        ls_appobj_ctabs-appobjid = ls_ref_list-vgbel.
        SHIFT ls_appobj_ctabs-appobjid LEFT DELETING LEADING '0'.
        APPEND ls_appobj_ctabs TO lt_appobj_ctabs.

        CLEAR: ls_control.
        ls_control-appsys  = lv_appsys.
        ls_control-appobjtype = ls_aotype-aot_type.
        ls_control-appobjid = ls_ref_list-vgbel.
        SHIFT ls_control-appobjid LEFT DELETING LEADING '0'.
        ls_control-paramname = 'YN_SO_NO'.
        ls_control-value     = ls_ref_list-vgbel.
        CONDENSE ls_control-value NO-GAPS.
        SHIFT ls_control-value LEFT DELETING LEADING '0'.
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

        CLEAR: lv_count.
        LOOP AT ls_ref_list-vbeln INTO DATA(ls_vbeln).

          lv_count = lv_count + 1.
          ls_control-paramname = 'YN_ODLV_LINE_NO'.
          ls_control-paramindex = lv_count.
          ls_control-value = lv_count.
          SHIFT ls_control-value LEFT DELETING LEADING space.
          APPEND ls_control TO lt_control.

          ls_control-paramname = 'YN_ODLV_NO'.
          ls_control-paramindex = lv_count.
          ls_control-value      = ls_vbeln.
          SHIFT ls_control-value LEFT DELETING LEADING '0'.
          APPEND ls_control TO lt_control.
        ENDLOOP.
        IF ls_ref_list-vbeln IS INITIAL.
          ls_control-paramname = 'YN_ODLV_LINE_NO'.
          ls_control-paramindex = '1'.
          ls_control-value = ''.
          APPEND ls_control TO lt_control.
        ENDIF.

        prepare_pln_evt(
          EXPORTING
            iv_appsys      = lv_appsys
            iv_obj_type    = ls_aotype-obj_type
            iv_aot_type    = ls_aotype-aot_type
            iv_server_name = lv_trxserver_id
            is_vbak        = ls_vbak_hdr
            it_vbap        = lt_vbap
          IMPORTING
            et_exp_event   = lt_exp_events ).

        IF lt_control IS NOT INITIAL.
          /saptrx/cl_send_idocs=>send_idoc_ehpost01(
            EXPORTING
              it_control      = lt_control
              it_info         = lt_info
              it_tracking_id  = lt_tracking_id
              it_exp_event    = lt_exp_events
              is_trxserv      = ls_trxserv
              iv_appsys       = lv_appsys
              it_appobj_ctabs = lt_appobj_ctabs ).

          " when GTTV.2 version
          IF /saptrx/cl_send_idocs=>st_idoc_data[] IS NOT INITIAL.
            /saptrx/cl_send_idocs=>send_idoc_gttmsg01(
              IMPORTING
                et_bapireturn = DATA(lt_bapiret) ).
          ENDIF.
        ENDIF.
      ENDLOOP.

    ENDLOOP.

  ENDMETHOD.
ENDCLASS.
