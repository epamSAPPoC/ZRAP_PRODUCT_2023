@AbapCatalog.sqlViewName: 'ZPIPIOVPMRKTORD'
@AbapCatalog.compiler.compareFilter: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Orders'


define view zpip_i_ovp_market_order
  as select from zpip_d_mrkt_ordr
  
  association[1..1] to zpip_i_ovp_product as _Product on $projection.ProdUuid = _Product.ProdUuid
  association[1..1] to zpip_i_ovp_market  as _Market  on $projection.MrktUuid = _Market.MrktUuid and
                                                         $projection.ProdUuid = _Market.ProdUuid
  
{
  key prod_uuid                                       as ProdUuid,
  key mrkt_uuid                                       as MrktUuid,
  key order_uuid                                      as OrderUuid,
      _Market._Country.Country                        as CountryName,
      cast(1 as abap.int4)                            as CountByCountry,
      _Product.Pgid                                   as Pgid,
      _Product._ProdGrp.Pgname                        as ProductName,
      cast(1 as abap.int4)                            as CountByProdGrp,
      _Product._Phase.Phase                           as PhaseName,
      orderid                                         as Orderid,
      quantity                                        as Quantity,
      calendar_year                                   as CalendarYear,
      delivery_date                                   as DeliveryDate,
      
      @Semantics.amount.currencyCode: 'Amountcurr'
      netamount                                       as Netamount,
      
      @Semantics.amount.currencyCode: 'Amountcurr'
      grossamount                                     as Grossamount,
      amountcurr                                      as Amountcurr,
      
      @Semantics.amount.currencyCode: 'Amountcurr'
      @EndUserText.label: 'Gross Incom'
      grossamount - netamount                         as GrossIncom,
      
      @Semantics.quantity.unitOfMeasure:'Percentage'
      division(
        (grossamount - netamount) * 100, netamount, 2
      )                                               as GrossIncomPercentage,
      
      @Semantics.unitOfMeasure:true
      cast(' % ' as abap.unit(3))                     as Percentage,
      
      20                                              as TargetGrossIncomPercentage,
      
      @Semantics.quantity.unitOfMeasure:'Percentage'
      division(
        (grossamount - netamount) * 100, netamount, 2
      )                                               as GrossIncomPercentageList,
      
      @Semantics.quantity.unitOfMeasure:'Percentage'
      division(
        (grossamount - netamount) * 100, netamount, 2
      )                                               as GrossIncomPercentageKPI,
      
      20                                              as TargetGrossIncomPercentageKPI,
      
      /*Associations*/
      _Product,
      _Market
      
}
