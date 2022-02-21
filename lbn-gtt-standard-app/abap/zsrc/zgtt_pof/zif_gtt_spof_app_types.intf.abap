INTERFACE zif_gtt_spof_app_types
  PUBLIC .


  TYPES ts_uekpo TYPE uekpo .
  TYPES:
    tt_uekpo TYPE STANDARD TABLE OF ts_uekpo .
  TYPES ts_ueket TYPE ueket .
  TYPES:
    tt_ueket TYPE STANDARD TABLE OF ts_ueket .

  TYPES ts_uekes TYPE uekes .
  TYPES:
    tt_uekes TYPE STANDARD TABLE OF ts_uekes .
  TYPES ts_uekko TYPE ekko .
  TYPES:
    tt_uekko TYPE STANDARD TABLE OF ts_uekko .
ENDINTERFACE.
