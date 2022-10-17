FUNCTION zgtt_ssof_trackid_ote_deitem .
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

*****<< THIS IS JUST EXAMPLE CODING >>*****
  DATA:
*   Definition of all application objects
    ls_app_objects TYPE trxas_appobj_ctab_wa,
    lv_tzone       TYPE timezone.

  FIELD-SYMBOLS:
*   Work Structure for Delivery Item
    <ls_xlips> TYPE lipsvb,
    <ls_xlikp> TYPE likpvb.

  CLEAR e_trackiddata.

  e_trackiddata-appsys     = i_appsys.
  e_trackiddata-appobjtype = i_app_obj_types-aotype.

* <3> Loop at application objects for geting delivery item data
  LOOP AT i_app_objects INTO ls_app_objects.

*   Application Object ID
    e_trackiddata-appobjid   = ls_app_objects-appobjid.

*   Check if Main table is Delivery Item or not.
    IF ls_app_objects-maintabdef <> gc_bpt_delivery_item_new.
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
      ASSIGN ls_app_objects-maintabref->* TO <ls_xlips>.
    ENDIF.

    e_trackiddata-trxcod = zif_gtt_sof_constants=>cs_trxcod-out_delivery_item.
    e_trackiddata-trxid = |{ <ls_xlips>-vbeln ALPHA = OUT }{ <ls_xlips>-posnr ALPHA = IN }|.
    CONDENSE e_trackiddata-trxid NO-GAPS.
    e_trackiddata-msrid = space.
    APPEND e_trackiddata.

*   DLV Item watch DLV Header
    IF <ls_xlips>-updkz = 'I'.
      e_trackiddata-trxcod = zif_gtt_sof_constants=>cs_trxcod-out_delivery.
      e_trackiddata-trxid = |{ <ls_xlips>-vbeln ALPHA = OUT }|.
      CONDENSE e_trackiddata-trxid NO-GAPS.
      e_trackiddata-msrid = space.
      APPEND e_trackiddata.

**     Get tracking id for FU
*      ASSIGN ls_app_objects-mastertabref->* TO <ls_xlikp>.
*      zcl_gtt_sof_toolkit=>get_instance( )->get_relation(
*        EXPORTING
*          iv_vbeln    = <ls_xlips>-vbeln  " Delivery
*          iv_posnr    = <ls_xlips>-posnr  " Item
*          iv_vbtyp    = <ls_xlikp>-vbtyp  " SD Document Category
*        IMPORTING
*          et_relation = DATA(lt_relation) ).
*      LOOP AT lt_relation INTO DATA(ls_relation).
*        APPEND INITIAL LINE TO e_trackiddata ASSIGNING FIELD-SYMBOL(<ls_fu_tracking>).
*        <ls_fu_tracking>-appsys     = i_appsys.
*        <ls_fu_tracking>-appobjtype = i_app_obj_types-aotype.
*        <ls_fu_tracking>-appobjid   = ls_app_objects-appobjid.
*        <ls_fu_tracking>-trxcod = zif_gtt_sof_constants=>cs_trxcod-fu_number.
*        <ls_fu_tracking>-trxid = |{ ls_relation-freight_unit_number ALPHA = OUT }|.
*      ENDLOOP.
*      CLEAR:lt_relation.

    ENDIF.

  ENDLOOP.

ENDFUNCTION.
