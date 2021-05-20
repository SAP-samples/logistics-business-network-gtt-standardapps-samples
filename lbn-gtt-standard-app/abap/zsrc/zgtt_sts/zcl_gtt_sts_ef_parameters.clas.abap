class ZCL_GTT_STS_EF_PARAMETERS definition
  public
  create public .

public section.

  interfaces ZIF_GTT_STS_EF_PARAMETERS .

  methods CONSTRUCTOR
    importing
      !IV_APPSYS type /SAPTRX/APPLSYSTEM
      !IS_APP_OBJ_TYPES type /SAPTRX/AOTYPES
      !IT_ALL_APPL_TABLES type TRXAS_TABCONTAINER
      !IT_APP_TYPE_CNTL_TABS type TRXAS_APPTYPE_TABS optional
      !IT_APP_OBJECTS type TRXAS_APPOBJ_CTABS .
  PROTECTED SECTION.
  PRIVATE SECTION.

    DATA mv_appsys TYPE /saptrx/applsystem .
    DATA ms_app_obj_types TYPE /saptrx/aotypes .
    DATA mr_all_appl_tables TYPE REF TO data .
    DATA mr_app_type_cntl_tabs TYPE REF TO data ##needed.
    DATA mr_app_objects TYPE REF TO data .
ENDCLASS.



CLASS ZCL_GTT_STS_EF_PARAMETERS IMPLEMENTATION.


  METHOD constructor.

    mv_appsys          = iv_appsys.
    ms_app_obj_types   = is_app_obj_types.
    mr_all_appl_tables = REF #( it_all_appl_tables ).

    IF it_app_type_cntl_tabs IS SUPPLIED.
      mr_app_type_cntl_tabs = REF #( it_app_type_cntl_tabs ).
    ENDIF.

    mr_app_objects = REF #( it_app_objects ).

  ENDMETHOD.


  METHOD zif_gtt_sts_ef_parameters~get_appl_table.

    FIELD-SYMBOLS <lt_all_appl_tables> TYPE trxas_tabcontainer.

    TRY.
        ASSIGN mr_all_appl_tables->* TO <lt_all_appl_tables>.
        rr_data = <lt_all_appl_tables>[ tabledef = iv_tabledef ]-tableref.

      CATCH cx_sy_itab_line_not_found.
        MESSAGE e008(/saptrx/asc) WITH iv_tabledef ms_app_obj_types-aotype INTO DATA(lv_dummy) ##needed.
        zcl_gtt_sts_tools=>throw_exception( iv_textid = zif_gtt_sts_ef_constants=>cs_errors-stop_processing ).
    ENDTRY.

  ENDMETHOD.


  METHOD zif_gtt_sts_ef_parameters~get_appsys.

    rv_appsys           = mv_appsys.

  ENDMETHOD.


  METHOD zif_gtt_sts_ef_parameters~get_app_objects.

    rr_data             = mr_app_objects.

  ENDMETHOD.


  METHOD zif_gtt_sts_ef_parameters~get_app_obj_types.

    rt_app_obj_types    = ms_app_obj_types.

  ENDMETHOD.
ENDCLASS.
