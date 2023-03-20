class ZCL_GTT_SPOF_CTP_DLI_DATA definition
  public
  create public .

public section.

  methods CONSTRUCTOR
    importing
      !IT_XLIKP type SHP_LIKP_T
      !IT_XLIPS type SHP_LIPS_T
      !IT_YLIPS type SHP_LIPS_T
    raising
      CX_UDM_MESSAGE .
  methods GET_RELATED_PO_DATA
    exporting
      !RR_LIKP type ref to DATA
      !RR_LIPS type ref to DATA
      !RR_EKKO type ref to DATA
      !RR_EKPO type ref to DATA
      !RR_EKES type ref to DATA
      !RR_EKET type ref to DATA .
  PROTECTED SECTION.
private section.

  data MT_EKKO type ZIF_GTT_SPOF_APP_TYPES=>TT_UEKKO .
  data MT_EKPO type ZIF_GTT_SPOF_APP_TYPES=>TT_UEKPO .
  data MT_EKES type ZIF_GTT_SPOF_APP_TYPES=>TT_UEKES .
  data MT_EKET type ZIF_GTT_SPOF_APP_TYPES=>TT_UEKET .
  data MT_LIKP type VA_LIKPVB_T .
  data MT_LIPS type VA_LIPSVB_T .

  methods INIT_PO_ITEM_DATA
    importing
      !IT_XLIKP type SHP_LIKP_T
      !IT_XLIPS type SHP_LIPS_T
      !IT_YLIPS type SHP_LIPS_T
    exporting
      !ET_EKES type ZIF_GTT_SPOF_APP_TYPES=>TT_UEKES
      !ET_EKKO type ZIF_GTT_SPOF_APP_TYPES=>TT_UEKKO
      !ET_EKPO type ZIF_GTT_SPOF_APP_TYPES=>TT_UEKPO
      !ET_EKET type ZIF_GTT_SPOF_APP_TYPES=>TT_UEKET
    raising
      CX_UDM_MESSAGE .
  methods MERGE_EKES
    importing
      !IS_XLIKP type LIKPVB
      !IS_XLIPS type LIPSVB
      !IS_YLIPS type LIPSVB
      !I_EBELN type EBELN
      !I_EBELP type EBELP
    changing
      !CT_EKES type ZIF_GTT_SPOF_APP_TYPES=>TT_UEKES
    raising
      CX_UDM_MESSAGE .
ENDCLASS.



CLASS ZCL_GTT_SPOF_CTP_DLI_DATA IMPLEMENTATION.


  METHOD constructor.
    init_po_item_data(
      EXPORTING
        it_xlikp = it_xlikp
        it_xlips = it_xlips
        it_ylips = it_ylips
      IMPORTING
        et_ekes  = mt_ekes
        et_ekko  = mt_ekko
        et_ekpo  = mt_ekpo
        et_eket  = mt_eket
    ).

    mt_likp = it_xlikp.
    mt_lips = it_xlips.

  ENDMETHOD.


  METHOD get_related_po_data.

    rr_ekko   = REF #( mt_ekko ).
    rr_ekpo   = REF #( mt_ekpo ).
    rr_ekes   = REF #( mt_ekes ).
    rr_eket   = REF #( mt_eket ).
    rr_likp   = REF #( mt_likp ).
    rr_lips   = REF #( mt_lips ).

  ENDMETHOD.


  METHOD init_po_item_data.

    DATA: ls_ekko    TYPE ekko,
          ls_ekpo    TYPE ekpo,
          l_archived TYPE boole_d,
          lv_ebelp   TYPE ebelp.
    DATA: lt_eket  TYPE STANDARD TABLE OF eket,
          lt_ueket TYPE zif_gtt_spof_app_types=>tt_ueket,
          ls_likp  TYPE likpvb.
    CLEAR: et_ekko, et_ekpo, et_ekes, et_eket.

    LOOP AT it_xlips ASSIGNING FIELD-SYMBOL(<ls_xlips>).
      CLEAR ls_likp.
      READ TABLE it_xlikp INTO ls_likp WITH KEY vbeln = <ls_xlips>-vbeln.
      IF sy-subrc <> 0.
        CONTINUE.
      ENDIF.
      CHECK zcl_gtt_tools=>is_appropriate_dl_item( ir_likp = REF #( ls_likp ) ir_lips = REF #( <ls_xlips> ) ) = abap_true
         OR zcl_gtt_tools=>is_appropriate_odlv_item( ir_likp = REF #( ls_likp ) ir_lips = REF #( <ls_xlips> ) ) = abap_true."Support STO Scenario

      CHECK zcl_gtt_tools=>is_appropriate_dl_type( ir_likp = REF #( ls_likp ) ) = abap_true
         OR zcl_gtt_tools=>is_appropriate_odlv_type( ir_likp = REF #( ls_likp ) ) = abap_true."Support STO Scenario

      DATA(lv_ebeln)  = <ls_xlips>-vgbel.
      DATA(lv_vgpos)  = <ls_xlips>-vgpos.

      IF lv_ebeln IS NOT INITIAL AND lv_vgpos IS NOT INITIAL.
        zcl_gtt_spof_po_tools=>get_po_header(
          EXPORTING
            i_ebeln    = lv_ebeln
          IMPORTING
            es_ekko    = ls_ekko
            e_archived = l_archived
        ).

        IF ls_ekko IS INITIAL.
          CONTINUE.
        ENDIF.

        lv_ebelp = lv_vgpos+1(5).
        zcl_gtt_spof_po_tools=>get_po_item(
          EXPORTING
            i_ebeln    = lv_ebeln
            i_ebelp    = lv_ebelp
            i_archived = l_archived
            is_ekko    = ls_ekko
          IMPORTING
            es_ekpo    = ls_ekpo
        ).

        IF ls_ekpo IS NOT INITIAL AND
          zcl_gtt_spof_po_tools=>is_appropriate_po_item( ir_ekko = REF #( ls_ekko ) ir_ekpo = REF #( ls_ekpo ) ) = abap_true.
          TRY.
              DATA(ls_duplicate_ekko) = et_ekko[ ebeln = lv_ebeln ].
            CATCH cx_sy_itab_line_not_found.
              et_ekko   = VALUE #( BASE et_ekko
                             ( CORRESPONDING #( ls_ekko ) ) ).
          ENDTRY.

          et_ekpo   = VALUE #( BASE et_ekpo
                             ( CORRESPONDING #( ls_ekpo ) ) ).

          SELECT * FROM ekes APPENDING CORRESPONDING FIELDS OF TABLE et_ekes
                         WHERE ebeln EQ lv_ebeln AND
                               ebelp EQ lv_ebelp AND
                               loekz NE abap_true.
          TRY.
              DATA(ls_ylips) = it_ylips[ vbeln = <ls_xlips>-vbeln posnr = <ls_xlips>-posnr ].
            CATCH cx_sy_itab_line_not_found.
          ENDTRY.

          merge_ekes(
            EXPORTING
              is_xlikp = ls_likp
              is_xlips = <ls_xlips>
              is_ylips = ls_ylips
              i_ebeln  = lv_ebeln
              i_ebelp  = lv_ebelp
            CHANGING
              ct_ekes  = et_ekes
          ).
          CLEAR: lt_eket,lt_ueket.
          CALL FUNCTION 'ME_EKET_SINGLE_READ_ITEM'
            EXPORTING
              pi_ebeln            = lv_ebeln
              pi_ebelp            = lv_ebelp
            TABLES
              pto_eket            = lt_eket
            EXCEPTIONS
              err_no_record_found = 1
              OTHERS              = 2.
          IF sy-subrc <> 0.
            CLEAR lt_eket.
          ENDIF.
          IF lt_eket IS NOT INITIAL.
            lt_ueket   = CORRESPONDING #( lt_eket ).
            APPEND LINES OF lt_ueket TO et_eket.
          ENDIF.

        ENDIF.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.


  METHOD merge_ekes.

    DATA: ls_ekes            TYPE zif_gtt_spof_app_types=>ts_uekes.

    ls_ekes-ebeln = i_ebeln.
    ls_ekes-ebelp = i_ebelp.
    ls_ekes-vbeln = CONV vbeln_vl( is_xlips-vbeln ).
    ls_ekes-vbelp = CONV posnr_vl( is_xlips-posnr ).
    ls_ekes-menge = CONV bbmng( is_xlips-lfimg ).

    CASE is_xlips-updkz.
      WHEN zif_gtt_ef_constants=>cs_change_mode-insert.
        ls_ekes-kz = zif_gtt_ef_constants=>cs_change_mode-insert.
      WHEN zif_gtt_ef_constants=>cs_change_mode-update OR
           zif_gtt_ef_constants=>cs_change_mode-undefined.

        IF is_ylips IS NOT INITIAL.

          IF is_xlips-lfimg <>  is_ylips-lfimg.
            LOOP AT ct_ekes ASSIGNING FIELD-SYMBOL(<ls_ekes>) WHERE vbeln = ls_ekes-vbeln AND
                                                                    vbelp = ls_ekes-vbelp.
              <ls_ekes>-kz    = zif_gtt_ef_constants=>cs_change_mode-update.
              <ls_ekes>-menge = ls_ekes-menge.
              EXIT.
            ENDLOOP.
          ENDIF.
        ENDIF.

      WHEN zif_gtt_ef_constants=>cs_change_mode-delete.
        ls_ekes-kz = zif_gtt_ef_constants=>cs_change_mode-delete.
        ls_ekes-loekz = 'X'.
        ls_ekes-menge = ls_ekes-menge * -1.
    ENDCASE.

    IF ls_ekes-kz IS NOT INITIAL.
      APPEND ls_ekes TO ct_ekes.
    ENDIF.


  ENDMETHOD.
ENDCLASS.
