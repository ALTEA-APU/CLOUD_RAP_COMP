class ZCO_JOURNAL_ENTRY_BULK_CLEARI1 definition
  public
  inheriting from CL_PROXY_CLIENT
  create public .

public section.

  methods CONSTRUCTOR
    importing
      !DESTINATION type ref to IF_PROXY_DESTINATION optional
      !LOGICAL_PORT_NAME type PRX_LOGICAL_PORT_NAME optional
    preferred parameter LOGICAL_PORT_NAME
    raising
      CX_AI_SYSTEM_FAULT .
  methods JOURNAL_ENTRY_BULK_CLEARING_RE
    importing
      !INPUT type ZJOURNAL_ENTRY_BULK_CLEARING_1
    raising
      CX_AI_SYSTEM_FAULT .
protected section.
private section.
ENDCLASS.



CLASS ZCO_JOURNAL_ENTRY_BULK_CLEARI1 IMPLEMENTATION.


  method CONSTRUCTOR.

  super->constructor(
    class_name          = 'ZCO_JOURNAL_ENTRY_BULK_CLEARI1'
    logical_port_name   = logical_port_name
    destination         = destination
  ).

  endmethod.


  method JOURNAL_ENTRY_BULK_CLEARING_RE.

  data(lt_parmbind) = value abap_parmbind_tab(
    ( name = 'INPUT' kind = '0' value = ref #( INPUT ) )
  ).
  if_proxy_client~execute(
    exporting
      method_name = 'JOURNAL_ENTRY_BULK_CLEARING_RE'
    changing
      parmbind_tab = lt_parmbind
  ).

  endmethod.
ENDCLASS.
