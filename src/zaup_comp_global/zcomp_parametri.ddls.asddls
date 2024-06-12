@EndUserText.label: 'Parametri Registrazione'
@Metadata.allowExtensions: true
define abstract entity ZCOMP_PARAMETRI
{
  @EndUserText.label: 'Data Documento'
  DataReg : abap.dats;

  @EndUserText.label: 'Testo Documento'
  Testo   : abap.char( 200 );

}
