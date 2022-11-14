INTERFACE zif_gtt_sts_constants
  PUBLIC .


  CONSTANTS:
    BEGIN OF cs_tabledef,
      fo_header_new TYPE /saptrx/strucdatadef VALUE 'TOR_ROOT',
      fo_header_old TYPE /saptrx/strucdatadef VALUE 'TOR_ROOT_BEFORE',
      fo_item_new   TYPE /saptrx/strucdatadef VALUE 'TOR_ITEM',
      fo_item_old   TYPE /saptrx/strucdatadef VALUE 'TOR_ITEM_BEFORE',
      fo_stop_new   TYPE /saptrx/strucdatadef VALUE 'TOR_STOP',
      fo_stop_old   TYPE /saptrx/strucdatadef VALUE 'TOR_STOP_BEFORE',
      fo_stop_addr  TYPE /saptrx/strucdatadef VALUE 'TOR_STOP_ADDR',
      fo_loc_addr   TYPE /saptrx/strucdatadef VALUE 'TOR_LOCATION_ADDR',
    END OF cs_tabledef .
  CONSTANTS:
    BEGIN OF cs_system_fields,
      actual_bisiness_timezone TYPE /saptrx/paramname VALUE 'ACTUAL_BUSINESS_TIMEZONE',
      actual_bisiness_datetime TYPE /saptrx/paramname VALUE 'ACTUAL_BUSINESS_DATETIME',
    END OF cs_system_fields .
  CONSTANTS:
    BEGIN OF cs_trxcod,
      fo_number   TYPE /saptrx/trxcod VALUE 'FT1_SHIPMENT',
      fu_number   TYPE /saptrx/trxcod VALUE 'FT1_FREIGHT_UNIT',
      fo_resource TYPE /saptrx/trxcod VALUE 'FT1_RESOURCE',
      tu_number   TYPE /saptrx/trxcod VALUE 'FT1_TRACKING_UNIT',
    END OF cs_trxcod .
  CONSTANTS:
    BEGIN OF cs_milestone,
      fo_load_start    TYPE /saptrx/appl_event_tag VALUE 'LOAD_BEGIN',
      fo_load_end      TYPE /saptrx/appl_event_tag VALUE 'LOAD_END',
      fo_coupling      TYPE /saptrx/appl_event_tag VALUE 'COUPLING',
      fo_decoupling    TYPE /saptrx/appl_event_tag VALUE 'DECOUPLING',
      fo_shp_departure TYPE /saptrx/appl_event_tag VALUE 'DEPARTURE',
      fo_shp_arrival   TYPE /saptrx/appl_event_tag VALUE 'ARRIV_DEST',
      fo_shp_pod       TYPE /saptrx/appl_event_tag VALUE 'POD',
      fo_unload_start  TYPE /saptrx/appl_event_tag VALUE 'UNLOAD_BEGIN',
      fo_unload_end    TYPE /saptrx/appl_event_tag VALUE 'UNLOAD_END',
      fo_popu          TYPE /saptrx/appl_event_tag VALUE 'POPU',
    END OF cs_milestone .
  CONSTANTS:
    BEGIN OF cs_location_type,
      logistic      TYPE string VALUE 'LogisticLocation',
      shippingpoint TYPE string VALUE 'ShippingPoint',
      customer      TYPE string VALUE 'Customer',
      supplier      TYPE string VALUE 'Supplier',
      bp            TYPE string VALUE 'BusinessPartner',
      plant         TYPE string VALUE 'Plant',
    END OF cs_location_type .
  CONSTANTS:
    BEGIN OF cs_lifecycle_status,
      draft      TYPE /scmtms/tor_lc_status VALUE '00',
      new        TYPE /scmtms/tor_lc_status VALUE '01',
      in_process TYPE /scmtms/tor_lc_status VALUE '02',
      completed  TYPE /scmtms/tor_lc_status VALUE '05',
      canceled   TYPE /scmtms/tor_lc_status VALUE '10',
    END OF cs_lifecycle_status .
  CONSTANTS:
    BEGIN OF cs_execution_status,
      not_relevant               TYPE /scmtms/tor_execution_status VALUE '01',
      not_started                TYPE /scmtms/tor_execution_status VALUE '02',
      in_execution               TYPE /scmtms/tor_execution_status VALUE '03',
      executed                   TYPE /scmtms/tor_execution_status VALUE '04',
      interrupted                TYPE /scmtms/tor_execution_status VALUE '05',
      canceled                   TYPE /scmtms/tor_execution_status VALUE '06',
      ready_for_transp_exec      TYPE /scmtms/tor_execution_status VALUE '07',
      not_ready_for_transp_exec  TYPE /scmtms/tor_execution_status VALUE '08',
      loading_in_process         TYPE /scmtms/tor_execution_status VALUE '09',
      capacity_planning_finished TYPE /scmtms/tor_execution_status VALUE '10',
    END OF cs_execution_status .
  CONSTANTS:
    BEGIN OF cs_track_exec_rel,
      no_execution                TYPE /scmtms/track_exec_rel VALUE '1',
      execution                   TYPE /scmtms/track_exec_rel VALUE '2',
      exec_with_extern_event_mngr TYPE /scmtms/track_exec_rel VALUE '3',
    END OF cs_track_exec_rel .
  CONSTANTS:
    BEGIN OF cs_trmodcod,
      road            TYPE /scmtms/trmodcode VALUE '01',
      rail            TYPE /scmtms/trmodcode VALUE '02',
      sea             TYPE /scmtms/trmodcode VALUE '03',
      inland_waterway TYPE /scmtms/trmodcode VALUE '04',
      air             TYPE /scmtms/trmodcode VALUE '05',
      postal_service  TYPE /scmtms/trmodcode VALUE '06',
      na              TYPE /scmtms/trmodcode VALUE '',
    END OF cs_trmodcod .
  CONSTANTS:
    BEGIN OF cs_uom,
      piece TYPE meins VALUE 'EA',
      km    TYPE meins VALUE 'KM',
    END OF cs_uom .
  CONSTANTS:
    BEGIN OF cs_shipment_type,
      tor TYPE string VALUE 'TOR',
    END OF cs_shipment_type.
  CONSTANTS:
    BEGIN OF cs_mtr,
      road_031 TYPE /scmtms/transmeanstypecode VALUE '0001',
      rail     TYPE /scmtms/transmeanstypecode VALUE '0002',
      air      TYPE /scmtms/transmeanstypecode VALUE '0003',
      mail     TYPE /scmtms/transmeanstypecode VALUE '0004',
      sea      TYPE /scmtms/transmeanstypecode VALUE '0005',
      road_038 TYPE /scmtms/transmeanstypecode VALUE '0006',
    END OF cs_mtr.
  CONSTANTS:
    BEGIN OF cs_btd_type_code,
      bill_of_landing        TYPE /scmtms/btd_type_code VALUE 'T50',
      master_bill_of_landing TYPE /scmtms/btd_type_code VALUE 'T52',
      master_air_waybill     TYPE /scmtms/btd_type_code VALUE 'T55',
      carrier_assigned       TYPE /scmtms/btd_type_code VALUE 'BN',
      purchase_order         TYPE /scmtms/btd_type_code VALUE '001',
      inbound_delivery       TYPE /scmtms/btd_type_code VALUE '58',
      outbound_delivery      TYPE /scmtms/btd_type_code VALUE '73',
      sales_order            TYPE /scmtms/btd_type_code VALUE '114',
    END OF cs_btd_type_code.
  CONSTANTS:
    BEGIN OF cs_text_type,
      cont TYPE /bobf/txc_text_type VALUE 'CONT',
      mobl TYPE /bobf/txc_text_type VALUE 'MOBL',
      epkg TYPE /bobf/txc_text_type VALUE 'EPKG',
    END OF cs_text_type .
  CONSTANTS:
    BEGIN OF cs_tracking_scenario,
      fo_track TYPE zgtt_dte_scenario VALUE '01', "Maintain Reference Document on Freight Order/Freight Booking
      tu_on_fo TYPE zgtt_dte_scenario VALUE '02', "Maintain Tracked Objects on Freight Order/Freight Booking
      tu_on_fu TYPE zgtt_dte_scenario VALUE '03', "Maintain Tracked Objects on Freight Unit
      tu_on_cu TYPE zgtt_dte_scenario VALUE '04', "Maintain Tracked Objects on Container Unit
    END OF cs_tracking_scenario.
  CONSTANTS:
    BEGIN OF cs_separator,
      semicolon type char1 VALUE ';',
    END OF cs_separator.
  CONSTANTS:
    cv_scac_prefix TYPE char5 VALUE 'SCAC#'.
ENDINTERFACE.
