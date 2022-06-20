class ZCL_GTT_STS_PE_TRK_ONFU_PLNFU definition
  public
  final
  create public .

public section.

  methods GET_PLANNED_EVENTS
    importing
      !IR_FO_ROOT type ref to DATA
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
      !IR_FU_ROOT type ref to DATA
      !IR_FO_ROOT type ref to DATA
      !IT_FO_STOP type /SCMTMS/T_TOR_STOP_K
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
  methods POPU
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
      !IT_CAPA_STOP type /SCMTMS/T_TOR_STOP_K
      !IT_STOP_POINTS type ZIF_GTT_STS_EF_TYPES=>TT_STOP_POINTS optional
    changing
      !CT_EXPEVENTDATA type ZIF_GTT_STS_EF_TYPES=>TT_EXPEVENTDATA
    raising
      CX_UDM_MESSAGE .
  methods SHP_ARRIVAL
    importing
      !IR_ROOT type ref to DATA
      !IT_STOP type /SCMTMS/T_EM_BO_TOR_STOP optional
      !IT_CAPA_STOP type /SCMTMS/T_TOR_STOP_K
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
  methods POD
    importing
      !IR_ROOT type ref to DATA
      !IT_STOP type /SCMTMS/T_EM_BO_TOR_STOP optional
      !IT_STOP_POINTS type ZIF_GTT_STS_EF_TYPES=>TT_STOP_POINTS optional
    changing
      !CT_EXPEVENTDATA type ZIF_GTT_STS_EF_TYPES=>TT_EXPEVENTDATA
    raising
      CX_UDM_MESSAGE .
  methods GET_TRACKING_INFO
    importing
      !IR_DATA type ref to DATA
      !IV_OLD_DATA type ABAP_BOOL default ABAP_FALSE
    exporting
      !ET_TRACKED_OBJ type TT_TRACK_OBJ
    raising
      CX_UDM_MESSAGE .
  methods GET_REQ_DOC
    importing
      !IR_FO_ROOT type ref to DATA
    exporting
      !ET_FO_STOP type /SCMTMS/T_TOR_STOP_K
      !ET_REQ_TOR type /SCMTMS/T_TOR_ROOT_K
    raising
      CX_UDM_MESSAGE .
ENDCLASS.



CLASS ZCL_GTT_STS_PE_TRK_ONFU_PLNFU IMPLEMENTATION.


  METHOD GET_DATA_FOR_PLANNED_EVENT.

    FIELD-SYMBOLS:
      <ls_root>    TYPE /scmtms/s_em_bo_tor_root,
      <ls_fo_root> TYPE /scmtms/s_em_bo_tor_root.

    DATA:
      lr_srvmgr_tor TYPE REF TO /bobf/if_tra_service_manager,
      lt_capa       TYPE /scmtms/t_tor_root_k,
      lv_tor_id     TYPE /scmtms/tor_id,
      lt_root_key   TYPE /bobf/t_frw_key,
      lt_capa_stop  TYPE /scmtms/t_tor_stop_k.

    CLEAR:
      et_stop,
      et_stop_points.

    ASSIGN ir_fu_root->* TO <ls_root>.
    IF sy-subrc <> 0.
      MESSAGE e010(zgtt_sts) INTO DATA(lv_dummy) ##needed.
      zcl_gtt_sts_tools=>throw_exception( ).
    ENDIF.

    ASSIGN ir_fo_root->* TO <ls_fo_root>.
    IF sy-subrc <> 0.
      MESSAGE e010(zgtt_sts) INTO lv_dummy ##needed.
      zcl_gtt_sts_tools=>throw_exception( ).
    ENDIF.

    lr_srvmgr_tor = /bobf/cl_tra_serv_mgr_factory=>get_service_manager(
      iv_bo_key = /scmtms/if_tor_c=>sc_bo_key ).

    lv_tor_id = <ls_root>-tor_id.
    SHIFT lv_tor_id LEFT DELETING LEADING '0'.

    lt_root_key = VALUE #( ( key = <ls_root>-node_id ) ).

    TEST-SEAM lt_stop_seq.
      /scmtms/cl_tor_helper_stop=>get_stop_sequence(
        EXPORTING
          it_root_key     = lt_root_key
          iv_before_image = abap_false
        IMPORTING
          et_stop_seq_d   = DATA(lt_stop_seq) ).
    END-TEST-SEAM.

    ASSIGN lt_stop_seq[ root_key = <ls_root>-node_id ] TO FIELD-SYMBOL(<ls_stop_seq>) ##WARN_OK.
    IF sy-subrc = 0.
      MOVE-CORRESPONDING <ls_stop_seq>-stop_seq TO et_stop.
      LOOP AT et_stop ASSIGNING FIELD-SYMBOL(<ls_stop>).
        <ls_stop>-parent_node_id = <ls_root>-node_id.
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

    IF <ls_fo_root>-stop_seq_type = /scmtms/if_tor_const=>sc_stop_sequence-linear. "Defined and Linear
      LOOP AT et_stop USING KEY parent_seqnum ASSIGNING FIELD-SYMBOL(<ls_fu_stop>).
        ASSIGN it_fo_stop[ key = <ls_fu_stop>-assgn_stop_key parent_key = <ls_fo_root>-node_id  ] TO FIELD-SYMBOL(<ls_fo_stop>).
        IF sy-subrc <> 0.
          DELETE et_stop WHERE node_id = <ls_fu_stop>-node_id.
        ENDIF.
      ENDLOOP.
    ELSEIF <ls_fo_root>-stop_seq_type = /scmtms/if_tor_const=>sc_stop_sequence-manifest."Star-Shaped Based on FU Stages
      "copy all of the FU stops,and do nothing.
    ENDIF.

  ENDMETHOD.


  METHOD GET_PLANNED_EVENTS.

    FIELD-SYMBOLS:
      <ls_tor_root> TYPE /scmtms/s_em_bo_tor_root.

    DATA:
      lo_root             TYPE REF TO data,
      lv_counter          TYPE /saptrx/seq_num,
      ls_expeventdata     TYPE zif_gtt_sts_ef_types=>ts_expeventdata,
      lv_length           TYPE i,
      lv_prefix           TYPE char20,
      lv_suffix           TYPE char4,
      lv_locid2           TYPE /saptrx/loc_id_2,
      ls_previous_line    TYPE /saptrx/exp_events,
      lv_shp_num_previous TYPE /saptrx/loc_id_2,
      lv_shp_num          TYPE /saptrx/loc_id_2,
      lt_tracked_obj      TYPE tt_track_obj,
      lt_expeventdata     TYPE zif_gtt_sts_ef_types=>tt_expeventdata,
      lt_tmp_expeventdata TYPE zif_gtt_sts_ef_types=>tt_expeventdata,
      lt_req_tor          TYPE /scmtms/t_tor_root_k,
      lt_fo_stop          TYPE /scmtms/t_tor_stop_k.

    mv_appsys    = iv_appsys.
    mv_appobjtype  = iv_appobjtype.
    mv_appobjid  = iv_appobjid.

    CREATE DATA lo_root TYPE /scmtms/s_em_bo_tor_root.
    ASSIGN lo_root->* TO <ls_tor_root>.

    get_req_doc(
      EXPORTING
        ir_fo_root = ir_fo_root
      IMPORTING
        et_fo_stop = lt_fo_stop
        et_req_tor = lt_req_tor ).

    LOOP AT lt_req_tor INTO DATA(ls_req_tor).
      <ls_tor_root> = CORRESPONDING #( ls_req_tor MAPPING node_id  = key tor_root_node = root_key ).

      get_tracking_info(
        EXPORTING
          ir_data        = REF #( <ls_tor_root> )
        IMPORTING
          et_tracked_obj = lt_tracked_obj ).

      IF lt_tracked_obj IS INITIAL.
        CONTINUE.
      ENDIF.

      get_data_for_planned_event(
        EXPORTING
          ir_fu_root     = REF #( <ls_tor_root> )
          ir_fo_root     = ir_fo_root
          it_fo_stop     = lt_fo_stop
        IMPORTING
          et_stop        = DATA(lt_stop)
          et_stop_points = DATA(lt_stop_points) ).

      shp_arrival(
        EXPORTING
          ir_root         = REF #( <ls_tor_root> )
          it_stop         = lt_stop
          it_capa_stop    = lt_fo_stop
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
          it_capa_stop    = lt_fo_stop
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


  METHOD GET_REQ_DOC.

    FIELD-SYMBOLS:
      <ls_tor_root> TYPE /scmtms/s_em_bo_tor_root.

    DATA:
      lr_srvmgr_tor TYPE REF TO /bobf/if_tra_service_manager,
      lt_root_key   TYPE /bobf/t_frw_key.

    CLEAR:
      et_fo_stop,
      et_req_tor.

    ASSIGN ir_fo_root->* TO <ls_tor_root>.
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
        et_data         = et_fo_stop ).

    lr_srvmgr_tor->retrieve_by_association(
      EXPORTING
        iv_node_key    = /scmtms/if_tor_c=>sc_node-root
        it_key         = lt_root_key
        iv_association = /scmtms/if_tor_c=>sc_association-root-req_tor
        iv_fill_data   = abap_true
      IMPORTING
        et_data        = et_req_tor ).

  ENDMETHOD.


  METHOD get_tracking_info.

    FIELD-SYMBOLS:
      <ls_root>      TYPE /scmtms/s_em_bo_tor_root.

    DATA:
      lt_package_id  TYPE TABLE OF /scmtms/package_id,
      lt_tracked_obj TYPE tt_track_obj.

    CLEAR et_tracked_obj.

    ASSIGN ir_data->* TO <ls_root>.
    IF sy-subrc <> 0.
      MESSAGE e010(zgtt_sts) INTO DATA(lv_dummy) ##needed.
      zcl_gtt_sts_tools=>throw_exception( ).
    ENDIF.

    zcl_gtt_sts_tools=>get_container_mobile_id(
      EXPORTING
        ir_root      = ir_data
        iv_old_data  = iv_old_data
      CHANGING
        et_container = lt_tracked_obj ).

    zcl_gtt_sts_tools=>get_package_id(
      EXPORTING
        ir_root           = ir_data
        iv_old_data       = iv_old_data
      IMPORTING
        et_package_id_ext = lt_package_id ).

    APPEND LINES OF lt_tracked_obj TO et_tracked_obj.
    APPEND LINES OF lt_package_id TO et_tracked_obj.

  ENDMETHOD.


  METHOD LOAD_END.

    FIELD-SYMBOLS:
      <ls_root> TYPE /scmtms/s_em_bo_tor_root.

    DATA: lt_loc_root TYPE /scmtms/t_bo_loc_root_k.

    ASSIGN ir_root->* TO <ls_root>.
    IF sy-subrc <> 0.
      MESSAGE e010(zgtt_sts) INTO DATA(lv_dummy) ##needed.
      zcl_gtt_sts_tools=>throw_exception( ).
    ENDIF.

    LOOP AT it_stop ASSIGNING FIELD-SYMBOL(<ls_stop>) USING KEY parent_seqnum WHERE parent_node_id = <ls_root>-node_id.

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

      APPEND VALUE #( appsys            = mv_appsys
                      appobjtype        = mv_appobjtype
                      language          = sy-langu
                      appobjid          = mv_appobjid
                      milestone         = zif_gtt_sts_constants=>cs_milestone-fo_load_end
                      evt_exp_datetime  = |0{ lv_exp_datetime }|
                      evt_exp_tzone     = lv_tz
                      locid1            = <ls_stop>-log_locid
                      locid2            = ls_stop_points->stop_id
                      loctype           = zcl_gtt_sts_tools=>get_location_type( iv_locno = <ls_stop>-log_locid )
                      itemident         = <ls_stop>-node_id ) TO ct_expeventdata.

      CLEAR: lt_loc_root, ls_loc_root.
    ENDLOOP.

  ENDMETHOD.


  METHOD LOAD_START.

    FIELD-SYMBOLS:
      <ls_root> TYPE /scmtms/s_em_bo_tor_root.

    DATA: lt_loc_root TYPE /scmtms/t_bo_loc_root_k.

    ASSIGN ir_root->* TO <ls_root>.
    IF sy-subrc <> 0.
      MESSAGE e010(zgtt_sts) INTO DATA(lv_dummy) ##needed.
      zcl_gtt_sts_tools=>throw_exception( ).
    ENDIF.

    LOOP AT it_stop ASSIGNING FIELD-SYMBOL(<ls_stop>) USING KEY parent_seqnum WHERE parent_node_id = <ls_root>-node_id.

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

      APPEND VALUE #( appsys            = mv_appsys
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


  METHOD POD.

    FIELD-SYMBOLS:
      <ls_root> TYPE /scmtms/s_em_bo_tor_root.

    DATA: lt_loc_root TYPE /scmtms/t_bo_loc_root_k.

    ASSIGN ir_root->* TO <ls_root>.
    IF sy-subrc <> 0.
      MESSAGE e010(zgtt_sts) INTO DATA(lv_dummy) ##needed.
      zcl_gtt_sts_tools=>throw_exception( ).
    ENDIF.

    LOOP AT it_stop ASSIGNING FIELD-SYMBOL(<ls_stop>) USING KEY parent_seqnum WHERE parent_node_id = <ls_root>-node_id.

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


  METHOD POPU.

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


  METHOD SHP_ARRIVAL.

    FIELD-SYMBOLS:
      <ls_root> TYPE /scmtms/s_em_bo_tor_root.

    DATA: lt_loc_root TYPE /scmtms/t_bo_loc_root_k.

    ASSIGN ir_root->* TO <ls_root>.
    IF sy-subrc <> 0.
      MESSAGE e010(zgtt_sts) INTO DATA(lv_dummy) ##needed.
      zcl_gtt_sts_tools=>throw_exception( ).
    ENDIF.

    LOOP AT it_stop ASSIGNING FIELD-SYMBOL(<ls_stop>) USING KEY parent_seqnum WHERE parent_node_id = <ls_root>-node_id.

      READ TABLE it_capa_stop ASSIGNING FIELD-SYMBOL(<ls_capa_stop>) WITH KEY key = <ls_stop>-assgn_stop_key.
      CHECK sy-subrc = 0.

      READ TABLE it_stop_points REFERENCE INTO DATA(ls_stop_points)
                                     WITH KEY log_locid = <ls_stop>-log_locid
                                              seq_num   = <ls_stop>-seq_num.
      CHECK sy-subrc = 0.

      CHECK <ls_stop>-stop_cat = /scmtms/if_common_c=>c_stop_category-inbound AND
            <ls_capa_stop>-plan_trans_time IS NOT INITIAL.

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

      DATA(lv_exp_datetime) = <ls_capa_stop>-plan_trans_time.

      zcl_gtt_sts_tools=>convert_utc_timestamp(
        EXPORTING
          iv_timezone  = lv_tz
        CHANGING
          cv_timestamp = lv_exp_datetime ).

      APPEND VALUE #( appsys            = mv_appsys
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

  ENDMETHOD.


  METHOD SHP_DEPARTURE.

    FIELD-SYMBOLS:
      <ls_root> TYPE /scmtms/s_em_bo_tor_root.

    DATA: lt_loc_root TYPE /scmtms/t_bo_loc_root_k.

    ASSIGN ir_root->* TO <ls_root>.
    IF sy-subrc <> 0.
      MESSAGE e010(zgtt_sts) INTO DATA(lv_dummy) ##needed.
      zcl_gtt_sts_tools=>throw_exception( ).
    ENDIF.

    LOOP AT it_stop ASSIGNING FIELD-SYMBOL(<ls_stop>) USING KEY parent_seqnum WHERE parent_node_id = <ls_root>-node_id.

      READ TABLE it_capa_stop ASSIGNING FIELD-SYMBOL(<ls_capa_stop>)
        WITH KEY key = <ls_stop>-assgn_stop_key.
      CHECK sy-subrc = 0.

      READ TABLE it_stop_points REFERENCE INTO DATA(ls_stop_points)
                                     WITH KEY log_locid = <ls_stop>-log_locid
                                              seq_num   = <ls_stop>-seq_num.
      CHECK sy-subrc = 0.

      CHECK <ls_stop>-stop_cat = /scmtms/if_common_c=>c_stop_category-outbound AND
            <ls_capa_stop>-plan_trans_time IS NOT INITIAL.

      TEST-SEAM shp_departure_lt_loc_root.
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

      APPEND VALUE #( appsys           = mv_appsys
                      appobjtype       = mv_appobjtype
                      language         = sy-langu
                      appobjid         = mv_appobjid
                      milestone        = zif_gtt_sts_constants=>cs_milestone-fo_shp_departure
                      evt_exp_datetime = |0{ lv_exp_datetime }|
                      evt_exp_tzone    = lv_tz
                      locid1           = <ls_stop>-log_locid
                      locid2           = ls_stop_points->stop_id
                      loctype          = zcl_gtt_sts_tools=>get_location_type( iv_locno = <ls_stop>-log_locid ) ) TO ct_expeventdata.

      CLEAR: lt_loc_root, ls_loc_root.
    ENDLOOP.

  ENDMETHOD.


  METHOD UNLOAD_END.

    FIELD-SYMBOLS:
      <ls_root> TYPE /scmtms/s_em_bo_tor_root.

    DATA: lt_loc_root TYPE /scmtms/t_bo_loc_root_k.

    ASSIGN ir_root->* TO <ls_root>.
    IF sy-subrc <> 0.
      MESSAGE e010(zgtt_sts) INTO DATA(lv_dummy) ##needed.
      zcl_gtt_sts_tools=>throw_exception( ).
    ENDIF.

    LOOP AT it_stop ASSIGNING FIELD-SYMBOL(<ls_stop>) USING KEY parent_seqnum WHERE parent_node_id = <ls_root>-node_id.

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

      APPEND VALUE #( appsys            = mv_appsys
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

  ENDMETHOD.


  METHOD UNLOAD_START.
    FIELD-SYMBOLS:
      <ls_root> TYPE /scmtms/s_em_bo_tor_root.

    DATA: lt_loc_root TYPE /scmtms/t_bo_loc_root_k.

    ASSIGN ir_root->* TO <ls_root>.
    IF sy-subrc <> 0.
      MESSAGE e010(zgtt_sts) INTO DATA(lv_dummy) ##needed.
      zcl_gtt_sts_tools=>throw_exception( ).
    ENDIF.

    LOOP AT it_stop ASSIGNING FIELD-SYMBOL(<ls_stop>) USING KEY parent_seqnum WHERE parent_node_id = <ls_root>-node_id.

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

      APPEND VALUE #( appsys             = mv_appsys
                      appobjtype         = mv_appobjtype
                      language           = sy-langu
                      appobjid           = mv_appobjid
                       milestone         = zif_gtt_sts_constants=>cs_milestone-fo_unload_start
                       evt_exp_datetime  = |0{ lv_exp_datetime }|
                       evt_exp_tzone     = lv_tz
                       locid1            = <ls_stop>-log_locid
                       locid2            = ls_stop_points->stop_id
                       loctype           = zcl_gtt_sts_tools=>get_location_type( iv_locno = <ls_stop>-log_locid ) ) TO ct_expeventdata.

      CLEAR: lt_loc_root, ls_loc_root.
    ENDLOOP.

  ENDMETHOD.
ENDCLASS.
