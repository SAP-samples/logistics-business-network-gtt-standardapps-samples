*----------------------------------------------------------------------*
***INCLUDE LZGTT_SSOFF03.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form read_appl_tables_status
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> LT_XVBUK
*&      --> LT_YVBUK
*&      --> I_ALL_APPL_TABLES
*&---------------------------------------------------------------------*
FORM read_appl_tables_status
TABLES ct_xvbuk STRUCTURE vbukvb
  ct_yvbuk STRUCTURE vbukvb
USING  i_all_appl_tables TYPE trxas_tabcontainer.

  DATA:
*   Container with references
        ls_one_app_tables   TYPE trxas_tabcontainer_wa.

  FIELD-SYMBOLS:
*   Sales Document: Header Status and Admin Data New
    <lt_xvbuk> TYPE STANDARD TABLE,
*   Sales Document: Header Status and Admin Data Old
    <lt_yvbuk> TYPE STANDARD TABLE.

* <1-1> Sales Document: Header Status and Admin Data New
  READ TABLE i_all_appl_tables INTO ls_one_app_tables
  WITH KEY tabledef = 'DELIVERY_HDR_STATUS_NEW'.

  IF NOT sy-subrc IS INITIAL.
    RAISE idata_determination_error.
  ELSE.
    ASSIGN ls_one_app_tables-tableref->* TO <lt_xvbuk>.
    ct_xvbuk[] = <lt_xvbuk>[].
    SORT ct_xvbuk BY vbeln.
  ENDIF.

* <1-2> Sales Document: Header Status and Admin Data Old
  READ TABLE i_all_appl_tables INTO ls_one_app_tables
  WITH KEY tabledef = 'DELIVERY_HDR_STATUS_OLD'.

  IF NOT sy-subrc IS INITIAL.
    RAISE idata_determination_error.
  ELSE.
    ASSIGN ls_one_app_tables-tableref->* TO <lt_yvbuk>.
    ct_yvbuk[] = <lt_yvbuk>[].
    SORT ct_yvbuk BY vbeln.
  ENDIF.

ENDFORM.                    " read_appl_tables_status

*&---------------------------------------------------------------------*
*& Form read_appl_tables_delivery_item
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> LT_XVBUK
*&      --> LT_YVBUK
*&      --> I_ALL_APPL_TABLES
*&---------------------------------------------------------------------*
FORM read_appl_tables_delivery_item
TABLES ct_xvlips STRUCTURE lipsvb
       ct_yvlips STRUCTURE lipsvb
USING  i_all_appl_tables TYPE trxas_tabcontainer.

  DATA:
*   Container with references
        ls_one_app_tables   TYPE trxas_tabcontainer_wa.

  FIELD-SYMBOLS:
*   Sales Document: Header Status and Admin Data New
    <lt_xvlips> TYPE STANDARD TABLE,
*   Sales Document: Header Status and Admin Data Old
    <lt_yvlips> TYPE STANDARD TABLE.

* <1-1> Sales Document: Delivery Item Data New
  READ TABLE i_all_appl_tables INTO ls_one_app_tables
  WITH KEY tabledef = 'DELIVERY_ITEM_NEW'.

  IF NOT sy-subrc IS INITIAL.
    RAISE idata_determination_error.
  ELSE.
    ASSIGN ls_one_app_tables-tableref->* TO <lt_xvlips>.
    ct_xvlips[] = <lt_xvlips>[].
    SORT ct_xvlips BY vbeln posnr.
  ENDIF.

* <1-2> Sales Document: Delivery Item Data Old
  READ TABLE i_all_appl_tables INTO ls_one_app_tables
  WITH KEY tabledef = 'DELIVERY_ITEM_OLD'.

  IF NOT sy-subrc IS INITIAL.
    RAISE idata_determination_error.
  ELSE.
    ASSIGN ls_one_app_tables-tableref->* TO <lt_yvlips>.
    ct_yvlips[] = <lt_yvlips>[].
    SORT ct_yvlips BY vbeln posnr.
  ENDIF.

ENDFORM.                    " read_appl_tables_status

*&---------------------------------------------------------------------*
*& Form read_appl_tables_packing_item
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> LT_XVBUK
*&      --> LT_YVBUK
*&      --> I_ALL_APPL_TABLES
*&---------------------------------------------------------------------*
FORM read_appl_tables_packing_item
TABLES ct_xvepo STRUCTURE vepovb
       ct_yvepo STRUCTURE vepovb
USING  i_all_appl_tables TYPE trxas_tabcontainer.

  DATA:
*   Container with references
        ls_one_app_tables   TYPE trxas_tabcontainer_wa.

  FIELD-SYMBOLS:
*   Sales Document: Header Status and Admin Data New
    <lt_xvepo> TYPE STANDARD TABLE,
*   Sales Document: Header Status and Admin Data Old
    <lt_yvepo> TYPE STANDARD TABLE.

* <1-1> Sales Document: Delivery Item Data New
  READ TABLE i_all_appl_tables INTO ls_one_app_tables
  WITH KEY tabledef = 'HU_ITEM_NEW'.

  IF NOT sy-subrc IS INITIAL.
    RAISE idata_determination_error.
  ELSE.
    ASSIGN ls_one_app_tables-tableref->* TO <lt_xvepo>.
    ct_xvepo[] = <lt_xvepo>[].
    SORT ct_xvepo BY vbeln posnr.
  ENDIF.

* <1-2> Sales Document: Delivery Item Data Old
  READ TABLE i_all_appl_tables INTO ls_one_app_tables
  WITH KEY tabledef = 'HU_ITEM_OLD'.

  IF NOT sy-subrc IS INITIAL.
    RAISE idata_determination_error.
  ELSE.
    ASSIGN ls_one_app_tables-tableref->* TO <lt_yvepo>.
    ct_yvepo[] = <lt_yvepo>[].
    SORT ct_yvepo BY vbeln posnr.
  ENDIF.

ENDFORM.                    " read_appl_tables_status

*&---------------------------------------------------------------------*
*& Form read_appl_tables_packing_item
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> LT_XVBUK
*&      --> LT_YVBUK
*&      --> I_ALL_APPL_TABLES
*&---------------------------------------------------------------------*
FORM read_appl_tables_pod_items
TABLES ct_xvbup STRUCTURE vbupvb
       ct_yvbup STRUCTURE vbupvb
USING  i_all_appl_tables TYPE trxas_tabcontainer.

  DATA:
*   Container with references
        ls_one_app_tables   TYPE trxas_tabcontainer_wa.

  FIELD-SYMBOLS:
*   Sales Document: Header Status and Admin Data New
    <lt_xvbup> TYPE STANDARD TABLE,
*   Sales Document: Header Status and Admin Data Old
    <lt_yvbup> TYPE STANDARD TABLE.

* <1-1> Sales Document: Delivery Item Data New
  READ TABLE i_all_appl_tables INTO ls_one_app_tables
  WITH KEY tabledef = 'DELIVERY_ITEM_STATUS_NEW'.

  IF NOT sy-subrc IS INITIAL.
    RAISE idata_determination_error.
  ELSE.
    ASSIGN ls_one_app_tables-tableref->* TO <lt_xvbup>.
    ct_xvbup[] = <lt_xvbup>[].
    SORT ct_xvbup BY vbeln posnr.
  ENDIF.

* <1-2> Sales Document: Delivery Item Data Old
  READ TABLE i_all_appl_tables INTO ls_one_app_tables
  WITH KEY tabledef = 'DELIVERY_ITEM_STATUS_OLD'.

  IF NOT sy-subrc IS INITIAL.
    RAISE idata_determination_error.
  ELSE.
    ASSIGN ls_one_app_tables-tableref->* TO <lt_yvbup>.
    ct_yvbup[] = <lt_yvbup>[].
    SORT ct_yvbup BY vbeln posnr.
  ENDIF.

ENDFORM.


*&---------------------------------------------------------------------*
*& Form read_appl_tables_shipment_header
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> LT_XVBUK
*&      --> LT_YVBUK
*&      --> I_ALL_APPL_TABLES
*&---------------------------------------------------------------------*
FORM read_appl_tables_shipmt_header
TABLES ct_xvttk STRUCTURE vttkvb
       ct_yvttk STRUCTURE vttkvb
USING  i_all_appl_tables TYPE trxas_tabcontainer.

  DATA:
*   Container with references
        ls_one_app_tables   TYPE trxas_tabcontainer_wa.

  FIELD-SYMBOLS:
    <lt_xvttk> TYPE STANDARD TABLE,
    <lt_yvttk> TYPE STANDARD TABLE.

* <1-1> Sales Document: Shipment Header Data New
  READ TABLE i_all_appl_tables INTO ls_one_app_tables
  WITH KEY tabledef = 'SHIPMENT_HEADER_NEW'.

  IF NOT sy-subrc IS INITIAL.
    RAISE idata_determination_error.
  ELSE.
    ASSIGN ls_one_app_tables-tableref->* TO <lt_xvttk>.
    ct_xvttk[] = <lt_xvttk>[].
    SORT ct_xvttk BY tknum.
  ENDIF.

* <1-2> Sales Document: Shipment Header Data Old
  READ TABLE i_all_appl_tables INTO ls_one_app_tables
  WITH KEY tabledef = 'SHIPMENT_HEADER_OLD'.

  IF NOT sy-subrc IS INITIAL.
    RAISE idata_determination_error.
  ELSE.
    ASSIGN ls_one_app_tables-tableref->* TO <lt_yvttk>.
    ct_yvttk[] = <lt_yvttk>[].
    SORT ct_yvttk BY tknum.
  ENDIF.

ENDFORM.                    " read_appl_tables_status



*&---------------------------------------------------------------------*
*& Form read_appl_tables_shipment_header
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> LT_XVBUK
*&      --> LT_YVBUK
*&      --> I_ALL_APPL_TABLES
*&---------------------------------------------------------------------*
FORM read_appl_tables_shipment_leg
TABLES ct_xvtts STRUCTURE vttsvb
       ct_yvtts STRUCTURE vttsvb
USING  i_all_appl_tables TYPE trxas_tabcontainer.

  DATA:
*   Container with references
        ls_one_app_tables   TYPE trxas_tabcontainer_wa.

  FIELD-SYMBOLS:
    <lt_xvtts> TYPE STANDARD TABLE,
    <lt_yvtts> TYPE STANDARD TABLE.

* <1-1> Sales Document: Shipment Header Data New
  READ TABLE i_all_appl_tables INTO ls_one_app_tables
  WITH KEY tabledef = 'SHIPMENT_LEG_NEW'.

  IF NOT sy-subrc IS INITIAL.
    RAISE idata_determination_error.
  ELSE.
    ASSIGN ls_one_app_tables-tableref->* TO <lt_xvtts>.
    ct_xvtts[] = <lt_xvtts>[].
    SORT ct_xvtts BY tknum tsnum.
  ENDIF.

* <1-2> Sales Document: Shipment Header Data Old
  READ TABLE i_all_appl_tables INTO ls_one_app_tables
  WITH KEY tabledef = 'SHIPMENT_LEG_OLD'.

  IF NOT sy-subrc IS INITIAL.
    RAISE idata_determination_error.
  ELSE.
    ASSIGN ls_one_app_tables-tableref->* TO <lt_yvtts>.
    ct_yvtts[] = <lt_yvtts>[].
    SORT ct_yvtts BY tknum tsnum.
  ENDIF.

ENDFORM.                    " read_appl_tables_status
*&---------------------------------------------------------------------*
*& Form fill_one_time_location
*&---------------------------------------------------------------------*
*& Support one time location
*&---------------------------------------------------------------------*
*&      --> ET_LOC_DATA      Location data
*&      --> is_xvbpa         Partner information
*&      --> iv_loctype       Location type
*&---------------------------------------------------------------------*
FORM fill_one_time_location  TABLES   et_loc_data     TYPE STANDARD TABLE
                             USING    is_xvbpa        TYPE vbpavb
                                      iv_loctype      TYPE zgtt_ssof_loctype.

  DATA:
    ls_loc_addr     TYPE addr1_data,
    lv_loc_email    TYPE ad_smtpadr,
    lv_loc_tel      TYPE char50,
    ls_address_info TYPE gtys_address_info,
    lt_address_info TYPE TABLE OF gtys_address_info.

  CLEAR et_loc_data[].

  IF is_xvbpa-adrnr CN '0 ' AND is_xvbpa-adrda CA zif_gtt_ef_constants=>vbpa_addr_ind_man_all.
    zcl_gtt_tools=>get_address_from_memory(
      EXPORTING
        iv_addrnumber = is_xvbpa-adrnr
      IMPORTING
        es_addr       = ls_loc_addr
        ev_email      = lv_loc_email
        ev_telephone  = lv_loc_tel ).

    ls_address_info-locid = |{ is_xvbpa-kunnr ALPHA = OUT }|.
    ls_address_info-loctype = iv_loctype.
    ls_address_info-addr1 = ls_loc_addr.
    ls_address_info-email = lv_loc_email.
    ls_address_info-telephone = lv_loc_tel.
    APPEND ls_address_info TO lt_address_info.
    CLEAR:
      ls_address_info.

  ENDIF.

  et_loc_data[] = lt_address_info.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form fill_loc_data
*&---------------------------------------------------------------------*
*& Fill location data
*&---------------------------------------------------------------------*
*&      --> CT_CONTROL_DATA  Control data
*&      --> is_ctrl          Control data
*&---------------------------------------------------------------------*
FORM fill_loc_data  TABLES  ct_control_data  TYPE /saptrx/bapi_trk_control_tab
                     USING  is_ctrl          TYPE /saptrx/control_data.

  DATA:
    ls_loc_data     TYPE gtys_address_info,
    lv_paramindex   TYPE /saptrx/indexcounter,
    ls_control_data TYPE /saptrx/control_data,
    lt_control_data TYPE TABLE OF /saptrx/control_data.

  CLEAR ct_control_data[].

  LOOP AT gt_loc_data INTO ls_loc_data.

    lv_paramindex = lv_paramindex + 1.

*   Location ID
    ls_control_data-paramindex = lv_paramindex.
    ls_control_data-paramname = gc_cp_yn_gtt_otl_locid.
    ls_control_data-value = ls_loc_data-locid.
    IF ls_loc_data-loctype = zif_gtt_sof_constants=>cs_loctype-bp.
      ls_control_data-value = |{ ls_loc_data-locid ALPHA = OUT }|.
    ENDIF.
    APPEND ls_control_data TO lt_control_data.

*   Location Type
    ls_control_data-paramindex = lv_paramindex.
    ls_control_data-paramname = gc_cp_yn_gtt_otl_loctype.
    ls_control_data-value = ls_loc_data-loctype.
    APPEND ls_control_data TO lt_control_data.

*   Time Zone
    ls_control_data-paramindex = lv_paramindex.
    ls_control_data-paramname = gc_cp_yn_gtt_otl_timezone.
    ls_control_data-value = ls_loc_data-addr1-time_zone.
    APPEND ls_control_data TO lt_control_data.

*   Description
    ls_control_data-paramindex = lv_paramindex.
    ls_control_data-paramname = gc_cp_yn_gtt_otl_description.
    ls_control_data-value = ls_loc_data-addr1-name1.
    APPEND ls_control_data TO lt_control_data.

*   Country Code
    ls_control_data-paramindex = lv_paramindex.
    ls_control_data-paramname = gc_cp_yn_gtt_otl_country_code.
    ls_control_data-value = ls_loc_data-addr1-country.
    APPEND ls_control_data TO lt_control_data.

*   City Name
    ls_control_data-paramindex = lv_paramindex.
    ls_control_data-paramname = gc_cp_yn_gtt_otl_city_name.
    ls_control_data-value = ls_loc_data-addr1-city1.
    APPEND ls_control_data TO lt_control_data.

*   Region Code
    ls_control_data-paramindex = lv_paramindex.
    ls_control_data-paramname = gc_cp_yn_gtt_otl_region_code.
    ls_control_data-value = ls_loc_data-addr1-region.
    APPEND ls_control_data TO lt_control_data.

*   House Number
    ls_control_data-paramindex = lv_paramindex.
    ls_control_data-paramname = gc_cp_yn_gtt_otl_house_number.
    ls_control_data-value = ls_loc_data-addr1-house_num1.
    APPEND ls_control_data TO lt_control_data.

*   Street Name
    ls_control_data-paramindex = lv_paramindex.
    ls_control_data-paramname = gc_cp_yn_gtt_otl_street_name.
    ls_control_data-value = ls_loc_data-addr1-street.
    APPEND ls_control_data TO lt_control_data.

*   Postal Code
    ls_control_data-paramindex = lv_paramindex.
    ls_control_data-paramname = gc_cp_yn_gtt_otl_postal_code.
    ls_control_data-value = ls_loc_data-addr1-post_code1.
    APPEND ls_control_data TO lt_control_data.

*   Email Address
    ls_control_data-paramindex = lv_paramindex.
    ls_control_data-paramname = gc_cp_yn_gtt_otl_email_address.
    ls_control_data-value = ls_loc_data-email.
    APPEND ls_control_data TO lt_control_data.

*   Phone Number
    ls_control_data-paramindex = lv_paramindex.
    ls_control_data-paramname = gc_cp_yn_gtt_otl_phone_number.
    ls_control_data-value = ls_loc_data-telephone.
    APPEND ls_control_data TO lt_control_data.

  ENDLOOP.

  LOOP AT lt_control_data ASSIGNING FIELD-SYMBOL(<fs_control_data>).
    <fs_control_data>-appsys = is_ctrl-appsys.
    <fs_control_data>-appobjtype = is_ctrl-appobjtype.
    <fs_control_data>-appobjid = is_ctrl-appobjid.
    <fs_control_data>-language = is_ctrl-language.
  ENDLOOP.

  ct_control_data[] = lt_control_data.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form get_one_time_location_from_shp
*&---------------------------------------------------------------------*
*& Get one-time location from shipment
*&---------------------------------------------------------------------*
*&      --> CT_LOC_DATA      Location data
*&      --> IV_VBELN         Delivery number
*&---------------------------------------------------------------------*
FORM get_one_time_location_from_shp  TABLES   ct_loc_data   TYPE STANDARD TABLE
                                     USING    iv_vbeln      TYPE likp-vbeln.

  DATA:
    lt_control_data     TYPE TABLE OF /saptrx/control_data,
    lt_control_data_tmp TYPE TABLE OF /saptrx/control_data,
    lt_vttsvb           TYPE vttsvb_tab,
    ls_loc_addr         TYPE addr1_data,
    lv_loc_email        TYPE ad_smtpadr,
    lv_loc_tel          TYPE char50,
    ls_address_info     TYPE gtys_address_info,
    lt_address_info     TYPE TABLE OF gtys_address_info,
    ls_loc_addr_tmp     TYPE addr1_data,
    lv_loc_email_tmp    TYPE ad_smtpadr,
    lv_loc_tel_tmp      TYPE char50.

  CLEAR ct_loc_data[].

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

  ct_loc_data[] = lt_address_info.

ENDFORM.
