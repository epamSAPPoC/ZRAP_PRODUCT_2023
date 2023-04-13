@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'User Interface View'


define view entity zpip_i_user
  as select from zpip_d_user
      association [0..1] to I_Country as _Country on $projection.Country = _Country.Country
{
//      @ObjectModel.text.element: ['Name']
//      @UI.textArrangement: #TEXT_ONLY
      @EndUserText.label: 'Contact'
  key id            as Id,
      
      @Semantics.name.fullName: true
      name          as Name,
      
      @Semantics.telephone.type: [ #WORK]
      phone         as Phone,
      
//      @Semantics.address.country: true
//      @Semantics.address.type: [#WORK]
      country       as Country,
      
      @Consumption.valueHelpDefault.display:true
      @Consumption.filter.hidden: true
      @ObjectModel.text.element: ['CountryName']
      @UI.textArrangement: #TEXT_ONLY
      @EndUserText.label: 'Country'
      country       as CountryDisplay,
      
      @Consumption.filter.hidden: true
      @Consumption.valueHelpDefault.display: false
      @Semantics.address.country: true
      @Semantics.address.type: [#WORK]
      _Country._Text[1: Language = $session.system_language].CountryName as CountryName,
            
      @Semantics.address.street: true
      @Semantics.address.type: [#WORK]
      street        as Street,
      
      @Semantics.address.city: true
      @Semantics.address.type: [#WORK]
      city          as City,
      
      @Semantics.address.zipCode: true
      @Semantics.address.type: [#WORK]
      postcode      as Postcode,
      
//      @Semantics.address.label: true
//      @Semantics.address.type: [#WORK]
      address_label as AddressLabel,
      
      @Semantics.imageUrl: true
      photo_url     as PhotoUrl,
      
      @Semantics.eMail.address: true
      @Semantics.eMail.type: [#WORK]
      email         as Email,
      3 as NameCriticality,
      _Country
}
