FUNCTION ZGTT_SSOF_TRACKID_OTE_SOITEM .
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(I_APPSYS) TYPE  /SAPTRX/APPLSYSTEM
*"     REFERENCE(I_APP_OBJ_TYPES) TYPE  /SAPTRX/AOTYPES
*"     REFERENCE(I_ALL_APPL_TABLES) TYPE  TRXAS_TABCONTAINER
*"     REFERENCE(I_APP_TYPE_CNTL_TABS) TYPE  TRXAS_APPTYPE_TABS
*"     REFERENCE(I_APP_OBJECTS) TYPE  TRXAS_APPOBJ_CTABS
*"  TABLES
*"      E_TRACKIDDATA STRUCTURE  /SAPTRX/TRACK_ID_DATA
*"      E_LOGTABLE STRUCTURE  BAPIRET2 OPTIONAL
*"  EXCEPTIONS
*"      PARAMETER_ERROR
*"      TID_DETERMINATION_ERROR
*"      TABLE_DETERMINATION_ERROR
*"      STOP_PROCESSING
*"----------------------------------------------------------------------
*----------------------------------------------------------------------*
* Top Include
* TYPE-POOLS:trxas.
*----------------------------------------------------------------------*

  DATA:
*   Definition of all application objects
    ls_app_objects TYPE trxas_appobj_ctab_wa,
    lv_tzone       TYPE timezone.

  FIELD-SYMBOLS:
*   Work Structure for Sales Order Item
    <ls_xvbap> TYPE vbapvb.

  CLEAR e_trackiddata.

  e_trackiddata-appsys     = i_appsys.
  e_trackiddata-appobjtype = i_app_obj_types-aotype.

* <3> Loop at application objects for geting sales order item data
  LOOP AT i_app_objects INTO ls_app_objects.

*   Application Object ID
    e_trackiddata-appobjid   = ls_app_objects-appobjid.

*   Check if Main table is Sales Order Item or not.
    IF ls_app_objects-maintabdef <> gc_bpt_sales_order_items_new.
      PERFORM create_logtable_aot
        TABLES e_logtable
        USING  ls_app_objects-maintabdef
               space
               i_app_obj_types-controldatafunc
               ls_app_objects-appobjtype
               i_appsys.
      RAISE table_determination_error.
    ELSE.
*     Read Main Object Table
      ASSIGN ls_app_objects-maintabref->* TO <ls_xvbap>.
    ENDIF.

    e_trackiddata-trxcod = zif_gtt_sof_constants=>cs_trxcod-sales_order_item.
    e_trackiddata-trxid = |{ <ls_xvbap>-vbeln ALPHA = OUT }{ <ls_xvbap>-posnr ALPHA = IN }|.
    CONDENSE e_trackiddata-trxid NO-GAPS.
    e_trackiddata-msrid = space.
    APPEND e_trackiddata.

  ENDLOOP.

ENDFUNCTION.
