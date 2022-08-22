class ZCL_GTT_STS_TOR_FACTORY definition
  public
  inheriting from ZCL_GTT_STS_FACTORY
  create public .

public section.

  types:
    TT_TRACK_CONF type TABLE of ZGTT_TRACK_CONF .

  methods ZIF_GTT_STS_FACTORY~GET_BO_READER
    redefinition .
  methods ZIF_GTT_STS_FACTORY~GET_PE_FILLER
    redefinition .
protected section.

  class-data MT_TRACK_CONF type TT_TRACK_CONF .
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_GTT_STS_TOR_FACTORY IMPLEMENTATION.


  METHOD zif_gtt_sts_factory~get_bo_reader.

    FIELD-SYMBOLS:
      <ls_tor_root> TYPE /scmtms/s_em_bo_tor_root.

    ASSIGN is_appl_object-maintabref->* TO <ls_tor_root>.
    IF sy-subrc <> 0.
      MESSAGE e010(zgtt_sts) INTO DATA(lv_dummy) ##needed.
      zcl_gtt_sts_tools=>throw_exception( ).
    ENDIF.

*   Get configuration data
    IF mt_track_conf IS INITIAL.
      zcl_gtt_sts_tools=>get_track_conf(
        IMPORTING
          et_conf = mt_track_conf ).
    ENDIF.

    READ TABLE mt_track_conf INTO DATA(ls_track_conf)
      WITH KEY tor_type = <ls_tor_root>-tor_type.
    IF sy-subrc = 0.

      CASE <ls_tor_root>-tor_cat.
        WHEN /scmtms/if_tor_const=>sc_tor_category-active.
          CASE ls_track_conf-track_option.
            WHEN zif_gtt_sts_constants=>cs_tracking_scenario-fo_track.
              ro_bo_reader = NEW zcl_gtt_sts_bo_fo_reader( io_ef_parameters ).
            WHEN zif_gtt_sts_constants=>cs_tracking_scenario-tu_on_fo.
              ro_bo_reader = NEW zcl_gtt_sts_bo_trk_onfo_fo( io_ef_parameters ).
            WHEN zif_gtt_sts_constants=>cs_tracking_scenario-tu_on_fu.
              ro_bo_reader = NEW zcl_gtt_sts_bo_trk_onfu_fo( io_ef_parameters ).
            WHEN zif_gtt_sts_constants=>cs_tracking_scenario-tu_on_cu.
              ro_bo_reader = NEW zcl_gtt_sts_bo_trk_oncu_fo( io_ef_parameters ).
            WHEN OTHERS.
          ENDCASE.
        WHEN /scmtms/if_tor_const=>sc_tor_category-booking.
          CASE ls_track_conf-track_option.
            WHEN zif_gtt_sts_constants=>cs_tracking_scenario-fo_track.
              ro_bo_reader = NEW zcl_gtt_sts_bo_fb_reader( io_ef_parameters ).
            WHEN zif_gtt_sts_constants=>cs_tracking_scenario-tu_on_fo.
              ro_bo_reader = NEW zcl_gtt_sts_bo_trk_onfo_fb( io_ef_parameters ).
            WHEN zif_gtt_sts_constants=>cs_tracking_scenario-tu_on_fu.
              ro_bo_reader = NEW zcl_gtt_sts_bo_trk_onfu_fb( io_ef_parameters ).
            WHEN zif_gtt_sts_constants=>cs_tracking_scenario-tu_on_cu.
              ro_bo_reader = NEW zcl_gtt_sts_bo_trk_oncu_fb( io_ef_parameters ).
            WHEN OTHERS.
          ENDCASE.
        WHEN /scmtms/if_tor_const=>sc_tor_category-freight_unit.
          CASE ls_track_conf-track_option.
            WHEN zif_gtt_sts_constants=>cs_tracking_scenario-fo_track.
              ro_bo_reader = NEW zcl_gtt_sts_bo_fu_reader( io_ef_parameters ).
            WHEN zif_gtt_sts_constants=>cs_tracking_scenario-tu_on_fo.
              ro_bo_reader = NEW zcl_gtt_sts_bo_trk_onfo_fu( io_ef_parameters ).
            WHEN zif_gtt_sts_constants=>cs_tracking_scenario-tu_on_fu.
              ro_bo_reader = NEW zcl_gtt_sts_bo_trk_onfu_fu( io_ef_parameters ).
            WHEN zif_gtt_sts_constants=>cs_tracking_scenario-tu_on_cu.
              ro_bo_reader = NEW zcl_gtt_sts_bo_trk_oncu_fu( io_ef_parameters ).
            WHEN OTHERS.
          ENDCASE.
        WHEN OTHERS.
      ENDCASE.
    ELSE.
      CASE <ls_tor_root>-tor_cat.
        WHEN /scmtms/if_tor_const=>sc_tor_category-active.
          ro_bo_reader = NEW zcl_gtt_sts_bo_fo_reader( io_ef_parameters ).
        WHEN /scmtms/if_tor_const=>sc_tor_category-booking.
          ro_bo_reader = NEW zcl_gtt_sts_bo_fb_reader( io_ef_parameters ).
        WHEN /scmtms/if_tor_const=>sc_tor_category-freight_unit OR
             /scmtms/if_tor_const=>sc_tor_category-transp_unit.
          ro_bo_reader = NEW zcl_gtt_sts_bo_fu_reader( io_ef_parameters ).
        WHEN OTHERS.
      ENDCASE.
    ENDIF.

  ENDMETHOD.


  METHOD zif_gtt_sts_factory~get_pe_filler.

    FIELD-SYMBOLS:
      <ls_tor_root> TYPE /scmtms/s_em_bo_tor_root.

    ASSIGN is_appl_object-maintabref->* TO <ls_tor_root>.
    IF sy-subrc <> 0.
      MESSAGE e010(zgtt_sts) INTO DATA(lv_dummy) ##needed.
      zcl_gtt_sts_tools=>throw_exception( ).
    ENDIF.

*   Get configuration data
    IF mt_track_conf IS INITIAL.
      zcl_gtt_sts_tools=>get_track_conf(
        IMPORTING
          et_conf = mt_track_conf ).
    ENDIF.

    READ TABLE mt_track_conf INTO DATA(ls_track_conf)
      WITH KEY tor_type = <ls_tor_root>-tor_type.
    IF sy-subrc = 0.
      CASE <ls_tor_root>-tor_cat.
        WHEN /scmtms/if_tor_const=>sc_tor_category-active.
          CASE ls_track_conf-track_option.
            WHEN zif_gtt_sts_constants=>cs_tracking_scenario-fo_track.
              ro_pe_filler = NEW zcl_gtt_sts_pe_fo_filler( io_ef_parameters ).
            WHEN zif_gtt_sts_constants=>cs_tracking_scenario-tu_on_fo.
              ro_pe_filler = NEW zcl_gtt_sts_pe_trk_onfo_fo_fil( io_ef_parameters ).
            WHEN zif_gtt_sts_constants=>cs_tracking_scenario-tu_on_fu.
              ro_pe_filler = NEW zcl_gtt_sts_pe_trk_onfu_fo_fil( io_ef_parameters ).
            WHEN zif_gtt_sts_constants=>cs_tracking_scenario-tu_on_cu.
              ro_pe_filler = NEW zcl_gtt_sts_pe_trk_oncu_fo_fil( io_ef_parameters ).
            WHEN OTHERS.
          ENDCASE.
        WHEN /scmtms/if_tor_const=>sc_tor_category-booking.
          CASE ls_track_conf-track_option.
            WHEN zif_gtt_sts_constants=>cs_tracking_scenario-fo_track.
              ro_pe_filler = NEW zcl_gtt_sts_pe_fb_filler( io_ef_parameters ).
            WHEN zif_gtt_sts_constants=>cs_tracking_scenario-tu_on_fo.
              ro_pe_filler = NEW zcl_gtt_sts_pe_trk_onfo_fb_fil( io_ef_parameters ).
            WHEN zif_gtt_sts_constants=>cs_tracking_scenario-tu_on_fu.
              ro_pe_filler = NEW zcl_gtt_sts_pe_trk_onfu_fb_fil( io_ef_parameters ).
            WHEN zif_gtt_sts_constants=>cs_tracking_scenario-tu_on_cu.
              ro_pe_filler = NEW zcl_gtt_sts_pe_trk_oncu_fb_fil( io_ef_parameters ).
            WHEN OTHERS.
          ENDCASE.
        WHEN /scmtms/if_tor_const=>sc_tor_category-freight_unit.
          CASE ls_track_conf-track_option.
            WHEN zif_gtt_sts_constants=>cs_tracking_scenario-fo_track.
              ro_pe_filler = NEW zcl_gtt_sts_pe_fu_filler( io_ef_parameters ).
            WHEN zif_gtt_sts_constants=>cs_tracking_scenario-tu_on_fo.
              ro_pe_filler = NEW zcl_gtt_sts_pe_trk_onfo_fu_fil( io_ef_parameters ).
            WHEN zif_gtt_sts_constants=>cs_tracking_scenario-tu_on_fu.
              ro_pe_filler = NEW zcl_gtt_sts_pe_trk_onfu_fu_fil( io_ef_parameters ).
            WHEN zif_gtt_sts_constants=>cs_tracking_scenario-tu_on_cu.
              ro_pe_filler = NEW zcl_gtt_sts_pe_trk_oncu_fu_fil( io_ef_parameters ).
            WHEN OTHERS.
          ENDCASE.
        WHEN OTHERS.
      ENDCASE.
    ELSE.
      CASE <ls_tor_root>-tor_cat.
        WHEN /scmtms/if_tor_const=>sc_tor_category-active.
          ro_pe_filler = NEW zcl_gtt_sts_pe_fo_filler( io_ef_parameters ).
        WHEN /scmtms/if_tor_const=>sc_tor_category-booking.
          ro_pe_filler = NEW zcl_gtt_sts_pe_fb_filler( io_ef_parameters ).
        WHEN /scmtms/if_tor_const=>sc_tor_category-freight_unit OR
             /scmtms/if_tor_const=>sc_tor_category-transp_unit.
          ro_pe_filler = NEW zcl_gtt_sts_pe_fu_filler( io_ef_parameters ).
        WHEN OTHERS.
      ENDCASE.
    ENDIF.

  ENDMETHOD.
ENDCLASS.
