class ZCL_GTT_SOF_CTP_SND_TOR_TO_DLI definition
  public
  inheriting from ZCL_GTT_SOF_CTP_SND
  create private .

public section.

  class-methods GET_INSTANCE
    returning
      value(RO_SENDER) type ref to ZCL_GTT_SOF_CTP_SND_TOR_TO_DLI
    raising
      CX_UDM_MESSAGE .
  methods PREPARE_IDOC_DATA
    importing
      !IO_DL_ITEM_DATA type ref to ZCL_GTT_SOF_CTP_DAT_TOR_TO_DLI
    raising
      CX_UDM_MESSAGE .
  PROTECTED SECTION.

    METHODS get_aotype_restriction_id
        REDEFINITION .
    METHODS get_object_type
        REDEFINITION .
private section.

  constants:
    BEGIN OF cs_mapping,
      vbeln            TYPE /saptrx/paramname VALUE 'YN_DL_DELEVERY',
      posnr            TYPE /saptrx/paramname VALUE 'YN_DL_DELEVERY_ITEM',
      fu_lineno        TYPE /saptrx/paramname VALUE 'YN_DL_FU_LINE_COUNT',
      fu_freightunit   TYPE /saptrx/paramname VALUE 'YN_DL_FU_NO',
      fu_itemnumber    TYPE /saptrx/paramname VALUE 'YN_DL_FU_ITEM_NO',
      fu_quantity      TYPE /saptrx/paramname VALUE 'YN_DL_FU_QUANTITY',
      fu_quantityuom   TYPE /saptrx/paramname VALUE 'YN_DL_FU_UNITS',
      fu_product_id    TYPE /saptrx/paramname VALUE 'YN_DL_FU_PRODUCT',
      fu_product_descr TYPE /saptrx/paramname VALUE 'YN_DL_FU_PRODUCT_DESCR',
    END OF cs_mapping .

  methods FILL_IDOC_APPOBJ_CTABS
    importing
      !IS_AOTYPE type ZIF_GTT_SOF_CTP_TYPES=>TS_AOTYPE
      !IS_LIPS type LIPSVB
    changing
      !CS_IDOC_DATA type ZIF_GTT_SOF_CTP_TYPES=>TS_IDOC_DATA
    raising
      CX_UDM_MESSAGE .
  methods FILL_IDOC_CONTROL_DATA
    importing
      !IS_AOTYPE type ZIF_GTT_SOF_CTP_TYPES=>TS_AOTYPE
      !IS_LIKP type LIKPVB
      !IS_LIPS type LIPSVB
      !IT_FU_LIST type ZIF_GTT_SOF_CTP_TYPES=>TT_FU_LIST
    changing
      !CS_IDOC_DATA type ZIF_GTT_SOF_CTP_TYPES=>TS_IDOC_DATA
    raising
      CX_UDM_MESSAGE .
  methods FILL_IDOC_EXP_EVENT
    importing
      !IS_AOTYPE type ZIF_GTT_SOF_CTP_TYPES=>TS_AOTYPE
      !IS_LIKP type LIKPVB
      !IS_LIPS type LIPSVB
      !IS_DLV_ITEM type ZIF_GTT_SOF_CTP_TYPES=>TS_DELIVERY_ITEM
    changing
      !CS_IDOC_DATA type ZIF_GTT_SOF_CTP_TYPES=>TS_IDOC_DATA
    raising
      CX_UDM_MESSAGE .
  methods FILL_IDOC_TRACKING_ID
    importing
      !IS_AOTYPE type ZIF_GTT_SOF_CTP_TYPES=>TS_AOTYPE
      !IS_LIPS type LIPSVB
      !IT_FU_LIST type ZIF_GTT_SOF_CTP_TYPES=>TT_FU_LIST
    changing
      !CS_IDOC_DATA type ZIF_GTT_SOF_CTP_TYPES=>TS_IDOC_DATA
    raising
      CX_UDM_MESSAGE .
ENDCLASS.



CLASS ZCL_GTT_SOF_CTP_SND_TOR_TO_DLI IMPLEMENTATION.


  METHOD fill_idoc_appobj_ctabs.

    DATA:
      lv_appobjid TYPE /saptrx/aoid.

    lv_appobjid = |{ is_lips-vbeln ALPHA = OUT }{ is_lips-posnr ALPHA = IN }|.
    CONDENSE lv_appobjid NO-GAPS.

    cs_idoc_data-appobj_ctabs = VALUE #( BASE cs_idoc_data-appobj_ctabs (
      trxservername = cs_idoc_data-trxserv-trx_server_id
      appobjtype    = is_aotype-aot_type
      appobjid      = lv_appobjid
    ) ).

  ENDMETHOD.


  METHOD fill_idoc_control_data.

    DATA: lt_control  TYPE /saptrx/bapi_trk_control_tab,
          lv_count    TYPE i VALUE 0,
          lv_appobjid TYPE /saptrx/aoid,
          lt_tmp_fu   TYPE zif_gtt_sof_ctp_types=>tt_fu_list.


    " DL Item key data (obligatory)
    lt_control  = VALUE #(
      (
        paramname = cs_mapping-vbeln
        value     = |{ is_likp-vbeln ALPHA = OUT }|
      )
      (
        paramname = cs_mapping-posnr
        value     = is_lips-posnr
      )
      (
        paramname = zif_gtt_sof_ctp_tor_constants=>cs_system_fields-actual_bisiness_timezone
        value     = zcl_gtt_sof_tm_tools=>get_system_time_zone( )
      )
      (
        paramname = zif_gtt_sof_ctp_tor_constants=>cs_system_fields-actual_bisiness_datetime
        value     = |0{ sy-datum }{ sy-uzeit }|
      )
      (
        paramname = zif_gtt_sof_ctp_tor_constants=>cs_system_fields-actual_technical_timezone
        value     = zcl_gtt_sof_tm_tools=>get_system_time_zone( )
      )
      (
        paramname = zif_gtt_sof_ctp_tor_constants=>cs_system_fields-actual_technical_datetime
        value     = |0{ sy-datum }{ sy-uzeit }|
      )
    ).

    " fill F.U. table
    LOOP AT it_fu_list ASSIGNING FIELD-SYMBOL(<ls_fu_list>).
      IF <ls_fu_list>-change_mode = /bobf/if_frw_c=>sc_modify_delete.
        CONTINUE.
      ENDIF.
      APPEND <ls_fu_list> TO lt_tmp_fu.

      ADD 1 TO lv_count.

      lt_control  = VALUE #( BASE lt_control
        (
          paramindex  = lv_count
          paramname   = cs_mapping-fu_lineno
          value       = zcl_gtt_sof_tm_tools=>get_pretty_value(
                          iv_value = lv_count )
        )
        (
          paramindex  = lv_count
          paramname   = cs_mapping-fu_freightunit
          value       = zcl_gtt_sof_tm_tools=>get_formated_tor_id(
                          ir_data = REF #( <ls_fu_list> ) )
        )
        (
          paramindex  = lv_count
          paramname   = cs_mapping-fu_itemnumber
          value       = zcl_gtt_sof_tm_tools=>get_formated_tor_item(
                          ir_data = REF #( <ls_fu_list> ) )
        )
        (
          paramindex  = lv_count
          paramname   = cs_mapping-fu_quantity
          value       = zcl_gtt_sof_tm_tools=>get_pretty_value(
                          iv_value = <ls_fu_list>-quantity )
        )
        (
          paramindex  = lv_count
          paramname   = cs_mapping-fu_quantityuom
          value       = zcl_gtt_sof_tm_tools=>get_pretty_value(
                          iv_value = <ls_fu_list>-quantityuom )
        )
        (
          paramindex  = lv_count
          paramname   = cs_mapping-fu_product_id
          value       = zcl_gtt_sof_tm_tools=>get_pretty_value(
                          iv_value = <ls_fu_list>-product_id )
        )
        (
          paramindex  = lv_count
          paramname   = cs_mapping-fu_product_descr
          value       = zcl_gtt_sof_tm_tools=>get_pretty_value(
                          iv_value = <ls_fu_list>-product_descr )
        )
      ).
    ENDLOOP.

    " add deletion sign in case of emtpy IT_FU_LIST table
    IF lt_tmp_fu IS INITIAL.
      lt_control  = VALUE #( BASE lt_control (
          paramindex = 1
          paramname  = cs_mapping-fu_lineno
          value      = ''
      ) ).
    ENDIF.

    " fill technical data into all control data records
    lv_appobjid = |{ is_lips-vbeln ALPHA = OUT }{ is_lips-posnr ALPHA = IN }|.
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
      lv_appobjid  TYPE /saptrx/aoid.

    " do not retrieve planned events when DLV is not stored in DB yet
    " (this is why all the fields of LIKP are empty, except VBELN)
    IF is_likp-lfart IS NOT INITIAL AND
       is_lips-pstyv IS NOT INITIAL.

      TRY.
          zcl_gtt_sof_tm_tools=>get_delivery_item_planned_evt(
            EXPORTING
              iv_appsys    = mv_appsys
              is_aotype    = is_aotype
              is_likp      = is_likp
              is_lips      = is_lips
              is_dlv_item  = is_dlv_item
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

          lv_appobjid = |{ is_lips-vbeln ALPHA = OUT }{ is_lips-posnr ALPHA = IN }|.
          CONDENSE lv_appobjid NO-GAPS.
          LOOP AT lt_exp_event ASSIGNING FIELD-SYMBOL(<ls_exp_event>).
            <ls_exp_event>-appsys         = mv_appsys.
            <ls_exp_event>-appobjtype     = is_aotype-aot_type.
            <ls_exp_event>-appobjid       = lv_appobjid.
            <ls_exp_event>-language       = sy-langu.
            IF <ls_exp_event>-evt_exp_tzone IS INITIAL.
              <ls_exp_event>-evt_exp_tzone  = zcl_gtt_sof_tm_tools=>get_system_time_zone(  ).
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
      lv_tmp_dlvittrxcod TYPE /saptrx/trxcod,
      lv_dlvittrxcod     TYPE /saptrx/trxcod,
      lv_appobjid        TYPE /saptrx/aoid,
      lt_fu_id           TYPE zif_gtt_sof_ctp_types=>tt_fu_id,
      lv_futrxcod        TYPE /saptrx/trxcod,
      ls_fu_create       TYPE zif_gtt_sof_ctp_types=>ts_fu_list,
      ls_fu_update       TYPE zif_gtt_sof_ctp_types=>ts_fu_list,
      ls_fu_delete       TYPE zif_gtt_sof_ctp_types=>ts_fu_list.

    lv_dlvittrxcod = zif_gtt_sof_constants=>cs_trxcod-out_delivery_item.
    lv_futrxcod    = zif_gtt_sof_constants=>cs_trxcod-fu_number.

    " Delivery Item
    lv_appobjid = |{ is_lips-vbeln ALPHA = OUT }{ is_lips-posnr ALPHA = IN }|.
    CONDENSE lv_appobjid NO-GAPS.
    cs_idoc_data-tracking_id  = VALUE #( BASE cs_idoc_data-tracking_id (
      appsys      = mv_appsys
      appobjtype  = is_aotype-aot_type
      appobjid    = lv_appobjid
      trxcod      = lv_dlvittrxcod
      trxid       = lv_appobjid
      timzon      = zcl_gtt_sof_tm_tools=>get_system_time_zone( )
    ) ).

*   DLV Item watch FU
    lt_fu_id =  CORRESPONDING #( it_fu_list ).
    SORT lt_fu_id BY tor_id.
    DELETE ADJACENT DUPLICATES FROM lt_fu_id COMPARING tor_id.

    LOOP AT lt_fu_id  ASSIGNING FIELD-SYMBOL(<ls_fu_id>).
      CLEAR:
        ls_fu_create,
        ls_fu_update,
        ls_fu_delete.

      READ TABLE it_fu_list INTO ls_fu_create WITH KEY tor_id = <ls_fu_id>-tor_id change_mode = /bobf/if_frw_c=>sc_modify_create.
      READ TABLE it_fu_list INTO ls_fu_update WITH KEY tor_id = <ls_fu_id>-tor_id change_mode = /bobf/if_frw_c=>sc_modify_update.
      READ TABLE it_fu_list INTO ls_fu_delete WITH KEY tor_id = <ls_fu_id>-tor_id change_mode = /bobf/if_frw_c=>sc_modify_delete.

      IF ls_fu_create IS NOT INITIAL
        AND ls_fu_update IS INITIAL
        AND ls_fu_delete IS INITIAL.
        cs_idoc_data-tracking_id  = VALUE #( BASE cs_idoc_data-tracking_id (
          appsys      = mv_appsys
          appobjtype  = is_aotype-aot_type
          appobjid    = lv_appobjid
          trxcod      = lv_futrxcod
          trxid       = zcl_gtt_sof_tm_tools=>get_formated_tor_id( ir_data = REF #( <ls_fu_id> ) )
          timzon      = zcl_gtt_sof_tm_tools=>get_system_time_zone( )
        ) ).
      ENDIF.

      IF ls_fu_delete IS NOT INITIAL
       AND ls_fu_create IS INITIAL
       AND ls_fu_update IS INITIAL.
        cs_idoc_data-tracking_id  = VALUE #( BASE cs_idoc_data-tracking_id (
          appsys      = mv_appsys
          appobjtype  = is_aotype-aot_type
          appobjid    = lv_appobjid
          trxcod      = lv_futrxcod
          trxid       = zcl_gtt_sof_tm_tools=>get_formated_tor_id( ir_data = REF #( <ls_fu_id> ) )
          timzon      = zcl_gtt_sof_tm_tools=>get_system_time_zone( )
          action      = /bobf/if_frw_c=>sc_modify_delete
        ) ).
      ENDIF.

    ENDLOOP.

  ENDMETHOD.


  METHOD get_aotype_restriction_id.

    rv_rst_id   = 'FU_TO_ODLI'.

  ENDMETHOD.


  METHOD get_instance.

    DATA(lt_trk_obj_type) = VALUE zif_gtt_sof_ctp_types=>tt_trk_obj_type(
       ( zif_gtt_sof_ctp_tor_constants=>cs_trk_obj_type-tms_tor )
       ( zif_gtt_sof_ctp_tor_constants=>cs_trk_obj_type-esc_deliv )
    ).

    IF is_gtt_enabled( it_trk_obj_type = lt_trk_obj_type ) = abap_true.
      ro_sender  = NEW #( ).

      ro_sender->initiate( ).
    ELSE.
      MESSAGE e006(zgtt_ssof) INTO DATA(lv_dummy).
      zcl_gtt_sof_tm_tools=>throw_exception( ).
    ENDIF.

  ENDMETHOD.


  METHOD get_object_type.

    rv_objtype  = zif_gtt_sof_ctp_tor_constants=>cs_trk_obj_type-esc_deliv.

  ENDMETHOD.


  METHOD prepare_idoc_data.

    DATA: ls_idoc_data    TYPE zif_gtt_sof_ctp_types=>ts_idoc_data.

    DATA(lr_dlv_item)   = io_dl_item_data->get_delivery_items( ).

    FIELD-SYMBOLS: <lt_dlv_item>  TYPE zif_gtt_sof_ctp_types=>tt_delivery_item.

    ASSIGN lr_dlv_item->*  TO <lt_dlv_item>.

    LOOP AT mt_aotype ASSIGNING FIELD-SYMBOL(<ls_aotype>).
      CLEAR: ls_idoc_data.

      ls_idoc_data-appsys   = mv_appsys.

      fill_idoc_trxserv(
        EXPORTING
          is_aotype    = <ls_aotype>
        CHANGING
          cs_idoc_data = ls_idoc_data ).

      LOOP AT <lt_dlv_item> ASSIGNING FIELD-SYMBOL(<ls_dlv_fu>).

        IF <ls_dlv_fu>-lips-pstyv IS INITIAL. " Skip the the item that don't stored in DB
          CONTINUE.
        ENDIF.

        fill_idoc_appobj_ctabs(
          EXPORTING
            is_aotype    = <ls_aotype>
            is_lips      = <ls_dlv_fu>-lips
          CHANGING
            cs_idoc_data = ls_idoc_data ).

        fill_idoc_control_data(
          EXPORTING
            is_aotype    = <ls_aotype>
            is_likp      = <ls_dlv_fu>-likp
            is_lips      = <ls_dlv_fu>-lips
            it_fu_list   = <ls_dlv_fu>-fu_list
          CHANGING
            cs_idoc_data = ls_idoc_data ).

        fill_idoc_exp_event(
          EXPORTING
            is_aotype    = <ls_aotype>
            is_likp      = <ls_dlv_fu>-likp
            is_lips      = <ls_dlv_fu>-lips
            is_dlv_item  = <ls_dlv_fu>
          CHANGING
            cs_idoc_data = ls_idoc_data ).

        fill_idoc_tracking_id(
          EXPORTING
            is_aotype    = <ls_aotype>
            is_lips      = <ls_dlv_fu>-lips
            it_fu_list   = <ls_dlv_fu>-fu_list
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
