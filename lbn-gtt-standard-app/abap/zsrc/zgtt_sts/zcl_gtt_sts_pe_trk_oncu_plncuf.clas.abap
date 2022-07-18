class ZCL_GTT_STS_PE_TRK_ONCU_PLNCUF definition
  public
  inheriting from ZCL_GTT_STS_PE_TRK_ONCU_PLNCU
  create public .

public section.

  methods GET_PLANNED_EVENTS
    redefinition .
protected section.

  methods GET_DATA_FOR_PLANNED_EVENT
    redefinition .
private section.
ENDCLASS.



CLASS ZCL_GTT_STS_PE_TRK_ONCU_PLNCUF IMPLEMENTATION.


  METHOD get_planned_events.

    FIELD-SYMBOLS:
      <ls_tor_root> TYPE /scmtms/s_em_bo_tor_root.

    DATA:
      lo_root             TYPE REF TO data,
      lr_srvmgr_tor       TYPE REF TO /bobf/if_tra_service_manager,
      lt_root_key         TYPE /bobf/t_frw_key,
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
      lv_shp_num          TYPE /saptrx/loc_id_2,
      lt_req_tor          TYPE /scmtms/t_tor_root_k,
      lt_fo_stop          TYPE /scmtms/t_tor_stop_k.

    mv_appsys    = iv_appsys.
    mv_appobjtype  = iv_appobjtype.
    mv_appobjid  = iv_appobjid.

    CREATE DATA lo_root TYPE /scmtms/s_em_bo_tor_root.
    ASSIGN lo_root->* TO <ls_tor_root>.

    get_req_doc(
      EXPORTING
        ir_fo_root = ir_root
      IMPORTING
        et_fo_stop = lt_fo_stop
        et_req_tor = lt_req_tor ).

    LOOP AT lt_req_tor INTO DATA(ls_req_tor).

      <ls_tor_root> = CORRESPONDING #( ls_req_tor MAPPING node_id  = key tor_root_node = root_key ).

      get_tracking_info(
        EXPORTING
          ir_data        = REF #( <ls_tor_root> )
        IMPORTING
          et_tracked_obj = DATA(lt_tracked_obj) ).

      IF lt_tracked_obj IS INITIAL.
        CONTINUE.
      ENDIF.

      get_data_for_planned_event(
        EXPORTING
          ir_root        = REF #( <ls_tor_root> )
          ir_fu_root     = ir_root
          it_fu_stop     = lt_fo_stop
        IMPORTING
          et_stop        = DATA(lt_stop)
          et_stop_points = DATA(lt_stop_points) ).

      shp_arrival(
        EXPORTING
          ir_root         = REF #( <ls_tor_root> )
          it_stop         = lt_stop
          it_stop_points  = lt_stop_points
        CHANGING
          ct_expeventdata = lt_tmp_expeventdata ).

      unload_start(
        EXPORTING
          ir_root         = REF #( <ls_tor_root> )
          it_stop         = lt_stop
          it_stop_points  = lt_stop_points
        CHANGING
          ct_expeventdata = lt_tmp_expeventdata ).

      unload_end(
        EXPORTING
          ir_root         = REF #( <ls_tor_root> )
          it_stop         = lt_stop
          it_stop_points  = lt_stop_points
        CHANGING
          ct_expeventdata = lt_tmp_expeventdata ).

      pod(
        EXPORTING
          ir_root         = REF #( <ls_tor_root> )
          it_stop         = lt_stop
          it_stop_points  = lt_stop_points
        CHANGING
          ct_expeventdata = lt_tmp_expeventdata ).

      load_start(
        EXPORTING
          ir_root         = REF #( <ls_tor_root> )
          it_stop         = lt_stop
          it_stop_points  = lt_stop_points
        CHANGING
          ct_expeventdata = lt_tmp_expeventdata ).

      load_end(
        EXPORTING
          ir_root         = REF #( <ls_tor_root> )
          it_stop         = lt_stop
          it_stop_points  = lt_stop_points
        CHANGING
          ct_expeventdata = lt_tmp_expeventdata ).

      popu(
        EXPORTING
          ir_root         = REF #( <ls_tor_root> )
          it_stop         = lt_stop
          it_stop_points  = lt_stop_points
        CHANGING
          ct_expeventdata = lt_tmp_expeventdata ).

      shp_departure(
        EXPORTING
          ir_root         = REF #( <ls_tor_root> )
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

    LOOP AT et_stop USING KEY parent_seqnum ASSIGNING FIELD-SYMBOL(<ls_tu_stop>).
      ASSIGN it_fu_stop[ key = <ls_tu_stop>-assgn_stop_key parent_key = <ls_fu_root>-node_id ] TO FIELD-SYMBOL(<ls_fu_stop>).
      IF sy-subrc <> 0.
        DELETE et_stop WHERE node_id = <ls_tu_stop>-node_id.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.
ENDCLASS.
