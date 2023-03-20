interface ZIF_GTT_SOF_CONSTANTS
  public .


  constants:
    BEGIN OF cs_loctype,
      bp               TYPE zgtt_ssof_stop_info-loctype VALUE 'BusinessPartner',
      shippingpoint    TYPE zgtt_ssof_stop_info-loctype VALUE 'ShippingPoint',
      plant            TYPE zgtt_ssof_stop_info-loctype VALUE 'Plant',
      logisticlocation TYPE zgtt_ssof_stop_info-loctype VALUE 'LogisticLocation',
    END OF cs_loctype .
  constants:
    BEGIN OF cs_trxcod,
      sales_order       TYPE /saptrx/trxcod VALUE 'FT1_SALES_ORDER',
      sales_order_item  TYPE /saptrx/trxcod VALUE 'FT1_SALES_ORDER_ITEM',
      out_delivery      TYPE /saptrx/trxcod VALUE 'FT1_OUT_DELIVERY',
      out_delivery_item TYPE /saptrx/trxcod VALUE 'FT1_ODLV_ITEM',
      shipment          TYPE /saptrx/trxcod VALUE 'FT1_SHIPMENT',
      resource          TYPE /saptrx/trxcod VALUE 'FT1_RESOURCE',
      fu_number         TYPE /saptrx/trxcod VALUE 'FT1_FREIGHT_UNIT',
    END OF cs_trxcod .
  constants:
    BEGIN OF cs_relevance,
      auart TYPE vbak-auart VALUE 'ZGTT',"Sales Document Type
      lfart TYPE likp-lfart VALUE 'LBNP',"Delivery Type
    END OF cs_relevance .
  constants:
    BEGIN OF cs_loccat,
      departure TYPE zgtt_ssof_stop_info-loccat VALUE 'S',
      arrival   TYPE zgtt_ssof_stop_info-loccat VALUE 'D',
    END OF cs_loccat .
  constants:
    BEGIN OF cs_milestone,
      so_item_completed  TYPE /saptrx/appl_event_tag VALUE 'SO_ITEM_COMPLETED',
      so_planned_dlv     TYPE /saptrx/appl_event_tag VALUE 'SO_PLANNED_DLV',
      dlv_hd_completed   TYPE /saptrx/appl_event_tag VALUE 'ODLV_HD_COMPLETED',
      dlv_item_completed TYPE /saptrx/appl_event_tag VALUE 'ODLV_IT_COMPLETED',
      dlv_item_pod       TYPE /saptrx/appl_event_tag VALUE 'ODLV_ITEM_POD',
      goods_issue        TYPE /saptrx/appl_event_tag VALUE 'GOODS_ISSUE',
      departure          TYPE /saptrx/appl_event_tag VALUE 'DEPARTURE',
      arriv_dest         TYPE /saptrx/appl_event_tag VALUE 'ARRIV_DEST',
      pod                TYPE /saptrx/appl_event_tag VALUE 'POD',
      picking            TYPE /saptrx/appl_event_tag VALUE 'PICKING',
      packing            TYPE /saptrx/appl_event_tag VALUE 'PACKING',
      fu_completed       TYPE /saptrx/appl_event_tag VALUE 'FU_COMPLETED',
      odlv_planned_dlv   TYPE /saptrx/appl_event_tag VALUE 'ODLV_PLANNED_DLV',
    END OF cs_milestone .

  CONSTANTS:
    BEGIN OF cs_tabledef,
      so_header_new       TYPE /saptrx/strucdatadef VALUE 'SALES_ORDER_HEADER_NEW',
      so_item_new         TYPE /saptrx/strucdatadef VALUE 'SALES_ORDER_ITEMS_NEW',
    END OF cs_tabledef .
endinterface.
