@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Consumption Entity for separate service'
@Metadata.ignorePropagatedAnnotations: false
@Metadata.allowExtensions: true
@Search.searchable: true


define view entity zpip_c_order_for_sep_serv
  as select from zpip_i_order
{

  key MrktUuid,
  key OrderUuid,
  key ProdUuid,
      @ObjectModel: { foreignKey.association: '_Product' }
      @Consumption: {
                     semanticObject: 'alpsemantic',
                     semanticObjectMapping: { element: 'ProductName' }
                    }
      @Search:{defaultSearchElement: true, fuzzinessThreshold: 0.7}      
      _Product.Pgname as ProductName,
      
      @Search.defaultSearchElement: true
      @EndUserText.label: 'Order ID'     
      Orderid,
      
      @Consumption.valueHelpDefinition: [{
                                           entity : { name: 'zpip_c_country_vh', element: 'country' } 
                                        }]     
      _Market.CountryName,
      
      @Aggregation.default: #SUM
      Quantity,
      
      CalendarYear,
      
      DeliveryDate,
      
      @Aggregation.default: #SUM
      Netamount,
      
      @Aggregation.default: #SUM
      Grossamount,
      
      Amountcurr,
      
      BusinessPartner,
      
      @Search:{defaultSearchElement: true, fuzzinessThreshold: 0.7}
      BusinessPartnerName,
      
      BusinessPartnerGroup,
      
      CreatedBy,
      
      CreationTime,
      
      ChangedBy,
      
      ChangeTime,
      
      /*Associasions*/
      _Market,
      _Product
}

 
