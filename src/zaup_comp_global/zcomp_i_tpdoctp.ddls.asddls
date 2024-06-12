@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Projection View forTpDoc'
define root view entity ZCOMP_I_TPDOCTP
  provider contract transactional_interface
  as projection on ZCOMP_R_TPDOCTP as TpDoc
{
  key Companycode,
  key Financialaccounttype,
  key Accountingdocumenttype
  
}
