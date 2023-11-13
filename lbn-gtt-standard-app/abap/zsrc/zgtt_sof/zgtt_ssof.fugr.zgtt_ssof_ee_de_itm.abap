FUNCTION zgtt_ssof_ee_de_itm.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(I_APPSYS) TYPE  /SAPTRX/APPLSYSTEM
*"     REFERENCE(I_APP_OBJ_TYPES) TYPE  /SAPTRX/AOTYPES
*"     REFERENCE(I_ALL_APPL_TABLES) TYPE  TRXAS_TABCONTAINER
*"     REFERENCE(I_APP_TYPE_CNTL_TABS) TYPE  TRXAS_APPTYPE_TABS
*"     REFERENCE(I_APP_OBJECTS) TYPE  TRXAS_APPOBJ_CTABS
*"  TABLES
*"      E_EXPEVENTDATA STRUCTURE  /SAPTRX/EXP_EVENTS
*"      E_MEASRMNTDATA STRUCTURE  /SAPTRX/MEASR_DATA OPTIONAL
*"      E_INFODATA STRUCTURE  /SAPTRX/INFO_DATA OPTIONAL
*"      E_LOGTABLE STRUCTURE  BAPIRET2 OPTIONAL
*"  EXCEPTIONS
*"      PARAMETER_ERROR
*"      EXP_EVENT_DETERM_ERROR
*"      TABLE_DETERMINATION_ERROR
*"      STOP_PROCESSING
*"----------------------------------------------------------------------
  DATA:
*   Definition of all application objects
    ls_app_objects            TYPE trxas_appobj_ctab_wa,
*   Work Structure for Expected Event
    ls_expeventdata           TYPE /saptrx/exp_events,
*   Event expected date/time
    lv_tsmp                   TYPE /saptrx/event_exp_datetime,
*   System Timezone
    lv_timezone               TYPE timezone,
*   header status new
    lt_xvbuk                  TYPE STANDARD TABLE OF vbukvb,
*   item status new
    lt_xvbup                  TYPE STANDARD TABLE OF vbupvb,
*   Status Relevance
    ls_eerel                  TYPE zgtt_mia_ee_rel,
    ls_vbfa_new               TYPE vbfavb,
    lt_vbfa_new               TYPE STANDARD TABLE OF vbfavb,
    ls_stop                   TYPE zgtt_ssof_stop_info,
    ls_dlv_watching_stop      TYPE zgtt_ssof_dlv_watch_stop,
    lt_stops_tmp              TYPE zgtt_ssof_stops,
    lt_dlv_watching_stops_tmp TYPE zgtt_ssof_dlv_watch_stops,
    lt_stops                  TYPE zgtt_ssof_stops,
    lt_dlv_watching_stops     TYPE zgtt_ssof_dlv_watch_stops,
    lt_relation               TYPE STANDARD TABLE OF gtys_tor_data,
    ls_relation               TYPE gtys_tor_data,
    lo_gtt_toolkit            TYPE REF TO zcl_gtt_sof_toolkit,
    lv_milestonenum           TYPE /saptrx/seq_num.

  FIELD-SYMBOLS:
*   Delivery Header
    <ls_xlikp> TYPE likpvb,
*   Delivery Item
    <ls_xlips> TYPE lipsvb,
*   Header Status New
    <ls_xvbuk> TYPE vbukvb,
*   Item Status New
    <ls_xvbup> TYPE vbupvb.

  lo_gtt_toolkit = zcl_gtt_sof_toolkit=>get_instance( ).

* <1> Read necessary application tables
* Read Header Status Data New
  PERFORM read_appl_table
    USING    i_all_appl_tables
             gc_bpt_delivery_hdrstatus_new
    CHANGING lt_xvbuk.
* Read Item Status Data New
  PERFORM read_appl_table
    USING    i_all_appl_tables
             gc_bpt_delivery_item_stat_new
    CHANGING lt_xvbup.
* Read Document flow New
  PERFORM read_appl_table
    USING    i_all_appl_tables
             gc_bpt_document_flow_new
    CHANGING lt_vbfa_new.

* <2> Fill general data for all control data records
  CLEAR ls_expeventdata.
* Logical System ID of an application system
  ls_expeventdata-appsys     = i_appsys.
* Application Object type
  ls_expeventdata-appobjtype = i_app_obj_types-aotype.
* Login Language
  ls_expeventdata-language   = sy-langu.

*   Get System TimeZone
  CALL FUNCTION 'GET_SYSTEM_TIMEZONE'
    IMPORTING
      timezone            = lv_timezone
    EXCEPTIONS
      customizing_missing = 1
      OTHERS              = 2.

* <3> Loop at application objects
  LOOP AT i_app_objects INTO ls_app_objects.
    lv_milestonenum = 1.

*   Application Object ID
    ls_expeventdata-appobjid = ls_app_objects-appobjid.

*   Check if Main table is Delivery Item or not.
    IF ls_app_objects-maintabdef >< gc_bpt_delivery_item_new.
      PERFORM create_logtable_aot
        TABLES e_logtable
        USING  ls_app_objects-maintabdef
               space
               i_app_obj_types-expeventfunc
               ls_app_objects-appobjtype
               i_appsys.
      EXIT.
    ENDIF.
*   Read Main Table
    ASSIGN ls_app_objects-maintabref->* TO <ls_xlips>.

*   Check if Master table is Delivery Header or not.
    IF ls_app_objects-mastertabdef >< gc_bpt_delivery_header_new.
      PERFORM create_logtable_aot
        TABLES e_logtable
        USING  ls_app_objects-mastertabdef
               space
               i_app_obj_types-expeventfunc
               ls_app_objects-appobjtype
               i_appsys.
      EXIT.
    ENDIF.
*   Read Master Table
    ASSIGN ls_app_objects-mastertabref->* TO <ls_xlikp>.

    READ TABLE lt_xvbuk ASSIGNING <ls_xvbuk> WITH KEY vbeln = <ls_xlikp>-vbeln.
    READ TABLE lt_xvbup ASSIGNING <ls_xvbup> WITH KEY vbeln = <ls_xlips>-vbeln
                                                      posnr = <ls_xlips>-posnr.

    CLEAR ls_eerel.
    SELECT SINGLE * INTO ls_eerel FROM zgtt_mia_ee_rel WHERE appobjid = ls_app_objects-appobjid.
    ls_eerel-mandt    = sy-mandt.
    ls_eerel-appobjid = ls_app_objects-appobjid.
    IF <ls_xvbup>-kosta = 'A'.
      ls_eerel-z_kosta    = gc_true.
    ELSEIF <ls_xvbup>-kosta = ''.
      ls_eerel-z_kosta    = gc_false.
    ENDIF.
    IF <ls_xvbup>-pksta = 'A'.
      ls_eerel-z_pksta    = gc_true.
    ELSEIF <ls_xvbup>-pksta = ''.
      ls_eerel-z_pksta    = gc_false.
    ENDIF.
    IF <ls_xvbup>-wbsta = 'A'.
      ls_eerel-z_wbsta    = gc_true.
    ELSEIF <ls_xvbup>-wbsta = ''.
      ls_eerel-z_wbsta    = gc_false.
    ENDIF.
    IF <ls_xvbup>-pdsta = 'A'.
      ls_eerel-z_pdstk    = gc_true.
    ELSEIF <ls_xvbup>-pdsta = ''.
      ls_eerel-z_pdstk    = gc_false.
    ENDIF.
    MODIFY zgtt_mia_ee_rel FROM ls_eerel.

    CLEAR ls_expeventdata-locid2.
*   < Picking>
    IF ls_eerel-z_kosta = gc_true.
      CLEAR ls_expeventdata-evt_exp_datetime.
      ls_expeventdata-milestone    = zif_gtt_sof_constants=>cs_milestone-picking.
      ls_expeventdata-milestonenum = lv_milestonenum.
*     Get Planned Picking datetime
      PERFORM set_local_timestamp
        USING    <ls_xlikp>-kodat
                 <ls_xlikp>-kouhr
        CHANGING ls_expeventdata-evt_exp_datetime.
      ls_expeventdata-evt_exp_tzone = lv_timezone.
      ls_expeventdata-loctype = zif_gtt_sof_constants=>cs_loctype-shippingpoint.
      ls_expeventdata-locid1 = <ls_xlikp>-vstel.
      APPEND ls_expeventdata TO e_expeventdata.
      ADD 1 TO lv_milestonenum.
    ENDIF.

*   < Packing>
    IF ls_eerel-z_pksta = gc_true.
      CLEAR ls_expeventdata-evt_exp_datetime.
      ls_expeventdata-milestone    = zif_gtt_sof_constants=>cs_milestone-packing.
      ls_expeventdata-milestonenum = lv_milestonenum.
      ls_expeventdata-evt_exp_tzone = lv_timezone.
      ls_expeventdata-loctype = zif_gtt_sof_constants=>cs_loctype-shippingpoint.
      ls_expeventdata-locid1 = <ls_xlikp>-vstel.
      APPEND ls_expeventdata TO e_expeventdata.
      ADD 1 TO lv_milestonenum.
    ENDIF.

*   < Goods Issued >
    IF ls_eerel-z_wbsta = gc_true.
      CLEAR ls_expeventdata-evt_exp_datetime.
      ls_expeventdata-milestone     = zif_gtt_sof_constants=>cs_milestone-goods_issue.
      ls_expeventdata-milestonenum  = lv_milestonenum.
*     Get Planned GI datetime
      PERFORM set_local_timestamp
        USING    <ls_xlikp>-wadat
                 <ls_xlikp>-wauhr
        CHANGING ls_expeventdata-evt_exp_datetime.
      ls_expeventdata-evt_exp_tzone = lv_timezone.
      ls_expeventdata-loctype = zif_gtt_sof_constants=>cs_loctype-shippingpoint.
      ls_expeventdata-locid1 = <ls_xlikp>-vstel.
      APPEND ls_expeventdata TO e_expeventdata.
      ADD 1 TO lv_milestonenum.
    ENDIF.

*   < ODLV Item POD >
    IF ls_eerel-z_pdstk = gc_true.
      CLEAR:
        ls_expeventdata-evt_exp_tzone,
        ls_expeventdata-evt_exp_datetime,
        ls_expeventdata-milestone,
        ls_expeventdata-milestonenum,
        ls_expeventdata-locid1,
        ls_expeventdata-locid2,
        ls_expeventdata-loctype.
      ls_expeventdata-milestone     = zif_gtt_sof_constants=>cs_milestone-dlv_item_pod.
      ls_expeventdata-milestonenum  = lv_milestonenum.
      CONCATENATE <ls_xlips>-vbeln <ls_xlips>-posnr
             INTO ls_expeventdata-locid2.
      SHIFT ls_expeventdata-locid2 LEFT DELETING LEADING '0'.
      APPEND ls_expeventdata TO e_expeventdata.
      ADD 1 TO lv_milestonenum.
    ENDIF.

*   Check if TM ingegrated or not
    CLEAR lt_relation.
    lo_gtt_toolkit->get_relation(
      EXPORTING
        iv_vbeln    = <ls_xlips>-vbeln  " Delivery
        iv_posnr    = <ls_xlips>-posnr  " Item
        iv_vbtyp    = <ls_xlikp>-vbtyp  " SD Document Category
      IMPORTING
        et_relation = lt_relation ).

*   Relevant with TM, add planned event FUCompleteds
    IF lt_relation IS NOT INITIAL."relevant with TM
      CLEAR:
        ls_expeventdata-milestonenum,
        ls_expeventdata-evt_exp_datetime,
        ls_expeventdata-evt_exp_tzone,
        ls_expeventdata-loctype,
        ls_expeventdata-locid1,
        ls_expeventdata-locid2.

      LOOP AT lt_relation INTO ls_relation.
        ls_expeventdata-milestonenum  = lv_milestonenum.
        ls_expeventdata-milestone = zif_gtt_sof_constants=>cs_milestone-fu_completed.
        ls_expeventdata-locid2 = ls_relation-freight_unit_number.
        SHIFT ls_expeventdata-locid2 LEFT DELETING LEADING '0'.
        APPEND ls_expeventdata TO e_expeventdata.
        ADD 1 TO lv_milestonenum.
      ENDLOOP.
    ELSE."Not relevant with TM
*     Not relevant with TM, add planned event HeaderCompleted
      CLEAR:
        ls_expeventdata-milestonenum,
        ls_expeventdata-evt_exp_datetime,
        ls_expeventdata-evt_exp_tzone,
        ls_expeventdata-loctype,
        ls_expeventdata-locid1,
        ls_expeventdata-locid2.
      ls_expeventdata-milestonenum  = lv_milestonenum.
      ls_expeventdata-milestone = zif_gtt_sof_constants=>cs_milestone-dlv_hd_completed.
      APPEND ls_expeventdata TO e_expeventdata.
      ADD 1 TO lv_milestonenum.
    ENDIF.

    CLEAR:
      ls_expeventdata-milestonenum,
      ls_expeventdata-evt_exp_datetime,
      ls_expeventdata-evt_exp_tzone,
      ls_expeventdata-loctype,
      ls_expeventdata-locid1,
      ls_expeventdata-locid2.

*   if it is a STO outbound delivery item,add Header Goods Receipt and Item Goods Receipt
    IF <ls_xlips>-vgtyp = if_sd_doc_category=>purchase_order
       AND ls_eerel-z_wbsta = gc_true.

*     Goods Receipt without event match key
*     Trigger Condition: STO outbound delivery item & GM relevant & LE-TRA scenario
      IF lt_relation IS INITIAL.
        ls_expeventdata-milestonenum  = lv_milestonenum.
        ls_expeventdata-milestone = zif_gtt_ef_constants=>cs_milestone-dl_goods_receipt.
        TRY.
            ls_expeventdata-evt_exp_tzone    = COND #( WHEN <ls_xlikp>-tzonrc IS NOT INITIAL
                                                   THEN <ls_xlikp>-tzonrc
                                                   ELSE zcl_gtt_tools=>get_system_time_zone( ) ).
          CATCH cx_udm_message.
        ENDTRY.
        ls_expeventdata-evt_exp_datetime = |0{ <ls_xlikp>-lfdat }{ <ls_xlikp>-lfuhr }|.
        APPEND ls_expeventdata TO e_expeventdata.
        ADD 1 TO lv_milestonenum.
      ENDIF.

*     Goods Receipt with event match key
*     Trigger Condition: STO outbound delivery item & GM relevant & item not flagged as Deleted
      CLEAR:
        ls_expeventdata-milestonenum,
        ls_expeventdata-evt_exp_datetime,
        ls_expeventdata-evt_exp_tzone,
        ls_expeventdata-loctype,
        ls_expeventdata-locid1,
        ls_expeventdata-locid2.

      ls_expeventdata-milestonenum  = lv_milestonenum.
      ls_expeventdata-milestone = zif_gtt_ef_constants=>cs_milestone-dl_goods_receipt.
      TRY.
          ls_expeventdata-evt_exp_tzone    = COND #( WHEN <ls_xlikp>-tzonrc IS NOT INITIAL
                                                 THEN <ls_xlikp>-tzonrc
                                                 ELSE zcl_gtt_tools=>get_system_time_zone( ) ).
        CATCH cx_udm_message.
      ENDTRY.
      ls_expeventdata-evt_exp_datetime = |0{ <ls_xlikp>-lfdat }{ <ls_xlikp>-lfuhr }|.
      zcl_gtt_tools=>get_location_id(
        EXPORTING
          iv_vgbel  = <ls_xlips>-vgbel
          iv_vgpos  = <ls_xlips>-vgpos
        IMPORTING
          ev_locid1 = DATA(lv_locid1) ).
      ls_expeventdata-locid1 = lv_locid1.
      ls_expeventdata-locid2 = |{ <ls_xlips>-vbeln ALPHA = OUT }{ <ls_xlips>-posnr ALPHA = IN }|.
      CONDENSE ls_expeventdata-locid2 NO-GAPS.
      ls_expeventdata-loctype = zif_gtt_ef_constants=>cs_loc_types-plant.
      APPEND ls_expeventdata TO e_expeventdata.
      ADD 1 TO lv_milestonenum.
    ENDIF.

    READ TABLE e_expeventdata WITH KEY appobjid = ls_app_objects-appobjid TRANSPORTING NO FIELDS.
    IF sy-subrc NE 0.
      ls_expeventdata-evt_exp_datetime = '000000000000000'.
      ls_expeventdata-milestone     = ''.
      ls_expeventdata-evt_exp_tzone = ''.
      ls_expeventdata-loctype = ''.
      ls_expeventdata-locid1 = ''.
      ls_expeventdata-locid2 = ''.
      APPEND ls_expeventdata TO e_expeventdata.
    ENDIF.

  ENDLOOP.

ENDFUNCTION.
