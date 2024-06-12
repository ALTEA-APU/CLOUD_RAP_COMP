@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Partite aperte Clienti - Cleared'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZCOMP_I_CLEAR_CLI
  as select from    I_GLAccountLineItem      as a
    inner join      zcomp_par                as b on a.CompanyCode = b.companycode
    inner join      I_JournalEntry           as c on  c.CompanyCode            = a.CompanyCode
                                                  and c.FiscalYear             = a.ClearingDocFiscalYear
                                                  and c.AccountingDocument     = a.ClearingAccountingDocument
                                                  and c.AccountingDocumentType = b.accountingdocumenttype
    left outer join I_SupplierWithHoldingTax as d on  a.CompanyCode = d.CompanyCode
                                                  and a.Customer    = d.Supplier
{

  key a.CompanyCode                 as Companycode,
  key a.Customer                    as BusinessPartner,
  key a.AccountingDocument          as AccountingDocument,
  key a.LedgerGLLineItem            as AccountingDocumentItem,
  key a.FiscalYear                  as FiscalYear,
      a.FinancialAccountType        as FinancialAccountType,
      a.AccountingDocumentType      as AccountingDocumentType,
      a.DocumentDate                as Documentdate,
      a.NetDueDate                  as NetDueDate,
      a.CompanyCodeCurrency         as Currency,
      @Semantics.amount.currencyCode: 'Currency'
      a.AmountInCompanyCodeCurrency as Amount,
      a.ClearingAccountingDocument  as ClearingAccountingDocument,
      a.ClearingDocFiscalYear       as ClearingDocFiscalYear,
      c.DocumentDate                as ClearingDocumentDate,

      case d.IsWithholdingTaxSubject
      when 'X' then 'X'
      else ' '
      end                           as WHTS

}
where
      a.ClearingJournalEntry != ''
  and a.Ledger               =  '0L'
  and a.IsReversal           =  ''
  and a.IsReversed           =  ''
  and a.FinancialAccountType =  'D'
