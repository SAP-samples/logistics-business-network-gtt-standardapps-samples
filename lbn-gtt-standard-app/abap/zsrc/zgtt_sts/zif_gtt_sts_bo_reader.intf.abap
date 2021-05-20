interface ZIF_GTT_STS_BO_READER
  public .


  methods CHECK_RELEVANCE
    importing
      !IS_APP_OBJECT type TRXAS_APPOBJ_CTAB_WA
    returning
      value(RV_RESULT) type ZIF_GTT_STS_EF_TYPES=>TV_CONDITION
    raising
      CX_UDM_MESSAGE .
  methods GET_DATA
    importing
      !IS_APP_OBJECT type TRXAS_APPOBJ_CTAB_WA
      !IV_OLD_DATA type ABAP_BOOL default ABAP_FALSE
    returning
      value(RR_DATA) type ref to DATA
    raising
      CX_UDM_MESSAGE .
  methods GET_MAPPING_STRUCTURE
    returning
      value(RR_DATA) type ref to DATA .
  methods GET_TRACK_ID_DATA
    importing
      !IS_APP_OBJECT type TRXAS_APPOBJ_CTAB_WA
    exporting
      !ET_TRACK_ID_DATA type ZIF_GTT_STS_EF_TYPES=>TT_TRACK_ID_DATA
    raising
      CX_UDM_MESSAGE .
endinterface.
