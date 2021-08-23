class ZCL_GTT_STS_PE_FO_FILLER definition
  public
  inheriting from ZCL_GTT_STS_PE_FILLER
  create public .

public section.

  methods ZIF_GTT_STS_PE_FILLER~GET_PLANNED_EVENTS
    redefinition .
  PROTECTED SECTION.
  PRIVATE SECTION.
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

  ENDMETHOD.
ENDCLASS.
