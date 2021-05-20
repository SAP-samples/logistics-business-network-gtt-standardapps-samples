INTERFACE zif_gtt_mia_ef_processor
  PUBLIC .


  METHODS check_app_objects
    RAISING
      cx_udm_message .
  METHODS check_relevance
    RETURNING
      VALUE(rv_result) TYPE zif_gtt_mia_ef_types=>tv_condition
    RAISING
      cx_udm_message .
  METHODS get_control_data
    CHANGING
      !ct_control_data TYPE zif_gtt_mia_ef_types=>tt_control_data
    RAISING
      cx_udm_message .
  METHODS get_track_id_data
    EXPORTING
      !et_track_id_data TYPE zif_gtt_mia_ef_types=>tt_track_id_data
    RAISING
      cx_udm_message .
  METHODS get_planned_events
    CHANGING
      !ct_expeventdata TYPE zif_gtt_mia_ef_types=>tt_expeventdata
      !ct_measrmntdata TYPE zif_gtt_mia_ef_types=>tt_measrmntdata
      !ct_infodata     TYPE zif_gtt_mia_ef_types=>tt_infodata
    RAISING
      cx_udm_message .
ENDINTERFACE.
