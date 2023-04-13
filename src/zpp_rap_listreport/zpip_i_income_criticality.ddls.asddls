@AbapCatalog.sqlViewName: 'ZPIPINCCRITICAL'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Income Criticalyty'


define view zpip_i_income_criticality
  as select distinct from zpip_tf_product_analyze( p_client : $session.client )
{
  key ProdUuid,
  
      cast(
        division(Netamount, Grossamount,  3) * 100 as abap.dec(9,1)  
      ) as NetamountInGrossamount,
      
      cast(
        (division(Grossamount, Netamount, 3) - 1 ) * 100 as abap.dec(9,1)  
      ) as IncomePercentage
}
