@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Root entity'
@Metadata.allowExtensions: true
define root view entity ZCOMP_I_H
  as select from    ZCOMP_B_BP     as a
    left outer join zcomp_datacalc as b on b.uname = $session.user
  composition [1..*] of ZCOMP_I_P      as _Child
  association [1..1] to I_CompanyCode  as _Company  on _Company.CompanyCode = $projection.Companycode
  association [1..1] to I_Customer     as _Customer on _Customer.Customer = $projection.BusinessPartner
  association [1..1] to ZCOMP_H_STATUS as _Status   on _Status.Stato = a.Stato
{
  key a.Companycode,
  key a.BusinessPartner,
  key a.ClearingDocFiscalYear,
  key a.ClearingAccountingDocument,
      a.ClearingDocumentDate,


      _Company.CompanyCodeName,
      _Customer.CustomerName,
      b.datacalc as Datascad,

      a.Stato,

      _Child,
      _Company,
      _Customer,
      _Status
}
