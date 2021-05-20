INTERFACE zif_gtt_mia_ctp_tor_types
  PUBLIC .


  TYPES:
    BEGIN OF ts_aotype,
      obj_type    TYPE /saptrx/trk_obj_type,
      aot_type    TYPE /saptrx/aotype,
      server_name TYPE /saptrx/trxservername,
    END OF ts_aotype .
  TYPES:
    tt_aotype TYPE STANDARD TABLE OF ts_aotype WITH EMPTY KEY .
  TYPES:
    tt_trxas_appobj_ctab TYPE STANDARD TABLE OF trxas_appobj_ctab_wa
                                WITH EMPTY KEY .
  TYPES:
    tt_aotype_rst  TYPE RANGE OF /saptrx/aotype .
  TYPES:
    tt_trk_obj_type TYPE STANDARD TABLE OF /saptrx/trk_obj_type
                           WITH EMPTY KEY .
  TYPES:
    BEGIN OF ts_idoc_data,
      control      TYPE /saptrx/bapi_trk_control_tab,
      info         TYPE /saptrx/bapi_trk_info_tab,
      tracking_id  TYPE /saptrx/bapi_trk_trkid_tab,
      exp_event    TYPE /saptrx/bapi_trk_ee_tab,
      trxserv      TYPE /saptrx/trxserv,
      appsys       TYPE logsys,
      appobj_ctabs TYPE tt_trxas_appobj_ctab,
    END OF ts_idoc_data .
  TYPES:
    tt_idoc_data TYPE STANDARD TABLE OF ts_idoc_data
                   WITH EMPTY KEY .
ENDINTERFACE.
