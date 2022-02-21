class ZCL_GTT_MIA_AE_FILLER_SHH_BH definition
  public
  abstract
  create public .

public section.

  interfaces ZIF_GTT_AE_FILLER .

  methods CONSTRUCTOR
    importing
      !IO_AE_PARAMETERS type ref to ZIF_GTT_AE_PARAMETERS .
  PROTECTED SECTION.

    METHODS get_eventid
      ABSTRACT
      RETURNING
        VALUE(rv_eventid) TYPE /saptrx/ev_evtid .
    METHODS get_date_field
      ABSTRACT
      RETURNING
        VALUE(rv_field) TYPE zif_gtt_ef_types=>tv_field_name .
    METHODS get_time_field
      ABSTRACT
      RETURNING
        VALUE(rv_field) TYPE zif_gtt_ef_types=>tv_field_name .
  PRIVATE SECTION.

    TYPES:
      BEGIN OF ts_dl_item_id,
        vbeln TYPE vbeln_vl,
        posnr TYPE posnr_vl,
      END OF ts_dl_item_id .

    DATA mo_ae_parameters TYPE REF TO zif_gtt_ae_parameters .
ENDCLASS.



CLASS ZCL_GTT_MIA_AE_FILLER_SHH_BH IMPLEMENTATION.


  METHOD CONSTRUCTOR.

    mo_ae_parameters  = io_ae_parameters.

  ENDMETHOD.


  METHOD ZIF_GTT_AE_FILLER~CHECK_RELEVANCE.

    DATA: lr_vttk_old TYPE REF TO data,
          lv_date     TYPE d.

    DATA(lr_vttp) = mo_ae_parameters->get_appl_table(
                      iv_tabledef = zif_gtt_mia_app_constants=>cs_tabledef-sh_item_new ).

    lv_date       = zcl_gtt_tools=>get_field_of_structure(
                      ir_struct_data = is_events-maintabref
                      iv_field_name  = get_date_field( ) ).

    rv_result   = zif_gtt_ef_constants=>cs_condition-false.

    IF is_events-maintabdef = zif_gtt_mia_app_constants=>cs_tabledef-sh_header_new AND
       zcl_gtt_mia_sh_tools=>is_appropriate_type( ir_vttk = is_events-maintabref ) = abap_true AND
       zcl_gtt_mia_sh_tools=>is_delivery_assigned( ir_vttp = lr_vttp ) = abap_true AND
       lv_date IS NOT INITIAL.

      lr_vttk_old = COND #( WHEN is_events-update_indicator = zif_gtt_ef_constants=>cs_change_mode-insert
                              THEN NEW vttkvb( )
                              ELSE is_events-mainoldtabref ).

      rv_result   = zcl_gtt_tools=>are_fields_different(
                      ir_data1  = is_events-maintabref
                      ir_data2  = lr_vttk_old
                      it_fields = VALUE #( ( get_date_field( ) )
                                           ( get_time_field( ) ) ) ).
    ENDIF.

  ENDMETHOD.


  METHOD ZIF_GTT_AE_FILLER~GET_EVENT_DATA.

    DATA:
      lv_shptrxcod     TYPE /saptrx/trxcod.

    DATA(lv_evtcnt) = zcl_gtt_mia_sh_tools=>get_next_event_counter( ).

    lv_shptrxcod = zif_gtt_ef_constants=>cs_trxcod-sh_number.

    ct_trackingheader = VALUE #( BASE ct_trackingheader (
      language    = sy-langu
      trxid       = zcl_gtt_mia_sh_tools=>get_tracking_id_sh_header(
                      ir_vttk = is_events-maintabref )
      trxcod      = lv_shptrxcod
      evtcnt      = lv_evtcnt
      evtid       = get_eventid( )
      evtdat      = zcl_gtt_tools=>get_field_of_structure(
                        ir_struct_data = is_events-maintabref
                        iv_field_name  = get_date_field( ) )
      evttim      = zcl_gtt_tools=>get_field_of_structure(
                        ir_struct_data = is_events-maintabref
                        iv_field_name  = get_time_field( ) )
      evtzon      = zcl_gtt_tools=>get_system_time_zone( )
    ) ).

    ct_eventid_map  = VALUE #( BASE ct_eventid_map (
      eventid     = is_events-eventid
      evtcnt      = lv_evtcnt
    ) ).

  ENDMETHOD.
ENDCLASS.
