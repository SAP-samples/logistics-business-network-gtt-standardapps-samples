FUNCTION zgtt_spof_ctp_dl_to_po .
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(IT_XLIKP) TYPE  SHP_LIKP_T
*"     REFERENCE(IT_XLIPS) TYPE  SHP_LIPS_T
*"     REFERENCE(IT_YLIPS) TYPE  SHP_LIPS_T
*"----------------------------------------------------------------------
  TRY.
      DATA(lo_item) = zcl_gtt_spof_ctp_snd_dl_to_po=>get_instance( ).
      DATA(lo_dli) = NEW zcl_gtt_spof_ctp_dli_data(
        it_xlikp = it_xlikp
        it_xlips = it_xlips
        it_ylips = it_ylips
      ).

      lo_item->prepare_idoc_data( io_dli_data = lo_dli ).

      lo_item->send_idoc_data( ).

    CATCH cx_udm_message INTO DATA(lo_udm_message).
      zcl_gtt_tools=>log_exception(
        EXPORTING
          io_udm_message = lo_udm_message
          iv_object      = zif_gtt_ef_constants=>cs_logs-object-delivery_ctp
          iv_subobject   = zif_gtt_ef_constants=>cs_logs-subobject-delivery_ctp ).
  ENDTRY.

ENDFUNCTION.
