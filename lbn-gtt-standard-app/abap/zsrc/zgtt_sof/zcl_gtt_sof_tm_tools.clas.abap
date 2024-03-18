class ZCL_GTT_SOF_TM_TOOLS definition
  public
  create public .

public section.

  types:
    BEGIN OF ts_dlv,
      vbeln        type /SCMTMS/BASE_BTD_ID,
      base_btd_tco TYPE /SCMTMS/BASE_BTD_TCO,
    END OF ts_dlv .
  types:
    tt_dlv TYPE TABLE OF ts_dlv .

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
      !IT_LIPS type ZIF_GTT_SOF_CTP_TYPES=>TT_LIPSVB_KEY
      !IV_TOR_CAT type /SCMTMS/TOR_CATEGORY optional
    exporting
      !ET_KEY type /BOBF/T_FRW_KEY
      !ET_FU_ITEM type /SCMTMS/T_TOR_ITEM_TR_K
    raising
      CX_UDM_MESSAGE .
  class-methods IS_FU_RELEVANT
    importing
      !IT_LIPS type ZIF_GTT_SOF_CTP_TYPES=>TT_LIPSVB_KEY
    returning
      value(RV_RESULT) type ABAP_BOOL
    raising
      CX_UDM_MESSAGE .
  class-methods GET_FIELD_OF_STRUCTURE
    importing
      !IR_STRUCT_DATA type ref to DATA
      !IV_FIELD_NAME type CLIKE
    returning
      value(RV_VALUE) type CHAR50
    raising
      CX_UDM_MESSAGE .
  class-methods THROW_EXCEPTION
    importing
      !IV_TEXTID type SOTR_CONC optional
    raising
      CX_UDM_MESSAGE .
  class-methods GET_LOGICAL_SYSTEM
    returning
      value(RV_LOGSYS) type LOGSYS
    raising
      CX_UDM_MESSAGE .
  class-methods GET_DELIVERY_HEAD_PLANNED_EVT
    importing
      !IV_APPSYS type LOGSYS
      !IS_AOTYPE type ZIF_GTT_SOF_CTP_TYPES=>TS_AOTYPE
      !IS_LIKP type LIKPVB
      !IT_LIPS type ZIF_GTT_SOF_CTP_TYPES=>TT_LIPSVB
      !IT_VBUK type VA_VBUKVB_T
      !IT_VBUP type VA_VBUPVB_T
      !IT_VBFA type VA_VBFAVB_T
    exporting
      !ET_EXP_EVENT type /SAPTRX/BAPI_TRK_EE_TAB
    raising
      CX_UDM_MESSAGE .
  class-methods GET_DELIVERY_ITEM_PLANNED_EVT
    importing
      !IV_APPSYS type LOGSYS
      !IS_AOTYPE type ZIF_GTT_SOF_CTP_TYPES=>TS_AOTYPE
      !IS_LIKP type LIKPVB
      !IS_LIPS type LIPSVB
      !IS_DLV_ITEM type ZIF_GTT_SOF_CTP_TYPES=>TS_DELIVERY_ITEM
    exporting
      !ET_EXP_EVENT type /SAPTRX/BAPI_TRK_EE_TAB
    raising
      CX_UDM_MESSAGE .
  class-methods LOG_EXCEPTION
    importing
      !IO_UDM_MESSAGE type ref to CX_UDM_MESSAGE
      !IV_LOG_NAME type BALNREXT optional
      !IV_OBJECT type BALOBJ_D
      !IV_SUBOBJECT type BALSUBOBJ .
  class-methods GET_SYSTEM_TIME_ZONE
    returning
      value(RV_TZONE) type TIMEZONE
    raising
      CX_UDM_MESSAGE .
  class-methods GET_PRETTY_VALUE
    importing
      !IV_VALUE type ANY
    returning
      value(RV_PRETTY) type /SAPTRX/PARAMVAL200 .
  class-methods IS_DATE
    importing
      !IV_VALUE type ANY
    returning
      value(RV_RESULT) type ABAP_BOOL .
  class-methods IS_NUMBER
    importing
      !IV_VALUE type ANY
    returning
      value(RV_RESULT) type ABAP_BOOL .
  class-methods IS_TIMESTAMP
    importing
      !IV_VALUE type ANY
    returning
      value(RV_RESULT) type ABAP_BOOL .
  class-methods GET_VALID_DATETIME
    importing
      !IV_TIMESTAMP type TIMESTAMP
    returning
      value(RV_DATETIME) type CHAR15 .
  class-methods GET_TOR_ROOT
    importing
      !IV_KEY type /BOBF/CONF_KEY
    exporting
      value(ES_TOR) type /SCMTMS/S_TOR_ROOT_K .
  class-methods GET_TOR_STOP_BEFORE
    importing
      !IT_TOR_ROOT type /SCMTMS/T_EM_BO_TOR_ROOT
    returning
      value(RT_TOR_STOP_BEFORE) type /SCMTMS/T_EM_BO_TOR_STOP .
  class-methods GET_DLV_TOR_RELATION
    importing
      !IT_TOR_ROOT_SSTRING type /SCMTMS/T_EM_BO_TOR_ROOT
      !IT_TOR_ITEM_SSTRING type /SCMTMS/T_EM_BO_TOR_ITEM
    exporting
      !ET_FU_INFO type /SCMTMS/T_TOR_ROOT_K .
  PROTECTED SECTION.
private section.

  class-methods GET_TOR_ITEM_SELPARAM_FOR_LIPS
    importing
      !IT_LIPS type ZIF_GTT_SOF_CTP_TYPES=>TT_LIPSVB_KEY
    exporting
      !ET_SELPARAM type /BOBF/T_FRW_QUERY_SELPARAM .
  class-methods FILTER_TOR_ITEMS_BY_TOR_CAT
    importing
      !IV_TOR_CAT type /SCMTMS/TOR_CATEGORY
    changing
      !CT_KEY type /BOBF/T_FRW_KEY .
ENDCLASS.



CLASS ZCL_GTT_SOF_TM_TOOLS IMPLEMENTATION.


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


  METHOD get_delivery_head_planned_evt.

    DATA: ls_app_obj_types      TYPE /saptrx/aotypes,
          lt_all_appl_tables    TYPE trxas_tabcontainer,
          lt_app_type_cntl_tabs TYPE trxas_apptype_tabs,
          ls_app_objects        TYPE trxas_appobj_ctab_wa,
          lt_app_objects        TYPE trxas_appobj_ctabs.

    CLEAR: et_exp_event[].

    ls_app_obj_types              = CORRESPONDING #( is_aotype ).

    ls_app_objects                = CORRESPONDING #( ls_app_obj_types ).
    ls_app_objects-appobjtype     = is_aotype-aot_type.
    ls_app_objects-appobjid       = |{ is_likp-vbeln ALPHA = OUT }|.
    ls_app_objects-maintabref     = REF #( is_likp ).
    ls_app_objects-maintabdef     = zif_gtt_sof_ctp_tor_constants=>cs_tabledef-dl_header_new.

    lt_app_objects                = VALUE #( ( ls_app_objects ) ).

    lt_all_appl_tables            = VALUE #(
    (
      tabledef    = zif_gtt_sof_ctp_tor_constants=>cs_tabledef-dl_item_new
      tableref    = REF #( it_lips )
     )
    (
      tabledef    = zif_gtt_sof_ctp_tor_constants=>cs_tabledef-delivery_hdrstatus_new
      tableref    = REF #( it_vbuk )
     )
    (
      tabledef    = zif_gtt_sof_ctp_tor_constants=>cs_tabledef-delivery_item_stat_new
      tableref    = REF #( it_vbup )
     )
    (
      tabledef    = zif_gtt_sof_ctp_tor_constants=>cs_tabledef-document_flow_new
      tableref    = REF #( it_vbfa )
     )

     ).

    CALL FUNCTION 'ZGTT_SSOF_EE_DE_HD'
      EXPORTING
        i_appsys                  = iv_appsys
        i_app_obj_types           = CORRESPONDING /saptrx/aotypes( is_aotype )
        i_all_appl_tables         = lt_all_appl_tables
        i_app_type_cntl_tabs      = lt_app_type_cntl_tabs
        i_app_objects             = lt_app_objects
      TABLES
        e_expeventdata            = et_exp_event
      EXCEPTIONS
        parameter_error           = 1
        exp_event_determ_error    = 2
        table_determination_error = 3
        stop_processing           = 4
        OTHERS                    = 5.

    IF sy-subrc <> 0.
      MESSAGE e013(zgtt_ssof) WITH 'ZGTT_SSOF_EE_DE_HD' INTO DATA(lv_dummy).
      zcl_gtt_sof_tm_tools=>throw_exception( ).
    ENDIF.

  ENDMETHOD.


  METHOD get_delivery_item_planned_evt.

    DATA: ls_app_obj_types      TYPE /saptrx/aotypes,
          lt_all_appl_tables    TYPE trxas_tabcontainer,
          lt_app_type_cntl_tabs TYPE trxas_apptype_tabs,
          ls_app_objects        TYPE trxas_appobj_ctab_wa,
          lt_app_objects        TYPE trxas_appobj_ctabs,
          lt_lips               TYPE zif_gtt_sof_ctp_types=>tt_lipsvb,
          lt_vbuk               TYPE va_vbukvb_t,
          lt_vbup               TYPE va_vbupvb_t,
          lt_vbfa               TYPE va_vbfavb_t.

    CLEAR: et_exp_event[].

    APPEND is_dlv_item-vbuk TO lt_vbuk.
    APPEND is_dlv_item-vbup TO lt_vbup.
    APPEND LINES OF is_dlv_item-vbfa TO lt_vbfa.

    ls_app_obj_types              = CORRESPONDING #( is_aotype ).

    ls_app_objects                = CORRESPONDING #( ls_app_obj_types ).
    ls_app_objects-appobjtype     = is_aotype-aot_type.
    ls_app_objects-appobjid       = |{ is_lips-vbeln ALPHA = OUT }{ is_lips-posnr ALPHA = IN }|.
    CONDENSE ls_app_objects-appobjid NO-GAPS.
    ls_app_objects-maintabref     = REF #( is_lips ).
    ls_app_objects-maintabdef     = zif_gtt_sof_ctp_tor_constants=>cs_tabledef-dl_item_new.
    ls_app_objects-mastertabref   = REF #( is_likp ).
    ls_app_objects-mastertabdef   = zif_gtt_sof_ctp_tor_constants=>cs_tabledef-dl_header_new.

    lt_app_objects                = VALUE #( ( ls_app_objects ) ).

    lt_lips                       = VALUE #( ( CORRESPONDING #( is_lips ) ) ).

    lt_all_appl_tables            = VALUE #(
    (
      tabledef    = zif_gtt_sof_ctp_tor_constants=>cs_tabledef-dl_item_new
      tableref    = REF #( lt_lips )
     )
    (
      tabledef    = zif_gtt_sof_ctp_tor_constants=>cs_tabledef-delivery_hdrstatus_new
      tableref    = REF #( lt_vbuk )
     )
    (
      tabledef    = zif_gtt_sof_ctp_tor_constants=>cs_tabledef-delivery_item_stat_new
      tableref    = REF #( lt_vbup )
     )
    (
      tabledef    = zif_gtt_sof_ctp_tor_constants=>cs_tabledef-document_flow_new
      tableref    = REF #( lt_vbfa )
     )

     ).

    CALL FUNCTION 'ZGTT_SSOF_EE_DE_ITM'
      EXPORTING
        i_appsys                  = iv_appsys
        i_app_obj_types           = CORRESPONDING /saptrx/aotypes( is_aotype )
        i_all_appl_tables         = lt_all_appl_tables
        i_app_type_cntl_tabs      = lt_app_type_cntl_tabs
        i_app_objects             = lt_app_objects
      TABLES
        e_expeventdata            = et_exp_event
      EXCEPTIONS
        parameter_error           = 1
        exp_event_determ_error    = 2
        table_determination_error = 3
        stop_processing           = 4
        OTHERS                    = 5.

    IF sy-subrc <> 0.
      MESSAGE e013(zgtt_ssof) WITH 'ZGTT_SSOF_EE_DE_ITM' INTO DATA(lv_dummy).
      zcl_gtt_sof_tm_tools=>throw_exception( ).
    ENDIF.

  ENDMETHOD.


  METHOD get_field_of_structure.

    DATA: lv_dummy      TYPE char100.

    FIELD-SYMBOLS: <ls_struct> TYPE any,
                   <lv_value>  TYPE any.

    ASSIGN ir_struct_data->* TO <ls_struct>.

    IF <ls_struct> IS ASSIGNED.
      ASSIGN COMPONENT iv_field_name OF STRUCTURE <ls_struct> TO <lv_value>.
      IF <lv_value> IS ASSIGNED.
        rv_value    = <lv_value>.
      ELSE.
        MESSAGE e001(zgtt_ssof) WITH iv_field_name '' INTO lv_dummy.
        zcl_gtt_sof_tm_tools=>throw_exception( ).
      ENDIF.
    ELSE.
      MESSAGE e002(zgtt_ssof) WITH '' INTO lv_dummy.
      zcl_gtt_sof_tm_tools=>throw_exception( ).
    ENDIF.

  ENDMETHOD.


  METHOD get_formated_tor_id.

    rv_tor_id   = zcl_gtt_sof_tm_tools=>get_field_of_structure(
                    ir_struct_data = ir_data
                    iv_field_name  = 'TOR_ID' ).

    rv_tor_id   = |{ rv_tor_id ALPHA = OUT }|.

  ENDMETHOD.


  METHOD get_formated_tor_item.

    rv_item_id   = zcl_gtt_sof_tm_tools=>get_field_of_structure(
                    ir_struct_data = ir_data
                    iv_field_name  = 'ITEM_ID' ).

  ENDMETHOD.


  METHOD get_logical_system.

    " Get current logical system
    CALL FUNCTION 'OWN_LOGICAL_SYSTEM_GET'
      IMPORTING
        own_logical_system             = rv_logsys
      EXCEPTIONS
        own_logical_system_not_defined = 1
        OTHERS                         = 2.

    IF sy-subrc <> 0.
      MESSAGE e007(zgtt_ssof) INTO DATA(lv_dummy).
      zcl_gtt_sof_tm_tools=>throw_exception( ).
    ENDIF.


  ENDMETHOD.


  METHOD get_pretty_value.

    rv_pretty   = COND #( WHEN zcl_gtt_sof_tm_tools=>is_date( iv_value = iv_value ) = abap_true
                            THEN COND #( WHEN iv_value IS NOT INITIAL
                                           THEN iv_value
                                           ELSE '' )
                          WHEN zcl_gtt_sof_tm_tools=>is_timestamp( iv_value = iv_value ) = abap_true
                            THEN COND #( WHEN iv_value IS NOT INITIAL
                                           THEN get_valid_datetime( iv_timestamp = iv_value )
                                           ELSE '' )
                          WHEN zcl_gtt_sof_tm_tools=>is_number( iv_value = iv_value ) = abap_true
                            THEN |{ iv_value }|
                            ELSE iv_value ).

  ENDMETHOD.


  METHOD get_system_time_zone.

    CLEAR rv_tzone.
    rv_tzone = zcl_gtt_tools=>get_system_time_zone( ).

  ENDMETHOD.


  METHOD get_tor_items_for_dlv_items.

    DATA: lo_srv_mgr  TYPE REF TO /bobf/if_tra_service_manager,
          lo_message  TYPE REF TO /bobf/if_frw_message,
          lt_altkey   TYPE /scmtms/t_base_document_w_item,
          lt_selparam TYPE /bobf/t_frw_query_selparam,
          lt_key      TYPE /bobf/t_frw_key,
          lt_result   TYPE /bobf/t_frw_keyindex.

    CLEAR: et_key[], et_fu_item[].

    lo_srv_mgr    = /bobf/cl_tra_serv_mgr_factory=>get_service_manager(
                      /scmtms/if_tor_c=>sc_bo_key ).

    lt_altkey     = VALUE #(
      FOR ls_lips IN it_lips
      ( base_btd_tco      = zif_gtt_sof_ctp_tor_constants=>cv_base_btd_tco_outb_dlv
        base_btd_id       = |{ ls_lips-vbeln ALPHA = IN }|
        base_btditem_id   = |{ ls_lips-posnr ALPHA = IN }|
        base_btd_logsys   = zcl_gtt_sof_tm_tools=>get_logical_system( ) )
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
              iv_node_key   = /scmtms/if_tor_c=>sc_node-item_tr
              it_key        = et_key
              iv_fill_data  = abap_true
            IMPORTING
              et_data       = et_fu_item ).
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


  METHOD get_valid_datetime.

    rv_datetime   = COND #( WHEN iv_timestamp > 0
                              THEN |{ CONV char15( iv_timestamp ) ALPHA = IN }| ).

  ENDMETHOD.


  method IS_DATE.

    DATA(lo_type) = cl_abap_typedescr=>describe_by_data( p_data = iv_value ).

    rv_result     = boolc( lo_type->type_kind = cl_abap_typedescr=>typekind_date ).

  endmethod.


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


  METHOD is_number.

    DATA(lo_type) = cl_abap_typedescr=>describe_by_data( p_data = iv_value ).

    rv_result = SWITCH #( lo_type->type_kind
      WHEN cl_abap_typedescr=>typekind_decfloat OR
           cl_abap_typedescr=>typekind_decfloat16 OR
           cl_abap_typedescr=>typekind_decfloat34 OR
           cl_abap_typedescr=>typekind_float OR
           cl_abap_typedescr=>typekind_int OR
           cl_abap_typedescr=>typekind_int1 OR
           cl_abap_typedescr=>typekind_int2 OR
           cl_abap_typedescr=>typekind_int8 OR
           cl_abap_typedescr=>typekind_num OR
           cl_abap_typedescr=>typekind_numeric OR
           cl_abap_typedescr=>typekind_packed
        THEN abap_true
        ELSE abap_false ).

  ENDMETHOD.


  METHOD is_timestamp.

    DATA lo_elem  TYPE REF TO cl_abap_elemdescr.

    DATA(lo_type) = cl_abap_typedescr=>describe_by_data( p_data = iv_value ).


    IF lo_type IS INSTANCE OF cl_abap_elemdescr.
      lo_elem ?= lo_type.

      rv_result   = boolc( lo_elem->help_id = zif_gtt_sof_ctp_tor_constants=>cs_date_types-timestamp ).
    ELSE.
      rv_result   = abap_false.
    ENDIF.

  ENDMETHOD.


  METHOD log_exception.

    DATA: ls_log    TYPE bal_s_log,
          lv_handle TYPE balloghndl,
          ls_msg    TYPE bal_s_msg,
          lt_handle TYPE bal_t_logh.

    TRY.
        cl_reca_guid=>guid_create(
          IMPORTING
            ed_guid_22 = DATA(lv_guid) ).

        " open application log
        ls_log-object    = iv_object.
        ls_log-subobject = iv_subobject.
        ls_log-extnumber = lv_handle.
        ls_log-aldate    = sy-datum.
        ls_log-altime    = sy-uzeit.
        ls_log-aluser    = sy-uname.
        ls_log-altcode   = sy-tcode.
        CALL FUNCTION 'BAL_LOG_CREATE'
          EXPORTING
            i_s_log                 = ls_log
          IMPORTING
            e_log_handle            = lv_handle
          EXCEPTIONS
            log_header_inconsistent = 1
            OTHERS                  = 2.
        IF sy-subrc <> 0.
          RETURN.
        ENDIF.

        " add message to application log
        ls_msg    = VALUE #(
          msgty  = io_udm_message->m_msgty
          msgid  = io_udm_message->m_msgid
          msgno  = io_udm_message->m_msgno
          msgv1  = io_udm_message->m_msgv1
          msgv2  = io_udm_message->m_msgv2
          msgv3  = io_udm_message->m_msgv3
          msgv4  = io_udm_message->m_msgv4
        ).

        GET TIME STAMP FIELD ls_msg-time_stmp.

        CALL FUNCTION 'BAL_LOG_MSG_ADD'
          EXPORTING
            i_log_handle     = lv_handle
            i_s_msg          = ls_msg
          EXCEPTIONS
            log_not_found    = 1
            msg_inconsistent = 2
            log_is_full      = 3
            OTHERS           = 4.
        IF sy-subrc <> 0.
          RETURN.
        ENDIF.

        " save application log
        CLEAR lt_handle[].
        INSERT lv_handle INTO TABLE lt_handle.

        CALL FUNCTION 'BAL_DB_SAVE'
          EXPORTING
            i_in_update_task = ' '
            i_t_log_handle   = lt_handle
          EXCEPTIONS
            log_not_found    = 1
            save_not_allowed = 2
            numbering_error  = 3
            OTHERS           = 4.
        IF sy-subrc <> 0.
          RETURN.
        ENDIF.
      CATCH cx_cacs_bal_ex.
    ENDTRY.

  ENDMETHOD.


  METHOD throw_exception.

    RAISE EXCEPTION TYPE cx_udm_message
      EXPORTING
        textid  = iv_textid
        m_msgid = sy-msgid
        m_msgty = sy-msgty
        m_msgno = sy-msgno
        m_msgv1 = sy-msgv1
        m_msgv2 = sy-msgv2
        m_msgv3 = sy-msgv3
        m_msgv4 = sy-msgv4.

  ENDMETHOD.


  METHOD get_tor_root.

    DATA: lo_srv_mgr  TYPE REF TO /bobf/if_tra_service_manager,
          lt_tor_root TYPE /scmtms/t_tor_root_k.
    CLEAR es_tor.
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

        es_tor  = lt_tor_root[ 1 ].

      CATCH /bobf/cx_frw_contrct_violation.
    ENDTRY.
  ENDMETHOD.


  METHOD get_dlv_tor_relation.

    DATA:
      lt_dlv        TYPE tt_dlv,
      ls_dlv        TYPE ts_dlv,
      lv_sys        TYPE tbdls-logsys,
      ls_base_doc   TYPE /scmtms/s_base_document_w_item,
      lt_base_doc   TYPE /scmtms/t_base_document_w_item,
      lo_srvmgr_tor TYPE REF TO /bobf/if_tra_service_manager,
      lt_result     TYPE /bobf/t_frw_keyindex,
      lt_fu         TYPE /scmtms/t_tor_root_k.

    CLEAR:et_fu_info.

    LOOP AT it_tor_root_sstring ASSIGNING FIELD-SYMBOL(<ls_tor_root>)
      WHERE tor_cat = /scmtms/if_tor_const=>sc_tor_category-freight_unit
        AND ( base_btd_tco = /scmtms/if_common_c=>c_btd_tco-outbounddelivery
         OR base_btd_tco = /scmtms/if_common_c=>c_btd_tco-inbounddelivery ).

      LOOP AT it_tor_item_sstring ASSIGNING FIELD-SYMBOL(<ls_tor_item>)
        USING KEY item_parent WHERE parent_node_id = <ls_tor_root>-node_id.

        READ TABLE lt_dlv TRANSPORTING NO FIELDS
          WITH KEY vbeln = <ls_tor_item>-base_btd_id .
        IF sy-subrc <> 0.
          ls_dlv-vbeln = <ls_tor_item>-base_btd_id .
          ls_dlv-base_btd_tco = <ls_tor_root>-base_btd_tco.
          APPEND ls_dlv TO lt_dlv.
          CLEAR ls_dlv.
        ENDIF.
      ENDLOOP.
    ENDLOOP.

    CALL FUNCTION 'OWN_LOGICAL_SYSTEM_GET'
      IMPORTING
        own_logical_system             = lv_sys
      EXCEPTIONS
        own_logical_system_not_defined = 1
        OTHERS                         = 2.

    LOOP AT lt_dlv INTO ls_dlv.
      ls_base_doc-base_btd_logsys = lv_sys.
      ls_base_doc-base_btd_tco = ls_dlv-base_btd_tco.
      ls_base_doc-base_btd_id = ls_dlv-vbeln.
      APPEND ls_base_doc TO lt_base_doc.
      CLEAR ls_base_doc.
    ENDLOOP.

    lo_srvmgr_tor = /bobf/cl_tra_serv_mgr_factory=>get_service_manager( iv_bo_key = /scmtms/if_tor_c=>sc_bo_key ).
    lo_srvmgr_tor->convert_altern_key(
      EXPORTING
        iv_node_key   = /scmtms/if_tor_c=>sc_node-item_tr
        iv_altkey_key = /scmtms/if_tor_c=>sc_alternative_key-item_tr-base_document
        it_key        = lt_base_doc
      IMPORTING
        et_result     = lt_result ).

    lo_srvmgr_tor->retrieve_by_association(
      EXPORTING
        iv_node_key    = /scmtms/if_tor_c=>sc_node-item_tr
        it_key         = CORRESPONDING #( lt_result )
        iv_association = /scmtms/if_tor_c=>sc_association-item_tr-fu_root
        iv_fill_data   = abap_true
      IMPORTING
        et_data        = et_fu_info ).

  ENDMETHOD.


  METHOD get_tor_stop_before.

    DATA: ls_tor_stop_before TYPE /scmtms/s_em_bo_tor_stop.

    /scmtms/cl_tor_helper_stop=>get_stop_sequence(
      EXPORTING
        it_root_key     = VALUE #( FOR <ls_tor_root> IN it_tor_root ( key = <ls_tor_root>-node_id ) )
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
ENDCLASS.
