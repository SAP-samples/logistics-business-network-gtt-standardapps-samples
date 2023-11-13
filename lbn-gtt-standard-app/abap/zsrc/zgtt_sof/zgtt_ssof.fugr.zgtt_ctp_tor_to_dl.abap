FUNCTION zgtt_ctp_tor_to_dl .
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(IT_TOR_ROOT_SSTRING) TYPE  /SCMTMS/T_EM_BO_TOR_ROOT
*"     REFERENCE(IT_TOR_ROOT_BEFORE_SSTRING) TYPE
*"        /SCMTMS/T_EM_BO_TOR_ROOT
*"     REFERENCE(IT_TOR_ITEM_SSTRING) TYPE  /SCMTMS/T_EM_BO_TOR_ITEM
*"     REFERENCE(IT_TOR_ITEM_BEFORE_SSTRING) TYPE
*"        /SCMTMS/T_EM_BO_TOR_ITEM
*"     REFERENCE(IT_TOR_STOP_SSTRING) TYPE  /SCMTMS/T_EM_BO_TOR_STOP
*"----------------------------------------------------------------------

  DATA:
    lt_tor_stop_before TYPE /scmtms/t_em_bo_tor_stop,
    lv_base_btd_tco    TYPE /scmtms/base_btd_tco,
    lo_tor_to_dlv_it   TYPE REF TO zif_gtt_ctp_tor_to_dl,
    lv_result          TYPE syst_binpt,
    lt_callstack       TYPE abap_callstack.

  CALL FUNCTION 'SYSTEM_CALLSTACK'
    IMPORTING
      callstack = lt_callstack.

* read the call stack to check if a outbound delivery being created based on purchase order
  READ TABLE lt_callstack TRANSPORTING NO FIELDS WITH KEY mainprogram = 'SAPLV50R_CREA'
                                                          include     = 'LV50R_CREAU01'
                                                          blocktype   = 'FUNCTION'
                                                          blockname   = 'SHP_VL10_DELIVERY_CREATE'.
  IF sy-subrc = 0.
    RETURN.
  ENDIF.

  zcl_gtt_sof_tm_tools=>get_tor_stop_before(
    EXPORTING
      it_tor_root        = it_tor_root_sstring
    RECEIVING
      rt_tor_stop_before = lt_tor_stop_before ).

  zcl_gtt_sof_tm_tools=>get_dlv_tor_relation(
    EXPORTING
      it_tor_root_sstring = it_tor_root_sstring
      it_tor_item_sstring = it_tor_item_sstring
    IMPORTING
      et_fu_info          = DATA(lt_fu_info) ).

* Get Base Document Type
  LOOP AT it_tor_root_sstring ASSIGNING FIELD-SYMBOL(<ls_tor_root>)
    WHERE tor_cat = /scmtms/if_tor_const=>sc_tor_category-freight_unit
      AND ( base_btd_tco = /scmtms/if_common_c=>c_btd_tco-outbounddelivery
       OR base_btd_tco = /scmtms/if_common_c=>c_btd_tco-inbounddelivery ).
    lv_base_btd_tco = <ls_tor_root>-base_btd_tco.
    EXIT.
  ENDLOOP.

  IF lv_base_btd_tco = /scmtms/if_common_c=>c_btd_tco-outbounddelivery.
    lo_tor_to_dlv_it = NEW zcl_gtt_ctp_tor_to_odlvit( ).
  ELSEIF lv_base_btd_tco = /scmtms/if_common_c=>c_btd_tco-inbounddelivery.
    lo_tor_to_dlv_it = NEW zcl_gtt_ctp_tor_to_idlvit( ).
  ENDIF.

  CHECK lo_tor_to_dlv_it IS BOUND.

  TRY.
*     Process Delivery Item IDOC
      CLEAR lv_result.
      lo_tor_to_dlv_it->initiate(
        it_tor_root        = it_tor_root_sstring
        it_tor_root_before = it_tor_root_before_sstring
        it_tor_item        = it_tor_item_sstring
        it_tor_item_before = it_tor_item_before_sstring
        it_tor_stop        = it_tor_stop_sstring
        it_tor_stop_before = lt_tor_stop_before
        it_fu_info         = lt_fu_info ).

      lo_tor_to_dlv_it->check_relevance(
        RECEIVING
          rv_result = lv_result ).

      IF lv_result = zif_gtt_sts_ef_constants=>cs_condition-true.
        lo_tor_to_dlv_it->extract_data( ).
        lo_tor_to_dlv_it->process_data( ).
      ENDIF.

    CATCH cx_udm_message INTO DATA(lo_udm_message).
      zcl_gtt_sof_tm_tools=>log_exception(
        EXPORTING
          io_udm_message = lo_udm_message
          iv_object      = zif_gtt_sof_ctp_tor_constants=>cs_logs-object-tor_ctp
          iv_subobject   = zif_gtt_sof_ctp_tor_constants=>cs_logs-subobject-tor_ctp ).
    CATCH cx_root.
  ENDTRY.

ENDFUNCTION.
