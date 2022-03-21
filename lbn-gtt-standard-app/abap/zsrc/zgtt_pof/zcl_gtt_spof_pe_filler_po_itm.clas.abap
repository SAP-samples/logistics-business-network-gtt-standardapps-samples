class ZCL_GTT_SPOF_PE_FILLER_PO_ITM definition
  public
  create public .

public section.

  interfaces ZIF_GTT_PE_FILLER .

  methods CONSTRUCTOR
    importing
      !IO_EF_PARAMETERS type ref to ZIF_GTT_EF_PARAMETERS
      !IO_BO_READER type ref to ZIF_GTT_TP_READER .
  PROTECTED SECTION.
private section.

  types:
    BEGIN OF ts_dl_item_id,
        vbeln TYPE vbeln_vl,
        posnr TYPE posnr_vl,
      END OF ts_dl_item_id .
  types:
    tt_dl_item_id  TYPE STANDARD TABLE OF ts_dl_item_id .

  data MO_EF_PARAMETERS type ref to ZIF_GTT_EF_PARAMETERS .
  data MO_BO_READER type ref to ZIF_GTT_TP_READER .

  methods ADD_GOODS_RECEIPT_EVENT
    importing
      !IS_APP_OBJECTS type TRXAS_APPOBJ_CTAB_WA
    changing
      !CT_EXPEVENTDATA type ZIF_GTT_EF_TYPES=>TT_EXPEVENTDATA
    raising
      CX_UDM_MESSAGE .
  methods ADD_CONFIRMATION_EVENT
    importing
      !IS_APP_OBJECTS type TRXAS_APPOBJ_CTAB_WA
    changing
      !CT_EXPEVENTDATA type ZIF_GTT_EF_TYPES=>TT_EXPEVENTDATA
    raising
      CX_UDM_MESSAGE .
  methods GET_DELIVERY_DATETIME
    importing
      !IS_APP_OBJECTS type TRXAS_APPOBJ_CTAB_WA
    returning
      value(RV_DATETIME) type /SAPTRX/EVENT_EXP_DATETIME
    raising
      CX_UDM_MESSAGE .
  methods GET_OBJECT_FIELD_VALUE
    importing
      !IS_APP_OBJECTS type TRXAS_APPOBJ_CTAB_WA
      !IV_FIELDNAME type CLIKE
    returning
      value(RV_VALUE) type CHAR50
    raising
      CX_UDM_MESSAGE .
  methods ADD_DLV_ITEM_COMPLETED_EVENT
    importing
      !IS_APP_OBJECTS type TRXAS_APPOBJ_CTAB_WA
      !IR_EKES_DATA type ref to DATA
    changing
      !CT_EXPEVENTDATA type ZIF_GTT_EF_TYPES=>TT_EXPEVENTDATA
    raising
      CX_UDM_MESSAGE .
  methods IS_APPROPRIATE_DL
    importing
      !I_VBELN type VBELN_VL
      !I_POSNR type POSNR_VL
    returning
      value(RV_RESULT) type ABAP_BOOL
    raising
      CX_UDM_MESSAGE .
ENDCLASS.



CLASS ZCL_GTT_SPOF_PE_FILLER_PO_ITM IMPLEMENTATION.


  METHOD add_confirmation_event.
    DATA: lv_enable_conf TYPE abap_bool.

    lv_enable_conf = zcl_gtt_spof_po_tools=>is_enable_confirmation_po_item( ir_ekpo = is_app_objects-maintabref ).

    IF lv_enable_conf = abap_true AND zcl_gtt_spof_po_tools=>is_appropriate_po_item( ir_ekpo = is_app_objects-maintabref ) = abap_true.
      ct_expeventdata = VALUE #( BASE ct_expeventdata (
        appsys            = mo_ef_parameters->get_appsys(  )
        appobjtype        = mo_ef_parameters->get_app_obj_types( )-aotype
        language          = sy-langu
        appobjid          = is_app_objects-appobjid
        milestone         = zif_gtt_ef_constants=>cs_milestone-po_confirmation
      ) ).
    ENDIF.
  ENDMETHOD.


  METHOD add_goods_receipt_event.
    DATA: lv_loekz   TYPE ekpo-loekz,
          lv_gr_conf TYPE abap_bool.

    lv_gr_conf = zcl_gtt_spof_po_tools=>is_appropriate_po_item( ir_ekpo = is_app_objects-maintabref ).

    IF lv_gr_conf EQ abap_true.
      " clear expecting datetime and timezone when Item is marked as deleted
      " to avoid generation of unwanted GTTOverdue events
      lv_loekz = zcl_gtt_tools=>get_field_of_structure(
        ir_struct_data = is_app_objects-maintabref
        iv_field_name  = 'LOEKZ' ).

      ct_expeventdata = VALUE #( BASE ct_expeventdata (
        appsys            = mo_ef_parameters->get_appsys(  )
        appobjtype        = mo_ef_parameters->get_app_obj_types( )-aotype
        language          = sy-langu
        appobjid          = is_app_objects-appobjid
        milestone         = zif_gtt_ef_constants=>cs_milestone-po_goods_receipt
        evt_exp_tzone     = COND #( WHEN lv_loekz IS INITIAL
                                      THEN zcl_gtt_tools=>get_system_time_zone( ) )
        evt_exp_datetime  = COND #( WHEN lv_loekz IS INITIAL
                                      THEN get_delivery_datetime( is_app_objects = is_app_objects ) )
        locid1            = zcl_gtt_tools=>get_field_of_structure(
                                ir_struct_data = is_app_objects-maintabref
                                iv_field_name  = 'WERKS' )
        loctype           = zif_gtt_ef_constants=>cs_loc_types-plant
      ) ).

    ENDIF.

  ENDMETHOD.


  METHOD constructor.

    mo_ef_parameters    = io_ef_parameters.
    mo_bo_reader        = io_bo_reader.

  ENDMETHOD.


  METHOD get_delivery_datetime.
    rv_datetime = zcl_gtt_tools=>get_local_timestamp(
                    iv_date = get_object_field_value(
                                is_app_objects = is_app_objects
                                iv_fieldname   = 'EINDT' )
                    iv_time = CONV t( '000000' ) ).
  ENDMETHOD.


  METHOD get_object_field_value.
    DATA: lr_data  TYPE REF TO data,
          lv_dummy TYPE char100.

    FIELD-SYMBOLS: <ls_data>  TYPE any,
                   <lv_value> TYPE any.

    lr_data = mo_bo_reader->get_data( is_app_object = is_app_objects ).

    ASSIGN lr_data->* TO <ls_data>.
    IF <ls_data> IS ASSIGNED.
      ASSIGN COMPONENT iv_fieldname OF STRUCTURE <ls_data> TO <lv_value>.
      IF <lv_value> IS ASSIGNED.
        rv_value = <lv_value>.
      ELSE.
        MESSAGE e001(zgtt) WITH iv_fieldname 'po item' INTO lv_dummy ##NO_TEXT.
        zcl_gtt_tools=>throw_exception( ).
      ENDIF.
    ELSE.
      MESSAGE e002(zgtt) WITH 'po item' INTO lv_dummy ##NO_TEXT .
      zcl_gtt_tools=>throw_exception( ).
    ENDIF.
  ENDMETHOD.


  METHOD add_dlv_item_completed_event.

    DATA: lv_conf TYPE abap_bool.
    DATA: lv_ebeln TYPE ebeln,
          lv_ebelp TYPE ebelp.
    DATA: lt_dl_item         TYPE tt_dl_item_id,
          lt_dl_item_deleted TYPE tt_dl_item_id.
    DATA: ls_lips  TYPE lips.

    FIELD-SYMBOLS: <lt_ekes> TYPE zif_gtt_spof_app_types=>tt_uekes,
                   <ls_ekes> TYPE zif_gtt_spof_app_types=>ts_uekes.

    ASSIGN ir_ekes_data->* TO <lt_ekes>.

    lv_ebeln = zcl_gtt_tools=>get_field_of_structure(
      ir_struct_data = is_app_objects-maintabref
      iv_field_name  = 'EBELN' ).

    lv_ebelp = zcl_gtt_tools=>get_field_of_structure(
      ir_struct_data = is_app_objects-maintabref
      iv_field_name  = 'EBELP' ).

    lv_conf = zcl_gtt_spof_po_tools=>is_appropriate_po_item( ir_ekpo = is_app_objects-maintabref ).

    IF <lt_ekes> IS ASSIGNED AND lv_conf = abap_true.
      LOOP AT <lt_ekes> ASSIGNING <ls_ekes>
        WHERE ebeln = lv_ebeln AND
              ebelp = lv_ebelp AND
              vbeln IS NOT INITIAL AND
              vbelp IS NOT INITIAL AND
              kz = zif_gtt_ef_constants=>cs_change_mode-delete.
        lt_dl_item_deleted  = VALUE #( BASE lt_dl_item_deleted (
              vbeln = <ls_ekes>-vbeln
              posnr = <ls_ekes>-vbelp
            ) ).
      ENDLOOP.
      LOOP AT <lt_ekes> ASSIGNING <ls_ekes>
        WHERE ebeln = lv_ebeln AND
              ebelp = lv_ebelp AND
              vbeln IS NOT INITIAL AND
              vbelp IS NOT INITIAL AND
              kz <> zif_gtt_ef_constants=>cs_change_mode-delete.
        IF NOT line_exists( lt_dl_item[ vbeln = <ls_ekes>-vbeln posnr = <ls_ekes>-vbelp ] ) AND
           NOT line_exists( lt_dl_item_deleted[ vbeln = <ls_ekes>-vbeln posnr = <ls_ekes>-vbelp ] )
          AND is_appropriate_dl( i_vbeln = <ls_ekes>-vbeln i_posnr = <ls_ekes>-vbelp ) = abap_true.

          lt_dl_item  = VALUE #( BASE lt_dl_item (
              vbeln = <ls_ekes>-vbeln
              posnr = <ls_ekes>-vbelp
            ) ).
        ENDIF.
      ENDLOOP.

      LOOP AT lt_dl_item ASSIGNING FIELD-SYMBOL(<ls_dl_item>).
        ct_expeventdata = VALUE #( BASE ct_expeventdata (
             appsys            = mo_ef_parameters->get_appsys(  )
             appobjtype        = mo_ef_parameters->get_app_obj_types( )-aotype
             language          = sy-langu
             appobjid          = is_app_objects-appobjid
             milestone         = zif_gtt_ef_constants=>cs_milestone-dl_item_completed
             locid2            = zcl_gtt_spof_po_tools=>get_tracking_id_dl_item( ir_lips = REF #( <ls_dl_item> )  )
             milestonenum      = zcl_gtt_tools=>get_next_sequence_id(
                                 it_expeventdata = ct_expeventdata )
           ) ).
      ENDLOOP.

    ENDIF.
  ENDMETHOD.


  METHOD is_appropriate_dl.

    FIELD-SYMBOLS:
      <ft_likp> TYPE va_likpvb_t,
      <ft_lips> TYPE va_lipsvb_t.

    DATA:
      ls_likp TYPE likp,
      ls_lips TYPE lips,
      lo_likp TYPE REF TO data,
      lo_lips TYPE REF TO data.

    rv_result = abap_false.

    SELECT SINGLE * INTO  ls_likp
      FROM likp
     WHERE vbeln = i_vbeln.

    IF sy-subrc = 0 AND
       zcl_gtt_spof_po_tools=>is_appropriate_dl_type(
         ir_struct = REF #( ls_likp ) ) = abap_true.

      SELECT SINGLE * INTO ls_lips
         FROM lips
         WHERE vbeln = i_vbeln AND posnr = i_posnr.

      IF sy-subrc = 0 AND zcl_gtt_spof_po_tools=>is_appropriate_dl_item( ir_struct = REF #( ls_lips ) ) = abap_true.
        rv_result = abap_true.
      ENDIF.
    ELSE.

      lo_likp = mo_ef_parameters->get_appl_table( iv_tabledef = zif_gtt_spof_app_constants=>cs_tabledef-dl_header_new ).
      ASSIGN lo_likp->* TO <ft_likp>.

      lo_lips = mo_ef_parameters->get_appl_table( iv_tabledef = zif_gtt_spof_app_constants=>cs_tabledef-dl_item_new ).
      ASSIGN lo_lips->* TO <ft_lips>.

      CLEAR:
        ls_likp,
        ls_lips.
      READ TABLE <ft_likp> INTO ls_likp INDEX 1.
      IF zcl_gtt_spof_po_tools=>is_appropriate_dl_type( ir_struct = REF #( ls_likp ) ) = abap_true.

        READ TABLE <ft_lips> INTO ls_lips WITH KEY vbeln = i_vbeln
                                                   posnr = i_posnr.
        IF sy-subrc = 0 AND zcl_gtt_spof_po_tools=>is_appropriate_dl_item( ir_struct = REF #( ls_lips ) ) = abap_true.
          rv_result = abap_true.
        ENDIF.

      ENDIF.

    ENDIF.

  ENDMETHOD.


  METHOD zif_gtt_pe_filler~check_relevance.

    TYPES: tt_ekpo    TYPE STANDARD TABLE OF uekpo.
    DATA: lv_dummy    TYPE char100.

    FIELD-SYMBOLS: <ls_ekpo_new> TYPE uekpo,
                   <lt_ekpo_old> TYPE tt_ekpo,
                   <ls_ekpo_old> TYPE uekpo.

    rv_result = zif_gtt_ef_constants=>cs_condition-false.

    IF zcl_gtt_spof_po_tools=>is_appropriate_po_item( ir_ekpo = is_app_objects-maintabref ) = abap_true.

      IF is_app_objects-update_indicator = zif_gtt_ef_constants=>cs_change_mode-insert.
        rv_result = zif_gtt_ef_constants=>cs_condition-true.
      ELSE.
        DATA(lr_ekpo) = mo_ef_parameters->get_appl_table(
          iv_tabledef = zif_gtt_spof_app_constants=>cs_tabledef-po_item_old ).

        ASSIGN is_app_objects-maintabref->* TO <ls_ekpo_new>.
        ASSIGN lr_ekpo->* TO <lt_ekpo_old>.

        IF <ls_ekpo_new> IS ASSIGNED AND
           <lt_ekpo_old> IS ASSIGNED AND
           ( <ls_ekpo_new>-kz = zif_gtt_ef_constants=>cs_change_mode-update OR
             <ls_ekpo_new>-kz = zif_gtt_ef_constants=>cs_change_mode-undefined ).

          READ TABLE <lt_ekpo_old> ASSIGNING <ls_ekpo_old>
            WITH KEY ebeln = <ls_ekpo_new>-ebeln
                     ebelp = <ls_ekpo_new>-ebelp.
          IF sy-subrc = 0.
            rv_result = COND #( WHEN <ls_ekpo_new>-kzabs <> <ls_ekpo_old>-kzabs OR
                                     <ls_ekpo_new>-wepos <> <ls_ekpo_old>-wepos OR
                                     <ls_ekpo_new>-loekz <> <ls_ekpo_old>-loekz
                                  THEN zif_gtt_ef_constants=>cs_condition-true
                                  ELSE zif_gtt_ef_constants=>cs_condition-false ).
          ELSE.
            MESSAGE e005(zgtt)
              WITH 'EKPO' |{ <ls_ekpo_new>-ebeln }{ <ls_ekpo_new>-ebelp }|
              INTO lv_dummy.
            zcl_gtt_tools=>throw_exception( ).
          ENDIF.
        ELSE.
          MESSAGE e002(zgtt) WITH 'EKPO' INTO lv_dummy.
          zcl_gtt_tools=>throw_exception( ).
        ENDIF.
      ENDIF.
    ENDIF.
  ENDMETHOD.


  METHOD zif_gtt_pe_filler~get_planed_events.
    add_confirmation_event(
      EXPORTING
        is_app_objects  = is_app_objects
      CHANGING
        ct_expeventdata = ct_expeventdata ).

    add_goods_receipt_event(
      EXPORTING
        is_app_objects  = is_app_objects
      CHANGING
        ct_expeventdata = ct_expeventdata ).

    add_dlv_item_completed_event(
      EXPORTING
        is_app_objects  = is_app_objects
        ir_ekes_data    = mo_ef_parameters->get_appl_table(
                         iv_tabledef = zif_gtt_spof_app_constants=>cs_tabledef-po_vend_conf_new )
      CHANGING
        ct_expeventdata = ct_expeventdata ).

  ENDMETHOD.
ENDCLASS.
