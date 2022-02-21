FUNCTION ZGTT_SSOF_AOID.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(I_APPSYS) TYPE  /SAPTRX/APPLSYSTEM
*"     REFERENCE(I_APP_OBJ_TYPES) TYPE  /SAPTRX/AOTYPES
*"     REFERENCE(I_ALL_APPL_TABLES) TYPE  TRXAS_TABCONTAINER
*"     REFERENCE(I_APPTYPE_TAB) TYPE  TRXAS_APPTYPE_TABS_WA
*"     REFERENCE(I_APP_OBJECT) TYPE  TRXAS_APPOBJ_CTAB_WA
*"     REFERENCE(I_APP_MAINSTRUC)
*"  CHANGING
*"     REFERENCE(E_APPOBJID) TYPE  /SAPTRX/AOID
*"----------------------------------------------------------------------
  FIELD-SYMBOLS:
    <ls_vbak> TYPE /saptrx/sd_sds_hdr,
    <ls_vbap> TYPE vbapvb,
    <ls_likp> TYPE likpvb,
    <ls_lips> TYPE lipsvb.

  CLEAR e_appobjid.

  CASE i_app_object-maintabdef.

*   Sales order Header
    WHEN gc_bpt_sales_order_header_new. "SALES_ORDER_HEADER_NEW

      ASSIGN i_app_object-maintabref->* TO <ls_vbak>.
      IF <ls_vbak> IS ASSIGNED.
        e_appobjid = |{ <ls_vbak>-vbeln ALPHA = OUT }|.
      ENDIF.

*   Sales order Item
    WHEN gc_bpt_sales_order_items_new. "SALES_ORDER_ITEMS_NEW

      ASSIGN i_app_object-maintabref->* TO <ls_vbap>.
      IF <ls_vbap> IS ASSIGNED.
        e_appobjid = |{ <ls_vbap>-vbeln ALPHA = OUT }{ <ls_vbap>-posnr ALPHA = IN }|.
      ENDIF.

*   Outbound Delivery Header
    WHEN gc_bpt_delivery_header_new.   "DELIVERY_HEADER_NEW

      ASSIGN i_app_object-maintabref->* TO <ls_likp>.
      IF <ls_likp> IS ASSIGNED.
        e_appobjid = |{ <ls_likp>-vbeln ALPHA = OUT }|.
      ENDIF.

*   Outbound Delivery Item
    WHEN gc_bpt_delivery_item_new.     "DELIVERY_ITEM_NEW

      ASSIGN i_app_object-maintabref->* TO <ls_lips>.
      IF <ls_lips> IS ASSIGNED.
        e_appobjid = |{ <ls_lips>-vbeln ALPHA = OUT }{ <ls_lips>-posnr ALPHA = IN }|.
      ENDIF.

    WHEN OTHERS.

  ENDCASE.

  CONDENSE e_appobjid NO-GAPS.

ENDFUNCTION.
