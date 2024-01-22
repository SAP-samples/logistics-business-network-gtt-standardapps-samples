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
      carrierreferenceno     TYPE /scmtms/btd_type_code VALUE 'T67',
      purchase_order         TYPE /scmtms/btd_type_code VALUE '001',
      inbound_delivery       TYPE /scmtms/btd_type_code VALUE '58',
      outbound_delivery      TYPE /scmtms/btd_type_code VALUE '73',
      sales_order            TYPE /scmtms/btd_type_code VALUE '114',
      stock_transport_order  TYPE /scmtms/btd_type_code VALUE 'STO',
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
  CONSTANTS:
    BEGIN OF sc_tor_event,  "TOR Events
      scheduled           TYPE /scmtms/tor_event VALUE 'SCHEDULED', "#EC NOTEXT
      cancel              TYPE /scmtms/tor_event VALUE 'CANCEL', "#EC NOTEXT
      cancel_unassign_fus TYPE /scmtms/tor_event VALUE 'CANCEL_UNASSIGN_FUS', "#EC NOTEXT
      cancel_status_reset TYPE /scmtms/tor_event VALUE 'CANCEL_STATUS_RESET', "#EC NOTEXT
      cancel_exec_doc     TYPE /scmtms/tor_event VALUE 'CANCEL_EXEC_DOC', "#EC NOTEXT
      load_begin          TYPE /scmtms/tor_event VALUE 'LOAD_BEGIN', "#EC NOTEXT
      load_end            TYPE /scmtms/tor_event VALUE 'LOAD_END', "#EC NOTEXT
      unload_begin        TYPE /scmtms/tor_event VALUE 'UNLOAD_BEGIN', "#EC NOTEXT
      unload_end          TYPE /scmtms/tor_event VALUE 'UNLOAD_END', "#EC NOTEXT
      ready_load          TYPE /scmtms/tor_event VALUE 'READY_LOAD', "#EC NOTEXT
      ready_unload        TYPE /scmtms/tor_event VALUE 'READY_UNLOAD', "#EC NOTEXT
      departure           TYPE /scmtms/tor_event VALUE 'DEPARTURE', "#EC NOTEXT
      arriv_dest          TYPE /scmtms/tor_event VALUE 'ARRIV_DEST', "#EC NOTEXT
      damage              TYPE /scmtms/tor_event VALUE 'DAMAGE', "#EC NOTEXT
      delay               TYPE /scmtms/tor_event VALUE 'DELAYED', "#EC NOTEXT
      delay_fu            TYPE /scmtms/tor_event VALUE 'DELAYED_FU', "#EC NOTEXT
      remove              TYPE /scmtms/tor_event VALUE 'REMOVE_TRQ_ASSIGN', "#EC NOTEXT
      pod                 TYPE /scmtms/tor_event VALUE 'POD', "#EC NOTEXT
      popu                TYPE /scmtms/tor_event VALUE 'POPU', "#EC NOTEXT
      ready_for_wh_proc   TYPE /scmtms/tor_event VALUE 'READY_FOR_WH_PROC', "#EC NOTEXT
      ready_for_execution TYPE /scmtms/tor_event VALUE 'READY_FOR_EXECUTION', "#EC NOTEXT
      clear_customs       TYPE /scmtms/tor_event VALUE 'CLEAR_CUSTOMS', "#EC NOTEXT
      block_for_exec      TYPE /scmtms/tor_event VALUE 'BLOCK_FOR_EXEC', "#EC NOTEXT
      unblock_for_exec    TYPE /scmtms/tor_event VALUE 'UNBLOCK_FOR_EXEC', "#EC NOTEXT
      report_quantity     TYPE /scmtms/tor_event VALUE 'REPORT_QUANTITY', "#EC NOTEXT
      report_vgm          TYPE /scmtms/tor_event VALUE 'REPORT_VGM', "#EC NOTEXT
      recall_event        TYPE /scmtms/tor_event VALUE 'RECALL_EVENT', "#EC NOTEXT
      gen_discrepancy     TYPE /scmtms/tor_event VALUE 'GEN_DISCRP', "#EC NOTEXT
      item_delivery       TYPE /scmtms/tor_event VALUE 'ITEM_DELIVERY', "#EC NOTEXT
      ee_modify           TYPE /scmtms/tor_event VALUE 'EE_MODIFY', "#EC NOTEXT
      coupling            TYPE /scmtms/tor_event VALUE 'COUPLING', "#EC NOTEXT
      decoupling          TYPE /scmtms/tor_event VALUE 'DECOUPLING', "#EC NOTEXT
      check_out           TYPE /scmtms/tor_event VALUE 'CHECK_OUT', "#EC NOTEXT
      check_in            TYPE /scmtms/tor_event VALUE 'CHECK_IN', "#EC NOTEXT
      arrival_door        TYPE /scmtms/tor_event VALUE 'ARRIVAL_DOOR', "#EC NOTEXT
      departure_door      TYPE /scmtms/tor_event VALUE 'DEPARTURE_DOOR', "#EC NOTEXT
      etd                 TYPE /scmtms/tor_event VALUE 'EXPECTED_DEPARTURE', "#EC NOTEXT
      eta                 TYPE /scmtms/tor_event VALUE 'EXPECTED_ARRIVAL', "#EC NOTEXT
      rep_emival_doc      TYPE /scmtms/tor_event VALUE 'REPORT_EMIVAL_DOC', "#EC NOTEXT
      rep_emival_stage    TYPE /scmtms/tor_event VALUE 'REPORT_EMIVAL_STAGE', "#EC NOTEXT
      " event codes for event first processing
      ep_arrival          TYPE /scmtms/tor_event VALUE 'EP_ARRIVAL', "#EC NOTEXT
      ep_departure        TYPE /scmtms/tor_event VALUE 'EP_DEPARTURE', "#EC NOTEXT
      ep_check_in         TYPE /scmtms/tor_event VALUE 'EP_CHECK_IN', "#EC NOTEXT
      ep_check_out        TYPE /scmtms/tor_event VALUE 'EP_CHECK_OUT', "#EC NOTEXT
      ep_load_begin       TYPE /scmtms/tor_event VALUE 'EP_LOAD_BEGIN', "#EC NOTEXT
      ep_load_end         TYPE /scmtms/tor_event VALUE 'EP_LOAD_END', "#EC NOTEXT
      ep_unload_begin     TYPE /scmtms/tor_event VALUE 'EP_UNLOAD_BEGIN', "#EC NOTEXT
      ep_unload_end       TYPE /scmtms/tor_event VALUE 'EP_UNLOAD_END', "#EC NOTEXT
      ep_load_end_item    TYPE /scmtms/tor_event VALUE 'EP_LOAD_END_ITEM', "#EC NOTEXT
      ep_unload_end_item  TYPE /scmtms/tor_event VALUE 'EP_UNLOAD_END_ITEM', "#EC NOTEXT
    END OF sc_tor_event .
ENDINTERFACE.
