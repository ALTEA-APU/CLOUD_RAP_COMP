@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Filtro su GLACC_ALL'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZCOMP_I_GLACC_ALL_FILT
  as select from ZCOMP_I_GLACC_ALL as a
    inner join   zcomp_datacalc    as b on b.uname = $session.user
{
  a.Companycode,
  a.BusinessPartner,
  a.AccountingDocument,
  a.AccountingDocumentItem,
  a.FiscalYear,
  a.FinancialAccountType,
  a.AccountingDocumentType,
  a.Documentdate,
  a.NetDueDate,
  a.Currency,
  @Semantics.amount.currencyCode: 'Currency'
  a.Amount,
  a.ClearingAccountingDocument,
  a.ClearingDocFiscalYear,
  a.ClearingDocumentDate,
  a.WHTS
}
where
  a.Documentdate <= b.datacalc and
  a.WHTS != 'X'
  
  
