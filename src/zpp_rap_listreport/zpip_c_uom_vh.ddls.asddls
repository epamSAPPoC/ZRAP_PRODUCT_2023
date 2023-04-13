@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Units fo Measure Value Help'
@ObjectModel.resultSet.sizeCategory: #XS

define view entity zpip_c_uom_vh
  as select from zpip_i_UOM
{
  @ObjectModel.text.element: ['Isocode']
  key Msehi,
      Isocode
}
