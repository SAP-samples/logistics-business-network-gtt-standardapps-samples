class ZCL_GTT_STS_TRK_TU_ON_FB definition
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
  methods DEL_CONDITION_CHECK
    redefinition .
private section.
ENDCLASS.



CLASS ZCL_GTT_STS_TRK_TU_ON_FB IMPLEMENTATION.


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


  METHOD get_tu_number.

    DATA:
      lt_resource1 TYPE tt_resource.

    CLEAR et_resource.

*   Get container ID
    get_container_mobile_id(
      EXPORTING
        is_tor_root     = is_tor_root
        it_tor_item     = it_tor_item
        iv_before_image = iv_before_image
      IMPORTING
        et_container    = lt_resource1 ).

    APPEND LINES OF lt_resource1 TO et_resource.

  ENDMETHOD.


  METHOD del_condition_check.

    rv_result = zif_gtt_sts_ef_constants=>cs_condition-false.

    IF is_root-change_mode = /bobf/if_frw_c=>sc_modify_delete OR
      is_root-lifecycle = zif_gtt_sts_constants=>cs_lifecycle_status-canceled.
      rv_result = zif_gtt_sts_ef_constants=>cs_condition-true.
      RETURN.
    ENDIF.

    IF ( is_root-track_exec_rel = zif_gtt_sts_constants=>cs_track_exec_rel-execution OR
        is_root-track_exec_rel = zif_gtt_sts_constants=>cs_track_exec_rel-exec_with_extern_event_mngr ) AND
      is_root-lifecycle = zif_gtt_sts_constants=>cs_lifecycle_status-in_process AND
      ( is_root-execution = zif_gtt_sts_constants=>cs_execution_status-in_execution OR
        is_root-execution = zif_gtt_sts_constants=>cs_execution_status-ready_for_transp_exec ) AND
      is_root-tspid IS NOT INITIAL AND ( is_root-tor_cat = mv_tor_cat  ).

      rv_result = zif_gtt_sts_ef_constants=>cs_condition-true.

    ENDIF.

  ENDMETHOD.
ENDCLASS.
