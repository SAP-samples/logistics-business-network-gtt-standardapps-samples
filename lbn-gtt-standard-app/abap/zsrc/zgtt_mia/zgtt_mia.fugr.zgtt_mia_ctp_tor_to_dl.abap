FUNCTION zgtt_mia_ctp_tor_to_dl.
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
*"     REFERENCE(IT_TOR_STOP_ADDR_SSTRING) TYPE
*"        /SCMTMS/T_EM_BO_LOC_ADDR
*"----------------------------------------------------------------------
  TRY.

      " *** collect F.O./F.U. changes that affects inbound deliveries ***
      DATA(lo_tor_changes)  = NEW zcl_gtt_mia_ctp_tor_changes(
                                it_tor_root_sstring        = it_tor_root_sstring
                                it_tor_root_before_sstring = it_tor_root_before_sstring
                                it_tor_item_sstring        = it_tor_item_sstring
                                it_tor_item_before_sstring = it_tor_item_before_sstring
                                it_tor_stop_sstring        = it_tor_stop_sstring
                                it_tor_stop_addr_sstring   = it_tor_stop_addr_sstring ).

      FIELD-SYMBOLS: <lt_delivery_chng> TYPE zif_gtt_mia_ctp_types=>tt_delivery_chng.

      DATA(lr_delivery_chng)  = lo_tor_changes->get_delivery_items( ).

      ASSIGN lr_delivery_chng->* TO <lt_delivery_chng>.

      IF <lt_delivery_chng> IS ASSIGNED AND <lt_delivery_chng> IS NOT INITIAL.

        " *** prepare and send DLV Header IDOC ***
        DATA(lo_dl_head_data) = NEW zcl_gtt_mia_ctp_dat_tor_to_dlh(
                                  it_delivery_chng = <lt_delivery_chng>
                                  it_tor_root      = it_tor_root_sstring
                                  it_tor_item      = it_tor_item_sstring ).

        DATA(lo_dl_head_sender) = zcl_gtt_mia_ctp_snd_tor_to_dlh=>get_instance( ).

        lo_dl_head_sender->prepare_idoc_data( io_dl_head_data = lo_dl_head_data ).

        lo_dl_head_sender->send_idoc_data( ).

        " *** prepare and send DLV Item IDOC ***
        DATA(lo_dlv_item_data) = NEW zcl_gtt_mia_ctp_dat_tor_to_dli(
                                   it_delivery_chng = <lt_delivery_chng> ).

        DATA(lo_dlv_item_sender) = zcl_gtt_mia_ctp_snd_tor_to_dli=>get_instance( ).

        lo_dlv_item_sender->prepare_idoc_data( io_dl_item_data = lo_dlv_item_data ).

        lo_dlv_item_sender->send_idoc_data( ).
      ENDIF.

    CATCH cx_udm_message INTO DATA(lo_udm_message).
      zcl_gtt_mia_tools=>log_exception(
        EXPORTING
          io_udm_message = lo_udm_message
          iv_object      = zif_gtt_mia_ef_constants=>cs_logs-object-tor_ctp
          iv_subobject   = zif_gtt_mia_ef_constants=>cs_logs-subobject-tor_ctp ).
    CATCH cx_root.
  ENDTRY.







ENDFUNCTION.
