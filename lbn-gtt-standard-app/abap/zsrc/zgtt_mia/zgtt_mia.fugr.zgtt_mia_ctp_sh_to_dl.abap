FUNCTION zgtt_mia_ctp_sh_to_dl.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(IS_SHIPMENT) TYPE  CXSHIPMENT
*"----------------------------------------------------------------------
  TRY.
      DATA(lo_head) = zcl_gtt_mia_ctp_snd_sh_to_dlh=>get_instance( ).
      DATA(lo_ship) = NEW zcl_gtt_mia_ctp_shipment_data( is_shipment = is_shipment ).

      " Delivery header
      lo_head->prepare_idoc_data( io_ship_data = lo_ship ).

      lo_head->send_idoc_data( ).

    CATCH cx_udm_message INTO DATA(lo_udm_message).
      zcl_gtt_mia_tools=>log_exception(
        EXPORTING
          io_udm_message = lo_udm_message
          iv_object      = zif_gtt_mia_ef_constants=>cs_logs-object-shipment_ctp
          iv_subobject   = zif_gtt_mia_ef_constants=>cs_logs-subobject-shipment_ctp ).
  ENDTRY.

ENDFUNCTION.
