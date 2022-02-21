class ZCL_GTT_MIA_CTP_DAT_TOR_TO_DLH definition
  public
  create public .

public section.

  methods CONSTRUCTOR
    importing
      !IT_DELIVERY_CHNG type ZIF_GTT_MIA_CTP_TYPES=>TT_DELIVERY_CHNG
      !IT_TOR_ROOT type /SCMTMS/T_EM_BO_TOR_ROOT
      !IT_TOR_ITEM type /SCMTMS/T_EM_BO_TOR_ITEM .
  methods GET_DELIVERIES
    returning
      value(RR_DELIVERIES) type ref to DATA .
  PROTECTED SECTION.
  PRIVATE SECTION.

    DATA mt_delivery TYPE zif_gtt_mia_ctp_types=>tt_delivery .

    METHODS fill_delivery_data
      IMPORTING
        !it_delivery_chng TYPE zif_gtt_mia_ctp_types=>tt_delivery_chng
        !it_tor_root      TYPE /scmtms/t_em_bo_tor_root
        !it_tor_item      TYPE /scmtms/t_em_bo_tor_item
      CHANGING
        !ct_delivery      TYPE zif_gtt_mia_ctp_types=>tt_delivery .
    METHODS init_delivery_headers
      IMPORTING
        !it_delivery_chng TYPE zif_gtt_mia_ctp_types=>tt_delivery_chng
        !it_tor_root      TYPE /scmtms/t_em_bo_tor_root
        !it_tor_item      TYPE /scmtms/t_em_bo_tor_item .
ENDCLASS.



CLASS ZCL_GTT_MIA_CTP_DAT_TOR_TO_DLH IMPLEMENTATION.


  METHOD constructor.

    IF it_delivery_chng[] IS NOT INITIAL.
      init_delivery_headers(
        EXPORTING
          it_delivery_chng = it_delivery_chng
          it_tor_root      = it_tor_root
          it_tor_item      = it_tor_item ).
    ENDIF.

  ENDMETHOD.


  METHOD fill_delivery_data.

    DATA: lt_likp        TYPE HASHED TABLE OF zif_gtt_mia_app_types=>ts_likpvb
                           WITH UNIQUE KEY vbeln,
          lt_lips        TYPE SORTED TABLE OF zif_gtt_mia_app_types=>ts_lipsvb
                           WITH UNIQUE KEY vbeln posnr,
          ls_lips        TYPE zif_gtt_mia_app_types=>ts_lipsvb,
          lv_base_btd_id TYPE /scmtms/base_btd_id.

    IF ct_delivery[] IS NOT INITIAL.
      SELECT *
        INTO CORRESPONDING FIELDS OF TABLE lt_likp
        FROM likp
        FOR ALL ENTRIES IN ct_delivery
        WHERE vbeln = ct_delivery-vbeln.

      SELECT *
        INTO CORRESPONDING FIELDS OF TABLE lt_lips
        FROM lips
        FOR ALL ENTRIES IN ct_delivery
        WHERE vbeln = ct_delivery-vbeln.

      LOOP AT ct_delivery ASSIGNING FIELD-SYMBOL(<ls_delivery>).
        " copy selected delivery header
        <ls_delivery>-likp  = VALUE #( lt_likp[ KEY primary_key
                                                COMPONENTS vbeln = <ls_delivery>-vbeln ]
                                         DEFAULT VALUE #( vbeln = <ls_delivery>-vbeln ) ).

        " copy selected delivery items
        LOOP AT lt_lips ASSIGNING FIELD-SYMBOL(<ls_lips>)
          USING KEY primary_key
          WHERE vbeln = <ls_delivery>-vbeln.

          APPEND <ls_lips> TO <ls_delivery>-lips.
        ENDLOOP.

        " when data is not stored in DB yet, just take it from TOR tables
        IF sy-subrc <> 0.
          lv_base_btd_id  = |{ <ls_delivery>-vbeln ALPHA = IN }|.

          LOOP AT it_tor_item ASSIGNING FIELD-SYMBOL(<ls_tor_item>)
            WHERE base_btd_tco = zif_gtt_mia_ctp_tor_constants=>cv_base_btd_tco_inb_dlv
              AND base_btd_id  = lv_base_btd_id
              AND base_btditem_id IS NOT INITIAL.

            ASSIGN it_tor_root[ node_id = <ls_tor_item>-parent_node_id ]
              TO FIELD-SYMBOL(<ls_tor_root>).

            IF sy-subrc = 0 AND
               <ls_tor_root>-tor_cat = /scmtms/if_tor_const=>sc_tor_category-freight_unit.

              ls_lips-vbeln   = |{ <ls_tor_item>-base_btd_id ALPHA = IN }|.
              ls_lips-posnr   = |{ <ls_tor_item>-base_btditem_id ALPHA = IN }|.

              " check whether DLV item already exists
              READ TABLE <ls_delivery>-lips
                WITH KEY vbeln = ls_lips-vbeln
                         posnr = ls_lips-posnr
                         TRANSPORTING NO FIELDS
                         BINARY SEARCH.

              " no row -> add it
              IF sy-subrc <> 0.
                INSERT ls_lips INTO <ls_delivery>-lips INDEX sy-tabix.
              ENDIF.
            ENDIF.
          ENDLOOP.
        ENDIF.
      ENDLOOP.
    ENDIF.

  ENDMETHOD.


  METHOD get_deliveries.

    rr_deliveries   = REF #( mt_delivery ).

  ENDMETHOD.


  METHOD init_delivery_headers.

    DATA: ls_dlv_head TYPE zif_gtt_mia_ctp_types=>ts_delivery.

    CLEAR: mt_delivery[].

    " collect DLV Headers from DLV Items
    LOOP AT it_delivery_chng ASSIGNING FIELD-SYMBOL(<ls_delivery_chng>).
      READ TABLE mt_delivery TRANSPORTING NO FIELDS
        WITH KEY vbeln  = <ls_delivery_chng>-vbeln
        BINARY SEARCH.

      IF sy-subrc <> 0.
        ls_dlv_head-vbeln = <ls_delivery_chng>-vbeln.
        INSERT ls_dlv_head INTO mt_delivery INDEX sy-tabix.
      ENDIF.
    ENDLOOP.

    " enrich DLV Headers with data from DB and TOR internal tables
    fill_delivery_data(
      EXPORTING
        it_delivery_chng = it_delivery_chng
        it_tor_root      = it_tor_root
        it_tor_item      = it_tor_item
      CHANGING
        ct_delivery      = mt_delivery ).

    LOOP AT mt_delivery ASSIGNING FIELD-SYMBOL(<ls_delivery>).
      TRY.
          <ls_delivery>-fu_relevant   = zcl_gtt_mia_tm_tools=>is_fu_relevant(
                                          it_lips = CORRESPONDING #( <ls_delivery>-lips ) ).
        CATCH cx_udm_message.
      ENDTRY.
    ENDLOOP.

  ENDMETHOD.
ENDCLASS.
