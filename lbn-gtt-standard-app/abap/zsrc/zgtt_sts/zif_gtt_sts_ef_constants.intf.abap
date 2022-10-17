interface ZIF_GTT_STS_EF_CONSTANTS
  public .


  constants:
    BEGIN OF cs_system_fields,
      actual_bisiness_timezone  TYPE /saptrx/paramname VALUE 'ACTUAL_BUSINESS_TIMEZONE',
      actual_bisiness_datetime  TYPE /saptrx/paramname VALUE 'ACTUAL_BUSINESS_DATETIME',
      actual_technical_timezone TYPE /saptrx/paramname VALUE 'ACTUAL_TECHNICAL_TIMEZONE',
      actual_technical_datetime TYPE /saptrx/paramname VALUE 'ACTUAL_TECHNICAL_DATETIME',
      reported_by               TYPE /saptrx/paramname VALUE 'REPORTED_BY',
    END OF cs_system_fields .
  constants:
    BEGIN OF cs_parameter,
      ref_planned_event_milestone TYPE /saptrx/paramname VALUE 'REF_PLANNED_EVENT_MILESTONE',
      ref_planned_event_locid2    TYPE /saptrx/paramname VALUE 'REF_PLANNED_EVENT_LOCID2',
      ref_planned_event_loctype   TYPE /saptrx/paramname VALUE 'REF_PLANNED_EVENT_LOCTYPE',
      ref_planned_event_locid1    TYPE /saptrx/paramname VALUE 'REF_PLANNED_EVENT_LOCID1',
      estimated_datetime          TYPE /saptrx/paramname VALUE 'ESTIMATED_DATETIME',
      estimated_timezone          TYPE /saptrx/paramname VALUE 'ESTIMATED_TIMEZONE',
      stop_id                     TYPE /saptrx/paramname VALUE 'STOP_ID',
      additional_match_key        TYPE /saptrx/paramname VALUE 'ADDITIONAL_MATCH_KEY',
    END OF cs_parameter .
  constants CV_LOGISTIC_LOCATION type STRING value 'LogisticLocation' ##NO_TEXT.
  constants:
    BEGIN OF cs_errors,
      wrong_parameter     TYPE sotr_conc VALUE '1216f03004ce11ebbf450050c2490048',
      cdata_determination TYPE sotr_conc VALUE '1216f03004ce11ebbf460050c2490048',
      table_determination TYPE sotr_conc VALUE '1216f03004ce11ebbf470050c2490048',
      stop_processing     TYPE sotr_conc VALUE '1216f03004ce11ebbf480050c2490048',
    END OF cs_errors .
  constants:
    BEGIN OF cs_condition,
      true  TYPE zif_gtt_sts_ef_types=>tv_condition VALUE 'T',
      false TYPE zif_gtt_sts_ef_types=>tv_condition VALUE 'F',
    END OF cs_condition .
  constants:
    BEGIN OF cs_change_mode,
      insert    TYPE updkz_d VALUE 'I',
      update    TYPE updkz_d VALUE 'U',
      delete    TYPE updkz_d VALUE 'D',
      undefined TYPE updkz_d VALUE 'T',
    END OF cs_change_mode .
  constants CV_AOT type STRING value 'AOT' ##NO_TEXT.
  constants:
    BEGIN OF cs_version,
      gtt10 TYPE /saptrx/em_version VALUE 'GTT1.0',
      gtt20 TYPE /saptrx/em_version VALUE 'GTT2.0',
    END OF cs_version .
endinterface.
