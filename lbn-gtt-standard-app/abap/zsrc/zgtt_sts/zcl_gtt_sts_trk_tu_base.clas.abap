CLASS zcl_gtt_sts_trk_tu_base DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES zif_gtt_sts_tu_reader .

    TYPES tv_tracked_object_type TYPE string .
    TYPES:
      tt_tracked_object_type TYPE STANDARD TABLE OF tv_tracked_object_type WITH EMPTY KEY .
    TYPES tv_tracked_object_id TYPE char20 .
    TYPES:
      tt_tracked_object_id TYPE STANDARD TABLE OF tv_tracked_object_type WITH EMPTY KEY .
    TYPES tv_stop_id TYPE string .
    TYPES:
      tt_stop_id TYPE STANDARD TABLE OF tv_stop_id WITH EMPTY KEY .
    TYPES tv_ordinal_no TYPE int4 .
    TYPES:
      tt_ordinal_no TYPE STANDARD TABLE OF tv_ordinal_no WITH EMPTY KEY .
    TYPES tv_loc_type TYPE /saptrx/loc_id_type .
    TYPES:
      tt_loc_type TYPE STANDARD TABLE OF tv_loc_type WITH EMPTY KEY .
    TYPES tv_loc_id TYPE /scmtms/location_id .
    TYPES:
      tt_loc_id TYPE STANDARD TABLE OF tv_loc_id WITH EMPTY KEY .
    TYPES ts_control_data TYPE /saptrx/control_data .
    TYPES:
      tt_control_data TYPE STANDARD TABLE OF ts_control_data .
    TYPES tv_carrier_ref_value TYPE /scmtms/btd_id .
    TYPES:
      tt_carrier_ref_value TYPE STANDARD TABLE OF tv_carrier_ref_value WITH EMPTY KEY .
    TYPES tv_carrier_ref_type TYPE char35 .
    TYPES:
      tt_carrier_ref_type TYPE STANDARD TABLE OF tv_carrier_ref_type WITH EMPTY KEY .
    TYPES:
      BEGIN OF ts_aotype,
        tor_type    TYPE /scmtms/tor_type,
        aot_type    TYPE /saptrx/aotype,
        server_name TYPE /saptrx/trxservername,
      END OF ts_aotype .
    TYPES:
      tt_aotype TYPE STANDARD TABLE OF ts_aotype WITH EMPTY KEY .
    TYPES:
      BEGIN OF ts_tor_data,
        tor_id   TYPE /scmtms/tor_id,
        tor_type TYPE /scmtms/tor_type,
      END OF ts_tor_data .
    TYPES:
      BEGIN OF ts_tu_header,
        tu_no               TYPE char20,
        tspid               TYPE bu_id_number,
        trmodcod            TYPE /scmtms/s_em_bo_tor_root-trmodcod,
        shipping_type       TYPE /scmtms/s_em_bo_tor_root-shipping_type,
        pln_dep_loc_id      TYPE /scmtms/location_id,
        pln_dep_loc_type    TYPE /saptrx/loc_id_type,
        pln_dep_timest      TYPE char16,
        pln_dep_timezone    TYPE ad_tzone,
        pln_arr_loc_id      TYPE /scmtms/location_id,
        pln_arr_loc_type    TYPE /saptrx/loc_id_type,
        pln_arr_timest      TYPE char16,
        pln_arr_timezone    TYPE ad_tzone,
        stop_id             TYPE tt_stop_id,
        ordinal_no          TYPE tt_ordinal_no,
        loc_type            TYPE tt_loc_type,
        loc_id              TYPE tt_loc_id,
        tracked_object_type TYPE tt_tracked_object_type,
        tracked_object_id   TYPE tt_tracked_object_id,
        carrier_ref_value   TYPE tt_carrier_ref_value,
        carrier_ref_type    TYPE tt_carrier_ref_type,
        tu_type             TYPE string,
      END OF ts_tu_header .
    TYPES:
      BEGIN OF ts_resource,
        category      TYPE char20,
        orginal_value TYPE /scmtms/package_id,
        value         TYPE char60,
        change_mode   TYPE /bobf/conf_change_mode,
        tor_id        TYPE /scmtms/tor_id,
      END OF ts_resource .
    TYPES:
      tt_resource TYPE TABLE OF ts_resource .
    TYPES:
      tt_trxas_appobj_ctab TYPE STANDARD TABLE OF trxas_appobj_ctab_wa
                                                  WITH EMPTY KEY .
    TYPES:
      BEGIN OF ts_relevance,
        node_id TYPE /scmtms/bo_node_id,
        tor_id  TYPE /scmtms/tor_id,
        rel     TYPE syst_binpt,
      END OF ts_relevance .
    TYPES:
      tt_relevance TYPE TABLE OF ts_relevance .
    TYPES:
      BEGIN OF ts_idoc_data,
        control      TYPE /saptrx/bapi_trk_control_tab,
        info         TYPE /saptrx/bapi_trk_info_tab,
        tracking_id  TYPE /saptrx/bapi_trk_trkid_tab,
        exp_event    TYPE /saptrx/bapi_trk_ee_tab,
        trxserv      TYPE /saptrx/trxserv,
        appsys       TYPE logsys,
        appobj_ctabs TYPE tt_trxas_appobj_ctab,
      END OF ts_idoc_data .
    TYPES:
      tt_idoc_data TYPE STANDARD TABLE OF ts_idoc_data
                                     WITH EMPTY KEY .
    TYPES:
      BEGIN OF ts_text,
        text_type  TYPE char50,
        text_value TYPE char1024,
      END OF ts_text.
    TYPES:
      tt_text TYPE TABLE OF ts_text.

    CONSTANTS:
      BEGIN OF cs_mapping,
        tu_no               TYPE /saptrx/paramname VALUE 'YN_SHP_TU_NO',
        tspid               TYPE /saptrx/paramname VALUE 'YN_SHP_SA_LBN_ID',
        trmodcod            TYPE /saptrx/paramname VALUE 'YN_SHP_TRANSPORTATION_MODE',
        shipping_type       TYPE /saptrx/paramname VALUE 'YN_SHP_SHIPMENT_TYPE',
        pln_dep_loc_id      TYPE /saptrx/paramname VALUE 'YN_SHP_PLN_DEP_LOC_ID',
        pln_dep_loc_type    TYPE /saptrx/paramname VALUE 'YN_SHP_PLN_DEP_LOC_TYPE',
        pln_dep_timest      TYPE /saptrx/paramname VALUE 'YN_SHP_PLN_DEP_BUS_DATETIME',
        pln_dep_timezone    TYPE /saptrx/paramname VALUE 'YN_SHP_PLN_DEP_BUS_TIMEZONE',
        pln_arr_loc_id      TYPE /saptrx/paramname VALUE 'YN_SHP_PLN_AR_LOC_ID',
        pln_arr_loc_type    TYPE /saptrx/paramname VALUE 'YN_SHP_PLN_AR_LOC_TYPE',
        pln_arr_timest      TYPE /saptrx/paramname VALUE 'YN_SHP_PLN_AR_BUS_DATETIME',
        pln_arr_timezone    TYPE /saptrx/paramname VALUE 'YN_SHP_PLN_AR_BUS_TIMEZONE',
        stop_id             TYPE /saptrx/paramname VALUE 'YN_SHP_VP_STOP_ID',
        ordinal_no          TYPE /saptrx/paramname VALUE 'YN_SHP_VP_STOP_ORD_NO',
        loc_type            TYPE /saptrx/paramname VALUE 'YN_SHP_VP_STOP_LOC_TYPE',
        loc_id              TYPE /saptrx/paramname VALUE 'YN_SHP_VP_STOP_LOC_ID',
        tracked_object_id   TYPE /saptrx/paramname VALUE 'YN_SHP_TRACKED_RESOURCE_ID',
        tracked_object_type TYPE /saptrx/paramname VALUE 'YN_SHP_TRACKED_RESOURCE_VALUE',
        carrier_ref_type    TYPE /saptrx/paramname VALUE 'YN_SHP_CARRIER_REF_TYPE',
        carrier_ref_value   TYPE /saptrx/paramname VALUE 'YN_SHP_CARRIER_REF_VALUE',
        tu_type             TYPE /saptrx/paramname VALUE 'YN_SHP_TU_TYPE',
      END OF cs_mapping .
    CONSTANTS:
      BEGIN OF cs_tu_type,
        container_id   TYPE tv_tracked_object_type VALUE 'CONTAINER_ID',
        mobile_number  TYPE tv_tracked_object_type VALUE 'MOBILE_NUMBER',
        truck_id       TYPE tv_tracked_object_type VALUE 'TRUCK_ID',
        license_plate  TYPE tv_tracked_object_type VALUE 'LICENSE_PLATE',
        vessel         TYPE tv_tracked_object_type VALUE 'VESSEL',
        flight_number  TYPE tv_tracked_object_type VALUE 'FLIGHT_NUMBER',
        imo            TYPE tv_tracked_object_type VALUE 'IMO',
        package_id     TYPE tv_tracked_object_type VALUE 'PACKAGE_ID',
        package_ext_id TYPE tv_tracked_object_type VALUE 'PACKAGE_EXT_ID',
      END OF cs_tu_type .
    CONSTANTS:
      BEGIN OF cs_change_mode,
        update TYPE /bobf/conf_change_mode VALUE 'U',
        delete TYPE /bobf/conf_change_mode VALUE 'D',
      END OF cs_change_mode .
    CONSTANTS:
      BEGIN OF cs_obj_type,
        tms_tor TYPE /saptrx/trk_obj_type VALUE 'TMS_TOR',
      END OF cs_obj_type .
protected section.

  constants CS_BP_TYPE type BU_ID_TYPE value 'LBN001' ##NO_TEXT.
  data MV_APPSYS type /SAPTRX/APPLSYSTEM .
  data MV_AOTYPE type /SAPTRX/AOTYPE .
  data MT_AOTYPE type TT_AOTYPE .
  data:
    mt_trxserv TYPE TABLE OF /saptrx/trxserv .
  data MV_TOR_CAT type /SCMTMS/TOR_CATEGORY .

  methods PRE_CONDITION_CHECK
    importing
      !IS_ROOT type /SCMTMS/S_EM_BO_TOR_ROOT
    returning
      value(RV_RESULT) type SY-BINPT .
  methods STATUS_CHANGES_CHECK
    importing
      !IS_TOR_ROOT_BEFORE type /SCMTMS/S_EM_BO_TOR_ROOT
      !IS_TOR_ROOT type /SCMTMS/S_EM_BO_TOR_ROOT
    returning
      value(RV_RESULT) type ABAP_BOOL .
  methods DEL_CONDITION_CHECK
    importing
      !IS_ROOT type /SCMTMS/S_EM_BO_TOR_ROOT
    returning
      value(RV_RESULT) type SY-BINPT .
  methods GET_TU_NUMBER
    importing
      !IS_TOR_ROOT type /SCMTMS/S_EM_BO_TOR_ROOT
      !IT_TOR_ITEM type /SCMTMS/T_EM_BO_TOR_ITEM
      !IV_BEFORE_IMAGE type BOOLE_D default ABAP_FALSE
    exporting
      !ET_RESOURCE type TT_RESOURCE
    raising
      CX_UDM_MESSAGE .
  methods GET_CHANGED_TU
    importing
      !IS_TOR_ROOT type /SCMTMS/S_EM_BO_TOR_ROOT
      !IT_TOR_ITEM type /SCMTMS/T_EM_BO_TOR_ITEM
      !IS_TOR_ROOT_BEFORE type /SCMTMS/S_EM_BO_TOR_ROOT
      !IT_TOR_ITEM_BEFORE type /SCMTMS/T_EM_BO_TOR_ITEM
    exporting
      !ET_RESOURCE type TT_RESOURCE
    raising
      CX_UDM_MESSAGE .
  methods GET_DELETED_TU
    importing
      !IS_TOR_ROOT type /SCMTMS/S_EM_BO_TOR_ROOT
      !IT_TOR_ITEM type /SCMTMS/T_EM_BO_TOR_ITEM
      !IS_TOR_ROOT_BEFORE type /SCMTMS/S_EM_BO_TOR_ROOT
      !IT_TOR_ITEM_BEFORE type /SCMTMS/T_EM_BO_TOR_ITEM
    exporting
      !ET_RESOURCE type TT_RESOURCE
    raising
      CX_UDM_MESSAGE .
  methods GET_DATA
    importing
      !IS_TOR_ROOT type /SCMTMS/S_EM_BO_TOR_ROOT
      !IV_OLD_DATA type ABAP_BOOL default ABAP_FALSE
      !IV_TU_NO type /SCMTMS/PACKAGE_ID optional
    changing
      !CS_TU_INFO type TS_TU_HEADER
    raising
      CX_UDM_MESSAGE .
  methods GET_PLATE_TRUCK_NUMBER
    importing
      !IS_TOR_ROOT type /SCMTMS/S_EM_BO_TOR_ROOT
      !IT_TOR_ITEM type /SCMTMS/T_EM_BO_TOR_ITEM
      !IV_BEFORE_IMAGE type BOOLE_D default ABAP_FALSE
    exporting
      !ET_PLATE type TT_RESOURCE
      !ET_TRUCK_ID type TT_RESOURCE .
  methods GET_CONTAINER_MOBILE_ID
    importing
      !IS_TOR_ROOT type /SCMTMS/S_EM_BO_TOR_ROOT
      !IT_TOR_ITEM type /SCMTMS/T_EM_BO_TOR_ITEM
      !IV_BEFORE_IMAGE type BOOLE_D default ABAP_FALSE
    exporting
      !ET_CONTAINER type TT_RESOURCE
      !ET_MOBILE type TT_RESOURCE
    raising
      CX_UDM_MESSAGE .
  methods GET_VESSEL_ID
    importing
      !IS_TOR_ROOT type /SCMTMS/S_EM_BO_TOR_ROOT
      !IT_TOR_ITEM type /SCMTMS/T_EM_BO_TOR_ITEM
      !IV_BEFORE_IMAGE type BOOLE_D default ABAP_FALSE
    exporting
      !ET_RESOURCE type TT_RESOURCE
    raising
      CX_UDM_MESSAGE .
  methods GET_PACKAGE_ID
    importing
      !IS_TOR_ROOT type /SCMTMS/S_EM_BO_TOR_ROOT
      !IT_TOR_ITEM type /SCMTMS/T_EM_BO_TOR_ITEM
      !IV_BEFORE_IMAGE type BOOLE_D default ABAP_FALSE
    exporting
      !ET_PACKAGE_ID type TT_RESOURCE
      !ET_PACKAGE_ID_EXT type TT_RESOURCE
    raising
      CX_UDM_MESSAGE .
  methods FILL_IDOC_TRXSERV
    importing
      !IV_TOR_TYPE type /SCMTMS/TOR_TYPE
    changing
      !CS_IDOC_DATA type TS_IDOC_DATA .
  methods FILL_IDOC_APPOBJ_CTABS
    importing
      !IV_APPOBJID type /SAPTRX/AOID
      !IV_UPDATE_INDICATOR type /SAPTRX/UPDATE_INDICATOR optional
    changing
      !CS_IDOC_DATA type TS_IDOC_DATA .
  methods FILL_IDOC_CONTROL_DATA
    importing
      !IS_TOR_ROOT type /SCMTMS/S_EM_BO_TOR_ROOT
      !IV_APPOBJID type /SAPTRX/AOID
      !IS_RESOURCE type TS_RESOURCE
    changing
      !CS_IDOC_DATA type TS_IDOC_DATA
    raising
      CX_UDM_MESSAGE .
  methods FILL_IDOC_EXP_EVENT
    importing
      !IS_TOR_ROOT type /SCMTMS/S_EM_BO_TOR_ROOT
      !IV_TU_NO type /SCMTMS/PACKAGE_ID
      !IV_APPOBJID type /SAPTRX/AOID
    changing
      !CS_IDOC_DATA type TS_IDOC_DATA
    raising
      CX_UDM_MESSAGE .
  methods FILL_IDOC_TRACKING_ID
    importing
      !IV_APPOBJID type /SAPTRX/AOID
    changing
      !CS_IDOC_DATA type TS_IDOC_DATA
    raising
      CX_UDM_MESSAGE .
  methods PREPARE_IDOC_DATA
    importing
      !IS_ROOT type /SCMTMS/S_EM_BO_TOR_ROOT
      !IT_RESOURCE type TT_RESOURCE
    exporting
      !ET_IDOC_DATA type TT_IDOC_DATA
    raising
      CX_UDM_MESSAGE .
  methods SEND_IDOC_DATA
    importing
      !IT_IDOC_DATA type TT_IDOC_DATA
    exporting
      !ET_BAPIRET type BAPIRET2_T .
  methods SEND_IDOC_EHPOST01
    importing
      !IV_APPSYS type LOGSYS
      !IS_TRXSERV type /SAPTRX/TRXSERV
      !IT_APPOBJ_DTABS type TRXAS_APPOBJ_CTABS .
  methods SEND_IDOC_GTTMSG01
    importing
      !IV_APPSYS type LOGSYS
      !IS_TRXSERV type /SAPTRX/TRXSERV
      !IT_APPOBJ_DTABS type TRXAS_APPOBJ_CTABS .
  methods SEND_DELETION_IDOC_DATA
    importing
      !IT_IDOC_DATA type TT_IDOC_DATA .
  methods GET_SYS_APPSYS
    returning
      value(RV_APPSYS) type LOGSYS .
  methods GET_DATA_FROM_STOP
    importing
      !IS_TOR_ROOT type /SCMTMS/S_EM_BO_TOR_ROOT
      !IV_OLD_DATA type ABAP_BOOL default ABAP_FALSE
      !IV_TU_NO type /SCMTMS/PACKAGE_ID optional
    changing
      !CV_PLN_DEP_LOC_ID type /SCMTMS/S_EM_BO_TOR_STOP-LOG_LOCID
      !CV_PLN_DEP_LOC_TYPE type /SAPTRX/LOC_ID_TYPE
      !CV_PLN_DEP_TIMEST type CHAR16
      !CV_PLN_DEP_TIMEZONE type AD_TZONE
      !CV_PLN_ARR_LOC_ID type /SCMTMS/S_EM_BO_TOR_STOP-LOG_LOCID
      !CV_PLN_ARR_LOC_TYPE type /SAPTRX/LOC_ID_TYPE
      !CV_PLN_ARR_TIMEST type CHAR16
      !CV_PLN_ARR_TIMEZONE type AD_TZONE
      !CT_STOP_ID type TT_STOP_ID
      !CT_ORDINAL_NO type TT_ORDINAL_NO
      !CT_LOC_TYPE type TT_LOC_TYPE
      !CT_LOC_ID type TT_LOC_ID .
  methods GET_CARRIER_NAME
    importing
      !IV_TSPID type /SCMTMS/PTY_CARRIER
    returning
      value(RV_CARRIER) type BU_ID_NUMBER .
  methods GET_STOP_SEQ
    importing
      !IS_TOR_ROOT type /SCMTMS/S_EM_BO_TOR_ROOT
      !IV_OLD_DATA type ABAP_BOOL default ABAP_FALSE
      !IV_TU_NO type /SCMTMS/PACKAGE_ID optional
      !IT_STOP_SEQ type /SCMTMS/T_PLN_STOP_SEQ_D
    changing
      !CT_STOP_ID type TT_STOP_ID
      !CT_ORDINAL_NO type TT_ORDINAL_NO
      !CT_LOC_TYPE type TT_LOC_TYPE
      !CT_LOC_ID type TT_LOC_ID .
  methods GET_DATA_FOR_PLANNED_EVENT
    importing
      !IS_TOR_ROOT type /SCMTMS/S_EM_BO_TOR_ROOT
      !IV_TU_NO type /SCMTMS/PACKAGE_ID
    exporting
      !ET_STOP type /SCMTMS/T_EM_BO_TOR_STOP
      !ET_STOP_POINTS type ZIF_GTT_STS_EF_TYPES=>TT_STOP_POINTS
    raising
      CX_UDM_MESSAGE .
  methods GET_HEADER_DATA_FROM_STOP
    importing
      !IS_TOR_ROOT type /SCMTMS/S_EM_BO_TOR_ROOT
      !IV_OLD_DATA type ABAP_BOOL default ABAP_FALSE
      !IT_STOP_SEQ type /SCMTMS/T_PLN_STOP_SEQ_D
    changing
      !CV_PLN_DEP_LOC_ID type /SCMTMS/S_EM_BO_TOR_STOP-LOG_LOCID
      !CV_PLN_DEP_LOC_TYPE type /SAPTRX/LOC_ID_TYPE
      !CV_PLN_DEP_TIMEST type CHAR16
      !CV_PLN_DEP_TIMEZONE type AD_TZONE
      !CV_PLN_ARR_LOC_ID type /SCMTMS/S_EM_BO_TOR_STOP-LOG_LOCID
      !CV_PLN_ARR_LOC_TYPE type /SAPTRX/LOC_ID_TYPE
      !CV_PLN_ARR_TIMEST type CHAR16
      !CV_PLN_ARR_TIMEZONE type AD_TZONE .
  methods GET_DOCREF_DATA
    importing
      !IS_TOR_ROOT type /SCMTMS/S_EM_BO_TOR_ROOT
      !IV_OLD_DATA type ABAP_BOOL default ABAP_FALSE
    changing
      !CT_CARRIER_REF_VALUE type TT_CARRIER_REF_VALUE
      !CT_CARRIER_REF_TYPE type TT_CARRIER_REF_TYPE .
  methods ADD_STRUCT_TO_CONTROL_DATA
    importing
      !IR_BO_DATA type DATA
      !IV_APPOBJID type /SAPTRX/AOID
    changing
      value(CT_CONTROL_DATA) type /SAPTRX/BAPI_TRK_CONTROL_TAB
    raising
      CX_UDM_MESSAGE .
  methods ADD_SYS_ATTR_TO_CONTROL_DATA
    importing
      !IV_APPOBJID type /SAPTRX/AOID
    changing
      !CT_CONTROL_DATA type /SAPTRX/BAPI_TRK_CONTROL_TAB
    raising
      CX_UDM_MESSAGE .
  methods THROW_EXCEPTION
    importing
      !IV_TEXTID type SOTR_CONC optional
    raising
      CX_UDM_MESSAGE .
  methods LOAD_START
    importing
      !IS_TOR_ROOT type /SCMTMS/S_EM_BO_TOR_ROOT
      !IT_STOP type /SCMTMS/T_EM_BO_TOR_STOP
      !IT_STOP_POINTS type ZIF_GTT_STS_EF_TYPES=>TT_STOP_POINTS
      !IV_APPOBJID type /SAPTRX/AOID
    changing
      !CT_EXPEVENTDATA type ZIF_GTT_STS_EF_TYPES=>TT_EXPEVENTDATA
    raising
      CX_UDM_MESSAGE .
  methods LOAD_END
    importing
      !IS_TOR_ROOT type /SCMTMS/S_EM_BO_TOR_ROOT
      !IT_STOP type /SCMTMS/T_EM_BO_TOR_STOP
      !IT_STOP_POINTS type ZIF_GTT_STS_EF_TYPES=>TT_STOP_POINTS
      !IV_APPOBJID type /SAPTRX/AOID
    changing
      !CT_EXPEVENTDATA type ZIF_GTT_STS_EF_TYPES=>TT_EXPEVENTDATA
    raising
      CX_UDM_MESSAGE .
  methods POPU
    importing
      !IS_TOR_ROOT type /SCMTMS/S_EM_BO_TOR_ROOT
      !IT_STOP type /SCMTMS/T_EM_BO_TOR_STOP
      !IT_STOP_POINTS type ZIF_GTT_STS_EF_TYPES=>TT_STOP_POINTS
      !IV_APPOBJID type /SAPTRX/AOID
    changing
      !CT_EXPEVENTDATA type ZIF_GTT_STS_EF_TYPES=>TT_EXPEVENTDATA
    raising
      CX_UDM_MESSAGE .
  methods COUPLING
    importing
      !IS_TOR_ROOT type /SCMTMS/S_EM_BO_TOR_ROOT
      !IT_STOP type /SCMTMS/T_EM_BO_TOR_STOP
      !IT_STOP_POINTS type ZIF_GTT_STS_EF_TYPES=>TT_STOP_POINTS
      !IV_APPOBJID type /SAPTRX/AOID
    changing
      !CT_EXPEVENTDATA type ZIF_GTT_STS_EF_TYPES=>TT_EXPEVENTDATA
    raising
      CX_UDM_MESSAGE .
  methods SHP_DEPARTURE
    importing
      !IS_TOR_ROOT type /SCMTMS/S_EM_BO_TOR_ROOT
      !IT_STOP type /SCMTMS/T_EM_BO_TOR_STOP
      !IT_STOP_POINTS type ZIF_GTT_STS_EF_TYPES=>TT_STOP_POINTS
      !IV_APPOBJID type /SAPTRX/AOID
    changing
      !CT_EXPEVENTDATA type ZIF_GTT_STS_EF_TYPES=>TT_EXPEVENTDATA
    raising
      CX_UDM_MESSAGE .
  methods SHP_ARRIVAL
    importing
      !IS_TOR_ROOT type /SCMTMS/S_EM_BO_TOR_ROOT
      !IT_STOP type /SCMTMS/T_EM_BO_TOR_STOP
      !IT_STOP_POINTS type ZIF_GTT_STS_EF_TYPES=>TT_STOP_POINTS
      !IV_APPOBJID type /SAPTRX/AOID
    changing
      !CT_EXPEVENTDATA type ZIF_GTT_STS_EF_TYPES=>TT_EXPEVENTDATA
    raising
      CX_UDM_MESSAGE .
  methods DECOUPLING
    importing
      !IS_TOR_ROOT type /SCMTMS/S_EM_BO_TOR_ROOT
      !IT_STOP type /SCMTMS/T_EM_BO_TOR_STOP
      !IT_STOP_POINTS type ZIF_GTT_STS_EF_TYPES=>TT_STOP_POINTS
      !IV_APPOBJID type /SAPTRX/AOID
    changing
      !CT_EXPEVENTDATA type ZIF_GTT_STS_EF_TYPES=>TT_EXPEVENTDATA
    raising
      CX_UDM_MESSAGE .
  methods UNLOAD_START
    importing
      !IS_TOR_ROOT type /SCMTMS/S_EM_BO_TOR_ROOT
      !IT_STOP type /SCMTMS/T_EM_BO_TOR_STOP
      !IT_STOP_POINTS type ZIF_GTT_STS_EF_TYPES=>TT_STOP_POINTS
      !IV_APPOBJID type /SAPTRX/AOID
    changing
      !CT_EXPEVENTDATA type ZIF_GTT_STS_EF_TYPES=>TT_EXPEVENTDATA
    raising
      CX_UDM_MESSAGE .
  methods UNLOAD_END
    importing
      !IS_TOR_ROOT type /SCMTMS/S_EM_BO_TOR_ROOT
      !IT_STOP type /SCMTMS/T_EM_BO_TOR_STOP
      !IT_STOP_POINTS type ZIF_GTT_STS_EF_TYPES=>TT_STOP_POINTS
      !IV_APPOBJID type /SAPTRX/AOID
    changing
      !CT_EXPEVENTDATA type ZIF_GTT_STS_EF_TYPES=>TT_EXPEVENTDATA
    raising
      CX_UDM_MESSAGE .
  methods POD
    importing
      !IS_TOR_ROOT type /SCMTMS/S_EM_BO_TOR_ROOT
      !IT_STOP type /SCMTMS/T_EM_BO_TOR_STOP
      !IT_STOP_POINTS type ZIF_GTT_STS_EF_TYPES=>TT_STOP_POINTS
      !IV_APPOBJID type /SAPTRX/AOID
    changing
      !CT_EXPEVENTDATA type ZIF_GTT_STS_EF_TYPES=>TT_EXPEVENTDATA
    raising
      CX_UDM_MESSAGE .
private section.

  constants CV_IDOC_TYPE_EHPOST01 type EDI_IDOCTP value 'AOPOST' ##NO_TEXT.
  constants CV_MSG_TYPE_AOPOST type EDI_MESTYP value 'AOPOST' ##NO_TEXT.
  constants CV_PARTNER_TYPE type EDI_RCVPRT value 'LS' ##NO_TEXT.
  constants CV_SEG_E1EHPAO type EDILSEGTYP value 'E1EHPAO' ##NO_TEXT.
  constants CV_SEG_E1EHPTID type EDILSEGTYP value 'E1EHPTID' ##NO_TEXT.
  constants CV_STRUCTURE_PKG type DEVCLASS value '/SAPTRX/SCEM_AI_R3' ##NO_TEXT.
  constants CV_MSG_TYPE_GTTMSG type EDI_MESTYP value 'GTTMSG' ##NO_TEXT.
  constants CV_IDOC_TYPE_GTTMSG01 type EDI_IDOCTP value 'GTTMSG' ##NO_TEXT.
ENDCLASS.



CLASS ZCL_GTT_STS_TRK_TU_BASE IMPLEMENTATION.


  METHOD add_struct_to_control_data.


    DATA: lt_fields       TYPE cl_abap_structdescr=>component_table,
          ls_control_data TYPE zif_gtt_sts_ef_types=>ts_control_data,
          lr_mapping      TYPE REF TO data,
          lv_dummy        TYPE char100 ##needed.

    FIELD-SYMBOLS: <ls_bo_data>   TYPE any,
                   <ls_mapping>   TYPE any,
                   <lt_value>     TYPE ANY TABLE,
                   <lv_value>     TYPE any,
                   <lv_paramname> TYPE any.

    ASSIGN ir_bo_data->* TO <ls_bo_data>.

    IF <ls_bo_data> IS ASSIGNED.
      " get fields list of the structure, which provided by reader class
      lt_fields = CAST cl_abap_structdescr(
                    cl_abap_typedescr=>describe_by_data(
                      p_data = <ls_bo_data> )
                  )->get_components( ).

      " assign mapping table to use it in converting of field names into external format
      lr_mapping  = REF #( cs_mapping ).
      ASSIGN lr_mapping->* TO <ls_mapping>.

      IF <ls_mapping> IS ASSIGNED.
        " fill generic parameters
        ls_control_data-appsys      = mv_appsys.
        ls_control_data-appobjtype  = mv_aotype.
        ls_control_data-language    = sy-langu.
        ls_control_data-appobjid    = iv_appobjid.

        " walk around fields list and copy values one by one
        LOOP AT lt_fields ASSIGNING FIELD-SYMBOL(<ls_fields>).
          ASSIGN COMPONENT <ls_fields>-name OF STRUCTURE <ls_bo_data> TO <lv_value>.
          ASSIGN COMPONENT <ls_fields>-name OF STRUCTURE <ls_mapping> TO <lv_paramname>.

          CLEAR: ls_control_data-paramindex,
                 ls_control_data-value.

          IF <lv_value> IS ASSIGNED AND <lv_paramname> IS ASSIGNED.
            ls_control_data-paramname = <lv_paramname>.

            " simple copy for usual values
            IF zcl_gtt_sts_tools=>is_table( iv_value = <lv_value> ) = abap_false.

              IF <lv_value> IS NOT INITIAL.
                ls_control_data-value = zcl_gtt_sts_tools=>get_pretty_value( iv_value = <lv_value> ).
              ENDIF.

              APPEND ls_control_data TO ct_control_data.

              " cycled copy for table values
            ELSE.
              ASSIGN <lv_value> TO <lt_value>.

              LOOP AT <lt_value> ASSIGNING <lv_value>.
                ls_control_data-paramindex += 1.
                IF <lv_value> IS NOT INITIAL.
                  ls_control_data-value = zcl_gtt_sts_tools=>get_pretty_value(
                    iv_value = <lv_value> ).
                ENDIF.
                APPEND ls_control_data TO ct_control_data.
                CLEAR: ls_control_data-value.
              ENDLOOP.
            ENDIF.
          ELSEIF <lv_value> IS NOT ASSIGNED.
            MESSAGE e010(zgtt_sts) INTO lv_dummy.
            zcl_gtt_sts_tools=>throw_exception( ).
          ELSE.
            MESSAGE e010(zgtt_sts) INTO lv_dummy.
            zcl_gtt_sts_tools=>throw_exception( ).
          ENDIF.
        ENDLOOP.
      ELSE.
        MESSAGE e010(zgtt_sts) INTO lv_dummy.
        zcl_gtt_sts_tools=>throw_exception( ).
      ENDIF.
    ELSE.
      MESSAGE e010(zgtt_sts) INTO lv_dummy.
      zcl_gtt_sts_tools=>throw_exception( ).
    ENDIF.


  ENDMETHOD.


  METHOD add_sys_attr_to_control_data.

    DATA ls_control_data TYPE /saptrx/bapi_trk_control_data.

    ls_control_data-appsys     = mv_appsys.
    ls_control_data-appobjtype = mv_aotype.
    ls_control_data-language   = sy-langu.
    ls_control_data-appobjid   = iv_appobjid.

    ls_control_data-paramname  = zif_gtt_sts_ef_constants=>cs_system_fields-actual_bisiness_timezone.
    ls_control_data-value      = zcl_gtt_sts_tools=>get_system_time_zone( ).
    APPEND ls_control_data TO ct_control_data.

    ls_control_data-paramname  = zif_gtt_sts_ef_constants=>cs_system_fields-actual_bisiness_datetime.
    ls_control_data-value      = zcl_gtt_sts_tools=>get_system_date_time( ).
    APPEND ls_control_data TO ct_control_data.

    ls_control_data-paramname  = zif_gtt_sts_ef_constants=>cs_system_fields-actual_technical_timezone.
    ls_control_data-value      = zcl_gtt_sts_tools=>get_system_time_zone( ).
    APPEND ls_control_data TO ct_control_data.

    ls_control_data-paramname  = zif_gtt_sts_ef_constants=>cs_system_fields-actual_technical_datetime.
    ls_control_data-value      = zcl_gtt_sts_tools=>get_system_date_time( ).
    APPEND ls_control_data TO ct_control_data.

    ls_control_data-paramname  = zif_gtt_sts_ef_constants=>cs_system_fields-reported_by.
    ls_control_data-value      = sy-uname.
    APPEND ls_control_data TO ct_control_data.

  ENDMETHOD.


  METHOD coupling.

    DATA:
      lt_loc_root TYPE /scmtms/t_bo_loc_root_k.

    LOOP AT it_stop USING KEY parent_seqnum ASSIGNING FIELD-SYMBOL(<ls_stop>) WHERE parent_node_id = is_tor_root-node_id.
      CHECK <ls_stop>-stop_cat = /scmtms/if_common_c=>c_stop_category-outbound AND
            <ls_stop>-aggr_assgn_start_c IS NOT INITIAL AND
            <ls_stop>-aggr_assgn_end_c   IS NOT INITIAL.

      READ TABLE it_stop_points REFERENCE INTO DATA(ls_stop_points)
                                     WITH KEY log_locid = <ls_stop>-log_locid
                                              seq_num   = <ls_stop>-seq_num.
      CHECK sy-subrc = 0.

      TEST-SEAM coupling_lt_loc_root.
        /scmtms/cl_pln_bo_data=>get_loc_data(
          EXPORTING
            it_key      = VALUE #( ( key = <ls_stop>-log_loc_uuid ) )
          CHANGING
            ct_loc_root = lt_loc_root ).
      END-TEST-SEAM.

      READ TABLE lt_loc_root REFERENCE INTO DATA(ls_loc_root)
                                     WITH KEY key COMPONENTS key = <ls_stop>-log_loc_uuid.
      CHECK sy-subrc = 0.

      DATA(lv_tz) = COND tznzone( WHEN ls_loc_root->time_zone_code IS NOT INITIAL
                                  THEN ls_loc_root->time_zone_code
                                  ELSE sy-zonlo ).

      DATA(lv_exp_datetime)    = <ls_stop>-aggr_assgn_end_c.
      DATA(lv_er_exp_datetime) = <ls_stop>-aggr_assgn_start_c.

      zcl_gtt_sts_tools=>convert_utc_timestamp(
        EXPORTING
          iv_timezone  = lv_tz
        CHANGING
          cv_timestamp = lv_exp_datetime ).

      zcl_gtt_sts_tools=>convert_utc_timestamp(
        EXPORTING
          iv_timezone  = lv_tz
        CHANGING
          cv_timestamp = lv_er_exp_datetime ).

      APPEND VALUE #(
      appsys               = mv_appsys
      appobjtype           = mv_aotype
      language             = sy-langu
      appobjid             = iv_appobjid
      milestone            = zif_gtt_sts_constants=>cs_milestone-fo_coupling
      evt_exp_datetime     = |0{ lv_exp_datetime }|
      evt_er_exp_dtime     = |0{ lv_er_exp_datetime }|
      evt_exp_tzone        = lv_tz
      locid1               = <ls_stop>-log_locid
      locid2               = ls_stop_points->stop_id
      loctype              = zcl_gtt_sts_tools=>get_location_type( iv_locno = <ls_stop>-log_locid ) ) TO ct_expeventdata.

      CLEAR: lt_loc_root, ls_loc_root.
    ENDLOOP.


  ENDMETHOD.


  METHOD decoupling.

    DATA: lt_loc_root TYPE /scmtms/t_bo_loc_root_k.

    LOOP AT it_stop USING KEY parent_seqnum ASSIGNING FIELD-SYMBOL(<ls_stop>) WHERE parent_node_id = is_tor_root-node_id.
      CHECK <ls_stop>-stop_cat = /scmtms/if_common_c=>c_stop_category-inbound AND
            <ls_stop>-aggr_assgn_start_c IS NOT INITIAL AND
            <ls_stop>-aggr_assgn_end_c   IS NOT INITIAL.

      READ TABLE it_stop_points REFERENCE INTO DATA(ls_stop_points)
                                     WITH KEY log_locid = <ls_stop>-log_locid
                                              seq_num   = <ls_stop>-seq_num.
      CHECK sy-subrc = 0.

      TEST-SEAM decoupling_lt_loc_root.
        /scmtms/cl_pln_bo_data=>get_loc_data(
          EXPORTING
            it_key      = VALUE #( ( key = <ls_stop>-log_loc_uuid ) )
          CHANGING
            ct_loc_root = lt_loc_root ).
      END-TEST-SEAM.

      READ TABLE lt_loc_root REFERENCE INTO DATA(ls_loc_root)
                                     WITH KEY key COMPONENTS key = <ls_stop>-log_loc_uuid.
      CHECK sy-subrc = 0.

      DATA(lv_tz) = COND tznzone( WHEN ls_loc_root->time_zone_code IS NOT INITIAL
                                  THEN ls_loc_root->time_zone_code
                                  ELSE sy-zonlo ).

      DATA(lv_exp_datetime)    = <ls_stop>-aggr_assgn_end_c.
      DATA(lv_er_exp_datetime) = <ls_stop>-aggr_assgn_start_c.

      zcl_gtt_sts_tools=>convert_utc_timestamp(
        EXPORTING
          iv_timezone  = lv_tz
        CHANGING
          cv_timestamp = lv_exp_datetime ).

      zcl_gtt_sts_tools=>convert_utc_timestamp(
        EXPORTING
          iv_timezone  = lv_tz
        CHANGING
          cv_timestamp = lv_er_exp_datetime ).

      APPEND VALUE #(
      appsys               = mv_appsys
      appobjtype           = mv_aotype
      language             = sy-langu
      appobjid             = iv_appobjid
      milestone            = zif_gtt_sts_constants=>cs_milestone-fo_decoupling
      evt_exp_datetime     = |0{ lv_exp_datetime }|
      evt_er_exp_dtime     = |0{ lv_er_exp_datetime }|
      evt_exp_tzone        = lv_tz
      locid1               = <ls_stop>-log_locid
      locid2               = ls_stop_points->stop_id
      loctype              = zcl_gtt_sts_tools=>get_location_type( iv_locno = <ls_stop>-log_locid ) ) TO ct_expeventdata.

      CLEAR: lt_loc_root, ls_loc_root.
    ENDLOOP.


  ENDMETHOD.


  METHOD fill_idoc_appobj_ctabs.

    cs_idoc_data-appobj_ctabs = VALUE #( BASE cs_idoc_data-appobj_ctabs (
      trxservername    = cs_idoc_data-trxserv-trx_server_id
      appobjtype       = mv_aotype
      appobjid         = iv_appobjid
      update_indicator = iv_update_indicator ) ).

  ENDMETHOD.


  METHOD fill_idoc_control_data.

    DATA:
      lt_control_data TYPE /saptrx/bapi_trk_control_tab,
      ls_tu_info      TYPE ts_tu_header,
      lv_old_data     TYPE abap_bool,
      lt_resource     TYPE tt_resource,
      rr_data         TYPE REF TO data.

    get_data(
      EXPORTING
        is_tor_root = is_tor_root
        iv_tu_no    = is_resource-orginal_value
      CHANGING
        cs_tu_info  = ls_tu_info ).

    ls_tu_info-tu_no = is_resource-orginal_value.

*   trackedObjects
    APPEND is_resource-category TO ls_tu_info-tracked_object_id.
    APPEND is_resource-orginal_value TO ls_tu_info-tracked_object_type .

    IF ls_tu_info-tracked_object_id IS INITIAL.
      APPEND '' TO ls_tu_info-tracked_object_id.
    ENDIF.

*   TU type
    ls_tu_info-tu_type = is_resource-category.

    rr_data = REF #( ls_tu_info ).

    add_struct_to_control_data(
      EXPORTING
        ir_bo_data      = rr_data
        iv_appobjid     = iv_appobjid
      CHANGING
        ct_control_data = lt_control_data ).

    add_sys_attr_to_control_data(
      EXPORTING
        iv_appobjid     = iv_appobjid
      CHANGING
        ct_control_data = lt_control_data ).

    cs_idoc_data-control = lt_control_data.

  ENDMETHOD.


  METHOD fill_idoc_exp_event.

    DATA:
      lt_stop             TYPE /scmtms/t_em_bo_tor_stop,
      lt_stop_points      TYPE zif_gtt_sts_ef_types=>tt_stop_points,
      lt_expeventdata     TYPE /saptrx/bapi_trk_ee_tab,
      lv_counter          TYPE /saptrx/seq_num,
      ls_previous_line    TYPE /saptrx/exp_events,
      lv_shp_num_previous TYPE /saptrx/loc_id_2,
      lv_shp_num          TYPE /saptrx/loc_id_2,
      lv_length           TYPE i.

    get_data_for_planned_event(
      EXPORTING
        is_tor_root    = is_tor_root
        iv_tu_no       = iv_tu_no
      IMPORTING
        et_stop        = lt_stop
        et_stop_points = lt_stop_points ).

    shp_arrival(
      EXPORTING
        is_tor_root     = is_tor_root
        it_stop         = lt_stop
        it_stop_points  = lt_stop_points
        iv_appobjid     = iv_appobjid
      CHANGING
        ct_expeventdata = lt_expeventdata ).

    decoupling(
      EXPORTING
        is_tor_root     = is_tor_root
        it_stop         = lt_stop
        it_stop_points  = lt_stop_points
        iv_appobjid     = iv_appobjid
      CHANGING
        ct_expeventdata = lt_expeventdata ).

    unload_start(
      EXPORTING
        is_tor_root     = is_tor_root
        it_stop         = lt_stop
        it_stop_points  = lt_stop_points
        iv_appobjid     = iv_appobjid
      CHANGING
        ct_expeventdata = lt_expeventdata ).

    unload_end(
      EXPORTING
        is_tor_root     = is_tor_root
        it_stop         = lt_stop
        it_stop_points  = lt_stop_points
        iv_appobjid     = iv_appobjid
      CHANGING
        ct_expeventdata = lt_expeventdata ).

    pod(
      EXPORTING
        is_tor_root     = is_tor_root
        it_stop         = lt_stop
        it_stop_points  = lt_stop_points
        iv_appobjid     = iv_appobjid
      CHANGING
        ct_expeventdata = lt_expeventdata ).

    load_start(
      EXPORTING
        is_tor_root     = is_tor_root
        it_stop         = lt_stop
        it_stop_points  = lt_stop_points
        iv_appobjid     = iv_appobjid
      CHANGING
        ct_expeventdata = lt_expeventdata ).

    load_end(
      EXPORTING
        is_tor_root     = is_tor_root
        it_stop         = lt_stop
        it_stop_points  = lt_stop_points
        iv_appobjid     = iv_appobjid
      CHANGING
        ct_expeventdata = lt_expeventdata ).

    popu(
      EXPORTING
        is_tor_root     = is_tor_root
        it_stop         = lt_stop
        it_stop_points  = lt_stop_points
        iv_appobjid     = iv_appobjid
      CHANGING
        ct_expeventdata = lt_expeventdata ).

    coupling(
      EXPORTING
        is_tor_root     = is_tor_root
        it_stop         = lt_stop
        it_stop_points  = lt_stop_points
        iv_appobjid     = iv_appobjid
      CHANGING
        ct_expeventdata = lt_expeventdata ).

    shp_departure(
      EXPORTING
        is_tor_root     = is_tor_root
        it_stop         = lt_stop
        it_stop_points  = lt_stop_points
        iv_appobjid     = iv_appobjid
      CHANGING
        ct_expeventdata = lt_expeventdata ).

    SORT lt_expeventdata BY locid2 ASCENDING.

    LOOP AT lt_expeventdata ASSIGNING FIELD-SYMBOL(<ls_expeventdata>)
         GROUP BY <ls_expeventdata>-locid2 ASSIGNING FIELD-SYMBOL(<lt_expeventdata_group>).

      lv_counter = 1.
      DATA(lv_first) = abap_true.
      LOOP AT GROUP <lt_expeventdata_group> ASSIGNING FIELD-SYMBOL(<ls_expeventdata_group>).
        IF lv_counter = 1.
          IF line_exists( lt_expeventdata[ sy-tabix - 1 ] ).
            ls_previous_line =  lt_expeventdata[ sy-tabix - 1 ].
            lv_length = strlen( ls_previous_line-locid2 ) - 4.
            lv_shp_num_previous = ls_previous_line-locid2+0(lv_length).

            lv_length = strlen( <ls_expeventdata_group>-locid2 ) - 4.
            lv_shp_num = <ls_expeventdata_group>-locid2+0(lv_length).
            IF lv_shp_num = lv_shp_num_previous.
              lv_counter = lt_expeventdata[ sy-tabix - 1 ]-milestonenum + 1.
            ENDIF.

            CLEAR:
              ls_previous_line,
              lv_length,
              lv_shp_num_previous,
              lv_shp_num.
          ENDIF.
        ENDIF.
        <ls_expeventdata_group>-milestonenum = lv_counter.
        lv_counter += 1.

      ENDLOOP.
    ENDLOOP.

    cs_idoc_data-exp_event = lt_expeventdata.

  ENDMETHOD.


  METHOD fill_idoc_tracking_id.

    cs_idoc_data-tracking_id = VALUE #( BASE cs_idoc_data-tracking_id (
     appsys      = mv_appsys
     appobjtype  = mv_aotype
     appobjid    = iv_appobjid
     trxcod      = zif_gtt_sts_constants=>cs_trxcod-tu_number
     trxid       = iv_appobjid ) ).

  ENDMETHOD.


  METHOD fill_idoc_trxserv.

    READ TABLE mt_aotype INTO DATA(ls_aotype)
      WITH KEY tor_type = iv_tor_type.
    IF sy-subrc = 0.
      READ TABLE mt_trxserv INTO DATA(ls_trxserv)
        WITH KEY trx_server_id = ls_aotype-server_name.
      IF sy-subrc = 0.
        cs_idoc_data-trxserv = ls_trxserv.
      ENDIF.
    ENDIF.

  ENDMETHOD.


  METHOD get_carrier_name.

    CONSTANTS lc_lbn TYPE char4 VALUE 'LBN#'.

    SELECT SINGLE idnumber
      FROM but0id
      INTO @DATA(lv_idnumber)
      WHERE partner = @iv_tspid AND
            type    = @cs_bp_type ##WARN_OK.
    IF sy-subrc = 0.
      rv_carrier = lc_lbn && lv_idnumber.
    ENDIF.

  ENDMETHOD.


  METHOD get_changed_tu.

    DATA:
      lt_current_resource TYPE tt_resource.

    get_tu_number(
      EXPORTING
        is_tor_root = is_tor_root
        it_tor_item = it_tor_item
      IMPORTING
        et_resource = lt_current_resource ).

    LOOP AT lt_current_resource ASSIGNING FIELD-SYMBOL(<fs_current_resource>).
      <fs_current_resource>-change_mode = cs_change_mode-update.
    ENDLOOP.

    SORT lt_current_resource BY category orginal_value value change_mode tor_id.
    DELETE ADJACENT DUPLICATES FROM lt_current_resource COMPARING ALL FIELDS.

    et_resource = lt_current_resource.

  ENDMETHOD.


  METHOD get_data.

    DATA:
      ls_tu_info TYPE ts_tu_header,
      lt_capa    TYPE /scmtms/t_em_bo_tor_root.

    CASE mv_tor_cat.
      WHEN /scmtms/if_tor_const=>sc_tor_category-active OR
           /scmtms/if_tor_const=>sc_tor_category-booking.
        ls_tu_info-tspid = get_carrier_name( iv_tspid = is_tor_root-tspid ).
        ls_tu_info-trmodcod = zcl_gtt_sts_tools=>get_trmodcod( iv_trmodcod = is_tor_root-trmodcod ).
        ls_tu_info-shipping_type  = is_tor_root-shipping_type.

      WHEN /scmtms/if_tor_const=>sc_tor_category-freight_unit OR
           /scmtms/if_tor_const=>sc_tor_category-transp_unit.

        zcl_gtt_sts_tools=>get_capa_info(
          EXPORTING
            ir_root     = REF #( is_tor_root )
            iv_old_data = iv_old_data
          IMPORTING
            et_capa     = lt_capa ).

        LOOP AT lt_capa ASSIGNING FIELD-SYMBOL(<fs_capa>).
          IF ( <fs_capa>-track_exec_rel = zif_gtt_sts_constants=>cs_track_exec_rel-execution OR
              <fs_capa>-track_exec_rel = zif_gtt_sts_constants=>cs_track_exec_rel-exec_with_extern_event_mngr ) AND
            <fs_capa>-lifecycle = zif_gtt_sts_constants=>cs_lifecycle_status-in_process AND
            ( <fs_capa>-execution = zif_gtt_sts_constants=>cs_execution_status-in_execution OR
              <fs_capa>-execution = zif_gtt_sts_constants=>cs_execution_status-ready_for_transp_exec ) AND
            <fs_capa>-tspid IS NOT INITIAL.

            ls_tu_info-tspid = get_carrier_name( iv_tspid = <fs_capa>-tspid ).
            ls_tu_info-trmodcod = zcl_gtt_sts_tools=>get_trmodcod( iv_trmodcod = <fs_capa>-trmodcod ).
            ls_tu_info-shipping_type  = <fs_capa>-shipping_type.
            EXIT.
          ENDIF.
        ENDLOOP.

      WHEN OTHERS.

    ENDCASE.

    get_data_from_stop(
      EXPORTING
        is_tor_root         = is_tor_root
        iv_old_data         = iv_old_data
        iv_tu_no            = iv_tu_no
      CHANGING
        cv_pln_dep_loc_id   = ls_tu_info-pln_dep_loc_id
        cv_pln_dep_loc_type = ls_tu_info-pln_dep_loc_type
        cv_pln_dep_timest   = ls_tu_info-pln_dep_timest
        cv_pln_dep_timezone = ls_tu_info-pln_dep_timezone
        cv_pln_arr_loc_id   = ls_tu_info-pln_arr_loc_id
        cv_pln_arr_loc_type = ls_tu_info-pln_arr_loc_type
        cv_pln_arr_timest   = ls_tu_info-pln_arr_timest
        cv_pln_arr_timezone = ls_tu_info-pln_arr_timezone
        ct_stop_id          = ls_tu_info-stop_id
        ct_ordinal_no       = ls_tu_info-ordinal_no
        ct_loc_type         = ls_tu_info-loc_type
        ct_loc_id           = ls_tu_info-loc_id ).

    get_docref_data(
      EXPORTING
        is_tor_root          = is_tor_root
        iv_old_data          = iv_old_data
      CHANGING
        ct_carrier_ref_value = ls_tu_info-carrier_ref_value
        ct_carrier_ref_type  = ls_tu_info-carrier_ref_type ).

    MOVE-CORRESPONDING ls_tu_info TO cs_tu_info.

  ENDMETHOD.


  METHOD get_data_for_planned_event.

    DATA:
      lv_tor_node_id TYPE /scmtms/bo_node_id,
      lv_tor_id      TYPE /scmtms/tor_id,
      lv_order(4)    TYPE n VALUE '0001',
      lv_tmp_value   type char255.

    lv_tor_id   = is_tor_root-tor_id.
    lv_tor_node_id =  is_tor_root-node_id.

    SHIFT lv_tor_id LEFT DELETING LEADING '0'.

    /scmtms/cl_tor_helper_stop=>get_stop_sequence(
      EXPORTING
        it_root_key     = VALUE #( ( key = lv_tor_node_id ) )
        iv_before_image = abap_false
      IMPORTING
        et_stop_seq_d   = DATA(lt_stop_seq) ).

    ASSIGN lt_stop_seq[ root_key = lv_tor_node_id ] TO FIELD-SYMBOL(<ls_stop_seq>) ##WARN_OK.
    IF sy-subrc = 0.
      MOVE-CORRESPONDING <ls_stop_seq>-stop_seq TO et_stop.
      LOOP AT et_stop ASSIGNING FIELD-SYMBOL(<ls_stop>).
        <ls_stop>-parent_node_id = lv_tor_node_id.
        ASSIGN <ls_stop_seq>-stop_map[ tabix = <ls_stop>-seq_num ]-stop_key TO FIELD-SYMBOL(<lv_stop_key>).
        CHECK sy-subrc = 0.
        <ls_stop>-node_id = <lv_stop_key>.
      ENDLOOP.
    ENDIF.

    LOOP AT et_stop USING KEY parent_seqnum ASSIGNING <ls_stop>.
      IF NOT zcl_gtt_sts_tools=>is_odd( <ls_stop>-seq_num ).
        lv_order += 1.
      ENDIF.
      lv_tmp_value = |{ lv_tor_id }{ iv_tu_no }{ lv_order }|.
      CONDENSE lv_tmp_value.
      APPEND VALUE #( stop_id   = lv_tmp_value
                      log_locid = <ls_stop>-log_locid
                      seq_num   = <ls_stop>-seq_num ) TO et_stop_points.
      CLEAR lv_tmp_value.
    ENDLOOP.

  ENDMETHOD.


  METHOD get_data_from_stop.

    /scmtms/cl_tor_helper_stop=>get_stop_sequence(
      EXPORTING
        it_root_key     = VALUE #( ( key = is_tor_root-node_id ) )
        iv_before_image = SWITCH #( iv_old_data WHEN abap_true THEN abap_true ELSE abap_false )
      IMPORTING
        et_stop_seq_d   = DATA(lt_stop_seq) ).

    get_stop_seq(
      EXPORTING
        is_tor_root   = is_tor_root
        iv_old_data   = iv_old_data
        iv_tu_no      = iv_tu_no
        it_stop_seq   = lt_stop_seq
      CHANGING
        ct_stop_id    = ct_stop_id
        ct_ordinal_no = ct_ordinal_no
        ct_loc_type   = ct_loc_type
        ct_loc_id     = ct_loc_id ).

    get_header_data_from_stop(
      EXPORTING
        is_tor_root         = is_tor_root
        iv_old_data         = iv_old_data
        it_stop_seq         = lt_stop_seq
      CHANGING
        cv_pln_dep_loc_id   = cv_pln_dep_loc_id
        cv_pln_dep_loc_type = cv_pln_dep_loc_type
        cv_pln_dep_timest   = cv_pln_dep_timest
        cv_pln_dep_timezone = cv_pln_dep_timezone
        cv_pln_arr_loc_id   = cv_pln_arr_loc_id
        cv_pln_arr_loc_type = cv_pln_arr_loc_type
        cv_pln_arr_timest   = cv_pln_arr_timest
        cv_pln_arr_timezone = cv_pln_arr_timezone ).

  ENDMETHOD.


  METHOD get_docref_data.

    DATA lt_docs TYPE /scmtms/t_tor_docref_k.

    /bobf/cl_tra_serv_mgr_factory=>get_service_manager(
          /scmtms/if_tor_c=>sc_bo_key )->retrieve_by_association(
          EXPORTING
            iv_node_key    = /scmtms/if_tor_c=>sc_node-root
            it_key         = VALUE #( ( key = is_tor_root-node_id ) )
            iv_association = /scmtms/if_tor_c=>sc_association-root-docreference
            iv_fill_data   = abap_true
            iv_before_image = SWITCH #( iv_old_data WHEN abap_true THEN abap_true
                                                    ELSE abap_false )
          IMPORTING
            et_data        = lt_docs ).

    LOOP AT lt_docs ASSIGNING FIELD-SYMBOL(<ls_docs>).
      SHIFT  <ls_docs>-btd_id LEFT DELETING LEADING '0'.
      IF <ls_docs>-btd_tco = zif_gtt_sts_constants=>cs_btd_type_code-bill_of_landing        OR
         <ls_docs>-btd_tco = zif_gtt_sts_constants=>cs_btd_type_code-master_bill_of_landing OR
         <ls_docs>-btd_tco = zif_gtt_sts_constants=>cs_btd_type_code-master_air_waybill     OR
         <ls_docs>-btd_tco = zif_gtt_sts_constants=>cs_btd_type_code-carrier_assigned.
        APPEND <ls_docs>-btd_id  TO ct_carrier_ref_value.
        APPEND <ls_docs>-btd_tco TO ct_carrier_ref_type.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.


  METHOD get_header_data_from_stop.

    ASSIGN it_stop_seq[ 1 ] TO FIELD-SYMBOL(<ls_stop_seq>).
    IF sy-subrc = 0.
      ASSIGN <ls_stop_seq>-stop_seq[ 1 ] TO FIELD-SYMBOL(<ls_stop_first>).
      IF sy-subrc = 0.
        IF <ls_stop_first>-log_locid IS NOT INITIAL.
          cv_pln_dep_loc_id   = <ls_stop_first>-log_locid.
          cv_pln_dep_loc_type = zcl_gtt_sts_tools=>get_location_type( iv_locno = <ls_stop_first>-log_locid ).
        ENDIF.
        cv_pln_dep_timest   = COND #( WHEN <ls_stop_first>-plan_trans_time IS NOT INITIAL
                                        THEN |0{ <ls_stop_first>-plan_trans_time }| ELSE '' ).
        cv_pln_dep_timezone = /scmtms/cl_common_helper=>loc_key_get_timezone( iv_loc_key = <ls_stop_first>-log_loc_uuid ).
      ENDIF.
      ASSIGN <ls_stop_seq>-stop_seq[ lines( <ls_stop_seq>-stop_seq ) ] TO FIELD-SYMBOL(<ls_stop_last>).
      IF sy-subrc = 0.
        IF <ls_stop_last>-log_locid IS NOT INITIAL.
          cv_pln_arr_loc_id   = <ls_stop_last>-log_locid.
          cv_pln_arr_loc_type = zcl_gtt_sts_tools=>get_location_type( iv_locno = <ls_stop_last>-log_locid ).
        ENDIF.
        cv_pln_arr_timest   = COND #( WHEN <ls_stop_last>-plan_trans_time IS NOT INITIAL
                                        THEN |0{ <ls_stop_last>-plan_trans_time }| ELSE '' ).
        cv_pln_arr_timezone = /scmtms/cl_common_helper=>loc_key_get_timezone( iv_loc_key = <ls_stop_last>-log_loc_uuid ).
      ENDIF.
    ENDIF.

  ENDMETHOD.


  METHOD get_package_id.

    DATA:
      ls_resource       TYPE ts_resource,
      lt_tmp_package_id TYPE TABLE OF /scmtms/package_id.

    CLEAR:
      et_package_id,
      et_package_id_ext.

    zcl_gtt_sts_tools=>get_package_id(
      EXPORTING
        ir_root           = REF #( is_tor_root )
        iv_old_data       = iv_before_image
      IMPORTING
        et_package_id_ext = lt_tmp_package_id ).

    LOOP AT lt_tmp_package_id INTO DATA(ls_tmp_package_id).
      ls_resource-category = cs_tu_type-package_ext_id.
      ls_resource-value = |{ is_tor_root-tor_id ALPHA = OUT }{ ls_tmp_package_id } |.
      CONDENSE ls_resource-value NO-GAPS.
      ls_resource-orginal_value = ls_tmp_package_id.
      ls_resource-tor_id = is_tor_root-tor_id.
      SHIFT ls_resource-tor_id LEFT DELETING LEADING '0'.
      APPEND ls_resource TO et_package_id_ext.
      CLEAR ls_resource.

    ENDLOOP.

  ENDMETHOD.


  METHOD get_stop_seq.

    DATA:
      lv_stop_num(4) TYPE n,
      lv_loctype     TYPE /saptrx/loc_id_type,
      lv_tmp_value   TYPE char255.

    DATA(lv_tor_id) = is_tor_root-tor_id.
    SHIFT lv_tor_id LEFT DELETING LEADING '0'.

    ASSIGN it_stop_seq[ root_key = is_tor_root-node_id ]-stop_seq TO FIELD-SYMBOL(<lt_stop_seq>) ##WARN_OK.
    IF sy-subrc = 0.
      LOOP AT <lt_stop_seq> ASSIGNING FIELD-SYMBOL(<ls_stop_seq>).
        CHECK zcl_gtt_sts_tools=>is_odd( <ls_stop_seq>-seq_num ).
        lv_stop_num += 1.
        CHECK <ls_stop_seq>-log_locid IS NOT INITIAL.

        lv_loctype = zcl_gtt_sts_tools=>get_location_type( iv_locno = <ls_stop_seq>-log_locid ).

        lv_tmp_value = |{ lv_tor_id }{ iv_tu_no }{ lv_stop_num }|.
        CONDENSE lv_tmp_value NO-GAPS.
        APPEND lv_tmp_value                    TO ct_stop_id.
        APPEND lv_stop_num                     TO ct_ordinal_no.
        APPEND lv_loctype                      TO ct_loc_type.
        APPEND <ls_stop_seq>-log_locid         TO ct_loc_id.
        CLEAR:
          lv_loctype,
          lv_tmp_value.
      ENDLOOP.
    ENDIF.

    lv_stop_num += 1.
    DATA(lv_stop_count) = lines( <lt_stop_seq> ).

    ASSIGN <lt_stop_seq>[ lv_stop_count ] TO <ls_stop_seq>.
    IF sy-subrc = 0 AND <ls_stop_seq>-log_locid IS NOT INITIAL.
      lv_loctype = zcl_gtt_sts_tools=>get_location_type( iv_locno = <ls_stop_seq>-log_locid ).

      lv_tmp_value = |{ lv_tor_id }{ iv_tu_no }{ lv_stop_num }|.
      CONDENSE lv_tmp_value NO-GAPS.
      APPEND lv_tmp_value                   TO ct_stop_id.
      APPEND lv_stop_num                    TO ct_ordinal_no.
      APPEND lv_loctype                     TO ct_loc_type.
      APPEND <ls_stop_seq>-log_locid        TO ct_loc_id.
      CLEAR lv_tmp_value.
    ENDIF.

    IF ct_ordinal_no IS INITIAL.
      APPEND '' TO ct_ordinal_no.
    ENDIF.

  ENDMETHOD.


  METHOD get_sys_appsys.

    CLEAR rv_appsys.

    CALL FUNCTION 'OWN_LOGICAL_SYSTEM_GET'
      IMPORTING
        own_logical_system             = rv_appsys
      EXCEPTIONS
        own_logical_system_not_defined = 1
        OTHERS                         = 2.

  ENDMETHOD.


  METHOD get_tu_number.

    DATA:
      lt_resource1 TYPE tt_resource,
      lt_resource2 TYPE tt_resource,
      lt_resource3 TYPE tt_resource,
      lt_resource4 TYPE tt_resource.

    CLEAR et_resource.

*   Get container ID
    get_container_mobile_id(
      EXPORTING
        is_tor_root     = is_tor_root
        it_tor_item     = it_tor_item
        iv_before_image = iv_before_image
      IMPORTING
        et_container    = lt_resource1
        et_mobile       = lt_resource2 ).

*   Get plate number
    get_plate_truck_number(
      EXPORTING
        is_tor_root     = is_tor_root
        it_tor_item     = it_tor_item
        iv_before_image = iv_before_image
      IMPORTING
        et_plate        = lt_resource3 ).

*   Get Package ID & External Package ID
    get_package_id(
      EXPORTING
        is_tor_root       = is_tor_root
        it_tor_item       = it_tor_item
        iv_before_image   = iv_before_image
      IMPORTING
        et_package_id_ext = lt_resource4 ).

    APPEND LINES OF lt_resource1 TO et_resource.
    APPEND LINES OF lt_resource2 TO et_resource.
    APPEND LINES OF lt_resource3 TO et_resource.
    APPEND LINES OF lt_resource4 TO et_resource.

  ENDMETHOD.


  METHOD get_vessel_id.

    DATA:
      ls_root         TYPE /scmtms/s_em_bo_tor_root,
      ls_resource     TYPE ts_resource,
      lt_resource     TYPE tt_resource,
      lv_before_image TYPE boole_d.

    CLEAR et_resource.

    ls_root = is_tor_root.
    lv_before_image = iv_before_image.

*   Get Vessel ID
    LOOP AT it_tor_item INTO DATA(ls_item)
      WHERE item_cat = /scmtms/if_tor_const=>sc_tor_item_category-booking.

      IF ls_item-parent_node_id = ls_root-node_id AND ls_item-vessel_id IS NOT INITIAL.
        ls_resource-category = cs_tu_type-vessel.
        ls_resource-value = |{ ls_root-tor_id ALPHA = OUT }{ ls_item-vessel_id } |.
        CONDENSE ls_resource-value NO-GAPS.
        ls_resource-orginal_value = ls_item-vessel_id.
        ls_resource-tor_id = ls_root-tor_id.
        SHIFT ls_resource-tor_id LEFT DELETING LEADING '0'.
        APPEND ls_resource TO lt_resource.
        CLEAR ls_resource.
      ENDIF.
    ENDLOOP.

    et_resource = lt_resource.

  ENDMETHOD.


  METHOD load_end.

    DATA:
      lt_loc_root TYPE /scmtms/t_bo_loc_root_k.

    LOOP AT it_stop USING KEY parent_seqnum ASSIGNING FIELD-SYMBOL(<ls_stop>) WHERE parent_node_id = is_tor_root-node_id.
      CHECK <ls_stop>-stop_cat = /scmtms/if_common_c=>c_stop_category-outbound AND
            <ls_stop>-aggr_assgn_start_l IS NOT INITIAL AND
            <ls_stop>-aggr_assgn_end_l   IS NOT INITIAL.

      READ TABLE it_stop_points REFERENCE INTO DATA(ls_stop_points) WITH KEY log_locid = <ls_stop>-log_locid
                                                                             seq_num   = <ls_stop>-seq_num.
      CHECK sy-subrc = 0.

      TEST-SEAM load_end_lt_loc_root.
        /scmtms/cl_pln_bo_data=>get_loc_data(
          EXPORTING
            it_key      = VALUE #( ( key = <ls_stop>-log_loc_uuid ) )
          CHANGING
            ct_loc_root = lt_loc_root ).
      END-TEST-SEAM.

      READ TABLE lt_loc_root REFERENCE INTO DATA(ls_loc_root) WITH KEY key COMPONENTS key = <ls_stop>-log_loc_uuid.
      CHECK sy-subrc = 0.

      DATA(lv_tz) = COND tznzone( WHEN ls_loc_root->time_zone_code IS NOT INITIAL THEN ls_loc_root->time_zone_code
                                  ELSE sy-zonlo ).

      DATA(lv_exp_datetime) = <ls_stop>-aggr_assgn_end_l.

      zcl_gtt_sts_tools=>convert_utc_timestamp(
        EXPORTING
          iv_timezone  = lv_tz
        CHANGING
          cv_timestamp = lv_exp_datetime ).

      APPEND VALUE #(
        appsys           = mv_appsys
        appobjtype       = mv_aotype
        language         = sy-langu
        appobjid         = iv_appobjid
        milestone        = zif_gtt_sts_constants=>cs_milestone-fo_load_end
        evt_exp_datetime = |0{ lv_exp_datetime }|
        evt_exp_tzone    = lv_tz
        locid1           = <ls_stop>-log_locid
        locid2           = ls_stop_points->stop_id
        loctype          = zcl_gtt_sts_tools=>get_location_type( iv_locno = <ls_stop>-log_locid )
        itemident        = <ls_stop>-node_id ) TO ct_expeventdata.

      CLEAR: lt_loc_root, ls_loc_root.
    ENDLOOP.

  ENDMETHOD.


  METHOD load_start.

    DATA:
      lt_loc_root TYPE /scmtms/t_bo_loc_root_k.


    LOOP AT it_stop USING KEY parent_seqnum ASSIGNING FIELD-SYMBOL(<ls_stop>) WHERE parent_node_id = is_tor_root-node_id.
      CHECK <ls_stop>-stop_cat = /scmtms/if_common_c=>c_stop_category-outbound AND
            <ls_stop>-aggr_assgn_start_l IS NOT INITIAL AND
            <ls_stop>-aggr_assgn_end_l   IS NOT INITIAL.

      READ TABLE it_stop_points REFERENCE INTO DATA(ls_stop_points)
                                     WITH KEY log_locid = <ls_stop>-log_locid
                                              seq_num   = <ls_stop>-seq_num.
      CHECK sy-subrc = 0.

      TEST-SEAM load_start_lt_loc_root.
        /scmtms/cl_pln_bo_data=>get_loc_data(
          EXPORTING
            it_key      = VALUE #( ( key = <ls_stop>-log_loc_uuid ) )
          CHANGING
            ct_loc_root = lt_loc_root ).
      END-TEST-SEAM.

      READ TABLE lt_loc_root REFERENCE INTO DATA(ls_loc_root)
                                     WITH KEY key COMPONENTS key = <ls_stop>-log_loc_uuid.
      CHECK sy-subrc = 0.

      DATA(lv_tz) = COND tznzone( WHEN ls_loc_root->time_zone_code IS NOT INITIAL
                                  THEN ls_loc_root->time_zone_code
                                  ELSE sy-zonlo ).

      DATA(lv_exp_datetime) = <ls_stop>-aggr_assgn_start_l.

      zcl_gtt_sts_tools=>convert_utc_timestamp(
        EXPORTING
          iv_timezone  = lv_tz
        CHANGING
          cv_timestamp = lv_exp_datetime ).

      APPEND VALUE #(
      appsys            = mv_appsys
      appobjtype        = mv_aotype
      language          = sy-langu
      appobjid          = iv_appobjid
      milestone         = zif_gtt_sts_constants=>cs_milestone-fo_load_start
      evt_exp_datetime  = |0{ lv_exp_datetime }|
      evt_exp_tzone     = lv_tz
      locid1            = <ls_stop>-log_locid
      locid2            = ls_stop_points->stop_id
      loctype           = zcl_gtt_sts_tools=>get_location_type( iv_locno = <ls_stop>-log_locid ) ) TO ct_expeventdata.

      CLEAR: lt_loc_root, ls_loc_root.
    ENDLOOP.

  ENDMETHOD.


  METHOD pod.

    DATA:
       lt_loc_root TYPE /scmtms/t_bo_loc_root_k.

    LOOP AT it_stop USING KEY parent_seqnum ASSIGNING FIELD-SYMBOL(<ls_stop>) WHERE parent_node_id = is_tor_root-node_id.
      CHECK <ls_stop>-stop_cat = /scmtms/if_common_c=>c_stop_category-inbound AND
            <ls_stop>-aggr_assgn_start_l IS NOT INITIAL AND
            <ls_stop>-aggr_assgn_end_l   IS NOT INITIAL.

      READ TABLE it_stop_points REFERENCE INTO DATA(ls_stop_points) WITH KEY log_locid = <ls_stop>-log_locid
                                                                             seq_num   = <ls_stop>-seq_num.
      CHECK sy-subrc = 0.

      TEST-SEAM pod_lt_loc_root.
        /scmtms/cl_pln_bo_data=>get_loc_data(
          EXPORTING
            it_key      = VALUE #( ( key = <ls_stop>-log_loc_uuid ) )
          CHANGING
            ct_loc_root = lt_loc_root ).
      END-TEST-SEAM.

      READ TABLE lt_loc_root REFERENCE INTO DATA(ls_loc_root)
                                     WITH KEY key COMPONENTS key = <ls_stop>-log_loc_uuid.
      CHECK sy-subrc = 0.

      DATA(lv_tz) = COND tznzone( WHEN ls_loc_root->time_zone_code IS NOT INITIAL THEN ls_loc_root->time_zone_code
                                  ELSE sy-zonlo ).

      DATA(lv_exp_datetime) = <ls_stop>-aggr_assgn_end_l.

      zcl_gtt_sts_tools=>convert_utc_timestamp(
        EXPORTING
          iv_timezone  = lv_tz
        CHANGING
          cv_timestamp = lv_exp_datetime ).

      APPEND VALUE #(
        appsys           = mv_appsys
        appobjtype       = mv_aotype
        language         = sy-langu
        appobjid         = iv_appobjid
        milestone        = zif_gtt_sts_constants=>cs_milestone-fo_shp_pod
        evt_exp_datetime = |0{ lv_exp_datetime }|
        evt_exp_tzone    = lv_tz
        locid1           = <ls_stop>-log_locid
        locid2           = ls_stop_points->stop_id
        loctype          = zcl_gtt_sts_tools=>get_location_type( iv_locno = <ls_stop>-log_locid ) ) TO ct_expeventdata.

      CLEAR: lt_loc_root, ls_loc_root.
    ENDLOOP.


  ENDMETHOD.


  METHOD popu.

*   There exists at least one planned load end,then plan POPU event
    LOOP AT ct_expeventdata INTO DATA(ls_expeventdata)
      WHERE appsys     = mv_appsys
        AND appobjtype = mv_aotype
        AND language   = sy-langu
        AND appobjid   = iv_appobjid
        AND milestone  = zif_gtt_sts_constants=>cs_milestone-fo_load_end.

      APPEND VALUE #(
        appsys           = ls_expeventdata-appsys
        appobjtype       = ls_expeventdata-appobjtype
        language         = ls_expeventdata-language
        appobjid         = ls_expeventdata-appobjid
        milestone        = zif_gtt_sts_constants=>cs_milestone-fo_popu
        evt_exp_datetime = ls_expeventdata-evt_exp_datetime
        evt_exp_tzone    = ls_expeventdata-evt_exp_tzone
        locid1           = ls_expeventdata-locid1
        locid2           = ls_expeventdata-locid2
        loctype          = ls_expeventdata-loctype
        itemident        = ls_expeventdata-itemident ) TO ct_expeventdata.

    ENDLOOP.

  ENDMETHOD.


  METHOD prepare_idoc_data.

    DATA:
      lv_appobjid  TYPE /saptrx/aoid,
      ls_resource  TYPE ts_resource,
      ls_idoc_data TYPE ts_idoc_data,
      lt_idoc_data TYPE tt_idoc_data.

    CLEAR: et_idoc_data.

    LOOP AT it_resource INTO ls_resource WHERE change_mode = cs_change_mode-update.
      CLEAR:ls_idoc_data.

      lv_appobjid = ls_resource-value.
      ls_idoc_data-appsys = mv_appsys.

      fill_idoc_trxserv(
        EXPORTING
          iv_tor_type  = is_root-tor_type
        CHANGING
          cs_idoc_data = ls_idoc_data ).

      fill_idoc_appobj_ctabs(
        EXPORTING
          iv_appobjid  = lv_appobjid
        CHANGING
          cs_idoc_data = ls_idoc_data ).

      fill_idoc_control_data(
        EXPORTING
          is_tor_root  = is_root
          iv_appobjid  = lv_appobjid
          is_resource  = ls_resource
        CHANGING
          cs_idoc_data = ls_idoc_data ).

      fill_idoc_exp_event(
        EXPORTING
          is_tor_root  = is_root
          iv_tu_no     = ls_resource-orginal_value
          iv_appobjid  = lv_appobjid
        CHANGING
          cs_idoc_data = ls_idoc_data ).

      fill_idoc_tracking_id(
        EXPORTING
          iv_appobjid  = lv_appobjid
        CHANGING
          cs_idoc_data = ls_idoc_data ).

      IF ls_idoc_data-appobj_ctabs[] IS NOT INITIAL AND
         ls_idoc_data-control[] IS NOT INITIAL AND
         ls_idoc_data-tracking_id[] IS NOT INITIAL.
        APPEND ls_idoc_data TO lt_idoc_data.
      ENDIF.

    ENDLOOP.

    et_idoc_data = lt_idoc_data.

  ENDMETHOD.


  METHOD send_deletion_idoc_data.

    LOOP AT it_idoc_data ASSIGNING FIELD-SYMBOL(<ls_idoc_data>).
      CASE <ls_idoc_data>-trxserv-em_version.
        WHEN zif_gtt_sts_ef_constants=>cs_version-gtt10.
          send_idoc_ehpost01(
            iv_appsys       = <ls_idoc_data>-appsys
            is_trxserv      = <ls_idoc_data>-trxserv
            it_appobj_dtabs = <ls_idoc_data>-appobj_ctabs ).
        WHEN zif_gtt_sts_ef_constants=>cs_version-gtt20.
          send_idoc_gttmsg01(
            iv_appsys       = <ls_idoc_data>-appsys
            is_trxserv      = <ls_idoc_data>-trxserv
            it_appobj_dtabs = <ls_idoc_data>-appobj_ctabs ).
      ENDCASE.
    ENDLOOP.

  ENDMETHOD.


  METHOD send_idoc_data.

    DATA:
      lt_bapiret1 TYPE bapiret2_t,
      lt_bapiret2 TYPE bapiret2_t.

    LOOP AT it_idoc_data ASSIGNING FIELD-SYMBOL(<ls_idoc_data>).
      CLEAR: lt_bapiret1[], lt_bapiret2[].

      /saptrx/cl_send_idocs=>send_idoc_ehpost01(
        EXPORTING
          it_control      = <ls_idoc_data>-control
          it_info         = <ls_idoc_data>-info
          it_tracking_id  = <ls_idoc_data>-tracking_id
          it_exp_event    = <ls_idoc_data>-exp_event
          is_trxserv      = <ls_idoc_data>-trxserv
          iv_appsys       = <ls_idoc_data>-appsys
          it_appobj_ctabs = <ls_idoc_data>-appobj_ctabs
          iv_upd_task     = 'X'
        IMPORTING
          et_bapireturn   = lt_bapiret1 ).

      " when GTT.2 version
      IF /saptrx/cl_send_idocs=>st_idoc_data[] IS NOT INITIAL.
        /saptrx/cl_send_idocs=>send_idoc_gttmsg01(
          IMPORTING
            et_bapireturn = lt_bapiret2 ).
      ENDIF.

      " collect messages, if it is necessary
      IF et_bapiret IS REQUESTED.
        et_bapiret    = VALUE #( BASE et_bapiret
                                 ( LINES OF lt_bapiret1 )
                                 ( LINES OF lt_bapiret2 ) ).
      ENDIF.
    ENDLOOP.

  ENDMETHOD.


  METHOD send_idoc_ehpost01.

    DATA:
      ls_e1ehpao                    TYPE e1ehpao,
      ls_e1ehptid                   TYPE e1ehptid,
      ls_master_idoc_control        TYPE edidc,
      lt_master_idoc_data           TYPE edidd_tt,
      ls_master_idoc_data           TYPE edidd,
      lt_communication_idoc_control TYPE edidc_tt,
      lr_appobj_dtabs               TYPE REF TO trxas_appobj_ctab_wa.

    ls_master_idoc_control-rcvprt = cv_partner_type.
    ls_master_idoc_control-rcvprn = is_trxserv-trx_server.
    ls_master_idoc_control-mestyp = cv_msg_type_aopost.
    ls_master_idoc_control-idoctp = cv_idoc_type_ehpost01.

    LOOP AT it_appobj_dtabs REFERENCE INTO lr_appobj_dtabs WHERE trxservername = is_trxserv-trx_server_id.
      CLEAR ls_e1ehpao.

      ls_master_idoc_data-mandt   = sy-mandt.
      ls_master_idoc_data-segnam  = cv_seg_e1ehpao.
      ls_e1ehpao-appsys           = iv_appsys.
      ls_e1ehpao-appobjtype       = lr_appobj_dtabs->appobjtype.
      ls_e1ehpao-appobjid         = lr_appobj_dtabs->appobjid.
      ls_e1ehpao-update_indicator = lr_appobj_dtabs->update_indicator.
      ls_master_idoc_data-sdata   = ls_e1ehpao.
      INSERT ls_master_idoc_data INTO TABLE lt_master_idoc_data.

      " Dummy entry for TID is needed, since this is mandatory segment in the IDOC
      CLEAR ls_e1ehptid.
      ls_master_idoc_data-segnam = cv_seg_e1ehptid.
      ls_master_idoc_data-sdata  = ls_e1ehptid.
      INSERT ls_master_idoc_data INTO TABLE lt_master_idoc_data.

    ENDLOOP.

    IF lt_master_idoc_data IS INITIAL.
      RETURN.
    ENDIF.

    CALL FUNCTION 'MASTER_IDOC_DISTRIBUTE'
      EXPORTING
        master_idoc_control            = ls_master_idoc_control
      TABLES
        communication_idoc_control     = lt_communication_idoc_control
        master_idoc_data               = lt_master_idoc_data
      EXCEPTIONS
        error_in_idoc_control          = 1
        error_writing_idoc_status      = 2
        error_in_idoc_data             = 3
        sending_logical_system_unknown = 4
        OTHERS                         = 5.
    IF sy-subrc IS NOT INITIAL.
      " fill bapireturn
    ENDIF.

  ENDMETHOD.


  METHOD send_idoc_gttmsg01.

    DATA:
      ls_e1ehpao                    TYPE e1ehpao,
      ls_e1ehptid                   TYPE e1ehptid,
      ls_master_idoc_control        TYPE edidc,
      lt_master_idoc_data           TYPE edidd_tt,
      ls_master_idoc_data           TYPE edidd,
      lt_communication_idoc_control TYPE edidc_tt,
      lr_appobj_dtabs               TYPE REF TO trxas_appobj_ctab_wa.

    ls_master_idoc_control-rcvprt = cv_partner_type.
    ls_master_idoc_control-rcvprn = is_trxserv-trx_server.
    ls_master_idoc_control-mestyp = cv_msg_type_gttmsg.
    ls_master_idoc_control-idoctp = cv_idoc_type_gttmsg01.

    LOOP AT it_appobj_dtabs REFERENCE INTO lr_appobj_dtabs WHERE trxservername = is_trxserv-trx_server_id.
      CLEAR ls_e1ehpao.

      ls_master_idoc_data-mandt   = sy-mandt.
      ls_master_idoc_data-segnam  = cv_seg_e1ehpao.
      ls_e1ehpao-appsys           = iv_appsys.
      ls_e1ehpao-appobjtype       = lr_appobj_dtabs->appobjtype.
      ls_e1ehpao-appobjid         = lr_appobj_dtabs->appobjid.
      ls_e1ehpao-update_indicator = lr_appobj_dtabs->update_indicator.
      ls_master_idoc_data-sdata   = ls_e1ehpao.
      INSERT ls_master_idoc_data INTO TABLE lt_master_idoc_data.

      " Dummy entry for TID is needed, since this is mandatory segment in the IDOC
      CLEAR ls_e1ehptid.
      ls_master_idoc_data-segnam = cv_seg_e1ehptid.
      ls_master_idoc_data-sdata  = ls_e1ehptid.
      INSERT ls_master_idoc_data INTO TABLE lt_master_idoc_data.

    ENDLOOP.

    IF lt_master_idoc_data IS INITIAL.
      RETURN.
    ENDIF.

    CALL FUNCTION 'MASTER_IDOC_DISTRIBUTE'
      EXPORTING
        master_idoc_control            = ls_master_idoc_control
      TABLES
        communication_idoc_control     = lt_communication_idoc_control
        master_idoc_data               = lt_master_idoc_data
      EXCEPTIONS
        error_in_idoc_control          = 1
        error_writing_idoc_status      = 2
        error_in_idoc_data             = 3
        sending_logical_system_unknown = 4
        OTHERS                         = 5.
    IF sy-subrc IS NOT INITIAL.
      " fill bapireturn
    ENDIF.

  ENDMETHOD.


  METHOD shp_arrival.

    DATA:
      lt_loc_root TYPE /scmtms/t_bo_loc_root_k.

    LOOP AT it_stop USING KEY parent_seqnum ASSIGNING FIELD-SYMBOL(<ls_stop>) WHERE parent_node_id = is_tor_root-node_id.
      CHECK <ls_stop>-stop_cat = /scmtms/if_common_c=>c_stop_category-inbound AND
            <ls_stop>-plan_trans_time IS NOT INITIAL.

      READ TABLE it_stop_points REFERENCE INTO DATA(ls_stop_points)
                                     WITH KEY log_locid = <ls_stop>-log_locid
                                              seq_num   = <ls_stop>-seq_num.
      CHECK sy-subrc = 0.

      TEST-SEAM shp_arrival_lt_loc_root.
        /scmtms/cl_pln_bo_data=>get_loc_data(
          EXPORTING
            it_key      = VALUE #( ( key = <ls_stop>-log_loc_uuid ) )
          CHANGING
            ct_loc_root = lt_loc_root ).
      END-TEST-SEAM.
      READ TABLE lt_loc_root REFERENCE INTO DATA(ls_loc_root)
                                     WITH KEY key COMPONENTS key = <ls_stop>-log_loc_uuid.
      CHECK sy-subrc = 0.

      DATA(lv_tz) = COND tznzone( WHEN ls_loc_root->time_zone_code IS NOT INITIAL
                                  THEN ls_loc_root->time_zone_code
                                  ELSE sy-zonlo ).

      DATA(lv_exp_datetime) = <ls_stop>-plan_trans_time.

      zcl_gtt_sts_tools=>convert_utc_timestamp(
        EXPORTING
          iv_timezone  = lv_tz
        CHANGING
          cv_timestamp = lv_exp_datetime ).

      APPEND VALUE #(
      appsys            = mv_appsys
      appobjtype        = mv_aotype
      language          = sy-langu
      appobjid          = iv_appobjid
      milestone         = zif_gtt_sts_constants=>cs_milestone-fo_shp_arrival
      evt_exp_datetime  = |0{ lv_exp_datetime }|
      evt_exp_tzone     = lv_tz
      locid1            = <ls_stop>-log_locid
      locid2            = ls_stop_points->stop_id
      loctype           = zcl_gtt_sts_tools=>get_location_type( iv_locno = <ls_stop>-log_locid ) ) TO ct_expeventdata.

      CLEAR: lt_loc_root, ls_loc_root.
    ENDLOOP.


  ENDMETHOD.


  METHOD shp_departure.

    DATA:
      lt_loc_root TYPE /scmtms/t_bo_loc_root_k.

    LOOP AT it_stop USING KEY parent_seqnum ASSIGNING FIELD-SYMBOL(<ls_stop>) WHERE parent_node_id = is_tor_root-node_id.
      CHECK <ls_stop>-stop_cat = /scmtms/if_common_c=>c_stop_category-outbound AND
            <ls_stop>-plan_trans_time IS NOT INITIAL.

      READ TABLE it_stop_points REFERENCE INTO DATA(ls_stop_points)
                                     WITH KEY log_locid = <ls_stop>-log_locid
                                              seq_num   = <ls_stop>-seq_num.
      CHECK sy-subrc = 0.

      TEST-SEAM shp_dep_lt_loc_root.
        /scmtms/cl_pln_bo_data=>get_loc_data(
          EXPORTING
            it_key      = VALUE #( ( key = <ls_stop>-log_loc_uuid ) )
          CHANGING
            ct_loc_root = lt_loc_root ).
      END-TEST-SEAM.
      READ TABLE lt_loc_root REFERENCE INTO DATA(ls_loc_root)
                                     WITH KEY key COMPONENTS key = <ls_stop>-log_loc_uuid.
      CHECK sy-subrc = 0.

      DATA(lv_tz) = COND tznzone( WHEN ls_loc_root->time_zone_code IS NOT INITIAL
                                  THEN ls_loc_root->time_zone_code
                                  ELSE sy-zonlo ).

      DATA(lv_exp_datetime) = <ls_stop>-plan_trans_time.

      zcl_gtt_sts_tools=>convert_utc_timestamp(
        EXPORTING
          iv_timezone  = lv_tz
        CHANGING
          cv_timestamp = lv_exp_datetime ).

      APPEND VALUE #(
      appsys            = mv_appsys
      appobjtype        = mv_aotype
      language          = sy-langu
      appobjid          = iv_appobjid
      milestone         = zif_gtt_sts_constants=>cs_milestone-fo_shp_departure
      evt_exp_datetime  = |0{ lv_exp_datetime }|
      evt_exp_tzone     = lv_tz
      locid1            = <ls_stop>-log_locid
      locid2            = ls_stop_points->stop_id
      loctype           = zcl_gtt_sts_tools=>get_location_type( iv_locno = <ls_stop>-log_locid ) ) TO ct_expeventdata.

      CLEAR: lt_loc_root, ls_loc_root.
    ENDLOOP.

  ENDMETHOD.


  METHOD status_changes_check.

    rv_result = abap_false.

    DATA(lv_carrier_added) = xsdbool( is_tor_root_before-tsp IS INITIAL AND is_tor_root-tsp IS NOT INITIAL ).

    DATA(lv_execution_status_changed) = xsdbool(
      ( is_tor_root_before-execution = /scmtms/if_tor_status_c=>sc_root-execution-v_not_relevant         OR
        is_tor_root_before-execution = /scmtms/if_tor_status_c=>sc_root-execution-v_not_started          OR
        is_tor_root_before-execution = /scmtms/if_tor_status_c=>sc_root-execution-v_cancelled            OR
        is_tor_root_before-execution = /scmtms/if_tor_status_c=>sc_root-execution-v_not_ready_for_execution ) AND
      ( is_tor_root-execution = /scmtms/if_tor_status_c=>sc_root-execution-v_in_execution        OR
        is_tor_root-execution = /scmtms/if_tor_status_c=>sc_root-execution-v_executed            OR
        is_tor_root-execution = /scmtms/if_tor_status_c=>sc_root-execution-v_interrupted         OR
        is_tor_root-execution = /scmtms/if_tor_status_c=>sc_root-execution-v_ready_for_execution OR
        is_tor_root-execution = /scmtms/if_tor_status_c=>sc_root-execution-v_loading_in_process  OR
        is_tor_root-execution = /scmtms/if_tor_status_c=>sc_root-execution-v_capa_plan_finished  ) ).

    DATA(lv_lifecycle_status_changed) = xsdbool(
      ( is_tor_root_before-lifecycle <> /scmtms/if_tor_status_c=>sc_root-lifecycle-v_in_process AND
        is_tor_root_before-lifecycle <> /scmtms/if_tor_status_c=>sc_root-lifecycle-v_completed ) AND
      ( is_tor_root-lifecycle = /scmtms/if_tor_status_c=>sc_root-lifecycle-v_in_process OR
        is_tor_root-lifecycle = /scmtms/if_tor_status_c=>sc_root-lifecycle-v_completed ) ).

    CASE is_tor_root-tor_cat.
      WHEN /scmtms/if_tor_const=>sc_tor_category-active OR
           /scmtms/if_tor_const=>sc_tor_category-booking.

        IF lv_carrier_added = abap_true AND lv_execution_status_changed = abap_true.
          rv_result = abap_true.
        ELSEIF is_tor_root-tsp IS NOT INITIAL AND lv_execution_status_changed = abap_true.
          rv_result = abap_true.
        ENDIF.
      WHEN /scmtms/if_tor_const=>sc_tor_category-freight_unit.
        IF lv_execution_status_changed = abap_true OR lv_lifecycle_status_changed = abap_true.
          rv_result = abap_true.
        ENDIF.
      WHEN OTHERS.

    ENDCASE.

  ENDMETHOD.


  METHOD throw_exception.

    RAISE EXCEPTION TYPE cx_udm_message
      EXPORTING
        textid  = iv_textid
        m_msgid = sy-msgid
        m_msgty = sy-msgty
        m_msgno = sy-msgno
        m_msgv1 = sy-msgv1
        m_msgv2 = sy-msgv2
        m_msgv3 = sy-msgv3
        m_msgv4 = sy-msgv4.

  ENDMETHOD.


  METHOD unload_end.

    DATA:
      lt_loc_root TYPE /scmtms/t_bo_loc_root_k.

    LOOP AT it_stop USING KEY parent_seqnum ASSIGNING FIELD-SYMBOL(<ls_stop>) WHERE parent_node_id = is_tor_root-node_id.
      CHECK  <ls_stop>-stop_cat = /scmtms/if_common_c=>c_stop_category-inbound AND
             <ls_stop>-aggr_assgn_start_l IS NOT INITIAL AND
             <ls_stop>-aggr_assgn_end_l   IS NOT INITIAL.

      READ TABLE it_stop_points REFERENCE INTO DATA(ls_stop_points)
                                     WITH KEY log_locid = <ls_stop>-log_locid
                                              seq_num   = <ls_stop>-seq_num.
      CHECK sy-subrc = 0.

      TEST-SEAM unload_end_lt_loc_root.
        /scmtms/cl_pln_bo_data=>get_loc_data(
          EXPORTING
            it_key      = VALUE #( ( key = <ls_stop>-log_loc_uuid ) )
          CHANGING
            ct_loc_root = lt_loc_root ).
      END-TEST-SEAM.

      READ TABLE lt_loc_root REFERENCE INTO DATA(ls_loc_root)
                                     WITH KEY key COMPONENTS key = <ls_stop>-log_loc_uuid.
      CHECK sy-subrc = 0.

      DATA(lv_tz) = COND tznzone( WHEN ls_loc_root->time_zone_code IS NOT INITIAL
                                  THEN ls_loc_root->time_zone_code
                                  ELSE sy-zonlo ).

      DATA(lv_exp_datetime) = <ls_stop>-aggr_assgn_end_l.

      zcl_gtt_sts_tools=>convert_utc_timestamp(
        EXPORTING
          iv_timezone  = lv_tz
        CHANGING
          cv_timestamp = lv_exp_datetime ).

      APPEND VALUE #(
      appsys            = mv_appsys
      appobjtype        = mv_aotype
      language          = sy-langu
      appobjid          = iv_appobjid
      milestone         = zif_gtt_sts_constants=>cs_milestone-fo_unload_end
      evt_exp_datetime  = |0{ lv_exp_datetime }|
      evt_exp_tzone     = lv_tz
      locid1            = <ls_stop>-log_locid
      locid2            = ls_stop_points->stop_id
      loctype           = zcl_gtt_sts_tools=>get_location_type( iv_locno = <ls_stop>-log_locid ) ) TO ct_expeventdata.

      CLEAR: lt_loc_root, ls_loc_root.
    ENDLOOP.


  ENDMETHOD.


  METHOD unload_start.

    DATA:
       lt_loc_root TYPE /scmtms/t_bo_loc_root_k.

    LOOP AT it_stop USING KEY parent_seqnum ASSIGNING FIELD-SYMBOL(<ls_stop>) WHERE parent_node_id = is_tor_root-node_id.
      CHECK <ls_stop>-stop_cat = /scmtms/if_common_c=>c_stop_category-inbound AND
            <ls_stop>-aggr_assgn_start_l IS NOT INITIAL AND
            <ls_stop>-aggr_assgn_end_l   IS NOT INITIAL.

      READ TABLE it_stop_points REFERENCE INTO DATA(ls_stop_points)
                                     WITH KEY log_locid = <ls_stop>-log_locid
                                              seq_num   = <ls_stop>-seq_num.
      CHECK sy-subrc = 0.

      TEST-SEAM unload_start_lt_loc_root.
        /scmtms/cl_pln_bo_data=>get_loc_data(
          EXPORTING
            it_key      = VALUE #( ( key = <ls_stop>-log_loc_uuid ) )
          CHANGING
            ct_loc_root = lt_loc_root ).
      END-TEST-SEAM.

      READ TABLE lt_loc_root REFERENCE INTO DATA(ls_loc_root)
                                     WITH KEY key COMPONENTS key = <ls_stop>-log_loc_uuid.
      CHECK sy-subrc = 0.

      DATA(lv_tz) = COND tznzone( WHEN ls_loc_root->time_zone_code IS NOT INITIAL
                                  THEN ls_loc_root->time_zone_code
                                  ELSE sy-zonlo ).

      DATA(lv_exp_datetime) = <ls_stop>-aggr_assgn_start_l.

      zcl_gtt_sts_tools=>convert_utc_timestamp(
        EXPORTING
          iv_timezone  = lv_tz
        CHANGING
          cv_timestamp = lv_exp_datetime ).

      APPEND VALUE #(
      appsys            = mv_appsys
      appobjtype        = mv_aotype
      language          = sy-langu
      appobjid          = iv_appobjid
      milestone         = zif_gtt_sts_constants=>cs_milestone-fo_unload_start
      evt_exp_datetime  = |0{ lv_exp_datetime }|
      evt_exp_tzone     = lv_tz
      locid1            = <ls_stop>-log_locid
      locid2            = ls_stop_points->stop_id
      loctype           = zcl_gtt_sts_tools=>get_location_type( iv_locno = <ls_stop>-log_locid ) ) TO ct_expeventdata.

      CLEAR: lt_loc_root, ls_loc_root.
    ENDLOOP.

  ENDMETHOD.


  METHOD zif_gtt_sts_tu_reader~check_relevance.

    DATA:
      ls_tu_info      TYPE ts_tu_header,
      ls_tu_info_old  TYPE ts_tu_header,
      lv_tu_no        TYPE /scmtms/package_id,
      rr_data         TYPE REF TO data,
      rr_data_old     TYPE REF TO data,
      lt_resource     TYPE tt_resource,
      lt_resource_old TYPE tt_resource,
      lv_no_changes   TYPE flag,
      lt_relevance    TYPE tt_relevance,
      ls_relevance    TYPE ts_relevance,
      lv_result       TYPE syst_binpt.

*   Get current data
    LOOP AT it_tor_root_sstring INTO DATA(ls_tor_root_sstring)
      WHERE tor_cat = mv_tor_cat.

      CLEAR:
        ls_tu_info,
        ls_tu_info_old,
        lt_resource,
        lt_resource_old.

      pre_condition_check(
        EXPORTING
          is_root   = ls_tor_root_sstring
        RECEIVING
          rv_result = lv_result ).

      IF lv_result = zif_gtt_sts_ef_constants=>cs_condition-false.
        ls_relevance-node_id = ls_tor_root_sstring-node_id.
        ls_relevance-tor_id = ls_tor_root_sstring-tor_id.
        ls_relevance-rel = lv_result.
        APPEND ls_relevance TO lt_relevance.
        CLEAR:ls_relevance.
        CONTINUE.
      ENDIF.
      CLEAR lv_result.

      get_data(
        EXPORTING
          is_tor_root = ls_tor_root_sstring
          iv_old_data = abap_false
          iv_tu_no    = lv_tu_no
        CHANGING
          cs_tu_info  = ls_tu_info ).

      rr_data = REF #( ls_tu_info ).

      get_tu_number(
        EXPORTING
          is_tor_root     = ls_tor_root_sstring
          it_tor_item     = it_tor_item_sstring
          iv_before_image = abap_false
        IMPORTING
          et_resource     = lt_resource ).

*     Get Old data
      READ TABLE it_tor_root_before_sstring INTO DATA(ls_tor_root_before_sstring)
        WITH KEY node_id = ls_tor_root_sstring-node_id.
      IF sy-subrc = 0.
        get_data(
          EXPORTING
            is_tor_root = ls_tor_root_before_sstring
            iv_old_data = abap_true
            iv_tu_no    = lv_tu_no
          CHANGING
            cs_tu_info  = ls_tu_info_old ).

        get_tu_number(
          EXPORTING
            is_tor_root     = ls_tor_root_before_sstring
            it_tor_item     = it_tor_item_before_sstring
            iv_before_image = abap_true
          IMPORTING
            et_resource     = lt_resource_old ).

      ENDIF.

      rr_data_old = REF #( ls_tu_info_old ).

      zcl_gtt_sts_tools=>are_structures_different(
        EXPORTING
          ir_data1  = rr_data
          ir_data2  = rr_data_old
        RECEIVING
          rv_result = lv_result ).

      IF lv_result = zif_gtt_sts_ef_constants=>cs_condition-false.
        SORT lt_resource BY category orginal_value.
        SORT lt_resource_old BY category orginal_value.

        CALL FUNCTION 'CTVB_COMPARE_TABLES'
          EXPORTING
            table_old  = lt_resource_old
            table_new  = lt_resource
            key_length = 80
          IMPORTING
            no_changes = lv_no_changes.

        IF lv_no_changes = abap_true.
          lv_result = zif_gtt_sts_ef_constants=>cs_condition-false.
        ELSE.
          lv_result = zif_gtt_sts_ef_constants=>cs_condition-true.
        ENDIF.

        IF lv_result = zif_gtt_sts_ef_constants=>cs_condition-false.
          status_changes_check(
            EXPORTING
              is_tor_root_before = ls_tor_root_before_sstring
              is_tor_root        = ls_tor_root_sstring
            RECEIVING
              rv_result          = DATA(lv_status_result) ).
          IF lv_status_result IS NOT INITIAL.
            lv_result = zif_gtt_sts_ef_constants=>cs_condition-true.
          ENDIF.
          CLEAR lv_status_result.
        ENDIF.
      ENDIF.

      ls_relevance-node_id = ls_tor_root_sstring-node_id.
      ls_relevance-tor_id = ls_tor_root_sstring-tor_id.
      ls_relevance-rel = lv_result.
      APPEND ls_relevance TO lt_relevance.
      CLEAR:ls_relevance.

    ENDLOOP.

    et_relevance = lt_relevance.

  ENDMETHOD.


  METHOD zif_gtt_sts_tu_reader~delete_old_tu.

    DATA:
      lt_resource     TYPE tt_resource,
      lt_tmp_resource TYPE tt_resource,
      lt_resource1    TYPE tt_resource,
      lt_resource2    TYPE tt_resource,
      ls_resource     TYPE ts_resource,
      ls_idoc_data    TYPE ts_idoc_data,
      ls_trxserv      TYPE /saptrx/trxserv,
      lv_appsys       TYPE logsys,
      lv_appobjid     TYPE /saptrx/aoid,
      lt_idoc_data    TYPE tt_idoc_data,
      lv_result       TYPE syst_binpt,
      ls_tor_data     TYPE ts_tor_data,
      lt_tor_data     TYPE TABLE OF ts_tor_data.

    LOOP AT it_tor_root_for_deletion INTO DATA(ls_tor_root_for_deletion)
      WHERE tor_cat = mv_tor_cat.
      CLEAR lt_tmp_resource.

      ls_tor_data-tor_id = ls_tor_root_for_deletion-tor_id.
      SHIFT ls_tor_data-tor_id LEFT DELETING LEADING '0'.
      ls_tor_data-tor_type = ls_tor_root_for_deletion-tor_type.
      APPEND ls_tor_data TO lt_tor_data.

      get_tu_number(
        EXPORTING
          is_tor_root = ls_tor_root_for_deletion
          it_tor_item = it_item_sstring
        IMPORTING
          et_resource = lt_tmp_resource ).
      APPEND LINES OF lt_tmp_resource TO lt_resource1.
    ENDLOOP.

    LOOP AT it_tor_root_sstring INTO DATA(ls_root)
      WHERE tor_cat = mv_tor_cat.
      CLEAR lt_tmp_resource.

      ls_tor_data-tor_id = ls_root-tor_id.
      SHIFT ls_tor_data-tor_id LEFT DELETING LEADING '0'.
      ls_tor_data-tor_type = ls_root-tor_type.
      APPEND ls_tor_data TO lt_tor_data.

      del_condition_check(
        EXPORTING
          is_root   = ls_root
        RECEIVING
          rv_result = lv_result ).

      IF lv_result = zif_gtt_sts_ef_constants=>cs_condition-false.
        CONTINUE.
      ENDIF.

      READ TABLE it_tor_root_for_deletion TRANSPORTING NO FIELDS
        WITH KEY node_id = ls_root-node_id.
      IF sy-subrc <> 0.

        READ TABLE it_tor_root_before_sstring INTO DATA(ls_root_old)
          WITH KEY node_id = ls_root-node_id.

*       if FO changed from no relevant to relevent,do not delete the TU
        status_changes_check(
          EXPORTING
            is_tor_root_before = ls_root_old
            is_tor_root        = ls_root
          RECEIVING
            rv_result          = DATA(lv_status_result) ).
        IF lv_status_result = abap_true.
          CONTINUE.
        ENDIF.

        get_deleted_tu(
          EXPORTING
            is_tor_root        = ls_root
            it_tor_item        = it_item_sstring
            is_tor_root_before = ls_root_old
            it_tor_item_before = it_item_before_sstring
          IMPORTING
            et_resource        = lt_tmp_resource ).
        APPEND LINES OF lt_tmp_resource TO lt_resource2.

      ENDIF.

    ENDLOOP.

    DELETE lt_resource2 WHERE change_mode <> cs_change_mode-delete.

    APPEND LINES OF lt_resource1 TO lt_resource.
    APPEND LINES OF lt_resource2 TO lt_resource.

    LOOP AT lt_resource INTO ls_resource.
      CLEAR:
        ls_idoc_data,
        ls_tor_data.

      READ TABLE lt_tor_data INTO ls_tor_data
        WITH KEY tor_id = ls_resource-tor_id.

      fill_idoc_trxserv(
        EXPORTING
          iv_tor_type  = ls_tor_data-tor_type
        CHANGING
          cs_idoc_data = ls_idoc_data ).

      lv_appobjid = ls_resource-value.
      ls_idoc_data-appsys = mv_appsys.

      fill_idoc_appobj_ctabs(
        EXPORTING
          iv_appobjid         = lv_appobjid
          iv_update_indicator = cs_change_mode-delete
        CHANGING
          cs_idoc_data        = ls_idoc_data ).
      IF ls_idoc_data-appobj_ctabs[] IS NOT INITIAL.
        APPEND ls_idoc_data TO lt_idoc_data.
      ENDIF.

    ENDLOOP.

    send_deletion_idoc_data( it_idoc_data = lt_idoc_data ).

  ENDMETHOD.


  METHOD zif_gtt_sts_tu_reader~generate_new_tu.

    DATA:
      lt_resource      TYPE tt_resource,
      lt_idoc_data     TYPE tt_idoc_data,
      lt_tmp_idoc_data TYPE tt_idoc_data,
      lt_bapiret       TYPE bapiret2_t,
      ls_relevance     TYPE ts_relevance.

    LOOP AT it_tor_root_sstring INTO DATA(ls_root)
      WHERE tor_cat = mv_tor_cat.
      CLEAR:
        lt_resource,
        lt_tmp_idoc_data,
        ls_relevance.

      READ TABLE it_relevance INTO ls_relevance
        WITH KEY node_id = ls_root-node_id.
      IF sy-subrc = 0 AND ls_relevance-rel = zif_gtt_sts_ef_constants=>cs_condition-false.
        CONTINUE.
      ENDIF.

      READ TABLE it_tor_root_before_sstring INTO DATA(ls_root_old)
        WITH KEY node_id = ls_root-node_id.

      get_changed_tu(
        EXPORTING
          is_tor_root        = ls_root
          it_tor_item        = it_tor_item_sstring
          is_tor_root_before = ls_root_old
          it_tor_item_before = it_tor_item_before_sstring
        IMPORTING
          et_resource        = lt_resource ).

      prepare_idoc_data(
        EXPORTING
          is_root      = ls_root
          it_resource  = lt_resource
        IMPORTING
          et_idoc_data = lt_tmp_idoc_data ).

      APPEND LINES OF lt_tmp_idoc_data TO lt_idoc_data.

    ENDLOOP.

    send_idoc_data(
      EXPORTING
        it_idoc_data = lt_idoc_data
      IMPORTING
        et_bapiret   = lt_bapiret ).

  ENDMETHOD.


  METHOD zif_gtt_sts_tu_reader~initiate.

    CALL FUNCTION 'OWN_LOGICAL_SYSTEM_GET'
      IMPORTING
        own_logical_system             = mv_appsys
      EXCEPTIONS
        own_logical_system_not_defined = 1
        OTHERS                         = 2.
    IF sy-subrc <> 0.
      MESSAGE e007(zgtt_sts) INTO DATA(lv_dummy) ##needed.
      throw_exception( ).
    ENDIF.

    SELECT /scmtms/c_torty~type          AS tor_type,
           /scmtms/c_torty~aotype        AS aot_type,
           /saptrx/aotypes~trxservername AS server_name
      INTO TABLE @mt_aotype
      FROM /scmtms/c_torty
      JOIN /saptrx/aotypes ON /scmtms/c_torty~aotype = /saptrx/aotypes~aotype
      FOR ALL ENTRIES IN @it_tor_root
      WHERE /scmtms/c_torty~type         = @it_tor_root-tor_type AND
            /saptrx/aotypes~trk_obj_type = @cs_obj_type-tms_tor  AND
            /saptrx/aotypes~torelevant   = @abap_true. "#EC CI_BUFFJOIN
    IF sy-subrc <> 0.
      MESSAGE e008(zgtt_sts) INTO lv_dummy.
      throw_exception( ).
    ENDIF.

    IF mt_aotype IS NOT INITIAL.
      SELECT *
        INTO TABLE mt_trxserv
        FROM /saptrx/trxserv
         FOR ALL ENTRIES IN mt_aotype
       WHERE trx_server_id = mt_aotype-server_name.
      IF sy-subrc <> 0.
        MESSAGE e008(zgtt_sts) INTO lv_dummy.
        throw_exception( ).
      ENDIF.
    ENDIF.

    mv_tor_cat = iv_tor_cat.
    mv_aotype = iv_aotype.

  ENDMETHOD.


  METHOD DEL_CONDITION_CHECK.
    rv_result = zif_gtt_sts_ef_constants=>cs_condition-false.
  ENDMETHOD.


  METHOD get_deleted_tu.

    DATA:
      lt_current_resource TYPE tt_resource,
      lt_old_resource     TYPE tt_resource,
      lv_index            TYPE i,
      lv_exec_flg         TYPE flag,
      lv_result           TYPE abap_bool.

    get_tu_number(
      EXPORTING
        is_tor_root = is_tor_root
        it_tor_item = it_tor_item
      IMPORTING
        et_resource = lt_current_resource ).

    get_tu_number(
      EXPORTING
        is_tor_root     = is_tor_root_before
        it_tor_item     = it_tor_item_before
        iv_before_image = abap_true
      IMPORTING
        et_resource     = lt_old_resource ).

    IF is_tor_root-change_mode <> /bobf/if_frw_c=>sc_modify_delete.
      LOOP AT lt_current_resource ASSIGNING FIELD-SYMBOL(<fs_current_resource>).
        READ TABLE lt_old_resource ASSIGNING FIELD-SYMBOL(<fs_old_resource>)
          WITH KEY category      = <fs_current_resource>-category
                   orginal_value = <fs_current_resource>-orginal_value.
        IF sy-subrc = 0.
          DELETE lt_old_resource WHERE category      = <fs_current_resource>-category
                                   AND orginal_value = <fs_current_resource>-orginal_value.
          DELETE lt_current_resource WHERE category      = <fs_current_resource>-category
                                       AND orginal_value = <fs_current_resource>-orginal_value.
        ENDIF.
      ENDLOOP.

    ENDIF.

    LOOP AT lt_old_resource ASSIGNING <fs_old_resource>.
      <fs_old_resource>-change_mode = cs_change_mode-delete.
    ENDLOOP.

    SORT lt_old_resource BY category orginal_value value change_mode tor_id.
    DELETE ADJACENT DUPLICATES FROM lt_old_resource COMPARING ALL FIELDS.

    et_resource = lt_old_resource.

  ENDMETHOD.


  METHOD pre_condition_check.

    rv_result = zif_gtt_sts_ef_constants=>cs_condition-false.

    IF is_root-change_mode = /bobf/if_frw_c=>sc_modify_delete.
      RETURN.
    ENDIF.

    IF ( is_root-track_exec_rel = zif_gtt_sts_constants=>cs_track_exec_rel-execution OR
        is_root-track_exec_rel = zif_gtt_sts_constants=>cs_track_exec_rel-exec_with_extern_event_mngr ) AND
      is_root-lifecycle = zif_gtt_sts_constants=>cs_lifecycle_status-in_process AND
      ( is_root-execution = zif_gtt_sts_constants=>cs_execution_status-in_execution OR
        is_root-execution = zif_gtt_sts_constants=>cs_execution_status-ready_for_transp_exec ) AND
      is_root-tspid IS NOT INITIAL AND ( is_root-tor_cat = mv_tor_cat  ).

      rv_result = zif_gtt_sts_ef_constants=>cs_condition-true.

    ENDIF.

  ENDMETHOD.


  METHOD get_container_mobile_id.

    DATA:
      ls_resource  TYPE ts_resource,
      lt_container TYPE tt_resource,
      lt_mobile    TYPE tt_resource,
      lt_tmp_cont  TYPE TABLE OF /scmtms/package_id,
      lt_tmp_mob   TYPE TABLE OF /scmtms/package_id,
      lt_text      TYPE tt_text,
      ls_text      TYPE ts_text.

    CLEAR :
      et_container,
      et_mobile.

    zcl_gtt_sts_tools=>get_container_mobile_id(
      EXPORTING
        ir_root      = REF #( is_tor_root )
        iv_old_data  = iv_before_image
      CHANGING
        et_container = lt_tmp_cont
        et_mobile    = lt_tmp_mob ).

    LOOP AT lt_tmp_cont INTO DATA(ls_tmp_cont).
      CLEAR ls_text.
      ls_text-text_type = cs_tu_type-container_id.
      ls_text-text_value = ls_tmp_cont.
      APPEND ls_text TO lt_text.
    ENDLOOP.

    LOOP AT lt_tmp_mob INTO DATA(ls_tmp_mob).
      CLEAR ls_text.
      ls_text-text_type = cs_tu_type-mobile_number.
      ls_text-text_value = ls_tmp_mob.
      APPEND ls_text TO lt_text.
    ENDLOOP.

    LOOP AT lt_text INTO ls_text.
      ls_resource-category = ls_text-text_type.
      ls_resource-value = |{ is_tor_root-tor_id ALPHA = OUT }{ ls_text-text_value } |.
      CONDENSE ls_resource-value NO-GAPS.
      ls_resource-orginal_value = ls_text-text_value .
      ls_resource-tor_id = is_tor_root-tor_id.
      SHIFT ls_resource-tor_id LEFT DELETING LEADING '0'.

      IF ls_resource-category = cs_tu_type-mobile_number.
        APPEND ls_resource TO lt_mobile.
      ELSEIF ls_resource-category = cs_tu_type-container_id.
        APPEND ls_resource TO lt_container.
      ENDIF.
      CLEAR ls_resource.
    ENDLOOP.

    et_container = lt_container.
    et_mobile = lt_mobile.

  ENDMETHOD.


  METHOD GET_PLATE_TRUCK_NUMBER.

    DATA:
      ls_root         TYPE /scmtms/s_em_bo_tor_root,
      ls_resource     TYPE ts_resource,
      lt_resource     TYPE tt_resource,
      lt_truck_id     TYPE tt_resource,
      lv_before_image TYPE boole_d.

    CLEAR:
      et_plate,
      et_truck_id.

    ls_root = is_tor_root.
    lv_before_image = iv_before_image.

    LOOP AT it_tor_item INTO DATA(ls_item)
      WHERE item_cat = /scmtms/if_tor_const=>sc_tor_item_category-av_item.

*     Get plate number
      IF ls_item-parent_node_id = ls_root-node_id AND ls_item-platenumber IS NOT INITIAL.
        ls_resource-category = cs_tu_type-license_plate.
        ls_resource-value = |{ ls_root-tor_id ALPHA = OUT }{ ls_item-platenumber } |.
        CONDENSE ls_resource-value NO-GAPS.
        ls_resource-orginal_value = ls_item-platenumber.
        ls_resource-tor_id = ls_root-tor_id.
        SHIFT ls_resource-tor_id LEFT DELETING LEADING '0'.
        APPEND ls_resource TO lt_resource.
        CLEAR ls_resource.
      ENDIF.

*     vehicle ID
      IF ls_item-parent_node_id = ls_root-node_id AND ls_item-res_id IS NOT INITIAL.
        ls_resource-category = cs_tu_type-truck_id.
        ls_resource-value = |{ ls_root-tor_id ALPHA = OUT }{ ls_item-res_id } |.
        CONDENSE ls_resource-value NO-GAPS.
        ls_resource-orginal_value = ls_item-res_id.
        ls_resource-tor_id = ls_root-tor_id.
        SHIFT ls_resource-tor_id LEFT DELETING LEADING '0'.
        APPEND ls_resource TO lt_truck_id.
        CLEAR ls_resource.
      ENDIF.
    ENDLOOP.

    et_plate = lt_resource.
    et_truck_id = lt_truck_id.

  ENDMETHOD.
ENDCLASS.
