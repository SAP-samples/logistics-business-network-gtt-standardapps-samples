class ZCL_GTT_MIA_SH_DATA_OLD definition
  public
  create public .

public section.

  methods CONSTRUCTOR
    importing
      !IO_EF_PARAMETERS type ref to ZIF_GTT_EF_PARAMETERS
    raising
      CX_UDM_MESSAGE .
  methods GET_VTTK
    returning
      value(RR_VTTK) type ref to DATA .
  methods GET_VTTP
    returning
      value(RR_VTTP) type ref to DATA .
  methods GET_VTTS
    returning
      value(RR_VTTS) type ref to DATA .
  methods GET_VTSP
    returning
      value(RR_VTSP) type ref to DATA .
  PROTECTED SECTION.
  PRIVATE SECTION.

    DATA mo_ef_parameters TYPE REF TO zif_gtt_ef_parameters .
    DATA mt_vttk TYPE zif_gtt_mia_app_types=>tt_vttkvb .
    DATA mt_vttp TYPE zif_gtt_mia_app_types=>tt_vttpvb .
    DATA mt_vtts TYPE zif_gtt_mia_app_types=>tt_vttsvb .
    DATA mt_vtsp TYPE zif_gtt_mia_app_types=>tt_vtspvb .

    METHODS init
      RAISING
        cx_udm_message .
    METHODS init_vttk
      RAISING
        cx_udm_message .
    METHODS init_vttp
      RAISING
        cx_udm_message .
    METHODS init_vtts
      RAISING
        cx_udm_message .
    METHODS init_vtsp
      RAISING
        cx_udm_message .
ENDCLASS.



CLASS ZCL_GTT_MIA_SH_DATA_OLD IMPLEMENTATION.


  METHOD CONSTRUCTOR.

    mo_ef_parameters  = io_ef_parameters.

    init( ).

  ENDMETHOD.


  METHOD GET_VTSP.

    rr_vtsp   = REF #( mt_vtsp ).

  ENDMETHOD.


  METHOD GET_VTTK.

    rr_vttk   = REF #( mt_vttk ).

  ENDMETHOD.


  METHOD GET_VTTP.

    rr_vttp   = REF #( mt_vttp ).

  ENDMETHOD.


  METHOD GET_VTTS.

    rr_vtts   = REF #( mt_vtts ).

  ENDMETHOD.


  METHOD INIT.

    init_vttk( ).

    init_vttp( ).

    init_vtts( ).

    init_vtsp( ).

  ENDMETHOD.


  METHOD INIT_VTSP.

    FIELD-SYMBOLS: <lt_vtsp_new> TYPE zif_gtt_mia_app_types=>tt_vtspvb,
                   <lt_vtsp_old> TYPE zif_gtt_mia_app_types=>tt_vtspvb.

    DATA(lr_vtsp_new) = mo_ef_parameters->get_appl_table(
                          iv_tabledef = zif_gtt_mia_app_constants=>cs_tabledef-sh_item_stage_new ).
    DATA(lr_vtsp_old) = mo_ef_parameters->get_appl_table(
                          iv_tabledef = zif_gtt_mia_app_constants=>cs_tabledef-sh_item_stage_old ).

    ASSIGN lr_vtsp_new->* TO <lt_vtsp_new>.
    ASSIGN lr_vtsp_old->* TO <lt_vtsp_old>.

    IF <lt_vtsp_new> IS ASSIGNED AND
       <lt_vtsp_old> IS ASSIGNED.

      mt_vtsp   = <lt_vtsp_old>.
      SORT mt_vtsp BY tknum tsnum tpnum.

      LOOP AT <lt_vtsp_new> ASSIGNING FIELD-SYMBOL(<ls_vtsp_new>)
        WHERE updkz IS INITIAL.

        READ TABLE mt_vtsp
          WITH KEY tknum = <ls_vtsp_new>-tknum
                   tsnum = <ls_vtsp_new>-tsnum
                   tpnum = <ls_vtsp_new>-tpnum
          TRANSPORTING NO FIELDS
          BINARY SEARCH.

        IF sy-subrc <> 0.
          INSERT <ls_vtsp_new> INTO mt_vtsp INDEX sy-tabix.
        ENDIF.
      ENDLOOP.
    ELSE.
      MESSAGE e002(zgtt) WITH 'VTSP' INTO DATA(lv_dummy).
      zcl_gtt_tools=>throw_exception( ).
    ENDIF.

  ENDMETHOD.


  METHOD INIT_VTTK.

    FIELD-SYMBOLS: <lt_vttk_new> TYPE zif_gtt_mia_app_types=>tt_vttkvb,
                   <lt_vttk_old> TYPE zif_gtt_mia_app_types=>tt_vttkvb.

    DATA(lr_vttk_new) = mo_ef_parameters->get_appl_table(
                          iv_tabledef = zif_gtt_mia_app_constants=>cs_tabledef-sh_header_new ).
    DATA(lr_vttk_old) = mo_ef_parameters->get_appl_table(
                          iv_tabledef = zif_gtt_mia_app_constants=>cs_tabledef-sh_header_old ).

    ASSIGN lr_vttk_new->* TO <lt_vttk_new>.
    ASSIGN lr_vttk_old->* TO <lt_vttk_old>.

    IF <lt_vttk_new> IS ASSIGNED AND
       <lt_vttk_old> IS ASSIGNED.

      mt_vttk   = <lt_vttk_old>.
      SORT mt_vttk BY tknum.

      LOOP AT <lt_vttk_new> ASSIGNING FIELD-SYMBOL(<ls_vttk_new>)
        WHERE updkz IS INITIAL.

        READ TABLE mt_vttk
          WITH KEY tknum = <ls_vttk_new>-tknum
          TRANSPORTING NO FIELDS
          BINARY SEARCH.

        IF sy-subrc <> 0.
          INSERT <ls_vttk_new> INTO mt_vttk INDEX sy-tabix.
        ENDIF.
      ENDLOOP.
    ELSE.
      MESSAGE e002(zgtt) WITH 'VTTK' INTO DATA(lv_dummy).
      zcl_gtt_tools=>throw_exception( ).
    ENDIF.

  ENDMETHOD.


  METHOD INIT_VTTP.

    FIELD-SYMBOLS: <lt_vttp_new> TYPE zif_gtt_mia_app_types=>tt_vttpvb,
                   <lt_vttp_old> TYPE zif_gtt_mia_app_types=>tt_vttpvb.

    DATA(lr_vttp_new) = mo_ef_parameters->get_appl_table(
                          iv_tabledef = zif_gtt_mia_app_constants=>cs_tabledef-sh_item_new ).
    DATA(lr_vttp_old) = mo_ef_parameters->get_appl_table(
                          iv_tabledef = zif_gtt_mia_app_constants=>cs_tabledef-sh_item_old ).

    ASSIGN lr_vttp_new->* TO <lt_vttp_new>.
    ASSIGN lr_vttp_old->* TO <lt_vttp_old>.

    IF <lt_vttp_new> IS ASSIGNED AND
       <lt_vttp_old> IS ASSIGNED.

      mt_vttp   = <lt_vttp_old>.
      SORT mt_vttp BY tknum tpnum.

      LOOP AT <lt_vttp_new> ASSIGNING FIELD-SYMBOL(<ls_vttp_new>)
        WHERE updkz IS INITIAL.

        READ TABLE mt_vttp
          WITH KEY tknum = <ls_vttp_new>-tknum
                   tpnum = <ls_vttp_new>-tpnum
          TRANSPORTING NO FIELDS
          BINARY SEARCH.

        IF sy-subrc <> 0.
          INSERT <ls_vttp_new> INTO mt_vttp INDEX sy-tabix.
        ENDIF.
      ENDLOOP.
    ELSE.
      MESSAGE e002(zgtt) WITH 'VTTP' INTO DATA(lv_dummy).
      zcl_gtt_tools=>throw_exception( ).
    ENDIF.

  ENDMETHOD.


  METHOD INIT_VTTS.

    FIELD-SYMBOLS: <lt_vtts_new> TYPE zif_gtt_mia_app_types=>tt_vttsvb,
                   <lt_vtts_old> TYPE zif_gtt_mia_app_types=>tt_vttsvb.

    DATA(lr_vtts_new) = mo_ef_parameters->get_appl_table(
                          iv_tabledef = zif_gtt_mia_app_constants=>cs_tabledef-sh_stage_new ).
    DATA(lr_vtts_old) = mo_ef_parameters->get_appl_table(
                          iv_tabledef = zif_gtt_mia_app_constants=>cs_tabledef-sh_stage_old ).

    ASSIGN lr_vtts_new->* TO <lt_vtts_new>.
    ASSIGN lr_vtts_old->* TO <lt_vtts_old>.

    IF <lt_vtts_new> IS ASSIGNED AND
       <lt_vtts_old> IS ASSIGNED.

      mt_vtts   = <lt_vtts_old>.
      SORT mt_vtts BY tknum tsnum.

      LOOP AT <lt_vtts_new> ASSIGNING FIELD-SYMBOL(<ls_vtts_new>)
        WHERE updkz IS INITIAL.

        READ TABLE mt_vtts
          WITH KEY tknum = <ls_vtts_new>-tknum
                   tsnum = <ls_vtts_new>-tsnum
          TRANSPORTING NO FIELDS
          BINARY SEARCH.

        IF sy-subrc <> 0.
          INSERT <ls_vtts_new> INTO mt_vtts INDEX sy-tabix.
        ENDIF.
      ENDLOOP.
    ELSE.
      MESSAGE e002(zgtt) WITH 'VTTS' INTO DATA(lv_dummy).
      zcl_gtt_tools=>throw_exception( ).
    ENDIF.

  ENDMETHOD.
ENDCLASS.
