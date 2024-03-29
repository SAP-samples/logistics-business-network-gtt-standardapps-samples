class ZCL_GTT_MIA_CTP_SHIPMENT_DATA definition
  public
  create public .

public section.

  types:
    BEGIN OF ts_likpdl,
        tknum TYPE vttk-tknum,
        vbeln TYPE likp-vbeln,
        updkz TYPE likpvb-updkz,
      END OF ts_likpdl .
  types:
    BEGIN OF ts_vbfaex,
        tknum TYPE vttk-tknum.
        INCLUDE TYPE vbfavb.
    TYPES: END OF ts_vbfaex .
  types:
    BEGIN OF ts_likpex,
        tknum TYPE vttk-tknum.
        INCLUDE TYPE likp.
    TYPES: END OF ts_likpex .
  types:
    BEGIN OF ts_stops,
        tknum    TYPE vttk-tknum,
        stops    TYPE zif_gtt_mia_app_types=>tt_stops,
        watching TYPE zif_gtt_mia_app_types=>tt_dlv_watch_stops,
      END OF ts_stops .
  types TS_VTTKVB type VTTKVB .
  types TS_LIPS type LIPS .
  types TS_EE_REL type ZGTT_MIA_EE_REL .
  types:
    tt_vttkvb_srt TYPE SORTED TABLE OF ts_vttkvb
                             WITH UNIQUE KEY tknum .
  types:
    tt_vttpvb_srt TYPE SORTED TABLE OF vttpvb
                             WITH NON-UNIQUE KEY tknum tpnum .
  types:
    tt_vttsvb_srt TYPE SORTED TABLE OF vttsvb
                             WITH NON-UNIQUE KEY tknum tsnum .
  types:
    tt_vtspvb_srt TYPE SORTED TABLE OF vtspvb
                             WITH UNIQUE KEY tknum tsnum tpnum
                             WITH NON-UNIQUE SORTED KEY vtts
                               COMPONENTS tknum tsnum .
  types:
    tt_vbfaex_srt TYPE SORTED TABLE OF ts_vbfaex
                             WITH NON-UNIQUE KEY tknum vbelv vbeln .
  types:
    tt_likpex_srt TYPE SORTED TABLE OF ts_likpex
                             WITH UNIQUE KEY tknum vbeln .
  types:
    tt_likpdl_srt TYPE SORTED TABLE OF ts_likpdl
                             WITH UNIQUE KEY vbeln tknum .
  types:
    tt_lips_srt   TYPE SORTED TABLE OF ts_lips
                             WITH UNIQUE KEY vbeln posnr .
  types:
    tt_stops_srt  TYPE SORTED TABLE OF ts_stops
                             WITH UNIQUE KEY tknum .
  types:
    tt_ee_rel_srt TYPE SORTED TABLE OF ts_ee_rel
                             WITH UNIQUE KEY appobjid .
  types:
    BEGIN OF MESH ts_shipment_merge,
        vttk     TYPE tt_vttkvb_srt
                 ASSOCIATION vttp TO vttp ON tknum = tknum
                 ASSOCIATION vttp_dlt TO vttp_dlt ON tknum = tknum,
        vttp     TYPE tt_vttpvb_srt,
        vttp_dlt TYPE tt_vttpvb_srt,
        vtts     TYPE tt_vttsvb_srt,
        vtts_dlt TYPE tt_vttsvb_srt
                 ASSOCIATION vtsp TO vtsp ON tknum = tknum
                                         AND tsnum = tsnum,
        vtsp     TYPE tt_vtspvb_srt
                 ASSOCIATION vttp TO vttp ON tknum = tknum
                                         AND tpnum = tpnum,
        vtsp_dlt TYPE tt_vtspvb_srt
                 ASSOCIATION vttp TO vttp ON tknum = tknum
                                         AND tpnum = tpnum,
        vbfa     TYPE tt_vbfaex_srt,
        likp     TYPE tt_likpex_srt
                 ASSOCIATION vbfa TO vbfa ON tknum = tknum
                                         AND vbelv = vbeln
                 ASSOCIATION likp_dlt TO likp_dlt ON vbeln = vbeln
                 ASSOCIATION lips TO lips ON vbeln = vbeln,
        lips     TYPE tt_lips_srt,
        likp_dlt TYPE tt_likpdl_srt,
        ee_rel   TYPE tt_ee_rel_srt,
      END OF MESH ts_shipment_merge .

  methods CONSTRUCTOR
    importing
      !IS_SHIPMENT type CXSHIPMENT
    raising
      CX_UDM_MESSAGE .
  methods GET_DATA
    returning
      value(RR_SHIP) type ref to DATA .
  methods GET_STOPS
    returning
      value(RR_STOPS) type ref to DATA .
  PROTECTED SECTION.
private section.

  types:
    tt_tknum   TYPE RANGE OF tknum .

  data MS_SHIP type TS_SHIPMENT_MERGE .
  data MT_STOPS type TT_STOPS_SRT .

  methods GET_VTTK_MERGED_DATA
    importing
      !IS_SHIPMENT type CXSHIPMENT
    exporting
      !ET_VTTK type TT_VTTKVB_SRT
    raising
      CX_UDM_MESSAGE .
  methods GET_VTTP_MERGED_DATA
    importing
      !IS_SHIPMENT type CXSHIPMENT
      !IT_TKNUM type TT_TKNUM
    exporting
      !ET_VTTP_FULL type TT_VTTPVB_SRT
      !ET_VTTP_DELTA type TT_VTTPVB_SRT
    raising
      CX_UDM_MESSAGE .
  methods GET_VTTS_MERGED_DATA
    importing
      !IS_SHIPMENT type CXSHIPMENT
      !IT_TKNUM type TT_TKNUM
    exporting
      !ET_VTTS_FULL type TT_VTTSVB_SRT
      !ET_VTTS_DELTA type TT_VTTSVB_SRT
    raising
      CX_UDM_MESSAGE .
  methods GET_VTSP_MERGED_DATA
    importing
      !IS_SHIPMENT type CXSHIPMENT
      !IT_TKNUM type TT_TKNUM
    exporting
      !ET_VTSP_FULL type TT_VTSPVB_SRT
      !ET_VTSP_DELTA type TT_VTSPVB_SRT
    raising
      CX_UDM_MESSAGE .
  methods GET_LIKP_DELTA_DATA
    importing
      !IS_SHIP type TS_SHIPMENT_MERGE
      !IT_TKNUM type TT_TKNUM
      !IS_SHIPMENT type CXSHIPMENT optional
    exporting
      !ET_LIKP_DELTA type TT_LIKPDL_SRT
    raising
      CX_UDM_MESSAGE .
  methods GET_VBFA_AND_LIKP_DATA
    importing
      !IS_SHIP type TS_SHIPMENT_MERGE
    exporting
      !ET_VBFA type TT_VBFAEX_SRT
      !ET_LIKP type TT_LIKPEX_SRT
    raising
      CX_UDM_MESSAGE .
  methods GET_LIPS_DATA
    importing
      !IS_SHIP type TS_SHIPMENT_MERGE
    exporting
      !ET_LIPS type TT_LIPS_SRT
    raising
      CX_UDM_MESSAGE .
  methods GET_EE_REL_DATA
    importing
      !IS_SHIP type TS_SHIPMENT_MERGE
    exporting
      !ET_EE_REL type TT_EE_REL_SRT
    raising
      CX_UDM_MESSAGE .
  methods INIT_SHIPMENT_DATA
    importing
      !IS_SHIPMENT type CXSHIPMENT
    exporting
      !ES_SHIP type TS_SHIPMENT_MERGE
    raising
      CX_UDM_MESSAGE .
  methods INIT_STOPS_DATA
    importing
      !IS_SHIPMENT type CXSHIPMENT
      !IS_SHIP type TS_SHIPMENT_MERGE
    exporting
      !ET_STOPS type TT_STOPS_SRT
    raising
      CX_UDM_MESSAGE .
  methods IS_VTTS_CHANGED
    importing
      !IS_SHIPMENT type CXSHIPMENT
      !IS_VTTS type VTTSVB
    returning
      value(RV_RESULT) type ABAP_BOOL
    raising
      CX_UDM_MESSAGE .
ENDCLASS.



CLASS ZCL_GTT_MIA_CTP_SHIPMENT_DATA IMPLEMENTATION.


  METHOD constructor.

    init_shipment_data(
      EXPORTING
        is_shipment = is_shipment
      IMPORTING
        es_ship     = ms_ship ).

    init_stops_data(
      EXPORTING
        is_shipment = is_shipment
        is_ship     = ms_ship
      IMPORTING
        et_stops    = mt_stops ).

  ENDMETHOD.


  METHOD get_data.

    rr_ship   = REF #( ms_ship ).

  ENDMETHOD.


  METHOD get_ee_rel_data.

    DATA: lt_appobjid TYPE STANDARD TABLE OF ts_ee_rel-appobjid.

    CLEAR: et_ee_rel.

    lt_appobjid   = VALUE #( FOR ls_likp IN is_ship-likp
                             ( zcl_gtt_mia_dl_tools=>get_tracking_id_dl_header(
                                 ir_likp = REF #( ls_likp ) ) ) ).

    lt_appobjid   = VALUE #( BASE lt_appobjid
                             FOR ls_lips IN is_ship-lips
                             ( zcl_gtt_mia_dl_tools=>get_tracking_id_dl_item(
                                 ir_lips = REF #( ls_lips ) ) ) ).

    IF lt_appobjid[] IS NOT INITIAL.
      SELECT *
        INTO TABLE et_ee_rel
        FROM zgtt_mia_ee_rel
        FOR ALL ENTRIES IN lt_appobjid
        WHERE appobjid = lt_appobjid-table_line.
    ENDIF.

  ENDMETHOD.


  METHOD get_likp_delta_data.

    DATA:
      ls_likp_delta TYPE ts_likpdl,
      lt_updkz      TYPE RANGE OF updkz_d,
      lv_likp_flg   TYPE flag,
      lt_vttp       TYPE vttpvb_tab.

    CLEAR: et_likp_delta[].

    FIELD-SYMBOLS: <ls_vttp> TYPE vttpvb,
                   <ls_vtsp> TYPE vtspvb,
                   <ls_vtts> TYPE vttsvb.

    LOOP AT is_ship-vttp_dlt ASSIGNING <ls_vttp>
      WHERE updkz = zif_gtt_ef_constants=>cs_change_mode-insert
         OR updkz = zif_gtt_ef_constants=>cs_change_mode-delete.

      IF NOT line_exists( et_likp_delta[ KEY primary_key
                                         COMPONENTS tknum = <ls_vttp>-tknum
                                                    vbeln = <ls_vttp>-vbeln ] ).
        ls_likp_delta = CORRESPONDING #( <ls_vttp> ).
        INSERT ls_likp_delta INTO TABLE et_likp_delta.
      ENDIF.
    ENDLOOP.

    LOOP AT is_ship-vtsp_dlt ASSIGNING <ls_vtsp>
      WHERE updkz = zif_gtt_ef_constants=>cs_change_mode-insert
         OR updkz = zif_gtt_ef_constants=>cs_change_mode-delete.
      ASSIGN is_ship-vtsp_dlt\vttp[ <ls_vtsp> ] TO <ls_vttp>.

      IF sy-subcs = 0.
        IF NOT line_exists( et_likp_delta[ KEY primary_key
                                           COMPONENTS tknum = <ls_vttp>-tknum
                                                      vbeln = <ls_vttp>-vbeln ] ).
          ls_likp_delta = CORRESPONDING #( <ls_vttp> ).
          INSERT ls_likp_delta INTO TABLE et_likp_delta.
        ENDIF.
      ENDIF.
    ENDLOOP.

    LOOP AT is_ship-vtts_dlt ASSIGNING <ls_vtts>.
      LOOP AT is_ship-vtts_dlt\vtsp[ <ls_vtts> ] ASSIGNING <ls_vtsp>.
        ASSIGN is_ship-vtsp_dlt\vttp[ <ls_vtsp> ] TO <ls_vttp>.

        IF sy-subcs = 0.
          IF NOT line_exists( et_likp_delta[ KEY primary_key
                                             COMPONENTS tknum = <ls_vttp>-tknum
                                                        vbeln = <ls_vttp>-vbeln ] ).
            ls_likp_delta = CORRESPONDING #( <ls_vttp> ).
            INSERT ls_likp_delta INTO TABLE et_likp_delta.
          ENDIF.
        ENDIF.
      ENDLOOP.
    ENDLOOP.

*   Additional logic for add planned destination arrival event
*   1.Check the check-in date and time in shipment is changed or not
*   2.If Shipment Item(VTTP) contains newly insert or delete item,all of the delivery should be send to GTT again
*   because we need to generate new planned destination arrival event for these delivery
    lt_updkz  = VALUE #(
      (
        sign = 'I'
        option = 'EQ'
        low = zif_gtt_ef_constants=>cs_change_mode-insert
      )
      (
        sign = 'I'
        option = 'EQ'
        low = zif_gtt_ef_constants=>cs_change_mode-delete
      ) ).

    APPEND LINES OF is_shipment-new_vttp TO lt_vttp.
    APPEND LINES OF is_shipment-old_vttp TO lt_vttp.
    LOOP AT lt_vttp TRANSPORTING NO FIELDS
      WHERE tknum IN it_tknum
        AND updkz IN lt_updkz.
      lv_likp_flg = abap_true.
      EXIT.
    ENDLOOP.

    LOOP AT lt_vttp INTO DATA(ls_vttp)
      WHERE tknum IN it_tknum.

      READ TABLE is_shipment-new_vttk INTO DATA(ls_vttk_new)
        WITH KEY tknum = ls_vttp-tknum.

      READ TABLE is_shipment-old_vttk INTO DATA(ls_vttk_old)
        WITH KEY tknum = ls_vttp-tknum.
      IF ls_vttk_new-dpreg <> ls_vttk_old-dpreg OR ls_vttk_new-upreg <> ls_vttk_old-upreg
        OR lv_likp_flg = abap_true.
        IF NOT line_exists( et_likp_delta[ KEY primary_key
                                           COMPONENTS tknum = ls_vttp-tknum
                                                      vbeln = ls_vttp-vbeln ] ).
          ls_likp_delta = CORRESPONDING #( ls_vttp ).
          INSERT ls_likp_delta INTO TABLE et_likp_delta.
        ENDIF.
      ENDIF.
      CLEAR:
        ls_vttk_new,
        ls_vttk_old,
        ls_likp_delta.
    ENDLOOP.

  ENDMETHOD.


  METHOD get_lips_data.

    DATA: ls_lips   TYPE lips.

    CLEAR: et_lips[].

    IF is_ship-likp[] IS NOT INITIAL.
      SELECT * INTO ls_lips
        FROM lips
        FOR ALL ENTRIES IN is_ship-likp
        WHERE vbeln = is_ship-likp-vbeln.

        READ TABLE is_ship-likp INTO DATA(ls_likp) WITH KEY vbeln = ls_lips-vbeln.
        IF sy-subrc <> 0.
          CONTINUE.
        ENDIF.
        IF zcl_gtt_tools=>is_appropriate_dl_item( ir_likp = REF #( ls_likp ) ir_lips = REF #( ls_lips ) ) = abap_true.
          INSERT ls_lips INTO TABLE et_lips.
        ENDIF.
      ENDSELECT.
    ENDIF.

  ENDMETHOD.


  METHOD get_stops.

    rr_stops  = REF #( mt_stops ).

  ENDMETHOD.


  METHOD get_vbfa_and_likp_data.

    DATA: ls_comwa6 TYPE vbco6,
          lt_vbfas  TYPE STANDARD TABLE OF vbfas,
          lv_vbeln  TYPE likp-vbeln,
          ls_vbfa   TYPE ts_vbfaex,
          ls_likp   TYPE ts_likpex,
          ls_vttk   TYPE vttk.

    CLEAR: et_vbfa[], et_likp[].

    LOOP AT is_ship-likp_dlt ASSIGNING FIELD-SYMBOL(<ls_likp_dlt>).
      CLEAR: ls_comwa6, lt_vbfas.
      MOVE-CORRESPONDING <ls_likp_dlt> TO ls_comwa6.

      CALL FUNCTION 'RV_ORDER_FLOW_INFORMATION'
        EXPORTING
          comwa         = ls_comwa6
        TABLES
          vbfa_tab      = lt_vbfas
        EXCEPTIONS
          no_vbfa       = 1
          no_vbuk_found = 2
          OTHERS        = 3.

      IF sy-subrc = 0.
        LOOP AT lt_vbfas ASSIGNING FIELD-SYMBOL(<ls_vbfas>)
          WHERE vbtyp_n = zif_gtt_mia_app_constants=>cs_vbtyp-shipment
            AND vbtyp_v = zif_gtt_mia_app_constants=>cs_vbtyp-delivery.

          SELECT SINGLE *
            INTO ls_vttk
            FROM vttk
            WHERE tknum = <ls_vbfas>-vbeln.

          IF sy-subrc = 0 AND
             zcl_gtt_mia_sh_tools=>is_appropriate_type(
               ir_vttk = REF #( ls_vttk ) ) = abap_true.

            SELECT SINGLE *
              INTO CORRESPONDING FIELDS OF ls_likp
              FROM likp
              WHERE vbeln = <ls_vbfas>-vbelv.

            IF sy-subrc = 0 AND
               zcl_gtt_tools=>is_appropriate_dl_type(
                 ir_likp = REF #( ls_likp ) ) = abap_true.

              ls_vbfa       = CORRESPONDING #( <ls_vbfas> ).
              ls_vbfa-tknum = <ls_likp_dlt>-tknum.

              INSERT ls_vbfa INTO TABLE et_vbfa.

              IF NOT line_exists( et_likp[ KEY primary_key
                                           COMPONENTS tknum = <ls_likp_dlt>-tknum
                                                      vbeln = ls_likp-vbeln ] ).
                ls_likp-tknum = <ls_likp_dlt>-tknum.
                INSERT ls_likp INTO TABLE et_likp.
              ENDIF.
            ENDIF.
          ENDIF.
        ENDLOOP.
      ENDIF.
    ENDLOOP.

    LOOP AT is_ship-vttp_dlt ASSIGNING FIELD-SYMBOL(<ls_vttp_dlt>).
      " DELETED
      IF <ls_vttp_dlt>-updkz = zif_gtt_ef_constants=>cs_change_mode-delete.
        DELETE et_vbfa
          WHERE vbeln = <ls_vttp_dlt>-tknum
            AND vbelv = <ls_vttp_dlt>-vbeln.

        " ADDED
      ELSEIF <ls_vttp_dlt>-updkz = zif_gtt_ef_constants=>cs_change_mode-insert AND
             NOT line_exists( et_vbfa[ KEY primary_key
                                       COMPONENTS tknum = <ls_vttp_dlt>-tknum
                                                  vbeln = <ls_vttp_dlt>-tknum
                                                  vbelv = <ls_vttp_dlt>-vbeln ] ).

        SELECT SINGLE *
          INTO CORRESPONDING FIELDS OF ls_likp
          FROM likp
          WHERE vbeln = <ls_vttp_dlt>-vbeln.

        IF sy-subrc = 0 AND
               zcl_gtt_tools=>is_appropriate_dl_type(
                 ir_likp = REF #( ls_likp ) ) = abap_true.

          ls_vbfa-tknum = <ls_vttp_dlt>-tknum.
          ls_vbfa-vbelv = <ls_vttp_dlt>-vbeln.
          ls_vbfa-vbeln = <ls_vttp_dlt>-tknum.
          INSERT ls_vbfa INTO TABLE et_vbfa.

          IF NOT line_exists( et_likp[ KEY primary_key
                                       COMPONENTS tknum = <ls_vttp_dlt>-tknum
                                                  vbeln = ls_likp-vbeln ] ).
            ls_likp-tknum   = <ls_vttp_dlt>-tknum.
            INSERT ls_likp INTO TABLE et_likp.
          ENDIF.
        ENDIF.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.


  METHOD get_vtsp_merged_data.

    FIELD-SYMBOLS: <ls_vtsp>  TYPE vtspvb.
    CLEAR: et_vtsp_delta[].

    et_vtsp_full  = is_shipment-new_vtsp[].

    LOOP AT is_shipment-old_vtsp ASSIGNING <ls_vtsp>
      WHERE updkz = zif_gtt_ef_constants=>cs_change_mode-delete.

      et_vtsp_full  = VALUE #( BASE et_vtsp_full
                               ( <ls_vtsp> ) ).
    ENDLOOP.

    LOOP AT et_vtsp_full ASSIGNING <ls_vtsp>
      WHERE tknum IN it_tknum
        AND ( updkz = zif_gtt_ef_constants=>cs_change_mode-insert
           OR updkz = zif_gtt_ef_constants=>cs_change_mode-delete ).

      et_vtsp_delta   = VALUE #( BASE et_vtsp_delta
                                 ( <ls_vtsp> ) ).
    ENDLOOP.

  ENDMETHOD.


  METHOD get_vttk_merged_data.

    CLEAR: et_vttk[].

    " collect all the current shipments
    LOOP AT is_shipment-new_vttk ASSIGNING FIELD-SYMBOL(<ls_vttk_new>).
      IF zcl_gtt_mia_sh_tools=>is_appropriate_type(
           ir_vttk = REF #( <ls_vttk_new> ) ) = abap_true.

        et_vttk   = VALUE #( BASE et_vttk
                             ( <ls_vttk_new> ) ).
      ENDIF.
    ENDLOOP.

    " add deleted shipments
    LOOP AT is_shipment-old_vttk ASSIGNING FIELD-SYMBOL(<ls_vttk_old>)
      WHERE updkz = zif_gtt_ef_constants=>cs_change_mode-delete.

      IF zcl_gtt_mia_sh_tools=>is_appropriate_type(
           ir_vttk = REF #( <ls_vttk_old> ) ) = abap_true.

        et_vttk   = VALUE #( BASE et_vttk
                             ( <ls_vttk_old> ) ).
      ENDIF.
    ENDLOOP.

  ENDMETHOD.


  METHOD get_vttp_merged_data.

    FIELD-SYMBOLS: <ls_vttp>  TYPE vttpvb.
    CLEAR: et_vttp_delta[].

    et_vttp_full  = is_shipment-new_vttp[].

    LOOP AT is_shipment-old_vttp ASSIGNING <ls_vttp>
      WHERE updkz = zif_gtt_ef_constants=>cs_change_mode-delete.

      et_vttp_full  = VALUE #( BASE et_vttp_full
                               ( <ls_vttp> ) ).
    ENDLOOP.

    LOOP AT et_vttp_full ASSIGNING <ls_vttp>
      WHERE tknum IN it_tknum
        AND ( updkz = zif_gtt_ef_constants=>cs_change_mode-insert
           OR updkz = zif_gtt_ef_constants=>cs_change_mode-delete ).

      et_vttp_delta   = VALUE #( BASE et_vttp_delta
                                 ( <ls_vttp> ) ).
    ENDLOOP.

  ENDMETHOD.


  METHOD get_vtts_merged_data.

    FIELD-SYMBOLS: <ls_vtts>  TYPE vttsvb.
    CLEAR: et_vtts_delta[].

    et_vtts_full  = is_shipment-new_vtts[].

    LOOP AT is_shipment-old_vtts ASSIGNING <ls_vtts>
      WHERE updkz = zif_gtt_ef_constants=>cs_change_mode-delete.

      et_vtts_full  = VALUE #( BASE et_vtts_full
                               ( <ls_vtts> ) ).
    ENDLOOP.

    LOOP AT et_vtts_full ASSIGNING <ls_vtts>
      WHERE tknum IN it_tknum.

      IF is_vtts_changed( is_shipment = is_shipment
                          is_vtts     = <ls_vtts> ) = abap_true.

        et_vtts_delta   = VALUE #( BASE et_vtts_delta
                                   ( <ls_vtts> ) ).
      ENDIF.
    ENDLOOP.

  ENDMETHOD.


  METHOD init_shipment_data.

    DATA: lt_tknum    TYPE tt_tknum.

    CLEAR: es_ship.

    get_vttk_merged_data(
      EXPORTING
        is_shipment = is_shipment
      IMPORTING
        et_vttk     = es_ship-vttk ).

    lt_tknum    = VALUE #( FOR ls_vttk IN es_ship-vttk
                           ( low    = ls_vttk-tknum
                             sign   = 'I'
                             option = 'EQ' ) ).

    get_vttp_merged_data(
      EXPORTING
        is_shipment   = is_shipment
        it_tknum      = lt_tknum
      IMPORTING
        et_vttp_full  = es_ship-vttp
        et_vttp_delta = es_ship-vttp_dlt ).

    get_vtts_merged_data(
      EXPORTING
        is_shipment   = is_shipment
        it_tknum      = lt_tknum
      IMPORTING
        et_vtts_full  = es_ship-vtts
        et_vtts_delta = es_ship-vtts_dlt ).

    get_vtsp_merged_data(
      EXPORTING
        is_shipment   = is_shipment
        it_tknum      = lt_tknum
      IMPORTING
        et_vtsp_full  = es_ship-vtsp
        et_vtsp_delta = es_ship-vtsp_dlt ).

    get_likp_delta_data(
      EXPORTING
        is_ship       = es_ship
        it_tknum      = lt_tknum
        is_shipment   = is_shipment
      IMPORTING
        et_likp_delta = es_ship-likp_dlt ).

    get_vbfa_and_likp_data(
      EXPORTING
        is_ship       = es_ship
      IMPORTING
        et_vbfa       = es_ship-vbfa
        et_likp       = es_ship-likp ).

    get_lips_data(
      EXPORTING
        is_ship       = es_ship
      IMPORTING
        et_lips       = es_ship-lips ).

    get_ee_rel_data(
      EXPORTING
        is_ship       = es_ship
      IMPORTING
        et_ee_rel     = es_ship-ee_rel ).

  ENDMETHOD.


  METHOD init_stops_data.

    DATA: lt_stops    TYPE zif_gtt_mia_app_types=>tt_stops,
          lt_watching TYPE zif_gtt_mia_app_types=>tt_dlv_watch_stops.

    FIELD-SYMBOLS: <ls_stops> TYPE ts_stops.

    CLEAR: et_stops[].

    "initiate table
    LOOP AT is_ship-vttk ASSIGNING FIELD-SYMBOL(<ls_vttk>).
      et_stops    = VALUE #( BASE et_stops
                             ( tknum = <ls_vttk>-tknum ) ).
    ENDLOOP.

    LOOP AT is_ship-vbfa ASSIGNING FIELD-SYMBOL(<ls_vbfa>).
      CLEAR: lt_stops[], lt_watching[].

      IF <ls_vbfa>-vbeln = <ls_vbfa>-tknum.
        zcl_gtt_mia_sh_tools=>get_stops_from_shipment(
          EXPORTING
            iv_tknum              = <ls_vbfa>-tknum
            it_vtts               = is_shipment-new_vtts
            it_vtsp               = is_shipment-new_vtsp
            it_vttp               = is_shipment-new_vttp
          IMPORTING
            et_stops              = lt_stops
            et_dlv_watching_stops = lt_watching ).

      ELSE.
        zcl_gtt_mia_sh_tools=>get_stops_from_shipment(
          EXPORTING
            iv_tknum              = <ls_vbfa>-vbeln
          IMPORTING
            et_stops              = lt_stops
            et_dlv_watching_stops = lt_watching ).
      ENDIF.

      READ TABLE et_stops ASSIGNING <ls_stops>
        WITH TABLE KEY tknum = <ls_vbfa>-tknum.

      IF sy-subrc = 0.
        <ls_stops>-stops    = VALUE #( BASE <ls_stops>-stops
                                       ( LINES OF lt_stops ) ).

        <ls_stops>-watching = VALUE #( BASE <ls_stops>-watching
                                       ( LINES OF lt_watching ) ).
      ELSE.
        MESSAGE e005(zgtt) WITH |{ <ls_vbfa>-tknum }| 'STOPS' INTO DATA(lv_dummy).
        zcl_gtt_tools=>throw_exception( ).
      ENDIF.
    ENDLOOP.

    LOOP AT et_stops ASSIGNING <ls_stops>.
      SORT <ls_stops>-stops    BY stopid loccat.
      SORT <ls_stops>-watching BY vbeln stopid loccat.

      DELETE ADJACENT DUPLICATES FROM <ls_stops>-stops
        COMPARING stopid loccat.
      DELETE ADJACENT DUPLICATES FROM <ls_stops>-watching
        COMPARING vbeln stopid loccat.
    ENDLOOP.
  ENDMETHOD.


  METHOD is_vtts_changed.

    IF is_vtts-updkz = zif_gtt_ef_constants=>cs_change_mode-insert OR
       is_vtts-updkz = zif_gtt_ef_constants=>cs_change_mode-delete.
      rv_result   = abap_true.
    ELSEIF ( is_vtts-updkz = zif_gtt_ef_constants=>cs_change_mode-update OR
             is_vtts-updkz = zif_gtt_ef_constants=>cs_change_mode-undefined ).

      READ TABLE is_shipment-old_vtts ASSIGNING FIELD-SYMBOL(<ls_vtts_old>)
        WITH KEY tknum = is_vtts-tknum
                 tsnum = is_vtts-tsnum
                 BINARY SEARCH.

      rv_result = boolc(
         sy-subrc = 0 ).
    ELSE.
      rv_result   = abap_false.
    ENDIF.

  ENDMETHOD.
ENDCLASS.
