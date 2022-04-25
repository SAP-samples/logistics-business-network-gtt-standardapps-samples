class ZCL_GTT_SOF_CTP_DAT_TOR_TO_DLH definition
  public
  create public .

public section.

  methods CONSTRUCTOR
    importing
      !IT_DELIVERY_CHNG type ZIF_GTT_SOF_CTP_TYPES=>TT_DELIVERY_CHNG
      !IT_TOR_ROOT type /SCMTMS/T_EM_BO_TOR_ROOT
      !IT_TOR_ITEM type /SCMTMS/T_EM_BO_TOR_ITEM .
  methods GET_DELIVERIES
    returning
      value(RR_DELIVERIES) type ref to DATA .
  PROTECTED SECTION.
private section.

  data MT_DELIVERY type ZIF_GTT_SOF_CTP_TYPES=>TT_DELIVERY .

  methods FILL_DELIVERY_DATA
    importing
      !IT_DELIVERY_CHNG type ZIF_GTT_SOF_CTP_TYPES=>TT_DELIVERY_CHNG
      !IT_TOR_ROOT type /SCMTMS/T_EM_BO_TOR_ROOT
      !IT_TOR_ITEM type /SCMTMS/T_EM_BO_TOR_ITEM
    changing
      !CT_DELIVERY type ZIF_GTT_SOF_CTP_TYPES=>TT_DELIVERY .
  methods INIT_DELIVERY_HEADERS
    importing
      !IT_DELIVERY_CHNG type ZIF_GTT_SOF_CTP_TYPES=>TT_DELIVERY_CHNG
      !IT_TOR_ROOT type /SCMTMS/T_EM_BO_TOR_ROOT
      !IT_TOR_ITEM type /SCMTMS/T_EM_BO_TOR_ITEM .
ENDCLASS.



CLASS ZCL_GTT_SOF_CTP_DAT_TOR_TO_DLH IMPLEMENTATION.


  METHOD CONSTRUCTOR.

    IF it_delivery_chng[] IS NOT INITIAL.
      init_delivery_headers(
        EXPORTING
          it_delivery_chng = it_delivery_chng
          it_tor_root      = it_tor_root
          it_tor_item      = it_tor_item ).
    ENDIF.

  ENDMETHOD.


  METHOD fill_delivery_data.

    DATA: lt_likp        TYPE HASHED TABLE OF likp WITH UNIQUE KEY vbeln,
          lt_lips        TYPE SORTED TABLE OF lipsvb WITH UNIQUE KEY vbeln posnr,
          lt_vbfa        TYPE STANDARD TABLE OF vbfavb,
          ls_lips        TYPE lipsvb,
          ls_vbuk        TYPE vbukvb,
          ls_vbup        TYPE vbupvb,
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

      SELECT *
        INTO CORRESPONDING FIELDS OF TABLE lt_vbfa
        FROM vbfa
        FOR ALL ENTRIES IN ct_delivery
       WHERE vbeln = ct_delivery-vbeln.

      LOOP AT ct_delivery ASSIGNING FIELD-SYMBOL(<ls_delivery>).

*       Delivery Header Status
        READ TABLE lt_likp INTO DATA(ls_likp) WITH KEY vbeln = <ls_delivery>-vbeln.
        IF sy-subrc = 0.
          MOVE-CORRESPONDING ls_likp TO ls_vbuk.
          APPEND ls_vbuk TO <ls_delivery>-vbuk.
          CLEAR ls_vbuk.
        ENDIF.

        " copy selected delivery header
        <ls_delivery>-likp  = VALUE #( lt_likp[ KEY primary_key
                                                COMPONENTS vbeln = <ls_delivery>-vbeln ]
                                         DEFAULT VALUE #( vbeln = <ls_delivery>-vbeln ) ).

*       Copy document flow data
        LOOP AT lt_vbfa INTO DATA(ls_vbfa) USING KEY primary_key
          WHERE vbeln = <ls_delivery>-vbeln.
          APPEND ls_vbfa TO <ls_delivery>-vbfa.
        ENDLOOP.

        " copy selected delivery items
        LOOP AT lt_lips ASSIGNING FIELD-SYMBOL(<ls_lips>)
          USING KEY primary_key
          WHERE vbeln = <ls_delivery>-vbeln.

          APPEND <ls_lips> TO <ls_delivery>-lips.

*         Delivery Item Status
          MOVE-CORRESPONDING <ls_lips> TO ls_vbup.
          APPEND ls_vbup TO <ls_delivery>-vbup.
          CLEAR:
            ls_vbup.
        ENDLOOP.

        " when data is not stored in DB yet, just take it from TOR tables
        IF sy-subrc <> 0.
          lv_base_btd_id  = |{ <ls_delivery>-vbeln ALPHA = IN }|.

          LOOP AT it_tor_item ASSIGNING FIELD-SYMBOL(<ls_tor_item>)
            WHERE base_btd_tco = zif_gtt_sof_ctp_tor_constants=>cv_base_btd_tco_outb_dlv
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
                         TRANSPORTING NO FIELDS.

              " no row -> add it
              IF sy-subrc <> 0.
                APPEND ls_lips to <ls_delivery>-lips.
              ENDIF.
            ENDIF.
          ENDLOOP.
        ENDIF.
      ENDLOOP.
    ENDIF.

  ENDMETHOD.


  METHOD GET_DELIVERIES.

    rr_deliveries   = REF #( mt_delivery ).

  ENDMETHOD.


  METHOD init_delivery_headers.

    DATA: ls_dlv_head TYPE zif_gtt_sof_ctp_types=>ts_delivery.

    CLEAR: mt_delivery[].

    " collect DLV Headers from DLV Items
    LOOP AT it_delivery_chng ASSIGNING FIELD-SYMBOL(<ls_delivery_chng>).
      READ TABLE mt_delivery TRANSPORTING NO FIELDS
        WITH KEY vbeln  = <ls_delivery_chng>-vbeln.

      IF sy-subrc <> 0.
        ls_dlv_head-vbeln = <ls_delivery_chng>-vbeln.
        APPEND ls_dlv_head TO mt_delivery.
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
          <ls_delivery>-fu_relevant = zcl_gtt_sof_tm_tools=>is_fu_relevant(
            it_lips = CORRESPONDING #( <ls_delivery>-lips ) ).
        CATCH cx_udm_message.
      ENDTRY.
    ENDLOOP.

  ENDMETHOD.
ENDCLASS.
