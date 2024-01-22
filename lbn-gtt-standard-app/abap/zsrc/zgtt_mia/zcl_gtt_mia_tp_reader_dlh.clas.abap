class ZCL_GTT_MIA_TP_READER_DLH definition
  public
  create public .

public section.

  interfaces ZIF_GTT_TP_READER .

  methods CONSTRUCTOR
    importing
      !IO_EF_PARAMETERS type ref to ZIF_GTT_EF_PARAMETERS .
protected section.

  types tt_otl_locid TYPE STANDARD TABLE OF vbpa-lifnr WITH EMPTY KEY .
  types tt_otl_loctype TYPE STANDARD TABLE OF char30 WITH EMPTY KEY .
  types tt_otl_timezone TYPE STANDARD TABLE OF addr1_data-time_zone WITH EMPTY KEY .
  types tt_otl_description TYPE STANDARD TABLE OF addr1_data-name1 WITH EMPTY KEY .
  types tt_otl_country_code TYPE STANDARD TABLE OF addr1_data-country WITH EMPTY KEY .
  types tt_otl_city_name TYPE STANDARD TABLE OF addr1_data-city1 WITH EMPTY KEY .
  types tt_otl_region_code TYPE STANDARD TABLE OF addr1_data-region WITH EMPTY KEY .
  types tt_otl_house_number TYPE STANDARD TABLE OF addr1_data-house_num1 WITH EMPTY KEY .
  types tt_otl_street_name TYPE STANDARD TABLE OF addr1_data-street WITH EMPTY KEY .
  types tt_otl_postal_code TYPE STANDARD TABLE OF addr1_data-post_code1 WITH EMPTY KEY .
  types tt_otl_email_address TYPE STANDARD TABLE OF ad_smtpadr WITH EMPTY KEY .
  types tt_otl_phone_number TYPE STANDARD TABLE OF char50 WITH EMPTY KEY .

  TYPES:
    BEGIN OF ts_address_info,
      locid     type char20,
      loctype   type char30,
      addr1     TYPE addr1_data,
      email     TYPE ad_smtpadr,
      telephone TYPE char50,
    END OF ts_address_info.
  TYPES:
    tt_address_info type TABLE OF ts_address_info.
private section.

  types:
    BEGIN OF ts_dl_header,
      vbeln             TYPE likp-vbeln,
      lifnr             TYPE likp-lifnr,
      lifnr_lt          TYPE /saptrx/loc_id_type,
      recv_loc          TYPE likp-vstel,
      recv_loc_tp       TYPE /saptrx/loc_id_type,
      bldat             TYPE likp-bldat,
      lfdat             TYPE likp-lfdat,
      lfdat_ts          TYPE timestamp,
      erdat             TYPE timestamp,
      btgew             TYPE likp-btgew,
      ntgew             TYPE likp-ntgew,
      gewei             TYPE likp-gewei,
      volum             TYPE likp-volum,
      voleh             TYPE likp-voleh,
      lgnum             TYPE likp-lgnum,
      lgtor             TYPE likp-lgtor,
      lgnum_txt         TYPE /saptrx/paramval200,
      bolnr             TYPE likp-bolnr,
      proli             TYPE likp-proli,
      incov             TYPE likp-incov,
      inco1             TYPE likp-inco1,
      inco2_l           TYPE likp-inco2_l,
      fu_relev          TYPE abap_bool,
      lifex             TYPE likp-lifex,
      dlv_version       TYPE c LENGTH 4,
      ref_odlv_no       TYPE likp-lifex,
      otl_locid         TYPE tt_otl_locid,
      otl_loctype       TYPE tt_otl_loctype,
      otl_timezone      TYPE tt_otl_timezone,
      otl_description   TYPE tt_otl_description,
      otl_country_code  TYPE tt_otl_country_code,
      otl_city_name     TYPE tt_otl_city_name,
      otl_region_code   TYPE tt_otl_region_code,
      otl_house_number  TYPE tt_otl_house_number,
      otl_street_name   TYPE tt_otl_street_name,
      otl_postal_code   TYPE tt_otl_postal_code,
      otl_email_address TYPE tt_otl_email_address,
      otl_phone_number  TYPE tt_otl_phone_number,
    END OF ts_dl_header .

  constants:
    BEGIN OF cs_mapping,
      " Header section
      vbeln             TYPE /saptrx/paramname VALUE 'YN_DL_DELEVERY',
      lifnr             TYPE /saptrx/paramname VALUE 'YN_DL_VENDOR_ID',
      lifnr_lt          TYPE /saptrx/paramname VALUE 'YN_DL_VENDOR_LOC_TYPE',
      recv_loc          TYPE /saptrx/paramname VALUE 'YN_DL_RECEIVING_LOCATION',
      recv_loc_tp       TYPE /saptrx/paramname VALUE 'YN_DL_RECEIVING_LOC_TYPE',
      bldat             TYPE /saptrx/paramname VALUE 'YN_DL_DOCUMENT_DATE',
      lfdat             TYPE /saptrx/paramname VALUE 'YN_DL_PLANNED_DLV_DATE',
      lfdat_ts          TYPE /saptrx/paramname VALUE 'YN_DL_PLANNED_DLV_DATETIME',
      erdat             TYPE /saptrx/paramname VALUE 'YN_DL_CREATION_DATE',     "MIA
      btgew             TYPE /saptrx/paramname VALUE 'YN_DL_TOTAL_WEIGHT',
      ntgew             TYPE /saptrx/paramname VALUE 'YN_DL_NET_WEIGHT',
      gewei             TYPE /saptrx/paramname VALUE 'YN_DL_WEIGHT_UNITS',
      volum             TYPE /saptrx/paramname VALUE 'YN_DL_VOLUME',
      voleh             TYPE /saptrx/paramname VALUE 'YN_DL_VOLUME_UNITS',
      lgnum             TYPE /saptrx/paramname VALUE 'YN_DL_WAREHOUSE',
      lgnum_txt         TYPE /saptrx/paramname VALUE 'YN_DL_WAREHOUSE_DESC',
      lgtor             TYPE /saptrx/paramname VALUE 'YN_DL_DOOR',
      bolnr             TYPE /saptrx/paramname VALUE 'YN_DL_BILL_OF_LADING',
      proli             TYPE /saptrx/paramname VALUE 'YN_DL_DANGEROUS_GOODS',
      incov             TYPE /saptrx/paramname VALUE 'YN_DL_INCOTERMS_VERSION',
      inco1             TYPE /saptrx/paramname VALUE 'YN_DL_INCOTERMS',
      inco2_l           TYPE /saptrx/paramname VALUE 'YN_DL_INCOTERMS_LOCATION',
      fu_relev          TYPE /saptrx/paramname VALUE 'YN_DL_FU_RELEVANT',
      lifex             TYPE /saptrx/paramname VALUE 'YN_DL_ASN_NUMBER',
      dlv_version       TYPE /saptrx/paramname VALUE 'YN_DL_DELIVERY_VERSION',
      ref_odlv_no       TYPE /saptrx/paramname VALUE 'YN_DL_REFERENCE_ODLV_NO',
      otl_locid         TYPE /saptrx/paramname VALUE 'GTT_OTL_LOCID',
      otl_loctype       TYPE /saptrx/paramname VALUE 'GTT_OTL_LOCTYPE',
      otl_timezone      TYPE /saptrx/paramname VALUE 'GTT_OTL_TIMEZONE',
      otl_description   TYPE /saptrx/paramname VALUE 'GTT_OTL_DESCRIPTION',
      otl_country_code  TYPE /saptrx/paramname VALUE 'GTT_OTL_COUNTRY_CODE',
      otl_city_name     TYPE /saptrx/paramname VALUE 'GTT_OTL_CITY_NAME',
      otl_region_code   TYPE /saptrx/paramname VALUE 'GTT_OTL_REGION_CODE',
      otl_house_number  TYPE /saptrx/paramname VALUE 'GTT_OTL_HOUSE_NUMBER',
      otl_street_name   TYPE /saptrx/paramname VALUE 'GTT_OTL_STREET_NAME',
      otl_postal_code   TYPE /saptrx/paramname VALUE 'GTT_OTL_POSTAL_CODE',
      otl_email_address TYPE /saptrx/paramname VALUE 'GTT_OTL_EMAIL_ADDRESS',
      otl_phone_number  TYPE /saptrx/paramname VALUE 'GTT_OTL_PHONE_NUMBER',
    END OF cs_mapping .
  data MO_EF_PARAMETERS type ref to ZIF_GTT_EF_PARAMETERS .

  methods FILL_HEADER_FROM_LIKP_STRUCT
    importing
      !IR_LIKP type ref to DATA
    changing
      !CS_DL_HEADER type TS_DL_HEADER
    raising
      CX_UDM_MESSAGE .
  methods FILL_HEADER_FROM_LIPS_TABLE
    importing
      !IR_LIPS type ref to DATA
      !IV_VBELN type VBELN_VL
      !IR_LIKP type ref to DATA
    changing
      !CS_DL_HEADER type TS_DL_HEADER
    raising
      CX_UDM_MESSAGE .
  methods FILL_HEADER_LOCATION_TYPES
    changing
      !CS_DL_HEADER type TS_DL_HEADER .
  methods FORMAT_HEADER_LOCATION_IDS
    changing
      !CS_DL_HEADER type TS_DL_HEADER .
  methods GET_LIKP_STRUCT_OLD
    importing
      !IS_APP_OBJECT type TRXAS_APPOBJ_CTAB_WA
      !IV_VBELN type VBELN_VL
    returning
      value(RR_LIKP) type ref to DATA
    raising
      CX_UDM_MESSAGE .
  methods IS_OBJECT_CHANGED
    importing
      !IS_APP_OBJECT type TRXAS_APPOBJ_CTAB_WA
    returning
      value(RV_RESULT) type ABAP_BOOL
    raising
      CX_UDM_MESSAGE .
  methods ADD_DELIVERY_ITEM_TRACKING
    importing
      !IS_APP_OBJECT type TRXAS_APPOBJ_CTAB_WA
    changing
      !CT_TRACK_ID_DATA type ZIF_GTT_EF_TYPES=>TT_TRACK_ID_DATA
    raising
      CX_UDM_MESSAGE .
  methods FILL_ONE_TIME_LOCATION
    importing
      !IV_VBELN type VBELN_VL
      !IR_VBPA type ref to DATA
    changing
      !CS_DL_HEADER type TS_DL_HEADER
    raising
      CX_UDM_MESSAGE .
  methods FILL_ONE_TIME_LOCATION_OLD
    importing
      !IV_VBELN type VBELN_VL
      !IR_VBPA type ref to DATA
    changing
      !CS_DL_HEADER type TS_DL_HEADER
    raising
      CX_UDM_MESSAGE .
ENDCLASS.



CLASS ZCL_GTT_MIA_TP_READER_DLH IMPLEMENTATION.


  METHOD ADD_DELIVERY_ITEM_TRACKING.
    DATA:
      lv_dlvittrxcod     TYPE /saptrx/trxcod,
      lr_lips_new        TYPE REF TO data,
      lv_vbeln           TYPE likp-vbeln.

    FIELD-SYMBOLS:
      <lt_lips_new> TYPE zif_gtt_mia_app_types=>tt_lipsvb,
      <ls_lips>     TYPE lipsvb.

    zcl_gtt_tools=>get_field_of_structure(
      EXPORTING
        ir_struct_data = is_app_object-maintabref
        iv_field_name  = 'VBELN'
      RECEIVING
        rv_value       = lv_vbeln ).

    lv_dlvittrxcod = zif_gtt_ef_constants=>cs_trxcod-dl_position.

    lr_lips_new = mo_ef_parameters->get_appl_table(
      iv_tabledef = zif_gtt_mia_app_constants=>cs_tabledef-dl_item_new ).
    ASSIGN lr_lips_new->* TO <lt_lips_new>.
    " prepare positions list
    IF <lt_lips_new> IS ASSIGNED.
      " collect NEW records with appropriate item type
      LOOP AT <lt_lips_new> ASSIGNING <ls_lips>
        WHERE vbeln = lv_vbeln AND
              ( updkz = zif_gtt_ef_constants=>cs_change_mode-insert OR
                updkz = zif_gtt_ef_constants=>cs_change_mode-delete ).

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


  METHOD fill_header_from_lips_table.

    FIELD-SYMBOLS:
      <lt_lips> TYPE va_lipsvb_t,
      <ls_likp> TYPE likpvb.

    DATA:
      lv_dummy TYPE char100,
      lt_lips  TYPE va_lipsvb_t.

    ASSIGN ir_likp->* TO <ls_likp>.
    ASSIGN ir_lips->* TO <lt_lips>.

    IF <ls_likp> IS NOT ASSIGNED OR <lt_lips> IS NOT ASSIGNED.
      MESSAGE e002(zgtt) WITH 'LIKP LIPS' INTO lv_dummy.
      zcl_gtt_tools=>throw_exception( ).
    ENDIF.

    LOOP AT <lt_lips> ASSIGNING FIELD-SYMBOL(<ls_lips>)
      WHERE vbeln = iv_vbeln.
      APPEND <ls_lips> TO lt_lips.
    ENDLOOP.

    zcl_gtt_tools=>check_tm_int_relevance(
      EXPORTING
        iv_ctrl_key = <ls_likp>-tm_ctrl_key
        it_lips     = lt_lips
      RECEIVING
        rv_relevant = cs_dl_header-fu_relev ).

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


  METHOD zif_gtt_tp_reader~get_data.

    FIELD-SYMBOLS: <ls_header> TYPE ts_dl_header.

    DATA:
      lr_lips  TYPE REF TO data.

    rr_data   = NEW ts_dl_header( ).

    ASSIGN rr_data->* TO <ls_header>.

    lr_lips = mo_ef_parameters->get_appl_table(
      iv_tabledef = zif_gtt_mia_app_constants=>cs_tabledef-dl_item_new ).

    fill_header_from_likp_struct(
      EXPORTING
        ir_likp      = is_app_object-maintabref
      CHANGING
        cs_dl_header = <ls_header> ).

    fill_header_from_lips_table(
      EXPORTING
        ir_lips      = lr_lips
        iv_vbeln     = |{ <ls_header>-vbeln ALPHA = IN }|
        ir_likp      = is_app_object-maintabref
      CHANGING
        cs_dl_header = <ls_header> ).

    fill_header_location_types(
      CHANGING
        cs_dl_header = <ls_header> ).

    format_header_location_ids(
      CHANGING
        cs_dl_header = <ls_header> ).

*   Support one-time location(Supplier)
    fill_one_time_location(
      EXPORTING
        iv_vbeln     = |{ <ls_header>-vbeln ALPHA = IN }|
        ir_vbpa      = mo_ef_parameters->get_appl_table(
                          iv_tabledef = zif_gtt_mia_app_constants=>cs_tabledef-dl_partners_new )
      CHANGING
        cs_dl_header = <ls_header> ).

    IF <ls_header>-otl_locid IS INITIAL.
      APPEND INITIAL LINE TO <ls_header>-otl_locid.
    ENDIF.

  ENDMETHOD.


  METHOD zif_gtt_tp_reader~get_data_old.
    FIELD-SYMBOLS: <ls_header> TYPE ts_dl_header.

    DATA:
      lr_likp TYPE REF TO data,
      lr_lips TYPE REF TO data.

    DATA(lv_vbeln)  = CONV vbeln_vl( zcl_gtt_tools=>get_field_of_structure(
                                       ir_struct_data = is_app_object-maintabref
                                       iv_field_name  = 'VBELN' ) ).

    lr_likp = get_likp_struct_old(
      is_app_object = is_app_object
      iv_vbeln      = lv_vbeln ).

    lr_lips = mo_ef_parameters->get_appl_table(
      iv_tabledef = zif_gtt_mia_app_constants=>cs_tabledef-dl_item_old ).

    rr_data   = NEW ts_dl_header( ).

    ASSIGN rr_data->* TO <ls_header>.

    fill_header_from_likp_struct(
      EXPORTING
        ir_likp      = lr_likp
      CHANGING
        cs_dl_header = <ls_header> ).

    fill_header_from_lips_table(
      EXPORTING
        ir_lips      = lr_lips
        iv_vbeln     = |{ <ls_header>-vbeln ALPHA = IN }|
        ir_likp      = lr_likp
      CHANGING
        cs_dl_header = <ls_header> ).

    fill_header_location_types(
      CHANGING
        cs_dl_header = <ls_header> ).

    format_header_location_ids(
      CHANGING
        cs_dl_header = <ls_header> ).

*   Support one-time location(Supplier)
    fill_one_time_location_old(
      EXPORTING
        iv_vbeln     = |{ <ls_header>-vbeln ALPHA = IN }|
        ir_vbpa      = mo_ef_parameters->get_appl_table(
                          iv_tabledef = zif_gtt_mia_app_constants=>cs_tabledef-dl_partners_old )
      CHANGING
        cs_dl_header = <ls_header> ).

    IF <ls_header>-otl_locid IS INITIAL.
      APPEND INITIAL LINE TO <ls_header>-otl_locid.
    ENDIF.

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


  METHOD fill_one_time_location.

    FIELD-SYMBOLS:
      <ls_likp> TYPE likpvb,
      <lt_vbpa> TYPE vbpavb_tab,
      <ls_vbpa> TYPE vbpavb.

    DATA:
      lv_dummy         TYPE char100,
      ls_loc_addr      TYPE addr1_data,
      lv_loc_email     TYPE ad_smtpadr,
      lv_loc_tel       TYPE char50,
      ls_address_info  TYPE ts_address_info,
      lt_address_info  TYPE tt_address_info,
      lt_vttsvb        TYPE vttsvb_tab,
      ls_loc_addr_tmp  TYPE addr1_data,
      lv_loc_email_tmp TYPE ad_smtpadr,
      lv_loc_tel_tmp   TYPE char50.

*   Get one-time location from shipment
    zcl_gtt_tools=>get_stage_by_delivery(
      EXPORTING
        iv_vbeln  = iv_vbeln
      IMPORTING
        et_vttsvb = lt_vttsvb ).

    zcl_gtt_tools=>get_location_info(
      EXPORTING
        it_vttsvb   = lt_vttsvb
      IMPORTING
        et_loc_info = DATA(lt_loc_info) ).

    LOOP AT lt_loc_info INTO DATA(ls_loc_info).
      CLEAR:
       ls_loc_addr,
       lv_loc_email,
       lv_loc_tel,
       ls_loc_addr_tmp,
       lv_loc_email_tmp,
       lv_loc_tel_tmp.

      IF ls_loc_info-locaddrnum CN '0 ' AND ls_loc_info-locindicator CA zif_gtt_ef_constants=>shp_addr_ind_man_all.

        zcl_gtt_tools=>get_address_from_db(
          EXPORTING
            iv_addrnumber = ls_loc_info-locaddrnum
          IMPORTING
            es_addr       = ls_loc_addr
            ev_email      = lv_loc_email
            ev_telephone  = lv_loc_tel ).

        zcl_gtt_tools=>get_address_detail_by_loctype(
          EXPORTING
            iv_loctype   = ls_loc_info-loctype
            iv_locid     = ls_loc_info-locid
          IMPORTING
            es_addr      = ls_loc_addr_tmp
            ev_email     = lv_loc_email_tmp
            ev_telephone = lv_loc_tel_tmp ).

        IF ls_loc_addr <> ls_loc_addr_tmp
          OR lv_loc_email <> lv_loc_email_tmp
          OR lv_loc_tel <> lv_loc_tel_tmp.
          ls_address_info-locid = ls_loc_info-locid.
          ls_address_info-loctype = ls_loc_info-loctype.
          ls_address_info-addr1 = ls_loc_addr.
          ls_address_info-email = lv_loc_email.
          ls_address_info-telephone = lv_loc_tel.
          APPEND ls_address_info TO lt_address_info.
        ENDIF.
        CLEAR:
          ls_address_info.
      ENDIF.
    ENDLOOP.

    CLEAR:ls_address_info.

*   Get one-time location from delivery itself(supplier)
    ASSIGN ir_vbpa->* TO <lt_vbpa>.
    IF <lt_vbpa> IS ASSIGNED.
      READ TABLE <lt_vbpa> ASSIGNING <ls_vbpa> WITH KEY vbeln = iv_vbeln
                                                        posnr = '000000'
                                                        parvw = zif_gtt_mia_app_constants=>cs_parvw-supplier.
      IF sy-subrc = 0 AND <ls_vbpa> IS ASSIGNED AND <ls_vbpa> IS NOT INITIAL
        AND <ls_vbpa>-adrnr CN '0 ' AND <ls_vbpa>-adrda CA zif_gtt_ef_constants=>vbpa_addr_ind_man_all.

*      For same one-Time location id and location type which exists in delivey and shipment,
*      use the shipment's address as one-Time location address
        READ TABLE lt_address_info TRANSPORTING NO FIELDS
          WITH KEY locid = |{ <ls_vbpa>-lifnr ALPHA = OUT }|
                   loctype = zif_gtt_ef_constants=>cs_loc_types-businesspartner.
        IF sy-subrc <> 0.

          zcl_gtt_tools=>get_address_from_memory(
            EXPORTING
              iv_addrnumber = <ls_vbpa>-adrnr
            IMPORTING
              es_addr       = ls_loc_addr
              ev_email      = lv_loc_email
              ev_telephone  = lv_loc_tel ).

          ls_address_info-locid = |{ <ls_vbpa>-lifnr ALPHA = OUT }|.
          ls_address_info-loctype = zif_gtt_ef_constants=>cs_loc_types-businesspartner.
          ls_address_info-addr1 = ls_loc_addr.
          ls_address_info-email = lv_loc_email.
          ls_address_info-telephone = lv_loc_tel.
          APPEND ls_address_info TO lt_address_info.
          CLEAR:
            ls_address_info.
        ENDIF.
      ENDIF.

    ELSE.
      MESSAGE e002(zgtt) WITH 'VBPA' INTO lv_dummy.
      zcl_gtt_tools=>throw_exception( ).
    ENDIF.

    LOOP AT lt_address_info INTO ls_address_info.
      APPEND ls_address_info-locid TO cs_dl_header-otl_locid.
      APPEND ls_address_info-loctype TO cs_dl_header-otl_loctype.
      APPEND ls_address_info-addr1-time_zone TO cs_dl_header-otl_timezone.
      APPEND ls_address_info-addr1-name1 TO cs_dl_header-otl_description.
      APPEND ls_address_info-addr1-country TO cs_dl_header-otl_country_code.
      APPEND ls_address_info-addr1-city1 TO cs_dl_header-otl_city_name.
      APPEND ls_address_info-addr1-region TO cs_dl_header-otl_region_code.
      APPEND ls_address_info-addr1-house_num1 TO cs_dl_header-otl_house_number.
      APPEND ls_address_info-addr1-street TO cs_dl_header-otl_street_name.
      APPEND ls_address_info-addr1-post_code1 TO cs_dl_header-otl_postal_code.
      APPEND ls_address_info-email TO cs_dl_header-otl_email_address.
      APPEND ls_address_info-telephone TO cs_dl_header-otl_phone_number.
      CLEAR:
        ls_address_info.

    ENDLOOP.

  ENDMETHOD.


  METHOD fill_one_time_location_old.

    FIELD-SYMBOLS:
      <ls_likp> TYPE likpvb,
      <lt_vbpa> TYPE vbpavb_tab,
      <ls_vbpa> TYPE vbpavb.

    DATA:
      lv_dummy         TYPE char100,
      ls_loc_addr      TYPE addr1_data,
      lv_loc_email     TYPE ad_smtpadr,
      lv_loc_tel       TYPE char50,
      ls_address_info  TYPE ts_address_info,
      lt_address_info  TYPE tt_address_info,
      lt_vttsvb        TYPE vttsvb_tab,
      ls_loc_addr_tmp  TYPE addr1_data,
      lv_loc_email_tmp TYPE ad_smtpadr,
      lv_loc_tel_tmp   TYPE char50.

*   Get one-time location from shipment
    zcl_gtt_tools=>get_stage_by_delivery(
      EXPORTING
        iv_vbeln  = iv_vbeln
      IMPORTING
        et_vttsvb = lt_vttsvb ).

    zcl_gtt_tools=>get_location_info(
      EXPORTING
        it_vttsvb   = lt_vttsvb
      IMPORTING
        et_loc_info = DATA(lt_loc_info) ).

    LOOP AT lt_loc_info INTO DATA(ls_loc_info).
      CLEAR:
       ls_loc_addr,
       lv_loc_email,
       lv_loc_tel,
       ls_loc_addr_tmp,
       lv_loc_email_tmp,
       lv_loc_tel_tmp.

      IF ls_loc_info-locaddrnum CN '0 ' AND ls_loc_info-locindicator CA zif_gtt_ef_constants=>shp_addr_ind_man_all.

        zcl_gtt_tools=>get_address_from_db(
          EXPORTING
            iv_addrnumber = ls_loc_info-locaddrnum
          IMPORTING
            es_addr       = ls_loc_addr
            ev_email      = lv_loc_email
            ev_telephone  = lv_loc_tel ).

        zcl_gtt_tools=>get_address_detail_by_loctype(
          EXPORTING
            iv_loctype   = ls_loc_info-loctype
            iv_locid     = ls_loc_info-locid
          IMPORTING
            es_addr      = ls_loc_addr_tmp
            ev_email     = lv_loc_email_tmp
            ev_telephone = lv_loc_tel_tmp ).

        IF ls_loc_addr <> ls_loc_addr_tmp
          OR lv_loc_email <> lv_loc_email_tmp
          OR lv_loc_tel <> lv_loc_tel_tmp.

          ls_address_info-locid = ls_loc_info-locid.
          ls_address_info-loctype = ls_loc_info-loctype.
          ls_address_info-addr1 = ls_loc_addr.
          ls_address_info-email = lv_loc_email.
          ls_address_info-telephone = lv_loc_tel.
          APPEND ls_address_info TO lt_address_info.
        ENDIF.
        CLEAR:
          ls_address_info.
      ENDIF.
    ENDLOOP.

    CLEAR:ls_address_info.

*   Get one-time location from delivery itself(supplier)
    ASSIGN ir_vbpa->* TO <lt_vbpa>.
    IF <lt_vbpa> IS ASSIGNED.
      READ TABLE <lt_vbpa> ASSIGNING <ls_vbpa> WITH KEY vbeln = iv_vbeln
                                                        posnr = '000000'
                                                        parvw = zif_gtt_mia_app_constants=>cs_parvw-supplier.
      IF sy-subrc = 0 AND <ls_vbpa> IS ASSIGNED AND <ls_vbpa> IS NOT INITIAL
        AND <ls_vbpa>-adrnr CN '0 ' AND <ls_vbpa>-adrda CA zif_gtt_ef_constants=>vbpa_addr_ind_man_all.

*      For same one-Time location id and location type which exists in delivey and shipment,
*      use the shipment's address as one-Time location address
        READ TABLE lt_address_info TRANSPORTING NO FIELDS
          WITH KEY locid = |{ <ls_vbpa>-lifnr ALPHA = OUT }|
                   loctype = zif_gtt_ef_constants=>cs_loc_types-businesspartner.
        IF sy-subrc <> 0.
          zcl_gtt_tools=>get_address_from_db(
            EXPORTING
              iv_addrnumber = <ls_vbpa>-adrnr
            IMPORTING
              es_addr       = ls_loc_addr
              ev_email      = lv_loc_email
              ev_telephone  = lv_loc_tel ).

          ls_address_info-locid = |{ <ls_vbpa>-lifnr ALPHA = OUT }|.
          ls_address_info-loctype = zif_gtt_ef_constants=>cs_loc_types-businesspartner.
          ls_address_info-addr1 = ls_loc_addr.
          ls_address_info-email = lv_loc_email.
          ls_address_info-telephone = lv_loc_tel.
          APPEND ls_address_info TO lt_address_info.
          CLEAR:
            ls_address_info.
        ENDIF.
      ENDIF.

    ELSE.
      MESSAGE e002(zgtt) WITH 'VBPA' INTO lv_dummy.
      zcl_gtt_tools=>throw_exception( ).
    ENDIF.

    LOOP AT lt_address_info INTO ls_address_info.
      APPEND ls_address_info-locid TO cs_dl_header-otl_locid.
      APPEND ls_address_info-loctype TO cs_dl_header-otl_loctype.
      APPEND ls_address_info-addr1-time_zone TO cs_dl_header-otl_timezone.
      APPEND ls_address_info-addr1-name1 TO cs_dl_header-otl_description.
      APPEND ls_address_info-addr1-country TO cs_dl_header-otl_country_code.
      APPEND ls_address_info-addr1-city1 TO cs_dl_header-otl_city_name.
      APPEND ls_address_info-addr1-region TO cs_dl_header-otl_region_code.
      APPEND ls_address_info-addr1-house_num1 TO cs_dl_header-otl_house_number.
      APPEND ls_address_info-addr1-street TO cs_dl_header-otl_street_name.
      APPEND ls_address_info-addr1-post_code1 TO cs_dl_header-otl_postal_code.
      APPEND ls_address_info-email TO cs_dl_header-otl_email_address.
      APPEND ls_address_info-telephone TO cs_dl_header-otl_phone_number.
      CLEAR:
        ls_address_info.

    ENDLOOP.

  ENDMETHOD.
ENDCLASS.
