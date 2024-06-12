@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Business Partner Validi'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZCOMP_I_BP
  as select distinct from ZCOMP_I_BP_KD_SUM
{
  key Companycode,
  key BusinessPartner,
  key ClearingAccountingDocument,
  key ClearingDocFiscalYear,
      ClearingDocumentDate
}
where
  Counter > 1
