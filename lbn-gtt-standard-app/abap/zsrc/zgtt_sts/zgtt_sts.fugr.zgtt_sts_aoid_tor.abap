FUNCTION zgtt_sts_aoid_tor.
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
  FIELD-SYMBOLS <ls_root> TYPE /scmtms/s_em_bo_tor_root.

  CLEAR e_appobjid.

  ASSIGN i_app_object-maintabref->* TO <ls_root>.
  IF sy-subrc = 0.
    e_appobjid = |{ <ls_root>-tor_id ALPHA = OUT }|.
  ENDIF..

ENDFUNCTION.
