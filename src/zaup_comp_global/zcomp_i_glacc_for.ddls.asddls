@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Partite aperte Fornitori'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZCOMP_I_GLACC_FOR
  as select from I_GLAccountLineItem as a
    inner join   zcomp_tpdoc         as b on  a.CompanyCode            = b.companycode
                                          and a.FinancialAccountType   = b.financialaccounttype
                                          and a.AccountingDocumentType = b.accountingdocumenttype
left outer join I_SupplierWithHoldingTax as c on  a.CompanyCode = c.CompanyCode
                                                  and a.Customer    = c.Supplier                                          
{

  key a.CompanyCode                 as Companycode,
  key a.Supplier                    as BusinessPartner,
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
      cast( '00000000' as datum )   as ClearingDocumentDate,
      
      case c.IsWithholdingTaxSubject
        when 'X' then 'X'
      else ' '
      end as WHTS       
}
where
      a.ClearingJournalEntry = ''
  and a.Ledger               = '0L'
  and a.IsReversal           = ''
  and a.IsReversed           = ''
  and a.FinancialAccountType = 'K'
