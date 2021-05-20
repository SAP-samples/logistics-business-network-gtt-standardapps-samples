class ZCL_GTT_STS_TOOLS definition
  public
  create public .

public section.

  constants:
    BEGIN OF cs_condition,
        true  TYPE sy-binpt VALUE 'T',
        false TYPE sy-binpt VALUE 'F',
      END OF cs_condition .

  class-methods ARE_STRUCTURES_DIFFERENT
    importing
      !IR_DATA1 type ref to DATA
      !IR_DATA2 type ref to DATA
    returning
      value(RV_RESULT) type SY-BINPT
    raising
      CX_UDM_MESSAGE .
  class-methods GET_POSTAL_ADDRESS
    importing
      !IV_NODE_ID type /SCMTMS/BO_NODE_ID
    exporting
      !ET_POSTAL_ADDRESS type /BOFU/T_ADDR_POSTAL_ADDRESSK
    raising
      CX_UDM_MESSAGE .
  class-methods CONVERT_UTC_TIMESTAMP
    importing
      !IV_TIMEZONE type TTZZ-TZONE
    changing
      !CV_TIMESTAMP type /SCMTMS/TIMESTAMP
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
  class-methods IS_NUMBER
    importing
      !IV_VALUE type ANY
    returning
      value(RV_RESULT) type ABAP_BOOL .
  class-methods IS_TABLE
    importing
      !IV_VALUE type ANY
    returning
      value(RV_RESULT) type ABAP_BOOL .
  class-methods THROW_EXCEPTION
    importing
      !IV_TEXTID type SOTR_CONC default ''
    raising
      CX_UDM_MESSAGE .
  class-methods GET_STOP_POINTS
    importing
      !IV_ROOT_ID type /SCMTMS/TOR_ID
      !IT_STOP type /SCMTMS/T_EM_BO_TOR_STOP
    exporting
      !ET_STOP_POINTS type ZIF_GTT_STS_EF_TYPES=>TT_STOP_POINTS .
  class-methods IS_ODD
    importing
      !IV_VALUE type N
    returning
      value(RV_IS_ODD) type ABAP_BOOL .
  class-methods GET_CAPA_MATCH_KEY
    importing
      !IV_ASSGN_STOP_KEY type /SCMTMS/TOR_STOP_KEY
      !IT_CAPA_STOP type /SCMTMS/T_EM_BO_TOR_STOP
      !IT_CAPA_ROOT type /SCMTMS/T_EM_BO_TOR_ROOT
      !IV_BEFORE_IMAGE type ABAP_BOOL optional
    returning
      value(RV_CAPA_MATCHKEY) type /SAPTRX/LOC_ID_2 .
  class-methods CHECK_IS_FO_DELETED
    importing
      !IS_ROOT_NEW type /SCMTMS/S_EM_BO_TOR_ROOT
      !IS_ROOT_OLD type /SCMTMS/S_EM_BO_TOR_ROOT
    returning
      value(RV_RESULT) type ZIF_GTT_STS_EF_TYPES=>TV_CONDITION
    raising
      CX_UDM_MESSAGE .
  class-methods GET_FO_TRACKED_ITEM_OBJ
    importing
      !IS_APP_OBJECT type TRXAS_APPOBJ_CTAB_WA
      !IS_ROOT type /SCMTMS/S_EM_BO_TOR_ROOT
      !IT_ITEM type /SCMTMS/T_EM_BO_TOR_ITEM
      !IV_APPSYS type /SAPTRX/APPLSYSTEM
      !IV_OLD_DATA type ABAP_BOOL default ABAP_FALSE
    changing
      !CT_TRACK_ID_DATA type ZIF_GTT_STS_EF_TYPES=>TT_ENH_TRACK_ID_DATA
    raising
      CX_UDM_MESSAGE .
  class-methods GET_TRACK_OBJ_CHANGES
    importing
      !IS_APP_OBJECT type TRXAS_APPOBJ_CTAB_WA
      !IV_APPSYS type /SAPTRX/APPLSYSTEM
      !IT_TRACK_ID_DATA_NEW type ZIF_GTT_STS_EF_TYPES=>TT_ENH_TRACK_ID_DATA
      !IT_TRACK_ID_DATA_OLD type ZIF_GTT_STS_EF_TYPES=>TT_ENH_TRACK_ID_DATA
    changing
      !CT_TRACK_ID_DATA type ZIF_GTT_STS_EF_TYPES=>TT_TRACK_ID_DATA
    raising
      CX_UDM_MESSAGE .
  class-methods GET_TRMODCOD
    importing
      !IV_TRMODCOD type /SCMTMS/TRMODCODE
    returning
      value(RV_TRMODCOD) type /SCMTMS/TRMODCODE .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_GTT_STS_TOOLS IMPLEMENTATION.


  METHOD are_structures_different.

    DATA: lt_fields TYPE cl_abap_structdescr=>component_table,
          lv_dummy  TYPE char100 ##needed.

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

      rv_result = cs_condition-false.

      LOOP AT lt_fields ASSIGNING FIELD-SYMBOL(<ls_fields>).
        ASSIGN COMPONENT <ls_fields>-name OF STRUCTURE <ls_data1> TO <lv_value1>.
        ASSIGN COMPONENT <ls_fields>-name OF STRUCTURE <ls_data2> TO <lv_value2>.

        IF <lv_value1> IS ASSIGNED AND
           <lv_value2> IS ASSIGNED.
          IF <lv_value1> <> <lv_value2>.
            rv_result   = cs_condition-true.
            EXIT.
          ENDIF.
        ELSE.
          MESSAGE e001(zgtt_sts) WITH <ls_fields>-name INTO lv_dummy.
          zcl_gtt_sts_tools=>throw_exception( ).
        ENDIF.
      ENDLOOP.
    ELSE.
      MESSAGE e002(zgtt_sts) INTO lv_dummy.
      zcl_gtt_sts_tools=>throw_exception( ).
    ENDIF.

  ENDMETHOD.


  METHOD check_is_fo_deleted.

    rv_result = zif_gtt_sts_ef_constants=>cs_condition-false.

    DATA(lv_carrier_removed) = xsdbool(
            is_root_old-tsp IS INITIAL AND is_root_new-tsp IS NOT INITIAL ).

    DATA(lv_execution_status_changed) = xsdbool(
      ( is_root_old-execution <> /scmtms/if_tor_status_c=>sc_root-execution-v_in_execution        AND
        is_root_old-execution <> /scmtms/if_tor_status_c=>sc_root-execution-v_ready_for_execution AND
        is_root_old-execution <> /scmtms/if_tor_status_c=>sc_root-execution-v_executed )          AND
      ( is_root_new-execution  = /scmtms/if_tor_status_c=>sc_root-execution-v_in_execution        OR
        is_root_new-execution  = /scmtms/if_tor_status_c=>sc_root-execution-v_ready_for_execution OR
        is_root_new-execution  = /scmtms/if_tor_status_c=>sc_root-execution-v_executed ) ).

    DATA(lv_lifecycle_status_changed) = xsdbool(
      ( is_root_old-lifecycle <> /scmtms/if_tor_status_c=>sc_root-lifecycle-v_in_process  AND
        is_root_old-lifecycle <> /scmtms/if_tor_status_c=>sc_root-lifecycle-v_completed ) AND
      ( is_root_new-lifecycle  = /scmtms/if_tor_status_c=>sc_root-lifecycle-v_in_process  OR
        is_root_new-lifecycle  = /scmtms/if_tor_status_c=>sc_root-lifecycle-v_completed ) ).

    IF lv_carrier_removed = abap_true OR lv_execution_status_changed = abap_true OR
       lv_lifecycle_status_changed = abap_true .
      rv_result = zif_gtt_sts_ef_constants=>cs_condition-true.
    ENDIF.

  ENDMETHOD.


  METHOD convert_utc_timestamp.

    DATA:
      lv_timestamp TYPE timestamp,
      lv_date      TYPE d,
      lv_time      TYPE t,
      lv_tz_utc    TYPE ttzz-tzone VALUE 'UTC',
      lv_dst       TYPE c LENGTH 1.

    lv_timestamp = cv_timestamp.
    CONVERT TIME STAMP lv_timestamp TIME ZONE iv_timezone
            INTO DATE lv_date TIME lv_time DAYLIGHT SAVING TIME lv_dst.

    CONVERT DATE lv_date TIME lv_time DAYLIGHT SAVING TIME lv_dst
            INTO TIME STAMP lv_timestamp TIME ZONE lv_tz_utc.
    cv_timestamp = lv_timestamp.

  ENDMETHOD.


  METHOD get_capa_match_key.

    DATA lt_stop TYPE /scmtms/t_em_bo_tor_stop.

    ASSIGN it_capa_stop[ node_id = iv_assgn_stop_key ] TO FIELD-SYMBOL(<ls_capa_stop>).
    IF sy-subrc <> 0.
      RETURN.
    ENDIF.

    ASSIGN it_capa_root[ node_id = <ls_capa_stop>-parent_node_id ]-tor_id TO FIELD-SYMBOL(<lv_tor_id>).
    IF sy-subrc <> 0.
      RETURN.
    ENDIF.

    /scmtms/cl_tor_helper_stop=>get_stop_sequence(
      EXPORTING
        it_root_key     = VALUE #( ( key = <ls_capa_stop>-parent_node_id ) )
        iv_before_image = iv_before_image
      IMPORTING
        et_stop_seq_d   = DATA(lt_stop_seq) ).

    ASSIGN lt_stop_seq[ root_key = <ls_capa_stop>-parent_node_id ] TO FIELD-SYMBOL(<ls_stop_seq>) ##WARN_OK.
    IF sy-subrc <> 0.
      RETURN.
    ENDIF.

    lt_stop = CORRESPONDING /scmtms/t_em_bo_tor_stop( <ls_stop_seq>-stop_seq ).
    ASSIGN <ls_stop_seq>-stop_map[ stop_key = <ls_capa_stop>-node_id ]-tabix TO FIELD-SYMBOL(<lv_seq_num>) ##WARN_OK.
    IF sy-subrc <> 0.
      RETURN.
    ENDIF.

    zcl_gtt_sts_tools=>get_stop_points(
      EXPORTING
        iv_root_id     = <lv_tor_id>
        it_stop        = lt_stop
      IMPORTING
        et_stop_points = DATA(lt_stop_points) ).

    ASSIGN lt_stop_points[ seq_num   = <lv_seq_num>
                           log_locid = <ls_capa_stop>-log_locid ] TO FIELD-SYMBOL(<ls_stop_point>) ##WARN_OK.
    IF sy-subrc = 0.
      rv_capa_matchkey = <ls_stop_point>-stop_id.
      SHIFT rv_capa_matchkey LEFT DELETING LEADING '0'.
    ENDIF.

  ENDMETHOD.


  METHOD get_errors_log.

    es_bapiret-id           = io_umd_message->m_msgid.
    es_bapiret-number       = io_umd_message->m_msgno.
    es_bapiret-type         = io_umd_message->m_msgty.
    es_bapiret-message_v1   = io_umd_message->m_msgv1.
    es_bapiret-message_v2   = io_umd_message->m_msgv2.
    es_bapiret-message_v3   = io_umd_message->m_msgv3.
    es_bapiret-message_v4   = io_umd_message->m_msgv4.
    es_bapiret-system       = iv_appsys.

  ENDMETHOD.


  METHOD get_field_of_structure.

    FIELD-SYMBOLS: <ls_struct> TYPE any,
                   <lv_value>  TYPE any.

    ASSIGN ir_struct_data->* TO <ls_struct>.

    IF <ls_struct> IS ASSIGNED.
      ASSIGN COMPONENT iv_field_name OF STRUCTURE <ls_struct> TO <lv_value>.
      IF <lv_value> IS ASSIGNED.
        rv_value    = <lv_value>.
      ELSE.
        zcl_gtt_sts_tools=>throw_exception( ).
      ENDIF.
    ELSE.
      zcl_gtt_sts_tools=>throw_exception( ).
    ENDIF.

  ENDMETHOD.


  METHOD get_fo_tracked_item_obj.

    CONSTANTS: cs_mtr_truck TYPE string VALUE '31'.

    LOOP AT it_item ASSIGNING FIELD-SYMBOL(<ls_item>).

      IF <ls_item>-platenumber IS ASSIGNED AND <ls_item>-res_id IS ASSIGNED AND <ls_item>-node_id IS ASSIGNED AND
         <ls_item>-item_cat    IS ASSIGNED AND <ls_item>-item_cat = /scmtms/if_tor_const=>sc_tor_item_category-av_item.

        IF is_root-tor_id IS NOT INITIAL AND <ls_item>-res_id IS NOT INITIAL.
          APPEND VALUE #( key = <ls_item>-node_id
                  appsys      = iv_appsys
                  appobjtype  = is_app_object-appobjtype
                  appobjid    = is_app_object-appobjid
                  trxcod      = zif_gtt_sts_constants=>cs_trxcod-fo_resource
                  trxid       = |{ is_root-tor_id }{ <ls_item>-res_id }|
                  start_date  = zcl_gtt_sts_tools=>get_system_date_time( )
                  end_date    = zif_gtt_sts_ef_constants=>cv_max_end_date
                  timzon      = zcl_gtt_sts_tools=>get_system_time_zone( )
                  msrid       = space  ) TO ct_track_id_data.
        ENDIF.

        DATA(lv_mtr) = is_root-mtr.
        SELECT SINGLE motscode FROM /sapapo/trtype INTO lv_mtr WHERE ttype = lv_mtr.
        SHIFT lv_mtr LEFT DELETING LEADING '0'.
        IF is_root-tor_id IS NOT INITIAL AND <ls_item>-platenumber IS NOT INITIAL AND lv_mtr = cs_mtr_truck.
          APPEND VALUE #( key = |{ <ls_item>-node_id }P|
                  appsys      = iv_appsys
                  appobjtype  = is_app_object-appobjtype
                  appobjid    = is_app_object-appobjid
                  trxcod      = zif_gtt_sts_constants=>cs_trxcod-fo_resource
                  trxid       = |{ is_root-tor_id }{ <ls_item>-platenumber }|
                  start_date  = zcl_gtt_sts_tools=>get_system_date_time( )
                  end_date    = zif_gtt_sts_ef_constants=>cv_max_end_date
                  timzon      = zcl_gtt_sts_tools=>get_system_time_zone( )
                  msrid       = space  ) TO ct_track_id_data.
        ENDIF.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.


  METHOD get_local_timestamp.

    rv_timestamp    = COND #( WHEN iv_date IS NOT INITIAL
                                THEN |0{ iv_date }{ iv_time }| ).

  ENDMETHOD.


  METHOD get_postal_address.

    DATA(lo_tor_srv_mgr) = /bobf/cl_tra_serv_mgr_factory=>get_service_manager( iv_bo_key = /scmtms/if_tor_c=>sc_bo_key ).
    DATA(lo_loc_srv_mgr) = /bobf/cl_tra_serv_mgr_factory=>get_service_manager( iv_bo_key = /scmtms/if_location_c=>sc_bo_key ).

    lo_tor_srv_mgr->retrieve_by_association(
        EXPORTING
          iv_node_key    = /scmtms/if_tor_c=>sc_node-root
          it_key         = VALUE #( ( key = iv_node_id ) )
          iv_association = /scmtms/if_tor_c=>sc_association-root-stop
        IMPORTING
          et_target_key  = DATA(lt_stop_target_key) ).

    IF lt_stop_target_key IS NOT INITIAL.
      lo_tor_srv_mgr->retrieve_by_association(
        EXPORTING
          iv_node_key    = /scmtms/if_tor_c=>sc_node-stop
          it_key         = CORRESPONDING #( lt_stop_target_key )
          iv_association = /scmtms/if_tor_c=>sc_association-stop-bo_loc_log
        IMPORTING
          et_key_link    = DATA(lt_loc_log_key_link) ).

      IF lt_loc_log_key_link IS NOT INITIAL.
        lo_loc_srv_mgr->retrieve_by_association(
        EXPORTING
          iv_node_key    = /scmtms/if_location_c=>sc_node-root
          it_key         = CORRESPONDING #( lt_loc_log_key_link MAPPING key = target_key )
          iv_association = /scmtms/if_location_c=>sc_association-root-address
        IMPORTING
          et_key_link    = DATA(lt_address_key_link) ).

        IF lt_address_key_link IS NOT INITIAL.
          TRY.
              DATA(lr_bo_conf) = /bobf/cl_frw_factory=>get_configuration( iv_bo_key = /scmtms/if_location_c=>sc_bo_key ).
            CATCH /bobf/cx_frw.
              MESSAGE e011(zgtt_sts) INTO DATA(lv_dummy) ##needed.
              zcl_gtt_sts_tools=>throw_exception( ).
          ENDTRY.

          DATA(lv_postal_ass_key) = lr_bo_conf->get_content_key_mapping(
                           iv_content_cat      = /bobf/if_conf_c=>sc_content_ass
                           iv_do_content_key   = /bofu/if_addr_constants=>sc_association-root-postal_address
                           iv_do_root_node_key = /scmtms/if_location_c=>sc_node-/bofu/address ).

          lo_loc_srv_mgr->retrieve_by_association(
            EXPORTING
              iv_node_key    = /scmtms/if_location_c=>sc_node-/bofu/address
              it_key         = CORRESPONDING #( lt_address_key_link MAPPING key = target_key )
              iv_association = lv_postal_ass_key
              iv_fill_data   = abap_true
            IMPORTING
              et_data        = et_postal_address ).
        ENDIF.
      ENDIF.
    ENDIF.

  ENDMETHOD.


  METHOD get_pretty_value.

    rv_pretty   = COND #( WHEN zcl_gtt_sts_tools=>is_number( iv_value = iv_value ) = abap_true
                            THEN |{ iv_value }|
                            ELSE iv_value ).

  ENDMETHOD.


  METHOD get_stop_points.

    DATA lv_order(4) TYPE n VALUE '0001'.

    LOOP AT it_stop USING KEY parent_seqnum ASSIGNING FIELD-SYMBOL(<ls_stop>).
      IF NOT zcl_gtt_sts_tools=>is_odd( <ls_stop>-seq_num ).
        lv_order += 1.
      ENDIF.
      APPEND VALUE #( stop_id   = |{ iv_root_id }{ lv_order }|
                      log_locid = <ls_stop>-log_locid
                      seq_num   = <ls_stop>-seq_num ) TO et_stop_points.
    ENDLOOP.

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
      MESSAGE e003(zpof_gtt) INTO DATA(lv_dummy) ##needed.
      zcl_gtt_sts_tools=>throw_exception( ).
    ENDIF.

  ENDMETHOD.


  METHOD get_track_obj_changes.

    DATA(lt_track_id_data_new) = it_track_id_data_new.
    DATA(lt_track_id_data_old) = it_track_id_data_old.

    LOOP AT lt_track_id_data_new ASSIGNING FIELD-SYMBOL(<ls_track_id_data>)
      WHERE trxcod = zif_gtt_sts_constants=>cs_trxcod-fo_resource.
      READ TABLE lt_track_id_data_old WITH KEY key = <ls_track_id_data>-key ASSIGNING FIELD-SYMBOL(<ls_track_id_data_old>).
      IF sy-subrc = 0.
        DATA(lt_fields) = CAST cl_abap_structdescr( cl_abap_typedescr=>describe_by_data(
                                                        p_data = <ls_track_id_data> ) )->get_included_view( ).
        DATA(lv_result) = abap_false.

        LOOP AT lt_fields ASSIGNING FIELD-SYMBOL(<ls_fields>).
          ASSIGN COMPONENT <ls_fields>-name OF STRUCTURE <ls_track_id_data> TO FIELD-SYMBOL(<lv_value1>).
          ASSIGN COMPONENT <ls_fields>-name OF STRUCTURE <ls_track_id_data_old> TO FIELD-SYMBOL(<lv_value2>).

          IF <lv_value1> IS ASSIGNED AND
             <lv_value2> IS ASSIGNED.
            IF <lv_value1> <> <lv_value2>.
              lv_result   = abap_true.
              EXIT.
            ENDIF.
          ENDIF.
        ENDLOOP.

        IF lv_result = abap_true.

          APPEND VALUE #( appsys      = iv_appsys
                          appobjtype  = is_app_object-appobjtype
                          appobjid    = is_app_object-appobjid
                          trxcod      = <ls_track_id_data>-trxcod
                          trxid       = <ls_track_id_data>-trxid
                          start_date  = zcl_gtt_sts_tools=>get_system_date_time( )
                          end_date    = zif_gtt_sts_ef_constants=>cv_max_end_date
                          timzon      = zcl_gtt_sts_tools=>get_system_time_zone( )
                          msrid       = space  ) TO ct_track_id_data.

          APPEND VALUE #( appsys      = iv_appsys
                          appobjtype  = is_app_object-appobjtype
                          appobjid    = is_app_object-appobjid
                          trxcod      = <ls_track_id_data_old>-trxcod
                          trxid       = <ls_track_id_data_old>-trxid
                          start_date  = zcl_gtt_sts_tools=>get_system_date_time( )
                          end_date    = zif_gtt_sts_ef_constants=>cv_max_end_date
                          timzon      = zcl_gtt_sts_tools=>get_system_time_zone( )
                          msrid       = space
                          action      = /scmtms/cl_scem_int_c=>sc_param_action-delete ) TO ct_track_id_data.
        ENDIF.

        DELETE lt_track_id_data_old WHERE key = <ls_track_id_data>-key.

      ELSE.
        APPEND VALUE #( appsys      = iv_appsys
                        appobjtype  = is_app_object-appobjtype
                        appobjid    = is_app_object-appobjid
                        trxcod      = <ls_track_id_data>-trxcod
                        trxid       = <ls_track_id_data>-trxid
                        start_date  = zcl_gtt_sts_tools=>get_system_date_time( )
                        end_date    = zif_gtt_sts_ef_constants=>cv_max_end_date
                        timzon      = zcl_gtt_sts_tools=>get_system_time_zone( )
                        msrid       = space ) TO ct_track_id_data.
      ENDIF.
    ENDLOOP.

    " Deleted resources
    LOOP AT lt_track_id_data_old ASSIGNING FIELD-SYMBOL(<ls_track_id_data_del>).
      APPEND VALUE #( appsys      = iv_appsys
                      appobjtype  = is_app_object-appobjtype
                      appobjid    = is_app_object-appobjid
                      trxcod      = <ls_track_id_data_del>-trxcod
                      trxid       = <ls_track_id_data_del>-trxid
                      start_date  = zcl_gtt_sts_tools=>get_system_date_time( )
                      end_date    = zif_gtt_sts_ef_constants=>cv_max_end_date
                      timzon      = zcl_gtt_sts_tools=>get_system_time_zone( )
                      msrid       = space
                      action      = /scmtms/cl_scem_int_c=>sc_param_action-delete ) TO ct_track_id_data.
    ENDLOOP.

  ENDMETHOD.


  METHOD get_trmodcod.

    CASE iv_trmodcod.
      WHEN '01'.
        rv_trmodcod = '03'.
      WHEN '02'.
        rv_trmodcod = '02'.
      WHEN '03'.
        rv_trmodcod = '01'.
      WHEN '05'.
        rv_trmodcod = '04'.
      WHEN '06'.
        rv_trmodcod = '05'.
      WHEN OTHERS.
        rv_trmodcod = ''.
    ENDCASE.

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


  METHOD is_odd.

    DATA lv_reminder TYPE n.
    lv_reminder = iv_value MOD 2.
    IF lv_reminder <> 0.
      rv_is_odd = abap_true.
    ELSE.
      rv_is_odd = abap_false.
    ENDIF.

  ENDMETHOD.


  METHOD is_table.

    DATA(lo_type) = cl_abap_typedescr=>describe_by_data( p_data = iv_value ).

    rv_result = boolc( lo_type->type_kind = cl_abap_typedescr=>typekind_table ).

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
ENDCLASS.
