class ZCL_GTT_MIA_TM_TOOLS definition
  public
  create public .

public section.

  class-methods GET_FORMATED_TOR_ID
    importing
      !IR_DATA type ref to DATA
    returning
      value(RV_TOR_ID) type /SCMTMS/TOR_ID
    raising
      CX_UDM_MESSAGE .
  class-methods GET_FORMATED_TOR_ITEM
    importing
      !IR_DATA type ref to DATA
    returning
      value(RV_ITEM_ID) type /SCMTMS/ITEM_ID
    raising
      CX_UDM_MESSAGE .
  class-methods GET_TOR_ROOT_TOR_ID
    importing
      !IV_KEY type /BOBF/CONF_KEY
    returning
      value(RV_TOR_ID) type /SCMTMS/TOR_ID .
  class-methods GET_TOR_ITEMS_FOR_DLV_ITEMS
    importing
      !IT_LIPS type ZIF_GTT_MIA_APP_TYPES=>TT_LIPSVB_KEY
      !IV_TOR_CAT type /SCMTMS/TOR_CATEGORY optional
    exporting
      !ET_KEY type /BOBF/T_FRW_KEY
      !ET_FU_ITEM type /SCMTMS/T_TOR_ITEM_TR_K
    raising
      CX_UDM_MESSAGE .
  class-methods IS_FU_RELEVANT
    importing
      !IT_LIPS type ZIF_GTT_MIA_APP_TYPES=>TT_LIPSVB_KEY
    returning
      value(RV_RESULT) type ABAP_BOOL
    raising
      CX_UDM_MESSAGE .
  class-methods GET_TOR_ROOT
    importing
      !IV_KEY type /BOBF/CONF_KEY
    exporting
      !ES_TOR type /SCMTMS/S_TOR_ROOT_K
    raising
      CX_UDM_MESSAGE .
  PROTECTED SECTION.
private section.

  class-methods GET_TOR_ITEM_SELPARAM_FOR_LIPS
    importing
      !IT_LIPS type ZIF_GTT_MIA_APP_TYPES=>TT_LIPSVB_KEY
    exporting
      !ET_SELPARAM type /BOBF/T_FRW_QUERY_SELPARAM .
  class-methods FILTER_TOR_ITEMS_BY_TOR_CAT
    importing
      !IV_TOR_CAT type /SCMTMS/TOR_CATEGORY
    changing
      !CT_KEY type /BOBF/T_FRW_KEY .
ENDCLASS.



CLASS ZCL_GTT_MIA_TM_TOOLS IMPLEMENTATION.


  METHOD filter_tor_items_by_tor_cat.

    DATA: lo_srv_mgr  TYPE REF TO /bobf/if_tra_service_manager,
          lt_tor_root TYPE /scmtms/t_tor_root_k,
          lv_tor_cat  TYPE /scmtms/tor_category.

    lo_srv_mgr    = /bobf/cl_tra_serv_mgr_factory=>get_service_manager(
                      /scmtms/if_tor_c=>sc_bo_key ).

    LOOP AT ct_key ASSIGNING FIELD-SYMBOL(<ls_key>).
      TRY.
          lo_srv_mgr->retrieve_by_association(
            EXPORTING
              iv_node_key             = /scmtms/if_tor_c=>sc_node-item_tr
              it_key                  = VALUE #( ( <ls_key> ) )
              iv_association          = /scmtms/if_tor_c=>sc_association-item_tr-to_parent
              iv_fill_data            = abap_true
            IMPORTING
              et_data                 = lt_tor_root ).
        CATCH /bobf/cx_frw_contrct_violation.
          CLEAR lt_tor_root.
      ENDTRY.

      lv_tor_cat  = VALUE #( lt_tor_root[ 1 ]-tor_cat OPTIONAL ).

      IF lv_tor_cat <> iv_tor_cat.
        DELETE ct_key.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.


  METHOD get_formated_tor_id.

    rv_tor_id   = zcl_gtt_tools=>get_field_of_structure(
                    ir_struct_data = ir_data
                    iv_field_name  = 'TOR_ID' ).

    rv_tor_id   = |{ rv_tor_id ALPHA = OUT }|.

  ENDMETHOD.


  METHOD get_formated_tor_item.

    rv_item_id   = zcl_gtt_tools=>get_field_of_structure(
                    ir_struct_data = ir_data
                    iv_field_name  = 'ITEM_ID' ).

  ENDMETHOD.


  METHOD get_tor_items_for_dlv_items.

    DATA: lo_srv_mgr  TYPE REF TO /bobf/if_tra_service_manager,
          lo_message  TYPE REF TO /bobf/if_frw_message,
          lt_altkey   TYPE /scmtms/t_base_document_w_item,
          lt_selparam TYPE /bobf/t_frw_query_selparam,
          lt_key      TYPE /bobf/t_frw_key,
          lt_result   TYPE /bobf/t_frw_keyindex.

    CLEAR: et_key[], et_fu_item[].

    lo_srv_mgr = /bobf/cl_tra_serv_mgr_factory=>get_service_manager(
      /scmtms/if_tor_c=>sc_bo_key ).

    lt_altkey     = VALUE #(
      FOR ls_lips IN it_lips
      ( base_btd_tco      = zif_gtt_mia_app_constants=>cs_base_btd_tco-inb_dlv
        base_btd_id       = |{ ls_lips-vbeln ALPHA = IN }|
        base_btditem_id   = |{ ls_lips-posnr ALPHA = IN }|
        base_btd_logsys   = zcl_gtt_tools=>get_logical_system( ) )
    ).

    get_tor_item_selparam_for_lips(
      EXPORTING
        it_lips     = it_lips
      IMPORTING
        et_selparam = lt_selparam ).

    TRY.
        lo_srv_mgr->convert_altern_key(
          EXPORTING
            iv_node_key   = /scmtms/if_tor_c=>sc_node-item_tr
            iv_altkey_key = /scmtms/if_tor_c=>sc_alternative_key-item_tr-base_document
            it_key        = lt_altkey
          IMPORTING
            et_key        = et_key
            et_result     = lt_result ).

        lo_srv_mgr->query(
          EXPORTING
            iv_query_key            = /scmtms/if_tor_c=>sc_query-item_tr-qdb_query_by_attributes
            it_selection_parameters = lt_selparam
          IMPORTING
            et_key                  = lt_key
        ).

        et_key  = VALUE #( BASE et_key
                           ( LINES OF lt_key ) ).

        et_key  = VALUE #( BASE et_key
                          FOR ls_result IN lt_result
                             ( key      = ls_result-key ) ) .


        DELETE et_key WHERE key IS INITIAL.

        SORT et_key BY key.
        DELETE ADJACENT DUPLICATES FROM et_key COMPARING key.

        IF iv_tor_cat IS SUPPLIED.
          filter_tor_items_by_tor_cat(
            EXPORTING
              iv_tor_cat = iv_tor_cat
            CHANGING
              ct_key     = et_key ).
        ENDIF.

        IF et_fu_item IS REQUESTED.
          lo_srv_mgr->retrieve(
            EXPORTING
              iv_node_key  = /scmtms/if_tor_c=>sc_node-item_tr
              it_key       = et_key
              iv_fill_data = abap_true
            IMPORTING
              et_data      = et_fu_item ).
        ENDIF.

      CATCH /bobf/cx_frw_contrct_violation.
    ENDTRY.

  ENDMETHOD.


  METHOD get_tor_item_selparam_for_lips.

    DATA: lv_base_btd_id      TYPE /scmtms/base_btd_id,
          lv_base_btd_item_id TYPE /scmtms/base_btd_item_id.

    CLEAR: et_selparam[].

    LOOP AT it_lips ASSIGNING FIELD-SYMBOL(<ls_lips>).
      lv_base_btd_id        = |{ <ls_lips>-vbeln ALPHA = IN }|.
      lv_base_btd_item_id   = |{ <ls_lips>-posnr ALPHA = IN }|.

      et_selparam = VALUE #( BASE et_selparam
        (
          attribute_name  = /scmtms/if_tor_c=>sc_query_attribute-item_tr-qdb_query_by_attributes-base_btd_id
          low             = lv_base_btd_id
          option          = 'EQ'
          sign            = 'I'
        )
        (
          attribute_name  = /scmtms/if_tor_c=>sc_query_attribute-item_tr-qdb_query_by_attributes-base_btditem_id
          low             = lv_base_btd_item_id
          option          = 'EQ'
          sign            = 'I'
        )
      ).
    ENDLOOP.

  ENDMETHOD.


  METHOD get_tor_root_tor_id.

    DATA: lo_srv_mgr  TYPE REF TO /bobf/if_tra_service_manager,
          lt_tor_root TYPE /scmtms/t_tor_root_k.

    lo_srv_mgr    = /bobf/cl_tra_serv_mgr_factory=>get_service_manager(
                      /scmtms/if_tor_c=>sc_bo_key ).

    TRY.
        lo_srv_mgr->retrieve(
          EXPORTING
            iv_node_key             = /scmtms/if_tor_c=>sc_node-root
            it_key                  = VALUE #( ( key = iv_key ) )
            iv_fill_data            = abap_true
            it_requested_attributes = VALUE #( ( /scmtms/if_tor_c=>sc_node_attribute-root-tor_id  ) )
          IMPORTING
            et_data                 = lt_tor_root ).

        rv_tor_id   = VALUE #( lt_tor_root[ 1 ]-tor_id OPTIONAL ).

      CATCH /bobf/cx_frw_contrct_violation.
    ENDTRY.


  ENDMETHOD.


  METHOD is_fu_relevant.

    DATA: lt_key  TYPE /bobf/t_frw_key.

    get_tor_items_for_dlv_items(
      EXPORTING
        it_lips    = it_lips
        iv_tor_cat = /scmtms/if_tor_const=>sc_tor_category-freight_unit
      IMPORTING
        et_key     = lt_key ).

    rv_result   = boolc( lt_key[] IS NOT INITIAL ).

  ENDMETHOD.


  METHOD get_tor_root.
    DATA: lo_srv_mgr  TYPE REF TO /bobf/if_tra_service_manager,
          lt_tor_root TYPE /scmtms/t_tor_root_k.
    CLEAR es_tor.
    lo_srv_mgr = /bobf/cl_tra_serv_mgr_factory=>get_service_manager(
      /scmtms/if_tor_c=>sc_bo_key ).

    TRY.
        lo_srv_mgr->retrieve(
          EXPORTING
            iv_node_key             = /scmtms/if_tor_c=>sc_node-root
            it_key                  = VALUE #( ( key = iv_key ) )
            iv_fill_data            = abap_true
            it_requested_attributes = VALUE #( ( /scmtms/if_tor_c=>sc_node_attribute-root-tor_id ) )
          IMPORTING
            et_data                 = lt_tor_root ).

        es_tor  = lt_tor_root[ 1 ].

      CATCH /bobf/cx_frw_contrct_violation.
    ENDTRY.
  ENDMETHOD.
ENDCLASS.
