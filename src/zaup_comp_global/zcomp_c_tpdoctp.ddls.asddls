@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
@EndUserText.label: 'Projection View forTpDoc'
@ObjectModel.semanticKey: [ 'Companycode' ]
@Search.searchable: true
define root view entity ZCOMP_C_TPDOCTP
  provider contract transactional_query
  as projection on ZCOMP_R_TPDOCTP as TpDoc
{
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.90
      @Consumption.valueHelpDefinition: [{
          entity: {
              name: 'I_CompanyCode',
              element: 'CompanyCode'
          }
      }]
  key Companycode,
  @Search.defaultSearchElement: true
  @Search.fuzzinessThreshold: 0.90 
  key Financialaccounttype,
  @Search.defaultSearchElement: true
  @Search.fuzzinessThreshold: 0.90 
  key Accountingdocumenttype
  
}
