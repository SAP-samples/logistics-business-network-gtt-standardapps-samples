CLASS zcl_gtt_mia_pe_filler_shh DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES zif_gtt_mia_pe_filler .

    METHODS constructor
      IMPORTING
        !io_ef_parameters TYPE REF TO zif_gtt_mia_ef_parameters
        !io_bo_reader     TYPE REF TO zif_gtt_mia_tp_reader
      RAISING
        cx_udm_message .
  PROTECTED SECTION.
private section.

  types:
    tt_vbeln    TYPE RANGE OF lips-vbeln .
  types:
    tt_werks    TYPE RANGE OF lips-werks .
  types:
    tt_appobjid TYPE RANGE OF /saptrx/aoid .

  data MO_EF_PARAMETERS type ref to ZIF_GTT_MIA_EF_PARAMETERS .
  data MO_BO_READER type ref to ZIF_GTT_MIA_TP_READER .
  data MO_SH_DATA_OLD type ref to ZCL_GTT_MIA_SH_DATA_OLD .

  methods ADD_SHIPMENT_EVENTS
    importing
      !IS_APP_OBJECTS type TRXAS_APPOBJ_CTAB_WA
    changing
      !CT_EXPEVENTDATA type ZIF_GTT_MIA_EF_TYPES=>TT_EXPEVENTDATA
      !CT_MEASRMNTDATA type ZIF_GTT_MIA_EF_TYPES=>TT_MEASRMNTDATA
      !CT_INFODATA type ZIF_GTT_MIA_EF_TYPES=>TT_INFODATA
    raising
      CX_UDM_MESSAGE .
  methods ADD_STOPS_EVENTS
    importing
      !IS_APP_OBJECTS type TRXAS_APPOBJ_CTAB_WA
      !IV_MILESTONENUM type /SAPTRX/SEQ_NUM
    changing
      !CT_EXPEVENTDATA type ZIF_GTT_MIA_EF_TYPES=>TT_EXPEVENTDATA
      !CT_MEASRMNTDATA type ZIF_GTT_MIA_EF_TYPES=>TT_MEASRMNTDATA
      !CT_INFODATA type ZIF_GTT_MIA_EF_TYPES=>TT_INFODATA
    raising
      CX_UDM_MESSAGE .
  methods GET_SHIPPMENT_HEADER
    importing
      !IS_APP_OBJECT type TRXAS_APPOBJ_CTAB_WA
      !IR_VTTK type ref to DATA
    returning
      value(RR_VTTK) type ref to DATA
    raising
      CX_UDM_MESSAGE .
  methods IS_POD_RELEVANT
    importing
      !IS_STOPS type ZIF_GTT_MIA_APP_TYPES=>TS_STOPS
      !IT_VTTP type VTTPVB_TAB
      !IT_VTSP type VTSPVB_TAB
    returning
      value(RV_RESULT) type ABAP_BOOL
    raising
      CX_UDM_MESSAGE .
  methods IS_STOP_CHANGED
    importing
      !IS_APP_OBJECT type TRXAS_APPOBJ_CTAB_WA
      !IT_FIELDS type ZIF_GTT_MIA_EF_TYPES=>TT_FIELD_NAME
    returning
      value(RV_RESULT) type ZIF_GTT_MIA_EF_TYPES=>TV_CONDITION
    raising
      CX_UDM_MESSAGE .
  methods GET_CORRESPONDING_DLV_ITEMS
    importing
      !IT_VBELN type TT_VBELN
      !IT_WERKS type TT_WERKS
    exporting
      !ET_APPOBJID type TT_APPOBJID
    raising
      CX_UDM_MESSAGE .
  methods GET_HEADER_FIELDS
    exporting
      !ET_FIELDS type ZIF_GTT_MIA_EF_TYPES=>TT_FIELD_NAME .
  methods GET_STOP_FIELDS
    exporting
      !ET_FIELDS type ZIF_GTT_MIA_EF_TYPES=>TT_FIELD_NAME .
  methods CHK_POD_RELEVANT_FOR_ODLV
    importing
      !IS_STOPS type ZIF_GTT_MIA_APP_TYPES=>TS_STOPS
      !IT_VTTP type VTTPVB_TAB
      !IT_VTSP type VTSPVB_TAB
    returning
      value(RV_RESULT) type ABAP_BOOL
    raising
      CX_UDM_MESSAGE .
ENDCLASS.



CLASS ZCL_GTT_MIA_PE_FILLER_SHH IMPLEMENTATION.


  METHOD add_shipment_events.

    FIELD-SYMBOLS: <ls_vttk>  TYPE vttkvb.

    ASSIGN is_app_objects-maintabref->* TO <ls_vttk>.

    IF <ls_vttk> IS ASSIGNED.
      " CHECK IN
      ct_expeventdata = VALUE #( BASE ct_expeventdata (
        appsys            = mo_ef_parameters->get_appsys(  )
        appobjtype        = mo_ef_parameters->get_app_obj_types( )-aotype
        language          = sy-langu
        appobjid          = is_app_objects-appobjid
        milestone         = zif_gtt_mia_app_constants=>cs_milestone-sh_check_in
        evt_exp_datetime  = zcl_gtt_mia_tools=>get_local_timestamp(
                              iv_date = <ls_vttk>-dpreg
                              iv_time = <ls_vttk>-upreg )
        evt_exp_tzone     = zcl_gtt_mia_tools=>get_system_time_zone( )
        milestonenum      = 1
      ) ).

      " LOAD START
      ct_expeventdata = VALUE #( BASE ct_expeventdata (
        appsys            = mo_ef_parameters->get_appsys(  )
        appobjtype        = mo_ef_parameters->get_app_obj_types( )-aotype
        language          = sy-langu
        appobjid          = is_app_objects-appobjid
        milestone         = zif_gtt_mia_app_constants=>cs_milestone-sh_load_start
        evt_exp_datetime  = zcl_gtt_mia_tools=>get_local_timestamp(
                              iv_date = <ls_vttk>-dplbg
                              iv_time = <ls_vttk>-uplbg )
        evt_exp_tzone     = zcl_gtt_mia_tools=>get_system_time_zone( )
        milestonenum      = 2
      ) ).

      " LOAD END
      ct_expeventdata = VALUE #( BASE ct_expeventdata (
        appsys            = mo_ef_parameters->get_appsys(  )
        appobjtype        = mo_ef_parameters->get_app_obj_types( )-aotype
        language          = sy-langu
        appobjid          = is_app_objects-appobjid
        milestone         = zif_gtt_mia_app_constants=>cs_milestone-sh_load_end
        evt_exp_datetime  = zcl_gtt_mia_tools=>get_local_timestamp(
                              iv_date = <ls_vttk>-dplen
                              iv_time = <ls_vttk>-uplen )
        evt_exp_tzone     = zcl_gtt_mia_tools=>get_system_time_zone( )
        milestonenum      = 3
      ) ).
    ENDIF.

  ENDMETHOD.


  METHOD add_stops_events.

    DATA(lv_tknum)        = CONV tknum( zcl_gtt_mia_tools=>get_field_of_structure(
                                          ir_struct_data = is_app_objects-maintabref
                                          iv_field_name  = 'TKNUM' ) ).
    DATA(lv_abfer)        = CONV abfer( zcl_gtt_mia_tools=>get_field_of_structure(
                                      ir_struct_data = is_app_objects-maintabref
                                      iv_field_name  = 'ABFER' ) ).

    DATA(lv_milestonenum) = iv_milestonenum.
    DATA: lt_stops    TYPE zif_gtt_mia_app_types=>tt_stops.

    FIELD-SYMBOLS: <lt_vttp> TYPE vttpvb_tab,
                   <lt_vtts> TYPE vttsvb_tab,
                   <lt_vtsp> TYPE vtspvb_tab.

    DATA(lr_vttp) = mo_ef_parameters->get_appl_table(
                      iv_tabledef = zif_gtt_mia_app_constants=>cs_tabledef-sh_item_new ).
    DATA(lr_vtts) = mo_ef_parameters->get_appl_table(
                      iv_tabledef = zif_gtt_mia_app_constants=>cs_tabledef-sh_stage_new ).
    DATA(lr_vtsp) = mo_ef_parameters->get_appl_table(
                      iv_tabledef = zif_gtt_mia_app_constants=>cs_tabledef-sh_item_stage_new ).

    ASSIGN lr_vtts->* TO <lt_vtts>.
    ASSIGN lr_vttp->* TO <lt_vttp>.
    ASSIGN lr_vtsp->* TO <lt_vtsp>.

    IF <lt_vtts> IS ASSIGNED AND
       <lt_vtsp> IS ASSIGNED AND
       <lt_vttp> IS ASSIGNED.

      zcl_gtt_mia_sh_tools=>get_stops_from_shipment(
        EXPORTING
          iv_tknum              = lv_tknum
          it_vtts               = <lt_vtts>
          it_vtsp               = <lt_vtsp>
          it_vttp               = <lt_vttp>
        IMPORTING
          et_stops              = lt_stops ).

      " important for correct sequence number calculation
      SORT lt_stops BY stopid loccat.

      LOOP AT lt_stops ASSIGNING FIELD-SYMBOL(<ls_stops>).
        " DEPARTURE / ARRIVAL
        ct_expeventdata = VALUE #( BASE ct_expeventdata (
          appsys            = mo_ef_parameters->get_appsys(  )
          appobjtype        = mo_ef_parameters->get_app_obj_types( )-aotype
          language          = sy-langu
          appobjid          = is_app_objects-appobjid
          milestone         = COND #( WHEN <ls_stops>-loccat = zif_gtt_mia_app_constants=>cs_loccat-departure
                                        THEN zif_gtt_mia_app_constants=>cs_milestone-sh_departure
                                        ELSE zif_gtt_mia_app_constants=>cs_milestone-sh_arrival )
          evt_exp_datetime  = <ls_stops>-pln_evt_datetime
          evt_exp_tzone     = <ls_stops>-pln_evt_timezone
          locid2            = <ls_stops>-stopid_txt
          loctype           = <ls_stops>-loctype
          locid1            = zcl_gtt_mia_tools=>get_pretty_location_id(
                                iv_locid   = <ls_stops>-locid
                                iv_loctype = <ls_stops>-loctype )
          milestonenum      = lv_milestonenum
        ) ).

        ADD 1 TO lv_milestonenum.

        IF ( lv_abfer = zif_gtt_mia_app_constants=>cs_abfer-empty_inb_ship OR
             lv_abfer = zif_gtt_mia_app_constants=>cs_abfer-loaded_inb_ship ).

          IF is_pod_relevant( is_stops = <ls_stops>
                              it_vttp  = <lt_vttp>
                              it_vtsp  = <lt_vtsp> ) = abap_true.
            " POD
            ct_expeventdata = VALUE #( BASE ct_expeventdata (
              appsys            = mo_ef_parameters->get_appsys(  )
              appobjtype        = mo_ef_parameters->get_app_obj_types( )-aotype
              language          = sy-langu
              appobjid          = is_app_objects-appobjid
              milestone         = zif_gtt_mia_app_constants=>cs_milestone-sh_pod
              evt_exp_datetime  = <ls_stops>-pln_evt_datetime
              evt_exp_tzone     = <ls_stops>-pln_evt_timezone
              locid2            = <ls_stops>-stopid_txt
              loctype           = <ls_stops>-loctype
              locid1            = zcl_gtt_mia_tools=>get_pretty_location_id(
                                    iv_locid   = <ls_stops>-locid
                                    iv_loctype = <ls_stops>-loctype )
              milestonenum      = lv_milestonenum
            ) ).

            ADD 1 TO lv_milestonenum.
          ENDIF.

        ELSEIF ( lv_abfer = zif_gtt_mia_app_constants=>cs_abfer-empty_outb_ship OR
                 lv_abfer = zif_gtt_mia_app_constants=>cs_abfer-loaded_outb_ship ).

          IF chk_pod_relevant_for_odlv( is_stops = <ls_stops>
                              it_vttp  = <lt_vttp>
                              it_vtsp  = <lt_vtsp> ) = abap_true.
            " POD
            ct_expeventdata = VALUE #( BASE ct_expeventdata (
              appsys            = mo_ef_parameters->get_appsys(  )
              appobjtype        = mo_ef_parameters->get_app_obj_types( )-aotype
              language          = sy-langu
              appobjid          = is_app_objects-appobjid
              milestone         = zif_gtt_mia_app_constants=>cs_milestone-sh_pod
              evt_exp_datetime  = <ls_stops>-pln_evt_datetime
              evt_exp_tzone     = <ls_stops>-pln_evt_timezone
              locid2            = <ls_stops>-stopid_txt
              loctype           = <ls_stops>-loctype
              locid1            = zcl_gtt_mia_tools=>get_pretty_location_id(
                                    iv_locid   = <ls_stops>-locid
                                    iv_loctype = <ls_stops>-loctype )
              milestonenum      = lv_milestonenum
            ) ).

            ADD 1 TO lv_milestonenum.
          ENDIF.
        ENDIF.
      ENDLOOP.
    ELSE.
      MESSAGE e002(zgtt_mia) WITH 'VTTS' INTO DATA(lv_dummy).
      zcl_gtt_mia_tools=>throw_exception( ).
    ENDIF.

  ENDMETHOD.


  METHOD constructor.

    mo_ef_parameters    = io_ef_parameters.
    mo_bo_reader        = io_bo_reader.
    mo_sh_data_old      = NEW zcl_gtt_mia_sh_data_old(
                            io_ef_parameters = io_ef_parameters ).

  ENDMETHOD.


  METHOD get_corresponding_dlv_items.

    DATA(lr_lips)   = mo_ef_parameters->get_appl_table(
                        iv_tabledef = zif_gtt_mia_app_constants=>cs_tabledef-sh_delivery_item ).

    FIELD-SYMBOLS: <lt_lips> TYPE vtrlp_tab.

    CLEAR: et_appobjid[].

    ASSIGN lr_lips->* TO <lt_lips>.

    IF <lt_lips> IS ASSIGNED.
      LOOP AT <lt_lips> ASSIGNING FIELD-SYMBOL(<ls_lips>)
        WHERE vbeln IN it_vbeln
          AND werks IN it_werks.

        et_appobjid = VALUE #( BASE et_appobjid (
                        low     = zcl_gtt_mia_dl_tools=>get_tracking_id_dl_item(
                                    ir_lips = REF #( <ls_lips> ) )
                        option  = 'EQ'
                        sign    = 'I'
                      ) ).
      ENDLOOP.
    ELSE.
      MESSAGE e002(zgtt_mia) WITH 'LIPS' INTO DATA(lv_dummy).
      zcl_gtt_mia_tools=>throw_exception( ).
    ENDIF.

  ENDMETHOD.


  METHOD get_header_fields.

    et_fields   = VALUE #( ( 'DPREG' ) ( 'UPREG' )
                           ( 'DPLBG' ) ( 'UPLBG' )
                           ( 'DPLEN' ) ( 'UPLEN' ) ).

  ENDMETHOD.


  METHOD get_shippment_header.

    TYPES: tt_vttk TYPE STANDARD TABLE OF vttkvb.

    FIELD-SYMBOLS: <lt_vttk> TYPE tt_vttk.

    DATA(lv_tknum)  = zcl_gtt_mia_tools=>get_field_of_structure(
                        ir_struct_data = is_app_object-maintabref
                        iv_field_name  = 'TKNUM' ).

    ASSIGN ir_vttk->* TO <lt_vttk>.
    IF <lt_vttk> IS ASSIGNED.
      READ TABLE <lt_vttk> ASSIGNING FIELD-SYMBOL(<ls_vttk>)
        WITH KEY tknum = lv_tknum.

      IF sy-subrc = 0.
        rr_vttk = REF #( <ls_vttk> ).
      ELSE.
        MESSAGE e005(zgtt_mia) WITH 'VTTK OLD' lv_tknum
          INTO DATA(lv_dummy).
        zcl_gtt_mia_tools=>throw_exception( ).
      ENDIF.
    ELSE.
      MESSAGE e002(zgtt_mia) WITH 'VTTK'
        INTO lv_dummy.
      zcl_gtt_mia_tools=>throw_exception( ).
    ENDIF.

  ENDMETHOD.


  METHOD get_stop_fields.

    et_fields   = VALUE #( ( 'DPTBG' ) ( 'UPTBG' )
                           ( 'DPTEN' ) ( 'UPTEN' )
                           ( 'KUNNA' ) ( 'KUNNZ' )
                           ( 'VSTEL' ) ( 'VSTEZ' )
                           ( 'LIFNA' ) ( 'LIFNZ' )
                           ( 'WERKA' ) ( 'WERKZ' )
                           ( 'KNOTA' ) ( 'KNOTZ' ) ).

  ENDMETHOD.


  METHOD is_pod_relevant.

    DATA: lt_vbeln    TYPE RANGE OF lips-vbeln,
          lt_appobjid TYPE RANGE OF /saptrx/aoid,
          lv_locid    TYPE zif_gtt_mia_app_types=>tv_locid,
          lv_pdstk    TYPE pdstk.

    rv_result = abap_false.

    IF is_stops-loccat  = zif_gtt_mia_app_constants=>cs_loccat-arrival AND
       is_stops-loctype = zif_gtt_mia_ef_constants=>cs_loc_types-plant.

      " get Inbound Delivery Numbers
      LOOP AT it_vtsp ASSIGNING FIELD-SYMBOL(<ls_vtsp>)
        WHERE tknum = is_stops-tknum
          AND tsnum = is_stops-tsnum.

        READ TABLE it_vttp ASSIGNING FIELD-SYMBOL(<ls_vttp>)
          WITH KEY tknum = <ls_vtsp>-tknum
                   tpnum = <ls_vtsp>-tpnum.

        IF sy-subrc = 0.
          lt_vbeln[]    = VALUE #( BASE lt_vbeln
                                  ( option = 'EQ'
                                    sign   = 'I'
                                    low    = <ls_vttp>-vbeln ) ).
        ENDIF.
      ENDLOOP.

      " get appobjid range (inbound deliveries for corresponding Plant)
      IF lt_vbeln[] IS NOT INITIAL.
        get_corresponding_dlv_items(
          EXPORTING
            it_vbeln    = lt_vbeln
            it_werks    = VALUE #( ( low    = is_stops-locid
                                     option = 'EQ'
                                     sign   = 'I'  ) )
          IMPORTING
            et_appobjid = lt_appobjid ).
      ENDIF.

      " get POD enabled flags for found DLV Items
      IF lt_appobjid[] IS NOT INITIAL.
        SELECT SINGLE z_pdstk                           "#EC CI_NOORDER
          INTO rv_result
          FROM zgtt_mia_ee_rel
          WHERE appobjid IN lt_appobjid
            AND z_pdstk   = abap_true.
      ENDIF.
    ENDIF.

  ENDMETHOD.


  METHOD is_stop_changed.

    FIELD-SYMBOLS: <lt_vtts_new> TYPE zif_gtt_mia_app_types=>tt_vttsvb,
                   <lt_vtts_old> TYPE zif_gtt_mia_app_types=>tt_vttsvb.

    DATA(lv_tknum)    = CONV tknum( zcl_gtt_mia_tools=>get_field_of_structure(
                                      ir_struct_data = is_app_object-maintabref
                                      iv_field_name  = 'TKNUM' ) ).

    DATA(lr_vtts_new) = mo_ef_parameters->get_appl_table(
                          iv_tabledef = zif_gtt_mia_app_constants=>cs_tabledef-sh_stage_new ).
    DATA(lr_vtts_old) = mo_sh_data_old->get_vtts( ).

    rv_result   = zif_gtt_mia_ef_constants=>cs_condition-false.

    ASSIGN lr_vtts_new->* TO <lt_vtts_new>.
    ASSIGN lr_vtts_old->* TO <lt_vtts_old>.

    IF <lt_vtts_new> IS ASSIGNED AND
       <lt_vtts_old> IS ASSIGNED.

      LOOP AT <lt_vtts_new> ASSIGNING FIELD-SYMBOL(<ls_vtts_new>)
        WHERE tknum = lv_tknum
          AND updkz IS NOT INITIAL.

        CASE <ls_vtts_new>-updkz.
          WHEN zif_gtt_mia_ef_constants=>cs_change_mode-insert.
            rv_result   = zif_gtt_mia_ef_constants=>cs_condition-true.

          WHEN zif_gtt_mia_ef_constants=>cs_change_mode-update OR
               zif_gtt_mia_ef_constants=>cs_change_mode-undefined.

            READ TABLE <lt_vtts_old> ASSIGNING FIELD-SYMBOL(<ls_vtts_old>)
              WITH KEY tknum  = <ls_vtts_new>-tknum
                       tsnum  = <ls_vtts_new>-tsnum.

            rv_result   = zcl_gtt_mia_tools=>are_fields_different(
                  ir_data1  = REF #( <ls_vtts_new> )
                  ir_data2  = REF #( <ls_vtts_old> )
                  it_fields = it_fields ).
        ENDCASE.

        IF rv_result   = zif_gtt_mia_ef_constants=>cs_condition-true.
          EXIT.
        ENDIF.
      ENDLOOP.

      IF rv_result   = zif_gtt_mia_ef_constants=>cs_condition-false.
        LOOP AT <lt_vtts_old> TRANSPORTING NO FIELDS
          WHERE tknum = lv_tknum
            AND updkz = zif_gtt_mia_ef_constants=>cs_change_mode-delete.

          rv_result   = zif_gtt_mia_ef_constants=>cs_condition-true.
        ENDLOOP.
      ENDIF.
    ENDIF.


  ENDMETHOD.


  METHOD zif_gtt_mia_pe_filler~check_relevance.

    DATA(lr_vttp) = mo_ef_parameters->get_appl_table(
                          iv_tabledef = zif_gtt_mia_app_constants=>cs_tabledef-sh_item_new ).

    rv_result = zif_gtt_mia_ef_constants=>cs_condition-false.

    " check the fields, used in PE extractor and not used in TP extractor
    IF zcl_gtt_mia_sh_tools=>is_appropriate_type( ir_vttk = is_app_objects-maintabref ) = abap_true AND
       zcl_gtt_mia_sh_tools=>is_delivery_assigned( ir_vttp = lr_vttp ) = abap_true.

      " check in, load start, load end
      get_header_fields(
        IMPORTING
          et_fields = DATA(lt_header_fields) ).

      rv_result = zcl_gtt_mia_tools=>are_fields_different(
                    ir_data1  = is_app_objects-maintabref
                    ir_data2  = get_shippment_header(
                                  is_app_object = is_app_objects
                                  ir_vttk       = mo_sh_data_old->get_vttk( ) )
                    it_fields = lt_header_fields ).

      " departure, arrival
      IF rv_result = zif_gtt_mia_ef_constants=>cs_condition-false.
        get_stop_fields(
          IMPORTING
            et_fields = DATA(lt_stop_fields) ).

        rv_result = is_stop_changed(
                      is_app_object = is_app_objects
                      it_fields     = lt_stop_fields ).

      ENDIF.
    ENDIF.

  ENDMETHOD.


  METHOD zif_gtt_mia_pe_filler~get_planed_events.

    add_shipment_events(
      EXPORTING
        is_app_objects  = is_app_objects
      CHANGING
        ct_expeventdata = ct_expeventdata
        ct_measrmntdata = ct_measrmntdata
        ct_infodata     = ct_infodata ).

    add_stops_events(
      EXPORTING
        is_app_objects  = is_app_objects
        iv_milestonenum = zcl_gtt_mia_tools=>get_next_sequence_id(
                            it_expeventdata = ct_expeventdata )
      CHANGING
        ct_expeventdata = ct_expeventdata
        ct_measrmntdata = ct_measrmntdata
        ct_infodata     = ct_infodata ).

    IF NOT line_exists( ct_expeventdata[ appobjid = is_app_objects-appobjid ] ).
      " planned events DELETION
      ct_expeventdata = VALUE #( BASE ct_expeventdata (
        appsys            = mo_ef_parameters->get_appsys(  )
        appobjtype        = mo_ef_parameters->get_app_obj_types( )-aotype
        language          = sy-langu
        appobjid          = is_app_objects-appobjid
        milestone         = ''
        evt_exp_datetime  = '000000000000000'
        evt_exp_tzone     = ''
      ) ).
    ENDIF.

  ENDMETHOD.


  METHOD chk_pod_relevant_for_odlv.

    DATA:
      lv_locid TYPE zif_gtt_mia_app_types=>tv_locid,
      lv_pdstk TYPE pdstk,
      lv_vbeln TYPE vttp-vbeln.

    rv_result = abap_false.

    IF is_stops-loccat  = zif_gtt_mia_app_constants=>cs_loccat-arrival AND
       is_stops-loctype = zif_gtt_mia_ef_constants=>cs_loc_types-businesspartner.

      "Get Outbound Delivery Numbers
      LOOP AT it_vtsp ASSIGNING FIELD-SYMBOL(<ls_vtsp>)
        WHERE tknum = is_stops-tknum
          AND tsnum = is_stops-tsnum.

        CLEAR:
          lv_locid,
          lv_pdstk,
          lv_vbeln.

        READ TABLE it_vttp ASSIGNING FIELD-SYMBOL(<ls_vttp>)
          WITH KEY tknum = <ls_vtsp>-tknum
                   tpnum = <ls_vtsp>-tpnum.
        IF sy-subrc = 0.

          SELECT SINGLE kunnr INTO lv_locid FROM likp WHERE vbeln = <ls_vttp>-vbeln.

          lv_vbeln = <ls_vttp>-vbeln.
          SHIFT lv_vbeln LEFT DELETING LEADING '0'.
          SELECT SINGLE z_pdstk INTO lv_pdstk FROM zgtt_mia_ee_rel WHERE ( appobjid = lv_vbeln OR appobjid = <ls_vttp>-vbeln ).

          IF lv_locid = is_stops-locid AND lv_pdstk = abap_true.
            rv_result = abap_true.
            EXIT.
          ENDIF.

        ENDIF.
      ENDLOOP.
    ENDIF.

  ENDMETHOD.
ENDCLASS.
