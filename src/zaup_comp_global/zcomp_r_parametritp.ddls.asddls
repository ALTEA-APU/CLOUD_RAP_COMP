@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
@EndUserText.label: 'CDS View forParametri'
define root view entity ZCOMP_R_PARAMETRITP
  as select from ZCOMP_PAR as Parametri
{
  key COMPANYCODE as Companycode,
  ACCOUNTINGDOCUMENTTYPE as Accountingdocumenttype,
  CURRENCY as Currency
  
}
