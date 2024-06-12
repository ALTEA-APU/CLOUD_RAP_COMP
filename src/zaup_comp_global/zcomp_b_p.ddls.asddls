@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Partite Aperte & Compensate (UNION)'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}

define view entity ZCOMP_B_P
  as select from ZCOMP_I_GLACC_ALL_FILT
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
  ClearingDocFiscalYear  
}
union all select from ZCOMP_I_CLEAR_ALL
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
  ClearingDocFiscalYear  
}
