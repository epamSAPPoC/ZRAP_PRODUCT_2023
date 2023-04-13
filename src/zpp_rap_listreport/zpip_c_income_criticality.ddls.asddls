@AbapCatalog.sqlViewName: 'ZPIPCINCCRITICAL'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Income criticality'

define view zpip_c_income_criticality
  as select from zpip_i_income_criticality
{
  key ProdUuid,
      IncomePercentage,
      case
        when IncomePercentage > 25
          then 3
        when IncomePercentage > 15 and
             IncomePercentage <= 18
          then 2
        when IncomePercentage <= 15
          then 1
          else 0
      end  as IncomePercentageCriticality,
      NetamountInGrossamount,
            case
        when NetamountInGrossamount >= 85
          then 1
        when NetamountInGrossamount >= 78 and
             IncomePercentage < 85
          then 2
        when IncomePercentage < 78
          then 3
          else 0
      end  as NetamountInGrossamountCritical,
      70   as ForecastValue,
      70   as TargetValueElement,
      85   as toleranceHigh,
      65   as toleranceLow,
      80   as deviationHigh,
      79.1 as deviationLow
      
}
