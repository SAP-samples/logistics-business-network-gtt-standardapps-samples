class ZCL_GTT_SPOF_CTP_SND_DL_TO_PO definition
  public
  inheriting from ZCL_GTT_CTP_SND
  create private .

public section.

  class-methods GET_INSTANCE
    returning
      value(RO_SENDER) type ref to ZCL_GTT_SPOF_CTP_SND_DL_TO_PO
    raising
      CX_UDM_MESSAGE .
  methods PREPARE_IDOC_DATA
    importing
      !IO_DLI_DATA type ref to ZCL_GTT_SPOF_CTP_DLI_DATA
    raising
      CX_UDM_MESSAGE .
protected section.

  methods GET_AOTYPE_RESTRICTION_ID
    redefinition .
  methods GET_OBJECT_TYPE
    redefinition .
  methods GET_EVTYPE_RESTRICTION_ID
    redefinition .
private section.

  constants:
    BEGIN OF cs_mapping,
      ebeln TYPE /saptrx/paramname VALUE 'YN_PO_NUMBER',
      ebelp TYPE /saptrx/paramname VALUE 'YN_PO_ITEM',
    END OF cs_mapping .

  methods PREPARE_IDOC_DATA_FOR_CF_EVENT
    importing
      !IO_DLI_DATA type ref to ZCL_GTT_SPOF_CTP_DLI_DATA
    raising
      CX_UDM_MESSAGE .
  methods PREPARE_IDOC_DATA_FOR_PLN_EVT
    importing
      !IO_DLI_DATA type ref to ZCL_GTT_SPOF_CTP_DLI_DATA
    raising
      CX_UDM_MESSAGE .
  methods FILL_IDOC_CF_EVENT
    importing
      !IS_EVTYPE type ZIF_GTT_CTP_TYPES=>TS_EVTYPE
      !IS_EKKO type ZIF_GTT_SPOF_APP_TYPES=>TS_UEKKO
      !IS_EKPO type ZIF_GTT_SPOF_APP_TYPES=>TS_UEKPO
      !IT_EKES type ZIF_GTT_SPOF_APP_TYPES=>TT_UEKES
    changing
      !CS_IDOC_DATA type ZIF_GTT_CTP_TYPES=>TS_IDOC_EVT_DATA
    raising
      CX_UDM_MESSAGE .
  methods FILL_IDOC_APPOBJ_CTABS
    importing
      !IS_AOTYPE type ZIF_GTT_CTP_TYPES=>TS_AOTYPE
      !IS_EKPO type ZIF_GTT_SPOF_APP_TYPES=>TS_UEKPO
    changing
      !CS_IDOC_DATA type ZIF_GTT_CTP_TYPES=>TS_IDOC_DATA
    raising
      CX_UDM_MESSAGE .
  methods FILL_IDOC_CONTROL_DATA
    importing
      !IS_AOTYPE type ZIF_GTT_CTP_TYPES=>TS_AOTYPE
      !IS_EKKO type ZIF_GTT_SPOF_APP_TYPES=>TS_UEKKO
      !IS_EKPO type ZIF_GTT_SPOF_APP_TYPES=>TS_UEKPO
      !IT_EKES type ZIF_GTT_SPOF_APP_TYPES=>TT_UEKES
    changing
      !CS_IDOC_DATA type ZIF_GTT_CTP_TYPES=>TS_IDOC_DATA
    raising
      CX_UDM_MESSAGE .
  methods FILL_IDOC_EXP_EVENT
    importing
      !IS_AOTYPE type ZIF_GTT_CTP_TYPES=>TS_AOTYPE
      !IS_EKKO type ZIF_GTT_SPOF_APP_TYPES=>TS_UEKKO
      !IS_EKPO type ZIF_GTT_SPOF_APP_TYPES=>TS_UEKPO
      !IT_EKES type ZIF_GTT_SPOF_APP_TYPES=>TT_UEKES
      !IT_EKET type ZIF_GTT_SPOF_APP_TYPES=>TT_UEKET
      !IT_LIKP type VA_LIKPVB_T
      !IT_LIPS type VA_LIPSVB_T
    changing
      !CS_IDOC_DATA type ZIF_GTT_CTP_TYPES=>TS_IDOC_DATA
    raising
      CX_UDM_MESSAGE .
  methods FILL_IDOC_TRACKING_ID
    importing
      !IS_AOTYPE type ZIF_GTT_CTP_TYPES=>TS_AOTYPE
      !IS_EKKO type ZIF_GTT_SPOF_APP_TYPES=>TS_UEKKO
      !IS_EKPO type ZIF_GTT_SPOF_APP_TYPES=>TS_UEKPO
      !IT_EKES type ZIF_GTT_SPOF_APP_TYPES=>TT_UEKES
    changing
      !CS_IDOC_DATA type ZIF_GTT_CTP_TYPES=>TS_IDOC_DATA
    raising
      CX_UDM_MESSAGE .
  methods IS_EKES_CHANGED
    importing
      !IT_EKES type ZIF_GTT_SPOF_APP_TYPES=>TT_UEKES
    returning
      value(RV_RESULT) type BOOLE_D .
  methods IS_EKES_INSERT_OR_REMOVED
    importing
      !IT_EKES type ZIF_GTT_SPOF_APP_TYPES=>TT_UEKES
    returning
      value(RV_RESULT) type BOOLE_D .
ENDCLASS.



CLASS ZCL_GTT_SPOF_CTP_SND_DL_TO_PO IMPLEMENTATION.


  METHOD fill_idoc_appobj_ctabs.
    cs_idoc_data-appobj_ctabs = VALUE #( BASE cs_idoc_data-appobj_ctabs (
      trxservername = cs_idoc_data-trxserv-trx_server_id
      appobjtype    = is_aotype-aot_type
      appobjid      = zcl_gtt_spof_po_tools=>get_tracking_id_po_itm( ir_ekpo = REF #( is_ekpo ) )
    ) ).
  ENDMETHOD.


  METHOD FILL_IDOC_CF_EVENT.

    zcl_gtt_spof_ctp_tools=>get_po_itm_conf_event_data(
      EXPORTING
        iv_appsys          = mv_appsys
        is_evtype          = is_evtype
        is_ekko            = CORRESPONDING #( is_ekko )
        is_ekpo            = CORRESPONDING #( is_ekpo )
        it_ekes            = CORRESPONDING #( it_ekes )
      IMPORTING
        et_evt_ctabs       = cs_idoc_data-evt_ctabs
        et_eventid_map     = cs_idoc_data-eventid_map
        et_trackingheader  = cs_idoc_data-evt_header
        et_tracklocation   = cs_idoc_data-evt_locationid
        et_trackreferences = cs_idoc_data-evt_reference
        et_trackparameters = cs_idoc_data-evt_parameters
    ).

  ENDMETHOD.


  METHOD fill_idoc_control_data.

    DATA: lt_control    TYPE /saptrx/bapi_trk_control_tab .

    lt_control  = VALUE #(
      (
        paramname = cs_mapping-ebeln
        value     = zcl_gtt_spof_po_tools=>get_formated_po_number(
                      ir_ekko = REF #( is_ekpo ) )
      )
      (
        paramname = cs_mapping-ebelp
        value     = zcl_gtt_spof_po_tools=>get_formated_po_item_number(
                      ir_ekpo = REF #( is_ekpo ) )
      )
      (
        paramname = zif_gtt_ef_constants=>cs_system_fields-actual_bisiness_timezone
        value     = zcl_gtt_tools=>get_system_time_zone( )
      )
      (
        paramname = zif_gtt_ef_constants=>cs_system_fields-actual_bisiness_datetime
        value     = |0{ sy-datum }{ sy-uzeit }|
      )
      (
        paramname = zif_gtt_ef_constants=>cs_system_fields-actual_technical_timezone
        value     = zcl_gtt_tools=>get_system_time_zone( )
      )
      (
        paramname = zif_gtt_ef_constants=>cs_system_fields-actual_technical_datetime
        value     = |0{ sy-datum }{ sy-uzeit }|
      )
      (
        paramname = zif_gtt_ef_constants=>cs_system_fields-reported_by
        value     = sy-uname
      )
    ).

    " fill technical data into all control data records
    LOOP AT lt_control ASSIGNING FIELD-SYMBOL(<ls_control>).
      <ls_control>-appsys     = mv_appsys.
      <ls_control>-appobjtype = is_aotype-aot_type.
      <ls_control>-appobjid = zcl_gtt_spof_po_tools=>get_tracking_id_po_itm( ir_ekpo = REF #( is_ekpo ) ).
    ENDLOOP.

    cs_idoc_data-control  = VALUE #( BASE cs_idoc_data-control
                                     ( LINES OF lt_control ) ).

  ENDMETHOD.


  METHOD fill_idoc_exp_event.

    DATA: lt_exp_event      TYPE /saptrx/bapi_trk_ee_tab.

    zcl_gtt_spof_ctp_tools=>get_po_itm_planned_evt(
      EXPORTING
        iv_appsys    = mv_appsys
        is_aotype    = is_aotype
        is_ekko      = is_ekko
        is_ekpo      = is_ekpo
        it_ekes      = it_ekes
        it_eket      = it_eket
        it_likp      = it_likp
        it_lips      = it_lips
      IMPORTING
        et_exp_event = lt_exp_event
    ).

    IF lt_exp_event[] IS INITIAL.
      lt_exp_event = VALUE #( (
          milestone         = ''
          locid2            = ''
          loctype           = ''
          locid1            = ''
          evt_exp_datetime  = '000000000000000'
          evt_exp_tzone     = ''
      ) ).
    ENDIF.

    LOOP AT lt_exp_event ASSIGNING FIELD-SYMBOL(<ls_exp_event>).
      <ls_exp_event>-appsys         = mv_appsys.
      <ls_exp_event>-appobjtype     = is_aotype-aot_type.
      <ls_exp_event>-appobjid       = zcl_gtt_spof_po_tools=>get_tracking_id_po_itm( ir_ekpo = REF #( is_ekpo ) ).
      <ls_exp_event>-language       = sy-langu.
      IF <ls_exp_event>-evt_exp_tzone IS INITIAL.
        <ls_exp_event>-evt_exp_tzone  = zcl_gtt_tools=>get_system_time_zone(  ).
      ENDIF.
    ENDLOOP.

    cs_idoc_data-exp_event = VALUE #( BASE cs_idoc_data-exp_event
                                      ( LINES OF lt_exp_event ) ).

  ENDMETHOD.


  METHOD fill_idoc_tracking_id.

    cs_idoc_data-tracking_id    = VALUE #( BASE cs_idoc_data-tracking_id (
      appsys      = mv_appsys
      appobjtype  = is_aotype-aot_type
      appobjid    = zcl_gtt_spof_po_tools=>get_tracking_id_po_itm( ir_ekpo = REF #( is_ekpo ) )
      trxcod      = zif_gtt_ef_constants=>cs_trxcod-po_position
      trxid       = zcl_gtt_spof_po_tools=>get_tracking_id_po_itm( ir_ekpo = REF #( is_ekpo ) )
      timzon      = zcl_gtt_tools=>get_system_time_zone( )
    ) ).

  ENDMETHOD.


  METHOD get_aotype_restriction_id.

    rv_rst_id   = 'DL_TO_POIT'.
  ENDMETHOD.


  METHOD GET_EVTYPE_RESTRICTION_ID.

    rv_rst_id   = 'DL_TO_POIT'.

  ENDMETHOD.


  METHOD GET_INSTANCE.

    DATA(lt_trk_obj_type) = VALUE zif_gtt_ctp_types=>tt_trk_obj_type(
       ( zif_gtt_ef_constants=>cs_trk_obj_type-esc_purord )
       ( zif_gtt_ef_constants=>cs_trk_obj_type-esc_deliv )
    ).

    IF is_gtt_enabled( it_trk_obj_type = lt_trk_obj_type ) = abap_true.
      ro_sender  = NEW #( ).
      ro_sender->initiate( ).
    ELSE.
      MESSAGE e006(zgtt) INTO DATA(lv_dummy).
      zcl_gtt_tools=>throw_exception( ).
    ENDIF.

  ENDMETHOD.


  METHOD GET_OBJECT_TYPE.

    rv_objtype  = zif_gtt_ef_constants=>cs_trk_obj_type-esc_purord.

  ENDMETHOD.


  METHOD IS_EKES_CHANGED.

    rv_result = abap_false.

    LOOP AT it_ekes TRANSPORTING NO FIELDS WHERE kz = zif_gtt_ef_constants=>cs_change_mode-insert or
                                                 kz = zif_gtt_ef_constants=>cs_change_mode-update or
                                                 kz = zif_gtt_ef_constants=>cs_change_mode-delete .
      rv_result = abap_true.
      exit.
    ENDLOOP.

  ENDMETHOD.


  METHOD is_ekes_insert_or_removed.
    rv_result = abap_false.

    LOOP AT it_ekes TRANSPORTING NO FIELDS WHERE kz = zif_gtt_ef_constants=>cs_change_mode-insert OR
                                                 kz = zif_gtt_ef_constants=>cs_change_mode-delete .
      rv_result = abap_true.
      EXIT.
    ENDLOOP.

  ENDMETHOD.


  METHOD prepare_idoc_data.

    prepare_idoc_data_for_cf_event( io_dli_data = io_dli_data ).

    prepare_idoc_data_for_pln_evt( io_dli_data = io_dli_data ).

  ENDMETHOD.


  METHOD prepare_idoc_data_for_cf_event.
    DATA: ls_idoc_data TYPE zif_gtt_ctp_types=>ts_idoc_evt_data,
          lt_ekes      TYPE zif_gtt_spof_app_types=>tt_uekes,
          ls_ekko      TYPE zif_gtt_spof_app_types=>ts_uekko.
    FIELD-SYMBOLS: <lt_ekko> TYPE zif_gtt_spof_app_types=>tt_uekko,
                   <lt_ekpo> TYPE zif_gtt_spof_app_types=>tt_uekpo,
                   <lt_ekes> TYPE zif_gtt_spof_app_types=>tt_uekes.

    DATA: lv_evtcnt TYPE /saptrx/evtcnt VALUE 1.

    io_dli_data->get_related_po_data(
      IMPORTING
        rr_ekko = DATA(lr_ekko)
        rr_ekpo = DATA(lr_ekpo)
        rr_ekes = DATA(lr_ekes)
    ).

    ASSIGN lr_ekko->* TO <lt_ekko>.
    ASSIGN lr_ekpo->* TO <lt_ekpo>.
    ASSIGN lr_ekes->* TO <lt_ekes>.

    LOOP AT <lt_ekpo> ASSIGNING FIELD-SYMBOL(<ls_ekpo>).
      CLEAR: lt_ekes, ls_ekko.
      LOOP AT <lt_ekes> ASSIGNING FIELD-SYMBOL(<ls_ekes>) WHERE ebeln = <ls_ekpo>-ebeln
                                                            AND ebelp = <ls_ekpo>-ebelp.
        lt_ekes = VALUE #( BASE lt_ekes ( <ls_ekes> ) ).
      ENDLOOP.

      LOOP AT <lt_ekko> INTO ls_ekko WHERE ebeln = <ls_ekpo>-ebeln.
        EXIT.
      ENDLOOP.
      IF is_ekes_changed( it_ekes = lt_ekes ) = abap_true.
        LOOP AT mt_evtype ASSIGNING FIELD-SYMBOL(<ls_evtype>).
          CLEAR: ls_idoc_data.
          <ls_evtype>-evtcnt = lv_evtcnt.
          fill_evt_idoc_trxserv(
            EXPORTING
              is_evtype    = <ls_evtype>
            CHANGING
              cs_idoc_data = ls_idoc_data
          ).
          fill_idoc_cf_event(
            EXPORTING
              is_evtype    = <ls_evtype>
              is_ekko      = ls_ekko
              is_ekpo      = <ls_ekpo>
              it_ekes      = lt_ekes
            CHANGING
              cs_idoc_data = ls_idoc_data
          ).

          IF ls_idoc_data-eventid_map IS NOT INITIAL AND
              ls_idoc_data-evt_parameters IS NOT INITIAL AND
              ls_idoc_data-evt_header IS NOT INITIAL.
            APPEND ls_idoc_data TO mt_idoc_evt_data.
            lv_evtcnt = lv_evtcnt + 1.
          ENDIF.
        ENDLOOP.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.


  METHOD prepare_idoc_data_for_pln_evt.
    DATA: ls_idoc_data TYPE zif_gtt_ctp_types=>ts_idoc_data,
          lt_ekes      TYPE zif_gtt_spof_app_types=>tt_uekes,
          lt_eket      TYPE zif_gtt_spof_app_types=>tt_ueket,
          ls_ekko      TYPE zif_gtt_spof_app_types=>ts_uekko.
    FIELD-SYMBOLS: <lt_ekko> TYPE zif_gtt_spof_app_types=>tt_uekko,
                   <lt_ekpo> TYPE zif_gtt_spof_app_types=>tt_uekpo,
                   <lt_ekes> TYPE zif_gtt_spof_app_types=>tt_uekes,
                   <lt_eket> TYPE zif_gtt_spof_app_types=>tt_ueket,
                   <lt_likp> TYPE va_likpvb_t,
                   <lt_lips> TYPE va_lipsvb_t.

    DATA: lv_evtcnt TYPE /saptrx/evtcnt VALUE 1.

    io_dli_data->get_related_po_data(
      IMPORTING
        rr_ekko = DATA(lr_ekko)
        rr_ekpo = DATA(lr_ekpo)
        rr_ekes = DATA(lr_ekes)
        rr_eket = DATA(lr_eket)
        rr_likp = DATA(lr_likp)
        rr_lips = DATA(lr_lips)
    ).

    ASSIGN lr_ekko->* TO <lt_ekko>.
    ASSIGN lr_ekpo->* TO <lt_ekpo>.
    ASSIGN lr_ekes->* TO <lt_ekes>.
    ASSIGN lr_eket->* TO <lt_eket>.
    ASSIGN lr_likp->* TO <lt_likp>.
    ASSIGN lr_lips->* TO <lt_lips>.

    LOOP AT <lt_ekpo> ASSIGNING FIELD-SYMBOL(<ls_ekpo>).
      CLEAR: lt_ekes, ls_ekko, lt_eket.
      LOOP AT <lt_ekes> ASSIGNING FIELD-SYMBOL(<ls_ekes>) WHERE ebeln = <ls_ekpo>-ebeln
                                                            AND ebelp = <ls_ekpo>-ebelp.
        lt_ekes = VALUE #( BASE lt_ekes ( <ls_ekes> ) ).
      ENDLOOP.

      LOOP AT <lt_eket> ASSIGNING FIELD-SYMBOL(<ls_eket>) WHERE ebeln = <ls_ekpo>-ebeln
                                                            AND ebelp = <ls_ekpo>-ebelp.
        lt_eket = VALUE #( BASE lt_eket ( <ls_eket> ) ).
      ENDLOOP.

      LOOP AT <lt_ekko> INTO ls_ekko WHERE ebeln = <ls_ekpo>-ebeln.
        EXIT.
      ENDLOOP.
      IF is_ekes_insert_or_removed( it_ekes = lt_ekes ) = abap_true.
        LOOP AT mt_aotype ASSIGNING FIELD-SYMBOL(<ls_aotype>).
          CLEAR: ls_idoc_data.
          ls_idoc_data-appsys   = mv_appsys.
          fill_idoc_trxserv(
            EXPORTING
              is_aotype    = <ls_aotype>
            CHANGING
              cs_idoc_data = ls_idoc_data ).

          fill_idoc_appobj_ctabs(
            EXPORTING
              is_aotype    = <ls_aotype>
              is_ekpo      = <ls_ekpo>
            CHANGING
              cs_idoc_data = ls_idoc_data ).

          fill_idoc_control_data(
            EXPORTING
              is_aotype    = <ls_aotype>
              is_ekko      = ls_ekko
              is_ekpo      = <ls_ekpo>
              it_ekes      = lt_ekes
            CHANGING
              cs_idoc_data = ls_idoc_data ).

          fill_idoc_exp_event(
            EXPORTING
              is_aotype    = <ls_aotype>
              is_ekko      = ls_ekko
              is_ekpo      = <ls_ekpo>
              it_ekes      = lt_ekes
              it_eket      = lt_eket
              it_likp      = <lt_likp>
              it_lips      = <lt_lips>
            CHANGING
              cs_idoc_data = ls_idoc_data ).

          fill_idoc_tracking_id(
            EXPORTING
              is_aotype    = <ls_aotype>
              is_ekko      = ls_ekko
              is_ekpo      = <ls_ekpo>
              it_ekes      = lt_ekes
            CHANGING
              cs_idoc_data = ls_idoc_data ).

          IF ls_idoc_data-appobj_ctabs[] IS NOT INITIAL AND
           ls_idoc_data-control[] IS NOT INITIAL AND
           ls_idoc_data-tracking_id[] IS NOT INITIAL.
            APPEND ls_idoc_data TO mt_idoc_data.
          ENDIF.
        ENDLOOP.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.
ENDCLASS.
