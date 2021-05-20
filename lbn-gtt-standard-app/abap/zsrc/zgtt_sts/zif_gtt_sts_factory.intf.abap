interface ZIF_GTT_STS_FACTORY
  public .


  methods GET_BO_READER
    importing
      !IS_APPL_OBJECT type TRXAS_APPOBJ_CTAB_WA
      !IO_EF_PARAMETERS type ref to ZIF_GTT_STS_EF_PARAMETERS
    returning
      value(RO_BO_READER) type ref to ZIF_GTT_STS_BO_READER
    raising
      CX_UDM_MESSAGE .
  methods GET_EF_PARAMETERS
    importing
      !IV_APPSYS type /SAPTRX/APPLSYSTEM
      !IS_APP_OBJ_TYPES type /SAPTRX/AOTYPES
      !IT_ALL_APPL_TABLES type TRXAS_TABCONTAINER
      !IT_APP_TYPE_CNTL_TABS type TRXAS_APPTYPE_TABS optional
      !IT_APP_OBJECTS type TRXAS_APPOBJ_CTABS
    returning
      value(RO_EF_PARAMETERS) type ref to ZIF_GTT_STS_EF_PARAMETERS .
  methods GET_EF_PROCESSOR
    importing
      !IS_DEFINITION type ZIF_GTT_STS_EF_TYPES=>TS_DEFINITION
      !IO_BO_FACTORY type ref to ZIF_GTT_STS_FACTORY
      !IV_APPSYS type /SAPTRX/APPLSYSTEM
      !IS_APP_OBJ_TYPES type /SAPTRX/AOTYPES
      !IT_ALL_APPL_TABLES type TRXAS_TABCONTAINER
      !IT_APP_TYPE_CNTL_TABS type TRXAS_APPTYPE_TABS
      !IT_APP_OBJECTS type TRXAS_APPOBJ_CTABS
    returning
      value(RO_EF_PROCESSOR) type ref to ZIF_GTT_STS_EF_PROCESSOR .
  methods GET_PE_FILLER
    importing
      !IS_APPL_OBJECT type TRXAS_APPOBJ_CTAB_WA
      !IO_EF_PARAMETERS type ref to ZIF_GTT_STS_EF_PARAMETERS
    returning
      value(RO_PE_FILLER) type ref to ZIF_GTT_STS_PE_FILLER
    raising
      CX_UDM_MESSAGE .
endinterface.
