class ZCL_GTT_SOF_CTP_DAT_TOR_TO_DLI definition
  public
  create public .

public section.

  methods CONSTRUCTOR
    importing
      !IT_DELIVERY_CHNG type ZIF_GTT_SOF_CTP_TYPES=>TT_DELIVERY_CHNG
    raising
      CX_UDM_MESSAGE .
  methods GET_DELIVERY_ITEMS
    returning
      value(RR_DELIVERY_ITEM) type ref to DATA .
  PROTECTED SECTION.
private section.

  data MT_DELIVERY_ITEM type ZIF_GTT_SOF_CTP_TYPES=>TT_DELIVERY_ITEM .

  methods CONVERT_DELIVERY_ITEMS
    importing
      !IT_DELIVERY_CHNG type ZIF_GTT_SOF_CTP_TYPES=>TT_DELIVERY_CHNG
    exporting
      !ET_DELIVERY_ITEM type ZIF_GTT_SOF_CTP_TYPES=>TT_DELIVERY_ITEM .
  methods FILL_DELIVERY_DATA
    changing
      !CT_DELIVERY_ITEM type ZIF_GTT_SOF_CTP_TYPES=>TT_DELIVERY_ITEM .
  methods FILL_FREIGHT_UNIT_DATA
    changing
      !CT_DELIVERY_ITEM type ZIF_GTT_SOF_CTP_TYPES=>TT_DELIVERY_ITEM
    raising
      CX_UDM_MESSAGE .
  methods INIT_DELIVERY_ITEMS
    importing
      !IT_DELIVERY_CHNG type ZIF_GTT_SOF_CTP_TYPES=>TT_DELIVERY_CHNG
    raising
      CX_UDM_MESSAGE .
ENDCLASS.



CLASS ZCL_GTT_SOF_CTP_DAT_TOR_TO_DLI IMPLEMENTATION.


  METHOD CONSTRUCTOR.

    IF it_delivery_chng[] IS NOT INITIAL.
      init_delivery_items(
        EXPORTING
          it_delivery_chng = it_delivery_chng ).
    ENDIF.

  ENDMETHOD.


  METHOD convert_delivery_items.

    DATA: ls_delivery_item TYPE zif_gtt_sof_ctp_types=>ts_delivery_item.

    CLEAR: et_delivery_item[].

    LOOP AT it_delivery_chng ASSIGNING FIELD-SYMBOL(<ls_delivery_chng>).
      READ TABLE et_delivery_item ASSIGNING FIELD-SYMBOL(<ls_delivery_item>)
        WITH KEY vbeln = <ls_delivery_chng>-vbeln
                 posnr = <ls_delivery_chng>-posnr
                 BINARY SEARCH.

      IF sy-subrc <> 0.
        CLEAR: ls_delivery_item.
        ls_delivery_item-vbeln  = <ls_delivery_chng>-vbeln.
        ls_delivery_item-posnr  = <ls_delivery_chng>-posnr.
        INSERT ls_delivery_item INTO et_delivery_item INDEX sy-tabix.

        ASSIGN et_delivery_item[ sy-tabix ] TO <ls_delivery_item>.
      ENDIF.

      <ls_delivery_item>-fu_list  = VALUE #( BASE <ls_delivery_item>-fu_list (
        tor_id        = <ls_delivery_chng>-tor_id
        item_id       = <ls_delivery_chng>-item_id
        quantity      = <ls_delivery_chng>-quantity
        quantityuom   = <ls_delivery_chng>-quantityuom
        product_id    = <ls_delivery_chng>-product_id
        product_descr = <ls_delivery_chng>-product_descr
        change_mode   = <ls_delivery_chng>-change_mode
      ) ).

      UNASSIGN <ls_delivery_item>.
    ENDLOOP.

  ENDMETHOD.


  METHOD fill_delivery_data.

    DATA:
      lt_likp        TYPE HASHED TABLE OF likp WITH UNIQUE KEY vbeln,
      lt_lips        TYPE SORTED TABLE OF lipsvb WITH UNIQUE KEY vbeln posnr,
      lt_vbfa        TYPE STANDARD TABLE OF vbfavb,
      ls_vbuk        TYPE vbukvb,
      ls_lips        TYPE lipsvb,
      lv_base_btd_id TYPE /scmtms/base_btd_id.

    IF ct_delivery_item[] IS NOT INITIAL.
      SELECT *
        INTO CORRESPONDING FIELDS OF TABLE lt_likp
        FROM likp
        FOR ALL ENTRIES IN ct_delivery_item
        WHERE vbeln = ct_delivery_item-vbeln.

      SELECT *
        INTO CORRESPONDING FIELDS OF TABLE lt_lips
        FROM lips
        FOR ALL ENTRIES IN ct_delivery_item
        WHERE vbeln = ct_delivery_item-vbeln
          AND posnr = ct_delivery_item-posnr.

      SELECT *
        INTO CORRESPONDING FIELDS OF TABLE lt_vbfa
        FROM vbfa
        FOR ALL ENTRIES IN ct_delivery_item
       WHERE vbeln = ct_delivery_item-vbeln.

      LOOP AT ct_delivery_item ASSIGNING FIELD-SYMBOL(<ls_delivery_item>).
        " copy selected delivery header
        <ls_delivery_item>-likp  = VALUE #(
          lt_likp[ KEY primary_key
                   COMPONENTS vbeln = <ls_delivery_item>-vbeln ]
          DEFAULT VALUE #( vbeln = <ls_delivery_item>-vbeln )
        ).

        " copy selected delivery item
        <ls_delivery_item>-lips  = VALUE #(
          lt_lips[ KEY primary_key
                   COMPONENTS vbeln = <ls_delivery_item>-vbeln
                              posnr = <ls_delivery_item>-posnr ]
          DEFAULT VALUE #( vbeln = <ls_delivery_item>-vbeln
                           posnr = <ls_delivery_item>-posnr )
        ).

*       Delivery Header Status
        READ TABLE lt_likp INTO DATA(ls_likp) WITH KEY vbeln = <ls_delivery_item>-vbeln.
        IF sy-subrc = 0.
          MOVE-CORRESPONDING ls_likp TO <ls_delivery_item>-vbuk.
        ENDIF.

*       Delivery Item Status
        LOOP AT lt_lips ASSIGNING FIELD-SYMBOL(<ls_lips>)
          USING KEY primary_key
          WHERE vbeln = <ls_delivery_item>-vbeln
            AND posnr = <ls_delivery_item>-posnr.

          MOVE-CORRESPONDING <ls_lips> TO <ls_delivery_item>-vbup.
        ENDLOOP.

*       Copy document flow data
        LOOP AT lt_vbfa INTO DATA(ls_vbfa) USING KEY primary_key
          WHERE vbeln = <ls_delivery_item>-vbeln
            AND posnn = <ls_delivery_item>-posnr.
          APPEND ls_vbfa TO <ls_delivery_item>-vbfa.
        ENDLOOP.

      ENDLOOP.
    ENDIF.

  ENDMETHOD.


  METHOD fill_freight_unit_data.

    DATA: lt_fu_item  TYPE /scmtms/t_tor_item_tr_k.

    LOOP AT ct_delivery_item ASSIGNING FIELD-SYMBOL(<ls_delivery_item>).
      zcl_gtt_sof_tm_tools=>get_tor_items_for_dlv_items(
        EXPORTING
          it_lips    = VALUE #( ( vbeln = <ls_delivery_item>-vbeln
                                  posnr = <ls_delivery_item>-posnr ) )
          iv_tor_cat = /scmtms/if_tor_const=>sc_tor_category-freight_unit
        IMPORTING
          et_fu_item = lt_fu_item ).

      LOOP AT lt_fu_item ASSIGNING FIELD-SYMBOL(<ls_fu_item>).
        zcl_gtt_sof_tm_tools=>get_tor_root(
          EXPORTING
            iv_key = <ls_fu_item>-parent_key
          IMPORTING
            es_tor = DATA(ls_tor_data) ).

        IF ls_tor_data IS INITIAL OR ls_tor_data-lifecycle = /scmtms/if_tor_status_c=>sc_root-lifecycle-v_canceled.
          CONTINUE.
        ENDIF.

        <ls_delivery_item>-fu_list  = VALUE #( BASE <ls_delivery_item>-fu_list (
          tor_id       = ls_tor_data-tor_id
          item_id      = <ls_fu_item>-item_id
          quantity     = <ls_fu_item>-qua_pcs_val
          quantityuom  = <ls_fu_item>-qua_pcs_uni
          product_id   = <ls_fu_item>-product_id
          product_descr = <ls_fu_item>-item_descr
        ) ).
      ENDLOOP.

      SORT <ls_delivery_item>-fu_list BY tor_id item_id.

      DELETE ADJACENT DUPLICATES FROM <ls_delivery_item>-fu_list
        COMPARING tor_id item_id.
    ENDLOOP.

  ENDMETHOD.


  METHOD GET_DELIVERY_ITEMS.

    rr_delivery_item       = REF #( mt_delivery_item ).

  ENDMETHOD.


  METHOD INIT_DELIVERY_ITEMS.

    " enrich it_delivery_chng with fu_quantity fu_quantityUoM
    convert_delivery_items(
      EXPORTING
        it_delivery_chng = it_delivery_chng
      IMPORTING
        et_delivery_item = mt_delivery_item ).

    fill_delivery_data(
      CHANGING
        ct_delivery_item = mt_delivery_item ).

    fill_freight_unit_data(
      CHANGING
        ct_delivery_item = mt_delivery_item ).

  ENDMETHOD.
ENDCLASS.
