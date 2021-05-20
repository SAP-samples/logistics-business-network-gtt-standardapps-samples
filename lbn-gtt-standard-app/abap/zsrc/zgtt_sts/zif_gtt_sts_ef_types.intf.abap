interface ZIF_GTT_STS_EF_TYPES
  public .


  types TS_CONTROL_DATA type /SAPTRX/CONTROL_DATA .
  types:
    tt_control_data TYPE STANDARD TABLE OF ts_control_data .
  types:
    BEGIN OF ts_enh_track_id_data,
           key TYPE char33.
           INCLUDE TYPE /saptrx/track_id_data.
  TYPES: END OF ts_enh_track_id_data .
  types:
    tt_enh_track_id_data TYPE STANDARD TABLE OF ts_enh_track_id_data .
  types TS_TRACK_ID_DATA type /SAPTRX/TRACK_ID_DATA .
  types:
    tt_track_id_data TYPE STANDARD TABLE OF ts_track_id_data .
  types TS_STRUCDATADEF type /SAPTRX/STRUCDATADEF .
  types:
    tt_strucdatadef TYPE STANDARD TABLE OF ts_strucdatadef .
  types TS_EXPEVENTDATA type /SAPTRX/EXP_EVENTS .
  types:
    tt_expeventdata TYPE STANDARD TABLE OF ts_expeventdata .
  types TS_MEASRMNTDATA type /SAPTRX/MEASR_DATA .
  types:
    tt_measrmntdata TYPE STANDARD TABLE OF ts_measrmntdata .
  types TS_INFODATA type /SAPTRX/INFO_DATA .
  types:
    tt_infodata TYPE STANDARD TABLE OF ts_infodata .
  types:
    BEGIN OF ts_definition,
           maintab   TYPE /saptrx/strucdatadef,
           mastertab TYPE /saptrx/strucdatadef,
         END OF ts_definition .
  types:
    tt_tracklocation  TYPE STANDARD TABLE OF /saptrx/bapi_evm_locationid .
  types:
    tt_trackingheader TYPE STANDARD TABLE OF /saptrx/bapi_evm_header .
  types TV_CONDITION type SY-BINPT .
  types:
    BEGIN OF ts_stop_points,
           stop_id   TYPE string,
           log_locid TYPE /scmtms/location_id,
           seq_num   TYPE /scmtms/seq_num,
         END OF ts_stop_points .
  types:
    tt_stop_points TYPE STANDARD TABLE OF ts_stop_points .
endinterface.
