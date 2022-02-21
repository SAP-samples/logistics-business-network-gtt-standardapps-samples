FUNCTION ZGTT_SSOF_EE_SO_HD.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(I_APPSYS) TYPE  /SAPTRX/APPLSYSTEM
*"     REFERENCE(I_APP_OBJ_TYPES) TYPE  /SAPTRX/AOTYPES
*"     REFERENCE(I_ALL_APPL_TABLES) TYPE  TRXAS_TABCONTAINER
*"     REFERENCE(I_APP_TYPE_CNTL_TABS) TYPE  TRXAS_APPTYPE_TABS
*"     REFERENCE(I_APP_OBJECTS) TYPE  TRXAS_APPOBJ_CTABS
*"  TABLES
*"      E_EXPEVENTDATA STRUCTURE  /SAPTRX/EXP_EVENTS
*"      E_MEASRMNTDATA STRUCTURE  /SAPTRX/MEASR_DATA OPTIONAL
*"      E_INFODATA STRUCTURE  /SAPTRX/INFO_DATA OPTIONAL
*"      E_LOGTABLE STRUCTURE  BAPIRET2 OPTIONAL
*"  EXCEPTIONS
*"      PARAMETER_ERROR
*"      EXP_EVENT_DETERM_ERROR
*"      TABLE_DETERMINATION_ERROR
*"      STOP_PROCESSING
*"----------------------------------------------------------------------
  FIELD-SYMBOLS:
    <ls_xvbak> TYPE /saptrx/sd_sds_hdr.

  DATA:
    ls_app_objects  TYPE trxas_appobj_ctab_wa,
    ls_expeventdata TYPE /saptrx/exp_events,
    lt_vbap         TYPE TABLE OF vbapvb,
    lv_exp_datetime TYPE timestamp,
    lv_time         TYPE tims VALUE '235959'.

* <1> Read necessary application tables from table reference
  PERFORM read_appl_table
    USING    i_all_appl_tables
             gc_bpt_sales_order_items_new
    CHANGING lt_vbap.

* <2> Fill general data for Expected events
  CLEAR ls_expeventdata.
  ls_expeventdata-appsys     = i_appsys. "Logical System ID of an application system
  ls_expeventdata-appobjtype = i_app_obj_types-aotype. "Application Object type
  ls_expeventdata-language   = sy-langu. "Login Language

* <3> Loop at application objects
  LOOP AT i_app_objects INTO ls_app_objects.

*   Application Object ID
    ls_expeventdata-appobjid = ls_app_objects-appobjid.

*   Check if Main table is Sales Order Header or not.
    IF ls_app_objects-maintabdef <> gc_bpt_sales_order_header_new.
      PERFORM create_logtable_aot
        TABLES e_logtable
        USING  space
               ls_app_objects-maintabdef
               i_app_obj_types-controldatafunc
               ls_app_objects-appobjtype
               i_appsys.
      RAISE table_determination_error.
    ELSE.
*     Read Main Object Table
      ASSIGN ls_app_objects-maintabref->* TO <ls_xvbak>.
    ENDIF.

*   Add planned event SOItemCompleteds
    LOOP AT lt_vbap INTO DATA(ls_vbap) WHERE vbeln = <ls_xvbak>-vbeln AND updkz <> 'D'.
      ls_expeventdata-milestone    = zif_gtt_sof_constants=>cs_milestone-so_item_completed.
      ls_expeventdata-locid2       = |{ ls_vbap-vbeln ALPHA = OUT }{ ls_vbap-posnr ALPHA = IN }|.
      CONDENSE ls_expeventdata-locid2 NO-GAPS.
      APPEND ls_expeventdata TO e_expeventdata.
    ENDLOOP.

*   Add planned event SODelivered
    CLEAR:
      ls_expeventdata-milestone,
      ls_expeventdata-locid2,
      lv_exp_datetime.
    ls_expeventdata-milestone = zif_gtt_sof_constants=>cs_milestone-so_planned_dlv.
    lv_exp_datetime = |0{ <ls_xvbak>-vdatu }{ lv_time }|.

    zcl_gtt_sof_toolkit=>convert_utc_timestamp(
      EXPORTING
        iv_timezone  = sy-zonlo                 " Time Zone
      CHANGING
        cv_timestamp = lv_exp_datetime ).       " Date stored in timestamp

    ls_expeventdata-evt_exp_datetime = |0{ lv_exp_datetime }|.
    ls_expeventdata-evt_exp_tzone = sy-zonlo.
    APPEND ls_expeventdata TO e_expeventdata.

    READ TABLE e_expeventdata WITH KEY appobjid = ls_app_objects-appobjid TRANSPORTING NO FIELDS.
    IF sy-subrc NE 0.
      ls_expeventdata-evt_exp_datetime = '000000000000000'.
      ls_expeventdata-milestone     = ''.
      ls_expeventdata-evt_exp_tzone = ''.
      ls_expeventdata-loctype = ''.
      ls_expeventdata-locid1 = ''.
      ls_expeventdata-locid2 = ''.
      APPEND ls_expeventdata TO e_expeventdata.
    ENDIF.

  ENDLOOP.

ENDFUNCTION.
