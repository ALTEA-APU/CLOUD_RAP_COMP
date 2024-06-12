CLASS zcomp_api_helper DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    DATA st_request TYPE zjournal_entry_bulk_clearing_1.
    DATA: fcode TYPE char20.

    TYPES: tty_h_data TYPE TABLE OF zcomp_i_h,
           tty_p_data TYPE TABLE OF zcomp_i_p.

    CLASS-METHODS: get_instance RETURNING VALUE(ro_instance) TYPE REF TO zcomp_api_helper.

    METHODS constructor
      IMPORTING base_url TYPE string
                username TYPE string
                password TYPE string.

    METHODS get_proxy
      RETURNING VALUE(proxy) TYPE REF TO zco_journal_entry_bulk_cleari1
      RAISING   cx_ai_system_fault
                cx_soap_destination_error.

    METHODS set_clearing_buffer
      IMPORTING i_h_data  TYPE tty_h_data
                i_datareg TYPE dats
                i_hdrtxt  TYPE char200.

    METHODS get_clearing_buffer
      EXPORTING r_h_data  TYPE tty_h_data
                r_datareg TYPE dats
                r_hdrtxt  TYPE char200.

    METHODS call_api
      IMPORTING p_commit TYPE char1_run_type DEFAULT ' '
      RAISING
                cx_ai_system_fault
                cx_soap_destination_error.


  PROTECTED SECTION.
  PRIVATE SECTION.

    DATA: gt_h_data TYPE TABLE OF zcomp_i_h,
          gt_p_data TYPE TABLE OF zcomp_i_p.

    DATA: gv_datareg TYPE dats,
          gv_hdrtxt  TYPE char200.

    DATA: url   TYPE string,
          uname TYPE string,
          pwd   TYPE string.

    CLASS-DATA go_instance TYPE REF TO zcomp_api_helper.
ENDCLASS.



CLASS ZCOMP_API_HELPER IMPLEMENTATION.


  METHOD call_api.

    TYPES:BEGIN OF ty_amount,
            Amount TYPE zcomp_i_p-amount,
          END OF ty_amount.

    DATA(request) = VALUE zjournal_entry_bulk_clearing_1( ).

    DATA: ls_JECR TYPE zjournal_entry_clearing_requ10,
          ls_je   LIKE ls_JECR-journal_entry,
          lt_apar TYPE TABLE OF zjournal_entry_clearing_reque6,
          ls_apar LIKE LINE OF lt_apar.

    DATA: lt_amount_all TYPE TABLE OF zcomp_i_p,
          ls_amount_all TYPE zcomp_i_p,
          lt_amount_pos TYPE TABLE OF zcomp_i_p,
          ls_amount_pos TYPE zcomp_i_p,
          lt_amount_neg TYPE TABLE OF zcomp_i_p,
          ls_amount_neg TYPE zcomp_i_p,
          lv_tot_all    TYPE zcomp_i_p-amount,
          lv_tot_pos    TYPE zcomp_i_p-amount,
          lv_tot_neg    TYPE zcomp_i_p-amount,
          lv_partial    TYPE zcomp_i_p-amount.

    DATA: lv_long_time_stamp  TYPE timestampl,
          lv_short_time_stamp TYPE timestamp.

    IF gt_h_data IS NOT INITIAL.

      DATA(proxy) = me->get_proxy( ).

      CHECK proxy IS BOUND.

      "Fill Request

      GET TIME STAMP FIELD lv_short_time_stamp.
      GET TIME STAMP FIELD lv_long_time_stamp.

*      request-journal_entry_bulk_clearing_re-message_header-id-content = 'COMP_' && |{ lv_short_time_stamp TIMESTAMP = ISO TIMEZONE = sy-zonlo }|.
      request-journal_entry_bulk_clearing_re-message_header-id-content = |COMP_| && cl_abap_context_info=>get_system_date(  ) && |_| && cl_abap_context_info=>get_system_time(  ).
      request-journal_entry_bulk_clearing_re-message_header-creation_date_time = cl_abap_context_info=>get_system_date(  ) && cl_abap_context_info=>get_system_time(  ).
*      request-journal_entry_bulk_clearing_re-message_header-creation_date_time = |{ lv_long_time_stamp TIMESTAMP = ISO TIMEZONE = sy-zonlo }|.

      LOOP AT gt_h_data INTO DATA(ls_h_data).

        ls_jecr-message_header-id-content = ls_h_data-BusinessPartner && |_| && cl_abap_context_info=>get_system_date(  ) && |_| && cl_abap_context_info=>get_system_time(  ).
        ls_jecr-message_header-creation_date_time = cl_abap_context_info=>get_system_date(  ) && cl_abap_context_info=>get_system_time(  ).
*        ls_jecr-message_header-id-content = ls_h_data-BusinessPartner && |{ lv_short_time_stamp TIMESTAMP = ISO TIMEZONE = sy-zonlo }|.
*        ls_jecr-message_header-creation_date_time = |{ lv_long_time_stamp TIMESTAMP = ISO TIMEZONE = sy-zonlo }|.

        "Fetch Child Data
        SELECT * FROM zcomp_i_p
        WHERE Companycode = @ls_h_data-CompanyCode
          AND BusinessPartner = @ls_h_data-BusinessPartner
          AND ClearingDocFiscalYear = @ls_h_data-ClearingDocFiscalYear
          AND ClearingAccountingDocument = @ls_h_data-ClearingAccountingDocument
          INTO TABLE @DATA(lt_child).

        "Separate Positive and Negative Amounts into their respective tables
        CLEAR: lt_amount_pos[], lt_amount_neg[].
        LOOP AT lt_child INTO DATA(ls_child).
          CLEAR: ls_amount_pos,   ls_amount_neg.

          IF ls_child-amount GT 0.
*            ls_amount_pos-amount = ls_child-amount.
*            APPEND ls_amount_pos TO lt_amount_pos.
            APPEND ls_child TO lt_amount_pos.
          ELSE.
*            ls_amount_neg-amount = ls_child-amount.
*            APPEND ls_amount_neg TO lt_amount_neg.
            APPEND ls_child TO lt_amount_neg.
          ENDIF.
        ENDLOOP.

        "Calculate Total Amounts
        CLEAR: lv_tot_pos, lv_tot_neg.

        LOOP AT lt_amount_pos INTO ls_amount_pos.
          ADD ls_amount_pos-amount TO lv_tot_pos.
        ENDLOOP.

        LOOP AT lt_amount_neg INTO ls_amount_neg.
          ADD ls_amount_neg-amount TO lv_tot_neg.
        ENDLOOP.

        "Decide which Sign should be focused on
        CLEAR: lv_tot_all, lt_amount_all[], lv_partial.
        lv_tot_all = lv_tot_pos + lv_tot_neg.

        IF lv_tot_all GT 0.
          lt_amount_all[] = lt_amount_pos[].
          lv_partial = lv_tot_neg * -1.
        ELSE.

          ""Convert in Absolute Value
          LOOP AT lt_amount_neg INTO ls_amount_neg.
            ls_amount_neg-amount = ls_amount_neg-amount * -1.
            MODIFY lt_amount_neg FROM ls_amount_neg.
          ENDLOOP.

          lt_amount_all[] = lt_amount_neg[].
          lv_partial = lv_tot_pos.

        ENDIF.

        "Calculate Partial Payment Amount
        SORT lt_amount_all BY NetDueDate ASCENDING Amount ASCENDING.
        DATA: ls_partial_data TYPE zcomp_i_p,
              lv_idx          TYPE sy-tabix,
              lv_temp         TYPE zcomp_i_p-amount.

        LOOP AT lt_amount_all INTO ls_amount_all.
          lv_idx = sy-tabix.
          lv_temp = lv_partial - ls_amount_all-amount.

          IF lv_temp GT 0.
            lv_partial = lv_temp.
            CONTINUE. "Keep Subtracting
          ELSEIF lv_temp LT 0. "Keep the last one and scrap the followings
            ls_partial_data = ls_amount_all.
            EXIT.
          ELSEIF lv_temp EQ 0. "Full Clearing
            CLEAR lv_partial.
            ls_partial_data = ls_amount_all.
            EXIT.
          ENDIF.

        ENDLOOP.

        "Fill Substructures

        SELECT SINGLE * FROM zcomp_r_parametritp
        WHERE CompanyCode = @ls_h_data-Companycode
        INTO @DATA(ls_params).

        ls_je-company_code = ls_h_data-Companycode.
        ls_je-accounting_document_type = ls_params-Accountingdocumenttype.
        ls_je-document_date = gv_datareg.
        ls_je-posting_date  = gv_datareg.
        ls_je-currency_code = ls_params-Currency.
        ls_je-document_header_text = gv_hdrtxt.

        DATA: lv_ref TYPE i,
              lv_ppa TYPE flag. "Partial Payment Amount

        CLEAR: ls_apar, lt_apar[], lv_ppa.
        LOOP AT lt_amount_all INTO ls_amount_all.

          IF lv_ppa IS NOT INITIAL.
            EXIT.
          ELSE.
            CLEAR: ls_apar.
          ENDIF.

          ADD 1 TO lv_ref.

          ls_apar-reference_document_item = lv_ref.
          ls_apar-company_code = ls_amount_all-Companycode.
          ls_apar-account_type = ls_amount_all-FinancialAccountType.
          ls_apar-aparaccount = ls_amount_all-BusinessPartner.
          ls_apar-fiscal_year = ls_amount_all-FiscalYear.
          ls_apar-accounting_document = ls_amount_all-AccountingDocument.
          ls_apar-accounting_document_item = 1.

          IF ls_amount_all EQ ls_partial_data.
            lv_ppa = 'X'.
            ls_apar-partial_payment_amt_in_dsp_crc-content =  lv_partial .
            IF lv_partial IS NOT INITIAL.
              ls_apar-partial_payment_amt_in_dsp_crc-currency_code = ls_amount_all-Currency .
            ENDIF.
          ENDIF.

          APPEND ls_apar TO lt_apar.

        ENDLOOP.

        "Add Missing Records
        CLEAR lt_amount_all[].

        IF lv_tot_all GT 0.
          APPEND LINES OF lt_amount_neg TO lt_amount_all.
        ELSE.
          APPEND LINES OF lt_amount_pos TO lt_amount_all.
        ENDIF.

        LOOP AT lt_amount_all INTO ls_amount_all.

          CLEAR: ls_apar.

          ADD 1 TO lv_ref.

          ls_apar-reference_document_item = lv_ref.
          ls_apar-company_code = ls_amount_all-Companycode.
          ls_apar-account_type = ls_amount_all-FinancialAccountType.
          ls_apar-aparaccount = ls_amount_all-BusinessPartner.
          ls_apar-fiscal_year = ls_amount_all-FiscalYear.
          ls_apar-accounting_document = ls_amount_all-AccountingDocument.
          ls_apar-accounting_document_item = 1.

          APPEND ls_apar TO lt_apar.

        ENDLOOP.

        ls_je-aparitems[] = lt_apar[].
        ls_jecr-journal_entry = ls_je.
        APPEND ls_jecr TO request-journal_entry_bulk_clearing_re-journal_entry_clearing_request.

      ENDLOOP.

      proxy->journal_entry_bulk_clearing_re(
        EXPORTING
          input = request
      ).

      " trigger async call
      IF p_commit EQ abap_true.
        COMMIT WORK.
      ENDIF.

    ENDIF.



  ENDMETHOD.


  METHOD constructor.
    url   = base_url.
    uname = username.
    pwd   = password.
  ENDMETHOD.


  METHOD get_clearing_buffer.
    r_h_data = gt_h_data.
    r_datareg = gv_datareg.
    r_hdrtxt = gv_hdrtxt.
  ENDMETHOD.


  METHOD get_instance.
    go_instance = COND #( WHEN go_instance IS BOUND THEN go_instance ELSE NEW #( base_url = ' '
                                                                                 username = 'SERVICE_API_USER'
                                                                                 password = '5o8^a35&YZ2RIxS%n*!#'  ) ).
    ro_instance = go_instance.
  ENDMETHOD.


  METHOD get_proxy.

    IF url IS INITIAL.
      DATA(soap_destination) = cl_soap_destination_provider=>create_by_comm_arrangement(
                                 comm_scenario  = 'ZCOMP_CSCEN_CLEARING'
                                 service_id     = 'ZCOMP_OUT_CLEAR_SPRX'
*                                   comm_system_id =
                               ).
    ELSE.
      soap_destination =  cl_soap_destination_provider=>create_by_url( i_url = url ) .
    ENDIF.

    proxy = NEW zco_journal_entry_bulk_cleari1( destination = soap_destination ).

*    http_client->get_http_request( )->set_authorization_basic(
*        i_username = uname "'SERVICE_API_USER'
*        i_password = pwd   "'5o8^a35&YZ2RIxS%n*!#'
*    ).


  ENDMETHOD.


  METHOD set_clearing_buffer.

    CLEAR: gt_h_data, gv_datareg, gv_hdrtxt.

    CHECK i_h_data IS NOT INITIAL.

    gt_h_data = CORRESPONDING #( i_h_data ).

    CHECK i_datareg IS NOT INITIAL.

    gv_datareg = i_datareg.

    CHECK i_hdrtxt IS NOT INITIAL.

    gv_hdrtxt = i_hdrtxt.

  ENDMETHOD.
ENDCLASS.
