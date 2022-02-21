INTERFACE zif_gtt_spof_app_constants
  PUBLIC .


  CONSTANTS:
    BEGIN OF cs_tabledef,
      po_header_new       TYPE /saptrx/strucdatadef VALUE 'PURCHASE_ORDER_HEADER_NEW',
      po_header_old       TYPE /saptrx/strucdatadef VALUE 'PURCHASE_ORDER_HEADER_OLD',
      po_item_new         TYPE /saptrx/strucdatadef VALUE 'PURCHASE_ITEM_NEW',
      po_item_old         TYPE /saptrx/strucdatadef VALUE 'PURCHASE_ITEM_OLD',
      po_sched_new        TYPE /saptrx/strucdatadef VALUE 'PO_SCHED_LINE_ITEM_NEW',
      po_sched_old        TYPE /saptrx/strucdatadef VALUE 'PO_SCHED_LINE_ITEM_OLD',
      po_vend_conf_new    TYPE /saptrx/strucdatadef VALUE 'VENDOR_CONFIRMATION_NEW',
      po_vend_conf_old    TYPE /saptrx/strucdatadef VALUE 'VENDOR_CONFIRMATION_OLD',
      md_material_segment TYPE /saptrx/strucdatadef VALUE 'MATERIAL_SEGMENT',
      md_material_header  TYPE /saptrx/strucdatadef VALUE 'MATERIAL_HEADER',
      dl_item_new         TYPE /saptrx/strucdatadef VALUE 'DELIVERY_ITEM_NEW',
      dl_item_old         TYPE /saptrx/strucdatadef VALUE 'DELIVERY_ITEM_OLD',
      dl_header_new       TYPE /saptrx/strucdatadef VALUE 'DELIVERY_HEADER_NEW',
      dl_header_old       TYPE /saptrx/strucdatadef VALUE 'DELIVERY_HEADER_OLD',
    END OF cs_tabledef .
  CONSTANTS:
    BEGIN OF cs_md_type,
      goods_receipt TYPE mkpf-blart VALUE 'WE',
    END OF cs_md_type .
  CONSTANTS:
    BEGIN OF cs_loekz,
      active  TYPE ekpo-loekz VALUE '',
      deleted TYPE ekpo-loekz VALUE 'L',
    END OF cs_loekz .
  CONSTANTS:
    BEGIN OF cs_adrtype,
      organization TYPE ad_adrtype VALUE '1',
    END OF cs_adrtype .
  CONSTANTS cv_agent_id_type TYPE bu_id_type VALUE 'LBN001' ##NO_TEXT.
  CONSTANTS:
    cv_agent_id_prefix TYPE c LENGTH 4 VALUE 'LBN#' ##NO_TEXT.
  CONSTANTS:
    BEGIN OF cs_vbtyp,
      delivery TYPE vbtyp VALUE '7',
    END OF cs_vbtyp .
ENDINTERFACE.
