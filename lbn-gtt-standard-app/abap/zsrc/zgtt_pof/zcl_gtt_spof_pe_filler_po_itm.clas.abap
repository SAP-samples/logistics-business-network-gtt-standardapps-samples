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

  types:
    BEGIN OF ts_dl_header,
      vbeln TYPE vbeln_vl,
      lfart TYPE lfart,
    END OF ts_dl_header.
  types:
    tt_dl_header TYPE STANDARD TABLE OF ts_dl_header.

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
  methods ADD_PLANNED_DELIVERY_EVENT
    importing
      !IS_APP_OBJECTS type TRXAS_APPOBJ_CTAB_WA
    changing
      !CT_EXPEVENTDATA type ZIF_GTT_EF_TYPES=>TT_EXPEVENTDATA
    raising
      CX_UDM_MESSAGE .
  methods GET_PLANNED_DELIVERY_DATETIME
    importing
      !I_DELIVERY_DATE type EINDT
    returning
      value(RV_DATETIME) type /SAPTRX/EVENT_EXP_DATETIME
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
  methods GET_LATEST_DELIVERY_DATE
    importing
      !IR_EKPO type ref to DATA
      !IR_EKET type ref to DATA
    returning
      value(RV_EINDT) type EINDT
    raising
      CX_UDM_MESSAGE .
  methods ADD_ODLV_ITEM_COMPLETED_EVENT
    importing
      !IS_APP_OBJECTS type TRXAS_APPOBJ_CTAB_WA
    changing
      !CT_EXPEVENTDATA type ZIF_GTT_EF_TYPES=>TT_EXPEVENTDATA
    raising
      CX_UDM_MESSAGE .
ENDCLASS.



CLASS ZCL_GTT_SPOF_PE_FILLER_PO_ITM IMPLEMENTATION.


  METHOD add_confirmation_event.
    DATA: lv_enable_conf TYPE abap_bool.

    lv_enable_conf = zcl_gtt_spof_po_tools=>is_enable_confirmation_po_item( ir_ekpo = is_app_objects-maintabref ).

    IF lv_enable_conf = abap_true AND zcl_gtt_spof_po_tools=>is_appropriate_po_item( ir_ekko = is_app_objects-mastertabref ir_ekpo = is_app_objects-maintabref ) = abap_true.
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

    lv_gr_conf = zcl_gtt_spof_po_tools=>is_appropriate_po_item( ir_ekko = is_app_objects-mastertabref ir_ekpo = is_app_objects-maintabref ).

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

    lv_conf = zcl_gtt_spof_po_tools=>is_appropriate_po_item( ir_ekko = is_app_objects-mastertabref ir_ekpo = is_app_objects-maintabref ).

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
       zcl_gtt_tools=>is_appropriate_dl_type(
         ir_likp = REF #( ls_likp ) ) = abap_true.

      SELECT SINGLE * INTO ls_lips
         FROM lips
         WHERE vbeln = i_vbeln AND posnr = i_posnr.

      IF sy-subrc = 0 AND zcl_gtt_tools=>is_appropriate_dl_item( ir_likp = REF #( ls_likp ) ir_lips = REF #( ls_lips ) ) = abap_true.
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
      IF zcl_gtt_tools=>is_appropriate_dl_type( ir_likp = REF #( ls_likp ) ) = abap_true.

        READ TABLE <ft_lips> INTO ls_lips WITH KEY vbeln = i_vbeln
                                                   posnr = i_posnr.
        IF sy-subrc = 0 AND zcl_gtt_tools=>is_appropriate_dl_item( ir_likp = REF #( ls_likp ) ir_lips = REF #( ls_lips ) ) = abap_true.
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

    IF zcl_gtt_spof_po_tools=>is_appropriate_po_item( ir_ekko = is_app_objects-mastertabref ir_ekpo = is_app_objects-maintabref ) = abap_true.

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

    add_planned_delivery_event(
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

*   If it is a STO purchase order item,add outbound delivery item completed planned event
    add_odlv_item_completed_event(
      EXPORTING
        is_app_objects  = is_app_objects
      CHANGING
        ct_expeventdata = ct_expeventdata ).

  ENDMETHOD.


  METHOD add_planned_delivery_event.
    DATA: lv_loekz       TYPE ekpo-loekz,
          lv_conf        TYPE abap_bool,
          lv_latest_date TYPE eindt.

    lv_conf = zcl_gtt_spof_po_tools=>is_appropriate_po_item( ir_ekko = is_app_objects-mastertabref ir_ekpo = is_app_objects-maintabref ).

    IF lv_conf EQ abap_true.
      lv_latest_date = get_latest_delivery_date(
        EXPORTING
          ir_ekpo  = is_app_objects-maintabref
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
                                      THEN get_planned_delivery_datetime( i_delivery_date = lv_latest_date ) )
        milestonenum      = zcl_gtt_tools=>get_next_sequence_id(
                                      it_expeventdata = ct_expeventdata )
      ) ).

    ENDIF.
  ENDMETHOD.


  METHOD get_latest_delivery_date.
    DATA: lv_eindt_max TYPE eket-eindt,
          lv_eindt_set TYPE abap_bool VALUE abap_false.

    FIELD-SYMBOLS: <lt_eket> TYPE zif_gtt_spof_app_types=>tt_ueket,
                   <ls_eket> TYPE zif_gtt_spof_app_types=>ts_ueket.

    CLEAR: rv_eindt.

    DATA(lv_ebeln) = CONV ebeln( zcl_gtt_tools=>get_field_of_structure(
                         ir_struct_data = ir_ekpo
                         iv_field_name  = 'EBELN'
              ) ).

    DATA(lv_ebelp) = CONV ebelp( zcl_gtt_tools=>get_field_of_structure(
                         ir_struct_data = ir_ekpo
                         iv_field_name  = 'EBELP'
              ) ).
    ASSIGN ir_eket->* TO <lt_eket>.
    IF <lt_eket> IS ASSIGNED.
      " keep Latest Delivery Date in schedule lines per item.
      LOOP AT <lt_eket> ASSIGNING <ls_eket>
         WHERE ebeln  = lv_ebeln
          AND ebelp  = lv_ebelp
          AND  kz <> zif_gtt_ef_constants=>cs_change_mode-delete
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


  METHOD get_planned_delivery_datetime.
    rv_datetime = zcl_gtt_tools=>get_local_timestamp(
      iv_date = i_delivery_date
      iv_time = CONV t( '235959' ) ).
  ENDMETHOD.


  METHOD add_odlv_item_completed_event.

    FIELD-SYMBOLS:
      <lt_likp> TYPE va_likpvb_t,
      <lt_lips> TYPE va_lipsvb_t.

    DATA:
      lv_ebeln     TYPE ebeln,
      lv_ebelp     TYPE ebelp,
      lv_conf      TYPE abap_bool,
      lt_dl_item   TYPE tt_dl_item_id,
      lt_dl_header TYPE tt_dl_header,
      ls_dl_header TYPE ts_dl_header,
      lr_likp      TYPE REF TO data,
      lr_lips      TYPE REF TO data,
      ls_dlv_data  TYPE ts_dl_item_id,
      lt_dlv_data  TYPE tt_dl_item_id,
      lv_locid2    TYPE /saptrx/loc_id_2.

    lv_ebeln = zcl_gtt_tools=>get_field_of_structure(
      ir_struct_data = is_app_objects-maintabref
      iv_field_name  = 'EBELN' ).

    lv_ebelp = zcl_gtt_tools=>get_field_of_structure(
      ir_struct_data = is_app_objects-maintabref
      iv_field_name  = 'EBELP' ).

    lv_conf = zcl_gtt_spof_po_tools=>is_appropriate_po_item( ir_ekko = is_app_objects-mastertabref ir_ekpo = is_app_objects-maintabref ).

    CHECK lv_conf = abap_true.

    zcl_gtt_sof_toolkit=>get_delivery_type(
      RECEIVING
        rt_type = DATA(lt_delv_type) ).

*   PO item planned event also can be called from outbound delivery cross PO item(STO scenario)
*   (function module ZGTT_SPOF_CTP_DL_TO_PO -> ZGTT_SPOF_EE_PO_ITM -> Method ADD_ODLV_ITEM_COMPLETED_EVENT of class ZCL_GTT_SPOF_PE_FILLER_PO_ITM )
*   In this case,the outbound delivery header and item data were stored in the cache table,retrive data from cache table is a more efficient way.
    TRY.
        lr_likp = mo_ef_parameters->get_appl_table( iv_tabledef = zif_gtt_spof_app_constants=>cs_tabledef-dl_header_new ).
        lr_lips = mo_ef_parameters->get_appl_table( iv_tabledef = zif_gtt_spof_app_constants=>cs_tabledef-dl_item_new ).
      CATCH cx_udm_message.
    ENDTRY.
    IF lr_likp IS BOUND AND lr_lips IS BOUND.
      ASSIGN lr_likp->* TO <lt_likp>.
      ASSIGN lr_lips->* TO <lt_lips>.
    ENDIF.

*   Based on PO number,get delivery data from cache
    IF <lt_likp> IS ASSIGNED AND <lt_lips> IS ASSIGNED.
      LOOP AT <lt_lips> ASSIGNING FIELD-SYMBOL(<fs_lips>)
        WHERE vgbel = lv_ebeln
          AND vgpos = lv_ebelp
          AND vgtyp = if_sd_doc_category=>purchase_order.
        READ TABLE <lt_likp> ASSIGNING FIELD-SYMBOL(<fs_likp>)
          WITH KEY vbeln = <fs_lips>-vbeln
                   vbtyp = if_sd_doc_category=>delivery.
        IF sy-subrc = 0 AND <fs_likp>-lfart IN lt_delv_type.
          ls_dlv_data-vbeln = <fs_lips>-vbeln.
          ls_dlv_data-posnr = <fs_lips>-posnr.
          APPEND ls_dlv_data TO lt_dlv_data.
          CLEAR ls_dlv_data.
        ENDIF.
      ENDLOOP.
    ENDIF.

*   Based on PO number,get delivery data from DB
    SELECT vbeln
           posnr
      INTO TABLE lt_dl_item
      FROM lips
     WHERE vgbel = lv_ebeln
       AND vgpos = lv_ebelp
       AND vgtyp = if_sd_doc_category=>purchase_order.

    IF lt_dl_item IS NOT INITIAL.
      SELECT vbeln
             lfart
        INTO TABLE lt_dl_header
        FROM likp
         FOR ALL ENTRIES IN lt_dl_item
       WHERE vbeln = lt_dl_item-vbeln
         AND vbtyp = if_sd_doc_category=>delivery.
    ENDIF.

    LOOP AT lt_dl_item ASSIGNING FIELD-SYMBOL(<ls_dl_item>).
      CLEAR:ls_dl_header.
      READ TABLE lt_dl_header INTO ls_dl_header
        WITH KEY vbeln = <ls_dl_item>-vbeln.
      IF sy-subrc = 0 AND ls_dl_header-lfart IN lt_delv_type.
        ls_dlv_data-vbeln = <ls_dl_item>-vbeln.
        ls_dlv_data-posnr = <ls_dl_item>-posnr.
        APPEND ls_dlv_data TO lt_dlv_data.
        CLEAR ls_dlv_data.
      ENDIF.
    ENDLOOP.

*   Merge the delivery data and delete the duplicated record
    SORT lt_dlv_data BY vbeln posnr.
    DELETE ADJACENT DUPLICATES FROM lt_dlv_data COMPARING ALL FIELDS.

    LOOP AT lt_dlv_data INTO ls_dlv_data.
      lv_locid2 = |{ ls_dlv_data-vbeln ALPHA = OUT }{ ls_dlv_data-posnr ALPHA = IN }|.
      CONDENSE lv_locid2 NO-GAPS.
      ct_expeventdata = VALUE #( BASE ct_expeventdata (
           appsys            = mo_ef_parameters->get_appsys(  )
           appobjtype        = mo_ef_parameters->get_app_obj_types( )-aotype
           language          = sy-langu
           appobjid          = is_app_objects-appobjid
           milestone         = zif_gtt_sof_constants=>cs_milestone-dlv_item_completed
           locid2            = lv_locid2
           milestonenum      = zcl_gtt_tools=>get_next_sequence_id(
                               it_expeventdata = ct_expeventdata )   ) ).

    ENDLOOP.

  ENDMETHOD.
ENDCLASS.
