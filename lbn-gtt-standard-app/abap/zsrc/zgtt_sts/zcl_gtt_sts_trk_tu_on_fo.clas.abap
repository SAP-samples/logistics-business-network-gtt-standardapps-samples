class ZCL_GTT_STS_TRK_TU_ON_FO definition
  public
  inheriting from ZCL_GTT_STS_TRK_TU_BASE
  final
  create public .

public section.
protected section.

  methods GET_TU_NUMBER
    redefinition .
  methods DEL_CONDITION_CHECK
    redefinition .
private section.
ENDCLASS.



CLASS ZCL_GTT_STS_TRK_TU_ON_FO IMPLEMENTATION.


  METHOD get_tu_number.

    DATA:
      lt_resource1 TYPE tt_resource,
      lt_resource2 TYPE tt_resource,
      lt_resource3 TYPE tt_resource.

    CLEAR et_resource.

*   Get container ID
    get_container_mobile_id(
      EXPORTING
        is_tor_root       = is_tor_root
        it_tor_item       = it_tor_item
        iv_before_image   = iv_before_image
      IMPORTING
        et_container      = lt_resource1
        et_mobile         = lt_resource2 ).

*   Get plate number
    get_plate_truck_number(
      EXPORTING
        is_tor_root       = is_tor_root
        it_tor_item       = it_tor_item
        iv_before_image   = iv_before_image
      IMPORTING
        et_plate          = lt_resource3 ).

    APPEND LINES OF lt_resource1 TO et_resource.
    APPEND LINES OF lt_resource2 TO et_resource.
    APPEND LINES OF lt_resource3 TO et_resource.

  ENDMETHOD.


  METHOD del_condition_check.

    rv_result = zif_gtt_sts_ef_constants=>cs_condition-false.

    IF is_root-change_mode = /bobf/if_frw_c=>sc_modify_delete.
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
