CLASS zcl_comp_calc DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_sadl_exit_calc_element_read .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_COMP_CALC IMPLEMENTATION.


  METHOD if_sadl_exit_calc_element_read~calculate.

    DATA: lt_data TYPE TABLE OF zcomp_c_h.
    lt_data[] = CORRESPONDING #( it_original_data ).

    LOOP AT lt_data ASSIGNING FIELD-SYMBOL(<fs>).

      SELECT SUM( amount ) AS somma
      FROM zcomp_c_p
      WHERE Companycode EQ @<fs>-Companycode
        AND Businesspartner EQ @<fs>-Businesspartner
        AND ClearingAccountingDocument EQ @<fs>-ClearingAccountingDocument
        AND ClearingDocFiscalYear EQ @<fs>-ClearingDocFiscalYear
        INTO @<fs>-delta.

    ENDLOOP.

    ct_calculated_data = CORRESPONDING #( lt_data ).

  ENDMETHOD.


  METHOD if_sadl_exit_calc_element_read~get_calculation_info.

  ENDMETHOD.
ENDCLASS.
