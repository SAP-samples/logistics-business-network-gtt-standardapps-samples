FUNCTION zgtt_ssof_ote_so_hdr_rel .
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
*----------------------------------------------------------------------*
* Top Include
* TYPE-POOLS:trxas.
*----------------------------------------------------------------------*

  DATA:
    lv_aot_relevance TYPE boole_d.

  FIELD-SYMBOLS:
    <ls_xvbak>       TYPE /saptrx/sd_sds_hdr.

  CLEAR gt_so_type.
  zcl_gtt_sof_toolkit=>get_so_type(
    RECEIVING
      rt_type = gt_so_type ).

* <1> Check if Main table is Sales Order or not.
  IF i_app_object-maintabdef <> gc_bpt_sales_order_header_new.
    PERFORM create_logtable_ao_rel
      TABLES c_logtable
      USING  i_app_object-maintabdef
             space
             i_app_obj_types-trrelfunc
             i_app_object-appobjtype
             i_appsys.
    RAISE parameter_error.
  ELSE.
*   Read Main Object Table (Sales Order - VBAK)
    ASSIGN i_app_object-maintabref->* TO <ls_xvbak>.
  ENDIF.

* <2> Check Relevance of AOT: YN_OTE
  PERFORM check_aot_relevance
     USING    <ls_xvbak>
     CHANGING lv_aot_relevance.
  CHECK lv_aot_relevance IS NOT INITIAL.

* <3> If Sales Order is NOT newly created, Check is Critical Changes Made
  IF <ls_xvbak>-updkz <> gc_insert.
    PERFORM check_for_header_changes
      USING    i_all_appl_tables
               <ls_xvbak>
      CHANGING lv_aot_relevance.
  ENDIF.

  IF lv_aot_relevance = gc_true.
    e_result = gc_true_condition.
  ELSE.
    e_result = gc_false_condition.
  ENDIF.

ENDFUNCTION.
