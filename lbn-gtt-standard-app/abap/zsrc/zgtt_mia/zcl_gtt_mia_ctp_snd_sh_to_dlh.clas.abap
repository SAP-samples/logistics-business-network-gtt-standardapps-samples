class ZCL_GTT_MIA_CTP_SND_SH_TO_DLH definition
  public
  inheriting from ZCL_GTT_CTP_SND
  create private .

public section.

  types TT_TKNUM TYPE TABLE OF vttk-tknum.
  types:
    BEGIN OF ts_loc_info,
      loctype      TYPE char20,
      locid        TYPE char10,
      locaddrnum   TYPE adrnr,
      locindicator TYPE char1,
    END OF ts_loc_info .
  types:
    tt_loc_info type STANDARD TABLE OF ts_loc_info .
  types:
    BEGIN OF ts_address_info,
      locid     type char20,
      loctype   type char30,
      addr1     TYPE addr1_data,
      email     TYPE ad_smtpadr,
      telephone TYPE char50,
    END OF ts_address_info .
  types:
    tt_address_info type TABLE OF ts_address_info .

  class-methods GET_INSTANCE
    returning
      value(RO_SENDER) type ref to ZCL_GTT_MIA_CTP_SND_SH_TO_DLH
    raising
      CX_UDM_MESSAGE .
  methods PREPARE_IDOC_DATA
    importing
      !IO_SHIP_DATA type ref to ZCL_GTT_MIA_CTP_SHIPMENT_DATA
    raising
      CX_UDM_MESSAGE .
  PROTECTED SECTION.

    METHODS get_aotype_restriction_id
        REDEFINITION .
    METHODS get_object_type
        REDEFINITION .
    METHODS get_evtype_restriction_id
        REDEFINITION .
private section.

  constants:
    BEGIN OF cs_mapping,
        vbeln                 TYPE /saptrx/paramname VALUE 'YN_DL_DELEVERY',
        shp_count             TYPE /saptrx/paramname VALUE 'YN_SHP_LINE_COUNT',
        shp_tknum             TYPE /saptrx/paramname VALUE 'YN_SHP_NO',
        shp_fstop             TYPE /saptrx/paramname VALUE 'YN_SHP_FIRST_STOP',
        shp_lstop             TYPE /saptrx/paramname VALUE 'YN_SHP_LAST_STOP',
        shp_lstop_rec_loc     TYPE /saptrx/paramname VALUE 'YN_SHP_LAST_STOP_REC_LOC',
        shp_lstop_rec_loc_typ TYPE /saptrx/paramname VALUE 'YN_SHP_LAST_STOP_REC_LOC_TYP',
        pod_relevant          TYPE /saptrx/paramname VALUE 'YN_DL_POD_RELEVANT',
        otl_locid             TYPE /saptrx/paramname VALUE 'GTT_OTL_LOCID',
        otl_loctype           TYPE /saptrx/paramname VALUE 'GTT_OTL_LOCTYPE',
        otl_timezone          TYPE /saptrx/paramname VALUE 'GTT_OTL_TIMEZONE',
        otl_longitude         TYPE /saptrx/paramname VALUE 'GTT_OTL_LONGITUDE',
        otl_latitude          TYPE /saptrx/paramname VALUE 'GTT_OTL_LATITUDE',
        otl_unlocode          TYPE /saptrx/paramname VALUE 'GTT_OTL_UNLOCODE',
        otl_iata_code         TYPE /saptrx/paramname VALUE 'GTT_OTL_IATA_CODE',
        otl_description       TYPE /saptrx/paramname VALUE 'GTT_OTL_DESCRIPTION',
        otl_country_code      TYPE /saptrx/paramname VALUE 'GTT_OTL_COUNTRY_CODE',
        otl_city_name         TYPE /saptrx/paramname VALUE 'GTT_OTL_CITY_NAME',
        otl_region_code       TYPE /saptrx/paramname VALUE 'GTT_OTL_REGION_CODE',
        otl_house_number      TYPE /saptrx/paramname VALUE 'GTT_OTL_HOUSE_NUMBER',
        otl_street_name       TYPE /saptrx/paramname VALUE 'GTT_OTL_STREET_NAME',
        otl_postal_code       TYPE /saptrx/paramname VALUE 'GTT_OTL_POSTAL_CODE',
        otl_email_address     TYPE /saptrx/paramname VALUE 'GTT_OTL_EMAIL_ADDRESS',
        otl_phone_number      TYPE /saptrx/paramname VALUE 'GTT_OTL_PHONE_NUMBER',
      END OF cs_mapping .

  methods FILL_IDOC_APPOBJ_CTABS
    importing
      !IS_AOTYPE type ZIF_GTT_CTP_TYPES=>TS_AOTYPE
      !IS_LIKP type ZCL_GTT_MIA_CTP_SHIPMENT_DATA=>TS_LIKPEX
    changing
      !CS_IDOC_DATA type ZIF_GTT_CTP_TYPES=>TS_IDOC_DATA
    raising
      CX_UDM_MESSAGE .
  methods FILL_IDOC_CONTROL_DATA
    importing
      !IS_AOTYPE type ZIF_GTT_CTP_TYPES=>TS_AOTYPE
      !IS_SHIP type ZCL_GTT_MIA_CTP_SHIPMENT_DATA=>TS_SHIPMENT_MERGE
      !IS_LIKP type ZCL_GTT_MIA_CTP_SHIPMENT_DATA=>TS_LIKPEX
      !IS_STOPS type ZCL_GTT_MIA_CTP_SHIPMENT_DATA=>TS_STOPS
    changing
      !CS_IDOC_DATA type ZIF_GTT_CTP_TYPES=>TS_IDOC_DATA
    raising
      CX_UDM_MESSAGE .
  methods FILL_IDOC_EXP_EVENT
    importing
      !IS_AOTYPE type ZIF_GTT_CTP_TYPES=>TS_AOTYPE
      !IS_SHIP type ZCL_GTT_MIA_CTP_SHIPMENT_DATA=>TS_SHIPMENT_MERGE
      !IS_LIKP type ZCL_GTT_MIA_CTP_SHIPMENT_DATA=>TS_LIKPEX
      !IS_STOPS type ZCL_GTT_MIA_CTP_SHIPMENT_DATA=>TS_STOPS
    changing
      !CS_IDOC_DATA type ZIF_GTT_CTP_TYPES=>TS_IDOC_DATA
    raising
      CX_UDM_MESSAGE .
  methods FILL_IDOC_TRACKING_ID
    importing
      !IS_AOTYPE type ZIF_GTT_CTP_TYPES=>TS_AOTYPE
      !IS_SHIP type ZCL_GTT_MIA_CTP_SHIPMENT_DATA=>TS_SHIPMENT_MERGE
      !IS_LIKP type ZCL_GTT_MIA_CTP_SHIPMENT_DATA=>TS_LIKPEX
    changing
      !CS_IDOC_DATA type ZIF_GTT_CTP_TYPES=>TS_IDOC_DATA
    raising
      CX_UDM_MESSAGE .
  methods GET_SHIPMENT_STOP
    importing
      !IS_STOPS type ZCL_GTT_MIA_CTP_SHIPMENT_DATA=>TS_STOPS
      !IS_VBFA type ZCL_GTT_MIA_CTP_SHIPMENT_DATA=>TS_VBFAEX
      !IV_ARRIVAL type ABAP_BOOL
    exporting
      !ES_STOP type ZIF_GTT_MIA_APP_TYPES=>TS_STOPS
    returning
      value(RV_STOPID_TXT) type ZIF_GTT_MIA_APP_TYPES=>TV_STOPID
    raising
      CX_UDM_MESSAGE .
  methods IS_POD_RELEVANT_DELIVERY
    importing
      !IS_SHIP type ZCL_GTT_MIA_CTP_SHIPMENT_DATA=>TS_SHIPMENT_MERGE
      !IS_LIKP type ZCL_GTT_MIA_CTP_SHIPMENT_DATA=>TS_LIKPEX
      !IT_STOPS type ZIF_GTT_MIA_APP_TYPES=>TT_STOPS
    returning
      value(RV_RESULT) type ZIF_GTT_EF_TYPES=>TV_CONDITION
    raising
      CX_UDM_MESSAGE .
  methods IS_POD_RELEVANT_STOP
    importing
      !IS_SHIP type ZCL_GTT_MIA_CTP_SHIPMENT_DATA=>TS_SHIPMENT_MERGE
      !IS_LIKP type ZCL_GTT_MIA_CTP_SHIPMENT_DATA=>TS_LIKPEX
      !IS_STOPS type ZIF_GTT_MIA_APP_TYPES=>TS_STOPS
    returning
      value(RV_RESULT) type ABAP_BOOL
    raising
      CX_UDM_MESSAGE .
  methods FILL_ONE_TIME_LOCATION
    importing
      !IV_VBELN type VBELN_VL
      !IT_TKNUM type TT_TKNUM
      !IT_VTTK type ZCL_GTT_MIA_CTP_SHIPMENT_DATA=>TT_VTTKVB_SRT
      !IT_VTTS type ZCL_GTT_MIA_CTP_SHIPMENT_DATA=>TT_VTTSVB_SRT
    exporting
      !ET_CONTROL_DATA type /SAPTRX/BAPI_TRK_CONTROL_TAB .
  methods PREPARE_CURRENT_LOC_DATA
    importing
      !IT_TKNUM type TT_TKNUM
      !IT_VTTKVB type ZCL_GTT_MIA_CTP_SHIPMENT_DATA=>TT_VTTKVB_SRT
      !IT_VTTSVB type ZCL_GTT_MIA_CTP_SHIPMENT_DATA=>TT_VTTSVB_SRT
    exporting
      !ET_ADDRESS_INFO type TT_ADDRESS_INFO .
  methods PREPARE_RELEVANT_LOC_DATA
    importing
      !IT_TKNUM type TT_TKNUM
      !IT_VTTKVB type ZCL_GTT_MIA_CTP_SHIPMENT_DATA=>TT_VTTKVB_SRT
    exporting
      !ET_ADDRESS_INFO type TT_ADDRESS_INFO .
  methods PREPARE_DELIVERY_LOC_DATA
    importing
      !IV_VBELN type VBELN_VL
    exporting
      !ET_ADDRESS_INFO type TT_ADDRESS_INFO .
  methods MERGE_LOCATION_DATA
    importing
      !IT_ADDR_INFO_CUR type TT_ADDRESS_INFO
      !IT_ADDR_INFO_REL type TT_ADDRESS_INFO
      !IT_ADDR_INFO_DLV type TT_ADDRESS_INFO
    exporting
      !ET_ADDR_INFO_ALL type TT_ADDRESS_INFO .
  methods PREPARE_CONTROL_DATA
    importing
      !IT_ADDR_INFO type TT_ADDRESS_INFO
    exporting
      !ET_CONTROL_DATA type /SAPTRX/BAPI_TRK_CONTROL_TAB .
  methods ADD_PLANNED_SOURCE_ARRIVAL
    importing
      !IT_EXPEVENTDATA type /SAPTRX/BAPI_TRK_EE_TAB
      !IS_SHIP type ZCL_GTT_MIA_CTP_SHIPMENT_DATA=>TS_SHIPMENT_MERGE
    exporting
      !ET_EXPEVENTDATA type /SAPTRX/BAPI_TRK_EE_TAB
    raising
      CX_UDM_MESSAGE .
ENDCLASS.



CLASS ZCL_GTT_MIA_CTP_SND_SH_TO_DLH IMPLEMENTATION.


  METHOD fill_idoc_appobj_ctabs.

    cs_idoc_data-appobj_ctabs = VALUE #( BASE cs_idoc_data-appobj_ctabs (
      trxservername = cs_idoc_data-trxserv-trx_server_id
      appobjtype    = is_aotype-aot_type
      appobjid      = zcl_gtt_mia_dl_tools=>get_tracking_id_dl_header(
                        ir_likp = REF #( is_likp ) )
    ) ).

  ENDMETHOD.


  METHOD fill_idoc_control_data.

    DATA: lt_control TYPE /saptrx/bapi_trk_control_tab,
          lv_count   TYPE i VALUE 0,
          lt_tknum   TYPE tt_tknum.

    " DLV Head data (obligatory)
    lt_control  = VALUE #(
      (
        paramname = cs_mapping-vbeln
        value     = zcl_gtt_mia_dl_tools=>get_formated_dlv_number(
                      ir_likp = REF #( is_likp ) )
      )
      (
        paramname = cs_mapping-pod_relevant
        value     = is_pod_relevant_delivery(
                      is_ship  = is_ship
                      is_likp  = is_likp
                      it_stops = is_stops-stops )
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

    LOOP AT is_ship-likp\vbfa[ is_likp ] ASSIGNING FIELD-SYMBOL(<ls_vbfa>).
      ADD 1 TO lv_count.

      get_shipment_stop(
        EXPORTING
          is_stops   = is_stops
          is_vbfa    = <ls_vbfa>
          iv_arrival = abap_true
        IMPORTING
          es_stop    = DATA(ls_lstop) ).

      lt_control  = VALUE #( BASE lt_control
        (
          paramindex = lv_count
          paramname  = cs_mapping-shp_count
          value      = |{ lv_count }|
        )
        (
          paramindex = lv_count
          paramname  = cs_mapping-shp_tknum
          value      = zcl_gtt_mia_sh_tools=>get_formated_sh_number(
                         ir_vttk = NEW vttk( tknum = <ls_vbfa>-vbeln ) )
        )
        (
          paramindex = lv_count
          paramname  = cs_mapping-shp_fstop
          value      = get_shipment_stop(
                         EXPORTING
                           is_stops   = is_stops
                           is_vbfa    = <ls_vbfa>
                           iv_arrival = abap_false )
        )
        (
          paramindex = lv_count
          paramname  = cs_mapping-shp_lstop
          value      = ls_lstop-stopid_txt
        )
        (
          paramindex = lv_count
          paramname  = cs_mapping-shp_lstop_rec_loc
          value      = zcl_gtt_tools=>get_pretty_location_id(
                         iv_locid   = ls_lstop-locid
                         iv_loctype = ls_lstop-loctype )
        )
        (
          paramindex = lv_count
          paramname  = cs_mapping-shp_lstop_rec_loc_typ
          value      = ls_lstop-loctype
        )
      ).
*     Note down the shipment number
      APPEND <ls_vbfa>-vbeln TO lt_tknum.
    ENDLOOP.

    IF sy-subrc <> 0.
      lt_control  = VALUE #( BASE lt_control (
          paramindex = '1'
          paramname  = cs_mapping-shp_count
          value      = ''
      ) ).
    ENDIF.

*   Support one time location
    fill_one_time_location(
      EXPORTING
        iv_vbeln        = is_likp-vbeln
        it_tknum        = lt_tknum
        it_vttk         = is_ship-vttk
        it_vtts         = is_ship-vtts
      IMPORTING
        et_control_data = DATA(lt_location_data) ).
    APPEND LINES OF lt_location_data TO lt_control.
    CLEAR lt_location_data.

    " fill technical data into all control data records
    LOOP AT lt_control ASSIGNING FIELD-SYMBOL(<ls_control>).
      <ls_control>-appsys     = mv_appsys.
      <ls_control>-appobjtype = is_aotype-aot_type.
      <ls_control>-appobjid = zcl_gtt_mia_dl_tools=>get_tracking_id_dl_header(
        ir_likp = REF #( is_likp ) ).
    ENDLOOP.

    cs_idoc_data-control  = VALUE #( BASE cs_idoc_data-control
                                     ( LINES OF lt_control ) ).

  ENDMETHOD.


  METHOD fill_idoc_exp_event.

    DATA: lt_exp_event     TYPE /saptrx/bapi_trk_ee_tab,
          lt_exp_event_dlv TYPE /saptrx/bapi_trk_ee_tab,
          lv_milestonenum  TYPE /saptrx/seq_num VALUE 1,
          lv_tknum         TYPE tknum.

    zcl_gtt_mia_ctp_tools=>get_delivery_head_planned_evt(
      EXPORTING
        iv_appsys    = mv_appsys
        is_aotype    = is_aotype
        is_likp      = CORRESPONDING #( is_likp )
        it_lips      = CORRESPONDING #( is_ship-lips )
      IMPORTING
        et_exp_event = lt_exp_event_dlv ).

    LOOP AT lt_exp_event_dlv TRANSPORTING NO FIELDS
      WHERE ( milestone = zif_gtt_ef_constants=>cs_milestone-sh_arrival OR
              milestone = zif_gtt_ef_constants=>cs_milestone-sh_departure OR
              milestone = zif_gtt_ef_constants=>cs_milestone-sh_pod ).
      DELETE lt_exp_event_dlv.
    ENDLOOP.

    LOOP AT is_stops-watching ASSIGNING FIELD-SYMBOL(<ls_watching>)
      WHERE vbeln = is_likp-vbeln.

      IF lv_tknum <> <ls_watching>-stopid(10).
        lv_tknum        = <ls_watching>-stopid(10).
        lv_milestonenum = 1.
      ENDIF.

      READ TABLE is_stops-stops ASSIGNING FIELD-SYMBOL(<ls_stops>)
        WITH KEY stopid = <ls_watching>-stopid
                 loccat = <ls_watching>-loccat.

      IF sy-subrc = 0.
        " Departure / Arrival
        lt_exp_event = VALUE #( BASE lt_exp_event (
            milestone         = COND #( WHEN <ls_watching>-loccat = zif_gtt_mia_app_constants=>cs_loccat-departure
                                          THEN zif_gtt_ef_constants=>cs_milestone-sh_departure
                                          ELSE zif_gtt_ef_constants=>cs_milestone-sh_arrival )
            locid2            = <ls_stops>-stopid_txt
            loctype           = <ls_stops>-loctype
            locid1            = zcl_gtt_tools=>get_pretty_location_id(
                                  iv_locid   = <ls_stops>-locid
                                  iv_loctype = <ls_stops>-loctype )
            evt_exp_datetime  = <ls_stops>-pln_evt_datetime
            evt_exp_tzone     = <ls_stops>-pln_evt_timezone
            milestonenum      = lv_milestonenum
        ) ).
        ADD 1 TO lv_milestonenum.

        " POD
        IF <ls_stops>-loccat  = zif_gtt_mia_app_constants=>cs_loccat-arrival AND
           <ls_stops>-loctype = zif_gtt_ef_constants=>cs_loc_types-shippingpoint AND
           is_pod_relevant_stop( is_ship  = is_ship
                                 is_likp  = is_likp
                                 is_stops = <ls_stops> ) = abap_true.

          lt_exp_event = VALUE #( BASE lt_exp_event (
              milestone         = zif_gtt_ef_constants=>cs_milestone-sh_pod
              locid2            = <ls_stops>-stopid_txt
              loctype           = <ls_stops>-loctype
              locid1            = zcl_gtt_tools=>get_pretty_location_id(
                                    iv_locid   = <ls_stops>-locid
                                    iv_loctype = <ls_stops>-loctype )
              evt_exp_datetime  = <ls_stops>-pln_evt_datetime
              evt_exp_tzone     = <ls_stops>-pln_evt_timezone
              milestonenum      = lv_milestonenum
          ) ).
          ADD 1 TO lv_milestonenum.
        ENDIF.
      ELSE.
        MESSAGE e005(zgtt)
          WITH |{ <ls_watching>-stopid }{ <ls_watching>-loccat }| 'STOPS'
          INTO DATA(lv_dummy).
        zcl_gtt_tools=>throw_exception( ).
      ENDIF.
    ENDLOOP.

    " fill sequence number in DLV events
    lv_milestonenum = zcl_gtt_tools=>get_next_sequence_id(
      it_expeventdata = lt_exp_event ).

    LOOP AT lt_exp_event_dlv ASSIGNING FIELD-SYMBOL(<ls_exp_event_dlv>).
      <ls_exp_event_dlv>-milestonenum   = lv_milestonenum.
      ADD 1 TO lv_milestonenum.
    ENDLOOP.

    lt_exp_event    = VALUE #( BASE lt_exp_event
                                ( LINES OF lt_exp_event_dlv ) ).

    add_planned_source_arrival(
      EXPORTING
        it_expeventdata = lt_exp_event
        is_ship         = is_ship
      IMPORTING
        et_expeventdata = DATA(lt_expeventdata) ).
    APPEND LINES OF lt_expeventdata TO lt_exp_event.

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
      <ls_exp_event>-appobjid = zcl_gtt_mia_dl_tools=>get_tracking_id_dl_header(
        ir_likp = REF #( is_likp ) ).
      <ls_exp_event>-language       = sy-langu.
      IF <ls_exp_event>-evt_exp_tzone IS INITIAL.
        <ls_exp_event>-evt_exp_tzone  = zcl_gtt_tools=>get_system_time_zone(  ).
      ENDIF.
    ENDLOOP.

    cs_idoc_data-exp_event = VALUE #( BASE cs_idoc_data-exp_event
                                      ( LINES OF lt_exp_event ) ).

  ENDMETHOD.


  METHOD fill_idoc_tracking_id.

    "another tip is that: for tracking ID type 'SHIPMENT_ORDER' of delivery header,
    "and for tracking ID type 'RESOURCE' of shipment header,
    "DO NOT enable START DATE and END DATE
    DATA:
      lt_tracking_id TYPE /saptrx/bapi_trk_trkid_tab,
      lv_shptrxcod   TYPE /saptrx/trxcod,
      lv_dlvhdtrxcod TYPE /saptrx/trxcod.

    lv_shptrxcod = zif_gtt_ef_constants=>cs_trxcod-sh_number.
    lv_dlvhdtrxcod = zif_gtt_ef_constants=>cs_trxcod-dl_number.

    " Delivery Header
    lt_tracking_id    = VALUE #( (
      trxcod      = lv_dlvhdtrxcod
      trxid       = zcl_gtt_mia_dl_tools=>get_tracking_id_dl_header(
                      ir_likp = REF #( is_likp ) )
      timzon      = zcl_gtt_tools=>get_system_time_zone( )
    ) ).

    " Shipment
    LOOP AT is_ship-likp\likp_dlt[ is_likp ] ASSIGNING FIELD-SYMBOL(<ls_likp_dlt>).
      IF <ls_likp_dlt>-updkz = zif_gtt_ef_constants=>cs_change_mode-insert OR
         <ls_likp_dlt>-updkz = zif_gtt_ef_constants=>cs_change_mode-delete.
        lt_tracking_id    = VALUE #( BASE lt_tracking_id (
          trxcod      = lv_shptrxcod
          trxid       = zcl_gtt_mia_sh_tools=>get_tracking_id_sh_header(
                          ir_vttk = REF #( <ls_likp_dlt> ) )              "<ls_likp_dlt>-tknum
          action      = COND #( WHEN <ls_likp_dlt>-updkz = zif_gtt_ef_constants=>cs_change_mode-delete
                                  THEN zif_gtt_ef_constants=>cs_change_mode-delete )
        ) ).
      ENDIF.
    ENDLOOP.

    " Fill general data
    LOOP AT lt_tracking_id ASSIGNING FIELD-SYMBOL(<ls_tracking_id>).
      <ls_tracking_id>-appsys     = mv_appsys.
      <ls_tracking_id>-appobjtype = is_aotype-aot_type.
      <ls_tracking_id>-appobjid = zcl_gtt_mia_dl_tools=>get_tracking_id_dl_header(
        ir_likp = REF #( is_likp ) ).
    ENDLOOP.

    cs_idoc_data-tracking_id = VALUE #( BASE cs_idoc_data-tracking_id
                                        ( LINES OF lt_tracking_id ) ).

  ENDMETHOD.


  METHOD get_aotype_restriction_id.

    rv_rst_id   = 'SH_TO_IDLH'.

  ENDMETHOD.


  METHOD get_evtype_restriction_id.
    CLEAR: rv_rst_id .
  ENDMETHOD.


  METHOD get_instance.

    DATA(lt_trk_obj_type) = VALUE zif_gtt_ctp_types=>tt_trk_obj_type(
       ( zif_gtt_ef_constants=>cs_trk_obj_type-esc_shipmt )
       ( zif_gtt_ef_constants=>cs_trk_obj_type-esc_deliv )
    ).

    IF is_gtt_enabled( it_trk_obj_type = lt_trk_obj_type ) = abap_true.
      ro_sender  = NEW #( ).

      ro_sender->initiate( ).
    ENDIF.

  ENDMETHOD.


  METHOD get_object_type.

    rv_objtype  = zif_gtt_ef_constants=>cs_trk_obj_type-esc_deliv.

  ENDMETHOD.


  METHOD get_shipment_stop.
    DATA: lv_stopid TYPE zif_gtt_mia_app_types=>tv_stopid.

    CLEAR: es_stop.

    LOOP AT is_stops-watching ASSIGNING FIELD-SYMBOL(<ls_watching>)
      WHERE vbeln       = is_vbfa-vbelv
        AND stopid(10)  = is_vbfa-vbeln.

      rv_stopid_txt = <ls_watching>-stopid_txt.
      lv_stopid     = <ls_watching>-stopid.

      IF iv_arrival = abap_false.
        EXIT.
      ENDIF.
    ENDLOOP.

    IF lv_stopid IS NOT INITIAL AND
       es_stop IS REQUESTED.
      READ TABLE is_stops-stops
        INTO es_stop
        WITH KEY stopid = lv_stopid
                 loccat = COND #( WHEN iv_arrival = abap_true
                                    THEN zif_gtt_mia_app_constants=>cs_loccat-arrival
                                    ELSE zif_gtt_mia_app_constants=>cs_loccat-departure ).
      IF sy-subrc <> 0.
        MESSAGE e011(zgtt) WITH lv_stopid is_stops-tknum INTO DATA(lv_dummy).
        zcl_gtt_tools=>throw_exception( ).
      ENDIF.
    ENDIF.

  ENDMETHOD.


  METHOD is_pod_relevant_delivery.

    DATA: lt_vstel TYPE RANGE OF likp-vstel.

    rv_result   = zif_gtt_ef_constants=>cs_condition-false.

    " prepare list of POD relevant shipping point
    LOOP AT is_ship-likp ASSIGNING FIELD-SYMBOL(<ls_likp>).
      IF lt_vstel IS INITIAL OR
         <ls_likp>-vstel NOT IN lt_vstel.

        READ TABLE is_ship-ee_rel ASSIGNING FIELD-SYMBOL(<ls_ee_rel>)
          WITH TABLE KEY appobjid = zcl_gtt_mia_dl_tools=>get_tracking_id_dl_header(
                                      ir_likp = REF #( <ls_likp> ) ).

        IF sy-subrc = 0 AND
           <ls_ee_rel>-z_pdstk = abap_true.

          lt_vstel  = VALUE #( BASE lt_vstel (
            low       = <ls_likp>-vstel
            option    = 'EQ'
            sign      = 'I'
          ) ).
        ENDIF.
      ENDIF.
    ENDLOOP.

    " check whether shipment has any stops with POD Relevant shipping point
    IF lt_vstel[] IS NOT INITIAL.
      LOOP AT it_stops ASSIGNING FIELD-SYMBOL(<ls_stops>)
        WHERE locid    IN lt_vstel
          AND loccat   = zif_gtt_mia_app_constants=>cs_loccat-arrival
          AND loctype  = zif_gtt_ef_constants=>cs_loc_types-shippingpoint.

        rv_result   = zif_gtt_ef_constants=>cs_condition-true.
        EXIT.
      ENDLOOP.
    ENDIF.

  ENDMETHOD.


  METHOD is_pod_relevant_stop.

    CLEAR: rv_result.

    LOOP AT is_ship-likp ASSIGNING FIELD-SYMBOL(<ls_likp>).
      IF is_stops-locid   = <ls_likp>-vstel AND
         is_stops-loccat  = zif_gtt_mia_app_constants=>cs_loccat-arrival AND
         is_stops-loctype = zif_gtt_ef_constants=>cs_loc_types-shippingpoint.

        READ TABLE is_ship-ee_rel ASSIGNING FIELD-SYMBOL(<ls_ee_rel>)
          WITH TABLE KEY appobjid = zcl_gtt_mia_dl_tools=>get_tracking_id_dl_header(
                                      ir_likp = REF #( <ls_likp> ) ).

        IF sy-subrc = 0 AND
           <ls_ee_rel>-z_pdstk = abap_true.

          rv_result   = abap_true.
          EXIT.
        ENDIF.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.


  METHOD prepare_idoc_data.

    " prepare DLV Header list (likp or vtrlk_tab)
    " fill DLV Header
    "   control data
    "     YN_SHP_LINE_COUNT
    "     YN_SHP_NO
    "     YN_SHP_FIRST_STOP
    "     YN_SHP_LAST_STOP
    "     YN_SHP_LINE_COUNT
    "     ACTUAL_BUSINESS_TIMEZONE
    "     ACTUAL_BUSINESS_DATETIME
    "   tracking ID
    "     send DLV Header TID
    "     add/delete Shipment TID
    "   planned events
    "     DEPARTURE
    "     ARRIV_DEST
    "     POD

    DATA: ls_idoc_data    TYPE zif_gtt_ctp_types=>ts_idoc_data.

    DATA(lr_ship)   = io_ship_data->get_data( ).
    DATA(lr_stops)  = io_ship_data->get_stops( ).

    FIELD-SYMBOLS: <ls_ship>  TYPE zcl_gtt_mia_ctp_shipment_data=>ts_shipment_merge,
                   <lt_stops> TYPE zcl_gtt_mia_ctp_shipment_data=>tt_stops_srt.

    ASSIGN lr_ship->*  TO <ls_ship>.
    ASSIGN lr_stops->* TO <lt_stops>.

    LOOP AT mt_aotype ASSIGNING FIELD-SYMBOL(<ls_aotype>).
      CLEAR: ls_idoc_data.

      ls_idoc_data-appsys   = mv_appsys.

      fill_idoc_trxserv(
        EXPORTING
          is_aotype    = <ls_aotype>
        CHANGING
          cs_idoc_data = ls_idoc_data ).

      LOOP AT <ls_ship>-likp ASSIGNING FIELD-SYMBOL(<ls_likp>).
        READ TABLE <lt_stops> ASSIGNING FIELD-SYMBOL(<ls_stops>)
          WITH TABLE KEY tknum = <ls_likp>-tknum.

        IF sy-subrc = 0.
          fill_idoc_appobj_ctabs(
            EXPORTING
              is_aotype    = <ls_aotype>
              is_likp      = <ls_likp>
            CHANGING
              cs_idoc_data = ls_idoc_data ).

          fill_idoc_control_data(
            EXPORTING
              is_aotype    = <ls_aotype>
              is_ship      = <ls_ship>
              is_likp      = <ls_likp>
              is_stops     = <ls_stops>
            CHANGING
              cs_idoc_data = ls_idoc_data ).

          fill_idoc_exp_event(
            EXPORTING
              is_aotype    = <ls_aotype>
              is_ship      = <ls_ship>
              is_likp      = <ls_likp>
              is_stops     = <ls_stops>
            CHANGING
              cs_idoc_data = ls_idoc_data ).

          fill_idoc_tracking_id(
            EXPORTING
              is_aotype    = <ls_aotype>
              is_ship      = <ls_ship>
              is_likp      = <ls_likp>
            CHANGING
              cs_idoc_data = ls_idoc_data ).
        ELSE.
          MESSAGE e005(zgtt) WITH |{ <ls_likp>-tknum }| 'STOPS'
            INTO DATA(lv_dummy).
          zcl_gtt_tools=>throw_exception( ).
        ENDIF.

      ENDLOOP.

      IF ls_idoc_data-appobj_ctabs[] IS NOT INITIAL AND
         ls_idoc_data-control[] IS NOT INITIAL AND
         ls_idoc_data-tracking_id[] IS NOT INITIAL.
        APPEND ls_idoc_data TO mt_idoc_data.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.


  METHOD fill_one_time_location.

    DATA:
      lt_addr_info_rel TYPE tt_address_info,
      lt_addr_info_cur TYPE tt_address_info,
      lt_addr_info_dlv TYPE tt_address_info,
      lt_addr_info_all TYPE tt_address_info.

    CLEAR et_control_data.

*   Step 1. Get current procced shipment location information
    prepare_current_loc_data(
      EXPORTING
        it_tknum        = it_tknum
        it_vttkvb       = it_vttk
        it_vttsvb       = it_vtts
      IMPORTING
        et_address_info = lt_addr_info_cur ).

*   Step 2. Get relevant shipment location information
    prepare_relevant_loc_data(
      EXPORTING
        it_tknum        = it_tknum
        it_vttkvb       = it_vttk
      IMPORTING
        et_address_info = lt_addr_info_rel ).

*   Step 3. Get delivery location information
    prepare_delivery_loc_data(
      EXPORTING
        iv_vbeln        = iv_vbeln
      IMPORTING
        et_address_info = lt_addr_info_dlv ).

*   Step 4. Merge the location information
    merge_location_data(
      EXPORTING
        it_addr_info_cur = lt_addr_info_cur
        it_addr_info_rel = lt_addr_info_rel
        it_addr_info_dlv = lt_addr_info_dlv
      IMPORTING
        et_addr_info_all = lt_addr_info_all ).

*   Step 5. Generate the location control data
    prepare_control_data(
      EXPORTING
        it_addr_info    = lt_addr_info_all
      IMPORTING
        et_control_data = et_control_data ).

  ENDMETHOD.


  METHOD merge_location_data.

    DATA:
      lt_addr_info_cur TYPE tt_address_info,
      lt_addr_info_rel TYPE tt_address_info,
      lt_addr_info_dlv TYPE tt_address_info.

    CLEAR et_addr_info_all.

    lt_addr_info_cur = it_addr_info_cur.
    lt_addr_info_rel = it_addr_info_rel.
    lt_addr_info_dlv = it_addr_info_dlv.

    LOOP AT lt_addr_info_cur INTO DATA(ls_loc_info_curr).
      READ TABLE lt_addr_info_rel INTO DATA(ls_addr_info_rel)
        WITH KEY locid   = ls_loc_info_curr-locid
                 loctype = ls_loc_info_curr-loctype.
      IF sy-subrc = 0.
        DELETE lt_addr_info_rel WHERE locid   = ls_loc_info_curr-locid
                                  AND loctype = ls_loc_info_curr-loctype.
      ENDIF.

      READ TABLE lt_addr_info_dlv INTO DATA(ls_addr_info_dlv)
        WITH KEY locid   = ls_loc_info_curr-locid
                 loctype = ls_loc_info_curr-loctype.
      IF sy-subrc = 0.
        DELETE lt_addr_info_dlv WHERE locid   = ls_loc_info_curr-locid
                                  AND loctype = ls_loc_info_curr-loctype.
      ENDIF.
    ENDLOOP.

    LOOP AT lt_addr_info_rel INTO ls_addr_info_rel.
      CLEAR ls_addr_info_dlv.
      READ TABLE lt_addr_info_dlv INTO ls_addr_info_dlv
        WITH KEY locid   = ls_addr_info_rel-locid
                 loctype = ls_addr_info_rel-loctype.
      IF sy-subrc = 0.
        DELETE lt_addr_info_dlv WHERE locid   = ls_addr_info_rel-locid
                                  AND loctype = ls_addr_info_rel-loctype.
      ENDIF.
    ENDLOOP.

    APPEND LINES OF lt_addr_info_cur TO et_addr_info_all.
    APPEND LINES OF lt_addr_info_rel TO et_addr_info_all.
    APPEND LINES OF lt_addr_info_dlv TO et_addr_info_all.

  ENDMETHOD.


  METHOD prepare_control_data.

    DATA:
      lv_paramindex   TYPE /saptrx/indexcounter,
      ls_control_data TYPE /saptrx/control_data.

    CLEAR:et_control_data.

    LOOP AT it_addr_info INTO DATA(ls_addr_info).

      lv_paramindex = lv_paramindex + 1.

*     Location ID
      ls_control_data-paramindex = lv_paramindex.
      ls_control_data-paramname = cs_mapping-otl_locid.
      ls_control_data-value = ls_addr_info-locid.
      IF ls_addr_info-loctype = zif_gtt_ef_constants=>cs_loc_types-businesspartner.
        ls_control_data-value = |{ ls_addr_info-locid ALPHA = OUT }|.
      ENDIF.
      APPEND ls_control_data TO et_control_data.

*     Location Type
      ls_control_data-paramindex = lv_paramindex.
      ls_control_data-paramname = cs_mapping-otl_loctype.
      ls_control_data-value = ls_addr_info-loctype.
      APPEND ls_control_data TO et_control_data.

*     Time Zone
      ls_control_data-paramindex = lv_paramindex.
      ls_control_data-paramname = cs_mapping-otl_timezone.
      ls_control_data-value = ls_addr_info-addr1-time_zone.
      APPEND ls_control_data TO et_control_data.

*     Description
      ls_control_data-paramindex = lv_paramindex.
      ls_control_data-paramname = cs_mapping-otl_description.
      ls_control_data-value = ls_addr_info-addr1-name1.
      APPEND ls_control_data TO et_control_data.

*     Country Code
      ls_control_data-paramindex = lv_paramindex.
      ls_control_data-paramname = cs_mapping-otl_country_code.
      ls_control_data-value = ls_addr_info-addr1-country.
      APPEND ls_control_data TO et_control_data.

*     City Name
      ls_control_data-paramindex = lv_paramindex.
      ls_control_data-paramname = cs_mapping-otl_city_name.
      ls_control_data-value = ls_addr_info-addr1-city1.
      APPEND ls_control_data TO et_control_data.

*     Region Code
      ls_control_data-paramindex = lv_paramindex.
      ls_control_data-paramname = cs_mapping-otl_region_code.
      ls_control_data-value = ls_addr_info-addr1-region.
      APPEND ls_control_data TO et_control_data.

*     House Number
      ls_control_data-paramindex = lv_paramindex.
      ls_control_data-paramname = cs_mapping-otl_house_number.
      ls_control_data-value = ls_addr_info-addr1-house_num1.
      APPEND ls_control_data TO et_control_data.

*     Street Name
      ls_control_data-paramindex = lv_paramindex.
      ls_control_data-paramname = cs_mapping-otl_street_name.
      ls_control_data-value = ls_addr_info-addr1-street.
      APPEND ls_control_data TO et_control_data.

*     Postal Code
      ls_control_data-paramindex = lv_paramindex.
      ls_control_data-paramname = cs_mapping-otl_postal_code.
      ls_control_data-value = ls_addr_info-addr1-post_code1.
      APPEND ls_control_data TO et_control_data.

*     Email Address
      ls_control_data-paramindex = lv_paramindex.
      ls_control_data-paramname = cs_mapping-otl_email_address.
      ls_control_data-value = ls_addr_info-email.
      APPEND ls_control_data TO et_control_data.

*     Phone Number
      ls_control_data-paramindex = lv_paramindex.
      ls_control_data-paramname = cs_mapping-otl_phone_number.
      ls_control_data-value = ls_addr_info-telephone.
      APPEND ls_control_data TO et_control_data.

    ENDLOOP.

    IF et_control_data IS INITIAL.
      ls_control_data-paramindex = 1.
      ls_control_data-paramname = cs_mapping-otl_locid.
      ls_control_data-value = ''.
      APPEND ls_control_data TO et_control_data.
    ENDIF.

  ENDMETHOD.


  METHOD prepare_current_loc_data.

    DATA:
      lt_loc_info_tmp  TYPE tt_loc_info,
      lt_loc_info_curr TYPE tt_loc_info,
      ls_address_info  TYPE ts_address_info,
      lt_addr_info_cur TYPE tt_address_info,
      ls_loc_addr      TYPE addr1_data,
      lv_loc_email     TYPE ad_smtpadr,
      lv_loc_tel       TYPE char50,
      lt_vttsvb        TYPE vttsvb_tab,
      ls_loc_addr_tmp  TYPE addr1_data,
      lv_loc_email_tmp TYPE ad_smtpadr,
      lv_loc_tel_tmp   TYPE char50.

    CLEAR et_address_info.

    APPEND LINES OF it_vttsvb TO lt_vttsvb.

    LOOP AT it_tknum INTO DATA(ls_tknum).
      CLEAR:
        lt_loc_info_tmp.
      READ TABLE it_vttkvb TRANSPORTING NO FIELDS
        WITH KEY tknum = ls_tknum.
      IF sy-subrc = 0.
*       Current procced shipment
        zcl_gtt_tools=>get_location_info(
          EXPORTING
            iv_tknum    = ls_tknum
            it_vttsvb   = lt_vttsvb
          IMPORTING
            et_loc_info = lt_loc_info_tmp ).
        APPEND LINES OF lt_loc_info_tmp TO lt_loc_info_curr.
      ENDIF.
    ENDLOOP.

    LOOP AT lt_loc_info_curr INTO DATA(ls_loc_info_curr).
      CLEAR:
        ls_loc_addr,
        lv_loc_email,
        lv_loc_tel,
        ls_loc_addr_tmp,
        lv_loc_email_tmp,
        lv_loc_tel_tmp.

      IF ls_loc_info_curr-locaddrnum CN '0 ' AND ls_loc_info_curr-locindicator CA zif_gtt_ef_constants=>shp_addr_ind_man_all.
        zcl_gtt_tools=>get_address_from_memory(
          EXPORTING
            iv_addrnumber = ls_loc_info_curr-locaddrnum
          IMPORTING
            es_addr       = ls_loc_addr
            ev_email      = lv_loc_email
            ev_telephone  = lv_loc_tel ).

        zcl_gtt_tools=>get_address_detail_by_loctype(
          EXPORTING
            iv_loctype   = ls_loc_info_curr-loctype
            iv_locid     = ls_loc_info_curr-locid
          IMPORTING
            es_addr      = ls_loc_addr_tmp
            ev_email     = lv_loc_email_tmp
            ev_telephone = lv_loc_tel_tmp ).

        IF ls_loc_addr <> ls_loc_addr_tmp
          OR lv_loc_email <> lv_loc_email_tmp
          OR lv_loc_tel <> lv_loc_tel_tmp.
          ls_address_info-locid = ls_loc_info_curr-locid.
          ls_address_info-loctype = ls_loc_info_curr-loctype.
          ls_address_info-addr1 = ls_loc_addr.
          ls_address_info-email = lv_loc_email.
          ls_address_info-telephone = lv_loc_tel.
          APPEND ls_address_info TO et_address_info.
        ENDIF.
        CLEAR:
          ls_address_info.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.


  METHOD prepare_delivery_loc_data.

    DATA:
      lv_posnr        TYPE vbpa-posnr VALUE '000000',
      ls_vbpa         TYPE vbpavb,
      ls_address_info TYPE ts_address_info,
      ls_loc_addr     TYPE addr1_data,
      lv_loc_email    TYPE ad_smtpadr,
      lv_loc_tel      TYPE char50.

    CLEAR: et_address_info.

    CALL FUNCTION 'SD_VBPA_SINGLE_READ'
      EXPORTING
        i_vbeln          = iv_vbeln
        i_posnr          = lv_posnr
        i_parvw          = zif_gtt_mia_app_constants=>cs_parvw-supplier
      IMPORTING
        e_vbpavb         = ls_vbpa
      EXCEPTIONS
        record_not_found = 1
        OTHERS           = 2.

    IF sy-subrc = 0.
      IF ls_vbpa-adrnr CN '0 ' AND ls_vbpa-adrda CA zif_gtt_ef_constants=>vbpa_addr_ind_man_all.
        zcl_gtt_tools=>get_address_from_db(
          EXPORTING
            iv_addrnumber = ls_vbpa-adrnr
          IMPORTING
            es_addr       = ls_loc_addr
            ev_email      = lv_loc_email
            ev_telephone  = lv_loc_tel ).

        ls_address_info-locid = ls_vbpa-lifnr.
        ls_address_info-loctype = zif_gtt_ef_constants=>cs_loc_types-businesspartner.
        ls_address_info-addr1 = ls_loc_addr.
        ls_address_info-email = lv_loc_email.
        ls_address_info-telephone = lv_loc_tel.
        APPEND ls_address_info TO et_address_info.
        CLEAR:
          ls_address_info.
      ENDIF.
    ENDIF.

  ENDMETHOD.


  METHOD prepare_relevant_loc_data.

    DATA:
      lt_relevant_shp  TYPE tt_tknum,
      lt_tknum_range   TYPE STANDARD TABLE OF range_c10,
      lt_vttsvb        TYPE vttsvb_tab,
      lt_loc_info      TYPE tt_loc_info,
      ls_address_info  TYPE ts_address_info,
      ls_loc_addr      TYPE addr1_data,
      lv_loc_email     TYPE ad_smtpadr,
      lv_loc_tel       TYPE char50,
      ls_loc_addr_tmp  TYPE addr1_data,
      lv_loc_email_tmp TYPE ad_smtpadr,
      lv_loc_tel_tmp   TYPE char50.

    CLEAR et_address_info.

    LOOP AT it_tknum INTO DATA(ls_tknum).
      READ TABLE it_vttkvb TRANSPORTING NO FIELDS
        WITH KEY tknum = ls_tknum.
      IF sy-subrc <> 0.
        APPEND ls_tknum TO lt_relevant_shp.
      ENDIF.
    ENDLOOP.

    LOOP AT lt_relevant_shp INTO ls_tknum.
      lt_tknum_range = VALUE #( BASE lt_tknum_range (
        sign   = 'I'
        option = 'EQ'
        low    = ls_tknum ) ).
    ENDLOOP.

    CHECK lt_tknum_range IS NOT INITIAL.
    CALL FUNCTION 'ST_STAGES_READ'
      TABLES
        i_tknum_range = lt_tknum_range
        c_xvttsvb     = lt_vttsvb
      EXCEPTIONS
        no_shipments  = 1
        OTHERS        = 2.

    zcl_gtt_tools=>get_location_info(
      EXPORTING
        it_vttsvb   = lt_vttsvb
      IMPORTING
        et_loc_info = lt_loc_info ).

    LOOP AT lt_loc_info INTO DATA(ls_loc_info).
      CLEAR:
        ls_loc_addr,
        lv_loc_email,
        lv_loc_tel,
        ls_loc_addr_tmp,
        lv_loc_email_tmp,
        lv_loc_tel_tmp.

      IF ls_loc_info-locaddrnum CN '0 ' AND ls_loc_info-locindicator CA zif_gtt_ef_constants=>shp_addr_ind_man_all.
        zcl_gtt_tools=>get_address_from_db(
          EXPORTING
            iv_addrnumber = ls_loc_info-locaddrnum
          IMPORTING
            es_addr       = ls_loc_addr
            ev_email      = lv_loc_email
            ev_telephone  = lv_loc_tel ).

        zcl_gtt_tools=>get_address_detail_by_loctype(
          EXPORTING
            iv_loctype   = ls_loc_info-loctype
            iv_locid     = ls_loc_info-locid
          IMPORTING
            es_addr      = ls_loc_addr_tmp
            ev_email     = lv_loc_email_tmp
            ev_telephone = lv_loc_tel_tmp ).

        IF ls_loc_addr <> ls_loc_addr_tmp
          OR lv_loc_email <> lv_loc_email_tmp
          OR lv_loc_tel <> lv_loc_tel_tmp.
          ls_address_info-locid = ls_loc_info-locid.
          ls_address_info-loctype = ls_loc_info-loctype.
          ls_address_info-addr1 = ls_loc_addr.
          ls_address_info-email = lv_loc_email.
          ls_address_info-telephone = lv_loc_tel.
          APPEND ls_address_info TO et_address_info.
        ENDIF.
        CLEAR:
          ls_address_info.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.


  METHOD add_planned_source_arrival.

    DATA:
      lv_length       TYPE i,
      lv_seq          TYPE char04,
      lv_tknum        TYPE vttk-tknum,
      lv_ltl_flag     TYPE flag,
      ls_eventdata    TYPE /saptrx/bapi_trk_exp_events,
      lt_vttk         TYPE vttkvb_tab,
      lt_vttp         TYPE vttpvb_tab,
      lv_exp_datetime TYPE /saptrx/event_exp_datetime.

    CLEAR et_expeventdata.

    lt_vttk = CORRESPONDING #( is_ship-vttk ).
    lt_vttp = CORRESPONDING #( is_ship-vttp ).

    LOOP AT it_expeventdata INTO DATA(ls_expeventdata)
      WHERE milestone = zif_gtt_ef_constants=>cs_milestone-sh_departure.
      CLEAR:
        lv_length,
        lv_tknum,
        lv_seq.

      lv_length = strlen( ls_expeventdata-locid2 ) - 4.
      IF lv_length >= 0.
        lv_tknum = ls_expeventdata-locid2+0(lv_length).
        lv_tknum = |{ lv_tknum ALPHA = IN }|.
        lv_seq = ls_expeventdata-locid2+lv_length(4).
        zcl_gtt_tools=>check_ltl_shipment(
          EXPORTING
            iv_tknum    = lv_tknum
            it_vttk     = lt_vttk
            it_vttp     = lt_vttp
          IMPORTING
            ev_ltl_flag = lv_ltl_flag
            es_vttk     = DATA(ls_vttk) ).

        IF lv_ltl_flag = abap_true AND lv_seq = '0001'. "only for source location of the shipment
          lv_exp_datetime = zcl_gtt_tools=>get_local_timestamp(
            iv_date = ls_vttk-dpreg     "Planned date of check-in
            iv_time = ls_vttk-upreg ).  "Planned check-in time
          ls_eventdata = ls_expeventdata.
          ls_eventdata-milestonenum = 0.
          ls_eventdata-milestone = zif_gtt_ef_constants=>cs_milestone-sh_arrival.
          ls_eventdata-evt_exp_datetime = lv_exp_datetime.
          ls_eventdata-evt_exp_tzone = zcl_gtt_tools=>get_system_time_zone( ).
          APPEND ls_eventdata TO et_expeventdata.
          CLEAR ls_eventdata.
        ENDIF.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.
ENDCLASS.
