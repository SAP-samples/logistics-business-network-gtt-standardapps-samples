CLASS zcl_gtt_spof_pe_filler_po_hdr DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES zif_gtt_pe_filler .

    METHODS constructor
      IMPORTING
        !io_ef_parameters TYPE REF TO zif_gtt_ef_parameters
        !io_bo_reader     TYPE REF TO zif_gtt_tp_reader .
  PROTECTED SECTION.
  PRIVATE SECTION.

    DATA mo_ef_parameters TYPE REF TO zif_gtt_ef_parameters .
    DATA mo_bo_reader TYPE REF TO zif_gtt_tp_reader .

    METHODS get_delivery_datetime
      IMPORTING
        !i_delivery_date   TYPE eindt
      RETURNING
        VALUE(rv_datetime) TYPE /saptrx/event_exp_datetime
      RAISING
        cx_udm_message .
    METHODS get_latest_delivery_date
      IMPORTING
        !iv_ebeln       TYPE ebeln
        !ir_ekpo        TYPE REF TO data
        !ir_eket        TYPE REF TO data
      RETURNING
        VALUE(rv_eindt) TYPE eindt
      RAISING
        cx_udm_message .
    METHODS add_planned_delivery_event
      IMPORTING
        !is_app_objects  TYPE trxas_appobj_ctab_wa
      CHANGING
        !ct_expeventdata TYPE zif_gtt_ef_types=>tt_expeventdata
      RAISING
        cx_udm_message .
    METHODS add_po_item_completed_event
      IMPORTING
        !is_app_objects  TYPE trxas_appobj_ctab_wa
        !ir_ekpo_data    TYPE REF TO data
      CHANGING
        !ct_expeventdata TYPE zif_gtt_ef_types=>tt_expeventdata
      RAISING
        cx_udm_message .
ENDCLASS.



CLASS ZCL_GTT_SPOF_PE_FILLER_PO_HDR IMPLEMENTATION.


  METHOD add_planned_delivery_event.
    DATA: lv_loekz       TYPE ekpo-loekz,
          lv_pd_conf     TYPE abap_bool,
          lv_latest_date TYPE eindt.

    lv_pd_conf = zcl_gtt_spof_po_tools=>is_appropriate_po(
      ir_ekko = is_app_objects-maintabref
      ir_ekpo = mo_ef_parameters->get_appl_table( iv_tabledef = zif_gtt_spof_app_constants=>cs_tabledef-po_item_new )
    ).

    IF lv_pd_conf EQ abap_true.
      " clear expecting datetime and timezone when lv_latest_date is initial
      " to avoid generation of unwanted GTTOverdue events
      lv_latest_date = get_latest_delivery_date(
        EXPORTING
          iv_ebeln = CONV ebeln( zcl_gtt_tools=>get_field_of_structure(
                         ir_struct_data = is_app_objects-maintabref
                         iv_field_name  = 'EBELN'
                       ) )
          ir_ekpo  = mo_ef_parameters->get_appl_table(
                        iv_tabledef = zif_gtt_spof_app_constants=>cs_tabledef-po_item_new )
          ir_eket  = mo_ef_parameters->get_appl_table(
                        iv_tabledef = zif_gtt_spof_app_constants=>cs_tabledef-po_sched_new )
      ).

      ct_expeventdata = VALUE #( BASE ct_expeventdata (
        appsys            = mo_ef_parameters->get_appsys(  )
        appobjtype        = mo_ef_parameters->get_app_obj_types( )-aotype
        language          = sy-langu
        appobjid          = is_app_objects-appobjid
        milestone         = zif_gtt_ef_constants=>cs_milestone-po_planned_delivery
        evt_exp_tzone     = COND #( WHEN lv_latest_date IS NOT INITIAL
                                      THEN zcl_gtt_tools=>get_system_time_zone( ) )
        evt_exp_datetime  = COND #( WHEN lv_latest_date IS NOT INITIAL
                                      THEN get_delivery_datetime( i_delivery_date = lv_latest_date ) )
        milestonenum      = zcl_gtt_tools=>get_next_sequence_id(
                                      it_expeventdata = ct_expeventdata )
      ) ).

    ENDIF.
  ENDMETHOD.


  METHOD add_po_item_completed_event.
    DATA: lv_ebeln     TYPE ebeln.
    FIELD-SYMBOLS: <lt_ekpo> TYPE zif_gtt_spof_app_types=>tt_uekpo,
                   <ls_ekpo> TYPE zif_gtt_spof_app_types=>ts_uekpo.

    ASSIGN ir_ekpo_data->* TO <lt_ekpo>.

    lv_ebeln = zcl_gtt_tools=>get_field_of_structure(
      ir_struct_data = is_app_objects-maintabref
      iv_field_name  = 'EBELN' ).
    IF <lt_ekpo> IS ASSIGNED.
      LOOP AT <lt_ekpo> ASSIGNING <ls_ekpo>
        WHERE ebeln = lv_ebeln.
        IF zcl_gtt_spof_po_tools=>is_appropriate_po_item( ir_ekko = is_app_objects-maintabref ir_ekpo = REF #( <ls_ekpo> ) ) = abap_true.

          ct_expeventdata = VALUE #( BASE ct_expeventdata (
                  appsys            = mo_ef_parameters->get_appsys(  )
                  appobjtype        = mo_ef_parameters->get_app_obj_types( )-aotype
                  language          = sy-langu
                  appobjid          = is_app_objects-appobjid
                  milestone         = zif_gtt_ef_constants=>cs_milestone-po_itm_completed
                  locid2            = zcl_gtt_spof_po_tools=>get_tracking_id_po_itm( ir_ekpo = REF #( <ls_ekpo> ) )
                  milestonenum      = zcl_gtt_tools=>get_next_sequence_id(
                                      it_expeventdata = ct_expeventdata )
                ) ).
        ENDIF.
      ENDLOOP.
    ENDIF.
  ENDMETHOD.


  METHOD constructor.

    mo_ef_parameters    = io_ef_parameters.
    mo_bo_reader        = io_bo_reader.

  ENDMETHOD.


  METHOD get_delivery_datetime.
    rv_datetime = zcl_gtt_tools=>get_local_timestamp(
      iv_date = i_delivery_date
      iv_time = CONV t( '235959' ) ).
  ENDMETHOD.


  METHOD get_latest_delivery_date.
    DATA: lt_ebelp_rng TYPE RANGE OF ekpo-ebelp,
          lv_eindt_max TYPE eket-eindt,
          lv_eindt_set TYPE abap_bool VALUE abap_false.

    FIELD-SYMBOLS: <lt_ekpo> TYPE zif_gtt_spof_app_types=>tt_uekpo,
                   <ls_ekpo> TYPE zif_gtt_spof_app_types=>ts_uekpo,
                   <lt_eket> TYPE zif_gtt_spof_app_types=>tt_ueket,
                   <ls_eket> TYPE zif_gtt_spof_app_types=>ts_ueket.


    CLEAR: rv_eindt.

    ASSIGN ir_ekpo->* TO <lt_ekpo>.
    ASSIGN ir_eket->* TO <lt_eket>.

    IF <lt_ekpo> IS ASSIGNED AND
       <lt_eket> IS ASSIGNED.
      " Preparation of Active Items List
      LOOP AT <lt_ekpo> ASSIGNING <ls_ekpo>
        WHERE ebeln  = iv_ebeln
          AND loekz <> zif_gtt_spof_app_constants=>cs_loekz-deleted.

        lt_ebelp_rng  = VALUE #( BASE lt_ebelp_rng
                                 ( low    = <ls_ekpo>-ebelp
                                   option = 'EQ'
                                   sign   = 'I' ) ).
      ENDLOOP.

      " keep Latest Delivery Date in schedule lines per item.
      LOOP AT <lt_eket> ASSIGNING <ls_eket>
        WHERE ebeln  = iv_ebeln
          AND ebelp IN lt_ebelp_rng
          AND kz <> zif_gtt_ef_constants=>cs_change_mode-delete
        GROUP BY ( ebeln = <ls_eket>-ebeln
                   ebelp = <ls_eket>-ebelp )
        ASCENDING
        ASSIGNING FIELD-SYMBOL(<ls_eket_group>).

        CLEAR: lv_eindt_max.

        LOOP AT GROUP <ls_eket_group> ASSIGNING FIELD-SYMBOL(<ls_eket_items>).
          lv_eindt_max    = COND #( WHEN <ls_eket_items>-eindt > lv_eindt_max
                                      THEN <ls_eket_items>-eindt
                                      ELSE lv_eindt_max ).
        ENDLOOP.

        IF lv_eindt_set = abap_false.
          rv_eindt  = lv_eindt_max.
          lv_eindt_set        = abap_true.
        ELSEIF rv_eindt < lv_eindt_max.
          rv_eindt = lv_eindt_max.
        ENDIF.
      ENDLOOP.
    ENDIF.
  ENDMETHOD.


  METHOD zif_gtt_pe_filler~check_relevance.

    DATA: lv_new_latest_date TYPE eindt,
          lv_old_latest_date TYPE eindt.

    rv_result   = zif_gtt_ef_constants=>cs_condition-false.
    IF zcl_gtt_spof_po_tools=>is_appropriate_po(
          ir_ekko = is_app_objects-maintabref
          ir_ekpo = mo_ef_parameters->get_appl_table( iv_tabledef = zif_gtt_spof_app_constants=>cs_tabledef-po_item_new )
          ) = abap_true.

      IF is_app_objects-update_indicator = zif_gtt_ef_constants=>cs_change_mode-insert.
        rv_result = zif_gtt_ef_constants=>cs_condition-true.
      ELSE.
        DATA(lv_ebeln) = CONV ebeln( zcl_gtt_tools=>get_field_of_structure(
                           ir_struct_data = is_app_objects-maintabref
                           iv_field_name  = 'EBELN'
                         ) ).

        lv_new_latest_date = get_latest_delivery_date(
          EXPORTING
            iv_ebeln = lv_ebeln
            ir_ekpo  = mo_ef_parameters->get_appl_table(
                          iv_tabledef = zif_gtt_spof_app_constants=>cs_tabledef-po_item_new )
            ir_eket  = mo_ef_parameters->get_appl_table(
                          iv_tabledef = zif_gtt_spof_app_constants=>cs_tabledef-po_sched_new )
        ).

        lv_old_latest_date = get_latest_delivery_date(
          EXPORTING
            iv_ebeln = lv_ebeln
            ir_ekpo  = mo_ef_parameters->get_appl_table(
                          iv_tabledef = zif_gtt_spof_app_constants=>cs_tabledef-po_item_old )
            ir_eket  = mo_ef_parameters->get_appl_table(
                          iv_tabledef = zif_gtt_spof_app_constants=>cs_tabledef-po_sched_old )
        ).
        rv_result = COND #( WHEN lv_new_latest_date <> lv_old_latest_date
                                 THEN zif_gtt_ef_constants=>cs_condition-true
                                 ELSE zif_gtt_ef_constants=>cs_condition-false ).
      ENDIF.
    ENDIF.
  ENDMETHOD.


  METHOD zif_gtt_pe_filler~get_planed_events.

    add_planned_delivery_event(
      EXPORTING
        is_app_objects  = is_app_objects
      CHANGING
        ct_expeventdata = ct_expeventdata ).

    add_po_item_completed_event(
      EXPORTING
        is_app_objects = is_app_objects
        ir_ekpo_data   = mo_ef_parameters->get_appl_table(
                           iv_tabledef = zif_gtt_spof_app_constants=>cs_tabledef-po_item_new )
      CHANGING
        ct_expeventdata = ct_expeventdata
  ).

  ENDMETHOD.
ENDCLASS.
