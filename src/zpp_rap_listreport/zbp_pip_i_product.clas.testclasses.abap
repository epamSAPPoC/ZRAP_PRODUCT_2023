* use this source file for your ABAP unit test classes
CLASS  ltcl_products  DEFINITION FINAL FOR TESTING
                      DURATION SHORT
                      RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    CLASS-DATA: cut                  TYPE REF TO lhc_product,
                cds_test_environment TYPE REF TO if_cds_test_environment,
                sql_test_environment TYPE REF TO if_osql_test_environment.
    CLASS-METHODS:
      class_setup,
      class_teardown.
    METHODS:
      setup
        RAISING cx_abap_auth_check_exception,
      teardown,
      check_products FOR TESTING
        RAISING cx_static_check.

ENDCLASS.

CLASS  ltcl_products IMPLEMENTATION.

  METHOD class_setup.
    CREATE OBJECT cut FOR TESTING.
*    cds_test_environment = cl_cds_test_environment=>create( i_for_entity = 'zpip_c_product' ).
    cds_test_environment = cl_cds_test_environment=>create_for_multiple_cds( i_for_entities = VALUE #( ( i_for_entity = 'zpip_c_product' )
                                                                                                       ( i_for_entity = 'zpip_c_market'  ) ) ).
    cds_test_environment->enable_double_redirection( ). " ! IMPORTANT !
    sql_test_environment = cl_osql_test_environment=>create( i_dependency_list = VALUE #( ( 'zpip_d_prod_grp' )
                                                                                          ( 'zpip_d_country' ) ) ).
  ENDMETHOD.

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

  METHOD check_products.

* == initialization of Test data to add
    DATA: lv_timestampl TYPE timestampl.
    GET TIME STAMP FIELD  lv_timestampl.
    DATA(lv_time) = sy-uzeit.
    DATA(lv_date) = sy-datum.

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
    cl_abap_unit_assert=>assert_equals( msg = 'Projects insert error'
                                        act = act_products   " Actual Value
                                        exp = lt_products ). " Expected Value


* ---- Set test data for 'zpip_d_prod_grp' via 'zpip_i_prod_gr'
    DATA: lt_prod_gr  TYPE STANDARD TABLE OF zpip_i_prod_gr,
          lt_prod_grp TYPE STANDARD TABLE OF zpip_d_prod_grp.
    lt_prod_grp = VALUE #( client = sy-mandt ( pgid ='001' pgname ='Microwave'      imageurl ='https://001.svg' )
                                             ( pgid ='002' pgname ='Coffee Machine' imageurl ='https://002.svg' )
                                             ( pgid ='003' pgname ='Waffle Iron'    imageurl ='https://003.svg' )
                                             ( pgid ='004' pgname ='Blender'        imageurl ='https://004.png' )
                                             ( pgid ='005' pgname ='Cooker'         imageurl ='https://005.svg' )
                         ).
    lt_prod_gr = CORRESPONDING #( lt_prod_grp ).
* ---- check inserted entries
* ------ 'zpip_d_prod_grp'
    sql_test_environment->insert_test_data( i_data = lt_prod_grp ).
    SELECT * FROM zpip_d_prod_grp INTO TABLE @DATA(act_prod_grp). "#EC CI_ALL_FIELDS_NEEDED
    cl_abap_unit_assert=>assert_equals( msg = 'Project Groups DB-insert error'
                                        act = act_prod_grp   " Actual Value
                                        exp = lt_prod_grp ). " Expected Value
* ------ 'zpip_i_prod_gr'
    cds_test_environment->insert_test_data( i_data = lt_prod_gr ).
    SELECT * FROM zpip_i_prod_gr INTO TABLE @DATA(act_prod_gr). "#EC CI_ALL_FIELDS_NEEDED
    cl_abap_unit_assert=>assert_equals( msg = 'Project Groups projection insert error'
                                        act = act_prod_gr   " Actual Value
                                        exp = lt_prod_gr ). " Expected Value

* ---- Set test data for 'zpip_i_market'
    DATA: lt_prod_market  TYPE STANDARD TABLE OF zpip_i_market.
    lt_prod_market = VALUE #( Startdate = lv_date  Enddate = lv_date + 10 CreatedBy = sy-uname  CreationTime = lv_timestampl
                                                                          ChangedBy = sy-uname  ChangeTime   = lv_timestampl
      ( ProdUuid ='FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF1' MrktUuid ='FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFA0'
          Mrktid ='10' CountryName ='Spain'   ISOCode ='ES' Status ='X' StatusCriticality ='3' ItemQuantity ='10' MarketNetamoun ='00.01' MarketGrossamount ='00.02' Amountcurr ='USD' MarketCount ='1' )
      ( ProdUuid ='FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF1' MrktUuid ='FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFA1'
          Mrktid ='5'  CountryName ='Germany' ISOCode ='DE' Status ='X' StatusCriticality ='3' ItemQuantity ='11' MarketNetamoun ='01.01' MarketGrossamount ='01.02' Amountcurr ='USD' MarketCount ='1' )
      ( ProdUuid ='FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF1' MrktUuid ='FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFA2'
          Mrktid ='7'  CountryName ='USA'     ISOCode =''   Status ='X' StatusCriticality ='3' ItemQuantity ='12' MarketNetamoun ='02.01' MarketGrossamount ='02.02' Amountcurr ='USD' MarketCount ='1' )
      ( ProdUuid ='FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF2' MrktUuid ='FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFA3'
          Mrktid ='4'  CountryName ='France'  ISOCode ='FR' Status ='X' StatusCriticality ='3' ItemQuantity ='13' MarketNetamoun ='03.01' MarketGrossamount ='03.02' Amountcurr ='USD' MarketCount ='1' )
      ( ProdUuid ='FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF2' MrktUuid ='FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFA4'
          Mrktid ='7'  CountryName ='USA'     ISOCode =''   Status ='X' StatusCriticality ='3' ItemQuantity ='14' MarketNetamoun ='04.01' MarketGrossamount ='04.02' Amountcurr ='USD' MarketCount ='1' )
      ( ProdUuid ='FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF2' MrktUuid ='FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFA5'
          Mrktid ='5'  CountryName ='Germany' ISOCode ='DE' Status ='X' StatusCriticality ='3' ItemQuantity ='15' MarketNetamoun ='05.01' MarketGrossamount ='05.02' Amountcurr ='USD' MarketCount ='1' )
      ( ProdUuid ='FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF2' MrktUuid ='FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFA6'
          Mrktid ='10' CountryName ='Spain'   ISOCode ='ES' Status ='X' StatusCriticality ='3' ItemQuantity ='16' MarketNetamoun ='06.01' MarketGrossamount ='06.02' Amountcurr ='USD' MarketCount ='1' )
      ( ProdUuid ='FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF3' MrktUuid ='FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFA7'
          Mrktid ='4'  CountryName ='France'  ISOCode ='FR' Status ='X' StatusCriticality ='3' ItemQuantity ='17' MarketNetamoun ='07.01' MarketGrossamount ='07.02' Amountcurr ='USD' MarketCount ='1' )
      ( ProdUuid ='FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF3' MrktUuid ='FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFA8'
          Mrktid ='5'  CountryName ='Germany' ISOCode ='DE' Status ='X' StatusCriticality ='3' ItemQuantity ='18' MarketNetamoun ='08.01' MarketGrossamount ='08.02' Amountcurr ='USD' MarketCount ='1' )
      ( ProdUuid ='FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF3' MrktUuid ='FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFA9'
          Mrktid ='10' CountryName ='Spain'   ISOCode ='ES' Status ='X' StatusCriticality ='3' ItemQuantity ='19' MarketNetamoun ='09.01' MarketGrossamount ='09.02' Amountcurr ='USD' MarketCount ='1' )
      ( ProdUuid ='FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF4' MrktUuid ='FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFAA'
          Mrktid ='10' CountryName ='Spain'   ISOCode ='ES' Status ='X' StatusCriticality ='3' ItemQuantity ='20' MarketNetamoun ='10.01' MarketGrossamount ='10.02' Amountcurr ='USD' MarketCount ='1' )
      ( ProdUuid ='FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF4' MrktUuid ='FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFAB'
          Mrktid ='5'  CountryName ='Germany' ISOCode ='DE' Status ='X' StatusCriticality ='3' ItemQuantity ='21' MarketNetamoun ='11.01' MarketGrossamount ='11.02' Amountcurr ='USD' MarketCount ='1' )
                                    ).
    cds_test_environment->insert_test_data( i_data = lt_prod_market ).
    SELECT * FROM zpip_i_market INTO TABLE @DATA(act_markets). "#EC CI_ALL_FIELDS_NEEDED
    cl_abap_unit_assert=>assert_equals( msg = 'Markets insert error'
                                        act = act_markets       " Actual Value
                                        exp = lt_prod_market ). " Expected Value

* ---- Set test data for 'zpip_d_country'
    DATA: lt_countries  TYPE STANDARD TABLE OF zpip_d_country.
    lt_countries = VALUE #( client = sy-mandt
      ( mrktid ='1'  country ='Russia'         code ='RU' imageurl ='https://cdn.webshopapp.com/shops/94414/files/54940426/russia-flag-image-free-download.jpg'  )
      ( mrktid ='2'  country ='Belarus'        code ='RU' imageurl ='https://cdn.countryflags.com/thumbs/belarus/flag-400.png'  )
      ( mrktid ='3'  country ='United Kingdom' code ='EN' imageurl ='https://upload.wikimedia.org/wikipedia/commons/thumb/a/ae/Flag_of_the_United_Kingdom.svg/640px-Flag_of_the_United_Kingdom.svg.png'  )
      ( mrktid ='4'  country ='France'         code ='FR' imageurl ='https://cdn.webshopapp.com/shops/94414/files/54002660/france-flag-image-free-download.jpg'  )
      ( mrktid ='5'  country ='Germany'        code ='DE' imageurl ='https://cdn.webshopapp.com/shops/94414/files/54006402/germany-flag-image-free-download.jpg'  )
      ( mrktid ='6'  country ='Italy'          code ='IT' imageurl ='https://cdn.countryflags.com/thumbs/italy/flag-400.png'  )
      ( mrktid ='7'  country ='USA'            code ='EN' imageurl ='https://cdn.webshopapp.com/shops/94414/files/54958906/the-united-states-flag-image-free-download.jpg'  )
      ( mrktid ='8'  country ='Japan'          code ='EN' imageurl ='https://image.freepik.com/free-vector/illustration-japan-flag_53876-27128.jpg'  )
      ( mrktid ='9'  country ='Poland'         code ='EN' imageurl ='https://cdn.webshopapp.com/shops/94414/files/54940016/poland-flag-image-free-download.jpg'  )
      ( mrktid ='10' country ='Spain'          code ='ES' imageurl ='https://cdn.webshopapp.com/shops/94414/files/54940016/poland-flag-image-free-download.jpg'  )
    ).
    sql_test_environment->insert_test_data( i_data = lt_countries ).
    SELECT * FROM zpip_d_country INTO TABLE @DATA(act_countries). "#EC CI_ALL_FIELDS_NEEDED
    cl_abap_unit_assert=>assert_equals( msg = 'Countries insert error'
                                        act = act_countries     " Actual Value
                                        exp = lt_countries ).   " Expected Value

* ============ Checking class methods (!)
* == check whether test data field validation logic entity 'zpip_i_product':
* ----{ 1. FOR VALIDATE - validateProdGroup
    DO 1 TIMES.
      DATA: failed_valProdGrp   TYPE RESPONSE FOR FAILED   LATE zpip_i_product,
            reported_valProdGrp TYPE RESPONSE FOR REPORTED LATE zpip_i_product.

      cut->validateprodgroup( EXPORTING keys     = CORRESPONDING #( lt_products )
                              CHANGING  reported = reported_valProdGrp
                                        failed   = failed_valProdGrp ).
      cl_abap_unit_assert=>assert_not_initial( msg = 'failed'
                                               act = failed_valProdGrp ).
      cl_abap_unit_assert=>assert_equals( msg = 'failed-ProdUuid'
                                          act = failed_valProdGrp-product[ 1 ]-ProdUuid
                                          exp = 'FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0' ).
      cl_abap_unit_assert=>assert_equals( msg = 'failed-ProdUuid'
                                          act = failed_valProdGrp-product[ 2 ]-ProdUuid
                                          exp = 'FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF6' ).
    ENDDO.
* ----} 1. FOR VALIDATE - validateProdGroup



* ----{ 2.FOR VALIDATE - validateProdDupl
    DO 1 TIMES.
      DATA: failed_valProdDup   TYPE RESPONSE FOR FAILED   LATE zpip_i_product,
            reported_valProdDup TYPE RESPONSE FOR REPORTED LATE zpip_i_product.

      cut->validateProdDupl( EXPORTING keys     = CORRESPONDING #( lt_products )
                             CHANGING  reported = reported_valProdDup
                                       failed   = failed_valProdDup ).
* ---->> check: No Failed
      cl_abap_unit_assert=>assert_not_initial( msg = 'failed'
                                               act = failed_valProdDup ).
      cl_abap_unit_assert=>assert_equals( msg = 'failed-DuplicateLines'
                                          act = lines( failed_valProdDup-product )
                                          exp = lines( lt_products ) ).
    ENDDO.
* ----} 2.FOR VALIDATE - validateProdDupl


* ----{ 3.FOR MODIFY|ACTION - copyProduct (single row)
    DO 1 TIMES.
      DATA: lt_keys_cpyProd     TYPE TABLE    FOR ACTION   IMPORT zpip_i_product\\Product~copyProduct,
            result_cpyProd_line TYPE TABLE    FOR ACTION   RESULT zpip_i_product\\product~copyproduct,
            mapped_cpyProd      TYPE RESPONSE FOR MAPPED   EARLY  zpip_i_product,
            reported_cpyProd    TYPE RESPONSE FOR REPORTED EARLY  zpip_i_product,
            failed_cpyProd      TYPE RESPONSE FOR FAILED   EARLY  zpip_i_product.
      DATA: lt_cpyProd_line     LIKE lt_products.
*
*      lt_keys_cpyProd = VALUE #( FOR wa_SetFirstPhase IN lt_products WHERE ( Pgid = '001' )  ( CORRESPONDING #( wa_SetFirstPhase ) ) ). " v.1.0 mapping not supported for '%param'
      LOOP AT lt_products INTO DATA(wa_products)                                                             " v.2.0
                           WHERE Pgid = '004'.          " select prodId value to check from lt_prod_grp-pgid
        APPEND: wa_products  TO lt_cpyProd_line,
                INITIAL LINE TO lt_keys_cpyProd ASSIGNING FIELD-SYMBOL(<fs>).
        <fs>-ProdUuid      = wa_products-ProdUuid.
        <fs>-%param-prodid = wa_products-Prodid.
        EXIT.
      ENDLOOP.

      cut->copyProduct( EXPORTING keys     = lt_keys_cpyProd
                        CHANGING  reported = reported_cpyProd
                                  failed   = failed_cpyProd
                                  mapped   = mapped_cpyProd
                                  result   = result_cpyProd_line ).
* ---->> check: No Failed
      cl_abap_unit_assert=>assert_initial( msg = 'failed-CopyProd'
                                           act = failed_cpyProd ).
* ---->> check: correct Phase ID
      cl_abap_unit_assert=>assert_equals( msg = 'failed-CopyProd'
                                          act = 1                 " PhaseID for newly created entry
                                          exp = result_cpyProd_line[ 1 ]-%param-Phaseid ).
* ---->> check: get original prod.UUID
      TYPES: BEGIN OF ty_comp_cpy_prod,
               ProdUuid      TYPE zpip_i_product-ProdUuid,
               Prodid        TYPE zpip_i_product-Prodid,
*               Phaseid       TYPE zpip_i_product-Phaseid,
               Pgid          TYPE zpip_i_product-Pgid,
               Height        TYPE zpip_i_product-Height,
               Depth         TYPE zpip_i_product-Depth,
               Width         TYPE zpip_i_product-Width,
               SizeUom       TYPE zpip_i_product-SizeUom,
               Price         TYPE zpip_i_product-Price,
               PriceCurrency TYPE zpip_i_product-PriceCurrency,
               Taxrate       TYPE zpip_i_product-Taxrate,
*               ChangeTime    TYPE zpip_i_product-ChangeTime,
*               CreationTime  TYPE zpip_i_product-CreationTime,
               CreatedBy     TYPE zpip_i_product-CreatedBy,
               ChangedBy     TYPE zpip_i_product-ChangedBy,
             END OF ty_comp_cpy_prod.
      DATA(ls_act_cpy_prod) = CORRESPONDING ty_comp_cpy_prod( VALUE #( lt_cpyProd_line[ 1 ] ) ).
      DATA(ls_exp_cpy_prod) = CORRESPONDING ty_comp_cpy_prod( VALUE #( result_cpyProd_line[ 1 ]-%param ) EXCEPT produuid ).
      ls_exp_cpy_prod-produuid = result_cpyProd_line[ 1 ]-ProdUuid.
      cl_abap_unit_assert=>assert_equals( msg = 'failed-CopyProd'   " Copied fields are the same as original
                                          act = ls_act_cpy_prod
                                          exp = ls_exp_cpy_prod ).
    ENDDO.
* ----} 3.FOR MODIFY|ACTION - copyProduct (single row)


* ----{ 4.FOR DETERMINATION | SAVE - changePhase
    DATA:
      lt_keys_SetFirstPhase     TYPE TABLE    FOR DETERMINATION zpip_i_product\\product~setfirstphase,
      lt_reported_SetFirstPhase TYPE RESPONSE FOR REPORTED LATE zpip_i_product.

    DO 1 TIMES.
      DATA: lt_SetFirstPhase LIKE lt_products.
      lt_SetFirstPhase = VALUE #( FOR wa_SetFirstPhase IN lt_products WHERE ( Phaseid IS INITIAL ) ( wa_SetFirstPhase ) ).
      lt_keys_SetFirstPhase = CORRESPONDING #( lt_SetFirstPhase ).
      cut->SetFirstPhase( EXPORTING keys     = lt_keys_SetFirstPhase
                          CHANGING  reported = lt_reported_SetFirstPhase ).
      READ ENTITIES OF zpip_i_product IN LOCAL MODE
        ENTITY Product
          FIELDS ( Prodid ) WITH CORRESPONDING #( lt_keys_SetFirstPhase )
        RESULT DATA(lt_SetFirstPhase_saved).

      LOOP AT lt_keys_SetFirstPhase INTO DATA(wa_keys_SetFirstPhase).
        cl_abap_unit_assert=>assert_equals( msg = 'failed-SetFirstPhase'
                                            act = lt_SetFirstPhase_saved[ KEY entity ProdUuid = wa_keys_SetFirstPhase-ProdUuid ]-Phaseid
                                            exp = lhc_product=>phase_id-plan ).
      ENDLOOP.
    ENDDO.
* ----} 4.FOR DETERMINATION | SAVE - changePhase


* ----{ 5.FOR MODIFY|ACTION - changePhase
    DO 1 TIMES.
      DATA: lt_keys_chgPhases  TYPE TABLE    FOR ACTION IMPORT  zpip_i_product\\product~changephase,
            result_chgPhases   TYPE TABLE    FOR ACTION RESULT  zpip_i_product\\product~changephase,
            mapped_chgPhases   TYPE RESPONSE FOR MAPPED EARLY   zpip_i_product,
            failed_chgPhases   TYPE RESPONSE FOR FAILED EARLY   zpip_i_product,
            reported_chgPhases TYPE RESPONSE FOR REPORTED EARLY zpip_i_product.

* ---->> Consequently checking for each value of phaseId
      DO 7 TIMES.
        DATA: lv_chk_pid_ProdUuid TYPE sysuuid_x16.
        DATA(lv_phaseId) = sy-index.
        CLEAR: lt_keys_chgPhases.

        CASE lv_phaseId.
          WHEN 1.
            lv_chk_pid_ProdUuid = 'FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF1'. " phaseId = lhc_Product=>phase_id-plan (1)/ markets assigned
          WHEN 2.
            lv_chk_pid_ProdUuid = 'FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF2'. " phaseId = lhc_Product=>phase_id-dev  (2)/ markets assigned
          WHEN 3.
            lv_chk_pid_ProdUuid = 'FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF3'. " phaseId = lhc_Product=>phase_id-prod (3)/ markets assigned
          WHEN 4.
            lv_chk_pid_ProdUuid = 'FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF4'. " phaseId = lhc_Product=>phase_id-out  (4)/ markets assigned
          WHEN 5.
            lv_chk_pid_ProdUuid = 'FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF11'. " phaseId = lhc_Product=>phase_id-out  (1)/ NO markets assigned
          WHEN 6.
            lv_chk_pid_ProdUuid = 'FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF33'. " phaseId = lhc_Product=>phase_id-prod (3)/ NO markets assigned
          WHEN OTHERS.
            EXIT.
        ENDCASE.
        APPEND CORRESPONDING #( VALUE #( lt_products[ ProdUuid = lv_chk_pid_produuid ] ) ) TO lt_keys_chgPhases.
        cl_abap_unit_assert=>assert_not_initial( msg = 'failed-ChgPhase'
                                                 act = lt_keys_chgPhases ).
        CLEAR: reported_chgPhases, failed_chgPhases, mapped_chgPhases, result_chgPhases.
        cut->changePhase( EXPORTING keys     = lt_keys_chgPhases
                          CHANGING  reported = reported_chgPhases
                                    failed   = failed_chgPhases
                                    mapped   = mapped_chgPhases
                                    result   = result_chgPhases ).
        CASE lv_phaseId.
          WHEN 1.
            cl_abap_unit_assert=>assert_equals( msg = 'failed-changePhase_1'
                                                act = result_chgPhases[ 1 ]-%param-Phaseid
                                                exp = lhc_product=>phase_id-dev ).
          WHEN 2.
            cl_abap_unit_assert=>assert_equals( msg = 'failed-changePhase_2'
                                                act = result_chgPhases[ 1 ]-%param-Phaseid
                                                exp = lhc_product=>phase_id-prod ).
          WHEN 3.
            cl_abap_unit_assert=>assert_equals( msg = 'failed-changePhase_3'
                                                act = failed_chgPhases-product[ 1 ]-prodUuid
                                                exp = lt_keys_chgPhases[ 1 ]-prodUuid ).
          WHEN 4.
            cl_abap_unit_assert=>assert_equals( msg = 'failed-changePhase_4'
                                                act = failed_chgPhases-product[ 1 ]-prodUuid
                                                exp = lt_keys_chgPhases[ 1 ]-prodUuid ).
          WHEN 5.
            cl_abap_unit_assert=>assert_equals( msg = 'failed-changePhase_1_noMarkets'
                                                act = failed_chgPhases-product[ 1 ]-ProdUuid
                                                exp = lt_keys_chgPhases[ 1 ]-prodUuid ).
          WHEN 6.
            cl_abap_unit_assert=>assert_equals( msg = 'failed-changePhase_3_noMarkets'
                                                act = result_chgphases[ 1 ]-%param-Phaseid
                                                exp = lhc_product=>phase_id-out ).  " 4
          WHEN OTHERS.
            EXIT.
        ENDCASE.

      ENDDO.
    ENDDO.
* ----{ 5.FOR MODIFY|ACTION - changePhase


* ----{ 6.FOR MODIFY|ACTION - setProductTransl
    DO 1 TIMES.
      TYPES:
        BEGIN OF ty_pgNameTansl,
          ProdUuid    TYPE zpip_i_product-ProdUuid,
          TransCode   TYPE zpip_i_product-TransCode,
          PgnameTrans TYPE zpip_i_product-PgnameTrans,
        END   OF ty_pgNameTansl,
        tt_pgNameTansl TYPE STANDARD TABLE OF ty_pgnametansl WITH KEY  primary_key  COMPONENTS ProdUuid TransCode
                                                             WITH NON-UNIQUE SORTED KEY  trCode   COMPONENTS  TransCode.

      DATA(lt_exp_PgNameTransl) = VALUE tt_pgNameTansl(
        ( ProdUuid     = 'FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF2' TransCode = 'DE'  "Coffee Machine
          PgnameTrans = 'Kaffeemaschine' )
        ( ProdUuid     = 'FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF3' TransCode = 'RU'  " Waffle Iron
          PgnameTrans = 'Вафельница'     )
        ( ProdUuid     = 'FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF4' TransCode = 'IT'  " Blender'
          PgnameTrans = 'Frullatore'     )
                        ).
      DATA:
        lt_keys_set_prodTransl TYPE TABLE    FOR DETERMINATION  zpip_i_product\\product~setpgnametranslation.
      DATA: lt_chk_prodTransl       LIKE lt_products.

* --->> Affected fields: zpip_i_product (InpField: Pgname, TransCod; OutFields: PgnameTrans )
* translation from EN to available language from the table LT_COUNTRIES
      DO 3 TIMES.
        DATA(li_step_prodTransl) = sy-index.
        CASE li_step_prodTransl.
          WHEN 1.
            DATA(lv_target_lang) = 'DE'.
          WHEN 2.
            lv_target_lang = 'RU'.
          WHEN 3.
            lv_target_lang = 'IT'.
          WHEN OTHERS.
            EXIT.
        ENDCASE.

        TRY.
            DATA(ls_exp_translate) = lt_exp_PgNameTransl[ KEY trCode: TransCode = lv_target_lang ].
            DATA(ls_chk_product)   = lt_products[ ProdUuid = ls_exp_translate-produuid ].
          CATCH cx_sy_itab_line_not_found.
            CONTINUE.
        ENDTRY.

        lt_chk_prodTransl      = VALUE  #( ( ls_chk_product ) ).
        lt_keys_set_prodTransl = CORRESPONDING #( lt_chk_prodTransl ).

* ------ check SetPgNameTranslation
        DO 1 TIMES.
          DATA: reported_set_prodTransl TYPE RESPONSE FOR REPORTED LATE zpip_i_product.

          cut->setPgNameTranslation( EXPORTING keys     = lt_keys_set_prodTransl
                                     CHANGING  reported = reported_set_prodTransl ).
          READ ENTITIES OF zpip_i_product IN LOCAL MODE
                ENTITY Product
                  FIELDS ( Pgname
                           TransCode
                           PgnameTrans ) WITH CORRESPONDING #( lt_keys_set_prodTransl )
            RESULT DATA(ls_act_PgNameTransl).                           .
          cl_abap_unit_assert=>assert_subrc(  msg = 'failed-ProdTransl'
                                              act = sy-subrc
                                              exp = 0 ).
          cl_abap_unit_assert=>assert_equals( msg = 'failed-ProdTransl'
                                              act = ls_act_PgNameTransl[ 1 ]-PgnameTrans
                                              exp = ls_exp_translate-PgnameTrans ).
        ENDDO.

      ENDDO.
    ENDDO.
* ----} 6.FOR MODIFY|ACTION - setProductTransl


* ----{ 7.FOR MODIFY|ACTION - getProductTransl
    DATA:
      lt_result_get_prodTransl   TYPE TABLE    FOR ACTION RESULT  zpip_i_product\\product~getproducttransl,
      lt_mapped_get_prodTransl   TYPE RESPONSE FOR MAPPED EARLY   zpip_i_product,
      lt_failed_get_prodTransl   TYPE RESPONSE FOR FAILED EARLY   zpip_i_product,
      lt_reported_get_prodTransl TYPE RESPONSE FOR REPORTED EARLY zpip_i_product.
    DATA: lt_get_prodTrans_line  LIKE lt_products.

    DO 1 TIMES.
      lt_get_prodTrans_line = VALUE #( FOR wa IN lt_products WHERE ( ProdUuid = 'FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF2') ( wa ) ).
      cl_abap_unit_assert=>assert_equals( msg = 'failed-getProdTransl'
                                          act = lines( lt_get_prodTrans_line )
                                          exp = 1 ).

      cut->getProductTransl( EXPORTING keys     = CORRESPONDING #( lt_get_prodTrans_line )
                             CHANGING  reported = lt_reported_get_prodTransl
                                       failed   = lt_failed_get_prodTransl
                                       mapped   = lt_mapped_get_prodTransl
                                       result   = lt_result_get_prodTransl ).
* ----- contains number of lines with all available _nguages defined in LT_COUNTRIES
      LOOP AT lt_reported_get_prodTransl-product INTO DATA(wa_reported_get_prodTransl).
        DATA(lr_msg_tmp) = CAST zcx_pip_product( wa_reported_get_prodTransl-%msg ).
        CASE lr_msg_tmp->lang.
          WHEN 'ES'.
            DATA(lv_exp_text_trans) = `Cafetera`.
          WHEN 'FR'.
            lv_exp_text_trans = 'Cafetière'.
          WHEN 'IT'.
            lv_exp_text_trans = 'Macchinetta'.
          WHEN 'RU'.
            lv_exp_text_trans = 'Кофеварка'.
          WHEN OTHERS.
            lv_exp_text_trans = space.
        ENDCASE.

        cl_abap_unit_assert=>assert_equals( msg = 'failed-getProdTransl'
                                            act = lr_msg_tmp->text_trans
                                            exp = lv_exp_text_trans ).
      ENDLOOP.
    ENDDO.
* ----} 7.FOR MODIFY|ACTION - getProductTransl

* ----{ 8.FOR INSTANCE FEATURE - ## Dummy ##
    DATA:
*      lt_keys_get_instFeature     TYPE TABLE FOR INSTANCE FEATURES KEY zpip_i_product\\product,
      ls_keys_get_instFeature_req TYPE STRUCTURE FOR INSTANCE FEATURES REQUEST zpip_i_product\\product,
      lt_result_get_instFeature   TYPE TABLE     FOR INSTANCE FEATURES RESULT  zpip_i_product\\product,
      lt_failed_get_instFeature   TYPE RESPONSE  FOR FAILED EARLY              zpip_i_product,
      lt_reported_get_instFeature TYPE RESPONSE  FOR REPORTED EARLY            zpip_i_product.

    cut->get_instance_features( EXPORTING keys              = CORRESPONDING #( lt_products )
                                         requested_features = ls_keys_get_instFeature_req
                                CHANGING result             = lt_result_get_instFeature
                                         failed             = lt_failed_get_instFeature
                                         reported           = lt_reported_get_instFeature ).
* ----} 8.FOR INSTANCE FEATURE - ## Dummy ##
  ENDMETHOD.

ENDCLASS.
