FUNCTION zgtt_spof_ote_po_hdr_rel .
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(I_APPSYS) TYPE  /SAPTRX/APPLSYSTEM
*"     REFERENCE(I_APP_OBJ_TYPES) TYPE  /SAPTRX/AOTYPES
*"     REFERENCE(I_ALL_APPL_TABLES) TYPE  TRXAS_TABCONTAINER
*"     REFERENCE(I_APPTYPE_TAB) TYPE  TRXAS_APPTYPE_TABS_WA
*"     REFERENCE(I_APP_OBJECT) TYPE  TRXAS_APPOBJ_CTAB_WA
*"  EXPORTING
*"     VALUE(E_RESULT) LIKE  SY-BINPT
*"  TABLES
*"      C_LOGTABLE STRUCTURE  BAPIRET2 OPTIONAL
*"  EXCEPTIONS
*"      PARAMETER_ERROR
*"      RELEVANCE_DETERM_ERROR
*"      STOP_PROCESSING
*"----------------------------------------------------------------------
  DATA: lt_app_objects TYPE trxas_appobj_ctabs,
        lo_udm_message TYPE REF TO cx_udm_message,
        ls_bapiret     TYPE bapiret2.

  lt_app_objects  = VALUE #( ( i_app_object ) ).

  TRY.
      e_result  = zcl_gtt_ef_performer=>check_relevance(
                    is_definition         = VALUE #( maintab = zif_gtt_spof_app_constants=>cs_tabledef-po_header_new )
                    io_tp_factory         = NEW zcl_gtt_spof_tp_factory_po_hdr( )
                    iv_appsys             = i_appsys
                    is_app_obj_types      = i_app_obj_types
                    it_all_appl_tables    = i_all_appl_tables
                    it_app_objects        = lt_app_objects ).

    CATCH cx_udm_message INTO lo_udm_message.
      zcl_gtt_tools=>get_errors_log(
        EXPORTING
          io_umd_message = lo_udm_message
          iv_appsys      = i_appsys
        IMPORTING
          es_bapiret     = ls_bapiret ).

      " add error message
      APPEND ls_bapiret TO c_logtable.

      " throw corresponding exception
      CASE lo_udm_message->textid.
        WHEN zif_gtt_ef_constants=>cs_errors-stop_processing.
          RAISE stop_processing.
        WHEN zif_gtt_ef_constants=>cs_errors-table_determination.
          RAISE parameter_error.
      ENDCASE.
  ENDTRY.

ENDFUNCTION.
