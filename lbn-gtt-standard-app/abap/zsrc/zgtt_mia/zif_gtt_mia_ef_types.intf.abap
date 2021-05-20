INTERFACE zif_gtt_mia_ef_types
  PUBLIC .


  TYPES ts_control_data TYPE /saptrx/control_data .
  TYPES:
    tt_control_data TYPE STANDARD TABLE OF ts_control_data .
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
  TYPES tv_parameter_id TYPE i .
  TYPES tv_parameter_value TYPE char50 .
  TYPES tv_condition TYPE sy-binpt .
  TYPES tv_field_name TYPE char20 .
  TYPES:
    tt_field_name TYPE STANDARD TABLE OF tv_field_name
                              WITH EMPTY KEY .
  TYPES tv_currency_amnt TYPE bapicurr_d .
ENDINTERFACE.
