class ZCL_GTT_CTP_TOR_TO_DL_BASE definition
  public
  abstract
  create public .

public section.

  interfaces ZIF_GTT_CTP_TOR_TO_DL .
PROTECTED SECTION.

  DATA mv_appsys TYPE logsys .
  DATA mv_base_btd_tco TYPE /scmtms/base_btd_tco .
  DATA mt_aotype TYPE zif_gtt_ctp_types=>tt_aotype .
  DATA mt_tor_root TYPE /scmtms/t_em_bo_tor_root .
  DATA mt_tor_root_before TYPE /scmtms/t_em_bo_tor_root .
  DATA mt_tor_item TYPE /scmtms/t_em_bo_tor_item .
  DATA mt_tor_item_before TYPE /scmtms/t_em_bo_tor_item .
  DATA mt_tor_stop TYPE /scmtms/t_em_bo_tor_stop .
  DATA mt_tor_stop_before TYPE /scmtms/t_em_bo_tor_stop .
  DATA mt_delivery_item_chng TYPE zif_gtt_sof_ctp_types=>tt_delivery_chng .
  DATA mt_delivery TYPE zif_gtt_sof_ctp_types=>tt_delivery .
  CONSTANTS:
    BEGIN OF cs_mapping,
      vbeln                 TYPE /saptrx/paramname VALUE 'YN_DLV_NO',
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
      appsys                TYPE /saptrx/paramname VALUE 'E1EHPTID_APPSYS',
      trxcod                TYPE /saptrx/paramname VALUE 'E1EHPTID_TRXCOD',
      trxid                 TYPE /saptrx/paramname VALUE 'E1EHPTID_TRXID',
      action                TYPE /saptrx/paramname VALUE 'E1EHPTID_ACTION',
    END OF cs_mapping .
  DATA mt_idoc_data TYPE zif_gtt_sof_ctp_types=>tt_idoc_data .
  DATA mt_delivery_item TYPE zif_gtt_sof_ctp_types=>tt_delivery_item .
  DATA mt_fu_info TYPE /scmtms/t_tor_root_k .

  METHODS get_aotype_restriction_id
    ABSTRACT
    RETURNING
      VALUE(rv_rst_id) TYPE zgtt_rst_id .
  METHODS initiate_aotypes
    IMPORTING
      !iv_rst_id TYPE zgtt_rst_id .
  METHODS is_gtt_enabled
    IMPORTING
      !iv_trk_obj_type TYPE /saptrx/trk_obj_type
    RETURNING
      VALUE(rv_result) TYPE flag .
  METHODS is_extractor_exist
    IMPORTING
      !iv_trk_obj_type TYPE /saptrx/trk_obj_type
    RETURNING
      VALUE(rv_result) TYPE abap_bool .
  METHODS get_dlv_item_based_on_tor_root
    CHANGING
      !ct_delivery_item TYPE zif_gtt_sof_ctp_types=>tt_delivery_chng .
  METHODS add_delivery_items_by_tor_root
    IMPORTING
      !is_tor_root      TYPE /scmtms/s_em_bo_tor_root
      !iv_change_mode   TYPE /bobf/conf_change_mode
    CHANGING
      !ct_delivery_item TYPE zif_gtt_sof_ctp_types=>tt_delivery_chng .
  METHODS add_delivery_item
    IMPORTING
      !is_tor_root      TYPE /scmtms/s_em_bo_tor_root
      !is_tor_item      TYPE /scmtms/s_em_bo_tor_item
      !iv_change_mode   TYPE /bobf/conf_change_mode
    CHANGING
      !ct_delivery_item TYPE zif_gtt_sof_ctp_types=>tt_delivery_chng .
  METHODS get_dlv_item_based_on_tor_item
    CHANGING
      !ct_delivery_item TYPE zif_gtt_sof_ctp_types=>tt_delivery_chng .
  METHODS get_dlv_item_based_on_tor_stop
    CHANGING
      !ct_delivery_item TYPE zif_gtt_sof_ctp_types=>tt_delivery_chng .
  METHODS fill_delivery_header_data .
  METHODS prepare_idoc_data
    RAISING
      cx_udm_message .
  METHODS fill_idoc_trxserv
    IMPORTING
      !is_aotype    TYPE zif_gtt_sof_ctp_types=>ts_aotype
    CHANGING
      !cs_idoc_data TYPE zif_gtt_sof_ctp_types=>ts_idoc_data .
  METHODS fill_idoc_appobj_ctabs
    IMPORTING
      !is_aotype              TYPE zif_gtt_sof_ctp_types=>ts_aotype
      VALUE(is_likp)          TYPE zif_gtt_sof_ctp_types=>ts_delivery OPTIONAL
      VALUE(is_delivery_item) TYPE zif_gtt_sof_ctp_types=>ts_delivery_item OPTIONAL
    CHANGING
      !cs_idoc_data           TYPE zif_gtt_sof_ctp_types=>ts_idoc_data .
  METHODS fill_idoc_control_data
    IMPORTING
      !is_aotype              TYPE zif_gtt_sof_ctp_types=>ts_aotype
      VALUE(is_delivery)      TYPE zif_gtt_sof_ctp_types=>ts_delivery OPTIONAL
      VALUE(is_delivery_item) TYPE zif_gtt_sof_ctp_types=>ts_delivery_item OPTIONAL
    CHANGING
      !cs_idoc_data           TYPE zif_gtt_sof_ctp_types=>ts_idoc_data
    RAISING
      cx_udm_message .
  METHODS fill_idoc_exp_event
    IMPORTING
      !is_aotype         TYPE zif_gtt_sof_ctp_types=>ts_aotype
      VALUE(is_delivery) TYPE zif_gtt_sof_ctp_types=>ts_delivery OPTIONAL
      VALUE(is_dlv_item) TYPE zif_gtt_sof_ctp_types=>ts_delivery_item OPTIONAL
    CHANGING
      !cs_idoc_data      TYPE zif_gtt_sof_ctp_types=>ts_idoc_data
    RAISING
      cx_udm_message .
  METHODS fill_idoc_tracking_id
    IMPORTING
      !is_aotype              TYPE zif_gtt_sof_ctp_types=>ts_aotype
      VALUE(is_delivery)      TYPE zif_gtt_sof_ctp_types=>ts_delivery OPTIONAL
      VALUE(is_delivery_item) TYPE zif_gtt_sof_ctp_types=>ts_delivery_item OPTIONAL
    CHANGING
      !cs_idoc_data           TYPE zif_gtt_sof_ctp_types=>ts_idoc_data
    RAISING
      cx_udm_message .
  METHODS send_idoc_data
    EXPORTING
      !et_bapiret TYPE bapiret2_t .
  METHODS fill_delivery_item_data .
  METHODS clear_data .
private section.
ENDCLASS.



CLASS ZCL_GTT_CTP_TOR_TO_DL_BASE IMPLEMENTATION.


  METHOD ADD_DELIVERY_ITEM.

    DATA: ls_delivery_item TYPE zif_gtt_sof_ctp_types=>ts_delivery_chng.

    ls_delivery_item-vbeln        = |{ is_tor_item-base_btd_id ALPHA = IN }|.
    ls_delivery_item-posnr        = is_tor_item-base_btditem_id.
    ls_delivery_item-tor_id       = is_tor_root-tor_id.
    ls_delivery_item-item_id      = is_tor_item-item_id.
    ls_delivery_item-quantity     = is_tor_item-qua_pcs_val.

    zcl_gtt_sof_toolkit=>convert_unit_output(
      EXPORTING
        iv_input  = is_tor_item-qua_pcs_uni
      RECEIVING
        rv_output = ls_delivery_item-quantityuom ).

    ls_delivery_item-product_id   = is_tor_item-product_id.
    ls_delivery_item-product_descr = is_tor_item-item_descr.
    ls_delivery_item-change_mode  = iv_change_mode.

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
      CLEAR lv_base_btd_id.
      lv_base_btd_id = |{ <ls_delivery>-vbeln ALPHA = IN }|.
      READ TABLE mt_fu_info TRANSPORTING NO FIELDS
        WITH KEY base_btd_id  = lv_base_btd_id.
      IF sy-subrc = 0.
        <ls_delivery>-fu_relevant = abap_true.
      ENDIF.

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


  METHOD GET_DLV_ITEM_BASED_ON_TOR_ROOT.

    LOOP AT mt_tor_root ASSIGNING FIELD-SYMBOL(<ls_tor_root>)
      WHERE tor_cat = /scmtms/if_tor_const=>sc_tor_category-freight_unit
        AND base_btd_tco = mv_base_btd_tco.

      IF <ls_tor_root>-change_mode = /bobf/if_frw_c=>sc_modify_delete.
        add_delivery_items_by_tor_root(
          EXPORTING
            is_tor_root      = <ls_tor_root>
            iv_change_mode   = /bobf/if_frw_c=>sc_modify_delete
          CHANGING
            ct_delivery_item = ct_delivery_item ).
        CONTINUE.
      ENDIF.

      ASSIGN mt_tor_root_before[ node_id = <ls_tor_root>-node_id ] TO FIELD-SYMBOL(<ls_tor_root_before>).
      IF sy-subrc = 0.
        CHECK <ls_tor_root_before>-base_btd_tco <> mv_base_btd_tco.

        add_delivery_items_by_tor_root(
          EXPORTING
            is_tor_root      = <ls_tor_root>
            iv_change_mode   = /bobf/if_frw_c=>sc_modify_update
          CHANGING
            ct_delivery_item = ct_delivery_item ).
      ELSE.
        add_delivery_items_by_tor_root(
          EXPORTING
            is_tor_root      = <ls_tor_root>
            iv_change_mode   = /bobf/if_frw_c=>sc_modify_create
          CHANGING
            ct_delivery_item = ct_delivery_item ).
      ENDIF.
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
            iv_change_mode   = /bobf/if_frw_c=>sc_modify_update
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


  METHOD ZIF_GTT_CTP_TOR_TO_DL~CHECK_RELEVANCE.

    CLEAR:
      rv_result,
      mt_delivery_item_chng.

    get_dlv_item_based_on_tor_root(
      CHANGING
        ct_delivery_item = mt_delivery_item_chng ).

    get_dlv_item_based_on_tor_stop(
      CHANGING
        ct_delivery_item = mt_delivery_item_chng ).

    IF mt_delivery_item_chng IS NOT INITIAL.
      rv_result = zif_gtt_sts_ef_constants=>cs_condition-true.
    ENDIF.

  ENDMETHOD.


  METHOD ZIF_GTT_CTP_TOR_TO_DL~EXTRACT_DATA.

    fill_delivery_header_data( ).

  ENDMETHOD.


  METHOD ZIF_GTT_CTP_TOR_TO_DL~INITIATE.

    mt_tor_root        = it_tor_root.
    mt_tor_root_before = it_tor_root_before.
    mt_tor_item        = it_tor_item.
    mt_tor_item_before = it_tor_item_before.
    mt_tor_stop        = it_tor_stop.
    mt_tor_stop_before = it_tor_stop_before.
    mt_fu_info         = it_fu_info.

    IF is_gtt_enabled( iv_trk_obj_type = zif_gtt_ef_constants=>cs_trk_obj_type-esc_deliv ) = abap_false.
      MESSAGE e006(zgtt) INTO DATA(lv_dummy).
      zcl_gtt_tools=>throw_exception( ).
    ENDIF.

*   Get current logical system
    CALL FUNCTION 'OWN_LOGICAL_SYSTEM_GET'
      IMPORTING
        own_logical_system             = mv_appsys
      EXCEPTIONS
        own_logical_system_not_defined = 1
        OTHERS                         = 2.

    IF sy-subrc <> 0.
      MESSAGE e007(zgtt_ssof) INTO lv_dummy.
      zcl_gtt_sof_tm_tools=>throw_exception( ).
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
ENDCLASS.
