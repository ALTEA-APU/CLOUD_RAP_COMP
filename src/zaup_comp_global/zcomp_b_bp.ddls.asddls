@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Business Partners (UNION)'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZCOMP_B_BP
  as select from ZCOMP_I_BP
{
  Companycode,
  BusinessPartner,
  ClearingAccountingDocument,
  ClearingDocFiscalYear,
  ClearingDocumentDate,
  'D' as Stato
}
union all select from ZCOMP_I_CLEAR_BP
{
  Companycode,
  BusinessPartner,
  ClearingAccountingDocument,
  ClearingDocFiscalYear,
  ClearingDocumentDate,
  'C' as Stato
}
