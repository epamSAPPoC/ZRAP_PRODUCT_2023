@AbapCatalog.sqlViewName: 'ZPIPIPRODANALYZE'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Product analyze'

define view zpip_i_product_analyze
  as select from zpip_i_order
{
  key ProdUuid                 as ProdUuid,
      _Product.Prodid          as Prodid,
      _Product.Pgname          as Pgname,
      _Market.CountryName      as MarketName,
      count(distinct MrktUuid) as MarketsQuantity,
      sum(Netamount)           as Netamount,
      sum(Grossamount)         as Grossamount,
      sum(OrderCount)          as OrderQuantity,
      Amountcurr,
      /* Associations */
      _Product
}
group by
  ProdUuid,
  _Product.Prodid,
  _Product.Pgname,
  _Market.CountryName,
  Amountcurr  
