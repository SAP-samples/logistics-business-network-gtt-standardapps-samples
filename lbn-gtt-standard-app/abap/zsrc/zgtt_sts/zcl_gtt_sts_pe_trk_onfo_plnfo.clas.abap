class ZCL_GTT_STS_PE_TRK_ONFO_PLNFO definition
  public
  final
  create public .

public section.

  types:
    BEGIN OF ts_req2capa_info,
        req_no              TYPE /scmtms/tor_id,
        req_key             TYPE /bobf/conf_key,
        req_stop_key        TYPE /bobf/conf_key,
        req_assgn_stop_key  TYPE /bobf/conf_key,
        req_log_locid       TYPE /scmtms/location_id,
        cap_no              TYPE /scmtms/tor_id,
        cap_key             TYPE /bobf/conf_key,
        cap_stop_key        TYPE /bobf/conf_key,
        cap_plan_trans_time TYPE /scmtms/stop_plan_date,
        cap_seq             TYPE numc04,
      END OF ts_req2capa_info .

  types:
    tt_req2capa_info TYPE TABLE OF ts_req2capa_info .

  methods GET_PLANNED_EVENTS
    importing
      !IR_FU_ROOT type ref to DATA
      !IV_APPSYS type /SAPTRX/APPLSYSTEM
      !IV_APPOBJTYPE type /SAPTRX/AOTYPE
      !IV_APPOBJID type /SAPTRX/AOID
    changing
      !CT_EXPEVENTDATA type ZIF_GTT_STS_EF_TYPES=>TT_EXPEVENTDATA
    raising
      CX_UDM_MESSAGE .
protected section.

  types TT_TRACK_OBJ TYPE TABLE OF /scmtms/package_id .

  data MV_APPSYS type /SAPTRX/APPLSYSTEM .
  data MV_APPOBJTYPE type /SAPTRX/AOTYPE .
  data MV_APPOBJID type /SAPTRX/AOID .
private section.

  methods GET_DATA_FOR_PLANNED_EVENT
    importing
      !IR_ROOT type ref to DATA
      !IR_FU_ROOT type ref to DATA
      !IT_FU_STOP type /SCMTMS/T_TOR_STOP_K
    exporting
      !ET_STOP type /SCMTMS/T_EM_BO_TOR_STOP
      !ET_STOP_POINTS type ZIF_GTT_STS_EF_TYPES=>TT_STOP_POINTS
    raising
      CX_UDM_MESSAGE .
  methods LOAD_START
    importing
      !IR_ROOT type ref to DATA
      !IT_STOP type /SCMTMS/T_EM_BO_TOR_STOP optional
      !IT_STOP_POINTS type ZIF_GTT_STS_EF_TYPES=>TT_STOP_POINTS optional
    changing
      !CT_EXPEVENTDATA type ZIF_GTT_STS_EF_TYPES=>TT_EXPEVENTDATA
    raising
      CX_UDM_MESSAGE .
  methods LOAD_END
    importing
      !IR_ROOT type ref to DATA
      !IT_STOP type /SCMTMS/T_EM_BO_TOR_STOP optional
      !IT_STOP_POINTS type ZIF_GTT_STS_EF_TYPES=>TT_STOP_POINTS optional
    changing
      !CT_EXPEVENTDATA type ZIF_GTT_STS_EF_TYPES=>TT_EXPEVENTDATA
    raising
      CX_UDM_MESSAGE .
  methods COUPLING
    importing
      !IR_ROOT type ref to DATA
      !IT_STOP type /SCMTMS/T_EM_BO_TOR_STOP optional
      !IT_STOP_POINTS type ZIF_GTT_STS_EF_TYPES=>TT_STOP_POINTS optional
    changing
      !CT_EXPEVENTDATA type ZIF_GTT_STS_EF_TYPES=>TT_EXPEVENTDATA
    raising
      CX_UDM_MESSAGE .
  methods DECOUPLING
    importing
      !IR_ROOT type ref to DATA
      !IT_STOP type /SCMTMS/T_EM_BO_TOR_STOP optional
      !IT_STOP_POINTS type ZIF_GTT_STS_EF_TYPES=>TT_STOP_POINTS optional
    changing
      !CT_EXPEVENTDATA type ZIF_GTT_STS_EF_TYPES=>TT_EXPEVENTDATA
    raising
      CX_UDM_MESSAGE .
  methods UNLOAD_START
    importing
      !IR_ROOT type ref to DATA
      !IT_STOP type /SCMTMS/T_EM_BO_TOR_STOP optional
      !IT_STOP_POINTS type ZIF_GTT_STS_EF_TYPES=>TT_STOP_POINTS optional
    changing
      !CT_EXPEVENTDATA type ZIF_GTT_STS_EF_TYPES=>TT_EXPEVENTDATA
    raising
      CX_UDM_MESSAGE .
  methods UNLOAD_END
    importing
      !IR_ROOT type ref to DATA
      !IT_STOP type /SCMTMS/T_EM_BO_TOR_STOP optional
      !IT_STOP_POINTS type ZIF_GTT_STS_EF_TYPES=>TT_STOP_POINTS optional
    changing
      !CT_EXPEVENTDATA type ZIF_GTT_STS_EF_TYPES=>TT_EXPEVENTDATA
    raising
      CX_UDM_MESSAGE .
  methods SHP_ARRIVAL
    importing
      !IR_ROOT type ref to DATA
      !IT_STOP type /SCMTMS/T_EM_BO_TOR_STOP optional
      !IT_STOP_POINTS type ZIF_GTT_STS_EF_TYPES=>TT_STOP_POINTS optional
    changing
      !CT_EXPEVENTDATA type ZIF_GTT_STS_EF_TYPES=>TT_EXPEVENTDATA
    raising
      CX_UDM_MESSAGE .
  methods SHP_DEPARTURE
    importing
      !IR_ROOT type ref to DATA
      !IT_STOP type /SCMTMS/T_EM_BO_TOR_STOP optional
      !IT_STOP_POINTS type ZIF_GTT_STS_EF_TYPES=>TT_STOP_POINTS optional
    changing
      !CT_EXPEVENTDATA type ZIF_GTT_STS_EF_TYPES=>TT_EXPEVENTDATA
    raising
      CX_UDM_MESSAGE .
  methods POD
    importing
      !IR_ROOT type ref to DATA
      !IT_STOP type /SCMTMS/T_EM_BO_TOR_STOP optional
      !IT_STOP_POINTS type ZIF_GTT_STS_EF_TYPES=>TT_STOP_POINTS optional
    changing
      !CT_EXPEVENTDATA type ZIF_GTT_STS_EF_TYPES=>TT_EXPEVENTDATA
    raising
      CX_UDM_MESSAGE .
  methods POPU
    importing
      !IR_ROOT type ref to DATA
      !IT_STOP type /SCMTMS/T_EM_BO_TOR_STOP optional
      !IT_STOP_POINTS type ZIF_GTT_STS_EF_TYPES=>TT_STOP_POINTS optional
    changing
      !CT_EXPEVENTDATA type ZIF_GTT_STS_EF_TYPES=>TT_EXPEVENTDATA
    raising
      CX_UDM_MESSAGE .
  methods GET_CAPA_DOC
    importing
      !IR_FU_ROOT type ref to DATA
    exporting
      !ET_FU_STOP type /SCMTMS/T_TOR_STOP_K
      !ET_CAPA type /SCMTMS/T_TOR_ROOT_K
    raising
      CX_UDM_MESSAGE .
  methods GET_TRACKING_INFO
    importing
      !IR_DATA type DATA
      !IV_OLD_DATA type ABAP_BOOL default ABAP_FALSE
    exporting
      !ET_TRACKED_OBJ type TT_TRACK_OBJ
    raising
      CX_UDM_MESSAGE .
  methods CHECK_IS_FO_DELETED
    importing
      !IR_FO_ROOT type ref to DATA
    returning
      value(RV_RESULT) type ZIF_GTT_STS_EF_TYPES=>TV_CONDITION
    raising
      CX_UDM_MESSAGE .
  methods PREPARE_DATA_FOR_PLANNED_EVENT
    importing
      !IS_CAPA type /SCMTMS/S_EM_BO_TOR_ROOT
      !IT_STOP_SEQ type /SCMTMS/T_EM_BO_TOR_STOP
      !IT_REQ2CAPA_INFO type TT_REQ2CAPA_INFO
    exporting
      !ET_STOP type /SCMTMS/T_EM_BO_TOR_STOP
      !ET_STOP_POINTS type ZIF_GTT_STS_EF_TYPES=>TT_STOP_POINTS .
ENDCLASS.



CLASS ZCL_GTT_STS_PE_TRK_ONFO_PLNFO IMPLEMENTATION.


  METHOD check_is_fo_deleted.

    FIELD-SYMBOLS <ls_root> TYPE /scmtms/s_em_bo_tor_root.

    rv_result = zif_gtt_sts_ef_constants=>cs_condition-false.

    ASSIGN ir_fo_root->* TO <ls_root>.
    IF sy-subrc <> 0.
      MESSAGE e010(zgtt_sts) INTO DATA(lv_dummy) ##needed.
      zcl_gtt_sts_tools=>throw_exception( ).
    ENDIF.

    IF <ls_root>-tsp IS INITIAL.
      DATA(lv_carrier_removed) = abap_true.
    ENDIF.

    IF ( <ls_root>-execution = /scmtms/if_tor_status_c=>sc_root-execution-v_not_relevant         OR
         <ls_root>-execution = /scmtms/if_tor_status_c=>sc_root-execution-v_not_started          OR
         <ls_root>-execution = /scmtms/if_tor_status_c=>sc_root-execution-v_cancelled            OR
         <ls_root>-execution = /scmtms/if_tor_status_c=>sc_root-execution-v_not_ready_for_execution ) .

      DATA(lv_execution_status_changed) = abap_true.
    ENDIF.

    IF ( <ls_root>-lifecycle <> /scmtms/if_tor_status_c=>sc_root-lifecycle-v_in_process AND
        <ls_root>-lifecycle <> /scmtms/if_tor_status_c=>sc_root-lifecycle-v_completed ) .
      DATA(lv_lifecycle_status_changed) = abap_true.
    ENDIF.

    IF lv_carrier_removed = abap_true OR lv_execution_status_changed = abap_true OR
       lv_lifecycle_status_changed = abap_true .
      rv_result = zif_gtt_sts_ef_constants=>cs_condition-true.
    ENDIF.

  ENDMETHOD.


  METHOD coupling.

    FIELD-SYMBOLS <ls_root> TYPE /scmtms/s_em_bo_tor_root.

    DATA:
      lt_loc_root TYPE /scmtms/t_bo_loc_root_k.

    ASSIGN ir_root->* TO <ls_root>.
    IF sy-subrc <> 0.
      MESSAGE e010(zgtt_sts) INTO DATA(lv_dummy) ##needed.
      zcl_gtt_sts_tools=>throw_exception( ).
    ENDIF.

    LOOP AT it_stop USING KEY parent_seqnum ASSIGNING FIELD-SYMBOL(<ls_stop>) WHERE parent_node_id = <ls_root>-node_id.
      CHECK <ls_stop>-stop_cat = /scmtms/if_common_c=>c_stop_category-outbound AND
            <ls_stop>-aggr_assgn_start_c IS NOT INITIAL AND
            <ls_stop>-aggr_assgn_end_c   IS NOT INITIAL.

      READ TABLE it_stop_points REFERENCE INTO DATA(ls_stop_points)
                                     WITH KEY log_locid = <ls_stop>-log_locid
                                              seq_num   = <ls_stop>-seq_num.
      CHECK sy-subrc = 0.

      TEST-SEAM coupling_lt_loc_root.
        /scmtms/cl_pln_bo_data=>get_loc_data(
          EXPORTING
            it_key      = VALUE #( ( key = <ls_stop>-log_loc_uuid ) )
          CHANGING
            ct_loc_root = lt_loc_root ).
      END-TEST-SEAM.

      READ TABLE lt_loc_root REFERENCE INTO DATA(ls_loc_root)
                                     WITH KEY key COMPONENTS key = <ls_stop>-log_loc_uuid.
      CHECK sy-subrc = 0.

      DATA(lv_tz) = COND tznzone( WHEN ls_loc_root->time_zone_code IS NOT INITIAL
                                  THEN ls_loc_root->time_zone_code
                                  ELSE sy-zonlo ).

      DATA(lv_exp_datetime)    = <ls_stop>-aggr_assgn_end_c.
      DATA(lv_er_exp_datetime) = <ls_stop>-aggr_assgn_start_c.

      zcl_gtt_sts_tools=>convert_utc_timestamp(
        EXPORTING
          iv_timezone  = lv_tz
        CHANGING
          cv_timestamp = lv_exp_datetime ).

      zcl_gtt_sts_tools=>convert_utc_timestamp(
        EXPORTING
          iv_timezone  = lv_tz
        CHANGING
          cv_timestamp = lv_er_exp_datetime ).

      APPEND VALUE #(
      appsys               = mv_appsys
      appobjtype           = mv_appobjtype
      language             = sy-langu
      appobjid             = mv_appobjid
      milestone            = zif_gtt_sts_constants=>cs_milestone-fo_coupling
      evt_exp_datetime     = |0{ lv_exp_datetime }|
      evt_er_exp_dtime     = |0{ lv_er_exp_datetime }|
      evt_exp_tzone        = lv_tz
      locid1               = <ls_stop>-log_locid
      locid2               = ls_stop_points->stop_id
      loctype              = zcl_gtt_sts_tools=>get_location_type( iv_locno = <ls_stop>-log_locid ) ) TO ct_expeventdata.

      CLEAR: lt_loc_root, ls_loc_root.
    ENDLOOP.

  ENDMETHOD.


  METHOD decoupling.

    FIELD-SYMBOLS <ls_root> TYPE /scmtms/s_em_bo_tor_root.

    DATA:
      lt_loc_root TYPE /scmtms/t_bo_loc_root_k.

    ASSIGN ir_root->* TO <ls_root>.
    IF sy-subrc <> 0.
      MESSAGE e010(zgtt_sts) INTO DATA(lv_dummy) ##needed.
      zcl_gtt_sts_tools=>throw_exception( ).
    ENDIF.

    LOOP AT it_stop USING KEY parent_seqnum ASSIGNING FIELD-SYMBOL(<ls_stop>) WHERE parent_node_id = <ls_root>-node_id.
      CHECK <ls_stop>-stop_cat = /scmtms/if_common_c=>c_stop_category-inbound AND
            <ls_stop>-aggr_assgn_start_c IS NOT INITIAL AND
            <ls_stop>-aggr_assgn_end_c   IS NOT INITIAL.

      READ TABLE it_stop_points REFERENCE INTO DATA(ls_stop_points)
                                     WITH KEY log_locid = <ls_stop>-log_locid
                                              seq_num   = <ls_stop>-seq_num.
      CHECK sy-subrc = 0.

      TEST-SEAM decoupling_lt_loc_root.
        /scmtms/cl_pln_bo_data=>get_loc_data(
          EXPORTING
            it_key      = VALUE #( ( key = <ls_stop>-log_loc_uuid ) )
          CHANGING
            ct_loc_root = lt_loc_root ).
      END-TEST-SEAM.

      READ TABLE lt_loc_root REFERENCE INTO DATA(ls_loc_root)
                                     WITH KEY key COMPONENTS key = <ls_stop>-log_loc_uuid.
      CHECK sy-subrc = 0.

      DATA(lv_tz) = COND tznzone( WHEN ls_loc_root->time_zone_code IS NOT INITIAL
                                  THEN ls_loc_root->time_zone_code
                                  ELSE sy-zonlo ).

      DATA(lv_exp_datetime)    = <ls_stop>-aggr_assgn_end_c.
      DATA(lv_er_exp_datetime) = <ls_stop>-aggr_assgn_start_c.

      zcl_gtt_sts_tools=>convert_utc_timestamp(
        EXPORTING
          iv_timezone  = lv_tz
        CHANGING
          cv_timestamp = lv_exp_datetime ).

      zcl_gtt_sts_tools=>convert_utc_timestamp(
        EXPORTING
          iv_timezone  = lv_tz
        CHANGING
          cv_timestamp = lv_er_exp_datetime ).

      APPEND VALUE #(
      appsys               = mv_appsys
      appobjtype           = mv_appobjtype
      language             = sy-langu
      appobjid             = mv_appobjid
      milestone            = zif_gtt_sts_constants=>cs_milestone-fo_decoupling
      evt_exp_datetime     = |0{ lv_exp_datetime }|
      evt_er_exp_dtime     = |0{ lv_er_exp_datetime }|
      evt_exp_tzone        = lv_tz
      locid1               = <ls_stop>-log_locid
      locid2               = ls_stop_points->stop_id
      loctype              = zcl_gtt_sts_tools=>get_location_type( iv_locno = <ls_stop>-log_locid ) ) TO ct_expeventdata.

      CLEAR: lt_loc_root, ls_loc_root.
    ENDLOOP.

  ENDMETHOD.


  METHOD GET_CAPA_DOC.

    FIELD-SYMBOLS:
      <ls_tor_root> TYPE /scmtms/s_em_bo_tor_root.

    DATA:
      lr_srvmgr_tor TYPE REF TO /bobf/if_tra_service_manager,
      lt_root_key   TYPE /bobf/t_frw_key.

    CLEAR:
      et_fu_stop,
      et_capa.

    ASSIGN ir_fu_root->* TO <ls_tor_root>.
    IF sy-subrc <> 0.
      MESSAGE e010(zgtt_sts) INTO DATA(lv_dummy) ##needed.
      zcl_gtt_sts_tools=>throw_exception( ).
    ENDIF.

    lt_root_key = VALUE #( ( key = <ls_tor_root>-node_id ) ).

    lr_srvmgr_tor = /bobf/cl_tra_serv_mgr_factory=>get_service_manager(
      iv_bo_key = /scmtms/if_tor_c=>sc_bo_key ).

    lr_srvmgr_tor->retrieve_by_association(
      EXPORTING
        iv_node_key     = /scmtms/if_tor_c=>sc_node-root
        it_key          = lt_root_key
        iv_association  = /scmtms/if_tor_c=>sc_association-root-stop
        iv_fill_data    = abap_true
        iv_before_image = abap_false
      IMPORTING
        et_data         = et_fu_stop ).

    lr_srvmgr_tor->retrieve_by_association(
      EXPORTING
        iv_node_key     = /scmtms/if_tor_c=>sc_node-root
        it_key          = lt_root_key
        iv_association  = /scmtms/if_tor_c=>sc_association-root-capa_tor
        iv_fill_data    = abap_true
        iv_before_image = abap_false
      IMPORTING
        et_data         = et_capa
        et_key_link     = DATA(lt_req2capa_link) ).

  ENDMETHOD.


  METHOD get_data_for_planned_event.

    FIELD-SYMBOLS:
      <ls_tor_root> TYPE /scmtms/s_em_bo_tor_root,
      <ls_fu_root>  TYPE /scmtms/s_em_bo_tor_root.

    DATA:
      lr_srvmgr_tor  TYPE REF TO /bobf/if_tra_service_manager,
      lv_tor_id      TYPE /scmtms/tor_id,
      lv_tor_node_id TYPE /scmtms/bo_node_id,
      lt_capa        TYPE /scmtms/t_tor_root_k,
      lt_fu_stop     TYPE /scmtms/t_tor_stop_k,
      lt_root_key    TYPE /bobf/t_frw_key.

    ASSIGN ir_root->* TO <ls_tor_root>.
    IF sy-subrc <> 0.
      MESSAGE e010(zgtt_sts) INTO DATA(lv_dummy) ##needed.
      zcl_gtt_sts_tools=>throw_exception( ).
    ENDIF.

    ASSIGN ir_fu_root->* TO <ls_fu_root>.
    IF sy-subrc <> 0.
      MESSAGE e010(zgtt_sts) INTO lv_dummy ##needed.
      zcl_gtt_sts_tools=>throw_exception( ).
    ENDIF.

    lv_tor_node_id = <ls_tor_root>-node_id.
    lv_tor_id = <ls_tor_root>-tor_id.
    SHIFT lv_tor_id LEFT DELETING LEADING '0'.

    TEST-SEAM lt_stop_seq.
      /scmtms/cl_tor_helper_stop=>get_stop_sequence(
        EXPORTING
          it_root_key     = VALUE #( ( key = lv_tor_node_id ) )
          iv_before_image = abap_false
        IMPORTING
          et_stop_seq_d   = DATA(lt_stop_seq) ).
    END-TEST-SEAM.

    ASSIGN lt_stop_seq[ root_key = lv_tor_node_id ] TO FIELD-SYMBOL(<ls_stop_seq>) ##WARN_OK.
    IF sy-subrc = 0.
      MOVE-CORRESPONDING <ls_stop_seq>-stop_seq TO et_stop.
      LOOP AT et_stop ASSIGNING FIELD-SYMBOL(<ls_stop>).
        <ls_stop>-parent_node_id = lv_tor_node_id.
        ASSIGN <ls_stop_seq>-stop_map[ tabix = <ls_stop>-seq_num ]-stop_key TO FIELD-SYMBOL(<lv_stop_key>).
        CHECK sy-subrc = 0.
        <ls_stop>-node_id = <lv_stop_key>.
      ENDLOOP.
    ENDIF.

    zcl_gtt_sts_tools=>get_stop_points(
      EXPORTING
        iv_root_id     = lv_tor_id
        it_stop        = et_stop
      IMPORTING
        et_stop_points = et_stop_points ).

    LOOP AT et_stop USING KEY parent_seqnum ASSIGNING FIELD-SYMBOL(<ls_fo_stop>).
      ASSIGN it_fu_stop[ assgn_stop_key = <ls_fo_stop>-node_id parent_key = <ls_fu_root>-node_id ] TO FIELD-SYMBOL(<ls_fu_stop>).
      IF sy-subrc <> 0.
        DELETE et_stop WHERE node_id = <ls_fo_stop>-node_id.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.


  METHOD get_planned_events.

    DATA:
      ls_expeventdata     TYPE zif_gtt_sts_ef_types=>ts_expeventdata,
      lt_tmp_expeventdata TYPE zif_gtt_sts_ef_types=>tt_expeventdata,
      lt_expeventdata     TYPE zif_gtt_sts_ef_types=>tt_expeventdata,
      lv_length           TYPE i,
      lv_prefix           TYPE char20,
      lv_suffix           TYPE char4,
      lv_locid2           TYPE /saptrx/loc_id_2,
      lv_counter          TYPE /saptrx/seq_num,
      ls_previous_line    TYPE /saptrx/exp_events,
      lv_shp_num_previous TYPE /saptrx/loc_id_2,
      lv_shp_num          TYPE /saptrx/loc_id_2.

    mv_appsys    = iv_appsys.
    mv_appobjtype  = iv_appobjtype.
    mv_appobjid  = iv_appobjid.

    zcl_gtt_sts_tools=>get_reqcapa_info_mul(
      EXPORTING
        ir_root          = ir_fu_root
        iv_old_data      = abap_false
      IMPORTING
        et_req2capa_info = DATA(lt_req2capa_info)
        et_capa_detail   = DATA(lt_capa)
        et_capa_stop_seq = DATA(lt_capa_stop_seq) ).

    LOOP AT lt_capa INTO DATA(ls_capa).

*     Check if FO is deleted
      check_is_fo_deleted(
        EXPORTING
          ir_fo_root = REF #( ls_capa )
        RECEIVING
          rv_result  = DATA(lv_result) ).

      IF lv_result = zif_gtt_sts_ef_constants=>cs_condition-true.
        CONTINUE.
      ENDIF.

      get_tracking_info(
        EXPORTING
          ir_data        = REF #( ls_capa )
        IMPORTING
          et_tracked_obj = DATA(lt_tracked_obj) ).

      IF lt_tracked_obj IS INITIAL.
        CONTINUE.
      ENDIF.

      prepare_data_for_planned_event(
        EXPORTING
          is_capa          = ls_capa
          it_stop_seq      = lt_capa_stop_seq
          it_req2capa_info = lt_req2capa_info
        IMPORTING
          et_stop          = DATA(lt_stop)
          et_stop_points   = DATA(lt_stop_points) ).

      shp_arrival(
        EXPORTING
          ir_root         = REF #( ls_capa )
          it_stop         = lt_stop
          it_stop_points  = lt_stop_points
        CHANGING
          ct_expeventdata = lt_tmp_expeventdata ).

      decoupling(
        EXPORTING
          ir_root         = REF #( ls_capa )
          it_stop         = lt_stop
          it_stop_points  = lt_stop_points
        CHANGING
          ct_expeventdata = lt_tmp_expeventdata ).

      unload_start(
        EXPORTING
          ir_root         = REF #( ls_capa )
          it_stop         = lt_stop
          it_stop_points  = lt_stop_points
        CHANGING
          ct_expeventdata = lt_tmp_expeventdata ).

      unload_end(
        EXPORTING
          ir_root         = REF #( ls_capa )
          it_stop         = lt_stop
          it_stop_points  = lt_stop_points
        CHANGING
          ct_expeventdata = lt_tmp_expeventdata ).

      pod(
        EXPORTING
          ir_root         = REF #( ls_capa )
          it_stop         = lt_stop
          it_stop_points  = lt_stop_points
        CHANGING
          ct_expeventdata = lt_tmp_expeventdata ).

      load_start(
        EXPORTING
          ir_root         = REF #( ls_capa )
          it_stop         = lt_stop
          it_stop_points  = lt_stop_points
        CHANGING
          ct_expeventdata = lt_tmp_expeventdata ).

      load_end(
        EXPORTING
          ir_root         = REF #( ls_capa )
          it_stop         = lt_stop
          it_stop_points  = lt_stop_points
        CHANGING
          ct_expeventdata = lt_tmp_expeventdata ).

      popu(
        EXPORTING
          ir_root         = REF #( ls_capa )
          it_stop         = lt_stop
          it_stop_points  = lt_stop_points
        CHANGING
          ct_expeventdata = lt_tmp_expeventdata ).

      coupling(
        EXPORTING
          ir_root         = REF #( ls_capa )
          it_stop         = lt_stop
          it_stop_points  = lt_stop_points
        CHANGING
          ct_expeventdata = lt_tmp_expeventdata ).

      shp_departure(
        EXPORTING
          ir_root         = REF #( ls_capa )
          it_stop         = lt_stop
          it_stop_points  = lt_stop_points
        CHANGING
          ct_expeventdata = lt_tmp_expeventdata ).

      SORT lt_tmp_expeventdata BY locid2 ASCENDING.

      LOOP AT lt_tracked_obj INTO DATA(ls_tracked_obj).
        LOOP AT lt_tmp_expeventdata INTO ls_expeventdata
          WHERE appsys     = mv_appsys
            AND appobjtype = mv_appobjtype
            AND language   = sy-langu
            AND appobjid   = mv_appobjid.

          CLEAR:
            lv_prefix,
            lv_suffix,
            lv_length,
            lv_locid2.

          lv_length = strlen( ls_expeventdata-locid2 ) - 4.
          lv_prefix = ls_expeventdata-locid2+0(lv_length).
          lv_suffix = ls_expeventdata-locid2+lv_length(*).
          lv_locid2 = |{ lv_prefix }{ ls_tracked_obj }{ lv_suffix }|.
          CONDENSE lv_locid2 NO-GAPS.

          APPEND VALUE #(
            appsys           = ls_expeventdata-appsys
            appobjtype       = ls_expeventdata-appobjtype
            language         = ls_expeventdata-language
            appobjid         = ls_expeventdata-appobjid
            milestone        = ls_expeventdata-milestone
            evt_exp_datetime = ls_expeventdata-evt_exp_datetime
            evt_exp_tzone    = ls_expeventdata-evt_exp_tzone
            locid1           = ls_expeventdata-locid1
            locid2           = lv_locid2
            loctype          = ls_expeventdata-loctype
            itemident        = ls_expeventdata-itemident ) TO lt_expeventdata.
          CLEAR ls_expeventdata.
        ENDLOOP.
      ENDLOOP.

      CLEAR:
        lv_result,
        ls_expeventdata,
        lt_stop,
        lt_stop_points,
        lt_tracked_obj,
        lt_tmp_expeventdata.

    ENDLOOP.

    LOOP AT lt_expeventdata ASSIGNING FIELD-SYMBOL(<ls_expeventdata>)
         GROUP BY <ls_expeventdata>-locid2 ASSIGNING FIELD-SYMBOL(<lt_expeventdata_group>).

      lv_counter = 1.
      DATA(lv_first) = abap_true.
      LOOP AT GROUP <lt_expeventdata_group> ASSIGNING FIELD-SYMBOL(<ls_expeventdata_group>).
        IF lv_counter = 1.
          IF line_exists( lt_expeventdata[ sy-tabix - 1 ] ).
            ls_previous_line =  lt_expeventdata[ sy-tabix - 1 ].
            lv_length = strlen( ls_previous_line-locid2 ) - 4.
            lv_shp_num_previous = ls_previous_line-locid2+0(lv_length).

            lv_length = strlen( <ls_expeventdata_group>-locid2 ) - 4.
            lv_shp_num = <ls_expeventdata_group>-locid2+0(lv_length).
            IF lv_shp_num = lv_shp_num_previous.
              lv_counter = lt_expeventdata[ sy-tabix - 1 ]-milestonenum + 1.
            ENDIF.

            CLEAR:
              ls_previous_line,
              lv_length,
              lv_shp_num_previous,
              lv_shp_num.
          ENDIF.
        ENDIF.
        <ls_expeventdata_group>-milestonenum = lv_counter.
        lv_counter += 1.

      ENDLOOP.
    ENDLOOP.

    ct_expeventdata = lt_expeventdata.

  ENDMETHOD.


  METHOD get_tracking_info.

    FIELD-SYMBOLS:
      <ls_root_new> TYPE /scmtms/s_em_bo_tor_root.

    DATA:
      lt_package_id  TYPE TABLE OF /scmtms/package_id,
      lt_mobile      TYPE TABLE OF /scmtms/package_id,
      lt_tracked_obj TYPE tt_track_obj.

    CLEAR et_tracked_obj.

    ASSIGN ir_data->* TO <ls_root_new>.
    IF sy-subrc <> 0.
      MESSAGE e010(zgtt_sts) INTO DATA(lv_dummy) ##needed.
      zcl_gtt_sts_tools=>throw_exception( ).
    ENDIF.

    zcl_gtt_sts_tools=>get_container_mobile_id(
      EXPORTING
        ir_root      = REF #( <ls_root_new> )
        iv_old_data  = iv_old_data
      CHANGING
        et_container = lt_tracked_obj
        et_mobile    = lt_mobile ).

    APPEND LINES OF lt_mobile TO lt_tracked_obj.

    IF <ls_root_new>-tor_cat = /scmtms/if_tor_const=>sc_tor_category-active.
      zcl_gtt_sts_tools=>get_plate_truck_number(
        EXPORTING
          ir_root        = REF #( <ls_root_new> )
          iv_old_data    = iv_old_data
        IMPORTING
          ev_platenumber = DATA(lv_platenumber) ).

      IF lv_platenumber IS NOT INITIAL.
        APPEND lv_platenumber TO lt_tracked_obj.
      ENDIF.
    ENDIF.

    et_tracked_obj = lt_tracked_obj.

  ENDMETHOD.


  METHOD load_end.

    FIELD-SYMBOLS <ls_root> TYPE /scmtms/s_em_bo_tor_root.

    DATA:
      lt_loc_root TYPE /scmtms/t_bo_loc_root_k.

    ASSIGN ir_root->* TO <ls_root>.
    IF sy-subrc <> 0.
      MESSAGE e010(zgtt_sts) INTO DATA(lv_dummy) ##needed.
      zcl_gtt_sts_tools=>throw_exception( ).
    ENDIF.

    LOOP AT it_stop USING KEY parent_seqnum ASSIGNING FIELD-SYMBOL(<ls_stop>) WHERE parent_node_id = <ls_root>-node_id.
      CHECK <ls_stop>-stop_cat = /scmtms/if_common_c=>c_stop_category-outbound AND
            <ls_stop>-aggr_assgn_start_l IS NOT INITIAL AND
            <ls_stop>-aggr_assgn_end_l   IS NOT INITIAL.

      READ TABLE it_stop_points REFERENCE INTO DATA(ls_stop_points) WITH KEY log_locid = <ls_stop>-log_locid
                                                                             seq_num   = <ls_stop>-seq_num.
      CHECK sy-subrc = 0.

      TEST-SEAM load_end_lt_loc_root.
        /scmtms/cl_pln_bo_data=>get_loc_data(
          EXPORTING
            it_key      = VALUE #( ( key = <ls_stop>-log_loc_uuid ) )
          CHANGING
            ct_loc_root = lt_loc_root ).
      END-TEST-SEAM.

      READ TABLE lt_loc_root REFERENCE INTO DATA(ls_loc_root) WITH KEY key COMPONENTS key = <ls_stop>-log_loc_uuid.
      CHECK sy-subrc = 0.

      DATA(lv_tz) = COND tznzone( WHEN ls_loc_root->time_zone_code IS NOT INITIAL THEN ls_loc_root->time_zone_code
                                  ELSE sy-zonlo ).

      DATA(lv_exp_datetime) = <ls_stop>-aggr_assgn_end_l.

      zcl_gtt_sts_tools=>convert_utc_timestamp(
        EXPORTING
          iv_timezone  =  lv_tz
        CHANGING
          cv_timestamp = lv_exp_datetime ).

      APPEND VALUE #(
        appsys           = mv_appsys
        appobjtype       = mv_appobjtype
        language         = sy-langu
        appobjid         = mv_appobjid
        milestone        = zif_gtt_sts_constants=>cs_milestone-fo_load_end
        evt_exp_datetime = |0{ lv_exp_datetime }|
        evt_exp_tzone    = lv_tz
        locid1           = <ls_stop>-log_locid
        locid2           = ls_stop_points->stop_id
        loctype          = zcl_gtt_sts_tools=>get_location_type( iv_locno = <ls_stop>-log_locid )
        itemident        = <ls_stop>-node_id ) TO ct_expeventdata.

      CLEAR: lt_loc_root, ls_loc_root.
    ENDLOOP.

  ENDMETHOD.


  METHOD load_start.

    FIELD-SYMBOLS <ls_root> TYPE /scmtms/s_em_bo_tor_root.

    DATA:
      lt_loc_root TYPE /scmtms/t_bo_loc_root_k.

    ASSIGN ir_root->* TO <ls_root>.
    IF sy-subrc <> 0.
      MESSAGE e010(zgtt_sts) INTO DATA(lv_dummy) ##needed.
      zcl_gtt_sts_tools=>throw_exception( ).
    ENDIF.

    LOOP AT it_stop USING KEY parent_seqnum ASSIGNING FIELD-SYMBOL(<ls_stop>) WHERE parent_node_id = <ls_root>-node_id.
      CHECK <ls_stop>-stop_cat = /scmtms/if_common_c=>c_stop_category-outbound AND
            <ls_stop>-aggr_assgn_start_l IS NOT INITIAL AND
            <ls_stop>-aggr_assgn_end_l   IS NOT INITIAL.

      READ TABLE it_stop_points REFERENCE INTO DATA(ls_stop_points)
                                     WITH KEY log_locid = <ls_stop>-log_locid
                                              seq_num   = <ls_stop>-seq_num.
      CHECK sy-subrc = 0.

      TEST-SEAM load_start_lt_loc_root.
        /scmtms/cl_pln_bo_data=>get_loc_data(
          EXPORTING
            it_key      = VALUE #( ( key = <ls_stop>-log_loc_uuid ) )
          CHANGING
            ct_loc_root = lt_loc_root ).
      END-TEST-SEAM.

      READ TABLE lt_loc_root REFERENCE INTO DATA(ls_loc_root)
                                     WITH KEY key COMPONENTS key = <ls_stop>-log_loc_uuid.
      CHECK sy-subrc = 0.

      DATA(lv_tz) = COND tznzone( WHEN ls_loc_root->time_zone_code IS NOT INITIAL
                                  THEN ls_loc_root->time_zone_code
                                  ELSE sy-zonlo ).

      DATA(lv_exp_datetime) = <ls_stop>-aggr_assgn_start_l.

      zcl_gtt_sts_tools=>convert_utc_timestamp(
        EXPORTING
          iv_timezone  = lv_tz
        CHANGING
          cv_timestamp = lv_exp_datetime ).

      APPEND VALUE #(
      appsys            = mv_appsys
      appobjtype        = mv_appobjtype
      language          = sy-langu
      appobjid          = mv_appobjid
      milestone         = zif_gtt_sts_constants=>cs_milestone-fo_load_start
      evt_exp_datetime  = |0{ lv_exp_datetime }|
      evt_exp_tzone     = lv_tz
      locid1            = <ls_stop>-log_locid
      locid2            = ls_stop_points->stop_id
      loctype           = zcl_gtt_sts_tools=>get_location_type( iv_locno = <ls_stop>-log_locid ) ) TO ct_expeventdata.

      CLEAR: lt_loc_root, ls_loc_root.
    ENDLOOP.

  ENDMETHOD.


  METHOD pod.

    FIELD-SYMBOLS <ls_root> TYPE /scmtms/s_em_bo_tor_root.

    DATA:
      lt_loc_root TYPE /scmtms/t_bo_loc_root_k.

    ASSIGN ir_root->* TO <ls_root>.
    IF sy-subrc <> 0.
      MESSAGE e010(zgtt_sts) INTO DATA(lv_dummy) ##needed.
      zcl_gtt_sts_tools=>throw_exception( ).
    ENDIF.

    LOOP AT it_stop USING KEY parent_seqnum ASSIGNING FIELD-SYMBOL(<ls_stop>) WHERE parent_node_id = <ls_root>-node_id.
      CHECK <ls_stop>-stop_cat = /scmtms/if_common_c=>c_stop_category-inbound AND
            <ls_stop>-aggr_assgn_start_l IS NOT INITIAL AND
            <ls_stop>-aggr_assgn_end_l   IS NOT INITIAL.

      READ TABLE it_stop_points REFERENCE INTO DATA(ls_stop_points) WITH KEY log_locid = <ls_stop>-log_locid
                                                                             seq_num   = <ls_stop>-seq_num.
      CHECK sy-subrc = 0.

      TEST-SEAM pod_lt_loc_root.
        /scmtms/cl_pln_bo_data=>get_loc_data(
          EXPORTING
            it_key      = VALUE #( ( key = <ls_stop>-log_loc_uuid ) )
          CHANGING
            ct_loc_root = lt_loc_root ).
      END-TEST-SEAM.

      READ TABLE lt_loc_root REFERENCE INTO DATA(ls_loc_root)
                                     WITH KEY key COMPONENTS key = <ls_stop>-log_loc_uuid.
      CHECK sy-subrc = 0.

      DATA(lv_tz) = COND tznzone( WHEN ls_loc_root->time_zone_code IS NOT INITIAL THEN ls_loc_root->time_zone_code
                                  ELSE sy-zonlo ).

      DATA(lv_exp_datetime) = <ls_stop>-aggr_assgn_end_l.

      zcl_gtt_sts_tools=>convert_utc_timestamp(
        EXPORTING
          iv_timezone  = lv_tz
        CHANGING
          cv_timestamp = lv_exp_datetime ).

      APPEND VALUE #(
        appsys           = mv_appsys
        appobjtype       = mv_appobjtype
        language         = sy-langu
        appobjid         = mv_appobjid
        milestone        = zif_gtt_sts_constants=>cs_milestone-fo_shp_pod
        evt_exp_datetime = |0{ lv_exp_datetime }|
        evt_exp_tzone    = lv_tz
        locid1           = <ls_stop>-log_locid
        locid2           = ls_stop_points->stop_id
        loctype          = zcl_gtt_sts_tools=>get_location_type( iv_locno = <ls_stop>-log_locid ) ) TO ct_expeventdata.

      CLEAR: lt_loc_root, ls_loc_root.
    ENDLOOP.

  ENDMETHOD.


  METHOD popu.

*   There exists at least one planned load end,then plan POPU event
    LOOP AT ct_expeventdata INTO DATA(ls_expeventdata)
      WHERE appsys     = mv_appsys
        AND appobjtype = mv_appobjtype
        AND language   = sy-langu
        AND appobjid   = mv_appobjid
        AND milestone  = zif_gtt_sts_constants=>cs_milestone-fo_load_end.

      APPEND VALUE #(
        appsys           = ls_expeventdata-appsys
        appobjtype       = ls_expeventdata-appobjtype
        language         = ls_expeventdata-language
        appobjid         = ls_expeventdata-appobjid
        milestone        = zif_gtt_sts_constants=>cs_milestone-fo_popu
        evt_exp_datetime = ls_expeventdata-evt_exp_datetime
        evt_exp_tzone    = ls_expeventdata-evt_exp_tzone
        locid1           = ls_expeventdata-locid1
        locid2           = ls_expeventdata-locid2
        loctype          = ls_expeventdata-loctype
        itemident        = ls_expeventdata-itemident ) TO ct_expeventdata.

    ENDLOOP.

  ENDMETHOD.


  method SHP_ARRIVAL.

    FIELD-SYMBOLS <ls_root> TYPE /scmtms/s_em_bo_tor_root.

    DATA:
      lt_loc_root TYPE /scmtms/t_bo_loc_root_k.

    ASSIGN ir_root->* TO <ls_root>.
    IF sy-subrc <> 0.
      MESSAGE e010(zgtt_sts) INTO DATA(lv_dummy) ##needed.
      zcl_gtt_sts_tools=>throw_exception( ).
    ENDIF.

    LOOP AT it_stop USING KEY parent_seqnum ASSIGNING FIELD-SYMBOL(<ls_stop>) WHERE parent_node_id = <ls_root>-node_id.
      CHECK <ls_stop>-stop_cat = /scmtms/if_common_c=>c_stop_category-inbound AND
            <ls_stop>-plan_trans_time IS NOT INITIAL.

      READ TABLE it_stop_points REFERENCE INTO DATA(ls_stop_points)
                                     WITH KEY log_locid = <ls_stop>-log_locid
                                              seq_num   = <ls_stop>-seq_num.
      CHECK sy-subrc = 0.

      TEST-SEAM shp_arrival_lt_loc_root.
        /scmtms/cl_pln_bo_data=>get_loc_data(
          EXPORTING
            it_key      = VALUE #( ( key = <ls_stop>-log_loc_uuid ) )
          CHANGING
            ct_loc_root = lt_loc_root ).
      END-TEST-SEAM.
      READ TABLE lt_loc_root REFERENCE INTO DATA(ls_loc_root)
                                     WITH KEY key COMPONENTS key = <ls_stop>-log_loc_uuid.
      CHECK sy-subrc = 0.

      DATA(lv_tz) = COND tznzone( WHEN ls_loc_root->time_zone_code IS NOT INITIAL
                                  THEN ls_loc_root->time_zone_code
                                  ELSE sy-zonlo ).

      DATA(lv_exp_datetime) = <ls_stop>-plan_trans_time.

      zcl_gtt_sts_tools=>convert_utc_timestamp(
        EXPORTING
          iv_timezone  =  lv_tz
        CHANGING
          cv_timestamp = lv_exp_datetime ).

      APPEND VALUE #(
      appsys            = mv_appsys
      appobjtype        = mv_appobjtype
      language          = sy-langu
      appobjid          = mv_appobjid
      milestone         = zif_gtt_sts_constants=>cs_milestone-fo_shp_arrival
      evt_exp_datetime  = |0{ lv_exp_datetime }|
      evt_exp_tzone     = lv_tz
      locid1            = <ls_stop>-log_locid
      locid2            = ls_stop_points->stop_id
      loctype           = zcl_gtt_sts_tools=>get_location_type( iv_locno = <ls_stop>-log_locid ) ) TO ct_expeventdata.

      CLEAR: lt_loc_root, ls_loc_root.
    ENDLOOP.

  endmethod.


  METHOD shp_departure.

    FIELD-SYMBOLS <ls_root> TYPE /scmtms/s_em_bo_tor_root.

    DATA:
      lt_loc_root TYPE /scmtms/t_bo_loc_root_k.

    ASSIGN ir_root->* TO <ls_root>.
    IF sy-subrc <> 0.
      MESSAGE e010(zgtt_sts) INTO DATA(lv_dummy) ##needed.
      zcl_gtt_sts_tools=>throw_exception( ).
    ENDIF.

    LOOP AT it_stop USING KEY parent_seqnum ASSIGNING FIELD-SYMBOL(<ls_stop>) WHERE parent_node_id = <ls_root>-node_id.
      CHECK <ls_stop>-stop_cat = /scmtms/if_common_c=>c_stop_category-outbound AND
            <ls_stop>-plan_trans_time IS NOT INITIAL.

      READ TABLE it_stop_points REFERENCE INTO DATA(ls_stop_points)
                                     WITH KEY log_locid = <ls_stop>-log_locid
                                              seq_num   = <ls_stop>-seq_num.
      CHECK sy-subrc = 0.

      TEST-SEAM shp_dep_lt_loc_root.
        /scmtms/cl_pln_bo_data=>get_loc_data(
          EXPORTING
            it_key      = VALUE #( ( key = <ls_stop>-log_loc_uuid ) )
          CHANGING
            ct_loc_root = lt_loc_root ).
      END-TEST-SEAM.
      READ TABLE lt_loc_root REFERENCE INTO DATA(ls_loc_root)
                                     WITH KEY key COMPONENTS key = <ls_stop>-log_loc_uuid.
      CHECK sy-subrc = 0.

      DATA(lv_tz) = COND tznzone( WHEN ls_loc_root->time_zone_code IS NOT INITIAL
                                  THEN ls_loc_root->time_zone_code
                                  ELSE sy-zonlo ).

      DATA(lv_exp_datetime) = <ls_stop>-plan_trans_time.

      zcl_gtt_sts_tools=>convert_utc_timestamp(
        EXPORTING
          iv_timezone  = lv_tz
        CHANGING
          cv_timestamp = lv_exp_datetime ).

      APPEND VALUE #(
      appsys            = mv_appsys
      appobjtype        = mv_appobjtype
      language          = sy-langu
      appobjid          = mv_appobjid
      milestone         = zif_gtt_sts_constants=>cs_milestone-fo_shp_departure
      evt_exp_datetime  = |0{ lv_exp_datetime }|
      evt_exp_tzone     = lv_tz
      locid1            = <ls_stop>-log_locid
      locid2            = ls_stop_points->stop_id
      loctype           = zcl_gtt_sts_tools=>get_location_type( iv_locno = <ls_stop>-log_locid ) ) TO ct_expeventdata.

      CLEAR: lt_loc_root, ls_loc_root.
    ENDLOOP.

  ENDMETHOD.


  method UNLOAD_END.

    FIELD-SYMBOLS <ls_root> TYPE /scmtms/s_em_bo_tor_root.

    DATA:
      lt_loc_root TYPE /scmtms/t_bo_loc_root_k.

    ASSIGN ir_root->* TO <ls_root>.
    IF sy-subrc <> 0.
      MESSAGE e010(zgtt_sts) INTO DATA(lv_dummy) ##needed.
      zcl_gtt_sts_tools=>throw_exception( ).
    ENDIF.

    LOOP AT it_stop USING KEY parent_seqnum ASSIGNING FIELD-SYMBOL(<ls_stop>) WHERE parent_node_id = <ls_root>-node_id.
      CHECK  <ls_stop>-stop_cat = /scmtms/if_common_c=>c_stop_category-inbound AND
             <ls_stop>-aggr_assgn_start_l IS NOT INITIAL AND
             <ls_stop>-aggr_assgn_end_l   IS NOT INITIAL.

      READ TABLE it_stop_points REFERENCE INTO DATA(ls_stop_points)
                                     WITH KEY log_locid = <ls_stop>-log_locid
                                              seq_num   = <ls_stop>-seq_num.
      CHECK sy-subrc = 0.

      TEST-SEAM unload_end_lt_loc_root.
        /scmtms/cl_pln_bo_data=>get_loc_data(
          EXPORTING
            it_key      = VALUE #( ( key = <ls_stop>-log_loc_uuid ) )
          CHANGING
            ct_loc_root = lt_loc_root ).
      END-TEST-SEAM.

      READ TABLE lt_loc_root REFERENCE INTO DATA(ls_loc_root)
                                     WITH KEY key COMPONENTS key = <ls_stop>-log_loc_uuid.
      CHECK sy-subrc = 0.

      DATA(lv_tz) = COND tznzone( WHEN ls_loc_root->time_zone_code IS NOT INITIAL
                                  THEN ls_loc_root->time_zone_code
                                  ELSE sy-zonlo ).

      DATA(lv_exp_datetime) = <ls_stop>-aggr_assgn_end_l.

      zcl_gtt_sts_tools=>convert_utc_timestamp(
        EXPORTING
          iv_timezone  =  lv_tz
        CHANGING
          cv_timestamp = lv_exp_datetime ).

      APPEND VALUE #(
      appsys            = mv_appsys
      appobjtype        = mv_appobjtype
      language          = sy-langu
      appobjid          = mv_appobjid
      milestone         = zif_gtt_sts_constants=>cs_milestone-fo_unload_end
      evt_exp_datetime  = |0{ lv_exp_datetime }|
      evt_exp_tzone     = lv_tz
      locid1            = <ls_stop>-log_locid
      locid2            = ls_stop_points->stop_id
      loctype           = zcl_gtt_sts_tools=>get_location_type( iv_locno = <ls_stop>-log_locid ) ) TO ct_expeventdata.

      CLEAR: lt_loc_root, ls_loc_root.
    ENDLOOP.

  endmethod.


  method UNLOAD_START.

    FIELD-SYMBOLS <ls_root> TYPE /scmtms/s_em_bo_tor_root.

    DATA:
      lt_loc_root TYPE /scmtms/t_bo_loc_root_k.

    ASSIGN ir_root->* TO <ls_root>.
    IF sy-subrc <> 0.
      MESSAGE e010(zgtt_sts) INTO DATA(lv_dummy) ##needed.
      zcl_gtt_sts_tools=>throw_exception( ).
    ENDIF.

    LOOP AT it_stop USING KEY parent_seqnum ASSIGNING FIELD-SYMBOL(<ls_stop>) WHERE parent_node_id = <ls_root>-node_id.
      CHECK <ls_stop>-stop_cat = /scmtms/if_common_c=>c_stop_category-inbound AND
            <ls_stop>-aggr_assgn_start_l IS NOT INITIAL AND
            <ls_stop>-aggr_assgn_end_l   IS NOT INITIAL.

      READ TABLE it_stop_points REFERENCE INTO DATA(ls_stop_points)
                                     WITH KEY log_locid = <ls_stop>-log_locid
                                              seq_num   = <ls_stop>-seq_num.
      CHECK sy-subrc = 0.

      TEST-SEAM unload_start_lt_loc_root.
        /scmtms/cl_pln_bo_data=>get_loc_data(
          EXPORTING
            it_key      = VALUE #( ( key = <ls_stop>-log_loc_uuid ) )
          CHANGING
            ct_loc_root = lt_loc_root ).
      END-TEST-SEAM.

      READ TABLE lt_loc_root REFERENCE INTO DATA(ls_loc_root)
                                     WITH KEY key COMPONENTS key = <ls_stop>-log_loc_uuid.
      CHECK sy-subrc = 0.

      DATA(lv_tz) = COND tznzone( WHEN ls_loc_root->time_zone_code IS NOT INITIAL
                                  THEN ls_loc_root->time_zone_code
                                  ELSE sy-zonlo ).

      DATA(lv_exp_datetime) = <ls_stop>-aggr_assgn_start_l.

      zcl_gtt_sts_tools=>convert_utc_timestamp(
        EXPORTING
          iv_timezone  =  lv_tz
        CHANGING
          cv_timestamp = lv_exp_datetime ).

      APPEND VALUE #(
      appsys            = mv_appsys
      appobjtype        = mv_appobjtype
      language          = sy-langu
      appobjid          = mv_appobjid
      milestone         = zif_gtt_sts_constants=>cs_milestone-fo_unload_start
      evt_exp_datetime  = |0{ lv_exp_datetime }|
      evt_exp_tzone     = lv_tz
      locid1            = <ls_stop>-log_locid
      locid2            = ls_stop_points->stop_id
      loctype           = zcl_gtt_sts_tools=>get_location_type( iv_locno = <ls_stop>-log_locid ) ) TO ct_expeventdata.

      CLEAR: lt_loc_root, ls_loc_root.
    ENDLOOP.

  endmethod.


  METHOD prepare_data_for_planned_event.

    DATA:
      lv_tor_id TYPE /scmtms/tor_id,
      ls_stop   TYPE /scmtms/s_em_bo_tor_stop,
      lt_stop   TYPE /scmtms/t_em_bo_tor_stop.

    CLEAR:
      et_stop,
      et_stop_points.

    lv_tor_id = |{ is_capa-tor_id ALPHA = OUT }|.

    LOOP AT it_stop_seq USING KEY parent_seqnum INTO DATA(ls_stop_seq) WHERE parent_node_id = is_capa-node_id.
      MOVE-CORRESPONDING ls_stop_seq TO ls_stop.
      APPEND ls_stop TO lt_stop.
      CLEAR ls_stop.
    ENDLOOP.

    zcl_gtt_sts_tools=>get_stop_points(
      EXPORTING
        iv_root_id     = lv_tor_id
        it_stop        = lt_stop
      IMPORTING
        et_stop_points = et_stop_points ).

    LOOP AT lt_stop INTO ls_stop.
      READ TABLE it_req2capa_info INTO DATA(ls_req2capa_info)
        WITH KEY cap_key      = ls_stop-parent_node_id
                 cap_stop_key = ls_stop-node_id.
      IF sy-subrc = 0.
        APPEND ls_stop TO et_stop.
      ENDIF.
      CLEAR:
        ls_stop,
        ls_req2capa_info.
    ENDLOOP.

  ENDMETHOD.
ENDCLASS.
