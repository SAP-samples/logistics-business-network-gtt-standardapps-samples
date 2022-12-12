class ZCL_GTT_STS_BO_FO_READER definition
  public
  inheriting from ZCL_GTT_STS_BO_TOR_READER
  create public .

public section.

  methods ZIF_GTT_STS_BO_READER~GET_DATA
    redefinition .
  methods ZIF_GTT_STS_BO_READER~GET_TRACK_ID_DATA
    redefinition .
protected section.

  methods GET_REQUIREMENT_DOC_LIST
    redefinition .
private section.

  types:
    BEGIN OF ts_fo_header,
        shipment_type         TYPE string,
        tor_id                TYPE /scmtms/s_em_bo_tor_root-tor_id,
        mtr                   TYPE /scmtms/s_em_bo_tor_root-mtr,  "/SAPAPO/TR_MOTSCODE,
        gro_vol_val           TYPE /scmtms/s_em_bo_tor_root-gro_vol_val,
        gro_vol_uni           TYPE /scmtms/s_em_bo_tor_root-gro_vol_uni,
        gro_wei_val           TYPE /scmtms/s_em_bo_tor_root-gro_wei_val,
        gro_wei_uni           TYPE /scmtms/s_em_bo_tor_root-gro_wei_uni,
        qua_pcs_val           TYPE /scmtms/s_em_bo_tor_root-qua_pcs_val,
        qua_pcs_uni           TYPE /scmtms/s_em_bo_tor_root-qua_pcs_uni,
        total_distance_km     TYPE /scmtms/s_em_bo_tor_root-total_distance_km,
        total_distance_km_uom TYPE meins,
        dgo_indicator         TYPE /scmtms/s_em_bo_tor_root-dgo_indicator,
        total_duration_net    TYPE /scmtms/s_em_bo_tor_root-total_duration_net,
        pln_grs_duration      TYPE /scmtms/total_duration,
        shipping_type         TYPE /scmtms/s_em_bo_tor_root-shipping_type,
        traffic_direct        TYPE /scmtms/s_em_bo_tor_root-traffic_direct,
        trmodcod              TYPE /scmtms/s_em_bo_tor_root-trmodcod,
        tspid                 TYPE bu_id_number,
        tracked_object_type   TYPE tt_tracked_object_type,
        tracked_object_id     TYPE tt_tracked_object_id,
        carrier_ref_value     TYPE tt_carrier_ref_value,
        carrier_ref_type      TYPE tt_carrier_ref_type,
        shipper_ref_value     TYPE tt_shipper_ref_value,
        shipper_ref_type      TYPE tt_shipper_ref_type,
        inc_class_code        TYPE /scmtms/s_em_bo_tor_item-inc_class_code,
        inc_transf_loc_n      TYPE /scmtms/s_em_bo_tor_item-inc_transf_loc_n,
        country               TYPE /scmtms/s_em_bo_tor_item-country,
        platenumber           TYPE /scmtms/s_em_bo_tor_item-platenumber,
        res_id                TYPE /scmtms/s_em_bo_tor_item-res_id,
        pln_dep_loc_id        TYPE /scmtms/location_id,
        pln_dep_loc_type      TYPE /saptrx/loc_id_type,
        pln_dep_timest        TYPE char16,
        pln_dep_timezone      TYPE ad_tzone,
        pln_arr_loc_id        TYPE /scmtms/location_id,
        pln_arr_loc_type      TYPE /saptrx/loc_id_type,
        pln_arr_timest        TYPE char16,
        pln_arr_timezone      TYPE ad_tzone,
        stop_id               TYPE tt_stop_id,
        ordinal_no            TYPE tt_ordinal_no,
        loc_type              TYPE tt_loc_type,
        loc_id                TYPE tt_loc_id,
        req_doc_line_no       TYPE tt_req_doc_line_number,
        req_doc_no            TYPE tt_req_doc_number,
        req_doc_first_stop    TYPE tt_stop,
        req_doc_last_stop     TYPE tt_stop,
        resource_tp_line_cnt  TYPE tt_resource_tp_line_cnt,
        resource_tp_id        TYPE tt_resource_tp_id,
      END OF ts_fo_header .

  methods GET_DATA_FROM_ROOT
    importing
      !IV_OLD_DATA type ABAP_BOOL default ABAP_FALSE
      !IR_ROOT type ref to DATA
    changing
      !CS_FO_HEADER type TS_FO_HEADER
    raising
      CX_UDM_MESSAGE .
  methods GET_DATA_FROM_ITEM
    importing
      !IV_OLD_DATA type ABAP_BOOL default ABAP_FALSE   ##NEEDED
      !IR_ROOT type ref to DATA
      !IR_ITEM type ref to DATA
    changing
      !CS_FO_HEADER type TS_FO_HEADER
    raising
      CX_UDM_MESSAGE .
  methods GET_DATA_FROM_TEXTCOLL
    importing
      !IV_OLD_DATA type ABAP_BOOL default ABAP_FALSE
      !IR_ROOT type ref to DATA
    changing
      !CS_FO_HEADER type TS_FO_HEADER
    raising
      CX_UDM_MESSAGE .
  methods GET_MAINTABREF
    importing
      !IS_APP_OBJECT type TRXAS_APPOBJ_CTAB_WA
    returning
      value(RR_MAINTABREF) type ref to DATA .
ENDCLASS.



CLASS ZCL_GTT_STS_BO_FO_READER IMPLEMENTATION.


  METHOD get_data_from_item.

    FIELD-SYMBOLS:
      <ls_root> TYPE /scmtms/s_em_bo_tor_root,
      <lt_item> TYPE /scmtms/t_em_bo_tor_item.

    ASSIGN ir_root->* TO <ls_root>.
    IF sy-subrc <> 0.
      MESSAGE e010(zgtt_sts) INTO DATA(lv_dummy) ##needed.
      zcl_gtt_sts_tools=>throw_exception( ).
    ENDIF.

    ASSIGN ir_item->* TO <lt_item>.
    IF sy-subrc <> 0.
      MESSAGE e010(zgtt_sts) INTO lv_dummy ##needed.
      zcl_gtt_sts_tools=>throw_exception( ).
    ENDIF.

    LOOP AT <lt_item> ASSIGNING FIELD-SYMBOL(<ls_item>).
      IF <ls_item>-item_cat = /scmtms/if_tor_const=>sc_tor_item_category-av_item
       AND <ls_item>-parent_node_id = <ls_root>-node_id.
        cs_fo_header-inc_class_code   =  <ls_item>-inc_class_code.
        cs_fo_header-inc_transf_loc_n =  <ls_item>-inc_transf_loc_n.
        cs_fo_header-country          =  <ls_item>-country.
        cs_fo_header-platenumber      =  <ls_item>-platenumber.
        cs_fo_header-res_id           =  <ls_item>-res_id.
        EXIT.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.


  METHOD get_data_from_root.

    FIELD-SYMBOLS:
      <ls_root>     TYPE /scmtms/s_em_bo_tor_root,
      <lt_root_old> TYPE /scmtms/t_em_bo_tor_root.

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
      DATA(lv_before_image) = abap_true.
    ENDIF.

    MOVE-CORRESPONDING <ls_root> TO cs_fo_header ##ENH_OK.

   TEST-SEAM det_transient_root_fields.
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
      cs_fo_header-pln_grs_duration = <ls_tor_additional_info>-tot_duration.
    ENDIF.

    cs_fo_header-shipment_type = zif_gtt_sts_constants=>cs_shipment_type-tor.
    TEST-SEAM get_carrier_name.
    cs_fo_header-tspid = get_carrier_name( iv_tspid = cs_fo_header-tspid
                                           iv_tsp_scac = <ls_root>-tsp_scac ).
    END-TEST-SEAM.
    IF cs_fo_header-total_distance_km IS NOT INITIAL.
      cs_fo_header-total_distance_km_uom = zif_gtt_sts_constants=>cs_uom-km.
    ENDIF.

   TEST-SEAM motscode.
    SELECT SINGLE motscode
      FROM /sapapo/trtype
      INTO cs_fo_header-mtr
      WHERE ttype = cs_fo_header-mtr.
   END-TEST-SEAM.

    SHIFT cs_fo_header-mtr    LEFT DELETING LEADING '0'.
    SHIFT cs_fo_header-tor_id LEFT DELETING LEADING '0'.
    cs_fo_header-trmodcod = zcl_gtt_sts_tools=>get_trmodcod( iv_trmodcod = cs_fo_header-trmodcod ).
    cs_fo_header-shipping_type  = <ls_root>-shipping_type.
    cs_fo_header-traffic_direct = <ls_root>-traffic_direct.

  ENDMETHOD.


  METHOD get_data_from_textcoll.

  TEST-SEAM get_container_and_mobile_track.
    get_container_and_mobile_track(
      EXPORTING
        ir_data         = ir_root
        iv_old_data     = iv_old_data
      CHANGING
        ct_tracked_object_type = cs_fo_header-tracked_object_type
        ct_tracked_object_id   = cs_fo_header-tracked_object_id ).
  END-TEST-SEAM.

    IF cs_fo_header-tor_id IS NOT INITIAL AND cs_fo_header-res_id IS NOT INITIAL.
      APPEND cs_track_id-truck_id TO cs_fo_header-tracked_object_id.
      APPEND cs_fo_header-res_id  TO cs_fo_header-tracked_object_type.
    ENDIF.
    IF cs_fo_header-tor_id IS NOT INITIAL AND cs_fo_header-platenumber IS NOT INITIAL AND cs_fo_header-mtr = '31'.
      APPEND cs_track_id-license_plate TO cs_fo_header-tracked_object_id.
      APPEND cs_fo_header-platenumber  TO cs_fo_header-tracked_object_type.
    ENDIF.

  ENDMETHOD.


  METHOD get_maintabref.

    FIELD-SYMBOLS <lt_maintabref> TYPE ANY TABLE.

    ASSIGN is_app_object-maintabref->* TO FIELD-SYMBOL(<ls_maintabref>).

    IF <ls_maintabref> IS ASSIGNED AND zcl_gtt_sts_tools=>is_table( iv_value = <ls_maintabref> ) = abap_true.
      ASSIGN <ls_maintabref> TO <lt_maintabref>.
      LOOP AT <lt_maintabref> ASSIGNING FIELD-SYMBOL(<ls_line>).
        ASSIGN COMPONENT /scmtms/if_tor_c=>sc_node_attribute-root-tor_cat
          OF STRUCTURE <ls_line> TO FIELD-SYMBOL(<lv_tor_cat>).
        IF sy-subrc = 0 AND <lv_tor_cat> = /scmtms/if_tor_const=>sc_tor_category-active.
          GET REFERENCE OF <ls_line> INTO rr_maintabref.
          EXIT.
        ENDIF.
      ENDLOOP.
    ELSEIF <ls_maintabref> IS ASSIGNED.
      GET REFERENCE OF <ls_maintabref> INTO rr_maintabref.
    ENDIF.

  ENDMETHOD.


  METHOD zif_gtt_sts_bo_reader~get_data.

    FIELD-SYMBOLS <ls_freight_order> TYPE ts_fo_header.

    DATA(lr_maintabref) = get_maintabref( is_app_object ).

    rr_data   = NEW ts_fo_header( ).
    ASSIGN rr_data->* TO <ls_freight_order>.
    IF sy-subrc <> 0.
      MESSAGE e010(zgtt_sts) INTO DATA(lv_dummy) ##needed.
      zcl_gtt_sts_tools=>throw_exception( ).
    ENDIF.

    get_data_from_root(
      EXPORTING
        iv_old_data   = iv_old_data
        ir_root       = lr_maintabref
      CHANGING
        cs_fo_header  = <ls_freight_order> ).
    IF <ls_freight_order> IS INITIAL.
      RETURN.
    ENDIF.

    get_data_from_item(
      EXPORTING
        iv_old_data   = iv_old_data
        ir_root       = lr_maintabref
        ir_item       = mo_ef_parameters->get_appl_table(
                            SWITCH #( iv_old_data WHEN abap_true THEN zif_gtt_sts_constants=>cs_tabledef-fo_item_old
                                                  ELSE zif_gtt_sts_constants=>cs_tabledef-fo_item_new ) )
      CHANGING
        cs_fo_header  = <ls_freight_order> ).

    get_data_from_textcoll(
      EXPORTING
        iv_old_data   = iv_old_data
        ir_root       = lr_maintabref
      CHANGING
        cs_fo_header  = <ls_freight_order> ).
    IF <ls_freight_order>-tracked_object_id IS INITIAL.
      APPEND '' TO <ls_freight_order>-tracked_object_id.
    ENDIF.

    TEST-SEAM get_docref_data.
      get_docref_data(
        EXPORTING
          iv_old_data     = iv_old_data
          ir_root         = lr_maintabref
        CHANGING
          ct_carrier_ref_value = <ls_freight_order>-carrier_ref_value
          ct_carrier_ref_type  = <ls_freight_order>-carrier_ref_type
          ct_shipper_ref_value = <ls_freight_order>-shipper_ref_value
          ct_shipper_ref_type  = <ls_freight_order>-shipper_ref_type ).
    END-TEST-SEAM.
    IF <ls_freight_order>-carrier_ref_value IS INITIAL.
      APPEND '' TO <ls_freight_order>-carrier_ref_value.
    ENDIF.
    IF <ls_freight_order>-shipper_ref_value IS INITIAL.
      APPEND '' TO <ls_freight_order>-shipper_ref_value.
    ENDIF.

    TEST-SEAM get_data_from_stop.
      get_data_from_stop(
        EXPORTING
          ir_data             = lr_maintabref
          iv_old_data         = iv_old_data
        CHANGING
          cv_pln_dep_loc_id   = <ls_freight_order>-pln_dep_loc_id
          cv_pln_dep_loc_type = <ls_freight_order>-pln_dep_loc_type
          cv_pln_dep_timest   = <ls_freight_order>-pln_dep_timest
          cv_pln_dep_timezone = <ls_freight_order>-pln_dep_timezone
          cv_pln_arr_loc_id   = <ls_freight_order>-pln_arr_loc_id
          cv_pln_arr_loc_type = <ls_freight_order>-pln_arr_loc_type
          cv_pln_arr_timest   = <ls_freight_order>-pln_arr_timest
          cv_pln_arr_timezone = <ls_freight_order>-pln_arr_timezone
          ct_stop_id          = <ls_freight_order>-stop_id
          ct_ordinal_no       = <ls_freight_order>-ordinal_no
          ct_loc_type         = <ls_freight_order>-loc_type
          ct_loc_id           = <ls_freight_order>-loc_id ).
    END-TEST-SEAM.

    TEST-SEAM get_requirement_doc_list.
      get_requirement_doc_list(
        EXPORTING
          ir_data               = lr_maintabref
          iv_old_data           = iv_old_data
        CHANGING
          ct_req_doc_line_no    = <ls_freight_order>-req_doc_line_no
          ct_req_doc_no         = <ls_freight_order>-req_doc_no ).
    END-TEST-SEAM.
    IF <ls_freight_order>-req_doc_no IS INITIAL.
      APPEND '' TO <ls_freight_order>-req_doc_line_no.
    ENDIF.

  ENDMETHOD.


  METHOD zif_gtt_sts_bo_reader~get_track_id_data.

    DATA:
      lv_fotrxcod  TYPE /saptrx/trxcod.

    FIELD-SYMBOLS:
      <ls_root_new>  TYPE /scmtms/s_em_bo_tor_root.

    CLEAR et_track_id_data.

    lv_fotrxcod = zif_gtt_sts_constants=>cs_trxcod-fo_number.

    ASSIGN is_app_object-maintabref->* TO <ls_root_new>.
    IF <ls_root_new> IS NOT ASSIGNED.
      MESSAGE e010(zgtt_sts) INTO DATA(lv_dummy) ##needed.
      zcl_gtt_sts_tools=>throw_exception( ).
    ENDIF.

    add_track_id_data(
      EXPORTING
        is_app_object = is_app_object
        iv_trxcod     = lv_fotrxcod
        iv_trxid      = |{ <ls_root_new>-tor_id  ALPHA = OUT }|
      CHANGING
        ct_track_id   = et_track_id_data ).

  ENDMETHOD.


  METHOD get_requirement_doc_list.

    DATA:
      lv_freight_unit_line_no TYPE int4.

    zcl_gtt_sts_tools=>get_req_info_mul(
      EXPORTING
        ir_root     = ir_data
        iv_old_data = iv_old_data
      IMPORTING
        et_req      = DATA(lt_req) ).

    LOOP AT lt_req INTO DATA(ls_req).
      lv_freight_unit_line_no = lv_freight_unit_line_no + 1.
      APPEND lv_freight_unit_line_no TO ct_req_doc_line_no.
      APPEND |{ ls_req-tor_id ALPHA = OUT }| TO ct_req_doc_no.
    ENDLOOP.

  ENDMETHOD.
ENDCLASS.
