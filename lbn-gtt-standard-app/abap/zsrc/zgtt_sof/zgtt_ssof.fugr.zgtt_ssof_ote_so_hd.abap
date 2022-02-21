FUNCTION ZGTT_SSOF_OTE_SO_HD.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(I_APPSYS) TYPE  /SAPTRX/APPLSYSTEM
*"     REFERENCE(I_APP_OBJ_TYPES) TYPE  /SAPTRX/AOTYPES
*"     REFERENCE(I_ALL_APPL_TABLES) TYPE  TRXAS_TABCONTAINER
*"     REFERENCE(I_APP_TYPE_CNTL_TABS) TYPE  TRXAS_APPTYPE_TABS
*"     REFERENCE(I_APP_OBJECTS) TYPE  TRXAS_APPOBJ_CTABS
*"  TABLES
*"      E_CONTROL_DATA STRUCTURE  /SAPTRX/CONTROL_DATA
*"      E_LOGTABLE STRUCTURE  BAPIRET2 OPTIONAL
*"  EXCEPTIONS
*"      PARAMETER_ERROR
*"      CDATA_DETERMINATION_ERROR
*"      TABLE_DETERMINATION_ERROR
*"      STOP_PROCESSING
*"----------------------------------------------------------------------
*----------------------------------------------------------------------*
* Top Include
* TYPE-POOLS:trxas.
*----------------------------------------------------------------------*

  DATA:
    ls_app_objects  TYPE trxas_appobj_ctab_wa,
    ls_control_data TYPE /saptrx/control_data,
    lt_xvbkd        TYPE STANDARD TABLE OF vbkdvb,
    lt_xvbpa        TYPE STANDARD TABLE OF vbpavb,
    ls_xvbkd        TYPE vbkdvb,
    ls_xvbpa        TYPE vbpavb,
*    lv_timestamp    TYPE tzntstmps,
    lv_tzone        TYPE timezone,
*    net value conversion
    rv_external     TYPE netwr_ak,
    lv_external     TYPE bapicurr_d,
    lt_xvbap        TYPE STANDARD TABLE OF vbapvb.

  FIELD-SYMBOLS:
    <ls_xvbap> TYPE vbapvb,
    <ls_xvbak> TYPE /saptrx/sd_sds_hdr.

* <1> Read necessary application tables from table reference
* Read Business Data New
  PERFORM read_appl_table
    USING    i_all_appl_tables
             gc_bpt_business_data_new
    CHANGING lt_xvbkd.

* Read Partner New
  PERFORM read_appl_table
    USING    i_all_appl_tables
             gc_bpt_partners_new
    CHANGING lt_xvbpa.

* Read Item New
  PERFORM read_appl_table
    USING    i_all_appl_tables
             gc_bpt_sales_order_items_new
    CHANGING lt_xvbap.

* <2> Fill general data for all control data records
  ls_control_data-appsys     = i_appsys.
  ls_control_data-appobjtype = i_app_obj_types-aotype.
  ls_control_data-language   = sy-langu.

* <3> Loop at application objects for geting Sales Order
*     add the following values which cannot be extracted in EM Data Extraction
* Sales Order
* Ship-to-Party
* Document date
* Customer Reference document no.
* Net value with currency
* Incoterms
* Incoterm location
* Incoterm version
* Actual Business Time
* Actual Business Time zone
* Sales Order Item table

  LOOP AT i_app_objects INTO ls_app_objects.

*   Application Object ID
    ls_control_data-appobjid   = ls_app_objects-appobjid.

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

*   SO No.
    ls_control_data-paramname = gc_cp_yn_so_no.
    ls_control_data-value     = |{ <ls_xvbak>-vbeln ALPHA = OUT }|.
    APPEND ls_control_data TO e_control_data.

*   Document date
    ls_control_data-paramname = gc_cp_yn_doc_date.
    IF <ls_xvbak>-audat IS NOT INITIAL.
      ls_control_data-value     = <ls_xvbak>-audat.
    ELSE.
      CLEAR ls_control_data-value.
    ENDIF.
    APPEND ls_control_data TO e_control_data.

*   Request delivery date
    ls_control_data-paramname = gc_cp_yn_so_req_dlv_dt.
    ls_control_data-value     = <ls_xvbak>-vdatu.
    APPEND ls_control_data TO e_control_data.

*   Net value
    ls_control_data-paramname = gc_cp_yn_net_value.
    CLEAR rv_external.
    IF <ls_xvbak>-netwr IS NOT INITIAL.
      CALL FUNCTION 'BAPI_CURRENCY_CONV_TO_EXTERNAL'
        EXPORTING
          currency        = <ls_xvbak>-waerk
          amount_internal = <ls_xvbak>-netwr
        IMPORTING
          amount_external = lv_external.
      rv_external   = round( val = lv_external dec = 2 ).
    ENDIF.
    ls_control_data-value     = rv_external.
    SHIFT ls_control_data-value LEFT  DELETING LEADING space.
    APPEND ls_control_data TO e_control_data.

*   Net value currency
    ls_control_data-paramname = gc_cp_yn_net_value_curr.
    ls_control_data-value     = <ls_xvbak>-waerk.
    APPEND ls_control_data TO e_control_data.

*   Business Data Information
    PERFORM read_business_data
      USING    lt_xvbkd
               <ls_xvbak>-vbeln
               '00'
      CHANGING ls_xvbkd.
    CLEAR ls_control_data-paramindex.
*   Incoterm 1
    ls_control_data-paramname = gc_cp_yn_so_incoterm1.
    ls_control_data-value     = ls_xvbkd-inco1.
    APPEND ls_control_data TO e_control_data.
*   Incoterm Location
    ls_control_data-paramname = gc_cp_yn_so_incotermloc1.
    ls_control_data-value     = ls_xvbkd-inco2_l.
    APPEND ls_control_data TO e_control_data.
*   Incoterm Version
    ls_control_data-paramname = gc_cp_yn_so_incotermversion.
    ls_control_data-value     = ls_xvbkd-incov.
    APPEND ls_control_data TO e_control_data.
*   Customer Reference document No.
    ls_control_data-paramname = gc_cp_yn_so_po_no.
    ls_control_data-value     = ls_xvbkd-bstkd.
    APPEND ls_control_data TO e_control_data.

*   Business Partner Information
*   Ship-to Party
    PERFORM read_business_partner
      USING    lt_xvbpa
               <ls_xvbak>-vbeln
               '00'
               gc_parvw_we
      CHANGING ls_xvbpa.
*   Ship-to Party
    ls_control_data-paramname = gc_cp_yn_so_ship_to.
    ls_control_data-value     = ls_xvbpa-kunnr.
    APPEND ls_control_data TO e_control_data.

*   Ship-to Party type
    ls_control_data-paramname = gc_cp_yn_so_ship_to_type.
    ls_control_data-value     = zif_gtt_sof_constants=>cs_loctype-bp.
    APPEND ls_control_data TO e_control_data.

*   Sold-to Party
    PERFORM read_business_partner
      USING    lt_xvbpa
               <ls_xvbak>-vbeln
               '00'
               gc_parvw_ag
      CHANGING ls_xvbpa.

    ls_control_data-paramname = gc_cp_yn_so_sold_to.
    ls_control_data-value     = ls_xvbpa-kunnr.
    APPEND ls_control_data TO e_control_data.

*   Sold-to Party type
    ls_control_data-paramname = gc_cp_yn_so_sold_to_type.
    ls_control_data-value     = zif_gtt_sof_constants=>cs_loctype-bp.
    APPEND ls_control_data TO e_control_data.

*   Actual Business Time zone
    CALL FUNCTION 'GET_SYSTEM_TIMEZONE'
      IMPORTING
        timezone            = lv_tzone
      EXCEPTIONS
        customizing_missing = 1
        OTHERS              = 2.
    ls_control_data-paramname = gc_cp_yn_act_timezone.
    ls_control_data-value     = lv_tzone.
    APPEND ls_control_data TO e_control_data.

    ls_control_data-paramname = gc_cp_yn_act_datetime.
    CONCATENATE '0' sy-datum sy-uzeit INTO ls_control_data-value.
    APPEND ls_control_data TO e_control_data.

*   Actual Technical Datetime & Time zone
    ls_control_data-paramname = gc_cp_yn_acttec_timezone."ACTUAL_TECHNICAL_TIMEZONE
    ls_control_data-value     = lv_tzone.
    APPEND ls_control_data TO e_control_data.

    ls_control_data-paramname = gc_cp_yn_acttec_datetime."ACTUAL_TECHNICAL_DATETIME
    CONCATENATE '0' sy-datum sy-uzeit INTO ls_control_data-value.
    APPEND ls_control_data TO e_control_data.

  ENDLOOP.
ENDFUNCTION.
