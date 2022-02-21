interface ZIF_GTT_CTP_TYPES
  public .


  types:
    BEGIN OF ts_evtype,
      trk_obj_type  TYPE /saptrx/trk_obj_type,
      evtype        TYPE /saptrx/evtype,
      trxservername TYPE /saptrx/trxservername,
      eventdatafunc TYPE /saptrx/treventdatafunc,
      evtcnt        TYPE /saptrx/evtcnt,
    END OF ts_evtype .
  types:
    tt_evtype TYPE STANDARD TABLE OF ts_evtype WITH EMPTY KEY .
  types:
    BEGIN OF ts_aotype,
      obj_type    TYPE /saptrx/trk_obj_type,
      aot_type    TYPE /saptrx/aotype,
      server_name TYPE /saptrx/trxservername,
    END OF ts_aotype .
  types:
    tt_aotype TYPE STANDARD TABLE OF ts_aotype WITH EMPTY KEY .
  types:
    tt_trxas_appobj_ctab TYPE STANDARD TABLE OF trxas_appobj_ctab_wa
                                WITH EMPTY KEY .
  types:
    tt_trxas_evt_ctab TYPE STANDARD TABLE OF trxas_evt_ctab_wa
                                WITH EMPTY KEY .
  types:
    tt_aotype_rst  TYPE RANGE OF /saptrx/aotype .
  types:
    tt_evtype_rst  TYPE RANGE OF /saptrx/evtype .
  types:
    tt_trk_obj_type TYPE STANDARD TABLE OF /saptrx/trk_obj_type
                           WITH EMPTY KEY .
  types:
    BEGIN OF ts_idoc_data,
      control      TYPE /saptrx/bapi_trk_control_tab,
      info         TYPE /saptrx/bapi_trk_info_tab,
      tracking_id  TYPE /saptrx/bapi_trk_trkid_tab,
      exp_event    TYPE /saptrx/bapi_trk_ee_tab,
      trxserv      TYPE /saptrx/trxserv,
      appsys       TYPE logsys,
      appobj_ctabs TYPE tt_trxas_appobj_ctab,
    END OF ts_idoc_data .
  types:
    tt_idoc_data TYPE STANDARD TABLE OF ts_idoc_data
                   WITH EMPTY KEY .
  types:
    tt_evm_header     TYPE STANDARD TABLE OF /saptrx/bapi_evm_header WITH EMPTY KEY .
  types:
    tt_evm_locationid TYPE STANDARD TABLE OF /saptrx/bapi_evm_locationid WITH EMPTY KEY .
  types:
    tt_evm_parameters TYPE STANDARD TABLE OF /saptrx/bapi_evm_parameters WITH EMPTY KEY .
  types:
    tt_evm_reference     TYPE STANDARD TABLE OF /saptrx/bapi_evm_reference WITH EMPTY KEY .
  types:
    tt_trxas_evt_ctabs TYPE STANDARD TABLE
                         OF trxas_evt_ctab_wa WITH EMPTY KEY .
  types:
    BEGIN OF ts_idoc_evt_data,
      evt_header     TYPE tt_evm_header,
      evt_locationid TYPE tt_evm_locationid,
      evt_parameters TYPE tt_evm_parameters,
      evt_reference  TYPE tt_evm_reference,
      evt_ctabs      TYPE tt_trxas_evt_ctabs,
      trxserv        TYPE /saptrx/trxserv,
      eventid_map    TYPE trxas_evtid_evtcnt_map,
    END OF ts_idoc_evt_data .
  types:
    tt_idoc_evt_data TYPE STANDARD TABLE OF ts_idoc_evt_data
                   WITH EMPTY KEY .
endinterface.
