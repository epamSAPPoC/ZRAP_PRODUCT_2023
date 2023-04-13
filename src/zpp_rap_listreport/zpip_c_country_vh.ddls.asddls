@AbapCatalog.sqlViewName: 'ZPIPCOUNTRYVH'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Country Help View'

@ObjectModel.resultSet.sizeCategory: #XS
@UI.presentationVariant: [{
                            sortOrder: [{ by: 'mrktid', direction: #ASC  }]
                         }]
                         
                         
define view zpip_c_country_vh
  as select from zpip_d_country
{
  @ObjectModel.text.element: ['country']
  key mrktid,
      country  
}
