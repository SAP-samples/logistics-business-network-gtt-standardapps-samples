class ZCL_GTT_STS_PE_FO_FILLER definition
  public
  inheriting from ZCL_GTT_STS_PE_FILLER
  create public .

public section.

  methods ZIF_GTT_STS_PE_FILLER~GET_PLANNED_EVENTS
    redefinition .
  PROTECTED SECTION.
private section.

  methods ADD_PLANNED_SOURCE_ARRIVAL
    importing
      !IS_APP_OBJECTS type TRXAS_APPOBJ_CTAB_WA
    changing
      !CT_EXPEVENTDATA type ZIF_GTT_STS_EF_TYPES=>TT_EXPEVENTDATA
    raising
      CX_UDM_MESSAGE .
ENDCLASS.



CLASS ZCL_GTT_STS_PE_FO_FILLER IMPLEMENTATION.


  METHOD zif_gtt_sts_pe_filler~get_planned_events.

    DATA lv_counter TYPE /saptrx/seq_num.

    get_data_for_planned_event(
      EXPORTING
        is_app_objects = is_app_objects
      IMPORTING
        ev_tor_id      = DATA(lv_tor_id)
        et_stop        = DATA(lt_stop)
        et_loc_address = DATA(lt_loc_address)
        et_stop_points = DATA(lt_stop_points) ).

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

    lv_counter = 1.
    LOOP AT ct_expeventdata ASSIGNING FIELD-SYMBOL(<ls_expeventdata>).
      <ls_expeventdata>-milestonenum = lv_counter.
      lv_counter += 1.
    ENDLOOP.

*   Add planned source arrival event for LTL shipment
    add_planned_source_arrival(
      EXPORTING
        is_app_objects  = is_app_objects
      CHANGING
        ct_expeventdata = ct_expeventdata ).

  ENDMETHOD.


  METHOD add_planned_source_arrival.

    DATA:
      ls_eventdata TYPE zif_gtt_sts_ef_types=>ts_expeventdata,
      lt_eventdata TYPE zif_gtt_sts_ef_types=>tt_expeventdata,
      lv_tor_id    TYPE /scmtms/tor_id,
      lv_locid2    TYPE /saptrx/loc_id_2.

    zcl_gtt_sts_tools=>check_ltl_shipment(
      EXPORTING
        ir_root     = is_app_objects-maintabref
      IMPORTING
        ev_ltl_flag = DATA(lv_ltl_flag) ).

    CHECK lv_ltl_flag = abap_true.

    lv_tor_id = zcl_gtt_sts_tools=>get_field_of_structure(
      ir_struct_data = is_app_objects-maintabref
      iv_field_name  = /scmtms/if_tor_c=>sc_node_attribute-root-tor_id ).
    SHIFT lv_tor_id LEFT DELETING LEADING '0'.
    CONCATENATE lv_tor_id '0001' INTO lv_locid2.

    READ TABLE ct_expeventdata ASSIGNING FIELD-SYMBOL(<ls_expeventdata>)
      WITH KEY milestone = zif_gtt_sts_constants=>cs_milestone-fo_shp_departure
               locid2    = lv_locid2.
    IF sy-subrc = 0.
      ls_eventdata = <ls_expeventdata>.
      ls_eventdata-milestonenum = 0.
      ls_eventdata-milestone = zif_gtt_sts_constants=>cs_milestone-fo_shp_arrival.

      READ TABLE ct_expeventdata INTO DATA(ls_exp_data)
        WITH KEY milestone = zif_gtt_sts_constants=>cs_milestone-fo_load_start
                 locid2    = lv_locid2.
      IF sy-subrc = 0.
        ls_eventdata-evt_exp_datetime = ls_exp_data-evt_exp_datetime.
        ls_eventdata-evt_exp_tzone = ls_exp_data-evt_exp_tzone.
      ENDIF.

*     Add planned source arrival event for LTL shipment
      INSERT ls_eventdata INTO ct_expeventdata INDEX 1.
    ENDIF.

  ENDMETHOD.
ENDCLASS.
