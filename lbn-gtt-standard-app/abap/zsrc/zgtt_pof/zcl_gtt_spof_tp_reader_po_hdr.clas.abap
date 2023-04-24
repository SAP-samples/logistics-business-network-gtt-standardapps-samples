class ZCL_GTT_SPOF_TP_READER_PO_HDR definition
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
private section.

  types TV_ITEM_NUM type I .
  types TV_IND_PO_ITM_DEL type ABAP_BOOL .
  types TV_IND_PO_ITM_NO type CHAR20 .
  types TV_IND_PO_NO type CHAR10 .
  types TV_IN_DLV_LINE_NO type INT4 .
  types TV_IN_DLV_NO type VBELN_VL .
  types:
    tt_ind_po_itm_del   TYPE STANDARD TABLE OF tv_ind_po_itm_del
                            WITH EMPTY KEY .
  types:
    tt_ind_po_itm_no  TYPE STANDARD TABLE OF tv_ind_po_itm_no
                            WITH EMPTY KEY .
  types:
    tt_ind_po_no   TYPE STANDARD TABLE OF tv_ind_po_no
                            WITH EMPTY KEY .
  types:
    tt_item_num TYPE STANDARD TABLE OF tv_item_num WITH EMPTY KEY .
  types TV_EBELP type CHAR15 .
  types:
    tt_ebelp TYPE STANDARD TABLE OF tv_ebelp WITH EMPTY KEY .
  types:
    tt_in_dlv_line_no TYPE STANDARD TABLE OF tv_in_dlv_line_no WITH EMPTY KEY .
  types:
    tt_in_dlv_no      TYPE STANDARD TABLE OF tv_in_dlv_no WITH EMPTY KEY .
  types:
    BEGIN OF ts_po_header,
      ebeln             TYPE ekko-ebeln,
      bsart             TYPE ekko-bsart,
      lifnr             TYPE ekko-lifnr,
      lifnr_lt          TYPE /saptrx/loc_id_type,
      werks             TYPE ekpo-werks,
      werks_lt          TYPE /saptrx/loc_id_type,
      adrnr             TYPE ekpo-adrnr,
      eindt             TYPE eket-eindt,
      netwr             TYPE ekpo-netwr,
      waers             TYPE ekko-waers,
      inco1             TYPE ekko-inco1,
      incov             TYPE ekko-incov,
      inco2_l           TYPE ekko-inco2_l,
      bedat             TYPE ekko-bedat,
      ihrez             TYPE ekko-ihrez,
      aedat             TYPE ekko-aedat,
      item_num          TYPE tt_item_num,
      ebelp             TYPE tt_ebelp,
      supplier_lbn_id   TYPE /saptrx/paramval200,
      rec_addr          TYPE /saptrx/paramval200,
      ind_po_no         TYPE tt_ind_po_no,
      ind_po_itm_no     TYPE tt_ind_po_itm_no,
      ind_po_itm_del    TYPE tt_ind_po_itm_del,
      in_dlv_line_no    TYPE tt_in_dlv_line_no,
      in_dlv_no         TYPE tt_in_dlv_no,
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
    END OF ts_po_header .

  constants:
    BEGIN OF cs_mapping,
      ebeln             TYPE /saptrx/paramname VALUE 'YN_PO_NUMBER',
      bsart             TYPE /saptrx/paramname VALUE 'YN_PO_DOCUMENT_TYPE',
      lifnr             TYPE /saptrx/paramname VALUE 'YN_PO_SUPPLIER_ID',
      lifnr_lt          TYPE /saptrx/paramname VALUE 'YN_PO_SUPPLIER_LOC_TYPE',
      werks             TYPE /saptrx/paramname VALUE 'YN_PO_RECEIVING_LOCATION',
      werks_lt          TYPE /saptrx/paramname VALUE 'YN_PO_RECEIVING_LOC_TYPE',
      adrnr             TYPE /saptrx/paramname VALUE 'YN_PO_ADDRESS_NUMBER',
      eindt             TYPE /saptrx/paramname VALUE 'YN_PO_DELIVERY_DATE',
      netwr             TYPE /saptrx/paramname VALUE 'YN_PO_NET_VALUE',
      waers             TYPE /saptrx/paramname VALUE 'YN_PO_CURRENCY',
      inco1             TYPE /saptrx/paramname VALUE 'YN_PO_INCOTERMS',
      incov             TYPE /saptrx/paramname VALUE 'YN_PO_INCOTERMS_VERSION',
      inco2_l           TYPE /saptrx/paramname VALUE 'YN_PO_INCOTERMS_LOCATION',
      bedat             TYPE /saptrx/paramname VALUE 'YN_PO_DOCUMENT_DATE',
      ihrez             TYPE /saptrx/paramname VALUE 'YN_PO_YOUR_REFERENCE',
      aedat             TYPE /saptrx/paramname VALUE 'YN_PO_CREATION_AT',
      item_num          TYPE /saptrx/paramname VALUE 'YN_PO_HDR_ITM_LINE_COUNT',
      ebelp             TYPE /saptrx/paramname VALUE 'YN_PO_HDR_ITM_NO',
      supplier_lbn_id   TYPE /saptrx/paramname VALUE 'YN_PO_SUPPLIER_LBN_ID',
      rec_addr          TYPE /saptrx/paramname VALUE 'YN_PO_RECEIVING_ADDRESS',
      ind_po_no         TYPE /saptrx/paramname VALUE 'YN_PO_IND_PO_NO',
      ind_po_itm_no     TYPE /saptrx/paramname VALUE 'YN_PO_IND_PO_ITEM_NO',
      ind_po_itm_del    TYPE /saptrx/paramname VALUE 'YN_PO_IND_PO_ITEM_DELETED',
      in_dlv_line_no    TYPE /saptrx/paramname VALUE 'YN_IDLV_LINE_NO',
      in_dlv_no         TYPE /saptrx/paramname VALUE 'YN_IDLV_NO',
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

  methods IS_OBJECT_CHANGED
    importing
      !IS_APP_OBJECT type TRXAS_APPOBJ_CTAB_WA
    returning
      value(RV_RESULT) type ABAP_BOOL
    raising
      CX_UDM_MESSAGE .
  methods FILL_HEADER_FROM_EKKO_STRUCT
    importing
      !IR_EKKO type ref to DATA
    changing
      !CS_PO_HEADER type TS_PO_HEADER
    raising
      CX_UDM_MESSAGE .
  methods FILL_HEADER_FROM_EKPO_TABLE
    importing
      !IV_EBELN type EBELN
      !IR_EKKO type ref to DATA
      !IR_EKPO type ref to DATA
    changing
      !CS_PO_HEADER type TS_PO_HEADER
    raising
      CX_UDM_MESSAGE .
  methods FILL_HEADER_FROM_EKET_TABLE
    importing
      !IV_EBELN type EBELN
      !IR_EKPO type ref to DATA
      !IR_EKET type ref to DATA
    changing
      !CS_PO_HEADER type TS_PO_HEADER
    raising
      CX_UDM_MESSAGE .
  methods FILL_HEADER_LOCATION_TYPES
    changing
      !CS_PO_HEADER type TS_PO_HEADER
    raising
      CX_UDM_MESSAGE .
  methods FILL_HEADER_FROM_EKKO_TABLE
    importing
      !IV_EBELN type EBELN
      !IR_EKKO type ref to DATA
    changing
      !CS_PO_HEADER type TS_PO_HEADER
    raising
      CX_UDM_MESSAGE .
  methods FILL_HEADER_SUPPLIER_LBN_ID
    changing
      !CS_PO_HEADER type TS_PO_HEADER .
  methods FILL_HEADER_RECEIVING_ADDRESS
    changing
      !CS_PO_HEADER type TS_PO_HEADER .
  methods FORMAT_TO_REMOVE_LEADING_ZERO
    changing
      !CS_PO_HEADER type TS_PO_HEADER .
  methods FILL_INBOUND_DLV_TABLE
    importing
      !IV_EBELN type EBELN
    changing
      !CS_PO_HEADER type TS_PO_HEADER
    raising
      CX_UDM_MESSAGE .
  methods FILL_ONE_TIME_LOCATION
    importing
      !IR_EKKO type ref to DATA
    changing
      !CS_PO_HEADER type TS_PO_HEADER
    raising
      CX_UDM_MESSAGE .
  methods FILL_ONE_TIME_LOCATION_OLD
    importing
      !IV_EBELN type EBELN
      !IR_EKKO type ref to DATA
    changing
      !CS_PO_HEADER type TS_PO_HEADER
    raising
      CX_UDM_MESSAGE .
ENDCLASS.



CLASS ZCL_GTT_SPOF_TP_READER_PO_HDR IMPLEMENTATION.


  METHOD constructor.

    mo_ef_parameters    = io_ef_parameters.

  ENDMETHOD.


  METHOD fill_header_from_eket_table.

    DATA: lt_ebelp_rng TYPE RANGE OF ekpo-ebelp,
          lv_eindt_max TYPE eket-eindt,
          lv_eindt_set TYPE abap_bool VALUE abap_false.

    FIELD-SYMBOLS: <lt_ekpo> TYPE zif_gtt_spof_app_types=>tt_uekpo,
                   <ls_ekpo> TYPE zif_gtt_spof_app_types=>ts_uekpo,
                   <lt_eket> TYPE zif_gtt_spof_app_types=>tt_ueket,
                   <ls_eket> TYPE zif_gtt_spof_app_types=>ts_ueket.


    CLEAR: cs_po_header-eindt.

    ASSIGN ir_ekpo->* TO <lt_ekpo>.
    ASSIGN ir_eket->* TO <lt_eket>.

    IF <lt_ekpo> IS ASSIGNED AND
       <lt_eket> IS ASSIGNED.
      CLEAR cs_po_header-eindt.

      " Preparation of Active Items List
      LOOP AT <lt_ekpo> ASSIGNING <ls_ekpo>
        WHERE ebeln  = iv_ebeln
          AND loekz <> zif_gtt_spof_app_constants=>cs_loekz-deleted.

        lt_ebelp_rng  = VALUE #( BASE lt_ebelp_rng
                                 ( low    = <ls_ekpo>-ebelp
                                   option = 'EQ'
                                   sign   = 'I' ) ).
      ENDLOOP.

      " keep Latest Delivery Date in schedule lines per item.

      LOOP AT <lt_eket> ASSIGNING <ls_eket>
        WHERE ebeln  = iv_ebeln
          AND ebelp IN lt_ebelp_rng
          AND kz <> zif_gtt_ef_constants=>cs_change_mode-delete
        GROUP BY ( ebeln = <ls_eket>-ebeln
                   ebelp = <ls_eket>-ebelp )
        ASCENDING
        ASSIGNING FIELD-SYMBOL(<ls_eket_group>).

        CLEAR: lv_eindt_max.

        LOOP AT GROUP <ls_eket_group> ASSIGNING FIELD-SYMBOL(<ls_eket_items>).
          lv_eindt_max    = COND #( WHEN <ls_eket_items>-eindt > lv_eindt_max
                                      THEN <ls_eket_items>-eindt
                                      ELSE lv_eindt_max ).
        ENDLOOP.

        IF lv_eindt_set = abap_false.
          cs_po_header-eindt  = lv_eindt_max.
          lv_eindt_set        = abap_true.
        ELSEIF cs_po_header-eindt < lv_eindt_max.
          cs_po_header-eindt = lv_eindt_max.
        ENDIF.
      ENDLOOP.
    ELSE.
      MESSAGE e002(zgtt) WITH 'EKET' INTO DATA(lv_dummy).
      zcl_gtt_tools=>throw_exception( ).
    ENDIF.

  ENDMETHOD.


  METHOD fill_header_from_ekko_struct.
    FIELD-SYMBOLS: <ls_ekko>  TYPE any.

    ASSIGN ir_ekko->* TO <ls_ekko>.

    IF <ls_ekko> IS ASSIGNED.
      MOVE-CORRESPONDING <ls_ekko> TO cs_po_header.
    ELSE.
      MESSAGE e002(zgtt) WITH 'EKKO' INTO DATA(lv_dummy).
      zcl_gtt_tools=>throw_exception( ).
    ENDIF.
  ENDMETHOD.


  METHOD fill_header_from_ekko_table.
    DATA: lv_dummy    TYPE char100.

    FIELD-SYMBOLS: <lt_ekko>  TYPE ANY TABLE,
                   <ls_ekko>  TYPE any,
                   <lv_ebeln> TYPE any.

    CLEAR: cs_po_header-werks, cs_po_header-netwr.

    ASSIGN ir_ekko->* TO <lt_ekko>.

    IF <lt_ekko> IS ASSIGNED.
      LOOP AT <lt_ekko> ASSIGNING <ls_ekko>.
        ASSIGN COMPONENT 'EBELN' OF STRUCTURE <ls_ekko> TO <lv_ebeln>.

        IF <lv_ebeln> IS ASSIGNED.
          " is it a record I need?
          IF <lv_ebeln>  = iv_ebeln.
            MOVE-CORRESPONDING <ls_ekko> TO cs_po_header.
            EXIT.
          ENDIF.
        ELSE.
          MESSAGE e001(zgtt) WITH 'EBELN' 'EKKO' INTO lv_dummy.
          zcl_gtt_tools=>throw_exception( ).
        ENDIF.
      ENDLOOP.
    ELSE.
      MESSAGE e002(zgtt) WITH 'EKKO' INTO lv_dummy.
      zcl_gtt_tools=>throw_exception( ).
    ENDIF.
  ENDMETHOD.


  METHOD fill_header_from_ekpo_table.

    DATA: lv_item_num TYPE tv_item_num VALUE 0,
          lv_fname    TYPE char5,
          lv_dummy    TYPE char100.

    FIELD-SYMBOLS: <lt_ekpo>  TYPE ANY TABLE,
                   <lt_ekko>  TYPE ANY TABLE,
                   <ls_ekpo>  TYPE any,
                   <ls_ekko>  TYPE any,
                   <lv_ebeln> TYPE any,
                   <lv_ebelp> TYPE any,
                   <lv_loekz> TYPE any,
                   <lv_werks> TYPE any,
                   <lv_netwr> TYPE any,
                   <lv_adrnr> TYPE any.

    CLEAR: cs_po_header-werks,
           cs_po_header-adrnr,
           cs_po_header-netwr,
           cs_po_header-item_num[],
           cs_po_header-ebelp[],
           cs_po_header-ind_po_no[],
           cs_po_header-ind_po_itm_no[],
           cs_po_header-ind_po_itm_del[].

    ASSIGN ir_ekko->* TO <lt_ekko>.
    ASSIGN ir_ekpo->* TO <lt_ekpo>.

    IF <lt_ekpo> IS ASSIGNED AND <lt_ekko> IS ASSIGNED.
      LOOP AT <lt_ekpo> ASSIGNING <ls_ekpo>.
        ASSIGN COMPONENT 'EBELN' OF STRUCTURE <ls_ekpo> TO <lv_ebeln>.
        ASSIGN COMPONENT 'EBELP' OF STRUCTURE <ls_ekpo> TO <lv_ebelp>.
        ASSIGN COMPONENT 'LOEKZ' OF STRUCTURE <ls_ekpo> TO <lv_loekz>.
        ASSIGN COMPONENT 'WERKS' OF STRUCTURE <ls_ekpo> TO <lv_werks>.
        ASSIGN COMPONENT 'NETWR' OF STRUCTURE <ls_ekpo> TO <lv_netwr>.
        ASSIGN COMPONENT 'ADRNR' OF STRUCTURE <ls_ekpo> TO <lv_adrnr>.

        IF <lv_ebeln> IS ASSIGNED AND
           <lv_ebelp> IS ASSIGNED AND
           <lv_loekz> IS ASSIGNED AND
           <lv_werks> IS ASSIGNED AND
           <lv_netwr> IS ASSIGNED.

          LOOP AT <lt_ekko> ASSIGNING <ls_ekko>.
            ASSIGN COMPONENT 'EBELN' OF STRUCTURE <ls_ekko> TO FIELD-SYMBOL(<lv_ekko_ebeln>).
            IF <lv_ekko_ebeln> IS ASSIGNED.
              IF <lv_ekko_ebeln> = <lv_ebeln>.
                EXIT.
              ELSE.
                UNASSIGN <ls_ekko>.
              ENDIF.
            ENDIF.
          ENDLOOP.

          IF <lv_ebeln>  = iv_ebeln AND <ls_ekko> IS ASSIGNED AND
             zcl_gtt_spof_po_tools=>is_appropriate_po_item( ir_ekko = REF #( <ls_ekko> ) ir_ekpo = REF #( <ls_ekpo> ) ) = abap_true.

            " Add PO Item number into result table
            ADD 1 TO lv_item_num.
            APPEND lv_item_num TO cs_po_header-item_num.

            " Add composition (PO Number PO Item position) into result table

            APPEND zcl_gtt_spof_po_tools=>get_tracking_id_po_itm( ir_ekpo = REF #( <ls_ekpo> ) ) TO cs_po_header-ebelp.
            APPEND zcl_gtt_spof_po_tools=>get_tracking_id_po_hdr( ir_ekko = REF #( <ls_ekpo> ) ) TO cs_po_header-ind_po_no.
            APPEND <lv_ebelp> TO cs_po_header-ind_po_itm_no.
            " Is item not deleted (active or blocked)?
            IF <lv_loekz> <> zif_gtt_spof_app_constants=>cs_loekz-deleted.
              " Plant ID, keep empty in case of different receiving plants on item level
              cs_po_header-werks  = COND #( WHEN sy-tabix = 1 OR
                                                 <lv_werks>  = cs_po_header-werks
                                              THEN <lv_werks> ).

              cs_po_header-adrnr  = COND #( WHEN cs_po_header-werks IS NOT INITIAL AND
                                                 <lv_adrnr> IS ASSIGNED
                                              THEN <lv_adrnr> ).
              " Sum of net values on item level
              ADD <lv_netwr> TO cs_po_header-netwr.
              APPEND abap_false TO cs_po_header-ind_po_itm_del.
            ELSE.
              APPEND abap_true TO cs_po_header-ind_po_itm_del.
            ENDIF.
          ENDIF.
        ELSE.
          lv_fname  = COND #( WHEN <lv_ebeln> IS NOT ASSIGNED THEN 'EBELN'
                              WHEN <lv_ebelp> IS NOT ASSIGNED THEN 'EBELP'
                              WHEN <lv_loekz> IS NOT ASSIGNED THEN 'LOEKZ'
                              WHEN <lv_werks> IS NOT ASSIGNED THEN 'WERKS'
                                ELSE 'NETWR' ).
          MESSAGE e001(zgtt) WITH lv_fname 'EKPO' INTO lv_dummy.
          zcl_gtt_tools=>throw_exception( ).
        ENDIF.
      ENDLOOP.

      cs_po_header-netwr = zcl_gtt_tools=>convert_to_external_amount(
        iv_currency = cs_po_header-waers
        iv_internal = cs_po_header-netwr ).
    ELSE.
      MESSAGE e002(zgtt) WITH 'EKPO' INTO lv_dummy.
      zcl_gtt_tools=>throw_exception( ).
    ENDIF.

  ENDMETHOD.


  METHOD fill_header_location_types.

    IF cs_po_header-lifnr IS NOT INITIAL.
      cs_po_header-lifnr_lt  = zif_gtt_ef_constants=>cs_loc_types-businesspartner.
    ENDIF.
    cs_po_header-werks_lt  = zif_gtt_ef_constants=>cs_loc_types-plant.

  ENDMETHOD.


  METHOD fill_header_receiving_address.

    cs_po_header-adrnr  = COND #( WHEN cs_po_header-adrnr IS NOT INITIAL
                                    THEN cs_po_header-adrnr ).

    IF cs_po_header-adrnr IS INITIAL AND cs_po_header-werks IS NOT INITIAL.
      TRY.
          zcl_gtt_spof_po_tools=>get_plant_address_num_and_name(
            EXPORTING
              iv_werks = cs_po_header-werks
            IMPORTING
              ev_adrnr = cs_po_header-adrnr
          ).
        CATCH cx_udm_message.
      ENDTRY.
    ENDIF.

    IF cs_po_header-adrnr IS NOT INITIAL.
      TRY.
          zcl_gtt_spof_po_tools=>get_address_info(
            EXPORTING
              iv_addr_numb = cs_po_header-adrnr
            IMPORTING
              ev_address   = cs_po_header-rec_addr ).
        CATCH cx_udm_message.
      ENDTRY.
    ENDIF.
  ENDMETHOD.


  METHOD fill_header_supplier_lbn_id.
    IF cs_po_header-lifnr IS NOT INITIAL.

      cs_po_header-supplier_lbn_id = zcl_gtt_spof_po_tools=>get_supplier_agent_id( iv_lifnr = cs_po_header-lifnr ).

    ENDIF.
  ENDMETHOD.


  METHOD format_to_remove_leading_zero.
    TRY.
        cs_po_header-ebeln = zcl_gtt_spof_po_tools=>get_tracking_id_po_hdr( ir_ekko = REF #( cs_po_header ) ).
        cs_po_header-lifnr = zcl_gtt_tools=>get_pretty_location_id(
          iv_locid   = cs_po_header-lifnr
          iv_loctype = cs_po_header-lifnr_lt ).
        cs_po_header-werks = zcl_gtt_tools=>get_pretty_location_id(
          iv_locid   = cs_po_header-werks
          iv_loctype = cs_po_header-werks_lt ).
      CATCH cx_udm_message.
    ENDTRY.
  ENDMETHOD.


  METHOD is_object_changed.

    rv_result = zcl_gtt_tools=>is_object_changed(
      is_app_object    = is_app_object
      io_ef_parameters = mo_ef_parameters
      it_check_tables  = VALUE #( ( zif_gtt_spof_app_constants=>cs_tabledef-po_item_new )
                                  ( zif_gtt_spof_app_constants=>cs_tabledef-po_item_old )
                                  ( zif_gtt_spof_app_constants=>cs_tabledef-po_sched_new )
                                  ( zif_gtt_spof_app_constants=>cs_tabledef-po_sched_old ) )
      iv_key_field     = 'EBELN'
      iv_upd_field     = 'KZ' ).

  ENDMETHOD.


  METHOD zif_gtt_tp_reader~check_relevance.

    rv_result   = zif_gtt_ef_constants=>cs_condition-false.

    IF zcl_gtt_spof_po_tools=>is_appropriate_po(
          ir_ekko = is_app_object-maintabref
          ir_ekpo = mo_ef_parameters->get_appl_table( iv_tabledef = zif_gtt_spof_app_constants=>cs_tabledef-po_item_new )
          ) = abap_true.

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

      IF rv_result = zif_gtt_ef_constants=>cs_condition-false.
        IF is_object_changed( is_app_object = is_app_object ) = abap_true.
          rv_result   = zif_gtt_ef_constants=>cs_condition-true.
        ENDIF.
      ENDIF.

    ENDIF.

  ENDMETHOD.


  method ZIF_GTT_TP_READER~GET_APP_OBJ_TYPE_ID.
    rv_appobjid   = zcl_gtt_spof_po_tools=>get_tracking_id_po_hdr(
                        ir_ekko = is_app_object-maintabref ).
  endmethod.


  METHOD zif_gtt_tp_reader~get_data.
    FIELD-SYMBOLS: <ls_header>      TYPE ts_po_header.

    rr_data   = NEW ts_po_header( ).

    ASSIGN rr_data->* TO <ls_header>.

    fill_header_from_ekko_struct(
      EXPORTING
        ir_ekko      = is_app_object-maintabref
      CHANGING
        cs_po_header = <ls_header> ).

    fill_header_from_ekpo_table(
      EXPORTING
        iv_ebeln      = <ls_header>-ebeln
        ir_ekko       = mo_ef_parameters->get_appl_table(
                          iv_tabledef = zif_gtt_spof_app_constants=>cs_tabledef-po_header_new )
        ir_ekpo       = mo_ef_parameters->get_appl_table(
                          iv_tabledef = zif_gtt_spof_app_constants=>cs_tabledef-po_item_new )
      CHANGING
        cs_po_header  = <ls_header> ).

    fill_header_from_eket_table(
      EXPORTING
        iv_ebeln      = <ls_header>-ebeln
        ir_ekpo       = mo_ef_parameters->get_appl_table(
                          iv_tabledef = zif_gtt_spof_app_constants=>cs_tabledef-po_item_new )
        ir_eket       = mo_ef_parameters->get_appl_table(
                          iv_tabledef = zif_gtt_spof_app_constants=>cs_tabledef-po_sched_new )
      CHANGING
        cs_po_header  = <ls_header> ).

    fill_header_location_types(
      CHANGING
        cs_po_header = <ls_header> ).

    fill_header_supplier_lbn_id(
      CHANGING
        cs_po_header = <ls_header> ).

    " Receiving address
    fill_header_receiving_address(
      CHANGING
        cs_po_header = <ls_header> ).

    fill_inbound_dlv_table(
      EXPORTING
        iv_ebeln      = CONV #( zcl_gtt_tools=>get_field_of_structure(
                                  ir_struct_data = is_app_object-maintabref
                                  iv_field_name  = 'EBELN'  ) )
      CHANGING
        cs_po_header = <ls_header> ).

    fill_one_time_location(
      EXPORTING
        ir_ekko      = is_app_object-maintabref
      CHANGING
        cs_po_header = <ls_header> ).

    format_to_remove_leading_zero(
      CHANGING
        cs_po_header = <ls_header> ).

    IF <ls_header>-otl_locid IS INITIAL.
      APPEND INITIAL LINE TO <ls_header>-otl_locid.
    ENDIF.

  ENDMETHOD.


  METHOD zif_gtt_tp_reader~get_data_old.
    FIELD-SYMBOLS: <ls_header>      TYPE ts_po_header.
    DATA:
      lv_ebeln TYPE ekko-ebeln.

    lv_ebeln = zcl_gtt_tools=>get_field_of_structure(
      ir_struct_data = is_app_object-maintabref
      iv_field_name  = 'EBELN' ).

    rr_data   = NEW ts_po_header( ).
    ASSIGN rr_data->* TO <ls_header>.

    fill_header_from_ekko_table(
      EXPORTING
        iv_ebeln      = lv_ebeln
        ir_ekko       = mo_ef_parameters->get_appl_table(
                          iv_tabledef = zif_gtt_spof_app_constants=>cs_tabledef-po_header_old )
      CHANGING
        cs_po_header  = <ls_header> ).

    fill_header_from_ekpo_table(
      EXPORTING
        iv_ebeln      = <ls_header>-ebeln
        ir_ekko       = mo_ef_parameters->get_appl_table(
                          iv_tabledef = zif_gtt_spof_app_constants=>cs_tabledef-po_header_old )
        ir_ekpo       = mo_ef_parameters->get_appl_table(
                          iv_tabledef = zif_gtt_spof_app_constants=>cs_tabledef-po_item_old )
      CHANGING
        cs_po_header  = <ls_header> ).

    fill_header_from_eket_table(
      EXPORTING
        iv_ebeln      = <ls_header>-ebeln
        ir_ekpo       = mo_ef_parameters->get_appl_table(
                          iv_tabledef = zif_gtt_spof_app_constants=>cs_tabledef-po_item_old )
        ir_eket       = mo_ef_parameters->get_appl_table(
                          iv_tabledef = zif_gtt_spof_app_constants=>cs_tabledef-po_sched_old )
      CHANGING
        cs_po_header  = <ls_header> ).

    fill_header_location_types(
      CHANGING
        cs_po_header = <ls_header> ).

    fill_header_supplier_lbn_id(
      CHANGING
        cs_po_header = <ls_header> ).

    " Receiving address
    fill_header_receiving_address(
      CHANGING
        cs_po_header = <ls_header> ).

    fill_inbound_dlv_table(
      EXPORTING
        iv_ebeln     = lv_ebeln
      CHANGING
        cs_po_header = <ls_header> ).

    fill_one_time_location_old(
      EXPORTING
        iv_ebeln     = lv_ebeln
        ir_ekko      = mo_ef_parameters->get_appl_table(
                          iv_tabledef = zif_gtt_spof_app_constants=>cs_tabledef-po_header_old )
      CHANGING
        cs_po_header = <ls_header> ).

    format_to_remove_leading_zero(
      CHANGING
        cs_po_header = <ls_header> ).

    IF <ls_header>-otl_locid IS INITIAL.
      APPEND INITIAL LINE TO <ls_header>-otl_locid.
    ENDIF.

  ENDMETHOD.


  METHOD zif_gtt_tp_reader~get_field_parameter.
    CASE iv_parameter.
      WHEN zif_gtt_ef_constants=>cs_parameter_id-key_field.
        rv_result   = boolc( iv_field_name = cs_mapping-item_num ).
      WHEN OTHERS.
        CLEAR: rv_result.
    ENDCASE.
  ENDMETHOD.


  method ZIF_GTT_TP_READER~GET_MAPPING_STRUCTURE.
     rr_data   = REF #( cs_mapping ).
  endmethod.


  method ZIF_GTT_TP_READER~GET_TRACK_ID_DATA.
    CLEAR et_track_id_data.
    et_track_id_data = VALUE #( BASE et_track_id_data (
        appsys      = mo_ef_parameters->get_appsys( )
        appobjtype  = is_app_object-appobjtype
        appobjid    = is_app_object-appobjid
        trxcod      = zif_gtt_ef_constants=>cs_trxcod-po_number
        trxid       = zcl_gtt_spof_po_tools=>get_tracking_id_po_hdr(
                        ir_ekko = is_app_object-maintabref )
        timzon      = zcl_gtt_tools=>get_system_time_zone( )
        msrid       = space
      ) ).
  endmethod.


  METHOD fill_inbound_dlv_table.

    DATA:
      lt_vbeln   TYPE vbeln_vl_t,
      lv_count   TYPE i,
      lv_line_no TYPE char20.

    zcl_gtt_tools=>get_delivery_by_ref_doc(
      EXPORTING
        iv_vgbel = iv_ebeln
      IMPORTING
        et_vbeln = lt_vbeln ).

    LOOP AT lt_vbeln INTO DATA(ls_vbeln).
      lv_count = lv_count + 1.
      lv_line_no = lv_count.
      CONDENSE lv_line_no NO-GAPS.
      APPEND lv_line_no TO cs_po_header-in_dlv_line_no.

      SHIFT ls_vbeln LEFT DELETING LEADING '0'.
      APPEND ls_vbeln TO cs_po_header-in_dlv_no.
      CLEAR lv_line_no.
    ENDLOOP.

    IF lt_vbeln IS INITIAL.
      APPEND '1' TO cs_po_header-in_dlv_line_no.
      APPEND '' TO cs_po_header-in_dlv_no.
    ENDIF.

  ENDMETHOD.


  METHOD fill_one_time_location.

    FIELD-SYMBOLS:
      <ls_ekko> TYPE /saptrx/mm_po_hdr.

    DATA:
      ls_loc_addr  TYPE addr1_data,
      lv_loc_email TYPE ad_smtpadr,
      lv_loc_tel   TYPE char50.

*   Vendor address
    ASSIGN ir_ekko->* TO <ls_ekko>.
    IF <ls_ekko> IS ASSIGNED.
      IF <ls_ekko>-adrnr IS NOT INITIAL AND <ls_ekko>-lifnr IS NOT INITIAL.
        zcl_gtt_tools=>get_address_from_memory(
          EXPORTING
            iv_addrnumber = <ls_ekko>-adrnr
          IMPORTING
            es_addr       = ls_loc_addr
            ev_email      = lv_loc_email
            ev_telephone  = lv_loc_tel ).

        APPEND |{ <ls_ekko>-lifnr ALPHA = OUT }| TO cs_po_header-otl_locid.
        APPEND zif_gtt_ef_constants=>cs_loc_types-businesspartner TO cs_po_header-otl_loctype.
        APPEND ls_loc_addr-time_zone TO cs_po_header-otl_timezone.
        APPEND ls_loc_addr-name1 TO cs_po_header-otl_description.
        APPEND ls_loc_addr-country TO cs_po_header-otl_country_code.
        APPEND ls_loc_addr-city1 TO cs_po_header-otl_city_name.
        APPEND ls_loc_addr-region TO cs_po_header-otl_region_code.
        APPEND ls_loc_addr-house_num1 TO cs_po_header-otl_house_number.
        APPEND ls_loc_addr-street TO cs_po_header-otl_street_name.
        APPEND ls_loc_addr-post_code1 TO cs_po_header-otl_postal_code.
        APPEND lv_loc_email TO cs_po_header-otl_email_address.
        APPEND lv_loc_tel TO cs_po_header-otl_phone_number.
      ENDIF.
    ELSE.
      MESSAGE e002(zgtt) WITH 'EKKO' INTO DATA(lv_dummy).
      zcl_gtt_tools=>throw_exception( ).
    ENDIF.

  ENDMETHOD.


  METHOD fill_one_time_location_old.

    FIELD-SYMBOLS:
      <ls_ekko> TYPE /saptrx/mm_po_hdr,
      <lt_ekko> TYPE ANY TABLE.

    DATA:
      ls_loc_addr  TYPE addr1_data,
      lv_loc_email TYPE ad_smtpadr,
      lv_loc_tel   TYPE char50.

*   Vendor address
    ASSIGN ir_ekko->* TO <lt_ekko>.
    IF <lt_ekko> IS ASSIGNED.
      LOOP AT <lt_ekko> ASSIGNING <ls_ekko>.
        IF <ls_ekko>-ebeln = iv_ebeln AND <ls_ekko>-adrnr IS NOT INITIAL AND <ls_ekko>-lifnr IS NOT INITIAL.
          zcl_gtt_tools=>get_address_from_db(
            EXPORTING
              iv_addrnumber = <ls_ekko>-adrnr
            IMPORTING
              es_addr       = ls_loc_addr
              ev_email      = lv_loc_email
              ev_telephone  = lv_loc_tel ).

          APPEND |{ <ls_ekko>-lifnr ALPHA = OUT }| TO cs_po_header-otl_locid.
          APPEND zif_gtt_ef_constants=>cs_loc_types-businesspartner TO cs_po_header-otl_loctype.
          APPEND ls_loc_addr-time_zone TO cs_po_header-otl_timezone.
          APPEND ls_loc_addr-name1 TO cs_po_header-otl_description.
          APPEND ls_loc_addr-country TO cs_po_header-otl_country_code.
          APPEND ls_loc_addr-city1 TO cs_po_header-otl_city_name.
          APPEND ls_loc_addr-region TO cs_po_header-otl_region_code.
          APPEND ls_loc_addr-house_num1 TO cs_po_header-otl_house_number.
          APPEND ls_loc_addr-street TO cs_po_header-otl_street_name.
          APPEND ls_loc_addr-post_code1 TO cs_po_header-otl_postal_code.
          APPEND lv_loc_email TO cs_po_header-otl_email_address.
          APPEND lv_loc_tel TO cs_po_header-otl_phone_number.
          EXIT.
        ENDIF.
      ENDLOOP.
    ELSE.
      MESSAGE e002(zgtt) WITH 'EKKO' INTO DATA(lv_dummy).
      zcl_gtt_tools=>throw_exception( ).
    ENDIF.

  ENDMETHOD.
ENDCLASS.
