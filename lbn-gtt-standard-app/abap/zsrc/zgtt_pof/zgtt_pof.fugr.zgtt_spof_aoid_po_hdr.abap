FUNCTION zgtt_spof_aoid_po_hdr.
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
  TRY.
      e_appobjid = zcl_gtt_ef_performer=>get_app_obj_type_id(
        EXPORTING
          is_definition      = VALUE #( maintab = zif_gtt_spof_app_constants=>cs_tabledef-po_header_new )
          io_tp_factory      = NEW zcl_gtt_spof_tp_factory_po_hdr( )
          iv_appsys          = i_appsys
          is_app_obj_types   = i_app_obj_types
          it_all_appl_tables = i_all_appl_tables
          it_app_objects     = VALUE #( ( i_app_object ) ) ).

    CATCH cx_udm_message.
  ENDTRY.
ENDFUNCTION.
