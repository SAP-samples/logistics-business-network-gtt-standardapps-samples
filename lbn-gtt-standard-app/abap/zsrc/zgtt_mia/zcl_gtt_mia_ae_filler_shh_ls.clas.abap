class ZCL_GTT_MIA_AE_FILLER_SHH_LS definition
  public
  inheriting from ZCL_GTT_MIA_AE_FILLER_SHH_BH
  create public .

public section.
protected section.

  methods GET_DATE_FIELD
    redefinition .
  methods GET_EVENTID
    redefinition .
  methods GET_TIME_FIELD
    redefinition .
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_GTT_MIA_AE_FILLER_SHH_LS IMPLEMENTATION.


  METHOD GET_DATE_FIELD.

    rv_field  = 'DALBG'.

  ENDMETHOD.


  METHOD GET_EVENTID.

    rv_eventid  = zif_gtt_ef_constants=>cs_milestone-sh_load_start.

  ENDMETHOD.


  METHOD GET_TIME_FIELD.

    rv_field  = 'UALBG'.

  ENDMETHOD.
ENDCLASS.
