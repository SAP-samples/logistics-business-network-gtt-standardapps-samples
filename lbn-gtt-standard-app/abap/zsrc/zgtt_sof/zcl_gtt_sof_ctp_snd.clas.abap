class ZCL_GTT_SOF_CTP_SND definition
  public
  abstract
  create public .

public section.

  methods SEND_IDOC_DATA
    exporting
      !ET_BAPIRET type BAPIRET2_T
    raising
      CX_UDM_MESSAGE .
protected section.

  data MV_APPSYS type LOGSYS .
  data MT_AOTYPE type ZIF_GTT_SOF_CTP_TYPES=>TT_AOTYPE .
  data MT_IDOC_DATA type ZIF_GTT_SOF_CTP_TYPES=>TT_IDOC_DATA .

  methods GET_AOTYPE_RESTRICTION_ID
  abstract
    returning
      value(RV_RST_ID) type CHAR10 .
  methods GET_AOTYPE_RESTRICTIONS
    exporting
      !ET_AOTYPE type ZIF_GTT_SOF_CTP_TYPES=>TT_AOTYPE_RST .
  methods GET_OBJECT_TYPE
  abstract
    returning
      value(RV_OBJTYPE) type /SAPTRX/TRK_OBJ_TYPE .
  methods FILL_IDOC_TRXSERV
    importing
      !IS_AOTYPE type ZIF_GTT_SOF_CTP_TYPES=>TS_AOTYPE
    changing
      !CS_IDOC_DATA type ZIF_GTT_SOF_CTP_TYPES=>TS_IDOC_DATA .
  methods INITIATE
    raising
      CX_UDM_MESSAGE .
  methods INITIATE_AOTYPES
    raising
      CX_UDM_MESSAGE .
  class-methods IS_EXTRACTOR_EXIST
    importing
      !IV_TRK_OBJ_TYPE type CLIKE
    returning
      value(RV_RESULT) type ABAP_BOOL .
  class-methods IS_GTT_ENABLED
    importing
      !IT_TRK_OBJ_TYPE type ZIF_GTT_SOF_CTP_TYPES=>TT_TRK_OBJ_TYPE
    returning
      value(RV_RESULT) type ABAP_BOOL .
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_GTT_SOF_CTP_SND IMPLEMENTATION.


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
      MESSAGE e007(zgtt_ssof) INTO DATA(lv_dummy).
      zcl_gtt_sof_tm_tools=>throw_exception( ).
    ENDIF.

    initiate_aotypes( ).

  ENDMETHOD.


  METHOD initiate_aotypes.

    DATA: lt_aotype_rst TYPE zif_gtt_sof_ctp_types=>tt_aotype_rst.

    DATA(lv_objtype)  = get_object_type(  ).

    get_aotype_restrictions(
      IMPORTING
        et_aotype = lt_aotype_rst ).

    " Prepare AOT list
    IF lt_aotype_rst IS NOT INITIAL.
      SELECT trk_obj_type  AS obj_type
             aotype        AS aot_type
             trxservername AS server_name
        INTO TABLE mt_aotype
        FROM /saptrx/aotypes
        WHERE trk_obj_type  = lv_objtype
          AND aotype       IN lt_aotype_rst
          AND torelevant    = abap_true.

      IF sy-subrc <> 0.
        MESSAGE e008(zgtt_ssof) INTO DATA(lv_dummy).
        zcl_gtt_sof_tm_tools=>throw_exception( ).
      ENDIF.
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
        i_structure_package = zif_gtt_sof_ctp_tor_constants=>cv_structure_pkg
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
          iv_upd_task     = 'X'
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
