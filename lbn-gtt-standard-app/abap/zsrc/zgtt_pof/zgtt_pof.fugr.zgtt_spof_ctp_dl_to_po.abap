FUNCTION zgtt_spof_ctp_dl_to_po .
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(IT_XLIKP) TYPE  SHP_LIKP_T
*"     REFERENCE(IT_XLIPS) TYPE  SHP_LIPS_T
*"     REFERENCE(IT_YLIPS) TYPE  SHP_LIPS_T
*"----------------------------------------------------------------------
  TRY.

*     Inbound delivery to PO Header
      DATA(lo_header) = zcl_gtt_spof_ctp_snd_dl_to_poh=>get_instance( ).
      DATA(lo_dlh) = NEW zcl_gtt_spof_ctp_dlh_data(
        it_xlikp = it_xlikp
        it_xlips = it_xlips
        it_ylips = it_ylips ).
      IF lo_header IS BOUND.
        lo_header->prepare_idoc_data( io_dlh_data = lo_dlh ).
        lo_header->send_idoc_data( ).
      ENDIF.

*     Outbound delivery to PO Header
      lo_dlh = NEW zcl_gtt_spof_ctp_dlh_data(
        it_xlikp       = it_xlikp
        it_xlips       = it_xlips
        it_ylips       = it_ylips
        iv_sto_is_used = abap_true ).
      IF lo_header IS BOUND.
        lo_header->prepare_idoc_data( io_dlh_data = lo_dlh ).
        lo_header->send_idoc_data( ).
      ENDIF.

*     Inbound/Outbound delivery to PO item
      DATA(lo_item) = zcl_gtt_spof_ctp_snd_dl_to_po=>get_instance( ).
      DATA(lo_dli) = NEW zcl_gtt_spof_ctp_dli_data(
        it_xlikp = it_xlikp
        it_xlips = it_xlips
        it_ylips = it_ylips
      ).
      IF lo_item IS BOUND.
        lo_item->prepare_idoc_data( io_dli_data = lo_dli ).

        lo_item->send_idoc_data( ).
      ENDIF.
    CATCH cx_udm_message INTO DATA(lo_udm_message).
      zcl_gtt_tools=>log_exception(
        EXPORTING
          io_udm_message = lo_udm_message
          iv_object      = zif_gtt_ef_constants=>cs_logs-object-delivery_ctp
          iv_subobject   = zif_gtt_ef_constants=>cs_logs-subobject-delivery_ctp ).
  ENDTRY.

ENDFUNCTION.
