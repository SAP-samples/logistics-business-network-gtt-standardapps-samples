INTERFACE zif_gtt_sts_ef_constants
  PUBLIC .


  CONSTANTS:
    BEGIN OF cs_system_fields,
      actual_bisiness_timezone  TYPE /saptrx/paramname VALUE 'ACTUAL_BUSINESS_TIMEZONE',
      actual_bisiness_datetime  TYPE /saptrx/paramname VALUE 'ACTUAL_BUSINESS_DATETIME',
      actual_technical_timezone TYPE /saptrx/paramname VALUE 'ACTUAL_TECHNICAL_TIMEZONE',
      actual_technical_datetime TYPE /saptrx/paramname VALUE 'ACTUAL_TECHNICAL_DATETIME',
    END OF cs_system_fields .
  CONSTANTS:
    BEGIN OF cs_parameter,
      ref_planned_event_milestone TYPE /saptrx/paramname VALUE 'REF_PLANNED_EVENT_MILESTONE',
      ref_planned_event_locid2    TYPE /saptrx/paramname VALUE 'REF_PLANNED_EVENT_LOCID2',
      ref_planned_event_loctype   TYPE /saptrx/paramname VALUE 'REF_PLANNED_EVENT_LOCTYPE',
      ref_planned_event_locid1    TYPE /saptrx/paramname VALUE 'REF_PLANNED_EVENT_LOCID1',
      estimated_datetime          TYPE /saptrx/paramname VALUE 'ESTIMATED_DATETIME',
      estimated_timezone          TYPE /saptrx/paramname VALUE 'ESTIMATED_TIMEZONE',
      stop_id                     TYPE /saptrx/paramname VALUE 'STOP_ID',
    END OF cs_parameter .
  CONSTANTS cv_logistic_location TYPE string VALUE 'LogisticLocation' ##NO_TEXT.
  CONSTANTS:
    BEGIN OF cs_errors,
      wrong_parameter     TYPE sotr_conc VALUE '1216f03004ce11ebbf450050c2490048',
      cdata_determination TYPE sotr_conc VALUE '1216f03004ce11ebbf460050c2490048',
      table_determination TYPE sotr_conc VALUE '1216f03004ce11ebbf470050c2490048',
      stop_processing     TYPE sotr_conc VALUE '1216f03004ce11ebbf480050c2490048',
    END OF cs_errors .
  CONSTANTS:
    BEGIN OF cs_condition,
      true  TYPE zif_gtt_sts_ef_types=>tv_condition VALUE 'T',
      false TYPE zif_gtt_sts_ef_types=>tv_condition VALUE 'F',
    END OF cs_condition .
  CONSTANTS:
    BEGIN OF cs_change_mode,
      insert    TYPE updkz_d VALUE 'I',
      update    TYPE updkz_d VALUE 'U',
      delete    TYPE updkz_d VALUE 'D',
      undefined TYPE updkz_d VALUE 'T',
    END OF cs_change_mode .
  CONSTANTS cv_aot TYPE string VALUE 'AOT' ##NO_TEXT.
  CONSTANTS cv_max_end_date TYPE /saptrx/tid_end_date_tsloc VALUE '099991231000000' ##NO_TEXT.
ENDINTERFACE.
