INTERFACE zif_gtt_tp_factory
  PUBLIC .


  METHODS get_tp_reader
    IMPORTING
      !io_ef_parameters   TYPE REF TO zif_gtt_ef_parameters
    RETURNING
      VALUE(ro_bo_reader) TYPE REF TO zif_gtt_tp_reader .
  METHODS get_ef_parameters
    IMPORTING
      !iv_appsys              TYPE /saptrx/applsystem
      !is_app_obj_types       TYPE /saptrx/aotypes
      !it_all_appl_tables     TYPE trxas_tabcontainer
      !it_app_type_cntl_tabs  TYPE trxas_apptype_tabs OPTIONAL
      !it_app_objects         TYPE trxas_appobj_ctabs
    RETURNING
      VALUE(ro_ef_parameters) TYPE REF TO zif_gtt_ef_parameters .
  METHODS get_ef_processor
    IMPORTING
      !is_definition         TYPE zif_gtt_ef_types=>ts_definition
      !io_bo_factory         TYPE REF TO zif_gtt_tp_factory
      !iv_appsys             TYPE /saptrx/applsystem
      !is_app_obj_types      TYPE /saptrx/aotypes
      !it_all_appl_tables    TYPE trxas_tabcontainer
      !it_app_type_cntl_tabs TYPE trxas_apptype_tabs
      !it_app_objects        TYPE trxas_appobj_ctabs
    RETURNING
      VALUE(ro_ef_processor) TYPE REF TO zif_gtt_ef_processor
    RAISING
      cx_udm_message .
  METHODS get_pe_filler
    IMPORTING
      !io_ef_parameters   TYPE REF TO zif_gtt_ef_parameters
      !io_bo_reader       TYPE REF TO zif_gtt_tp_reader
    RETURNING
      VALUE(ro_pe_filler) TYPE REF TO zif_gtt_pe_filler
    RAISING
      cx_udm_message .
ENDINTERFACE.
