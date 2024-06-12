CLASS lhc_Root DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR Root RESULT result.

    METHODS read FOR READ
      IMPORTING keys FOR READ Root RESULT result.

    METHODS lock FOR LOCK
      IMPORTING keys FOR LOCK Root.

    METHODS rba_Child FOR READ
      IMPORTING keys_rba FOR READ Root\_Child FULL result_requested RESULT result LINK association_links.

    METHODS compensa FOR MODIFY
      IMPORTING keys FOR ACTION Root~compensa RESULT result.

    METHODS set_dates FOR MODIFY
      IMPORTING keys FOR ACTION Root~set_dates.

ENDCLASS.

CLASS lhc_Root IMPLEMENTATION.

  METHOD get_instance_authorizations.

    SELECT * FROM zcomp_i_h
    FOR ALL ENTRIES IN @keys
    WHERE BusinessPartner = @keys-BusinessPartner
      AND ClearingAccountingDocument = @keys-ClearingAccountingDocument
      AND ClearingDocFiscalYear = @keys-ClearingDocFiscalYear
      AND Companycode = @keys-Companycode
    INTO TABLE @DATA(lt_root).

    result = VALUE #( FOR ls_root IN lt_root
                     ( %tky-BusinessPartner            = ls_root-BusinessPartner
                       %tky-ClearingAccountingDocument = ls_root-ClearingAccountingDocument
                       %tky-ClearingDocFiscalYear      = ls_root-ClearingDocFiscalYear
                       %tky-Companycode                = ls_root-Companycode
                       %action-compensa = COND #( WHEN ls_root-Stato = 'C' " Compensato
                                                           THEN if_abap_behv=>fc-o-disabled ELSE if_abap_behv=>fc-o-enabled  )
                     ) ).

  ENDMETHOD.

  METHOD read.
  ENDMETHOD.

  METHOD lock.
  ENDMETHOD.

  METHOD rba_Child.
  ENDMETHOD.

  METHOD compensa.

    DATA: ls_res    LIKE LINE OF result,
          lt_h_data TYPE zcomp_api_helper=>tty_h_data,
          ls_h_data LIKE LINE OF lt_h_data.

    LOOP AT keys INTO DATA(ls_keys).

      SELECT * FROM zcomp_i_h
      WHERE Companycode = @ls_keys-CompanyCode
        AND BusinessPartner = @ls_keys-BusinessPartner
        AND ClearingDocFiscalYear = @ls_keys-ClearingDocFiscalYear
        AND ClearingAccountingDocument = @ls_keys-ClearingAccountingDocument
        INTO TABLE @DATA(lt_temp).
      IF sy-subrc IS INITIAL.
        APPEND LINES OF lt_temp TO lt_h_Data.
      ENDIF.

    ENDLOOP.

    zcomp_api_helper=>get_instance(   )->set_clearing_buffer( i_h_data = lt_h_data
                                                              i_datareg = ls_keys-%param-DataReg
                                                              i_hdrtxt  = ls_keys-%param-Testo ).

    "Gestisci tabella Result
    LOOP AT keys INTO ls_keys.

      READ TABLE lt_h_data INTO ls_h_data
      WITH KEY Companycode = ls_keys-CompanyCode
               BusinessPartner = ls_keys-BusinessPartner
               ClearingDocFiscalYear = ls_keys-ClearingDocFiscalYear
               ClearingAccountingDocument = ls_keys-ClearingAccountingDocument.

      ls_res-%cid_ref = ls_keys-%cid_ref.
      ls_res-%key = ls_keys-%key.
      ls_res-%param = CORRESPONDING #( ls_h_data ).

      APPEND ls_res TO result.

    ENDLOOP.

  ENDMETHOD.

  METHOD set_dates.

    DATA: ls_tab TYPE zcomp_datacalc.

    LOOP AT keys INTO DATA(ls_keys).

      IF ls_keys-%param-DataScad IS NOT INITIAL.

        zcl_comp_util=>get_instance(  )->set_data( i_data = ls_keys-%param-DataScad ).
        zcl_comp_util=>get_instance(  )->set_fcode( i_fcode = 'DATA' ).

      ENDIF.

    ENDLOOP.

  ENDMETHOD.

ENDCLASS.

CLASS lhc_Child DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

*    METHODS update FOR MODIFY
*      IMPORTING entities FOR UPDATE Child.

*    METHODS delete FOR MODIFY
*      IMPORTING keys FOR DELETE Child.

    METHODS read FOR READ
      IMPORTING keys FOR READ Child RESULT result.

    METHODS rba_Root FOR READ
      IMPORTING keys_rba FOR READ Child\_Root FULL result_requested RESULT result LINK association_links.

ENDCLASS.

CLASS lhc_Child IMPLEMENTATION.

*  METHOD update.
*  ENDMETHOD.
*
*  METHOD delete.
*  ENDMETHOD.

  METHOD read.
  ENDMETHOD.

  METHOD rba_Root.
  ENDMETHOD.

ENDCLASS.

CLASS lsc_ZCOMP_I_H DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS finalize REDEFINITION.

    METHODS check_before_save REDEFINITION.

    METHODS save REDEFINITION.

    METHODS cleanup REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_ZCOMP_I_H IMPLEMENTATION.

  METHOD finalize.
  ENDMETHOD.

  METHOD check_before_save.
  ENDMETHOD.

  METHOD save.

    IF zcl_comp_util=>get_instance(  )->get_fcode( ) = 'DATA'.

      DATA: ls_tab TYPE zcomp_datacalc.
      ls_tab-datacalc = zcl_comp_util=>get_instance(  )->get_data(  ).
      ls_tab-uname = sy-uname.
      MODIFY zcomp_datacalc FROM @ls_tab.
    ENDIF.


    DATA: lt_h_data TYPE zcomp_api_helper=>tty_h_data.
    zcomp_api_helper=>get_instance(   )->get_clearing_buffer(
      IMPORTING
        r_h_data = lt_h_data
    ).

    IF lt_h_data IS NOT INITIAL.

      TRY.
          zcomp_api_helper=>get_instance(   )->call_api( p_commit = ' ' ).

        CATCH cx_soap_destination_error INTO DATA(lo_exc1).
          DATA(lv_text) = lo_exc1->get_longtext( ).
          " handle error
        CATCH cx_ai_system_fault INTO DATA(lo_exc2).
          " handle error
          lv_text = lo_exc2->get_longtext( ).
      ENDTRY.

    ENDIF.


  ENDMETHOD.

  METHOD cleanup.
  ENDMETHOD.

  METHOD cleanup_finalize.
  ENDMETHOD.

ENDCLASS.
