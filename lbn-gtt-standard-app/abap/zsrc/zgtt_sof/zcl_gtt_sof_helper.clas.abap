class ZCL_GTT_SOF_HELPER definition
  public
  final
  create public .

public section.

  types:
    TT_AOTREFD TYPE STANDARD TABLE OF /saptrx/aotrefd .
  types:
    tt_bapi_evm_header     TYPE STANDARD TABLE OF /saptrx/bapi_evm_header .
  types:
    tt_bapi_evm_locationid TYPE STANDARD TABLE OF /saptrx/bapi_evm_locationid .
  types:
    tt_bapi_evm_parameters TYPE STANDARD TABLE OF /saptrx/bapi_evm_parameters .

  constants CV_PARTNER_TYPE type EDI_RCVPRT value 'LS' ##NO_TEXT.
  constants CV_MSG_TYPE_AOPOST type EDI_MESTYP value 'AOPOST' ##NO_TEXT.
  constants CV_IDOC_TYPE_EHPOST01 type EDI_IDOCTP value 'EHPOST01' ##NO_TEXT.
  constants CV_SEG_E1EHPAO type EDILSEGTYP value 'E1EHPAO' ##NO_TEXT.
  constants CV_SEG_E1EHPTID type EDILSEGTYP value 'E1EHPTID' ##NO_TEXT.
  constants CV_SEG_E1EHPCP type EDILSEGTYP value 'E1EHPCP' ##NO_TEXT.
  constants CV_SEG_E1EHPEE type EDILSEGTYP value 'E1EHPEE' ##NO_TEXT.
  constants:
    begin of CV_TT_VERSION,
    GTT10 type /SAPTRX/EM_VERSION value 'GTT1.0',
    GTT20 type /SAPTRX/EM_VERSION value 'GTT2.0',
  end of CV_TT_VERSION .
  constants CV_MSG_TYPE_GTTMSG type EDI_MESTYP value 'GTTMSG' ##NO_TEXT.
  constants CV_IDOC_TYPE_GTTMSG01 type EDI_IDOCTP value 'GTTMSG01' ##NO_TEXT.
  class-data ST_IDOC_DATA type /SAPTRX/T_LOGSYS_IDOC_MAP .

  class-methods SEND_IDOC_EHPOST01
    importing
      !IT_CONTROL type /SAPTRX/BAPI_TRK_CONTROL_TAB
      !IT_TRACKING_ID type /SAPTRX/BAPI_TRK_TRKID_TAB
      !IT_EXP_EVENT type /SAPTRX/BAPI_TRK_EE_TAB optional
      !IS_TRXSERV type /SAPTRX/TRXSERV
      !IV_APPSYS type LOGSYS
      !IT_APPOBJ_CTABS type TRXAS_APPOBJ_CTABS
    exporting
      !ET_BAPIRETURN type BAPIRET2_T .
  class-methods CHECK_AND_CORRECT_TIMESTAMP
    importing
      !IV_TIMESTAMP type TZNTSTMPSL
    returning
      value(RV_TIMESTAMP) type TZNTSTMPSL .
  class-methods SEND_IDOC_GTTMSG01
    exporting
      !ET_BAPIRETURN type BAPIRET2_T .
protected section.
private section.
ENDCLASS.



CLASS ZCL_GTT_SOF_HELPER IMPLEMENTATION.


  METHOD CHECK_AND_CORRECT_TIMESTAMP.
    DATA: lv_date_wrong   TYPE d,
          lv_date_correct TYPE d,
          lv_time_correct TYPE t.

    IF iv_timestamp+9(6) = '240000'.
      lv_date_wrong = iv_timestamp+1(8).
      lv_time_correct = '000000'.
      CALL METHOD cl_abap_tstmp=>td_add
        EXPORTING
          date     = lv_date_wrong
          time     = lv_time_correct
          secs     = 86400
        IMPORTING
          res_date = lv_date_correct
          res_time = lv_time_correct.

      CONCATENATE iv_timestamp(1) lv_date_correct lv_time_correct INTO rv_timestamp.
    ELSE.
      rv_timestamp = iv_timestamp.
    ENDIF.
  ENDMETHOD.


  METHOD SEND_IDOC_EHPOST01.
    FIELD-SYMBOLS:
      <ls_idoc_data> TYPE /saptrx/s_logsys_idoc_map.
    DATA: ls_master_idoc_control        TYPE edidc,
          lt_master_idoc_data           TYPE edidd_tt,
          ls_master_idoc_data           TYPE edidd,
          ls_e1ehpao                    TYPE e1ehpao,
          ls_e1ehptid                   TYPE e1ehptid,
          ls_e1ehpcp                    TYPE e1ehpcp,
          ls_e1ehpee                    TYPE e1ehpee,
          lt_communication_idoc_control TYPE edidc_tt,
          lr_appobj_ctabs               TYPE REF TO trxas_appobj_ctab_wa,
          lr_control                    TYPE REF TO /saptrx/bapi_trk_control_data,
          lr_tracking_id                TYPE REF TO /saptrx/bapi_trk_track_id,
          lr_exp_events                 TYPE REF TO /saptrx/bapi_trk_exp_events,
          lv_timestamp                  TYPE tzntstmpsl.

* fill idoc control
    ls_master_idoc_control-rcvprt = cv_partner_type.
    ls_master_idoc_control-rcvprn = is_trxserv-trx_server.
    ls_master_idoc_control-mestyp = cv_msg_type_aopost.
    ls_master_idoc_control-idoctp = cv_idoc_type_ehpost01.

    LOOP AT it_appobj_ctabs REFERENCE INTO lr_appobj_ctabs
      WHERE trxservername = is_trxserv-trx_server_id.
      CLEAR ls_e1ehpao.
*     fill idoc header segment
      ls_master_idoc_data-mandt = sy-mandt.
      ls_master_idoc_data-segnam = cv_seg_e1ehpao.

* supported fields have to be populated in the IDOC; the ones not used here are NOT supported in GT&T
      ls_e1ehpao-appsys     = iv_appsys.
      ls_e1ehpao-appobjtype = lr_appobj_ctabs->appobjtype.
      ls_e1ehpao-appobjid   = lr_appobj_ctabs->appobjid.
      ls_master_idoc_data-sdata = ls_e1ehpao.
      INSERT ls_master_idoc_data INTO TABLE lt_master_idoc_data.

*     fill control parameters segment
      LOOP AT it_control REFERENCE INTO lr_control
          WHERE appsys = iv_appsys AND
                appobjtype = lr_appobj_ctabs->appobjtype AND
                appobjid   = lr_appobj_ctabs->appobjid.
        CLEAR ls_e1ehpcp.
        ls_master_idoc_data-segnam = cv_seg_e1ehpcp.
* supported fields have to be populated in the IDOC; the ones not used here are NOT supported in GT&T
        ls_e1ehpcp-paramname      = lr_control->paramname.
        ls_e1ehpcp-paramindex     = lr_control->paramindex.
        ls_e1ehpcp-value          = lr_control->value.
        IF lr_control->action = 'D'. "only used in deletion case
          ls_e1ehpcp-action         = lr_control->action.
        ENDIF.
        ls_master_idoc_data-sdata = ls_e1ehpcp.
        INSERT ls_master_idoc_data INTO TABLE lt_master_idoc_data.
      ENDLOOP.

*     fill expected events segment
      LOOP AT it_exp_event REFERENCE INTO lr_exp_events
          WHERE appsys = iv_appsys AND
                appobjtype = lr_appobj_ctabs->appobjtype AND
                appobjid   = lr_appobj_ctabs->appobjid.
        CLEAR ls_e1ehpee.
        ls_master_idoc_data-segnam = cv_seg_e1ehpee.

* supported fields have to be populated in the IDOC; the ones not used here are NOT supported in GT&T
        ls_e1ehpee-milestonenum       = lr_exp_events->milestonenum.
        ls_e1ehpee-milestone          = lr_exp_events->milestone.
*        ls_e1ehpee-carrtype           = lr_exp_events->carrtype.
        ls_e1ehpee-carrid             = lr_exp_events->carrid.
        ls_e1ehpee-loctype            = lr_exp_events->loctype.
        ls_e1ehpee-locid1             = lr_exp_events->locid1.
        ls_e1ehpee-locid2             = lr_exp_events->locid2.
*        ls_e1ehpee-sndtype            = lr_exp_events->sndtype.
        ls_e1ehpee-sndid              = lr_exp_events->sndid.

        ls_e1ehpee-msg_exp_datetime   = check_and_correct_timestamp( lr_exp_events->msg_exp_datetime ).
        ls_e1ehpee-msg_exp_tzone      = lr_exp_events->msg_exp_tzone.
        ls_e1ehpee-msg_er_exp_dtime   = check_and_correct_timestamp( lr_exp_events->msg_er_exp_dtime ).
        ls_e1ehpee-msg_lt_exp_dtime   = check_and_correct_timestamp( lr_exp_events->msg_lt_exp_dtime ).
        ls_e1ehpee-evt_exp_datetime   = check_and_correct_timestamp( lr_exp_events->evt_exp_datetime ).
        ls_e1ehpee-evt_exp_tzone      = lr_exp_events->evt_exp_tzone.
        ls_e1ehpee-evt_er_exp_dtime   = check_and_correct_timestamp( lr_exp_events->evt_er_exp_dtime ).
        ls_e1ehpee-evt_lt_exp_dtime   = check_and_correct_timestamp( lr_exp_events->evt_lt_exp_dtime ).
        ls_e1ehpee-itemident          = lr_exp_events->itemident.
        ls_e1ehpee-datacs             = lr_exp_events->datacs.
        ls_e1ehpee-dataid             = lr_exp_events->dataid.

        ls_master_idoc_data-sdata = ls_e1ehpee.
        INSERT ls_master_idoc_data INTO TABLE lt_master_idoc_data.
      ENDLOOP.

*     fill tracking IDs segment
      LOOP AT it_tracking_id REFERENCE INTO lr_tracking_id
          WHERE appsys = iv_appsys AND
                appobjtype = lr_appobj_ctabs->appobjtype AND
                appobjid   = lr_appobj_ctabs->appobjid.
        CLEAR ls_e1ehptid.
        ls_master_idoc_data-segnam = cv_seg_e1ehptid.
* supported fields have to be populated in the IDOC; the ones not used here are NOT supported in GT&T
        ls_e1ehptid-trxcod          = lr_tracking_id->trxcod.
        ls_e1ehptid-trxid           = lr_tracking_id->trxid.
        ls_e1ehptid-start_date      = check_and_correct_timestamp( lr_tracking_id->start_date ).
        ls_e1ehptid-end_date        = check_and_correct_timestamp( lr_tracking_id->end_date ).
        ls_e1ehptid-timzon          = lr_tracking_id->timzon.
        IF lr_tracking_id->action = 'D'. "only used in deletion case
          ls_e1ehptid-action          = lr_tracking_id->action.
        ENDIF.

        ls_master_idoc_data-sdata = ls_e1ehptid.
        INSERT ls_master_idoc_data INTO TABLE lt_master_idoc_data.
      ENDLOOP.

    ENDLOOP.

    CHECK lt_master_idoc_data IS NOT INITIAL.

    CASE is_trxserv-em_version.
*     EM version = GTT1.0 -> distribute IDOC EHPOST
      WHEN cv_tt_version-gtt10.

        CALL FUNCTION 'MASTER_IDOC_DISTRIBUTE'
          EXPORTING
            master_idoc_control            = ls_master_idoc_control
          TABLES
            communication_idoc_control     = lt_communication_idoc_control
            master_idoc_data               = lt_master_idoc_data
          EXCEPTIONS
            error_in_idoc_control          = 1
            error_writing_idoc_status      = 2
            error_in_idoc_data             = 3
            sending_logical_system_unknown = 4
            OTHERS                         = 5.
        IF sy-subrc <> 0.
          " fill bapireturn
        ENDIF.
*     EM version = GTT2.0 -> collect the content grouped by logical system to compose combined IDOC GTTMSG later
      WHEN cv_tt_version-gtt20.
        READ TABLE st_idoc_data WITH KEY trx_server = is_trxserv-trx_server ASSIGNING <ls_idoc_data>.

        IF sy-subrc IS INITIAL.
          APPEND LINES OF lt_master_idoc_data TO <ls_idoc_data>-idoc_data.
        ELSE.
          APPEND INITIAL LINE TO st_idoc_data ASSIGNING <ls_idoc_data>.
          <ls_idoc_data>-trx_server = is_trxserv-trx_server.
          APPEND LINES OF lt_master_idoc_data TO <ls_idoc_data>-idoc_data.
        ENDIF.

      WHEN OTHERS.
        " do nothing
    ENDCASE.

  ENDMETHOD.


  METHOD SEND_IDOC_GTTMSG01.
**********************************************************************
* This method creates and distributes the new IDOC type GTTMSG01 to
* SAP Logistics Busiss Network - Global Track & Trace Option
* Content of ST_IDOC_DATA must not be empty and
* is expected to be filled by methods
*   - ZCL_GTT_SOF_UPD_XTP_REFERENCES=>SEND_IDOC_EHPOST01
* Expected EM version is GTT2.0
**********************************************************************
    DATA: ls_master_idoc_control        TYPE edidc,
          lt_communication_idoc_control TYPE edidc_tt,
          lt_master_idoc_data           TYPE edidd_tt.

    FIELD-SYMBOLS:
          <ls_idoc_data> TYPE /saptrx/s_logsys_idoc_map.

    " Check if data is provided
    CHECK st_idoc_data IS NOT INITIAL.

    " Create IDOC header
    ls_master_idoc_control-rcvprt = cv_partner_type.
    ls_master_idoc_control-mestyp = cv_msg_type_gttmsg.
    ls_master_idoc_control-idoctp = cv_idoc_type_gttmsg01.

    " Send message to each logical system separately
    LOOP AT st_idoc_data ASSIGNING <ls_idoc_data>.
      CLEAR: lt_master_idoc_data.

      " Set Tracking Server (Logical System)
      ls_master_idoc_control-rcvprn = <ls_idoc_data>-trx_server.
      " Set IDOC Content
      lt_master_idoc_data = <ls_idoc_data>-idoc_data.

      " Distribute IDOC
      CALL FUNCTION 'MASTER_IDOC_DISTRIBUTE'
        EXPORTING
          master_idoc_control            = ls_master_idoc_control
        TABLES
          communication_idoc_control     = lt_communication_idoc_control
          master_idoc_data               = lt_master_idoc_data
        EXCEPTIONS
          error_in_idoc_control          = 1
          error_writing_idoc_status      = 2
          error_in_idoc_data             = 3
          sending_logical_system_unknown = 4
          OTHERS                         = 5.

      IF sy-subrc IS NOT INITIAL.
        " fill bapireturn
      ENDIF.
    ENDLOOP.

    " Clear data for next iteration
    CLEAR st_idoc_data.

  ENDMETHOD.
ENDCLASS.
