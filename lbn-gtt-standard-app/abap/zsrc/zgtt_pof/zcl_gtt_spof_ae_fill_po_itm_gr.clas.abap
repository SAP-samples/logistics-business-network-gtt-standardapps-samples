CLASS zcl_gtt_spof_ae_fill_po_itm_gr DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES zif_gtt_ae_filler .

    TYPES:
     lt_ekbe_t TYPE SORTED TABLE OF ekbe
                   WITH UNIQUE KEY table_line.
    TYPES:
     lt_ekbz_t TYPE SORTED TABLE OF ekbz
                   WITH UNIQUE KEY table_line.

    METHODS constructor
      IMPORTING
        !io_ae_parameters TYPE REF TO zif_gtt_ae_parameters .
  PROTECTED SECTION.
  PRIVATE SECTION.

    DATA mo_ae_parameters TYPE REF TO zif_gtt_ae_parameters .
    DATA mv_archived TYPE boole_d .

    METHODS is_creation_mode
      IMPORTING
        !is_events       TYPE trxas_evt_ctab_wa
      RETURNING
        VALUE(rv_result) TYPE abap_bool
      RAISING
        cx_udm_message .
    METHODS get_goods_receipt_quantity
      IMPORTING
        !ir_goods_receipt TYPE REF TO data
      RETURNING
        VALUE(rv_menge)   TYPE menge_d
      RAISING
        cx_udm_message .
    METHODS get_goods_receipt_quantity_dif
      IMPORTING
        !is_events           TYPE trxas_evt_ctab_wa
      RETURNING
        VALUE(rv_difference) TYPE menge_d
      RAISING
        cx_udm_message .
    METHODS is_delivery_completed
      IMPORTING
        !ir_goods_receipt   TYPE REF TO data
      RETURNING
        VALUE(rv_completed) TYPE abap_bool
      RAISING
        cx_udm_message .
    METHODS is_appropriate_definition
      IMPORTING
        !is_events       TYPE trxas_evt_ctab_wa
      RETURNING
        VALUE(rv_result) TYPE abap_bool
      RAISING
        cx_udm_message .
    METHODS is_appropriate_md_type
      IMPORTING
        !ir_md_head      TYPE REF TO data
      RETURNING
        VALUE(rv_result) TYPE abap_bool
      RAISING
        cx_udm_message .
    METHODS is_appropriate_po_item
      IMPORTING
        !ir_md_pos       TYPE REF TO data
      RETURNING
        VALUE(rv_result) TYPE abap_bool
      RAISING
        cx_udm_message .
    METHODS get_full_quantity_for_gr
      IMPORTING
        !is_events         TYPE trxas_evt_ctab_wa
      RETURNING
        VALUE(rv_quantity) TYPE menge_d
      RAISING
        cx_udm_message .
    METHODS get_po_item_history
      IMPORTING
        !i_ebeln TYPE ebeln
        !i_ebelp TYPE ebelp
        !is_ekko TYPE ekko
        !is_ekpo TYPE ekpo
      EXPORTING
        !et_ekbe TYPE zcl_gtt_spof_ae_fill_po_itm_gr=>lt_ekbe_t
        !et_ekbz TYPE zcl_gtt_spof_ae_fill_po_itm_gr=>lt_ekbz_t
      RAISING
        cx_udm_message .
ENDCLASS.



CLASS ZCL_GTT_SPOF_AE_FILL_PO_ITM_GR IMPLEMENTATION.


  METHOD constructor.
    mo_ae_parameters  = io_ae_parameters.
    mv_archived = abap_false.
  ENDMETHOD.


  METHOD get_goods_receipt_quantity.
    DATA: lv_dummy    TYPE char100.

    FIELD-SYMBOLS: <ls_goods_receipt> TYPE any,
                   <lv_quantity>      TYPE any,
                   <lv_sign>          TYPE any.

    ASSIGN ir_goods_receipt->* TO <ls_goods_receipt>.

    IF <ls_goods_receipt> IS ASSIGNED.
      ASSIGN COMPONENT 'MENGE' OF STRUCTURE <ls_goods_receipt> TO <lv_quantity>.
      ASSIGN COMPONENT 'SHKZG' OF STRUCTURE <ls_goods_receipt> TO <lv_sign>.

      IF <lv_quantity> IS ASSIGNED.
        rv_menge    = COND #( WHEN <lv_sign> = 'H'
                                THEN - <lv_quantity>
                                ELSE <lv_quantity> ).
      ELSE.
        MESSAGE e001(zgtt) WITH 'MENGE' 'Goods Receipt' INTO lv_dummy ##NO_TEXT.
        zcl_gtt_tools=>throw_exception( ).
      ENDIF.
    ELSE.
      MESSAGE e002(zgtt) WITH 'Goods Receipt' INTO lv_dummy ##NO_TEXT.
      zcl_gtt_tools=>throw_exception( ).
    ENDIF.
  ENDMETHOD.


  METHOD get_goods_receipt_quantity_dif.
    rv_difference = get_goods_receipt_quantity(
      ir_goods_receipt = is_events-maintabref ).
  ENDMETHOD.


  METHOD is_appropriate_definition.
    rv_result = boolc( is_events-maintabdef = zif_gtt_spof_app_constants=>cs_tabledef-md_material_segment ).
  ENDMETHOD.


  METHOD is_appropriate_md_type.
    DATA: lv_md_type  TYPE mkpf-blart.

    lv_md_type = zcl_gtt_tools=>get_field_of_structure(
      ir_struct_data = ir_md_head
      iv_field_name  = 'BLART' ).

    rv_result   = boolc( lv_md_type = zif_gtt_spof_app_constants=>cs_md_type-goods_receipt ).
  ENDMETHOD.


  METHOD is_appropriate_po_item.
    DATA: ls_ekpo  TYPE ekpo.

    DATA(lv_ebeln)  = CONV ebeln( zcl_gtt_tools=>get_field_of_structure(
                                    ir_struct_data = ir_md_pos
                                    iv_field_name  = 'EBELN' ) ).

    DATA(lv_ebelp)  = CONV ebelp( zcl_gtt_tools=>get_field_of_structure(
                                    ir_struct_data = ir_md_pos
                                    iv_field_name  = 'EBELP' ) ).

    CALL FUNCTION 'ME_EKPO_SINGLE_READ'
      EXPORTING
        pi_ebeln         = lv_ebeln
        pi_ebelp         = lv_ebelp
      IMPORTING
        po_ekpo          = ls_ekpo
      EXCEPTIONS
        no_records_found = 1
        OTHERS           = 2.

    rv_result   = boolc(
      sy-subrc = 0 AND
      zcl_gtt_spof_po_tools=>is_appropriate_po_item( ir_ekpo = REF #( ls_ekpo ) ) = abap_true
    ).
  ENDMETHOD.


  METHOD is_creation_mode.
    DATA: lv_mblnr TYPE mkpf-mblnr,
          lv_mjahr TYPE mkpf-mjahr.

    IF is_events-update_indicator = zif_gtt_ef_constants=>cs_change_mode-insert.
      rv_result = abap_true.
    ELSEIF is_events-update_indicator = zif_gtt_ef_constants=>cs_change_mode-undefined.
      lv_mblnr = zcl_gtt_tools=>get_field_of_structure(
        ir_struct_data = is_events-maintabref
        iv_field_name  = 'MBLNR' ).

      lv_mjahr = zcl_gtt_tools=>get_field_of_structure(
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


  METHOD is_delivery_completed.
    DATA: lv_dummy    TYPE char100.
    FIELD-SYMBOLS: <ls_goods_receipt> TYPE any,
                   <lv_is_completed>  TYPE any.

    rv_completed = abap_false.
    ASSIGN ir_goods_receipt->* TO <ls_goods_receipt>.

    IF <ls_goods_receipt> IS ASSIGNED.
      ASSIGN COMPONENT 'ELIKZ' OF STRUCTURE <ls_goods_receipt> TO <lv_is_completed>.

      IF <lv_is_completed> IS ASSIGNED.
        rv_completed = boolc( <lv_is_completed> EQ abap_true ).
      ELSE.
        MESSAGE e001(zgtt) WITH 'ELIKZ' 'Goods Receipt' INTO lv_dummy ##NO_TEXT.
        zcl_gtt_tools=>throw_exception( ).
      ENDIF.
    ELSE.
      MESSAGE e002(zgtt) WITH 'Goods Receipt' INTO lv_dummy ##NO_TEXT.
      zcl_gtt_tools=>throw_exception( ).
    ENDIF.
  ENDMETHOD.


  METHOD get_full_quantity_for_gr.

    DATA: lv_ebeln TYPE ekpo-ebeln,
          lv_ebelp TYPE ekpo-ebelp,
          ls_ekko  TYPE ekko,
          ls_ekpo  TYPE ekpo.

    DATA: lt_ekbe TYPE zcl_gtt_spof_ae_fill_po_itm_gr=>lt_ekbe_t,
          lt_ekbz TYPE zcl_gtt_spof_ae_fill_po_itm_gr=>lt_ekbz_t.

    DATA: lv_total_quantity TYPE menge_d VALUE 0.

    DATA(lv_current_quantity) = get_goods_receipt_quantity(
      ir_goods_receipt = is_events-maintabref ).

    lv_ebeln = zcl_gtt_tools=>get_field_of_structure(
      ir_struct_data = is_events-maintabref
      iv_field_name  = 'EBELN' ).

    lv_ebelp = zcl_gtt_tools=>get_field_of_structure(
      ir_struct_data = is_events-maintabref
      iv_field_name  = 'EBELP' ).

    zcl_gtt_spof_po_tools=>get_po_header(
      EXPORTING
        i_ebeln    = lv_ebeln
      IMPORTING
        es_ekko    = ls_ekko
        e_archived = mv_archived
    ).

    zcl_gtt_spof_po_tools=>get_po_item(
      EXPORTING
        i_ebeln    = lv_ebeln
        i_ebelp    = lv_ebelp
        is_ekko    = ls_ekko
        i_archived = mv_archived
      IMPORTING
        es_ekpo    = ls_ekpo
    ).

    get_po_item_history(
      EXPORTING
        i_ebeln = lv_ebeln
        i_ebelp = lv_ebelp
        is_ekko = ls_ekko
        is_ekpo = ls_ekpo
      IMPORTING
        et_ekbe = lt_ekbe
    ).

    LOOP AT lt_ekbe INTO DATA(ls_ekbe) WHERE vgabe NE '7'.
      IF ls_ekbe-shkzg EQ 'H'.
        ls_ekbe-menge = ls_ekbe-menge * ( -1 ).
      ENDIF.
      IF ls_ekpo-bstyp NE 'K'.
* no quantities for blanket items, service items with no SRV-based IR
* and items with an invoicing plan
        IF ls_ekbe-vgabe EQ '9'
               OR   ls_ekpo-pstyp EQ '1'
               OR ( ls_ekpo-pstyp EQ '9' AND ls_ekpo-lebre IS INITIAL )
               OR   ls_ekpo-fplnr IS NOT INITIAL.
          CONTINUE.
        ENDIF.
      ENDIF.
      lv_total_quantity = lv_total_quantity + ls_ekbe-menge.
    ENDLOOP.

    DATA(lv_diff) = get_goods_receipt_quantity_dif( is_events = is_events ).
    lv_diff = lv_diff * ls_ekpo-umren / ls_ekpo-umrez.
    rv_quantity = lv_total_quantity + lv_diff.
  ENDMETHOD.


  METHOD get_po_item_history.

    DATA:
      lt_ekbe  TYPE STANDARD TABLE OF ekbe,
      lt_ekbes TYPE STANDARD TABLE OF ekbes,
      lt_ekbz  TYPE STANDARD TABLE OF ekbz,
      lt_ekbez TYPE STANDARD TABLE OF ekbez,
      ls_ekbe  TYPE ekbe,
      ls_ekbz  TYPE ekbz.
    FIELD-SYMBOLS: <ekbe> TYPE ekbe,
                   <ekbz> TYPE ekbz.
    DATA: lo_po_history_diff TYPE REF TO cl_po_history_with_diff_inv. "EhP6 DInv

    IF mv_archived EQ abap_false.                           "1624571
      CALL FUNCTION 'ME_READ_HISTORY'
        EXPORTING
          ebeln  = i_ebeln
          ebelp  = i_ebelp
          webre  = is_ekpo-webre
          vrtkz  = is_ekpo-vrtkz
        TABLES
          xekbe  = lt_ekbe
          xekbes = lt_ekbes
          xekbez = lt_ekbez
          xekbz  = lt_ekbz.
    ELSE.                                                   "v_"1624571
      TRY.
          cl_mmpur_archive=>if_mmpur_archive~get_archived_pd(
            EXPORTING
              im_ebeln = i_ebeln
              im_bstyp = is_ekko-bstyp
            IMPORTING
              ex_ekbe  = lt_ekbe
              ex_ekbz  = lt_ekbz ).
        CATCH cx_mmpur_no_authority.
          CLEAR: lt_ekbe, lt_ekbz.
        CATCH cx_mmpur_root.
          CLEAR: lt_ekbe, lt_ekbz.
      ENDTRY.
    ENDIF.                                                  "^_1624571

*-----------------------EhP6 DInv--Start---------------------
    IF cl_ops_switch_check=>mm_sfws_dinv_01( ) = abap_true AND
       is_ekpo-diff_invoice EQ cl_mmpur_constants=>diff_invoice_2.

      lo_po_history_diff = cl_po_history_with_diff_inv=>get_instance( ).

      CALL METHOD lo_po_history_diff->add_diff_inv_to_po_history
        CHANGING
          ct_ekbe = lt_ekbe.
    ENDIF.
*-----------------------EhP6 DInv--End---------------------
    LOOP AT lt_ekbe ASSIGNING <ekbe>.
      CHECK <ekbe>-ebelp EQ i_ebelp.                        "1624571
      ls_ekbe = <ekbe>.
      INSERT ls_ekbe INTO TABLE et_ekbe.
    ENDLOOP.
    LOOP AT lt_ekbz ASSIGNING <ekbz>.
      CHECK <ekbz>-ebelp EQ i_ebelp.                        "1624571
      ls_ekbz = <ekbz>.
      INSERT ls_ekbz INTO TABLE et_ekbz.
    ENDLOOP.

    CLEAR: lt_ekbe, lt_ekbz.
    CALL FUNCTION 'MR_READ_PRELIMINARY_HISTORY'
      EXPORTING
        i_bukrs = is_ekko-bukrs
        i_ebeln = i_ebeln
        i_ebelp = i_ebelp
      TABLES
        t_ekbe  = lt_ekbe
        t_ekbz  = lt_ekbz.

    LOOP AT lt_ekbe ASSIGNING <ekbe>.
      MOVE-CORRESPONDING <ekbe> TO ls_ekbe.
      ls_ekbe-vgabe = cl_mmpur_constants=>vgabe_p.
      ls_ekbe-bewtp = cl_mmpur_constants=>bewtp_t.
      INSERT ls_ekbe INTO TABLE et_ekbe.
      CLEAR ls_ekbe.
    ENDLOOP.

    LOOP AT lt_ekbz ASSIGNING <ekbz>.
      MOVE-CORRESPONDING <ekbz> TO ls_ekbz.
      ls_ekbz-vgabe = cl_mmpur_constants=>vgabe_p.
      ls_ekbz-bewtp = cl_mmpur_constants=>bewtp_t.
      INSERT ls_ekbz INTO TABLE et_ekbz.
      CLEAR ls_ekbz.
    ENDLOOP.

  ENDMETHOD.


  METHOD zif_gtt_ae_filler~check_relevance.
    DATA: lv_mng_new    TYPE menge_d.

    rv_result   = zif_gtt_ef_constants=>cs_condition-false.

    IF is_appropriate_definition( is_events = is_events ) = abap_true AND
       is_appropriate_md_type( ir_md_head = is_events-mastertabref ) = abap_true AND
       is_appropriate_po_item( ir_md_pos  = is_events-maintabref )   = abap_true AND
       is_creation_mode( is_events = is_events ) = abap_true.

      lv_mng_new = get_goods_receipt_quantity(
        ir_goods_receipt = is_events-maintabref ).

      rv_result   = COND #( WHEN lv_mng_new <> 0
                              THEN zif_gtt_ef_constants=>cs_condition-true
                              ELSE zif_gtt_ef_constants=>cs_condition-false ).
    ENDIF.
  ENDMETHOD.


  METHOD zif_gtt_ae_filler~get_event_data.

    DATA(lv_quantity) = get_full_quantity_for_gr( is_events = is_events ).

    DATA(lv_is_completed) = is_delivery_completed( ir_goods_receipt = is_events-maintabref ).

    ct_trackingheader = VALUE #( BASE ct_trackingheader (
      language    = sy-langu
      trxid       = zcl_gtt_spof_po_tools=>get_tracking_id_po_itm(
                      ir_ekpo = is_events-maintabref )      "MSEG contains EBELN/EBELP
      trxcod      = zif_gtt_ef_constants=>cs_trxcod-po_position
      evtcnt      = is_events-eventid
      evtid       = zif_gtt_ef_constants=>cs_milestone-po_goods_receipt
      evtdat      = sy-datum
      evttim      = sy-uzeit
      evtzon      = zcl_gtt_tools=>get_system_time_zone( )
    ) ).

    ct_eventid_map  = VALUE #( BASE ct_eventid_map (
      eventid     = is_events-eventid
      evtcnt      = is_events-eventid
    ) ).

    ct_tracklocation  = VALUE #( BASE ct_tracklocation (
      evtcnt      = is_events-eventid
      loccod      = zif_gtt_ef_constants=>cs_loc_types-plant
      locid1      = zcl_gtt_tools=>get_field_of_structure(
                      ir_struct_data = is_events-maintabref
                      iv_field_name  = 'WERKS' )
    ) ).

    ct_trackparameters  = VALUE #( BASE ct_trackparameters (
      evtcnt      = is_events-eventid
      param_name  = zif_gtt_ef_constants=>cs_event_param-quantity
      param_value = zcl_gtt_tools=>get_pretty_value( iv_value = lv_quantity )
    ) ).

    ct_trackparameters  = VALUE #( BASE ct_trackparameters (
      evtcnt      = is_events-eventid
      param_name  = zif_gtt_ef_constants=>cs_event_param-delivery_completed
      param_value = lv_is_completed
    ) ).
  ENDMETHOD.
ENDCLASS.
