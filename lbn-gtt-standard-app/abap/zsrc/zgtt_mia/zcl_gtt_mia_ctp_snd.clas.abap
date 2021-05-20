CLASS zcl_gtt_mia_ctp_snd DEFINITION
  PUBLIC
  ABSTRACT
  CREATE PUBLIC .

  PUBLIC SECTION.
    METHODS send_idoc_data
      EXPORTING
        !et_bapiret TYPE bapiret2_t
      RAISING
        cx_udm_message .

  PROTECTED SECTION.
    DATA mv_appsys TYPE logsys .
    DATA mt_aotype TYPE zif_gtt_mia_ctp_tor_types=>tt_aotype .
    DATA mt_idoc_data TYPE zif_gtt_mia_ctp_tor_types=>tt_idoc_data .

    METHODS get_aotype_restriction_id
      ABSTRACT
      RETURNING
        VALUE(rv_rst_id) TYPE zgtt_rst_id.

    METHODS get_aotype_restrictions
      EXPORTING
        !et_aotype TYPE zif_gtt_mia_ctp_tor_types=>tt_aotype_rst .

    METHODS get_object_type
      ABSTRACT
      RETURNING
        VALUE(rv_objtype) TYPE /saptrx/trk_obj_type .

    METHODS fill_idoc_trxserv
      IMPORTING
        !is_aotype    TYPE zif_gtt_mia_ctp_tor_types=>ts_aotype
      CHANGING
        !cs_idoc_data TYPE zif_gtt_mia_ctp_tor_types=>ts_idoc_data .

    METHODS initiate
      RAISING
        cx_udm_message .

    METHODS initiate_aotypes
      RAISING
        cx_udm_message .

    CLASS-METHODS is_extractor_exist
      IMPORTING
        !iv_trk_obj_type TYPE clike
      RETURNING
        VALUE(rv_result) TYPE abap_bool .

    CLASS-METHODS is_gtt_enabled
      IMPORTING
        !it_trk_obj_type TYPE zif_gtt_mia_ctp_tor_types=>tt_trk_obj_type
      RETURNING
        VALUE(rv_result) TYPE abap_bool .

  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_gtt_mia_ctp_snd IMPLEMENTATION.


  METHOD fill_idoc_trxserv.

    SELECT SINGLE *
      INTO cs_idoc_data-trxserv
      FROM /saptrx/trxserv
      WHERE trx_server_id = is_aotype-server_name.

  ENDMETHOD.

  METHOD get_aotype_restrictions.

    DATA(rst_id)  = get_aotype_restriction_id( ).

    SELECT rst_option AS option,
           rst_sign   AS sign,
           rst_low    AS low,
           rst_high   AS high
      INTO CORRESPONDING FIELDS OF TABLE @et_aotype
      FROM zgtt_aotype_rst
      WHERE rst_id = @rst_id.

    IF sy-subrc <> 0.
      CLEAR: et_aotype[].
    ENDIF.

  ENDMETHOD.

  METHOD initiate.

    " Get current logical system
    CALL FUNCTION 'OWN_LOGICAL_SYSTEM_GET'
      IMPORTING
        own_logical_system             = mv_appsys
      EXCEPTIONS
        own_logical_system_not_defined = 1
        OTHERS                         = 2.

    IF sy-subrc <> 0.
      MESSAGE e007(zgtt_mia) INTO DATA(lv_dummy).
      zcl_gtt_mia_tools=>throw_exception( ).
    ENDIF.

    initiate_aotypes( ).

  ENDMETHOD.


  METHOD initiate_aotypes.

    DATA: lt_aotype_rst TYPE zif_gtt_mia_ctp_tor_types=>tt_aotype_rst.

    DATA(lv_objtype)  = get_object_type(  ).

    get_aotype_restrictions(
      IMPORTING
        et_aotype = lt_aotype_rst ).

    " Prepare AOT list
    SELECT trk_obj_type  AS obj_type
           aotype        AS aot_type
           trxservername AS server_name
      INTO TABLE mt_aotype
      FROM /saptrx/aotypes
      WHERE trk_obj_type  = lv_objtype
        AND aotype       IN lt_aotype_rst
        AND torelevant    = abap_true.

    IF sy-subrc <> 0.
      MESSAGE e008(zgtt_mia) INTO DATA(lv_dummy).
      zcl_gtt_mia_tools=>throw_exception( ).
    ENDIF.

  ENDMETHOD.


  METHOD is_extractor_exist.

    DATA: lv_trk_obj_type  TYPE /saptrx/aotypes-trk_obj_type.

    SELECT SINGLE trk_obj_type
      INTO lv_trk_obj_type
      FROM /saptrx/aotypes
      WHERE trk_obj_type = iv_trk_obj_type
        AND torelevant   = abap_true.

    rv_result   = boolc( sy-subrc = 0 ).

  ENDMETHOD.


  METHOD is_gtt_enabled.

    DATA: lv_extflag      TYPE flag.

    rv_result   = abap_false.

    " Check package dependent BADI disabling
    CALL FUNCTION 'GET_R3_EXTENSION_SWITCH'
      EXPORTING
        i_structure_package = zif_gtt_mia_ef_constants=>cv_structure_pkg
      IMPORTING
        e_active            = lv_extflag
      EXCEPTIONS
        not_existing        = 1
        object_not_existing = 2
        no_extension_object = 3
        OTHERS              = 4.

    IF sy-subrc = 0 AND lv_extflag = abap_true.
*     Check if any tracking server defined
      CALL FUNCTION '/SAPTRX/EVENT_MGR_CHECK'
        EXCEPTIONS
          no_event_mgr_available = 1
          OTHERS                 = 2.

      "Check whether at least 1 active extractor exists for every object
      IF sy-subrc = 0.
        rv_result = boolc( it_trk_obj_type[] IS NOT INITIAL ).

        LOOP AT it_trk_obj_type ASSIGNING FIELD-SYMBOL(<lv_trk_obj_type>).
          IF is_extractor_exist( iv_trk_obj_type = <lv_trk_obj_type> ) = abap_false.
            rv_result   = abap_false.
            EXIT.
          ENDIF.
        ENDLOOP.
      ENDIF.
    ENDIF.

  ENDMETHOD.


  METHOD send_idoc_data.

    DATA: lt_bapiret1 TYPE bapiret2_t,
          lt_bapiret2 TYPE bapiret2_t.

    LOOP AT mt_idoc_data ASSIGNING FIELD-SYMBOL(<ls_idoc_data>).
      CLEAR: lt_bapiret1[], lt_bapiret2[].

      /saptrx/cl_send_idocs=>send_idoc_ehpost01(
        EXPORTING
          it_control      = <ls_idoc_data>-control
          it_info         = <ls_idoc_data>-info
          it_tracking_id  = <ls_idoc_data>-tracking_id
          it_exp_event    = <ls_idoc_data>-exp_event
          is_trxserv      = <ls_idoc_data>-trxserv
          iv_appsys       = <ls_idoc_data>-appsys
          it_appobj_ctabs = <ls_idoc_data>-appobj_ctabs
        IMPORTING
          et_bapireturn   = lt_bapiret1 ).

      " when GTT.2 version
      IF /saptrx/cl_send_idocs=>st_idoc_data[] IS NOT INITIAL.
        /saptrx/cl_send_idocs=>send_idoc_gttmsg01(
          IMPORTING
            et_bapireturn = lt_bapiret2 ).
      ENDIF.

      " collect messages, if it is necessary
      IF et_bapiret IS REQUESTED.
        et_bapiret    = VALUE #( BASE et_bapiret
                                 ( LINES OF lt_bapiret1 )
                                 ( LINES OF lt_bapiret2 ) ).
      ENDIF.
    ENDLOOP.

  ENDMETHOD.
ENDCLASS.
