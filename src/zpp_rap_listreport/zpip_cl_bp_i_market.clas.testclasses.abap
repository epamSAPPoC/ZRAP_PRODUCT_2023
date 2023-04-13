CLASS  ltcl_market  DEFINITION FINAL FOR TESTING
                      DURATION SHORT
                      RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    CLASS-DATA: cut                  TYPE REF TO lhc_market,
                cds_test_environment TYPE REF TO if_cds_test_environment,
                sql_test_environment TYPE REF TO if_osql_test_environment.
* -- Global data
    DATA: mt_d_markets  TYPE STANDARD TABLE OF zpip_d_market.
    DATA: mt_markets    TYPE STANDARD TABLE OF zpip_i_market.
    DATA: mt_products   TYPE STANDARD TABLE OF zpip_i_product.
    DATA: mt_countries  TYPE STANDARD TABLE OF zpip_d_country.

    CLASS-METHODS:
      class_setup,
      class_teardown.
    METHODS:
      setup
        RAISING cx_abap_auth_check_exception,
      teardown,
      check_markets FOR TESTING
        RAISING cx_static_check.
    METHODS:
      init_data.
ENDCLASS.

CLASS  ltcl_market IMPLEMENTATION.

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
*    cds_test_environment = cl_cds_test_environment=>create( i_for_entity ='' ).
    cds_test_environment = cl_cds_test_environment=>create_for_multiple_cds( i_for_entities = VALUE #(  ( i_for_entity ='zpip_c_product' )
                                                                                                        ( i_for_entity ='zpip_c_market'  ) ) ).
    cds_test_environment->enable_double_redirection( ). " ! IMPORTANT !
    sql_test_environment = cl_osql_test_environment=>create( i_dependency_list = VALUE #( ( 'zpip_d_country' )
                                                                                          ( 'zpip_d_market'  ) ) ).
  ENDMETHOD.

  METHOD check_markets.
    TYPES: tt_market  TYPE STANDARD TABLE OF  zpip_i_market WITH DEFAULT KEY.

* ---- Data initialization: mt_markets | mt_products |
    me->init_data( ).

* ---- check inserted entries
    cds_test_environment->insert_test_data( i_data = mt_markets ).
    SELECT * FROM zpip_i_market INTO TABLE @DATA(act_markets). "#EC CI_ALL_FIELDS_NEEDED
    cl_abap_unit_assert=>assert_equals( msg = 'Market data insert error'
                                        act = act_markets   " Actual Value
                                        exp = mt_markets ). " Expected Value

    cds_test_environment->insert_test_data( i_data = mt_products ).
    SELECT * FROM zpip_i_product INTO TABLE @DATA(act_products). "#EC CI_ALL_FIELDS_NEEDED
    cl_abap_unit_assert=>assert_equals( msg = 'Product data insert error'
                                        act = act_products   " Actual Value
                                        exp = mt_products ). " Expected Value

* ------ SQL
    sql_test_environment->insert_test_data( i_data = mt_countries ).
    SELECT * FROM zpip_d_country INTO TABLE @DATA(act_countries). "#EC CI_ALL_FIELDS_NEEDED
    cl_abap_unit_assert=>assert_equals( msg = 'Countries SQL data insert error'
                                        act = act_countries   " Actual Value
                                        exp = mt_countries ). " Expected Value

    sql_test_environment->insert_test_data( i_data = mt_d_markets ).
    SELECT * FROM zpip_d_market INTO TABLE @DATA(act_d_markets). "#EC CI_ALL_FIELDS_NEEDED
    cl_abap_unit_assert=>assert_equals( msg = 'Market SQL data insert error'
                                        act = act_d_markets  " Actual Value
                                        exp = mt_d_markets ). " Expected Value


* ----{ 1. FOR VALIDATE | ON SAVE - validateMarket
    DO 1 TIMES.
      DATA: lt_keys_validateMarket     TYPE TABLE FOR VALIDATION zpip_i_product\\market~validatemarket,
            lt_failed_validateMarket   TYPE RESPONSE FOR FAILED LATE zpip_i_product,
            lt_reported_validateMarket TYPE RESPONSE FOR REPORTED LATE zpip_i_product.
      lt_keys_validateMarket = CORRESPONDING #( VALUE tt_market( FOR wa_market IN mt_markets
                                                                    WHERE ( MrktUuid = 'FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFA0' OR
                                                                            MrktUuid = 'FFFFFFFFFFFFFFFFFFFFFFFFFFFFFEEE' )
                                                                  ( wa_market ) ) ).
      cut->validateMarket( EXPORTING keys     =  lt_keys_validateMarket
                           CHANGING  failed   =  lt_failed_validateMarket
                                     reported =  lt_reported_validateMarket ).
* ------- check results: ver.2.0
      READ TABLE lt_failed_validateMarket-market ASSIGNING FIELD-SYMBOL(<fs_reported_validateMarket>)
                                                      WITH KEY MrktUuid = 'FFFFFFFFFFFFFFFFFFFFFFFFFFFFFEEE'.
      cl_abap_unit_assert=>assert_equals( msg = 'failed-validateMarket'
                                          act = <fs_reported_validateMarket>-MrktUuid
                                          exp = 'FFFFFFFFFFFFFFFFFFFFFFFFFFFFFEEE' ).
* ------- check results: ver.1.0.
*      LOOP AT lt_reported_validatemarket-market ASSIGNING FIELD-SYMBOL(<fs_reported_validateMarket>)
*                                                           WHERE MrktUuid = 'FFFFFFFFFFFFFFFFFFFFFFFFFFFFFEEE' AND
*                                                                 %msg IS BOUND.
*        DATA(lv_failed_marketId) = CONV zpip_market_id( CAST zcx_pip_product( <fs_reported_validateMarket>-%msg )->mrktid ).
*        EXIT.
*      ENDLOOP.
*
*      cl_abap_unit_assert=>assert_equals( msg = 'failed-validateMarket'
*                                          act = lv_failed_marketId
*                                          exp = 'EE' ).

    ENDDO.

* ----} 1. FOR VALIDATE | ON SAVE - validateMarket


* ----{ 2. FOR VALIDATE | ON SAVE - validateStartDate
    DO 1 TIMES.
      DATA:
        lt_keys_validateStrDate     TYPE TABLE FOR VALIDATION zpip_i_product\\market~validatestartdate,
        lt_failed_validateStrDate   TYPE RESPONSE FOR FAILED LATE zpip_i_product,
        lt_reported_validateStrDate TYPE RESPONSE FOR REPORTED LATE zpip_i_product.
      lt_keys_validateStrDate  = CORRESPONDING #( VALUE tt_market( FOR wa_market IN mt_markets
                                                                    WHERE ( MrktUuid = 'FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFA0' OR
                                                                            MrktUuid = 'FFFFFFFFFFFFFFFFFFFFFFFFFFFFFEEE' )
                                                                  ( wa_market ) ) ).


      cut->validateStartDate( EXPORTING  keys     = lt_keys_validateStrDate
                               CHANGING  failed   = lt_failed_validateStrDate
                                         reported = lt_reported_validateStrDate ).
      READ TABLE lt_failed_validateStrDate-market ASSIGNING FIELD-SYMBOL(<fs_reported_validateStrDate>)
                                                      WITH KEY MrktUuid = 'FFFFFFFFFFFFFFFFFFFFFFFFFFFFFEEE'.
      cl_abap_unit_assert=>assert_equals( msg = 'failed-validateMarket'
                                          act = <fs_reported_validateStrDate>-MrktUuid
                                          exp = 'FFFFFFFFFFFFFFFFFFFFFFFFFFFFFEEE' ).

    ENDDO.
* ----{ 2. FOR VALIDATE | ON SAVE - validateStartDate


* ----{ 3. FOR VALIDATE | ON SAVE - validateEndDate
    DO 1 TIMES.
      DATA:
        lt_keys_validateEndDate     TYPE TABLE FOR VALIDATION zpip_i_product\\market~validateenddate,
        lt_failed_validateEndDate   TYPE RESPONSE FOR FAILED LATE zpip_i_product,
        lt_reported_validateEndDate TYPE RESPONSE FOR REPORTED LATE zpip_i_product.

      lt_keys_validateEndDate  = CORRESPONDING #( VALUE tt_market( FOR wa_market IN mt_markets
                                                                    WHERE ( MrktUuid = 'FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFA0' OR
                                                                            MrktUuid = 'FFFFFFFFFFFFFFFFFFFFFFFFFFFFFEEE' )
                                                                  ( wa_market ) ) ).

      cut->validateEndDate( EXPORTING keys     = lt_keys_validateEndDate
                            CHANGING  failed   = lt_failed_validateEndDate
                                      reported = lt_reported_validateEndDate ).
      READ TABLE lt_failed_validateEndDate-market ASSIGNING FIELD-SYMBOL(<fs_reported_validateEndDate>)
                                                      WITH KEY MrktUuid = 'FFFFFFFFFFFFFFFFFFFFFFFFFFFFFEEE'.
      cl_abap_unit_assert=>assert_equals( msg = 'failed-validateMarket'
                                          act = <fs_reported_validateEndDate>-MrktUuid
                                          exp = 'FFFFFFFFFFFFFFFFFFFFFFFFFFFFFEEE' ).
    ENDDO.
* ----} 3. FOR VALIDATE | ON SAVE - validateEndDate


* ----{ 4. FOR VALIDATE | ON SAVE - validateMarketDupl
    DO 1 TIMES.
      DATA:
        lt_keys_validateMarketDupl     TYPE TABLE FOR VALIDATION zpip_i_product\\market~validatemarketdupl,
        lt_failed_validateMarketDupl   TYPE RESPONSE FOR FAILED LATE zpip_i_product,
        lt_reported_validateMarketDupl TYPE RESPONSE FOR REPORTED LATE zpip_i_product.
      lt_keys_validateMarketDupl = CORRESPONDING #( VALUE tt_market( FOR wa_market IN mt_markets
                                                                    WHERE ( MrktUuid = 'FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFA0' OR
                                                                            MrktUuid = 'FFFFFFFFFFFFFFFFFFFFFFFFFFFFFEEE' )
                                                                  ( wa_market ) ) ).


      cut->validateMarketDupl( EXPORTING keys     = lt_keys_validateMarketDupl
                               CHANGING  failed   = lt_failed_validateMarketDupl
                                         reported = lt_reported_validateMarketDupl ).

      LOOP AT lt_keys_validateMarketDupl ASSIGNING FIELD-SYMBOL(<fs_keys_validateMarketDupl>).
        READ TABLE  lt_failed_validateMarketDupl-market WITH KEY MrktUuid = <fs_keys_validateMarketDupl>-MrktUuid
          INTO DATA(ls_failed_validateMarketDupl).
        cl_abap_unit_assert=>assert_equals( msg = 'failed-validateMarket'
                                            act = ls_failed_validateMarketDupl-MrktUuid
                                            exp = <fs_keys_validateMarketDupl>-MrktUuid ).

        CLEAR: ls_failed_validateMarketDupl.
      ENDLOOP.
    ENDDO.
* ----} 4. FOR VALIDATE | ON SAVE - validateMarketDupl


* ----{ 5. FOR MODIFY   | FOR ACTION - confirmMarketStatus
    DO 1 TIMES.
      DATA:
        lt_keys_confMarketSts     TYPE TABLE FOR ACTION IMPORT zpip_i_product\\market~confirmmarketstatus,
        lt_result_confMarketSts   TYPE TABLE FOR ACTION RESULT zpip_i_product\\market~confirmmarketstatus,
        lt_mapped_confMarketSts   TYPE RESPONSE FOR MAPPED EARLY zpip_i_product,
        lt_failed_confMarketSts   TYPE RESPONSE FOR FAILED EARLY zpip_i_product,
        lt_reported_confMarketSts TYPE RESPONSE FOR REPORTED EARLY zpip_i_product.

      lt_keys_confMarketSts = CORRESPONDING #( mt_markets ).
      cut->confirmMarketStatus( EXPORTING keys     = lt_keys_confMarketSts
                                CHANGING  result   = lt_result_confMarketSts
                                          mapped   = lt_mapped_confMarketSts
                                          failed   = lt_failed_confMarketSts
                                          reported = lt_reported_confMarketSts ).
    ENDDO.
* ----} 5. FOR MODIFY   | FOR ACTION - confirmMarketStatus


* ----{ 6. FOR INSTANCE | FEATURES - get_instance_features
    DO 1 TIMES.
      DATA: keys_getInstFeat     TYPE TABLE FOR INSTANCE FEATURES KEY zpip_i_product\\market,
            reqFeat_getInstFeat  TYPE STRUCTURE FOR INSTANCE FEATURES REQUEST zpip_i_product\\market,
            result_getInstFeat   TYPE TABLE FOR INSTANCE FEATURES RESULT zpip_i_product\\market,
            failed_getInstFeat   TYPE RESPONSE FOR FAILED EARLY zpip_i_product,
            reported_getInstFeat TYPE RESPONSE FOR REPORTED EARLY zpip_i_product.

      keys_getInstFeat = CORRESPONDING #( mt_markets ).
      cut->get_instance_features( EXPORTING keys               = keys_getInstFeat
                                            requested_features = reqFeat_getInstFeat
                                  CHANGING  result             = result_getInstFeat
                                            failed             = failed_getInstFeat
                                            reported           = reported_getInstFeat ).
    ENDDO.
* ----} 6. FOR INSTANCE | FEATURES - get_instance_features


* ----{ 7. FOR DETERMINE| ON SAVE  - set_iso_code
    DO 1 TIMES.
      DATA: lt_keys_setIsoCode     TYPE TABLE FOR DETERMINATION zpip_i_product\\market~set_iso_code,
            lt_reported_setIsoCode TYPE RESPONSE FOR REPORTED LATE zpip_i_product.

      lt_keys_setIsoCode = CORRESPONDING #( mt_markets ).
      cut->set_iso_code( EXPORTING keys     = lt_keys_setIsoCode
                         CHANGING  reported = lt_reported_setIsoCode ).
    ENDDO.
* ----} 7. FOR DETERMINE| ON SAVE  - set_iso_code

  ENDMETHOD.

  METHOD init_data.
* ---- Set test data for'zpip_i_market'
    DATA(lv_time) = sy-uzeit.
    DATA(lv_date) = sy-datum.
    DATA(lv_end_date) = lv_date + 365.
    DATA: lv_timestampl TYPE timestampl.
    GET TIME STAMP FIELD  lv_timestampl.

    mt_markets = VALUE #(
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
* ------ Error Entry
      ( ProdUuid ='FFFFFFFFFFFFFFFFFFFFFFFFFFFFFEEE' MrktUuid ='FFFFFFFFFFFFFFFFFFFFFFFFFFFFFEEE'
        Mrktid    ='EE'          CountryName ='Error'   ISOCode ='ER' Status ='X' StatusCriticality ='0'
        Startdate = lv_date - 10 Enddate = lv_date - 20  ItemQuantity ='99900'
        MarketNetamoun ='999900.00'  MarketGrossamount ='99999.20'   Amountcurr ='ERR' CreatedBy = sy-uname CreationTime = lv_timestampl ChangedBy = sy-uname ChangeTime = lv_timestampl MarketCount ='1' )
                      ).

* ---- Set test data for 'zpip_d_markets'

    mt_d_markets = CORRESPONDING #( mt_markets MAPPING prod_uuid = ProdUuid  mrkt_uuid = MrktUuid  mrktid = Mrktid  startdate = Startdate  enddate = Enddate  isocode = ISOCode
                                                       created_by = CreatedBy creation_time = CreationTime changed_by = ChangedBy change_time = ChangeTime ).
    MODIFY mt_d_markets FROM VALUE #( client = sy-mandt ) TRANSPORTING client  WHERE client IS INITIAL.

* ---- Set test data for 'zpip_i_product'
    mt_products = VALUE #(
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
      ( ProdUuid     = 'FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF11'   prodid    = 'A-11' pgid       = '001'
        phaseid      = 1           height = 11  depth = 11  width     = 11     SizeUom    = 'CM'
        price        = '11.11'     PriceCurrency = 'USD'    taxrate   = '1'    taxisocode = 'A1'
        CreationTime = '000011'    )
      ( ProdUuid     = 'FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF22'   prodid    = 'B-22' pgid       = '002'
        phaseid      = 2           height = 22  depth = 22  width     = 22     SizeUom    = 'CM'
        price        = '22.22'     PriceCurrency = 'USD'    taxrate   = '2'    taxisocode = 'B2'
        CreationTime = '000022'     )
      ( ProdUuid     = 'FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF33'   prodid    = 'C-33' pgid       = '003'
        phaseid      = 3           height = 33  depth = 33  width     = 33     SizeUom    = 'CM'
        price        = '33.33'     PriceCurrency = 'USD'    taxrate   = '3'    taxisocode = 'C3'
        CreationTime = '000033'     )
      ( ProdUuid     = 'FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF44'   prodid    = 'D-44' pgid       = '004'
        phaseid      = 4           height = 44  depth = 44  width     = 44     SizeUom    = 'CM'
        price        = '44.44'     PriceCurrency = 'USD'    taxrate   = '4'    taxisocode = 'D4'
        CreationTime = '000044'     )
* ------ Error Entry
      ( ProdUuid     = 'FFFFFFFFFFFFFFFFFFFFFFFFFFFFFEEE'   prodid    = 'ERR'  pgid       = 'ERR'
        phaseid      = 9           height = 99  depth = 99  width     = 99     SizeUom    = 'CM'
        price        = '999.99'    PriceCurrency = 'ERR'    taxrate   = '9'    taxisocode = 'E9'
        CreationTime = '000059'     )
      ).

    mt_countries = VALUE #(
     ( client = sy-mandt mrktid = '1'  country = 'Russia'         code = 'RU' imageurl = 'https://cdn.webshopapp.com/shops/94414/files/54940426/russia-flag-image-free-download.jpg'  )
     ( client = sy-mandt mrktid = '2'  country = 'Belarus'        code = 'RU' imageurl = 'https://cdn.countryflags.com/thumbs/belarus/flag-400.png'  )
     ( client = sy-mandt mrktid = '3'  country = 'United Kingdom' code = 'EN' imageurl = 'https://upload.wikimedia.org/wikipedia/commons/thumb/a/ae/Flag_of_the_United_Kingdom.svg/640px-Flag_of_the_United_Kingdom.svg.png'  )
     ( client = sy-mandt mrktid = '4'  country = 'France'         code = 'FR' imageurl = 'https://cdn.webshopapp.com/shops/94414/files/54002660/france-flag-image-free-download.jpg'  )
     ( client = sy-mandt mrktid = '5'  country = 'Germany'        code = 'DE' imageurl = 'https://cdn.webshopapp.com/shops/94414/files/54006402/germany-flag-image-free-download.jpg'  )
     ( client = sy-mandt mrktid = '6'  country = 'Italy'          code = 'IT' imageurl = 'https://cdn.countryflags.com/thumbs/italy/flag-400.png'  )
     ( client = sy-mandt mrktid = '7'  country = 'USA'            code = 'EN' imageurl = 'https://cdn.webshopapp.com/shops/94414/files/54958906/the-united-states-flag-image-free-download.jpg'  )
     ( client = sy-mandt mrktid = '8'  country = 'Japan'          code = 'EN' imageurl = 'https://image.freepik.com/free-vector/illustration-japan-flag_53876-27128.jpg'  )
     ( client = sy-mandt mrktid = '9'  country = 'Poland'         code = 'EN' imageurl = 'https://cdn.webshopapp.com/shops/94414/files/54940016/poland-flag-image-free-download.jpg'  )
     ( client = sy-mandt mrktid = '10' country = 'Spain'          code = 'ES' imageurl = 'https://cdn.webshopapp.com/shops/94414/files/54940016/poland-flag-image-free-download.jpg'  )
   ).

  ENDMETHOD.
ENDCLASS.
