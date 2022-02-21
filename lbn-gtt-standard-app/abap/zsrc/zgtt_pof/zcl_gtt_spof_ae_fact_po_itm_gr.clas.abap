CLASS zcl_gtt_spof_ae_fact_po_itm_gr DEFINITION
  PUBLIC
  INHERITING FROM zcl_gtt_ae_factory
  CREATE PUBLIC .

  PUBLIC SECTION.

    METHODS zif_gtt_ae_factory~get_ae_filler
        REDEFINITION .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_GTT_SPOF_AE_FACT_PO_ITM_GR IMPLEMENTATION.


  METHOD zif_gtt_ae_factory~get_ae_filler.
    ro_ae_filler = NEW zcl_gtt_spof_ae_fill_po_itm_gr(
      io_ae_parameters = io_ae_parameters ).
  ENDMETHOD.
ENDCLASS.
