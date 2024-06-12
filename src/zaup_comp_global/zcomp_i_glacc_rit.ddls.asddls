@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Valore ritenuta partite'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZCOMP_I_GLACC_RIT as select from I_Withholdingtaxitem
{
    CompanyCode,
    AccountingDocument,
    FiscalYear,
    CompanyCodeCurrency as Currency,
    @Semantics.amount.currencyCode: 'Currency'
    sum( WhldgTaxAmtInCoCodeCrcy ) as ImportoRitenuta
    
} group by CompanyCode, AccountingDocument, FiscalYear, CompanyCodeCurrency
