class ZCL_GTT_MIA_TP_READER_DLI definition
  public
  create public .

public section.

  interfaces ZIF_GTT_TP_READER .

  methods CONSTRUCTOR
    importing
      !IO_EF_PARAMETERS type ref to ZIF_GTT_EF_PARAMETERS .
  PROTECTED SECTION.
private section.

  types TV_POSNR_TXT type CHAR6 .
  types TV_PO_ITEM type CHAR20 .
  types TV_LINE_NO type I .
  types TV_FREIGHTUNIT type /SCMTMS/TOR_ID .
  types TV_ITEMNUMBER type /SCMTMS/ITEM_ID .
  types TV_QUANTITY type MENGE_D .
  types TV_QUANTITYUOM type MEINS .
  types TV_PRODUCT_ID type /SCMTMS/PRODUCT_ID .
  types TV_PRODUCT_DESCR type /SCMTMS/ITEM_DESCRIPTION .
  types tv_logsys TYPE  /SAPTRX/APPLSYSTEM.
  types:
    tt_line_no TYPE STANDARD TABLE OF tv_line_no
                          WITH EMPTY KEY .
  types:
    tt_freightunit  TYPE STANDARD TABLE OF tv_freightunit
                          WITH EMPTY KEY .
  types:
    tt_itemnumber   TYPE STANDARD TABLE OF tv_itemnumber
                          WITH EMPTY KEY .
  types:
    tt_quantity TYPE STANDARD TABLE OF tv_quantity WITH EMPTY KEY .
  types:
    tt_quantityuom  TYPE STANDARD TABLE OF tv_quantityuom
                        WITH EMPTY KEY .
  types:
    tt_product_id   TYPE STANDARD TABLE OF tv_product_id
                          WITH EMPTY KEY .
  types:
    tt_product_descr TYPE STANDARD TABLE OF tv_product_descr WITH EMPTY KEY .
   types:
    tt_logsys        TYPE STANDARD TABLE OF tv_logsys WITH EMPTY KEY .
   types:
    tt_appsys        TYPE STANDARD TABLE OF tv_logsys WITH EMPTY KEY .
   types:
    tt_trxcod        type STANDARD TABLE OF /SAPTRX/TRXCOD WITH EMPTY KEY .
   types:
    tt_trxid         type STANDARD TABLE OF /SAPTRX/TRXID WITH EMPTY KEY .
  types:
    BEGIN OF ts_dl_item,
      " Header section
      vbeln     TYPE lips-vbeln,
      posnr     TYPE tv_posnr_txt,
      arktx     TYPE lips-arktx,
      matnr     TYPE lips-matnr,
      charg     TYPE lips-charg,         "MIA
      lgobe     TYPE t001l-lgobe,        "MIA
      lfimg     TYPE lips-lfimg,
      vrkme     TYPE lips-vrkme,
      " Departure section
      lifnr     TYPE likp-lifnr,
      lifnr_lt  TYPE /saptrx/loc_id_type,
      dep_addr  TYPE /saptrx/paramval200,
      dep_email TYPE /saptrx/paramval200,
      dep_tel   TYPE /saptrx/paramval200,
      " Destination section
      werks     TYPE lips-werks,
      werks_lt  TYPE /saptrx/loc_id_type,
      dest_addr TYPE /saptrx/paramval200,
      lgnum     TYPE lips-lgnum,
      lgtor     TYPE lips-lgtor,
      lgnum_txt TYPE /saptrx/paramval200,
      " Others
      bldat     TYPE likp-bldat,
      lfdat     TYPE likp-lfdat,
      brgew     TYPE lips-brgew,
      ntgew     TYPE lips-ntgew,
      gewei     TYPE likp-gewei,
      volum     TYPE lips-volum,
      voleh     TYPE lips-voleh,
      bolnr     TYPE likp-bolnr,
      profl     TYPE lips-profl,
      incov     TYPE likp-incov,
      inco1     TYPE likp-inco1,
      inco2_l   TYPE likp-inco2_l,
      po_item   TYPE tv_po_item,
      umvkz     TYPE lips-umvkz,
      umvkn     TYPE lips-umvkn,
    END OF ts_dl_item .
  types:
    BEGIN OF ts_dl_item_with_fu,
      " Header section
      vbeln     TYPE lips-vbeln,
      posnr     TYPE tv_posnr_txt,
      arktx     TYPE lips-arktx,
      matnr     TYPE lips-matnr,
      charg     TYPE lips-charg,         "MIA
      lgobe     TYPE t001l-lgobe,        "MIA
      lfimg     TYPE lips-lfimg,
      vrkme     TYPE lips-vrkme,
      " Departure section
      lifnr     TYPE likp-lifnr,
      lifnr_lt  TYPE /saptrx/loc_id_type,
      dep_addr  TYPE /saptrx/paramval200,
      dep_email TYPE /saptrx/paramval200,
      dep_tel   TYPE /saptrx/paramval200,
      " Destination section
      werks     TYPE lips-werks,
      werks_lt  TYPE /saptrx/loc_id_type,
      dest_addr TYPE /saptrx/paramval200,
      lgnum     TYPE lips-lgnum,
      lgtor     TYPE lips-lgtor,
      lgnum_txt TYPE /saptrx/paramval200,
      " Others
      bldat     TYPE likp-bldat,
      lfdat     TYPE likp-lfdat,
      brgew     TYPE lips-brgew,
      ntgew     TYPE lips-ntgew,
      gewei     TYPE likp-gewei,
      volum     TYPE lips-volum,
      voleh     TYPE lips-voleh,
      bolnr     TYPE likp-bolnr,
      profl     TYPE lips-profl,
      incov     TYPE likp-incov,
      inco1     TYPE likp-inco1,
      inco2_l   TYPE likp-inco2_l,
      po_item   TYPE tv_po_item,
      umvkz     TYPE lips-umvkz,
      umvkn     TYPE lips-umvkn,
      " FU items
      fu_lineno        TYPE tt_line_no,
      fu_freightunit   TYPE tt_freightunit,
      fu_itemnumber    TYPE tt_itemnumber,
      fu_quantity      TYPE tt_quantity,
      fu_quantityuom   TYPE tt_quantityuom,
      fu_product_id    TYPE tt_product_id,
      fu_product_descr TYPE tt_product_descr,
      fu_no_logsys     type tt_logsys,
      appsys           TYPE tt_appsys,
      trxcod           type tt_trxcod,
      trxid            type tt_trxid,
  END OF ts_dl_item_with_fu .

  constants:
    BEGIN OF cs_mapping,
      " Header section
      vbeln     TYPE /saptrx/paramname VALUE 'YN_DL_DELEVERY',
      posnr     TYPE /saptrx/paramname VALUE 'YN_DL_DELEVERY_ITEM',
      arktx     TYPE /saptrx/paramname VALUE 'YN_DL_ITEM_DESCR',
      matnr     TYPE /saptrx/paramname VALUE 'YN_DL_MATERIAL_ID',
      charg     TYPE /saptrx/paramname VALUE 'YN_DL_MATERIAL_BATCH',       "MIA
      lgobe     TYPE /saptrx/paramname VALUE 'YN_DL_STORAGE_LOCATION_TXT', "MIA
      lfimg     TYPE /saptrx/paramname VALUE 'YN_DL_ORDER_QUANT',
      vrkme     TYPE /saptrx/paramname VALUE 'YN_DL_ORDER_UNITS',
      " Departure section
      lifnr     TYPE /saptrx/paramname VALUE 'YN_DL_VENDOR_ID',
      lifnr_lt  TYPE /saptrx/paramname VALUE 'YN_DL_VENDOR_LOC_TYPE',
      dep_addr  TYPE /saptrx/paramname VALUE 'YN_DL_DEPART_ADDRESS',
      dep_email TYPE /saptrx/paramname VALUE 'YN_DL_DEPART_EMAIL',
      dep_tel   TYPE /saptrx/paramname VALUE 'YN_DL_DEPART_TEL',
      " Destination section
      werks     TYPE /saptrx/paramname VALUE 'YN_DL_PLANT',
      werks_lt  TYPE /saptrx/paramname VALUE 'YN_DL_PLANT_LOC_TYPE',
      dest_addr TYPE /saptrx/paramname VALUE 'YN_DL_DESTIN_ADDRESS',
      lgnum     TYPE /saptrx/paramname VALUE 'YN_DL_WAREHOUSE',
      lgnum_txt TYPE /saptrx/paramname VALUE 'YN_DL_WAREHOUSE_DESC',
      lgtor     TYPE /saptrx/paramname VALUE 'YN_DL_DOOR',
      " Others
      bldat     TYPE /saptrx/paramname VALUE 'YN_DL_DOCUMENT_DATE',
      lfdat     TYPE /saptrx/paramname VALUE 'YN_DL_PLANNED_DLV_DATE',
      brgew     TYPE /saptrx/paramname VALUE 'YN_DL_GROSS_WEIGHT',
      ntgew     TYPE /saptrx/paramname VALUE 'YN_DL_NET_WEIGHT',
      gewei     TYPE /saptrx/paramname VALUE 'YN_DL_WEIGHT_UNITS',
      volum     TYPE /saptrx/paramname VALUE 'YN_DL_VOLUME',
      voleh     TYPE /saptrx/paramname VALUE 'YN_DL_VOLUME_UNITS',
      bolnr     TYPE /saptrx/paramname VALUE 'YN_DL_BILL_OF_LADING',
      profl     TYPE /saptrx/paramname VALUE 'YN_DL_DANGEROUS_GOODS',
      incov     TYPE /saptrx/paramname VALUE 'YN_DL_INCOTERMS_VERSION',
      inco1     TYPE /saptrx/paramname VALUE 'YN_DL_INCOTERMS',
      inco2_l   TYPE /saptrx/paramname VALUE 'YN_DL_INCOTERMS_LOCATION',
      po_item   TYPE /saptrx/paramname VALUE 'YN_DL_ASSOC_POITEM_NO',
      umvkz     TYPE /saptrx/paramname VALUE 'YN_DL_NUMERATOR_FACTOR',
      umvkn     TYPE /saptrx/paramname VALUE 'YN_DL_DENOMINATOR_DIVISOR',
    END OF cs_mapping .
  constants:
    BEGIN OF cs_mapping_with_fu,
      " Header section
      vbeln            TYPE /saptrx/paramname VALUE 'YN_DL_DELEVERY',
      posnr            TYPE /saptrx/paramname VALUE 'YN_DL_DELEVERY_ITEM',
      arktx            TYPE /saptrx/paramname VALUE 'YN_DL_ITEM_DESCR',
      matnr            TYPE /saptrx/paramname VALUE 'YN_DL_MATERIAL_ID',
      charg            TYPE /saptrx/paramname VALUE 'YN_DL_MATERIAL_BATCH',       "MIA
      lgobe            TYPE /saptrx/paramname VALUE 'YN_DL_STORAGE_LOCATION_TXT', "MIA
      lfimg            TYPE /saptrx/paramname VALUE 'YN_DL_ORDER_QUANT',
      vrkme            TYPE /saptrx/paramname VALUE 'YN_DL_ORDER_UNITS',
      " Departure section
      lifnr            TYPE /saptrx/paramname VALUE 'YN_DL_VENDOR_ID',
      lifnr_lt         TYPE /saptrx/paramname VALUE 'YN_DL_VENDOR_LOC_TYPE',
      dep_addr         TYPE /saptrx/paramname VALUE 'YN_DL_DEPART_ADDRESS',
      dep_email        TYPE /saptrx/paramname VALUE 'YN_DL_DEPART_EMAIL',
      dep_tel          TYPE /saptrx/paramname VALUE 'YN_DL_DEPART_TEL',
      " Destination section
      werks            TYPE /saptrx/paramname VALUE 'YN_DL_PLANT',
      werks_lt         TYPE /saptrx/paramname VALUE 'YN_DL_PLANT_LOC_TYPE',
      dest_addr        TYPE /saptrx/paramname VALUE 'YN_DL_DESTIN_ADDRESS',
      lgnum            TYPE /saptrx/paramname VALUE 'YN_DL_WAREHOUSE',
      lgnum_txt        TYPE /saptrx/paramname VALUE 'YN_DL_WAREHOUSE_DESC',
      lgtor            TYPE /saptrx/paramname VALUE 'YN_DL_DOOR',
      " Others
      bldat            TYPE /saptrx/paramname VALUE 'YN_DL_DOCUMENT_DATE',
      lfdat            TYPE /saptrx/paramname VALUE 'YN_DL_PLANNED_DLV_DATE',
      brgew            TYPE /saptrx/paramname VALUE 'YN_DL_GROSS_WEIGHT',
      ntgew            TYPE /saptrx/paramname VALUE 'YN_DL_NET_WEIGHT',
      gewei            TYPE /saptrx/paramname VALUE 'YN_DL_WEIGHT_UNITS',
      volum            TYPE /saptrx/paramname VALUE 'YN_DL_VOLUME',
      voleh            TYPE /saptrx/paramname VALUE 'YN_DL_VOLUME_UNITS',
      bolnr            TYPE /saptrx/paramname VALUE 'YN_DL_BILL_OF_LADING',
      profl            TYPE /saptrx/paramname VALUE 'YN_DL_DANGEROUS_GOODS',
      incov            TYPE /saptrx/paramname VALUE 'YN_DL_INCOTERMS_VERSION',
      inco1            TYPE /saptrx/paramname VALUE 'YN_DL_INCOTERMS',
      inco2_l          TYPE /saptrx/paramname VALUE 'YN_DL_INCOTERMS_LOCATION',
      po_item          TYPE /saptrx/paramname VALUE 'YN_DL_ASSOC_POITEM_NO',
      umvkz            TYPE /saptrx/paramname VALUE 'YN_DL_NUMERATOR_FACTOR',
      umvkn            TYPE /saptrx/paramname VALUE 'YN_DL_DENOMINATOR_DIVISOR',
      " FU fields
      fu_lineno        TYPE /saptrx/paramname VALUE 'YN_DL_FU_LINE_COUNT',
      fu_freightunit   TYPE /saptrx/paramname VALUE 'YN_DL_FU_NO',
      fu_itemnumber    TYPE /saptrx/paramname VALUE 'YN_DL_FU_ITEM_NO',
      fu_quantity      TYPE /saptrx/paramname VALUE 'YN_DL_FU_QUANTITY',
      fu_quantityuom   TYPE /saptrx/paramname VALUE 'YN_DL_FU_UNITS',
      fu_product_id    TYPE /saptrx/paramname VALUE 'YN_DL_FU_PRODUCT',
      fu_product_descr TYPE /saptrx/paramname VALUE 'YN_DL_FU_PRODUCT_DESCR',
      fu_no_logsys     TYPE /saptrx/paramname VALUE 'YN_DL_FU_NO_LOGSYS',
      appsys           TYPE /saptrx/paramname VALUE 'E1EHPTID_APPSYS',
      trxcod           TYPE /saptrx/paramname VALUE 'E1EHPTID_TRXCOD',
      trxid            TYPE /saptrx/paramname VALUE 'E1EHPTID_TRXID',
    END OF cs_mapping_with_fu .
  constants CV_POSNR_EMPTY type POSNR_VL value '000000' ##NO_TEXT.
  data MO_EF_PARAMETERS type ref to ZIF_GTT_EF_PARAMETERS .
  data CHANGE_MODE type UPDKZ_D .

  methods FILL_ITEM_FROM_LIKP_STRUCT
    importing
      !IR_LIKP type ref to DATA
    changing
      !CS_DL_ITEM type TS_DL_ITEM
    raising
      CX_UDM_MESSAGE .
  methods FILL_ITEM_FROM_LIPS_STRUCT
    importing
      !IR_LIPS type ref to DATA
    changing
      !CS_DL_ITEM type TS_DL_ITEM
    raising
      CX_UDM_MESSAGE .
  methods FILL_ITEM_FROM_VBPA_TABLE
    importing
      !IR_VBPA type ref to DATA
      !IV_VBELN type VBELN_VL
      !IV_POSNR type POSNR_VL
    changing
      !CS_DL_ITEM type TS_DL_ITEM
    raising
      CX_UDM_MESSAGE .
  methods FILL_ITEM_LOCATION_TYPES
    changing
      !CS_DL_ITEM type TS_DL_ITEM .
  methods FORMAT_ITEM_LOCATION_IDS
    changing
      !CS_DL_ITEM type TS_DL_ITEM .
  methods GET_LIKP_STRUCT_OLD
    importing
      !IS_APP_OBJECT type TRXAS_APPOBJ_CTAB_WA
      !IV_VBELN type VBELN_VL
    returning
      value(RR_LIKP) type ref to DATA
    raising
      CX_UDM_MESSAGE .
  methods GET_LIPS_STRUCT_OLD
    importing
      !IS_APP_OBJECT type TRXAS_APPOBJ_CTAB_WA
      !IV_VBELN type VBELN_VL
      !IV_POSNR type POSNR_VL
    returning
      value(RR_LIPS) type ref to DATA
    raising
      CX_UDM_MESSAGE .
  methods GET_VBPA_TABLE_OLD
    importing
      !IS_APP_OBJECT type TRXAS_APPOBJ_CTAB_WA
      !IV_VBELN type VBELN_VL
      !IV_POSNR type POSNR_VL
    returning
      value(RR_VBPA) type ref to DATA
    raising
      CX_UDM_MESSAGE .
  methods IS_OBJECT_CHANGED
    importing
      !IS_APP_OBJECT type TRXAS_APPOBJ_CTAB_WA
    returning
      value(RV_RESULT) type ABAP_BOOL
    raising
      CX_UDM_MESSAGE .
  methods GET_TOR_ITEMS_FOR_DLV_ITEM
    importing
      !IR_LIPS type ref to DATA
    exporting
      !ET_TOR_ID type ZIF_GTT_MIA_CTP_TYPES=>TT_FU_ID
      !ET_TOR_ITEM type ZIF_GTT_MIA_CTP_TYPES=>TT_FU_LIST
    raising
      CX_UDM_MESSAGE .
ENDCLASS.



CLASS ZCL_GTT_MIA_TP_READER_DLI IMPLEMENTATION.


  METHOD CONSTRUCTOR.

    mo_ef_parameters    = io_ef_parameters.

  ENDMETHOD.


  METHOD FILL_ITEM_FROM_LIKP_STRUCT.

    FIELD-SYMBOLS: <ls_likp>  TYPE likpvb.

    ASSIGN ir_likp->* TO <ls_likp>.

    IF <ls_likp> IS ASSIGNED.
      MOVE-CORRESPONDING <ls_likp> TO cs_dl_item.

      cs_dl_item-vbeln = zcl_gtt_mia_dl_tools=>get_formated_dlv_number(
        ir_likp = ir_likp ).

    ELSE.
      MESSAGE e002(zgtt) WITH 'LIKP' INTO DATA(lv_dummy).
      zcl_gtt_tools=>throw_exception( ).
    ENDIF.

  ENDMETHOD.


  METHOD FILL_ITEM_FROM_LIPS_STRUCT.

    FIELD-SYMBOLS: <ls_lips> TYPE lipsvb.

    DATA(lv_lgtor_old) = cs_dl_item-lgtor.

    ASSIGN ir_lips->* TO <ls_lips>.

    IF <ls_lips> IS ASSIGNED.
      MOVE-CORRESPONDING <ls_lips> TO cs_dl_item.

      cs_dl_item-vbeln = zcl_gtt_mia_dl_tools=>get_formated_dlv_number(
        ir_likp = ir_lips ).
      cs_dl_item-posnr = zcl_gtt_mia_dl_tools=>get_formated_dlv_item(
        ir_lips = REF #( <ls_lips> ) ).

      cs_dl_item-profl  = boolc( cs_dl_item-profl IS NOT INITIAL ).

      cs_dl_item-lgtor  = COND #( WHEN cs_dl_item-lgtor IS NOT INITIAL
                                    THEN cs_dl_item-lgtor
                                    ELSE lv_lgtor_old ).
      TRY.
          zcl_gtt_mia_dl_tools=>get_addres_info(
            EXPORTING
              iv_addr_numb = zcl_gtt_mia_dl_tools=>get_plant_address_number(
                               iv_werks = <ls_lips>-werks )
            IMPORTING
              ev_address   = cs_dl_item-dest_addr ).

        CATCH cx_udm_message.
      ENDTRY.

      IF cs_dl_item-lgnum IS NOT INITIAL AND
         cs_dl_item-lgtor IS NOT INITIAL.
        TRY.
            cs_dl_item-lgnum_txt = zcl_gtt_mia_dl_tools=>get_door_description(
              EXPORTING
                iv_lgnum = cs_dl_item-lgnum
                iv_lgtor = cs_dl_item-lgtor ).
          CATCH cx_udm_message.
        ENDTRY.
      ENDIF.

      IF <ls_lips>-werks IS NOT INITIAL AND
         <ls_lips>-lgort IS NOT INITIAL.
        TRY.
            cs_dl_item-lgobe = zcl_gtt_mia_dl_tools=>get_storage_location_txt(
              iv_werks = <ls_lips>-werks
              iv_lgort = <ls_lips>-lgort ).
          CATCH cx_udm_message.
        ENDTRY.
      ENDIF.

      cs_dl_item-po_item = zcl_gtt_mia_dl_tools=>get_formated_po_item(
        ir_lips = ir_lips ).
    ELSE.
      MESSAGE e002(zgtt) WITH 'LIKP' INTO DATA(lv_dummy).
      zcl_gtt_tools=>throw_exception( ).
    ENDIF.

  ENDMETHOD.


  METHOD FILL_ITEM_FROM_VBPA_TABLE.

    TYPES: tt_vbpa TYPE STANDARD TABLE OF vbpavb.

    FIELD-SYMBOLS: <lt_vbpa>      TYPE tt_vbpa,
                   <ls_vbpa>      TYPE vbpavb,
                   <lv_addr_type> TYPE any.

    ASSIGN ir_vbpa->* TO <lt_vbpa>.

    IF <lt_vbpa> IS ASSIGNED.
      READ TABLE <lt_vbpa> ASSIGNING <ls_vbpa>
        WITH KEY vbeln = iv_vbeln
                 posnr = iv_posnr
                 parvw = zif_gtt_mia_app_constants=>cs_parvw-supplier.

      IF sy-subrc = 0.
        ASSIGN COMPONENT 'ADDR_TYPE' OF STRUCTURE <ls_vbpa> TO <lv_addr_type>.
        TRY.
            zcl_gtt_mia_dl_tools=>get_addres_info(
              EXPORTING
                iv_addr_type = COND #( WHEN <lv_addr_type> IS ASSIGNED AND
                                            <lv_addr_type> IS NOT INITIAL
                                         THEN <lv_addr_type>
                                         ELSE zif_gtt_mia_app_constants=>cs_adrtype-organization )
                iv_addr_numb = <ls_vbpa>-adrnr
              IMPORTING
                ev_address   = cs_dl_item-dep_addr
                ev_email     = cs_dl_item-dep_email
                ev_telephone = cs_dl_item-dep_tel ).
          CATCH cx_udm_message.
        ENDTRY.
      ENDIF.
    ELSE.
      MESSAGE e002(zgtt) WITH 'VBPA' INTO DATA(lv_dummy).
      zcl_gtt_tools=>throw_exception( ).
    ENDIF.

  ENDMETHOD.


  METHOD FILL_ITEM_LOCATION_TYPES.

    cs_dl_item-lifnr_lt   = zif_gtt_ef_constants=>cs_loc_types-businesspartner.
    cs_dl_item-werks_lt   = zif_gtt_ef_constants=>cs_loc_types-plant.

  ENDMETHOD.


  METHOD FORMAT_ITEM_LOCATION_IDS.
    cs_dl_item-lifnr = zcl_gtt_tools=>get_pretty_location_id(
      iv_locid   = cs_dl_item-lifnr
      iv_loctype = cs_dl_item-lifnr_lt ).

    cs_dl_item-werks = zcl_gtt_tools=>get_pretty_location_id(
      iv_locid   = cs_dl_item-werks
      iv_loctype = cs_dl_item-werks_lt ).
  ENDMETHOD.


  METHOD GET_LIKP_STRUCT_OLD.

    " when header is unchanged, table 'DELIVERY_HEADER_OLD' is not populated
    " so mastertab record is used as data source for header data
    TYPES: tt_likp TYPE STANDARD TABLE OF likpvb.

    FIELD-SYMBOLS: <lt_likp> TYPE tt_likp,
                   <ls_likp> TYPE likpvb.

    DATA(lr_likp) = mo_ef_parameters->get_appl_table(
      iv_tabledef = zif_gtt_mia_app_constants=>cs_tabledef-dl_header_old ).

    ASSIGN lr_likp->* TO <lt_likp>.

    IF <lt_likp> IS ASSIGNED.
      READ TABLE <lt_likp> ASSIGNING <ls_likp>
        WITH KEY vbeln = iv_vbeln.

      rr_likp   = COND #( WHEN sy-subrc = 0
                            THEN REF #( <ls_likp> )
                            ELSE is_app_object-mastertabref ).
    ELSE.
      MESSAGE e002(zgtt) WITH 'LIKP' INTO DATA(lv_dummy).
      zcl_gtt_tools=>throw_exception( ).
    ENDIF.

  ENDMETHOD.


  METHOD GET_LIPS_STRUCT_OLD.

    " when item is unchanged, it is absent in table 'DELIVERY_ITEM_OLD'
    " so maintab record is used as data source for item data
    TYPES: tt_lips TYPE STANDARD TABLE OF lipsvb.

    FIELD-SYMBOLS: <lt_lips> TYPE tt_lips,
                   <ls_lips> TYPE lipsvb.

    DATA(lr_lips) = mo_ef_parameters->get_appl_table(
      iv_tabledef = zif_gtt_mia_app_constants=>cs_tabledef-dl_item_old ).

    ASSIGN lr_lips->* TO <lt_lips>.

    IF <lt_lips> IS ASSIGNED.
      READ TABLE <lt_lips> ASSIGNING <ls_lips>
        WITH KEY vbeln = iv_vbeln
                 posnr = iv_posnr.

      rr_lips   = COND #( WHEN sy-subrc = 0
                            THEN REF #( <ls_lips> )
                            ELSE is_app_object-maintabref ).
    ELSE.
      MESSAGE e002(zgtt) WITH 'LIPS' INTO DATA(lv_dummy).
      zcl_gtt_tools=>throw_exception( ).
    ENDIF.

  ENDMETHOD.


  METHOD GET_VBPA_TABLE_OLD.

    " when partner data is unchanged, it is absent in table 'PARTNERS_OLD'
    " so 'PARTNERS_NEW' is used as data source for partner data
    TYPES: tt_vbpa TYPE STANDARD TABLE OF vbpavb.

    FIELD-SYMBOLS: <lt_vbpa> TYPE tt_vbpa,
                   <ls_vbpa> TYPE vbpavb.

    DATA(lr_vbpa) = mo_ef_parameters->get_appl_table(
      iv_tabledef = zif_gtt_mia_app_constants=>cs_tabledef-dl_partners_old ).

    ASSIGN lr_vbpa->* TO <lt_vbpa>.

    IF <lt_vbpa> IS ASSIGNED.
      READ TABLE <lt_vbpa> ASSIGNING <ls_vbpa>
        WITH KEY vbeln = iv_vbeln
                 posnr = iv_posnr
                 parvw = zif_gtt_mia_app_constants=>cs_parvw-supplier.

      rr_vbpa = COND #( WHEN sy-subrc = 0
                          THEN lr_vbpa
                          ELSE mo_ef_parameters->get_appl_table(
                                 iv_tabledef = zif_gtt_mia_app_constants=>cs_tabledef-dl_partners_new ) ).
    ELSE.
      MESSAGE e002(zgtt) WITH 'VBPA' INTO DATA(lv_dummy).
      zcl_gtt_tools=>throw_exception( ).
    ENDIF.

  ENDMETHOD.


  METHOD IS_OBJECT_CHANGED.

    rv_result = zcl_gtt_tools=>is_object_changed(
      is_app_object    = is_app_object
      io_ef_parameters = mo_ef_parameters
      it_check_tables  = VALUE #( ( zif_gtt_mia_app_constants=>cs_tabledef-dl_partners_new )
                                  ( zif_gtt_mia_app_constants=>cs_tabledef-dl_partners_old ) )
      iv_key_field     = 'VBELN'
      iv_upd_field     = 'UPDKZ'
      iv_chk_mastertab = abap_true ).

  ENDMETHOD.


  METHOD ZIF_GTT_TP_READER~CHECK_RELEVANCE.

    rv_result   = zif_gtt_ef_constants=>cs_condition-false.

    IF zcl_gtt_mia_dl_tools=>is_appropriate_dl_type( ir_struct = is_app_object-mastertabref ) = abap_true AND
       zcl_gtt_mia_dl_tools=>is_appropriate_dl_item( ir_struct = is_app_object-maintabref ) = abap_true AND
       is_object_changed( is_app_object = is_app_object ) = abap_true.

      CASE is_app_object-update_indicator.
        WHEN zif_gtt_ef_constants=>cs_change_mode-insert.
          change_mode = zif_gtt_ef_constants=>cs_change_mode-insert.
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
    rv_appobjid = zcl_gtt_mia_dl_tools=>get_tracking_id_dl_item(
      ir_lips = is_app_object-maintabref ).
  ENDMETHOD.


  METHOD zif_gtt_tp_reader~get_data.

    DATA: ls_item         TYPE ts_dl_item,
          ls_item_with_fu TYPE ts_dl_item_with_fu.
    DATA: lv_count        TYPE i VALUE 0.
    FIELD-SYMBOLS: <ls_lips>  TYPE lipsvb.

    ASSIGN is_app_object-maintabref->* TO <ls_lips>.
    IF <ls_lips> IS ASSIGNED.
      change_mode = <ls_lips>-updkz. " Save change mode to determinate cs_mapping!
    ENDIF.

    fill_item_from_likp_struct(
      EXPORTING
        ir_likp    = is_app_object-mastertabref
      CHANGING
        cs_dl_item = ls_item ).

    fill_item_from_lips_struct(
      EXPORTING
        ir_lips    = is_app_object-maintabref
      CHANGING
        cs_dl_item = ls_item ).

    fill_item_from_vbpa_table(
      EXPORTING
        ir_vbpa    = mo_ef_parameters->get_appl_table(
                          iv_tabledef = zif_gtt_mia_app_constants=>cs_tabledef-dl_partners_new )
        iv_vbeln   = |{ ls_item-vbeln ALPHA = IN }|
        iv_posnr   = cv_posnr_empty
      CHANGING
        cs_dl_item = ls_item ).

    fill_item_location_types(
      CHANGING
        cs_dl_item = ls_item ).

    format_item_location_ids(
      CHANGING
        cs_dl_item = ls_item ).

    ls_item_with_fu = CORRESPONDING #( ls_item ).
    " Give FU number in the tracking id
    get_tor_items_for_dlv_item(
      EXPORTING
        ir_lips     = is_app_object-maintabref
      IMPORTING
        et_tor_item = DATA(lt_tor_item)
    ).
    IF lt_tor_item IS NOT INITIAL.
      LOOP AT lt_tor_item ASSIGNING FIELD-SYMBOL(<ls_tor_item>).
        ADD 1 TO lv_count.
        APPEND lv_count TO ls_item_with_fu-fu_lineno.
        APPEND zcl_gtt_mia_tm_tools=>get_formated_tor_id(
                 ir_data = REF #( <ls_tor_item> ) ) TO ls_item_with_fu-fu_freightunit.
        APPEND zcl_gtt_mia_tm_tools=>get_formated_tor_item(
                 ir_data = REF #( <ls_tor_item> ) ) TO ls_item_with_fu-fu_itemnumber.
        APPEND <ls_tor_item>-quantity TO ls_item_with_fu-fu_quantity.
        APPEND <ls_tor_item>-quantityuom TO ls_item_with_fu-fu_quantityuom.
        APPEND <ls_tor_item>-product_id TO ls_item_with_fu-fu_product_id.
        APPEND <ls_tor_item>-product_descr TO ls_item_with_fu-fu_product_descr.
        APPEND mo_ef_parameters->get_appsys( ) TO ls_item_with_fu-fu_no_logsys.
        APPEND mo_ef_parameters->get_appsys( ) TO ls_item_with_fu-appsys.
        APPEND zif_gtt_ef_constants=>cs_trxcod-fu_number TO ls_item_with_fu-trxcod.
        APPEND zcl_gtt_mia_tm_tools=>get_formated_tor_id(
                 ir_data = REF #( <ls_tor_item> ) ) TO ls_item_with_fu-trxid.
      ENDLOOP.
    ENDIF.
    rr_data   = NEW ts_dl_item_with_fu( ).
    ASSIGN rr_data->* TO FIELD-SYMBOL(<ls_item_with_fu>).
    <ls_item_with_fu> = ls_item_with_fu.

  ENDMETHOD.


  METHOD zif_gtt_tp_reader~get_data_old.

    FIELD-SYMBOLS: <ls_lips>  TYPE lipsvb.
    DATA: ls_item         TYPE ts_dl_item,
          ls_item_with_fu TYPE ts_dl_item_with_fu.
    DATA: lr_data TYPE REF TO data.
    DATA(lv_vbeln)  = CONV vbeln_vl( zcl_gtt_tools=>get_field_of_structure(
                                       ir_struct_data = is_app_object-maintabref
                                       iv_field_name  = 'VBELN' ) ).
    DATA(lv_posnr)  = CONV posnr_vl( zcl_gtt_tools=>get_field_of_structure(
                                       ir_struct_data = is_app_object-maintabref
                                       iv_field_name  = 'POSNR' ) ).
    lr_data = get_lips_struct_old(
      is_app_object = is_app_object
      iv_vbeln      = lv_vbeln
      iv_posnr      = lv_posnr ).
    ASSIGN lr_data->* TO <ls_lips>.
    IF <ls_lips> IS ASSIGNED.
      change_mode = <ls_lips>-updkz. " Save change mode to determinate cs_mapping!
    ENDIF.

    fill_item_from_likp_struct(
      EXPORTING
        ir_likp    = get_likp_struct_old(
                       is_app_object = is_app_object
                       iv_vbeln      = lv_vbeln )
      CHANGING
        cs_dl_item = ls_item ).

    fill_item_from_lips_struct(
      EXPORTING
        ir_lips    = get_lips_struct_old(
                       is_app_object = is_app_object
                       iv_vbeln      = lv_vbeln
                       iv_posnr      = lv_posnr )
      CHANGING
        cs_dl_item = ls_item ).


    fill_item_from_vbpa_table(
      EXPORTING
        ir_vbpa    = get_vbpa_table_old(
                       is_app_object = is_app_object
                       iv_vbeln      = lv_vbeln
                       iv_posnr      = cv_posnr_empty )
        iv_vbeln   = lv_vbeln
        iv_posnr   = cv_posnr_empty
      CHANGING
        cs_dl_item = ls_item ).

    fill_item_location_types(
      CHANGING
        cs_dl_item = ls_item ).

    format_item_location_ids(
      CHANGING
        cs_dl_item = ls_item ).

    ls_item_with_fu = CORRESPONDING #( ls_item ).
    rr_data   = NEW ts_dl_item_with_fu( ).
    ASSIGN rr_data->* TO FIELD-SYMBOL(<ls_item_with_fu>).
    <ls_item_with_fu> = ls_item_with_fu.

  ENDMETHOD.


  METHOD ZIF_GTT_TP_READER~GET_FIELD_PARAMETER.

    CLEAR: rv_result.

  ENDMETHOD.


  METHOD zif_gtt_tp_reader~get_mapping_structure.

    rr_data   = REF #( cs_mapping_with_fu ).

  ENDMETHOD.


  METHOD zif_gtt_tp_reader~get_track_id_data.

    "In ERP’s extractors, need to include 2 tracking IDs.
    "The first one is for itself, one is for its header –
    "please ensure same tracking ID type to be used in the
    "Inbound Delivery Header process

    FIELD-SYMBOLS: <ls_lips>  TYPE lipsvb.

    DATA:
      lv_dlvittrxcod TYPE /saptrx/trxcod,
      lv_dlvhdtrxcod TYPE /saptrx/trxcod,
      lv_futrxcod    TYPE /saptrx/trxcod.

    " Actual Business Time zone

    DATA(lv_tzone)  = zcl_gtt_tools=>get_system_time_zone( ).

    lv_dlvittrxcod = zif_gtt_ef_constants=>cs_trxcod-dl_position.
    lv_dlvhdtrxcod = zif_gtt_ef_constants=>cs_trxcod-dl_number.
    lv_futrxcod    = zif_gtt_ef_constants=>cs_trxcod-fu_number.
    CLEAR et_track_id_data.

    ASSIGN is_app_object-maintabref->* TO <ls_lips>.

    IF <ls_lips> IS ASSIGNED.
      et_track_id_data  = VALUE #( (
          appsys      = mo_ef_parameters->get_appsys( )
          appobjtype  = is_app_object-appobjtype
          appobjid    = is_app_object-appobjid
          trxcod      = lv_dlvittrxcod
          trxid       = zcl_gtt_mia_dl_tools=>get_tracking_id_dl_item(
                          ir_lips = is_app_object-maintabref )
          timzon      = lv_tzone
          msrid       = space
        ) ).
      IF <ls_lips>-updkz = zif_gtt_ef_constants=>cs_change_mode-insert.
        et_track_id_data  = VALUE #( BASE et_track_id_data (
          appsys      = mo_ef_parameters->get_appsys( )
          appobjtype  = is_app_object-appobjtype
          appobjid    = is_app_object-appobjid
          trxcod      = lv_dlvhdtrxcod
          trxid       = zcl_gtt_mia_dl_tools=>get_tracking_id_dl_header(
                          ir_likp = is_app_object-mastertabref )
          timzon      = lv_tzone
          msrid       = space
        ) ).
*        " Give FU number in the tracking id
*        get_tor_items_for_dlv_item(
*          EXPORTING
*            ir_lips   = is_app_object-maintabref
*          IMPORTING
*            et_tor_id = DATA(lt_tor_id)
*        ).
*        IF lt_tor_id IS NOT INITIAL.
*          LOOP AT lt_tor_id ASSIGNING FIELD-SYMBOL(<ls_fu_id>).
*            et_track_id_data  = VALUE #( BASE et_track_id_data (
*              appsys      = mo_ef_parameters->get_appsys( )
*              appobjtype  = is_app_object-appobjtype
*              appobjid    = is_app_object-appobjid
*              trxcod      = lv_futrxcod
*              trxid       = zcl_gtt_mia_tm_tools=>get_formated_tor_id( ir_data = REF #( <ls_fu_id> ) )
*              timzon      = lv_tzone
*              msrid       = space
*            ) ).
*          ENDLOOP.
*        ENDIF.
      ENDIF.
    ELSE.
      MESSAGE e002(zgtt) WITH 'LIPS' INTO DATA(lv_dummy).
      zcl_gtt_tools=>throw_exception( ).
    ENDIF.

  ENDMETHOD.


  METHOD get_tor_items_for_dlv_item.

    DATA: lt_fu_item     TYPE /scmtms/t_tor_item_tr_k.
    CLEAR: et_tor_id,et_tor_item.

    zcl_gtt_mia_tm_tools=>get_tor_items_for_dlv_items(
      EXPORTING
        it_lips    = VALUE #( ( vbeln = zcl_gtt_tools=>get_field_of_structure(
                                  ir_struct_data = ir_lips
                                  iv_field_name  = 'VBELN' )
                                posnr = zcl_gtt_tools=>get_field_of_structure(
                                  ir_struct_data = ir_lips
                                  iv_field_name  = 'POSNR' ) ) )
        iv_tor_cat = /scmtms/if_tor_const=>sc_tor_category-freight_unit
      IMPORTING
        et_fu_item = lt_fu_item ).

    LOOP AT lt_fu_item ASSIGNING FIELD-SYMBOL(<ls_fu_item>).
      zcl_gtt_mia_tm_tools=>get_tor_root(
        EXPORTING
          iv_key = <ls_fu_item>-parent_key
        IMPORTING
          es_tor = DATA(ls_tor_data)
      ).
      IF ls_tor_data-lifecycle = /scmtms/if_tor_status_c=>sc_root-lifecycle-v_canceled.
        CONTINUE.
      ENDIF.
      et_tor_id  = VALUE #( BASE et_tor_id (
         tor_id = ls_tor_data-tor_id
      ) ).
      et_tor_item  = VALUE #( BASE et_tor_item (
                tor_id        = ls_tor_data-tor_id
                item_id       = <ls_fu_item>-item_id
                quantity     = <ls_fu_item>-qua_pcs_val
                quantityuom  = <ls_fu_item>-qua_pcs_uni
                product_id   = <ls_fu_item>-product_id
                product_descr = <ls_fu_item>-item_descr
              ) ).
    ENDLOOP.
    SORT et_tor_id BY tor_id.
    DELETE ADJACENT DUPLICATES FROM et_tor_id  COMPARING tor_id.

    SORT et_tor_item BY tor_id item_id.
    DELETE ADJACENT DUPLICATES FROM et_tor_item COMPARING tor_id item_id.
  ENDMETHOD.
ENDCLASS.
