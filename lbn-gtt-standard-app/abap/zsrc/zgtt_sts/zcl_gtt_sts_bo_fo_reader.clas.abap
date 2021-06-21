CLASS zcl_gtt_sts_bo_fo_reader DEFINITION
  PUBLIC
  INHERITING FROM zcl_gtt_sts_bo_tor_reader
  CREATE PUBLIC .

  PUBLIC SECTION.

    METHODS zif_gtt_sts_bo_reader~get_data
        REDEFINITION .
    METHODS zif_gtt_sts_bo_reader~get_track_id_data
        REDEFINITION .
  PROTECTED SECTION.
  PRIVATE SECTION.

    TYPES:
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
      END OF ts_fo_header .

    METHODS get_data_from_root
      IMPORTING
        !iv_old_data  TYPE abap_bool DEFAULT abap_false
        !ir_root      TYPE REF TO data
      CHANGING
        !cs_fo_header TYPE ts_fo_header
      RAISING
        cx_udm_message .
    METHODS get_data_from_item
      IMPORTING
        !iv_old_data  TYPE abap_bool DEFAULT abap_false   ##NEEDED
        !ir_item      TYPE REF TO data
      CHANGING
        !cs_fo_header TYPE ts_fo_header
      RAISING
        cx_udm_message .
    METHODS get_data_from_textcoll
      IMPORTING
        !iv_old_data  TYPE abap_bool DEFAULT abap_false
        !ir_root      TYPE REF TO data
      CHANGING
        !cs_fo_header TYPE ts_fo_header
      RAISING
        cx_udm_message .
    METHODS get_maintabref
      IMPORTING
        !is_app_object       TYPE trxas_appobj_ctab_wa
      RETURNING
        VALUE(rr_maintabref) TYPE REF TO data .
ENDCLASS.



CLASS ZCL_GTT_STS_BO_FO_READER IMPLEMENTATION.


  METHOD get_data_from_item.

    FIELD-SYMBOLS <lt_item> TYPE /scmtms/t_em_bo_tor_item.

    ASSIGN ir_item->* TO <lt_item>.
    IF sy-subrc <> 0.
      MESSAGE e010(zgtt_sts) INTO DATA(lv_dummy) ##needed.
      zcl_gtt_sts_tools=>throw_exception( ).
    ENDIF.

    ASSIGN <lt_item>[ item_cat = /scmtms/if_tor_const=>sc_tor_item_category-av_item ] TO FIELD-SYMBOL(<ls_item>).
    IF sy-subrc <> 0.
      MESSAGE e010(zgtt_sts) INTO lv_dummy.
      zcl_gtt_sts_tools=>throw_exception( ).
    ENDIF.

    cs_fo_header-inc_class_code   =  <ls_item>-inc_class_code.
    cs_fo_header-inc_transf_loc_n =  <ls_item>-inc_transf_loc_n.
    cs_fo_header-country          =  <ls_item>-country.
    cs_fo_header-platenumber      =  <ls_item>-platenumber.
    cs_fo_header-res_id           =  <ls_item>-res_id.

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
      cs_fo_header-pln_grs_duration = <ls_tor_additional_info>-tot_duration.
    ENDIF.

    cs_fo_header-shipment_type = zif_gtt_sts_constants=>cs_shipment_type-tor.
    cs_fo_header-tspid = get_carrier_name( iv_tspid = cs_fo_header-tspid ).
    IF cs_fo_header-total_distance_km IS NOT INITIAL.
      cs_fo_header-total_distance_km_uom = zif_gtt_sts_constants=>cs_uom-km.
    ENDIF.
    SELECT SINGLE motscode
      FROM /sapapo/trtype
      INTO cs_fo_header-mtr
      WHERE ttype = cs_fo_header-mtr.

    SHIFT cs_fo_header-mtr    LEFT DELETING LEADING '0'.
    SHIFT cs_fo_header-tor_id LEFT DELETING LEADING '0'.
    cs_fo_header-trmodcod = zcl_gtt_sts_tools=>get_trmodcod( iv_trmodcod = cs_fo_header-trmodcod ).

  ENDMETHOD.


  METHOD get_data_from_textcoll.

    get_container_and_mobile_track(
      EXPORTING
        ir_data         = ir_root
        iv_old_data     = iv_old_data
      CHANGING
        ct_tracked_object_type = cs_fo_header-tracked_object_type
        ct_tracked_object_id   = cs_fo_header-tracked_object_id ).

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

    get_docref_data(
      EXPORTING
        iv_old_data     = iv_old_data
        ir_root         = lr_maintabref
      CHANGING
        ct_carrier_ref_value = <ls_freight_order>-carrier_ref_value
        ct_carrier_ref_type  = <ls_freight_order>-carrier_ref_type
        ct_shipper_ref_value = <ls_freight_order>-shipper_ref_value
        ct_shipper_ref_type  = <ls_freight_order>-shipper_ref_type ).
    IF <ls_freight_order>-carrier_ref_value IS INITIAL.
      APPEND '' TO <ls_freight_order>-carrier_ref_value.
    ENDIF.
    IF <ls_freight_order>-shipper_ref_value IS INITIAL.
      APPEND '' TO <ls_freight_order>-shipper_ref_value.
    ENDIF.

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

    get_requirement_doc_list(
      EXPORTING
        ir_data            = lr_maintabref
        iv_old_data        = iv_old_data
      CHANGING
        ct_req_doc_line_no     = <ls_freight_order>-req_doc_line_no
        ct_req_doc_no          = <ls_freight_order>-req_doc_no
        ct_req_doc_first_stop = <ls_freight_order>-req_doc_first_stop
        ct_req_doc_last_stop  = <ls_freight_order>-req_doc_last_stop  ).
    IF <ls_freight_order>-req_doc_no IS INITIAL.
      APPEND '' TO <ls_freight_order>-req_doc_line_no.
    ENDIF.

  ENDMETHOD.


  METHOD zif_gtt_sts_bo_reader~get_track_id_data.

    DATA:
      lr_item_new          TYPE REF TO data,
      lr_item_old          TYPE REF TO data,
      lr_root_old          TYPE REF TO data,
      lt_track_id_data_new TYPE zif_gtt_sts_ef_types=>tt_enh_track_id_data,
      lt_track_id_data_old TYPE zif_gtt_sts_ef_types=>tt_enh_track_id_data.

    FIELD-SYMBOLS:
      <lt_item_new>         TYPE /scmtms/t_em_bo_tor_item,
      <lt_item_old>         TYPE /scmtms/t_em_bo_tor_item,
      <ls_root_new>         TYPE /scmtms/s_em_bo_tor_root,
      <lt_root_old>         TYPE /scmtms/t_em_bo_tor_root,
      <lt_tor_req_root_new> TYPE /scmtms/t_em_bo_tor_root,
      <lt_tor_req_root_old> TYPE /scmtms/t_em_bo_tor_root.

    ASSIGN is_app_object-maintabref->* TO <ls_root_new>.

    lr_root_old = mo_ef_parameters->get_appl_table( iv_tabledef = zif_gtt_sts_constants=>cs_tabledef-fo_header_old ).
    ASSIGN lr_root_old->* TO <lt_root_old>.
    IF <ls_root_new> IS NOT ASSIGNED OR <lt_root_old> IS NOT ASSIGNED.
      MESSAGE e010(zgtt_sts) INTO DATA(lv_dummy) ##needed.
      zcl_gtt_sts_tools=>throw_exception( ).
    ENDIF.

    add_track_id_data(
      EXPORTING
        is_app_object = is_app_object
        iv_trxcod     = zif_gtt_sts_constants=>cs_trxcod-fo_number
        iv_trxid      = |{ <ls_root_new>-tor_id }|
      CHANGING
        ct_track_id   = et_track_id_data ).

    get_container_mobile_track_id(
      EXPORTING
        is_app_object    = is_app_object
      CHANGING
        ct_track_id_data = lt_track_id_data_new ).

    get_container_mobile_track_id(
      EXPORTING
        is_app_object    = is_app_object
        iv_old_data      = abap_true
      CHANGING
        ct_track_id_data = lt_track_id_data_old ).

    lr_item_new = mo_ef_parameters->get_appl_table( iv_tabledef = zif_gtt_sts_constants=>cs_tabledef-fo_item_new ).
    lr_item_old = mo_ef_parameters->get_appl_table( iv_tabledef = zif_gtt_sts_constants=>cs_tabledef-fo_item_old ).
    DATA(lr_tor_req_root_new) = mo_ef_parameters->get_appl_table( /scmtms/cl_scem_int_c=>sc_table_definition-bo_tor-req_root ).
    DATA(lr_tor_req_root_old) = mo_ef_parameters->get_appl_table( /scmtms/cl_scem_int_c=>sc_table_definition-bo_tor-req_root_before ).

    ASSIGN <lt_root_old>[ node_id = <ls_root_new>-node_id ] TO FIELD-SYMBOL(<ls_root_old>).
    IF sy-subrc = 0.
      DATA(lv_deleted) = zcl_gtt_sts_tools=>check_is_fo_deleted(
                          is_root_new = <ls_root_new>
                          is_root_old = <ls_root_old> ).
      IF lv_deleted = zif_gtt_sts_ef_constants=>cs_condition-true.
        CLEAR: lt_track_id_data_old, lr_item_old, lr_tor_req_root_old.
      ENDIF.
    ENDIF.

    ASSIGN lr_tor_req_root_new->* TO <lt_tor_req_root_new>.
    IF <lt_tor_req_root_new> IS ASSIGNED.
      LOOP AT <lt_tor_req_root_new> ASSIGNING FIELD-SYMBOL(<ls_tor_req_root_new>).
        IF <ls_tor_req_root_new>-tor_root_node IS ASSIGNED AND <ls_tor_req_root_new>-tor_cat = /scmtms/if_tor_const=>sc_tor_category-freight_unit AND
           <ls_tor_req_root_new>-tor_root_node = <ls_root_new>-node_id.

          APPEND VALUE #( key = <ls_tor_req_root_new>-tor_id
                  appsys      = mo_ef_parameters->get_appsys( )
                  appobjtype  = is_app_object-appobjtype
                  appobjid    = is_app_object-appobjid
                  trxcod      = zif_gtt_sts_constants=>cs_trxcod-fu_number
                  trxid       = <ls_tor_req_root_new>-tor_id
                  start_date  = zcl_gtt_sts_tools=>get_system_date_time( )
                  end_date    = zif_gtt_sts_ef_constants=>cv_max_end_date
                  timzon      = zcl_gtt_sts_tools=>get_system_time_zone( )
                  msrid       = space  ) TO lt_track_id_data_new.
        ENDIF.
      ENDLOOP.
    ENDIF.

    ASSIGN lr_tor_req_root_old->* TO <lt_tor_req_root_old>.
    IF sy-subrc = 0 AND lv_deleted = zif_gtt_sts_ef_constants=>cs_condition-false.
      LOOP AT <lt_tor_req_root_old> ASSIGNING FIELD-SYMBOL(<ls_tor_req_root_old>).
        IF <ls_tor_req_root_old>-tor_root_node IS ASSIGNED AND <ls_tor_req_root_old>-tor_cat = /scmtms/if_tor_const=>sc_tor_category-freight_unit AND
           <ls_tor_req_root_old>-tor_root_node = <ls_root_new>-node_id.

          APPEND VALUE #( key = <ls_tor_req_root_old>-tor_id
                  appsys      = mo_ef_parameters->get_appsys( )
                  appobjtype  = is_app_object-appobjtype
                  appobjid    = is_app_object-appobjid
                  trxcod      = zif_gtt_sts_constants=>cs_trxcod-fu_number
                  trxid       = <ls_tor_req_root_old>-tor_id
                  start_date  = zcl_gtt_sts_tools=>get_system_date_time( )
                  end_date    = zif_gtt_sts_ef_constants=>cv_max_end_date
                  timzon      = zcl_gtt_sts_tools=>get_system_time_zone( )
                  msrid       = space  ) TO lt_track_id_data_old.
        ENDIF.
      ENDLOOP.
    ENDIF.

    ASSIGN lr_item_new->* TO <lt_item_new>.
    IF sy-subrc = 0.
      zcl_gtt_sts_tools=>get_fo_tracked_item_obj(
          EXPORTING
            is_app_object    = is_app_object
            is_root          = <ls_root_new>
            it_item          = <lt_item_new>
            iv_appsys        = mo_ef_parameters->get_appsys( )
            iv_old_data      = abap_false
         CHANGING
            ct_track_id_data = lt_track_id_data_new ).
    ELSE.
      MESSAGE e010(zgtt_sts) INTO lv_dummy.
      zcl_gtt_sts_tools=>throw_exception( ).
    ENDIF.

    ASSIGN lr_item_old->* TO <lt_item_old>.
    IF sy-subrc = 0 AND lv_deleted = zif_gtt_sts_ef_constants=>cs_condition-false.
      zcl_gtt_sts_tools=>get_fo_tracked_item_obj(
        EXPORTING
          is_app_object = is_app_object
          is_root       = <ls_root_old>
          it_item       = <lt_item_old>
          iv_appsys     = mo_ef_parameters->get_appsys( )
          iv_old_data   = abap_true
       CHANGING
          ct_track_id_data = lt_track_id_data_old ).
    ENDIF.

    zcl_gtt_sts_tools=>get_track_obj_changes(
       EXPORTING
         is_app_object        = is_app_object
         iv_appsys            = mo_ef_parameters->get_appsys( )
         it_track_id_data_new = lt_track_id_data_new
         it_track_id_data_old = lt_track_id_data_old
       CHANGING
         ct_track_id_data     = et_track_id_data ).

  ENDMETHOD.
ENDCLASS.
