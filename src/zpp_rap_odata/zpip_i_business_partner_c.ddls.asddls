@EndUserText.label: 'Custom Entity'
@ObjectModel.query.implementedBy: 'ABAP:ZPIP_CL_CALL_ODATA_SCM'
@ObjectModel.resultSet.sizeCategory: #XS
define custom entity zpip_i_business_partner_c
{
      @ObjectModel.text.element: ['BusinessPartnerFullName']
  key BusinessPartner         : abap.char( 10 );
      BusinessPartnerFullName : abap.char( 81 );
      BusinessPartnerGrouping : abap.char( 4 );
}
