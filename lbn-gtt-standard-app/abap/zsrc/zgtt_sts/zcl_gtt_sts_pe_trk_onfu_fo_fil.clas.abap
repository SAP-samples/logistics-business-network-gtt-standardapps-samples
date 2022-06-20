class ZCL_GTT_STS_PE_TRK_ONFU_FO_FIL definition
  public
  inheriting from ZCL_GTT_STS_PE_FILLER
  create public .

public section.

  methods ZIF_GTT_STS_PE_FILLER~GET_PLANNED_EVENTS
    redefinition .
PROTECTED SECTION.


  TYPES:
    tt_container TYPE TABLE OF /scmtms/package_id .

  TYPES:
    tt_track_obj TYPE TABLE OF /scmtms/package_id.
  TYPES:
    tt_req_doc_number TYPE STANDARD TABLE OF /scmtms/tor_id WITH EMPTY KEY .
  TYPES:
    BEGIN OF ts_req_tu_info,
      tor_id     TYPE /scmtms/tor_id,
      track_obj  TYPE /scmtms/package_id,
      first_stop TYPE /saptrx/loc_id_2,
      last_stop  TYPE /saptrx/loc_id_2,
    END OF ts_req_tu_info.
  TYPES:
    tt_req_tu_info TYPE TABLE OF ts_req_tu_info.
  TYPES:
    BEGIN OF ts_stop_info,
      tor_id         TYPE /scmtms/tor_id,
      first_stop_num TYPE numc4,
      last_stop_num  TYPE numc4,
    END OF ts_stop_info .
  TYPES:
    tt_stop_info TYPE TABLE OF ts_stop_info .
private section.
ENDCLASS.



CLASS ZCL_GTT_STS_PE_TRK_ONFU_FO_FIL IMPLEMENTATION.


  METHOD zif_gtt_sts_pe_filler~get_planned_events.

    FIELD-SYMBOLS <ls_root> TYPE /scmtms/s_em_bo_tor_root.

    DATA:
      lv_counter          TYPE /saptrx/seq_num,
      lt_tracked_obj      TYPE tt_track_obj,
      ls_expeventdata     TYPE zif_gtt_sts_ef_types=>ts_expeventdata,
      lt_expeventdata     TYPE zif_gtt_sts_ef_types=>tt_expeventdata,
      lv_prefix           TYPE char20,
      lv_suffix           TYPE char4,
      lv_length           TYPE i,
      lv_locid2           TYPE /saptrx/loc_id_2,
      ls_previous_line    TYPE /saptrx/exp_events,
      lv_shp_num_previous TYPE /saptrx/loc_id_2,
      lv_shp_num          TYPE /saptrx/loc_id_2,
      lo_fu_filler        TYPE REF TO zcl_gtt_sts_pe_trk_onfu_plnfu,
      lt_req_tu_info      TYPE tt_req_tu_info.

    ASSIGN is_app_objects-maintabref->* TO <ls_root>.
    IF sy-subrc <> 0.
      MESSAGE e010(zgtt_sts) INTO DATA(lv_dummy) ##needed.
      zcl_gtt_sts_tools=>throw_exception( ).
    ENDIF.

    get_data_for_planned_event(
      EXPORTING
        is_app_objects = is_app_objects
      IMPORTING
        ev_tor_id      = DATA(lv_tor_id)
        et_stop        = DATA(lt_stop)
        et_loc_address = DATA(lt_loc_address)
        et_stop_points = DATA(lt_stop_points) ).

    IF <ls_root>-stop_seq_type = /scmtms/if_tor_const=>sc_stop_sequence-manifest."Star-Shaped Based on FU Stages
      DELETE lt_stop WHERE stop_cat = /scmtms/if_common_c=>c_stop_category-inbound.
    ENDIF.

    shp_arrival(
      EXPORTING
        iv_tor_id       = lv_tor_id
        it_stop         = lt_stop
        it_loc_addr     = lt_loc_address
        it_stop_points  = lt_stop_points
        is_app_objects  = is_app_objects
      CHANGING
        ct_expeventdata = ct_expeventdata ).

    decoupling(
      EXPORTING
        iv_tor_id       = lv_tor_id
        it_stop         = lt_stop
        it_loc_addr     = lt_loc_address
        it_stop_points  = lt_stop_points
        is_app_objects  = is_app_objects
      CHANGING
        ct_expeventdata = ct_expeventdata ).

    unload_start(
      EXPORTING
        iv_tor_id       = lv_tor_id
        it_stop         = lt_stop
        it_loc_addr     = lt_loc_address
        it_stop_points  = lt_stop_points
        is_app_objects  = is_app_objects
      CHANGING
        ct_expeventdata = ct_expeventdata ).

    unload_end(
      EXPORTING
        iv_tor_id       = lv_tor_id
        it_stop         = lt_stop
        it_loc_addr     = lt_loc_address
        it_stop_points  = lt_stop_points
        is_app_objects  = is_app_objects
      CHANGING
        ct_expeventdata = ct_expeventdata ).

    pod(
      EXPORTING
        iv_tor_id       = lv_tor_id
        it_stop         = lt_stop
        it_loc_addr     = lt_loc_address
        it_stop_points  = lt_stop_points
        is_app_objects  = is_app_objects
      CHANGING
        ct_expeventdata = ct_expeventdata ).

    load_start(
      EXPORTING
        iv_tor_id       = lv_tor_id
        it_stop         = lt_stop
        it_loc_addr     = lt_loc_address
        it_stop_points  = lt_stop_points
        is_app_objects  = is_app_objects
      CHANGING
        ct_expeventdata = ct_expeventdata ).

    load_end(
      EXPORTING
        iv_tor_id       = lv_tor_id
        it_stop         = lt_stop
        it_loc_addr     = lt_loc_address
        it_stop_points  = lt_stop_points
        is_app_objects  = is_app_objects
      CHANGING
        ct_expeventdata = ct_expeventdata ).

    popu(
      EXPORTING
        iv_tor_id       = lv_tor_id
        it_stop         = lt_stop
        it_loc_addr     = lt_loc_address
        it_stop_points  = lt_stop_points
        is_app_objects  = is_app_objects
      CHANGING
        ct_expeventdata = ct_expeventdata ).

    coupling(
      EXPORTING
        iv_tor_id       = lv_tor_id
        it_stop         = lt_stop
        it_loc_addr     = lt_loc_address
        it_stop_points  = lt_stop_points
        is_app_objects  = is_app_objects
      CHANGING
        ct_expeventdata = ct_expeventdata ).

    shp_departure(
      EXPORTING
        iv_tor_id       = lv_tor_id
        it_stop         = lt_stop
        it_loc_addr     = lt_loc_address
        it_stop_points  = lt_stop_points
        is_app_objects  = is_app_objects
      CHANGING
        ct_expeventdata = ct_expeventdata ).

    SORT ct_expeventdata BY locid2 ASCENDING.

    lo_fu_filler = NEW zcl_gtt_sts_pe_trk_onfu_plnfu( ).
    lo_fu_filler->get_planned_events(
      EXPORTING
        ir_fo_root      = is_app_objects-maintabref
        iv_appsys       = mo_ef_parameters->get_appsys(  )
        iv_appobjtype   = mo_ef_parameters->get_app_obj_types( )-aotype
        iv_appobjid     = is_app_objects-appobjid
      CHANGING
        ct_expeventdata = lt_expeventdata ).

    APPEND LINES OF lt_expeventdata TO ct_expeventdata.

    LOOP AT ct_expeventdata ASSIGNING FIELD-SYMBOL(<ls_expeventdata>)
      GROUP BY <ls_expeventdata>-locid2 ASSIGNING FIELD-SYMBOL(<ct_expeventdata_group>).

      lv_counter = 1.
      DATA(lv_first) = abap_true.
      LOOP AT GROUP <ct_expeventdata_group> ASSIGNING FIELD-SYMBOL(<ls_expeventdata_group>).
        IF lv_counter = 1.
          IF line_exists( ct_expeventdata[ sy-tabix - 1 ] ).
            ls_previous_line =  ct_expeventdata[ sy-tabix - 1 ].
            lv_length = strlen( ls_previous_line-locid2 ) - 4.
            lv_shp_num_previous = ls_previous_line-locid2+0(lv_length).

            lv_length = strlen( <ls_expeventdata_group>-locid2 ) - 4.
            lv_shp_num = <ls_expeventdata_group>-locid2+0(lv_length).
            IF lv_shp_num = lv_shp_num_previous.
              lv_counter = ct_expeventdata[ sy-tabix - 1 ]-milestonenum + 1.
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

  ENDMETHOD.
ENDCLASS.
