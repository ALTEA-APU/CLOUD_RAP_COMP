@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Value Help Stato ODV'
@Metadata.ignorePropagatedAnnotations: true
@Search.searchable: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZCOMP_H_STATUS
  as select from ZCOMP_I_DD07 ( i_DOMNAME: 'ZCOMP_STATUS_D' )
{
      @EndUserText.label: 'Stato'
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.9
  key value_low as Stato,
      @EndUserText.label: 'Descrizione'
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
      text      as DescrizioneStato,

      @UI.hidden: true
      case value_low
        when 'N' then 0 // Nuovo: Neutro
        when 'D' then 2 // Da Compensare: Giallo
        when 'C' then 3 // Compensato: Verde
        else 0          // Default: Neutro
      end       as Semaforo

}
