@AbapCatalog.sqlViewName: 'ZPIPCPRODANALYZE'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Product analyze'
@Metadata.allowExtensions: true

//@Consumption.semanticObject: 'ProdAnalyze'
define view zpip_c_product_analyze
  as select distinct from zpip_tf_product_analyze( p_client : $session.client )
  
{
  key ProdId,
      
      Pgname as ProductName,
      
      Countries,
      
      MarketsQuantity,
      
      OrderQuantity,
      
      @Semantics.amount.currencyCode: 'Amountcurr'
      Netamount,
      
      @Semantics.amount.currencyCode: 'Amountcurr'
      Grossamount,
      
      Amountcurr,
      
      cast(
        division(Netamount, Grossamount,  3) * 100 as abap.dec(9,1)  
      ) as NetamountInGrossamount,
      
      cast(
        (division(Grossamount, Netamount, 3) - 1 ) * 100 as abap.dec(9,1)  
      ) as IncomePercentage,
                  
      3 as ProdIDCriticality,
      3 as ProdNameCriticality
}
