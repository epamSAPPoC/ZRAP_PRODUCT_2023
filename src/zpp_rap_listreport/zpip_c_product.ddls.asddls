@EndUserText.label: 'Product projection CDS view'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Search.searchable: true
@Metadata.allowExtensions: true

define root view entity zpip_c_product
  as projection on zpip_i_product as Product

{
  key ProdUuid,
      @Consumption.valueHelpDefinition: [{
                                           entity: { name:    'zpip_c_product_vh',
                                                     element: 'Prodid' }
                                        }]
      @ObjectModel: { foreignKey.association: '_ProductAnalyze' }
      @Consumption: {
                     semanticObject: 'productanalyzesemobj',
//                     semanticObject: 'ProdAnalyze',
                     semanticObjectMapping.element: 'Prodid',
                     semanticObjectMapping.additionalBinding: [{
                                                                 localElement: 'ProdGrName', 
                                                                 element: 'ProductName' 
                                                              }] 
                    }
      @Search.defaultSearchElement: true   
      Prodid,
      
      @Consumption: {
                     semanticObject: 'ovpsemanticobject',
                     semanticObjectMapping.additionalBinding: [ 
                                                               {
                                                                 localElement: 'ProdGrName', 
                                                                 element: 'ProductName' 
                                                               }
                                                              ] 
                    }
      @Consumption.valueHelpDefinition: [{ 
                                           entity : { name:    'zpip_c_prodgr_vh', 
                                                      element: 'pgid' } 
                                        }]
      @ObjectModel.text.element:    ['ProdGrName']
      @Search:{defaultSearchElement: true, fuzzinessThreshold: 0.7}
      @Semantics.text: true
      Pgid,
      @Search:{defaultSearchElement: true, fuzzinessThreshold: 0.7}
      _ProdGroup.Pgname as ProdGrName,
      
      @Consumption.valueHelpDefinition: [{ 
                                           entity : { name:    'zpip_c_phase_vh', 
                                                      element: 'Phaseid' } 
                                        }]
      @ObjectModel.text.element:    ['PhaseName']
      @Search.defaultSearchElement: true
      Phaseid,
      _Phases.phase as PhaseName,
      
      @Semantics.quantity.unitOfMeasure: 'SizeUom'
      Height,
     
      @Semantics.quantity.unitOfMeasure: 'SizeUom'
      Depth,
     
      @Semantics.quantity.unitOfMeasure: 'SizeUom'
      Width,
      
      @Consumption.valueHelpDefinition: [{ 
                                           entity : { name: 'zpip_c_uom_vh', 
                                                      element: 'Msehi' } 
                                        }]
      @ObjectModel.text.element: ['DimName']
      @Search.defaultSearchElement: true
      @Semantics.unitOfMeasure: true
      @EndUserText.label: 'Units'
      SizeUom,
      _UOM.isocode as DimName,
      
      @Semantics.amount.currencyCode: 'PriceCurrency'
      Price,

      PriceCriticality,
      ProductCriticality,
      PhaseCriticality,
      _IncCritical.IncomePercentageCriticality,
      _IncCritical.NetamountInGrossamountCritical,
      _IncCritical.ForecastValue,
      _IncCritical.TargetValueElement,
      _IncCritical.deviationHigh,
      _IncCritical.deviationLow,
      _IncCritical.toleranceHigh,
      _IncCritical.toleranceLow,
      
      @Consumption.valueHelpDefinition: [{ 
                                           entity : { name:    'zpip_c_currency_vh', 
                                                      element: 'Currency' } 
                                        }]
      PriceCurrency,
      
      @Consumption.valueHelpDefinition: [{
                                           entity: { 
                                                     name:    'zpip_c_tax_vh', 
                                                     element: 'TaxRate' 
                                                    },
                                           additionalBinding: [{ localElement: 'TaxIsocode', element: 'TaxIsocode' }]
                                        }]
      Taxrate,
      
      @EndUserText.label: 'Tax Units'
      TaxIsocode,
      
      PgnameTrans,
      
      @Consumption.valueHelpDefinition: [{ 
                                           entity : { name:    'zpip_c_lang_vh', 
                                                      element: 'Code' } 
                                        }]
      TransCode,
      
      _ProdGroup.Imageurl,
      
      _ProductAnalyze.IncomePercentage,
      _ProductAnalyze.NetamountInGrossamount,
      
      @ObjectModel.foreignKey.association: '_CreatedByContact'
      CreatedBy,
      
      CreationTime,
      
      @ObjectModel.foreignKey.association: '_ChangedByContact'
      ChangedBy,
      
      ChangeTime,
      
      Measures,
      
      /* Associations */
      _Market : redirected to composition child zpip_c_market,
      _ProdGroup,
      _Phases,
      _UOM,
      _MarketChart,
      _ProductAnalyze,
      _CreatedByContact,
      _ChangedByContact,
      _IncCritical
}
