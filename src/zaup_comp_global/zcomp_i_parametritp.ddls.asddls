@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Projection View forParametri'
define root view entity ZCOMP_I_PARAMETRITP
  provider contract transactional_interface
  as projection on ZCOMP_R_PARAMETRITP as Parametri
{
  key Companycode,
  Accountingdocumenttype,
  Currency
  
}
