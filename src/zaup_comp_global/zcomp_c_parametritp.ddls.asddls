@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
@EndUserText.label: 'Projection View forParametri'
@ObjectModel.semanticKey: [ 'Companycode' ]
@Search.searchable: true
define root view entity ZCOMP_C_PARAMETRITP
  provider contract transactional_query
  as projection on ZCOMP_R_PARAMETRITP as Parametri
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
      Accountingdocumenttype,
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.90
      Currency

}
