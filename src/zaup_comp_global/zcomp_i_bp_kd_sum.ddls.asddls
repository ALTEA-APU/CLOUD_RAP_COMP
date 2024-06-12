@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Business Partner Somma K/D'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZCOMP_I_BP_KD_SUM
  as select distinct from ZCOMP_I_BP_KD
{
  key Companycode,
  key BusinessPartner,
  key ClearingAccountingDocument,
  key ClearingDocFiscalYear,
      ClearingDocumentDate,
      sum( Counter ) as Counter
}
group by
  Companycode,
  BusinessPartner,
  ClearingAccountingDocument,
  ClearingDocFiscalYear,
  ClearingDocumentDate
