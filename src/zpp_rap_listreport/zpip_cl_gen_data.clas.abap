CLASS zpip_cl_gen_data DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
    METHODS:
      get_uuid
        RETURNING VALUE(rx_uuid) TYPE sysuuid_x16,
      get_prod_group,
      get_phase,
      get_uom,
      get_country,
      get_taxes,
      get_user,
      set_oreders,
      del_orders.
ENDCLASS.



CLASS ZPIP_CL_GEN_DATA IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.
*    GET_COUNTRY( ).
*    GET_PHASE( ).
*    GET_PROD_GROUP( ).
*    GET_UOM( ).
*    GET_TAXES( ).
*    GET_USER( ).
*    SET_OREDERS( ).
*    del_orders(  ).
  ENDMETHOD.


  METHOD GET_COUNTRY.
    DELETE FROM zpip_d_country.

    INSERT zpip_d_country FROM TABLE @(
      value #(
        ( mrktid  ='1'  country = 'Russia'          code = 'RU' imageurl = 'https://cdn.webshopapp.com/shops/94414/files/54940426/russia-flag-image-free-download.jpg' )
        ( mrktid  ='2'  country = 'Belarus'         code = 'RU' imageurl = 'https://cdn.countryflags.com/thumbs/belarus/flag-400.png' )
        ( mrktid  ='3'  country = 'United Kingdom'  code = 'EN' imageurl = 'https://upload.wikimedia.org/wikipedia/commons/thumb/a/ae/Flag_of_the_United_Kingdom.svg/640px-Flag_of_the_United_Kingdom.svg.png' )
        ( mrktid  ='4'  country = 'France'          code = 'FR' imageurl = 'https://cdn.webshopapp.com/shops/94414/files/54002660/france-flag-image-free-download.jpg' )
        ( mrktid  ='5'  country = 'Germany'         code = 'DE' imageurl = 'https://cdn.webshopapp.com/shops/94414/files/54006402/germany-flag-image-free-download.jpg' )
        ( mrktid  ='6'  country = 'Italy'           code = 'IT' imageurl = 'https://cdn.countryflags.com/thumbs/italy/flag-400.png' )
        ( mrktid  ='7'  country = 'USA'             code = 'EN' imageurl = 'https://cdn.webshopapp.com/shops/94414/files/54958906/the-united-states-flag-image-free-download.jpg' )
        ( mrktid  ='8'  country = 'Japan'           code = 'EN' imageurl = 'https://image.freepik.com/free-vector/illustration-japan-flag_53876-27128.jpg' )
        ( mrktid  ='9'  country = 'Poland'          code = 'EN' imageurl = 'https://cdn.webshopapp.com/shops/94414/files/54940016/poland-flag-image-free-download.jpg' )
        ( mrktid  ='10' country = 'Spain'           code = 'ES' imageurl = 'https://cdn.webshopapp.com/shops/94414/files/54940016/poland-flag-image-free-download.jpg' )
      )
    ).
  ENDMETHOD.


  METHOD GET_PHASE.
    DELETE FROM zpip_d_phase.

    INSERT zpip_d_phase FROM TABLE @(
      VALUE #(
        ( phaseid  = '1' phase = 'PLAN' )
        ( phaseid  = '2' phase = 'DEV'  )
        ( phaseid  = '3' phase = 'PROD' )
        ( phaseid  = '4' phase = 'OUT'  )
      )
    ).
  ENDMETHOD.


  METHOD GET_PROD_GROUP.
    DELETE FROM zpip_d_prod_grp.

    INSERT zpip_d_prod_grp FROM TABLE @(
      VALUE #(
          ( pgid  = '1' pgname = 'Microwave'      imageurl = 'https://assets.dryicons.com/uploads/icon/svg/6676/ce9bd43b-e390-4a79-a216-47f5c9bb1c8c.svg' )
          ( pgid  = '2' pgname = 'Coffee Machine' imageurl = 'https://assets.dryicons.com/uploads/icon/svg/6655/49bdf99f-1bdd-4cca-8480-182aabab75a5.svg' )
          ( pgid  = '3' pgname = 'Waffle Iron'    imageurl = 'https://assets.dryicons.com/uploads/icon/svg/6691/6459344e-ec66-4aa6-ac86-c4c868c7075d.svg' )
          ( pgid  = '4' pgname = 'Blender'        imageurl = 'https://cdn0.iconfinder.com/data/icons/coffee-brewing-glyph/16/5-512.png' )
          ( pgid  = '5' pgname = 'Cooker'         imageurl = 'https://assets.dryicons.com/uploads/icon/svg/6691/6459344e-ec66-4aa6-ac86-c4c868c7075d.svg')
      )
    ).
  ENDMETHOD.


  METHOD GET_UOM.
    DELETE FROM zpip_d_uom.

    INSERT zpip_d_uom FROM TABLE @(
      VALUE #(
        ( msehi = 'CM'  dimid = 'LENGTH' isocode = 'CMT')
        ( msehi = 'DM'  dimid = 'LENGTH' isocode = 'DMT')
        ( msehi = 'FT'  dimid = 'LENGTH' isocode = 'FOT')
        ( msehi = 'IN'  dimid = 'LENGTH' isocode = 'INH')
        ( msehi = 'KM'  dimid = 'LENGTH' isocode = 'KMT')
        ( msehi = 'M'   dimid = 'LENGTH' isocode = 'MTR')
        ( msehi = 'MI'  dimid = 'LENGTH' isocode = 'SMI')
        ( msehi = 'MIM' dimid = 'LENGTH' isocode = '4H' )
        ( msehi = 'MM'  dimid = 'LENGTH' isocode = 'MMT')
        ( msehi = 'NAM' dimid = 'LENGTH' isocode = 'C45')
        ( msehi = 'YD'  dimid = 'LENGTH' isocode = 'YRD')
      )
    ).
  ENDMETHOD.


  METHOD GET_TAXES.
    DELETE FROM zpip_d_tax.

    INSERT zpip_d_tax FROM TABLE @(
      VALUE #(
        ( tax_id = 'VAT' tax_rate = '20.00' isocode = '%' )
        ( tax_id = 'VAT' tax_rate = '18.00' isocode = '%' )
        ( tax_id = 'VAT' tax_rate = '10.00' isocode = '%' )
        ( tax_id = 'VAT' tax_rate = '0.00'  isocode = '%' )
      )
    ).
  ENDMETHOD.


  METHOD GET_USER.
    DELETE FROM zpip_d_user.

    INSERT zpip_d_user FROM TABLE @(
      VALUE #(
        ( id            = 'CB9980001989'
          name          = 'Roland Deichgraeber'
          phone         = '+29 7670024'
          building      = 'Victoria Center - Batiment A3'
          country       = 'FR'
          street        = '20 Chemin de Laporte'
          city          = 'Toulouse'
          postcode      = '31300'
          address_label = 'Victoria Center - Batiment A3 20 Chemin de Laporte 31300 Toulouse FR'
          photo_url     = 'https://icons.iconarchive.com/icons/rokey/the-blacy/128/unhappy-icon.png'
          email         = 'Roland.Deichgraeber@mail.example' )

        ( id            = 'CB9980001414'
          name          = 'Mathilde Benz'
          phone         = '+32 93195326'
          building      = 'Edificio Torre Diagonal Mar.'
          country       = 'ES'
          street        = 'Josep Pla, no 2. Planta 13'
          city          = 'Barcelona'
          postcode      = '08019'
          address_label = 'Edificio Torre Diagonal Mar. Josep Pla, no 2. Planta 13 08019 Barcelona ES'
          photo_url     = 'https://icons.iconarchive.com/icons/rokey/the-blacy/128/scorn-icon.png'
          email         = 'Mathilde.Benz@mail.example' )

        ( id            = 'CB9980003307'
          name          = 'Hendrik Marshall'
          phone         = '+96 56238802'
          building      = '5th Floor G-Block'
          country       = 'IN'
          street        = 'C-59 BKC Bandra East'
          city          = 'Mumbai'
          postcode      = '400051'
          address_label = '5th Floor G-Block C-59 BKC Bandra East 400 051 Mumbai IN'
          photo_url     = 'https://icons.iconarchive.com/icons/picol/picol/72/Avatar-icon.png'
          email         = 'Hendrik.Marshall@mail.example' )
      )
    ).
  ENDMETHOD.


  METHOD GET_UUID.
      TRY.
          DATA(lv_id) =  cl_system_uuid=>if_system_uuid_static~create_uuid_x16( ).
        CATCH cx_uuid_error .

      ENDTRY.

      SELECT FROM zpip_d_mrkt_ordr
        FIELDS order_uuid
        INTO TABLE @DATA(lt_orders).

      IF NOT line_exists( lt_orders[ order_uuid = lv_id ] ).
        rx_uuid = lv_id.
      ELSE.
        RETURN.
      ENDIF.

  ENDMETHOD.


  METHOD SET_OREDERS.

    DATA: lv_createion_time   TYPE timestampl,
          lv_date             TYPE zpip_delivery_date,
          lv_order_id         TYPE zpip_order_id,
          lv_low              TYPE i,
          lv_high             TYPE i,
          lv_random_quan      TYPE i,
          _mo_rnd_seed_quan   TYPE REF TO cl_abap_random,
          lv_rnd_seed_quan    TYPE i,
          lv_prod_uuid        TYPE sysuuid_x16,
          lv_mrkt_uuid        TYPE sysuuid_x16,
          lv_netamount        TYPE p LENGTH 15 DECIMALS 2,
          lv_grossamount      TYPE p LENGTH 15 DECIMALS 2,
          lv_calendar_year    TYPE zpip_year,
          lv_amountcurr       TYPE waers_curc,
          lv_busspartner      TYPE zpip_business_partner,
          lv_busspartnername  TYPE zpip_business_partner_name,
          lv_busspartnergroup TYPE zpip_business_partner_group.

    GET TIME STAMP FIELD lv_createion_time.
    DATA(lv_user)  = sy-uname.
    DATA(lv_today) = sy-datum.
    lv_date = lv_today.


****************->
    lv_order_id = 3."!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    lv_prod_uuid = '86272E52B1EF1EEDA7C5764AA2F1AD7D'."!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    lv_mrkt_uuid = '72AD846C0C401EEDB095918FA5C24F14'."!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    lv_low = 5.
    lv_high = 11.
    lv_calendar_year = '2023'.
    lv_amountcurr    = 'USD'."!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    lv_busspartner   = '10100050'.
    lv_busspartnername = 'Susan Miller'.
    lv_busspartnergroup = 'BP03'.

****************->

    SELECT SINGLE FROM zpip_d_product
      FIELDS price
        WHERE prod_uuid = @lv_prod_uuid
      INTO @DATA(lv_price).

    lv_rnd_seed_quan = frac( lv_createion_time ) * 10000000.
    _mo_rnd_seed_quan = cl_abap_random=>create( lv_rnd_seed_quan ).
    DATA(lo_rand_quan) = cl_abap_random=>create( _mo_rnd_seed_quan->int( ) ).

    DO 120 TIMES.

      lv_random_quan = lo_rand_quan->intinrange( low  = lv_low
                                                 high = lv_high ).
      lv_random_quan = lv_random_quan * 100.

      lv_grossamount = lv_random_quan * lv_price.
      lv_netamount = lv_random_quan * lv_price * '0.91'.
      lv_order_id = lv_order_id + 1.
      lv_date     = lv_date + 1.

      INSERT zpip_d_mrkt_ordr FROM TABLE @(
        VALUE #(
          (
           prod_uuid        = lv_prod_uuid
           mrkt_uuid        = lv_mrkt_uuid
           order_uuid       = get_uuid( )
           orderid          = lv_order_id
           quantity         = lv_random_quan
           calendar_year    = lv_calendar_year
           delivery_date    = lv_date
           netamount        = lv_netamount
           grossamount      = lv_grossamount
           amountcurr       = lv_amountcurr
           busspartner      = lv_busspartner
           busspartnername  = lv_busspartnername
           busspartnergroup = lv_busspartnergroup
           created_by       = lv_user
           creation_time    = lv_createion_time
           changed_by       = lv_user
           change_time      = lv_createion_time
          )
        )
      ).

    ENDDO.


*    UPDATE:
*      zpip_d_mrkt_ordr
*        SET orderid = '39'
*          WHERE prod_uuid   = '72AD846C0C401EEDB094EC973B4D0D6E' AND
*                mrkt_uuid   = 'C6EF623455A21EEDB0B5334BBC578444' AND
*                order_uuid  = '72AD846C0C401EDDB0B7135774FC2CDF',
*      zpip_d_mrkt_ordr
*        SET orderid = '40'
*          WHERE prod_uuid   = '72AD846C0C401EEDB094EC973B4D0D6E' AND
*                mrkt_uuid   = 'C6EF623455A21EEDB0B5334BBC578444' AND
*                order_uuid  = '72AD846C0C401EDDB0B7135774FC4CDF',
*      zpip_d_mrkt_ordr
*        SET orderid = '41'
*          WHERE prod_uuid   = '72AD846C0C401EEDB094EC973B4D0D6E' AND
*                mrkt_uuid   = 'C6EF623455A21EEDB0B5334BBC578444' AND
*                order_uuid  = '72AD846C0C401EDDB0B7135774FC6CDF'
*                .
*
*     DELETE FROM  zpip_d_mrkt_ordr
*       WHERE mrkt_uuid   = 'C6EF623455A21EDDB0966C4C343C4C82'.


  ENDMETHOD.

  METHOD del_orders.
    DELETE FROM  zpip_d_mrkt_ordr
      WHERE prod_uuid   = 'C6EF623455A21EDDB0964E1E072CCC60' AND
            mrkt_uuid   = '72AD846C0C401EEDB09661456F095113' AND
            order_uuid  = '76229B85365C1EEDB884015E54328913'.
  ENDMETHOD.

ENDCLASS.
