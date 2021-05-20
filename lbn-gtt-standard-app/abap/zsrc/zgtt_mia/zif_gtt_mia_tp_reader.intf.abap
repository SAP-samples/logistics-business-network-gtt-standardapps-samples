INTERFACE zif_gtt_mia_tp_reader
  PUBLIC .


  METHODS check_relevance
    IMPORTING
      !is_app_object   TYPE trxas_appobj_ctab_wa
    RETURNING
      VALUE(rv_result) TYPE zif_gtt_mia_ef_types=>tv_condition
    RAISING
      cx_udm_message .
  METHODS get_data
    IMPORTING
      !is_app_object TYPE trxas_appobj_ctab_wa
    RETURNING
      VALUE(rr_data) TYPE REF TO data
    RAISING
      cx_udm_message .
  METHODS get_data_old
    IMPORTING
      !is_app_object TYPE trxas_appobj_ctab_wa
    RETURNING
      VALUE(rr_data) TYPE REF TO data
    RAISING
      cx_udm_message .
  METHODS get_field_parameter
    IMPORTING
      !iv_field_name   TYPE clike
      !iv_parameter    TYPE zif_gtt_mia_ef_types=>tv_parameter_id
    RETURNING
      VALUE(rv_result) TYPE zif_gtt_mia_ef_types=>tv_parameter_value
    RAISING
      cx_udm_message .
  METHODS get_mapping_structure
    RETURNING
      VALUE(rr_data) TYPE REF TO data .
  METHODS get_track_id_data
    IMPORTING
      !is_app_object    TYPE trxas_appobj_ctab_wa
    EXPORTING
      !et_track_id_data TYPE zif_gtt_mia_ef_types=>tt_track_id_data
    RAISING
      cx_udm_message .
ENDINTERFACE.
