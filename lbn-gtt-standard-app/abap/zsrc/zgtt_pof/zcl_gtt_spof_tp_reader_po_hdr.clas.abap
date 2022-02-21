class ZCL_GTT_SPOF_TP_READER_PO_HDR definition
  public
  create public .

public section.

  interfaces ZIF_GTT_TP_READER .

  methods CONSTRUCTOR
    importing
      !IO_EF_PARAMETERS type ref to ZIF_GTT_EF_PARAMETERS .
  PROTECTED SECTION.
  PRIVATE SECTION.

    TYPES tv_item_num TYPE i .

    TYPES tv_ind_po_itm_del TYPE abap_bool .
    TYPES tv_ind_po_itm_no TYPE char20 .
    TYPES tv_ind_po_no TYPE char10 .
    TYPES:
      tt_ind_po_itm_del   TYPE STANDARD TABLE OF tv_ind_po_itm_del
                            WITH EMPTY KEY .
    TYPES:
      tt_ind_po_itm_no  TYPE STANDARD TABLE OF tv_ind_po_itm_no
                            WITH EMPTY KEY .
    TYPES:
      tt_ind_po_no   TYPE STANDARD TABLE OF tv_ind_po_no
                            WITH EMPTY KEY .
    TYPES:

      tt_item_num TYPE STANDARD TABLE OF tv_item_num WITH EMPTY KEY .
    TYPES tv_ebelp TYPE char15 .
    TYPES:
      tt_ebelp TYPE STANDARD TABLE OF tv_ebelp WITH EMPTY KEY .
    TYPES:
      BEGIN OF ts_po_header,
        ebeln           TYPE ekko-ebeln,
        lifnr           TYPE ekko-lifnr,
        lifnr_lt        TYPE /saptrx/loc_id_type,
        werks           TYPE ekpo-werks,
        werks_lt        TYPE /saptrx/loc_id_type,
        adrnr           TYPE ekpo-adrnr,
        eindt           TYPE eket-eindt,
        netwr           TYPE ekpo-netwr,
        waers           TYPE ekko-waers,
        inco1           TYPE ekko-inco1,
        incov           TYPE ekko-incov,
        inco2_l         TYPE ekko-inco2_l,
        bedat           TYPE ekko-bedat,
        ihrez           TYPE ekko-ihrez,
        aedat           TYPE ekko-aedat,
        item_num        TYPE tt_item_num,
        ebelp           TYPE tt_ebelp,
        supplier_lbn_id TYPE /saptrx/paramval200,
        rec_addr        TYPE /saptrx/paramval200,
        ind_po_no       TYPE tt_ind_po_no,
        ind_po_itm_no   TYPE tt_ind_po_itm_no,
        ind_po_itm_del  TYPE tt_ind_po_itm_del,
      END OF ts_po_header .

    CONSTANTS:
      BEGIN OF cs_mapping,
        ebeln           TYPE /saptrx/paramname VALUE 'YN_PO_NUMBER',
        lifnr           TYPE /saptrx/paramname VALUE 'YN_PO_SUPPLIER_ID',
        lifnr_lt        TYPE /saptrx/paramname VALUE 'YN_PO_SUPPLIER_LOC_TYPE',
        werks           TYPE /saptrx/paramname VALUE 'YN_PO_RECEIVING_LOCATION',
        werks_lt        TYPE /saptrx/paramname VALUE 'YN_PO_RECEIVING_LOC_TYPE',
        adrnr           TYPE /saptrx/paramname VALUE 'YN_PO_ADDRESS_NUMBER',
        eindt           TYPE /saptrx/paramname VALUE 'YN_PO_DELIVERY_DATE',
        netwr           TYPE /saptrx/paramname VALUE 'YN_PO_NET_VALUE',
        waers           TYPE /saptrx/paramname VALUE 'YN_PO_CURRENCY',
        inco1           TYPE /saptrx/paramname VALUE 'YN_PO_INCOTERMS',
        incov           TYPE /saptrx/paramname VALUE 'YN_PO_INCOTERMS_VERSION',
        inco2_l         TYPE /saptrx/paramname VALUE 'YN_PO_INCOTERMS_LOCATION',
        bedat           TYPE /saptrx/paramname VALUE 'YN_PO_DOCUMENT_DATE',
        ihrez           TYPE /saptrx/paramname VALUE 'YN_PO_YOUR_REFERENCE',
        aedat           TYPE /saptrx/paramname VALUE 'YN_PO_CREATION_AT',
        item_num        TYPE /saptrx/paramname VALUE 'YN_PO_HDR_ITM_LINE_COUNT',
        ebelp           TYPE /saptrx/paramname VALUE 'YN_PO_HDR_ITM_NO',
        supplier_lbn_id TYPE /saptrx/paramname VALUE 'YN_PO_SUPPLIER_LBN_ID',
        rec_addr        TYPE /saptrx/paramname VALUE 'YN_PO_RECEIVING_ADDRESS',
        ind_po_no       TYPE /saptrx/paramname VALUE 'YN_PO_IND_PO_NO',
        ind_po_itm_no   TYPE /saptrx/paramname VALUE 'YN_PO_IND_PO_ITEM_NO',
        ind_po_itm_del  TYPE /saptrx/paramname VALUE 'YN_PO_IND_PO_ITEM_DELETED',
      END OF cs_mapping .
    DATA mo_ef_parameters TYPE REF TO zif_gtt_ef_parameters .

    METHODS is_object_changed
      IMPORTING
        !is_app_object   TYPE trxas_appobj_ctab_wa
      RETURNING
        VALUE(rv_result) TYPE abap_bool
      RAISING
        cx_udm_message .
    METHODS fill_header_from_ekko_struct
      IMPORTING
        !ir_ekko      TYPE REF TO data
      CHANGING
        !cs_po_header TYPE ts_po_header
      RAISING
        cx_udm_message .
    METHODS fill_header_from_ekpo_table
      IMPORTING
        !iv_ebeln     TYPE ebeln
        !ir_ekpo      TYPE REF TO data
      CHANGING
        !cs_po_header TYPE ts_po_header
      RAISING
        cx_udm_message .
    METHODS fill_header_from_eket_table
      IMPORTING
        !iv_ebeln     TYPE ebeln
        !ir_ekpo      TYPE REF TO data
        !ir_eket      TYPE REF TO data
      CHANGING
        !cs_po_header TYPE ts_po_header
      RAISING
        cx_udm_message .
    METHODS fill_header_location_types
      CHANGING
        !cs_po_header TYPE ts_po_header
      RAISING
        cx_udm_message .
    METHODS fill_header_from_ekko_table
      IMPORTING
        !iv_ebeln     TYPE ebeln
        !ir_ekko      TYPE REF TO data
      CHANGING
        !cs_po_header TYPE ts_po_header
      RAISING
        cx_udm_message .
    METHODS fill_header_supplier_lbn_id
      CHANGING
        !cs_po_header TYPE ts_po_header .
    METHODS fill_header_receiving_address
      CHANGING
        !cs_po_header TYPE ts_po_header .
    METHODS format_to_remove_leading_zero
      CHANGING
        !cs_po_header TYPE ts_po_header .
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
                   <ls_ekpo>  TYPE any,
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


    ASSIGN ir_ekpo->* TO <lt_ekpo>.

    IF <lt_ekpo> IS ASSIGNED.
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

          IF <lv_ebeln>  = iv_ebeln AND
             zcl_gtt_spof_po_tools=>is_appropriate_po_item( ir_ekpo = REF #( <ls_ekpo> ) ) = abap_true.

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

    cs_po_header-lifnr_lt  = zif_gtt_ef_constants=>cs_loc_types-businesspartner.
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


  method ZIF_GTT_TP_READER~CHECK_RELEVANCE.

    rv_result   = zif_gtt_ef_constants=>cs_condition-false.

    IF zcl_gtt_spof_po_tools=>is_appropriate_po(
          ir_ekko = is_app_object-maintabref
          ir_ekpo = mo_ef_parameters->get_appl_table( iv_tabledef = zif_gtt_spof_app_constants=>cs_tabledef-po_item_new )
          ) = abap_true AND
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
  endmethod.


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

    format_to_remove_leading_zero(
      CHANGING
        cs_po_header = <ls_header> ).
  ENDMETHOD.


  METHOD zif_gtt_tp_reader~get_data_old.
    FIELD-SYMBOLS: <ls_header>      TYPE ts_po_header.

    rr_data   = NEW ts_po_header( ).
    ASSIGN rr_data->* TO <ls_header>.

    fill_header_from_ekko_table(
      EXPORTING
        iv_ebeln      = CONV #( zcl_gtt_tools=>get_field_of_structure(
                                  ir_struct_data = is_app_object-maintabref
                                  iv_field_name  = 'EBELN'
                                ) )
        ir_ekko       = mo_ef_parameters->get_appl_table(
                          iv_tabledef = zif_gtt_spof_app_constants=>cs_tabledef-po_header_old )
      CHANGING
        cs_po_header  = <ls_header> ).

    fill_header_from_ekpo_table(
      EXPORTING
        iv_ebeln      = <ls_header>-ebeln
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

    format_to_remove_leading_zero(
      CHANGING
        cs_po_header = <ls_header> ).
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
ENDCLASS.
