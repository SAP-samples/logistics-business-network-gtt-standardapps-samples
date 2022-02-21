class ZCL_GTT_SPOF_CTP_TOOLS definition
  public
  create public .

public section.

  class-methods GET_PO_ITM_CONF_EVENT_DATA
    importing
      !IV_APPSYS type LOGSYS
      !IS_EVTYPE type ZIF_GTT_CTP_TYPES=>TS_EVTYPE optional
      !IS_EKKO type ZIF_GTT_SPOF_APP_TYPES=>TS_UEKKO
      !IS_EKPO type ZIF_GTT_SPOF_APP_TYPES=>TS_UEKPO
      !IT_EKES type ZIF_GTT_SPOF_APP_TYPES=>TT_UEKES
    exporting
      !ET_EVT_CTABS type TRXAS_EVT_CTABS
      !ET_EVENTID_MAP type TRXAS_EVTID_EVTCNT_MAP
      !ET_TRACKINGHEADER type ZIF_GTT_AE_TYPES=>TT_TRACKINGHEADER
      !ET_TRACKLOCATION type ZIF_GTT_AE_TYPES=>TT_TRACKLOCATION
      !ET_TRACKREFERENCES type ZIF_GTT_AE_TYPES=>TT_TRACKREFERENCES
      !ET_TRACKPARAMETERS type ZIF_GTT_AE_TYPES=>TT_TRACKPARAMETERS
    raising
      CX_UDM_MESSAGE .
  class-methods GET_PO_ITM_PLANNED_EVT
    importing
      !IV_APPSYS type LOGSYS
      !IS_AOTYPE type ZIF_GTT_CTP_TYPES=>TS_AOTYPE
      !IS_EKKO type ZIF_GTT_SPOF_APP_TYPES=>TS_UEKKO
      !IS_EKPO type ZIF_GTT_SPOF_APP_TYPES=>TS_UEKPO
      !IT_EKES type ZIF_GTT_SPOF_APP_TYPES=>TT_UEKES
      !IT_EKET type ZIF_GTT_SPOF_APP_TYPES=>TT_UEKET
      !IT_LIKP type VA_LIKPVB_T
      !IT_LIPS type VA_LIPSVB_T
    exporting
      !ET_EXP_EVENT type /SAPTRX/BAPI_TRK_EE_TAB
    raising
      CX_UDM_MESSAGE .
  PROTECTED SECTION.
private section.
ENDCLASS.



CLASS ZCL_GTT_SPOF_CTP_TOOLS IMPLEMENTATION.


  METHOD get_po_itm_conf_event_data.

    DATA: ls_app_obj_types        TYPE /saptrx/aotypes,
          lt_all_appl_tables      TYPE trxas_tabcontainer,
          lt_event_type_cntl_tabs TYPE trxas_eventtype_tabs,
          lt_events               TYPE trxas_evt_ctabs,
          ls_event                TYPE trxas_evt_ctab_wa.
    DATA: ls_evtype               TYPE /saptrx/evtypes.
    CLEAR: et_eventid_map[],et_trackingheader[],
           et_tracklocation[],et_trackreferences[],
           et_trackparameters[],et_evt_ctabs[].

    ls_event-maintabref     = REF #( is_ekpo ).
    ls_event-maintabdef     = zif_gtt_spof_app_constants=>cs_tabledef-po_item_new.
    ls_event-mastertabref   = REF #( is_ekko ).
    ls_event-mastertabdef   = zif_gtt_spof_app_constants=>cs_tabledef-po_header_new.
    ls_event-eventid        = is_evtype-evtcnt.
    ls_event-trxservername  = is_evtype-trxservername.
    ls_event-eventtype      = is_evtype-evtype.
    lt_events               = VALUE #( ( ls_event ) ).

    et_evt_ctabs            = VALUE #( ( ls_event ) ).

    lt_all_appl_tables            = VALUE #( (
      tabledef    = zif_gtt_spof_app_constants=>cs_tabledef-po_vend_conf_new
      tableref    = REF #( it_ekes )
     ) ).

    SELECT SINGLE * FROM /saptrx/evtypes INTO ls_evtype
      WHERE trk_obj_type = zif_gtt_ef_constants=>cs_trk_obj_type-esc_purord
            AND evtype = is_evtype-evtype.

    CALL FUNCTION 'ZGTT_SPOF_EE_PO_ITM_CONF'
      EXPORTING
        i_appsys               = iv_appsys
        i_event_type           = ls_evtype
        i_all_appl_tables      = lt_all_appl_tables
        i_event_type_cntl_tabs = lt_event_type_cntl_tabs
        i_events               = lt_events
      TABLES
        ct_trackingheader      = et_trackingheader
        ct_tracklocation       = et_tracklocation
        ct_trackreferences     = et_trackreferences
        ct_trackparameters     = et_trackparameters
      CHANGING
        c_eventid_map          = et_eventid_map
      EXCEPTIONS
        parameter_error        = 1
        event_data_error       = 2
        stop_processing        = 3
        OTHERS                 = 4.

    IF sy-subrc <> 0.
      zcl_gtt_tools=>throw_exception( ).
    ENDIF.

  ENDMETHOD.


  METHOD get_po_itm_planned_evt.
    DATA: ls_app_obj_types      TYPE /saptrx/aotypes,
          lt_all_appl_tables    TYPE trxas_tabcontainer,
          lt_app_type_cntl_tabs TYPE trxas_apptype_tabs,
          ls_app_objects        TYPE trxas_appobj_ctab_wa,
          lt_app_objects        TYPE trxas_appobj_ctabs.

    CLEAR: et_exp_event[].

    ls_app_obj_types              = CORRESPONDING #( is_aotype ).

    ls_app_objects                = CORRESPONDING #( ls_app_obj_types ).
    ls_app_objects-appobjtype     = is_aotype-aot_type.
    ls_app_objects-appobjid       = zcl_gtt_spof_po_tools=>get_tracking_id_po_itm( ir_ekpo = REF #( is_ekpo ) ).
    ls_app_objects-maintabref     = REF #( is_ekpo ).
    ls_app_objects-maintabdef     = zif_gtt_spof_app_constants=>cs_tabledef-po_item_new.
    ls_app_objects-mastertabref   = REF #( is_ekko ).
    ls_app_objects-mastertabdef   = zif_gtt_spof_app_constants=>cs_tabledef-po_header_new.

    lt_app_objects                = VALUE #( ( ls_app_objects ) ).

    lt_all_appl_tables            = VALUE #(
    (
      tabledef    = zif_gtt_spof_app_constants=>cs_tabledef-po_vend_conf_new
      tableref    = REF #( it_ekes )
     )
     (
      tabledef    = zif_gtt_spof_app_constants=>cs_tabledef-po_sched_new
      tableref    = REF #( it_eket )
     )
     (
      tabledef    = zif_gtt_spof_app_constants=>cs_tabledef-dl_header_new
      tableref    = REF #( it_likp )
     )
     (
      tabledef    = zif_gtt_spof_app_constants=>cs_tabledef-dl_item_new
      tableref    = REF #( it_lips )
     ) ).

    CALL FUNCTION 'ZGTT_SPOF_EE_PO_ITM'
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
