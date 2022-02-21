INTERFACE zif_gtt_pe_filler
  PUBLIC .


  METHODS check_relevance
    IMPORTING
      !is_app_objects  TYPE trxas_appobj_ctab_wa
    RETURNING
      VALUE(rv_result) TYPE zif_gtt_ef_types=>tv_condition
    RAISING
      cx_udm_message .
  METHODS get_planed_events
    IMPORTING
      !is_app_objects  TYPE trxas_appobj_ctab_wa
    CHANGING
      !ct_expeventdata TYPE zif_gtt_ef_types=>tt_expeventdata
      !ct_measrmntdata TYPE zif_gtt_ef_types=>tt_measrmntdata
      !ct_infodata     TYPE zif_gtt_ef_types=>tt_infodata
    RAISING
      cx_udm_message .
ENDINTERFACE.
