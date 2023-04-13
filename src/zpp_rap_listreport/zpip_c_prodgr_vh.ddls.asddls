@AbapCatalog.sqlViewName: 'ZPIPPRPDGRVH'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Product group Value Help'

@ObjectModel.resultSet.sizeCategory: #XS
@UI.presentationVariant: [{
                            sortOrder: [{ by: 'pgid', direction: #ASC  }]
                         }]

define view zpip_c_prodgr_vh
  as select from zpip_d_prod_grp
{
  @ObjectModel.text.element: ['pgname']    
  key pgid ,
      pgname  
}
