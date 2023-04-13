@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'ISO Codes'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity zpip_i_isocode_full
  as select from I_UnitOfMeasure
{
  key UnitOfMeasure,
      UnitOfMeasureISOCode,
      _ISOCodeText[1:Language = 'E'].UnitOfMeasureISOCodeName,
      UnitOfMeasureNumberOfDecimals,
      UnitOfMeasure_E,
      UnitOfMeasureDimension,
      /* Associations */
      _ISOCode,
      _ISOCodeText,
      _Text
}
where
      UnitOfMeasureIsCommercial =  'X'
  and UnitOfMeasureISOCode      <> ''
