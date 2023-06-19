FUNCTION zgtt_sts_trk_tu.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(IT_TOR_ROOT_SSTRING) TYPE  /SCMTMS/T_EM_BO_TOR_ROOT
*"     REFERENCE(IT_TOR_ROOT_BEFORE_SSTRING) TYPE
*"        /SCMTMS/T_EM_BO_TOR_ROOT
*"     REFERENCE(IT_TOR_ITEM_SSTRING) TYPE  /SCMTMS/T_EM_BO_TOR_ITEM
*"     REFERENCE(IT_TOR_ITEM_BEFORE_SSTRING) TYPE
*"        /SCMTMS/T_EM_BO_TOR_ITEM
*"     REFERENCE(IT_TOR_ROOT_FOR_DELETION) TYPE
*"        /SCMTMS/T_EM_BO_TOR_ROOT
*"----------------------------------------------------------------------
  DATA:
    lo_tu_info   TYPE REF TO zif_gtt_sts_tu_reader,
    lt_resource  TYPE zcl_gtt_sts_trk_tu_base=>tt_resource,
    ls_idoc_data TYPE zcl_gtt_sts_trk_tu_base=>ts_idoc_data,
    lt_idoc_data TYPE zcl_gtt_sts_trk_tu_base=>tt_idoc_data,
    ls_aotype    TYPE zcl_gtt_sts_trk_tu_base=>ts_aotype,
    lt_relevance TYPE zcl_gtt_sts_trk_tu_base=>tt_relevance,
    lv_appobjid  TYPE /saptrx/aoid,
    lt_bapiret   TYPE bapiret2_t,
    lv_trxserv   TYPE /saptrx/trxserv,
    lv_appsys    TYPE logsys,
    lt_conf      TYPE TABLE OF zgtt_track_conf,
    lv_aotype    TYPE /saptrx/aotype,
    lv_tor_cat   TYPE /scmtms/tor_category.

  TRY.
      zcl_gtt_sts_tools=>get_track_conf(
        IMPORTING
          et_conf = lt_conf ).

      LOOP AT it_tor_root_sstring INTO DATA(ls_tor_root_sstring).
        READ TABLE lt_conf INTO DATA(ls_conf)
          WITH KEY tor_type = ls_tor_root_sstring-tor_type.
        IF sy-subrc = 0.

          CASE ls_conf-track_option.
            WHEN zif_gtt_sts_constants=>cs_tracking_scenario-fo_track. "FO tracking (no tracking unit)
              "Normal tracking do nothing.
            WHEN zif_gtt_sts_constants=>cs_tracking_scenario-tu_on_fo. "Tracking with tracking unit on FOFB
              IF ls_tor_root_sstring-tor_cat = /scmtms/if_tor_const=>sc_tor_category-active.
                lv_tor_cat = /scmtms/if_tor_const=>sc_tor_category-active.
                lo_tu_info = NEW zcl_gtt_sts_trk_tu_on_fo( ).
              ELSEIF ls_tor_root_sstring-tor_cat = /scmtms/if_tor_const=>sc_tor_category-booking.
                lv_tor_cat = /scmtms/if_tor_const=>sc_tor_category-booking.
                lo_tu_info = NEW zcl_gtt_sts_trk_tu_on_fb( ).
              ENDIF.
            WHEN zif_gtt_sts_constants=>cs_tracking_scenario-tu_on_fu. "Tracking with tracking unit on FU
              lv_tor_cat = /scmtms/if_tor_const=>sc_tor_category-freight_unit.
              lo_tu_info = NEW zcl_gtt_sts_trk_tu_on_fu( ).
            WHEN zif_gtt_sts_constants=>cs_tracking_scenario-tu_on_cu. "Maintain Tracked Objects on Container Unit
              lv_tor_cat = /scmtms/if_tor_const=>sc_tor_category-transp_unit.
              lo_tu_info = NEW zcl_gtt_sts_trk_tu_on_cu( ).
            WHEN OTHERS.
          ENDCASE.
        ENDIF.
      ENDLOOP.

      READ TABLE it_tor_root_sstring INTO ls_tor_root_sstring
        WITH KEY tor_cat = /scmtms/if_tor_const=>sc_tor_category-freight_unit.
      IF sy-subrc = 0.
        lv_aotype = ls_tor_root_sstring-aotype.
        REPLACE ALL OCCURRENCES OF 'FU' IN lv_aotype WITH 'TU'.
      ELSE.
        LOOP AT it_tor_root_sstring INTO ls_tor_root_sstring
          WHERE tor_cat = /scmtms/if_tor_const=>sc_tor_category-active
             OR tor_cat = /scmtms/if_tor_const=>sc_tor_category-booking.
          lv_aotype = ls_tor_root_sstring-aotype.
          REPLACE ALL OCCURRENCES OF 'SHP_HD' IN lv_aotype WITH 'TU'.
          EXIT.
        ENDLOOP.
      ENDIF.

      CHECK lo_tu_info IS BOUND AND lv_aotype IS NOT INITIAL.

      lo_tu_info->initiate( it_tor_root = it_tor_root_sstring
                            iv_tor_cat  = lv_tor_cat
                            iv_aotype   = lv_aotype ).

      lo_tu_info->check_relevance(
        EXPORTING
          it_tor_root_sstring        = it_tor_root_sstring
          it_tor_item_sstring        = it_tor_item_sstring
          it_tor_root_before_sstring = it_tor_root_before_sstring
          it_tor_item_before_sstring = it_tor_item_before_sstring
        CHANGING
          et_relevance               = lt_relevance ).

      lo_tu_info->generate_new_tu(
        it_tor_root_sstring        = it_tor_root_sstring
        it_tor_item_sstring        = it_tor_item_sstring
        it_tor_root_before_sstring = it_tor_root_before_sstring
        it_tor_item_before_sstring = it_tor_item_before_sstring
        it_relevance               = lt_relevance ).

      lo_tu_info->delete_old_tu(
        it_tor_root_for_deletion   = it_tor_root_for_deletion
        it_item_sstring            = it_tor_item_sstring
        it_tor_root_before_sstring = it_tor_root_before_sstring
        it_item_before_sstring     = it_tor_item_before_sstring
        it_tor_root_sstring        = it_tor_root_sstring ).

    CATCH cx_udm_message INTO DATA(lo_udm_message).
      zcl_gtt_sof_tm_tools=>log_exception(
        EXPORTING
          io_udm_message = lo_udm_message
          iv_object      = zif_gtt_sof_ctp_tor_constants=>cs_logs-object-tor_ctp
          iv_subobject   = zif_gtt_sof_ctp_tor_constants=>cs_logs-subobject-tor_ctp ).
    CATCH cx_root.
  ENDTRY.

ENDFUNCTION.
