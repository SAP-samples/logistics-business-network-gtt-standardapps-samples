class ZCL_GTT_SOF_LE_SHIPMNT_IMP definition
  public
  final
  create public .

public section.

  interfaces IF_EX_BADI_LE_SHIPMENT .

  types:
    TT_TKNUM TYPE TABLE of vttk-tknum .
  types:
    BEGIN OF ts_loc_info,
      loctype      TYPE char20,
      locid        TYPE char10,
      locaddrnum   TYPE adrnr,
      locindicator TYPE char1,
    END OF ts_loc_info .
  types:
    tt_loc_info type STANDARD TABLE OF ts_loc_info .
  types:
    BEGIN OF ts_address_info,
      locid     type char20,
      loctype   type char30,
      addr1     TYPE addr1_data,
      email     TYPE ad_smtpadr,
      telephone TYPE char50,
    END OF ts_address_info .
  types:
    tt_address_info type TABLE OF ts_address_info .

constants:
* One Time Location
  gc_cp_yn_gtt_otl_locid         TYPE /saptrx/paramname     VALUE 'GTT_OTL_LOCID',
  gc_cp_yn_gtt_otl_loctype       TYPE /saptrx/paramname     VALUE 'GTT_OTL_LOCTYPE',
  gc_cp_yn_gtt_otl_timezone      TYPE /saptrx/paramname     VALUE 'GTT_OTL_TIMEZONE',
  gc_cp_yn_gtt_otl_longitude     TYPE /saptrx/paramname     VALUE 'GTT_OTL_LONGITUDE',
  gc_cp_yn_gtt_otl_latitude      TYPE /saptrx/paramname     VALUE 'GTT_OTL_LATITUDE',
  gc_cp_yn_gtt_otl_unlocode      TYPE /saptrx/paramname     VALUE 'GTT_OTL_UNLOCODE',
  gc_cp_yn_gtt_otl_iata_code     TYPE /saptrx/paramname     VALUE 'GTT_OTL_IATA_CODE',
  gc_cp_yn_gtt_otl_description   TYPE /saptrx/paramname     VALUE 'GTT_OTL_DESCRIPTION',
  gc_cp_yn_gtt_otl_country_code  TYPE /saptrx/paramname     VALUE 'GTT_OTL_COUNTRY_CODE',
  gc_cp_yn_gtt_otl_city_name     TYPE /saptrx/paramname     VALUE 'GTT_OTL_CITY_NAME',
  gc_cp_yn_gtt_otl_region_code   TYPE /saptrx/paramname     VALUE 'GTT_OTL_REGION_CODE',
  gc_cp_yn_gtt_otl_house_number  TYPE /saptrx/paramname     VALUE 'GTT_OTL_HOUSE_NUMBER',
  gc_cp_yn_gtt_otl_street_name   TYPE /saptrx/paramname     VALUE 'GTT_OTL_STREET_NAME',
  gc_cp_yn_gtt_otl_postal_code   TYPE /saptrx/paramname     VALUE 'GTT_OTL_POSTAL_CODE',
  gc_cp_yn_gtt_otl_email_address TYPE /saptrx/paramname     VALUE 'GTT_OTL_EMAIL_ADDRESS',
  gc_cp_yn_gtt_otl_phone_number  TYPE /saptrx/paramname     VALUE 'GTT_OTL_PHONE_NUMBER'.
protected section.
private section.

  methods FILL_ONE_TIME_LOCATION
    importing
      !IV_VBELN type VBELN_VL
      !IT_TKNUM type TT_TKNUM
      !IT_VTTKVB type VTTKVB_TAB
      !IT_VTTSVB type VTTSVB_TAB
      !IS_CONTROL type /SAPTRX/BAPI_TRK_CONTROL_DATA
    exporting
      !ET_CONTROL_DATA type /SAPTRX/BAPI_TRK_CONTROL_TAB .
  methods PREPARE_CURRENT_LOC_DATA
    importing
      !IT_TKNUM type TT_TKNUM
      !IT_VTTKVB type VTTKVB_TAB
      !IT_VTTSVB type VTTSVB_TAB
    exporting
      !ET_ADDRESS_INFO type TT_ADDRESS_INFO .
  methods PREPARE_RELEVANT_LOC_DATA
    importing
      !IT_TKNUM type TT_TKNUM
      !IT_VTTKVB type VTTKVB_TAB
    exporting
      !ET_ADDRESS_INFO type TT_ADDRESS_INFO .
  methods PREPARE_DELIVERY_LOC_DATA
    importing
      !IV_VBELN type VBELN_VL
    exporting
      !ET_ADDRESS_INFO type TT_ADDRESS_INFO .
  methods MERGE_LOCATION_DATA
    importing
      !IT_ADDR_INFO_CUR type TT_ADDRESS_INFO
      !IT_ADDR_INFO_REL type TT_ADDRESS_INFO
      !IT_ADDR_INFO_DLV type TT_ADDRESS_INFO
    exporting
      !ET_ADDR_INFO_ALL type TT_ADDRESS_INFO .
  methods PREPARE_CONTROL_DATA
    importing
      !IT_ADDR_INFO type TT_ADDRESS_INFO
      !IS_CONTROL type /SAPTRX/BAPI_TRK_CONTROL_DATA
    exporting
      !ET_CONTROL_DATA type /SAPTRX/BAPI_TRK_CONTROL_TAB .
  methods GET_LIKP_DELTA_DATA
    importing
      !IV_TKNUM type TKNUM
      !IT_NEW_VTTP type VTTPVB_TAB
      !IT_NEW_VTTK type VTTKVB_TAB
      !IT_OLD_VTTK type VTTKVB_TAB
      !IT_LIKP_DELTA type VA_LIKPVB_T
    exporting
      !ET_LIKP_DELTA type VA_LIKPVB_T .
ENDCLASS.



CLASS ZCL_GTT_SOF_LE_SHIPMNT_IMP IMPLEMENTATION.


  METHOD fill_one_time_location.

    DATA:
      lt_addr_info_rel TYPE tt_address_info,
      lt_addr_info_cur TYPE tt_address_info,
      lt_addr_info_dlv TYPE tt_address_info,
      lt_addr_info_all TYPE tt_address_info.

    CLEAR et_control_data.

*   Step 1. Get current procced shipment location information
    prepare_current_loc_data(
      EXPORTING
        it_tknum        = it_tknum
        it_vttkvb       = it_vttkvb
        it_vttsvb       = it_vttsvb
      IMPORTING
        et_address_info = lt_addr_info_cur ).

*   Step 2. Get relevant shipment location information
    prepare_relevant_loc_data(
      EXPORTING
        it_tknum        = it_tknum
        it_vttkvb       = it_vttkvb
      IMPORTING
        et_address_info = lt_addr_info_rel ).

*   Step 3. Get delivery location information
    prepare_delivery_loc_data(
      EXPORTING
        iv_vbeln        = iv_vbeln
      IMPORTING
        et_address_info = lt_addr_info_dlv ).

*   Step 4. Merge the location information
    merge_location_data(
      EXPORTING
        it_addr_info_cur = lt_addr_info_cur
        it_addr_info_rel = lt_addr_info_rel
        it_addr_info_dlv = lt_addr_info_dlv
      IMPORTING
        et_addr_info_all = lt_addr_info_all ).

*   Step 5. Generate the location control data
    prepare_control_data(
      EXPORTING
        it_addr_info    = lt_addr_info_all
        is_control      = is_control
      IMPORTING
        et_control_data = et_control_data ).

  ENDMETHOD.


  method IF_EX_BADI_LE_SHIPMENT~AT_SAVE.
  endmethod.


METHOD if_ex_badi_le_shipment~before_update.

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
    ls_lips                   TYPE lips,
    lv_milestonenum           TYPE /saptrx/seq_num,
    lv_length                 TYPE i,
    lv_tmp_vbeln              TYPE vbeln_nach,
    lv_appobjid               TYPE /saptrx/aoid,
    lt_dlv_type               TYPE rseloption,
    lv_timezone               TYPE timezone,
    lv_plan_gr                TYPE boolean,
    lt_tknum                  TYPE tt_tknum,
    lt_vttp                   TYPE vttpvb_tab,
    lv_seq_num                TYPE /saptrx/seq_num,
    lv_tknum                  TYPE tknum,
    lv_current_tknum          TYPE tknum.

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
                                                                 tpnum = ls_vtsp_delta-tpnum.
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
                                                                   tpnum = ls_vtsp_delta-tpnum.
          IF sy-subrc EQ 0.
            MOVE ls_vttp_delta-vbeln TO ls_likp_delta-vbeln.
            COLLECT ls_likp_delta INTO lt_likp_delta.
          ENDIF.
        ENDLOOP.
      ENDLOOP.
      LOOP AT lt_vtts_delta INTO ls_vtts_delta WHERE updkz <> 'I' AND updkz <> 'D'.
        READ TABLE im_shipments_before_update-old_vtts INTO ls_vtts_old WITH KEY tknum = ls_vtts_delta-tknum
                                                                                 tsnum = ls_vtts_delta-tsnum.
        CHECK sy-subrc IS INITIAL.
        CLEAR: ls_vtsp_delta,  ls_vttp_delta.
        LOOP AT lt_vtsp_delta_tmp INTO ls_vtsp_delta WHERE tknum = ls_vtts_delta-tknum
                                                       AND tsnum = ls_vtts_delta-tsnum.
          READ TABLE lt_vttp_delta_tmp INTO ls_vttp_delta WITH KEY tknum = ls_vtsp_delta-tknum
                                                                   tpnum = ls_vtsp_delta-tpnum.
          IF sy-subrc EQ 0.
            MOVE ls_vttp_delta-vbeln TO ls_likp_delta-vbeln.
            COLLECT ls_likp_delta INTO lt_likp_delta.
          ENDIF.
        ENDLOOP.
      ENDLOOP.
    ENDIF.

*   Additional logic for add planned destination arrival event
*   1.Check the check-in date and time in shipment is changed or not
*   2.If Shipment Item(VTTP) contains newly insert or delete item,all of the delivery should be send to GTT again
*   because we need to generate new planned destination arrival event for these delivery
    CLEAR lt_vttp.
    APPEND LINES OF im_shipments_before_update-new_vttp TO lt_vttp.
    APPEND LINES OF im_shipments_before_update-old_vttp TO lt_vttp.
    get_likp_delta_data(
      EXPORTING
        iv_tknum      = ls_vttk-tknum
        it_new_vttp   = lt_vttp
        it_new_vttk   = im_shipments_before_update-new_vttk
        it_old_vttk   = im_shipments_before_update-old_vttk
        it_likp_delta = lt_likp_delta
      IMPORTING
        et_likp_delta = DATA(lt_likp_delta_additional) ).
    APPEND LINES OF lt_likp_delta_additional TO lt_likp_delta.
    CLEAR lt_likp_delta_additional.

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
                                                 AND lfart IN lt_dlv_type.
        CHECK sy-subrc EQ 0.
        SELECT SINGLE * INTO ls_vttk_tmp FROM vttk WHERE tknum = ls_vbfas-vbeln
                                                     AND ( abfer EQ '1' OR abfer EQ '3' ).
        CHECK sy-subrc EQ 0.
        MOVE-CORRESPONDING ls_vbfas TO ls_vbfa_new.
        APPEND ls_vbfa_new TO lt_vbfa_new.
      ENDLOOP.

      SELECT SINGLE * INTO ls_likp FROM likp WHERE vbeln = ls_likp_delta-vbeln
                                               AND lfart IN lt_dlv_type.
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
                                                 AND lfart IN lt_dlv_type.
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
        CLEAR: ls_appobj_ctabs,lt_tknum.
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

        ls_control-paramname = 'REPORTED_BY'.
        ls_control-value = sy-uname.
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

*         Note down the shipment number
          APPEND ls_vbfa_new-vbeln TO lt_tknum.
        ENDLOOP.
        IF sy-subrc NE 0.
          ls_control-paramname = 'YN_SHP_LINE_COUNT'.
          ls_control-paramindex = '1'.
          ls_control-value = ''.
          APPEND ls_control TO lt_control.
        ENDIF.

*       Support one-time location
        fill_one_time_location(
          EXPORTING
            iv_vbeln        = ls_likp_new-vbeln
            it_tknum        = lt_tknum
            it_vttkvb       = im_shipments_before_update-new_vttk
            it_vttsvb       = im_shipments_before_update-new_vtts
            is_control      = ls_control
          IMPORTING
            et_control_data = DATA(lt_location_data) ).
        APPEND LINES OF lt_location_data TO lt_control.
        CLEAR lt_location_data.

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
        CLEAR:
         lv_plan_gr,
         ls_eerel.
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

          lv_plan_gr = abap_true.

        ENDIF.
        lv_seq_num = lv_milestonenum.
        LOOP AT lt_dlv_watching_stops INTO ls_dlv_watching_stop WHERE vbeln = ls_likp_new-vbeln.
          lv_length = strlen( ls_dlv_watching_stop-stopid ) - 4.
          lv_tknum = ls_dlv_watching_stop-stopid+0(lv_length).
          IF lv_current_tknum <> lv_tknum.
            lv_current_tknum = lv_tknum.
            lv_seq_num = lv_milestonenum.
          ENDIF.

          READ TABLE lt_stops INTO ls_stop WITH KEY stopid = ls_dlv_watching_stop-stopid
                                                    loccat = ls_dlv_watching_stop-loccat.
          IF ls_stop-loctype = zif_gtt_sof_constants=>cs_loctype-bp.
            SHIFT ls_stop-locid LEFT DELETING LEADING '0'.
          ENDIF.
          IF ls_dlv_watching_stop-loccat = zif_gtt_sof_constants=>cs_loccat-departure.
*           Add planned source arrival event for LTL mode
            ls_expeventdata-locid2       = ls_stop-stopid.
            ls_expeventdata-loctype      = ls_stop-loctype.
            ls_expeventdata-locid1       = ls_stop-locid.
            TRY.
                zcl_gtt_sof_toolkit=>add_planned_source_arrival(
                  EXPORTING
                    is_expeventdata = ls_expeventdata
                    it_vttk         = im_shipments_before_update-new_vttk
                    it_vttp         = im_shipments_before_update-new_vttp
                    iv_seq_num      = lv_seq_num
                  IMPORTING
                    es_eventdata    = DATA(ls_eventdata) ).
              CATCH cx_udm_message.
            ENDTRY.
            IF ls_eventdata IS NOT INITIAL.
              APPEND ls_eventdata TO lt_exp_events.
              ADD 1 TO lv_seq_num.
            ENDIF.
            CLEAR ls_eventdata.

*           DEPARTURE planned event
            ls_expeventdata-milestone    = zif_gtt_sof_constants=>cs_milestone-departure.
            ls_expeventdata-milestonenum = lv_seq_num.
            ls_expeventdata-locid2       = ls_stop-stopid.
            ls_expeventdata-loctype      = ls_stop-loctype.
            ls_expeventdata-locid1       = ls_stop-locid.
            ls_expeventdata-evt_exp_datetime  = ls_stop-pln_evt_datetime.
            ls_expeventdata-evt_exp_tzone = ls_stop-pln_evt_timezone.
            APPEND ls_expeventdata TO lt_exp_events.
            ADD 1 TO lv_seq_num.

          ELSEIF ls_dlv_watching_stop-loccat = zif_gtt_sof_constants=>cs_loccat-arrival.
*           ARRIVAL planned event
            ls_expeventdata-milestone    = zif_gtt_sof_constants=>cs_milestone-arriv_dest.
            ls_expeventdata-milestonenum = lv_seq_num.
            ls_expeventdata-locid2       = ls_stop-stopid.
            ls_expeventdata-loctype      = ls_stop-loctype.
            ls_expeventdata-locid1       = ls_stop-locid.
            ls_expeventdata-evt_exp_datetime  = ls_stop-pln_evt_datetime.
            ls_expeventdata-evt_exp_tzone = ls_stop-pln_evt_timezone.
            APPEND ls_expeventdata TO lt_exp_events.
            ADD 1 TO lv_seq_num.

*           POD planned event
            CLEAR: lv_locid.
            SELECT SINGLE kunnr INTO lv_locid FROM likp WHERE vbeln = ls_likp_new-vbeln.
            IF lv_locid EQ ls_stop-locid AND ls_eerel-z_pdstk = 'X'.
              ls_expeventdata-milestone    = zif_gtt_sof_constants=>cs_milestone-pod.
              ls_expeventdata-milestonenum = lv_seq_num.
              ls_expeventdata-locid2       = ls_stop-stopid.
              ls_expeventdata-loctype      = ls_stop-loctype.
              ls_expeventdata-locid1       = ls_stop-locid.
              ls_expeventdata-evt_exp_datetime  = ls_stop-pln_evt_datetime.
              ls_expeventdata-evt_exp_tzone = ls_stop-pln_evt_timezone.
              APPEND ls_expeventdata TO lt_exp_events.
              ADD 1 TO lv_seq_num.
            ENDIF.

          ENDIF.

        ENDLOOP.
        lv_milestonenum = lv_seq_num.

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
        LOOP AT lt_lips INTO ls_lips WHERE vbeln = ls_likp_new-vbeln.
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
        ls_expeventdata-milestonenum  = lv_milestonenum.
        ls_expeventdata-milestone = zif_gtt_sof_constants=>cs_milestone-dlv_hd_completed.
        APPEND ls_expeventdata TO lt_exp_events.
        ADD 1 TO lv_milestonenum.

*       Add planned delivery event with planned timestamp
        CLEAR:
          ls_expeventdata-milestonenum,
          ls_expeventdata-evt_exp_datetime,
          ls_expeventdata-evt_exp_tzone,
          ls_expeventdata-loctype,
          ls_expeventdata-locid1,
          ls_expeventdata-locid2.
        ls_expeventdata-milestonenum  = lv_milestonenum.
        ls_expeventdata-milestone        = zif_gtt_sof_constants=>cs_milestone-odlv_planned_dlv.
        ls_expeventdata-evt_exp_datetime = |{ ls_likp_new-lfdat }{ ls_likp_new-lfuhr }|.
        ls_expeventdata-evt_exp_tzone    = ls_likp_new-tzonrc.
        APPEND ls_expeventdata TO lt_exp_events.
        ADD 1 TO lv_milestonenum.

        IF lv_plan_gr = abap_true.
*         Goods Receipt without event match key
*         Trigger Condition: STO outbound delivery item & GM relevant & LE-TRA scenario
          CLEAR:
            ls_expeventdata-milestonenum,
            ls_expeventdata-evt_exp_datetime,
            ls_expeventdata-evt_exp_tzone,
            ls_expeventdata-loctype,
            ls_expeventdata-locid1,
            ls_expeventdata-locid2.
          READ TABLE lt_lips INTO ls_lips
            WITH KEY vbeln = ls_likp_new-vbeln
                     vgtyp = if_sd_doc_category=>purchase_order.
          IF sy-subrc = 0.
            lv_timezone = ls_likp_new-tzonrc.
            IF lv_timezone IS INITIAL.
              TRY.
                  lv_timezone = zcl_gtt_tools=>get_system_time_zone( ).
                CATCH cx_udm_message.
              ENDTRY.
            ENDIF.
            ls_expeventdata-milestonenum  = lv_milestonenum.
            ls_expeventdata-milestone = zif_gtt_ef_constants=>cs_milestone-dl_goods_receipt.
            ls_expeventdata-evt_exp_tzone = lv_timezone.
            ls_expeventdata-evt_exp_datetime = |0{ ls_likp_new-lfdat }{ ls_likp_new-lfuhr }|.
            APPEND ls_expeventdata TO lt_exp_events.
            ADD 1 TO lv_milestonenum.
          ENDIF.

*         Goods Receipt with event match key
*         Trigger Condition: STO outbound delivery
          LOOP AT lt_lips INTO ls_lips WHERE vbeln = ls_likp_new-vbeln
                                         AND vgtyp = if_sd_doc_category=>purchase_order.

            CLEAR:
              ls_expeventdata-milestonenum,
              ls_expeventdata-evt_exp_datetime,
              ls_expeventdata-evt_exp_tzone,
              ls_expeventdata-loctype,
              ls_expeventdata-locid1,
              ls_expeventdata-locid2.

            ls_expeventdata-milestonenum  = lv_milestonenum.
            ls_expeventdata-milestone = zif_gtt_ef_constants=>cs_milestone-dl_goods_receipt.
            ls_expeventdata-evt_exp_tzone = lv_timezone.
            ls_expeventdata-evt_exp_datetime = |0{ ls_likp_new-lfdat }{ ls_likp_new-lfuhr }|.
            zcl_gtt_tools=>get_location_id(
              EXPORTING
                iv_vgbel  = ls_lips-vgbel
                iv_vgpos  = ls_lips-vgpos
              IMPORTING
                ev_locid1 = DATA(lv_locid1) ).
            ls_expeventdata-locid1 = lv_locid1.
            ls_expeventdata-locid2 = |{ ls_lips-vbeln ALPHA = OUT }{ ls_lips-posnr ALPHA = IN }|.
            CONDENSE ls_expeventdata-locid2 NO-GAPS.
            ls_expeventdata-loctype = zif_gtt_ef_constants=>cs_loc_types-plant.
            APPEND ls_expeventdata TO lt_exp_events.
            ADD 1 TO lv_milestonenum.
          ENDLOOP.
        ENDIF.

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


  METHOD MERGE_LOCATION_DATA.

    DATA:
      lt_addr_info_cur TYPE tt_address_info,
      lt_addr_info_rel TYPE tt_address_info,
      lt_addr_info_dlv TYPE tt_address_info.

    CLEAR et_addr_info_all.

    lt_addr_info_cur = it_addr_info_cur.
    lt_addr_info_rel = it_addr_info_rel.
    lt_addr_info_dlv = it_addr_info_dlv.

    LOOP AT lt_addr_info_cur INTO DATA(ls_loc_info_curr).
      READ TABLE lt_addr_info_rel INTO DATA(ls_addr_info_rel)
        WITH KEY locid   = ls_loc_info_curr-locid
                 loctype = ls_loc_info_curr-loctype.
      IF sy-subrc = 0.
        DELETE lt_addr_info_rel WHERE locid   = ls_loc_info_curr-locid
                                  AND loctype = ls_loc_info_curr-loctype.
      ENDIF.

      READ TABLE lt_addr_info_dlv INTO DATA(ls_addr_info_dlv)
        WITH KEY locid   = ls_loc_info_curr-locid
                 loctype = ls_loc_info_curr-loctype.
      IF sy-subrc = 0.
        DELETE lt_addr_info_dlv WHERE locid   = ls_loc_info_curr-locid
                                  AND loctype = ls_loc_info_curr-loctype.
      ENDIF.
    ENDLOOP.

    LOOP AT lt_addr_info_rel INTO ls_addr_info_rel.
      CLEAR ls_addr_info_dlv.
      READ TABLE lt_addr_info_dlv INTO ls_addr_info_dlv
        WITH KEY locid   = ls_addr_info_rel-locid
                 loctype = ls_addr_info_rel-loctype.
      IF sy-subrc = 0.
        DELETE lt_addr_info_dlv WHERE locid   = ls_addr_info_rel-locid
                                  AND loctype = ls_addr_info_rel-loctype.
      ENDIF.
    ENDLOOP.

    APPEND LINES OF lt_addr_info_cur TO et_addr_info_all.
    APPEND LINES OF lt_addr_info_rel TO et_addr_info_all.
    APPEND LINES OF lt_addr_info_dlv TO et_addr_info_all.

  ENDMETHOD.


  METHOD prepare_control_data.

    DATA:
      lv_paramindex   TYPE /saptrx/indexcounter,
      ls_control_data TYPE /saptrx/control_data.

    CLEAR:et_control_data.

    LOOP AT it_addr_info INTO DATA(ls_addr_info).

      lv_paramindex = lv_paramindex + 1.

*     Location ID
      ls_control_data-paramindex = lv_paramindex.
      ls_control_data-paramname = gc_cp_yn_gtt_otl_locid.
      ls_control_data-value = ls_addr_info-locid.
      IF ls_addr_info-loctype = zif_gtt_sof_constants=>cs_loctype-bp.
        ls_control_data-value = |{ ls_addr_info-locid ALPHA = OUT }|.
      ENDIF.
      APPEND ls_control_data TO et_control_data.

*     Location Type
      ls_control_data-paramindex = lv_paramindex.
      ls_control_data-paramname = gc_cp_yn_gtt_otl_loctype.
      ls_control_data-value = ls_addr_info-loctype.
      APPEND ls_control_data TO et_control_data.

*     Time Zone
      ls_control_data-paramindex = lv_paramindex.
      ls_control_data-paramname = gc_cp_yn_gtt_otl_timezone.
      ls_control_data-value = ls_addr_info-addr1-time_zone.
      APPEND ls_control_data TO et_control_data.

*     Description
      ls_control_data-paramindex = lv_paramindex.
      ls_control_data-paramname = gc_cp_yn_gtt_otl_description.
      ls_control_data-value = ls_addr_info-addr1-name1.
      APPEND ls_control_data TO et_control_data.

*     Country Code
      ls_control_data-paramindex = lv_paramindex.
      ls_control_data-paramname = gc_cp_yn_gtt_otl_country_code.
      ls_control_data-value = ls_addr_info-addr1-country.
      APPEND ls_control_data TO et_control_data.

*     City Name
      ls_control_data-paramindex = lv_paramindex.
      ls_control_data-paramname = gc_cp_yn_gtt_otl_city_name.
      ls_control_data-value = ls_addr_info-addr1-city1.
      APPEND ls_control_data TO et_control_data.

*     Region Code
      ls_control_data-paramindex = lv_paramindex.
      ls_control_data-paramname = gc_cp_yn_gtt_otl_region_code.
      ls_control_data-value = ls_addr_info-addr1-region.
      APPEND ls_control_data TO et_control_data.

*     House Number
      ls_control_data-paramindex = lv_paramindex.
      ls_control_data-paramname = gc_cp_yn_gtt_otl_house_number.
      ls_control_data-value = ls_addr_info-addr1-house_num1.
      APPEND ls_control_data TO et_control_data.

*     Street Name
      ls_control_data-paramindex = lv_paramindex.
      ls_control_data-paramname = gc_cp_yn_gtt_otl_street_name.
      ls_control_data-value = ls_addr_info-addr1-street.
      APPEND ls_control_data TO et_control_data.

*     Postal Code
      ls_control_data-paramindex = lv_paramindex.
      ls_control_data-paramname = gc_cp_yn_gtt_otl_postal_code.
      ls_control_data-value = ls_addr_info-addr1-post_code1.
      APPEND ls_control_data TO et_control_data.

*     Email Address
      ls_control_data-paramindex = lv_paramindex.
      ls_control_data-paramname = gc_cp_yn_gtt_otl_email_address.
      ls_control_data-value = ls_addr_info-email.
      APPEND ls_control_data TO et_control_data.

*     Phone Number
      ls_control_data-paramindex = lv_paramindex.
      ls_control_data-paramname = gc_cp_yn_gtt_otl_phone_number.
      ls_control_data-value = ls_addr_info-telephone.
      APPEND ls_control_data TO et_control_data.

    ENDLOOP.

    IF et_control_data IS INITIAL.
      ls_control_data-paramindex = 1.
      ls_control_data-paramname = gc_cp_yn_gtt_otl_locid.
      ls_control_data-value = ''.
      APPEND ls_control_data TO et_control_data.
    ENDIF.

    LOOP AT et_control_data ASSIGNING FIELD-SYMBOL(<fs_control_data>).
      <fs_control_data>-appsys = is_control-appsys.
      <fs_control_data>-appobjtype = is_control-appobjtype.
      <fs_control_data>-appobjid = is_control-appobjid.
      <fs_control_data>-language = is_control-language.
    ENDLOOP.

  ENDMETHOD.


  METHOD prepare_current_loc_data.

    DATA:
      lt_loc_info_tmp  TYPE tt_loc_info,
      lt_loc_info_curr TYPE tt_loc_info,
      ls_address_info  TYPE ts_address_info,
      lt_addr_info_cur TYPE tt_address_info,
      ls_loc_addr      TYPE addr1_data,
      lv_loc_email     TYPE ad_smtpadr,
      lv_loc_tel       TYPE char50,
      ls_loc_addr_tmp  TYPE addr1_data,
      lv_loc_email_tmp TYPE ad_smtpadr,
      lv_loc_tel_tmp   TYPE char50.

    CLEAR et_address_info.

    LOOP AT it_tknum INTO DATA(ls_tknum).
      CLEAR:
        lt_loc_info_tmp.
      READ TABLE it_vttkvb TRANSPORTING NO FIELDS
        WITH KEY tknum = ls_tknum.
      IF sy-subrc = 0.
*       Current procced shipment
        zcl_gtt_tools=>get_location_info(
          EXPORTING
            iv_tknum    = ls_tknum
            it_vttsvb   = it_vttsvb
          IMPORTING
            et_loc_info = lt_loc_info_tmp ).
        APPEND LINES OF lt_loc_info_tmp TO lt_loc_info_curr.
      ENDIF.
    ENDLOOP.

    LOOP AT lt_loc_info_curr INTO DATA(ls_loc_info_curr).
      CLEAR:
        ls_loc_addr,
        lv_loc_email,
        lv_loc_tel,
        ls_loc_addr_tmp,
        lv_loc_email_tmp,
        lv_loc_tel_tmp.

      IF ls_loc_info_curr-locaddrnum CN '0 ' AND ls_loc_info_curr-locindicator CA zif_gtt_ef_constants=>shp_addr_ind_man_all.
        zcl_gtt_tools=>get_address_from_memory(
          EXPORTING
            iv_addrnumber = ls_loc_info_curr-locaddrnum
          IMPORTING
            es_addr       = ls_loc_addr
            ev_email      = lv_loc_email
            ev_telephone  = lv_loc_tel ).

        zcl_gtt_tools=>get_address_detail_by_loctype(
          EXPORTING
            iv_loctype   = ls_loc_info_curr-loctype
            iv_locid     = ls_loc_info_curr-locid
          IMPORTING
            es_addr      = ls_loc_addr_tmp
            ev_email     = lv_loc_email_tmp
            ev_telephone = lv_loc_tel_tmp ).

        IF ls_loc_addr <> ls_loc_addr_tmp
          OR lv_loc_email <> lv_loc_email_tmp
          OR lv_loc_tel <> lv_loc_tel_tmp.
          ls_address_info-locid = ls_loc_info_curr-locid.
          ls_address_info-loctype = ls_loc_info_curr-loctype.
          ls_address_info-addr1 = ls_loc_addr.
          ls_address_info-email = lv_loc_email.
          ls_address_info-telephone = lv_loc_tel.
          APPEND ls_address_info TO et_address_info.
        ENDIF.
        CLEAR:
          ls_address_info.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.


  METHOD PREPARE_DELIVERY_LOC_DATA.

    DATA:
      lv_posnr        TYPE vbpa-posnr VALUE '000000',
      ls_vbpa         TYPE vbpavb,
      ls_address_info TYPE ts_address_info,
      ls_loc_addr     TYPE addr1_data,
      lv_loc_email    TYPE ad_smtpadr,
      lv_loc_tel      TYPE char50.

    CLEAR: et_address_info.

    CALL FUNCTION 'SD_VBPA_SINGLE_READ'
      EXPORTING
        i_vbeln          = iv_vbeln
        i_posnr          = lv_posnr
        i_parvw          = if_sd_partner=>co_partner_function_code-ship_to_party
      IMPORTING
        e_vbpavb         = ls_vbpa
      EXCEPTIONS
        record_not_found = 1
        OTHERS           = 2.

    IF sy-subrc = 0.
      IF ls_vbpa-adrnr CN '0 ' AND ls_vbpa-adrda CA zif_gtt_ef_constants=>vbpa_addr_ind_man_all.
        zcl_gtt_tools=>get_address_from_db(
          EXPORTING
            iv_addrnumber = ls_vbpa-adrnr
          IMPORTING
            es_addr       = ls_loc_addr
            ev_email      = lv_loc_email
            ev_telephone  = lv_loc_tel ).

        ls_address_info-locid = ls_vbpa-kunnr.
        ls_address_info-loctype = zif_gtt_sof_constants=>cs_loctype-bp.
        ls_address_info-addr1 = ls_loc_addr.
        ls_address_info-email = lv_loc_email.
        ls_address_info-telephone = lv_loc_tel.
        APPEND ls_address_info TO et_address_info.
        CLEAR:
          ls_address_info.
      ENDIF.
    ENDIF.

  ENDMETHOD.


  METHOD prepare_relevant_loc_data.

    DATA:
      lt_relevant_shp  TYPE tt_tknum,
      lt_tknum_range   TYPE STANDARD TABLE OF range_c10,
      lt_vttsvb        TYPE vttsvb_tab,
      lt_loc_info      TYPE tt_loc_info,
      ls_address_info  TYPE ts_address_info,
      ls_loc_addr      TYPE addr1_data,
      lv_loc_email     TYPE ad_smtpadr,
      lv_loc_tel       TYPE char50,
      ls_loc_addr_tmp  TYPE addr1_data,
      lv_loc_email_tmp TYPE ad_smtpadr,
      lv_loc_tel_tmp   TYPE char50.

    CLEAR et_address_info.

    LOOP AT it_tknum INTO DATA(ls_tknum).
      READ TABLE it_vttkvb TRANSPORTING NO FIELDS
        WITH KEY tknum = ls_tknum.
      IF sy-subrc <> 0.
        APPEND ls_tknum TO lt_relevant_shp.
      ENDIF.
    ENDLOOP.

    LOOP AT lt_relevant_shp INTO ls_tknum.
      lt_tknum_range = VALUE #( BASE lt_tknum_range (
        sign   = 'I'
        option = 'EQ'
        low    = ls_tknum ) ).
    ENDLOOP.

    CHECK lt_tknum_range IS NOT INITIAL.
    CALL FUNCTION 'ST_STAGES_READ'
      TABLES
        i_tknum_range = lt_tknum_range
        c_xvttsvb     = lt_vttsvb
      EXCEPTIONS
        no_shipments  = 1
        OTHERS        = 2.

    zcl_gtt_tools=>get_location_info(
      EXPORTING
        it_vttsvb   = lt_vttsvb
      IMPORTING
        et_loc_info = lt_loc_info ).

    LOOP AT lt_loc_info INTO DATA(ls_loc_info).
      CLEAR:
        ls_loc_addr,
        lv_loc_email,
        lv_loc_tel,
        ls_loc_addr_tmp,
        lv_loc_email_tmp,
        lv_loc_tel_tmp.

      IF ls_loc_info-locaddrnum CN '0 ' AND ls_loc_info-locindicator CA zif_gtt_ef_constants=>shp_addr_ind_man_all.
        zcl_gtt_tools=>get_address_from_db(
          EXPORTING
            iv_addrnumber = ls_loc_info-locaddrnum
          IMPORTING
            es_addr       = ls_loc_addr
            ev_email      = lv_loc_email
            ev_telephone  = lv_loc_tel ).

        zcl_gtt_tools=>get_address_detail_by_loctype(
          EXPORTING
            iv_loctype   = ls_loc_info-loctype
            iv_locid     = ls_loc_info-locid
          IMPORTING
            es_addr      = ls_loc_addr_tmp
            ev_email     = lv_loc_email_tmp
            ev_telephone = lv_loc_tel_tmp ).

        IF ls_loc_addr <> ls_loc_addr_tmp
          OR lv_loc_email <> lv_loc_email_tmp
          OR lv_loc_tel <> lv_loc_tel_tmp.
          ls_address_info-locid = ls_loc_info-locid.
          ls_address_info-loctype = ls_loc_info-loctype.
          ls_address_info-addr1 = ls_loc_addr.
          ls_address_info-email = lv_loc_email.
          ls_address_info-telephone = lv_loc_tel.
          APPEND ls_address_info TO et_address_info.
        ENDIF.
        CLEAR:
          ls_address_info.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.


  METHOD get_likp_delta_data.

    DATA:
      ls_likp_delta TYPE likpvb,
      lt_updkz      TYPE RANGE OF updkz_d,
      lv_likp_flg   TYPE flag.

    CLEAR et_likp_delta.

    lt_updkz  = VALUE #(
      (
        sign = 'I'
        option = 'EQ'
        low = zif_gtt_ef_constants=>cs_change_mode-insert
      )
      (
        sign = 'I'
        option = 'EQ'
        low = zif_gtt_ef_constants=>cs_change_mode-delete
      ) ).

    LOOP AT it_new_vttp TRANSPORTING NO FIELDS
      WHERE tknum = iv_tknum
        AND updkz IN lt_updkz.
      lv_likp_flg = abap_true.
      EXIT.
    ENDLOOP.

    LOOP AT it_new_vttp INTO DATA(ls_new_vttp)
      WHERE tknum = iv_tknum.

      READ TABLE it_new_vttk INTO DATA(ls_new_vttk)
        WITH KEY tknum = ls_new_vttp-tknum.

      READ TABLE it_old_vttk INTO DATA(ls_old_vttk)
        WITH KEY tknum = ls_new_vttp-tknum.

      IF ls_new_vttk-dpreg <> ls_old_vttk-dpreg OR ls_new_vttk-upreg <> ls_old_vttk-upreg
        OR lv_likp_flg = abap_true.
        READ TABLE it_likp_delta TRANSPORTING NO FIELDS
          WITH KEY vbeln = ls_new_vttp-vbeln.
        IF sy-subrc <> 0.
          READ TABLE et_likp_delta TRANSPORTING NO FIELDS
            WITH KEY vbeln = ls_new_vttp-vbeln.
          IF sy-subrc <> 0.
            ls_likp_delta-vbeln = ls_new_vttp-vbeln.
            APPEND ls_likp_delta TO et_likp_delta.
          ENDIF.
        ENDIF.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.
ENDCLASS.
