CLASS  ltcl_order  DEFINITION FINAL FOR TESTING
                      DURATION SHORT
                      RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    CLASS-DATA: cut                  TYPE REF TO lhc_order,
                cds_test_environment TYPE REF TO if_cds_test_environment,
                sql_test_environment TYPE REF TO if_osql_test_environment.
    CLASS-METHODS:
      class_setup,
      class_teardown.
    METHODS:
      setup
        RAISING cx_abap_auth_check_exception,
      teardown,
      check_orders FOR TESTING
        RAISING cx_static_check.

ENDCLASS.

CLASS  ltcl_order IMPLEMENTATION.

  METHOD class_teardown.
    cds_test_environment->destroy( ).
    sql_test_environment->destroy( ).
  ENDMETHOD.

  METHOD  setup.
    cds_test_environment->clear_doubles( ).
    sql_test_environment->clear_doubles( ).
  ENDMETHOD.

  METHOD  teardown.
    ROLLBACK ENTITIES.
  ENDMETHOD.

  METHOD class_setup.
    CREATE OBJECT cut FOR TESTING.
*    cds_test_environment = cl_cds_test_environment=>create( i_for_entity = 'zpip_c_product' ).
    cds_test_environment = cl_cds_test_environment=>create_for_multiple_cds( i_for_entities = VALUE #(  ( i_for_entity ='zpip_c_product' )
                                                                                                        ( i_for_entity ='zpip_c_market' )
                                                                                                        ( i_for_entity ='zpip_c_order' ) ) ).
    cds_test_environment->enable_double_redirection( ). " ! IMPORTANT !
    sql_test_environment = cl_osql_test_environment=>create( i_dependency_list = VALUE #( ( 'zpip_d_mrkt_ordr' ) ) ).
  ENDMETHOD.

  METHOD check_orders.
* ---- Set test data for 'zpip_i_order'
    DATA(lv_time) = sy-uzeit.
    DATA(lv_date) = sy-datum.
    DATA(lv_end_date) = lv_date + 365.

    DATA: lv_timestampl TYPE timestampl.
    GET TIME STAMP FIELD  lv_timestampl.
    DATA(lv_chg_timestampl) = lv_timestampl + 100000000.

* ---- Set test data for 'zpip_i_product'
    DATA: lt_products   TYPE STANDARD TABLE OF zpip_i_product.
    lt_products = VALUE #(
      ( ProdUuid     = 'FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0'   prodid    = '0-00' pgid       = '000'
        phaseid      = 0           height = 00  depth = 00  width     = 00     SizeUom    = 'CM'
        price        = '00.00'     PriceCurrency = 'USD'    taxrate   = '0'    taxisocode = 'A0'
        CreationTime = '000001'    TransCode = 'FR'
        Pgname       = 'none' )
      ( ProdUuid     = 'FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF1'   prodid    = 'A-01' pgid       = '001'
        phaseid      = 1           height = 11  depth = 11  width     = 11     SizeUom    = 'CM'
        price        = '1.11'      PriceCurrency = 'USD'    taxrate   = '1'    taxisocode = 'A1'
        CreationTime = '000001'    TransCode = 'FR'
        Pgname       = 'Microwave' )
      ( ProdUuid     = 'FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF2'   prodid    = 'B-02' pgid       = '002'
        phaseid      = 2           height = 22  depth = 22  width     = 22     SizeUom    = 'CM'
        price        = '2.22'      PriceCurrency = 'USD'    taxrate   = '2'    taxisocode = 'B2'
        CreationTime = '000002'    TransCode = 'DE'
        Pgname       = 'Coffee Machine' )
      ( ProdUuid     = 'FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF3'   prodid    = 'C-03' pgid       = '003'
        phaseid      = 3           height = 33  depth = 33  width     = 33     SizeUom    = 'CM'
        price        = '3.33'      PriceCurrency = 'USD'    taxrate   = '3'    taxisocode = 'C3'
        CreationTime = '000003'    TransCode = 'RU'
        Pgname       = 'Waffle Iron' )
      ( ProdUuid     = 'FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF4'   prodid    = 'D-04' pgid       = '004'
        phaseid      = 4           height = 44  depth = 44  width     = 44     SizeUom    = 'CM'
        price        = '4.44'      PriceCurrency = 'USD'    taxrate   = '4'    taxisocode = 'D4'
        CreationTime = '000004'    TransCode = 'IT'
        Pgname       = 'Blender' )
      ( ProdUuid     = 'FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5'   prodid    = 'E-05' pgid       = '005'
        phaseid      = 5           height = 55  depth = 55  width     = 55     SizeUom    = 'CM'
        price        = '5.55'      PriceCurrency = 'USD'    taxrate   = '5'    taxisocode = 'E5'
        CreationTime = '000005'    TransCode     = 'GE'
        Pgname       = 'Cooker' )
      ( ProdUuid     = 'FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF6'   prodid    = 'F-06' pgid       = '006'
        phaseid      = 6           height = 66  depth = 66  width     = 66     SizeUom    = 'CM'
        price        = '6.66'      PriceCurrency = 'USD'    taxrate   = '6'    taxisocode = 'E6'
        CreationTime = '000006'    TransCode = 'HE'
        Pgname       = 'Space Ship' )
      ( ProdUuid     = 'FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF11'   prodid    = 'A-11' "pgid       = '001'
        phaseid      = 1           height = 11  depth = 11  width     = 11     SizeUom    = 'CM'
        price        = '11.11'     PriceCurrency = 'USD'    taxrate   = '1'    taxisocode = 'A1'
        CreationTime = '000011'    )
      ( ProdUuid     = 'FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF22'   prodid    = 'B-22' "pgid       = '002'
        phaseid      = 2           height = 22  depth = 22  width     = 22     SizeUom    = 'CM'
        price        = '22.22'     PriceCurrency = 'USD'    taxrate   = '2'    taxisocode = 'B2'
        CreationTime = '000022'     )
      ( ProdUuid     = 'FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF33'   prodid    = 'C-33' "pgid       = '003'
        phaseid      = 3           height = 33  depth = 33  width     = 33     SizeUom    = 'CM'
        price        = '33.33'     PriceCurrency = 'USD'    taxrate   = '3'    taxisocode = 'C3'
        CreationTime = '000033'     )
      ( ProdUuid     = 'FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF44'   prodid    = 'D-44' "pgid       = '004'
        phaseid      = 4           height = 44  depth = 44  width     = 44     SizeUom    = 'CM'
        price        = '44.44'     PriceCurrency = 'USD'    taxrate   = '4'    taxisocode = 'D4'
        CreationTime = '000044'     )
                      ).
* ---- check inserted entries
    cds_test_environment->insert_test_data( i_data = lt_products ).
    SELECT * FROM zpip_i_product INTO TABLE @DATA(act_products). "#EC CI_ALL_FIELDS_NEEDED
    cl_abap_unit_assert=>assert_equals( msg = 'Prooduct data insert error'
                                        act = act_products   " Actual Value
                                        exp = lt_products ). " Expected Value


    DATA: lt_markets   TYPE STANDARD TABLE OF zpip_i_market.
    lt_markets = VALUE #(
      ( ProdUuid ='FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0' MrktUuid ='FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFA0' Mrktid ='7'  CountryName ='USA'     ISOCode =''   Status ='X' StatusCriticality ='3' Startdate = lv_date Enddate = lv_end_date ItemQuantity ='8880'
        MarketNetamoun ='621600.00'   MarketGrossamount ='798134.40'   Amountcurr ='USD' CreatedBy = sy-uname CreationTime = lv_timestampl ChangedBy = sy-uname ChangeTime = lv_timestampl MarketCount ='1' )
      ( ProdUuid ='FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF1' MrktUuid ='FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFA1' Mrktid ='7'  CountryName ='USA'     ISOCode =''   Status ='X' StatusCriticality ='3' Startdate = lv_date Enddate = lv_end_date ItemQuantity ='112000'
        MarketNetamoun ='22400000.00' MarketGrossamount ='28282240.00' Amountcurr ='USD' CreatedBy = sy-uname CreationTime = lv_timestampl ChangedBy = sy-uname ChangeTime = lv_timestampl MarketCount ='1' )
      ( ProdUuid ='FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF2' MrktUuid ='FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFA2' Mrktid ='5'  CountryName ='Germany' ISOCode ='DE' Status ='X' StatusCriticality ='3' Startdate = lv_date Enddate = lv_end_date ItemQuantity ='115000'
        MarketNetamoun ='5750000.00'  MarketGrossamount ='6767750.00'  Amountcurr ='USD' CreatedBy = sy-uname CreationTime = lv_timestampl ChangedBy = sy-uname ChangeTime = lv_timestampl MarketCount ='1' )
      ( ProdUuid ='FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0' MrktUuid ='FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFA3' Mrktid ='5'  CountryName ='Germany' ISOCode ='DE' Status ='X' StatusCriticality ='3' Startdate = lv_date Enddate = lv_end_date ItemQuantity ='30000'
        MarketNetamoun ='2100000.00'  MarketGrossamount ='2696400.00'  Amountcurr ='USD' CreatedBy = sy-uname CreationTime = lv_timestampl ChangedBy = sy-uname ChangeTime = lv_timestampl MarketCount ='1' )
      ( ProdUuid ='FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF3' MrktUuid ='FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFA4' Mrktid ='5'  CountryName ='Germany' ISOCode ='DE' Status ='X' StatusCriticality ='3' Startdate = lv_date Enddate = lv_end_date ItemQuantity ='30000'
        MarketNetamoun ='12000000.00' MarketGrossamount ='15408000.00' Amountcurr ='USD' CreatedBy = sy-uname CreationTime = lv_timestampl ChangedBy = sy-uname ChangeTime = lv_timestampl MarketCount ='1' )
      ( ProdUuid ='FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF1' MrktUuid ='FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFA5' Mrktid ='5'  CountryName ='Germany' ISOCode ='DE' Status ='X' StatusCriticality ='3' Startdate = lv_date Enddate = lv_end_date ItemQuantity ='40000'
        MarketNetamoun ='8000000.00'  MarketGrossamount ='10100800.00' Amountcurr ='USD' CreatedBy = sy-uname CreationTime = lv_timestampl ChangedBy = sy-uname ChangeTime = lv_timestampl MarketCount ='1' )
      ( ProdUuid ='FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF3' MrktUuid ='FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFA6' Mrktid ='4'  CountryName ='France'  ISOCode ='FR' Status ='X' StatusCriticality ='3' Startdate = lv_date Enddate = lv_end_date ItemQuantity ='4000'
        MarketNetamoun ='1600000.00'  MarketGrossamount ='2054400.00'  Amountcurr ='USD' CreatedBy = sy-uname CreationTime = lv_timestampl ChangedBy = sy-uname ChangeTime = lv_timestampl MarketCount ='1' )
      ( ProdUuid ='FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0' MrktUuid ='FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFA7' Mrktid ='4'  CountryName ='France'  ISOCode ='FR' Status ='X' StatusCriticality ='3' Startdate = lv_date Enddate = lv_end_date ItemQuantity ='9840'
        MarketNetamoun ='688800.00'   MarketGrossamount ='884419.20'   Amountcurr ='USD' CreatedBy = sy-uname CreationTime = lv_timestampl ChangedBy = sy-uname ChangeTime = lv_timestampl MarketCount ='1' )
      ( ProdUuid ='FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF2' MrktUuid ='FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFA8' Mrktid ='10' CountryName ='Spain'   ISOCode ='ES' Status ='X' StatusCriticality ='3' Startdate = lv_date Enddate = lv_end_date ItemQuantity ='6000'
        MarketNetamoun ='300000.00'   MarketGrossamount ='353100.00'   Amountcurr ='USD' CreatedBy = sy-uname CreationTime = lv_timestampl ChangedBy = sy-uname ChangeTime = lv_timestampl MarketCount ='1' )
      ( ProdUuid ='FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF1' MrktUuid ='FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFA9' Mrktid ='10' CountryName ='Spain'   ISOCode ='ES' Status ='X' StatusCriticality ='3' Startdate = lv_date Enddate = lv_end_date ItemQuantity ='21000'
        MarketNetamoun ='4200000.00'  MarketGrossamount ='5302920.00'  Amountcurr ='USD' CreatedBy = sy-uname CreationTime = lv_timestampl ChangedBy = sy-uname ChangeTime = lv_timestampl MarketCount ='1' )
      ( ProdUuid ='FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF3' MrktUuid ='FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFAA' Mrktid ='10' CountryName ='Spain'   ISOCode ='ES' Status ='X' StatusCriticality ='3' Startdate = lv_date Enddate = lv_end_date ItemQuantity ='5000'
        MarketNetamoun ='2000000.00'  MarketGrossamount ='2568000.00'  Amountcurr ='USD' CreatedBy = sy-uname CreationTime = lv_timestampl ChangedBy = sy-uname ChangeTime = lv_timestampl MarketCount ='1' )
      ( ProdUuid ='FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0' MrktUuid ='FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFAB' Mrktid ='10' CountryName ='Spain'   ISOCode ='ES' Status ='X' StatusCriticality ='3' Startdate = lv_date Enddate = lv_end_date ItemQuantity ='13100'
        MarketNetamoun ='917000.00'  MarketGrossamount ='1172784.20'   Amountcurr ='USD' CreatedBy = sy-uname CreationTime = lv_timestampl ChangedBy = sy-uname ChangeTime = lv_timestampl MarketCount ='1' )
                      ).
* ---- check inserted entries
    cds_test_environment->insert_test_data( i_data = lt_markets ).
    SELECT * FROM zpip_i_market INTO TABLE @DATA(act_markets). "#EC CI_ALL_FIELDS_NEEDED
    cl_abap_unit_assert=>assert_equals( msg = 'Market data insert error'
                                        act = act_markets   " Actual Value
                                        exp = lt_markets ). " Expected Value

* ---- Set test data for 'zpip_i_order'
    DATA(lv_delivDate) = lv_date + 100.
    TYPES: tt_orders  TYPE STANDARD TABLE OF zpip_i_order WITH DEFAULT KEY.
    DATA: lt_orders  TYPE tt_orders.
    lt_orders = VALUE #(
 ( ProdUuid ='FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0' MrktUuid ='FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFAB' OrderUuid ='FFFFFFFFFFFFFFFFFFFFFFFFFFFFF0AB' Orderid ='1'  Quantity ='100'    CalendarYear ='2022'
    DeliveryDate = lv_delivDate Netamount ='7000.00'     Grossamount ='8838.20'     Amountcurr ='USD' BusinessPartner ='17300082'   BusinessPartnerName ='Domestic US Supplier (Ariba Sourcing 2)'
    BusinessPartnerGroup ='BP03' CreatedBy = sy-uname CreationTime = lv_timestampl ChangedBy = sy-uname ChangeTime = lv_chg_timestampl OrderCount ='1'  )
 ( ProdUuid ='FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0' MrktUuid ='FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFAB' OrderUuid ='FFFFFFFFFFFFFFFFFFFFFFFFFFFFF1AB' Orderid ='2'  Quantity ='3000'   CalendarYear ='2022'
    DeliveryDate = lv_delivDate Netamount ='210000.00'   Grossamount ='265146.00'   Amountcurr ='USD' BusinessPartner ='11300001'   BusinessPartnerName ='Domestic GB Supplier 1'
    BusinessPartnerGroup ='BP03' CreatedBy = sy-uname CreationTime = lv_timestampl ChangedBy = sy-uname ChangeTime = lv_chg_timestampl OrderCount ='1'  )
 ( ProdUuid ='FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0' MrktUuid ='FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFAB' OrderUuid ='FFFFFFFFFFFFFFFFFFFFFFFFFFFFF2AB' Orderid ='0'   Quantity ='10000'  CalendarYear ='2022'
    DeliveryDate = lv_delivDate Netamount ='700000.00'   Grossamount ='898800.00'   Amountcurr ='USD' BusinessPartner ='10100002'   BusinessPartnerName ='Inlandskunde DE 2'
    BusinessPartnerGroup ='BP03' CreatedBy = sy-uname CreationTime = lv_timestampl ChangedBy = sy-uname ChangeTime = lv_chg_timestampl OrderCount ='1'  )
 ( ProdUuid ='FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0' MrktUuid ='FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFA7' OrderUuid ='FFFFFFFFFFFFFFFFFFFFFFFFFFFFF0A7' Orderid ='1'  Quantity ='4000'   CalendarYear ='2022'
    DeliveryDate = lv_delivDate Netamount ='280000.00'   Grossamount ='359520.00'   Amountcurr ='USD' BusinessPartner ='17300001'   BusinessPartnerName ='Domestic US Supplier 1'
    BusinessPartnerGroup ='BP03' CreatedBy = sy-uname CreationTime = lv_timestampl ChangedBy = sy-uname ChangeTime = lv_chg_timestampl OrderCount ='1'  )
 ( ProdUuid ='FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0' MrktUuid ='FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFA7' OrderUuid ='FFFFFFFFFFFFFFFFFFFFFFFFFFFFF1A7' Orderid ='2'  Quantity ='540'    CalendarYear ='2022'
    DeliveryDate = lv_delivDate Netamount ='37800.00'    Grossamount ='48535.20'    Amountcurr ='USD' BusinessPartner ='9980000049' BusinessPartnerName ='Priya Bandhav'
    BusinessPartnerGroup ='BPEE' CreatedBy = sy-uname CreationTime = lv_timestampl ChangedBy = sy-uname ChangeTime = lv_chg_timestampl OrderCount ='1'  )
 ( ProdUuid ='FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF2' MrktUuid ='FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFA8' OrderUuid ='FFFFFFFFFFFFFFFFFFFFFFFFFFFFF0A8' Orderid ='1'  Quantity ='1000'   CalendarYear ='2022'
    DeliveryDate = lv_delivDate Netamount ='50000.00'    Grossamount ='58850.00'    Amountcurr ='USD' BusinessPartner ='30100004'   BusinessPartnerName ='Domestic Customer AU 4'
    BusinessPartnerGroup ='BP03' CreatedBy = sy-uname CreationTime = lv_timestampl ChangedBy = sy-uname ChangeTime = lv_chg_timestampl OrderCount ='1'  )
 ( ProdUuid ='FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0' MrktUuid ='FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFA7' OrderUuid ='FFFFFFFFFFFFFFFFFFFFFFFFFFFFF2A7' Orderid ='4'  Quantity ='2000'   CalendarYear ='2023'
    DeliveryDate = lv_delivDate Netamount ='140000.00'   Grossamount ='179760.00'   Amountcurr ='USD' BusinessPartner ='1000014'    BusinessPartnerName ='Inlandskunde DE 22Pavel Belski (S4)'
    BusinessPartnerGroup ='BP02' CreatedBy = sy-uname CreationTime = lv_timestampl ChangedBy = sy-uname ChangeTime = lv_chg_timestampl OrderCount ='1'  )
 ( ProdUuid ='FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0' MrktUuid ='FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFA7' OrderUuid ='FFFFFFFFFFFFFFFFFFFFFFFFFFFFF3A7' Orderid ='3'  Quantity ='2000'   CalendarYear ='2023'
    DeliveryDate = lv_delivDate Netamount ='140000.00'   Grossamount ='179760.00'   Amountcurr ='USD' BusinessPartner ='11300003'   BusinessPartnerName ='Domestic GB Supplier 3 (with ERS)'
    BusinessPartnerGroup ='BP03' CreatedBy = sy-uname CreationTime = lv_timestampl ChangedBy = sy-uname ChangeTime = lv_chg_timestampl OrderCount ='1'  )
 ( ProdUuid ='FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0' MrktUuid ='FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFA7' OrderUuid ='FFFFFFFFFFFFFFFFFFFFFFFFFFFFF4A7' Orderid ='5'  Quantity ='1300'   CalendarYear ='2023'
    DeliveryDate = lv_delivDate Netamount ='91000.00'    Grossamount ='116844.00'   Amountcurr ='USD' BusinessPartner ='9980000030' BusinessPartnerName ='Chamdeep Mudigolam'
    BusinessPartnerGroup ='BPEE' CreatedBy = sy-uname CreationTime = lv_timestampl ChangedBy = sy-uname ChangeTime = lv_chg_timestampl OrderCount ='1'  )
 ( ProdUuid ='FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF2' MrktUuid ='FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFA2' OrderUuid ='FFFFFFFFFFFFFFFFFFFFFFFFFFFFF0A2' Orderid ='1'  Quantity ='4000'   CalendarYear ='2023'
    DeliveryDate = lv_delivDate Netamount ='200000.00'   Grossamount ='235400.00'   Amountcurr ='USD' BusinessPartner ='9980000063' BusinessPartnerName ='Abhinav Singh'
    BusinessPartnerGroup ='BPEE' CreatedBy = sy-uname CreationTime = lv_timestampl ChangedBy = sy-uname ChangeTime = lv_chg_timestampl OrderCount ='1'  )
 ( ProdUuid ='FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF2' MrktUuid ='FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFA2' OrderUuid ='FFFFFFFFFFFFFFFFFFFFFFFFFFFFF1A2' Orderid ='2'  Quantity ='3000'   CalendarYear ='2023'
    DeliveryDate = lv_delivDate Netamount ='150000.00'   Grossamount ='176550.00'   Amountcurr ='USD' BusinessPartner ='9980000074' BusinessPartnerName ='Zeba Parveen'
    BusinessPartnerGroup ='BPEE' CreatedBy = sy-uname CreationTime = lv_timestampl ChangedBy = sy-uname ChangeTime = lv_chg_timestampl OrderCount ='1'  )
 ( ProdUuid ='FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF2' MrktUuid ='FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFA2' OrderUuid ='FFFFFFFFFFFFFFFFFFFFFFFFFFFFF2A2' Orderid ='3'  Quantity ='25000'  CalendarYear ='2023'
    DeliveryDate = lv_delivDate Netamount ='1250000.00'  Grossamount ='1471250.00'  Amountcurr ='USD' BusinessPartner ='10910005'   BusinessPartnerName ='Alina Müller'
    BusinessPartnerGroup ='BP03' CreatedBy = sy-uname CreationTime = lv_timestampl ChangedBy = sy-uname ChangeTime = lv_chg_timestampl OrderCount ='1'  )
 ( ProdUuid ='FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF2' MrktUuid ='FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFA8' OrderUuid ='FFFFFFFFFFFFFFFFFFFFFFFFFFFFF1A8' Orderid ='2'  Quantity ='5000'   CalendarYear ='2022'
    DeliveryDate = lv_delivDate Netamount ='250000.00'   Grossamount ='294250.00'   Amountcurr ='USD' BusinessPartner ='1000014'    BusinessPartnerName ='Inlandskunde DE 22Pavel Belski (S4)'
    BusinessPartnerGroup ='BP02' CreatedBy = sy-uname CreationTime = lv_timestampl ChangedBy = sy-uname ChangeTime = lv_chg_timestampl OrderCount ='1'  )
 ( ProdUuid ='FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF2' MrktUuid ='FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFA2' OrderUuid ='FFFFFFFFFFFFFFFFFFFFFFFFFFFFF3A2' Orderid ='4'  Quantity ='67000'  CalendarYear ='2022'
    DeliveryDate = lv_delivDate Netamount ='3350000.00'  Grossamount ='3942950.00'  Amountcurr ='USD' BusinessPartner ='11101011'   BusinessPartnerName ='Domestic GB Customer 11'
    BusinessPartnerGroup ='BP03' CreatedBy = sy-uname CreationTime = lv_timestampl ChangedBy = sy-uname ChangeTime = lv_chg_timestampl OrderCount ='1'  )
 ( ProdUuid ='FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF2' MrktUuid ='FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFA2' OrderUuid ='FFFFFFFFFFFFFFFFFFFFFFFFFFFFF4A2' Orderid ='5'  Quantity ='3000'   CalendarYear ='2023'
    DeliveryDate = lv_delivDate Netamount ='150000.00'   Grossamount ='176550.00'   Amountcurr ='USD' BusinessPartner ='17300034'   BusinessPartnerName ='Domestic US Supplier 1099K Withholding T'
    BusinessPartnerGroup ='BP03' CreatedBy = sy-uname CreationTime = lv_timestampl ChangedBy = sy-uname ChangeTime = lv_chg_timestampl OrderCount ='1'  )
 ( ProdUuid ='FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF2' MrktUuid ='FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFA2' OrderUuid ='FFFFFFFFFFFFFFFFFFFFFFFFFFFFF5A2' Orderid ='6'  Quantity ='2000'   CalendarYear ='2023'
    DeliveryDate = lv_delivDate Netamount ='100000.00'   Grossamount ='117700.00'   Amountcurr ='USD' BusinessPartner ='9980000000' BusinessPartnerName ='Emre Caglar'
    BusinessPartnerGroup ='BPEE' CreatedBy = sy-uname CreationTime = lv_timestampl ChangedBy = sy-uname ChangeTime = lv_chg_timestampl OrderCount ='1'  )
 ( ProdUuid ='FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF2' MrktUuid ='FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFA2' OrderUuid ='FFFFFFFFFFFFFFFFFFFFFFFFFFFFF6A2' Orderid ='7'  Quantity ='2000'   CalendarYear ='2024'
    DeliveryDate = lv_delivDate Netamount ='100000.00'   Grossamount ='117700.00'   Amountcurr ='USD' BusinessPartner ='10100050'   BusinessPartnerName ='Ausländischer Kunde 50 (US)'
    BusinessPartnerGroup ='BP03' CreatedBy = sy-uname CreationTime = lv_timestampl ChangedBy = sy-uname ChangeTime = lv_chg_timestampl OrderCount ='1'  )
 ( ProdUuid ='FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF2' MrktUuid ='FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFA2' OrderUuid ='FFFFFFFFFFFFFFFFFFFFFFFFFFFFF7A2' Orderid ='8'  Quantity ='2000'   CalendarYear ='2024'
    DeliveryDate = lv_delivDate Netamount ='100000.00'   Grossamount ='117700.00'   Amountcurr ='USD' BusinessPartner ='17910005'   BusinessPartnerName ='Susan Miller'
    BusinessPartnerGroup ='BP03' CreatedBy = sy-uname CreationTime = lv_timestampl ChangedBy = sy-uname ChangeTime = lv_chg_timestampl OrderCount ='1'  )
 ( ProdUuid ='FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF2' MrktUuid ='FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFA2' OrderUuid ='FFFFFFFFFFFFFFFFFFFFFFFFFFFFF8A2' Orderid ='9'  Quantity ='3000'   CalendarYear ='2024'
    DeliveryDate = lv_delivDate Netamount ='150000.00'   Grossamount ='176550.00'   Amountcurr ='USD' BusinessPartner ='10100005'   BusinessPartnerName ='Inlandskunde DE 5 (CMS)'
    BusinessPartnerGroup ='BP03' CreatedBy = sy-uname CreationTime = lv_timestampl ChangedBy = sy-uname ChangeTime = lv_chg_timestampl OrderCount ='1'  )
 ( ProdUuid ='FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF2' MrktUuid ='FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFA2' OrderUuid ='FFFFFFFFFFFFFFFFFFFFFFFFFFFFF9A2' Orderid ='10' Quantity ='4000'   CalendarYear ='2024'
    DeliveryDate = lv_delivDate Netamount ='200000.00'   Grossamount ='235400.00'   Amountcurr ='USD' BusinessPartner ='9980000011' BusinessPartnerName ='Diego Armiliato'
    BusinessPartnerGroup ='BPEE' CreatedBy = sy-uname CreationTime = lv_timestampl ChangedBy = sy-uname ChangeTime = lv_chg_timestampl OrderCount ='1'  )
 ( ProdUuid ='FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF1' MrktUuid ='FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFA1' OrderUuid ='FFFFFFFFFFFFFFFFFFFFFFFFFFFFF0A1' Orderid ='1'  Quantity ='30000'  CalendarYear ='2022'
    DeliveryDate = lv_delivDate  Netamount ='6000000.00'  Grossamount ='7575600.00'  Amountcurr ='USD' BusinessPartner ='11300081'   BusinessPartnerName ='Domestic GB Supplier (Ariba Sourcing 1)'
    BusinessPartnerGroup ='BP03' CreatedBy = sy-uname CreationTime = lv_timestampl ChangedBy = sy-uname ChangeTime = lv_chg_timestampl OrderCount ='1'  )
 ( ProdUuid ='FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF1' MrktUuid ='FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFA1' OrderUuid ='FFFFFFFFFFFFFFFFFFFFFFFFFFFFF1A1' Orderid ='2'  Quantity ='50000'  CalendarYear ='2022'
    DeliveryDate = lv_delivDate Netamount ='10000000.00' Grossamount ='12626000.00' Amountcurr ='USD' BusinessPartner ='9980000073' BusinessPartnerName ='Nandini Chakraborty'
    BusinessPartnerGroup ='BPEE' CreatedBy = sy-uname CreationTime = lv_timestampl ChangedBy = sy-uname ChangeTime = lv_chg_timestampl OrderCount ='1'  )
 ( ProdUuid ='FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF1' MrktUuid ='FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFA1' OrderUuid ='FFFFFFFFFFFFFFFFFFFFFFFFFFFFF2A1' Orderid ='3'  Quantity ='29000'  CalendarYear ='2023'
    DeliveryDate = lv_delivDate Netamount ='5800000.00'  Grossamount ='7323080.00'  Amountcurr ='USD' BusinessPartner ='17100081'   BusinessPartnerName ='Domestic US Customer 81'
    BusinessPartnerGroup ='BP03' CreatedBy = sy-uname CreationTime = lv_timestampl ChangedBy = sy-uname ChangeTime = lv_chg_timestampl OrderCount ='1'  )
 ( ProdUuid ='FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF1' MrktUuid ='FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFA1' OrderUuid ='FFFFFFFFFFFFFFFFFFFFFFFFFFFFF3A1' Orderid ='4'  Quantity ='3000'   CalendarYear ='2023'
    DeliveryDate = lv_delivDate Netamount ='600000.00'   Grossamount ='757560.00'   Amountcurr ='USD' BusinessPartner ='10100050'   BusinessPartnerName ='Ausländischer Kunde 50 (US)'
    BusinessPartnerGroup ='BP03' CreatedBy = sy-uname CreationTime = lv_timestampl ChangedBy = sy-uname ChangeTime = lv_chg_timestampl OrderCount ='1'  )
 ( ProdUuid ='FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF1' MrktUuid ='FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFA9' OrderUuid ='FFFFFFFFFFFFFFFFFFFFFFFFFFFFF0A9' Orderid ='1'  Quantity ='5000'   CalendarYear ='2022'
    DeliveryDate = lv_delivDate Netamount ='1000000.00'  Grossamount ='1262600.00'  Amountcurr ='USD' BusinessPartner ='1000060'    BusinessPartnerName ='Domestic US Customer 1'
    BusinessPartnerGroup ='BP02' CreatedBy = sy-uname CreationTime = lv_timestampl ChangedBy = sy-uname ChangeTime = lv_chg_timestampl OrderCount ='1'  )
 ( ProdUuid ='FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF1' MrktUuid ='FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFA9' OrderUuid ='FFFFFFFFFFFFFFFFFFFFFFFFFFFFF2A9' Orderid ='2'  Quantity ='4000'   CalendarYear ='2022'
    DeliveryDate = lv_delivDate Netamount ='800000.00'   Grossamount ='1010080.00'  Amountcurr ='USD' BusinessPartner ='30100050'   BusinessPartnerName ='Foreign Customer 50 (DE)'
    BusinessPartnerGroup ='BP03' CreatedBy = sy-uname CreationTime = lv_timestampl ChangedBy = sy-uname ChangeTime = lv_chg_timestampl OrderCount ='1'  )
 ( ProdUuid ='FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF1' MrktUuid ='FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFA9' OrderUuid ='FFFFFFFFFFFFFFFFFFFFFFFFFFFFF3A9' Orderid ='3'  Quantity ='7000'   CalendarYear ='2022'
    DeliveryDate = lv_delivDate Netamount ='1400000.00'  Grossamount ='1767640.00'  Amountcurr ='USD' BusinessPartner ='9980000077' BusinessPartnerName ='Vishal Gupta'
    BusinessPartnerGroup ='BPEE' CreatedBy = sy-uname CreationTime = lv_timestampl ChangedBy = sy-uname ChangeTime = lv_chg_timestampl OrderCount ='1'  )
 ( ProdUuid ='FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF1' MrktUuid ='FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFA9' OrderUuid ='FFFFFFFFFFFFFFFFFFFFFFFFFFFFF4A9' Orderid ='4'  Quantity ='5000'   CalendarYear ='2023'
    DeliveryDate = lv_delivDate Netamount ='1000000.00'  Grossamount ='1262600.00'  Amountcurr ='USD' BusinessPartner ='17100080'   BusinessPartnerName ='Domestic US Customer 80'
    BusinessPartnerGroup ='BP03' CreatedBy = sy-uname CreationTime = lv_timestampl ChangedBy = sy-uname ChangeTime = lv_chg_timestampl OrderCount ='1'  )
 ( ProdUuid ='FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0' MrktUuid ='FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFA0' OrderUuid ='FFFFFFFFFFFFFFFFFFFFFFFFFFFFF0A0' Orderid ='1'  Quantity ='4880'   CalendarYear ='2022'
    DeliveryDate = lv_delivDate Netamount ='341600.00'   Grossamount ='438614.40'   Amountcurr ='USD' BusinessPartner ='1000010'    BusinessPartnerName =' TST'
    BusinessPartnerGroup ='BP02' CreatedBy = sy-uname CreationTime = lv_timestampl ChangedBy = sy-uname ChangeTime = lv_chg_timestampl OrderCount ='1'  )
 ( ProdUuid ='FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0' MrktUuid ='FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFA0' OrderUuid ='FFFFFFFFFFFFFFFFFFFFFFFFFFFFF1A0' Orderid ='2'  Quantity ='4000'   CalendarYear ='2022'
    DeliveryDate = lv_delivDate Netamount ='280000.00'   Grossamount ='359520.00'   Amountcurr ='USD' BusinessPartner ='9980000011' BusinessPartnerName ='Diego Armiliato'
    BusinessPartnerGroup ='BPEE' CreatedBy = sy-uname CreationTime = lv_timestampl ChangedBy = sy-uname ChangeTime = lv_chg_timestampl OrderCount ='1'  )
 ( ProdUuid ='FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF3' MrktUuid ='FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFAA' OrderUuid ='FFFFFFFFFFFFFFFFFFFFFFFFFFFFF0AA' Orderid ='1'  Quantity ='5000'   CalendarYear ='2022'
    DeliveryDate ='19720101' Netamount ='2000000.00'  Grossamount ='2568000.00'  Amountcurr ='USD' BusinessPartner ='9980000077' BusinessPartnerName ='Vishal Gupta'
    BusinessPartnerGroup ='BPEE' CreatedBy = sy-uname CreationTime = lv_timestampl ChangedBy = sy-uname ChangeTime = lv_chg_timestampl OrderCount ='1'  )
 ( ProdUuid ='FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF3' MrktUuid ='FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFA6' OrderUuid ='FFFFFFFFFFFFFFFFFFFFFFFFFFFFF0A6' Orderid ='1'  Quantity ='4000'   CalendarYear ='2022'
    DeliveryDate = lv_delivDate Netamount ='1600000.00'  Grossamount ='2054400.00'  Amountcurr ='USD' BusinessPartner ='9980000048' BusinessPartnerName ='Priya Bandhav'
    BusinessPartnerGroup ='BPEE' CreatedBy = sy-uname CreationTime = lv_timestampl ChangedBy = sy-uname ChangeTime = lv_chg_timestampl OrderCount ='1'  )
 ( ProdUuid ='FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0' MrktUuid ='FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFA3' OrderUuid ='FFFFFFFFFFFFFFFFFFFFFFFFFFFFF0A3' Orderid ='1'  Quantity ='30000'  CalendarYear ='2022'
    DeliveryDate = lv_delivDate Netamount ='2100000.00'  Grossamount ='2696400.00'  Amountcurr ='USD' BusinessPartner ='9980000072' BusinessPartnerName ='Zeba Parveen'
    BusinessPartnerGroup ='BPEE' CreatedBy = sy-uname CreationTime = lv_timestampl ChangedBy = sy-uname ChangeTime = lv_chg_timestampl OrderCount ='1'  )
 ( ProdUuid ='FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF3' MrktUuid ='FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFA4' OrderUuid ='FFFFFFFFFFFFFFFFFFFFFFFFFFFFF0A4' Orderid ='1'  Quantity ='30000'  CalendarYear ='2022'
    DeliveryDate = lv_delivDate Netamount ='12000000.00' Grossamount ='15408000.00' Amountcurr ='USD' BusinessPartner ='9980000080' BusinessPartnerName ='Tina Yoon'
    BusinessPartnerGroup ='BPEE' CreatedBy = sy-uname CreationTime = lv_timestampl ChangedBy = sy-uname ChangeTime = lv_chg_timestampl OrderCount ='1'  )
 ( ProdUuid ='FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF1' MrktUuid ='FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFA5' OrderUuid ='FFFFFFFFFFFFFFFFFFFFFFFFFFFFF0A5' Orderid ='1'  Quantity ='40000'  CalendarYear ='2022'
    DeliveryDate = lv_delivDate Netamount ='8000000.00'  Grossamount ='10100800.00' Amountcurr ='USD' BusinessPartner ='17100013'   BusinessPartnerName ='Domestic Customer Invoice List'
    BusinessPartnerGroup ='BP03' CreatedBy = sy-uname CreationTime = lv_timestampl ChangedBy = sy-uname ChangeTime = lv_chg_timestampl OrderCount ='1'  )
    ).

* ---- check inserted entries
    cds_test_environment->insert_test_data( i_data = lt_orders ).
    SELECT * FROM zpip_i_order INTO TABLE @DATA(act_orders). "#EC CI_ALL_FIELDS_NEEDED
    cl_abap_unit_assert=>assert_equals( msg = 'Order data insert error'
                                        act = act_orders   " Actual Value
                                        exp = lt_orders ). " Expected Value


* ----{ 1. FOR VALIDATE  | ON SAVE - validateDeliveryDate
    DATA: lt_failed_valDelivDate   TYPE RESPONSE FOR FAILED   LATE zpip_i_product,
          lt_reported_valDelivDate TYPE RESPONSE FOR REPORTED LATE zpip_i_product.

    cut->validateDeliveryDate( EXPORTING keys    = CORRESPONDING #( lt_orders )
                               CHANGING failed   = lt_failed_valDelivDate
                                        reported = lt_reported_valDelivDate ).
* ------ check results
    LOOP AT lt_reported_valDelivDate-order ASSIGNING FIELD-SYMBOL(<fs_reported_orders_dlvDate>)
                                    WHERE %msg IS NOT INITIAL.

      DATA: lt_act_keys_valDelivDate TYPE TABLE FOR VALIDATION zpip_i_product\\order~validatedeliverydate,
            lt_exp_keys_valDelivDate TYPE TABLE FOR VALIDATION zpip_i_product\\order~validatedeliverydate.
      lt_act_keys_valDelivDate = VALUE #( ( ProdUuid  = <fs_reported_orders_dlvDate>-ProdUuid
                                            MrktUuid  = <fs_reported_orders_dlvDate>-MrktUuid
                                            OrderUuid = <fs_reported_orders_dlvDate>-OrderUuid ) ).
      lt_exp_keys_valDelivDate = VALUE #( ( ProdUuid  ='FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF3'       " failed date: 19720101 for row #32
                                            MrktUuid  ='FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFAA'
                                            OrderUuid ='FFFFFFFFFFFFFFFFFFFFFFFFFFFFF0AA' ) ).

      cl_abap_unit_assert=>assert_equals( msg = 'failed-validateDelivDate'
                                          act = lt_act_keys_valDelivDate
                                          exp = lt_exp_keys_valDelivDate ).

    ENDLOOP.
* ----} 1. FOR VALIDATE  | ON SAVE - validateDeliveryDate


* ----{ 2. FOR VALIDATE  | ON SAVE - validateBusinessPartner
    DATA: lt_failed_validateBP   TYPE RESPONSE FOR FAILED LATE zpip_i_product,
          lt_reported_validateBP TYPE RESPONSE FOR REPORTED LATE zpip_i_product.
    cut->validateBusinessPartner( EXPORTING keys    = CORRESPONDING #( lt_orders )
                                  CHANGING failed   = lt_failed_validateBP
                                           reported = lt_reported_validateBP ).
* ------ check results #### DUMMY-implementation since empty method ####
    cl_abap_unit_assert=>assert_equals( msg = 'failed-validateBP'
                                        act = lt_reported_validateBP
                                        exp = lt_reported_validateBP ).
* ----} 2. FOR VALIDATE  | ON SAVE - validateBusinessPartner


* ----{ 3. FOR DETERMINE | ON MODIFY - calculateOrderID
    DATA: lt_keys_calcOrdID     TYPE TABLE FOR DETERMINATION zpip_i_product\\order~calculateorderid,
          lt_reported_calcOrdID TYPE RESPONSE FOR REPORTED LATE zpip_i_product.

    lt_keys_calcOrdID = CORRESPONDING #( VALUE tt_orders( FOR wa_keys_calcOrdID IN lt_orders WHERE ( MrktUuid ='FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFAB' )
                                                          ( wa_keys_calcOrdID ) ) ).

* ------- perform calculation OrderId
    cut->calculateOrderId( EXPORTING keys    = lt_keys_calcOrdID
                           CHANGING reported = lt_reported_calcOrdID ).

* ------ read original value OrgderId for ( MrktUuid ='FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFAB' OrderUuid ='FFFFFFFFFFFFFFFFFFFFFFFFFFFFF2AB' )
    READ ENTITIES OF zpip_i_product IN LOCAL MODE
            ENTITY Market BY \_MarketOrder
              FIELDS ( Orderid ) WITH CORRESPONDING #( lt_keys_calcOrdID )
            RESULT DATA(lt_OrderID_act).
    DATA(ls_OrderID_act) =  CORRESPONDING zpip_i_order( VALUE #( lt_OrderID_act[ MrktUuid  = 'FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFAB'
                                                                                 OrderUuid = 'FFFFFFFFFFFFFFFFFFFFFFFFFFFFF2AB' ] OPTIONAL ) ).
* ------ check results
    cl_abap_unit_assert=>assert_equals( msg = 'failed-validateOrderId'
                                        act = ls_OrderID_act-Orderid
                                        exp = 3  ).
* ----} 3. FOR DETERMINE | ON MODIFY - calculateOrderID

* ----{ 4. FOR DETERMINE | ON SAVE - calculateAmounts
    DATA: lt_keys_calcOrdAmnt     TYPE TABLE FOR DETERMINATION zpip_i_product\\order~calculateamounts,
          lt_reported_calcOrdAmnt TYPE RESPONSE FOR REPORTED LATE zpip_i_product.
    lt_keys_calcOrdAmnt = CORRESPONDING #( VALUE tt_orders( FOR wa_keys_calcOrdAmnt IN lt_orders WHERE ( ProdUuid ='FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF1')
                                                            ( wa_keys_calcOrdAmnt ) ) ).

    cut->calculateamounts( EXPORTING keys     = lt_keys_calcOrdAmnt
                           CHANGING  reported = lt_reported_calcOrdAmnt ).

    READ ENTITIES OF zpip_i_product IN LOCAL MODE
           ENTITY Order
             FIELDS ( Quantity
                      Netamount
                      Grossamount
                      Amountcurr
                      DeliveryDate
                      CalendarYear ) WITH CORRESPONDING #( lt_keys_calcOrdAmnt )
           RESULT DATA(picedOrders).
    DO lines( picedOrders ) TIMES.
      ASSIGN  picedOrders[ sy-index ] TO FIELD-SYMBOL(<fs_priceOrders>).
      CHECK <fs_priceOrders> IS ASSIGNED.

      DATA(lv_exp_year)      = CONV zpip_year( 2023 ).
      DATA(lv_exp_delivDate) = lv_delivdate.
      DATA(lv_exp_amntCurr)  = CONV waers_curc( 'USD' ).

      CASE sy-index.
        WHEN 1.   " OrderUUID = FFFFFFFFFFFFFFFFFFFFFFFFFFFFF0A1
          DATA(lv_exp_netAmnt)   = CONV  zpip_netamount( '33300.00' ).
          DATA(lv_exp_grossAmnt) = CONV  zpip_grossamount( '35987.31' ).

        WHEN 2.   " OrderUUID = FFFFFFFFFFFFFFFFFFFFFFFFFFFFF1A1
          lv_exp_netAmnt   = CONV  zpip_netamount( '55500.00' ).
          lv_exp_grossAmnt = CONV  zpip_grossamount( '59978.85' ).

        WHEN 3.   " OrderUUID = FFFFFFFFFFFFFFFFFFFFFFFFFFFFF2A1
          lv_exp_netAmnt   = CONV  zpip_netamount( '32190.00' ).
          lv_exp_grossAmnt = CONV  zpip_grossamount( '34787.73' ).

        WHEN 4.   " OrderUUID = FFFFFFFFFFFFFFFFFFFFFFFFFFFFF3A1
          lv_exp_netAmnt   = CONV  zpip_netamount( '3330.00' ).
          lv_exp_grossAmnt = CONV  zpip_grossamount( '3598.73' ).

        WHEN 5.   " OrderUUID = FFFFFFFFFFFFFFFFFFFFFFFFFFFFF0A9
          lv_exp_netAmnt   = CONV  zpip_netamount( '5550.00' ).
          lv_exp_grossAmnt = CONV  zpip_grossamount( '5997.89' ).

        WHEN 6.   " OrderUUID = FFFFFFFFFFFFFFFFFFFFFFFFFFFFF2A9
          lv_exp_netAmnt   = CONV  zpip_netamount( '4440.00' ).
          lv_exp_grossAmnt = CONV  zpip_grossamount( '4798.31' ).

        WHEN 7.   " OrderUUID = FFFFFFFFFFFFFFFFFFFFFFFFFFFFF3A9
          lv_exp_netAmnt   = CONV  zpip_netamount( '7770.00' ).
          lv_exp_grossAmnt = CONV  zpip_grossamount( '8397.04' ).

        WHEN 8.   " OrderUUID = FFFFFFFFFFFFFFFFFFFFFFFFFFFFF4A9
          lv_exp_netAmnt   = CONV  zpip_netamount( '5550.00' ).
          lv_exp_grossAmnt = CONV  zpip_grossamount( '5997.89' ).

        WHEN 9.   " OrderUUID = FFFFFFFFFFFFFFFFFFFFFFFFFFFFF0A5
          lv_exp_netAmnt   = CONV  zpip_netamount( '44400.00' ).
          lv_exp_grossAmnt = CONV  zpip_grossamount( '47983.08' ).

        WHEN OTHERS.
          EXIT.
      ENDCASE.

* ------ check results
      cl_abap_unit_assert=>assert_equals( msg = 'failed-validateOrderAmnt-netAmount'
                                          act = <fs_priceOrders>-Netamount
                                          exp = lv_exp_netAmnt  ).
      cl_abap_unit_assert=>assert_equals( msg = 'failed-validateOrderAmnt-grossAmount'
                                          act = <fs_priceOrders>-Grossamount
                                          exp = lv_exp_grossAmnt  ).
      cl_abap_unit_assert=>assert_equals( msg = 'failed-validateOrderAmnt-calendarYear'
                                          act = <fs_priceOrders>-CalendarYear
                                          exp = lv_exp_year  ).
      cl_abap_unit_assert=>assert_equals( msg = 'failed-validateOrderAmnt-deliveryDate'
                                           act = <fs_priceOrders>-DeliveryDate
                                           exp = lv_exp_delivDate  ).
      cl_abap_unit_assert=>assert_equals( msg = 'failed-validateOrderAmnt-amountCurrency'
                                           act = <fs_priceOrders>-Amountcurr
                                           exp = lv_exp_amntCurr ).
      UNASSIGN <fs_priceorders>.
    ENDDO.

* ----} 4. FOR DETERMINE | ON SAVE - calculateAmounts

  ENDMETHOD.
ENDCLASS.
