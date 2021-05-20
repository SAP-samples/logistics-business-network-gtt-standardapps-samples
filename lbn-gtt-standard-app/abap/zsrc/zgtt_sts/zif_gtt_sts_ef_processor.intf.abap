interface ZIF_GTT_STS_EF_PROCESSOR
  public .


  methods CHECK_APP_OBJECTS
    raising
      CX_UDM_MESSAGE .
  methods CHECK_RELEVANCE
    importing
      !IO_BO_FACTORY type ref to ZIF_GTT_STS_FACTORY
    returning
      value(RV_RESULT) type ZIF_GTT_STS_EF_TYPES=>TV_CONDITION
    raising
      CX_UDM_MESSAGE .
  methods GET_CONTROL_DATA
    importing
      !IO_BO_FACTORY type ref to ZIF_GTT_STS_FACTORY
    changing
      !CT_CONTROL_DATA type ZIF_GTT_STS_EF_TYPES=>TT_CONTROL_DATA
    raising
      CX_UDM_MESSAGE .
  methods GET_PLANNED_EVENTS
    importing
      !IO_FACTORY type ref to ZIF_GTT_STS_FACTORY
    changing
      !CT_EXPEVENTDATA type ZIF_GTT_STS_EF_TYPES=>TT_EXPEVENTDATA
      !CT_MEASRMNTDATA type ZIF_GTT_STS_EF_TYPES=>TT_MEASRMNTDATA
      !CT_INFODATA type ZIF_GTT_STS_EF_TYPES=>TT_INFODATA   ##NEEDED
    raising
      CX_UDM_MESSAGE .
  methods GET_TRACK_ID_DATA
    importing
      !IO_BO_FACTORY type ref to ZIF_GTT_STS_FACTORY
    exporting
      !ET_TRACK_ID_DATA type ZIF_GTT_STS_EF_TYPES=>TT_TRACK_ID_DATA
    raising
      CX_UDM_MESSAGE .
endinterface.
