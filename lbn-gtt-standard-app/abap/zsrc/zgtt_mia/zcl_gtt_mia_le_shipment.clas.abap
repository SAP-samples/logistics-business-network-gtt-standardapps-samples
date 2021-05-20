class ZCL_GTT_MIA_LE_SHIPMENT definition
  public
  final
  create public .

public section.

  interfaces IF_EX_BADI_LE_SHIPMENT .
protected section.
private section.
ENDCLASS.



CLASS ZCL_GTT_MIA_LE_SHIPMENT IMPLEMENTATION.


  method IF_EX_BADI_LE_SHIPMENT~AT_SAVE.
  endmethod.


  METHOD if_ex_badi_le_shipment~before_update.
    CALL FUNCTION 'ZGTT_MIA_CTP_SH_TO_DL'
      EXPORTING
        is_shipment = im_shipments_before_update.
  ENDMETHOD.


  method IF_EX_BADI_LE_SHIPMENT~IN_UPDATE.
  endmethod.
ENDCLASS.
