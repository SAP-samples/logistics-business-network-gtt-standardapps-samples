class ZCL_GTT_STS_EF_PROCESSOR definition
  public
  create public .

public section.

  interfaces ZIF_GTT_STS_EF_PROCESSOR .

  methods CONSTRUCTOR
    importing
      !IO_EF_PARAMETERS type ref to ZIF_GTT_STS_EF_PARAMETERS
      !IO_BO_READER type ref to ZIF_GTT_STS_BO_READER
      !IO_PE_FILLER type ref to ZIF_GTT_STS_PE_FILLER
      !IS_DEFINITION type ZIF_GTT_STS_EF_TYPES=>TS_DEFINITION .
  PROTECTED SECTION.
private section.

  data MO_EF_PARAMETERS type ref to ZIF_GTT_STS_EF_PARAMETERS .
  data MO_BO_READER type ref to ZIF_GTT_STS_BO_READER .
  data MO_PE_FILLER type ref to ZIF_GTT_STS_PE_FILLER .
  data MS_DEFINITION type ZIF_GTT_STS_EF_TYPES=>TS_DEFINITION .

  methods ADD_STRUCT_TO_CONTROL_DATA
    importing
      !IR_BO_DATA type ref to DATA
      !IV_APPOBJID type /SAPTRX/AOID
    changing
      !CT_CONTROL_DATA type ZIF_GTT_STS_EF_TYPES=>TT_CONTROL_DATA
    raising
      CX_UDM_MESSAGE .
  methods ADD_SYS_ATTR_TO_CONTROL_DATA
    importing
      !IV_APPOBJID type /SAPTRX/AOID
    changing
      !CT_CONTROL_DATA type ZIF_GTT_STS_EF_TYPES=>TT_CONTROL_DATA
    raising
      CX_UDM_MESSAGE .
ENDCLASS.



CLASS ZCL_GTT_STS_EF_PROCESSOR IMPLEMENTATION.


  METHOD add_struct_to_control_data.

    DATA: lt_fields       TYPE cl_abap_structdescr=>component_table,
          ls_control_data TYPE zif_gtt_sts_ef_types=>ts_control_data,
          lr_mapping      TYPE REF TO data,
          lv_dummy        TYPE char100 ##needed.

    FIELD-SYMBOLS: <ls_bo_data>   TYPE any,
                   <ls_mapping>   TYPE any,
                   <lt_value>     TYPE ANY TABLE,
                   <lv_value>     TYPE any,
                   <lv_paramname> TYPE any.

    ASSIGN ir_bo_data->* TO <ls_bo_data>.

    IF <ls_bo_data> IS ASSIGNED.
      " get fields list of the structure, which provided by reader class
      lt_fields = CAST cl_abap_structdescr(
                    cl_abap_typedescr=>describe_by_data(
                      p_data = <ls_bo_data> )
                  )->get_components( ).

      " assign mapping table to use it in converting of field names into external format
      lr_mapping  = mo_bo_reader->get_mapping_structure( ).
      ASSIGN lr_mapping->* TO <ls_mapping>.

      IF <ls_mapping> IS ASSIGNED.
        " fill generic parameters
        ls_control_data-appsys      = mo_ef_parameters->get_appsys( ).
        ls_control_data-appobjtype  = mo_ef_parameters->get_app_obj_types( )-aotype.
        ls_control_data-language    = sy-langu.
        ls_control_data-appobjid    = iv_appobjid.

        " walk around fields list and copy values one by one
        LOOP AT lt_fields ASSIGNING FIELD-SYMBOL(<ls_fields>).
          ASSIGN COMPONENT <ls_fields>-name OF STRUCTURE <ls_bo_data> TO <lv_value>.
          ASSIGN COMPONENT <ls_fields>-name OF STRUCTURE <ls_mapping> TO <lv_paramname>.

          CLEAR: ls_control_data-paramindex,
                 ls_control_data-value.

          IF <lv_value> IS ASSIGNED AND <lv_paramname> IS ASSIGNED.
            ls_control_data-paramname = <lv_paramname>.

            " simple copy for usual values
            IF zcl_gtt_sts_tools=>is_table( iv_value = <lv_value> ) = abap_false.

              IF <lv_value> IS NOT INITIAL.
                ls_control_data-value = zcl_gtt_sts_tools=>get_pretty_value( iv_value = <lv_value> ).
              ENDIF.

              APPEND ls_control_data TO ct_control_data.

              " cycled copy for table values
            ELSE.
              ASSIGN <lv_value> TO <lt_value>.

              LOOP AT <lt_value> ASSIGNING <lv_value>.
                ls_control_data-paramindex += 1.
                IF <lv_value> IS NOT INITIAL.
                  ls_control_data-value     = zcl_gtt_sts_tools=>get_pretty_value(
                                                iv_value = <lv_value> ).
                ENDIF.
                APPEND ls_control_data TO ct_control_data.
                CLEAR: ls_control_data-value.
              ENDLOOP.
            ENDIF.
          ELSEIF <lv_value> IS NOT ASSIGNED.
            MESSAGE e010(zgtt_sts) INTO lv_dummy.
            zcl_gtt_sts_tools=>throw_exception( ).
          ELSE.
            MESSAGE e010(zgtt_sts) INTO lv_dummy.
            zcl_gtt_sts_tools=>throw_exception( ).
          ENDIF.
        ENDLOOP.
      ELSE.
        MESSAGE e010(zgtt_sts) INTO lv_dummy.
        zcl_gtt_sts_tools=>throw_exception( ).
      ENDIF.
    ELSE.
      MESSAGE e010(zgtt_sts) INTO lv_dummy.
      zcl_gtt_sts_tools=>throw_exception( ).
    ENDIF.

  ENDMETHOD.


  METHOD add_sys_attr_to_control_data.

    DATA ls_control_data TYPE zif_gtt_sts_ef_types=>ts_control_data.

    ls_control_data-appsys     = mo_ef_parameters->get_appsys( ).
    ls_control_data-appobjtype = mo_ef_parameters->get_app_obj_types( )-aotype.
    ls_control_data-language   = sy-langu.
    ls_control_data-appobjid   = iv_appobjid.

    ls_control_data-paramname  = zif_gtt_sts_ef_constants=>cs_system_fields-actual_bisiness_timezone.
    ls_control_data-value      = zcl_gtt_sts_tools=>get_system_time_zone( ).
    APPEND ls_control_data TO ct_control_data.

    ls_control_data-paramname  = zif_gtt_sts_ef_constants=>cs_system_fields-actual_bisiness_datetime.
    ls_control_data-value      = zcl_gtt_sts_tools=>get_system_date_time( ).
    APPEND ls_control_data TO ct_control_data.

    ls_control_data-paramname  = zif_gtt_sts_ef_constants=>cs_system_fields-actual_technical_timezone.
    ls_control_data-value      = zcl_gtt_sts_tools=>get_system_time_zone( ).
    APPEND ls_control_data TO ct_control_data.

    ls_control_data-paramname  = zif_gtt_sts_ef_constants=>cs_system_fields-actual_technical_datetime.
    ls_control_data-value      = zcl_gtt_sts_tools=>get_system_date_time( ).
    APPEND ls_control_data TO ct_control_data.

  ENDMETHOD.


  METHOD constructor.

    mo_ef_parameters    = io_ef_parameters.
    mo_bo_reader        = io_bo_reader.
    mo_pe_filler        = io_pe_filler.
    ms_definition       = is_definition.

  ENDMETHOD.


  METHOD zif_gtt_sts_ef_processor~check_app_objects.

    DATA: lr_app_objects TYPE REF TO data,
          lv_dummy       TYPE char100 ##needed.

    FIELD-SYMBOLS: <lt_app_objects>  TYPE trxas_appobj_ctabs.

    lr_app_objects  = mo_ef_parameters->get_app_objects( ).

    ASSIGN lr_app_objects->* TO <lt_app_objects>.

    LOOP AT <lt_app_objects> ASSIGNING FIELD-SYMBOL(<ls_app_objects>).
      IF <ls_app_objects>-maintabdef <> ms_definition-maintab.
        MESSAGE e087(/saptrx/asc)
          WITH <ls_app_objects>-maintabdef
               mo_ef_parameters->get_app_obj_types( )-controldatafunc
               zif_gtt_sts_ef_constants=>cv_aot
               mo_ef_parameters->get_appsys( )
          INTO lv_dummy.

        zcl_gtt_sts_tools=>throw_exception(
          iv_textid = zif_gtt_sts_ef_constants=>cs_errors-table_determination ).

      ELSEIF ms_definition-mastertab IS NOT INITIAL AND
            <ls_app_objects>-mastertabdef <> ms_definition-mastertab.
        MESSAGE e088(/saptrx/asc)
          WITH <ls_app_objects>-maintabdef
               mo_ef_parameters->get_app_obj_types( )-controldatafunc
               zif_gtt_sts_ef_constants=>cv_aot
               mo_ef_parameters->get_appsys( )
          INTO lv_dummy.

        zcl_gtt_sts_tools=>throw_exception(
          iv_textid = zif_gtt_sts_ef_constants=>cs_errors-table_determination ).
      ENDIF.
    ENDLOOP.

  ENDMETHOD.


  METHOD zif_gtt_sts_ef_processor~check_relevance.

    FIELD-SYMBOLS <lt_app_objects>  TYPE trxas_appobj_ctabs.

    DATA(lr_app_objects) = mo_ef_parameters->get_app_objects( ).
    ASSIGN lr_app_objects->* TO <lt_app_objects>.
    rv_result = zif_gtt_sts_ef_constants=>cs_condition-false.

    LOOP AT <lt_app_objects> ASSIGNING FIELD-SYMBOL(<ls_app_objects>).
      TRY.
          mo_bo_reader = io_bo_factory->get_bo_reader(
                             is_appl_object   = <ls_app_objects>
                             io_ef_parameters = mo_ef_parameters ).
        CATCH cx_udm_message.
          CONTINUE.
      ENDTRY.
      rv_result = mo_bo_reader->check_relevance( is_app_object = <ls_app_objects> ).
      IF rv_result = abap_true.
        EXIT.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.


  METHOD zif_gtt_sts_ef_processor~get_control_data.

    DATA: lr_app_objects TYPE REF TO data,
          lr_bo_data     TYPE REF TO data.

    FIELD-SYMBOLS: <lt_app_objects> TYPE trxas_appobj_ctabs,
                   <ls_app_objects> TYPE trxas_appobj_ctab_wa.

    lr_app_objects  = mo_ef_parameters->get_app_objects( ).
    ASSIGN lr_app_objects->* TO <lt_app_objects>.

    LOOP AT <lt_app_objects> ASSIGNING <ls_app_objects> WHERE maintabdef = ms_definition-maintab.

      mo_bo_reader = io_bo_factory->get_bo_reader(
                         is_appl_object   = <ls_app_objects>
                         io_ef_parameters = mo_ef_parameters ).

      lr_bo_data = mo_bo_reader->get_data( EXPORTING is_app_object = <ls_app_objects> ).

      add_struct_to_control_data(
        EXPORTING
          ir_bo_data      = lr_bo_data
          iv_appobjid     = <ls_app_objects>-appobjid
        CHANGING
          ct_control_data = ct_control_data ).

      add_sys_attr_to_control_data(
        EXPORTING
          iv_appobjid     = <ls_app_objects>-appobjid
        CHANGING
          ct_control_data = ct_control_data ).
    ENDLOOP.

  ENDMETHOD.


  METHOD zif_gtt_sts_ef_processor~get_planned_events.

    DATA: lt_expeventdata TYPE zif_gtt_sts_ef_types=>tt_expeventdata,
          lt_measrmntdata TYPE zif_gtt_sts_ef_types=>tt_measrmntdata,
          lt_infodata     TYPE zif_gtt_sts_ef_types=>tt_infodata,
          lr_app_objects  TYPE REF TO data.

    FIELD-SYMBOLS <lt_app_objects> TYPE trxas_appobj_ctabs.

    lr_app_objects  = mo_ef_parameters->get_app_objects( ).
    ASSIGN lr_app_objects->* TO <lt_app_objects>.

    LOOP AT <lt_app_objects> ASSIGNING FIELD-SYMBOL(<ls_app_objects>)
      WHERE maintabdef = ms_definition-maintab.

      mo_pe_filler = io_factory->get_pe_filler(
                          is_appl_object   = <ls_app_objects>
                          io_ef_parameters = mo_ef_parameters ).

      mo_pe_filler->get_planned_events(
        EXPORTING
          is_app_objects  = <ls_app_objects>
        CHANGING
          ct_expeventdata = lt_expeventdata
          ct_measrmntdata = lt_measrmntdata
          ct_infodata     = lt_infodata ).
    ENDLOOP.

    " Add all the changes to result tables in the end of the method,
    " so that in case of exceptions there will be no inconsistent data in them
    IF lt_expeventdata[] IS NOT INITIAL.
      ct_expeventdata[] = VALUE #( BASE ct_expeventdata ( LINES OF lt_expeventdata ) ).
    ENDIF.
    IF lt_measrmntdata[] IS NOT INITIAL.
      ct_measrmntdata[] = VALUE #( BASE ct_measrmntdata ( LINES OF lt_measrmntdata ) ).
    ENDIF.
    IF lt_expeventdata[] IS NOT INITIAL.
      lt_infodata[] = VALUE #( BASE ct_infodata ( LINES OF lt_infodata ) ).
    ENDIF.

  ENDMETHOD.


  METHOD zif_gtt_sts_ef_processor~get_track_id_data.

    DATA: lr_app_objects   TYPE REF TO data,
          lt_track_id_data TYPE zif_gtt_sts_ef_types=>tt_track_id_data.

    FIELD-SYMBOLS: <lt_app_objects>   TYPE trxas_appobj_ctabs.

    CLEAR: et_track_id_data[].

    lr_app_objects  = mo_ef_parameters->get_app_objects( ).
    ASSIGN lr_app_objects->* TO <lt_app_objects>.



    LOOP AT <lt_app_objects> ASSIGNING FIELD-SYMBOL(<ls_app_objects>)
      WHERE maintabdef = ms_definition-maintab.

      mo_bo_reader = io_bo_factory->get_bo_reader(
                               is_appl_object   = <ls_app_objects>
                               io_ef_parameters = mo_ef_parameters ).

      mo_bo_reader->get_track_id_data(
        EXPORTING
          is_app_object    = <ls_app_objects>
        IMPORTING
          et_track_id_data = lt_track_id_data ).

      et_track_id_data  = VALUE #( BASE et_track_id_data ( LINES OF lt_track_id_data ) ).
    ENDLOOP.

  ENDMETHOD.
ENDCLASS.
