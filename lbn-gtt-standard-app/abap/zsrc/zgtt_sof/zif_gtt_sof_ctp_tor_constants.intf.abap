INTERFACE zif_gtt_sof_ctp_tor_constants
  PUBLIC .


  CONSTANTS cv_base_btd_tco_inb_dlv TYPE /scmtms/base_btd_tco VALUE '58' ##NO_TEXT.
  CONSTANTS cv_base_btd_tco_outb_dlv TYPE /scmtms/base_btd_tco VALUE '73' ##NO_TEXT.
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
  CONSTANTS cv_structure_pkg TYPE devclass VALUE '/SAPTRX/SCEM_AI_R3' ##NO_TEXT.
  CONSTANTS:
    BEGIN OF cs_tabledef,
      dl_header_new          TYPE /saptrx/strucdatadef VALUE 'DELIVERY_HEADER_NEW',
      dl_header_old          TYPE /saptrx/strucdatadef VALUE 'DELIVERY_HEADER_OLD',
      dl_item_new            TYPE /saptrx/strucdatadef VALUE 'DELIVERY_ITEM_NEW',
      dl_item_old            TYPE /saptrx/strucdatadef VALUE 'DELIVERY_ITEM_OLD',
      delivery_hdrstatus_new TYPE /saptrx/strucdatadef VALUE 'DELIVERY_HDR_STATUS_NEW',
      delivery_item_stat_new TYPE /saptrx/strucdatadef VALUE 'DELIVERY_ITEM_STATUS_NEW',
      document_flow_new      TYPE /saptrx/strucdatadef VALUE 'DOCUMENT_FLOW_NEW',
    END OF cs_tabledef .
  CONSTANTS:
    BEGIN OF cs_system_fields,
      actual_bisiness_timezone  TYPE /saptrx/paramname VALUE 'ACTUAL_BUSINESS_TIMEZONE',
      actual_bisiness_datetime  TYPE /saptrx/paramname VALUE 'ACTUAL_BUSINESS_DATETIME',
      actual_technical_timezone TYPE /saptrx/paramname VALUE 'ACTUAL_TECHNICAL_TIMEZONE',
      actual_technical_datetime TYPE /saptrx/paramname VALUE 'ACTUAL_TECHNICAL_DATETIME',
    END OF cs_system_fields .
  CONSTANTS:
    BEGIN OF cs_trk_obj_type,
      esc_purord TYPE /saptrx/trk_obj_type VALUE 'ESC_PURORD',
      esc_deliv  TYPE /saptrx/trk_obj_type VALUE 'ESC_DELIV',
      esc_shipmt TYPE /saptrx/trk_obj_type VALUE 'ESC_SHIPMT',
      tms_tor    TYPE /saptrx/trk_obj_type VALUE 'TMS_TOR',
    END OF cs_trk_obj_type .
  CONSTANTS:
    BEGIN OF cs_date_types,
      timestamp TYPE char20 VALUE 'TIMESTAMP',
    END OF cs_date_types .
ENDINTERFACE.
