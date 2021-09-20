CLASS zcl_gtt_mia_ae_filler_dlh_gr DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES zif_gtt_mia_ae_filler .

    METHODS constructor
      IMPORTING
        !io_ae_parameters TYPE REF TO zif_gtt_mia_ae_parameters .
  PROTECTED SECTION.
private section.

  types:
    BEGIN OF ts_dl_item_id,
        vbeln TYPE vbeln_vl,
        posnr TYPE posnr_vl,
      END OF ts_dl_item_id .
  types:
    tt_vbeln    TYPE STANDARD TABLE OF vbeln_vl .
  types:
    tt_pos     TYPE STANDARD TABLE OF ts_dl_item_id .
  types:
    tt_lips  TYPE STANDARD TABLE OF lips .

  data MO_AE_PARAMETERS type ref to ZIF_GTT_MIA_AE_PARAMETERS .

  methods GET_DELIVERY_IDS
    importing
      !IR_MD_POS type ref to DATA
    exporting
      !ET_VBELN type TT_VBELN
    raising
      CX_UDM_MESSAGE .
  methods IS_APPROPRIATE_DEFINITION
    importing
      !IS_EVENTS type TRXAS_EVT_CTAB_WA
    returning
      value(RV_RESULT) type ABAP_BOOL
    raising
      CX_UDM_MESSAGE .
  methods IS_APPROPRIATE_MD_TYPE
    importing
      !IR_MD_HEAD type ref to DATA
    returning
      value(RV_RESULT) type ABAP_BOOL
    raising
      CX_UDM_MESSAGE .
  methods IS_APPROPRIATE_DL_ITEM
    importing
      !IR_MD_POS type ref to DATA
    returning
      value(RV_RESULT) type ABAP_BOOL
    raising
      CX_UDM_MESSAGE .
  methods IS_APPROPRIATE_DL_TYPE
    importing
      !IR_MD_POS type ref to DATA
    returning
      value(RV_RESULT) type ABAP_BOOL
    raising
      CX_UDM_MESSAGE .
  methods IS_CREATION_MODE
    importing
      !IS_EVENTS type TRXAS_EVT_CTAB_WA
    returning
      value(RV_RESULT) type ABAP_BOOL
    raising
      CX_UDM_MESSAGE .
  methods IS_REVERAL_DOCUMENT
    importing
      !IR_MD_POS type ref to DATA
    returning
      value(RV_RESULT) type ABAP_BOOL
    raising
      CX_UDM_MESSAGE .
  methods GET_ITEMS_BY_DELIVERY_IDS
    importing
      !IT_VBELN type TT_VBELN
    exporting
      !ET_LIPS type TT_LIPS .
ENDCLASS.



CLASS ZCL_GTT_MIA_AE_FILLER_DLH_GR IMPLEMENTATION.


  METHOD constructor.

    mo_ae_parameters  = io_ae_parameters.

  ENDMETHOD.


  METHOD get_delivery_ids.

    DATA: lv_vbeln    TYPE vbeln_vl.

    FIELD-SYMBOLS: <lt_mseg>    TYPE zif_gtt_mia_app_types=>tt_mseg.

    CLEAR: et_vbeln[].

    ASSIGN ir_md_pos->* TO <lt_mseg>.

    IF <lt_mseg> IS ASSIGNED.
      LOOP AT <lt_mseg> ASSIGNING FIELD-SYMBOL(<ls_mseg>)
        WHERE vbeln_im IS NOT INITIAL.

        IF NOT line_exists( et_vbeln[ table_line = <ls_mseg>-vbeln_im ] ).
          APPEND <ls_mseg>-vbeln_im TO et_vbeln.
        ENDIF.
      ENDLOOP.
    ELSE.
      MESSAGE e002(zgtt_mia) WITH 'MSEG' INTO DATA(lv_dummy).
      zcl_gtt_mia_tools=>throw_exception( ).
    ENDIF.

  ENDMETHOD.


  METHOD is_appropriate_definition.

    rv_result = boolc( is_events-maintabdef = zif_gtt_mia_app_constants=>cs_tabledef-md_material_header ).

  ENDMETHOD.


  METHOD is_appropriate_dl_item.

    DATA: lt_vbeln TYPE tt_vbeln,
          lt_lips  TYPE STANDARD TABLE OF lips.

    rv_result   = abap_false.

    get_delivery_ids(
      EXPORTING
        ir_md_pos = ir_md_pos
      IMPORTING
        et_vbeln  = lt_vbeln ).

    IF lt_vbeln[] IS NOT INITIAL.
      get_items_by_delivery_ids(
        EXPORTING
          it_vbeln =  lt_vbeln
        IMPORTING
          et_lips  =  lt_lips
      ).
      LOOP AT lt_lips ASSIGNING FIELD-SYMBOL(<ls_lips>).
        rv_result   = boolc( sy-subrc = 0 AND
                             zcl_gtt_mia_dl_tools=>is_appropriate_dl_item(
                               ir_struct = REF #( <ls_lips> ) ) = abap_true ).
        IF rv_result = abap_true.
          EXIT.
        ENDIF.
      ENDLOOP.
    ENDIF.

  ENDMETHOD.


  METHOD is_appropriate_dl_type.

    DATA: lt_vbeln TYPE tt_vbeln,
          lt_likp  TYPE STANDARD TABLE OF likp.

    rv_result   = abap_false.

    get_delivery_ids(
      EXPORTING
        ir_md_pos = ir_md_pos
      IMPORTING
        et_vbeln  = lt_vbeln ).

    IF lt_vbeln[] IS NOT INITIAL.
      SELECT *
        INTO TABLE lt_likp
        FROM likp
        FOR ALL ENTRIES IN lt_vbeln
        WHERE vbeln = lt_vbeln-table_line.

      LOOP AT lt_likp ASSIGNING FIELD-SYMBOL(<ls_likp>).
        rv_result   = boolc( sy-subrc = 0 AND
                             zcl_gtt_mia_dl_tools=>is_appropriate_dl_type(
                               ir_struct = REF #( <ls_likp> ) ) = abap_true ).
        IF rv_result = abap_true.
          EXIT.
        ENDIF.
      ENDLOOP.
    ENDIF.

  ENDMETHOD.


  METHOD is_appropriate_md_type.

    DATA: lv_md_type  TYPE mkpf-blart.

    lv_md_type  = zcl_gtt_mia_tools=>get_field_of_structure(
                    ir_struct_data = ir_md_head
                    iv_field_name  = 'BLART' ).

    rv_result   = boolc( lv_md_type = zif_gtt_mia_app_constants=>cs_md_type-goods_receipt ).

  ENDMETHOD.


  METHOD is_creation_mode.

    DATA: lv_mblnr TYPE mkpf-mblnr,
          lv_mjahr TYPE mkpf-mjahr.

    IF is_events-update_indicator = zif_gtt_mia_ef_constants=>cs_change_mode-insert.
      rv_result = abap_true.
    ELSEIF is_events-update_indicator = zif_gtt_mia_ef_constants=>cs_change_mode-undefined.
      lv_mblnr  = zcl_gtt_mia_tools=>get_field_of_structure(
                      ir_struct_data = is_events-maintabref
                      iv_field_name  = 'MBLNR' ).

      lv_mjahr  = zcl_gtt_mia_tools=>get_field_of_structure(
                      ir_struct_data = is_events-maintabref
                      iv_field_name  = 'MJAHR' ).

      SELECT SINGLE mblnr INTO lv_mblnr
        FROM mkpf
        WHERE mblnr = lv_mblnr
          AND mjahr = lv_mjahr.

      rv_result = boolc( sy-subrc <> 0 ).
    ELSE.
      rv_result = abap_false.
    ENDIF.

  ENDMETHOD.


  METHOD is_reveral_document.

    DATA: lv_vbeln    TYPE vbeln_vl.

    FIELD-SYMBOLS: <lt_mseg>    TYPE zif_gtt_mia_app_types=>tt_mseg.

    ASSIGN ir_md_pos->* TO <lt_mseg>.

    IF <lt_mseg> IS ASSIGNED.
      READ TABLE <lt_mseg> ASSIGNING FIELD-SYMBOL(<ls_mseg>) INDEX 1.

      rv_result = boolc( sy-subrc = 0 AND <ls_mseg>-smbln IS NOT INITIAL ).

    ELSE.
      MESSAGE e002(zgtt_mia) WITH 'MSEG' INTO DATA(lv_dummy).
      zcl_gtt_mia_tools=>throw_exception( ).
    ENDIF.

  ENDMETHOD.


  METHOD zif_gtt_mia_ae_filler~check_relevance.

    DATA: lv_mng_new    TYPE menge_d.

    DATA(lr_md_pos) = mo_ae_parameters->get_appl_table(
                        iv_tabledef = zif_gtt_mia_app_constants=>cs_tabledef-md_material_segment ).

    rv_result       = zif_gtt_mia_ef_constants=>cs_condition-false.

    " mkpf-blart        = 'WE'
    " update_indicator  = insert
    IF is_appropriate_definition( is_events = is_events ) = abap_true AND
       is_appropriate_md_type( ir_md_head = is_events-maintabref ) = abap_true AND
       is_appropriate_dl_type( ir_md_pos  = lr_md_pos ) = abap_true AND
       is_appropriate_dl_item( ir_md_pos  = lr_md_pos ) = abap_true AND
       is_creation_mode( is_events = is_events ) = abap_true.

      rv_result   = zif_gtt_mia_ef_constants=>cs_condition-true.
    ENDIF.

  ENDMETHOD.


  METHOD zif_gtt_mia_ae_filler~get_event_data.

    DATA:
      lt_vbeln           TYPE tt_vbeln,
      lt_lips            TYPE tt_lips,
      lv_tmp_dlvhdtrxcod TYPE /saptrx/trxcod,
      lv_dlvhdtrxcod     TYPE /saptrx/trxcod,
      lv_tmp_dlvittrxcod TYPE /saptrx/trxcod,
      lv_dlvittrxcod     TYPE /saptrx/trxcod.

    DATA(lr_md_pos)   = mo_ae_parameters->get_appl_table(
                          iv_tabledef = zif_gtt_mia_app_constants=>cs_tabledef-md_material_segment ).

    DATA(lv_reversal) = is_reveral_document( ir_md_pos = lr_md_pos ).

    lv_dlvhdtrxcod = zif_gtt_mia_app_constants=>cs_trxcod-dl_number.
    lv_dlvittrxcod = zif_gtt_mia_app_constants=>cs_trxcod-dl_position.

    TRY.
        CALL FUNCTION 'ZGTT_SOF_GET_TRACKID'
          EXPORTING
            iv_type        = is_events-eventtype
            iv_app         = 'MIA'
          IMPORTING
            ev_dlvhdtrxcod = lv_tmp_dlvhdtrxcod
            ev_dlvittrxcod = lv_tmp_dlvittrxcod.

        IF lv_tmp_dlvhdtrxcod IS NOT INITIAL.
          lv_dlvhdtrxcod = lv_tmp_dlvhdtrxcod.
        ENDIF.

        IF lv_tmp_dlvittrxcod IS NOT INITIAL.
          lv_dlvittrxcod = lv_tmp_dlvittrxcod.
        ENDIF.

      CATCH cx_sy_dyn_call_illegal_func.
    ENDTRY.

    get_delivery_ids(
      EXPORTING
        ir_md_pos = lr_md_pos
      IMPORTING
        et_vbeln  = lt_vbeln ).

    get_items_by_delivery_ids(
      EXPORTING
        it_vbeln = lt_vbeln
      IMPORTING
        et_lips  = lt_lips
    ).

    " Goods receipt for header
    LOOP AT lt_vbeln ASSIGNING FIELD-SYMBOL(<lv_vbeln>).
      DATA(lv_evtcnt) = zcl_gtt_mia_sh_tools=>get_next_event_counter( ).

      ct_trackingheader = VALUE #( BASE ct_trackingheader (
        language    = sy-langu
        trxid       = zcl_gtt_mia_dl_tools=>get_tracking_id_dl_header(
                        ir_likp = NEW likp( vbeln = <lv_vbeln> ) )
        trxcod      = lv_dlvhdtrxcod
        evtcnt      = lv_evtcnt
        evtid       = zif_gtt_mia_app_constants=>cs_milestone-dl_goods_receipt
        evtdat      = sy-datum
        evttim      = sy-uzeit
        evtzon      = zcl_gtt_mia_tools=>get_system_time_zone( )
      ) ).

      ct_eventid_map  = VALUE #( BASE ct_eventid_map (
        eventid     = is_events-eventid
        evtcnt      = lv_evtcnt
      ) ).

      ct_trackparameters  = VALUE #( BASE ct_trackparameters (
        evtcnt      = lv_evtcnt
        param_name  = zif_gtt_mia_app_constants=>cs_event_param-reversal
        param_value = lv_reversal
      ) ).
    ENDLOOP.

    " Goods receipt for Item
    LOOP AT lt_lips ASSIGNING FIELD-SYMBOL(<ls_lips>).
      IF  zcl_gtt_mia_dl_tools=>is_appropriate_dl_item( ir_struct = REF #( <ls_lips> ) ) = abap_false.
        CONTINUE.
      ENDIF.
      lv_evtcnt = zcl_gtt_mia_sh_tools=>get_next_event_counter( ).

      ct_trackingheader = VALUE #( BASE ct_trackingheader (
        language    = sy-langu
        trxid       = zcl_gtt_mia_dl_tools=>get_tracking_id_dl_item(
                        ir_lips = NEW lips( vbeln = <ls_lips>-vbeln posnr = <ls_lips>-posnr  ) )
        trxcod      = lv_dlvittrxcod
        evtcnt      = lv_evtcnt
        evtid       = zif_gtt_mia_app_constants=>cs_milestone-dl_goods_receipt
        evtdat      = sy-datum
        evttim      = sy-uzeit
        evtzon      = zcl_gtt_mia_tools=>get_system_time_zone( )
      ) ).

      ct_eventid_map  = VALUE #( BASE ct_eventid_map (
        eventid     = is_events-eventid
        evtcnt      = lv_evtcnt
      ) ).

      ct_trackparameters  = VALUE #( BASE ct_trackparameters (
        evtcnt      = lv_evtcnt
        param_name  = zif_gtt_mia_app_constants=>cs_event_param-reversal
        param_value = lv_reversal
      ) ).
    ENDLOOP.


  ENDMETHOD.


  METHOD get_items_by_delivery_ids.

    CLEAR: et_lips[].
    IF it_vbeln[] IS NOT INITIAL.
     SELECT *
        INTO TABLE et_lips
        FROM lips
        FOR ALL ENTRIES IN it_vbeln
        WHERE vbeln = it_vbeln-table_line.

    ENDIF.

  ENDMETHOD.
ENDCLASS.
