CLASS zcl_gtt_mia_tp_factory_shh DEFINITION
  PUBLIC
  INHERITING FROM zcl_gtt_mia_tp_factory
  CREATE PUBLIC .

  PUBLIC SECTION.

    METHODS zif_gtt_mia_tp_factory~get_tp_reader
        REDEFINITION .
    METHODS zif_gtt_mia_tp_factory~get_pe_filler
        REDEFINITION .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_gtt_mia_tp_factory_shh IMPLEMENTATION.


  METHOD zif_gtt_mia_tp_factory~get_tp_reader.

    ro_bo_reader    = NEW zcl_gtt_mia_tp_reader_shh(
                        io_ef_parameters = io_ef_parameters ).

  ENDMETHOD.


  METHOD zif_gtt_mia_tp_factory~get_pe_filler.

    ro_pe_filler    = NEW zcl_gtt_mia_pe_filler_shh(
                        io_ef_parameters = io_ef_parameters
                        io_bo_reader     = io_bo_reader ).

  ENDMETHOD.
ENDCLASS.
