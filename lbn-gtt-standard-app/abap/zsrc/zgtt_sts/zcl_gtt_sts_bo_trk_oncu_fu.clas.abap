class ZCL_GTT_STS_BO_TRK_ONCU_FU definition
  public
  inheriting from ZCL_GTT_STS_BO_TOR_READER
  create public .

public section.

  types:
    BEGIN OF ts_freight_unit,
        tor_id                TYPE /scmtms/s_em_bo_tor_root-tor_id,
        shipping_type         TYPE /scmtms/s_em_bo_tor_root-shipping_type,
        inc_class_code        TYPE /scmtms/s_em_bo_tor_item-inc_class_code,
        inc_transf_loc_n      TYPE /scmtms/s_em_bo_tor_item-inc_transf_loc_n,
        trmodcod              TYPE /scmtms/s_em_bo_tor_root-trmodcod,
        total_distance_km     TYPE /scmtms/total_distance_km,
        total_distance_km_uom TYPE meins,
        pln_grs_duration      TYPE /scmtms/total_duration_net,
        total_duration_net    TYPE /scmtms/total_duration_net,
        dgo_indicator         TYPE /scmtms/s_em_bo_tor_root-dgo_indicator,
        pln_arr_loc_id        TYPE /scmtms/s_em_bo_tor_stop-log_locid,
        pln_arr_loc_type      TYPE /saptrx/loc_id_type,
        pln_arr_timest        TYPE char16,
        pln_arr_timezone      TYPE timezone,
        pln_dep_loc_id        TYPE /scmtms/s_em_bo_tor_stop-log_locid,
        pln_dep_loc_type      TYPE /saptrx/loc_id_type,
        pln_dep_timest        TYPE char16,
        pln_dep_timezone      TYPE timezone,
        tspid                 TYPE bu_id_number,
        carrier_ref_value     TYPE tt_carrier_ref_value,
        carrier_ref_type      TYPE tt_carrier_ref_type,
        shipper_ref_value     TYPE tt_shipper_ref_value,
        shipper_ref_type      TYPE tt_shipper_ref_type,
        stop_id               TYPE tt_stop_id,
        ordinal_no            TYPE tt_ordinal_no,
        loc_type              TYPE tt_loc_type,
        loc_id                TYPE tt_loc_id,
        item_id               TYPE STANDARD TABLE OF /scmtms/item_id              WITH EMPTY KEY,
        erp_dlv_id            TYPE STANDARD TABLE OF /scmtms/erp_shpm_dlv_id      WITH EMPTY KEY,
        erp_dlv_item_id       TYPE STANDARD TABLE OF /scmtms/erp_shpm_dlv_item_id WITH EMPTY KEY,
        itm_qua_pcs_val	      TYPE STANDARD TABLE OF /scmtms/qua_pcs_val          WITH EMPTY KEY,
        itm_qua_pcs_uni	      TYPE STANDARD TABLE OF /scmtms/qua_pcs_uni          WITH EMPTY KEY,
        product_id            TYPE STANDARD TABLE OF /scmtms/product_id           WITH EMPTY KEY,
        product_txt           TYPE STANDARD TABLE OF /scmtms/item_description     WITH EMPTY KEY,
        dlv_item_inb_alt_id   TYPE STANDARD TABLE OF char16                       WITH EMPTY KEY,
        dlv_item_oub_alt_id   TYPE STANDARD TABLE OF char16                       WITH EMPTY KEY,
        capa_doc_line_no      TYPE tt_capacity_doc_line_number,
        capa_doc_no           TYPE tt_capacity_doc_number,
        capa_doc_first_stop   TYPE tt_stop,
        capa_doc_last_stop    TYPE tt_stop,
        tu_line_no            TYPE tt_tu_line_no,
        tu_type               TYPE tt_tu_type,
        tu_value              TYPE tt_tu_value,
        tu_number             TYPE tt_tu_number,
        tu_first_stop         TYPE tt_tu_first_stop,
        tu_last_stop          TYPE tt_tu_last_stop,
      END OF ts_freight_unit .
  types:
    BEGIN OF ts_tu_info,
        tor_id    type /scmtms/s_em_bo_tor_root-tor_id,
        tu_type   TYPE char20,
        tu_value  TYPE char255,
        tu_number TYPE char255,
      END OF ts_tu_info .
  types:
    tt_tu_info TYPE TABLE OF ts_tu_info .

  constants CS_BASE_BTD_TCO_INB_DLV type /SCMTMS/BASE_BTD_TCO value '58' ##NO_TEXT.
  constants CS_BASE_BTD_TCO_OUTB_DLV type /SCMTMS/BASE_BTD_TCO value '73' ##NO_TEXT.
  constants CS_BASE_BTD_TCO_DELIVERY_ITEM type /SCMTMS/BASE_BTD_ITEM_TCO value '14' ##NO_TEXT.

  methods GET_DATA_FROM_MAINTAB
    importing
      !IR_MAINTAB type ref to DATA
      !IV_OLD_DATA type ABAP_BOOL default ABAP_FALSE
    changing
      !CS_FREIGHT_UNIT type TS_FREIGHT_UNIT
    raising
      CX_UDM_MESSAGE .
  methods GET_MAINTABREF
    importing
      !IS_APP_OBJECT type TRXAS_APPOBJ_CTAB_WA
    returning
      value(RR_MAINTABREF) type ref to DATA .
  methods GET_DATA_FROM_ITEM
    importing
      !IR_DATA type ref to DATA
      !IV_OLD_DATA type ABAP_BOOL default ABAP_FALSE
    changing
      !CS_FREIGHT_UNIT type TS_FREIGHT_UNIT
    raising
      CX_UDM_MESSAGE .
  methods GET_CAPACITY_DOC_LIST
    importing
      !IR_DATA type ref to DATA
      !IV_OLD_DATA type ABAP_BOOL default ABAP_FALSE
    changing
      !CT_CAPA_DOC_LINE_NO type TT_CAPACITY_DOC_LINE_NUMBER
      !CT_CAPA_DOC_NO type TT_CAPACITY_DOC_NUMBER
    raising
      CX_UDM_MESSAGE .
  methods CHECK_CU_ROUTE_CHANGE
    importing
      !IS_APP_OBJECT type TRXAS_APPOBJ_CTAB_WA
    returning
      value(RV_RESULT) type ZIF_GTT_STS_EF_TYPES=>TV_CONDITION
    raising
      CX_UDM_MESSAGE .
  methods GET_TRACKING_UNIT
    importing
      !IR_DATA type ref to DATA
      !IV_OLD_DATA type ABAP_BOOL default ABAP_FALSE
    changing
      !CS_FREIGHT_UNIT type TS_FREIGHT_UNIT
    raising
      CX_UDM_MESSAGE .

  methods ZIF_GTT_STS_BO_READER~CHECK_RELEVANCE
    redefinition .
  methods ZIF_GTT_STS_BO_READER~GET_DATA
    redefinition .
  methods ZIF_GTT_STS_BO_READER~GET_TRACK_ID_DATA
    redefinition .
PROTECTED SECTION.

  METHODS check_non_idoc_fields
      REDEFINITION .
  METHODS check_non_idoc_stop_fields
      REDEFINITION .
private section.

  methods FO_RELEVANCE_CHECK
    importing
      !IR_FO_ROOT type ref to DATA
    returning
      value(RV_RESULT) type ZIF_GTT_STS_EF_TYPES=>TV_CONDITION
    raising
      CX_UDM_MESSAGE .
  methods GET_CAPACITY_FO_INFO
    importing
      !IR_DATA type ref to DATA
      !IV_OLD_DATA type ABAP_BOOL default ABAP_FALSE
    exporting
      !ET_CAPA_INFO type /SCMTMS/T_EM_BO_TOR_ROOT
    raising
      CX_UDM_MESSAGE .
ENDCLASS.



CLASS ZCL_GTT_STS_BO_TRK_ONCU_FU IMPLEMENTATION.


  METHOD CHECK_CU_ROUTE_CHANGE.

    FIELD-SYMBOLS <ls_header> TYPE /scmtms/s_em_bo_tor_root.

    DATA:
      lv_stage_num_difference    TYPE i,
      lv_stage_num_difference_bi TYPE i.

    rv_result = zif_gtt_sts_ef_constants=>cs_condition-false.

    ASSIGN is_app_object-maintabref->* TO <ls_header>.
    IF sy-subrc <> 0.
      RETURN.
    ENDIF.

    DATA(lo_tor_srv_mgr) = /bobf/cl_tra_serv_mgr_factory=>get_service_manager( iv_bo_key = /scmtms/if_tor_c=>sc_bo_key ).
    lo_tor_srv_mgr->retrieve_by_association(
      EXPORTING
        iv_node_key    = /scmtms/if_tor_c=>sc_node-root
        it_key         = VALUE #( ( key = <ls_header>-node_id ) )
        iv_association = /scmtms/if_tor_c=>sc_association-root-capa_tor
      IMPORTING
        et_target_key  = DATA(lt_tor_capa_key) ).

    /scmtms/cl_tor_helper_stage=>get_stage(
      EXPORTING
        it_root_key = VALUE #( ( key = <ls_header>-node_id ) )
      IMPORTING
        et_stage    = DATA(lt_req_stage) ).

    /scmtms/cl_tor_helper_stage=>get_stage(
      EXPORTING
        it_root_key = lt_tor_capa_key
      IMPORTING
        et_stage    = DATA(lt_capa_stage) ).

    /scmtms/cl_tor_helper_stage=>get_stage(
      EXPORTING
        it_root_key     = lt_tor_capa_key
        iv_before_image = abap_true
      IMPORTING
        et_stage        = DATA(lt_capa_stage_bi) ).

    DATA(lv_req_stage_count) = lines( lt_req_stage ).
    DATA(lv_stop_des_key) = lt_req_stage[ lv_req_stage_count ]-dest_stop-assgn_stop_key.
    DATA(lv_stop_src_key) = lt_req_stage[ 1 ]-source_stop-assgn_stop_key.

    DO 1 TIMES.

      ASSIGN lt_capa_stage[ source_stop_key = lv_stop_src_key ]-seq_num TO FIELD-SYMBOL(<lv_capa_stage_first_num>).
      CHECK sy-subrc = 0.

      ASSIGN lt_capa_stage[ dest_stop_key = lv_stop_des_key ]-seq_num TO FIELD-SYMBOL(<lv_capa_stage_last_num>).
      CHECK sy-subrc = 0.

      lv_stage_num_difference = <lv_capa_stage_last_num> - <lv_capa_stage_first_num>.

      ASSIGN lt_capa_stage_bi[ source_stop_key = lv_stop_src_key ]-seq_num TO FIELD-SYMBOL(<lv_capa_stage_first_num_bi>).
      CHECK sy-subrc = 0.

      ASSIGN lt_capa_stage_bi[ dest_stop_key = lv_stop_des_key ]-seq_num TO FIELD-SYMBOL(<lv_capa_stage_last_num_bi>).
      CHECK sy-subrc = 0.

      lv_stage_num_difference_bi = <lv_capa_stage_last_num_bi> - <lv_capa_stage_first_num_bi>.

    ENDDO.

    IF lv_stage_num_difference <> lv_stage_num_difference_bi.
      rv_result = zif_gtt_sts_ef_constants=>cs_condition-true.
    ENDIF.

  ENDMETHOD.


  METHOD check_non_idoc_fields.

    rv_result = check_non_idoc_stop_fields( is_app_object = is_app_object ).
    IF rv_result = zif_gtt_sts_ef_constants=>cs_condition-true.
      RETURN.
    ENDIF.

    rv_result = check_cu_route_change( is_app_object = is_app_object ).
    IF rv_result = zif_gtt_sts_ef_constants=>cs_condition-true.
      RETURN.
    ENDIF.

  ENDMETHOD.


  METHOD CHECK_NON_IDOC_STOP_FIELDS.

    DATA lt_capa_stop_old TYPE /scmtms/t_tor_stop_k.

    FIELD-SYMBOLS:
      <lt_stop_new>      TYPE /scmtms/t_em_bo_tor_stop,
      <lt_stop_old>      TYPE /scmtms/t_em_bo_tor_stop,
      <lt_capa_stop_new> TYPE /scmtms/t_em_bo_tor_stop,
      <ls_header>        TYPE /scmtms/s_em_bo_tor_root.

    rv_result = zif_gtt_sts_ef_constants=>cs_condition-false.

    DATA(lt_stop_new) = mo_ef_parameters->get_appl_table(
                            iv_tabledef = zif_gtt_sts_constants=>cs_tabledef-fo_stop_new ).
    DATA(lt_stop_old) = mo_ef_parameters->get_appl_table(
                            iv_tabledef = zif_gtt_sts_constants=>cs_tabledef-fo_stop_old ).
    DATA(lt_capa_stop_new) = mo_ef_parameters->get_appl_table(
                               /scmtms/cl_scem_int_c=>sc_table_definition-bo_tor-capa_stop ).

    ASSIGN lt_stop_new->* TO <lt_stop_new>.
    ASSIGN lt_stop_old->* TO <lt_stop_old>.
    ASSIGN lt_capa_stop_new->* TO <lt_capa_stop_new>.
    ASSIGN is_app_object-maintabref->* TO <ls_header>.
    IF <lt_stop_new>      IS NOT ASSIGNED OR <lt_stop_old> IS NOT ASSIGNED OR
       <lt_capa_stop_new> IS NOT ASSIGNED OR <ls_header> IS NOT ASSIGNED.
      MESSAGE e010(zgtt_sts) INTO DATA(lv_dummy) ##needed.
      zcl_gtt_sts_tools=>throw_exception( ).
    ENDIF.

    DATA(lo_tor_srv_mgr) = /bobf/cl_tra_serv_mgr_factory=>get_service_manager( iv_bo_key = /scmtms/if_tor_c=>sc_bo_key ).
    DATA(lt_capa_stop_key) = VALUE /bobf/t_frw_key( FOR <ls_stop> IN <lt_stop_new> ( key = <ls_stop>-assgn_stop_key ) ).
    TEST-SEAM lt_capa_stop_old.
      lo_tor_srv_mgr->retrieve(
        EXPORTING
          iv_node_key     = /scmtms/if_tor_c=>sc_node-stop
          it_key          = lt_capa_stop_key
          iv_before_image = abap_true
        IMPORTING
          et_data         = lt_capa_stop_old ).
    END-TEST-SEAM.

    LOOP AT <lt_stop_new> ASSIGNING FIELD-SYMBOL(<ls_stop_new>)
      USING KEY parent_seqnum WHERE parent_node_id = <ls_header>-node_id.

      ASSIGN <lt_stop_old>[ node_id = <ls_stop_new>-node_id ] TO FIELD-SYMBOL(<ls_stop_old>).
      CHECK sy-subrc = 0.

      IF <ls_stop_new>-assgn_start <> <ls_stop_old>-assgn_start OR
         <ls_stop_new>-assgn_end   <> <ls_stop_old>-assgn_end.
        rv_result = zif_gtt_sts_ef_constants=>cs_condition-true.
        EXIT.
      ENDIF.

      ASSIGN <lt_capa_stop_new>[ node_id = <ls_stop_new>-assgn_stop_key ] TO FIELD-SYMBOL(<ls_capa_stop_new>).
      CHECK sy-subrc = 0.

      ASSIGN lt_capa_stop_old[ key = <ls_stop_new>-assgn_stop_key ] TO FIELD-SYMBOL(<ls_capa_stop_old>).
      CHECK sy-subrc = 0.

      IF <ls_capa_stop_new>-plan_trans_time <> <ls_capa_stop_old>-plan_trans_time.
        rv_result = zif_gtt_sts_ef_constants=>cs_condition-true.
        EXIT.
      ENDIF.

    ENDLOOP.

  ENDMETHOD.


  METHOD FO_RELEVANCE_CHECK.

    FIELD-SYMBOLS <ls_root> TYPE /scmtms/s_em_bo_tor_root.

    rv_result = zif_gtt_sts_ef_constants=>cs_condition-false.

    ASSIGN ir_fo_root->* TO <ls_root>.
    IF sy-subrc <> 0.
      MESSAGE e010(zgtt_sts) INTO DATA(lv_dummy) ##needed.
      zcl_gtt_sts_tools=>throw_exception( ).
    ENDIF.

    IF <ls_root>-tsp IS INITIAL.
      DATA(lv_carrier_removed) = abap_true.
    ENDIF.

    IF ( <ls_root>-execution = /scmtms/if_tor_status_c=>sc_root-execution-v_not_relevant         OR
         <ls_root>-execution = /scmtms/if_tor_status_c=>sc_root-execution-v_not_started          OR
         <ls_root>-execution = /scmtms/if_tor_status_c=>sc_root-execution-v_cancelled            OR
         <ls_root>-execution = /scmtms/if_tor_status_c=>sc_root-execution-v_not_ready_for_execution ) .

      DATA(lv_execution_status_changed) = abap_true.
    ENDIF.

    IF ( <ls_root>-lifecycle <> /scmtms/if_tor_status_c=>sc_root-lifecycle-v_in_process AND
        <ls_root>-lifecycle <> /scmtms/if_tor_status_c=>sc_root-lifecycle-v_completed ) .
      DATA(lv_lifecycle_status_changed) = abap_true.
    ENDIF.

    IF lv_carrier_removed = abap_true OR lv_execution_status_changed = abap_true OR
       lv_lifecycle_status_changed = abap_true .
      rv_result = zif_gtt_sts_ef_constants=>cs_condition-true.
    ENDIF.

  ENDMETHOD.


  METHOD get_capacity_doc_list.

    DATA:
      lv_capa_doc_line_no TYPE int4,
      lt_capa             TYPE /scmtms/t_em_bo_tor_root.

    get_capacity_fo_info(
      EXPORTING
        ir_data      = ir_data
        iv_old_data  = iv_old_data
      IMPORTING
        et_capa_info = lt_capa ).

    LOOP AT lt_capa INTO DATA(ls_capa).
      lv_capa_doc_line_no += 1.
      APPEND lv_capa_doc_line_no TO ct_capa_doc_line_no.
      APPEND |{ ls_capa-tor_id ALPHA = OUT }| TO ct_capa_doc_no.
    ENDLOOP.

  ENDMETHOD.


  METHOD get_capacity_fo_info.

    FIELD-SYMBOLS:
      <ls_tor_root>      TYPE /scmtms/s_em_bo_tor_root.

    DATA:
      lt_capa             TYPE /scmtms/t_tor_root_k.

    CLEAR et_capa_info.

    DATA(lo_tor_srv_mgr) = /bobf/cl_tra_serv_mgr_factory=>get_service_manager( iv_bo_key = /scmtms/if_tor_c=>sc_bo_key ).

    ASSIGN ir_data->* TO <ls_tor_root>.
    IF sy-subrc <> 0.
      MESSAGE e010(zgtt_sts) INTO DATA(lv_dummy) ##needed.
      zcl_gtt_sts_tools=>throw_exception( ).
    ENDIF.

    lo_tor_srv_mgr->retrieve_by_association(
      EXPORTING
        iv_node_key     = /scmtms/if_tor_c=>sc_node-root
        it_key          = VALUE #( ( key = <ls_tor_root>-node_id ) )
        iv_association  = /scmtms/if_tor_c=>sc_association-root-capa_tor
        iv_before_image = iv_old_data
      IMPORTING
        et_key_link     = DATA(lt_req2capa_link) ).

    lo_tor_srv_mgr->retrieve_by_association(
      EXPORTING
        iv_node_key     = /scmtms/if_tor_c=>sc_node-root
        it_key          = CORRESPONDING #( lt_req2capa_link MAPPING key = target_key )
        iv_association  = /scmtms/if_tor_c=>sc_association-root-capa_tor
        iv_fill_data    = abap_true
        iv_before_image = iv_old_data
      IMPORTING
        et_data         = lt_capa ).

    et_capa_info = CORRESPONDING #( lt_capa MAPPING node_id = key tor_root_node = root_key ).

  ENDMETHOD.


  METHOD GET_DATA_FROM_ITEM.

    DATA:
      lv_item_id              TYPE char6,
      lv_product_id           TYPE /scmtms/product_id,
      lv_base_btd_id_conv     TYPE char10,
      lv_base_btditem_id_conv TYPE char6,
      lv_base_btd_alt_item_id TYPE char16.

    FIELD-SYMBOLS:
      <lt_tor_item> TYPE /scmtms/t_em_bo_tor_item,
      <ls_tor_root> TYPE /scmtms/s_em_bo_tor_root.

    ASSIGN ir_data->* TO <ls_tor_root>.
    IF sy-subrc <> 0.
      MESSAGE e010(zgtt_sts) INTO DATA(lv_dummy) ##needed.
      zcl_gtt_sts_tools=>throw_exception( ).
    ENDIF.

    DATA(lr_item) = mo_ef_parameters->get_appl_table(
                        SWITCH #( iv_old_data WHEN abap_true THEN zif_gtt_sts_constants=>cs_tabledef-fo_item_old
                                              ELSE zif_gtt_sts_constants=>cs_tabledef-fo_item_new ) ).
    ASSIGN lr_item->* TO <lt_tor_item>.
    IF sy-subrc <> 0.
      MESSAGE e010(zgtt_sts) INTO lv_dummy.
      zcl_gtt_sts_tools=>throw_exception( ).
    ENDIF.

    " POC
    DATA(lv_item_cat) = SWITCH /scmtms/item_category( <ls_tor_root>-tor_cat
                          WHEN 'FU' THEN /scmtms/if_tor_const=>sc_tor_item_category-fu_root
                          WHEN 'TU' THEN /scmtms/if_tor_const=>sc_tor_item_category-tu_resource ).

    ASSIGN <lt_tor_item>[ item_cat       = lv_item_cat
                          parent_node_id = <ls_tor_root>-node_id ] TO FIELD-SYMBOL(<ls_fu_item>).
    IF sy-subrc <> 0.
      MESSAGE e010(zgtt_sts) INTO lv_dummy.
      zcl_gtt_sts_tools=>throw_exception( ).
    ENDIF.

    cs_freight_unit-inc_class_code   = <ls_fu_item>-inc_class_code.
    cs_freight_unit-inc_transf_loc_n = <ls_fu_item>-inc_transf_loc_n.

    SORT <lt_tor_item> BY item_id.

    LOOP AT <lt_tor_item> ASSIGNING FIELD-SYMBOL(<ls_tor_item>) USING KEY parent_node_track_rel
      WHERE parent_node_id = <ls_tor_root>-node_id
        AND item_cat = /scmtms/if_tor_const=>sc_tor_item_category-product
        AND change_mode <> /bobf/if_frw_c=>sc_modify_delete.

      lv_item_id = <ls_tor_item>-item_id+4(6).
      APPEND lv_item_id TO cs_freight_unit-item_id.

      IF <ls_tor_item>-base_btd_tco = cs_base_btd_tco_inb_dlv OR
         <ls_tor_item>-base_btd_tco = cs_base_btd_tco_outb_dlv.
        DATA(lv_base_btd_id) = <ls_tor_item>-base_btd_id.
        SHIFT lv_base_btd_id LEFT DELETING LEADING '0'.
        APPEND lv_base_btd_id TO cs_freight_unit-erp_dlv_id.
      ELSE.
        APPEND '' TO cs_freight_unit-erp_dlv_id.
      ENDIF.

      IF  <ls_tor_item>-base_btditem_tco = cs_base_btd_tco_delivery_item.
        DATA(lv_base_btditem_id) = <ls_tor_item>-base_btditem_id.
        SHIFT lv_base_btditem_id LEFT DELETING LEADING '0'.
        lv_base_btditem_id_conv = lv_base_btditem_id.
        CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
          EXPORTING
            input  = lv_base_btditem_id_conv
          IMPORTING
            output = lv_base_btditem_id_conv.
        APPEND lv_base_btditem_id_conv TO cs_freight_unit-erp_dlv_item_id.
      ELSE.
        APPEND '' TO cs_freight_unit-erp_dlv_item_id.
      ENDIF.

      lv_base_btd_alt_item_id = lv_base_btd_id && lv_base_btditem_id_conv.

      IF <ls_tor_item>-base_btd_tco     = cs_base_btd_tco_inb_dlv  AND
         <ls_tor_item>-base_btditem_tco = cs_base_btd_tco_delivery_item.
        APPEND lv_base_btd_alt_item_id TO cs_freight_unit-dlv_item_inb_alt_id.
      ELSE.
        APPEND '' TO cs_freight_unit-dlv_item_inb_alt_id.
      ENDIF.

      IF <ls_tor_item>-base_btd_tco     = cs_base_btd_tco_outb_dlv AND
         <ls_tor_item>-base_btditem_tco = cs_base_btd_tco_delivery_item.
        APPEND lv_base_btd_alt_item_id TO cs_freight_unit-dlv_item_oub_alt_id.
      ELSE.
        APPEND '' TO cs_freight_unit-dlv_item_oub_alt_id.
      ENDIF.

      APPEND <ls_tor_item>-qua_pcs_val TO cs_freight_unit-itm_qua_pcs_val.
      APPEND <ls_tor_item>-qua_pcs_uni TO cs_freight_unit-itm_qua_pcs_uni.
      APPEND <ls_tor_item>-item_descr  TO cs_freight_unit-product_txt.

      CALL FUNCTION 'CONVERSION_EXIT_MATN1_OUTPUT'
        EXPORTING
          input  = <ls_tor_item>-product_id
        IMPORTING
          output = lv_product_id.
      APPEND lv_product_id TO cs_freight_unit-product_id.

    ENDLOOP.

  ENDMETHOD.


  METHOD get_data_from_maintab.

    FIELD-SYMBOLS:
      <ls_root>          TYPE /scmtms/s_em_bo_tor_root,
      <lt_root_old>      TYPE /scmtms/t_em_bo_tor_root,
      <lt_tor_root_capa> TYPE /scmtms/t_em_bo_tor_root.

    DATA:
      lv_tabledef_capa_root TYPE /saptrx/strucdataname,
      lv_tsp_id             TYPE bu_id_number,
      lt_capa               TYPE /scmtms/t_em_bo_tor_root.

    ASSIGN ir_maintab->* TO <ls_root>.
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
          " Record was just created
          RETURN.
        ENDIF.
      ENDIF.
      DATA(lv_before_image) = abap_true.
    ENDIF.

    cs_freight_unit-tor_id = <ls_root>-tor_id.
    SHIFT cs_freight_unit-tor_id LEFT DELETING LEADING '0'.
    cs_freight_unit-dgo_indicator = <ls_root>-dgo_indicator.

    cs_freight_unit-tspid = get_carrier_name( iv_tspid = cs_freight_unit-tspid ).

    TEST-SEAM lt_tor_add_info.
      /scmtms/cl_tor_helper_root=>det_transient_root_fields(
        EXPORTING
          it_key               = VALUE #( ( key = <ls_root>-node_id ) )
          iv_get_stop_infos    = abap_true
          iv_get_mainitem_info = abap_true
          iv_before_image      = lv_before_image
        IMPORTING
          et_tor_add_info      = DATA(lt_tor_add_info) ).
    END-TEST-SEAM.
    ASSIGN lt_tor_add_info[ 1 ] TO FIELD-SYMBOL(<ls_tor_additional_info>).
    IF sy-subrc = 0.
      cs_freight_unit-pln_grs_duration = <ls_tor_additional_info>-tot_duration.
    ENDIF.

    cs_freight_unit-total_duration_net    = <ls_root>-total_duration_net.
    cs_freight_unit-total_distance_km     = <ls_root>-total_distance_km.
    IF cs_freight_unit-total_distance_km IS NOT INITIAL.
      cs_freight_unit-total_distance_km_uom = zif_gtt_sts_constants=>cs_uom-km.
    ENDIF.

    lv_tsp_id = <ls_root>-tspid.
    cs_freight_unit-shipping_type  = <ls_root>-shipping_type.
    cs_freight_unit-trmodcod       = zcl_gtt_sts_tools=>get_trmodcod( iv_trmodcod = <ls_root>-trmodcod ).
    cs_freight_unit-tspid = get_carrier_name( iv_tspid = lv_tsp_id ).

  ENDMETHOD.


  METHOD GET_MAINTABREF.

    " FU
    FIELD-SYMBOLS <lt_maintabref> TYPE ANY TABLE.

    ASSIGN is_app_object-maintabref->* TO FIELD-SYMBOL(<ls_maintabref>).

    IF <ls_maintabref> IS ASSIGNED AND zcl_gtt_sts_tools=>is_table( iv_value = <ls_maintabref> ) = abap_true.
      ASSIGN <ls_maintabref> TO <lt_maintabref>.
      LOOP AT <lt_maintabref> ASSIGNING FIELD-SYMBOL(<ls_line>).
        ASSIGN COMPONENT /scmtms/if_tor_c=>sc_node_attribute-root-tor_cat
          OF STRUCTURE <ls_line> TO FIELD-SYMBOL(<lv_tor_cat>).
        IF sy-subrc = 0 AND <lv_tor_cat> = /scmtms/if_tor_const=>sc_tor_category-freight_unit.
          GET REFERENCE OF <ls_line> INTO rr_maintabref.
          EXIT.
        ENDIF.
      ENDLOOP.
    ELSEIF <ls_maintabref> IS ASSIGNED.
      GET REFERENCE OF <ls_maintabref> INTO rr_maintabref.
    ENDIF.

  ENDMETHOD.


  METHOD get_tracking_unit.

    FIELD-SYMBOLS:
      <ls_tor_root>      TYPE /scmtms/s_em_bo_tor_root,
      <lt_tor_root_capa> TYPE /scmtms/t_em_bo_tor_root,
      <ls_tor_root_capa> TYPE /scmtms/s_em_bo_tor_root.

    DATA:
      ls_container TYPE ts_container,
      lt_container TYPE tt_container,
      lr_capa_root TYPE REF TO data,
      lt_tu_info   TYPE tt_tu_info,
      ls_tu_info   TYPE ts_tu_info,
      lt_capa      TYPE /scmtms/t_em_bo_tor_root,
      lt_tmp_cont  TYPE TABLE OF /scmtms/package_id,
      lv_line_no   TYPE i,
      lv_tmp_stop  TYPE char255.

    ASSIGN ir_data->* TO <ls_tor_root>.
    IF sy-subrc <> 0.
      MESSAGE e010(zgtt_sts) INTO DATA(lv_dummy) ##needed.
      zcl_gtt_sts_tools=>throw_exception( ).
    ENDIF.

*   Get capacity root information
    zcl_gtt_sts_tools=>get_capa_info(
      EXPORTING
        ir_root     = ir_data
        iv_old_data = iv_old_data
      IMPORTING
        et_capa     = lt_capa ).

    LOOP AT lt_capa ASSIGNING <ls_tor_root_capa>
      WHERE tor_cat = /scmtms/if_tor_const=>sc_tor_category-transp_unit.

      CLEAR:
        ls_container,
        lt_container,
        lt_tmp_cont.

      zcl_gtt_sts_tools=>get_container_num_on_cu(
        EXPORTING
          ir_root      = REF #( <ls_tor_root_capa> )
          iv_old_data  = iv_old_data
        IMPORTING
          et_container = lt_tmp_cont ).

      LOOP AT lt_tmp_cont INTO DATA(ls_tmp_cont).
        ls_container-object_id = cs_track_id-container_id.
        ls_container-object_value = ls_tmp_cont.
        APPEND ls_container TO lt_container.
      ENDLOOP.

      LOOP AT lt_container INTO ls_container.
        ls_tu_info-tor_id = |{ <ls_tor_root_capa>-tor_id ALPHA = OUT }|.
        CONDENSE ls_tu_info-tor_id NO-GAPS.
        ls_tu_info-tu_type = ls_container-object_id.
        ls_tu_info-tu_value = ls_container-object_value.
        ls_tu_info-tu_number = |{ <ls_tor_root_capa>-tor_id }{ ls_container-object_value }|.
        CONDENSE ls_tu_info-tu_number NO-GAPS.
        SHIFT ls_tu_info-tu_number LEFT DELETING LEADING '0'.
        APPEND ls_tu_info TO lt_tu_info.
        CLEAR:
          ls_tu_info,
          ls_container.
      ENDLOOP.

    ENDLOOP.

    zcl_gtt_sts_tools=>get_capa_stop_info(
      EXPORTING
        ir_root      = ir_data
        iv_old_data  = iv_old_data
      IMPORTING
        et_capa_stop = DATA(lt_capa_stop) ).

    LOOP AT lt_tu_info INTO ls_tu_info.
      CLEAR lv_tmp_stop.
      lv_line_no = lv_line_no + 1.
      APPEND lv_line_no TO cs_freight_unit-tu_line_no.
      APPEND ls_tu_info-tu_type TO cs_freight_unit-tu_type.
      APPEND ls_tu_info-tu_value TO cs_freight_unit-tu_value.
      APPEND ls_tu_info-tu_number TO cs_freight_unit-tu_number.

      READ TABLE lt_capa_stop INTO DATA(ls_capa_stop)
        WITH KEY tor_id = ls_tu_info-tor_id.
      IF sy-subrc = 0.
        DATA(lv_length) = strlen( ls_capa_stop-first_stop ) - 4.
        DATA(lv_stop_num) = ls_capa_stop-first_stop+lv_length(4).
        lv_tmp_stop = |{ ls_tu_info-tor_id }{ ls_tu_info-tu_value }{ lv_stop_num }|.
        CONDENSE lv_tmp_stop NO-GAPS.
        APPEND lv_tmp_stop TO cs_freight_unit-tu_first_stop.

        CLEAR lv_tmp_stop.
        lv_length = strlen( ls_capa_stop-last_stop ) - 4.
        lv_stop_num = ls_capa_stop-last_stop+lv_length(4).
        lv_tmp_stop = |{ ls_tu_info-tor_id }{ ls_tu_info-tu_value }{ lv_stop_num }|.
        CONDENSE lv_tmp_stop NO-GAPS.
        APPEND lv_tmp_stop TO cs_freight_unit-tu_last_stop.
      ENDIF.
      CLEAR:
        ls_tu_info,
        ls_capa_stop,
        lv_length,
        lv_stop_num.

    ENDLOOP.

  ENDMETHOD.


  METHOD ZIF_GTT_STS_BO_READER~CHECK_RELEVANCE.

    " FU relevance function
    FIELD-SYMBOLS <ls_root> TYPE /scmtms/s_em_bo_tor_root.

    rv_result = zif_gtt_sts_ef_constants=>cs_condition-false.
    ASSIGN is_app_object-maintabref->* TO <ls_root>.
    IF sy-subrc <> 0.
      RETURN.
    ENDIF.

    IF get_customizing_aot( <ls_root>-tor_type ) <> is_app_object-appobjtype.
      RETURN.
    ENDIF.

    IF is_app_object-maintabdef = zif_gtt_sts_constants=>cs_tabledef-fo_header_new AND
      ( <ls_root>-track_exec_rel = zif_gtt_sts_constants=>cs_track_exec_rel-execution OR
        <ls_root>-track_exec_rel = zif_gtt_sts_constants=>cs_track_exec_rel-exec_with_extern_event_mngr ).

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


  METHOD ZIF_GTT_STS_BO_READER~GET_DATA.

    FIELD-SYMBOLS <ls_freight_unit> TYPE ts_freight_unit.

    rr_data = NEW ts_freight_unit( ).
    ASSIGN rr_data->* TO <ls_freight_unit>.
    IF sy-subrc <> 0.
      MESSAGE e010(zgtt_sts) INTO DATA(lv_dummy) ##needed.
      zcl_gtt_sts_tools=>throw_exception( ).
    ENDIF.

    DATA(lr_maintabref) = get_maintabref( is_app_object ).
    get_data_from_maintab(
      EXPORTING
        iv_old_data     = iv_old_data
        ir_maintab      = lr_maintabref
      CHANGING
        cs_freight_unit = <ls_freight_unit> ).
    IF <ls_freight_unit> IS INITIAL.
      RETURN.
    ENDIF.

    get_data_from_item(
      EXPORTING
        iv_old_data     = iv_old_data
        ir_data         = lr_maintabref
      CHANGING
        cs_freight_unit = <ls_freight_unit> ).
    IF <ls_freight_unit>-item_id IS INITIAL.
      APPEND '' TO <ls_freight_unit>-item_id.
    ENDIF.

    get_docref_data(
      EXPORTING
        iv_old_data          = iv_old_data
        ir_root              = lr_maintabref
      CHANGING
        ct_carrier_ref_value = <ls_freight_unit>-carrier_ref_value
        ct_carrier_ref_type  = <ls_freight_unit>-carrier_ref_type
        ct_shipper_ref_value = <ls_freight_unit>-shipper_ref_value
        ct_shipper_ref_type  = <ls_freight_unit>-shipper_ref_type ).

    CLEAR:
      <ls_freight_unit>-carrier_ref_value,
      <ls_freight_unit>-carrier_ref_type.

    IF <ls_freight_unit>-shipper_ref_value IS INITIAL.
      APPEND '' TO <ls_freight_unit>-shipper_ref_value.
    ENDIF.

    get_data_from_stop(
      EXPORTING
        ir_data             = lr_maintabref
        iv_old_data         = iv_old_data
      CHANGING
        cv_pln_dep_loc_id   = <ls_freight_unit>-pln_dep_loc_id
        cv_pln_dep_loc_type = <ls_freight_unit>-pln_dep_loc_type
        cv_pln_dep_timest   = <ls_freight_unit>-pln_dep_timest
        cv_pln_dep_timezone = <ls_freight_unit>-pln_dep_timezone
        cv_pln_arr_loc_id   = <ls_freight_unit>-pln_arr_loc_id
        cv_pln_arr_loc_type = <ls_freight_unit>-pln_arr_loc_type
        cv_pln_arr_timest   = <ls_freight_unit>-pln_arr_timest
        cv_pln_arr_timezone = <ls_freight_unit>-pln_arr_timezone
        ct_stop_id          = <ls_freight_unit>-stop_id
        ct_ordinal_no       = <ls_freight_unit>-ordinal_no
        ct_loc_type         = <ls_freight_unit>-loc_type
        ct_loc_id           = <ls_freight_unit>-loc_id ).

    get_capacity_doc_list(
      EXPORTING
        ir_data             = lr_maintabref
        iv_old_data         = iv_old_data
      CHANGING
        ct_capa_doc_line_no = <ls_freight_unit>-capa_doc_line_no
        ct_capa_doc_no      = <ls_freight_unit>-capa_doc_no ).

    IF <ls_freight_unit>-capa_doc_no IS INITIAL.
      APPEND '' TO <ls_freight_unit>-capa_doc_line_no.
    ENDIF.

    get_tracking_unit(
      EXPORTING
        ir_data         = lr_maintabref
        iv_old_data     = iv_old_data
      CHANGING
        cs_freight_unit = <ls_freight_unit> ).
    IF <ls_freight_unit>-tu_line_no IS INITIAL.
      APPEND '' TO <ls_freight_unit>-tu_line_no.
    ENDIF.

  ENDMETHOD.


  METHOD zif_gtt_sts_bo_reader~get_track_id_data.

    FIELD-SYMBOLS:
      <ls_root>              TYPE /scmtms/s_em_bo_tor_root.

    DATA:
      lt_track_id_data_new TYPE zif_gtt_sts_ef_types=>tt_enh_track_id_data,
      lt_track_id_data_old TYPE zif_gtt_sts_ef_types=>tt_enh_track_id_data,
      lv_trxid             TYPE /saptrx/trxid,
      lv_tutrxcod          TYPE /saptrx/trxcod,
      lv_futrxcod          TYPE /saptrx/trxcod,
      lt_container         TYPE TABLE OF /scmtms/package_id,
      lt_capa_new          TYPE /scmtms/t_em_bo_tor_root,
      lt_capa_old          TYPE /scmtms/t_em_bo_tor_root.

    CLEAR: et_track_id_data.

    ASSIGN is_app_object-maintabref->* TO <ls_root>.
    IF sy-subrc <> 0.
      MESSAGE e010(zgtt_sts) INTO DATA(lv_dummy) ##needed.
      zcl_gtt_sts_tools=>throw_exception( ).
    ENDIF.

    lv_futrxcod = zif_gtt_sts_constants=>cs_trxcod-fu_number.
    lv_tutrxcod = zif_gtt_sts_constants=>cs_trxcod-tu_number.

    lv_trxid = |{ <ls_root>-tor_id ALPHA = OUT }|.
    add_track_id_data(
      EXPORTING
        is_app_object = is_app_object
        iv_trxcod     = lv_futrxcod
        iv_trxid      = lv_trxid
      CHANGING
        ct_track_id   = et_track_id_data ).

*   Get capacity root information
    zcl_gtt_sts_tools=>get_capa_info(
      EXPORTING
        ir_root     = REF #( <ls_root> )
        iv_old_data = abap_false
      IMPORTING
        et_capa     = lt_capa_new ).

    LOOP AT lt_capa_new ASSIGNING FIELD-SYMBOL(<ls_tor_capa_root_new>)
      WHERE tor_cat = /scmtms/if_tor_const=>sc_tor_category-transp_unit.

      CLEAR:
        lt_container.

      DATA(lv_tor_id) = |{ <ls_tor_capa_root_new>-tor_id  ALPHA = OUT }|.
      CONDENSE lv_tor_id.

      zcl_gtt_sts_tools=>get_container_num_on_cu(
        EXPORTING
          ir_root      = REF #( <ls_tor_capa_root_new> )
          iv_old_data  = abap_false
        IMPORTING
          et_container = lt_container ).

      LOOP AT lt_container INTO DATA(ls_container).
        CLEAR lv_trxid.
        lv_trxid = |{ lv_tor_id } { ls_container }|.
        CONDENSE lv_trxid NO-GAPS.

        APPEND VALUE #( key = |{ <ls_tor_capa_root_new>-tor_id ALPHA = OUT }|
                appsys      = mo_ef_parameters->get_appsys( )
                appobjtype  = is_app_object-appobjtype
                appobjid    = |{ is_app_object-appobjid ALPHA = OUT }|
                trxcod      = lv_tutrxcod
                trxid       = lv_trxid ) TO lt_track_id_data_new.

      ENDLOOP.

    ENDLOOP.

    zcl_gtt_sts_tools=>get_capa_info(
      EXPORTING
        ir_root     = REF #( <ls_root> )
        iv_old_data = abap_true
      IMPORTING
        et_capa     = lt_capa_old ).

    LOOP AT lt_capa_old ASSIGNING FIELD-SYMBOL(<ls_tor_capa_root_old>)
      WHERE tor_cat = /scmtms/if_tor_const=>sc_tor_category-transp_unit.

      CLEAR:
        lt_container.

      lv_tor_id = |{ <ls_tor_capa_root_old>-tor_id  ALPHA = OUT }|.
      CONDENSE lv_tor_id.

      zcl_gtt_sts_tools=>get_container_num_on_cu(
        EXPORTING
          ir_root      = REF #( <ls_tor_capa_root_old> )
          iv_old_data  = abap_true
        IMPORTING
          et_container = lt_container ).

      LOOP AT lt_container INTO ls_container.
        CLEAR lv_trxid.
        lv_trxid = |{ lv_tor_id } { ls_container }|.
        CONDENSE lv_trxid NO-GAPS.
        APPEND VALUE #( key = |{ <ls_tor_capa_root_old>-tor_id ALPHA = OUT }|
                appsys      = mo_ef_parameters->get_appsys( )
                appobjtype  = is_app_object-appobjtype
                appobjid    = |{ is_app_object-appobjid ALPHA = OUT }|
                trxcod      = lv_tutrxcod
                trxid       = lv_trxid ) TO lt_track_id_data_old.

      ENDLOOP.

    ENDLOOP.

    zcl_gtt_sts_tools=>get_track_obj_changes_v2(
      EXPORTING
        is_app_object        = is_app_object
        iv_appsys            = mo_ef_parameters->get_appsys( )
        it_track_id_data_new = lt_track_id_data_new
        it_track_id_data_old = lt_track_id_data_old
      CHANGING
        ct_track_id_data     = et_track_id_data ).

  ENDMETHOD.
ENDCLASS.
