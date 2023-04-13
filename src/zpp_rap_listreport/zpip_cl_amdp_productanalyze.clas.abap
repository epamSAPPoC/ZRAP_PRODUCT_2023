CLASS zpip_cl_amdp_productanalyze DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_amdp_marker_hdb .
    CLASS-METHODS get_product_analyze FOR TABLE FUNCTION zpip_tf_product_analyze.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZPIP_CL_AMDP_PRODUCTANALYZE IMPLEMENTATION.


  METHOD get_product_analyze
    BY DATABASE FUNCTION FOR HDB
        LANGUAGE SQLSCRIPT
        USING zpip_i_product_analyze.

    RETURN
      select :p_client                        AS client,
             ProdUuid,
             Prodid,
             Pgname,
             SUM( MarketsQuantity )           AS MarketsQuantity,
             STRING_AGG(
                         MarketName,
                         '; '
                         ORDER BY MarketName
                       )                      AS Countries,
             SUM( OrderQuantity )             AS OrderQuantity,
             SUM( Netamount )                 AS Netamount,
             SUM( Grossamount )               AS Grossamount,
             Amountcurr                       AS Amountcurr
        FROM zpip_i_product_analyze
        GROUP BY
          ProdUuid,
          Prodid,
          Pgname,
          Amountcurr
        ;

  ENDMETHOD.
ENDCLASS.
