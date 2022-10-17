interface ZIF_GTT_CTP_TOR_TO_DL
  public .


  methods INITIATE
    importing
      !IT_TOR_ROOT type /SCMTMS/T_EM_BO_TOR_ROOT
      !IT_TOR_ROOT_BEFORE type /SCMTMS/T_EM_BO_TOR_ROOT
      !IT_TOR_ITEM type /SCMTMS/T_EM_BO_TOR_ITEM
      !IT_TOR_ITEM_BEFORE type /SCMTMS/T_EM_BO_TOR_ITEM
      !IT_TOR_STOP type /SCMTMS/T_EM_BO_TOR_STOP
      !IT_TOR_STOP_BEFORE type /SCMTMS/T_EM_BO_TOR_STOP
      value(IT_FU_INFO) type /SCMTMS/T_TOR_ROOT_K optional
    raising
      CX_UDM_MESSAGE .
  methods CHECK_RELEVANCE
    returning
      value(RV_RESULT) type SYST_BINPT .
  methods EXTRACT_DATA .
  methods PROCESS_DATA
    exporting
      !ET_BAPIRET type BAPIRET2_T
    raising
      CX_UDM_MESSAGE .
endinterface.
