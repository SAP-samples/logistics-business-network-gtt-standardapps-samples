INTERFACE zif_gtt_sts_ef_types
  PUBLIC .


  TYPES ts_control_data TYPE /saptrx/control_data .
  TYPES:
    tt_control_data TYPE STANDARD TABLE OF ts_control_data .
  TYPES:
    BEGIN OF ts_enh_track_id_data,
      key TYPE char33.
      INCLUDE TYPE /saptrx/track_id_data.
  TYPES: END OF ts_enh_track_id_data .
  TYPES:
    tt_enh_track_id_data TYPE STANDARD TABLE OF ts_enh_track_id_data .
  TYPES ts_track_id_data TYPE /saptrx/track_id_data .
  TYPES:
    tt_track_id_data TYPE STANDARD TABLE OF ts_track_id_data .
  TYPES ts_strucdatadef TYPE /saptrx/strucdatadef .
  TYPES:
    tt_strucdatadef TYPE STANDARD TABLE OF ts_strucdatadef .
  TYPES ts_expeventdata TYPE /saptrx/exp_events .
  TYPES:
    tt_expeventdata TYPE STANDARD TABLE OF ts_expeventdata .
  TYPES ts_measrmntdata TYPE /saptrx/measr_data .
  TYPES:
    tt_measrmntdata TYPE STANDARD TABLE OF ts_measrmntdata .
  TYPES ts_infodata TYPE /saptrx/info_data .
  TYPES:
    tt_infodata TYPE STANDARD TABLE OF ts_infodata .
  TYPES:
    BEGIN OF ts_definition,
      maintab   TYPE /saptrx/strucdatadef,
      mastertab TYPE /saptrx/strucdatadef,
    END OF ts_definition .
  TYPES:
    tt_tracklocation  TYPE STANDARD TABLE OF /saptrx/bapi_evm_locationid .
  TYPES:
    tt_trackingheader TYPE STANDARD TABLE OF /saptrx/bapi_evm_header .
  TYPES tv_condition TYPE sy-binpt .
  TYPES:
    BEGIN OF ts_stop_points,
      stop_id   TYPE string,
      log_locid TYPE /scmtms/location_id,
      seq_num   TYPE /scmtms/seq_num,
    END OF ts_stop_points .
  TYPES:
    tt_stop_points TYPE STANDARD TABLE OF ts_stop_points .

ENDINTERFACE.
