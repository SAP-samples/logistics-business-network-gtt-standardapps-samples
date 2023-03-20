class ZCL_GTT_SPOF_PO_TOOLS definition
  public
  create public .

public section.

  class-methods IS_APPROPRIATE_PO
    importing
      !IR_EKKO type ref to DATA
      !IR_EKPO type ref to DATA
    returning
      value(RV_RESULT) type ABAP_BOOL
    raising
      CX_UDM_MESSAGE .
  class-methods IS_ENABLE_CONFIRMATION_PO_ITEM
    importing
      !IR_EKPO type ref to DATA
    returning
      value(RV_RESULT) type ABAP_BOOL
    raising
      CX_UDM_MESSAGE .
  class-methods IS_APPROPRIATE_PO_ITEM
    importing
      !IR_EKKO type ref to DATA
      !IR_EKPO type ref to DATA
    returning
      value(RV_RESULT) type ABAP_BOOL
    raising
      CX_UDM_MESSAGE .
  class-methods GET_TRACKING_ID_PO_HDR
    importing
      !IR_EKKO type ref to DATA
    returning
      value(RV_TRACK_ID) type /SAPTRX/TRXID
    raising
      CX_UDM_MESSAGE .
  class-methods GET_TRACKING_ID_PO_ITM
    importing
      !IR_EKPO type ref to DATA
    returning
      value(RV_TRACK_ID) type /SAPTRX/TRXID
    raising
      CX_UDM_MESSAGE .
  class-methods GET_PLANT_ADDRESS_NUM_AND_NAME
    importing
      !IV_WERKS type WERKS_D
    exporting
      !EV_ADRNR type ADRNR
      !EV_NAME type NAME1
    raising
      CX_UDM_MESSAGE .
  class-methods GET_ADDRESS_INFO
    importing
      !IV_ADDR_TYPE type AD_ADRTYPE default ZIF_GTT_SPOF_APP_CONSTANTS=>CS_ADRTYPE-ORGANIZATION
      !IV_ADDR_NUMB type AD_ADDRNUM
    exporting
      !EV_ADDRESS type CLIKE
      !EV_EMAIL type CLIKE
      !EV_TELEPHONE type CLIKE
    raising
      CX_UDM_MESSAGE .
  class-methods GET_SUPPLIER_AGENT_ID
    importing
      !IV_LIFNR type ELIFN
    returning
      value(RV_ID_NUM) type /SAPTRX/PARAMVAL200 .
  class-methods GET_FORMATED_MATNR
    importing
      !IR_EKPO type ref to DATA
    returning
      value(RV_MATNR) type CHAR40
    raising
      CX_UDM_MESSAGE .
  class-methods GET_PO_ITEM
    importing
      !I_EBELN type EBELN
      !I_EBELP type EBELP
      !I_ARCHIVED type BOOLE_D
      !IS_EKKO type EKKO
    exporting
      !ES_EKPO type EKPO
    raising
      CX_UDM_MESSAGE .
  class-methods GET_PO_HEADER
    importing
      !I_EBELN type EBELN
    exporting
      !ES_EKKO type EKKO
      !E_ARCHIVED type BOOLE_D
    raising
      CX_UDM_MESSAGE .
  class-methods GET_TRACKING_ID_DL_ITEM
    importing
      !IR_LIPS type ref to DATA
    returning
      value(RV_TRACK_ID) type /SAPTRX/TRXID
    raising
      CX_UDM_MESSAGE .
  class-methods GET_FORMATED_PO_NUMBER
    importing
      !IR_EKKO type ref to DATA
    returning
      value(RV_EBELN) type EBELN
    raising
      CX_UDM_MESSAGE .
  class-methods GET_FORMATED_PO_ITEM_NUMBER
    importing
      !IR_EKPO type ref to DATA
    returning
      value(RV_EBELP) type EBELP
    raising
      CX_UDM_MESSAGE .
  class-methods GET_PO_TYPE
    returning
      value(RT_TYPE) type RSELOPTION .
  PROTECTED SECTION.
private section.
ENDCLASS.



CLASS ZCL_GTT_SPOF_PO_TOOLS IMPLEMENTATION.


  METHOD get_address_info.
    DATA: lt_address   TYPE szadr_printform_table,
          ls_addr_comp TYPE szadr_addr1_complete.


    IF ev_address IS REQUESTED.
      CLEAR: ev_address.

      CALL FUNCTION 'ADDRESS_INTO_PRINTFORM'
        EXPORTING
          address_type                   = iv_addr_type
          address_number                 = iv_addr_numb
        IMPORTING
          address_printform_table        = lt_address
        EXCEPTIONS
          address_blocked                = 1
          person_blocked                 = 2
          contact_person_blocked         = 3
          addr_to_be_formated_is_blocked = 4
          OTHERS                         = 5.

      IF sy-subrc = 0.
        LOOP AT lt_address ASSIGNING FIELD-SYMBOL(<ls_address>).
          ev_address  = COND #( WHEN ev_address IS INITIAL
                                  THEN <ls_address>-address_line
                                  ELSE |{ ev_address }${ <ls_address>-address_line }| ).
        ENDLOOP.
      ELSE.
        zcl_gtt_tools=>throw_exception( ).
      ENDIF.
    ENDIF.

    IF ev_email IS REQUESTED OR ev_telephone IS REQUESTED.
      CLEAR: ev_email, ev_telephone.

      CALL FUNCTION 'ADDR_GET_COMPLETE'
        EXPORTING
          addrnumber              = iv_addr_numb
        IMPORTING
          addr1_complete          = ls_addr_comp
        EXCEPTIONS
          parameter_error         = 1
          address_not_exist       = 2
          internal_error          = 3
          wrong_access_to_archive = 4
          address_blocked         = 5
          OTHERS                  = 6.

      IF sy-subrc = 0.
        ev_email      = VALUE #( ls_addr_comp-adsmtp_tab[ 1 ]-adsmtp-smtp_addr OPTIONAL ).
        ev_telephone  = VALUE #( ls_addr_comp-adtel_tab[ 1 ]-adtel-tel_number OPTIONAL ).
      ELSE.
        zcl_gtt_tools=>throw_exception( ).
      ENDIF.
    ENDIF.
  ENDMETHOD.


  METHOD get_formated_matnr.
    DATA: lv_matnr TYPE ekpo-matnr.

    lv_matnr = zcl_gtt_tools=>get_field_of_structure(
      ir_struct_data = ir_ekpo
      iv_field_name  = 'MATNR' ).

    rv_matnr   = |{ lv_matnr ALPHA = OUT }|.
  ENDMETHOD.


  METHOD get_plant_address_num_and_name.
    DATA: ls_t001w TYPE t001w.

    CALL FUNCTION 'WCB_T001W_SINGLE_READ'
      EXPORTING
        i_werks   = iv_werks
      IMPORTING
        e_t001w   = ls_t001w
      EXCEPTIONS
        not_found = 1
        OTHERS    = 2.

    IF sy-subrc = 0.
      ev_adrnr    = ls_t001w-adrnr.
      ev_name    = ls_t001w-name1.
    ELSE.
      zcl_gtt_tools=>throw_exception( ).
    ENDIF.

  ENDMETHOD.


  METHOD get_supplier_agent_id.
    DATA: lv_forward_agt TYPE bu_partner,
          lt_bpdetail    TYPE STANDARD TABLE OF bapibus1006_id_details.

    CALL METHOD cl_site_bp_assignment=>select_bp_via_cvi_link
      EXPORTING
        i_lifnr = iv_lifnr
      IMPORTING
        e_bp    = lv_forward_agt.

    CALL FUNCTION 'BAPI_IDENTIFICATIONDETAILS_GET'
      EXPORTING
        businesspartner      = lv_forward_agt
      TABLES
        identificationdetail = lt_bpdetail.

    READ TABLE lt_bpdetail ASSIGNING FIELD-SYMBOL(<ls_bpdetail>)
      WITH KEY identificationtype = zif_gtt_spof_app_constants=>cv_agent_id_type
      BINARY SEARCH.

    rv_id_num   = COND #( WHEN sy-subrc = 0
                            THEN zif_gtt_spof_app_constants=>cv_agent_id_prefix &&
                                 <ls_bpdetail>-identificationnumber ).
  ENDMETHOD.


  METHOD get_tracking_id_po_hdr.

    DATA: lv_ebeln TYPE ekko-ebeln.

    lv_ebeln = zcl_gtt_tools=>get_field_of_structure(
      ir_struct_data = ir_ekko
      iv_field_name  = 'EBELN' ).

    rv_track_id   = |{ lv_ebeln ALPHA = OUT }|.
  ENDMETHOD.


  METHOD get_tracking_id_po_itm.

    DATA: lv_ebeln TYPE ekpo-ebeln,
          lv_ebelp TYPE ekpo-ebelp.

    lv_ebeln = zcl_gtt_tools=>get_field_of_structure(
      ir_struct_data = ir_ekpo
      iv_field_name  = 'EBELN' ).

    lv_ebelp = zcl_gtt_tools=>get_field_of_structure(
      ir_struct_data = ir_ekpo
      iv_field_name  = 'EBELP' ).

    rv_track_id   = |{ lv_ebeln ALPHA = OUT }{ lv_ebelp ALPHA = IN }|.

    CONDENSE rv_track_id NO-GAPS.


  ENDMETHOD.


  METHOD is_appropriate_po.

    FIELD-SYMBOLS: <lt_ekpo>  TYPE ANY TABLE,
                   <ls_ekpo>  TYPE any,
                   <lv_ebeln> TYPE ekpo-ebeln.

    DATA:
      lv_ebeln TYPE ekko-ebeln,
      lv_bsart TYPE ekko-bsart.

    rv_result = abap_false.

    zcl_gtt_spof_po_tools=>get_po_type(
      RECEIVING
        rt_type = DATA(lt_po_type) ).

    CHECK lt_po_type IS NOT INITIAL.
    lv_bsart = zcl_gtt_tools=>get_field_of_structure(
      ir_struct_data = ir_ekko
      iv_field_name  = 'BSART' ).
    IF lv_bsart NOT IN lt_po_type.
      RETURN.
    ENDIF.

    lv_ebeln = zcl_gtt_tools=>get_field_of_structure(
      ir_struct_data = ir_ekko
      iv_field_name  = 'EBELN' ).
    ASSIGN ir_ekpo->* TO <lt_ekpo>.
    IF <lt_ekpo> IS ASSIGNED.
      LOOP AT <lt_ekpo> ASSIGNING <ls_ekpo>.
        ASSIGN COMPONENT 'EBELN' OF STRUCTURE <ls_ekpo> TO <lv_ebeln>.
        IF <lv_ebeln> IS ASSIGNED.
          IF <lv_ebeln>  = lv_ebeln AND
             zcl_gtt_spof_po_tools=>is_appropriate_po_item( ir_ekko = ir_ekko ir_ekpo = REF #( <ls_ekpo> ) ) = abap_true.
            rv_result = abap_true.
            RETURN.
          ENDIF.
        ENDIF.
      ENDLOOP.
    ELSE.
      MESSAGE e002(zgtt) WITH 'EKPO' INTO DATA(lv_dummy).
      zcl_gtt_tools=>throw_exception( ).
    ENDIF.

  ENDMETHOD.


  METHOD is_appropriate_po_item.

    DATA:
      lv_bsart TYPE ekko-bsart.

    rv_result = abap_false.

    zcl_gtt_spof_po_tools=>get_po_type(
      RECEIVING
        rt_type = DATA(lt_po_type) ).

    CHECK lt_po_type IS NOT INITIAL.
    lv_bsart = zcl_gtt_tools=>get_field_of_structure(
      ir_struct_data = ir_ekko
      iv_field_name  = 'BSART' ).
    IF lv_bsart NOT IN lt_po_type.
      RETURN.
    ENDIF.

    DATA(lv_wepos) = zcl_gtt_tools=>get_field_of_structure(
      ir_struct_data = ir_ekpo
      iv_field_name  = 'WEPOS' ).

    rv_result = boolc( lv_wepos = abap_true ).

  ENDMETHOD.


  METHOD is_enable_confirmation_po_item.

    DATA(lv_kzabs) = zcl_gtt_tools=>get_field_of_structure(
      ir_struct_data = ir_ekpo
      iv_field_name  = 'KZABS' ).

    rv_result = boolc( lv_kzabs = abap_true ).

  ENDMETHOD.


  METHOD get_formated_po_item_number.
    rv_ebelp = zcl_gtt_tools=>get_field_of_structure(
      ir_struct_data = ir_ekpo
      iv_field_name  = 'EBELP' ).

    rv_ebelp   = |{ rv_ebelp ALPHA = IN }|.
  ENDMETHOD.


  METHOD get_formated_po_number.
    DATA: lv_ebeln TYPE ekko-ebeln.

    lv_ebeln = zcl_gtt_tools=>get_field_of_structure(
      ir_struct_data = ir_ekko
      iv_field_name  = 'EBELN' ).

    rv_ebeln   = |{ lv_ebeln ALPHA = OUT }|.
  ENDMETHOD.


  METHOD get_po_header.
    DATA lv_bstyp TYPE bstyp.

    CLEAR es_ekko.
    CALL FUNCTION 'ME_EKKO_SINGLE_READ'
      EXPORTING
        pi_ebeln         = i_ebeln
      IMPORTING
        po_ekko          = es_ekko
      EXCEPTIONS
        no_records_found = 1
        OTHERS           = 2.
    IF sy-subrc GT 0.
* archive integration                                       "v_1624571
      IF cl_mmpur_archive=>if_mmpur_archive~get_archive_handle( i_ebeln )
        GT 0.
        DO 3 TIMES.
          CASE sy-index.
            WHEN 1.
              lv_bstyp = 'F'.
            WHEN 2.
              lv_bstyp = 'K'.
            WHEN 3.
              lv_bstyp = 'L'.
          ENDCASE.
          TRY.
              cl_mmpur_archive=>if_mmpur_archive~get_archived_pd(
                EXPORTING
                  im_ebeln = i_ebeln
                  im_bstyp = lv_bstyp
                IMPORTING
                  ex_ekko  = es_ekko ).
            CATCH cx_mmpur_no_authority.
              CLEAR es_ekko.
            CATCH cx_mmpur_root.
              CLEAR es_ekko.
          ENDTRY.
          CHECK es_ekko IS NOT INITIAL.
          e_archived = abap_true.
          EXIT.
        ENDDO.
        IF es_ekko IS INITIAL.
          MESSAGE e005(zgtt) WITH 'EKKO' i_ebeln INTO DATA(lv_dummy).
          zcl_gtt_tools=>throw_exception( ).
        ENDIF.
      ENDIF.                                                "^_1624571
    ENDIF.
  ENDMETHOD.


  METHOD get_po_item.
    DATA lt_items TYPE STANDARD TABLE OF ekpo.
    CLEAR es_ekpo.

    CALL FUNCTION 'ME_EKPO_READ_WITH_EBELN'
      EXPORTING
        pi_ebeln             = i_ebeln
      TABLES
        pto_ekpo             = lt_items
      EXCEPTIONS
        err_no_records_found = 1
        OTHERS               = 2.
    IF sy-subrc GT 0.
      IF i_archived EQ abap_true.                          "v_1624571
        TRY.
            cl_mmpur_archive=>if_mmpur_archive~get_archived_pd(
              EXPORTING
                im_ebeln = i_ebeln
                im_bstyp = is_ekko-bstyp
              IMPORTING
                ex_ekpo  = lt_items ).
          CATCH cx_mmpur_no_authority.
            CLEAR lt_items.
          CATCH cx_mmpur_root.
            CLEAR lt_items.
        ENDTRY.
      ENDIF.
      IF lines( lt_items ) EQ 0.
        MESSAGE e005(zgtt) WITH 'EKPO' |{ i_ebeln }{ i_ebelp }|
         INTO DATA(lv_dummy).
        zcl_gtt_tools=>throw_exception( ).
      ENDIF.                                                "^_1624571
    ENDIF.
    READ TABLE lt_items WITH KEY ebeln = i_ebeln
                                 ebelp = i_ebelp
                        INTO es_ekpo.
    IF sy-subrc NE 0.
      MESSAGE e005(zgtt) WITH 'EKPO' |{ i_ebeln }{ i_ebelp }|
          INTO lv_dummy.
      zcl_gtt_tools=>throw_exception( ).
    ENDIF.
ENDMETHOD.


  method GET_TRACKING_ID_DL_ITEM.
     DATA: lv_vbeln TYPE lips-vbeln,
          lv_posnr TYPE lips-posnr.

    lv_vbeln  = zcl_gtt_tools=>get_field_of_structure(
                  ir_struct_data = ir_lips
                  iv_field_name  = 'VBELN' ).

    lv_posnr  = zcl_gtt_tools=>get_field_of_structure(
                  ir_struct_data = ir_lips
                  iv_field_name  = 'POSNR' ).

    rv_track_id   = |{ lv_vbeln ALPHA = OUT }{ lv_posnr ALPHA = IN }|.

    CONDENSE rv_track_id NO-GAPS.
  endmethod.


  METHOD get_po_type.

    DATA:
      lt_potype TYPE TABLE OF zgtt_potype_rst,
      rs_type   TYPE rsdsselopt.

    CLEAR rt_type.

    SELECT *
      INTO TABLE lt_potype
      FROM zgtt_potype_rst
     WHERE active = abap_true.

    LOOP AT lt_potype INTO DATA(ls_potype).
      rs_type-sign = 'I'.
      rs_type-option = 'EQ'.
      rs_type-low = ls_potype-bsart.
      APPEND rs_type TO rt_type.
      CLEAR rs_type.
    ENDLOOP.

  ENDMETHOD.
ENDCLASS.
