class ZCL_GTT_MIA_TP_READER_SHH definition
  public
  create public .

public section.

  interfaces ZIF_GTT_TP_READER .

  TYPES:
    BEGIN OF ts_ref_doc,
      vgbel TYPE lips-vgbel,
      vgtyp TYPE lips-vgtyp,
    END OF ts_ref_doc.
  TYPES: tt_ref_doc TYPE TABLE OF ts_ref_doc.

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

  types:
    BEGIN OF ts_address_info,
      locid     type char20,
      loctype   type char30,
      addr1     TYPE addr1_data,
      email     TYPE ad_smtpadr,
      telephone TYPE char50,
    END OF ts_address_info .
  types:
    tt_address_info type TABLE OF ts_address_info .
private section.

  types:
    tt_trobj_res_id  TYPE STANDARD TABLE OF zif_gtt_mia_app_types=>tv_trobj_res_id WITH EMPTY KEY .
  types:
    tt_trobj_res_val TYPE STANDARD TABLE OF zif_gtt_mia_app_types=>tv_trobj_res_val WITH EMPTY KEY .
  types:
    tt_resrc_cnt     TYPE STANDARD TABLE OF zif_gtt_mia_app_types=>tv_resrc_cnt WITH EMPTY KEY .
  types:
    tt_resrc_tp_id   TYPE STANDARD TABLE OF zif_gtt_mia_app_types=>tv_resrc_tp_id WITH EMPTY KEY .
  types:
    tt_crdoc_ref_typ TYPE STANDARD TABLE OF zif_gtt_mia_app_types=>tv_crdoc_ref_typ WITH EMPTY KEY .
  types:
    tt_crdoc_ref_val TYPE STANDARD TABLE OF zif_gtt_mia_app_types=>tv_crdoc_ref_val WITH EMPTY KEY .
  types:
    BEGIN OF ts_sh_header,
        tknum             TYPE vttkvb-tknum,
        bu_id_num         TYPE /saptrx/paramval200,
        cont_dg           TYPE vttkvb-cont_dg,
        tndr_trkid        TYPE vttkvb-tndr_trkid,
        ship_type         TYPE zif_gtt_mia_app_types=>tv_ship_type,
        trans_mode        TYPE zif_gtt_mia_app_types=>tv_trans_mode,
        ship_kind         TYPE zif_gtt_mia_app_types=>tv_shipment_kind,
        departure_dt      TYPE zif_gtt_mia_app_types=>tv_departure_dt,
        departure_tz      TYPE zif_gtt_mia_app_types=>tv_departure_tz,
        departure_locid   TYPE zif_gtt_mia_app_types=>tv_locid,
        departure_loctype TYPE zif_gtt_mia_app_types=>tv_loctype,
        arrival_dt        TYPE zif_gtt_mia_app_types=>tv_arrival_dt,
        arrival_tz        TYPE zif_gtt_mia_app_types=>tv_arrival_tz,
        arrival_locid     TYPE zif_gtt_mia_app_types=>tv_locid,
        arrival_loctype   TYPE zif_gtt_mia_app_types=>tv_loctype,
        tdlnr             TYPE vttkvb-tdlnr,
*        deliv_cnt         TYPE STANDARD TABLE OF zif_gtt_mia_app_types=>tv_deliv_cnt WITH EMPTY KEY,
*        deliv_no          TYPE STANDARD TABLE OF vbeln WITH EMPTY KEY,
        trobj_res_id      TYPE tt_trobj_res_id,
        trobj_res_val     TYPE tt_trobj_res_val,
        resrc_cnt         TYPE tt_resrc_cnt,
        resrc_tp_id       TYPE tt_resrc_tp_id,
        crdoc_ref_typ     TYPE tt_crdoc_ref_typ,
        crdoc_ref_val     TYPE tt_crdoc_ref_val,
        stpid_stopid      TYPE STANDARD TABLE OF zif_gtt_mia_app_types=>tv_stopid WITH EMPTY KEY,
        stpid_stopcnt     TYPE STANDARD TABLE OF zif_gtt_mia_app_types=>tv_stopcnt WITH EMPTY KEY,
        stpid_loctype     TYPE STANDARD TABLE OF zif_gtt_mia_app_types=>tv_loctype WITH EMPTY KEY,
        stpid_locid       TYPE STANDARD TABLE OF zif_gtt_mia_app_types=>tv_locid WITH EMPTY KEY,
        shpdoc_ref_typ    TYPE STANDARD TABLE OF /scmtms/btd_type_code WITH EMPTY KEY,
        shpdoc_ref_val    TYPE STANDARD TABLE OF vbeln WITH EMPTY KEY,
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
      END OF ts_sh_header .

  data MO_EF_PARAMETERS type ref to ZIF_GTT_EF_PARAMETERS .
  constants:
    BEGIN OF cs_mapping,
        tknum             TYPE /saptrx/paramname VALUE 'YN_SHP_NO',
        bu_id_num         TYPE /saptrx/paramname VALUE 'YN_SHP_SA_LBN_ID',
        cont_dg           TYPE /saptrx/paramname VALUE 'YN_SHP_CONTAIN_DGOODS',
        tndr_trkid        TYPE /saptrx/paramname VALUE 'YN_SHP_FA_TRACKING_ID',
        ship_type         TYPE /saptrx/paramname VALUE 'YN_SHP_SHIPPING_TYPE',
        trans_mode        TYPE /saptrx/paramname VALUE 'YN_SHP_TRANSPORTATION_MODE',
        ship_kind         TYPE /saptrx/paramname VALUE 'YN_SHP_SHIPMENT_TYPE',
        departure_dt      TYPE /saptrx/paramname VALUE 'YN_SHP_PLN_DEP_BUS_DATETIME',
        departure_tz      TYPE /saptrx/paramname VALUE 'YN_SHP_PLN_DEP_BUS_TIMEZONE',
        departure_locid   TYPE /saptrx/paramname VALUE 'YN_SHP_PLN_DEP_LOC_ID',
        departure_loctype TYPE /saptrx/paramname VALUE 'YN_SHP_PLN_DEP_LOC_TYPE',
        arrival_dt        TYPE /saptrx/paramname VALUE 'YN_SHP_PLN_AR_BUS_DATETIME',
        arrival_tz        TYPE /saptrx/paramname VALUE 'YN_SHP_PLN_AR_BUS_TIMEZONE',
        arrival_locid     TYPE /saptrx/paramname VALUE 'YN_SHP_PLN_AR_LOC_ID',
        arrival_loctype   TYPE /saptrx/paramname VALUE 'YN_SHP_PLN_AR_LOC_TYPE',
        tdlnr             TYPE /saptrx/paramname VALUE 'YN_SHP_SA_ERP_ID',
*        deliv_cnt         TYPE /saptrx/paramname VALUE 'YN_SHP_HDR_DLV_LINE_COUNT',
*        deliv_no          TYPE /saptrx/paramname VALUE 'YN_SHP_HDR_DLV_NO',
        trobj_res_id      TYPE /saptrx/paramname VALUE 'YN_SHP_TRACKED_RESOURCE_ID',
        trobj_res_val     TYPE /saptrx/paramname VALUE 'YN_SHP_TRACKED_RESOURCE_VALUE',
        resrc_cnt         TYPE /saptrx/paramname VALUE 'YN_SHP_RESOURCE_TP_LINE_COUNT',
        resrc_tp_id       TYPE /saptrx/paramname VALUE 'YN_SHP_RESOURCE_TP_ID',
        crdoc_ref_typ     TYPE /saptrx/paramname VALUE 'YN_SHP_CARRIER_REF_TYPE',
        crdoc_ref_val     TYPE /saptrx/paramname VALUE 'YN_SHP_CARRIER_REF_VALUE',
        stpid_stopid      TYPE /saptrx/paramname VALUE 'YN_SHP_VP_STOP_ID',
        stpid_stopcnt     TYPE /saptrx/paramname VALUE 'YN_SHP_VP_STOP_ORD_NO',
        stpid_loctype     TYPE /saptrx/paramname VALUE 'YN_SHP_VP_STOP_LOC_TYPE',
        stpid_locid       TYPE /saptrx/paramname VALUE 'YN_SHP_VP_STOP_LOC_ID',
        shpdoc_ref_typ    TYPE /saptrx/paramname VALUE 'YN_SHP_SHIPPER_REF_TYPE',
        shpdoc_ref_val    TYPE /saptrx/paramname VALUE 'YN_SHP_SHIPPER_REF_VALUE',
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

  methods FILL_HEADER_FROM_VTTK
    importing
      !IR_VTTK type ref to DATA
      !IV_VTTP_CNT type I
    changing
      !CS_HEADER type TS_SH_HEADER
    raising
      CX_UDM_MESSAGE .
  methods FILL_HEADER_FROM_VTTP
    importing
      !IR_VTTK type ref to DATA
      !IR_VTTP type ref to DATA
    changing
      !CS_HEADER type TS_SH_HEADER
    raising
      CX_UDM_MESSAGE .
  methods FILL_HEADER_FROM_VTTS
    importing
      !IR_VTTK type ref to DATA
      !IR_VTTP type ref to DATA
      !IR_VTTS type ref to DATA
      !IR_VTSP type ref to DATA optional
    changing
      !CS_HEADER type TS_SH_HEADER
    raising
      CX_UDM_MESSAGE .
  methods FILL_TRACKED_OBJECT_TABLES
    importing
      !IS_VTTK type VTTKVB
    exporting
      !ET_RES_ID type TT_TROBJ_RES_ID
      !ET_RES_VAL type TT_TROBJ_RES_VAL .
  methods FILL_RESOURCE_TABLES
    importing
      !IS_VTTK type VTTKVB
    exporting
      !ET_REF_CNT type TT_RESRC_CNT
      !ET_TP_ID type TT_RESRC_TP_ID .
  methods FILL_CARRIER_REF_DOC_TABLES
    importing
      !IS_VTTK type VTTKVB
    exporting
      !ET_REF_TYP type TT_CRDOC_REF_TYP
      !ET_REF_VAL type TT_CRDOC_REF_VAL .
  methods GET_FORWARDING_AGENT_ID_NUMBER
    importing
      !IV_TDLNR type TDLNR
    returning
      value(RV_ID_NUM) type /SAPTRX/PARAMVAL200 .
  methods GET_RESOURCE_TRACKING_ID
    importing
      !IS_VTTK type VTTKVB
    returning
      value(RV_TRACKING_ID) type /SAPTRX/TRXID .
  methods GET_SHIPPMENT_HEADER
    importing
      !IS_APP_OBJECT type TRXAS_APPOBJ_CTAB_WA
      !IR_VTTK type ref to DATA
    returning
      value(RR_VTTK) type ref to DATA
    raising
      CX_UDM_MESSAGE .
  methods GET_SHIPPMENT_ITEM_COUNT
    importing
      !IR_VTTP type ref to DATA
    returning
      value(RV_COUNT) type I
    raising
      CX_UDM_MESSAGE .
  methods GET_SHIPPMENT_TYPE
    importing
      !IV_VSART type CLIKE
      !IV_VTTP_CNT type I
    returning
      value(RV_SHIP_TYPE) type ZIF_GTT_MIA_APP_TYPES=>TV_SHIP_TYPE .
  methods GET_TRANSPORTATION_MODE
    importing
      !IV_VSART type CLIKE
    returning
      value(RV_TRANS_MODE) type ZIF_GTT_MIA_APP_TYPES=>TV_TRANS_MODE .
  methods IS_OBJECT_CHANGED
    importing
      !IS_APP_OBJECT type TRXAS_APPOBJ_CTAB_WA
    returning
      value(RV_RESULT) type ABAP_BOOL
    raising
      CX_UDM_MESSAGE .
  methods FILL_ONE_TIME_LOCATION
    importing
      !IV_TKNUM type TKNUM
      !IR_VTTS type ref to DATA
    changing
      !CS_HEADER type TS_SH_HEADER
    raising
      CX_UDM_MESSAGE .
  methods FILL_ONE_TIME_LOCATION_OLD
    importing
      !IV_TKNUM type TKNUM
      !IR_VTTS type ref to DATA
    changing
      !CS_HEADER type TS_SH_HEADER
    raising
      CX_UDM_MESSAGE .
ENDCLASS.



CLASS ZCL_GTT_MIA_TP_READER_SHH IMPLEMENTATION.


  METHOD CONSTRUCTOR.

    mo_ef_parameters    = io_ef_parameters.

  ENDMETHOD.


  METHOD FILL_CARRIER_REF_DOC_TABLES.

    zcl_gtt_mia_sh_tools=>get_carrier_reference_document(
      EXPORTING
        is_vttk    = is_vttk
      IMPORTING
        ev_ref_typ = DATA(lv_ref_typ)
        ev_ref_val = DATA(lv_ref_val) ).

    IF lv_ref_typ IS NOT INITIAL AND lv_ref_val IS NOT INITIAL.
      et_ref_typ  = VALUE #( ( lv_ref_typ ) ).
      et_ref_val  = VALUE #( ( lv_ref_val ) ).
    ELSE.
      CLEAR: et_ref_typ[], et_ref_val[].
    ENDIF.

  ENDMETHOD.


  METHOD FILL_HEADER_FROM_VTTK.

    FIELD-SYMBOLS: <ls_vttk> TYPE vttkvb.

    ASSIGN ir_vttk->* TO <ls_vttk>.
    IF sy-subrc = 0.
      cs_header-tknum = zcl_gtt_mia_sh_tools=>get_formated_sh_number(
        ir_vttk = ir_vttk ).
      cs_header-bu_id_num = get_forwarding_agent_id_number(
        iv_tdlnr = <ls_vttk>-tdlnr ).
      cs_header-cont_dg     = <ls_vttk>-cont_dg.
      cs_header-tndr_trkid  = <ls_vttk>-tndr_trkid.
      cs_header-ship_type = get_shippment_type(
        iv_vsart    = <ls_vttk>-vsart
        iv_vttp_cnt = iv_vttp_cnt ).
      cs_header-trans_mode = get_transportation_mode(
        iv_vsart = <ls_vttk>-vsart ).
      cs_header-ship_kind   = zif_gtt_mia_app_constants=>cs_shipment_kind-shipment.
      cs_header-tdlnr       = <ls_vttk>-tdlnr.

      fill_tracked_object_tables(
        EXPORTING
          is_vttk    = <ls_vttk>
        IMPORTING
          et_res_id  = cs_header-trobj_res_id
          et_res_val = cs_header-trobj_res_val ).

      fill_carrier_ref_doc_tables(
        EXPORTING
          is_vttk    = <ls_vttk>
        IMPORTING
          et_ref_typ = cs_header-crdoc_ref_typ
          et_ref_val = cs_header-crdoc_ref_val ).
    ELSE.
      MESSAGE e002(zgtt) WITH 'VTTK' INTO DATA(lv_dummy).
      zcl_gtt_tools=>throw_exception( ).
    ENDIF.

  ENDMETHOD.


  METHOD fill_header_from_vttp.

    TYPES: tt_vttp  TYPE STANDARD TABLE OF vttpvb.
    DATA: lv_count        TYPE i VALUE 0,
          lv_vbeln        TYPE vbeln_vl,
          lt_ref_doc      TYPE tt_ref_doc,
          lv_base_btd_tco TYPE /scmtms/base_btd_tco,
          lv_vgbel        TYPE lips-vgbel,
          ls_ekko         TYPE ekko,
          lt_vttp         TYPE tt_vttp.

    FIELD-SYMBOLS: <ls_vttk> TYPE vttkvb,
                   <lt_vttp> TYPE tt_vttp.

    ASSIGN ir_vttk->* TO <ls_vttk>.
    ASSIGN ir_vttp->* TO <lt_vttp>.

    IF sy-subrc = 0.
      CLEAR:
       lt_ref_doc,
       lt_vttp.
      LOOP AT <lt_vttp> ASSIGNING FIELD-SYMBOL(<ls_vttp>)
        WHERE tknum = <ls_vttk>-tknum.
        APPEND <ls_vttp> TO lt_vttp.
      ENDLOOP.
      IF lt_vttp IS NOT INITIAL.
        SELECT vgbel
               vgtyp
          INTO TABLE lt_ref_doc
          FROM lips
           FOR ALL ENTRIES IN lt_vttp
         WHERE vbeln = lt_vttp-vbeln.
      ENDIF.

      LOOP AT lt_ref_doc INTO DATA(ls_ref_doc).
        CLEAR:
          lv_vgbel,
          lv_base_btd_tco,
          ls_ekko.
        lv_vgbel = ls_ref_doc-vgbel.
        SHIFT lv_vgbel LEFT DELETING LEADING '0'.
        IF ls_ref_doc-vgtyp = if_sd_doc_category=>order.
          APPEND zif_gtt_mia_app_constants=>cs_base_btd_tco-sales_order TO cs_header-shpdoc_ref_typ.
          APPEND lv_vgbel TO cs_header-shpdoc_ref_val.
        ELSEIF ls_ref_doc-vgtyp = if_sd_doc_category=>purchase_order.

          SELECT SINGLE *
            INTO ls_ekko
            FROM ekko
           WHERE ebeln = ls_ref_doc-vgbel.

          zcl_gtt_tools=>get_tco_for_doc(
            EXPORTING
              is_ekko         = ls_ekko
            RECEIVING
              rv_base_btd_tco = lv_base_btd_tco ).
          APPEND lv_base_btd_tco TO cs_header-shpdoc_ref_typ.
          APPEND lv_vgbel TO cs_header-shpdoc_ref_val.
        ENDIF.
      ENDLOOP.

      LOOP AT lt_vttp ASSIGNING <ls_vttp>.

        lv_vbeln = zcl_gtt_mia_dl_tools=>get_formated_dlv_number(
          ir_likp = REF #( <ls_vttp> ) ).

*       For inbound Delivery,add shipper reference document
        IF <ls_vttk>-abfer = zif_gtt_mia_app_constants=>cs_abfer-empty_inb_ship OR
           <ls_vttk>-abfer = zif_gtt_mia_app_constants=>cs_abfer-loaded_inb_ship.
          APPEND zif_gtt_mia_app_constants=>cs_base_btd_tco-inb_dlv TO cs_header-shpdoc_ref_typ.
          APPEND lv_vbeln TO cs_header-shpdoc_ref_val.

*       For outbound Delivery,add shipper reference document
        ELSE.
          APPEND zif_gtt_mia_app_constants=>cs_base_btd_tco-outb_dlv TO cs_header-shpdoc_ref_typ.
          APPEND lv_vbeln TO cs_header-shpdoc_ref_val.
        ENDIF.
      ENDLOOP.

    ELSEIF <ls_vttk> IS NOT ASSIGNED.
      MESSAGE e002(zgtt) WITH 'VTTK' INTO DATA(lv_dummy).
      zcl_gtt_tools=>throw_exception( ).
    ELSE.
      MESSAGE e002(zgtt) WITH 'VTTP' INTO lv_dummy.
      zcl_gtt_tools=>throw_exception( ).
    ENDIF.

  ENDMETHOD.


  METHOD FILL_HEADER_FROM_VTTS.

    TYPES: BEGIN OF ts_stop_id,
             stopid_txt TYPE zif_gtt_mia_app_types=>tv_stopid,
             stopcnt    TYPE zif_gtt_mia_app_types=>tv_stopcnt,
             loctype    TYPE zif_gtt_mia_app_types=>tv_loctype,
             locid      TYPE zif_gtt_mia_app_types=>tv_locid,
           END OF ts_stop_id.

    DATA(lv_tknum) = CONV tknum( zcl_gtt_tools=>get_field_of_structure(
                                   ir_struct_data = ir_vttk
                                   iv_field_name  = 'TKNUM' ) ).

    DATA: lt_vtts     TYPE vttsvb_tab,
          lt_stops    TYPE zif_gtt_mia_app_types=>tt_stops,
          lt_stop_ids TYPE STANDARD TABLE OF ts_stop_id,
          lv_datetime TYPE zif_gtt_mia_app_types=>tv_pln_evt_datetime,
          lv_locid    TYPE zif_gtt_mia_app_types=>tv_locid,
          lv_stopid   TYPE zif_gtt_mia_app_types=>tv_stopid,
          lv_count    TYPE i.

    FIELD-SYMBOLS: <lt_vttp>  TYPE vttpvb_tab,
                   <lt_vtts>  TYPE vttsvb_tab,
                   <lt_vtsp>  TYPE vtspvb_tab,
                   <ls_stops> TYPE zif_gtt_mia_app_types=>ts_stops.

    ASSIGN ir_vtts->* TO <lt_vtts>.
    ASSIGN ir_vttp->* TO <lt_vttp>.
    ASSIGN ir_vtsp->* TO <lt_vtsp>.

    IF <lt_vtts> IS ASSIGNED AND
       <lt_vtsp> IS ASSIGNED AND
       <lt_vttp> IS ASSIGNED.

      lt_vtts[]  = <lt_vtts>[].
      SORT lt_vtts BY tsrfo.

      zcl_gtt_mia_sh_tools=>get_stops_from_shipment(
        EXPORTING
          iv_tknum = lv_tknum
          it_vtts  = lt_vtts
          it_vtsp  = <lt_vtsp>
          it_vttp  = <lt_vttp>
        IMPORTING
          et_stops = lt_stops ).

      CLEAR: lv_count.

      SORT lt_stops BY stopid.
      MOVE-CORRESPONDING lt_stops TO lt_stop_ids.
      DELETE ADJACENT DUPLICATES FROM lt_stop_ids.

      LOOP AT lt_stop_ids ASSIGNING FIELD-SYMBOL(<ls_stop_ids>).
        lv_locid = zcl_gtt_tools=>get_pretty_location_id(
          iv_locid   = <ls_stop_ids>-locid
          iv_loctype = <ls_stop_ids>-loctype ).

        APPEND <ls_stop_ids>-stopid_txt TO cs_header-stpid_stopid.
        APPEND <ls_stop_ids>-stopcnt    TO cs_header-stpid_stopcnt.
        APPEND <ls_stop_ids>-loctype    TO cs_header-stpid_loctype.
        APPEND lv_locid                 TO cs_header-stpid_locid.
      ENDLOOP.

      READ TABLE lt_stops ASSIGNING <ls_stops> INDEX 1.
      IF sy-subrc = 0.
        cs_header-departure_dt = zcl_gtt_tools=>convert_datetime_to_utc(
          iv_datetime = <ls_stops>-pln_evt_datetime
          iv_timezone = <ls_stops>-pln_evt_timezone ).
        cs_header-departure_tz      = <ls_stops>-pln_evt_timezone.
        cs_header-departure_locid = zcl_gtt_tools=>get_pretty_location_id(
          iv_locid   = <ls_stops>-locid
          iv_loctype = <ls_stops>-loctype ).
        cs_header-departure_loctype = <ls_stops>-loctype.
      ENDIF.

      READ TABLE lt_stops ASSIGNING <ls_stops> INDEX lines( lt_stops ).
      IF sy-subrc = 0.
        cs_header-arrival_dt = zcl_gtt_tools=>convert_datetime_to_utc(
          iv_datetime = <ls_stops>-pln_evt_datetime
          iv_timezone = <ls_stops>-pln_evt_timezone ).
        cs_header-arrival_tz      = <ls_stops>-pln_evt_timezone.
        cs_header-arrival_locid = zcl_gtt_tools=>get_pretty_location_id(
          iv_locid   = <ls_stops>-locid
          iv_loctype = <ls_stops>-loctype ).
        cs_header-arrival_loctype = <ls_stops>-loctype.
      ENDIF.
    ELSE.
      MESSAGE e002(zgtt) WITH 'VTTS' INTO DATA(lv_dummy).
      zcl_gtt_tools=>throw_exception( ).
    ENDIF.

  ENDMETHOD.


  METHOD FILL_RESOURCE_TABLES.

    DATA(lv_res_tid) = get_resource_tracking_id(
      is_vttk = is_vttk ).

    IF lv_res_tid IS NOT INITIAL.
      et_ref_cnt    = VALUE #( ( 1 ) ).
      et_tp_id      = VALUE #( ( CONV #( lv_res_tid ) ) ).
    ENDIF.

  ENDMETHOD.


  METHOD FILL_TRACKED_OBJECT_TABLES.

    IF is_vttk-exti1 IS NOT INITIAL AND
       is_vttk-vsart = '01'.

      et_res_id  = VALUE #( ( 'NA' ) ).
      et_res_val = VALUE #( ( is_vttk-exti1 ) ).

    ELSEIF is_vttk-exti1 IS NOT INITIAL AND
       is_vttk-vsart = '02'. "Mail

      et_res_id  = VALUE #( ( 'PACKAGE_EXT_ID' ) ).
      et_res_val = VALUE #( ( is_vttk-exti1 ) ).

    ELSEIF is_vttk-vsart = '04' AND
           is_vttk-signi IS NOT INITIAL.

      et_res_id  = VALUE #( ( 'CONTAINER_ID' ) ).
      et_res_val = VALUE #( ( is_vttk-signi ) ).

    ELSEIF is_vttk-exti1 IS NOT INITIAL AND
           ( is_vttk-vsart = '05' OR
             is_vttk-vsart = '15' ).

      et_res_id  = VALUE #( ( 'FLIGHT_NUMBER' ) ).
      et_res_val = VALUE #( ( is_vttk-exti1 ) ).

    ELSE.
      CLEAR: et_res_id[], et_res_val[].
    ENDIF.

  ENDMETHOD.


  METHOD get_forwarding_agent_id_number.

    DATA: lv_forward_agt TYPE bu_partner,
          lt_bpdetail    TYPE STANDARD TABLE OF bapibus1006_id_details.

    CHECK iv_tdlnr IS NOT INITIAL.

*   Retrieve BP's LBN id
    CALL METHOD cl_site_bp_assignment=>select_bp_via_cvi_link
      EXPORTING
        i_lifnr = iv_tdlnr
      IMPORTING
        e_bp    = lv_forward_agt.

    CALL FUNCTION 'BAPI_IDENTIFICATIONDETAILS_GET'
      EXPORTING
        businesspartner      = lv_forward_agt
      TABLES
        identificationdetail = lt_bpdetail.

    READ TABLE lt_bpdetail ASSIGNING FIELD-SYMBOL(<ls_bpdetail>)
      WITH KEY identificationtype = zif_gtt_mia_app_constants=>cv_agent_id_type.

    rv_id_num   = COND #( WHEN sy-subrc = 0
                            THEN zif_gtt_mia_app_constants=>cv_agent_id_prefix &&
                                 <ls_bpdetail>-identificationnumber ).

*   if BP‘s LBN id is empty, retrieve BP's Carrier Role's SCAC code with prefix "SCAC#"
    IF rv_id_num IS INITIAL.
*     Get Standard Carrier Alpha Code
      zcl_gtt_mia_sh_tools=>get_scac_code(
        EXPORTING
          iv_partner = lv_forward_agt
        RECEIVING
          rv_num     = rv_id_num ).
    ENDIF.

  ENDMETHOD.


  METHOD GET_RESOURCE_TRACKING_ID.

    rv_tracking_id  = COND #(
      WHEN is_vttk-exti1 IS NOT INITIAL AND
           ( is_vttk-vsart = '01' OR
             is_vttk-vsart = '05' OR
             is_vttk-vsart = '15' )
        THEN |{ is_vttk-tknum ALPHA = OUT }{ is_vttk-exti1 }|
      WHEN is_vttk-signi IS NOT INITIAL AND
           is_vttk-vsart = '04'
        THEN |{ is_vttk-tknum ALPHA = OUT }{ is_vttk-signi }|
    ).

    CONDENSE rv_tracking_id NO-GAPS.

  ENDMETHOD.


  METHOD GET_SHIPPMENT_HEADER.

    TYPES: tt_vttk TYPE STANDARD TABLE OF vttkvb.

    FIELD-SYMBOLS: <lt_vttk> TYPE tt_vttk.

    DATA(lv_tknum) = zcl_gtt_tools=>get_field_of_structure(
      ir_struct_data = is_app_object-maintabref
      iv_field_name  = 'TKNUM' ).

    ASSIGN ir_vttk->* TO <lt_vttk>.
    IF <lt_vttk> IS ASSIGNED.
      READ TABLE <lt_vttk> ASSIGNING FIELD-SYMBOL(<ls_vttk>)
        WITH KEY tknum = lv_tknum.

      IF sy-subrc = 0.
        rr_vttk = REF #( <ls_vttk> ).
      ELSE.
        MESSAGE e005(zgtt) WITH 'VTTK OLD' lv_tknum
          INTO DATA(lv_dummy).
        zcl_gtt_tools=>throw_exception( ).
      ENDIF.
    ELSE.
      MESSAGE e002(zgtt) WITH 'VTTK' INTO lv_dummy.
      zcl_gtt_tools=>throw_exception( ).
    ENDIF.

  ENDMETHOD.


  METHOD GET_SHIPPMENT_ITEM_COUNT.

    FIELD-SYMBOLS: <lt_vttp> TYPE ANY TABLE.

    ASSIGN ir_vttp->* TO <lt_vttp>.

    rv_count    = lines( <lt_vttp> ).

  ENDMETHOD.


  METHOD GET_SHIPPMENT_TYPE.

    rv_ship_type  = COND #( WHEN iv_vttp_cnt <= 1
                              THEN SWITCH #( iv_vsart
                                             WHEN '01' THEN '18'
                                             WHEN '04' THEN '3' )
                              ELSE SWITCH #( iv_vsart
                                             WHEN '01' THEN '17'
                                             WHEN '04' THEN '2' ) ).

  ENDMETHOD.


  METHOD GET_TRANSPORTATION_MODE.

    rv_trans_mode = SWITCH #( iv_vsart
                              WHEN '04' THEN '01'   "Sea
                              WHEN '03' THEN '02'   "Rail
                              WHEN '01' THEN '03'   "Road
                              WHEN '05' THEN '04'   "Air
                              WHEN '15' THEN '04'   "Air
                              WHEN '02' THEN '05'   "Mail
                              WHEN ''   THEN '00'   "Not specified
                                        ELSE '09'). "Not applicable

  ENDMETHOD.


  METHOD IS_OBJECT_CHANGED.

    rv_result = zcl_gtt_tools=>is_object_changed(
      is_app_object    = is_app_object
      io_ef_parameters = mo_ef_parameters
      it_check_tables  = VALUE #( ( zif_gtt_mia_app_constants=>cs_tabledef-sh_item_new )
                                  ( zif_gtt_mia_app_constants=>cs_tabledef-sh_item_new )
                                  ( zif_gtt_mia_app_constants=>cs_tabledef-sh_stage_new )
                                  ( zif_gtt_mia_app_constants=>cs_tabledef-sh_stage_old )
                                  ( zif_gtt_mia_app_constants=>cs_tabledef-sh_item_stage_new )
                                  ( zif_gtt_mia_app_constants=>cs_tabledef-sh_item_stage_old ) )
      iv_key_field     = 'TKNUM'
      iv_upd_field     = 'UPDKZ' ).

  ENDMETHOD.


  METHOD ZIF_GTT_TP_READER~CHECK_RELEVANCE.

    DATA(lr_vttp) = mo_ef_parameters->get_appl_table(
      iv_tabledef = zif_gtt_mia_app_constants=>cs_tabledef-sh_item_new ).

    rv_result = zif_gtt_ef_constants=>cs_condition-false.

    IF zcl_gtt_mia_sh_tools=>is_appropriate_type( ir_vttk = is_app_object-maintabref ) = abap_true AND
      " zcl_gtt_mia_sh_tools=>is_delivery_assigned( ir_vttp = lr_vttp ) = abap_true AND
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
    rv_appobjid = zcl_gtt_mia_sh_tools=>get_tracking_id_sh_header(
      ir_vttk = is_app_object-maintabref ).
  ENDMETHOD.


  METHOD zif_gtt_tp_reader~get_data.

    FIELD-SYMBOLS: <ls_header>  TYPE ts_sh_header.

    rr_data   = NEW ts_sh_header(  ).

    ASSIGN rr_data->* TO <ls_header>.

    DATA(lr_vttp) = mo_ef_parameters->get_appl_table(
      iv_tabledef = zif_gtt_mia_app_constants=>cs_tabledef-sh_item_new ).

    fill_header_from_vttk(
      EXPORTING
        ir_vttk     = is_app_object-maintabref
        iv_vttp_cnt = get_shippment_item_count( ir_vttp = lr_vttp )
      CHANGING
        cs_header   = <ls_header> ).

    fill_header_from_vttp(
      EXPORTING
        ir_vttk   = is_app_object-maintabref
        ir_vttp   = lr_vttp
      CHANGING
        cs_header = <ls_header> ).
    IF <ls_header>-shpdoc_ref_val IS INITIAL.
      APPEND '' TO <ls_header>-shpdoc_ref_val.
    ENDIF.

    fill_header_from_vtts(
      EXPORTING
        ir_vttk   = is_app_object-maintabref
        ir_vttp   = lr_vttp
        ir_vtts   = mo_ef_parameters->get_appl_table(
                      iv_tabledef = zif_gtt_mia_app_constants=>cs_tabledef-sh_stage_new )
        ir_vtsp   = mo_ef_parameters->get_appl_table(
                      iv_tabledef = zif_gtt_mia_app_constants=>cs_tabledef-sh_item_stage_new )
      CHANGING
        cs_header = <ls_header> ).

    fill_one_time_location(
      EXPORTING
        iv_tknum  = |{ <ls_header>-tknum ALPHA = IN }|
        ir_vtts   = mo_ef_parameters->get_appl_table(
                      iv_tabledef = zif_gtt_mia_app_constants=>cs_tabledef-sh_stage_new )
      CHANGING
        cs_header =  <ls_header> ).

    IF <ls_header>-otl_locid IS INITIAL.
      APPEND INITIAL LINE TO <ls_header>-otl_locid.
    ENDIF.

  ENDMETHOD.


  METHOD zif_gtt_tp_reader~get_data_old.

    FIELD-SYMBOLS: <ls_header>  TYPE ts_sh_header.

    DATA(lo_sh_data) = NEW zcl_gtt_mia_sh_data_old(
      io_ef_parameters = mo_ef_parameters ).

    DATA(lr_vttk) = get_shippment_header(
      is_app_object = is_app_object
      ir_vttk       = lo_sh_data->get_vttk( ) ).

    rr_data   = NEW ts_sh_header(  ).

    ASSIGN rr_data->* TO <ls_header>.

    fill_header_from_vttk(
      EXPORTING
        ir_vttk     = lr_vttk
        iv_vttp_cnt = get_shippment_item_count(
                        ir_vttp = lo_sh_data->get_vttp( ) )
      CHANGING
        cs_header   = <ls_header> ).

    fill_header_from_vttp(
      EXPORTING
        ir_vttk   = lr_vttk
        ir_vttp   = lo_sh_data->get_vttp( )
      CHANGING
        cs_header = <ls_header> ).
    IF <ls_header>-shpdoc_ref_val IS INITIAL.
      APPEND '' TO <ls_header>-shpdoc_ref_val.
    ENDIF.

    fill_header_from_vtts(
      EXPORTING
        ir_vttk   = lr_vttk
        ir_vttp   = lo_sh_data->get_vttp( )
        ir_vtts   = lo_sh_data->get_vtts( )
        ir_vtsp   = lo_sh_data->get_vtsp( )
      CHANGING
        cs_header = <ls_header> ).

    fill_one_time_location_old(
      EXPORTING
        iv_tknum  = |{ <ls_header>-tknum ALPHA = IN }|
        ir_vtts   = lo_sh_data->get_vtts( )
      CHANGING
        cs_header = <ls_header> ).

    IF <ls_header>-otl_locid IS INITIAL.
      APPEND INITIAL LINE TO <ls_header>-otl_locid.
    ENDIF.

  ENDMETHOD.


  METHOD ZIF_GTT_TP_READER~GET_FIELD_PARAMETER.

    CASE iv_parameter.
      WHEN zif_gtt_ef_constants=>cs_parameter_id-key_field.
        rv_result   = boolc( "iv_field_name = cs_mapping-deliv_cnt     OR
                             iv_field_name = cs_mapping-trobj_res_val OR
                             iv_field_name = cs_mapping-resrc_cnt     OR
                             iv_field_name = cs_mapping-crdoc_ref_val OR
                             iv_field_name = cs_mapping-stpid_stopcnt ).
      WHEN zif_gtt_ef_constants=>cs_parameter_id-no_empty_tag.
        rv_result   = boolc( iv_field_name = cs_mapping-departure_dt      OR
                             iv_field_name = cs_mapping-departure_tz      OR
                             iv_field_name = cs_mapping-departure_locid   OR
                             iv_field_name = cs_mapping-departure_loctype OR
                             iv_field_name = cs_mapping-arrival_dt        OR
                             iv_field_name = cs_mapping-arrival_tz        OR
                             iv_field_name = cs_mapping-arrival_locid     OR
                             iv_field_name = cs_mapping-arrival_loctype ).
      WHEN OTHERS.
        CLEAR: rv_result.
    ENDCASE.

  ENDMETHOD.


  METHOD ZIF_GTT_TP_READER~GET_MAPPING_STRUCTURE.

    rr_data = REF #( cs_mapping ).

  ENDMETHOD.


  METHOD ZIF_GTT_TP_READER~GET_TRACK_ID_DATA.

    "another tip is that: for tracking ID type 'SHIPMENT_ORDER' of delivery header,
    "DO NOT enable START DATE and END DATE

    DATA:
      lv_dummy         TYPE string,
      lv_shptrxcod     TYPE /saptrx/trxcod,
      lv_restrxcod     TYPE /saptrx/trxcod.

    FIELD-SYMBOLS: <ls_vttk>     TYPE vttkvb,
                   <ls_vttk_old> TYPE vttkvb.

    lv_shptrxcod = zif_gtt_ef_constants=>cs_trxcod-sh_number.
    CLEAR et_track_id_data.

    ASSIGN is_app_object-maintabref->* TO <ls_vttk>.

    IF <ls_vttk> IS ASSIGNED.
      " SHIPMENT Tracking ID
      et_track_id_data  = VALUE #( (
        appsys      = mo_ef_parameters->get_appsys( )
        appobjtype  = is_app_object-appobjtype
        appobjid    = is_app_object-appobjid
        trxcod      = lv_shptrxcod
        trxid       = zcl_gtt_mia_sh_tools=>get_tracking_id_sh_header(
                        ir_vttk = is_app_object-maintabref )
        timzon      = zcl_gtt_tools=>get_system_time_zone( )
      ) ).

    ELSE.
      MESSAGE e002(zgtt) WITH 'VTTK' INTO lv_dummy.
      zcl_gtt_tools=>throw_exception( ).
    ENDIF.

  ENDMETHOD.


  METHOD fill_one_time_location.

    FIELD-SYMBOLS:
      <lt_vtts>  TYPE vttsvb_tab.

    DATA:
      lt_vtts          TYPE vttsvb_tab,
      ls_loc_addr      TYPE addr1_data,
      lv_loc_email     TYPE ad_smtpadr,
      lv_loc_tel       TYPE char50,
      ls_address_info  TYPE ts_address_info,
      lt_address_info  TYPE tt_address_info,
      ls_loc_addr_tmp  TYPE addr1_data,
      lv_loc_email_tmp TYPE ad_smtpadr,
      lv_loc_tel_tmp   TYPE char50.

    ASSIGN ir_vtts->* TO <lt_vtts>.
    IF <lt_vtts> IS ASSIGNED.

      lt_vtts = <lt_vtts>.
      SORT lt_vtts BY tsrfo.

      zcl_gtt_tools=>get_location_info(
        EXPORTING
          iv_tknum    = iv_tknum
          it_vttsvb   = lt_vtts
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
          zcl_gtt_tools=>get_address_from_memory(
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

    ELSE.
      MESSAGE e002(zgtt) WITH 'VTTS' INTO DATA(lv_dummy).
      zcl_gtt_tools=>throw_exception( ).
    ENDIF.

    LOOP AT lt_address_info INTO ls_address_info.
      IF ls_address_info-loctype = zif_gtt_ef_constants=>cs_loc_types-businesspartner.
        APPEND |{ ls_address_info-locid ALPHA = OUT }| TO cs_header-otl_locid.
      ELSE.
        APPEND ls_address_info-locid TO cs_header-otl_locid.
      ENDIF.
      APPEND ls_address_info-loctype TO cs_header-otl_loctype.
      APPEND ls_address_info-addr1-time_zone TO cs_header-otl_timezone.
      APPEND ls_address_info-addr1-name1 TO cs_header-otl_description.
      APPEND ls_address_info-addr1-country TO cs_header-otl_country_code.
      APPEND ls_address_info-addr1-city1 TO cs_header-otl_city_name.
      APPEND ls_address_info-addr1-region TO cs_header-otl_region_code.
      APPEND ls_address_info-addr1-house_num1 TO cs_header-otl_house_number.
      APPEND ls_address_info-addr1-street TO cs_header-otl_street_name.
      APPEND ls_address_info-addr1-post_code1 TO cs_header-otl_postal_code.
      APPEND ls_address_info-email TO cs_header-otl_email_address.
      APPEND ls_address_info-telephone TO cs_header-otl_phone_number.
    ENDLOOP.

  ENDMETHOD.


  METHOD fill_one_time_location_old.

    FIELD-SYMBOLS:
      <lt_vtts>  TYPE vttsvb_tab.

    DATA:
      lt_vtts          TYPE vttsvb_tab,
      ls_loc_addr      TYPE addr1_data,
      lv_loc_email     TYPE ad_smtpadr,
      lv_loc_tel       TYPE char50,
      ls_address_info  TYPE ts_address_info,
      lt_address_info  TYPE tt_address_info,
      ls_loc_addr_tmp  TYPE addr1_data,
      lv_loc_email_tmp TYPE ad_smtpadr,
      lv_loc_tel_tmp   TYPE char50.

    ASSIGN ir_vtts->* TO <lt_vtts>.
    IF <lt_vtts> IS ASSIGNED.

      lt_vtts = <lt_vtts>.
      SORT lt_vtts BY tsrfo.

      zcl_gtt_tools=>get_location_info(
        EXPORTING
          iv_tknum    = iv_tknum
          it_vttsvb   = lt_vtts
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

    ELSE.
      MESSAGE e002(zgtt) WITH 'VTTS' INTO DATA(lv_dummy).
      zcl_gtt_tools=>throw_exception( ).
    ENDIF.

    LOOP AT lt_address_info INTO ls_address_info.
      IF ls_address_info-loctype = zif_gtt_ef_constants=>cs_loc_types-businesspartner.
        APPEND |{ ls_address_info-locid ALPHA = OUT }| TO cs_header-otl_locid.
      ELSE.
        APPEND ls_address_info-locid TO cs_header-otl_locid.
      ENDIF.
      APPEND ls_address_info-loctype TO cs_header-otl_loctype.
      APPEND ls_address_info-addr1-time_zone TO cs_header-otl_timezone.
      APPEND ls_address_info-addr1-name1 TO cs_header-otl_description.
      APPEND ls_address_info-addr1-country TO cs_header-otl_country_code.
      APPEND ls_address_info-addr1-city1 TO cs_header-otl_city_name.
      APPEND ls_address_info-addr1-region TO cs_header-otl_region_code.
      APPEND ls_address_info-addr1-house_num1 TO cs_header-otl_house_number.
      APPEND ls_address_info-addr1-street TO cs_header-otl_street_name.
      APPEND ls_address_info-addr1-post_code1 TO cs_header-otl_postal_code.
      APPEND ls_address_info-email TO cs_header-otl_email_address.
      APPEND ls_address_info-telephone TO cs_header-otl_phone_number.
    ENDLOOP.

  ENDMETHOD.
ENDCLASS.
