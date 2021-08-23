CLASS zcl_gtt_mia_ctp_tools DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.

    CLASS-METHODS get_delivery_head_planned_evt
      IMPORTING
        !iv_appsys    TYPE logsys
        !is_aotype    TYPE zif_gtt_mia_ctp_tor_types=>ts_aotype
        !is_likp      TYPE zif_gtt_mia_app_types=>ts_likpvb
        !it_lips      TYPE zif_gtt_mia_app_types=>tt_lipsvb
      EXPORTING
        !et_exp_event TYPE /saptrx/bapi_trk_ee_tab
      RAISING
        cx_udm_message .

    CLASS-METHODS get_delivery_item_planned_evt
      IMPORTING
        !iv_appsys    TYPE logsys
        !is_aotype    TYPE zif_gtt_mia_ctp_tor_types=>ts_aotype
        !is_likp      TYPE zif_gtt_mia_app_types=>ts_likpvb
        !is_lips      TYPE zif_gtt_mia_app_types=>ts_lipsvb
      EXPORTING
        !et_exp_event TYPE /saptrx/bapi_trk_ee_tab
      RAISING
        cx_udm_message .

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
      zcl_gtt_mia_tools=>throw_exception( ).
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
      zcl_gtt_mia_tools=>throw_exception( ).
    ENDIF.

  ENDMETHOD.

ENDCLASS.
