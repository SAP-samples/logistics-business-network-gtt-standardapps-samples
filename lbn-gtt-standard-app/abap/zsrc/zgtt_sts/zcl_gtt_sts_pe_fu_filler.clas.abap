class ZCL_GTT_STS_PE_FU_FILLER definition
  public
  inheriting from ZCL_GTT_STS_PE_FILLER
  create public .

public section.

  methods GET_CAPA_MATCHKEY
    importing
      !IV_ASSGN_STOP_KEY type /SCMTMS/TOR_STOP_KEY
    returning
      value(RV_MATCH_KEY) type /SAPTRX/LOC_ID_2
    raising
      CX_UDM_MESSAGE .

  methods ZIF_GTT_STS_PE_FILLER~GET_PLANNED_EVENTS
    redefinition .
  PROTECTED SECTION.

    METHODS load_end
        REDEFINITION .
    METHODS load_start
        REDEFINITION .
    METHODS pod
        REDEFINITION .
    METHODS shp_arrival
        REDEFINITION .
    METHODS shp_departure
        REDEFINITION .
    METHODS unload_end
        REDEFINITION .
    METHODS unload_start
        REDEFINITION .
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_GTT_STS_PE_FU_FILLER IMPLEMENTATION.


  METHOD get_capa_matchkey.

    FIELD-SYMBOLS:
      <lt_capa_root> TYPE /scmtms/t_em_bo_tor_root,
      <lt_capa_stop> TYPE /scmtms/t_em_bo_tor_stop.

    DATA(lr_capa_root) = mo_ef_parameters->get_appl_table( /scmtms/cl_scem_int_c=>sc_table_definition-bo_tor-capa_root ).
    ASSIGN lr_capa_root->* TO <lt_capa_root>.
    IF sy-subrc <> 0.
      RETURN.
    ENDIF.

    DATA(lr_capa_stop) = mo_ef_parameters->get_appl_table( /scmtms/cl_scem_int_c=>sc_table_definition-bo_tor-capa_stop ).
    ASSIGN lr_capa_stop->* TO <lt_capa_stop>.
    IF sy-subrc <> 0.
      RETURN.
    ENDIF.

    rv_match_key = zcl_gtt_sts_tools=>get_capa_match_key(
                        iv_assgn_stop_key = iv_assgn_stop_key
                        it_capa_stop      = <lt_capa_stop>
                        it_capa_root      = <lt_capa_root> ).

  ENDMETHOD.


  METHOD load_end.

    DATA: ls_loc_addr TYPE REF TO /bofu/s_addr_postal_addressk,
          lt_loc_root TYPE /scmtms/t_bo_loc_root_k.

    FIELD-SYMBOLS:
      <lt_stop> TYPE /scmtms/t_em_bo_tor_stop,
      <ls_root> TYPE /scmtms/s_em_bo_tor_root.

    ASSIGN is_app_objects-maintabref->* TO <ls_root>.
    IF sy-subrc <> 0.
      RETURN.
    ENDIF.

    DATA(lr_stop) = mo_ef_parameters->get_appl_table( /scmtms/cl_scem_int_c=>sc_table_definition-bo_tor-stop ).
    ASSIGN lr_stop->* TO <lt_stop>.
    IF sy-subrc <> 0.
      RETURN.
    ENDIF.

    LOOP AT <lt_stop> ASSIGNING FIELD-SYMBOL(<ls_stop>) USING KEY parent_seqnum WHERE parent_node_id = <ls_root>-node_id.

      CHECK <ls_stop>-stop_cat = /scmtms/if_common_c=>c_stop_category-outbound AND <ls_stop>-assgn_end IS NOT INITIAL.

      READ TABLE it_loc_addr REFERENCE INTO ls_loc_addr
         WITH KEY root_key = <ls_stop>-log_loc_uuid.
      CHECK sy-subrc = 0.

      /scmtms/cl_pln_bo_data=>get_loc_data(
             EXPORTING
               it_key      = VALUE #( ( key = <ls_stop>-log_loc_uuid ) )
             CHANGING
               ct_loc_root = lt_loc_root ).

      READ TABLE lt_loc_root REFERENCE INTO DATA(ls_loc_root)
                                     WITH KEY key COMPONENTS key = <ls_stop>-log_loc_uuid.
      CHECK sy-subrc = 0.

      DATA(lv_tz) = COND tznzone( WHEN ls_loc_root->time_zone_code IS NOT INITIAL
                                  THEN ls_loc_root->time_zone_code
                                  ELSE sy-zonlo ).

      DATA(lv_exp_datetime) = <ls_stop>-assgn_end.

      zcl_gtt_sts_tools=>convert_utc_timestamp(
        EXPORTING
          iv_timezone  =  lv_tz
        CHANGING
          cv_timestamp = lv_exp_datetime ).

      DATA(lv_locid2) = get_capa_matchkey( iv_assgn_stop_key = <ls_stop>-assgn_stop_key ).
      mv_milestonecnt += 1.

      APPEND VALUE #( appsys            = mo_ef_parameters->get_appsys(  )
                      appobjtype        = mo_ef_parameters->get_app_obj_types( )-aotype
                      language          = sy-langu
                      appobjid          = is_app_objects-appobjid
                      milestone         = zif_gtt_sts_constants=>cs_milestone-fo_load_end
                      evt_exp_datetime  = |0{ lv_exp_datetime }|
                      evt_exp_tzone     = lv_tz
                      locid1            = <ls_stop>-log_locid
                      locid2            = lv_locid2
                      loctype           = zif_gtt_sts_constants=>cs_location_type-logistic
                      country           = ls_loc_addr->country_code
                      city              = ls_loc_addr->city_name
                      itemident         = <ls_stop>-node_id ) TO ct_expeventdata.

      CLEAR: lt_loc_root, ls_loc_root.
    ENDLOOP.

  ENDMETHOD.


  METHOD load_start.

    DATA: lt_loc_root TYPE /scmtms/t_bo_loc_root_k.

    FIELD-SYMBOLS:
      <lt_stop> TYPE /scmtms/t_em_bo_tor_stop,
      <ls_root> TYPE /scmtms/s_em_bo_tor_root.

    ASSIGN is_app_objects-maintabref->* TO <ls_root>.
    IF sy-subrc <> 0.
      RETURN.
    ENDIF.

    DATA(lr_stop) = mo_ef_parameters->get_appl_table( /scmtms/cl_scem_int_c=>sc_table_definition-bo_tor-stop ).
    ASSIGN lr_stop->* TO <lt_stop>.
    IF sy-subrc <> 0.
      RETURN.
    ENDIF.

    LOOP AT <lt_stop> ASSIGNING FIELD-SYMBOL(<ls_stop>) USING KEY parent_seqnum WHERE parent_node_id = <ls_root>-node_id.

      CHECK <ls_stop>-stop_cat = /scmtms/if_common_c=>c_stop_category-outbound AND <ls_stop>-assgn_start IS NOT INITIAL.

      READ TABLE it_loc_addr ASSIGNING FIELD-SYMBOL(<ls_loc_addr>) WITH KEY root_key = <ls_stop>-log_loc_uuid.
      CHECK sy-subrc = 0.

      /scmtms/cl_pln_bo_data=>get_loc_data(
        EXPORTING
          it_key      = VALUE #( ( key = <ls_stop>-log_loc_uuid ) )
        CHANGING
          ct_loc_root = lt_loc_root ).

      READ TABLE lt_loc_root REFERENCE INTO DATA(ls_loc_root)
                                     WITH KEY key COMPONENTS key = <ls_stop>-log_loc_uuid.
      CHECK sy-subrc = 0.

      DATA(lv_tz) = COND tznzone( WHEN ls_loc_root->time_zone_code IS NOT INITIAL
                                  THEN ls_loc_root->time_zone_code
                                  ELSE sy-zonlo ).

      DATA(lv_exp_datetime) = <ls_stop>-assgn_start.

      zcl_gtt_sts_tools=>convert_utc_timestamp(
        EXPORTING
          iv_timezone  =  lv_tz
        CHANGING
          cv_timestamp = lv_exp_datetime ).

      DATA(lv_locid2) = get_capa_matchkey( iv_assgn_stop_key = <ls_stop>-assgn_stop_key ).
      mv_milestonecnt += 1.

      APPEND VALUE #( appsys            = mo_ef_parameters->get_appsys(  )
                      appobjtype        = mo_ef_parameters->get_app_obj_types( )-aotype
                      language          = sy-langu
                      appobjid          = is_app_objects-appobjid
                      milestone         = zif_gtt_sts_constants=>cs_milestone-fo_load_start
                      evt_exp_datetime  = |0{ lv_exp_datetime }|
                      evt_exp_tzone     = lv_tz
                      locid1            = <ls_stop>-log_locid
                      locid2            = lv_locid2
                      loctype           = zif_gtt_sts_constants=>cs_location_type-logistic
                      country           = <ls_loc_addr>-country_code
                      city              = <ls_loc_addr>-city_name ) TO ct_expeventdata.

      CLEAR: lt_loc_root, ls_loc_root.
    ENDLOOP.

  ENDMETHOD.


  METHOD pod.

    DATA:
      ls_loc_addr TYPE REF TO /bofu/s_addr_postal_addressk,
      lt_loc_root TYPE /scmtms/t_bo_loc_root_k.

    FIELD-SYMBOLS:
      <lt_stop> TYPE /scmtms/t_em_bo_tor_stop,
      <ls_root> TYPE /scmtms/s_em_bo_tor_root.

    ASSIGN is_app_objects-maintabref->* TO <ls_root>.
    IF sy-subrc <> 0.
      RETURN.
    ENDIF.

    DATA(lr_stop) = mo_ef_parameters->get_appl_table( /scmtms/cl_scem_int_c=>sc_table_definition-bo_tor-stop ).
    ASSIGN lr_stop->* TO <lt_stop>.
    IF sy-subrc <> 0.
      RETURN.
    ENDIF.

    DATA(lt_stop) = VALUE /scmtms/t_em_bo_tor_stop( FOR <ls_tor_stop> IN <lt_stop> USING KEY parent_seqnum
                                                    WHERE ( parent_node_id = <ls_root>-node_id ) ( <ls_tor_stop> ) ).

    DATA(lv_stop_count) = lines( lt_stop ).
    ASSIGN lt_stop[ seq_num = lv_stop_count ] TO FIELD-SYMBOL(<ls_stop>) ##WARN_OK.
    IF sy-subrc <> 0.
      RETURN.
    ENDIF.
    IF <ls_stop>-assgn_end IS INITIAL.
      RETURN.
    ENDIF.

    READ TABLE it_loc_addr REFERENCE INTO ls_loc_addr WITH KEY root_key = <ls_stop>-log_loc_uuid.
    IF sy-subrc <> 0.
      RETURN.
    ENDIF.

    /scmtms/cl_pln_bo_data=>get_loc_data(
      EXPORTING
        it_key      = VALUE #( ( key = <ls_stop>-log_loc_uuid ) )
      CHANGING
        ct_loc_root = lt_loc_root ).

    READ TABLE lt_loc_root REFERENCE INTO DATA(ls_loc_root) WITH KEY key COMPONENTS key = <ls_stop>-log_loc_uuid.
    IF sy-subrc <> 0.
      RETURN.
    ENDIF.

    DATA(lv_tz) = COND tznzone( WHEN ls_loc_root->time_zone_code IS NOT INITIAL
                                THEN ls_loc_root->time_zone_code
                                ELSE sy-zonlo ).

    DATA(lv_exp_datetime) = <ls_stop>-assgn_end.

    zcl_gtt_sts_tools=>convert_utc_timestamp(
      EXPORTING
        iv_timezone  =  lv_tz
      CHANGING
        cv_timestamp = lv_exp_datetime ).

    DATA(lv_locid2) = get_capa_matchkey( iv_assgn_stop_key = <ls_stop>-assgn_stop_key ).
    mv_milestonecnt += 1.

    APPEND VALUE #( appsys           = mo_ef_parameters->get_appsys(  )
                    appobjtype       = mo_ef_parameters->get_app_obj_types( )-aotype
                    language         = sy-langu
                    appobjid         = is_app_objects-appobjid
                    milestone        = zif_gtt_sts_constants=>cs_milestone-fo_shp_pod
                    evt_exp_datetime = |0{ lv_exp_datetime }|
                    evt_exp_tzone    = lv_tz
                    locid1           = <ls_stop>-log_locid
                    locid2           = lv_locid2
                    loctype          = zif_gtt_sts_constants=>cs_location_type-logistic
                    country          = ls_loc_addr->country_code
                    city             = ls_loc_addr->city_name ) TO ct_expeventdata.

    CLEAR: lt_loc_root, ls_loc_root.

  ENDMETHOD.


  METHOD shp_arrival.

    DATA: ls_loc_addr TYPE REF TO /bofu/s_addr_postal_addressk,
          lt_loc_root TYPE /scmtms/t_bo_loc_root_k.

    FIELD-SYMBOLS:
      <lt_capa_stop> TYPE /scmtms/t_em_bo_tor_stop,
      <lt_stop>      TYPE /scmtms/t_em_bo_tor_stop,
      <ls_root>      TYPE /scmtms/s_em_bo_tor_root.

    ASSIGN is_app_objects-maintabref->* TO <ls_root>.
    IF sy-subrc <> 0.
      RETURN.
    ENDIF.

    DATA(lr_stop) = mo_ef_parameters->get_appl_table( /scmtms/cl_scem_int_c=>sc_table_definition-bo_tor-stop ).
    ASSIGN lr_stop->* TO <lt_stop>.
    IF sy-subrc <> 0.
      RETURN.
    ENDIF.

    DATA(lr_capa_stop) = mo_ef_parameters->get_appl_table( /scmtms/cl_scem_int_c=>sc_table_definition-bo_tor-capa_stop ).
    ASSIGN lr_capa_stop->* TO <lt_capa_stop>.

    LOOP AT <lt_stop> ASSIGNING FIELD-SYMBOL(<ls_stop>) USING KEY parent_seqnum WHERE parent_node_id = <ls_root>-node_id.

      READ TABLE <lt_capa_stop> ASSIGNING FIELD-SYMBOL(<ls_capa_stop>) WITH KEY node_id = <ls_stop>-assgn_stop_key.
      CHECK sy-subrc = 0.

      CHECK <ls_stop>-stop_cat = /scmtms/if_common_c=>c_stop_category-inbound AND
            <ls_capa_stop>-plan_trans_time IS NOT INITIAL.

      READ TABLE it_loc_addr REFERENCE INTO ls_loc_addr WITH KEY root_key = <ls_stop>-log_loc_uuid.
      CHECK sy-subrc = 0.

      /scmtms/cl_pln_bo_data=>get_loc_data(
              EXPORTING
                it_key      = VALUE #( ( key = <ls_stop>-log_loc_uuid ) )
              CHANGING
                ct_loc_root = lt_loc_root ).

      READ TABLE lt_loc_root REFERENCE INTO DATA(ls_loc_root)
                                     WITH KEY key COMPONENTS key = <ls_stop>-log_loc_uuid.
      CHECK sy-subrc = 0.

      DATA(lv_tz) = COND tznzone( WHEN ls_loc_root->time_zone_code IS NOT INITIAL
                                  THEN ls_loc_root->time_zone_code
                                  ELSE sy-zonlo ).

      DATA(lv_exp_datetime) = <ls_capa_stop>-plan_trans_time.

      zcl_gtt_sts_tools=>convert_utc_timestamp(
        EXPORTING
          iv_timezone  =  lv_tz
        CHANGING
          cv_timestamp = lv_exp_datetime ).

      DATA(lv_locid2) = get_capa_matchkey( iv_assgn_stop_key = <ls_stop>-assgn_stop_key ).
      mv_milestonecnt += 1.

      APPEND VALUE #( appsys            = mo_ef_parameters->get_appsys(  )
                      appobjtype        = mo_ef_parameters->get_app_obj_types( )-aotype
                      language          = sy-langu
                      appobjid          = is_app_objects-appobjid
                      milestone         = zif_gtt_sts_constants=>cs_milestone-fo_shp_arrival
                      evt_exp_datetime  = |0{ lv_exp_datetime }|
                      evt_exp_tzone     = lv_tz
                      locid1            = <ls_stop>-log_locid
                      locid2            = lv_locid2
                      loctype           = zif_gtt_sts_constants=>cs_location_type-logistic
                      country           = ls_loc_addr->country_code
                      city              = ls_loc_addr->city_name ) TO ct_expeventdata.

      CLEAR: lt_loc_root, ls_loc_root.
    ENDLOOP.

  ENDMETHOD.


  METHOD shp_departure.

    DATA: ls_loc_addr TYPE REF TO /bofu/s_addr_postal_addressk,
          lt_loc_root TYPE /scmtms/t_bo_loc_root_k.

    FIELD-SYMBOLS:
      <lt_capa_stop> TYPE /scmtms/t_em_bo_tor_stop,
      <lt_stop>      TYPE /scmtms/t_em_bo_tor_stop,
      <ls_root>      TYPE /scmtms/s_em_bo_tor_root.

    ASSIGN is_app_objects-maintabref->* TO <ls_root>.
    IF sy-subrc <> 0.
      RETURN.
    ENDIF.

    DATA(lr_stop) = mo_ef_parameters->get_appl_table( /scmtms/cl_scem_int_c=>sc_table_definition-bo_tor-stop ).
    ASSIGN lr_stop->* TO <lt_stop>.
    IF sy-subrc <> 0.
      RETURN.
    ENDIF.

    DATA(lr_capa_stop) = mo_ef_parameters->get_appl_table( /scmtms/cl_scem_int_c=>sc_table_definition-bo_tor-capa_stop ).
    ASSIGN lr_capa_stop->* TO <lt_capa_stop>.

    LOOP AT <lt_stop> ASSIGNING FIELD-SYMBOL(<ls_stop>) USING KEY parent_seqnum WHERE parent_node_id = <ls_root>-node_id.

      READ TABLE <lt_capa_stop> ASSIGNING FIELD-SYMBOL(<ls_capa_stop>)
        WITH KEY node_id = <ls_stop>-assgn_stop_key.
      CHECK sy-subrc = 0.

      CHECK <ls_stop>-stop_cat = /scmtms/if_common_c=>c_stop_category-outbound AND
            <ls_capa_stop>-plan_trans_time IS NOT INITIAL.

      READ TABLE it_loc_addr REFERENCE INTO ls_loc_addr  WITH KEY root_key = <ls_stop>-log_loc_uuid.
      CHECK sy-subrc = 0.

      /scmtms/cl_pln_bo_data=>get_loc_data(
                      EXPORTING
                        it_key      = VALUE #( ( key = <ls_stop>-log_loc_uuid ) )
                      CHANGING
                        ct_loc_root = lt_loc_root ).

      READ TABLE lt_loc_root REFERENCE INTO DATA(ls_loc_root)
                                     WITH KEY key COMPONENTS key = <ls_stop>-log_loc_uuid.
      CHECK sy-subrc = 0.

      DATA(lv_tz) = COND tznzone( WHEN ls_loc_root->time_zone_code IS NOT INITIAL
                                  THEN ls_loc_root->time_zone_code
                                  ELSE sy-zonlo ).

      DATA(lv_exp_datetime) = <ls_capa_stop>-plan_trans_time.

      zcl_gtt_sts_tools=>convert_utc_timestamp(
        EXPORTING
          iv_timezone  =  lv_tz
        CHANGING
          cv_timestamp = lv_exp_datetime ).

      DATA(lv_locid2) = get_capa_matchkey( iv_assgn_stop_key = <ls_stop>-assgn_stop_key ).
      mv_milestonecnt += 1.

      APPEND VALUE #( appsys           = mo_ef_parameters->get_appsys(  )
                      appobjtype       = mo_ef_parameters->get_app_obj_types( )-aotype
                      language         = sy-langu
                      appobjid         = is_app_objects-appobjid
                      milestone        = zif_gtt_sts_constants=>cs_milestone-fo_shp_departure
                      evt_exp_datetime = |0{ lv_exp_datetime }|
                      evt_exp_tzone    = lv_tz
                      locid1           = <ls_stop>-log_locid
                      locid2           = lv_locid2
                      loctype          = zif_gtt_sts_constants=>cs_location_type-logistic
                      country          = ls_loc_addr->country_code
                      city             = ls_loc_addr->city_name ) TO ct_expeventdata.

      CLEAR: lt_loc_root, ls_loc_root.
    ENDLOOP.

  ENDMETHOD.


  METHOD unload_end.

    DATA: ls_loc_addr TYPE REF TO /bofu/s_addr_postal_addressk,
          lt_loc_root TYPE /scmtms/t_bo_loc_root_k.

    FIELD-SYMBOLS:
      <lt_stop> TYPE /scmtms/t_em_bo_tor_stop,
      <ls_root> TYPE /scmtms/s_em_bo_tor_root.

    ASSIGN is_app_objects-maintabref->* TO <ls_root>.
    IF sy-subrc <> 0.
      RETURN.
    ENDIF.

    DATA(lr_stop) = mo_ef_parameters->get_appl_table( /scmtms/cl_scem_int_c=>sc_table_definition-bo_tor-stop ).
    ASSIGN lr_stop->* TO <lt_stop>.
    IF sy-subrc <> 0.
      RETURN.
    ENDIF.

    LOOP AT <lt_stop> ASSIGNING FIELD-SYMBOL(<ls_stop>) USING KEY parent_seqnum WHERE parent_node_id = <ls_root>-node_id.

      CHECK <ls_stop>-stop_cat = /scmtms/if_common_c=>c_stop_category-inbound AND <ls_stop>-assgn_end IS NOT INITIAL.

      READ TABLE it_loc_addr REFERENCE INTO ls_loc_addr
                                     WITH KEY root_key = <ls_stop>-log_loc_uuid.

      CHECK sy-subrc = 0.

      /scmtms/cl_pln_bo_data=>get_loc_data(
        EXPORTING
          it_key      = VALUE #( ( key = <ls_stop>-log_loc_uuid ) )
        CHANGING
          ct_loc_root = lt_loc_root ).

      READ TABLE lt_loc_root REFERENCE INTO DATA(ls_loc_root)
                                     WITH KEY key COMPONENTS key = <ls_stop>-log_loc_uuid.
      CHECK sy-subrc = 0.

      DATA(lv_tz) = COND tznzone( WHEN ls_loc_root->time_zone_code IS NOT INITIAL
                                  THEN ls_loc_root->time_zone_code
                                  ELSE sy-zonlo ).

      DATA(lv_exp_datetime) = <ls_stop>-assgn_end.

      zcl_gtt_sts_tools=>convert_utc_timestamp(
        EXPORTING
          iv_timezone  =  lv_tz
        CHANGING
          cv_timestamp = lv_exp_datetime ).

      DATA(lv_locid2) = get_capa_matchkey( iv_assgn_stop_key = <ls_stop>-assgn_stop_key ).
      mv_milestonecnt += 1.

      APPEND VALUE #( appsys            = mo_ef_parameters->get_appsys(  )
                      appobjtype        = mo_ef_parameters->get_app_obj_types( )-aotype
                      language          = sy-langu
                      appobjid          = is_app_objects-appobjid
                      milestone         = zif_gtt_sts_constants=>cs_milestone-fo_unload_end
                      evt_exp_datetime  = |0{ lv_exp_datetime }|
                      evt_exp_tzone     = lv_tz
                      locid1            = <ls_stop>-log_locid
                      locid2            = lv_locid2
                      loctype           = zif_gtt_sts_constants=>cs_location_type-logistic
                      country           = ls_loc_addr->country_code
                      city              = ls_loc_addr->city_name ) TO ct_expeventdata.
      CLEAR: lt_loc_root, ls_loc_root.
    ENDLOOP.

  ENDMETHOD.


  METHOD unload_start.

    DATA: ls_loc_addr TYPE REF TO /bofu/s_addr_postal_addressk,
          lt_loc_root TYPE /scmtms/t_bo_loc_root_k.

    FIELD-SYMBOLS:
      <lt_stop> TYPE /scmtms/t_em_bo_tor_stop,
      <ls_root> TYPE /scmtms/s_em_bo_tor_root.

    ASSIGN is_app_objects-maintabref->* TO <ls_root>.
    IF sy-subrc <> 0.
      RETURN.
    ENDIF.

    DATA(lr_stop) = mo_ef_parameters->get_appl_table( /scmtms/cl_scem_int_c=>sc_table_definition-bo_tor-stop ).
    ASSIGN lr_stop->* TO <lt_stop>.
    IF sy-subrc <> 0.
      RETURN.
    ENDIF.

    LOOP AT <lt_stop> ASSIGNING FIELD-SYMBOL(<ls_stop>) USING KEY parent_seqnum WHERE parent_node_id = <ls_root>-node_id.

      CHECK <ls_stop>-stop_cat = /scmtms/if_common_c=>c_stop_category-inbound AND <ls_stop>-assgn_start IS NOT INITIAL.

      READ TABLE it_loc_addr REFERENCE INTO ls_loc_addr
                                     WITH KEY root_key = <ls_stop>-log_loc_uuid.
      CHECK sy-subrc = 0.

      /scmtms/cl_pln_bo_data=>get_loc_data(
        EXPORTING
          it_key      = VALUE #( ( key = <ls_stop>-log_loc_uuid ) )
        CHANGING
          ct_loc_root = lt_loc_root ).

      READ TABLE lt_loc_root REFERENCE INTO DATA(ls_loc_root)
                                     WITH KEY key COMPONENTS key = <ls_stop>-log_loc_uuid.
      CHECK sy-subrc = 0.

      DATA(lv_tz) = COND tznzone( WHEN ls_loc_root->time_zone_code IS NOT INITIAL
                                  THEN ls_loc_root->time_zone_code
                                  ELSE sy-zonlo ).

      DATA(lv_exp_datetime) = <ls_stop>-assgn_start.

      zcl_gtt_sts_tools=>convert_utc_timestamp(
        EXPORTING
          iv_timezone  =  lv_tz
        CHANGING
          cv_timestamp = lv_exp_datetime ).

      DATA(lv_locid2) = get_capa_matchkey( iv_assgn_stop_key = <ls_stop>-assgn_stop_key ).
      mv_milestonecnt += 1.

      APPEND VALUE #(  appsys            = mo_ef_parameters->get_appsys(  )
                       appobjtype        = mo_ef_parameters->get_app_obj_types( )-aotype
                       language          = sy-langu
                       appobjid          = is_app_objects-appobjid
                       milestone         = zif_gtt_sts_constants=>cs_milestone-fo_unload_start
                       evt_exp_datetime  = |0{ lv_exp_datetime }|
                       evt_exp_tzone     = lv_tz
                       locid1            = <ls_stop>-log_locid
                       locid2            = lv_locid2
                       loctype           = zif_gtt_sts_constants=>cs_location_type-logistic
                       country           = ls_loc_addr->country_code
                       city              = ls_loc_addr->city_name ) TO ct_expeventdata.
      CLEAR: lt_loc_root, ls_loc_root.
    ENDLOOP.

  ENDMETHOD.


  METHOD zif_gtt_sts_pe_filler~get_planned_events.

    DATA lv_counter TYPE /saptrx/seq_num.

    get_data_for_planned_event(
      EXPORTING
        is_app_objects = is_app_objects
      IMPORTING
        et_loc_address = DATA(lt_loc_address) ).

    shp_arrival(
      EXPORTING
        it_loc_addr     = lt_loc_address
        is_app_objects  = is_app_objects
      CHANGING
        ct_expeventdata = ct_expeventdata ).

    unload_start(
      EXPORTING
        it_loc_addr     = lt_loc_address
        is_app_objects  = is_app_objects
      CHANGING
        ct_expeventdata = ct_expeventdata ).

    unload_end(
      EXPORTING
        it_loc_addr     = lt_loc_address
        is_app_objects  = is_app_objects
      CHANGING
        ct_expeventdata = ct_expeventdata ).

    pod(
      EXPORTING
        it_loc_addr     = lt_loc_address
        is_app_objects  = is_app_objects
      CHANGING
        ct_expeventdata = ct_expeventdata ).

    load_start(
      EXPORTING
        it_loc_addr     = lt_loc_address
        is_app_objects  = is_app_objects
      CHANGING
        ct_expeventdata = ct_expeventdata ).

    load_end(
      EXPORTING
        it_loc_addr     = lt_loc_address
        is_app_objects  = is_app_objects
      CHANGING
        ct_expeventdata = ct_expeventdata ).

    shp_departure(
      EXPORTING
        it_loc_addr     = lt_loc_address
        is_app_objects  = is_app_objects
      CHANGING
        ct_expeventdata = ct_expeventdata ).

    SORT ct_expeventdata BY locid2 ASCENDING.

    LOOP AT ct_expeventdata ASSIGNING FIELD-SYMBOL(<ls_expeventdata>)
      GROUP BY <ls_expeventdata>-locid2 ASSIGNING FIELD-SYMBOL(<lt_expeventdata_group>).

      lv_counter = 1.
      DATA(lv_first) = abap_true.
      LOOP AT GROUP <lt_expeventdata_group> ASSIGNING FIELD-SYMBOL(<ls_expeventdata_group>).
        IF lv_counter = 1.
          IF line_exists( ct_expeventdata[ sy-tabix - 1 ] ).
            DATA(ls_previous_line) =  ct_expeventdata[ sy-tabix - 1 ].
            DATA(shp_num_previous) = ls_previous_line-locid2+0(11).
            DATA(shp_num) = <ls_expeventdata_group>-locid2+0(11).
            IF shp_num = shp_num_previous.
              lv_counter = ct_expeventdata[ sy-tabix - 1 ]-milestonenum + 1.
            ENDIF.
          ENDIF.
        ENDIF.
        <ls_expeventdata_group>-milestonenum = lv_counter.
        lv_counter += 1.

      ENDLOOP.
    ENDLOOP.

  ENDMETHOD.
ENDCLASS.
