@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Business Partner Validi - Cleared'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZCOMP_I_CLEAR_BP
  as select distinct from ZCOMP_I_CLEAR_ALL
{
  key Companycode,
  key BusinessPartner,
  key ClearingAccountingDocument,
  key ClearingDocFiscalYear,
      ClearingDocumentDate
}
where WHTS != 'X'
