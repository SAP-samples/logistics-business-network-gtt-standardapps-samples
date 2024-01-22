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
      !IV_VBTYP type VBTYPL
    exporting
      !ET_RELATION type TT_TOR_DATA
      !ET_ROOT_KEY type /BOBF/T_FRW_KEY
      !ET_FU_ITEM type /SCMTMS/T_TOR_ITEM_TR_K .
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
  class-methods CONVERT_UNIT_OUTPUT
    importing
      !IV_INPUT type CLIKE
    returning
      value(RV_OUTPUT) type MSEH3 .
  class-methods GET_DELIVERY_TYPE
    returning
      value(RT_TYPE) type RSELOPTION .
  class-methods GET_SO_TYPE
    returning
      value(RT_TYPE) type RSELOPTION .
  class-methods CHECK_LOCATION_ADDRESS
    importing
      !IT_VBPA type VBPAVB_TAB
      !IV_VBELN type VBELN_VA
      !IV_HEADER_CHK type BOOLE_D default 'X'
    exporting
      !EV_RELEVANCE type BOOLE_D .
  class-methods GET_FU_FROM_DB
    importing
      !IT_TOR_ID type /SCMTMS/T_TOR_ID
    exporting
      !ET_FU type /SCMTMS/T_TOR_ROOT_K .
  class-methods ADD_PLANNED_SOURCE_ARRIVAL
    importing
      !IS_EXPEVENTDATA type /SAPTRX/EXP_EVENTS
      !IT_VTTK type VTTKVB_TAB optional
      !IT_VTTP type VTTPVB_TAB optional
      !IV_SEQ_NUM type /SAPTRX/SEQ_NUM optional
    exporting
      !ES_EVENTDATA type /SAPTRX/EXP_EVENTS
    raising
      CX_UDM_MESSAGE .
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


  METHOD get_relation.

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
      ls_root_key    TYPE /bobf/s_frw_key,
      lt_fu_item     TYPE /scmtms/t_tor_item_tr_k.

    CLEAR:
      et_relation,
      et_root_key,
      et_fu_item.

    CALL FUNCTION 'OWN_LOGICAL_SYSTEM_GET'
      IMPORTING
        own_logical_system             = lv_sys
      EXCEPTIONS
        own_logical_system_not_defined = 1
        OTHERS                         = 2.

    ls_base_doc-base_btd_logsys = lv_sys.

*   Type Code
    CALL METHOD /scmtms/cl_logint_cmn_reuse=>get_tco_for_doc
      EXPORTING
        iv_vbtyp   = iv_vbtyp
      IMPORTING
        ev_btd_tco = ls_base_doc-base_btd_tco.

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
        iv_node_key   = /scmtms/if_tor_c=>sc_node-item_tr
        iv_altkey_key = /scmtms/if_tor_c=>sc_alternative_key-item_tr-base_document
        it_key        = lt_base_doc
      IMPORTING
        et_result     = lt_result ).  " Key table with explicit index

    IF lt_result IS INITIAL.
      RETURN.
    ENDIF.

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

    LOOP AT lt_fu INTO DATA(ls_fu).
      IF ls_fu-tor_cat   =  /scmtms/if_tor_const=>sc_tor_category-freight_unit
        AND ls_fu-lifecycle <> /scmtms/if_tor_status_c=>sc_root-lifecycle-v_canceled.
        ls_relation-delivery_number = iv_vbeln.
        ls_relation-delivery_item_number = iv_posnr.
        ls_relation-freight_unit_number = ls_fu-tor_id.
        ls_relation-freight_unit_root_key = ls_fu-root_key.
        APPEND ls_relation TO et_relation.
        CLEAR ls_relation.

        ls_root_key-key = ls_fu-root_key.
        APPEND ls_root_key TO et_root_key.
        CLEAR ls_root_key.
      ENDIF.
    ENDLOOP.

    IF et_fu_item IS REQUESTED.

      lo_srvmgr_tor->retrieve(
        EXPORTING
          iv_node_key  = /scmtms/if_tor_c=>sc_node-item_tr
          it_key       = lt_item_tr_key
          iv_fill_data = abap_true
        IMPORTING
          et_data      = lt_fu_item ).

      LOOP AT lt_fu_item INTO DATA(ls_fu_item) WHERE item_cat = /scmtms/if_tor_const=>sc_tor_item_category-product.
        READ TABLE et_root_key INTO ls_root_key WITH TABLE KEY key_sort COMPONENTS key = ls_fu_item-root_key.
        IF sy-subrc = 0.
          APPEND ls_fu_item TO et_fu_item.
        ENDIF.
      ENDLOOP.
    ENDIF.

  ENDMETHOD.


  METHOD convert_unit_output.

    CLEAR:rv_output.

    CALL FUNCTION 'CONVERSION_EXIT_CUNIT_OUTPUT'
      EXPORTING
        input    = iv_input
        language = sy-langu
      IMPORTING
        output   = rv_output.

    CONDENSE rv_output NO-GAPS.

  ENDMETHOD.


  METHOD get_delivery_type.

    DATA:
      lt_dlvtype TYPE TABLE OF zgtt_dlvtype_rst,
      rs_type    TYPE rsdsselopt.

    CLEAR rt_type.

    SELECT *
      INTO TABLE lt_dlvtype
      FROM zgtt_dlvtype_rst
     WHERE active = abap_true.

    LOOP AT lt_dlvtype INTO DATA(ls_dlvtype).
      rs_type-sign = 'I'.
      rs_type-option = 'EQ'.
      rs_type-low = ls_dlvtype-lfart.
      APPEND rs_type TO rt_type.
      CLEAR rs_type.
    ENDLOOP.

  ENDMETHOD.


  METHOD get_so_type.

    DATA:
      lt_sotype TYPE TABLE OF zgtt_sotype_rst,
      rs_type   TYPE rsdsselopt.

    CLEAR rt_type.

    SELECT *
      INTO TABLE lt_sotype
      FROM zgtt_sotype_rst
     WHERE active = abap_true.

    LOOP AT lt_sotype INTO DATA(ls_sotype).
      rs_type-sign = 'I'.
      rs_type-option = 'EQ'.
      rs_type-low = ls_sotype-auart.
      APPEND rs_type TO rt_type.
      CLEAR rs_type.
    ENDLOOP.

  ENDMETHOD.


  METHOD check_location_address.

    DATA:
      ls_loc_addr_old  TYPE addr1_data,
      lv_loc_email_old TYPE ad_smtpadr,
      lv_loc_tel_old   TYPE char50,
      ls_loc_addr_new  TYPE addr1_data,
      lv_loc_email_new TYPE ad_smtpadr,
      lv_loc_tel_new   TYPE char50,
      ls_vbpa          TYPE vbpavb,
      lt_vbpa          TYPE vbpavb_tab.

    CLEAR ev_relevance.

    IF iv_header_chk = abap_true.
      LOOP AT it_vbpa INTO ls_vbpa
        WHERE vbeln = iv_vbeln
          AND posnr IS INITIAL
          AND ( parvw = if_sd_partner=>co_partner_function_code-ship_to_party
           OR  parvw = if_sd_partner=>co_partner_function_code-sold_to_party ).
        APPEND ls_vbpa TO lt_vbpa.
        CLEAR ls_vbpa.
      ENDLOOP.
    ELSE.
      LOOP AT it_vbpa INTO ls_vbpa
        WHERE vbeln = iv_vbeln
          AND posnr IS INITIAL
          AND parvw = if_sd_partner=>co_partner_function_code-ship_to_party.
        APPEND ls_vbpa TO lt_vbpa.
        CLEAR ls_vbpa.
      ENDLOOP.
    ENDIF.

    LOOP AT lt_vbpa INTO ls_vbpa.

      IF ls_vbpa-adrnr CN '0 ' AND ls_vbpa-adrda CA zif_gtt_ef_constants=>vbpa_addr_ind_man_all.

        zcl_gtt_tools=>get_address_from_db(
          EXPORTING
            iv_addrnumber = ls_vbpa-adrnr
          IMPORTING
            es_addr       = ls_loc_addr_old
            ev_email      = lv_loc_email_old
            ev_telephone  = lv_loc_tel_old ).

        zcl_gtt_tools=>get_address_from_memory(
          EXPORTING
            iv_addrnumber = ls_vbpa-adrnr
          IMPORTING
            es_addr       = ls_loc_addr_new
            ev_email      = lv_loc_email_new
            ev_telephone  = lv_loc_tel_new ).

        IF ( ls_loc_addr_old <> ls_loc_addr_new )
          OR ( lv_loc_email_old <> lv_loc_email_new )
          OR ( lv_loc_tel_old <> lv_loc_tel_new ).
          ev_relevance = abap_true.
          EXIT.
        ENDIF.
      ENDIF.

      CLEAR:
        ls_loc_addr_old,
        lv_loc_email_old,
        lv_loc_tel_old,
        ls_loc_addr_new,
        lv_loc_email_new,
        lv_loc_tel_new,
        ls_vbpa.
    ENDLOOP.

  ENDMETHOD.


  METHOD get_fu_from_db.

    DATA:
      lo_srvmgr_tor           TYPE REF TO /bobf/if_tra_service_manager,
      lt_selection_parameters TYPE /bobf/t_frw_query_selparam,
      ls_selection_parameters TYPE /bobf/s_frw_query_selparam,
      ls_query_options        TYPE /bobf/s_frw_query_options.

    CLEAR et_fu.

    lo_srvmgr_tor = /bobf/cl_tra_serv_mgr_factory=>get_service_manager( iv_bo_key = /scmtms/if_tor_c=>sc_bo_key ).

    LOOP AT it_tor_id INTO DATA(ls_tor_id).
      ls_selection_parameters-attribute_name =  /scmtms/if_tor_c=>sc_query_attribute-root-root_elements-tor_id.
      ls_selection_parameters-sign = /bobf/if_conf_c=>sc_sign_option_including.
      ls_selection_parameters-option = /bobf/if_conf_c=>sc_sign_equal.
      ls_selection_parameters-low = ls_tor_id.
      APPEND ls_selection_parameters TO lt_selection_parameters.
      CLEAR ls_selection_parameters.
    ENDLOOP.

    ls_query_options-maximum_rows = 1000.

    TRY.
        lo_srvmgr_tor->query(
          EXPORTING
            iv_query_key            = /scmtms/if_tor_c=>sc_query-root-root_elements
            it_selection_parameters = lt_selection_parameters
            is_query_options        = ls_query_options
            iv_fill_data            = abap_true
          IMPORTING
            et_data                 = et_fu ).

      CATCH /bobf/cx_frw_contrct_violation. " Caller violates a BOPF contract
    ENDTRY.

  ENDMETHOD.


  METHOD add_planned_source_arrival.

    DATA:
      lv_length       TYPE i,
      lv_seq          TYPE char04,
      lv_tknum        TYPE vttk-tknum,
      lv_ltl_flag     TYPE flag,
      ls_vttk         TYPE vttkvb,
      lv_exp_datetime TYPE /saptrx/event_exp_datetime.

    CLEAR es_eventdata.

    lv_length = strlen( is_expeventdata-locid2 ) - 4.
    IF lv_length >= 0.
      lv_tknum = is_expeventdata-locid2+0(lv_length).
      lv_tknum = |{ lv_tknum ALPHA = IN }|.
      lv_seq = is_expeventdata-locid2+lv_length(4).
      zcl_gtt_tools=>check_ltl_shipment(
        EXPORTING
          iv_tknum    = lv_tknum
          it_vttk     = it_vttk
          it_vttp     = it_vttp
        IMPORTING
          ev_ltl_flag = lv_ltl_flag
          es_vttk     = ls_vttk ).

      IF lv_ltl_flag = abap_true AND lv_seq = '0001'. "only for source location of the shipment
        lv_exp_datetime = zcl_gtt_tools=>get_local_timestamp(
          iv_date = ls_vttk-dpreg     "Planned date of check-in
          iv_time = ls_vttk-upreg ).  "Planned check-in time

        es_eventdata = is_expeventdata.
        IF iv_seq_num IS NOT INITIAL.
          es_eventdata-milestonenum = iv_seq_num.
        ELSE.
          es_eventdata-milestonenum = 0.
        ENDIF.
        es_eventdata-milestone = zif_gtt_ef_constants=>cs_milestone-sh_arrival.
        es_eventdata-evt_exp_datetime = lv_exp_datetime.
        es_eventdata-evt_exp_tzone = zcl_gtt_tools=>get_system_time_zone( ).

      ENDIF.
    ENDIF.

  ENDMETHOD.
ENDCLASS.
