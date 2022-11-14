class ZCL_GTT_STS_BO_TRK_ONCU_FO definition
  public
  inheriting from ZCL_GTT_STS_BO_TOR_READER
  create public .

public section.

  methods ZIF_GTT_STS_BO_READER~GET_DATA
    redefinition .
  methods ZIF_GTT_STS_BO_READER~GET_TRACK_ID_DATA
    redefinition .
protected section.

  methods GET_HEADER_DATA_FROM_STOP
    redefinition .
  methods GET_STOP_SEQ
    redefinition .
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
      tu_line_no            TYPE tt_tu_line_no,
      tu_type               TYPE tt_tu_type,
      tu_value              TYPE tt_tu_value,
      tu_number             TYPE tt_tu_number,
      tu_first_stop         TYPE tt_tu_first_stop,
      tu_last_stop          TYPE tt_tu_last_stop,
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
  methods GET_TRACKING_UNIT
    importing
      !IR_DATA type ref to DATA
      !IV_OLD_DATA type ABAP_BOOL default ABAP_FALSE
    changing
      !CS_FO_HEADER type TS_FO_HEADER
    raising
      CX_UDM_MESSAGE .
ENDCLASS.



CLASS ZCL_GTT_STS_BO_TRK_ONCU_FO IMPLEMENTATION.


  METHOD GET_DATA_FROM_ITEM.

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


  METHOD GET_DATA_FROM_ROOT.

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


  METHOD GET_DATA_FROM_TEXTCOLL.

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


  METHOD GET_HEADER_DATA_FROM_STOP.

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

      IF <ls_tor_root>-stop_seq_type <> /scmtms/if_tor_const=>sc_stop_sequence-manifest."Star-Shaped Based on FU Stages
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
    ENDIF.

  ENDMETHOD.


  METHOD GET_MAINTABREF.

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


  METHOD GET_STOP_SEQ.

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

    IF <ls_tor_root>-stop_seq_type <> /scmtms/if_tor_const=>sc_stop_sequence-manifest."Star-Shaped Based on FU Stages
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
    ENDIF.

    IF ct_ordinal_no IS INITIAL.
      APPEND '' TO ct_ordinal_no.
    ENDIF.

  ENDMETHOD.


  METHOD get_tracking_unit.

    FIELD-SYMBOLS:
      <lt_tor_root_req>    TYPE /scmtms/t_em_bo_tor_root.

    DATA:
      ls_container     TYPE ts_container,
      lt_container     TYPE tt_container,
      lt_tmp_container TYPE tt_container,
      lt_tmp_cont      TYPE TABLE OF /scmtms/package_id,
      lt_stop_info     TYPE tt_stop_info,
      lv_tor_id        TYPE /scmtms/tor_id,
      lt_req_tor       TYPE /scmtms/t_em_bo_tor_root,
      lv_prefix        TYPE char20,
      lv_suffix        TYPE char4,
      lv_length        TYPE i,
      lv_line_no       TYPE int4,
      lv_tmp_value     TYPE char255.

    zcl_gtt_sts_tools=>get_req_stop_info(
      EXPORTING
        ir_root     = ir_data
        iv_old_data = iv_old_data
      IMPORTING
        et_req_stop = DATA(lt_req_stop) ).

    zcl_gtt_sts_tools=>get_req_info(
      EXPORTING
        ir_root     = ir_data
        iv_old_data = iv_old_data
      IMPORTING
        et_req_tor  = lt_req_tor ).

    LOOP AT lt_req_tor ASSIGNING FIELD-SYMBOL(<ls_tor_root_req>).

      lv_tor_id = <ls_tor_root_req>-tor_id.
      SHIFT lv_tor_id LEFT DELETING LEADING '0'.

      zcl_gtt_sts_tools=>get_container_num_on_cu(
        EXPORTING
          ir_root      = REF #( <ls_tor_root_req> )
          iv_old_data  = iv_old_data
        IMPORTING
          et_container = lt_tmp_cont ).

      LOOP AT lt_tmp_cont INTO DATA(ls_tmp_cont).
        ls_container-object_id = cs_track_id-container_id.
        ls_container-object_value = ls_tmp_cont.
        APPEND ls_container TO lt_container.
        CLEAR ls_container.
      ENDLOOP.

      LOOP AT lt_container INTO ls_container.
        lv_line_no = lv_line_no + 1.
        APPEND lv_line_no TO cs_fo_header-tu_line_no.
        APPEND ls_container-object_id TO cs_fo_header-tu_type.
        APPEND ls_container-object_value TO cs_fo_header-tu_value.

        CLEAR lv_tmp_value.
        lv_tmp_value = |{ lv_tor_id }{ ls_container-object_value }|.
        CONDENSE lv_tmp_value NO-GAPS.
        APPEND lv_tmp_value TO cs_fo_header-tu_number.

        READ TABLE lt_req_stop INTO DATA(ls_req_stop) WITH KEY tor_id = lv_tor_id.
        IF sy-subrc = 0.
          lv_length = strlen( ls_req_stop-first_stop ) - 4.
          lv_prefix = ls_req_stop-first_stop+0(lv_length).
          lv_suffix = ls_req_stop-first_stop+lv_length(*).

          CLEAR lv_tmp_value.
          lv_tmp_value = |{ lv_prefix }{ ls_container-object_value }{ lv_suffix }|.
          CONDENSE lv_tmp_value NO-GAPS.
          APPEND lv_tmp_value TO cs_fo_header-tu_first_stop.

          lv_length = strlen( ls_req_stop-last_stop ) - 4.
          lv_prefix = ls_req_stop-last_stop+0(lv_length).
          lv_suffix = ls_req_stop-last_stop+lv_length(*).

          CLEAR lv_tmp_value.
          lv_tmp_value = |{ lv_prefix }{ ls_container-object_value }{ lv_suffix }|.
          CONDENSE lv_tmp_value NO-GAPS.
          APPEND lv_tmp_value TO cs_fo_header-tu_last_stop.

        ENDIF.

        CLEAR:
          lv_length,
          lv_prefix,
          lv_suffix,
          lv_tmp_value.
      ENDLOOP.

      CLEAR:
        lt_tmp_cont,
        lt_container.
    ENDLOOP.

  ENDMETHOD.


  METHOD ZIF_GTT_STS_BO_READER~GET_DATA.

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
        iv_old_data  = iv_old_data
        ir_root      = lr_maintabref
      CHANGING
        cs_fo_header = <ls_freight_order> ).
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

    TEST-SEAM get_docref_data.
      get_docref_data(
        EXPORTING
          iv_old_data          = iv_old_data
          ir_root              = lr_maintabref
        CHANGING
          ct_carrier_ref_value = <ls_freight_order>-carrier_ref_value
          ct_carrier_ref_type  = <ls_freight_order>-carrier_ref_type
          ct_shipper_ref_value = <ls_freight_order>-shipper_ref_value
          ct_shipper_ref_type  = <ls_freight_order>-shipper_ref_type ).
    END-TEST-SEAM.

    CLEAR:
       <ls_freight_order>-carrier_ref_value,
       <ls_freight_order>-carrier_ref_type.

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
          ir_data            = lr_maintabref
          iv_old_data        = iv_old_data
        CHANGING
          ct_req_doc_line_no = <ls_freight_order>-req_doc_line_no
          ct_req_doc_no      = <ls_freight_order>-req_doc_no ).
    END-TEST-SEAM.
    IF <ls_freight_order>-req_doc_no IS INITIAL.
      APPEND '' TO <ls_freight_order>-req_doc_line_no.
    ENDIF.

*   trackingUnits
    get_tracking_unit(
      EXPORTING
        ir_data      = lr_maintabref
        iv_old_data  = iv_old_data
      CHANGING
        cs_fo_header = <ls_freight_order> ).

    IF <ls_freight_order>-tu_line_no IS INITIAL.
      APPEND '' TO <ls_freight_order>-tu_line_no.
    ENDIF.

  ENDMETHOD.


  METHOD zif_gtt_sts_bo_reader~get_track_id_data.

    FIELD-SYMBOLS:
      <ls_root_new>         TYPE /scmtms/s_em_bo_tor_root,
      <lt_root_old>         TYPE /scmtms/t_em_bo_tor_root,
      <lt_tor_root_req_new> TYPE /scmtms/t_em_bo_tor_root,
      <lt_tor_root_req_old> TYPE /scmtms/t_em_bo_tor_root.

    DATA:
      lr_root_old          TYPE REF TO data,
      lt_track_id_data_new TYPE zif_gtt_sts_ef_types=>tt_enh_track_id_data,
      lt_track_id_data_old TYPE zif_gtt_sts_ef_types=>tt_enh_track_id_data,
      lv_fotrxcod          TYPE /saptrx/trxcod,
      lt_container         TYPE TABLE OF /scmtms/package_id,
      lt_package_id        TYPE TABLE OF /scmtms/package_id,
      lt_req_tor_new       TYPE /scmtms/t_em_bo_tor_root,
      lt_req_tor_old       TYPE /scmtms/t_em_bo_tor_root,
      lv_trxid             TYPE /saptrx/trxid,
      lv_tutrxcod          TYPE /saptrx/trxcod.

    ASSIGN is_app_object-maintabref->* TO <ls_root_new>.

    lr_root_old = mo_ef_parameters->get_appl_table( iv_tabledef = zif_gtt_sts_constants=>cs_tabledef-fo_header_old ).
    ASSIGN lr_root_old->* TO <lt_root_old>.
    IF <ls_root_new> IS NOT ASSIGNED OR <lt_root_old> IS NOT ASSIGNED.
      MESSAGE e010(zgtt_sts) INTO DATA(lv_dummy) ##needed.
      zcl_gtt_sts_tools=>throw_exception( ).
    ENDIF.

    lv_fotrxcod = zif_gtt_sts_constants=>cs_trxcod-fo_number.
    lv_tutrxcod = zif_gtt_sts_constants=>cs_trxcod-tu_number.

    add_track_id_data(
      EXPORTING
        is_app_object = is_app_object
        iv_trxcod     = lv_fotrxcod
        iv_trxid      = |{ <ls_root_new>-tor_id  ALPHA = OUT }|
      CHANGING
        ct_track_id   = et_track_id_data ).

    zcl_gtt_sts_tools=>get_req_info(
      EXPORTING
        ir_root     = REF #( <ls_root_new> )
        iv_old_data = abap_false
      IMPORTING
        et_req_tor  = lt_req_tor_new ).

    LOOP AT lt_req_tor_new ASSIGNING FIELD-SYMBOL(<ls_tor_root_req_new>)
      WHERE tor_cat = /scmtms/if_tor_const=>sc_tor_category-transp_unit.
      CLEAR:
        lt_container.

      DATA(lv_tor_id) = |{ <ls_tor_root_req_new>-tor_id  ALPHA = OUT }|.
      CONDENSE lv_tor_id.

      zcl_gtt_sts_tools=>get_container_num_on_cu(
        EXPORTING
          ir_root      = REF #( <ls_tor_root_req_new> )
          iv_old_data  = abap_false
        IMPORTING
          et_container = lt_container ).

      LOOP AT lt_container INTO DATA(ls_container).
        CLEAR lv_trxid.
        lv_trxid = |{ lv_tor_id } { ls_container }|.
        CONDENSE lv_trxid NO-GAPS.

        APPEND VALUE #( key = |{ <ls_tor_root_req_new>-tor_id ALPHA = OUT }|
                appsys      = mo_ef_parameters->get_appsys( )
                appobjtype  = is_app_object-appobjtype
                appobjid    = |{ is_app_object-appobjid ALPHA = OUT }|
                trxcod      = lv_tutrxcod
                trxid       = lv_trxid ) TO lt_track_id_data_new.

      ENDLOOP.
    ENDLOOP.

    CLEAR:
      lt_container.

    zcl_gtt_sts_tools=>get_req_info(
      EXPORTING
        ir_root     = REF #( <ls_root_new> )
        iv_old_data = abap_true
      IMPORTING
        et_req_tor  = lt_req_tor_old ).

    LOOP AT lt_req_tor_old ASSIGNING FIELD-SYMBOL(<ls_tor_root_req_old>)
      WHERE tor_cat = /scmtms/if_tor_const=>sc_tor_category-transp_unit.
      CLEAR:
        lt_container.

      lv_tor_id = |{ <ls_tor_root_req_old>-tor_id  ALPHA = OUT }|.
      CONDENSE lv_tor_id.

      zcl_gtt_sts_tools=>get_container_num_on_cu(
        EXPORTING
          ir_root      = REF #( <ls_tor_root_req_old> )
          iv_old_data  = abap_true
        IMPORTING
          et_container = lt_container ).

      LOOP AT lt_container INTO ls_container.
        CLEAR lv_trxid.
        lv_trxid = |{ lv_tor_id } { ls_container }|.
        CONDENSE lv_trxid NO-GAPS.

        APPEND VALUE #( key = |{ <ls_tor_root_req_old>-tor_id ALPHA = OUT }|
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


  METHOD get_requirement_doc_list.

    FIELD-SYMBOLS:
      <ls_tor_root>        TYPE /scmtms/s_em_bo_tor_root.

    DATA:
      lt_req_tor              TYPE /scmtms/t_tor_root_k,
      lv_freight_unit_line_no TYPE int4.

    ASSIGN ir_data->* TO <ls_tor_root>.
    IF sy-subrc <> 0.
      MESSAGE e010(zgtt_sts) INTO DATA(lv_dummy) ##needed.
      zcl_gtt_sts_tools=>throw_exception( ).
    ENDIF.

    DATA(lo_tor_srv_mgr) = /bobf/cl_tra_serv_mgr_factory=>get_service_manager( iv_bo_key = /scmtms/if_tor_c=>sc_bo_key ).

    lo_tor_srv_mgr->retrieve_by_association(
      EXPORTING
        iv_node_key     = /scmtms/if_tor_c=>sc_node-root
        it_key          = VALUE #( ( key = <ls_tor_root>-node_id ) )
        iv_association  = /scmtms/if_tor_c=>sc_association-root-req_tor
        iv_before_image = iv_old_data
      IMPORTING
        et_key_link     = DATA(lt_capa2req_link) ).

    lo_tor_srv_mgr->retrieve_by_association(
      EXPORTING
        iv_node_key     = /scmtms/if_tor_c=>sc_node-root
        it_key          = CORRESPONDING #( lt_capa2req_link MAPPING key = target_key )
        iv_association  = /scmtms/if_tor_c=>sc_association-root-req_tor
        iv_before_image = iv_old_data
        iv_fill_data    = abap_true
      IMPORTING
        et_data         = lt_req_tor ).

    LOOP AT lt_req_tor INTO DATA(ls_req_tor).

      lv_freight_unit_line_no += 1.
      APPEND lv_freight_unit_line_no TO ct_req_doc_line_no.

      APPEND |{ ls_req_tor-tor_id ALPHA = OUT }| TO ct_req_doc_no.

    ENDLOOP.

  ENDMETHOD.
ENDCLASS.
