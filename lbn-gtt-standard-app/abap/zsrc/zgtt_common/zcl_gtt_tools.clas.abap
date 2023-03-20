class ZCL_GTT_TOOLS definition
  public
  create public .

public section.

  types:
    BEGIN OF ts_ref_doc,
      vbeln TYPE lips-vbeln,
      vgbel TYPE lips-vgbel,
   END OF ts_ref_doc .
  types:
    tt_ref_doc TYPE STANDARD TABLE OF ts_ref_doc .
  types:
    BEGIN OF ts_ref_list,
      vgbel TYPE vgbel,
      vbeln TYPE vbeln_vl_t,
     END OF ts_ref_list .
  types:
    tt_ref_list TYPE STANDARD TABLE OF ts_ref_list .
  types:
    BEGIN OF ts_likp,
      vbeln type likp-vbeln,
      vbtyp type likp-vbtyp,
    END OF ts_likp .
  types:
    tt_likp TYPE STANDARD TABLE OF ts_likp .

  class-methods ARE_FIELDS_DIFFERENT
    importing
      !IR_DATA1 type ref to DATA
      !IR_DATA2 type ref to DATA
      !IT_FIELDS type ZIF_GTT_EF_TYPES=>TT_FIELD_NAME
    returning
      value(RV_RESULT) type ZIF_GTT_EF_TYPES=>TV_CONDITION
    raising
      CX_UDM_MESSAGE .
  class-methods ARE_STRUCTURES_DIFFERENT
    importing
      !IR_DATA1 type ref to DATA
      !IR_DATA2 type ref to DATA
    returning
      value(RV_RESULT) type ZIF_GTT_EF_TYPES=>TV_CONDITION
    raising
      CX_UDM_MESSAGE .
  class-methods CONVERT_DATETIME_TO_UTC
    importing
      !IV_DATETIME type TIMESTAMP
      !IV_TIMEZONE type TIMEZONE
    returning
      value(RV_DATETIME_UTC) type CHAR15 .
  class-methods CONVERT_TO_EXTERNAL_AMOUNT
    importing
      !IV_CURRENCY type WAERS_CURC
      !IV_INTERNAL type ANY
    returning
      value(RV_EXTERNAL) type ZIF_GTT_EF_TYPES=>TV_CURRENCY_AMNT .
  class-methods GET_FIELD_OF_STRUCTURE
    importing
      !IR_STRUCT_DATA type ref to DATA
      !IV_FIELD_NAME type CLIKE
    returning
      value(RV_VALUE) type CHAR50
    raising
      CX_UDM_MESSAGE .
  class-methods GET_ERRORS_LOG
    importing
      !IO_UMD_MESSAGE type ref to CX_UDM_MESSAGE
      !IV_APPSYS type C
    exporting
      !ES_BAPIRET type BAPIRET2 .
  class-methods GET_LOCAL_TIMESTAMP
    importing
      !IV_DATE type ANY default SY-DATUM
      !IV_TIME type ANY default SY-UZEIT
    returning
      value(RV_TIMESTAMP) type /SAPTRX/EVENT_EXP_DATETIME .
  class-methods GET_LOGICAL_SYSTEM
    returning
      value(RV_LOGSYS) type LOGSYS
    raising
      CX_UDM_MESSAGE .
  class-methods GET_MAX_SEQUENCE_ID
    importing
      !IT_EXPEVENTDATA type ZIF_GTT_EF_TYPES=>TT_EXPEVENTDATA
    returning
      value(RV_MILESTONENUM) type /SAPTRX/SEQ_NUM .
  class-methods GET_NEXT_SEQUENCE_ID
    importing
      !IT_EXPEVENTDATA type ZIF_GTT_EF_TYPES=>TT_EXPEVENTDATA
    returning
      value(RV_MILESTONENUM) type /SAPTRX/SEQ_NUM .
  class-methods GET_PRETTY_LOCATION_ID
    importing
      !IV_LOCID type C
      !IV_LOCTYPE type C
    returning
      value(RV_LOCID) type /SAPTRX/LOC_ID_1 .
  class-methods GET_PRETTY_VALUE
    importing
      !IV_VALUE type ANY
    returning
      value(RV_PRETTY) type /SAPTRX/PARAMVAL200 .
  class-methods GET_SYSTEM_TIME_ZONE
    returning
      value(RV_TZONE) type TIMEZONE
    raising
      CX_UDM_MESSAGE .
  class-methods GET_SYSTEM_DATE_TIME
    returning
      value(RV_DATETIME) type STRING
    raising
      CX_UDM_MESSAGE .
  class-methods GET_VALID_DATETIME
    importing
      !IV_TIMESTAMP type TIMESTAMP
    returning
      value(RV_DATETIME) type CHAR15 .
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
  class-methods IS_OBJECT_CHANGED
    importing
      !IS_APP_OBJECT type TRXAS_APPOBJ_CTAB_WA
      !IO_EF_PARAMETERS type ref to ZIF_GTT_EF_PARAMETERS
      !IT_CHECK_TABLES type ZIF_GTT_EF_TYPES=>TT_STRUCDATADEF optional
      !IV_KEY_FIELD type CLIKE
      !IV_UPD_FIELD type CLIKE
      !IV_CHK_MASTERTAB type ABAP_BOOL default ABAP_FALSE
    returning
      value(RV_RESULT) type ABAP_BOOL
    raising
      CX_UDM_MESSAGE .
  class-methods IS_TABLE
    importing
      !IV_VALUE type ANY
    returning
      value(RV_RESULT) type ABAP_BOOL .
  class-methods IS_TIMESTAMP
    importing
      !IV_VALUE type ANY
    returning
      value(RV_RESULT) type ABAP_BOOL .
  class-methods LOG_EXCEPTION
    importing
      !IO_UDM_MESSAGE type ref to CX_UDM_MESSAGE
      !IV_LOG_NAME type BALNREXT optional
      !IV_OBJECT type BALOBJ_D
      !IV_SUBOBJECT type BALSUBOBJ .
  class-methods THROW_EXCEPTION
    importing
      !IV_TEXTID type SOTR_CONC default ''
    raising
      CX_UDM_MESSAGE .
  class-methods IS_APPROPRIATE_ODLV_TYPE
    importing
      !IR_LIKP type ref to DATA
    returning
      value(RV_RESULT) type ABAP_BOOL
    raising
      CX_UDM_MESSAGE .
  class-methods IS_APPROPRIATE_ODLV_ITEM
    importing
      !IR_LIKP type ref to DATA
      !IR_LIPS type ref to DATA
    returning
      value(RV_RESULT) type ABAP_BOOL
    raising
      CX_UDM_MESSAGE .
  class-methods GET_DELIVERY_TYPE
    returning
      value(RT_TYPE) type RSELOPTION .
  class-methods IS_APPROPRIATE_DL_TYPE
    importing
      !IR_LIKP type ref to DATA
    returning
      value(RV_RESULT) type ABAP_BOOL
    raising
      CX_UDM_MESSAGE .
  class-methods IS_APPROPRIATE_DL_ITEM
    importing
      !IR_LIKP type ref to DATA
      !IR_LIPS type ref to DATA
    returning
      value(RV_RESULT) type ABAP_BOOL
    raising
      CX_UDM_MESSAGE .
  class-methods GET_TCO_FOR_DOC
    importing
      !IS_EKKO type EKKO
    returning
      value(RV_BASE_BTD_TCO) type /SCMTMS/BASE_BTD_TCO .
  class-methods GET_DELIVERY_BY_REF_DOC
    importing
      !IV_VGBEL type VGBEL
    exporting
      !ET_VBELN type VBELN_VL_T .
  class-methods GET_PO_SO_BY_DELIVERY
    importing
      !IV_VGTYP type VBTYPL_V
      !IT_XLIKP type SHP_LIKP_T
      !IT_XLIPS type SHP_LIPS_T
    exporting
      !ET_REF_LIST type TT_REF_LIST .
  class-methods CONVERT_UNIT_OUTPUT
    importing
      !IV_INPUT type CLIKE
    returning
      value(RV_OUTPUT) type MSEH3 .
  class-methods CONVERT_TO_EXTERNAL_FRMT
    importing
      !IV_INPUT type CLIKE
    exporting
      value(EV_OUTPUT) type CLIKE .
  class-methods CONVERT_MATNR_TO_EXTERNAL_FRMT
    importing
      !IV_MATERIAL type MATNR
    exporting
      !EV_RESULT type MATNR .
  PROTECTED SECTION.
  PRIVATE SECTION.

    CLASS-METHODS is_structure_changed
      IMPORTING
        !ir_struct       TYPE REF TO data
        !iv_upd_field    TYPE clike
      RETURNING
        VALUE(rv_result) TYPE abap_bool
      RAISING
        cx_udm_message .
    CLASS-METHODS is_table_changed
      IMPORTING
        !ir_table        TYPE REF TO data
        !iv_key_field    TYPE clike
        !iv_upd_field    TYPE clike
        !iv_key_value    TYPE any
      RETURNING
        VALUE(rv_result) TYPE abap_bool
      RAISING
        cx_udm_message .
ENDCLASS.



CLASS ZCL_GTT_TOOLS IMPLEMENTATION.


  METHOD are_fields_different.
    FIELD-SYMBOLS: <ls_data1>  TYPE any,
                   <ls_data2>  TYPE any,
                   <lv_value1> TYPE any,
                   <lv_value2> TYPE any.

    ASSIGN ir_data1->* TO <ls_data1>.
    ASSIGN ir_data2->* TO <ls_data2>.

    rv_result = zif_gtt_ef_constants=>cs_condition-false.

    LOOP AT it_fields ASSIGNING FIELD-SYMBOL(<lv_field>).
      ASSIGN COMPONENT <lv_field> OF STRUCTURE <ls_data1> TO <lv_value1>.
      ASSIGN COMPONENT <lv_field> OF STRUCTURE <ls_data2> TO <lv_value2>.

      IF <lv_value1> IS ASSIGNED AND
         <lv_value2> IS ASSIGNED.

        IF <lv_value1> <> <lv_value2>.
          rv_result = zif_gtt_ef_constants=>cs_condition-true.
          EXIT.
        ENDIF.

        UNASSIGN: <lv_value1>, <lv_value2>.
      ELSE.
        MESSAGE e001(zgtt) WITH <lv_field> '' INTO DATA(lv_dummy).
        zcl_gtt_tools=>throw_exception( ).
      ENDIF.
    ENDLOOP.
  ENDMETHOD.


  METHOD are_structures_different.

    DATA: lt_fields TYPE cl_abap_structdescr=>component_table,
          lv_dummy  TYPE char100.

    FIELD-SYMBOLS: <ls_data1>  TYPE any,
                   <ls_data2>  TYPE any,
                   <lv_value1> TYPE any,
                   <lv_value2> TYPE any.

    ASSIGN ir_data1->* TO <ls_data1>.
    ASSIGN ir_data2->* TO <ls_data2>.

    IF <ls_data1> IS ASSIGNED AND <ls_data2> IS ASSIGNED.
      lt_fields = CAST cl_abap_structdescr(
                    cl_abap_typedescr=>describe_by_data(
                      p_data = <ls_data1> )
                  )->get_components( ).

      rv_result   = zif_gtt_ef_constants=>cs_condition-false.

      LOOP AT lt_fields ASSIGNING FIELD-SYMBOL(<ls_fields>).
        ASSIGN COMPONENT <ls_fields>-name OF STRUCTURE <ls_data1> TO <lv_value1>.
        ASSIGN COMPONENT <ls_fields>-name OF STRUCTURE <ls_data2> TO <lv_value2>.

        IF <lv_value1> IS ASSIGNED AND
           <lv_value2> IS ASSIGNED.
          IF <lv_value1> <> <lv_value2>.
            rv_result   = zif_gtt_ef_constants=>cs_condition-true.
            EXIT.
          ENDIF.
        ELSE.
          MESSAGE e001(zgtt) WITH <ls_fields>-name '' INTO lv_dummy.
          zcl_gtt_tools=>throw_exception( ).
        ENDIF.
      ENDLOOP.
    ELSE.
      MESSAGE e002(zgtt) WITH '' INTO lv_dummy.
      zcl_gtt_tools=>throw_exception( ).
    ENDIF.

  ENDMETHOD.


  METHOD convert_datetime_to_utc.

    DATA: lv_datetime_utc   TYPE timestamp.

    CALL FUNCTION '/SAPAPO/TIMESTAMP_ZONE_TO_UTC'
      EXPORTING
        iv_timezone  = iv_timezone
        iv_timestamp = iv_datetime
      IMPORTING
        ev_timestamp = lv_datetime_utc.

    rv_datetime_utc = get_valid_datetime(
      iv_timestamp = lv_datetime_utc ).

  ENDMETHOD.


  METHOD convert_to_external_amount.

    DATA: lv_external   TYPE bapicurr_d.

    CALL FUNCTION 'BAPI_CURRENCY_CONV_TO_EXTERNAL'
      EXPORTING
        currency        = iv_currency
        amount_internal = iv_internal
      IMPORTING
        amount_external = lv_external.

    rv_external   = round( val = lv_external dec = 2 ).

  ENDMETHOD.


  METHOD get_errors_log.

    es_bapiret-id           = io_umd_message->m_msgid.
    es_bapiret-number       = io_umd_message->m_msgno.
    es_bapiret-type         = io_umd_message->m_msgty.
    es_bapiret-message_v1   = io_umd_message->m_msgv1.
    es_bapiret-message_v1   = io_umd_message->m_msgv1.
    es_bapiret-message_v1   = io_umd_message->m_msgv1.
    es_bapiret-message_v1   = io_umd_message->m_msgv1.
    es_bapiret-system       = iv_appsys.

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
        MESSAGE e001(zgtt) WITH iv_field_name '' INTO lv_dummy.
        zcl_gtt_tools=>throw_exception( ).
      ENDIF.
    ELSE.
      MESSAGE e002(zgtt) WITH '' INTO lv_dummy.
      zcl_gtt_tools=>throw_exception( ).
    ENDIF.

  ENDMETHOD.


  METHOD get_local_timestamp.

    rv_timestamp    = COND #( WHEN iv_date IS NOT INITIAL
                                THEN |0{ iv_date }{ iv_time }| ).

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
      MESSAGE e007(zgtt) INTO DATA(lv_dummy).
      zcl_gtt_tools=>throw_exception( ).
    ENDIF.

  ENDMETHOD.


  METHOD get_max_sequence_id.
    CLEAR: rv_milestonenum.

    LOOP AT it_expeventdata ASSIGNING FIELD-SYMBOL(<ls_expeventdata>).
      IF rv_milestonenum < <ls_expeventdata>-milestonenum.
        rv_milestonenum = <ls_expeventdata>-milestonenum.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.


  METHOD get_next_sequence_id.
    rv_milestonenum   = get_max_sequence_id(
                          it_expeventdata = it_expeventdata ) + 1.
  ENDMETHOD.


  METHOD get_pretty_location_id.
    rv_locid  = SWITCH #( iv_loctype
                          WHEN zif_gtt_ef_constants=>cs_loc_types-businesspartner
                            THEN |{ iv_locid ALPHA = OUT }|
                            ELSE iv_locid ).
  ENDMETHOD.


  METHOD get_pretty_value.

    rv_pretty   = COND #( WHEN zcl_gtt_tools=>is_date( iv_value = iv_value ) = abap_true
                            THEN COND #( WHEN iv_value IS NOT INITIAL
                                           THEN iv_value
                                           ELSE '' )
                          WHEN zcl_gtt_tools=>is_timestamp( iv_value = iv_value ) = abap_true
                            THEN COND #( WHEN iv_value IS NOT INITIAL
                                           THEN get_valid_datetime( iv_timestamp = iv_value )
                                           ELSE '' )
                          WHEN zcl_gtt_tools=>is_number( iv_value = iv_value ) = abap_true
                            THEN |{ iv_value }|
                            ELSE iv_value ).

  ENDMETHOD.


  METHOD get_system_date_time.

    rv_datetime   = |0{ sy-datum }{ sy-uzeit }|.

  ENDMETHOD.


  METHOD get_system_time_zone.

    CALL FUNCTION 'GET_SYSTEM_TIMEZONE'
      IMPORTING
        timezone            = rv_tzone
      EXCEPTIONS
        customizing_missing = 1
        OTHERS              = 2.
    IF sy-subrc <> 0.
      MESSAGE e003(zgtt) INTO DATA(lv_dummy).
      zcl_gtt_tools=>throw_exception( ).
    ENDIF.

  ENDMETHOD.


  METHOD get_valid_datetime.

    rv_datetime   = COND #( WHEN iv_timestamp > 0
                              THEN |{ CONV char15( iv_timestamp ) ALPHA = IN }| ).

  ENDMETHOD.


  METHOD is_date.

    DATA(lo_type) = cl_abap_typedescr=>describe_by_data( p_data = iv_value ).

    rv_result     = boolc( lo_type->type_kind = cl_abap_typedescr=>typekind_date ).

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


  METHOD is_object_changed.

    DATA: lv_dummy TYPE char255.

    FIELD-SYMBOLS: <ls_maintab>   TYPE any,
                   <lv_key_value> TYPE any.

    rv_result   = abap_false.

    IF is_app_object-update_indicator IS NOT INITIAL.
      IF is_structure_changed( ir_struct    = is_app_object-maintabref
                               iv_upd_field = iv_upd_field ) = abap_true.
        rv_result   = abap_true.
      ELSEIF iv_chk_mastertab = abap_true AND
             is_app_object-mastertabref IS BOUND AND
             is_structure_changed( ir_struct    = is_app_object-mastertabref
                                   iv_upd_field = iv_upd_field ) = abap_true.
        rv_result   = abap_true.
      ELSE.
        ASSIGN is_app_object-maintabref->* TO <ls_maintab>.

        IF <ls_maintab> IS ASSIGNED.
          ASSIGN COMPONENT iv_key_field OF STRUCTURE <ls_maintab> TO <lv_key_value>.

          IF <lv_key_value> IS ASSIGNED.
            LOOP AT it_check_tables ASSIGNING FIELD-SYMBOL(<ls_tables>).
              IF is_table_changed(
                   ir_table     = io_ef_parameters->get_appl_table( iv_tabledef = <ls_tables> )
                   iv_key_field = iv_key_field
                   iv_upd_field = iv_upd_field
                   iv_key_value = <lv_key_value> ) = abap_true.

                rv_result   = abap_true.
                EXIT.
              ENDIF.
            ENDLOOP.
          ELSE.
            MESSAGE e001(zgtt)
              WITH iv_key_field is_app_object-maintabdef
              INTO lv_dummy.
            zcl_gtt_tools=>throw_exception( ).
          ENDIF.
        ELSE.
          MESSAGE e002(zgtt) WITH '' INTO lv_dummy.
          zcl_gtt_tools=>throw_exception( ).
        ENDIF.
      ENDIF.
    ENDIF.

  ENDMETHOD.


  METHOD is_structure_changed.

    DATA: lv_fname TYPE char5,
          lv_dummy TYPE char100.

    FIELD-SYMBOLS: <ls_struct> TYPE any,
                   <lv_updkz>  TYPE any.

    rv_result = abap_false.

    ASSIGN ir_struct->* TO <ls_struct>.

    IF <ls_struct> IS ASSIGNED.
      ASSIGN COMPONENT iv_upd_field OF STRUCTURE <ls_struct> TO <lv_updkz>.

      IF <lv_updkz> IS ASSIGNED.

        rv_result   = boolc( <lv_updkz> IS NOT INITIAL ).

      ELSE.
        MESSAGE e001(zgtt) WITH iv_upd_field '' INTO lv_dummy.
        zcl_gtt_tools=>throw_exception( ).
      ENDIF.
    ELSE.
      MESSAGE e002(zgtt) WITH '' INTO lv_dummy.
      zcl_gtt_tools=>throw_exception( ).
    ENDIF.

  ENDMETHOD.


  METHOD is_table.

    DATA(lo_type) = cl_abap_typedescr=>describe_by_data( p_data = iv_value ).

    rv_result = boolc( lo_type->type_kind = cl_abap_typedescr=>typekind_table ).

  ENDMETHOD.


  METHOD is_table_changed.

    DATA: lv_fname TYPE char5,
          lv_dummy TYPE char100.

    FIELD-SYMBOLS: <lt_table>     TYPE ANY TABLE,
                   <ls_table>     TYPE any,
                   <lv_key_value> TYPE any,
                   <lv_upd_value> TYPE any.

    rv_result = abap_false.

    ASSIGN ir_table->* TO <lt_table>.

    IF <lt_table> IS ASSIGNED.
      LOOP AT <lt_table> ASSIGNING <ls_table>.
        ASSIGN COMPONENT iv_key_field OF STRUCTURE <ls_table> TO <lv_key_value>.
        ASSIGN COMPONENT iv_upd_field OF STRUCTURE <ls_table> TO <lv_upd_value>.

        IF <lv_key_value> IS ASSIGNED AND
           <lv_upd_value> IS ASSIGNED.

          IF <lv_key_value>  = iv_key_value AND
             <lv_upd_value> IS NOT INITIAL.

            rv_result   = abap_true.
            EXIT.
          ENDIF.
        ELSE.
          lv_fname  = COND #( WHEN <lv_key_value> IS NOT ASSIGNED
                                THEN iv_key_field ELSE iv_upd_field ).
          MESSAGE e001(zgtt) WITH lv_fname '' INTO lv_dummy.
          zcl_gtt_tools=>throw_exception( ).
        ENDIF.
      ENDLOOP.
    ELSE.
      MESSAGE e002(zgtt) WITH '' INTO lv_dummy.
      zcl_gtt_tools=>throw_exception( ).
    ENDIF.

  ENDMETHOD.


  METHOD is_timestamp.

    DATA lo_elem  TYPE REF TO cl_abap_elemdescr.

    DATA(lo_type) = cl_abap_typedescr=>describe_by_data( p_data = iv_value ).


    IF lo_type IS INSTANCE OF cl_abap_elemdescr.
      lo_elem ?= lo_type.

      rv_result   = boolc( lo_elem->help_id = zif_gtt_ef_constants=>cs_date_types-timestamp ).
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


  METHOD is_appropriate_odlv_item.

    DATA:
      lt_tvlp     TYPE STANDARD TABLE OF tvlp,
      lt_dlv_type TYPE rseloption.

    CLEAR rv_result.

    zcl_gtt_tools=>get_delivery_type(
      RECEIVING
        rt_type = lt_dlv_type ).

    CHECK lt_dlv_type IS NOT INITIAL.

    DATA(lv_lfart) = CONV lfart( zcl_gtt_tools=>get_field_of_structure(
                                   ir_struct_data = ir_likp
                                   iv_field_name  = 'LFART' ) ).

    IF lv_lfart NOT IN lt_dlv_type.
      RETURN.
    ENDIF.

    DATA(lv_pstyv)  = CONV pstyv_vl( zcl_gtt_tools=>get_field_of_structure(
                                       ir_struct_data = ir_lips
                                       iv_field_name  = 'PSTYV' ) ).

    CALL FUNCTION 'MCV_TVLP_READ'
      EXPORTING
        i_pstyv   = lv_pstyv
      TABLES
        t_tvlp    = lt_tvlp
      EXCEPTIONS
        not_found = 1
        OTHERS    = 2.

    IF sy-subrc = 0.
      rv_result = boolc( lt_tvlp[ 1 ]-vbtyp = if_sd_doc_category=>delivery ).
    ELSE.
      MESSAGE e057(00) WITH lv_pstyv '' '' 'TVLP'
        INTO DATA(lv_dummy).
      zcl_gtt_tools=>throw_exception( ).
    ENDIF.

  ENDMETHOD.


  METHOD is_appropriate_odlv_type.

    DATA:
      lt_dlv_type TYPE rseloption.

    CLEAR rv_result.

    zcl_gtt_tools=>get_delivery_type(
      RECEIVING
        rt_type = lt_dlv_type ).

    CHECK lt_dlv_type IS NOT INITIAL.

    DATA(lv_lfart) = CONV lfart( zcl_gtt_tools=>get_field_of_structure(
                                   ir_struct_data = ir_likp
                                   iv_field_name  = 'LFART' ) ).

    IF lv_lfart NOT IN lt_dlv_type.
      RETURN.
    ENDIF.

    DATA(lv_vbtyp)  = CONV vbtyp( zcl_gtt_tools=>get_field_of_structure(
                                    ir_struct_data = ir_likp
                                    iv_field_name  = 'VBTYP' ) ).

    rv_result = boolc( lv_vbtyp = if_sd_doc_category=>delivery ).

  ENDMETHOD.


  METHOD get_delivery_type.

    DATA:
      lt_dlvtype TYPE TABLE OF zgtt_dlvtype_rst,
      rs_type    TYPE rsdsselopt.

    CLEAR rt_type.

    SELECT *
      INTO TABLE lt_dlvtype
      FROM zgtt_dlvtype_rst
     WHERE active = abap_true.

    LOOP AT lt_dlvtype INTO DATA(ls_dlvtype).
      rs_type-sign = 'I'.
      rs_type-option = 'EQ'.
      rs_type-low = ls_dlvtype-lfart.
      APPEND rs_type TO rt_type.
      CLEAR rs_type.
    ENDLOOP.

  ENDMETHOD.


  METHOD is_appropriate_dl_item.

    DATA:
      lt_tvlp     TYPE STANDARD TABLE OF tvlp,
      lt_dlv_type TYPE rseloption.

    CLEAR rv_result.

    zcl_gtt_tools=>get_delivery_type(
      RECEIVING
        rt_type = lt_dlv_type ).

    CHECK lt_dlv_type IS NOT INITIAL.

    DATA(lv_lfart) = CONV lfart( zcl_gtt_tools=>get_field_of_structure(
                                   ir_struct_data = ir_likp
                                   iv_field_name  = 'LFART' ) ).

    IF lv_lfart NOT IN lt_dlv_type.
      RETURN.
    ENDIF.

    DATA(lv_pstyv)  = CONV pstyv_vl( zcl_gtt_tools=>get_field_of_structure(
                                       ir_struct_data = ir_lips
                                       iv_field_name  = 'PSTYV' ) ).

    CALL FUNCTION 'MCV_TVLP_READ'
      EXPORTING
        i_pstyv   = lv_pstyv
      TABLES
        t_tvlp    = lt_tvlp
      EXCEPTIONS
        not_found = 1
        OTHERS    = 2.

    IF sy-subrc = 0.
      rv_result = boolc( lt_tvlp[ 1 ]-vbtyp = if_sd_doc_category=>delivery_shipping_notif AND
                         lt_tvlp[ 1 ]-bwart IS NOT INITIAL ).
    ELSE.
      MESSAGE e057(00) WITH lv_pstyv '' '' 'TVLP'
        INTO DATA(lv_dummy).
      zcl_gtt_tools=>throw_exception( ).
    ENDIF.

  ENDMETHOD.


  METHOD is_appropriate_dl_type.

    DATA:
      lt_dlv_type TYPE rseloption.

    CLEAR rv_result.

    zcl_gtt_tools=>get_delivery_type(
      RECEIVING
        rt_type = lt_dlv_type ).

    CHECK lt_dlv_type IS NOT INITIAL.

    DATA(lv_lfart) = CONV lfart( zcl_gtt_tools=>get_field_of_structure(
                                   ir_struct_data = ir_likp
                                   iv_field_name  = 'LFART' ) ).

    IF lv_lfart NOT IN lt_dlv_type.
      RETURN.
    ENDIF.

    DATA(lv_vbtyp)  = CONV vbtyp( zcl_gtt_tools=>get_field_of_structure(
                                    ir_struct_data = ir_likp
                                    iv_field_name  = 'VBTYP' ) ).

    rv_result = boolc( lv_vbtyp = if_sd_doc_category=>delivery_shipping_notif ).

  ENDMETHOD.


  METHOD convert_matnr_to_external_frmt.

    CLEAR ev_result.
    CALL FUNCTION 'CONVERSION_EXIT_MATN1_OUTPUT'
      EXPORTING
        input  = iv_material
      IMPORTING
        output = ev_result.

  ENDMETHOD.


  METHOD CONVERT_TO_EXTERNAL_FRMT.

    CLEAR:ev_output.

    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
      EXPORTING
        input  = iv_input
      IMPORTING
        output = ev_output.

  ENDMETHOD.


  METHOD convert_unit_output.

    CLEAR:rv_output.

    CALL FUNCTION 'CONVERSION_EXIT_CUNIT_OUTPUT'
      EXPORTING
        input    = iv_input
        language = sy-langu
      IMPORTING
        output   = rv_output.

    CONDENSE rv_output NO-GAPS.

  ENDMETHOD.


  METHOD get_delivery_by_ref_doc.

    CLEAR et_vbeln.
    SELECT vbeln
      INTO TABLE et_vbeln
      FROM lips
     WHERE vgbel = iv_vgbel.

    SORT et_vbeln BY table_line.
    DELETE ADJACENT DUPLICATES FROM et_vbeln COMPARING ALL FIELDS.

  ENDMETHOD.


  METHOD get_po_so_by_delivery.

    DATA:
      lt_ref_doc_curr TYPE tt_ref_doc,
      ls_ref_doc_curr TYPE ts_ref_doc,
      lt_ref_doc_db   TYPE tt_ref_doc,
      ls_ref_doc_db   TYPE ts_ref_doc,
      lt_ref_doc_all  TYPE tt_ref_doc,
      ls_ref_doc_all  TYPE ts_ref_doc,
      lt_ref_list     TYPE tt_ref_list,
      ls_ref_list     TYPE ts_ref_list,
      ls_likp         TYPE likpvb,
      lt_likp_dt      TYPE tt_likp,
      ls_likp_dt      TYPE ts_likp.

    CLEAR et_ref_list.

    LOOP AT it_xlips INTO DATA(ls_lips) WHERE vgtyp = iv_vgtyp.
*    For purchase order,only need the inbound delivery
      IF ls_lips-vgtyp = if_sd_doc_category=>purchase_order.
        CLEAR ls_likp.
        READ TABLE it_xlikp INTO ls_likp WITH KEY vbeln = ls_lips-vbeln.
        IF sy-subrc = 0.
          IF ls_likp-vbtyp = if_sd_doc_category=>delivery.
            CONTINUE.
          ENDIF.
        ENDIF.
      ENDIF.
      ls_ref_doc_curr-vbeln = ls_lips-vbeln.
      ls_ref_doc_curr-vgbel = ls_lips-vgbel.
      APPEND ls_ref_doc_curr TO lt_ref_doc_curr.
      CLEAR ls_ref_doc_curr.
    ENDLOOP.

    SORT lt_ref_doc_curr BY vbeln vgbel.
    DELETE ADJACENT DUPLICATES FROM lt_ref_doc_curr COMPARING ALL FIELDS.

    IF lt_ref_doc_curr IS NOT INITIAL.
      SELECT vbeln
             vgbel
        INTO TABLE lt_ref_doc_db
        FROM lips
         FOR ALL ENTRIES IN lt_ref_doc_curr
       WHERE vgbel = lt_ref_doc_curr-vgbel.
    ENDIF.

    IF lt_ref_doc_db IS NOT INITIAL.
      SELECT vbeln
             vbtyp
        INTO TABLE lt_likp_dt
        FROM likp
         FOR ALL ENTRIES IN lt_ref_doc_db
       WHERE vbeln = lt_ref_doc_db-vbeln.
    ENDIF.

*   For purchase order,only need the inbound delivery
    IF iv_vgtyp = if_sd_doc_category=>purchase_order.
      LOOP AT lt_ref_doc_db INTO ls_ref_doc_db.
        CLEAR ls_likp_dt.
        READ TABLE lt_likp_dt INTO ls_likp_dt WITH KEY vbeln = ls_ref_doc_db-vbeln.
        IF sy-subrc = 0.
          IF ls_likp_dt-vbtyp = if_sd_doc_category=>delivery.
            DELETE lt_ref_doc_db.
          ENDIF.
        ENDIF.
      ENDLOOP.
    ENDIF.

    APPEND LINES OF lt_ref_doc_curr TO lt_ref_doc_all.
    APPEND LINES OF lt_ref_doc_db TO lt_ref_doc_all.

    SORT lt_ref_doc_all BY vbeln vgbel.
    DELETE ADJACENT DUPLICATES FROM lt_ref_doc_all COMPARING ALL FIELDS.

    LOOP AT lt_ref_doc_all INTO ls_ref_doc_all
      GROUP BY ls_ref_doc_all-vgbel ASSIGNING FIELD-SYMBOL(<ft_ref_group>).

      LOOP AT GROUP <ft_ref_group> ASSIGNING FIELD-SYMBOL(<fs_ref>).
        ls_ref_list-vgbel = <fs_ref>-vgbel.
*       Do not consider the deleted delivery
        CLEAR ls_likp.
        READ TABLE it_xlikp INTO ls_likp WITH KEY vbeln = <fs_ref>-vbeln.
        IF sy-subrc = 0 AND ls_likp-updkz = /bobf/if_frw_c=>sc_modify_delete.
          CLEAR <fs_ref>-vbeln.
        ENDIF.
        IF <fs_ref>-vbeln IS NOT INITIAL.
          APPEND <fs_ref>-vbeln TO ls_ref_list-vbeln.
        ENDIF.
      ENDLOOP.
      IF ls_ref_list IS NOT INITIAL.
        APPEND ls_ref_list TO lt_ref_list.
      ENDIF.
      CLEAR ls_ref_list.
    ENDLOOP.

    et_ref_list = lt_ref_list.

  ENDMETHOD.


  METHOD get_tco_for_doc.

    DATA:
      ls_ekko TYPE ekko.

    CLEAR:rv_base_btd_tco.

    ls_ekko = is_ekko.

*   Read MM type code
    TRY.
        cl_mmpur_db_utility_general=>get_t161(
          EXPORTING
            im_bsart = ls_ekko-bsart
            im_bstyp = ls_ekko-bstyp
          RECEIVING
            re_t161  = DATA(ls_t161) ).
      CATCH cx_mmpur_not_found INTO DATA(lo_cx_mmpur).
        lo_cx_mmpur->get_messages(
          IMPORTING
            et_msg = DATA(lt_exception_msg) ).
        CLEAR ls_t161.
    ENDTRY.

    /scmtms/cl_logint_cmn_reuse=>get_tco_for_doc(
      EXPORTING
        iv_bstyp      = ls_ekko-bstyp
        iv_reswk      = ls_ekko-reswk
        iv_msr_active = ls_t161-msr_active
      IMPORTING
        ev_btd_tco    = rv_base_btd_tco ).

  ENDMETHOD.
ENDCLASS.
