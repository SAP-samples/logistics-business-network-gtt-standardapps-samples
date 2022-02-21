class ZCL_GTT_MIA_AE_FACTORY_DLI_PA definition
  public
  inheriting from ZCL_GTT_AE_FACTORY
  create public .

public section.

  methods ZIF_GTT_AE_FACTORY~GET_AE_FILLER
    redefinition .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_GTT_MIA_AE_FACTORY_DLI_PA IMPLEMENTATION.


  METHOD ZIF_GTT_AE_FACTORY~GET_AE_FILLER.

    ro_ae_filler = NEW zcl_gtt_mia_ae_filler_dli_pa(
      io_ae_parameters = io_ae_parameters ).

  ENDMETHOD.
ENDCLASS.
