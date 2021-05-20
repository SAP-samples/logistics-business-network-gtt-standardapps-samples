interface ZIF_GTT_STS_AE_FACTORY
  public .


  methods GET_AE_FILLER
    importing
      !IO_AE_PARAMETERS type ref to ZIF_GTT_STS_AE_PARAMETERS
    returning
      value(RO_AE_FILLER) type ref to ZIF_GTT_STS_AE_FILLER .
  methods GET_AE_PARAMETERS
    importing
      !IV_APPSYS type /SAPTRX/APPLSYSTEM
      !IS_EVENT_TYPE type /SAPTRX/EVTYPES
      !IT_ALL_APPL_TABLES type TRXAS_TABCONTAINER
      !IT_EVENT_TYPE_CNTL_TABS type TRXAS_EVENTTYPE_TABS optional
      !IT_EVENTS type TRXAS_EVT_CTABS
    returning
      value(RO_AE_PARAMETERS) type ref to ZIF_GTT_STS_AE_PARAMETERS
    raising
      CX_UDM_MESSAGE .
  methods GET_AE_PROCESSOR
    importing
      !IS_DEFINITION type ZIF_GTT_STS_EF_TYPES=>TS_DEFINITION
      !IO_AE_FACTORY type ref to ZIF_GTT_STS_AE_FACTORY
      !IV_APPSYS type /SAPTRX/APPLSYSTEM
      !IS_EVENT_TYPE type /SAPTRX/EVTYPES
      !IT_ALL_APPL_TABLES type TRXAS_TABCONTAINER
      !IT_EVENT_TYPE_CNTL_TABS type TRXAS_EVENTTYPE_TABS optional
      !IT_EVENTS type TRXAS_EVT_CTABS
    returning
      value(RO_AE_PROCESSOR) type ref to ZIF_GTT_STS_AE_PROCESSOR
    raising
      CX_UDM_MESSAGE .
endinterface.
