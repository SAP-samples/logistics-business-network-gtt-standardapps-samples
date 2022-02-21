INTERFACE zif_gtt_ef_constants
  PUBLIC .

  CONSTANTS:
    BEGIN OF cs_trxcod, " tracking id type
      po_number   TYPE /saptrx/trxcod VALUE 'FT1_PO',
      po_position TYPE /saptrx/trxcod VALUE 'FT1_PO_ITEM',
      dl_number   TYPE /saptrx/trxcod VALUE 'FT1_IN_DELIVERY',
      dl_position TYPE /saptrx/trxcod VALUE 'FT1_IN_DELIVERY_ITEM',
      sh_number   TYPE /saptrx/trxcod VALUE 'FT1_SHIPMENT',
      sh_resource TYPE /saptrx/trxcod VALUE 'FT1_RESOURCE',
      fu_number   TYPE /saptrx/trxcod VALUE 'FT1_FREIGHT_UNIT',
    END OF cs_trxcod .

  CONSTANTS:
    BEGIN OF cs_milestone,

      po_confirmation     TYPE /saptrx/appl_event_tag VALUE 'CONFIRMATION',
      po_goods_receipt    TYPE /saptrx/appl_event_tag VALUE 'GOODS_RECEIPT',
      po_planned_delivery TYPE /saptrx/appl_event_tag VALUE 'PO_PLANNED_DLV',
      po_itm_completed    TYPE /saptrx/appl_event_tag VALUE 'PO_ITEM_COMPLETED',
      po_deletion         TYPE /saptrx/appl_event_tag VALUE 'DELETION',
      po_undeletion       TYPE /saptrx/appl_event_tag VALUE 'UNDELETION',

      dl_item_completed   TYPE /saptrx/appl_event_tag VALUE 'IDLV_IT_COMPLETED',
      dl_put_away         TYPE /saptrx/appl_event_tag VALUE 'PUT_AWAY',
      dl_packing          TYPE /saptrx/appl_event_tag VALUE 'PACKING',
      dl_goods_receipt    TYPE /saptrx/appl_event_tag VALUE 'GOODS_RECEIPT',
      dl_pod              TYPE /saptrx/appl_event_tag VALUE 'SHP_POD',
      dl_planned_delivery TYPE /saptrx/appl_event_tag VALUE 'IDLV_PLANNED_DLV',

      fu_completed        TYPE /saptrx/appl_event_tag VALUE 'FU_COMPLETED',

      sh_check_in         TYPE /saptrx/appl_event_tag VALUE 'CHECK_IN',
      sh_load_start       TYPE /saptrx/appl_event_tag VALUE 'LOAD_BEGIN',
      sh_load_end         TYPE /saptrx/appl_event_tag VALUE 'LOAD_END',
      sh_departure        TYPE /saptrx/appl_event_tag VALUE 'DEPARTURE',
      sh_arrival          TYPE /saptrx/appl_event_tag VALUE 'ARRIV_DEST',
      sh_pod              TYPE /saptrx/appl_event_tag VALUE 'POD',

    END OF cs_milestone .
  CONSTANTS:
    BEGIN OF cs_event_param,
      quantity           TYPE /saptrx/paramname VALUE 'QUANTITY',
      delivery_completed TYPE /saptrx/paramname VALUE 'DELIVERY_COMPLETED',
      full_volume_mode   TYPE /saptrx/paramname VALUE 'FULL_VOLUME_MODE',
      reversal           TYPE /saptrx/paramname VALUE 'REVERSAL_INDICATOR',
      location_id        TYPE /saptrx/paramname VALUE 'LOCATION_ID',
      location_type      TYPE /saptrx/paramname VALUE 'LOCATION_TYPE',
    END OF cs_event_param .

  CONSTANTS:
    BEGIN OF cs_trk_obj_type,
      esc_purord TYPE /saptrx/trk_obj_type VALUE 'ESC_PURORD',
      esc_deliv  TYPE /saptrx/trk_obj_type VALUE 'ESC_DELIV',
      esc_shipmt TYPE /saptrx/trk_obj_type VALUE 'ESC_SHIPMT',
      tms_tor    TYPE /saptrx/trk_obj_type VALUE 'TMS_TOR',
    END OF cs_trk_obj_type .
  CONSTANTS:
    BEGIN OF cs_system_fields,
      actual_bisiness_timezone  TYPE /saptrx/paramname VALUE 'ACTUAL_BUSINESS_TIMEZONE',
      actual_bisiness_datetime  TYPE /saptrx/paramname VALUE 'ACTUAL_BUSINESS_DATETIME',
      actual_technical_timezone TYPE /saptrx/paramname VALUE 'ACTUAL_TECHNICAL_TIMEZONE',
      actual_technical_datetime TYPE /saptrx/paramname VALUE 'ACTUAL_TECHNICAL_DATETIME',
    END OF cs_system_fields .
  CONSTANTS:
    BEGIN OF cs_errors,
      wrong_parameter     TYPE sotr_conc VALUE '1216f03004ce11ebbf450050c2490048',
      cdata_determination TYPE sotr_conc VALUE '1216f03004ce11ebbf460050c2490048',
      table_determination TYPE sotr_conc VALUE '1216f03004ce11ebbf470050c2490048',
      stop_processing     TYPE sotr_conc VALUE '1216f03004ce11ebbf480050c2490048',
    END OF cs_errors .
  CONSTANTS:
    BEGIN OF cs_condition,
      true  TYPE zif_gtt_ef_types=>tv_condition VALUE 'T',
      false TYPE zif_gtt_ef_types=>tv_condition VALUE 'F',
    END OF cs_condition .
  CONSTANTS:
    BEGIN OF cs_change_mode,
      insert    TYPE updkz_d VALUE 'I',
      update    TYPE updkz_d VALUE 'U',
      delete    TYPE updkz_d VALUE 'D',
      undefined TYPE updkz_d VALUE 'T',
    END OF cs_change_mode .
  CONSTANTS:
    BEGIN OF cs_parameter_id,
      key_field    TYPE zif_gtt_ef_types=>tv_parameter_id VALUE 1,
      no_empty_tag TYPE zif_gtt_ef_types=>tv_parameter_id VALUE 2,
    END OF cs_parameter_id .
  CONSTANTS cv_aot TYPE string VALUE 'AOT' ##NO_TEXT.
  CONSTANTS cv_max_end_date TYPE /saptrx/tid_end_date_tsloc VALUE '099991231000000' ##NO_TEXT.
  CONSTANTS cv_structure_pkg TYPE devclass VALUE '/SAPTRX/SCEM_AI_R3' ##NO_TEXT.
  CONSTANTS:
    BEGIN OF cs_loc_types,
      businesspartner  TYPE /saptrx/loc_id_type VALUE 'BusinessPartner' ##NO_TEXT,
      customer         TYPE /saptrx/loc_id_type VALUE 'Customer' ##NO_TEXT,
      logisticlocation TYPE /saptrx/loc_id_type VALUE 'LogisticLocation' ##NO_TEXT,
      plant            TYPE /saptrx/loc_id_type VALUE 'Plant' ##NO_TEXT,
      shippingpoint    TYPE /saptrx/loc_id_type VALUE 'ShippingPoint' ##NO_TEXT,
      supplier         TYPE /saptrx/loc_id_type VALUE 'Supplier' ##NO_TEXT,
    END OF cs_loc_types .
  CONSTANTS:
    BEGIN OF cs_date_types,
      timestamp TYPE char20 VALUE 'TIMESTAMP',
    END OF cs_date_types .
  CONSTANTS:
    BEGIN OF cs_logs,
*               log_name TYPE balnrext VALUE '',
      BEGIN OF object,
        shipment_ctp TYPE balobj_d VALUE 'SAPTRX',
        delivery_ctp TYPE balobj_d VALUE 'SAPTRX',
        tor_ctp      TYPE balobj_d VALUE 'SAPTRX',
      END OF object,
      BEGIN OF subobject,
        shipment_ctp TYPE balsubobj VALUE 'APPSYS',
        delivery_ctp TYPE balsubobj VALUE 'APPSYS',
        tor_ctp      TYPE balsubobj VALUE 'APPSYS',
      END OF subobject,
    END OF cs_logs .
ENDINTERFACE.
