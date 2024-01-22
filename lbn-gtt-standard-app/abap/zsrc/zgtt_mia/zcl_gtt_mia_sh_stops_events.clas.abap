class ZCL_GTT_MIA_SH_STOPS_EVENTS definition
  public
  create private .

public section.

  types:
    BEGIN OF ts_event_info,
        appsys        TYPE /saptrx/applsystem,
        appobjtype    TYPE /saptrx/aotype,
        appobjid      TYPE /saptrx/aoid,
        language      TYPE spras,
        evt_exp_tzone TYPE /saptrx/timezone,
      END OF ts_event_info .

  class-methods GET_INSTANCE_FOR_DELIVERY
    importing
      !IV_APPOBJID type /SAPTRX/AOID
      !IV_VBELN type VBELN_VL
      !IV_POSNR type POSNR_VL default 0
      !IS_APP_OBJECTS type TRXAS_APPOBJ_CTAB_WA
      !IO_EF_PARAMETERS type ref to ZIF_GTT_EF_PARAMETERS
    returning
      value(RO_SH_STOPS_EVENTS) type ref to ZCL_GTT_MIA_SH_STOPS_EVENTS
    raising
      CX_UDM_MESSAGE .
  methods GET_PLANNED_EVENTS
    exporting
      !ET_EXP_EVENT type /SAPTRX/BAPI_TRK_EE_TAB
    raising
      CX_UDM_MESSAGE .
  PROTECTED SECTION.
private section.

  types:
    tt_tknum   TYPE STANDARD TABLE OF tknum .
  types:
    BEGIN OF ts_stops_info,
        tknum    TYPE vttk-tknum,
        stops    TYPE zif_gtt_mia_app_types=>tt_stops,
        watching TYPE zif_gtt_mia_app_types=>tt_dlv_watch_stops,
      END OF ts_stops_info .
  types:
    tt_stops_info TYPE STANDARD TABLE OF ts_stops_info .

  data MV_VBELN type VBELN_VL .
  data MV_POSNR type POSNR_VL .
  data MS_EVENT_INFO type TS_EVENT_INFO .
  data MT_STOPS_INFO type TT_STOPS_INFO .
  data MT_LIPS type ZIF_GTT_MIA_APP_TYPES=>TT_LIPSVB .
  data MT_LIKP type VA_LIKPVB_T .

  methods CONSTRUCTOR
    importing
      !IV_VBELN type VBELN_VL
      !IV_POSNR type POSNR_VL
      !IS_EVENT_INFO type TS_EVENT_INFO
      !IT_STOPS_INFO type TT_STOPS_INFO
      !IT_LIPS type ZIF_GTT_MIA_APP_TYPES=>TT_LIPSVB
      !IT_LIKP type VA_LIKPVB_T .
  class-methods GET_DELIVERY_ITEMS
    importing
      !IV_VBELN type VBELN_VL
      !IV_POSNR type POSNR_VL
      !IR_LIPS type ref to DATA
    exporting
      !ET_LIPS type ZIF_GTT_MIA_APP_TYPES=>TT_LIPSVB
    raising
      CX_UDM_MESSAGE .
  class-methods GET_EVENT_INFO
    importing
      !IV_APPOBJID type /SAPTRX/AOID
      !IO_EF_PARAMETERS type ref to ZIF_GTT_EF_PARAMETERS
    returning
      value(RS_EVENT_INFO) type TS_EVENT_INFO
    raising
      CX_UDM_MESSAGE .
  class-methods GET_SHIPMENTS_FOR_DELIVERY
    importing
      !IV_VBELN type VBELN_VL
    exporting
      !ET_TKNUM type TT_TKNUM .
  class-methods GET_STOPS_INFO_FOR_DELIVERY
    importing
      !IV_VBELN type VBELN_VL
    exporting
      !ET_STOPS_INFO type TT_STOPS_INFO .
  methods IS_POD_RELEVANT
    importing
      !IV_LOCID type CLIKE
    returning
      value(RV_RESULT) type ABAP_BOOL .
  class-methods GET_DELIVERY_HEADER
    importing
      !IV_VBELN type VBELN_VL
      !IR_LIKP type DATA
    exporting
      !ET_LIKP type VA_LIKPVB_T
    raising
      CX_UDM_MESSAGE .
ENDCLASS.



CLASS ZCL_GTT_MIA_SH_STOPS_EVENTS IMPLEMENTATION.


  METHOD CONSTRUCTOR.

    mv_vbeln      = iv_vbeln.
    ms_event_info = is_event_info.
    mt_stops_info = it_stops_info.
    mt_lips       = it_lips.
    mt_likp       = it_likp.

  ENDMETHOD.


  METHOD GET_DELIVERY_ITEMS.

    DATA: lt_vbeln TYPE RANGE OF vbeln_vl,
          lt_posnr TYPE RANGE OF posnr_vl.

    CLEAR: et_lips[].

    FIELD-SYMBOLS: <lt_lips>  TYPE zif_gtt_mia_app_types=>tt_lipsvb.

    ASSIGN ir_lips->* TO <lt_lips>.
    IF <lt_lips> IS ASSIGNED.
      IF iv_vbeln IS NOT INITIAL.
        lt_vbeln    = VALUE #( ( low = iv_vbeln option = 'EQ' sign = 'I' ) ).
      ENDIF.
      IF iv_posnr IS NOT INITIAL.
        lt_posnr    = VALUE #( ( low = iv_posnr option = 'EQ' sign = 'I' ) ).
      ENDIF.

      LOOP AT <lt_lips> ASSIGNING FIELD-SYMBOL(<ls_lips>)
        WHERE vbeln IN lt_vbeln
          AND posnr IN lt_posnr.

        APPEND <ls_lips> TO et_lips.
      ENDLOOP.
    ELSE.
      MESSAGE e002(zgtt) WITH 'LIPS' INTO DATA(lv_dummy).
      zcl_gtt_tools=>throw_exception( ).
    ENDIF.


  ENDMETHOD.


  METHOD GET_EVENT_INFO.


    rs_event_info = VALUE #(
      appsys        = io_ef_parameters->get_appsys(  )
      appobjtype    = io_ef_parameters->get_app_obj_types( )-aotype
      appobjid      = iv_appobjid
      language      = sy-langu
      evt_exp_tzone = zcl_gtt_tools=>get_system_time_zone( )
    ).

  ENDMETHOD.


  METHOD get_instance_for_delivery.

    DATA: lt_stops_info TYPE tt_stops_info,
          lt_lips       TYPE zif_gtt_mia_app_types=>tt_lipsvb,
          lt_likp       TYPE va_likpvb_t.

    DATA(ls_event_info) = get_event_info(
      iv_appobjid      = iv_appobjid
      io_ef_parameters = io_ef_parameters ).

    get_stops_info_for_delivery(
      EXPORTING
        iv_vbeln      = iv_vbeln
      IMPORTING
        et_stops_info = lt_stops_info ).

    get_delivery_items(
      EXPORTING
        iv_vbeln = iv_vbeln
        iv_posnr = iv_posnr
        ir_lips  = io_ef_parameters->get_appl_table(
                     iv_tabledef = zif_gtt_mia_app_constants=>cs_tabledef-dl_item_new )
      IMPORTING
        et_lips  = lt_lips ).

    get_delivery_header(
      EXPORTING
        iv_vbeln = iv_vbeln
        ir_likp  = is_app_objects-maintabref
      IMPORTING
        et_likp  = lt_likp ).

    ro_sh_stops_events = NEW zcl_gtt_mia_sh_stops_events(
      iv_vbeln      = iv_vbeln
      iv_posnr      = iv_posnr
      is_event_info = ls_event_info
      it_stops_info = lt_stops_info
      it_lips       = lt_lips
      it_likp       = lt_likp ).

  ENDMETHOD.


  METHOD GET_PLANNED_EVENTS.

    DATA: lt_exp_event    TYPE /saptrx/bapi_trk_ee_tab,
          lv_milestonenum TYPE /saptrx/seq_num.

    LOOP AT mt_stops_info ASSIGNING FIELD-SYMBOL(<ls_stops_info>).
      lv_milestonenum  = 1.

      LOOP AT <ls_stops_info>-watching ASSIGNING FIELD-SYMBOL(<ls_watching>)
        WHERE vbeln = mv_vbeln.

        READ TABLE <ls_stops_info>-stops ASSIGNING FIELD-SYMBOL(<ls_stops>)
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
             is_pod_relevant( iv_locid = <ls_stops>-locid ) = abap_true.

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
    ENDLOOP.

    LOOP AT lt_exp_event ASSIGNING FIELD-SYMBOL(<ls_exp_event>).
      <ls_exp_event>-appsys         = ms_event_info-appsys.         "mv_appsys.
      <ls_exp_event>-appobjtype     = ms_event_info-appobjtype.     "is_aotype-aot_type.
      <ls_exp_event>-appobjid       = ms_event_info-appobjid.       "is_likp-vbeln.
      <ls_exp_event>-language       = ms_event_info-language.       "sy-langu.
      <ls_exp_event>-evt_exp_tzone  = ms_event_info-evt_exp_tzone.  "lcl_tools=>get_system_time_zone(  ).
    ENDLOOP.

    et_exp_event  = lt_exp_event.

  ENDMETHOD.


  METHOD GET_SHIPMENTS_FOR_DELIVERY.

    DATA: ls_comwa6 TYPE vbco6,
          lt_vbfas  TYPE STANDARD TABLE OF vbfas.

    CLEAR: et_tknum[].

    ls_comwa6-vbeln   = iv_vbeln.

    CALL FUNCTION 'RV_ORDER_FLOW_INFORMATION'
      EXPORTING
        comwa         = ls_comwa6
      TABLES
        vbfa_tab      = lt_vbfas
      EXCEPTIONS
        no_vbfa       = 1
        no_vbuk_found = 2
        OTHERS        = 3.

    IF sy-subrc = 0.
      LOOP AT lt_vbfas ASSIGNING FIELD-SYMBOL(<ls_vbfas>)
        WHERE vbtyp_n = zif_gtt_mia_app_constants=>cs_vbtyp-shipment
          AND vbtyp_v = zif_gtt_mia_app_constants=>cs_vbtyp-delivery.

        APPEND <ls_vbfas>-vbeln TO et_tknum.
      ENDLOOP.

      SORT et_tknum.
      DELETE ADJACENT DUPLICATES FROM et_tknum.
    ENDIF.

  ENDMETHOD.


  METHOD GET_STOPS_INFO_FOR_DELIVERY.

    DATA: lt_tknum      TYPE tt_tknum,
          ls_stops_info TYPE ts_stops_info.

    CLEAR: et_stops_info.

    get_shipments_for_delivery(
      EXPORTING
        iv_vbeln = iv_vbeln
      IMPORTING
        et_tknum = lt_tknum ).

    LOOP AT lt_tknum ASSIGNING FIELD-SYMBOL(<lv_tknum>).
      CLEAR: ls_stops_info.

      ls_stops_info-tknum   = <lv_tknum>.

      zcl_gtt_mia_sh_tools=>get_stops_from_shipment(
        EXPORTING
          iv_tknum              = ls_stops_info-tknum
        IMPORTING
          et_stops              = ls_stops_info-stops
          et_dlv_watching_stops = ls_stops_info-watching ).

      " important for milestonenum (sequence number) calculation
      SORT ls_stops_info-watching BY stopid loccat.

      APPEND ls_stops_info TO et_stops_info.
    ENDLOOP.

  ENDMETHOD.


  METHOD is_pod_relevant.

    CLEAR: rv_result.

    READ TABLE mt_likp TRANSPORTING NO FIELDS
      WITH KEY vbeln = mv_vbeln
               vstel = iv_locid.
    IF sy-subrc = 0.
      SELECT SINGLE z_pdstk INTO rv_result
        FROM zgtt_mia_ee_rel
        WHERE appobjid  = ms_event_info-appobjid.

      rv_result   = boolc( sy-subrc = 0 AND rv_result = abap_true ).
    ENDIF.

  ENDMETHOD.


  METHOD get_delivery_header.

    FIELD-SYMBOLS:
      <ls_likp> TYPE any.
    DATA:
      ls_likpvb TYPE likpvb.

    CLEAR et_likp.

    ASSIGN ir_likp->* TO <ls_likp>.
    IF <ls_likp> IS NOT ASSIGNED.
      MESSAGE e002(zgtt) WITH 'LIKP' INTO DATA(lv_dummy).
      zcl_gtt_tools=>throw_exception( ).
    ENDIF.
    MOVE-CORRESPONDING <ls_likp> TO ls_likpvb.
    APPEND ls_likpvb TO et_likp.

  ENDMETHOD.
ENDCLASS.
