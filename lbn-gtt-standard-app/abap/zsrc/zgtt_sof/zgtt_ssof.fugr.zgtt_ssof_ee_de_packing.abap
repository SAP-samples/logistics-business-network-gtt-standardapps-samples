FUNCTION zgtt_ssof_ee_de_packing.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(I_APPSYS) TYPE  /SAPTRX/APPLSYSTEM
*"     REFERENCE(I_EVENT_TYPE) TYPE  /SAPTRX/EVTYPES
*"     REFERENCE(I_ALL_APPL_TABLES) TYPE  TRXAS_TABCONTAINER
*"     REFERENCE(I_EVENT_TYPE_CNTL_TABS) TYPE  TRXAS_EVENTTYPE_TABS
*"     REFERENCE(I_EVENTS) TYPE  TRXAS_EVT_CTABS
*"  TABLES
*"      CT_TRACKINGHEADER STRUCTURE  /SAPTRX/BAPI_EVM_HEADER
*"      CT_TRACKLOCATION STRUCTURE  /SAPTRX/BAPI_EVM_LOCATIONID
*"       OPTIONAL
*"      CT_TRACKADDRESS STRUCTURE  /SAPTRX/BAPI_EVM_ADDRESS OPTIONAL
*"      CT_TRACKLOCATIONDESCR STRUCTURE  /SAPTRX/BAPI_EVM_LOCDESCR
*"       OPTIONAL
*"      CT_TRACKLOCADDITIONALID STRUCTURE  /SAPTRX/BAPI_EVM_LOCADDID
*"       OPTIONAL
*"      CT_TRACKPARTNERID STRUCTURE  /SAPTRX/BAPI_EVM_PARTNERID
*"       OPTIONAL
*"      CT_TRACKPARTNERADDID STRUCTURE  /SAPTRX/BAPI_EVM_PARTNERADDID
*"       OPTIONAL
*"      CT_TRACKESTIMDEADLINE STRUCTURE  /SAPTRX/BAPI_EVM_ESTIMDEADL
*"       OPTIONAL
*"      CT_TRACKCONFIRMSTATUS STRUCTURE  /SAPTRX/BAPI_EVM_CONFSTAT
*"       OPTIONAL
*"      CT_TRACKNEXTEVENT STRUCTURE  /SAPTRX/BAPI_EVM_NEXTEVENT
*"       OPTIONAL
*"      CT_TRACKNEXTEVDEADLINES STRUCTURE  /SAPTRX/BAPI_EVM_NEXTEVDEADL
*"       OPTIONAL
*"      CT_TRACKREFERENCES STRUCTURE  /SAPTRX/BAPI_EVM_REFERENCE
*"       OPTIONAL
*"      CT_TRACKMEASURESULTS STRUCTURE  /SAPTRX/BAPI_EVM_MEASRESULT
*"       OPTIONAL
*"      CT_TRACKSTATUSATTRIB STRUCTURE  /SAPTRX/BAPI_EVM_STATUSATTR
*"       OPTIONAL
*"      CT_TRACKPARAMETERS STRUCTURE  /SAPTRX/BAPI_EVM_PARAMETERS
*"       OPTIONAL
*"      CT_TRACKFILEHEADER STRUCTURE  /SAPTRX/BAPI_EVM_FILEHEADER
*"       OPTIONAL
*"      CT_TRACKFILEREF STRUCTURE  /SAPTRX/BAPI_EVM_FILEREF OPTIONAL
*"      CT_TRACKFILEBIN STRUCTURE  /SAPTRX/BAPI_EVM_FILEBIN OPTIONAL
*"      CT_TRACKFILECHAR STRUCTURE  /SAPTRX/BAPI_EVM_FILECHAR OPTIONAL
*"      CT_TRACKTEXTHEADER STRUCTURE  /SAPTRX/BAPI_EVM_TEXTHEADER
*"       OPTIONAL
*"      CT_TRACKTEXTLINES STRUCTURE  /SAPTRX/BAPI_EVM_TEXTLINES
*"       OPTIONAL
*"      CT_TRACKEEMODIFY STRUCTURE  /SAPTRX/BAPI_EVM_EE_MODIFY OPTIONAL
*"      CT_EXTENSIONIN STRUCTURE  BAPIPAREX OPTIONAL
*"      CT_EXTENSIONOUT STRUCTURE  BAPIPAREX OPTIONAL
*"      CT_LOGTABLE STRUCTURE  BAPIRET2 OPTIONAL
*"  CHANGING
*"     REFERENCE(C_EVENTID_MAP) TYPE  TRXAS_EVTID_EVTCNT_MAP
*"  EXCEPTIONS
*"      PARAMETER_ERROR
*"      EVENT_DATA_ERROR
*"      STOP_PROCESSING
*"----------------------------------------------------------------------
*----------------------------------------------------------------------*
* Top Include
* TYPE-POOLS:trxas.
*----------------------------------------------------------------------*
  DATA:
*   Container with references
    ls_one_app_tables TYPE trxas_tabcontainer_wa,
*   Definition of all event type
    ls_events         TYPE trxas_evt_ctab_wa,
*   Bapi for message input: message Header
    ls_trackingheader TYPE /saptrx/bapi_evm_header,
*   Event Mapping
    ls_eventid_map    TYPE trxas_evtid_evtcnt_map_wa,
*   Location  table for event message input
    ls_tracklocation  TYPE /saptrx/bapi_evm_locationid,
*   Packing quantity
    ls_parameters     TYPE /saptrx/bapi_evm_parameters,
*   Packing item table new
    lt_xvepo          TYPE STANDARD TABLE OF vepovb,
*   Packing item table old
    lt_yvepo          TYPE STANDARD TABLE OF vepovb,
    lv_vemng          TYPE vepovb-vemng,
    lv_vemng_out      TYPE vepovb-vemng,
    lv_factor         TYPE f.

  FIELD-SYMBOLS:
*   Work Structure for Delivery Header
    <ls_xlikp> TYPE likpvb,
*   Work Structure for Delivery Item
    <ls_xlips> TYPE lipsvb,
*   Work Structure for Packing Item
    <ls_xvepo> TYPE vepovb.

* <1> Load packing item table
  PERFORM read_appl_tables_packing_item
  TABLES  lt_xvepo
          lt_yvepo
  USING   i_all_appl_tables.

* <2> Fill general data for all control data records
* Login Language
  ls_trackingheader-language   = sy-langu.

* <3> Loop at application objects for geting Shipment item data
  LOOP AT i_events INTO ls_events.
*   Check if Main table is Delivery Item or not.
    IF ls_events-maintabdef <> gc_bpt_delivery_item_new.
      PERFORM create_logtable_et
          TABLES ct_logtable
          USING  ls_events-maintabdef
                 space
                 i_event_type-eventdatafunc
                 ls_events-eventtype
                 i_appsys.
      EXIT.
    ENDIF.

*   Check if Master table is Delivery Header or not.
    IF ls_events-mastertabdef <> gc_bpt_delivery_header_new.
      PERFORM create_logtable_et
          TABLES ct_logtable
          USING  ls_events-mastertabdef
                 space
                 i_event_type-eventdatafunc
                 ls_events-eventtype
                 i_appsys.
      EXIT.
    ENDIF.

*   Read Mater Object Table (Delivery Header - LIKPVB)
    ASSIGN ls_events-mastertabref->* TO <ls_xlikp>.
*   Read Main Object Table (Delivery Item - LIPSVB)
    ASSIGN ls_events-maintabref->* TO <ls_xlips>.

*   Packing Event Code Set
    ls_trackingheader-trxcod = zif_gtt_sof_constants=>cs_trxcod-out_delivery_item.
*   Item ID
    ls_trackingheader-trxid = |{ <ls_xlips>-vbeln ALPHA = OUT } { <ls_xlips>-posnr ALPHA = IN }|.
    CONDENSE ls_trackingheader-trxid NO-GAPS.

*   < Packing >
*   Counter for Event
    ls_trackingheader-evtcnt  = ls_events-eventid.
*   Event ID
    ls_trackingheader-evtid   = 'PACKING'.
*   Event Date
    ls_trackingheader-evtdat  = sy-datum.
*   Event Time
    ls_trackingheader-evttim  = sy-uzeit.
*   Event Time Zone
    CALL FUNCTION 'GET_SYSTEM_TIMEZONE'
      IMPORTING
        timezone            = ls_trackingheader-evtzon
      EXCEPTIONS
        customizing_missing = 1
        OTHERS              = 2.

    APPEND ls_trackingheader TO ct_trackingheader.

*   Mapping table
    ls_eventid_map-eventid    = ls_events-eventid.
    ls_eventid_map-evtcnt     = ls_events-eventid.
    APPEND ls_eventid_map TO c_eventid_map.

    ls_tracklocation-evtcnt = ls_events-eventid.
    ls_tracklocation-loccod = zif_gtt_sof_constants=>cs_loctype-shippingpoint.
    ls_tracklocation-locid1 = <ls_xlikp>-vstel.
    APPEND ls_tracklocation TO ct_tracklocation.

*   packing quantity
    CLEAR:
     ls_parameters,
     lv_vemng,
     lv_vemng_out,
     lv_factor.
    ls_parameters-evtcnt = ls_events-eventid.
    ls_parameters-param_name = 'QUANTITY'.
    LOOP AT lt_xvepo ASSIGNING <ls_xvepo>
                     WHERE vbeln = <ls_xlips>-vbeln
                     AND   posnr = <ls_xlips>-posnr.
      lv_vemng = lv_vemng + <ls_xvepo>-vemng.
    ENDLOOP.
    IF <ls_xvepo> IS ASSIGNED.
      CALL FUNCTION 'MC_UNIT_CONVERSION'
        EXPORTING
          matnr                = <ls_xvepo>-matnr
          nach_meins           = <ls_xvepo>-altme
          von_meins            = <ls_xvepo>-vemeh
        IMPORTING
          umref                = lv_factor
        EXCEPTIONS
          conversion_not_found = 1
          material_not_found   = 2
          nach_meins_missing   = 3
          overflow             = 4
          von_meins_missing    = 5
          OTHERS               = 6.
    ENDIF.
    lv_vemng_out = lv_vemng * lv_factor.
    ls_parameters-param_value = lv_vemng_out.
    SHIFT ls_parameters-param_value LEFT  DELETING LEADING space.
    APPEND ls_parameters TO ct_trackparameters.

*   Actual Technical Datetime & Time zone
    CLEAR ls_parameters.
    ls_parameters-evtcnt = ls_events-eventid.
    ls_parameters-param_name = gc_cp_yn_acttec_timezone."ACTUAL_TECHNICAL_TIMEZONE
    ls_parameters-param_value = ls_trackingheader-evtzon.
    APPEND ls_parameters TO ct_trackparameters.

    CLEAR ls_parameters.
    ls_parameters-evtcnt = ls_events-eventid.
    ls_parameters-param_name = gc_cp_yn_acttec_datetime."ACTUAL_TECHNICAL_DATETIME
    CONCATENATE '0' sy-datum sy-uzeit INTO ls_parameters-param_value.
    APPEND ls_parameters TO ct_trackparameters.

    CLEAR ls_parameters.
    ls_parameters-evtcnt = ls_events-eventid.
    ls_parameters-param_name = gc_cp_yn_reported_by."Reported_by
    ls_parameters-param_value = sy-uname.
    APPEND ls_parameters TO ct_trackparameters.

  ENDLOOP.
ENDFUNCTION.
