@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Lettura testi Dominio'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZCOMP_I_DD07
  with parameters
    i_DOMNAME : sxco_ad_object_name --abap.char(30)
  as select from    DDCDS_CUSTOMER_DOMAIN_VALUE( p_domain_name: $parameters.i_DOMNAME  )
    left outer join DDCDS_CUSTOMER_DOMAIN_VALUE_T( p_domain_name: $parameters.i_DOMNAME  ) on  DDCDS_CUSTOMER_DOMAIN_VALUE_T.domain_name    = DDCDS_CUSTOMER_DOMAIN_VALUE.domain_name
                                                                                           and DDCDS_CUSTOMER_DOMAIN_VALUE_T.language       = $session.system_language
                                                                                           and DDCDS_CUSTOMER_DOMAIN_VALUE_T.value_position = DDCDS_CUSTOMER_DOMAIN_VALUE.value_position
                                                                                           and DDCDS_CUSTOMER_DOMAIN_VALUE_T.value_low      = DDCDS_CUSTOMER_DOMAIN_VALUE.value_low
{
  key DDCDS_CUSTOMER_DOMAIN_VALUE.value_low,
      DDCDS_CUSTOMER_DOMAIN_VALUE_T.text
}
