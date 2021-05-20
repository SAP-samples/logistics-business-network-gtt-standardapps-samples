CLASS zcl_gtt_sts_factory DEFINITION
  PUBLIC
  ABSTRACT
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES zif_gtt_sts_factory .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_GTT_STS_FACTORY IMPLEMENTATION.


  METHOD zif_gtt_sts_factory~get_bo_reader.
    RETURN.
  ENDMETHOD.


  METHOD zif_gtt_sts_factory~get_ef_parameters.

    ro_ef_parameters  = NEW zcl_gtt_sts_ef_parameters(
      iv_appsys             = iv_appsys
      is_app_obj_types      = is_app_obj_types
      it_all_appl_tables    = it_all_appl_tables
      it_app_type_cntl_tabs = it_app_type_cntl_tabs
      it_app_objects        = it_app_objects ).

  ENDMETHOD.


  METHOD zif_gtt_sts_factory~get_ef_processor.

    DATA:
      lo_ef_parameters TYPE REF TO zif_gtt_sts_ef_parameters,
      lo_bo_reader     TYPE REF TO zif_gtt_sts_bo_reader,
      lo_pe_filler     TYPE REF TO zif_gtt_sts_pe_filler.

    lo_ef_parameters = zif_gtt_sts_factory~get_ef_parameters(
                           iv_appsys             = iv_appsys
                           is_app_obj_types      = is_app_obj_types
                           it_all_appl_tables    = it_all_appl_tables
                           it_app_type_cntl_tabs = it_app_type_cntl_tabs
                           it_app_objects        = it_app_objects ).

    ro_ef_processor = NEW zcl_gtt_sts_ef_processor(
                              io_ef_parameters = lo_ef_parameters
                              io_bo_reader     = lo_bo_reader
                              io_pe_filler     = lo_pe_filler
                              is_definition    = is_definition ).

  ENDMETHOD.


  METHOD zif_gtt_sts_factory~get_pe_filler.
    RETURN.
  ENDMETHOD.
ENDCLASS.
