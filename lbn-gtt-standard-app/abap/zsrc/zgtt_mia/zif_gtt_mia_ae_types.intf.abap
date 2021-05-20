INTERFACE zif_gtt_mia_ae_types
  PUBLIC .


  TYPES ts_trackingheader TYPE /saptrx/bapi_evm_header .
  TYPES:
    tt_trackingheader TYPE STANDARD TABLE OF ts_trackingheader .
  TYPES ts_tracklocation TYPE /saptrx/bapi_evm_locationid .
  TYPES:
    tt_tracklocation TYPE STANDARD TABLE OF ts_tracklocation .
  TYPES ts_trackreferences TYPE /saptrx/bapi_evm_reference .
  TYPES:
    tt_trackreferences TYPE STANDARD TABLE OF ts_trackreferences .
  TYPES ts_trackparameters TYPE /saptrx/bapi_evm_parameters .
  TYPES:
    tt_trackparameters TYPE STANDARD TABLE OF ts_trackparameters .
ENDINTERFACE.
