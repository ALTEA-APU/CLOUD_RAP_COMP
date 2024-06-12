@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Child'
@Metadata.allowExtensions: true
define view entity ZCOMP_I_P
  as select from ZCOMP_B_P
  association        to parent ZCOMP_I_H as _Root on  $projection.Companycode                = _Root.Companycode
                                                  and $projection.BusinessPartner            = _Root.BusinessPartner
                                                  and $projection.ClearingAccountingDocument = _Root.ClearingAccountingDocument
                                                  and $projection.ClearingDocFiscalYear      = _Root.ClearingDocFiscalYear
  association [1..1] to I_JournalEntry   as _JE   on  _JE.CompanyCode        = $projection.Companycode
                                                  and _JE.FiscalYear         = $projection.FiscalYear
                                                  and _JE.AccountingDocument = $projection.AccountingDocument
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
      @Semantics.amount.currencyCode: 'Currency'
      sum( Amount ) as Amount,
      ClearingAccountingDocument,
      ClearingDocFiscalYear,
      _JE.AccountingDocumentHeaderText,

      _Root,
      _JE
} group by Companycode, BusinessPartner, AccountingDocument, FiscalYear, FinancialAccountType, 
           _JE.AccountingDocumentType, Documentdate , NetDueDate, Currency, ClearingAccountingDocument, ClearingDocFiscalYear, _JE.AccountingDocumentHeaderText
