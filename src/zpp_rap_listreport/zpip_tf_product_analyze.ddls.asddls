@EndUserText.label: 'Table function for product analyze'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@ClientHandling.algorithm: #SESSION_VARIABLE
@ClientHandling.type: #CLIENT_DEPENDENT

define table function zpip_tf_product_analyze
  with parameters 
    @Environment.systemField: #CLIENT
    p_client : mandt
returns
{
  client          : abap.clnt;
  ProdUuid        : sysuuid_x16;
  ProdId          : zpip_product_id;
  Pgname          : zpip_pg_name;
  MarketsQuantity : abap.int4;
  Countries       : abap.char(1000);
  OrderQuantity   : abap.int4;
  Netamount       : zpip_netamount;
  Grossamount     : zpip_grossamount;
  Amountcurr      : waers_curc;
}
implemented by method
  zpip_cl_amdp_productanalyze=>get_product_analyze;