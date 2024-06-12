CLASS ZCL_COMP_UTIL DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    CLASS-METHODS get_instance RETURNING VALUE(ro_instance) TYPE REF TO ZCL_COMP_UTIL.

    METHODS: set_data  IMPORTING i_data  TYPE datum.
    METHODS: set_fcode IMPORTING i_fcode TYPE char20.

    METHODS: get_data   RETURNING VALUE(e_data)  TYPE datum.
    METHODS: get_fcode  RETURNING VALUE(e_fcode) TYPE char20.

  PROTECTED SECTION.
  PRIVATE SECTION.
    CLASS-DATA go_instance TYPE REF TO ZCL_COMP_UTIL.
    DATA: lv_data  TYPE datum.
    DATA: lv_fcode TYPE char20.
ENDCLASS.



CLASS ZCL_COMP_UTIL IMPLEMENTATION.


  METHOD get_data.
    e_data = lv_data.
  ENDMETHOD.


  METHOD get_fcode.
    e_fcode = lv_fcode.
  ENDMETHOD.


  METHOD get_instance.
    IF NOT go_instance IS BOUND.
      CREATE OBJECT go_instance.
    ENDIF.
    ro_instance = go_instance.
  ENDMETHOD.


  METHOD set_data.
    CLEAR lv_data.
    lv_data = i_data.
  ENDMETHOD.


  METHOD set_fcode.
    CLEAR lv_fcode.
    lv_fcode = i_fcode.
  ENDMETHOD.
ENDCLASS.
