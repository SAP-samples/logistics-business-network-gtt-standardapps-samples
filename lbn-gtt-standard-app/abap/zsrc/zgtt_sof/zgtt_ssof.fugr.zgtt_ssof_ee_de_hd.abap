FUNCTION zgtt_ssof_ee_de_hd.
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
    lt_xvbup                  TYPE STANDARD TABLE OF vbupvb,
    ls_xvbup                  TYPE vbupvb,
*   Planned Event relevance
    ls_eerel                  TYPE zgtt_mia_ee_rel,
    ls_vbfa_new               TYPE vbfavb,
    lt_vbfa_new               TYPE STANDARD TABLE OF vbfavb,
    ls_stop                   TYPE zgtt_ssof_stop_info,
    ls_dlv_watching_stop      TYPE zgtt_ssof_dlv_watch_stop,
    lt_stops_tmp              TYPE zgtt_ssof_stops,
    lt_dlv_watching_stops_tmp TYPE zgtt_ssof_dlv_watch_stops,
    lt_stops                  TYPE zgtt_ssof_stops,
    lt_dlv_watching_stops     TYPE zgtt_ssof_dlv_watch_stops,
    lo_gtt_toolkit            TYPE REF TO zcl_gtt_sof_toolkit,
    lt_item_new               TYPE TABLE OF lipsvb,
    ls_item_new               TYPE lipsvb,
    lv_milestonenum           TYPE /saptrx/seq_num VALUE 1,
    lv_appobjid               TYPE /saptrx/aoid,
    lv_pdstk                  TYPE zgtt_mia_ee_rel-z_pdstk,
    lt_relation               TYPE STANDARD TABLE OF gtys_tor_data,
    lv_plan_flag              TYPE flag,
    lv_length                 TYPE i,
    lv_seq_num                TYPE /saptrx/seq_num,
    lv_tknum                  TYPE tknum,
    lv_current_tknum          TYPE tknum.

  FIELD-SYMBOLS:
*   Delivery Header
    <ls_xlikp> TYPE likpvb,
*   Header Status New
    <ls_xvbuk> TYPE vbukvb.

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

* Read delivery item info(new)
  PERFORM read_appl_table USING i_all_appl_tables
                                gc_bpt_delivery_item_new
                       CHANGING lt_item_new.

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

*   Check if Main table is Delivery Header or not.
    IF ls_app_objects-maintabdef >< gc_bpt_delivery_header_new.
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
    ASSIGN ls_app_objects-maintabref->* TO <ls_xlikp>.

    READ TABLE lt_xvbuk ASSIGNING <ls_xvbuk> WITH KEY vbeln = <ls_xlikp>-vbeln.

    CLEAR ls_eerel.
    SELECT SINGLE * INTO ls_eerel FROM zgtt_mia_ee_rel WHERE appobjid = ls_app_objects-appobjid.
    ls_eerel-mandt    = sy-mandt.
    ls_eerel-appobjid = ls_app_objects-appobjid.
    IF <ls_xvbuk>-kostk = 'A'.
      ls_eerel-z_kosta    = gc_true.
    ELSEIF <ls_xvbuk>-kostk = ''.
      ls_eerel-z_kosta    = gc_false.
    ENDIF.
    IF <ls_xvbuk>-pkstk = 'A'.
      ls_eerel-z_pksta    = gc_true.
    ELSEIF <ls_xvbuk>-pkstk = ''.
      ls_eerel-z_pksta    = gc_false.
    ENDIF.
    IF <ls_xvbuk>-wbstk = 'A'.
      ls_eerel-z_wbsta    = gc_true.
    ELSEIF <ls_xvbuk>-wbstk = ''.
      ls_eerel-z_wbsta    = gc_false.
    ENDIF.
    IF <ls_xvbuk>-pdstk = 'A'.
      ls_eerel-z_pdstk    = gc_true.
    ELSEIF <ls_xvbuk>-pdstk = ''.
      ls_eerel-z_pdstk    = gc_false.
    ENDIF.
    MODIFY zgtt_mia_ee_rel FROM ls_eerel.

    CLEAR ls_expeventdata-locid2.
    IF ls_eerel-z_wbsta    = gc_true.
*     < Goods Issued >
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

    CLEAR: lt_stops, lt_dlv_watching_stops.
    DELETE lt_vbfa_new WHERE vbtyp_n NE '8' OR vbtyp_v NE 'J' OR vbelv NE <ls_xlikp>-vbeln.
    LOOP AT lt_vbfa_new INTO ls_vbfa_new.
      CLEAR: lt_stops_tmp, lt_dlv_watching_stops_tmp.
      CALL FUNCTION 'ZGTT_SSOF_GET_STOPS_FROM_SHP'
        EXPORTING
          iv_tknum              = ls_vbfa_new-vbeln
        IMPORTING
          et_stops              = lt_stops_tmp
          et_dlv_watching_stops = lt_dlv_watching_stops_tmp.
      APPEND LINES OF lt_stops_tmp TO lt_stops.
      APPEND LINES OF lt_dlv_watching_stops_tmp TO lt_dlv_watching_stops.
    ENDLOOP.
    SORT lt_stops BY stopid loccat.
    SORT lt_dlv_watching_stops BY vbeln stopid loccat.
    DELETE ADJACENT DUPLICATES FROM lt_stops COMPARING stopid loccat.
    DELETE ADJACENT DUPLICATES FROM lt_dlv_watching_stops COMPARING vbeln stopid loccat.
    lv_seq_num = lv_milestonenum.
    LOOP AT lt_dlv_watching_stops INTO ls_dlv_watching_stop WHERE vbeln = <ls_xlikp>-vbeln.
      lv_length = strlen( ls_dlv_watching_stop-stopid ) - 4.
      lv_tknum = ls_dlv_watching_stop-stopid+0(lv_length).
      IF lv_current_tknum <> lv_tknum.
        lv_current_tknum = lv_tknum.
        lv_seq_num = lv_milestonenum.
      ENDIF.

      READ TABLE lt_stops INTO ls_stop WITH KEY stopid = ls_dlv_watching_stop-stopid
                                                loccat = ls_dlv_watching_stop-loccat.
      IF ls_stop-loctype = zif_gtt_sof_constants=>cs_loctype-bp.
        SHIFT ls_stop-locid LEFT DELETING LEADING '0'.
      ENDIF.
      IF ls_dlv_watching_stop-loccat = zif_gtt_sof_constants=>cs_loccat-departure.
*       Add planned source arrival event for LTL mode
        ls_expeventdata-locid2            = ls_stop-stopid.
        ls_expeventdata-loctype           = ls_stop-loctype.
        ls_expeventdata-locid1            = ls_stop-locid.
        TRY.
            zcl_gtt_sof_toolkit=>add_planned_source_arrival(
              EXPORTING
                is_expeventdata = ls_expeventdata
                iv_seq_num      = lv_seq_num
              IMPORTING
                es_eventdata    = DATA(ls_eventdata) ).
          CATCH cx_udm_message.
        ENDTRY.
        IF ls_eventdata IS NOT INITIAL.
          APPEND ls_eventdata TO e_expeventdata.
          ADD 1 TO lv_seq_num.
        ENDIF.
        CLEAR ls_eventdata.

*       DEPARTURE planned event
        ls_expeventdata-milestone         = zif_gtt_sof_constants=>cs_milestone-departure.
        ls_expeventdata-milestonenum      = lv_seq_num.
        ls_expeventdata-locid2            = ls_stop-stopid.
        ls_expeventdata-loctype           = ls_stop-loctype.
        ls_expeventdata-locid1            = ls_stop-locid.
        ls_expeventdata-evt_exp_datetime  = ls_stop-pln_evt_datetime.
        ls_expeventdata-evt_exp_tzone     = ls_stop-pln_evt_timezone.
        APPEND ls_expeventdata TO e_expeventdata.

        ADD 1 TO lv_seq_num.

      ELSEIF ls_dlv_watching_stop-loccat = zif_gtt_sof_constants=>cs_loccat-arrival.
*       ARRIVAL planned event
        ls_expeventdata-milestone         = zif_gtt_sof_constants=>cs_milestone-arriv_dest.
        ls_expeventdata-milestonenum      = lv_seq_num.
        ls_expeventdata-locid2            = ls_stop-stopid.
        ls_expeventdata-loctype           = ls_stop-loctype.
        ls_expeventdata-locid1            = ls_stop-locid.
        ls_expeventdata-evt_exp_datetime  = ls_stop-pln_evt_datetime.
        ls_expeventdata-evt_exp_tzone     = ls_stop-pln_evt_timezone.
        APPEND ls_expeventdata TO e_expeventdata.

        ADD 1 TO lv_seq_num.

*       POD planned event
        IF <ls_xlikp>-kunnr EQ ls_stop-locid AND ls_eerel-z_pdstk = 'X'.
          ls_expeventdata-milestone         = zif_gtt_sof_constants=>cs_milestone-pod.
          ls_expeventdata-milestonenum      = lv_seq_num.
          ls_expeventdata-locid2            = ls_stop-stopid.
          ls_expeventdata-loctype           = ls_stop-loctype.
          ls_expeventdata-locid1            = ls_stop-locid.
          ls_expeventdata-evt_exp_datetime  = ls_stop-pln_evt_datetime.
          ls_expeventdata-evt_exp_tzone     = ls_stop-pln_evt_timezone.
          APPEND ls_expeventdata TO e_expeventdata.
          ADD 1 TO lv_seq_num.
        ENDIF.

      ENDIF.

    ENDLOOP.
    lv_milestonenum = lv_seq_num.
*   Add planned event ItemPOD
    CLEAR:
      ls_expeventdata-milestonenum,
      ls_expeventdata-evt_exp_datetime,
      ls_expeventdata-evt_exp_tzone,
      ls_expeventdata-loctype,
      ls_expeventdata-locid1,
      ls_expeventdata-locid2.
    LOOP AT lt_item_new INTO ls_item_new WHERE vbeln = <ls_xlikp>-vbeln AND updkz <> 'D'.
      CLEAR:
        ls_xvbup,
        lv_appobjid,
        lv_pdstk.

      CONCATENATE ls_item_new-vbeln ls_item_new-posnr INTO lv_appobjid.
      SHIFT lv_appobjid LEFT DELETING LEADING '0'.
      SELECT SINGLE z_pdstk INTO lv_pdstk FROM zgtt_mia_ee_rel WHERE appobjid = lv_appobjid.

      READ TABLE lt_xvbup INTO ls_xvbup WITH KEY vbeln = ls_item_new-vbeln
                                                 posnr = ls_item_new-posnr.
      IF sy-subrc = 0.
        IF ls_xvbup-pdsta = 'A'.
          lv_pdstk = abap_true.
        ELSEIF ls_xvbup-pdsta = ''.
          lv_pdstk = abap_false.
        ENDIF.
      ENDIF.

*     POD relevant,then plan itemPOD event
      IF lv_pdstk = abap_true.
        ls_expeventdata-milestone    = zif_gtt_sof_constants=>cs_milestone-dlv_item_pod.
        ls_expeventdata-milestonenum = lv_milestonenum.
        CONCATENATE ls_item_new-vbeln ls_item_new-posnr
               INTO ls_expeventdata-locid2.
        SHIFT ls_expeventdata-locid2 LEFT DELETING LEADING '0'.
        APPEND ls_expeventdata TO e_expeventdata.
        ADD 1 TO lv_milestonenum.
      ENDIF.
    ENDLOOP.

*   Check if TM ingegrated or not
    CLEAR lt_relation.
    lo_gtt_toolkit->get_relation(
      EXPORTING
        iv_vbeln    = <ls_xlikp>-vbeln  " Delivery
        iv_vbtyp    = <ls_xlikp>-vbtyp  " SD Document Category
      IMPORTING
        et_relation = lt_relation ).

*   Relevant with TM, add planned event ItemCompletedByFU
    IF lt_relation IS NOT INITIAL."relevant with TM
      CLEAR:
        ls_expeventdata-milestonenum,
        ls_expeventdata-evt_exp_datetime,
        ls_expeventdata-evt_exp_tzone,
        ls_expeventdata-loctype,
        ls_expeventdata-locid1,
        ls_expeventdata-locid2.

      LOOP AT lt_item_new INTO ls_item_new WHERE vbeln = <ls_xlikp>-vbeln AND updkz <> 'D'.
        ls_expeventdata-milestonenum  = lv_milestonenum.
        ls_expeventdata-milestone = zif_gtt_sof_constants=>cs_milestone-dlv_item_completed.
        ls_expeventdata-locid2 = |{ ls_item_new-vbeln ALPHA = OUT }{ ls_item_new-posnr ALPHA = IN }|.
        CONDENSE ls_expeventdata-locid2 NO-GAPS.
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

*   Add planned delivery event with planned timestamp
    CLEAR:
      ls_expeventdata-milestonenum,
      ls_expeventdata-evt_exp_datetime,
      ls_expeventdata-evt_exp_tzone,
      ls_expeventdata-loctype,
      ls_expeventdata-locid1,
      ls_expeventdata-locid2.
    ls_expeventdata-milestonenum  = lv_milestonenum.
    ls_expeventdata-milestone        = zif_gtt_sof_constants=>cs_milestone-odlv_planned_dlv.
    ls_expeventdata-evt_exp_datetime = zcl_gtt_tools=>get_local_timestamp(
      iv_date = <ls_xlikp>-lfdat
      iv_time = <ls_xlikp>-lfuhr ).
    TRY.
        ls_expeventdata-evt_exp_tzone    = COND #( WHEN <ls_xlikp>-tzonrc IS NOT INITIAL
                                               THEN <ls_xlikp>-tzonrc
                                               ELSE zcl_gtt_tools=>get_system_time_zone( ) ).
      CATCH cx_udm_message.
    ENDTRY.
    APPEND ls_expeventdata TO e_expeventdata.
    ADD 1 TO lv_milestonenum.

*   if it is a STO outbound delivery,add Header Goods Receipt and Item Goods Receipt
    CLEAR:
      ls_expeventdata-milestonenum,
      ls_expeventdata-evt_exp_datetime,
      ls_expeventdata-evt_exp_tzone,
      ls_expeventdata-loctype,
      ls_expeventdata-locid1,
      ls_expeventdata-locid2,
      lv_plan_flag.

    IF ls_eerel-z_wbsta = gc_true.
*     Goods Receipt without event match key
*     Trigger Condition: STO outbound delivery item & GM relevant & LE-TRA scenario
      LOOP AT lt_item_new INTO ls_item_new WHERE vbeln = <ls_xlikp>-vbeln AND updkz <> 'D'
                                             AND vgtyp = if_sd_doc_category=>purchase_order.
        lv_plan_flag = abap_true.
        EXIT.
      ENDLOOP.
      IF lv_plan_flag = abap_true AND lt_relation IS INITIAL.
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
*     Trigger Condition: STO outbound delivery & item not flagged as Deleted
      LOOP AT lt_item_new INTO ls_item_new WHERE vbeln = <ls_xlikp>-vbeln AND updkz <> 'D'
                                             AND vgtyp = if_sd_doc_category=>purchase_order.

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
            iv_vgbel  = ls_item_new-vgbel
            iv_vgpos  = ls_item_new-vgpos
          IMPORTING
            ev_locid1 = DATA(lv_locid1) ).
        ls_expeventdata-locid1 = lv_locid1.
        ls_expeventdata-locid2 = |{ ls_item_new-vbeln ALPHA = OUT }{ ls_item_new-posnr ALPHA = IN }|.
        CONDENSE ls_expeventdata-locid2 NO-GAPS.
        ls_expeventdata-loctype = zif_gtt_ef_constants=>cs_loc_types-plant.
        APPEND ls_expeventdata TO e_expeventdata.
        ADD 1 TO lv_milestonenum.
      ENDLOOP.
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
