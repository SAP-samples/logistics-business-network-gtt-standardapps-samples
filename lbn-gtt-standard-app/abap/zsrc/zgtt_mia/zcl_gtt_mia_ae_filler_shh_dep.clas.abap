class ZCL_GTT_MIA_AE_FILLER_SHH_DEP definition
  public
  inheriting from ZCL_GTT_MIA_AE_FILLER_SHH_BS
  create public .

public section.
  PROTECTED SECTION.

    METHODS get_date_field
        REDEFINITION .
    METHODS get_eventid
        REDEFINITION .
    METHODS get_location_category
        REDEFINITION .
    METHODS get_time_field
        REDEFINITION .
    METHODS is_location_required
        REDEFINITION .
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_GTT_MIA_AE_FILLER_SHH_DEP IMPLEMENTATION.


  METHOD GET_DATE_FIELD.

    rv_field    = 'DATBG'.

  ENDMETHOD.


  METHOD GET_EVENTID.

    rv_eventid  = zif_gtt_ef_constants=>cs_milestone-sh_departure.

  ENDMETHOD.


  METHOD GET_LOCATION_CATEGORY.

    rv_loccat   = zif_gtt_mia_app_constants=>cs_loccat-departure.

  ENDMETHOD.


  METHOD GET_TIME_FIELD.

    rv_field    = 'UATBG'.

  ENDMETHOD.


  METHOD IS_LOCATION_REQUIRED.

    rv_result   = abap_false.

  ENDMETHOD.
ENDCLASS.
