INTERFACE zif_gtt_ef_parameters
  PUBLIC .


  METHODS get_appsys
    RETURNING
      VALUE(rv_appsys) TYPE /saptrx/applsystem .
  METHODS get_app_obj_types
    RETURNING
      VALUE(rs_app_obj_types) TYPE /saptrx/aotypes .
  METHODS get_app_objects
    RETURNING
      VALUE(rr_data) TYPE REF TO data .
  METHODS get_appl_table
    IMPORTING
      !iv_tabledef   TYPE clike
    RETURNING
      VALUE(rr_data) TYPE REF TO data
    RAISING
      cx_udm_message .
ENDINTERFACE.
