class ZCL_GTT_STS_EF_PERFORMER definition
  public
  create public .

public section.

  types:
    BEGIN OF ts_definition,
        maintab   TYPE /saptrx/strucdatadef,
        mastertab TYPE /saptrx/strucdatadef,
      END OF ts_definition .

  class-methods CHECK_RELEVANCE
    importing
      !IS_DEFINITION type TS_DEFINITION
      !IO_BO_FACTORY type ref to ZIF_GTT_STS_FACTORY
      !IV_APPSYS type /SAPTRX/APPLSYSTEM
      !IS_APP_OBJ_TYPES type /SAPTRX/AOTYPES
      !IT_ALL_APPL_TABLES type TRXAS_TABCONTAINER
      !IT_APP_TYPE_CNTL_TABS type TRXAS_APPTYPE_TABS optional
      !IT_APP_OBJECTS type TRXAS_APPOBJ_CTABS
    returning
      value(RV_RESULT) type SY-BINPT
    raising
      CX_UDM_MESSAGE .
  class-methods GET_CONTROL_DATA
    importing
      !IS_DEFINITION type ZIF_GTT_STS_EF_TYPES=>TS_DEFINITION
      !IO_BO_FACTORY type ref to ZIF_GTT_STS_FACTORY
      !IV_APPSYS type /SAPTRX/APPLSYSTEM
      !IS_APP_OBJ_TYPES type /SAPTRX/AOTYPES
      !IT_ALL_APPL_TABLES type TRXAS_TABCONTAINER
      !IT_APP_TYPE_CNTL_TABS type TRXAS_APPTYPE_TABS
      !IT_APP_OBJECTS type TRXAS_APPOBJ_CTABS
    changing
      !CT_CONTROL_DATA type ZIF_GTT_STS_EF_TYPES=>TT_CONTROL_DATA
    raising
      CX_UDM_MESSAGE .
  class-methods GET_PLANNED_EVENTS
    importing
      !IS_DEFINITION type ZIF_GTT_STS_EF_TYPES=>TS_DEFINITION
      !IO_FACTORY type ref to ZIF_GTT_STS_FACTORY
      !IV_APPSYS type /SAPTRX/APPLSYSTEM
      !IS_APP_OBJ_TYPES type /SAPTRX/AOTYPES
      !IT_ALL_APPL_TABLES type TRXAS_TABCONTAINER
      !IT_APP_TYPE_CNTL_TABS type TRXAS_APPTYPE_TABS
      !IT_APP_OBJECTS type TRXAS_APPOBJ_CTABS
    changing
      !CT_EXPEVENTDATA type ZIF_GTT_STS_EF_TYPES=>TT_EXPEVENTDATA
      !CT_MEASRMNTDATA type ZIF_GTT_STS_EF_TYPES=>TT_MEASRMNTDATA
      !CT_INFODATA type ZIF_GTT_STS_EF_TYPES=>TT_INFODATA
    raising
      CX_UDM_MESSAGE .
  class-methods GET_TRACK_ID_DATA
    importing
      !IS_DEFINITION type ZIF_GTT_STS_EF_TYPES=>TS_DEFINITION
      !IO_BO_FACTORY type ref to ZIF_GTT_STS_FACTORY
      !IV_APPSYS type /SAPTRX/APPLSYSTEM
      !IS_APP_OBJ_TYPES type /SAPTRX/AOTYPES
      !IT_ALL_APPL_TABLES type TRXAS_TABCONTAINER
      !IT_APP_TYPE_CNTL_TABS type TRXAS_APPTYPE_TABS
      !IT_APP_OBJECTS type TRXAS_APPOBJ_CTABS
    exporting
      !ET_TRACK_ID_DATA type ZIF_GTT_STS_EF_TYPES=>TT_TRACK_ID_DATA
    raising
      CX_UDM_MESSAGE .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_GTT_STS_EF_PERFORMER IMPLEMENTATION.


  METHOD check_relevance.

    DATA lo_ef_processor TYPE REF TO zif_gtt_sts_ef_processor.

    lo_ef_processor = io_bo_factory->get_ef_processor(
                          is_definition         = is_definition
                          io_bo_factory         = io_bo_factory
                          iv_appsys             = iv_appsys
                          is_app_obj_types      = is_app_obj_types
                          it_all_appl_tables    = it_all_appl_tables
                          it_app_type_cntl_tabs = it_app_type_cntl_tabs
                          it_app_objects        = it_app_objects ).

    lo_ef_processor->check_app_objects( ).

    rv_result = lo_ef_processor->check_relevance( io_bo_factory ).

  ENDMETHOD.


  METHOD get_control_data.

    DATA(lo_ef_processor) = io_bo_factory->get_ef_processor(
                                is_definition         = is_definition
                                io_bo_factory         = io_bo_factory
                                iv_appsys             = iv_appsys
                                is_app_obj_types      = is_app_obj_types
                                it_all_appl_tables    = it_all_appl_tables
                                it_app_type_cntl_tabs = it_app_type_cntl_tabs
                                it_app_objects        = it_app_objects ).

    lo_ef_processor->check_app_objects( ).

    lo_ef_processor->get_control_data(
      EXPORTING
        io_bo_factory   = io_bo_factory
      CHANGING
        ct_control_data = ct_control_data[] ).

  ENDMETHOD.


  METHOD get_planned_events.

    DATA lo_ef_processor TYPE REF TO zif_gtt_sts_ef_processor.

    lo_ef_processor = io_factory->get_ef_processor(
                        is_definition         = is_definition
                        io_bo_factory         = io_factory
                        iv_appsys             = iv_appsys
                        is_app_obj_types      = is_app_obj_types
                        it_all_appl_tables    = it_all_appl_tables
                        it_app_type_cntl_tabs = it_app_type_cntl_tabs
                        it_app_objects        = it_app_objects ).

    lo_ef_processor->check_app_objects( ).

    lo_ef_processor->get_planned_events(
      EXPORTING
        io_factory      = io_factory
      CHANGING
        ct_expeventdata = ct_expeventdata
        ct_measrmntdata = ct_measrmntdata
        ct_infodata     = ct_infodata ).

  ENDMETHOD.


  METHOD get_track_id_data.

    DATA: lo_ef_processor   TYPE REF TO zif_gtt_sts_ef_processor.

    CLEAR: et_track_id_data[].

    lo_ef_processor = io_bo_factory->get_ef_processor(
                        is_definition         = is_definition
                        io_bo_factory         = io_bo_factory
                        iv_appsys             = iv_appsys
                        is_app_obj_types      = is_app_obj_types
                        it_all_appl_tables    = it_all_appl_tables
                        it_app_type_cntl_tabs = it_app_type_cntl_tabs
                        it_app_objects        = it_app_objects ).

    lo_ef_processor->check_app_objects( ).

    lo_ef_processor->get_track_id_data(
      EXPORTING
        io_bo_factory    = io_bo_factory
      IMPORTING
        et_track_id_data = et_track_id_data ).

  ENDMETHOD.
ENDCLASS.
