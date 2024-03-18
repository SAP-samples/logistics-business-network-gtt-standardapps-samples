class ZCL_GTT_SPOF_CTP_SND_DL_TO_POH definition
  public
  inheriting from ZCL_GTT_CTP_SND
  create private .

public section.

  class-methods GET_INSTANCE
    returning
      value(RO_SENDER) type ref to ZCL_GTT_SPOF_CTP_SND_DL_TO_POH
    raising
      CX_UDM_MESSAGE .
  methods PREPARE_IDOC_DATA
    importing
      !IO_DLH_DATA type ref to ZCL_GTT_SPOF_CTP_DLH_DATA
    raising
      CX_UDM_MESSAGE .
protected section.

  methods GET_AOTYPE_RESTRICTION_ID
    redefinition .
  methods GET_OBJECT_TYPE
    redefinition .
  methods GET_EVTYPE_RESTRICTION_ID
    redefinition .
private section.

  constants:
    BEGIN OF cs_mapping,
      ebeln        TYPE /saptrx/paramname VALUE 'YN_PO_NUMBER',
      idlv_line_no TYPE /saptrx/paramname VALUE 'YN_IDLV_LINE_NO',
      idlv_no      TYPE /saptrx/paramname VALUE 'YN_IDLV_NO',
      odlv_line_no TYPE /saptrx/paramname VALUE 'YN_ODLV_LINE_NO',
      odlv_no      TYPE /saptrx/paramname VALUE 'YN_ODLV_NO',
    END OF cs_mapping .

  methods PREPARE_IDOC_DATA_FOR_PO
    importing
      !IO_DLH_DATA type ref to ZCL_GTT_SPOF_CTP_DLH_DATA
    raising
      CX_UDM_MESSAGE .
  methods FILL_IDOC_APPOBJ_CTABS
    importing
      !IS_AOTYPE type ZIF_GTT_CTP_TYPES=>TS_AOTYPE
      !IV_APPOBJID type /SAPTRX/AOID
    changing
      !CS_IDOC_DATA type ZIF_GTT_CTP_TYPES=>TS_IDOC_DATA
    raising
      CX_UDM_MESSAGE .
  methods FILL_IDOC_CONTROL_DATA
    importing
      !IS_AOTYPE type ZIF_GTT_CTP_TYPES=>TS_AOTYPE
      !IS_REF_LIST type ZIF_GTT_SPOF_APP_TYPES=>TS_REF_LIST
      !IV_STO_IS_USED type BOOLEAN
    changing
      !CS_IDOC_DATA type ZIF_GTT_CTP_TYPES=>TS_IDOC_DATA
    raising
      CX_UDM_MESSAGE .
  methods FILL_IDOC_EXP_EVENT
    importing
      !IS_AOTYPE type ZIF_GTT_CTP_TYPES=>TS_AOTYPE
      !IS_EKKO type ZIF_GTT_SPOF_APP_TYPES=>TS_UEKKO
      !IT_EKPO type ZIF_GTT_SPOF_APP_TYPES=>TT_UEKPO
      !IT_EKET type ZIF_GTT_SPOF_APP_TYPES=>TT_UEKET
      !IT_LIKP type VA_LIKPVB_T
      !IT_LIPS type VA_LIPSVB_T
    changing
      !CS_IDOC_DATA type ZIF_GTT_CTP_TYPES=>TS_IDOC_DATA
    raising
      CX_UDM_MESSAGE .
  methods FILL_IDOC_TRACKING_ID
    importing
      !IS_AOTYPE type ZIF_GTT_CTP_TYPES=>TS_AOTYPE
      !IV_APPOBJID type /SAPTRX/AOID
    changing
      !CS_IDOC_DATA type ZIF_GTT_CTP_TYPES=>TS_IDOC_DATA
    raising
      CX_UDM_MESSAGE .
ENDCLASS.



CLASS ZCL_GTT_SPOF_CTP_SND_DL_TO_POH IMPLEMENTATION.


  METHOD fill_idoc_appobj_ctabs.

    cs_idoc_data-appobj_ctabs = VALUE #( BASE cs_idoc_data-appobj_ctabs (
      trxservername = cs_idoc_data-trxserv-trx_server_id
      appobjtype    = is_aotype-aot_type
      appobjid      = iv_appobjid  ) ).

  ENDMETHOD.


  METHOD fill_idoc_control_data.

    DATA:
      lt_control       TYPE /saptrx/bapi_trk_control_tab,
      lv_ebeln         TYPE ekko-ebeln,
      lv_count         TYPE i VALUE 0,
      lv_param_line_no TYPE /saptrx/paramname,
      lv_param_dlv_no  TYPE /saptrx/paramname.

    lv_ebeln = is_ref_list-vgbel.
    SHIFT lv_ebeln LEFT DELETING LEADING '0'.

    lv_param_line_no = SWITCH #( iv_sto_is_used WHEN abap_true THEN cs_mapping-odlv_line_no
                                                               ELSE cs_mapping-idlv_line_no ).

    lv_param_dlv_no = SWITCH #( iv_sto_is_used WHEN abap_true THEN cs_mapping-odlv_no
                                                              ELSE cs_mapping-idlv_no ).

    lt_control  = VALUE #(
      (
        paramname = cs_mapping-ebeln
        value     = lv_ebeln
      )
      (
        paramname = zif_gtt_ef_constants=>cs_system_fields-actual_bisiness_timezone
        value     = zcl_gtt_tools=>get_system_time_zone( )
      )
      (
        paramname = zif_gtt_ef_constants=>cs_system_fields-actual_bisiness_datetime
        value     = |0{ sy-datum }{ sy-uzeit }|
      )
      (
        paramname = zif_gtt_ef_constants=>cs_system_fields-actual_technical_timezone
        value     = zcl_gtt_tools=>get_system_time_zone( )
      )
      (
        paramname = zif_gtt_ef_constants=>cs_system_fields-actual_technical_datetime
        value     = |0{ sy-datum }{ sy-uzeit }|
      )
      (
        paramname = zif_gtt_ef_constants=>cs_system_fields-reported_by
        value     = sy-uname
      )
    ).

    LOOP AT is_ref_list-vbeln INTO DATA(ls_vbeln).
      SHIFT ls_vbeln LEFT DELETING LEADING '0'.
      ADD 1 TO lv_count.

      lt_control  = VALUE #( BASE lt_control
        (
          paramindex  = lv_count
          paramname   = lv_param_line_no
          value       = zcl_gtt_tools=>get_pretty_value(
                          iv_value = lv_count )
        )
        (
          paramindex  = lv_count
          paramname   = lv_param_dlv_no
          value       = ls_vbeln
        )
      ).
    ENDLOOP.

    " add deletion sign in case of emtpy is_ref_list-vbeln table
    IF is_ref_list-vbeln IS INITIAL.
      lt_control  = VALUE #( BASE lt_control (
          paramindex = 1
          paramname  = lv_param_line_no
          value      = ''
      ) ).
    ENDIF.

    " fill technical data into all control data records
    LOOP AT lt_control ASSIGNING FIELD-SYMBOL(<ls_control>).
      <ls_control>-appsys     = mv_appsys.
      <ls_control>-appobjtype = is_aotype-aot_type.
      <ls_control>-appobjid   = lv_ebeln.
    ENDLOOP.

    cs_idoc_data-control  = VALUE #( BASE cs_idoc_data-control
                                     ( LINES OF lt_control ) ).

  ENDMETHOD.


  METHOD fill_idoc_exp_event.

    DATA: lt_exp_event      TYPE /saptrx/bapi_trk_ee_tab.

    zcl_gtt_spof_ctp_tools=>get_po_hd_planned_evt(
      EXPORTING
        iv_appsys    = mv_appsys
        is_aotype    = is_aotype
        is_ekko      = is_ekko
        it_ekpo      = it_ekpo
        it_eket      = it_eket
        it_likp      = it_likp
        it_lips      = it_lips
      IMPORTING
        et_exp_event = lt_exp_event
    ).

    IF lt_exp_event[] IS INITIAL.
      lt_exp_event = VALUE #( (
          milestone         = ''
          locid2            = ''
          loctype           = ''
          locid1            = ''
          evt_exp_datetime  = '000000000000000'
          evt_exp_tzone     = ''
      ) ).
    ENDIF.

    LOOP AT lt_exp_event ASSIGNING FIELD-SYMBOL(<ls_exp_event>).
      <ls_exp_event>-appsys         = mv_appsys.
      <ls_exp_event>-appobjtype     = is_aotype-aot_type.
      <ls_exp_event>-appobjid       = zcl_gtt_spof_po_tools=>get_tracking_id_po_hdr( ir_ekko = REF #( is_ekko ) ).
      <ls_exp_event>-language       = sy-langu.
    ENDLOOP.

    cs_idoc_data-exp_event = VALUE #( BASE cs_idoc_data-exp_event
                                      ( LINES OF lt_exp_event ) ).

  ENDMETHOD.


  METHOD FILL_IDOC_TRACKING_ID.

    cs_idoc_data-tracking_id    = VALUE #( BASE cs_idoc_data-tracking_id (
      appsys      = mv_appsys
      appobjtype  = is_aotype-aot_type
      appobjid    = iv_appobjid
      trxcod      = zif_gtt_ef_constants=>cs_trxcod-po_number
      trxid       = iv_appobjid
      timzon      = zcl_gtt_tools=>get_system_time_zone( )
    ) ).

  ENDMETHOD.


  METHOD GET_AOTYPE_RESTRICTION_ID.

    rv_rst_id   = 'DL_TO_POHD'.

  ENDMETHOD.


  METHOD GET_EVTYPE_RESTRICTION_ID.

    rv_rst_id   = 'DL_TO_POHD'.

  ENDMETHOD.


  METHOD get_instance.

    DATA(lt_trk_obj_type) = VALUE zif_gtt_ctp_types=>tt_trk_obj_type(
       ( zif_gtt_ef_constants=>cs_trk_obj_type-esc_purord )
       ( zif_gtt_ef_constants=>cs_trk_obj_type-esc_deliv )
    ).

    IF is_gtt_enabled( it_trk_obj_type = lt_trk_obj_type ) = abap_true.
      ro_sender  = NEW #( ).
      ro_sender->initiate( ).

    ENDIF.

  ENDMETHOD.


  METHOD GET_OBJECT_TYPE.

    rv_objtype  = zif_gtt_ef_constants=>cs_trk_obj_type-esc_purord.

  ENDMETHOD.


  METHOD prepare_idoc_data.

    prepare_idoc_data_for_po( io_dlh_data = io_dlh_data ).

  ENDMETHOD.


  METHOD prepare_idoc_data_for_po.

    FIELD-SYMBOLS:
      <lt_ref_list> TYPE zif_gtt_spof_app_types=>tt_ref_list,
      <lt_ekko>     TYPE zif_gtt_spof_app_types=>tt_uekko,
      <lt_ekpo>     TYPE zif_gtt_spof_app_types=>tt_uekpo,
      <lt_eket>     TYPE zif_gtt_spof_app_types=>tt_ueket,
      <lt_likp>     TYPE va_likpvb_t,
      <lt_lips>     TYPE va_lipsvb_t.

    DATA:
      ls_idoc_data TYPE zif_gtt_ctp_types=>ts_idoc_data,
      lv_appobjid  TYPE /saptrx/aoid,
      ls_ekko      TYPE zif_gtt_spof_app_types=>ts_uekko,
      lt_eket      TYPE zif_gtt_spof_app_types=>tt_ueket,
      lt_ekpo      TYPE zif_gtt_spof_app_types=>tt_uekpo.

    io_dlh_data->get_related_po_data(
      IMPORTING
        rr_ekko        = DATA(lr_ekko)
        rr_ekpo        = DATA(lr_ekpo)
        rr_eket        = DATA(lr_eket)
        rr_ref_list    = DATA(lr_ref_list)
        rr_likp        = DATA(lr_likp)
        rr_lips        = DATA(lr_lips)
        ev_sto_is_used = DATA(lv_sto_is_used) ).

    ASSIGN lr_ekko->* TO <lt_ekko>.
    ASSIGN lr_ekpo->* TO <lt_ekpo>.
    ASSIGN lr_eket->* TO <lt_eket>.
    ASSIGN lr_ref_list->* TO <lt_ref_list>.
    ASSIGN lr_likp->* TO <lt_likp>.
    ASSIGN lr_lips->* TO <lt_lips>.

    LOOP AT <lt_ref_list> ASSIGNING FIELD-SYMBOL(<fs_ref_list>).
      CLEAR:
        lv_appobjid,
        ls_ekko,
        lt_ekpo,
        lt_eket.

      READ TABLE <lt_ekko> INTO ls_ekko WITH KEY ebeln = <fs_ref_list>-vgbel.
      IF sy-subrc <> 0.
        CONTINUE.
      ENDIF.

      LOOP AT <lt_ekpo> ASSIGNING FIELD-SYMBOL(<ls_ekpo>) WHERE ebeln = <fs_ref_list>-vgbel.
        lt_ekpo = VALUE #( BASE lt_ekpo ( <ls_ekpo> ) ).
      ENDLOOP.

      LOOP AT <lt_eket> ASSIGNING FIELD-SYMBOL(<ls_eket>) WHERE ebeln = <fs_ref_list>-vgbel.
        lt_eket = VALUE #( BASE lt_eket ( <ls_eket> ) ).
      ENDLOOP.

      lv_appobjid = <fs_ref_list>-vgbel.
      CONDENSE lv_appobjid NO-GAPS.
      SHIFT lv_appobjid LEFT DELETING LEADING '0'.

      LOOP AT mt_aotype ASSIGNING FIELD-SYMBOL(<ls_aotype>).
        CLEAR:
          ls_idoc_data.

        ls_idoc_data-appsys   = mv_appsys.

        fill_idoc_trxserv(
          EXPORTING
            is_aotype    = <ls_aotype>
          CHANGING
            cs_idoc_data = ls_idoc_data ).

        fill_idoc_appobj_ctabs(
          EXPORTING
            is_aotype    = <ls_aotype>
            iv_appobjid  = lv_appobjid
          CHANGING
            cs_idoc_data = ls_idoc_data ).

        fill_idoc_control_data(
          EXPORTING
            is_aotype      = <ls_aotype>
            is_ref_list    = <fs_ref_list>
            iv_sto_is_used = lv_sto_is_used
          CHANGING
            cs_idoc_data   = ls_idoc_data ).

        fill_idoc_exp_event(
          EXPORTING
            is_aotype    = <ls_aotype>
            is_ekko      = ls_ekko
            it_ekpo      = lt_ekpo
            it_eket      = lt_eket
            it_likp      = <lt_likp>
            it_lips      = <lt_lips>
          CHANGING
            cs_idoc_data = ls_idoc_data ).

        fill_idoc_tracking_id(
          EXPORTING
            is_aotype    = <ls_aotype>
            iv_appobjid  = lv_appobjid
          CHANGING
            cs_idoc_data = ls_idoc_data ).

        IF ls_idoc_data-appobj_ctabs[] IS NOT INITIAL AND
         ls_idoc_data-control[] IS NOT INITIAL AND
         ls_idoc_data-tracking_id[] IS NOT INITIAL.
          APPEND ls_idoc_data TO mt_idoc_data.
        ENDIF.
      ENDLOOP.
    ENDLOOP.

  ENDMETHOD.
ENDCLASS.
