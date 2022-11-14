INTERFACE zif_gtt_mia_app_constants
  PUBLIC .


  CONSTANTS:
    BEGIN OF cs_tabledef,
      md_material_header  TYPE /saptrx/strucdatadef VALUE 'MATERIAL_HEADER',
      md_material_segment TYPE /saptrx/strucdatadef VALUE 'MATERIAL_SEGMENT',
      md_update_control   TYPE /saptrx/strucdatadef VALUE 'UPDATE_CONTROL',
      dl_header_new       TYPE /saptrx/strucdatadef VALUE 'DELIVERY_HEADER_NEW',
      dl_header_old       TYPE /saptrx/strucdatadef VALUE 'DELIVERY_HEADER_OLD',
      dl_hdr_status_new   TYPE /saptrx/strucdatadef VALUE 'DELIVERY_HDR_STATUS_NEW',
      dl_hdr_status_old   TYPE /saptrx/strucdatadef VALUE 'DELIVERY_HDR_STATUS_OLD',
      dl_item_new         TYPE /saptrx/strucdatadef VALUE 'DELIVERY_ITEM_NEW',
      dl_item_old         TYPE /saptrx/strucdatadef VALUE 'DELIVERY_ITEM_OLD',
      dl_partners_new     TYPE /saptrx/strucdatadef VALUE 'PARTNERS_NEW',
      dl_partners_old     TYPE /saptrx/strucdatadef VALUE 'PARTNERS_OLD',
      dl_itm_status_new   TYPE /saptrx/strucdatadef VALUE 'DELIVERY_ITEM_STATUS_NEW',
      dl_itm_status_old   TYPE /saptrx/strucdatadef VALUE 'DELIVERY_ITEM_STATUS_OLD',
      dl_hu_item_new      TYPE /saptrx/strucdatadef VALUE 'HU_ITEM_NEW',
      dl_hu_item_old      TYPE /saptrx/strucdatadef VALUE 'HU_ITEM_OLD',
      sh_header_new       TYPE /saptrx/strucdatadef VALUE 'SHIPMENT_HEADER_NEW',
      sh_header_old       TYPE /saptrx/strucdatadef VALUE 'SHIPMENT_HEADER_OLD',
      sh_item_new         TYPE /saptrx/strucdatadef VALUE 'SHIPMENT_ITEM_NEW',
      sh_item_old         TYPE /saptrx/strucdatadef VALUE 'SHIPMENT_ITEM_OLD',
      sh_stage_new        TYPE /saptrx/strucdatadef VALUE 'SHIPMENT_LEG_NEW',
      sh_stage_old        TYPE /saptrx/strucdatadef VALUE 'SHIPMENT_LEG_OLD',
      sh_item_stage_new   TYPE /saptrx/strucdatadef VALUE 'SHIPMENT_ITEM_LEG_NEW',
      sh_item_stage_old   TYPE /saptrx/strucdatadef VALUE 'SHIPMENT_ITEM_LEG_OLD',
      sh_delivery_header  TYPE /saptrx/strucdatadef VALUE 'DELIVERY_HEADER',
      sh_delivery_item    TYPE /saptrx/strucdatadef VALUE 'DELIVERY_ITEM',
    END OF cs_tabledef .

  CONSTANTS:
    BEGIN OF cs_delivery_stat,
      not_relevant    TYPE wbsta VALUE '',
      not_processed   TYPE wbsta VALUE 'A',
      partially_proc  TYPE wbsta VALUE 'B',
      completely_proc TYPE wbsta VALUE 'C',
    END OF cs_delivery_stat .
  CONSTANTS:
    BEGIN OF cs_md_type,
      goods_receipt TYPE mkpf-blart VALUE 'WE',
    END OF cs_md_type .
  CONSTANTS:
    BEGIN OF cs_parvw,
      supplier TYPE parvw VALUE 'LF',
    END OF cs_parvw .
  CONSTANTS:
    BEGIN OF cs_adrtype,
      organization TYPE ad_adrtype VALUE '1',
    END OF cs_adrtype .
  CONSTANTS:
    BEGIN OF cs_loccat,
      departure TYPE zif_gtt_mia_app_types=>tv_loccat VALUE 'S',
      arrival   TYPE zif_gtt_mia_app_types=>tv_loccat VALUE 'D',
    END OF cs_loccat .
  CONSTANTS:
    BEGIN OF cs_vbtyp,
      shipment TYPE vbtyp VALUE '8',
      delivery TYPE vbtyp VALUE '7',
    END OF cs_vbtyp .
  CONSTANTS:
    BEGIN OF cs_abfer,
      loaded_inb_ship  TYPE abfer VALUE '2',
      empty_inb_ship   TYPE abfer VALUE '4',
      loaded_outb_ship TYPE abfer VALUE '1', "Loaded outbound shipment
      empty_outb_ship  TYPE abfer VALUE '3', "Empty outbound shipment
    END OF cs_abfer .
  CONSTANTS:
    BEGIN OF cs_base_btd_tco,
      inb_dlv  TYPE /scmtms/base_btd_tco VALUE '58',
      outb_dlv TYPE /scmtms/base_btd_tco VALUE '73',
    END OF cs_base_btd_tco .
  CONSTANTS:
    BEGIN OF cs_start_evtcnt,
      shipment TYPE i VALUE 2000000000,
      delivery TYPE i VALUE 2100000000,
    END OF cs_start_evtcnt .
  CONSTANTS cv_agent_id_type TYPE bu_id_type VALUE 'LBN001' ##NO_TEXT.
  CONSTANTS:
    cv_agent_id_prefix TYPE c LENGTH 4 VALUE 'LBN#' ##NO_TEXT.
  CONSTANTS:
    cv_scac_prefix TYPE char5 VALUE 'SCAC#'.
  CONSTANTS:
    BEGIN OF cs_shipment_kind,
      shipment TYPE zif_gtt_mia_app_types=>tv_shipment_kind VALUE 'SHP',
    END OF cs_shipment_kind.
ENDINTERFACE.
