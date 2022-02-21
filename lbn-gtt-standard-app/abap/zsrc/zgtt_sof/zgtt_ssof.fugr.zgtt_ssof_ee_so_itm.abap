FUNCTION ZGTT_SSOF_EE_SO_ITM.
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
    <ls_xvbap> TYPE vbapvb.

  DATA:
    ls_app_objects  TYPE trxas_appobj_ctab_wa,
    ls_expeventdata TYPE /saptrx/exp_events,
    lt_vbap         TYPE TABLE OF vbapvb,
    lt_lips         TYPE TABLE OF gtys_lips.

* <1> Read necessary application tables from table reference
  PERFORM read_appl_table
    USING    i_all_appl_tables
             gc_bpt_sales_order_items_new
    CHANGING lt_vbap.

* Check the sales order linked with outbound delivery or not
  IF lt_vbap IS NOT INITIAL.
    SELECT vbeln
           posnr
           vgbel
           vgpos
      INTO TABLE lt_lips
      FROM lips
       FOR ALL ENTRIES IN lt_vbap
     WHERE vgbel = lt_vbap-vbeln
       AND vgpos = lt_vbap-posnr.
  ENDIF.

* Sales order not linked with outbound delivery
  IF lt_lips IS INITIAL.
    RETURN.
  ENDIF.

* <2> Fill general data for Expected events
  CLEAR ls_expeventdata.
  ls_expeventdata-appsys     = i_appsys. "Logical System ID of an application system
  ls_expeventdata-appobjtype = i_app_obj_types-aotype. "Application Object type
  ls_expeventdata-language   = sy-langu. "Login Language

* <3> Loop at application objects
  LOOP AT i_app_objects INTO ls_app_objects.

*   Application Object ID
    ls_expeventdata-appobjid = ls_app_objects-appobjid.

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

    LOOP AT lt_lips INTO DATA(ls_lips) WHERE vgbel = <ls_xvbap>-vbeln
                                         AND vgpos = <ls_xvbap>-posnr.
*     Add planned event ItemCompleteds
      ls_expeventdata-milestone    = zif_gtt_sof_constants=>cs_milestone-dlv_item_completed.
      ls_expeventdata-locid2       = |{ ls_lips-vbeln ALPHA = OUT }{ ls_lips-posnr ALPHA = IN }|.
      CONDENSE ls_expeventdata-locid2 NO-GAPS.
      APPEND ls_expeventdata TO e_expeventdata.

    ENDLOOP.

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
