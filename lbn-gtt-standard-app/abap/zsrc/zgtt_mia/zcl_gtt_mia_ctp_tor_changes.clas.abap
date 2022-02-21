class ZCL_GTT_MIA_CTP_TOR_CHANGES definition
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
  PRIVATE SECTION.

    DATA mt_tor_root TYPE /scmtms/t_em_bo_tor_root .
    DATA mt_tor_root_before TYPE /scmtms/t_em_bo_tor_root .
    DATA mt_tor_item TYPE /scmtms/t_em_bo_tor_item .
    DATA mt_tor_item_before TYPE /scmtms/t_em_bo_tor_item .
    DATA mt_tor_stop TYPE /scmtms/t_em_bo_tor_stop .
    DATA mt_tor_stop_before TYPE /scmtms/t_em_bo_tor_stop .
    DATA mt_tor_stop_addr TYPE /scmtms/t_em_bo_loc_addr .
    DATA mt_allowed_fu_type TYPE zif_gtt_mia_ctp_types=>tt_tor_type .
    DATA mt_deliveries TYPE zif_gtt_mia_ctp_types=>tt_delivery .
    DATA mt_delivery_item TYPE zif_gtt_mia_ctp_types=>tt_delivery_chng .

    METHODS add_delivery_item
      IMPORTING
        !is_tor_root      TYPE /scmtms/s_em_bo_tor_root
        !is_tor_item      TYPE /scmtms/s_em_bo_tor_item
        !iv_change_mode   TYPE /bobf/conf_change_mode
      CHANGING
        !ct_delivery_item TYPE zif_gtt_mia_ctp_types=>tt_delivery_chng .
    METHODS add_delivery_items_by_tor_root
      IMPORTING
        !is_tor_root      TYPE /scmtms/s_em_bo_tor_root
        !iv_change_mode   TYPE /bobf/conf_change_mode
      CHANGING
        !ct_delivery_item TYPE zif_gtt_mia_ctp_types=>tt_delivery_chng .
    METHODS convert_dlv_number
      IMPORTING
        !iv_dlv_num     TYPE clike
      RETURNING
        VALUE(rv_vbeln) TYPE vbeln_vl .
    METHODS get_allowed_fu_types
      RETURNING
        VALUE(rt_fu_type) TYPE zif_gtt_mia_ctp_types=>tt_tor_type .
    METHODS get_aotype_restrictions
      EXPORTING
        !et_aotype TYPE zif_gtt_mia_ctp_types=>tt_aotype_rst .
    METHODS get_dlv_item_based_on_tor_root
      CHANGING
        !ct_delivery_item TYPE zif_gtt_mia_ctp_types=>tt_delivery_chng .
    METHODS get_dlv_item_based_on_tor_item
      CHANGING
        !ct_delivery_item TYPE zif_gtt_mia_ctp_types=>tt_delivery_chng .
    METHODS get_dlv_item_based_on_tor_stop
      CHANGING
        !ct_delivery_item TYPE zif_gtt_mia_ctp_types=>tt_delivery_chng .
    METHODS get_tor_types
      EXPORTING
        !et_tor_types TYPE zif_gtt_mia_ctp_types=>tt_tor_type_rst .
    METHODS get_tor_stop_before
      RETURNING
        VALUE(rt_tor_stop_before) TYPE /scmtms/t_em_bo_tor_stop .
    METHODS init_deliveries .
ENDCLASS.



CLASS ZCL_GTT_MIA_CTP_TOR_CHANGES IMPLEMENTATION.


  METHOD add_delivery_item.

    DATA: ls_delivery_item TYPE zif_gtt_mia_ctp_types=>ts_delivery_chng.

    ls_delivery_item-vbeln        = convert_dlv_number(
                                      iv_dlv_num = is_tor_item-base_btd_id ).
    ls_delivery_item-posnr        = is_tor_item-base_btditem_id.
    ls_delivery_item-tor_id       = is_tor_root-tor_id.
    ls_delivery_item-item_id      = is_tor_item-item_id.
    ls_delivery_item-quantity     = is_tor_item-qua_pcs_val.
    ls_delivery_item-quantityuom  = is_tor_item-qua_pcs_uni.
    ls_delivery_item-product_id   = is_tor_item-product_id.
    ls_delivery_item-product_descr = is_tor_item-item_descr.
    ls_delivery_item-change_mode  = iv_change_mode.

    INSERT ls_delivery_item INTO TABLE ct_delivery_item.

  ENDMETHOD.


  METHOD add_delivery_items_by_tor_root.

    DATA: ls_delivery_item TYPE zif_gtt_mia_ctp_types=>ts_delivery_chng.

    LOOP AT mt_tor_item ASSIGNING FIELD-SYMBOL(<ls_tor_item>)
      USING KEY item_parent WHERE parent_node_id = is_tor_root-node_id.

      IF <ls_tor_item>-base_btd_tco = zif_gtt_mia_ctp_tor_constants=>cv_base_btd_tco_inb_dlv AND
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


  METHOD constructor.

    mt_tor_root        = it_tor_root_sstring.
    mt_tor_root_before = it_tor_root_before_sstring.
    mt_tor_item        = it_tor_item_sstring.
    mt_tor_item_before = it_tor_item_before_sstring.
    mt_tor_stop        = it_tor_stop_sstring.
    mt_tor_stop_addr   = it_tor_stop_addr_sstring.
    mt_tor_stop_before = get_tor_stop_before( ).

    init_deliveries( ).

  ENDMETHOD.


  METHOD convert_dlv_number.

    rv_vbeln    = |{ iv_dlv_num ALPHA = IN }|.

  ENDMETHOD.


  METHOD get_allowed_fu_types.

    DATA: lt_aotype       TYPE zif_gtt_mia_ctp_types=>tt_aottype,
          lt_aotype_rst   TYPE zif_gtt_mia_ctp_types=>tt_aotype_rst,
          lt_tor_type_rst TYPE zif_gtt_mia_ctp_types=>tt_tor_type_rst.

    get_tor_types(
      IMPORTING
        et_tor_types = lt_tor_type_rst ).

    get_aotype_restrictions(
      IMPORTING
        et_aotype = lt_aotype_rst ).

    IF lt_tor_type_rst[] IS NOT INITIAL.
      SELECT type AS tor_type, aotype
        FROM /scmtms/c_torty
        INTO TABLE @lt_aotype
        WHERE type   IN @lt_tor_type_rst
          AND aotype IN @lt_aotype_rst.
    ELSE.
      CLEAR rt_fu_type.
    ENDIF.

  ENDMETHOD.


  METHOD get_aotype_restrictions.

    et_aotype = VALUE #( (
      low     = 'ZGTT_IDLV_HD_*'
      option  = 'CP'
      sign    = 'I'
    ) ).

  ENDMETHOD.


  METHOD get_delivery_items.

    rr_deliveries   = REF #( mt_delivery_item ).

  ENDMETHOD.


  METHOD get_dlv_item_based_on_tor_item.

    DATA ls_delivery_item TYPE zif_gtt_mia_ctp_types=>ts_delivery_chng.

    LOOP AT mt_tor_item ASSIGNING FIELD-SYMBOL(<ls_tor_item>)
      WHERE base_btd_tco = zif_gtt_mia_ctp_tor_constants=>cv_base_btd_tco_inb_dlv AND
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
        AND base_btd_tco = zif_gtt_mia_ctp_tor_constants=>cv_base_btd_tco_inb_dlv.

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
        CHECK <ls_tor_root_before>-base_btd_tco <> zif_gtt_mia_ctp_tor_constants=>cv_base_btd_tco_inb_dlv.

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


  METHOD get_dlv_item_based_on_tor_stop.

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


  METHOD get_tor_stop_before.

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


  METHOD get_tor_types.

    et_tor_types = VALUE #(
      FOR <ls_tor_root> IN mt_tor_root
        WHERE ( tor_cat = /scmtms/if_tor_const=>sc_tor_category-freight_unit )
        ( low     = <ls_tor_root>-tor_type
          option  = 'EQ'
          sign    = 'I' )
    ).

  ENDMETHOD.


  METHOD init_deliveries.

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
