CLASS zcl_gtt_mia_pe_filler_dli DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES zif_gtt_mia_pe_filler .

    METHODS constructor
      IMPORTING
        !io_ef_parameters TYPE REF TO zif_gtt_mia_ef_parameters
        !io_bo_reader     TYPE REF TO zif_gtt_mia_tp_reader .
  PROTECTED SECTION.
private section.

  data MO_EF_PARAMETERS type ref to ZIF_GTT_MIA_EF_PARAMETERS .
  data MO_BO_READER type ref to ZIF_GTT_MIA_TP_READER .

  methods ADD_GOODS_RECEIPT_EVENT
    importing
      !IS_APP_OBJECTS type TRXAS_APPOBJ_CTAB_WA
      !IO_RELEVANCE type ref to ZCL_GTT_MIA_EVENT_REL_DL_MAIN
      !IV_MILESTONENUM type /SAPTRX/SEQ_NUM
    changing
      !CT_EXPEVENTDATA type ZIF_GTT_MIA_EF_TYPES=>TT_EXPEVENTDATA
    raising
      CX_UDM_MESSAGE .
  methods ADD_PACKING_EVENT
    importing
      !IS_APP_OBJECTS type TRXAS_APPOBJ_CTAB_WA
      !IO_RELEVANCE type ref to ZCL_GTT_MIA_EVENT_REL_DL_MAIN
      !IV_MILESTONENUM type /SAPTRX/SEQ_NUM
    changing
      !CT_EXPEVENTDATA type ZIF_GTT_MIA_EF_TYPES=>TT_EXPEVENTDATA
    raising
      CX_UDM_MESSAGE .
  methods ADD_PUT_AWAY_EVENT
    importing
      !IS_APP_OBJECTS type TRXAS_APPOBJ_CTAB_WA
      !IO_RELEVANCE type ref to ZCL_GTT_MIA_EVENT_REL_DL_MAIN
      !IV_MILESTONENUM type /SAPTRX/SEQ_NUM
    changing
      !CT_EXPEVENTDATA type ZIF_GTT_MIA_EF_TYPES=>TT_EXPEVENTDATA
    raising
      CX_UDM_MESSAGE .
  methods IS_TIME_OF_DELIVERY_CHANGED
    importing
      !IS_APP_OBJECTS type TRXAS_APPOBJ_CTAB_WA
    returning
      value(RV_RESULT) type ABAP_BOOL
    raising
      CX_UDM_MESSAGE .
  methods GET_GR_EVENT_MATCHKEY
    importing
      !IR_STRUCT_DATA type ref to DATA
    returning
      value(RV_MATCHKEY) type CHAR50
    raising
      CX_UDM_MESSAGE .
  methods IS_FU_RELEVANT
    importing
      !IR_STRUCT_DATA type ref to DATA
    returning
      value(RV_RESULT) type ABAP_BOOL
    raising
      CX_UDM_MESSAGE .
  methods ADD_GR_EVENT_WO_MATCHKEY
    importing
      !IS_APP_OBJECTS type TRXAS_APPOBJ_CTAB_WA
      !IO_RELEVANCE type ref to ZCL_GTT_MIA_EVENT_REL_DL_MAIN
      !IV_MILESTONENUM type /SAPTRX/SEQ_NUM
    changing
      !CT_EXPEVENTDATA type ZIF_GTT_MIA_EF_TYPES=>TT_EXPEVENTDATA
    raising
      CX_UDM_MESSAGE .
  methods ADD_FU_COMPLETED_EVENT
    importing
      !IS_APP_OBJECTS type TRXAS_APPOBJ_CTAB_WA
      !IO_RELEVANCE type ref to ZCL_GTT_MIA_EVENT_REL_DL_MAIN
    changing
      !CT_EXPEVENTDATA type ZIF_GTT_MIA_EF_TYPES=>TT_EXPEVENTDATA
    raising
      CX_UDM_MESSAGE .
ENDCLASS.



CLASS ZCL_GTT_MIA_PE_FILLER_DLI IMPLEMENTATION.


  METHOD add_goods_receipt_event.
    DATA: lv_werks  TYPE werks_d.

    IF io_relevance->is_enabled(
         iv_milestone   = zif_gtt_mia_app_constants=>cs_milestone-dl_goods_receipt ) = abap_true.

      lv_werks  = zcl_gtt_mia_tools=>get_field_of_structure(
                    ir_struct_data = is_app_objects-maintabref
                    iv_field_name  = 'WERKS' ).

      ct_expeventdata = VALUE #( BASE ct_expeventdata (
        appsys            = mo_ef_parameters->get_appsys(  )
        appobjtype        = mo_ef_parameters->get_app_obj_types( )-aotype
        language          = sy-langu
        appobjid          = is_app_objects-appobjid
        milestone         = zif_gtt_mia_app_constants=>cs_milestone-dl_goods_receipt
        evt_exp_tzone     = zcl_gtt_mia_tools=>get_system_time_zone( )
        evt_exp_datetime  = zcl_gtt_mia_dl_tools=>get_delivery_date(
                              ir_data = is_app_objects-mastertabref )
        locid1            = zcl_gtt_mia_tools=>get_pretty_location_id(
                              iv_locid   = lv_werks
                              iv_loctype = zif_gtt_mia_ef_constants=>cs_loc_types-plant )
        locid2            = get_gr_event_matchkey( ir_struct_data = is_app_objects-maintabref )
        loctype           = zif_gtt_mia_ef_constants=>cs_loc_types-plant
        milestonenum      = iv_milestonenum
      ) ).
    ENDIF.

  ENDMETHOD.


  METHOD add_packing_event.
    DATA: lv_werks  TYPE werks_d.

    IF io_relevance->is_enabled(
         iv_milestone   = zif_gtt_mia_app_constants=>cs_milestone-dl_packing ) = abap_true.

      lv_werks  = zcl_gtt_mia_tools=>get_field_of_structure(
                    ir_struct_data = is_app_objects-maintabref
                    iv_field_name  = 'WERKS' ).

      ct_expeventdata = VALUE #( BASE ct_expeventdata (
        appsys            = mo_ef_parameters->get_appsys(  )
        appobjtype        = mo_ef_parameters->get_app_obj_types( )-aotype
        language          = sy-langu
        appobjid          = is_app_objects-appobjid
        milestone         = zif_gtt_mia_app_constants=>cs_milestone-dl_packing
        evt_exp_tzone     = zcl_gtt_mia_tools=>get_system_time_zone( )
        locid1            = zcl_gtt_mia_tools=>get_pretty_location_id(
                              iv_locid   = lv_werks
                              iv_loctype = zif_gtt_mia_ef_constants=>cs_loc_types-plant )
        loctype           = zif_gtt_mia_ef_constants=>cs_loc_types-plant
        milestonenum      = iv_milestonenum
      ) ).
    ENDIF.

  ENDMETHOD.


  METHOD add_put_away_event.
    DATA: lv_werks  TYPE werks_d.

    IF io_relevance->is_enabled(
         iv_milestone   = zif_gtt_mia_app_constants=>cs_milestone-dl_put_away ) = abap_true.

      lv_werks  = zcl_gtt_mia_tools=>get_field_of_structure(
                    ir_struct_data = is_app_objects-maintabref
                    iv_field_name  = 'WERKS' ).

      ct_expeventdata = VALUE #( BASE ct_expeventdata (
        appsys            = mo_ef_parameters->get_appsys(  )
        appobjtype        = mo_ef_parameters->get_app_obj_types( )-aotype
        language          = sy-langu
        appobjid          = is_app_objects-appobjid
        milestone         = zif_gtt_mia_app_constants=>cs_milestone-dl_put_away
        evt_exp_tzone     = zcl_gtt_mia_tools=>get_system_time_zone( )
        evt_exp_datetime  = zcl_gtt_mia_dl_tools=>get_delivery_date(
                              ir_data = is_app_objects-mastertabref )
        locid1            = zcl_gtt_mia_tools=>get_pretty_location_id(
                              iv_locid   = lv_werks
                              iv_loctype = zif_gtt_mia_ef_constants=>cs_loc_types-plant )
        loctype           = zif_gtt_mia_ef_constants=>cs_loc_types-plant
        milestonenum      = iv_milestonenum
      ) ).
    ENDIF.

  ENDMETHOD.


  METHOD constructor.

    mo_ef_parameters    = io_ef_parameters.
    mo_bo_reader        = io_bo_reader.

  ENDMETHOD.


  METHOD is_time_of_delivery_changed.

    TYPES: tt_likp    TYPE STANDARD TABLE OF likpvb.

    DATA: lv_vbeln     TYPE likp-vbeln,
          lv_lfuhr_new TYPE lfuhr,
          lv_lfuhr_old TYPE lfuhr.

    lv_lfuhr_new  = zcl_gtt_mia_tools=>get_field_of_structure(
                      ir_struct_data = is_app_objects-mastertabref
                      iv_field_name  = 'LFUHR' ).

    DATA(lr_likp)  = mo_ef_parameters->get_appl_table(
                       iv_tabledef = zif_gtt_mia_app_constants=>cs_tabledef-dl_header_old ).

    FIELD-SYMBOLS: <lt_likp> TYPE tt_likp.

    IF lr_likp IS BOUND.
      ASSIGN lr_likp->* TO <lt_likp>.

      IF <lt_likp> IS ASSIGNED.
        lv_vbeln  = zcl_gtt_mia_tools=>get_field_of_structure(
                      ir_struct_data = is_app_objects-mastertabref
                      iv_field_name  = 'VBELN' ).

        READ TABLE <lt_likp> ASSIGNING FIELD-SYMBOL(<ls_likp>)
          WITH KEY vbeln = lv_vbeln.

        lv_lfuhr_old  = COND #( WHEN sy-subrc = 0 THEN <ls_likp>-lfuhr ).
      ENDIF.
    ENDIF.

    rv_result   = boolc( lv_lfuhr_new <> lv_lfuhr_old ).

  ENDMETHOD.


  METHOD zif_gtt_mia_pe_filler~check_relevance.

    TYPES: tt_milestones    TYPE STANDARD TABLE OF /saptrx/appl_event_tag
                              WITH EMPTY KEY.

    rv_result = zif_gtt_mia_ef_constants=>cs_condition-false.

    IF zcl_gtt_mia_dl_tools=>is_appropriate_dl_type( ir_struct = is_app_objects-mastertabref ) = abap_true AND
       zcl_gtt_mia_dl_tools=>is_appropriate_dl_item( ir_struct = is_app_objects-maintabref ) = abap_true.

      IF is_time_of_delivery_changed( is_app_objects = is_app_objects ) = abap_true.
        rv_result = zif_gtt_mia_ef_constants=>cs_condition-true.

      ELSE.
        DATA(lo_relevance_old)  = NEW zcl_gtt_mia_event_rel_dl_it(
                                        io_ef_parameters = mo_ef_parameters ).

        DATA(lo_relevance_new)  = NEW zcl_gtt_mia_event_rel_dl_it(
                                        io_ef_parameters = mo_ef_parameters
                                        is_app_objects   = is_app_objects ).

        DATA(lt_milestones)     = VALUE tt_milestones(
          ( zif_gtt_mia_app_constants=>cs_milestone-dl_goods_receipt )
          ( zif_gtt_mia_app_constants=>cs_milestone-dl_packing )
          ( zif_gtt_mia_app_constants=>cs_milestone-dl_put_away )
        ).

        rv_result = zif_gtt_mia_ef_constants=>cs_condition-false.

        LOOP AT lt_milestones ASSIGNING FIELD-SYMBOL(<lv_milestone>).
          IF lo_relevance_old->is_enabled( iv_milestone = <lv_milestone> ) <>
               lo_relevance_new->is_enabled( iv_milestone = <lv_milestone> ).

            rv_result = zif_gtt_mia_ef_constants=>cs_condition-true.
            EXIT.
          ENDIF.
        ENDLOOP.
      ENDIF.
    ENDIF.

  ENDMETHOD.


  METHOD zif_gtt_mia_pe_filler~get_planed_events.

    DATA(lo_relevance) = NEW zcl_gtt_mia_event_rel_dl_it(
      io_ef_parameters = mo_ef_parameters
      is_app_objects   = is_app_objects ).

    " initiate relevance flags
    lo_relevance->initiate( ).

    " store calculated relevance flags
    lo_relevance->update( ).

    add_put_away_event(
      EXPORTING
        is_app_objects  = is_app_objects
        io_relevance    = lo_relevance
        iv_milestonenum = zcl_gtt_mia_tools=>get_next_sequence_id(
                            it_expeventdata = ct_expeventdata )
      CHANGING
        ct_expeventdata = ct_expeventdata ).

    add_packing_event(
      EXPORTING
        is_app_objects  = is_app_objects
        io_relevance    = lo_relevance
        iv_milestonenum = zcl_gtt_mia_tools=>get_next_sequence_id(
                            it_expeventdata = ct_expeventdata )
      CHANGING
        ct_expeventdata = ct_expeventdata ).

    add_goods_receipt_event(
      EXPORTING
        is_app_objects  = is_app_objects
        io_relevance    = lo_relevance
        iv_milestonenum = zcl_gtt_mia_tools=>get_next_sequence_id(
                            it_expeventdata = ct_expeventdata )
      CHANGING
        ct_expeventdata = ct_expeventdata ).

    IF is_fu_relevant( ir_struct_data = is_app_objects-maintabref ) = abap_true.
      add_fu_completed_event(
        EXPORTING
          is_app_objects  = is_app_objects
          io_relevance    = lo_relevance
        CHANGING
          ct_expeventdata = ct_expeventdata ).
    ELSE.
      add_gr_event_wo_matchkey(
        EXPORTING
          is_app_objects  = is_app_objects
          io_relevance    = lo_relevance
          iv_milestonenum = zcl_gtt_mia_tools=>get_next_sequence_id(
                              it_expeventdata = ct_expeventdata )
        CHANGING
          ct_expeventdata = ct_expeventdata ).
    ENDIF.

  ENDMETHOD.


  METHOD add_fu_completed_event.

    DATA: lr_struct_data TYPE REF TO data,
          lt_fu_item     TYPE /scmtms/t_tor_item_tr_k.
    DATA: lt_torid TYPE zif_gtt_mia_ctp_types=>tt_fu_id,
          ls_torid TYPE zif_gtt_mia_ctp_types=>ts_fu_id.

    lr_struct_data = is_app_objects-maintabref.
    zcl_gtt_mia_tm_tools=>get_tor_items_for_dlv_items(
      EXPORTING
        it_lips    = VALUE #( ( vbeln = zcl_gtt_mia_tools=>get_field_of_structure(
                                  ir_struct_data = lr_struct_data
                                  iv_field_name  = 'VBELN' )
                                posnr = zcl_gtt_mia_tools=>get_field_of_structure(
                                  ir_struct_data = lr_struct_data
                                  iv_field_name  = 'POSNR' ) ) )
        iv_tor_cat = /scmtms/if_tor_const=>sc_tor_category-freight_unit
      IMPORTING
        et_fu_item = lt_fu_item ).

    LOOP AT lt_fu_item ASSIGNING FIELD-SYMBOL(<ls_fu_item>).
      lt_torid  = VALUE #( BASE lt_torid (
         tor_id = zcl_gtt_mia_tm_tools=>get_tor_root_tor_id(
                            iv_key = <ls_fu_item>-parent_key )
      ) ).

    ENDLOOP.

    SORT lt_torid BY tor_id.
    DELETE ADJACENT DUPLICATES FROM lt_torid  COMPARING tor_id.

    IF lt_torid IS NOT INITIAL.
      LOOP AT lt_torid INTO ls_torid.
        ct_expeventdata = VALUE #( BASE ct_expeventdata (
               appsys            = mo_ef_parameters->get_appsys(  )
               appobjtype        = mo_ef_parameters->get_app_obj_types( )-aotype
               language          = sy-langu
               appobjid          = is_app_objects-appobjid
               milestone         = zif_gtt_mia_app_constants=>cs_milestone-fu_completed
               evt_exp_tzone     = zcl_gtt_mia_tools=>get_system_time_zone( )
               evt_exp_datetime  = zcl_gtt_mia_dl_tools=>get_delivery_date(
                                     ir_data = is_app_objects-mastertabref )
               locid2            = zcl_gtt_mia_tm_tools=>get_formated_tor_id( ir_data = REF #( ls_torid )  )
               milestonenum      = zcl_gtt_mia_tools=>get_next_sequence_id(
                                   it_expeventdata = ct_expeventdata )
             ) ).
      ENDLOOP.
    ENDIF.
  ENDMETHOD.


  METHOD add_gr_event_wo_matchkey.

    IF io_relevance->is_enabled(
             iv_milestone   = zif_gtt_mia_app_constants=>cs_milestone-dl_goods_receipt ) = abap_true.
      ct_expeventdata = VALUE #( BASE ct_expeventdata (
              appsys            = mo_ef_parameters->get_appsys(  )
              appobjtype        = mo_ef_parameters->get_app_obj_types( )-aotype
              language          = sy-langu
              appobjid          = is_app_objects-appobjid
              milestone         = zif_gtt_mia_app_constants=>cs_milestone-dl_goods_receipt
              evt_exp_tzone     = zcl_gtt_mia_tools=>get_system_time_zone( )
              evt_exp_datetime  = zcl_gtt_mia_dl_tools=>get_delivery_date(
                                    ir_data = is_app_objects-mastertabref )
              milestonenum      = iv_milestonenum
            ) ).
    ENDIF.

  ENDMETHOD.


  METHOD get_gr_event_matchkey.

    DATA(lv_vbeln) = zcl_gtt_mia_tools=>get_field_of_structure(
      ir_struct_data = ir_struct_data
      iv_field_name  = 'VBELN' ).

    DATA(lv_posnr) = zcl_gtt_mia_tools=>get_field_of_structure(
      ir_struct_data = ir_struct_data
      iv_field_name  = 'POSNR' ).

    rv_matchkey = zcl_gtt_mia_dl_tools=>get_tracking_id_dl_item(
      ir_lips = NEW lips( vbeln = lv_vbeln posnr = lv_posnr ) ).
  ENDMETHOD.


  METHOD is_fu_relevant.

    DATA: lt_lips TYPE zif_gtt_mia_app_types=>tt_lipsvb_key.
    rv_result = zcl_gtt_mia_tm_tools=>is_fu_relevant(
      it_lips = VALUE #( BASE lt_lips (
        vbeln             = zcl_gtt_mia_tools=>get_field_of_structure(
                                  ir_struct_data = ir_struct_data
                                  iv_field_name  = 'VBELN' )
        posnr             = zcl_gtt_mia_tools=>get_field_of_structure(
                                  ir_struct_data = ir_struct_data
                                  iv_field_name  = 'POSNR' )
      ) ) ).

  ENDMETHOD.
ENDCLASS.
