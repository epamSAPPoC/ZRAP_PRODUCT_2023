class ZPIP_CL_CALL_ODATA_SCM definition
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES: if_oo_adt_classrun,
                if_rap_query_provider.

    TYPES: t_business_partner_range TYPE RANGE OF ZZPIP_A_BUSINESSPARTNER-BusinessPartner,
           t_business_data          TYPE TABLE OF ZZPIP_A_BUSINESSPARTNER.

    METHODS get_business_partners
      IMPORTING
        filter_cond        TYPE if_rap_query_filter=>tt_name_range_pairs   OPTIONAL
        top                TYPE i OPTIONAL
        skip               TYPE i OPTIONAL
        is_data_requested  TYPE abap_bool
        is_count_requested TYPE abap_bool
      EXPORTING
        business_data      TYPE t_business_data
        count              TYPE int8
      RAISING
        /iwbep/cx_cp_remote
        /iwbep/cx_gateway
        cx_web_http_client_error
        cx_http_dest_provider_error.

ENDCLASS.



CLASS ZPIP_CL_CALL_ODATA_SCM IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

    DATA: business_data      TYPE t_business_data,
          count_of_entries   TYPE int8,
          filter_conditions  TYPE if_rap_query_filter=>tt_name_range_pairs,
          ranges_table       TYPE if_rap_query_filter=>tt_range_option .

    ranges_table      = VALUE #( ( sign = 'I' option = 'GE' low = '0000000000' ) ).
    filter_conditions = VALUE #( ( name = 'BUSINESSPARTNER'  range = ranges_table ) ).

    TRY.
      get_business_partners(
        EXPORTING
          filter_cond        = filter_conditions
          top                = 50
          skip               = 0
          is_count_requested = abap_true
          is_data_requested  = abap_true
        IMPORTING
          business_data  = business_data
          count          = count_of_entries
        ) .
      out->write( |Total number of records = { count_of_entries }| ) .
      out->write( business_data ).
    CATCH cx_root INTO DATA(exception).
      out->write( cl_message_helper=>get_latest_t100_exception( exception )->if_message~get_longtext( ) ).
    ENDTRY.
  ENDMETHOD.


  METHOD if_rap_query_provider~select.

    DATA: business_data TYPE t_business_data,
          count         TYPE int8.

    DATA(top)              = io_request->get_paging( )->get_page_size( ).
    DATA(skip)             = io_request->get_paging( )->get_offset( ).
    DATA(requested_fields) = io_request->get_requested_elements( ).
    DATA(sort_order)       = io_request->get_sort_elements( ).

    TRY.
      DATA(filter_condition) = io_request->get_filter( )->get_as_ranges( ).

      get_business_partners(
        EXPORTING
          filter_cond        = filter_condition
          top                = CONV i( top )
          skip               = CONV i( skip )
          is_data_requested  = io_request->is_data_requested( )
          is_count_requested = io_request->is_total_numb_of_rec_requested(  )
        IMPORTING
          business_data = business_data
          count         = count
        ) .

      IF io_request->is_total_numb_of_rec_requested(  ).
        io_response->set_total_number_of_records( count ).
      ENDIF.
      IF io_request->is_data_requested(  ).
        io_response->set_data( business_data ).
      ENDIF.

    CATCH cx_root INTO DATA(exception).
      DATA(exception_message) = cl_message_helper=>get_latest_t100_exception( exception )->if_message~get_longtext( ).
    ENDTRY.

  ENDMETHOD.


  METHOD get_business_partners.

    DATA: filter_factory     TYPE REF TO /iwbep/if_cp_filter_factory,
          filter_node        TYPE REF TO /iwbep/if_cp_filter_node,
          root_filter_node   TYPE REF TO /iwbep/if_cp_filter_node,

          http_client        TYPE REF TO if_web_http_client,
          odata_client_proxy TYPE REF TO /iwbep/if_cp_client_proxy,
          read_list_request  TYPE REF TO /iwbep/if_cp_request_read_list,
          read_list_response TYPE REF TO /iwbep/if_cp_response_read_lst,

          service_consumption_name TYPE cl_web_odata_client_factory=>ty_service_definition_name.

    DATA(http_destination) = cl_http_destination_provider=>create_by_url( i_url = 'https://my303843.s4hana.ondemand.com' ).

    http_client = cl_web_http_client_manager=>create_by_http_destination( i_destination = http_destination ).

    http_client->get_http_request( )->set_authorization_basic(
                                                               i_username = 'POSTMAN_USER'
                                                               i_password = 'bLaPPuUkMMmDJGzgklwHQQqfJLlAPSi[5ekDKgxL'
                                                             ).

    service_consumption_name = to_upper( 'ZPIP_SCM_BP' ).

    odata_client_proxy = cl_web_odata_client_factory=>create_v2_remote_proxy(
                                                        EXPORTING
                                                          iv_service_definition_name = service_consumption_name
                                                          io_http_client             = http_client
                                                          iv_relative_service_root   = '/sap/opu/odata/sap/API_BUSINESS_PARTNER'
                                                      ).

    read_list_request = odata_client_proxy->create_resource_for_entity_set( 'A_BUSINESSPARTNER' )->create_request_for_read( ).

    filter_factory = read_list_request->create_filter_factory( ).

    LOOP AT  filter_cond  INTO DATA(filter_condition).
      filter_node  = filter_factory->create_by_range( iv_property_path = filter_condition-name
                                                      it_range         = filter_condition-range ).
      IF root_filter_node IS INITIAL.
        root_filter_node = filter_node.
      ELSE.
        root_filter_node = root_filter_node->and( filter_node ).
      ENDIF.
    ENDLOOP.

    IF root_filter_node IS NOT INITIAL.
      read_list_request->set_filter( root_filter_node ).
    ENDIF.

    IF is_data_requested = abap_true.
      read_list_request->set_skip( skip ).
      IF top > 0 .
        read_list_request->set_top( top ).
      ENDIF.
    ENDIF.

    IF is_count_requested = abap_true.
      read_list_request->request_count(  ).
    ENDIF.

    IF is_data_requested = abap_false.
      read_list_request->request_no_business_data(  ).
    ENDIF.

    read_list_response = read_list_request->execute( ).
    IF is_data_requested = abap_true.
      read_list_response->get_business_data( IMPORTING et_business_data = business_data ).
    ENDIF.
    IF is_count_requested = abap_true.
      count = read_list_response->get_count(  ).
    ENDIF.
  ENDMETHOD.
ENDCLASS.
