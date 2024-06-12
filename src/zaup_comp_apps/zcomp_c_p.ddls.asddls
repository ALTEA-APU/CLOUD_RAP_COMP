@EndUserText.label: 'Projection'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
define view entity ZCOMP_C_P
  as projection on ZCOMP_I_P
{
  key Companycode,
  key BusinessPartner,
  key AccountingDocument,
  key FiscalYear,
  key FinancialAccountType,
      _JE.AccountingDocumentType,
      Documentdate,
      NetDueDate,
      Currency,
      Amount,
      ClearingAccountingDocument,
      ClearingDocFiscalYear,      
      _JE.AccountingDocumentHeaderText,

      /* Associations */
      _Root : redirected to parent ZCOMP_C_H,
      _JE
}
