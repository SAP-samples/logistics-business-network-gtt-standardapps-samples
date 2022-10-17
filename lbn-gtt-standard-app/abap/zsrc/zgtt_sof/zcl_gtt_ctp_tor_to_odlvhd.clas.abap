class ZCL_GTT_CTP_TOR_TO_ODLVHD definition
  public
  inheriting from ZCL_GTT_CTP_TOR_TO_DL_BASE
  create public .

public section.
protected section.

  methods GET_AOTYPE_RESTRICTION_ID
    redefinition .
private section.
ENDCLASS.



CLASS ZCL_GTT_CTP_TOR_TO_ODLVHD IMPLEMENTATION.


  METHOD get_aotype_restriction_id.

    rv_rst_id   = 'FU_TO_ODLH'.

  ENDMETHOD.
ENDCLASS.
