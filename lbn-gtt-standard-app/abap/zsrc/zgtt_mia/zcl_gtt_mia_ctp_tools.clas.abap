class ZCL_GTT_MIA_CTP_TOOLS definition
  public
  create public .

public section.

  class-methods GET_DELIVERY_HEAD_PLANNED_EVT
    importing
      !IV_APPSYS type LOGSYS
      !IS_AOTYPE type ZIF_GTT_CTP_TYPES=>TS_AOTYPE
      !IS_LIKP type ZIF_GTT_MIA_APP_TYPES=>TS_LIKPVB
      !IT_LIPS type ZIF_GTT_MIA_APP_TYPES=>TT_LIPSVB
    exporting
      !ET_EXP_EVENT type /SAPTRX/BAPI_TRK_EE_TAB
    raising
      CX_UDM_MESSAGE .
  class-methods GET_DELIVERY_ITEM_PLANNED_EVT
    importing
      !IV_APPSYS type LOGSYS
      !IS_AOTYPE type ZIF_GTT_CTP_TYPES=>TS_AOTYPE
      !IS_LIKP type ZIF_GTT_MIA_APP_TYPES=>TS_LIKPVB
      !IS_LIPS type ZIF_GTT_MIA_APP_TYPES=>TS_LIPSVB
    exporting
      !ET_EXP_EVENT type /SAPTRX/BAPI_TRK_EE_TAB
    raising
      CX_UDM_MESSAGE .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_GTT_MIA_CTP_TOOLS IMPLEMENTATION.


  METHOD get_delivery_head_planned_evt.

    DATA: ls_app_obj_types      TYPE /saptrx/aotypes,
          lt_all_appl_tables    TYPE trxas_tabcontainer,
          lt_app_type_cntl_tabs TYPE trxas_apptype_tabs,
          ls_app_objects        TYPE trxas_appobj_ctab_wa,
          lt_app_objects        TYPE trxas_appobj_ctabs.

    CLEAR: et_exp_event[].

    ls_app_obj_types              = CORRESPONDING #( is_aotype ).

    ls_app_objects                = CORRESPONDING #( ls_app_obj_types ).
    ls_app_objects-appobjtype     = is_aotype-aot_type.
    ls_app_objects-appobjid       = zcl_gtt_mia_dl_tools=>get_tracking_id_dl_header(
                                      ir_likp = REF #( is_likp ) ).
    ls_app_objects-maintabref     = REF #( is_likp ).
    ls_app_objects-maintabdef     = zif_gtt_mia_app_constants=>cs_tabledef-dl_header_new.

    lt_app_objects                = VALUE #( ( ls_app_objects ) ).

    lt_all_appl_tables            = VALUE #( (
      tabledef    = zif_gtt_mia_app_constants=>cs_tabledef-dl_item_new
      tableref    = REF #( it_lips )
     ) ).

    CALL FUNCTION 'ZGTT_MIA_EE_DL_HDR'
      EXPORTING
        i_appsys                  = iv_appsys
        i_app_obj_types           = CORRESPONDING /saptrx/aotypes( is_aotype )
        i_all_appl_tables         = lt_all_appl_tables
        i_app_type_cntl_tabs      = lt_app_type_cntl_tabs
        i_app_objects             = lt_app_objects
      TABLES
        e_expeventdata            = et_exp_event
      EXCEPTIONS
        parameter_error           = 1
        exp_event_determ_error    = 2
        table_determination_error = 3
        stop_processing           = 4
        OTHERS                    = 5.

    IF sy-subrc <> 0.
      zcl_gtt_tools=>throw_exception( ).
    ENDIF.

  ENDMETHOD.


  METHOD get_delivery_item_planned_evt.

    DATA: ls_app_obj_types      TYPE /saptrx/aotypes,
          lt_all_appl_tables    TYPE trxas_tabcontainer,
          lt_app_type_cntl_tabs TYPE trxas_apptype_tabs,
          ls_app_objects        TYPE trxas_appobj_ctab_wa,
          lt_app_objects        TYPE trxas_appobj_ctabs,
          lt_lips               TYPE zif_gtt_mia_app_types=>tt_lipsvb.

    CLEAR: et_exp_event[].

    ls_app_obj_types              = CORRESPONDING #( is_aotype ).

    ls_app_objects                = CORRESPONDING #( ls_app_obj_types ).
    ls_app_objects-appobjtype     = is_aotype-aot_type.
    ls_app_objects-appobjid       = zcl_gtt_mia_dl_tools=>get_tracking_id_dl_item(
                                      ir_lips = REF #( is_lips ) ).
    ls_app_objects-maintabref     = REF #( is_lips ).
    ls_app_objects-maintabdef     = zif_gtt_mia_app_constants=>cs_tabledef-dl_item_new.
    ls_app_objects-mastertabref   = REF #( is_likp ).
    ls_app_objects-mastertabdef   = zif_gtt_mia_app_constants=>cs_tabledef-dl_header_new.

    lt_app_objects                = VALUE #( ( ls_app_objects ) ).

    lt_lips                       = VALUE #( ( CORRESPONDING #( is_lips ) ) ).

    lt_all_appl_tables            = VALUE #( (
      tabledef    = zif_gtt_mia_app_constants=>cs_tabledef-dl_item_new
      tableref    = REF #( lt_lips )
     ) ).

    CALL FUNCTION 'ZGTT_MIA_EE_DL_ITEM'
      EXPORTING
        i_appsys                  = iv_appsys
        i_app_obj_types           = CORRESPONDING /saptrx/aotypes( is_aotype )
        i_all_appl_tables         = lt_all_appl_tables
        i_app_type_cntl_tabs      = lt_app_type_cntl_tabs
        i_app_objects             = lt_app_objects
      TABLES
        e_expeventdata            = et_exp_event
      EXCEPTIONS
        parameter_error           = 1
        exp_event_determ_error    = 2
        table_determination_error = 3
        stop_processing           = 4
        OTHERS                    = 5.

    IF sy-subrc <> 0.
      zcl_gtt_tools=>throw_exception( ).
    ENDIF.

  ENDMETHOD.
ENDCLASS.
