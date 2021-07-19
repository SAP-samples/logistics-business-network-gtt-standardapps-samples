CLASS zcl_gtt_sts_bo_tor_reader DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES zif_gtt_sts_bo_reader .

    METHODS constructor
      IMPORTING
        !io_ef_parameters TYPE REF TO zif_gtt_sts_ef_parameters .
  PROTECTED SECTION.

    TYPES tv_tracked_object_type TYPE string .
    TYPES:
      tt_tracked_object_type TYPE STANDARD TABLE OF tv_tracked_object_type WITH EMPTY KEY .
    TYPES tv_tracked_object_id TYPE char20 .
    TYPES:
      tt_tracked_object_id TYPE STANDARD TABLE OF tv_tracked_object_type WITH EMPTY KEY .
    TYPES tv_carrier_ref_value TYPE /scmtms/btd_id .
    TYPES:
      tt_carrier_ref_value TYPE STANDARD TABLE OF tv_carrier_ref_value WITH EMPTY KEY .
    TYPES tv_carrier_ref_type TYPE char35 .
    TYPES:
      tt_carrier_ref_type TYPE STANDARD TABLE OF tv_carrier_ref_type WITH EMPTY KEY .
    TYPES tv_shipper_ref_value TYPE /scmtms/btd_id .
    TYPES:
      tt_shipper_ref_value TYPE STANDARD TABLE OF tv_shipper_ref_value WITH EMPTY KEY .
    TYPES tv_shipper_ref_type TYPE char35 .
    TYPES:
      tt_shipper_ref_type TYPE STANDARD TABLE OF tv_shipper_ref_type WITH EMPTY KEY .
    TYPES tv_stop_id TYPE string .
    TYPES:
      tt_stop_id TYPE STANDARD TABLE OF tv_stop_id WITH EMPTY KEY .
    TYPES tv_ordinal_no TYPE int4 .
    TYPES:
      tt_ordinal_no TYPE STANDARD TABLE OF tv_ordinal_no WITH EMPTY KEY .
    TYPES tv_loc_type TYPE /saptrx/loc_id_type .
    TYPES:
      tt_loc_type TYPE STANDARD TABLE OF tv_loc_type WITH EMPTY KEY .
    TYPES tv_loc_id TYPE /scmtms/location_id .
    TYPES:
      tt_loc_id TYPE STANDARD TABLE OF tv_loc_id WITH EMPTY KEY .
    TYPES:
      tt_req_doc_line_number TYPE STANDARD TABLE OF int4 WITH EMPTY KEY .
    TYPES:
      tt_req_doc_number      TYPE STANDARD TABLE OF /scmtms/tor_id WITH EMPTY KEY .
    TYPES:
      tt_capacity_doc_line_number  TYPE STANDARD TABLE OF int4 WITH EMPTY KEY .
    TYPES:
      tt_capacity_doc_number TYPE STANDARD TABLE OF /scmtms/tor_id WITH EMPTY KEY .
    TYPES:
      tt_stop TYPE STANDARD TABLE OF /saptrx/loc_id_2 WITH EMPTY KEY .

    CONSTANTS:
      BEGIN OF cs_text_type,
        cont TYPE /bobf/txc_text_type VALUE 'CONT',
        mobl TYPE /bobf/txc_text_type VALUE 'MOBL',
      END OF cs_text_type .
    CONSTANTS:
      BEGIN OF cs_track_id,
        container_id  TYPE tv_tracked_object_type VALUE 'CONTAINER_ID',
        mobile_number TYPE tv_tracked_object_type VALUE 'MOBILE_NUMBER',
        truck_id      TYPE tv_tracked_object_type VALUE 'TRUCK_ID',
        license_plate TYPE tv_tracked_object_type VALUE 'LICENSE_PLATE',
        vessel        TYPE tv_tracked_object_type VALUE 'VESSEL',
        flight_number TYPE tv_tracked_object_type VALUE 'FLIGHT_NUMBER',
      END OF cs_track_id .
    CONSTANTS:
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
        estimated_datetime    TYPE /saptrx/paramname VALUE 'YN_SHP_ESTIMATED_DATETIME',
        estimated_timezone    TYPE /saptrx/paramname VALUE 'YN_SHP_ESTIMATED_TIMEZONE',
      END OF cs_mapping .
    CONSTANTS cs_bp_type TYPE bu_id_type VALUE 'LBN001' ##NO_TEXT.
    DATA mo_ef_parameters TYPE REF TO zif_gtt_sts_ef_parameters .

    METHODS get_data_from_text_collection
      IMPORTING
        !ir_data         TYPE REF TO data
        !iv_old_data     TYPE abap_bool DEFAULT abap_false
      EXPORTING
        !er_text         TYPE REF TO /bobf/t_txc_txt_k
        !er_text_content TYPE REF TO /bobf/t_txc_con_k
      RAISING
        cx_udm_message .
    METHODS get_container_and_mobile_track
      IMPORTING
        !ir_data                TYPE REF TO data
        !iv_old_data            TYPE abap_bool DEFAULT abap_false
      CHANGING
        !ct_tracked_object_type TYPE tt_tracked_object_type
        !ct_tracked_object_id   TYPE tt_tracked_object_id
      RAISING
        cx_udm_message .
    METHODS get_container_mobile_track_id
      IMPORTING
        !is_app_object    TYPE trxas_appobj_ctab_wa
        !iv_old_data      TYPE abap_bool DEFAULT abap_false
      CHANGING
        !ct_track_id_data TYPE zif_gtt_sts_ef_types=>tt_enh_track_id_data
      RAISING
        cx_udm_message .
    METHODS add_track_id_data
      IMPORTING
        !is_app_object TYPE trxas_appobj_ctab_wa
        !iv_trxcod     TYPE /saptrx/trxcod
        !iv_trxid      TYPE /saptrx/trxid
        !iv_action     TYPE /saptrx/action OPTIONAL
      CHANGING
        !ct_track_id   TYPE zif_gtt_sts_ef_types=>tt_track_id_data
      RAISING
        cx_udm_message .
    METHODS get_docref_data
      IMPORTING
        !ir_root              TYPE REF TO data
        !iv_old_data          TYPE abap_bool DEFAULT abap_false
      CHANGING
        !ct_carrier_ref_value TYPE tt_carrier_ref_value
        !ct_carrier_ref_type  TYPE tt_carrier_ref_type
        !ct_shipper_ref_value TYPE tt_shipper_ref_value
        !ct_shipper_ref_type  TYPE tt_shipper_ref_type
      RAISING
        cx_udm_message .
    METHODS check_non_idoc_fields
      IMPORTING
        !is_app_object   TYPE trxas_appobj_ctab_wa
      RETURNING
        VALUE(rv_result) TYPE zif_gtt_sts_ef_types=>tv_condition
      RAISING
        cx_udm_message .
    METHODS check_non_idoc_status_fields
      IMPORTING
        !is_app_object   TYPE trxas_appobj_ctab_wa
      RETURNING
        VALUE(rv_result) TYPE zif_gtt_sts_ef_types=>tv_condition
      RAISING
        cx_udm_message .
    METHODS check_non_idoc_stop_fields
      IMPORTING
        !is_app_object   TYPE trxas_appobj_ctab_wa
      RETURNING
        VALUE(rv_result) TYPE zif_gtt_sts_ef_types=>tv_condition
      RAISING
        cx_udm_message .
    METHODS get_header_data_from_stop
      IMPORTING
        !ir_data             TYPE REF TO data
        !iv_old_data         TYPE abap_bool DEFAULT abap_false
        !it_stop_seq         TYPE /scmtms/t_pln_stop_seq_d
      CHANGING
        !cv_pln_dep_loc_id   TYPE /scmtms/s_em_bo_tor_stop-log_locid
        !cv_pln_dep_loc_type TYPE /saptrx/loc_id_type
        !cv_pln_dep_timest   TYPE char16
        !cv_pln_dep_timezone TYPE ad_tzone
        !cv_pln_arr_loc_id   TYPE /scmtms/s_em_bo_tor_stop-log_locid
        !cv_pln_arr_loc_type TYPE /saptrx/loc_id_type
        !cv_pln_arr_timest   TYPE char16
        !cv_pln_arr_timezone TYPE ad_tzone
      RAISING
        cx_udm_message .
    METHODS get_stop_seq
      IMPORTING
        !ir_data       TYPE REF TO data
        !iv_old_data   TYPE abap_bool DEFAULT abap_false
        !it_stop_seq   TYPE /scmtms/t_pln_stop_seq_d
      CHANGING
        !ct_stop_id    TYPE tt_stop_id
        !ct_ordinal_no TYPE tt_ordinal_no
        !ct_loc_type   TYPE tt_loc_type
        !ct_loc_id     TYPE tt_loc_id
      RAISING
        cx_udm_message .
    METHODS get_data_from_stop
      IMPORTING
        !ir_data             TYPE REF TO data
        !iv_old_data         TYPE abap_bool DEFAULT abap_false
      CHANGING
        !cv_pln_dep_loc_id   TYPE /scmtms/s_em_bo_tor_stop-log_locid
        !cv_pln_dep_loc_type TYPE /saptrx/loc_id_type
        !cv_pln_dep_timest   TYPE char16
        !cv_pln_dep_timezone TYPE ad_tzone
        !cv_pln_arr_loc_id   TYPE /scmtms/s_em_bo_tor_stop-log_locid
        !cv_pln_arr_loc_type TYPE /saptrx/loc_id_type
        !cv_pln_arr_timest   TYPE char16
        !cv_pln_arr_timezone TYPE ad_tzone
        !ct_stop_id          TYPE tt_stop_id
        !ct_ordinal_no       TYPE tt_ordinal_no
        !ct_loc_type         TYPE tt_loc_type
        !ct_loc_id           TYPE tt_loc_id
      RAISING
        cx_udm_message .
    METHODS get_customizing_aot
      IMPORTING
        !iv_tor_type  TYPE /scmtms/tor_type
      RETURNING
        VALUE(rv_aot) TYPE /saptrx/aotype .
    METHODS get_requirement_doc_list
      IMPORTING
        !ir_data               TYPE REF TO data
        !iv_old_data           TYPE abap_bool DEFAULT abap_false
      CHANGING
        !ct_req_doc_line_no    TYPE tt_req_doc_line_number
        !ct_req_doc_no         TYPE tt_req_doc_number
        !ct_req_doc_first_stop TYPE tt_stop
        !ct_req_doc_last_stop  TYPE tt_stop
      RAISING
        cx_udm_message .
    METHODS get_carrier_name
      IMPORTING
        !iv_tspid         TYPE bu_id_number
      RETURNING
        VALUE(rv_carrier) TYPE bu_id_number
      RAISING
        cx_udm_message .
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_GTT_STS_BO_TOR_READER IMPLEMENTATION.


  METHOD add_track_id_data.

    APPEND VALUE #( appsys     = mo_ef_parameters->get_appsys( )
                    appobjtype = is_app_object-appobjtype
                    appobjid   = is_app_object-appobjid
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

    SELECT SINGLE idnumber
      FROM but0id
      INTO @DATA(lv_idnumber)
      WHERE partner = @iv_tspid AND
            type    = @cs_bp_type ##WARN_OK.
    IF sy-subrc = 0.
      rv_carrier = lc_lbn && lv_idnumber.
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
    ASSIGN is_app_object-maintabref->* TO <ls_root>.
    IF sy-subrc <> 0.
      MESSAGE e010(zgtt_sts) INTO DATA(lv_dummy) ##needed.
      zcl_gtt_sts_tools=>throw_exception( ).
    ENDIF.

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
          APPEND VALUE #( key = <ls_text_content>-key
                   appsys      = mo_ef_parameters->get_appsys( )
                   appobjtype  = is_app_object-appobjtype
                   appobjid    = is_app_object-appobjid
                   trxcod      = zif_gtt_sts_constants=>cs_trxcod-fo_resource
                   trxid       = |{ <ls_root>-tor_id }{ <ls_text_content>-text }| ) TO ct_track_id_data.
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

*    IF sy-uname <> 'C5204218'.
    /scmtms/cl_tor_helper_stop=>get_stop_sequence(
      EXPORTING
        it_root_key     = VALUE #( ( key = <ls_tor_root>-node_id ) )
        iv_before_image = SWITCH #( iv_old_data WHEN abap_true THEN abap_true ELSE abap_false )
      IMPORTING
        et_stop_seq_d   = DATA(lt_stop_seq) ).

*    ELSE.
*      DATA lt_stop TYPE /scmtms/t_tor_stop_k.
**
*      DATA(lo_srvmgr_tor) = /bobf/cl_tra_serv_mgr_factory=>get_service_manager( iv_bo_key = /scmtms/if_tor_c=>sc_bo_key ).
*      lo_srvmgr_tor->retrieve_by_association(
*        EXPORTING
*          iv_node_key     = /scmtms/if_tor_c=>sc_node-root
*          it_key          = VALUE #( ( key = <ls_tor_root>-node_id ) )
*          iv_association  = /scmtms/if_tor_c=>sc_association-root-stop
*          iv_fill_data    = abap_true
*          iv_before_image = iv_old_data
*        IMPORTING
*          et_data         = lt_stop ).
**
**      /scmtms/cl_tor_helper_stop=>get_stop_sequence(
**        EXPORTING
**          it_root_key     = VALUE #( ( key = <ls_tor_root>-node_id ) )
**          iv_before_image = SWITCH #( iv_old_data WHEN abap_true THEN abap_true ELSE abap_false )
**          it_stop_succ    = lt_stop_succ
**        IMPORTING
**          et_stop_seq_d   = lt_stop_seq ).
*
*
*      FIELD-SYMBOLS <lt_tor_stop_succ> TYPE /scmtms/t_em_bo_tor_stop_succ.
*
*      DATA(lr_stop_succ) = mo_ef_parameters->get_appl_table(
*           SWITCH #( iv_old_data WHEN abap_true
*                                   THEN /scmtms/cl_scem_int_c=>sc_table_definition-bo_tor-stop_successor_before
*                                 ELSE /scmtms/cl_scem_int_c=>sc_table_definition-bo_tor-stop_successor ) ).
*      ASSIGN lr_stop_succ->* TO <lt_tor_stop_succ>.
*
*      DATA(lt_stop_succ) = CORRESPONDING /scmtms/t_tor_stop_succ_k( <lt_tor_stop_succ> MAPPING key = node_id ).
*
*      /scmtms/cl_tor_helper_stop=>get_stop_sequence(
*        EXPORTING
*          it_root_key     = VALUE #( ( key = <ls_tor_root>-node_id ) )
*          iv_before_image = SWITCH #( iv_old_data WHEN abap_true THEN abap_true ELSE abap_false )
*          it_stop_succ    = lt_stop_succ
*          it_stop         = lt_stop
*        IMPORTING
*          et_stop_seq_d   = lt_stop_seq ).

*    ENDIF.

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
           <ls_docs>-btd_tco = zif_gtt_sts_constants=>cs_btd_type_code-carrier_assigned.
          APPEND <ls_docs>-btd_id  TO ct_carrier_ref_value.
          APPEND <ls_docs>-btd_tco TO ct_carrier_ref_type.
        ELSEIF <ls_docs>-btd_tco = zif_gtt_sts_constants=>cs_btd_type_code-purchase_order OR
           <ls_docs>-btd_tco = zif_gtt_sts_constants=>cs_btd_type_code-inbound_delivery   OR
           <ls_docs>-btd_tco = zif_gtt_sts_constants=>cs_btd_type_code-outbound_delivery  OR
           <ls_docs>-btd_tco = zif_gtt_sts_constants=>cs_btd_type_code-sales_order.
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
          cv_pln_dep_loc_type = zif_gtt_sts_constants=>cs_location_type-logistic.
        ENDIF.
        cv_pln_dep_timest   = COND #( WHEN <ls_stop_first>-plan_trans_time IS NOT INITIAL
                                        THEN |0{ <ls_stop_first>-plan_trans_time }| ELSE '' ).
        cv_pln_dep_timezone = /scmtms/cl_common_helper=>loc_key_get_timezone( iv_loc_key = <ls_stop_first>-log_loc_uuid ).
      ENDIF.
      ASSIGN <ls_stop_seq>-stop_seq[ lines( <ls_stop_seq>-stop_seq ) ] TO FIELD-SYMBOL(<ls_stop_last>).
      IF sy-subrc = 0.
        IF <ls_stop_last>-log_locid IS NOT INITIAL.
          cv_pln_arr_loc_id   = <ls_stop_last>-log_locid.
          cv_pln_arr_loc_type = zif_gtt_sts_constants=>cs_location_type-logistic.
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
    lo_tor_srv_mgr->retrieve_by_association(
      EXPORTING
        iv_node_key    = /scmtms/if_tor_c=>sc_node-root
        it_key         = VALUE #( ( key = <ls_tor_root>-node_id ) )
        iv_association = /scmtms/if_tor_c=>sc_association-root-req_tor
      IMPORTING
        et_key_link    = DATA(lt_capa2req_link) ).

*   Get req stop information
    IF iv_old_data = abap_false.
      DATA(lr_req_stop) = mo_ef_parameters->get_appl_table( iv_tabledef = /scmtms/cl_scem_int_c=>sc_table_definition-bo_tor-req_stop ).
      ASSIGN lr_req_stop->* TO <lt_req_stop>.
      IF sy-subrc <> 0.
        MESSAGE e010(zgtt_sts) INTO lv_dummy.
        zcl_gtt_sts_tools=>throw_exception( ).
      ELSE.
        lt_req_stop = <lt_req_stop>.
      ENDIF.
    ELSE.
      lo_tor_srv_mgr->retrieve_by_association(
        EXPORTING
          iv_node_key     = /scmtms/if_tor_c=>sc_node-root
          it_key          = VALUE #( ( key = <ls_tor_root>-node_id ) )
          iv_association  = /scmtms/if_tor_c=>sc_association-root-req_tor_stop
          iv_before_image = abap_true
          iv_fill_data    = abap_true
        IMPORTING
          et_data         = lt_tor_req_stop_before ).

      lt_req_stop = CORRESPONDING #( lt_tor_req_stop_before MAPPING node_id = key parent_node_id = parent_key ).
    ENDIF.

    /scmtms/cl_tor_helper_stop=>get_stop_sequence(
      EXPORTING
        it_root_key     = VALUE #( ( key = <ls_tor_root>-node_id ) )
        iv_before_image = iv_old_data
      IMPORTING
        et_stop_seq_d   = DATA(lt_stop_seq) ).

    ASSIGN lt_stop_seq[ root_key = <ls_tor_root>-node_id ] TO FIELD-SYMBOL(<ls_stop_seq>) ##WARN_OK.
    IF sy-subrc = 0.
      MOVE-CORRESPONDING <ls_stop_seq>-stop_seq TO lt_fo_stop.
      LOOP AT lt_fo_stop ASSIGNING FIELD-SYMBOL(<ls_fo_stop>).
        <ls_fo_stop>-parent_node_id = <ls_tor_root>-node_id.
        ASSIGN <ls_stop_seq>-stop_map[ tabix = <ls_fo_stop>-seq_num ]-stop_key TO FIELD-SYMBOL(<lv_stop_key>).
        CHECK sy-subrc = 0.
        <ls_fo_stop>-node_id = <lv_stop_key>.
      ENDLOOP.
    ENDIF.

    zcl_gtt_sts_tools=>get_stop_points(
      EXPORTING
        iv_root_id     = <ls_tor_root>-tor_id
        it_stop        = lt_fo_stop
       IMPORTING
        et_stop_points = DATA(lt_stop_points) ).

    LOOP AT lt_capa2req_link ASSIGNING FIELD-SYMBOL(<ls_capa2req_link>).
      ASSIGN <lt_tor_root_req>[ node_id = <ls_capa2req_link>-target_key ] TO FIELD-SYMBOL(<ls_tor_req_id>).
      CHECK sy-subrc = 0.

      lv_freight_unit_line_no += 1.
      APPEND lv_freight_unit_line_no TO ct_req_doc_line_no.

      APPEND <ls_tor_req_id>-tor_id TO ct_req_doc_no.

      LOOP AT lt_fo_stop USING KEY parent_seqnum ASSIGNING <ls_fo_stop>.
        ASSIGN lt_req_stop[ assgn_stop_key = <ls_fo_stop>-node_id parent_node_id = <ls_tor_req_id>-node_id ] TO FIELD-SYMBOL(<ls_fu_stop>).
        IF sy-subrc = 0.
          IF lv_seq_num IS INITIAL.
            DATA(lv_req_doc_first_stop) = lt_stop_points[ seq_num = <ls_fo_stop>-seq_num ]-stop_id.
            APPEND |{ lv_req_doc_first_stop ALPHA = OUT }| TO ct_req_doc_first_stop.
          ENDIF.
          lv_seq_num = <ls_fo_stop>-seq_num.
        ENDIF.
      ENDLOOP.
      IF lv_seq_num IS NOT INITIAL.
        DATA(lv_req_doc_last_stop) = lt_stop_points[ seq_num = lv_seq_num ]-stop_id.
        APPEND |{ lv_req_doc_last_stop ALPHA = OUT }| TO ct_req_doc_last_stop.
      ENDIF.
      CLEAR: lv_seq_num.
    ENDLOOP.

  ENDMETHOD.


  METHOD get_stop_seq.

    DATA lv_stop_num(4) TYPE n.
    FIELD-SYMBOLS <ls_tor_root> TYPE /scmtms/s_em_bo_tor_root.

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
        APPEND |{ lv_tor_id }{ lv_stop_num }|               TO ct_stop_id.
        APPEND lv_stop_num                                  TO ct_ordinal_no.
        APPEND zif_gtt_sts_constants=>cs_location_type-logistic TO ct_loc_type.
        APPEND <ls_stop_seq>-log_locid                      TO ct_loc_id.
      ENDLOOP.
    ENDIF.

    lv_stop_num += 1.
    DATA(lv_stop_count) = lines( <lt_stop_seq> ).

    ASSIGN <lt_stop_seq>[ lv_stop_count ] TO <ls_stop_seq>.
    IF sy-subrc = 0 AND <ls_stop_seq>-log_locid IS NOT INITIAL.
      APPEND |{ lv_tor_id }{ lv_stop_num }|               TO ct_stop_id.
      APPEND lv_stop_num                                  TO ct_ordinal_no.
      APPEND zif_gtt_sts_constants=>cs_location_type-logistic TO ct_loc_type.
      APPEND <ls_stop_seq>-log_locid                      TO ct_loc_id.
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
ENDCLASS.
