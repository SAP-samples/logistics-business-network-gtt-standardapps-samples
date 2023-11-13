interface ZIF_GTT_EF_CONSTANTS
  public .


  constants:
    BEGIN OF cs_trxcod, " tracking id type
      po_number         TYPE /saptrx/trxcod VALUE 'FT1_PO',
      po_position       TYPE /saptrx/trxcod VALUE 'FT1_PO_ITEM',
      dl_number         TYPE /saptrx/trxcod VALUE 'FT1_IN_DELIVERY',
      dl_position       TYPE /saptrx/trxcod VALUE 'FT1_IN_DELIVERY_ITEM',
      sh_number         TYPE /saptrx/trxcod VALUE 'FT1_SHIPMENT',
      sh_resource       TYPE /saptrx/trxcod VALUE 'FT1_RESOURCE',
      fu_number         TYPE /saptrx/trxcod VALUE 'FT1_FREIGHT_UNIT',
      sales_order       TYPE /saptrx/trxcod VALUE 'FT1_SALES_ORDER',
      sales_order_item  TYPE /saptrx/trxcod VALUE 'FT1_SALES_ORDER_ITEM',
      out_delivery      TYPE /saptrx/trxcod VALUE 'FT1_OUT_DELIVERY',
      out_delivery_item TYPE /saptrx/trxcod VALUE 'FT1_ODLV_ITEM',
    END OF cs_trxcod .
  constants:
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

      so_item_completed   TYPE /saptrx/appl_event_tag VALUE 'SO_ITEM_COMPLETED',
      so_planned_dlv      TYPE /saptrx/appl_event_tag VALUE 'SO_PLANNED_DLV',
      dlv_hd_completed    TYPE /saptrx/appl_event_tag VALUE 'ODLV_HD_COMPLETED',
      dlv_item_completed  TYPE /saptrx/appl_event_tag VALUE 'ODLV_IT_COMPLETED',
      dlv_item_pod        TYPE /saptrx/appl_event_tag VALUE 'ODLV_ITEM_POD',
      goods_issue         TYPE /saptrx/appl_event_tag VALUE 'GOODS_ISSUE',
      departure           TYPE /saptrx/appl_event_tag VALUE 'DEPARTURE',
      arriv_dest          TYPE /saptrx/appl_event_tag VALUE 'ARRIV_DEST',
      pod                 TYPE /saptrx/appl_event_tag VALUE 'POD',
      picking             TYPE /saptrx/appl_event_tag VALUE 'PICKING',
      packing             TYPE /saptrx/appl_event_tag VALUE 'PACKING',
      odlv_planned_dlv    TYPE /saptrx/appl_event_tag VALUE 'ODLV_PLANNED_DLV',
    END OF cs_milestone .
  constants:
    BEGIN OF cs_event_param,
      quantity           TYPE /saptrx/paramname VALUE 'QUANTITY',
      delivery_completed TYPE /saptrx/paramname VALUE 'DELIVERY_COMPLETED',
      full_volume_mode   TYPE /saptrx/paramname VALUE 'FULL_VOLUME_MODE',
      reversal           TYPE /saptrx/paramname VALUE 'REVERSAL_INDICATOR',
      location_id        TYPE /saptrx/paramname VALUE 'LOCATION_ID',
      location_type      TYPE /saptrx/paramname VALUE 'LOCATION_TYPE',
    END OF cs_event_param .
  constants:
    BEGIN OF cs_trk_obj_type,
      esc_purord TYPE /saptrx/trk_obj_type VALUE 'ESC_PURORD',
      esc_deliv  TYPE /saptrx/trk_obj_type VALUE 'ESC_DELIV',
      esc_shipmt TYPE /saptrx/trk_obj_type VALUE 'ESC_SHIPMT',
      tms_tor    TYPE /saptrx/trk_obj_type VALUE 'TMS_TOR',
      esc_sorder TYPE /saptrx/trk_obj_type VALUE 'ESC_SORDER',
    END OF cs_trk_obj_type .
  constants:
    BEGIN OF cs_system_fields,
      actual_bisiness_timezone  TYPE /saptrx/paramname VALUE 'ACTUAL_BUSINESS_TIMEZONE',
      actual_bisiness_datetime  TYPE /saptrx/paramname VALUE 'ACTUAL_BUSINESS_DATETIME',
      actual_technical_timezone TYPE /saptrx/paramname VALUE 'ACTUAL_TECHNICAL_TIMEZONE',
      actual_technical_datetime TYPE /saptrx/paramname VALUE 'ACTUAL_TECHNICAL_DATETIME',
      reported_by               TYPE /saptrx/paramname VALUE 'REPORTED_BY',
    END OF cs_system_fields .
  constants:
    BEGIN OF cs_errors,
      wrong_parameter     TYPE sotr_conc VALUE '1216f03004ce11ebbf450050c2490048',
      cdata_determination TYPE sotr_conc VALUE '1216f03004ce11ebbf460050c2490048',
      table_determination TYPE sotr_conc VALUE '1216f03004ce11ebbf470050c2490048',
      stop_processing     TYPE sotr_conc VALUE '1216f03004ce11ebbf480050c2490048',
    END OF cs_errors .
  constants:
    BEGIN OF cs_condition,
      true  TYPE zif_gtt_ef_types=>tv_condition VALUE 'T',
      false TYPE zif_gtt_ef_types=>tv_condition VALUE 'F',
    END OF cs_condition .
  constants:
    BEGIN OF cs_change_mode,
      insert    TYPE updkz_d VALUE 'I',
      update    TYPE updkz_d VALUE 'U',
      delete    TYPE updkz_d VALUE 'D',
      undefined TYPE updkz_d VALUE 'T',
    END OF cs_change_mode .
  constants:
    BEGIN OF cs_parameter_id,
      key_field    TYPE zif_gtt_ef_types=>tv_parameter_id VALUE 1,
      no_empty_tag TYPE zif_gtt_ef_types=>tv_parameter_id VALUE 2,
    END OF cs_parameter_id .
  constants CV_AOT type STRING value 'AOT' ##NO_TEXT.
  constants CV_STRUCTURE_PKG type DEVCLASS value '/SAPTRX/SCEM_AI_R3' ##NO_TEXT.
  constants:
    BEGIN OF cs_loc_types,
      businesspartner  TYPE /saptrx/loc_id_type VALUE 'BusinessPartner' ##NO_TEXT,
      customer         TYPE /saptrx/loc_id_type VALUE 'Customer' ##NO_TEXT,
      logisticlocation TYPE /saptrx/loc_id_type VALUE 'LogisticLocation' ##NO_TEXT,
      plant            TYPE /saptrx/loc_id_type VALUE 'Plant' ##NO_TEXT,
      shippingpoint    TYPE /saptrx/loc_id_type VALUE 'ShippingPoint' ##NO_TEXT,
      supplier         TYPE /saptrx/loc_id_type VALUE 'Supplier' ##NO_TEXT,
    END OF cs_loc_types .
  constants:
    BEGIN OF cs_date_types,
      timestamp TYPE char20 VALUE 'TIMESTAMP',
    END OF cs_date_types .
  constants:
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
* combinations of address indicator
  CONSTANTS:
    vbpa_addr_ind_man_all TYPE char04 VALUE 'BCEF',
    shp_addr_ind_man_all  TYPE char03 VALUE 'BCD'.
endinterface.
