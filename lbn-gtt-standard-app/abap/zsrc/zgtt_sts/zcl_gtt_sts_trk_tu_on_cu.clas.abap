class ZCL_GTT_STS_TRK_TU_ON_CU definition
  public
  inheriting from ZCL_GTT_STS_TRK_TU_BASE
  final
  create public .

public section.
protected section.

  methods DEL_CONDITION_CHECK
    redefinition .
  methods FILL_IDOC_EXP_EVENT
    redefinition .
  methods FILL_IDOC_TRXSERV
    redefinition .
  methods GET_DOCREF_DATA
    redefinition .
  methods GET_TU_NUMBER
    redefinition .
  methods PRE_CONDITION_CHECK
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



CLASS ZCL_GTT_STS_TRK_TU_ON_CU IMPLEMENTATION.


  METHOD DEL_CONDITION_CHECK.

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


  METHOD FILL_IDOC_EXP_EVENT.

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


  METHOD GET_CAPA_DOC.

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


  METHOD get_docref_data.

*   in Container Unit we do not need Carrier reference documents
    RETURN.

  ENDMETHOD.


  METHOD get_tu_number.

    DATA:
      lt_tmp_cont TYPE TABLE OF /scmtms/package_id,
      ls_resource TYPE ts_resource,
      lt_text     TYPE tt_text,
      ls_text     TYPE ts_text.

    CLEAR et_resource.

*   Get container ID
    zcl_gtt_sts_tools=>get_container_num_on_cu(
      EXPORTING
        ir_root      = REF #( is_tor_root )
        iv_old_data  = iv_before_image
      IMPORTING
        et_container = lt_tmp_cont ).

    LOOP AT lt_tmp_cont INTO DATA(ls_tmp_cont).
      CLEAR ls_text.
      ls_text-text_type = cs_tu_type-container_id.
      ls_text-text_value = ls_tmp_cont.
      APPEND ls_text TO lt_text.
    ENDLOOP.

    LOOP AT lt_text INTO ls_text.
      ls_resource-category = ls_text-text_type.
      ls_resource-value = |{ is_tor_root-tor_id ALPHA = OUT }{ ls_text-text_value } |.
      CONDENSE ls_resource-value NO-GAPS.
      ls_resource-orginal_value = ls_text-text_value .
      ls_resource-tor_id = is_tor_root-tor_id.
      SHIFT ls_resource-tor_id LEFT DELETING LEADING '0'.
      APPEND ls_resource TO et_resource.
      CLEAR ls_resource.
    ENDLOOP.

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


  METHOD fill_idoc_trxserv.

    READ TABLE mt_trxserv INTO DATA(ls_trxserv) INDEX 1.
    IF sy-subrc = 0.
      cs_idoc_data-trxserv = ls_trxserv.
    ENDIF.

  ENDMETHOD.
ENDCLASS.
