CLASS zcl_gtt_mia_pe_filler_dli DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES zif_gtt_mia_pe_filler .

    METHODS constructor
      IMPORTING
        !io_ef_parameters TYPE REF TO zif_gtt_mia_ef_parameters
        !io_bo_reader     TYPE REF TO zif_gtt_mia_tp_reader .
  PROTECTED SECTION.
  PRIVATE SECTION.

    DATA mo_ef_parameters TYPE REF TO zif_gtt_mia_ef_parameters .
    DATA mo_bo_reader TYPE REF TO zif_gtt_mia_tp_reader .

    METHODS add_goods_receipt_event
      IMPORTING
        !is_app_objects  TYPE trxas_appobj_ctab_wa
        !io_relevance    TYPE REF TO zcl_gtt_mia_event_rel_dl_main
        !iv_milestonenum TYPE /saptrx/seq_num
      CHANGING
        !ct_expeventdata TYPE zif_gtt_mia_ef_types=>tt_expeventdata
      RAISING
        cx_udm_message .
    METHODS add_packing_event
      IMPORTING
        !is_app_objects  TYPE trxas_appobj_ctab_wa
        !io_relevance    TYPE REF TO zcl_gtt_mia_event_rel_dl_main
        !iv_milestonenum TYPE /saptrx/seq_num
      CHANGING
        !ct_expeventdata TYPE zif_gtt_mia_ef_types=>tt_expeventdata
      RAISING
        cx_udm_message .
    METHODS add_put_away_event
      IMPORTING
        !is_app_objects  TYPE trxas_appobj_ctab_wa
        !io_relevance    TYPE REF TO zcl_gtt_mia_event_rel_dl_main
        !iv_milestonenum TYPE /saptrx/seq_num
      CHANGING
        !ct_expeventdata TYPE zif_gtt_mia_ef_types=>tt_expeventdata
      RAISING
        cx_udm_message .
    METHODS add_shipment_events
      IMPORTING
        !is_app_objects  TYPE trxas_appobj_ctab_wa
      CHANGING
        !ct_expeventdata TYPE zif_gtt_mia_ef_types=>tt_expeventdata
      RAISING
        cx_udm_message .
    METHODS is_time_of_delivery_changed
      IMPORTING
        !is_app_objects  TYPE trxas_appobj_ctab_wa
      RETURNING
        VALUE(rv_result) TYPE abap_bool
      RAISING
        cx_udm_message .
ENDCLASS.



CLASS zcl_gtt_mia_pe_filler_dli IMPLEMENTATION.


  METHOD add_goods_receipt_event.
    DATA: lv_werks  TYPE werks_d.

    IF io_relevance->is_enabled(
         iv_milestone   = zif_gtt_mia_app_constants=>cs_milestone-dl_goods_receipt ) = abap_true.

      lv_werks  = zcl_gtt_mia_tools=>get_field_of_structure(
                    ir_struct_data = is_app_objects-maintabref
                    iv_field_name  = 'WERKS' ).

      ct_expeventdata = VALUE #( BASE ct_expeventdata (
        appsys            = mo_ef_parameters->get_appsys(  )
        appobjtype        = mo_ef_parameters->get_app_obj_types( )-aotype
        language          = sy-langu
        appobjid          = is_app_objects-appobjid
        milestone         = zif_gtt_mia_app_constants=>cs_milestone-dl_goods_receipt
        evt_exp_tzone     = zcl_gtt_mia_tools=>get_system_time_zone( )
        evt_exp_datetime  = zcl_gtt_mia_dl_tools=>get_delivery_date(
                              ir_data = is_app_objects-mastertabref )
        locid1            = zcl_gtt_mia_tools=>get_pretty_location_id(
                              iv_locid   = lv_werks
                              iv_loctype = zif_gtt_mia_ef_constants=>cs_loc_types-plant )
        loctype           = zif_gtt_mia_ef_constants=>cs_loc_types-plant
        milestonenum      = iv_milestonenum
      ) ).
    ENDIF.

  ENDMETHOD.


  METHOD add_packing_event.
    DATA: lv_werks  TYPE werks_d.

    IF io_relevance->is_enabled(
         iv_milestone   = zif_gtt_mia_app_constants=>cs_milestone-dl_packing ) = abap_true.

      lv_werks  = zcl_gtt_mia_tools=>get_field_of_structure(
                    ir_struct_data = is_app_objects-maintabref
                    iv_field_name  = 'WERKS' ).

      ct_expeventdata = VALUE #( BASE ct_expeventdata (
        appsys            = mo_ef_parameters->get_appsys(  )
        appobjtype        = mo_ef_parameters->get_app_obj_types( )-aotype
        language          = sy-langu
        appobjid          = is_app_objects-appobjid
        milestone         = zif_gtt_mia_app_constants=>cs_milestone-dl_packing
        evt_exp_tzone     = zcl_gtt_mia_tools=>get_system_time_zone( )
        locid1            = zcl_gtt_mia_tools=>get_pretty_location_id(
                              iv_locid   = lv_werks
                              iv_loctype = zif_gtt_mia_ef_constants=>cs_loc_types-plant )
        loctype           = zif_gtt_mia_ef_constants=>cs_loc_types-plant
        milestonenum      = iv_milestonenum
      ) ).
    ENDIF.

  ENDMETHOD.


  METHOD add_put_away_event.
    DATA: lv_werks  TYPE werks_d.

    IF io_relevance->is_enabled(
         iv_milestone   = zif_gtt_mia_app_constants=>cs_milestone-dl_put_away ) = abap_true.

      lv_werks  = zcl_gtt_mia_tools=>get_field_of_structure(
                    ir_struct_data = is_app_objects-maintabref
                    iv_field_name  = 'WERKS' ).

      ct_expeventdata = VALUE #( BASE ct_expeventdata (
        appsys            = mo_ef_parameters->get_appsys(  )
        appobjtype        = mo_ef_parameters->get_app_obj_types( )-aotype
        language          = sy-langu
        appobjid          = is_app_objects-appobjid
        milestone         = zif_gtt_mia_app_constants=>cs_milestone-dl_put_away
        evt_exp_tzone     = zcl_gtt_mia_tools=>get_system_time_zone( )
        evt_exp_datetime  = zcl_gtt_mia_dl_tools=>get_delivery_date(
                              ir_data = is_app_objects-mastertabref )
        locid1            = zcl_gtt_mia_tools=>get_pretty_location_id(
                              iv_locid   = lv_werks
                              iv_loctype = zif_gtt_mia_ef_constants=>cs_loc_types-plant )
        loctype           = zif_gtt_mia_ef_constants=>cs_loc_types-plant
        milestonenum      = iv_milestonenum
      ) ).
    ENDIF.

  ENDMETHOD.


  METHOD add_shipment_events.

    DATA: lt_expeventdata  TYPE zif_gtt_mia_ef_types=>tt_expeventdata.

    DATA(lv_vbeln)            = CONV vbeln_vl( zcl_gtt_mia_tools=>get_field_of_structure(
                                                 ir_struct_data = is_app_objects-maintabref
                                                 iv_field_name  = 'VBELN' ) ).

    DATA(lo_sh_stops_events)  = zcl_gtt_mia_sh_stops_events=>get_instance_for_delivery(
                                  iv_vbeln         = lv_vbeln
                                  iv_appobjid      = is_app_objects-appobjid
                                  io_ef_parameters = mo_ef_parameters ).

    lo_sh_stops_events->get_planned_events(
      IMPORTING
        et_exp_event = lt_expeventdata ).

    ct_expeventdata   = VALUE #( BASE ct_expeventdata
                                 ( LINES OF lt_expeventdata ) ).

  ENDMETHOD.


  METHOD constructor.

    mo_ef_parameters    = io_ef_parameters.
    mo_bo_reader        = io_bo_reader.

  ENDMETHOD.

  METHOD is_time_of_delivery_changed.

    TYPES: tt_likp    TYPE STANDARD TABLE OF likpvb.

    DATA: lv_vbeln     TYPE likp-vbeln,
          lv_lfuhr_new TYPE lfuhr,
          lv_lfuhr_old TYPE lfuhr.

    lv_lfuhr_new  = zcl_gtt_mia_tools=>get_field_of_structure(
                      ir_struct_data = is_app_objects-mastertabref
                      iv_field_name  = 'LFUHR' ).

    DATA(lr_likp)  = mo_ef_parameters->get_appl_table(
                       iv_tabledef = zif_gtt_mia_app_constants=>cs_tabledef-dl_header_old ).

    FIELD-SYMBOLS: <lt_likp> TYPE tt_likp.

    IF lr_likp IS BOUND.
      ASSIGN lr_likp->* TO <lt_likp>.

      IF <lt_likp> IS ASSIGNED.
        lv_vbeln  = zcl_gtt_mia_tools=>get_field_of_structure(
                      ir_struct_data = is_app_objects-mastertabref
                      iv_field_name  = 'VBELN' ).

        READ TABLE <lt_likp> ASSIGNING FIELD-SYMBOL(<ls_likp>)
          WITH KEY vbeln = lv_vbeln.

        lv_lfuhr_old  = COND #( WHEN sy-subrc = 0 THEN <ls_likp>-lfuhr ).
      ENDIF.
    ENDIF.

    rv_result   = boolc( lv_lfuhr_new <> lv_lfuhr_old ).

  ENDMETHOD.


  METHOD zif_gtt_mia_pe_filler~check_relevance.

    TYPES: tt_milestones    TYPE STANDARD TABLE OF /saptrx/appl_event_tag
                              WITH EMPTY KEY.

    rv_result = zif_gtt_mia_ef_constants=>cs_condition-false.

    IF zcl_gtt_mia_dl_tools=>is_appropriate_dl_type( ir_struct = is_app_objects-mastertabref ) = abap_true AND
       zcl_gtt_mia_dl_tools=>is_appropriate_dl_item( ir_struct = is_app_objects-maintabref ) = abap_true.

      IF is_time_of_delivery_changed( is_app_objects = is_app_objects ) = abap_true.
        rv_result = zif_gtt_mia_ef_constants=>cs_condition-true.

      ELSE.
        DATA(lo_relevance_old)  = NEW zcl_gtt_mia_event_rel_dl_it(
                                        io_ef_parameters = mo_ef_parameters ).

        DATA(lo_relevance_new)  = NEW zcl_gtt_mia_event_rel_dl_it(
                                        io_ef_parameters = mo_ef_parameters
                                        is_app_objects   = is_app_objects ).

        DATA(lt_milestones)     = VALUE tt_milestones(
          ( zif_gtt_mia_app_constants=>cs_milestone-dl_goods_receipt )
          ( zif_gtt_mia_app_constants=>cs_milestone-dl_packing )
          ( zif_gtt_mia_app_constants=>cs_milestone-dl_put_away )
        ).

        rv_result = zif_gtt_mia_ef_constants=>cs_condition-false.

        LOOP AT lt_milestones ASSIGNING FIELD-SYMBOL(<lv_milestone>).
          IF lo_relevance_old->is_enabled( iv_milestone = <lv_milestone> ) <>
               lo_relevance_new->is_enabled( iv_milestone = <lv_milestone> ).

            rv_result = zif_gtt_mia_ef_constants=>cs_condition-true.
            EXIT.
          ENDIF.
        ENDLOOP.
      ENDIF.
    ENDIF.

  ENDMETHOD.


  METHOD zif_gtt_mia_pe_filler~get_planed_events.

    DATA(lo_relevance)  = NEW zcl_gtt_mia_event_rel_dl_it(
                            io_ef_parameters = mo_ef_parameters
                            is_app_objects   = is_app_objects ).

    " initiate relevance flags
    lo_relevance->initiate( ).

    " store calculated relevance flags
    lo_relevance->update( ).

    add_shipment_events(
      EXPORTING
        is_app_objects  = is_app_objects
      CHANGING
        ct_expeventdata = ct_expeventdata ).

    add_put_away_event(
      EXPORTING
        is_app_objects  = is_app_objects
        io_relevance    = lo_relevance
        iv_milestonenum = zcl_gtt_mia_tools=>get_next_sequence_id(
                            it_expeventdata = ct_expeventdata )
      CHANGING
        ct_expeventdata = ct_expeventdata ).

    add_packing_event(
      EXPORTING
        is_app_objects  = is_app_objects
        io_relevance    = lo_relevance
        iv_milestonenum = zcl_gtt_mia_tools=>get_next_sequence_id(
                            it_expeventdata = ct_expeventdata )
      CHANGING
        ct_expeventdata = ct_expeventdata ).

    add_goods_receipt_event(
      EXPORTING
        is_app_objects  = is_app_objects
        io_relevance    = lo_relevance
        iv_milestonenum = zcl_gtt_mia_tools=>get_next_sequence_id(
                            it_expeventdata = ct_expeventdata )
      CHANGING
        ct_expeventdata = ct_expeventdata ).

  ENDMETHOD.
ENDCLASS.
