@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Business Partner K/D'
define view entity ZCOMP_I_BP_KD
  as select distinct from ZCOMP_I_GLACC_ALL_FILT

{
  key Companycode,
  key BusinessPartner,
  key FinancialAccountType,
  key ClearingAccountingDocument,
  key ClearingDocFiscalYear,
      ClearingDocumentDate,
      1 as Counter

}
