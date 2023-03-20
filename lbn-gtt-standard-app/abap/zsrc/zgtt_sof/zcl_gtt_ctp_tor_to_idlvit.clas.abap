class ZCL_GTT_CTP_TOR_TO_IDLVIT definition
  public
  inheriting from ZCL_GTT_CTP_TOR_TO_DL_BASE
  create public .

public section.

  methods ZIF_GTT_CTP_TOR_TO_DL~EXTRACT_DATA
    redefinition .
protected section.

  methods FILL_IDOC_APPOBJ_CTABS
    redefinition .
  methods FILL_IDOC_CONTROL_DATA
    redefinition .
  methods FILL_IDOC_EXP_EVENT
    redefinition .
  methods FILL_IDOC_TRACKING_ID
    redefinition .
  methods GET_AOTYPE_RESTRICTION_ID
    redefinition .
  methods PREPARE_IDOC_DATA
    redefinition .
private section.
ENDCLASS.



CLASS ZCL_GTT_CTP_TOR_TO_IDLVIT IMPLEMENTATION.


  METHOD fill_idoc_appobj_ctabs.

    DATA:
      lv_appobjid TYPE /saptrx/aoid.

    lv_appobjid = |{ is_delivery_item-lips-vbeln ALPHA = OUT }{ is_delivery_item-lips-posnr ALPHA = IN }|.
    CONDENSE lv_appobjid NO-GAPS.

    cs_idoc_data-appobj_ctabs = VALUE #( BASE cs_idoc_data-appobj_ctabs (
      trxservername = cs_idoc_data-trxserv-trx_server_id
      appobjtype    = is_aotype-aot_type
      appobjid      = lv_appobjid
    ) ).

  ENDMETHOD.


  METHOD fill_idoc_control_data.

    DATA:
      lt_control     TYPE /saptrx/bapi_trk_control_tab,
      lv_count       TYPE i VALUE 0,
      lv_appobjid    TYPE /saptrx/aoid,
      lt_tmp_fu_list TYPE zif_gtt_mia_ctp_types=>tt_fu_list,
      ls_fu_create   TYPE zif_gtt_sof_ctp_types=>ts_fu_list,
      ls_fu_update   TYPE zif_gtt_sof_ctp_types=>ts_fu_list,
      ls_fu_delete   TYPE zif_gtt_sof_ctp_types=>ts_fu_list,
      lt_fu_id       TYPE zif_gtt_sof_ctp_types=>tt_fu_id.

    " DL Item key data (obligatory)
    lt_control  = VALUE #(
      (
        paramname = cs_mapping-dlv_vbeln
        value     = |{ is_delivery_item-likp-vbeln ALPHA = OUT }|
      )
      (
        paramname = cs_mapping-dlv_posnr
        value     = is_delivery_item-lips-posnr
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

    " fill F.U. table
    LOOP AT is_delivery_item-fu_list ASSIGNING FIELD-SYMBOL(<ls_fu_list>).
      IF <ls_fu_list>-change_mode = /bobf/if_frw_c=>sc_modify_delete.
        CONTINUE.
      ENDIF.
      APPEND <ls_fu_list> TO lt_tmp_fu_list.
      ADD 1 TO lv_count.

      lt_control  = VALUE #( BASE lt_control
        (
          paramindex  = lv_count
          paramname   = cs_mapping-fu_lineno
          value       = zcl_gtt_tools=>get_pretty_value(
                          iv_value = lv_count )
        )
        (
          paramindex  = lv_count
          paramname   = cs_mapping-fu_freightunit
          value       = zcl_gtt_mia_tm_tools=>get_formated_tor_id(
                          ir_data = REF #( <ls_fu_list> ) )
        )
        (
          paramindex  = lv_count
          paramname   = cs_mapping-fu_itemnumber
          value       = zcl_gtt_mia_tm_tools=>get_formated_tor_item(
                          ir_data = REF #( <ls_fu_list> ) )
        )
        (
          paramindex  = lv_count
          paramname   = cs_mapping-fu_quantity
          value       = zcl_gtt_tools=>get_pretty_value(
                          iv_value = <ls_fu_list>-quantity )
        )
        (
          paramindex  = lv_count
          paramname   = cs_mapping-fu_quantityuom
          value       = zcl_gtt_tools=>get_pretty_value(
                          iv_value = <ls_fu_list>-quantityuom )
        )
        (
          paramindex  = lv_count
          paramname   = cs_mapping-fu_product_id
          value       = zcl_gtt_tools=>get_pretty_value(
                          iv_value = <ls_fu_list>-product_id )
        )
        (
          paramindex  = lv_count
          paramname   = cs_mapping-fu_product_descr
          value       = zcl_gtt_tools=>get_pretty_value(
                          iv_value = <ls_fu_list>-product_descr )
        )
        (
          paramindex  = lv_count
          paramname   = cs_mapping-fu_base_uom_val
          value       = zcl_gtt_tools=>get_pretty_value(
                          iv_value = <ls_fu_list>-base_uom_val )
        )
        (
          paramindex  = lv_count
          paramname   = cs_mapping-fu_base_uom_uni
          value       = zcl_gtt_tools=>get_pretty_value(
                          iv_value = <ls_fu_list>-base_uom_uni )
        )
        (
          paramindex  = lv_count
          paramname   = cs_mapping-fu_freightunit_logsys
          value       = mv_appsys
        )
      ).
    ENDLOOP.

    " add deletion sign in case of emtpy is_delivery_item-FU_LIST table
    IF lt_tmp_fu_list IS INITIAL.
      lt_control  = VALUE #( BASE lt_control (
          paramindex = 1
          paramname  = cs_mapping-fu_lineno
          value      = ''
      ) ).
    ENDIF.

*   Add tracking ID information
    CLEAR lv_count.
    lt_fu_id =  CORRESPONDING #( is_delivery_item-fu_list ).
    SORT lt_fu_id BY tor_id.
    DELETE ADJACENT DUPLICATES FROM lt_fu_id COMPARING tor_id.

    LOOP AT lt_fu_id  ASSIGNING FIELD-SYMBOL(<ls_fu_id>).
      ADD 1 TO lv_count.
      CLEAR:
        ls_fu_create,
        ls_fu_update,
        ls_fu_delete.

      READ TABLE is_delivery_item-fu_list INTO ls_fu_create WITH KEY tor_id = <ls_fu_id>-tor_id change_mode = /bobf/if_frw_c=>sc_modify_create.
      READ TABLE is_delivery_item-fu_list INTO ls_fu_update WITH KEY tor_id = <ls_fu_id>-tor_id change_mode = /bobf/if_frw_c=>sc_modify_update.
      READ TABLE is_delivery_item-fu_list INTO ls_fu_delete WITH KEY tor_id = <ls_fu_id>-tor_id change_mode = /bobf/if_frw_c=>sc_modify_delete.

      IF ls_fu_create IS NOT INITIAL
        AND ls_fu_update IS INITIAL
        AND ls_fu_delete IS INITIAL.

        lt_control  = VALUE #( BASE lt_control
          (
            paramindex  = lv_count
            paramname   = cs_mapping-appsys
            value       = mv_appsys
          )
          (
            paramindex  = lv_count
            paramname   = cs_mapping-trxcod
            value       = zif_gtt_sof_constants=>cs_trxcod-fu_number
          )
          (
            paramindex  = lv_count
            paramname   = cs_mapping-trxid
            value       = zcl_gtt_sof_tm_tools=>get_formated_tor_id( ir_data = REF #( <ls_fu_id> ) )
          )
        ).
      ENDIF.

      IF ls_fu_delete IS NOT INITIAL
       AND ls_fu_create IS INITIAL
       AND ls_fu_update IS INITIAL.
        lt_control  = VALUE #( BASE lt_control
          (
            paramindex  = lv_count
            paramname   = cs_mapping-appsys
            value       = mv_appsys
          )
          (
            paramindex  = lv_count
            paramname   = cs_mapping-trxcod
            value       = zif_gtt_sof_constants=>cs_trxcod-fu_number
          )
          (
            paramindex  = lv_count
            paramname   = cs_mapping-trxid
            value       = zcl_gtt_sof_tm_tools=>get_formated_tor_id( ir_data = REF #( <ls_fu_id> ) )
          )
          (
            paramindex  = lv_count
            paramname   = cs_mapping-action
            value       = /bobf/if_frw_c=>sc_modify_delete
          )
        ).
      ENDIF.
    ENDLOOP.

    " fill technical data into all control data records
    lv_appobjid = |{ is_delivery_item-lips-vbeln ALPHA = OUT }{ is_delivery_item-lips-posnr ALPHA = IN }|.
    CONDENSE lv_appobjid NO-GAPS.
    LOOP AT lt_control ASSIGNING FIELD-SYMBOL(<ls_control>).
      <ls_control>-appsys     = mv_appsys.
      <ls_control>-appobjtype = is_aotype-aot_type.
      <ls_control>-appobjid   = lv_appobjid .
    ENDLOOP.

    cs_idoc_data-control  = VALUE #( BASE cs_idoc_data-control
                                     ( LINES OF lt_control ) ).
  ENDMETHOD.


  METHOD fill_idoc_exp_event.

    DATA:
      lt_exp_event TYPE /saptrx/bapi_trk_ee_tab,
      lv_appobjid  TYPE /saptrx/aoid,
      ls_likp      TYPE likp.

    " do not retrieve planned events when DLV is not stored in DB yet
    " (this is why all the fields of LIKP are empty, except VBELN)
    IF is_dlv_item-likp-lfart IS NOT INITIAL AND
       is_dlv_item-lips-pstyv IS NOT INITIAL.

      MOVE-CORRESPONDING is_dlv_item-likp TO ls_likp.

      TRY.
          zcl_gtt_mia_ctp_tools=>get_delivery_item_planned_evt(
            EXPORTING
              iv_appsys    = mv_appsys
              is_aotype    = is_aotype
              is_likp      = ls_likp
              is_lips      = is_dlv_item-lips
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

          lv_appobjid = |{ is_dlv_item-lips-vbeln ALPHA = OUT }{ is_dlv_item-lips-posnr ALPHA = IN }|.
          CONDENSE lv_appobjid NO-GAPS.
          LOOP AT lt_exp_event ASSIGNING FIELD-SYMBOL(<ls_exp_event>).
            <ls_exp_event>-appsys         = mv_appsys.
            <ls_exp_event>-appobjtype     = is_aotype-aot_type.
            <ls_exp_event>-appobjid       = lv_appobjid.
            <ls_exp_event>-language       = sy-langu.
            IF <ls_exp_event>-evt_exp_tzone IS INITIAL.
              <ls_exp_event>-evt_exp_tzone  = zcl_gtt_tools=>get_system_time_zone(  ).
            ENDIF.
          ENDLOOP.

          cs_idoc_data-exp_event = VALUE #( BASE cs_idoc_data-exp_event
                                            ( LINES OF lt_exp_event ) ).

        CATCH cx_udm_message INTO DATA(lo_udm_message).
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
      ENDTRY.
    ENDIF.

  ENDMETHOD.


  METHOD fill_idoc_tracking_id.

    DATA:
      lv_appobjid    TYPE /saptrx/aoid,
      lv_dlvittrxcod TYPE /saptrx/trxcod,
      lv_futrxcod    TYPE /saptrx/trxcod,
      lt_tracking_id TYPE /saptrx/bapi_trk_trkid_tab,
      lt_fu_id       TYPE zif_gtt_mia_ctp_types=>tt_fu_id,
      ls_fu_create   TYPE zif_gtt_mia_ctp_types=>ts_fu_list,
      ls_fu_update   TYPE zif_gtt_mia_ctp_types=>ts_fu_list,
      ls_fu_delete   TYPE zif_gtt_mia_ctp_types=>ts_fu_list.

    lv_dlvittrxcod = zif_gtt_ef_constants=>cs_trxcod-dl_position.
    lv_futrxcod    = zif_gtt_ef_constants=>cs_trxcod-fu_number.

    " Delivery Item
    lv_appobjid = |{ is_delivery_item-lips-vbeln ALPHA = OUT }{ is_delivery_item-lips-posnr ALPHA = IN }|.
    CONDENSE lv_appobjid NO-GAPS.
    cs_idoc_data-tracking_id  = VALUE #( BASE cs_idoc_data-tracking_id (
      appsys      = mv_appsys
      appobjtype  = is_aotype-aot_type
      appobjid    = lv_appobjid
      trxcod      = lv_dlvittrxcod
      trxid       = lv_appobjid

    ) ).

  ENDMETHOD.


  METHOD get_aotype_restriction_id.

    rv_rst_id   = 'FU_TO_IDLI'.

  ENDMETHOD.


  METHOD prepare_idoc_data.

    DATA: ls_idoc_data    TYPE zif_gtt_ctp_types=>ts_idoc_data.

    LOOP AT mt_aotype ASSIGNING FIELD-SYMBOL(<ls_aotype>).
      CLEAR: ls_idoc_data.

      ls_idoc_data-appsys   = mv_appsys.

      fill_idoc_trxserv(
        EXPORTING
          is_aotype    = <ls_aotype>
        CHANGING
          cs_idoc_data = ls_idoc_data ).

      LOOP AT mt_delivery_item ASSIGNING FIELD-SYMBOL(<ls_dlv_item>).

        " Skip for new created delivery item.
        IF <ls_dlv_item>-lips-pstyv IS INITIAL.
          CONTINUE.
        ENDIF.
        fill_idoc_appobj_ctabs(
          EXPORTING
            is_aotype        = <ls_aotype>
            is_delivery_item = <ls_dlv_item>
          CHANGING
            cs_idoc_data     = ls_idoc_data ).

        fill_idoc_control_data(
          EXPORTING
            is_aotype        = <ls_aotype>
            is_delivery_item = <ls_dlv_item>
          CHANGING
            cs_idoc_data     = ls_idoc_data ).

        fill_idoc_exp_event(
          EXPORTING
            is_aotype    = <ls_aotype>
            is_dlv_item  = <ls_dlv_item>
          CHANGING
            cs_idoc_data = ls_idoc_data ).

        fill_idoc_tracking_id(
          EXPORTING
            is_aotype        = <ls_aotype>
            is_delivery_item = <ls_dlv_item>
          CHANGING
            cs_idoc_data     = ls_idoc_data ).
      ENDLOOP.

      IF ls_idoc_data-appobj_ctabs[] IS NOT INITIAL AND
         ls_idoc_data-control[] IS NOT INITIAL AND
         ls_idoc_data-tracking_id[] IS NOT INITIAL.
        APPEND ls_idoc_data TO mt_idoc_data.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.


  METHOD zif_gtt_ctp_tor_to_dl~extract_data.
    fill_delivery_item_data( ).
  ENDMETHOD.
ENDCLASS.
