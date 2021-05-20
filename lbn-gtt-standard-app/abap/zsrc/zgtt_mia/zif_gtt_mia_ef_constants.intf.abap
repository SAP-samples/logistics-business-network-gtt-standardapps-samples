INTERFACE zif_gtt_mia_ef_constants
  PUBLIC .


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
      true  TYPE zif_gtt_mia_ef_types=>tv_condition VALUE 'T',
      false TYPE zif_gtt_mia_ef_types=>tv_condition VALUE 'F',
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
      key_field    TYPE zif_gtt_mia_ef_types=>tv_parameter_id VALUE 1,
      no_empty_tag TYPE zif_gtt_mia_ef_types=>tv_parameter_id VALUE 2,
    END OF cs_parameter_id .
  CONSTANTS cv_aot TYPE string VALUE 'AOT' ##NO_TEXT.
  CONSTANTS cv_max_end_date TYPE /saptrx/tid_end_date_tsloc VALUE '099991231000000' ##NO_TEXT.
  CONSTANTS cv_structure_pkg TYPE devclass VALUE '/SAPTRX/SCEM_AI_R3' ##NO_TEXT.
  CONSTANTS:
    BEGIN OF cs_loc_types,
      BusinessPartner  TYPE /saptrx/loc_id_type VALUE 'BusinessPartner' ##NO_TEXT,
      Customer         TYPE /saptrx/loc_id_type VALUE 'Customer' ##NO_TEXT,
      LogisticLocation TYPE /saptrx/loc_id_type VALUE 'LogisticLocation' ##NO_TEXT,
      Plant            TYPE /saptrx/loc_id_type VALUE 'Plant' ##NO_TEXT,
      ShippingPoint    TYPE /saptrx/loc_id_type VALUE 'ShippingPoint' ##NO_TEXT,
      Supplier         TYPE /saptrx/loc_id_type VALUE 'Supplier' ##NO_TEXT,
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
