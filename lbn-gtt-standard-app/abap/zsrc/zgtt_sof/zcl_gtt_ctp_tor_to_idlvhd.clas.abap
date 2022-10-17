class ZCL_GTT_CTP_TOR_TO_IDLVHD definition
  public
  inheriting from ZCL_GTT_CTP_TOR_TO_DL_BASE
  create public .

public section.
protected section.

  methods FILL_IDOC_EXP_EVENT
    redefinition .
  methods GET_AOTYPE_RESTRICTION_ID
    redefinition .
  methods FILL_IDOC_TRACKING_ID
    redefinition .
private section.
ENDCLASS.



CLASS ZCL_GTT_CTP_TOR_TO_IDLVHD IMPLEMENTATION.


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
            <ls_exp_event>-appobjid = zcl_gtt_mia_dl_tools=>get_tracking_id_dl_header(
              ir_likp = REF #( is_delivery ) ).
            <ls_exp_event>-language       = sy-langu.
            IF <ls_exp_event>-evt_exp_tzone IS INITIAL.
              <ls_exp_event>-evt_exp_tzone  = zcl_gtt_tools=>get_system_time_zone( ).
            ENDIF.
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

    DATA:
      lv_dlvhdtrxcod     TYPE /saptrx/trxcod.

    lv_dlvhdtrxcod = zif_gtt_ef_constants=>cs_trxcod-dl_number.

    " Delivery Header
    cs_idoc_data-tracking_id  = VALUE #( BASE cs_idoc_data-tracking_id (
      appsys      = mv_appsys
      appobjtype  = is_aotype-aot_type
      appobjid    = |{ is_delivery-vbeln ALPHA = OUT }|
      trxcod      = lv_dlvhdtrxcod
      trxid       = |{ is_delivery-vbeln ALPHA = OUT }|

    ) ).

  ENDMETHOD.


  method GET_AOTYPE_RESTRICTION_ID.

    rv_rst_id   = 'FU_TO_IDLH'.

  endmethod.
ENDCLASS.
