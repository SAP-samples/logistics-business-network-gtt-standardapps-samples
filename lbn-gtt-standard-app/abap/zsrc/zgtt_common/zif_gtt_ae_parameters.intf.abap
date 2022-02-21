INTERFACE zif_gtt_ae_parameters
  PUBLIC .


  METHODS get_appsys
    RETURNING
      VALUE(rv_appsys) TYPE /saptrx/applsystem .
  METHODS get_event_type
    RETURNING
      VALUE(rs_event_type) TYPE /saptrx/evtypes .
  METHODS get_appl_table
    IMPORTING
      !iv_tabledef   TYPE clike
    RETURNING
      VALUE(rr_data) TYPE REF TO data
    RAISING
      cx_udm_message .
  METHODS get_events
    RETURNING
      VALUE(rr_data) TYPE REF TO data
    RAISING
      cx_udm_message .
ENDINTERFACE.
