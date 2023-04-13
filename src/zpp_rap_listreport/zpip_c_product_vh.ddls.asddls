@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Product Value Help'

define view entity zpip_c_product_vh
  as select from zpip_i_product  as Product
     inner join  zpip_d_prod_grp as ProdGroup on Product.Pgid = ProdGroup.pgid
{
  key Product.Prodid,
      ProdGroup.pgname
}
