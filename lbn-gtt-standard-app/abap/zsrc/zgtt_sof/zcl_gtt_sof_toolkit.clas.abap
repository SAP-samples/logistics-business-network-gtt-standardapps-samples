class ZCL_GTT_SOF_TOOLKIT definition
  public
  final
  create public .

public section.

  types:
    BEGIN OF ts_stop_points,
        stop_id   TYPE string,
        log_locid TYPE /scmtms/location_id,
        seq_num   TYPE /scmtms/seq_num,
      END OF ts_stop_points .
  types:
    BEGIN OF ts_tor_data,
        delivery_number       TYPE vbeln_vl,
        delivery_item_number  TYPE posnr_vl,
        freight_unit_number   TYPE /scmtms/tor_id,
        freight_unit_root_key TYPE /bobf/s_frw_key-key,
      END OF ts_tor_data .
  types:
    tt_stop_points TYPE STANDARD TABLE OF ts_stop_points .
  types:
    tt_expeventdata TYPE STANDARD TABLE OF /saptrx/exp_events .
  types:
    tt_tor_data TYPE STANDARD TABLE OF ts_tor_data .
  types:
    BEGIN OF ty_delivery_item,
        delivery_number      TYPE vbeln_vl,
        delivery_item_number TYPE posnr_vl,
        freight_unit_number  TYPE /scmtms/tor_id,
        change_mode          TYPE /bobf/conf_change_mode,
        stop_id_dst          TYPE /scmtms/stop_id,
        log_locid_dst        TYPE /scmtms/location_id,
        country_code_dst     TYPE land1,
        city_name_dst	       TYPE	ad_city1,
        evt_exp_datetime     TYPE /saptrx/event_exp_datetime,
        evt_exp_tzone        TYPE /saptrx/timezone,
      END OF ty_delivery_item .
  types:
    tt_delivery_item TYPE TABLE OF ty_delivery_item .

  constants:
    BEGIN OF cs_milestone,
        fo_load_start    TYPE /saptrx/appl_event_tag VALUE 'LOAD_BEGIN',
        fo_load_end      TYPE /saptrx/appl_event_tag VALUE 'LOAD_END',
        fo_coupling      TYPE /saptrx/appl_event_tag VALUE 'COUPLING',
        fo_decoupling    TYPE /saptrx/appl_event_tag VALUE 'DECOUPLING',
        fo_shp_departure TYPE /saptrx/appl_event_tag VALUE 'DEPARTURE',
        fo_shp_arrival   TYPE /saptrx/appl_event_tag VALUE 'ARRIV_DEST',
        fo_shp_pod       TYPE /saptrx/appl_event_tag VALUE 'POD',
        fo_unload_start  TYPE /saptrx/appl_event_tag VALUE 'UNLOAD_BEGIN',
        fo_unload_end    TYPE /saptrx/appl_event_tag VALUE 'UNLOAD_END',
      END OF cs_milestone .
  constants:
    BEGIN OF cs_location_type,
        logistic TYPE string VALUE 'LogisticLocation',
      END OF cs_location_type .
  class-data GT_DELIVERY_ITEM type TT_DELIVERY_ITEM .

  class-methods GET_INSTANCE
    returning
      value(RO_INSTANCE) type ref to ZCL_GTT_SOF_TOOLKIT .
  methods CONVERSION_ALPHA_INPUT
    importing
      !IV_INPUT type CLIKE
    exporting
      !EV_OUTPUT type CLIKE .
  methods GET_RELATION
    importing
      !IV_VBELN type VBELN_VL
      !IV_POSNR type POSNR_VL optional
    exporting
      !ET_RELATION type TT_TOR_DATA
      !ET_ROOT_KEY type /BOBF/T_FRW_KEY .
  methods CHECK_INTEGRATION_MODE
    importing
      !IV_VSTEL type VSTEL
      !IV_LFART type LFART
      !IV_VSBED type VSBED
    exporting
      !EV_INTERNAL_INT type BOOLE_D .
  class-methods CONVERT_UTC_TIMESTAMP
    importing
      !IV_TIMEZONE type TTZZ-TZONE
    changing
      !CV_TIMESTAMP type TIMESTAMP .
protected section.

  class-data GO_ME type ref to ZCL_GTT_SOF_TOOLKIT .
private section.

  types:
    BEGIN OF ts_likp,
      vbeln TYPE likp-vbeln,
      vstel TYPE likp-vstel,
      lfart TYPE likp-lfart,
      vsbed TYPE likp-vsbed,
    END OF ts_likp .
  types:
    BEGIN OF ts_vbak,
      vbeln TYPE vbak-vbeln,
      vkorg TYPE vbak-vkorg,
      vtweg TYPE vbak-vtweg,
      spart TYPE vbak-spart,
      auart TYPE vbak-auart,
      vsbed TYPE vbak-vsbed,
    END OF ts_vbak .
  types:
    BEGIN OF ts_vbfa,
      vbelv   TYPE vbfa-vbelv,
      posnv   TYPE vbfa-posnv,
      vbeln   TYPE vbfa-vbeln,
      posnn   TYPE vbfa-posnn,
      vbtyp_n TYPE vbfa-vbtyp_n,
    END OF ts_vbfa .
  types:
    BEGIN OF ts_tms_c_shp,
      vstel       TYPE tms_c_shp-vstel,
      lfart       TYPE tms_c_shp-lfart,
      vsbed       TYPE tms_c_shp-vsbed,
      tm_ctrl_key TYPE tms_c_shp-tm_ctrl_key,
    END OF ts_tms_c_shp .
  types:
    BEGIN OF ts_tms_c_sls,
      vkorg       TYPE tms_c_sls-vkorg,
      vtweg       TYPE tms_c_sls-vtweg,
      spart       TYPE tms_c_sls-spart,
      auart       TYPE tms_c_sls-auart,
      vsbed       TYPE tms_c_sls-vsbed,
      tm_ctrl_key TYPE tms_c_sls-tm_ctrl_key,
    END OF ts_tms_c_sls .
  types:
    BEGIN OF ts_tms_c_control,
      tm_ctrl_key   TYPE tms_c_control-tm_ctrl_key,
      sls_to_tm_ind TYPE tms_c_control-sls_to_tm_ind,
      od_to_tm_ind  TYPE tms_c_control-od_to_tm_ind,
    END OF ts_tms_c_control .
ENDCLASS.



CLASS ZCL_GTT_SOF_TOOLKIT IMPLEMENTATION.


  METHOD CHECK_INTEGRATION_MODE.

    DATA:
      ls_tms_c_shp     TYPE tms_s_shp,
      ls_tms_c_control TYPE tms_s_control.

    CLEAR:
      ev_internal_int.

*   Get Integration Relevance SHP
    cl_tms_int_cust=>get_tms_c_shp(
       EXPORTING
         iv_vstel     = iv_vstel
         iv_lfart     = iv_lfart
         iv_vsbed     = iv_vsbed
       IMPORTING
         es_tms_c_shp = ls_tms_c_shp ).

*   Get control from control key
    cl_tms_int_cust=>read_tms_c_control(
      EXPORTING
        iv_tm_ctrl_key   = ls_tms_c_shp-tm_ctrl_key
      IMPORTING
        es_tms_c_control = ls_tms_c_control ).

    IF ls_tms_c_control-sls_to_tm_ind = abap_true OR ls_tms_c_control-od_to_tm_ind  = abap_true .
      ev_internal_int = abap_true.
    ENDIF..

  ENDMETHOD.


  METHOD CONVERSION_ALPHA_INPUT.

    CLEAR:ev_output.

    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
      EXPORTING
        input  = iv_input
      IMPORTING
        output = ev_output.

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


  METHOD GET_INSTANCE.

    IF go_me IS INITIAL.
      CREATE OBJECT go_me.
    ENDIF.
    ro_instance = go_me.

  ENDMETHOD.


  METHOD GET_RELATION.

    DATA:
      lo_srvmgr_tor  TYPE REF TO /bobf/if_tra_service_manager,
      lt_item_tr_key TYPE /bobf/t_frw_key,
      ls_item_tr_key TYPE /bobf/s_frw_key,
      lt_base_doc    TYPE /scmtms/t_base_document_w_item,
      ls_base_doc    TYPE /scmtms/s_base_document_w_item,
      lt_result      TYPE /bobf/t_frw_keyindex,
      ls_result      TYPE /bobf/s_frw_keyindex,
      lv_sys         TYPE tbdls-logsys,
      lt_fu          TYPE /scmtms/t_tor_root_k,
      ls_relation    TYPE ts_tor_data,
      ls_root_key    TYPE /bobf/s_frw_key.

    CLEAR:
      et_relation,
      et_root_key.

    CALL FUNCTION 'OWN_LOGICAL_SYSTEM_GET'
      IMPORTING
        own_logical_system             = lv_sys
      EXCEPTIONS
        own_logical_system_not_defined = 1
        OTHERS                         = 2.

    ls_base_doc-base_btd_logsys = lv_sys.
    ls_base_doc-base_btd_tco = /scmtms/if_common_c=>c_btd_tco-outbounddelivery.

    me->conversion_alpha_input(
      EXPORTING
        iv_input  = iv_vbeln
      IMPORTING
        ev_output = ls_base_doc-base_btd_id ).

    IF iv_posnr IS NOT INITIAL.
      me->conversion_alpha_input(
        EXPORTING
          iv_input  = iv_posnr
        IMPORTING
          ev_output = ls_base_doc-base_btditem_id ).
    ENDIF.

    APPEND ls_base_doc TO lt_base_doc.

***********************************************************************
** get instance service manager for BO /SCMTMS/TOR                    *
***********************************************************************
*   instance servicemanger for BO
    lo_srvmgr_tor = /bobf/cl_tra_serv_mgr_factory=>get_service_manager( iv_bo_key = /scmtms/if_tor_c=>sc_bo_key ).

***********************************************************************
**  Converts an alternative key to the technical key                  *
***********************************************************************
    lo_srvmgr_tor->convert_altern_key(
      EXPORTING
        iv_node_key          = /scmtms/if_tor_c=>sc_node-item_tr
        iv_altkey_key        = /scmtms/if_tor_c=>sc_alternative_key-item_tr-base_document
        it_key               = lt_base_doc
      IMPORTING
        et_result            = lt_result ).  " Key table with explicit index

***********************************************************************
**  FU Root Assocation                                                *
***********************************************************************
    LOOP AT lt_result INTO ls_result.
      ls_item_tr_key-key = ls_result-key.
      APPEND ls_item_tr_key TO lt_item_tr_key.
      CLEAR ls_item_tr_key.
    ENDLOOP.

    lo_srvmgr_tor->retrieve_by_association(
      EXPORTING
        iv_node_key    = /scmtms/if_tor_c=>sc_node-item_tr
        it_key         = lt_item_tr_key
        iv_association = /scmtms/if_tor_c=>sc_association-item_tr-fu_root
        iv_fill_data   = abap_true
      IMPORTING
        et_data        = lt_fu ).

    LOOP AT lt_fu INTO DATA(ls_fu) WHERE tor_cat   =  /scmtms/if_tor_const=>sc_tor_category-freight_unit
                                     AND lifecycle <> /scmtms/if_tor_status_c=>sc_root-lifecycle-v_canceled.
      ls_relation-delivery_number = iv_vbeln.
      ls_relation-delivery_item_number = iv_posnr.
      ls_relation-freight_unit_number = ls_fu-tor_id.
      ls_relation-freight_unit_root_key = ls_fu-root_key.
      APPEND ls_relation TO et_relation.
      CLEAR ls_relation.

      ls_root_key-key = ls_fu-root_key.
      APPEND ls_root_key TO et_root_key.
      CLEAR ls_root_key.
    ENDLOOP.

  ENDMETHOD.
ENDCLASS.
