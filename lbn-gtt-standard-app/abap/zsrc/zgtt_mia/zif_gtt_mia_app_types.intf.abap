INTERFACE zif_gtt_mia_app_types
  PUBLIC .


  TYPES ts_likpvb TYPE likp .
  TYPES:
    tt_likpvb TYPE STANDARD TABLE OF ts_likpvb .
  TYPES ts_lipsvb TYPE lipsvb .
  TYPES:
    tt_lipsvb TYPE STANDARD TABLE OF ts_lipsvb .
  TYPES ts_vttkvb TYPE vttkvb .
  TYPES:
    tt_vttkvb TYPE STANDARD TABLE OF ts_vttkvb .
  TYPES ts_vttpvb TYPE vttpvb .
  TYPES:
    tt_vttpvb TYPE STANDARD TABLE OF ts_vttpvb .
  TYPES ts_vttsvb TYPE vttsvb .
  TYPES:
    tt_vttsvb TYPE STANDARD TABLE OF ts_vttsvb .
  TYPES ts_vtspvb TYPE vtspvb .
  TYPES:
    tt_vtspvb TYPE STANDARD TABLE OF ts_vtspvb .
  TYPES ts_mseg TYPE mseg .
  TYPES:
    tt_mseg TYPE STANDARD TABLE OF ts_mseg .
  TYPES:
    BEGIN OF ts_lipsvb_key,
      vbeln TYPE vbeln_vl,
      posnr TYPE posnr_vl,
    END OF ts_lipsvb_key .
  TYPES:
    tt_lipsvb_key TYPE STANDARD TABLE OF ts_lipsvb_key .
  TYPES tv_ship_type TYPE char2 .
  TYPES tv_trans_mode TYPE char2 .
  TYPES tv_departure_dt TYPE timestamp .
  TYPES tv_departure_tz TYPE timezone .
  TYPES tv_arrival_dt TYPE timestamp .
  TYPES tv_arrival_tz TYPE timezone .
  TYPES tv_deliv_cnt TYPE int4 .
  TYPES tv_trobj_res_id TYPE char12 .
  TYPES tv_trobj_res_val TYPE char20 .
  TYPES tv_resrc_cnt TYPE int4 .
  TYPES tv_resrc_tp_id TYPE char30 .
  TYPES tv_crdoc_ref_typ TYPE char3 .
  TYPES tv_crdoc_ref_val TYPE tndr_trkid .
  TYPES tv_stopnum TYPE int4 .
  TYPES tv_stopid TYPE char255 .
  TYPES tv_stopcnt TYPE int4 .
  TYPES tv_loccat TYPE char1 .
  TYPES tv_loctype TYPE char20 .
  TYPES tv_locid TYPE char10 .
  TYPES tv_lstelz_txt TYPE char20 .
  TYPES tv_kunablaz_txt TYPE char25 .
  TYPES tv_lgortaz_txt TYPE char16 .
  TYPES tv_lgnumaz TYPE char3 .
  TYPES tv_toraz TYPE char3 .
  TYPES tv_lgtraz_txt TYPE char50 .
  TYPES tv_tsrfo TYPE num4 .
  TYPES tv_pln_evt_datetime TYPE timestamp .
  TYPES tv_pln_evt_timezone TYPE char6 .
  TYPES:
    BEGIN OF ts_stops,
      stopid           TYPE tv_stopid,
      stopcnt          TYPE tv_stopcnt,
      loccat           TYPE tv_loccat,
      loctype          TYPE tv_loctype,
      locid            TYPE tv_locid,
      lstelz_txt       TYPE tv_lstelz_txt,
      kunablaz_txt     TYPE tv_kunablaz_txt,
      lgortaz_txt      TYPE tv_lgortaz_txt,
      lgnumaz          TYPE tv_lgnumaz,
      toraz            TYPE tv_toraz,
      lgtraz_txt       TYPE tv_lgtraz_txt,
      tknum            TYPE tknum,
      tsnum            TYPE tsnum,
      tsrfo            TYPE tsrfo,
      pln_evt_datetime TYPE timestamp,
      pln_evt_timezone TYPE timezone,
    END OF ts_stops .
  TYPES:
    tt_stops TYPE STANDARD TABLE OF ts_stops
                    WITH EMPTY KEY .
  TYPES:
    BEGIN OF ts_dlv_watch_stops,
      vbeln  TYPE vbeln_vl,
      stopid TYPE tv_stopid,
      loccat TYPE tv_loccat,
    END OF ts_dlv_watch_stops .
  TYPES:
    tt_dlv_watch_stops TYPE STANDARD TABLE OF ts_dlv_watch_stops
                              WITH EMPTY KEY .

  TYPES:
    tv_shipment_kind TYPE char5.
ENDINTERFACE.
