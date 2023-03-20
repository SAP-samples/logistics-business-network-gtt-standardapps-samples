FUNCTION zgtt_ssof_ote_de_hd.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(I_APPSYS) TYPE  /SAPTRX/APPLSYSTEM
*"     REFERENCE(I_APP_OBJ_TYPES) TYPE  /SAPTRX/AOTYPES
*"     REFERENCE(I_ALL_APPL_TABLES) TYPE  TRXAS_TABCONTAINER
*"     REFERENCE(I_APP_TYPE_CNTL_TABS) TYPE  TRXAS_APPTYPE_TABS
*"     REFERENCE(I_APP_OBJECTS) TYPE  TRXAS_APPOBJ_CTABS
*"  TABLES
*"      E_CONTROL_DATA STRUCTURE  /SAPTRX/CONTROL_DATA
*"      E_LOGTABLE STRUCTURE  BAPIRET2 OPTIONAL
*"  EXCEPTIONS
*"      PARAMETER_ERROR
*"      CDATA_DETERMINATION_ERROR
*"      TABLE_DETERMINATION_ERROR
*"      STOP_PROCESSING
*"----------------------------------------------------------------------
*----------------------------------------------------------------------*
* Top Include
* TYPE-POOLS:trxas.
*----------------------------------------------------------------------*

  DATA:
    ls_app_objects  TYPE trxas_appobj_ctab_wa,
    ls_control_data TYPE /saptrx/control_data,
    lt_xlikp        TYPE STANDARD TABLE OF likpvb,
    lt_xvbuk        TYPE STANDARD TABLE OF vbukvb,
    lt_xlips        TYPE STANDARD TABLE OF lipsvb,
*    business partner table
    lt_xvbpa        TYPE STANDARD TABLE OF vbpavb,
    lv_tzone        TYPE timezone,
*    door text
    lv_ltort        TYPE t30bt-ltort,
*    warehouse text
    lv_lnumt        TYPE t300t-lnumt,
*    warehouse text / door text
    lv_lgtratxt     TYPE char60,
*    shipping point address number,
    lv_adrnr_shpt	  TYPE adrnr,
*    country iso code
    lv_countryiso   TYPE intca,
*    sd document address information
    ls_sd_addr      TYPE vbadr,
    lv_tabix        TYPE numc10,
    lt_address      TYPE STANDARD TABLE OF gtys_address,
    ls_address      TYPE gtys_address,
    lv_dlv_datetime TYPE timestamp,
    lv_tmp_datetime TYPE char20,
    lo_gtt_toolkit  TYPE REF TO zcl_gtt_sof_toolkit,
    lt_relation     TYPE STANDARD TABLE OF gtys_tor_data,
    lv_kunnr        TYPE likp-kunnr.

  FIELD-SYMBOLS:
    <ls_xlikp> TYPE likpvb,
    <ls_xvbuk> TYPE vbukvb,
    <ls_xlips> TYPE lipsvb,
    <ls_xvbpa> TYPE vbpavb.

  lo_gtt_toolkit = zcl_gtt_sof_toolkit=>get_instance( ).

* <1> Read necessary application tables from table reference
* Read Header Status Data New
  PERFORM read_appl_table
    USING    i_all_appl_tables
             gc_bpt_delivery_hdrstatus_new
    CHANGING lt_xvbuk.

* Read Item New
  PERFORM read_appl_table
    USING    i_all_appl_tables
             gc_bpt_delivery_item_new
    CHANGING lt_xlips.

* <1> Read Ship-to Party New
  PERFORM read_appl_table
    USING    i_all_appl_tables
             gc_bpt_partners_new
    CHANGING lt_xvbpa.

* <2> Fill general data for all control data records
  ls_control_data-appsys     = i_appsys.
  ls_control_data-appobjtype = i_app_obj_types-aotype.
  ls_control_data-language   = sy-langu.

* <3> Loop at application objects for geting Delivery Header
*     add the following values which cannot be extracted in EM Data Extraction
*Delivery No. (LIKP-VBELN)
*Ship-To Party (LIKP-KUNNR)
*Document date (LIKP-BLDAT)
*Planned delivery date (LIKP-LFDAT)
*Total Weight (LIKP-BTGEW)
*Net weight (LIKP-NTGEW)
*Total Weight uom (LIKP-GEWEI)
*Volume (LIKP-VOLUM)
*Volume unit (LIKP-VOLEH)
*Picking Status (VBUK-KOSTK)
*Packing Status (VBUK-PKSTK)
*Goods Issue Status (VBUK-WBSTK)
*Warehouse No: LIKP-LGNUM
*Door for warehouse: LIKP-LGTOR
*Warehouse door text: T30BT with LGNUM and LGTOR
*Shipping point / Departure (LIKP-VSTEL)
*Departure address
*Departure country
*Destination (LIKP-KUNNR)
*Destination country
*Destination address
*Destination email
*Destination telephone
*Bill of lading (LIKP-BOLNR)
*Incoterms (LIKP-INCO1)
*Incoterms location 1 (LIKP-INCO2_L)
*Incoterms version (LIKP-INCOV)
* Actual Business Time
* Actual Business Time zone
* Actual Technical Datetime
* Actual Technical Time zone
* Delivery Order Item table

  LOOP AT i_app_objects INTO ls_app_objects.

*   Application Object ID
    ls_control_data-appobjid   = ls_app_objects-appobjid.

*   Check if Main table is Delivery Header or not.
    IF ls_app_objects-maintabdef <> gc_bpt_delivery_header_new.
      PERFORM create_logtable_aot
        TABLES e_logtable
        USING  space
               ls_app_objects-maintabdef
               i_app_obj_types-controldatafunc
               ls_app_objects-appobjtype
               i_appsys.
      RAISE table_determination_error.
    ELSE.
*     Read Main Object Table
      ASSIGN ls_app_objects-maintabref->* TO <ls_xlikp>.
    ENDIF.

*Delivery No. (LIKP-VBELN)
    ls_control_data-paramname = gc_cp_yn_de_no.
    ls_control_data-value     = |{ <ls_xlikp>-vbeln ALPHA = OUT }|.
    APPEND ls_control_data TO e_control_data.

*Ship-To Party (LIKP-KUNNR)
    ls_control_data-paramname = gc_cp_yn_de_ship_to.
    ls_control_data-value     = <ls_xlikp>-kunnr.
    zcl_gtt_tools=>convert_to_external_frmt(
      EXPORTING
        iv_input  = ls_control_data-value
      IMPORTING
        ev_output = lv_kunnr ).
    ls_control_data-value = lv_kunnr.
    CLEAR lv_kunnr.
    APPEND ls_control_data TO e_control_data.

*Document date (LIKP-BLDAT)
    ls_control_data-paramname = gc_cp_yn_doc_date.
    IF <ls_xlikp>-bldat IS NOT INITIAL.
      ls_control_data-value     = <ls_xlikp>-bldat.
    ELSE.
      CLEAR ls_control_data-value.
    ENDIF.
    APPEND ls_control_data TO e_control_data.

*Planned delivery date (LIKP-LFDAT)& Time
    ls_control_data-paramname = gc_cp_yn_dl_planned_dlv_datetm.
    IF <ls_xlikp>-lfdat IS NOT INITIAL.
      CLEAR:
        lv_dlv_datetime,
        lv_tmp_datetime.
      lv_dlv_datetime = |0{ <ls_xlikp>-lfdat }{ <ls_xlikp>-lfuhr }|.

      zcl_gtt_tools=>convert_datetime_to_utc(
        EXPORTING
          iv_datetime     = lv_dlv_datetime
          iv_timezone     = <ls_xlikp>-tzonrc
        RECEIVING
          rv_datetime_utc = lv_tmp_datetime ).

      ls_control_data-value  = lv_tmp_datetime.
      CONDENSE ls_control_data-value NO-GAPS.
    ELSE.
      CLEAR ls_control_data-value.
    ENDIF.
    APPEND ls_control_data TO e_control_data.

*Total Weight (LIKP-BTGEW)
    ls_control_data-paramname = gc_cp_yn_de_tot_weight.
    ls_control_data-value     = <ls_xlikp>-btgew.
    SHIFT ls_control_data-value LEFT  DELETING LEADING space.
    APPEND ls_control_data TO e_control_data.

*Net weight (LIKP-NTGEW)
    ls_control_data-paramname = gc_cp_yn_de_net_weight.
    ls_control_data-value     = <ls_xlikp>-ntgew.
    SHIFT ls_control_data-value LEFT  DELETING LEADING space.
    APPEND ls_control_data TO e_control_data.

*Total Weight uom (LIKP-GEWEI)
    ls_control_data-paramname = gc_cp_yn_de_tot_weight_uom.
    zcl_gtt_sof_toolkit=>convert_unit_output(
      EXPORTING
        iv_input  = <ls_xlikp>-gewei
      RECEIVING
        rv_output = ls_control_data-value ).
    APPEND ls_control_data TO e_control_data.

*Volume (LIKP-VOLUM)
    ls_control_data-paramname = gc_cp_yn_de_vol.
    ls_control_data-value     = <ls_xlikp>-volum.
    SHIFT ls_control_data-value LEFT  DELETING LEADING space.
    APPEND ls_control_data TO e_control_data.

*Volume unit (LIKP-VOLEH)
    ls_control_data-paramname = gc_cp_yn_de_vol_uom.
    zcl_gtt_sof_toolkit=>convert_unit_output(
      EXPORTING
        iv_input  = <ls_xlikp>-voleh
      RECEIVING
        rv_output = ls_control_data-value ).
    APPEND ls_control_data TO e_control_data.

    READ TABLE lt_xvbuk ASSIGNING <ls_xvbuk> WITH KEY vbeln = <ls_xlikp>-vbeln.

*Picking Status (VBUK-KOSTK)
    ls_control_data-paramname = gc_cp_yn_de_pick_status.
    IF <ls_xvbuk>-kostk IS NOT INITIAL.
      ls_control_data-value     = <ls_xvbuk>-kostk.
    ELSE.
      ls_control_data-value     = gc_true.
    ENDIF.
    APPEND ls_control_data TO e_control_data.

*Packing Status (VBUK-PKSTK)
    ls_control_data-paramname = gc_cp_yn_de_pack_status.
    IF <ls_xvbuk>-pkstk IS NOT INITIAL.
      ls_control_data-value     = <ls_xvbuk>-pkstk.
    ELSE.
      ls_control_data-value     = gc_true.
    ENDIF.
    APPEND ls_control_data TO e_control_data.

*Goods Issue Status (VBUK-WBSTK)
    ls_control_data-paramname = gc_cp_yn_de_gi_status.
    IF <ls_xvbuk>-wbstk IS NOT INITIAL.
      ls_control_data-value     = <ls_xvbuk>-wbstk.
    ELSE.
      ls_control_data-value     = gc_true.
    ENDIF.
    APPEND ls_control_data TO e_control_data.

*Warehouse No: LIKP-LGNUM
    ls_control_data-paramname =  gc_cp_yn_de_warehouse_no.
    ls_control_data-value     = <ls_xlikp>-lgnum.
    APPEND ls_control_data TO e_control_data.
*Door for warehouse: LIKP-LGTOR
    ls_control_data-paramname =  gc_cp_yn_de_door_no.
    ls_control_data-value     = <ls_xlikp>-lgtor.
    APPEND ls_control_data TO e_control_data.
*Warehouse door text: concatenate T300T-LNUMT '/' T30BT-ltort with LGNUM and LGTOR
    CLEAR lv_ltort.
    SELECT SINGLE ltort INTO lv_ltort FROM t30bt WHERE spras = sy-langu
                                                 AND   lgnum = <ls_xlikp>-lgnum
                                                 AND   lgtor = <ls_xlikp>-lgtor.
    CLEAR lv_lnumt.
    SELECT SINGLE lnumt INTO lv_lnumt FROM t300t WHERE spras = sy-langu
                                                 AND   lgnum = <ls_xlikp>-lgnum.
    CLEAR lv_lgtratxt.
    IF lv_ltort IS NOT INITIAL OR lv_lnumt IS NOT INITIAL.
      CONCATENATE lv_lnumt lv_ltort INTO lv_lgtratxt SEPARATED BY '/'.
    ENDIF.
    ls_control_data-paramname = gc_cp_yn_de_door_txt.
    ls_control_data-value     = lv_lgtratxt.
    APPEND ls_control_data TO e_control_data.

*Shipping point / Departure (LIKP-VSTEL)
    ls_control_data-paramname =  gc_cp_yn_de_shp_pnt.
    ls_control_data-value     = <ls_xlikp>-vstel.
    APPEND ls_control_data TO e_control_data.

*   Shipping Point Location Type
    ls_control_data-paramname = gc_cp_yn_de_shippoint_type.
    ls_control_data-value     = zif_gtt_sof_constants=>cs_loctype-shippingpoint.
    APPEND ls_control_data TO e_control_data.

*Location Type for Shipping point / Departure (LIKP-VSTEL)
    ls_control_data-paramname =  gc_cp_yn_de_shp_pnt_loctype.
    ls_control_data-value     = zif_gtt_sof_constants=>cs_loctype-shippingpoint.
    APPEND ls_control_data TO e_control_data.

*Departure address
    CLEAR lv_adrnr_shpt.
    SELECT SINGLE adrnr INTO lv_adrnr_shpt FROM tvst WHERE vstel = <ls_xlikp>-vstel.
    CLEAR: lt_address, ls_address.
    CALL FUNCTION 'ADDRESS_INTO_PRINTFORM'
      EXPORTING
        address_type            = '1'
        address_number          = lv_adrnr_shpt
      IMPORTING
        address_printform_table = lt_address.
    CLEAR ls_control_data-value.
    LOOP AT lt_address INTO ls_address.
      IF sy-tabix = 1.
        ls_control_data-value = ls_address-address_line.
      ELSE.
        IF ls_address-address_line IS NOT INITIAL.
          CONCATENATE ls_control_data-value ls_address-address_line INTO ls_control_data-value SEPARATED BY '$'.
        ENDIF.
      ENDIF.
    ENDLOOP.
    ls_control_data-paramname =  gc_cp_yn_de_shp_addr.
    APPEND ls_control_data TO e_control_data.
*Departure country
    CLEAR: lv_countryiso, ls_sd_addr.
    CALL FUNCTION 'SD_ADDRESS_GET'
      EXPORTING
        fif_address_number = lv_adrnr_shpt
      IMPORTING
        fes_address        = ls_sd_addr.
    CALL FUNCTION 'COUNTRY_CODE_SAP_TO_ISO'
      EXPORTING
        sap_code = ls_sd_addr-land1
      IMPORTING
        iso_code = lv_countryiso.
    ls_control_data-paramname =  gc_cp_yn_de_shp_countryiso.
    ls_control_data-value     = lv_countryiso.
    APPEND ls_control_data TO e_control_data.

*Destination (LIKP-KUNNR)
    ls_control_data-paramname =  gc_cp_yn_de_dest.
    zcl_gtt_tools=>convert_to_external_frmt(
      EXPORTING
        iv_input  = <ls_xlikp>-kunnr
      IMPORTING
        ev_output = lv_kunnr ).
    ls_control_data-value = lv_kunnr.
    CLEAR lv_kunnr.
    APPEND ls_control_data TO e_control_data.

*Location Type for Destination (LIKP-KUNNR)
    ls_control_data-paramname =  gc_cp_yn_de_dest_loctype.
    ls_control_data-value     = zif_gtt_sof_constants=>cs_loctype-bp.
    APPEND ls_control_data TO e_control_data.

*Ship to type
    ls_control_data-paramname = gc_cp_yn_dlv_shipto_type.
    ls_control_data-value     = zif_gtt_sof_constants=>cs_loctype-bp.
    APPEND ls_control_data TO e_control_data.

*Destination address
    READ TABLE lt_xvbpa ASSIGNING <ls_xvbpa> WITH KEY vbeln = <ls_xlikp>-vbeln
                                                      posnr = '000000'
                                                      parvw = 'WE'.
    CLEAR: lt_address, ls_address.
    IF <ls_xvbpa> IS ASSIGNED AND <ls_xvbpa> IS NOT INITIAL.
      CALL FUNCTION 'ADDRESS_INTO_PRINTFORM'
        EXPORTING
          address_type            = '1'
          address_number          = <ls_xvbpa>-adrnr
        IMPORTING
          address_printform_table = lt_address.
    ENDIF.
    CLEAR ls_control_data-value.
    LOOP AT lt_address INTO ls_address.
      IF sy-tabix = 1.
        ls_control_data-value = ls_address-address_line.
      ELSE.
        IF ls_address-address_line IS NOT INITIAL.
          CONCATENATE ls_control_data-value ls_address-address_line INTO ls_control_data-value SEPARATED BY '$'.
        ENDIF.
      ENDIF.
    ENDLOOP.
    ls_control_data-paramname =  gc_cp_yn_de_dest_addr.
    APPEND ls_control_data TO e_control_data.
*Destination country, Destination email, Destination telephone
    CLEAR: lv_countryiso, ls_sd_addr.
    IF <ls_xvbpa> IS ASSIGNED AND <ls_xvbpa> IS NOT INITIAL.
      CALL FUNCTION 'SD_ADDRESS_GET'
        EXPORTING
          fif_address_number = <ls_xvbpa>-adrnr
        IMPORTING
          fes_address        = ls_sd_addr.
      CALL FUNCTION 'COUNTRY_CODE_SAP_TO_ISO'
        EXPORTING
          sap_code = ls_sd_addr-land1
        IMPORTING
          iso_code = lv_countryiso.
    ENDIF.
    ls_control_data-paramname =  gc_cp_yn_de_dest_countryiso.
    ls_control_data-value     = lv_countryiso.
    APPEND ls_control_data TO e_control_data.

    ls_control_data-paramname =  gc_cp_yn_de_dest_email.
    ls_control_data-value     = ls_sd_addr-email_addr.
    APPEND ls_control_data TO e_control_data.

    ls_control_data-paramname =  gc_cp_yn_de_dest_tele.
    ls_control_data-value     = ls_sd_addr-telf1.
    APPEND ls_control_data TO e_control_data.

*Bill of lading (LIKP-BOLNR)
    ls_control_data-paramname =  gc_cp_yn_de_bol_no.
    ls_control_data-value     = <ls_xlikp>-bolnr.
    APPEND ls_control_data TO e_control_data.
*Incoterms (LIKP-INCO1)
    ls_control_data-paramname =  gc_cp_yn_de_inco1.
    ls_control_data-value     = <ls_xlikp>-inco1.
    APPEND ls_control_data TO e_control_data.
*Incoterms location 1 (LIKP-INCO2_L)
    ls_control_data-paramname =  gc_cp_yn_de_inco2_l.
    ls_control_data-value     = <ls_xlikp>-inco2_l.
    APPEND ls_control_data TO e_control_data.
*Incoterms version (LIKP-INCOV)
    ls_control_data-paramname =  gc_cp_yn_de_incov.
    ls_control_data-value     = <ls_xlikp>-incov.
    APPEND ls_control_data TO e_control_data.

*   fu relevant flag
    CLEAR lt_relation.
    lo_gtt_toolkit->get_relation(
      EXPORTING
        iv_vbeln    = <ls_xlikp>-vbeln  " Delivery
        iv_vbtyp    = <ls_xlikp>-vbtyp  " SD Document Category
      IMPORTING
        et_relation = lt_relation ).

    IF lt_relation IS NOT INITIAL.
      ls_control_data-paramname = gc_cp_yn_fu_relevant.
      ls_control_data-value     = abap_true.
      APPEND ls_control_data TO e_control_data.
    ENDIF.

*   Actual Business Time zone
    CALL FUNCTION 'GET_SYSTEM_TIMEZONE'
      IMPORTING
        timezone            = lv_tzone
      EXCEPTIONS
        customizing_missing = 1
        OTHERS              = 2.
    ls_control_data-paramname = gc_cp_yn_act_timezone.
    ls_control_data-value     = lv_tzone.
    APPEND ls_control_data TO e_control_data.

*   Actual Business Time
    ls_control_data-paramname = gc_cp_yn_act_datetime.
    CONCATENATE '0' sy-datum sy-uzeit INTO ls_control_data-value.
    APPEND ls_control_data TO e_control_data.

*   Actual Technical Datetime & Time zone
    ls_control_data-paramname = gc_cp_yn_acttec_timezone."ACTUAL_TECHNICAL_TIMEZONE
    ls_control_data-value     = lv_tzone.
    APPEND ls_control_data TO e_control_data.

    ls_control_data-paramname = gc_cp_yn_acttec_datetime."ACTUAL_TECHNICAL_DATETIME
    CONCATENATE '0' sy-datum sy-uzeit INTO ls_control_data-value.
    APPEND ls_control_data TO e_control_data.

    ls_control_data-paramname = gc_cp_yn_reported_by.
    ls_control_data-value = sy-uname.
    CONDENSE ls_control_data-value NO-GAPS.
    APPEND ls_control_data TO e_control_data.

    CLEAR ls_control_data-paramindex.
  ENDLOOP.


ENDFUNCTION.
