class ZCL_GTT_MIA_TP_READER_DLH definition
  public
  create public .

public section.

  interfaces ZIF_GTT_TP_READER .

  methods CONSTRUCTOR
    importing
      !IO_EF_PARAMETERS type ref to ZIF_GTT_EF_PARAMETERS .
  PROTECTED SECTION.
PRIVATE SECTION.

  TYPES:
    BEGIN OF ts_dl_header,
      vbeln       TYPE likp-vbeln,
      lifnr       TYPE likp-lifnr,
      lifnr_lt    TYPE /saptrx/loc_id_type,
      recv_loc    TYPE likp-vstel,
      recv_loc_tp TYPE /saptrx/loc_id_type,
      bldat       TYPE likp-bldat,
      lfdat       TYPE likp-lfdat,
      lfdat_ts    TYPE timestamp,
      erdat       TYPE timestamp,
      btgew       TYPE likp-btgew,
      ntgew       TYPE likp-ntgew,
      gewei       TYPE likp-gewei,
      volum       TYPE likp-volum,
      voleh       TYPE likp-voleh,
      lgnum       TYPE likp-lgnum,
      lgtor       TYPE likp-lgtor,
      lgnum_txt   TYPE /saptrx/paramval200,
      bolnr       TYPE likp-bolnr,
      proli       TYPE likp-proli,
      incov       TYPE likp-incov,
      inco1       TYPE likp-inco1,
      inco2_l     TYPE likp-inco2_l,
      fu_relev    TYPE abap_bool,
      lifex       TYPE likp-lifex,
      dlv_version TYPE c LENGTH 4,
      ref_odlv_no TYPE likp-lifex,
    END OF ts_dl_header .

  CONSTANTS:
    BEGIN OF cs_mapping,
      " Header section
      vbeln       TYPE /saptrx/paramname VALUE 'YN_DL_DELEVERY',
      lifnr       TYPE /saptrx/paramname VALUE 'YN_DL_VENDOR_ID',
      lifnr_lt    TYPE /saptrx/paramname VALUE 'YN_DL_VENDOR_LOC_TYPE',
      recv_loc    TYPE /saptrx/paramname VALUE 'YN_DL_RECEIVING_LOCATION',
      recv_loc_tp TYPE /saptrx/paramname VALUE 'YN_DL_RECEIVING_LOC_TYPE',
      bldat       TYPE /saptrx/paramname VALUE 'YN_DL_DOCUMENT_DATE',
      lfdat       TYPE /saptrx/paramname VALUE 'YN_DL_PLANNED_DLV_DATE',
      lfdat_ts    TYPE /saptrx/paramname VALUE 'YN_DL_PLANNED_DLV_DATETIME',
      erdat       TYPE /saptrx/paramname VALUE 'YN_DL_CREATION_DATE',     "MIA
      btgew       TYPE /saptrx/paramname VALUE 'YN_DL_TOTAL_WEIGHT',
      ntgew       TYPE /saptrx/paramname VALUE 'YN_DL_NET_WEIGHT',
      gewei       TYPE /saptrx/paramname VALUE 'YN_DL_WEIGHT_UNITS',
      volum       TYPE /saptrx/paramname VALUE 'YN_DL_VOLUME',
      voleh       TYPE /saptrx/paramname VALUE 'YN_DL_VOLUME_UNITS',
      lgnum       TYPE /saptrx/paramname VALUE 'YN_DL_WAREHOUSE',
      lgnum_txt   TYPE /saptrx/paramname VALUE 'YN_DL_WAREHOUSE_DESC',
      lgtor       TYPE /saptrx/paramname VALUE 'YN_DL_DOOR',
      bolnr       TYPE /saptrx/paramname VALUE 'YN_DL_BILL_OF_LADING',
      proli       TYPE /saptrx/paramname VALUE 'YN_DL_DANGEROUS_GOODS',
      incov       TYPE /saptrx/paramname VALUE 'YN_DL_INCOTERMS_VERSION',
      inco1       TYPE /saptrx/paramname VALUE 'YN_DL_INCOTERMS',
      inco2_l     TYPE /saptrx/paramname VALUE 'YN_DL_INCOTERMS_LOCATION',
      fu_relev    TYPE /saptrx/paramname VALUE 'YN_DL_FU_RELEVANT',
      lifex       TYPE /saptrx/paramname VALUE 'YN_DL_ASN_NUMBER',
      dlv_version TYPE /saptrx/paramname VALUE 'YN_DL_DELIVERY_VERSION',
      ref_odlv_no TYPE /saptrx/paramname VALUE 'YN_DL_REFERENCE_ODLV_NO',
    END OF cs_mapping .
  DATA mo_ef_parameters TYPE REF TO zif_gtt_ef_parameters .

  METHODS fill_header_from_likp_struct
    IMPORTING
      !ir_likp      TYPE REF TO data
    CHANGING
      !cs_dl_header TYPE ts_dl_header
    RAISING
      cx_udm_message .
  METHODS fill_header_from_lips_table
    IMPORTING
      !ir_lips_new  TYPE REF TO data
      !ir_lips_old  TYPE REF TO data OPTIONAL
      !iv_vbeln     TYPE vbeln_vl
    CHANGING
      !cs_dl_header TYPE ts_dl_header
    RAISING
      cx_udm_message .
  METHODS fill_header_location_types
    CHANGING
      !cs_dl_header TYPE ts_dl_header .
  METHODS format_header_location_ids
    CHANGING
      !cs_dl_header TYPE ts_dl_header .
  METHODS get_likp_struct_old
    IMPORTING
      !is_app_object TYPE trxas_appobj_ctab_wa
      !iv_vbeln      TYPE vbeln_vl
    RETURNING
      VALUE(rr_likp) TYPE REF TO data
    RAISING
      cx_udm_message .
  METHODS is_object_changed
    IMPORTING
      !is_app_object   TYPE trxas_appobj_ctab_wa
    RETURNING
      VALUE(rv_result) TYPE abap_bool
    RAISING
      cx_udm_message .
  METHODS add_delivery_item_tracking
    IMPORTING
      !is_app_object    TYPE trxas_appobj_ctab_wa
    CHANGING
      !ct_track_id_data TYPE zif_gtt_ef_types=>tt_track_id_data
    RAISING
      cx_udm_message .
ENDCLASS.



CLASS ZCL_GTT_MIA_TP_READER_DLH IMPLEMENTATION.


  METHOD ADD_DELIVERY_ITEM_TRACKING.
    DATA:
      lv_dlvittrxcod     TYPE /saptrx/trxcod,
      lr_lips_new        TYPE REF TO data.

    FIELD-SYMBOLS:
      <lt_lips_new> TYPE zif_gtt_mia_app_types=>tt_lipsvb,
      <ls_lips>     TYPE lipsvb.

    lv_dlvittrxcod = zif_gtt_ef_constants=>cs_trxcod-dl_position.

    lr_lips_new = mo_ef_parameters->get_appl_table(
      iv_tabledef = zif_gtt_mia_app_constants=>cs_tabledef-dl_item_new ).
    ASSIGN lr_lips_new->* TO <lt_lips_new>.
    " prepare positions list
    IF <lt_lips_new> IS ASSIGNED.
      " collect NEW records with appropriate item type
      LOOP AT <lt_lips_new> ASSIGNING <ls_lips>
        WHERE updkz = zif_gtt_ef_constants=>cs_change_mode-insert OR
              updkz = zif_gtt_ef_constants=>cs_change_mode-delete.

        IF zcl_gtt_tools=>is_appropriate_dl_item(
             ir_likp = is_app_object-maintabref
             ir_lips = REF #( <ls_lips> ) ) = abap_true.
          ct_track_id_data = VALUE #( BASE ct_track_id_data (
                    appsys      = mo_ef_parameters->get_appsys( )
                    appobjtype  = is_app_object-appobjtype
                    appobjid    = is_app_object-appobjid
                    trxcod      = lv_dlvittrxcod
                    trxid       = zcl_gtt_mia_dl_tools=>get_tracking_id_dl_item(
                                    ir_lips = NEW lips( vbeln = <ls_lips>-vbeln posnr = <ls_lips>-posnr ) )
                    timzon      = zcl_gtt_tools=>get_system_time_zone( )
                    action      = COND #( WHEN <ls_lips>-updkz = zif_gtt_ef_constants=>cs_change_mode-delete
                                          THEN zif_gtt_ef_constants=>cs_change_mode-delete )
                    msrid       = space
                  ) ).
        ENDIF.
      ENDLOOP.

    ENDIF.

  ENDMETHOD.


  METHOD CONSTRUCTOR.

    mo_ef_parameters    = io_ef_parameters.

  ENDMETHOD.


  METHOD fill_header_from_likp_struct.

    FIELD-SYMBOLS: <ls_likp>  TYPE likpvb.

    DATA:
      lv_voleh TYPE likp-voleh,
      lv_gewei TYPE likp-gewei.

    ASSIGN ir_likp->* TO <ls_likp>.

    IF <ls_likp> IS ASSIGNED.
      MOVE-CORRESPONDING <ls_likp> TO cs_dl_header.

      cs_dl_header-vbeln = zcl_gtt_mia_dl_tools=>get_formated_dlv_number(
        ir_likp = ir_likp ).

      cs_dl_header-erdat = zcl_gtt_tools=>get_local_timestamp(
        iv_date = <ls_likp>-erdat
        iv_time = <ls_likp>-erzet ).
      cs_dl_header-erdat = zcl_gtt_tools=>convert_datetime_to_utc(
        iv_datetime = cs_dl_header-erdat
        iv_timezone = zcl_gtt_tools=>get_system_time_zone( ) ).

      cs_dl_header-lfdat_ts = zcl_gtt_tools=>get_local_timestamp(
        iv_date = <ls_likp>-lfdat
        iv_time = <ls_likp>-lfuhr ).

      cs_dl_header-lfdat_ts = zcl_gtt_tools=>convert_datetime_to_utc(
        iv_datetime = cs_dl_header-lfdat_ts
        iv_timezone = COND #( WHEN <ls_likp>-tzonrc IS NOT INITIAL
                                   THEN <ls_likp>-tzonrc
                                   ELSE zcl_gtt_tools=>get_system_time_zone( ) ) ).

      cs_dl_header-proli    = boolc( cs_dl_header-proli IS NOT INITIAL ).
      cs_dl_header-recv_loc = <ls_likp>-vstel."Shipping Point / Receiving Point
      CLEAR:cs_dl_header-lifex.
      IF <ls_likp>-spe_lifex_type = /spe/cl_dlv_doc=>c_lifex_type-vendor.  "External Identification from Vendor
        cs_dl_header-lifex = <ls_likp>-lifex.      "External ASN Id
      ELSEIF <ls_likp>-spe_lifex_type = /spe/cl_dlv_doc=>c_lifex_type-sto. "Stock Transfer: Number of Preceding Outbound Delivery
        cs_dl_header-ref_odlv_no = <ls_likp>-lifex."Reference Outbound Delivery No.
        SHIFT cs_dl_header-ref_odlv_no LEFT DELETING LEADING '0'.
      ENDIF.
      IF <ls_likp>-lgnum IS NOT INITIAL AND
         <ls_likp>-lgtor IS NOT INITIAL.

        TRY.
            cs_dl_header-lgnum_txt = zcl_gtt_mia_dl_tools=>get_door_description(
              EXPORTING
                iv_lgnum = <ls_likp>-lgnum
                iv_lgtor = <ls_likp>-lgtor ).
          CATCH cx_udm_message.
        ENDTRY.
      ENDIF.

      zcl_gtt_tools=>convert_unit_output(
        EXPORTING
          iv_input  = cs_dl_header-voleh
        RECEIVING
          rv_output = lv_voleh ).

      zcl_gtt_tools=>convert_unit_output(
        EXPORTING
          iv_input  = cs_dl_header-gewei
        RECEIVING
          rv_output = lv_gewei ).

      cs_dl_header-voleh = lv_voleh.
      cs_dl_header-gewei = lv_gewei.

    ELSE.
      MESSAGE e002(zgtt) WITH 'LIKP' INTO DATA(lv_dummy).
      zcl_gtt_tools=>throw_exception( ).
    ENDIF.

  ENDMETHOD.


  METHOD FILL_HEADER_FROM_LIPS_TABLE.

    TYPES: tt_posnr TYPE SORTED TABLE OF posnr_vl
                           WITH UNIQUE KEY table_line.

    DATA: lv_dummy TYPE char100.

    FIELD-SYMBOLS: <lt_lips_new> TYPE zif_gtt_mia_app_types=>tt_lipsvb,
                   <lt_lips_old> TYPE zif_gtt_mia_app_types=>tt_lipsvb,
                   <ls_lips>     TYPE lipsvb.

    ASSIGN ir_lips_new->* TO <lt_lips_new>.

    " prepare positions list
    IF <lt_lips_new> IS ASSIGNED.

      cs_dl_header-fu_relev = zcl_gtt_mia_tm_tools=>is_fu_relevant(
                                it_lips = CORRESPONDING #( <lt_lips_new> ) ).

    ELSE.
      MESSAGE e002(zgtt) WITH 'LIPS NEW' INTO lv_dummy.
      zcl_gtt_tools=>throw_exception( ).
    ENDIF.

  ENDMETHOD.


  METHOD FILL_HEADER_LOCATION_TYPES.

    cs_dl_header-lifnr_lt   = zif_gtt_ef_constants=>cs_loc_types-businesspartner.

    IF cs_dl_header-recv_loc IS NOT INITIAL.
      cs_dl_header-recv_loc_tp = zif_gtt_ef_constants=>cs_loc_types-shippingpoint.
    ENDIF.

  ENDMETHOD.


  METHOD FORMAT_HEADER_LOCATION_IDS.
    cs_dl_header-lifnr  = zcl_gtt_tools=>get_pretty_location_id(
                            iv_locid   = cs_dl_header-lifnr
                            iv_loctype = cs_dl_header-lifnr_lt ).

    cs_dl_header-recv_loc = zcl_gtt_tools=>get_pretty_location_id(
                            iv_locid   = cs_dl_header-recv_loc
                            iv_loctype = cs_dl_header-recv_loc_tp ).
  ENDMETHOD.


  METHOD GET_LIKP_STRUCT_OLD.

    " when header is unchanged, table 'DELIVERY_HEADER_OLD' is not populated
    " so maintab record is used as data source for header data
    TYPES: tt_likp TYPE STANDARD TABLE OF likpvb.

    FIELD-SYMBOLS: <lt_likp> TYPE tt_likp,
                   <ls_likp> TYPE likpvb.

    DATA(lr_likp)   = mo_ef_parameters->get_appl_table(
                        iv_tabledef = zif_gtt_mia_app_constants=>cs_tabledef-dl_header_old ).

    ASSIGN lr_likp->* TO <lt_likp>.

    IF <lt_likp> IS ASSIGNED.
      READ TABLE <lt_likp> ASSIGNING <ls_likp>
        WITH KEY vbeln = iv_vbeln.

      rr_likp   = COND #( WHEN sy-subrc = 0
                            THEN REF #( <ls_likp> )
                            ELSE is_app_object-maintabref ).
    ELSE.
      MESSAGE e002(zgtt) WITH 'LIKP' INTO DATA(lv_dummy).
      zcl_gtt_tools=>throw_exception( ).
    ENDIF.

  ENDMETHOD.


  METHOD IS_OBJECT_CHANGED.

    rv_result   = zcl_gtt_tools=>is_object_changed(
                    is_app_object    = is_app_object
                    io_ef_parameters = mo_ef_parameters
                    iv_key_field     = 'VBELN'
                    iv_upd_field     = 'UPDKZ' ).

  ENDMETHOD.


  METHOD ZIF_GTT_TP_READER~CHECK_RELEVANCE.

    rv_result   = zif_gtt_ef_constants=>cs_condition-false.

    IF zcl_gtt_tools=>is_appropriate_dl_type( ir_likp = is_app_object-maintabref ) = abap_true AND
       is_object_changed( is_app_object = is_app_object ) = abap_true.

      CASE is_app_object-update_indicator.
        WHEN zif_gtt_ef_constants=>cs_change_mode-insert.
          rv_result   = zif_gtt_ef_constants=>cs_condition-true.
        WHEN zif_gtt_ef_constants=>cs_change_mode-update OR
             zif_gtt_ef_constants=>cs_change_mode-undefined.
          rv_result   = zcl_gtt_tools=>are_structures_different(
                          ir_data1  = zif_gtt_tp_reader~get_data(
                                        is_app_object = is_app_object )
                          ir_data2  = zif_gtt_tp_reader~get_data_old(
                                        is_app_object = is_app_object ) ).
      ENDCASE.
    ENDIF.

  ENDMETHOD.


  METHOD ZIF_GTT_TP_READER~GET_APP_OBJ_TYPE_ID.
    rv_appobjid   = zcl_gtt_mia_dl_tools=>get_tracking_id_dl_header(
                        ir_likp = is_app_object-maintabref ).
  ENDMETHOD.


  METHOD ZIF_GTT_TP_READER~GET_DATA.

    FIELD-SYMBOLS: <ls_header> TYPE ts_dl_header.

    rr_data   = NEW ts_dl_header( ).

    ASSIGN rr_data->* TO <ls_header>.

    fill_header_from_likp_struct(
      EXPORTING
        ir_likp      = is_app_object-maintabref
      CHANGING
        cs_dl_header = <ls_header> ).

    fill_header_from_lips_table(
      EXPORTING
        ir_lips_new  = mo_ef_parameters->get_appl_table(
                         iv_tabledef = zif_gtt_mia_app_constants=>cs_tabledef-dl_item_new )
        ir_lips_old  = mo_ef_parameters->get_appl_table(
                         iv_tabledef = zif_gtt_mia_app_constants=>cs_tabledef-dl_item_old )
        iv_vbeln     = |{ <ls_header>-vbeln ALPHA = IN }|
      CHANGING
        cs_dl_header = <ls_header> ).

    fill_header_location_types(
      CHANGING
        cs_dl_header = <ls_header> ).

    format_header_location_ids(
      CHANGING
        cs_dl_header = <ls_header> ).
  ENDMETHOD.


  METHOD ZIF_GTT_TP_READER~GET_DATA_OLD.
    FIELD-SYMBOLS: <ls_header> TYPE ts_dl_header.

    DATA(lv_vbeln)  = CONV vbeln_vl( zcl_gtt_tools=>get_field_of_structure(
                                       ir_struct_data = is_app_object-maintabref
                                       iv_field_name  = 'VBELN' ) ).

    rr_data   = NEW ts_dl_header( ).

    ASSIGN rr_data->* TO <ls_header>.

    fill_header_from_likp_struct(
      EXPORTING
        ir_likp      = get_likp_struct_old(
                         is_app_object = is_app_object
                         iv_vbeln      = lv_vbeln )
      CHANGING
        cs_dl_header = <ls_header> ).

    fill_header_from_lips_table(
      EXPORTING
        ir_lips_new  = mo_ef_parameters->get_appl_table(
                         iv_tabledef = zif_gtt_mia_app_constants=>cs_tabledef-dl_item_new )
        ir_lips_old  = mo_ef_parameters->get_appl_table(
                         iv_tabledef = zif_gtt_mia_app_constants=>cs_tabledef-dl_item_old )
        iv_vbeln     = |{ <ls_header>-vbeln ALPHA = IN }|
      CHANGING
        cs_dl_header = <ls_header> ).

    fill_header_location_types(
      CHANGING
        cs_dl_header = <ls_header> ).

    format_header_location_ids(
      CHANGING
        cs_dl_header = <ls_header> ).
  ENDMETHOD.


  METHOD ZIF_GTT_TP_READER~GET_FIELD_PARAMETER.

    CLEAR: rv_result.

  ENDMETHOD.


  METHOD ZIF_GTT_TP_READER~GET_MAPPING_STRUCTURE.

    rr_data   = REF #( cs_mapping ).

  ENDMETHOD.


  METHOD zif_gtt_tp_reader~get_track_id_data.
    " another tip is that: for tracking ID type 'SHIPMENT_ORDER' of delivery header,
    " and for tracking ID type 'RESOURCE' of shipment header,
    " DO NOT enable START DATE and END DATE

    DATA:lv_dlvhdtrxcod     TYPE /saptrx/trxcod.

    lv_dlvhdtrxcod = zif_gtt_ef_constants=>cs_trxcod-dl_number.
    CLEAR et_track_id_data.

    et_track_id_data = VALUE #( (
        appsys      = mo_ef_parameters->get_appsys( )
        appobjtype  = is_app_object-appobjtype
        appobjid    = is_app_object-appobjid
        trxcod      = lv_dlvhdtrxcod
        trxid       = zcl_gtt_mia_dl_tools=>get_tracking_id_dl_header(
                        ir_likp = is_app_object-maintabref )
        timzon      = zcl_gtt_tools=>get_system_time_zone( )
        msrid       = space
      ) ).

    add_delivery_item_tracking(
      EXPORTING
        is_app_object    = is_app_object
      CHANGING
        ct_track_id_data = et_track_id_data
    ).

  ENDMETHOD.
ENDCLASS.
