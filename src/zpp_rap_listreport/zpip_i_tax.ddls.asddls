@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Taxes'
@Metadata.ignorePropagatedAnnotations: true

define view entity zpip_i_tax
  as select from zpip_d_tax
{
  key tax_id   as TaxId,
  key tax_rate as TaxRate,
      isocode  as Isocode
}
