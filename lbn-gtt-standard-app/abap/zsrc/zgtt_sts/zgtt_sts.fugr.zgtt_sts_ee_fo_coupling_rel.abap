FUNCTION zgtt_sts_ee_fo_coupling_rel.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(I_APPSYS) TYPE  /SAPTRX/APPLSYSTEM
*"     REFERENCE(I_EVENT_TYPES) TYPE  /SAPTRX/EVTYPES
*"     REFERENCE(I_ALL_APPL_TABLES) TYPE  TRXAS_TABCONTAINER
*"     REFERENCE(I_EVENTTYPE_TAB) TYPE  TRXAS_EVENTTYPE_TABS_WA
*"     REFERENCE(I_EVENT) TYPE  TRXAS_EVT_CTAB_WA
*"  EXPORTING
*"     VALUE(E_RESULT) LIKE  SY-BINPT
*"  TABLES
*"      C_LOGTABLE STRUCTURE  BAPIRET2 OPTIONAL
*"  EXCEPTIONS
*"      PARAMETER_ERROR
*"      RELEVANCE_DETERM_ERROR
*"      STOP_PROCESSING
*"----------------------------------------------------------------------

  TRY.
      data(lo_act_evt) = zcl_gtt_sts_actual_event=>get_tor_actual_event_class( i_event ).
      CHECK lo_act_evt is BOUND.
      lo_act_evt->check_event_relevance(
        EXPORTING
          it_all_appl_tables = i_all_appl_tables
          iv_event_code     = /scmtms/if_tor_const=>sc_tor_event-coupling
          is_event           = i_event
        IMPORTING
          ev_result          = e_result ).
    CATCH cx_udm_message INTO DATA(lo_udm_message).
      zcl_gtt_sts_tools=>get_errors_log(
        EXPORTING
          io_umd_message = lo_udm_message
          iv_appsys      = i_appsys
        IMPORTING
          es_bapiret     = DATA(ls_bapiret) ).
      APPEND ls_bapiret TO c_logtable.
      RAISE stop_processing.
  ENDTRY.

  IF e_result = zif_gtt_sts_ef_constants=>cs_condition-false.
    RETURN.
  ENDIF.

  CALL FUNCTION '/SCMTMS/REL_EVT_TOR_COUPL'
    EXPORTING
      i_appsys               = i_appsys
      i_event_types          = i_event_types
      i_all_appl_tables      = i_all_appl_tables
      i_eventtype_tab        = i_eventtype_tab
      i_event                = i_event
    IMPORTING
      e_result               = e_result
    TABLES
      c_logtable             = c_logtable
    EXCEPTIONS
      parameter_error        = 1
      relevance_determ_error = 2
      stop_processing        = 3
      OTHERS                 = 4.
  CASE sy-subrc.
    WHEN 1.
      RAISE parameter_error.
    WHEN 2.
      RAISE relevance_determ_error.
    WHEN 3.
      RAISE stop_processing.
  ENDCASE.

ENDFUNCTION.
