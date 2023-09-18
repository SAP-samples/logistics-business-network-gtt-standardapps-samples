CLASS zcl_gtt_mia_pe_filler_dlh DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES zif_gtt_pe_filler .

    METHODS constructor
      IMPORTING
        !io_ef_parameters TYPE REF TO zif_gtt_ef_parameters
        !io_bo_reader     TYPE REF TO zif_gtt_tp_reader .
  PROTECTED SECTION.
private section.

  data MO_EF_PARAMETERS type ref to ZIF_GTT_EF_PARAMETERS .
  data MO_BO_READER type ref to ZIF_GTT_TP_READER .

  methods ADD_GR_EVENT_WITH_MATCK_KEY
    importing
      !IS_APP_OBJECTS type TRXAS_APPOBJ_CTAB_WA
      !IR_LIPS_DATA type ref to DATA
      !IO_RELEVANCE type ref to ZCL_GTT_MIA_EVENT_REL_DL_MAIN
    changing
      !CT_EXPEVENTDATA type ZIF_GTT_EF_TYPES=>TT_EXPEVENTDATA
    raising
      CX_UDM_MESSAGE .
  methods ADD_GOODS_RECEIPT_EVENT
    importing
      !IS_APP_OBJECTS type TRXAS_APPOBJ_CTAB_WA
      !IO_RELEVANCE type ref to ZCL_GTT_MIA_EVENT_REL_DL_MAIN
      !IV_MILESTONENUM type /SAPTRX/SEQ_NUM
    changing
      !CT_EXPEVENTDATA type ZIF_GTT_EF_TYPES=>TT_EXPEVENTDATA
    raising
      CX_UDM_MESSAGE .
  methods ADD_SHIPMENT_EVENTS
    importing
      !IS_APP_OBJECTS type TRXAS_APPOBJ_CTAB_WA
    changing
      !CT_EXPEVENTDATA type ZIF_GTT_EF_TYPES=>TT_EXPEVENTDATA
    raising
      CX_UDM_MESSAGE .
  methods ADD_ITEM_COMPLETED_BY_FU_EVENT
    importing
      !IS_APP_OBJECTS type TRXAS_APPOBJ_CTAB_WA
      !IR_LIPS_DATA type ref to DATA
    changing
      !CT_EXPEVENTDATA type ZIF_GTT_EF_TYPES=>TT_EXPEVENTDATA
    raising
      CX_UDM_MESSAGE .
  methods ADD_PLANNED_DELIVERY_EVENT
    importing
      !IS_APP_OBJECTS type TRXAS_APPOBJ_CTAB_WA
      !IO_RELEVANCE type ref to ZCL_GTT_MIA_EVENT_REL_DL_MAIN
      !IV_MILESTONENUM type /SAPTRX/SEQ_NUM
    changing
      !CT_EXPEVENTDATA type ZIF_GTT_EF_TYPES=>TT_EXPEVENTDATA
    raising
      CX_UDM_MESSAGE .
  methods IS_TIME_OF_DELIVERY_CHANGED
    importing
      !IS_APP_OBJECTS type TRXAS_APPOBJ_CTAB_WA
    returning
      value(RV_RESULT) type ABAP_BOOL
    raising
      CX_UDM_MESSAGE .
  methods IS_FU_RELEVANT
    importing
      !IS_APP_OBJECTS type TRXAS_APPOBJ_CTAB_WA
      !IR_LIPS_DATA type ref to DATA
    returning
      value(RV_RESULT) type ABAP_BOOL
    raising
      CX_UDM_MESSAGE .
ENDCLASS.



CLASS ZCL_GTT_MIA_PE_FILLER_DLH IMPLEMENTATION.


  METHOD add_goods_receipt_event.

    IF io_relevance->is_enabled(
         iv_milestone   = zif_gtt_ef_constants=>cs_milestone-dl_goods_receipt ) = abap_true.

      DATA(lv_tzonrc) = zcl_gtt_tools=>get_field_of_structure(
            ir_struct_data = is_app_objects-maintabref
            iv_field_name  = 'TZONRC' ).

      ct_expeventdata = VALUE #( BASE ct_expeventdata (
        appsys            = mo_ef_parameters->get_appsys(  )
        appobjtype        = mo_ef_parameters->get_app_obj_types( )-aotype
        language          = sy-langu
        appobjid          = is_app_objects-appobjid
        milestone         = zif_gtt_ef_constants=>cs_milestone-dl_goods_receipt
        evt_exp_tzone     = COND #( WHEN lv_tzonrc IS NOT INITIAL
                                   THEN lv_tzonrc
                                   ELSE zcl_gtt_tools=>get_system_time_zone( ) )
        evt_exp_datetime  = zcl_gtt_mia_dl_tools=>get_delivery_date(
                              ir_data = is_app_objects-maintabref )
        milestonenum      = iv_milestonenum
      ) ).
    ENDIF.

  ENDMETHOD.


  METHOD add_gr_event_with_matck_key.
    DATA: lv_vbeln     TYPE vbeln_vl.
    FIELD-SYMBOLS: <lt_lips_fs> TYPE zif_gtt_mia_app_types=>tt_lipsvb,
                   <ls_lips>    TYPE lipsvb.

    ASSIGN ir_lips_data->* TO <lt_lips_fs>.

    lv_vbeln = zcl_gtt_tools=>get_field_of_structure(
      ir_struct_data = is_app_objects-maintabref
      iv_field_name  = 'VBELN' ).
    IF <lt_lips_fs> IS ASSIGNED
      AND io_relevance->is_enabled(
         iv_milestone   = zif_gtt_ef_constants=>cs_milestone-dl_goods_receipt ) = abap_true.
      LOOP AT <lt_lips_fs> ASSIGNING <ls_lips>
        WHERE vbeln = lv_vbeln AND updkz <> zif_gtt_ef_constants=>cs_change_mode-delete.
        IF zcl_gtt_tools=>is_appropriate_dl_item(
             ir_likp = is_app_objects-maintabref
             ir_lips = REF #( <ls_lips> ) ) = abap_true.

          DATA(lv_tzonrc) = zcl_gtt_tools=>get_field_of_structure(
            ir_struct_data = is_app_objects-maintabref
            iv_field_name  = 'TZONRC' ).


          ct_expeventdata = VALUE #( BASE ct_expeventdata (
                  appsys            = mo_ef_parameters->get_appsys(  )
                  appobjtype        = mo_ef_parameters->get_app_obj_types( )-aotype
                  language          = sy-langu
                  appobjid          = is_app_objects-appobjid
                  milestone         = zif_gtt_ef_constants=>cs_milestone-dl_goods_receipt
                  evt_exp_tzone     = COND #( WHEN lv_tzonrc IS NOT INITIAL
                                             THEN lv_tzonrc
                                             ELSE zcl_gtt_tools=>get_system_time_zone( ) )
                  evt_exp_datetime  = zcl_gtt_mia_dl_tools=>get_delivery_date(
                                        ir_data = is_app_objects-maintabref )
                  locid1            = zcl_gtt_tools=>get_pretty_location_id(
                                        iv_locid   = <ls_lips>-werks
                                        iv_loctype = zif_gtt_ef_constants=>cs_loc_types-plant )
                  loctype           = zif_gtt_ef_constants=>cs_loc_types-plant
                  locid2            = zcl_gtt_mia_dl_tools=>get_tracking_id_dl_item( ir_lips = REF #( <ls_lips> ) )
                  milestonenum      = zcl_gtt_tools=>get_next_sequence_id(
                                      it_expeventdata = ct_expeventdata )
                ) ).
        ENDIF.
      ENDLOOP.
    ENDIF.
  ENDMETHOD.


  METHOD add_item_completed_by_fu_event.

    DATA: lv_vbeln     TYPE vbeln_vl.
    FIELD-SYMBOLS: <lt_lips_fs> TYPE zif_gtt_mia_app_types=>tt_lipsvb,
                   <ls_lips>    TYPE lipsvb.

    ASSIGN ir_lips_data->* TO <lt_lips_fs>.

    lv_vbeln = zcl_gtt_tools=>get_field_of_structure(
      ir_struct_data = is_app_objects-maintabref
      iv_field_name  = 'VBELN' ).
    IF <lt_lips_fs> IS ASSIGNED.
      LOOP AT <lt_lips_fs> ASSIGNING <ls_lips>
        WHERE vbeln = lv_vbeln AND updkz <> zif_gtt_ef_constants=>cs_change_mode-delete.

        IF zcl_gtt_tools=>is_appropriate_dl_item(
             ir_likp = is_app_objects-maintabref
             ir_lips = REF #( <ls_lips> ) ) = abap_true.

           DATA(lv_tzonrc) = zcl_gtt_tools=>get_field_of_structure(
            ir_struct_data = is_app_objects-maintabref
            iv_field_name  = 'TZONRC' ).

          ct_expeventdata = VALUE #( BASE ct_expeventdata (
                  appsys            = mo_ef_parameters->get_appsys(  )
                  appobjtype        = mo_ef_parameters->get_app_obj_types( )-aotype
                  language          = sy-langu
                  appobjid          = is_app_objects-appobjid
                  milestone         = zif_gtt_ef_constants=>cs_milestone-dl_item_completed
                  evt_exp_tzone     = COND #( WHEN lv_tzonrc IS NOT INITIAL
                                         THEN lv_tzonrc
                                         ELSE zcl_gtt_tools=>get_system_time_zone( ) )
                  evt_exp_datetime  = zcl_gtt_mia_dl_tools=>get_delivery_date(
                                        ir_data = is_app_objects-maintabref )
                  locid2            = zcl_gtt_mia_dl_tools=>get_tracking_id_dl_item( ir_lips = REF #( <ls_lips> ) )
                  milestonenum      = zcl_gtt_tools=>get_next_sequence_id(
                                      it_expeventdata = ct_expeventdata )
                ) ).
        ENDIF.
      ENDLOOP.
    ENDIF.
  ENDMETHOD.


  METHOD add_planned_delivery_event.

    IF zcl_gtt_tools=>is_appropriate_dl_type( ir_likp = is_app_objects-maintabref ) = abap_true.
      DATA(lv_plant) = CONV werks_d( zcl_gtt_tools=>get_field_of_structure(
                            ir_struct_data = is_app_objects-maintabref
                            iv_field_name  = 'WERKS' ) ).
      DATA(lv_tzonrc) = zcl_gtt_tools=>get_field_of_structure(
            ir_struct_data = is_app_objects-maintabref
            iv_field_name  = 'TZONRC' ).
      ct_expeventdata = VALUE #( BASE ct_expeventdata (
                appsys            = mo_ef_parameters->get_appsys(  )
                appobjtype        = mo_ef_parameters->get_app_obj_types( )-aotype
                language          = sy-langu
                appobjid          = is_app_objects-appobjid
                milestone         = zif_gtt_ef_constants=>cs_milestone-dl_planned_delivery
                evt_exp_tzone     = COND #( WHEN lv_tzonrc IS NOT INITIAL
                                         THEN lv_tzonrc
                                         ELSE zcl_gtt_tools=>get_system_time_zone( ) )
                evt_exp_datetime  = zcl_gtt_mia_dl_tools=>get_delivery_date(
                                      ir_data = is_app_objects-maintabref )
                locid1            = zcl_gtt_tools=>get_pretty_location_id(
                                      iv_locid   = lv_plant
                                      iv_loctype = zif_gtt_ef_constants=>cs_loc_types-plant )
                loctype           = zif_gtt_ef_constants=>cs_loc_types-plant
                milestonenum      = iv_milestonenum
              ) ).
    ENDIF.

  ENDMETHOD.


  METHOD add_shipment_events.

    DATA: lt_expeventdata  TYPE zif_gtt_ef_types=>tt_expeventdata.

    DATA(lv_vbeln)            = CONV vbeln_vl( zcl_gtt_tools=>get_field_of_structure(
                                                 ir_struct_data = is_app_objects-maintabref
                                                 iv_field_name  = 'VBELN' ) ).

    DATA(lo_sh_stops_events) = zcl_gtt_mia_sh_stops_events=>get_instance_for_delivery(
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


  METHOD is_fu_relevant.

    DATA: lv_is_fu_rel TYPE abap_bool VALUE abap_false,
          lv_vbeln     TYPE vbeln_vl,
          lt_lips      TYPE zif_gtt_mia_app_types=>tt_lipsvb.

    FIELD-SYMBOLS: <lt_lips_fs> TYPE zif_gtt_mia_app_types=>tt_lipsvb,
                   <ls_lips>    TYPE lipsvb.

    ASSIGN ir_lips_data->* TO <lt_lips_fs>.

    lv_vbeln = zcl_gtt_tools=>get_field_of_structure(
      ir_struct_data = is_app_objects-maintabref
      iv_field_name  = 'VBELN' ).
    IF <lt_lips_fs> IS ASSIGNED.
      " collect NEW records with appropriate item type
      LOOP AT <lt_lips_fs> ASSIGNING <ls_lips>
        WHERE vbeln = lv_vbeln AND updkz <> zif_gtt_ef_constants=>cs_change_mode-delete.

        IF zcl_gtt_tools=>is_appropriate_dl_item(
             ir_likp = is_app_objects-maintabref
             ir_lips = REF #( <ls_lips> ) ) = abap_true.
          APPEND <ls_lips> TO lt_lips.
        ENDIF.
      ENDLOOP.
      IF lt_lips IS NOT INITIAL.
        lv_is_fu_rel = zcl_gtt_mia_tm_tools=>is_fu_relevant(
          it_lips = CORRESPONDING #( lt_lips ) ).
      ENDIF.
    ENDIF.
    rv_result = lv_is_fu_rel.

  ENDMETHOD.


  METHOD is_time_of_delivery_changed.

    TYPES: tt_likp    TYPE STANDARD TABLE OF likpvb.

    DATA: lv_vbeln     TYPE likp-vbeln,
          lv_lfuhr_new TYPE lfuhr,
          lv_lfuhr_old TYPE lfuhr.

    lv_lfuhr_new = zcl_gtt_tools=>get_field_of_structure(
      ir_struct_data = is_app_objects-maintabref
      iv_field_name  = 'LFUHR' ).

    DATA(lr_likp) = mo_ef_parameters->get_appl_table(
      iv_tabledef = zif_gtt_mia_app_constants=>cs_tabledef-dl_header_old ).

    FIELD-SYMBOLS: <lt_likp> TYPE tt_likp.

    IF lr_likp IS BOUND.
      ASSIGN lr_likp->* TO <lt_likp>.

      IF <lt_likp> IS ASSIGNED.
        lv_vbeln = zcl_gtt_tools=>get_field_of_structure(
          ir_struct_data = is_app_objects-maintabref
          iv_field_name  = 'VBELN' ).

        READ TABLE <lt_likp> ASSIGNING FIELD-SYMBOL(<ls_likp>)
          WITH KEY vbeln = lv_vbeln.

        lv_lfuhr_old  = COND #( WHEN sy-subrc = 0 THEN <ls_likp>-lfuhr ).
      ENDIF.
    ENDIF.

    rv_result   = boolc( lv_lfuhr_new <> lv_lfuhr_old ).

  ENDMETHOD.


  METHOD zif_gtt_pe_filler~check_relevance.

    TYPES: tt_milestones    TYPE STANDARD TABLE OF /saptrx/appl_event_tag
                              WITH EMPTY KEY.

    rv_result = zif_gtt_ef_constants=>cs_condition-false.

    IF zcl_gtt_tools=>is_appropriate_dl_type( ir_likp = is_app_objects-maintabref ) = abap_true.

      IF is_time_of_delivery_changed( is_app_objects = is_app_objects ) = abap_true.
        rv_result = zif_gtt_ef_constants=>cs_condition-true.

      ELSE.
        DATA(lo_relevance_old)  = NEW zcl_gtt_mia_event_rel_dl_hd(
                                        io_ef_parameters = mo_ef_parameters
                                        is_app_objects   = VALUE #(
                                                             appobjid   = is_app_objects-appobjid ) ).

        DATA(lo_relevance_new) = NEW zcl_gtt_mia_event_rel_dl_hd(
          io_ef_parameters = mo_ef_parameters
          is_app_objects   = is_app_objects ).

        DATA(lv_milestone)      = zif_gtt_ef_constants=>cs_milestone-dl_goods_receipt.

        rv_result = boolc( lo_relevance_old->is_enabled( iv_milestone = lv_milestone ) <>
                           lo_relevance_new->is_enabled( iv_milestone = lv_milestone ) ).

        rv_result = COND #( WHEN rv_result = abap_true
                              THEN zif_gtt_ef_constants=>cs_condition-true
                              ELSE zif_gtt_ef_constants=>cs_condition-false ).
      ENDIF.
    ENDIF.

  ENDMETHOD.


  METHOD zif_gtt_pe_filler~get_planed_events.

    DATA: lr_lips_data TYPE REF TO data.

    DATA(lo_relevance) = NEW zcl_gtt_mia_event_rel_dl_hd(
      io_ef_parameters = mo_ef_parameters
      is_app_objects   = is_app_objects ).

    " initiate relevance flags
    lo_relevance->initiate( ).

    " store calculated relevance flags
    lo_relevance->update( ).

    lr_lips_data = mo_ef_parameters->get_appl_table(
      iv_tabledef = zif_gtt_mia_app_constants=>cs_tabledef-dl_item_new ).

    add_gr_event_with_matck_key(
      EXPORTING
        is_app_objects  = is_app_objects
        ir_lips_data    = lr_lips_data
        io_relevance    = lo_relevance
      CHANGING
        ct_expeventdata = ct_expeventdata
    ).

    add_planned_delivery_event(
      EXPORTING
        is_app_objects  = is_app_objects
        io_relevance    = lo_relevance
        iv_milestonenum = zcl_gtt_tools=>get_next_sequence_id(
                              it_expeventdata = ct_expeventdata )
      CHANGING
        ct_expeventdata = ct_expeventdata ).

    IF is_fu_relevant( is_app_objects = is_app_objects
                       ir_lips_data   = lr_lips_data ) = abap_true.

      add_item_completed_by_fu_event(
        EXPORTING
          is_app_objects  = is_app_objects
          ir_lips_data    = lr_lips_data
        CHANGING
          ct_expeventdata = ct_expeventdata
      ).

    ELSE.

      add_shipment_events(
        EXPORTING
          is_app_objects  = is_app_objects
        CHANGING
          ct_expeventdata = ct_expeventdata ).

      add_goods_receipt_event(
        EXPORTING
          is_app_objects  = is_app_objects
          io_relevance    = lo_relevance
          iv_milestonenum = zcl_gtt_tools=>get_next_sequence_id(
                              it_expeventdata = ct_expeventdata )
        CHANGING
          ct_expeventdata = ct_expeventdata ).

    ENDIF.

  ENDMETHOD.
ENDCLASS.
