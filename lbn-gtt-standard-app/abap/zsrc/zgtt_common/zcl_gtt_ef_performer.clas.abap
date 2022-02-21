class ZCL_GTT_EF_PERFORMER definition
  public
  create public .

public section.

  class-methods CHECK_RELEVANCE
    importing
      !IS_DEFINITION type ZIF_GTT_EF_TYPES=>TS_DEFINITION
      !IO_TP_FACTORY type ref to ZIF_GTT_TP_FACTORY
      !IV_APPSYS type /SAPTRX/APPLSYSTEM
      !IS_APP_OBJ_TYPES type /SAPTRX/AOTYPES
      !IT_ALL_APPL_TABLES type TRXAS_TABCONTAINER
      !IT_APP_TYPE_CNTL_TABS type TRXAS_APPTYPE_TABS optional
      !IT_APP_OBJECTS type TRXAS_APPOBJ_CTABS
    returning
      value(RV_RESULT) type SY-BINPT
    raising
      CX_UDM_MESSAGE .
  class-methods GET_APP_OBJ_TYPE_ID
    importing
      !IS_DEFINITION type ZIF_GTT_EF_TYPES=>TS_DEFINITION
      !IO_TP_FACTORY type ref to ZIF_GTT_TP_FACTORY
      !IV_APPSYS type /SAPTRX/APPLSYSTEM
      !IS_APP_OBJ_TYPES type /SAPTRX/AOTYPES
      !IT_ALL_APPL_TABLES type TRXAS_TABCONTAINER
      !IT_APP_TYPE_CNTL_TABS type TRXAS_APPTYPE_TABS optional
      !IT_APP_OBJECTS type TRXAS_APPOBJ_CTABS
    returning
      value(RV_APPOBJID) type /SAPTRX/AOID
    raising
      CX_UDM_MESSAGE .
  class-methods GET_CONTROL_DATA
    importing
      !IS_DEFINITION type ZIF_GTT_EF_TYPES=>TS_DEFINITION
      !IO_TP_FACTORY type ref to ZIF_GTT_TP_FACTORY
      !IV_APPSYS type /SAPTRX/APPLSYSTEM
      !IS_APP_OBJ_TYPES type /SAPTRX/AOTYPES
      !IT_ALL_APPL_TABLES type TRXAS_TABCONTAINER
      !IT_APP_TYPE_CNTL_TABS type TRXAS_APPTYPE_TABS
      !IT_APP_OBJECTS type TRXAS_APPOBJ_CTABS
    changing
      !CT_CONTROL_DATA type ZIF_GTT_EF_TYPES=>TT_CONTROL_DATA
    raising
      CX_UDM_MESSAGE .
  class-methods GET_PLANNED_EVENTS
    importing
      !IS_DEFINITION type ZIF_GTT_EF_TYPES=>TS_DEFINITION
      !IO_TP_FACTORY type ref to ZIF_GTT_TP_FACTORY
      !IV_APPSYS type /SAPTRX/APPLSYSTEM
      !IS_APP_OBJ_TYPES type /SAPTRX/AOTYPES
      !IT_ALL_APPL_TABLES type TRXAS_TABCONTAINER
      !IT_APP_TYPE_CNTL_TABS type TRXAS_APPTYPE_TABS
      !IT_APP_OBJECTS type TRXAS_APPOBJ_CTABS
    changing
      !CT_EXPEVENTDATA type ZIF_GTT_EF_TYPES=>TT_EXPEVENTDATA
      !CT_MEASRMNTDATA type ZIF_GTT_EF_TYPES=>TT_MEASRMNTDATA
      !CT_INFODATA type ZIF_GTT_EF_TYPES=>TT_INFODATA
    raising
      CX_UDM_MESSAGE .
  class-methods GET_TRACK_ID_DATA
    importing
      !IS_DEFINITION type ZIF_GTT_EF_TYPES=>TS_DEFINITION
      !IO_TP_FACTORY type ref to ZIF_GTT_TP_FACTORY
      !IV_APPSYS type /SAPTRX/APPLSYSTEM
      !IS_APP_OBJ_TYPES type /SAPTRX/AOTYPES
      !IT_ALL_APPL_TABLES type TRXAS_TABCONTAINER
      !IT_APP_TYPE_CNTL_TABS type TRXAS_APPTYPE_TABS
      !IT_APP_OBJECTS type TRXAS_APPOBJ_CTABS
    exporting
      !ET_TRACK_ID_DATA type ZIF_GTT_EF_TYPES=>TT_TRACK_ID_DATA
    raising
      CX_UDM_MESSAGE .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_GTT_EF_PERFORMER IMPLEMENTATION.


  METHOD check_relevance.

    DATA: lo_ef_processor   TYPE REF TO zif_gtt_ef_processor.

    " get instance of extractor function processor
    lo_ef_processor = io_tp_factory->get_ef_processor(
      is_definition         = is_definition
      io_bo_factory         = io_tp_factory
      iv_appsys             = iv_appsys
      is_app_obj_types      = is_app_obj_types
      it_all_appl_tables    = it_all_appl_tables
      it_app_type_cntl_tabs = it_app_type_cntl_tabs
      it_app_objects        = it_app_objects ).

    " check i_app_objects     : is maintabdef correct?
    lo_ef_processor->check_app_objects( ).

    " check relevance
    rv_result = lo_ef_processor->check_relevance( ).

  ENDMETHOD.


  METHOD get_app_obj_type_id.
    DATA: lo_ef_processor   TYPE REF TO zif_gtt_ef_processor.

    " get instance of extractor function processor
    lo_ef_processor = io_tp_factory->get_ef_processor(
      is_definition         = is_definition
      io_bo_factory         = io_tp_factory
      iv_appsys             = iv_appsys
      is_app_obj_types      = is_app_obj_types
      it_all_appl_tables    = it_all_appl_tables
      it_app_type_cntl_tabs = it_app_type_cntl_tabs
      it_app_objects        = it_app_objects
    ).

    " check i_app_objects     : is maintabdef correct?
    lo_ef_processor->check_app_objects( ).

    " fill control data from business object data
    rv_appobjid   = lo_ef_processor->get_app_obj_type_id( ).
  ENDMETHOD.


  METHOD get_control_data.

    DATA: lo_ef_processor   TYPE REF TO zif_gtt_ef_processor.

    " get instance of extractor function processor
    lo_ef_processor = io_tp_factory->get_ef_processor(
      is_definition         = is_definition
      io_bo_factory         = io_tp_factory
      iv_appsys             = iv_appsys
      is_app_obj_types      = is_app_obj_types
      it_all_appl_tables    = it_all_appl_tables
      it_app_type_cntl_tabs = it_app_type_cntl_tabs
      it_app_objects        = it_app_objects
    ).

    " check i_app_objects     : is maintabdef correct?
    lo_ef_processor->check_app_objects( ).

    " fill control data from business object data
    lo_ef_processor->get_control_data(
      CHANGING
        ct_control_data = ct_control_data[]
    ).


  ENDMETHOD.


  METHOD get_planned_events.

    DATA: lo_ef_processor   TYPE REF TO zif_gtt_ef_processor.

    " get instance of extractor function processor
    lo_ef_processor = io_tp_factory->get_ef_processor(
      is_definition         = is_definition
      io_bo_factory         = io_tp_factory
      iv_appsys             = iv_appsys
      is_app_obj_types      = is_app_obj_types
      it_all_appl_tables    = it_all_appl_tables
      it_app_type_cntl_tabs = it_app_type_cntl_tabs
      it_app_objects        = it_app_objects
    ).

    " check i_app_objects     : is maintabdef correct?
    lo_ef_processor->check_app_objects( ).

    " fill planned events data
    lo_ef_processor->get_planned_events(
      CHANGING
        ct_expeventdata = ct_expeventdata
        ct_measrmntdata = ct_measrmntdata
        ct_infodata     = ct_infodata
    ).


  ENDMETHOD.


  METHOD get_track_id_data.

    DATA: lo_ef_processor   TYPE REF TO zif_gtt_ef_processor.

    CLEAR: et_track_id_data[].

    " get instance of extractor function processor
    lo_ef_processor = io_tp_factory->get_ef_processor(
      is_definition         = is_definition
      io_bo_factory         = io_tp_factory
      iv_appsys             = iv_appsys
      is_app_obj_types      = is_app_obj_types
      it_all_appl_tables    = it_all_appl_tables
      it_app_type_cntl_tabs = it_app_type_cntl_tabs
      it_app_objects        = it_app_objects
    ).

    " check i_app_objects     : is maintabdef correct?
    lo_ef_processor->check_app_objects( ).

    " fill controll data from PO Header data
    lo_ef_processor->get_track_id_data(
      IMPORTING
        et_track_id_data = et_track_id_data
    ).


  ENDMETHOD.
ENDCLASS.
