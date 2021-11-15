class ZCL_GTT_STS_PE_FILLER definition
  public
  create public .

public section.

  interfaces ZIF_GTT_STS_PE_FILLER .

  constants:
    BEGIN OF cs_attribute,
        node_id TYPE string VALUE 'NODE_ID',
      END OF   cs_attribute .

  methods CONSTRUCTOR
    importing
      !IO_EF_PARAMETERS type ref to ZIF_GTT_STS_EF_PARAMETERS .
protected section.

  data MO_EF_PARAMETERS type ref to ZIF_GTT_STS_EF_PARAMETERS .
  data:
    mv_milestonecnt(4) TYPE n .

  methods GET_DATA_FOR_PLANNED_EVENT
    importing
      !IS_APP_OBJECTS type TRXAS_APPOBJ_CTAB_WA
    exporting
      !EV_TOR_ID type /SCMTMS/TOR_ID
      !ET_STOP type /SCMTMS/T_EM_BO_TOR_STOP
      !ET_LOC_ADDRESS type /BOFU/T_ADDR_POSTAL_ADDRESSK
      !ET_STOP_POINTS type ZIF_GTT_STS_EF_TYPES=>TT_STOP_POINTS
    raising
      CX_UDM_MESSAGE .
  methods LOAD_START
    importing
      !IV_TOR_ID type /SCMTMS/TOR_ID optional
      !IT_STOP type /SCMTMS/T_EM_BO_TOR_STOP optional
      !IT_LOC_ADDR type /BOFU/T_ADDR_POSTAL_ADDRESSK
      !IT_STOP_POINTS type ZIF_GTT_STS_EF_TYPES=>TT_STOP_POINTS optional
      !IS_APP_OBJECTS type TRXAS_APPOBJ_CTAB_WA
    changing
      !CT_EXPEVENTDATA type ZIF_GTT_STS_EF_TYPES=>TT_EXPEVENTDATA
    raising
      CX_UDM_MESSAGE .
  methods LOAD_END
    importing
      !IV_TOR_ID type /SCMTMS/TOR_ID optional
      !IT_STOP type /SCMTMS/T_EM_BO_TOR_STOP optional
      !IT_LOC_ADDR type /BOFU/T_ADDR_POSTAL_ADDRESSK
      !IT_STOP_POINTS type ZIF_GTT_STS_EF_TYPES=>TT_STOP_POINTS optional
      !IS_APP_OBJECTS type TRXAS_APPOBJ_CTAB_WA
    changing
      !CT_EXPEVENTDATA type ZIF_GTT_STS_EF_TYPES=>TT_EXPEVENTDATA
    raising
      CX_UDM_MESSAGE .
  methods COUPLING
    importing
      !IV_TOR_ID type /SCMTMS/TOR_ID
      !IT_STOP type /SCMTMS/T_EM_BO_TOR_STOP
      !IT_LOC_ADDR type /BOFU/T_ADDR_POSTAL_ADDRESSK
      !IT_STOP_POINTS type ZIF_GTT_STS_EF_TYPES=>TT_STOP_POINTS
      !IS_APP_OBJECTS type TRXAS_APPOBJ_CTAB_WA
    changing
      !CT_EXPEVENTDATA type ZIF_GTT_STS_EF_TYPES=>TT_EXPEVENTDATA
    raising
      CX_UDM_MESSAGE .
  methods DECOUPLING
    importing
      !IV_TOR_ID type /SCMTMS/TOR_ID
      !IT_STOP type /SCMTMS/T_EM_BO_TOR_STOP
      !IT_LOC_ADDR type /BOFU/T_ADDR_POSTAL_ADDRESSK
      !IT_STOP_POINTS type ZIF_GTT_STS_EF_TYPES=>TT_STOP_POINTS
      !IS_APP_OBJECTS type TRXAS_APPOBJ_CTAB_WA
    changing
      !CT_EXPEVENTDATA type ZIF_GTT_STS_EF_TYPES=>TT_EXPEVENTDATA
    raising
      CX_UDM_MESSAGE .
  methods UNLOAD_START
    importing
      !IV_TOR_ID type /SCMTMS/TOR_ID optional
      !IT_STOP type /SCMTMS/T_EM_BO_TOR_STOP optional
      !IT_LOC_ADDR type /BOFU/T_ADDR_POSTAL_ADDRESSK
      !IT_STOP_POINTS type ZIF_GTT_STS_EF_TYPES=>TT_STOP_POINTS optional
      !IS_APP_OBJECTS type TRXAS_APPOBJ_CTAB_WA
    changing
      !CT_EXPEVENTDATA type ZIF_GTT_STS_EF_TYPES=>TT_EXPEVENTDATA
    raising
      CX_UDM_MESSAGE .
  methods UNLOAD_END
    importing
      !IV_TOR_ID type /SCMTMS/TOR_ID optional
      !IT_STOP type /SCMTMS/T_EM_BO_TOR_STOP optional
      !IT_LOC_ADDR type /BOFU/T_ADDR_POSTAL_ADDRESSK
      !IT_STOP_POINTS type ZIF_GTT_STS_EF_TYPES=>TT_STOP_POINTS optional
      !IS_APP_OBJECTS type TRXAS_APPOBJ_CTAB_WA
    changing
      !CT_EXPEVENTDATA type ZIF_GTT_STS_EF_TYPES=>TT_EXPEVENTDATA
    raising
      CX_UDM_MESSAGE .
  methods SHP_ARRIVAL
    importing
      !IV_TOR_ID type /SCMTMS/TOR_ID optional
      !IT_STOP type /SCMTMS/T_EM_BO_TOR_STOP optional
      !IT_LOC_ADDR type /BOFU/T_ADDR_POSTAL_ADDRESSK
      !IT_STOP_POINTS type ZIF_GTT_STS_EF_TYPES=>TT_STOP_POINTS optional
      !IS_APP_OBJECTS type TRXAS_APPOBJ_CTAB_WA
    changing
      !CT_EXPEVENTDATA type ZIF_GTT_STS_EF_TYPES=>TT_EXPEVENTDATA
    raising
      CX_UDM_MESSAGE .
  methods SHP_DEPARTURE
    importing
      !IV_TOR_ID type /SCMTMS/TOR_ID optional
      !IT_STOP type /SCMTMS/T_EM_BO_TOR_STOP optional
      !IT_LOC_ADDR type /BOFU/T_ADDR_POSTAL_ADDRESSK
      !IT_STOP_POINTS type ZIF_GTT_STS_EF_TYPES=>TT_STOP_POINTS optional
      !IS_APP_OBJECTS type TRXAS_APPOBJ_CTAB_WA
    changing
      !CT_EXPEVENTDATA type ZIF_GTT_STS_EF_TYPES=>TT_EXPEVENTDATA
    raising
      CX_UDM_MESSAGE .
  methods POD
    importing
      !IV_TOR_ID type /SCMTMS/TOR_ID optional
      !IT_STOP type /SCMTMS/T_EM_BO_TOR_STOP optional
      !IT_LOC_ADDR type /BOFU/T_ADDR_POSTAL_ADDRESSK
      !IT_STOP_POINTS type ZIF_GTT_STS_EF_TYPES=>TT_STOP_POINTS optional
      !IS_APP_OBJECTS type TRXAS_APPOBJ_CTAB_WA
    changing
      !CT_EXPEVENTDATA type ZIF_GTT_STS_EF_TYPES=>TT_EXPEVENTDATA
    raising
      CX_UDM_MESSAGE .
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_GTT_STS_PE_FILLER IMPLEMENTATION.


  METHOD constructor.

    mo_ef_parameters = io_ef_parameters.
    mv_milestonecnt  = 0.

  ENDMETHOD.


  METHOD coupling.

    DATA: ls_loc_addr TYPE REF TO /bofu/s_addr_postal_addressk,
          lt_loc_root TYPE /scmtms/t_bo_loc_root_k.

    FIELD-SYMBOLS <ls_root> TYPE /scmtms/s_em_bo_tor_root.

    ASSIGN is_app_objects-maintabref->* TO <ls_root>.
    IF sy-subrc <> 0.
      RETURN.
    ENDIF.

    LOOP AT it_stop USING KEY parent_seqnum ASSIGNING FIELD-SYMBOL(<ls_stop>) WHERE parent_node_id = <ls_root>-node_id.
      CHECK <ls_stop>-stop_cat = /scmtms/if_common_c=>c_stop_category-outbound AND
            <ls_stop>-aggr_assgn_start_c IS NOT INITIAL AND
            <ls_stop>-aggr_assgn_end_c   IS NOT INITIAL.

      READ TABLE it_stop_points REFERENCE INTO DATA(ls_stop_points)
                                     WITH KEY log_locid = <ls_stop>-log_locid
                                              seq_num   = <ls_stop>-seq_num.
      CHECK sy-subrc = 0.

*      READ TABLE it_loc_addr REFERENCE INTO ls_loc_addr
*                                     WITH KEY root_key = <ls_stop>-log_loc_uuid.
*      CHECK sy-subrc = 0.
      TEST-SEAM coupling_lt_loc_root.
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

      DATA(lv_exp_datetime)    = <ls_stop>-aggr_assgn_end_c.
      DATA(lv_er_exp_datetime) = <ls_stop>-aggr_assgn_start_c.

      zcl_gtt_sts_tools=>convert_utc_timestamp(
        EXPORTING
          iv_timezone  =  lv_tz
        CHANGING
          cv_timestamp = lv_exp_datetime ).

      zcl_gtt_sts_tools=>convert_utc_timestamp(
      EXPORTING
        iv_timezone  =  lv_tz
      CHANGING
        cv_timestamp = lv_er_exp_datetime ).

      mv_milestonecnt += 1.
      APPEND VALUE #(
      appsys               = mo_ef_parameters->get_appsys(  )
      appobjtype           = mo_ef_parameters->get_app_obj_types( )-aotype
      language             = sy-langu
      appobjid             = is_app_objects-appobjid
      milestone            = zif_gtt_sts_constants=>cs_milestone-fo_coupling
      evt_exp_datetime     = |0{ lv_exp_datetime }|
      evt_er_exp_dtime     = |0{ lv_er_exp_datetime }|
      evt_exp_tzone        = lv_tz
      locid1               = <ls_stop>-log_locid
      locid2               = ls_stop_points->stop_id
      loctype              = zcl_gtt_sts_tools=>get_location_type( iv_locno = <ls_stop>-log_locid ) ) TO ct_expeventdata.
*      country              = ls_loc_addr->country_code
*      city                 = ls_loc_addr->city_name ) TO ct_expeventdata.

      CLEAR: lt_loc_root, ls_loc_root.
    ENDLOOP.

  ENDMETHOD.


  METHOD decoupling.

    DATA: ls_loc_addr TYPE REF TO /bofu/s_addr_postal_addressk,
          lt_loc_root TYPE /scmtms/t_bo_loc_root_k.

    FIELD-SYMBOLS <ls_root> TYPE /scmtms/s_em_bo_tor_root.

    ASSIGN is_app_objects-maintabref->* TO <ls_root>.
    IF sy-subrc <> 0.
      RETURN.
    ENDIF.

    LOOP AT it_stop USING KEY parent_seqnum ASSIGNING FIELD-SYMBOL(<ls_stop>) WHERE parent_node_id = <ls_root>-node_id.
      CHECK <ls_stop>-stop_cat = /scmtms/if_common_c=>c_stop_category-inbound AND
            <ls_stop>-aggr_assgn_start_c IS NOT INITIAL AND
            <ls_stop>-aggr_assgn_end_c   IS NOT INITIAL.

      READ TABLE it_stop_points REFERENCE INTO DATA(ls_stop_points)
                                     WITH KEY log_locid = <ls_stop>-log_locid
                                              seq_num   = <ls_stop>-seq_num.
      CHECK sy-subrc = 0.

*      READ TABLE it_loc_addr REFERENCE INTO ls_loc_addr
*                                     WITH KEY root_key = <ls_stop>-log_loc_uuid.
*
*      CHECK sy-subrc = 0.
      TEST-SEAM decoupling_lt_loc_root.
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

      DATA(lv_exp_datetime)    = <ls_stop>-aggr_assgn_end_c.
      DATA(lv_er_exp_datetime) = <ls_stop>-aggr_assgn_start_c.

      zcl_gtt_sts_tools=>convert_utc_timestamp(
        EXPORTING
          iv_timezone  =  lv_tz
        CHANGING
          cv_timestamp = lv_exp_datetime ).

      zcl_gtt_sts_tools=>convert_utc_timestamp(
      EXPORTING
        iv_timezone  =  lv_tz
      CHANGING
        cv_timestamp = lv_er_exp_datetime ).

      mv_milestonecnt += 1.
      APPEND VALUE #(
      appsys               = mo_ef_parameters->get_appsys(  )
      appobjtype           = mo_ef_parameters->get_app_obj_types( )-aotype
      language             = sy-langu
      appobjid             = is_app_objects-appobjid
      milestone            = zif_gtt_sts_constants=>cs_milestone-fo_decoupling
      evt_exp_datetime     = |0{ lv_exp_datetime }|
      evt_er_exp_dtime     = |0{ lv_er_exp_datetime }|
      evt_exp_tzone        = lv_tz
      locid1               = <ls_stop>-log_locid
      locid2               = ls_stop_points->stop_id
      loctype              = zcl_gtt_sts_tools=>get_location_type( iv_locno = <ls_stop>-log_locid ) ) TO ct_expeventdata.
*      country              = ls_loc_addr->country_code
*      city                 = ls_loc_addr->city_name ) TO ct_expeventdata.

      CLEAR: lt_loc_root, ls_loc_root.
    ENDLOOP.

  ENDMETHOD.


  METHOD get_data_for_planned_event.

    DATA: lv_tor_node_id    TYPE /scmtms/bo_node_id.

    ev_tor_id = zcl_gtt_sts_tools=>get_field_of_structure(
                               ir_struct_data = is_app_objects-maintabref
                               iv_field_name  = /scmtms/if_tor_c=>sc_node_attribute-root-tor_id ).
    SHIFT ev_tor_id LEFT DELETING LEADING '0'.

    lv_tor_node_id = zcl_gtt_sts_tools=>get_field_of_structure(
                                          ir_struct_data = is_app_objects-maintabref
                                          iv_field_name  = cs_attribute-node_id ).

    IF et_stop IS SUPPLIED.
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
    ENDIF.

    IF et_loc_address IS SUPPLIED.
      TEST-SEAM et_loc_addres.
        zcl_gtt_sts_tools=>get_postal_address(
          EXPORTING
            iv_node_id        = lv_tor_node_id
          IMPORTING
            et_postal_address = et_loc_address ).
      END-TEST-SEAM.
    ENDIF.

    IF et_stop_points IS SUPPLIED.
      zcl_gtt_sts_tools=>get_stop_points(
        EXPORTING
          iv_root_id     = ev_tor_id
          it_stop        = et_stop
        IMPORTING
          et_stop_points = et_stop_points ).
    ENDIF.

  ENDMETHOD.


  METHOD load_end.

    DATA: ls_loc_addr TYPE REF TO /bofu/s_addr_postal_addressk,
          lt_loc_root TYPE /scmtms/t_bo_loc_root_k.

    FIELD-SYMBOLS <ls_root> TYPE /scmtms/s_em_bo_tor_root.

    ASSIGN is_app_objects-maintabref->* TO <ls_root>.
    IF sy-subrc <> 0.
      RETURN.
    ENDIF.

    LOOP AT it_stop USING KEY parent_seqnum ASSIGNING FIELD-SYMBOL(<ls_stop>) WHERE parent_node_id = <ls_root>-node_id.
      CHECK <ls_stop>-stop_cat = /scmtms/if_common_c=>c_stop_category-outbound AND
            <ls_stop>-aggr_assgn_start_l IS NOT INITIAL AND
            <ls_stop>-aggr_assgn_end_l   IS NOT INITIAL.

      READ TABLE it_stop_points REFERENCE INTO DATA(ls_stop_points) WITH KEY log_locid = <ls_stop>-log_locid
                                                                             seq_num   = <ls_stop>-seq_num.
      CHECK sy-subrc = 0.

*      READ TABLE it_loc_addr REFERENCE INTO ls_loc_addr WITH KEY root_key = <ls_stop>-log_loc_uuid.
*      CHECK sy-subrc = 0.

      TEST-SEAM load_end_lt_loc_root.
        /scmtms/cl_pln_bo_data=>get_loc_data(
          EXPORTING
            it_key      = VALUE #( ( key = <ls_stop>-log_loc_uuid ) )
          CHANGING
            ct_loc_root = lt_loc_root ).
      END-TEST-SEAM.

      READ TABLE lt_loc_root REFERENCE INTO DATA(ls_loc_root) WITH KEY key COMPONENTS key = <ls_stop>-log_loc_uuid.
      CHECK sy-subrc = 0.

      DATA(lv_tz) = COND tznzone( WHEN ls_loc_root->time_zone_code IS NOT INITIAL THEN ls_loc_root->time_zone_code
                                  ELSE sy-zonlo ).

      DATA(lv_exp_datetime) = <ls_stop>-aggr_assgn_end_l.

      zcl_gtt_sts_tools=>convert_utc_timestamp(
        EXPORTING
          iv_timezone  =  lv_tz
        CHANGING
          cv_timestamp = lv_exp_datetime ).

      mv_milestonecnt += 1.
      APPEND VALUE #(
        appsys           = mo_ef_parameters->get_appsys(  )
        appobjtype       = mo_ef_parameters->get_app_obj_types( )-aotype
        language         = sy-langu
        appobjid         = is_app_objects-appobjid
        milestone        = zif_gtt_sts_constants=>cs_milestone-fo_load_end
        evt_exp_datetime = |0{ lv_exp_datetime }|
        evt_exp_tzone    = lv_tz
        locid1           = <ls_stop>-log_locid
        locid2           = ls_stop_points->stop_id
        loctype          = zcl_gtt_sts_tools=>get_location_type( iv_locno = <ls_stop>-log_locid )
*        country          = ls_loc_addr->country_code
*        city             = ls_loc_addr->city_name
        itemident        = <ls_stop>-node_id ) TO ct_expeventdata.

      CLEAR: lt_loc_root, ls_loc_root.
    ENDLOOP.

  ENDMETHOD.


  METHOD load_start.

    DATA: ls_loc_addr TYPE REF TO /bofu/s_addr_postal_addressk,
          lt_loc_root TYPE /scmtms/t_bo_loc_root_k.

    FIELD-SYMBOLS <ls_root> TYPE /scmtms/s_em_bo_tor_root.

    ASSIGN is_app_objects-maintabref->* TO <ls_root>.
    IF sy-subrc <> 0.
      RETURN.
    ENDIF.

    LOOP AT it_stop USING KEY parent_seqnum ASSIGNING FIELD-SYMBOL(<ls_stop>) WHERE parent_node_id = <ls_root>-node_id.
      CHECK <ls_stop>-stop_cat = /scmtms/if_common_c=>c_stop_category-outbound AND
            <ls_stop>-aggr_assgn_start_l IS NOT INITIAL AND
            <ls_stop>-aggr_assgn_end_l   IS NOT INITIAL.

      READ TABLE it_stop_points REFERENCE INTO DATA(ls_stop_points)
                                     WITH KEY log_locid = <ls_stop>-log_locid
                                              seq_num   = <ls_stop>-seq_num.
      CHECK sy-subrc = 0.

*      READ TABLE it_loc_addr REFERENCE INTO ls_loc_addr
*                                     WITH KEY root_key = <ls_stop>-log_loc_uuid.
*
*      CHECK sy-subrc = 0.
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

      DATA(lv_exp_datetime) = <ls_stop>-aggr_assgn_start_l.

      zcl_gtt_sts_tools=>convert_utc_timestamp(
        EXPORTING
          iv_timezone  =  lv_tz
        CHANGING
          cv_timestamp = lv_exp_datetime ).

      mv_milestonecnt += 1.
      APPEND VALUE #(
      appsys            = mo_ef_parameters->get_appsys(  )
      appobjtype        = mo_ef_parameters->get_app_obj_types( )-aotype
      language          = sy-langu
      appobjid          = is_app_objects-appobjid
      milestone         = zif_gtt_sts_constants=>cs_milestone-fo_load_start
      evt_exp_datetime  = |0{ lv_exp_datetime }|
      evt_exp_tzone     = lv_tz
      locid1            = <ls_stop>-log_locid
      locid2            = ls_stop_points->stop_id
      loctype           = zcl_gtt_sts_tools=>get_location_type( iv_locno = <ls_stop>-log_locid ) ) TO ct_expeventdata.
*      country           = ls_loc_addr->country_code
*      city              = ls_loc_addr->city_name ) TO ct_expeventdata.

      CLEAR: lt_loc_root, ls_loc_root.
    ENDLOOP.

  ENDMETHOD.


  METHOD pod.

    DATA: ls_loc_addr TYPE REF TO /bofu/s_addr_postal_addressk,
          lt_loc_root TYPE /scmtms/t_bo_loc_root_k.

    FIELD-SYMBOLS <ls_root> TYPE /scmtms/s_em_bo_tor_root.

    ASSIGN is_app_objects-maintabref->* TO <ls_root>.
    IF sy-subrc <> 0.
      RETURN.
    ENDIF.

    LOOP AT it_stop USING KEY parent_seqnum ASSIGNING FIELD-SYMBOL(<ls_stop>) WHERE parent_node_id = <ls_root>-node_id.
      CHECK <ls_stop>-stop_cat = /scmtms/if_common_c=>c_stop_category-inbound AND
            <ls_stop>-aggr_assgn_start_l IS NOT INITIAL AND
            <ls_stop>-aggr_assgn_end_l   IS NOT INITIAL.

      READ TABLE it_stop_points REFERENCE INTO DATA(ls_stop_points) WITH KEY log_locid = <ls_stop>-log_locid
                                                                             seq_num   = <ls_stop>-seq_num.
      CHECK sy-subrc = 0.

*      READ TABLE it_loc_addr REFERENCE INTO ls_loc_addr WITH KEY root_key = <ls_stop>-log_loc_uuid.
*      CHECK sy-subrc = 0.

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

      DATA(lv_exp_datetime) = <ls_stop>-aggr_assgn_end_l.

      zcl_gtt_sts_tools=>convert_utc_timestamp(
        EXPORTING
          iv_timezone  = lv_tz
        CHANGING
          cv_timestamp = lv_exp_datetime ).

      mv_milestonecnt += 1.
      APPEND VALUE #(
        appsys           = mo_ef_parameters->get_appsys(  )
        appobjtype       = mo_ef_parameters->get_app_obj_types( )-aotype
        language         = sy-langu
        appobjid         = is_app_objects-appobjid
        milestone        = zif_gtt_sts_constants=>cs_milestone-fo_shp_pod
        evt_exp_datetime = |0{ lv_exp_datetime }|
        evt_exp_tzone    = lv_tz
        locid1           = <ls_stop>-log_locid
        locid2           = ls_stop_points->stop_id
        loctype          = zcl_gtt_sts_tools=>get_location_type( iv_locno = <ls_stop>-log_locid ) ) TO ct_expeventdata.
*        country          = ls_loc_addr->country_code
*        city             = ls_loc_addr->city_name ) TO ct_expeventdata.

      CLEAR: lt_loc_root, ls_loc_root.
    ENDLOOP.

  ENDMETHOD.


  METHOD shp_arrival.

    DATA: ls_loc_addr TYPE REF TO /bofu/s_addr_postal_addressk,
          lt_loc_root TYPE /scmtms/t_bo_loc_root_k.

    FIELD-SYMBOLS <ls_root> TYPE /scmtms/s_em_bo_tor_root.

    ASSIGN is_app_objects-maintabref->* TO <ls_root>.
    IF sy-subrc <> 0.
      RETURN.
    ENDIF.

    LOOP AT it_stop USING KEY parent_seqnum ASSIGNING FIELD-SYMBOL(<ls_stop>) WHERE parent_node_id = <ls_root>-node_id.
      CHECK <ls_stop>-stop_cat = /scmtms/if_common_c=>c_stop_category-inbound AND
            <ls_stop>-plan_trans_time IS NOT INITIAL.

      READ TABLE it_stop_points REFERENCE INTO DATA(ls_stop_points)
                                     WITH KEY log_locid = <ls_stop>-log_locid
                                              seq_num   = <ls_stop>-seq_num.
      CHECK sy-subrc = 0.

*      READ TABLE it_loc_addr REFERENCE INTO ls_loc_addr
*                                     WITH KEY root_key = <ls_stop>-log_loc_uuid.
*      CHECK sy-subrc = 0.

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

      DATA(lv_exp_datetime) = <ls_stop>-plan_trans_time.

      zcl_gtt_sts_tools=>convert_utc_timestamp(
        EXPORTING
          iv_timezone  =  lv_tz
        CHANGING
          cv_timestamp = lv_exp_datetime ).

      mv_milestonecnt += 1.
      APPEND VALUE #(
      appsys            = mo_ef_parameters->get_appsys(  )
      appobjtype        = mo_ef_parameters->get_app_obj_types( )-aotype
      language          = sy-langu
      appobjid          = is_app_objects-appobjid
      milestone         = zif_gtt_sts_constants=>cs_milestone-fo_shp_arrival
      evt_exp_datetime  = |0{ lv_exp_datetime }|
      evt_exp_tzone     = lv_tz
      locid1            = <ls_stop>-log_locid
      locid2            = ls_stop_points->stop_id
      loctype           = zcl_gtt_sts_tools=>get_location_type( iv_locno = <ls_stop>-log_locid ) ) TO ct_expeventdata.
*      country           = ls_loc_addr->country_code
*      city              = ls_loc_addr->city_name ) TO ct_expeventdata.

      CLEAR: lt_loc_root, ls_loc_root.
    ENDLOOP.

  ENDMETHOD.


  METHOD shp_departure.

    DATA: ls_loc_addr TYPE REF TO /bofu/s_addr_postal_addressk,
          lt_loc_root TYPE /scmtms/t_bo_loc_root_k.

    FIELD-SYMBOLS <ls_root> TYPE /scmtms/s_em_bo_tor_root.

    ASSIGN is_app_objects-maintabref->* TO <ls_root>.
    IF sy-subrc <> 0.
      RETURN.
    ENDIF.

    LOOP AT it_stop USING KEY parent_seqnum ASSIGNING FIELD-SYMBOL(<ls_stop>) WHERE parent_node_id = <ls_root>-node_id.
      CHECK <ls_stop>-stop_cat = /scmtms/if_common_c=>c_stop_category-outbound AND
            <ls_stop>-plan_trans_time IS NOT INITIAL.

      READ TABLE it_stop_points REFERENCE INTO DATA(ls_stop_points)
                                     WITH KEY log_locid = <ls_stop>-log_locid
                                              seq_num   = <ls_stop>-seq_num.
      CHECK sy-subrc = 0.

*      READ TABLE it_loc_addr REFERENCE INTO ls_loc_addr
*                                     WITH KEY root_key = <ls_stop>-log_loc_uuid.
*
*      CHECK sy-subrc = 0.
      TEST-SEAM shp_dep_lt_loc_root.
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

      DATA(lv_exp_datetime) = <ls_stop>-plan_trans_time.

      zcl_gtt_sts_tools=>convert_utc_timestamp(
        EXPORTING
          iv_timezone  =  lv_tz
        CHANGING
          cv_timestamp = lv_exp_datetime ).

      mv_milestonecnt += 1.
      APPEND VALUE #(
      appsys            = mo_ef_parameters->get_appsys(  )
      appobjtype        = mo_ef_parameters->get_app_obj_types( )-aotype
      language          = sy-langu
      appobjid          = is_app_objects-appobjid
      milestone         = zif_gtt_sts_constants=>cs_milestone-fo_shp_departure
      evt_exp_datetime  = |0{ lv_exp_datetime }|
      evt_exp_tzone     = lv_tz
      locid1            = <ls_stop>-log_locid
      locid2            = ls_stop_points->stop_id
      loctype           = zcl_gtt_sts_tools=>get_location_type( iv_locno = <ls_stop>-log_locid ) ) TO ct_expeventdata.
*      country           = ls_loc_addr->country_code
*      city              = ls_loc_addr->city_name ) TO ct_expeventdata.

      CLEAR: lt_loc_root, ls_loc_root.
    ENDLOOP.

  ENDMETHOD.


  METHOD unload_end.

    DATA: ls_loc_addr TYPE REF TO /bofu/s_addr_postal_addressk,
          lt_loc_root TYPE /scmtms/t_bo_loc_root_k.

    FIELD-SYMBOLS <ls_root> TYPE /scmtms/s_em_bo_tor_root.

    ASSIGN is_app_objects-maintabref->* TO <ls_root>.
    IF sy-subrc <> 0.
      RETURN.
    ENDIF.

    LOOP AT it_stop USING KEY parent_seqnum ASSIGNING FIELD-SYMBOL(<ls_stop>) WHERE parent_node_id = <ls_root>-node_id.
      CHECK  <ls_stop>-stop_cat = /scmtms/if_common_c=>c_stop_category-inbound AND
             <ls_stop>-aggr_assgn_start_l IS NOT INITIAL AND
             <ls_stop>-aggr_assgn_end_l   IS NOT INITIAL.

      READ TABLE it_stop_points REFERENCE INTO DATA(ls_stop_points)
                                     WITH KEY log_locid = <ls_stop>-log_locid
                                              seq_num   = <ls_stop>-seq_num.
      CHECK sy-subrc = 0.

*      READ TABLE it_loc_addr REFERENCE INTO ls_loc_addr
*                                     WITH KEY root_key = <ls_stop>-log_loc_uuid.
*      CHECK sy-subrc = 0.

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

      DATA(lv_exp_datetime) = <ls_stop>-aggr_assgn_end_l.

      zcl_gtt_sts_tools=>convert_utc_timestamp(
        EXPORTING
          iv_timezone  =  lv_tz
        CHANGING
          cv_timestamp = lv_exp_datetime ).

      mv_milestonecnt += 1.
      APPEND VALUE #(
      appsys            = mo_ef_parameters->get_appsys(  )
      appobjtype        = mo_ef_parameters->get_app_obj_types( )-aotype
      language          = sy-langu
      appobjid          = is_app_objects-appobjid
      milestone         = zif_gtt_sts_constants=>cs_milestone-fo_unload_end
      evt_exp_datetime  = |0{ lv_exp_datetime }|
      evt_exp_tzone     = lv_tz
      locid1            = <ls_stop>-log_locid
      locid2            = ls_stop_points->stop_id
      loctype           = zcl_gtt_sts_tools=>get_location_type( iv_locno = <ls_stop>-log_locid ) ) TO ct_expeventdata.
*      country           = ls_loc_addr->country_code
*      city              = ls_loc_addr->city_name ) TO ct_expeventdata.

      CLEAR: lt_loc_root, ls_loc_root.
    ENDLOOP.

  ENDMETHOD.


  METHOD unload_start.

    DATA: ls_loc_addr TYPE REF TO /bofu/s_addr_postal_addressk,
          lt_loc_root TYPE /scmtms/t_bo_loc_root_k.

    FIELD-SYMBOLS <ls_root> TYPE /scmtms/s_em_bo_tor_root.

    ASSIGN is_app_objects-maintabref->* TO <ls_root>.
    IF sy-subrc <> 0.
      RETURN.
    ENDIF.

    LOOP AT it_stop USING KEY parent_seqnum ASSIGNING FIELD-SYMBOL(<ls_stop>) WHERE parent_node_id = <ls_root>-node_id.
      CHECK <ls_stop>-stop_cat = /scmtms/if_common_c=>c_stop_category-inbound AND
            <ls_stop>-aggr_assgn_start_l IS NOT INITIAL AND
            <ls_stop>-aggr_assgn_end_l   IS NOT INITIAL.

      READ TABLE it_stop_points REFERENCE INTO DATA(ls_stop_points)
                                     WITH KEY log_locid = <ls_stop>-log_locid
                                              seq_num   = <ls_stop>-seq_num.
      CHECK sy-subrc = 0.

*      READ TABLE it_loc_addr REFERENCE INTO ls_loc_addr
*                                     WITH KEY root_key = <ls_stop>-log_loc_uuid.
*      CHECK sy-subrc = 0.
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

      DATA(lv_exp_datetime) = <ls_stop>-aggr_assgn_start_l.

      zcl_gtt_sts_tools=>convert_utc_timestamp(
        EXPORTING
          iv_timezone  =  lv_tz
        CHANGING
          cv_timestamp = lv_exp_datetime ).

      mv_milestonecnt += 1.
      APPEND VALUE #(
      appsys            = mo_ef_parameters->get_appsys(  )
      appobjtype        = mo_ef_parameters->get_app_obj_types( )-aotype
      language          = sy-langu
      appobjid          = is_app_objects-appobjid
      milestone         = zif_gtt_sts_constants=>cs_milestone-fo_unload_start
      evt_exp_datetime  = |0{ lv_exp_datetime }|
      evt_exp_tzone     = lv_tz
      locid1            = <ls_stop>-log_locid
      locid2            = ls_stop_points->stop_id
      loctype           = zcl_gtt_sts_tools=>get_location_type( iv_locno = <ls_stop>-log_locid ) ) TO ct_expeventdata.
*      country           = ls_loc_addr->country_code
*      city              = ls_loc_addr->city_name ) TO ct_expeventdata.

      CLEAR: lt_loc_root, ls_loc_root.
    ENDLOOP.

  ENDMETHOD.


  METHOD zif_gtt_sts_pe_filler~get_planned_events.

    RETURN.

  ENDMETHOD.
ENDCLASS.
