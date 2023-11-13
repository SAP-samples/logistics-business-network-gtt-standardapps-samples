class ZCL_GTT_SPOF_CTP_DLH_DATA definition
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
      !RR_EKKO type ref to DATA
      !RR_EKPO type ref to DATA
      !RR_EKET type ref to DATA
      !RR_REF_LIST type ref to DATA
      !RR_LIKP type ref to DATA
      !RR_LIPS type ref to DATA .
  PROTECTED SECTION.
private section.

  data MT_EKKO type ZIF_GTT_SPOF_APP_TYPES=>TT_UEKKO .
  data MT_EKPO type ZIF_GTT_SPOF_APP_TYPES=>TT_UEKPO .
  data MT_EKET type ZIF_GTT_SPOF_APP_TYPES=>TT_UEKET .
  data MT_REF_LIST type ZIF_GTT_SPOF_APP_TYPES=>TT_REF_LIST .
  data MT_LIKP type VA_LIKPVB_T .
  data MT_LIPS type VA_LIPSVB_T .

  methods INIT_PO_HEADER_DATA
    importing
      !IT_XLIKP type SHP_LIKP_T
      !IT_XLIPS type SHP_LIPS_T
      !IT_YLIPS type SHP_LIPS_T
    exporting
      !ET_EKKO type ZIF_GTT_SPOF_APP_TYPES=>TT_UEKKO
      !ET_EKPO type ZIF_GTT_SPOF_APP_TYPES=>TT_UEKPO
      !ET_EKET type ZIF_GTT_SPOF_APP_TYPES=>TT_UEKET
      !ET_REF_LIST type ZIF_GTT_SPOF_APP_TYPES=>TT_REF_LIST
    raising
      CX_UDM_MESSAGE .
ENDCLASS.



CLASS ZCL_GTT_SPOF_CTP_DLH_DATA IMPLEMENTATION.


  METHOD constructor.

    init_po_header_data(
      EXPORTING
        it_xlikp    = it_xlikp
        it_xlips    = it_xlips
        it_ylips    = it_ylips
      IMPORTING
        et_ekko     = mt_ekko
        et_ekpo     = mt_ekpo
        et_eket     = mt_eket
        et_ref_list = mt_ref_list ).

    mt_likp = it_xlikp.
    mt_lips = it_xlips.

  ENDMETHOD.


  METHOD get_related_po_data.

    rr_ekko     = REF #( mt_ekko ).
    rr_ekpo     = REF #( mt_ekpo ).
    rr_eket     = REF #( mt_eket ).
    rr_ref_list = REF #( mt_ref_list ).
    rr_likp     = REF #( mt_likp ).
    rr_lips     = REF #( mt_lips ).

  ENDMETHOD.


  METHOD init_po_header_data.

    DATA:
      ls_likp     TYPE likpvb,
      lt_lips     TYPE shp_lips_t,
      lt_ref_list TYPE zif_gtt_spof_app_types=>tt_ref_list,
      lt_ekko     TYPE zif_gtt_spof_app_types=>tt_uekko,
      lt_ekpo     TYPE zif_gtt_spof_app_types=>tt_uekpo,
      lt_eket     TYPE zif_gtt_spof_app_types=>tt_ueket.

    CLEAR:
      et_ekko,
      et_ekpo,
      et_eket,
      et_ref_list.

    LOOP AT it_xlips ASSIGNING FIELD-SYMBOL(<ls_xlips>).
      CLEAR ls_likp.
      READ TABLE it_xlikp INTO ls_likp WITH KEY vbeln = <ls_xlips>-vbeln.
      IF sy-subrc <> 0.
        CONTINUE.
      ENDIF.

      CHECK zcl_gtt_tools=>is_appropriate_dl_item( ir_likp = REF #( ls_likp ) ir_lips = REF #( <ls_xlips> ) ) = abap_true.
      APPEND <ls_xlips> TO lt_lips.
    ENDLOOP.

    CHECK lt_lips IS NOT INITIAL.

    zcl_gtt_tools=>get_po_so_by_delivery(
      EXPORTING
        iv_vgtyp    = if_sd_doc_category=>purchase_order
        it_xlikp    = it_xlikp
        it_xlips    = lt_lips
      IMPORTING
        et_ref_list = lt_ref_list ).

    IF lt_ref_list IS NOT INITIAL.
      SELECT *
        INTO TABLE lt_ekko
        FROM ekko
         FOR ALL ENTRIES IN lt_ref_list
       WHERE ebeln = lt_ref_list-vgbel.

      SELECT *
        INTO CORRESPONDING FIELDS OF TABLE lt_ekpo
        FROM ekpo
         FOR ALL ENTRIES IN lt_ref_list
       WHERE ebeln = lt_ref_list-vgbel.

      SELECT *
        INTO CORRESPONDING FIELDS OF TABLE lt_eket
        FROM eket
         FOR ALL ENTRIES IN lt_ref_list
       WHERE ebeln = lt_ref_list-vgbel.
    ENDIF.

    LOOP AT lt_ekko INTO DATA(ls_ekko).
      CHECK zcl_gtt_spof_po_tools=>is_appropriate_po(
          ir_ekko = REF #( ls_ekko )
          ir_ekpo = REF #( lt_ekpo ) ) = abap_true.
      APPEND ls_ekko TO et_ekko.
    ENDLOOP.

    LOOP AT lt_ekpo INTO DATA(ls_ekpo).
      CLEAR ls_ekko.
      READ TABLE et_ekko INTO ls_ekko WITH KEY ebeln = ls_ekpo-ebeln.
      IF sy-subrc = 0.
        APPEND ls_ekpo TO et_ekpo.
      ENDIF.
    ENDLOOP.

    LOOP AT lt_eket INTO DATA(ls_eket).
      CLEAR ls_ekko.
      READ TABLE et_ekko INTO ls_ekko WITH KEY ebeln = ls_eket-ebeln.
      IF sy-subrc = 0.
        APPEND ls_eket TO et_eket.
      ENDIF.
    ENDLOOP.

    LOOP AT lt_ref_list INTO DATA(ls_ref_list).
      CLEAR ls_ekko.
      READ TABLE et_ekko INTO ls_ekko WITH KEY ebeln = ls_ref_list-vgbel.
      IF sy-subrc <> 0.
        DELETE lt_ref_list.
      ENDIF.
    ENDLOOP.

    et_ref_list = lt_ref_list.

  ENDMETHOD.
ENDCLASS.
