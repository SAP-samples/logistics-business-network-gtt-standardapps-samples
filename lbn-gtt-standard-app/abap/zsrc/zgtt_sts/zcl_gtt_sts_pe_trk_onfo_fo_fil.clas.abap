class ZCL_GTT_STS_PE_TRK_ONFO_FO_FIL definition
  public
  inheriting from ZCL_GTT_STS_PE_FILLER
  create public .

public section.

  methods ZIF_GTT_STS_PE_FILLER~GET_PLANNED_EVENTS
    redefinition .
protected section.


  types:
    tt_container TYPE TABLE OF /SCMTMS/PACKAGE_ID .

  types:
    tt_track_obj type TABLE OF /SCMTMS/PACKAGE_ID.
private section.

  methods GET_TRACKED_OBJ
    importing
      !IS_APP_OBJECT type TRXAS_APPOBJ_CTAB_WA
      !IV_OLD_DATA type ABAP_BOOL default ABAP_FALSE
    exporting
      !ET_TRACKED_OBJ type TT_TRACK_OBJ
    raising
      CX_UDM_MESSAGE .
  methods GET_MAINTABREF
    importing
      !IS_APP_OBJECT type TRXAS_APPOBJ_CTAB_WA
    returning
      value(RR_MAINTABREF) type ref to DATA .
ENDCLASS.



CLASS ZCL_GTT_STS_PE_TRK_ONFO_FO_FIL IMPLEMENTATION.


  METHOD get_maintabref.

    FIELD-SYMBOLS <lt_maintabref> TYPE ANY TABLE.

    ASSIGN is_app_object-maintabref->* TO FIELD-SYMBOL(<ls_maintabref>).

    IF <ls_maintabref> IS ASSIGNED AND zcl_gtt_sts_tools=>is_table( iv_value = <ls_maintabref> ) = abap_true.
      ASSIGN <ls_maintabref> TO <lt_maintabref>.
      LOOP AT <lt_maintabref> ASSIGNING FIELD-SYMBOL(<ls_line>).
        ASSIGN COMPONENT /scmtms/if_tor_c=>sc_node_attribute-root-tor_cat
          OF STRUCTURE <ls_line> TO FIELD-SYMBOL(<lv_tor_cat>).
        IF sy-subrc = 0 AND <lv_tor_cat> = /scmtms/if_tor_const=>sc_tor_category-active.
          GET REFERENCE OF <ls_line> INTO rr_maintabref.
          EXIT.
        ENDIF.
      ENDLOOP.
    ELSEIF <ls_maintabref> IS ASSIGNED.
      GET REFERENCE OF <ls_maintabref> INTO rr_maintabref.
    ENDIF.

  ENDMETHOD.


  METHOD get_tracked_obj.

    FIELD-SYMBOLS:
      <ls_root>     TYPE /scmtms/s_em_bo_tor_root.

    DATA:
      lt_tracked_obj TYPE tt_track_obj,
      lt_mobile      TYPE tt_track_obj,
      lv_platenumber TYPE /scmtms/resplatenr.

    CLEAR et_tracked_obj.

    DATA(lr_maintabref) = get_maintabref( is_app_object ).

    ASSIGN lr_maintabref->* TO <ls_root>.
    IF sy-subrc <> 0.
      MESSAGE e010(zgtt_sts) INTO DATA(lv_dummy) ##needed.
      zcl_gtt_sts_tools=>throw_exception( ).
    ENDIF.

    zcl_gtt_sts_tools=>get_container_mobile_id(
      EXPORTING
        ir_root      = lr_maintabref
        iv_old_data  = iv_old_data
      CHANGING
        et_container = lt_tracked_obj
        et_mobile    = lt_mobile ).

    APPEND LINES OF lt_mobile TO lt_tracked_obj.

    zcl_gtt_sts_tools=>get_plate_truck_number(
      EXPORTING
        ir_root        = lr_maintabref
        iv_old_data    = iv_old_data
      IMPORTING
        ev_platenumber = lv_platenumber ).

    IF lv_platenumber IS NOT INITIAL.
      APPEND lv_platenumber TO lt_tracked_obj.
    ENDIF.

    et_tracked_obj = lt_tracked_obj.

  ENDMETHOD.


  METHOD zif_gtt_sts_pe_filler~get_planned_events.

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
      lv_shp_num          TYPE /saptrx/loc_id_2.

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

    get_tracked_obj(
      EXPORTING
        is_app_object  = is_app_objects
      IMPORTING
        et_tracked_obj = lt_tracked_obj ).

    LOOP AT lt_tracked_obj INTO DATA(ls_tracked_obj).
      LOOP AT ct_expeventdata INTO ls_expeventdata
        WHERE appsys     = mo_ef_parameters->get_appsys(  )
          AND appobjtype = mo_ef_parameters->get_app_obj_types( )-aotype
          AND language   = sy-langu
          AND appobjid   = is_app_objects-appobjid.

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
