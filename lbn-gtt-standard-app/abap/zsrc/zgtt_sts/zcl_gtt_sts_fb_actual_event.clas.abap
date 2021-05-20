CLASS zcl_gtt_sts_fb_actual_event DEFINITION
  PUBLIC
  INHERITING FROM zcl_gtt_sts_actual_event
  CREATE PUBLIC .

  PUBLIC SECTION.
  PROTECTED SECTION.

    METHODS check_tor_type_specific_events
        REDEFINITION .
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_GTT_STS_FB_ACTUAL_EVENT IMPLEMENTATION.


  METHOD check_tor_type_specific_events.

    IF iv_event_code <> /scmtms/if_tor_const=>sc_tor_event-departure    AND
       iv_event_code <> /scmtms/if_tor_const=>sc_tor_event-arriv_dest   AND
       iv_event_code <> /scmtms/if_tor_const=>sc_tor_event-popu         AND
       iv_event_code <> /scmtms/if_tor_const=>sc_tor_event-pod          AND
       iv_event_code <> /scmtms/if_tor_const=>sc_tor_event-load_begin   AND
       iv_event_code <> /scmtms/if_tor_const=>sc_tor_event-load_end     AND
       iv_event_code <> /scmtms/if_tor_const=>sc_tor_event-unload_begin AND
       iv_event_code <> /scmtms/if_tor_const=>sc_tor_event-unload_end   AND
       iv_event_code <> /scmtms/if_tor_const=>sc_tor_event-delay.
      ev_result = zif_gtt_sts_ef_constants=>cs_condition-false.
    ENDIF.

  ENDMETHOD.
ENDCLASS.
