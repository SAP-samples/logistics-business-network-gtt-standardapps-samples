CLASS zcl_gtt_mia_ae_factory_dlh_gr DEFINITION
  PUBLIC
  INHERITING FROM zcl_gtt_mia_ae_factory
  CREATE PUBLIC .

  PUBLIC SECTION.

    METHODS zif_gtt_mia_ae_factory~get_ae_filler
        REDEFINITION .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_gtt_mia_ae_factory_dlh_gr IMPLEMENTATION.


  METHOD zif_gtt_mia_ae_factory~get_ae_filler.

    ro_ae_filler    = NEW zcl_gtt_mia_ae_filler_dlh_gr(
                        io_ae_parameters = io_ae_parameters ).

  ENDMETHOD.
ENDCLASS.
