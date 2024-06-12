@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Partite Aperte - Cleared (UNION)'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZCOMP_I_CLEAR_ALL
  as select from ZCOMP_I_CLEAR_CLI
{
  Companycode,
  BusinessPartner,
  AccountingDocument,
  AccountingDocumentItem,
  FiscalYear,
  FinancialAccountType,
  AccountingDocumentType,
  Documentdate,
  NetDueDate,
  Currency,
  @Semantics.amount.currencyCode: 'Currency'
  Amount,
  ClearingAccountingDocument,
  ClearingDocFiscalYear,
  ClearingDocumentDate,
  WHTS

}
union all select from ZCOMP_I_CLEAR_FOR
{
  Companycode,
  BusinessPartner,
  AccountingDocument,
  AccountingDocumentItem,
  FiscalYear,
  FinancialAccountType,
  AccountingDocumentType,
  Documentdate,
  NetDueDate,
  Currency,
  Amount,
  ClearingAccountingDocument,
  ClearingDocFiscalYear,
  ClearingDocumentDate,
  WHTS

}
