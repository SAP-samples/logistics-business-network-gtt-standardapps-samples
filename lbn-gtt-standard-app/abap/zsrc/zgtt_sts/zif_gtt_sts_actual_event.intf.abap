interface ZIF_GTT_STS_ACTUAL_EVENT
  public .


  types:
    tt_tracklocation   TYPE STANDARD TABLE OF /saptrx/bapi_evm_locationid .
  types:
    tt_trackingheader  TYPE STANDARD TABLE OF /saptrx/bapi_evm_header .
  types:
    tt_trackparameters TYPE STANDARD TABLE OF /saptrx/bapi_evm_parameters .
  types:
    tt_execution_info  TYPE STANDARD TABLE OF /scmtms/s_em_bo_tor_execinfo WITH DEFAULT KEY .

  constants:
    BEGIN OF cs_location_type,
      logistic TYPE string VALUE 'LogisticLocation',
    END OF cs_location_type .
  constants CV_TOR_TRK_OBJ_TYP type /SAPTRX/TRK_OBJ_TYPE value 'TMS_TOR' ##NO_TEXT.
  constants:
    BEGIN OF cs_tabledef,
      tor_stop                  TYPE string VALUE 'TOR_STOP',
      tor_root                  TYPE string VALUE 'TOR_ROOT',
      tor_execution_info        TYPE string VALUE 'TOR_EXECUTION_INFO',
      tor_execution_info_before TYPE string VALUE 'TOR_EXECUTION_INFO_BEFORE',
    END OF cs_tabledef .
  constants:
    BEGIN OF cs_event_id,
      BEGIN OF standard,
        departure    TYPE /saptrx/ev_evtid VALUE 'DEPARTURE',
        arrival      TYPE /saptrx/ev_evtid VALUE 'ARRIV_DEST',
        pod          TYPE /saptrx/ev_evtid VALUE 'POD',
        popu         TYPE /saptrx/ev_evtid VALUE 'POPU',
        load_begin   TYPE /saptrx/ev_evtid VALUE 'LOAD_BEGIN',
        load_end     TYPE /saptrx/ev_evtid VALUE 'LOAD_END',
        coupling     TYPE /saptrx/ev_evtid VALUE 'COUPLING',
        decoupling   TYPE /saptrx/ev_evtid VALUE 'DECOUPLING',
        unload_begin TYPE /saptrx/ev_evtid VALUE 'UNLOAD_BEGIN',
        unload_end   TYPE /saptrx/ev_evtid VALUE 'UNLOAD_END',
        delay        TYPE /saptrx/ev_evtid VALUE 'DELAYED',
        delay_fu     TYPE /saptrx/ev_evtid VALUE 'DELAYED_FU',
      END OF standard,
      BEGIN OF model,
        shp_departure TYPE /saptrx/ev_evtid VALUE 'DEPARTURE',
        shp_arrival   TYPE /saptrx/ev_evtid VALUE 'ARRIV_DEST',
        shp_pod       TYPE /saptrx/ev_evtid VALUE 'POD',
        popu          TYPE /saptrx/ev_evtid VALUE 'POPU',
        load_start    TYPE /saptrx/ev_evtid VALUE 'LOAD_BEGIN',
        load_end      TYPE /saptrx/ev_evtid VALUE 'LOAD_END',
        coupling      TYPE /saptrx/ev_evtid VALUE 'COUPLING',
        decoupling    TYPE /saptrx/ev_evtid VALUE 'DECOUPLING',
        unload_begin  TYPE /saptrx/ev_evtid VALUE 'UNLOAD_BEGIN',
        unload_end    TYPE /saptrx/ev_evtid VALUE 'UNLOAD_END',
        delay         TYPE /saptrx/ev_evtid VALUE 'DELAYED',
      END OF model,
    END OF cs_event_id .

  methods PROCESS_ACTUAL_EVENT
    importing
      !IV_APPSYS type /SAPTRX/APPLSYSTEM
      !IT_EVENT_TYPE type /SAPTRX/EVTYPES
      !IT_ALL_APPL_TABLES type TRXAS_TABCONTAINER
      !IT_EVENT_TYPE_CNTL_TABS type TRXAS_EVENTTYPE_TABS
      !IT_EVENTS type TRXAS_EVT_CTABS
      !IV_EVENT_CODE type /SCMTMS/TOR_EVENT
    changing
      !CT_TRACKINGHEADER type TT_TRACKINGHEADER
      !CT_TRACKLOCATION type TT_TRACKLOCATION
      !CT_TRACKPARAMETERS type TT_TRACKPARAMETERS
      !CT_EVENTID_MAP type TRXAS_EVTID_EVTCNT_MAP
    raising
      CX_UDM_MESSAGE .
  methods CHECK_EVENT_RELEVANCE
    importing
      !IT_ALL_APPL_TABLES type TRXAS_TABCONTAINER
      !IV_EVENT_CODE type /SCMTMS/TOR_EVENT
      !IS_EVENT type TRXAS_EVT_CTAB_WA
    exporting
      !EV_RESULT like SY-BINPT .
  methods EXTRACT_EVENT
    importing
      !IS_EXECINFO type /SCMTMS/S_EM_BO_TOR_EXECINFO
      !IV_EVT_CNT type /SAPTRX/EVTCNT
      !IS_EVENT type TRXAS_EVT_CTAB_WA
      !IS_TRACKINGHEADER type /SAPTRX/BAPI_EVM_HEADER
      !IT_ALL_APPL_TABLES type TRXAS_TABCONTAINER
      !IV_EVENT_CODE type /SCMTMS/TOR_EVENT
    changing
      !CT_TRACKINGHEADER type TT_TRACKINGHEADER
      !CT_TRACKLOCATION type TT_TRACKLOCATION
      !CT_TRACKPARAMETERS type TT_TRACKPARAMETERS
      !CT_EVENTID_MAP type TRXAS_EVTID_EVTCNT_MAP
    raising
      CX_UDM_MESSAGE .
endinterface.
