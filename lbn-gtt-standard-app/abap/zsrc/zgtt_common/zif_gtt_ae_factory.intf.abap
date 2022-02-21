INTERFACE zif_gtt_ae_factory
  PUBLIC .


  METHODS get_ae_filler
    IMPORTING
      !io_ae_parameters   TYPE REF TO zif_gtt_ae_parameters
    RETURNING
      VALUE(ro_ae_filler) TYPE REF TO zif_gtt_ae_filler
    RAISING
      cx_udm_message .
  METHODS get_ae_parameters
    IMPORTING
      !iv_appsys               TYPE /saptrx/applsystem
      !is_event_type           TYPE /saptrx/evtypes
      !it_all_appl_tables      TYPE trxas_tabcontainer
      !it_event_type_cntl_tabs TYPE trxas_eventtype_tabs OPTIONAL
      !it_events               TYPE trxas_evt_ctabs
    RETURNING
      VALUE(ro_ae_parameters)  TYPE REF TO zif_gtt_ae_parameters
    RAISING
      cx_udm_message .
  METHODS get_ae_processor
    IMPORTING
      !is_definition           TYPE zif_gtt_ef_types=>ts_definition
      !io_ae_factory           TYPE REF TO zif_gtt_ae_factory
      !iv_appsys               TYPE /saptrx/applsystem
      !is_event_type           TYPE /saptrx/evtypes
      !it_all_appl_tables      TYPE trxas_tabcontainer
      !it_event_type_cntl_tabs TYPE trxas_eventtype_tabs OPTIONAL
      !it_events               TYPE trxas_evt_ctabs
    RETURNING
      VALUE(ro_ae_processor)   TYPE REF TO zif_gtt_ae_processor
    RAISING
      cx_udm_message .
ENDINTERFACE.
