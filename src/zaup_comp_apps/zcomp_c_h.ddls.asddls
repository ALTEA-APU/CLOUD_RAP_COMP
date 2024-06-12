@EndUserText.label: 'Projection'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
define root view entity ZCOMP_C_H
  provider contract transactional_query
  as projection on ZCOMP_I_H
{

  key     Companycode,
  key     BusinessPartner,
  key     ClearingDocFiscalYear,
  key     ClearingAccountingDocument,
          ClearingDocumentDate,
          _Company.CompanyCodeName,
          _Customer.CustomerName,
          Datascad,

          @Consumption.valueHelpDefinition: [{entity: {name: 'ZCOMP_H_STATUS', element: 'Stato' }, useForValidation: true}]
          @ObjectModel.text.element: ['DescrizioneStato']
          Stato,
          _Status.DescrizioneStato,
          _Status.Semaforo,

          @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_COMP_CALC'
          @EndUserText.label: 'Compensazione'
  virtual delta : abap.dec( 10, 2 ),


          /* Associations */

          _Child : redirected to composition child ZCOMP_C_P,
          _Company,
          _Customer
}
