class ZCL_GTT_CTP_TOR_TO_DL_BASE definition
  public
  abstract
  create public .

public section.

  interfaces ZIF_GTT_CTP_TOR_TO_DL .

  TYPES:
    BEGIN OF ts_delivery,
      vbeln TYPE likp-vbeln,
    END OF ts_delivery.

  TYPES:
    BEGIN OF ts_delivery_info,
      vbeln       TYPE likp-vbeln,
      dlv_items   TYPE zif_gtt_sof_ctp_types=>tt_delivery_chng,
      tor_id      TYPE /scmtms/t_tor_id,
      process_flg TYPE flag,
    END OF ts_delivery_info.
  TYPES:
    tt_delivery      TYPE TABLE OF ts_delivery,
    tt_delivery_info TYPE TABLE OF ts_delivery_info.
protected section.

  data MV_APPSYS type LOGSYS .
  data MV_BASE_BTD_TCO type /SCMTMS/BASE_BTD_TCO .
  data MT_AOTYPE type ZIF_GTT_CTP_TYPES=>TT_AOTYPE .
  data MT_TOR_ROOT type /SCMTMS/T_EM_BO_TOR_ROOT .
  data MT_TOR_ROOT_BEFORE type /SCMTMS/T_EM_BO_TOR_ROOT .
  data MT_TOR_ITEM type /SCMTMS/T_EM_BO_TOR_ITEM .
  data MT_TOR_ITEM_BEFORE type /SCMTMS/T_EM_BO_TOR_ITEM .
  data MT_TOR_STOP type /SCMTMS/T_EM_BO_TOR_STOP .
  data MT_TOR_STOP_BEFORE type /SCMTMS/T_EM_BO_TOR_STOP .
  data MT_DELIVERY_ITEM_CHNG type ZIF_GTT_SOF_CTP_TYPES=>TT_DELIVERY_CHNG .
  data MT_DELIVERY type ZIF_GTT_SOF_CTP_TYPES=>TT_DELIVERY .
  constants:
    BEGIN OF cs_mapping,
      vbeln                 TYPE /saptrx/paramname VALUE 'YN_DLV_NO',
      posnr                 TYPE /saptrx/paramname VALUE 'YN_DLV_ITEM_NO',
      fu_relevant           TYPE /saptrx/paramname VALUE 'YN_DL_FU_RELEVANT',
      pod_relevant          TYPE /saptrx/paramname VALUE 'YN_DL_POD_RELEVANT',
      dlv_vbeln             TYPE /saptrx/paramname VALUE 'YN_DL_DELEVERY',
      dlv_posnr             TYPE /saptrx/paramname VALUE 'YN_DL_DELEVERY_ITEM',
      fu_lineno             TYPE /saptrx/paramname VALUE 'YN_DL_FU_LINE_COUNT',
      fu_freightunit        TYPE /saptrx/paramname VALUE 'YN_DL_FU_NO',
      fu_itemnumber         TYPE /saptrx/paramname VALUE 'YN_DL_FU_ITEM_NO',
      fu_quantity           TYPE /saptrx/paramname VALUE 'YN_DL_FU_QUANTITY',
      fu_quantityuom        TYPE /saptrx/paramname VALUE 'YN_DL_FU_UNITS',
      fu_product_id         TYPE /saptrx/paramname VALUE 'YN_DL_FU_PRODUCT',
      fu_product_descr      TYPE /saptrx/paramname VALUE 'YN_DL_FU_PRODUCT_DESCR',
      fu_freightunit_logsys TYPE /saptrx/paramname VALUE 'YN_DL_FU_NO_LOGSYS',
      fu_base_uom_val       TYPE /saptrx/paramname VALUE 'YN_FU_BASE_UOM_VAL',
      fu_base_uom_uni       TYPE /saptrx/paramname VALUE 'YN_FU_BASE_UOM_UNI',
      appsys                TYPE /saptrx/paramname VALUE 'E1EHPTID_APPSYS',
      trxcod                TYPE /saptrx/paramname VALUE 'E1EHPTID_TRXCOD',
      trxid                 TYPE /saptrx/paramname VALUE 'E1EHPTID_TRXID',
      action                TYPE /saptrx/paramname VALUE 'E1EHPTID_ACTION',
    END OF cs_mapping .
  data MT_IDOC_DATA type ZIF_GTT_SOF_CTP_TYPES=>TT_IDOC_DATA .
  data MT_DELIVERY_ITEM type ZIF_GTT_SOF_CTP_TYPES=>TT_DELIVERY_ITEM .
  data MT_FU_INFO type /SCMTMS/T_TOR_ROOT_K .

  methods GET_AOTYPE_RESTRICTION_ID
  abstract
    returning
      value(RV_RST_ID) type ZGTT_RST_ID .
  methods INITIATE_AOTYPES
    importing
      !IV_RST_ID type ZGTT_RST_ID .
  methods IS_GTT_ENABLED
    importing
      !IV_TRK_OBJ_TYPE type /SAPTRX/TRK_OBJ_TYPE
    returning
      value(RV_RESULT) type FLAG .
  methods IS_EXTRACTOR_EXIST
    importing
      !IV_TRK_OBJ_TYPE type /SAPTRX/TRK_OBJ_TYPE
    returning
      value(RV_RESULT) type ABAP_BOOL .
  methods GET_DLV_ITEM_BASED_ON_TOR_ROOT
    changing
      !CT_DELIVERY_ITEM type ZIF_GTT_SOF_CTP_TYPES=>TT_DELIVERY_CHNG .
  methods ADD_DELIVERY_ITEMS_BY_TOR_ROOT
    importing
      !IS_TOR_ROOT type /SCMTMS/S_EM_BO_TOR_ROOT
      !IV_CHANGE_MODE type /BOBF/CONF_CHANGE_MODE
    changing
      !CT_DELIVERY_ITEM type ZIF_GTT_SOF_CTP_TYPES=>TT_DELIVERY_CHNG .
  methods ADD_DELIVERY_ITEM
    importing
      !IS_TOR_ROOT type /SCMTMS/S_EM_BO_TOR_ROOT
      !IS_TOR_ITEM type /SCMTMS/S_EM_BO_TOR_ITEM
      !IV_CHANGE_MODE type /BOBF/CONF_CHANGE_MODE
    changing
      !CT_DELIVERY_ITEM type ZIF_GTT_SOF_CTP_TYPES=>TT_DELIVERY_CHNG .
  methods GET_DLV_ITEM_BASED_ON_TOR_ITEM
    changing
      !CT_DELIVERY_ITEM type ZIF_GTT_SOF_CTP_TYPES=>TT_DELIVERY_CHNG .
  methods GET_DLV_ITEM_BASED_ON_TOR_STOP
    changing
      !CT_DELIVERY_ITEM type ZIF_GTT_SOF_CTP_TYPES=>TT_DELIVERY_CHNG .
  methods FILL_DELIVERY_HEADER_DATA .
  methods PREPARE_IDOC_DATA
    raising
      CX_UDM_MESSAGE .
  methods FILL_IDOC_TRXSERV
    importing
      !IS_AOTYPE type ZIF_GTT_SOF_CTP_TYPES=>TS_AOTYPE
    changing
      !CS_IDOC_DATA type ZIF_GTT_SOF_CTP_TYPES=>TS_IDOC_DATA .
  methods FILL_IDOC_APPOBJ_CTABS
    importing
      !IS_AOTYPE type ZIF_GTT_SOF_CTP_TYPES=>TS_AOTYPE
      value(IS_LIKP) type ZIF_GTT_SOF_CTP_TYPES=>TS_DELIVERY optional
      value(IS_DELIVERY_ITEM) type ZIF_GTT_SOF_CTP_TYPES=>TS_DELIVERY_ITEM optional
    changing
      !CS_IDOC_DATA type ZIF_GTT_SOF_CTP_TYPES=>TS_IDOC_DATA .
  methods FILL_IDOC_CONTROL_DATA
    importing
      !IS_AOTYPE type ZIF_GTT_SOF_CTP_TYPES=>TS_AOTYPE
      value(IS_DELIVERY) type ZIF_GTT_SOF_CTP_TYPES=>TS_DELIVERY optional
      value(IS_DELIVERY_ITEM) type ZIF_GTT_SOF_CTP_TYPES=>TS_DELIVERY_ITEM optional
    changing
      !CS_IDOC_DATA type ZIF_GTT_SOF_CTP_TYPES=>TS_IDOC_DATA
    raising
      CX_UDM_MESSAGE .
  methods FILL_IDOC_EXP_EVENT
    importing
      !IS_AOTYPE type ZIF_GTT_SOF_CTP_TYPES=>TS_AOTYPE
      value(IS_DELIVERY) type ZIF_GTT_SOF_CTP_TYPES=>TS_DELIVERY optional
      value(IS_DLV_ITEM) type ZIF_GTT_SOF_CTP_TYPES=>TS_DELIVERY_ITEM optional
    changing
      !CS_IDOC_DATA type ZIF_GTT_SOF_CTP_TYPES=>TS_IDOC_DATA
    raising
      CX_UDM_MESSAGE .
  methods FILL_IDOC_TRACKING_ID
    importing
      !IS_AOTYPE type ZIF_GTT_SOF_CTP_TYPES=>TS_AOTYPE
      value(IS_DELIVERY) type ZIF_GTT_SOF_CTP_TYPES=>TS_DELIVERY optional
      value(IS_DELIVERY_ITEM) type ZIF_GTT_SOF_CTP_TYPES=>TS_DELIVERY_ITEM optional
    changing
      !CS_IDOC_DATA type ZIF_GTT_SOF_CTP_TYPES=>TS_IDOC_DATA
    raising
      CX_UDM_MESSAGE .
  methods SEND_IDOC_DATA
    exporting
      !ET_BAPIRET type BAPIRET2_T .
  methods FILL_DELIVERY_ITEM_DATA .
  methods CLEAR_DATA .
  methods DETERMINE_PROCESS_FLAG
    importing
      !IT_TOR_ID type /SCMTMS/T_TOR_ID
      !IT_FU_DB type /SCMTMS/T_TOR_ROOT_K
    exporting
      !EV_PROCESS_FLG type FLAG .
  methods CHECK_FU_STATUS
    exporting
      !ET_DELIVERY_INFO type TT_DELIVERY_INFO .
private section.
ENDCLASS.



CLASS ZCL_GTT_CTP_TOR_TO_DL_BASE IMPLEMENTATION.


  METHOD add_delivery_item.

    DATA:
      ls_delivery_item TYPE zif_gtt_sof_ctp_types=>ts_delivery_chng,
      lv_matnr         TYPE mara-matnr.

    ls_delivery_item-vbeln        = |{ is_tor_item-base_btd_id ALPHA = IN }|.
    ls_delivery_item-posnr        = is_tor_item-base_btditem_id.
    ls_delivery_item-tor_id       = is_tor_root-tor_id.
    ls_delivery_item-item_id      = is_tor_item-item_id.
    ls_delivery_item-quantity     = is_tor_item-qua_pcs_val.
    ls_delivery_item-product_descr = is_tor_item-item_descr.
    ls_delivery_item-base_uom_val  = is_tor_item-base_uom_val.
    IF iv_change_mode IS NOT INITIAL.
      ls_delivery_item-change_mode  = iv_change_mode.
    ELSE.
      zcl_gtt_sof_toolkit=>get_fu_from_db(
        EXPORTING
          it_tor_id = VALUE #( ( is_tor_root-tor_id ) )
        IMPORTING
          et_fu     = DATA(lt_fu_db) ).
      IF lt_fu_db IS INITIAL.
        ls_delivery_item-change_mode  = /bobf/if_frw_c=>sc_modify_create.
      ELSE.
        ls_delivery_item-change_mode  = /bobf/if_frw_c=>sc_modify_update.
      ENDIF.
    ENDIF.

    zcl_gtt_sof_toolkit=>convert_unit_output(
      EXPORTING
        iv_input  = is_tor_item-qua_pcs_uni
      RECEIVING
        rv_output = ls_delivery_item-quantityuom ).

    zcl_gtt_sof_toolkit=>convert_unit_output(
      EXPORTING
        iv_input  = is_tor_item-base_uom_uni
      RECEIVING
        rv_output = ls_delivery_item-base_uom_uni ).

    zcl_gtt_tools=>convert_matnr_to_external_frmt(
      EXPORTING
        iv_material = is_tor_item-product_id
      IMPORTING
        ev_result   = lv_matnr ).
    ls_delivery_item-product_id = lv_matnr.
    CLEAR lv_matnr.

    INSERT ls_delivery_item INTO TABLE ct_delivery_item.

  ENDMETHOD.


  METHOD ADD_DELIVERY_ITEMS_BY_TOR_ROOT.

    DATA: ls_delivery_item TYPE zif_gtt_sof_ctp_types=>ts_delivery_chng.

    LOOP AT mt_tor_item ASSIGNING FIELD-SYMBOL(<ls_tor_item>)
      USING KEY item_parent WHERE parent_node_id = is_tor_root-node_id.

      IF <ls_tor_item>-base_btd_tco = mv_base_btd_tco AND
         <ls_tor_item>-base_btd_id     IS NOT INITIAL AND
         <ls_tor_item>-base_btditem_id IS NOT INITIAL AND
         <ls_tor_item>-item_cat = /scmtms/if_tor_const=>sc_tor_item_category-product.
        add_delivery_item(
          EXPORTING
            is_tor_root      = is_tor_root
            is_tor_item      = <ls_tor_item>
            iv_change_mode   = iv_change_mode
          CHANGING
            ct_delivery_item = ct_delivery_item ).
      ENDIF.
    ENDLOOP.

  ENDMETHOD.


  METHOD CLEAR_DATA.

    CLEAR:
      mv_appsys,
      mv_base_btd_tco,
      mt_aotype,
      mt_tor_root,
      mt_tor_root_before,
      mt_tor_item,
      mt_tor_item_before,
      mt_tor_stop,
      mt_tor_stop_before,
      mt_delivery_item_chng,
      mt_delivery,
      mt_idoc_data,
      mt_delivery_item,
      mt_fu_info.

  ENDMETHOD.


  METHOD fill_delivery_header_data.

    DATA:
      lt_likp        TYPE HASHED TABLE OF likp WITH UNIQUE KEY vbeln,
      lt_lips        TYPE SORTED TABLE OF lipsvb WITH UNIQUE KEY vbeln posnr,
      lt_vbfa        TYPE STANDARD TABLE OF vbfavb,
      ls_lips        TYPE lipsvb,
      ls_vbuk        TYPE vbukvb,
      ls_vbup        TYPE vbupvb,
      lv_base_btd_id TYPE /scmtms/base_btd_id,
      ls_dlv_head    TYPE zif_gtt_sof_ctp_types=>ts_delivery.

    CLEAR: mt_delivery.

*  collect DLV Headers from DLV Items
    LOOP AT mt_delivery_item_chng ASSIGNING FIELD-SYMBOL(<ls_delivery_item>).
      READ TABLE mt_delivery TRANSPORTING NO FIELDS
        WITH KEY vbeln  = <ls_delivery_item>-vbeln.

      IF sy-subrc <> 0.
        ls_dlv_head-vbeln = <ls_delivery_item>-vbeln.
        APPEND ls_dlv_head TO mt_delivery.
      ENDIF.
    ENDLOOP.

    IF mt_delivery IS NOT INITIAL.
      SELECT *
        INTO CORRESPONDING FIELDS OF TABLE lt_likp
        FROM likp
        FOR ALL ENTRIES IN mt_delivery
        WHERE vbeln = mt_delivery-vbeln.

      SELECT *
        INTO CORRESPONDING FIELDS OF TABLE lt_lips
        FROM lips
        FOR ALL ENTRIES IN mt_delivery
        WHERE vbeln = mt_delivery-vbeln.

      SELECT *
        INTO CORRESPONDING FIELDS OF TABLE lt_vbfa
        FROM vbfa
        FOR ALL ENTRIES IN mt_delivery
       WHERE vbeln = mt_delivery-vbeln.

    ENDIF.

    LOOP AT mt_delivery ASSIGNING FIELD-SYMBOL(<ls_delivery>).

*     Delivery Header Status
      READ TABLE lt_likp INTO DATA(ls_likp) WITH KEY vbeln = <ls_delivery>-vbeln.
      IF sy-subrc = 0.
        MOVE-CORRESPONDING ls_likp TO ls_vbuk.
        APPEND ls_vbuk TO <ls_delivery>-vbuk.
        CLEAR ls_vbuk.
      ENDIF.

*     copy selected delivery header
      <ls_delivery>-likp  = VALUE #( lt_likp[ KEY primary_key
                                              COMPONENTS vbeln = <ls_delivery>-vbeln ]
                                       DEFAULT VALUE #( vbeln = <ls_delivery>-vbeln ) ).

*     Copy document flow data
      LOOP AT lt_vbfa INTO DATA(ls_vbfa) USING KEY primary_key
        WHERE vbeln = <ls_delivery>-vbeln.
        APPEND ls_vbfa TO <ls_delivery>-vbfa.
      ENDLOOP.

*     copy selected delivery items
      LOOP AT lt_lips ASSIGNING FIELD-SYMBOL(<ls_lips>)
        USING KEY primary_key
        WHERE vbeln = <ls_delivery>-vbeln.

        APPEND <ls_lips> TO <ls_delivery>-lips.

*       Delivery Item Status
        MOVE-CORRESPONDING <ls_lips> TO ls_vbup.
        APPEND ls_vbup TO <ls_delivery>-vbup.
        CLEAR:
          ls_vbup.
      ENDLOOP.

*     Check if there is any freight unit assigned to the delivery
      <ls_delivery>-fu_relevant = abap_false.

      CLEAR lv_base_btd_id.
      lv_base_btd_id = |{ <ls_delivery>-vbeln ALPHA = IN }|.
      LOOP AT mt_fu_info INTO DATA(ls_fu_info)
        WHERE base_btd_id  = lv_base_btd_id
          AND lifecycle <> /scmtms/if_tor_status_c=>sc_root-lifecycle-v_canceled.
        <ls_delivery>-fu_relevant = abap_true.
        EXIT.
      ENDLOOP.

    ENDLOOP.

  ENDMETHOD.


  METHOD fill_delivery_item_data.

    DATA:
      ls_delivery_item TYPE zif_gtt_sof_ctp_types=>ts_delivery_item,
      lt_likp          TYPE HASHED TABLE OF likp WITH UNIQUE KEY vbeln,
      lt_lips          TYPE SORTED TABLE OF lipsvb WITH UNIQUE KEY vbeln posnr,
      lt_vbfa          TYPE STANDARD TABLE OF vbfavb,
      ls_vbuk          TYPE vbukvb,
      ls_lips          TYPE lipsvb,
      lv_base_btd_id   TYPE /scmtms/base_btd_id.

    CLEAR:mt_delivery_item.

    LOOP AT mt_delivery_item_chng ASSIGNING FIELD-SYMBOL(<ls_delivery_chng>).
      READ TABLE mt_delivery_item ASSIGNING FIELD-SYMBOL(<ls_delivery_item>)
        WITH KEY vbeln = <ls_delivery_chng>-vbeln
                 posnr = <ls_delivery_chng>-posnr.

      IF sy-subrc <> 0.
        CLEAR: ls_delivery_item.
        ls_delivery_item-vbeln  = <ls_delivery_chng>-vbeln.
        ls_delivery_item-posnr  = <ls_delivery_chng>-posnr.
        APPEND ls_delivery_item TO mt_delivery_item.

        ASSIGN mt_delivery_item[ vbeln = <ls_delivery_chng>-vbeln posnr = <ls_delivery_chng>-posnr ] TO <ls_delivery_item>.
      ENDIF.

      IF <ls_delivery_item> IS ASSIGNED.
        <ls_delivery_item>-fu_list  = VALUE #( BASE <ls_delivery_item>-fu_list (
          tor_id        = <ls_delivery_chng>-tor_id
          item_id       = <ls_delivery_chng>-item_id
          quantity      = <ls_delivery_chng>-quantity
          quantityuom   = <ls_delivery_chng>-quantityuom
          product_id    = <ls_delivery_chng>-product_id
          product_descr = <ls_delivery_chng>-product_descr
          change_mode   = <ls_delivery_chng>-change_mode
          base_uom_val  = <ls_delivery_chng>-base_uom_val
          base_uom_uni  = <ls_delivery_chng>-base_uom_uni
        ) ).

        UNASSIGN <ls_delivery_item>.
      ENDIF.
    ENDLOOP.

    IF mt_delivery_item IS NOT INITIAL.
      SELECT *
        INTO CORRESPONDING FIELDS OF TABLE lt_likp
        FROM likp
        FOR ALL ENTRIES IN mt_delivery_item
        WHERE vbeln = mt_delivery_item-vbeln.

      SELECT *
        INTO CORRESPONDING FIELDS OF TABLE lt_lips
        FROM lips
        FOR ALL ENTRIES IN mt_delivery_item
        WHERE vbeln = mt_delivery_item-vbeln
          AND posnr = mt_delivery_item-posnr.

      SELECT *
        INTO CORRESPONDING FIELDS OF TABLE lt_vbfa
        FROM vbfa
        FOR ALL ENTRIES IN mt_delivery_item
       WHERE vbeln = mt_delivery_item-vbeln.

      LOOP AT mt_delivery_item ASSIGNING <ls_delivery_item>.
        " copy selected delivery header
        <ls_delivery_item>-likp  = VALUE #(
          lt_likp[ KEY primary_key
                   COMPONENTS vbeln = <ls_delivery_item>-vbeln ]
          DEFAULT VALUE #( vbeln = <ls_delivery_item>-vbeln )
        ).

        " copy selected delivery item
        <ls_delivery_item>-lips  = VALUE #(
          lt_lips[ KEY primary_key
                   COMPONENTS vbeln = <ls_delivery_item>-vbeln
                              posnr = <ls_delivery_item>-posnr ]
          DEFAULT VALUE #( vbeln = <ls_delivery_item>-vbeln
                           posnr = <ls_delivery_item>-posnr )
        ).

*       Delivery Header Status
        READ TABLE lt_likp INTO DATA(ls_likp) WITH KEY vbeln = <ls_delivery_item>-vbeln.
        IF sy-subrc = 0.
          MOVE-CORRESPONDING ls_likp TO <ls_delivery_item>-vbuk.
        ENDIF.

*       Delivery Item Status
        LOOP AT lt_lips ASSIGNING FIELD-SYMBOL(<ls_lips>)
          USING KEY primary_key
          WHERE vbeln = <ls_delivery_item>-vbeln
            AND posnr = <ls_delivery_item>-posnr.

          MOVE-CORRESPONDING <ls_lips> TO <ls_delivery_item>-vbup.
        ENDLOOP.

*       Copy document flow data
        LOOP AT lt_vbfa INTO DATA(ls_vbfa) USING KEY primary_key
          WHERE vbeln = <ls_delivery_item>-vbeln
            AND posnn = <ls_delivery_item>-posnr.
          APPEND ls_vbfa TO <ls_delivery_item>-vbfa.
        ENDLOOP.

      ENDLOOP.
    ENDIF.

  ENDMETHOD.


  method FILL_IDOC_APPOBJ_CTABS.

    cs_idoc_data-appobj_ctabs = VALUE #( BASE cs_idoc_data-appobj_ctabs (
      trxservername = cs_idoc_data-trxserv-trx_server_id
      appobjtype    = is_aotype-aot_type
      appobjid      = |{ is_likp-vbeln ALPHA = OUT }|
    ) ).

  endmethod.


  METHOD FILL_IDOC_CONTROL_DATA.

    DATA: lt_control TYPE /saptrx/bapi_trk_control_tab,
          lv_count   TYPE i VALUE 0.

    lt_control  = VALUE #(
      (
        paramname = cs_mapping-vbeln
        value     = |{ is_delivery-vbeln ALPHA = OUT }|
      )
      (
        paramname = cs_mapping-fu_relevant
        value     = is_delivery-fu_relevant
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
      (
        paramname = zif_gtt_sof_ctp_tor_constants=>cs_system_fields-reported_by
        value     = sy-uname
      )
    ).

    " fill technical data into all control data records
    LOOP AT lt_control ASSIGNING FIELD-SYMBOL(<ls_control>).
      <ls_control>-appsys     = mv_appsys.
      <ls_control>-appobjtype = is_aotype-aot_type.
      <ls_control>-appobjid   = |{ is_delivery-vbeln ALPHA = OUT }|.
    ENDLOOP.

    cs_idoc_data-control  = VALUE #( BASE cs_idoc_data-control
                                     ( LINES OF lt_control ) ).

  ENDMETHOD.


  METHOD FILL_IDOC_EXP_EVENT.

    DATA: lt_exp_event TYPE /saptrx/bapi_trk_ee_tab.

    " do not retrieve planned events when DLV is not stored in DB yet
    " (this is why all the fields of LIKP are empty, except VBELN)
    IF is_delivery-likp-lfart IS NOT INITIAL AND
       is_delivery-lips[] IS NOT INITIAL AND
       is_delivery-vbuk[] IS NOT INITIAL AND
       is_delivery-vbup[] IS NOT INITIAL AND
       is_delivery-vbfa[] IS NOT INITIAL.

      TRY.
          zcl_gtt_sof_tm_tools=>get_delivery_head_planned_evt(
            EXPORTING
              iv_appsys    = mv_appsys
              is_aotype    = is_aotype
              is_likp      = CORRESPONDING #( is_delivery-likp )
              it_lips      = CORRESPONDING #( is_delivery-lips )
              it_vbuk      = CORRESPONDING #( is_delivery-vbuk )
              it_vbup      = CORRESPONDING #( is_delivery-vbup )
              it_vbfa      = CORRESPONDING #( is_delivery-vbfa )
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
            <ls_exp_event>-appobjid       = |{ is_delivery-vbeln ALPHA = OUT }|.
            <ls_exp_event>-language       = sy-langu.
            IF <ls_exp_event>-evt_exp_tzone IS INITIAL.
              <ls_exp_event>-evt_exp_tzone  = zcl_gtt_sof_tm_tools=>get_system_time_zone( ).
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


  METHOD FILL_IDOC_TRACKING_ID.

    DATA:
      lv_dlvhdtrxcod     TYPE /saptrx/trxcod.

    lv_dlvhdtrxcod = zif_gtt_sof_constants=>cs_trxcod-out_delivery.

    " Delivery Header
    cs_idoc_data-tracking_id  = VALUE #( BASE cs_idoc_data-tracking_id (
      appsys      = mv_appsys
      appobjtype  = is_aotype-aot_type
      appobjid    = |{ is_delivery-vbeln ALPHA = OUT }|
      trxcod      = lv_dlvhdtrxcod
      trxid       = |{ is_delivery-vbeln ALPHA = OUT }|
    ) ).

  ENDMETHOD.


  method FILL_IDOC_TRXSERV.

    SELECT SINGLE *
      INTO cs_idoc_data-trxserv
      FROM /saptrx/trxserv
      WHERE trx_server_id = is_aotype-server_name.

  endmethod.


  METHOD GET_DLV_ITEM_BASED_ON_TOR_ITEM.

    DATA ls_delivery_item TYPE zif_gtt_sof_ctp_types=>ts_delivery_chng.

    LOOP AT mt_tor_item ASSIGNING FIELD-SYMBOL(<ls_tor_item>)
      WHERE base_btd_tco = mv_base_btd_tco AND
            ( change_mode = /bobf/if_frw_c=>sc_modify_delete OR
              change_mode = /bobf/if_frw_c=>sc_modify_create ) AND
              base_btd_id IS NOT INITIAL AND
              base_btditem_id IS NOT INITIAL AND
             item_cat = /scmtms/if_tor_const=>sc_tor_item_category-product.

      ASSIGN mt_tor_root[ node_id = <ls_tor_item>-parent_node_id ] TO FIELD-SYMBOL(<ls_tor_root>).
      IF sy-subrc = 0 AND
         <ls_tor_root>-tor_cat = /scmtms/if_tor_const=>sc_tor_category-freight_unit.

        add_delivery_item(
          EXPORTING
            is_tor_root      = <ls_tor_root>
            is_tor_item      = <ls_tor_item>
            iv_change_mode   = <ls_tor_item>-change_mode
          CHANGING
            ct_delivery_item = ct_delivery_item ).
      ENDIF.
    ENDLOOP.

  ENDMETHOD.


  METHOD get_dlv_item_based_on_tor_root.

    LOOP AT mt_tor_root ASSIGNING FIELD-SYMBOL(<ls_tor_root>)
      WHERE tor_cat = /scmtms/if_tor_const=>sc_tor_category-freight_unit
        AND base_btd_tco = mv_base_btd_tco.

      add_delivery_items_by_tor_root(
        EXPORTING
          is_tor_root      = <ls_tor_root>
          iv_change_mode   = <ls_tor_root>-change_mode
        CHANGING
          ct_delivery_item = ct_delivery_item ).
    ENDLOOP.

  ENDMETHOD.


  METHOD GET_DLV_ITEM_BASED_ON_TOR_STOP.

    DATA lv_tabix TYPE sy-tabix.

    LOOP AT mt_tor_stop ASSIGNING FIELD-SYMBOL(<ls_tor_stop>)
      GROUP BY ( parent_node_id = <ls_tor_stop>-parent_node_id
                 group_size     = GROUP SIZE ) ASSIGNING FIELD-SYMBOL(<lt_group>).

      LOOP AT GROUP <lt_group> ASSIGNING FIELD-SYMBOL(<ls_tor_stop_current>).
        lv_tabix += 1.
        CHECK lv_tabix = <lt_group>-group_size.

        ASSIGN mt_tor_stop_before[ node_id = <ls_tor_stop_current>-node_id ] TO FIELD-SYMBOL(<ls_tor_stop_before>).
        CHECK ( sy-subrc = 0 AND <ls_tor_stop_current>-log_locid <> <ls_tor_stop_before>-log_locid ) OR sy-subrc <> 0.

        " Freight Unit destination was changed => send IDOC
        ASSIGN mt_tor_root[ node_id = <ls_tor_stop_current>-parent_node_id ] TO FIELD-SYMBOL(<ls_tor_root>).
        CHECK sy-subrc = 0 AND <ls_tor_root>-tor_cat = /scmtms/if_tor_const=>sc_tor_category-freight_unit.

        add_delivery_items_by_tor_root(
          EXPORTING
            is_tor_root      = <ls_tor_root>
            iv_change_mode   = <ls_tor_root>-change_mode
          CHANGING
            ct_delivery_item = ct_delivery_item ).
      ENDLOOP.

      CLEAR lv_tabix.
    ENDLOOP.

  ENDMETHOD.


  METHOD INITIATE_AOTYPES.
    DATA:
      lt_aotype TYPE zif_gtt_ctp_types=>tt_aotype_rst.

    SELECT rst_option AS option,
           rst_sign   AS sign,
           rst_low    AS low,
           rst_high   AS high
      INTO CORRESPONDING FIELDS OF TABLE @lt_aotype
      FROM zgtt_aotype_rst
     WHERE rst_id = @iv_rst_id.

    " Prepare AOT list
    IF lt_aotype IS NOT INITIAL.
      SELECT trk_obj_type  AS obj_type
             aotype        AS aot_type
             trxservername AS server_name
        INTO TABLE mt_aotype
        FROM /saptrx/aotypes
        WHERE trk_obj_type  = zif_gtt_ef_constants=>cs_trk_obj_type-esc_deliv
          AND aotype       IN lt_aotype
          AND torelevant    = abap_true.

      IF sy-subrc <> 0.
        MESSAGE e008(zgtt) INTO DATA(lv_dummy).
      ENDIF.
    ENDIF.

  ENDMETHOD.


  METHOD IS_EXTRACTOR_EXIST.

    DATA: lv_trk_obj_type  TYPE /saptrx/aotypes-trk_obj_type.

    SELECT SINGLE trk_obj_type
      INTO lv_trk_obj_type
      FROM /saptrx/aotypes
      WHERE trk_obj_type = iv_trk_obj_type
        AND torelevant   = abap_true.

    rv_result   = boolc( sy-subrc = 0 ).

  ENDMETHOD.


  METHOD is_gtt_enabled.

    DATA: lv_extflag      TYPE flag.

    rv_result   = abap_false.

*   Check package dependent BADI disabling
    CALL FUNCTION 'GET_R3_EXTENSION_SWITCH'
      EXPORTING
        i_structure_package = zif_gtt_ef_constants=>cv_structure_pkg
      IMPORTING
        e_active            = lv_extflag
      EXCEPTIONS
        not_existing        = 1
        object_not_existing = 2
        no_extension_object = 3
        OTHERS              = 4.

    IF sy-subrc = 0 AND lv_extflag = abap_true.
*     Check if any tracking server defined
      CALL FUNCTION '/SAPTRX/EVENT_MGR_CHECK'
        EXCEPTIONS
          no_event_mgr_available = 1
          OTHERS                 = 2.

*     Check whether at least 1 active extractor exists for every object
      IF sy-subrc = 0.
        IF is_extractor_exist( iv_trk_obj_type = iv_trk_obj_type ) = abap_false.
          rv_result   = abap_false.
        ELSE.
          rv_result   = abap_true.
        ENDIF.
      ENDIF.
    ENDIF.

  ENDMETHOD.


  METHOD PREPARE_IDOC_DATA.

    DATA:
      ls_idoc_data    TYPE zif_gtt_sof_ctp_types=>ts_idoc_data.

    LOOP AT mt_aotype ASSIGNING FIELD-SYMBOL(<ls_aotype>).
      CLEAR: ls_idoc_data.

      ls_idoc_data-appsys   = mv_appsys.

      fill_idoc_trxserv(
        EXPORTING
          is_aotype    = <ls_aotype>
        CHANGING
          cs_idoc_data = ls_idoc_data ).

      LOOP AT mt_delivery ASSIGNING FIELD-SYMBOL(<ls_dlv>).

        IF <ls_dlv>-likp-lfart IS INITIAL. " Skip cross TP if DLV not stored in DB
          CONTINUE.
        ENDIF.

        fill_idoc_appobj_ctabs(
          EXPORTING
            is_aotype    = <ls_aotype>
            is_likp      = <ls_dlv>
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


  METHOD SEND_IDOC_DATA.

    DATA:
      lt_bapiret1 TYPE bapiret2_t,
      lt_bapiret2 TYPE bapiret2_t.

    LOOP AT mt_idoc_data ASSIGNING FIELD-SYMBOL(<ls_idoc_data>).
      CLEAR: lt_bapiret1[], lt_bapiret2[].

      /saptrx/cl_send_idocs=>send_idoc_ehpost01(
        EXPORTING
          it_control      = <ls_idoc_data>-control
          it_info         = <ls_idoc_data>-info
          it_tracking_id  = <ls_idoc_data>-tracking_id
          it_exp_event    = <ls_idoc_data>-exp_event
          is_trxserv      = <ls_idoc_data>-trxserv
          iv_appsys       = <ls_idoc_data>-appsys
          it_appobj_ctabs = <ls_idoc_data>-appobj_ctabs
          iv_upd_task     = 'X'
        IMPORTING
          et_bapireturn   = lt_bapiret1 ).

      " when GTT.2 version
      IF /saptrx/cl_send_idocs=>st_idoc_data[] IS NOT INITIAL.
        /saptrx/cl_send_idocs=>send_idoc_gttmsg01(
          IMPORTING
            et_bapireturn = lt_bapiret2 ).
      ENDIF.

      " collect messages, if it is necessary
      IF et_bapiret IS REQUESTED.
        et_bapiret    = VALUE #( BASE et_bapiret
                                 ( LINES OF lt_bapiret1 )
                                 ( LINES OF lt_bapiret2 ) ).
      ENDIF.
    ENDLOOP.

  ENDMETHOD.


  METHOD zif_gtt_ctp_tor_to_dl~check_relevance.

    DATA:
      lt_fu_db TYPE /scmtms/t_tor_root_k.

    CLEAR:
      rv_result,
      mt_delivery_item_chng.

    get_dlv_item_based_on_tor_root(
      CHANGING
        ct_delivery_item = mt_delivery_item_chng ).

    get_dlv_item_based_on_tor_stop(
      CHANGING
        ct_delivery_item = mt_delivery_item_chng ).

    check_fu_status(
      IMPORTING
        et_delivery_info = DATA(lt_delivery_info) ).

    LOOP AT mt_delivery_item_chng INTO DATA(ls_delivery_item_chng).
      READ TABLE lt_delivery_info INTO DATA(ls_delivery_info)
        WITH KEY vbeln = ls_delivery_item_chng-vbeln.
      IF sy-subrc = 0.
        IF ls_delivery_info-process_flg = abap_false.
          DELETE mt_delivery_item_chng WHERE vbeln = ls_delivery_info-vbeln.
        ENDIF.
      ENDIF.
    ENDLOOP.

    IF mt_delivery_item_chng IS NOT INITIAL.
      rv_result = zif_gtt_sts_ef_constants=>cs_condition-true.
    ENDIF.

  ENDMETHOD.


  METHOD ZIF_GTT_CTP_TOR_TO_DL~EXTRACT_DATA.

    fill_delivery_header_data( ).

  ENDMETHOD.


  METHOD zif_gtt_ctp_tor_to_dl~initiate.

    CLEAR rv_error_flag.

    mt_tor_root        = it_tor_root.
    mt_tor_root_before = it_tor_root_before.
    mt_tor_item        = it_tor_item.
    mt_tor_item_before = it_tor_item_before.
    mt_tor_stop        = it_tor_stop.
    mt_tor_stop_before = it_tor_stop_before.
    mt_fu_info         = it_fu_info.

    IF is_gtt_enabled( iv_trk_obj_type = zif_gtt_ef_constants=>cs_trk_obj_type-esc_deliv ) = abap_false.
      rv_error_flag = abap_true.
      RETURN.
    ENDIF.

*   Get current logical system
    CALL FUNCTION 'OWN_LOGICAL_SYSTEM_GET'
      IMPORTING
        own_logical_system             = mv_appsys
      EXCEPTIONS
        own_logical_system_not_defined = 1
        OTHERS                         = 2.

    IF sy-subrc <> 0.
      MESSAGE e007(zgtt_ssof) INTO DATA(lv_dummy).
      rv_error_flag = abap_true.
      RETURN.
    ENDIF.

*   Get Restriction ID
    get_aotype_restriction_id(
      RECEIVING
        rv_rst_id = DATA(lv_rst_id) ).

    initiate_aotypes( iv_rst_id = lv_rst_id ).

*   Get Base Document Type
    LOOP AT mt_tor_root ASSIGNING FIELD-SYMBOL(<ls_tor_root>)
      WHERE tor_cat = /scmtms/if_tor_const=>sc_tor_category-freight_unit
        AND ( base_btd_tco = /scmtms/if_common_c=>c_btd_tco-outbounddelivery
         OR base_btd_tco = /scmtms/if_common_c=>c_btd_tco-inbounddelivery ).
      mv_base_btd_tco = <ls_tor_root>-base_btd_tco.
      EXIT.
    ENDLOOP.

  ENDMETHOD.


  METHOD ZIF_GTT_CTP_TOR_TO_DL~PROCESS_DATA.

    prepare_idoc_data( ).

    send_idoc_data(
      IMPORTING
        et_bapiret = et_bapiret ).

    clear_data( ).

  ENDMETHOD.


  METHOD check_fu_status.

    DATA:
      lt_delivery           TYPE tt_delivery,
      ls_delivery           TYPE ts_delivery,
      lt_delivery_info      TYPE tt_delivery_info,
      ls_delivery_info      TYPE ts_delivery_info,
      lv_delivery_exist_flg TYPE flag,
      lt_fu_db              TYPE /scmtms/t_tor_root_k.

    CLEAR et_delivery_info.

    LOOP AT mt_delivery_item_chng ASSIGNING FIELD-SYMBOL(<ls_delivery_item>).
      READ TABLE lt_delivery TRANSPORTING NO FIELDS
        WITH KEY vbeln = <ls_delivery_item>-vbeln.
      IF sy-subrc <> 0.
        ls_delivery-vbeln = <ls_delivery_item>-vbeln.
        APPEND ls_delivery TO lt_delivery.
        CLEAR ls_delivery.
      ENDIF.
    ENDLOOP.

    LOOP AT lt_delivery INTO ls_delivery.
      CLEAR ls_delivery_info.
      LOOP AT mt_delivery_item_chng INTO DATA(ls_delivery_item)
        WHERE vbeln = ls_delivery-vbeln.
        APPEND ls_delivery_item TO ls_delivery_info-dlv_items.
        APPEND ls_delivery_item-tor_id TO ls_delivery_info-tor_id.
      ENDLOOP.
      IF ls_delivery_info IS NOT INITIAL.
        ls_delivery_info-vbeln = ls_delivery-vbeln.
        SORT ls_delivery_info-tor_id BY table_line.
        DELETE ADJACENT DUPLICATES FROM ls_delivery_info-tor_id COMPARING ALL FIELDS.
        APPEND ls_delivery_info TO lt_delivery_info.
      ENDIF.
    ENDLOOP.

    LOOP AT lt_delivery_info ASSIGNING FIELD-SYMBOL(<fs_delivery_info>).
      CLEAR:
        lv_delivery_exist_flg,
        lt_fu_db.

      <fs_delivery_info>-process_flg = abap_false.

      SELECT COUNT(*)
        FROM likp
       WHERE vbeln = <fs_delivery_info>-vbeln.
      IF sy-dbcnt > 0.
        lv_delivery_exist_flg = abap_true.
      ENDIF.

      zcl_gtt_sof_toolkit=>get_fu_from_db(
        EXPORTING
          it_tor_id = <fs_delivery_info>-tor_id
        IMPORTING
          et_fu     = lt_fu_db ).

*     DLV in DB,TOR not in DB(new TOR), send the IDOC
      IF lv_delivery_exist_flg IS NOT INITIAL AND lt_fu_db IS INITIAL.
        <fs_delivery_info>-process_flg = abap_true.

*     DLV in DB,TOR in DB,and TOR in progress, do not sent out IDOC
*     FU is deleted or canceled, send the IDOC
      ELSEIF lv_delivery_exist_flg IS NOT INITIAL AND lt_fu_db IS NOT INITIAL.

        determine_process_flag(
          EXPORTING
            it_tor_id      = <fs_delivery_info>-tor_id
            it_fu_db       = lt_fu_db
          IMPORTING
            ev_process_flg = <fs_delivery_info>-process_flg ).

      ENDIF.

    ENDLOOP.

    et_delivery_info = lt_delivery_info.

  ENDMETHOD.


  METHOD DETERMINE_PROCESS_FLAG.

    DATA:
      lv_all_fu_in_db_flg   TYPE flag.

    CLEAR ev_process_flg.

    LOOP AT it_tor_id INTO DATA(ls_tor_id).
      READ TABLE it_fu_db TRANSPORTING NO FIELDS
        WITH KEY tor_id COMPONENTS tor_id = ls_tor_id.
      IF sy-subrc = 0.
        lv_all_fu_in_db_flg = abap_true.
      ELSE.
        lv_all_fu_in_db_flg = abap_false.
      ENDIF.
    ENDLOOP.

    IF lv_all_fu_in_db_flg = abap_true.
      LOOP AT it_tor_id INTO ls_tor_id.
        READ TABLE mt_tor_root INTO DATA(ls_tor_root)
          WITH KEY tor_id = ls_tor_id.
        IF sy-subrc = 0.
*         FU is deleted or canceled, send the IDOC
          IF ( ls_tor_root-change_mode = /bobf/if_frw_c=>sc_modify_delete
            OR ls_tor_root-lifecycle   = /scmtms/if_tor_status_c=>sc_root-lifecycle-v_canceled ).
            ev_process_flg = abap_true.
            EXIT.
          ENDIF.
        ENDIF.
      ENDLOOP.
    ELSE.
      ev_process_flg = abap_true.
    ENDIF.

  ENDMETHOD.
ENDCLASS.
