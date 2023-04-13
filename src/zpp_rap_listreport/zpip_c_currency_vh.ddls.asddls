@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Currency Value Help'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel:{
               semanticKey: ['CurrencyName'],
               representativeKey: 'Currency',
               resultSet.sizeCategory: #XS,
               dataCategory: #VALUE_HELP
             }
define view entity zpip_c_currency_vh
  as select from I_Currency
{
  key Currency,
      _Text[1:Language = 'E'].CurrencyName
}
where AlternativeCurrencyKey = '978' or
      AlternativeCurrencyKey = '933' or
      AlternativeCurrencyKey = '840' or
      AlternativeCurrencyKey = '643'
