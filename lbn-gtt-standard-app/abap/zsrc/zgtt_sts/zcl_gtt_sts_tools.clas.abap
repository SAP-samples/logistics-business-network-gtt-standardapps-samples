class ZCL_GTT_STS_TOOLS definition
  public
  create public .

public section.

  types:
    tt_conf TYPE TABLE OF zgtt_track_conf .
  types:
    tt_container TYPE TABLE OF /scmtms/package_id .
  types TS_CONTAINER type /SCMTMS/PACKAGE_ID .
  types:
    BEGIN OF ts_capa_stop,
        line_no    TYPE i,
        tor_id     TYPE /scmtms/tor_id,
        first_stop TYPE /saptrx/loc_id_2,
        last_stop  TYPE /saptrx/loc_id_2,
      END OF ts_capa_stop .
  types:
    tt_capa_stop TYPE TABLE OF ts_capa_stop .
  types:
    tt_req_stop TYPE TABLE OF ts_capa_stop .
  types:
    BEGIN OF ts_txc_key_mapping,
        root_key TYPE /bobf/obm_node_key,
        text_key TYPE /bobf/obm_node_key,
        text_asc TYPE /bobf/obm_assoc_key,
        cont_key TYPE /bobf/obm_node_key,
        cont_asc TYPE /bobf/obm_assoc_key,
      END OF ts_txc_key_mapping .
  types:
    BEGIN OF ts_req2capa_info,
        req_no              TYPE /scmtms/tor_id,
        req_key             TYPE /bobf/conf_key,
        req_stop_key        TYPE /bobf/conf_key,
        req_assgn_stop_key  TYPE /bobf/conf_key,
        req_log_locid       TYPE /scmtms/location_id,
        cap_no              TYPE /scmtms/tor_id,
        cap_key             TYPE /bobf/conf_key,
        cap_stop_key        TYPE /bobf/conf_key,
        cap_plan_trans_time TYPE /scmtms/stop_plan_date,
        cap_seq             TYPE numc04,
        cap_trmodcat        TYPE /scmtms/trmodcat,
        cap_shipping_type   type /scmtms/shipping_type,
      END OF ts_req2capa_info .
  types:
    BEGIN OF ts_cap_stop_seq,
        cap_no       TYPE /scmtms/tor_id,
        cap_key      TYPE /bobf/conf_key,
        cap_stop_key TYPE /bobf/conf_key,
        seq          TYPE numc04,
      END OF ts_cap_stop_seq .
  types:
    BEGIN OF ts_capa_list,
        cap_no     TYPE /scmtms/tor_id,
        first_stop TYPE char50,
        last_stop  TYPE char50,
      END OF ts_capa_list .
  types:
    tt_req2capa_info TYPE TABLE OF ts_req2capa_info .
  types:
    tt_cap_stop_seq  TYPE TABLE OF ts_cap_stop_seq .
  types:
    tt_capa_list TYPE TABLE OF ts_capa_list .
  types:
    BEGIN OF ts_split_result,
      key type char60,
      val type string,
    END OF ts_split_result .
  types:
    tt_split_result type TABLE of ts_split_result .

  constants:
    BEGIN OF cs_condition,
        true  TYPE sy-binpt VALUE 'T',
        false TYPE sy-binpt VALUE 'F',
      END OF cs_condition .

  class-methods ARE_STRUCTURES_DIFFERENT
    importing
      !IR_DATA1 type ref to DATA
      !IR_DATA2 type ref to DATA
    returning
      value(RV_RESULT) type SY-BINPT
    raising
      CX_UDM_MESSAGE .
  class-methods GET_POSTAL_ADDRESS
    importing
      !IV_NODE_ID type /SCMTMS/BO_NODE_ID
    exporting
      !ET_POSTAL_ADDRESS type /BOFU/T_ADDR_POSTAL_ADDRESSK
    raising
      CX_UDM_MESSAGE .
  class-methods CONVERT_UTC_TIMESTAMP
    importing
      !IV_TIMEZONE type TTZZ-TZONE
    changing
      !CV_TIMESTAMP type /SCMTMS/TIMESTAMP
    raising
      CX_UDM_MESSAGE .
  class-methods GET_FIELD_OF_STRUCTURE
    importing
      !IR_STRUCT_DATA type ref to DATA
      !IV_FIELD_NAME type CLIKE
    returning
      value(RV_VALUE) type CHAR50
    raising
      CX_UDM_MESSAGE .
  class-methods GET_ERRORS_LOG
    importing
      !IO_UMD_MESSAGE type ref to CX_UDM_MESSAGE
      !IV_APPSYS type C
    exporting
      !ES_BAPIRET type BAPIRET2 .
  class-methods GET_LOCAL_TIMESTAMP
    importing
      !IV_DATE type ANY default SY-DATUM
      !IV_TIME type ANY default SY-UZEIT
    returning
      value(RV_TIMESTAMP) type /SAPTRX/EVENT_EXP_DATETIME .
  class-methods GET_PRETTY_VALUE
    importing
      !IV_VALUE type ANY
    returning
      value(RV_PRETTY) type /SAPTRX/PARAMVAL200 .
  class-methods GET_SYSTEM_TIME_ZONE
    returning
      value(RV_TZONE) type TIMEZONE
    raising
      CX_UDM_MESSAGE .
  class-methods GET_SYSTEM_DATE_TIME
    returning
      value(RV_DATETIME) type STRING
    raising
      CX_UDM_MESSAGE .
  class-methods IS_NUMBER
    importing
      !IV_VALUE type ANY
    returning
      value(RV_RESULT) type ABAP_BOOL .
  class-methods IS_TABLE
    importing
      !IV_VALUE type ANY
    returning
      value(RV_RESULT) type ABAP_BOOL .
  class-methods THROW_EXCEPTION
    importing
      !IV_TEXTID type SOTR_CONC default ''
    raising
      CX_UDM_MESSAGE .
  class-methods GET_STOP_POINTS
    importing
      !IV_ROOT_ID type /SCMTMS/TOR_ID
      !IT_STOP type /SCMTMS/T_EM_BO_TOR_STOP
    exporting
      !ET_STOP_POINTS type ZIF_GTT_STS_EF_TYPES=>TT_STOP_POINTS .
  class-methods IS_ODD
    importing
      !IV_VALUE type N
    returning
      value(RV_IS_ODD) type ABAP_BOOL .
  class-methods GET_CAPA_MATCH_KEY
    importing
      !IV_ASSGN_STOP_KEY type /SCMTMS/TOR_STOP_KEY
      !IT_CAPA_STOP type /SCMTMS/T_EM_BO_TOR_STOP
      !IT_CAPA_ROOT type /SCMTMS/T_EM_BO_TOR_ROOT
      !IV_BEFORE_IMAGE type ABAP_BOOL optional
    returning
      value(RV_CAPA_MATCHKEY) type /SAPTRX/LOC_ID_2 .
  class-methods CHECK_IS_FO_DELETED
    importing
      !IS_ROOT_NEW type /SCMTMS/S_EM_BO_TOR_ROOT
      !IS_ROOT_OLD type /SCMTMS/S_EM_BO_TOR_ROOT
    returning
      value(RV_RESULT) type ZIF_GTT_STS_EF_TYPES=>TV_CONDITION
    raising
      CX_UDM_MESSAGE .
  class-methods GET_FO_TRACKED_ITEM_OBJ
    importing
      !IS_APP_OBJECT type TRXAS_APPOBJ_CTAB_WA
      !IS_ROOT type /SCMTMS/S_EM_BO_TOR_ROOT
      !IT_ITEM type /SCMTMS/T_EM_BO_TOR_ITEM
      !IV_APPSYS type /SAPTRX/APPLSYSTEM
      !IV_OLD_DATA type ABAP_BOOL default ABAP_FALSE
    changing
      !CT_TRACK_ID_DATA type ZIF_GTT_STS_EF_TYPES=>TT_ENH_TRACK_ID_DATA
    raising
      CX_UDM_MESSAGE .
  class-methods GET_TRACK_OBJ_CHANGES
    importing
      !IS_APP_OBJECT type TRXAS_APPOBJ_CTAB_WA
      !IV_APPSYS type /SAPTRX/APPLSYSTEM
      !IT_TRACK_ID_DATA_NEW type ZIF_GTT_STS_EF_TYPES=>TT_ENH_TRACK_ID_DATA
      !IT_TRACK_ID_DATA_OLD type ZIF_GTT_STS_EF_TYPES=>TT_ENH_TRACK_ID_DATA
    changing
      !CT_TRACK_ID_DATA type ZIF_GTT_STS_EF_TYPES=>TT_TRACK_ID_DATA
    raising
      CX_UDM_MESSAGE .
  class-methods GET_TRMODCOD
    importing
      !IV_TRMODCOD type /SCMTMS/TRMODCODE
    returning
      value(RV_TRMODCOD) type /SCMTMS/TRMODCODE .
  class-methods GET_LOCATION_TYPE
    importing
      !IV_LOCNO type /SAPAPO/LOCNO
    returning
      value(RV_LOCTYPE) type /SAPTRX/LOC_ID_TYPE .
  class-methods GET_TRACK_CONF
    exporting
      !ET_CONF type TT_CONF .
  class-methods GET_CONTAINER_MOBILE_ID
    importing
      !IR_ROOT type DATA
      !IV_OLD_DATA type ABAP_BOOL default ABAP_FALSE
    changing
      !ET_CONTAINER type TT_CONTAINER optional
      !ET_MOBILE type TT_CONTAINER optional
    raising
      CX_UDM_MESSAGE .
  class-methods GET_DATA_FROM_TEXT_COLLECTION
    importing
      !IR_ROOT type DATA
      !IV_OLD_DATA type ABAP_BOOL default ABAP_FALSE
    exporting
      !ER_TEXT type ref to /BOBF/T_TXC_TXT_K
      !ER_TEXT_CONTENT type ref to /BOBF/T_TXC_CON_K
    raising
      CX_UDM_MESSAGE .
  class-methods GET_PLATE_TRUCK_NUMBER
    importing
      !IR_ROOT type ref to DATA
      !IV_OLD_DATA type ABAP_BOOL default ABAP_FALSE
    exporting
      !EV_PLATENUMBER type /SCMTMS/RESPLATENR
      !EV_TRUCK_ID type /SCMTMS/RES_NAME
    raising
      CX_UDM_MESSAGE .
  class-methods GET_PACKAGE_ID
    importing
      !IR_ROOT type ref to DATA
      !IV_OLD_DATA type ABAP_BOOL default ABAP_FALSE
    exporting
      !ET_PACKAGE_ID type TT_CONTAINER
      !ET_PACKAGE_ID_EXT type TT_CONTAINER
    raising
      CX_UDM_MESSAGE .
  class-methods GET_CAPA_STOP_INFO
    importing
      !IR_ROOT type ref to DATA
      !IV_OLD_DATA type ABAP_BOOL default ABAP_FALSE
    exporting
      !ET_CAPA_STOP type TT_CAPA_STOP
    raising
      CX_UDM_MESSAGE .
  class-methods GET_REQ_STOP_INFO
    importing
      !IR_ROOT type ref to DATA
      !IV_OLD_DATA type ABAP_BOOL default ABAP_FALSE
    exporting
      !ET_REQ_STOP type TT_REQ_STOP
    raising
      CX_UDM_MESSAGE .
  class-methods GET_TRACK_OBJ_CHANGES_V2
    importing
      !IS_APP_OBJECT type TRXAS_APPOBJ_CTAB_WA
      !IV_APPSYS type /SAPTRX/APPLSYSTEM
      !IT_TRACK_ID_DATA_NEW type ZIF_GTT_STS_EF_TYPES=>TT_ENH_TRACK_ID_DATA
      !IT_TRACK_ID_DATA_OLD type ZIF_GTT_STS_EF_TYPES=>TT_ENH_TRACK_ID_DATA
    changing
      !CT_TRACK_ID_DATA type ZIF_GTT_STS_EF_TYPES=>TT_TRACK_ID_DATA
    raising
      CX_UDM_MESSAGE .
  class-methods GET_CAPA_INFO
    importing
      !IR_ROOT type ref to DATA
      !IV_OLD_DATA type ABAP_BOOL default ABAP_FALSE
    exporting
      !ET_CAPA type /SCMTMS/T_EM_BO_TOR_ROOT
    raising
      CX_UDM_MESSAGE .
  class-methods GET_REQ_INFO
    importing
      !IR_ROOT type ref to DATA
      !IV_OLD_DATA type ABAP_BOOL
    exporting
      !ET_REQ_TOR type /SCMTMS/T_EM_BO_TOR_ROOT
    raising
      CX_UDM_MESSAGE .
  class-methods GET_TXC_KEY_MAPPING
    importing
      !IV_BO_KEY type /BOBF/OBM_BO_KEY
      !IV_NODE type /BOBF/OBM_NODE_KEY
    exporting
      !ES_TXC_KEY_MAPPING type TS_TXC_KEY_MAPPING .
  class-methods GET_PACKAGE_ID_V2
    importing
      !IR_ROOT type ref to DATA
      !IV_OLD_DATA type ABAP_BOOL default ABAP_FALSE
    exporting
      !ET_PACKAGE_ID type TT_CONTAINER
      !ET_PACKAGE_ID_EXT type TT_CONTAINER
    raising
      CX_UDM_MESSAGE .
  class-methods GET_CONTAINER_NUM_ON_CU
    importing
      !IR_ROOT type ref to DATA
      !IV_OLD_DATA type ABAP_BOOL default ABAP_FALSE
    exporting
      !ET_CONTAINER type TT_CONTAINER
    raising
      CX_UDM_MESSAGE .
  class-methods GET_REQCAPA_INFO_MUL
    importing
      !IR_ROOT type ref to DATA optional
      !IT_ROOT_KEY type /BOBF/T_FRW_KEY optional
      !IV_OLD_DATA type ABAP_BOOL default ABAP_FALSE
    exporting
      !ET_REQ2CAPA_INFO type TT_REQ2CAPA_INFO
      !ET_CAPA_LIST type TT_CAPA_LIST
      !ET_CAPA_DETAIL type /SCMTMS/T_EM_BO_TOR_ROOT
      !ET_CAPA_STOP_SEQ type /SCMTMS/T_EM_BO_TOR_STOP
    raising
      CX_UDM_MESSAGE .
  class-methods GET_CAPA_INFO_MUL
    importing
      !IR_ROOT type ref to DATA optional
      !IT_ROOT_KEY type /BOBF/T_FRW_KEY optional
      !IV_OLD_DATA type ABAP_BOOL default ABAP_FALSE
    exporting
      !ET_CAPA type /SCMTMS/T_EM_BO_TOR_ROOT
      !ET_CAPA_STOP type /SCMTMS/T_EM_BO_TOR_STOP
    raising
      CX_UDM_MESSAGE .
  class-methods GET_REQ_INFO_MUL
    importing
      !IR_ROOT type ref to DATA optional
      !IT_ROOT_KEY type /BOBF/T_FRW_KEY optional
      !IV_OLD_DATA type ABAP_BOOL default ABAP_FALSE
    exporting
      !ET_REQ type /SCMTMS/T_EM_BO_TOR_ROOT
      !ET_REQ_STOP type /SCMTMS/T_EM_BO_TOR_STOP
    raising
      CX_UDM_MESSAGE .
  class-methods GET_CAPA2REQ_LINK_MUL
    importing
      !IT_ROOT_KEY type /BOBF/T_FRW_KEY
    exporting
      !ET_KEY_LINK type /BOBF/T_FRW_KEY_LINK .
  class-methods GET_SCAC_CODE
    importing
      !IV_PARTNER type BU_PARTNER
    returning
      value(RV_NUM) type /SAPTRX/PARAMVAL200 .
  class-methods GET_GTT_RELEV_FLAG_BY_AOT_TYPE
    importing
      !IV_TRK_OBJ_TYPE type /SAPTRX/TRK_OBJ_TYPE default 'TMS_TOR'
      !IV_AOTYPE type /SAPTRX/AOTYPE
    returning
      value(RV_TORELEVANT) type /SAPTRX/TRKRELINDICATOR .
  class-methods CONVERT_CARRIER_NOTE_TO_TABLE
    importing
      !IV_TEXT type STRING
    exporting
      !ET_SPLIT_RESULT type TT_SPLIT_RESULT .
  class-methods CHECK_LTL_SHIPMENT
    importing
      !IR_ROOT type ref to DATA
    exporting
      !EV_LTL_FLAG type FLAG
    raising
      CX_UDM_MESSAGE .
  class-methods MAP_EP_EVNT_CODE_TO_EVENT_CODE
    importing
      !IV_EP_EVENT_CODE type /SCMTMS/TOR_EVENT
    returning
      value(EV_LEGACY_EVENT_CODE) type /SCMTMS/TOR_EVENT .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_GTT_STS_TOOLS IMPLEMENTATION.


  METHOD are_structures_different.

    DATA: lt_fields TYPE cl_abap_structdescr=>component_table,
          lv_dummy  TYPE char100 ##needed.

    FIELD-SYMBOLS: <ls_data1>  TYPE any,
                   <ls_data2>  TYPE any,
                   <lv_value1> TYPE any,
                   <lv_value2> TYPE any.

    ASSIGN ir_data1->* TO <ls_data1>.
    ASSIGN ir_data2->* TO <ls_data2>.

    IF <ls_data1> IS ASSIGNED AND <ls_data2> IS ASSIGNED.
      lt_fields = CAST cl_abap_structdescr(
                    cl_abap_typedescr=>describe_by_data(
                      p_data = <ls_data1> )
                  )->get_components( ).

      rv_result = cs_condition-false.

      LOOP AT lt_fields ASSIGNING FIELD-SYMBOL(<ls_fields>).
        ASSIGN COMPONENT <ls_fields>-name OF STRUCTURE <ls_data1> TO <lv_value1>.
        ASSIGN COMPONENT <ls_fields>-name OF STRUCTURE <ls_data2> TO <lv_value2>.

        IF <lv_value1> IS ASSIGNED AND
           <lv_value2> IS ASSIGNED.
          IF <lv_value1> <> <lv_value2>.
            rv_result   = cs_condition-true.
            EXIT.
          ENDIF.
        ELSE.
          MESSAGE e001(zgtt_sts) WITH <ls_fields>-name INTO lv_dummy.
          zcl_gtt_sts_tools=>throw_exception( ).
        ENDIF.
      ENDLOOP.
    ELSE.
      MESSAGE e002(zgtt_sts) INTO lv_dummy.
      zcl_gtt_sts_tools=>throw_exception( ).
    ENDIF.

  ENDMETHOD.


  METHOD check_is_fo_deleted.

    rv_result = zif_gtt_sts_ef_constants=>cs_condition-false.

    DATA(lv_carrier_removed) = xsdbool(
            is_root_old-tsp IS INITIAL AND is_root_new-tsp IS NOT INITIAL ).

    DATA(lv_execution_status_changed) = xsdbool(
      ( is_root_new-execution = /scmtms/if_tor_status_c=>sc_root-execution-v_not_relevant         OR
        is_root_new-execution = /scmtms/if_tor_status_c=>sc_root-execution-v_not_started          OR
        is_root_new-execution = /scmtms/if_tor_status_c=>sc_root-execution-v_cancelled            OR
        is_root_new-execution = /scmtms/if_tor_status_c=>sc_root-execution-v_not_ready_for_execution ) AND
      ( is_root_old-execution = /scmtms/if_tor_status_c=>sc_root-execution-v_in_execution        OR
        is_root_old-execution = /scmtms/if_tor_status_c=>sc_root-execution-v_executed            OR
        is_root_old-execution = /scmtms/if_tor_status_c=>sc_root-execution-v_interrupted         OR
        is_root_old-execution = /scmtms/if_tor_status_c=>sc_root-execution-v_ready_for_execution OR
        is_root_old-execution = /scmtms/if_tor_status_c=>sc_root-execution-v_loading_in_process  OR
        is_root_old-execution = /scmtms/if_tor_status_c=>sc_root-execution-v_capa_plan_finished  ) ).

    DATA(lv_lifecycle_status_changed) = xsdbool(
      ( is_root_new-lifecycle <> /scmtms/if_tor_status_c=>sc_root-lifecycle-v_in_process AND
        is_root_new-lifecycle <> /scmtms/if_tor_status_c=>sc_root-lifecycle-v_completed ) AND
      ( is_root_old-lifecycle = /scmtms/if_tor_status_c=>sc_root-lifecycle-v_in_process OR
        is_root_old-lifecycle = /scmtms/if_tor_status_c=>sc_root-lifecycle-v_completed ) ).

    IF lv_carrier_removed = abap_true OR lv_execution_status_changed = abap_true OR
       lv_lifecycle_status_changed = abap_true .
      rv_result = zif_gtt_sts_ef_constants=>cs_condition-true.
    ENDIF.

  ENDMETHOD.


  METHOD convert_utc_timestamp.

    DATA:
      lv_timestamp TYPE timestamp,
      lv_date      TYPE d,
      lv_time      TYPE t,
      lv_tz_utc    TYPE ttzz-tzone VALUE 'UTC',
      lv_dst       TYPE c LENGTH 1.

    lv_timestamp = cv_timestamp.
    CONVERT TIME STAMP lv_timestamp TIME ZONE iv_timezone
            INTO DATE lv_date TIME lv_time DAYLIGHT SAVING TIME lv_dst.

    CONVERT DATE lv_date TIME lv_time DAYLIGHT SAVING TIME lv_dst
            INTO TIME STAMP lv_timestamp TIME ZONE lv_tz_utc.
    cv_timestamp = lv_timestamp.

  ENDMETHOD.


  METHOD get_capa2req_link_mul.

    DATA:
      lo_srvmgr_tor   TYPE REF TO /bobf/if_tra_service_manager,
      lt_root_key_tmp TYPE /bobf/t_frw_key,
      lt_req_key      TYPE /bobf/t_frw_key,
      lt_req_tmp      TYPE /scmtms/t_tor_root_k,
      lt_req          TYPE /scmtms/t_tor_root_k,
      lt_link_tmp     TYPE /bobf/t_frw_key_link.

    CLEAR:
      et_key_link.

    lo_srvmgr_tor = /bobf/cl_tra_serv_mgr_factory=>get_service_manager( iv_bo_key = /scmtms/if_tor_c=>sc_bo_key ).
    lt_root_key_tmp = it_root_key.

*   Find Capacity and requirement document links
    DO 10 TIMES.

      CLEAR:
        lt_req_tmp,
        lt_req_key,
        lt_link_tmp.

*     Get requirement information
      lo_srvmgr_tor->retrieve_by_association(
        EXPORTING
          iv_node_key    = /scmtms/if_tor_c=>sc_node-root
          it_key         = lt_root_key_tmp
          iv_association = /scmtms/if_tor_c=>sc_association-root-req_tor
          iv_fill_data   = abap_true
        IMPORTING
          et_data        = lt_req_tmp
          et_target_key  = lt_req_key
          et_key_link    = lt_link_tmp ).

      CLEAR lt_root_key_tmp.
      lt_root_key_tmp = CORRESPONDING #( lt_req_key ).

*     Check the document is FU or not
      READ TABLE lt_req_tmp TRANSPORTING NO FIELDS
        WITH TABLE KEY tor_cat COMPONENTS tor_cat = /scmtms/if_tor_const=>sc_tor_category-freight_unit.
      IF sy-subrc <> 0.
        CONTINUE.
      ENDIF.

      APPEND LINES OF lt_link_tmp TO et_key_link.
      EXIT."Exit the loop
    ENDDO.

  ENDMETHOD.


  METHOD get_capa_info.

    FIELD-SYMBOLS:
      <ls_root>          TYPE /scmtms/s_em_bo_tor_root.
    DATA:
      lt_capa TYPE /scmtms/t_tor_root_k.

    CLEAR et_capa.

    ASSIGN ir_root->* TO <ls_root>.
    IF sy-subrc <> 0.
      MESSAGE e010(zgtt_sts) INTO DATA(lv_dummy) ##needed.
      zcl_gtt_sts_tools=>throw_exception( ).
    ENDIF.

    DATA(lr_srvmgr_tor) = /bobf/cl_tra_serv_mgr_factory=>get_service_manager(
      iv_bo_key = /scmtms/if_tor_c=>sc_bo_key ).

    lr_srvmgr_tor->retrieve_by_association(
      EXPORTING
        iv_node_key     = /scmtms/if_tor_c=>sc_node-root
        it_key          = VALUE #( ( key = <ls_root>-node_id ) )
        iv_association  = /scmtms/if_tor_c=>sc_association-root-capa_tor
        iv_fill_data    = abap_true
        iv_before_image = iv_old_data
      IMPORTING
        et_data         = lt_capa ).

    et_capa = CORRESPONDING #( lt_capa MAPPING node_id = key tor_root_node = root_key ).

  ENDMETHOD.


  METHOD get_capa_info_mul.

    FIELD-SYMBOLS:
      <ls_root>  TYPE /scmtms/s_em_bo_tor_root.

    DATA:
      lo_srvmgr_tor    TYPE REF TO /bobf/if_tra_service_manager,
      lt_root_key      TYPE /bobf/t_frw_key,
      lt_root_key_tmp  TYPE /bobf/t_frw_key,
      lt_capa_key      TYPE /bobf/t_frw_key,
      lt_capa_tmp      TYPE /scmtms/t_tor_root_k,
      lt_capa_stop_tmp TYPE /scmtms/t_tor_stop_k,
      lt_capa          TYPE /scmtms/t_tor_root_k,
      lt_capa_stop     TYPE /scmtms/t_tor_stop_k.

    CLEAR:
      et_capa,
      et_capa_stop.

    IF it_root_key IS NOT INITIAL.
      lt_root_key = it_root_key.
    ELSE.
      ASSIGN ir_root->* TO <ls_root>.
      IF sy-subrc <> 0.
        MESSAGE e010(zgtt_sts) INTO DATA(lv_dummy) ##needed.
        zcl_gtt_sts_tools=>throw_exception( ).
      ENDIF.
      lt_root_key = VALUE #( ( key = <ls_root>-node_id ) ).
    ENDIF.

    lo_srvmgr_tor = /bobf/cl_tra_serv_mgr_factory=>get_service_manager( iv_bo_key = /scmtms/if_tor_c=>sc_bo_key ).
    lt_root_key_tmp = lt_root_key.

*   Find capacity document
    DO 10 TIMES.

      CLEAR:
        lt_capa_tmp,
        lt_capa_stop_tmp,
        lt_capa_key.

*     Get Capacity information
      lo_srvmgr_tor->retrieve_by_association(
        EXPORTING
          iv_node_key     = /scmtms/if_tor_c=>sc_node-root
          it_key          = lt_root_key_tmp
          iv_association  = /scmtms/if_tor_c=>sc_association-root-capa_tor
          iv_fill_data    = abap_true
          iv_before_image = iv_old_data
        IMPORTING
          et_data         = lt_capa_tmp
          et_target_key   = lt_capa_key ).

      CLEAR lt_root_key_tmp.
      lt_root_key_tmp = CORRESPONDING #( lt_capa_key ).

*     Check the document is FO or not
      READ TABLE lt_capa_tmp TRANSPORTING NO FIELDS
        WITH TABLE KEY tor_cat COMPONENTS tor_cat = /scmtms/if_tor_const=>sc_tor_category-active.
      IF sy-subrc <> 0.
        READ TABLE lt_capa_tmp TRANSPORTING NO FIELDS
          WITH TABLE KEY tor_cat COMPONENTS tor_cat = /scmtms/if_tor_const=>sc_tor_category-booking.
        IF sy-subrc <> 0.
          CONTINUE.
        ENDIF.
      ENDIF.

*     Get Capacity Stop information
      lo_srvmgr_tor->retrieve_by_association(
        EXPORTING
          iv_node_key     = /scmtms/if_tor_c=>sc_node-root
          it_key          = lt_root_key_tmp
          iv_association  = /scmtms/if_tor_c=>sc_association-root-stop
          iv_fill_data    = abap_true
          iv_before_image = iv_old_data
        IMPORTING
          et_data         = lt_capa_stop_tmp ).

      APPEND LINES OF lt_capa_tmp TO lt_capa.
      APPEND LINES OF lt_capa_stop_tmp TO lt_capa_stop.
      EXIT."Exit the loop
    ENDDO.

    et_capa      = CORRESPONDING #( lt_capa MAPPING node_id = key tor_root_node = root_key ).
    et_capa_stop = CORRESPONDING #( lt_capa_stop MAPPING node_id = key parent_node_id = parent_key ).

  ENDMETHOD.


  METHOD get_capa_match_key.

    DATA lt_stop TYPE /scmtms/t_em_bo_tor_stop.

    ASSIGN it_capa_stop[ node_id = iv_assgn_stop_key ] TO FIELD-SYMBOL(<ls_capa_stop>).
    IF sy-subrc <> 0.
      RETURN.
    ENDIF.

    ASSIGN it_capa_root[ node_id = <ls_capa_stop>-parent_node_id ]-tor_id TO FIELD-SYMBOL(<lv_tor_id>).
    IF sy-subrc <> 0.
      RETURN.
    ENDIF.

    /scmtms/cl_tor_helper_stop=>get_stop_sequence(
      EXPORTING
        it_root_key     = VALUE #( ( key = <ls_capa_stop>-parent_node_id ) )
        iv_before_image = iv_before_image
      IMPORTING
        et_stop_seq_d   = DATA(lt_stop_seq) ).

    ASSIGN lt_stop_seq[ root_key = <ls_capa_stop>-parent_node_id ] TO FIELD-SYMBOL(<ls_stop_seq>) ##WARN_OK.
    IF sy-subrc <> 0.
      RETURN.
    ENDIF.

    lt_stop = CORRESPONDING /scmtms/t_em_bo_tor_stop( <ls_stop_seq>-stop_seq ).
    ASSIGN <ls_stop_seq>-stop_map[ stop_key = <ls_capa_stop>-node_id ]-tabix TO FIELD-SYMBOL(<lv_seq_num>) ##WARN_OK.
    IF sy-subrc <> 0.
      RETURN.
    ENDIF.

    zcl_gtt_sts_tools=>get_stop_points(
      EXPORTING
        iv_root_id     = <lv_tor_id>
        it_stop        = lt_stop
      IMPORTING
        et_stop_points = DATA(lt_stop_points) ).

    ASSIGN lt_stop_points[ seq_num   = <lv_seq_num>
                           log_locid = <ls_capa_stop>-log_locid ] TO FIELD-SYMBOL(<ls_stop_point>) ##WARN_OK.
    IF sy-subrc = 0.
      rv_capa_matchkey = <ls_stop_point>-stop_id.
      SHIFT rv_capa_matchkey LEFT DELETING LEADING '0'.
    ENDIF.

  ENDMETHOD.


  METHOD get_capa_stop_info.

    FIELD-SYMBOLS:
      <ls_tor_root> TYPE /scmtms/s_em_bo_tor_root.

    DATA:
      lv_seq_num          TYPE i,
      lv_capa_doc_line_no TYPE i,
      lr_srvmgr_tor       TYPE REF TO /bobf/if_tra_service_manager,
      lt_capa             TYPE /scmtms/t_tor_root_k,
      lt_fu_stop          TYPE /scmtms/t_tor_stop_k,
      lt_fo_stop          TYPE /scmtms/t_em_bo_tor_stop,
      ls_capa_stop        TYPE ts_capa_stop,
      lt_root_key         TYPE /bobf/t_frw_key.

    CLEAR et_capa_stop.

    ASSIGN ir_root->* TO <ls_tor_root>.
    IF sy-subrc <> 0.
      MESSAGE e010(zgtt_sts) INTO DATA(lv_dummy) ##needed.
      zcl_gtt_sts_tools=>throw_exception( ).
    ENDIF.

    DATA(lv_before_image) = SWITCH abap_bool( iv_old_data WHEN abap_true THEN abap_true
                                                          ELSE abap_false ).

    lt_root_key = VALUE #( ( key = <ls_tor_root>-node_id ) ).

    lr_srvmgr_tor = /bobf/cl_tra_serv_mgr_factory=>get_service_manager(
      iv_bo_key = /scmtms/if_tor_c=>sc_bo_key ).

    lr_srvmgr_tor->retrieve_by_association(
      EXPORTING
        iv_node_key     = /scmtms/if_tor_c=>sc_node-root
        it_key          = lt_root_key
        iv_association  = /scmtms/if_tor_c=>sc_association-root-stop
        iv_fill_data    = abap_true
        iv_before_image = lv_before_image
      IMPORTING
        et_data         = lt_fu_stop ).

    lr_srvmgr_tor->retrieve_by_association(
      EXPORTING
        iv_node_key     = /scmtms/if_tor_c=>sc_node-root
        it_key          = lt_root_key
        iv_association  = /scmtms/if_tor_c=>sc_association-root-capa_tor
        iv_fill_data    = abap_true
        iv_before_image = lv_before_image
      IMPORTING
        et_data         = lt_capa
        et_key_link     = DATA(lt_req2capa_link) ).

    LOOP AT lt_req2capa_link INTO DATA(ls_req2capa_link).
      READ TABLE lt_capa INTO DATA(ls_capa) WITH KEY key = ls_req2capa_link-target_key.
      CHECK sy-subrc = 0.
      /scmtms/cl_tor_helper_stop=>get_stop_sequence(
        EXPORTING
          it_root_key     = VALUE #( ( key = ls_req2capa_link-target_key ) )
          iv_before_image = lv_before_image
        IMPORTING
          et_stop_seq_d   = DATA(lt_stop_seq) ).

      ASSIGN lt_stop_seq[ root_key = ls_req2capa_link-target_key ] TO FIELD-SYMBOL(<ls_stop_seq>) ##WARN_OK.
      IF sy-subrc = 0.
        MOVE-CORRESPONDING <ls_stop_seq>-stop_seq TO lt_fo_stop.
        LOOP AT lt_fo_stop ASSIGNING FIELD-SYMBOL(<ls_fo_stop>).
          <ls_fo_stop>-parent_node_id = ls_req2capa_link-target_key.
          ASSIGN <ls_stop_seq>-stop_map[ tabix = <ls_fo_stop>-seq_num ]-stop_key TO FIELD-SYMBOL(<lv_stop_key>).
          CHECK sy-subrc = 0.
          <ls_fo_stop>-node_id = <lv_stop_key>.
        ENDLOOP.
      ENDIF.

      zcl_gtt_sts_tools=>get_stop_points(
        EXPORTING
          iv_root_id     = ls_capa-tor_id
          it_stop        = lt_fo_stop
        IMPORTING
          et_stop_points = DATA(lt_stop_points) ).

      LOOP AT lt_fo_stop USING KEY parent_seqnum ASSIGNING <ls_fo_stop>.
        ASSIGN lt_fu_stop[ assgn_stop_key = <ls_fo_stop>-node_id  parent_key = ls_req2capa_link-source_key ] TO FIELD-SYMBOL(<ls_fu_stop>).
        IF sy-subrc = 0.
          IF lv_seq_num IS INITIAL.
            READ TABLE lt_stop_points INTO DATA(ls_stop_points)
              WITH KEY  seq_num   = <ls_fo_stop>-seq_num
                        log_locid = <ls_fo_stop>-log_locid.
            IF sy-subrc = 0.
              DATA(lv_capa_doc_first_stop) = ls_stop_points-stop_id.
            ENDIF.
          ENDIF.
          lv_seq_num = <ls_fo_stop>-seq_num.
        ENDIF.
      ENDLOOP.

      IF lv_seq_num IS NOT INITIAL.
        DATA(lv_capa_doc_last_stop) = lt_stop_points[ seq_num = lv_seq_num ]-stop_id.
      ENDIF.

      lv_capa_doc_line_no = lv_capa_doc_line_no + 1.
      ls_capa_stop-line_no = lv_capa_doc_line_no.
      ls_capa_stop-tor_id = |{ ls_capa-tor_id ALPHA = OUT }|.
      ls_capa_stop-first_stop = |{ lv_capa_doc_first_stop ALPHA = OUT }|.
      ls_capa_stop-last_stop = |{ lv_capa_doc_last_stop ALPHA = OUT }|.
      CONDENSE ls_capa_stop-tor_id NO-GAPS.
      CONDENSE ls_capa_stop-first_stop NO-GAPS.
      CONDENSE ls_capa_stop-last_stop NO-GAPS.
      APPEND ls_capa_stop TO et_capa_stop.

      CLEAR: lv_seq_num, lt_stop_points.
    ENDLOOP.

  ENDMETHOD.


  METHOD get_container_mobile_id.

    DATA:
      ls_container TYPE ts_container,
      ls_mobile    TYPE ts_container,
      lt_container TYPE tt_container,
      lv_container TYPE char1024.

    CLEAR:
      et_container,
      et_mobile.

    get_data_from_text_collection(
      EXPORTING
        iv_old_data     = iv_old_data
        ir_root         = ir_root
      IMPORTING
        er_text         = DATA(lr_text)
        er_text_content = DATA(lr_text_content) ).

    IF lr_text->* IS NOT INITIAL AND lr_text_content->* IS NOT INITIAL.
      LOOP AT lr_text->* ASSIGNING FIELD-SYMBOL(<ls_text>).
        READ TABLE lr_text_content->* WITH KEY parent_key
          COMPONENTS parent_key = <ls_text>-key ASSIGNING FIELD-SYMBOL(<ls_text_content>).
        IF sy-subrc = 0.
          IF <ls_text>-text_type = zif_gtt_sts_constants=>cs_text_type-cont AND <ls_text_content>-text IS NOT INITIAL.
            lv_container = <ls_text_content>-text.
            SPLIT lv_container AT zif_gtt_sts_constants=>cs_separator-semicolon INTO TABLE lt_container.
            APPEND LINES OF lt_container TO et_container.
            CLEAR lt_container.
          ENDIF.
          IF <ls_text>-text_type = zif_gtt_sts_constants=>cs_text_type-mobl AND <ls_text_content>-text IS NOT INITIAL.
            ls_mobile = <ls_text_content>-text.
            APPEND ls_mobile TO et_mobile.
          ENDIF.
        ENDIF.
      ENDLOOP.
    ENDIF.

    DELETE et_container WHERE table_line IS INITIAL.

  ENDMETHOD.


  METHOD get_container_num_on_cu.

    FIELD-SYMBOLS <ls_root> TYPE /scmtms/s_em_bo_tor_root.
    DATA:
      lt_item       TYPE /scmtms/t_tor_item_tr_k.

    CLEAR:
      et_container.

    ASSIGN ir_root->* TO <ls_root>.
    IF sy-subrc <> 0.
      MESSAGE e010(zgtt_sts) INTO DATA(lv_dummy) ##needed.
      zcl_gtt_sts_tools=>throw_exception( ).
    ENDIF.

    DATA(lv_before_image) = SWITCH abap_bool( iv_old_data WHEN abap_true THEN abap_true
                                                          ELSE abap_false ).

    DATA(lr_srvmgr_tor) = /bobf/cl_tra_serv_mgr_factory=>get_service_manager( iv_bo_key = /scmtms/if_tor_c=>sc_bo_key ).

    lr_srvmgr_tor->retrieve_by_association(
      EXPORTING
        it_key          = VALUE #( ( key = <ls_root>-node_id ) )
        iv_node_key     = /scmtms/if_tor_c=>sc_node-root
        iv_association  = /scmtms/if_tor_c=>sc_association-root-item_tr
        iv_before_image = lv_before_image
        iv_fill_data    = abap_true
      IMPORTING
        et_data         = lt_item ).

    LOOP AT lt_item INTO DATA(ls_item)
       WHERE item_cat = /scmtms/if_tor_const=>sc_tor_item_category-tu_resource
         AND platenumber IS NOT INITIAL.
      APPEND ls_item-platenumber TO et_container.
    ENDLOOP.

  ENDMETHOD.


  METHOD get_data_from_text_collection.

    FIELD-SYMBOLS <ls_root> TYPE /scmtms/s_em_bo_tor_root.
    ASSIGN ir_root->* TO <ls_root>.
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


  METHOD get_errors_log.

    es_bapiret-id           = io_umd_message->m_msgid.
    es_bapiret-number       = io_umd_message->m_msgno.
    es_bapiret-type         = io_umd_message->m_msgty.
    es_bapiret-message_v1   = io_umd_message->m_msgv1.
    es_bapiret-message_v2   = io_umd_message->m_msgv2.
    es_bapiret-message_v3   = io_umd_message->m_msgv3.
    es_bapiret-message_v4   = io_umd_message->m_msgv4.
    es_bapiret-system       = iv_appsys.

  ENDMETHOD.


  METHOD get_field_of_structure.

    FIELD-SYMBOLS: <ls_struct> TYPE any,
                   <lv_value>  TYPE any.

    ASSIGN ir_struct_data->* TO <ls_struct>.

    IF <ls_struct> IS ASSIGNED.
      ASSIGN COMPONENT iv_field_name OF STRUCTURE <ls_struct> TO <lv_value>.
      IF <lv_value> IS ASSIGNED.
        rv_value    = <lv_value>.
      ELSE.
        zcl_gtt_sts_tools=>throw_exception( ).
      ENDIF.
    ELSE.
      zcl_gtt_sts_tools=>throw_exception( ).
    ENDIF.

  ENDMETHOD.


  METHOD get_fo_tracked_item_obj.

    CONSTANTS: cs_mtr_truck TYPE string VALUE '31'.

    DATA:
      lv_tmp_restrxcod TYPE /saptrx/trxcod,
      lv_restrxcod     TYPE /saptrx/trxcod.

    lv_restrxcod = zif_gtt_sts_constants=>cs_trxcod-fo_resource.

    LOOP AT it_item ASSIGNING FIELD-SYMBOL(<ls_item>).

      IF <ls_item>-platenumber IS ASSIGNED AND <ls_item>-res_id IS ASSIGNED AND <ls_item>-node_id IS ASSIGNED AND
         <ls_item>-item_cat    IS ASSIGNED AND <ls_item>-item_cat = /scmtms/if_tor_const=>sc_tor_item_category-av_item.

        DATA(lv_tor_id) = |{ is_root-tor_id ALPHA = OUT }|.
        CONDENSE lv_tor_id.
        IF is_root-tor_id IS NOT INITIAL AND <ls_item>-res_id IS NOT INITIAL.
          APPEND VALUE #( key = <ls_item>-node_id
                  appsys      = iv_appsys
                  appobjtype  = is_app_object-appobjtype
                  appobjid    = is_app_object-appobjid
                  trxcod      = lv_restrxcod
                  trxid       = |{ lv_tor_id }{ <ls_item>-res_id }| ) TO ct_track_id_data.
        ENDIF.

        DATA(lv_mtr) = is_root-mtr.
        SELECT SINGLE motscode FROM /sapapo/trtype INTO lv_mtr WHERE ttype = lv_mtr.
        SHIFT lv_mtr LEFT DELETING LEADING '0'.
        IF is_root-tor_id IS NOT INITIAL AND <ls_item>-platenumber IS NOT INITIAL AND lv_mtr = cs_mtr_truck.
          lv_tor_id = |{ is_root-tor_id ALPHA = OUT }|.
          CONDENSE lv_tor_id.
          APPEND VALUE #( key = <ls_item>-node_id
                  appsys      = iv_appsys
                  appobjtype  = is_app_object-appobjtype
                  appobjid    = is_app_object-appobjid
                  trxcod      = lv_restrxcod
                  trxid       = |{ lv_tor_id }{ <ls_item>-platenumber }| ) TO ct_track_id_data.
        ENDIF.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.


  METHOD get_local_timestamp.

    rv_timestamp    = COND #( WHEN iv_date IS NOT INITIAL
                                THEN |0{ iv_date }{ iv_time }| ).

  ENDMETHOD.


  METHOD get_location_type.

    CLEAR:rv_loctype.
    IF iv_locno IS NOT INITIAL.
      rv_loctype = zif_gtt_sts_constants=>cs_location_type-logistic.
    ENDIF.

  ENDMETHOD.


  METHOD get_package_id.
*----------------------------------------------------------------------*
* In this method we provide 3 options to get package id.
* Option 1:
*   Retrive the package id from ITEM_TR-PACKAGE_ID
* Option 2:
*   Retrive the external package id from ITEM_TR-PACKAGE_ID_EXT
*   field PACKAGE_ID_EXT only available on S/4HANA 2020 FPS01 and afterwards
* Option 3:
*   Retrive the external package id from
*     freight unit-Items-notes-Text type = 'EPKG'
* We recommend you to use external package id as the tracked object.
*----------------------------------------------------------------------*

    FIELD-SYMBOLS <ls_root> TYPE /scmtms/s_em_bo_tor_root.
    DATA:
      lt_item           TYPE /scmtms/t_tor_item_tr_k,
      lt_package_id_ext TYPE tt_container.

    CLEAR:
      et_package_id,
      et_package_id_ext.

    ASSIGN ir_root->* TO <ls_root>.
    IF sy-subrc <> 0.
      MESSAGE e010(zgtt_sts) INTO DATA(lv_dummy) ##needed.
      zcl_gtt_sts_tools=>throw_exception( ).
    ENDIF.

    DATA(lv_before_image) = SWITCH abap_bool( iv_old_data WHEN abap_true THEN abap_true
                                                          ELSE abap_false ).

    DATA(lr_srvmgr_tor) = /bobf/cl_tra_serv_mgr_factory=>get_service_manager( iv_bo_key = /scmtms/if_tor_c=>sc_bo_key ).

    lr_srvmgr_tor->retrieve_by_association(
      EXPORTING
        it_key          = VALUE #( ( key = <ls_root>-node_id ) )
        iv_node_key     = /scmtms/if_tor_c=>sc_node-root
        iv_association  = /scmtms/if_tor_c=>sc_association-root-item_tr
        iv_before_image = lv_before_image
        iv_fill_data    = abap_true
      IMPORTING
        et_data         = lt_item ).

*   Option 2:
*   Retrive the external package id from ITEM_TR-PACKAGE_ID_EXT
    LOOP AT lt_item ASSIGNING FIELD-SYMBOL(<fs_item>)
      WHERE item_cat = /scmtms/if_tor_const=>sc_tor_item_category-packaging.

      IF <fs_item>-parent_key = <ls_root>-node_id.
*        IF <fs_item>-package_id IS NOT INITIAL.
*          APPEND <fs_item>-package_id TO et_package_id.
*        ENDIF.

        ASSIGN COMPONENT 'PACKAGE_ID_EXT' OF STRUCTURE <fs_item> TO FIELD-SYMBOL(<fv_package_id_ext>).
        IF <fv_package_id_ext> IS ASSIGNED AND <fv_package_id_ext> IS NOT INITIAL.
          APPEND <fv_package_id_ext> TO lt_package_id_ext.
          UNASSIGN <fv_package_id_ext>.
        ENDIF.
      ENDIF.
    ENDLOOP.

*   Option 3:
*   Retrive the external package id from
*     freight unit-Items-notes-Text type = 'EPKG'
    zcl_gtt_sts_tools=>get_package_id_v2(
      EXPORTING
        ir_root           = ir_root
        iv_old_data       = iv_old_data
      IMPORTING
        et_package_id_ext = et_package_id_ext ).

    APPEND LINES OF lt_package_id_ext TO et_package_id_ext.

    SORT et_package_id_ext BY table_line.
    DELETE ADJACENT DUPLICATES FROM et_package_id_ext COMPARING ALL FIELDS.

  ENDMETHOD.


  METHOD get_package_id_v2.

    FIELD-SYMBOLS <ls_root> TYPE /scmtms/s_em_bo_tor_root.
    DATA:
      lt_item        TYPE /scmtms/t_tor_item_tr_k,
      lt_txt_root    TYPE /bobf/t_txc_root_k,
      ls_key_map     TYPE ts_txc_key_mapping,
      lt_target_key  TYPE /bobf/t_frw_key,
      lt_target_key2 TYPE /bobf/t_frw_key,
      lt_text        TYPE /bobf/t_txc_txt_k,
      lt_cont        TYPE /bobf/t_txc_con_k.

    CLEAR:
      et_package_id,
      et_package_id_ext.

    ASSIGN ir_root->* TO <ls_root>.
    IF sy-subrc <> 0.
      MESSAGE e010(zgtt_sts) INTO DATA(lv_dummy) ##needed.
      zcl_gtt_sts_tools=>throw_exception( ).
    ENDIF.

    DATA(lv_before_image) = SWITCH abap_bool( iv_old_data WHEN abap_true THEN abap_true
                                                          ELSE abap_false ).

    DATA(lr_srvmgr_tor) = /bobf/cl_tra_serv_mgr_factory=>get_service_manager( iv_bo_key = /scmtms/if_tor_c=>sc_bo_key ).

    lr_srvmgr_tor->retrieve_by_association(
      EXPORTING
        it_key          = VALUE #( ( key = <ls_root>-node_id ) )
        iv_node_key     = /scmtms/if_tor_c=>sc_node-root
        iv_association  = /scmtms/if_tor_c=>sc_association-root-item_tr
        iv_before_image = lv_before_image
        iv_fill_data    = abap_true
      IMPORTING
        et_data         = lt_item ).

    DELETE lt_item WHERE item_cat <> /scmtms/if_tor_const=>sc_tor_item_category-packaging.

    CHECK lt_item IS NOT INITIAL.
    lr_srvmgr_tor->retrieve_by_association(
      EXPORTING
        iv_node_key     = /scmtms/if_tor_c=>sc_node-item_tr
        it_key          = CORRESPONDING #( lt_item )
        iv_association  = /scmtms/if_tor_c=>sc_association-item_tr-itemtextcollection
        iv_before_image = lv_before_image
        iv_fill_data    = abap_true
      IMPORTING
        et_data         = lt_txt_root
        et_target_key   = lt_target_key ).

    zcl_gtt_sts_tools=>get_txc_key_mapping(
      EXPORTING
        iv_bo_key          = /scmtms/if_tor_c=>sc_bo_key
        iv_node            = /scmtms/if_tor_c=>sc_node-itemtextcollection
      IMPORTING
        es_txc_key_mapping = ls_key_map ).

*   Retrieve DO text node
    lr_srvmgr_tor->retrieve_by_association(
      EXPORTING
        iv_node_key     = ls_key_map-root_key
        it_key          = lt_target_key
        iv_association  = ls_key_map-text_asc
        iv_before_image = lv_before_image
        iv_fill_data    = abap_true
      IMPORTING
        et_data         = lt_text
        et_target_key   = lt_target_key2 ).

*   Retrieve DO text content nodes
    lr_srvmgr_tor->retrieve_by_association(
      EXPORTING
        iv_node_key     = ls_key_map-text_key
        it_key          = lt_target_key2
        iv_association  = ls_key_map-cont_asc
        iv_before_image = lv_before_image
        iv_fill_data    = abap_true
      IMPORTING
        et_data         = lt_cont ).

    LOOP AT lt_text INTO DATA(ls_text).
      IF ls_text-text_type = zif_gtt_sts_constants=>cs_text_type-epkg.
        READ TABLE lt_cont INTO DATA(ls_cont) WITH TABLE KEY parent_key
         COMPONENTS parent_key = ls_text-key .
        IF sy-subrc = 0.
          APPEND ls_cont-text TO et_package_id_ext.
        ENDIF.
      ENDIF.
    ENDLOOP.

    DELETE et_package_id_ext WHERE table_line IS INITIAL.

  ENDMETHOD.


  METHOD get_plate_truck_number.

    FIELD-SYMBOLS <ls_root> TYPE /scmtms/s_em_bo_tor_root.
    DATA:
      lt_item       TYPE /scmtms/t_tor_item_tr_k.

    CLEAR:
      ev_platenumber,
      ev_truck_id.

    ASSIGN ir_root->* TO <ls_root>.
    IF sy-subrc <> 0.
      MESSAGE e010(zgtt_sts) INTO DATA(lv_dummy) ##needed.
      zcl_gtt_sts_tools=>throw_exception( ).
    ENDIF.

    DATA(lv_before_image) = SWITCH abap_bool( iv_old_data WHEN abap_true THEN abap_true
                                                          ELSE abap_false ).

    DATA(lr_srvmgr_tor) = /bobf/cl_tra_serv_mgr_factory=>get_service_manager( iv_bo_key = /scmtms/if_tor_c=>sc_bo_key ).

    lr_srvmgr_tor->retrieve_by_association(
      EXPORTING
        it_key          = VALUE #( ( key = <ls_root>-node_id ) )
        iv_node_key     = /scmtms/if_tor_c=>sc_node-root
        iv_association  = /scmtms/if_tor_c=>sc_association-root-item_tr
        iv_before_image = lv_before_image
        iv_fill_data    = abap_true
      IMPORTING
        et_data         = lt_item ).

    ASSIGN lt_item[ item_cat = /scmtms/if_tor_const=>sc_tor_item_category-av_item ] TO FIELD-SYMBOL(<ls_item>).
    IF <ls_item> IS ASSIGNED.
      ev_platenumber = <ls_item>-platenumber.
      ev_truck_id = <ls_item>-res_id.
    ENDIF.

  ENDMETHOD.


  METHOD get_postal_address.

    DATA(lo_tor_srv_mgr) = /bobf/cl_tra_serv_mgr_factory=>get_service_manager( iv_bo_key = /scmtms/if_tor_c=>sc_bo_key ).
    DATA(lo_loc_srv_mgr) = /bobf/cl_tra_serv_mgr_factory=>get_service_manager( iv_bo_key = /scmtms/if_location_c=>sc_bo_key ).

    lo_tor_srv_mgr->retrieve_by_association(
        EXPORTING
          iv_node_key    = /scmtms/if_tor_c=>sc_node-root
          it_key         = VALUE #( ( key = iv_node_id ) )
          iv_association = /scmtms/if_tor_c=>sc_association-root-stop
        IMPORTING
          et_target_key  = DATA(lt_stop_target_key) ).

    IF lt_stop_target_key IS NOT INITIAL.
      lo_tor_srv_mgr->retrieve_by_association(
        EXPORTING
          iv_node_key    = /scmtms/if_tor_c=>sc_node-stop
          it_key         = CORRESPONDING #( lt_stop_target_key )
          iv_association = /scmtms/if_tor_c=>sc_association-stop-bo_loc_log
        IMPORTING
          et_key_link    = DATA(lt_loc_log_key_link) ).

      IF lt_loc_log_key_link IS NOT INITIAL.
        lo_loc_srv_mgr->retrieve_by_association(
        EXPORTING
          iv_node_key    = /scmtms/if_location_c=>sc_node-root
          it_key         = CORRESPONDING #( lt_loc_log_key_link MAPPING key = target_key )
          iv_association = /scmtms/if_location_c=>sc_association-root-address
        IMPORTING
          et_key_link    = DATA(lt_address_key_link) ).

        IF lt_address_key_link IS NOT INITIAL.
          TRY.
              DATA(lr_bo_conf) = /bobf/cl_frw_factory=>get_configuration( iv_bo_key = /scmtms/if_location_c=>sc_bo_key ).
            CATCH /bobf/cx_frw.
              MESSAGE e011(zgtt_sts) INTO DATA(lv_dummy) ##needed.
              zcl_gtt_sts_tools=>throw_exception( ).
          ENDTRY.

          DATA(lv_postal_ass_key) = lr_bo_conf->get_content_key_mapping(
                           iv_content_cat      = /bobf/if_conf_c=>sc_content_ass
                           iv_do_content_key   = /bofu/if_addr_constants=>sc_association-root-postal_address
                           iv_do_root_node_key = /scmtms/if_location_c=>sc_node-/bofu/address ).

          lo_loc_srv_mgr->retrieve_by_association(
            EXPORTING
              iv_node_key    = /scmtms/if_location_c=>sc_node-/bofu/address
              it_key         = CORRESPONDING #( lt_address_key_link MAPPING key = target_key )
              iv_association = lv_postal_ass_key
              iv_fill_data   = abap_true
            IMPORTING
              et_data        = et_postal_address ).
        ENDIF.
      ENDIF.
    ENDIF.

  ENDMETHOD.


  METHOD get_pretty_value.

    rv_pretty   = COND #( WHEN zcl_gtt_sts_tools=>is_number( iv_value = iv_value ) = abap_true
                            THEN |{ iv_value }|
                            ELSE iv_value ).

  ENDMETHOD.


  METHOD get_reqcapa_info_mul.

    FIELD-SYMBOLS:
      <ls_root>  TYPE /scmtms/s_em_bo_tor_root.

    DATA:
      lo_srvmgr_tor        TYPE REF TO /bobf/if_tra_service_manager,
      lt_root_key          TYPE /bobf/t_frw_key,
      lt_root_key_tmp      TYPE /bobf/t_frw_key,
      lt_req_stop          TYPE /scmtms/t_tor_stop_k,
      lt_capa_stop_seq     TYPE TABLE OF /scmtms/s_pln_stop_seq_d,
      lt_capa_stop_seq_tmp TYPE /scmtms/t_pln_stop_seq_d,
      lt_capa              TYPE TABLE OF /scmtms/s_tor_root_k,
      lt_capa_tmp          TYPE /scmtms/t_tor_root_k,
      lt_capa_stop         TYPE TABLE OF /scmtms/s_tor_stop_k,
      lt_capa_stop_tmp     TYPE /scmtms/t_tor_stop_k,
      lt_capa_key          TYPE /bobf/t_frw_key,
      lv_key               TYPE /bobf/conf_key,
      lt_req2capa_info     TYPE tt_req2capa_info,
      ls_req2capa_info     TYPE ts_req2capa_info,
      lt_cap_stop_seq      TYPE tt_cap_stop_seq,
      ls_cap_stop_seq      TYPE ts_cap_stop_seq,
      lt_capa_stop_seq_new TYPE /scmtms/t_pln_stop_seq,
      lv_order             TYPE numc04,
      lv_counter           TYPE int4,
      lt_capa_list         TYPE tt_capa_list,
      ls_capa_list         TYPE ts_capa_list,
      lt_stop_tmp          TYPE /scmtms/t_em_bo_tor_stop.

    CLEAR:
      et_req2capa_info,
      et_capa_list,
      et_capa_detail,
      et_capa_stop_seq.

    IF it_root_key IS NOT INITIAL.
      lt_root_key = it_root_key.
    ELSE.
      ASSIGN ir_root->* TO <ls_root>.
      IF sy-subrc <> 0.
        MESSAGE e010(zgtt_sts) INTO DATA(lv_dummy) ##needed.
        zcl_gtt_sts_tools=>throw_exception( ).
      ENDIF.
      lt_root_key = VALUE #( ( key = <ls_root>-node_id ) ).
    ENDIF.

    lo_srvmgr_tor = /bobf/cl_tra_serv_mgr_factory=>get_service_manager( iv_bo_key = /scmtms/if_tor_c=>sc_bo_key ).
    lt_root_key_tmp = lt_root_key.

    lo_srvmgr_tor->retrieve_by_association(
      EXPORTING
        iv_node_key     = /scmtms/if_tor_c=>sc_node-root
        it_key          = lt_root_key
        iv_association  = /scmtms/if_tor_c=>sc_association-root-stop
        iv_fill_data    = abap_true
        iv_before_image = iv_old_data
      IMPORTING
        et_data         = lt_req_stop ).

*   1)Find capacity document
    DO 10 TIMES.

      CLEAR:
        lt_capa_key,
        lt_capa_tmp,
        lt_capa_stop_tmp,
        lt_capa_stop_seq_tmp.

      lo_srvmgr_tor->retrieve_by_association(
        EXPORTING
          iv_node_key     = /scmtms/if_tor_c=>sc_node-root
          it_key          = lt_root_key_tmp
          iv_association  = /scmtms/if_tor_c=>sc_association-root-capa_tor
          iv_fill_data    = abap_true
          iv_before_image = iv_old_data
        IMPORTING
          et_data         = lt_capa_tmp
          et_target_key   = lt_capa_key ).

      CLEAR lt_root_key_tmp.
      lt_root_key_tmp = CORRESPONDING #( lt_capa_key ).

*     Capacity document is not found
      IF lt_root_key_tmp IS INITIAL.
        EXIT."exit the loop
      ENDIF.

      lo_srvmgr_tor->retrieve_by_association(
        EXPORTING
          iv_node_key     = /scmtms/if_tor_c=>sc_node-root
          it_key          = lt_root_key_tmp
          iv_association  = /scmtms/if_tor_c=>sc_association-root-stop
          iv_fill_data    = abap_true
          iv_before_image = iv_old_data
        IMPORTING
          et_data         = lt_capa_stop_tmp ).

      /scmtms/cl_tor_helper_stop=>get_stop_sequence(
        EXPORTING
          it_root_key     = lt_root_key_tmp
          iv_before_image = iv_old_data
        IMPORTING
          et_stop_seq_d   = lt_capa_stop_seq_tmp ).

      APPEND LINES OF lt_capa_tmp TO lt_capa.
      APPEND LINES OF lt_capa_stop_tmp TO lt_capa_stop.
      APPEND LINES OF lt_capa_stop_seq_tmp TO lt_capa_stop_seq.

*     Freight order is found,then exit the loop
      READ TABLE lt_capa_tmp TRANSPORTING NO FIELDS
        WITH TABLE KEY tor_cat COMPONENTS tor_cat = /scmtms/if_tor_const=>sc_tor_category-active.
      IF sy-subrc = 0.
        EXIT."exit the loop
      ELSE.
        READ TABLE lt_capa_tmp TRANSPORTING NO FIELDS
          WITH TABLE KEY tor_cat COMPONENTS tor_cat = /scmtms/if_tor_const=>sc_tor_category-booking.
        IF sy-subrc = 0.
          EXIT."exit the loop
        ENDIF.
      ENDIF.
    ENDDO.

    CLEAR:
      lt_capa_tmp,
      lt_capa_stop_tmp,
      lt_capa_stop_seq_tmp.

    SORT lt_capa BY key.
    SORT lt_capa_stop BY key.
    SORT lt_capa_stop_seq BY root_key seq_id.

*   2)Build requirement document and capacity document relationship table
    LOOP AT lt_req_stop INTO DATA(ls_req_stop).
      lv_key = ls_req_stop-assgn_stop_key.

      DO 10 TIMES.
        READ TABLE lt_capa_stop INTO DATA(ls_capa_stop)
          WITH KEY key = lv_key.
        IF sy-subrc = 0.
          lv_key = ls_capa_stop-assgn_stop_key.
          READ TABLE lt_capa INTO DATA(ls_capa)
            WITH KEY key = ls_capa_stop-parent_key.
          IF sy-subrc = 0 AND ( ls_capa-tor_cat = /scmtms/if_tor_const=>sc_tor_category-active
                           OR ls_capa-tor_cat = /scmtms/if_tor_const=>sc_tor_category-booking ).
            ls_req2capa_info-req_key = ls_req_stop-parent_key.
            ls_req2capa_info-req_no = <ls_root>-tor_id.
            ls_req2capa_info-req_stop_key = ls_req_stop-key.
            ls_req2capa_info-req_assgn_stop_key = ls_req_stop-assgn_stop_key.
            ls_req2capa_info-req_log_locid = ls_req_stop-log_locid.
            ls_req2capa_info-cap_no  = ls_capa-tor_id.
            ls_req2capa_info-cap_key = ls_capa_stop-parent_key.
            ls_req2capa_info-cap_stop_key = ls_capa_stop-key.
            ls_req2capa_info-cap_plan_trans_time = ls_capa_stop-plan_trans_time.
            ls_req2capa_info-cap_trmodcat = ls_capa-trmodcat.
            ls_req2capa_info-cap_shipping_type = ls_capa-shipping_type.
            APPEND ls_req2capa_info TO lt_req2capa_info.
            CLEAR ls_req2capa_info.
            EXIT.
          ENDIF.
        ELSE.
          EXIT.
        ENDIF.
      ENDDO.
    ENDLOOP.

*   3)Prepare capacity document stop sequence table
    LOOP AT lt_capa_stop_seq INTO DATA(ls_capa_stop_seq).
      CLEAR:
       ls_capa,
       lt_capa_stop_seq_new.

      lv_order = 1.

      APPEND LINES OF ls_capa_stop_seq-stop_seq TO lt_capa_stop_seq_new.

      READ TABLE lt_capa INTO ls_capa
         WITH KEY key = ls_capa_stop_seq-root_key.

      LOOP AT lt_capa_stop_seq_new INTO DATA(ls_capa_stop_seq_new).

        ls_cap_stop_seq-cap_no = ls_capa-tor_id.
        ls_cap_stop_seq-cap_key  = ls_capa_stop_seq_new-root_key.

        READ TABLE ls_capa_stop_seq-stop_map INTO DATA(ls_capa_stop_map)
          WITH KEY tabix = ls_capa_stop_seq_new-seq_num.
        IF sy-subrc = 0.
          ls_cap_stop_seq-cap_stop_key = ls_capa_stop_seq_new-stop_key.
        ENDIF.

        IF NOT zcl_gtt_sts_tools=>is_odd( ls_capa_stop_seq_new-seq_num ).
          lv_order += 1.
        ENDIF.
        ls_cap_stop_seq-seq = lv_order.
        APPEND ls_cap_stop_seq TO lt_cap_stop_seq.
        CLEAR ls_cap_stop_seq.

      ENDLOOP.
    ENDLOOP.

*   4)Summarize all of the data
    LOOP AT lt_req2capa_info ASSIGNING FIELD-SYMBOL(<fs_req2capa_info>).
      CLEAR ls_cap_stop_seq.
      READ TABLE lt_cap_stop_seq INTO ls_cap_stop_seq
        WITH KEY cap_no       = <fs_req2capa_info>-cap_no
                 cap_key      = <fs_req2capa_info>-cap_key
                 cap_stop_key = <fs_req2capa_info>-cap_stop_key.
      IF sy-subrc = 0.
        <fs_req2capa_info>-cap_seq = ls_cap_stop_seq-seq.
      ENDIF.
    ENDLOOP.

    SORT lt_req2capa_info BY cap_no
                             cap_seq.

*   5)Prepare capacity document list
    LOOP AT lt_req2capa_info INTO ls_req2capa_info
      GROUP BY ls_req2capa_info-cap_no ASSIGNING FIELD-SYMBOL(<lt_capa_group>).
      CLEAR:
        lv_counter,
        ls_capa_list.

      LOOP AT GROUP <lt_capa_group> ASSIGNING FIELD-SYMBOL(<ls_capa_group>).
        lv_counter = lv_counter + 1.
        IF lv_counter = 1.
          ls_capa_list-cap_no = |{ <ls_capa_group>-cap_no ALPHA = OUT }|.
          ls_capa_list-first_stop = |{ ls_capa_list-cap_no }{ <ls_capa_group>-cap_seq }|.
          CONDENSE ls_capa_list-first_stop NO-GAPS.
        ENDIF.
        ls_capa_list-last_stop = |{ ls_capa_list-cap_no }{ <ls_capa_group>-cap_seq }|.
        CONDENSE ls_capa_list-last_stop NO-GAPS.
      ENDLOOP.
      APPEND ls_capa_list TO lt_capa_list.
    ENDLOOP.

*   6)Output the result
    et_req2capa_info = lt_req2capa_info.
    et_capa_list = lt_capa_list.

*   7)Prepare capacity detail result.
    DELETE lt_capa WHERE tor_cat <> /scmtms/if_tor_const=>sc_tor_category-active
                     AND tor_cat <> /scmtms/if_tor_const=>sc_tor_category-booking.
    et_capa_detail = CORRESPONDING #( lt_capa MAPPING node_id = key tor_root_node = root_key ).

*   8)prepare Capacity Stop Sequences table
    LOOP AT lt_capa_stop_seq INTO ls_capa_stop_seq.
      CLEAR:
        ls_capa,
        lt_stop_tmp.
      READ TABLE lt_capa INTO ls_capa WITH KEY key = ls_capa_stop_seq-root_key.
      IF sy-subrc = 0.
        MOVE-CORRESPONDING ls_capa_stop_seq-stop_seq TO lt_stop_tmp.
        LOOP AT lt_stop_tmp ASSIGNING FIELD-SYMBOL(<ls_stop_tmp>).
          <ls_stop_tmp>-parent_node_id = ls_capa_stop_seq-root_key.
          ASSIGN ls_capa_stop_seq-stop_map[ tabix = <ls_stop_tmp>-seq_num ]-stop_key TO FIELD-SYMBOL(<lv_stop_key>).
          CHECK sy-subrc = 0.
          <ls_stop_tmp>-node_id = <lv_stop_key>.
        ENDLOOP.
        APPEND LINES OF lt_stop_tmp TO et_capa_stop_seq.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.


  METHOD get_req_info.

    FIELD-SYMBOLS:
      <ls_root>          TYPE /scmtms/s_em_bo_tor_root.
    DATA:
      lt_req TYPE /scmtms/t_tor_root_k.

    CLEAR et_req_tor.

    ASSIGN ir_root->* TO <ls_root>.
    IF sy-subrc <> 0.
      MESSAGE e010(zgtt_sts) INTO DATA(lv_dummy) ##needed.
      zcl_gtt_sts_tools=>throw_exception( ).
    ENDIF.

    DATA(lr_srvmgr_tor) = /bobf/cl_tra_serv_mgr_factory=>get_service_manager(
      iv_bo_key = /scmtms/if_tor_c=>sc_bo_key ).

    lr_srvmgr_tor->retrieve_by_association(
      EXPORTING
        iv_node_key     = /scmtms/if_tor_c=>sc_node-root
        it_key          = VALUE #( ( key = <ls_root>-node_id ) )
        iv_association  = /scmtms/if_tor_c=>sc_association-root-req_tor
        iv_fill_data    = abap_true
        iv_before_image = iv_old_data
      IMPORTING
        et_data         = lt_req ).

    et_req_tor = CORRESPONDING #( lt_req MAPPING node_id = key tor_root_node = root_key ).

  ENDMETHOD.


  METHOD get_req_info_mul.

    FIELD-SYMBOLS:
      <ls_root>  TYPE /scmtms/s_em_bo_tor_root.

    DATA:
      lo_srvmgr_tor   TYPE REF TO /bobf/if_tra_service_manager,
      lt_root_key     TYPE /bobf/t_frw_key,
      lt_root_key_tmp TYPE /bobf/t_frw_key,
      lt_req_key      TYPE /bobf/t_frw_key,
      lt_req_tmp      TYPE /scmtms/t_tor_root_k,
      lt_req_stop_tmp TYPE /scmtms/t_tor_stop_k,
      lt_req          TYPE /scmtms/t_tor_root_k,
      lt_req_stop     TYPE /scmtms/t_tor_stop_k.

    CLEAR:
      et_req,
      et_req_stop.

    IF it_root_key IS NOT INITIAL.
      lt_root_key = it_root_key.
    ELSE.
      ASSIGN ir_root->* TO <ls_root>.
      IF sy-subrc <> 0.
        MESSAGE e010(zgtt_sts) INTO DATA(lv_dummy) ##needed.
        zcl_gtt_sts_tools=>throw_exception( ).
      ENDIF.
      lt_root_key = VALUE #( ( key = <ls_root>-node_id ) ).
    ENDIF.

    lo_srvmgr_tor = /bobf/cl_tra_serv_mgr_factory=>get_service_manager( iv_bo_key = /scmtms/if_tor_c=>sc_bo_key ).
    lt_root_key_tmp = lt_root_key.

*   Find requirement document
    DO 10 TIMES.

      CLEAR:
        lt_req_tmp,
        lt_req_stop_tmp,
        lt_req_key.

*     Get requirement information
      lo_srvmgr_tor->retrieve_by_association(
        EXPORTING
          iv_node_key     = /scmtms/if_tor_c=>sc_node-root
          it_key          = lt_root_key_tmp
          iv_association  = /scmtms/if_tor_c=>sc_association-root-req_tor
          iv_fill_data    = abap_true
          iv_before_image = iv_old_data
        IMPORTING
          et_data         = lt_req_tmp
          et_target_key   = lt_req_key ).

      CLEAR lt_root_key_tmp.
      lt_root_key_tmp = CORRESPONDING #( lt_req_key ).

*     Check the document is FU or not
      READ TABLE lt_req_tmp TRANSPORTING NO FIELDS
        WITH TABLE KEY tor_cat COMPONENTS tor_cat = /scmtms/if_tor_const=>sc_tor_category-freight_unit.
      IF sy-subrc <> 0.
        CONTINUE.
      ENDIF.

*     Get requirement Stop information
      lo_srvmgr_tor->retrieve_by_association(
        EXPORTING
          iv_node_key     = /scmtms/if_tor_c=>sc_node-root
          it_key          = lt_root_key_tmp
          iv_association  = /scmtms/if_tor_c=>sc_association-root-stop
          iv_fill_data    = abap_true
          iv_before_image = iv_old_data
        IMPORTING
          et_data         = lt_req_stop_tmp ).

      APPEND LINES OF lt_req_tmp TO lt_req.
      APPEND LINES OF lt_req_stop_tmp TO lt_req_stop.
      EXIT."Exit the loop
    ENDDO.

    et_req      = CORRESPONDING #( lt_req MAPPING node_id = key tor_root_node = root_key ).
    et_req_stop = CORRESPONDING #( lt_req_stop MAPPING node_id = key parent_node_id = parent_key ).

  ENDMETHOD.


  METHOD get_req_stop_info.

    FIELD-SYMBOLS:
      <ls_tor_root> TYPE /scmtms/s_em_bo_tor_root.

    DATA:
      lv_seq_num         TYPE i,
      lv_req_doc_line_no TYPE i,
      lr_srvmgr_tor      TYPE REF TO /bobf/if_tra_service_manager,
      lt_root_key        TYPE /bobf/t_frw_key,
      lt_fo_stop         TYPE /scmtms/t_tor_stop_k,
      lt_req_tor         TYPE /scmtms/t_tor_root_k,
      lt_fu_stop         TYPE /scmtms/t_em_bo_tor_stop,
      ls_req_stop        TYPE ts_capa_stop.

    CLEAR et_req_stop.

    ASSIGN ir_root->* TO <ls_tor_root>.
    IF sy-subrc <> 0.
      MESSAGE e010(zgtt_sts) INTO DATA(lv_dummy) ##needed.
      zcl_gtt_sts_tools=>throw_exception( ).
    ENDIF.

    DATA(lv_before_image) = SWITCH abap_bool( iv_old_data WHEN abap_true THEN abap_true
                                                          ELSE abap_false ).

    lt_root_key = VALUE #( ( key = <ls_tor_root>-node_id ) ).

    lr_srvmgr_tor = /bobf/cl_tra_serv_mgr_factory=>get_service_manager(
      iv_bo_key = /scmtms/if_tor_c=>sc_bo_key ).

    lr_srvmgr_tor->retrieve_by_association(
      EXPORTING
        iv_node_key     = /scmtms/if_tor_c=>sc_node-root
        it_key          = lt_root_key
        iv_association  = /scmtms/if_tor_c=>sc_association-root-stop
        iv_fill_data    = abap_true
        iv_before_image = lv_before_image
      IMPORTING
        et_data         = lt_fo_stop ).

    lr_srvmgr_tor->retrieve_by_association(
      EXPORTING
        iv_node_key     = /scmtms/if_tor_c=>sc_node-root
        it_key          = lt_root_key
        iv_association  = /scmtms/if_tor_c=>sc_association-root-req_tor
        iv_fill_data    = abap_true
        iv_before_image = lv_before_image
      IMPORTING
        et_data         = lt_req_tor
        et_key_link     = DATA(lt_req2capa_link) ).

    LOOP AT lt_req2capa_link INTO DATA(ls_req2capa_link).
      READ TABLE lt_req_tor INTO DATA(ls_req_tor) WITH KEY key = ls_req2capa_link-target_key.
      CHECK sy-subrc = 0.
      /scmtms/cl_tor_helper_stop=>get_stop_sequence(
        EXPORTING
          it_root_key     = VALUE #( ( key = ls_req2capa_link-target_key ) )
          iv_before_image = lv_before_image
        IMPORTING
          et_stop_seq_d   = DATA(lt_stop_seq) ).

      ASSIGN lt_stop_seq[ root_key = ls_req2capa_link-target_key ] TO FIELD-SYMBOL(<ls_stop_seq>) ##WARN_OK.
      IF sy-subrc = 0.
        MOVE-CORRESPONDING <ls_stop_seq>-stop_seq TO lt_fu_stop.
        LOOP AT lt_fu_stop ASSIGNING FIELD-SYMBOL(<ls_fu_stop>).
          <ls_fu_stop>-parent_node_id = ls_req2capa_link-target_key.
          ASSIGN <ls_stop_seq>-stop_map[ tabix = <ls_fu_stop>-seq_num ]-stop_key TO FIELD-SYMBOL(<lv_stop_key>).
          CHECK sy-subrc = 0.
          <ls_fu_stop>-node_id = <lv_stop_key>.
        ENDLOOP.
      ENDIF.

      zcl_gtt_sts_tools=>get_stop_points(
        EXPORTING
          iv_root_id     = ls_req_tor-tor_id
          it_stop        = lt_fu_stop
        IMPORTING
          et_stop_points = DATA(lt_stop_points) ).

      LOOP AT lt_fu_stop USING KEY parent_seqnum ASSIGNING <ls_fu_stop>.
        ASSIGN lt_fo_stop[ key = <ls_fu_stop>-assgn_stop_key  parent_key = ls_req2capa_link-source_key ] TO FIELD-SYMBOL(<ls_fo_stop>).
        IF sy-subrc = 0.
          IF lv_seq_num IS INITIAL.
            READ TABLE lt_stop_points INTO DATA(ls_stop_points)
              WITH KEY  seq_num   = <ls_fu_stop>-seq_num
                        log_locid = <ls_fu_stop>-log_locid.
            IF sy-subrc = 0.
              DATA(lv_req_doc_first_stop) = ls_stop_points-stop_id.
            ENDIF.
          ENDIF.
          lv_seq_num = <ls_fu_stop>-seq_num.
        ENDIF.
      ENDLOOP.

      IF lv_seq_num IS NOT INITIAL.
        DATA(lv_req_doc_last_stop) = lt_stop_points[ seq_num = lv_seq_num ]-stop_id.
      ENDIF.

      lv_req_doc_line_no = lv_req_doc_line_no + 1.
      ls_req_stop-line_no = lv_req_doc_line_no.
      ls_req_stop-tor_id = |{ ls_req_tor-tor_id ALPHA = OUT }|.
      ls_req_stop-first_stop = |{ lv_req_doc_first_stop ALPHA = OUT }|.
      ls_req_stop-last_stop = |{ lv_req_doc_last_stop ALPHA = OUT }|.
      CONDENSE ls_req_stop-tor_id NO-GAPS.
      CONDENSE ls_req_stop-first_stop NO-GAPS.
      CONDENSE ls_req_stop-last_stop NO-GAPS.
      APPEND ls_req_stop TO et_req_stop.

      CLEAR: lv_seq_num, lt_stop_points.
    ENDLOOP.

  ENDMETHOD.


  METHOD get_stop_points.

    DATA lv_order(4) TYPE n VALUE '0001'.

    LOOP AT it_stop USING KEY parent_seqnum ASSIGNING FIELD-SYMBOL(<ls_stop>).
      IF NOT zcl_gtt_sts_tools=>is_odd( <ls_stop>-seq_num ).
        lv_order += 1.
      ENDIF.
      APPEND VALUE #( stop_id   = |{ iv_root_id }{ lv_order }|
                      log_locid = <ls_stop>-log_locid
                      seq_num   = <ls_stop>-seq_num ) TO et_stop_points.
    ENDLOOP.

  ENDMETHOD.


  METHOD get_system_date_time.

    rv_datetime   = |0{ sy-datum }{ sy-uzeit }|.

  ENDMETHOD.


  METHOD get_system_time_zone.

    rv_tzone = zcl_gtt_tools=>get_system_time_zone( ).

  ENDMETHOD.


  METHOD get_track_conf.

    CLEAR et_conf.

    SELECT *
      INTO TABLE et_conf
      FROM zgtt_track_conf.

  ENDMETHOD.


  METHOD get_track_obj_changes.

    zcl_gtt_sts_tools=>get_track_obj_changes_v2(
      EXPORTING
        is_app_object        = is_app_object
        iv_appsys            = iv_appsys
        it_track_id_data_new = it_track_id_data_new
        it_track_id_data_old = it_track_id_data_old
      CHANGING
        ct_track_id_data     = ct_track_id_data ).

  ENDMETHOD.


  METHOD get_track_obj_changes_v2.

    DATA:
      lt_track_id_data_new TYPE zif_gtt_sts_ef_types=>tt_enh_track_id_data,
      lt_track_id_data_old TYPE zif_gtt_sts_ef_types=>tt_enh_track_id_data.

    lt_track_id_data_new = it_track_id_data_new.
    lt_track_id_data_old = it_track_id_data_old.

    SORT lt_track_id_data_new BY key appsys appobjtype appobjid trxcod trxid.
    SORT lt_track_id_data_old BY key appsys appobjtype appobjid trxcod trxid.
    DELETE ADJACENT DUPLICATES FROM lt_track_id_data_new COMPARING ALL FIELDS.
    DELETE ADJACENT DUPLICATES FROM lt_track_id_data_old COMPARING ALL FIELDS.

    LOOP AT lt_track_id_data_new INTO DATA(ls_track_id_data_new).
      READ TABLE lt_track_id_data_old INTO DATA(ls_track_id_data_old)
        WITH KEY key        = ls_track_id_data_new-key
                 appsys     = ls_track_id_data_new-appsys
                 appobjtype = ls_track_id_data_new-appobjtype
                 appobjid   = ls_track_id_data_new-appobjid
                 trxcod     = ls_track_id_data_new-trxcod
                 trxid      = ls_track_id_data_new-trxid.
      IF sy-subrc = 0.
        DELETE lt_track_id_data_old WHERE key        = ls_track_id_data_new-key
                                     AND  appsys     = ls_track_id_data_new-appsys
                                     AND  appobjtype = ls_track_id_data_new-appobjtype
                                     AND  appobjid   = ls_track_id_data_new-appobjid
                                     AND  trxcod     = ls_track_id_data_new-trxcod
                                     AND  trxid      = ls_track_id_data_new-trxid.
      ENDIF.
    ENDLOOP.

    LOOP AT lt_track_id_data_new INTO ls_track_id_data_new.
      APPEND VALUE #( appsys      = iv_appsys
                      appobjtype  = is_app_object-appobjtype
                      appobjid    = is_app_object-appobjid
                      trxcod      = ls_track_id_data_new-trxcod
                      trxid       = ls_track_id_data_new-trxid ) TO ct_track_id_data.
    ENDLOOP.

    " Deleted resources
    LOOP AT lt_track_id_data_old ASSIGNING FIELD-SYMBOL(<ls_track_id_data_del>).
      APPEND VALUE #( appsys      = iv_appsys
                      appobjtype  = is_app_object-appobjtype
                      appobjid    = is_app_object-appobjid
                      trxcod      = <ls_track_id_data_del>-trxcod
                      trxid       = <ls_track_id_data_del>-trxid
                      action      = /scmtms/cl_scem_int_c=>sc_param_action-delete ) TO ct_track_id_data.
    ENDLOOP.

    SORT ct_track_id_data BY appsys appobjtype appobjid trxcod trxid.
    DELETE ADJACENT DUPLICATES FROM ct_track_id_data COMPARING ALL FIELDS.

  ENDMETHOD.


  METHOD get_trmodcod.

    CASE iv_trmodcod.
      WHEN '01'.
        rv_trmodcod = '03'.
      WHEN '02'.
        rv_trmodcod = '02'.
      WHEN '03'.
        rv_trmodcod = '01'.
      WHEN '05'.
        rv_trmodcod = '04'.
      WHEN '06'.
        rv_trmodcod = '05'.
      WHEN OTHERS.
        rv_trmodcod = ''.
    ENDCASE.

  ENDMETHOD.


  METHOD get_txc_key_mapping.

    CLEAR es_txc_key_mapping.

*   Get DO content mappings
    /scmtms/cl_common_helper=>get_do_keys_4_rba(
      EXPORTING
        iv_host_bo_key      = iv_bo_key
        iv_host_do_node_key = iv_node
        iv_do_node_key      = /bobf/if_txc_c=>sc_node-root
      IMPORTING
        ev_node_key         = es_txc_key_mapping-root_key ).

    /scmtms/cl_common_helper=>get_do_keys_4_rba(
      EXPORTING
        iv_host_bo_key      = iv_bo_key
        iv_host_do_node_key = iv_node
        iv_do_node_key      = /bobf/if_txc_c=>sc_node-text
        iv_do_assoc_key     = /bobf/if_txc_c=>sc_association-root-text
      IMPORTING
        ev_node_key         = es_txc_key_mapping-text_key
        ev_assoc_key        = es_txc_key_mapping-text_asc ).

    /scmtms/cl_common_helper=>get_do_keys_4_rba(
      EXPORTING
        iv_host_bo_key      = iv_bo_key
        iv_host_do_node_key = iv_node
        iv_do_node_key      = /bobf/if_txc_c=>sc_node-text_content
        iv_do_assoc_key     = /bobf/if_txc_c=>sc_association-text-text_content
      IMPORTING
        ev_node_key         = es_txc_key_mapping-cont_key
        ev_assoc_key        = es_txc_key_mapping-cont_asc ).

  ENDMETHOD.


  METHOD is_number.

    DATA(lo_type) = cl_abap_typedescr=>describe_by_data( p_data = iv_value ).

    rv_result = SWITCH #( lo_type->type_kind
      WHEN cl_abap_typedescr=>typekind_decfloat OR
           cl_abap_typedescr=>typekind_decfloat16 OR
           cl_abap_typedescr=>typekind_decfloat34 OR
           cl_abap_typedescr=>typekind_float OR
           cl_abap_typedescr=>typekind_int OR
           cl_abap_typedescr=>typekind_int1 OR
           cl_abap_typedescr=>typekind_int2 OR
           cl_abap_typedescr=>typekind_int8 OR
           cl_abap_typedescr=>typekind_num OR
           cl_abap_typedescr=>typekind_numeric OR
           cl_abap_typedescr=>typekind_packed
        THEN abap_true
        ELSE abap_false ).

  ENDMETHOD.


  METHOD is_odd.

    DATA lv_reminder TYPE n.
    lv_reminder = iv_value MOD 2.
    IF lv_reminder <> 0.
      rv_is_odd = abap_true.
    ELSE.
      rv_is_odd = abap_false.
    ENDIF.

  ENDMETHOD.


  METHOD is_table.

    DATA(lo_type) = cl_abap_typedescr=>describe_by_data( p_data = iv_value ).

    rv_result = boolc( lo_type->type_kind = cl_abap_typedescr=>typekind_table ).

  ENDMETHOD.


  METHOD throw_exception.

    RAISE EXCEPTION TYPE cx_udm_message
      EXPORTING
        textid  = iv_textid
        m_msgid = sy-msgid
        m_msgty = sy-msgty
        m_msgno = sy-msgno
        m_msgv1 = sy-msgv1
        m_msgv2 = sy-msgv2
        m_msgv3 = sy-msgv3
        m_msgv4 = sy-msgv4.

  ENDMETHOD.


  METHOD get_scac_code.

    DATA:
      lt_bpsc  TYPE TABLE OF /scmtms/cv_bpscac,
      lv_lines TYPE i.

    CLEAR:rv_num.
    CHECK iv_partner IS NOT INITIAL.

    SELECT *
      INTO TABLE @lt_bpsc
      FROM /scmtms/cv_bpscac
     WHERE partner = @iv_partner.

    lv_lines = lines( lt_bpsc ).

    IF lv_lines > 1.
      DELETE lt_bpsc WHERE scac_valfr > sy-datum OR scac_valto < sy-datum.
    ENDIF.

    READ TABLE lt_bpsc INTO DATA(ls_bpsc) WITH KEY type = 'BUP006'."Standard Carrier Alpha Code
    IF sy-subrc = 0.
      rv_num = zif_gtt_sts_constants=>cv_scac_prefix && ls_bpsc-scac.
    ENDIF.

  ENDMETHOD.


  METHOD get_gtt_relev_flag_by_aot_type.

    CLEAR:rv_torelevant.

    IF iv_aotype IS INITIAL.
      RETURN.
    ENDIF.

    SELECT SINGLE torelevant
      INTO rv_torelevant
      FROM /saptrx/aotypes
     WHERE trk_obj_type = iv_trk_obj_type
       AND aotype = iv_aotype.

  ENDMETHOD.


  METHOD check_ltl_shipment.

    FIELD-SYMBOLS:
      <ls_root>  TYPE /scmtms/s_em_bo_tor_root.

    CLEAR:ev_ltl_flag.

    ASSIGN ir_root->* TO <ls_root>.
    IF sy-subrc <> 0.
      MESSAGE e010(zgtt_sts) INTO DATA(lv_dummy) ##needed.
      zcl_gtt_sts_tools=>throw_exception( ).
    ENDIF.

    IF <ls_root>-trmodcat = /scmtms/if_common_c=>sc_c_trmodcat_road           "Road transport
      AND <ls_root>-shipping_type = /scmtms/if_common_c=>c_shipping_type-ltl. "Shipping Type = "LTL (Less Than Truck Load)"
      ev_ltl_flag = abap_true.
    ENDIF.

  ENDMETHOD.


  METHOD convert_carrier_note_to_table.

*Example text,we only need the latest content between ##
*Will pick it up in the evening
*##MOBL:9198769876;MOBL1:9112341234;TRUCK:VIN2;TRAIL:TRAIL2;##
*(Reply from: 20.10.2023 03:55:10 UTC)
*-----------------------------------------------------------------
*Will pick it up in the afternoon
*##MOBL:81123456789;MOBL1:71987654321;TRUCK:VIN1;TRAIL:TRAIL1;##

    DATA:
      lv_pattern      TYPE char1024,
      lr_matcher      TYPE REF TO cl_abap_matcher,
      lt_match_result TYPE match_result_tab,
      ls_match_result TYPE match_result,
      lv_value        TYPE char16384,
      lt_list         TYPE TABLE OF char1024,
      ls_split_result TYPE ts_split_result.

    CLEAR et_split_result.

    lv_pattern = '##([^#]+)##'.

    lr_matcher = cl_abap_matcher=>create( pattern = lv_pattern text = iv_text ).
    lt_match_result = lr_matcher->find_all( ).
*   Only need the latest information
    READ TABLE lt_match_result INTO ls_match_result INDEX 1.
    IF sy-subrc = 0.
      lv_value = lr_matcher->text+ls_match_result-offset(ls_match_result-length).
      REPLACE ALL OCCURRENCES OF '##' IN lv_value WITH ''.
      SPLIT lv_value AT ';' INTO TABLE lt_list.
    ENDIF.

    LOOP AT lt_list INTO DATA(ls_list).
      SPLIT ls_list AT ':' INTO ls_split_result-key ls_split_result-val.
      APPEND ls_split_result TO et_split_result.
      CLEAR ls_split_result.
    ENDLOOP.

  ENDMETHOD.


  METHOD map_ep_evnt_code_to_event_code.

    CASE iv_ep_event_code.
      WHEN zif_gtt_sts_constants=>sc_tor_event-ep_arrival.
        ev_legacy_event_code = zif_gtt_sts_constants=>sc_tor_event-arriv_dest.
      WHEN zif_gtt_sts_constants=>sc_tor_event-ep_check_in.
        ev_legacy_event_code = zif_gtt_sts_constants=>sc_tor_event-check_in.
      WHEN zif_gtt_sts_constants=>sc_tor_event-ep_load_begin.
        ev_legacy_event_code = zif_gtt_sts_constants=>sc_tor_event-load_begin.
      WHEN zif_gtt_sts_constants=>sc_tor_event-ep_load_end.
        ev_legacy_event_code = zif_gtt_sts_constants=>sc_tor_event-load_end.
      WHEN zif_gtt_sts_constants=>sc_tor_event-ep_unload_begin.
        ev_legacy_event_code = zif_gtt_sts_constants=>sc_tor_event-unload_begin.
      WHEN zif_gtt_sts_constants=>sc_tor_event-ep_unload_end.
        ev_legacy_event_code = zif_gtt_sts_constants=>sc_tor_event-unload_end.
      WHEN zif_gtt_sts_constants=>sc_tor_event-ep_check_out.
        ev_legacy_event_code = zif_gtt_sts_constants=>sc_tor_event-check_out.
      WHEN zif_gtt_sts_constants=>sc_tor_event-ep_departure.
        ev_legacy_event_code = zif_gtt_sts_constants=>sc_tor_event-departure.
      WHEN OTHERS.
        " fallback to provided event code
        ev_legacy_event_code = iv_ep_event_code.
    ENDCASE.

  ENDMETHOD.
ENDCLASS.
