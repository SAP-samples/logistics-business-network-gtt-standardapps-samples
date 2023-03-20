class ZCL_GTT_SOF_CTP_TOR_CHANGES definition
  public
  create public .

public section.

  methods CONSTRUCTOR
    importing
      !IT_TOR_ROOT_SSTRING type /SCMTMS/T_EM_BO_TOR_ROOT
      !IT_TOR_ROOT_BEFORE_SSTRING type /SCMTMS/T_EM_BO_TOR_ROOT
      !IT_TOR_ITEM_SSTRING type /SCMTMS/T_EM_BO_TOR_ITEM
      !IT_TOR_ITEM_BEFORE_SSTRING type /SCMTMS/T_EM_BO_TOR_ITEM
      !IT_TOR_STOP_SSTRING type /SCMTMS/T_EM_BO_TOR_STOP
      !IT_TOR_STOP_ADDR_SSTRING type /SCMTMS/T_EM_BO_LOC_ADDR .
  methods GET_DELIVERY_ITEMS
    returning
      value(RR_DELIVERIES) type ref to DATA .
  PROTECTED SECTION.
private section.

  data MT_TOR_ROOT type /SCMTMS/T_EM_BO_TOR_ROOT .
  data MT_TOR_ROOT_BEFORE type /SCMTMS/T_EM_BO_TOR_ROOT .
  data MT_TOR_ITEM type /SCMTMS/T_EM_BO_TOR_ITEM .
  data MT_TOR_ITEM_BEFORE type /SCMTMS/T_EM_BO_TOR_ITEM .
  data MT_TOR_STOP type /SCMTMS/T_EM_BO_TOR_STOP .
  data MT_TOR_STOP_BEFORE type /SCMTMS/T_EM_BO_TOR_STOP .
  data MT_TOR_STOP_ADDR type /SCMTMS/T_EM_BO_LOC_ADDR .
  data MT_ALLOWED_FU_TYPE type ZIF_GTT_SOF_CTP_TYPES=>TT_TOR_TYPE .
  data MT_DELIVERIES type ZIF_GTT_SOF_CTP_TYPES=>TT_DELIVERY .
  data MT_DELIVERY_ITEM type ZIF_GTT_SOF_CTP_TYPES=>TT_DELIVERY_CHNG .

  methods ADD_DELIVERY_ITEM
    importing
      !IS_TOR_ROOT type /SCMTMS/S_EM_BO_TOR_ROOT
      !IS_TOR_ITEM type /SCMTMS/S_EM_BO_TOR_ITEM
      !IV_CHANGE_MODE type /BOBF/CONF_CHANGE_MODE
    changing
      !CT_DELIVERY_ITEM type ZIF_GTT_SOF_CTP_TYPES=>TT_DELIVERY_CHNG .
  methods ADD_DELIVERY_ITEMS_BY_TOR_ROOT
    importing
      !IS_TOR_ROOT type /SCMTMS/S_EM_BO_TOR_ROOT
      !IV_CHANGE_MODE type /BOBF/CONF_CHANGE_MODE
    changing
      !CT_DELIVERY_ITEM type ZIF_GTT_SOF_CTP_TYPES=>TT_DELIVERY_CHNG .
  methods CONVERT_DLV_NUMBER
    importing
      !IV_DLV_NUM type CLIKE
    returning
      value(RV_VBELN) type VBELN_VL .
  methods GET_ALLOWED_FU_TYPES
    returning
      value(RT_FU_TYPE) type ZIF_GTT_SOF_CTP_TYPES=>TT_TOR_TYPE .
  methods GET_AOTYPE_RESTRICTIONS
    exporting
      !ET_AOTYPE type ZIF_GTT_SOF_CTP_TYPES=>TT_AOTYPE_RST .
  methods GET_DLV_ITEM_BASED_ON_TOR_ROOT
    changing
      !CT_DELIVERY_ITEM type ZIF_GTT_SOF_CTP_TYPES=>TT_DELIVERY_CHNG .
  methods GET_DLV_ITEM_BASED_ON_TOR_ITEM
    changing
      !CT_DELIVERY_ITEM type ZIF_GTT_SOF_CTP_TYPES=>TT_DELIVERY_CHNG .
  methods GET_DLV_ITEM_BASED_ON_TOR_STOP
    changing
      !CT_DELIVERY_ITEM type ZIF_GTT_SOF_CTP_TYPES=>TT_DELIVERY_CHNG .
  methods GET_TOR_TYPES
    exporting
      !ET_TOR_TYPES type ZIF_GTT_SOF_CTP_TYPES=>TT_TOR_TYPE_RST .
  methods GET_TOR_STOP_BEFORE
    returning
      value(RT_TOR_STOP_BEFORE) type /SCMTMS/T_EM_BO_TOR_STOP .
  methods INIT_DELIVERIES .
ENDCLASS.



CLASS ZCL_GTT_SOF_CTP_TOR_CHANGES IMPLEMENTATION.


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
    ls_delivery_item-change_mode  = iv_change_mode.

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


  METHOD add_delivery_items_by_tor_root.

    DATA: ls_delivery_item TYPE zif_gtt_sof_ctp_types=>ts_delivery_chng.

    LOOP AT mt_tor_item ASSIGNING FIELD-SYMBOL(<ls_tor_item>)
      USING KEY item_parent WHERE parent_node_id = is_tor_root-node_id.

      IF <ls_tor_item>-base_btd_tco = zif_gtt_sof_ctp_tor_constants=>cv_base_btd_tco_outb_dlv AND
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


  METHOD CONSTRUCTOR.

    mt_tor_root        = it_tor_root_sstring.
    mt_tor_root_before = it_tor_root_before_sstring.
    mt_tor_item        = it_tor_item_sstring.
    mt_tor_item_before = it_tor_item_before_sstring.
    mt_tor_stop        = it_tor_stop_sstring.
    mt_tor_stop_addr   = it_tor_stop_addr_sstring.
    mt_tor_stop_before = get_tor_stop_before( ).

    init_deliveries( ).

  ENDMETHOD.


  METHOD CONVERT_DLV_NUMBER.

    rv_vbeln    = |{ iv_dlv_num ALPHA = IN }|.

  ENDMETHOD.


  METHOD GET_ALLOWED_FU_TYPES.

  ENDMETHOD.


  METHOD GET_AOTYPE_RESTRICTIONS.

  ENDMETHOD.


  METHOD GET_DELIVERY_ITEMS.

    rr_deliveries   = REF #( mt_delivery_item ).

  ENDMETHOD.


  METHOD GET_DLV_ITEM_BASED_ON_TOR_ITEM.

    DATA ls_delivery_item TYPE zif_gtt_sof_ctp_types=>ts_delivery_chng.

    LOOP AT mt_tor_item ASSIGNING FIELD-SYMBOL(<ls_tor_item>)
      WHERE base_btd_tco = zif_gtt_sof_ctp_tor_constants=>cv_base_btd_tco_outb_dlv AND
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
        AND base_btd_tco = zif_gtt_sof_ctp_tor_constants=>cv_base_btd_tco_outb_dlv.

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
        CHECK <ls_tor_root_before>-base_btd_tco <> zif_gtt_sof_ctp_tor_constants=>cv_base_btd_tco_outb_dlv.

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


  METHOD GET_TOR_STOP_BEFORE.

    DATA: ls_tor_stop_before TYPE /scmtms/s_em_bo_tor_stop.

    /scmtms/cl_tor_helper_stop=>get_stop_sequence(
      EXPORTING
        it_root_key     = VALUE #( FOR <ls_tor_root> IN mt_tor_root ( key = <ls_tor_root>-node_id ) )
        iv_before_image = abap_true
      IMPORTING
        et_stop_seq_d   = DATA(lt_stop_seq_d) ).

    LOOP AT lt_stop_seq_d ASSIGNING FIELD-SYMBOL(<ls_stop_seq_d>).

      LOOP AT <ls_stop_seq_d>-stop_seq ASSIGNING FIELD-SYMBOL(<ls_stop_seq>).
        DATA(lv_tabix) = sy-tabix.
        MOVE-CORRESPONDING <ls_stop_seq> TO ls_tor_stop_before.

        ls_tor_stop_before-parent_node_id = <ls_stop_seq>-root_key.

        ASSIGN <ls_stop_seq_d>-stop_map[ tabix = lv_tabix ] TO FIELD-SYMBOL(<ls_stop_map>).
        ls_tor_stop_before-node_id = <ls_stop_map>-stop_key.

        INSERT ls_tor_stop_before INTO TABLE rt_tor_stop_before.
      ENDLOOP.

    ENDLOOP.

  ENDMETHOD.


  METHOD GET_TOR_TYPES.

    et_tor_types = VALUE #(
      FOR <ls_tor_root> IN mt_tor_root
        WHERE ( tor_cat = /scmtms/if_tor_const=>sc_tor_category-freight_unit )
        ( low     = <ls_tor_root>-tor_type
          option  = 'EQ'
          sign    = 'I' )
    ).

  ENDMETHOD.


  METHOD INIT_DELIVERIES.

    CLEAR: mt_delivery_item.

    get_dlv_item_based_on_tor_root(
      CHANGING
        ct_delivery_item = mt_delivery_item ).

    get_dlv_item_based_on_tor_item(
      CHANGING
        ct_delivery_item = mt_delivery_item ).

    get_dlv_item_based_on_tor_stop(
      CHANGING
        ct_delivery_item = mt_delivery_item ).

  ENDMETHOD.
ENDCLASS.
