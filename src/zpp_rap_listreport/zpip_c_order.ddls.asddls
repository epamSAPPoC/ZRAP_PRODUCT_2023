@EndUserText.label: 'Projection for Order'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Search.searchable: true
@Metadata.allowExtensions: true


define view entity zpip_c_order
  as projection on zpip_i_order
{
  key ProdUuid,
  key MrktUuid,
  key OrderUuid,
      
      _Product._ProdGroup.Pgname as ProductName,
      
      @Search.defaultSearchElement: true
//      @Consumption: {
//                     semanticObject: 'orderslistrepsemobj',
//                     semanticObjectMapping.additionalBinding: [ 
//                                                               {
//                                                                 localElement: 'OrderUuid', 
//                                                                 element: 'OrderUuid' 
//                                                               }
//                                                              ]
//                    }
      Orderid,
      
      Quantity,
      
      @Search.defaultSearchElement: true
      CalendarYear,
      
      @Search.defaultSearchElement: true
      DeliveryDate,
      
      @Semantics.amount.currencyCode: 'Amountcurr'
      Netamount,
      
      @Semantics.amount.currencyCode: 'Amountcurr'
      Grossamount,
      
      @Consumption.valueHelpDefinition: [{ 
                                           entity: { 
                                                     name:    'I_Currency', 
                                                     element: 'Currency' 
                                                   } 
                                        }]
      Amountcurr,
      
      @Consumption.valueHelpDefinition: [{ 
                                           entity : { 
                                                      name:    'zpip_i_business_partner_c', 
                                                      element: 'BusinessPartner' 
                                                    }, 
                                           
                                           additionalBinding: [
                                                               { localElement: 'BusinessPartnerName',  element: 'BusinessPartnerFullName' },
                                                               { localElement: 'BusinessPartnerGroup', element: 'BusinessPartnerGrouping' }
                                                              ]
                                        }]
      @Search.defaultSearchElement: true
      @EndUserText.label: 'Business Partner ID'
      BusinessPartner,     
      
      @EndUserText.label: 'Business Partner Name'
      BusinessPartnerName, 
      
      @EndUserText.label: 'Business Partner Group'
      BusinessPartnerGroup,
      
      @ObjectModel.foreignKey.association: '_CreatedByContact'
      CreatedBy,
      CreationTime,
      @ObjectModel.foreignKey.association: '_ChangedByContact'
      ChangedBy,
      ChangeTime ,
      
      /* Associations */
      _Market  : redirected to parent zpip_c_market, 
      _Product : redirected to        zpip_c_product,
      _CreatedByContact,
      _ChangedByContact

}
