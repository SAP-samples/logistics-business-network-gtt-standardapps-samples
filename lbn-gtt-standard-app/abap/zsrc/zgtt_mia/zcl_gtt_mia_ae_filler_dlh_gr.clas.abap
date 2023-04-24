class ZCL_GTT_MIA_AE_FILLER_DLH_GR definition
  public
  create public .

public section.

  interfaces ZIF_GTT_AE_FILLER .

  types:
    lt_ekbe_t TYPE SORTED TABLE OF ekbe
                     WITH UNIQUE KEY table_line .
  types:
    lt_ekbz_t TYPE SORTED TABLE OF ekbz
                       WITH UNIQUE KEY table_line .

  methods CONSTRUCTOR
    importing
      !IO_AE_PARAMETERS type ref to ZIF_GTT_AE_PARAMETERS .
  methods GET_FULL_QUANTITY_FOR_GR
    importing
      !IS_LIPS type LIPS
      !IS_MSEG type MSEG
      !IS_LIKP type LIKP
    returning
      value(RV_QUANTITY) type MENGE_D
    raising
      CX_UDM_MESSAGE .
  PROTECTED SECTION.
private section.

  types:
    BEGIN OF ts_dl_item_id,
        vbeln TYPE vbeln_vl,
        posnr TYPE posnr_vl,
        mseg  TYPE mseg,
      END OF ts_dl_item_id .
  types:
    tt_vbeln    TYPE STANDARD TABLE OF vbeln_vl .
  types:
    tt_pos     TYPE STANDARD TABLE OF ts_dl_item_id .
  types:
    tt_lips  TYPE STANDARD TABLE OF lips .

  data MO_AE_PARAMETERS type ref to ZIF_GTT_AE_PARAMETERS .
  data MV_ARCHIVED type BOOLE_D .

  methods GET_DELIVERY_IDS
    importing
      !IR_MD_POS type ref to DATA
    exporting
      !ET_VBELN type TT_VBELN
      !ET_VBELP type TT_POS
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
  methods GET_PO_HEADER
    importing
      !I_EBELN type EBELN
    exporting
      !ES_EKKO type EKKO
    raising
      CX_UDM_MESSAGE .
  methods GET_PO_ITEM
    importing
      !I_EBELN type EBELN
      !I_EBELP type EBELP
      !IS_EKKO type EKKO
    exporting
      !ES_EKPO type EKPO
    raising
      CX_UDM_MESSAGE .
  methods GET_PO_ITEM_HISTORY
    importing
      !I_EBELN type EBELN
      !I_EBELP type EBELP
      !IS_EKKO type EKKO
      !IS_EKPO type EKPO
    exporting
      !ET_EKBE type ZCL_GTT_MIA_AE_FILLER_DLH_GR=>LT_EKBE_T
      !ET_EKBZ type ZCL_GTT_MIA_AE_FILLER_DLH_GR=>LT_EKBZ_T
    raising
      CX_UDM_MESSAGE .
  methods GET_GOODS_RECEIPT_QUANTITY
    importing
      !IR_GOODS_RECEIPT type ref to DATA
    returning
      value(RV_MENGE) type MENGE_D
    raising
      CX_UDM_MESSAGE .
  methods GET_HEADER_BY_DELIVERY_IDS
    importing
      !IT_VBELN type TT_VBELN
    exporting
      !ET_LIKP type TAB_LIKP .
ENDCLASS.



CLASS ZCL_GTT_MIA_AE_FILLER_DLH_GR IMPLEMENTATION.


  METHOD constructor.

    mo_ae_parameters  = io_ae_parameters.

  ENDMETHOD.


  METHOD get_delivery_ids.

    DATA: lv_vbeln    TYPE vbeln_vl.

    FIELD-SYMBOLS: <lt_mseg>    TYPE zif_gtt_mia_app_types=>tt_mseg.

    CLEAR: et_vbeln[],et_vbelp[].

    ASSIGN ir_md_pos->* TO <lt_mseg>.

    IF <lt_mseg> IS ASSIGNED.
      LOOP AT <lt_mseg> ASSIGNING FIELD-SYMBOL(<ls_mseg>)
        WHERE vbeln_im IS NOT INITIAL.

        IF NOT line_exists( et_vbeln[ table_line = <ls_mseg>-vbeln_im ] ).
          APPEND <ls_mseg>-vbeln_im TO et_vbeln.
        ENDIF.
        et_vbelp  = VALUE #( BASE et_vbelp (
         vbeln = <ls_mseg>-vbeln_im
         posnr = <ls_mseg>-vbelp_im
         mseg  = <ls_mseg>
       ) ).
      ENDLOOP.
    ELSE.
      MESSAGE e002(zgtt) WITH 'MSEG' INTO DATA(lv_dummy).
      zcl_gtt_tools=>throw_exception( ).
    ENDIF.

  ENDMETHOD.


  METHOD get_full_quantity_for_gr.

    DATA: lv_ebeln TYPE ekpo-ebeln,
          lv_ebelp TYPE ekpo-ebelp,
          ls_ekko  TYPE ekko,
          ls_ekpo  TYPE ekpo.

    DATA: lt_ekbe TYPE zcl_gtt_mia_ae_filler_dlh_gr=>lt_ekbe_t,
          lt_ekbz TYPE zcl_gtt_mia_ae_filler_dlh_gr=>lt_ekbz_t.

    DATA: lt_vbfa           TYPE STANDARD TABLE OF vbfa,
          lv_total_quantity TYPE menge_d VALUE 0.

    DATA: lt_vbeln TYPE STANDARD TABLE OF mblnr.

    CALL FUNCTION 'READ_VBFA'
      EXPORTING
        i_vbelv         = is_lips-vbeln
        i_posnv         = is_lips-posnr
        i_vbtyp_v       = is_likp-vbtyp
        i_vbtyp_n       = 'R'
*       I_FKTYP         =
      TABLES
        e_vbfa          = lt_vbfa
      EXCEPTIONS
        no_record_found = 1
        OTHERS          = 2.
    IF sy-subrc <> 0.
      CLEAR lt_vbfa.
    ENDIF.


    LOOP AT lt_vbfa INTO DATA(ls_vbfa).
      APPEND ls_vbfa-vbeln TO lt_vbeln.
    ENDLOOP.

    lv_ebeln = CONV ebeln( is_lips-vgbel ).
    lv_ebelp = CONV ebelp( is_lips-vgpos ).

    IF lv_ebeln IS NOT INITIAL AND lv_ebelp IS NOT INITIAL.
      get_po_header(
        EXPORTING
          i_ebeln = lv_ebeln
        IMPORTING
          es_ekko = ls_ekko
      ).

      get_po_item(
        EXPORTING
          i_ebeln = lv_ebeln
          i_ebelp = lv_ebelp
          is_ekko = ls_ekko
        IMPORTING
          es_ekpo = ls_ekpo
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

      LOOP AT lt_ekbe INTO DATA(ls_ekbe) WHERE vgabe NE '7'
                                           AND ( bwart = '101' OR bwart = '102' )
                                           AND belnr <> is_mseg-mblnr.
        IF is_likp-vbtyp = if_sd_doc_category=>delivery_shipping_notif. "Inbound delivery
          IF NOT line_exists( lt_vbeln[ table_line = ls_ekbe-belnr ] ).
            CONTINUE.
          ENDIF.
        ELSEIF is_likp-vbtyp = if_sd_doc_category=>delivery.            "Outbound delivery
          IF ls_ekbe-vbeln_st <> is_mseg-vbeln_im.
            CONTINUE.
          ENDIF.
        ENDIF.
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

      lv_total_quantity = lv_total_quantity * ls_ekpo-umrez / ls_ekpo-umren.

    ENDIF.

    DATA(lv_diff) = get_goods_receipt_quantity( REF #( is_mseg ) ).

    rv_quantity = lv_total_quantity + lv_diff.
    rv_quantity = rv_quantity * is_lips-umvkn / is_lips-umvkz.

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


  METHOD get_po_header.
    DATA lv_bstyp TYPE bstyp.

    CLEAR es_ekko.
    CALL FUNCTION 'ME_EKKO_SINGLE_READ'
      EXPORTING
        pi_ebeln         = i_ebeln
      IMPORTING
        po_ekko          = es_ekko
      EXCEPTIONS
        no_records_found = 1
        OTHERS           = 2.
    IF sy-subrc GT 0.
* archive integration                                       "v_1624571
      IF cl_mmpur_archive=>if_mmpur_archive~get_archive_handle( i_ebeln )
        GT 0.
        DO 3 TIMES.
          CASE sy-index.
            WHEN 1.
              lv_bstyp = 'F'.
            WHEN 2.
              lv_bstyp = 'K'.
            WHEN 3.
              lv_bstyp = 'L'.
          ENDCASE.
          TRY.
              cl_mmpur_archive=>if_mmpur_archive~get_archived_pd(
                EXPORTING
                  im_ebeln = i_ebeln
                  im_bstyp = lv_bstyp
                IMPORTING
                  ex_ekko  = es_ekko ).
            CATCH cx_mmpur_no_authority.
              CLEAR es_ekko.
            CATCH cx_mmpur_root.
              CLEAR es_ekko.
          ENDTRY.
          CHECK es_ekko IS NOT INITIAL.
          mv_archived = abap_true.
          EXIT.
        ENDDO.
        IF es_ekko IS INITIAL.
          MESSAGE e005(zgtt) WITH 'EKKO' i_ebeln INTO DATA(lv_dummy).
          zcl_gtt_tools=>throw_exception( ).
        ENDIF.
      ENDIF.                                                "^_1624571
    ENDIF.



  ENDMETHOD.


  METHOD get_po_item.
    DATA lt_items TYPE STANDARD TABLE OF ekpo.
    CLEAR es_ekpo.

    CALL FUNCTION 'ME_EKPO_READ_WITH_EBELN'
      EXPORTING
        pi_ebeln             = i_ebeln
      TABLES
        pto_ekpo             = lt_items
      EXCEPTIONS
        err_no_records_found = 1
        OTHERS               = 2.
    IF sy-subrc GT 0.
      IF mv_archived EQ abap_true.                          "v_1624571
        TRY.
            cl_mmpur_archive=>if_mmpur_archive~get_archived_pd(
              EXPORTING
                im_ebeln = i_ebeln
                im_bstyp = is_ekko-bstyp
              IMPORTING
                ex_ekpo  = lt_items ).
          CATCH cx_mmpur_no_authority.
            CLEAR lt_items.
          CATCH cx_mmpur_root.
            CLEAR lt_items.
        ENDTRY.
      ENDIF.
      IF lines( lt_items ) EQ 0.
        MESSAGE e005(zgtt) WITH 'EKPO' |{ i_ebeln }{ i_ebelp }|
         INTO DATA(lv_dummy).
        zcl_gtt_tools=>throw_exception( ).
      ENDIF.                                                "^_1624571
    ENDIF.
    READ TABLE lt_items WITH KEY ebeln = i_ebeln
                                 ebelp = i_ebelp
                        INTO es_ekpo.
    IF sy-subrc NE 0.
      MESSAGE e005(zgtt) WITH 'EKPO' |{ i_ebeln }{ i_ebelp }|
          INTO lv_dummy.
      zcl_gtt_tools=>throw_exception( ).
    ENDIF.
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


  METHOD is_appropriate_definition.

    rv_result = boolc( is_events-maintabdef = zif_gtt_mia_app_constants=>cs_tabledef-md_material_header ).

  ENDMETHOD.


  METHOD is_appropriate_dl_item.

    DATA: lt_vbeln TYPE tt_vbeln,
          lt_lips  TYPE STANDARD TABLE OF lips,
          lt_likp  TYPE tab_likp,
          ls_likp  TYPE likp.

    rv_result   = abap_false.

    get_delivery_ids(
      EXPORTING
        ir_md_pos = ir_md_pos
      IMPORTING
        et_vbeln  = lt_vbeln ).

    IF lt_vbeln[] IS NOT INITIAL.
      get_items_by_delivery_ids(
        EXPORTING
          it_vbeln = lt_vbeln
        IMPORTING
          et_lips  = lt_lips
      ).

      get_header_by_delivery_ids(
        EXPORTING
          it_vbeln = lt_vbeln
        IMPORTING
          et_likp  = lt_likp ).

      LOOP AT lt_lips ASSIGNING FIELD-SYMBOL(<ls_lips>).
        CLEAR ls_likp.
        READ TABLE lt_likp INTO ls_likp WITH KEY vbeln = <ls_lips>-vbeln.
        IF sy-subrc <> 0.
          CONTINUE.
        ENDIF.
        rv_result   = boolc( zcl_gtt_tools=>is_appropriate_dl_item(
                               ir_likp = REF #( ls_likp )
                               ir_lips = REF #( <ls_lips> ) ) = abap_true ).
*       Support GR for Outbound delivery in STO Scenario
        IF rv_result IS INITIAL.
          rv_result = boolc( zcl_gtt_tools=>is_appropriate_odlv_item(
                               ir_likp = REF #( ls_likp )
                               ir_lips = REF #( <ls_lips> ) ) = abap_true ).
        ENDIF.
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
        rv_result   = boolc( zcl_gtt_tools=>is_appropriate_dl_type(
                               ir_likp = REF #( <ls_likp> ) ) = abap_true ).
*       Support GR for Outbound delivery in STO Scenario
        IF rv_result IS INITIAL.
          rv_result = boolc( zcl_gtt_tools=>is_appropriate_odlv_type(
                               ir_likp = REF #( <ls_likp> ) ) = abap_true ).
        ENDIF.
        IF rv_result = abap_true.
          EXIT.
        ENDIF.
      ENDLOOP.
    ENDIF.

  ENDMETHOD.


  METHOD is_appropriate_md_type.

    DATA: lv_md_type  TYPE mkpf-blart.

    lv_md_type = zcl_gtt_tools=>get_field_of_structure(
      ir_struct_data = ir_md_head
      iv_field_name  = 'BLART' ).

    rv_result   = boolc( lv_md_type = zif_gtt_mia_app_constants=>cs_md_type-goods_receipt ).

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


  METHOD is_reveral_document.

    DATA: lv_vbeln    TYPE vbeln_vl.

    FIELD-SYMBOLS: <lt_mseg>    TYPE zif_gtt_mia_app_types=>tt_mseg.

    ASSIGN ir_md_pos->* TO <lt_mseg>.

    IF <lt_mseg> IS ASSIGNED.
      READ TABLE <lt_mseg> ASSIGNING FIELD-SYMBOL(<ls_mseg>) INDEX 1.

      rv_result = boolc( sy-subrc = 0 AND <ls_mseg>-smbln IS NOT INITIAL ).

    ELSE.
      MESSAGE e002(zgtt) WITH 'MSEG' INTO DATA(lv_dummy).
      zcl_gtt_tools=>throw_exception( ).
    ENDIF.

  ENDMETHOD.


  METHOD zif_gtt_ae_filler~check_relevance.

    DATA: lv_mng_new    TYPE menge_d.

    DATA(lr_md_pos) = mo_ae_parameters->get_appl_table(
      iv_tabledef = zif_gtt_mia_app_constants=>cs_tabledef-md_material_segment ).

    rv_result       = zif_gtt_ef_constants=>cs_condition-false.

    " mkpf-blart        = 'WE'
    " update_indicator  = insert
    IF is_appropriate_definition( is_events = is_events ) = abap_true AND
       is_appropriate_md_type( ir_md_head = is_events-maintabref ) = abap_true AND
       is_appropriate_dl_type( ir_md_pos  = lr_md_pos ) = abap_true AND
       is_appropriate_dl_item( ir_md_pos  = lr_md_pos ) = abap_true AND
       is_creation_mode( is_events = is_events ) = abap_true.

      rv_result   = zif_gtt_ef_constants=>cs_condition-true.
    ENDIF.

  ENDMETHOD.


  METHOD zif_gtt_ae_filler~get_event_data.

    DATA:
      lt_vbeln       TYPE tt_vbeln,
      lt_pos         TYPE tt_pos,
      lt_lips        TYPE tt_lips,
      lv_dlvittrxcod TYPE /saptrx/trxcod,
      lt_likp        TYPE tab_likp,
      ls_likp        TYPE likp,
      lv_locid       TYPE /saptrx/loc_id_1.

    DATA(lr_md_pos) = mo_ae_parameters->get_appl_table(
      iv_tabledef = zif_gtt_mia_app_constants=>cs_tabledef-md_material_segment ).

    DATA(lv_reversal) = is_reveral_document( ir_md_pos = lr_md_pos ).

    get_delivery_ids(
      EXPORTING
        ir_md_pos = lr_md_pos
      IMPORTING
        et_vbeln  = lt_vbeln
        et_vbelp  = lt_pos ).

    get_items_by_delivery_ids(
      EXPORTING
        it_vbeln = lt_vbeln
      IMPORTING
        et_lips  = lt_lips ).

    get_header_by_delivery_ids(
      EXPORTING
        it_vbeln = lt_vbeln
      IMPORTING
        et_likp  = lt_likp ).

    " Goods receipt for Item
    LOOP AT lt_lips ASSIGNING FIELD-SYMBOL(<ls_lips>).

      CLEAR:
        ls_likp,
        lv_dlvittrxcod.

      READ TABLE lt_pos INTO DATA(ls_pos)
        WITH KEY vbeln = <ls_lips>-vbeln
                 posnr = <ls_lips>-posnr.
      IF sy-subrc <> 0.
        CONTINUE.
      ENDIF.

      READ TABLE lt_likp INTO ls_likp
        WITH KEY vbeln = <ls_lips>-vbeln.
      IF sy-subrc = 0.
        IF ls_likp-vbtyp = if_sd_doc_category=>delivery_shipping_notif. "Inbound delivery
          lv_dlvittrxcod = zif_gtt_ef_constants=>cs_trxcod-dl_position.
        ELSEIF ls_likp-vbtyp = if_sd_doc_category=>delivery.            "Outbound delivery
          lv_dlvittrxcod = zif_gtt_sof_constants=>cs_trxcod-out_delivery_item.
        ENDIF.
      ELSE.
        CONTINUE.
      ENDIF.

      IF zcl_gtt_tools=>is_appropriate_dl_item( ir_likp = REF #( ls_likp ) ir_lips = REF #( <ls_lips> ) ) = abap_false
         AND zcl_gtt_tools=>is_appropriate_odlv_item( ir_likp = REF #( ls_likp ) ir_lips = REF #( <ls_lips> ) ) = abap_false.
        CONTINUE.
      ENDIF.

      DATA(lv_evtcnt) = zcl_gtt_mia_sh_tools=>get_next_event_counter( ).
      DATA(lv_quantity) = get_full_quantity_for_gr( is_lips = <ls_lips> is_mseg = ls_pos-mseg is_likp = ls_likp ).

      ct_trackingheader = VALUE #( BASE ct_trackingheader (
        language    = sy-langu
        trxid       = zcl_gtt_mia_dl_tools=>get_tracking_id_dl_item(
                        ir_lips = NEW lips( vbeln = <ls_lips>-vbeln posnr = <ls_lips>-posnr  ) )
        trxcod      = lv_dlvittrxcod
        evtcnt      = lv_evtcnt
        evtid       = zif_gtt_ef_constants=>cs_milestone-dl_goods_receipt
        evtdat      = sy-datum
        evttim      = sy-uzeit
        evtzon      = zcl_gtt_tools=>get_system_time_zone( )
      ) ).

      ct_eventid_map  = VALUE #( BASE ct_eventid_map (
        eventid     = is_events-eventid
        evtcnt      = lv_evtcnt
      ) ).

      ct_trackparameters  = VALUE #( BASE ct_trackparameters (
        evtcnt      = lv_evtcnt
        param_name  = zif_gtt_ef_constants=>cs_event_param-quantity
        param_value = zcl_gtt_tools=>get_pretty_value( iv_value = lv_quantity )
      ) ).

      IF ls_likp-vbtyp = if_sd_doc_category=>delivery_shipping_notif. "Inbound delivery
        lv_locid = <ls_lips>-werks.
      ELSEIF ls_likp-vbtyp = if_sd_doc_category=>delivery.            "Outbound delivery
        zcl_gtt_tools=>get_location_id(
          EXPORTING
            iv_vgbel  = <ls_lips>-vgbel
            iv_vgpos  = <ls_lips>-vgpos
          IMPORTING
            ev_locid1 = lv_locid ).
      ENDIF.
      ct_tracklocation  = VALUE #( BASE ct_tracklocation (
        evtcnt      = lv_evtcnt
        loccod      = zif_gtt_ef_constants=>cs_loc_types-plant
        locid1  = zcl_gtt_tools=>get_pretty_location_id(
                              iv_locid   = lv_locid
                              iv_loctype = zif_gtt_ef_constants=>cs_loc_types-plant )
        locid2 = zcl_gtt_mia_dl_tools=>get_tracking_id_dl_item(
                        ir_lips = NEW lips( vbeln = <ls_lips>-vbeln posnr = <ls_lips>-posnr  ) )
      ) ).

      CLEAR lv_locid.
    ENDLOOP.


  ENDMETHOD.


  METHOD get_header_by_delivery_ids.

    CLEAR et_likp.

    IF it_vbeln IS NOT INITIAL.
      SELECT *
        INTO TABLE et_likp
        FROM likp
         FOR ALL ENTRIES IN it_vbeln
       WHERE vbeln = it_vbeln-table_line.

    ENDIF.

  ENDMETHOD.
ENDCLASS.
