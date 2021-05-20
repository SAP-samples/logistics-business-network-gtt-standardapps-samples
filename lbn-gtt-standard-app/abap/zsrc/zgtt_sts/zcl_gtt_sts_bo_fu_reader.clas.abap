CLASS zcl_gtt_sts_bo_fu_reader DEFINITION
  PUBLIC
  INHERITING FROM zcl_gtt_sts_bo_tor_reader
  CREATE PUBLIC .

  PUBLIC SECTION.

    TYPES:
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
        ref_doc_id            TYPE tt_ref_doc_id,
        ref_doc_type          TYPE tt_ref_doc_type,
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
*        capa_doc_first_stop   TYPE tt_stop,
*        capa_doc_last_stop    TYPE tt_stop,
      END OF ts_freight_unit .

    CONSTANTS cs_base_btd_tco_inb_dlv TYPE /scmtms/base_btd_tco VALUE '58' ##NO_TEXT.
    CONSTANTS cs_base_btd_tco_outb_dlv TYPE /scmtms/base_btd_tco VALUE '73' ##NO_TEXT.
    CONSTANTS cs_base_btd_tco_delivery_item TYPE /scmtms/base_btd_item_tco VALUE '14' ##NO_TEXT.

    METHODS get_data_from_maintab
      IMPORTING
        !ir_maintab      TYPE REF TO data
        !iv_old_data     TYPE abap_bool DEFAULT abap_false
      CHANGING
        !cs_freight_unit TYPE ts_freight_unit
      RAISING
        cx_udm_message .
    METHODS check_fo_track_obj_changes
      IMPORTING
        !is_app_object   TYPE trxas_appobj_ctab_wa
      RETURNING
        VALUE(rv_result) TYPE zif_gtt_sts_ef_types=>tv_condition
      RAISING
        cx_udm_message .
    METHODS get_maintabref
      IMPORTING
        !is_app_object       TYPE trxas_appobj_ctab_wa
      RETURNING
        VALUE(rr_maintabref) TYPE REF TO data .
    METHODS get_data_from_item
      IMPORTING
        !ir_data         TYPE REF TO data
        !iv_old_data     TYPE abap_bool DEFAULT abap_false
      CHANGING
        !cs_freight_unit TYPE ts_freight_unit
      RAISING
        cx_udm_message .
    METHODS get_capacity_doc_list
      IMPORTING
        !ir_data             TYPE REF TO data
        !iv_old_data         TYPE abap_bool DEFAULT abap_false
      CHANGING
        !ct_capa_doc_line_no TYPE tt_capacity_doc_line_number
        !ct_capa_doc_no      TYPE tt_capacity_doc_number
      RAISING
        cx_udm_message .
    METHODS check_fo_route_change
      IMPORTING
        !is_app_object   TYPE trxas_appobj_ctab_wa
      RETURNING
        VALUE(rv_result) TYPE zif_gtt_sts_ef_types=>tv_condition
      RAISING
        cx_udm_message .

    METHODS zif_gtt_sts_bo_reader~check_relevance
        REDEFINITION .
    METHODS zif_gtt_sts_bo_reader~get_data
        REDEFINITION .
    METHODS zif_gtt_sts_bo_reader~get_track_id_data
        REDEFINITION .
  PROTECTED SECTION.

    METHODS check_non_idoc_fields
        REDEFINITION .
    METHODS check_non_idoc_stop_fields
        REDEFINITION .
    METHODS get_stop_seq
        REDEFINITION .
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_GTT_STS_BO_FU_READER IMPLEMENTATION.


  METHOD check_fo_route_change.

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

      ASSIGN lt_capa_stage[ KEY source_stop_key COMPONENTS
        source_stop_key = lv_stop_src_key ]-seq_num TO FIELD-SYMBOL(<lv_capa_stage_first_num>).
      CHECK sy-subrc = 0.

      ASSIGN lt_capa_stage[ dest_stop_key = lv_stop_des_key ]-seq_num TO FIELD-SYMBOL(<lv_capa_stage_last_num>).
      CHECK sy-subrc = 0.

      lv_stage_num_difference = <lv_capa_stage_last_num> - <lv_capa_stage_first_num>.

      ASSIGN lt_capa_stage_bi[ KEY source_stop_key COMPONENTS
        source_stop_key = lv_stop_src_key ]-seq_num TO FIELD-SYMBOL(<lv_capa_stage_first_num_bi>).
      CHECK sy-subrc = 0.

      ASSIGN lt_capa_stage_bi[ dest_stop_key = lv_stop_des_key ]-seq_num TO FIELD-SYMBOL(<lv_capa_stage_last_num_bi>).
      CHECK sy-subrc = 0.

      lv_stage_num_difference_bi = <lv_capa_stage_last_num_bi> - <lv_capa_stage_first_num_bi>.

    ENDDO.

    IF lv_stage_num_difference <> lv_stage_num_difference_bi.
      rv_result = zif_gtt_sts_ef_constants=>cs_condition-true.
    ENDIF.

  ENDMETHOD.


  METHOD check_fo_track_obj_changes.

    "FU
    DATA:
      lr_item_new          TYPE REF TO data,
      lr_item_old          TYPE REF TO data,
      lt_track_id_data     TYPE zif_gtt_sts_ef_types=>tt_track_id_data,
      lt_track_id_data_new TYPE zif_gtt_sts_ef_types=>tt_enh_track_id_data,
      lt_track_id_data_old TYPE zif_gtt_sts_ef_types=>tt_enh_track_id_data,
      ls_capa_root_fo      TYPE /scmtms/s_em_bo_tor_root.

    FIELD-SYMBOLS:
      <lt_item_new>          TYPE /scmtms/t_em_bo_tor_item,
      <lt_item_old>          TYPE /scmtms/t_em_bo_tor_item,
      <ls_root>              TYPE /scmtms/s_em_bo_tor_root,
      <ls_root_new>          TYPE /scmtms/s_em_bo_tor_root,
      <ls_root_old>          TYPE /scmtms/s_em_bo_tor_root,
      <lt_tor_root_capa_new> TYPE /scmtms/t_em_bo_tor_root,
      <lt_tor_root_capa_old> TYPE /scmtms/t_em_bo_tor_root.

    rv_result = zif_gtt_sts_ef_constants=>cs_condition-false.

    ASSIGN is_app_object-maintabref->* TO <ls_root>.
    IF sy-subrc <> 0.
      MESSAGE e010(zgtt_sts) INTO DATA(lv_dummy) ##needed.
      zcl_gtt_sts_tools=>throw_exception( ).
    ENDIF.

    DATA(lr_root_capa_new) = mo_ef_parameters->get_appl_table(
                                  iv_tabledef = /scmtms/cl_scem_int_c=>sc_table_definition-bo_tor-capa_root ).
    ASSIGN lr_root_capa_new->* TO <lt_tor_root_capa_new>.
    IF sy-subrc <> 0.
      MESSAGE e010(zgtt_sts) INTO lv_dummy.
      zcl_gtt_sts_tools=>throw_exception( ).
    ENDIF.

    DATA(lr_capa_root_old) = mo_ef_parameters->get_appl_table(
                                  iv_tabledef = /scmtms/cl_scem_int_c=>sc_table_definition-bo_tor-capa_root_before ).
    ASSIGN lr_capa_root_old->* TO <lt_tor_root_capa_old>.
    IF sy-subrc <> 0.
      MESSAGE e010(zgtt_sts) INTO lv_dummy.
      zcl_gtt_sts_tools=>throw_exception( ).
    ENDIF.

    DATA(lo_tor_srv_mgr) = /bobf/cl_tra_serv_mgr_factory=>get_service_manager( iv_bo_key = /scmtms/if_tor_c=>sc_bo_key ).
    lo_tor_srv_mgr->retrieve_by_association(
      EXPORTING
        iv_node_key    = /scmtms/if_tor_c=>sc_node-root
        it_key         = VALUE #( ( key = <ls_root>-node_id ) )
        iv_association = /scmtms/if_tor_c=>sc_association-root-capa_tor
      IMPORTING
        et_key_link    = DATA(lt_req2capa_link) ).

    LOOP AT lt_req2capa_link ASSIGNING FIELD-SYMBOL(<ls_req2capa_link>).
      ASSIGN <lt_tor_root_capa_new>[ node_id = <ls_req2capa_link>-target_key ] TO <ls_root_new>.
      CHECK sy-subrc = 0.

      ASSIGN <lt_tor_root_capa_old>[ node_id = <ls_req2capa_link>-target_key ] TO <ls_root_old>.
      CHECK sy-subrc = 0.

      DATA(ls_app_object) = is_app_object.
      ls_capa_root_fo = CORRESPONDING #( <ls_root_new> MAPPING node_id = node_id  ).
      GET REFERENCE OF ls_capa_root_fo INTO ls_app_object-maintabref.

      get_container_mobile_track_id(
        EXPORTING
          is_app_object    = ls_app_object
        CHANGING
          ct_track_id_data = lt_track_id_data_new ).

      get_container_mobile_track_id(
        EXPORTING
          is_app_object    = ls_app_object
          iv_old_data      = abap_true
        CHANGING
          ct_track_id_data = lt_track_id_data_old ).

      lr_item_new = mo_ef_parameters->get_appl_table( iv_tabledef = zif_gtt_sts_constants=>cs_tabledef-fo_item_new ).
      lr_item_old = mo_ef_parameters->get_appl_table( iv_tabledef = zif_gtt_sts_constants=>cs_tabledef-fo_item_old ).

      DATA(lv_deleted) = zcl_gtt_sts_tools=>check_is_fo_deleted(
                             is_root_new = <ls_root_new>
                             is_root_old = <ls_root_old> ).
      IF lv_deleted = zif_gtt_sts_ef_constants=>cs_condition-true.
        CLEAR: lt_track_id_data_old, lr_item_old.
      ENDIF.

      ASSIGN lr_item_new->* TO <lt_item_new>.
      IF <lt_item_new> IS ASSIGNED.
        zcl_gtt_sts_tools=>get_fo_tracked_item_obj(
          EXPORTING
            is_app_object = ls_app_object
            is_root       = <ls_root_new>
            it_item       = <lt_item_new>
            iv_appsys     = mo_ef_parameters->get_appsys( )
            iv_old_data   = abap_false
         CHANGING
            ct_track_id_data = lt_track_id_data_new ).
      ELSE.
        MESSAGE e010(zgtt_sts) INTO lv_dummy.
        zcl_gtt_sts_tools=>throw_exception( ).
      ENDIF.

      ASSIGN lr_item_old->* TO <lt_item_old>.
      IF sy-subrc = 0 AND lv_deleted =  zif_gtt_sts_ef_constants=>cs_condition-false.
        zcl_gtt_sts_tools=>get_fo_tracked_item_obj(
          EXPORTING
            is_app_object = ls_app_object
            is_root       = <ls_root_old>
            it_item       = <lt_item_old>
            iv_appsys     = mo_ef_parameters->get_appsys( )
            iv_old_data   = abap_true
         CHANGING
            ct_track_id_data = lt_track_id_data_old ).
      ENDIF.

      zcl_gtt_sts_tools=>get_track_obj_changes(
        EXPORTING
          is_app_object        = ls_app_object
          iv_appsys            = mo_ef_parameters->get_appsys( )
          it_track_id_data_new = lt_track_id_data_new
          it_track_id_data_old = lt_track_id_data_old
        CHANGING
          ct_track_id_data     = lt_track_id_data ).
    ENDLOOP.

    IF lt_track_id_data IS NOT INITIAL.
      rv_result = zif_gtt_sts_ef_constants=>cs_condition-true.
      RETURN.
    ENDIF.

  ENDMETHOD.


  METHOD check_non_idoc_fields.

    rv_result = check_non_idoc_stop_fields( is_app_object = is_app_object ).
    IF rv_result = zif_gtt_sts_ef_constants=>cs_condition-true.
      RETURN.
    ENDIF.

    rv_result = check_fo_route_change( is_app_object = is_app_object ).

  ENDMETHOD.


  METHOD check_non_idoc_stop_fields.

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
    lo_tor_srv_mgr->retrieve(
      EXPORTING
        iv_node_key     = /scmtms/if_tor_c=>sc_node-stop
        it_key          = lt_capa_stop_key
        iv_before_image = abap_true
      IMPORTING
        et_data         = lt_capa_stop_old ).

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


  METHOD get_capacity_doc_list.

    DATA:
      lv_capa_doc_line_no   TYPE int4,
      lv_tabledef_capa_root TYPE /saptrx/strucdataname,
      lv_tabledef_capa_stop TYPE /saptrx/strucdataname.

    FIELD-SYMBOLS:
      <ls_tor_root>      TYPE /scmtms/s_em_bo_tor_root,
      <lt_tor_root_capa> TYPE /scmtms/t_em_bo_tor_root.

    ASSIGN ir_data->* TO <ls_tor_root>.
    IF sy-subrc <> 0.
      MESSAGE e010(zgtt_sts) INTO DATA(lv_dummy) ##needed.
      zcl_gtt_sts_tools=>throw_exception( ).
    ENDIF.

    IF iv_old_data = abap_false.
      lv_tabledef_capa_root = /scmtms/cl_scem_int_c=>sc_table_definition-bo_tor-capa_root.
    ELSE.
      lv_tabledef_capa_root = /scmtms/cl_scem_int_c=>sc_table_definition-bo_tor-capa_root_before.
    ENDIF.

    DATA(lr_req_root) = mo_ef_parameters->get_appl_table( iv_tabledef = lv_tabledef_capa_root ).
    ASSIGN lr_req_root->* TO <lt_tor_root_capa>.
    IF sy-subrc <> 0.
      MESSAGE e010(zgtt_sts) INTO lv_dummy.
      zcl_gtt_sts_tools=>throw_exception( ).
    ENDIF.

    DATA(lo_tor_srv_mgr) = /bobf/cl_tra_serv_mgr_factory=>get_service_manager( iv_bo_key = /scmtms/if_tor_c=>sc_bo_key ).
    lo_tor_srv_mgr->retrieve_by_association(
      EXPORTING
        iv_node_key    = /scmtms/if_tor_c=>sc_node-root
        it_key         = VALUE #( ( key = <ls_tor_root>-node_id ) )
        iv_association = /scmtms/if_tor_c=>sc_association-root-capa_tor
      IMPORTING
        et_key_link    = DATA(lt_req2capa_link) ).

    LOOP AT lt_req2capa_link ASSIGNING FIELD-SYMBOL(<ls_req2capa_link>).
      ASSIGN <lt_tor_root_capa>[ node_id = <ls_req2capa_link>-target_key ]-tor_id TO FIELD-SYMBOL(<lv_tor_capa_id>).
      CHECK sy-subrc = 0.

      lv_capa_doc_line_no += 1.
      APPEND lv_capa_doc_line_no TO ct_capa_doc_line_no.

      APPEND <lv_tor_capa_id> TO ct_capa_doc_no.
    ENDLOOP.

  ENDMETHOD.


  METHOD get_data_from_item.

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
      WHERE parent_node_id = <ls_tor_root>-node_id AND
            item_cat = /scmtms/if_tor_const=>sc_tor_item_category-product.

      lv_item_id = <ls_tor_item>-item_id+4(6).
      APPEND lv_item_id TO cs_freight_unit-item_id.

      IF <ls_tor_item>-base_btd_tco = cs_base_btd_tco_inb_dlv OR
         <ls_tor_item>-base_btd_tco = cs_base_btd_tco_outb_dlv.
        DATA(lv_base_btd_id) = <ls_tor_item>-base_btd_id.
        SHIFT lv_base_btd_id LEFT DELETING LEADING '0'.
        lv_base_btd_id_conv = lv_base_btd_id.
        CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
          EXPORTING
            input  = lv_base_btd_id_conv
          IMPORTING
            output = lv_base_btd_id_conv.
        APPEND lv_base_btd_id_conv TO cs_freight_unit-erp_dlv_id.
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

      lv_base_btd_alt_item_id = lv_base_btd_id && <ls_tor_item>-base_btditem_id+4(6).

      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
        EXPORTING
          input  = lv_base_btd_alt_item_id
        IMPORTING
          output = lv_base_btd_alt_item_id.

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
      <ls_root>     TYPE /scmtms/s_em_bo_tor_root,
      <lt_root_old> TYPE /scmtms/t_em_bo_tor_root.

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

    /scmtms/cl_tor_helper_root=>det_transient_root_fields(
      EXPORTING
        it_key               = VALUE #( ( key = <ls_root>-node_id ) )
        iv_get_stop_infos    = abap_true
        iv_get_mainitem_info = abap_true
        iv_before_image      = lv_before_image
      IMPORTING
        et_tor_add_info      = DATA(lt_tor_add_info) ).
    ASSIGN lt_tor_add_info[ 1 ] TO FIELD-SYMBOL(<ls_tor_additional_info>).
    IF sy-subrc = 0.
      cs_freight_unit-pln_grs_duration = <ls_tor_additional_info>-tot_duration.
    ENDIF.

    cs_freight_unit-total_duration_net    = <ls_root>-total_duration_net.
    cs_freight_unit-total_distance_km     = <ls_root>-total_distance_km.
    IF cs_freight_unit-total_distance_km IS NOT INITIAL.
      cs_freight_unit-total_distance_km_uom = zif_gtt_sts_constants=>cs_uom-km.
    ENDIF.
    cs_freight_unit-shipping_type         = <ls_root>-shipping_type.
    cs_freight_unit-trmodcod              = zcl_gtt_sts_tools=>get_trmodcod( iv_trmodcod = <ls_root>-trmodcod ).

  ENDMETHOD.


  METHOD get_maintabref.

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


  METHOD get_stop_seq.

    DATA:
      lv_stop_id_num(4)       TYPE n,
      lv_stop_num(4)          TYPE n,
      lv_stop_id              TYPE string,
      lt_stop_id              TYPE SORTED TABLE OF string WITH UNIQUE KEY table_line,
      lt_tor_capa_stop_before TYPE /scmtms/t_tor_stop_k,
      lt_capa_stop            TYPE /scmtms/t_em_bo_tor_stop.

    FIELD-SYMBOLS:
      <ls_tor_root>  TYPE /scmtms/s_em_bo_tor_root,
      <lt_capa_root> TYPE /scmtms/t_em_bo_tor_root,
      <lt_capa_stop> TYPE /scmtms/t_em_bo_tor_stop.

    ASSIGN ir_data->* TO <ls_tor_root>.
    IF sy-subrc <> 0.
      MESSAGE e010(zgtt_sts) INTO DATA(lv_dummy) ##needed.
      zcl_gtt_sts_tools=>throw_exception( ).
    ENDIF.

    DATA(lv_tor_id) = <ls_tor_root>-tor_id.
    SHIFT lv_tor_id LEFT DELETING LEADING '0'.

    ASSIGN it_stop_seq[ root_key = <ls_tor_root>-node_id ]-stop_seq TO FIELD-SYMBOL(<lt_stop_seq>) ##WARN_OK.
    IF sy-subrc <> 0.
      RETURN.
    ENDIF.

    " Get Capacity Root
    DATA(lr_capa_root) = mo_ef_parameters->get_appl_table(
      SWITCH #( iv_old_data WHEN abap_false THEN /scmtms/cl_scem_int_c=>sc_table_definition-bo_tor-capa_root
                                            ELSE /scmtms/cl_scem_int_c=>sc_table_definition-bo_tor-capa_root_before ) ).
    ASSIGN lr_capa_root->* TO <lt_capa_root>.
    IF sy-subrc <> 0.
      MESSAGE e010(zgtt_sts) INTO lv_dummy.
      zcl_gtt_sts_tools=>throw_exception( ).
    ENDIF.

    " Get Capacity Stop
    IF iv_old_data = abap_true.
      DATA(lo_tor_srv_mgr) = /bobf/cl_tra_serv_mgr_factory=>get_service_manager(
                                 iv_bo_key = /scmtms/if_tor_c=>sc_bo_key ).
      lo_tor_srv_mgr->retrieve_by_association(
        EXPORTING
          iv_node_key     = /scmtms/if_tor_c=>sc_node-root
          it_key          = CORRESPONDING #( <lt_capa_root> MAPPING key = node_id )
          iv_association  = /scmtms/if_tor_c=>sc_association-root-stop
          iv_before_image = abap_true
          iv_fill_data    = abap_true
        IMPORTING
          et_data         = lt_tor_capa_stop_before ).

      lt_capa_stop = CORRESPONDING #( lt_tor_capa_stop_before MAPPING node_id = key parent_node_id = parent_key ).

    ELSE.
      DATA(lr_capa_stop) = mo_ef_parameters->get_appl_table( /scmtms/cl_scem_int_c=>sc_table_definition-bo_tor-capa_stop ).
      ASSIGN lr_capa_stop->* TO <lt_capa_stop>.
      IF sy-subrc = 0.
        lt_capa_stop = <lt_capa_stop>.
      ENDIF.
    ENDIF.

    LOOP AT <lt_stop_seq> ASSIGNING FIELD-SYMBOL(<ls_stop_seq>).

      IF <ls_stop_seq>-seq_num = 1 OR zcl_gtt_sts_tools=>is_odd( <ls_stop_seq>-seq_num ) = abap_false.
        lv_stop_id_num += 1.
      ENDIF.

      IF <ls_stop_seq>-assgn_stop_key IS NOT INITIAL.
        lv_stop_id = zcl_gtt_sts_tools=>get_capa_match_key(
                          iv_assgn_stop_key = <ls_stop_seq>-assgn_stop_key
                          it_capa_stop      = lt_capa_stop
                          it_capa_root      = <lt_capa_root>
                          iv_before_image   = iv_old_data ).
      ELSE.
        lv_stop_id = |{ lv_tor_id }{ lv_stop_id_num }|.
      ENDIF.

      CHECK NOT line_exists( lt_stop_id[ table_line = lv_stop_id ] ).
      lv_stop_num += 1.

      APPEND lv_stop_id                                   TO ct_stop_id.
      APPEND lv_stop_num                                  TO ct_ordinal_no.
      APPEND zif_gtt_sts_constants=>cs_location_type-logistic TO ct_loc_type.
      APPEND <ls_stop_seq>-log_locid                      TO ct_loc_id.

      INSERT lv_stop_id INTO TABLE lt_stop_id.

    ENDLOOP.

  ENDMETHOD.


  METHOD zif_gtt_sts_bo_reader~check_relevance.

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


  METHOD zif_gtt_sts_bo_reader~get_data.

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
        iv_old_data     = iv_old_data
        ir_root         = lr_maintabref
      CHANGING
        ct_ref_doc_id   = <ls_freight_unit>-ref_doc_id
        ct_ref_doc_type = <ls_freight_unit>-ref_doc_type ).
    IF <ls_freight_unit>-ref_doc_id IS INITIAL.
      APPEND '' TO <ls_freight_unit>-ref_doc_id.
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

  ENDMETHOD.


  METHOD zif_gtt_sts_bo_reader~get_track_id_data.

    FIELD-SYMBOLS <ls_root> TYPE /scmtms/s_em_bo_tor_root.

    CLEAR: et_track_id_data.

    ASSIGN is_app_object-maintabref->* TO <ls_root>.
    IF sy-subrc <> 0.
      MESSAGE e010(zgtt_sts) INTO DATA(lv_dummy) ##needed.
      zcl_gtt_sts_tools=>throw_exception( ).
    ENDIF.

    add_track_id_data(
      EXPORTING
        is_app_object = is_app_object
        iv_trxcod     = zif_gtt_sts_constants=>cs_trxcod-fu_number
        iv_trxid      = |{ <ls_root>-tor_id }|
      CHANGING
        ct_track_id   = et_track_id_data ).

  ENDMETHOD.
ENDCLASS.
