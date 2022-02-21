FUNCTION ZGTT_SSOF_EE_DE_POD.
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
  FIELD-SYMBOLS:
*   Work Structure for Delivery Header
    <ls_xlikp> TYPE likpvb,
*   Work Structure for Delivery Item
    <ls_xlips> TYPE lipsvb.

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
*   BAPI structure for Event Handler control parameters
    ls_parameters     TYPE /saptrx/bapi_evm_parameters,
    lt_lips           TYPE TABLE OF lipsvb,
    lt_tvpod          TYPE TABLE OF tvpodvb,
    lv_podmg          TYPE tvpod-podmg.

* <1> Fill general data for all control data records
* Login Language
  ls_trackingheader-language   = sy-langu.

* <2> Loop at application objects for geting Delivery item data
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

*   POD Event Code Set
    ls_trackingheader-trxcod = zif_gtt_sof_constants=>cs_trxcod-out_delivery_item.
*   Item ID
    ls_trackingheader-trxid = |{ <ls_xlips>-vbeln ALPHA = OUT } { <ls_xlips>-posnr ALPHA = IN }|.
    CONDENSE ls_trackingheader-trxid NO-GAPS.

*   < POD >
*   Counter for Event
    ls_trackingheader-evtcnt  = ls_events-eventid.
*   Event ID
    ls_trackingheader-evtid   = zif_gtt_sof_constants=>cs_milestone-dlv_item_pod.
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
    CONCATENATE <ls_xlips>-vbeln <ls_xlips>-posnr INTO ls_tracklocation-locid2.
    SHIFT ls_tracklocation-locid2 LEFT DELETING LEADING '0'.
    APPEND ls_tracklocation TO ct_tracklocation.

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

*   POD quantity
    CLEAR:
      lt_tvpod,
      lt_lips,
      lv_podmg.
    APPEND <ls_xlips> TO lt_lips.
    CALL FUNCTION 'LE_POD_TVPOD_READ'
      TABLES
        it_lips  = lt_lips
        et_tvpod = lt_tvpod.

    READ TABLE lt_tvpod INTO DATA(ls_tvpod)
      WITH KEY vbeln = <ls_xlips>-vbeln
               posnr = <ls_xlips>-posnr.
    IF sy-subrc = 0.
      lv_podmg = ls_tvpod-podmg.     "Actual quantity accepted in sales unit per delivery item
    ELSE.
      lv_podmg = <ls_xlips>-g_lfimg. "Actual quantity delivered (in sales units)
    ENDIF.
    CLEAR ls_parameters.
    ls_parameters-evtcnt = ls_events-eventid.
    ls_parameters-param_name = 'QUANTITY'.
    ls_parameters-param_value = lv_podmg.
    SHIFT ls_parameters-param_value LEFT DELETING LEADING space.
    APPEND ls_parameters TO ct_trackparameters.

  ENDLOOP.

ENDFUNCTION.
