FUNCTION ZGTT_SSOF_TRACKID_OTE_DEHDR .
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
*****<< THIS IS JUST EXAMPLE CODING >>*****
  DATA:
*   Definition of all application objects
    ls_app_objects TYPE trxas_appobj_ctab_wa,
    lv_tzone       TYPE timezone,
    lt_item_new    TYPE TABLE OF lipsvb,
    lt_item_old    TYPE TABLE OF lipsvb.

  FIELD-SYMBOLS:
*   Work Structure for Delivery Header
    <ls_xlikp> TYPE likpvb.

  CLEAR e_trackiddata.

  e_trackiddata-appsys     = i_appsys.
  e_trackiddata-appobjtype = i_app_obj_types-aotype.

* Read delivery item info(new)
  PERFORM read_appl_table USING i_all_appl_tables
                                gc_bpt_delivery_item_new
                       CHANGING lt_item_new.

* Read delivery item info(old)
  PERFORM read_appl_table USING i_all_appl_tables
                                gc_bpt_delivery_item_old
                       CHANGING lt_item_old.

* Loop at application objects for geting delivery Header data
  LOOP AT i_app_objects INTO ls_app_objects.

*   Application Object ID
    e_trackiddata-appobjid   = ls_app_objects-appobjid.

*   Check if Main table is Delivery Header or not.
    IF ls_app_objects-maintabdef <> gc_bpt_delivery_header_new.
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
      ASSIGN ls_app_objects-maintabref->* TO <ls_xlikp>.
    ENDIF.

    e_trackiddata-trxcod = zif_gtt_sof_constants=>cs_trxcod-out_delivery.
    e_trackiddata-trxid = |{ <ls_xlikp>-vbeln ALPHA = OUT } |.
    CONDENSE e_trackiddata-trxid NO-GAPS.
    e_trackiddata-msrid = space.
    APPEND e_trackiddata.

*   Add delivery item tracking
    LOOP AT lt_item_new INTO DATA(ls_item_new) WHERE vbeln = <ls_xlikp>-vbeln
                                                 AND updkz IS NOT INITIAL.

      IF ls_item_new-updkz = 'I'.
        e_trackiddata-trxcod = zif_gtt_sof_constants=>cs_trxcod-out_delivery_item.
        e_trackiddata-trxid = |{ ls_item_new-vbeln ALPHA = OUT }{ ls_item_new-posnr ALPHA = IN }|.
        CONDENSE e_trackiddata-trxid NO-GAPS.
        e_trackiddata-action = ''.
        APPEND e_trackiddata.
      ELSEIF ls_item_new-updkz = 'D'.
        e_trackiddata-trxcod = zif_gtt_sof_constants=>cs_trxcod-out_delivery_item.
        e_trackiddata-trxid = |{ ls_item_new-vbeln ALPHA = OUT }{ ls_item_new-posnr ALPHA = IN }|.
        CONDENSE e_trackiddata-trxid NO-GAPS.
        e_trackiddata-action = 'D'.
        APPEND e_trackiddata.
      ENDIF.
    ENDLOOP.

  ENDLOOP.

ENDFUNCTION.
