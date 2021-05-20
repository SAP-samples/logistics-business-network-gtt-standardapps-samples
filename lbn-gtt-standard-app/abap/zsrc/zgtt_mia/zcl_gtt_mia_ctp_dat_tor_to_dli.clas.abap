CLASS zcl_gtt_mia_ctp_dat_tor_to_dli DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.

    METHODS constructor
      IMPORTING
        !it_delivery_chng TYPE zif_gtt_mia_ctp_types=>tt_delivery_chng
      RAISING
        cx_udm_message .
    METHODS get_delivery_items
      RETURNING
        VALUE(rr_delivery_item) TYPE REF TO data .
  PROTECTED SECTION.
  PRIVATE SECTION.

    DATA mt_delivery_item TYPE zif_gtt_mia_ctp_types=>tt_delivery_item .

    METHODS convert_delivery_items
      IMPORTING
        !it_delivery_chng TYPE zif_gtt_mia_ctp_types=>tt_delivery_chng
      EXPORTING
        !et_delivery_item TYPE zif_gtt_mia_ctp_types=>tt_delivery_item .
    METHODS fill_delivery_data
      CHANGING
        !ct_delivery_item TYPE zif_gtt_mia_ctp_types=>tt_delivery_item .
    METHODS fill_freight_unit_data
      CHANGING
        !ct_delivery_item TYPE zif_gtt_mia_ctp_types=>tt_delivery_item
      RAISING
        cx_udm_message .
    METHODS init_delivery_items
      IMPORTING
        !it_delivery_chng TYPE zif_gtt_mia_ctp_types=>tt_delivery_chng
      RAISING
        cx_udm_message .
ENDCLASS.



CLASS zcl_gtt_mia_ctp_dat_tor_to_dli IMPLEMENTATION.


  METHOD constructor.

    IF it_delivery_chng[] IS NOT INITIAL.
      init_delivery_items(
        EXPORTING
          it_delivery_chng = it_delivery_chng ).
    ENDIF.

  ENDMETHOD.


  METHOD convert_delivery_items.

    DATA: ls_delivery_item TYPE zif_gtt_mia_ctp_types=>ts_delivery_item.

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
        quantityUoM   = <ls_delivery_chng>-quantityUoM
      ) ).

      UNASSIGN <ls_delivery_item>.
    ENDLOOP.

  ENDMETHOD.


  METHOD fill_delivery_data.

    DATA: lt_likp        TYPE HASHED TABLE OF zif_gtt_mia_app_types=>ts_likpvb
                           WITH UNIQUE KEY vbeln,
          lt_lips        TYPE SORTED TABLE OF zif_gtt_mia_app_types=>ts_lipsvb
                           WITH UNIQUE KEY vbeln posnr,
          ls_lips        TYPE zif_gtt_mia_app_types=>ts_lipsvb,
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
      ENDLOOP.
    ENDIF.

  ENDMETHOD.


  METHOD fill_freight_unit_data.

    DATA: lt_fu_item  TYPE /scmtms/t_tor_item_tr_k.

    LOOP AT ct_delivery_item ASSIGNING FIELD-SYMBOL(<ls_delivery_item>).
      zcl_gtt_mia_tm_tools=>get_tor_items_for_dlv_items(
        EXPORTING
          it_lips    = VALUE #( ( vbeln = <ls_delivery_item>-vbeln
                                  posnr = <ls_delivery_item>-posnr ) )
          iv_tor_cat = /scmtms/if_tor_const=>sc_tor_category-freight_unit
        IMPORTING
          et_fu_item = lt_fu_item ).

      LOOP AT lt_fu_item ASSIGNING FIELD-SYMBOL(<ls_fu_item>).
        <ls_delivery_item>-fu_list  = VALUE #( BASE <ls_delivery_item>-fu_list (
          tor_id  = zcl_gtt_mia_tm_tools=>get_tor_root_tor_id(
                              iv_key = <ls_fu_item>-parent_key )
          item_id   = <ls_fu_item>-item_id
          quantity     = <ls_fu_item>-qua_pcs_val
          quantityuom  = <ls_fu_item>-qua_pcs_uni
        ) ).
      ENDLOOP.

      SORT <ls_delivery_item>-fu_list BY tor_id item_id.

      DELETE ADJACENT DUPLICATES FROM <ls_delivery_item>-fu_list
        COMPARING tor_id item_id.
    ENDLOOP.

  ENDMETHOD.


  METHOD get_delivery_items.

    rr_delivery_item       = REF #( mt_delivery_item ).

  ENDMETHOD.


  METHOD init_delivery_items.

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
