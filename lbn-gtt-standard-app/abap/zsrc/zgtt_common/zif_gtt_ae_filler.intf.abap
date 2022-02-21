INTERFACE zif_gtt_ae_filler
  PUBLIC .


  METHODS check_relevance
    IMPORTING
      !is_events       TYPE trxas_evt_ctab_wa
    RETURNING
      VALUE(rv_result) TYPE zif_gtt_ef_types=>tv_condition
    RAISING
      cx_udm_message .
  METHODS get_event_data
    IMPORTING
      !is_events          TYPE trxas_evt_ctab_wa
    CHANGING
      !ct_eventid_map     TYPE trxas_evtid_evtcnt_map
      !ct_trackingheader  TYPE zif_gtt_ae_types=>tt_trackingheader
      !ct_tracklocation   TYPE zif_gtt_ae_types=>tt_tracklocation
      !ct_trackreferences TYPE zif_gtt_ae_types=>tt_trackreferences
      !ct_trackparameters TYPE zif_gtt_ae_types=>tt_trackparameters
    RAISING
      cx_udm_message .
ENDINTERFACE.
