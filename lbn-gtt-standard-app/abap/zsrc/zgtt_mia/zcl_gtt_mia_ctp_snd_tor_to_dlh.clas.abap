CLASS zcl_gtt_mia_ctp_snd_tor_to_dlh DEFINITION
  PUBLIC
  INHERITING FROM zcl_gtt_mia_ctp_snd
  CREATE PRIVATE .

  PUBLIC SECTION.

    CLASS-METHODS get_instance
      RETURNING
        VALUE(ro_sender) TYPE REF TO zcl_gtt_mia_ctp_snd_tor_to_dlh
      RAISING
        cx_udm_message .
    METHODS prepare_idoc_data
      IMPORTING
        !io_dl_head_data TYPE REF TO zcl_gtt_mia_ctp_dat_tor_to_dlh
      RAISING
        cx_udm_message .
  PROTECTED SECTION.

    METHODS get_aotype_restriction_id
      REDEFINITION.
    METHODS get_object_type
      REDEFINITION.
  PRIVATE SECTION.

    CONSTANTS:
      BEGIN OF cs_mapping,
        vbeln        TYPE /saptrx/paramname VALUE 'YN_DLV_NO',
        fu_relevant  TYPE /saptrx/paramname VALUE 'YN_DL_FU_RELEVANT',
        pod_relevant TYPE /saptrx/paramname VALUE 'YN_DL_POD_RELEVANT',
      END OF cs_mapping .

    METHODS fill_idoc_appobj_ctabs
      IMPORTING
        !is_aotype    TYPE zif_gtt_mia_ctp_tor_types=>ts_aotype
        !iv_vbeln     TYPE likp-vbeln
      CHANGING
        !cs_idoc_data TYPE zif_gtt_mia_ctp_tor_types=>ts_idoc_data .
    METHODS fill_idoc_control_data
      IMPORTING
        !is_aotype    TYPE zif_gtt_mia_ctp_tor_types=>ts_aotype
        !is_delivery  TYPE zif_gtt_mia_ctp_types=>ts_delivery
      CHANGING
        !cs_idoc_data TYPE zif_gtt_mia_ctp_tor_types=>ts_idoc_data
      RAISING
        cx_udm_message .
    METHODS fill_idoc_exp_event
      IMPORTING
        !is_aotype    TYPE zif_gtt_mia_ctp_tor_types=>ts_aotype
        !is_delivery  TYPE zif_gtt_mia_ctp_types=>ts_delivery
      CHANGING
        !cs_idoc_data TYPE zif_gtt_mia_ctp_tor_types=>ts_idoc_data
      RAISING
        cx_udm_message .
    METHODS fill_idoc_tracking_id
      IMPORTING
        !is_aotype    TYPE zif_gtt_mia_ctp_tor_types=>ts_aotype
        !is_delivery  TYPE zif_gtt_mia_ctp_types=>ts_delivery
      CHANGING
        !cs_idoc_data TYPE zif_gtt_mia_ctp_tor_types=>ts_idoc_data
      RAISING
        cx_udm_message .
ENDCLASS.



CLASS zcl_gtt_mia_ctp_snd_tor_to_dlh IMPLEMENTATION.


  METHOD fill_idoc_appobj_ctabs.

    cs_idoc_data-appobj_ctabs = VALUE #( BASE cs_idoc_data-appobj_ctabs (
      trxservername = cs_idoc_data-trxserv-trx_server_id
      appobjtype    = is_aotype-aot_type
      appobjid      = |{ iv_vbeln }|
    ) ).

  ENDMETHOD.


  METHOD fill_idoc_control_data.

    DATA: lt_control TYPE /saptrx/bapi_trk_control_tab,
          lv_count   TYPE i VALUE 0.

    " PO Item key data (obligatory)
    lt_control  = VALUE #(
      (
        paramname = cs_mapping-vbeln
        value     = is_delivery-vbeln
      )
      (
        paramname = cs_mapping-fu_relevant
        value     = is_delivery-fu_relevant
      )
*      (
*        paramname = cs_mapping-pod_relevant
*        value     = is_delivery-pod_relevant
*      )
      (
        paramname = zif_gtt_mia_ef_constants=>cs_system_fields-actual_bisiness_timezone
        value     = zcl_gtt_mia_tools=>get_system_time_zone( )
      )
      (
        paramname = zif_gtt_mia_ef_constants=>cs_system_fields-actual_bisiness_datetime
        value     = |0{ sy-datum }{ sy-uzeit }|
      )
      (
        paramname = zif_gtt_mia_ef_constants=>cs_system_fields-actual_technical_timezone
        value     = zcl_gtt_mia_tools=>get_system_time_zone( )
      )
      (
        paramname = zif_gtt_mia_ef_constants=>cs_system_fields-actual_technical_datetime
        value     = |0{ sy-datum }{ sy-uzeit }|
      )
    ).

    " fill technical data into all control data records
    LOOP AT lt_control ASSIGNING FIELD-SYMBOL(<ls_control>).
      <ls_control>-appsys     = mv_appsys.
      <ls_control>-appobjtype = is_aotype-aot_type.
      <ls_control>-appobjid   = is_delivery-vbeln.
    ENDLOOP.

    cs_idoc_data-control  = VALUE #( BASE cs_idoc_data-control
                                     ( LINES OF lt_control ) ).

  ENDMETHOD.


  METHOD fill_idoc_exp_event.

    DATA: lt_exp_event TYPE /saptrx/bapi_trk_ee_tab.

    " do not retrieve planned events when DLV is not stored in DB yet
    " (this is why all the fields of LIKP are empty, except VBELN)
    IF is_delivery-likp-lfart IS NOT INITIAL AND
       is_delivery-lips[] IS NOT INITIAL.

      TRY.
          zcl_gtt_mia_ctp_tools=>get_delivery_head_planned_evt(
            EXPORTING
              iv_appsys    = mv_appsys
              is_aotype    = is_aotype
              is_likp      = CORRESPONDING #( is_delivery-likp )
              it_lips      = CORRESPONDING #( is_delivery-lips )
            IMPORTING
              et_exp_event = lt_exp_event ).

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
            <ls_exp_event>-appobjid       = zcl_gtt_mia_ctp_tools=>get_delivery_head_tracking_id(
                                              is_likp = is_delivery-likp ).
            <ls_exp_event>-language       = sy-langu.
            <ls_exp_event>-evt_exp_tzone  = zcl_gtt_mia_tools=>get_system_time_zone(  ).
          ENDLOOP.

          cs_idoc_data-exp_event = VALUE #( BASE cs_idoc_data-exp_event
                                            ( LINES OF lt_exp_event ) ).

        CATCH cx_udm_message INTO DATA(lo_udm_message).
          " do not throw exception when DLV is not stored in DB yet
          " (this is why all the fields of LIKP are empty, except VBELN)
          IF is_delivery-likp-lfart IS NOT INITIAL.
            RAISE EXCEPTION TYPE cx_udm_message
              EXPORTING
                textid   = lo_udm_message->textid
                previous = lo_udm_message->previous
                m_msgid  = lo_udm_message->m_msgid
                m_msgty  = lo_udm_message->m_msgty
                m_msgno  = lo_udm_message->m_msgno
                m_msgv1  = lo_udm_message->m_msgv1
                m_msgv2  = lo_udm_message->m_msgv2
                m_msgv3  = lo_udm_message->m_msgv3
                m_msgv4  = lo_udm_message->m_msgv4.
          ENDIF.
      ENDTRY.
    ENDIF.

  ENDMETHOD.


  METHOD fill_idoc_tracking_id.

    " Delivery Header
    cs_idoc_data-tracking_id  = VALUE #( BASE cs_idoc_data-tracking_id (
      appsys      = mv_appsys
      appobjtype  = is_aotype-aot_type
      appobjid    = is_delivery-vbeln
      trxcod      = zif_gtt_mia_app_constants=>cs_trxcod-dl_number
      trxid       = is_delivery-vbeln
      start_date  = zcl_gtt_mia_tools=>get_local_timestamp( )
      end_date    = zif_gtt_mia_ef_constants=>cv_max_end_date
      timzon      = zcl_gtt_mia_tools=>get_system_time_zone( )
    ) ).

  ENDMETHOD.


  METHOD get_aotype_restriction_id.

    rv_rst_id   = 'FU_TO_IDLH'.

  ENDMETHOD.


  METHOD get_instance.

    DATA(lt_trk_obj_type) = VALUE zif_gtt_mia_ctp_tor_types=>tt_trk_obj_type(
       ( zif_gtt_mia_ef_constants=>cs_trk_obj_type-tms_tor )
       ( zif_gtt_mia_ef_constants=>cs_trk_obj_type-esc_deliv )
    ).

    IF is_gtt_enabled( it_trk_obj_type = lt_trk_obj_type ) = abap_true.
      ro_sender  = NEW #( ).

      ro_sender->initiate( ).
    ELSE.
      MESSAGE e006(zgtt_mia) INTO DATA(lv_dummy).
      zcl_gtt_mia_tools=>throw_exception( ).
    ENDIF.

  ENDMETHOD.


  METHOD get_object_type.

    rv_objtype  = zif_gtt_mia_ef_constants=>cs_trk_obj_type-esc_deliv.

  ENDMETHOD.


  METHOD prepare_idoc_data.

    DATA: ls_idoc_data    TYPE zif_gtt_mia_ctp_tor_types=>ts_idoc_data.

    DATA(lr_dlv)   = io_dl_head_data->get_deliveries( ).

    FIELD-SYMBOLS: <lt_dlv>  TYPE zif_gtt_mia_ctp_types=>tt_delivery.

    ASSIGN lr_dlv->*  TO <lt_dlv>.

    LOOP AT mt_aotype ASSIGNING FIELD-SYMBOL(<ls_aotype>).
      CLEAR: ls_idoc_data.

      ls_idoc_data-appsys   = mv_appsys.

      fill_idoc_trxserv(
        EXPORTING
          is_aotype    = <ls_aotype>
        CHANGING
          cs_idoc_data = ls_idoc_data ).

      LOOP AT <lt_dlv> ASSIGNING FIELD-SYMBOL(<ls_dlv>).
        fill_idoc_appobj_ctabs(
          EXPORTING
            is_aotype    = <ls_aotype>
            iv_vbeln     = <ls_dlv>-vbeln
          CHANGING
            cs_idoc_data = ls_idoc_data ).

        fill_idoc_control_data(
          EXPORTING
            is_aotype    = <ls_aotype>
            is_delivery  = <ls_dlv>
          CHANGING
            cs_idoc_data = ls_idoc_data ).

        fill_idoc_exp_event(
          EXPORTING
            is_aotype    = <ls_aotype>
            is_delivery  = <ls_dlv>
          CHANGING
            cs_idoc_data = ls_idoc_data ).

        fill_idoc_tracking_id(
          EXPORTING
            is_aotype    = <ls_aotype>
            is_delivery  = <ls_dlv>
          CHANGING
            cs_idoc_data = ls_idoc_data ).
      ENDLOOP.

      IF ls_idoc_data-appobj_ctabs[] IS NOT INITIAL AND
         ls_idoc_data-control[] IS NOT INITIAL AND
         ls_idoc_data-tracking_id[] IS NOT INITIAL.
        APPEND ls_idoc_data TO mt_idoc_data.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.
ENDCLASS.
