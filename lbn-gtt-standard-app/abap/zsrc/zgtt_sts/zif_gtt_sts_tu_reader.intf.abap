interface ZIF_GTT_STS_TU_READER
  public .


  types:
    BEGIN OF ts_relevance,
      node_id TYPE /scmtms/bo_node_id,
      tor_id  TYPE /scmtms/tor_id,
      rel     TYPE syst_binpt,
    END OF ts_relevance .
  types:
    tt_relevance TYPE TABLE OF ts_relevance .

  methods INITIATE
    importing
      !IT_TOR_ROOT type /SCMTMS/T_EM_BO_TOR_ROOT
      !IV_TOR_CAT type /SCMTMS/TOR_CATEGORY
      !IV_AOTYPE type /SAPTRX/AOTYPE
    raising
      CX_UDM_MESSAGE .
  methods CHECK_RELEVANCE
    importing
      !IT_TOR_ROOT_SSTRING type /SCMTMS/T_EM_BO_TOR_ROOT
      !IT_TOR_ITEM_SSTRING type /SCMTMS/T_EM_BO_TOR_ITEM
      !IT_TOR_ROOT_BEFORE_SSTRING type /SCMTMS/T_EM_BO_TOR_ROOT
      !IT_TOR_ITEM_BEFORE_SSTRING type /SCMTMS/T_EM_BO_TOR_ITEM
    changing
      !ET_RELEVANCE type TT_RELEVANCE
    raising
      CX_UDM_MESSAGE .
  methods GENERATE_NEW_TU
    importing
      !IT_TOR_ROOT_SSTRING type /SCMTMS/T_EM_BO_TOR_ROOT
      !IT_TOR_ITEM_SSTRING type /SCMTMS/T_EM_BO_TOR_ITEM
      !IT_TOR_ROOT_BEFORE_SSTRING type /SCMTMS/T_EM_BO_TOR_ROOT optional
      !IT_TOR_ITEM_BEFORE_SSTRING type /SCMTMS/T_EM_BO_TOR_ITEM optional
      !IT_RELEVANCE type TT_RELEVANCE
    raising
      CX_UDM_MESSAGE .
  methods DELETE_OLD_TU
    importing
      !IT_TOR_ROOT_FOR_DELETION type /SCMTMS/T_EM_BO_TOR_ROOT
      !IT_ITEM_SSTRING type /SCMTMS/T_EM_BO_TOR_ITEM
      !IT_TOR_ROOT_BEFORE_SSTRING type /SCMTMS/T_EM_BO_TOR_ROOT
      !IT_ITEM_BEFORE_SSTRING type /SCMTMS/T_EM_BO_TOR_ITEM
      !IT_TOR_ROOT_SSTRING type /SCMTMS/T_EM_BO_TOR_ROOT
    raising
      CX_UDM_MESSAGE .
endinterface.
