FUNCTION zgtt_mia_aoid_dl_hdr.
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
      e_appobjid = zcl_gtt_mia_ef_performer=>get_app_obj_type_id(
        EXPORTING
          is_definition         = VALUE #( maintab = zif_gtt_mia_app_constants=>cs_tabledef-dl_header_new )
          io_tp_factory         = NEW zcl_gtt_mia_tp_factory_dlh( )
          iv_appsys             = i_appsys
          is_app_obj_types      = i_app_obj_types
          it_all_appl_tables    = i_all_appl_tables
          it_app_objects        = VALUE #( ( i_app_object ) ) ).

    CATCH cx_udm_message.
  ENDTRY.
ENDFUNCTION.
