INTERFACE zif_gtt_sof_ctp_types
  PUBLIC .


  TYPES:
    BEGIN OF ts_fu_list,
      tor_id        TYPE /scmtms/tor_id,
      item_id       TYPE /scmtms/item_id,
      quantity      TYPE menge_d,
      quantityuom   TYPE meins,
      product_id    TYPE /scmtms/product_id,
      product_descr TYPE /scmtms/item_description,
      change_mode   TYPE /bobf/conf_change_mode,
    END OF ts_fu_list .
  TYPES:
    tt_fu_list  TYPE STANDARD TABLE OF ts_fu_list
                       WITH EMPTY KEY .
  TYPES:
    BEGIN OF ts_delivery_item,
      vbeln   TYPE vbeln_vl,
      posnr   TYPE posnr_vl,
      likp    TYPE likpvb,
      lips    TYPE lipsvb,
      vbuk    TYPE vbukvb,
      vbup    TYPE vbupvb,
      vbfa    TYPE STANDARD TABLE OF vbfavb WITH EMPTY KEY,
      fu_list TYPE tt_fu_list,
    END OF ts_delivery_item .
  TYPES:
    tt_delivery_item TYPE STANDARD TABLE OF ts_delivery_item
                            WITH EMPTY KEY .
  TYPES:
    BEGIN OF ts_delivery,
      vbeln        TYPE vbeln_vl,
      fu_relevant  TYPE abap_bool,
      pod_relevant TYPE abap_bool,
      likp         TYPE likpvb,
      lips         TYPE STANDARD TABLE OF lipsvb WITH EMPTY KEY,
      vbuk         TYPE STANDARD TABLE OF vbukvb WITH EMPTY KEY,
      vbup         TYPE STANDARD TABLE OF vbupvb WITH EMPTY KEY,
      vbfa         TYPE STANDARD TABLE OF vbfavb WITH EMPTY KEY,
    END OF ts_delivery .
  TYPES:
    tt_delivery TYPE STANDARD TABLE OF ts_delivery .
  TYPES:
    BEGIN OF ts_delivery_chng,
      vbeln         TYPE vbeln_vl,
      posnr         TYPE posnr_vl,
      tor_id        TYPE /scmtms/tor_id,
      item_id       TYPE /scmtms/item_id,
      quantity      TYPE /scmtms/qua_pcs_val,
      quantityuom   TYPE /scmtms/qua_pcs_uni,
      product_id    TYPE /scmtms/product_id,
      product_descr TYPE /scmtms/item_description,
      change_mode   TYPE /bobf/conf_change_mode,
    END OF ts_delivery_chng .
  TYPES:
    tt_delivery_chng TYPE SORTED TABLE OF ts_delivery_chng
                            WITH UNIQUE KEY vbeln posnr tor_id .
  TYPES:
    tt_tor_type TYPE SORTED TABLE OF /scmtms/tor_type
                       WITH UNIQUE KEY table_line .
  TYPES:
    BEGIN OF ty_aotype,
      tor_type TYPE /scmtms/tor_type,
      aotype   TYPE /saptrx/aotype,
    END OF ty_aotype .
  TYPES:
    tt_aottype TYPE SORTED TABLE OF ty_aotype
                      WITH UNIQUE KEY tor_type .
  TYPES:
    BEGIN OF ty_aotype_item,
      obj_type TYPE /saptrx/trk_obj_type,
      aot_type TYPE /saptrx/aotype,
    END OF ty_aotype_item .
  TYPES:
    tt_aotype_item TYPE TABLE OF ty_aotype_item .
  TYPES:
    BEGIN OF ty_aotypes_new,
      trk_obj_type  TYPE /saptrx/aotypes-trk_obj_type,
      aotype        TYPE /saptrx/aotypes-aotype,
      trxservername TYPE /saptrx/aotypes-trxservername,
    END OF ty_aotypes_new .
  TYPES:
    tt_aotypes_new TYPE TABLE OF ty_aotypes_new .
  TYPES:
    BEGIN OF ty_trxserv,
      trx_server_id TYPE /saptrx/trxserv-trx_server_id,
      trx_server    TYPE /saptrx/trxserv-trx_server,
    END OF ty_trxserv .
  TYPES:
    tt_trxserv TYPE TABLE OF ty_trxserv .
  TYPES:
    BEGIN OF ty_likp,
      vbeln TYPE likp-vbeln, "Delivery
      kodat TYPE likp-kodat, "Picking Date
      kouhr TYPE likp-kouhr, "Picking Time (Local Time, with Reference to a Plant)
      vstel TYPE likp-vstel, "Shipping Point / Receiving Point
      wadat TYPE likp-wadat, "Planned Goods Movement Date
      wauhr TYPE likp-wauhr, "Time of Goods Issue (Local, Relating to a Plant)
      kunnr TYPE likp-kunnr, "Ship-to Party
    END OF ty_likp .
  TYPES:
    tt_likp TYPE TABLE OF ty_likp .
  TYPES:
    tt_aotype_rst   TYPE RANGE OF /saptrx/aotype .
  TYPES:
    tt_tor_type_rst TYPE RANGE OF /scmtms/tor_type .
  TYPES:
    BEGIN OF ts_lipsvb_key,
      vbeln TYPE vbeln_vl,
      posnr TYPE posnr_vl,
    END OF ts_lipsvb_key .
  TYPES:
    tt_lipsvb_key TYPE STANDARD TABLE OF ts_lipsvb_key .
  TYPES:
    BEGIN OF ts_aotype,
      obj_type    TYPE /saptrx/trk_obj_type,
      aot_type    TYPE /saptrx/aotype,
      server_name TYPE /saptrx/trxservername,
    END OF ts_aotype .
  TYPES:
    tt_aotype TYPE STANDARD TABLE OF ts_aotype WITH EMPTY KEY .
  TYPES ts_lipsvb TYPE lipsvb .
  TYPES:
    tt_lipsvb TYPE STANDARD TABLE OF ts_lipsvb .
  TYPES:
    tt_trxas_appobj_ctab TYPE STANDARD TABLE OF trxas_appobj_ctab_wa
                                WITH EMPTY KEY .
  TYPES:
    BEGIN OF ts_idoc_data,
      control      TYPE /saptrx/bapi_trk_control_tab,
      info         TYPE /saptrx/bapi_trk_info_tab,
      tracking_id  TYPE /saptrx/bapi_trk_trkid_tab,
      exp_event    TYPE /saptrx/bapi_trk_ee_tab,
      trxserv      TYPE /saptrx/trxserv,
      appsys       TYPE logsys,
      appobj_ctabs TYPE tt_trxas_appobj_ctab,
    END OF ts_idoc_data .
  TYPES:
    tt_idoc_data TYPE STANDARD TABLE OF ts_idoc_data
                   WITH EMPTY KEY .
  TYPES:
    tt_trk_obj_type TYPE STANDARD TABLE OF /saptrx/trk_obj_type
                           WITH EMPTY KEY .
  TYPES:
    BEGIN OF ts_fu_id,
      tor_id TYPE /scmtms/tor_id,
    END OF ts_fu_id .
  TYPES:
    tt_fu_id  TYPE STANDARD TABLE OF ts_fu_id
                       WITH EMPTY KEY .
ENDINTERFACE.
