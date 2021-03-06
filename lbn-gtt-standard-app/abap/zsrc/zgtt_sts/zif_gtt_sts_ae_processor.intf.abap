interface ZIF_GTT_STS_AE_PROCESSOR
  public .


  methods CHECK_EVENTS
    raising
      CX_UDM_MESSAGE .
  methods CHECK_RELEVANCE
    returning
      value(RV_RESULT) type ZIF_GTT_STS_EF_TYPES=>TV_CONDITION
    raising
      CX_UDM_MESSAGE .
  methods GET_EVENT_DATA
    changing
      !CT_EVENTID_MAP type TRXAS_EVTID_EVTCNT_MAP
      !CT_TRACKINGHEADER type ZIF_GTT_STS_AE_TYPES=>TT_TRACKINGHEADER
      !CT_TRACKLOCATION type ZIF_GTT_STS_AE_TYPES=>TT_TRACKLOCATION
      !CT_TRACKREFERENCES type ZIF_GTT_STS_AE_TYPES=>TT_TRACKREFERENCES
      !CT_TRACKPARAMETERS type ZIF_GTT_STS_AE_TYPES=>TT_TRACKPARAMETERS
    raising
      CX_UDM_MESSAGE .
endinterface.
