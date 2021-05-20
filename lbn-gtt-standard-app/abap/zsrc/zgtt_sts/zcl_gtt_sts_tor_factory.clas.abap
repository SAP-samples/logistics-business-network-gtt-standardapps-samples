CLASS zcl_gtt_sts_tor_factory DEFINITION
  PUBLIC
  INHERITING FROM zcl_gtt_sts_factory
  CREATE PUBLIC .

  PUBLIC SECTION.

    METHODS zif_gtt_sts_factory~get_bo_reader
        REDEFINITION .
    METHODS zif_gtt_sts_factory~get_pe_filler
        REDEFINITION .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_GTT_STS_TOR_FACTORY IMPLEMENTATION.


  METHOD zif_gtt_sts_factory~get_bo_reader.

    ASSIGN is_appl_object-maintabref->* TO FIELD-SYMBOL(<ls_tor_root>).
    IF sy-subrc = 0.
      ASSIGN COMPONENT /scmtms/if_tor_c=>sc_node_attribute-root-tor_cat
        OF STRUCTURE <ls_tor_root> TO FIELD-SYMBOL(<lv_tor_cat>).
      IF sy-subrc = 0.
        CASE <lv_tor_cat>.
          WHEN /scmtms/if_tor_const=>sc_tor_category-active.
            ro_bo_reader = NEW zcl_gtt_sts_bo_fo_reader( io_ef_parameters ).
          WHEN /scmtms/if_tor_const=>sc_tor_category-booking.
            ro_bo_reader = NEW zcl_gtt_sts_bo_fb_reader( io_ef_parameters ).
          WHEN /scmtms/if_tor_const=>sc_tor_category-freight_unit OR
               /scmtms/if_tor_const=>sc_tor_category-transp_unit.
            ro_bo_reader = NEW zcl_gtt_sts_bo_fu_reader( io_ef_parameters ).
          WHEN OTHERS.
            MESSAGE i009(zgtt_sts) WITH <lv_tor_cat> INTO DATA(lv_dummy) ##needed.
            zcl_gtt_sts_tools=>throw_exception( ).
        ENDCASE.
      ENDIF.
    ENDIF.

  ENDMETHOD.


  METHOD zif_gtt_sts_factory~get_pe_filler.

    ASSIGN is_appl_object-maintabref->* TO FIELD-SYMBOL(<ls_tor_root>).
    IF sy-subrc = 0.
      ASSIGN COMPONENT /scmtms/if_tor_c=>sc_node_attribute-root-tor_cat
        OF STRUCTURE <ls_tor_root> TO FIELD-SYMBOL(<lv_tor_cat>).
      IF sy-subrc = 0.
        CASE <lv_tor_cat>.
          WHEN /scmtms/if_tor_const=>sc_tor_category-active.
            ro_pe_filler = NEW zcl_gtt_sts_pe_fo_filler( io_ef_parameters ).
          WHEN /scmtms/if_tor_const=>sc_tor_category-booking.
            ro_pe_filler = NEW zcl_gtt_sts_pe_fb_filler( io_ef_parameters ).
          WHEN /scmtms/if_tor_const=>sc_tor_category-freight_unit OR
               /scmtms/if_tor_const=>sc_tor_category-transp_unit.
            ro_pe_filler = NEW zcl_gtt_sts_pe_fu_filler( io_ef_parameters ).
          WHEN OTHERS.
            MESSAGE i009(zgtt_sts) WITH <lv_tor_cat> INTO DATA(lv_dummy) ##needed.
            zcl_gtt_sts_tools=>throw_exception( ).
        ENDCASE.
      ENDIF.
    ENDIF.

  ENDMETHOD.
ENDCLASS.
