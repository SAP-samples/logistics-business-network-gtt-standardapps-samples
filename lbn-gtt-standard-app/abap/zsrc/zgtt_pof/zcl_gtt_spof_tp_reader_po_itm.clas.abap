CLASS zcl_gtt_spof_tp_reader_po_itm DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES zif_gtt_tp_reader .

    METHODS constructor
      IMPORTING
        !io_ef_parameters TYPE REF TO zif_gtt_ef_parameters .
  PROTECTED SECTION.
  PRIVATE SECTION.

    TYPES tv_ebelp_txt TYPE char5 .
    TYPES tv_deliv_num TYPE i .
    TYPES tv_deliv_item TYPE char20 .
    TYPES tv_sched_num TYPE i .      "char15
    TYPES:
      tt_deliv_num   TYPE STANDARD TABLE OF tv_deliv_num
                            WITH EMPTY KEY .
    TYPES:
      tt_deliv_item  TYPE STANDARD TABLE OF tv_deliv_item
                            WITH EMPTY KEY .
    TYPES:
      tt_sched_num   TYPE STANDARD TABLE OF tv_sched_num
                            WITH EMPTY KEY .
    TYPES:
      tt_sched_eindt TYPE STANDARD TABLE OF eket-eindt
                            WITH EMPTY KEY .
    TYPES:
      tt_sched_menge TYPE STANDARD TABLE OF eket-menge
                            WITH EMPTY KEY .
    TYPES:
      tt_sched_meins TYPE STANDARD TABLE OF ekpo-meins
                            WITH EMPTY KEY .
    TYPES:
      BEGIN OF ts_po_item,
        ebeln       TYPE ekpo-ebeln,
        ebelp       TYPE tv_ebelp_txt,    "used char type to avoid leading zeros deletion
        lifnr       TYPE ekko-lifnr,
        lifnr_lt    TYPE /saptrx/loc_id_type,
        werks       TYPE ekpo-werks,
        werks_lt    TYPE /saptrx/loc_id_type,
        werks_name  TYPE t001w-name1,
        eindt       TYPE eket-eindt,
        matnr       TYPE ekpo-matnr,
        menge       TYPE ekpo-menge,
        meins       TYPE ekpo-meins,
        txz01       TYPE ekpo-txz01,
        ntgew       TYPE ekpo-ntgew,
        gewei       TYPE ekpo-gewei,
        brgew       TYPE ekpo-brgew,
        volum       TYPE ekpo-volum,
        voleh       TYPE ekpo-voleh,
        netwr       TYPE ekpo-netwr,
        waers       TYPE ekko-waers,
        inco1       TYPE ekpo-inco1,
        incov       TYPE ekko-incov,
        inco2_l     TYPE ekpo-inco2_l,
        elikz       TYPE abap_bool,
        untto       TYPE ekpo-untto,
        uebto       TYPE ekpo-uebto,
        uebtk       TYPE abap_bool,
        rec_addr    TYPE /saptrx/paramval200,
        menge_sum   TYPE ekes-menge,
        adrnr       TYPE ekpo-adrnr,
        deliv_num   TYPE tt_deliv_num,
        deliv_item  TYPE tt_deliv_item,
        sched_num   TYPE tt_sched_num,
        sched_eindt TYPE tt_sched_eindt,
        sched_menge TYPE tt_sched_menge,
        sched_meins TYPE tt_sched_meins,
        umren       TYPE ekpo-umren,
        umrez       TYPE ekpo-umrez,
      END OF ts_po_item .

    CONSTANTS:
      BEGIN OF cs_mapping,
        ebeln       TYPE /saptrx/paramname VALUE 'YN_PO_NUMBER',
        ebelp       TYPE /saptrx/paramname VALUE 'YN_PO_ITEM',
        lifnr       TYPE /saptrx/paramname VALUE 'YN_PO_SUPPLIER_ID',
        lifnr_lt    TYPE /saptrx/paramname VALUE 'YN_PO_SUPPLIER_LOC_TYPE',
        werks       TYPE /saptrx/paramname VALUE 'YN_PO_RECEIVING_LOCATION',
        werks_lt    TYPE /saptrx/paramname VALUE 'YN_PO_RECEIVING_LOC_TYPE',
        werks_name  TYPE /saptrx/paramname VALUE 'YN_PO_PLANT_DESCR',
        eindt       TYPE /saptrx/paramname VALUE 'YN_PO_DELIVERY_DATE',
        matnr       TYPE /saptrx/paramname VALUE 'YN_PO_MATERIAL_ID',
        menge       TYPE /saptrx/paramname VALUE 'YN_PO_ORDER_QUANTITY',
        meins       TYPE /saptrx/paramname VALUE 'YN_PO_UNIT_OF_MEASURE',
        txz01       TYPE /saptrx/paramname VALUE 'YN_PO_MATERIAL_DESCR',
        ntgew       TYPE /saptrx/paramname VALUE 'YN_PO_NET_WEIGHT',
        gewei       TYPE /saptrx/paramname VALUE 'YN_PO_WEIGHT_UOM',
        brgew       TYPE /saptrx/paramname VALUE 'YN_PO_GROSS_WEIGHT',
        volum       TYPE /saptrx/paramname VALUE 'YN_PO_VOLUME',
        voleh       TYPE /saptrx/paramname VALUE 'YN_PO_VOLUME_UOM',
        netwr       TYPE /saptrx/paramname VALUE 'YN_PO_NET_VALUE',
        waers       TYPE /saptrx/paramname VALUE 'YN_PO_CURRENCY',
        inco1       TYPE /saptrx/paramname VALUE 'YN_PO_INCOTERMS',
        incov       TYPE /saptrx/paramname VALUE 'YN_PO_INCOTERMS_VERSION',
        inco2_l     TYPE /saptrx/paramname VALUE 'YN_PO_INCOTERMS_LOCATION',
        elikz       TYPE /saptrx/paramname VALUE 'YN_DL_COMPL_IND',
        untto       TYPE /saptrx/paramname VALUE 'YN_DL_UNDER_TOLERANCE',
        uebto       TYPE /saptrx/paramname VALUE 'YN_DL_OVER_TOLERANCE',
        uebtk       TYPE /saptrx/paramname VALUE 'YN_DL_UNLIMITED_ALLOWED',
        rec_addr    TYPE /saptrx/paramname VALUE 'YN_PO_RECEIVING_ADDRESS',
        menge_sum   TYPE /saptrx/paramname VALUE 'YN_PO_COMFIRMED_QUANTITY',
        adrnr       TYPE /saptrx/paramname VALUE 'YN_PO_ADDRESS_NUMBER',
        deliv_num   TYPE /saptrx/paramname VALUE 'YN_DL_HDR_ITM_LINE_COUNT',
        deliv_item  TYPE /saptrx/paramname VALUE 'YN_DL_HDR_ITM_NO',
        sched_num   TYPE /saptrx/paramname VALUE 'YN_PO_ITM_SCHED_LINE_COUNT',
        sched_eindt TYPE /saptrx/paramname VALUE 'YN_PO_ITM_SCHED_DATE',
        sched_menge TYPE /saptrx/paramname VALUE 'YN_PO_ITM_SCHED_QUANTITY',
        sched_meins TYPE /saptrx/paramname VALUE 'YN_PO_ITM_SCHED_QUANT_UOM',
        umrez       TYPE /saptrx/paramname VALUE 'YN_PO_NUMERATOR_FACTOR',
        umren       TYPE /saptrx/paramname VALUE 'YN_PO_DENOMINATOR_DIVISOR',
      END OF cs_mapping .
    DATA mo_ef_parameters TYPE REF TO zif_gtt_ef_parameters .

    METHODS is_object_changed
      IMPORTING
        !is_app_object   TYPE trxas_appobj_ctab_wa
      RETURNING
        VALUE(rv_result) TYPE abap_bool
      RAISING
        cx_udm_message .
    METHODS fill_item_from_ekko_struct
      IMPORTING
        !ir_ekko    TYPE REF TO data
      CHANGING
        !cs_po_item TYPE ts_po_item
      RAISING
        cx_udm_message .
    METHODS fill_item_from_ekpo_struct
      IMPORTING
        !ir_ekpo    TYPE REF TO data
      CHANGING
        !cs_po_item TYPE ts_po_item
      RAISING
        cx_udm_message .
    METHODS fill_item_from_eket_table
      IMPORTING
        !ir_ekpo    TYPE REF TO data
        !ir_eket    TYPE REF TO data
      CHANGING
        !cs_po_item TYPE ts_po_item
      RAISING
        cx_udm_message .
    METHODS fill_item_location_types
      CHANGING
        !cs_po_item TYPE ts_po_item
      RAISING
        cx_udm_message .
    METHODS get_ekpo_record
      IMPORTING
        !ir_ekpo       TYPE REF TO data
        !iv_ebeln      TYPE ebeln
        !iv_ebelp      TYPE ebelp
      RETURNING
        VALUE(rv_ekpo) TYPE REF TO data
      RAISING
        cx_udm_message .
    METHODS fill_item_from_ekko_table
      IMPORTING
        !ir_ekko    TYPE REF TO data
        !iv_ebeln   TYPE ebeln
      CHANGING
        !cs_po_item TYPE ts_po_item
      RAISING
        cx_udm_message .
    METHODS fill_item_receiving_address
      CHANGING
        !cs_po_item TYPE ts_po_item .
    METHODS fill_confirmed_quantity
      IMPORTING
        !ir_ekpo    TYPE REF TO data
        !ir_ekes    TYPE REF TO data
      CHANGING
        !cs_po_item TYPE ts_po_item .
    METHODS fill_plant_description
      CHANGING
        !cs_po_item TYPE ts_po_item .
    METHODS get_confirmation_quantity
      IMPORTING
        !ir_ekpo        TYPE REF TO data
        !ir_ekes        TYPE REF TO data
      RETURNING
        VALUE(rv_menge) TYPE menge_d
      RAISING
        cx_udm_message .
    METHODS format_to_remove_leading_zero
      CHANGING
        !cs_po_item TYPE ts_po_item .
ENDCLASS.



CLASS ZCL_GTT_SPOF_TP_READER_PO_ITM IMPLEMENTATION.


  METHOD constructor.

    mo_ef_parameters    = io_ef_parameters.

  ENDMETHOD.


  METHOD fill_confirmed_quantity.

    TRY.
        cs_po_item-menge_sum = get_confirmation_quantity(
          EXPORTING
            ir_ekpo = ir_ekpo
            ir_ekes = ir_ekes
        ).
      CATCH cx_udm_message.
    ENDTRY.
  ENDMETHOD.


  METHOD fill_item_from_eket_table.
    TYPES: tt_eket    TYPE STANDARD TABLE OF ueket.

    DATA: lv_sched_num   TYPE tv_sched_num VALUE 0,
          lv_sched_vrkme TYPE lips-vrkme.

    FIELD-SYMBOLS: <lt_eket>  TYPE tt_eket.

    DATA(lv_ebeln) = CONV ebeln( zcl_gtt_tools=>get_field_of_structure(
                                   ir_struct_data = ir_ekpo
                                   iv_field_name  = 'EBELN' ) ).
    DATA(lv_ebelp) = CONV ebelp( zcl_gtt_tools=>get_field_of_structure(
                                   ir_struct_data = ir_ekpo
                                   iv_field_name  = 'EBELP' ) ).
    DATA(lv_meins) = CONV vrkme( zcl_gtt_tools=>get_field_of_structure(
                                   ir_struct_data = ir_ekpo
                                   iv_field_name  = 'MEINS' ) ).
    CLEAR: cs_po_item-eindt,
           cs_po_item-sched_num[],
           cs_po_item-sched_eindt[],
           cs_po_item-sched_menge[],
           cs_po_item-sched_meins[].

    ASSIGN ir_eket->* TO <lt_eket>.

    IF <lt_eket> IS ASSIGNED.
      LOOP AT <lt_eket> ASSIGNING FIELD-SYMBOL(<ls_eket>)
        WHERE ebeln = lv_ebeln
          AND ebelp = lv_ebelp.

        " Latest Delivery Date in schedule lines per item, keep empty in case of
        " different date on item level
        cs_po_item-eindt  = COND #( WHEN <ls_eket>-eindt > cs_po_item-eindt
                                      THEN <ls_eket>-eindt
                                      ELSE cs_po_item-eindt ).

        " add row to schedule line table
        ADD 1 TO lv_sched_num.
        APPEND lv_sched_num    TO cs_po_item-sched_num.
        APPEND <ls_eket>-eindt TO cs_po_item-sched_eindt.
        APPEND <ls_eket>-menge TO cs_po_item-sched_menge.
        APPEND lv_meins        TO cs_po_item-sched_meins.
      ENDLOOP.
    ELSE.
      MESSAGE e002(zgtt) WITH 'EKET' INTO DATA(lv_dummy).
      zcl_gtt_tools=>throw_exception( ).
    ENDIF.
  ENDMETHOD.


  METHOD fill_item_from_ekko_struct.

    DATA: lv_fname TYPE char5,
          lv_dummy TYPE char100.

    FIELD-SYMBOLS: <ls_ekko>  TYPE any,
                   <lv_lifnr> TYPE ekko-lifnr,
                   <lv_waers> TYPE ekko-waers,
                   <lv_incov> TYPE ekko-incov.

    ASSIGN ir_ekko->* TO <ls_ekko>.

    IF <ls_ekko> IS ASSIGNED.
      ASSIGN COMPONENT 'LIFNR' OF STRUCTURE <ls_ekko> TO <lv_lifnr>.
      ASSIGN COMPONENT 'WAERS' OF STRUCTURE <ls_ekko> TO <lv_waers>.
      ASSIGN COMPONENT 'INCOV' OF STRUCTURE <ls_ekko> TO <lv_incov>.

      IF <lv_lifnr> IS ASSIGNED AND
         <lv_waers> IS ASSIGNED AND
         <lv_incov> IS ASSIGNED.

        cs_po_item-lifnr  = <lv_lifnr>.
        cs_po_item-waers  = <lv_waers>.
        cs_po_item-incov  = <lv_incov>.

      ELSE.
        lv_fname  = COND #( WHEN <lv_lifnr> IS NOT ASSIGNED THEN 'LIFNR'
                            WHEN <lv_incov> IS NOT ASSIGNED THEN 'INCOV'
                              ELSE 'WAERS' ).
        MESSAGE e001(zgtt) WITH lv_fname 'EKKO' INTO lv_dummy.
        zcl_gtt_tools=>throw_exception( ).
      ENDIF.
    ELSE.
      MESSAGE e002(zgtt) WITH 'EKKO' INTO lv_dummy.
      zcl_gtt_tools=>throw_exception( ).
    ENDIF.
  ENDMETHOD.


  METHOD fill_item_from_ekko_table.
    DATA: lv_fname TYPE char5,
          lv_dummy TYPE char100.

    FIELD-SYMBOLS: <lt_ekko>  TYPE ANY TABLE,
                   <ls_ekko>  TYPE any,
                   <lv_ebeln> TYPE ekko-ebeln,
                   <lv_lifnr> TYPE ekko-lifnr,
                   <lv_incov> TYPE ekko-incov,
                   <lv_waers> TYPE ekko-waers.

    CLEAR: cs_po_item-lifnr, cs_po_item-waers.

    ASSIGN ir_ekko->* TO <lt_ekko>.

    IF <lt_ekko> IS ASSIGNED.
      LOOP AT <lt_ekko> ASSIGNING <ls_ekko>.
        ASSIGN COMPONENT 'EBELN' OF STRUCTURE <ls_ekko> TO <lv_ebeln>.
        ASSIGN COMPONENT 'LIFNR' OF STRUCTURE <ls_ekko> TO <lv_lifnr>.
        ASSIGN COMPONENT 'INCOV' OF STRUCTURE <ls_ekko> TO <lv_incov>.
        ASSIGN COMPONENT 'WAERS' OF STRUCTURE <ls_ekko> TO <lv_waers>.

        IF <lv_ebeln> IS ASSIGNED AND
           <lv_lifnr> IS ASSIGNED AND
           <lv_incov> IS ASSIGNED AND
           <lv_waers> IS ASSIGNED.

          IF <lv_ebeln> = iv_ebeln.
            cs_po_item-lifnr  = <lv_lifnr>.
            cs_po_item-waers  = <lv_waers>.
            cs_po_item-incov  = <lv_incov>.
          ENDIF.

        ELSE.
          lv_fname  = COND #( WHEN <lv_ebeln> IS NOT ASSIGNED THEN 'EBELN'
                              WHEN <lv_lifnr> IS NOT ASSIGNED THEN 'LIFNR'
                              WHEN <lv_incov> IS NOT ASSIGNED THEN 'INCOV'
                                ELSE 'WAERS' ).
          MESSAGE e001(zgtt) WITH lv_fname 'EKKO' INTO lv_dummy.
          zcl_gtt_tools=>throw_exception( ).
        ENDIF.
      ENDLOOP.
    ELSE.
      MESSAGE e002(zgtt) WITH 'EKKO' INTO lv_dummy.
      zcl_gtt_tools=>throw_exception( ).
    ENDIF.
  ENDMETHOD.


  METHOD fill_item_from_ekpo_struct.
    FIELD-SYMBOLS: <ls_ekpo>  TYPE any.

    ASSIGN ir_ekpo->* TO <ls_ekpo>.

    IF <ls_ekpo> IS ASSIGNED.
      MOVE-CORRESPONDING <ls_ekpo> TO cs_po_item.

      cs_po_item-netwr = zcl_gtt_tools=>convert_to_external_amount(
        iv_currency = cs_po_item-waers
        iv_internal = cs_po_item-netwr ).
    ELSE.
      MESSAGE e002(zgtt) WITH 'EKPO' INTO DATA(lv_dummy).
      zcl_gtt_tools=>throw_exception( ).
    ENDIF.
  ENDMETHOD.


  METHOD fill_item_location_types.
    cs_po_item-lifnr_lt  = zif_gtt_ef_constants=>cs_loc_types-businesspartner.
    cs_po_item-werks_lt  = zif_gtt_ef_constants=>cs_loc_types-plant.
  ENDMETHOD.


  METHOD fill_item_receiving_address.

    IF cs_po_item-adrnr IS INITIAL AND cs_po_item-werks IS NOT INITIAL.
      TRY.
          zcl_gtt_spof_po_tools=>get_plant_address_num_and_name(
            EXPORTING
              iv_werks = cs_po_item-werks
            IMPORTING
              ev_adrnr = cs_po_item-adrnr
          ).
        CATCH cx_udm_message.
      ENDTRY.
    ENDIF.

    IF cs_po_item-adrnr IS NOT INITIAL.
      TRY.
          zcl_gtt_spof_po_tools=>get_address_info(
            EXPORTING
              iv_addr_numb = cs_po_item-adrnr
            IMPORTING
              ev_address   = cs_po_item-rec_addr ).
        CATCH cx_udm_message.
      ENDTRY.
    ENDIF.
  ENDMETHOD.


  METHOD fill_plant_description.
    IF cs_po_item-werks IS NOT INITIAL.
      TRY.
          zcl_gtt_spof_po_tools=>get_plant_address_num_and_name(
            EXPORTING
              iv_werks = cs_po_item-werks
            IMPORTING
              ev_name  = cs_po_item-werks_name
          ).
        CATCH cx_udm_message.
      ENDTRY.
    ENDIF.
  ENDMETHOD.


  METHOD format_to_remove_leading_zero.

    TRY.
        cs_po_item-ebeln = zcl_gtt_spof_po_tools=>get_tracking_id_po_hdr( ir_ekko = REF #( cs_po_item ) ).

        cs_po_item-lifnr = zcl_gtt_tools=>get_pretty_location_id(
          iv_locid   = cs_po_item-lifnr
          iv_loctype = cs_po_item-lifnr_lt ).

        cs_po_item-werks = zcl_gtt_tools=>get_pretty_location_id(
          iv_locid   = cs_po_item-werks
          iv_loctype = cs_po_item-werks_lt ).

        cs_po_item-matnr = zcl_gtt_spof_po_tools=>get_formated_matnr( ir_ekpo = REF #( cs_po_item ) ).
      CATCH cx_udm_message.
    ENDTRY.

  ENDMETHOD.


  METHOD get_confirmation_quantity.
    DATA: lv_has_conf TYPE abap_bool,
          lv_dummy    TYPE char100.

    TYPES: tt_ekes    TYPE STANDARD TABLE OF uekes.

    FIELD-SYMBOLS: <ls_ekpo> TYPE uekpo,
                   <lt_ekes> TYPE tt_ekes,
                   <ls_ekes> TYPE uekes.

    CLEAR rv_menge.

    ASSIGN ir_ekpo->* TO <ls_ekpo>.
    ASSIGN ir_ekes->* TO <lt_ekes>.

    IF <ls_ekpo> IS ASSIGNED AND
       <lt_ekes> IS ASSIGNED.
      LOOP AT <lt_ekes> ASSIGNING <ls_ekes>
        WHERE ebeln = <ls_ekpo>-ebeln
          AND ebelp = <ls_ekpo>-ebelp.

        ADD <ls_ekes>-menge TO rv_menge.
      ENDLOOP.

      DATA(lv_subrc) = sy-subrc.

      rv_menge    = COND #( WHEN lv_subrc <> 0 AND <ls_ekpo>-kzabs = abap_false
                              THEN <ls_ekpo>-menge ELSE rv_menge ).

      rv_menge    = COND #( WHEN lv_subrc <> 0 AND <ls_ekpo>-kzabs = abap_true
                              THEN 0 ELSE rv_menge ).

    ELSEIF <ls_ekpo> IS NOT ASSIGNED.
      MESSAGE e002(zgtt) WITH 'EKPO' INTO lv_dummy.
      zcl_gtt_tools=>throw_exception( ).
    ELSE.
      MESSAGE e002(zgtt) WITH 'EKET' INTO lv_dummy.
      zcl_gtt_tools=>throw_exception( ).
    ENDIF.
  ENDMETHOD.


  METHOD get_ekpo_record.
    TYPES: tt_ekpo    TYPE STANDARD TABLE OF uekpo.

    DATA: lv_dummy    TYPE char100.

    FIELD-SYMBOLS: <lt_ekpo> TYPE tt_ekpo.

    ASSIGN ir_ekpo->* TO <lt_ekpo>.
    IF <lt_ekpo> IS ASSIGNED.
      READ TABLE <lt_ekpo> ASSIGNING FIELD-SYMBOL(<ls_ekpo>)
        WITH KEY ebeln = iv_ebeln
                 ebelp = iv_ebelp.
      IF sy-subrc = 0.
        rv_ekpo   = REF #( <ls_ekpo> ).
      ELSE.
        MESSAGE e005(zgtt) WITH 'EKPO' |{ iv_ebeln }{ iv_ebelp }|
          INTO lv_dummy.
        zcl_gtt_tools=>throw_exception( ).
      ENDIF.
    ELSE.
      MESSAGE e002(zgtt) WITH 'EKPO' INTO lv_dummy.
      zcl_gtt_tools=>throw_exception( ).
    ENDIF.
  ENDMETHOD.


  METHOD is_object_changed.

    rv_result = zcl_gtt_tools=>is_object_changed(
      is_app_object    = is_app_object
      io_ef_parameters = mo_ef_parameters
      it_check_tables  = VALUE #( ( zif_gtt_spof_app_constants=>cs_tabledef-po_sched_new )
                                  ( zif_gtt_spof_app_constants=>cs_tabledef-po_sched_old ) )
      iv_key_field     = 'EBELN'
      iv_upd_field     = 'KZ' ).

  ENDMETHOD.


  method ZIF_GTT_TP_READER~CHECK_RELEVANCE.
    rv_result   = zif_gtt_ef_constants=>cs_condition-false.

    IF zcl_gtt_spof_po_tools=>is_appropriate_po_item( ir_ekpo = is_app_object-maintabref ) = abap_true AND
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


  METHOD zif_gtt_tp_reader~get_app_obj_type_id.
    rv_appobjid = zcl_gtt_spof_po_tools=>get_tracking_id_po_itm(
      ir_ekpo = is_app_object-maintabref ).
  ENDMETHOD.


  METHOD zif_gtt_tp_reader~get_data.
    FIELD-SYMBOLS: <ls_item>      TYPE ts_po_item.

    rr_data   = NEW ts_po_item( ).

    ASSIGN rr_data->* TO <ls_item>.

    fill_item_from_ekko_struct(
      EXPORTING
        ir_ekko    = is_app_object-mastertabref
      CHANGING
        cs_po_item = <ls_item> ).

    fill_item_from_ekpo_struct(
      EXPORTING
        ir_ekpo    = is_app_object-maintabref
      CHANGING
        cs_po_item = <ls_item> ).

    fill_item_from_eket_table(
      EXPORTING
        ir_ekpo       = is_app_object-maintabref
        ir_eket       = mo_ef_parameters->get_appl_table(
                          iv_tabledef = zif_gtt_spof_app_constants=>cs_tabledef-po_sched_new )
      CHANGING
        cs_po_item  = <ls_item> ).

    fill_item_location_types(
      CHANGING
        cs_po_item = <ls_item> ).

    fill_item_receiving_address(
      CHANGING
        cs_po_item = <ls_item> ).

    fill_confirmed_quantity(
      EXPORTING
        ir_ekpo       = is_app_object-maintabref
        ir_ekes       = mo_ef_parameters->get_appl_table(
                          iv_tabledef = zif_gtt_spof_app_constants=>cs_tabledef-po_vend_conf_new )
      CHANGING
        cs_po_item  = <ls_item> ).

    fill_plant_description(
      CHANGING
        cs_po_item = <ls_item> ).

    format_to_remove_leading_zero(
      CHANGING
        cs_po_item = <ls_item> ).
  ENDMETHOD.


  method ZIF_GTT_TP_READER~GET_DATA_OLD.
     FIELD-SYMBOLS: <ls_item>      TYPE ts_po_item.

    DATA(lv_ebeln)  = CONV ebeln( zcl_gtt_tools=>get_field_of_structure(
                                    ir_struct_data = is_app_object-maintabref
                                    iv_field_name  = 'EBELN' ) ).
    DATA(lv_ebelp)  = CONV ebelp( zcl_gtt_tools=>get_field_of_structure(
                                    ir_struct_data = is_app_object-maintabref
                                    iv_field_name  = 'EBELP' ) ).
    DATA(lr_ekpo)   = get_ekpo_record(
                        ir_ekpo  = mo_ef_parameters->get_appl_table(
                                     iv_tabledef = zif_gtt_spof_app_constants=>cs_tabledef-po_item_old )
                        iv_ebeln = lv_ebeln
                        iv_ebelp = lv_ebelp ).

    rr_data   = NEW ts_po_item( ).
    ASSIGN rr_data->* TO <ls_item>.

    fill_item_from_ekko_table(
      EXPORTING
        iv_ebeln      = lv_ebeln
        ir_ekko       = mo_ef_parameters->get_appl_table(
                          iv_tabledef = zif_gtt_spof_app_constants=>cs_tabledef-po_header_old )
      CHANGING
        cs_po_item  = <ls_item> ).

    fill_item_from_ekpo_struct(
      EXPORTING
        ir_ekpo    = lr_ekpo
      CHANGING
        cs_po_item = <ls_item> ).

    fill_item_from_eket_table(
      EXPORTING
        ir_ekpo       = lr_ekpo
        ir_eket       = mo_ef_parameters->get_appl_table(
                          iv_tabledef = zif_gtt_spof_app_constants=>cs_tabledef-po_sched_old )
      CHANGING
        cs_po_item  = <ls_item> ).

    fill_item_location_types(
      CHANGING
        cs_po_item = <ls_item> ).

    fill_item_receiving_address(
      CHANGING
        cs_po_item = <ls_item> ).

    fill_confirmed_quantity(
      EXPORTING
        ir_ekpo       = lr_ekpo
        ir_ekes       = mo_ef_parameters->get_appl_table(
                          iv_tabledef = zif_gtt_spof_app_constants=>cs_tabledef-po_vend_conf_old )
      CHANGING
        cs_po_item  = <ls_item> ).

    fill_plant_description(
      CHANGING
        cs_po_item = <ls_item> ).

    format_to_remove_leading_zero(
      CHANGING
        cs_po_item = <ls_item> ).
  endmethod.


  method ZIF_GTT_TP_READER~GET_FIELD_PARAMETER.
    CASE iv_parameter.
      WHEN zif_gtt_ef_constants=>cs_parameter_id-key_field.
        rv_result   = boolc( iv_field_name = cs_mapping-deliv_num OR
                             iv_field_name = cs_mapping-sched_num ).
      WHEN OTHERS.
        CLEAR: rv_result.
    ENDCASE.
  endmethod.


  METHOD zif_gtt_tp_reader~get_mapping_structure.

    rr_data   = REF #( cs_mapping ).

  ENDMETHOD.


  METHOD zif_gtt_tp_reader~get_track_id_data.
    FIELD-SYMBOLS: <ls_ekpo> TYPE uekpo.
    CLEAR et_track_id_data.

    DATA(lv_tzone)  = zcl_gtt_tools=>get_system_time_zone( ).
    ASSIGN is_app_object-maintabref->* TO <ls_ekpo>.

    IF <ls_ekpo> IS ASSIGNED.
      et_track_id_data = VALUE #( BASE et_track_id_data (
         appsys      = mo_ef_parameters->get_appsys( )
         appobjtype  = is_app_object-appobjtype
         appobjid    = is_app_object-appobjid
         trxcod      = zif_gtt_ef_constants=>cs_trxcod-po_position
         trxid       = zcl_gtt_spof_po_tools=>get_tracking_id_po_itm(
                         ir_ekpo = is_app_object-maintabref )
         timzon      = lv_tzone
         msrid       = space
       ) ).
    ELSE.
      MESSAGE e002(zgtt) WITH 'EKPO' INTO DATA(lv_dummy).
      zcl_gtt_tools=>throw_exception( ).
    ENDIF.
  ENDMETHOD.
ENDCLASS.
