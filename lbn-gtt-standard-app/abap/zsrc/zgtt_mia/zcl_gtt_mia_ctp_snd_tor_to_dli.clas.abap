CLASS zcl_gtt_mia_ctp_snd_tor_to_dli DEFINITION
  PUBLIC
  INHERITING FROM zcl_gtt_ctp_snd
  CREATE PRIVATE .

  PUBLIC SECTION.

    CLASS-METHODS get_instance
      RETURNING
        VALUE(ro_sender) TYPE REF TO zcl_gtt_mia_ctp_snd_tor_to_dli
      RAISING
        cx_udm_message .
    METHODS prepare_idoc_data
      IMPORTING
        !io_dl_item_data TYPE REF TO zcl_gtt_mia_ctp_dat_tor_to_dli
      RAISING
        cx_udm_message .
  PROTECTED SECTION.

    METHODS get_aotype_restriction_id
        REDEFINITION .
    METHODS get_object_type
        REDEFINITION .
    METHODS get_evtype_restriction_id
        REDEFINITION .
  PRIVATE SECTION.

    CONSTANTS:
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

    METHODS fill_idoc_appobj_ctabs
      IMPORTING
        !is_aotype    TYPE zif_gtt_ctp_types=>ts_aotype
        !is_lips      TYPE zif_gtt_mia_app_types=>ts_lipsvb
      CHANGING
        !cs_idoc_data TYPE zif_gtt_ctp_types=>ts_idoc_data
      RAISING
        cx_udm_message .
    METHODS fill_idoc_control_data
      IMPORTING
        !is_aotype    TYPE zif_gtt_ctp_types=>ts_aotype
        !is_likp      TYPE zif_gtt_mia_app_types=>ts_likpvb
        !is_lips      TYPE zif_gtt_mia_app_types=>ts_lipsvb
        !it_fu_list   TYPE zif_gtt_mia_ctp_types=>tt_fu_list
      CHANGING
        !cs_idoc_data TYPE zif_gtt_ctp_types=>ts_idoc_data
      RAISING
        cx_udm_message .
    METHODS fill_idoc_exp_event
      IMPORTING
        !is_aotype    TYPE zif_gtt_ctp_types=>ts_aotype
        !is_likp      TYPE zif_gtt_mia_app_types=>ts_likpvb
        !is_lips      TYPE zif_gtt_mia_app_types=>ts_lipsvb
      CHANGING
        !cs_idoc_data TYPE zif_gtt_ctp_types=>ts_idoc_data
      RAISING
        cx_udm_message .
    METHODS fill_idoc_tracking_id
      IMPORTING
        !is_aotype    TYPE zif_gtt_ctp_types=>ts_aotype
        !is_lips      TYPE zif_gtt_mia_app_types=>ts_lipsvb
        !it_fu_list   TYPE zif_gtt_mia_ctp_types=>tt_fu_list
      CHANGING
        !cs_idoc_data TYPE zif_gtt_ctp_types=>ts_idoc_data
      RAISING
        cx_udm_message .
ENDCLASS.



CLASS ZCL_GTT_MIA_CTP_SND_TOR_TO_DLI IMPLEMENTATION.


  METHOD fill_idoc_appobj_ctabs.

    cs_idoc_data-appobj_ctabs = VALUE #( BASE cs_idoc_data-appobj_ctabs (
      trxservername = cs_idoc_data-trxserv-trx_server_id
      appobjtype    = is_aotype-aot_type
      appobjid      = zcl_gtt_mia_dl_tools=>get_tracking_id_dl_item(
                        ir_lips = REF #( is_lips ) )
    ) ).

  ENDMETHOD.


  METHOD fill_idoc_control_data.

    DATA: lt_control TYPE /saptrx/bapi_trk_control_tab,
          lv_count   TYPE i VALUE 0.
    DATA: lt_tmp_fu_list TYPE zif_gtt_mia_ctp_types=>tt_fu_list.

    " DL Item key data (obligatory)
    lt_control  = VALUE #(
      (
        paramname = cs_mapping-vbeln
        value     = zcl_gtt_mia_dl_tools=>get_formated_dlv_number(
                      ir_likp = REF #( is_likp ) )
      )
      (
        paramname = cs_mapping-posnr
        value     = zcl_gtt_mia_dl_tools=>get_formated_dlv_item(
                      ir_lips = REF #( is_lips ) )
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

    DATA(lt_fu_list) = it_fu_list.

    " fill F.U. table
    LOOP AT it_fu_list ASSIGNING FIELD-SYMBOL(<ls_fu_list>).
      READ TABLE lt_fu_list INTO DATA(ls_fu_delete) WITH KEY tor_id = <ls_fu_list>-tor_id change_mode = /bobf/if_frw_c=>sc_modify_delete.
      IF ls_fu_delete IS NOT INITIAL.
        CLEAR ls_fu_delete.
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
      ).
    ENDLOOP.

    " add deletion sign in case of emtpy IT_FU_LIST table
    IF lt_tmp_fu_list IS INITIAL.
      lt_control  = VALUE #( BASE lt_control (
          paramindex = 1
          paramname  = cs_mapping-fu_lineno
          value      = ''
      ) ).
    ENDIF.

    " fill technical data into all control data records
    LOOP AT lt_control ASSIGNING FIELD-SYMBOL(<ls_control>).
      <ls_control>-appsys     = mv_appsys.
      <ls_control>-appobjtype = is_aotype-aot_type.
      <ls_control>-appobjid = zcl_gtt_mia_dl_tools=>get_tracking_id_dl_item(
        ir_lips = REF #( is_lips ) ).
    ENDLOOP.

    cs_idoc_data-control  = VALUE #( BASE cs_idoc_data-control
                                     ( LINES OF lt_control ) ).

  ENDMETHOD.


  METHOD fill_idoc_exp_event.

    DATA: lt_exp_event TYPE /saptrx/bapi_trk_ee_tab.

    " do not retrieve planned events when DLV is not stored in DB yet
    " (this is why all the fields of LIKP are empty, except VBELN)
    IF is_likp-lfart IS NOT INITIAL AND
       is_lips-pstyv IS NOT INITIAL.

      TRY.
          zcl_gtt_mia_ctp_tools=>get_delivery_item_planned_evt(
            EXPORTING
              iv_appsys    = mv_appsys
              is_aotype    = is_aotype
              is_likp      = is_likp
              is_lips      = is_lips
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
            <ls_exp_event>-appobjid = zcl_gtt_mia_dl_tools=>get_tracking_id_dl_item(
              ir_lips = REF #( is_lips ) ).
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
      lv_dlvittrxcod     TYPE /saptrx/trxcod,
      lv_futrxcod        TYPE /saptrx/trxcod.

    DATA:
      lt_tracking_id TYPE /saptrx/bapi_trk_trkid_tab,
      lt_fu_id       TYPE zif_gtt_mia_ctp_types=>tt_fu_id.

    DATA:
      ls_fu_create TYPE zif_gtt_mia_ctp_types=>ts_fu_list,
      ls_fu_update TYPE zif_gtt_mia_ctp_types=>ts_fu_list,
      ls_fu_delete TYPE zif_gtt_mia_ctp_types=>ts_fu_list.

    lv_dlvittrxcod = zif_gtt_ef_constants=>cs_trxcod-dl_position.
    lv_futrxcod    = zif_gtt_ef_constants=>cs_trxcod-fu_number.

    " Delivery Item
    cs_idoc_data-tracking_id  = VALUE #( BASE cs_idoc_data-tracking_id (
      appsys      = mv_appsys
      appobjtype  = is_aotype-aot_type
      appobjid    = zcl_gtt_mia_dl_tools=>get_tracking_id_dl_item(
                      ir_lips = REF #( is_lips ) )
      trxcod      = lv_dlvittrxcod
      trxid       = zcl_gtt_mia_dl_tools=>get_tracking_id_dl_item(
                      ir_lips = REF #( is_lips ) )
      timzon      = zcl_gtt_tools=>get_system_time_zone( )
    ) ).

    lt_fu_id =  CORRESPONDING #( it_fu_list ).
    SORT lt_fu_id BY tor_id.
    DELETE ADJACENT DUPLICATES FROM lt_fu_id COMPARING tor_id.
    " Freight unit
    LOOP AT lt_fu_id  ASSIGNING FIELD-SYMBOL(<ls_fu_id>).

      CLEAR:ls_fu_create,ls_fu_update,ls_fu_delete.
      READ TABLE it_fu_list INTO ls_fu_create WITH KEY tor_id = <ls_fu_id>-tor_id change_mode = /bobf/if_frw_c=>sc_modify_create.
      READ TABLE it_fu_list INTO ls_fu_update WITH KEY tor_id = <ls_fu_id>-tor_id change_mode = /bobf/if_frw_c=>sc_modify_update.
      READ TABLE it_fu_list INTO ls_fu_delete WITH KEY tor_id = <ls_fu_id>-tor_id change_mode = /bobf/if_frw_c=>sc_modify_delete.

      IF ls_fu_create IS NOT INITIAL AND
         ls_fu_update IS INITIAL AND
         ls_fu_delete IS INITIAL.
        lt_tracking_id    = VALUE #( BASE lt_tracking_id (
          trxcod      = lv_futrxcod
          trxid       = zcl_gtt_mia_tm_tools=>get_formated_tor_id( ir_data = REF #( <ls_fu_id> ) )
        ) ).

      ENDIF.

      IF ls_fu_delete IS NOT INITIAL AND
         ls_fu_update IS INITIAL AND
         ls_fu_create IS INITIAL.
        lt_tracking_id    = VALUE #( BASE lt_tracking_id (
          trxcod      = lv_futrxcod
          trxid       = zcl_gtt_mia_tm_tools=>get_formated_tor_id( ir_data = REF #( <ls_fu_id> ) )
          action      = zif_gtt_ef_constants=>cs_change_mode-delete
        ) ).

      ENDIF.
    ENDLOOP.

*    " Fill general data
    LOOP AT lt_tracking_id ASSIGNING FIELD-SYMBOL(<ls_tracking_id>).
      <ls_tracking_id>-appsys     = mv_appsys.
      <ls_tracking_id>-appobjtype = is_aotype-aot_type.
      <ls_tracking_id>-appobjid = zcl_gtt_mia_dl_tools=>get_tracking_id_dl_item(
        ir_lips = REF #( is_lips ) ).
    ENDLOOP.

    cs_idoc_data-tracking_id = VALUE #( BASE cs_idoc_data-tracking_id
                                        ( LINES OF lt_tracking_id ) ).

  ENDMETHOD.


  METHOD get_aotype_restriction_id.

    rv_rst_id   = 'FU_TO_IDLI'.

  ENDMETHOD.


  METHOD get_evtype_restriction_id.
    CLEAR rv_rst_id.
  ENDMETHOD.


  METHOD get_instance.

    DATA(lt_trk_obj_type) = VALUE zif_gtt_ctp_types=>tt_trk_obj_type(
       ( zif_gtt_ef_constants=>cs_trk_obj_type-tms_tor )
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


  METHOD get_object_type.

    rv_objtype  = zif_gtt_ef_constants=>cs_trk_obj_type-esc_deliv.

  ENDMETHOD.


  METHOD prepare_idoc_data.

    DATA: ls_idoc_data    TYPE zif_gtt_ctp_types=>ts_idoc_data.

    DATA(lr_dlv_item)   = io_dl_item_data->get_delivery_items( ).

    FIELD-SYMBOLS: <lt_dlv_item>  TYPE zif_gtt_mia_ctp_types=>tt_delivery_item.

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

        " Skip for new created delivery item.
        IF <ls_dlv_fu>-lips-pstyv IS INITIAL.
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
