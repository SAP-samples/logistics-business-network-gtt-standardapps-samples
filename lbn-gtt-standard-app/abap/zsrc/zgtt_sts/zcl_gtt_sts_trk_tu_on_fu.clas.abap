class ZCL_GTT_STS_TRK_TU_ON_FU definition
  public
  inheriting from ZCL_GTT_STS_TRK_TU_BASE
  final
  create public .

public section.
protected section.

  methods FILL_IDOC_EXP_EVENT
    redefinition .
  methods GET_TU_NUMBER
    redefinition .
  methods LOAD_END
    redefinition .
  methods LOAD_START
    redefinition .
  methods POD
    redefinition .
  methods PRE_CONDITION_CHECK
    redefinition .
  methods SHP_ARRIVAL
    redefinition .
  methods SHP_DEPARTURE
    redefinition .
  methods UNLOAD_END
    redefinition .
  methods UNLOAD_START
    redefinition .
  methods DEL_CONDITION_CHECK
    redefinition .
private section.

  methods GET_CAPA_DOC
    importing
      !IS_TOR_ROOT type /SCMTMS/S_EM_BO_TOR_ROOT
      !IV_OLD_DATA type ABAP_BOOL default ABAP_FALSE
    exporting
      !ET_CAPA_ROOT type /SCMTMS/T_TOR_ROOT_K
      !ET_CAPA_STOP type /SCMTMS/T_TOR_STOP_K .
ENDCLASS.



CLASS ZCL_GTT_STS_TRK_TU_ON_FU IMPLEMENTATION.


  METHOD fill_idoc_exp_event.

    DATA:
      lt_stop             TYPE /scmtms/t_em_bo_tor_stop,
      lt_stop_points      TYPE zif_gtt_sts_ef_types=>tt_stop_points,
      lt_expeventdata     TYPE /saptrx/bapi_trk_ee_tab,
      lv_counter          TYPE /saptrx/seq_num,
      ls_previous_line    TYPE /saptrx/exp_events,
      lv_shp_num_previous TYPE /saptrx/loc_id_2,
      lv_shp_num          TYPE /saptrx/loc_id_2,
      lv_length           TYPE i.

    get_data_for_planned_event(
      EXPORTING
        is_tor_root    = is_tor_root
        iv_tu_no       = iv_tu_no
      IMPORTING
        et_stop        = lt_stop
        et_stop_points = lt_stop_points ).

    shp_arrival(
      EXPORTING
        is_tor_root     = is_tor_root
        it_stop         = lt_stop
        it_stop_points  = lt_stop_points
        iv_appobjid     = iv_appobjid
      CHANGING
        ct_expeventdata = lt_expeventdata ).

    unload_start(
      EXPORTING
        is_tor_root     = is_tor_root
        it_stop         = lt_stop
        it_stop_points  = lt_stop_points
        iv_appobjid     = iv_appobjid
      CHANGING
        ct_expeventdata = lt_expeventdata ).

    unload_end(
      EXPORTING
        is_tor_root     = is_tor_root
        it_stop         = lt_stop
        it_stop_points  = lt_stop_points
        iv_appobjid     = iv_appobjid
      CHANGING
        ct_expeventdata = lt_expeventdata ).

    pod(
      EXPORTING
        is_tor_root     = is_tor_root
        it_stop         = lt_stop
        it_stop_points  = lt_stop_points
        iv_appobjid     = iv_appobjid
      CHANGING
        ct_expeventdata = lt_expeventdata ).

    load_start(
      EXPORTING
        is_tor_root     = is_tor_root
        it_stop         = lt_stop
        it_stop_points  = lt_stop_points
        iv_appobjid     = iv_appobjid
      CHANGING
        ct_expeventdata = lt_expeventdata ).

    load_end(
      EXPORTING
        is_tor_root     = is_tor_root
        it_stop         = lt_stop
        it_stop_points  = lt_stop_points
        iv_appobjid     = iv_appobjid
      CHANGING
        ct_expeventdata = lt_expeventdata ).

    popu(
      EXPORTING
        is_tor_root     = is_tor_root
        it_stop         = lt_stop
        it_stop_points  = lt_stop_points
        iv_appobjid     = iv_appobjid
      CHANGING
        ct_expeventdata = lt_expeventdata ).

    shp_departure(
      EXPORTING
        is_tor_root     = is_tor_root
        it_stop         = lt_stop
        it_stop_points  = lt_stop_points
        iv_appobjid     = iv_appobjid
      CHANGING
        ct_expeventdata = lt_expeventdata ).

    SORT lt_expeventdata BY locid2 ASCENDING.

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

    cs_idoc_data-exp_event = lt_expeventdata.

  ENDMETHOD.


  METHOD get_capa_doc.

    DATA:
      lr_srvmgr_tor TYPE REF TO /bobf/if_tra_service_manager,
      lt_root_key   TYPE /bobf/t_frw_key.

    CLEAR:
      et_capa_root,
      et_capa_stop.

    DATA(lv_before_image) = SWITCH abap_bool( iv_old_data WHEN abap_true THEN abap_true
                                                      ELSE abap_false ).

    lt_root_key = VALUE #( ( key = is_tor_root-node_id ) ).

    lr_srvmgr_tor = /bobf/cl_tra_serv_mgr_factory=>get_service_manager(
      iv_bo_key = /scmtms/if_tor_c=>sc_bo_key ).

    lr_srvmgr_tor->retrieve_by_association(
      EXPORTING
        iv_node_key     = /scmtms/if_tor_c=>sc_node-root
        it_key          = lt_root_key
        iv_association  = /scmtms/if_tor_c=>sc_association-root-capa_tor
        iv_fill_data    = abap_true
        iv_before_image = lv_before_image
      IMPORTING
        et_data         = et_capa_root
        et_key_link     = DATA(lt_req2capa_link) ).

    lr_srvmgr_tor->retrieve_by_association(
      EXPORTING
        iv_node_key     = /scmtms/if_tor_c=>sc_node-root
        it_key          = CORRESPONDING #( et_capa_root )
        iv_association  = /scmtms/if_tor_c=>sc_association-root-stop
        iv_fill_data    = abap_true
        iv_before_image = lv_before_image
      IMPORTING
        et_data         = et_capa_stop ).

  ENDMETHOD.


  METHOD get_tu_number.

    DATA:
      lt_resource1 TYPE tt_resource,
      lt_resource2 TYPE tt_resource.

    CLEAR et_resource.

*   Get container ID
    get_container_mobile_id(
      EXPORTING
        is_tor_root     = is_tor_root
        it_tor_item     = it_tor_item
        iv_before_image = iv_before_image
      IMPORTING
        et_container    = lt_resource1 ).

*   Get Package ID & External Package ID
    get_package_id(
      EXPORTING
        is_tor_root       = is_tor_root
        it_tor_item       = it_tor_item
        iv_before_image   = iv_before_image
      IMPORTING
        et_package_id_ext = lt_resource2 ).

    APPEND LINES OF lt_resource1 TO et_resource.
    APPEND LINES OF lt_resource2 TO et_resource.

  ENDMETHOD.


  METHOD load_end.

    DATA:
      lt_loc_root TYPE /scmtms/t_bo_loc_root_k.

    LOOP AT it_stop USING KEY parent_seqnum ASSIGNING FIELD-SYMBOL(<ls_stop>) WHERE parent_node_id = is_tor_root-node_id.
      CHECK <ls_stop>-stop_cat = /scmtms/if_common_c=>c_stop_category-outbound AND <ls_stop>-assgn_end IS NOT INITIAL.

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

      DATA(lv_exp_datetime) = <ls_stop>-assgn_end.

      zcl_gtt_sts_tools=>convert_utc_timestamp(
        EXPORTING
          iv_timezone  = lv_tz
        CHANGING
          cv_timestamp = lv_exp_datetime ).

      APPEND VALUE #(
        appsys           = mv_appsys
        appobjtype       = mv_aotype
        language         = sy-langu
        appobjid         = iv_appobjid
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

    DATA:
      lt_loc_root TYPE /scmtms/t_bo_loc_root_k.

    LOOP AT it_stop USING KEY parent_seqnum ASSIGNING FIELD-SYMBOL(<ls_stop>) WHERE parent_node_id = is_tor_root-node_id.
      CHECK <ls_stop>-stop_cat = /scmtms/if_common_c=>c_stop_category-outbound AND <ls_stop>-assgn_start IS NOT INITIAL.

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

      DATA(lv_exp_datetime) = <ls_stop>-assgn_start.

      zcl_gtt_sts_tools=>convert_utc_timestamp(
        EXPORTING
          iv_timezone  = lv_tz
        CHANGING
          cv_timestamp = lv_exp_datetime ).

      APPEND VALUE #(
      appsys            = mv_appsys
      appobjtype        = mv_aotype
      language          = sy-langu
      appobjid          = iv_appobjid
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

    DATA:
       lt_loc_root TYPE /scmtms/t_bo_loc_root_k.

    LOOP AT it_stop USING KEY parent_seqnum ASSIGNING FIELD-SYMBOL(<ls_stop>) WHERE parent_node_id = is_tor_root-node_id.
      CHECK <ls_stop>-stop_cat = /scmtms/if_common_c=>c_stop_category-inbound AND
            <ls_stop>-assgn_end IS NOT INITIAL.

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

      DATA(lv_exp_datetime) = <ls_stop>-assgn_end.

      zcl_gtt_sts_tools=>convert_utc_timestamp(
        EXPORTING
          iv_timezone  = lv_tz
        CHANGING
          cv_timestamp = lv_exp_datetime ).

      APPEND VALUE #(
        appsys           = mv_appsys
        appobjtype       = mv_aotype
        language         = sy-langu
        appobjid         = iv_appobjid
        milestone        = zif_gtt_sts_constants=>cs_milestone-fo_shp_pod
        evt_exp_datetime = |0{ lv_exp_datetime }|
        evt_exp_tzone    = lv_tz
        locid1           = <ls_stop>-log_locid
        locid2           = ls_stop_points->stop_id
        loctype          = zcl_gtt_sts_tools=>get_location_type( iv_locno = <ls_stop>-log_locid ) ) TO ct_expeventdata.

      CLEAR: lt_loc_root, ls_loc_root.
    ENDLOOP.

  ENDMETHOD.


  METHOD shp_arrival.

    DATA:
      lt_loc_root TYPE /scmtms/t_bo_loc_root_k.

    get_capa_doc(
      EXPORTING
        is_tor_root  = is_tor_root
      IMPORTING
        et_capa_stop = DATA(lt_capa_stop) ).

    LOOP AT it_stop USING KEY parent_seqnum ASSIGNING FIELD-SYMBOL(<ls_stop>) WHERE parent_node_id = is_tor_root-node_id.

      READ TABLE lt_capa_stop INTO DATA(ls_capa_stop) WITH KEY key = <ls_stop>-assgn_stop_key.
      CHECK sy-subrc = 0.

      CHECK <ls_stop>-stop_cat = /scmtms/if_common_c=>c_stop_category-inbound AND
            ls_capa_stop-plan_trans_time IS NOT INITIAL.

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

      DATA(lv_exp_datetime) = ls_capa_stop-plan_trans_time.

      zcl_gtt_sts_tools=>convert_utc_timestamp(
        EXPORTING
          iv_timezone  = lv_tz
        CHANGING
          cv_timestamp = lv_exp_datetime ).

      APPEND VALUE #(
      appsys            = mv_appsys
      appobjtype        = mv_aotype
      language          = sy-langu
      appobjid          = iv_appobjid
      milestone         = zif_gtt_sts_constants=>cs_milestone-fo_shp_arrival
      evt_exp_datetime  = |0{ lv_exp_datetime }|
      evt_exp_tzone     = lv_tz
      locid1            = <ls_stop>-log_locid
      locid2            = ls_stop_points->stop_id
      loctype           = zcl_gtt_sts_tools=>get_location_type( iv_locno = <ls_stop>-log_locid ) ) TO ct_expeventdata.

      CLEAR: lt_loc_root, ls_loc_root.
    ENDLOOP.

  ENDMETHOD.


  METHOD shp_departure.

    DATA:
      lt_loc_root TYPE /scmtms/t_bo_loc_root_k.

    get_capa_doc(
      EXPORTING
        is_tor_root  = is_tor_root
      IMPORTING
        et_capa_stop = DATA(lt_capa_stop) ).

    LOOP AT it_stop USING KEY parent_seqnum ASSIGNING FIELD-SYMBOL(<ls_stop>) WHERE parent_node_id = is_tor_root-node_id.
      READ TABLE lt_capa_stop ASSIGNING FIELD-SYMBOL(<ls_capa_stop>)
        WITH KEY key = <ls_stop>-assgn_stop_key.
      CHECK sy-subrc = 0.

      CHECK <ls_stop>-stop_cat = /scmtms/if_common_c=>c_stop_category-outbound AND
            <ls_capa_stop>-plan_trans_time IS NOT INITIAL.

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

      DATA(lv_exp_datetime) = <ls_capa_stop>-plan_trans_time.

      zcl_gtt_sts_tools=>convert_utc_timestamp(
        EXPORTING
          iv_timezone  = lv_tz
        CHANGING
          cv_timestamp = lv_exp_datetime ).

      APPEND VALUE #(
      appsys            = mv_appsys
      appobjtype        = mv_aotype
      language          = sy-langu
      appobjid          = iv_appobjid
      milestone         = zif_gtt_sts_constants=>cs_milestone-fo_shp_departure
      evt_exp_datetime  = |0{ lv_exp_datetime }|
      evt_exp_tzone     = lv_tz
      locid1            = <ls_stop>-log_locid
      locid2            = ls_stop_points->stop_id
      loctype           = zcl_gtt_sts_tools=>get_location_type( iv_locno = <ls_stop>-log_locid ) ) TO ct_expeventdata.

      CLEAR: lt_loc_root, ls_loc_root.
    ENDLOOP.

  ENDMETHOD.


  METHOD unload_end.

    DATA:
      lt_loc_root TYPE /scmtms/t_bo_loc_root_k.

    LOOP AT it_stop USING KEY parent_seqnum ASSIGNING FIELD-SYMBOL(<ls_stop>) WHERE parent_node_id = is_tor_root-node_id.
      CHECK <ls_stop>-stop_cat = /scmtms/if_common_c=>c_stop_category-inbound AND <ls_stop>-assgn_end IS NOT INITIAL.

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

      DATA(lv_exp_datetime) = <ls_stop>-assgn_end.

      zcl_gtt_sts_tools=>convert_utc_timestamp(
        EXPORTING
          iv_timezone  = lv_tz
        CHANGING
          cv_timestamp = lv_exp_datetime ).

      APPEND VALUE #(
      appsys            = mv_appsys
      appobjtype        = mv_aotype
      language          = sy-langu
      appobjid          = iv_appobjid
      milestone         = zif_gtt_sts_constants=>cs_milestone-fo_unload_end
      evt_exp_datetime  = |0{ lv_exp_datetime }|
      evt_exp_tzone     = lv_tz
      locid1            = <ls_stop>-log_locid
      locid2            = ls_stop_points->stop_id
      loctype           = zcl_gtt_sts_tools=>get_location_type( iv_locno = <ls_stop>-log_locid ) ) TO ct_expeventdata.

      CLEAR: lt_loc_root, ls_loc_root.
    ENDLOOP.

  ENDMETHOD.


  METHOD unload_start.

    DATA:
       lt_loc_root TYPE /scmtms/t_bo_loc_root_k.

    LOOP AT it_stop USING KEY parent_seqnum ASSIGNING FIELD-SYMBOL(<ls_stop>) WHERE parent_node_id = is_tor_root-node_id.
      CHECK <ls_stop>-stop_cat = /scmtms/if_common_c=>c_stop_category-inbound AND <ls_stop>-assgn_start IS NOT INITIAL.

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

      DATA(lv_exp_datetime) = <ls_stop>-assgn_start.

      zcl_gtt_sts_tools=>convert_utc_timestamp(
        EXPORTING
          iv_timezone  = lv_tz
        CHANGING
          cv_timestamp = lv_exp_datetime ).

      APPEND VALUE #(
      appsys            = mv_appsys
      appobjtype        = mv_aotype
      language          = sy-langu
      appobjid          = iv_appobjid
      milestone         = zif_gtt_sts_constants=>cs_milestone-fo_unload_start
      evt_exp_datetime  = |0{ lv_exp_datetime }|
      evt_exp_tzone     = lv_tz
      locid1            = <ls_stop>-log_locid
      locid2            = ls_stop_points->stop_id
      loctype           = zcl_gtt_sts_tools=>get_location_type( iv_locno = <ls_stop>-log_locid ) ) TO ct_expeventdata.

      CLEAR: lt_loc_root, ls_loc_root.
    ENDLOOP.

  ENDMETHOD.


  METHOD del_condition_check.

    rv_result = zif_gtt_sts_ef_constants=>cs_condition-false.

    IF is_root-change_mode = /bobf/if_frw_c=>sc_modify_delete.
      rv_result = zif_gtt_sts_ef_constants=>cs_condition-true.
      RETURN.
    ENDIF.

    IF ( is_root-track_exec_rel = zif_gtt_sts_constants=>cs_track_exec_rel-execution OR
        is_root-track_exec_rel = zif_gtt_sts_constants=>cs_track_exec_rel-exec_with_extern_event_mngr ) AND
    "  is_root-lifecycle = zif_gtt_sts_constants=>cs_lifecycle_status-in_process AND
      is_root-tor_cat = mv_tor_cat .

      rv_result = zif_gtt_sts_ef_constants=>cs_condition-true.

    ENDIF.

  ENDMETHOD.


  METHOD PRE_CONDITION_CHECK.

    rv_result = zif_gtt_sts_ef_constants=>cs_condition-false.

    IF is_root-change_mode = /bobf/if_frw_c=>sc_modify_delete.
      RETURN.
    ENDIF.

    IF ( is_root-track_exec_rel = zif_gtt_sts_constants=>cs_track_exec_rel-execution OR
        is_root-track_exec_rel = zif_gtt_sts_constants=>cs_track_exec_rel-exec_with_extern_event_mngr ) AND
    "  is_root-lifecycle = zif_gtt_sts_constants=>cs_lifecycle_status-in_process AND
      is_root-tor_cat = mv_tor_cat .

      rv_result = zif_gtt_sts_ef_constants=>cs_condition-true.

    ENDIF.

  ENDMETHOD.
ENDCLASS.
