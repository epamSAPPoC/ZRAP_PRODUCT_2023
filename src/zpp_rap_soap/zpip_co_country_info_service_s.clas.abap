class ZPIP_CO_COUNTRY_INFO_SERVICE_S definition
  public
  inheriting from CL_PROXY_CLIENT
  create public .

public section.

  methods LIST_OF_LANGUAGES_BY_NAME
    importing
      !INPUT type ZPIP_LIST_OF_LANGUAGES_BY_NAM1
    exporting
      !OUTPUT type ZPIP_LIST_OF_LANGUAGES_BY_NAME
    raising
      CX_AI_SYSTEM_FAULT .
  methods LIST_OF_LANGUAGES_BY_CODE
    importing
      !INPUT type ZPIP_LIST_OF_LANGUAGES_BY_COD1
    exporting
      !OUTPUT type ZPIP_LIST_OF_LANGUAGES_BY_CODE
    raising
      CX_AI_SYSTEM_FAULT .
  methods LIST_OF_CURRENCIES_BY_NAME
    importing
      !INPUT type ZPIP_LIST_OF_CURRENCIES_BY_NA1
    exporting
      !OUTPUT type ZPIP_LIST_OF_CURRENCIES_BY_NAM
    raising
      CX_AI_SYSTEM_FAULT .
  methods LIST_OF_CURRENCIES_BY_CODE
    importing
      !INPUT type ZPIP_LIST_OF_CURRENCIES_BY_CO1
    exporting
      !OUTPUT type ZPIP_LIST_OF_CURRENCIES_BY_COD
    raising
      CX_AI_SYSTEM_FAULT .
  methods LIST_OF_COUNTRY_NAMES_GROUPED
    importing
      !INPUT type ZPIP_LIST_OF_COUNTRY_NAMES_GR1
    exporting
      !OUTPUT type ZPIP_LIST_OF_COUNTRY_NAMES_GRO
    raising
      CX_AI_SYSTEM_FAULT .
  methods LIST_OF_COUNTRY_NAMES_BY_NAME
    importing
      !INPUT type ZPIP_LIST_OF_COUNTRY_NAMES_BY1
    exporting
      !OUTPUT type ZPIP_LIST_OF_COUNTRY_NAMES_BY
    raising
      CX_AI_SYSTEM_FAULT .
  methods LIST_OF_COUNTRY_NAMES_BY_CODE
    importing
      !INPUT type ZPIP_LIST_OF_COUNTRY_NAMES_BY3
    exporting
      !OUTPUT type ZPIP_LIST_OF_COUNTRY_NAMES_BY2
    raising
      CX_AI_SYSTEM_FAULT .
  methods LIST_OF_CONTINENTS_BY_NAME
    importing
      !INPUT type ZPIP_LIST_OF_CONTINENTS_BY_NA1
    exporting
      !OUTPUT type ZPIP_LIST_OF_CONTINENTS_BY_NAM
    raising
      CX_AI_SYSTEM_FAULT .
  methods LIST_OF_CONTINENTS_BY_CODE
    importing
      !INPUT type ZPIP_LIST_OF_CONTINENTS_BY_CO1
    exporting
      !OUTPUT type ZPIP_LIST_OF_CONTINENTS_BY_COD
    raising
      CX_AI_SYSTEM_FAULT .
  methods LANGUAGE_NAME
    importing
      !INPUT type ZPIP_LANGUAGE_NAME_SOAP_REQUES
    exporting
      !OUTPUT type ZPIP_LANGUAGE_NAME_SOAP_RESPON
    raising
      CX_AI_SYSTEM_FAULT .
  methods LANGUAGE_ISOCODE
    importing
      !INPUT type ZPIP_LANGUAGE_ISOCODE_SOAP_REQ
    exporting
      !OUTPUT type ZPIP_LANGUAGE_ISOCODE_SOAP_RES
    raising
      CX_AI_SYSTEM_FAULT .
  methods FULL_COUNTRY_INFO_ALL_COUNTRIE
    importing
      !INPUT type ZPIP_FULL_COUNTRY_INFO_ALL_CO1
    exporting
      !OUTPUT type ZPIP_FULL_COUNTRY_INFO_ALL_COU
    raising
      CX_AI_SYSTEM_FAULT .
  methods FULL_COUNTRY_INFO
    importing
      !INPUT type ZPIP_FULL_COUNTRY_INFO_SOAP_R1
    exporting
      !OUTPUT type ZPIP_FULL_COUNTRY_INFO_SOAP_RE
    raising
      CX_AI_SYSTEM_FAULT .
  methods CURRENCY_NAME
    importing
      !INPUT type ZPIP_CURRENCY_NAME_SOAP_REQUES
    exporting
      !OUTPUT type ZPIP_CURRENCY_NAME_SOAP_RESPON
    raising
      CX_AI_SYSTEM_FAULT .
  methods COUNTRY_NAME
    importing
      !INPUT type ZPIP_COUNTRY_NAME_SOAP_REQUEST
    exporting
      !OUTPUT type ZPIP_COUNTRY_NAME_SOAP_RESPONS
    raising
      CX_AI_SYSTEM_FAULT .
  methods COUNTRY_ISOCODE
    importing
      !INPUT type ZPIP_COUNTRY_ISOCODE_SOAP_REQU
    exporting
      !OUTPUT type ZPIP_COUNTRY_ISOCODE_SOAP_RESP
    raising
      CX_AI_SYSTEM_FAULT .
  methods COUNTRY_INT_PHONE_CODE
    importing
      !INPUT type ZPIP_COUNTRY_INT_PHONE_CODE_S1
    exporting
      !OUTPUT type ZPIP_COUNTRY_INT_PHONE_CODE_SO
    raising
      CX_AI_SYSTEM_FAULT .
  methods COUNTRY_FLAG
    importing
      !INPUT type ZPIP_COUNTRY_FLAG_SOAP_REQUEST
    exporting
      !OUTPUT type ZPIP_COUNTRY_FLAG_SOAP_RESPONS
    raising
      CX_AI_SYSTEM_FAULT .
  methods COUNTRY_CURRENCY
    importing
      !INPUT type ZPIP_COUNTRY_CURRENCY_SOAP_REQ
    exporting
      !OUTPUT type ZPIP_COUNTRY_CURRENCY_SOAP_RES
    raising
      CX_AI_SYSTEM_FAULT .
  methods COUNTRIES_USING_CURRENCY
    importing
      !INPUT type ZPIP_COUNTRIES_USING_CURRENCY1
    exporting
      !OUTPUT type ZPIP_COUNTRIES_USING_CURRENCY
    raising
      CX_AI_SYSTEM_FAULT .
  methods CONSTRUCTOR
    importing
      !DESTINATION type ref to IF_PROXY_DESTINATION optional
      !LOGICAL_PORT_NAME type PRX_LOGICAL_PORT_NAME optional
    preferred parameter LOGICAL_PORT_NAME
    raising
      CX_AI_SYSTEM_FAULT .
  methods CAPITAL_CITY
    importing
      !INPUT type ZPIP_CAPITAL_CITY_SOAP_REQUEST
    exporting
      !OUTPUT type ZPIP_CAPITAL_CITY_SOAP_RESPONS
    raising
      CX_AI_SYSTEM_FAULT .
protected section.
private section.
ENDCLASS.



CLASS ZPIP_CO_COUNTRY_INFO_SERVICE_S IMPLEMENTATION.


  method CAPITAL_CITY.

  data(lt_parmbind) = value abap_parmbind_tab(
    ( name = 'INPUT' kind = '0' value = ref #( INPUT ) )
    ( name = 'OUTPUT' kind = '1' value = ref #( OUTPUT ) )
  ).
  if_proxy_client~execute(
    exporting
      method_name = 'CAPITAL_CITY'
    changing
      parmbind_tab = lt_parmbind
  ).

  endmethod.


  method CONSTRUCTOR.

  super->constructor(
    class_name          = 'ZPIP_CO_COUNTRY_INFO_SERVICE_S'
    logical_port_name   = logical_port_name
    destination         = destination
  ).

  endmethod.


  method COUNTRIES_USING_CURRENCY.

  data(lt_parmbind) = value abap_parmbind_tab(
    ( name = 'INPUT' kind = '0' value = ref #( INPUT ) )
    ( name = 'OUTPUT' kind = '1' value = ref #( OUTPUT ) )
  ).
  if_proxy_client~execute(
    exporting
      method_name = 'COUNTRIES_USING_CURRENCY'
    changing
      parmbind_tab = lt_parmbind
  ).

  endmethod.


  method COUNTRY_CURRENCY.

  data(lt_parmbind) = value abap_parmbind_tab(
    ( name = 'INPUT' kind = '0' value = ref #( INPUT ) )
    ( name = 'OUTPUT' kind = '1' value = ref #( OUTPUT ) )
  ).
  if_proxy_client~execute(
    exporting
      method_name = 'COUNTRY_CURRENCY'
    changing
      parmbind_tab = lt_parmbind
  ).

  endmethod.


  method COUNTRY_FLAG.

  data(lt_parmbind) = value abap_parmbind_tab(
    ( name = 'INPUT' kind = '0' value = ref #( INPUT ) )
    ( name = 'OUTPUT' kind = '1' value = ref #( OUTPUT ) )
  ).
  if_proxy_client~execute(
    exporting
      method_name = 'COUNTRY_FLAG'
    changing
      parmbind_tab = lt_parmbind
  ).

  endmethod.


  method COUNTRY_INT_PHONE_CODE.

  data(lt_parmbind) = value abap_parmbind_tab(
    ( name = 'INPUT' kind = '0' value = ref #( INPUT ) )
    ( name = 'OUTPUT' kind = '1' value = ref #( OUTPUT ) )
  ).
  if_proxy_client~execute(
    exporting
      method_name = 'COUNTRY_INT_PHONE_CODE'
    changing
      parmbind_tab = lt_parmbind
  ).

  endmethod.


  method COUNTRY_ISOCODE.

  data(lt_parmbind) = value abap_parmbind_tab(
    ( name = 'INPUT' kind = '0' value = ref #( INPUT ) )
    ( name = 'OUTPUT' kind = '1' value = ref #( OUTPUT ) )
  ).
  if_proxy_client~execute(
    exporting
      method_name = 'COUNTRY_ISOCODE'
    changing
      parmbind_tab = lt_parmbind
  ).

  endmethod.


  method COUNTRY_NAME.

  data(lt_parmbind) = value abap_parmbind_tab(
    ( name = 'INPUT' kind = '0' value = ref #( INPUT ) )
    ( name = 'OUTPUT' kind = '1' value = ref #( OUTPUT ) )
  ).
  if_proxy_client~execute(
    exporting
      method_name = 'COUNTRY_NAME'
    changing
      parmbind_tab = lt_parmbind
  ).

  endmethod.


  method CURRENCY_NAME.

  data(lt_parmbind) = value abap_parmbind_tab(
    ( name = 'INPUT' kind = '0' value = ref #( INPUT ) )
    ( name = 'OUTPUT' kind = '1' value = ref #( OUTPUT ) )
  ).
  if_proxy_client~execute(
    exporting
      method_name = 'CURRENCY_NAME'
    changing
      parmbind_tab = lt_parmbind
  ).

  endmethod.


  method FULL_COUNTRY_INFO.

  data(lt_parmbind) = value abap_parmbind_tab(
    ( name = 'INPUT' kind = '0' value = ref #( INPUT ) )
    ( name = 'OUTPUT' kind = '1' value = ref #( OUTPUT ) )
  ).
  if_proxy_client~execute(
    exporting
      method_name = 'FULL_COUNTRY_INFO'
    changing
      parmbind_tab = lt_parmbind
  ).

  endmethod.


  method FULL_COUNTRY_INFO_ALL_COUNTRIE.

  data(lt_parmbind) = value abap_parmbind_tab(
    ( name = 'INPUT' kind = '0' value = ref #( INPUT ) )
    ( name = 'OUTPUT' kind = '1' value = ref #( OUTPUT ) )
  ).
  if_proxy_client~execute(
    exporting
      method_name = 'FULL_COUNTRY_INFO_ALL_COUNTRIE'
    changing
      parmbind_tab = lt_parmbind
  ).

  endmethod.


  method LANGUAGE_ISOCODE.

  data(lt_parmbind) = value abap_parmbind_tab(
    ( name = 'INPUT' kind = '0' value = ref #( INPUT ) )
    ( name = 'OUTPUT' kind = '1' value = ref #( OUTPUT ) )
  ).
  if_proxy_client~execute(
    exporting
      method_name = 'LANGUAGE_ISOCODE'
    changing
      parmbind_tab = lt_parmbind
  ).

  endmethod.


  method LANGUAGE_NAME.

  data(lt_parmbind) = value abap_parmbind_tab(
    ( name = 'INPUT' kind = '0' value = ref #( INPUT ) )
    ( name = 'OUTPUT' kind = '1' value = ref #( OUTPUT ) )
  ).
  if_proxy_client~execute(
    exporting
      method_name = 'LANGUAGE_NAME'
    changing
      parmbind_tab = lt_parmbind
  ).

  endmethod.


  method LIST_OF_CONTINENTS_BY_CODE.

  data(lt_parmbind) = value abap_parmbind_tab(
    ( name = 'INPUT' kind = '0' value = ref #( INPUT ) )
    ( name = 'OUTPUT' kind = '1' value = ref #( OUTPUT ) )
  ).
  if_proxy_client~execute(
    exporting
      method_name = 'LIST_OF_CONTINENTS_BY_CODE'
    changing
      parmbind_tab = lt_parmbind
  ).

  endmethod.


  method LIST_OF_CONTINENTS_BY_NAME.

  data(lt_parmbind) = value abap_parmbind_tab(
    ( name = 'INPUT' kind = '0' value = ref #( INPUT ) )
    ( name = 'OUTPUT' kind = '1' value = ref #( OUTPUT ) )
  ).
  if_proxy_client~execute(
    exporting
      method_name = 'LIST_OF_CONTINENTS_BY_NAME'
    changing
      parmbind_tab = lt_parmbind
  ).

  endmethod.


  method LIST_OF_COUNTRY_NAMES_BY_CODE.

  data(lt_parmbind) = value abap_parmbind_tab(
    ( name = 'INPUT' kind = '0' value = ref #( INPUT ) )
    ( name = 'OUTPUT' kind = '1' value = ref #( OUTPUT ) )
  ).
  if_proxy_client~execute(
    exporting
      method_name = 'LIST_OF_COUNTRY_NAMES_BY_CODE'
    changing
      parmbind_tab = lt_parmbind
  ).

  endmethod.


  method LIST_OF_COUNTRY_NAMES_BY_NAME.

  data(lt_parmbind) = value abap_parmbind_tab(
    ( name = 'INPUT' kind = '0' value = ref #( INPUT ) )
    ( name = 'OUTPUT' kind = '1' value = ref #( OUTPUT ) )
  ).
  if_proxy_client~execute(
    exporting
      method_name = 'LIST_OF_COUNTRY_NAMES_BY_NAME'
    changing
      parmbind_tab = lt_parmbind
  ).

  endmethod.


  method LIST_OF_COUNTRY_NAMES_GROUPED.

  data(lt_parmbind) = value abap_parmbind_tab(
    ( name = 'INPUT' kind = '0' value = ref #( INPUT ) )
    ( name = 'OUTPUT' kind = '1' value = ref #( OUTPUT ) )
  ).
  if_proxy_client~execute(
    exporting
      method_name = 'LIST_OF_COUNTRY_NAMES_GROUPED'
    changing
      parmbind_tab = lt_parmbind
  ).

  endmethod.


  method LIST_OF_CURRENCIES_BY_CODE.

  data(lt_parmbind) = value abap_parmbind_tab(
    ( name = 'INPUT' kind = '0' value = ref #( INPUT ) )
    ( name = 'OUTPUT' kind = '1' value = ref #( OUTPUT ) )
  ).
  if_proxy_client~execute(
    exporting
      method_name = 'LIST_OF_CURRENCIES_BY_CODE'
    changing
      parmbind_tab = lt_parmbind
  ).

  endmethod.


  method LIST_OF_CURRENCIES_BY_NAME.

  data(lt_parmbind) = value abap_parmbind_tab(
    ( name = 'INPUT' kind = '0' value = ref #( INPUT ) )
    ( name = 'OUTPUT' kind = '1' value = ref #( OUTPUT ) )
  ).
  if_proxy_client~execute(
    exporting
      method_name = 'LIST_OF_CURRENCIES_BY_NAME'
    changing
      parmbind_tab = lt_parmbind
  ).

  endmethod.


  method LIST_OF_LANGUAGES_BY_CODE.

  data(lt_parmbind) = value abap_parmbind_tab(
    ( name = 'INPUT' kind = '0' value = ref #( INPUT ) )
    ( name = 'OUTPUT' kind = '1' value = ref #( OUTPUT ) )
  ).
  if_proxy_client~execute(
    exporting
      method_name = 'LIST_OF_LANGUAGES_BY_CODE'
    changing
      parmbind_tab = lt_parmbind
  ).

  endmethod.


  method LIST_OF_LANGUAGES_BY_NAME.

  data(lt_parmbind) = value abap_parmbind_tab(
    ( name = 'INPUT' kind = '0' value = ref #( INPUT ) )
    ( name = 'OUTPUT' kind = '1' value = ref #( OUTPUT ) )
  ).
  if_proxy_client~execute(
    exporting
      method_name = 'LIST_OF_LANGUAGES_BY_NAME'
    changing
      parmbind_tab = lt_parmbind
  ).

  endmethod.
ENDCLASS.
