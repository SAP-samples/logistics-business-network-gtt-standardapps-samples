CLASS zcl_gtt_spof_tp_factory_po_itm DEFINITION
  PUBLIC
  INHERITING FROM zcl_gtt_tp_factory
  CREATE PUBLIC .

  PUBLIC SECTION.

    METHODS zif_gtt_tp_factory~get_pe_filler
        REDEFINITION .
    METHODS zif_gtt_tp_factory~get_tp_reader
        REDEFINITION .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_GTT_SPOF_TP_FACTORY_PO_ITM IMPLEMENTATION.


  METHOD zif_gtt_tp_factory~get_pe_filler.
    ro_pe_filler = NEW zcl_gtt_spof_pe_filler_po_itm(
      io_ef_parameters = io_ef_parameters
      io_bo_reader     = io_bo_reader ).
  ENDMETHOD.


  METHOD zif_gtt_tp_factory~get_tp_reader.

    ro_bo_reader = NEW zcl_gtt_spof_tp_reader_po_itm(
      io_ef_parameters = io_ef_parameters ).

  ENDMETHOD.
ENDCLASS.
