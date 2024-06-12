@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
@EndUserText.label: 'CDS View forTpDoc'
define root view entity ZCOMP_R_TPDOCTP
  as select from ZCOMP_TPDOC as TpDoc
{
  key COMPANYCODE as Companycode,
  key FINANCIALACCOUNTTYPE as Financialaccounttype,
  key ACCOUNTINGDOCUMENTTYPE as Accountingdocumenttype
  
}
