@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Product CDS view'

define root view entity zpip_i_product
  as select from zpip_d_product as Product

  composition [0..*] of zpip_i_market  as _Market

  association [0..1] to zpip_i_prod_gr            as _ProdGroup        on $projection.Pgid       = _ProdGroup.Pgid
  association [0..1] to zpip_d_phase              as _Phases           on $projection.Phaseid    = _Phases.phaseid
  association [0..1] to zpip_d_uom                as _UOM              on $projection.SizeUom    = _UOM.msehi
  association [0..1] to zpip_c_market_order_count as _MarketOrderCount on $projection.ProdUuid   = _MarketOrderCount.ProdUuid
  association [0..*] to zpip_i_market_ch          as _MarketChart      on $projection.ProdUuid   = _MarketChart.ProdUuid
  association [0..1] to zpip_i_tax                as _TAX              on $projection.Taxrate    = _TAX.TaxRate
  association [0..1] to zpip_c_product_analyze    as _ProductAnalyze   on $projection.Prodid     = _ProductAnalyze.ProdId
  association [0..1] to zpip_c_income_criticality as _IncCritical      on $projection.ProdUuid   = _IncCritical.ProdUuid
  association [0..1] to zpip_i_user               as _CreatedByContact on $projection.CreatedBy = _CreatedByContact.Id
  association [0..1] to zpip_i_user               as _ChangedByContact on $projection.ChangedBy = _ChangedByContact.Id

{
  key prod_uuid         as ProdUuid,
      prodid            as Prodid,
      pgid              as Pgid,
      _ProdGroup.Pgname as Pgname, 
      phaseid           as Phaseid,
      case phaseid
        when 1 
          then 1
        when 2 
          then 2
        when 3 
          then 3
        when 4 
          then 4
          else 0
      end               as PhaseCriticality,
      @Semantics.quantity.unitOfMeasure: 'SizeUom'    
      height            as Height, 
      @Semantics.quantity.unitOfMeasure: 'SizeUom'
      depth             as Depth,  
      @Semantics.quantity.unitOfMeasure: 'SizeUom'
      width             as Width,  
      size_uom          as SizeUom,

      @Semantics.amount.currencyCode: 'PriceCurrency'
      price             as Price,
      case
        when price >  300 then 1
        when price <= 300
         and price >  150 then 2
        when price <= 150
         and price >  50  then 3
        when price <= 50
         and price >  20  then 4
        else 0
      end               as PriceCriticality,
      case
        when _MarketOrderCount.MarcetCount > 0 and
             _MarketOrderCount.OrderCount  > 0
          then 3
        when _MarketOrderCount.MarcetCount > 0 and
             (_MarketOrderCount.OrderCount = 0 or _MarketOrderCount.OrderCount  is null)
          then 2
        when (_MarketOrderCount.MarcetCount = 0 or _MarketOrderCount.MarcetCount is null) and
             (_MarketOrderCount.OrderCount  = 0 or _MarketOrderCount.OrderCount  is null)
          then 1
          else 4
      end               as ProductCriticality,
      price_currency    as PriceCurrency,
         
      taxrate           as Taxrate,
      _TAX.Isocode      as TaxIsocode,
      pgname_trans      as PgnameTrans,
      trans_code        as TransCode,
      
      @Semantics.user.createdBy: true
      Product.created_by as CreatedBy,
      @Semantics.systemDateTime.createdAt: true
      creation_time     as CreationTime,
      @Semantics.user.lastChangedBy: true
      Product.changed_by as ChangedBy,
      //local ETag field --> OData ETag
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      change_time       as ChangeTime,
      
      //total ETag field
      @Semantics.systemDateTime.lastChangedAt: true
      last_changed_at   as LastChangedAt,
//      cast( '   ' as msehi ) as Measures,
      cast('' as char30 ) as Measures,

      /* Associations */
      _Market,
      _ProdGroup,
      _Phases,
      _UOM,
      _MarketChart ,
      _ProductAnalyze,
      _CreatedByContact,
      _ChangedByContact,
      _IncCritical
}
