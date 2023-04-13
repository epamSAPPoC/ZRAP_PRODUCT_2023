@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Taxes Value Help'
@ObjectModel.resultSet.sizeCategory: #XS

define view entity zpip_c_tax_vh
  as select from zpip_i_tax
{
  key TaxRate,
      Isocode as TaxIsocode
}
