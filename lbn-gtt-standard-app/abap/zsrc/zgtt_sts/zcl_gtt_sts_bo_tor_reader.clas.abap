class ZCL_GTT_STS_BO_TOR_READER definition
  public
  create public .

public section.

  interfaces ZIF_GTT_STS_BO_READER .

  methods CONSTRUCTOR
    importing
      !IO_EF_PARAMETERS type ref to ZIF_GTT_STS_EF_PARAMETERS .
protected section.

  types TV_TRACKED_OBJECT_TYPE type STRING .
  types:
    tt_tracked_object_type TYPE STANDARD TABLE OF tv_tracked_object_type WITH EMPTY KEY .
  types TV_TRACKED_OBJECT_ID type CHAR20 .
  types:
    tt_tracked_object_id TYPE STANDARD TABLE OF tv_tracked_object_type WITH EMPTY KEY .
  types TV_CARRIER_REF_VALUE type /SCMTMS/BTD_ID .
  types:
    tt_carrier_ref_value TYPE STANDARD TABLE OF tv_carrier_ref_value WITH EMPTY KEY .
  types TV_CARRIER_REF_TYPE type CHAR35 .
  types:
    tt_carrier_ref_type TYPE STANDARD TABLE OF tv_carrier_ref_type WITH EMPTY KEY .
  types TV_SHIPPER_REF_VALUE type /SCMTMS/BTD_ID .
  types:
    tt_shipper_ref_value TYPE STANDARD TABLE OF tv_shipper_ref_value WITH EMPTY KEY .
  types TV_SHIPPER_REF_TYPE type CHAR35 .
  types:
    tt_shipper_ref_type TYPE STANDARD TABLE OF tv_shipper_ref_type WITH EMPTY KEY .
  types TV_STOP_ID type STRING .
  types:
    tt_stop_id TYPE STANDARD TABLE OF tv_stop_id WITH EMPTY KEY .
  types TV_ORDINAL_NO type INT4 .
  types:
    tt_ordinal_no TYPE STANDARD TABLE OF tv_ordinal_no WITH EMPTY KEY .
  types TV_LOC_TYPE type /SAPTRX/LOC_ID_TYPE .
  types:
    tt_loc_type TYPE STANDARD TABLE OF tv_loc_type WITH EMPTY KEY .
  types TV_LOC_ID type /SCMTMS/LOCATION_ID .
  types:
    tt_loc_id TYPE STANDARD TABLE OF tv_loc_id WITH EMPTY KEY .
  types:
    tt_req_doc_line_number TYPE STANDARD TABLE OF int4 WITH EMPTY KEY .
  types:
    tt_req_doc_number      TYPE STANDARD TABLE OF char20 WITH EMPTY KEY .
  types:
    tt_capacity_doc_line_number  TYPE STANDARD TABLE OF int4 WITH EMPTY KEY .
  types:
    tt_capacity_doc_number TYPE STANDARD TABLE OF /scmtms/tor_id WITH EMPTY KEY .
  types:
    tt_stop TYPE STANDARD TABLE OF /saptrx/loc_id_2 WITH EMPTY KEY .
  types:
    tt_resource_tp_line_cnt TYPE STANDARD TABLE OF int4 WITH EMPTY KEY .
  types:
    tt_resource_tp_id TYPE STANDARD TABLE OF string WITH EMPTY KEY .
  types:
    tt_tu_line_no TYPE STANDARD TABLE OF int4 WITH EMPTY KEY .
  types:
    tt_tu_type TYPE STANDARD TABLE OF char20 WITH EMPTY KEY .
  types:
    tt_tu_value TYPE STANDARD TABLE OF char255 WITH EMPTY KEY .
  types:
    tt_tu_number TYPE STANDARD TABLE OF char255 WITH EMPTY KEY .
  types:
    tt_tu_first_stop TYPE STANDARD TABLE OF char255 WITH EMPTY KEY .
  types:
    tt_tu_last_stop TYPE STANDARD TABLE OF char255 WITH EMPTY KEY .
  types:
    BEGIN OF ts_container,
      object_id    TYPE char20,
      object_value TYPE /scmtms/package_id,
    END OF ts_container .
  types:
    tt_container TYPE TABLE OF ts_container .
  types:
    tt_package TYPE TABLE OF ts_container .
  types:
    BEGIN OF ts_stop_info,
      tor_id   TYPE /scmtms/tor_id,
      stop_num TYPE numc4,
    END OF ts_stop_info .
  types:
    tt_stop_info TYPE TABLE OF ts_stop_info .

  constants:
    BEGIN OF cs_text_type,
      cont         TYPE /bobf/txc_text_type VALUE 'CONT',
      mobl         TYPE /bobf/txc_text_type VALUE 'MOBL',
      truck        TYPE /bobf/txc_text_type VALUE 'TRUCK',
      trail        TYPE /bobf/txc_text_type VALUE 'TRAIL',
      carrier_note TYPE /bobf/txc_text_type VALUE 'E0103',"Carrier's Note in Subcontr/Tendering
    END OF cs_text_type .
  constants:
    BEGIN OF cs_track_id,
      container_id  TYPE tv_tracked_object_type VALUE 'CONTAINER_ID',
      mobile_number TYPE tv_tracked_object_type VALUE 'MOBILE_NUMBER',
      truck_id      TYPE tv_tracked_object_type VALUE 'TRUCK_ID',
      license_plate TYPE tv_tracked_object_type VALUE 'LICENSE_PLATE',
      vessel        TYPE tv_tracked_object_type VALUE 'VESSEL',
      flight_number TYPE tv_tracked_object_type VALUE 'FLIGHT_NUMBER',
      imo           TYPE tv_tracked_object_type VALUE 'IMO',
      pkg_id        TYPE tv_tracked_object_type VALUE 'PACKAGE_ID',
      pkg_ext_id    TYPE tv_tracked_object_type VALUE 'PACKAGE_EXT_ID',
      trailer_id    TYPE tv_tracked_object_type VALUE 'TRAILER_ID',
    END OF cs_track_id .
  constants:
    BEGIN OF cs_mapping,
      shipment_type         TYPE /saptrx/paramname VALUE 'YN_SHP_SHIPMENT_TYPE',
      tor_id                TYPE /saptrx/paramname VALUE 'YN_SHP_NO',
      mtr                   TYPE /saptrx/paramname VALUE 'YN_SHP_MTR',
      gro_vol_val           TYPE /saptrx/paramname VALUE 'YN_SHP_VOLUME',
      gro_vol_uni           TYPE /saptrx/paramname VALUE 'YN_SHP_VOLUME_UOM',
      gro_wei_val           TYPE /saptrx/paramname VALUE 'YN_SHP_WEIGHT',
      gro_wei_uni           TYPE /saptrx/paramname VALUE 'YN_SHP_WEIGHT_UOM',
      qua_pcs_val           TYPE /saptrx/paramname VALUE 'YN_SHP_QUANTITY',
      qua_pcs_uni           TYPE /saptrx/paramname VALUE 'YN_SHP_QUANTITY_UOM',
      total_distance_km     TYPE /saptrx/paramname VALUE 'YN_SHP_TOTAL_DIST',
      total_distance_km_uom TYPE /saptrx/paramname VALUE 'YN_SHP_TOTAL_DIST_UOM',
      dgo_indicator         TYPE /saptrx/paramname VALUE 'YN_SHP_CONTAIN_DGOODS',
      total_duration_net    TYPE /saptrx/paramname VALUE 'YN_SHP_PLAN_NET_DURAT',
      shipping_type         TYPE /saptrx/paramname VALUE 'YN_SHP_SHIPPING_TYPE',
      traffic_direct        TYPE /saptrx/paramname VALUE 'YN_SHP_TRAFFIC_DIRECT',
      trmodcod              TYPE /saptrx/paramname VALUE 'YN_SHP_TRANSPORTATION_MODE',
      tspid                 TYPE /saptrx/paramname VALUE 'YN_SHP_SA_LBN_ID',
      tracked_object_id     TYPE /saptrx/paramname VALUE 'YN_SHP_TRACKED_RESOURCE_ID',
      tracked_object_type   TYPE /saptrx/paramname VALUE 'YN_SHP_TRACKED_RESOURCE_VALUE',
      carrier_ref_type      TYPE /saptrx/paramname VALUE 'YN_SHP_CARRIER_REF_TYPE',
      carrier_ref_value     TYPE /saptrx/paramname VALUE 'YN_SHP_CARRIER_REF_VALUE',
      shipper_ref_type      TYPE /saptrx/paramname VALUE 'YN_SHP_SHIPPER_REF_TYPE',
      shipper_ref_value     TYPE /saptrx/paramname VALUE 'YN_SHP_SHIPPER_REF_VALUE',
      inc_class_code        TYPE /saptrx/paramname VALUE 'YN_SHP_INCOTERM',
      inc_transf_loc_n      TYPE /saptrx/paramname VALUE 'YN_SHP_INCOTERM_LOC',
      country               TYPE /saptrx/paramname VALUE 'YN_SHP_REG_COUNTRY',
      platenumber           TYPE /saptrx/paramname VALUE 'YN_SHP_REG_NUM',
      res_id                TYPE /saptrx/paramname VALUE 'YN_SHP_VEHICLE',
      pln_dep_loc_id        TYPE /saptrx/paramname VALUE 'YN_SHP_PLN_DEP_LOC_ID',
      pln_dep_loc_type      TYPE /saptrx/paramname VALUE 'YN_SHP_PLN_DEP_LOC_TYPE',
      pln_dep_timest        TYPE /saptrx/paramname VALUE 'YN_SHP_PLN_DEP_BUS_DATETIME',
      pln_dep_timezone      TYPE /saptrx/paramname VALUE 'YN_SHP_PLN_DEP_BUS_TIMEZONE',
      pln_arr_loc_id        TYPE /saptrx/paramname VALUE 'YN_SHP_PLN_AR_LOC_ID',
      pln_arr_loc_type      TYPE /saptrx/paramname VALUE 'YN_SHP_PLN_AR_LOC_TYPE',
      pln_arr_timest        TYPE /saptrx/paramname VALUE 'YN_SHP_PLN_AR_BUS_DATETIME',
      pln_arr_timezone      TYPE /saptrx/paramname VALUE 'YN_SHP_PLN_AR_BUS_TIMEZONE',
      pln_grs_duration      TYPE /saptrx/paramname VALUE 'YN_SHP_GROSS_DUR',
      stop_id               TYPE /saptrx/paramname VALUE 'YN_SHP_VP_STOP_ID',
      ordinal_no            TYPE /saptrx/paramname VALUE 'YN_SHP_VP_STOP_ORD_NO',
      loc_type              TYPE /saptrx/paramname VALUE 'YN_SHP_VP_STOP_LOC_TYPE',
      loc_id                TYPE /saptrx/paramname VALUE 'YN_SHP_VP_STOP_LOC_ID',
      item_id               TYPE /saptrx/paramname VALUE 'YN_SHP_DLV_ITM_FU_ITEM_ID',
      erp_dlv_id            TYPE /saptrx/paramname VALUE 'YN_SHP_DLV_ITM_ERP_DLV_ID',
      erp_dlv_item_id       TYPE /saptrx/paramname VALUE 'YN_SHP_DLV_ITM_ERP_DLV_ITM_ID',
      itm_qua_pcs_val       TYPE /saptrx/paramname VALUE 'YN_SHP_DLV_ITM_QUANTITY',
      itm_qua_pcs_uni       TYPE /saptrx/paramname VALUE 'YN_SHP_DLV_ITM_QUANTITY_UOM',
      product_id            TYPE /saptrx/paramname VALUE 'YN_SHP_DLV_ITM_PRODUCT_ID',
      product_txt           TYPE /saptrx/paramname VALUE 'YN_SHP_DLV_ITM_PRODUCT_TEXT',
      req_doc_line_no       TYPE /saptrx/paramname VALUE 'YN_SHP_REQ_DOC_LINE_NO',
      req_doc_no            TYPE /saptrx/paramname VALUE 'YN_SHP_REQ_DOC_NO',
      req_doc_first_stop    TYPE /saptrx/paramname VALUE 'YN_SHP_REQ_DOC_FIRST_STOP',
      req_doc_last_stop     TYPE /saptrx/paramname VALUE 'YN_SHP_REQ_DOC_LAST_STOP',
      capa_doc_line_no      TYPE /saptrx/paramname VALUE 'YN_SHP_CAPA_DOC_LINE_NO',
      capa_doc_no           TYPE /saptrx/paramname VALUE 'YN_SHP_CAPA_DOC_NO',
      capa_doc_first_stop   TYPE /saptrx/paramname VALUE 'YN_SHP_CAPA_DOC_FIRST_STOP',
      capa_doc_last_stop    TYPE /saptrx/paramname VALUE 'YN_SHP_CAPA_DOC_LAST_STOP',
      dlv_item_inb_alt_id   TYPE /saptrx/paramname VALUE 'YN_SHP_DLV_ITM_INB_ALT_ID',
      dlv_item_oub_alt_id   TYPE /saptrx/paramname VALUE 'YN_SHP_DLV_ITM_OUB_ALT_ID',
      dlv_item_inb_logsys   TYPE /saptrx/paramname VALUE 'YN_SHP_DLV_ITM_INB_ALT_ID_LOGSYS',
      dlv_item_oub_logsys   TYPE /saptrx/paramname VALUE 'YN_SHP_DLV_ITM_OUB_ALT_ID_LOGSYS',
      estimated_datetime    TYPE /saptrx/paramname VALUE 'YN_SHP_ESTIMATED_DATETIME',
      estimated_timezone    TYPE /saptrx/paramname VALUE 'YN_SHP_ESTIMATED_TIMEZONE',
      resource_tp_line_cnt  TYPE /saptrx/paramname VALUE 'YN_SHP_RESOURCE_TP_LINE_COUNT',
      resource_tp_id        TYPE /saptrx/paramname VALUE 'YN_SHP_RESOURCE_TP_ID',
      tu_line_no            TYPE /saptrx/paramname VALUE 'YN_SHP_TU_LINE_NO',
      tu_type               TYPE /saptrx/paramname VALUE 'YN_SHP_TU_TYPE',
      tu_value              TYPE /saptrx/paramname VALUE 'YN_SHP_TU_VALUE',
      tu_number             TYPE /saptrx/paramname VALUE 'YN_SHP_TU_NO',
      tu_first_stop         TYPE /saptrx/paramname VALUE 'YN_SHP_TU_FIRST_STOP',
      tu_last_stop          TYPE /saptrx/paramname VALUE 'YN_SHP_TU_LAST_STOP',
    END OF cs_mapping .
  constants CS_BP_TYPE type BU_ID_TYPE value 'LBN001' ##NO_TEXT.
  data MO_EF_PARAMETERS type ref to ZIF_GTT_STS_EF_PARAMETERS .

  methods GET_DATA_FROM_TEXT_COLLECTION
    importing
      !IR_DATA type ref to DATA
      !IV_OLD_DATA type ABAP_BOOL default ABAP_FALSE
    exporting
      !ER_TEXT type ref to /BOBF/T_TXC_TXT_K
      !ER_TEXT_CONTENT type ref to /BOBF/T_TXC_CON_K
    raising
      CX_UDM_MESSAGE .
  methods GET_CONTAINER_AND_MOBILE_TRACK
    importing
      !IR_DATA type ref to DATA
      !IV_OLD_DATA type ABAP_BOOL default ABAP_FALSE
    changing
      !CT_TRACKED_OBJECT_TYPE type TT_TRACKED_OBJECT_TYPE
      !CT_TRACKED_OBJECT_ID type TT_TRACKED_OBJECT_ID
    raising
      CX_UDM_MESSAGE .
  methods GET_CONTAINER_MOBILE_TRACK_ID
    importing
      !IS_APP_OBJECT type TRXAS_APPOBJ_CTAB_WA
      !IV_OLD_DATA type ABAP_BOOL default ABAP_FALSE
    changing
      !CT_TRACK_ID_DATA type ZIF_GTT_STS_EF_TYPES=>TT_ENH_TRACK_ID_DATA
    raising
      CX_UDM_MESSAGE .
  methods ADD_TRACK_ID_DATA
    importing
      !IS_APP_OBJECT type TRXAS_APPOBJ_CTAB_WA
      !IV_TRXCOD type /SAPTRX/TRXCOD
      !IV_TRXID type /SAPTRX/TRXID
      !IV_ACTION type /SAPTRX/ACTION optional
    changing
      !CT_TRACK_ID type ZIF_GTT_STS_EF_TYPES=>TT_TRACK_ID_DATA
    raising
      CX_UDM_MESSAGE .
  methods GET_DOCREF_DATA
    importing
      !IR_ROOT type ref to DATA
      !IV_OLD_DATA type ABAP_BOOL default ABAP_FALSE
    changing
      !CT_CARRIER_REF_VALUE type TT_CARRIER_REF_VALUE
      !CT_CARRIER_REF_TYPE type TT_CARRIER_REF_TYPE
      !CT_SHIPPER_REF_VALUE type TT_SHIPPER_REF_VALUE
      !CT_SHIPPER_REF_TYPE type TT_SHIPPER_REF_TYPE
    raising
      CX_UDM_MESSAGE .
  methods CHECK_NON_IDOC_FIELDS
    importing
      !IS_APP_OBJECT type TRXAS_APPOBJ_CTAB_WA
    returning
      value(RV_RESULT) type ZIF_GTT_STS_EF_TYPES=>TV_CONDITION
    raising
      CX_UDM_MESSAGE .
  methods CHECK_NON_IDOC_STATUS_FIELDS
    importing
      !IS_APP_OBJECT type TRXAS_APPOBJ_CTAB_WA
    returning
      value(RV_RESULT) type ZIF_GTT_STS_EF_TYPES=>TV_CONDITION
    raising
      CX_UDM_MESSAGE .
  methods CHECK_NON_IDOC_STOP_FIELDS
    importing
      !IS_APP_OBJECT type TRXAS_APPOBJ_CTAB_WA
    returning
      value(RV_RESULT) type ZIF_GTT_STS_EF_TYPES=>TV_CONDITION
    raising
      CX_UDM_MESSAGE .
  methods GET_HEADER_DATA_FROM_STOP
    importing
      !IR_DATA type ref to DATA
      !IV_OLD_DATA type ABAP_BOOL default ABAP_FALSE
      !IT_STOP_SEQ type /SCMTMS/T_PLN_STOP_SEQ_D
    changing
      !CV_PLN_DEP_LOC_ID type /SCMTMS/S_EM_BO_TOR_STOP-LOG_LOCID
      !CV_PLN_DEP_LOC_TYPE type /SAPTRX/LOC_ID_TYPE
      !CV_PLN_DEP_TIMEST type CHAR16
      !CV_PLN_DEP_TIMEZONE type AD_TZONE
      !CV_PLN_ARR_LOC_ID type /SCMTMS/S_EM_BO_TOR_STOP-LOG_LOCID
      !CV_PLN_ARR_LOC_TYPE type /SAPTRX/LOC_ID_TYPE
      !CV_PLN_ARR_TIMEST type CHAR16
      !CV_PLN_ARR_TIMEZONE type AD_TZONE
    raising
      CX_UDM_MESSAGE .
  methods GET_STOP_SEQ
    importing
      !IR_DATA type ref to DATA
      !IV_OLD_DATA type ABAP_BOOL default ABAP_FALSE
      !IT_STOP_SEQ type /SCMTMS/T_PLN_STOP_SEQ_D
    changing
      !CT_STOP_ID type TT_STOP_ID
      !CT_ORDINAL_NO type TT_ORDINAL_NO
      !CT_LOC_TYPE type TT_LOC_TYPE
      !CT_LOC_ID type TT_LOC_ID
    raising
      CX_UDM_MESSAGE .
  methods GET_DATA_FROM_STOP
    importing
      !IR_DATA type ref to DATA
      !IV_OLD_DATA type ABAP_BOOL default ABAP_FALSE
    changing
      !CV_PLN_DEP_LOC_ID type /SCMTMS/S_EM_BO_TOR_STOP-LOG_LOCID
      !CV_PLN_DEP_LOC_TYPE type /SAPTRX/LOC_ID_TYPE
      !CV_PLN_DEP_TIMEST type CHAR16
      !CV_PLN_DEP_TIMEZONE type AD_TZONE
      !CV_PLN_ARR_LOC_ID type /SCMTMS/S_EM_BO_TOR_STOP-LOG_LOCID
      !CV_PLN_ARR_LOC_TYPE type /SAPTRX/LOC_ID_TYPE
      !CV_PLN_ARR_TIMEST type CHAR16
      !CV_PLN_ARR_TIMEZONE type AD_TZONE
      !CT_STOP_ID type TT_STOP_ID
      !CT_ORDINAL_NO type TT_ORDINAL_NO
      !CT_LOC_TYPE type TT_LOC_TYPE
      !CT_LOC_ID type TT_LOC_ID
    raising
      CX_UDM_MESSAGE .
  methods GET_CUSTOMIZING_AOT
    importing
      !IV_TOR_TYPE type /SCMTMS/TOR_TYPE
    returning
      value(RV_AOT) type /SAPTRX/AOTYPE .
  methods GET_REQUIREMENT_DOC_LIST
    importing
      !IR_DATA type ref to DATA
      !IV_OLD_DATA type ABAP_BOOL default ABAP_FALSE
    changing
      !CT_REQ_DOC_LINE_NO type TT_REQ_DOC_LINE_NUMBER
      !CT_REQ_DOC_NO type TT_REQ_DOC_NUMBER
    raising
      CX_UDM_MESSAGE .
  methods GET_CARRIER_NAME
    importing
      !IV_TSPID type BU_ID_NUMBER
      !IV_TSP_SCAC type /SCMTMS/SCACD
    returning
      value(RV_CARRIER) type BU_ID_NUMBER
    raising
      CX_UDM_MESSAGE .
  methods GET_RESOURCE_INFO
    importing
      !IV_OLD_DATA type ABAP_BOOL optional
      !IR_ROOT type ref to DATA
    changing
      !CT_RESOURCE_TP_LINE_CNT type TT_RESOURCE_TP_LINE_CNT
      !CT_RESOURCE_TP_ID type TT_RESOURCE_TP_ID
    raising
      CX_UDM_MESSAGE .
  methods GET_CONTAINER_ID
    importing
      !IR_DATA type ref to DATA
      !IV_OLD_DATA type ABAP_BOOL default ABAP_FALSE
    changing
      !ET_CONTAINER type TT_CONTAINER
    raising
      CX_UDM_MESSAGE .
  methods GET_STOP_INFO
    importing
      !IR_DATA type ref to DATA
      !IV_OLD_DATA type ABAP_BOOL default ABAP_FALSE
    changing
      !CT_STOP_INFO type TT_STOP_INFO
    raising
      CX_UDM_MESSAGE .
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_GTT_STS_BO_TOR_READER IMPLEMENTATION.


  METHOD add_track_id_data.

    APPEND VALUE #( appsys     = mo_ef_parameters->get_appsys( )
                    appobjtype = is_app_object-appobjtype
                    appobjid   = |{ is_app_object-appobjid ALPHA = OUT }|
                    trxcod     = iv_trxcod
                    trxid      = iv_trxid
                    action     = iv_action ) TO ct_track_id.

  ENDMETHOD.


  METHOD check_non_idoc_fields.

    rv_result = check_non_idoc_status_fields( is_app_object ).
    IF rv_result = zif_gtt_sts_ef_constants=>cs_condition-true.
      RETURN.
    ENDIF.

    rv_result = check_non_idoc_stop_fields( is_app_object = is_app_object ).

  ENDMETHOD.


  METHOD check_non_idoc_status_fields.

    FIELD-SYMBOLS:
      <lt_header_new> TYPE /scmtms/t_em_bo_tor_root,
      <lt_header_old> TYPE /scmtms/t_em_bo_tor_root,
      <ls_header>     TYPE /scmtms/s_em_bo_tor_root.

    rv_result = zif_gtt_sts_ef_constants=>cs_condition-false.

    DATA(lt_header_new) = mo_ef_parameters->get_appl_table(
                            iv_tabledef = zif_gtt_sts_constants=>cs_tabledef-fo_header_new ).
    DATA(lt_header_old) = mo_ef_parameters->get_appl_table(
                            iv_tabledef = zif_gtt_sts_constants=>cs_tabledef-fo_header_old ).
    ASSIGN lt_header_new->* TO <lt_header_new>.
    ASSIGN lt_header_old->* TO <lt_header_old>.

    ASSIGN is_app_object-maintabref->* TO <ls_header>.
    ASSIGN <lt_header_new>[ node_id = <ls_header>-node_id ] TO FIELD-SYMBOL(<ls_header_new>).
    ASSIGN <lt_header_old>[ node_id = <ls_header>-node_id ] TO FIELD-SYMBOL(<ls_header_old>).

    IF <ls_header> IS ASSIGNED AND <ls_header_new> IS ASSIGNED AND <ls_header_old> IS ASSIGNED.
      DATA(lv_execution_status_changed) = xsdbool(
        ( <ls_header_new>-execution = /scmtms/if_tor_status_c=>sc_root-execution-v_in_execution        OR
          <ls_header_new>-execution = /scmtms/if_tor_status_c=>sc_root-execution-v_ready_for_execution OR
          <ls_header_new>-execution = /scmtms/if_tor_status_c=>sc_root-execution-v_executed ) AND
        ( <ls_header_old>-execution <> /scmtms/if_tor_status_c=>sc_root-execution-v_in_execution        AND
          <ls_header_old>-execution <> /scmtms/if_tor_status_c=>sc_root-execution-v_ready_for_execution AND
          <ls_header_old>-execution <> /scmtms/if_tor_status_c=>sc_root-execution-v_executed ) ).

      DATA(lv_lifecycle_status_changed) = xsdbool(
        ( <ls_header_new>-lifecycle = /scmtms/if_tor_status_c=>sc_root-lifecycle-v_in_process OR
          <ls_header_new>-lifecycle = /scmtms/if_tor_status_c=>sc_root-lifecycle-v_completed ) AND
        ( <ls_header_old>-lifecycle <> /scmtms/if_tor_status_c=>sc_root-lifecycle-v_in_process AND
          <ls_header_old>-lifecycle <> /scmtms/if_tor_status_c=>sc_root-lifecycle-v_completed ) ).

      IF lv_execution_status_changed = abap_true OR lv_lifecycle_status_changed = abap_true.
        rv_result = zif_gtt_sts_ef_constants=>cs_condition-true.
        RETURN.
      ENDIF.
    ENDIF.

  ENDMETHOD.


  METHOD check_non_idoc_stop_fields.

    FIELD-SYMBOLS:
      <lt_stop_new> TYPE /scmtms/t_em_bo_tor_stop,
      <lt_stop_old> TYPE /scmtms/t_em_bo_tor_stop,
      <ls_header>   TYPE /scmtms/s_em_bo_tor_root.

    rv_result = zif_gtt_sts_ef_constants=>cs_condition-false.

    DATA(lt_stop_new) = mo_ef_parameters->get_appl_table(
                            iv_tabledef = zif_gtt_sts_constants=>cs_tabledef-fo_stop_new ).
    DATA(lt_stop_old) = mo_ef_parameters->get_appl_table(
                            iv_tabledef = zif_gtt_sts_constants=>cs_tabledef-fo_stop_old ).
    ASSIGN lt_stop_new->* TO <lt_stop_new>.
    ASSIGN lt_stop_old->* TO <lt_stop_old>.
    ASSIGN is_app_object-maintabref->* TO <ls_header>.
    IF sy-subrc <> 0.
      RETURN.
    ENDIF.
    LOOP AT <lt_stop_new> ASSIGNING FIELD-SYMBOL(<ls_stop_new>)
      USING KEY parent_seqnum WHERE parent_node_id = <ls_header>-node_id.
      ASSIGN <lt_stop_old>[ node_id = <ls_stop_new>-node_id ] TO FIELD-SYMBOL(<ls_stop_old>).
      CHECK sy-subrc = 0.
      IF <ls_stop_new>-aggr_assgn_start_l <> <ls_stop_old>-aggr_assgn_start_l OR
         <ls_stop_new>-aggr_assgn_end_l   <> <ls_stop_old>-aggr_assgn_end_l   OR
         <ls_stop_new>-aggr_assgn_start_c <> <ls_stop_old>-aggr_assgn_start_c OR
         <ls_stop_new>-aggr_assgn_end_c   <> <ls_stop_old>-aggr_assgn_end_c   OR
         <ls_stop_new>-plan_trans_time    <> <ls_stop_old>-plan_trans_time.
        rv_result = zif_gtt_sts_ef_constants=>cs_condition-true.
        EXIT.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.


  METHOD constructor.

    mo_ef_parameters = io_ef_parameters.

  ENDMETHOD.


  METHOD get_carrier_name.

    CONSTANTS lc_lbn TYPE char4 VALUE 'LBN#'.
    DATA:
      lv_partner TYPE but000-partner.

    CLEAR:rv_carrier.

*   Retrieve BP's LBN id
    IF iv_tspid IS NOT INITIAL.
      SELECT SINGLE idnumber
        FROM but0id
        INTO @DATA(lv_idnumber)
        WHERE partner = @iv_tspid AND
              type    = @cs_bp_type ##WARN_OK.
      IF sy-subrc = 0.
        rv_carrier = lc_lbn && lv_idnumber.
      ENDIF.
    ENDIF.

*   if BP‘s LBN id is empty,Retrieve SCAC code in the freight document with prefix "SCAC#"
    IF rv_carrier IS INITIAL AND iv_tsp_scac IS NOT INITIAL.
      rv_carrier = zif_gtt_sts_constants=>cv_scac_prefix && iv_tsp_scac.
    ENDIF.

*   if BP‘s LBN id and SCAC code in the freight document is empty,
*   Retrieve SCAC code in the BP‘s Carrier Role's SCAC code with prefix "SCAC#"
    IF rv_carrier IS INITIAL AND iv_tspid IS NOT INITIAL.
      lv_partner = iv_tspid.
      zcl_gtt_sts_tools=>get_scac_code(
        EXPORTING
          iv_partner = lv_partner
        RECEIVING
          rv_num     = DATA(lv_scac_number) ).
      rv_carrier = lv_scac_number.
    ENDIF.

  ENDMETHOD.


  METHOD get_container_and_mobile_track.

    get_data_from_text_collection(
      EXPORTING
        iv_old_data     = iv_old_data
        ir_data         = ir_data
      IMPORTING
        er_text         = DATA(lr_text)
        er_text_content = DATA(lr_text_content) ).

    IF lr_text->* IS NOT INITIAL AND lr_text_content->* IS NOT INITIAL.
      LOOP AT lr_text->* ASSIGNING FIELD-SYMBOL(<ls_text>).
        READ TABLE lr_text_content->* WITH KEY parent_key
          COMPONENTS parent_key = <ls_text>-key ASSIGNING FIELD-SYMBOL(<ls_text_content>).
        IF sy-subrc = 0.
          IF <ls_text>-text_type = cs_text_type-cont AND <ls_text_content>-text IS NOT INITIAL.
            APPEND cs_track_id-container_id TO ct_tracked_object_id.
            APPEND <ls_text_content>-text   TO ct_tracked_object_type.
          ELSEIF <ls_text>-text_type = cs_text_type-mobl AND <ls_text_content>-text IS NOT INITIAL.
            APPEND cs_track_id-mobile_number TO ct_tracked_object_id.
            APPEND <ls_text_content>-text    TO ct_tracked_object_type.
          ENDIF.
        ENDIF.
      ENDLOOP.
    ENDIF.

  ENDMETHOD.


  METHOD get_container_mobile_track_id.

    FIELD-SYMBOLS <ls_root> TYPE /scmtms/s_em_bo_tor_root.

    DATA:
      lv_tmp_restrxcod TYPE /saptrx/trxcod,
      lv_restrxcod     TYPE /saptrx/trxcod.

    ASSIGN is_app_object-maintabref->* TO <ls_root>.
    IF sy-subrc <> 0.
      MESSAGE e010(zgtt_sts) INTO DATA(lv_dummy) ##needed.
      zcl_gtt_sts_tools=>throw_exception( ).
    ENDIF.

    lv_restrxcod = zif_gtt_sts_constants=>cs_trxcod-fo_resource.

    get_data_from_text_collection(
      EXPORTING
        ir_data         = is_app_object-maintabref
        iv_old_data     = iv_old_data
      IMPORTING
        er_text         = DATA(lr_text)
        er_text_content = DATA(lr_text_content) ).

    IF lr_text->* IS NOT INITIAL AND lr_text_content->* IS NOT INITIAL.
      LOOP AT lr_text->* ASSIGNING FIELD-SYMBOL(<ls_text>).
        READ TABLE lr_text_content->* WITH KEY parent_key
          COMPONENTS parent_key = <ls_text>-key ASSIGNING FIELD-SYMBOL(<ls_text_content>).
        CHECK sy-subrc = 0.

        IF ( <ls_text>-text_type = cs_text_type-cont OR <ls_text>-text_type = cs_text_type-mobl ) AND
             <ls_text_content>-text IS NOT INITIAL.

          DATA(lv_tor_id) = |{ <ls_root>-tor_id ALPHA = OUT }|.
          CONDENSE lv_tor_id.
          APPEND VALUE #( key = <ls_text_content>-key
                   appsys      = mo_ef_parameters->get_appsys( )
                   appobjtype  = is_app_object-appobjtype
                   appobjid    = is_app_object-appobjid
                   trxcod      = lv_restrxcod
                   trxid       = |{ lv_tor_id }{ <ls_text_content>-text }| ) TO ct_track_id_data.
        ENDIF.
      ENDLOOP.
    ENDIF.

  ENDMETHOD.


  METHOD get_customizing_aot.

    SELECT SINGLE aotype
      FROM /scmtms/c_torty
      INTO rv_aot
      WHERE type = iv_tor_type.

  ENDMETHOD.


  METHOD get_data_from_stop.

    FIELD-SYMBOLS <ls_tor_root> TYPE /scmtms/s_em_bo_tor_root.

    ASSIGN ir_data->* TO <ls_tor_root>.
    IF sy-subrc <> 0.
      MESSAGE e010(zgtt_sts) INTO DATA(lv_dummy) ##needed.
      zcl_gtt_sts_tools=>throw_exception( ).
    ENDIF.

    /scmtms/cl_tor_helper_stop=>get_stop_sequence(
      EXPORTING
        it_root_key     = VALUE #( ( key = <ls_tor_root>-node_id ) )
        iv_before_image = SWITCH #( iv_old_data WHEN abap_true THEN abap_true ELSE abap_false )
      IMPORTING
        et_stop_seq_d   = DATA(lt_stop_seq) ).

    get_stop_seq(
      EXPORTING
        ir_data       = ir_data
        iv_old_data   = iv_old_data
        it_stop_seq   = lt_stop_seq
      CHANGING
        ct_stop_id    = ct_stop_id
        ct_ordinal_no = ct_ordinal_no
        ct_loc_type   = ct_loc_type
        ct_loc_id     = ct_loc_id ).

    get_header_data_from_stop(
      EXPORTING
        ir_data             = ir_data
        iv_old_data         = iv_old_data
        it_stop_seq         = lt_stop_seq
      CHANGING
        cv_pln_dep_loc_id   = cv_pln_dep_loc_id
        cv_pln_dep_loc_type = cv_pln_dep_loc_type
        cv_pln_dep_timest   = cv_pln_dep_timest
        cv_pln_dep_timezone = cv_pln_dep_timezone
        cv_pln_arr_loc_id   = cv_pln_arr_loc_id
        cv_pln_arr_loc_type = cv_pln_arr_loc_type
        cv_pln_arr_timest   = cv_pln_arr_timest
        cv_pln_arr_timezone = cv_pln_arr_timezone ).

  ENDMETHOD.


  METHOD get_data_from_text_collection.

    FIELD-SYMBOLS <ls_root> TYPE /scmtms/s_em_bo_tor_root.
    ASSIGN ir_data->* TO <ls_root>.
    IF sy-subrc <> 0.
      MESSAGE e010(zgtt_sts) INTO DATA(lv_dummy) ##needed.
      zcl_gtt_sts_tools=>throw_exception( ).
    ENDIF.

    DATA(lv_before_image) = SWITCH abap_bool( iv_old_data WHEN abap_true THEN abap_true
                                                          ELSE abap_false ).

    DATA(lr_srvmgr_tor) = /bobf/cl_tra_serv_mgr_factory=>get_service_manager( iv_bo_key = /scmtms/if_tor_c=>sc_bo_key ).
    TRY.
        DATA(lr_bo_conf) = /bobf/cl_frw_factory=>get_configuration( iv_bo_key = /scmtms/if_tor_c=>sc_bo_key ).
      CATCH /bobf/cx_frw.
        MESSAGE e011(zgtt_sts) INTO  lv_dummy.
        zcl_gtt_sts_tools=>throw_exception( ).
    ENDTRY.
    DATA(lv_txt_key) = lr_bo_conf->get_content_key_mapping(
                           iv_content_cat      = /bobf/if_conf_c=>sc_content_nod
                           iv_do_content_key   = /bobf/if_txc_c=>sc_node-text
                           iv_do_root_node_key = /scmtms/if_tor_c=>sc_node-textcollection ).

    DATA(lv_txt_assoc) = lr_bo_conf->get_content_key_mapping(
                             iv_content_cat      = /bobf/if_conf_c=>sc_content_ass
                             iv_do_content_key   = /bobf/if_txc_c=>sc_association-root-text
                             iv_do_root_node_key = /scmtms/if_tor_c=>sc_node-textcollection ).

    DATA(lv_cont_assoc) = lr_bo_conf->get_content_key_mapping(
                              iv_content_cat      = /bobf/if_conf_c=>sc_content_ass
                              iv_do_content_key   = /bobf/if_txc_c=>sc_association-text-text_content
                              iv_do_root_node_key = /scmtms/if_tor_c=>sc_node-textcollection ).

    lr_srvmgr_tor->retrieve_by_association(
      EXPORTING
        it_key          = VALUE #( ( key = <ls_root>-node_id ) )
        iv_node_key     = /scmtms/if_tor_c=>sc_node-root
        iv_association  = /scmtms/if_tor_c=>sc_association-root-textcollection
        iv_before_image = lv_before_image
      IMPORTING
        et_target_key   = DATA(lt_textcollection_key) ).

    CREATE DATA er_text.
    CREATE DATA er_text_content.

    IF lt_textcollection_key IS NOT INITIAL.

      lr_srvmgr_tor->retrieve_by_association(
        EXPORTING
          it_key          = lt_textcollection_key
          iv_node_key     = /scmtms/if_tor_c=>sc_node-textcollection
          iv_association  = lv_txt_assoc
          iv_fill_data    = abap_true
          iv_before_image = lv_before_image
        IMPORTING
          et_data         = er_text->* ).

      IF er_text->* IS NOT INITIAL.

        lr_srvmgr_tor->retrieve_by_association(
          EXPORTING
            it_key          = CORRESPONDING #( er_text->* )
            iv_node_key     = lv_txt_key
            iv_association  = lv_cont_assoc
            iv_fill_data    = abap_true
            iv_before_image = lv_before_image
          IMPORTING
            et_data         = er_text_content->* ).
      ENDIF.
    ENDIF.

  ENDMETHOD.


  METHOD get_docref_data.

    DATA lt_docs TYPE /scmtms/t_tor_docref_k.
    FIELD-SYMBOLS <ls_root> TYPE /scmtms/s_em_bo_tor_root.

    ASSIGN ir_root->* TO <ls_root>.
    IF sy-subrc = 0.
      /bobf/cl_tra_serv_mgr_factory=>get_service_manager(
        /scmtms/if_tor_c=>sc_bo_key )->retrieve_by_association(
        EXPORTING
          iv_node_key    = /scmtms/if_tor_c=>sc_node-root
          it_key         = VALUE #( ( key = <ls_root>-node_id ) )
          iv_association = /scmtms/if_tor_c=>sc_association-root-docreference
          iv_fill_data   = abap_true
          iv_before_image = SWITCH #( iv_old_data WHEN abap_true THEN abap_true
                                                  ELSE abap_false )
        IMPORTING
          et_data        = lt_docs ).

      LOOP AT lt_docs ASSIGNING FIELD-SYMBOL(<ls_docs>).
        SHIFT  <ls_docs>-btd_id LEFT DELETING LEADING '0'.
        IF <ls_docs>-btd_tco = zif_gtt_sts_constants=>cs_btd_type_code-bill_of_landing        OR
           <ls_docs>-btd_tco = zif_gtt_sts_constants=>cs_btd_type_code-master_bill_of_landing OR
           <ls_docs>-btd_tco = zif_gtt_sts_constants=>cs_btd_type_code-master_air_waybill     OR
           <ls_docs>-btd_tco = zif_gtt_sts_constants=>cs_btd_type_code-carrier_assigned       OR
           <ls_docs>-btd_tco = zif_gtt_sts_constants=>cs_btd_type_code-carrierreferenceno.
          APPEND <ls_docs>-btd_id  TO ct_carrier_ref_value.
          APPEND <ls_docs>-btd_tco TO ct_carrier_ref_type.
        ELSEIF <ls_docs>-btd_tco = zif_gtt_sts_constants=>cs_btd_type_code-purchase_order OR
           <ls_docs>-btd_tco = zif_gtt_sts_constants=>cs_btd_type_code-inbound_delivery   OR
           <ls_docs>-btd_tco = zif_gtt_sts_constants=>cs_btd_type_code-outbound_delivery  OR
           <ls_docs>-btd_tco = zif_gtt_sts_constants=>cs_btd_type_code-sales_order        OR
           <ls_docs>-btd_tco = zif_gtt_sts_constants=>cs_btd_type_code-stock_transport_order.
          APPEND <ls_docs>-btd_id  TO ct_shipper_ref_value.
          APPEND <ls_docs>-btd_tco TO ct_shipper_ref_type.
        ENDIF.
      ENDLOOP.
    ELSE.
      MESSAGE e002(zgtt_sts) INTO DATA(lv_dummy) ##needed.
      zcl_gtt_sts_tools=>throw_exception( ).
    ENDIF.

  ENDMETHOD.


  METHOD get_header_data_from_stop.

    FIELD-SYMBOLS <ls_tor_root> TYPE /scmtms/s_em_bo_tor_root.

    ASSIGN ir_data->* TO <ls_tor_root>.
    IF sy-subrc <> 0.
      MESSAGE e010(zgtt_sts) INTO DATA(lv_dummy) ##needed.
      zcl_gtt_sts_tools=>throw_exception( ).
    ENDIF.

    ASSIGN it_stop_seq[ 1 ] TO FIELD-SYMBOL(<ls_stop_seq>).
    IF sy-subrc = 0.
      ASSIGN <ls_stop_seq>-stop_seq[ 1 ] TO FIELD-SYMBOL(<ls_stop_first>).
      IF sy-subrc = 0.
        IF <ls_stop_first>-log_locid IS NOT INITIAL.
          cv_pln_dep_loc_id   = <ls_stop_first>-log_locid.
          cv_pln_dep_loc_type = zcl_gtt_sts_tools=>get_location_type( iv_locno = <ls_stop_first>-log_locid ).
        ENDIF.
        cv_pln_dep_timest   = COND #( WHEN <ls_stop_first>-plan_trans_time IS NOT INITIAL
                                        THEN |0{ <ls_stop_first>-plan_trans_time }| ELSE '' ).
        cv_pln_dep_timezone = /scmtms/cl_common_helper=>loc_key_get_timezone( iv_loc_key = <ls_stop_first>-log_loc_uuid ).
      ENDIF.
      ASSIGN <ls_stop_seq>-stop_seq[ lines( <ls_stop_seq>-stop_seq ) ] TO FIELD-SYMBOL(<ls_stop_last>).
      IF sy-subrc = 0.
        IF <ls_stop_last>-log_locid IS NOT INITIAL.
          cv_pln_arr_loc_id   = <ls_stop_last>-log_locid.
          cv_pln_arr_loc_type = zcl_gtt_sts_tools=>get_location_type( iv_locno = <ls_stop_last>-log_locid ).
        ENDIF.
        cv_pln_arr_timest   = COND #( WHEN <ls_stop_last>-plan_trans_time IS NOT INITIAL
                                        THEN |0{ <ls_stop_last>-plan_trans_time }| ELSE '' ).
        cv_pln_arr_timezone = /scmtms/cl_common_helper=>loc_key_get_timezone( iv_loc_key = <ls_stop_last>-log_loc_uuid ).
      ENDIF.
    ENDIF.

  ENDMETHOD.


  METHOD get_requirement_doc_list.

    DATA: lv_freight_unit_line_no TYPE int4,
          lv_tabledef_req_stop    TYPE /saptrx/strucdataname,
          lt_tor_req_stop_before  TYPE /scmtms/t_tor_stop_k,
          lt_fo_stop              TYPE /scmtms/t_em_bo_tor_stop,
          lt_req_stop             TYPE /scmtms/t_em_bo_tor_stop,
          lv_seq_num              TYPE /scmtms/seq_num.

    FIELD-SYMBOLS:
      <lt_req_stop>        TYPE /scmtms/t_em_bo_tor_stop,
      <ls_tor_root>        TYPE /scmtms/s_em_bo_tor_root,
      <lt_tor_root_req>    TYPE /scmtms/t_em_bo_tor_root,
      <lt_tor_root_req_tu> TYPE /scmtms/t_em_bo_tor_root,
      <lt_capa_stop>       TYPE /scmtms/t_em_bo_tor_stop.

    ASSIGN ir_data->* TO <ls_tor_root>.
    IF sy-subrc <> 0.
      MESSAGE e010(zgtt_sts) INTO DATA(lv_dummy) ##needed.
      zcl_gtt_sts_tools=>throw_exception( ).
    ENDIF.

    DATA(lv_tabledef_fu) = SWITCH #( iv_old_data
                             WHEN abap_false THEN /scmtms/cl_scem_int_c=>sc_table_definition-bo_tor-req_root
                             ELSE /scmtms/cl_scem_int_c=>sc_table_definition-bo_tor-req_root_before ).

    DATA(lr_req_root) = mo_ef_parameters->get_appl_table( iv_tabledef = lv_tabledef_fu ).
    ASSIGN lr_req_root->* TO <lt_tor_root_req>.
    IF sy-subrc <> 0.
      MESSAGE e010(zgtt_sts) INTO lv_dummy.
      zcl_gtt_sts_tools=>throw_exception( ).
    ENDIF.

    DATA(lv_tabledef_tu) = SWITCH #( iv_old_data
                             WHEN abap_false THEN /scmtms/cl_scem_int_c=>sc_table_definition-bo_tor-req_tu_root
                             ELSE /scmtms/cl_scem_int_c=>sc_table_definition-bo_tor-req_tu_root_before ).

    DATA(lr_req_root_tu) = mo_ef_parameters->get_appl_table( iv_tabledef = lv_tabledef_tu ).
    ASSIGN lr_req_root_tu->* TO <lt_tor_root_req_tu>.
    IF sy-subrc <> 0.
      MESSAGE e010(zgtt_sts) INTO lv_dummy.
      zcl_gtt_sts_tools=>throw_exception( ).
    ENDIF.
    INSERT LINES OF <lt_tor_root_req_tu> INTO TABLE <lt_tor_root_req>.

    DATA(lo_tor_srv_mgr) = /bobf/cl_tra_serv_mgr_factory=>get_service_manager( iv_bo_key = /scmtms/if_tor_c=>sc_bo_key ).
    TEST-SEAM lt_capa2req_link.
      lo_tor_srv_mgr->retrieve_by_association(
        EXPORTING
          iv_node_key    = /scmtms/if_tor_c=>sc_node-root
          it_key         = VALUE #( ( key = <ls_tor_root>-node_id ) )
          iv_association = /scmtms/if_tor_c=>sc_association-root-req_tor
        IMPORTING
          et_key_link    = DATA(lt_capa2req_link) ).
    END-TEST-SEAM.

    LOOP AT lt_capa2req_link ASSIGNING FIELD-SYMBOL(<ls_capa2req_link>).
      ASSIGN <lt_tor_root_req>[ node_id = <ls_capa2req_link>-target_key ] TO FIELD-SYMBOL(<ls_tor_req_id>).
      CHECK sy-subrc = 0.

      lv_freight_unit_line_no += 1.
      APPEND lv_freight_unit_line_no TO ct_req_doc_line_no.

      APPEND |{ <ls_tor_req_id>-tor_id ALPHA = OUT }| TO ct_req_doc_no.

    ENDLOOP.

  ENDMETHOD.


  METHOD get_stop_seq.

    FIELD-SYMBOLS <ls_tor_root> TYPE /scmtms/s_em_bo_tor_root.
    DATA:
      lv_stop_num(4) TYPE n,
      lv_loctype     TYPE /saptrx/loc_id_type.

    ASSIGN ir_data->* TO <ls_tor_root>.
    IF sy-subrc <> 0.
      MESSAGE e010(zgtt_sts) INTO DATA(lv_dummy) ##needed.
      zcl_gtt_sts_tools=>throw_exception( ).
    ENDIF.

    DATA(lv_tor_id) = <ls_tor_root>-tor_id.
    SHIFT lv_tor_id LEFT DELETING LEADING '0'.

    ASSIGN it_stop_seq[ root_key = <ls_tor_root>-node_id ]-stop_seq TO FIELD-SYMBOL(<lt_stop_seq>) ##WARN_OK.
    IF sy-subrc = 0.
      LOOP AT <lt_stop_seq> ASSIGNING FIELD-SYMBOL(<ls_stop_seq>).
        CHECK zcl_gtt_sts_tools=>is_odd( <ls_stop_seq>-seq_num ).
        lv_stop_num += 1.
        CHECK <ls_stop_seq>-log_locid IS NOT INITIAL.

        lv_loctype = zcl_gtt_sts_tools=>get_location_type( iv_locno = <ls_stop_seq>-log_locid ).

        APPEND |{ lv_tor_id }{ lv_stop_num }|  TO ct_stop_id.
        APPEND lv_stop_num                     TO ct_ordinal_no.
        APPEND lv_loctype                      TO ct_loc_type.
        APPEND <ls_stop_seq>-log_locid         TO ct_loc_id.
        CLEAR:lv_loctype.
      ENDLOOP.
    ENDIF.

    lv_stop_num += 1.
    DATA(lv_stop_count) = lines( <lt_stop_seq> ).

    ASSIGN <lt_stop_seq>[ lv_stop_count ] TO <ls_stop_seq>.
    IF sy-subrc = 0 AND <ls_stop_seq>-log_locid IS NOT INITIAL.
      lv_loctype = zcl_gtt_sts_tools=>get_location_type( iv_locno = <ls_stop_seq>-log_locid ).
      APPEND |{ lv_tor_id }{ lv_stop_num }| TO ct_stop_id.
      APPEND lv_stop_num                    TO ct_ordinal_no.
      APPEND lv_loctype                     TO ct_loc_type.
      APPEND <ls_stop_seq>-log_locid        TO ct_loc_id.
    ENDIF.

    IF ct_ordinal_no IS INITIAL.
      APPEND '' TO ct_ordinal_no.
    ENDIF.

  ENDMETHOD.


  METHOD zif_gtt_sts_bo_reader~check_relevance.

    " FO relevance function
    FIELD-SYMBOLS <ls_root> TYPE /scmtms/s_em_bo_tor_root.

    rv_result = zif_gtt_sts_ef_constants=>cs_condition-false.

    ASSIGN is_app_object-maintabref->* TO <ls_root>.
    IF sy-subrc <> 0.
      RETURN.
    ENDIF.

    IF get_customizing_aot( <ls_root>-tor_type ) <> is_app_object-appobjtype.
      RETURN.
    ENDIF.

    zcl_gtt_sts_tools=>get_gtt_relev_flag_by_aot_type(
      EXPORTING
        iv_aotype     = <ls_root>-aotype
      RECEIVING
        rv_torelevant = DATA(lv_torelevant) ).
    IF lv_torelevant = abap_false.
      RETURN.
    ENDIF.

    IF is_app_object-maintabdef = zif_gtt_sts_constants=>cs_tabledef-fo_header_new AND
      ( <ls_root>-track_exec_rel = zif_gtt_sts_constants=>cs_track_exec_rel-execution OR
        <ls_root>-track_exec_rel = zif_gtt_sts_constants=>cs_track_exec_rel-exec_with_extern_event_mngr ) AND
      <ls_root>-lifecycle = zif_gtt_sts_constants=>cs_lifecycle_status-in_process AND
      ( <ls_root>-execution = zif_gtt_sts_constants=>cs_execution_status-in_execution OR
        <ls_root>-execution = zif_gtt_sts_constants=>cs_execution_status-ready_for_transp_exec ) AND
     <ls_root>-tspid IS NOT INITIAL AND
      ( <ls_root>-tor_cat = /scmtms/if_tor_const=>sc_tor_category-active OR
        <ls_root>-tor_cat = /scmtms/if_tor_const=>sc_tor_category-booking ).

      CASE is_app_object-update_indicator.
        WHEN zif_gtt_sts_ef_constants=>cs_change_mode-insert.
          rv_result = zif_gtt_sts_ef_constants=>cs_condition-true.
        WHEN zif_gtt_sts_ef_constants=>cs_change_mode-update OR
             zif_gtt_sts_ef_constants=>cs_change_mode-undefined.
          rv_result = zcl_gtt_sts_tools=>are_structures_different(
                          ir_data1  = zif_gtt_sts_bo_reader~get_data( is_app_object = is_app_object )
                          ir_data2  = zif_gtt_sts_bo_reader~get_data(
                                          is_app_object = is_app_object
                                          iv_old_data   = abap_true ) ).
          IF rv_result = zif_gtt_sts_ef_constants=>cs_condition-false.
            rv_result = check_non_idoc_fields( is_app_object ).
          ENDIF.
      ENDCASE.
    ENDIF.

  ENDMETHOD.


  METHOD zif_gtt_sts_bo_reader~get_data.
    RETURN.
  ENDMETHOD.


  METHOD zif_gtt_sts_bo_reader~get_mapping_structure.

    rr_data = REF #( cs_mapping ).

  ENDMETHOD.


  METHOD zif_gtt_sts_bo_reader~get_track_id_data.
    CLEAR et_track_id_data.
    RETURN.
  ENDMETHOD.


  METHOD get_resource_info.

    FIELD-SYMBOLS:
      <ls_root>     TYPE /scmtms/s_em_bo_tor_root,
      <lt_root_old> TYPE /scmtms/t_em_bo_tor_root,
      <lt_item>     TYPE /scmtms/t_em_bo_tor_item.

    DATA:
      lv_count          TYPE int4 VALUE 1,
      lr_item           TYPE REF TO data,
      lv_tor_id         TYPE /scmtms/tor_id,
      lv_resource_tp_id TYPE string.

    CLEAR:
      ct_resource_tp_line_cnt,
      ct_resource_tp_id.

    ASSIGN ir_root->* TO <ls_root>.
    IF sy-subrc <> 0.
      MESSAGE e010(zgtt_sts) INTO DATA(lv_dummy) ##needed.
      zcl_gtt_sts_tools=>throw_exception( ).
    ENDIF.

    IF iv_old_data = abap_true.
      DATA(lr_root_old) = mo_ef_parameters->get_appl_table( zif_gtt_sts_constants=>cs_tabledef-fo_header_old ).
      ASSIGN lr_root_old->* TO <lt_root_old>.
      IF sy-subrc = 0.
        ASSIGN <lt_root_old>[ tor_id = <ls_root>-tor_id ] TO <ls_root>.
        IF sy-subrc <> 0.
          " FO is just crerated
          RETURN.
        ENDIF.
      ENDIF.
    ENDIF.

    lv_tor_id = <ls_root>-tor_id.
    SHIFT lv_tor_id LEFT DELETING LEADING '0'.

    lr_item = mo_ef_parameters->get_appl_table(
                                SWITCH #( iv_old_data WHEN abap_true THEN zif_gtt_sts_constants=>cs_tabledef-fo_item_old
                                                      ELSE zif_gtt_sts_constants=>cs_tabledef-fo_item_new ) ).
    ASSIGN lr_item->* TO <lt_item>.
    IF sy-subrc <> 0.
      MESSAGE e010(zgtt_sts) INTO lv_dummy ##needed.
      zcl_gtt_sts_tools=>throw_exception( ).
    ENDIF.

    get_data_from_text_collection(
      EXPORTING
        iv_old_data     = iv_old_data
        ir_data         = ir_root
      IMPORTING
        er_text         = DATA(lr_text)
        er_text_content = DATA(lr_text_content) ).

    CASE <ls_root>-tor_cat.
      WHEN /scmtms/if_tor_const=>sc_tor_category-active. "Freight order

        ASSIGN <lt_item>[ item_cat = /scmtms/if_tor_const=>sc_tor_item_category-av_item ] TO FIELD-SYMBOL(<ls_av_item>).
        IF sy-subrc <> 0.
          MESSAGE e010(zgtt_sts) INTO lv_dummy.
          zcl_gtt_sts_tools=>throw_exception( ).
        ENDIF.

*       Registration Number
        IF <ls_av_item>-platenumber IS NOT INITIAL.
          CLEAR lv_resource_tp_id.
          CONCATENATE lv_tor_id <ls_av_item>-platenumber INTO lv_resource_tp_id.
          APPEND lv_count          TO ct_resource_tp_line_cnt.
          APPEND lv_resource_tp_id TO ct_resource_tp_id.
          ADD 1 TO lv_count.
        ENDIF.

*       Vehicle ID
        IF <ls_av_item>-res_id IS NOT INITIAL.
          CLEAR lv_resource_tp_id.
          CONCATENATE lv_tor_id <ls_av_item>-res_id INTO lv_resource_tp_id.
          APPEND lv_count          TO ct_resource_tp_line_cnt.
          APPEND lv_resource_tp_id TO ct_resource_tp_id.
          ADD 1 TO lv_count.
        ENDIF.

*       Notes container ID,Mobile ID
        IF lr_text->* IS NOT INITIAL AND lr_text_content->* IS NOT INITIAL.
          LOOP AT lr_text->* ASSIGNING FIELD-SYMBOL(<ls_text>).
            CLEAR lv_resource_tp_id.
            READ TABLE lr_text_content->* WITH KEY parent_key
              COMPONENTS parent_key = <ls_text>-key ASSIGNING FIELD-SYMBOL(<ls_text_content>).
            IF sy-subrc = 0.
              IF <ls_text>-text_type = cs_text_type-cont AND <ls_text_content>-text IS NOT INITIAL.
                CONCATENATE lv_tor_id <ls_text_content>-text INTO lv_resource_tp_id.
                APPEND lv_count          TO ct_resource_tp_line_cnt.
                APPEND lv_resource_tp_id TO ct_resource_tp_id.
                ADD 1 TO lv_count.
              ELSEIF <ls_text>-text_type = cs_text_type-mobl AND <ls_text_content>-text IS NOT INITIAL.
                CONCATENATE lv_tor_id <ls_text_content>-text INTO lv_resource_tp_id.
                APPEND lv_count          TO ct_resource_tp_line_cnt.
                APPEND lv_resource_tp_id TO ct_resource_tp_id.
                ADD 1 TO lv_count.
              ENDIF.
            ENDIF.
          ENDLOOP.
        ENDIF.

      WHEN /scmtms/if_tor_const=>sc_tor_category-booking. "Freight booking
        ASSIGN <lt_item>[ item_cat       = /scmtms/if_tor_const=>sc_tor_item_category-booking
                          parent_node_id = <ls_root>-node_id ] TO FIELD-SYMBOL(<ls_booking_item>).
        IF sy-subrc <> 0.
          MESSAGE e010(zgtt_sts) INTO lv_dummy.
          zcl_gtt_sts_tools=>throw_exception( ).
        ENDIF.

*       Vessel ID
        IF <ls_booking_item>-vessel_id IS NOT INITIAL.
          CLEAR lv_resource_tp_id.
          CONCATENATE lv_tor_id <ls_booking_item>-vessel_id INTO lv_resource_tp_id.
          APPEND lv_count          TO ct_resource_tp_line_cnt.
          APPEND lv_resource_tp_id TO ct_resource_tp_id.
          ADD 1 TO lv_count.
        ENDIF.

*       Notes container ID
        IF lr_text->* IS NOT INITIAL AND lr_text_content->* IS NOT INITIAL.
          LOOP AT lr_text->* ASSIGNING <ls_text>.
            CLEAR lv_resource_tp_id.
            READ TABLE lr_text_content->* WITH KEY parent_key
              COMPONENTS parent_key = <ls_text>-key ASSIGNING <ls_text_content>.
            IF sy-subrc = 0.
              IF <ls_text>-text_type = cs_text_type-cont AND <ls_text_content>-text IS NOT INITIAL.
                CONCATENATE lv_tor_id <ls_text_content>-text INTO lv_resource_tp_id.
                APPEND lv_count          TO ct_resource_tp_line_cnt.
                APPEND lv_resource_tp_id TO ct_resource_tp_id.
                ADD 1 TO lv_count.
              ENDIF.
            ENDIF.
          ENDLOOP.
        ENDIF.

      WHEN /scmtms/if_tor_const=>sc_tor_category-freight_unit OR
           /scmtms/if_tor_const=>sc_tor_category-transp_unit.

      WHEN OTHERS.

    ENDCASE.

  ENDMETHOD.


  METHOD get_container_id.

    DATA:
      ls_container TYPE ts_container,
      lt_tmp_cont  TYPE TABLE OF /scmtms/package_id.

    CLEAR:et_container.

    get_data_from_text_collection(
      EXPORTING
        iv_old_data     = iv_old_data
        ir_data         = ir_data
      IMPORTING
        er_text         = DATA(lr_text)
        er_text_content = DATA(lr_text_content) ).

    IF lr_text->* IS NOT INITIAL AND lr_text_content->* IS NOT INITIAL.
      LOOP AT lr_text->* ASSIGNING FIELD-SYMBOL(<ls_text>).
        READ TABLE lr_text_content->* WITH KEY parent_key
          COMPONENTS parent_key = <ls_text>-key ASSIGNING FIELD-SYMBOL(<ls_text_content>).
        IF sy-subrc = 0.
          IF <ls_text>-text_type = cs_text_type-cont AND <ls_text_content>-text IS NOT INITIAL.
            CLEAR lt_tmp_cont.
            SPLIT <ls_text_content>-text AT zif_gtt_sts_constants=>cs_separator-semicolon INTO TABLE lt_tmp_cont.
            DELETE lt_tmp_cont WHERE table_line IS INITIAL.
            LOOP AT lt_tmp_cont INTO DATA(ls_tmp_cont).
              ls_container-object_value = ls_tmp_cont.
              ls_container-object_id = cs_track_id-container_id.
              APPEND ls_container TO et_container.
              CLEAR ls_tmp_cont.
            ENDLOOP.
          ENDIF.
        ENDIF.
      ENDLOOP.
    ENDIF.

  ENDMETHOD.


  METHOD get_stop_info.

    FIELD-SYMBOLS <ls_tor_root> TYPE /scmtms/s_em_bo_tor_root.

    DATA:
      lv_stop_num  TYPE char4,
      ls_stop_info TYPE ts_stop_info,
      lv_seq_num   TYPE i,
      lv_length    TYPE i,
      lt_stop      TYPE /scmtms/t_em_bo_tor_stop.

    CLEAR:ct_stop_info.

    ASSIGN ir_data->* TO <ls_tor_root>.
    IF sy-subrc <> 0.
      MESSAGE e010(zgtt_sts) INTO DATA(lv_dummy) ##needed.
      zcl_gtt_sts_tools=>throw_exception( ).
    ENDIF.

    DATA(lv_tor_id) = <ls_tor_root>-tor_id.
    SHIFT lv_tor_id LEFT DELETING LEADING '0'.

    /scmtms/cl_tor_helper_stop=>get_stop_sequence(
      EXPORTING
        it_root_key     = VALUE #( ( key = <ls_tor_root>-node_id ) )
        iv_before_image = SWITCH #( iv_old_data WHEN abap_true THEN abap_true ELSE abap_false )
      IMPORTING
        et_stop_seq_d   = DATA(lt_stop_seq) ).

    ASSIGN lt_stop_seq[ root_key = <ls_tor_root>-node_id ] TO FIELD-SYMBOL(<ls_stop_seq>) ##WARN_OK.
    IF sy-subrc = 0.
      MOVE-CORRESPONDING <ls_stop_seq>-stop_seq TO lt_stop.
      LOOP AT lt_stop ASSIGNING FIELD-SYMBOL(<ls_stop>).
        <ls_stop>-parent_node_id = <ls_tor_root>-node_id.
        ASSIGN <ls_stop_seq>-stop_map[ tabix = <ls_stop>-seq_num ]-stop_key TO FIELD-SYMBOL(<lv_stop_key>).
        CHECK sy-subrc = 0.
        <ls_stop>-node_id = <lv_stop_key>.
      ENDLOOP.
    ENDIF.

    zcl_gtt_sts_tools=>get_stop_points(
      EXPORTING
        iv_root_id     = lv_tor_id
        it_stop        = lt_stop
      IMPORTING
        et_stop_points = DATA(lt_stop_points) ).

    LOOP AT lt_stop USING KEY parent_seqnum ASSIGNING <ls_stop>.
      IF lv_seq_num IS INITIAL.
        READ TABLE lt_stop_points INTO DATA(ls_stop_points)
          WITH KEY  seq_num   = <ls_stop>-seq_num
                    log_locid = <ls_stop>-log_locid.
        IF sy-subrc = 0.
          DATA(lv_first_stop) = ls_stop_points-stop_id.
        ENDIF.
      ENDIF.
      lv_seq_num = <ls_stop>-seq_num.
    ENDLOOP.

    IF lv_seq_num IS NOT INITIAL.
      DATA(lv_last_stop) = lt_stop_points[ seq_num = lv_seq_num ]-stop_id.
    ENDIF.

    lv_length = strlen( lv_first_stop ) - 4.
    lv_stop_num = lv_first_stop+lv_length(4).
    ls_stop_info-tor_id = lv_tor_id.
    ls_stop_info-stop_num = lv_stop_num.
    APPEND ls_stop_info TO ct_stop_info.

    lv_length = strlen( lv_last_stop ) - 4.
    lv_stop_num = lv_last_stop+lv_length(4).
    ls_stop_info-tor_id = lv_tor_id.
    ls_stop_info-stop_num = lv_stop_num.
    APPEND ls_stop_info TO ct_stop_info.

  ENDMETHOD.
ENDCLASS.
