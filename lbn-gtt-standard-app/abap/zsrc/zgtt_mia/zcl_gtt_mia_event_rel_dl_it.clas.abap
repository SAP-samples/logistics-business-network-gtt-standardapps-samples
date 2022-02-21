class ZCL_GTT_MIA_EVENT_REL_DL_IT definition
  public
  inheriting from ZCL_GTT_MIA_EVENT_REL_DL_MAIN
  create public .

public section.
protected section.

  methods GET_FIELD_NAME
    redefinition .
  methods GET_OBJECT_STATUS
    redefinition .
  methods GET_OLD_APPOBJID
    redefinition .
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_GTT_MIA_EVENT_REL_DL_IT IMPLEMENTATION.


  METHOD GET_FIELD_NAME.

    CASE iv_milestone.
      WHEN zif_gtt_ef_constants=>cs_milestone-dl_put_away.
        rv_field_name   = 'KOSTA'.
      WHEN zif_gtt_ef_constants=>cs_milestone-dl_packing.
        rv_field_name   = 'PKSTA'.
      WHEN zif_gtt_ef_constants=>cs_milestone-dl_goods_receipt.
        rv_field_name   = 'WBSTA'.
      WHEN zif_gtt_ef_constants=>cs_milestone-dl_pod.
        rv_field_name   = COND #( WHEN iv_internal = abap_true
                                    THEN 'PDSTK'
                                    ELSE 'PDSTA' ).
      WHEN OTHERS.
        MESSAGE e009(zgtt) WITH iv_milestone INTO DATA(lv_dummy).
        zcl_gtt_tools=>throw_exception( ).
    ENDCASE.

    IF iv_internal = abap_true.
      rv_field_name   = |Z_{ rv_field_name }|.
    ENDIF.

  ENDMETHOD.


  METHOD GET_OBJECT_STATUS.

    TYPES: tt_vbup  TYPE STANDARD TABLE OF vbupvb.

    DATA: lv_dummy  TYPE char100.

    FIELD-SYMBOLS: <lt_vbup>  TYPE tt_vbup,
                   <ls_vbup>  TYPE vbupvb,
                   <lv_value> TYPE any.

    DATA(lv_fname)  = get_field_name( iv_milestone = iv_milestone ).

    DATA(lv_vbeln)  = zcl_gtt_tools=>get_field_of_structure(
                        ir_struct_data = ms_app_objects-maintabref
                        iv_field_name  = 'VBELN' ).

    DATA(lv_posnr)  = zcl_gtt_tools=>get_field_of_structure(
                        ir_struct_data = ms_app_objects-maintabref
                        iv_field_name  = 'POSNR' ).

    DATA(lr_vbup)   = mo_ef_parameters->get_appl_table(
                        iv_tabledef    = zif_gtt_mia_app_constants=>cs_tabledef-dl_itm_status_new ).

    CLEAR rv_value.

    ASSIGN lr_vbup->* TO <lt_vbup>.

    IF <lt_vbup> IS ASSIGNED.
      READ TABLE <lt_vbup> ASSIGNING <ls_vbup>
        WITH KEY vbeln  = lv_vbeln
                 posnr  = lv_posnr.

      IF sy-subrc = 0.
        ASSIGN COMPONENT lv_fname OF STRUCTURE <ls_vbup> TO <lv_value>.
        IF <lv_value> IS ASSIGNED.
          rv_value  = <lv_value>.
        ELSE.
          MESSAGE e001(zgtt) WITH lv_fname 'VBUP' INTO lv_dummy.
          zcl_gtt_tools=>throw_exception( ).
        ENDIF.
      ELSE.
        MESSAGE e005(zgtt)
          WITH 'VBUP' |{ lv_vbeln }-{ lv_posnr }|
          INTO lv_dummy.
        zcl_gtt_tools=>throw_exception( ).
      ENDIF.
    ELSE.
      MESSAGE e002(zgtt) WITH 'VBUP' INTO lv_dummy.
      zcl_gtt_tools=>throw_exception( ).
    ENDIF.

  ENDMETHOD.


  METHOD GET_OLD_APPOBJID.
    DATA: lv_vbeln TYPE lips-vbeln,
          lv_posnr TYPE lips-posnr.

    lv_vbeln  = zcl_gtt_tools=>get_field_of_structure(
                  ir_struct_data = ms_app_objects-maintabref
                  iv_field_name  = 'VBELN' ).

    lv_posnr  = zcl_gtt_tools=>get_field_of_structure(
                  ir_struct_data = ms_app_objects-maintabref
                  iv_field_name  = 'POSNR' ).

    rv_appobjid   = |{ lv_vbeln ALPHA = IN }{ lv_posnr ALPHA = IN }|.
  ENDMETHOD.
ENDCLASS.
