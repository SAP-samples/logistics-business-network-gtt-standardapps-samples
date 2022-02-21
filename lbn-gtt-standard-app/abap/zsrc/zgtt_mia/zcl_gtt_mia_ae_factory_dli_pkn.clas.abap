class ZCL_GTT_MIA_AE_FACTORY_DLI_PKN definition
  public
  inheriting from ZCL_GTT_AE_FACTORY
  create public .

public section.

  methods ZIF_GTT_AE_FACTORY~GET_AE_FILLER
    redefinition .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_GTT_MIA_AE_FACTORY_DLI_PKN IMPLEMENTATION.


  METHOD ZIF_GTT_AE_FACTORY~GET_AE_FILLER.

    ro_ae_filler = NEW zcl_gtt_mia_ae_filler_dli_pkn(
      io_ae_parameters = io_ae_parameters ).

  ENDMETHOD.
ENDCLASS.
